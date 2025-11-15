# A Basic Two-Stage Op Amp with Nulling-Miller Compensation for Low-Voltage BGR in 28nm CMOS Technology

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 02:01 on 2025-07-17 in Beijing.

本次科研实践相关链接：
- [Scientific Research Practice 1 (Low-Voltage BGR)](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>)
    - [Design of the Low-Voltage Bandgap Reference (BGR)](<AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1.md>)
        - [(本文) Design of the Op Amp for Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller.md>)
        - [Layout and Post-Layout Simulation of the Op Amp for Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller__layout.md>)
    - [Layout and Post-Layout Simulation of the Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1__layout.md>)


>注：本文所设计的运放将用于科研实践一，也即 [ Scientific Research Practice 1 (Low-Voltage BGR)](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>) 中的 [low-voltage bandgap reference (BGR)](<AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1.md>)。


## 0. Introduction

本文，我们借助 [gm-Id](<AnalogIC/Virtuoso Tutorials - 5. An Introduction to gm-Id Methodology.md>) 方法，使用台积电 28nm CMOS 工艺库 `tsmcN28` 来完整地设计一个 **basic two-stage op amp with nulling-Miller compensation**, 需要根据工艺性能自行确定一部分关键指标， **<span style='color:red'> 并完成前仿、版图、验证和后仿工作。 </span>** 设计流程参考上次 180nm CMOS 中所设计的运放： [A Basic Two-Stage Nulling-Miller Compensation Op Amp with 80 dB Gain, 50 MHz UGF and 50 V/us SR at 5pF Load (Simulated 84.35 dB, 55.75 MHz and +56.31/-45.35 V/us)](<AnalogICDesigns/202506_tsmc18rf_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.md>)





## 1. Design Considerations

在文章 [low-voltage bandgap reference (BGR)](<AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1.md>) 中，我们已经给出了部分 specs 内容：

<span style='font-size:12px'>
<div class='center'>

| DC Gain | UGF | Load | PM | SR | ICMR | Swing | Power Dissipation | Process Corner |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | - | - | - | 60° | - | (600 mV, 800 mV) | (400 mV, 700 mV) | 100 uA @ 0.9V (0.09 mW) | TT, SS, FF, SF, FS |
</div>
</span>

剩余未指定参数由 **1.3 determining specs** 一节给出，完整 specs 如下：



<span style='font-size:12px'>
<div class='center'>

| DC Gain | UGF | Load | PM | SR | ICMR | Swing | Power Dissipation | Process Corner |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | - | 75 MHz | 1 pF | 60° | - | (600 mV, 800 mV) | (400 mV, 700 mV) | 120 uA @ 0.9V (0.108 mW) | TT, SS, FF, SF, FS |
</div>
</span>

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

## 3. Design Iteration



我们从本小节开始仿真迭代，先将所有 multiplier 改为 fingers. 



### 3.1 iteration 1 (DC Opt)

这一步通过调整 Rs 使 I_out 在 20 uA 左右，为整个电路提供合适的电流参考。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-17-22-26_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-17-23-57_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

如图, 3.6 kOhm 和 3.4 kOhm 都是比较不错的选择，不妨选择 Rs = 3.6 kOhm.

(2025.07.20 补) 在 Rs = 3.6 kOhm 的条件下，看看不同 VDD 的电流情况 (以此调整 Mb5 的尺寸)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-20-22-28-53_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-20-22-27-51_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA.png"/></div>

### 3.2 iteration 2 (UGF PM)

这一步通过调整 Cc 和 Rz 使得 UGF 和 PM 性能得到提高。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-18-31-48_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-19-09-21_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

<span style='color:red'> 上图出现了图像与实际数据不符的问题！ </span>如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-19-11-50_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>


所以我们不看图了，直接在众多数据中手动找一下, 0.1 pF ~ 0.3 pF 电容值下的的最佳频响性能如下图 (为避免 UGF 虚高，还需参考 GBP @ -20dB drop 的值)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-19-45-46_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

