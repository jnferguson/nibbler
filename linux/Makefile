EXTRA_CFLAGS := -I$(src)/include
TARGET := nbdev
nbdev-objs := src/net.o src/char.o src/main.o src/thread.o
obj-m := $(TARGET).o


all: app.o
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

app.o:
	$(CC) -Iinclude -o app src/app.c

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
