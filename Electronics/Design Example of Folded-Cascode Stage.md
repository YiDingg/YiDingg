# Design Example of Folded-Cascode Stage

> [!Note|style:callout|label:Infor]
> Initially published at 17:11 on 2025-05-20 in Beijing.

## Introduction

本文是 *Design of Analog CMOS Integrated Circuits (Razavi) (2nd Edition, 2015)* 一书课后习题 9.3 的解答。电路使用 LTspice 进行简单 SPICE 仿真 (cadence 的使用方法我还需要摸索一下)。在讲解完我们的设计过程后，会给出习题集答案上的解答，也即 *Solution Manual for "Design of Analog CMOS Integrated Circuits (Razavi) (Second Edition, 2015)"* 一书中给出的参考答案。


原题的题目如下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-18-46_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-19-12_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-20-02_Design Example of Folded-Cascode Stage.png"/></div>

## Design Notes

### Design Considerations

下面是本设计的一些考量：
- 按 Razavi 书上的常规思路进行设计 (也即先依据经验分配 overdrive voltages)
- 仅在 Schematic 层面进行设计，不考虑 Layout 部分
- 不考虑 CMFB 的部分，详见文章 (待补充)

### Design Constraints

### 0. Design Preparations

在开始设计之前，先把我们这部分的笔记翻出来，方便一会儿参考：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-30-52_Design Example of Folded-Cascode Stage.png"/></div>

以及 SPICE 中各参数的含义：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-49-58_Design Example of Folded-Cascode Stage.png"/></div>

相关公式：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-51-32_Design Example of Folded-Cascode Stage.png"/></div>

### 1. Allocate Overdrives and Determine Biasing Conditions

这一部分，我们用比例法来分配 overdrive voltages. 以普通 cascode stage 为例，可以设 M9 占 1 份, M1 ~ M4 占 1.4 份而 M5 ~ M8 占 1.8 份；回到 folded-cascode stage, 就是 $M_{5,6} = 1\times V_1$, $M_{1,2} = M_{3,4} = 1.4\times V_1$, $M_{7,8} = M_{9,10} = 1.8\times V_1$. 这样一共消耗 $V_{OV5,6} + V_{OV3,4} + V_{OV7,8} + V_{OV9,10} = 6 V_1$ 的 single-ended swing. $V_{DD} = 3 \ \mathrm{V}$, 要使 CM swing > 2.4 V, 需要 $6 V_1 < 1.8 \ \mathrm{V}$. 不妨设 $6 V_1 = 1.7 \ \mathrm{V} \Longrightarrow V_1 = 283.3 \ \mathrm{mV}$. 于是各个 overdrive voltage 分配如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-31-46_Design Example of Folded-Cascode Stage.png"/></div>

当然，我们这里的比例系数是比较简易的，读者可以根据经验自行调整。

### 2. Choose the Biasing Circuit and Determine Aspect Ratios

### 3. Calculate the Small-Signal Gain and Determine Lengths

### 4. Compensation and Frequency Analysis

### 5. Tuning Parameters for Improvement

## Reference Answer




