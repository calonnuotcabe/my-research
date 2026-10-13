# Task 2 — ret2usr stage 1

Kernel lab: Linux 2.6.32 + Holstein v1.

The learner must create `solve_stage1.c` in this directory.
The target is `/dev/holstein`, and the measured saved-RIP offset for
`module_write()` in this build is `0x418`.

This task only proves the control-flow transition:

```text
user write()
  -> module_write()
  -> saved RIP overwrite
  -> user restore_state()
  -> swapgs + iretq
  -> user stage1_success()
```

Do not add `prepare_kernel_cred()` or `commit_creds()` in this task.
The expected UID after returning to user mode is still `1337`.

Files:

- `bzImage`: Linux 2.6.32 kernel
- `vmlinux`: unstripped kernel symbols for GDB
- `initramfs-base.cpio.gz`: clean base filesystem with the Holstein module
- `vuln.c`: module source for analysis
- `init.bai17`: init script used to build the base filesystem
- `run.sh`: QEMU launcher; it accepts an initramfs path as its first argument
- `debug.sh`: same launcher with `-S`, waiting for GDB on TCP port `1234`
- `huhu`: symbolized ELF generated from `vmlinux-to-elf`
- `vuln.ko`: module ELF for optional `add-symbol-file`

The exploit source and rebuilt initramfs are deliberately not provided.
