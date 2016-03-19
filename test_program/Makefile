CFLAGS=-march=i386 -m32

SRCS=$(wildcard *.c)
PROGS=$(patsubst %.c,%,$(SRCS))

all: $(PROGS)

%: %.c
	gcc $(CFLAGS) -o $@ $^
	
