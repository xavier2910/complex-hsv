{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Main (main) where

import Import
import Options.Applicative.Simple
import qualified Paths_complex_hsv
import RIO.Process
import Run

main :: IO ()
main = do
  (options, ()) <-
    simpleOptions
      $(simpleVersion Paths_complex_hsv.version)
      "I really don't know what belongs here."
      "Graphs a complex function: inputs are x + y*i, outputs are 1/s * e^(h*i), ie, color indicates where a point is going, its position, where it comes from."
      ( Options
          <$> switch
            ( long "verbose"
                <> short 'v'
                <> help "Verbose output?"
            )
      )
      empty
  lo <- logOptionsHandle stderr (optionsVerbose options)
  pc <- mkDefaultProcessContext
  withLogFunc lo $ \lf ->
    let app =
          App
            { appLogFunc = lf
            , appProcessContext = pc
            , appOptions = options
            }
     in runRIO app run
