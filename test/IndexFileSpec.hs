module IndexFileSpec where

import           BasicPrelude
import           Test.Hspec

import           FileUtil                       ( fixture )
import           HtmlUtil
import           IndexFile                      ( parseTitles )
import           Models.Chapter                as Chapter
import           Models.Title                  as Title


spec :: SpecWith ()
spec = parallel $ describe "parseTitles" $ do

  it "finds the correct number of titles" $ do
    html <- nrsIndexHtml
    length (parseTitles html) `shouldBe` 59


  it "gets a title's name" $ do
    judicialDept <- firstTitle
    Title.name judicialDept `shouldBe` "State Judicial Department"


  it "gets a title's name" $ do
    t <- title17
    Title.name t `shouldBe` "State Legislative Department"


  it "gets a title's number" $ do
    judicialDept <- firstTitle
    Title.number judicialDept `shouldBe` 1


  it "reads a chapter correctly" $ do
    judicialDept <- firstTitle
    length (chapters judicialDept) `shouldNotBe` 0
    let chapter1 = head $ chapters judicialDept

    Chapter.name chapter1 `shouldBe` "Judicial Department Generally"
    Chapter.number chapter1 `shouldBe` "1"
    Chapter.url chapter1
      `shouldBe` "https://www.leg.state.nv.us/nrs/NRS-001.html"


  it "gets one that is further in" $ do
    publicWelfare <- title38
    Title.name publicWelfare `shouldBe` "Public Welfare"

    let chapter432b = last $ chapters publicWelfare
    Chapter.name chapter432b
      `shouldBe` "Protection of Children From Abuse and Neglect"


--
-- Helper Functions
--
main :: IO ()
main = hspec spec


firstTitle :: IO Title
firstTitle = head . parseTitles <$> nrsIndexHtml

title17 :: IO Title
title17 = (!! 16) . parseTitles <$> nrsIndexHtml

title38 :: IO Title
title38 = (!! 37) . parseTitles <$> nrsIndexHtml

nrsIndexHtml :: IO Html
nrsIndexHtml = NewHtml <$> readFile (fixture "index.html")
