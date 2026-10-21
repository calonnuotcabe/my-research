COMPOSE := docker compose
SERVICE := maria
CONTAINER_DIR := /home/user
GUEST_ROOT := share/initramfs
EXPLOIT_SRC := $(GUEST_ROOT)/exploit.c
EXPLOIT_BIN := $(GUEST_ROOT)/exploit

.PHONY: build exploit pack up shell run logs down clean restart

exploit: $(EXPLOIT_BIN)

$(EXPLOIT_BIN): $(EXPLOIT_SRC)
	gcc -O0 -g -Wall -Wextra -Werror -static -std=c2x -o $@ $<

pack: exploit
	(cd $(GUEST_ROOT) && find . -print0 | LC_ALL=C sort -z | \
		cpio --null --create --format=newc --owner=0:0) | gzip -9n > share/initramfs.cpio.gz

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d --build

shell: up
	$(COMPOSE) exec $(SERVICE) bash

run: pack up
	@echo "[+] Serial console"
	nc 127.0.0.1 30002

logs:
	$(COMPOSE) logs -f

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --rmi local --volumes --remove-orphans
