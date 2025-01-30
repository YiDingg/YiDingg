# [Razavi CMOS] MOSFET's Terminal Resistance

> [!Note|style:callout|label:Infor]
Initially published at 17:55 on 2025-01-29 in Lincang.

在《模拟 CMOS 集成电路设计》的 single stage amplifier 中，我们常常使用 $A_v = -G_m R_{out}$ 来计算单极放大器的增益，其中 $R_{out}$ 是输出电阻，$G_m$ 是广义跨导。本文讨论了小信号模型中 MOSFET 的三种“端口电阻”，即从某个端口看入的电阻大小，为快速计算 $R_{out}$ 打下基础 (by inspection)。

后文默认 $\lambda \ne 0, \gamma \ne 0$，也即考虑 channel-length modulation 和 body effect ；同时默认使用 NMOS (PMOS 的结果是类似的)。



## Drain Resistance

Drain resistance, namely $R_{\mathrm{drain}}$, is the resistance seen at the drain terminal of a MOSFET. 考虑下图所示的电路模型：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-29-18-56-55_[Razavi CMOS] MOSFET's Terminal Resistance.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-29-18-45-38_[Razavi CMOS] MOSFET's Terminal Resistance.png"/></div> -->

其中小信号模型是在保持 $V_G$ 和 $V_{S'}$ 不变的情况下得到的, 因此 gate 和 source 在 small-signal 下与 ac ground 连接。

之所以不在 drain 端口加一电阻 $R_D$, 是因为无论对 drain or source，$R_D$ 都可在此基础上通过串联考虑进去。但 $R_S$ 必须留下，因为 $R_S$ 的存在会使 $g_{mb}$ 和 $r_{O}$ 对结果产生影响。因此，略去 $R_D$ 但保留 $R_S$ 是最具有普适性的选择。

下面在小信号模型中，求出 $\displaystyle R_{\mathrm{drain}} = \frac{V_x}{I_x}$。
$$
\begin{gather}
\begin{cases}
V_s = I_x R_S, V_g = V_b = 0 \\
V_{gs} = -I_x R_S \\
V_{bs} = -I_x R_S
\end{cases}
\Longrightarrow 
I_x = (g_m + g_{mb}) (-I_x R_S) + \frac{V_x - I_x R_S}{r_O} \\
(1 + g_m R_S + g_{mb}R_S + \frac{R_S}{r_O}) \ I_x = \frac{1}{r_O} V_x\\
R_S\, (\frac{1}{R_S} + g_m + g_{mb} + \frac{1}{r_O}) \ I_x = \frac{1}{r_O} V_x
\end{gather}
$$

$$
\begin{align}
\Longrightarrow 
R_{\mathrm{drain}}
&= \frac{V_x}{I_x}\\
&= R_S \, r_O\, (\frac{1}{R_S} + g_m + g_{mb} + \frac{1}{r_O}) \\
&= R_S + r_O + (g_m + g_{mb})\,R_S\,r_O
\\\Longrightarrow  R_{\mathrm{drain}} & = \frac{R_S}{R_S \parallel \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O} \cdot r_O
\end{align}
$$

为了得到 $R_S = 0$ 时的 $R_{\mathrm{drain}}$ (也即去掉 $R_S$)，只需令 $\lim_{R_S = 0}$，于是：
$$
\begin{gather}
\lim_{R_S = 0} \frac{R_S}{R_S \parallel \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O} = 1 \Longrightarrow 
\lim_{R_S = 0} R_{\mathrm{drain}} = r_O
\end{gather}
$$

这也验证了我们之前说的，$R_S$ 会影响 channel-length modulation 和 body effect ，从而耦合在最后的结果中，而不能像 $R_D$ 一样单纯地当作串联来处理。

## Source Resistance

类似地，为求 source resistance ， 我们考虑如下模型：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-29-18-46-00_[Razavi CMOS] MOSFET's Terminal Resistance.png"/></div>

只需注意到 $V_g = V_b = V_d = 0$，indicating that $g_m$ 和 $g_{mb}$ 经过的电流“受控与其两端的电势”，这等价于它们可以等效为纯电导（或电阻），由此得到：

$$
\begin{gather}
R_{\mathrm{source}} = R_S + \left( \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O \right)
\end{gather}
$$

不考虑 $R_S$ 时 ($R_S = 0$), 我们有 $ R_{\mathrm{source}} = \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O $

## Gate Resistance

查阅资料可以知道， MOSFET 的 gate leakage current 与多种因素有关，包括但不限于 technology, process, $t_{ox}$, $W$, $L$, $V_{DS}$ 和 $V_{GS}$ 等。在目前这个阶段，我们可以粗略地认为大多数 $R_{\mathrm{gate}}$ 在 $100\ \mathrm{M\Omega}$ 以上。

特别地，一些低漏电流的 MOSFET, 其 gate resistance 可以做到 $10^4 \ \mathrm{M\Omega}$ 以上。

## Current or Resistance?

上述模型对 current source 的情况也具有普适性，理想的 current source 在 small-single angle 下电流不会有任何变化，因此在 small-single model 中呈现断路 (等价于 $R_S = \infty$)。如果使用一个有 gate bias 的 MOS 来充当 current source, 其在 small-single model 中呈现出 $r_O$（也可能是 $r_O \parallel \frac{1}{g_{mb}}$），这是因为流过的电流与 $V_{ds}$ 呈线性关系。