# The Five-Transistor OTA

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 17:49 on 2025-03-24 in Beijing.


## Intro

The Five-Transistor OTA (Operational Transconductance Amplifier), 是一种差分输入、单端输出的放大器，如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-17-54-18_The Five-Transistor OTA.png"/></div>

将上图中的 tail current source 替换为一个晶体管，便一共包含五个晶体管，因此得名 Five-Transistor OTA 。

另外，上图中的五管 OTA 是 NPN/NMOS 输入 (PNP/PMOS 作 active load), 也可以替换为 PNP/PMOS 输入 (NPN/NMOS 作 active load)，两者的分析过程是几乎一致的。



在后文中，我们以 MOS 五管 OTA 为例，详细分析此电路在 large-signal 和 small-signal 下的性质，并进一步求解小信号差模增益 $A_{DM}$、共模增益 $A_{CM}$、共模抑制比 CMRR 等参数。推导过程参考了 Razavi 的 *Fundamentals of Microelectronics (2014, 2nd edition)*，后文简称为 *Razavi Microelectronics* 。



## Large-Signal Analysis

若无特别说明，下文的大信号分析都基于以下假设：
- 假设 tail current source 的小信号输出电阻可视为无穷大（但需要消耗一定 voltage headroom）
- <span style='color:red'> 不考虑 channel-length modulation ($r_O = \infty$) </span>
- 不考虑 MOSFET 的 body-effect (body tied to source)，相当于是分立 MOS 元件


我们知道，尽管一定范围的输入共模电压对五管 OTA 的增益、输出电阻等参数影响不大，但是不同于差分-差分放大器，五管 OTA 的输出摆幅与输入共模强相关，或者说输入共模电压限制着输出摆幅（限制最低输出电压）。


在进行 Large-Signal 分析之前，我们先对这个现象有一个定性的认识。下图是 NMOS 输入的五管 OTA 在不同输入共模电压下的开环仿真结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-25-22-56-47_The Five-Transistor OTA.png"/></div>

显然，在 OTA 的正常工作区间内，输出电压上边界始终为 VDD 不变，但是下边界受输入共模限制。随着 $V_{in,CM}$ 的提高，输出下边界被抬高，输出摆幅逐渐减小。

下面，我们就具体分析输入和输出的电压范围。先给出结论：

$$
\begin{gather}
V_{out} \in \left[ V_{in,CM} + V_{TH},\ \ V_{DD} \right]
\\
V_{in, CM} \in \left[ V_{OV}(I_{SS}) + V_{GS}(\frac{1}{2}I_{SS}),\ \ V_{DD} - V_{OV}(\frac{1}{2}I_{SS}) \right]
\end{gather}
$$

分析过程如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-25-23-38-50_The Five-Transistor OTA.png"/></div>

## Small-Signal Analysis


若无特别说明，后文的小信号分析都基于以下假设：
- 假设 tail current source 的小信号输出电阻为 $R_{SS}$
- <span style='color:red'> 考虑 channel-length modulation ($r_O < \infty$) </span>
- 不考虑 MOSFET 的 body-effect (body tied to source, $ \Longleftrightarrow  g_{mb} = 0$) 

### A_DM and A_CM (Method 1)

先考虑第一种方法，也是最“笨”，也是最实用的方法，即列出整个电路的小信号模型，依据 KCL 和 KVL 求解。

*Razavi Microelectronics* 的 Page 483 列出了五管 OTA 完整的小信号电路，作了比较详细的推导，但是并没有考虑尾电流源的输出电阻 $R_{SS}$ (即假设了 $R_{SS} \to \infty$)。在这里，我们参考 *Razavi Microelectronics* 的推导，但是将 $R_{SS}$ 考虑进去，即认为 $R_{SS} < \infty$ 是一个有限的电阻。


推导过程比较繁琐，我们先列出结论，再给出具体过程。结论如下：

$$
\begin{gather}
\begin{cases}
\displaystyle
v_{out} = A_{DM}\cdot (v_1 - v_2) + A_{CM}\cdot \frac{v_1 + v_2}{2} 
\\
\\\displaystyle
A_{DM} = 
\frac{
    g_{mN}r_{ON}
}{
    \frac{2(r_{ON} + r_{OP})}{r_{OP} \left[ 1 + g_{mP} (\frac{1}{g_{mP}}\parallel r_{OP}) \right]}  
    + 
    \frac{2g_{mP} r_{OP}}{(2g_{mP} r_{OP} + 1)^2 \cdot \frac{r_{ON} + r_{OP}}{2 (1 + g_{mN} r_{ON}) R_{SS} + r_{ON}}}
}
\\
\\\displaystyle
A_{CM} = \frac{- 2 g_{mN} r_{ON} (r_{ON} + r_{OP})}{(2 g_{mP} r_{OP} + 1) \left(2 (1 + g_{mN} r_{ON}) R_{SS} + r_{ON}\right)}
\end{cases}
\end{gather}
$$

