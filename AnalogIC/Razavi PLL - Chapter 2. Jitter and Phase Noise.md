# Razavi PLL - Chapter 2. Jitter and Phase Noise

> [!Note|style:callout|label:Infor]
> Initially published at 19:59 on 2025-08-28 in Lincang.

## 1. Brief Review of Noise

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

### 1.5 approximation of noise spectrum

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


### 2.1 jitter 

**The departure of the zero crossings of a nominally periodic waveform from their ideal time points is called "edge jitter" $J_{e}$.** 若无特别说明，后文所说的 jitter 都指 edge jitter $J_{e}$。

由一个个周期积累起来的 eye diagram 无法区分 jitter 到底是 DJ (deterministic jitter) 还是 RJ (random jitter), 因此我们常常需要到频域来分析 jitter 的成分。下面是一个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-21-40-42_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>



### 2.2 phase noise

Recall that the aberrations in the zero crossings or the period can be viewed as phase modulation and expressed as $V_{out}(t)= V_0\cos[\omega_0 t + \phi_n(t)]$. We call $\phi_n(t)$ the **phase noise**. 

通常情况下, phase noise 仅包干 random fluctuations of the phase or the zero crossings, 而 jitter 则包含 DJ (deterministic/periodic jitter) 和 RJ (random jitter) 成分。

For a sinusoid wave, let us assume $\phi_n(t) \ll 1 \ \mathrm{rad}$ and use the **narrowband FM approximation** (Example 2.6) to write:

$$
\begin{gather}
V_{out}(t)= V_0\cos[\omega_0 t + \phi_n(t)] \approx V_{out}(t)= V_0\cos(\omega_0 t) - V_0 \phi_n(t) \sin(\omega_0 t)
\end{gather}
$$

We recognize a carrier with an amplitude of V0 along with the product of $\phi_n(t)$ and $V_0 \sin (\omega_0 t)$, which corresponds to **a shift in the center frequency of the spectrum of $\phi_n(t)$** by an amount equal to $\omega_0$. 这是因为时域的乘积对应频域的卷积，而 $\sin(\omega_0 t)$ 在频域对应 $\delta(\omega - \omega_0)$, 卷积时起到平移作用。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-22-03-06_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

对于 sinusoid oscillator, 其 phase noise spectrum shape 大多比较类似，因此可以用一个或多个 phase noise (unit: dBc/Hz) at the given frequency offset 来描述振荡器的噪声性能。至于实际测量中如何计算 phase noise at the given frequency offset (unit: dBc/Hz), 见下面这个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-23-09-36_Razavi PLL - Chapter 2. Jitter and Phase Noise.png"/></div>

An important observation here is that any mechanism that modulates an oscillator’s frequency by white noise yields a phase noise profile proportional to $\frac{1}{f^2}$. This is to be expected as frequency and phase are related by a factor of $\frac{1}{s}$.

### 2.3 limitations of narrowband FM approximation



## 3. Trade-Off Between Noise and Power
## 4. Basic Phase Noise Mechanisms
## 5. Negative Effects on Performance
### 5.1 negative effects of jitter
### 5.2 negative effects of phase noise

