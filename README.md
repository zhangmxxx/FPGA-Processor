# FPGA-Processor

## 项目概述

本项目为南京大学数字逻辑与计算机组成实验课程的期末课程作业. 基于`xc7a100tcsg324-1`开发板实现并运行了RISCV32计算系统.

## 项目功能

- 实现支持25MHz时钟主频的处理器
- 实现支持ANSI颜色控制码的字符显存
- 实现数码管, LED灯的外设支持
- 移植AM中的klib, 支持常用库函数的使用
- 移植dhrystone跑分程序, 对cpu性能进行评估
- 内建终端支持回删, 滚屏, capslock按键支持, 能够解析命令
- 实现登录界面, 能够对密码输入等行为进行响应

## 运行

1. 配置`riscv32-unknown-elf`工具链[(link)](https://github.com/riscv-collab/riscv-gnu-toolchain), 使用如下命令进行工具链的编译

```shell
../configure --prefix=/opt/riscv32 --with-arch=rv32i --with-abi=ilp32
make
```

2. 在software目录下键入`make` , 以生成程序的代码段`main.coe` 和数据段`main_d.coe`
3. 将`main.coe`内容拷贝到`imem`中, 将`main_d.coe`内容拷贝到`dmem`中
4. 在`coe_generate/src.txt`中绘制图形(注意每一行必须严格保证为70字符, 包括空格), 必要时可在`main.cpp`中对颜色的分配进行修改. 随后编译运行`main.cpp`(基于主机的环境)即可得到字符显存和颜色显存的初始化文件`char_out.coe`和`color_out.coe`
5. 将`char_out.coe`拷贝到`char_buf`中,  将`color_out.coe`拷贝到`color_buf`中
6. 生成二进制文件并编程主板

## 工程目录结构

```SCSS
.
├── hardware
│   ├── asm-test                  // 汇编语言实现的键盘, vga模块测试代码
│   │   ├── kbd-test.asm
│   │   └── vga-test.asm
│   ├── coefficient               // 存储器的初始化文件, 约束文件以及字模
│   │   ├── char_init.coe			  
│   │   ├── color_init.coe
│   │   ├── data.coe
│   │   ├── inst.coe
│   │   ├── nexysa7.xdc
│   │   └── vga_font.txt
│   └── source
│       ├── ip                    // Vivado生成的ip核文件
│       │   ├── char_buf
│       │   ├── clk_wiz_0
│       │   ├── clk_wiz_0_1
│       │   ├── clk_wiz_1
│       │   ├── color_buf
│       │   ├── d_mem
│       │   └── imem
│       └── new                   // 模块verilog实现
│           ├── ALU.v
│           ├── bcd7seg.v
│           ├── clk_gen.v
│           ├── cpu.v
│           ├── ctrl_gen.v
│           ├── dmem.v
│           ├── imm_gen.v
│           ├── pc_gen.v
│           ├── Processor.v
│           ├── ps2_keyboard.v
│           ├── regfile.v
│           ├── segdisplay.v
│           ├── testclk.v
│           ├── testdmem.v
│           ├── vga_ascii.v
│           └── vga_ctrl.v
├── README.md
└── software
    ├── built-in-app.c            // 内建终端支持的较为复杂的应用程序
    ├── built-in-app.h
    ├── dry.c                     // dhrystone跑分程序
    ├── key-def.h                 // 键码相关定义
    ├── klib.h						 
    ├── klib-stdio.c				 
    ├── klib-stdlib.c
    ├── klib-string.c
    ├── main.c
    ├── Makefile
    ├── mul.c                     // rv32i乘除法链接源码
    ├── sections.ld
    ├── sys.c                     // 底层api实现
    ├── sys.h
    ├── terminal.c                // 内建终端
    └── terminal.h
```

