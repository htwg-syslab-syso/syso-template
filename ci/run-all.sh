#!/usr/bin/env bash

# Exit script on the first error
set -o errexit -o nounset

MY_PATH="$(dirname "$0")"

# build tests (contains artifacts check)
"$MY_PATH/run-test.sh"

# check files (pre-build)
"$MY_PATH/check-files.py"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+            Ready for pull request                +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
