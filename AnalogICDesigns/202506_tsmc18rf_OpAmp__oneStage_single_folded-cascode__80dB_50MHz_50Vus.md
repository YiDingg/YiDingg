# A Single-Ended Output Folded-Cascode Op Amp Achieving 81.33dB Gain, 51.59MHz GBW and 35.22V/us SR

> [!Note|style:callout|label:Infor]
> Initially published at 17:12 on 2025-06-11 in Beijing.

## 0. Introduction

本文，我们借助 [gm-Id](<AnalogIC/Virtuoso Tutorials - 5. An Introduction to gm-Id Methodology.md>) 方法，使用台积电 180nm CMOS 工艺库 `tsmc18rf` 来设计一个 **pmos-input single-ended output folded-cascode op amp** 。暂时只作前仿练习，未进行 layout 和 post-layout simulation, 之后如果有需求再补上这一部分。


运放主要指标如下：

<div class='center'>

| DC Gain | GBW | Load | PM | SR | Input CM | Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 80 dB | 50 MHz | 5 pF | 60° | 50 V/us | - 0.1 V ~ + 1.2 V | 1 V | 600 uA @ 1.8V (1.08 mW) |
</div>

主要优化方向为 UGF (unit gain frequency), 齐次是 DC Gain.

## 1. Design Considerations

<!-- ### 1.0 Design Specifications


<div class='center'>

| DC Gain | GBW | Load | PM | SR | Input CM | Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 80 dB | 50 MHz | 5 pF | 60° | 50 V/us | - 0.1 V ~ + 1.2 V | 1 V | 600 uA @ 1.8V (1.08 mW) |
</div> -->

### 1.1 theoretical formulas

理论参考公式如下 (2025.06.11), 后续如有更新会放在 [Design Sheet for Folded-Cascode Op Amp](<AnalogICDesigns/Design Sheet for Folded-Cascode Op Amp.md>):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-17-31-39_Design Sheet of Folded-Cascode Op Amp.png"/></div>



### 1.2 biasing circuits

$V_{b3}$ 和 $V_{b4}$ 的偏置由常规的 current mirror 即可实现，$V_{b1}$ 和 $V_{b2}$ 的偏置可以由同一个 biasing 支路生成。具体而言，用两个 PMOS Mb9 和 Mb7 串联成一个等效晶体管，将此晶体管 diode-connected 以生成 $V_{b2}$，并在 drain 内或外部添加电阻以生成 $V_{b1}$，可以参考下图（下图的性能不好，不要抄尺寸）：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-18-18-57_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>


### 1.3 satisfying specs


在考虑如何满足 Specifications 之前，需要对当前工艺的 NMOS/PMOS 性能有大致的了解，建议先在 cadence 中对需要用到的晶体管进行仿真，了解各性能参数范围，再考虑 "Satisfying Specifications":
- 若无特别说明, NMOS 的 bulk 都接到 GND, PMOS 的 bulk 都接 source (以避免 body-effect 导致的阈值电压上升)
- 先考虑 `SR` 和 `UGF`, 因为这两个参数可以直接确定电路的 $I_D$ 和输入管的 $g_m$
- `SR > 50 V/us` : 
    - $\mathrm{SR} = \min \{ \frac{I_{SS}}{C_L},\ \frac{I_{D5}}{C_L} \}$, 不妨令两者相等, 则 $\mathrm{SR} = \frac{I_{SS}}{C_L} = \frac{I_{D5}}{C_L} \Longrightarrow I_{SS} = I_{D5} > \mathrm{SR}\cdot C_L = 250 \ \mathrm{uA}$
    - 主电路需要消耗 $2\,I_{SS}$, 偏置电路共需要 3 路 $I_{REF}$ (一路生成 $V_{b1}$ 和 $V_{b2}$, 剩下两路分别生成 $V_{b3}$, $V_{b4}$), 不妨令 $I_{REF} = 8 I_{SS}$ 以方便 layout 工作，总 600 uA 最大可以有 252.6316 uA 的 $I_{SS}$, 因此我们令 $I_{SS} = 250 \ \mathrm{uA}$
