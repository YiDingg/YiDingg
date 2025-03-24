# The Five-Transistor OTA

> [!Note|style:callout|label:Infor]
Initially published at 17:49 on 2025-03-24 in Beijing.

## Intro

The Five-Transistor OTA (Operational Transconductance Amplifier), 是一种差分输入、单端输出的放大器，如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-17-54-18_The Five-Transistor OTA.png"/></div>

将上图中的 tail current source 替换为一个晶体管，便一共包含五个晶体管，因此得名 Five-Transistor OTA 。

另外，上图中的五管 OTA 是 NPN/NMOS 输入 (PNP/PMOS 作 active load), 也可以替换为 PNP/PMOS 输入 (NPN/NMOS 作 active load)，两者的分析过程是几乎一致的。



下面，我们以 NMOS 作为输入管为例，详细分析此 OTA 在 large-signal 和 small-signal 下的性质，并进一步求解小信号差模增益 $A_{DM}$、共模增益 $A_{CM}$、共模抑制比 CMRR 等参数。推导过程参考了 Razavi 的 *Fundamentals of Microelectronics (2014, 2nd edition)*，后文简称为 *Razavi Microelectronics* 。



## Large-Signal Analysis



## Small-Signal Analysis

若无特别说明，本小节基于以下假设：
- 假设 tail current source 的小信号输出电阻为 $R_{SS}$
- <span style='color:red'> 考虑 channel-length modulation ($r_O < \infty$) </span>
- 不考虑 MOSFET 的 body-effect (body tied to source, $ \Longleftrightarrow  g_{mb} = 0$) 


### A_DM (Approach 1)

先考虑第一种方法，也是最“笨”，也是最实用的方法，即列出整个电路的小信号模型，依据 KCL 和 KVL 求解。

*Razavi Microelectronics* 的 Page 483 列出了五管 OTA 完整的小信号电路，作了比较详细的推导，但是并没有考虑尾电流源的输出电阻 $R_{SS}$ (即假设了 $R_{SS} \to \infty$)。在这里，我们参考 *Razavi Microelectronics* 的推导，但是将 $R_{SS}$ 考虑进去，即认为 $R_{SS} < \infty$ 是一个有限的电阻。

小信号电路如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-18-11-07_The Five-Transistor OTA.png"/></div>

推导过程比较繁琐，我们先列出结论，再给出具体过程。结论如下：

$$
\begin{gather}
\begin{cases}
\displaystyle
v_{out} = A_{DM}\cdot (v_1 - v_2) + A_{CM}\cdot \frac{v_1 + v_2}{2} 
\\\displaystyle
A_{DM} = \frac{g_{mN}r_{ON}}{ \frac{2(r_{ON} + r_{OP})}{r_{OP} \left[ 1 + g_{mP} (\frac{1}{g_{mP}}\parallel r_{OP}) \right]}  + \frac{2g_{mP} r_{OP}}{(2g_{mP} r_{OP} + 1)^2 \cdot \frac{r_{ON} + r_{OP}}{2 R_{SS} + r_{ON}}}}
\\\displaystyle
A_{CM} = \frac{- 2 g_{mN} r_{ON} (r_{ON} + r_{OP})}{(2 g_{mP} r_{OP} + 1) (2 R_{SS} + r_{ON})}
\end{cases}
\end{gather}
$$

如果作近似 $R_{SS} \approx \infty$，则有： 
$$
{\color{blue} \mathrm{Assuming \ R_{SS} \to \infty,\ we\ have:}}
\\
~
\\
\begin{gather}\color{blue}
A_{DM} = g_{mN} (r_{ON} \parallel r_{OP}) \cdot \frac{\ g_{mP} r_{OP} + 0.5\ }{g_{mP} r_{OP} + 1},\quad 
A_{CM} = 0\quad \quad 
\end{gather}
$$

如果作近似 $g_{mP} r_{OP} \gg 1$ (但是 $R_{SS} < \infty$)，则有：

