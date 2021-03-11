#!/usr/bin/env bash
#set -o xtrace

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)

HW="$(find "$ROOT_DIR/" -mindepth 1 -maxdepth 1 -type d -name 'hw*' | sort | tail -n 1 | sed -nE 's/.*\/hw([0-9]+)$/\1/p')"
HW_FOLDER="${ROOT_DIR}/hw${HW}"
HW_SCRIPT="${HW_FOLDER}/hw${HW}.sh"
echo " found latest hw (${HW}) in '${HW_FOLDER}' with scripts '${HW_SCRIPT}'"


function run() {
  echo " run '$@'..."
  if ! "$@"; then
    echo "! '$@' failed."
    exit -1
  fi
}


# cd into hw folder
cd "${HW_FOLDER}"

# clean
echo " test 'clean' function..."
run "${HW_SCRIPT}" clean
CLEAN_LOG="$(git clean -df --dry-run)"
if [ "$CLEAN_LOG" != "" ]; then
  echo "clean failed:"
  echo "$CLEAN_LOG"
  exit -6
fi
