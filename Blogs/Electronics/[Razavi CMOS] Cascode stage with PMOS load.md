# [Razavi CMOS] Cascode stage with PMOS load

> [!Note|style:callout|label:Infor]
Initially published at 16:37 on 2025-01-23 in Lincang.

对于常见的 cascode stage with PMOS load (2 NMOS + 2 PMOS)，教材上仅给出了 $R_{out}$ 的计算，而近似了 $G_m \approx g_m$。为了方便回顾，这里给出完整的 small-signal gain 推导过程。

如无特别说明,后文默认 $\lambda \ne 0,\ \gamma \ne 0$，也即考虑 channel-length modulation 和 body effect ；并且 NMOS 的 body 都连接 GND ， PMOS 的 body 都连接 VDD 。

## Output resistance Rout


<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-05-22-34-19_[Razavi CMOS] Cascode stage with PMOS load.png"/></div>
 -->

<div class="center"><img width = 300px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-05-22-38-47_[Razavi CMOS] Cascode stage with PMOS load.png"/></div>

考虑上图所示的 cascode stage with PMOS load ，在小信号模型中令 $V_{in} = 0$，则有：

$$
\begin{align}
R_{out} 
&= R_{\mathrm{drain2}} \parallel R_{\mathrm{drain3}} 
= \left[ \left( 1 + \frac{r_{O1}}{R_{S02}} \right) r_{O2} \right] \parallel \left[ \left( 1 + \frac{r_{O4}}{R_{S03}} \right) r_{O3} \right]
\end{align}
$$

对 $R_{\mathrm{drain}}$ 和 $R_{S0}$ 不熟悉的读者可以回顾往期文章： [MOSFET's Terminal Resistance](<Blogs/Electronics/[Razavi CMOS] MOSFET's Terminal Resistance.md>)。

## Transconductance Gm

计算 $G_m$ 时，在小信号模型中将 $V_{out}$ 接地，计算 $I_{out}$ (as a function of $V_{in}$)，等效小信号电路如下图所示：

<div class="center"><img width = 300px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-05-22-51-02_[Razavi CMOS] Cascode stage with PMOS load.png"/></div>


由于中间 $V_{out}$ 接地，可以将其分为两部分来看。对于上半部分，我们先假设 $V_{Y} \ne 0$，对节点 Y 列 KCL 有：
$$
\begin{gather}
- \frac{V_Y}{r_{O3} \parallel r_{O4}} = (g_{m3} + g_{mb3}) V_Y
\\
\left( g_{m3} + g_{mb3} + r_{O3} \parallel r_{O4}\right) \cdot V_Y = 0
\\
\Longrightarrow V_Y = 0
\end{gather}
$$

显然 $\left( g_{m3} + g_{mb3} + r_{O3} \parallel r_{O4}\right)$ 加起来不可能为零，因此只有 $V_Y = 0$，于是 $I_1 = 0$。这表明 $G_m$ 全部由下半部分贡献。这与 load 为 $R_D$ 时是类似的，上半部分可视作断路，对 $I_{out}$ 没有贡献，也就不影响 $G_m$。

我们说到 $G_m$ 全部由下半部分贡献，因此可以直接搬用 load 为 $R_D$ 时的结果，即：
$$
\begin{align}
G_m 
&= g_{m1} r_{O1} \cdot \frac{-1}{r_{O1} + R_{S02}}
\end{align}
$$

这个结果可以由 Thevenin equivalent circuit 快速得到（将其视为一个 $R_D = \infty$ 的 CS，级联一个 $R_D = \infty$ 且 $R_S \ne 0$ 的 CG ）


## Small-Signal Gain Av

将上面的结果代入，我们有：

