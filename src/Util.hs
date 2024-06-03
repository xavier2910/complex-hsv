{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- | Utils for complex-hsv.
module Util (
  genInput,
  graph,
  serializeImage,
  clamp,
  -- exported for testing:
  complexToHsv,
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

graph :: (Complex Double -> Complex Double) -> Bounds -> Int -> DynamicImage
graph !fn !bnds !res = ImageRGBF $ generateImage createPixel res res
 where
  createPixel !a !b = {-# SCC createPixel #-} hsvToRgb . complexToHsv . fn $ genInput bnds res a b

hsvToRgb :: (PixelF, PixelF, PixelF) -> PixelRGBF
hsvToRgb (!h, !s, !v) = toPixel $ hsv h s v

toPixel :: RGB PixelF -> PixelRGBF
toPixel (RGB !r !g !b) = PixelRGBF r g b

serializeImage :: DynamicImage -> ByteString
serializeImage = L.toStrict . encodePng . convertRGB8

complexToHsv :: (RealFloat a) => Complex a -> (Float, Float, Float)
complexToHsv !z = (realToFrac adjustedPhase, realToFrac . clamp 0 1 $ 1 / magnitude z, 1)
 where
  !adjustedPhase =
    if straightPhase < 0
      then straightPhase + 360
      else straightPhase
  !straightPhase = phase z / pi * 180

clamp :: (Ord a) => a -> a -> a -> a
clamp !mn !mx = max mn . min mx
