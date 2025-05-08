# [Razavi CMOS] Mismatches of Basic Differential Pair


> [!Note|style:callout|label:Infor]
Initially published at 12:26 on 2025-02-08 in Lincang.

## 前言

本文记录了 basic differential pair 的 mismatch 分析过程，以此为其它结构的 mismatch 分析提供参考。另一个原因是教材 (*Razavi CMOS*) 上对这部分仅做了较简单的近似计算，即 $\lambda = \gamma = 0$（也可以说是从 large-signal 的角度作分析），强迫症患者如我，总是希望能较为完整地（带有二阶效应地）推导出这些公式。

## Resistor Mismatch

如图，考虑 $R_{D1} = R_D$ 而 $R_{D2} = R_D + \Delta R_D$ 的 basic differential pair ，其中 $\Delta R_D$ 是 mismatch 部分，剩余部分保持 symmetrical 。

<div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-08-12-52-38_[Razavi CMOS] Mismatches of Basic Differential Pair.png"/></div>
<!-- 
<div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-08-12-41-29_[Razavi CMOS] Mismatches of Basic Differential Pair.png"/></div> -->

假设现在 $V_{in,CM}$ 已经有一个值，由于 pair 的非对称性，流过 $M_1$ 和 $M_2$ 的电流不相等，这使得 $M_1$ 和 $M_2$ 具有不同的 $g_m, g_{mb}, r_O$，并且 $V_{out1} \ne V_{out2}$。在现代纳米工艺中，短沟道调制效应非常明显，与短沟道带来的误差相比，将 $M_1$ 和 $M_2$ 的小信号参数视为两套不相等的值所带来的收益不高。因此，在 Resistor Mismatch 这一小节，我们认为 $M_1$ 和 $M_2$ 的小信号参数可以由 $I_{D1} = I_{D2} = \frac{1}{2}I_{SS}$ 计算得到，后文统一用 $M_1$ 的参数来表示。

下面我们计算当 $V_{in,CM}$ 发生变化时，$V_{out} = V_{out1} - V_{out2}$ 的变化量 $\Delta V_{out} = \Delta (V_{out1} - V_{out2})$ 。为强调小信号输入与大信号 (bias) 的区别，我们用小写字母表示小信号量。

将 $M_1$ 和 $M_2$ 视为两个相同的 SF 并联 (source follower, 在这一步忽略 $\Delta R_D$ 的影响)，注意并联后应作映射 $\color{red} g_m \to 2 g_m,\ g_{mb} \to 2g_{mb},\ r_O \to \frac{r_O}{2} \ \mathrm{和} \ R_D \to \frac{R_D}{2}$。作映射之前，SF 的小信号增益为：
$$
\begin{align}
A_{CD} 
&= - G_m \cdot R_{out} 
\\
&= - \left( -\frac{g_m}{1 + \frac{R_D}{r_O}} \right) \cdot \left( R_{S} \parallel R_{\mathrm{source}} \right)
\\
&= \frac{g_m}{1 + \frac{R_D}{r_O}} \cdot \frac{ R_S \cdot \left( 1 + \frac{R_D}{r_O}\right) R_{S0} }{R_S + \left( 1 + \frac{R_D}{r_O}\right) R_{S0}}
\end{align}
$$
在小信号中 $R_S$ 由 $M_3$ 表现为 $r_{O3}$，$R_{S0} = \frac{1}{g_m} \parallel \frac{1}{g_{mb}} \parallel r_O$ 是 MOSFET 的 resistance seen at the source node 。作并联映射，然后进一步化简，得到等效 $A_{CD}$ 为：
$$
\begin{gather}
A_{CD} = 
\frac{2 \, g_m}{1 + \frac{R_D}{r_O}} \cdot \frac{ r_{O3} \cdot \left( 1 + \frac{R_D}{r_O}\right) R_{S0} }{r_{O3} + \left( 1 + \frac{R_D}{r_O}\right) R_{S0}}
=
\frac{ 2 \, g_mr_{O3} }{1 + \frac{R_D}{r_O} + \left(2 g_m + 2 g_{mb} + \frac{2}{r_O}\right)r_{O3} }
\end{gather}
$$