上图的 (Cc, Rz) = (0.1 pF, 5 kOhm) 其实已经很好了，但为了跟优的性能，我们还是继续迭代。将最佳 (Cc, Rz) 的范围锁定到 0 ~ 0.3 pF 和 0.5 kOhm ~ 6 kOhm, 重新仿真。结果如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-19-55-33_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>


手动在表格中寻找最佳参数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-20-19-16_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

显然, (Cc, Rz) = (0.1 pF, 6.0 kOhm) 时有最佳参数。不妨在 Cc = 0.1 pF 的情况下扫描 Rz, 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-20-25-23_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

虽然部分 Rz 的值导致 UGF > GBW (由于零点的不同位置)，但在有充足 GM 的情况下，我们完全可以选择 (Cc, Rz) = (0.1 pF, 14 kOhm). 事实上, Rz 的值会对瞬态性能有影响 (例如 settling time 和 overshot)，不妨进行 tran 仿真以确定最佳 Rz, 详见下一小节。


### 3.3 iteration 3 (transient)

设置好 step (20 mV 和 100 mV), 对 Rz 进行扫描：



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-20-52-13_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

上图可以看出, Rz = 8.0 kOhm 时运放的 settling time 和 overshot 性能最好，因此最终选择 Rz = 8.0 kOhm.




### 3.4 iteration summary

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

## 4. Pre-Layout Simulation

下面将阻容替换为实际阻容，正式对运放进行前仿。若无特别说明，均默认 VDD = 0.9 V 且 Vin_CM = 0.7 V, 工艺角为 TT 且温度 27 °C (室温)。需要仿真其他工艺角或温度时，其参考范围如下：
- Corners: {TT, SS, FF, SF, FS}
- Temperature: (-40 °C, 125 °C) or {-40 °C, 0 °C, 27 °C, 75 °C, 125 °C} ()

<div class='center'>

| **类别**            | **温度范围**               | **特点**                                                                 | **典型应用/器件**                              |
|---------------------|---------------------------|--------------------------------------------------------------------------|-----------------------------------------------|
| **商用级**          | **0°C 至 +70°C**          | 低成本，适用于消费电子产品                                               | 手机、电脑、普通MCU、消费电子IC               |
| **工业级**          | **-40°C 至 +85°C/+105°C** | 高可靠性，抗干扰，适用于严苛工业环境                                      | PLC、工业传感器、STM32系列MCU                 |
| **汽车级**          | **-40°C 至 +125°C**       | 耐高温、抗振动，符合车规认证（如AEC-Q100）                               | 车载ECU、CAN收发器、汽车MCU（如NXP S32K）     |
| **军用/航天级**     | **-55°C 至 +125°C/+150°C**| 超高可靠性，抗辐射，极端环境适用                                          | 宇航级FPGA（Xilinx QPRO）、军用CPU            |
| **高温器件**        | **+150°C 至 +300°C+**     | 特殊材料（SiC、陶瓷封装），耐极端高温                                     | 石油钻井、航空发动机（SiC MOSFET、高温传感器）|
| **低温器件**        | **-196°C 至 -40°C**       | 超导、量子计算等超低温环境                                                | 超导器件、极地科考设备                        |
</div>

### 4.0 schematic preview

用作前仿的 schematic 及器件详细参数如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-02-08-59_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>

### 4.1 (dc) operation point (TT, 27 °C)

仿真运放在 TT, 27 °C 且 Vin_CM = 700 mV 下的静态工作点，并给出各管子的详细静态参数：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-02-14-40_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>

### 4.2 (dc) out-range and gain (all-corner, all-temp)

设置好外围电路和 config 文件 (注意要选 schematic 而不是 calibre):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-02-19-12_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>

先仿真一下  TT, 27 °C 且 Vin_CM = 700 mV 下的输出性能：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-02-22-32_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>

然后仿真典型工艺角下不同温度 (-40 °C, 0 °C, 27 °C, 75 °C, 125 °C) 的输出性能 (Vin_CM = 700 mV):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-02-39-13_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-02-39-32_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>

最后仿真室温 (27 °C) 下不同工艺角 (TT, SS, FF, SF, FS) 的输出性能 (Vin_CM = 700 mV):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-02-43-58_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-02-43-20_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>




