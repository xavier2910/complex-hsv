{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Run (run) where

import Import

run :: RIO App ()
run = do
  logInfo "We're inside the application!"
  let a = 0.707 :+ 0.707 :: Complex Double
      b = conjugate a
      c = a * b + b * a
  logInfo $ (display . realPart $ c) <> " + " <> (display . imagPart $ c) <> "i"
