#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
OUTPUT="${1:-$ROOT_DIR/../initramfs.cpio.gz}"

case "$OUTPUT" in
    /*) ;;
    *) OUTPUT="$ROOT_DIR/$OUTPUT" ;;
esac

cd "$ROOT_DIR"

fakeroot -- sh -c '
    set -eu

    rm -f dev/console dev/null dev/ptmx dev/tty dev/ttyS0 dev/zero

    mknod dev/console c 5 1
    chmod 622 dev/console
    mknod dev/null c 1 3
    chmod 666 dev/null
    mknod dev/zero c 1 5
    chmod 666 dev/zero
    mknod dev/tty c 5 0
    chmod 666 dev/tty
    mknod dev/ttyS0 c 4 64
    chmod 666 dev/ttyS0
    mknod dev/ptmx c 5 2
    chmod 666 dev/ptmx

    find . -print0 | cpio --null -o --format=newc --quiet | gzip -9 > "$1"
' sh "$OUTPUT"

printf '[+] wrote %s\n' "$OUTPUT"
