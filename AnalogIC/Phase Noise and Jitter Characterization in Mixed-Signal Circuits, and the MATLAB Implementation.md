# Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 20:18 on 2025-11-05 in Beijing.

## 1. Introduction and Summary

前置文章： 
- [Razavi PLL - Chapter 2. Jitter and Phase Noise](<AnalogIC/Razavi PLL - Chapter 2. Jitter and Phase Noise.md>)
- [Phase Noise and Jitter in Mixed-Signal Circuits](<AnalogIC/Phase Noise and Jitter in Mixed-Signal Circuits.md>)
- [Phase Noise and Jitter Calculation using MATLAB](<AnalogIC/Phase Noise and Jitter Calculation using MATLAB.md>)

在前面的几篇文章中，我们介绍了相位噪声和抖动的基本概念，它们在混合信号电路 (例如 PLL) 中的表现形式/计算方法，并给出了 MATLAB 代码示例。然而，无论是理论介绍还是代码实现，上述内容或多或少有不完备的地方，本文将对其进行补充和修正，并给出较全面的总结，以便读者更好地理解、掌握并应用这些知识。


相位噪声 (Phase Noise) 和抖动 (Jitter) 是描述时钟信号质量的两个重要指标。这两大块下面又可以细分为多种类型，并且之间存在密切的联系，有的参数之间可以相互转换，有的参数之间则存在某种特殊数学关系。

**<span style='color:red'> 若无特别说明，本文用 "Frequency Spectrum (频率谱)" 指代纵坐标以 Volt, second, rad 等一次物理量为单位的频谱，而将纵坐标以 Volt^2, second^2, rad^2 等二次物理量为单位的频谱称为 "Power Spectrum (功率谱)"。</span>**



这里先给出相噪/抖动全文总结，再进行详细介绍：



先是一些基本定义：

$$
\begin{gather}
\mathrm{noisy\ voltage\ signal:\ \ } v(t) = V_{amp}(t) \cos (\phi(t)) =  [V_0 + V_\alpha(t)]\cos (\omega_c t + \phi_n(t) + \phi_0)
\\
\mathrm{where:\ \ }V(t) = V_0 + V_\alpha(t),\quad 
\phi(t) = \omega_c t + \phi_n(t) + \phi_0,\quad 
f_{n,nor}(t) := f_n(t)/f_c
\\
\begin{cases}
\mathrm{angular\ frequency\ noise:\ }& \omega_n(t) = \omega(t) - \omega_c = \frac{\mathrm{d} \phi(t)}{\mathrm{d}t} - \omega_c = \frac{\mathrm{d} \phi_n(t)}{\mathrm{d}t} \\
\mathrm{frequency\ noise:\ \ }& f_n(t) = f(t) - f_c = \frac{1}{2\pi}\left(\frac{\mathrm{d} \phi(t)}{\mathrm{d}t} - \omega_c\right) = \frac{1}{2\pi} \frac{\mathrm{d} \phi_n(t)}{\mathrm{d}t} \\
\mathrm{normalized\ frequency\ noise:\ }& f_{n,nor}(t) = \frac{f_n(t)}{f_c} = \frac{1}{2\pi f_c} \frac{\mathrm{d} \phi_n(t)}{\mathrm{d}t} \\
\mathrm{amplitude\ noise:\ \ } & \alpha(t) = V_{amp}(t) - V_0 = V_\alpha(t)
\end{cases}
\\ 
\end{gather}
$$

$$
\begin{gather}
\begin{cases}
S_{\phi_n}(f) = \frac{S_{\omega_n}(f)}{(2\pi f)^2} = \frac{S_{f_n}(f)}{f^2} = \frac{f_c^2 S_{f_{n,nor}}(f)}{f^2}
\\
S_{f_n}(f) = f_c^2 S_{f_{n,nor}}(f) = \frac{S_{\omega_n}(f)}{(2\pi)^2} = f^2 S_{\phi_n}(f)
\end{cases}
\end{gather}
$$

然后是相位噪声 (phase noise) 的定义：

$$
\begin{gather}
\mathscr{L}(f_m) := \frac{S_{v}(f_c + f_m)}{P_c}
\\
L(f_m) \ \mathrm{(Hz^{-1})} = \frac{S_v(f_c + f_m)\ \mathrm{(W/Hz)}}{P_c \ \mathrm{(W)}}
\\
L(f_m) \ \mathrm{(dBc/Hz)} = S_v(f_c + f_m)\ \mathrm{(dBm/Hz)} - P_c \ \mathrm{(dBm)}
\end{gather}
$$

$$
\begin{gather}
\mathscr{L}(f_m) = \frac{S_{v}(f_c + f_m)}{P_c},\quad 
P_c = \int_{f_c - \Delta f}^{f_c + \Delta f} S_v(f) \mathrm{d}f
\end{gather}
$$


$$
\begin{gather}
\begin{cases}
\mathrm{small\ noise\ angle\ hypothesis:\ } 
\begin{cases}
\phi_{n,rms} < 0.01 \ \mathrm{rad} = 0.5730^\circ
\\
\phi_{n,pp} < 0.20 \ \mathrm{rad} = 11.4592^\circ
\end{cases}
\\
\mathrm{negligible\ AM\ noise:\ \ } V_\alpha(t) \ll V_0
\end{cases}
\\
\Longrightarrow 
\color{red}{
\boxed{
\mathscr{L}(f_m) \approx \frac{1}{2} S_{\phi_n}(f)\big|_{f = f_m}
}
}
\end{gather}
$$

其次是抖动 (jitter) 的定义：

$$
\begin{gather}
T_0 = \frac{1}{N - 1} \sum_{n=1}^{N-1} T[n]
\\
T[n] = \mathrm{edge}[n + 1] - \mathrm{edge}[n],\quad n = 1, 2,..., N - 1
\\
\mathrm{Types\ of\ jitter:}
\begin{cases}
J_{c}[n] = T[n] - T_0 &,\  n = 1, 2,..., N
\\
J_{cc,L}[n] = T[n + L] - T[n] &,\  n = 1, 2,..., N - L
\\
J_{e}[n] = \mathrm{edge}[n] - \mathrm{edge}_{id}[n] &,\  n = 1, 2,..., N
\\
J_{ee,L}[n] = J_{e}[n + L] - J_{e}[n] &,\  n = 1, 2,..., N - L
\end{cases}
\end{gather}
$$

从 IEEE Standard 2020 中总结的常用抖动类型如下：

<span style='font-size:12px'> 
<div class='center'>

| Abbreviation | Full Name | Definition (IEEE Standard 2020) | Definition Expression | Equivalent Expression |
|:-|:-|:-|:-|:-:|
 | PEJ | period jitter | <div class='center' style='font-size:10px; width:170px'> The jitter in the period of a repetitive signal or its waveform. </div> | $J_{PEJ}[n] = T[n] - T_0,\ \ n = 1, 2,..., N$ | $J_{PEJ}[n] = J_c[n] = J_{ee,1}[n] = \left(J_e[n+1] - J_e[n]\right)$ |  |
 | TIE | time interval error | <div class='center' style='font-size:10px; width:170px'> The difference between two specified time intervals, each delimited by two event occurrences; the first interval is in the actual waveform and the other is in the ideal waveform. </div> | $J_{TIE,L}[n] = (\mathrm{edge}[n + L] - \mathrm{edge}[n]) - (\mathrm{edge}_{id}[n + L] - \mathrm{edge}_{id}[n])$ | $J_{TIE,L}[n] = J_{ee,L}[n] = J_{e}[n + L] - J_{e}[n] $ <br> $J_{TIE,1}[n] = J_{ee,1}[n] = J_c[n] = J_{PEJ}[n]$ |
 | TE | timing error | <div class='center' style='font-size:10px; width:170px'> The difference between the actual reference instant of an event and its ideal value. </div> | $J_{TE}[n] = \mathrm{edge}[n] - \mathrm{edge}_{id}[n]$ | $J_{TE}[n] = J_e[n]$ |
 | C2C | cycle-to-cycle jitter | <div class='center' style='font-size:10px; width:170px'> The difference between consecutive period durations in an ideally periodic signal. </div> | $J_{C2C}[n] = T[n + 1] - T[n],\ n = 1, 2,..., N - 1$ | $J_{C2C}[n] = J_{cc}[n]$ |

</div>
</span>

最后是从相位噪声频谱计算抖动：


$$
\begin{align}
\mathrm{RMS\ phase\ jitter:\ \ } 
J_{\phi_n, rms} & = \sqrt{\int_{f_L}^{f_H} S_{\phi_n}(f) \ \mathrm{d}f} 
\\ & = \sqrt{\int_{f_L}^{f_H} 2 L(f_m) \ \mathrm{d}f_m}
\\ \mathrm{RMS\ TIE\ jitter:\ \ } J_{TIE, L, rms} 
& = J_{ee,L,rms} 
\\ & = \sqrt{ \int_{f_L}^{f_H} S_{\phi_n}(f) \times 4 \sin^2 (\pi f \tau) \ \mathrm{d}f }
\\ & = \sqrt{ \int_{f_L}^{f_H} L(f_m) \times 8 \sin^2 (\pi f_m \tau) \ \mathrm{d}f_m }
\\ \mathrm{where:\ \ } & \tau = L \times T_s, L = 1, 2, 3, ...
\end{align}
$$

## 2. Phase Noise

### 2.1 basic definitions

无论采用何种测量方法，phase noise 的定义都是不变的。一个带有 Phase-Modulation (PM) 和 Amplitude-Modulation (AM) 噪声的电压信号可以表示为：

$$
\begin{gather}
v(t) = V_{amp}(t) \cos (\phi(t)) =  [V_0 + V_\alpha(t)]\cos (\omega_c t + \phi_n(t) + \phi_0)
\\
V(t) = V_0 + V_\alpha(t),\quad 
\phi(t) = \omega_c t + \phi_n(t) + \phi_0,\quad 
f_{n,nor}(t) := f_n(t)/f_c
\\
\begin{cases}
\mathrm{angular\ frequency\ noise:\ }& \omega_n(t) = \omega(t) - \omega_c = \frac{\mathrm{d} \phi(t)}{\mathrm{d}t} - \omega_c = \frac{\mathrm{d} \phi_n(t)}{\mathrm{d}t} \\
\mathrm{frequency\ noise:\ }& f_n(t) = f(t) - f_c = \frac{1}{2\pi}\left(\frac{\mathrm{d} \phi(t)}{\mathrm{d}t} - \omega_c\right) = \frac{1}{2\pi} \frac{\mathrm{d} \phi_n(t)}{\mathrm{d}t} \\
\mathrm{normalized\ frequency\ noise:\ }& f_{n,nor}(t) = \frac{f_n(t)}{f_c} = \frac{1}{2\pi f_c} \frac{\mathrm{d} \phi_n(t)}{\mathrm{d}t} \\
\mathrm{amplitude\ noise:\ }& \alpha(t) = V_{amp}(t) - V_0 = V_\alpha(t)
\end{cases}
\\ 
\end{gather}
$$

