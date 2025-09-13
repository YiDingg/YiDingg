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




## 3. Design of LDO

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


## 4. Pre-Simulation

### 4.0 schematic preview

(已检查过所有 schematic)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-01-10-18_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-01-10-39_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-01-11-02_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-20-35_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-23-29-49_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div> -->

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

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-53-02_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

VDD = 2.65 V 时：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-00-55-48_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

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
