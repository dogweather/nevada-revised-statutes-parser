{-# LANGUAGE OverloadedStrings #-}

module NvStatutes where

import           Data.Function     ((&))
import           Data.List.Split   (chunksOf, split, whenElt)
import           Data.Text         (Text, splitOn, strip, unpack)
import           Text.HTML.TagSoup (Tag, innerText, parseTags, partitions,
                                    (~==))

import           Models


titles :: Text -> [Title]
titles indexHtml =
  let rows   = contentRows indexHtml
      tuples = rowTuples rows
  in fmap newTitle tuples


contentRows :: Text -> [[Tag Text]]
contentRows indexHtml =
  let tags       = parseTags indexHtml
      table      = head $ partitions (~== ("<table class=MsoNormalTable"::String)) tags
  in partitions (~== ("<tr>"::String)) table


newTitle :: [[[Tag Text]]] -> Title
newTitle tuple =
  let titleRow  = head (head tuple)
      rawTitle  = innerText $ head $ partitions (~== ("<b>"::String)) titleRow
      name      = nameFromRawTitle rawTitle
      number    = numberFromRawTitle rawTitle
  in Title { titleName = name, titleNumber = number, chapters = [] }


-- Input:  "TITLE\n  1 \8212 STATE JUDICIAL DEPARTMENT\n  \n \n "
-- Output: "STATE JUDICIAL DEPARTMENT"
nameFromRawTitle :: Text -> Text
nameFromRawTitle text =
  splitOn "\8212" text
    & tail
    & head
    & strip


-- Input:  "TITLE\n  1 \8212 STATE JUDICIAL DEPARTMENT\n  \n \n "
-- Output: 1
numberFromRawTitle :: Text -> Int
numberFromRawTitle text =
  let numberText = numberTextFromRawTitle text
  in read $ unpack numberText :: Int


-- Input:  "TITLE\n  1 \8212 STATE JUDICIAL DEPARTMENT\n  \n \n "
-- Output: "1"
numberTextFromRawTitle :: Text -> Text
numberTextFromRawTitle text =
  splitOn "\8212" text
    & head
    & strip
    & splitOn "\n"
    & tail
    & head


rowTuples :: [[Tag Text]] -> [[[[Tag Text]]]]
rowTuples rows =
  split (whenElt isTitleRow) rows
    & tail
    & chunksOf 2


isTitleRow :: [Tag Text] -> Bool
isTitleRow r =
  length (partitions (~== ("<td>"::String)) r) == 1


newChapter :: [Tag Text] -> Chapter
newChapter row =
  Chapter {chapterName="", chapterNumber="", url=""}
