obj-m := vuln.o

EXTRA_CFLAGS += -I$(src)
KERNEL_SRC ?= /kernel/linux-2.6.32
KERNEL_OUT ?= $(CURDIR)/../kernel-build

all:
	$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) M=$(CURDIR) modules

clean:
	$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) M=$(CURDIR) clean
