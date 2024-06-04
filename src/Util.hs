{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- | Utils for complex-hsv.
module Util (
  genInput,
  serializeImage,
  clamp,
  hsvToRgb,
  getH,
  getS,
  getV,
) where

import Codec.Picture
import Data.Colour.RGBSpace
import Data.Colour.RGBSpace.HSV
import Data.Complex
import RIO hiding (map)
import RIO.ByteString.Lazy qualified as L
import Types

genInput :: Bounds -> Int -> Int -> Int -> Complex Double
genInput (!na, !xa, !nb, !xb) !res !ia !ib = (na + a * da) :+ (nb + b * db)
 where
  !da = (xa - na) / fromIntegral res
  !db = (xb - nb) / fromIntegral res
  !a = fromIntegral ia
  !b = fromIntegral ib

hsvToRgb :: (PixelF, PixelF, PixelF) -> PixelRGBF
hsvToRgb (!h, !s, !v) = toPixel $ hsv h s v

toPixel :: RGB PixelF -> PixelRGBF
toPixel (RGB !r !g !b) = PixelRGBF r g b

serializeImage :: DynamicImage -> ByteString
serializeImage = L.toStrict . encodePng . convertRGB8

getH :: (RealFloat a) => Complex a -> Float
getH !z = realToFrac adjustedPhase
 where
  !adjustedPhase =
    if straightPhase < 0
      then straightPhase + 360
      else straightPhase
  !straightPhase = phase z / pi * 180

getS :: (RealFloat a) => Complex a -> Float
getS !z = realToFrac . clamp 0 1 $! recip $! magnitude z

getV :: (RealFloat a) => Complex a -> Float
getV !z = realToFrac . clamp 0 1 $! magnitude z

clamp :: (Ord a) => a -> a -> a -> a
clamp !mn !mx = max mn . min mx
