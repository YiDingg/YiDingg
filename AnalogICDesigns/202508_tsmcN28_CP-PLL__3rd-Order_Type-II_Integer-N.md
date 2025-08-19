# A Third-Order Type-II Integer-N CP-PLL Achieving xxx rmsJitter and xxx FoM

> [!Note|style:callout|label:Infor]
Initially published at 13:48 on 2025-08-16 in Lincang.

## Introduction

本文是项目 [Design of A Third-Order Type-II Integer-N CP-PLL](<Projects/Design of A Third-Order Type-II Integer-N CP-PLL.md>) 的附属文档，用于记录各个模块的详细设计和仿真，以及整个系统的前仿过程。

<!-- 各模块的设计主要参考这篇文章 (或者说是复现)：
>[[1]](https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system) M. Aldacher, “muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system.” Accessed: Jun. 30, 2025. [Online]. Available: https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system -->



## 1. PFD and CP Design

`tsmcN28` 库中自带的逻辑门如下：


- inv:  inverter (NOT)
- nand: NAND
- nor:  NOR
- trans: Transmission Gate (differing from "Pass Gate")
- tri: Tri State Inverter

``` bash
inv_18_mac            : 1.8V Inverter
inv_hv18_mac          : 1.8V high voltage Inverter
inv_18ud12_mac        : 1.8V under-drive 1.2V Inverter
inv_18ud15_mac        : 1.8V under-drive 1.5V Inverter
inv_25_mac            : 2.5V Inverter
inv_25od33_mac        : 2.5V over-drive 3.3V Inverter
inv_25ud18_mac        : 2.5V under-drive 1.8V Inverter
inv_ehvt_mac          : Extreme High Vt Inverter
inv_hvt_mac           : High Vt Inverter
inv_lvt_mac           : Low Vt Inverter
inv_uhvt_mac          : Ultra High Vt Inverter
inv_ulvt_mac          : Ultra Low Vt Inverter
inv_mac               : Standard Vt Inverter
nand2_18_mac          : 1.8V NAND
nand2_hv18_mac        : 1.8V high voltage NAND
nand2_18ud12_mac      : 1.8V under-drive 1.2V NAND
nand2_18ud15_mac      : 1.8V under-drive 1.5V NAND
nand2_25_mac          : 2.5V NAND
nand2_25od33_mac      : 2.5V over-drive 3.3V NAND
nand2_25ud18_mac      : 2.5V under-drive 1.8V NAND
nand2_ehvt_mac        : Extreme High Vt NAND
nand2_hvt_mac         : High Vt NAND
nand2_lvt_mac         : Low Vt NAND
nand2_uhvt_mac        : Ultra High Vt NAND
nand2_ulvt_mac        : Ultra Low Vt NAND
nand2_mac             : Standard Vt NAND
nand3_18_mac          : 1.8V NAND
nand3_hv18_mac        : 1.8V high voltage NAND
nand3_18ud12_mac      : 1.8V under-drive 1.2V NAND
nand3_18ud15_mac      : 1.8V under-drive 1.5V NAND
nand3_25_mac          : 2.5V NAND
nand3_25od33_mac      : 2.5V over-drive 3.3V NAND
nand3_25ud18_mac      : 2.5V under-drive 1.8V NAND
nand3_ehvt_mac        : Extreme High Vt NAND
nand3_hvt_mac         : High Vt NAND
nand3_lvt_mac         : Low Vt NAND
nand3_uhvt_mac        : Ultra High Vt NAND
nand3_ulvt_mac        : Ultra Low Vt NAND
nand3_mac             : Standard Vt NAND
nand4_18_mac          : 1.8V NAND
nand4_hv18_mac        : 1.8V high voltage NAND
nand4_18ud12_mac      : 1.8V under-drive 1.2V NAND
nand4_18ud15_mac      : 1.8V under-drive 1.5V NAND
nand4_25_mac          : 2.5V NAND
nand4_25od33_mac      : 2.5V over-drive 3.3V NAND
nand4_25ud18_mac      : 2.5V under-drive 1.8V NAND
nand4_ehvt_mac        : Extreme High Vt NAND
nand4_hvt_mac         : High Vt NAND
nand4_lvt_mac         : Low Vt NAND
nand4_uhvt_mac        : Ultra High Vt NAND
nand4_ulvt_mac        : Ultra Low Vt NAND
nand4_mac             : Standard Vt NAND
nor2_18_mac           : 1.8V NOR
nor2_hv18_mac         : 1.8V high voltage NOR
nor2_18ud12_mac       : 1.8V under-drive 1.2V NOR
nor2_18ud15_mac       : 1.8V under-drive 1.5V NOR
nor2_25_mac           : 2.5V NOR
nor2_25od33_mac       : 2.5V over-drive 3.3V NOR
nor2_25ud18_mac       : 2.5V under-drive 1.8V NOR
nor2_ehvt_mac         : Extreme High Vt NOR
nor2_hvt_mac          : High Vt NOR
nor2_lvt_mac          : Low Vt NOR
nor2_uhvt_mac         : Ultra High Vt NOR
nor2_ulvt_mac         : Ultra Low Vt NOR
nor2_mac              : Standard Vt NOR
nor3_18_mac           : 1.8V NOR
nor3_hv18_mac         : 1.8V high voltage NOR
nor3_18ud12_mac       : 1.8V under-drive 1.2V NOR
nor3_18ud15_mac       : 1.8V under-drive 1.5V NOR
nor3_25_mac           : 2.5V NOR
nor3_25od33_mac       : 2.5V over-drive 3.3V NOR
nor3_25ud18_mac       : 2.5V under-drive 1.8V NOR
nor3_ehvt_mac         : Extreme High Vt NOR
nor3_hvt_mac          : High Vt NOR
nor3_lvt_mac          : Low Vt NOR
nor3_uhvt_mac         : Ultra High Vt NOR
nor3_ulvt_mac         : Ultra Low Vt NOR
nor3_mac              : Standard Vt NOR
nor4_18_mac           : 1.8V NOR
nor4_hv18_mac         : 1.8V high voltage NOR
nor4_18ud12_mac       : 1.8V under-drive 1.2V NOR
nor4_18ud15_mac       : 1.8V under-drive 1.5V NOR
nor4_25_mac           : 2.5V NOR
nor4_25od33_mac       : 2.5V over-drive 3.3V NOR
nor4_25ud18_mac       : 2.5V under-drive 1.8V NOR
nor4_ehvt_mac         : Extreme High Vt NOR
nor4_hvt_mac          : High Vt NOR
nor4_lvt_mac          : Low Vt NOR
nor4_uhvt_mac         : Ultra High Vt NOR
nor4_ulvt_mac         : Ultra Low Vt NOR
nor4_mac              : Standard Vt NOR
trans_18_mac          : 1.8V Transmission Gate
trans_hv18_mac        : 1.8V high voltage Transmission Gate
trans_18ud12_mac      : 1.8V under-drive 1.2V Transmission Gate
trans_18ud15_mac      : 1.8V under-drive 1.5V Transmission Gate
trans_25_mac          : 2.5V Transmission Gate
trans_25od33_mac      : 2.5V over-drive 3.3V Transmission Gate
trans_25ud18_mac      : 2.5V under-drive 1.8V Transmission Gate
trans_ehvt_mac        : Extreme High Vt Transmission Gate
trans_hvt_mac         : High Vt Transmission Gate
trans_lvt_mac         : Low Vt Transmission Gate
trans_uhvt_mac        : Ultra High Vt Transmission Gate
trans_ulvt_mac        : Ultra Low Vt Transmission Gate
trans_mac             : Standard Vt Transmission Gate
tri_18_mac            : 1.8V Tri State Inverter
tri_hv18_mac          : 1.8V high voltage Tri State Inverter
tri_18ud12_mac        : 1.8V under-drive 1.2V Tri State Inverter
tri_18ud15_mac        : 1.8V under-drive 1.5V Tri State Inverter
tri_25_mac            : 2.5V Tri State Inverter
tri_25od33_mac        : 2.5V over-drive 3.3V Tri State Inverter
tri_25ud18_mac        : 2.5V under-drive 1.8V Tri State Inverter
tri_ehvt_mac          : Extreme High Vt Tri State Inverter
tri_hvt_mac           : High Vt Tri State Inverter
tri_lvt_mac           : Low Vt Tri State Inverter
tri_uhvt_mac          : Ultra High Vt Tri State Inverter
tri_ulvt_mac          : Ultra Low Vt Tri State Inverter
tri_mac               : Standard Vt Tri State Inverter
```