假设噪声源都是白噪声 (white noise)，则理论上这些噪声 (的功率谱) 之间满足以下关系：
$$
\begin{gather}
\begin{cases}
S_{\phi_n}(f) = \frac{S_{\omega_n}(f)}{(2\pi f)^2} = \frac{S_{f_n}(f)}{f^2} = \frac{f_c^2 S_{f_{n,nor}}(f)}{f^2}
\\
S_{f_n}(f) = f_c^2 S_{f_{n,nor}}(f) = \frac{S_{\omega_n}(f)}{(2\pi)^2} = f^2 S_{\phi_n}(f)
\end{cases}
\end{gather}
$$


### 2.2 SSB phase noise L_fm

上面这些公式都是纯理论内容，不能对实际测量提供直接帮助。为解决这个问题，人们定义了函数 $\mathscr{L}(f_m)$，它表示在频率偏移 $f_m$ 处，信号功率谱 $S_v(f)$ 与载波功率 $P_c$ 的比值：

$$
\begin{gather}
\mathscr{L}(f_m) := \frac{S_{v}(f_c + f_m)}{P_c}
\\
L(f_m) \ \mathrm{(Hz^{-1})} = \frac{S_v(f_c + f_m)\ \mathrm{(W/Hz)}}{P_c \ \mathrm{(W)}}
\\
L(f_m) \ \mathrm{(dBc/Hz)} = S_v(f_c + f_m)\ \mathrm{(dBm/Hz)} - P_c \ \mathrm{(dBm)}
\end{gather}
$$