$$
{\color{green} \mathrm{Assuming \ g_{mP} r_{OP} \gg 1,\ but\ R_{SS} < \infty,\ \ we\ have:}}
\\
~
\\
\begin{gather}
\color{green} 
A_{DM} = g_{mN} (r_{ON} \parallel r_{OP}) \cdot \frac{1}{1 + \frac{1}{2 g_{mp} \left( 2R_{SS} + r_{ON} \right)}}
\\\color{green}
A_{CM} = \frac{- g_{mN} r_{ON} (r_{ON} + r_{OP})}{2 g_{mP} r_{OP} (2R_{SS} + r_{ON})} \approx \frac{- g_{mN}^2 r_{ON}^2}{g_{mP} (2R_{SS} + r_{ON})} \cdot \frac{1}{A_{DM}}
\\\color{green}
\mathrm{CMRR} = \left|\frac{A_{DM}}{A_{CM}}\right| \approx \frac{A_{DM}^2}{g_{mN}^2 r_{ON}^2} \cdot g_{mP} (2 R_{SS} + r_{ON}) \Longrightarrow 
\mathrm{CMRR} < g_{mP} (2 R_{SS} + r_{ON}) \quad 
\end{gather}
$$

如果作近似 $g_{mP} r_{OP} \gg 1$ 且 $R_{SS} \to \infty$，则有：

$$
{\color{red} \mathrm{Assuming \ g_{mP} r_{OP} \gg 1\ and \ R_{SS} \to \infty,\ we\ have:}}
\\
~
\\
\begin{gather}
{\color{red} 
A_{DM} = g_{mN} (r_{ON} \parallel r_{OP})
,\quad 
A_{CM} = 0
}
\quad \quad \quad 
\end{gather}
$$


详细的推导过程如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-18-05-13_The Five-Transistor OTA.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-18-05-21_The Five-Transistor OTA.png"/></div>
 -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-18-13-02_The Five-Transistor OTA.png"/></div>

### A_DM (Approach 2)

上面的方法，基本、可用，但实在是太过繁琐，有没有更精简的、适合直觉的方法？有的。我们可以将 OTA 拆分为两个部分（上半部分和下半部分），在这个过程中，利用戴维南等效，体现它们的连接关系，从而求解。

如下图所示，我们先求解下半部分的戴维南等效（别忘了我们是要考虑 $R_{SS}$ 的）：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-19-52-15_The Five-Transistor OTA.png"/></div>

此时，下半部分可视为一个负载无穷大的 Common Source 差分放大，<span style='color:red'> 但是我们不能直接使用 half-circuit </span> 去计算 $v_{Thev}$，因为这样会使 $R_{SS}$ 对电路“无影响”，最终的结果中不含 $R_{SS}$。那么，$R_{SS} < \infty$ 时，等效的 $v_{Thev}$ 到底是多少？我们一算便知：

不妨先假设 $R_{D} < \infty$，得到计算结果后再令 $R_D \to \infty$，过程如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-21-21-59_The Five-Transistor OTA.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-21-25-46_The Five-Transistor OTA.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-20-52-43_The Five-Transistor OTA.png"/></div> -->

令人困惑的是，即使我们强调了 $R_{SS}$ 的作用，最后答案仍与 Approach 1 中令 $R_{SS} \to \infty$ 的结果相同，这是为什么？

Approach 2 的 MATLAB 公式代码如下：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-21-28-51_The Five-Transistor OTA.png"/></div>
 -->

