# A Basic Two-Stage Op Amp with Nulling-Miller Compensation (simulated xxx) for Low-Voltage BGR in 28nm CMOS Technology

> [!Note|style:callout|label:Infor]
Initially published at 02:01 on 2025-07-17 in Beijing.

## 0. Introduction

>注：本文所设计的运放将用于 [科研实践一](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>) 的 [low-voltage bandgap reference (BGR)](<AnalogICDesigns/tsmcN28_BGR__scientific_research_practice_1.md>) 中。

本文，我们借助 [gm-Id](<Electronics/An Introduction to gm-Id Methodology.md>) 方法，使用台积电 28nm CMOS 工艺库 `tsmcN28` 来完整地设计一个 **basic two-stage op amp with nulling-Miller compensation**, 需要根据工艺性能自行确定一部分关键指标， **<span style='color:red'> 并完成前仿、版图和后仿工作。 </span>** 

设计流程参考上次 180nm CMOS 中所设计的运放： [A Basic Two-Stage Nulling-Miller Compensation Op Amp with 80 dB Gain, 50 MHz UGF and 50 V/us SR at 5pF Load (Simulated 84.35 dB, 55.75 MHz and +56.31/-45.35 V/us)](<AnalogICDesigns/tsmc18rf_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.md>)

在文章 [low-voltage bandgap reference (BGR)](<AnalogICDesigns/tsmcN28_BGR__scientific_research_practice_1.md>) 中给出了部分 specs 内容：

<div class='center'>

| DC Gain | UGF | Load | PM | SR | ICMR | Swing | Power Dissipation | Process Corner |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | - | - | - | 60° | - | (600 mV, 800 mV) | (400 mV, 700 mV) | 100 uA @ 0.9V (0.09 mW) | TT, SS, FF, SF, FS |
</div>

剩余未指定参数由 **1.3 determining specs** 一节给出，完整 specs 如下：

<div class='center'>

| DC Gain | UGF | Load | PM | SR | ICMR | Swing | Power Dissipation | Process Corner |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 70 dB | 100 MHz | 0.6 pF | 65° | - | (600 mV, 800 mV) | (400 mV, 700 mV) | 100 uA @ 0.9V (0.09 mW) | TT, SS, FF, SF, FS |
</div>

主要优化方向为 UGF, 其次是 DC Gain 和 ICMR.

## 1. Design Considerations


### 1.1 theoretical formulas

理论参考公式如下图 (2025.07.17), 后续如有更新会放在 [Design Sheet of Basic Two-Stage Op Amp with Nulling-Miller Compensation](<AnalogICDesigns/Design Sheet of Basic Two-Stage Op Amp with Nulling-Miller Compensation.md>).



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-14-42-24_Design Sheet of Basic Two-Stage Op Amp with Nulling-Miller Compensation.png"/></div>


### 1.2 biasing circuits

参考电流由单独的 current reference circuit 提供，也即下图右侧的 Figure 12.3 (b), 然后由普通 current mirror 生成 I_SS1 和 I_SS2.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-14-52-28_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__70dB_500MHz.png"/></div>

$$
\begin{gather}
I_{out} = \frac{2}{\mu_n C_{ox}\left(\frac{W}{L}\right)_N}\cdot \frac{1}{R_S^2}\left(1 - \frac{1}{\sqrt{K}}\right)^2,\quad I_D =  \mu_n C_{ox}\left(\frac{W}{L}\right) \cdot \frac{4}{\left(\frac{g_m}{I_D}\right)^2}
\\
\Longrightarrow I_{out} = \frac{2\sqrt{2}}{\left(\frac{g_m}{I_D}\right)_N }\cdot \frac{1 - \frac{1}{\sqrt{K}} }{R_S} \quad \mathrm{(square\ low)},\quad \mathrm{let\ } K = 4,\ \mathrm{we\ have:}
\\
I_{out} = \frac{\sqrt{2}}{\left(\frac{g_m}{I_D}\right)_N }\cdot \frac{1}{R_S},\quad R_S = \frac{\sqrt{2}}{I_{out}\left(\frac{g_m}{I_D}\right)_N } =  \frac{\sqrt{2}}{g_{mN}}
\end{gather}
$$

