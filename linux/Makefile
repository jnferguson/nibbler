ccflag-t += -Wpadded
obj-m += nbdev.o

all:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
    gcc -o app app.c
clean:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
