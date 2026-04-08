#!/bin/sh

git stash --include-untracked

mkdir -p ./docs/blog

# TODO: Check that we have committed all of our files.

# nix build ./hakyll# && cp -r result/* ./docs/blog/
cd hakyll
./result/bin/site rebuild
cp -r _site/* ../docs/blog/

git stash pop
