#!/usr/bin/env bash

set -euo pipefail

# TODO: Check that we have committed all of our files.
git stash --include-untracked

# nix build ./hakyll#
cd hakyll
../result/bin/site rebuild

git switch pages
mkdir -p ./blog
cp -r _site/* ../blog/
git commit --all --message Deploy || printf "\x1b[93mFailed to commit, possibly because there were no changes\x1b[0m\n"

git switch master
git stash pop

