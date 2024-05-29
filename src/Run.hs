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
      output = complexGraphToImage res outputs
      outFile = optionsOutFile opts
  logInfo $ "Completed calculations. Writing output to " <> display outFile
  writeBinaryFile outFile output

fn :: (RealFloat a) => Complex a -> Complex a
fn = id
