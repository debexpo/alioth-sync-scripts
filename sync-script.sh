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

function create_image() {
    RESULT="$?"
    if (( $RESULT == "0" )) ; then
        COLOR="#00ff00"
    else
        COLOR="#ff0000"
    fi

    echo "Git pushed to Alioth on $(date -R)" | convert -border 10 -bordercolor "$COLOR" label:@- ~/public_html/git-status.png
}

cd ~/debexpo  # This is where the code is.
git fetch -q origin  # This should fetch from github.

# We attempt to push, filtering out a particular error from Alioth's commit hooks.
git push --quiet alioth origin/master:master | ( grep -v dam.homelinux || true )

# If that didn't work, then we let the shell exit 1,
# and print an error.

# At exit time, always create a status image.
trap "create_image" INT TERM EXIT