- `UGF > 50 MHz` :
    - $\mathrm{UGF} \approx \mathrm{GBW} = \frac{g_{m1}}{2\pi C_L} > 50 \ \mathrm{MHz}$, 我们令 GBW = 55 MHz, 则 $g_{m1} = 1.5708 \ \mathrm{mS} = \frac{1}{636.6\ \mathrm{\Omega}}$, 这里的 $g_{m1}$ 与上面 `SR` 中的 $I_{SS}$ 共同决定了 M1, M2 的 $\left(\frac{g_m}{I_D}\right)$
    - $\left(\frac{g_m}{I_D}\right)_{1,2} = \frac{1.5708 \ \mathrm{mS}}{0.5 \times 250 \ \mathrm{uA}} = 1.5708 \times 8 = 12.5664 \approx 12.57$

对于直流增益，需要多大的 self gain 和 rout 才能满足增益要求呢？看下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-11-17-52-53_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

- `DC Gain > 80 dB` : 用近似公式 $A_v \approx g_{m1} \cdot \left( \left[ g_{m3}r_{O3}  (r_{O1}\parallel r_{O5}) \right] \parallel \left[ g_{m7}r_{O7} r_{O9} \right] \right)$ 来分配 DC Gain, 具体如下：
    - 可以考虑 <span style='color:red'> M7, M8 的 bulk 接 VDD </span> 以利用 body-effect 提高 DC Gain (尽管这会降低 swing), 仿真后如果发现 swing 确实偏小, 再改为连接 source (牺牲增益换摆幅)
    - 考虑上图的第二种方案 (84 dB), 也即 $A_3 = 300,\ r_{O1} = 100 \ \mathrm{k}\Omega,\ r_{O5} = 100 \ \mathrm{k}\Omega,\ A_7 = 350,\ r_{O9} = 100 \ \mathrm{k}\Omega$
- `PM > 60°` : 
    - 近似以 mirror pole 为 $f_{p2}$, 则有 $f_{p2} = \frac{g_{m9}}{2 \pi C_Z}$
    - $C_Z$ 由 M3, M7, M9 和 M10 贡献
    - 可以适当增大 $g_{m9}$ 以提高 PM (即使这会降低 M9 的匹配性)
- `Input CM = -0.1 V ~ +1.2 V` : 
    - <span style='color:red'> PMOS M1 和 M2 的 bulk 接到 source </span> 以避免 body-effect, 提高共模输入范围
    - M11 的 overdrive 应尽量小，以增大输入共模范围，对 M11 的 $A,\ f_T$ 等要求不高，因此可以取较小的 overdrive
- `Swing > 1 V` : 
    - 先将 M5, M6 作为增大摆幅的主要方式，使其 overdrive 尽量小，以增大输出摆幅和共模输入范围，同时
    - 如果最终摆幅仍不够, 可令 M3, M4, M7 ~ M10 在满足 $g_mr_O$ 的要求下，牺牲部分增益以减小 overdrive

### 1.4 summary

上面的考虑可汇总为以下几条：
- 除 M5, M6 和 M11 Id = 250 uA 以外, 其它晶体管的 Id 都为 125 uA
- 所有 NMOS (M3 ~ M6) 的 bulk 连接 GND, PMOS bulk 默认连接 source
- (P) M1, M2 : gm/Id = 12.5664, gm > 1.5708 mS, rout > 100k
- (N) M3, M4 : A = 300, 先考虑 gm/Id = 12 (小面积意味着高 gm/Id)
- (N) M5, M6 : rout > 100k, low Vdsat (200 mV), 其次是小面积以降低 drain 端电容
- (P) M7, M8 : A = 350, 优化 overdrive <span style='color:red'> bulk 连接 VDD 以提高增益 </span>
- (P) M9, M10 : rout > 100k, 优化 overdrive, 先不提高 gm (仿真 PM 后再考虑)
- (P) M11 : 低 overdrive (150 mV), rout > 50k 以保持 CMRR


## 2. Design Details

### 2.1 (P) M1, M2


- (P) M1, M2 : gm/Id = 12.5664, gm > 1.5708 mS, rout > 100k

在 **<span style='color:red'> Vds = 450 mV </span>** 条件下进行仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-11-18-35-21_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

$$
\begin{gather}
I_{nor} = 0.6 \ \mathrm{u} \Longrightarrow a = \frac{I_{D1}}{I_{nor}} = \frac{125 \ \mathrm{uA}}{0.6 \ \mathrm{uA}} = 208.3333 \\
\end{gather}
$$

令 $a = 210$, 扫描 L from 0.36u to 3.6u, 查看 gm 和 rout 结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-11-18-42-58_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

