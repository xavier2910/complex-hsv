{-# LANGUAGE NoImplicitPrelude #-}

module UtilSpec (spec) where

import Import
import Test.Hspec
import Test.Hspec.QuickCheck
import Util

spec :: Spec
spec = do
  describe "genInputs" $ do
    it "simple 2x2" $ genInputs (0, 1, 0, 1) 1 `shouldBe` ([0 :+ 0, 0 :+ 1, 1 :+ 0, 1 :+ 1] :: [Complex Double])

{-
spec :: Spec
spec = do
  describe "plus2" $ do
    it "basic check" $ plus2 0 `shouldBe` 2
    it "overflow" $ plus2 maxBound `shouldBe` minBound + 1
    prop "minus 2" $ \i -> plus2 i - 2 `shouldBe` i
-}