``` matlab
clc, clear
syms v_1 v_2 i_1 i_2 R_D g_mN r_ON r_OP v_p R_SS
eq = [
-i_1*R_D - (i_1 - g_mN*v_1)*r_ON == v_p
-i_2*R_D - (i_2 - g_mN*v_2)*r_ON == v_p
i_1 + i_2 == v_p/R_SS
v_p * ( 2 + (R_D + r_ON)/R_SS ) == g_mN*r_ON*(v_1 + v_2)
]

re_v_p = solve(eq(4), v_p)
eq(1) = subs(eq(1), v_p, re_v_p);
eq(2) = subs(eq(2), v_p, re_v_p)
[i_1, i_2] = solve([eq(1), eq(2)], [i_1, i_2])
simplifyFraction([i_1, i_2])

v_Thev_DM = -R_D*(i_1 - i_2)
v_Thev_DM = simplifyFraction(v_Thev_DM)

v_Thev_CM = -R_D/2*(i_1 + i_2)
v_Thev_CM = simplifyFraction(v_Thev_CM)

simplify(eq(1) + eq(2))

clc, clear
syms v_out i_3 i_4 r_O3 r_O4 g_m4 g_m3 R_Thev v_Thev_DM v_Thev_CM g_mP r_OP r_ON
eq = [
v_out == (i_3 + i_4)*r_O4
i_4 == g_m4*i_3*MyParallel(r_O3, 1/g_m3)
-i_3*MyParallel(r_O3, 1/g_m3) - i_3*R_Thev - v_Thev_DM == v_out
]

re_i_4 = solve(eq(2), i_4);
re_i_3 = solve(eq(3), i_3);
eq(1) = subs(eq(1), i_4, re_i_4);
eq(1) = subs(eq(1), i_3, re_i_3);
re_v_out = solve(eq(1), v_out)


syms v_out i_3 i_4 r_O3 r_O4 g_m4 g_m3 R_Thev v_Thev_DM v_Thev_CM g_mP r_OP r_ON
eq_Razavi = (v_out + v_Thev_DM) * (g_m4*MyParallel(r_O3, 1/g_m3) + 1) / (MyParallel(r_O3, 1/g_m3) + R_Thev) + v_out/r_O4 == 0
re_v_out_Razavi = solve(eq_Razavi, v_out);

simplify(re_v_out_Razavi - re_v_out)    % 验证与 Razavi 的结果是否相同

if 1
    re_v_out = subs(re_v_out, R_Thev, 2*r_ON);
    re_v_out = subs(re_v_out, r_O3, r_OP);     % r_O3 = r_O4 = r_OP
    re_v_out = subs(re_v_out, r_O4, r_OP); 
    re_v_out = subs(re_v_out, g_m3, g_mP);     % g_m3 = g_m4 = g_mP
    re_v_out = subs(re_v_out, g_m4, g_mP);    
    %re_v_out = subs(re_v_out, r_O3, inf)      % g_m3*r_O3 >> 1
end
re_v_out = simplifyFraction(re_v_out)
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-21-29-44_The Five-Transistor OTA.png"/></div>


### Output Resistance (待验证)

对于输出电阻 $R_{out}$，利用 MOSFET 的端口电阻即可快速求解：

$$
\begin{gather}
R_{out} = r_{OP} \parallel \left[ r_{ON} + \frac{r_{ON} + \frac{1}{g_{mP}}\parallel r_{OP}}{1 + \frac{r_{ON} + \frac{1}{g_{mP}}\parallel r_{OP}}{R_{SS} \left(1 + g_{mN}r_{ON}\right)}} \right]
\end{gather}
$$

如果作近似 $R_{SS} \to \infty$，则有：
$$
\begin{gather}
\color{red} 
\mathrm{if \ R_{SS} \to \infty,\ we\ have:}
\\\color{red} 
R_{out} = r_{OP} \parallel (2r_{ON} + g_{mP}^{-1}\parallel r_{OP}) \approx r_{OP} \parallel 2 r_{ON}
\end{gather}
$$

具体计算过程如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-24-22-20-21_The Five-Transistor OTA.png"/></div>

更正：参考 sansen, 有：
$$
\begin{gather}
R_{out} \approx r_{OP} \parallel r_{ON}
\end{gather}
$$

### DM Input Resistance

### CM Input Resistance

## Using BJT

### A_DM

### A_CM

### Output Resistance

### DM Input Resistance