gm 无法满足要求，增大 a 至 240 再次扫描：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-11-18-47-15_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

依上图结果，选择 L = 1.20u, 则晶体管预计参数为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_{1,2} = 240 = \frac{288 \ \mathrm{um}}{1.20 \ \mathrm{um}},\quad \frac{g_m}{I_D} = 12.5664,\quad g_m = 1.69 \mathrm{mS},\quad r_{out} = 130 \ \mathrm{k}\Omega \\
\end{gather}
$$


### 2.2 (N) M3, M4

- (N) M3, M4 : A = 300, 先考虑 gm/Id = 12 (小面积意味着高 gm/Id)


更小的 Vds 意味着更大的 output swing, 因此可以考虑 vds = 225mV 或者 vds = 350mV.

a = aspect ratio 对 self gain 基本没有影响 (经验), 所以可以取得很小。长宽范围限制是 L from 0.18u to 20u, W from 0.22u to 900u. 分别设置 vds = 350mV 和 vds = 450 mV, 扫描 L from 0.36u to 3.6u (a = 50) 对应的 self gain:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-11-21-03-20_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-11-21-01-42_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

350 mV 还差一点，到 450 mV 已经可以很好地满足要求了。为保持较小的晶体管长度，我们选取 $\frac{g_m}{I_D} = 12$, 在 $I_{nor}$ vs. $\frac{g_m}{I_D}$ 图像中对应 $I_{nor} = 3.75 \ \mathrm{uA} $, 并且选取 $L = 2.5 \ \mathrm{um}$。则有：

$$
\begin{gather}
a = \frac{125 \ \mathrm{uA}}{3.75 \ \mathrm{uA}} = 33.33
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-11-23-40-22_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>


此时晶体管的预估参数为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_{3,4} = \frac{80 \ \mathrm{um}}{2.5 \ \mathrm{um}} = 32,\quad \frac{g_m}{I_D} = 12,\ g_m r_O = 350
\end{gather}
$$



### 2.3 (N) M5, M6

- (N) M5, M6 : rout > 100k, low Vdsat (200 mV), 其次是小面积以降低 drain 端电容


作为 current source 管, M5 和 M6 工作基本上在 350 mV 以下，不妨在 Vds = 350 mV 条件下进行设计。查看 Vdsat 和 rout 数据：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-11-23-50-25_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

$\frac{g_m}{I_D}$ 至少为 6.8 才能满足 Vdsat < 200 mV, 至少为 8.4 才能使 rout > 100k. 我们令 $\frac{g_m}{I_D} = 9$, 得到晶体管长宽比：

$$
\begin{gather}
I_{nor} = 6.5 \ \mathrm{uA} \Longrightarrow a = \frac{250 \ \mathrm{uA}}{6.5 \ \mathrm{uA}} = 38.46 \\
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-11-23-51-52_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

然后就是选取满足指标的 $L$，$L$ 需尽量小以改善高频特性。令 a = 40 进行扫描，结果如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-11-23-57-46_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

发现 rout 不够大，于是将 $\frac{g_m}{I_D}$ 改为 11, 对应 $I_{nor} = 4.65 \ \mathrm{uA}\Longrightarrow a = 53.7634$. 令 $a = 55$ 进行扫描：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-00-03-56_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

选择 $L = 3.6 \ \mathrm{um}$, 虽然没有完全满足 rout 要求，但也足够了。此时晶体管的预估参数为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_{5,6} = \frac{200 \ \mathrm{um}}{3.6 \ \mathrm{um}} = 55.5556,\quad \frac{g_m}{I_D} = 11,\ r_{out} = 75 \ \mathrm{k}\Omega,\ V_{dsat} = 180 \ \mathrm{mV}
\end{gather}
$$



### 2.4 (P) M7, M8

- (P) M7, M8 : A = 350, 优化 overdrive

在 Vds = 350 mV 下进行仿真。作为增益管，可以直接考虑 $\frac{g_m}{I_D} = 12$, 对应 $I_{nor} = 0.67 \ \mathrm{uA}$, 则：

$$
\begin{gather}
a = \frac{125 \ \mathrm{uA}}{0.67 \ \mathrm{uA}} = 186.5672
\end{gather}
$$

令 $a = 190$ 进行仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-00-14-35_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

