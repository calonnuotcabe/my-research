#!/bin/sh

qemu-system-x86_64 \
  -kernel linux-2.6.32/arch/x86/boot/bzImage \
  -initrd initramfs.cpio.gz \
  -append "console=ttyS0 nokaslr" \
  -m 512M \
  -s \
  -no-reboot \
  -nographic \
  -virtfs local,path=/home/huhu/hypervisor,mount_tag=hostshare,security_model=none,id=hostshare
