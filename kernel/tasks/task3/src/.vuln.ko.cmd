cmd_/lab/src/vuln.ko := ld -r -m elf_x86_64 -T /kernel/linux-2.6.32/scripts/module-common.lds --build-id -o /lab/src/vuln.ko /lab/src/vuln.o /lab/src/vuln.mod.o
