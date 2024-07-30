{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Run (run) where

import Import

run :: RIO App ()
run = do
  logInfo "Calculating inputs..."
  !opts <- asks appOptions
  let !graphBounds = optionsInputBounds opts
      !res = optionsGraphPts opts
  !output <- serializeImage <$> graph fn graphBounds res
  let !outFile = optionsOutFile opts
  logInfo $ "Completed calculations. Writing output to " <> display outFile <> "."
  writeBinaryFile outFile output

-- this is the function to graph. Let it be whatever,
-- so long as it typechecks
fn :: (RealFloat a) => Complex a -> Complex a
fn = id

graph :: (Complex Double -> Complex Double) -> Bounds -> Int -> RIO App DynamicImage
graph !f !bnds !res = do
  !clr <- asks (not . optionsDontUseColor . appOptions)
  !blk <- asks (not . optionsDontUseBlack . appOptions)
  !wht <- asks (not . optionsDontUseWhite . appOptions)
  -- the idea here is to create the function once based on configuration
  -- and then run it rather than doing a bunch of ifs on the fly.
  -- There are no bangs b/c it runs faster that way.
  let calcH = if clr then getH else const 240
      calcS = if wht then getS else const 1
      calcV = if blk then getV else const 1
      complexToHsv !z = {-# SCC complexToHsv #-} (calcH z, calcS z, calcV z)
      createPixel !a !b = hsvToRgb . complexToHsv . f $ genInput bnds res a b
  return $! ImageRGBF $ generateImage createPixel res res
