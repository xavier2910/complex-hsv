{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Run (run) where

import Import

run :: RIO App ()
run = do
  logInfo "Calculating inputs..."
  app <- ask
  let opts = appOptions app
      graphBounds = optionsInputBounds opts
      res = optionsGraphPts opts
      inputs = genInputs graphBounds res
      outputs = map fn inputs
      output = foldl' (\a b -> a <> "\n" <> b) mempty $ map display outputs
  logInfo $ "Outputs:" <> output

fn :: (RealFloat a) => Complex a -> Complex a
fn = (** 2)

genInputs :: Bounds -> Int -> [Complex Double]
genInputs (mina, maxa, minb, maxb) res =
  [z | a <- [mina, nexta .. maxa], b <- [minb, nextb .. maxb], let z = a :+ b]
 where
  nexta = mina + (maxa - mina) / fromIntegral res
  nextb = minb + (maxb - minb) / fromIntegral res
