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


<div class='center'>

| Spectre X + CX 仿真结果与可视化 |  |  |
|:-:|:-:|:-:|
 | 仿真设置 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-13-02-30-11_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | all_trimming of v2 @ Spectre X + CX (0 to 12) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-13-02-28-50_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | all_trimming of v2 @ Spectre X + CX (13 to 31) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-13-02-30-00_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 结果汇总表 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-14-19-56-55_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | MATLAB 可视化曲线图  | MATLAB 可视化柱状图  |
 | 结果汇总表  | MATLAB 可视化曲线图  | MATLAB 可视化柱状图  |
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


``` bash
\begin{table}[H]\centering
    %\renewcommand{\arraystretch}{1.5} % 调整行间距为 1.5 倍
    %\setlength{\tabcolsep}{1.5mm} % 调整列间距
    \caption{Post-layout simulation results at typical corner for all trimming codes}
    \label{tab__simul_all_trimming_results}

\resizebox{\linewidth}{!}{   % 设置宽度为 \linewidth 等比例缩放
\begin{tabular}{cccccccccccccccccccccccccccccccccccccccc}\toprule\toprule
    T$\left \langle 4:0 \right \rangle\ $ (Decimal) & 0 & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10 & 11 & 12 & 13 & 14 & 15 & 16 & 17 & 18 & 19 & 20 & 21 & 22 & 23 & 24 & 25 & 26 & 27 & 28 & 29 & 30 & 31 \\
    \bottomrule\toprule
    $I_P$ & \\
    $C_1$ & \\
    $C_2$ & \\
    \midrule
    $I_{DD}$ @ 40 fF (simul.)   & \\ 
    $I_{DD}$ @ no load (calc.)  & \\ 
    $t_{lock}$                  & \\ 
    \midrule
    $D_{ADC}$ & \\ 
    $t_{rise,ADC}$    & \\ 
    $t_{fall,ADC}$    & \\ 
    $J_{c,rms,ADC}$   & \\ 
    $J_{e,rms,ADC}$   & \\ 
    $J_{int,rms,ADC}$ & \\ 
    $L_{ADC}(f_m)\,@\,1 \ \mathrm{kHz}$         & \\ 
    $L_{ADC}(f_m)\,@\,10 \ \mathrm{kHz}$        & \\ 
    $L_{ADC}(f_m)\,@\, \frac{f_{CK\_ADC}}{2}$   & \\ 
    \midrule
    $D_{OUT}$ & \\ 
    $t_{rise,OUT}$    & \\ 
    $t_{fall,OUT}$    & \\ 
    $J_{c,rms,OUT}$   & \\ 
    $J_{e,rms,OUT}$   & \\ 
    $J_{int,rms,OUT}$ & \\ 
    $L_{OUT}(f_m)\,@\,1 \ \mathrm{kHz}$         & \\ 
    $L_{OUT}(f_m)\,@\,10 \ \mathrm{kHz}$        & \\ 
    $L_{OUT}(f_m)\,@\, \frac{f_{CK\_OUT}}{2}$   & \\ 
    \bottomrule\bottomrule
\end{tabular}
}\end{table}



\begin{table}[H]\centering
    %\renewcommand{\arraystretch}{1.5} % 调整行间距为 1.5 倍
    %\setlength{\tabcolsep}{1.5mm} % 调整列间距
    \caption{Post-layout simulation results at typical corner for all trimming codes}
    \label{tab__simul_all_trimming_results}

\resizebox{\linewidth}{!}{   % 设置宽度为 \linewidth 等比例缩放
\begin{tabular}{cccccccccccccccccccccccccccccccccccccccc}\toprule\toprule
    T$\left \langle 4:0 \right \rangle\ $ (Decimal) & 0 & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10 & 11 & 12 & 13 & 14 & 15 & 16 & 17 & 18 & 19 & 20 & 21 & 22 & 23 & 24 & 25 & 26 & 27 & 28 & 29 & 30 & 31 \\
    \bottomrule\toprule
    $I_P$ & \\
    $C_1$ & \\
    $C_2$ & \\
    \midrule
    (simul.) $I_{DD}$ @ 40 fF (nA)  & 503.40 & 503.70 & 502.50 & 505.20 & 503.90 & 502.70 & 503.40 & 504.40 & 508.40 & 507.90 & 507.40 & 506.20 & 508.00 & 508.50 & 508.50 & 508.90 & 513.50 & 511.20 & 512.40 & 512.90 & 513.90 & 514.20 & 514.40 & 511.60 & 518.10 & 519.30 & 518.50 & 518.70 & 518.30 & 518.10 & 518.30 & 519.30 \\
    (calc.)$I_{DD}$ @ no load (nA) & 459.16 & 459.46 & 458.26 & 460.96 & 459.66 & 458.46 & 459.16 & 460.16 & 464.16 & 463.66 & 463.16 & 461.96 & 463.76 & 464.26 & 464.26 & 464.66 & 469.26 & 466.96 & 468.16 & 468.66 & 469.66 & 469.96 & 470.16 & 467.36 & 473.86 & 475.06 & 474.26 & 474.46 & 474.06 & 473.86 & 474.06 & 475.06 \\
    $t_{lock}$ (ms)                 & 1.77 & 2.05 & 2.23 & 2.42 & 2.72 & 2.99 & 3.15 & 3.33 & 1.56 & 1.71 & 1.90 & 2.08 & 2.32 & 2.57 & 2.69 & 2.81 & 1.44 & 1.56 & 1.77 & 1.93 & 2.14 & 2.32 & 2.47 & 2.54 & 14.97 & 1.50 & 1.62 & 1.80 & 2.02 & 2.17 & 2.29 & 2.41 \\
    \midrule
    $D_{ADC}$ (\%) & 50.02 & 50.02 & 50.02 & 50.01 & 50.04 & 50.04 & 50.03 & 50.03 & 50.02 & 50.02 & 50.01 & 50.01 & 50.04 & 50.04 & 50.03 & 50.03 & 50.02 & 50.02 & 50.02 & 50.01 & 50.04 & 50.04 & 50.04 & 50.03 & 49.96 & 50.01 & 50.01 & 50.01 & 50.04 & 50.04 & 50.03 & 50.03 \\
    $t_{rise,ADC}$ (mUI)  & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 \\
    $t_{fall,ADC}$ (mUI)   & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 & 0.05 \\
    $J_{c,rms,ADC}$ (ns)  & 24.54 & 22.12 & 20.22 & 19.52 & 20.33 & 18.67 & 17.84 & 17.36 & 34.22 & 29.78 & 24.21 & 22.06 & 21.09 & 20.08 & 20.20 & 16.92 & 68.35 & 42.69 & 34.32 & 26.93 & 25.49 & 23.08 & 21.29 & 20.84 & 564.12 & 170.31 & 63.15 & 39.00 & 33.65 & 26.98 & 25.46 & 22.05 \\
    $J_{e,rms,ADC}$ (ns)  & 26.28 & 26.73 & 26.39 & 28.32 & 29.85 & 28.81 & 28.04 & 30.51 & 34.56 & 32.38 & 27.46 & 26.74 & 25.60 & 26.47 & 28.18 & 23.26 & 66.39 & 42.30 & 35.11 & 28.80 & 28.72 & 27.82 & 26.46 & 26.86 & 545.67 & 165.28 & 61.77 & 39.77 & 34.69 & 29.94 & 28.88 & 26.21 \\
    $J_{int,rms,ADC}$ (ns) & 19.65 & 18.38 & 15.09 & 14.95 & 14.85 & 13.61 & 13.63 & 11.49 & 31.01 & 27.73 & 21.92 & 20.78 & 19.45 & 18.14 & 15.62 & 14.74 & 64.92 & 40.25 & 32.67 & 26.09 & 24.82 & 21.74 & 21.35 & 19.94 & 542.28 & 163.91 & 60.62 & 37.80 & 32.68 & 26.79 & 25.41 & 21.94 \\
    $L_{ADC}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)        & -81.82 & -81.03 & -80.51 & -81.46 & -80.69 & -82.33 & -81.51 & -80.95 & -82.82 & -82.33 & -82.69 & -83.01 & -83.96 & -83.97 & -83.75 & -85.03 & -84.60 & -87.35 & -85.72 & -85.36 & -86.16 & -84.54 & -88.98 & -86.72 & -82.46 & -86.58 & -88.52 & -87.35 & -87.13 & -85.68 & -87.99 & -87.31 \\
    $L_{ADC}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)       & -84.42 & -82.98 & -82.59 & -82.61 & -81.87 & -82.48 & -82.50 & -83.49 & -84.23 & -83.34 & -83.21 & -82.09 & -82.03 & -81.15 & -79.55 & -83.02 & -86.16 & -84.86 & -85.19 & -85.04 & -81.14 & -81.12 & -80.25 & -79.53 & -78.84 & -84.33 & -85.08 & -84.77 & -85.56 & -81.89 & -81.50 & -82.10 \\
    $L_{ADC}(f_m)\,@\, \frac{f_{CK\_ADC}}{2}$ (dBc/Hz)  & -102.70 & -100.25 & -101.80 & -102.36 & -103.81 & -105.02 & -103.91 & -104.20 & -90.89 & -96.40 & -101.44 & -104.43 & -103.48 & -102.26 & -102.24 & -102.40 & -82.22 & -88.08 & -90.15 & -96.65 & -99.45 & -101.34 & -103.84 & -102.19 & -73.70 & -79.50 & -82.36 & -87.59 & -91.57 & -96.27 & -96.38 & -100.15 \\
    \midrule
    $D_{OUT}$ (\%)  & 50.68 & 50.68 & 50.69 & 50.65 & 50.67 & 50.67 & 50.68 & 50.68 & 50.67 & 50.68 & 50.67 & 50.68 & 50.69 & 50.68 & 50.67 & 50.67 & 50.68 & 50.65 & 50.67 & 50.68 & 50.69 & 50.66 & 50.67 & 50.68 & 50.66 & 50.66 & 50.65 & 50.67 & 50.69 & 50.65 & 50.67 & 50.67 \\
    $t_{rise,OUT}$ (mUI)   & 0.47 & 0.48 & 0.48 & 0.48 & 0.48 & 0.47 & 0.47 & 0.48 & 0.48 & 0.48 & 0.48 & 0.48 & 0.48 & 0.48 & 0.47 & 0.48 & 0.48 & 0.48 & 0.48 & 0.48 & 0.48 & 0.47 & 0.47 & 0.48 & 0.47 & 0.48 & 0.48 & 0.48 & 0.48 & 0.48 & 0.48 & 0.48 \\
    $t_{fall,OUT}$ (mUI)   & 0.44 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 & 0.44 & 0.45 & 0.44 & 0.45 & 0.44 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 & 0.44 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 & 0.45 \\
    $J_{c,rms,OUT}$ (ns)  & 4.49 & 4.14 & 3.91 & 3.82 & 4.04 & 3.82 & 3.68 & 3.62 & 5.54 & 4.98 & 4.32 & 4.04 & 4.10 & 3.96 & 3.84 & 3.61 & 9.68 & 6.42 & 5.44 & 4.56 & 4.53 & 4.22 & 4.04 & 3.95 & 74.77 & 22.98 & 8.95 & 5.94 & 5.41 & 4.60 & 4.43 & 4.06 \\
    $J_{e,rms,OUT}$ (ns)  & 25.87 & 26.40 & 26.17 & 28.14 & 29.69 & 28.56 & 27.84 & 30.37 & 33.72 & 31.65 & 27.02 & 26.38 & 25.23 & 26.18 & 27.94 & 23.03 & 63.90 & 41.11 & 34.11 & 28.12 & 28.27 & 27.40 & 26.10 & 26.54 & 522.49 & 158.78 & 59.60 & 38.87 & 33.83 & 29.22 & 28.18 & 25.62 \\
    $J_{int,rms,OUT}$ (ns) & 19.28 & 18.07 & 14.95 & 14.83 & 14.90 & 13.60 & 13.58 & 11.61 & 30.18 & 27.08 & 21.52 & 20.50 & 19.09 & 17.97 & 15.46 & 14.68 & 62.51 & 39.06 & 31.66 & 25.39 & 24.39 & 21.47 & 20.99 & 19.67 & 521.92 & 158.18 & 58.49 & 36.93 & 31.83 & 26.08 & 24.81 & 21.46 \\
    $L_{OUT}(f_m)\,@\,1 \ \mathrm{kHz}$  (dBc/Hz)       & -81.82 & -81.03 & -80.51 & -81.46 & -80.69 & -82.33 & -81.51 & -80.95 & -82.82 & -82.33 & -82.69 & -83.01 & -83.96 & -83.97 & -83.75 & -85.03 & -84.60 & -87.35 & -85.72 & -85.36 & -86.16 & -84.54 & -88.98 & -86.72 & -82.46 & -86.58 & -88.52 & -87.35 & -87.13 & -85.68 & -87.99 & -87.31 \\
    $L_{OUT}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)       & -84.42 & -82.98 & -82.59 & -82.61 & -81.87 & -82.48 & -82.50 & -83.49 & -84.23 & -83.34 & -83.21 & -82.09 & -82.03 & -81.15 & -79.55 & -83.02 & -86.16 & -84.86 & -85.19 & -85.04 & -81.14 & -81.12 & -80.25 & -79.53 & -78.84 & -84.33 & -85.08 & -84.77 & -85.56 & -81.89 & -81.50 & -82.10 \\
    $L_{OUT}(f_m)\,@\, \frac{f_{CK\_OUT}}{2}$ (dBc/Hz)  & -102.70 & -100.25 & -101.80 & -102.36 & -103.81 & -105.02 & -103.91 & -104.20 & -90.89 & -96.40 & -101.44 & -104.43 & -103.48 & -102.26 & -102.24 & -102.40 & -82.22 & -88.08 & -90.15 & -96.65 & -99.45 & -101.34 & -103.84 & -102.19 & -73.70 & -79.50 & -82.36 & -87.59 & -91.57 & -96.27 & -96.38 & -100.15 \\
    \bottomrule\bottomrule
\end{tabular}
}\end{table}

```



