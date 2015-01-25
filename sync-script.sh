#!/bin/bash

set -e

# Strategy:
#
# For JUST the master branch, if it gets an update on github,
# push that to Alioth.
#
# If that fails for some reason, this thing will send output
# to stdout, which will cause the cron user to get emailed.
# To avoid this happening repeatedly, this script chmod itself
# not executable.
#
# TODO: create a status images.

cd ~/debexpo  # This is where the code is.
git fetch -q origin  # This should fetch from github.
git push --quiet alioth HEAD:master | ( grep -v dam.homelinux || true )  # We attempt to push, filtering out a particular error from Alioth's commit hooks.

# If that didn't work, then we let the shell exit 1,
# and print an error.
