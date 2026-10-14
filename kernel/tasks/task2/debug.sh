#!/bin/sh
set -eu

musl-gcc -static -O2 -o solve copy.c
cp solve initramfs-root/solve
initramfs-root/setup.sh

TASK_INITRD="${1:-initramfs.cpio.gz}"

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