### 1.3 determining specs

在考虑如何确定 Specifications 之前，需要对当前工艺的 NMOS/PMOS 性能有大致的了解 ([this article](<AnalogIC/Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).md>))，然后再考虑 specifications. 在后文，若无特别说明, NMOS 的 bulk 默认接到 GND, PMOS 的 bulk 默认接 source (以避免 body-effect 导致的阈值电压上升)。

先做下图中的考量：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-15-58-21_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__70dB_500MHz.png"/></div>

到这一步可以有：
<div class='center'>

| DC Gain | UGF | Load | PM | SR | ICMR | Swing | Power Dissipation | Process Corner |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | - | 75 MHz | 1 pF | 60° | - | (600 mV, 800 mV) | (400 mV, 700 mV) | 120 uA @ 0.9V (0.108 mW) | TT, SS, FF, SF, FS |
</div>

在保证 UGF 和 PM 的情况下，尽量提高 DC Gain. 下面是增益的大致分配情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-15-47-21_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__70dB_500MHz.png"/></div>

至于增益具体能做到哪一步，等设计时便会知道了。

<!-- 考虑到 op amp 仅仅驱动两个 PMOS (尽管这两个 PMOS 的 cgg 偏大), 不妨将指标中的负载电容 C_L 设置为 0.6 pF, 对应 GBW_f = 109.42 MHz.

然后根据运放功率限制确定电流和压摆率。总电流 100 uA, 那么各支路电流量级为 10 uA, biasing circuit 消耗 $2\,I_{SS1}$, $\alpha = \frac{1}{3}$ 的情况下 $I_{SS2} = (1+\frac{1}{\alpha})I_{SS1} = 4I_{SS1}$, 于是总电流

$$
\begin{gather}
7 I_{SS1} = 100 \ \mathrm{uA} \Longrightarrow I_{SS1} = 14.2857 \ \mathrm{uA} 
\end{gather}
$$

不妨令 $I_{SS1} = 15 \ \mathrm{uA}$ 而 $I_{SS2} = 60 \ \mathrm{uA}$ (总电流超了一点也无妨)。此时的压摆率满足：

$$
\begin{gather}
\mathrm{SR} = \frac{I_{SS1}}{C_c} = \frac{15 \ \mathrm{uA}}{ \frac{1}{3}C_L } = \frac{15 \ \mathrm{uA}}{ 0.2 \ \mathrm{pF}} = 75 \ \mathrm{V/\mu s},\quad \left(\frac{g_m}{I_D}\right)_{1} = 4 \pi \frac{\mathrm{GBW}_f}{\mathrm{SR}} = 4\pi\times\frac{100 \ \mathrm{MHz}}{75 \ \mathrm{V/\mu s}} = 16.755 \ \mathrm{S/A}
\end{gather}
$$

综合上面几条，我们有：
$$
\begin{gather}
I_{SS1} = 15 \ \mathrm{uA},\quad  I_{SS2} = 60 \ \mathrm{uA},\\
\alpha = \frac{1}{3},\ C_c = 0.2 \ \mathrm{pF},\ R_z = \frac{1}{g_{m6}}\left(1 + \frac{1}{\alpha}\right) = 795.7747 \Omega \approx 800 \ \Omega \\
g_{m1} = 0.1375 \ \mathrm{mS},\quad  I_{D1} = 15 \ \mathrm{uA},\quad \left(\frac{g_m}{I_D}\right)_{1} = \frac{0.1375 \ \mathrm{mS}}{\frac{1}{2}\times 15 \ \mathrm{uA}} = 
\\
g_{m6} = 2\left(1 + \frac{1}{\alpha}\right) g_{m1} = 5.0265 \ \mathrm{mS},\quad I_{D6} = 400 \ \mathrm{uA},\quad \left(\frac{g_m}{I_D}\right)_{6} = 12.5664\ \mathrm{S/A}
\end{gather}
$$ -->


## 2. Design Details

**<span style='color:red'> 若无特别说明，本小节所有 MOSFET 仿真数据均在 vds = 225 mV 下扫描 vgs 得到。 </span>**