``` bash
\begin{tabular}{cccccccccccccccccccccccccccccccccccccccc}\toprule\toprule
    Trimming Code T$\left \langle 4:0 \right \rangle$ (Decimal) & 0 & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10 & 11 & 12 & 13 & 14 & 15 & 16 & 17 & 18 & 19 & 20 & 21 & 22 & 23 & 24 & 25 & 26 & 27 & 28 & 29 & 30 & 31 \\
    \toprule\toprule
    $I_{DD}$ @ 40 fF (simul.) (nA)   & \\
    $I_{DD}$ @ no load (calc.) (nA)  & \\
    $t_{lock}$  (ms)                & \\
    \midrule
    $D_{ADC}$ (\%) & \\
    $t_{rise,ADC}$ (ns)    & \\
    $t_{fall,ADC}$ (ns)    & \\
    $J_{c,rms,ADC}$ (ns)   & \\
    $J_{e,rms,ADC}$ (ns)   & \\
    $J_{int,rms,ADC}$ (ns) & \\
    $L_{ADC}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)       & \\
    $L_{ADC}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)      & \\
    $L_{ADC}(f_m)\,@\, \frac{f_{CK\_ADC}}{2}$ (dBc/Hz) & \\
    \midrule
    $D_{OUT}$ (\%) & \\
    $t_{rise,OUT}$ (ns)   & \\
    $t_{fall,OUT}$ (ns)    & \\
    $J_{c,rms,OUT}$ (ns)   & \\
    $J_{e,rms,OUT}$ (ns)   & \\
    $J_{int,rms,OUT}$ (ns) & \\
    $L_{OUT}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)       & \\
    $L_{OUT}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)      & \\
    $L_{OUT}(f_m)\,@\, \frac{f_{CK\_OUT}}{2}$ (dBc/Hz) & \\
    \bottomrule\bottomrule
\end{tabular}

\begin{tabular}{cccccccccccccccccccccccccccccccccccccccc}\toprule\toprule
    Parameter & Best @ Code & Worst @ Code \\
    \toprule\toprule
    (simul.) $I_{DD}$ @ 40 fF   & \\
    (calc.) $I_{DD}$ @ no load  & \\
    $t_{lock}$                & \\
    \midrule
    $D_{ADC}$  & \\
    $t_{rise,ADC}$   & \\
    $t_{fall,ADC}$   & \\
    $J_{c,rms,ADC}$  & \\
    $J_{e,rms,ADC}$  & \\
    $J_{int,rms,ADC}$ & \\
    $L_{ADC}(f_m)\,@\,1 \ \mathrm{kHz}$          & \\
    $L_{ADC}(f_m)\,@\,10 \ \mathrm{kHz}$         & \\
    $L_{ADC}(f_m)\,@\, \frac{f_{CK\_ADC}}{2}$    & \\
    \midrule
    $D_{OUT}$  & \\
    $t_{rise,OUT}$   & \\
    $t_{fall,OUT}$    & \\
    $J_{c,rms,OUT}$   & \\
    $J_{e,rms,OUT}$   & \\
    $J_{int,rms,OUT}$ & \\
    $L_{OUT}(f_m)\,@\,1 \ \mathrm{kHz}$       & \\
    $L_{OUT}(f_m)\,@\,10 \ \mathrm{kHz}$      & \\
    $L_{OUT}(f_m)\,@\, \frac{f_{CK\_OUT}}{2}$ & \\
    \bottomrule\bottomrule
\end{tabular}

nA      
nA      
ms      
\%      
ns      
ns      
ns      
ns      
ns      
dBc/Hz  
dBc/Hz  
dBc/Hz  
\%      
ns      
ns      
ns      
ns      
ns      
dBc/Hz  
dBc/Hz  
dBc/Hz  
```


``` bash
\begin{table}[H]\centering
    %\renewcommand{\arraystretch}{1.5} % 调整行间距为 1.5 倍
    %\setlength{\tabcolsep}{1.5mm} % 调整列间距
    \caption{Post-layout simulation results at typical corner for all trimming codes}
    \label{tab__simul_all_trimming_results}

\resizebox{\linewidth}{!}{   % 设置宽度为 \linewidth 等比例缩放
\begin{tabular}{cccccccccccccccccccccccccccccccccccccccc}\toprule\toprule
    Trimming Code T$\left \langle 4:0 \right \rangle$ (Decimal) & 0 & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10 & 11 & 12 & 13 & 14 & 15 & 16 & 17 & 18 & 19 & 20 & 21 & 22 & 23 & 24 & 25 & 26 & 27 & 28 & 29 & 30 & 31 \\
    \toprule\toprule
    (simul.) $I_{DD}$ @ 40 fF (nA)   & 503.40 & 503.70 & 502.50 & 505.20 & 503.90 & 502.70 & 503.40 & 504.40 & 508.40 & 507.90 & 507.40 & 506.20 & 508.00 & 508.50 & 508.50 & 508.90 & 513.50 & 511.20 & 512.40 & 512.90 & 513.90 & 514.20 & 514.40 & 511.60 & 518.10 & 519.30 & 518.50 & 518.70 & 518.30 & 518.10 & 518.30 & 519.30 \\
    (calc.) $I_{DD}$ @ no load (nA)  & 459.16 & 459.46 & 458.26 & 460.96 & 459.66 & 458.46 & 459.16 & 460.16 & 464.16 & 463.66 & 463.16 & 461.96 & 463.76 & 464.26 & 464.26 & 464.66 & 469.26 & 466.96 & 468.16 & 468.66 & 469.66 & 469.96 & 470.16 & 467.36 & 473.86 & 475.06 & 474.26 & 474.46 & 474.06 & 473.86 & 474.06 & 475.06 \\
    $t_{lock}$  (ms)                & 1.77 & 2.05 & 2.23 & 2.42 & 2.72 & 2.99 & 3.15 & 3.33 & 1.56 & 1.71 & 1.90 & 2.08 & 2.32 & 2.57 & 2.69 & 2.81 & 1.44 & 1.56 & 1.77 & 1.93 & 2.14 & 2.32 & 2.47 & 2.54 & NAN & 1.50 & 1.62 & 1.80 & 2.02 & 2.17 & 2.29 & 2.41 \\
    \midrule
    $D_{ADC}$ (\%) & 50.02 & 50.02 & 50.02 & 50.01 & 50.04 & 50.04 & 50.03 & 50.03 & 50.02 & 50.02 & 50.01 & 50.01 & 50.04 & 50.04 & 50.03 & 50.03 & 50.02 & 50.02 & 50.02 & 50.01 & 50.04 & 50.04 & 50.04 & 50.03 & 49.96 & 50.01 & 50.01 & 50.01 & 50.04 & 50.04 & 50.03 & 50.03 \\
    $t_{rise,ADC}$ (ns)    & 0.54 & 0.54 & 0.55 & 0.55 & 0.55 & 0.54 & 0.55 & 0.55 & 0.54 & 0.55 & 0.55 & 0.55 & 0.54 & 0.55 & 0.55 & 0.54 & 0.55 & 0.55 & 0.54 & 0.54 & 0.54 & 0.55 & 0.55 & 0.54 & 0.55 & 0.54 & 0.55 & 0.54 & 0.54 & 0.55 & 0.55 & 0.54 \\
    $t_{fall,ADC}$ (ns)    & 0.56 & 0.56 & 0.55 & 0.55 & 0.55 & 0.55 & 0.55 & 0.55 & 0.55 & 0.55 & 0.55 & 0.55 & 0.55 & 0.55 & 0.55 & 0.56 & 0.55 & 0.55 & 0.55 & 0.55 & 0.56 & 0.55 & 0.55 & 0.56 & 0.55 & 0.55 & 0.56 & 0.56 & 0.55 & 0.56 & 0.55 & 0.56 \\
    $J_{c,rms,ADC}$ (ns)   & 24.54 & 22.12 & 20.22 & 19.52 & 20.33 & 18.67 & 17.84 & 17.36 & 34.22 & 29.78 & 24.21 & 22.06 & 21.09 & 20.08 & 20.20 & 16.92 & 68.35 & 42.69 & 34.32 & 26.93 & 25.49 & 23.08 & 21.29 & 20.84 & 564.12 & 170.31 & 63.15 & 39.00 & 33.65 & 26.98 & 25.46 & 22.05 \\
    $J_{e,rms,ADC}$ (ns)   & 26.28 & 26.73 & 26.39 & 28.32 & 29.85 & 28.81 & 28.04 & 30.51 & 34.56 & 32.38 & 27.46 & 26.74 & 25.60 & 26.47 & 28.18 & 23.26 & 66.39 & 42.30 & 35.11 & 28.80 & 28.72 & 27.82 & 26.46 & 26.86 & 545.67 & 165.28 & 61.77 & 39.77 & 34.69 & 29.94 & 28.88 & 26.21 \\
    $J_{int,rms,ADC}$ (ns) & 19.65 & 18.38 & 15.09 & 14.95 & 14.85 & 13.61 & 13.63 & 11.49 & 31.01 & 27.73 & 21.92 & 20.78 & 19.45 & 18.14 & 15.62 & 14.74 & 64.92 & 40.25 & 32.67 & 26.09 & 24.82 & 21.74 & 21.35 & 19.94 & 542.28 & 163.91 & 60.62 & 37.80 & 32.68 & 26.79 & 25.41 & 21.94 \\
    $L_{ADC}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)       & -81.82 & -81.03 & -80.51 & -81.46 & -80.69 & -82.33 & -81.51 & -80.95 & -82.82 & -82.33 & -82.69 & -83.01 & -83.96 & -83.97 & -83.75 & -85.03 & -84.60 & -87.35 & -85.72 & -85.36 & -86.16 & -84.54 & -88.98 & -86.72 & -82.46 & -86.58 & -88.52 & -87.35 & -87.13 & -85.68 & -87.99 & -87.31 \\
    $L_{ADC}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)      & -84.42 & -82.98 & -82.59 & -82.61 & -81.87 & -82.48 & -82.50 & -83.49 & -84.23 & -83.34 & -83.21 & -82.09 & -82.03 & -81.15 & -79.55 & -83.02 & -86.16 & -84.86 & -85.19 & -85.04 & -81.14 & -81.12 & -80.25 & -79.53 & -78.84 & -84.33 & -85.08 & -84.77 & -85.56 & -81.89 & -81.50 & -82.10 \\
    $L_{ADC}(f_m)\,@\, \frac{f_{CK\_ADC}}{2}$ (dBc/Hz) & -102.70 & -100.25 & -101.80 & -102.36 & -103.81 & -105.02 & -103.91 & -104.20 & -90.89 & -96.40 & -101.44 & -104.43 & -103.48 & -102.26 & -102.24 & -102.40 & -82.22 & -88.08 & -90.15 & -96.65 & -99.45 & -101.34 & -103.84 & -102.19 & -73.70 & -79.50 & -82.36 & -87.59 & -91.57 & -96.27 & -96.38 & -100.15 \\
    \midrule
    $D_{OUT}$ (\%) & 50.68 & 50.68 & 50.69 & 50.65 & 50.67 & 50.67 & 50.68 & 50.68 & 50.67 & 50.68 & 50.67 & 50.68 & 50.69 & 50.68 & 50.67 & 50.67 & 50.68 & 50.65 & 50.67 & 50.68 & 50.69 & 50.66 & 50.67 & 50.68 & 50.66 & 50.66 & 50.65 & 50.67 & 50.69 & 50.65 & 50.67 & 50.67 \\
    $t_{rise,OUT}$ (ns)   & 4.83 & 4.85 & 4.84 & 4.87 & 4.91 & 4.83 & 4.83 & 4.89 & 4.84 & 4.85 & 4.85 & 4.87 & 4.84 & 4.84 & 4.81 & 4.88 & 4.85 & 4.87 & 4.87 & 4.86 & 4.90 & 4.82 & 4.82 & 4.86 & 4.82 & 4.93 & 4.92 & 4.85 & 4.88 & 4.88 & 4.87 & 4.90 \\
    $t_{fall,OUT}$ (ns)    & 4.52 & 4.53 & 4.57 & 4.57 & 4.54 & 4.55 & 4.62 & 4.53 & 4.56 & 4.53 & 4.58 & 4.49 & 4.56 & 4.53 & 4.59 & 4.52 & 4.57 & 4.55 & 4.59 & 4.55 & 4.56 & 4.56 & 4.59 & 4.58 & 4.54 & 4.51 & 4.55 & 4.58 & 4.56 & 4.55 & 4.60 & 4.57 \\
    $J_{c,rms,OUT}$ (ns)   & 4.49 & 4.14 & 3.91 & 3.82 & 4.04 & 3.82 & 3.68 & 3.62 & 5.54 & 4.98 & 4.32 & 4.04 & 4.10 & 3.96 & 3.84 & 3.61 & 9.68 & 6.42 & 5.44 & 4.56 & 4.53 & 4.22 & 4.04 & 3.95 & 74.77 & 22.98 & 8.95 & 5.94 & 5.41 & 4.60 & 4.43 & 4.06 \\
    $J_{e,rms,OUT}$ (ns)   & 25.87 & 26.40 & 26.17 & 28.14 & 29.69 & 28.56 & 27.84 & 30.37 & 33.72 & 31.65 & 27.02 & 26.38 & 25.23 & 26.18 & 27.94 & 23.03 & 63.90 & 41.11 & 34.11 & 28.12 & 28.27 & 27.40 & 26.10 & 26.54 & 522.49 & 158.78 & 59.60 & 38.87 & 33.83 & 29.22 & 28.18 & 25.62 \\
    $J_{int,rms,OUT}$ (ns) & 19.28 & 18.07 & 14.95 & 14.83 & 14.90 & 13.60 & 13.58 & 11.61 & 30.18 & 27.08 & 21.52 & 20.50 & 19.09 & 17.97 & 15.46 & 14.68 & 62.51 & 39.06 & 31.66 & 25.39 & 24.39 & 21.47 & 20.99 & 19.67 & 521.92 & 158.18 & 58.49 & 36.93 & 31.83 & 26.08 & 24.81 & 21.46 \\
    $L_{OUT}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)       & -81.82 & -81.03 & -80.51 & -81.46 & -80.69 & -82.33 & -81.51 & -80.95 & -82.82 & -82.33 & -82.69 & -83.01 & -83.96 & -83.97 & -83.75 & -85.03 & -84.60 & -87.35 & -85.72 & -85.36 & -86.16 & -84.54 & -88.98 & -86.72 & -82.46 & -86.58 & -88.52 & -87.35 & -87.13 & -85.68 & -87.99 & -87.31 \\
    $L_{OUT}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)      & -84.42 & -82.98 & -82.59 & -82.61 & -81.87 & -82.48 & -82.50 & -83.49 & -84.23 & -83.34 & -83.21 & -82.09 & -82.03 & -81.15 & -79.55 & -83.02 & -86.16 & -84.86 & -85.19 & -85.04 & -81.14 & -81.12 & -80.25 & -79.53 & -78.84 & -84.33 & -85.08 & -84.77 & -85.56 & -81.89 & -81.50 & -82.10 \\
    $L_{OUT}(f_m)\,@\, \frac{f_{CK\_OUT}}{2}$ (dBc/Hz) & -102.70 & -100.25 & -101.80 & -102.36 & -103.81 & -105.02 & -103.91 & -104.20 & -90.89 & -96.40 & -101.44 & -104.43 & -103.48 & -102.26 & -102.24 & -102.40 & -82.22 & -88.08 & -90.15 & -96.65 & -99.45 & -101.34 & -103.84 & -102.19 & -73.70 & -79.50 & -82.36 & -87.59 & -91.57 & -96.27 & -96.38 & -100.15 \\
    \bottomrule\bottomrule
\end{tabular}
}\end{table}

```




