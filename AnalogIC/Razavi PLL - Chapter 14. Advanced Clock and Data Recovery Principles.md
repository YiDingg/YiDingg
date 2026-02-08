# Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 02:09 on 2026-01-25 in Lincang.
> dingyi233@mails.ucas.ac.cn

**参考教材：[*Design of CMOS Phase-Locked Loops (Behzad Razavi) (1st Edition, 2020)*](https://www.zhihu.com/question/23142886/answer/108257466853)**

## Introduction

在上一篇文章 [Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals](<AnalogIC/Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.md>) 中，我们介绍了时钟数据恢复 (CDR) 的基本概念和架构。

在本章，我们将深入探讨更高级的 CDR 原理和设计技术，重点关注其在高速数据通信中一些的难点和解决方案。首先是能大幅提高数据传输速率的 "half-rate" 架构，通过多相 (≥ 4-phase) half-rate clock, 使得同频时钟下的数据速率翻倍；然后介绍了一些 oscillator-less CDR 架构，包括 DLL-based, PI-based 和 all digital CDR，以及 CDR 中的一些频率捕获方法 (辅助频率锁定)；最后是 CDR 的抖动特性分析，包括 jitter transfer function 和 jitter tolerance 等内容。


## 1. Half-Rate Phase Detector

### 1.1 half-rate Alexander PD


上一章讲的 (full-rate) Alexander PD 不能直接在 half-rate 条件下使用，下面的例子具体说明了原因：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-02-40-06_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>

事实上，half-rate Alexander PD 需要 quadrature (IQ) half-rate clocks, 也就是一路 CK_I 和另一路 CK_Q (后者滞后 90°)，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-02-29-44_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>

这样，在完全对齐的情况下，我们有 data edge = pos-edge of CK_Q，但上图所示电路有一个问题是：它只能将 pos-edge of data 和 CK 相位进行比较，不能像 full-rate Alexander PD 那样同时利用 pos and neg-edge of data 的相位信息，浪费了一半。为解决这个问题，通常使用下图架构作为完整的 half-rate Alexander PD:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-02-47-16_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>

这个架构还有一个好处是 CK_I 和 CK_Q 的负载天然对称，不需要额外添加 dummy load 来平衡负载。



### 1.2 half-rate Hogge PD

类似地，full-rate Hogge PD 也不能直接在 half-rate 条件下使用：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-02-20-43_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>

但是 Hogge PD 从结构上更容易扩展到 half-rate 条件，只需将原来的 pos-edge-triggered DFF 替换为 double-edge-triggered DFF:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-02-43-34_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>

其中 double-edge-triggered DFF 的实现方法如下 (只是一个例子)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-02-45-34_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>

如果只有 two-phase half-rate clock (差分时钟)，则可以使用下面的 Hogge PD 架构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-02-44-57_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>

## 2. Oscillator-less CDR

有些系统会在一个芯片上集成大量的 CDR 电路。例如，一个支持 16 I/O channel 的有线收发器 (wireline transceiver) 就需要十六个 CDR loop。在这种情况下，使用 LC-VCO 来实现时钟恢复是不太现实的 (十六个 LC-VCO 所占面积太大)，而 Ring-VCO 又可能无法提供足够低的抖动/相噪。于是本小节，我们来研究几种无需自身振荡器即可运行的 CDR 架构 (可使用外部其它模块提供的时钟) 。

### 2.1 DLL-based CDR

最简单的就是直接利用 TX 端传来的时钟信号，配合 DLL 来去除传输过程中造成的偏移 (skew)，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-02-51-34_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>

假设 LPF 为 (非积分型) 一阶低通系统，则上面的 delay-locked loop (DLL) 也是一阶环路，如下图，其开环和闭环传递函数为：

$$
\begin{gather}
H_{LPF}(s) = \frac{1}{1 + \frac{s}{\omega_{LPF}}} \\
\Longrightarrow 
H_{OL}(s) = \frac{K_{PD}K_{VCDL}}{1 + \frac{s}{\omega_{LPF}}}
,\quad 
H_{CL}(s) = \frac{H_{OL}(s)}{1 + H_{OL}(s)} = \frac{K_{PD}K_{VCDL}}{ 1 + K_{PD}K_{VCDL} + \frac{s}{\omega_{LPF}}}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-02-52-59_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>

### 2.2 PI-based CDR

PI 即为 phase interpolator (相位插值器)，它可以在两个输入信号之间插入一个的输出信号，输出信号的相位通常在两输入之间可调 (被夹在中间)。

这一小节暂时先不展开，后续有时间再补充。

### 2.3 all-digital CDR

暂略。

## 3. Frequency Acquisition

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-03-01-43_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>

## 4. Jitters in CDR

### 4.1 type-II CDR loop analysis

由于 CDR 的架构多种多样，使用不同模块时的环路参数不尽相同，因此无法仅用一个通用的环路模型来分析所有 CDR 的抖动特性。不过，大多数 CDR 都可以归结为分频比为一 (N = 1) 的 type-II PLL，也就是 PD + CP + LPF + VCO 的结构 (带有负反馈)，直接将之前推过的结论搬过来，然后令 $N = 1$ 得到：

$$
\begin{gather}
H_{OL}(s) = \omega_n^2 \times \frac{1 + s \frac{2\zeta}{\omega_n}}{s^2} = \frac{4\zeta^2}{\tau_1^2} \times \frac{1 + s\tau_1}{s^2} \\
H_{CL}(s) 
= \omega_n^2 \times \frac{1 + s\frac{2\zeta}{\omega_n}}{s^2 + 2\zeta \omega_n s + \omega_n^2} 
= \frac{4\zeta^2}{\tau_1^2} \times \frac{1 + s\tau_1}{s^2 + \frac{4\zeta^2}{\tau_1} s + \frac{4\zeta^2}{\tau_1^2}}
\\
\zeta = \frac{R_1 C_1}{2}\sqrt{\frac{I_PK_{VCO}}{2\pi C_1}},\ \  
\tau_1 = R_1 C_1 ,\quad 
\omega_n = \frac{2\zeta}{\tau_1} = \sqrt{\frac{I_PK_{VCO}}{2\pi C_1}}
\\
\text{BW}_\omega = \frac{2\zeta}{\tau_1} \left[1 + 2\zeta^2 + \sqrt{4\zeta^4 + 4\zeta^2 + 2}\right]^\frac{1}{2} \ \mathrm{(rad/s)}
\\
\text{PM} = \mathrm{atan}\left(2\sqrt{N\zeta^2} \sqrt{2\,N\,\zeta^2 +\sqrt{4\,N^2 \,\zeta^4 +1}}\right) \ \mathrm{(rad)}
\\
\end{gather}
$$




### 4.2 jitter transfer function

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-03-02-27_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>


由于 CDR 环路在闭环情况下的输入就是数据流 data (类似 PLL 中的 REF 输入端)，因此 CDR 的抖动传递函数 (jitter transfer function) 就是其闭环传递函数 $H_{CL}(s)$。将 $H_{CL}(s)$ 进一步分解可以得到：

$$
\begin{gather}
H_{CL}(s) = \frac{1 + \frac{s}{\omega_z}}{ \left(1 + \frac{s}{\omega_{p1}}\right)\left(1 + \frac{s}{\omega_{p2}}\right)} 
,\quad \omega_z = - \frac{1}{\tau_1} = - \frac{1}{R_1 C_1} ,\quad
\\
\omega_{p1,2} = - \left(\zeta \pm \sqrt{\zeta^2 - 1}\right) \omega_n = - \left(\zeta \pm \sqrt{\zeta^2 - 1}\right) \frac{2\zeta}{\tau_1}
\end{gather}
$$

这样含有 "一零点 + 两极点" 的系统，最典型的特性就是可能出现峰值 (peaking) 现象。由零极点的公式，从数学上容易证明：

$$
\begin{gather}
幅频曲线出现峰值 \Longleftrightarrow 两个极点都在零点右侧 \Longleftrightarrow \zeta \in (0,\ +\infty)
\end{gather}
$$

换句话说，在这样的一个闭环系统下，无论 damping factor $\zeta$ 取何值，幅频曲线都会出现峰值 (peaking) 现象，这有时会显著影响抖动传输特性，下图详细阐述了这种现象：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-31-00-48-20_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>

当 $\zeta > 2$ 时，我们有近似：

$$
\begin{gather}
H_{peaking} = \frac{|H_{CL}(j\omega_{p1})|}{|H_{CL}(j \omega_z)|} \approx 1 + \frac{1}{4\zeta^2}
\end{gather}
$$

上式表明，增大 $\zeta$ 可以有效抑制峰值 (peaking) 现象，但是注意我们无法完全消除峰值。举个例子，$\zeta = 2$ 时，峰值约为 0.527 dB，也即在 $|H_{CL}(j \omega_z)|$ 的基础上增加 0.53 dB；而 $\zeta = 4$ 时，额外峰值降低到 0.135 dB，几乎可以忽略不计。


环路中的 "时延" 也可能导致一系列问题。例如，在简单的锁相环中，分频器会表现出有限的延迟 $T_{div}$，这会导致环路增益乘上一个因子 $\exp (-T_{div}s)$。对于环路动态时间远大于 $T_{div}$ 的情况，该因子简化为 $(1 - T_{div})$，由此产生的右半平面零点会显著降低环路相位裕度。类似地，在数字锁相环中，与 TDC (time-to-digital converter) 和 loop filter 相关的延迟时间可能会导致抖动峰值，而在数字 CDR 电路中，demultiplexer (DeMUX), counter 和 PI (phase interpolator) 都会引入额外延迟，影响抖动传输特性的同时还可能引发稳定性问题。


### 4.3 jitter tolerance

我们知道，random 从 Transmitter 发出、经过 (有损耗的) 传输通道并最终到达 Receiver 的过程中会不断积累抖动，这些抖动的频率分量非常丰富，从低频到高频都有可能出现。CDR 环路需要有足够的抖动容限 (jitter tolerance)，才能保证在各种抖动条件下都能正确恢复时钟信号。

如下图，现在假设 CDR 在跟踪输入数据 DATA 的相位，我们考察在理想无抖动 DATA 上叠加一个指定频率的正弦抖动后，CDR 能否继续正确锁定 DATA 的相位。具体而言，这个指定频率的正弦抖动幅度为多少时，相位误差会达到 $\pm \frac{1}{2} \ \mathrm{UI}\ \ (1 \ \mathrm{UI} = 1 \ \mathrm{bit\,period})$，从而导致 sampling 过程出现错误，这个抖动的幅度就被定义为该频率下的抖动容限 (jitter tolerance)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-31-01-30-10_Razavi PLL - Chapter 14. Advanced Clock and Data Recovery Principles.png"/></div>

从数学上可以推得：
$$
\begin{gather}
|\phi_{in} - \phi_{out}| < 0.5 \ \mathrm{UI} \\
\Longleftrightarrow 
\phi_{in}  |1 - H_{CL}(s)| < 0.5 \ \mathrm{UI} \\
\Longleftrightarrow 
{\color{red} \phi_{in} < \frac{0.5 \ \mathrm{UI}}{|1 - H_{CL}(s)|}} = \frac{s^2 + 2\zeta \omega_n s + \omega_n^2}{s^2} \times \left(0.5 \ \mathrm{UI}\right)
\\
\Longrightarrow 
{\color{red} G_{JT}(s) = \frac{0.5 \ \mathrm{UI}}{|1 - H_{CL}(s)|}} = \frac{s^2 + 2\zeta \omega_n s + \omega_n^2}{s^2} \times \left(0.5 \ \mathrm{UI}\right)
\end{gather}
$$

其中 $G_{JT}(s)$ 就称为 CDR 的抖动容限函数 (jitter tolerance function)，单位为 $\mathrm{UI_{amp}}$。通常 $G_{JT}(s)$ 在直流处的值为无穷大 $(\infty)$，随着频率升高而逐渐降低，最终逐渐趋于 $0.5 \ \mathrm{UI}$。当然，实际的 CDR 抖动容限曲线会受到环路时延等非理想因素的影响，最终的渐近值会比 $0.5 \ \mathrm{UI}$ 更低，比如 $0.2 \ \mathrm{UI_{amp}}$，有的甚至比 $0.1 \ \mathrm{UI_{amp}}$ 更低。
