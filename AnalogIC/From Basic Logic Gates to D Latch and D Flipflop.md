# The Differences Between Latch and Flipflop (D Latch vs. D Flipflop)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 23:52 on 2025-10-23 in Beijing.

## 1. Introduction

在混合信号集成电路设计中，D Flipflop (D 触发器) 是最基本的时序元件之一，但多数资料/文章/论文/应用中并不严格区分 D Latch 和 D Flipflop 的概念，常常令人摸不着头脑。本文就来详细介绍如何搭建 D Latch 和 D Flipflop，对两者进行仿真对比，以此剖析它们的区别。

由于 D Latch 或者 D Flipflop 的搭建 (通常) 都使用 SR Latch 作为基础单元，因此理解 SR Latch 的工作原理对于掌握 D Latch 和 D Flipflop 至关重要。而在 SR Latch 之前，我们不妨过一下 CMOS 基本逻辑门的电路实现。


## 1. Basic CMOS Logic Gates

### 1.1 Overview

从电路实现的角度来讲，CMOS 的基本逻辑门一共有四个，其它所有逻辑门/组合电路都是由它们组合而成：
- (1) inverter (INV) (非门, 也称为 NOT)
- (2) NAND (与非门)
- (3) NOR (或非门)
- (4) TG/PG (Transmission Gate / Pass Gate)

这四个基本逻辑门的最简电路实现如下 (所用管子最少)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-24-15-54-41_The Differences Between Latch and Flipflop (D Latch vs. D Flipflop).png"/></div>

**<span style='color:red'> 图中指出了 TG (Transmission Gate) = PG (Pass Gate), 我们稍后解释原因。 </span>**

剩余的 AND, OR 等 "基础" 逻辑门都可以由上述基本逻辑门组合而成，下面给出两种实现 XOR/XNOR 的示例，一种是 TG-based, 另一种是 transistor-based:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-24-14-48-26_The Differences Between Latch and Flipflop (D Latch vs. D Flipflop).png"/></div>



### 1.2 More on TG/PG

<!-- 尽管我们在电路图中标出了 Pass Gate 两个管子的 source, 但由于 MOSFET 的对称性，source 和 drain 一定程度上可以互换 (特殊工艺除外)，使得 TG/PG 在 EN = 1 时是双向导通的 (A 和 Y 都可作为驱动源)。 -->

为什么我们说 TG 和 PG 是 **完全等价** 的呢？这是因为在常规 CMOS 工艺中, source 和 drain 完全对称，此时原理图上的符号标注并不是绝对的 source/drain, 而是取决于管子两端的电压高低。例如对于 NMOS, 电压高的一端就是 drain, 低的一端就是 source, 在此基础上才能利用 Vgs 和 Vds 来分析管子的工作状态。