发现 gm/Id = 12 到不了 350 的增益，于是提高到 $\frac{g_m}{I_D} = 13$, 对应 $I_{nor} = 0.52 \ \mathrm{uA}\Longrightarrow a = 240.3846$。令 $a = 240$ 进行仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-00-16-35_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>


选取 $L = 2.5 \ \mathrm{um}$ 以基本满足增益需求，此时晶体管预估参数为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_{7,8} = \frac{600 \ \mathrm{um}}{2.5 \ \mathrm{um}} = 240,\quad \frac{g_m}{I_D} = 13,\ g_m r_O = 300
\end{gather}
$$






### 2.5 (P) M9, M10

- (P) M9, M10 : rout > 100k, 优化 overdrive, 先不提高 gm (仿真 PM 后再考虑)

作为 load 管, gm/Id 也是稍微小一些更好。 Vds 虽说可以调节，但是与输出摆幅直接挂钩，因此基本不会超过 300 mV. 考虑 Vds = 350 mV 的条件下进行仿真，取 $\frac{g_m}{I_D} = 11$, 对应 $I_{nor} = 0.83 \ \mathrm{uA}\Longrightarrow a = 150.6024$，令 $a = 150$ 扫描 length:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-00-23-15_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

选择 $L = 1.5 \ \mathrm{um}$ 以弥补刚刚增益管稍低的 self gain, 此时晶体管的预估参数为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_{9,10} = \frac{225 \ \mathrm{um}}{1.5 \ \mathrm{um}} = 150,\quad \frac{g_m}{I_D} = 11,\ r_O = 135 \ \mathrm{k}\Omega
\end{gather}
$$



### 2.6 (P) M11

- (P) M11 : 低 overdrive (150 mV), rout > 50k 以保持 CMRR

这个晶体管的要求就相对宽松一些，先在 Vds = 350 mV 下看看 overdrive 对 gm/Id 的要求：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-00-27-20_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

令 $\frac{g_m}{I_D} = 11$, 对应 $I_{nor} = 0.82 \ \mathrm{uA} \Longrightarrow a = 304.8780$， 令 $a = 300$ 扫描 rout:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-00-29-51_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

a 已经达到 300 所以 length 不可能太大，选取 $L = 1.5 \ \mathrm{um}$，则晶体管参数为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_{11} = \frac{450 \ \mathrm{um}}{1.5\ \mathrm{um}} = 300,\quad \frac{g_m}{I_D} = 11,\ r_O = 65 \ \mathrm{k}\Omega
\end{gather}
$$

### 2.7 Summary

上面各晶体管的参数汇总如下：

<div class='center'>

| MOSFET | W/L | a | gm/Id |
|:-:|:-:|:-:|:-:|
| M1, M2 | 288/1.2 | 240 | 12.57 |
| M3, M4 | 80/2.5 | 32 | 12 |
| M5, M6 | 200/3.6 | 55.6 | 11 |
| M7, M8 | 600/2.5 | 240 | 13 |
| M9, M10 | 225/1.5 | 150 | 11 |
 | M11 | 450/1.5 | 300 | 11 |
</div>

## 3. Design Iteration

### 3.1 dc: operation point



先令 R = 0, 进行 dc 仿真，查看各晶体管直流工作点。具体而言，设置 $V_{in+} = V_{in,CM} + \frac{1}{2}V_{in,DM}$, $V_{in-} = V_{in,CM} - \frac{1}{2}V_{in,DM}$ 进行仿真：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-01-33-11_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-00-45-15_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-01-33-27_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

- M5, M6 由于 Vds 较低 (300 mV) 导致 rout 偏低以外
- M9, M10 由于 Vds 较低 (230 mV) 导致 rout 偏低
- 其余晶体管的工作点都在预期范围内

$V_{b1}$ 和 $V_{b2}$ 只能调节电路的输入输出摆幅/范围, M9, M10 的 Vds 基本已无法再调整。

### 3.2 dc: io-range and gain

扫描一下 io-curve 并求出 dc gain, 调节 R 和 frac 的值使输出摆幅和增益在合适的范围内：

``` bash
vout = VS("/Vout")
dc_gain = dB20(deriv(VS("/Vout")))
max dc gain = ymax(dB20(deriv(VS("/Vout"))))
swing @ 80dB = (value(vout cross(dc_gain 80 2)) - value(vout cross(dc_gain 80 1)))
swing @ 60dB = (value(vout cross(dc_gain 60 2)) - value(vout cross(dc_gain 60 1)))
```
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-01-27-55_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-01-29-30_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

