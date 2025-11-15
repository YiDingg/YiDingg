# A Third-Order Type-II Integer-64 CP-PLL with 0.5 GHz ~ 3.0 GHz Locking Range Achieving 2.800 ps RMS Jitter and -234.3 dB FoM in 28nm CMOS Technology

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 13:48 on 2025-08-16 in Lincang.

## Introduction

本文是项目 [Design of A Third-Order Type-II Integer-N CP-PLL](<Projects/Design of A Third-Order Type-II Integer-N CP-PLL.md>) 的附属文档，用于记录各个模块的详细设计和仿真，以及整个系统的前仿过程。

<!-- 各模块的设计主要参考这篇文章 (或者说是复现)：
>[[1]](https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system) M. Aldacher, “muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system.” Accessed: Jun. 30, 2025. [Online]. Available: https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system -->



## 1. Design Considerations

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
2NT_D =\frac{1}{f_{osc}} \Longrightarrow T_D = \frac{1}{2 N f_{osc}} = \frac{1}{2 \cdot 11 \cdot 12.8 \ \mathrm{GHz}} = 3.5511 \ \mathrm{ps}
\\
2NT_D =\frac{1}{f_{osc}} \Longrightarrow T_D = \frac{1}{2 N f_{osc}} = \frac{1}{2 \cdot 11 \cdot 13.0 \ \mathrm{GHz}} = 3.4965 \ \mathrm{ps}
\end{gather}
$$

当然，更常见的是运行 pss/hb 仿真。


