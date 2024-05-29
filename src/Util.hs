{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- | Utils for complex-hsv.
module Util (
  genInputs,
  complexToHsv, -- exported for testing
) where

import Data.Complex
import RIO
import Types

-- | Generates a one-dimensional list of all the inputs from the specified bounds
genInputs :: Bounds -> Int -> [Complex Double]
genInputs (mina, maxa, minb, maxb) res =
  [z | a <- [mina, nexta .. maxa], b <- [minb, nextb .. maxb], let z = a :+ b]
 where
  nexta = mina + (maxa - mina) / fromIntegral res
  nextb = minb + (maxb - minb) / fromIntegral res


complexToHsv :: (RealFloat a) => Complex a -> (Float, Float, Float)
complexToHsv !z = (realToFrac $ phase z / pi * 180 + 180, realToFrac . clamp 1 1 $ 1 / magnitude z, 1)
 where
  clamp mn mx = max mn . min mx
