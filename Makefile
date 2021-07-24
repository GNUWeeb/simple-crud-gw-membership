# SPDX-License-Identifier: GPL-2.0
#
# @author Ammar Faizi <ammarfaizi2@gmail.com> https://www.facebook.com/ammarfaizi2
# @license GNU GPL-2.0
#
# Copyright (C) 2021  Ammar Faizi
#

RM = rm
CC = gcc
CFLAGS = -Wall -Wextra

all: main

src/const.o: src/const.c
	$(CC) $(CFLAGS) -c $(^) -o $(@)

src/const: src/const.o
	$(CC) $(CFLAGS) $(^) -o $(@)

src/__const.S: src/const
	src/const > src/__const.S

src/main.S: src/__const.S


src/main.o: src/main.S
	$(CC) $(CFLAGS) -c $(<) -o $(@)

main: src/main.o
	$(CC) $(CFLAGS) -nostartfiles -static $(^) -o $(@)

clean:
	$(RM) -vf main src/main.o src/const.o
