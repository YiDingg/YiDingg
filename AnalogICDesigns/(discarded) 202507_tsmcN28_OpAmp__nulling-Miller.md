# A Basic Two-Stage Op Amp with Nulling-Miller Compensation for Low-Voltage BGR in 28nm CMOS Technology

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 02:01 on 2025-07-17 in Beijing.

本次科研实践相关链接：
- [Scientific Research Practice 1 (Low-Voltage BGR)](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>)
    - [Design of the Low-Voltage Bandgap Reference (BGR)](AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1.md)
        - [(本文) Design of the Op Amp for Low-Voltage BGR](AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller.md)
        - [Layout and Post-Layout Simulation of the Op Amp for Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller__layout.md>)
    - [Layout and Post-Layout Simulation of the Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1__layout.md>)


>注：本文所设计的运放将用于科研实践一，也即 [ Scientific Research Practice 1 (Low-Voltage BGR)](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>) 中的 [low-voltage bandgap reference (BGR)](AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1.md)。


## 0. Introduction

本文，我们借助 [gm-Id](<AnalogIC/Virtuoso Tutorials - 5. An Introduction to gm-Id Methodology.md>) 方法，使用台积电 28nm CMOS 工艺库 `tsmcN28` 来完整地设计一个 **basic two-stage op amp with nulling-Miller compensation**, 需要根据工艺性能自行确定一部分关键指标， **<span style='color:red'> 并完成前仿、版图、验证和后仿工作。 </span>** 设计流程参考上次 180nm CMOS 中所设计的运放： [A Basic Two-Stage Nulling-Miller Compensation Op Amp with 80 dB Gain, 50 MHz UGF and 50 V/us SR at 5pF Load (Simulated 84.35 dB, 55.75 MHz and +56.31/-45.35 V/us)](AnalogICDesigns/202506_tsmc18rf_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.md)





## 1. Design Considerations

在文章 [low-voltage bandgap reference (BGR)](AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1.md) 中，我们已经给出了部分 specs 内容：

<div class='center'>

| DC Gain | UGF | Load | PM | SR | ICMR | Swing | Power Dissipation | Process Corner |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | - | - | - | 60° | - | (600 mV, 800 mV) | (400 mV, 700 mV) | 100 uA @ 0.9V (0.09 mW) | TT, SS, FF, SF, FS |
</div>

剩余未指定参数由 **1.3 determining specs** 一节给出，完整 specs 如下：

<div class='center'>

| DC Gain | UGF | Load | PM | SR | ICMR | Swing | Power Dissipation | Process Corner |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | - | 75 MHz | 1 pF | 60° | - | (600 mV, 800 mV) | (400 mV, 700 mV) | 120 uA @ 0.9V (0.108 mW) | TT, SS, FF, SF, FS |
</div>

主要优化方向为 UGF, 其次是 DC Gain 和 ICMR.

### 1.1 theoretical formulas

理论参考公式如下图 (2025.07.17), 后续如有更新会放在 [Design Sheet for Basic Two-Stage Op Amp with Nulling-Miller Compensation](<AnalogICDesigns/Design Sheet for Basic Two-Stage Op Amp with Nulling-Miller Compensation.md>).



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

在考虑如何确定 Specifications 之前，需要对当前工艺的 NMOS/PMOS 性能有大致的了解 ([this article](<AnalogICDesigns/Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).md>))，然后再考虑 specifications. 在后文，若无特别说明, NMOS 的 bulk 默认接到 GND, PMOS 的 bulk 默认接 source (以避免 body-effect 导致的阈值电压上升)。

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
    g_m = 0.1674 \ \mathrm{mS},\ 
    r_{out} = 312.6 \ \mathrm{k}\Omega
\\
\mathrm{M5:}&\quad
    \left(\frac{g_m}{I_D}\right) = 12 \ \mathrm{S/A},\ 
    I_{D} = 20 \ \mathrm{uA},\ 
    a = \frac{1440 \ \mathrm{nm}}{240 \ \mathrm{nm}} = 6,\ 
    f_t = 9.488 \ \mathrm{GHz},\ 
    r_{out} = 106.3 \ \mathrm{k}\Omega