$\mathscr{L}(f_m)$ 的全称是 **single-sideband (SSB) phase noise power spectrum normalized to carrier power ratio [[2]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9364950)**，常见的简称有：
- SSB phase noise to carrier ratio [[2]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9364950)
- SSB phase noise spectrum
- SSB phase noise [[3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1703773)
- phase noise spectrum [[4]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7219391)
- normalized phase noise spectrum
- loop phase noise [[1]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=4785494)

注意 single-sideband (SSB) 和平常说的 "单边" single-sided (one-sided) 不同，前者 SSB 是将频率范围从 $[-\frac{f_s}{2}, \frac{f_s}{2}]$ 直接截断/限制到 $[0, f_{s}/2]$，并没有做 "乘二" 处理；而后者 single-sided 则是将负频率部分的频谱 "赋值" 到正频率部分，此时功率谱密度会乘以 2.



有了基本定义，得到 $\mathscr{L}(f_m)$ 最直接的方法自然就是测量输出信号的功率谱 $S_v(f)$，然后计算出 $\mathscr{L}(f_m)$：

$$
\begin{gather}
\mathscr{L}(f_m) = \frac{S_{v}(f_c + f_m)}{P_c},\quad 
P_c = \int_{f_c - \Delta f}^{f_c + \Delta f} S_v(f) \mathrm{d}f
\end{gather}
$$

这种方法被称为 direct power spectrum measurement. 需要注意的是，由于载波频率 $f_c$ 这单个频点的功率是 "无法直接测量的" (只有理想信号才能得到)，因此实际测量中 $P_c$ 是以 $f_c$ 为中心频率，结合设置好的仪器分辨带宽 RBW (resolution bandwidth) 测量得到；而理论计算时，$P_c$ 一般是在 $f_c$ 附近积分得到，也即在 $[f_c - \Delta f, f_c + \Delta f]$ 上对 $S_v(f)$ 进行积分，$\Delta f$ 的选取视具体测量情况而定。



另外，如果实际信号的 AM 噪声非常小 (可以忽略不计)，并且相位噪声 $\phi_n(t)$ 的 rms 和 peak-to-peak 值也足够小 (called "small noise angle" hypothesis)，那么 SSB phase noise $\mathscr{L}(f_m)$ 就可由 $S_{\phi_n}(f)$ 近似计算得到：

$$
\begin{gather}
\begin{cases}
\mathrm{small\ noise\ angle\ hypothesis:\ } 
\begin{cases}
\phi_{n,rms} < 0.01 \ \mathrm{rad} = 0.5730^\circ
\\
\phi_{n,pp} < 0.20 \ \mathrm{rad} = 11.4592^\circ
\end{cases}
\\
\mathrm{negligible\ AM\ noise:} V_\alpha(t) \ll V_0
\end{cases}
\\
\Longrightarrow 
\color{red}{
\boxed{
\mathscr{L}(f_m) \approx \frac{1}{2} S_{\phi_n}(f)\big|_{f = f_m}
}
}
\end{gather}
$$

这个近似关系的具体证明过程见文献 [[2] “IEEE Standard for Jitter and Phase Noise,” IEEE Std 2414-2020, pp. 1–42, Feb. 2021, doi: 10.1109/IEEESTD.2021.9364950.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9364950)，它是 phase detection method 的理论基础。Phase detection method 利用公式：

$$
\begin{gather}
S_{\phi_n}(f) = \frac{\phi_{n,rms}^2(f + BW)}{BW}
\end{gather}
$$

测量得到相位噪声 $\phi_n(t)$ 的功率谱 $S_{\phi_n}(f)$，最后用近似公式 $L(f_m) \approx \frac{1}{2} S_{\phi_n}(f)\big|_{f = f_m}$ 计算出 SSB phase noise $\mathscr{L}(f_m)$。



上面提到的 direct power spectrum measurement 和 phase detection method  是目前最基本的两种相位噪声测量方法，除此之外，还有 frequency detection method 和 cross-correlation method 等，感兴趣的读者可到 **6. Further Reading** 一节查阅相关资料。



## 3. Jitter

### 3.1 basic definitions

Jitter 的种类繁多，且各类抖动之间或多或少存在一些数学关系。我们不妨直接引用 IEEE 标准来看看哪些抖动类型是最常用的：
> [[7]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9366669) "IEEE Standard Specification Format Guide and Test Procedure for Single-Axis Interferometric Fiber Optic Gyros," in IEEE Std 952-1997, vol., no., pp.1-84, 30 Nov. 1997, [doi: 10.1109/IEEESTD.1997.9366669.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9366669)

本文所用的一些基本符号含义：

$$
\begin{gather}
T_0 = \frac{1}{N - 1} \sum_{n=1}^{N-1} T[n]
\\
T[n] = \mathrm{edge}[n + 1] - \mathrm{edge}[n],\quad n = 1, 2,..., N - 1
\\
\mathrm{Types\ of\ jitter:}
\begin{cases}
J_{c}[n] = T[n] - T_0 &,\  n = 1, 2,..., N
\\
J_{cc,L}[n] = T[n + L] - T[n] &,\  n = 1, 2,..., N - L
\\
J_{e}[n] = \mathrm{edge}[n] - \mathrm{edge}_{id}[n] &,\  n = 1, 2,..., N
\\
J_{ee,L}[n] = J_{e}[n + L] - J_{e}[n] &,\  n = 1, 2,..., N - L
\end{cases}
\end{gather}
$$

从 IEEE Standard 2020 中总结的常用抖动类型如下：

<span style='font-size:12px'> 
<div class='center'>

| Abbreviation | Full Name | Definition (IEEE Standard 2020) | Definition Expression | Equivalent Expression |
|:-|:-|:-|:-|:-:|
 | PEJ | period jitter | <div class='center' style='font-size:10px; width:300px'> The jitter in the period of a repetitive signal or its waveform. </div> | $J_{PEJ}[n] = T[n] - T_0,\ \ n = 1, 2,..., N$ | $J_{PEJ}[n] = J_c[n] = J_{ee,1}[n] = \left(J_e[n+1] - J_e[n]\right)$ |  |
 | TIE | time interval error | <div class='center' style='font-size:10px; width:300px'> The difference between two specified time intervals, each delimited by two event occurrences; the first interval is in the actual waveform and the other is in the ideal waveform. </div> | $J_{TIE,L}[n] = (\mathrm{edge}[n + L] - \mathrm{edge}[n]) - (\mathrm{edge}_{id}[n + L] - \mathrm{edge}_{id}[n])$ | $J_{TIE,L}[n] = J_{ee,L}[n] = J_{e}[n + L] - J_{e}[n] $ <br> $J_{TIE,1}[n] = J_{ee,1}[n] = J_c[n] = J_{PEJ}[n]$ |
 | TE | timing error | <div class='center' style='font-size:10px; width:300px'> The difference between the actual reference instant of an event and its ideal value. </div> | $J_{TE}[n] = \mathrm{edge}[n] - \mathrm{edge}_{id}[n]$ | $J_{TE}[n] = J_e[n]$ |
 | C2C | cycle-to-cycle jitter | <div class='center' style='font-size:10px; width:300px'> The difference between consecutive period durations in an ideally periodic signal. </div> | $J_{C2C}[n] = T[n + 1] - T[n],\ n = 1, 2,..., N - 1$ | $J_{C2C}[n] = J_{cc}[n]$ |

</div>
</span>

其它类型抖动：

<div class='center'>

| Abbreviation | Full Name | Definition (IEEE Standard 2020) | Definition Expression | Equivalent Expression |
|:-|:-|:-|:-|:-:|
 | DJ | deterministic jitter |  <div class='center' style='font-size:10px; width:300px'> The contribution to the jitter in which successive reference instants are deterministically predicted. </div> |  |  |
 | RJ | random jitter | <div class='center' style='font-size:10px; width:300px'> The contribution to the jitter in which successive reference instants cannot be deterministically predicted and, thus, must be described in statistical terms. </div> |  |  |

</div>


### 3.2 rms/pp jitter 

在实际 jitter 测量中，仿真/测量得到的波形总是含有 random noise (随机噪声)，而随机噪声是 unbounded 的，随着测量时间变长/点数增多，噪声值的 peak-to-peak value 会逐渐增大。此时简单地用最大值减去最小值并不能正确反映一个系统的噪声性能，于是人们根据 RMS jitter 的值，假设其满足 Gaussian distribution (正态分布) 定义了一种新的 peak-to-peak jitter。具体内容详见 [{15} The Designer’s Guide Community >  Predicting the Phase Noise and Jitter of PLL-Based Frequency Synthesizers](https://designers-guide.org/analysis/PLLnoise+jitter.pdf) page 26 of 52, 这里直接给出截图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-24-00-34-48_Jitter and Phase Noise in Mixed-Signal Circuits.png"/></div>

上图的 Error Rate 指发生错误的概率，也就是高斯分布中两端剩余面积占总面积的比例。显然, Error Rate 越小，两端面积越小，根据 $J_{PP} = \alpha J_{RMS}$ 计算得到的 PP 值就越大。


## 4. Calculation Methods

### 4.0 general considerations

前面几个小节中，我们已经掌握了相位噪声和抖动的基本概念、定义和测量思路，本小节就来介绍几种常见的相位噪声/抖动计算方法，以及一些特殊的噪声分析方法 (例如 Allan variance method)。


对于一个 "稳定的" 时钟/正弦信号，常规噪声分析的基本需求是： **已知时域波形 $v(t)$ 的情况下，计算出信号的相位噪声功率谱 $S_{\phi_n}(f)$ 和 SSB 相位噪声谱 $\mathscr{L}(f_m)$，以及各种类型的抖动 (rms/pp)。**

### 4.1 zero-crossing method

>[[6]](https://www.nist.gov/sites/default/files/documents/calibrations/tn1337.pdf) NIST Technical Note 1337. “Characterization of Clocks and Oscillators,” edited by D.B. Sullivan, D.W. Allan, D.A. Howe, F.L. Walls, 1990. 


zero-crossing method 是 D.W. Allan 等人在 1990 年提出的一种经典相位噪声/抖动计算方法，其主要结论为下面这个公式：

$$
\begin{align}
\Delta t_{rms}^2 (\tau)|_{\tau = L T_0}
& = J_{ee,L,rms}^2 = J_{TIE,L,rms}^2
\\ & = \frac{T_0^2}{\pi^2} \int_{0}^{+\infty} S_{\phi_n}(f) \sin^2 (\pi f \tau) \mathrm{d}f 
\\ & = \frac{1}{\omega_0^2} \int_{0}^{+\infty} S_{\phi_n}(f)\cdot 4\sin^2 (\pi f \tau) \mathrm{d}f
\end{align}
$$

$$
\begin{gather}
\mathrm{where\ \ } \tau  = (t_2 - t_1) = T_0,\ 2 T_0,\ 3 T_0,\ ...
\end{gather}
$$

这个公式就意义其实就是在相位噪声谱 $S_{\phi_n}(f)$ 已知的情况下，取计算出 TIE 抖动的值。




下面就来详细推导一下。

对于一个带有相位噪声的实际信号 $V(t) = V_{0}\cos \left(\omega_0 t + \phi_n(t)\right)$，在其上任意找到两个 (positive-edge) zero-crossing point $V(t_1) = V(t_2) = 0$，这时两点之间的相位差便是 $ 2\pi L$，其中整数 $L$ 是 $t_1$ 到 $t_2$ 经过的周期数，于是有：

$$
\begin{gather}
\begin{cases}
V(t_1) = 0
\\
V(t_2) = 0
\end{cases}
\Longrightarrow 
\begin{cases}
\omega_0 t_1 + \phi_n(t_1) = 2\pi m
\\
\omega_0 t_2 + \phi_n(t_2) = 2\pi (m + N)
\end{cases}
\\
\Longrightarrow 
\omega_0 (t_2 - t_1) + \left(\phi_n(t_2) - \phi_n(t_1)\right) = 2\pi N
\\
\mathrm{note\ that:\ \ } t_2 - t_1 = N T_0 + J_{ee,L}[n]
\Longrightarrow J_{ee,L}[n] = \frac{1}{\omega_0} \left(\phi_n(t_2) - \phi_n(t_1)\right)
\end{gather}
$$

上式两边同时取平均功率 (mean square, 平均平方值)。对于左边，是一个离散时间信号 $J_{ee,L}[n]$，因此求平均功率的方式是平方后求和取平均 $\lim_{N\to \infty} \frac{1}{N} \sum_{n=1}^{N} f[n]^2$，而右边是连续时间 (功率) 信号 $\phi_n(t)$，需要平方后求积分 $\lim_{T\to \infty} \frac{1}{T} \int_{0}^{T} f(t)^2 \ \mathrm{d}t$，得到：

$$
\begin{gather}
\left<J_{ee,L}^2[n]\right> = \frac{1}{\omega_0^2} \left<\left[\phi_n(t_2)^2 + \phi_n(t_1)^2 - 2 \phi_n(t_2) \phi_n(t_1)\right]\right>
\end{gather}
$$

回想信号与系统中的帕塞瓦尔定理和自相关函数 $R_{xx}(t)$， **以功率信号为例** ，我们有：

$$
\begin{gather}
\left< x^2(t) \right>  
= \lim_{T \to \infty} \frac{1}{T} \int_{0}^{T} x^2(t) \mathrm{d}t
= \int_{-\infty}^{+\infty} S_x(f) \mathrm{d}f = R_x(0)
\\
R_{x_1x_2}(\tau) = x_1(t) \ast  x_2(-t) = \lim_{T \to \infty} \frac{1}{T} \int_{0}^{T} x_1(\tau) \cdot x_2(\tau - t) \mathrm{d}\tau
\\
x_1(t) = x_2(t) = x(t) \Longrightarrow \mathcal{F}\{R_x(t)\} = S_{x}(f) = |F_{x}(f)|^2
\end{gather}
$$

特别地，当 $x_1(t) = x_2(t) = V_0 \cos(\omega_0 t)$ 时，我们有：

$$
\begin{gather}
R(t) = \frac{V_0^2}{2}\cos(\omega_0 t) = R(0) \cos(\omega_0 t) = \int_{-\infty}^{+\infty} S(f) \cos (\omega_0 t)\mathrm{d}f
\end{gather}
$$

将上面的几个结论代入，$\phi_n(t)$ 是一个随机过程 (random process)，我们有：

$$
\begin{gather}
\left<\phi_n(t_2)^2\right> = \left<\phi_n(t_1)^2\right> = \left<\phi_n(t)^2\right> = R_{\phi_n}(0) = \int_{-\infty}^{+\infty} S_{\phi_n}(f) \mathrm{d}f
\\
\left<\phi_n(t_2)\cdot \phi_n(t_1)\right> = R_{\phi_n}(t_2 - t_1) = R_{\phi_n}(\tau) = \int_{-\infty}^{+\infty} S_{\phi_n}(f) \cos (\omega_0 \tau) \mathrm{d}f
\end{gather}
$$

又因为 $J_{ee,L,rms} = \sqrt{\left<J_{ee,L}^2[n]\right>}$，代入化简即得最终结果：

$$
\begin{align}
\Delta t_{rms}^2 (\tau)|_{\tau = L T_0}
& = J_{ee,L,rms}^2
\\ & = \frac{T_0^2}{\pi^2} \int_{0}^{+\infty} S_{\phi_n}(f) \sin^2 (\pi f \tau) \mathrm{d}f 
\\ & = \frac{1}{\omega_0^2} \int_{0}^{+\infty} S_{\phi_n}(f)\cdot 4\sin^2 (\pi f \tau) \mathrm{d}f
\end{align}
$$

$$
\begin{gather}
\mathrm{where\ \ } \tau  = (t_2 - t_1) = T_0,\ 2 T_0,\ 3 T_0,\ ...
\end{gather}
$$
### 4.2 Cadence recommendation

Cadence 中提供了函数 `PN()` 来计算一个时域信号的相位噪声谱，其输出结果为 $L(f_m)$ in dBc/Hz. 阅读 [{11} Community Forums RF Design Usage of PN() after transient noise simulation](https://community.cadence.com/cadence_technology_forums/f/rf-design/47278/usage-of-pn-after-transient-noise-simulation) 可以知道这个函数的详细计算原理。由于 [{11}](https://community.cadence.com/cadence_technology_forums/f/rf-design/47278/usage-of-pn-after-transient-noise-simulation) 文中的 "absolute jitter" 实际上就是指 "edge jitter"，可以将其翻译为：

$$
\begin{gather}
\phi_n[n] = 2 \pi f_c \times J_{e}[n] \Longrightarrow 
S_{\phi_n}(f) = |\mathcal{F}\{\phi_n(t)\}|^2
\end{gather}
$$

上面公式可以看出, Cadence 的 `PN()` 函数实际上是基于 zero-crossing method 来计算相位噪声谱 $S_{\phi_n}(f)$ 的。

Cadence 还给出了一种相噪曲线的计算方法是利用 `pllMMLib` 库中的元件 `freq_meter`，详见 [{12} Cadence > Blogs > Analog/Custom Design Calculating Large Signal Phase Noise Using Transient Noise Analysis](https://community.cadence.com/cadence_blogs_8/b/cic/posts/calculating-large-signal-phase-noise-using-transient-noise-analysis)，背后原理也是 zero-crossing method, 这里不多赘述。





### 4.3 cycle-jitter method


从时域波形 (crossing time) 还原出 $\phi_n(t)$ 的另一种方法是 [page.7 of {1} Keysight > Phase Noise and its Measurements (25 Oct 2024)](https://indico.ihep.ac.cn/event/22089/contributions/168539/attachments/83428/105838/02%20Phase%20Noise%20and%20its%20Measurement%20Solutions-20241025.pdf) 中提到的，原文是 $\phi = 2\pi \cdot TIE(t)\cdot f_c$，把它翻译成本文的符号体系：

$$
\begin{gather}
\phi_n[n] = 2 \pi f_c \times J_{TIE,1}[n] = 2\pi f_c \times J_{c}[n]
,\quad 
\mathrm{Note\ that:}\quad  J_{TIE,1}[n] = J_{ee,1}[n] = J_{c}[n]
\end{gather}
$$

用这种方法来反推 $\phi_n[n]$ 似乎在理论层面就有错误，具体有待考证。



### 4.4 allan variance method

Allan variance 是一种用于分析和表征频率源 (时钟、正弦振荡器等) 噪声特性的时域分析技术，由 David Allan 于 1990 年提出 [[7]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9366669)，主要用于评估时域信号的频率稳定度/噪声性能。

Allan variance 的特点：
- 能够区分不同类型的噪声：可以识别和量化白噪声 (white noise)、闪烁噪声 (flicker noise)、随机游走噪声 (random wander)等
- 对非平稳过程有效：适用于具有趋势或漂移的数据
- 收敛性好：对于某些类型的噪声, Allan 方差比标准方差收敛得更好

主要参考：
- [[7]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9366669) "IEEE Standard Specification Format Guide and Test Procedure for Single-Axis Interferometric Fiber Optic Gyros," in IEEE Std 952-1997, vol., no., pp.1-84, 30 Nov. 1997, [doi: 10.1109/IEEESTD.1997.9366669.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9366669)
- [{13} CSDN > Allan 方差计算方法实现](https://blog.csdn.net/Gou_Hailong/article/details/127288190)
- [{14} 知乎 > Allan 方差计算方法](https://zhuanlan.zhihu.com/p/550890736)

<div class='center'>

| [[7]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9366669) "IEEE Standard Specification Format Guide and Test Procedure for Single-Axis Interferometric Fiber Optic Gyros," in IEEE Std 952-1997, vol., no., pp.1-84, 30 Nov. 1997, [doi: 10.1109/IEEESTD.1997.9366669.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9366669) |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-19-45-16_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.62-63 |

</div>

但是近年来, Allan variance method 在相位噪声/抖动分析中并不多见，主要是因为：
- 直接、直观的频域测量技术 (例如相位噪声分析仪) 已成为主流和标准
- SSB phase noise spectral density $\mathscr{L}(s)$ 提供了更丰富、与系统性能直接相关的信息
- 行业标准和数据手册都基于频域指标，工程师们也更倾向于使用频域方法进行设计和分析



## 5. MATLAB Implementation

### 5.1 built-in functions

MATLAB 提供了多种与相位噪声相关的函数，可以辅助我们实现相位噪声的计算与其它操作，下面列出几个作为例子：
- `phaseNoiseMeasure()`: measure and plot phase noise profile of time or frequency-domain signal
    - source link: https://ww2.mathworks.cn/help/msblks/ref/phasenoisemeasure.html
- `comm.PhaseNoise()`: Apply phase noise to baseband signal
    - source link: https://ww2.mathworks.cn/help/comm/ref/comm.phasenoise-system-object.html
- `plotPhaseNoiseFilter()`: Plot response of phase noise filter block
    - source link: https://ww2.mathworks.cn/help/comm/ref/plotphasenoisefilter.html
- `PhaseNoiseConfiguration()`: Measure and display phase noise (since R2025a)
    - source link: https://ww2.mathworks.cn/help/dsp/ref/phasenoiseconfiguration.html

这些函数或多或少能帮助我们实现相位噪声的计算与分析，但它们背后的理论原理和具体实现细节不尽相同，感兴趣的读者可以参考官方文档了解更多信息。




### 5.2 custom functions

进行相位噪声和抖动数据处理时，非常忌讳使用 "黑箱" (black-box) 来完成计算任务，因为黑箱的内部实现细节往往不透明，导致结果难以验证和解释，容易对结果的正确性和适用范围产生怀疑。因此，本小节就基于 zero-crossing method, 给出一套完整的 phase noise and jitter analysis 代码 (MATLAB)，供读者参考和使用。

具体的实现细节见前置文章 [Phase Noise and Jitter Calculation using MATLAB](<AnalogIC/Phase Noise and Jitter Calculation using MATLAB.md>)，这里直接给出具体代码：



``` matlab
% Phase Noise and Jitter Analysis Function using Zero-Crossing Method
% Version: v1_20251106
% Uploaded by YiDingg (https://www.zhihu.com/people/YiDingg) on 2025-11-12
% Additional custom functions are used, refer to https://github.com/YiDingg/Matlab for these functions.

function STC = MyAnalysis_PhaseNoise_v1_20251106(data_edgeTimeSequence, flag_drawFigure)

figureSize = [4*2, 1.8*2]*512*1;
    tiledlayout(2, 2);
    plotSequence = [1 3 2 4];
    % 2x2 布局顺序是这样的：
    %  1 2
    %  3 4
annotation_fontsize = 11;

%%


%% (完整代码) Calculation of jitter and phase noise spectrum using time-domain edge time sequence (crossing time sequence)


% 1. 导入频率序列并计算周期序列
    % data = readmatrix("D:\aa_MyExperimentData\Raw data backup\202510_PLL_RVCO1_v1_calibre_tran_3x1600_frequencySequence.csv"); 
    edgeTime = data_edgeTimeSequence;
    % nfft=2^16;
    % 对数据进行处理，去除 nan 异常数据
    flag_nan = any(isnan(edgeTime), 2);
    edgeTime = edgeTime(~flag_nan, :);
    % 提取数据
    periods = diff(edgeTime);
    freq = 1./periods;
    N = length(periods);

    % 保存数据
    time = edgeTime(2:end) - edgeTime(1);
    STC.dataProcessing.time = time;
    STC.dataProcessing.freqs = freq;
    STC.dataProcessing.periods = periods;



%% 2. 通过周期序列计算 T_0 (nominal period), Jc (cycle jitter) 和 Jcc (cycle-to-cycle jitter)
    % 利用 fitness of edge time 来计算 T_0 而不是使用 average period, 这样可以去除 period 可能存在的 "漂移趋势"
    [para, ~, ~, ~] = MyFit_linear(1:length(edgeTime), edgeTime', 0);
    T_0 = para.k;
    % T_0 = mean(periods);     % use the function "nanmean" to ignore NaN data?
    f_0 = 1/T_0;
    %f_0 = 1/T_0;
    omega_0 = 2*pi*f_0;
    delta_T_relative_max = max(abs(periods-T_0)/T_0)*100; % unit: %
    delta_f_relative_max = max(abs(freq-f_0)/f_0)*100; % unit: %
    
    % 从统计角度计算一系列 jitter 值
    Jc = periods - T_0;
    Jcc = Jc(2:end) - Jc(1:(end - 1));
    edgeTime = cumsum(periods); 
    % edgeTime = edgeTime - edgeTime(1);  % 使 n = 1 对应 edgeTime = 0
    Je = edgeTime - T_0*(1:1:length(edgeTime))';
    Jee = Je(2:end) - Je(1:(end - 1));
    
    L = 2; Jee2 = Je((1+L):end) - Je(1:(end-L));
    L = 4; Jee4 = Je((1+L):end) - Je(1:(end-L));
    L = 8; Jee8 = Je((1+L):end) - Je(1:(end-L));
    L = 32; Jee32 = Je((1+L):end) - Je(1:(end-L));
    L = 128; Jee128 = Je((1+L):end) - Je(1:(end-L));
    
    Jc_rms = std(Jc);
    Jcc_rms = std(Jcc);
    Je_rms = std(Je);
    Jee_rms = std(Jee);
    Jee2_rms = std(Jee2);
    Jee4_rms = std(Jee4);
    Jee8_rms = std(Jee8);
    Jee32_rms = std(Jee32);
    Jee128_rms = std(Jee128);
    
    disp(['number of periods = ', num2str(N)])
    disp(['T_0 = ', num2str(T_0*10^9, '%.4f'), ' ns, f_0 = ', num2str(f_0/10^9, '%.4f'), ' GHz'])
    disp(['max abs relative delta T = ', num2str(delta_T_relative_max, '%.4f'), ' %'])
    disp(['max abs relative delta f = ', num2str(delta_f_relative_max, '%.4f'), ' %'])
    disp(['Jc_rms = ', num2str(Jc_rms*10^12, '%.4f'), ' ps'])
    disp(['Jcc_rms = ', num2str(Jcc_rms*10^12, '%.4f'), ' ps'])
    disp(['Jc_rms*sqrt(2) = ', num2str(Jc_rms*sqrt(2)*10^12), ' ps'])

    if flag_drawFigure
        % 作出 periods 图像：
        ax = nexttile(plotSequence(1));
        stc = MyScatter_ax(ax, time'*10^6, periods'*10^9);
        % 进行核密度估计并作出密度分布
        [density, density_xaxis] = ksdensity(periods);
        density = density/max(density) * stc.axes.XLim(2)/4;
        stc = MyPlot_ax(stc.axes, density, density_xaxis*10^9);
        stc.plot.plot_1.Color = 'm';
        % ylim([0.95, 1.05])
        % xlim([0 100])
        stc.axes.Title.String = 'Period Sequence of the Transient Simulation Results';
        stc.leg.Visible = 'off';
        % MyFigure_ChangeSize([3, 1]*512*1.3)
        stc = MyPlot_ax(ax, time'*10^6, zeros(size(time')) + T_0*10^9);
        stc.leg.String = [
            "Period Sequence $T(t)$"
            "Scaled Distribution Sensity"
            "Nominal Period $T_0$"
        ];
        stc.leg.Location = 'northeast';
        stc.plot.plot_1.Color = 'b';
        stc.label.x.String = 'Time $t$ (us)';
        stc.label.y.String = 'Period $T(t)$ (ns)';
        
        % 在计算好的位置添加文本
        XLIM = stc.axes.XLim;   % 获取横坐标范围
        YLIM = stc.axes.YLim;   % 获取纵坐标范围
        text(XLIM(1) + 0.45*(XLIM(2) - XLIM(1)), YLIM(1) + 0.05*(YLIM(2) - YLIM(1)), [ ...
            "Number of periods = " + num2str(N)
            "Nominal period $T_0$ = " + num2str(T_0*10^9, '%.4f') + " ns"
            "Nominal frequency $f_0$ = " + num2str(f_0/10^6, '%.4f') + " MHz"
            "(PEJ) RMS cycle jitter $J_{c, rms}$ = " + num2str(Jc_rms*10^12, '%.2f')      + " ps" +   " = " + num2str(Jc_rms/T_0*1000, '%.2f') + " mUI"
            "(C2C) RMS C2C jitter $J_{cc, rms}$ = " + num2str(Jcc_rms*10^12, '%.2f') + " ps" +   " = " + num2str(Jcc_rms/T_0*1000, '%.2f') + " mUI"
            %"(TE) RMS phase jitter $J_{e, rms}$ = " + num2str(Je_rms*10^12, '%.2f')          + " ps" +   " = " + num2str(Je_rms/T_0*1000, '%.2f') + " mUI"
            %"RMS phase jitter $J_{ee, rms}$ = " + num2str(Je_rms*10^12, '%.2f')         + " ps" +   " = " + num2str(Jee_rms/T_0*1000, '%.2f') + " mUI"
            ], ...
            'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
            'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
            'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
            'EdgeColor', 'k', ...               % 设置黑色边框（可选）
            'Margin', 2, ...                    % 设置文本与边框的边距（可选）
            'FontSize', annotation_fontsize, ...
            'Interpreter', 'latex' ...
            );                    % 设置字体大小
    else 
        stc = 0;
    end
    

    % 保存数据
    STC.stc1 = stc; % 保存图像
    STC.dataProcessing.T_0 = T_0;
    STC.dataProcessing.f_0 = f_0;
    STC.dataProcessing.omega_0 = omega_0;
    STC.dataProcessing.Jc = Jc;
    STC.dataProcessing.Jcc = Jcc;
    STC.dataProcessing.edgeTime = edgeTime;
    STC.dataProcessing.Je = Je;
    STC.dataProcessing.Jee = Jee;
    STC.dataProcessing.Jc_rms = Jc_rms;
    STC.dataProcessing.Jcc_rms = Jcc_rms;
    STC.dataProcessing.Je_rms = Je_rms;
    STC.dataProcessing.Jee_rms = Jee_rms;
    STC.dataProcessing.Jee2_rms     = Jee2_rms  ;
    STC.dataProcessing.Jee4_rms     = Jee4_rms  ;
    STC.dataProcessing.Jee8_rms     = Jee8_rms  ;
    STC.dataProcessing.Jee32_rms    = Jee32_rms ;
    STC.dataProcessing.Jee128_rms   = Jee128_rms;



%% 3. 积分后分离出 phi_n (phase noise), 图形和 edge time (crossing time) fluctuation 也即 Je[n] 一致
    phases = 2*pi*cumsum(periods/T_0); % 积分得到 phase noise (unit: rad) 
    periods_ideal = zeros(N, 1) + T_0;
    phi_n = phases - 2*pi*cumsum(periods_ideal/T_0); % unit: rad
    % 去除 phi_n 中可能存在的 "漂移现象"，再进行后续计算，以获得更精确的 jitter and phase noise 结果
    [para, stc, freq_fit, gof] = MyFit_linear(time', phi_n', 0);
    phi_n = phi_n - (para.k)*time;  % 去除可能存在的 "漂移现象"
    phi_n = phi_n - mean(phi_n); % 去除 dc offset

    
    % 计算 phi_n 的功率
    fs = f_0;
    [bw, ~, ~, power_phi_n] = obw(phi_n, fs);
    % ave_power = power_phi_n;
    RMS_Sphin_rad = sqrt(power_phi_n);
    RMS_phaseJitter = RMS_Sphin_rad/omega_0;
    disp(['RMS_phi = ', num2str(RMS_Sphin_rad), ' rad = ', num2str(rad2deg(RMS_Sphin_rad), '%.2f') , '°'])
    disp(['RMS_phaseJitter = ', num2str(RMS_phaseJitter*10^12), ' ps'])

    if flag_drawFigure
        ax = nexttile(plotSequence(2));
        stc = MyScatter_ax(ax, time'*10^6, phi_n');
        % 核密度估计与作图
        [density, density_xaxis] = ksdensity(phi_n);
        density = density/max(density) * stc.axes.XLim(2)/4;
        stc = MyPlot_ax(stc.axes, density, density_xaxis);
        stc.plot.plot_1.Color = 'm';
        stc.axes.Title.String = 'Recovered Phase Noise Curve';
        stc.label.x.String = 'Time $t$ (us)';
        stc.label.y.String = 'Phase Noise $\phi_n(t)$ (rad)';
        stc.leg.String = [
            "Recovered Phase Noise Curve $\phi_n(t)$"
            "Scaled Distribution Sensity"
        ];
        stc.leg.Location = 'northeast';
        
        % 在计算好的位置添加文本
        XLIM = stc.axes.XLim;   % 获取横坐标范围
        YLIM = stc.axes.YLim;   % 获取纵坐标范围
        text(XLIM(1) + 0.45*(XLIM(2) - XLIM(1)), YLIM(1) + 0.05*(YLIM(2) - YLIM(1)), [ ...
            %"Average phase nosie power $\overline{\phi_n(t)^2}$ = " + num2str(power_phi_n, '%.6f') + " rad$^2$"
            %"RMS phase noise $\phi_{n, rms}$ = " + num2str(RMS_Sphin_rad, '%.4f') + " rad = " + num2str(rad2deg(RMS_Sphin_rad), '%.2f') + "$^\circ$"
            %"RMS phase jitter $J{\phi_n, rms}$ = " + num2str(RMS_phaseJitter*10^12, '%.2f')          + " ps" +   " = " + num2str(RMS_phaseJitter/T_0*1000, '%.2f') + " mUI"
            "(TE) RMS edge jitter $J_{e, rms}$ = " + num2str(Je_rms*10^12, '%.2f')          + " ps" +   " = " + num2str(Je_rms/T_0*1000, '%.2f') + " mUI"
            "(2-TIE) RMS 2-TIE jitter = " + num2str(Jee2_rms*10^12, '%.2f')          + " ps" +   " = " + num2str(Jee2_rms/T_0*1000, '%.2f') + " mUI"
            "(4-TIE) RMS 4-TIE jitter = " + num2str(Jee4_rms*10^12, '%.2f')          + " ps" +   " = " + num2str(Jee4_rms/T_0*1000, '%.2f') + " mUI"
            "(8-TIE) RMS 8-TIE jitter = " + num2str(Jee8_rms *10^12, '%.2f')          + " ps" +   " = " + num2str(Jee8_rms/T_0*1000, '%.2f') + " mUI"
            "(32-TIE) RMS 32-TIE jitter = " + num2str(Jee32_rms*10^12, '%.2f')          + " ps" +   " = " + num2str(Jee32_rms/T_0*1000, '%.2f') + " mUI"
            "(128-TIE) RMS 128-TIE jitter = " + num2str(Jee128_rms*10^12, '%.2f')          + " ps" +   " = " + num2str(Jee128_rms/T_0*1000, '%.2f') + " mUI"
    
            ], ...
            'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
            'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
            'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
            'EdgeColor', 'k', ...               % 设置黑色边框（可选）
            'Margin', 2, ...                    % 设置文本与边框的边距（可选）
            'FontSize', annotation_fontsize, ...
            'Interpreter', 'latex' ...
        );                  
    end
   

    % 保存数据
    STC.stc2 = stc; % 保存图像
    STC.dataProcessing.phases = phases;
    STC.dataProcessing.periods_ideal = periods_ideal;
    STC.dataProcessing.phi_n_vsTime = phi_n;
    STC.dataProcessing.fs = fs;
    STC.dataProcessing.power_phi_n = power_phi_n;
    STC.dataProcessing.RMS_Sphin_rad = RMS_Sphin_rad;
    STC.dataProcessing.RMS_phaseJitter = RMS_phaseJitter;
   

%% 4. (实际采用) 用函数 periodogram 计算 phase noise spectrum，进而得到 L(f_m)
    
    XLIM = [10^3 10^9];
    YLIM = [-200 -50];

    % powerbw 默认使用 periodogram 方法
    fs = f_0;
    [S_phi_n, f] = periodogram(phi_n, [], [], fs);
    
    % (2:end) 是为了避免 dc value 影响
    f = f(2:end);
    S_phi_n = S_phi_n(2:end);

    % 横坐标 (频率): f   (Hz)
    % 纵坐标 (相位噪声功率谱密度): S_phi_n  (rad^2)  (Power Spectral Density of \phi_n)
    L_fm = S_phi_n'/2;     % L(f_m)
    L_fm_dBc = 10*log10(L_fm);
    tv = length(L_fm_dBc);
    L_fm_dBc_filted = zeros(size(L_fm_dBc));
    L_fm_dBc_filted = MyFilter_mean_mean(L_fm_dBc);
    L_fm_filted = 10.^(L_fm_dBc_filted/10);

    fit_method = 3; 
    if fit_method == 1
        [L_fm_dBc_filted_fit, ~] = fit(f, L_fm_dBc_filted', 'splineinterp'); % 对 L_fm_dBc_filted 进行差值拟合以得到特定频率处的值
    elseif fit_method == 2  % 用两个幂函数之和 -a*x^b-c*x^d 进行拟合
        [xData, yData] = prepareCurveData(f, L_fm_dBc_filted');
        % 设置 fittype 和选项。
        ft = fittype( '-a*x^b-c*x^d', 'independent', 'x', 'dependent', 'y' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display = 'Off';
        opts.StartPoint = [0.96 0.0046 0.77 0.82];
        opts.Lower = [0 0 -50 0];
        opts.Upper = [100 10 50 10];
        % 对数据进行模型拟合。
        [L_fm_dBc_filted_fit, ~] = fit( xData, yData, ft, opts);
    elseif fit_method == 3  % 用平滑度极高的 "平滑拟合" 方法
        [xData, yData] = prepareCurveData(f, L_fm_dBc_filted');
        % 设置 fittype 和选项。
        ft = fittype( 'smoothingspline' );
        opts = fitoptions( 'Method', 'SmoothingSpline' );
        opts.SmoothingParam = 0.5e-10;
        % 对数据进行模型拟合。
        [L_fm_dBc_filted_fit, ~] = fit( xData, yData, ft, opts );
    end

    if flag_drawFigure
        ax = nexttile(plotSequence(3));
        stc = MyPlot_ax(ax, f', [L_fm_dBc; L_fm_dBc_filted_fit(f)']);
        stc.axes.XScale = 'log';
        %stc.axes.XLim = XLIM;
        %stc.axes.YLim = YLIM;
        YLIM = stc.axes.YLim;
        XLIM = stc.axes.XLim;
        stc.axes.YLim(2) = YLIM(2) + 0.1*(YLIM(2) - YLIM(1));
        stc.axes.XLim = XLIM;
        MyFigure_ChangeSize([3, 1]*512*1.3)
        stc.axes.Title.String = '(SSB) Phase Noise Spectrum Normalized to Carrier Power Ratio (dBc/Hz)';
        %stc.axes.Title.Interpreter = 'LaTex';
        %stc.axes.Title.FontWeight = 'bold';
        %stc.axes.Subtitle.FontSize = 10;
        %stc.axes.Subtitle.String = ['RMS_phaseJitter = ', num2str(RMS_phaseJitter*10^12), ' ps'];
        stc.label.x.String = 'Offset Frequency $f_m$ (Hz)';
        stc.label.y.String = 'Phase Noise Spectrum $L(f_m)$ (dBc/Hz)';
        %xline(bw)
        %stc.leg.String = ["Raw data"; "Filted data"; "99\% noise = " + num2str(bw/10^6, '%.1f') + " MHz"];
        stc.leg.String = [
            "Raw Data"
            "Fitted Curve"
            ];
        stc.leg.Location = 'northeast';
        %stc.plot.plot_1.LineStyle = '--';
        stc.plot.plot_2.LineStyle = '-';
    
        % 在计算好的位置添加文本
        XLIM = stc.axes.XLim;   % 获取横坐标范围
        YLIM = stc.axes.YLim;   % 获取纵坐标范围
        if 1     % 1kHz ~ 500 kHz
            text(1.2*XLIM(1), YLIM(1) + 0.05*(YLIM(2) - YLIM(1)), [ ...
                "Average phase nosie power $\overline{\phi_n(t)^2}$ = " + num2str(power_phi_n, '%.6f') + " rad$^2$"
                "RMS phase noise $\phi_{n, rms}$ = " + num2str(RMS_Sphin_rad, '%.4f') + " rad = " + num2str(rad2deg(RMS_Sphin_rad), '%.2f') + "$^\circ$"
                "RMS phase jitter $J_{\phi_n, rms}$ = " + num2str(RMS_phaseJitter*10^12, '%.2f')          + " ps" +   " = " + num2str(RMS_phaseJitter/T_0*1000, '%.2f') + " mUI"
                "Phase Noise @ 1 kHz = " + num2str(L_fm_dBc_filted_fit(1e3), '%.2f')    + " dBc/Hz"
                "Phase Noise @ 5 kHz  = " + num2str(L_fm_dBc_filted_fit(5e3), '%.2f')    + " dBc/Hz"
                "Phase Noise @ 10 kHz  = " + num2str(L_fm_dBc_filted_fit(10e3), '%.2f')    + " dBc/Hz"
                "Phase Noise @ 50 kHz = " + num2str(L_fm_dBc_filted_fit(50e3), '%.2f')    + " dBc/Hz"
                "Phase Noise @ 100 kHz = " + num2str(L_fm_dBc_filted_fit(100e3), '%.2f')    + " dBc/Hz"
                "Phase Noise @ 500 kHz = " + num2str(L_fm_dBc_filted_fit(500e3), '%.2f')    + " dBc/Hz"
                %"Phase Noise @ 1MHz = " + num2str(L_fm_dBc_filted_fit(1e6), '%.2f')    + " dBc/Hz"
                %"Phase Noise @ 10MHz = " + num2str(L_fm_dBc_filted_fit(10e6), '%.2f')    + " dBc/Hz"
                ], ...
                'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
                'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
                'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
                'EdgeColor', 'k', ...               % 设置黑色边框（可选）
                'Margin', 2, ...                    % 设置文本与边框的边距（可选）
                'FontSize', annotation_fontsize, ...
                'Interpreter', 'latex' ...
            );                    % 设置字体大小
        else    % 10 kHz ~ 500 MHz
            text(1.2*XLIM(1), YLIM(1) + 0.05*(YLIM(2) - YLIM(1)), [ ...
                %"Average phase noise $\overline{\phi_n(t)^2}$ = " + num2str(power_phi_n, '%.4f')    + " rad$^2$"
                "Phase Noise @ 10 kHz = " + num2str(L_fm_dBc_filted_fit(10e3), '%.2f')    + " dBc/Hz"
                "Phase Noise @ 100 kHz  = " + num2str(L_fm_dBc_filted_fit(100e3), '%.2f')    + " dBc/Hz"
                "Phase Noise @ 1 MHz  = " + num2str(L_fm_dBc_filted_fit(1e6), '%.2f')    + " dBc/Hz"
                "Phase Noise @ 10 MHz = " + num2str(L_fm_dBc_filted_fit(10e6), '%.2f')    + " dBc/Hz"
                "Phase Noise @ 100 MHz = " + num2str(L_fm_dBc_filted_fit(100e6), '%.2f')    + " dBc/Hz"
                "Phase Noise @ 500 MHz = " + num2str(L_fm_dBc_filted_fit(500e6), '%.2f')    + " dBc/Hz"
                %"Phase Noise @ 1MHz = " + num2str(L_fm_dBc_filted_fit(1e6), '%.2f')    + " dBc/Hz"
                %"Phase Noise @ 10MHz = " + num2str(L_fm_dBc_filted_fit(10e6), '%.2f')    + " dBc/Hz"
                ], ...
                'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
                'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
                'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
                'EdgeColor', 'k', ...               % 设置黑色边框（可选）
                'Margin', 2, ...                    % 设置文本与边框的边距（可选）
                'FontSize', annotation_fontsize, ...
                'Interpreter', 'latex' ...
            );                    % 设置字体大小
        end
    end

    % 保存数据
    STC.stc3 = stc;
    STC.dataProcessing.f_axis = f;
    STC.dataProcessing.S_phi_n = S_phi_n;
    STC.dataProcessing.L_fm = L_fm;
    STC.dataProcessing.L_fm_filted = L_fm_filted;
    STC.dataProcessing.L_fm_dBc = L_fm_dBc;
    STC.dataProcessing.L_fm_dBc_filted = L_fm_dBc_filted;
    STC.dataProcessing.L_fm_dBc_filted_fit = L_fm_dBc_filted_fit;
    

%% 5. 计算 Weighted/unweighted integral jitter as a function of integration lower bound f_L (f_H = f_0/2)
    
    f_axis = f;
    re = cumtrapz(f_axis(end:-1:1), S_phi_n(end:-1:1));
    RMS_Jintegral = sqrt(abs(re))/(2*pi*f_0);
    RMS_Jintegral_mUI = RMS_Jintegral*f_0*1000;
    [RMS_Jintegral_mUI_fit, ~] = fit(f_axis(end:-1:1), RMS_Jintegral_mUI, 'splineinterp'); % 插值拟合以得到给定频率处的值
    
    tau = 1/f_0;
    S_phi_n_weighted = S_phi_n .* 4.*sin(pi.*f_axis.*tau);
    re = cumtrapz(f_axis(end:-1:1), S_phi_n_weighted(end:-1:1));
    RMS_Jintegral_weighted = sqrt(abs(re))/(2*pi*f_0);
    RMS_Jintegral_weighted_mUI = RMS_Jintegral_weighted*f_0*1000;
    [RMS_Jintegral_weighted_mUI_fit, ~] = fit(f_axis(end:-1:1), RMS_Jintegral_weighted_mUI, 'splineinterp'); % 插值拟合以得到给定频率处的值
    
    tau = 2/f_0;
    S_phi_n_weighted2 = S_phi_n .* 4.*sin(pi.*f_axis.*tau);
    re = cumtrapz(f_axis(end:-1:1), S_phi_n_weighted2(end:-1:1));
    RMS_Jintegral_weighted2 = sqrt(abs(re))/(2*pi*f_0);
    RMS_Jintegral_weighted2_mUI = RMS_Jintegral_weighted2*f_0*1000;
    [RMS_Jintegral_weighted2_mUI_fit, ~] = fit(f_axis(end:-1:1), RMS_Jintegral_weighted2_mUI, 'splineinterp'); % 插值拟合以得到给定频率处的值

    tau = 4/f_0;
    S_phi_n_weighted4 = S_phi_n .* 4.*sin(pi.*f_axis.*tau);
    re = cumtrapz(f_axis(end:-1:1), S_phi_n_weighted4(end:-1:1));
    RMS_Jintegral_weighted4 = sqrt(abs(re))/(2*pi*f_0);
    RMS_Jintegral_weighted4_mUI = RMS_Jintegral_weighted4*f_0*1000;
    [RMS_Jintegral_weighted4_mUI_fit, ~] = fit(f_axis(end:-1:1), RMS_Jintegral_weighted4_mUI, 'splineinterp'); % 插值拟合以得到给定频率处的值
    
    if flag_drawFigure
        ax = nexttile(plotSequence(4));
        stc = MyPlot_ax(ax, f_axis(end:-1:1)', [RMS_Jintegral_weighted_mUI'; RMS_Jintegral_weighted2_mUI'; RMS_Jintegral_weighted4_mUI'; RMS_Jintegral_mUI']);
        stc.axes.XDir = 'reverse';
        stc.axes.XScale = 'log';
        stc.axes.Title.String = 'RMS Integral Jitter as a Function of Integration Lower Bound';
        stc.label.x.String = 'Integration Lower Bound (Hz)';
        stc.label.y.String = 'RMS Integral Jitter (mUI)';
        stc.leg.String = [
            "RMS Weighted Integral Jitter $(\tau = T_0)$"
            "RMS Weighted Integral Jitter $(\tau = 2T_0)$"
            "RMS Weighted Integral Jitter $(\tau = 4T_0)$"
            "RMS Unweighted Integral Jitter $(f_H = f_0/2)$"
        ];
    
        % 在计算好的位置添加文本
        XLIM = stc.axes.XLim;   % 获取横坐标范围
        YLIM = stc.axes.YLim;   % 获取纵坐标范围
        text(XLIM(2)/1.2, YLIM(1) + 0.2*(YLIM(2) - YLIM(1)), [ ...
            "(TE) RMS unweighted integral jitter @ $f_L = 10$ kHz = " + num2str(RMS_Jintegral_mUI_fit(10e3), '%.2f')  + " mUI"
            "(1-TIE) RMS 1-weighted integral jitter @ $f_L = 10$ kHz = " + num2str(RMS_Jintegral_weighted_mUI_fit(10e3), '%.2f')  + " mUI"
            "(2-TIE) RMS 2-weighted integral jitter @ $f_L = 10$ kHz = " + num2str(RMS_Jintegral_weighted2_mUI_fit(10e3), '%.2f')  + " mUI"
            "(4-TIE) RMS 4-weighted integral jitter @ $f_L = 10$ kHz = " + num2str(RMS_Jintegral_weighted4_mUI_fit(10e3), '%.2f')  + " mUI"
            %"(TE) RMS unweighted integral jitter @ $f_L = 1$ kHz = " + num2str(RMS_Jintegral_mUI_fit(1e3), '%.2f')  + " mUI"
            %"(1-TIE) RMS 1-weighted integral jitter @ $f_L = 1$ kHz = " + num2str(RMS_Jintegral_weighted_mUI_fit(1e3), '%.2f')  + " mUI"
            %"(2-TIE) RMS 2-weighted integral jitter @ $f_L = 1$ kHz = " + num2str(RMS_Jintegral_weighted2_mUI_fit(1e3), '%.2f')  + " mUI"
            %"(4-TIE) RMS 4-weighted integral jitter @ $f_L = 1$ kHz = " + num2str(RMS_Jintegral_weighted4_mUI_fit(1e3), '%.2f')  + " mUI"
            ], ...
            'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
            'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
            'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
            'EdgeColor', 'k', ...               % 设置黑色边框（可选）
            'Margin', 2, ...                    % 设置文本与边框的边距（可选）
            'FontSize', annotation_fontsize, ...
            'Interpreter', 'latex' ...
            );                    % 设置字体大小
    end


    % 保存结果
    STC.stc4 = stc;
    STC.dataProcessing.RMS_Jintegral = RMS_Jintegral;
    STC.dataProcessing.RMS_Jintegral_mUI = RMS_Jintegral_mUI;
    STC.dataProcessing.RMS_Jintegral_mUI_fit = RMS_Jintegral_mUI_fit;
    STC.dataProcessing.S_phi_n_weighted = S_phi_n_weighted;
    STC.dataProcessing.RMS_Jintegral_weighted = S_phi_n_weighted;
    STC.dataProcessing.RMS_Jintegral_weighted_mUI = RMS_Jintegral_weighted_mUI;
    STC.dataProcessing.RMS_Jintegral_weighted_mUI_fit = RMS_Jintegral_weighted_mUI_fit;
    STC.dataProcessing.S_phi_n_weighted2 = S_phi_n_weighted2;
    STC.dataProcessing.RMS_Jintegral_weighted2 = S_phi_n_weighted2;
    STC.dataProcessing.RMS_Jintegral_weighted2_mUI = RMS_Jintegral_weighted2_mUI;
    STC.dataProcessing.RMS_Jintegral_weighted2_mUI_fit = RMS_Jintegral_weighted2_mUI_fit;
    STC.dataProcessing.S_phi_n_weighted4 = S_phi_n_weighted4;
    STC.dataProcessing.RMS_Jintegral_weighted4 = S_phi_n_weighted4;
    STC.dataProcessing.RMS_Jintegral_weighted4_mUI = RMS_Jintegral_weighted4_mUI;
    STC.dataProcessing.RMS_Jintegral_weighted4_mUI_fit = RMS_Jintegral_weighted4_mUI_fit;

    % 输出关键结果
    disp("(TE)  Je_rms = " + num2str(Je_rms*10^12, '%.4f') + " ps = " + num2str(Je_rms/T_0*1000, '%.2f') + " mUI")
    disp("(PEJ) Jc_rms = " + num2str(Jc_rms*10^12, '%.4f') + " ps = " + num2str(Jc_rms/T_0*1000, '%.3f') + " mUI")
    disp("(C2C) Jcc_rms = " + num2str(Jcc_rms*10^12, '%.4f') + " ps = " + num2str(Jcc_rms/T_0*1000, '%.3f') + " mUI")
    disp("(2-TIE) Jc_rms = " + num2str(Jee2_rms*10^12, '%.4f') + " ps = " + num2str(Jee2_rms/T_0*1000, '%.3f') + " mUI")
    disp("Phase Noise @ 1 kHz   = " + num2str(L_fm_dBc_filted_fit(1e3), '%.2f')    + " dBc/Hz")
    disp("Phase Noise @ 5 kHz   = " + num2str(L_fm_dBc_filted_fit(5e3), '%.2f')    + " dBc/Hz")
    disp("Phase Noise @ 10 kHz  = " + num2str(L_fm_dBc_filted_fit(10e3), '%.2f')    + " dBc/Hz")
    %disp("Phase Noise @ 50 kHz  = " + num2str(L_fm_dBc_filted_fit(50e3), '%.2f')    + " dBc/Hz")
    disp("Phase Noise @ 100 kHz = " + num2str(L_fm_dBc_filted_fit(100e3), '%.2f')    + " dBc/Hz")

MyFigure_ChangeSize(figureSize)
end
```

上述代码的运行示例及效果如下：

``` matlab
% Phase Noise and Jitter Analysis Example using the custom function MyAnalysis_PhaseNoise_v1_20251106.m
% Uploaded by YiDingg (https://www.zhihu.com/people/YiDingg) on 2025-11-12

clc, clear, close all
fileName = "202510_PLL_loopVeri_allModules_SpectreXCX_20251111_tran15ms_RVCO1and2_optimizeLPFalpha_TT27_2x5points.csv";
rawdata = readmatrix("D:\aa_MyExperimentData\Raw data backup\" + fileName);

N = length(rawdata(1, :))/2;
Je_rms_array = zeros([N, 1]);
Jc_rms_array = zeros([N, 1]);


datanum = 8;   
data = rawdata(:, [datanum*2 - 1, datanum*2]);

% 第一列是 cycle num, 第二列才是 edge time
num = length(data(:, 1));
data = data(ceil(num/6):end, :);
edgeTime = data(:, 2);
flag_drawFigure = 1;
STC = MyAnalysis_PhaseNoise_v1_20251106(edgeTime, flag_drawFigure);
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-12-01-56-22_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div>


## 6. Further Reading

### 6.1 phase noise 

<div class='center'>

| [{1} Keysight > Phase Noise and its Measurements (25 Oct 2024)](https://indico.ihep.ac.cn/event/22089/contributions/168539/attachments/83428/105838/02%20Phase%20Noise%20and%20its%20Measurement%20Solutions-20241025.pdf) |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-16-46-59_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.3 |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-16-46-39_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.4 |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-16-46-03_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.5 |
 |  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-17-12-58_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.7 |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-17-04-13_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.9 |
</div>

<div class='center'>

| [{10} Silicon Labs > AN279 - Estimating Period Jitter From Phase Noise](https://www.skyworksinc.com/-/media/Skyworks/SL/documents/public/application-notes/AN279.pdf) |
|:-:|
 | <span style='color:red'> $L(f_m) \ \mathrm{Hz^{-1}} = \frac{1}{2} S_{\phi_n}(f)_{f = f_m} $ </span> |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-03-23-40_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.1 |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-03-34-45_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.3 |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-17-34-39_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.5-6 |
</div>

<div class='center'>

| [{2} Keysight > Methods and Instruments for Phase Noise Measurement](https://www.keysight.com/us/en/assets/3124-1845/application-notes/Methods-and-Instruments-for-Phase-Noise-Measurement.pdf) |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-02-38-07_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.5 |
 | 实际仪器常用的相位噪声测量方法： <br> (1) direct spectrum analyzer measurement <br> (2) phase detection method <br> (3) frequency detection method <br> (4) cross-correlation method <br> page.5 |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-02-42-33_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.12 |
</div>

<div class='center'>

| [{9} Silicon Labs > Timing Jitter Tutorial & Measurement Guide](https://www.mouser.com/pdfdocs/timing-jitter-tutorial-and-measurement-guide-ebook.pdf) |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-03-13-46_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.20-21 |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-03-15-04_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.24-25 |
</div>




### 6.2 jitter

<div class='center'>

| [{7} TI Application Report > How to Measure Total Jitter (TJ)](https://www.ti.com/lit/an/scaa120b/scaa120b.pdf?ts=1762191109494) |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-02-23-42_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.2  |
</div>

<div class='center'>

| [{8} TI Application Report > Time-Domain Jitter Measurement Considerations for Low Noise Oscillators](https://www.ti.com/lit/an/snaa285/snaa285.pdf?ts=1762191104280) | 
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-03-04-21_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.2  |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-03-09-45_Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.png"/></div> page.6  |
</div>


### 6.3 spur

<div class='center'>

| [{3} Keysight > AN10062 Phase Noise Measurement Guide for Oscillators](https://www.sitime.com/support/resource-library/application-notes/an10062-phase-noise-measurement-guide-oscillators) |
|:-:|
 | $P^{\mathrm{dBc}}_{spur} = 10 \log_{10} \left(\frac{P^{\mathrm{W}}_{spur}}{P^{\mathrm{W}}_{c}}\right) = P^{\mathrm{dBm}}_{spur} - P^{\mathrm{dBm}}_{c}$ |
 | $J_{spur,rms}^{\mathrm{second}} = \frac{10^{\frac{P^{\mathrm{dBc}}_{spur}}{20}}}{\sqrt{2} \pi f_c} = \frac{\sqrt{P^{\mathrm{W}}_{spur}/P^{\mathrm{W}}_{c}}}{\sqrt{2} \pi f_c} $ |
</div>


## 7. Summary

本小节对本文的关键公式做总结/归纳，方便读者查阅。

先是一些基本定义：

$$
\begin{gather}
\mathrm{noisy\ voltage\ signal:\ \ } v(t) = V_{amp}(t) \cos (\phi(t)) =  [V_0 + V_\alpha(t)]\cos (\omega_c t + \phi_n(t) + \phi_0)
\\
\mathrm{where:\ \ }V(t) = V_0 + V_\alpha(t),\quad 
\phi(t) = \omega_c t + \phi_n(t) + \phi_0,\quad 
f_{n,nor}(t) := f_n(t)/f_c
\\
\begin{cases}
\mathrm{angular\ frequency\ noise:\ }& \omega_n(t) = \omega(t) - \omega_c = \frac{\mathrm{d} \phi(t)}{\mathrm{d}t} - \omega_c = \frac{\mathrm{d} \phi_n(t)}{\mathrm{d}t} \\
\mathrm{frequency\ noise:\ \ }& f_n(t) = f(t) - f_c = \frac{1}{2\pi}\left(\frac{\mathrm{d} \phi(t)}{\mathrm{d}t} - \omega_c\right) = \frac{1}{2\pi} \frac{\mathrm{d} \phi_n(t)}{\mathrm{d}t} \\
\mathrm{normalized\ frequency\ noise:\ }& f_{n,nor}(t) = \frac{f_n(t)}{f_c} = \frac{1}{2\pi f_c} \frac{\mathrm{d} \phi_n(t)}{\mathrm{d}t} \\
\mathrm{amplitude\ noise:\ \ } & \alpha(t) = V_{amp}(t) - V_0 = V_\alpha(t)
\end{cases}
\\ 
\end{gather}
$$

$$
\begin{gather}
\begin{cases}
S_{\phi_n}(f) = \frac{S_{\omega_n}(f)}{(2\pi f)^2} = \frac{S_{f_n}(f)}{f^2} = \frac{f_c^2 S_{f_{n,nor}}(f)}{f^2}
\\
S_{f_n}(f) = f_c^2 S_{f_{n,nor}}(f) = \frac{S_{\omega_n}(f)}{(2\pi)^2} = f^2 S_{\phi_n}(f)
\end{cases}
\end{gather}
$$

然后是相位噪声 (phase noise) 的定义：

$$
\begin{gather}
\mathscr{L}(f_m) := \frac{S_{v}(f_c + f_m)}{P_c}
\\
L(f_m) \ \mathrm{(Hz^{-1})} = \frac{S_v(f_c + f_m)\ \mathrm{(W/Hz)}}{P_c \ \mathrm{(W)}}
\\
L(f_m) \ \mathrm{(dBc/Hz)} = S_v(f_c + f_m)\ \mathrm{(dBm/Hz)} - P_c \ \mathrm{(dBm)}
\end{gather}
$$

$$
\begin{gather}
\mathscr{L}(f_m) = \frac{S_{v}(f_c + f_m)}{P_c},\quad 
P_c = \int_{f_c - \Delta f}^{f_c + \Delta f} S_v(f) \mathrm{d}f
\end{gather}
$$


$$
\begin{gather}
\begin{cases}
\mathrm{small\ noise\ angle\ hypothesis:\ } 
\begin{cases}
\phi_{n,rms} < 0.01 \ \mathrm{rad} = 0.5730^\circ
\\
\phi_{n,pp} < 0.20 \ \mathrm{rad} = 11.4592^\circ
\end{cases}
\\
\mathrm{negligible\ AM\ noise:\ \ } V_\alpha(t) \ll V_0
\end{cases}
\\
\Longrightarrow 
\color{red}{
\boxed{
\mathscr{L}(f_m) \approx \frac{1}{2} S_{\phi_n}(f)\big|_{f = f_m}
}
}
\end{gather}
$$

其次是抖动 (jitter) 的定义：

$$
\begin{gather}
T_0 = \frac{1}{N - 1} \sum_{n=1}^{N-1} T[n]
\\
T[n] = \mathrm{edge}[n + 1] - \mathrm{edge}[n],\quad n = 1, 2,..., N - 1
\\
\mathrm{Types\ of\ jitter:}
\begin{cases}
J_{c}[n] = T[n] - T_0 &,\  n = 1, 2,..., N
\\
J_{cc,L}[n] = T[n + L] - T[n] &,\  n = 1, 2,..., N - L
\\
J_{e}[n] = \mathrm{edge}[n] - \mathrm{edge}_{id}[n] &,\  n = 1, 2,..., N
\\
J_{ee,L}[n] = J_{e}[n + L] - J_{e}[n] &,\  n = 1, 2,..., N - L
\end{cases}
\end{gather}
$$

从 IEEE Standard 2020 中总结的常用抖动类型如下：

<span style='font-size:12px'> 
<div class='center'>

| Abbreviation | Full Name | Definition (IEEE Standard 2020) | Definition Expression | Equivalent Expression |
|:-|:-|:-|:-|:-:|
 | PEJ | period jitter | <div class='center' style='font-size:10px; width:300px'> The jitter in the period of a repetitive signal or its waveform. </div> | $J_{PEJ}[n] = T[n] - T_0,\ \ n = 1, 2,..., N$ | $J_{PEJ}[n] = J_c[n] = J_{ee,1}[n] = \left(J_e[n+1] - J_e[n]\right)$ |  |
 | TIE | time interval error | <div class='center' style='font-size:10px; width:300px'> The difference between two specified time intervals, each delimited by two event occurrences; the first interval is in the actual waveform and the other is in the ideal waveform. </div> | $J_{TIE,L}[n] = (\mathrm{edge}[n + L] - \mathrm{edge}[n]) - (\mathrm{edge}_{id}[n + L] - \mathrm{edge}_{id}[n])$ | $J_{TIE,L}[n] = J_{ee,L}[n] = J_{e}[n + L] - J_{e}[n] $ <br> $J_{TIE,1}[n] = J_{ee,1}[n] = J_c[n] = J_{PEJ}[n]$ |
 | TE | timing error | <div class='center' style='font-size:10px; width:300px'> The difference between the actual reference instant of an event and its ideal value. </div> | $J_{TE}[n] = \mathrm{edge}[n] - \mathrm{edge}_{id}[n]$ | $J_{TE}[n] = J_e[n]$ |
 | C2C | cycle-to-cycle jitter | <div class='center' style='font-size:10px; width:300px'> The difference between consecutive period durations in an ideally periodic signal. </div> | $J_{C2C}[n] = T[n + 1] - T[n],\ n = 1, 2,..., N - 1$ | $J_{C2C}[n] = J_{cc}[n]$ |

</div>
</span>

最后是从相位噪声频谱计算抖动：


$$
\begin{align}
\mathrm{RMS\ phase\ jitter:\ \ } 
J_{\phi_n, rms} & = \sqrt{\int_{f_L}^{f_H} S_{\phi_n}(f) \ \mathrm{d}f} 
\\ & = \sqrt{\int_{f_L}^{f_H} 2 L(f_m) \ \mathrm{d}f_m}
\\ \mathrm{RMS\ TIE\ jitter:\ \ } J_{TIE, L, rms} 
& = J_{ee,L,rms} 
\\ & = \sqrt{ \int_{f_L}^{f_H} S_{\phi_n}(f) \times 4 \sin^2 (\pi f \tau) \ \mathrm{d}f }
\\ & = \sqrt{ \int_{f_L}^{f_H} L(f_m) \times 8 \sin^2 (\pi f_m \tau) \ \mathrm{d}f_m }
\\ \mathrm{where:\ \ } & \tau = L \times T_s, L = 1, 2, 3, ...
\end{align}
$$


## Reference


相关文章/博客/技术文档：
- [{1} Keysight > Phase Noise and its Measurements (25 Oct 2024)](https://indico.ihep.ac.cn/event/22089/contributions/168539/attachments/83428/105838/02%20Phase%20Noise%20and%20its%20Measurement%20Solutions-20241025.pdf)
- [{2} Keysight > Methods and Instruments for Phase Noise Measurement](https://www.keysight.com/us/en/assets/3124-1845/application-notes/Methods-and-Instruments-for-Phase-Noise-Measurement.pdf)
- [{3} Keysight > AN10062 Phase Noise Measurement Guide for Oscillators](https://www.sitime.com/support/resource-library/application-notes/an10062-phase-noise-measurement-guide-oscillators)
- [{4} Keysight > E5052B Signal Source Analyzer](https://www.keysight.com/us/en/assets/7018-01529/technical-overviews/5989-6389.pdf)
- [{5} Phase Noise and AM Noise Measurements in the Frequency Domain](https://tf.nist.gov/general/tn1337/Tn190.pdf)
- [{6} TI Application Note > Jitter and Phase Noise Measurement Techniques for BAW Oscillators](https://www.ti.com.cn/cn/lit/an/snaa393/snaa393.pdf?ts=1706876003408)
- [{7} TI Application Report > How to Measure Total Jitter (TJ)](https://www.ti.com/lit/an/scaa120b/scaa120b.pdf?ts=1762191109494)
- [{8} TI Application Report > Time-Domain Jitter Measurement Considerations for Low Noise Oscillators](https://www.ti.com/lit/an/snaa285/snaa285.pdf?ts=1762191104280)
- [{9} Silicon Labs > Timing Jitter Tutorial & Measurement Guide](https://www.mouser.com/pdfdocs/timing-jitter-tutorial-and-measurement-guide-ebook.pdf)
- [{10} Silicon Labs > AN279 - Estimating Period Jitter From Phase Noise](https://www.skyworksinc.com/-/media/Skyworks/SL/documents/public/application-notes/AN279.pdf)
- [{11} Cadence > Community Forums > RF Design Usage of PN() after transient noise simulation](https://community.cadence.com/cadence_technology_forums/f/rf-design/47278/usage-of-pn-after-transient-noise-simulation)
- [{12} Cadence > Blogs > Analog/Custom Design Calculating Large Signal Phase Noise Using Transient Noise Analysis](https://community.cadence.com/cadence_blogs_8/b/cic/posts/calculating-large-signal-phase-noise-using-transient-noise-analysis)
- [{13} CSDN > Allan 方差计算方法实现](https://blog.csdn.net/Gou_Hailong/article/details/127288190)
- [{14} 知乎 > Allan 方差计算方法](https://zhuanlan.zhihu.com/p/550890736)
- [{15} The Designer’s Guide Community >  Predicting the Phase Noise and Jitter of PLL-Based Frequency Synthesizers](https://designers-guide.org/analysis/PLLnoise+jitter.pdf)

相关文献：
- [[1]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=4785494) X. Gao, E. A. M. Klumperink, P. F. J. Geraedts, and B. Nauta, “Jitter Analysis and a Benchmarking Figure-of-Merit for Phase-Locked Loops,” IEEE Transactions on Circuits and Systems II: Express Briefs, vol. 56, no. 2, pp. 117–121, Feb. 2009, [doi: 10.1109/TCSII.2008.2010189.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=4785494)
- [[2]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9364950) “IEEE Standard for Jitter and Phase Noise,” IEEE Std 2414-2020, pp. 1–42, Feb. 2021, [doi: 10.1109/IEEESTD.2021.9364950.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9364950)
- [[3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1703773) A. Demir, “Computing Timing Jitter From Phase Noise Spectra for Oscillators and Phase-Locked Loops With White and1/fNoise,” IEEE Transactions on Circuits and Systems I: Regular Papers, vol. 53, no. 9, pp. 1869–1884, Sept. 2006, [doi: 10.1109/TCSI.2006.881184.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1703773)
- [[4]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7219391) L. Liu and R. Pokharel, “Compact Modeling of Phase-Locked Loop Frequency Synthesizer for Transient Phase Noise and Jitter Simulation,” IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems, vol. 35, no. 1, pp. 166–170, Jan. 2016, [doi: 10.1109/TCAD.2015.2472018.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7219391)
- [[5]](https://kupdf.net/download/drakhlis-boris-calculate-oscillator-jitter-by-using-phase-noise-analysis-part-1_59f8716fe2b6f5d2274c7b5a_pdf#) Drakhlis, B.. (2001). Calculate oscillator jitter by using phase-noise analysis. Microwaves and RF. 40. 109-119. 
- [[6]](https://www.nist.gov/sites/default/files/documents/calibrations/tn1337.pdf) NIST Technical Note 1337. “Characterization of Clocks and Oscillators,” edited by D.B. Sullivan, D.W. Allan, D.A. Howe, F.L. Walls, 1990. 
- [[7]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9366669) "IEEE Standard Specification Format Guide and Test Procedure for Single-Axis Interferometric Fiber Optic Gyros," in IEEE Std 952-1997, vol., no., pp.1-84, 30 Nov. 1997, [doi: 10.1109/IEEESTD.1997.9366669.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9366669)
- [[9]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1661757) A. A. Abidi, “Phase Noise and Jitter in CMOS Ring Oscillators,” IEEE Journal of Solid-State Circuits, vol. 41, no. 8, pp. 1803–1816, Aug. 2006, [doi: 10.1109/JSSC.2006.876206.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1661757)
- [[10]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=766813) “Predicting the Phase Noise and Jitter of PLLBased Frequency Synthesizers,” in Phase-Locking in High-Performance Systems, IEEE, 2009. [doi: 10.1109/9780470545492.ch5.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=766813)
- [[11]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=658619) A. Hajimiri and T. H. Lee, “A general theory of phase noise in electrical oscillators,” IEEE Journal of Solid-State Circuits, vol. 33, no. 2, pp. 179–194, Feb. 1998, [doi: 10.1109/4.658619.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=658619)
- [[12] Phase Noise Characterization of Microwave Oscillators Frequency Discriminator Method](https://hpmemoryproject.org/an/pdf/pn11729C-2.pdf)