注意 TRANS (Transmission Gate) 和 PASS (Pass Gate) 的区别：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-18-25-39_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-18-48-53_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


tri (Tri State Inverter) 其实就是一个带 clock enable 的 inverter, 如下图 [(slides)](https://faculty-web.msoe.edu/johnsontimoj/Common/FILES/tristate_inverter.pdf):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-14-07-52_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>



### 1.1 Structure of PFD

[Paper [1]](https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system) 使用 NOR 组成 resettable D latch, 配合 AND (NAND + NOT) 实现 Razavi CMOS 中给出的经典 PFD. 
我们 `tsmcN28` 库中给出的基本逻辑门也包含 NOR, 因此可以直接套用：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-16-31-52_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

### 1.2 Structure of CP

我们 Charge Pump 的结构与 [Paper [1]](https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system) 相同，采用 Razavi CMOS 中给出的经典 Bootstrapped Charge Pump:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-16-24-34_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-16-30-53_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

schematic 中的 opamp 是在之前的项目 [Scientific Research Practice 1 (Low-Voltage BGR)](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>) 时设计的运放 [202507_tsmcN28_OpAmp__nulling-Miller](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller.md>).

### 1.3 Structure of LPF

直接使用 $R_P,\ C_P,\ C_2$ 三个阻容器件即可。

### 1.4 PASS Simulation

这里先仿真一下 pass (Pass Gate) 的延迟情况, 以便后续参考：

最小尺寸 (100nm/30nm) pass gate 的电阻：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-20-04-01_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

最小尺寸 (100nm/30nm) pass gate 的延迟：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-19-46-53_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-19-46-28_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


### 1.5 INV Simulation


各器件都取最小尺寸 (100nm/30nm), 设置到初始条件后运行瞬态仿真：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-21-14-50_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-21-13-50_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-21-52-50_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


$$
\begin{gather}
2NT_D =\frac{1}{f_{ocs}} \Longrightarrow T_D = \frac{1}{2 N f_{ocs}} = \frac{1}{2 \cdot 11 \cdot 12.8 \ \mathrm{GHz}} = 3.5511 \ \mathrm{ps}
\\
2NT_D =\frac{1}{f_{ocs}} \Longrightarrow T_D = \frac{1}{2 N f_{ocs}} = \frac{1}{2 \cdot 11 \cdot 13.0 \ \mathrm{GHz}} = 3.4965 \ \mathrm{ps}
\end{gather}
$$

当然，更常见的是运行 pss/hb 仿真。


pss 设置如下 (参考 [here](https://www.bilibili.com/video/BV1Gw41197m2))：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-21-25-24_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

运行仿真，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-21-42-34_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-21-43-09_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

pss 仿真给出 12.81 GHz 的时域频率和 13.0 GHz 的基波频率，这与 tran 仿真中的结果完全一致。

### 1.5 PFD/CP/LPF Simulation 

将 PFD/CP/LPF 结合在一起仿真，看看模块设计和端口定义是否正确。注意，为了保证 Charge Pump 输出正常，我们需要在 simulation 中设置其输出端初始电压为 0.5V: 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-22-33-56_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-22-36-25_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-22-38-16_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-16-44-07_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

图中可以看到，即便我们设置了 CP 的电流镜为 100 uA, 最终输出的却只有约 ±50 uA, 因此需要对其晶体管尺寸进行调整。也就是说，现在需要设计 charge pump 的下面四个参数：
- NMOS: 
    - `LN`: NMOS length
    - `AN`: NMOS aspect ratio (W/L)_N
- PMOS: 
    - `LP`: PMOS length
    - `AP`: PMOS aspect ratio (W/L)_P

我们将在 **2.1 Design of CP** 节中讨论这些参数的设计。

## 2. Design Details

### 2.1 Design of PFD/CP


若无特别说明，下面都默认输出端电压扫描范围 200 mV ~ 800 mV.


先设置 UP = 1, DN = 0, 此时输出电流由上方的 PMOS 提供, 目标是输出 100 uA. 看看初始值下的情况 (LP = 30n, AP = 5):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-01-12-02_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

为获得较好的晶体管性能，同时保持匹配不会过低，我们考虑令 NMOS 和 PMOS 的 gm/Id = 14. 

设置 vds = 225 mV 进行仿真，得到归一化电流 I_nor 结果如下 (总结成表方便查阅)：

<div class='center'>

**Normalized current I_nor = Id/a of `nch_mac` in tsmcN28 process library.**
<br>
Note that for NMOS: I_nor and length have a <span style='color:red'> positive </span> correlation.
<br>
But for PMOS: I_nor and length have a <span style='color:blue'> negative </span> correlation. 
</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-16-27-29_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


gm/Id = 14 时, NMOS I_nor = 2.219 uA (a = 45.065), PMOS I_nor = 2.122 uA (a = 47.125), 不妨直接设置 AN = AP = 45.

下面就是确定 length, 为了不让 width 超过最大值，我们调整 FP = FN = 10. 先让 PMOS 提供输出 (UP = 1, DN = 0)，扫描 LP 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-02-36-59_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

然后让 NMOS 提供输出 (UP = 0, DN = 1)，扫描 LN 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-02-39-25_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


从上面的结果来看，似乎是 length 越大的越好。但是别忘了 length 越大晶体管速度越慢 (电容也越大)：

为保持速度和输出精度的折中，我们选择以下参数：
- CP_AN = CP_AP = 45
- CP_FN = CP_FP = 10
- CP_LN = CP_LP = length (to be determined)
- CP_FWN = CP_FWP = length\*CP_AN/CP_FN = 4.5\*length


重新到 PFD/CP/LPF 中，调整 f_REF = 50 MHz 进行仿真，结果如下：

**length = 80 nm:**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-03-04-45_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

**length = 100 nm:**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-02-58-47_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-03-00-44_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


**length = 140 nm:**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-03-06-28_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

**length = 200 nm:**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-03-08-26_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

可以看到，当 length 达到 200 nm 时, PFD 所输出的 UP 和 DN 已经不足以在 50 MHz 驱动 Charge Pump 了。加入两个反相器以提升驱动能力，再次仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-03-11-28_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-03-13-37_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

UP 和 DN 波形有所改善，但 UP 和 DN 不能同时关闭导致的次级电流脉冲变得明显，随着 length 增大，此现象越发严重。

综上考虑, PFD/CP 模块及其连接部分的全部管子，我们都使用 length = 100 n, 最终参数为：
- CP_AN = CP_AP = 45
- CP_FN = CP_FP = 10
- CP_LN = CP_LP = 100 nm
- CP_FWN = CP_FWP = length\*CP_AN/CP_FN = 450 nm

此时效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-03-22-28_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-03-27-25_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-03-28-35_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div> -->


### 2.2 Design of FD

<!-- 分频器 FD (frequency divider) 一般是用 D flip-flop (D 触发器) 来实现的。


对于一个 active-high-input D flipflop (在上升沿或高电平时触发)，只需简单地将输出 Q_BAR 与输入 D 相连，便可得到一个 Divide-by-2 的分频器 (在 CLK 处输入时钟信号，输出端为 Q)。只不过 D flipflop 的实现方式非常多，例如经典 CMOS Logic 的 NOR 门或者 NAND 门、适用于高速低功耗的 TSPC (ture single-phase clock) 方法等。单单是 TSPC 就已经有 5-transistors (5T), 6T, 8T, 9T, 11T 构成的 D flipflop [[10]](https://ieeexplore.ieee.org/document/7754138).

考虑使用 TSPC (true single-phase clock) 下的 D Flip-Flop (D Latch) 来实现。 -->

关于 Frequency Dividers 的基础知识 (包括 TSPC), 详见文章 [Razavi PLL - Chapter 15. Frequency Dividers](<AnalogIC/Razavi PLL - Chapter 15. Frequency Dividers.md>)。我们直接采用如下结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-18-46-09_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-19-01-47_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

对 FD 而言，我们的预期输入频率 (即 VCO 的输出) 为 1 GHz ~ 2 GHz 。为了保证系统性能的稳定，可以按最高输入频率为 5 GHz 进行设计，同时验证 FD 在 0.2 GHz 下也可以正常工作 (因为动态逻辑电路在低频可能时序错误)。


### 2.3 Design of VCO

完成此部分前建议先学习 Razavi PLL > Chapter 1. Oscillator Fundamentals ~ Chapter 4. Design of Differential and Multiphase Ring Oscillators. 





<!-- ## 2. Design Iteration
### 2.1 Iteration 1: transient response

locking time and 

### 2.1 Iteration 2: 



## 3. Pre-Layout Simulation

这里放 schematic

### 3.1 (tran) transient response (all-temp, all-corner, 1.0 V)
### 3.2 (tran) transient response (27 °C, TT, {0.9 V, 1.1 V})
### 3.3 (tran) step response (27 °C, TT, 1.0 V)
### 3.4 (pss) jitter and phase noise (27 °C, all-corner, 1.0 V)


## References

- [[1]](https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system) M. Aldacher, “muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system.” Accessed: Jun. 30, 2025. [Online]. Available: https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system
- [[2]](https://u.dianyuan.com/bbs/u/29/1116306785.pdf) F. Gardner, “Charge-Pump Phase-Lock Loops,” IEEE Transactions on Communications, vol. 28, no. 11, pp. 1849–1858, Nov. 1980, doi: 10.1109/TCOM.1980.1094619.
- [[3]](https://www.ideals.illinois.edu/items/50583) D. Wei, Clock Synthesizer Design With Analog and Digital Phas-Locked Loop. [Online]. Available: https://www.ideals.illinois.edu/items/50583
- [[4]](https://www.ideals.illinois.edu/items/49560) R. Ratan, Design of a Phase-Locked Loop Based Clocking Circuit for High Speed Serial Link Applications. [Online]. Available: https://www.ideals.illinois.edu/items/49560
- [[5]](https://www.zhihu.com/question/452068235/answer/95164892409) B. Razavi, Design of Analog CMOS Integrated Circuits, Second edition. New York, NY: McGraw-Hill Education, 2017.
- [[6]](https://www.zhihu.com/question/23142886/answer/108257466853) B. Razavi, Design of CMOS Phase-Locked Loops. New York, NY: Cambridge University Press, 2020.
- [[7]](https://snehilverma41.github.io/PLL_Report.pdf) Phase-Locked Loop (Design and Implementation). Accessed: Jun. 30, 2025. [Online]. Available: https://snehilverma41.github.io/PLL_Report.pdf
- [[8]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9847207) W. Bae, “Benchmark Figure of Merit Extensions for Low Jitter Phase Locked Loops Inspired by New PLL Architectures,” IEEE Access, vol. 10, pp. 80680–80694, 2022, doi: 10.1109/ACCESS.2022.3195687.
- [[9]](https://seas.ucla.edu/brweb/papers/Journals/BRFall16TSPC.pdf) B. Razavi, “TSPC Logic [A Circuit for All Seasons],” IEEE Solid-State Circuits Mag., vol. 8, no. 4, pp. 10–13, 2016, doi: 10.1109/MSSC.2016.2603228.

 -->