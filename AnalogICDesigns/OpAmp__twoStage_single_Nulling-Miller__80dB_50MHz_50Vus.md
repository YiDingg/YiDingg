# A Basic Two-Stage Nulling-Miller Compensation Op Amp with 80 dB Gain, 50 MHz UGF and 50 V/us SR at 5pF Load (Simulated 84.35 dB, 55.75 MHz and +56.31/-45.35 V/us)

> [!Note|style:callout|label:Infor]
Initially published at 10:32 on 2025-06-17 in Beijing.


## 0. Introduction

本文，我们借助 [gm-Id](<Electronics/An Introduction to gm-Id Methodology.md>) 方法，使用台积电 180nm CMOS 工艺库 `tsmc18rf` 来设计一个 **basic two-stage op amp with nulling-Miller compensation** 。暂时只作前仿练习，未进行 layout 和 post-layout simulation, 之后如果有需求再补上这一部分。


运放主要指标如下：

<div class='center'>

| DC Gain | UGF | Load | PM | SR | ICMR | Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 80 dB | 100 MHz | 5 pF | 60° | 50 V/us | 0.5 V to 1.5 V | 1.0 V | 1 mA @ 1.8V (1.8 mW) |
</div>

主要优化方向为 dc gain, 齐次是 UGF 和 PM.



## 1. Design Considerations


### 1.1 theoretical formulas

理论参考公式如下图 (2025.06.18), 后续如有更新会放在 [Design Sheet of Basic Two-Stage Op Amp with Nulling-Miller Compensation](<AnalogICDesigns/Design Sheet of Basic Two-Stage Op Amp with Nulling-Miller Compensation.md>).



<span style='color:red'> 这里放图 </span>


### 1.2 biasing circuits

在已有参考电流的情况下，由于 I_SS2 已经是 I_SS1 的数倍，不宜在 I_REF 和 I_SS1 之间再做 Multiplier, 因此考虑令 I_REF = I_SS1, 且 I_SS2 由 I_REF 经过普通 current mirror + multiplier 生成。

### 1.3 satisfying specs


在考虑如何满足 Specifications 之前，需要对当前工艺的 NMOS/PMOS 性能有大致的了解，建议先在 cadence 中对需要用到的晶体管进行仿真，了解各性能参数范围，再考虑 "satisfying specifications":
- 若无特别说明, NMOS 的 bulk 默认接到 GND, PMOS 的 bulk 默认接 source (以避免 body-effect 导致的阈值电压上升)
- **<span style='color:red'> 令 $\alpha = \frac{1}{3}$ 作为 initial design 的值</span>** ，此时 $C_c = \frac{5}{3} \mathrm{pF} \approx 1.67 \ \mathrm{pF}$
- 先考虑 `SR` 和 `UGF`, 因为这两个参数可以直接确定电路的 $I_D$ 和输入管的 $g_m$
- `SR > 50 V/us` : 为留有足够的设计余量，考虑 SR = 1.2 SR0 = 60 V/us, 此时 $I_{SS1} = \mathrm{SR}\cdot C_{c} = 100 \ \mathrm{uA},\ I_{SS2} = \left(1 + \frac{1}{\alpha}\right)I_{SS1} = 400 \ \mathrm{uA}$
- `UGF > 50 MHz` : 同样，考虑 $\mathrm{UGF} \approx 1.2 \ \mathrm{GBW} = 60 \ \mathrm{MHz}$ 进行设计，此时 $g_m = 2\pi C_c \cdot \mathrm{GBW}_f = 0.6283 \ \mathrm{mS}$


综合上面两条，我们有：
$$
\begin{gather}
I_{SS1} = 100 \ \mathrm{uA},\quad  I_{SS2} = 400 \ \mathrm{uA},\\
\alpha = \frac{1}{3},\ C_c = 1.67 \ \mathrm{pF},\ R_z = \frac{1}{g_{m6}}\left(1 + \frac{1}{\alpha}\right) = 795.7747 \Omega \approx 800 \ \Omega \\
g_{m1} = 0.6283 \ \mathrm{mS},\quad  I_{D1} = 50 \ \mathrm{uA},\quad \left(\frac{g_m}{I_D}\right)_{1} = 12.5664\ \mathrm{S/A}
\\
g_{m6} = 2\left(1 + \frac{1}{\alpha}\right) g_{m1} = 5.0265 \ \mathrm{mS},\quad I_{D6} = 400 \ \mathrm{uA},\quad \left(\frac{g_m}{I_D}\right)_{6} = 12.5664\ \mathrm{S/A}
\end{gather}
$$


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-13-00-26_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

