CC:=i586-elf-gcc
AS:=i586-elf-as
OBJS:=boot.o kernel.o
 
CRTI_OBJ=crti.o
CRTBEGIN_OBJ:=$(shell $(CC) $(CFLAGS) -print-file-name=crtbegin.o)
CRTEND_OBJ:=$(shell $(CC) $(CFLAGS) -print-file-name=crtend.o)
CRTN_OBJ=crtn.o
 
OBJ_LINK_LIST:=$(CRTI_OBJ) $(CRTBEGIN_OBJ) $(OBJS) $(CRTEND_OBJ) $(CRTN_OBJ)
INTERNAL_OBJS:=$(CRTI_OBJ) $(OBJS) $(CRTN_OBJ)

all: iso

$(CRTI_OBJ): crti.s
	$(AS) crti.s -o $(CRTI_OBJ)

$(CRTN_OBJ): crtn.s
	$(AS) crtn.s -o $(CRTN_OBJ)
 
boot.o: boot.s
	$(AS) boot.s -o boot.o

kernel.o: kernel.c
	$(CC) $(CFLAGS) -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

lubb.bin: $(OBJ_LINK_LIST)
	$(CC) $(CFLAGS) -T linked.ld -o lubb.bin -ffreestanding -O2 -nostdlib -lgcc $(OBJ_LINK_LIST)

iso: lubb.bin
	mkdir -p isodir/boot/grub
	cp grub.cfg isodir/boot/grub
	cp lubb.bin isodir/boot
	grub-mkrescue -o lubb.iso isodir

clean:
	rm -rf lubb.bin $(INTERNAL_OBJS) isodir *.iso
