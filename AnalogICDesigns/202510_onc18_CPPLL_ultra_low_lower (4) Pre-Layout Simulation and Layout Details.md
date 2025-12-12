# 202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 01:03 on 2025-11-16 in Beijing.


>注：本文是项目 [Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology](<Projects/Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology.md>) 的附属文档，用于全面记录 PLL 的设计/迭代/仿真/版图/后仿过程。


续前文 [202510_onc18_CPPLL_ultra_low_lower (3) Design of Other Modules](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (3) Design of Other Modules.md>), 本文继续记录 PLL 的设计进展。

## 1. Pre-Simul Preparation

前仿之前，我们还有一些准备工作要做，包括但不限于之前没加上的辅助模块 (analog MUX, clock buffer) 和电容电阻实现方式等。

### 1.1 analog MUX4

<div class='center'>

| 我们采用的 Analog MUX 结构 | 其它参考资料 | 其它参考资料 |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-23-37-33_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | [TI Documents > Basics of Analog Multiplexers 1](https://www.ti.com.cn/content/dam/videos/external-videos/en-us/1/3816841626001/5125907075001.mp4/subassets/switches-and-muxes-on-resistance-flatness-and-on-capacitance-presentation-quiz.pdf) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-18-35-39_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-18-36-06_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | [ADI MT-088 Tutorial > Analog Switches and Multiplexers Basics](https://www.analog.com/media/en/training-seminars/tutorials/MT-088.pdf) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-18-39-00_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |

</div>

仿真验证：

<div class='center'>

| testbench 原理图 | 仿真结果 |  |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-23-40-03_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-23-41-01_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |  |
</div>

### 1.2 big clock buffer

这一小节来设计引到 PAD 用于测试的 clk buffer, 仿真结果如下：

<div class='center'>

| Buffer Chain 简单测试 |  |  |
|:-:|:-:|:-:|
 | testbench 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-00-23-45_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 单个 Buffer Chain 带载能力 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-00-04-56_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 两个 Buffer Chain (级联) 带载能力 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-00-07-38_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 综合考虑版图安排，固定尺寸为 **wg/lg = 3.60/0.18 (a = 20)**, 考察 ka 对带载能力影响 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-00-25-42_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 固定尺寸为 **(ka, wg, lg) = (2, 3.6, 0.18)**, 进一步仿真带载能力 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-00-34-34_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |  |
</div>

**2025.11.15 01:12 注: 上面这个表的仿真, BUF 参数设置错误，固定为了 (ka, wg, lg) = (2.5, 0.84, 0.18), multiplier 倒是正确设置了，所以才会出现带载能力与尺寸完全无关的 "错误结果"。**

有了基本的设计框架后，我们需要对 buffer chain 的抖动进行优化：

<div class='center'>

| 设置 transient noise f_max = 10 x (8 x f_ref) 进行抖动测试 (CL = 20 pF) |  |  |
|:-:|:-:|
 | **(ka, wg, lg) = (2.5, 0.84, 0.18)** 时的抖动表现： <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-01-07-07_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 左图可以看出，buffer chain 带来的额外抖动很小，放在环路中应该也是类似的效果，负面效果可以忽略 |
 | 不同尺寸下的性能 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-01-19-13_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |  |  |
</div>


<div class='center'>

| Big Buffer 尺寸选型结果 |  |
|:-:|:-:|
 | wg = 1.8u or 3.6u (ka = 2.0, lg = 0.18) 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-11-31-39_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 输出占空比偏大，应该增大 INV threshold voltage, 等价于 **减小 ka** |
 | 不妨先试一下增大至 ka = 2.5 的效果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-11-38-01_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |  |
 | 然后再试试减小至 ka = 1.25 or 1.5 的效果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-11-51-38_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 相比于较大的 ka, ka 减小后占空比和 jitter 都有所改善，但 SR 下降 (带载能力下降) |
</div>

这样看还是太麻烦了，我们直接做参数遍历吧：

<div class='center'>

| 两级 Buffer 原理图 | 两级 Buffer 遍历结果 (有筛选, 按尺寸排序) | CK_X24  (signal Y) Jc_n 与 Je_n 图像 | CK_X03 (signal Z) Jc_n 与 Je_n 图像 |
|:-:|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-22-30-34_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-23-15-10_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-23-19-50_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-23-22-37_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 综合考虑版图面积、抖动和功耗，我们选取 **(ka, wg, lg) = (2.0, 3.60, 0.18)** 作为两级 BUF 的最佳参数，每个 BUF 有两级，两个 BUF 仅 Gate 部分需消耗面积 25um x 50um (相比电容其实挺小了) | 其在 CL = 20pF 输出波形如图 (输出波形的) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-23-28-01_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 在 CL = 0.1fF 的输出波形如图 |  |
 | 单极 Buffer 原理图 | **单极 Buffer 遍历结果 (有筛选, 按尺寸排序)** | **单极 Buffer 尺寸选型** | **单极 Buffer 最佳尺寸** |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-23-17-04_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-23-40-40_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | x | x |
 | 对单极 BUF 来讲，我们选取 **(ka, wg, lg) = (2.5, 14.4, 0.18)** 作为最佳参数，当然，这个宽长比有些大了，我们将其调整为 **(ka, ng, wg, lg) = (2.5, 2, 7.2, 0.18)** | 此参数下的 big BUF, 在既保持了一定带载能力，又在抖动和面积方面都有提升， **于是选取它作为最终 BUF** |  |  |
</div>

### 1.3 small clock buffer


**注意 small buffer 的功耗是算在电路中的，功耗不能太大。**

<div class='center'>

| Small Buffer 原理图 (两个 INV 构成) | 遍历结果 (有筛选, 按尺寸排序) | CK_X24  (signal Y) Jc_n 与 Je_n 图像 | CK_X03 (signal Z) Jc_n 与 Je_n 图像 |
|:-:|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-00-03-08_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-00-12-45_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-00-42-09_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-00-42-50_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 综合考虑功耗和抖动 (主要是功耗)，我们选择 **(ka, wg, lg) = (2.5, 0.84, 0.18)** 作为 small BUF 的最佳参数, **两个 BUF 共额外消耗电流 25 nA (CL = 0.1 fF)** | 在 CL = 50fF 的输出波形如图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-00-47-11_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |  其在 CL = 0.1fF 输出波形如图  |  |
</div>



### 1.4 actual cap and res

**<span style='color:red'> LPF 中的电容改用 `cmimhc` 来实现 (multiplier x 0.5 pF)，电阻的话，改用 `rppolyhr` (multiplier 0.5 MOhm) </span>**

<div class='center'>

| 高密度电阻 rnwsti 与 rppolyhr 对比 |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-01-52-43_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 尽管 rnwsti 的 PC (process coefficient) 系数较小，但其温度系数较大，在 100°C 跨度下变化量达到 0.4 (40 %)；反过来看, rppolyhr 具有更高的电阻密度和更小的温度系数，因此我们选择 rppolyhr 作为具体电阻实现 |
 | 将 `cmimhc` 和 `rppolyhr` 封装成 pcell, 版图效果如下 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-02-18-07_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 在当前工艺库设置下 (m5t08), `cmimhc` 的两端分别在 M4 和 M5 (m5t08), `rppolyhr` 的两端则是在 M1 |
</div>


仿真验证过，电阻的 `TUB` 端电位对电阻没有影响 (版图中也没有这个端口)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-22-49-17_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>

TUB 端悬空是能正常过 DRC/LVS 的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-19-23-08-06_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div>

### 1.5 trimming range

为保证电路性能灵活性，我们给 IP of CP 和 C1 of LPF 留出一些 trimming range. 当前的两种最佳环路参数分别为：
- RVCO1: (IP, R1, C1, C2) = (20 nA, 10.5 MOhm, 24 pF, 2 pF)
- RVCO2: (IP, R1, C1, C2) = (20 nA, 10.5 MOhm, 33 pF, 3 pF)

不妨将带有 trimming range 的环路参数设置为：


- R1: **R1 = 10.0 MOhm (20 x 0.5 MOhm) 固定**
- IP:
    - **IP = 20 nA**
    - trimming range: 1 x 5nA ~ 8 x 5nA = 5 nA ~ 40 nA (5 nA 步进)
    - 共四组电流: 5nA (恒开启) 以及可开关的 5nA, 10nA, 20nA
- C1:
    - **C1 = 24 pF (RVCO1) or 36 pF (RVCO2)**
    - trimming range: 1 x 6pF ~ 8 x 6pF = 6 pF ~ 48 pF (6 pF 步进)
    - 共四组电容: 6pF (恒开启) 以及可开关的 6pF, 12pF, 24pF
- C2: 
    - **C2 = 2 pF (RVCO1) or 3 pF (RVCO2)**
    - trimming range: 1 x 0.5pF ~ 8 x 0.5pF = 0.5 pF ~ 4 pF (0.5 pF 步进)
    - 共四组电容: 0.5pF (恒开启) 以及可开关的 0.5pF, 1pF, 2pF

这样设置的好处是，保留充足 trimming range 和精度的同时，C1 和 C2 的值可以由 3-bit code 共同控制，保持了 alpha = C2/C1 = 1/12 不变。实现 trimming 一共需要 6-bit code.

如果想一共用 4-bit code 来实现 trimming range control, 可以做成这样：
- R1: **R1 = 10.0 MOhm (20 x 0.5 MOhm) 固定**
- IP:
    - **IP = 20 nA** (multiplier = 4)
    - trimming range: 15 nA ~ 30 nA (5 nA 步进)
    - 共三组管子: 15nA (恒开启) 以及可开关的 5nA, 10nA
- C1:
    - **C1 = 24 pF (RVCO1) or 36 pF (RVCO2)**
    - trimming range: 24 pF ~ 42 pF (6 pF 步进)
    - 共三组电容: 24pF (恒开启) 以及可开关的 6pF, 12pF
- C2: 
    - **C2 = 2 pF (RVCO1) or 3 pF (RVCO2)**
    - trimming range: 2.0 pF ~ 3.5 pF 
    - 共三组电容: 2pF (恒开启) 以及可开关的 0.5pF, 1pF



与导师讨论之后，我们采用 2-bit IP + 3-bit C1 (and C2) 方案。注意关注电阻和电容的工艺/温度偏差：
- 不同工艺角/温度下，电阻 R1 (rppolyhr) 的值在 75% ~ 125% 之间变化
- 电容 C1 (cmimhc) 的值在 78% ~ 114% 之间变化


综合考虑，设定 trimming range 如下：

<div class='center'>

| Papameter | Nominal Value | Triming Range | Implementation |
|:-:|:-:|:-:|:-:|
 | R1 | 10.0 MOhm           | no trimming (fixed) | 20 x 0.5MOhm |
 | IP | 20 nA               | 15 nA ~ 30 nA (5 nA 步进) | 共三组电流: 15nA (恒开启) 以及可开关的 5nA, 10nA |
 | C1 | 24 pF (or 33 pF)    | 21 pF ~ 42 pF (3 pF 步进) | 共四组电容: 21pF (恒开启) 以及可开关的 3pF, 6pF, 12pF |
 | C2 | 2 pF (or 2.75 pF)      | 1.75 pF ~ 3.50 pF (0.25 pF 步进) | 共四组电容: 1.75pF (恒开启) 以及可开关的 0.25pF, 0.5pF, 1pF |
</div>

此设置可大致覆盖以下范围：

<div class='center'>

| Divider N = 24 | Divider N = 48 |
|:-:|:-:|:-:|
 | Divider N = 24 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-23-03-03_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | Divider N = 48 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-15-23-04-51_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |

</div>


利用 analog MUX2 实现开关功能，原理图效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-00-00-19_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>


分别做一下基本单元 0.5MOhm, 0.25pF 和 0.5pF 的版图，便可实现总版图拼接。








### 1.5 noisy voltage supply




## 2. pre-layout simulation

### 2.1 simulation 1

第一次仿真时错误地将 small buffer 设置为了 m1 = m2 = 1, 这里将其改为 (m1, m2) = (1, 3) **注意 m2 = 3 而不是二** 重新进行仿真，具体设置如下：
- (1) PFD (1 point): 仍然使用 `PFD_NOR_v1`，也即 NOR-based PFD/CP with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 模拟尺寸为 (KA, WN, L) = (2.0, 0.42, 10.0), 数字尺寸与 PFD 一致
- (3) CP/LPF/VCO/FD (3 points): 使用三种最佳方案:
    - Option 1:
        - RVCO1 + FDX24_X01 + (20 nA, 10 MOhm, 24 pF, 2 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0, 0, 1) 
    - Option 2:
        - RVCO2 + FDX24_X01_retiming + (20 nA, 10 MOhm, 33 pF, 2.75 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (1, 0, 0)
    - Option 3:
        - RVCO1 + FDX48_X01 + (20 nA, 10 MOhm, 24 pF, 2 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0, 0, 1)
- (4) VDD ripple (1 point): 三种纹波与白噪声叠加
    - (a) ±10 mV triangular ripple @ 0.2 kHz (rise = 5%, fall = 95%)
    - (b) ±5 mV triangular ripple @ 1.0 kHz (rise = 5%, fall = 95%)
    - (c) ±5 mV sine ripple @ 300 kHz
    - (d) 2 mVrms white noise (fnoise_max = 100 MHz)
- (5) BUF (1 point):
    - big buffer: (ka, ng, wg, lg) = (2.0, 2, 7.2, 0.18) 
    - small buffer: (ka, wg, lg) = (2.5, 0.84, 0.18) @ (m1, m2) = (1, 3)
- (6) Output Setting (6 points): big buffer 端负载固定 20 pF, 输出频选与 small buffer 负载设置如下
    - (5.1) CK_OUT = CK_X24 @ CL = 0.1 fF with enabled BUF:  CL = 0.1 fF, (SL1, SL0) = (1, 1), BUF_EN = 1
    - (5.2) CK_OUT = CK_X24 @ CL = 0.1 fF with disabled BUF: CL = 0.1 fF, (SL1, SL0) = (1, 1), BUF_EN = 0
    - (5.3) CK_OUT = CK_X12 @ CL = 0.1 fF with disabled BUF: CL = 0.1 fF, (SL1, SL0) = (1, 0), BUF_EN = 0
    - (5.4) CK_OUT = CK_X24 @ CL = 40 fF with enabled BUF:   CL = 40 fF,  (SL1, SL0) = (1, 1), BUF_EN = 1
    - (5.5) CK_OUT = CK_X24 @ CL = 40 fF with disabled BUF:  CL = 40 fF,  (SL1, SL0) = (1, 1), BUF_EN = 0
    - (5.6) CK_OUT = CK_X12 @ CL = 40 fF with disabled BUF:  CL = 40 fF,  (SL1, SL0) = (1, 0), BUF_EN = 0
- (7) Corner (1 point): 仅考虑 TT27
- (8) Start-up (1 point): no start-up circuit
- (9) Else: transient time = 25 ms. (上述参数下 settling time < 5 ms)
- 上面一共是 3 x 6 = 18 个仿真点，每次仿真 **6 points**, 大约需要 3 x 4.5h = 14h

先用 Spectre FX + AX 仿真 tran = 5ms 测试一下：

<div class='center'>

| Spectre FX + AX 测试结果 |  |  |  |
|:-:|:-:|:-:|:-:|
 | 原理图设置 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-18-11-58_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 功耗情况 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-18-36-20_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |  |
 | 下面来看一下 CK_OUT = CK_X24 @ **Option 1** 的输出波形，也即固定 (SL1, SL0) = (1, 1)，仅改变 CL 和 BUF_EN 的值 | 由于 CL 和 BUF_EN 都是 CK_OUT (and CK_ADC) 的负载，这两个参数的改变会对 CK_OUT (and CK_ADC) 波形及性能有影响 |  |  |
 | (0.1 fF, BUF_EN = 1) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-18-22-25_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | (0.1 fF, BUF_EN = 0) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-18-27-17_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | (40 fF, BUF_EN = 1) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-18-29-12_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | (40 fF, BUF_EN = 0) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-18-30-46_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 上面四张图看出，当且仅当 BUF_EN = 1 时输出波形 CK_X03/CK_ADC 出现毛刺，原因是什么？ | 

</div>


### 2.2 buffer simulation

上面的输出毛刺是因为 EN_BUF = 1 时，输出的上升/下降沿电流 IDD 达到 mA 级别 (0.5 mA ~ 3 mA), 而我们设置的电源 R_out = 50 Ohm, 这就带来 25 mV ~ 150 mV 的 VDD 降低，使 CK_X03 等更低频信号出现毛刺。在实际供电时，供电输出电阻不会这么大 (估计在几 Ohm 以内，且相当一部分来自走线电阻)，可以在版图时降低走线电阻来减小这个毛刺，无需特别在意此现象。


但是 small buffer 的功耗却异常的高，这一点必须作出改善，下面就来适当调整 small buffer 功耗。

<div class='center'>

| small buffer | big buffer | MUX for big buffer | schematic | results  |
|:-:|:-:|:-:|:-:|:-:|
 | (ka, wg, lg) = (2.5, 0.84, 0.18) @ X1 + X3 | (ka, ng, wg, lg) = (2.5, 2, 3.6, 0.18) | 尺寸同 big buffer | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-19-19-47_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-19-21-37_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 
 | 改为 mu2 = 2 (之前是 3), 其它不变 | ditto | ditto | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-19-25-44_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-19-25-36_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 保持 mu2 = 2, 其它不变 | ditto | 尺寸减小为 (ka, wg, lg) = (2.5, 0.84, 0.18) @ mu = 2 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-19-23-16_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-19-26-05_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 设置为 (ka, wg, lg) = (2.5, 0.84, 0.18) @ X1 + X2 | (ka, ng, wg, lg) = (2.5, 2, 3.6, 0.18) 仍不变 | input MUX 尺寸同 small buffer 但是 mu = 2 <br> output MUX 尺寸同 small buffer | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-19-31-59_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | IDD = 32.69 nA <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-19-32-15_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | ditto | 改为 ng = 4 (之前是 2), 其它不变 | 尺寸同 big buffer | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-19-39-51_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | IDD = 32.60 nA, CK_OUT_BUF 的 SR 有所改善 (稍微增大的 jitter 完全在可接受范围内) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-19-39-39_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
</div>

修改后的 buffer chain 本身总功耗为 33 nA @ (CL, BUF_EN) = (0.1 fF, 0), 相比之前的 100 nA (虚高) 有明显改善。

### 2.3 PFD/CP module issue

一开始用 PFD/CP with trimming 进行仿真时遇到一个问题：
- 达到预期频率后, DN 信号逐渐静默, UP 信号正常出现，但是不能正常激活 Charge Pump, 导致 vcont 持续下降， vout_freq 持续上升，最终失锁。
- 但我们在 PFD/CP 模块单独测试时 (perc = -20, 0, +20)，并没有遇到这个问题
- 后来又重新验证了一遍 PFD/CP 模块在 0.625V/0.2V/1.02V 的增益曲线，也是正常的
- **不知为何，将 PFD/CP 的 UPB/DNB 信号也引出作为 output signal 后，模块的功能就正常了** (之前只引出了 IOUT/UP/DN 作为 output signal)


下面是功能正常时的 schematic of PLL loop:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-19-22-15-48_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div>



### 2.4 simulation 2

修改了 buffer 参数后，重新进行 pre-layout 仿真，其他设置不变，具体设置如下：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 模拟尺寸为 (KA, WN, L) = (2.0, 0.42, 10.0), 数字尺寸与 PFD 一致
- (3) CP/LPF/VCO/FD (3 points): 使用三种最佳方案:
    - Option 1:
        - RVCO1 + FDX24_X01 + (20 nA, 10 MOhm, 24 pF, 2 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0, 0, 1) 
    - Option 2:
        - RVCO2 + FDX24_X01_retiming + (20 nA, 10 MOhm, 33 pF, 2.75 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (1, 0, 0)
    - Option 3:
        - RVCO1 + FDX48_X01 + (20 nA, 10 MOhm, 24 pF, 2 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0, 0, 1)
- (4) VDD ripple (1 point): 三种纹波与白噪声叠加
    - (a) ±10 mV triangular ripple @ 0.2 kHz (rise = 5%, fall = 95%)
    - (b) ±5 mV triangular ripple @ 1.0 kHz (rise = 5%, fall = 95%)
    - (c) ±5 mV sine ripple @ 300 kHz
    - (d) 2 mVrms white noise (fnoise_max = 100 MHz)
- (5) BUF (1 point):
    - big buffer: (ka, ng, wg, lg) = **(2.5, 4, 7.2, 0.18)** (总宽度增加到了 WN = 4 x 7.2 = 28.8 um)
    - small buffer: (ka, wg, lg) = (2.5, 0.84, 0.18) @ **(m1, m2) = (1, 2)** (m2 从 3 减小到了 2) 
- (6) Output Setting (6 points): big buffer 端负载固定 20 pF, 输出频选与 small buffer 负载设置如下
    - (6.2) CK_OUT = CK_X24 @ CL = 0.1 fF with disabled BUF: CL = 0.1 fF, (SL1, SL0) = (1, 1), BUF_EN = 0
    - (6.1) CK_OUT = CK_X24 @ CL = 0.1 fF with enabled BUF:  CL = 0.1 fF, (SL1, SL0) = (1, 1), BUF_EN = 1
    - (6.5) CK_OUT = CK_X24 @ CL = 40 fF with disabled BUF:  CL = 40 fF,  (SL1, SL0) = (1, 1), BUF_EN = 0
    - (6.4) CK_OUT = CK_X24 @ CL = 40 fF with enabled BUF:   CL = 40 fF,  (SL1, SL0) = (1, 1), BUF_EN = 1
    - (6.3) CK_OUT = CK_X12 @ CL = 0.1 fF with disabled BUF: CL = 0.1 fF, (SL1, SL0) = (1, 0), BUF_EN = 0
    - (6.6) CK_OUT = CK_X12 @ CL = 40 fF with enabled  BUF:  CL = 40 fF,  (SL1, SL0) = (1, 0), BUF_EN = 1
- (7) Corner (1 point): 仅考虑 TT27
- (8) Else: transient time = 25 ms. (上述参数下 settling time < 5 ms)
- 上面一共是 3 x 6 = 18 个仿真点，每次仿真 **6 points**, 大约需要 3 x 4.5h = 14h

还是先用 Spectre FX + AX 仿真 tran = 5ms 测试一下：

<div class='center'>

| Spectre FX + AX 测试结果 |  |  |  |
|:-:|:-:|:-:|:-:|
 | 功耗情况 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-20-36-21_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |

</div>

然后用 Spectre X + CX 进行正式仿真，tran = 25ms:

<div class='center'>

| Spectre X + CX 前仿结果，耗时 Nov 16 20:32:02 ~ Nov 17 11:25:03 (约 15h) |  |  |
|:-:|:-:|:-:|
 | (这里忘记把数据 lock, 被覆盖了) |  |  |

</div>


随后进行全工艺角仿真，具体设置如下：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 模拟尺寸为 (KA, WN, L) = (2.0, 0.42, 10.0), 数字尺寸与 PFD 一致
- (3) CP/LPF/VCO/FD (3 points): 使用三种最佳方案:
    - Option 1:
        - RVCO1 + FDX24_X01 + (20 nA, 10 MOhm, 24 pF, 2 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0, 0, 1) 
    - Option 2:
        - RVCO2 + FDX24_X01_retiming + (20 nA, 10 MOhm, 33 pF, 2.75 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (1, 0, 0)
    - Option 3:
        - RVCO1 + FDX48_X01 + (20 nA, 10 MOhm, 24 pF, 2 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0, 0, 1)
- (4) VDD ripple (1 point): 三种纹波与白噪声叠加
    - (a) ±10 mV triangular ripple @ 0.2 kHz (rise = 5%, fall = 95%)
    - (b) ±5 mV triangular ripple @ 1.0 kHz (rise = 5%, fall = 95%)
    - (c) ±5 mV sine ripple @ 300 kHz
    - (d) 2 mVrms white noise (fnoise_max = 100 MHz)
- (5) BUF (1 point):
    - big buffer: (ka, ng, wg, lg) = **(2.5, 4, 7.2, 0.18)** (总宽度增加到了 WN = 4 x 7.2 = 28.8 um)
    - small buffer: (ka, wg, lg) = (2.5, 0.84, 0.18) @ **(m1, m2) = (1, 2)** (m2 从 3 减小到了 2) 
- (6) Output Setting (1 point): big buffer 端负载固定 20 pF, 输出频选与 small buffer 负载设置如下
    - (6.1) CK_OUT = CK_X24 @ CL = 0.1 fF with disabled BUF: CL = 0.1 fF, (SL1, SL0) = (1, 1), BUF_EN = 0
- (7) Corner (6 points): 共六个温度/工艺角如下
    - FF: 0°C, 65°C, 130°C
    - SS: -40°C, 0°C, 65°C
- (8) Else: transient time = 25 ms. (上述参数下 settling time < 5 ms)
- 上面一共是 3 x 6 = 18 个仿真点，每次仿真 **6 points**, 大约需要 3 x 4.5h = 14h




<div class='center'>

| Spectre X + CX 全温度/工艺角结果，耗时 Nov 17 18:54:21 ~ Nov 18 09:56:00 (约 15h) |  |  |
|:-:|:-:|:-:|
 | Option 1 总览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-18-12-55-21_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | Option 2 总览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-18-12-55-53_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | Option 3 总览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-18-12-56-49_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |

</div>

### 2.5 (FF, 130°C) lock issue

发现 (FF, 130°C) 时锁定异常，出现振荡，详细记录其波形以探究原因：

<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | (FF, 130°C) 时失锁，出现振荡 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-18-13-00-26_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |  |
 | 振荡平衡后的波形 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-18-12-47-14_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 振荡平衡后的波形 (局部放大) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-18-12-49-00_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 振荡起振过程 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-18-12-48-08_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 正常锁定波形 (用于对比) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-18-12-48-53_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |  |
</div>


为什么产生振荡？观察波形发现 Vcont 回落过慢，是因为 R1C1 乘积过大吗？可 (FF, 130°C) 时 R 和 C 都为最小值, R1C1 达到最小, Vcont 回落应该最快才对。



经验证：
- (1) 此振荡与输出负载无关：尝试过 CL = 0.1 fF or 40 fF and BUF_EN = 0 or 1, 振荡均不变
- (2) 此振荡有无与 LPF 电容参数无关：尝试过 LPF trimming (T2, T1, T0) 的所有组合，均存在振荡，且振荡幅度随电容增大而减小
- (3) 此振荡有无与 IP 无关：尝试过 CP trimming (T1, T0) 的所有组合，均存在振荡，且振荡幅度与电流大小 **无关**



<div class='center'>

| 验证过的一些情况 |  |  |
|:-:|:-:|:-:|
 | (1) "是否出现振荡" 与输出负载无关 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-18-13-09-01_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |  |
 | (2) "是否出现振荡" 与 LPF 电容参数无关 (图中某几个点虽然没有 evaluation error, 但 f_out 也是振荡的，从功耗可以看出这一点) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-18-13-12-30_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 经检查，所有情况下 f_out 均出现振荡， **且振荡幅度随电容增大而减小** <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-18-13-15-48_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |
 | (3) "是否出现振荡" 与 IP 无关 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-19-22-28-20_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 经检查，所有 IP 取值下均出现振荡，且振荡幅度与电流大小 **无关** <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-19-22-31-44_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |

</div>

经过进一步检查，确定此问题的 "异常之处" 在于节点 vcp (vc1). 具体而言，当 vcont 完成充电高于 vcp 后, vcont 下降的同时 vcp 应该升高，但是仿真结果显示 vcp 反而下降了，这就导致 "此次充电无效，甚至起到反作用"，从而引起振荡。

特别地，由于 vcont > vc1, R1 这边会向节点 vc1 注入电流，又因为 C1 接在 VDD/vc1 之间而 vc1 在下降，说明 C1 这边也向节点 vc1 注入电流，这些电流最终流向哪里了？显然，这个节点处只有 trimming circuit 没考虑了，所以这些电流一定是从 vc1 流向了 trimming circuit. 

将 LPF 的 trimming circuit 直接 disable 之后验证了一下，振荡确实消失了，说明 trimming circuit 确实是问题所在。具体情况如下：

<div class='center'>

| issue trimming circuit in LPF |  |  |
|:-:|:-:|:-:|
 | 将 trimming circuit 直接 disable 之后进行验证，振荡确实消失了，说明 trimming circuit of the LPF 确实是问题所在 | disable trimming 之后的 LPF 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-01-48-48_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  FX 仿真结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-01-50-42_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 上面还能发现 (FF, 130°C) 出现了功耗异常，原因是 big BUF 在 disable 情况下竟然消耗了 70 nA 电流。结合 trimming circuit of LPF 中仅有 MUX 可能出问题，这暗示我们 big buffer 和 LPF 中的 MUX 就是问题所在；而 CP 中的 MUX 则没有问题。 | 稍一检查，发现这两处的 MUX 确实都使用了相同尺寸，与 INVs of big BUF 相同，为 (ka, ng, wg, lg) = (2.5, 4, 7.2, 0.18)；而 CP 中的 MUX 尺寸与 PFD 相同，为 (ka, wg, lg) = (2.5, 0.84, 0.18) | 也就是说, LPF 与 big BUF 使用的这种 "超大尺寸" MUX 在 (FF, 130°C) 时出现异常，具体原因是什么？暂时还不太清楚。 |
 | 为了解决工艺角问题，我们将上面两处 "超大尺寸 MUX" 都改为 (ka, wg, lg) = (2.5, 0.84, 0.18) 也就是尺寸与 PFD 相同 | 修改后的 LPF 原理图如下 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-02-00-49_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 修改后的 BUF 原理图如下 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-02-03-57_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 修改之后重新进行全温度/工艺角仿真, FX 仿真结果如下  | 修改 MUX 尺寸之后，环路已经能够正常锁定，但 big BUF 在 (FF, 130°C) 下的功耗仍为七十多 nA 没有改变，说明这样大尺寸的 INV 也是没法正常工作的，需要修改 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-02-21-11_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |

</div>


为了得到能正常被 disable 的 big BUF, 我们采用 6-stage (X1 INV to X32 INV) 结构重新确定尺寸，详见下一小节。

### 2.6 big BUF modification

<div class='center'>

| big BUF modification |  |  |
|:-:|:-:|:-:|
 | 修改后的 big BUF 结构 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-02-36-10_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | (TT, 27°C 扫描情况) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-02-39-55_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | (FF, 130°C 扫描情况) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-03-24-49_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 经过检查，我们发现 CK_OUT_BUF 输出路径上的 MUX 会严重拉低输出性能，包括但不限于压摆率等，因此直接将其移除，输出端不作任何处理 | 我们希望 (FF, 130°C) 下没有异常漏电，但是发现即便 (ka, wg, lg) = (2.5, 1.8, 0.18) 这样较小的尺寸也会有 20 nA 的漏电 (两个 big BUF) | 无奈用完整 BUF module 在 (FF, 130°C) 重新扫描，结果如下 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-13-33-59_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 左图这些参数在 disabled 情况下的电流为 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-13-37-05_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 根据上面两张图中 big BUF 功耗和性能，可以总结出两点 | (1) 宽长比相同，增大 length 时，压摆率和抖动都有所恶化，但 disabled 时的漏电流大幅减小 | (2) length 不变，增大宽长比时，压摆率和抖动都有所改善，但 disabled 时的漏电流增大 |
 | 我们再试试看保持 total muWidth 不变，增大 ng (finger) 能否降低漏电流 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-14-10-09_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 左图看出，非但不能降低漏电，反而有所增大 |  |
 | 综合上面几点，我们将 big BUF 的尺寸调整为 **(ka, ng, wg, lg) = (2.5, 1, 3.6, 0.36)**, 此时 BUF 全工艺角性能见右图 | disable 状态下的输出 (仅有 small BUF 工作) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-14-36-55_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | enable 状态下的输出 (big/small BUF 同时工作) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-14-37-38_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |

</div>

**除修改 big BUF 尺寸外，我们将此后的全温度定义修改为 -40°C ~ 100°C (原来是 -40°C ~ 130°C), 具体而言，我们选择 {-40°C, 0°C, 65°C, 100°C} 进行仿真**

### 2.7 simulation 3

再次检查是否有极大尺寸的 MUX/INV 等器件，确认没有之后先用 FX + AX 测试一下 (tran = 5ms)，具体设置如下：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 模拟尺寸为 (KA, WN, L) = (2.0, 0.42, 10.0), 数字尺寸与 PFD 一致
- (3) CP/LPF/VCO/FD (3 points): 使用三种最佳方案:
    - Option 1:
        - RVCO1 + FDX24_X01 + (20 nA, 10 MOhm, 24 pF, 2 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0, 0, 1) 
    - Option 2:
        - RVCO2 + FDX24_X01_retiming + (20 nA, 10 MOhm, 33 pF, 2.75 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (1, 0, 0)
    - Option 3:
        - RVCO1 + FDX48_X01 + (20 nA, 10 MOhm, 24 pF, 2 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0, 0, 1)
- (4) VDD ripple (1 point): 一种纹波与白噪声叠加, (rout_VDD, cout_VDD) = (50 Ohm, 10 pF)
    - (a) ±10 mV triangular ripple @ 0.2 kHz (rise = 5%, fall = 95%)
    - (d) 2 mVrms white noise (fnoise_max = 100 MHz)
- (5) BUF (1 point):
    - big buffer: (ka, ng, wg, lg) = **(2.5, 1, 3.6, 0.36)**
    - small buffer: (ka, wg, lg) = (2.5, 0.84, 0.18) @ **(m1, m2) = (1, 2)**
- (6) Output Setting (2 points): big buffer 端负载固定 20 pF, 输出频选与 small buffer 负载设置如下
    - (6.1) CK_OUT = CK_X24 @ CL = 0.1 fF with disabled BUF: (SL1, SL0) = (1, 1), CL = 0.1 fF, BUF_EN = 0
    - (6.2) CK_OUT = CK_X24 @ CL = 40 fF with enabled BUF:   (SL1, SL0) = (1, 1), CL = 40 fF,  BUF_EN = 1
- (7) Corner (6 points): 共六个温度/工艺角如下
    - FF: 0°C, 65°C, 100°C (注意不是 130°C)
    - SS: -40°C, 0°C, 65°C
- (8) Else: transient time = 25 ms. (上述参数下 settling time < 3 ms, FX + AX 时设置 tran = 5 ms)
- 上面一共是 3 x 6 x 2 = 36 个仿真点，每次仿真 **6 points**, Spectre X + CX 的话大约需要 6 x 4.5h = 27h


(FX + AX 测试成功，但当时忘记截图了)

## 3. Layout of PFD and FD

### 3.1 preparations

我们先把一些不会再改动的模块的版图做好，确保后续的迭代可以在此基础上进行。它们是：
- (1) PFD
    - (ka, wg, lg) = (2.5, 0.84, 0.18)
    - 基本模块: DFF_forPFD
    - 基本逻辑门: NOR, NAND, INV @ (2.5, 0.84, 0.18)
- (2) CP
    - digital (ka, wg, lg) = (2.5, 0.84, 0.18)
    - 基本模块: MUX2
    - 基本逻辑门: INV, TG @ (2.5, 0.84, 0.18)
    - analog (ka, wg, lg) = (2.0, 0.42, 10.0) for each multiplier
- (3) LPF
    - (ka, wg, lg) = (2.5, 0.84, 0.18)
    - 基本模块: MUX2
    - 基本逻辑门: INV, TG @ (2.5, 0.84, 0.18)
- (4) FD
    - (ka, wg, lg) = (1.0, 0.42, 10.0)
    - 二级模块: FD2, FD3
    - 基本模块: DLatch, DFF, DFF_n
    - 基本逻辑门: NOR, NAND, INV @ (1.0, 0.42, 10.0)

也就是说，目前我们一共需要两套逻辑门：
- (1) (ka, wg, lg) = (2.5, 0.84, 0.18)
    - 基本逻辑门: NOR, NAND, INV, TG
    - 基本模块: MUX2, DFF_forPFD
    - 二级模块: 无
    - 最终模块: PFD, CP, LPF
- (2) (ka, wg, lg) = (1.0, 0.42, 10.0)
    - 基本逻辑门: NOR, NAND, INV
    - 基本模块: DLatch, DFF, DFF_n
    - 二级模块: FD2, FD3
    - 最终模块: FD

### 3.2 layout details

<div class='center'>

| 基本模块版图设计记录 |  |  |
|:-:|:-:|:-:|
 | `DFF_forPFD` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-21-19-06_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `DFF_forPFD` 版图效果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-17-44-58_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `DFF_forPFD` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-17-46-39_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |
 | `PFD_ANDrst` 原理图 (为保证对称性，将 INV 与 NAND 改为了 multiplier = 2) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-21-17-47_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `PFD_ANDrst` 版图效果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-21-15-23_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `PFD_ANDrst` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-21-16-25_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 完成 PFD 版图之后，先导出 calibre 验证一下，确保没有什么异常错误 | FX + AX 仿真结果如下 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-22-02-06_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 确实没有错误，可以继续进行其它模块的版图 |
 | 为了早日得到后仿功耗估计，我们先把 FD 的版图做完，再来做剩下的模块 | 
 | `DLatch` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-23-44-37_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `DLatch` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-23-45-09_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `DLatch` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-20-23-45-46_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | `DFF` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-00-20-33_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `DFF` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-00-27-31_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `DFF` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-00-27-59_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | `DFF_n` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-00-20-20_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `DFF_n` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-00-31-43_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `DFF_n` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-00-31-27_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | `FD2` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-00-36-44_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `FD2` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-00-36-27_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `FD2` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-00-36-08_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | `FD3` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-02-25-26_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `FD3` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-02-28-48_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `FD3` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-02-24-55_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | `FD24_chain` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-19-57-35_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `FD24_chain` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-19-50-48_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `FD24_chain` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-19-57-11_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | `FD24_chain_retiming` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-20-30-03_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `FD24_chain_retiming` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-20-29-32_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `FD24_chain_retiming` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-20-29-10_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | `FD48_chain` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-21-26-06_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `FD48_chain` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-21-24-14_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `FD48_chain` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-21-23-39_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
</div>





### 3.3 post VCO/PFD/FD

这一小节代入 VCO/PFD/FD 的 calibre 后仿网表进行仿真，具体设置如下：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 模拟尺寸为 (KA, WN, L) = (2.0, 0.42, 10.0), 数字尺寸与 PFD 一致
- (3) CP/LPF/VCO/FD (3 points): 使用三种最佳方案:
    - Option 1:
        - RVCO1 + FDX24_X01 + (20 nA, 10 MOhm, 24 pF, 2 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0, 0, 1) 
    - Option 2:
        - RVCO2 + FDX24_X01_retiming + (20 nA, 10 MOhm, 33 pF, 2.75 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (1, 0, 0)
    - Option 3:
        - RVCO1 + FDX48_X01 + (20 nA, 10 MOhm, 24 pF, 2 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0, 0, 1)
- (4) VDD ripple (1 point): 一种纹波与白噪声叠加, **(rout_VDD, cout_VDD) = (20 Ohm, 50 pF)** 
    - (a) ±10 mV triangular ripple @ 0.2 kHz (rise = 5%, fall = 95%)
    - (d) 2 mVrms white noise (fnoise_max = 100 MHz)
- (5) BUF (1 point):
    - big buffer: (ka, ng, wg, lg) = (2.5, 1, 3.6, 0.36)
    - small buffer: (ka, wg, lg) = (2.5, 0.84, 0.18) @ (1, 2)
- (6) Output Setting (2 points): big buffer 端负载固定 20 pF, 输出频选与 small buffer 负载设置如下
    - (6.1) CK_OUT = CK_X24 @ CL = 0.1 fF with disabled BUF: (SL1, SL0) = (1, 1), CL = 0.1 fF, BUF_EN = 0
    - (6.2) CK_OUT = CK_X24 @ CL = 40 fF with enabled BUF:   (SL1, SL0) = (1, 1), CL = 40 fF,  BUF_EN = 1
- (7) Corner (1 point): (TT, 27°C)
- (8) Pre or post (2 points): pre-layout / post-layout netlist (前仿后仿各跑一次，方便对比)
- (9) Transient time: (上述参数下 settling time < 3 ms)
    - 5 ms @ Spectre FX + AX
    - **15 ms** @ Spectre X + CX
- 注意这里将 VDD 参数改为了 (rout_VDD, cout_VDD) = (20 Ohm, 50 pF)，同时将 Spectre X + CX 的仿真时间改为了 15 ms
- 上面一共是 3 x 2 x 2 = 12 个仿真点，每次仿真 **6 points**, Spectre X + CX 的话大约需要 2.5h + 5h = 7.5h @ tran = 15ms (预估前仿 2.5h, 后仿 5h)

<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | Spectre FX + AX 测试结果 (tran = 5 ms) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-21-22-31-47_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | Spectre FX + CX 仿真结果 (tran = 15 ms), 2 x 6-points 仿真共耗时 Fri Nov 21 22:14:41 2025 ~ Sat Nov 22 08:05:05 2025 (9h 50m) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-23-15-28-24_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |

</div>


完成前后仿对比之后，进行前两种方案的后仿全温度/工艺角验证，具体设置为：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 模拟尺寸为 (KA, WN, L) = (2.0, 0.42, 10.0), 数字尺寸与 PFD 一致
- (3) CP/LPF/VCO/FD (2 points): 使用 VCO 工作在 CK_X24 的前两种方案
    - Option 1:
        - RVCO1 + FDX24_X01 + (20 nA, 10 MOhm, 24 pF, 2 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0, 0, 1) 
    - Option 2:
        - RVCO2 + FDX24_X01_retiming + (20 nA, 10 MOhm, 33 pF, 2.75 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (1, 0, 0)
- (4) VDD ripple (1 point): 一种纹波与白噪声叠加, (rout_VDD, cout_VDD) = (20 Ohm, 50 pF)
    - (a) ±10 mV triangular ripple @ 0.2 kHz (rise = 5%, fall = 95%)
    - (d) 2 mVrms white noise (fnoise_max = 100 MHz)
- (5) BUF (1 point):
    - big buffer: (ka, ng, wg, lg) = (2.5, 1, 3.6, 0.36)
    - small buffer: (ka, wg, lg) = (2.5, 0.84, 0.18) @ (1, 2)
- (6) Output Setting (2 points): big buffer 端负载固定 20 pF, 输出频选与 small buffer 负载设置如下
    - (6.1) CK_OUT = CK_X24 @ CL = 0.1 fF with disabled BUF: (SL1, SL0) = (1, 1), CL = 0.1 fF, BUF_EN = 0
    - (6.2) CK_OUT = CK_X24 @ CL = 40 fF with enabled BUF:   (SL1, SL0) = (1, 1), CL = 40 fF,  BUF_EN = 1
- (7) Corner (9 point): 共九个温度/工艺角
    - TT: -20°C, 27°C, 80°C
    - FF: -20°C, 27°C, 80°C
    - SS: -20°C, 27°C, 80°C
- (8) Pre or post (1 point): post-layout netlist
- (9) Transient time: (上述参数下 settling time < 3 ms)
    - 5 ms @ Spectre FX + AX
    - 15 ms @ Spectre X + CX
- 上面一共是 2 x 9 = 18 个仿真点，每次仿真 **6 points**, Spectre X + CX 的话大约需要 3 x 5h = 15h @ tran = 15ms


<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | Spectre FX + CX 测试结果 (tran = 15 ms), 3 x 6-points 仿真共耗时 Sat Nov 22 01:00:03 2025 ~ Sat Nov 22 14:53:51 2025 (13h 53m)  |  |  |
 | Option 1 全温度/工艺角仿真结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-23-15-34-35_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-23-15-36-17_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 左图中 (FF, 27°C) 看似不能正常工作，但其实仍是正常工作的，只是 settling_begin 受波形影响计算值过低而已 |  |
 | Option 2 全温度/工艺角仿真结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-23-15-40-46_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-23-15-41-57_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |  |
</div>

**<span style='color:red'> 经与导师沟通，我们选择 Option 2 作为最终方案。 </span>** 此方案当前仿真设置如下：
- Simulation Mode: Spectre X + CX @ tran = 15 ms
- Test Condition:
    - VDD = 1.25 V with ±10 mV triangular ripple @ 0.2 kHz (5% rise, 95% fall) + 2 mVrms white noise (f_cut = fnoise_max = 100 MHz)
    - Output Setting: 
        - Big BUF disabled: BUF_EN = 0
        - CK_OUT = CK_X24 @ CL = 0.1 fF (no load)
    - Loop Options: RVCO2 + FDX24_X01_retiming + (20 nA, 10 MOhm, 33 pF, 2.75 pF)
    - Trimming Setting:
        - CP: (CP_T1, CP_T0) = (0, 1)
        - LPF: (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (1, 0, 0)
    - Transient Time: 15 ms
    - Corners:  TT/FF/SS @ {-20°C, 27°C, 80°C} (9 points)

仿真结果为：
- Settling Time: 1.774 ms (0.628 ms ~ 2.294 ms)
- Tunning Voltage: Vcont = 438.7 mV (302.5 mV ~ 575.8 mV)
- Power Consumption with disabled big BUF @ no load: 
    - IDD = 401.0 nA (396.6 nA ~ 411.1 nA)
    - IDD_PFD = 9.683 nA (9.529 nA ~ 9.851 nA) @ calibre
    - IDD_CP = 30.24 nA (29.96 nA ~ 30.33 nA) @ schematic
    - IDD_VCO = 193.1 nA (190.7 nA ~ 202.8 nA) @ calibre
    - IDD_FD = 132.6 nA (129.6 nA ~ 140.2 nA) @ calibre
    - IDD_small_BUF = 28.67 nA (28.19 nA ~ 29.46 nA) @ schematic
    - IDD_big_BUF = 107.9 pA (-101.1 pA ~ 227.0 pA)
- Output Performance @ CK_OUT = CK_X24:
    - CK_X24: 
        - duty = 51.39% (51.14% ~ 51.56%)
        - riseTime = 1.269% (0.880% ~ 1.760%)
        - fallTime = 0.674% (0.430% ~ 0.813%)
        - Jc_rms = 2.810 mUI (2.689 mUI ~ 3.084 mUI), namely 3.573 ns (3.419 ns ~ 3.922 ns)
        - Je_rms = 21.22 mUI (19.89 mUI ~ 26.06 mUI), namely 26.983 ns (25.291 ns ~ 33.137 ns)
    - CK_X03:
        - duty = 50.00% (50.00% ~ 50.01%)
        - riseTime = 0.027% (0.016% ~ 0.065%)
        - fallTime = 0.022% (0.013% ~ 0.039%)
        - Jc_rms = 1.800 mUI (1.679 mUI ~ 2.215 mUI), namely 18.311 ns (17.080 ns ~ 22.532 ns)
        - Je_rms = 2.537 mUI (2.490 mUI ~ 3.296 mUI), namely 25.808 ns (25.330 ns ~ 33.529 ns)
    - CK_OUT (= X24 with BUF disabled @ CL = 0.1 fF):
        - duty = 51.03% (50.50% ~ 51.27%)
        - riseTime = 0.020% (0.013% ~ 0.032%)
        - fallTime = 0.003% (0.003% ~ 0.003%)
        - Jc_rms = 2.814 mUI (2.705 mUI ~ 3.086 mUI), namely 3.578 ns (3.440 ns ~ 3.924 ns)
        - Je_rms = 21.21 mUI (19.88 mUI ~ 26.06 mUI), namely 26.970 ns (25.279 ns ~ 33.137 ns)
    - CK_ADC(= X03 with BUF disabled @ CL = 0.1 fF):
        - duty = 50.00% (49.99% ~ 50.01%)
        - riseTime = 0.002% (0.001% ~ 0.004%)
        - fallTime = 0.001% (0.001% ~ 0.002%)
        - Jc_rms = 1.800 mUI (1.679 mUI ~ 2.215 mUI), namely 18.311 ns (17.080 ns ~ 22.532 ns)
        - Je_rms = 2.537 mUI (2.490 mUI ~ 3.296 mUI), namely 25.808 ns (25.330 ns ~ 33.529 ns)

为确保结果准确性，我们还用 Spectre 和 APS 分别验证了 TT27 **但是 CL = 40 fF** 时的仿真结果，如下：

<div class='center'>

| Spectre @ CL = 40 fF, 耗时 118 ks (1d 8h 51m) @ 1-point | APS (4-thread) @ CL = 40 fF, 耗时 116 ks (1d 8h 17m) @ 1-point |  |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-25-01-09-46_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-25-01-09-01_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 一方面, Spectre 和 APS 的仿真结果完全一致 (主要性能没有任何区别)；另一方面，不同仿真模式的结果也没有明显差异，甚至 Spectre/APS 带了 40fF 负载之后的抖动性能还更好 |

</div>


## 5. Layout of CP, LPF and BUF

### 5.1 CP layout details

这一小节对 CP进行版图设计，具体记录如下：

<div class='center'>

| 基本模块版图设计记录 |  |  |
|:-:|:-:|:-:|
 | `MUX2_analog` 原理图和版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-23-00-30-05_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | x | `MUX2_analog` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-23-00-30-57_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 做 CP 版图时发现 5T-OTA pcell 的 bulk of pmos input pair 接的是 source 而不是 VDD, 于是做修正，将 bulk 改接为 VDD | `CP_2bitTrimming` 版图布局 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-23-00-50-05_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 2025.11.23 继续推进 `CP_2bitTrimming` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-23-02-29-54_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 2025.11.26 继续推进 `CP_2bitTrimming` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-26-00-49-02_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 推进 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-26-01-18-57_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  | 
 | `CP_2bitTrimming` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-26-02-26-35_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `CP_2bitTrimming` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-26-02-26-18_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `CP_2bitTrimming` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-26-02-25-07_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |

</div>


<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | Spectre FX + AX 简单对比 CP 前后仿结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-26-02-45-57_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |  |
 |  |  |  |
</div>

- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (2 point): 分别使用 schematic 和 calibre 网表进行仿真
- (3) CP/LPF/VCO/FD (1 points): 使用 VCO 工作在 CK_X24 的第二种方案
    - Option 2:
        - RVCO2 + FDX24_X01_retiming + (20 nA, 10 MOhm, 33 pF, 2.75 pF)
        - trimming 设置为 (CP_T1, CP_T0) = (0, 1), (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (1, 0, 0)
- (4) VDD ripple (1 point): 一种纹波与白噪声叠加, (rout_VDD, cout_VDD) = (20 Ohm, 50 pF)
    - (a) ±10 mV triangular ripple @ 0.2 kHz (rise = 5%, fall = 95%)
    - (d) 2 mVrms white noise (fnoise_max = 100 MHz)
- (5) BUF (1 point):
    - big buffer: (ka, ng, wg, lg) = (2.5, 1, 3.6, 0.36)
    - small buffer: (ka, wg, lg) = (2.5, 0.84, 0.18) @ (1, 2)
- (6) Output Setting (1 points): big buffer 端负载固定 20 pF, 输出频选与 small buffer 负载设置如下
    - CK_OUT = CK_X24 @ CL = 40 fF with disabled BUF:   (SL1, SL0) = (1, 1), CL = 40 fF,  BUF_EN = 0
- (7) Corner (9 point): 共九个温度/工艺角
    - TT: -20°C, 27°C, 80°C
    - FF: -20°C, 27°C, 80°C
    - SS: -20°C, 27°C, 80°C
- (8) Pre or post (1 point): post-layout netlist
- (9) Transient time: (上述参数下 settling time < 3 ms)
    - 5 ms @ Spectre FX + AX
    - 15 ms @ Spectre X + CX
- 上面一共是 2 x 9 = 18 个仿真点，每次仿真 **6 points**, Spectre X + CX 的话大约需要 3 x 5h = 15h @ tran = 15ms


<div class='center'>

| Spectre X + CX 仿真结果总览 |  |  |
|:-:|:-:|:-:|
 | 使用 CP 前仿原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-26-19-42-55_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 使用 CP 后仿网表 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-26-19-43-13_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |
</div>

### 5.2 BUF layout details

<div class='center'>

| 版图设计记录 |  |  |
|:-:|:-:|:-:|
 | `big_BUF` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-27-00-57-20_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `big_BUF` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-27-00-57-32_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `big_BUF` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-27-00-58-02_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 完整 `BUF` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-06-01-32-14_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 完整 `BUF` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-06-01-31-21_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 完整 `BUF` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-06-01-31-01_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |

</div>

对 BUF 版图进行验证 (LPF 先用 schematic)，仿真设置如下：
- (1) PFD/CP (1 point): calibre of `202510_PFDCP_2bitTrimming` @ IP = 20 nA
    - trimming: **(CP_T1, CP_T0) = (0, 1)**
- (2) LPF (1 point): schematic of `202510_LPF_3bitC1Trimming` @  (R1, C1, C2) = (10 MOhm, 33 pF, 2.75 pF)
    - trimming: **(LPF_T2, LPF_T1, LPF_T0) = (1, 0, 0)**
- (3) VCO (1 point): calibre of `202510_PLL_RVCO2_lowJitter_layout_v2`
- (4) VDD ripple (1 point): 一种纹波与白噪声叠加, (rout_VDD, cout_VDD) = (20 Ohm, 50 pF)
    - (a) ±10 mV triangular ripple @ 0.2 kHz (rise = 5%, fall = 95%)
    - (d) 2 mVrms white noise (fnoise_max = 100 MHz)
- (5) BUF (2 points): schematic/calibre of `202510_PLL_BUF_output` @ CL = 40 fF
- (6) Output Setting (3 points): 
    - 固定 CK_OUT = CK_X24, 也即 (SL1, SL0) = (1, 1)
    - 固定 big buffer 端负载固定 20 pF, small buffer 端负载 CL 设置如下
    - (6.1) (EN_BUF, CL) = (0, 0.1 fF)
    - (6.2) (EN_BUF, CL) = (0, 40 fF)
    - (6.3) (EN_BUF, CL) = (1, 40 fF)
- (7) Corner (1 points): (TT, 27°C)
- (8) Simulation Mode (1 point): Spectre FX + AX @ tran = 30 ms
- 上面一共是 2 x 3 = 6 个仿真点，每次仿真 **6 points**, Spectre X + CX 的话大约需要 1 x 7h = 7h @ tran = 15ms



<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | Spectre FX + AX 简单验证 (small BUF load = 40 fF @ disabled big BUF) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-06-02-30-57_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | Spectre FX + AX 简单验证 (small BUF load = 40 fF @ enabled big BUF @ 20 pF load) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-06-02-35-21_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |
 | Spectre X + CX 仿真结果 (EN_BUF = 0, CL = 0.1 fF), 耗时 20.4 ks (5h 39m 51s) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-07-00-00-54_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | Spectre X + CX 仿真结果 (EN_BUF = 0, CL = 40 fF), 耗时 27.1 ks (7h 32m 25s) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-07-00-02-03_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | Spectre X + CX 仿真结果 (EN_BUF = 1, CL = 40 fF), 耗时 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-07-00-05-17_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
</div>

### 5.3 LPF layout details



 <div class='center'>

| 版图设计记录 |  |  |
|:-:|:-:|:-:|
 | `LPF` 版图基本布局 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-06-10-16-46_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |  |
 | 完整 `LPF` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-07-02-47-32_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 完整 `LPF` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-07-02-48-00_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 完整 `LPF` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-07-02-47-18_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | **注：做版图时发现自行创建的 cmimhc pcell 始终过不了 LVS, 无奈在原理图中换为原始器件** |  |  |

</div>

对 LPF 版图进行验证 **(所有器件都是用后仿网表)**，仿真设置如下：
- (1) PFD/CP (1-point): calibre of `202510_PFDCP_2bitTrimming` @ IP = 20 nA
    - trimming: **(CP_T1, CP_T0) = (0, 1)**
- (2) LPF (2-point): schematic/calibre of `202510_LPF_3bitC1Trimming` @  (R1, C1, C2) = (10 MOhm, 33 pF, 2.75 pF)
    - trimming: **(LPF_T2, LPF_T1, LPF_T0) = (1, 0, 0)**
- (3) VCO (1-point): calibre of `202510_PLL_RVCO2_lowJitter_layout_v2`
- (4) VDD ripple (1-point): 一种纹波与白噪声叠加, (rout_VDD, cout_VDD) = (20 Ohm, 50 pF)
    - (a) ±10 mV triangular ripple @ 0.2 kHz (rise = 5%, fall = 95%)
    - (d) 2 mVrms white noise (fnoise_max = 100 MHz)
- (5) BUF (1-point): calibre of `202510_PLL_BUF_output` @ CL = 40 fF
- (6) Output Setting (3-point): 
    - 固定 CK_OUT = CK_X24, 也即 (SL1, SL0) = (1, 1)
    - 固定 big buffer 端负载固定 20 pF, small buffer 端负载 CL 设置如下
    - (6.1) (EN_BUF, CL) = (0, 0.1 fF)
    - (6.2) (EN_BUF, CL) = (0, 40 fF)
    - (6.3) (EN_BUF, CL) = (1, 40 fF)
- (7) Corner (1-points): (TT, 27°C)
- (8) Simulation Mode (1-point): Spectre FX + AX @ tran = 30 ms
- 上面一共是 2 x 3 = 6 个仿真点，每次仿真 **6 points**, Spectre X + CX 的话大约需要 1 x 7h = 7h @ tran = 15ms

<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | Spectre X + CX 仿真结果 (EN_BUF = 0, CL = 0.1 fF), 耗时 25.5 ks (7h 4m 14s) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-07-22-06-32_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | Spectre X + CX 仿真结果 (EN_BUF = 0, CL = 40 fF), 耗时 24.8 ks (6h 54m 7s) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-07-22-07-57_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | Spectre X + CX 仿真结果 (EN_BUF = 1, CL = 40 fF), 耗时 28.1 ks (7h 48m 30s) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-07-22-09-42_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 全模块后仿结果概览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-07-22-02-57_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |  |
</div>


## 6. Post-Simulation Results (v1)

### 6.0 layout details (v1)

 <div class='center'>

| 版图设计记录 |  |  |
|:-:|:-:|:-:|
 | 先连接好 VDD/VSS 之外的所有网络和 I/O Pins <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-00-26-36_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 然后连接好 VDD/VSS <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-01-48-27_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 并通过 DRC/LVS 检查 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-01-46-46_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 对当前版图进行备份，然后提取一次寄生参数，考察几条关键信号线的寄生电容 (尤其是频率为 X24 的几条线)，根据寄生参数结果对走线进行优化，节省功耗的同时降低串扰 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-02-02-32_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 对走线 `VDD` 的寄生电容进行检查 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-02-03-53_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 对走线 `VSS` 的寄生电容进行检查 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-02-04-31_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 完整 `PLL` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-01-47-26_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 完整 `PLL` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-01-48-27_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | 完整 `PLL` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-01-46-46_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div>  |
 
</div>

**<span style='color:red'> 注意关注生成 calibre 时是否满足 "0 warning, 0 error"，若不满足可能导致仿真结果不准。 </span>** 我们的倒确实满足 "0 warning, 0 error"。


### 6.1 all_trimming of v1

这一小节给出 TT27 下 所有 trimming setting 的性能
- 测试条件：
    - (SL1, SL0) = (1, 1), namely CK_OUT = X24
    - EN_BUF = 0, CL = (40 fF, 20 pF)
- 横坐标：trimming settings (5-bit trimming, 共 32-point)
- 纵坐标：IDD/CK_ADC_Je_rms/CK_ADC_Jc_rms (三种都 normalized，用堆叠柱状图)

具体仿真设置如下：
- (1) PLL (1-point): calibre of `202510_PLL_v1`
- (2) VDD ripple (1-point): 一种纹波与白噪声叠加, (rout_VDD, cout_VDD) = (20 Ohm, 50 pF)
    - (a) ±10 mV triangular ripple @ 0.2 kHz (rise = 5%, fall = 95%)
    - (b) 2 mVrms white noise (fnoise_max = 100 MHz)
    - (c) C_VDD = 50 pF @ rout_VDD = 20 Ohm
- (3) Output Setting (1-point): 
    - 固定 EN_BUF = 0 和 (SL1, SL0) = (1, 1)
    - 固定 40 fF @ small BUF output, 20 pF @ big BUF output
- (4) Trimming Setting (32-point): 
    - CP Trimming: (CP_T1, CP_T0) = (0,0), (0,1), (1,0), (1,1)
    - LPF Trimming: (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0,0,0), (0,0,1), (0,1,0), (0,1,1), (1,0,0), (1,0,1), (1,1,0), (1,1,1)
- (5) Corner (1-points): (TT, 27°C)
- (6) Simulation Mode (1-point): Spectre FX + AX @ tran = 15 ms, or Spectre X + CX @ tran = 15 ms
- 上面一共是 32 个仿真点，每次仿真 **6 points** :   
    - Spectre FX + AX 的话大约需要 6 x 1.5h = 9h @ tran = 15ms
    - Spectre  X + CX 的话大约需要 6 x 8h = 48h @ tran = 15ms

仿真结果如下：

<div class='center'>

| Spectre FX + AX 仿真结果与可视化 |  |  |
|:-:|:-:|:-:|
 | all_trimming of v1 @ Spectr FX + AX (0 to 14) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-17-28-08_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | all_trimming of v1 @ Spectr FX + AX (15 to 31) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-17-29-42_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | MATLAB 可视化结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-17-41-29_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-17-41-22_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
</div>

## 7. Post-Simulation Results (v2)

### 7.0 layout details (v2)

由于不清楚需求方那边提供的 REF 是正弦还是方波，我们在 `v1` 的基础上，给 PFD 输入端加一个 BUF, 形成 `v2` 版本。

 <div class='center'>

| 版图设计记录 |  |  |
|:-:|:-:|:-:|
 | `PFD_ANDrst_inputBufferd` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-23-20-03_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `PFD_ANDrst_inputBufferd` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-23-01-51_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `PFD_ANDrst_inputBufferd` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-23-01-22_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | `PLL_v2` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-10-00-44-34_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `PLL_v2` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-10-00-44-18_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | `PLL_v2` DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-10-00-24-14_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 
</div>

### 7.0 Tran/Gate Level Comparison (v2)

本来打算分别导出 `v2` 版本的 transistor level netlist 和 gate level netlist 进行对比，查看后发现 onc18 没用提供 gate level 所需的 x-cell 文件，于是作罢。

仿真设置如下：
- (1) PLL (2-point): calibre_tran/calibre_gate of `202510_PLL_v2`
- (2) VDD ripple (1-point): 两种纹波与白噪声叠加
    - (rout_VDD, cout_VDD) = (20 Ohm, 50 pF)
    - (a) 10 mVamp triangular ripple @ 0.2 kHz (rise = 5%, fall = 95%)
    - (c) 5 mVamp sine ripple @ 300 kHz
    - (c) 2 mVrms white noise (fnoise_max = 100 MHz)
- (3) Output Setting (1-point): 
    - 固定 EN_BUF = 0 和 (SL1, SL0) = (1, 1)
    - 固定 40 fF @ small BUF output, 20 pF @ big BUF output
- (4) Trimming Setting (1-point): Trimming_Num = 14 (0 ~ 31)
- (5) Corner (1-points): (TT, 27°C)
- (6) Simulation Mode (1-point): Spectre FX + AX @ tran = 15 ms, or Spectre X + CX @ tran = 15 ms
- 上面一共是 2 个仿真点，每次仿真 **6 points** :   
    - Spectre FX + AX 的话大约需要 1 x  2h =  2h @ tran = 15ms
    - Spectre  X + CX 的话大约需要 1 x 10h = 10h @ tran = 15ms

### 7.1 all_trimming of v2

这一小节给出 TT27 下 所有 trimming setting 的性能
- 测试条件：
    - (SL1, SL0) = (1, 1), namely CK_OUT = X24
    - EN_BUF = 0, CL = (40 fF, 20 pF)
- 横坐标：trimming settings (5-bit trimming, 共 32-point)
- 纵坐标：IDD/CK_ADC_Je_rms/CK_ADC_Jc_rms (三种都 normalized，用堆叠柱状图)
具体仿真设置如下：
- (1) PLL (1-point): calibre of `202510_PLL_v1`
- (2) VDD ripple (1-point): 一种纹波与白噪声叠加, (rout_VDD, cout_VDD) = (20 Ohm, 50 pF)
    - (a) ±10 mV triangular ripple @ 0.2 kHz (rise = 5%, fall = 95%)
    - (b) 2 mVrms white noise (fnoise_max = 100 MHz)
    - (c) C_VDD = 50 pF @ rout_VDD = 20 Ohm
- (3) Output Setting (1-point): 
    - 固定 EN_BUF = 0 和 (SL1, SL0) = (1, 1)
    - 固定 40 fF @ small BUF output, 20 pF @ big BUF output
- (4) Trimming Setting (32-point): 
    - CP Trimming: (CP_T1, CP_T0) = (0,0), (0,1), (1,0), (1,1)
    - LPF Trimming: (LPF_C1_T2, LPF_C1_T1, LPF_C1_T0) = (0,0,0), (0,0,1), (0,1,0), (0,1,1), (1,0,0), (1,0,1), (1,1,0), (1,1,1)
- (5) Corner (1-points): (TT, 27°C)
- (6) Simulation Mode (1-point): **Spectre X + CX @ thread = 8, max jobs = 4**
- 上面一共是 32 个仿真点, Spectre  X + CX 的话大约需要 8 x 8h = 64h (2.67d) @ tran = 15ms


| Spectre X + CX 仿真结果与可视化 |  |  |
|:-:|:-:|:-:|
 | 仿真设置  | all_trimming of v2 @ Spectre X + CX (0 to 14)  | all_trimming of v2 @ Spectre X + CX (15 to 31)  |
 | MATLAB 可视化结果 (all_trimming) | MATLAB 可视化结果 (all_corner) | MATLAB 可视化结果 (all_load) |
</div>


``` bash
仿真数据保存在了下面路径，可用 results browser 打开查看：
/home/dy2025/Desktop/Work/simulation/MyLib_202510_PLL_onc18/TB_PLL/maestro/results/maestro/.tmpADEDir_dy2025/TB_PLL_SpectreFXAX/simulation/MyLib_202510_PLL_onc18/TB_PLL/maestro/results/maestro/.tmpADEDir_dy2025/TB_PLL_SpectreFXAX/simulation/MyLib_202510_PLL_onc18/TB_PLL/maestro/results/maestro/.tmpADEDir_dy2025/TB_PLL_SpectreFXAX/simulation/MyLib_202510_PLL_onc18/TB_PLL/maestro/results/maestro/202510_PLL_v2_SpectreXCX_tran15ms_allTrimming_40fF_outX24_29points_3to31/psf/TB_PLL_SpectreXCX/psf

保险起见，我们又将数据作了备份，路径为：
/home/dy2025/Desktop/Work/simulation/MyLib_202510_PLL_onc18/TB_PLL/maestro/results/maestro/.tmpADEDir_dy2025/TB_PLL_SpectreFXAX/simulation/MyLib_202510_PLL_onc18/TB_PLL/maestro/results/maestro/.tmpADEDir_dy2025/TB_PLL_SpectreFXAX/simulation/MyLib_202510_PLL_onc18/TB_PLL/maestro/results/maestro/.tmpADEDir_dy2025/TB_PLL_SpectreFXAX/simulation/MyLib_202510_PLL_onc18/TB_PLL/maestro/results/maestro/202510_PLL_v2_SpectreXCX_tran15ms_allTrimming_40fF_outX24_29points_3to31__BK_20251212_1358
```




<div class='center'>

| 如何在 results browser 中，利用上述数据计算 edge time: |
|:-:|
 | (1) 在 results browser 中选择目标数据文件夹，然后右键 `Set Context`，此时观察到目标数据文件夹显示为绿色。这一步是为了简化后面 calculator 中表达式的路径，不需要带很长的路径字符串 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-12-14-22-36_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 然后是 edgeTime 的基本计算原理，以 `CK_OUT` 为例：`edgeTime__CK_OUT = cross(  clip(VT("/CK_OUT") settling_begin time_end)  (VAR("VDD") / 2) 1 "rising" t "cycle" nil)`；当然，这里的 `clip` 时间以及 VDD 需要引用 variable 或者具体数值，简便起见，我们使用从 5ms ~ 15ms 的具体数值，命令变为：`edgeTime__CK_OUT = cross(  clip(VT("/CK_OUT") 5m 15m)  (1.25 / 2) 1 "rising" t "cycle" nil)` |
 | 在上一步基础上，需要对用到的信号指定来源，将其修改为 results browser 中能识别的形式，最终的计算命令为：`edgeTime__CK_OUT = cross(  clip(v("CK_OUT" ?result "tran") 5m 15m)  (1.25 / 2) 1 "rising" t "cycle" nil)` |
 | 在 Calculator 中输入命令并点击 `Evaluate the buffer. if waveform, plot`，计算/作图完成后导出数据 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-12-14-28-45_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | `edgeTime__CK_ADC` 也是类似，作图后导出数据；再将 scalar 数据全部导出。 |
 | 这样, all_trimming 层面所需的全部数据就已经有了，无需担心再出什么问题 |
</div>

``` bash
edgeTime 最基本的计算原理：
edgeTime__CK_OUT = cross(CK_OUT (VAR("VDD") / 2) 1 "rising" t "cycle" nil)
CK_OUT = clip(VT("/CK_OUT") settling_begin time_end) 

```




### 7.2 all_corner of v2
### 7.3 all_load of v2
### 7.4 more detailed results

这里给出功耗分布饼图：


## FATAL (SPECTRE-18): Segmentation fault.

2025.12.10 13:35 做后仿时又出现了这个问题，之前就遇到过 (当时就没找到解决方案)，放着不管之后，不知道为啥它莫名很久没出现，然后不知道为啥今天又出现了。这里详细记录一下问题出现的过程和报错信息，方便之后查找解决方案。

我们设置 Spectre X + CX (multi-thread = 8) 和 max jobs = 4 之后，先运行了一个 5.5 ms @ 1-point 的仿真 (占一个 job), 然后又运行了一个 15ms @ 32-point 的仿真，此时仿真器会先仿 32-point 中的前三个点 (占三个 job)，这样就一共占了四个 job，等前面有任务完成之后才会继续往后。第二天早上来一看，5.5 ms @ 1-point 这个稍短些的仿真顺利完成，但是 15ms @ 32-point 中的前三个点均出现错误。但又比较奇怪的是，15ms @ 32-point 中的 4th ~ 7th point 又顺利完成了 (在 1st ~ 3rd point 完成之后仿的 4th ~ 7th)

5.5 ms @ 1-point 这个稍短的仿真顺利完成：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-10-13-56-11_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div>

15ms @ 32-point 中的 1st ~ 3rd point 仿真报错环境如下：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-10-13-45-37_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div>

看起来像是 1st point 仿真出错，同时导致了 2nd 和 3rd points 也中断，因为后两者的 log 没有给出任何报错： <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-10-13-48-33_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div>

仿真前设置了仅保存顶层节点，所以也没占多少内存/硬盘 (不到 1GB 内存)，所以也不是内存/硬盘大小的问题： <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-10-13-54-04_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div>


Simulator log of the 1st point 中的具体报错内容如下：

``` bash
Internal error found in spectre at time = 647.25 us during transient analysis `tran'.

    FATAL (SPECTRE-19): Bus error signal received by Spectre. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem.    FATAL (SPECTRE-19): Bus error signal received by Spectre. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem.    FATAL (SPECTRE-19): Bus error signal received by Spectre. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem.

    FATAL (SPECTRE-18): Segmentation fault. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem.
```


暂时没有啥好的解决方案，实在不行就用断点续仿间接解决一下吧：参考这篇文章 [模拟电路仿真技巧——延长仿真时间 (spectre 的 save 和 restart feature)](https://zhuanlan.zhihu.com/p/142714596)

这个我之前到时也看到过，当时还简单试了一下（用），但不太清楚异常退出后会不会按原先设置的保存不同时间下的 transient 状态。

## Hspice 尝试 

``` bash
ERROR (SFE-23): "netlist" 57: The instance `I0' is referencing an undefined model or subcircuit, `202510_PLL'. Either include the file containing the definition of `202510_PLL', or define `202510_PLL' before running the simulation.
Warning from spectre during circuit read-in.
```

尝试了 `Hspice` 格式的 hspiceText view, 行不通，暂时放弃。

## x. DRC tips


``` bash
Check pepiNOTbln_UNDERPASSES_pwallConn:
pepiNOTnbl has been found with more than one net connected
which creates a resistive path or UNDERPASS in the net which is not recommended.

大多数情况是因为加了 nw ring 后，内部 psub 与外部 psub 没有连通；这在需要 guard ring 的模块设计中是正常现象，可通过去除 nw ring 来验证 (去除 nw ring, 或者开通一条小路径后问题消失)。当然，如果当前模块就是需要提交的最终模块，还是建议开一条小路径把 psub 连通，以避免提交后的扯皮。
```


## x. Iteration Summary

<!-- <div class='center'>

| Time | Summary | Results Overview | 
|:-:|:-:|:-:|
 | 2025.11.04 (1) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-07-00-08-35_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-06-23-55-35_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 2025.11.04 (2) | x | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-06-23-34-46_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 2025.11.05 (1) | x | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-06-23-36-49_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 2025.11.05 (2) (PFD optimization) | x | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-06-23-31-27_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 2025.11.07 (LPF optimization - lower BW) |  |  |
 | 2025.11.08 (LPF optimization - lower tau_P, higher zeta) |  |  |
</div>
 -->



























**<span style='color:red'> ！！！！！ Macro Model Name 没改 </span>**



**FD 不仅要能在低频工作，高频也是需要的？**




## x. Experience Summary
 
- Verilog-A 代码修改后却 "没有变化" 时，记得在 verilog 界面点击左上角的保存按钮 `Build a databese of instances, nets and pins found in file`，这会重新提取 verilog 代码对应网表；如果还不行，可能是原理图未刷新导致的，重新放置器件即可。 
- 在 Assembler 的 Global Variables 处右键可以 Add Config Sweep.
- VCO 输出波形 (CK_OUT) 占空比不为 50% 时，不会对 CK_FB 产生影响，因为 PFD 比较的是两路时钟的上升沿对齐情况，即便 CK_FB 是窄脉冲也可以正常工作
- 偶数分频 (2 分频) 可以完全修正时钟占空比，奇数分配只能部分修正，具体如下：

$$
\begin{gather}
N = 2k + 1 \Longrightarrow  D' = \frac{100\%\times k + D}{100\%\times (2k + 1)} = \frac{D  - 50\%}{N} + 50\% 
\\
\mathrm{for\ example:}\ D = 53\%,\ N = 15 \Longrightarrow D' = \frac{53\% - 50\%}{15} + 50\% = 50.2\%
\end{gather}
$$


- global 变量用于扫描，sweep 变量由于存放最佳值
- VCO 设置时分为 VCO_core 和 VCO_buffer 两部分，方便迭代
- Current-Starved Ring VCO: VDD = 1.2\*Vth ~ 2.8\*Vth 有良好性能；如果要求功耗尽量低，那么 1.5\*Vth 左右能在保证其它性能的前提下尽量降低功耗；综合性能最优的点一般在 2.0\*Vth 附近
- 蒙卡点数太少是看不了 mismatch contribution 的，例如只设了 10 个点不行，改成 100 个点后可以
- **Analog multiplexers can be used as digital multiplexers too however digital multiplexers cannot be used as analog multiplexers.**
- 对小面积 nA 级低功耗设计而言，除寄生电容影响外，后仿总比前仿功耗高出 40 nA ~ 100 nA 不等 (与版图面积有关)，这是因为后仿考虑了版图寄生器件漏电流的影响 (主要是寄生 PN 结)



模块文件结构：
``` bash
2025_PLL_RVCO1_layout
    schematic
    layout
    symbol
```


做完一个版本后复制（备份）到另一个 cell: **<span style='color:red'> (注意修改复制后新 cell > layout 的 reference source) </span>**

``` bash
2025_PLL_RVCO1_layout_v1
    schematic
    layout
    symbol
    v1_10272243_PEX_HSPICE
    v1_10272243_layout
```


v1_10272243_layout 是为了再次备份，因为后面有可能修改 v1 的 layout，此时可保存为 v1_10281026_layout (仍属于 v1)
另外，将寄生网表复制到主 cell (config 均使用主 cell，直接从此处调用寄生网表)，最终得到这样的结构：

``` bash
2025_PLL_RVCO1_layout
    schematic
    layout
    symbol
    v1_10272243_PEX_HSPICE
    v1_10281026_PEX_HSPICE
    v2_10290000_PEX_HSPICE

2025_PLL_RVCO1_layout_v1
    schematic
    layout (注意修改复制后新 cell > layout 的 reference source)
    symbol
    v1_10272243_layout
    v1_10272243_PEX_HSPICE
    v1_10281026_layout
    v1_10281026_PEX_HSPICE


2025_PLL_RVCO1_layout_v2
    schematic
    layout (注意修改复制后新 cell > layout 的 reference source)
    symbol
    v2_10290000_layout
    v2_10290000_PEX_HSPICE
```

这样的好处是，可以直接用 config sweep 快速切换 2025_PLL_RVCO1_layout 的 schematic/v1_PEX/v2_PEX, 十分方便。


- 想要 annotate DC operating points 时，直接在 ADE results 处找到想看的工艺角或特定参数，右键选择 `annotate > DC Operating Points` 即可，这样就会自动选择对应参数下的直流工作点结果，显示在原理图上 (配合我们的设置代码即可快速查看晶体管的各个关键参数)
- 对于具有 Negative K_VCO 的锁相环 (假设锁定时控制电压在 VDD/2 附近，不过高或过低)，滤波器 LPF 的 "地" 端有两种基本接法：
    - (1) 接 VDD: 上电之后 V_CT = VDD (最大值)，VCO 频率最低，PLL 需要 "向高频锁定"，锁定时间较长？但是对环路模块 (主要是第一级 FD) 的频率要求大大降低； **如何 "打破" f_out/2 的假锁定状态？**
    - (2) 接 VSS: 上电之后 V_CT = VSS = 0 (最小值)，VCO 频率最高，PLL 需要 "向低频锁定"，锁定时间较短？但是对环路模块 (主要是第一级 FD) 的频率要求较高；也就是说，如果 FD 的最大工作频率不足以覆盖此频率，锁定过程中可能会出现一些问题； **如何 "打破" 2\*f_out 的假锁定状态？**
- VCT 可以设置初始值以加快环路锁定，节省一些时间来仿真稳定后的性能，但是 VDD 最好给充足的 delay 再上电，以避免可能出现的时序或其它问题；
- LPF to VSS/VDD 对 FD 的高频要求不同，如果上电后频率是从低向高锁定，则 FD 高频要求较低，反之则要求较高
- 中高频锁相环 (output > 100 MHz) 的闭环环路带宽比 (f_REF/f_BW) 常常会做到 100 以上，以获得更低的相位噪声 (尤其是低频段)，通常是 150 ~ 500 居多。对于分频比较高的锁相环又如何？
- 对于 CP-PLL, the dead zone of PFD/CP 对整个环路的 Je_rms 影响较大 (因为 Je 是很长时间的 "累积" 抖动)，死区大时，输出相位越有可能接近死区边界，这时便有较大的相位噪声/抖动。举个例子，假设 PFD/CP 对 delay = ±2% 以内都没有反应，也就是 dead zone = -2% ~ +2%, 如果这段死区内的等效电流 $I_{dz}$ 非常小，几乎相当于 "没有电流"，就会导致环路的 RMS phase noise 达到 $2\pi \times 2\% = 0.1257 \ \mathrm{rad} = 7.2^\circ$，这在低抖动时钟系统中是完全不可接受的。这个现象在 nominal $I_P$ 较小时尤为明显，比如 nA-level 低功耗设计。
- 可以用 **`basic > patch`** 元件来短接两个具有不同 net name 的网络，这在版图中也是能正常过的 (版图中会将两网络合二为一，同时保持正确的对应关系)，LVS 能不能过还待验证；但是注意，`patch` 仅能短接两个 net 或者 1 pin + 1 net, 但是不能短接两个 pin (会报错)。与之类似的还有 `basic > cds_thru` 元件 [(here)](https://zhuanlan.zhihu.com/p/370333465)，这个元件其实更好用，一方面它可以短接两个 pin, 另一方面可以明确知道两个 net 到底共用哪个名字 (src 和 dst 两个端口，公用 src 端口的 net name)，数字电路在综合时 (如果需要 "短接") 常常就是自动生成了这个元件，它的版图和 LVS 都能正常通过 (LVS 是利用了 `lvs ignore = true` 来实现的)
- 作图之后，可以通过 `Graph > Edge Browser` 查看边沿的各种信息
- 封装 pcell (parameterized cell) 时，`4*pPar("mu")` 不行但是 `pPar("mu")*4` 可以
- `schematic > View > Info Balloons` 可以打开波形信息气泡，鼠标悬停在 net/pin 上可以快速查看此位置的 voltage/current 波形。


