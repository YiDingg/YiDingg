# [Razavi CMOS] A Brief View of Negative Feedback Analysis Method

> [!Note|style:callout|label:Infor]
> Initially published at 15:56 on 2025-04-30 in Beijing.

## Intro

本文对 *Design of Analog CMOS Integrated Circuits (Razavi) (Second Edition, 2015)* 第八章 "Chapter 8: Feedback" 的内容作了简要总结，并讨论了我对书中各种反馈分析方法的理解。

>注：如无特别说明，本章都默认忽略 channel-length modulation 和 body effect, 也即 $\lambda = 0$ 和 $\eta = 0$。

## Five Diffic. in FB Analysis

- The first difficulty relates to breaking the loop and stems from the “loading” effects imposed by the feedback network upon the forward amplifier.
- The second difficulty is that some circuits cannot be clearly decomposed into a forward amplifier and a feedback network.
- The third difficulty in feedback analysis is that some circuits do not readily map to the four canonical topologies studied in the previous sections.
- The fourth difficulty is that the general feedback system analyzed thus far assumes unilateral stages, i.e., signal propagation in only one direction around the loop.
- The fifth difficulty arises in circuits containing multiple feedback mechanisms (loosely called “multiloop” circuits).

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-21-11-08_A Brief View of Negative Feedback.png"/></div>


## Tow-Port Method

<span style='color:red'> 必须强调，以下结论默认了 forward system 和 feedback network 的 $\mathbf{G}$ 参数满足 $G_{12} = \left(\frac{I_1}{I_2}\right)_{V_1 = 0} = 0$ </span>，这表明：将 input 短接 (virtual ground), 然后在 forward system 的 output 处加一个电流源 $I_{2}$，无论 $I_2$ 的值是多少，都有 $I_1 = 0$，也就是 input 端不会流入任何电流。

只要验证了这一点，我们便可用“标准的” amplifier model 来描述 forward system, 例如用 $(Z_{in}, A_v, Z_{out})$ 表示 voltage-to-voltage amp, 用 $(Z_{in}, G_m, Z_{out})$ 表示 voltage-to-current amp. 不考虑寄生电容等动态元件时，大多数从 MOS Gate 输入的 forward system 都满足这个要求 ($G_{12} = 0$)；特别地，对于 BJT 器件，由于 $I_B$ 的变化量通常远小于电路中其它电流的变化量 (即小信号模型中 $i_B \ll i_C$ 等)，我们可以近似地认为 $G_{12} = \left(\frac{I_1}{I_2}\right)_{V_1 = 0}$ 为零，称为 "Tow-Port Approximation"。

下面便可以介绍 Tow-Port Method 如何分析反馈环路。我们直接考虑非理想反馈的情形，也就是 feedback network 对 forward system 有 loading 作用。 In this case, 我们对 feedback network 作一个 duplication, 将其“并入”原来的 forward system, 得到一个新的 forward system 。

这样，原来的非理想反馈便可以替换为理想反馈（需要事先计算反馈系数 $K$），此时的 forward system 是包含了 loading effect 的 new forward system 。再按理想反馈的方法，计算开环增益 $A_{OL}$, 输入输出阻抗 $Z_{in},\ Z_{out}$ 和 loop gain $KA_{OL}$, 便可以得到：

$$
\begin{gather}
\mathrm{Voltage-voltage\ amp:\ }
\begin{cases}
A_{CL} = \frac{A_{OL}}{1 + KA_{OL}}         \\
Z_{in,CL} = \left(1 + KA_{OL}\right)Z_{in}  \\
Z_{out,CL} = \frac{Z_{out}}{1 + KA_{OL}}
\end{cases}
\end{gather}
$$

类似地，对于其它类型的 forward system, 其增益也被 scaled down by $(1 + KA_{OL})$, 输入输出阻抗被 scaled up or down by $(1 + KA_{OL})$.


## Universal Analysis (Tow-Port Method)

*Razavi CMOS* 在 page 多次强调，利用反馈网络的 duplication 进行计算，是默认了原二端口网络 $\mathbf{G}$ 参数中的 $G_{12}$ 和 $g_{12}$ 为零，也即 forward system 的 $G_{12} = 0$ 和 feedback network 的 $g_{12} = 0$。在大多数情况下，这个假设是成立的，得到的结果也是精确解。但是，在某些情况下，这个假设并不成立，因此有必要对普遍情况进行分析。

以 voltage-voltage amplifier 为例，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-30-15-39-18_A Brief View of Negative Feedback.png"/></div>

在上图中，我们设 forward system 和 feedback network 的 $\mathbf{G}$ 参数分别为：