由上图，综合 max dc gain, swing @ 80dB 和 swing @ 60dB 三个参数，选择 $R = 2 \ \mathrm{k}\Omega$、$\mathrm{frac} = 0.4$. 重新进行 operation point 仿真，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-01-36-52_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

此时的输入输出曲线如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-01-42-53_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>


### 3.3 dc: CM input range

以“max dc gain” 下降到 80 dB 或 60dB 为准，查看输入共模范围：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-01-47-12_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

CM input range = (-0.047 V, +1.201 V) 1.2480 V @ 80dB, 或者 = (-0.173 V, +1.345 V) 1.5180 V @ 60dB, 基本符合我们对输入共模范围的要求。

### 3.4 ac: UGF and PM

为 schematic 创建 symbol, 运行 ac 仿真以查看频率响应：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-11-27-48_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-13-15-57_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-11-30-34_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-02-10-14_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
 -->

``` bash
UGF = cross(dB20(VF("/Vout")) "0" 1 "either" nil nil nil)
PM = value(phase(VF("/Vout")) cross(dB20(VF("/Vout")) 0))
GM = value(dB20(VF("/Vout")) cross(phase(VF("/Vout")) 0))
GBW @ 80dB = value(abs(VF("/Vout")) cross(dB20(VF("/Vout")) 80 1))*cross(dB20(VF("/Vout")) 80 1)
GBW @ 60dB = value(abs(VF("/Vout")) cross(dB20(VF("/Vout")) 60 1))*cross(dB20(VF("/Vout")) 60 1)
```

图中可以看出：
- GM = 32 dB, 但 PM 仅有 31.5°，需要优化
- UGF 和 GBW 都明显低于 50 MHz, 需要优化
- 频响曲线含有三个极点和一个左半平面零点，并且第二、三极点和零点的位置比较接近


### 3.5 improve UGF and PM

#### 3.5.1 scaling M7 

为了提高 UGF 和 PM, 可以考虑以下几种方式：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-11-42-20_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

回到 **3.1 dc: operation point** 一节看看哪一个晶体管的 fug 最低，作为重点优化对象。发现 M7 的 fug 仅有 28.3 MHz, 其它管子的 fug 基本都在 100 MHz 以上，于是考虑先对 M7 进行优化。保持 $a_7$ 不变 (等价于 $\frac{g_m}{I_D}$ 不变)，减小 $L$ (同步减小 $W$) 以改善频率响应，不妨扫描原尺寸的 0.1 ~ 1, 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-11-52-12_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

选取 scaling factor 为 0.4, 对应 Gain = 83.2 dB, UGF = 38.27 MHz, GM = 31.68 dB, 以及 PM = 51.13°，此时 M7 长宽变为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_7 =  \left(\frac{0.4 \times W}{0.4 \times L}\right)_{7,orig} = \frac{240 \ \mathrm{um}}{1 \ \mathrm{um}} = 240
\end{gather}
$$

重新仿真 opt (operation point) 和 frequency response:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-11-58-01_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-12-57-07_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-12-05-36_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

现在，一方面，我们希望继续提升 PM 至 60° 以上，这可以通过缩放 fug 最小的 M5, M9 两对晶体管来实现 (fug_5 = 107 MHz, fug_9 = 97 MHz)；另一方面，我们还希望尽量提高 UGF 和 GBW, 可以通过增大输入管 M1 的 gm 来做到，但是注意会使 PM 明显下降 (因为次极点位置基本不变)。

具体而言，对于 M1, 要想在保持其它参数基本不变的情况下来提高 $g_m$, 需要增大 $\frac{g_m}{I_D}$，这等价于增大 $a = \frac{W}{L}$ (因为 $I_D$ 不变)。这会使 GBW 和 DC Gain 同时增大，但是 PM 会下降。

综合来考虑，我们有两种方案：
- 第一种方案：只 “缩放 M5, M9”，牺牲增益来换取更高的 UGF 和 PM 
- 第二种方案：在第一步 “缩放 M5, M9” 时多牺牲一点点 DC Gain (真的只是一点点, 因为 gm/Id 无法太大) 以换取更高的 PM, 以便在第二步 “增大 $g_{m1}$” 时用 PM 来换回 DC Gain 和 UGF. 

#### 3.5.2 solution 1

