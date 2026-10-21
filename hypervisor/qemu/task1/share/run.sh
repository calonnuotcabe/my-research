#!/bin/bash
set -eu

exec /home/user/qemu-system-x86_64 \
    -L /home/user/bios \
    -kernel /home/user/bzImage \
    -initrd /home/user/initramfs.cpio.gz \
    -accel tcg \
    -cpu kvm64,+smep,+smap \
    -monitor none \
    -m 1024M \
    -append "console=ttyS0 oops=panic panic=1 quiet nokaslr" \
    -display none \
    -serial stdio \
    -no-reboot \
    -net user -net nic -device e1000 \
    -device maria \
    -sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny
