cmd_arch/x86/kernel/asm-offsets.s := gcc -Wp,-MD,arch/x86/kernel/.asm-offsets.s.d  -nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.6/include -Iinclude -Iinclude2 -I/kernel/linux-2.6.32/include -I/kernel/linux-2.6.32/arch/x86/include -include include/linux/autoconf.h  -I/kernel/linux-2.6.32/. -I. -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -m64 -mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm -fconserve-stack   -D"KBUILD_STR(s)=\#s" -D"KBUILD_BASENAME=KBUILD_STR(asm_offsets)"  -D"KBUILD_MODNAME=KBUILD_STR(asm_offsets)"  -fverbose-asm -S -o arch/x86/kernel/asm-offsets.s /kernel/linux-2.6.32/arch/x86/kernel/asm-offsets.c

deps_arch/x86/kernel/asm-offsets.s := \
  /kernel/linux-2.6.32/arch/x86/kernel/asm-offsets.c \
    $(wildcard include/config/x86/32.h) \
  /kernel/linux-2.6.32/arch/x86/kernel/asm-offsets_64.c \
    $(wildcard include/config/ia32/emulation.h) \
    $(wildcard include/config/paravirt.h) \
    $(wildcard include/config/xen.h) \
  /kernel/linux-2.6.32/include/linux/crypto.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/atomic.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/atomic_64.h \
  /kernel/linux-2.6.32/include/linux/types.h \
    $(wildcard include/config/uid16.h) \
    $(wildcard include/config/lbdaf.h) \
    $(wildcard include/config/phys/addr/t/64bit.h) \
    $(wildcard include/config/64bit.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/types.h \
    $(wildcard include/config/x86/64.h) \
    $(wildcard include/config/highmem64g.h) \
  /kernel/linux-2.6.32/include/asm-generic/types.h \
  /kernel/linux-2.6.32/include/asm-generic/int-ll64.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/bitsperlong.h \
  /kernel/linux-2.6.32/include/asm-generic/bitsperlong.h \
  /kernel/linux-2.6.32/include/linux/posix_types.h \
  /kernel/linux-2.6.32/include/linux/stddef.h \
  /kernel/linux-2.6.32/include/linux/compiler.h \
    $(wildcard include/config/trace/branch/profiling.h) \
    $(wildcard include/config/profile/all/branches.h) \
    $(wildcard include/config/enable/must/check.h) \
    $(wildcard include/config/enable/warn/deprecated.h) \
  /kernel/linux-2.6.32/include/linux/compiler-gcc.h \
    $(wildcard include/config/arch/supports/optimized/inlining.h) \
    $(wildcard include/config/optimize/inlining.h) \
  /kernel/linux-2.6.32/include/linux/compiler-gcc4.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/posix_types.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/posix_types_64.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/alternative.h \
    $(wildcard include/config/smp.h) \
  /kernel/linux-2.6.32/include/linux/stringify.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/asm.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/cpufeature.h \
    $(wildcard include/config/x86/invlpg.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/required-features.h \
    $(wildcard include/config/x86/minimum/cpu/family.h) \
    $(wildcard include/config/math/emulation.h) \
    $(wildcard include/config/x86/pae.h) \
    $(wildcard include/config/x86/cmpxchg64.h) \
    $(wildcard include/config/x86/cmov.h) \
    $(wildcard include/config/x86/use/3dnow.h) \
    $(wildcard include/config/x86/p6/nop.h) \
  /kernel/linux-2.6.32/include/linux/bitops.h \
    $(wildcard include/config/generic/find/first/bit.h) \
    $(wildcard include/config/generic/find/last/bit.h) \
    $(wildcard include/config/generic/find/next/bit.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/bitops.h \
  /kernel/linux-2.6.32/include/asm-generic/bitops/sched.h \
  /kernel/linux-2.6.32/include/asm-generic/bitops/hweight.h \
  /kernel/linux-2.6.32/include/asm-generic/bitops/fls64.h \
  /kernel/linux-2.6.32/include/asm-generic/bitops/ext2-non-atomic.h \
  /kernel/linux-2.6.32/include/asm-generic/bitops/le.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/byteorder.h \
  /kernel/linux-2.6.32/include/linux/byteorder/little_endian.h \
  /kernel/linux-2.6.32/include/linux/swab.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/swab.h \
    $(wildcard include/config/x86/bswap.h) \
  /kernel/linux-2.6.32/include/linux/byteorder/generic.h \
  /kernel/linux-2.6.32/include/asm-generic/bitops/minix.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/cmpxchg.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/cmpxchg_64.h \
  /kernel/linux-2.6.32/include/asm-generic/atomic-long.h \
  /kernel/linux-2.6.32/include/linux/module.h \
    $(wildcard include/config/modules.h) \
    $(wildcard include/config/modversions.h) \
    $(wildcard include/config/unused/symbols.h) \
    $(wildcard include/config/generic/bug.h) \
    $(wildcard include/config/kallsyms.h) \
    $(wildcard include/config/tracepoints.h) \
    $(wildcard include/config/tracing.h) \
    $(wildcard include/config/event/tracing.h) \
    $(wildcard include/config/ftrace/mcount/record.h) \
    $(wildcard include/config/module/unload.h) \
    $(wildcard include/config/constructors.h) \
    $(wildcard include/config/sysfs.h) \
  /kernel/linux-2.6.32/include/linux/list.h \
    $(wildcard include/config/debug/list.h) \
  /kernel/linux-2.6.32/include/linux/poison.h \
  /kernel/linux-2.6.32/include/linux/prefetch.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/processor.h \
    $(wildcard include/config/x86/vsmp.h) \
    $(wildcard include/config/cc/stackprotector.h) \
    $(wildcard include/config/m386.h) \
    $(wildcard include/config/m486.h) \
    $(wildcard include/config/x86/debugctlmsr.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/processor-flags.h \
    $(wildcard include/config/vm86.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/vm86.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/ptrace.h \
    $(wildcard include/config/x86/ptrace/bts.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/ptrace-abi.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/segment.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/cache.h \
    $(wildcard include/config/x86/l1/cache/shift.h) \
  /kernel/linux-2.6.32/include/linux/linkage.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/linkage.h \
    $(wildcard include/config/x86/alignment/16.h) \
  /kernel/linux-2.6.32/include/linux/init.h \
    $(wildcard include/config/hotplug.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/math_emu.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/sigcontext.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/current.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/percpu.h \
    $(wildcard include/config/x86/64/smp.h) \
  /kernel/linux-2.6.32/include/linux/kernel.h \
    $(wildcard include/config/preempt/voluntary.h) \
    $(wildcard include/config/debug/spinlock/sleep.h) \
    $(wildcard include/config/prove/locking.h) \
    $(wildcard include/config/printk.h) \
    $(wildcard include/config/dynamic/debug.h) \
    $(wildcard include/config/ring/buffer.h) \
    $(wildcard include/config/numa.h) \
  /usr/lib/gcc/x86_64-linux-gnu/4.6/include/stdarg.h \
  /kernel/linux-2.6.32/include/linux/log2.h \
    $(wildcard include/config/arch/has/ilog2/u32.h) \
    $(wildcard include/config/arch/has/ilog2/u64.h) \
  /kernel/linux-2.6.32/include/linux/typecheck.h \
  /kernel/linux-2.6.32/include/linux/ratelimit.h \
  /kernel/linux-2.6.32/include/linux/param.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/param.h \
  /kernel/linux-2.6.32/include/asm-generic/param.h \
    $(wildcard include/config/hz.h) \
  /kernel/linux-2.6.32/include/linux/dynamic_debug.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/bug.h \
    $(wildcard include/config/bug.h) \
    $(wildcard include/config/debug/bugverbose.h) \
  /kernel/linux-2.6.32/include/asm-generic/bug.h \
    $(wildcard include/config/generic/bug/relative/pointers.h) \
  /kernel/linux-2.6.32/include/asm-generic/percpu.h \
    $(wildcard include/config/debug/preempt.h) \
    $(wildcard include/config/have/setup/per/cpu/area.h) \
  /kernel/linux-2.6.32/include/linux/threads.h \
    $(wildcard include/config/nr/cpus.h) \
    $(wildcard include/config/base/small.h) \
  /kernel/linux-2.6.32/include/linux/percpu-defs.h \
    $(wildcard include/config/debug/force/weak/per/cpu.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/system.h \
    $(wildcard include/config/x86/32/lazy/gs.h) \
    $(wildcard include/config/x86/ppro/fence.h) \
    $(wildcard include/config/x86/oostore.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/nops.h \
    $(wildcard include/config/mk7.h) \
  /kernel/linux-2.6.32/include/linux/irqflags.h \
    $(wildcard include/config/trace/irqflags.h) \
    $(wildcard include/config/irqsoff/tracer.h) \
    $(wildcard include/config/preempt/tracer.h) \
    $(wildcard include/config/trace/irqflags/support.h) \
    $(wildcard include/config/x86.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/irqflags.h \
    $(wildcard include/config/debug/lock/alloc.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/page.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/page_types.h \
  /kernel/linux-2.6.32/include/linux/const.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/page_64_types.h \
    $(wildcard include/config/physical/start.h) \
    $(wildcard include/config/physical/align.h) \
    $(wildcard include/config/flatmem.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/page_64.h \
  /kernel/linux-2.6.32/include/asm-generic/memory_model.h \
    $(wildcard include/config/discontigmem.h) \
    $(wildcard include/config/sparsemem/vmemmap.h) \
    $(wildcard include/config/sparsemem.h) \
  /kernel/linux-2.6.32/include/asm-generic/getorder.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/pgtable_types.h \
    $(wildcard include/config/kmemcheck.h) \
    $(wildcard include/config/compat/vdso.h) \
    $(wildcard include/config/proc/fs.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/pgtable_64_types.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/msr.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/msr-index.h \
  /kernel/linux-2.6.32/include/linux/ioctl.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/ioctl.h \
  /kernel/linux-2.6.32/include/asm-generic/ioctl.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/errno.h \
  /kernel/linux-2.6.32/include/asm-generic/errno.h \
  /kernel/linux-2.6.32/include/asm-generic/errno-base.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/cpumask.h \
  /kernel/linux-2.6.32/include/linux/cpumask.h \
    $(wildcard include/config/cpumask/offstack.h) \
    $(wildcard include/config/hotplug/cpu.h) \
    $(wildcard include/config/debug/per/cpu/maps.h) \
    $(wildcard include/config/disable/obsolete/cpumask/functions.h) \
  /kernel/linux-2.6.32/include/linux/bitmap.h \
  /kernel/linux-2.6.32/include/linux/string.h \
    $(wildcard include/config/binary/printf.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/string.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/string_64.h \
  /kernel/linux-2.6.32/include/linux/errno.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/desc_defs.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/ds.h \
    $(wildcard include/config/x86/ds.h) \
  /kernel/linux-2.6.32/include/linux/err.h \
  /kernel/linux-2.6.32/include/linux/personality.h \
  /kernel/linux-2.6.32/include/linux/cache.h \
    $(wildcard include/config/arch/has/cache/line/size.h) \
  /kernel/linux-2.6.32/include/linux/math64.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/div64.h \
  /kernel/linux-2.6.32/include/asm-generic/div64.h \
  /kernel/linux-2.6.32/include/linux/stat.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/stat.h \
  /kernel/linux-2.6.32/include/linux/time.h \
    $(wildcard include/config/arch/uses/gettimeoffset.h) \
  /kernel/linux-2.6.32/include/linux/seqlock.h \
  /kernel/linux-2.6.32/include/linux/spinlock.h \
    $(wildcard include/config/debug/spinlock.h) \
    $(wildcard include/config/generic/lockbreak.h) \
    $(wildcard include/config/preempt.h) \
  /kernel/linux-2.6.32/include/linux/preempt.h \
    $(wildcard include/config/preempt/notifiers.h) \
  /kernel/linux-2.6.32/include/linux/thread_info.h \
    $(wildcard include/config/compat.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/thread_info.h \
    $(wildcard include/config/debug/stack/usage.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/ftrace.h \
    $(wildcard include/config/function/tracer.h) \
    $(wildcard include/config/dynamic/ftrace.h) \
  /kernel/linux-2.6.32/include/linux/bottom_half.h \
  /kernel/linux-2.6.32/include/linux/spinlock_types.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/spinlock_types.h \
  /kernel/linux-2.6.32/include/linux/lockdep.h \
    $(wildcard include/config/lockdep.h) \
    $(wildcard include/config/lock/stat.h) \
    $(wildcard include/config/generic/hardirqs.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/spinlock.h \
    $(wildcard include/config/paravirt/spinlocks.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/rwlock.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/paravirt.h \
    $(wildcard include/config/highpte.h) \
  /kernel/linux-2.6.32/include/linux/spinlock_api_smp.h \
  /kernel/linux-2.6.32/include/linux/kmod.h \
  /kernel/linux-2.6.32/include/linux/gfp.h \
    $(wildcard include/config/highmem.h) \
    $(wildcard include/config/zone/dma.h) \
    $(wildcard include/config/zone/dma32.h) \
    $(wildcard include/config/debug/vm.h) \
  /kernel/linux-2.6.32/include/linux/mmzone.h \
    $(wildcard include/config/force/max/zoneorder.h) \
    $(wildcard include/config/memory/hotplug.h) \
    $(wildcard include/config/arch/populates/node/map.h) \
    $(wildcard include/config/flat/node/mem/map.h) \
    $(wildcard include/config/cgroup/mem/res/ctlr.h) \
    $(wildcard include/config/have/memory/present.h) \
    $(wildcard include/config/need/node/memmap/size.h) \
    $(wildcard include/config/need/multiple/nodes.h) \
    $(wildcard include/config/have/arch/early/pfn/to/nid.h) \
    $(wildcard include/config/sparsemem/extreme.h) \
    $(wildcard include/config/nodes/span/other/nodes.h) \
    $(wildcard include/config/holes/in/zone.h) \
    $(wildcard include/config/arch/has/holes/memorymodel.h) \
  /kernel/linux-2.6.32/include/linux/wait.h \
  /kernel/linux-2.6.32/include/linux/numa.h \
    $(wildcard include/config/nodes/shift.h) \
  /kernel/linux-2.6.32/include/linux/nodemask.h \
  /kernel/linux-2.6.32/include/linux/pageblock-flags.h \
    $(wildcard include/config/hugetlb/page.h) \
    $(wildcard include/config/hugetlb/page/size/variable.h) \
  include/linux/bounds.h \
  /kernel/linux-2.6.32/include/linux/memory_hotplug.h \
    $(wildcard include/config/have/arch/nodedata/extension.h) \
    $(wildcard include/config/memory/hotremove.h) \
  /kernel/linux-2.6.32/include/linux/notifier.h \
  /kernel/linux-2.6.32/include/linux/mutex.h \
    $(wildcard include/config/debug/mutexes.h) \
  /kernel/linux-2.6.32/include/linux/rwsem.h \
    $(wildcard include/config/rwsem/generic/spinlock.h) \
  /kernel/linux-2.6.32/include/linux/rwsem-spinlock.h \
  /kernel/linux-2.6.32/include/linux/srcu.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/mmzone.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/mmzone_64.h \
    $(wildcard include/config/numa/emu.h) \
  /kernel/linux-2.6.32/include/linux/mmdebug.h \
    $(wildcard include/config/debug/virtual.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/smp.h \
    $(wildcard include/config/x86/local/apic.h) \
    $(wildcard include/config/x86/io/apic.h) \
    $(wildcard include/config/x86/32/smp.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/mpspec.h \
    $(wildcard include/config/x86/numaq.h) \
    $(wildcard include/config/mca.h) \
    $(wildcard include/config/eisa.h) \
    $(wildcard include/config/x86/mpparse.h) \
    $(wildcard include/config/acpi.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/mpspec_def.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/x86_init.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/bootparam.h \
  /kernel/linux-2.6.32/include/linux/screen_info.h \
  /kernel/linux-2.6.32/include/linux/apm_bios.h \
  /kernel/linux-2.6.32/include/linux/edd.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/e820.h \
    $(wildcard include/config/efi.h) \
    $(wildcard include/config/hibernation.h) \
    $(wildcard include/config/memtest.h) \
  /kernel/linux-2.6.32/include/linux/ioport.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/ist.h \
  /kernel/linux-2.6.32/include/video/edid.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/apic.h \
    $(wildcard include/config/x86/x2apic.h) \
  /kernel/linux-2.6.32/include/linux/delay.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/delay.h \
  /kernel/linux-2.6.32/include/linux/pm.h \
    $(wildcard include/config/pm/sleep.h) \
    $(wildcard include/config/pm/runtime.h) \
  /kernel/linux-2.6.32/include/linux/workqueue.h \
  /kernel/linux-2.6.32/include/linux/timer.h \
    $(wildcard include/config/timer/stats.h) \
    $(wildcard include/config/debug/objects/timers.h) \
  /kernel/linux-2.6.32/include/linux/ktime.h \
    $(wildcard include/config/ktime/scalar.h) \
  /kernel/linux-2.6.32/include/linux/jiffies.h \
  /kernel/linux-2.6.32/include/linux/timex.h \
    $(wildcard include/config/no/hz.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/timex.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/tsc.h \
    $(wildcard include/config/x86/tsc.h) \
  /kernel/linux-2.6.32/include/linux/debugobjects.h \
    $(wildcard include/config/debug/objects.h) \
    $(wildcard include/config/debug/objects/free.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/apicdef.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/fixmap.h \
    $(wildcard include/config/x86/visws/apic.h) \
    $(wildcard include/config/x86/f00f/bug.h) \
    $(wildcard include/config/x86/cyclone/timer.h) \
    $(wildcard include/config/pci/mmconfig.h) \
    $(wildcard include/config/provide/ohci1394/dma/init.h) \
    $(wildcard include/config/intel/txt.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/acpi.h \
    $(wildcard include/config/acpi/numa.h) \
  /kernel/linux-2.6.32/include/acpi/pdc_intel.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/numa.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/numa_64.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/mmu.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/vsyscall.h \
    $(wildcard include/config/generic/time.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/io_apic.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/irq_vectors.h \
    $(wildcard include/config/sparse/irq.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/sparsemem.h \
  /kernel/linux-2.6.32/include/linux/topology.h \
    $(wildcard include/config/sched/smt.h) \
    $(wildcard include/config/sched/mc.h) \
  /kernel/linux-2.6.32/include/linux/smp.h \
    $(wildcard include/config/use/generic/smp/helpers.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/topology.h \
    $(wildcard include/config/x86/ht.h) \
    $(wildcard include/config/x86/64/acpi/numa.h) \
  /kernel/linux-2.6.32/include/asm-generic/topology.h \
  /kernel/linux-2.6.32/include/linux/elf.h \
  /kernel/linux-2.6.32/include/linux/elf-em.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/elf.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/user.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/user_64.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/auxvec.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/vdso.h \
  /kernel/linux-2.6.32/include/linux/kobject.h \
  /kernel/linux-2.6.32/include/linux/sysfs.h \
  /kernel/linux-2.6.32/include/linux/kref.h \
  /kernel/linux-2.6.32/include/linux/moduleparam.h \
    $(wildcard include/config/alpha.h) \
    $(wildcard include/config/ia64.h) \
    $(wildcard include/config/ppc64.h) \
  /kernel/linux-2.6.32/include/linux/tracepoint.h \
  /kernel/linux-2.6.32/include/linux/rcupdate.h \
    $(wildcard include/config/tree/preempt/rcu.h) \
    $(wildcard include/config/tree/rcu.h) \
  /kernel/linux-2.6.32/include/linux/completion.h \
  /kernel/linux-2.6.32/include/linux/rcutree.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/local.h \
  /kernel/linux-2.6.32/include/linux/percpu.h \
    $(wildcard include/config/have/legacy/per/cpu/area.h) \
    $(wildcard include/config/need/per/cpu/embed/first/chunk.h) \
    $(wildcard include/config/need/per/cpu/page/first/chunk.h) \
    $(wildcard include/config/debug/kmemleak.h) \
  /kernel/linux-2.6.32/include/linux/slab.h \
    $(wildcard include/config/slab/debug.h) \
    $(wildcard include/config/slub.h) \
    $(wildcard include/config/slob.h) \
    $(wildcard include/config/debug/slab.h) \
  /kernel/linux-2.6.32/include/linux/slub_def.h \
    $(wildcard include/config/slub/stats.h) \
    $(wildcard include/config/slub/debug.h) \
    $(wildcard include/config/kmemtrace.h) \
  /kernel/linux-2.6.32/include/linux/kmemtrace.h \
  /kernel/linux-2.6.32/include/trace/events/kmem.h \
  /kernel/linux-2.6.32/include/trace/define_trace.h \
  /kernel/linux-2.6.32/include/linux/kmemleak.h \
  /kernel/linux-2.6.32/include/linux/pfn.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/module.h \
    $(wildcard include/config/m586.h) \
    $(wildcard include/config/m586tsc.h) \
    $(wildcard include/config/m586mmx.h) \
    $(wildcard include/config/mcore2.h) \
    $(wildcard include/config/matom.h) \
    $(wildcard include/config/m686.h) \
    $(wildcard include/config/mpentiumii.h) \
    $(wildcard include/config/mpentiumiii.h) \
    $(wildcard include/config/mpentiumm.h) \
    $(wildcard include/config/mpentium4.h) \
    $(wildcard include/config/mk6.h) \
    $(wildcard include/config/mk8.h) \
    $(wildcard include/config/x86/elan.h) \
    $(wildcard include/config/mcrusoe.h) \
    $(wildcard include/config/mefficeon.h) \
    $(wildcard include/config/mwinchipc6.h) \
    $(wildcard include/config/mwinchip3d.h) \
    $(wildcard include/config/mcyrixiii.h) \
    $(wildcard include/config/mviac3/2.h) \
    $(wildcard include/config/mviac7.h) \
    $(wildcard include/config/mgeodegx1.h) \
    $(wildcard include/config/mgeode/lx.h) \
    $(wildcard include/config/4kstacks.h) \
  /kernel/linux-2.6.32/include/asm-generic/module.h \
  /kernel/linux-2.6.32/include/trace/events/module.h \
  /kernel/linux-2.6.32/include/linux/uaccess.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/uaccess.h \
    $(wildcard include/config/x86/wp/works/ok.h) \
    $(wildcard include/config/x86/intel/usercopy.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/uaccess_64.h \
  /kernel/linux-2.6.32/include/linux/sched.h \
    $(wildcard include/config/sched/debug.h) \
    $(wildcard include/config/detect/softlockup.h) \
    $(wildcard include/config/detect/hung/task.h) \
    $(wildcard include/config/core/dump/default/elf/headers.h) \
    $(wildcard include/config/bsd/process/acct.h) \
    $(wildcard include/config/taskstats.h) \
    $(wildcard include/config/audit.h) \
    $(wildcard include/config/inotify/user.h) \
    $(wildcard include/config/epoll.h) \
    $(wildcard include/config/posix/mqueue.h) \
    $(wildcard include/config/keys.h) \
    $(wildcard include/config/user/sched.h) \
    $(wildcard include/config/perf/events.h) \
    $(wildcard include/config/schedstats.h) \
    $(wildcard include/config/task/delay/acct.h) \
    $(wildcard include/config/fair/group/sched.h) \
    $(wildcard include/config/rt/group/sched.h) \
    $(wildcard include/config/blk/dev/io/trace.h) \
    $(wildcard include/config/sysvipc.h) \
    $(wildcard include/config/auditsyscall.h) \
    $(wildcard include/config/rt/mutexes.h) \
    $(wildcard include/config/task/xacct.h) \
    $(wildcard include/config/cpusets.h) \
    $(wildcard include/config/cgroups.h) \
    $(wildcard include/config/futex.h) \
    $(wildcard include/config/fault/injection.h) \
    $(wildcard include/config/latencytop.h) \
    $(wildcard include/config/function/graph/tracer.h) \
    $(wildcard include/config/have/unstable/sched/clock.h) \
    $(wildcard include/config/group/sched.h) \
    $(wildcard include/config/mm/owner.h) \
  /kernel/linux-2.6.32/include/linux/capability.h \
    $(wildcard include/config/security/file/capabilities.h) \
  /kernel/linux-2.6.32/include/linux/rbtree.h \
  /kernel/linux-2.6.32/include/linux/mm_types.h \
    $(wildcard include/config/split/ptlock/cpus.h) \
    $(wildcard include/config/want/page/debug/flags.h) \
    $(wildcard include/config/mmu.h) \
    $(wildcard include/config/aio.h) \
    $(wildcard include/config/mmu/notifier.h) \
  /kernel/linux-2.6.32/include/linux/auxvec.h \
  /kernel/linux-2.6.32/include/linux/prio_tree.h \
  /kernel/linux-2.6.32/include/linux/page-debug-flags.h \
    $(wildcard include/config/page/poisoning.h) \
    $(wildcard include/config/page/debug/something/else.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/cputime.h \
  /kernel/linux-2.6.32/include/asm-generic/cputime.h \
  /kernel/linux-2.6.32/include/linux/sem.h \
  /kernel/linux-2.6.32/include/linux/ipc.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/ipcbuf.h \
  /kernel/linux-2.6.32/include/asm-generic/ipcbuf.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/sembuf.h \
  /kernel/linux-2.6.32/include/linux/signal.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/signal.h \
  /kernel/linux-2.6.32/include/asm-generic/signal-defs.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/siginfo.h \
  /kernel/linux-2.6.32/include/asm-generic/siginfo.h \
  /kernel/linux-2.6.32/include/linux/path.h \
  /kernel/linux-2.6.32/include/linux/pid.h \
  /kernel/linux-2.6.32/include/linux/proportions.h \
  /kernel/linux-2.6.32/include/linux/percpu_counter.h \
  /kernel/linux-2.6.32/include/linux/seccomp.h \
    $(wildcard include/config/seccomp.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/seccomp.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/seccomp_64.h \
  /kernel/linux-2.6.32/include/linux/unistd.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/unistd.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/unistd_64.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/ia32_unistd.h \
  /kernel/linux-2.6.32/include/linux/rculist.h \
  /kernel/linux-2.6.32/include/linux/rtmutex.h \
    $(wildcard include/config/debug/rt/mutexes.h) \
  /kernel/linux-2.6.32/include/linux/plist.h \
    $(wildcard include/config/debug/pi/list.h) \
  /kernel/linux-2.6.32/include/linux/resource.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/resource.h \
  /kernel/linux-2.6.32/include/asm-generic/resource.h \
  /kernel/linux-2.6.32/include/linux/hrtimer.h \
    $(wildcard include/config/high/res/timers.h) \
  /kernel/linux-2.6.32/include/linux/task_io_accounting.h \
    $(wildcard include/config/task/io/accounting.h) \
  /kernel/linux-2.6.32/include/linux/latencytop.h \
  /kernel/linux-2.6.32/include/linux/cred.h \
    $(wildcard include/config/debug/credentials.h) \
    $(wildcard include/config/security.h) \
  /kernel/linux-2.6.32/include/linux/key.h \
    $(wildcard include/config/sysctl.h) \
  /kernel/linux-2.6.32/include/linux/sysctl.h \
  /kernel/linux-2.6.32/include/linux/selinux.h \
    $(wildcard include/config/security/selinux.h) \
  /kernel/linux-2.6.32/include/linux/aio.h \
  /kernel/linux-2.6.32/include/linux/aio_abi.h \
  /kernel/linux-2.6.32/include/linux/uio.h \
  /kernel/linux-2.6.32/include/linux/hardirq.h \
    $(wildcard include/config/virt/cpu/accounting.h) \
  /kernel/linux-2.6.32/include/linux/ftrace_irq.h \
    $(wildcard include/config/ftrace/nmi/enter.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/hardirq.h \
    $(wildcard include/config/x86/mce.h) \
    $(wildcard include/config/x86/mce/threshold.h) \
  /kernel/linux-2.6.32/include/linux/irq.h \
    $(wildcard include/config/s390.h) \
    $(wildcard include/config/irq/per/cpu.h) \
    $(wildcard include/config/irq/release/method.h) \
    $(wildcard include/config/intr/remap.h) \
    $(wildcard include/config/generic/pending/irq.h) \
    $(wildcard include/config/numa/irq/desc.h) \
    $(wildcard include/config/generic/hardirqs/no//do/irq.h) \
    $(wildcard include/config/cpumasks/offstack.h) \
  /kernel/linux-2.6.32/include/linux/irqreturn.h \
  /kernel/linux-2.6.32/include/linux/irqnr.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/irq.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/irq_regs.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/hw_irq.h \
  /kernel/linux-2.6.32/include/linux/profile.h \
    $(wildcard include/config/profiling.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/sections.h \
  /kernel/linux-2.6.32/include/asm-generic/sections.h \
  /kernel/linux-2.6.32/include/linux/suspend.h \
    $(wildcard include/config/vt.h) \
    $(wildcard include/config/vt/console.h) \
    $(wildcard include/config/suspend.h) \
    $(wildcard include/config/hibernation/nvs.h) \
  /kernel/linux-2.6.32/include/linux/swap.h \
    $(wildcard include/config/migration.h) \
    $(wildcard include/config/memory/failure.h) \
    $(wildcard include/config/swap.h) \
    $(wildcard include/config/cgroup/mem/res/ctlr/swap.h) \
  /kernel/linux-2.6.32/include/linux/memcontrol.h \
    $(wildcard include/config/cgroup/mem/cont.h) \
  /kernel/linux-2.6.32/include/linux/cgroup.h \
  /kernel/linux-2.6.32/include/linux/cgroupstats.h \
  /kernel/linux-2.6.32/include/linux/taskstats.h \
  /kernel/linux-2.6.32/include/linux/prio_heap.h \
  /kernel/linux-2.6.32/include/linux/idr.h \
  /kernel/linux-2.6.32/include/linux/cgroup_subsys.h \
    $(wildcard include/config/cgroup/debug.h) \
    $(wildcard include/config/cgroup/ns.h) \
    $(wildcard include/config/cgroup/sched.h) \
    $(wildcard include/config/cgroup/cpuacct.h) \
    $(wildcard include/config/cgroup/device.h) \
    $(wildcard include/config/cgroup/freezer.h) \
    $(wildcard include/config/net/cls/cgroup.h) \
  /kernel/linux-2.6.32/include/linux/node.h \
  /kernel/linux-2.6.32/include/linux/sysdev.h \
  /kernel/linux-2.6.32/include/linux/mm.h \
    $(wildcard include/config/stack/growsup.h) \
    $(wildcard include/config/debug/pagealloc.h) \
  /kernel/linux-2.6.32/include/linux/debug_locks.h \
    $(wildcard include/config/debug/locking/api/selftests.h) \
  /kernel/linux-2.6.32/arch/x86/include/asm/pgtable.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/pgtable_64.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/pgtable_64_types.h \
  /kernel/linux-2.6.32/include/asm-generic/pgtable.h \
  /kernel/linux-2.6.32/include/linux/page-flags.h \
    $(wildcard include/config/pageflags/extended.h) \
    $(wildcard include/config/have/mlocked/page/bit.h) \
    $(wildcard include/config/arch/uses/pg/uncached.h) \
  /kernel/linux-2.6.32/include/linux/vmstat.h \
    $(wildcard include/config/vm/event/counters.h) \
  /kernel/linux-2.6.32/include/linux/kbuild.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/ia32.h \
    $(wildcard include/config/ia32/support.h) \
  /kernel/linux-2.6.32/include/linux/compat.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/compat.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/user32.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/sigcontext32.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/suspend.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/suspend_64.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/desc.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/ldt.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/i387.h \
  /kernel/linux-2.6.32/include/linux/kernel_stat.h \
  /kernel/linux-2.6.32/include/linux/interrupt.h \
    $(wildcard include/config/generic/irq/probe.h) \
    $(wildcard include/config/debug/shirq.h) \
  /kernel/linux-2.6.32/include/linux/regset.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/xsave.h \
  /kernel/linux-2.6.32/include/xen/interface/xen.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/xen/interface.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/xen/interface_64.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/pvclock-abi.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/sigframe.h \
  /kernel/linux-2.6.32/arch/x86/include/asm/ucontext.h \
  /kernel/linux-2.6.32/include/asm-generic/ucontext.h \

arch/x86/kernel/asm-offsets.s: $(deps_arch/x86/kernel/asm-offsets.s)

$(deps_arch/x86/kernel/asm-offsets.s):
