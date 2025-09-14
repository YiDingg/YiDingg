# 202509_tsmcN65_LDO__in-1d8-to-2d5_out-1d0

> [!Note|style:callout|label:Infor]
> Initially published at 23:11 on 2025-09-09 in Lincang.


## Introduction

本文是项目 [2025.09 Design of A Basic Low Dropout Regulator (LDO) for BB-PLL](<Projects/Design of A Basic Low Dropout Regulator (LDO) for BB-PLL.md>) 的附属文档，用于记录 LDO 的设计和前仿过程。

甲方给出的 LDO 设计指标如下：

<div class='center'><span style='font-size: 12px'>

| Parameter | Process | Supply Range | Output Voltage | Static Current | Settling Time | Overshoot | Linear Regulation | Load Regulation | PSRR |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| **Specification**   | TSMC 65nm CMOS | 1.710 V ~ 2.625 V | 1.2 V | not given | not given | not given | < -40 dB | not given | -40 dB @ 5 MHz |

</span>
</div>

## 1. Design Considerations

根据 [原始设计指标](https://www.123684.com/s/0y0pTd-FRSj3) 中的工艺角要求，我们定义此次设计的 all-corner/all-supply 条件为：
- all-corner = {(TT, 65°C), (SS, -40°C), (SS, 130°C), (FF, -40°C), (FF, 130°C), (FS, -40°C), (SF, 130°C)} 共七个工艺角
- all-supply = {1.70 V, 1.80 V, 2.50 V, 2.65 V} 共四个供电电压
- two-supply = {1.70 V, 2.65 V} 共两个供电电压

### 1.1 reference formulas

本次设计所用 LDO 架构及主要参考公式如下 (Design sheet for basic LDO)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-01-12-08_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0 copy.png"/></div>

注意 NMOS as the pass transistor 时，$V_{REF}$ 要接运放的 noninverting 端才是负反馈。

另外，有关 LDO 的环路稳定性分析和补偿机制见这篇文章 [LDO Stability Analysis and Loop Compensation Mechanism](<AnalogIC/LDO Stability Analysis and Loop Compensation Mechanism.md>)。

### 1.2 design considerations

- PMOS as the pass transistor: $V_{GS} \in (0, \ \mathrm{VDD})$
- NMOS as the pass transistor: $V_{GS} \in (-1.2 \ \mathrm{V}, \ \mathrm{VDD} - 1.2 \ \mathrm{V})$
由 design sheet 知道, NMOS 作为 pass transistor 时，LDO 的 linear regulation 性能更好 (PSRR 更好)，但由于 $V_{GS}$ 最高只能有 $(\mathrm{VDD} - 1.2 \ \mathrm{V}\mathrm{VDD} - 1.2 \ \mathrm{V})$，可能出现 maximum load current 不够的情况 (尤其是 VDD 很低时)。为解决这个问题，一种思路仍是使用 PMOS, 另一种思路是用 low VT or native VT NMOS.

无论哪一种，我们都可以先设计完运放再来做对比。方便起见，求解运放 specs 时我们参考 PMOS as the pass transistor 的相关公式。另外，按张老师的说法，运放的偏置电流 $I_{BIAS}$ 可以从 10 uA ~ 100 uA 任选，并且设定 maximum load current 为 15 mA 进行设计。


为了得到较合理的 load capacitance $C_L$，我们最好是先根据最大电流求解/估算一下 pass transistor 的尺寸 (W/L)。下面两个小节 **1.3 ~ 1.4** 就是在做这件事情。

### 1.3 nch_na25 as the PT



先考虑 nch_na25 的效果，其 $V_{GS,\max} = 1.7 \ \mathrm{V} - 1.2 \ \mathrm{V} = 0.5 \ \mathrm{V}$，仿真后查看此电压对应的 gm/Id, 进而得到 I_nor:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-01-05-26_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

图中可以看到：
$$
\begin{gather}
V_{GS} = 0.5 \ \mathrm{V} \Longrightarrow \left(\frac{g_m}{I_D}\right) = 2.355 \ \mathrm{S/A} \Longrightarrow I_{nor} = 33.31 \ \mathrm{uA} \sim 38.23 \ \mathrm{uA}
\\
I_{nor} \approx 35 \ \mathrm{uA} \Longrightarrow a = \frac{15 \ \mathrm{mA}}{35 \ \mathrm{uA}} = 42.857 \approx 45
\end{gather}
$$

并且 `nch_na25` 的最小 length 是 1.2 um, 为获得较好性能，我们起码选择 length = 2.0 um ~ 2.4 um, 于是晶体管的尺寸约为：

$$
\begin{gather}
\frac{W}{L} = 45 = \frac{90 \ \mathrm{um}}{2.0 \ \mathrm{um}} \sim \frac{108 \ \mathrm{um}}{2.4 \ \mathrm{um}}
\end{gather}
$$

<span style='color:red'> 这似乎有点太大了。 </span>  按照 [TN65CMSP018_1.0.pdf](<AnalogICDesigns/Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).md>) 给出的 2.5 V MOS scaling equation, 其等效电容值为 0.15 pF ~ 0.48 pF:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-01-22-48_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<span style='color:red'> 我们这里等效电容估的不是很好，不应该简单用 Miller effect 来算，实际等效负载肯定没有这么大，不过也能作个参考就是了。 </span>

