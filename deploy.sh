#!/usr/bin/env bash

set -euo pipefail

# TODO: Check that we have committed all of our files.

cd "$(git rev-parse --show-toplevel)"
nix-build

rsync -rhv --delete ./result/* ./deployed/
cd deployed
git add --all
git commit --message Deploy || printf "\x1b[93mFailed to commit, possibly because there were no changes\x1b[0m\n"
git push
