#!/usr/bin/env bash

# pull all changes for the submodules
# --remote fetches new commits in the submodules
# and updates the working tree to the commit described by the branch
git submodule update --remote

# cd home-manager
# git fetch --all
# git checkout release-20.03
# git pull
