{-# LANGUAGE NoImplicitPrelude #-}

module UtilSpec (spec) where

import Import
import Test.Hspec
import Test.Hspec.QuickCheck

spec :: Spec
spec = do
  describe "genInputs" $ do
    it "simple 2x2" $ genInputs (0, 1, 0, 1) 1 `shouldBe` ([[0 :+ 0, 0 :+ 1], [1 :+ 0, 1 :+ 1]] :: [[Complex Double]])

  describe "complexToHsv" $ do
    prop "hbounds" $ \z -> let getH (hval, _, _) = hval; h = getH $ complexToHsv (z :: Complex Double) in h <= 360 && h >= 0
    prop "sbounds" $ \z -> let getS (_, sval, _) = sval; s = getS $ complexToHsv (z :: Complex Double) in s <= 1 && s >= 0
    prop "realIsRed" $ \a -> let z = abs a :+ 0 in complexToHsv (z :: Complex Double) `shouldBe` (0, realToFrac . clamp 0 1 $ 1 / magnitude z, 1)

{-
spec :: Spec
spec = do
  describe "plus2" $ do
    it "basic check" $ plus2 0 `shouldBe` 2
    it "overflow" $ plus2 maxBound `shouldBe` minBound + 1
    prop "minus 2" $ \i -> plus2 i - 2 `shouldBe` i
-}