这样，小信号 $v_{in,CM}$ 的输入，会使得 P 点电压升高 $v_p = A_{CD} \cdot v_{in, CM}$，导致 $I_{D1}$ 和 $I_{D2}$ 升高（我们将电流近似视为二等分）：
$$
\begin{gather}
i_{D1} = i_{D2} = \frac{1}{2} \cdot \frac{v_P}{r_{O3}}
\end{gather}
$$
这样，$v_{out} = v_{out1} - v_{out2}$ 就体现为：
$$
\begin{align}
\Delta V_{out} 
&= v_{out} = -  \Delta R_D \cdot \left(\frac{1}{2} \cdot \frac{A_{CD}\, v_{in}}{r_{O3}}\right)
\\
A_{CM-DM} &= - \frac{\Delta R_D}{2\, r_{O3}} \cdot  A_{CD}\ 
{\color{red}
= \frac{  - g_m \Delta R_D }{1 + \frac{R_D}{r_O} + \left(2 g_m + 2 g_{mb} + \frac{2}{r_O}\right)r_{O3} }
}
\end{align}
$$

为了得到更直观的结果，我们忽略二阶效应，得到近似结果：
$$
\begin{gather}
{\color{red}
A_{CM-DM} \approx \frac{-g_m \Delta R_D}{1 + 2 g_m r_{O3}}
}
\end{gather}
$$
这与教材上的结果一致， *Razavi CMOS* page 120 eq (4.45)。

## Transistor Mismatch

现在，我们考虑 transistor 带来的 mismatch 。如图所示：
<div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-08-13-24-13_[Razavi CMOS] Mismatches of Basic Differential Pair.png"/></div> 

这次，$M_1$ 和 $M_2$ 的电流、小信号参数有明显不同，我们不能像上一节那样作近似，只能一齐代入计算。画出小信号等效电路，我们有方程组：
$$
\begin{gather}
i_1 = - \frac{v_{out1}}{R_D},\ \ 
i_2 = - \frac{v_{out2}}{R_D},\quad 
i_1 + i_2 = \frac{v_p}{r_{O3}}\\
i_1 = g_{m1}(v_{in} - v_p) + g_{mb}(-v_p) + \frac{v_{out1} - v_p}{r_{O1}}\\
i_2 = g_{m2}(v_{in} - v_p) + g_{mb}(-v_p) + \frac{v_{out2} - v_p}{r_{O2}}
\end{gather}
$$
利用 Matlab (代码在最后)，在上面的方程中，消去其它变量，求出 $v_p$ as a function of $v_{in}$，given by:
$$
\begin{gather}
v_p = v_{in} \cdot 
\frac{
    {g_{\mathrm{m1}} +g_{\mathrm{m2}}} 
    - \frac{g_{\mathrm{m1}}}{1 + \frac{r_{O1}}{R_D}} 
    - \frac{g_{\mathrm{m2}}}{1 + \frac{r_{O2}}{R_D}}
    }{
    g_{\mathrm{m1}} +g_{\mathrm{m2}} +g_{\mathrm{mb1}} +g_{\mathrm{mb2}} 
    +\frac{1}{r_{\mathrm{O1}} }+\frac{1}{r_{\mathrm{O2}} }+\frac{1}{r_{\mathrm{O3}} }-
    \frac{1}{\left(1 + \frac{r_{O1}}{R_D}\right) R_{S01}}
    -
    \frac{1}{\left(1 + \frac{r_{O2}}{R_D}\right) R_{S02}}
    }
\end{gather}
$$
其中 $\frac{1}{R_{S01}} = g_{m1} + g_{mb1} + \frac{1}{r_{O1}}$，$\frac{1}{R_{S02}}$ 把角标从 1 换为 2 即可。直观上讲，如果忽略二阶效应，即 $[g_{mb1},\ g_{mb2},\ r_{O1},\ r_{O2}] = [0,\ 0,\ \infty,\ \infty]$，化简得到 $v_p = \frac{g_{m1} + g_{m2}}{g_{m1} + g_{m2} + \frac{1}{r_{O3}}}$，这与课本上的结果一致。


得到了 $v_p$ 关于 $v_{in}$ 的表达式，我们再回到公式 $i_1 = \frac{v_{out1}}{R_D}$ 和 $i_1 = g_{m1}(v_{in} - v_p) + g_{mb}(-v_p) + \frac{v_{out1} - v_p}{r_{O1}}$。消去 $i_1$，我们可以得到关于 $v_{out1}$、$v_p$ 和 $v_{in}$ 的方程，再将 $v_p$ 换为关于 $v_{in}$ 的表达式，即可求出 $v_{out1}$ as a function of $v_{in}$。同理也可以求出 $v_{out2}$，将两者相减，即得到我们需要的 $v_{out} = A_{CM-DM} \cdot v_{in}$，也就是 $V_{in,CM}$ 发生（小信号）变化时，$V_{out} = V_{out1} - V_{out2}$ 的变化量。

