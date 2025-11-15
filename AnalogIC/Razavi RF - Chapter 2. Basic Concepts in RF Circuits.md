# Razavi RF - Chapter 2. Basic Concepts in RF Circuits

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 21:54 on 2025-09-06 in Lincang.

参考教材：[*RF Microelectronics (Behzad Razavi) (2nd Edition, 2012)*](https://www.writebug.com/static/uploads/2025/9/7/e8086c78d053e74f2d3225579e0fe0cc.pdf)


现代射频设计需要来自多个领域的诸多理论，包括信号与系统、电磁学、微波理论以及通信技术等。尽管如此，射频设计仍发展出了自己的分析方法和专用术语。本章 (本文) 主要介绍对射频电路的分析与设计至关重要的通用概念，从而弥补了与其他领域 (如模拟设计、微波理论和通信系统) 之间的距离。

本文主要内容如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-06-22-03-27_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

## 1. General Considerations

### 1.1 units in RF design

电压、电流等一次幂信号的增益，以 dB (decibels) 为单位时取 $20\log_{10} x$, 而像功率这样二次幂信号的增益，以 dB 为单位时是取 $10\log_{10} x$。

**<span style='color:red'> 为避免歧义，本文所有增益均用 $A_{V|_{\mathrm{subscript}}}$ 或 $A_{P|_{\mathrm{subscript}}}$ 表示，其它以大写字母 $A$ 表示的参数均为 amplitude 而非 amplification gain.</span>**

$$
\begin{gather}
A_{V|_\mathrm{dB}} = 20 \log_{10} A_V = 20 \log_{10} \frac{V_\mathrm{out}}{V_\mathrm{in}} 
\\
A_{P|_\mathrm{dB}} = 10 \log_{10} A_P = 10 \log_{10} \frac{P_\mathrm{out}}{P_\mathrm{in}}
\end{gather}
$$

特别地，当 $V_{in}$ 和 $V_{out}$ 都施加在相同的阻抗上时，例如 $50 \ \Omega$，则 $A_{V|_\mathrm{dB}}$ 与 $A_{P|_\mathrm{dB}}$ 在数值上是相等的：

$$
\begin{gather}
A_{P|_\mathrm{dB}} = 10 \log_{10} \frac{V_\mathrm{out,rms}^2 / R_0}{V_\mathrm{in,rms}^2 / R_0} = 20 \log_{10} \frac{V_\mathrm{out,rms}}{V_\mathrm{in,rms}} = 20 \log_{10} \frac{V_\mathrm{out,amp}}{V_\mathrm{in,amp}} = A_{V|_\mathrm{dB}}
\end{gather}
$$

当然，在大多数射频系统里，输入输出阻抗并不相同，因此上式一般不成立。

另外，我们常常用 dBm (decibels relative to 1 milliwatt) 作为正弦信号的绝对功率单位：

$$
\begin{gather}
P_{sig|_\mathrm{dBm}} = 10 \log_{10} \frac{P_{sig}}{1 \ \mathrm{mW}} = 10 \log_{10} P_{sig} + 30 = P_{sig|_\mathrm{dB}} + 30
\end{gather}
$$

一个常用值是 50 Ohm 上的 0 dBm 正弦信号表示 $V_{pp} = 632 \ \mathrm{mV}$ 或者 $V_{amp} = 316 \ \mathrm{mV}$。在学界/业界中，若无特殊说明，已知信号 dBm 功率需要计算信号幅度时，一般都默认阻抗为 50 Ohm.






### 1.2 time variance

下图是一个 time-variant 系统的例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-06-22-26-29_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>


无论以 $V_{in1}$ 还是 $V_{in2}$ 作为系统的输入 $V_{in}$, $V_{out}$ 都是 time-variant 的。由此可以得出一个重要结论: **a linear system can generate frequency components that do not exist in the input signal——the system only need be time-variant.**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-06-22-37-30_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

### 1.3 nonlinearity

暂略。

## 2. Effects of Nonlinearity

虽然我们常常用线性模型来描述模拟电路和射频电路的小信号响应，但系统的非线性特性往往会引发一些重要且小信号模型所无法预测的现象。在本节，我们讨论那些输入/输出特性能够方式近似表示为下式的 **third-order nonlinear memoryless systems**（后文简称三阶非线性系统）：

$$
\begin{gather}
y(t) = \alpha_1 x(t) + \alpha_2 x^2(t) + \alpha_3 x^3(t)
\end{gather}
$$

We may consider $\alpha_1$ as the small-signal gain of the system because the other two terms are negligible for small input swings. 


### 2.1 harmonic distortion

在现在的射频收发系统中, harmonic distortion 通常影响不大，因为输出谐波频率一般远高于系统工作频率范围，从而被一个或多个 bandpass filter 有效地抑制了。

但是偶数阶非线性会引入直流偏移 **even-order nonlinearity introduces dc offsets**。以上面的三阶非线性系统为例，将 $x(t) = A \cos (\omega t)$ 代入得到：

$$
\begin{align}
y(t) & = \frac{\alpha_2 A^2}{2} 
\\ & + \left(\alpha_1 A + \frac{3 \alpha_3 A^3}{4}\right) \cos (\omega t)
\\ & + \frac{\alpha_2 A^2}{2} \cos (2 \omega t)
\\ & + \frac{\alpha_3 A^3}{4} \cos (3 \omega t)
\end{align}
$$

上式出现了一个直流分量 $\frac{\alpha_2 A^2}{2}$，这在非差分系统 ($\alpha_2 \ne 0$) 中是必须考虑的问题。如果系统是差分系统，在 local mismatch 可以忽略的情况下，系统输出特性为奇函数，因此 $\alpha_2 = 0$。

如下图，我们以一个简单的 differential pair 为例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-07-22-10-57_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

利用平方律模型可以得到 (推导过程见 Razavi RF page.13)：

$$
\begin{gather}
V_{out} = - \frac{1}{2} \mu_n C_{ox} \left(\frac{W}{L}\right) R_D \times V_{in} \times \sqrt{\frac{4 I_{SS}}{\mu_n C_{ox} \left(\frac{W}{L}\right)} - V_{in}^2}
\\
\approx - R_D\sqrt{\mu_n C_{ox} \left(\frac{W}{L}\right) I_{SS}}  \times V_{in} + \frac{R_D\left[\mu_n C_{ox} \left(\frac{W}{L}\right)I_{SS}\right]^{\frac{3}{2}}}{8 I_{SS}^2} \times V_{in}^3
\\
\Longrightarrow 
\alpha_1 = - R_D\sqrt{\mu_n C_{ox} \left(\frac{W}{L}\right) I_{SS}} = g_m R_D,\quad 
\alpha_3 = \frac{R_D\left[\mu_n C_{ox} \left(\frac{W}{L}\right)I_{SS}\right]^{\frac{3}{2}}}{8 I_{SS}^2}
\end{gather}
$$

在后续几个小节的分析中，我们都假设系统是 balanced differential system $(\alpha_2 = 0)$，从而忽略 $\alpha_2$ 带来的影响。



### 2.2 gain compression

我们知道，对于三阶非线性系统而言，小信号模型计算得到的增益是 $\alpha_1$, 也即输入信号幅度非常小时的增益，而 $\alpha_2$ 会带来直流偏移，那么 $\alpha_3$ 对系统有什么影响呢？

一种自然的想法是，如果 $\alpha_1$ 与 $\alpha_3$ 异号，那么系统的小信号增益会随着输入幅度的增加而减小，称为 **gain compression**，上面 Figure 2.6 的差分对就是一个例子。

为了量化 $\alpha_3$ 对 gain compression 的影响程度，如 Figure 2.10 所示，我们引入 **1-dB compression point**，定义为 **"the input signal level that causes the gain to drop by 1dB."**



$1 \ \mathrm{dB} = 20 \log_{10} 10^{\frac{1}{20}} \approx 20 \log_{10} 1.12202$，于是在三阶非线性系统中，此点可以表示为：

$$
\begin{gather}
20 \log_{10} \left| \alpha_1 A_{in,1 \mathrm{dB}} \right| - 1 \ \mathrm{dB} 
\ = \ 
20 \log_{10} \left| \alpha_1 A_{in,1 \mathrm{dB}} + \frac{3}{4}\alpha_3 A_{in,1 \mathrm{dB}}^3 \right|
\\
\Longrightarrow A_{in,1 \mathrm{dB}} = \sqrt{0.145 \left|\frac{\alpha_1}{\alpha_3}\right|}
\end{gather}
$$

在输入输出阻抗不存在歧义时，也常常用 $P_{in,1 \mathrm{dB}} = A_{in,1 \mathrm{dB}}$ 来表示 1-dB compression point. The 1-dB compression point is **typically in the range of -25 dBm to -20 dBm (35.6mVpp to 63.2 mVpp in 50-Ohm system)** at the input of RF receivers.

容易知道：输入信号幅度越大，受 gain compression 影响越大。除此之外，还有一种常见情况也会使信号具有明显的 gain compression (Figure 2.12): **a large interferer accompanies the desired signal**，由此导致的 gain compression 称为 **"desensitization"**. This phenomenon lowers the signal-to-noise ratio (SNR) at the receiver output and proves critical even if the signal contains no amplitude information.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-07-22-54-12_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

为了定量分析 desensitization 的影响，我们设 $x(t) = A_1 \cos (\omega_1 t) + A_2 \cos (\omega_2 t)$，其中 $A_1 \cos (\omega_1 t)$ 是 desired signal 而 $A_2 \cos (\omega_2 t)$ 是 interferer ，且 $A_1 \ll A_2$。代入得：

$$
\begin{gather}
y(t) = \left(\alpha_1 A_1 + \frac{3}{4}A_1^3 + \frac{3}{2}\alpha_3 A_1 A_2^2\right) \cos (\omega_1 t) + \cdots
\approx 
\left(\alpha_1 + \frac{3}{2}\alpha_3 A_2^2\right) A_1\cos (\omega_1 t) + \cdots
\end{gather}
$$

当 $\alpha_1 \alpha_3 < 0$ 时，增益从 $\alpha_1$ 降为 $\alpha_1 + \frac{3}{2}\alpha_3 A_2^2$，这表明即便 $A_1$ 很小 (不足以产生明显的 gain compression)，增益仍然会因为 large interferer 的存在而降低。



### 2.3 cross modulation (CM)

除 desensitization 外， a large interferer accompanies the desired signal 时可能出现的另一个现象是 the transfer (of modulation) from the interferer to the desired signal, 称为 **cross modulation (CM)**。

具体而言，当 large interferer $A_2 \cos (\omega_2 t)$ is another amplitude-modulated (AM) signal 时，设 $A_2 = A_{2,0} (1 + m \cos \omega_m t)$, where $m$ is a constant and $\omega_m$ denotes the modulation frequency. 此时，上一小节的 $y(t)\approx \left(\alpha_1 + \frac{3}{2}\alpha_3 A_2^2\right) A_1\cos (\omega_1 t) + \cdots$ 变为：

$$
\begin{gather}
y(t) = \left[
\alpha_1 + \frac{3}{2}\alpha_3 A_{2,0}^2 \left(
    1 + \frac{m^2}{2} + \frac{m^2}{2} \cos 2\omega_m t + 2m \cos \omega_m t
    \right)
\right] A_1 \cos (\omega_1 t) + \cdots
\end{gather}
$$

这导致  the desired signal at the output suffers from amplitude modulation at $\omega_m$ and $2 \omega_m$。另外，上面是假设了 interferer $\omega_2$ is a AM signal, if it is a phase-modulated (PM) signal, the cross modulation will **NOT occur** at the output desired signal.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-07-23-14-01_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

### 2.4 intermodulation (IM)

上面 desensitization 和 cross compression 考虑的是 a single signal accompanied by **ONE** large interferer ，另一种常见且重要的情形是 a single signal accompanied by **TWO** large interferer. 

If two interferers at $\omega_1$ and $\omega_2$ are applied to a nonlinear system, the output generally exhibits components that are not harmonics of these frequencies——$(2\omega_1 \pm \omega_2)$ and $(2\omega_2 \pm \omega_1)$. Called **intermodulation (IM)**, this phenomenon arises from "mixing" (multiplication) of the two components.

还是在三阶非线性系统中设 $x(t) = A_1 \cos \omega_1 t + A_2 \cos \omega_2 t$，称为 **two-tone test**，其中 "tone" denotes "approximate pure (unmodulated) sinusoid"。代入后化简，忽略频率较高的 harmonic distortion 项，可以得到：

$$
\begin{align}
y(t) 
& = \left(a_1 A_1 + \frac{3\alpha_3 A_1^3}{4} + \frac{3\alpha_3 A_1 A_2^2}{2} \right) \cos \omega_1 t 
\\ & + \left(a_1 A_2 + \frac{3\alpha_3 A_2^3}{4} + \frac{3\alpha_3 A_2 A_1^2}{2} \right) \cos \omega_2 t
\\ & + \frac{3\alpha_3 A_1^2 A_2}{4} \left[\cos (2\omega_1 - \omega_2) + \cos (2\omega_1 + \omega_2)\right]
\\ & + \frac{3\alpha_3 A_2^2 A_1 }{4} \left[\cos (2\omega_2 - \omega_1) + \cos (2\omega_2 + \omega_1)\right]
\\ & + \cdots
\end{align}
$$

上式中的 $(2\omega_1 - \omega_2)$ 和 $(2\omega_2 - \omega_1)$ 频率分量称为 **intermodulation products**，它们可能对 desired signal 造成严重干扰，因此设计时必须加以考虑。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-07-23-56-44_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

下面举一个具体的 intermodulation (IM) 例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-08-00-01-12_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

测量 IM 的常用方法是 **two-tone test:** two pure sinusoids with **equal amplitudes** are applied to the input. 记每一个分量的幅度为 $A$，则有 normalized IM:

$$
\begin{gather}
\mathrm{Relative\ IM}\ = \frac{A_{\mathrm{IM\ products}}}{A_{\mathrm{fundamentals}}} \approx \frac{\frac{3\alpha_3 A^3}{4}}{\alpha_1 A} = \frac{3\alpha_3 A^2}{4\alpha_1} = 20 \log_{10} \left|\frac{3\alpha_3 A^2}{4\alpha_1}\right| \ \mathrm{dBc}
\end{gather}
$$

where the unit dBc denotes decibels with respect to the "carrier" to emphasize the normalization.

由于 two-tone test 得到的 $\mathrm{Relative\ IM}\ = 20 \log_{10} \left|\frac{3\alpha_3 A^2}{4\alpha_1}\right| \ \mathrm{dBc}$ 式中含有输入幅度 $A$，因此在实际中的通用性不是特别高。为此，我们希望另寻一种方法来衡量系统的 IM 程度，**third-order intercept point (IP3)** 就是这样一种方法。

IP3 方法的原理是：从一个很小的输入幅度开始做 two-tone test, 记录 fundamental 和 IM3 (third-order intermodulation) 的输出幅度，逐渐增大输入幅度再记录，最终得到 Figure 2.21 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-08-16-08-30_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-08-16-14-10_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

顺着 fundamental 和 IM3 的初始曲线作切线，所得交点即为 IP3 (third-order intercept point)，分为 input IP3 (IIP3) 和 output IP3 (OIP3)。并且可以推导得到：

$$
\begin{gather}
|\alpha_1 A_{IIP3}| = \left|\frac{3\alpha_3 A_{IIP3}^3}{4}\right| \Longrightarrow A_{IIP3} = \sqrt{\frac{4}{3}\left|\frac{\alpha_1}{\alpha_3}\right|}
\\
\frac{A_{IIP3}}{A_{1\mathrm{dB}}} = \frac{\sqrt{4/3}}{\sqrt{0.145}} 
\approx 3.03 \approx 9.6 \ \mathrm{dB}
\end{gather}
$$

第二个式子常常用来验证实际测量所得 $A_{IIP3}$ 是否合理。下面是一个具体的例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-08-16-19-02_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

<!-- $$
\begin{align}
A_{IIP3} 
   & = \sqrt{\frac{4}{3}\left|\frac{\alpha_1}{\alpha_3}\right|}
     = \sqrt{10\times \frac{A_{int}^3}{A_{sig}}}
\\ & = \frac{1}{2}\times [20 \ \mathrm{dB} + 3\times (-20 \ \mathrm{dBm}) - (-80 \ \mathrm{dBm})]
\\ & = 20 \ \mathrm{dBm}
\end{align}
$$
 -->


We should remark that second-order nonlinearity also leads to a certain type of intermodulation and is characterized by a "second intercept point" (IP2). As seen in the next section, second-order nonlinearity also affects the IP3 in cascaded systems.


### 2.5 cascaded nonlinearity

射频系统中的信号处理通常涉及多个级联模块，这些模块的非线性效应会逐一积累，从而影响系统的整体性能。这里直接给出 cascaded nonlinearity 的计算公式，具体过程见 Razavi RF page.29-32:

$$
\begin{gather}
\begin{cases}
y_1(t) = \alpha_{1} x(t) + \alpha_{2} x^2(t) + \alpha_{3} x^3(t)
\\
y_2(t) = \beta_{1} y_1(t) + \beta_{2} y_1^2(t) + \beta_{3} y_1^3(t)
\end{cases}
\Longrightarrow 
\\
\begin{aligned}
y_2(t) 
   & =  A\times (\alpha_1 \beta_1)\times  (\cos \omega_1 t + \cos \omega_2 t)
\\ & + A^3\times \left( \frac{3\alpha_3\beta_1}{4} + \frac{3\alpha_1\alpha_2\beta}{2} + \frac{3\alpha_1^3\beta_3}{4} \right) \times [\cos (2\omega_1 - \omega_2) + \cos (2\omega_2 - \omega_1)]
\\ & + \cdots 
\end{aligned}
\\
P_{1\mathrm{dB}} \approx 
,\quad 
\\
A_{IIP3} \approx \sqrt{\frac{4}{3}\left|\frac{\alpha_1\beta_1}{\alpha_3\beta_1 + 2 \alpha_1 \alpha_2 \beta_2 + \alpha_1^3\beta_3}\right|}
,\quad 
\frac{1}{A_{IIP3}^2} = \left|
    \frac{1}{A_{IIP3,1}^2} + \frac{3\alpha_2\beta_2}{2\beta_1} + \frac{\alpha_1^2}{A_{IIP3,2}^2}
\right|
\end{gather}
$$

当多个模块级联时，我们有近似：

$$
\begin{gather}
\frac{1}{A_{IP3}^2} \approx \frac{1}{A_{IIP3}^2}  + \frac{\alpha_1^2}{A_{IIP3,2}^2} \Longrightarrow 
\\
\frac{1}{A_{IP3}^2} \approx \frac{1}{A_{IIP3}^2}  + \frac{\alpha_1^2}{A_{IIP3,2}^2} + \frac{\alpha_1^2\beta_1^2}{A_{IIP3,3}^2} + \cdots
\end{gather}
$$

### 2.6 AM/PM conversion

暂略。

## 3. Noise in RF Circuits

我们已经在 Razavi CMOS 和 Razavi PLL 两本书中较详细地学习过噪声相关的内容，类似地内容我们不再赘述，这里仅介绍射频电路中噪声的特有现象和分析方法。



### 3.1 random noise

略。

### 3.2 noise spectrum

略。

### 3.3 noise transfer

略。

### 3.4 device noise

之前的学习中没有涉及 **noise in bipolar transistors**，这里简单提一下：

$$
\begin{align}
\overline{I_{n,b}^2} &= 2 q I_B = 2 q \frac{I_C}{\beta}
\\
\overline{I_{n,c}^2} &= 2 q I_C = 4 k T (g_m/2)
\\
\overline{V_{n,b}^2} &= 4 k T R_B
\end{align}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-08-17-05-09_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

### 3.5 noise figure

Noise figure (NF) 是衡量射频系统噪声性能的一个重要指标，体现了系统在信号传输前后信噪比 (SNR) 的变化情况：

$$
\begin{gather}
\mathrm{Noise\ Factor} = \mathrm{NF} = \frac{\mathrm{SNR}_{\mathrm{in}}}{\mathrm{SNR}_{\mathrm{out}}}
\\
\mathrm{Noise\ Figure} = \mathrm{NF|_{dB}} = 10 \log_{10} \mathrm{NF}
\end{gather}
$$

那么如何计算 NF 呢？以 Figure 2.48 的信号接收为例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-09-15-33-37_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

图中 $R_S$ 与 $\overline{V_{n,R_S}^2} = 4 k T R_S$ 分别是天线的输出阻抗和热噪声，计算时注意 LNA 的输入阻抗为 $Z_{in} < \infty$，因此需要考虑输入端的 attenuation 分压，我们有：

$$
\begin{gather}
\mathrm{SNR}_{in} = \frac{|\alpha|^2V_{in,rms}^2}{\ |\alpha|^2\overline{V_{n,R_S}^2}\ } = \frac{V_{in,rms}^2}{4 k T R_S},\quad \alpha = \frac{Z_{in}}{Z_{in} + R_S}
\\
\mathrm{SNR}_{out} = \frac{V_{out,rms}^2}{\overline{V_{n,out}}^2} = \frac{|\alpha|^2A_v^2V_{in,rms}^2}{|\alpha|^2 A_v^2 \overline{V_{n,R_S}^2} + \overline{V_{n}^2}} = \frac{V_{in,rms}^2}{ \overline{V_{n,R_S}^2} + \frac{\overline{V_{n}^2}}{|\alpha|^2A_v^2}}
\\
\mathrm{NF} = \frac{\mathrm{SNR}_{in}}{\mathrm{SNR}_{out}} = 1 + \frac{\overline{V_{n}^2}}{|\alpha|^2 A_v^2 \overline{V_{n,R_S}^2}} = \frac{\overline{V_{n,out,total}^2}}{A_0^2 \overline{V_{n,R_S}^2}},\quad A_0 = |\alpha| A_v = \frac{V_{out}}{V_{in}}
\end{gather}
$$

where $V_{n,out,total}^2 = |\alpha|^2 A_v^2 \overline{V_{n,R_S}^2} + \overline{V_{n}^2}$ denotes the total noise measured at the output. 下面是一个具体的例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-09-18-22-50_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>


### 3.6 cascaded NF

如下图，当两级或更多模块级联起来时，整体的 NF (noise figure) 变为：

$$
\begin{gather}
\mathrm{NF}_{total} = \mathrm{NF_1} + \frac{\mathrm{NF_2} - 1}{A_{P_1}^{\mathrm{ava}}}
\\
\mathrm{NF}_{total} = 1 + (\mathrm{NF_1} - 1) + \frac{\mathrm{NF_2} - 1}{A_{P_1}^{\mathrm{ava}}} + \cdots + \frac{\mathrm{NF_n} - 1}{A_{P_1}^{\mathrm{ava}} A_{P_2}^{\mathrm{ava}} \cdots A_{P_{n-1}}^{\mathrm{ava}}}
\\
\mathrm{Available\ Power\ Gain:}\ 
A_{P}^{\mathrm{ava}} := \frac{P_{in}^{\mathrm{ava}}}{P_{out}^{\mathrm{ava}}} = \frac{V_{in,rms}^2 / R_S}{V_{out,rms}^2 / R_{out}} = \frac{V_{in,amp}^2 / 2R_S}{V_{out,amp}^2 / 2R_{out}}
\end{gather}
$$

where $R_S$ and $R_{out}$ denote the source and output resistances, respectively. 并且注意 available power gain $A_{P}^{\mathrm{ava}}$ 的分子是 input.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-14-06-49_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

### 3.7 lossy NF

无源器件构成的匹配网络不仅会降低信号的幅度，还会引入额外的噪声，从而影响系统噪声性能。可以证明, lossy circuits 的 NF (noise figure) 与其 lose factor $L$ 是相等的：

$$
\begin{gather}
\mathrm{NF} = L = \frac{V_{in}^2/R_S}{V_{Thev}^2/R_{out}}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-14-25-20_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

## 4. Dynamic Range

暂略。

## 5. Passive Impedance Transformation

<div class='center'>

|  | $C$ | $L$ |
|:-:|:-:|:-:|
 | $Q_S$ | $\frac{\frac{1}{\omega C_S}}{R_S}$ | $\frac{\omega L_S}{R_S}$ |
 | $Q_P$ | $\frac{R_P}{\frac{1}{\omega C_P}}$ | $\frac{R_P}{\omega L_P}$ |
</div>

串并联之间的等效转换：

$$
\begin{gather}
\begin{cases}
R_P = (1 + Q^2) R_S
\\
C_P = \frac{Q^2}{Q^2 + 1} C_S
\\
Q_P = Q_S = Q
\end{cases}
,\quad 
\begin{cases}
R_P = (1 + Q^2) R_S
\\
L_P = \frac{Q^2 + 1}{Q^2} L_S
\\
Q_P = Q_S = Q
\end{cases}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-14-31-23_Razavi RF - Chapter 2. Basic Concepts in RF Circuits.png"/></div>

之所以说上面是 "等效" 的，是因为绝大多数模块都具有极窄的带宽，在这个给定带宽范围内，品质因子 $Q$ 可以看作是常数，因此上面的等效成立。