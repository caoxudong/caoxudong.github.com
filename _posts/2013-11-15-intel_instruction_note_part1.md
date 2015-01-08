---
category:   pages
layout:     post
tags:       [assembly, intel]
---


intel汇编指令，笔记，part1，控制转换指令
================


>内容来自[Intel 64 and IA-32 Architectures Software Developer][1]

# 控制转换指令

控制转换指令包括了 **跳转**、**条件跳转**、**循环**和**调用**几种操作，用以控制程序流转，具体包含以下指令：

    instruction     jump condition              description
    
    JMP                                         跳转（Jump）
    JA/JNBE         (CF or ZF) = 0              无符号条件跳转，大于则跳转/不小于等于时跳转（Jump if above/Jump if not below or equal）
    JAE/JNB         CF = 0                      无符号条件跳转，大于等于则跳转/不小于时跳转（Jump if above or equal/Jump if not below）
    JB/JNAE         CF = 1                      无符号条件跳转，小于则跳转/不大于等于时跳转（Jump if below/Jump if not above or equal）
    JBE/JNA         (CF or ZF) = 1              无符号条件跳转，小于等于时跳转/不大于时跳转（Jump if below or equal/Jump if not above）
    JC              CF = 1                      无符号条件跳转，如果进位则跳转（Jump if carry）
    JE/JZ           ZF = 1                      无符号条件跳转，相等则跳转/为零则跳转（Jump if equal/Jump if zero）
    JNC             CF = 0                      无符号条件跳转，如果没进位则跳转（Jump if not carry）
    JNE/JNZ         ZF = 0                      无符号条件跳转，不等则跳转/不为零则跳转（Jump if not equal/Jump if not zero）
    JPO/JNP         PF = 0                      无符号条件跳转，如果二进制表示中1的个数为奇数则跳转（Jump if parity odd/Jump if not parity）
    JPE/JP          PF = 1                      无符号条件跳转，如果二进制表示中1的个数为偶数则跳转（Jump if parity even/Jump if parity）
    JCXZ            CX = 0                      无符号条件跳转，寄存器CX为0时跳转（Jump register CX zero）（注，寄存器CX一般作为计数器使用，例如用于循环）
	JECXZ           ECX = 0                     无符号条件跳转，寄存器ECX为0时跳转（Jump register ECX zero）（同上）
    
	JG/JNLE         ((SF xor OF) or ZF) = 0     有符号条件跳转，大于则跳转/不小于则跳转（Jump if greater/Jump if not less or equal）
	JGE/JNL         (SF xor OF) = 0             有符号条件跳转，大于等于则跳转/不小于则跳转（Jump if greater or equal/Jump if not less）
    JL/JNGE         (SF xor OF) = 1             有符号条件跳转，小于则跳转/不大于则跳转（Jump if less/Jump if not greater or equal）
    JLE/JNG         ((SF xor OF) or ZF) = 1     有符号条件跳转，小于等于则跳转/不大于则跳转（Jump if less or equal/Jump if not greater）
    JO              OF = 1                      有符号条件跳转，如果溢出则跳转（Jump if overflow）
    JNO             OF = 0                      有符号条件跳转，如果没溢出则跳转（Jump if not overflow）
    JS              SF = 1                      有符号条件跳转，如果是负数则跳转（Jump if sign (negative)）
    JNS             SF = 0                      有符号条件跳转，如果是非负数则跳转（Jump if not sign (non-negative)）
    
    LOOP            ECX != 0                    ECX不为0时循环（Loop with ECX counter）
    LOOPZ/LOOPE     ECX != 0 and ZF = 1         ECX不为零且标志Z=1时循环（Loop with ECX and zero/Loop with ECX and equal）
    LOOPNZ/LOOPNE   ECX != 0 and ZF = 0         ECX不为零且标志Z=0时循环（Loop with ECX and not zero/Loop with ECX and not equal）
    
    CALL                                        调用过程（Call procedure）
    RET                                         函数返回（Return）
    IRET                                        从中断返回（Return from interrupt）
    INT                                         软中断（Software interrupt）
    INTO                                        （Interrupt on overflow）
    BOUND                                       检查是否越界（Detect value out of range）
    ENTER                                       （High-level procedure entry）
    LEAVE                                       （High-level procedure exit）

>条件跳转指令的跳转条件中，标志位的作用请看[这里][2])。





[1]:    http://www.intel.cn/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-manual-325462.pdf
[2]:    ./the_intel_microprocessors_note_1#special_registers
