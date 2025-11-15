# The Unidentified Second-Pole in the Two-Stage Op Amp with Nulling-Miller Compensation

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 14:44 on 2025-06-22 in Beijing.

## Introduction

在前不久的运放设计 [A Basic Two-Stage Nulling-Miller Compensation Op Amp with 80 dB Gain, 50 MHz UGF and 50 V/us SR at 5pF Load (Simulated 84.35 dB, 55.75 MHz and +56.31/-45.35 V/us)](<AnalogICDesigns/202506_tsmc18rf_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.md>) 中，我们在仿真频响曲线时发现了一个 [design sheet](<AnalogICDesigns/Design Sheet for Basic Two-Stage Op Amp with Nulling-Miller Compensation.md>) 中未预测到的极点，并且它是影响 phase margin 的主要因素。这篇文章便尝试分析这个极点的来源。



## Discussion

### the contradiction

按照我们原先在文章 [Miller Compensation in Basic Two-Stage Op Amp](<AnalogIC/Miller Compensation in Basic Two-Stage Op Amp.md>) 中的推导，带有 nulling-Miller compensation 的两级运放（在中低频）应该具有三个极点和一个零点：$\omega_{p1},\ \omega_{p2},\ \omega_{p3}$ 以及 $\omega_{z}$, 通过调整 $R_z$ 的值.我们可以让 $\omega_{z}$ 和 $\omega_{p2}$ 很好地 cancel out, 使系统退化为仅有两个极点的二阶系统。同时，由于 $\omega_{p3} \gg \mathrm{UGF}$, 系统应该具有非常高的 phase margin.

但是，在频响曲线仿真结果中 (如下图)，我们发现了一个额外的极点 $\omega_{pp}$, 它出现在 $\omega_{p1}$ 和 $\omega_{p2}$ 之间，导致系统的 phase margin 主要由 $\omega_{pp}$ 决定，这与我们原先的推导相矛盾。

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-14-58-29_The Unidentified Second-Pole in the Two-Stage Op Amp with Nulling-Miller Compensation.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-15-03-40_The Unidentified Second-Pole in the Two-Stage Op Amp with Nulling-Miller Compensation.png"/></div>

图中可以看到，频响优化前后，系统在 UGF 附近都存在一个 "来源不明" 的极点 $\omega_{pp}$。频响优化之前，$\frac{\omega_{pp}}{\mathrm{UGF}} = \frac{30.6 \ \mathrm{MHz}}{36.35 \ \mathrm{MHz}} = 0.842$, 导致系统的 phase margin 低于 45° ；频响优化之后，$\frac{\omega_{pp}}{\mathrm{UGF}} = \frac{87.6 \ \mathrm{MHz}}{55.75 \ \mathrm{MHz}} = 1.571$, 使得 phase margin 回升到 64°.

### possible cause 1: omega_p3

最容易想到的原因就是 $\omega_{p3}$ 并没有我们想象的那么大，而是比所谓的 $\omega_{p2}$ 小。下面就从两个角度来看看这种说法对不对。

第一种角度是验证 dominant-pole approximation 中的假设条件 $\omega_{p1} \ll \omega_{p2} \ll \omega_{p3}$:

$$
\begin{align}
\frac{\omega_{p3}}{\omega_{p2}} 
&= \frac{\frac{1}{R_z C_c}\left(1 + \frac{C_c}{C_{L1}} + \frac{C_c}{C_{L2}}\right)}{\frac{g_{m6}}{C_{L2}}}
\\
&= \frac{C_c + C_{L2} + \frac{C_c C_{L2}}{C_{L1}}}{g_{m6}R_zc\cdot C_c}
\\
&= \frac{1}{g_{m6}R_z}\left(1 + \frac{1}{\alpha} + \frac{C_{L2}}{C_{L1}}\right)
\end{align}
$$

如果让 $R_z$ 位于 "恰好抵消零点" 和 "恰好抵消 $\omega_{p2}$" 之间，我们有：

$$
\begin{gather}
R_z \in \left(\frac{1}{g_{m6}},\ \ \frac{1}{g_{m6}} \cdot \left(1 + \frac{1}{\alpha}\right)\right) \Longrightarrow 
\frac{\omega_{p3}}{\omega_{p2}} \in \left(1 + \frac{C_{L2}}{\left(1 + \frac{1}{\alpha}\right) C_{L1}},\ \ 1 + \frac{1}{\alpha} + \frac{C_{L2}}{C_{L1}}\right)
\end{gather}
$$

其中，"恰好抵消 $\omega_{p2}$" 对应 $\frac{\omega_{p3}}{\omega_{p2}} = 1 + \frac{C_{L2}}{\left(1 + \frac{1}{\alpha}\right) C_{L1}}$. 显然，由于 $C_{L2} \gg C_{L1}$ 是成立的，即使除以了 $1 + \frac{1}{\alpha}$, 这个比值仍然比 1 大得多，也就是 $\omega_{p3} \gg \omega_{p2}$. 所以 "$\omega_{E}$ 就是 $\omega_{p3}$" 的这种说法不成立。

从第二种角度，我们不妨将仿真频率上限从 10 GHz 提高到 10 THz, 此时频响曲线仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-15-25-57_The Unidentified Second-Pole in the Two-Stage Op Amp with Nulling-Miller Compensation.png"/></div>

从这个图来看，又感觉 "$\omega_{E}$ 就是 $\omega_{p3}$" 是成立的。真是令人困惑的结果。



### possible cause 2: omega_E

To be completed...
