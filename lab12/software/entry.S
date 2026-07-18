    .option norvc
    .section .text.entry
    .globl _start

_start:
    # dmem 范围为 0x00100000-0x0011ffff，栈从末端向低地址增长。
    la   sp, __stack_top

    # 清零 .bss，使未显式初始化的全局变量符合 C 语言语义。
    la   t0, __bss_start
    la   t1, __bss_end

.Lclear_bss:
    bgeu t0, t1, .Lbss_done
    sw   zero, 0(t0)
    addi t0, t0, 4
    j    .Lclear_bss

.Lbss_done:
    call main

.Lhalt:
    j .Lhalt