### 7.2 all_corner of v2


<div class='center'>

| Spectre X + CX 仿真结果与可视化 (all-corner) |  |  |
|:-:|:-:|:-:|
 | 仿真设置 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-14-00-26-48_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | all_corner of v2 @ Spectre X + CX <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-13-22-21-14_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |
 | 结果汇总表 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-14-00-26-35_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | nominal/mean/min/max <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-14-00-26-01_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div>  |  |
 |  MATLAB 可视化曲线图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-14-00-25-41_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | MATLAB 可视化柱状图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-14-00-25-23_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | MATLAB 全工艺相位噪声可视化 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-14-00-25-03_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
</div>




``` bash
\begin{tabular}{cccccccccccccccccccccccccccccccccccccccc}\toprule\toprule
    Test Point & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10 & 11 & 12 \\
    \bottomrule\toprule
    Process Corner & TT & TT & TT & TT & SS & SS & SS & SS & FF & FF & FF & FF \\
    Temperature & -20°C & 27°C & 50°C & 80°C & -20°C & 27°C & 50°C & 80°C & -20°C & 27°C & 50°C & 80°C \\
    Supply Voltage (VDD) & 1.25 V & 1.25 V & 1.25 V & 1.25 V & 1.20 V & 1.20 V & 1.20 V & 1.20 V & 1.30 V & 1.30 V & 1.30 V & 1.30 V \\
    \bottomrule\toprule
    $I_{DD}$ @ 40 fF (simul.) (nA)   & \\
    $I_{DD}$ @ no load (calc.) (nA)  & \\
    $t_{lock}$  (ms)                & \\
    \midrule
    $D_{ADC}$ (\%) & \\
    $t_{rise,ADC}$ (ns)    & \\
    $t_{fall,ADC}$ (ns)    & \\
    $J_{c,rms,ADC}$ (ns)   & \\
    $J_{e,rms,ADC}$ (ns)   & \\
    $J_{int,rms,ADC}$ (ns) & \\
    $L_{ADC}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)       & \\
    $L_{ADC}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)      & \\
    $L_{ADC}(f_m)\,@\, \frac{f_{CK\_ADC}}{2}$ (dBc/Hz) & \\
    \midrule
    $D_{OUT}$ (\%) & \\
    $t_{rise,OUT}$ (ns)   & \\
    $t_{fall,OUT}$ (ns)    & \\
    $J_{c,rms,OUT}$ (ns)   & \\
    $J_{e,rms,OUT}$ (ns)   & \\
    $J_{int,rms,OUT}$ (ns) & \\
    $L_{OUT}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)       & \\
    $L_{OUT}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)      & \\
    $L_{OUT}(f_m)\,@\, \frac{f_{CK\_OUT}}{2}$ (dBc/Hz) & \\
    \bottomrule\bottomrule
\end{tabular}
```


### 7.3 all_load of v2

<div class='center'>

| Spectre X + CX 仿真结果与可视化 (all-corner) |  |  |
|:-:|:-:|:-:|
 | 仿真设置  | all_corner of v2 @ Spectre X + CX  |  |
 | 结果汇总表 (1) | 结果汇总表 (2) nominal/mean/min/max   |  |

</div>


### 7.4 comparison to prior art

2025.12.15 搜集了一下 ultra-low-power PLL 的相关文献，总结如下：

<span style='font-size:10px'> 

<div class='center'>

| Paper | Power Efficiency | Ref. Spur | RMS Jitter | 其它参数 | 架构 | 主要亮点 |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | [1] J.-W. Moon | 0.256 mW/GHz @ 0.4 V (0.13 mW @ 0.5 GHz) | -59 dBc | 16.9 ps | - | 经典 CP-PLL, 差分 RVCO  | (1) 在 CP 中引入了补偿，包括 gain-boosting 和 bulk-driven; (2) 利用了 AFC (automatic frequency calibration) 来提高性能; (3) 使用了带 bulk-driven 的 cross-couple-based differential RVCO  |
 | [2] B. Xiang | 0.213mW/GHz @ 0.8 V  | < -90 dBc | 2.3 ps (J_int @ 100 kHz ~ 100 MHz) | FoM = -234.4 dB, core area = 0.015 mm2 | 经典 CP-PLL | (1) 带有 lock detection 以加速锁定, 200ns lock time at 100MHz reference clock (20 ref cycles); (2) 使用了 tunable switched capacitor based loop filter (SC-LPF); (3) VCO 带有 start-up;   |
 | [3] W. Wu et al. 这是个 Ultra-Low Jitter Frac-N DTC-based sampling PLL  |  |  |  |  |  |  |
 | [4] M. Faisal | 1.6 mW/GHz or 1.1 mW/GHz @ 0.5 V (300 nW @ 187.5 kHz, 570 nW @ 500 kHz) | -60 dBc | 12.3 ns @ 187.5 kHz, 4.7 ns @ 500 kHz | core area = 0.07 mm2  | ADPLL |  |
 | [5] S. Schober (这篇没有给出除 CP 之外的其它模块情况，有拿一个特殊 CP 去蹭已有优秀模块的嫌疑) |  |  |  |  | 经典 CP-PLL | 主要亮点 (1) 使用了非常规的 capacitor-based CP 以实现低抖动和宽锁定, 并且实现了极低的 CP 电流失配和极低的 (锁定后) 静态电流 |
 | [6] S. K. Saw 这篇很拉，像课程大作业而不是论文 |  |  |  |  |  |  |
 | [7] B. Ghafari 这篇不咋行，更像是课程大作业 | @ 1 V (0.196 mW @ 0.4 GHz ) |  |  |  |  | (1) 使用 cross-coupled-based RVCO |
 | [8] Y.-H. | 0.50 mW/GHz @ 1V (1.19 mW @ 2.4 GHz) | -66 dBc | 1.7 ps | FoMJ = -234.6 dB, core area = 0.22 mm2 | frac-N sub-sampling digital PLL (SS-DPLL) | (1) improved DTC nonlinearity |
 | [9] C.-Y. Lin | 5.16 mW/GHz @ 1V (169 nW @ 32.768 kHz) |  | 94.54 ns (Jcc_rms), 529.4 ns (Jcc_pp) | core area = 0.116 mm2 |  |  |
 | [10] N. O. Adesina 这是个特殊工艺，并且功率效率异常的低，有点奇怪 | 0.0010 mW/GHz @ 0.5V (1.91 uW @ 2 GHz) |  |  |  |  |  |
 | [14] T.-S. Chao | 0.38 mW/GHz @ 0.5V (210 uW @ 0.55 GHz) | - | 8.01 ps (Je_rms), 56.36 ps (Je_pp) | core area = 0.017 mm2 |  |  |
 | [17] A. Gundel | 70 mW/GHz @ 5V (7 uW @ 100.013 kHz) | - | 5 ns (Jc_rms) | core area = 0.8 mm2 |  |  |
 | [18] A. Kira et al. | 0.0609 mW/GHz @ 1 V (6.709 uW @ 110.2 MHz) | - | 2.02 ps (estimated from SSB phase noise spectral density) | FoM = , core area =  | CP-PLL | (1) 使用了 dead-zone-free PFD 以提高相噪/抖动性能  (2) 使用了 MEMS-based oscillator 以实现低相噪/抖动的参考信号 | 
 | [19] A. Kira et al. | 0.0609 mW/GHz @ 1 V (6.709 uW @ 110.2 MHz) | - | 2.02 ps (estimated from SSB phase noise spectral density) | FoM = , core area =  | CP-PLL | (1) 使用了 dead-zone-free PFD 以提高相噪/抖动性能  (2) 使用了 MEMS-based oscillator 以实现低相噪/抖动的参考信号 | 