### 4.3 (dc) CM input range (TT, 27 °C)

固定 TT + 27 °C, 扫描不同共模输入下的差分增益，得到共模输入范围：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-20-58-04_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-21-02-42_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>

### 4.4 (ac) frequency response (all-corner, all-temp)

**<span style='color:red'> 设置 C_L = 1 pF </span>** , 先仿真 TT + 27 °C + Vin_CM = 700 mV 下的输出性能：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-21-06-19_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-21-12-11_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>

然后仿真典型工艺角下不同温度 (-40 °C, 0 °C, 27 °C, 75 °C, 125 °C) 的频响性能 (Vin_CM = 700 mV):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-21-14-09_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>

最后仿真室温 (27 °C) 下不同工艺角 (TT, SS, FF, SF, FS) 的频响性能 (Vin_CM = 700 mV):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-21-16-54_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>

### 4.5 (tran) step response (TT, 27 °C)

**<span style='color:red'> 设置 C_L = 1 pF </span>** , 仿真 step input = ± 10 mV 和 ± 100 mV 下的瞬态性能：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-21-28-31_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-21-32-07_202507_tsmcN28_OpAmp__nulling-Miller.png"/></div>

### 4.6 (tran) slew rate (TT, 27 °C)

在上面小节的基础上，逐渐增大 input step 的幅度，知道 SR 达到最大值：



### 4.6 simulation summary

上面的仿真结果总结如下： <span style='color:red'> (默认 VDD = 0.9 V) </span>

<span style='font-size:12px'>
<div class='center'>

| Parameter | Definition | Pre-Layout Simulation | Simulation Condition |
|:-:|:-:|:-:|:-:|
 | A_0          | DC gain @ Vin_CM = 0.7 V | 66.71 dB <br> 61.63 dB ~ 70.37 dB | TT, 27 °C, Vin_CM = 0.7 V <br> all-corner, all-temp, Vin_CM = 0.7 V |
 | V_out_swing  | Output swing             | (59.69 mV, 813.7 mV) = 665.0 mV @ 40dB gain <br> 467.3 mV ~ 754.3 mV @ 40dB gain | TT, 27 °C, Vin_CM = 0.7 V <br> all-corner, all-temp, Vin_CM = 0.7 V |
 | V_OS         | Offset voltage           | -1.675 mV <br> -3.624 mV ~ -0.840 mV | TT, 27 °C <br> all-corner, all-temp |
 | A_0_max      | Maximum dc gain          | 71.3534 dB | TT, 27 °C, all-vincm |
 | ICMR | Input common-mode range          | (187.194 mV, 742.373 mV) = 555.179 mV @ 40dB gain <br> (227.547 mV, 710.640 mV) = 483.093 mV @ 60dB gain | TT, 27 °C |
 | Idd | Total current consumption    | 122.1 uA (0.110 mW @ 0.9 V) <br> 96.48 uA ~ 158.3 uA (0.087 mW ~ 0.142 mW) | TT, 27 °C, Vin_CM = 0.7 V <br> all-corner, all-temp, Vin_CM = 0.7 V |
 | GBW_f        | Gain bandwidth product (Hz) | 193.3 MHz <br> 137.9 MHz ~ 289 MHz | TT, 27 °C, Vin_CM = 0.7 V, C_L = 1 pF <br> all-corner, all-temp, Vin_CM = 0.7 V, C_L = 1 pF |
 | UGF_f        | Unit gain frequency (Hz)    | 180.4 MHz <br> 143.6 MHz ~ 234.6 MHz | TT, 27 °C, Vin_CM = 0.7 V, C_L = 1 pF <br> all-corner, all-temp, Vin_CM = 0.7 V, C_L = 1 pF |
 | PM           | Phase Margin (°)      | 72.35° <br> 61.83° ~ 80.62° | TT, 27 °C, Vin_CM = 0.7 V, C_L = 1 pF <br> all-corner, all-temp, Vin_CM = 0.7 V, C_L = 1 pF |
 | GM           | Gain Margin (dB)      | 29.67 dB <br> 29.12 dB ~ 30.99 dB | TT, 27 °C, Vin_CM = 0.7 V, C_L = 1 pF <br> all-corner, all-temp, Vin_CM = 0.7 V, C_L = 1 pF |
 | OST | Overshoot (rise, fall)     | (1.172 %, 1.115 %) @ ± 10 mV step <br> (0.163 %, 0.008 %) @ ± 100 mV step |  TT, 27 °C, unit buffer, C_L = 1 pF |
 | ST | Settling time (rise, fall)  | (18.16 ns, 19.54 ns) @ 0.05% accuracy (10 mV step) <br> (8.701 ns, 11.30 ns) @ 0.05% accuracy (100 mV step) |  TT, 27 °C, unit buffer, C_L = 1 pF |
 | SR | Slew rate (from 20% to 80%)          | +156.6 V/us @ 20% to 80% (500 mV step) <br> -62.49 V/us @ 20% to 80% (500 mV step) | TT, 27 °C, unit buffer, C_L = 1 pF |