如果 $R_{SS}$ 相对较大（但 $g_{mP}r_{OP}$ 比较小），我们可以作近似： 


$$
\begin{gather}
A_{DM} = g_{mN} (r_{ON} \parallel r_{OP}) \cdot \frac{\ g_{mP} r_{OP} + 0.5\ }{g_{mP} r_{OP} + 1},\quad 
A_{CM} \approx - \frac{r_{ON} + r_{OP}}{2 g_{mP} r_{OP} R_{SS}}
\quad \quad 
\end{gather}
$$


如果作近似 $g_{mP} r_{OP},\ g_{mN}r_{ON} \gg 1$（但是 $R_{SS}$ 较小），则有：

$$
\begin{gather}
A_{DM} = g_{mN} (r_{ON} \parallel r_{OP}) \cdot \frac{1}{1 + \frac{1}{2 g_{mp} r_{ON} \left( 2g_{mN}R_{SS} + 1 \right)}}
\\
A_{CM} = \frac{- g_{mN} r_{ON} (r_{ON} + r_{OP})}{2 g_{mP} r_{OP} (2R_{SS} + r_{ON})} \approx 
\frac{- g_{mN}^2 r_{ON}^2}{A_{DM} \cdot g_{mP}r_{ON} (2 g_{mN}R_{SS} + 1)} 
\\
\mathrm{CMRR} = \left|\frac{A_{DM}}{A_{CM}}\right| 
\approx \frac{A_{DM}^2}{g_{mN}^2 r_{ON}^2} \cdot g_{mP}r_{ON} (2 g_{mN}R_{SS} + 1)
\\
\Longrightarrow 
\mathrm{CMRR} < g_{mP}r_{ON} (2 g_{mN}R_{SS} + 1) \approx 2 (g_{mP}r_{ON}) (g_{mN}R_{SS}) \quad 
\end{gather}
$$

如果作近似 $g_{mP} r_{OP},\ g_{mN} r_{ON} \gg 1$ 且 $R_{SS}$ 相对较大，则有：

$$
\begin{gather}
\boxed{
A_{DM} = g_{mN} (r_{ON} \parallel r_{OP})
}
,\quad 
A_{CM} = \frac{- g_{mN}r_{ON}}{2 A_{DM} \cdot g_{mP} R_{SS}}
\quad \quad 
\\
\mathrm{CMRR} = 2 A_{DM}^2 \cdot \frac{g_{mP} R_{SS}}{g_{mN}r_{ON}}
< 2 A_{DM} (g_{mP} R_{SS})
\quad \quad \quad 
\end{gather}
$$


详细的推导过程如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-25-17-40-25_The Five-Transistor OTA.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-25-17-40-33_The Five-Transistor OTA.png"/></div>

### A_DM and A_CM (Method 2)

上面的分析显然太过繁琐，为了快速得到更符合直观的（近似）结果，我们可以将电路分为上下两部分，并用戴维南等效体现它们的连接关系。


### Output Resistance R_out

对于输出电阻 $R_{out}$，合理利用 MOSFET 的端口电阻即可快速求解。但需要注意的是，向上看的 <span style='color:red'> $M_4$ 不可简单等效为一个 $r_{OP}$ </span>，这是因为 $v_x$ (和 $i_x$) 加在输出节点时，$v_A$ 会发生了变化，从而使 $M_4$ 的电流发生变化。

因此，我们对“从输出节点向下看”作电阻等效，而对“从输出节点向上看”列出 $M_4$ 的小信号模型，最终结果为：

$$
\begin{gather}
R_{out} = r_{OP} \parallel R_4 \parallel 
\left[
    R_4 \cdot \left(1 + \frac{1}{g_{mP}r_{OP}}\right)\cdot \left(1 + \frac{R_2}{R_{SS}}\right)
\right]
\\
\mathrm{where\ } 
R_4 = r_{ON} + \frac{r_{ON} + \frac{1}{g_{mP}}\parallel r_{OP}}{1 + \frac{R_2}{R_{SS}}}
,\quad 
R_2 = \frac{r_{ON} + \frac{1}{g_{mP}}\parallel r_{OP}}{1 + g_{mN}r_{ON}}
\end{gather}
$$

