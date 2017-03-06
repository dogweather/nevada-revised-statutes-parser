{-# LANGUAGE OverloadedStrings #-}
module NvStatutesSpec where
import           BasicPrelude
import           Models
import           NvStatutes   (nrsIndexHtml, titles)
import           Test.Hspec


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


  describe "chapters" $

    it "reads a chapter correctly" $ do
      judicialDept <- firstTitle
      length (chapters judicialDept) `shouldNotBe` 0

      let generally = head (chapters judicialDept)
      chapterName   generally `shouldBe` "Judicial Department Generally"
      chapterNumber generally `shouldBe` "1"
      chapterUrl    generally `shouldBe` "https://www.leg.state.nv.us/nrs/NRS-001.html"


  describe "sections" $

    it "reads a section correctly" $ do
      judicialDept <- firstTitle
      let judicialDeptGenerally = head (chapters judicialDept)
      let courtsOfJustice       = head (sections judicialDeptGenerally)
      sectionName courtsOfJustice `shouldBe` "Courts of justice"


--
-- Helper Functions
--
firstTitle :: IO Title
firstTitle = do
  html <- nrsIndexHtml
  return (head (titles html))

main :: IO()
main =
  hspec spec
