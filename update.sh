#!/usr/bin/env bash

git submodule foreach git pull origin master
git submodule foreach git submodule foreach git pull origin master

# setup command-t
cd _vim/bundle/command-t
rake make