</div>
</span>

<div class='center'>

| [18] A. Kira et al. 的这个 PFD 值得复现试一试 |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-15-22-53-15_临时文件.png"/></div> |  |  |
 |  |
</div>


进一步筛选和整理之后：

<span style='font-size:09px'> 

<div class='center'>

| Paper | Power Efficiency | Ref. Spur | RMS Jitter | 其它参数 | 架构 |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | CICC'14 [1] J.-W. Moon | 0.256 mW/GHz @ 0.4 V (0.13 mW @ 0.5 GHz) | -59 dBc | 16.9 ps (Je_rms) | FoM = -224.3, core area = 0.041 (estimated from die graph) | 经典 CP-PLL, 差分 RVCO  |
 | CICC'20 [2] B. Xiang | 0.213mW/GHz @ 0.8 V (0.682 mW @ 3.2 GHz) | < -90 dBc | 2.3 ps (J_int @ 100 kHz ~ 100 MHz) | FoM = -234.4 dB, core area = 0.015 mm2 | 经典 CP-PLL |
 | S3S'15 [4] M. Faisal | 1.6 mW/GHz @ 0.5 V (300 nW @ 187.5 kHz) <br> 1.1 mW/GHz @ 0.5 V (570 nW @ 500 kHz) <br> 1.266 mW/GHz (435 nW @ 343.75 kHz) (estimated from the reported power consumption at 187.5 kHz and 500 kHz) | -60 dBc | 12.3 ns @ 187.5 kHz <br> 4.7 ns @ 500 kHz <br> 301.4 ns @ 343 kHz (estimated from the SSB phase noise) | FoM = -193.43 dB @ 187.5 kHz, core area = 0.07 mm2 <br> FoM = -199.00 dB @ 500 kHz | ADPLL |
 | TCSI'16 [8] Y.-H. | 0.50 mW/GHz @ 1 V (1.19 mW @ 2.4 GHz) | -66 dBc | 1.7 ps | FoMJ = -234.6 dB, core area = 0.22 mm2 | frac-N sub-sampling digital PLL (SS-DPLL) | 
 | ASSCC'17 [9] C.-Y. Lin | 5.16 mW/GHz @ 1 V (169 nW @ 32.768 kHz) | - | 94.54 ns (Je_rms) | FoM = -178.21 dB (estimated from the reported Jcc_rms), core area = 0.116 mm2 | CP-PLL |
 | ESSCIRC'09 [14] T.-S. Chao | 0.38 mW/GHz @ 0.5 V (210 uW @ 0.55 GHz) | - | 8.01 ps (Je_rms) | FoM = -228.71 dB, core area = 0.017 mm2 | CP-PLL |
 | ISCAS'07 [17] A. Gundel | 70 mW/GHz @ 5 V (7 uW @ 100.013 kHz) | - | 5 ns (Jc_rms) | FoM = -187.57 dB, core area = 0.8 mm2 | CP-PLL |
 | JSSC'14 [19] S. Zaliasl et al. ([9] 的参考文献) | 8.8501 mW/GHz @ 1.2 V (290 nW @ 32.768 kHz) | - | 235 ns (estimated Je_rms from the reported LTJ_pp) <br> 0.7 ns (long-term jitter) | FoM = -167.95 dB (calc. from the estimated Je_rms), core area = 0.3 mm2 | CP-PLL |
 | ISSCC'23 [20] Z. Zhang (组内文献) | 0.22 mW/GHz @ 0.35 V (0.55 mW @ 2.5 GHz) | -78.1 dBc |  375 fs  | FoM = -251.1 dB, core area = 0.197 mm2 | SS-PLL |
 | VLSIC'19 [21] Z. Zhang (组内文献) | 0.048 mW/GHz @ 0.25 V (0.0095 mW @ 0.2 GHz) | -48.5 dBc |  147.2 ps | FoM = -216.9 dB, core area = 0.009 mm2 | DP-CP-PLL |
 | ISSCC'19 [22] Z. Zhang (组内文献) | 0.5143 mW/GHz @ 0.65 V (7.2 mW @ 14 GHz) | -64.6 | 56.4 fs | FoM = - 256.4 dB, core area = 0.234 mm2 | SS-PLL |
 | ISSCC'25 [23] X. Shen (组内文献)  | 1.3048 mW/GHz @ 0.65 V (13.7 mW @ 10.5 GHz) | -72.9 | 73.8 fs | FoM = - 251.3 dB, core area = 0.27 mm2 | S-PLL |
 | TCSI'19 [24] Z. Zhang (组内文献) | 0.685 mW/GHz @ 0.95 V (13.7 mW @ 20 GHz) | NA | 57.4 fs | FoM = -253.5 dB, core area = 0.462 mm2 | SIL-ADPLL |

<!--  | [18] A. Kira et al. | 0.0609 mW/GHz @ 1 V (6.709 uW @ 110.2 MHz) | -135 dBc (estimated) | 1.94 ps (estimated Jint_rms from SSB phase noise spectral density) | FoM = -255.63 dB, core area = 0.110 mm2 | CP-PLL | -->
</div>
</span>

``` bash
str_matrix = [
% Name, Architecture, Cite_name
"This Work (X03)"   "CP-PLL"    ""
"This Work (X24)"   "CP-PLL"    ""
"[1] CICC'14"       "CP-PLL"    "\cite{Moon_2014_04V500MHzUltralowpower}           "
"[2] CICC'20"       "CP-PLL"    "\cite{Xiang_2020_05Vto09V02GHzto5GHzUltraLowPower}"
"[4] S3S'15"        "AD-PLL"    "\cite{Faisal_2015_300nWNearthreshold1875500}      "
"[8] TCSI'16"       "SS-DPLL"   "\cite{Liu_2017_UltraLowPower1727}                 "
"[9] ASSCC'17"      "CP-PLL"    "\cite{Lin_2017_UltralowPower169nA}                "
"[14] ESSCIRC'09"   "CP-PLL"    "\cite{Chao_2009_DesigningUltralowVoltage}         "
"[17] ISCAS'07"     "CP-PLL"    "\cite{Gundel_2007_UltraLowPower}                  "
"[19] JSSC'14"      "CP-PLL"    "\cite{Zaliasl_2015_3Ppm15}                        "
"[20] ISSCC'23"     "SS-PLL"    "\cite{Zhang_2023_04VVDD225to275GHzULVSSPLL}       "
"[21] VLSIC'19"     "DP-CP-PLL" "\cite{Zhang_2019_02504VSub011mWGHz}               "
"[22] ISSCC'19"     "SS-PLL"    "\cite{Zhang_2019_065V12to16GHzSubSampling}        "
"[23] ISSCC'25"     "S-PLL"     "\cite{Shen_2025_065VVDD104to118GHzFractionalN}    "
"[24] TCSI'19"      "SIL-ADPLL" "\cite{Zhang_2019_1823GHz574fs}                    "
];

\begin{tabular}{ccccccccccccccccc}\toprule
    Parameter 
    & {\color{red}\bfseries This Work (X03)} 
    & \cite{Moon_2014_04V500MHzUltralowpower}               CICC'14 
    & \cite{Xiang_2020_05Vto09V02GHzto5GHzUltraLowPower}    CICC'20 
    & \cite{Faisal_2015_300nWNearthreshold1875500}          S3S'15
    & \cite{Liu_2017_UltraLowPower1727}                     TCSI'16
    & \cite{Lin_2017_UltralowPower169nA}                    ASSCC'17
    & \cite{Chao_2009_DesigningUltralowVoltage}             ESSCIRC'09
    & \cite{Gundel_2007_UltraLowPower}                      ISCAS'07
    & \cite{Zaliasl_2015_3Ppm15}                            JSSC'14
    % 下面五篇是组内文献
    & \cite{Zhang_2023_04VVDD225to275GHzULVSSPLL}           ISSCC'23
    & \cite{Zhang_2019_02504VSub011mWGHz}                   VLSIC'19
    & \cite{Zhang_2019_065V12to16GHzSubSampling}            ISSCC'19
    & \cite{Shen_2025_065VVDD104to118GHzFractionalN}        ISSCC'25
    & \cite{Zhang_2019_1823GHz574fs}                        TCSI'19
    \\
    \midrule
    Architecture                &  &   \\
    Output Frequency $f_{out}$  &  &   \\
    Current Efficiency $I_{eff}$&  &   \\
    Power Efficiency $P_{eff}$  &  &   \\
    Supply Voltage $V_{DD}$     &  &   \\
    RMS Jitter $J_{rms}$        &  &   \\
    FoM$_J$                     &  &   \\
    Core Area                   &  &   \\
    Reference Spur              &  &   \\
    \bottomrule
\end{tabular}










str_matrix = [
% Name, Architecture, Cite_name
"This Work (X03)"   "CP-PLL"    ""
"This Work (X24)"   "CP-PLL"    ""
"CICC'14"       "CP-PLL"    "\cite{Moon_2014_04V500MHzUltralowpower}           "
"CICC'20"       "CP-PLL"    "\cite{Xiang_2020_05Vto09V02GHzto5GHzUltraLowPower}"
"S3S'15"        "AD-PLL"    "\cite{Faisal_2015_300nWNearthreshold1875500}      "
"TCSI'16"       "SS-DPLL"   "\cite{Liu_2017_UltraLowPower1727}                 "
"ASSCC'17"      "CP-PLL"    "\cite{Lin_2017_UltralowPower169nA}                "
"ESSCIRC'09"   "CP-PLL"    "\cite{Chao_2009_DesigningUltralowVoltage}         "
"ISCAS'07"     "CP-PLL"    "\cite{Gundel_2007_UltraLowPower}                  "
"JSSC'14"      "CP-PLL"    "\cite{Zaliasl_2015_3Ppm15}                        "
"ISSCC'23"     "SS-PLL"    "\cite{Zhang_2023_04VVDD225to275GHzULVSSPLL}       "
"VLSIC'19"     "DP-CP-PLL" "\cite{Zhang_2019_02504VSub011mWGHz}               "
"ISSCC'19"     "SS-PLL"    "\cite{Zhang_2019_065V12to16GHzSubSampling}        "
"ISSCC'25"     "S-PLL"     "\cite{Shen_2025_065VVDD104to118GHzFractionalN}    "
"TCSI'19"      "SIL-ADPLL" "\cite{Zhang_2019_1823GHz574fs}                    "
];

\begin{tabular}{ccccccccccccccccc}\toprule
    \midrule
    Work                                    & \\
    Architecture                            & \\
    Output Frequency $f_{out}$ (kHz)        & \\
    Current Efficiency $I_{eff}$ (nA/kHz)   & \\
    Power Efficiency $P_{eff}$ (nW/kHz)     & \\
    Supply Voltage $V_{DD}$ (V)             & \\
    RMS Jitter $J_{rms}$ (ps)               & \\
    FoM$_J$ (dB)                            & \\
    Core Area (mm$^2$)                      & \\
    Reference Spur (dBc)                     & \\
    \bottomrule
\end{tabular}



str_matrix = [
% Name (用于作图), Architecture, export_name
"This Work (X03)"   "CP-PLL"    "This Work (X03)"
"This Work (X24)"   "CP-PLL"    "This Work (X24)"
"[99] CICC'14"      "CP-PLL"    "\cite{Moon_2014_04V500MHzUltralowpower} CICC'14"
"[99] CICC'20"      "CP-PLL"    "\cite{Xiang_2020_05Vto09V02GHzto5GHzUltraLowPower} CICC'20"
"S3S'15"            "AD-PLL"    "\cite{Faisal_2015_300nWNearthreshold1875500} S3S'15"
"TCSI'16"           "SS-DPLL"   "\cite{Liu_2017_UltraLowPower1727} TCSI'16"
"ASSCC'17"          "CP-PLL"    "\cite{Lin_2017_UltralowPower169nA} ASSCC'17"
"ESSCIRC'09"        "CP-PLL"    "\cite{Chao_2009_DesigningUltralowVoltage} ESSCIRC'09"
"ISCAS'07"          "CP-PLL"    "\cite{Gundel_2007_UltraLowPower} ISCAS'07"
"JSSC'14"           "CP-PLL"    "\cite{Zaliasl_2015_3Ppm15} JSSC'14"
"ISSCC'23"          "SS-PLL"    "\cite{Zhang_2023_04VVDD225to275GHzULVSSPLL} ISSCC'23"
"VLSIC'19"          "DP-CP-PLL" "\cite{Zhang_2019_02504VSub011mWGHz} VLSIC'19"
"ISSCC'19"          "SS-PLL"    "\cite{Zhang_2019_065V12to16GHzSubSampling} ISSCC'19"
"ISSCC'25"          "S-PLL"     "\cite{Shen_2025_065VVDD104to118GHzFractionalN} ISSCC'25"
"TCSI'19"           "SIL-ADPLL" "\cite{Zhang_2019_1823GHz574fs} TCSI'19"
];


\begin{tabular}{cccccccccccccccccccc}\bottomrule\toprule
    Work                                    & 
    Architecture                            & 
    Output Frequency $f_{out}$ (kHz)        & 
    Current Consumption $I_{DD}$ (nA)       & 
    Current Efficiency $I_{eff}$ (nA/kHz)   & 
    Power Efficiency $P_{eff}$ (nW/kHz)     & 
    Supply Voltage $V_{DD}$ (V)             & 
    RMS Jitter $J_{rms}$ (ps)               & 
    FoM$_{J}$ (dB)                          & 
    FoM$_{JA}$ (dB)                         & 
    Core Area (mm$^2$)                      & 
    Reference Spur (dBc)                    & 
    \bottomrule\toprule
\end{tabular}



```


