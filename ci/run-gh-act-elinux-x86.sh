#!/usr/bin/env bash

# Exit script on the first error
set -o errexit -o nounset



function shell_check(){
MY_PATH="$(dirname "$0")"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+            Run ShellCheck                        +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
# run shellcheck
"$MY_PATH/run-shellcheck.sh"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+            ShellCheck OK                         +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

function artifacts(){
MY_PATH="$(dirname "$0")"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+            Run Artifacts Build                   +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
# build tests (contains artifacts check)
"$MY_PATH/run-test-artifacts.sh"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+            Artifacts Build OK                    +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

function test_qemu(){
MY_PATH="$(dirname "$0")"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+            Run Qemu                              +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
## build tests (contains artifacts check)
"$MY_PATH/run-test-qemu.sh"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+            Qemu OK                               +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

function test_clean(){
MY_PATH="$(dirname "$0")"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+            Run Clean Function                    +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
# build tests (contains artifacts check)
"$MY_PATH/run-test-clean.sh"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+            Clean Function OK                     +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
}
function all_files(){
MY_PATH="$(dirname "$0")"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+            All Files found?                       +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
# check files (pre-build)
"$MY_PATH/check-files.py"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+            Yes, all files found                  +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

function run_all() {

shell_check
artifacts
#test_qemu
test_clean
all_files

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+            Ready for manual review               +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
}


"${@:-run_all}"
