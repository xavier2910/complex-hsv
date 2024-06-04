{-# LANGUAGE NoImplicitPrelude #-}

module UtilSpec (spec) where

import Import
import Test.Hspec
import Test.Hspec.QuickCheck

spec :: Spec
spec = do
  describe "complexToHsv" $ do
    prop "hbounds" $ \z -> let h = getH (z :: Complex Double) in h <= 360 && h >= 0
    prop "sbounds" $ \z -> let s = getS (z :: Complex Double) in s <= 1 && s >= 0
    prop "vbounds" $ \z -> let v = getV (z :: Complex Double) in v <= 1 && v >= 0

{-
spec :: Spec
spec = do
  describe "plus2" $ do
    it "basic check" $ plus2 0 `shouldBe` 2
    it "overflow" $ plus2 maxBound `shouldBe` minBound + 1
    prop "minus 2" $ \i -> plus2 i - 2 `shouldBe` i
-}
