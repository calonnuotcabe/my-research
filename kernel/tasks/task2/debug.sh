#!/bin/sh
set -eu

TASK_INITRD="${1:-initramfs-base.cpio.gz}"

exec qemu-system-x86_64 \
    -kernel ./bzImage \
    -initrd "${TASK_INITRD}" \
    -append "console=ttyS0 nokaslr" \
    -m 512M \
    -s \
    -S \
    -no-reboot \
    -nographic \
    -cpu qemu64 \
    -smp 1
