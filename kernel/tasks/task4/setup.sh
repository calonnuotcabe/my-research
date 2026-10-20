#!/bin/sh 
set -eu

cd "$(dirname "$0")"

if [ ! -f initramfs-root/solve ]; then
    echo "missing initramfs-root/solve: compile your solve.c as a static binary first" >&2
    exit 1
fi

cd initramfs-root

find . -print0 \
    | cpio --null -ov --format=newc --owner=0:0 \
    | gzip -9 > ../initramfs.cpio.gz

echo "built ../initramfs.cpio.gz"
