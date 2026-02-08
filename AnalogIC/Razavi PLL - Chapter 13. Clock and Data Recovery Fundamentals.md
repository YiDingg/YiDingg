# Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 02:05 on 2026-01-22 in Lincang.
> dingyi233@mails.ucas.ac.cn

**参考教材：[*Design of CMOS Phase-Locked Loops (Behzad Razavi) (1st Edition, 2020)*](https://www.zhihu.com/question/23142886/answer/108257466853)**


## Introduction

**Clock and Data Recovery (CDR, 时钟与数据恢复) 是一种从接收到的串行数据流中提取并重建同步时钟信号的电路技术。** 

在许多高速串行通信系统中 (如以太网、PCIe、USB 等)，为了节省成本与互联复杂度，通常不会在模块/系统间传输数据的时钟信号，而是仅传输串行数据流。CDR 便是用于数据接收端的一种关键电路，其核心任务是从因传输而存在抖动和畸变的串行数据流中，实时恢复出与数据对齐的时钟信号，从而为接收端提供准确的采样时序，确保数据的可靠解析。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-22-03-01-54_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

CDR 的典型实现通常包含**相位检测器、环路滤波器与压控振荡器**等模块，构成一个闭环反馈系统，能够动态跟踪输入数据的相位与频率变化，实现数据与时钟的同步。CDR 的性能 (如抖动容忍度与功耗) 直接影响整个通信链路的最大速度、可靠性与传输效率。


下面是 CDR 利用恢复出的时钟，对 input jittered data 进行 retiming, 从而得到 retimed data 的一个示例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-22-03-02-20_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>



CDR 的基本实现逻辑有两种：
- (1) 对输入的随机数据流进行频域处理，从中提取出周期性时钟成分
- (2) 使用振荡器来生成周期性的时钟信号，并添加相关模块以确保频率和相位的正确对齐

> That the clock must be periodic points to two possibilities for clock generation: (1) manipulate the input random data so as to extract a periodic component from it, or (2) employ an oscillator to produce a periodic waveform and add means to ensure proper frequency and phase alignment.

像大多数 PLL-based CDR (例如 edge-detection + PLL 构成的 CDR) 就属于第一种方法，从频域的角度出发，对输入数据流进行适当处理后，利用 PLL 的 extreme narrow-band filtering 特性进行滤波，从而提取出周期性的时钟信号。

第二种方法则是目前高速 CDR 设计的主流，利用 PD for CDR (而不是 PLL 中常用的几种 PD) 来检测数据和本地振荡器输出之间的相位差，从而调整振荡器频率/相位，实现时钟与数据的同步与对齐。

## 1. Random Data Properties

### 1.1 NRZ/RZ data

在介绍 CDR 的基本架构之前，我们需要先知道 CDR 的输入数据流具有哪些性质。以最朴素的二进制随机数据流 (random binary data stream)，也称 **NRZ** (nonreturn-to-zero) data 为例：其在任一比特 (bit) 出现 ONE 和 ZERO 的概率相同，均为 0.5，且可能存在任意长度的连续 ONE 或 ZERO (这样的长连称为 **run**)，如 Figure 13.5 (a) 所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-22-03-14-25_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

这里 NRZ 的 nonreturn-to-zero, 指的是信号在传输过程中不会回到零状态 (不代表任何逻辑值) (unlike return-to-zero format, RZ)，而是直接在 ONE 和 ZERO 两种逻辑值之间跳变。

而 RZ data (return-to-zero data) 则是在每个比特周期内，前半个周期表示数据逻辑值 (ONE or ZERO)，后半个周期信号回到零状态 (不代表任何逻辑值)。也就是说，NRZ 和 RZ 是相对的，下面是两者的对比图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-22-03-16-55_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>


一般情况下，我们不会去特别区分 unipolar/bipolar NRZ data，因为它们的频谱特性是几乎相同的 (only DC component differs)，且都是低电平 (负电压比正电压低) 表示逻辑 ZERO，高电平表示逻辑 ONE。


### 1.2 NRZ data spectrum

我们先来看看 DC-free NRZ data 的频谱特性 (从 NRZ data 中去掉 DC 分量)。如下图所示，一个 DC-free NRZ data stream $x(t)$ 可以看作一系列脉冲信号 $p(t)$ 平移后的叠加，前面带有正负系数 $\alpha[n] = \pm 1$，也就是：

$$
\begin{gather}
x(t) = \sum_{n=-\infty}^{\infty} \alpha[n]\, p(t - nT_b)
\\
p(t) = 
\begin{cases}
V_0, & t \in \left(-\frac{T_b}{2}, +\frac{T_b}{2}\right) \\ 
0, & \mathrm{else} 
\end{cases}
\\
\alpha[n] \in \{-1, +1\},\quad T_b = \mathrm{bit\ period}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-22-14-47-31_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

而我们知道持续时间从 $-a \sim a$ 且高度为 $1$ 的矩形脉冲信号 $\mathrm{square}_{2a}(t)$，其傅里叶变换为：

$$
\begin{gather}
\mathrm{square}_{2a}(t) = 
\begin{cases}
1, & t \in (-a, +a) \\
0, & \mathrm{else}
\end{cases}
\\
\Longrightarrow 
\mathscr{F}\{\mathrm{square}_{2a}(t)\} = 2 a \,\mathrm{Sa} (a \omega) = 2a \frac{sin(a \omega)}{a \omega}
\end{gather}
$$

由此得到脉冲信号 $p(t)$ 的傅里叶变换，再由 [1] 中的结论 $S_{x}(\omega) = \frac{1}{T_b} |F(\omega)|^2$ 得到 DC-free NRZ data $x(t)$ 的功率谱密度 (PSD, power spectral density)：

$$
\begin{gather}
p(t) = V_0 \times \mathrm{square}_{2a}(t)|_{a = \frac{T_b}{2}} \Longrightarrow
F(\omega) = \mathscr{F}\{p(t)\} = V_0 T_b \,\mathrm{Sa}\left(\frac{1}{2} T_b \,\omega\right) 
\\
\Longrightarrow 
S_{x}(\omega) = \frac{1}{T_b} |F(\omega)|^2 = \frac{1}{T_b} \left[V_0 T_b \,\mathrm{Sa}\left(\frac{1}{2} T_b \,\omega\right)\right]^2 = \frac{1}{T_b} \left[V_0 T_b \frac{sin\left(\frac{1}{2} T_b \,\omega\right)}{\frac{1}{2} T_b \,\omega}\right]^2
\\
\mathrm{or:\ \ }
S_{x}(f) = \frac{1}{T_b} \left[V_0 T_b\, \mathrm{Sa}\left(\frac{1}{2} T_b \,2 \pi f\right)\right]^2 = \frac{1}{T_b} \left[V_0 T_b \frac{sin\left(\pi f T_b\right)}{\pi f T_b}\right]^2
\end{gather}
$$

这里最关键的式子是 $S_{x}(\omega) = \frac{1}{T_b} |F(\omega)|^2$，此时的证明详见参考文献 [1]，全引为：

>[1]. J. Lee and B. Razavi, “Analysis and modeling of bang-bang clock and data recovery circuits,” IEEE J. Solid-State Circuits, vol. 39, pp. 1571-1580, Sep. 2004.

作出 DC-free NRZ data 的功率谱，如 Figure 13.7 (a) 所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-22-15-03-24_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

这里一个比较反常的点是：DC-free NRZ data 的功率谱在趋于直流时非零，也即 $\displaystyle \lim_{f \to 0} S_{x}(f) > 0$。明明已经是 DC-free 了，可为什么看起来像是存在直流分量一样？

其实，这是因为原始 DC-free NRZ data 并没有对 long `-1` (or long `+1`) 进行限制，对任意低的频率 $f$，与之长度对应的 long run 都有可能出现，使得任意低频处的功率谱都不为零，从极限的角度便得到 $\displaystyle \lim_{f \to 0} S_{x}(f) = S_0 = \frac{1}{T_b}(V_0 T_b)^2> 0$。

从 DC-free NRZ 到原始 NRZ, 只需在频谱中额外加上一个 DC 分量 $S_0 = V_0$ 即可。一般情况下，data 的摆幅就是 $V_{DD}$ (满摆幅)，此时有 $V_0 = \frac{1}{2}V_{DD}$。

### 1.3 encoded NRZ data

在实际通信过程中，为了避免 long run 导致的一系列时域或频域问题，我们通常会对 NRZ data 进行重编码 (encoding)，以限制 long run 的最大长度 (maximum run length)。例如，**8-bit/10-bit 编码** 就是一种常用的编码方式，它将每 8-bit (1-byte) 的 NRZ data 映射为 10-bit 的编码数据，同时限制 long run 的最大长度为 5-bit。

由于 max-run-length 收到限制，重编码之后的数据 (encoded NRZ data) 的频谱特性也发生变化，容易证明有且仅有低频段频谱受到抑制，如上面的 Figure 13.7 (c) 所示。

当然，还有 、3-bit/4-bit 和 5-bit/6-bit 等多种编码方式，这两种编码的映射表如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-23-03-58-29_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

8-bit/10-bit 编码的自然也有其映射表，不过一共有 256 种映射关系，这里就不单独给出了。值得一提的是，在现代更高速的协议 (如 PCIe 4.0+) 中，8-bit/10-bit 编码已被更高效的 128-bit/130-bit 等编码取代，不过其基本原理是类似的。

**<span style='color:red'> 注意，无论是 raw NRZ data 还是 encoded NRZ data, 其频谱在 $f = n\,f_b = n \times \frac{1}{T_b}$ 处都为零，也即不具有 $\frac{1}{T_b}$ 及其谐波分量。 </span>**

## 2. Edge-Detection CDR

最简单的 CDR 结构是基于 edge-detection 的，也就是从 data transition (data edge) 中提取时钟信息。


### 2.1 edge-detection circuit

下面 Figure 13.9 是一个典型的 edge-detection 电路，也是最常用的结构 (无论低速高速)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-23-04-11-15_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

由于 delay 的存在，每一次 data transition 都产生一个脉冲，由此得到的一系列脉冲信号称为 **edge-detected data**。实际中我们常取 $\Delta T \approx \frac{T_b}{2}$ (因为很难做到恰好相等)。

不同于 NRZ data 的频谱，edge-detected data 具有丰富的 $\frac{1}{T_b}$ 成分，如 Figure 13.9 (c) 所示。再利用 PLL 的 narrow-band filtering 特性，即可从中提取出 $f = \frac{1}{T_b}$ 的时钟信号 (需要 FLL 辅助频率锁定在正确值)，这便引出了 edge-detection CDR 的基本架构，详见下一小节。


### 2.2 edge-detection CDR  

下面 Figure 13.10 (b) 是一个典型的 edge-detection CDR 架构，Figure 13.10 (c) 是其输出频谱示意图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-23-04-17-45_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

用恢复得到的时钟信号对 input data 进行 retiming (通过 DFF)，即可得到 retimed data：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-23-04-22-21_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>


由于进行 edge-detection 的 XOR gate 具有一定延迟 (delay) $\Delta T_{\mathrm{XOR}}$，最终 retiming (sampling) 的时钟会有一定延迟，也即 CK lags the ideal sampling point (data center) by $\Delta T_{\mathrm{XOR}}$，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-23-18-47-42_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>
上面左右两个时序图分别是 ideal sampling point (data center) 和考虑 XOR 异或门延迟的实际采样时序，可以看到采样时钟 CK 相对于理想采样点滞后了 $t_{delay} = \Delta T_{XOR} + \Delta T_{PLL} + \Delta T_{DFF}$，其中 $\Delta T_{PLL}$ 是 PLL 锁定后的固有相差 (这里单位是 second 而非角度)，而 $\Delta T_{DFF}$ 是 DFF 的采样延迟。

所谓 DFF "采样延迟"，或者说 retiming delay, 指的是 DFF 在时钟上升沿 (或下降沿) 到来时，并非立刻将当前时刻 DFF 输入端的数据 "采样" (保存到电路中进行处理)，而是需要经过一个短暂的建立时间 (setup time) 才能 "真正看到" 输入端的数据情况，从而完成采样动作。这与输出延迟 (output delay) 是两种不同的概念，且有 retiming delay (sampling delay) < output delay.

具体而言，当时钟上升沿 (或下降沿) 到来，DFF 输出被激活时，是第一个 D-Latch  (master latch) 先关闭，然后第二个 D-Latch (slave latch) 才打开，从而将第一个 D-Latch 中保存的数据传递到输出端。 **由于 master slave 的关闭并非瞬时完成，在彻底关闭之前，input of master latch 端的变化仍会反映到其 output 上，从而影响整个 output of DFF (output of slave D-Latch)，这段时间就是所谓的 sampling delay.**

sampling delay 可能导致电路进入亚稳态 (metastability)，影响数据的正常传输，这部分我们后面再详细介绍，这里先有个概念即可。






## 3. Phase-Locking CDR

### 3.1 PD for PLL or CDR?

我们之前接触的几种 PD for PLL 是：
- XOR PD (the simplest one)
- tri-state PFD (the most common one)
- mixer (analog multiplier, for sine input only)
- D-FF PD (basic bang-bang PD)

最常见的 PLL PD 也就差不多这几种。它们各自具有不同的频差 $(\Delta f)$ 和相差 $(\Delta \phi)$ 特性，一般说的输入输出特性都是指相差特性 (with the same frequency)，频差特性一般用于 PLL 的频率捕获过程分析。


对于 CDR 而言，上述鉴相器都没法直接使用，因为 CDR 的输入并非 periodic的连续时钟信号，而是非周期的数据信号 (DATA)，通常用 **PRBS (pseudo-random binary sequence)** 或者 run-length-limited PRBS 来模拟，后者其实就是限制了连续 0 或 1 最大长度的 PRBS (by encoding).

下面是一些常见的 phase detector (PD) for CDR:
- bang-bang (binary):
    - DFF PD (the simplest one, note that DATA samples CK)
    - Alexander PD
    - Pottbacker PD
- linear:
    - Hogge PD
    - Mueller-Muller PD

我们将在后续小节介绍其中一部分。

### 3.2 XOR as a multiplier (freq-domain convolver)

下面就以 XOR gate 为例，来分析一下它能否作为 CDR 的鉴相器 (答案是不能)。在此之前，我们先回顾一下 XOR gate 的输入输出特性：

$$
\begin{gather}
Y = A \oplus B = A'B + AB'
\end{gather}
$$

这是 XOR gate 的逻辑表达式，也是最基本的定义，但这个表达式并不能帮助我们分析 XOR 作为 PD for CDR 的可行性。为了分析输入分别为 DATA 和 CK 时，输出 Y 的时域特性或频域特性，我们需要从另一个角度来看待 XOR gate: **<span style='color:red'> XOR = time-domain multiplier = frequency-domain convolver </span>** 。

具体而言，XOR 会对两个输入的 "频谱" (实际是 DC-free spectrum) 进行卷积 (convolution)，卷积结果就是输出 Y 的 DC-free spectrum (去除了直流分量)。


下面就来证明此结论。假设输入信号 A/B 是 DC-free data (可以是 NRZ data, 也可以是 CK)，逻辑值 `ONE` 和 `ZERO` 分别对应电压 $V_0\times (+1)$ 和 $V_0\times (-1)$，也就是输入信号可以用数字码 $a[n], b[n] \in \{-1, +1\}$ 来表示。在此基础上，由真值表即可证明输出 Y 的数字码 $y[n]$ 满足：

$$
\begin{gather}
Y = A \oplus B \Longrightarrow
y = - a \times b
\\
\mathrm{where:\ \ } A,\, B,\, Y \in \{0, 1\},\quad a,\, b,\, y \in \{-1, +1\}
\end{gather}
$$

<div class='center'>

| $A$ | $B$ | $Y = A \oplus B$ | $a \times b$ | $y = - a \times b$ |
|:-:|:-:|:-:|:-:|:-:|
 | 0 | 0 | 0 | $(-1) \times (-1) = +1$ | $-1$ |
 | 0 | 1 | 1 | $(-1) \times (+1) = -1$ | $+1$ |
 | 1 | 0 | 1 | $(+1) \times (-1) = -1$ | $+1$ |
 | 1 | 1 | 0 | $(+1) \times (+1) = +1$ | $-1$ |

</div>

**由于时域乘法对应频域卷积 (convolution)，因此在不考虑输入/输出信号直流量的情况下，可以理解为 XOR gate 对两输入信号的频谱做了卷积，并由此得到输出信号频谱。**

下面是一个例子：假设输入 A/B 分别为 NRZ data 和频率为 $f_{CK} = f_b = \frac{1}{T_b}$ 的时钟 CK，由于后者的 DC-free spectrum 就是两个位于 $f = \pm f_{CK} = \pm \frac{1}{T_b}$ 的冲激函数 (impulse)，做卷积就相当于对 DC-free NRZ data 的频谱分别平移后相加，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-23-17-12-11_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>


从频域角度来看待 XOR PD，可以轻松得到 random data + CK 作为输入时的 XOR PD 频差输入输出特性：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-02-24-58_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

此频差特性并不能使 CK 频率锁定在 $f_{CK} = f_b = \frac{1}{T_b}$；而且当 $f_{CK} = f_b$ 时，因为改变 CK 相位不会影响卷积后的 DC component value，也即频率相同时输出平均值 $\overline{y(t)}$ 与相差无关，所以 XOR 的相差输出特性恒为常数，不具有鉴相功能。

综上，这样一个在 NRZ + CK 输入下，既不能鉴频也不能鉴相的 PD，自然不能作为 PD for CDR 使用。

### 3.3 bang-bang PD characteristic

这里的 bang-bang PD 即为具有 binary characteristic 的鉴相器，也就是 $\Delta \phi > 0$ 时输出 logic 1, $\Delta \phi < 0$ 时输出 logic 0 的二进制鉴相器。

在时钟抖动较小且相位差较大的情况下，binary curve 可以很好地 bang-bang PD 的输入输出特性；但是，当相位差较小以至于和时钟抖动 $\sigma_{CK}$ 在同一量级时，就不能简单 "一刀切"，而是需要从 "平均" 的角度对其作线性化。

假设法时钟抖动满足高斯分布，我们直接给出结论：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-23-23-03-54_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

分析 CDR 的瞬态锁定过程，通常会利用 bang-bang characteristic 在离散时域上进行推导；而分析其时钟/重定时数据抖动时，则可能要用到 bang-bang PD 的线性特性，线性区有 (假设满足高斯分布)：

$$
\begin{gather}
K_{PD,linear} = \frac{V_H}{3 \sigma_{CK}} \ \mathrm{V/s} = \frac{V_H}{6\pi f_{CK} \sigma_{CK}} \ \mathrm{V/rad}
\end{gather}
$$

注意此线性模型其实没有考虑 bang bang PD 的亚稳态 (metastability)，实际中亚稳态会导致线性区变宽，但多数情况下上述模型已经够用。



### 3.4 basic CDR with DFF PD

DFF PD 是最简单的 bang-bang PD for CDR，其工作原理为：**用 DATA 去采样 CK**, 假设理想情况下 DATA edge (transition) 应与 positive-edge of CK 对齐，当 CK lags DATA (DATA 在先，CK 在后) 时采用到时钟低电平，从而输出 ZERO, 反之则输出 ONE；如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-23-17-43-58_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

由 DFF PD 可以构成 phase-locking CDR 的最基本结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-23-19-13-43_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-23-23-40-03_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>


### 3.5 CDR with Alexander PD

Alexander PD 是另一种常用的 bang-bang PD for CDR. 如下图所示，其工作原理为：在 CK 的连续三个边沿处 (上/下边沿都算) 采样 DATA，得到三个采样值 $S_1, S_2, S_3$，然后根据这三个采样值的组合情况来判断 CK 相对于 DATA edge 的相位关系 (early/late)，从而输出相应的 UP/DN 信号：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-23-23-44-07_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

具体而言，当 $A = S_2 \oplus S_3 = 1$ 时，说明 CK 超前 DATA (CK early)，与此同时有 $B = S_2 \oplus S_1 = 0$；而当 $B = S_2 \oplus S_1 = 1$ 时 $(A = S_2 \oplus S_3 = 0)$，说明 CK 滞后 DATA (CK late)。

下面是两个具体的例子 (CK late 和 CK early)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-24-00-41-16_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

由于输出信号分为了两路，可以构成差分信号，因此 Alexander PD 后面一般会用 Gm + LPF 的组合而不是直接用 voltage-to-voltage LPF，如下图所示：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-24-00-41-33_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

## 4. CDR with Hogge PD

Hogge PD 是一种 linear PD for CDR (不是 bang-bang PD), 它由 synchronous edge detector (SED) 发展而来，利用了 "SED 在 CK early 时输出脉冲宽度变小" 的机制，具体电路如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-24-15-49-15_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-24-15-51-17_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

用 Hogge PD 自然也能构成 CDR 电路，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-24-15-52-42_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

注意到稳定时 vcont 上存在 ripple, 这是 A/B 时序相差 180° of CK 导致的，实际应用时需要对其进行改进：常见的思路是将 CP 换为 Gm, 然后在 Gm 输入端用电容将 A/B 的面积积累起来，并在 Gm 输出路径上添加一个 EDSW (switch driven by edge of data) 来消除 ripple，从而得到更平滑的 vcont. 当然，这会对环路参数产生一定影响，就需要具体分析了。


## 5. High-Speed Logic

前几节可以看出，CDR 中使用了许多数字电路方面的模块和技术，如 XOR gate, D flipflop, Alexander PD 的时序对齐等。其实，在数据速率不高的情况下 (100 Mbps ~ 2 Gbps)，这些模块都可看作纯粹的 CMOS 数字电路，可以用标准 CMOS 数字单元 (standard CMOS digital cell) 来实现；但是当数据速率达到数 Gbps 甚至数十 Gbps 以上时，CMOS 逻辑电路的速度和性能就无法满足要求了，模块的带宽 (工作频率) 很难达到这么高，此时就必须引入其它高速逻辑电平，如 LVDS, LVPECL 和 CML 等，来实现这些模块 (高速 Serdes 中最常用的是 CML - current mode logic)。

### 5.1 XOR implementations

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-24-15-42-22_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-24-15-42-00_Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.png"/></div>

### 5.2 CML (current-mode logic)

详见：
- [GitHub > HarshitSri-Analog > Current-Mode-Logic-Circuits-180nm](https://github.com/HarshitSri-Analog/Current-Mode-Logic-Circuits-180nm?tab=readme-ov-file)
- [Analog Design Examples from GitHub User HarshitSri-Analog](<AnalogIC/Analog Design Examples from GitHub User HarshitSri-Analog.md>)
- [High-Speed Logic Circuit - LVDS, LVPECL and CML](<AnalogIC/High-Speed Logic Circuit - LVDS, LVPECL and CML.md>)

## 6. Problem of Data Swings

As illustrated in Fig. 13.1(c), actual data suffers from heavy attenuation as it travels through a lossy channel. The small voltage swings thus created pose difficulties with respect to PD and CDR design.  

We make the following observations for the three PDs studied in this chapter:
- The single-DFF bang-bang PD requires that the data sample the clock, a difficult problem in view of the small data swings.
- The Alexander PD, on the other hand, allows the clock to sample the data, a more favorable situation as it is simpler to generate large clock swings than large data swings. 
- While sampling the data by the clock, the Hogge PD still demands large data swings for driving its first XOR gate.

Thus, the AlexanderPD is the most attractive choice at high speeds.

## Reference

- [1]. J. Lee and B. Razavi, “Analysis and modeling of bang-bang clock and data recovery circuits,” IEEE J. Solid-State Circuits, vol. 39, pp. 1571-1580, Sep. 2004.
- [2]. J. D. H. Alexander, “Clock recovery from random binary data,” Electronics Letters, vol. 11, pp. 541-542, Oct. 1975.
- [3]. B. Razavi, Y. Ota, and R. G. Swartz, “Design techniques for low-voltage high-speed digital bipolar circuits,” IEEE J. Solid-State Circuits, vol. 29, pp.332-339, March 1994.
- [4]. B. Razavi, K. F. Lee, and R. H. Yan, “Design of high-speed low-power frequency dividers and phase-locked loops in deep submicron CMOS,” IEEE J. Solid-State Circuits, vol. 30, pp. 101-109, Feb. 1995.
- [5]. C. R. Hogge, “A self-correcting clock recovery circuit,” IEEE J. Lightwave Tech., vol. 3, pp. 1312-1314, Dec. 1985.
- [6]. S. B. Anand and B. Razavi, “A 2.75-Gb/s CMOS clock and data recovery circuit with broad capture range,” ISSCC Dig. Tech. Papers, pp. 214-215, Feb. 2001.
- [7]. L. DeVito et al., “A 52 MHz and 155 MHz clock recovery PLL,” ISSCC Dig. Tech. Papers, pp. 142-143, Feb. 1991.