注：下面的文献仅用于指标性能对比，与总项目中参考文献标号无关。
- [1] J.-W. Moon, S.-G. Kim, D.-H. Kwon, and W.-Y. Choi, “A 0.4-V, 500-MHz, ultra-low-power phase-locked loop for near-threshold voltage operation,” in Proceedings of the IEEE 2014 Custom Integrated Circuits Conference, Sept. 2014, pp. 1–4. doi: 10.1109/CICC.2014.6946100.
- [2] B. Xiang, Y. Fan, J. Ayers, J. Shen, and D. Zhang, “A 0.5V-to-0.9V 0.2GHz-to-5GHz Ultra-Low-Power Digitally-Assisted Analog Ring PLL with Less Than 200ns Lock Time in 22nm FinFET CMOS Technology,” in 2020 IEEE Custom Integrated Circuits Conference (CICC), Mar. 2020, pp. 1–4. doi: 10.1109/CICC48029.2020.9075897.
- [3] W. Wu et al., “A 14-nm Ultra-Low Jitter Fractional-N PLL Using a DTC Range Reduction Technique and a Reconfigurable Dual-Core VCO,” IEEE Journal of Solid-State Circuits, vol. 56, no. 12, pp. 3756–3767, Dec. 2021, doi: 10.1109/JSSC.2021.3111134.
- [4] M. Faisal, N. E. Roberts, and D. D. Wentzloff, “A 300nW near-threshold 187.5–500 kHz programmable clock generator for ultra low power SoCs,” in 2015 IEEE SOI-3D-Subthreshold Microelectronics Technology Unified Conference (S3S), Oct. 2015, pp. 1–3. doi: 10.1109/S3S.2015.7333528.
- [5] S. Schober and J. Choma, “A charge transfer-based high performance, ultra-low power PLL charge pump,” in 2015 IEEE 6th Latin American Symposium on Circuits & Systems (LASCAS), Montevideo, Uruguay: IEEE, Feb. 2015, pp. 1–4. doi: 10.1109/LASCAS.2015.7250412.
- [6] S. K. Saw and V. Nath, “A low power low noise current starved CMOS VCO for PLL,” in Communication & Automation International Conference on Computing, May 2015, pp. 1252–1255. doi: 10.1109/CCAA.2015.7148611.
- [7] B. Ghafari, L. Koushaeian, and F. Goodarzy, “An ultra low power and small size PLL for wearable and implantable medical sensors,” in 2012 IEEE Consumer Communications and Networking Conference (CCNC), Jan. 2012, pp. 409–412. doi: 10.1109/CCNC.2012.6181026.
- [8] Y.-H. Liu et al., “An Ultra-Low Power 1.7-2.7 GHz Fractional-N Sub-Sampling Digital Frequency Synthesizer and Modulator for IoT Applications in 40 nm CMOS,” IEEE Transactions on Circuits and Systems I: Regular Papers, vol. 64, no. 5, pp. 1094–1105, May 2017, doi: 10.1109/TCSI.2016.2625462.
- [9] C.-Y. Lin, T.-J. Wang, T.-H. Liu, and T.-H. Lin, “An ultra-low power 169-nA 32.768-kHz fractional-N PLL,” in 2017 IEEE Asian Solid-State Circuits Conference (A-SSCC), Nov. 2017, pp. 45–48. doi: 10.1109/ASSCC.2017.8240212.
- [10] N. O. Adesina, A. Srivastava, A. Ullah Khan, and J. Xu, “An Ultra-Low Power MOS2 Tunnel Field Effect Transistor PLL Design for IoT Applications,” in 2021 IEEE International IOT, Electronics and Mechatronics Conference (IEMTRONICS), Apr. 2021, pp. 1–6. doi: 10.1109/IEMTRONICS52119.2021.9422641.
- [11] S. Chakraborty et al., “An ultra-low power, low-cost, multi-standard transceiver,” in 2015 Texas Symposium on Wireless and Microwave Circuits and Systems (WMCS), Apr. 2015, pp. 1–5. doi: 10.1109/WMCaS.2015.7233220.
- [12] N. van Helleputte and G. Gielen, “An Ultra-low-Power Quadrature PLL in 130nm CMOS for Impulse Radio Receivers,” in 2007 IEEE Biomedical Circuits and Systems Conference, Nov. 2007, pp. 63–66. doi: 10.1109/BIOCAS.2007.4463309.
- [13] T. Alam, T. H. Saika, T. Tanjil Hossain, and S. Nishat, “Design and Optimization of an Area Efficient Ultra-Low Voltage Differential Ring VCO with Wide Tuning Range for PLL Applications,” in 2023 26th International Conference on Computer and Information Technology (ICCIT), Dec. 2023, pp. 1–6. doi: 10.1109/ICCIT60459.2023.10441252.
- [14] T.-S. Chao, Y.-L. Lo, W.-B. Yang, and K.-H. Cheng, “Designing ultra-low voltage PLL Using a bulk-driven technique,” in 2009 Proceedings of ESSCIRC, Sept. 2009, pp. 388–391. doi: 10.1109/ESSCIRC.2009.5325983.
- [15] B. Ghafari, L. Koushaeian, and F. Goodarzy, “New architecture for an ultra low power and low noise PLL for biomedical applications,” in 2013 IEEE Global High Tech Congress on Electronics, Nov. 2013, pp. 61–62. doi: 10.1109/GHTCE.2013.6767241.
- [16] S. K. Saw and V. Nath, “Performance Analysis of Low Power CSVCO for PLL Architecture,” in 2015 Second International Conference on Advances in Computing and Communication Engineering, May 2015, pp. 370–373. doi: 10.1109/ICACCE.2015.101.
- [17] A. Gundel and W. N. Carr, “Ultra Low Power CMOS PLL Clock Synthesizer for Wireless Sensor Nodes,” in 2007 IEEE International Symposium on Circuits and Systems (ISCAS), May 2007, pp. 3059–3062. doi: 10.1109/ISCAS.2007.378054.
- [18] A. Kira et al., “A 6.7 μW Low-Noise, Compact PLL with an Input MEMS-Based Reference Oscillator Featuring a High-Resolution Dead/Blind Zone-Free PFD,” Sensors, vol. 24, no. 24, Dec. 2024, doi: 10.3390/s24247963.
- [19] S. Zaliasl et al., “A 3 ppm 1.5 × 0.8 mm 2 1.0 µA 32.768 kHz MEMS-Based Oscillator,” IEEE Journal of Solid-State Circuits, vol. 50, no. 1, pp. 291–302, Jan. 2015, doi: 10.1109/JSSC.2014.2360377.
下面几篇是我们组的部分文献，用作 state-of-art 参考：
- [20] Z. Zhang et al., “A 0.4V-VDD 2.25-to-2.75GHz ULV-SS-PLL Achieving 236.6fsrms Jitter, −253.8dB Jitter-Power FoM, and −76.1dBc Reference Spur,” in 2023 IEEE International Solid- State Circuits Conference (ISSCC), San Francisco, CA, USA: IEEE, Feb. 2023, pp. 86–88. doi: 10.1109/ISSCC42615.2023.10067638.
- [21] Z. Zhang, G. Zhu, and C. P. Yue, “A 0.25-0.4-V, Sub-0.11-mW/GHz, 0.15-1.6-GHz PLL Using an Offset Dual-Path Loop Architecture with Dynamic Charge Pumps,” in 2019 Symposium on VLSI Circuits, June 2019, pp. C158–C159. doi: 10.23919/VLSIC.2019.8778061.
- [22] Z. Zhang, G. Zhu, and C. P. Yue, “A 0.65V 12-to-16GHz Sub-Sampling PLL with 56.4fsrms Integrated Jitter and -256.4dB FoM,” in 2019 IEEE International Solid- State Circuits Conference - (ISSCC), San Francisco, CA, USA: IEEE, Feb. 2019, pp. 488–490. doi: 10.1109/ISSCC.2019.8662378.
- [23] X. Shen et al., “A 0.65V-VDD 10.4-to-11.8GHz Fractional-N Sampling PLL Achieving 73.8fsrms Jitter, -271.5dB FoMN, and -61 dBc in-Band Fractional Spur in 40nm CMOS,” in 2025 IEEE International Solid-State Circuits Conference (ISSCC), San Francisco, CA, USA: IEEE, Feb. 2025, pp. 1–3. doi: 10.1109/ISSCC49661.2025.10904612.
- [24] Z. Zhang et al., “An 18–23 GHz 57.4-fs RMS Jitter −253.5-dB FoM Sub-Harmonically Injection-Locked All-Digital PLL With Single-Ended Injection Technique and ILFD Aided Adaptive Injection Timing Alignment Technique,” IEEE Trans. Circuits Syst. I, vol. 66, no. 10, pp. 3733–3746, Oct. 2019, doi: 10.1109/TCSI.2019.2911531.




### 7.5 summary and comparison


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-16-22-10-02_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div>

**记得给出功耗分布饼图：**


## 8. Simulation with Digital LDO

这一小节我们代入需求方提供的数字 LDO 进行联合仿真。

<div class='center'>

| 联合仿真结果 |
|:-:|:-:|:-:|
 | 先看一下需求方提供的数字 LDO 的仿真结果 (LDO schematic, Spectre X + CX)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-16-22-04-27_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 然后将 LDO 和 PLL 联合起来仿真，考虑到仿真时长，仅使用 schematic of LDO and PLL  |
</div>


vref 被 enable 之前，仿真是很快的；但 vref 被 enable 之后，仿真耗时大约 35ms/h @ Spectre FX + AX (8-thread)。于是推荐：
- Spectre FX + AX (8-thread)：设置 (延迟 5ms 是为了达到稳态)
    - vref_delay = 700m
    - settling_begin = vref_delay + 5m
    - time_end = settling_begin + 200m
    - 仿真耗时约 5min + 6h
- Spectre X + CX (8-thread)：设置 (延迟 5ms 是为了达到稳态)
    - vref_delay = 700m
    - settling_begin = vref_delay + 5m
    - time_end = settling_begin + 10m
    - 仿真耗时约 10min + 7h

经过测试，发现将总仿真时间拉长时，仿真精度会明显降低 (平均步长增加)，导致仿出来的结果和预期不符 (Spectre FX + AX 是这样，X + CX 还没试过)。


### 8.0 transient operation points



