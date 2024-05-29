{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Types (
  App (..),
  Options (..),
  Bounds,
) where

import Data.Complex
import RIO
import RIO.Process

-- | Command line arguments
data Options = Options
  { optionsVerbose :: !Bool
  , optionsInputBounds :: !Bounds
  , optionsGraphPts :: !Int
  }

data App = App
  { appLogFunc :: !LogFunc
  , appProcessContext :: !ProcessContext
  , appOptions :: !Options
  -- Add other app-specific configuration information here
  }

type Bounds = (Double, Double, Double, Double)

instance HasLogFunc App where
  logFuncL = lens appLogFunc (\x y -> x{appLogFunc = y})
instance HasProcessContext App where
  processContextL = lens appProcessContext (\x y -> x{appProcessContext = y})

instance (Display a) => Display (Complex a) where
  display z = display (realPart z) <> "+" <> display (imagPart z) <> "i"
