#!/bin/sh

mkdir -p ./docs/blog

# TODO: Check that we have committed all of our files.

nix build ./hakyll# && cp -r result/* ./docs/blog/