### 1.4 pch_25 as the PT

再来看看 pch_25 的情况，其 $V_{GS,\max} = 1.7 \ \mathrm{V}$：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-01-28-55_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

图中可以看到：
$$
\begin{gather}
V_{GS} = 1.7 \ \mathrm{V} \Longrightarrow \left(\frac{g_m}{I_D}\right) = 0.918 \ \mathrm{S/A} \Longrightarrow I_{nor} = 13.89 \ \mathrm{uA} \sim 16.43 \ \mathrm{uA}
\\
I_{nor} \approx 15 \ \mathrm{uA} \Longrightarrow a = \frac{15 \ \mathrm{mA}}{15 \ \mathrm{uA}} = 100
\\
L = 0.5 \ \mathrm{um} \Longrightarrow W = a\times L = 50 \ \mathrm{um}
\end{gather}
$$

显然面积要比 nch_na25 小很多 (约八分之一)，并且其等效电容值约为 0.059 pF ~ 0.184 pF 也要更小：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-01-31-29_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>



### 1.5 op amp specs

综上，我们还是考虑用 nch_na25 作为 pass transistor, 并且取运放 $C_L = 0.5 \ \mathrm{pF}$ 进行设计。


根据上面的设计思路，我们给出运放的设计指标如下：


<div class='center'>
<span style='font-size:12px'> 


| Type | DC Gain | GBW | PM | Slew Rate | Input CM | Output Swing | Power Dissipation | Corner |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Specifications | 60 dB | 600 MHz @ 0.5 pF | 65° | - | 0.6 V | - | 300 uA ~ 500 uA | all-corner |

</span>
</div>

具体而言，我们以下列参数为初始目标：

$$
\begin{gather}
I_{SS1} = 80 \ \mathrm{uA},\quad I_{SS2} = 320 \ \mathrm{uA}
\\
C_c = \frac{1}{3}C_L = \frac{1}{3} \times 0.5 \ \mathrm{pF} = 0.167 \ \mathrm{pF}
\\
g_{m1} > 650 \ \mathrm{uS},\quad g_{m6} > 5.0 \ \mathrm{mS}
\\
V_{in,CM} = 0.6 \ \mathrm{V},\quad A_{v,DC} > 60 \ \mathrm{dB}
\end{gather}
$$

<span style='color:red'> 本次设计基本无需关注功耗，可以适当增加电流已获得更好的 opamp/LDO 性能，但要注意输出噪声需尽量小。 </span>

## 2. Design of Op Amp

设计和前仿见这篇文章 [202509_tsmcN65_OpAmp__nulling-Miller](<AnalogICDesigns/202509_tsmcN65_OpAmp__nulling-Miller.md>)，版图与后仿见这篇文章 [202509_tsmcN65_OpAmp__nulling-Miller__layout](<AnalogICDesigns/202509_tsmcN65_OpAmp__nulling-Miller__layout.md>)。




## 3. Design of LDO (v1)

### 3.1 PT iteration

运放设计完成后，我们来调整 pass transistor 的尺寸，以满足 15 mA 的最大负载电流要求，调整前的性能如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-15-04-18_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

上图中 a = 50u/0.5u = 100 可以覆盖 0.5 mA, 那么 15 mA 需要 a = 3000 = 1500u/0.5u, 设置 finger = 100 (area = 15u*50u) 看看：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-15-08-01_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

