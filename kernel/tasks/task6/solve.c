#define _GNU_SOURCE
#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>
#include <liburing.h>
#include <pthread.h>

#include <sys/capability.h>
#include <sys/msg.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <sys/xattr.h>
#include <sys/ioctl.h>
#include <sys/prctl.h>

#include <linux/capability.h>
#include <linux/types.h>

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

uint64_t user_rip, user_cs, user_ss, user_rsp, user_rflags;

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
        ".att_syntax prefix;"
    );
    user_rip = (uint64_t)(uintptr_t)get_shell;

}

int main() {
    return 0;
}