另起一个 test 命名为 `TB_PLL_withDigitalLDO_forTranOP`，在 `tran > Option > state file > savetime` 中设置好保存时间为 `500m, 700m`，可以看到仿真过程中保存了瞬态工作点：

``` bash
# ......
  491.00 ms / 700.00 ms (70.14%)  # of steps: 278159 time spent: 00:03:54  time left: 00:01:39  CPU: 796.06%  mem: 184.184 MB
  497.00 ms / 700.00 ms (71.00%)  # of steps: 281659 time spent: 00:03:57  time left: 00:01:36  CPU: 796.06%  mem: 184.191 MB
Saving the states into file at t=500 ms...
State File: ./input.scs.tran.srf_at_500.00ms.
  505.00 ms / 700.00 ms (72.14%)  # of steps: 286946 time spent: 00:04:02  time left: 00:01:33  CPU: 796.11%  mem: 184.688 MB
  512.98 ms / 700.00 ms (73.28%)  # of steps: 291556 time spent: 00:04:06  time left: 00:01:29  CPU: 796.07%  mem: 184.723 MB
  519.75 ms / 700.00 ms (74.25%)  # of steps: 295655 time spent: 00:04:10  time left: 00:01:26  CPU: 796.00%  mem: 184.734 MB
# ......
# ......
  695.00 ms / 700.00 ms (99.29%)  # of steps: 398924 time spent: 00:05:43  time left: 00:00:02  CPU: 796.04%  mem: 185.25 MB
Saving the states into file at t=700 ms...
State File: ./input.scs.tran.srf_at_700.00ms.
# ......
```

然后到原来的仿真中，设置 `tran > Option > recovery` 为刚刚保存的瞬态工作点，这里以 700ms 的瞬态工作点为例，文件路径为：
``` bash
# 注意下面的 /4 对应 all_load8 的结果 (BUF 被使能)
/home/dy2025/Desktop/Work/simulation/MyLib_202510_PLL_onc18/TB_PLL_withDigitalLDO/maestro/results/maestro/Interactive.286/4/TB_PLL_withDigitalLDO_forTranOP_SpectreFXAX/netlist/input.scs.tran.srf_at_700.00ms
```

设置好仿真结束时间 (总的时间，包含之前的 700ms)，这里以 710ms 为例，运行仿真，可以看到仿真是从 700ms 开始的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-17-14-59-18_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div>

recovery 文件相当于设置了一个初始状态，在开始瞬态之前仿真器会先给一个收敛的 DC 结果，然后再开始瞬态仿真，但仿出来发现这个 DC 结果明显错误，如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-17-15-17-54_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div>

遂改为 Spextre X + CX 重新尝试一遍，先仿瞬态工作点 (vref disabled)：从 15:20 到 15:30 只仿了 1.035 ms (148 m%)，这样算下来要仿完大约需要 112.6h (4.7 days)，实在是太久了。于是无奈在 tb schematic 中将 PLL 和 white_noise disable 掉，只仿 LDO 的瞬态工作点。具体而言：
- (1) 设置仿真模式为 Spectre X + CX (8-thread)
- (2) 在 tb schematic 中将 PLL 和 white_noise disable 掉
- (3) 设置 fnoise_max = 1 MHz 以提高仿真速度 (增加仿真步长)

保存的瞬态工作点路径为：
``` bash
# Interactive.292
/home/dy2025/Desktop/Work/simulation/MyLib_202510_PLL_onc18/TB_PLL_withDigitalLDO/maestro/results/maestro/Interactive.292/4/TB_PLL_withDigitalLDO_forTranOP_SpectreXCX/netlist/input.scs.tran.srf_at_700.00ms
```

然后将其它的器件 enable 回来，设置 recovery 文件为刚刚保存的瞬态工作点，修改仿真结束时间进行仿真，却警告说 “恢复失败”：

``` bash
*************************************************
Transient Analysis `tran': time = (0 s -> 715 ms)
*************************************************
Recovering from save-restart file /data/Work_dy2025/simulation/MyLib_202510_PLL_onc18/TB_PLL_withDigitalLDO/maestro/results/maestro/Interactive.292/4/TB_PLL_withDigitalLDO_forTranOP_SpectreXCX/netlist/input.scs.tran.srf_at_700.00ms,

Warning from spectre during transient analysis `tran'.
    WARNING (SPECTRE-4076): The circuit information has changed since the last savestate, which is not allowed. Use the checkpoint feature to restore the circuit to the last saved state.
    WARNING (SPECTRE-16532): Failed to recover from /data/Work_dy2025/simulation/MyLib_202510_PLL_onc18/TB_PLL_withDigitalLDO/maestro/results/maestro/Interactive.292/4/TB_PLL_withDigitalLDO_forTranOP_SpectreXCX/netlist/input.scs.tran.srf_at_700.00ms due to error in file or the reloaded ckt is different from the ckt when saved.
```

无奈，又回去重新仿真瞬态工作点：
- (1) 设置仿真模式为 Spectre X + CX (8-thread)
- (2) 在 tb schematic 中所有用到的器件全部 enable 回来
- (3) 设置 fnoise_max = 1 MHz (or 0.1 MHz) 以提高仿真速度
保存的瞬态工作点路径为：
``` bash
# Interactive.298
/data/Work_dy2025/simulation/MyLib_202510_PLL_onc18/TB_PLL_withDigitalLDO/maestro/results/maestro/Interactive.298/4/TB_PLL_withDigitalLDO_forTranOP_SpectreXCX/netlist/input.scs.tran.srf_at_700.00ms
```

遇到了仿真不收敛的问题：

``` bash

*************************************************
Transient Analysis `tran': time = (0 s -> 710 ms)
*************************************************
Recovering from save-restart file /data/Work_dy2025/simulation/MyLib_202510_PLL_onc18/TB_PLL_withDigitalLDO/maestro/results/maestro/Interactive.298/5/TB_PLL_withDigitalLDO_forTranOP_SpectreXCX/netlist/input.scs.tran.srf_at_700.00ms,
Restarting at time 700 ms.

Opening the PSFXL file ../psf/tran.tran.tran ...
Important parameter values:
    start = 0 s
    outputstart = 0 s
    stop = 710 ms
    step = 710 us
    maxstep = 7.1 ms
    minstep = 100 as
    ic = all
    useprevic = no
    skipdc = no
    reltol = 100e-06
    abstol(V) = 1 uV
    abstol(I) = 1 pA
    abstol(Temp) = 100 uC
    abstol(Pwr) = 1 nW
    temp = 27 C
    tnom = 27 C
    tempeffects = all
    errpreset = conservative_sigglobal
    method = gear2only
    lteratio = 10
    relref = sigglobal
    cmin = 0 F
    gmin = 1 pS
    rabsshort = 1 mOhm
    trannoisemethod = default
    noisefmax = 100 MHz
    noisefmin = 1.40845 Hz
    noiseseed = 1


Warning from spectre during transient analysis `tran'.
    WARNING (CMI-2732): I0.I92.R1.R0.r_noise:  Resistance= 9.998528e+12 has exceeded rcut=1.000000e+12 and will be cut to 1.000000e+12. 
    WARNING (CMI-2732): I1.R17.r_noise:  Resistance= 1.070437e+12 has exceeded rcut=1.000000e+12 and will be cut to 1.000000e+12. 
    WARNING (CMI-2732): I1.R1.r_noise:  Resistance= 2.143550e+13 has exceeded rcut=1.000000e+12 and will be cut to 1.000000e+12. 
    WARNING (CMI-2732): I1.R18.r_noise:  Resistance= 3.131028e+12 has exceeded rcut=1.000000e+12 and will be cut to 1.000000e+12. 
    WARNING (CMI-2732): I1.R0.r_noise:  Resistance= 3.853573e+12 has exceeded rcut=1.000000e+12 and will be cut to 1.000000e+12. 
        Further occurrences of this warning will be suppressed.


Output and IC/nodeset summary:
                 save   31      (current)
                 save   51      (voltage)

    tran: time = 700 ms      (98.6 %), step = 700 ms       (98.6 %)

Notice from spectre at time = 700 ms during transient analysis `tran'.
    Newton iteration fails to converge at time = 700 ms step = 19.984 fs.
        Disaster recovery algorithm is enabled to search for a converged solution.
Error found by spectre at time = 701.311 ms during transient analysis `tran'.
    ERROR (SPECTRE-16192): No convergence achieved with the minimum time step specified.  
```

日志中给出了下面几条改进建议：
``` bash
The following set of suggestions might help you avoid convergence difficulties.  

 1. Enable diagnostic messages using the `+diagnose' option.

 2. Evaluate and resolve any notice, warning, or error messages.
 3. Use realistic device models. Check all component parameters, particularly nonlinear device model parameters, to ensure that they are reasonable.
 4. Small floating resistors connected to high impedance nodes can cause convergence difficulties. Avoid very small floating resistors, particularly small parasitic resistors in semiconductors. Instead, use voltage sources or iprobes to measure current.
 5. Ensure that a complete set of parasitic capacitors is used on nonlinear devices to avoid jumps in the solution waveforms. On MOS models, specify nonzero source and drain areas.
 6. Perform sanity check on the parameter values by using the parameter range checker (use ``+param param-limits-file'' as a command line argument) and heed any warnings.  Print the minimum and maximum parameter value by using `info' analysis.  Ensure that the bounds given for instance, model, output, temperature-dependent, and operating-point (if possible) parameters are reasonable.

 7. Check the direction of both independent and dependent current sources. Convergence problems might result if current sources are connected such that they force current backward through diodes.
 8. Use the `cmin' parameter to install a small capacitor from every node in the circuit to ground.  This usually eliminates any jump in the solution.
 9. Loosen tolerances, particularly absolute tolerances like `iabstol' (on options statement). If tolerances are set too tight, they might preclude convergence.
10. Try to simplify the nonlinear component models to avoid regions that might contribute to convergence problems in the model.

```