如果作近似 $R_{SS} \gg R_2$（这是很容易满足的），则有：

$$
\begin{gather}
R_4 = 2 r_{ON} + \frac{1}{g_{mP}}\parallel r_{OP} \approx 2 r_{ON}
\Longrightarrow 
\boxed{
R_{out} \approx r_{OP} \parallel r_{ON}
}
\quad \quad \quad 
\end{gather}
$$

$R_{out}$ 的具体计算过程如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-25-17-46-56_The Five-Transistor OTA.png"/></div>


### Transconductance G_m

先列出结论：

$$
\begin{gather}
G_{m,DM} \approx - \frac{g_{mN} + g_{mP}}{2}\ \ (有待考证)
\end{gather}
$$

下面展示具体求解过程（利用 Matlab 辅助求解）。如图，依据 KCL 和 KVL 写出方程组：

$$
\begin{gather}
\left(\begin{array}{c}
i_x =g_{\mathrm{mP}} \,v_A -g_{\mathrm{mN}} \,{\left(v_P -v_{\mathrm{in2}} \right)}-\frac{v_P }{r_{\mathrm{ON}} }\\
-\frac{v_A }{R_3 }=g_{\mathrm{mP}} \,v_A -i_x +\frac{v_P }{R_{\mathrm{SS}} }\\
-\frac{v_A }{R_3 }=\frac{v_A -v_P }{r_{\mathrm{ON}} }-g_{\mathrm{mN}} \,{\left(v_P -v_{\mathrm{in1}} \right)}
\end{array}\right)
\end{gather}
$$

其中 $R_3$ 是上一小节求 $R_{out}$ 时的 $R_3$，也即 $R_3 = R_{SS}\parallel \frac{r_{ON}+ \frac{1}{g_{mP}}\parallel r_{OP}}{1 + g_{mN}r_{ON}}$，我们留到最后再来代入它的值。

联立 1、2 求解 $v_A$ 和 $v_P$: 

$$
\begin{gather}
v_P = \frac{R_{\mathrm{SS}} \,r_{\mathrm{ON}} \,{\left(g_{\mathrm{mN}} \,v_{\mathrm{in2}} -i_x +R_3 \,g_{\mathrm{mN}} \,g_{\mathrm{mP}} \,v_{\mathrm{in2}} \right)}}{R_{\mathrm{SS}} +R_3 \,R_{\mathrm{SS}} \,g_{\mathrm{mP}} +R_3 \,g_{\mathrm{mP}} \,r_{\mathrm{ON}} +R_{\mathrm{SS}} \,g_{\mathrm{mN}} \,r_{\mathrm{ON}} +R_3 \,R_{\mathrm{SS}} \,g_{\mathrm{mN}} \,g_{\mathrm{mP}} \,r_{\mathrm{ON}} }
\\
v_A = \frac{R_{\mathrm{SS}} \,r_{\mathrm{ON}} \,{\left(g_{\mathrm{mN}} \,v_{\mathrm{in2}} -i_x +R_3 \,g_{\mathrm{mN}} \,g_{\mathrm{mP}} \,v_{\mathrm{in2}} \right)}}{R_{\mathrm{SS}} +R_3 \,R_{\mathrm{SS}} \,g_{\mathrm{mP}} +R_3 \,g_{\mathrm{mP}} \,r_{\mathrm{ON}} +R_{\mathrm{SS}} \,g_{\mathrm{mN}} \,r_{\mathrm{ON}} +R_3 \,R_{\mathrm{SS}} \,g_{\mathrm{mN}} \,g_{\mathrm{mP}} \,r_{\mathrm{ON}} }
\end{gather}
$$

代入 3 式，求解 $i_x$，由于公式太长，我们这里直接贴图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-25-18-13-37_The Five-Transistor OTA.png"/></div>

下面化简 $i_x$ 的表达式，使其写为 $i_x = G_{m,DM} (v_{in1} - v_{in2}) + G_{m,CM} \frac{v_{in1} + v_{in2}}{2}$ 的形式。

由于 $i_x$ 的所有项都包含 $v_{in1}$ 或 $v_{in2}$，只需令其中一个为零，即可得到另一个输入量的系数。具体而言，$v_{in1}$ 的系数 $A_1$ 和 $v_{in2}$ 的系数 $A_2$ 分别为：

