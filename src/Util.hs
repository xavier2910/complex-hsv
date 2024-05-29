{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- | Utils for complex-hsv.
module Util (
  genInputs,
  complexToHsv, -- exported for testing
  complexGraphToImage,
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
genInputs :: Bounds -> Int -> [Complex Double]
genInputs (mina, maxa, minb, maxb) res =
  [z | a <- [mina, nexta .. maxa], b <- [minb, nextb .. maxb], let z = a :+ b]
 where
  nexta = mina + (maxa - mina) / fromIntegral res
  nextb = minb + (maxb - minb) / fromIntegral res

complexGraphToImage :: Int -> [Complex Double] -> ByteString
complexGraphToImage !dim outputs = L.toStrict . encodePng . convertRGB8 . ImageRGBF $ generateImage getOutput dim dim
 where
  getOutput !a !b = hsvToRgb . complexToHsv $ findOutput a b
  hsvToRgb (h, s, v) = toPixel $ hsv h s v
  toPixel (RGB r g b) = PixelRGBF r g b
  findOutput !a !b = outputs !! (a * sqrtDim + b)
  !sqrtDim = floor $ sqrt (fromIntegral dim :: Double)

complexToHsv :: (RealFloat a) => Complex a -> (Float, Float, Float)
complexToHsv !z = (realToFrac $ phase z / pi * 180 + 180, realToFrac . clamp 1 1 $ 1 / magnitude z, 1)
 where
  clamp mn mx = max mn . min mx
