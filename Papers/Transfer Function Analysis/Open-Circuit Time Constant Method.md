# The Open-Circuit Time Constant Method (OCTC)


> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 17:25 on 2025-05-05 in Beijing.

## Infor 

- Title: [Introducing Senior Undergraduate Students to the Open-Circuit Time-Constant Method for Circuit Analysis](https://ieeexplore.ieee.org/document/8741560)
- DOI: [10.1109/MOCAST.2019.8741560](https://doi.org/10.1109/MOCAST.2019.8741560)
- Author:  [Nikolaos F. Voudoukis, et al.](https://ieeexplore.ieee.org/author/37086139497)
- Conference Date: 13-15 May 2019
- Published in: [2019 8th International Conference on Modern Circuits and Systems Technologies (MOCAST)](https://ieeexplore.ieee.org/xpl/conhome/8732971/proceeding)

>**Full Citation:**
N. F. Voudoukis, D. Baxevanakis, K. Papafotis, C. Dimas, C. Oustoglou and P. P. Sotiriadis, "Introducing Senior Undergraduate Students to the Open-Circuit Time-Constant Method for Circuit Analysis," 2019 8th International Conference on Modern Circuits and Systems Technologies (MOCAST), Thessaloniki, Greece, 2019, pp. 1-4, doi: 10.1109/MOCAST.2019.8741560.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-20-53-32_Open-Circuit Time Constant Method.png"/></div>

## Abstract





<details>
<summary>Abstract</summary>

Open-circuit time-constant (OCTC) method is an approximate analytical method to estimate the 3 dB bandwidth of baseband circuits. Considerable saving in computational effort is achieved since a full analysis of the circuit is not required. 

The paper focuses on teaching and illustrating OCTC to senior undergraduate students. Two examples are presented to highlight the benefits gained by the approximate analysis technique and the perception of the students on the subject.
</details>






``` txt
Abstract: 

Open-circuit time-constant (OCTC) method is an approximate analytical method to estimate the 3 dB bandwidth of baseband circuits. Considerable saving in computational effort is achieved since a full analysis of the circuit is not required. 

The paper focuses on teaching and illustrating OCTC to senior undergraduate students. Two examples are presented to highlight the benefits gained by the approximate analysis technique and the perception of the students on the subject.
```

``` txt
AI 全文总结 (DeepSeek, 2025.05.06):  

这篇论文介绍了如何向高年级本科生教授开环时间常数（OCTC）方法，用于电路分析中的带宽估计。以下是论文的核心内容总结：

### 1. **背景与目的**
- OCTC是一种近似分析方法，用于估计基带电路的3 dB带宽，避免了复杂的传递函数分析。
- 论文旨在通过教学案例展示OCTC的优势，帮助学生理解电路带宽的限制因素。

### 2. **OCTC方法原理**
- **核心思想**：通过计算每个电容的开环时间常数（ $R_{C_i} C_i$ ）之和，估计电路的-3 dB频率（ $f_{-3\mathrm{dB}}$ ）。
- **假设条件**：存在一个主导极点，且其他极点和零点频率远高于主导极点。
- **公式**：总时间常数  $T = \sum R_{C_i} C_i$ ，带宽  $f_{-3\mathrm{dB}} \approx \frac{1}{2\pi T}$ 。

### 3. **应用步骤**
1. 选择电容  $C_i$ ，移除其他电容，短路耦合电容。
2. 关闭独立电源。
3. 计算电容  $C_i$  两端的等效电阻  $R_{C_i}$ 。
4. 重复步骤1-3，计算所有电容的时间常数。
5. 求和得到总时间常数  $T$ ，并估计带宽。

### 4. **教学案例**
- **案例1**：共发射极放大器电路。
  - 学生通过OCTC计算带宽为298.62 kHz，与仿真结果327 kHz接近。
  - 主要带宽限制来自Miller效应下的  $C_{\mu 1}$ 。
- **案例2**：共射共基（Cascode）放大器电路。
  - OCTC估计带宽为1.65 MHz，仿真结果为2.4 MHz，差异较大。
  - 主要限制来自  $C_{\pi 1}$ ，Miller效应因Cascode结构减弱。

### 5. **学生表现**
- **案例1**：70%学生正确解答，主要错误为等效电阻计算错误。
- **案例2**：50%学生正确解答，更多学生因电路复杂性遇到困难。
- 使用常见等效电路形式（如论文图1）的学生更易成功。

### 6. **结论与建议**
- OCTC是一种有效的教学工具，帮助学生理解电路带宽的限制因素。
- 结合理论讲解、仿真验证和课堂练习，能提升学生的分析与设计能力。
- 近似方法的价值在于快速定位问题，仿真用于最终验证。

### 7. **参考文献**
- 引用了经典教材和教学资源，如Gray的《模拟集成电路分析与设计》和课程讲义。

### 关键贡献
- 通过具体案例展示了OCTC的教学应用。
- 强调了近似方法在电路设计中的实用性，以及理论与仿真的互补性。

这篇论文为工程教育提供了一种高效的教学方法，帮助学生掌握复杂电路分析的简化技巧。
```

## OCTC Method

设线性电路中仅有电容作为储能元件 (无电感)，系统零点可以忽略 (零点频率高)，且第一极点可视为主极点 ($\omega_{p1} \ll \omega_{p2}, ..., \omega_{pn}$)，则系统的 -3dB 截止频率为：

$$
\begin{gather}
\omega_{p1} \approx \frac{1}{R_1 C_1 + R_2 C_2 \cdots + R_r C_r}
\end{gather}
$$

其中 $C_1, ..., C_r$ 为系统中的全部电容，$R_1, ..., R_r$ 为电容两端的等效电阻 (将其它电容置零)。

## Method Proof

>论文中并没有给出定理的证明过程，读者可在其他论文中找到。我们这里参考 *Design of Analog CMOS Integrated Circuits (Razavi) (2nd edition, 2017)* page-210.

设系统含有 $m$ 个零点 $z_1, ..., z_m$ 和 $n$ 个极点 $p_1, ..., p_n$, 假设零点频率很高，可以忽略不计，则系统传递函数近似写为：

$$
\begin{align}
H(s) 
&= A \cdot \frac{(1 - \frac{s}{z_1}) \cdots (1 - \frac{s}{z_m})}{(1 - \frac{s}{p_1}) \cdots (1 - \frac{s}{p_n})} 
\\
&\approx  \frac{A}{(1 - \frac{s}{p_1}) \cdots (1 - \frac{s}{p_n})} 
\\
&= \frac{A}{D(s)}
\\
D(s) 
&= \left(1 + \frac{s}{\omega_{p1}}\right) \left(1 + \frac{s}{\omega_{p2}}\right)\cdots \left(1 + \frac{s}{\omega_{pn}}\right) 
\\
&= 1 + s \left(\frac{1}{\omega_{p1}} + \frac{1}{\omega_{p2}} + \cdots \frac{1}{\omega_{pn}}\right) + H.O.T(s) 
\\
&= 1 + B(s) + H.O.T(s)\\
\end{align}
$$

其中 $D(s)$ 表示 denominator, H.O.T 表示 higher order terms. 另一方面，依次只留一个电容 (将其它电容置零), 使得系统降为一阶系统 (分母也是一阶), 利用 Node-Pole Theorem 可以证明, 对只有电容作为储能元件 (动态元件) 的任意线性电路，分母中 $s$ 的系数为：

$$
\begin{gather}
B(s) = R_1 C_1 + R_2 C_2 \cdots + R_r C_r
\end{gather}
$$

其中 $C_1, ..., C_r$ 为系统中的全部电容，$R_1, ..., R_r$ 为电容两端的等效电阻 (其它电容置零)。两式结合得到：

$$
\begin{gather}
R_1 C_1 + R_2 C_2 \cdots + R_r C_r = \frac{1}{\omega_{p1}} + \frac{1}{\omega_{p2}} + \cdots \frac{1}{\omega_{pn}}
\end{gather}
$$

当 $|p_1| \ll |p_2|, ..., |p_n|$ 时, 右侧退化为 $\frac{1}{\omega_{p1}}$, 得到最终的近似式：

$$
\begin{gather}
\omega_{p1} \approx \frac{1}{R_1 C_1 + R_2 C_2 \cdots + R_r C_r}
\end{gather}
$$

这便证明了 OCTC (The Open-Circuit Time Constant Method)。

## Useful Observation

下面是一个阻抗计算的常用结论：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-07-01-01-25_Open-Circuit Time Constant Method.png"/></div>

例如分析 MOS 电容 $C_{GD}$ 的等效阻抗时，便可以直接利用上面的结论。

另外一个常用的结论是从 GS 端看入的阻抗，结论为：

$$
\begin{gather}
R_{GS} = \frac{R_G + R_S \parallel r_O}{1 + g_m (R_S \parallel r_O)}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-00-17-55_Open-Circuit Time Constant Method.png"/></div>
（图片来自知乎“模集王小桃”）


## Exercise 1

论文中给出了两个例题，我们现在就来完成它们，并给出详细的计算过程。下面是第一个例题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-07-01-05-21_Open-Circuit Time Constant Method.png"/></div>

### DC Analysis

下面计算电路的静态工作点。

$$
\begin{gather}
\begin{cases}\displaystyle
\frac{V_{CC} - V_{B1}}{R_{B1} + R_{B2}} - \frac{I_C}{\beta} = \frac{V_{B1}}{R_{B3}} \\
\left(1 + \frac{1}{\beta}\right)I_C R_{E1} = V_{B1} - 0.7 \ \mathrm{V}
\end{cases}
\Longrightarrow 
\begin{cases}
I_{C1} = 0.976023 \ \mathrm{mA} \\
V_{B1} = 2.956079 \ \mathrm{V} \\
V_{CB1} = 5.1398 \ \mathrm{V}
\end{cases}
\Longrightarrow 
\begin{cases}
I_{C2} = 4.088394 \ \mathrm{mA} \\
V_{B2} = 8.095905 \ \mathrm{V} \\
V_{CB2} = 3.9041 \ \mathrm{V}
\end{cases}
\end{gather}
$$

有了静态工作点之后，便可以计算晶体管的小信号参数：

$$
\begin{gather}
g_{m1} = \frac{I_{C}}{V_T} = \frac{0.976023 \ \mathrm{mA}}{25 \ \mathrm{mV}} = 0.0390 \ \mathrm{S}
,\quad 
g_{m2} = \frac{4.088394 \ \mathrm{mA}}{25 \ \mathrm{mV}} = 0.1635 \ \mathrm{S}
\\
r_{\pi 1} = \frac{\beta}{g_m} = \frac{\beta V_T}{I_C} = \frac{100 \cdot 25 \ \mathrm{mV}}{0.976023 \ \mathrm{mA}} = 5.1228 \ \mathrm{k}\Omega
,\quad 
r_{\pi 2} = \frac{100 \cdot 25 \ \mathrm{mV}}{4.088394 \ \mathrm{mA}} = 1.2230 \ \mathrm{k}\Omega
\\
r_{O1} \approx \infty,\quad r_{O2} \approx \infty
\end{gather}
$$

### AC Analysis

由题意，用 two-cap model 对电路进行分析。计算寄生电容容值：

$$
\begin{gather}
C_{\mu 1} = \frac{C_{jc0}}{\left(1 + \frac{V_{CB}}{V_{0C}}\right)^m} = \frac{8 \ \mathrm{pF}}{\left(1 + \frac{5.1398 \ \mathrm{V}}{0.7 \ \mathrm{V}}\right)^{0.3}} = 4.2335 \ \mathrm{pF}
,\quad 
C_{\mu 2} = \frac{8 \ \mathrm{pF}}{\left(1 + \frac{3.9041 \ \mathrm{V}}{0.7 \ \mathrm{V}}\right)^{0.3}} = 4.5465 \ \mathrm{pF}
\\
C_{\pi 1} = C_{de} + C_{je} = g_m \tau_f + 2 C_{je0} = 0.0390 \ \mathrm{S} \times 400 \ \mathrm{ps} + 2 \times 25 \ \mathrm{pF} = 65.6164 \ \mathrm{pF}
\\
C_{\pi 2} = 0.1635 \ \mathrm{S}\times 400 \ \mathrm{ps} + 50 \ \mathrm{pF} = 115.4143 \ \mathrm{pF}
\end{gather}
$$

然后便可以依据 AC Equivalent 来计算每个电容对应的等效电阻： 

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-07-16-15-12_Open-Circuit Time Constant Method.png"/></div>

$$
\begin{gather}
R_{base2} = r_{\pi 2} + (\beta + 1)(R_{E2} \parallel R_L) = 130.44 \ \mathrm{k}\Omega
\\
\Longrightarrow 
\begin{cases}
R_A = R_S \parallel R_{B2} \parallel R_{B3}\ {\color{red} \parallel r_{\pi 1}} \\
R_B = R_{C}\parallel R_{base2} \\
g_m = g_{m1}
\end{cases}
\\
\Longrightarrow
\begin{cases}
R_{C_{\mu 1}} = R_A + R_B + g_{m}R_A R_B =  109.4144 \ \mathrm{k}\Omega
\\
R_{C_{\mu 2}} = R_C \parallel R_{base2} = 3.8810 \ \mathrm{k}\Omega
\\
R_{C_{\pi 1}} = R_S \parallel R_{B2} \parallel R_{B3}\ \parallel r_{\pi 1} = 691.9435 \ \Omega
\end{cases}
\end{gather}
$$

$R_{C_{\pi 2}}$ 的计算要稍微麻烦一些，我们画出等效电路图进行计算（如下图），可以得到：

$$
\begin{gather}
R_{C_{\pi 2}} = r_{\pi 2} \parallel \frac{R_C}{1 + \left(g_{m2} - \frac{1}{R_C}\right)(R_C \parallel R_L \parallel R_{E2})} = 42.2360 \Omega
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-07-16-23-55_Open-Circuit Time Constant Method.png"/></div>

综上，四个电容及其对应的等效电阻为：

<div class="center"><img width=700px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-07-16-39-27_Open-Circuit Time Constant Method.png"/></div>


用表格可以更清晰地呈现：
<div class='center'>

| Item | $C_{\mu 1}$ | $C_{\mu 2}$ | $C_{\pi 1}$ | $C_{\pi 2}$ |
|:-:|:-:|:-:|:-:|:-:|
 | Capacitance $C$ | 4.2335 pF | 4.5465 pF | 65.6164 pF | 115.4143 pF |
 | Resistance $R$ | 109.4144 kOhm | 3.8810 kOhm | 691.9435 Ohm | 42.2360 Ohm |
 | Time constant $\tau$ | 463.2056 ns | 17.6449 ns | 45.4028 ns | 4.8746 ns |
 | Angular frequency $\omega$ | 2.1589 Mrad/s | 56.6737 Mrad/s | 22.0251 Mrad/s | 205.1433 Mrad/s |
 | Frequency $f$ | 0.3436 MHz | 9.0199 MHz | 3.5054 MHz | 32.6496 MHz |
</div>

### -3dB Frequency

由 OCTC, 可以近似计算出电路的 -3dB 截止频率：
$$
\begin{gather}
f_{\mathrm{-3dB}}^{\mathrm{OCTC}} = \frac{1}{2 \pi} \cdot \frac{1}{\tau_{C_{\mu 1}} + \tau_{C_{\mu 2}} +\tau_{C_{\pi 1}} +\tau_{C_{\pi 2}}} 
= f_{C_{\mu 1}} \parallel f_{C_{\mu 2}} \parallel f_{C_{\pi 1}} \parallel f_{C_{\pi 2}} 
= 299.6546 \ \mathrm{kHz}
\end{gather}
$$

论文中指出 LTspice 的仿真结果是 $f_{\mathrm{-3dB}}^{\mathrm{LTspice}} = 327 \ \mathrm{kHz}$, 两者较为接近。

另外，细心的读者还可以发现，论文中展示时间常数结果时，将 $R_{C_{\mu 2}} C_{\mu 2}$ 和 $R_{C_{\pi 1}} C_{\pi 1}$ 的结果写反了。论文原文如下：

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-07-16-45-00_Open-Circuit Time Constant Method.png"/></div>

我们已向论文作者 Nikolaos Voudoukis 提出反馈，并且得到了对方的回复：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-09-23-44-26_Open-Circuit Time Constant Method.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-09-23-44-52_Open-Circuit Time Constant Method.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-07-16-44-34_Open-Circuit Time Constant Method.png"/></div> -->

### MATLAB Code

本例题的计算借助了 MATLAB 进行，下面是源代码：

``` matlab
if 1    % Problem conditions
    V_CC = 12;
    R_B1 = 30e3;
    R_B2 = 6e3;
    R_B3 = 12e3;
    R_E1 = 2.3e3;
    R_E2 = 1.8e3;
    R_L = 1e3;
    R_C = 4e3;
    R_S = 1e3;
    
    C_jc0 = 8e-12;
    C_je0 = 25e-12;
    m = 0.3;
    V_0C = 0.7;
    tau_f = 400e-12;

    beta = 200;
    V_T = 25e-3;
end

% DC Analysis
syms V_B1 V_B2 V_E1 V_E2 I_C

eq = [
(V_CC - V_B1)/(R_B1 + R_B2) - I_C/beta == V_B1 / R_B3
(1 + 1/beta)*I_C*R_E1 == V_B1 - 0.7
]
[V_B1, I_C1] = solve(eq, [V_B1, I_C]);
V_B1 = double(V_B1)
I_C1 = double(I_C1)

V_B2 = 12 - R_C*I_C1
I_C2 = (V_B2 - 0.7)/R_E2 / (1 + 1/beta)

V_CB1 = V_B2 - V_B1
V_CB2 = 12 - V_B2

% AC Analysis

% Small signal quantities
g_m1 = I_C1/V_T
g_m2 = I_C2/V_T
r_pi1 = beta/g_m1
r_pi2 = beta/g_m2

C_mu1 = C_jc0 / ( 1 + V_CB1/V_0C )^m*10^12  % unit: pF 
C_mu2 = C_jc0 / ( 1 + V_CB2/V_0C )^m*10^12  % unit: pF 
C_pi1 = ( g_m1*tau_f + 2*C_je0 )*10^12  % unit: pF 
C_pi2 = ( g_m2*tau_f + 2*C_je0 )*10^12  % unit: pF 

% resistance calculation
R_base1 = r_pi1;
R_base2 = r_pi2 + (beta + 1) * MyParallel(R_E2, R_L)
R_A = MyParallel_n([R_S, R_B2, R_B3, R_base1]);   % 注意要并联 r_pi1
R_B = MyParallel(R_C, R_base2);
R_C_mu1 = R_A + R_B + g_m1*R_A*R_B
R_C_mu2 = MyParallel(R_C, R_base2)
R_C_pi1 = MyParallel_n([R_S, R_B2, R_B3, R_base1])
%R_C_pi2 = MyParallel(R_C + MyParallel(R_E2, R_L), r_pi2)
tv = 1 + (g_m2 - 1/R_C)*MyParallel_n([R_C, R_L, R_E2]);
R_C_pi2 = MyParallel(R_C/tv, r_pi2)

C = [C_mu1, C_mu2, C_pi1, C_pi2]';

R = [R_C_mu1, R_C_mu2, R_C_pi1, R_C_pi2]';
tau = R.*C/10^(12) * 10^9;
omega = 1./(tau/10^9) / 10^6;
f = omega/(2*pi);
num2str(C, '%.4f')
num2str(R, '%.4f')

disp(' ')
disp(num2str([R, C, tau, omega, f]', '%.4f'))

MyParallel_n(f')*1000
```

## Exercise 2

第一个例题是 CE + CC 结构，由于 CE 中 Miller effect 对 $C_{\mu}$ 的放大作用，放大器截止频率较低。在第二个例题中，我们将 CS 换为了 Cascode 结构 (共射共基)，使得电路截止频率明显提高。下面是电路图：

<!-- 
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-07-01-05-55_Open-Circuit Time Constant Method.png"/></div>
-->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-07-01-06-38_Open-Circuit Time Constant Method.png"/></div>

### DC Analysis

计算静态工作点：

$$
\begin{gather}
\begin{cases}
I_{R_{B3}} = \frac{1}{R_{B3}}\left[\left(1 + \frac{1}{\beta}\right)^2 I_{C3} R_{E1} + 0.7 \ \mathrm{V}  \right]
\\
12 \ \mathrm{V} = I_{R_{B3}} (R_{B1} + R_{B2} + R_{B3}) + \left(\frac{\beta + 1}{\beta^2} I_{C3} + \frac{1}{\beta} I_{C3}\right)R_{B1} + \frac{\beta + 1}{\beta^2} I_{C3}R_{B2}
\end{cases}
\\
\Longrightarrow
\begin{cases}
I_{R_{B3}} = 0.2434 \ \mathrm{mA}
\\
I_{C3} = 0.9560 \ \mathrm{mA}
\end{cases}
\\
\begin{cases}
I_{C1} = \left(1 + \frac{1}{\beta}\right)I_{C3} = 0.9608 \ \mathrm{mA}\\
V_{CB1} = \left(I_1 + \frac{\beta + 1}{\beta^2}I_{C3}\right)R_{B2} - 0.7 \ \mathrm{V} = 0.7893 \ \mathrm{V}
\end{cases}
,\quad 
\begin{cases}
I_{C2} = 4.1326 \ \mathrm{mA}\\
V_{CB2} = 3.8241 \ \mathrm{V}
\end{cases}
,\quad 
\begin{cases}
I_{C3} = 0.9560 \ \mathrm{mA}\\
V_{CB3} = 3.7657 \ \mathrm{V}
\end{cases}
\end{gather}
$$

计算晶体管的小信号参数：

$$
\begin{gather}
\begin{cases}
g_{m1} = 0.0384\ \mathrm{S}\\
r_{\pi 1} = 5.2039\ \mathrm{k}\Omega
\end{cases}
,\quad 
\begin{cases}
g_{m2} = 0.1653\ \mathrm{S}\\
r_{\pi 2} = 1.2099\ \mathrm{k}\Omega
\end{cases}
,\quad 
\begin{cases}
g_{m3} = 0.0382\ \mathrm{S}\\
r_{\pi 3} = 5.2300\ \mathrm{k}\Omega
\end{cases}
\end{gather}
$$


### AC Analysis


计算寄生电容容值：

$$
\begin{gather}
\begin{cases}
C_{\mu 1} = 6.3786 \ \mathrm{pF} \\
C_{\mu 2} = 4.5705 \ \mathrm{pF} \\
C_{\mu 3} = 4.5883 \ \mathrm{pF}
\end{cases}
,\quad 
\begin{cases}
C_{\pi 1} =  65.3730 \ \mathrm{pF} \\
C_{\pi 2} =  116.1217 \ \mathrm{pF} \\
C_{\pi 3} =  65.2956\ \mathrm{pF}
\end{cases}
\end{gather}
$$

在计算各电容的等效电阻之前，我们先计算几个稍后会用到的电阻值：

$$
\begin{align}
\begin{aligned}
R_{base 1} &= r_{\pi 1} &= 5.2039 \ \mathrm{k}\Omega
\\
R_{base 2} &= r_{\pi 2} + (\beta + 1)(R_{E2} \parallel R_L) &= 1.3042 \ \mathrm{k}\Omega
\\
R_{emit 3} &= \frac{r_{\pi 3}}{\beta + 1} &= 26.0197 \ \Omega
\\
R_A &= R_S \parallel R_{B2} \parallel R_{B3} \parallel R_{base 1} &= 693.4034 \ \Omega
\end{aligned}
\end{align}
$$

$$
\begin{align}
\begin{aligned}
R_{C_{\mu 1}} &= R_A + R_{emit3} + g_{m1}R_A R_{emit3} &= 1.4128 \ \mathrm{k}\Omega \\
R_{C_{\mu 2}} &= R_C \parallel R_{base2} &= 3.8810 \ \mathrm{k}\Omega \\
R_{C_{\mu 3}} &= R_C \parallel R_{base2} &= 3.8810 \ \mathrm{k}\Omega \\
R_{C_{\pi 1}} &= R_A &= 693.4034 \ \Omega \\
R_{C_{\pi 2}} &= r_{\pi 2} \parallel \frac{R_C}{1 + \left(g_{m2} - \frac{1}{R_C}\right)(R_C \parallel R_L \parallel R_{E2})} &= 41.7882 \ \Omega \\
R_{C_{\pi 3}} &= R_{emit3} &= 26.0197 \ \Omega \\
\end{aligned}
\end{align}
$$

### -3dB Frequency

这样，我们可以算出各个电容对应的时间常数，并由此估计 -3dB 带宽：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-07-21-33-28_Open-Circuit Time Constant Method.png"/></div>

$$
\begin{gather}
f_{\mathrm{-3dB}}^{\mathrm{OCTC}} = f_1 \parallel \cdots \parallel f_6 = 1.6503 \ \mathrm{MHz}
\end{gather}
$$

论文中指出, LTspice 仿真所得结果为 $f_{\mathrm{-3dB}}^{\mathrm{LTspice}} = 2.4 \ \mathrm{MHz}$，两者差距比较大，这是因为系统的两个高频极点比较接近, OCTC 的近似效果一般。

## Summary