### 2.1 (n) M1 ~ M2, M5, M7

根据 gm/Id 找出各管子的 I_nor, 由此确定 a = W/L:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-16-11-25_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__70dB_500MHz.png"/></div>


<div class='center'>

| MOS | M1, M2 | M5 | M7 |
|:-:|:-:|:-:|:-:|
 | gm/Id        | 16 | 12 | 12 |
 | I_nor_range  | 1.151u ~ 1.73u | 2.442u ~ 3.67u | 2.442u ~ 3.67u |
 | I_nor        | 1.5u | 3.3u | 3.3u |
 | I_D          | 10u | 20u | 80u |
 | a = I_D/I_nor | 6.67 | 6.06 | 24.24 |
 | a_regulated   | 6.5 | 6.0 | 24.0 |
</div>

设置 a = 6.5 进行仿真，根据 gm1 = 0.16 mS 选择 M1 和 M2 的 length:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-16-21-09_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__70dB_500MHz.png"/></div>

选择 L = 2.1e-07 = 210 nm, 对应 gm = 167.4u 和 rout = 312.6 kOhm.

同理，设置 a = 6.0 进行仿真，选择 M5 的 length:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-16-37-03_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__70dB_500MHz.png"/></div>


不妨选择 L = 2.4e-07 = 240 nm (W = 6\*240nm = 1440nm), 对应 rout = 106.3 kOhm 且 ft = 9.488 GHz. 另外，关于 M7 的尺寸，一种方法是直接令 M7 = 4*M5, 但是这样 rout 会非常低 (相当于四个 106.3 kOhm 并联)，所以并不推荐。注意到 `tsmcN28` 工艺库的 length from 28nm to 900nm, width from 90nm to 2700nm, 要想在 a = 24 的情况选取较高的 L, 我们必须引入 **composite transistor**, 也就是将两个或多个管子 “串联” 以等效地提高 length. 

假设 $r_{out} \propto \frac{1}{L}$, 以 M5 为 unit transistor, 要想得到 100kOhm 的输出电阻，我们可以采用 series = 4 且 multiplier = 16 (共 64 units). 这样 $a_7 = \frac{16 W_5}{4 L_5} = 4 a_5 = 24$ 也满足条件。同理, 50kOhm 的输出电阻对应 series\*multiplier = 2\*8 = 16 units. 

为避免消耗过高面积，我们选择 50kOhm 的输出电阻方案, 此时 series\*multiplier = 2\*8 = 16 units. 

综上, M1 ~ M2, M5, M7 的尺寸及预估参数如下：

$$
\begin{align}
\mathrm{M1, M2:}&\quad
    \left(\frac{g_m}{I_D}\right) = 16 \ \mathrm{S/A},\ 
    I_{D} = 10 \ \mathrm{uA},\ 
    a = \frac{1365 \ \mathrm{nm}}{210 \ \mathrm{nm}} = 6.5,\ 
    g_{m} = 0.1674 \ \mathrm{mS},\
    r_{out} = 312.6 \ \mathrm{k\Omega}
\\
\mathrm{M5:}&\quad
    \left(\frac{g_m}{I_D}\right) = 12 \ \mathrm{S/A},\ 
    I_{D} = 20 \ \mathrm{uA},\ 
    a = \frac{1440 \ \mathrm{nm}}{240 \ \mathrm{nm}} = 6,\ 
    f_t = 9.488 \ \mathrm{GHz},\ 
    r_{out} = 106.3 \ \mathrm{k\Omega}
\\
\mathrm{M7:}&\quad
    \left(\frac{g_m}{I_D}\right) = 12 \ \mathrm{S/A},\ 
    I_{D} = 80 \ \mathrm{uA},\ 
    a = 24\ \mathrm{(2\ series \times 8\ multiplier = 16\ units)},\ 
    f_t = 0.593 \ \mathrm{GHz},\ 
    r_{out} = 50 \ \mathrm{k\Omega}
\end{align}
$$

### 2.2 (p) M3 ~ M4, M6

根据 gm/Id 找出各管子的 I_nor, 由此确定 a = W/L:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-17-06-40_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__70dB_500MHz.png"/></div>

<div class='center'>

