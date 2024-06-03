# Changelog for `complex-hsv`

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to the
[Haskell Package Versioning Policy](https://pvp.haskell.org/).

## 0.1.0.0 - 2024-06-03

### Features

* Graphs a complex function specified in the source code -- i.e., it works!
* Allows for custom graph resolution and output location to be specified on the command line (via `-r` and `-o`).

### Known Limitations

* Recompliation is necessary to graph different functions.
* Magnitude information is trucated if the output's magnitude is < 1.
