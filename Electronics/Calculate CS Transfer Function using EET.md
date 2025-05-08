# Calculate CS Transfer Function using EET


> [!Note|style:callout|label:Infor]
Initially published at 18:53 on 2025-04-07 in Beijing.

## Intro

在先前的内容中 ([Frequency Response of CE and CS Stages](https://zhuanlan.zhihu.com/p/1892732378264339436))，我们使用小信号等效电路对 CS 和 CE 的传递函数进行了求解 (利用 KCL 和 KVL)，是最基本且直接的方法。
在本文，我们将用一种常用的传递函数分析技巧来求解 CS 的传递函数，称为 EET (Extra Element Theorem)，即额外元件定理。

## EET (Extra Element Theorem)

参考资料：
- *Design of Analog CMOS Integrated Circuits (Razavi) (2nd edition, 2016)*, Chapter 6 (Frequency Response) page.206
- R. D. Middlebrook, "Null double injection and the extra element theorem," in IEEE Transactions on Education, vol. 32, no. 3, pp. 167-180, Aug. 1989, doi: 10.1109/13.34149. (https://ieeexplore.ieee.org/document/34149)

下面是 *Razavi CMOS* 关于 EET 的原文：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-00-28-43_Calcu CS Transfer Function using EET.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-00-28-52_Calcu CS Transfer Function using EET.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-00-29-02_Calcu CS Transfer Function using EET.png"/></div>

## Derivation of H using EET

现在，我们便尝试利用 EET 求出 CS 的传递函数 $H(s)$, 并与先前直接列 KCL/KVL 所得结果进行比较：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-00-23-37_Calcu CS Transfer Function using EET.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-00-23-50_Calcu CS Transfer Function using EET.png"/></div>

## Appendix: MATLAB codes

本文使用了 MATLAB 来辅助计算，下面是相关代码：

``` matlab
% Z_in_0
syms V_out V_pi C_L s R_L r_pi g_m C_pi s V_in R_S C_mu C_GS C_GD C_DB C_SB
syms V_x I_x 
re_V_out = (-I_x - g_m*V_x) / (g_m + s*C_DB + 1/R_L)
eq1 = (-V_x)*(1/R_S + s*C_GS) + I_x == V_out*(s*C_GS + 1/R_S)
eq1 = subs(eq1, V_out, re_V_out)
V_x = solve(eq1, V_x)
Z_in_0 = simplifyFraction(V_x/I_x)


% H(s)
Z_out_0 = -1/g_m
H_0 = -(g_m*R_L)/(1+s*R_L*C_DB) * 1/(1+s*R_S*C_GS)
Z = 1/(s*C_GD)
H = H_0 * (1 + Z_out_0/Z) / (1 + Z_in_0/Z);
H = simplifyFraction(H)
[numerator, denominator] = numden(H) % 提取分子和分母
% 提取 zero 和 denominator 的 As^2 + Bs + C
zero = solve(numerator) % 求出 zero
C = subs(denominator, s, 0)
B = subs(expand( (denominator - C)/s ), s, 0)
A = subs(expand( denominator/s^2 ), s, inf)
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-00-34-06_Calculate CS Transfer Function using EET.png"/></div>

## References

- *Design of Analog CMOS Integrated Circuits (Razavi) (2nd edition, 2016)*, Chapter 6 (Frequency Response) page.206
- R. D. Middlebrook, "Null double injection and the extra element theorem," in IEEE Transactions on Education, vol. 32, no. 3, pp. 167-180, Aug. 1989, doi: 10.1109/13.34149. (https://ieeexplore.ieee.org/document/34149)