\\
\mathrm{M7:}&\quad
    \left(\frac{g_m}{I_D}\right) = 12 \ \mathrm{S/A},\ 
    I_{D} = 80 \ \mathrm{uA},\ 
    a = 24\ \mathrm{(2\ series \times 8 = 16\times M5)},\ 
    f_t = 0.593 \ \mathrm{GHz},\ 
    r_{out} = 50 \ \mathrm{k}\Omega
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
    r_{out} = 612.3 \ \mathrm{k}\Omega
\\
\mathrm{M6:} &\quad
    \left(\frac{g_m}{I_D}\right) = 16 \ \mathrm{S/A},\ 
    I_{D} = 80 \ \mathrm{uA},\ 
    a = 10 \times \frac{750 \ \mathrm{nm}}{150 \ \mathrm{nm}} = 50,\ 
    g_m = 1.335 \ \mathrm{mS},\ 
    r_{out} = 23.1 \ \mathrm{k}\Omega
\end{align}
$$


### 2.3 biasing circuit

Mb1 ~ Mb2 尺寸是 M5 的一半, Mb3 ~ Mb4 尺寸是 Mb1 的四倍，然后选取一个 Mb5 满足 a = W/L < 1/10 即可。得到：

$$
\begin{align}
\mathrm{Mb1, Mb2:} &\quad a = \frac{0.5\, W_5}{L_5} = \frac{0.5 \times 1440 \ \mathrm{nm}}{240 \ \mathrm{nm}} = \frac{720 \ \mathrm{nm}}{240 \ \mathrm{nm}} = 3
\\
\mathrm{Mb3} &\quad a = \frac{4\, W_{b1}}{L_{b1}} = \frac{4 \times 720 \ \mathrm{nm}}{240 \ \mathrm{nm}} = \frac{2880 \ \mathrm{nm}}{240 \ \mathrm{nm}} = 12 \ (\mathrm{multiplier\ = 4})
\\
\mathrm{Mb4} &\quad a = \frac{4K\, W_{b1}}{L_{b1}} = \frac{4K \times 720 \ \mathrm{nm}}{240 \ \mathrm{nm}} = \frac{16\times 720 \ \mathrm{nm}}{240 \ \mathrm{nm}} = 48 \ (\mathrm{multiplier\ = 16})
\\
\mathrm{Mb5:} &\quad a = \frac{W}{L} = \frac{90 \ \mathrm{nm}}{900 \ \mathrm{nm}} = 0.1
\end{align}
$$

**<span style='color:red'> 注：上面的 multiplier 也可以用 finger 来替代。 </span>**

### 2.4 design summary

上面各晶体管的参数汇总如下：
<div class='center'>

| MOSFET | W/L (nm) | a | gm/Id |
|:-:|:-:|:-:|:-:| 
 | M1, M2   | 1365/210 | 6.5 | 16.0 |
 | M3, M4   | 2025/450 | 4.5 | 14.0 |
 | M5       | 1440/240 | 6.0 | 12.0 |
 | M6       | (10\*750)/150  | 10\*5.0 = 50.0 | 16.0 |
 | M7       | (8\*1440)/(2\*240)  | 8*6.0/2 =  24.0 | 12.0 |
 | Mb1, Mb2 | 720/240  | 3.0 | 12.0 |
 | Mb3      | (4\*720)/240  | 4\*3.0 = 12.0 | - |
 | Mb4      | (16\*720)/240  | 16\*3.0 = 48.0 | - |
 | Mb5      | 90/900   | 0.1 | - |
</div>

以及阻容器件的初始值：

<div class='center'>

| Parameter | Value |
|:-:|:-:|
 | Cc | 0.33 pF |
 | Rz | 3.125 kOhm |
 | Rs | 11.785 kOhm |
</div>