对于直流增益，需要多大的 self gain 和 rout 才能满足增益要求呢？参考下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-15-07-53_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

<!-- <span style='color:red'> 这里放图 </span>
 -->

- `DC Gain > 80 dB` : 
    - 考虑上图的第 2 种方案 (82.3 dB), 也即 $r_{O1} = r_{O6} = 100 \ \mathrm{k}\Omega,\ r_{O3} = r_{O7} = 200 \ \mathrm{k}\Omega$
- `PM > 60°` : 
    - 补偿带有 nulling resistor 时，如果 cancel out 的效果比较好，运放通常会具有相当高的相位裕度，并且可以通过增大 $\alpha$ 来降低 PM 以避免 PM 过高导致 settling time 过长。
- `Swing > 1.2 V` : 
    - 输出有两个晶体管，对于 1.8 V 的电源轨，要想在 600mV/2 = 300 mV 的情况下保证足够的增益是比较难的，因此最终得到的 -3dB (或 80dB) 输出摆幅大概率会小于 1.2 V, 但 60dB 摆幅应该可以满足 1.2 V 的要求

### 1.4 summary

上面的考虑可汇总为以下几条 (括号内的是仿真时的 Vds 建议值):

``` bash
- Cc = 1.67 pF, R_z = 800 Ohm 
- M1 ~ M4 Id = 50 uA, M5 Id = 100 uA, M6 ~ M7 Id = 400 uA
- 所有 NMOS (M3 ~ M6) 的 bulk 连接 GND, PMOS bulk 连接 source
- (N) M1, M2 (450 mV): gm/Id = 12.5664, gm = 0.6283 mS, rout > 100 kOhm
- (P) M3, M4 (350 mV): rout > 200 kOhm
- (N) M5     (350 mV): rout > 50 kOhm 以保证 CMRR 不会过低
- (P) M6     (350 mV): gm/Id = 12.5664, gm = 5.0265 mS, rout > 100 kOhm
- (N) M7     (350 mV): rout > 200 kOhm
```


## 2. Design Details

### 2.1 (N) M1, M2 (450 mV)

从 I_nor vs. gm/Id (Vds = 450 mV) 的曲线图中读出 gm/Id = 12.5664 时 I_nor = 3.2 uA, 于是 a = W/L = 15.6250。于是令 a = 15.625 仿真 rout 和 gm, 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-15-35-14_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-15-37-01_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>


由于 450 mV 还是非常宽松的，所以 rout 很容易就达到了 100 kOhm, 不妨选择刚好具有 200 kOhm 的 length = 684 nm 以保证较高的 80 dB 增益摆幅。则晶体管预估参数为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_{1,2} = \frac{10.6875 \ \mathrm{um}}{0.684 \ \mathrm{um}} = 15.6250,\quad 
\left(\frac{g_m}{I_D}\right)_{1,2} = 12.5664
\\
I_D = 50 \ \mathrm{uA},\quad g_m = 0.650 \ \mathrm{mS},\quad r_O = 207.6 \ \mathrm{k}\Omega
\end{gather}
$$

### 2.2 (P) M3, M4 (350 mV)

作为负载管，我们先尝试 gm/Id = 11, 从 I_nor vs. gm/Id (Vds = 350 mV) 的曲线图中读出此时 I_nor = 0.840 uA @ gm/Id = 11, 此时 a = W/L = 59.5238. (作为对比, NMOS 的是 I_nor = 4.32 uA @ gm/Id = 11, a = 11.5741)

Vds = 350 mV 扫描 length from 0.36u to 3.6u (19 steps), 得到 pmos 的  rout 和 fug 数据如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-15-55-47_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

选择 length = 900 nm 对应 rout = 222.8 kOhm, 则晶体管的预估参数为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_{3,4} = \frac{53.5714 \ \mathrm{um}}{0.9 \ \mathrm{um}} = 59.5238,\quad
\left(\frac{g_m}{I_D}\right)_{3,4} = 11
\\
I_D = 50 \ \mathrm{uA}\quad r_O = 222.8 \ \mathrm{k}\Omega,\quad f_T = 255.6 \ \mathrm{MHz}
\end{gather}
$$

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-15-47-34_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

选择 length = 1.494 um 即可很好地满足要求，不必再尝试 gm/Id = 12 (即使其 rout 更高)
 -->

### 2.3 (N) M5 (350 mV)