pss 设置如下 (参考 [here](https://www.bilibili.com/video/BV1Gw41197m2))：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-21-25-24_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

运行仿真，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-21-43-09_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-21-42-34_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

pss 仿真给出 12.81 GHz 的时域频率和 13.0 GHz 的基波频率，这与 tran 仿真中的结果完全一致。

### 1.6 PFD/CP/LPF Simul

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

## 2. Design of PFD/CP


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


## 3. Design of FD



关于 Frequency Dividers 的基础知识 (包括 TSPC) 详见文章 [Razavi PLL - Chapter 15. Frequency Dividers](<AnalogIC/Razavi PLL - Chapter 15. Frequency Dividers.md>)。我们直接采用如下结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-18-46-09_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-19-01-47_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

对 FD 而言，我们的预期输入频率 (即 VCO 的输出) 为 1 GHz ~ 2 GHz, 预期输出频率 20 MHz ~ 30 MHz, 也即输入频率从 40 MHz ~ 2 GHz 都有。为了保证系统性能稳定性，可以按输入 4 GHz 输出 15.5 MHz 进行仿真 (共八个 Divider 级联)。**但是这样的瞬态仿真太过耗时！** 因此考虑仅仿真两个 FD, 一个输入 5 GHz, 另一个输入 10 MHz, 分为两个 schematic (两个 test) 在同一 ADE XL 中进行仿真，每个 test 仅仿真二十个周期，这样仿真速度会好几个档次。



**当然，在实际的 Divide-By-64 Frequency Divider (六个 FD 级联) 电路中，我们可以从前向后逐渐增大每个 FD 单元的 length, 以此调整各个单元的工作频率。**

我们感兴趣的几个性能参数：
- delay/period
- risingTime/period, fallingTime/period
- average power consumption

下面是输入分别为 5GHz 和 10 MHz 时， W/L = 200n/60n 的 FD 的仿真情况：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-00-07-14_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>



现在，保持 length = 30nm, 60nm, 100nm 不变，改变长宽比 a = W/L, 观察 FD 的性能变化情况 <span style='color:red'> (注：所有参数都已经取绝对值) </span>：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-00-23-38_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-00-25-07_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

由上面的数据，我们选择 W/L = 200n/60n 为最佳尺寸 (NMOS = PMOS = 200n/60n)。然后仿真一下此参数下的最大最小输入频率：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-00-39-14_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-00-55-25_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

图中可以看出 $f_{in,\min} \in (50 \ \mathrm{kHz},\ 250 \ \mathrm{kHz})$ 且 $f_{in,\max} \in (20 \ \mathrm{GHz},\ 100 \ \mathrm{GHz})$。进一步仿真以确定其频率界限：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-01-02-51_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-00-56-20_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div> -->

图中紫色方框标出的是认为可以正常工作的频率，因此 W/L = 200n/60n 时，整个工作频率范围是：

$$
\begin{gather}
f_{in} \in (180 \ \mathrm{KHz},\ 20 \ \mathrm{GHz})\quad \mathrm{or} \quad f_{in} \in (250 \ \mathrm{KHz},\ 4 \ \mathrm{GHz})
\end{gather}
$$


仿真 W/L = 160n/50n 的输入频率范围，结果为 0.6 MHz ~ 5.0 GHz:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-01-14-17_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

仿真 W/L = 130n/40n 的输入频率范围，结果为 2.5 MHz ~ 7.5 GHz:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-01-28-14_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

仿真 W/L = 100n/30n 的输入频率范围，结果为 9.0 MHz ~ 10 GHz:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-01-22-53_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

下表汇总了不同尺寸下的输入频率范围：

<div class='center'>

| W/L | input frequency range |
|:-:|:-:|
 | 100n/30n | 9 MHz ~ 10 GHz |
 | 130n/40n | 2.5 MHz ~ 7.5 GHz |
 | 160n/50n | 0.6 MHz ~ 5.0 GHz |
 | 200n/60n | 0.25 MHz ~ 4.0 GHz |
</div>


我们的输入频率在 40 MHz ~ 2 GHz 都有，因此 100n/30n (9 MHz ~ 10 GHz) 是最佳选择。 


## 4. Design of VCO


考虑 current-starved ring VCO, 其基本公式为：

$$
\begin{gather}
f_{osc} = \frac{1}{2NT_D},\quad \mathrm{N\ must\ be\ an\ odd\ number.}
\end{gather}
$$

增大 length 和增加级数都可以降低振荡频率，我们需要在其中找到一个平衡点 (以五级或七级最为经典)。简便起见，不妨设置级数为 7, 在此基础上调整晶体管尺寸。

另外，关于 VBN 的设置，一种方法是 Vcont 直接连接所有 VBN, 第二种方法是 Vcont 仅控制一个 NMOS (决定电流)，然后由 current mirror 生成 VBN 。 前者 Vcont 的节点电容更大 (相当于提高了电容 $C_2$)，在一定范围内有更好的动态响应。因此我们考虑 Vcont 直接连接所有 VBN, 如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-02-34-20_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-02-42-22_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

设置好能够起振的初始状态后，令 Vcont = 0.7 V 进行仿真，发现 Vout 输出呈现三角波：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-02-41-55_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

这是最后输出级的压摆率有限导致的 (约 5.733 GV/s)，可以通过增加 INV 的并联数量来解决 (因为这样增加了电流)。经过仿真测试，我们将 multiplier 设置为 1 + 9 是比较合适的 (两级 INV 进行驱动)，并且将总级数增加到九级，效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-03-05-29_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-03-09-42_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


我们希望 VCO 输出目标频率范围时 (1 GHz ~ 2 GHz), VCONT 的范围控制在 0.3 V ~ 0.8 V 以内，以避免过高或过低的 VCONT 对 CP 造成不良影响。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-03-29-33_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-03-34-23_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

不妨选择 W/L = 270nm/90nm 为最佳参数，进行更详细的仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-03-43-49_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-03-45-12_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

嗯，看起来还不错的指标，线性度也很好。




## 5. PLL Simulation 

### 5.1 LPF Iteration 1

将之前选好的参数全部填入各自的 schematic 中，然后连接好外围测试电路：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-16-05-10_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

先在 MATLAB 中计算理论最佳参数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-16-12-25_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

为保证 1 GHz ~ 2 GHz 都有较好的动态性能，我们先尝试 R_P = 7 kOhm, C_P = 10 pF 的组合：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-16-16-12_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

设置预期 VCO 输出频率 f_osc = 1 GHz, 1.5 GHz, 2 GHz 进行仿真，发现结果不能正常收敛：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-16-45-44_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-16-45-08_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

<!-- ### 5.2 5k + 30p (1 GHz, 1.5 GHz)

为获得更 "真实" 的最佳阻容参数，我们设置 I_P = 80 uA 进行计算，然后再尝试 R_P = 5 kOhm, C_P = 30 pF 和 f_osc = 1 GHz 进行仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-16-57-10_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-17-26-32_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>



(我们试过用 APS 仿真器，但结果确是 VCO 甚至不振荡了，无奈还是用 spectre + <span style='color:red'> **liberal** </span>)


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-17-41-51_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-17-45-37_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

在 ADE XL Test Editor > Setup > High Performance Simulation 将 `Accuracy + Speed` 也改为 **liberal**，重新仿真看看结果是否有明显差异：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-17-59-37_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

嗯，结果是完全相同的，下面是沿用这种精度设置进行仿真。
 -->


### 5.3 5k + 30p (2 GHz)

我们提高仿真时间至 150 个 vref 周期 (150*64 = 9600 个 vout 周期) 进行仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-18-46-24_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-18-44-14_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-18-47-15_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

锁定时间 1% locking time = 632.7 ns, 下面是抖动 (jitter) 情况：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-18-55-09_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-19-07-56_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


...... 仿真时忘记勾选功耗了，罢了，换成 f_osc = 1 GHz 重新仿真一次。

### 5.4 5k + 30p (1~1.5 GHz)

当预期频率设置为 1 GHz 和 1.5 GHz 时，发现系统陷入振荡：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-21-10-25_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-21-09-38_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

于是调整仿真精度为 "conservative" + "do not override" 重新仿真，发现仍是陷入振荡。


### 5.5 Why PLL Oscillates?

下表展示了我们尝试过的阻容参数：
<div class='center'>

| (R_P, C_P) | f_osc (GHz) | Pass/Fall |
|:-:|:-:|:-:|
 | (5k, 30p)   | 1.0 | Fall |
 | (5k, 30p)   | 1.5 | Fall |
 | (5k, 30p)   | 2.0 | Pass |
 | (4.5k, 35p) | 1.0 | Fall |
 | (3k, 35p)   | 1.0 | Fall |
 | (5k, 50p)   | 1.0 | Fall |
 | (5k, 70p)   | 1.0 | Fall |
 | (5k, 100p)  | 1.0 | Fall |
</div>

为什么 1 GHz 时总陷入振荡？仔细研究振荡波形，发现其频率 7.8125 MHz 正好是 f_REF 15.625 MHz 的一半：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-23-50-40_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

仔细分析一下振荡原因：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-01-55-10_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


提出下面两种解决方案：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-02-20-13_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

### 5.6 Additional PFD (Fall)

和之前预测的差不多，原始振荡是消除了，但是出现了新的振荡 (振荡频率 15.625 MHz):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-17-36-21_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>



### 5.7 Reducing R_P (Pass)

大幅降低 R_P 至 1 kOhm (C_P = 50 pF) 重新仿真，发现和预期的类似，$\zeta = 0.17$ 较低导致锁定前抖动大，但总归可以正常收敛了：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-02-22-43_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-02-31-39_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-02-30-58_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


进一步尝试其它阻容参数 (f_osc = 1 GHz)，结果如下：

Outputs 设置：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-11-48-31_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-11-48-47_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

下面固定 RP = 1 kOhm, 扫描 CP from 20 pF to 100 pF 的各项性能，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-16-54-27_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

<!-- 
(1k, 50p):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-11-49-56_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

(1k, 30p):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-11-48-01_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

(2k, 50p):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-11-51-23_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

(1k, 20p):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-11-53-06_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

(1k, 40p) at nominal and worst (SS, -45°C) corner:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-11-56-22_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

(1.5k, 50p) at nominal and worst (SS, -45°C) corner:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-11-57-50_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

(1k, 50p) at nominal and worst (SS, -45°C) corner:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-12-00-46_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

(1k, 20p) at nominal and worst (SS, -45°C) corner:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-13-14-30_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

(1k, 25p):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-13-21-56_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

(1k, 35p):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-13-23-12_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

(1k, 45p):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-13-24-56_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


(1k, 60p):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-13-41-02_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

(1k, 70p):
(1k, 80p):
(1k, 90p):
(1k, 100p):
 -->


### 5.8 Brief Summary

上面的一系列仿真结果总结在下图：

<div class="center"><img width=600px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-18-31-13_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


``` bash
原始数据：

Point	Corner	CP	C2	Pass/Fail	f_osc	time_end	settling_vcont_1percent	settling_vcp_1percent	settling_vcp_0d05percent	overshoot_vcp (%)	vout_freq_absJitter_av (%)	vout_period_jitter_sigma	vfb_freq_absJitter_av (%)	vfb_period_jitter_sigma	IDD_average	IDD_rms	Idd_opamp_average	Idd_opamp_rms
1	nom	2.00E-11	1.00E-12	fail	1.00E+09	9.60E-06	8.90E-06	1.09E-06	6.02E-06	19.21	1.34E-03	3.23E-12	8.61E-02	6.51E-11	4.72E-04	4.98E-04	1.24E-04	1.25E-04
2	nom	2.50E-11	1.25E-12	pass	1.00E+09	9.60E-06	7.87E-06	5.77E-07	9.61E-07	3.983	1.08E-03	2.88E-12	6.91E-02	5.41E-11	4.72E-04	4.98E-04	1.24E-04	1.24E-04
3	nom	3.00E-11	1.50E-12	pass	1.00E+09	9.60E-06	1.22E-06	7.66E-07	1.22E-06	9.219	9.40E-04	2.96E-12	6.02E-02	4.75E-11	4.72E-04	4.98E-04	1.24E-04	1.25E-04
4	nom	3.50E-11	1.75E-12	pass	1.00E+09	9.60E-06	1.09E-06	7.75E-07	1.22E-06	11.85	9.24E-04	2.90E-12	5.92E-02	4.79E-11	4.73E-04	4.98E-04	1.24E-04	1.25E-04
5	nom	4.00E-11	2.00E-12	pass	1.00E+09	9.60E-06	1.28E-06	8.33E-07	1.28E-06	12.72	8.88E-04	2.91E-12	5.69E-02	4.48E-11	4.73E-04	4.99E-04	1.25E-04	1.26E-04
6	nom	4.50E-11	2.25E-12	pass	1.00E+09	9.60E-06	1.15E-06	7.72E-07	1.22E-06	7.759	7.79E-04	2.88E-12	4.98E-02	4.16E-11	4.73E-04	4.98E-04	1.25E-04	1.26E-04
7	nom	5.00E-11	2.50E-12	pass	1.00E+09	9.60E-06	1.16E-06	7.80E-07	1.15E-06	8.782	6.51E-04	2.77E-12	4.17E-02	3.33E-11	4.73E-04	4.99E-04	1.25E-04	1.26E-04
8	nom	6.00E-11	3.00E-12	pass	1.00E+09	9.60E-06	1.28E-06	9.00E-07	1.28E-06	6.353	5.96E-04	2.48E-12	3.81E-02	3.00E-11	4.73E-04	4.99E-04	1.26E-04	1.27E-04
9	nom	7.00E-11	3.50E-12	pass	1.00E+09	9.60E-06	1.22E-06	9.61E-07	1.22E-06	7.093	5.34E-04	2.72E-12	3.42E-02	2.78E-11	4.74E-04	4.99E-04	1.26E-04	1.27E-04
10	nom	8.00E-11	4.00E-12	pass	1.00E+09	9.60E-06	1.34E-06	8.94E-07	1.34E-06	5.724	5.32E-04	2.48E-12	3.40E-02	2.74E-11	4.74E-04	4.99E-04	1.26E-04	1.28E-04
11	nom	9.00E-11	4.50E-12	pass	1.00E+09	9.60E-06	1.60E-06	1.28E-06	1.67E-06	3.965	5.90E-04	2.72E-12	3.78E-02	2.97E-11	4.74E-04	4.99E-04	1.26E-04	1.28E-04
12	nom	1.00E-10	5.00E-12	pass	1.00E+09	9.60E-06	1.47E-06	1.15E-06	1.48E-06	2.672	5.08E-04	2.43E-12	3.25E-02	2.53E-11	4.74E-04	4.99E-04	1.27E-04	1.29E-04
```



将这些性能都综合起来，同时考虑 $C_P$ 不应过大，综合得分如下图：
<div class="center"><img width=600px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-18-33-00_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

``` bash
co = [3 3 -1 1 1 1 1]';
data_nomalized_sum = sum(data_nomalized.*co, 1) + exp(CP'/100);
```


最终我们选择 **(1 kOhm, 50 pF)** 作为 "最佳参数"：

## 6. Pre-Layout Simulation

先定义 nominal 和 worst simulation condition:
- nominal: 27 °C, TT, 1.0 V
- worst: -45 °C, SS, 0.9 V

相比于 2 GHz, 1 GHz 下的锁定更困难，相位噪声也更高 (频率与 jitter 呈负相关, 但是与 normalized jitter 呈正相关)，因此若无特别说明，均默认目标输出频率为 1 GHz (参考源频率 15.625 MHz).

下面，基于上面得到的 "最佳参数"，先在 nominal 情况下进行仿真，最后再给出 worst 情况下的工作波形。



### 6.0 schematic preview

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-17-40-37_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

### 6.1 start-up response

设置好瞬态仿真和 outputs, 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-01-55-51_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-02-00-35_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-02-02-03_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-02-04-16_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>

由图知道 locking time = 779.6 ns.


### 6.2 steady-state waveform

后面 jitter 的计算会用到瞬态仿真的数据，为保证 jitter 计算的准确性，我们希望稳定之后能有至少 70000 个周期的数据，因此设定仿真结束时间为 time_end = 1500/f_REF = 96 us, 其中 f_REF = 1GHz/64 = 15.625 MHz.

修改之后运行仿真，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-14-46-06_Virtuoso Tutorials - 12. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

锁定之后的波形：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-14-59-15_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>


### 6.3 transient jitter analysis

有关 jitter 和 phase noise 的基础知识见文章 [Jitter and Phase Noise in Mixed-Signal Circuits](<AnalogIC/Phase Noise and Jitter in Mixed-Signal Circuits.md>)，锁相环的 FoM 公式详见参考文献 [[3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9847207):

$$
\begin{gather}
\mathrm{FoM}_{J} = 10 \log_{10} \left[ \left(\frac{J_{rms}}{1 \ \mathrm{s}}\right)^2\cdot \left(\frac{\mathrm{power}}{1 \ \mathrm{mW}}\right) \right]
= \mathrm{J_{rms}}_{\mathrm{dB}} + \mathrm{power}_{\mathrm{dBm}}
\\
\mathrm{FoM}_{JAN} = 10 \log_{10} \left[
    \left(\frac{J_{rms}}{1 \ \mathrm{s}}\right)^2
    \cdot 
    \left(\frac{\mathrm{power}}{1 \ \mathrm{mW}}\right) 
    \cdot 
    \left( \frac{\mathrm{area}}{1 \ \mathrm{mm^2}} \right)
    \cdot 
    \left( \frac{1}{N} \right)
    \right]
\end{gather}
$$

根据 transient simulation 得到的瞬态抖动结果，参考这篇文章 [Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation](<AnalogIC/Virtuoso Tutorials - 13. VCO and PLL Simulation (Periodical Steady-State and Phase Noise).md>)，可以计算出  transient period jitter (cycle jitter) 和 FoM:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-18-44-48_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

$$
\begin{gather}
I_{DD} = 472.9 \ \mathrm{uA},\ J_{c, rms} = 2.800 \ \mathrm{ps},\ N = 64
\\
\Longrightarrow 
\mathrm{FoM}_J = -234.3 \ \mathrm{dB},\quad 
\mathrm{FoM}_JN = -252.4 \ \mathrm{dB}
\end{gather}
$$

### 6.4 phase noise and jitter

当然，也可以用 pnoise 仿真得到 jitter, 下图是 edge-to-edge jitter 的仿真情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-19-51-33_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

在 1 kHz ~ 1 MHz 范围内积分 (环路带宽 0.416 MHz), 得到 RMS edge-to-edge jitter = 3.901 ps, 于是：

$$
\begin{gather}
I_{DD} = 472.9 \ \mathrm{uA},\ J_{ee,rms} = 3.901 \ \mathrm{ps},\ N = 64
\\
\Longrightarrow 
\mathrm{FoM}_J = -231.4 \ \mathrm{dB},\quad 
\mathrm{FoM}_{JN} = -249.5 \ \mathrm{dB}
\end{gather}
$$


### 6.5 worst-corner simul

设置 corner = {-45 °C, SS, 0.9 V} 进行仿真，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-23-02-59-53_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-23-03-04-05_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-23-03-06-54_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-23-03-09-48_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


### 6.6 brief summary

下表列出了主要仿真结果：
<div class='center'><span style='font-size: 14px'> 


| Parameter | Process | Locking Range | Locking Time | RMS Jitter | Power Consumption | FoM_J | FoM_JN |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| **Value** | 28nm CMOS | 0.5 GHz ~ 3.0 GHz | 779.6 ns | 2.800 ps | 472.9 uA @ 1 V | -234.3 dB | -252.4 dB |

</span>
</div>

本次设计的原始数据已上传到连接 [202508_CPPLL_rawData.zip](https://www.writebug.com/static/uploads/2025/8/22/4437bf0044ac47139b9e685831ff203b.zip)，下面是此设计相关 MATLAB 代码：

``` bash
Type-II PLL (Rp + Cp + Cpp)
syms A Phi_out Phi_in Delta_phi s omega_0 omega_in phi_0 Delta_omega omega_LPF t x alpha tau_P
syms I_P C_P C_2 K_VCO R_P
LPF = simplifyFraction(MyParallel(R_P + 1/(s*C_P), 1/(s*(alpha*C_P))))
H_OL = simplifyFraction(I_P/(2*pi) * LPF * K_VCO/s)
H_CL = simplifyFraction(H_OL/(1 + H_OL))

subs(LPF, alpha, 0)

stc = MyAnalysis_TransferFunction(H_CL, 0);
simplify(subs(stc.deno, s, (1+1/alpha)/(R_P*C_P)))

离散 z 变换
syms A Phi_out Phi_in Delta_phi s omega_0 omega_in phi_0 Delta_omega omega_LPF t x
syms I_P C_P C_2 K_VCO R_P tau_P z K_P
D = (z - 1)^2 + (z - 1)*2*pi*K_P/(omega_in*tau_P)*(1 + 2*pi/(omega_in*tau_P)) + K_P*(2*pi/(omega_in*tau_P))^2
z = solve(D, z);
z_1 = z(1); z_2 = z(2)
%SQRT = K_P*(4 K_P*pi^2 - 4*omega_in^2*tau_P^2 + K_P*omega_in^2)
SQRT = K_P*(4*K_P*sym(pi)^2 - 4*omega_in^2*tau_P^2 + K_P*omega_in^2*tau_P^2 + 4*sym(pi)*K_P*omega_in*tau_P)
K_P = solve(SQRT == 0, K_P);
K_P = K_P(2)

eqs = [
R_P*C_P == 10*pi/(3*omega_in)
K_VCO*I_P*R_P/(2*pi)*(R_P*C_P) == 2
];
stc = solve(eqs, [R_P, C_P])
stc.R_P
stc.C_P

PLL behavior-level simulation (理论最佳参数)
I_P = 100e-6;
Divide_N = 64;
f_osc = [1 1.5 2]*10^9;
f_REF = f_osc/Divide_N;
K_VCO = 9.3e9;
K_VCO_eq = K_VCO/Divide_N;

omega_in = 2*pi*f_REF;
tau_P = 10*pi./(3*omega_in);
R_P = 6*omega_in./(5*K_VCO_eq*I_P);
C_P = 25*pi*K_VCO_eq*I_P./(9*omega_in.^2);

%disp('-----------')
%disp(['tau_P = ', num2str(tau_P*1e6), ' us'])
%disp(['omega_in = ', num2str(omega_in/1e6), ' Mrad/s'])
%disp(['K_VCO_eq = ', num2str(K_VCO_eq/1e6), ' Mrad/(s*V)'])
disp('-----------')
disp('Best parameters ignoring I_P*R_P ripple:')
disp(['f_osc = ', num2str(f_osc/10^9), ' GHz'])
disp(['f_REF = ', num2str(f_REF/10^6), ' MHz'])
disp(['R_P = ', num2str(R_P/1e3), ' kOhm'])
disp(['C_P = ', num2str(C_P*1e12), ' pF'])

%I_P*R_P


根据给定阻容计算其它参数
I_P = 100e-6;
K_VCO = 9.3e9;

f_in = 25e6;
omega_in = 2*pi*f_in;

Divide_N = 64
R_P = 7e3
C_P = 10e-12


K_VCO_eq = K_VCO/Divide_N; tau_P = R_P*C_P; K = K_VCO_eq*I_P*R_P/(2*pi);
zeta =sqrt(K*tau_P)/2
omega_BW = 2*(sqrt(2)-1)*zeta/tau_P; ratio = omega_in/omega_BW
discrete = 1/(K*tau_P)
discrete_min = pi/(omega_in*tau_P)*(1 + pi/(omega_in*tau_P))

MOSFET gm/Id I_nor 数据
X = [
7.123
5.815
4.792
3.980
3.326
2.794
2.357
1.993
1.688 
];
Y = [
7.109
5.661
4.546
3.680
3.001
2.463
2.034
1.686
1.403
];
round(0.5*(X + Y), 3)

最终计算：根据给定阻容计算其它参数
I_P = 100e-6;
K_VCO = 8e9;
Divide_N = 64;

f_osc = [1 1.5 2]*10^9;    % 设置预期 f_osc (f_fb = f_osc/64)

K_VCO_eq = K_VCO/Divide_N; 
f_REF = f_osc/Divide_N;
omega_in = 2*pi*f_REF;

% 设置阻容参数
R_P = 1e3;
C_P = 50e-12;
disp(['R_P = ', num2str(R_P/1e3), ' kOhm'])
disp(['C_P = ', num2str(C_P*1e12), ' pF'])

tau_P = R_P*C_P; K = K_VCO_eq*I_P*R_P/(2*pi);
zeta =sqrt(K*tau_P)/2
omega_BW = 2*(sqrt(2)-1)*zeta/tau_P; ratio = omega_in/omega_BW; disp(['(omega_BW/onega_REF)^(-1) = ', num2str(ratio)])
discrete = 1/(K*tau_P); discrete_min = pi./(omega_in*tau_P).*(1 + pi./(omega_in*tau_P)); if discrete > discrete_min; disp(['discrete = ', num2str(discrete), ' > discrete_min = ', num2str(discrete_min)])
disp(['f_BW = ', num2str(omega_BW/(2*pi)/10^6), ' MHz'])
else
    error(['[Error] discrete = ', num2str(discrete), ' < discrete_min = ', num2str(discrete_min)])
end
disp(['discrete ratio = ', num2str(discrete./max(discrete_min))])
disp('Recommanded: zeta > 0.5, discrete ratio > 4')

C_2 = C_P/20;
R_P_max = 1./(5*f_REF*C_2)   % 每周期仅一次充/放电 (单个 PFD)



FoM 计算
%% FoM_J
I_average = 472.9e-6; %I_average = 485e-6;
N = 64;
power = 1*I_average;
sigma_RMSjitter = 2.800e-12; %sigma_RMSjitter = 0.5e-12;
FoM_J = 10*log( (sigma_RMSjitter/1)^2 * (power/1e-3) )/log(10)
FoM_JN = 10*log(  (sigma_RMSjitter/1)^2 * (power/1e-3) * (1/N)  )/log(10)

%% FoM_JN
I_average = 473e-6; %I_average = 485e-6;
power = 1*I_average;
sigma_RMSjitter = 35.955e-12; %sigma_RMSjitter = 0.5e-12;
N = 64;
FoM_JN = 10*log(  (sigma_RMSjitter/1)^2 * (power/1e-3) * (1/N)  )/log(10)


%10*log((power/1e-3))/log(10)
%20*log(sigma_RMSjitter)/log(10)

RP CP 仿真结果曲线
CP = [
2.00E-11
2.50E-11
3.00E-11
3.50E-11
4.00E-11
4.50E-11
5.00E-11
6.00E-11
7.00E-11
8.00E-11
9.00E-11
1.00E-10
]*10^12;
str = [
"selttling time @ 1% of VCONT"
"selttling time @ 1% of VCP"
"overshoot of VCP"
"absolute frequency jitter of VOUT"
"std deviation of period jitter of VOUT"
"absolute frequency jitter of VFB"
"std deviation of period jitter of VFB"
];


data = [
% (1) 1% locking time (s)
% (2) 0.05% locking time (s)
% (3) VCP overshoot (%)
% (4) VOUT abs freq jitter (%)
% (5) VOUT period jitter std deviation (s)
% (6) VFB abs freq jitter (%)
% (7) VFB period jitter_sigma (s)
8.90E-06	1.09E-06	19.21	1.34E-03	3.23E-12	8.61E-02	6.51E-11
7.87E-06	5.77E-07	3.983	1.08E-03	2.88E-12	6.91E-02	5.41E-11
1.22E-06	7.66E-07	9.219	9.40E-04	2.96E-12	6.02E-02	4.75E-11
1.09E-06	7.75E-07	11.85	9.24E-04	2.90E-12	5.92E-02	4.79E-11
1.28E-06	8.33E-07	12.72	8.88E-04	2.91E-12	5.69E-02	4.48E-11
1.15E-06	7.72E-07	7.759	7.79E-04	2.88E-12	4.98E-02	4.16E-11
1.16E-06	7.80E-07	8.782	6.51E-04	2.77E-12	4.17E-02	3.33E-11
1.28E-06	9.00E-07	6.353	5.96E-04	2.48E-12	3.81E-02	3.00E-11
1.22E-06	9.61E-07	7.093	5.34E-04	2.72E-12	3.42E-02	2.78E-11
1.34E-06	8.94E-07	5.724	5.32E-04	2.48E-12	3.40E-02	2.74E-11
1.60E-06	1.28E-06	3.965	5.90E-04	2.72E-12	3.78E-02	2.97E-11
1.47E-06	1.15E-06	2.672	5.08E-04	2.43E-12	3.25E-02	2.53E-11  
]';
data_nomalized = data./min(data, [], 2);
stc = MyPlot(CP', data_nomalized);
ylim([1 4])
MyFigure_ChangeSize([1.7 1]*1024);
stc.leg.String = str;
stc.leg.Interpreter = 'latex';

marker_str = [
"+" "o" "*" "." "x" ...             % 1  ~ 5
"square" "diamond" "v" "^" ">" ...  % 6  ~ 10
"<" "pentagram" "hexagram" "|" "_"   % 11 ~ 15
];
stc.plot.plot_1.Marker = marker_str{2};
stc.plot.plot_2.Marker = marker_str{5};
stc.plot.plot_3.Marker = marker_str{6};
stc.plot.plot_4.Marker = marker_str{7};
stc.plot.plot_5.Marker = marker_str{9};
stc.plot.plot_6.Marker = marker_str{12};
stc.plot.plot_7.Marker = marker_str{8};

for i = 1:7
    stc.plot.(['plot_', num2str(i)]).LineWidth = 3;
    stc.plot.(['plot_', num2str(i)]).MarkerSize = 15;
end
stc.label.y.String = 'Normalized Value';
stc.label.x.String = 'Value of $C_P$ (pF)';


co = [3 3 -1 1 1 1 1]';
data_nomalized_sum = sum(data_nomalized.*co, 1) + exp(CP'/100);

stc = MyPlot(CP', data_nomalized_sum);
xlim([20 100])
ylim([0 25])
MyFigure_ChangeSize([1.5 1]*512*1.3);
stc.label.y.String = 'Synthesis Score';
stc.label.x.String = 'Value of $C_P$ (pF)';


transient jitter analysis 
(参考 Cadence_PLL_Jitter_measurment_in_Spectre.pdf)
%vout_freq = readmatrix("D:\a_Win_VM_shared\202508_CPPLL_1k_50p_vout_freq_settled.csv"); nfft=2^12;
%vout_freq = readmatrix("D:\a_Win_VM_shared\best_pass_1k_50p_1G-1500periods_tran__vfb_freq.csv"); nfft=2^10;
vout_freq = readmatrix("D:\a_Win_VM_shared\best_pass_1k_50p_1G-1500periods_tran__vout_freq.csv"); nfft=2^16;
vout_freq = vout_freq(:, 2);
vout_period = 1./vout_freq;
periods = vout_period;

%% 下面的代码主要参考 Cadence_PLL_Jitter_measurment_in_Spectre.pdf
echo off;
% nfft should be power of two
winLength=nfft;
overlap=nfft/2;
winNBW=1.5;
% Noise bandwidth given in bins (defult 1.5)
% Load the data from the file generated by the VCO load periods.m
% output estimates of period and jitter
T=mean(periods);
J=std(periods);     % standard deviation of period jitter
maxdT = max(abs(periods-T))/T;
fprintf('T = %.3gs, F = %.3gHz\n',T, 1/T);
fprintf('J_sigma = %.3gs, Jrel = %.2g%%\n', J, 100*J/T);
fprintf('max dT = %.2g%%\n', 100*maxdT);
fprintf('periods = %d, nfft = %d\n', length(periods), nfft);
% compute the cumulative phase of each transition
phases=2*pi*cumsum(periods)/T;

% compute power spectral density of phase 
% function psd() has been deprecated, use function pwelch as an alternative solution
% [Sphi,f]=psd(phases,nfft,1/T,winLength,overlap,'linear');
[Sphi, f] = pwelch(phases, winLength, overlap, nfft, 1/T, 'psd');

% correct for scaling in PSD due to FFT and window 
Sphi=winNBW*Sphi/nfft;
% plot the results (except at DC) 
K = length(f);

%{
semilogx(f(2:K), 10*log10(Sphi(2:K)));
title('Noise Power Spectral Density at the output of the PLL');
xlabel('Frequency (Hz)');
ylabel('S phi (dB/Hz)');
%}

rbw = winNBW/(T*nfft);
RBW=sprintf('Resolution bandwidth = %.3f kHz (%.3f dB)', rbw/10^3, 10*log10(rbw));
line1=sprintf('Period = %.3f ns, Frequency = %.4f MHz\n', T*10^9, 1/T/10^6);
line2=sprintf('Std dev of period jitter = %.3f ps (normalized %.2g %%)\n', J*10^12, J/T*100);
line4=sprintf('Number of periods = %d, FFT points = %d\n', length(periods), nfft);



% 作图
stc = MyPlot(f(2:(K-1))', 10*log10(Sphi(2:(K-1)))');
stc.axes.XScale = 'log';
xlim([10^4 10^7])
ylim([-100 0])
stc.axes.Title.String = 'Noise Power Spectral Density at the output of the PLL';
stc.label.x.String = 'Frequency (Hz)';
stc.label.y.String = 'S phi (dB/Hz)';
MyFigure_ChangeSize([1.7, 1]*512*1.2)
text.num1 = imtext(0.3,0.11, line4);
text.num2 = imtext(0.3,0.17, line2);
text.num3 = imtext(0.3,0.23, line1);
text.num4 = imtext(0.3,0.07, RBW);

for i = 1:4
    text.(['num', num2str(i)]).FontName = 'Times New Roman';
    text.(['num', num2str(i)]).FontSize = 13;
end

stc = MyHistogram(periods, T/600, 1);
%ystr = stc.axes.YTickLabel;
%ylabel = str2num(ystr)


data = periods*10^9 - 1;
% 绘制直方图并拟合正态分布
figure;
histfit(data, 100, 'normal'); % 30个柱子，正态分布拟合
title('直方图与正态分布拟合 (Histfit)');
xlabel('数值');
ylabel('频数');

% 计算均值和标准差
mu = mean(data);
sigma = std(data);

% 添加均值和sigma标注
hold on;
% 绘制均值线
xline(mu, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('mu = %.2f', mu));
% 绘制 ±1σ 线
xline(mu + sigma, 'g--', 'LineWidth', 1.5, 'DisplayName', sprintf('+1σ = %.3e', mu+sigma));
xline(mu - sigma, 'g--', 'LineWidth', 1.5, 'DisplayName', sprintf('-1σ = %.3e', mu-sigma));
% 绘制 ±2σ 线
xline(mu + 2*sigma, 'b:', 'LineWidth', 1.5, 'DisplayName', sprintf('+2σ = %.3e', mu+2*sigma));
xline(mu - 2*sigma, 'b:', 'LineWidth', 1.5, 'DisplayName', sprintf('-2σ = %.3e', mu-2*sigma));
% 绘制 ±3σ 线
xline(mu + 3*sigma, 'r-', 'LineWidth', 1.5, 'DisplayName', sprintf('+3σ = %.3e', mu+3*sigma));
xline(mu - 3*sigma, 'r-', 'LineWidth', 1.5, 'DisplayName', sprintf('-3σ = %.3e', mu-3*sigma));

legend('show');
hold off;
MyFigure_ChangeSize([2, 1]*512*1.2)
用噪声功率谱计算 cycle jitter (period jitter)
f_osc = 1e9;
f_min = 10^5;
X = f(f > f_min);
Y = Sphi(f > f_min);
%Sj = Sphi/()
%Jc_square = 4*


% 指定X坐标（适用于非等间距情况）
integral_value2 = trapz(X, Y);
disp(['使用 trapz(X, Y) 积分结果: ', num2str(integral_value2)]);
A = 10*log10(integral_value2)  % Integrated Phase Noise Power (dBc) 
RMS_jitter_rad = sqrt(2*10^(A/10))
RMS_jitter_sec = RMS_jitter_rad/(2*pi*f_osc);
disp(['RMS_jitter = ', num2str(RMS_jitter_sec*10^9), ' ns'])
disp(['RMS_jitter = ', num2str(RMS_jitter_sec*10^9), ' ns'])



RMS Jee 频谱计算总 Jitter
data = readmatrix("D:\a_Win_VM_shared\202508_CPPLL_phaseNoise_rmsJee.csv");
f_min = 1e3;
f_max = 1e6;


freq = data(:, 1); freq = freq(freq > f_min & freq < f_max);
Jee = data(:, 2);  Jee = Jee(freq > f_min & freq < f_max);
Jee_RMS = sqrt(trapz(freq, Jee.^2));
disp(['RMS Jee integ from 1 kHz to 1 MHz = ', num2str(Jee_RMS*10^12), ' ps'])

%% FoM_J, FoM_JN
I_average = 472.9e-6; %I_average = 485e-6;
N = 64;
power = 1*I_average;
sigma_RMSjitter = Jee_RMS; %sigma_RMSjitter = 0.5e-12;
FoM_J = 10*log( (sigma_RMSjitter/1)^2 * (power/1e-3) )/log(10)
FoM_JN = 10*log(  (sigma_RMSjitter/1)^2 * (power/1e-3) * (1/N)  )/log(10)
```


## References

- [[1]](https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system) M. Aldacher, “muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system.” Accessed: Jun. 30, 2025. [Online]. Available: https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system
- [[2]](https://u.dianyuan.com/bbs/u/29/1116306785.pdf) F. Gardner, “Charge-Pump Phase-Lock Loops,” IEEE Transactions on Communications, vol. 28, no. 11, pp. 1849–1858, Nov. 1980, doi: 10.1109/TCOM.1980.1094619.
- [[3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9847207) W. Bae, “Benchmark Figure of Merit Extensions for Low Jitter Phase Locked Loops Inspired by New PLL Architectures,” IEEE Access, vol. 10, pp. 80680–80694, 2022, doi: 10.1109/ACCESS.2022.3195687.
- [[4]](https://www.zhihu.com/question/452068235/answer/95164892409) B. Razavi, Design of Analog CMOS Integrated Circuits, Second edition. New York, NY: McGraw-Hill Education, 2017.
- [[5]](https://www.zhihu.com/question/23142886/answer/108257466853) B. Razavi, Design of CMOS Phase-Locked Loops. New York, NY: Cambridge University Press, 2020.
- [[6]](https://www.ideals.illinois.edu/items/49560) R. Ratan, Design of a Phase-Locked Loop Based Clocking Circuit for High Speed Serial Link Applications. [Online]. Available: https://www.ideals.illinois.edu/items/49560
- [[7]](https://snehilverma41.github.io/PLL_Report.pdf) Phase-Locked Loop (Design and Implementation). Accessed: Jun. 30, 2025. [Online]. Available: https://snehilverma41.github.io/PLL_Report.pdf
- [[8]](https://www.ideals.illinois.edu/items/50583) D. Wei, Clock Synthesizer Design With Analog and Digital Phas-Locked Loop. [Online]. Available: https://www.ideals.illinois.edu/items/50583
- [[9]](https://seas.ucla.edu/brweb/papers/Journals/BRFall16TSPC.pdf) B. Razavi, “TSPC Logic [A Circuit for All Seasons],” IEEE Solid-State Circuits Mag., vol. 8, no. 4, pp. 10–13, 2016, doi: 10.1109/MSSC.2016.2603228.
- [[10]](https://ieeexplore.ieee.org/document/7754138) H. Ashwini, S. Rohith, and K. A. Sunitha, “Implementation of high speed and low power 5T-TSPC D flip-flop and its application,” in 2016 International Conference on Communication and Signal Processing (ICCSP), Melmaruvathur, Tamilnadu, India: IEEE, Apr. 2016, pp. 0275–0279. doi: 10.1109/ICCSP.2016.7754138.
- [11] H.-T. Ahn and S.-S. Lee, “A 216µW 281MHz-1.126GHz Self-Calibrated SSCG PLL with 0.6V Supply Voltage in 55nm DDC™ CMOS Process”, doi: 10.1587/elex.18.20200441.
- [14] J. Yuan and C. Svensson, “High speed CMOS circuit technique,” IEEE Journal of Solid-State Circuits, vol. 24, no. 1, pp. 62–70, 1989, doi: 10.1109/4.16303.
- [15] “Jitter measurement using SpectreRF Application Note.” [Online]. Available: https://www.writebug.com/static/uploads/2025/8/22/28c1f61cd30eb054e8a9d5c6824f4d7e.pdf
- [16] “PLL_Jitter_measurment_in_Spectre.” [Online]. Available: https://www.writebug.com/static/uploads/2025/8/22/705f40616dd3afd7796ddfbe1d5b66d8.pdf
- [17] Snehil Verma, “Phase-Locked Loop (Design and Implementation)”, Accessed: Jun. 30, 2025. [Online]. Available: https://snehilverma41.github.io/PLL_Report.pdf
