#!/bin/sh
set -eu

TASK_INITRD="${1:-initramfs.cpio.gz}"
TASK_GDB_PORT="${TASK_GDB_PORT:-1234}"

exec qemu-system-x86_64 \
    -kernel ./bzImage \
    -initrd "${TASK_INITRD}" \
    -append "console=ttyS0 loglevel=3 oops=panic panic=-1 pti=on kaslr" \
    -m 64M \
    -gdb "tcp::${TASK_GDB_PORT}" \
    -no-reboot \
    -nographic \
    -cpu qemu64,+smep,+smap \
    -smp 1 \
    -monitor /dev/null
