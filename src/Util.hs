{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- | Utils for complex-hsv.
module Util (
  genInputs,
  complexGraphToImage,
  clamp,
  -- exported for testing:
  complexToHsv,
) where

import Codec.Picture
import Data.Colour.RGBSpace
import Data.Colour.RGBSpace.HSV
import Data.Complex
import RIO
import qualified RIO.ByteString.Lazy as L
import RIO.List.Partial
import Types

-- | Generates a one-dimensional list of all the inputs from the specified bounds
genInputs :: Bounds -> Int -> [[Complex Double]]
genInputs (mina, maxa, minb, maxb) res =
  [ zs | a <- [mina, nexta .. maxa], let zs = [z | b <- [minb, nextb .. maxb], let z = a :+ b]
  ]
 where
  nexta = mina + (maxa - mina) / fromIntegral res
  nextb = minb + (maxb - minb) / fromIntegral res

complexGraphToImage :: Int -> [[Complex Double]] -> ByteString
complexGraphToImage !dim outputs =
  L.toStrict
    . encodePng
    . convertRGB8
    . ImageRGBF
    $ generateImage getOutput dim dim
 where
  getOutput !a !b = hsvToRgb . complexToHsv $ findOutput a b
  hsvToRgb (h, s, v) = toPixel $ hsv h s v
  toPixel (RGB r g b) = PixelRGBF r g b
  findOutput !a !b = outputs !! a !! b

complexToHsv :: (RealFloat a) => Complex a -> (Float, Float, Float)
complexToHsv !z = (realToFrac adjustedPhase, realToFrac . clamp 0 1 $ 1 / magnitude z, 1)
 where
  adjustedPhase =
    if straightPhase < 0
      then straightPhase + 360
      else straightPhase
  straightPhase = phase z / pi * 180

clamp :: (Ord a) => a -> a -> a -> a
clamp !mn !mx = max mn . min mx