又回到 NMOS, 作为一个电流管，我们希望它有较低的 gm/Id (提高匹配性)、较低的 vdsat (增大共模输入范围) 、可观的 rout 和较高的 fug (减弱 mirror pole)。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-16-02-50_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

先令 gm/Id = 10(如果不行再提高到 gm/Id = 11), 从 I_nor vs. gm/Id (Vds = 350 mV) 图可知 I_nor = 6.10 uA, 于是 a = 100 uA / 6.10 uA = 16.3934。令 a = 16.3934 扫描 rout, vdsat 和 fug 数据：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-16-07-27_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

不妨选择 length = 1.98 um (rout = 128.2 kOhm, vdsat = 194 mV), 由于是 nmos 且 a 较小，这么长的 length 仍然具有中等的 fug = 406.8 MHz. 于是晶体管的预估参数为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_{5} = \frac{32.4589 \ \mathrm{um}}{1.98 \ \mathrm{um}} = 16.3934,\quad
\left(\frac{g_m}{I_D}\right)_{5} = 10
\\
I_D = 100 \ \mathrm{uA},\quad r_O = 128.2 \ \mathrm{k}\Omega,\quad v_{dsat} = 194 \ \mathrm{mV},\quad f_T = 406.8 \ \mathrm{MHz}
\end{gather}
$$



### 2.4 (P) M6 (350 mV)

<!-- 回到 PMOS, M6 与 M1 具有相同的 gm/Id = 12.5664, 于是 I_nor = 0.58 uA, a = 400 uA / 0.58 uA = 689.6552. 令 a = 689.6552 扫描 gm6,  rout 和 fug 数据：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-16-18-40_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

无奈，由于 a 实在太大 (从 Id3 到 Id6 有八倍，从 nmos 到 pmos 又有数倍)
 -->

回到 M6 (pmos), 按照我们的 design sheet:

$$
\begin{gather}
a_6 = \frac{2\, I_{SS2}}{I_{SS1}}\cdot a_3 = 8\,a_3 = 8 \times 59.5238 = 476.1904
\end{gather}
$$

此时的 I_nor, gm/Id 与 M3, M4 基本相同，也即 I_nor = = 0.840 uA, gm/Id = 11. 令 a = 476.1904 扫描 gm,  rout 和 fug 数据：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-16-35-01_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

遗憾的是，由于 a 过高，没有任何 length 可以很好地满足我们的要求。要想降低 a 并提升 fug, 我们需要减小 gm/Id, 但是要想提高 gm 和 rout, 我们又需要提升 a, 于是一个不可避免的 trade-off 出现在我们面前。


综合考虑，由于 gm6 对除增益外的其它指标影响不大 (例如 GBW 和 SR)，我们考虑允许较低的 gm6, 也即直接在刚刚的图中选择 length = 1.26 um, 此时晶体管的预估参数为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_{6} = \frac{599.9994 \ \mathrm{um}}{1.26 \ \mathrm{um}} = 476.19,\quad \left(\frac{g_m}{I_D}\right)_{6} = 11
\\
I_D = 400 \ \mathrm{uA},\quad A_6 = g_mr_O = 147.8,\quad  g_m = 4.105 \ \mathrm{mS} \quad f_T = 134.7 \ \mathrm{MHz}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-16-56-55_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>


由于实际放到电路里之后 Vds 会增大非常多，所以下降的增益会被补偿回来一部分。我们待会观察观察电路的 dc gain 和 ac frequency response 情况，如果 dc gain 不够或者 ac response 实在不好，再对 M6 进行调整。

<!-- 保证足够的 gm, 提升 fug, 同时将 A_v2 的参考公式替换为 A_6 = gm6*rout6. 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-16-38-49_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

选取 gm/Id = 9, 对应 I_nor = 1.24 uA, a = 400/1.24 = 322.5806, 然后扫描 gm7,  self gain 和 fug 数据：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-16-47-03_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

gm7 和 rout 还是太小。也就是说，想在保持 GBW 或 SR 不变的情况下，维持大约 80 dB 的增益，已经是非常困难了，因为我们不可能用如此大的 

现在摆在我们面前的
 -->


### 2.5 (N) M7 (350 mV)

M7 是 NMOS, a = W/L 相对就没有那么大。同样，依据 design sheet, 考虑：

$$
\begin{gather}
a_7 = \frac{2\, I_{SS2}}{I_{SS1}}\cdot a_5 = 8\,a_5 = 8 \times 16.3934 = 131.1472,\quad 
\left(\frac{g_m}{I_D}\right)_{7} = \left(\frac{g_m}{I_D}\right)_{5} = 10
\end{gather}
$$

