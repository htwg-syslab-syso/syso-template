#!/usr/bin/env bash
#set -o xtrace

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)

HW="$(find "$ROOT_DIR/" -mindepth 1 -maxdepth 1 -type d -name 'hw*' | sort | tail -n 1 | sed -nE 's/.*\/hw([0-9]+)$/\1/p')"
HW_FOLDER="${ROOT_DIR}/hw${HW}"
HW_SCRIPT="${HW_FOLDER}/hw${HW}.sh"
echo " found latest hw (${HW}) in '${HW_FOLDER}' with scripts '${HW_SCRIPT}'"

# kill qemu
if pgrep qemu-system-; then
  echo '! qemu is running, please stop qemu before running this test.'
  exit 1
fi

function run() {
  echo " run '$@'..."
  if ! "$@"; then
    echo "! '$@' failed."
    exit -1
  fi
}

# cd into hw folder
cd "${HW_FOLDER}"


# run qemu
echo " test 'qemu*' script functions..."
if [ "$HW" -eq 1 ]; then
  run "${HW_SCRIPT}" kernel kernel/config
  sync
  run "${HW_SCRIPT}" qemu_kernel 0</dev/null &
  sleep 15s
  echo " verify qemu is running..."
  run pgrep qemu-system-x86
  run pkill qemu-system-x86
fi

if [ "$HW" -eq 2 ]; then
  run "${HW_SCRIPT}" kernel kernel/config-busybox
  sync
  run "${HW_SCRIPT}" qemu_busybox 0</dev/null &
  sleep 15s
  
  echo " verify qemu is running..."
  run pgrep qemu-system-x86
  run pkill qemu-system-x86

  #sleep 30s

  #run "${HW_SCRIPT}" kernel kernel/config-initramfs
  #run "${HW_SCRIPT}" qemu_sysinfo 0</dev/null &
  #sleep 15s
  
  #echo " verify qemu is running..."
  #run pgrep qemu-system-x86
  #run pkill qemu-system-x86
fi

