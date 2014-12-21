CC=g++
CFLAGS=-std=c++11 -I../include
LDFLAGS=-lcrypto -lssl

all:
	$(CC) $(CFLAGS) -c -o client.o client.c
	$(CC) -o client ../CMakeFiles/nibblerd.dir/src/message.cpp.o client.o $(LDFLAGS)

clean:
	rm -f client client.o