| MOS | M3, M4 | M6 |
|:-:|:-:|:-:
 | gm/Id        | 14 | 16 |
 | I_nor_range  | 1.882u ~ 2.479u | 1.329u ~ 1.77u |
 | I_nor        | 2.20u | 1.60u |
 | I_D          | 10u | 80u |
 | a = I_D/I_nor | 4.545 | 50 |
 | a_regulated   | 4.5 | 50 |
</div>

先考虑 M3 和 M4:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-17-14-34_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__70dB_500MHz.png"/></div>

选择 L = 4.5e-07 = 450 nm (width = 2025nm), 对应 rout = 612.3 kOhm.

对于 M6, a = 50 实在是太大, 考虑 multiplier = 10 (unit transistor 的 a = 5) 进行仿真 (仿真结果中的 gm 和 rout 需分别乘 10 和除以 10 才是总的参数)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-17-21-14_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__70dB_500MHz.png"/></div>

选择 L = 1.5e-07 = 150 nm (width = 750nm), 对应 gm = 133.5u, rout = 231.0 kOhm. 而 M6 由 10 个这样的 750nm/150nm 并联构成。

综上, M3 ~ M4 和 M6 的尺寸和预估参数为：

$$
\begin{align}
\mathrm{M3, M4:} &\quad
    \left(\frac{g_m}{I_D}\right) = 14 \ \mathrm{S/A},\ 
    I_{D} = 10 \ \mathrm{uA},\ 
    a = \frac{2025 \ \mathrm{nm}}{450 \ \mathrm{nm}} = 4.5,\ 
    r_{out} = 612.3 \ \mathrm{k\Omega}
\\
\mathrm{M6:} &\quad
    \left(\frac{g_m}{I_D}\right) = 16 \ \mathrm{S/A},\ 
    I_{D} = 80 \ \mathrm{uA},\ 
    a = 10 \times \frac{750 \ \mathrm{nm}}{150 \ \mathrm{nm}} = 50 \ \mathrm{(multiplier = 10)},\ 
    g_{m} = 1.335 \ \mathrm{mS},\
    r_{out} = 23.1 \ \mathrm{k\Omega}
\end{align}
$$


### 2.3 biasing circuit

Mb1 ~ Mb2 尺寸是 M5 的一半, Mb3 ~ Mb4 尺寸是 Mb1 的四倍，然后选取一个 Mb5 满足 a = W/L < 1/10 即可。得到：

$$
\begin{align}
\mathrm{Mb1, Mb2:} &\quad a = \frac{0.5\, W_5}{L_5} = \frac{0.5 \times 1440 \ \mathrm{nm}}{240 \ \mathrm{nm}} = \frac{720 \ \mathrm{nm}}{240 \ \mathrm{nm}} = 3
\\
\mathrm{Mb3, Mb4:} &\quad a = \frac{4\, W_{b1}}{L_{b1}} = \frac{4 \times 720 \ \mathrm{nm}}{240 \ \mathrm{nm}} = \frac{2880 \ \mathrm{nm}}{240 \ \mathrm{nm}} = 12 \ (\mathrm{multiplier\ = 4})
\\
\mathrm{Mb5:} &\quad a = \frac{W}{L} = \frac{90 \ \mathrm{nm}}{900 \ \mathrm{nm}} = 0.1
\end{align}
$$

### design summary

上面各晶体管的参数汇总如下：
<div class='center'>

| MOSFET | W/L (nm) | a | gm/Id |
|:-:|:-:|:-:|:-:| 
 | M1, M2   | 1365/210 | 6.5 | 16.0 |
 | M3, M4   | 2025/450 | 4.5 | 14.0 |
 | M5       | 1440/240 | 6.0 | 12.0 |
 | M6       | 750/150  | 5.0 | 16.0 |
 | M7       | 750/150  | 5.0 | 12.0 |
 | Mb1, Mb2 | 720/240  | 3.0 | 12.0 |
 | Mb3, Mb4 | 720/240  | 3.0 | - |
 | Mb5      | 90/900   | 0.1 | - |
</div>

以及阻容器件的初始值：

<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 |  |  |  |
 |  |  |  |
</div>
