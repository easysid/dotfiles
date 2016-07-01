CC      ?= gcc
CFLAGS  += -march=native -O2 -pedantic -Wall -Wextra -Werror

DESTDIR = $(HOME)/.scripts/

all: sysinfo mpdinfo

sysinfo: sysinfo.c config.h
	$(CC) $(CFLAGS) $@.c -o $@

mpdinfo: mpdinfo.c config.h
	$(CC) $(CFLAGS) $@.c -o $@ -lmpdclient

install: all
	install -m 0755 sysinfo $(DESTDIR)
	install -m 0755 mpdinfo $(DESTDIR)

clean:
	-rm -vf sysinfo mpdinfo

.PHONY: all clean install