仿真 rout, fug 和 vdsat 如图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-17-06-15_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-17-07-54_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

非常的遗憾, rout 仍然是不够的。由于 gm/Id 值已不宜继续降低 (否则 width 太大)，我们先选择 length = 3.06 um, 在下一小节进行 iteration 1: dc gain adjustment 时提高 rout1 和 rout3 来尽量弥补。

length = 3.06 um 对应的晶体管预估参数为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_{7} = \frac{401.3104 \ \mathrm{um}}{3.06 \ \mathrm{um}} = 131.1472,\quad
\left(\frac{g_m}{I_D}\right)_{7} = 10
\\
I_D = 400 \ \mathrm{uA},\quad r_O = 20.36 \ \mathrm{k}\Omega,\quad v_{dsat} = 194 \ \mathrm{mV},\quad f_T = 170.5 \ \mathrm{MHz}
\end{gather}
$$

### 2.6 design summary

作规整化之后，上面各晶体管的参数汇总如下：
<div class='center'>

| MOSFET | W/L (um) | a | gm/Id |
|:-:|:-:|:-:|:-:| 
 | M1, M2 | 11/0.70  | 15.71  | 12.5 |
 | M3, M4 | 54/0.90  | 60.00  | 11.0 |
 | M5     | 33/2.00  | 16.50  | 10.0 |
 | M6     | 600/1.26 | 476.19 | 11.0 |
 | M7     | 400/3.06 | 130.72 | 10.0 |
</div>

## 3. Design Iteration

### 3.1 iteration 1 (dc gain)

在上面的设计中，我们的增益情况如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-17-22-52_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

即使认为 Vds 的增大会使各 rout 变为原来的 1.5 倍，也只能达到 78.4762 dB 的增益。因此，我们需要适当调整 M1 和 M3 的 length, 使其 rout 提高到 300 kOhm ~ 400 kOhm 以尽量满足增益要求。需要注意的是 M3 (pmos) 的 fug 并没有多大 (255.6 MHz), 因此考虑将 rout3 只提高到 300 kOhm (length = 1.30 um), 而将 M1 的 rout 提高到 400 kOhm (length = 1.65 um)，两对 mos 的长宽比仍保持不变。

此时各晶体管的参数如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-17-37-06_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

作规整化：

<div class='center'>

| MOSFET | W/L (um) | a | gm/Id |
|:-:|:-:|:-:|:-:| 
 | M1, M2 | <span style='color:red'> 26/1.65 </span>  | 15.78  | 12.5 |
 | M3, M4 | <span style='color:red'> 80/1.30 </span>  | 61.54  | 11.0 |
 | M5     | 33/2.00  | 16.50  | 10.0 |
 | M6     | 600/1.26 | 476.19 | 11.0 |
 | M7     | 400/3.06 | 130.72 | 10.0 |
</div>

仿真静态工作点，查看是否有明显不合理的地方：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-18-08-35_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-18-04-49_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

上图可以看出各晶体管参数与我们预估的基本一致，于是进行 dc sweep, 查看运放的直流增益情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-18-15-00_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-18-16-20_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

图中看出最大增益达到了 89.05 dB, 远超我们的预期，看来 vds 升高导致 rout 增大的现象比我们想象中的还要明显。另外，虽然系统的差分输入有 0.495 mV 的系统失调，但这仍是可以接受的，因为多数情况下 Vin_offset 随机失调的标准差为 4mV ~ 8mV, 仅 0.5 mV 的系统失调自然不会带来明显影响。

在电路中加入 $C_c = 1.67 \ \mathrm{pF}$ 和 $R_z = 800 \ \Omega$ 的补偿电路，看看频响有没有什么明显问题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-18-36-30_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-18-36-07_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

虽然 UGF 和 PM 都不达标，但是基本上没什么大问题，第一次迭代结束，可以进入第二次迭代：改善 UGF 和 PM.

### 3.2 iteration 2 (UGF, PM)

在上一小节对 dc gain 的迭代中，我们已经看到，频响在 30.6 MHz 左右出现了一个第二极点。首先要解决的问题就是，这个极点是从哪来的？按照我们之前 design sheet 中的分析，可以排除掉 $C_{L1}$ 和 $C_{L2}$ 导致的 $p_2$ 和 $p_3$, 那么只剩下了一种可能: drain of M3 节点等效电容 $C_E$ 导致的 mirror pole $\omega_{pE} \approx \frac{g_{m3}}{C_E}$.