此时的电路增益约为 57.1241 dB:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-17-51-08_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__70dB_500MHz.png"/></div>


## 3. (discarded) Design Iterations

**<span style='color:red'> 注：第三小节 3. Design Iterations 和第四小节 4. Corner-Simulation 由于误将 Mb4 的 length 设置为了 30 nm (本来应该是 240 nm) 从而被废弃，需要重新仿真。 </span>** 这也是为什么 20 uA 下得到的 Rs 理论值在 3.1 iteration 1 (DC Opt) 中却带来了 50 uA 的电流。

### 3.1 iteration 1 (DC Opt)

先搭建电路，仿真静态工作点，查看是否有明显不合理的地方。(后注：这里无意间把 Rz 和 Rs 的数值代入反了，不过对整个设计影响不大，反正都需要迭代)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-18-42-01_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-18-42-18_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

从上图可以看出，一方面 reference current 生成得太大了 (达到 50 uA)；另一方面，尽管从 Mb2 到 M5 的 length 不变, width 翻倍，但是电流并没有翻倍。因此我们直接修改 Mb1 和 Mb2, 使得 Mb1 = Mb2 = M5 (Mb3 和 Mb4 就不改了，相当于 K = 2), 然后调整 Rs 的值使得 I_out = 20 uA, 如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-18-55-35_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>



<!-- 我们增大 Rs 的值直至 I_out = 10 uA. 如下图, 10 uA 对应 Rs = 18 kOhm, 修改后重新仿真静态工作点： -->

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-18-47-07_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-18-49-56_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
 -->

 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-18-59-42_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

虽然 I_SS1, I_SS2 稍低，而且 M6 的 gm = 841u 也不够大，但是无妨，我们直接进入下一步 “直流输入输出曲线优化”。

### 3.2 iteration 2 (DC Curve)

打开 ADE XL, 设置好 Vin_CM = 700 mV 下的 Vin_DM 扫描 (用于观察输出性能)，以及不同 Vin_CM 下的 Vin_DM 扫描 (用于观察输入范围)，运行仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-21-01-04_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

**<span style='color:red'> 注：部分在 ADE XL 主界面无法直接作出的图像 (例如 waveVsWave)，可以在打开 ADE XL Test Editor (界面和 ADE L 基本一致) 后作出。 </span>**

**Output Performance:**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-21-24-19_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-21-25-03_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

**Input Performance:**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-21-22-41_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

图中可以看出, vincm_range @ 60 dB = (249.533 mV, 723.15 mV) 而 vincm_range @ 40 dB = (207.384 mV, 746.473 mV), 虽然与我们预想的最高 800 mV 有一定差距，但已经不能再大幅提高了。所以我们干脆就不改尺寸了，继续进行下一步 “频响性能优化”。

<!-- 打开 ADE XL, 设置好 Vin_DM 的扫描 (Vin_CM = 700 mV), 运行仿真：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-19-17-07_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

输出范围和增益已经基本满足要求了，然后看看共模输入范围：
 -->


### 3.3 iteration 3 (UGF PM)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-21-51-38_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-21-51-23_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

**<span style='color:red'> UGF 达到了 589.6 MHz, 远远超过了我们的预期！这是为什么？ </span>**

扫描 Cc 和 Rz, 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-21-58-15_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

最终取 Rz = 11 kOhm 和 Cc = 0.35 pF, 重新仿真 frequency response:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-22-00-28_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

**后注：我们在 4.4 (ac) frequency response 一节才发现这里在仿真时使用了错误的电源电压 VDD = 1.8 V (从 schematic 中可以看出).** 因此重新进行 Cc 和 Rz 的迭代 (不影响 **4. Pre-Post Simulation** 的 dc 仿真结果)，也即下面的 iteration 4.

### 3.4 iteration 4 (UGF PM)

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-01-52-40_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
 -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-02-04-35_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-02-03-49_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-02-06-37_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-02-06-12_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div> -->

我们取 Rz = 18 kOhm 和 Cc = 0.20 pF.

