# Phase Noise Modeling and Prediction of CP-PLL

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 16:36 on 2026-01-03 in Beijing.

## 1. Introduction

前置文章：
- [Loop Analysis of Typical Type-II CP-PLL](<AnalogIC/Loop Analysis of Typical Type-II CP-PLL.md>)
- [Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation](<AnalogIC/Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.md>)
- [Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum](<AnalogIC/Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.md>)
- [Phase Noise Modeling and Prediction of CP-PLL](<AnalogIC/Phase Noise Modeling and Prediction of CP-PLL.md>)

在前面几篇文章中，我们

## 2. Noise Transfer Functions

Noise Transfer 的推导倒是没什么可说的，有了 phase-domain model 后，直接计算各模块噪声源到输出相位的传递函数即可 (注意我们用的是 output-referred noise source)，这里直接给出结果：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-25-00-17-58_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>

<div class='center'>

| Module | Transfer Definition | Noise Transfer $H_{n,xx}(s)$ | Pass Type | Value @ DC | Value @ INF |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | VCO | $ H_{n,\ VCO}(s) = \frac{\phi_{out}}{\phi_{n,\ VCO}}$ | $H_{n,\ VCO}(s) = N \times \frac{1}{N + H_{OL}(s)}$ | High-pass | $0$ | N |
 | PFD | $ H_{n,\ PFD}(s) = \frac{\phi_{out}}{\phi_{n,\ PFD}}$ | $H_{n,\ PFD}(s) = N \times \color{red}{\frac{ H_{OL}(s)}{N + H_{OL}(s)}}$ | Low-pass | $N$ | 0 |
 | CP | $ H_{n,\ CP}(s) = \frac{\phi_{out}}{I_{n,\ CP}}$ | $H_{n,\ CP}(s) = \frac{N}{K_d} \times \color{red}{\frac{ H_{OL}(s)}{N + H_{OL}(s)}}$ | Low-pass | $\frac{N}{K_d}$ | 0 |
 | LPF | $ H_{n,\ LPF}(s) = \frac{\phi_{out}}{V_{n,\ LPF}}$ | $H_{n,\ LPF}(s) = N \times \frac{\frac{K_{VCO}}{s}}{N + H_{OL}(s)}$ | Band-pass | $0$ | $0$ |
 | FD | $ H_{n,\ FD}(s) = \frac{\phi_{out}}{\phi_{n,\ FD}}$ | $ H_{n,\ FD}(s) = -N \times \color{red}{\frac{ H_{OL}(s)}{N + H_{OL}(s)}}$ | Low-pass | $-N$ | 0 |
 | REF | $ H_{n,\ REF}(s) = \frac{\phi_{out}}{\phi_{n,\ REF}}$ | $ H_{n,\ REF}(s) = N \times \color{red}{\frac{ H_{OL}(s)}{N + H_{OL}(s)}}$ | Low-pass | $N$ | 0 |
</div>



其中：
- (1) $N$ 为 frequency division ratio
- (2) $H_{OL}(s) = K_d Z_{LF}(s) \frac{K_{VCO}}{s} $ 为 open-loop transfer function, 注意分频比是在 feedback factor $F = \frac{1}{N}$ 上，而不是开环增益中；也即 $H_{CL}(s) = \frac{H_{OL}(s)}{1 + \frac{H_{OL}(s)}{N}} = N \times \frac{H_{OL}(s)}{N + H_{OL}(s)}$
- (3) $K_d$ 为 PFD/CP 增益，经典 tri-state PFD/CP 结构有 $K_d = \frac{I_P}{2 \pi}\ \mathrm{rad/A}$.
- (4) $K_{VCO} := \frac{\mathrm{d}\ \omega_{out}}{\mathrm{d}\ V_{cont}}\ (\mathrm{rad/s/V})$ 为 VCO 增益， <span style='color:red'> 注意是角频率 $\omega_{out}$ 而不是 $f_{out}$ </span>
- (5) $Z_{LF}(s) := \frac{V}{I}(s)$ 为 loop filter impedance
- (6) 各模块的噪声传递函数的通带类型 (pass type) 也在上表中给出，方便后续分析各模块噪声对总相噪的贡献。



## 3. Noise Sources
### 3.0 REF
### 3.1 RVCO