现在，先尝试第一种方案：只 “缩放 M5, M9”，牺牲增益来换取更高的 UGF 和 PM. 设置 Vin_CM = 800 mV, 扫描 co (scaling factor) from 0.2 to 1, 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-13-02-39_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

不妨选择 cor = 0.5 作为 solution 1 的结果，对应 Gain = 81.22 dB, UGF = 45.69 MHz, GM = 29.71 dB 以及 PM = 61.53°. 此时晶体管 M5, M9 的参数变为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_5 =  \left(\frac{0.5 \times W}{0.5 \times L}\right)_{5,orig} = \frac{100 \ \mathrm{um}}{1.8 \ \mathrm{um}} = 55.56
\\
\left(\frac{W}{L}\right)_9 =  \left(\frac{0.5 \times W}{0.5 \times L}\right)_{9,orig} = \frac{112.5 \ \mathrm{um}}{0.75 \ \mathrm{um}} = 150
\end{gather}
$$

重新仿真 opt (operation point) 和 frequency response:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-13-12-14_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-13-08-00_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

#### 3.5.2 solution 2

作为 solution 2 的选择，我们取 co = 0.35, 对应 Gain = 79.67 dB, UGF = 46.36 MHz, GM = 18.59 dB 以及 PM = 65.76°。然后保持 M1 的长度不变，增大 a = W/L 以提高 $\frac{g_{m}}{I_D}$, 等价地提高 $g_{m1}$. 扫描 a from 200 to 400 的结果如下 (原始值 240):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-13-23-26_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

图中可以看到, a1 = 320 ~ 360 是一个比较好的范围，于是取 a1 = 340, 又 co = 0.35, 晶体管的尺寸为：

$$
\begin{gather}
\left(\frac{W}{L}\right)_5 =  \left(\frac{0.35 \times W}{0.35 \times L}\right)_{5,orig} = \frac{70 \ \mathrm{um}}{1.26 \mathrm{um}} = 55.56
\\
\left(\frac{W}{L}\right)_9 =  \left(\frac{0.35 \times W}{0.35 \times L}\right)_{9,orig} = \frac{78.75 \ \mathrm{um}}{0.525 \mathrm{um}} = 150
\\
\left(\frac{W}{L}\right)_1 =  \frac{340 \times 1.2 \ \mathrm{um}}{1.2 \ \mathrm{um}} = \frac{408 \ \mathrm{um}}{1.2 \ \mathrm{um}} = 340
\end{gather}
$$

**<span style='color:red'> 作规整化，令上面三个晶体管的尺寸分别为： </span>**

$$
\begin{gather}
\left(\frac{W}{L}\right)_5 = \frac{70 \ \mathrm{um}}{1.26 \mathrm{um}} = 55.56,\quad 
\left(\frac{W}{L}\right)_9 = \frac{80 \ \mathrm{um}}{0.53 \mathrm{um}} = 150.94,\quad 
\left(\frac{W}{L}\right)_1 = \frac{408 \ \mathrm{um}}{1.2 \ \mathrm{um}} = 340
\end{gather}
$$

进行 opt (operation point) 和 frequency response 仿真：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-13-34-10_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-13-39-24_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

基本上很好地满足了我们的设计要求。

## 4. Simulation Results

### 4.1 dc: operation point

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-13-34-10_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>


### 4.2 dc: io-range and gain

``` bash
vout = VS("/Vout")
dc_gain = dB20(deriv(VS("/Vout")))
max dc gain = ymax(dB20(deriv(VS("/Vout"))))
swing @ -3dB = (value(vout cross(dc_gain, max_dc_gain-3, 2)) - value(vout cross(dc_gain, max_dc_gain-3, 1)))
swing @ 80dB = (value(vout cross(dc_gain 80 2)) - value(vout cross(dc_gain 80 1)))
swing @ 60dB = (value(vout cross(dc_gain 60 2)) - value(vout cross(dc_gain 60 1)))

```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-14-03-29_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>


### 4.3 dc: CM input range

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-14-19-26_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>


### 4.4 ac: UGF and PM

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-13-39-24_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

顺便看一下运放在不同负载电容下的频率响应，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-14-18-17-58_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>


### 4.5 tran: slew rate

SR 是 large-signal 下的非线性行为，将输入信号改为幅度较大的 step signal, 运行仿真，结果如下：



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-19-31-09_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-19-48-07_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-19-51-01_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