可是此节点的电容主要由 M3 和 M4 贡献得到，这三个晶体管在目前的参数下 fug 虽然比较小 (约 130 MHz), 但也不至于产生 30 MHz 的极点吧？虽然有些不解，但我们还是来缩放 M1 ~ M4 和 M6, 也即它们的 length 和 width 同时乘上缩放系数 frac, 扫描结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-01-31-32_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

如上图，选择 frac = 0.6, 此时的频响曲线如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-01-33-23_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

由于 M7 对系统性能影响不大 (如下图)，我们便不再缩小 M7 了 (如果希望减小面积可以进一步缩小 M7)。下面来调整 Cc 和 Rz 以获得更好的 UGF 和 PM:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-01-34-59_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

上图表明 Cc 已经基本没有调整空间，因此直接考虑 Rz:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-01-37-23_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

显然, Rz = 1.3 kOhm 是最佳选择。综上，本此迭代的结果为：

``` bash
frac = 0.6 (M3, M4, M6)
Cc = 1.67 pF
Rz = 1.3 kOhm
```



<!--  -->
<!--  -->
<!--  -->

<!-- <span style='color:blue'> 

本来这部分应该缩放 M3, M4 和 M6 的，但是错缩放成了 M1 ~ M4, M6. 因此重新仿真

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-19-06-44_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

选择 frac = 0.6, 此时的频响曲线如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-19-11-56_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

由于 M7 对系统性能影响不大 (如下图)，我们便不再缩小 M7 了 (如果希望减小面积可以进一步缩小 M7)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-19-19-04_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>



直接来调整 Cc 和 Rz 以获得更好的 UGF 和 PM:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-19-23-29_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

从图中知道, Cc 已经基本上没有什么调整空间了，就令 Cc = 1.67 pF, 然后调整 Rz:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-19-26-59_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

将 Rz 调整为 1.3 kOhm 最佳。综上，本此迭代的结果为：

``` bash
frac = 0.6 (M1 ~ M4, M6)
Cc = 1.67 pF
Rz = 1.3 kOhm
```

 </span> -->





## 4. Simulation Results

综合上面的迭代，各元件的参数如下表所示：

<div class='center'>

| MOSFET | W/L (um) | a | gm/Id |
|:-:|:-:|:-:|:-:| 
 | M1, M2 | 26/1.65  | 15.78  | 12.5 |
 | M3, M4 | (80\*frac/1.30\*frac) = 48/0.78 | 61.54  | 11.0 |
 | M5     | 33/2.00  | 16.50  | 10.0 |
 | M6     | (600\*frac/1.26\*frac) = 360/0.7560 | 476.19 | 11.0 |
 | M7     | 400/3.06 | 130.72 | 10.0 |
</div>

不妨将 M6 的 length 与 M3, M4 统一，得到：

<div class='center'>

| MOSFET | W/L (um) | a | gm/Id |
|:-:|:-:|:-:|:-:| 
 | M1, M2 | 26/1.65  | 15.78  | 12.5 |
 | M3, M4 | <span style='color:red'> 48/0.78 </span>  | 61.54  | 11.0 |
 | M5     | 33/2.00  | 16.50  | 10.0 |
 | M6     | <span style='color:red'> 370/0.78 </span> | 474.36 | 11.0 |
 | M7     | 400/3.06 | 130.72 | 10.0 |
 | Cc     |  1.67 pF |  Rz    | 1.3 kOhm |
</div>




现在，我们可以对运放进行较全面的仿真，考察其各项性能是否达标。但是在那之前，还需要对 Iref 进行设计，以便在后续的仿真中直接使用。


### 4.0 generation of Iref 

采用文章 [Reference Current Generation Methods](<AnalogIC/Reference Current Generation Methods.md>) 中的 **basic beta multiplier** ，具体电路及参数仿真如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-01-57-52_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

图中可以看出，随着 K 的增大, R_S 在 Iout = 100 uA 时增大，并且 sensitivity (绝对值) 减小。综合考虑正反馈环路增益、面积限制和 sensitivity, 我们先选择 K = 4 (R_S = 1.287 kOhm), 查看其静态工作点，验证正反馈环路增益是否小于 1:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-02-01-35_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

对于 nmos current mirror 的情况，需要满足：

$$
\begin{gather}
R_S > \frac{1}{g_{m3}}\cdot \left(\frac{g_{m3}g_{m1}}{g_{m4}g_{m2}} - 1\right) = 523.678 \ \Omega
\end{gather}
$$

可见我们的 $R_S$ 是满足要求的。再来看看 Iout 关于 VDD 的变化情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-02-20-54_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