然后是网上的一些方法：
- [cadence virtuoso 仿真不收敛的几种解决方法](https://www.bilibili.com/opus/965887928148426791)：(1) minstep越小越容易收敛; (2) 换算法or改变迭代次数，可以试试 gear2only或者其它的算法，再或者修改迭代次数，但是增大迭代次数可能会让仿真变得很慢。

尝试了多种方法，没能解决。于是考虑用 APS 而不是 Spectre X + CX 来仿，因为这样可以修改 DC 收敛算法 (比如 gear2only) 和迭代次数，Spectre X 是不能修改这些参数的。瞬态工作点仿真设置如下：
- (1) 设置仿真模式为 APS (8-thread)
- (2) 在 tb schematic 中所有用到的器件全部 enable 回来
- (3) 设置 fnoise_max = 1 MHz (or 0.1 MHz) 以提高仿真速度
保存的瞬态工作点路径为：
``` bash
# Interactive.311
/data/Work_dy2025/simulation/MyLib_202510_PLL_onc18/TB_PLL_withDigitalLDO/maestro/results/maestro/Interactive.311/4/TB_PLL_withDigitalLDO_forTranOP_APS/netlist/input.scs.tran.srf_at_700.00ms
```

还是不收敛，没办法了，只能直接长时间仿真了。

### 8.1 Spectre X + CX 仿真结果

仿真设置：
- (1) 设置仿真模式为 Spectre X + CX (16-thread)
- (2) 仿真时长：
    - vref_delay = 700m
    - settling_begin = vref_delay + 5m
    - time_end = settling_begin + 20m (稳定后再多仿 15ms)
- (3) 瞬态噪声 (仿真精度): fnoise_max = 1 MHz (无法实现 100 MHz 因为仿真时间太长)
- (4) Corner 设置：
    - all_load8
    - TT +27°

19:32 开始，约 20:36 (1h) 时到 700ms 处，开始进入锁相环的仿真，然后又到 22:52:21 才仿完，共耗时 1h + 2h 20m = 3h 20m. 仿真结果如下：

<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | 结果总览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-17-23-09-50_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |  |
 | EN_BUF = 0 @ (TT, 27°C) 时： | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-17-23-04-31_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-17-23-05-47_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 下图之所以 Std. Dev. 达到 80 ns, 是因为在 VDD 突变时引起了大抖动 (详见右图) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-17-22-53-53_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-17-22-55-34_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |
 | EN_BUF = 1 @ (TT, 27°C) 时： <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-17-22-57-58_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-17-23-00-05_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-17-23-02-54_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |  |  |
</div>

### 8.2 Spectre X + CX 长时间仿真

延长仿真时间到 750ms (700 ms 接入，705 ms 稳定，然后再多仿 45 ms)，仿真设置和结果如下：
- (1) 设置仿真模式为 Spectre X + CX @ 16-thread (2-job parallel)
- (2) 瞬态噪声 (仿真精度): fnoise_max = 2 MHz
- (3) Corner 设置：
    - all_load8 (EN_BUF = 1, CL1 = 80 fF, CL2 = 30 pF)
    - TT +27° (EN_BUF = 0, CL1 = 40 fF, CL2 = 30 pF)
- (4) 仿真时长：
    - vref_delay = 700m
    - settling_begin = vref_delay + 5m
    - time_end = vref_delay + 50m (稳定后再多仿 45ms)

<div class='center'>

| 仿真耗时 10h 50m 59s @ 16-thread (2-job parallel) |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-20-22-52-12_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
 | 这边有个问题就是，需求方的这个电源，输出纹波会使 VDD 突变 +60 mV 左右，这个 60 mV 实在太大，导致每出现一次纹波，我们的锁相环输出频率就会波动一次，然后在 180 us 内重归稳定。在电源轻载模式下（比如引到 PAD 的两路被 disable），这个纹波间隔在 64.3 ms 左右 (15.5 Hz)。这么大的间隔，对输出频率的影响其实不大。但是在电源重载模式（比如 enable 引到 PAD 的两路输出），这个纹波间隔会缩短到 2 ms (0.5 kHz)，尽管每次波动之后输出频率很快就会锁回来 (180 us 内)，但频繁的纹波会导出输出频率不那么好看，如下图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-19-00-58-38_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
</div>


### 8.3 电源上升纹波导致的输出频率波动问题

下面是一个给导这边拿去和需求方 battlle 的问题说明文档，记录了电源充电纹波导致输出频率波动的问题。

>注：本小节内容除在下面已有外，还另外整理成了一个文档提交给导师用于分析讨论，详见 [202510_onc18_CPPLL_ultra_low_lower (docs-1) 2025.11.13 PLL 性能评估结果 (Digital 1.25V or 0.625V)](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (docs-1) 2025.11.13 PLL 性能评估结果 (Digital 1.25V or 0.625V).md>).

### 电源上升纹波导致的输出频率波动问题

#### 1. 问题现象描述

在锁相环和数字电源联合仿真时，发现电源充电时纹波突变过大 (约 +60 mV)，这会使输出频率出现明显波动，然后在 180 us 内重新稳定。并且，由电源的工作原理容易知道，平均输出电流与充电纹波频率成正比，所以这个频率波动现象在重载时更为明显 (比如 enable 了引到 PAD 的两路输出时)。

具体而言，当前数字电源的工作原理是：当输出电压低于 1.25 V 时 (比如 1.235 V)，内部电路开启，给电源输出端大电容 (uF-level) 充电，直到输出电压达到 1.31 V 左右，停止充电。这个过程带来了 +50 mV ~ +70 mV 的输出电压突变，尽管我们已经使用了 VDD-referenced LPF 和 VDD-referenced VCO 来抑制电源波动对输出频率的影响，但 50 mV ~ 70 mV 的突变还是足以让输出频率出现明显波动。

下图是一个具体的例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-19-01-28-46_临时文件.png"/></div><br><br>

图中可以看到，在接入锁相环之后 (enable 了 big BUF，模拟测试时的电流消耗)，电源的充电纹波间隔缩小到 2ms, 导致输出频率每 2ms 出现一次明显波动，尽管 180 us 内能重新稳定下来，但频繁的波动为测试带来了不便。

使用 VDD-referenced LPF/VCO，是为了让锁相环中 VCO 的控制电压 "`vcont` 紧紧跟随 VDD"，使得这俩的差值基本不变，这样能充分抑制电源波动对输出频率的影响。但别忘了从 vcont 到 GND 之间的电压差也会影响 VCO 输出频率。下图是一个例子，说明了频率波动的直接原因是 "VCO 控制电压 vcont 到 GND 之间的电压差值突变过大"。毕竟 50 mV ~ 70 mV 已经较大，足以使 VCO 频率发生明显变化：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-19-01-31-08_临时文件.png"/></div><br><br>

最后给出每次频率波动的具体变化情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-19-01-41-03_临时文件.png"/></div><br><br>

可以看到，输出通道 `CK_OUT` (当前频率设置为 X24) 的频率在 720.9 kHz ~ 843.0 kHz 之间波动，也即 **<span style='color:red'> -8.33% ~ +7.193% </span>**，并 **<span style='color:red'> 在 180 us 内重新稳定下来 </span>**；而另一路输出 `CK_ADC` (频率固定为 X03) 的频率在 92.36 kHz ~ 104.6 kHz 之间波动，也即 **<span style='color:red'> -6.05% ~ +6.40% </span>**，同样在 180 us 内重新稳定下来。




#### 2. 问题细节补充

问：电源的上升纹波是怎么来的，重载模式是什么意思？
- 答：这个数字电源，大概是根据 "`当输出电压低于 1.25 V 时 (比如 1.235 V)，内部电路开启，给电源输出端大电容 (uF-level) 充电，直到输出电压达到 1.31 V 左右，停止充电`" 的原理来工作的。那么在输出端电容不变的情况下，平均消耗电流越大，电压下降得越快，充电越频繁，纹波就越密集。

问：enable 了 big BUF 时是这样，那么 disable big BUF 时的输出频率如何？
- 答：disable 了 big BUF 时，由于整个锁相环仅消耗 465 nA 电流 (空载)，电源电压下降得非常慢，即便 TB 中多消耗了 1uA 电流 (总共 1.465 uA)，充电间隔也能维持在 60 ms 以上，这么大的间隔并不会对输出频率造成明显影响 (因为频率波动间隔远大于 180 us 的稳定时间)，也基本不会影响后级使用锁相环输出时钟的数字电路正常工作 (具体有没有影响，还需进一步确认)。
- <span style='color:red'> 注：无论有没有 enable big BUF，联合仿真下的锁相环输出性能都与单独仿真时一致 (包括功耗和抖动等)，仅是频率受电源纹波影响出现波动而已。 </span>


问：可能的解决方案有什么？
- 答：只要从 LDO 输出端消耗过多电流，这个纹波就会变密集。相反，平均消耗电流越少，纹波就越稀疏 (间隔越大)。那么只有两种方案：
    - (1) 增大 LDO 输出端电容，让每次充电能“撑住”的时间长一些，开启没那么频繁，纹波自然就变稀疏
    - (2) 把我们输出端 big BUF (用于将内部的两路输出放大到 PAD) 的电源单独拉出来，不和锁相环其它部分共用，这样测试的时候需要单独给 big BUF 供电（small BUF 仍算在锁相环剩余部分里，用于提供有一定负载能力的时钟输出）













### 8.4 all-SL 验证

数字 LDO 和 PLL 都只用 schematic 进行仿真，设置 Spectre X + CX 为 16-thread 进行仿真时，仿真器自动将线程数限制为了 8-thread：

``` bash
Notice from spectre during initial setup.
    Number of thread was limited because of small circuit size.

Notice from spectre.
    Multithreading enabled: 8 threads in the system with 152 available processors.
```

仿真设置和结果如下：
- (1) 设置仿真模式为 Spectre X + CX @ 16-thread (4-job parallel), 实际被自动限制为了 8-thread
- (2) 瞬态噪声 (仿真精度): fnoise_max = 0.5 MHz
- (3) Corner 设置：all_SL, 也即 SL<1:0> = <00>, <01>, <10>, <11> @ (TT, 27°C)
- (4) 仿真时长：
    - vref_delay = 700m
    - settling_begin = vref_delay + 5m
    - time_end = vref_delay + 25m (稳定后再多仿 20ms)


<div class='center'>

| 仿真耗时 2h 31m 60s @ 8-thread |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-20-22-44-44_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
</div>

截至目前，我们所有的仿真都是设置 REF 为方波输入。尽管我们已经在 PFD 给了两个 INV 作为输入 BUF, 但 TB 最好还是设置正弦输入以模仿真实输入情况。于是：

**<span style='color:red'> 从本语句之后的所用仿真，若无特别说明，REF 均设置为了正弦输入 (无相噪) </span>**


## 8.5 GND-reference LPF/VCO


我们顺便将 LPF 改为 GND-referenced 简单测试了一下，但 VCO 的控制电压 vcont 仍然是 PMOS-input (没改), 所以稳定后的噪声水平显著恶化 (主要来自 VDD)。于是又重新试了一下 GND-referenced LPF 配合 GND-referenced VCO，仿真设置和结果如下：
- (1) 设置仿真模式为 Spectre X + CX @ 16-thread (2-job parallel), 实际被限制为了 8-thread
- (2) 瞬态噪声 (仿真精度): fnoise_max = 2 MHz
- (3) Corner 设置：
    - all_load8 (EN_BUF = 1, CL1 = 80 fF, CL2 = 30 pF)
    - TT +27° (EN_BUF = 0, CL1 = 40 fF, CL2 = 30 pF)
- (4) 其它修改：
    - LPF 改为 GND-referenced
    - VCO 改为 GND-referenced (NMOS-input)
    - <span style='color:red'> PFD 从反接改为正接 </span>
    - 上述修改已经在开始仿真 (生成网表) 后修改回来，不必担心对后续仿真产生影响
- (5) 仿真时长：
    - vref_delay = 700m
    - settling_begin = vref_delay + 5m
    - time_end = vref_delay + 50m (稳定后再多仿 45ms)

不知为何，从 `2:36:16 AM, Sun Dec 21, 2025` 一直运行到 `01:03:49 AM, Fri Dec 26, 2025` 都五天了，竟然只仿真到 `tran: time = 462.6 ms (61.7 %), step = 1.165 ns (155 n%)`，无奈只能终止仿真重新运行，下面是一些简要情况记录：

<div class='center'>

| 五天只仿真了 61.7% (Interactive.323) |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-26-01-10-15_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.png"/></div> |
</div>

取消后适当修改 TB 电路参数，将总仿真时长从 750 ms 缩短到 440 ms, 运放仿真，结果如下：

<div class='center'>

| fnoise_max = 0.1 MHz @ 8-thread (设置 16 但被限制为 8) | fnoise_max = 0.5 MHz @ 8-thread (设置 16 但被限制为 8) | fnoise_max = 2.0 MHz @ 8-thread (设置 16 但被限制为 8) |
|:-:|:-:|:-:|
 | fnoise_max = 0.1 MHz 仿真耗时 16.6 ks (4h 36m 29s) <br> fnoise_max = 0.5 MHz 仿真耗时 20.5 ks (5h 41m 52s) <br> fnoise_max = 2.0 MHz 仿真耗时 23.6 ks (6h 32m 35s) | 仿真结果总览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-01-17-38-40_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Simulation, Layout Details and Post-Simulation Results.png"/></div> |  |
 | 波形总览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-01-17-44-46_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Simulation, Layout Details and Post-Simulation Results.png"/></div> | 锁定过程总览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-01-17-48-04_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Simulation, Layout Details and Post-Simulation Results.png"/></div> |  |
 | CK_OUT/CK_ADC 的频率波形和相位噪声 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-01-17-53-35_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Simulation, Layout Details and Post-Simulation Results.png"/></div> | 作为对比，我们把原先使用 VDD-referenced 时的频率波形和相噪曲线也给出来，如下图 (scalar 结果总览) 和右图 (波形和相噪总览) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-01-17-57-34_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Simulation, Layout Details and Post-Simulation Results.png"/></div>  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-01-18-07-45_202510_onc18_CPPLL_ultra_low_lower (4) Pre-Simulation, Layout Details and Post-Simulation Results.png"/></div> |
</div>








## 99. 杂七杂八的尝试

### 99.1 FATAL (SPECTRE-18): Segmentation fault.

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

### 99.2 Hspice 尝试 

``` bash
ERROR (SFE-23): "netlist" 57: The instance `I0' is referencing an undefined model or subcircuit, `202510_PLL'. Either include the file containing the definition of `202510_PLL', or define `202510_PLL' before running the simulation.
Warning from spectre during circuit read-in.
```

尝试了 `Hspice` 格式的 hspiceText view, 行不通，暂时放弃。

### 99.3 DRC tips


``` bash
Check pepiNOTbln_UNDERPASSES_pwallConn:
pepiNOTnbl has been found with more than one net connected
which creates a resistive path or UNDERPASS in the net which is not recommended.

大多数情况是因为加了 nw ring 后，内部 psub 与外部 psub 没有连通；这在需要 guard ring 的模块设计中是正常现象，可通过去除 nw ring 来验证 (去除 nw ring, 或者开通一条小路径后问题消失)。当然，如果当前模块就是需要提交的最终模块，还是建议开一条小路径把 psub 连通，以避免提交后的扯皮。
```


<!-- ## x. Iteration Summary
 -->
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


## 100. Literature Review

2025.12.15 搜集了一下 ultra-low-power PLL 的相关文献，总结如下：

<span style='font-size:10px'> 

<div class='center'>

| Paper | Power Efficiency | Ref. Spur | RMS Jitter | 其它参数 | 架构 | 主要亮点 |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | [1] J.-W. Moon | 0.256 mW/GHz @ 0.4 V (0.13 mW @ 0.5 GHz) | -59 dBc | 16.9 ps | - | 经典 CP-PLL, 差分 RVCO  | (1) 在 CP 中引入了补偿，包括 gain-boosting 和 bulk-driven; (2) 利用了 AFC (automatic frequency calibration) 来提高性能; (3) 使用了带 bulk-driven 的 cross-couple-based differential RVCO  |
 | [2] B. Xiang | 0.213mW/GHz @ 0.8 V  | < -90 dBc | 2.3 ps (J_int @ 100 kHz ~ 100 MHz) | FoM = -234.4 dB, core area = 0.015 mm2 | 经典 CP-PLL | (1) 带有 lock detection 以加速锁定, 200ns lock time at 100MHz reference clock (20 ref cycles); (2) 使用了 tunable switched capacitor based loop filter (SC-LPF); (3) VCO 带有 start-up;   |
 | [3] W. Wu et al. 这是个 Ultra-Low Jitter Frac-N DTC-based sampling PLL  |  |  |  |  |  |  |
 | [4] M. Faisal | 1.6 mW/GHz or 1.1 mW/GHz @ 0.5 V (300 nW @ 187.5 kHz, 570 nW @ 500 kHz) | -60 dBc | 12.3 ns @ 187.5 kHz, 4.7 ns @ 500 kHz | core area = 0.07 mm2  | ADPLL |  |
 | [5] S. Schober (这篇没有给出除 CP 之外的其它模块情况，有拿一个特殊 CP 去蹭已有优秀模块的嫌疑) |  |  |  |  | 经典 CP-PLL | 主要亮点 (1) 使用了非常规的 capacitor-based CP 以实现低抖动和宽锁定, 并且实现了极低的 CP 电流失配和极低的 (锁定后) 静态电流 |
 | [6] S. K. Saw 这篇很拉，像课程大作业而不是论文 |  |  |  |  |  |  |
 | [7] B. Ghafari 这篇不咋行，更像是课程大作业 | @ 1 V (0.196 mW @ 0.4 GHz ) |  |  |  |  | (1) 使用 cross-coupled-based RVCO |
 | [8] Y.-H. | 0.50 mW/GHz @ 1V (1.19 mW @ 2.4 GHz) | -66 dBc | 1.7 ps | FoMJ = -234.6 dB, core area = 0.22 mm2 | frac-N sub-sampling digital PLL (SS-DPLL) | (1) improved DTC nonlinearity |
 | [9] C.-Y. Lin | 5.16 mW/GHz @ 1V (169 nW @ 32.768 kHz) |  | 94.54 ns (Jcc_rms), 529.4 ns (Jcc_pp) | core area = 0.116 mm2 |  |  |
 | [10] N. O. Adesina 这是个特殊工艺，并且功率效率异常的低，有点奇怪 | 0.0010 mW/GHz @ 0.5V (1.91 uW @ 2 GHz) |  |  |  |  |  |
 | [14] T.-S. Chao | 0.38 mW/GHz @ 0.5V (210 uW @ 0.55 GHz) | - | 8.01 ps (Je_rms), 56.36 ps (Je_pp) | core area = 0.017 mm2 |  |  |
 | [17] A. Gundel | 70 mW/GHz @ 5V (7 uA @ 100.013 kHz) | - | 5 ns (Jc_rms) | core area = 0.8 mm2 |  |  |
</div>
</span>

上表重新筛选之后：

<span style='font-size:10px'> 

<div class='center'>

| Paper | Power Efficiency | Ref. Spur | RMS Jitter | 其它参数 | 架构 |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | [1] J.-W. Moon | 0.256 mW/GHz @ 0.4 V (0.13 mW @ 0.5 GHz) | -59 dBc | 16.9 ps | - | 经典 CP-PLL, 差分 RVCO  |
 | [2] B. Xiang | 0.213mW/GHz @ 0.8 V  | < -90 dBc | 2.3 ps (J_int @ 100 kHz ~ 100 MHz) | FoM = -234.4 dB, core area = 0.015 mm2 | 经典 CP-PLL |
 | [4] M. Faisal | 1.6 mW/GHz (300 nW @ 187.5 kHz) <br> 1.1 mW/GHz @ 0.5 V (570 nW @ 500 kHz) | -60 dBc | 12.3 ns @ 187.5 kHz, 4.7 ns @ 500 kHz | core area = 0.07 mm2  | ADPLL |
 | [8] Y.-H. | 0.50 mW/GHz @ 1 V (1.19 mW @ 2.4 GHz) | -66 dBc | 1.7 ps | FoMJ = -234.6 dB, core area = 0.22 mm2 | frac-N sub-sampling digital PLL (SS-DPLL) | 
 | [9] C.-Y. Lin | 5.16 mW/GHz @ 1 V (169 nW @ 32.768 kHz) |  | 94.54 ns (Jcc_rms), 529.4 ns (Jcc_pp) | core area = 0.116 mm2 |  |
 | [14] T.-S. Chao | 0.38 mW/GHz @ 0.5 V (210 uW @ 0.55 GHz) | - | 8.01 ps (Je_rms), 56.36 ps (Je_pp) | core area = 0.017 mm2 |  |
 | [17] A. Gundel | 70 mW/GHz @ 5 V (7 uA @ 100.013 kHz) | - | 5 ns (Jc_rms) | core area = 0.8 mm2 |  |  |
</div>
</span>

注：下面的文献仅用于指标性能对比，与总项目中参考文献标号无关。
- [1] J.-W. Moon, S.-G. Kim, D.-H. Kwon, and W.-Y. Choi, “A 0.4-V, 500-MHz, ultra-low-power phase-locked loop for near-threshold voltage operation,” in Proceedings of the IEEE 2014 Custom Integrated Circuits Conference, Sept. 2014, pp. 1–4. doi: 10.1109/CICC.2014.6946100.
- [2] B. Xiang, Y. Fan, J. Ayers, J. Shen, and D. Zhang, “A 0.5V-to-0.9V 0.2GHz-to-5GHz Ultra-Low-Power Digitally-Assisted Analog Ring PLL with Less Than 200ns Lock Time in 22nm FinFET CMOS Technology,” in 2020 IEEE Custom Integrated Circuits Conference (CICC), Mar. 2020, pp. 1–4. doi: 10.1109/CICC48029.2020.9075897.
- [3] W. Wu et al., “A 14-nm Ultra-Low Jitter Fractional-N PLL Using a DTC Range Reduction Technique and a Reconfigurable Dual-Core VCO,” IEEE Journal of Solid-State Circuits, vol. 56, no. 12, pp. 3756–3767, Dec. 2021, doi: 10.1109/JSSC.2021.3111134.
- [4] M. Faisal, N. E. Roberts, and D. D. Wentzloff, “A 300nW near-threshold 187.5–500 kHz programmable clock generator for ultra low power SoCs,” in 2015 IEEE SOI-3D-Subthreshold Microelectronics Technology Unified Conference (S3S), Oct. 2015, pp. 1–3. doi: 10.1109/S3S.2015.7333528.
- [5] S. Schober and J. Choma, “A charge transfer-based high performance, ultra-low power PLL charge pump,” in 2015 IEEE 6th Latin American Symposium on Circuits & Systems (LASCAS), Montevideo, Uruguay: IEEE, Feb. 2015, pp. 1–4. doi: 10.1109/LASCAS.2015.7250412.
- [6] S. K. Saw and V. Nath, “A low power low noise current starved CMOS VCO for PLL,” in Communication & Automation International Conference on Computing, May 2015, pp. 1252–1255. doi: 10.1109/CCAA.2015.7148611.
- [7] B. Ghafari, L. Koushaeian, and F. Goodarzy, “An ultra low power and small size PLL for wearable and implantable medical sensors,” in 2012 IEEE Consumer Communications and Networking Conference (CCNC), Jan. 2012, pp. 409–412. doi: 10.1109/CCNC.2012.6181026.
- [8] Y.-H. Liu et al., “An Ultra-Low Power 1.7-2.7 GHz Fractional-N Sub-Sampling Digital Frequency Synthesizer and Modulator for IoT Applications in 40 nm CMOS,” IEEE Transactions on Circuits and Systems I: Regular Papers, vol. 64, no. 5, pp. 1094–1105, May 2017, doi: 10.1109/TCSI.2016.2625462.
- [9] C.-Y. Lin, T.-J. Wang, T.-H. Liu, and T.-H. Lin, “An ultra-low power 169-nA 32.768-kHz fractional-N PLL,” in 2017 IEEE Asian Solid-State Circuits Conference (A-SSCC), Nov. 2017, pp. 45–48. doi: 10.1109/ASSCC.2017.8240212.
- [10] N. O. Adesina, A. Srivastava, A. Ullah Khan, and J. Xu, “An Ultra-Low Power MOS2 Tunnel Field Effect Transistor PLL Design for IoT Applications,” in 2021 IEEE International IOT, Electronics and Mechatronics Conference (IEMTRONICS), Apr. 2021, pp. 1–6. doi: 10.1109/IEMTRONICS52119.2021.9422641.
- [11] S. Chakraborty et al., “An ultra-low power, low-cost, multi-standard transceiver,” in 2015 Texas Symposium on Wireless and Microwave Circuits and Systems (WMCS), Apr. 2015, pp. 1–5. doi: 10.1109/WMCaS.2015.7233220.
- [12] N. van Helleputte and G. Gielen, “An Ultra-low-Power Quadrature PLL in 130nm CMOS for Impulse Radio Receivers,” in 2007 IEEE Biomedical Circuits and Systems Conference, Nov. 2007, pp. 63–66. doi: 10.1109/BIOCAS.2007.4463309.
- [13] T. Alam, T. H. Saika, T. Tanjil Hossain, and S. Nishat, “Design and Optimization of an Area Efficient Ultra-Low Voltage Differential Ring VCO with Wide Tuning Range for PLL Applications,” in 2023 26th International Conference on Computer and Information Technology (ICCIT), Dec. 2023, pp. 1–6. doi: 10.1109/ICCIT60459.2023.10441252.
- [14] T.-S. Chao, Y.-L. Lo, W.-B. Yang, and K.-H. Cheng, “Designing ultra-low voltage PLL Using a bulk-driven technique,” in 2009 Proceedings of ESSCIRC, Sept. 2009, pp. 388–391. doi: 10.1109/ESSCIRC.2009.5325983.
- [15] B. Ghafari, L. Koushaeian, and F. Goodarzy, “New architecture for an ultra low power and low noise PLL for biomedical applications,” in 2013 IEEE Global High Tech Congress on Electronics, Nov. 2013, pp. 61–62. doi: 10.1109/GHTCE.2013.6767241.
- [16] S. K. Saw and V. Nath, “Performance Analysis of Low Power CSVCO for PLL Architecture,” in 2015 Second International Conference on Advances in Computing and Communication Engineering, May 2015, pp. 370–373. doi: 10.1109/ICACCE.2015.101.
- [17] A. Gundel and W. N. Carr, “Ultra Low Power CMOS PLL Clock Synthesizer for Wireless Sensor Nodes,” in 2007 IEEE International Symposium on Circuits and Systems (ISCAS), May 2007, pp. 3059–3062. doi: 10.1109/ISCAS.2007.378054.