</div>
</span>

## 5. Layout and Post-Simulation

``` bash
; 修改 layout 的 display 设置
leHiEditDisplayOptions()
leDisplayOptionsForm->instName->value="both"
_hiFormApplyCB(leDisplayOptionsForm)
hiFormDone(leDisplayOptionsForm)
```




详细的版图设计、版图验证和后仿工作见文章 [202507_tsmcN28_OpAmp__nulling-Miller__layout](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller__layout.md>)。


## 6. Design Summary

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

前仿结果总结如下： <span style='color:red'> (默认 VDD = 0.9 V) </span>

<span style='font-size:12px'>
<div class='center'>

| Parameter | Definition | Pre-Layout Simulation | Simulation Condition |
|:-:|:-:|:-:|:-:|
 | A_0          | DC gain @ Vin_CM = 0.7 V | 66.71 dB <br> 61.63 dB ~ 70.37 dB | TT, 27 °C, Vin_CM = 0.7 V <br> all-corner, all-temp, Vin_CM = 0.7 V |
 | V_out_swing  | Output swing             | (59.69 mV, 813.7 mV) = 665.0 mV @ 40dB gain <br> 467.3 mV ~ 754.3 mV @ 40dB gain | TT, 27 °C, Vin_CM = 0.7 V <br> all-corner, all-temp, Vin_CM = 0.7 V |
 | V_OS         | Offset voltage           | -1.675 mV <br> -3.624 mV ~ -0.840 mV | TT, 27 °C <br> all-corner, all-temp |
 | A_0_max      | Maximum dc gain          | 71.3534 dB | TT, 27 °C, all-vincm |
 | ICMR | Input common-mode range          | (187.194 mV, 742.373 mV) = 555.179 mV @ 40dB gain <br> (227.547 mV, 710.640 mV) = 483.093 mV @ 60dB gain | TT, 27 °C |
 | Idd | Total current consumption    | 122.1 uA (0.110 mW @ 0.9 V) <br> 96.48 uA ~ 158.3 uA (0.087 mW ~ 0.142 mW) | TT, 27 °C, Vin_CM = 0.7 V <br> all-corner, all-temp, Vin_CM = 0.7 V |
 | GBW_f        | Gain bandwidth product (Hz) | 193.3 MHz <br> 137.9 MHz ~ 289 MHz | TT, 27 °C, Vin_CM = 0.7 V, C_L = 1 pF <br> all-corner, all-temp, Vin_CM = 0.7 V, C_L = 1 pF |
 | UGF_f        | Unit gain frequency (Hz)    | 180.4 MHz <br> 143.6 MHz ~ 234.6 MHz | TT, 27 °C, Vin_CM = 0.7 V, C_L = 1 pF <br> all-corner, all-temp, Vin_CM = 0.7 V, C_L = 1 pF |
 | PM           | Phase Margin (°)      | 72.35° <br> 61.83° ~ 80.62° | TT, 27 °C, Vin_CM = 0.7 V, C_L = 1 pF <br> all-corner, all-temp, Vin_CM = 0.7 V, C_L = 1 pF |
 | GM           | Gain Margin (dB)      | 29.67 dB <br> 29.12 dB ~ 30.99 dB | TT, 27 °C, Vin_CM = 0.7 V, C_L = 1 pF <br> all-corner, all-temp, Vin_CM = 0.7 V, C_L = 1 pF |
 | OST | Overshoot (rise, fall)     | (1.172 %, 1.115 %) @ ± 10 mV step <br> (0.163 %, 0.008 %) @ ± 100 mV step |  TT, 27 °C, unit buffer, C_L = 1 pF |
 | ST | Settling time (rise, fall)  | (18.16 ns, 19.54 ns) @ 0.05% accuracy (10 mV step) <br> (8.701 ns, 11.30 ns) @ 0.05% accuracy (100 mV step) |  TT, 27 °C, unit buffer, C_L = 1 pF |
 | SR | Slew rate (from 20% to 80%)          | +156.6 V/us @ 20% to 80% (500 mV step) <br> -62.49 V/us @ 20% to 80% (500 mV step) | TT, 27 °C, unit buffer, C_L = 1 pF |