可以满足我们的偏置电路要求，然后加入 start-up transistor (注意 M5 的 Vgs 需要尽量高, 所以 a = W/L 会很小)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-02-38-55_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>




### 4.1 (dc) operation point

不妨把 1.287 kOhm 的 Rs 也改为 1.3 kOhm, 则所有器件参数汇总在下表：

<div class='center'>

| MOSFET | W/L (um) | a | gm/Id |
|:-:|:-:|:-:|:-:| 
 | M1, M2 | 26/1.65  | 15.78  | 12.5 |
 | M3, M4 | 48/0.78  | 61.54  | 11.0 |
 | M5     | 33/2.00  | 16.50  | 10.0 |
 | M6     | 370/0.78 | 474.36 | 11.0 |
 | M7     | 400/3.06 | 130.72 | 10.0 |
 |  ---   |    ---   |   ---  |  --- |
 | Mb1, Mb2 | 33u/2u | Mb3 | 528u/2u |
 | Mb4 | 132u/2u | Mb5 | 0.36u/5u |
 | Cc     |  1.67 pF |  Rz    | 1.3 kOhm |
 | Rs     | <span style='color:red'> 1.3 kOhm </span> |
</div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-16-09_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-25-17_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-26-03_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

为什么加上电感之后, Id7 会显示有 835 uA? 去掉电感后进行仿真 (便没有负反馈了)，电流也是正常的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-33-50_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

### 4.2 (dc) io-range and gain



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-38-27_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-39-21_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>


``` bash
vout = VS("/Vout")
dc_gain = dB20(deriv(VS("/Vout")))
max dc gain = ymax(dB20(deriv(VS("/Vout"))))
swing @ -3dB = (value(vout cross(dc_gain, max_dc_gain-3, 2)) - value(vout cross(dc_gain, max_dc_gain-3, 1)))
swing @ 80dB = (value(vout cross(dc_gain 80 2)) - value(vout cross(dc_gain 80 1)))
swing @ 60dB = (value(vout cross(dc_gain 60 2)) - value(vout cross(dc_gain 60 1)))

```

### 4.3 (dc) CM input range

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-19-45-33_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-41-48_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div> -->

### 4.4 (ac) UGF and PM

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-44-51_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-45-28_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

顺便看一下运放在不同负载电容下的频率响应：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-48-14_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

### 4.5 (tran) slew rate

SR 是 large-signal 下的非线性行为，将输入信号设置为幅度较大的 step signal, 运行仿真，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-52-34_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

顺便看一下不同幅度 step 信号下的 SR 情况 (幅度需足够大以使运放进入 slewing 状态):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-55-26_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

``` bash
SR+ = slewRate(vout 0 t 7e-07 t 20 80 nil "time")
SR- = slewRate(vout 7e-07 t 20e-07 t 20 80 nil "time")
```


### 4.6 (tran) step response


将 vout 和 vin- 短接，设置输入信号为幅度足够小的 step signal, 考察运放的 (small-signal) step response, 看看相位裕度和增益裕度是不是“真的”, 并且计算运放的 settling time 和 overshoot:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-57-59_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-15-59-55_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

``` bash
# 注意 settlingTime 返回的是横坐标 (时间), 还需要减去 step 信号起始点才是 settling time
setting time @ 0.05% (rising) = (settlingTime(vout 0 t 7e-07 t 0.05 nil "time") - 2e-07)
setting time @ 0.05% (falling) = (settlingTime(vout 7e-07 t 20e-07 t 0.05 nil "time") - 7e-07)
overshoot (%) (rising) = overshoot(vout 0 t 7e-07 t)
overshoot (%) (falling) = overshoot(vout 7e-07 t 2e-06 t)
```