### 3.5 iteration summary

上面的迭代仅修改了 Mb1 ~ Mb2, Rz 和 Cc, 修改后的器件参数汇总如下：

<div class='center'>

| MOSFET | W/L (nm) | a | gm/Id |
|:-:|:-:|:-:|:-:| 
 | M1, M2   | 1365/210 | 6.5 | 16.0 |
 | M3, M4   | 2025/450 | 4.5 | 14.0 |
 | M5       | 1440/240 | 6.0 | 12.0 |
 | M6       | (10\*750)/150  | 10\*5.0 = 50.0 | 16.0 |
 | M7       | (8\*1440)/(2\*240)  | 8*6.0/2 =  24.0 | 12.0 |
 | Mb1, Mb2 | 1440/240 | 6.0 | 12.0 |
 | Mb3      | (4\*720)/240  | 4\*3.0 = 12.0 | - |
 | Mb4      | (16\*720)/240  | 16\*3.0 = 48.0 | - |
 | Mb5      | 90/900   | 0.1 | - |
</div>

<div class='center'>

| Parameter | Value |
|:-:|:-:|
 | Rs | 9.4 kOhm |
 | Cc | 0.200 pF |
 | Rz | 18.0 kOhm |
</div>

## 4. (discarded) Corner-Simulation

在下面的 pre-simulation 中，我们将前仿分为两步：
1. corner-simulation: 对常温 (27 °C) 下的全工艺角进行仿真
2. temp-simulation: 对不同温度下的 TT (Nominal) 工艺角进行仿真

在正式的前仿中，相比于 design iteration, 一方面我们需要将理想阻容器件替换为实际器件，另一方面需要对全工艺角度进行仿真。


工艺库 `tsmcN28` 的常用器件见文章 [Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library)](<AnalogICDesigns/Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).md>), 我们选择 `rupolym` 和 `cfmom_2t` 分别作为实际电阻和电容器件。

具体而言：
- Rs = 9.4 kOhm 替换为 rupolym = 16.13u/1u (9.40116 kOhm)
- Rz = 18.0 kOhm 替换为两个 rupolym = 15.44u/1u (9.00003 kOhm) 共 18.00006 kOhm
- Cc = 200 fF 替换为 cfmom_2t, 具体参数为：
    - c: 198.054 fF
    - nr/lr: 64/11.0u (finger and fingers length)
    - w/sp: 50n/50n (fingers width and space)
    - Stack: M1-M3
    - lay: 3
    - m: 1 (multiplier)



### 4.1 (dc) operation point

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-22-47-07_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-22-47-33_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

各工艺角下的静态工作点：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-00-46-08_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

### 4.2 (dc) output-range and gain

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-00-53-58_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-00-54-35_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

### 4.3 (dc) input common-mode range

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-01-16-53_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-01-22-44_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-01-24-07_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

### 4.4 (ac) frequency response

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-02-16-38_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-02-31-59_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-02-34-35_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-01-41-10_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-01-40-22_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

 -->
<!-- 
### 4.5 (tran) slew rate
### 4.6 (tran) step response
### 4.7 (ac) CMRR, PSRR
### 4.8 (noise) input noise
### 4.9 (mc) input offset -->


### 4.99 FS and SF sim error

上面的仿真中, FS 和 SF 的仿真都出现报错，仿真日志里给出的报错信息如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-14-50-58_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-14-50-05_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

