# Correction of the AC Gain Equation in the ADI Op Amp Measurement Methods

> [!Note|style:callout|label:Infor]
Initially published at 16:13 on 2025-05-28 in Beijing.

## Introduction

关于如何测量运算放大器的基本参数，例如 $V_{OS},\ I_{B\pm}$ 和开环增益 $A_v$ 等，相信大家一定看过广为流传的 [ADI: Simple Op Amp Measurements](https://www.analog.com/media/en/analog-dialogue/volume-45/number-2/articles/simple-op-amp-measurements.pdf), 也就是下面这篇文章：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-28-22-57-03_Correction of the AC Gain Equation in the ADI Op Amp Measurement Methods.png"/></div>

文中对运放的一些基本参数给出了测量方法和公式，并统一到一个电路中，为系统测量提供了便利。然而，在我自己的实际测量过程中（详见 [Basic Op Amp Measurement Board v2](<ElectronicDesigns/Basic Op Amp Measurement Board v2.md>)），发现测量得到的运放低频增益与实际值有较大差异。经过仔细分析，我们找到了误差来源，并对原开环增益的计算公式作了修正。



## The Original Gain Equation

下面这一段摘自我们之前写的 ADI 运放测试方法解读，也即文章 [Op Amp Measurement Methods](<Electronics/Op Amp Measurement Methods.md>), ADI 给出的原始公式为：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-28-23-09-17_Correction of the AC Gain Equation in the ADI Op Amp Measurement Methods.png"/></div>

不代入电阻值时，公式为：

$$
\begin{gather}
A_{OL} = \left(1 + \frac{R_9}{R_1}\right) \cdot \frac{v_{TP2,amp}}{v_{IN,amp}}
\end{gather}
$$

## The Corrected Gain Equation

事实上，在低频时（比如 $10 \ \mathrm{Hz} \sim 1\ \mathrm{kHz}$），输入电容会对测量结果产生较大影响，因此我们考虑将原式修正为：

$$
\begin{cases}
v_{out} = v_{TP2} = A_v v_{eff}
\\
v_{eff} = 0 - \frac{R_1}{R_1 + R_9 + \frac{1}{j \omega C_3}} \cdot  v_{acin} 
\end{cases}
\Longrightarrow 
\\
A_{v} 
    = \frac{R_1 + R_9 + \frac{1}{j\omega C_3}}{R_1}\times \left(- \frac{v_{out}}{v_{acin}}\right) 
    = \left(1 + \frac{R_9}{R_1} + \frac{1}{j 2 \pi f R_1 C_3}\right) \times \left(- \frac{v_{TP2}}{v_{acin}}\right)
$$

## Precision Analysis

上面的分析中，我们忽略了 AUX 运放和另一个反馈环路 R2, R3 的影响，认为 DUT 在 AC input 下处在开环状态。这样的假设是否成立？或者说，此假设带来的误差是多少？这是我们真正感兴趣的问题，下面便来作具体的推导。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-28-23-35-45_Correction of the AC Gain Equation in the ADI Op Amp Measurement Methods.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-28-23-35-54_Correction of the AC Gain Equation in the ADI Op Amp Measurement Methods.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-28-23-36-04_Correction of the AC Gain Equation in the ADI Op Amp Measurement Methods.png"/></div>

最终结论就是，公式 $A_v = \left(1 + \frac{R_9}{R_1} + \frac{1}{j 2 \pi f R_1 C_3}\right) \times \left(- \frac{v_{TP2}}{v_{acin}}\right)$ 可以在相当宽的频率范围内有很高的精度，因此具有较大的实际价值。

本文借助了 MATLAB 辅助推导公式，具体代码如下：

``` matlab
%% 20250528 ADI op amp 测量方法修正

syms v_out1 A_1 v_out2 R_2 R_3 v_1 omega R_4 A_2 C_1 R_1 R_9 C_3 v_in s

% 代入具体数值
if 0
C_3 = 10e-9;
R_9 = 51e3;
R_1 = 100;
R_2 = 100;
R_3 = 100e3;
R_4 = MyParallel(20, 20);
C_1 = 10e-6;
end

eq1 = v_1 == R_1 / (R_1 + R_9 + 1/(s*C_3)) * v_in
eq2 = v_out1 == A_1 * ( v_out2/(1+R_3/R_2) - v_1 )
eq3 = (v_out1 + v_out2/A_2) / R_4 == (-v_out2/A_2 - v_out2) / (1/s*C_1)
re_v_out2 = solve(eq2, v_out2)
eq3 = subs(eq3, v_out2, re_v_out2);
re_v_out1 = solve(eq3, v_out1);
re_v_out1 = simplifyFraction(re_v_out1)
re_v_out1_dividedBy_v_1 = simplify(re_v_out1/v_1)

limit(re_v_out1_dividedBy_v_1, A_2, inf)
simplify(subs(re_v_out1_dividedBy_v_1, A_2, A_1))
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-29-00-05-49_Correction of the AC Gain Equation in the ADI Op Amp Measurement Methods.png"/></div>