注：在两极点二阶系统中, PM 与 overshoot 的关系如下图 (from [this slide](https://pallen.ece.gatech.edu/Academic/ECE_6412/Spring_2003/L240-Sim&MeasofOpAmps(2UP).pdf)):

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-14-51-55_Relationship Between GBW and fp2 in a Two-Order System.png"/></div>


### 4.7 (ac) CMRR, PSRR

<!-- 
考虑文章 [A Practical AC Simulation Method in Cadence Virtuoso](<AnalogIC/A Practical AC Simulation Method in Cadence Virtuoso.md>) 中提出的电路，同时仿真 $A_{DM-DM},\ A_{CM-DM}$ 和 $\mathrm{CMRR} = \frac{A_{DM-DM}}{A_{CM-DM}}$:
 -->

Vin_CM = 900 mV 时的 CMRR:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-16-44-08_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-16-39-39_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

不同 Vin_CM 时的 CMRR:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-16-43-12_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>


Vin_CM = 900 mV 时的 PSRR:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-16-53-24_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-16-56-35_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

不同 Vin_CM 时的 PSRR: 这里遇到了 ac 仿真不收敛的问题 (如下图)，该如何解决？

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-17-06-17_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>



### 4.8 (noise) input noise

有关运放噪声的内容可以参考文章 [EDN: Designing with a complete simulation test bench for op amps, Part 4: Noise](https://www.edn.com/designing-with-a-complete-simulation-test-bench-for-op-amps-part-4-noise/)。

在这里，我们将运放配置为 unit buffer, 对其 input-referred noise (等效输入噪声) 进行仿真。 `Output Noise` 选择为 `voltage`, 设置 `Positive Output Node` 为输出电压 `Vout`, `Negative Output Node` 设置为 `gnd`, `Input Noise` 选择为 `voltage`, `input voltage source` 选择提供 Vin_CM 的电压源。

结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-17-37-18_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-17-37-02_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-17-48-06_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-17-50-22_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>


上图中的 total noise 和 RMS noise 定义如下：

$$
\begin{gather}
\mathrm{Total\ Noise} = \int_{f_1}^{f_2} V_{noise}^2 \ \mathrm{d}f,\quad 
\mathrm{RMS\ Noise} = \sqrt{\mathrm{Total\ Noise}} = \sqrt{\int_{f_1}^{f_2} V_{noise}^2 \ \mathrm{d}f}
\end{gather}
$$


另外，在 ADE L 中进行噪声仿真时，可以通过 `results > print > noise summary` 查看噪声单频点噪声或者积分噪声，并且可以看到电路中各元器件对噪声贡献的排序。具体操作为：点击 `Result > Print > Noise Summary`，`Type` 选择 `spot noise`，且 `noise unit` 为 `(V)`，选 `include all`，并选择 `Truncate by number, top 10` (想看前几个噪声贡献就填几)。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-17-52-15_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>


各噪声类型的定义如下：

<div class='center'>

| Parameter | Definition |
|:-:|:-:|
|fn	  | Flicker noise                                           |
|id	  | Thermal noise from the resistive drain current noise    |
|igd  | Gate-to-drain tunneling current noise                   |
|igs  | Gate-to-source tunneling current noise                  |
|igb  | Gate-to-bulk tunneling current noise                    |
|rn	  | Resistor thermal noise                                  |
|rs	  | Source parasitic resistor thermal noise                 |
|rd	  | Drain parasitic resistor thermal noise                  |
|rbdb | Resistor thermal noise between dbNode and bNode         |
|rbpb | Resistor thermal noise between bNode and bNodePrime     |
|rbpd | Resistor thermal noise between Bulk and dbNode          |
|rbps | Resistor thermal noise between bulk and bNode prime     |
|rbsb | Resistor thermal noise between sbNode and bNode         |
|rgbi | Gate Bias-Independent Resistor thermal noise            |
</div>

大多数情况下只会接触到 MOS 管电流热噪声 `id`、电阻热噪声 `rn` 和闪烁噪声 `rn`。


### 4.9 (mc) input offset

仿真步骤参考了 [Analog-Life > 使用 Cadence IC617 的蒙特卡洛仿真器仿真单端运放的失调电压 – ](https://www.analog-life.com/2022/05/montecarlo-simulation-for-amp-on-cadence-ic617/) 和 [知乎 > 蒙特卡洛 (Monte Carlo) 仿真方法](https://zhuanlan.zhihu.com/p/669731621)。

<!-- 
仿真步骤参考 [知乎 > 蒙特卡洛 (Monte Carlo) 仿真方法](https://zhuanlan.zhihu.com/p/669731621)。
 -->

下面进行 Monte Carlo 仿真，具体步骤如下：

0. 首先 <span style='color:red'> 将电路中的管子、电阻和电容改成相应的 mismatch 器件，不同的工艺管子类型不同，如 simc 中 MOS 管为 ckt, tsmc 中 MOS 管为 mis </span> (例如 `nmos2v` 换为 `nmos2v_mis`)
1. 将运放配置为 unit buffer
2. 修改 model library 中相应管子的类型，(以 tsmc 为例) 也即将 `tt_rfmos` 改为 `mc_rfmos`，保存 ADE L state, 如 xxx_stage_mc
3. 打开 `ADE XL `，在菜单栏 `Run > Monte Carlo Sampling` 中进行设置，如下所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-18-37-05_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>


5. 点击 `Run Simulation` 开始仿真 (设置完成后通常会自动开始仿真)
6. 仿真完成后，选择 `Results > Post Processing Operations for Monte Carlo > Histogram > outputs > plot` 即可。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-19-07-19_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-19-08-12_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-19-13-40_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

注：
- 蒙特卡洛分析服从正态分布，只是对数值进行统计，并无正确错误之说；
- 一般蒙卡只进行前仿；
- “步骤4” 中 number of points 不能低于 30，否则数量太少会导致 model 出错，尽量多些，如 100/200/1000 等。

ADL XL 会自动保存最近几次 (默认 10 次) 的仿真数据，要查看之前的数据，只需在左侧 `Data View > 右键某次数据 > View Results` 即可。 


## 5. Conner Simulation

这一小节进行运放 ac frequency response 的工艺角仿真。

工艺角中的 ss, tt, ff 分别是指左下角、中心、右上角的 corner. 它们的含有如下：

| **工艺角** | **NMOS** | **PMOS** | **主要影响** | **典型用途** |
|------------|---------|---------|-------------|-------------|
| **tt** | 典型 | 典型 | 基准性能 | 标准验证 |
| **ss** | 慢 | 慢 | 高延迟、低功耗 | 最坏时序分析 |
| **ff** | 快 | 快 | 低延迟、高功耗 | 信号完整性 |
| **sf** | 慢 | 快 | NMOS 弱、PMOS 强 | 电平转换问题 |
| **fs** | 快 | 慢 | NMOS 强、PMOS 弱 | 竞争条件分析 |


打开 `ADE XL > Data View > Corners > Add Model Files > Import From Tests > Add New Corner (温度计) > choose corner (可以多点几次温度计) > rename corner test` 进行设置。设置完成后，点击 `Run Simulation` 开始仿真，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-23-53-43_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.png"/></div>

可以看到，除了 dc gain 在 ff 工艺角下只有 79.7 dB, 其他指标都很好地满足了 specs 要求。

## 6. Design Summary

本文设计的运放非常好地满足了各项指标要求，其主要性能如下：

<div class='center'>

| Parameter | Value |
|:-:|:-:|
 | DC gain              |  84.35 dB @ Vin_CM = 0.9 V |
 | Output swing         | 0.881 V @ -3dB drop <br> 0.985 V @ 80dB gain <br> 1.38 V @ 60dB gain |
 | IMCR                 | (0.481 V, 1.568 V) =  1.087 V @ 80dB gain <br> (0.456 V, 1.697 V) = 1.242 V @ 60dB gain |
 | UGF                  | 55.75 MHz @ Vin_CM = 0.9 V |
 | PM                   | 64.46° @ Vin_CM = 0.9 V |
 | GM                   | 19.31 dB @ Vin_CM = 0.9 V |
 | Slew rate            | +56.31 V/us, -45.35 V/us |
 | Overshoot (r, f)     | (5.40 %, 6.17 %) @ 100 mV step <br> (3.23 %, 3.90 %) @ 200 mV step |
 | Settling time (r, f) | (53.48 ns, 57.07 ns) @ 0.05% (100 mV step) |
 | CMRR_dc              |  86.02 dB @ Vin_CM = 0.9 V |
 | PSRR_dc              |  81.25 dB @ Vin_CM = 0.9 V |
 | Input-referred noise | 60.68 nV/√Hz @ 1 kHz |
 | RMS noise            | 108.69 uV @ 10 Hz to 10 GHz |
 | Input offset voltage | +643.98 uV, sigma = 1.249 mV |
 | Power dissipation    | 690.2 uA @ Vin_CM = 0.9 V (1.242 mW) |
</div>

下表是仿真值与指标要求的对比：

<div class='center'>

<span style='font-size:12px'> 


| Type | DC Gain | GBW | PM | Slew Rate | CM Input Range | Output Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Specifications     | 80 dB | 100 MHz | 60° | 50 V/us | 0.5 V to 1.5 V | 1.0 V |  1 mA @ 1.8V (1.8 mW) |
 | Simulation Results | 84.3461 dB | 55.75 MHz | 64.46° | +56.31 V/us, -45.35 V/us | 0.481 V to 1.568 V @ 80dB <br> 0.456 V to 1.697 V @ 60dB | 0.881 V @ -3dB <br> 0.985 V @ 80dB <br> 1.38 V @ 60dB | 690.2 uA @ 1.8V (1.242 mW) |

</span>
</div>