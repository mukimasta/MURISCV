# MURISCV
基于 FPGA 的 RISC-V 处理器设计

## 设计介绍
RISC-V 是一个基于精简指令集(RISC)原则的开源指令集架构(ISA)。本次设计基于 RISC-V 指令集架构，完成了一个简单的 RISC-V 单周期处理器，实现了大部分 RV32I 的指令，包括算术逻辑指令、移位指 令、访存指令、分支跳转指令、比较指令、无条件跳转指令等。
本次设计使用 Verilog 语言进行设计，使用 Vivado 进行综合，使用 ALINX 黑金 AX7010 开发板的 PL 部分(ZYNQ-7000)上板验证。

## 设计框图

![绘制框图](/figs/frame.png)

![Vivado框图](/figs/MU_CPU.png)

## 设计结果
用设计的处理器计算斐波那契数列。具体测试为：计算斐波那契数列的第 30 项，与实际值比对，若相等则测试通过，将寄存器 x10, x11 都设置为 1，若测试未通过，则将寄存器 x10 设置为 1，x11 寄存器设置为 0

![仿真结果](/figs/wave.png)

![上板结果](/figs/board.jpg)

学习、参考资料
• RISC-V 官方文档:https://riscv.org/technical/specifications/
• RISC-V 中文手册:http://www.riscvbook.com/chinese/RISC-V-Reader-Chinese-v2p1.pdf
• tinyriscv 项目:https://github.com/liangkangnan/tinyriscv
•《图灵完备》游戏:https://store.steampowered.com/app/1444480/Turing_Complete/?l=schinese 
• HDL_Bits:https://hdlbits.01xz.net/wiki/Main_Page
• (拓展资源)“一生一芯”项目:https://ysyx.oscc.cc/
