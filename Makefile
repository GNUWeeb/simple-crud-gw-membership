# SPDX-License-Identifier: GPL-2.0

RM = rm
CC = gcc
CFLAGS = -Wall -Wextra

all: main

main.o: main.S
	$(CC) $(CFLAGS) -c $(^) -o $(@)

main: main.o
	$(CC) $(CFLAGS) -nostartfiles -static $(^) -o $(@)

clean:
	$(RM) -vf main.o main