<!-- $$
\begin{gather}
A_1 = -\frac{r_{\mathrm{ON}} \,{\left(R_{\mathrm{SS}} \,g_{\mathrm{mN}} +R_{\mathrm{SS}} \,{g_{\mathrm{mN}} }^2 \,r_{\mathrm{ON}} +R_3 \,R_{\mathrm{SS}} \,g_{\mathrm{mN}} \,g_{\mathrm{mP}} +R_3 \,g_{\mathrm{mN}} \,g_{\mathrm{mP}} \,r_{\mathrm{ON}} +R_3 \,R_{\mathrm{SS}} \,{g_{\mathrm{mN}} }^2 \,g_{\mathrm{mP}} \,r_{\mathrm{ON}} \right)}}{R_3 \,R_{\mathrm{SS}} +R_3 \,r_{\mathrm{ON}} +2\,R_{\mathrm{SS}} \,r_{\mathrm{ON}} +{r_{\mathrm{ON}} }^2 +2\,R_{\mathrm{SS}} \,g_{\mathrm{mN}} \,{r_{\mathrm{ON}} }^2 +R_3 \,R_{\mathrm{SS}} \,g_{\mathrm{mN}} \,r_{\mathrm{ON}} }
\\
A_2 = \frac{r_{\mathrm{ON}} \,{\left(R_3 \,g_{\mathrm{mN}} +R_{\mathrm{SS}} \,g_{\mathrm{mN}} +g_{\mathrm{mN}} \,r_{\mathrm{ON}} +R_{\mathrm{SS}} \,{g_{\mathrm{mN}} }^2 \,r_{\mathrm{ON}} +R_3 \,R_{\mathrm{SS}} \,g_{\mathrm{mN}} \,g_{\mathrm{mP}} +R_3 \,R_{\mathrm{SS}} \,{g_{\mathrm{mN}} }^2 \,g_{\mathrm{mP}} \,r_{\mathrm{ON}} \right)}}{R_3 \,R_{\mathrm{SS}} +R_3 \,r_{\mathrm{ON}} +2\,R_{\mathrm{SS}} \,r_{\mathrm{ON}} +{r_{\mathrm{ON}} }^2 +2\,R_{\mathrm{SS}} \,g_{\mathrm{mN}} \,{r_{\mathrm{ON}} }^2 +R_3 \,R_{\mathrm{SS}} \,g_{\mathrm{mN}} \,r_{\mathrm{ON}} }
\end{gather}
$$
 -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-25-18-18-54_The Five-Transistor OTA.png"/></div>

设 $i_x = A_1 v_{in1} + A_2 v_{in2} = X(v_{in1} - v_{in2}) + Y\frac{v_{in1} + v_{in2}}{2}$，则有：

$$
\begin{gather}
\begin{cases}
A_1 = X + \frac{Y}{2}\\
A_2 = -X + \frac{Y}{2}
\end{cases}
\Longrightarrow 
G_{m, DM} = X = \frac{A_1 - A_2}{2},\quad G_{m, CM} = Y = A_1 + A_2
\end{gather}
$$
代入 $A_1$ 和 $A_2$ 的值，得到 $G_{m, DM}$ 和 $G_{m, CM}$ 的表达式。未化简的结果太长，我们直接贴图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-25-18-38-19_The Five-Transistor OTA.png"/></div>

先令 $R_{SS} \to \infty$，再令 $r_{ON} \to \infty$，得到近似条件下的 $G_m$（事实上，这里交换极限顺序，$G_{m,DM}$ 结果不变）：

$$
\begin{gather}
G_{m,DM} = - \frac{g_{mN} + g_{mP}}{2}
\end{gather}
$$

显然，如果我们用这里计算得到的 $G_m$，与上面的 $A_{DM}$ 和 $R_{out}$ 作了对比，验证是否满足 $A_{DM} + G_{m,DM}R_{out}$，结果是不满足的（因为近似条件下 $G_{m,DM} = - \frac{g_{mN} + g_{mP}}{2}$ 而不是 $- g_{mN}$）。这说明我们的计算仍存在某些缺陷，未来如果有机会，我们会重新更正这些缺陷。

本小节的 MATLAB 代码如下：

