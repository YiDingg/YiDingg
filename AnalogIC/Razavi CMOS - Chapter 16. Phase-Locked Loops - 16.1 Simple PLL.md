# Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL

> [!Note|style:callout|label:Infor]
> Initially published at 22:55 on 2025-08-07 in Lincang.

参考教材：[*Design of Analog CMOS Integrated Circuits (Behzad Razavi) (2nd edition, 2015)*](https://www.zhihu.com/question/452068235/answer/95164892409)


## Introduction

锁相环 (PLL, Phase-Locked Loop) 是一种针对相位 (Phase) 的负反馈系统，它将输出相位与输入相位进行比较，进而将输出相位 “锁定到” 输入相位 (可理解为 “跟随”)。相位锁定的概念于 20 世纪 30 年代被提出，并迅速在电子学和通信领域得到广泛应用。尽管自那时起基本的相位锁定环路基本保持不变，但其在不同技术中的实现方式以及用于不同应用的情况仍不断给设计者带来挑战。

本文，我们的目标是为更严密/进阶的工作奠定基础：从一个简单的 PLL 架构开始，研究如何实现相位锁定，并分析 PLL 在时间和频率和相位域的行为。



## 1. Phase Detector (PD)

输入输出相位之间的比较是由一个 “phase comparator” 或 “phase detector” (PD, 鉴相器) 来完成的。我们先给出鉴相器在理论上的定义，再来研究最简单的 phase detector —— XOR Gate.

相位检测器：其输出电压的平均值 $\overline{V_{out}}$ 与该电路两个输入端之间的相位差 $\Delta \phi$ 成正比 (如图 16.1 所示)。在理想情况下，$\overline{V_{out}}$ 与 $\Delta \phi$ 之间呈正比例关系，当 $\Delta \phi$ 为 0 时会穿过原点。这种线性关系 (正比例关系) 被称为相位检测器的“增益”，该直线的斜率 $K_{PD}$ 以 V/rad 为单位。


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-22-54-52_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>

最简单的 phase detector 就是 XOR gate (异或门)，如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-23-10-46_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>

需要注意的是，异或门仅在 $\Delta \phi \in (0,\ \pi)$ 时满足理想性，但不能在整个 $(-\pi, \pi)$ 区间上视为理想鉴相器。下面这个例子解释了原因：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-23-13-30_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>


## 2. Simple PLL Topology 

### 2.1 how to achieve phase lock?

为了实现相位锁定，我们先来考虑这样一个问题：如何使压控振荡器 (VCO) 的输出相位与参考时钟 (输入信号) 的相位保持一致？

如图 16.4 (a) 所示，$V_{out}$ 的上升沿相对于 $V_{CK}$ “偏移” 了 $\Delta t$ 秒，我们希望消除这种误差。假设 VCO 有一个单一的控制输入 $V_{cont}$，我们注意到要改变相位，就必须改变频率，并且得到输出相位 $\phi_{out} = \int (\omega_0 + K_{VCO}V_{cont})\mathrm{d} t$。例如图 16.4 (b) 所示，当 $t = t_1$ 时 VCO 频率被提升到一个更高的值。然后电路会更快地累积相位，逐渐减少相位误差。在 $t = t_2$ 时，相位误差降为零，如果 $V_{cont}$ 返回到其初始值，$V_{VCO}$ 和 $V_{CK}$ 将保持对齐。这个例子告诉我们，只有通过（暂时的）频率变化才能实现相位对齐。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-23-18-27_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>

Figure 16.4 (a) (b) 展示了时域上的相位对齐过程，而 Figure 16.4 (c) (d) 则从相位域 (phase domain) 的角度展示了整个对齐过程。


### 2.2 Simple PLL Structure


最基本的 PLL 结构如 Figure 16.5 (b) 所示，包含一个鉴相器 (PD)、一个低通滤波器 (LPF) 和一个压控振荡器 (VCO)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-23-22-22_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>

为什么说这样的结构能实现相位锁定 (phase lock) 呢？上图已经定性分析过了，我们现在便来做理论推导，看看这个结构是否真的能实现相位锁定。

设输入为理想余弦信号 $V_{in} = \cos(\omega_{in} t)$，则有 $\phi_{in} = \omega_{in} t$，定义相位差 $\Delta \phi = \phi_{out} - \phi_{in}$ (也即 $\phi_{out} = \phi_{in} + \Delta \phi$)。

再假设 LPF 是截止频率极低的理想低通滤波器，输出的是 $V_{PD}$ 的平均值，则有 $V_{cont} = V_{LPF} = \overline{V_{PD}} = K_{PD} \Delta \phi$，此时输出电压 $V_{out}$ 可以写为：

$$
\begin{gather}
V_{out} = \cos \left(\varphi_0 + \omega_0 t + \int K_{VCO}V_{cont}\ \mathrm{d}t \right) = \cos \left(\varphi_0 + \omega_0 t + \int K_{VCO}K_{PD} \Delta \phi\ \mathrm{d}t \right)
\\
\Longrightarrow 
\phi_{out} = \varphi_0 + \omega_0 t + K_{VCO}K_{PD} \int (\phi_{out} - \phi_{in})\ \mathrm{d}t
\end{gather}
$$

上式默认了输入电压的初相位为 0, 输出电压的初相位为 $\varphi_0$, 且 $\phi_{in} = \omega_{in}t$ 是已知的，求解这个微分方程即可得到 $\phi_{out}$ 的时域表达式。为求解方程，我们记 $A = K_{VCO}K_{PD}$, 然后用拉普拉斯变换进行求解：

$$
\begin{gather}
\Phi_{out}(s) = \frac{\varphi_0}{s} + \frac{\omega_0}{s^2} + \frac{A}{s}\left[\Phi_{out}(s) - \frac{\omega_{in}}{s^2}\right]
\\
\Longrightarrow 
\Phi_{out}(s) = \frac{\varphi_0 s^2 + \omega_0 s - A \omega_{in}}{s^2 (s - A)}
\\
\phi_{out}(t) = \omega_{in} t - \frac{\omega_{0} - \omega_{in}}{A} + \left(\frac{\omega_{0} - \omega_{in}}{A} + \varphi_0\right) \cdot e^{At}
\\
\Delta \phi(t) = \phi_{out}(t) - \phi_{in}(t) = \frac{\omega_{in} - \omega_{0}}{A} + \left(\frac{\omega_{0} - \omega_{in}}{A} + \varphi_0\right) \cdot e^{At}
\end{gather}
$$

其中 $\omega_0 = \omega_{VCO}|_{V_{cont} = 0}$, 也即 $V_{cont} = 0$ 使，压控振荡器的输出角频率。从上式，我们可以看出以下几点：
- (1) 要想实现相位锁定 (phase lock)，**前馈增益 $A = K_{VCO}K_{PD}$ 必须小于 0** (注意我们对 $\Delta \phi(t)$ 的定义), 这可以通过合理连接 PD 的正负输入端口来实现
- (2) $\Delta \phi(t)$ 的第一项 **$\frac{\omega_{in} - \omega_{0}}{A}$ 是固有相位误差 (系统误差)**，可通过增大 前馈增益 $A$ 降低误差 (在 Simple PLL 中其实也就是环路增益, 因为反馈系数为 1)
- (3) 系统的 **锁定时间 (locking time) 正比于时间常数 $\tau = \frac{1}{|A|}$**, 这表明增益 $A$ 越大，锁定时间越低，相位锁定越快，系统性能越好

由于 $A < 0$, 不妨将相位差 $\Delta \phi(t)$ 重写为下面的形式：

$$
\begin{gather}
\Delta \phi(t) = \phi_{out}(t) - \phi_{in}(t) = \frac{\omega_{0} - \omega_{in}}{|A|} + \left(\frac{\omega_{0} - \omega_{in}}{|A|} + \varphi_0\right) \cdot e^{- |A|t},\quad |A| = |K_{VCO}K_{PD}|
\end{gather}
$$

上式会更直观一些。

值得一提的是，如果将鉴相器 (PD, phase detector) 换为鉴频器 (FD, frequency detector), 系统便不能实现相位锁定的功能，具体原因如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-23-51-37_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>

### 2.3 Small Transients in Locked Condition

现在，假设系统在理想输入信号下已经达到锁定状态，我们来研究输入信号上的小抖动/变化 ($\Delta \phi$ 或 $\Delta \omega$) 对系统造成的影响。

将系统相位误差 $\frac{\omega_{0} - \omega_{in}}{|A|}$ 记作 $\phi_0$, 假设输入相位有一个向上的小阶跃：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-23-55-19_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-23-55-53_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-23-58-48_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>

然后，我们再来考察当输入频率发生微小变化时，输出相位的变化情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-00-01-02_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>

当然，实际生活中所用的高阶锁相环并没有这么 "smooth" 的锁定过程 (因为这样通常很慢)，下面是一个例子：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-00-02-12_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>

根据上面的讨论，我们可以得出结论：锁相环是一种 “动态” 系统，其响应取决于输入和输出 (在整个时域上) 的过去值。这是意料之中的，因为低通滤波器 (LPF) 和压控振荡器 (VCO) 会在环路传递函数中引入极点 (通常还有零点)。

此外，我们注意到，只要输入和输出始终保持完全周期性，即 $\phi_{in} = \omega_{in} t$ 且 $\phi_{out} = \omega_{in}t + \phi_0$，环路就会处于稳态，不会出现瞬态现象。因此，锁相环只对输入或输出的多余相位的变化作出响应。

## 3. Dynamics of Simple PLL

### 3.1 Transfer Function of PLL

通过上一节对 Simple PLL 的分析，现在我们可以通过 s 域 (拉普拉斯变换) 来更严谨地分析其瞬态行为 (时域响应)。并且，与放大器中的传递函数 $H(s) = \frac{V_{out}(s)}{V_{in}(s)}$ 类似，锁相环也有传递函数的概念，只不过它是由相位量来定义的：

$$
\begin{gather}
H(s) := \frac{\Phi_{out}(s)}{\Phi_{in}(s)}
\end{gather}
$$

传递函数 $H(s) = \frac{\Phi_{out}(s)}{\Phi_{in}(s)}$ 能直接或间接地揭示出系统面对不同输入变化的瞬态响应过程，是考察锁相环动态性能的关键物理量。

我们在 **2.2 Simple PLL Structure** 一节中已经推导过了 $\Phi_{out}(s)$ 和 $\phi_{out}(t)$, 一个自然的问题就是能否沿用当时的假设来推导传递函数呢？其实当时的设定并不完全可行，因为我们假设了 LPF 足够理想 (能直接输出 $V_{PD}$ 的平均值)，这样的 LPF 的是一个典型的非线性系统，自然就不能做拉普拉斯变换。也就是说，像下面这样的 LPF, 其拉普拉斯变换结果不存在：

$$
\begin{align}
\mathrm{time\ domain:} &\quad V_{out}(t) = \frac{1}{t} \int_0^t V_{in}(\tau)\ \mathrm{d}\tau
\\
\int_0^t f(\tau) \ \mathrm{d}\tau \longmapsto \frac{L(s)}{s} 
&\Longrightarrow 
L_1(s) = \mathscr{L}\left \{ \int_0^t V_{in}(\tau)\ \mathrm{d}\tau \right \} = \frac{L_{V_{in}}(s)}{s}
\\
\frac{f(t)}{t} \longmapsto \int_{s}^{\infty}L(\xi)\ \mathrm{d}\xi
&\Longrightarrow
L_2(s) = \mathscr{L}\left\{ \frac{1}{t} \right\} = \int_{s}^{\infty} \mathscr{L}\{1\} \ \mathrm{d}\xi = \int_{s}^{\infty} \frac{1}{\xi} \ \mathrm{d}\xi = \ln \frac{\infty}{s}
\\
V_{LPF}(s) &= \frac{1}{2\pi j} \cdot L_1(s) * L_2(s)
\end{align}
$$

显然，由于 $L_2(s)$ 发散，卷积结果也不存在。所以，要想求出锁相环系统的传递函数，我们需要对各个模块做合理的线性化建模。

### 3.2 Large-Signal Modeling

假设系统已经达到稳定状态，我们需要将初始相位差 $\varphi_0$ 替换为固有相位误差 $\phi_0$，先对系统的 large-signal 行为进行建模：

**(1) PD (Phase Detector):** 实际的输入输出都为电压信号，但是理论分析时，需要将其视为输入为相位而输出为电压的系统。将 PD 近似为输出为理想直流量的模块，则有：

$$
\begin{gather}
V_{out}(t) = K_{PD} \Delta \phi(t) \Longrightarrow  H_{PD}(s) = \frac{V_{out}(s)}{\Delta \Phi_{s}} = K_{PD} 
\end{gather}
$$

**(2) LPF (Low Pass Filter):** 实际电路中一般都会使用高阶 LPF 以提高系统性能，在这里，我们以最简单的一阶 LPF 为例进行分析：

$$
\begin{gather}
H_{LPF}(s) = \frac{V_{out}(s)}{V_{in}(s)} = \frac{1}{1 + \frac{s}{\omega_{LPF}}} 
\end{gather}
$$

**(3) VCO (Voltage Controlled Oscillator):** 在理论建模时，VCO 输入电压信号，输出相位信号。

$$
\begin{gather}
\phi_{out}(t) = \phi_0 + \omega_0 t + K_{VCO} \int_0^t V_{in}(\tau)\ \mathrm{d}\tau 
\\
\Phi_{out}(s) = \frac{\phi_0}{s} + \frac{\omega_0}{s^2} + \frac{K_{VCO}}{s} V_{in}(s)
\\
\Longrightarrow 
H_{VCO}(s) = \frac{\Phi_{out}(s)}{V_{in}(s)} = \mathrm{NaN}
\end{gather}
$$

Large-Signal 下无法对 VCO 建模，因此我们需要转向 Small-Signal 建模。

### 3.3 Small-Signal Modeling

假设系统已经达到锁定状态，在小信号下的行为可以用线性模型来描述，我们可以对各个模块进行小信号建模。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-15-24-18_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-15-26-03_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-15-26-39_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>

上述模型中，环路增益 $H_{open}(s)\times F(s) = H_{open}(s)$ 在原点处有一阶极点，这样的锁相环系统称为 "第一类锁相环" (Type I).

## 4. Summary of Type-I PLL

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-00-37-51_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.png"/></div>

本文部分公式推导由 MATLAB 辅助：

``` matlab
%% Razavi CMOS Chapter 16. PLL

%% 16.1.2 Basic PLL Topology
syms A Phi_out Phi_in Delta_phi s omega_0 omega_in phi_0 Delta_omega
% 第一种: Delta_phi = phi_out - phi_in, Delta_omega = omega_0 - omega_in
Phi_out = ( phi_0/s + omega_0/s^2 - A*omega_in/s^3 ) / ( 1 - A/s );
Phi_out = simplifyFraction(Phi_out)
phi_out = ilaplace(Phi_out);
phi_out = subs(phi_out, omega_0 - omega_in, Delta_omega)

% 第二种: Delta_phi = phi_in - phi_out, Delta_omega = omega_in - omega_0
Phi_out = ( phi_0/s + omega_0/s^2 + A*omega_in/s^3 ) / ( 1 + A/s );
Phi_out = simplifyFraction(Phi_out)
phi_out = ilaplace(Phi_out);
phi_out = subs(phi_out, omega_in - omega_0, Delta_omega)

%% 16.1.3 Dynamics of Simple PLL
syms A Phi_out Phi_in Delta_phi s omega_0 omega_in phi_0 Delta_omega omega_LPF t x
H_OL = A/(s*(1 + s/omega_LPF))
H_CL = simplifyFraction(H_OL / (1 + H_OL))
Phi_out = H_CL * omega_in/s^2
phi_out = simplify(ilaplace(Phi_out))
%fplot(phi_out, [-5 5])
%omega = expand(phi_out/t)

% 推导传递函数 (假设 LPF 理想，直接滤出直流，也即 = )
syms A Phi_out Phi_in Delta_phi s omega_0 omega_in phi_0 Delta_omega omega_LPF t x
eq = Phi_out == phi_0/s + omega_0/s^2 + A/s*(Phi_out - Phi_in)
solve(eq, Phi_out)
```