传输门 (TG) 的具体分析可以参考文章 [[1] Analog Circuit Design > Digital > Transmission gates](https://analogcircuitdesign.com/transmission-gates-working-circuit-and-applications/), 这里仅给出关键结论：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-24-14-52-13_The Differences Between Latch and Flipflop (D Latch vs. D Flipflop).png"/></div>

事实上，传输门 TG 在工作时，为了满足 NMOS Vds > 0 和 PMOS Vsd > 0 的要求，管子的实际工作状态是按 PG 图中所示的那样形成的。不妨作出图像，仔细分析 TG/PG 在 EN = 0 和 EN = 1 时的工作状态：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-24-14-58-12_The Differences Between Latch and Flipflop (D Latch vs. D Flipflop).png"/></div>

由此得出结论，导通状态下的 TG/PG 完全可以当作一根导线或者一个阻值较低的电阻；关断状态下 TG/PG 则表现出完全阻断 (完全开路) 的特性，此时支路中仅有极低的漏电流 (off-state leakage current) 存在。


在 ONC 180nm CMOS (onc18) 库中进行仿真验证：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-24-15-50-13_The Differences Between Latch and Flipflop (D Latch vs. D Flipflop).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-24-15-49-33_The Differences Between Latch and Flipflop (D Latch vs. D Flipflop).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-24-15-52-24_The Differences Between Latch and Flipflop (D Latch vs. D Flipflop).png"/></div>

仿真结果与我们预测的类似，无论 EN = 0 or 1, 无论输入端在 A 还是 Y, TG/PG 都表现出 **完全相同** 的特性： **EN = 1 时两端短路 (低阻态)，EN = 0 时两端开路 (高阻态)** 。

在后文，我们将不再区分 TG 和 PG, 统一使用 TG 来表示。

## 2. SR Latch/Flipflop

本小节参考文章 [[2] Analog Circuit Design > Digital > SR Latch and SR Flip-Flop](https://analogcircuitdesign.com/sr-latch-and-sr-flip-flop/)。

### 2.1 SR Latch

SR Latch (Set-Reset Latch) 是一种基本的时序存储单元，可以存储 1 bit 的信息 (1-bit memory cell), 其两个输入端 S (Set) 和 R (Reset) 可以控制输出端 Q 和 Q' 的状态，从而实现数据的存储和保持。

SR Latch 的基本电路实现有 NOR-based 和 NAND-based 两种，分别对应 negative-hold (00-hold) 和 positive-hold (11-hold) 两种：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-24-16-49-12_The Differences Between Latch and Flipflop (D Latch vs. D Flipflop).png"/></div>

### 2.2 Gated SR Latch

加入使能信号 EN 后，变成 Gated SR Latch:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-24-19-25-22_The Differences Between Latch and Flipflop (D Latch vs. D Flipflop).png"/></div>

具体的波形示例可以看文章 [[5] 知乎 > 深入理解锁存器：SR 锁存器、门控 SR 锁存器、门控 D 锁存器介绍](https://zhuanlan.zhihu.com/p/1938209046684505714)。

### 2.3 SR Flipflop

Flipflop (触发器)，是一种由边沿信号 (上升/下降沿) 控制的时序存储单元，而 Latch (锁存器) 则是由电平信号 (高/低电平) 控制。

一般情况下，也是最简单的实现方式，是将两个 Gated Latch 级联到一起，构成 Master-Slave 结构，从而实现边沿触发的 SFlipflop. 例如两个 Gated SR Latch 级联成 Master-Slave SR Latch = SR Flipflop, 或者两个 Gated D Latch 级联成 Master-Slave D Latch = D Flipflop.

Master-Slave 结构的工作原理是：当时钟信号 CLK 为高电平时，Master 级 (第一级) 的 Latch 处于透明状态，输入数据可以传递到 Master 级的输出端；而 Slave 级 (第二级) 的 Latch 处于锁存状态，保持其之前的输出状态。当 CLK 信号从高电平变为低电平时，Master 级的 Latch 锁存当前输入数据，而 Slave 级的 Latch 则进入透明状态，将 Master 级的输出传递到最终输出端。

下面是 SR Flipflop 的电路示例：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-24-19-56-10_The Differences Between Latch and Flipflop (D Latch vs. D Flipflop).png"/></div>

## 3. D Latch/Flipflop

SR Latch/Flipflop 最大的缺点之一，就是存在 "forbidden stage", 也即不允许的输入状态。以 NAND-based SR Latch 为例，当 S = R = 1 时，输出 Q 和 Q' 都为 0, 此时如果 S 和 R 同时变为 0, 电路会出现 **"竞争"**，使输出状态变得不可预测，这种不可预测的输出常常会带来致命的问题。

为了解决这个问题，人们基于 SR Latch 设计了 D Latch/Flipflop, 它只有一个数据输入端 D, 避免了 SR Latch 中的 forbidden state. 

### 3.1 (Gated) D Latch

(Gated) D Latch 的几种基本电路实现如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-24-21-15-23_The Differences Between Latch and Flipflop (D Latch vs. D Flipflop).png"/></div>

### 3.2 D Flipflop

与 SR Flipflop 类似，D Flipflop 也是通过级联两个 Gated D Latch 构成 Master-Slave 结构来实现边沿触发：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-24-21-26-46_The Differences Between Latch and Flipflop (D Latch vs. D Flipflop).png"/></div>

## 4. Summary

这里放一张总结：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-18-19-39_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>


## 5. Further Reading

### 5.1 DFF implementations

下面收集了各种 DFF 的实现方式，供参考：



<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | [Circuit Diagram > Home > Wiring > Negative Edge Triggered D Flip Flop Circuit Diagram](https://www.circuitdiagram.co/negative-edge-triggered-d-flip-flop-circuit-diagram/) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-23-34-43_From Basic Logic Gates to D Latch and D Flipflop.png"/></div> | [Circuit Diagram > Home > Wiring > Negative Edge Triggered D Flip Flop Circuit Diagram](https://www.circuitdiagram.co/negative-edge-triggered-d-flip-flop-circuit-diagram/) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-23-35-44_From Basic Logic Gates to D Latch and D Flipflop.png"/></div> |  |
 | [Pass-Transistor-Based Negative-Edge-Triggered D-Flipflop (PTDFF)](https://www.ijera.com/papers/Vol4_issue4/Version%203/J044037073.pdf) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-23-55-50_From Basic Logic Gates to D Latch and D Flipflop.png"/></div> | [Pass-Transistor-Based Negative-Edge-Triggered D-Flipflop (PTDFF)](https://www.ijera.com/papers/Vol4_issue4/Version%203/J044037073.pdf) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-23-56-36_From Basic Logic Gates to D Latch and D Flipflop.png"/></div> |  |
</div>


### 5.2 matters need attention

上面的内容看似简单，但还是有一些要注意的地方，尤其是 negative-edge-triggered SR-FF/JK-FF, 是非常容易出错的，下面是两个典型例子：

<div class='center'>

| negative-edge-triggered SR-FF  | negative-edge-triggered JK-FF |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-23-47-44_From Basic Logic Gates to D Latch and D Flipflop.jpg"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-11-00-13-42_From Basic Logic Gates to D Latch and D Flipflop.png"/></div> |
</div>





## Reference

- [[1] Analog Circuit Design > Digital > Transmission gates](https://analogcircuitdesign.com/transmission-gates-working-circuit-and-applications/)
- [[2] Analog Circuit Design > Digital > SR Latch and SR Flip-Flop](https://analogcircuitdesign.com/sr-latch-and-sr-flip-flop/)
- [[3] Analog Circuit Design > Digital > D Latch and D Flip-Flop](https://analogcircuitdesign.com/d-latch-and-d-flip-flop/)
- [[4] Analog Circuit Design > Digital > Multiplexers (MUX)](https://analogcircuitdesign.com/multiplexers-working-truth-table-and-applications/)
- [[5] 知乎 > 深入理解锁存器：SR 锁存器、门控 SR 锁存器、门控 D 锁存器介绍](https://zhuanlan.zhihu.com/p/1938209046684505714)