参考 [this blog](https://blog.eetop.cn/blog-1780399-6952706.html), 我们知道报错是因为 model file `crn28ull_2d5_elk_v1d0_2p1_shrink0d9_embedded_usage.scs` 里并没有包含 resistor, capacitor 和 inductor 的 FS 和 SF 工艺角模型。而 TT, FF 和 SS 能正常仿真，就是因为文件中包含了这些工艺角：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-14-54-28_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
 -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-14-54-52_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

依上图，找到 `cln28ull_2d5_elk_v1d0_2.scs` 文件，查看一下其中是否有阻容器件的 FS 和 SF 工艺角模型：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-14-57-55_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

可以看到确实是没有的。那么如何 “间接” 地解决 FS, SF 的工艺角仿真问题呢？我们不妨将阻容器件的 FS, SF 模型设置为对应的 TT 模型 (相当于只有晶体管的 FS, SF 模型起作用)，这样就可以避免报错了 (聊胜于无)。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-15-05-00_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

修改后再仿真一次 (ac) frequency response, 仿真正常完成：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-15-08-22_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

## 5. Design Iteration

**<span style='color:red'> 注：第三小节 3. Design Iterations 和第四小节 4. Corner-Simulation 由于误将 Mb4 的 length 设置为了 30 nm (本来应该是 240 nm) 从而被废弃，需要重新仿真。 </span>** 这也是为什么 20 uA 下得到的 Rs 理论值在 3.1 iteration 1 (DC Opt) 中却带来了 50 uA 的电流。

我们从本小节开始重新仿真，将 Mb4 的 length 由 30 nm 改回 240 nm 的同时，顺便将所有 multiplier 改为 fingers. 修改的途中发现 M2 的 width = 1.355u (本来应该是 1.365u), 也一并改正。



### 5.1 iteration 1 (DC Opt)

这一步通过调整 Rs 使 I_out 在 20 uA 左右，为整个电路提供合适的电流参考。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-17-22-26_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-17-23-57_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

如图, 3.6 kOhm 和 3.4 kOhm 都是比较不错的选择，不妨选择 Rs = 3.6 kOhm.

(2025.07.20 补) 在 Rs = 3.6 kOhm 的条件下，看看不同 VDD 的电流情况 (以此调整 Mb5 的尺寸)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-20-22-28-53_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-20-22-27-51_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA.png"/></div>

### 5.2 iteration 2 (UGF PM)

这一步通过调整 Cc 和 Rz 使得 UGF 和 PM 性能得到提高。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-18-31-48_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-18-54-29_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
 -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-18-53-38_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
 -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-19-09-21_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

<span style='color:red'> 上图出现了图像与实际数据不符的问题！ </span>如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-19-11-50_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

<!-- 改用 ADE XL Test Editor 来作图： -->

所以我们不看图了，直接在众多数据中手动找一下, 0.1 pF ~ 0.3 pF 电容值下的的最佳频响性能如下图 (为避免 UGF 虚高，还需参考 GBP @ -20dB drop 的值)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-19-45-46_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

上图的 (Cc, Rz) = (0.1 pF, 5 kOhm) 其实已经很好了，但为了跟优的性能，我们还是继续迭代。将最佳 (Cc, Rz) 的范围锁定到 0 ~ 0.3 pF 和 0.5 kOhm ~ 6 kOhm, 重新仿真。结果如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-19-55-33_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>


手动在表格中寻找最佳参数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-20-19-16_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

显然, (Cc, Rz) = (0.1 pF, 6.0 kOhm) 时有最佳参数。不妨在 Cc = 0.1 pF 的情况下扫描 Rz, 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-20-25-23_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

虽然部分 Rz 的值导致 UGF > GBW (由于零点的不同位置)，但在有充足 GM 的情况下，我们完全可以选择 (Cc, Rz) = (0.1 pF, 14 kOhm). 事实上, Rz 的值会对瞬态性能有影响 (例如 settling time 和 overshot)，不妨进行 tran 仿真以确定最佳 Rz, 详见下一小节。

<!-- 将 Cc = 0.05 pF, 0.3 pF 隐藏 (GBW 较低)，寻找最佳参数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-20-03-32_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

PM 在 65° ~ 70° 以内的最佳参数有两组：
- 绿色曲线的 (0.15 pF, 2.0 kOhm): GBW = 214.9 MHz, UGF = 164.9 MHz, PM = 70.05°
- 蓝色曲线的 (0.25 pF, 1.7 kOhm): GBW = 210.3 MHz, UGF = 176.6 MHz, PM = 68.53°

由于 Rz 仿真点数的不足，并不能保证这两个参数下的性能就是如此，我们分别做两次仿真来比较一下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-20-09-54_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
 -->


### 5.3 iteration 3 (transient)

设置好 step (20 mV 和 100 mV), 对 Rz 进行扫描：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-20-35-59_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

 -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-20-50-42_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-20-50-20_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-20-52-13_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

上图可以看出, Rz = 8.0 kOhm 时运放的 settling time 和 overshot 性能最好，因此最终选择 Rz = 8.0 kOhm.










<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-19-18-09_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

我们选用 (0.3 pF, 17 kOhm) 作为最佳参数，其频响特征及曲线如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-19-22-53_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

 -->



### 5.3 iteration summary

上面两次迭代中，各晶体管的尺寸没变，仅改变了阻容器件的值：

<div class='center'>

| MOSFET | W/L (nm) | a | gm/Id |
|:-:|:-:|:-:|:-:| 
 | M1, M2   | 1365/210 = 1.365u/210n | 6.5 | 16.0 |
 | M3, M4   | 2025/450 = 2.025u/450n | 4.5 | 14.0 |
 | M5       | 1440/240 = 1.44u/240n | 6.0 | 12.0 |
 | M6       | (10\*750)/150 = 7.5u/150n | 10\*5.0 = 50.0 | 16.0 |
 | M7       | (8\*1440)/(2\*240) = 11.52u/(2\*240n) | 8*6.0/2 =  24.0 | 12.0 |
 | Mb1, Mb2 | 1440/240 = 1.44u/240n | 6.0 | 12.0 |
 | Mb3      | (4\*720)/240 = 2.88u/240n | 4*3.0 = 12.0 | - |
 | Mb4      | (16\*720)/240 = 11.52u/240n | 16*3.0 = 48.0 | - |
 | Mb5      | 90/900 = 90n/900n | 0.1 | - |
</div>

<div class='center'>

| Parameter | Value |
|:-:|:-:|
 | Rs | 3.6 kOhm |
 | Cc | 0.1 pF |
 | Rz | 8.0 kOhm |
</div>

## 6. Pre-Simul (Corner)

将阻容替换为实际阻容，然后仿真。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-21-23-52_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

>累了，又要重新仿真工艺角，后面再说吧，先跳过。

### 6.1 (dc) operation point
### 6.2 (dc) io-range and gain
### 6.3 (dc) CM input range
### 6.4 (ac) UGF and PM
### 6.5 simulation summary


<!-- ### 6.5 (tran) slew rate
### 6.6 (tran) step response
### 6.7 (ac) CMRR, PSRR
### 6.8 (noise) input noise
### 6.9 (mc) input offset -->

## 7. Pre-Simul (Temp)

本小节仿真不同温度下的 TT (Nominal) 工艺角，观察不同温度下的性能表现。

以下是不同器件工作温度区间的分类总结列表：


| **类别**            | **温度范围**               | **特点**                                                                 | **典型应用/器件**                              |
|---------------------|---------------------------|--------------------------------------------------------------------------|-----------------------------------------------|
| **商用级**          | **0°C 至 +70°C**          | 低成本，适用于消费电子产品                                               | 手机、电脑、普通MCU、消费电子IC               |
| **工业级**          | **-40°C 至 +85°C/+105°C** | 高可靠性，抗干扰，适用于严苛工业环境                                      | PLC、工业传感器、STM32系列MCU                 |
| **汽车级**          | **-40°C 至 +125°C**       | 耐高温、抗振动，符合车规认证（如AEC-Q100）                               | 车载ECU、CAN收发器、汽车MCU（如NXP S32K）     |
| **军用/航天级**     | **-55°C 至 +125°C/+150°C**| 超高可靠性，抗辐射，极端环境适用                                          | 宇航级FPGA（Xilinx QPRO）、军用CPU            |
| **高温器件**        | **+150°C 至 +300°C+**     | 特殊材料（SiC、陶瓷封装），耐极端高温                                     | 石油钻井、航空发动机（SiC MOSFET、高温传感器）|
| **低温器件**        | **-196°C 至 -40°C**       | 超导、量子计算等超低温环境                                                | 超导器件、极地科考设备                        |

<span style='color:red'>本次设计的目标温度区间为 (-40°C, +105°C) </span>, 也是后续仿真的温度区间。


### 7.1 (dc) operation point

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-21-42-32_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-21-43-59_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

### 7.2 (dc) io-range and gain



### 7.3 (dc) CM input range
### 7.4 (ac) GBW and PM


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-21-49-10_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-21-51-16_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

### 7.5 simulation summary




## 8. Layout Details

``` bash
; 修改 layout 的 display 设置
leHiEditDisplayOptions()
leDisplayOptionsForm->instName->value="both"
_hiFormApplyCB(leDisplayOptionsForm)
hiFormDone(leDisplayOptionsForm)
```


为方便 layout 工作，我们将所有晶体管的 multiplier 全部换为 fingers. 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-16-55-44_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

然后为每一组晶体管添加适当的 dummy 管，并将 schematic 中的器件导入到 layout 中。一个小技巧是 dummy 管的 fingerwidth 和原始管一致，但是 length 可以不同 (比如 dummy 管的 length 都取 30nm 以节省面积)，添加 dummy 管后如下图：


详细的 layout 及版图验证工作见文章 [202507_tsmcN28_OpAmp__nulling-Miller__layout](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller__layout.md>)。






## 9. Post-Simulation


To be completed...


## 10. Design Summary

本文设计的运放较好地满足了各项指标要求，可以用于后续的 BGR 设计。其全部器件参数和详细仿真 (pre-layout simulation) 结果如下：

<div class='center'>

| MOSFET | W/L (nm) | a | gm/Id |
|:-:|:-:|:-:|:-:| 
 | M1, M2   | 1365/210 = 1.365u/210n | 6.5 | 16.0 |
 | M3, M4   | 2025/450 = 2.025u/450n | 4.5 | 14.0 |
 | M5       | 1440/240 = 1.44u/240n | 6.0 | 12.0 |
 | M6       | (10\*750)/150 = 7.5u/150n | 10\*5.0 = 50.0 | 16.0 |
 | M7       | (8\*1440)/(2\*240) = 11.52u/(2\*240n) | 8*6.0/2 =  24.0 | 12.0 |
 | Mb1, Mb2 | 1440/240 = 1.44u/240n | 6.0 | 12.0 |
 | Mb3      | (4\*720)/240 = 2.88u/240n | 4*3.0 = 12.0 | - |
 | Mb4      | (16\*720)/240 = 11.52u/240n | 16*3.0 = 48.0 | - |
 | Mb5      | 90/900 = 90n/900n | 0.1 | - |
</div>

<div class='center'>

| Parameter | Value |
|:-:|:-:|
 | Rs | 3.6 kOhm |
 | Cc | 0.1 pF |
 | Rz | 8.0 kOhm |
</div>

若无特别说明，下面数据均在 27 °C 的 TT 工艺角下仿真得到：

<div class='center'>

| Parameter | Value |
|:-:|:-:|
 | DC gain              |  xxx dB @ Vin_CM = 0.7 V |
 | Output swing         | xxx V @ -3dB drop <br> xxx V @ -20dB drop <br> xxx V @ 40dB gain |
 | ICMR                 | (xxx V, xxx V) =  xxx V @ -3dB drop <br> (xxx V, xxx V) = xxx V @ 40dB gain |
 | UGF                  | 206.7 MHz @ Vin_CM = 0.7 V |
 | GBW                  | 210.5 MHz @ Vin_CM = 0.7 V |
 | PM                   | 74.27° @ Vin_CM = 0.7 V |
 | GM                   | 27.95 dB @ Vin_CM = 0.7 V |
 | Slew rate            | +xxx V/us, -xxx V/us |
 | Overshoot (r, f)     | < 2.0 % @ 20 mV ~ 100 mV step |
 | Settling time (r, f) | < 10 ns @ 0.05% (20 mV ~ 100 mV step) |
 | CMRR_dc              |  xxx dB @ Vin_CM = 0.7 V |
 | PSRR_dc              |  xxx dB @ Vin_CM = 0.7 V |
 | Input-referred noise | xxx nV/√Hz @ 1 kHz |
 | RMS noise            | xxx uV @ 10 Hz to 10 GHz |
 | Input offset voltage | +xxx uV, sigma = xxx mV |
 | Power dissipation    | 143.6 uA @ Vin_CM = 0.7 V (0.12924 mW, VDD = 0.9 V) |
</div>

<!-- 
<div class='center'>

| Parameter | Value |
|:-:|:-:|
 | DC gain              |  xxx dB @ Vin_CM = 0.7 V |
 | Output swing         | xxx V @ -3dB drop <br> xxx V @ -20dB drop <br> xxx V @ 40dB gain |
 | ICMR                 | (xxx V, xxx V) =  xxx V @ -3dB drop <br> (xxx V, xxx V) = xxx V @ 40dB gain |
 | UGF                  | 206.7 MHz @ Vin_CM = 0.7 V |
 | GBW                  | 210.5 MHz @ Vin_CM = 0.7 V |
 | PM                   | 74.27° @ Vin_CM = 0.7 V |
 | GM                   | 27.95 dB @ Vin_CM = 0.7 V |
 | Slew rate            | +xxx V/us, -xxx V/us |
 | Overshoot (r, f)     | < 2.0 % @ 20 mV ~ 100 mV step |
 | Settling time (r, f) | < 10 ns @ 0.05% (20 mV ~ 100 mV step) |
 | CMRR_dc              |  xxx dB @ Vin_CM = 0.7 V |
 | PSRR_dc              |  xxx dB @ Vin_CM = 0.7 V |
 | Input-referred noise | xxx nV/√Hz @ 1 kHz |
 | RMS noise            | xxx uV @ 10 Hz to 10 GHz |
 | Input offset voltage | +xxx uV, sigma = xxx mV |
 | Power dissipation    | 143.6 uA @ Vin_CM = 0.7 V (0.12924 mW, VDD = 0.9 V) |
</div>
 -->


<!-- <div class='center'>

| Parameter | Value |
|:-:|:-:|
 | DC gain              |  59 dB @ Vin_CM = 0.7 V |
 | Output swing         | 0.881 V @ -3dB drop <br> 0.985 V @ 80dB gain <br> 1.38 V @ 60dB gain |
 | ICMR                 | (0.481 V, 1.568 V) =  1.087 V @ 80dB gain <br> (0.456 V, 1.697 V) = 1.242 V @ 60dB gain |
 | UGF                  | 55.75 MHz @ Vin_CM = 0.7 V |
 | PM                   | 64.46° @ Vin_CM = 0.7 V |
 | GM                   | 19.31 dB @ Vin_CM = 0.7 V |
 | Slew rate            | +56.31 V/us, -45.35 V/us |
 | Overshoot (r, f)     | (5.40 %, 6.17 %) @ 100 mV step <br> (3.23 %, 3.90 %) @ 200 mV step |
 | Settling time (r, f) | (53.48 ns, 57.07 ns) @ 0.05% (100 mV step) |
 | CMRR_dc              |  86.02 dB @ Vin_CM = 0.7 V |
 | PSRR_dc              |  81.25 dB @ Vin_CM = 0.7 V |
 | Input-referred noise | 60.68 nV/√Hz @ 1 kHz |
 | RMS noise            | 108.69 uV @ 10 Hz to 10 GHz |
 | Input offset voltage | +643.98 uV, sigma = 1.249 mV |
 | Power dissipation    | 690.2 uA @ Vin_CM = 0.7 V (1.242 mW) |
</div>
 -->