由于 RVCO 是典型的 “large signal + time delay” 电路，其分析和建模都比较复杂。查阅多方资料后，我们发现 RVCO 的相噪模型要么就是 “太理论”，难以应用到实际，要么就是 “太高大上”，需要复杂的电路模型和参数，难以对实际设计进行有效建模和预测。于是，本文取了个折中，基于 [[1]](https://zhuanlan.zhihu.com/p/1920847644764411901) 给出的 ring-oscillator 相噪模型，将其推广到 Ring-VCO (而不是仅仅 oscillator) 的情况；并结合实际设计参数，对模型公式稍作调整。

[[1]](https://zhuanlan.zhihu.com/p/1920847644764411901) 原文中给出的 ring-oscillator 相噪公式为：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-03-16-56-05_Phase Noise Modeling and Prediction of CP-PLL.png"/></div>

上图中的各物理量含义如下：
- $f_{0}$: oscillation frequency 振荡频率
- $I_{D}$: ring-oscillator 在 slewing (crossing) 阶段的 (输出) 电流，更严谨地，是指其在 zero-crossing point (VDD/2 of output) 处的 drain current
- $g_m$: ring-oscillator 在 slewing (crossing) 阶段的小信号跨导
- $V_{DD}$: supply voltage
- $N$: ring-oscillator 的级数，为奇数
- $f$: single-sided offset frequency，此时 $S(f) = 2 L(f_m)$

详细的数学推导过程在原文中有，我们也在 Appendix.1 phase noise of inverter 中给出了理论总结，这里就不多赘述。容易知道 [[1]](https://zhuanlan.zhihu.com/p/1920847644764411901) 的推导思路是学习 [[2]](https://ieeexplore.ieee.org/document/6324396)，注意原文在数学处理时适当使用了一些近似，但最终结论仍有较好的准确性。


这里，我们将其推广到 Ring-VCO 的情况，主要修改点在于：
- (1) slewing $I_{D}$ 由上下对称电流源 $I_B$ 控制；由 Appendix.2 中的分析可知，此时反相器管的噪声可以忽略，电流噪声主要来自于 current source, 因此直接将 $S_{I_n}(f)$ 替换为 current source 的噪声谱密度即可。此时 $S_{I_n}(f) = 4 k T \gamma I_B \left(\frac{g_m}{I_D}\right)_{bias,N}$，其中 $\left(\frac{g_m}{I_D}\right)_{bias,N}$ 是下方 bias current source 的 gm/Id 值。
- (2) 将 single-sided power spectrum $S(f)$ 改写为更标准的 SSB phase noise $L(f_m)$
- (3) 将 RVCO 级数 $N$ 改写为 $N_{ring}$，避免与 Integer-N FD 中的 $N$ 混淆，同时将 $f_0$ 改写为 $f_{osc}$；
- (4) 使用 $\frac{g_m}{I_D}$ 而不是 $V_{OV}$ (overdrive voltage) 来得到最终表达式；这样做的好处是在 $I_B$ 具有良好定义的情况下，简化了 slewing 阶段的 $g_m$ 计算，并且精度也更好。

修改后的 Ring-VCO 相噪模型如下：

$$
\begin{gather}
\boxed{
S_{\phi_n,\ \mathrm{RVCO,\ white}}(f) = 
\left[ \left(\frac{g_m}{I_D}\right)_{bias,N} + \left(\frac{g_m}{I_D}\right)_{bias,P} \right] \times \frac{2 k T \gamma f_{osc}^2}{I_B}
\times \frac{1}{f^2}, \quad f \in (0,\ \infty)
}
\\
S_{\phi_n,\ \mathrm{RVCO,\ 1/f}}(f) =
\left[ \left(\frac{g_m}{I_D}\right)_{bias,N}^2 + \left(\frac{g_m}{I_D}\right)_{bias,P}^2 \right] \times \frac{K f_{osc}^2}{4 N_{ring} WL C_{ox}} \times \frac{1}{f^3}, \quad f \in (0,\ \infty)
\end{gather}
$$




### 3.2 PFD

本文考虑典型 tri-state PFD 结构 (如下图)，所以也可以基于 Appendix.1 phase noise of inverter 中的结论推导 PFD 的相噪。至于是 NOR-based PFD 还是 NAND-based PFD，这里都近似采用 INV 模型。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-03-22-21-15_Phase Noise Modeling and Prediction of CP-PLL.png"/></div>

一个输入信号 A/B 进入 PFD，共经过两级 NOR/NAND 才能到达 UP/DN，因此考虑两个 INV 相噪的叠加，并注意 output falling/rising edge 都要算上，我们有：

$$
\begin{gather}
S_{\phi_n,\ \mathrm{PFD,\ white}}(f) \approx  2 \times \frac{\pi^2}{I_{D}^2 T_{in}} \times 
\left[
(\Delta T)_{fall} \times S_{I_n,\ N}(f) + (\Delta T)_{rise} \times S_{I_n,\ P}(f)
\right]
\\
\mathrm{where\ } S_{I_n}(f) = 4 k T \gamma g_{ds} \approx 4 k T \gamma g_{m} = 4 k T \gamma I_D \left(\frac{g_m}{I_D}\right)
\end{gather}
$$

用上升/下降时间来近似 transition time，也即 $(\Delta T)_{fall} \approx t_{rise}$，$(\Delta T)_{rise} \approx t_{fall}$，我们得到：

$$
\begin{gather}
S_{\phi_n,\ \mathrm{PFD,\ white}}(f) \approx 
\frac{8 \pi^2 k T \gamma}{I_{D}} \times 
\left[
\frac{t_{rise}}{T_{in}} \times \left(\frac{g_m}{I_D}\right)_N + \frac{t_{fall}}{T_{in}} \times \left(\frac{g_m}{I_D}\right)_P
\right]
\end{gather}
$$

更进一步地，如果认为 NMOS/PMOS 在各阶段都完全对称，也即 $\left(\frac{g_m}{I_D}\right)_N = \left(\frac{g_m}{I_D}\right)_P = \left(\frac{g_m}{I_D}\right)$，并且 $t_{rise} = t_{fall} = t_{pd}$，则有：

$$
\begin{gather}
\boxed{
S_{\phi_n,\ \mathrm{PFD,\ white}}(f) \approx 
\frac{8 \pi^2 k T \gamma}{I_{D} } \times \frac{t_{pd}}{T_{in}} \left(\frac{g_m}{I_D}\right)
}
\end{gather}
$$



### 3.3 CP

环路完全稳定后，由于 CP 仅在每个 $T_{ref}$ 的 $\tau_{pul}$ 时间内导通，其等效噪声功率会缩小为原来的 $D = \frac{\tau_{pul}}{T_{ref}}$ 倍；再考虑到 NMOS 和 PMOS 都打开，所以噪声功率需叠加，得到 CP 的等效噪声功率谱：

$$
\begin{gather}
S_{I_n,CP}(f) = D_{pulse} \times \left[S_{I_n,N}(f) + S_{I_n,P}(f)\right] = 4 k T \gamma D_{pulse} I_P \times \left[\left(\frac{g_m}{I_D}\right)_{N} + \left(\frac{g_m}{I_D}\right)_{P}\right]
\end{gather}
$$

其中 $\left(\frac{g_m}{I_D}\right)_{N/P}$ 是 CP 中输出管在 on-state 输出电流时的 gm/Id 值。


### 3.4 LPF

考虑最典型的 2nd-order LPF，也即 $Z_{LF}(s) = \left(R_1 + \frac{1}{s C_1}\right) \parallel \frac{1}{sC_2}$，其中 $C_2 = \alpha C_1 \ll C_1$。此结构中仅有 $R_1$ 产生热噪声 $S_{I_n}(f) = \frac{4 k T}{R_1}$，推导过程如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-04-00-28-41_Phase Noise Modeling and Prediction of CP-PLL.png"/></div>

由此得到 LPF 等效输出噪声功率谱：

$$
\begin{gather}
S_{V_n,LPF}(f) \approx \frac{4 k T R_1}{\left(1 + s R_1 C_2\right)^2}
,\quad C_2 = \alpha C_1 \ll C_1
\end{gather}
$$

注意上面的极点由 $R_1 C_2$ 构成而不是 $C_1$，相当于 $R_1$ 的热噪声通过一个低通滤波器 $\frac{1}{1 + s R_1 C_2}$。


### 3.5 FD

FD 的话，一般是使用 DFF-based freq. divider，最常见的就是 DFF 中 QB 和 D 短接构成的 integer-2 divider。由于 DFF 实现方法多样，严谨的噪声分析较为困难，这里我们仍采用 jitter-based INV 模型近似其相噪。

先推导典型 integer-2 divider 的相噪。如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-04-00-39-48_Phase Noise Modeling and Prediction of CP-PLL.png"/></div>

考虑上图中的第二个 (16T) gated D-latch 结构。以时钟 CK 上升沿为例，输入信号 CK (可能) 经过一个反相器到达 gated D-latch 的 EN 端，然后再经过 2-NAND 到达 Q, 经过 3-NAND 到达 QB:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-04-00-46-52_Phase Noise Modeling and Prediction of CP-PLL.png"/></div>

根据上图，作如下分析：
- (1) 仅考虑 Q 端，用 INV 噪声模型来近似 NAND 的抖动 (相噪)，则 CK 上升沿共经过 3 个 INV 才能到达 Q 端
- (2) 又考虑到分频输出 Q 仅在 CK 上升沿发生变化，也即第一个 CK 上升沿对应 Q 上升沿，第二个 CK 上升沿对应 Q 下降沿，因此将 INV 的 rise/fall 部分叠加后需除以二
- (3) 与 PFD 类似，直接假设各管对称以简化表达式，则单个 INV 的 total rise/fall 抖动 (相噪) 为 $S_{\phi_n,\ INV,\ white}(f) = \frac{8 \pi^2 k T \gamma}{I_{D}} \times \frac{t_{pd}}{T_{in}} \left(\frac{g_m}{I_D}\right)$

综上，一个 integer-2 divider 的相噪功率谱为：

$$
\begin{gather}
S_{\phi_n, FD2}(f) = \frac{3}{2} \times S_{\phi_n,\ INV,\ white}(f) 
= \frac{12 \pi^2 k T \gamma}{I_{D}} \times \frac{t_{pd}}{T_{in}} \left(\frac{g_m}{I_D}\right) 
= \frac{12 \pi^2 k T \gamma}{I_{D}} \times t_{pd}f_{in} \left(\frac{g_m}{I_D}\right) 
\end{gather}
$$

上式可以看出，FD 输出相噪与工作频率 $f_{in}$ 成正比，因此 FD chain 的整体相噪通常取决于前几级 divider。


假设分频链的前三级均为 integer-2 divider，则 FD chain 的总相噪可近似为：

$$
\begin{gather}
S_{\phi_n, FD}(f) \approx \frac{12 \pi^2 k T \gamma}{I_{D}} \times t_{pd} \left(f_{in} + \frac{f_{in}}{2} + \frac{f_{in}}{4} \right) \left(\frac{g_m}{I_D}\right) 
= \frac{21 \pi^2 k T \gamma}{I_{D}} \times t_{pd} f_{in} \left(\frac{g_m}{I_D}\right)
\end{gather}
$$

其中 $t_{pd} = \frac{1}{2} \left(t_{rise} + t_{fall}\right)$ 是 FD2 的平均 transition time，更精确的值应当采用 zero-crossing delay time, 但这个值一般只能仿真得到，难以手动估计。




## 4. Total Phase Noise

有了 noise transfer functions 和各模块噪声源的表达式后，我们就可以对 CP-PLL 的总输出相噪进行建模和预测了。注意我们仅考虑 thermal 而不考虑 flicker noise，所有相噪汇总如下：


<span style='font-size:12px'> 

$$
\begin{gather}
\begin{aligned}
\mathrm{Module:}
&\quad   \mathrm{White\ Noise\ Source}\ S_{n, xx}(f)
&&\quad  \mathrm{Noise\ Transfer\ FUnction}\ H_{n,xx}(f)
\\
\mathrm{RVCO:} 
&\quad   S_{\phi_n,\ RVCO}(f) = \left[ \left(\frac{g_m}{I_D}\right)_{bias,N} + \left(\frac{g_m}{I_D}\right)_{bias,P} \right] \frac{2 k T \gamma f_{out}^2}{I_B}\times \frac{1}{f^2}
&&\quad  H_{n,\ VCO}(s)|_{s = j 2\pi f} = N \times \frac{1}{N + H_{OL}(s)}
\\
\mathrm{PFD:} 
&\quad   S_{\phi_n,\ PFD}(f) = \frac{8 \pi^2 k T \gamma}{I_{D} } \times \left(\frac{t_{pd}}{T_{in}}\right) \left(\frac{g_m}{I_D}\right)
&&\quad  H_{n,\ PFD}(s)|_{s = j 2\pi f} = N \times \frac{ H_{OL}(s)}{N + H_{OL}(s)}
\\
\mathrm{CP:} 
&\quad   S_{I_n,\ CP}(f) = 4 k T \gamma D_{pulse} I_P \times \left[\left(\frac{g_m}{I_D}\right)_{N} + \left(\frac{g_m}{I_D}\right)_{P}\right]
&&\quad  H_{n,\ CP}(s)|_{s = j 2\pi f} = \frac{N}{K_d} \times \frac{ H_{OL}(s)}{N + H_{OL}(s)}
\\
\mathrm{LPF:} 
&\quad   S_{V_n,\ LPF}(f) = \frac{4 k T R_1}{\left(1 + j 2 \pi f R_1 C_2\right)^2}
&&\quad  H_{n,\ LPF}(s)|_{s = j 2\pi f} = N \times \frac{\frac{K_{VCO}}{j 2 \pi f}}{N + H_{OL}(s)}
\\
\mathrm{FD:}
&\quad   S_{\phi_n,\ FD}(f) = \frac{21 \pi^2 k T \gamma}{I_{D}} \times \left(\frac{t_{pd}}{T_{in}}\right) \left(\frac{g_m}{I_D}\right)
&&\quad  H_{n,\ FD}(s)|_{s = j 2\pi f} = -N \times \frac{ H_{OL}(s)}{N + H_{OL}(s)}
\\
\mathrm{REF:}
&\quad   S_{\phi_n,\ REF}(f) = \mathrm{NA}
&&\quad  H_{n,\ REF}(s)|_{s = j 2\pi f} = N \times \frac{ H_{OL}(s)}{N + H_{OL}(s)}
\end{aligned}
\end{gather}
$$

</span>

其中：

$$
\begin{gather}
H_{OL}(s) = K_d Z_{LF}(s) \frac{K_{VCO}}{s}
\end{gather}
$$


## 5. Prediction Example


### 5.1 square clock @ 1.28 GHz

以之前的练手项目 `202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-64` 为例，利用上述模型对 square clock @ 1.28 GHz 的相噪进行预测，并与 post-simulation 结果作对比。

环路参数、相噪模型参数以及预测结果对比如下：

``` bash
%%%%%%%%%%%%%%% loop parameter %%%%%%%%%%%%%%%%%%
I_P = 100*1e-6   
R_1 = 1*1e3   % R1
C_1 = 50*1e-12 % C1
K_VCO_Hz = 7e9             % unit: Hz/V
K_VCO_rads = 2*pi * K_VCO_Hz   % unit: (rad/s)/V
f_in = 20e6;
omega_in = 2*pi*f_in;
Divide_N = 64;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%% phase noise parameter %%%%%%%%%%%%%%%%%%%
k = 1.381e-23;
T = 300;
gamma = 1;

gmId_INV = 4;
gmId_VCON = 3;
gmId_VCOP = gmId_VCON*1.2;
gmId_CPN = 2; gmId_CPP = 2; 
I_B_VCO = 80e-06;
I_D_INV = 300e-06;
D_pd_INV = 50e-12 * f_in;
D_pulse_CP = 0.4e-09 * f_in;  % pulse_min 在 1/3 ns ~ 1/2 ns 这样子, 可取 0.4 ns = 400 ps

f_out = N*f_in;
C_2 = alpha*C_1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-05-12-41-52_Phase Noise Modeling and Prediction of CP-PLL.png"/></div>

我们先不作讨论，继续看第二个例子再一起来说。

### 5.2 square clock @ 786.432 kHz

不妨再以最近的项目 `202510_onc18_CPPLL_ultra_low_lower` 为例，利用上述模型对 square clock @ 786.432 kHz 的相噪进行预测，并与 post-simulation 结果作对比。

环路参数、相噪模型参数以及预测结果对比如下：

``` bash
%%%%%%%%%%%%%%% loop parameter %%%%%%%%%%%%%%%%%%
I_P = [20]*1e-9   
R_1 = [10]*1e6   % R1
C_1 = [42]*1e-12 % C1
K_VCO_Hz = 11.43e6             % unit: Hz/V
K_VCO_rads = 2*pi * K_VCO_Hz   % unit: (rad/s)/V
f_in = 32.768e3;
omega_in = 2*pi*f_in;
Divide_N = 24;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% phase noise parameter %%%%%%%%%%%%%%%%%%%
k = 1.381e-23;
T = 300;
gamma = 1;

gmId = 5;
gmId_VCON = 3;
gmId_VCOP = gmId_VCON*1.2;
gmId_CPN = 2; gmId_CPP = 2; 
I_B = 50e-09;
I_D = 500e-09;
D_pd = 8e-09 * f_in;
D_pulse = 0.005;

f_out = N*f_in;
C_2 = alpha*C_1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-05-12-21-30_Phase Noise Modeling and Prediction of CP-PLL.png"/></div>




### 5.3 comparison summary

上面两个例子可以看出：
- (1) 模型虽然误差较大 (约为仿真值的 0.1 倍)，但整体趋势还是比较吻合的，说明模型思路可取；
- (2) 虽然模型得到的相噪结果偏低，但把这个结果乘上十倍之后 (+ 10 dB)，便与仿真结果基本吻合；尽管背后原因未知，但这样确实得到了一个 "还算不错" 的预测模型；
- (3) 模型中各模块的相噪表达式可能过于简化，忽略了很多实际电路中的细节 (如非理想特性、寄生参数等)，导致误差较大，后续有新思路的话再来改进模型吧。

## Appendix

### A.1 phase noise of inverter

文献 [[2]](https://ieeexplore.ieee.org/document/6324396) 中详细推导了仅考虑 transition 过程中的 thermal and flicker noise 时，反相器的相位噪声表现，容易看出 [[1]](https://zhuanlan.zhihu.com/p/1920847644764411901) 的推导思路也是基于此文献。

这里不对过程作过多赘述，直接给出结果和适用条件。

$$
\begin{gather}
\mathrm{White\ noise\ due\ to\ one\ MOS:\ }
\\
S_{\phi_n,\ white} (f) = \frac{\pi^2}{I_D^2} \frac{\Delta T}{T_{in}} \times S_{I_n}(f),\quad S_{I_n} = 4 k T \gamma g_{ds} \approx 4 k T \gamma g_m
\\
\mathrm{Flicker\ noise\ due\ to\ one\ MOS:\ }
\\ 
S_{\phi_n,\ 1/f} (f) = \frac{\pi^2}{I_D^2} \left(\frac{\Delta T}{T_{in}}\right)^2 \times S_{I_n}(f),\quad S_{I_n} = \frac{K g_m^2}{WL C_{ox} f}
\end{gather}
$$

上式中：
- $T_{in}$: input period
- $\Delta T$: transition time, e.g., the time range from zero-crossing of IN to zero-crossing of OUT (输入输出电压中点之间的时间差), 简单来说就是反相器的 gate delay time
- $S_{I_n}$: thermal current noise spectral density of the MOSFET, namely $S_{I_n} = 4 k T \gamma g_{ds}$
- $I_D$: drain current of the on-state MOSFET at zero-crossing point


假设/适用条件：
- (1) 仅考虑了 transition 过程中处于 on-state 的 MOSFET 噪声贡献，忽略了另一个处于 off-state 的 MOSFET.
- (2) 假设 transition 过程中负载电容 $C_L$ 为常量


很多情形下，我们需要利用反相器的抖动/相噪模型对其它逻辑门电路 (如 NAND/NOR) 的噪声作近似，并且希望得到尽量简单的表达式。此时，可以直接令各管对称以简化表达式，则单个 INV 的 total rise/fall 抖动 (相噪) 为：

$$
\begin{gather}
\mathrm{Total\ rise/fall\ jitter:\ \ } 
S_{\phi_n,\ INV,\ white}(f) = \frac{2 \pi^2}{I_D^2} \frac{t_{pd}}{T_{in}} \times S_{I_n}(f) = \frac{8 \pi^2 k T \gamma}{I_{D}} \times \frac{t_{pd}}{T_{in}} \left(\frac{g_m}{I_D}\right)
\end{gather}
$$


### A.2 phase noise of VC-INV

本文所谓 VC-INV (voltage-controlled inverter) 指的是由上下对称电流源控制的反相器，偏置电流为 $I_B$。基于上一小节 inverter 的相噪结果，我们利用小信号分析对 VC-INV 的相噪进行推导，详细过程如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-03-22-12-41_Phase Noise Modeling and Prediction of CP-PLL.png"/></div>

也就是说，加入了上下对称电流源后，VC-INV 的相噪表现与普通反相器类似，只是噪声源从 NMOS of INV 变成了 NMOS current source (同理 PMOS 也是)，也即：

$$
\begin{gather}
S_{\phi_n,\ white} (f) = \frac{\pi^2}{I_B^2} \frac{\Delta T}{T_{in}} \times S_{I_n}(f),\quad S_{I_n} = 4 k T \gamma g_{ds} 
\\
S_{\phi_n,\ 1/f} (f) = \frac{\pi^2}{I_B^2} \left(\frac{\Delta T}{T_{in}}\right)^2 \times S_{I_n}(f),\quad S_{I_n} = \frac{K g_m^2}{WL C_{ox} f}
\end{gather}
$$

其中 $I_B$ 是 current source 的偏置电流。



## Reference

本文引用到的文献：
- [[1]](https://zhuanlan.zhihu.com/p/1920847644764411901) Leon, “Ring-VCO相位噪声详细推导.” Accessed: Jan. 03, 2026. [Online]. Available: https://zhuanlan.zhihu.com/p/1920847644764411901
- [[2]](https://ieeexplore.ieee.org/document/6324396) A. Homayoun, “Analysis of Phase Noise in Phase/Frequency Detectors,” IEEE Transactions on Circuits and Systems I: Regular Papers, vol. 60, no. 3, pp. 529–539, Mar. 2013, doi: 10.1109/TCSI.2012.2215792.

本文未提及，但我们读过之后认为可能有帮助的文献：
- [3] M. van Delden, L. Polzin, B. Walther, N. Pohl, K. Aufinger, and T. Musch, “A Fast and Highly-Linear Phase-Frequency Detector with Low Noise for Fractional Phase-Locked Loops,” in 2023 IEEE/MTT-S International Microwave Symposium - IMS 2023, June 2023, pp. 224–227. doi: 10.1109/IMS37964.2023.10187956.
- [4] Y. Lei, R. Jiang, S. Ye, C. He, C. Li, and W. Wang, “A Low Phase Noise Performance Phase Frequency Detector and Charge Pump in a 65nm CMOS Technology,” in 2023 2nd International Joint Conference on Information and Communication Engineering (JCICE), May 2023, pp. 111–115. doi: 10.1109/JCICE59059.2023.00031.
- [5] V. F. Kroupa, “Jitter and phase noise in frequency dividers,” IEEE Transactions on Instrumentation and Measurement, vol. 50, no. 5, pp. 1241–1243, Oct. 2001, doi: 10.1109/19.963191.
- [6] W. F. Egan, “Modeling phase noise in frequency dividers,” IEEE Transactions on Ultrasonics, Ferroelectrics, and Frequency Control, vol. 37, no. 4, pp. 307–315, July 1990, doi: 10.1109/58.56498.
- [7] M. K. Hati and T. K. Bhattacharyya, “Phase noise analysis of proposed PFD and CP switching circuit and its advantages over various PFD/CP switching circuits in phase-locked loops,” Integration, vol. 63, pp. 115–129, Sept. 2018, doi: 10.1016/j.vlsi.2018.06.002.
- [8] S. Levantino, L. Romano, S. Pellerano, C. Samori, and A. L. Lacaita, “Phase noise in digital frequency dividers,” IEEE Journal of Solid-State Circuits, vol. 39, no. 5, pp. 775–784, May 2004, doi: 10.1109/JSSC.2004.826338.
- [9] M. Apostolidou, P. G. M. Baltus, and C. S. Vaucher, “Phase noise in frequency divider circuits,” in 2008 IEEE International Symposium on Circuits and Systems (ISCAS), Seattle, WA, USA: IEEE, May 2008, pp. 2538–2541. doi: 10.1109/ISCAS.2008.4541973.
- [10] A. Dyskin and I. Kallfass, “Phase noise prediction for static frequency dividers and ring oscillators,” Electronics Letters, vol. 54, no. 25, pp. 1427–1428, 2018, doi: 10.1049/el.2018.6498.
- [11] A. Narayanan and N. Krishnapura, “Simulation of Divider Phase Noise and Spurious Tones in Integer-N PLLs,” in 2023 30th IEEE International Conference on Electronics, Circuits and Systems (ICECS), Dec. 2023, pp. 1–5. doi: 10.1109/ICECS58634.2023.10382810.