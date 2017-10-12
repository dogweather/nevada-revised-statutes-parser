{-# LANGUAGE OverloadedStrings #-}

module IndexFile where

import           BasicPrelude            hiding (takeWhile)
import           Data.Attoparsec.Text    (parseOnly)
import           Data.Function           ((&))
import           Data.List.Split         (chunksOf, split, whenElt)
import qualified Data.Text               as T
import           Text.HTML.TagSoup       (Tag, fromAttrib, innerText, parseTags)
import           Text.Parser.Char
import           Text.Parser.Combinators
import           Text.Parser.Token

import           HtmlUtil                (findAll, findFirst)
import           Models.Chapter          as Chapter
import           Models.Title            as Title
import           TextUtil                (titleize)


type Html = Text
type Node = [Tag Text]


parseTitles :: Html → [Title]
parseTitles indexHtml =
    let rows = contentRows indexHtml
        tuples = rowTuples rows
    in fmap newTitle tuples


contentRows :: Html → [Node]
contentRows indexHtml =
    let tags  = parseTags indexHtml
        table = findFirst "<table class=MsoNormalTable" tags
    in findAll "<tr>" table


newTitle :: [[Node]] -> Title
newTitle tuple =
    let titleRow       = head (head tuple)
        chapterRows    = head $ tail tuple
        parsedChapters = fmap newChapter chapterRows
        title          = innerText $ findFirst "<b>" titleRow
        (rawNumber, rawName) = parseRawTitle title
    in Title { Title.name = titleize rawName, Title.number = rawNumber, chapters = parsedChapters }


newChapter :: Node → Chapter
newChapter row =
    Chapter {
        Chapter.name   = last columns & innerText & T.strip,
        Chapter.number = head columns & innerText & T.strip & words & last,
        url    = findFirst "<a>" row & head & fromAttrib "href",
        subChapters   = []
    }
    where columns = findAll "<td>" row


-- Input:  "TITLE\n  1 — STATE JUDICIAL DEPARTMENT\n  \n \n "
-- Output: (1, "STATE JUDICIAL DEPARTMENT")
parseRawTitle :: Text -> (Integer, Text)
parseRawTitle input =
    let f = parseOnly p input
        p = (,) <$>
            (textSymbol "TITLE" *> integer) <*>
            (textSymbol "—" *> (fromString <$> many (notChar '\n')))
    in case f of
        Left e  -> error e
        Right b -> b


rowTuples :: [Node] → [[[Node]]]
rowTuples rows =
    split (whenElt isTitleRow) rows
        & tail
        & chunksOf 2


isTitleRow :: Node → Bool
isTitleRow html =
    length (findAll "<td>" html) == 1