``` bash
SR+ = slewRate(vout 0 t 7e-07 t 20 80 nil "time")
SR- = slewRate(vout 7e-07 t 20e-07 t 20 80 nil "time")
```

图中可以看到，运放的 SR 为 +32.58 V/us 和 -35.22 V/us, 这与设计的 50 V/us 相差较大，具体原因有待进一步探究。

### 4.6 tran: step response


将 vout 和 vin- 短接，设置输入信号为幅度足够小的 step signal, 考察运放的 small-signal step response, 看看相位和增益裕度是不是“真的”, 并且计算运放的 settling time 和 overshoot:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-19-38-03_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-19-56-19_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>

``` bash
# 注意 settlingTime 返回的是横坐标 (时间), 还需要减去 step 信号起始点才是 settling time
setting time @ 0.05% (rising) = (settlingTime(vout 0 t 7e-07 t 0.05 nil "time") - 2e-07)
setting time @ 0.05% (falling) = (settlingTime(vout 7e-07 t 20e-07 t 0.05 nil "time") - 7e-07)
overshoot (%) (rising) = overshoot(vout 0 t 7e-07 t)
overshoot (%) (falling) = overshoot(vout 7e-07 t 2e-06 t)
```


``` bash
# 下面几个函数不好用, cadence calculator 有专门计算 settling time 和 overshoot 的函数
settling time @ 0.05% (rising) = cross(vout value(vout, 450n)*(1 + 0.05*0.01) 1 "falling" nil nil  nil ) - 200n
settling time @ 0.05% (falling) = cross(vout value(vout, 900n)*(1 - 0.05*0.01) 1 "rising" nil nil  nil ) - 700n
overshoot (%) (rising) = (ymax(vout)/value(vout, 450n) - 1)*100 / (value(vout, 0) - value(vout, 700n))
overshoot (%) (falling) = (ymin(vout)/value(vout, 900n) - 1)*100 / (value(vout, 700n) - value(vout, 900n))
```

<span style='color:red'> 为什么 SR 明显小于设计值？是输出节点实际 $C_L$ 约为 8.3 pF, 还是其它的什么原因？也有待进一步探究。 </span>

注：在两极点二阶系统中, PM 与 overshoot 的关系如下图 (from [this slide](https://pallen.ece.gatech.edu/Academic/ECE_6412/Spring_2003/L240-Sim&MeasofOpAmps(2UP).pdf)):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-14-51-55_Relationship Between GBW and fp2 in a Two-Order System.png"/></div>


## 5. Design Summary

本文设计的 **pmos-input single-ended output folded-cascode op amp** 基本满足了指标要求，其主要性能如下：

<div class='center'>

| Parameter | Value |
|:-:|:-:|
 | DC Gain | maximum 81.33 dB <br> 80.65 dB @ Vin = 0.8 V in unit buffer |
 | UGF | 51.59 MHz @ Vin = 0.8 V in unit buffer |
 | PM | 61.20° @ Vin = 0.8 V in unit buffer |
 | GM | 15.03 dB @ Vin = 0.8 V in unit buffer |
 | Output swing | 0.569 V @ -3dB drop <br> 0.895 V @ 60dB gain |
 | CM Input range | 1.120 V @ -3dB drop <br> 1.489 V @ 60dB gain |
 | Overshoot (r, f) | (3.415 %, 2.979 %) @ 10 mV step <br> (2.939 %, 0.957 %) @ 50 mV step |
 | Settling time (r, f) | (39.08 ns, 40.13 ns) @ 0.05% (50 mV step) |
 | Slew rate | +32.58 V/us, -35.22 V/us |
 | Power dissipation | 586 uA @ 1.8V (1.05 mW) |
</div>

下表是仿真值与指标要求的对比：

<div class='center'>

<span style='font-size:12px'> 


| Type | DC Gain | GBW | PM | Slew Rate | CM Input Range | Output Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Specifications | 80 dB | 50 MHz | 60° | 50 V/us | (-0.1 V, +1.2 V) | 1 V | 600 uA @ 1.8V (1.08 mW) |
 | Simulation Results | 81.33 dB | 51.59 MHz | 61.20° | +32.58 V/us <br> -35.22 V/us | 1.120 V @ -3dB drop <br> 1.489 V @ 60dB gain |  0.569 V @ -3dB drop <br> 0.895 V @ 60dB gain | 586 uA @ 1.8V (1.05 mW) |

</span>
</div>
