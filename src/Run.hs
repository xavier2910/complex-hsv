{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Run (run) where

import Import

run :: RIO App ()
run = do
  logInfo "Calculating inputs..."
  !app <- ask
  let !opts = appOptions app
      !graphBounds = optionsInputBounds opts
      !res = optionsGraphPts opts
      !output = serializeImage $ graph fn graphBounds res
      !outFile = optionsOutFile opts
  logInfo $ "Completed calculations. Writing output to " <> display outFile <> "."
  writeBinaryFile outFile output

-- this is the function to graph. Let it be whatever,
-- so long as it typechecks
fn :: (RealFloat a) => Complex a -> Complex a
fn = id
