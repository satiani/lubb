# Declare constants used for creating a multiboot header, these are read by the
# bootloader, and provide an interface between the bootloader and the operating
# system kernel
.set ALIGN,         1<<0
.set MEMINFO,       1<<1
.set FLAGS,         ALIGN | MEMINFO
.set MAGIC,         0x1BADB002
.set CHECKSUM,      -(MAGIC + FLAGS)

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .bootstrap_stack
stack_bottom:
.skip 16384 #16 KB
stack_top:

.section .text
.global _start
.type _start, @function
_start:
    movl $stack_top, %esp
    call kernel_main
    cli
    hlt
.Lhang:
    jmp .Lhang

.size _start, . - _start
