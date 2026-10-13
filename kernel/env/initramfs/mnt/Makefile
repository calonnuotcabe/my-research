obj-m += hello-1.o
obj-m += vuln.o
KDIR ?= ../../linux-2.6.32 
PWD = $(CURDIR)

all: 
	$(MAKE) -C $(KDIR) M=$(PWD) ARCH=x86 modules
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) ARCH=x86 clean