$$
\begin{gather}
\mathbf{G_{A_v}} = 
\begin{bmatrix}
G_{11} & G_{12} \\
G_{21} & G_{22}
\end{bmatrix}
,\quad 
\mathbf{G_{FB}} =
\begin{bmatrix}
g_{11} & g_{12} \\
g_{21} & g_{22}
\end{bmatrix}
\end{gather}
$$

注意二端口 $\mathbf{G}$ 参数的定义是：

$$
\begin{gather}
\begin{bmatrix}
I_1 \\ {\color{red} V_2 }
\end{bmatrix} =
\mathbf{G}\cdot 
\begin{bmatrix}
{\color{red} V_1} \\ I_2
\end{bmatrix}
= \begin{bmatrix}
G_{11} & G_{12} \\
G_{21} & G_{22}
\end{bmatrix}
\cdot 
\begin{bmatrix}
{\color{red} V_1} \\ I_2
\end{bmatrix}
\end{gather}
$$

应用 KCL/KVl, 得到线性方程组：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-30-15-43-44_A Brief View of Negative Feedback.png"/></div>

写成矩阵形式：

$$
\begin{gather}
\mathbf{C}\cdot \mathbf{Y} = \mathbf{0}
,\quad 
\mathbf{C} = 
\begin{bmatrix}
1 & -g_{21}  & -g_{22} -\frac{1}{G_{11} } & \frac{G_{12} }{G_{11} } & 0\\
0 & g_{11} +\frac{1}{G_{22} } & g_{12}  & 0 & -\frac{G_{21} }{G_{22} }\\
0 & 0 & -\frac{1}{G_{11} } & \frac{G_{12} }{G_{11} } & 1\\
0 & g_{11}  & g_{12}  & 1 & 0
\end{bmatrix}
,\quad 
\mathbf{Y} =
\begin{bmatrix}
V_{\mathrm{in}} \\
V_{\mathrm{out}} \\
I_{\mathrm{in}} \\
I_2 \\
V_e 
\end{bmatrix}
\end{gather}
$$

上面共有四个方程，但是有五个未知数。假设我们感兴趣的是 $A_{CL} = \frac{V_{out}}{V_{in}}$, 把 $V_{in}$ 当作已知量，方程两边同除以 $V_{in}$，则方程组等价于：

$$
\begin{gather}
\mathbf{A}\cdot \mathbf{X} = \mathbf{B} 
,\quad 
\mathbf{A} = 
\begin{bmatrix}
-g_{21}  & -g_{22} -\frac{1}{G_{11} } & \frac{G_{12} }{G_{11} } & 0\\
g_{11} +\frac{1}{G_{22} } & g_{12}  & 0 & -\frac{G_{21} }{G_{22} }\\
0 & -\frac{1}{G_{11} } & \frac{G_{12} }{G_{11} } & 1\\
g_{11}  & g_{12}  & 1 & 0
\end{bmatrix}
,\quad 
\mathbf{X} =
\begin{bmatrix}
V_{\mathrm{out}} \\
I_{\mathrm{in}} \\
I_2 \\
V_e 
\end{bmatrix}\cdot \frac{1}{V_{in}}
,\quad 
\mathbf{B} 
= \begin{bmatrix}
-1 \\ 0 \\ 0 \\ 0 
\end{bmatrix}
\end{gather}
$$

不妨把 $\mathbf{X}$ 记作 $\mathbf{X} = \begin{bmatrix} V_{\mathrm{out}}, & I_{\mathrm{in}}, & I_2, & V_e \end{bmatrix}^T$, 求出结果后再统一除以 $V_{in}$。在 MATLAB 中解此线性方程组，得到 (公式太长, 我们直接贴图片):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-21-47-08_A Brief View of Negative Feedback.png"/></div>

<!-- 
$$
\begin{gather}
A_{CL} = \frac{V_{out}}{V_{in}} = \frac{G_{11} \,{\left(G_{21} -G_{11} \,G_{22} \,g_{12} +G_{12} \,G_{21} \,g_{12} \right)}}{G_{11} +{G_{11} }^2 \,g_{22} +G_{11} \,G_{12} \,g_{12} +G_{11} \,G_{22} \,g_{11} +G_{11} \,G_{21} \,g_{21} +{G_{11} }^2 \,G_{22} \,g_{11} \,g_{22} -{G_{11} }^2 \,G_{22} \,g_{12} \,g_{21} -G_{11} \,G_{12} \,G_{21} \,g_{11} \,g_{22} +G_{11} \,G_{12} \,G_{21} \,g_{12} \,g_{21} }
\end{gather}
$$
 -->