$$
\begin{align}
A_v 
&= - G_m R_{out}
\\
&= \frac{g_{{m1}} \,r_{{O1}} }{{\left(r_{{O1}} +\frac{1}{g_{{m2}} +g_{{mb2}} +\frac{1}{r_{{O2}} }}\right)}\,{\left(\frac{1}{r_{{O2}} \,{\left(r_{{O1}} \,{\left(g_{{m2}} +g_{{mb2}} +\frac{1}{r_{{O2}} }\right)}+1\right)}}+\frac{1}{r_{{O3}} \,{\left(r_{{O4}} \,{\left(g_{{m3}} +g_{{mb3}} +\frac{1}{r_{{O3}} }\right)}+1\right)}}\right)}}
\\
&= 
\frac{g_{{m1}} \,r_{{O1}} \,{\left(g_{{m2}} \,r_{{O2}} +g_{{mb2}} \,r_{{O2}} +1\right)}\,{\left(r_{{O3}} +r_{{O4}} +g_{{m3}} \,r_{{O3}} \,r_{{O4}} +g_{{mb3}} \,r_{{O3}} \,r_{{O4}} \right)}}{r_{{O1}} +r_{{O2}} +r_{{O3}} +r_{{O4}} +g_{{m2}} \,r_{{O1}} \,r_{{O2}} +g_{{m3}} \,r_{{O3}} \,r_{{O4}} +g_{{mb2}} \,r_{{O1}} \,r_{{O2}} +g_{{mb3}} \,r_{{O3}} \,r_{{O4}} }
\end{align}
$$

上面这一长串看着就头疼，因此我们考虑一些近似计算，以获得方便直觉观察的结果。
假设： 
$$
\begin{cases}
(g_{m2} + g_{mb2})\, r_{O1}r_{O2} \gg (r_{O1} + r_{O2}) \\ 
(g_{m3} + g_{mb3})\, r_{O3} r_{O4} \gg (r_{O3} + r_{O4}) 
\end{cases}
\Longleftrightarrow 
\begin{cases}
(g_{m2} + g_{mb2}) \gg (\frac{1}{r_{O1}} + \frac{1}{r_{O2}}) \\ 
(g_{m3} + g_{mb3}) \gg (\frac{1}{r_{O3}} + \frac{1}{r_{O4}}) 
\end{cases}
$$
则有：
$$
\begin{align}
A_v 
&\approx
\frac{g_{{m1}} \,r_{{O1}} \,{\left(g_{{m2}} +g_{{mb2}}\right)}\,r_{{O2}} \cdot \,{\left(g_{{m3}} +g_{{mb3}}\right)}\,r_{{O3}} \,r_{{O4}}}{(g_{{m2}} + g_{{mb2}})\,r_{{O1}} \,r_{{O2}} + (g_{{m3}} + g_{{mb3}}) \,r_{{O3}} \,r_{{O4}}}
\\
&= 
g_{{m1}}  \cdot \frac{\,{\left(g_{{m2}} +g_{{mb2}}\right)}r_{{O1}}\,r_{{O2}} \cdot \,{\left(g_{{m3}} +g_{{mb3}}\right)}\,r_{{O3}} \,r_{{O4}}}{(g_{{m2}} + g_{{mb2}})\,r_{{O1}} \,r_{{O2}} + (g_{{m3}} + g_{{mb3}}) \,r_{{O3}} \,r_{{O4}}}
\\
&=
\color{red}
g_{{m1}}  \cdot\  \left[ {\left(g_{{m2}} +g_{{mb2}}\right)}r_{{O1}}\,r_{{O2}} \right] \parallel \left[ \,{\left(g_{{m3}} +g_{{mb3}}\right)}\,r_{{O3}} \,r_{{O4}} \right]
\end{align}
$$

当然，如果进一步忽略 body effect ，即 $g_{mb} = 0$，则有：

$$
\begin{gather}
\color{red}
A_v \approx
g_{{m1}}  \cdot \left[ \left( g_{{m2}}r_{{O1}}\,r_{{O2}} \right) \parallel \left( g_{{m3}}\,r_{{O3}} \,r_{{O4}} \right) \right]
\end{gather}
$$