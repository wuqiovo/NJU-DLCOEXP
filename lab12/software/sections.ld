OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
    IMEM (rx)  : ORIGIN = 0x00000000, LENGTH = 256K
    DMEM (rwx) : ORIGIN = 0x00100000, LENGTH = 128K
}

SECTIONS
{
    .text : ALIGN(4)
    {
        KEEP(*(.text.entry))
        *(.text*)
    } > IMEM

    .rodata : ALIGN(4)
    {
        *(.rodata*)
        *(.srodata*)
    } > DMEM

    .data : ALIGN(4)
    {
        *(.data*)
        *(.sdata*)
    } > DMEM

    .bss (NOLOAD) : ALIGN(4)
    {
        __bss_start = .;
        *(.bss*)
        *(.sbss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .;
    } > DMEM

    __heap_start = ALIGN(16);
    __stack_top  = ORIGIN(DMEM) + LENGTH(DMEM);
}