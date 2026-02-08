# Basics and Overview of Clock Data Recovery (CDR)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 01:55 on 2026-01-22 in Lincang.
> dingyi233@mails.ucas.ac.cn


## Introduction

在挺久之前 (半年前)，我们曾大致介绍过时钟数据恢复 (Clock Data Recovery, CDR) 的基本概念和工作原理，详见文章 [Basics of Clock Data Recovery (CDR)](<AnalogIC/Basics of Clock Data Recovery (CDR).md>)。但当时一方面对 PLL 和 frequency synthesizer 的理解还不够深入，另一方面对 CDR 的具体实现和设计挑战也没有全面的认识，因此内容比较浅显。

最近做完 ultra-low-power (500 nA) sub-MHz CP-PLL 项目之后，终于开始正式向 CDR 和 Serdes 迈进。基于下面几篇 CDR 的前置文章，本文就来重新梳理一下 CDR 的基本概念、工作原理、常见架构和部分进阶内容，为后续的 CDR 设计项目 [A 56-Gbuad PAM3 CDR (84 Gbps, 14 GHz) in TSMC 28nm Technology](<A 56-Gbuad PAM3 CDR (84 Gbps, 14 GHz) in TSMC 28nm Technology>) 提供理论基础和参考：
- [Basics of Clock Data Recovery (CDR)](<AnalogIC/Basics of Clock Data Recovery (CDR).md>)
- [Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals](<AnalogIC/Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.md>)
- [Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles](<AnalogIC/Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.md>)





## 2. Edge Detection CDR

### 2.1 edge-detection circuit

### 2.2 edge-detection CDR

xxx

## 3. Phase-Locking CDR

### 3.1 PD for PLL or CDR?

几种较常用的 PD for PLL 是：
- XOR PD (the simplest one)
- tri-state PFD (the most common one)
- mixer (analog multiplier, for sine input only)
- D-FF PD (basic bang-bang PD)

它们各自具有不同的频差 $(\Delta f)$ 和相差 $(\Delta \phi)$ 特性，一般说的输入输出特性都是指相差特性 (with the same frequency)，频差特性一般用于 PLL 的频率捕获过程分析。


对于 CDR 而言，上述鉴相器基本都没法使用，因为 CDR 的输入并非 periodic的连续时钟信号，而是非周期的数据信号 (DATA)，通常用 **PRBS (pseudo-random binary sequence)** 或者 run-length-limited PRBS 来模拟，后者其实就是限制了连续 0 或 1 最大长度的 PRBS (by encoding).


下面是一些常见的 phase detector (PD) for CDR:
- bang-bang (binary):
    - DFF PD (the simplest one, note that DATA samples CK)
    - Alexander PD
    - Pottbacker PD
- linear:
    - Hogge PD
    - Mueller-Muller PD



### 3.2 DFF PD (binary)
### 3.3 Alexander PD (binary)
### 3.4 Hogge PD (linear)
### 3.5 BB-CDR summary

这里放三种基本架构的图片总结


## 4. Data Swing Issues

## 5. Advanced CDR Techniques
### 5.1 half-rate PD
### 5.2 OSC-less CDR

## 5. Digital or Analog?

前几节可以看出，CDR 中使用了许多数字电路方面的模块和技术，如 XOR gate, D flipflop, Alexander PD 的时序对齐等。其实，在数据速率不高的情况下 (100 Mbps ~ 2 Gbps)，这些模块都可看作纯粹的 CMOS 数字电路，可以用标准 CMOS 数字单元 (standard CMOS digital cell) 来实现；但是当数据速率达到数 Gbps 甚至数十 Gbps 以上时，CMOS 逻辑电路的速度和性能就无法满足要求了，模块的带宽 (工作频率) 很难达到这么高，此时就必须引入其它高速逻辑电平，如 LVDS, LVPECL 和 CML 等，来实现这些模块 (高速 Serdes 中最常用的是 CML - current mode logic)。

以最常见的 Gated D-Latch 为例 (DFF 由两个 Gated D-Latch 组合而成)，在常规数字电路中，D-Latch 通常直接由 NAND gate 或 NOR gate 组合而成，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-22-14-40-14_Basics and Overview of Clock Data Recovery (CDR).png"/></div>

在高速和亚稳态 (例如 DFF 的 input data 在上升过程中就遇到 CK 上升沿，发生 "采样") 限制下，上述数字电路的性能就会大打折扣，性能大打折扣甚至不能正常工作，此时就需要用从模拟的角度来设计这些模块，或者使用 CML (current mode logic) CMOS 来实现。





## Reference