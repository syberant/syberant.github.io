#!/usr/bin/env bash

# nix build ./hakyll#builder
cd hakyll
../result/bin/site rebuild
../result/bin/site watch
