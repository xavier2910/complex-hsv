{-# LANGUAGE NoImplicitPrelude #-}

-- | Utils for complex-hsv.
module Util (
  genInputs,
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