perfect!!! 无需再调整。

简单看一看不同工艺角下的性能：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-15-17-25_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-15-20-31_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-15-26-16_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

轻松抗过所有工艺角！

### 3.2 PM iteration

输出端并联电容 $C_M$ 可以降低高频时的输出阻抗，减弱振铃效应，但是过高的 $C_M$ 会引发稳定性问题，简单的稳定性分析见这两篇文章：
- [知乎 > 王小桃带你读文献：低压差线性稳压器 LDO Low Dropout Regulator](https://zhuanlan.zhihu.com/p/19362115112)
- [知乎 > 基础 LDO 的原理分析和推导](https://zhuanlan.zhihu.com/p/683717504)

我们先不作任何补偿，看一下开环增益 $H_{OL}(s)$ 在 ILOAD = 15 mA 下的相位情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-18-07-20_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

可以通过下面几种方法来提升 PM:
- (1) 降低 DC Loop Gain, 等价地降低 $R_1$ 或 $g_{m1}$，后者不太好调整，不妨降低 $R_1$ <span style='color:red'> (这种方法会使 PSRR 降低) </span>
- (2) 在负载端连接 $(R_c + \frac{1}{s_C})$ 来引入一个位于 $s = - \frac{1}{R_{cc} C_{cc}}$ 的零点，使零点 $f_{zero} = \frac{1}{2\pi R_{cc}C_{cc}}$ 靠近/抵消第二极点 $f_{p2} = 26.17 \ \mathrm{MHz}$
- (3) 在 $R_1$ 处并联一个电容 $C_1$，但这种方法会使 PSRR 降低


先将 $R_1$ 降低为 500 Ohm, 然后尝试不同的 $(R_{cc}, C_{cc})$ 组合：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-18-17-19_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

虽然 PM 有一定改善，但都不足以让系统重回稳定，这怎么办呢？无奈只能重新回到运放的 $(C_c,\ R_z)$ 补偿，选择其中最稳定的 (800f, 1kOhm)，则有：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-18-42-57_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

PM 已经回正，但还是不够。下面设定 ILOAD = 1 mA 进行迭代：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-18-47-14_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-18-48-12_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

尽管 (Cc, Rz) = (2.0 pF, 700 Ohm) 时有较好的 PM, 但如此大的 Cc 会严重影响 LDO 的 PSRR_GBW:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-18-52-57_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

现在的参数是 (Cc, Rz, Ccc, Rcc) = (2.0 pF, 700 Ohm, 2.0 pF, 1 kOhm), 为得到更小的 Cc, 我们尝试降低 pass transistor 的面积：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-19-03-30_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-19-08-17_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

现在的参数是 (Cc, Rz, Ccc, Rcc) = (425 fF, 700 Ohm, 2.0 pF, 1 kOhm) 以及 WP_PT/LP_PT = 480um/400nm, 此时有 PM = 53.69° @ 15 mA, PSRR_DC = -54 dB, PSRR_5MHz = -34.9 dB. 但是转为 ILOAD = 1 mA 进行验证时发现这么高的 PM 是 "假的"，无奈再次提高 Cc 进行迭代：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-19-14-01_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-20-02-30_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

上图发现 L = 500n, AP_PT = 800 对应的参数较好，于是继续尝试增大 L.


结合 15 mA 的输出电流要求，限定 AP_PT >= 1000, 继续迭代：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-20-15-38_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

上图 L = 660n, AP_PT = 1200 时已经达到了 PM = 80° @ 15 mA, 可以转为 1 mA 下的 PM_min 继续迭代 (保持 AP_PT >= 1000)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-20-20-30_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-20-23-16_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

看来基本上就是 L = 620n, AP_PT = 1000 为最佳参数了。

顺便看一下 IBIAS = 150 uA 时的性能：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-20-26-01_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

**L = 620n, AP_PT = 1000** 时的完整性能如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-20-28-49_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>


### 3.3 Ccc iteration

下面重新迭代 (Ccc, Rcc) 组合，以获得更好的 PM. **注：(Ccc, Rcc) 组合对 PSRR 几乎无影响。**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-20-35-05_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

取 (Ccc, Rcc) = (2.0 pF, 600 Ohm) 作为最佳参数。

### 3.4 C1 iteration

继续迭代 C1 以获得更优 PM:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-20-39-31_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

选择 C1 = 1.0 pF 作为最佳参数。

<span style='color:red'> 后补：这里降低 R1 和升高 C1 都会使 PSRR 降低 (如下图)，我们后面 pre-simul 时实际使用的是 C1 = xxx pF. </span>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-36-49_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 3.5 Cc iteration

现在 PM 的问题已经大致解决，但 PSRR_5MHz 稍不够一些，我们看看能否通过适当降低 Cc 来提升 PSRR_GBW (在不牺牲太多 PM 的情况下)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-20-41-04_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

唉，看来是无法避免的 tradeoff.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-21-27-20_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>


### 3.6 LDO compensation

为了解决 PM 不够的问题，除 (Ccc, Rcc) 外，我们再引入一个补偿网络 (Cc2, Rc2) 以进一步提高 PM, 参考下面这两篇论文：

>[[1]](https://libyw.ucas.ac.cn/https/63HNga92DoxwAYPr51CYnV8eWBha67Ly8CNtBH8tNL/document/10762683/) X. Liang, X. Kuang, J. Yang, and L. Wang, “A Fast Transient Response Output-capacitorless LDO With Low Quiescent Power,” in 2024 3rd International Conference on Electronics and Information Technology (EIT), Chengdu, China: IEEE, Sep. 2024, pp. 314–317. doi: 10.1109/EIT63098.2024.10762683.<br>
[2] M. M. Elkhatib, “A capacitor-less LDO with improved transient response using neuromorphic spiking technique,” in 2016 28th International Conference on Microelectronics (ICM), Giza, Egypt: IEEE, Dec. 2016, pp. 133–136. doi: 10.1109/ICM.2016.7847927.


**下图可以看出 (Cc2, Rc2) 对 PSRR 几乎无影响：**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-22-04-04_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

迭代 (Cc2, Rc2) 组合：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-22-10-54_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

将 Cc 修改回 0.425 pF, 继续迭代：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-22-15-15_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-22-33-31_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

**终于做到了 o(╥﹏╥)o, 太不容易了我。**


导师建议我们使用 mom cap, 先看一下 mom cap 所需的面积再决定 Cc2 的最终值：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-22-29-26_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

设置 width = spacing = 100 nm 时，大约需要 27um*27um/pF, 也就是 730um^2/pF。 **综合面积和稳定性，我们最终选择 (Cc2, Rc2) = (2 pF, 1 kOhm)。**

如果采用 mim 电容，其单位面积电容值更高一些，在我们的库中为 22u*22u/pF (arrayX = arrayY = 1), 如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-23-13-29_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

**我们选择 mim cap, 因为它的精度和其它性能在我们的频率要求下已经完全够用了。**

另外，C1 的值已经比较不错，无需再调整：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-22-45-59_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>


### 3.7 R1 iteration

上面最开始迭代 R1 时犯了一点错误, PSRR 的 schematic 中未添加 R1, 因此没有正确体现 R1 对 PSRR 的影响。现在补上 R1 再来迭代：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-44-09_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

选择 R1 = R2 = 5 kOhm, C1 = 0.1 pF 作为最终参数。



### 3.8 iteration summary

LDO 的最终参数如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-22-55-33_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<!--
### 3.6 Noise Reduction


在 LDO 中加入几个电容可以起到降低噪声的作用。参考文章 [ADI > Noise Sources in Low Dropout (LDO) Regulators](https://www.analog.com/media/en/technical-documentation/app-notes/an-1120.pdf) 和 [TI > Understanding noise in linear regulators](https://www.ti.com/lit/an/slyt201/slyt201.pdf)，我们可以添加下面三个电容：
- input capacitor: 由 Vin 接到 VSS
- noise reduction capacitor: 由运放 REF 输入端接到 VSS
- bypass capacitor: 与上端电阻 R1 并联

 -->


## 4. Pre-Simulation (v1_132108) 

下面对第一个版本 (v1_132108) 进行 pre-simulation **(默认 C_L = 0.5 pF)。**

### 4.0 schematic preview

(已检查过所有 schematic)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-19-27-06_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-01-10-39_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-19-28-38_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 4.1 (tran) start-up response (all-corner, 1.7 V)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-23-59-15_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

VDD 以 1V/us 上升：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-23-56-54_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

VDD 以 100V/us 上升：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-23-58-36_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 4.2 (ac) stability (all-corner, two-supply)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-13-59_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

VDD = 1.7 V 时：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-22-39_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-53-34_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

VDD = 2.65 V 时：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-12-44_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-23-44_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-55-10_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 4.3 (ac) PSRR (all-corner, two-supply)

VDD = 1.7 V 时：

第一张图 (错误的) 是设置的什么参数给忘了：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-53-02_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-19-33-50_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

VDD = 2.65 V 时：

第一张图 (错误的) 是设置的什么参数给忘了：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-55-48_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-19-34-29_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 4.4 (ac) stability at all C_L (TT65, 1.7 V)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-13-00-50_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-43-46_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>


<!-- 
### 4.4 (ac) load regulation (all-corner, 1.7 V)
### 4.5 (tran) step response (TT, 1.7 V)
### 4.6 (mc) output voltage (1.7 V)
### 4.7 pre-simul summary

上面的前仿结果汇总在下表：

<div class='center'><span style='font-size: 12px'>

| Parameter | Process | Supply Range | Output Voltage | Output Current | Settling Time | Overshoot | Linear Regulation | Load Regulation | PSRR |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | **Specification** | TSMC 65nm CMOS | 1.7 V ~ 2.65 V | xxx mA ~ xxx mA  (nominal xxx mA) | 1.0 V | xxx ns | mV (xx%) | xx uV/V | xx nV/mA | xx dB @ DC <br> xx dB @ 100 kHz |
 | **Pre-Simulation** | TSMC 65nm CMOS | 1.7 V ~ 2.65 V | xxx mA ~ xxx mA  (nominal xxx mA) | 1.0 V | xxx ns | mV (xx%) | xx uV/V | xx nV/mA | xx dB @ DC <br> xx dB @ 100 kHz |

</span>
</div>

后续的 layout and post-layout simulation 详见这篇文章 [202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0__layout]()。
 -->


## 5. Further Discussion

### 5.1 the effect of C_L

- (1) PSRR: C_L 对 PSRR 几乎无影响
- (2) PM: 升高 C_L 会使 PM 显著降低


关于要不要在输出端并联一个电容 $C_L$，我们先看看从不同负载电容下的零极点分布：

<div class='center'>

| LOAD | p1 (Hz) | p2 (Hz) | p3 (Hz) | zero | PM |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | 0 pF   | 28.23k | 17.04M | 298.1M | 41.89M | 48.57 |
 | 10 pF  | 28.15k | 8.814M | - | - | 8.107 |
 | 100 pF | 27.43k | 1.936M | - | - | -9.909 |
 | 10 uF  | 14.10  | 43.67k | - | - | 14.47 |
 | 100 uF | 1.411  | 43.63k | - | - | 43.31 |
</div>

除 0 pF 外的 p3 和 zero 没数据是因为从图中不太好肉眼看出。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-13-00-50_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-12-55-45_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-13-03-52_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-13-14-53_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-13-21-18_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-13-21-06_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

从上面的数据可以看出：在非片外电容的情形下 (capacitor-less LDO), 系统 PM 随着 C_L 的增大而降低，甚至变为负值 (不稳定)。

从下图又可看出 C_L 对 PSRR 影响不大：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-15-16-04_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

有关环路传递函数的分析，详见这篇文章 [LDO Stability Analysis and Loop Compensation Mechanism](<AnalogIC/LDO Stability Analysis and Loop Compensation Mechanism.md>).



### 5.2 the effect of C1

- (1) PSRR: 升高 C1 会使 PSRR 降低
- (2) PM: 只有在 C1 很小时，升高才会对 PM 有改善作用


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-15-01-54_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-15-03-02_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 5.3 the effect of (Cc1, Rc1)

- (1) PSRR: (Cc1, Rc1) 对 PSRR 无影响
- (2) PM:   合适的 (Cc1, Rc1) 可以显著提升 PM



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-15-06-21_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 5.4 the effect of (Cc2, Rc2)

- (1) PSRR: (Cc1, Rc1) 对 PSRR 几乎无影响
- (2) PM:   合适的 (Cc2, Rc2) 可以显著提升 PM

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-15-09-48_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 5.5 the effect of R1

- (1) PSRR: 合适的 R1 才能保持较好的 PSRR
- (2) PM:   R1 对 PM 有一定影响，并且通常与 PSRR 的趋势相同 (同时使 PSRR 和 PM 变好)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-15-23-30_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 5.6 the effect of IBIAS

- (1) PSRR: 升高 IBIAS 可提升 PSRR_GBW 
- (2) PM:   IBIAS 对 PM 有一定影响，不一定好或坏


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-15-26-08_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 5.7 the effect of opamp

运放内部补偿参数 (Cc, Rz) 会影响运放的 GBW 和 PM, 从而影响 LDO 的 PSRR 和 PM:

- (1) PSRR: 升高内部 Cc 会降低 PSRR_GBW
- (2) PM:   升高内部 Cc 会提升 PM

### 5.8 tradeoff between PSRR and PM

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-15-29-46_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

## 6. Design Iteration (v2)

### 6.1 loop compensation

先以 (C_L, C1, R_1, I_BIAS, Cc) = (0.5 pF, 0.1 pF, 5 kOhm, 150 uA, 0.425 pF) 为初始参数，迭代 (Cc1, Rc1) 和 (Cc2, Rc2) 以获得更好的 PM (这两个参数对 PSRR 几乎无影响)。考虑到电容的面积现在，首次迭代范围是 0.5 pF ~ 2.5 pF 和 0.6 kOhm ~ 1.5 kOhm:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-15-40-11_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

固定 Cc2 = 2.5 pF, 设置 Cc1 = 1.5 pF ~ 2.5 pF, Rc1 = 0.5 kOhm ~ 2.0 kOhm, Rc2 = 0.3 kOhm ~ 1.0 kOhm 进行迭代：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-15-45-38_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

仍固定 Cc2 = 2.5 pF, 设置 Cc1 = 2.0 pF ~ 2.5 pF, Rc1 = 1.5 kOhm ~ 2.0 kOhm, Rc2 = 0.7 kOhm ~ 0.9 kOhm 进行迭代：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-15-50-05_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

**最终参数为: (Cc1, Rc1, Cc2, Rc2) = (2.5 pF, 1.5 kOhm, 2.5 pF, 0.7 kOhm)**



### 6.2 R1/C1 iteration

下面迭代 R1 和 C1 以获得更好的 PSRR (需要注意这两个参数对 PM 的影响)。

先设置 R1 = 0.5 kOhm ~ 10 kOhm, C1 = 0 ~ 1.0 pF 进行迭代：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-15-56-11_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

修改范围为 R1 = 5 kOhm ~ 8 kOhm, C1 = 0 ~ 0.3 pF 继续迭代：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-00-25_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

修改范围为 R1 = 5.5 kOhm ~ 6.5 kOhm, C1 = 0 ~ 0.25 pF 继续迭代：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-03-29_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

**最终选择 (R1, C1) = (6.0 kOhm, 0.15 pF)**

### 6.3 Cc/IBIAS iteration

除 C_L 外，就剩下 Cc 和 IBIAS 两个参数了。设置 Cc = 0.3 pF ~ 1.5 pF, IBIAS = 100 uA ~ 250 uA 进行迭代：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-12-39_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

修改为 Cc = 0.25 pF ~ 0.75 pF, IBIAS = 100 uA ~ 250 uA 继续迭代：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-17-21_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

修改为 Cc = 350 fF ~ 650 fF, IBIAS = 150 uA ~ 200 uA 继续迭代：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-23-22_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-26-29_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

**最终选择 (IBAS, Cc) = (175 uA, 450 fF)。** 

### 6.4 Rz iteration

最后对运放内部补偿电阻 Rz 进行简单迭代，先仿真 0.1 kOhm ~ 2.0 kOhm:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-37-01_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

再看看 400 Ohm ~ 1 kOhm:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-39-01_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

最终还是选择 Rz = 700 Ohm (与初始值相同)。


### 6.5 iteration summary

综上所述, LDO 的最终参数为 (v2_141631):
- (Cc1, Rc1) = (2.5 pF, 1.5 kOhm)
- (Cc2, Rc2) = (2.5 pF, 0.7 kOhm)
- (R1, C1) = (6.0 kOhm, 0.15 pF)
- (IBIAS, Cc, Rz) = (175 uA, 450 fF, 0.7 kOhm)


此时的 PSRR/PM/LOAD 曲线图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-31-00_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>


## 7. Pre-Simulation (v2_141631)

按上一小节所得参数 (v2_141631) 摆放 schematic 并生成 symbol, 进行 pre-layout simulation **(默认 C_L = 0.5 pF)。**

### 7.0 schematic preview



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-41-44_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-54-25_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-54-48_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 7.1 (tran) start-up response (all-corner, 1.7 V)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-17-27-20_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-17-29-17_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-17-35-26_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 7.2 (ac) stability (all-corner, two-supply)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-16-57-06_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

VDD = 1.7 V 时：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-17-13-53_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

VDD = 2.65 V 时：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-17-17-56_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>



### 7.3 (ac) stability at all C_L (TT65, 1.7 V)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-17-25-31_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-17-26-07_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>



### 7.4 (ac) PSRR (all-corner, two-supply)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-17-00-55_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

VDD = 1.7 V 时：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-17-02-52_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

VDD = 2.65 V 时：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-17-03-45_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 7.5 (sm) pre-simul summary

ε(´ο｀*))) 唉，这一版本 (v2_141631) 尽管 PSRR 有所提升，但是的稳定性显然没有 v1_132108 好。

又要重新迭代一次吗？如何保证迭代后的结果是具有高稳定性的呢？

<!-- 为了保证迭代所得参数具有较高的稳定性，我们在迭代时设置如下条件：
- ILOAD = 10 uA
- corner:
    - PM simulation: {(FF, -40°), (FF, 125°)}
    - PSRR simulation: {(SS, -40°), (SS, 125°)}
 -->

## 8. Design Iteration (v3)

为了解决稳定性问题，我们尝试在 op amp 输出端到 pass transistor gate 之间增加一级 buffer (例如 source follower 或者 push-pull), 实现阻抗上的隔离，从而提升系统的稳定性。当然，无论是输出范围还是简便程度都是 push-pull 占优。

但是这种方法却会大幅降低 PSRR, 因为添加 push-pull stage 相当于将功率管驱动处的极点拉低到 10 Hz 级别 (来自 PP stage 极高的输入阻抗)，大幅拉低环路的 GBW 从而使原本位于 50 kHz 左右的极点成为第二极点。下面是一个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-18-19-04_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-18-18-46_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

因此这种方法对我们而言并不适用。

为保证结果的可靠性，我们设置 ILOAD = 10 uA @ 0.5 pF 进行 PM 仿真, 设置 ILOAD = 10 mA @ 0.5 pF 进行 PSRR 仿真。

**迭代思路为：以 v1_132108 作为初始版本 (稳定性较好但是 PSRR 稍不够)，在降低全体管子 length 的前提下，先适当提高 R1 (同时调整 C1 以保证 PM 不太差)，然后调整两个补偿网络以及运放内部补偿网络以寻求更好的 PM. 这样整体来看，相当于牺牲 PSRR_DC 换取 PSRR_5MHz.**



<!-- - R1 的升高可以提升 PSRR_5MHz (5kOhm 以下) 但是牺牲 PM
- 降低全体管子 length 可以牺牲 PSRR_DC 换一点点 PM
-  -->

### 8.1 R1/C1/Rz iteration

使用 v1_132108 参数作为初始值，将管子长度改为 L = 360 nm, LP_PT = 280 nm, 根据 R1 对 PSRR 的影响，我们选择 R1 = 5.0 kOhm 进行后续仿真 (此时 PSRR_5MHz 稍改善了一些)，看看能否达到较好的 PM.

先迭代 C1 和 Rz: C1 = 0.0 pF ~ 1.0 pF, Rz = 0.5 kOhm ~ 5.0 kOhm

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-21-23_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-23-38_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>


既然 5 kOhm 能如此简单地就找到 PM = 50°, 能否进一步提升 R1 呢？我们尝试 R1 = 7.0 kOhm 来搜索 C1 和 Rz:


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-26-46_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-29-32_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

看来 R1 = 7.0 kOhm 也是可行的。以 (Rz, C1) = (5k, 250f) 为中心点进一步仿真 Rz = 4.0 kOhm ~ 6.0 kOhm, C1 = 150 fF ~ 350f:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-33-37_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

**最终选择了 (R1, Rz, C1) = (7.0 kOhm, 5.0 kOhm, 250 fF).**

### 8.2 loop compensation

下面就是迭代两个补偿网络 (Cc1, Rc1) 和 (Cc2, Rc2)，其初始值为 (2.0 pF, 0.6 kOhm) 和 (2.0 pF, 1.0 kOhm) (v1_132108 的值)。注意它们俩对 PSRR 几乎无影响，只需仿真 PM. 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-38-03_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

以 (Cc1, Rc1, Cc2, Rc2) = (2.0 pF, 1.0 kOhm, 2.0 pF, 1.0 kOhm) 为中心点，仿真下面范围：
- Cc1 = 1.5 pF ~ 2.5 pF
- Rc1 = 0.5 kOhm ~ 1.5 kOhm
- Cc2 = 1.5 pF ~ 2.5 pF
- Rc2 = 0.5 kOhm ~ 1.5 kOhm

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-43-11_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

以 (Cc1, Rc1, Cc2, Rc2) = (2.5 pF, 500 Ohm, 2.5 pF, 1.5 kOhm) 为中心点，仿真下面范围：
- Cc1 = 2.0 pF ~ 3.0 pF
- Rc1 = 0.25 kOhm ~ 0.75 kOhm
- Cc2 = 2.0 pF ~ 3.0 pF
- Rc2 = 1.25 kOhm ~ 1.75 kOhm

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-48-52_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-49-51_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<!-- 到这一步还不太完整，我们再简单扫描一下 (FF, -40°C) 工艺角的情况： -->

**受电容面积限制，我们就截止到最大 3.0 pF 的迭代，得到补偿网络的最终参数：(Cc1, Rc1, Cc2, Rc2) = (3.0 pF, 0.75 kOhm, 3.0 pF, 1.25 kOhm)**

### 8.3 Cc iteration

基于上面结果，这么高的 PM 当然可以拿来牺牲一点啦。我们尝试降低 Cc 来提升 PSRR_5MHz:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-55-20_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-55-38_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

进一步仿真 Cc = 325 fF ~ 375 fF:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-59-40_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-20-59-52_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

**最终选择 Cc = 325 fF.** 

### 8.4 transient verification

本次迭代结果汇总如下 (v3_142126)：
- L = 360 nm, LP_PT = 280 nm
- (R1, C1, Rz) = (7.0 kOhm, 250 fF, 5.0 kOhm)
- (Cc1, Rc1, Cc2, Rc2) = (3.0 pF, 0.75 kOhm, 3.0 pF, 1.25 kOhm)
- (IBIAS, Cc) = (150 uA, 325 fF)


用 10 uA 负载下的启动波形验证一下 PM 是不是 "真的"。先仅设置 VDD 具有上升时间看一下 (VREF 和 ILOAD 恒定)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-09-52_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-10-17_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>



再 VDD/VREF/ILOAD 依次上升，间隔 0.5 us:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-17-41_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-20-48_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>



基本没有什么问题, 10 uA 下全部工艺角的启动波形都很干净，说明 PM 结果是可靠的。顺便看看突然接入大负载电流的瞬态响应：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-21-49_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-26-05_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

也是没问题的。

## 9. Pre-Simulation (v3_142126)


### 9.0 schematic preview

将上面所得参数 (v3_142126) 摆放 schematic 并生成 symbol, 进行 pre-layout simulation **(默认 C_L = 0.5 pF)。**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-33-17_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-44-27_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-44-39_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 9.1 (tran) start-up response (all-corner, 1.7 V)

**设置 VREF 与 VDD 一同上升 (上升时间相同)**，运行瞬态仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-50-50_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-52-13_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-50-25_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

再看一下极低负载下的启动波形 (ILOAD = 10 uA):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-54-06_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

也是没问题的。

### 9.2 (ac) stability (all-corner, 1.7 V)



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-55-15_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-03-59_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<!-- 注：我们怀疑 (ac) stability 仿真中得到的直流工作点与 transient opt 有明显不同，导致部分 stability 结果不准确。
 -->


<!-- 将 ILOAD 改为 RLOAD 又尝试了下，无明显变化。
 -->


### 9.3 (ac) stability at all C_L (TT65, 1.7 V)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-22-34_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 9.4 (ac) PSRR (all-corner, two-supply)


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-24-59_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-24-02_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-29-19_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-24-39_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-31-03_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 9.4 (tran) step response (TT, 2.65 V)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-41-46_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

DC_1mA + STEP_10mA:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-44-37_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-43-48_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

DC_10uA + STEP_100uA:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-47-22_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-48-25_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 9.5 (sm) pre-simul summary

除了 100uA/1mA/5mA 下的 stability 结果有点奇怪以外，其它参数都或多或少的比前两个版本更优秀，基本上就是最终迭代结果了。
