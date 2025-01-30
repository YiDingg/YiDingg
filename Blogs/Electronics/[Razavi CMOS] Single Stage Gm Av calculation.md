# Single Stage Gm and Av calculation

> [!Note|style:callout|label:Infor]
Initially published at 00:15 on 2025-01-06 in Beijing.

往期回顾：[MOSFET's Terminal Resistance](<Blogs/Electronics/[Razavi CMOS] MOSFET's Terminal Resistance.md>)


## CS Stage

考虑下图所示 common-gate stage ，其中 $R_D$ 和 $R_S$ 暂时先不为零（为了普适性）。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-30-02-02-46_[Razavi CMOS] Single Stage Gm Av calculation.png"/></div>

依据小信号模型可得：
$$
G_m = 
\frac{g_m \, r_O}{R_S + r_O + (g_m + g_{mb})\,R_S\,r_O} = {\color{red} \frac{g_m \, r_O}{R_{\mathrm{drain}}}}
$$
继续由 $R_{\mathrm{drain}}$ 可以轻松的知道 $R_{out} = R_D \parallel R_{\mathrm{drain}}$ ，于是 $A_v$ 为：
$$
\begin{align}
A_v 
&= -G_m R_{out} 
= - \frac{g_m \, r_O}{R_{\mathrm{drain}}} \cdot \left( R_D \parallel R_{\mathrm{drain}} \right)
\\
&= - \frac{g_m \, r_O}{R_{\mathrm{drain}}} \cdot \frac{R_D \, R_{\mathrm{drain}}}{R_D + R_{\mathrm{drain}}} 
\\
&= {\color{red} - g_m \cdot \frac{\, r_O \, R_D}{R_D + R_{\mathrm{drain}}}}
\end{align}
$$

这与 *Razavi CMOS* page 66 equation (3.76) 的结果是一致的。


## CD Stage

如下图所示，我们有：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-30-02-02-32_[Razavi CMOS] Single Stage Gm Av calculation.png"/></div>


$$
\begin{gather}
V_{gs} = V_{in}, \quad V_{bs} = 0 \\
\Longrightarrow - I_{out} = \frac{I_{out}R_D}{r_O} + g_m V_{in} \\
\Longrightarrow 
G_m = \frac{I_{out}}{V_{in}} 
= {\color{red} - \frac{g_m}{1 + \frac{R_D}{r_O}}}
\end{gather}
$$

由 $R_{\mathrm{source}} = \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O$ 可以快速计算 $R_{out}$：
$$
\begin{equation}
R_{out} = (R_{\mathrm{source}} + R_D) \parallel R_S 
= \left( \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O + R_D \right) \parallel R_S 
\end{equation}
$$

于是得到 $A_v$ 为：
$$
A_v = -G_m R_{out} = 
{\color{red} \frac{g_m}{1 + \frac{R_D}{r_O}} \cdot \left[ \left( \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O + R_D \right) \parallel R_S  \right]}
$$

通常情况下， SF (source follower) 的 $R_D$ 为零。只需令上式 $\lim_{R_D \to 0}$，即可得到：
$$
\lim_{R_D \to 0} A_v = 
g_m \cdot \left( \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O \parallel R_S \right) 
$$

这与 *Razavi CMOS* page 72 equation (3.97) 的结果是一致的。

## CG Stage

考虑下图所示 common-gate stage ，先求 $G_m$，再求 $A_v$：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-30-01-12-06_[Razavi CMOS] Single Stage Gm Av calculation.png"/></div>

$$
\begin{gather}
V_g = V_b = 0 \Longrightarrow 
R_{eq} = R_S + \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O
\\
\end{gather}
$$
注意 $I_{out}$ 的方向相反，需要加负号：
$$
\begin{align}
G_m 
&= - \frac{1}{R_{eq}} = - \frac{1}{R_S + \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O} \\
&= {\color{red} - \left( g_m + g_{mb} + \frac{1}{r_O} \right) \cdot  \frac{R_S}{R_S + g_m + g_{mb} + \frac{1}{r_O}}}\\
\lim_{R_S \to 0} G_m & = -  \left(g_m + g_{mb} + \frac{1}{r_O}\right)
\end{align}
$$

求 $G_m$ 时，也可以由 $R_{\mathrm{source}}$ (resistance seen at source) 来考虑，结果是一样的。

下面求 $A_v$：将 $R_D$ 断开，我们有 $R_{\text{drain}} = r_O \cdot \frac{R_S}{R_S \parallel \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O}$，再与 $R_D$ 并联，得到：
$$
\begin{gather}
R_{out} = 
\left( r_O \cdot \frac{R_S}{R_S \parallel \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O} \right) \parallel R_D \\
\end{gather}
$$
$$
\begin{align}
\Longrightarrow 
A_v 
&= - G_m R_{out} \\
&= \frac{\left( r_O \cdot \frac{R_S}{R_S \parallel \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O} \right) \parallel R_D}{R_S + \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O} \\
&=
{\color{red} \frac{R_D \,{\left(g_m \,r_O +g_{\textrm{mb}} \,r_O +1\right)}}{R_D +R_S +r_O +R_S \,g_m \,r_O +R_S \,g_{\textrm{mb}} \,r_O }}
\end{align}
$$
这与 *Razavi CMOS* page 78 equation (3.111) 的结果是一致的。