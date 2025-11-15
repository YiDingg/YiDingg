# Razavi PLL - Chapter 2. Jitter and Phase Noise

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 19:59 on 2025-08-28 in Lincang.

参考教材：[*Design of CMOS Phase-Locked Loops (Behzad Razavi) (1st Edition, 2020)*](https://www.zhihu.com/question/23142886/answer/108257466853)


## 1. Brief Review of Noise

**<span style='color:red'> 若无特别说明，本文所提到的 VCO 均为正弦输出。</span>**

### 1.1 Gaussian noise

For a noise with Gaussian distribution PDF (probability density function), the standard deviation of the distribution, $\sigma$, is equal to the root mean square (RMS) value of the noise. 

A useful rule of thumb for Gaussian noise is that its peak value in the time domain rarely exceeds $\pm 4 \sigma$.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-20-07-17_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

噪声没有确定幅度谱密度，进行傅里叶变换后一般不能得到有意义结果，因此通常用功率谱密度 (PSD, power spectral density) $S(f)$ 来描述噪声。

### 1.2 device noise models

在 CMOS 电路中，大多数情况下我们只考虑电阻 R 和晶体管 MOSFET 所产生的噪声。

电阻 $R$ 的噪声模型如下：

$$
\begin{gather}
S_R(f) = 4 k T R \ \ \mathrm{(V^2/Hz)},\quad k = 1.38 \times 10^{-23}\ \mathrm{J/K} \\
\end{gather}
$$

上式常常写作 $\overline{V_n^2} = 4 k T R \ \ \mathrm{(V^2/Hz)}$ 或 $\overline{I_n^2} = \frac{4 k T}{R} \ \ \mathrm{(A^2/Hz)}$，以表明噪声量到底是电压还是电流。注意噪声源是不具有正负极性的，分析电路时不必考虑其极性。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-20-20-55_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

显然，电阻噪声属于 thermal noise (热噪声)。


对于 MOSFET 而言, MOS transistors generate "**flicker noise**" (also called "1/f noise") and **thermal noise**:

$$
\begin{gather}
S_{1/f}(f) = \overline{V_n^2} = \frac{K}{C_{ox} W L} \cdot \frac{1}{f}\ \ \mathrm{(V^2/Hz)} \\
\overline{I_n^2} = 4 k T \gamma g_m \ \ \mathrm{(A^2/Hz)}
\end{gather}
$$

where $K$ is a process-dependent parameter, and $\gamma$ is called the excess noise coefficient (ideally equal to 2/3) and is about unity in short-channel devices.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-20-23-46_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-20-38-04_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

### 1.3 propagation of noise

噪声在电路中的传播可以用传递函数来描述，将噪声源 $\overline{V_{n,in}^2}$ 当作一个 deterministic source $V_{n,in}$, 求解 $V_{n,in}$ 到输出端 $V_{n,out}$ 的传递函数 $H(s)$, 则有：

$$
\begin{gather}
S_{n,out}(f) = |H(j 2 \pi f)|^2 \times S_{n,in}(f),\quad H(s) = \frac{V_{n,out}}{V_{n,in}}(s)
\end{gather}
$$

### 1.4 average power of noise

噪声的平均功率与随机信号平均功率的定义相同，还可以用功率谱积分得到：

$$
\begin{gather}
P_{x} = \overline{x^2(t)} = \lim_{T \to \infty} \frac{1}{T} \int_{-\frac{T}{2}}^{+\frac{T}{2}} x^2(t) dt = \int_{-\infty}^{+\infty} S_x(f) df
\end{gather}
$$

### 1.5 noise spectrum approx.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-20-40-44_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

### 1.6 time accumulation of noise



第一种视角：

$$
\begin{gather}
\mathrm{effective\ noise\ frequency\ range:\ } f > \frac{1}{50 t_{a}}
\end{gather}
$$

第二种视角 (HPL, high-pass filter):

$$
\begin{gather}
H_{HPF}(s) = \frac{\t_a}{2 j} \times s,\quad H(f) = H_{HPF}(j 2 \pi f) = \pi t_a \times f
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-21-03-47_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

## 2. Jitter and Phase Noise


从理想固定频率信号 (sinusoid wave or square wave) 到含有 phase noise 的频率信号，一般有三种看法：
- (a) the noise makes the periods unequal
- (b) the noise causes the instantaneous frequency to change randomly
- (c) the noise produces zero crossings that do not occur at $n\times \frac{T}{2}$

某些情况下它们可以互相转换，甚至完全等同。


### 2.1 random jitter 

**The departure of the zero crossings of a nominally periodic waveform from their ideal time points is called "edge jitter" $J_{e}$.** <!-- 若无特别说明，后文所说的 jitter 都指 edge jitter $J_{e}$。 -->

由一个个周期积累起来的 eye diagram 无法区分 jitter 到底是 DJ (deterministic jitter) 还是 RJ (random jitter), 因此我们常常需要到频域来分析 jitter 的成分。下面是一个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-21-40-42_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>



### 2.2 phase noise

Recall that the aberrations in the zero crossings or the period can be viewed as phase modulation and expressed as $V_{out}(t)= V_0\cos[\omega_0 t + \phi_n(t)]$. We call $\phi_n(t)$ the **phase noise**. 

通常情况下, phase noise 仅包含 **random fluctuations** of the phase or the zero crossings, 而 jitter 则包含 **DJ** (deterministic/periodic jitter) 和 **RJ** (random jitter) 成分。

For a sinusoid wave, let us assume $\phi_n(t) \ll 1 \ \mathrm{rad}$ and use the **narrowband FM approximation** (Example 2.6) to write:

$$
\begin{gather}
V_{out}(t)= V_0\cos[\omega_0 t + \phi_n(t)] \approx V_{out}(t) = V_0 \left[\cos(\omega_0 t) -\phi_n(t) \sin(\omega_0 t)\right]
\end{gather}
$$

We recognize a carrier with an amplitude of V0 along with the product of $\phi_n(t)$ and $V_0 \sin (\omega_0 t)$, which corresponds to **a shift in the center frequency of the spectrum of $\phi_n(t)$** by an amount equal to $\omega_0$. 这是因为时域的乘积对应频域的卷积，而 $\sin(\omega_0 t)$ 在频域对应 $\delta(\omega - \omega_0)$, **卷积时起到平移作用**。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-22-03-06_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

下面是一个 deterministic phase noise 的例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-04-02-32-15_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

$$
\begin{gather}
J_{\phi_n, pp} = 4 \times \frac{V_{\mathrm{side-band}}}{V_0} = 4 \times \frac{\frac{V_0 K_{VCO} V_m}{2 \omega_m}}{V_0} = \frac{2K_{VCO} V_m}{\omega_m}
\end{gather}
$$

对于 sinusoid oscillator, 其 phase noise spectrum shape 大多比较类似，因此可以用一个或多个 phase noise (unit: dBc/Hz) at the given frequency offset 来描述振荡器的噪声性能。至于实际测量中如何计算 phase noise at the given frequency offset (unit: dBc/Hz), 见下面这个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-23-09-36_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

An important observation here is that any mechanism that modulates an oscillator’s frequency by white noise yields a phase noise profile proportional to $\frac{1}{f^2}$. This is to be expected as frequency and phase are related by a factor of $\frac{1}{s}$.



### 2.3 autocorrelation vs. spectrum

两个能量信号 $x_1(t)$ 和 $x_2(t)$ 之间的自相关函数 (autocorrelation function) 定义为：

$$
\begin{gather}
R_{x_1, x_2}(t) = \int_{-\infty}^{+\infty} x_1(\tau + t) x_2(\tau) \ \mathrm{d}\tau
\\
R_{x_1, x_2}(n) = \sum_{m=-\infty}^{+\infty} x_1(m + n) x_2(m)
\\
R_{x_1,x_2}(t) = R_{x_2,x_1}^*(-t),\quad R_{x_1,x_2}(n) = R_{x_2,x_1}^*(-n)
\end{gather}
$$

如果是功率信号，只需将定义修改为：

$$
\begin{gather}
R_{x_1, x_2}(t) = \lim_{T \to \infty} \frac{1}{T} \int_{-\frac{T}{2}}^{+\frac{T}{2}} x_1(\tau + t) x_2(\tau) \ \mathrm{d}\tau
\\
R_{x_1, x_2}(n) = \lim_{N \to \infty} \frac{1}{N} \sum_{m=-\frac{N}{2}}^{+\frac{N}{2}} x_1(m + n) x_2(m)
\\
\mathrm{Example:}\ x(t) = A \cos(\omega t) \Longrightarrow R_{x,x}(t) = \frac{A^2}{2} \cos(\omega t)
\end{gather}
$$

特别地，单个能量信号 $x(t)$ 的自相关函数 (autocorrelation function) 定义为：

$$
\begin{gather}
R_{x,x}(t) = \int_{-\infty}^{+\infty} x(\tau + t) x(\tau) \ \mathrm{d}\tau,\quad R_{x,x}(n) = \sum_{m=-\infty}^{+\infty} x(m + n) x(m)
\end{gather}
$$

大多数情况下，信号为时域实信号，此时 $R_{x, x}(t) = R_{x, x}^*(-t) = R_{x, x}(t)$ 为实偶函数。



自相关函数最重要的性质可以由 **相关定理** 推出：

$$
\begin{gather}
\color{red}{
\begin{cases}
R_{x_1, x_2}(t) = x_{1}(t) * x_{2}(-t)
\\
\mathscr{F}\left\{R_{x_1, x_2}(t)\right\} = X_1(\omega)\cdot X_2^*(\omega)
\end{cases} } \\
\mathrm{where}\ X(\omega) = \mathscr{F}\left\{x(t)\right\} = \int_{-\infty}^{+\infty} x(t) e^{-j \omega t} \ \mathrm{d}t \\
\Longrightarrow 
\begin{cases}
{\color{red}{
E_x \mathrm{\ or\ } P_{x} = R_{x,x}(0)
}}
= \int_{-\infty}^{+\infty} |X_{f}|^2 \ \mathrm{d}f = \frac{1}{2\pi} \int_{-\infty}^{+\infty} |X_{\omega}|^2 \ \mathrm{d}\omega  \\
{\color{red}{ S_{x}(\omega) = \mathscr{F}\left\{R_{x,x}(t)\right\} }}  = X(\omega)\cdot X^*(\omega) = |X(\omega)|^2,\ \ R_{x,x}(t) = x(t) * x(-t)
\end{cases}
\end{gather}
$$

下面给出一个计算的例子。设电压信号 $V_{out}(t) = V_0 \cos[\omega_0 t + \phi_n(t)]$，其中 $\phi_n(t)$ 为白噪声，满足 $S_{\phi_n}(f) = \eta = \mathrm{\ constant}$。如何计算输出信号的功率谱 (spectrum) $S_{out}(f)$ 呢？

Razavi PLL 中给出了计算思路：
>computing the autocorrelation of the waveform and taking the Fourier transform of the result [[3]](https://search.iczhiku.com/paper/SuAUtarUX0Vkit3c.pdf).

按文献 [[3]](https://search.iczhiku.com/paper/SuAUtarUX0Vkit3c.pdf) 的思路，我们有：


$$
\begin{align}
x(t) &= V_{out}(t) = V_0 \cos[\omega_0 t + \phi_n(t)]
\\
y(t) &= \Delta \omega (t) := \frac{\mathrm{d} \phi_n(t) }{\mathrm{d} t }
\\
R_{y,y}(t) &= y(t) * y(-t) 
\\ & = \int_{-\infty}^{+\infty} y(\tau) * y(-(t - \tau)) \ \mathrm{d}\tau
\\ & = \int_{-\infty}^{+\infty} y(\tau) * y(\tau - t) \ \mathrm{d}\tau
\\ & = 2 D_{\phi_n} \delta (t)
\\ 
{\color{red}{S_{\Delta \omega}(\omega)}} &\ {\color{red}{= \mathscr{F}\left\{R_{y,y}(t)\right\} = 2 D_{\phi_n}}}
\\
{\color{red} S_{\phi_n}(\omega)} &\ {\color{red} = \frac{S_{\Delta \omega}(\omega)}{\omega^2} = \frac{2 D_{\phi_n}}{\omega^2} } \mathrm{\ \ since\ \ } \Delta \omega := \frac{\mathrm{d} \phi_n }{\mathrm{d} t }
\end{align}
$$

**where $D_{\phi_n}$ is the diffusivity** and $\delta (t)$ the Delta function. The probability density of $\phi_n(t)$ represents a Gaussian distribution centered at zero with the standard deviation $\sigma_{\phi_n}$ and diverges with time because $\sigma_{\phi_n}^2 = 2 D_{\phi_n} t$.

由此求得 $x(t) = V_{out}(t)$ 的自相关函数为：

$$
\begin{gather}
R_{x,x}(t) = \frac{V_0^2}{2} \exp (- D_{\phi_n} |\tau|) \cos (\omega \tau)
\\
S_{V_{out}}(\omega) = \mathscr{F}\left\{R_{x,x}(t)\right\} = \frac{V_0^2 D_{\phi_n}}{(\omega - \omega_0)^2 + D_{\phi_n}^2}
\\
S_{V_{out}}^{\mathrm{nor}}(\omega) = \frac{R_{x,x}(t)}{\frac{V_0^2}{2}} = \frac{2 D_{\phi_n}}{(\omega - \omega_0)^2 + D_{\phi_n}^2}
\\
(\omega - \omega_0) \gg D_{\phi_n} \Longrightarrow S_{V_{out}}^{\mathrm{nor}}(\omega) \approx \frac{2 D_{\phi_n}}{(\omega - \omega_0)^2}
\\
\max\,\left\{S_{V_{out}}^{\mathrm{nor}}(\omega)\right\} = S_{V_{out}}^{\mathrm{nor}}(\omega_0) = \frac{2}{D_{\phi_n}}
,\quad 
\max\,\left\{S_{V_{out}}(\omega)\right\} = S_{V_{out}}(\omega_0) = \frac{V_0^2}{D_{\phi_n}}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-04-01-34-50_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>


其中 $S_{V_{out}}^{\mathrm{nor}}(\omega)$ 指 normalized autocorrelation (归一化自相关函数)。文献  [[3]](https://search.iczhiku.com/paper/SuAUtarUX0Vkit3c.pdf) 还给出了时域 cycle jitter 和 cycle-to-cycle jitter 的表达式：

$$
\begin{gather}
J_{cc,rms} = \sqrt{2}\, J_{c,rms} = \sqrt{\frac{8 \pi D_{\phi_n}}{\omega_0^3}},\quad J_{c,rms} = \sqrt{\frac{4 \pi D_{\phi_n}}{\omega_0^3}}
\\
{\color{red}{D_{\phi_n} = \frac{\omega_0^3}{8\pi} \times J_{cc,rms}^2 = \frac{\omega_0^3}{4\pi} \times J_{c,rms}^2}}
\end{gather}
$$

上式的 RMS 值其实也就是 std dev (standard deviation) 标准差，重新代入后可以得到：

$$
\begin{gather}
S_{\phi_n}(\omega) = \frac{\frac{\omega_0^3}{4 \pi}\times J_{cc,rms}^2}{(\omega - \omega_0)^2 + \left(\frac{\omega_0^3}{8 \pi}\right)^2 \times J_{cc,rms}^4}
,\quad 
S_{\phi_n}(f) = S_{\phi_n}(\omega)|_{\omega = 2 \pi f} = \frac{f_0^3 \, J_{c,rms}^2}{(f - f_0)^2 + \pi^2 f_0^4 J_{c,rms}^4}
\end{gather}
$$ 

关于 narrowband FM approximation 的适用范围，我们直接应用 Razavi PLL 的原话：
>In reality, $D_{\phi_n}^2$ is small enough that it can be neglected with respect to $(\omega - \omega_0)^2$ for $\frac{|\omega - \omega_0|}{2\pi}$ above a few hundred hertz. In other words, the narrowband FM approximation still serves us well in most cases, obviating the need for distinction between $S_{\phi_n}(f)$ and $S_{V_{out}}(f)$.

这一小节表明：即便 $\phi_n(t)$ 是 phase 而 $V_{out}(t)$ 为 voltage, 两者功率谱是极其相似的，在 narrowband FM approximation 成立时，$S_{\phi_n}(f)$ 向右平移 $f_0$ 个单位即可得到 $S_{V_{out}}(f)$。

特别地，对于 **white noise** driving the control voltage of a VCO generates **white frequency noise** and **a phase noise profile proportional to $\frac{1}{f^2}$**；对于 **flicker noise** We say flicker-noise-induced phase noise follows a $\frac{1}{f^3}$ profile.


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-04-01-54-33_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

### 2.4 jitter of phase noise

任何一种随机噪声的  random  RMS jitter 都可以由其平均功率算出，而时域积分和频域积分都可以计算平均功率 (频域更方便)：

$$
\begin{gather}
P_{\phi_n,av} = \overline{\phi_n^2 (t)} = \lim_{T \to \infty} \frac{1}{T} \int_{-\infty}^{+\infty} \phi_n^2 (t) \ \mathrm{d}t = \int_{-\infty}^{+\infty} S_{\phi_n}(f) \ \mathrm{d}f = \frac{1}{2\pi} \int_{-\infty}^{+\infty} S_{\phi_n}(\omega) \ \mathrm{d}\omega
\\
J_{\phi_n, rms} \ \mathrm{(rad/s)} = \sqrt{P_{\phi_n,av}} = \sqrt{\int_{-\infty}^{+\infty} S_{\phi_n}(f) \ \mathrm{d}f},\quad J_{\phi_n, rms} \ \mathrm{(s)} = \sqrt{P_{\phi_n,av}} \times \frac{T_0}{2\pi} = \frac{\sqrt{P_{\phi_n,av}}}{2\pi f_0}
\end{gather}
$$

**<span style='color:red'> 事实上，按照 [这篇文章](https://www.analog.com/media/en/technical-documentation/tech-articles/clock-clk-jitter-and-phase-noise-conversion.pdf) 的说法，上式中以 second (秒) 为单位的 rms phase noise 就是 rms cycle jitter $J_{c,rms}$</span>** ，也就是说：

$$
\begin{gather}
{\color{red}{J_{c, rms} \ \mathrm{(s)} = J_{\phi_n, rms} \ \mathrm{(s)} }}
= \sqrt{P_{\phi_n,av}} \times \frac{T_0}{2\pi} = \frac{\sqrt{P_{\phi_n,av}}}{2\pi f_0}
\end{gather}
$$



下面是一个根据 $S_{\phi_n}(f)$ 计算 $J_{\phi_n, rms}$ 的经典例子（平均功率是面积的四倍）：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-04-02-14-13_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

<!-- $$
\begin{gather}
J_{\phi_n, rms} = 2 \sqrt{S_0 f_1} \ \mathrm{(rad/s)}
\end{gather}
$$ -->

### 2.5 types of jitter

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-04-02-43-37_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

<!-- $$
\begin{align}
&DJ_{\phi_n,pp} \ \mathrm{(rad/s)} = \frac{2 K_{VCO} V_m}{\omega_m}
\\
&RJ_{\phi_n,rms} \ \mathrm{(rad/s)} = \infty
\\
&RJ_{\Delta T,rms} \ \mathrm{(rad/s)} = \sqrt{\frac{2 \alpha}{f_0^3}}\ \ \ \left(S_{\phi_n (f)} = \frac{\alpha}{f^2}\right)
\end{align}
$$ -->

<!-- 知乎话题：

**芯片（集成电路） 54.8亿 (必选)**
电子产品 11.1亿
**芯片设计 10.1亿**
电子计算机 7.3亿
**电路 5.7亿**
微电子 5.3亿
电子工程（EE） 4.3亿
电子信息工程 3.6亿
电子 3.4亿
电子信息 2.8亿
**模拟电路 1.8亿 (必选)**
**电路设计 1.8亿**
电子技术 1.8亿
**模拟电子技术 1亿**
电子电路 0.9亿
数字电路 0.8亿
集成电路 0.7亿
模拟cmos集成电路设计（书籍）800万 -->

## 3. Trade-Off Between Noise and Power

Random phase noise directly trades with power dissipation. Hence, in most cases, **the power drawn by an oscillator is determined by the phase noise specification**.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-04-12-41-12_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

## 4. Basic Phase Noise Mechanisms

### 4.1 white noise modulation

当 VDD 具有噪声 $V_{n}$ 时：
> supply noise directly modulates the output **phase of a delay line**, but  modulates the **frequency of the oscillation**.

因此：
- 对 delay line 而言, 其**输出相位噪声** $S_{\phi_n}(\omega)$ 直接 "继承" VDD 上的噪声 $S_{V_n}(\omega)$
- 而对于 oscillator, 其**输出频率噪声** $S_{\omega_n}(\omega)$ 直接 "继承" VDD 上的噪声 $S_{V_n}(\omega)$，然后由 $S_{\phi_n}(\omega) = \frac{S_{\omega_n}(\omega)}{\omega^2}$ 得到相位噪声谱。

举个例子，如果 $V_{n}$ 为白噪声，则 delay line 的**输出相位**也是白噪声，而 oscillator 则是**输出频率**具有白噪声特性，也就是输出相位具有 $\frac{1}{f^2}$ 噪声。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-04-13-48-16_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

至于为什么 supply noise directly modulates the frequency of the oscillator, Razavi PLL page.12 给出了答案：

$$
\begin{gather}
\begin{cases}
t_D \propto \frac{1}{V_{DD}}
\\
f_{osc} \propto \frac{1}{t_D}
\end{cases}
\Longrightarrow 
f_{osc} \propto V_{DD}
\end{gather}
$$

类似地，对于 delay line, 我们有：

$$
\begin{gather}
\begin{cases}
t_D \propto \frac{1}{V_{DD}} 
\\ 
\phi \propto \frac{1}{t_D}
\end{cases}
\Longrightarrow 
\phi \propto V_{DD}
\end{gather}
$$

### 4.2 inverter

如下图，考虑一个用作 delay line 的 inverter, 其中 M1 的 white current noise 直接调制 $\Delta t \propto \Delta \phi$, 由此导致输出相位上的白噪声。由对称性可以知道, M2 的 white current noise 也会给输出相位带来白噪声。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-04-13-54-58_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

考虑完电流热噪声，再来看看 flicker noise 如何影响反相器的输出相位。

如 Figure 2.33 所示，考虑 M2 的 1/f noise, 注意到可以将 common-source 和 common-gate 作等效，于是 $V_n$ 被放到 VDD 上。由上一节知道 VDD 的噪声直接调制 output phase of a delay line, 因此相位噪声谱直接 "继承" 了 $V_n$ 的功率谱。

由对称性容易知道, M1 的 flicker noise 也是通过同样的等效方法来影响输出噪声。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-04-14-01-55_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>


### 4.3 ring oscillator

对于 ring oscillator 的情况，只需将上一小节的 "delay modulation" 换为 "frequency modulation" 即可。也即 frequency noise spectrum $S_{\omega_n}(\omega)$ 直接 "继承" flicker noise 和 white noise 的功率谱，然后利用 $S_{\phi_n}(\omega) = \frac{S_{\omega_n}(\omega)}{\omega^2}$ 便可求出相位噪声谱。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-04-14-07-31_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

### 4.4 LC oscillator

暂略。

<!-- ## 5. Negative Effects on Performance
### 5.1 negative effects of jitter
### 5.2 negative effects of phase noise -->

## References

- [1] S. O. Rice, “Mathematical analysis of random noise,” Bell Sys. Tech. J., vol. 23, pp. 282-332, July 1944.
- [2] C. C. Enz and G. C. Temes, “Circuit techniques for reducing the effects of op-amp imperfections: autozeroing, correlated double sampling, and chopper stabilization,” Proc. of IEEE, vol. 84, pp.1584-1614, Nov.1996.
- [\[3\]](https://search.iczhiku.com/paper/SuAUtarUX0Vkit3c.pdf) F. Herzel and B. Razavi, ”A study of oscillator jitter due to supply and substrate noise,” IEEE Trans. Circuits and Systems, Part II, vol. 46, pp. 56-62, Jan. 1999.