#!/bin/bash

sudo mknod -m 622 dev/console c 5 1
sudo mknod -m 666 dev/null c 1 3
sudo mknod -m 666 dev/zero c 1 5
sudo mknod -m 666 dev/tty c 5 0
sudo mknod -m 666 dev/ttyS0 c 4 64

find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs.cpio.gz