相关代码如下：

``` matlab
syms V_in V_out I_in I_2 V_e G_Av G_FB
syms G_11 G_12 G_21 G_22
syms g_11 g_12 g_21 g_22
G_Av = [G_11, G_12; G_21, G_22]
G_FB = [g_11, g_12; g_21, g_22]

% A*X = B
A = [
-g_21, -g_22 - 1/G_11, G_12/G_11, 0 
g_11 + 1/G_22, g_12, 0, -G_21/G_22
0, -1/G_11, G_12/G_11, 1
g_11, g_12, 1, 0
]
X = [
V_out
I_in
I_2
V_e
];
B = [-1; 0; 0; 0];
% 为避免参数为 0 带来的 nan, A 和 B 两边同乘：
A = A*G_22*G_11;
X
B = B*G_22*G_11;
X = inv(A)*B;  % A*X = B, X = inv(A)*B
A_CL = X(1) % A_CL = V_out/V_in

```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-30-15-54-41_A Brief View of Negative Feedback.png"/></div>

遗憾的是，上面的讨论虽然严谨，但并不具有什么实际意义。因为计算 forward system 的 $\mathbf{G}$ 参数通常是非常繁琐的（反馈网络的要稍容易一些），尤其是在 forward system 有动态元件或多级的情况下。


## Bode's Method

### Intro

Bode's Method 适用于 forward system 中至少有一个晶体管的情况（至少有一个受控电流源，记作 $I_1 = g_m V_1$）。它利用线性系统的叠加定理，将复杂的闭环计算转化为四步更简单的计算（分别对应 $A$, $B$, $C$, $D$ 四个参数），从而降低了分析难度。 Bode's Method 最大的优势在于计算闭环系统时无需识别、断开反馈回路，这使得它非常适用于那些反馈路径模糊不清、难以辨认的闭环系统。

### Bode's Method

下面介绍 Bode's Method 的具体方法（以 voltage-voltage amp 为例）：
- 将 $V_{in},\ I_1$ 视为输入量，$V_{out}$ 和 $V_1$ 视为输出量，其中 $I_1 = g_m V_1$ 是系统中（任意）一个受控源
- 求出 $A$, $B$, $C$, $D$ 四个参数，满足 $\begin{bmatrix} V_{out} \\ V_1 \end{bmatrix} = \mathbf{Bode} \cdot \begin{bmatrix} A & B \\ C & D \end{bmatrix} = \begin{bmatrix} A & B \\ C & D \end{bmatrix} \cdot \begin{bmatrix} V_{in} \\ I_1 \end{bmatrix} = \begin{bmatrix} AV_{in} + B I_1 \\ C V_{in} + D I_1 \end{bmatrix}$
    - 设置 $I_1 = 0$ (开路), 在激励为 $V_{in}$ 的情况下，求出响应 $V_{out}$ 和 $V_1$, 以此得到 $A = \left(\frac{V_{out}}{V_{in}}\right)_{I_1 = 0}$ 和 $C = \left(\frac{V_{1}}{V_{in}}\right)_{I_1 = 0}$
    - 设置 $V_{in} = 0$ (短路), 在激励为 $I_1$ 的情况下，求出响应 $V_{out}$ 和 $V_1$, 以此得到 $B = \left(\frac{V_{out}}{I_1}\right)_{V_{in} = 0}$ 和 $D = \left(\frac{V_{1}}{I_1}\right)_{V_{in} = 0}$
- 计算闭环增益：$A_{CL} = \frac{A - g_m \mathrm{det} (\mathbf{Bode})}{1\ \  -\ \  g_m D}$

总结下来就是一个公式：

$$
\begin{gather}
A_{CL} = \frac{A - g_m \mathrm{det} (\mathbf{Bode})}{1\ \  -\ \  g_m D}
\end{gather}
$$




对于更普适的情况，只需将 $V_{in}$ 和 $V_{out}$ 分别视作系统的激励和响应，而无需考虑它们是电压还是电流量。

### Exercise: Degenerate CS

以 Degenerate CS Stage 为例，这是一个典型的反馈路径难以辨认的负反馈系统。如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-30-16-40-54_A Brief View of Negative Feedback.png"/></div>

容易计算得到：
$$
\begin{gather}
A = 0,\quad 
B = \frac{- r_O R_D}{R_D + r_O + R_S},\quad
C = 1,\quad 
D = \frac{- r_O R_S}{R_D + r_O + R_S}
\\
\det (\mathbf{Bode}) =
AD - BC = 0  - \frac{- r_O R_D}{R_D + r_O + R_S} = \frac{r_O R_D}{R_D + r_O + R_S}
\end{gather}
$$

