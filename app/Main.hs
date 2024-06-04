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
          <*> option
            auto
            ( long "input-bounds"
                <> short 'i'
                <> help "Boundaries for the function inputs"
                <> showDefault
                <> value (-10, 10, -10, 10)
                <> metavar "(MINA,MAXA,MINB,MAXB)"
            )
          <*> option
            auto
            ( long "graph-resolution"
                <> short 'r'
                <> help "Number of points on the final rendered graph in each dimension."
                <> showDefault
                <> value 128
                <> metavar "INT"
            )
          <*> strOption
            ( long "out-file"
                <> short 'o'
                <> help "File to write"
                <> showDefault
                <> value "./graph.png"
                <> metavar "PATH"
            )
          <*> switch
            ( long "no-color"
                <> help "DON'T use hue color to indicate output angle"
            )
          <*> switch
            ( long "no-black"
                <> short 'b'
                <> help "DON'T use black to color outputs within the unit circle"
            )
          <*> switch
            ( long "no-white"
                <> short 'w'
                <> help "DON'T use white to color outputs beyond the unit circle"
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