最终结果如下：
$$
\begin{gather}
{\color{red}
A_{CM-DM} = 
\frac{g_{m2} + \frac{X}{Y} \cdot \frac{1}{R_{S02}}}{\frac{1}{R_D} + \frac{1}{r_{O2}}} -
\frac{g_{m1} + \frac{X}{Y} \cdot \frac{1}{R_{S01}}}{\frac{1}{R_D} + \frac{1}{r_{O1}}}
}
\\
\mathrm{where:}\quad 
X = - \frac{g_{m1}}{1 + \frac{R_D}{r_{O1}}} - \frac{g_{m2}}{1 + \frac{R_D}{r_{O2}}}
\\
Y = g_{\mathrm{m1}} +g_{\mathrm{m2}} +g_{\mathrm{mb1}} +g_{\mathrm{mb2}} 
    +\frac{1}{r_{\mathrm{O1}} }+\frac{1}{r_{\mathrm{O2}} }+\frac{1}{r_{\mathrm{O3}} }-
    \frac{1}{\left(1 + \frac{r_{O1}}{R_D}\right) R_{S01}}
    -
    \frac{1}{\left(1 + \frac{r_{O2}}{R_D}\right) R_{S02}}
\end{gather}
$$

经过验证，当 $M_1$ 和 $M_2$ 完全对称时，也即 $r_{O1} = r_{O2}$、$g_{m1} = g_{m2}$、$g_{mb1} = g_{mb2}$，$A_{CM-DM} = 0$，与直觉相符。

上面这一长串令人十分头疼，为了得到更加直观的效果，我们作一些近似。忽略二阶效应，可以化简得到：
$$
\begin{gather}
X \approx - g_{m1} - g_{m2},\ \ 
Y \approx g_{m1} + g_{m2} + \frac{1}{r_{O3}}
\\
{\color{red}
A_{CM-DM} \approx
\frac{- \Delta g_m R_D}{1 + (g_{m1} + g_{m2})\,r_{O3}}
}
,\quad 
\Delta g_m = g_{m1} - g_{m2}
\end{gather}
$$
这与教材上的结果一致， *Razavi CMOS* page 122 eq (4.53)。

<!-- 显然，相比前面的 resistor mismatch ，transistor mismatch 带来的 $A_{CM-DM}$ 更大，这也符合实际情况。 -->

## Matlab Code

本文的 Matlab 代码如下：
```matlab
clc, clear, close all
syms V_D V_out I_out V_in V_x I_x V_X I_X V_Y I_Y R_S R_D V_P V_...
    V_out1 V_out2 ...
    g_m g_mb r_O ...
    g_m1 g_mb1 r_O1 ...
    g_m2 g_mb2 r_O2 ...
    g_m3 g_mb3 r_O3 ...
    g_m4 g_mb4 r_O4 ...
R_S01 = MyParallel_n([1/g_m1, 1/g_mb1, r_O1])
R_S02 = MyParallel_n([1/g_m2, 1/g_mb2, r_O2])
R_S03 = MyParallel_n([1/g_m3, 1/g_mb3, r_O3])

% 20250208 0131 (Transistor Mismatch)
eq = - V_out1/R_D == g_m1*(V_in-V_P) + g_mb1*(0-V_P) + (V_out1 - V_P)/r_O1;
V_out1 = solve(eq, V_out1)
eq = - V_out2/R_D == g_m2*(V_in-V_P) + g_mb2*(0-V_P) + (V_out2 - V_P)/r_O2;
V_out2 = solve(eq, V_out2)
eq = V_P/r_O3 == (g_mb1 + g_mb2)*(-V_P) + (g_m1 + g_m2)*(V_in-V_P) + V_out1/r_O1 + V_out2/r_O2 - V_P*(1/r_O1 + 1/r_O2);
V_P_ = solve(eq, V_P)
subs(V_P_, [g_mb1 g_mb2 r_O1 r_O2], [0 0 inf inf])  % 忽略二阶效应
%V_P_ = simplify(V_P_)

V_out1 = subs(V_out1, V_P, V_P_);
V_out2 = subs(V_out2, V_P, V_P_);
v_out = V_out1 - V_out2
A_CM_DM = v_out/V_in
A_CM_DM = simplify(v_out/V_in);
subs(v_out, [g_mb1 g_mb2 r_O1 r_O2], [0 0 inf inf]) % 忽略二阶效应
subs(v_out, [g_m1 g_mb1 r_O1], [g_m2 g_mb2 r_O2])   % 验证 symmetric 时 A_CM_DM = 0
```