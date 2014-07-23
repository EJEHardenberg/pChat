#Configurations and setup
CC = cc
CFLAGS = -std=gnu99 -pedantic -Wall -Wextra -Werror -g -I./headers
LINKFLAGS = $(CFLAGS)
LIBS = lib/wolkykim-qdecoder-63888fc/src/libqdecoder.a

INTERNAL = fasthash

#Use Phony to keep clean
.PHONY: clean 

OBJECTS := $(patsubst src/%.c,obj/%.o,$(wildcard src/*.c))
TARGETS := $(patsubst src/%.c,bin/%.cgi,$(wildcard src/*.c))
     
#Commands to help test and run programs:	
valgrind = valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes

all: ${TARGETS}

$(TARGETS): $(OBJECTS) $(INTERNAL)
	${CC} ${LINKFLAGS} -o $@ $(patsubst bin/%.cgi, obj/%.o, $@ ) $(patsubst %, obj/%.o, $(INTERNAL)) ${LIBS}

$(INTERNAL):
	${CC} ${CFLAGS} -c src/internal/$@.c -o obj/$@.o 

clean:
	rm -f obj/*.o ${TARGETS}

$(OBJECTS): obj/%.o : src/%.c
	${CC} ${CFLAGS} -c -o $@ $<

config:
	-@mv ./headers/config.h ./headers/config.h.bak
	cp ./headers/sample-config.h ./headers/config.h && vi ./headers/config.h

