#!/usr/bin/env bash

cd hakyll
# nix build .#builder
./result/bin/site rebuild
./result/bin/site watch
