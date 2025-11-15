# Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 CP-PLL ~ 16.5 Applications

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 15:31 on 2025-08-08 in Lincang.

参考教材：[*Design of Analog CMOS Integrated Circuits (Behzad Razavi) (2nd edition, 2017)*](https://www.zhihu.com/question/452068235/answer/95164892409)
阅读本文需要部分数电知识基础，详见文章：[Pre-requisite Digital Electronics Knowledge for PLL](<AnalogIC/Prerequisite Digital Electronics Knowledge for PLL.md>)


## Introduction

虽然 type-I PLL 在分立元件形式上已得到广泛应用，但其缺陷限制了其在高性能集成电路中的使用。除了 $\zeta$、$\omega_{LPF}$ 和相位误差之间的 trade-off 外, type-I PLL 还存在一个重要缺陷：锁定范围十分有限 (limited acquisition range, namely, limited lock range).

## 1. Problem of Lock Acquisition

假设当一个锁相环电路开启时，其振荡器的工作频率与输入频率相差甚远，即环路未锁定。那么在何种条件下环路会“获得”锁定呢？环路从未锁定状态转变为锁定状态的过程是一个典型的非线性过程，对于 type-I PLL, 我们指出其 “获取范围” (acquisition range) 与 $\omega_{LPF}$ 的值大致相同。也就是说，在 PLL 开启的瞬间，只有当 $|\omega_{in} - \omega_{out}| \leqslant \omega_{LPF}$ 时，该循环才会锁定。

需要注意的是, acquisition range 和 tracking range 是两种不同的概念。前者是指锁相环 "能够从未锁定状态 (开启瞬间) 转变为锁定状态" 的输出角频率范围，即 $\omega_{0} \pm (|\Delta \omega|_{t=0})_{\max}$ 的范围；而后者是指锁定状态下，随着输入角频率缓慢变化，系统能够正常跟随的输出角频率范围。并且可以注意到, acquisition range 一定是 tracking range 的子集。

另外，即便输入频率的值是非常精确的，我们也还是需要较大的 acquisition range, 因为压控振荡器 (VCO) 的中心频率 $\omega_0$ 可能会因工艺和温度因素而有很大变化。在大多数实际应用中, type-I PLL 的 acquisition range 实在是太小，不能满足要求。

为了提高捕获范围，现代锁相环电路除了进行 phase detection 外，还增加了 frequency detection. 这种技术被称为“辅助捕获” (aided acquisition)，如图 16.21 所示。其原理是通过频率检测器 (FD, frequency detector) 将 $\omega_{in}$ 和 $\omega_{out}$ 进行比较，生成与 $(\omega_{in} - \omega_{in})$ 成正比的直流分量 $V_{LPF2}$，并将结果应用于 VCO 的负反馈回路中。电路刚启动时，FD 使 $\omega_{out}$ 向 $\omega_{in}$ 靠拢，而 PD 输出则保持“静默”。当 $|\omega_{in} - \omega_{in}|$ 达到足够小的值时，锁相环开始接管并实现锁定，这种方案通常能将捕获范围 (acquisition range) 扩大到 VCO 的整个调谐范围 (tunning range)。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-16-04-29_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

## 2. PFD (Phase Frequency Detector)

将 PD 和 FD 合并即得到鉴频鉴相器 (PFD, Phase/Frequency Detector)，如图 16.22 所示。该电路通常采用一系列逻辑门来创建三个稳态，并对两个输入的上升（或下降）沿做出响应。如果初始时 QA = QB = 0，那么 A 的上升沿会导致 QA = 1，QB = 0. 电路保持此状态，直到 B 变为高电平，此时 QA 会回到低电平。换句话说，如果 A 的上升沿之后紧接着 B 的上升沿，那么 QA 会变高然后回到低电平。对于 B 输入，其行为类似。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-16-08-41_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

在图 16.22(a) 中，两个输入的频率相等，但 A 超前 B。输出 QA 继续产生宽度与 φA - φB 成比例的脉冲，而 QB 保持为零。在图 16.22(b) 中，A 的频率高于 B，QA 产生脉冲，而 QB 不产生脉冲。由对称性可知，如果 A 滞后于 B 或频率低于 B，则 QB 产生脉冲，而 QA 保持静默。因此，QA 和 QB 的直流分量提供了关于 φA - φB 或 ωA - ωB 的信息。输出 QA 和 QB 分别称为 "UP" (A > B) 和 "DOWN" (A < B) 脉冲。

图 16.22 中的 PFD 可以有多种实现形式，图 16.24(a) 就展示了其中较为简单的一种：由两个 resettable D latch (flip-flop) 和一个 AND 门组成，其中 D 触发器的输入端 "D" 连接到逻辑 "1" (VDD).

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-01-43-10_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>


The inputs of interest, A and B, serve as the clocks of the flipflops. If QA = QB = 0 and A goes high, QA rises. If this event is followed by a rising transition on B, QB goes high and the AND gate resets both flipflops. In other words, QA and QB are simultaneously high for a short time, but the difference between their average values still represents the input phase or frequency difference correctly.

上图 Figure 16.24 (b) 所示的 resettable D latch (flip-flop), 其实是由两个 SR latch 构成：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-02-42-33_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

其工作原理如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-02-43-33_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

当两时钟信号频率相等 (仅存在相位差时)，定义 $V_{out} = V_{Q_{A}} - V_{Q_{B}}$，则此 PFD 的输入输出特性为：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-02-51-52_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

传统的 PFD 会将输出端 QA/QB 直接连到低通滤波器进行处理 (有的还会利用运放做适当放大)，以获得与输入相位差成正比的 (近似) 直流电压。这样的 PLL 基本上都能够 locking, 但是其环路增益 $K_{PFD}K_{VCO}$ 始终为有限值，无法避免相位上的系统误差 (即使这个误差可以很小)。我们在下一小节中介绍的 PFD with Charge Pump 便能在理论层面上解决这个问题 (因为其环路增益无穷大)。


需要注意的是，由于逻辑门存在传输延迟，即使两个输入时钟的频率和相位都完全相等，PFD 的 QA/QB 输出端仍会存在窄脉冲，下面是一个例子：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-02-48-49_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

$$
\begin{gather}
\Delta T \approx 5 \Delta t_{gate}
\end{gather}
$$

## 3. CP (Charge Pump)

要获得无穷大的环路增益，最直接的方法就是在环路中插入积分器，例如在 PFD 之后插入一个 CP (Charge Pump), 如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-13-38-40_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

上图 CP 需要满足 $I_{1} = I_{2}$，这样才能使 QA = QB (差分输出为零) 时 Vout 保持不变。

## 4. Charge Pump PLL (type-II PLL)

### 4.1 Basic CP-PLL

利用刚刚提到的 CP 可以构建下图所示的 basic charge-pump PLL (CP-PLL):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-14-28-07_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

PFD + CP + 电容 $C_{P}$ 的组合会在小信号 (动态) 传递函数中产生位于原点的二阶极点 (推导过程见下一小节)，因此被称为 type-II PLL.

### 4.2 Dynamics of CP-PLL

现在来考察 CP-PLL (type-II PLL) 的 dynamic performance (动态性能)，也就是锁相环已经 locking 之后，面对小信号输入 (phase/frequency) 时整个系统的响应情况。

为了更好地理解 PFD + CP 与 LPF 直接的配合作用 (连接关系)，我们完全可以将 PFD + CP 看作一个输出为电流的模块，然后再将 LPF 看作一个阻抗模块，如下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-00-13-33_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

总结下来就是：
$$
\begin{gather}
H_{PFD/CP}(s) = \frac{I_{out}}{\Phi_{in}}(s) = \frac{I_P}{2\pi},\quad 
H_{LPF}(s) = \frac{V_{out}}{I_{out}}(s) = Z_{LPF}(s)
\end{gather}
$$

由此可以轻松地对此锁相环的各个模块进行线性建模，并推导其传递函数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-01-17-19_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>



## 5. Nonidealities in PLL

上面对 PLL 的理论推导都有一定的理想性假设，本节便来讨论实际应用中可能出现的非理想因素。


### 5.1 PFD Dead Zone

我们知道，一个脉冲信号在驱动较大电容时会有较长的上升/下降时间。相应地，当系统位于锁定状态时，如果输入相位差发生微小变化， PFD 输出端 QA/QB 产生的窄脉冲信号很可能无法在这么窄的脉冲宽度内上升/下降到规定值，于是后续 CP 的开关无法正常通断，导致 CP 没有充放电电流，压控振荡器的控制电压没有变化，也就不能有效地调整输出相位，这样的现象称为 "相位死区 (Dead Zone)"。 Dead zone 会使系统不能对微小相位差作出响应，因此严重影响了锁相环的抖动性能 (jitter).

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-01-24-56_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-01-25-05_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

解决死区问题最直接的方法就是时刻保持 PFD 输出端 QA/QB 的脉冲宽度大于等于 CP 的开关时间 (即使是 $\Delta \phi = 0$ 时)，也就是我们在 **2. PFD (Phase Frequency Detector)** 一节中提到的宽度约为 $5 \Delta t_{gate}$ 的窄脉冲。只要让此窄脉冲的宽度大于 QA/QB 的上升/下降时间，就能有效避免死区的影响。

### 5.2 CP Nonidealities

考虑下图所示的 charge pump 结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-19-25-39_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

QB 驱动 M3 (NMOS) 是高开低关没错 (高电平开，低电平关)，但是 QA 驱动 M4 (PMOS) 却需要低电平才能开，因此需要通过 NOT gate (inverter) 将 QA 反相。这种操作，以及 charge pump 本身的特性决定了 CP 会存在很多非理想效应，最典型便是下面三条：


- **(1) Delay difference between $\overline{\mathrm{Q_A}}$ and \mathrm{Q_B}.** x
- **(2) mismatch between UP and DOWN currents.**
- **(3) the finite capacitance seen at the drains of M1 and M2.**

下面就来一一讨论这些非理想效应对锁相环系统的影响。

**(1) Delay difference between $\overline{\mathrm{Q_A}}$ and \mathrm{Q_B}.** 

如 Figure 16.44 (b) 所示，由于 NOT gate 的存在，$\overline{\mathrm{Q_A}}$ 在时域上落后于 $\mathrm{Q_B}$ 一个 NOT 门延迟时间 $T_D$. 这会导致即便在锁定状态下，振荡器的控制电压 $V_{cont}$ 也会出现周期性的 ripple (可以理解为毛刺)，影响锁相环的抖动性能 (jitter performance). 

为了缓解这个问题，可以在 QB 的输出端添加一个或多个互补型传输门，也即 complementary transmission gate, 又称 pass gate. 并且 pass gate 中 gate of PMOS 接 GND, gate of NMOS 接 VDD (使传输门恒开启). 关于 CMOS 传输门的具体原理，详见这篇文章 [BuzzTech > CMOS Transmission Gate (Pass Gates)](https://buzztech.in/cmos-transmission-gate/)

**(2) mismatch between UP and DOWN currents.**


受 PVT 影响, M3 和 M4 在开启时的漏级电流 (也即 UP 和 DOWN 电流) 不可能严格相等，这就导致在$ M3 和 M4 都打开时，仍有部分电流流入/流出后级电容 (LPF)。如下图所示，锁相环为了保证锁定时的 $V_{cont}$ 稳定，会被迫调整 QA/QB 间的相位差，使最终锁定时相位差非零，并且 $V_{cont}$ 出现周期性 ripple.


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-19-53-45_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

因此 charge pump 设计时需要充分考虑 PVT 的影响，并进行较为严格的前仿/后仿验证，否则会严重拉低 PLL 性能。

**(3) the finite capacitance seen at the drains of M1 and M2.**

如 Figure 14.46 所示，假设一开始 S1 和 S2 处于关闭状态，由于 M1/M2 一直处于正常 biasing 状态 (相当于已打开)，节点 X 被拉低至 GND, 而 Y 则被拉高至 VDD 。

在某一瞬间 S1 和 S2 都开启，$V_X$ 上升且 $V_Y$ 下降，直至 $V_X \approx V_Y \approx V_{cont}$。如果相位误差为零且 $I_{D1}$ = $|I_{D2}|$，从开关开启到 $V_X$ 和 $V_Y$ 达到 $V_{cont}$ 的这段时间内，$V_{cont}$ 是否能保持不变？
我们指出，即便 $C_X = C_Y$，$V_X$ 的变化也不一定等于 $V_Y$ 的变化。例如，如果 $V_{cont}$ 相对较高则 $V_X$ 变化幅度较大，而 $V_Y$ 变化幅度较小。因此，这两者变化之间的差异必须由 CP 的输出节点 $V_{cont}$ 提供，从而导致 $V_{cont}$ 出现周期性 ripple.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-20-00-27_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

上面这样的现象称为 "charge-sharing phenomenon", 可以通过 "bootstrapping" 技术来解决，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-20-11-18_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

在 S1/S2 断开时, S3/S4 闭合，利用 unit buffer 将 Vx 和 Vy 拉到 Vcont 附近。而当 S1/S2 开启时, S3/S4 断开以避免引入更大的 drain capacitances.



### 5.3 Jitter in PLL

除输入时钟自带的 jitter 外，PLL 的 jitter 主要来源于 VCO, 可利用下面这种方式对其 jitter 作简单的线性建模：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-21-09-32_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

容易推导得到 $\frac{\Phi_{out}}{\Phi_{VCO}}(s)$：

$$
\begin{gather}
\frac{\Phi_{out}}{\Phi_{VCO}}(s) = \frac{s^2}{s^2 + 2\zeta \omega_n s + \omega_n^2},\quad \omega_n = \sqrt{\frac{I_P K_{VCO}}{2\pi C_P}},\ \zeta = \frac{R_P}{2}\sqrt{\frac{I_P C_P K_{VCO}}{2\pi}}
\end{gather}
$$

这是一个高通型传递函数，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-21-12-58_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

## 6. Delayed-Locked Loop (DLL)

与 PLL 相比, DLL (Delayed-Locked Loop) 是用 "压控延迟线 (voltage-controlled delay line, VCDL)" 替换了 VCO, 以实现低抖动且固定频率的时钟对齐。 DLL 最典型的应用便是 "多相位时钟信号生成"，例如将一路原有的时钟信号通过 DLL (PDF/CP/LPF + Delay Line) 输出为两两相位差为 $\frac{\pi}{2}$ 的四路时钟信号。

下面是几种典型 DLL 结构示例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-21-34-42_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 CP-PLL ~ 16.5 Applications.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-21-35-17_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 CP-PLL ~ 16.5 Applications.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-21-35-40_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 CP-PLL ~ 16.5 Applications.png"/></div>

关于 DLL 的设计实例，可以看下面这篇论文 [[3]](https://ieeexplore.ieee.org/document/5947)：
>[3] M. G. Johnson and E. L. Hudson, “A variable delay line PLL for CPU-coprocessor synchronization,” IEEE J. Solid-State Circuits, vol. 23, no. 5, pp. 1218–1223, Oct. 1988, [doi: 10.1109/4.5947](https://ieeexplore.ieee.org/document/5947).



与 PLL 相比，由于不存在 VCO 这一模块, DLL 的抖动一般要小得多。但相应地，不存在 VCO 就意味着不能产生输入频率之外的时钟信号，无法用于频率合成/倍频/分频。

## 7. Applications of PLL

### 7.1 Frequency Multiplication/Division/Synthesis

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-21-45-17_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 CP-PLL ~ 16.5 Applications.png"/></div>

### 7.2 Skew Reduction

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-21-46-09_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 CP-PLL ~ 16.5 Applications.png"/></div>

### 7.3 Jitter Reduction

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-21-47-26_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 CP-PLL ~ 16.5 Applications.png"/></div>

## 8. Summary of Type-II PLL

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-01-17-06_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-01-17-19_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-01-17-29_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

本文部分公式推导由 MATLAB 辅助：

``` matlab
%% Type-II PLL (Rp + Cp + Cpp)
syms A Phi_out Phi_in Delta_phi s omega_0 omega_in phi_0 Delta_omega omega_LPF t x
syms I_P C_P C_2 K_VCO R_P
LPF = simplifyFraction(MyParallel(R_P + 1/(s*C_P), 1/(s*C_2)))
H_OL = simplifyFraction(I_P/(2*pi) * LPF * K_VCO/s)
H_CL = simplifyFraction(H_OL/(1 + H_OL))
```

## References

- [1] R. E. Best, Phase-Locked Loops, 2nd ed. (New York: McGraw-Hill, 1993).
- [2] F. M. Gardner, Phaselock Techniques, 2nd ed. (New York: John Wiley & Sons, 1979).
- [[3]](https://ieeexplore.ieee.org/document/5947) M. G. Johnson and E. L. Hudson, “A Variable Delay Line PLL for CPU-Coprocessor Synchronization,” IEEE
 J. of Solid-State Circuits, vol. 23, pp. 1218–1223, October 1988.
- [[4]](https://u.dianyuan.com/bbs/u/29/1116306785.pdf) F. M. Gardner, “Charge-Pump Phase-Locked Loops,” IEEE Trans. Comm., vol. COM-28, pp. 1849–1858,
 November 1980.
- [5] F. Herzel and B. Razavi, “A Study of Oscillator Jitter Due to Supply and Substrate Noise,” IEEE Transactions
 on Circuits and Systems, Part II, vol. 46, pp. 56–62, January 1999.
- [6] W. F. Egan, Frequency Synthesis by Phase Lock (New York: John Wiley & Sons, 1981).
- [7] J. A. Crawford, Frequency Synthesizer Design Handbook (Boston: Artech House, 1994).