于是闭环增益（总增益）为：

$$
\begin{gather}
A_{CL} = \frac{A - g_m \mathrm{det} (\mathbf{Bode})}{1\ \  -\ \  g_m D} = \frac{0 - g_m \cdot \frac{r_O R_D}{R_D + r_O + R_S}}{1\ \  -\ \  g_m \cdot \frac{- r_O R_S}{R_D + r_O + R_S}}
= \frac{- g_m r_O R_D}{g_m r_O R_S + R_D + r_O + R_S}
\end{gather}
$$

这与我们之前就熟知的结果一致：

$$
\begin{gather}
A_{CS} = -g_m r_O \cdot \frac{R_D}{R_D + R_{drain}},\quad R_{drain} = \left(1 + \frac{R_S}{R_{S0}}\right)r_O = \left[1 + (g_m + g_{mb} + \frac{1}{r_O})R_S\right]r_O
\end{gather}
$$

忽略 body effect 时，$g_{mb} = 0$，得到：

$$
\begin{gather}
R_{drain}|_{g_{mb} = 0} = r_O + (1 + g_m r_O) R_S
\\
A_{CS}|_{g_{mb} = 0}  = \frac{- g_m r_O R_D}{g_m r_O R_S + R_D + r_O + R_S}
\end{gather}
$$

这与 Bode's Method 计算的结果一致。



### Exercise: R_drain + Z_GD

待补充……


## Blackman's Impedance Theorem

Blackman's Impedance Theorem 用于求解电路任意端口看入的阻抗，用 Bode's Method 可以很容易证明。我们先从 Bode's Method 的角度得到结论，再给出 Blackman's Impedance Theorem 的具体内容。

### From Bode's Perspe.

从 Bode's Method 的角度来看，把 Bode's Method 中的 OUT 和 IN 看作同一端口的 $V_{x}$ 和 $I_x$, 或者说 $V_{in}$ 和 $I_{in}$, 如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-21-33-20_A Brief View of Negative Feedback.png"/></div>

可以证明 (*Razavi CMOS* page-325), 此时端口看入的阻抗为：

$$
\begin{gather}
Z_{in} = \frac{V_{in}}{I_{in}} = A + \frac{g_m BC}{1 - g_m D}
\end{gather}
$$


### From Blackman's Perspe.

从 Blackman's Impedance Theorem 的角度来看，我们先将电流源 $I_1$ 置零  (等价于 $g_m = 0$), 求出此时的 $Z_0 = \left(\frac{OUT}{IN}\right)_{I_{1} = 0} = \left(\frac{V_{in}}{I_{in}}\right)_{I_{1} = 0}$；再分别令 $V_{in}$ 和 $I_{in}$ 为零，求得此时的 $\frac{V_1}{I_1}$；也就是要求出三个物理量：

$$
\begin{gather}
Z_0 = \left(\frac{V_{in}}{I_{in}}\right)_{I_{1} = 0},\quad 
T_{sc} = (-g_m)\cdot \left(\frac{V_1}{I_1}\right)_{V_{in} = 0},\ 
T_{oc} = (-g_m)\cdot \left(\frac{V_1}{I_1}\right)_{I_{in} = 0}
\end{gather}
$$

上式中的角标 `oc` 和 `sc` 分别表示 `open-circuit` 和 `short-circuit`，$Z_0$, $T_{oc}$, $T_{sc}$ 分别称为 open-loop impedance, open-circuit loop gain 和 short-circuit loop gain. 求出这三个量之后，端口的阻抗 $Z_{in}$ 即为：

$$
\begin{gather}
Z_{in} = Z_0 \cdot \frac{1 + T_{sc}}{1 + T_{oc}} = Z_0 \cdot \frac{1 - g_m \left(\frac{V_1}{I_1}\right)_{V_{in} = 0}}{1 - g_m\left(\frac{V_1}{I_1}\right)_{I_{in} = 0}}
\end{gather}
$$

容易证明上式与 Bode's Method 得到的式子是等价的，具体过程见 *Razavi CMOS* page-325，我们不多赘述。

## Middlebrook's Method

Middlebrook 曾提出了传函分析最经典的技巧之一： Extra Element Theorem (EET), Middlebrook's Method 便是 EET 的另一种形式, 或者说是 EET 的前身。定理的具体内容如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-21-45-11_A Brief View of Negative Feedback.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-21-45-22_A Brief View of Negative Feedback.png"/></div>

此方法较为繁琐，在传函分析中很少使用，因此我们浅尝辄止，不继续深入。
