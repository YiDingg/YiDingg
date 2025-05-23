# [Razavi CMOS] Design Example of Folded-Cascode Stage

> [!Note|style:callout|label:Infor]
> Initially published at 17:11 on 2025-05-20 in Beijing.

## Introduction

本文是 *Design of Analog CMOS Integrated Circuits (Razavi) (2nd Edition, 2015)* 一书课后习题 9.3 的解答。电路使用 LTspice 进行简单 SPICE 仿真 (cadence 的使用方法我还需要摸索一下)。在讲解完我们的设计过程后，会给出习题集答案上的解答，也即 *Solution Manual for "Design of Analog CMOS Integrated Circuits (Razavi) (Second Edition, 2015)"* 一书中给出的参考答案。


本文的 LTspice 仿真文件已上传到 [123 云盘](https://www.123684.com/s/0y0pTd-YUUj3), [123 云盘 (备用链接)](https://www.123912.com/s/0y0pTd-YUUj3)。

原题的题目如下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-18-46_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-19-12_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-20-02_Design Example of Folded-Cascode Stage.png"/></div>

## Design Notes

### Design Considerations

下面是本设计的一些考量：
- 按 Razavi 书上的常规思路进行设计 (也即先依据经验分配 overdrive voltages)
- 仅在 Schematic 层面进行设计，不考虑 Layout 部分
- 设计时不考虑 CMFB 的部分，仿真时会考虑较理想且简单的 CMFB
- 计算 $a = (W/L)$ 时，使用 $V_{DS} = V_{GS}$ 而不是 $V_{DS} = V_{OV}$

### Design Preparations

在开始设计之前，先把我们这部分的笔记翻出来，方便一会儿参考：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-30-52_Design Example of Folded-Cascode Stage.png"/></div>

以及 SPICE 中各参数的含义：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-49-58_Design Example of Folded-Cascode Stage.png"/></div>

相关公式：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-51-32_Design Example of Folded-Cascode Stage.png"/></div>

### Design Example

<!-- 这一部分，我们用比例法来分配 overdrive voltages. 以普通 cascode stage 为例，可以设 M9 占 1 份, M1 ~ M4 占 1.4 份而 M5 ~ M8 占 1.8 份；回到 folded-cascode stage, 就是 $M_{5,6} = 1\times V_1$, $M_{1,2} = M_{3,4} = 1.4\times V_1$, $M_{7,8} = M_{9,10} = 1.8\times V_1$. 这样一共消耗 $V_{OV5,6} + V_{OV3,4} + V_{OV7,8} + V_{OV9,10} = 6 V_1$ 的 single-ended swing. $V_{DD} = 3 \ \mathrm{V}$, 要使 CM swing > 2.4 V, 需要 $6 V_1 < 1.8 \ \mathrm{V}$. 不妨设 $6 V_1 = 1.7 \ \mathrm{V} \Longrightarrow V_1 = 283.3 \ \mathrm{mV}$. 于是各个 overdrive voltage 分配如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-17-31-46_Design Example of Folded-Cascode Stage.png"/></div>

当然，我们这里的比例系数是比较简易的，读者可以根据经验自行调整。 -->

注，下图公式 $a = \left(\frac{W}{L}\right)$ 中的 $L$ 都是指 $L = L_{eff} = L_{total} - 2L_D$。并且，若无特别说明，均默认 $L = 0.5 \ \mathrm{um}$。

完整过程如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-23-10-38-51_[Razavi CMOS] Design Example of Folded-Cascode Stage.webp"/></div>

分步：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-23-10-34-59_[Razavi CMOS] Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-23-10-35-09_[Razavi CMOS] Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-23-10-35-24_[Razavi CMOS] Design Example of Folded-Cascode Stage.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-23-10-35-44_[Razavi CMOS] Design Example of Folded-Cascode Stage.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-23-10-36-52_[Razavi CMOS] Design Example of Folded-Cascode Stage.png"/></div>

## LTspice Simulation

本文的 LTspice 仿真文件已上传到 [123 云盘](https://www.123684.com/s/0y0pTd-YUUj3), [123 云盘 (备用链接)](https://www.123912.com/s/0y0pTd-YUUj3)。


### CMFB and Frequency Response

注意: MOSFET 的 width 是用 $L_{eff}$ 计算得到的，也就是参数 $L = L_{eff} + 2L_D$ 而 $a = \frac{W}{L_{eff}} \Longrightarrow W = a \cdot L_{eff} = a \cdot (L - 2L_D)$.

``` spice
.model NMOS nmos(LEVEL=1 L=6.6e-7 VTO=0.7 GAMMA=0.45 PHI=0.9 NSUB=9e+14 LD=0.08e-6 UO=350 LAMBDA=0.1 TOX=9e-9 PB=0.9 CJ=0.56e-3 CJSW=0.35e-11 MJ=0.45 MJSW=0.2 CGDO=0.4e-9 JS=1.0e-8)
.model NMOS_Mb1 nmos(LEVEL=1 L=0.66e-6 W=8.6507e-06 VTO=0.7 GAMMA=0.45 PHI=0.9 NSUB=9e+14 LD=0.08e-6 UO=350 LAMBDA=0.1 TOX=9e-9 PB=0.9 CJ=0.56e-3 CJSW=0.35e-11 MJ=0.45 MJSW=0.2 CGDO=0.4e-9 JS=1.0e-8)
.model PMOS pmos(LEVEL=1 L=6.8e-7 VTO=-0.8 GAMMA=0.40 PHI=0.8 NSUB=5e+14 LD=0.09e-6 UO=100 LAMBDA=0.2 TOX=9e-9 PB=0.9 CJ=0.94e-3 CJSW=0.32e-11 MJ=0.50 MJSW=0.3 CGDO=0.3e-9 JS=0.5e-8)
.model PMOS_Mb6 pmos(LEVEL=1 L=0.68e-6 W=8.2742e-06 VTO=-0.8 GAMMA=0.40 PHI=0.8 NSUB=5e+14 LD=0.09e-6 UO=100 LAMBDA=0.2 TOX=9e-9 PB=0.9 CJ=0.94e-3 CJSW=0.32e-11 MJ=0.50 MJSW=0.3 CGDO=0.3e-9 JS=0.5e-8)
```




<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-00-57-50_Design Example of Folded-Cascode Stage.png"/></div>

没有 CMFB 时，$V_{out,CM}$ 对电流镜的匹配非常敏感。匹配稍有误差，就会导致 $V_{out,CM}$ 过高或过低，管子进入线性区，电路无法正常工作。如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-01-21-14_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-00-58-19_Design Example of Folded-Cascode Stage.png"/></div>


加入比较理想的 resistive CMFB 之后，$V_{out,CM}$ 被很好地稳定在 $V_{REF} = 1.3 \ \mathrm{V}$ (single-ended swing 的中点)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-01-20-26_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-01-16-54_Design Example of Folded-Cascode Stage.png"/></div>

加入很小的补偿电容便可获得较大的 Phase Margin, 并且没有让 GBW 下降太多：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-01-33-39_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-01-30-46_Design Example of Folded-Cascode Stage.png"/></div>

### Transient Simulation

single-ended swing 的范围是 $(V_{b1} - 0.7 \ \mathrm{V},\ V_{b2} + 0.8 \ \mathrm{V}) = (0.8 \ \mathrm{V},\ 2.1 \ \mathrm{V})$, DM swing = 1.3 Vamp (2.6 Vpp). 要在开环下无明显失真，我们设置输入幅度为 7 mVamp, 下面是时域瞬态仿真结果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-15-32-28_Design Example of Folded-Cascode Stage.png"/></div>

加入高频共模干扰后的输出：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-15-35-50_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-15-37-16_Design Example of Folded-Cascode Stage.png"/></div>
上图充分体现了差分输出在共模抑制上的优势。

### Common-Mode to CM/DM Gain


Common-Mode (input) to Common-Mode (output) Gain:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-15-41-57_Design Example of Folded-Cascode Stage.png"/></div>

Common-Mode (input) to Differential-Mode (output) Gain:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-20-26-10_Design Example of Folded-Cascode Stage.png"/></div>

可以看到，在当前的理想仿真环境下 (无 mismatch), CMRR 是趋于无穷大的。


## Reference Answer

下面是 *Solution Manual for "Design of Analog CMOS Integrated Circuits (Razavi) (Second Edition, 2015)"* 一书中给出的参考解答：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-15-52-21_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-15-52-44_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-15-53-07_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-15-53-17_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-15-53-30_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-15-53-42_Design Example of Folded-Cascode Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-15-53-53_Design Example of Folded-Cascode Stage.png"/></div>

