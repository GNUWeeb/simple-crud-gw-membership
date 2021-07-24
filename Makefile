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

main.o: main.S
	$(CC) $(CFLAGS) -c $(^) -o $(@)

main: main.o
	$(CC) $(CFLAGS) -nostartfiles -static $(^) -o $(@)

clean:
	$(RM) -vf main.o main