</div>
</span>

<span style='font-size:8px'>
<div class='center'>

| Parameter | DC Gain | GBW | Load | PM | GM | SR | ICMR | Output Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Specifications | - | 75 MHz | 1 pF | 60° | 10 dB | - | (600 mV, 800 mV) | (400 mV, 700 mV) | 120 uA @ 0.9V (0.108 mW) |
 | Nominal Corner (TT) | 66.71 dB | 193.3 MHz| 1 pF | 72.35° | 29.67 dB | +156.6 V/us,  -62.49 V/us | (187.2 mV, 742.4 mV) = 555.2 mV @ 40 dB gain | (59.69 mV, 813.7 mV) = 665.0 mV @ 40 dB gain | 122.1 uA @ 0.9V (0.110 mW) |
 | All Corners (TT, SS, FF, SF, FS) | 61.63 dB ~ 70.37 dB | 137.9 MHz ~ 289.0 MHz | 1 pF | 61.83° ~ 80.62° | 29.12 dB ~ 30.99 dB | - | - | 467.3 mV ~ 754.3 mV @ 40 dB gain | 96.48 uA ~ 158.3 uA <br> (0.087 mW ~ 0.142 mW) |
</div>
</span>


<!-- 若无特别说明，下面数据均在 27 °C 的 TT 工艺角下仿真得到：

<div class='center'>

| Parameter | Pre-Layout Simulation | Post-Layout Simulation |
|:-:|:-:|:-:|
 | DC gain              |  xxx dB @ Vin_CM = 0.7 V | xxx dB @ Vin_CM = 0.7 V |
 | Output swing         | xxx V @ -3dB drop <br> xxx V @ -20dB drop <br> xxx V @ 40dB gain |
 | ICMR                 | (xxx V, xxx V) =  xxx V @ -3dB drop <br> (xxx V, xxx V) = xxx V @ 40dB gain |
 | UGF                  |  | 206.7 MHz @ Vin_CM = 0.7 V |
 | GBW                  |  | 210.5 MHz @ Vin_CM = 0.7 V |
 | PM                   |  | 74.27° @ Vin_CM = 0.7 V |
 | GM                   |  | 27.95 dB @ Vin_CM = 0.7 V |
 | Slew rate            | +xxx V/us, -xxx V/us |
 | Overshoot (r, f)     |  | < 2.0 % @ 20 mV ~ 100 mV step |
 | Settling time (r, f) |  | < 10 ns @ 0.05% (20 mV ~ 100 mV step) |
 | CMRR_dc              |  xxx dB @ Vin_CM = 0.7 V |
 | PSRR_dc              |  xxx dB @ Vin_CM = 0.7 V |
 | Input-referred noise | xxx nV/√Hz @ 1 kHz |
 | RMS noise            | xxx uV @ 10 Hz to 10 GHz |
 | Input offset voltage | +xxx uV, sigma = xxx mV |
 | Power dissipation    |  | 143.6 uA @ Vin_CM = 0.7 V (0.10052 mW @ VDD = 0.9 V) |
</div>

 -->