# Razavi CMOS - Chapter 15. Oscillators


> [!Note|style:callout|label:Infor]
> Initially published at 21:16 on 2025-06-26 in Beijing.

参考教材：[*Design of Analog CMOS Integrated Circuits (Behzad Razavi) (2nd edition, 2017)*](https://www.zhihu.com/question/452068235/answer/95164892409)

## Introduction

本章主要探讨了 CMOS Oscillators (振荡器) 的分析与设计，更具体地说是压控振荡器 (VCO, voltage-controlled oscillator)。我们先回顾反馈系统中的振荡现象，然后介绍 ring oscillator (环形振荡器) 和 LC 振荡器，并讨论改变振荡频率的方法 (VCO)。最后给出 VCO 的数学模型，该模型将在第 16 章中用于锁相环 (PLL) 的分析。

## References

Razavi 一书中，本章的参考文献如下：
- [1] ([link 1](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=133172), [link 2](https://ieeexplore.ieee.org/document/133172)) N. M. Nguyen and R. G. Meyer, “Start-up and Frequency Stability in High-Frequency Oscillators,” IEEE J. of Solid-State Circuits, vol. 27, pp. 810–820, May 1992. 
- [2] ([link 1](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=165341), [link 2](https://ieeexplore.ieee.org/document/165341)) I. A. Young, J. K. Greason, and K. L. Wong, “A PLL Clock Generator with 5 to 110 MHz of Lock Range for Microprocessors,” IEEE J. of Solid-State Circuits, vol. SC-27, pp. 1599–1607, November 1992. 
- [3] ([link 1](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1414941), [link 2](https://ieeexplore.ieee.org/document/1414941)) B. Lai and R. C. Walker, “A Monolithic 622 Mb/sec Clock Extraction and Data Retiming Circuit,” ISSCC Dig. of Tech. Papers, pp. 144–145, February 1991. 
- [4] ([link 1](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=173103), [link 2](https://ieeexplore.ieee.org/document/173103)) S. K. Enam and A. A. Abidi, “NMOS ICs for Clock and Data Regeneration in Gigabit-per-Second Optical-Fiber Receivers,” IEEE J. of Solid-State Circuits, vol. SC-27, pp. 1763–1774, December 1992. 
- [5] B. Razavi, RF Microelectronics, 2nd ed. (Upper Saddle River, NJ: Prentice-Hall, 2012).

## 1. General Considerations


负反馈系统发生振荡的一个必要不充分条件是：

$$
\begin{gather}
|H(j\omega_0)| \ge 1 \ \ \mathrm{if} \angle H(j\omega_0) = 180^\circ 
\end{gather}
$$

其中 $H(j\omega)$ 是系统的开环传递函数，$\omega_0$ 是 phase cross-over frequency. 上面这条规则称为 **Barkhausen criterion** (巴克豪森准则)。

下图是由反馈系统构成振荡器的三个等价形式：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-26-21-28-23_Oscillators.png"/></div>

## 2. Ring Oscillators


一般情况下，起码需要三个 common-source stage 才能构成 (具有实用性的) 环形振荡器。将输出连接回输入的 gate 端，由于三个 CS stages 本就具有 180° 的相移，要使得环形振荡器振荡 (total phase shift = 360°)，还需要每级 CS stage 额外提供 60° 的相移。由此得到产生振荡的条件：

$$
\begin{gather}
A = \frac{A_0}{1 + \frac{s}{\omega_0}} \Longrightarrow  A_0 = 2,\ \  \omega_{osc} = \sqrt{3} \omega_0
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-26-21-31-37_Oscillators.png"/></div>

此时，上图中的 E, F, G 点一共可以产生三个振荡信号，它们频率相同，相位分别为 0°, 120° 和 240° (注意不是 0°, -120° 和 -240°)。能够产生多个同频率不同相位的振荡信号是环形振荡器的一个重要优势。

实际中不可能保证 $A_0$ 严格等于 2, 因此需要研究振荡器在 $A_0 > 0$ 下的行为。考虑下图所示的线性系统框图，其闭环传递函数为 (注意反馈系数 $K = -1$, 为正反馈)：

$$
\begin{gather}
A = \frac{- A_0^3}{\left(1 + \frac{s}{\omega_0}\right)^3}
\\
H_{CL}(s) = \frac{V_{out}(s)}{V_{in}(s)} = \frac{A}{1 + K A}
=  \frac{\frac{- A_0^3}{\left(1 + \frac{s}{\omega_0}\right)^3}}{1 + \frac{A_0^3}{\left(1 + \frac{s}{\omega_0}\right)^3}} = \frac{- A_0^3}{\left(1 + \frac{s}{\omega_0}\right)^3 + A_0^3}
\\
s_1 = - (A_0 + 1)\omega_0,\quad s_{2,3} = \left[ \frac{A_0 (1 \pm j\sqrt{3})}{2} - 1 \right]\omega_0 = \left[ \frac{A_0 - 2}{2} \pm j \frac{\sqrt{3}}{2}A_0 \right]\omega_0
\end{gather}
$$

依据极点的分布情况，零状态且零输入响应为：

$$
\begin{align}
s_1 &  \longmapsto e^{- (A_0 + 1)\omega_0 t}
\\
s_{2,3} &  \longmapsto e^{ \frac{A_0 - 2}{2} \omega_0 t }\cos \left( \frac{\sqrt{3}}{2}A_0 \omega_0 t \right)
\end{align}
$$

显然，对于 $A_0 > 2$ 的情况，$s_{2,3}$ 的实部为正，系统输出随时间无限增长（如果没有限幅），在实际电路中表现为接近方波的输出。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-26-21-34-42_Oscillators.png"/></div>

最简单的 ring oscillator 是由三个 CMOS inverter 构成的，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-26-22-15-54_Oscillators.png"/></div>

其振荡周期：
$$
\begin{gather}
T_{osc} = 6 T_D,\quad f_{osc} = \frac{1}{6 T_D}
\end{gather}
$$

在振荡还未完全形成时，输出信号会以 $\omega = \frac{\sqrt{3}}{2}A_0 \omega_0 t$ 为角频率，且幅度逐渐增大，直至形成类似方波的完全振荡，此时信号频率 **降低** 到 $f_{osc} = \frac{1}{6 T_D}\ \ (6 T_D < \frac{2\pi}{\omega})$.

具有不止三个 inverter 的 ring oscillator 也很常见，通常是 **奇数个** inverter 来构成振荡器以避免 "latch up" (deadlocked, 闩锁, 卡死)。注意这里所说的 "latch up" 是指 deadlocked, 和 "CMOS 工艺中因寄生三极管触发大电流导致器件损坏" 的 "latch up" 不同。

另外，也可以由 **偶数个** 差分输入的 stage 构成 ring oscillator, 如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-26-22-27-34_Oscillators.png"/></div>

在大多数情况下, 3 ~ 5 个 stages 构成的 ring oscillator 具有较好的综合性能 (4-stages oscillator 由差分级构成)。

## 3. LC Oscillators

随着工艺的迭代更新，片上电感在 CMOS 技术中已变得十分常见，从而发展出片上的 LC oscillators. 在深入探讨此类振荡器之前，先回顾一下 RLC 电路的基本特性是很有必要的。

### 3.1 Basic Concepts

如下图 (a) 所示，一个理想电感和一个理想电容并联，其谐振频率为 $\omega = \frac{1}{\sqrt{LC}}$, 此时 $Z_{eq} = \infty$, 在国内教材称为并联谐振，也就是 $|Z| = |Z|_{\max}$ or $|Z| = \infty$. 

如图 (b), 实际用 metal 来构成电感时, metal 自带的电阻一般不可忽略，此时的 L-R || C 电路称为 **tank**, 其等效阻抗为：

$$
\begin{gather}
Z_{eq}(s) 
= \frac{R_S + s L_1}{S^2 L_1 C_1 + s R_S C_1 + 1},\quad Q = \frac{\omega L_1}{R_S}
\\
|Z_{eq}|^2 
= \frac{R_S^2 + \omega^2 L_1^2}{(1 - \omega^2 L_1 C_1)^2 + \omega^2 R_S^2 C_1^2} 
= \frac{R_S^2 + x L_1^2}{x^2 L^2 C^2 + x(R^2 C^2 - 2 LC) + 1}
\\
|Z_{eq}|_{\omega = \frac{1}{\sqrt{L_1 C_1}}} 
= \sqrt{\frac{L_1}{C_1} + \frac{L_1^2}{R_S^2C_1^2}}
\\
\omega_0 
= \sqrt{-\frac{C\,R^2 -\sqrt{L}\,\sqrt{2\,C\,R^2 +L}}{C\,L^2 }}
= \frac{1}{\sqrt{L C}}\cdot \sqrt{\sqrt{1 + \frac{2 R^2 C}{L}} - \frac{R^2 C}{L} } 
\approx \frac{1}{\sqrt{L C}} 
\\
|Z_{eq}|_{\max} 
= |Z_{eq}|_{\omega = \omega_0} 
= -\frac{L^2 \,\sqrt{2\,C\,R^2 +L}}{C\,{\left(2\,L\,\sqrt{2\,C\,R^2 +L}-2\,L^{3/2} +C\,R^2 \,\sqrt{2\,C\,R^2 +L}-4\,C\,\sqrt{L}\,R^2 \right)}}
\end{gather}
$$

注意 $\frac{L}{C}$ 具有 $R^2$ 的量纲。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-26-22-41-10_Oscillators.png"/></div>


显然，上面的公式实在是太过繁琐，这对电路的设计和分析极不友好。为了解决这个问题，我们希望在很窄的频段内用 RL 并联电路来替代 RL 的串联。结论和具体推导过程如下：

$$
\begin{gather}
L_P 
= L_1 \left(1 + \frac{R_S^2}{\omega^2 L_1^2} \right) 
= L_1 \left(1 + \frac{1}{Q^2} \right) \approx L_1
,\quad 
R_P = \frac{\omega^2 L_1 L_P}{R_S} = \left(Q^2 + 1\right)R_S \approx Q^2 R_S
\end{gather}
\\
\omega = \omega_{0} = \frac{1}{\sqrt{L C}}\cdot \sqrt{\sqrt{1 + \frac{2 R^2 C}{L}} - \frac{R^2 C}{L} }
\approx \frac{1}{\sqrt{L C}}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-26-23-14-59_Oscillators.png"/></div>

由上面的等效可以看出, tank 在 resonance frequency $\omega_0$ 附近呈现纯电阻性 (pure resistive)，这是一个非常重要的特性。

### 3.2 Cross-Coupled LC Oscillator

下图是 cross-coupled LC oscillator 的一个例子。两级 CS stage 提供 2*180° = 360° 的 phase shift, 从而形成振荡。读者可能有疑问，为什么这里会发生振荡而不是 latch up 呢？毕竟从信号来看, X 升高 > Y 降低 > X 升高会使得 X 持续升高，最终 latch up. 这是因为 latch up 看的是 low-frequency 下的特性，而下图所示电路的 low-frequency gain 非常小 (约等于零)。只要 low-frequency gain < 1 就不会发生 latch up, 因此这里的 cross-coupled LC oscillator 自然不会 latch up.

<!-- **<span style='color:red'> 这里对 latch up 的解释能否更直观详细一些？感觉说服力没有那么强。 </span>**-->


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-26-23-43-34_An Introduction to Oscillators.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-27-00-00-43_An Introduction to Oscillators.png"/></div>



上图中的电路也常常等价地画为下图的 (a) 和 (b)。同时，由于 X 和 Y 处的 voltage 是 differential 的 (每一级都是 180° 的 phase shift at the resonance frequency), 我们可以将其改进为下图 (c) 所示的差分电路。这样还有一个好处就是，电路的偏置电流完全由 $I_{SS}$ 决定，而与 VDD 无关 (改进前的偏置电流受 VDD 影响非常大)。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-27-00-30-43_An Introduction to Oscillators.png"/></div>

### 3.3 Colpitts Oscillator

### 3.4 One-Port Oscillator

## 4. VCOs

大多数应用都需要振荡器具备“可调性”，即其输出频率应取决于一个控制输入，通常是一个电压值，这便衍生出了 **VCO** (voltage-controlled oscillator, 压控振荡器)。一般情况下，我们希望系统尽量具有好的线性性，因此通常认为理想的 VCO 就是一个完全线性的压控振荡器，其输入输出关系为：

$$
\begin{gather}
\omega_{out} = \omega_{0} + K_{VCO}\cdot V_{cont},\quad \omega_0 = \omega_{out}|_{V_{cont} = 0}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-27-00-43-00_An Introduction to Oscillators.png"/></div>

在学习 VCOs 的具体结构之前，我们先总结一下 VCO 的一些重要性能参数：
- Center frequency
- Tuning range
- Tuning linearity
- Output amplitude
- Power dissipation
- Supply and common-mode rejection
- Output signal purity (jitter and phase noise)

它们的定义和意义如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-27-00-44-19_An Introduction to Oscillators.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-27-00-44-26_An Introduction to Oscillators.png"/></div>

### 4.1 Tuning in Ring Osci.

#### (1) Basic Tuning Tech.

我们前面已经介绍过，一个 N-stage ring oscillator 的振荡频率为 $f_{osc} = \frac{1}{2NT_D}$, 因此，只要调节 每个 stage 的 delay time $T_D$，就可以实现振荡频率的调节。下图是 differential pair 作为 stage 的一个例子，其中 $M_3$ 和 $M_4$ 工作一直在 deep triode region:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-30-21-54-34_An Introduction to Oscillators.png"/></div>


输出节点的时间常数 $\tau_1$ 为：

$$
\begin{gather}
\tau_1 = R_{on3,4}C_L = \frac{C_L}{\mu_n C_{ox} \frac{W}{L} \left(V_{DD} - V_{cont} - |V_{TH3,4}|\right)}
\end{gather}
$$

直觉上容易理解 delay time $T_D$ 与 $\tau_1$ 呈正相关，在精度要求不太高时，我们可以作近似 $T_D \propto \tau_1$，于是：


$$
\begin{gather}
f_{osc} \propto \frac{1}{T_D} \approx\propto \frac{1}{\tau_1} = \frac{\mu_n C_{ox} \frac{W}{L} \left(V_{DD} - V_{cont} - |V_{TH3,4}|\right)}{C_L}
\end{gather}
$$

此时 $f_{osc}$ 与 $V_{cont}$ 呈线性关系，近似满足理想 VCO 的要求。但是上面的结构有一个比较明显的缺点，那就是输出信号的幅度会随着 $V_{cont}$ 的变化而变化：因为 $V_{out,amp}=  I_{SS}R_{on}$ (with complete switching)，$R_{on}$ 会随着 $V_{cont}$ 的变化而变化，从而导致输出幅度的变化。

为了解决这个问题，我们利用负反馈引入一个参考电压 $V_{REF}$:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-30-22-08-40_An Introduction to Oscillators.png"/></div>

注意 **<span style='color:red'> $I_{1} = I_{SS}$ if M3 = M4 = M5 </span>** 而不是 $I_{1} = 2 I_{SS}$. 这是为了保证当 $I_{SS}$ 全部流过其中一路时 (令一路 $I_D \approx 0$), 输出节点的电压约为 $V_{REF}$, 因此输出信号的上下边界分别是 $V_{DD}$ 和 $V_{REF}$, $V_{out,amp} = V_{DD} - V_{REF}$.

此时输出幅度与 $V_{cont}$ 无关，而 $V_{cont}$ 控制 $I_{SS}$，为了在 $I_{SS}$ 改变时保证 $V_{out,amp} = V_{DD} - V_{REF} = I_{SS}R_{on}$, $V_{gate}$ 会相应地发生变化，从而改变 $R_{on}$ 的值。这样就间接实现了 frequency tuning 功能，同时输出幅度也保持不变。

由于 $V_{out,amp} = V_{DD} - V_{REF} = I_{SS}R_{on}$, 此结构的输出频率为：

$$
\begin{gather}
f_{osc} \approx \propto \frac{1}{R_{on}C_L} \Longrightarrow 
f_{osc} \approx \propto \frac{I_{SS}}{(V_{DD} - V_{REF})C_L}
\end{gather}
$$

#### (2) Tuning by XCP

也可以考虑用 XCP 结构 (利用了 Positive Feedback) 来实现频率调节。

回想一下图 15.36 中的 XCP (交叉耦合对)，其小信号电阻为 $\frac{-2\,}{g_m}$，该值可通过偏置电流进行控制。将一个负电阻 $-R_N$ 与一个正电阻 $+R_P$ 并联，会得到等效值 $R = \frac{R_N R_P}{R_N - R_P} $，如果 $|-R_N | > | +R_P |$，则该值会变得更正 (相当于 $R_P$ 变大)。

下图是一个基本例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-30-23-25-32_An Introduction to Oscillators.png"/></div>

在上图，假设一开始有 $|\frac{-1\,}{g_{m3,4}}| > |R_{1,2}|$，也即 $R_{P} || \frac{-1\,}{g_{m3,4}} = \frac{R_P}{1 - g_{m3,4}R_P} > 0$ 。随着 $I_1$ 的增加 (收 $V_{cont}$ 控制)，$g_{m3,4}$ 增大，等效电阻 $R_{P} || \frac{-1\,}{g_{m3,4}} = \frac{R_P}{1 - g_{m3,4}R_P}$ 增大，使 $f_{osc}$ 降低。

与之前的思路类似，在上面的结构中，$V_{cont}$ 改变 $I_1$ 会导致 $R_{1,2}$ 上流经的电流改变，从而改变输出幅度。为了解决这个问题，我们可以在 $I_1$ 增大的同时减小 $I_{SS}$, 使 $(I_{SS} + I_1) \approx \mathrm{constant}$. 换句话说，我们希望 vary $I_11$ and $I_{SS}$ **differentially** while their sum is fixed, 这正是一个 (小信号) 差分对的特性。于是改进电路如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-30-23-41-40_An Introduction to Oscillators.png"/></div>

但如果所有的电路都由 M6 控制至 M3 和 M4 会怎样呢？由于 M1 和 M2 没有电流通过，该电路的增益会降为零，从而无法产生振荡。为了避免这种影响，可以在节点 P 与地之间连接一个较小的恒定电流源 $I_H$，从而确保 M1 和 M2 总是处于导通状态。为满足低频增益大于 2, $I_H$ 的值至少为：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-30-23-49-45_An Introduction to Oscillators.png"/></div>



在典型情况下，这种环形振荡器提供了 2:1 的调谐范围 (频率最大与最小值之比为 2:1) 和较好的线性度，并且它具有比 single-ended Vcont 更好的噪声性能。但这种结构最大的缺陷之一便是消耗了额外的 voltage headroom, 因此在 low-voltage design 中很少采用。

应当指出的是, M5 和 M6 这对晶体管并不需要完全处于饱和状态。如果漏极电压足够低，能够将这些晶体管驱动至三极管工作区，那么差分对的等效导通电流就会降低，这就需要更大的 $(V_{cont1} - V_{cont2})$ 电压来控制尾电流。实际上，这种现象会导致 VCO 敏感度降低。在实际应用中，需要进行相当仔细的仿真以确保 VCO 在所关注的频率范围内保持足够良好的线性度。

那么，在 low-voltage design 中，如何改进上面的电路呢？考虑 “current folding” 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-30-23-55-49_An Introduction to Oscillators.png"/></div>

虽然大大降低了 headroom consumption, 但控制路径中的器件会产生大量噪声，从而影响振荡频率。

#### (3) Tuning by Interpolation

另一种 tuning 的方法是利用 “interpolation” (插值) [3, 4]。如图 15.48(a) 所示，每个阶段都包含一条快速路径和一条慢速路径，这两条路径的输出相加，并且其增益 (路径的通断程度) 通过 Vcont 在相反方向上进行调整。在 Vcont 的一个极端情况下，只有快速路径处于工作状态，而慢速路径被禁用，从而产生最大振荡频率 [图 15.48(b)]。相反，在另一个极端情况下，只有慢速路径处于工作状态，而快速路径关闭，从而提供最小振荡频率 [图 15.48(c)]。如果 Vcont 位于这两个极端值之间，则每条路径部分处于工作状态，总延迟是它们延迟的加权和。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-01-19-36-11_An Introduction to Oscillators.png"/></div>

为了更好地理解插值的概念，让我们在晶体管层面实现图 15.48(a) 所示的拓扑结构。每个阶段都可以简单地实现为一个差分对，其增益由其尾电流控制。但两个输出是如何相加的呢？由于差分对中的两个晶体管提供输出电流，因此两个对的输出可以在电流域中相加。如图 15.49(a) 所示, **<span style='color:red'> 直接短接两个差分对的输出即可完成电流相加 </span>** 。例如小信号 $I_{out} = g_{m1,2}V_{in1} + g_{m3,4}V_{in2}$。因此，整个插值阶段采用了如图 15.49(b) 所示的配置，其中 $V_{cont}^+$ 和 $V_{cont}^-$ 表示方向相反的电压 (这样当一条路径导通时，另一条路径就会关闭)。 M1-M2 和 M3-M4 的输出电流在 X 和 Y 处相加，并流过 R1 和 R2 从而产生 Vout.


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-01-19-38-44_An Introduction to Oscillators.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-01-19-38-52_An Introduction to Oscillators.png"/></div>

在 Figure 15.50 的情况下，慢路径比快路径多了一个 stage, 因此 VCO 的调谐范围大约为 2:1 (f_max : f_min = 2 : 1). 对于 low supply voltage 的情况, M7-M8 的电流控制可以用图 15.47(a) 中的结构来替代。


在上面结构的基础上，可以再加入 XCP (交叉耦合对) 来进一步提高振荡器的 tuning range, 如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-01-19-53-14_An Introduction to Oscillators.png"/></div>


#### (4) Wide-Range Tuning

除了图 15.43(b) 所示的电路外，到目前为止所介绍的三种 tuning techniques 能达到的 tuning ratio (调谐比) 通常不超过 3 (仅使用一种 tech 的情况下). 在频率必须按数量级变化的应用中，可以考虑图 15.52 所示的拓扑结构。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-01-19-55-50_An Introduction to Oscillators.png"/></div>

在输入信号的驱动下，额外的 PMOS 晶体管 (M5, M6) 将每个输出节点拉至 VDD 电压，从而即使在 ISS 有较大变化的情况下 (Vcont 幅度较大) 也能形成相对稳定的输出摆幅。通常情况下，采用此结构的振荡频率可以达到 $10^4$ (10^4:1) 的 tuning ratio, 而输出幅度的变化比则小于 2:1 

#### (5) Conclusions 

通常情况下，实际应用时只使用其中一种 tuning technique 即可达到所需的性能。对于一些特殊设计，可以考虑将两种或更多的 tuning techniques 结合起来，以获得更好的性能。

### 4.2 Tuning in LC Osci.

## 5. VCO Models

### 5.1 Definition of Frequency

由公式 $\omega_{out} = \omega_{out0} + K_{VCO} V_{cont}$ 给出的定义指出了控制电压与输出频率之间的关系。这种关系是“无记忆的”，因为控制电压的变化会立即导致输出频率的变化。但从时域的角度来讲，在 Vcont 变化时, VCO 的输出信号是如何随时间变化的呢？要回答这个问题，我们必须回顾一下相位和频率的概念。

考虑正弦波 $V_0(t) = V_m \sin \phi (t) = V_m \sin (\omega_0 t)$，这里的幅角 $\phi (t)$ 被称为信号的“总相位”。在本例中，相位 $\phi (t) = \omega_0 t$ 随时间呈线性变化，其斜率等于 $\omega_0$ 。现在考虑两个不同频率的正弦波：

$$
\begin{gather}
V_1(t) = V_m \sin(\phi_1(t)) = V_m \sin (\omega_1 t),\quad V_2(t) = V_m \sin(\phi_2(t)) = V_m \sin (\omega_2 t)
\end{gather}
$$

其中 $\omega_2 > \omega_1$. 如图 15.61 所示，$\phi_2(t)$ 比 $\phi_1(t)$ 增长得更快，使 $V_2(t)$ 变化得更快。我们称 “$V_2(t)$ 积累相位的速度更快”。上述例子说明，波形变化的速度越快，波形的 (角) 频率就越高，这意味着 (角) 频率可以定义为相位随时间的变化率：

$$
\begin{gather}
\omega := \frac{\mathrm{d} \phi }{\mathrm{d} t }
\end{gather}
$$

这种定义极大地简化了“频率”这一概念，使我们能够更直观地理解频率与相位之间的关系。下图就是一个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-01-20-11-47_An Introduction to Oscillators.png"/></div>

根据这一定义，我们容易理解：如果一个波形的频率 $\omega = \omega(t)$ 已知，那么波形的相位可以表达为：

$$
\begin{gather}
\phi = \phi(t) = \phi_0 + \int \omega(t)\ \mathrm{d} t,\quad \omega_{out} = \omega_0 + K_{VCO} V_{cont}
\\
\Longrightarrow 
V_{out}(t) = V_m \sin(\phi(t)) = V_m \sin\left(\phi_0 + \omega_0 t + \int K_{VCO} V_{cont}\ \mathrm{d} t\right)
\end{gather}
$$

### 5.2 Mathematical Model

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-22-14-21_Razavi CMOS - Chapter 15. Oscillators.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-22-10-13_Razavi CMOS - Chapter 15. Oscillators.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-15-09-45_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>


