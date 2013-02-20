CC = gcc
CFLAGS += $(shell pkg-config --cflags glib-2.0 jansson)
CFLAGS += $(shell curl-config --cflags)
CFLAGS += -I$(shell pwd)
LDFLAGS += $(shell pkg-config --libs glib-2.0 jansson) 
LDFLAGS += $(shell curl-config --libs)

SOURCES = channel.c \
	  curl_wrap.c \
	  irc.c \
	  log.c \
	  main.c \
	  network.c \
	  session.c \
	  user.c \
	  config.c


ifeq ($(OS),Windows_NT)
SOURCES += socket_win.c
else
SOURCES += socket_unix.c
endif

ifdef DEBUG
	DEBUGFLAG = -g
endif

WARNINGFLAGS = -Wall

OBJECTS    = $(SOURCES:.c=.o)

all: irc-client modules

irc-client : $(OBJECTS) modules
	$(CC) $(DEBUGFLAG) $(LDFLAGS) *.o -o irc-client

.c.o:
	$(CC) -c $(DEBUGFLAG) $(WARNINGFLAGS) $(CFLAGS) $< -o $@

clean:
	rm -f irc-client *.o

.PHONY: modules

modules:
		$(MAKE) --directory=$@
