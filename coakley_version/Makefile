PROG=prog1
CC=g++
CPPFLAGS=-g -Wall -std=c++11

.PHONY: all

all:
	$(CC) $(CPPFLAGS) main.cpp trie.cpp -o $(PROG)

clean:
	rm -f *.o $(PROG) core
