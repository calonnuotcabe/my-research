#!/usr/bin/env bash
# Build solve.c as a self-contained guest binary and refresh the initramfs.
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source_file="$script_dir/solve.c"
binary_file="$script_dir/solve"
initramfs_dir="$script_dir/initramfs"
guest_binary="$initramfs_dir/home/user/solve"
archive_file="$script_dir/initramfs.cpio.gz"
temporary_archive=$(mktemp "$script_dir/.initramfs.cpio.gz.XXXXXX")

cleanup() {
    rm -f -- "$temporary_archive"
}
trap cleanup EXIT

if [[ ! -f "$source_file" ]]; then
    printf 'error: missing source file: %s\n' "$source_file" >&2
    exit 1
fi

if [[ ! -d "$initramfs_dir" ]]; then
    printf 'error: missing initramfs directory: %s\n' "$initramfs_dir" >&2
    exit 1
fi

gcc -static -O2 -Wall -Wextra -o "$binary_file" "$source_file"
install -D -m 0755 "$binary_file" "$guest_binary"

(
    cd "$initramfs_dir"
    find . -print0 | cpio --null -o --format=newc 2>/dev/null | gzip -9 > "$temporary_archive"
)
mv -f -- "$temporary_archive" "$archive_file"
trap - EXIT

printf 'built %s and packed it as /home/user/solve in %s\n' \
    "$binary_file" "$archive_file"
