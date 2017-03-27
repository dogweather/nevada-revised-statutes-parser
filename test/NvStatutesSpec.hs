{-# LANGUAGE OverloadedStrings #-}
module NvStatutesSpec where
import           BasicPrelude
import           Models
import           NvStatutes   (titles)
import           Test.Hspec


spec :: SpecWith ()
spec = parallel $ do

  describe "titles" $ do

    it "finds the correct number of titles" $ do
      html <- nrsIndexHtml
      length (titles html) `shouldBe` 59


    it "gets a title's name" $ do
      judicialDept <- firstTitle
      titleName judicialDept `shouldBe` "STATE JUDICIAL DEPARTMENT"


    it "gets a title's number" $ do
      judicialDept <- firstTitle
      titleNumber judicialDept `shouldBe` 1


  describe "chapters" $ do

    it "reads a chapter correctly" $ do
      judicialDept <- firstTitle
      length (chapters judicialDept) `shouldNotBe` 0
      let chapter1 = head $ chapters judicialDept

      chapterName   chapter1 `shouldBe` "Judicial Department Generally"
      chapterNumber chapter1 `shouldBe` "1"
      chapterUrl    chapter1 `shouldBe` "https://www.leg.state.nv.us/nrs/NRS-001.html"

    it "gets one that is further in" $ do
      publicWelfare <- title38
      titleName publicWelfare `shouldBe` "PUBLIC WELFARE"

      let chapter432b = last $ chapters publicWelfare
      chapterName chapter432b `shouldBe` "Protection of Children From Abuse and Neglect"


  -- describe "parseChapter" $
  --
  --   it "gets the first sub chapter correctly" $ do
  --     html ← chapter_432b_html
  --     let subChapters     = parseChapter html
  --     let firstSubChapter = head $ subChapters
  --
  --     subChapterName firstSubChapter `shouldBe` "GENERAL PROVISIONS"



  --
  --
  -- describe "sections" $
  --
  --   it "reads a section correctly" $ do
  --     pendingWith "TODO"
  --     judicialDept <- firstTitle
  --     let judicialDeptGenerally = head $ chapters judicialDept
  --     let courtsOfJustice       = head $ sections judicialDeptGenerally
  --
  --     sectionName courtsOfJustice `shouldBe` "Courts of justice"


--
-- Helper Functions
--
main ∷ IO()
main =
  hspec spec


firstTitle ∷ IO Title
firstTitle = do
  html ← nrsIndexHtml
  return (head (titles html))

title38 ∷ IO Title
title38 = do
  html ← nrsIndexHtml
  return $ titles html !! 37

nrsIndexHtml ∷ IO Text
nrsIndexHtml = readFile "test/fixtures/nrs.html"

chapter_432b_html ∷ IO Text
chapter_432b_html = readFile "text/fixtures/nrs-432b.html"