``` matlab
% 求解 Gm
clc, clear, close all
syms i_x g_mN v_in1 v_in2 v_P r_ON r_OP g_mP v_A R_3 R_SS
eq = [
i_x == g_mN*(v_in2 - v_P) - v_P/r_ON + g_mP*v_A
- v_A/R_3 == v_P/R_SS - (i_x - g_mP*v_A)
- v_A/R_3 == (v_A - v_P)/r_ON + g_mN*(v_in1 - v_P)
]

% 求解 v_A 和 v_P
re_v_A = solve(eq(2), v_A)  % 2 求解 v_A
eq(1) = subs(eq(1), v_A, re_v_A);   % 代入 1
re_v_P = solve(eq(1), v_P); % 1 求解 v_P
re_v_A = subs(re_v_A, v_P, re_v_P); % v_P 结果代回 v_A
re_v_P = simplifyFraction(re_v_P)
re_v_A = simplifyFraction(re_v_A)

% v_A 和 v_P 代入 3 求解 i_x
eq(3) = subs(eq(3), v_P, re_v_P);
eq(3) = subs(eq(3), v_A, re_v_A);
i_x = solve(eq(3), i_x);
i_x = simplifyFraction(i_x)
%simplifyFraction(i_x/r_ON/g_mN)  

% 化简 i_x 的表达式
A_1 = simplifyFraction(subs(i_x, v_in2, 0)/v_in1)     % 求 v_in1 的系数 A_1
A_2 = simplifyFraction(subs(i_x, v_in1, 0)/v_in2)     % 求 v_in2 的系数 A_2

syms X Y A B
eq = [
A == X + Y/2
B == -X + Y/2
]
[X, Y] = solve(eq, [X, Y])

% 准备代入 R_3
R_2 = (r_ON + MyParallel(1/g_mP, r_OP)) / (1 + g_mN*r_ON);
re_R_3 = MyParallel(R_SS, R_2 )

% 求解 Gm_DM
G_m_DM = X;
G_m_DM = subs(G_m_DM, A, A_1);  % 代入 A_1
G_m_DM = subs(G_m_DM, B, A_2);  % 代入 A_2
G_m_DM = subs(G_m_DM, R_3, re_R_3);  % 代入 R_3
G_m_DM = simplifyFraction(G_m_DM);
G_m_DM = g_mN*r_ON*simplifyFraction(G_m_DM/(g_mN*r_ON))    % 观察提取公因式后的式子

% 求解 Gm_CM
G_m_CM = Y;
G_m_CM = subs(G_m_CM, A, A_1);  % 代入 A_1
G_m_CM = subs(G_m_CM, B, A_2);  % 代入 A_2
G_m_CM = subs(G_m_CM, R_3, re_R_3);  % 代入 R_3
G_m_CM = simplifyFraction(G_m_CM)

if 0
% 验证 Gm_DM 与 A_DM 中的结果是否相同
R_4 = r_ON + (r_ON + MyParallel(1/g_mP, r_OP)) / (1 + R_2/R_SS);
R_out = MyParallel_n([r_OP, R_4, R_4 * (1+1/(g_mP*r_OP)) * (1+R_2/R_SS)]);   % 已校验
A_DM = (g_mN*r_ON)  ... % 已校验
    /  ( ...
    2*(r_ON + r_OP) / (r_OP*(1+g_mP*MyParallel(1/g_mP, r_OP))) ...
    + ...
    2*g_mP*r_OP / (2*g_mP*r_OP+1)^2 / ( (r_ON+r_OP)/(2*(1+g_mN*r_ON)*R_SS+r_ON)) ...
    )

check_DM = simplify(simplifyFraction(G_m_DM*R_out + A_DM))  % 验证 A_DM
%check_CM = simplify(simplifyFraction(G_m_CM*R_out - A_CM))  % 验证 A_CM

end

% 计算近似条件下的 G_m_DM 和 G_m_CM
G_m_DM = simplifyFraction(limit(G_m_DM, R_SS, inf));
G_m_DM = simplifyFraction(limit(G_m_DM, r_ON, inf));
%G_m_DM = simplifyFraction(limit(G_m_DM, R_SS, inf));
G_m_DM

%G_m_CM = simplifyFraction(limit(G_m_CM, R_SS, inf));
%G_m_CM = simplifyFraction(limit(G_m_CM, r_ON, inf));
%G_m_CM
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-25-19-34-10_The Five-Transistor OTA.png"/></div>



### Summary of Results

为方便查阅，我们将常用结果汇总如下：
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-25-22-10-03_The Five-Transistor OTA.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-25-22-10-48_The Five-Transistor OTA.png"/></div>

