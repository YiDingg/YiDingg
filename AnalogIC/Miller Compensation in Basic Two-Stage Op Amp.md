# Miller Compensations in Basic Two-Stage Op Amp

> [!Note|style:callout|label:Infor]
Initially published at 18:29 on 2025-06-15 in Beijing.

## Introduction

Miller 补偿是运放设计最重要的基础之一。本文将对 **F-OTA + CS** 基本两级运放的 **三种补偿方式** 进行分析和比较，它们分别是：
- (1) no compensation
- (2) Miller compensation
- (3) nulling-Miller compensation (Miller compensation with nulling resistor)

我们将给出每一种补偿方式 **传递函数** 的具体表达式，并从传函表达式提取出其 **DC 增益、零极点分布情况、增益带宽积 (GBW) 和相位裕量 (PM)** 等重要参数，由此为运放设计提供直观的理论指导。



## 1. Five-OTA

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-23-52-14_Miller Compensation in Basic Two-Stage Op Amp.png"/></div>

五管 OTA 的传递函数与频响参数如下：

$$
\begin{gather}
A_{v}(s)=\frac{g_{mN}r_{ON}(2g_{mP}+sC_{E})r_{OP}}{2s^{2}r_{OP}r_{ON}C_{E}C_{L}+s\left[(2r_{ON}+r_{OP})C_{E}+(1+2g_{mP}r_{ON})r_{OP}C_{L}\right]+2g_{mP}(r_{ON}+r_{OP})}
\\
\omega_{p1} \approx \frac{1}{(r_{ON}\parallel r_{OP})C_L},\ \ \omega_{p2}\approx \frac{g_{mP}}{C_E},\ \ \omega_{z} \approx \frac{2g_{mP}}{C_E}
\\
A_{v0} = g_{m1}(r_{O1}\parallel r_{O3}),\ \  \mathrm{GBW}_{\omega} = A_{v0}\cdot \omega_{p1} = \frac{g_{m1}}{C_L}
\end{gather}
$$

## 2. Miller Compensation

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-23-52-36_Miller Compensation in Basic Two-Stage Op Amp.png"/></div>

$$
\begin{gather}
A_{v}(s)=\frac{g_{m1}R_{1}\cdot g_{m6}R_{2}\cdot(1-\frac{sC_{c}}{g_{m6}})}{s^{2}R_{1}R_{2}(C_{L1}C_{L2}+C_{c}C_{L1}+C_{c}C_{L2})+s[R_{1}C_{L1}+R_{2}(C_{L2}+C_{c})+(1+g_{m6}R_{2})R_{1}C_{c}]+1}
\\
p_1 \approx -\frac{1}{g_{m6}R_2 R_1 C_c}  = - \frac{g_{m1}}{A_{v0}C_c},\ \ 
p_2 \approx -\frac{g_{m6}}{C_{L2}},\ \ 
z \approx \color{red}{+} \frac{g_{m6}}{C_c}
\\
\mathrm{GBW}_{\omega} = A_{0}\cdot \omega_{p1} = \frac{g_{m1}}{C_{c}},\ \ \frac{\omega_z}{\mathrm{GBW}_{\omega}} = \frac{g_{m6}}{g_{m1}}
\end{gather}
$$





## 3. Nulling-Miller

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-23-53-06_Miller Compensation in Basic Two-Stage Op Amp.png"/></div>


$$
\begin{gather}
\begin{aligned}&A_{v(s)}=g_{m}g_{mb}R_{1}R_{2}\cdot\frac{1-\frac{s}{z}}{As^{2}+Bs^{2}+Cs+1} ,\ \mathrm{where:}\\
&Z=\frac{g_{mb}}{C_{c}(1-g_{mb}R_{z})}\quad\mathrm{and}\quad
\begin{cases}
A=R_{1}R_{2}R_{2}C_{L1}C_{L1}C_{c}\\
B=R_{1}R_{2}(C_{L1}C_{L2}+C_{c}C_{L1}+C_{c}C_{L2})+(R_{1}C_{L1}+R_{2}C_{L2})R_{z}C_{c}\\
C=R_{1}C_{L1}+R_{2}(C_{L2}+C_{c})+(1+g_{m6}R_{2})R_{1}C_{c}+R_{z}C_{c}&
\end{cases}\end{aligned}
\\
p_1 \approx - \frac{g_{m1}}{A_{v0}C_c},\ \ 
p_2 \approx - \frac{g_{m6}}{C_{L2}},\ \ 
p_3 \approx - \frac{1}{R_z C_c}\left(1 + \frac{C_c}{C_{L1}} + \frac{C_c}{C_{L2}}\right),\ \ 
z \approx \color{red}{+} \frac{g_{m6}}{C_c (1 - g_{m6}R_z)}
\end{gather}
$$

相比于普通的 Miller 补偿，引入 nulling-resistor 后极点 $p_1,\ p_2$ 的位置几乎不变，但是产生了一个新的高频极点 $p_3$，同时零点 $z$ 的位置也有变化。一般情况下我们会设置 $C_c$ 的值使 $p_2$ 和 $z$ 相互抵消，最起码也要将 $z$ 的位置调整到左半平面。

(下图源自 “模集王小桃”)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-01-13-52-07_Miller Compensation in Basic Two-Stage Op Amp.png"/></div>

如图所示，随着 $R_z$ 从 0 接近 $\frac{1}{g_{m6}}$，右半平面零点 $z$ 趋向于无穷大；$R_z$ 继续增大，零点出现在左半平面，并向原点 (向右) 移动。如果令 $z$ 和 $p_2$ 恰好抵消，解得：

$$
\begin{gather}
R_z = \left(1 + \frac{C_{L2}}{C_c}\right) \frac{1}{g_{m6}}
\end{gather}
$$



## Appendix: MATLAB Code

本文的部分公式利用了 MATLAB 辅助计算，源码如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-01-58-00_Miller Compensation in Basic Two-Stage Op Amp.png"/></div>

```matlab
%% 2025.06.15 Two-Stage 传函分析

% 1. F-OTA 传函分析
syms g_m1 r_O1 g_m3 r_O3 s C_E C_L A_v C_c A_v1 A_v2 g_m6 r_O6 r_O7 R_1 R_2 C_L1 C_L2
A_v = g_m1*r_O1*(2*g_m3 + s*C_E)*r_O3 / (...
    2*s^2*r_O1*r_O3*C_E*C_L + s * ( (2*r_O1+r_O3)*C_E + r_O3*(1+2*g_m3*r_O1)*C_L ) + 2*g_m3*(r_O1 + r_O3)   ...
    )
stc = MyAnalysis_TransferFunction(A_v, 1);


% 2. adding cs stage (C_c = 0):
A_v1 = stc.H_0/(1 + s)

% 2. Miller
%A_v_noCom = subs(A_v, C_c, 0)
A_v = g_m1*R_1*g_m6*R_2*(1 - s*C_c/g_m6) / (...
      s^2 * R_1*R_2*(C_L1*C_L2 + C_c*C_L2 + C_c*C_L1) ...
    + s^1 * ( R_1*C_L1 + R_2*(C_L2 + C_c) + (1 + g_m6*R_2)*(R_1*C_c) ) ...
    + s^0 * 1 ...
    )
stc = MyAnalysis_TransferFunction(A_v, 1);


% 3. nulling-Miller
syms R_z
A_v = simplify(subs(A_v, C_c, C_c/(1 + s*R_z*C_c)));
stc = MyAnalysis_TransferFunction(A_v, 1);

% As^3 + Bs^2 + Cs + 1 推导:
syms p_1 p_2 p_3
eq = (1 - s/p_1)*(1 - s/p_2)*(1 - s/p_3)
eq = expand(eq)
```

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-23-51-42_Miller Compensation in Basic Two-Stage Op Amp.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-23-51-49_Miller Compensation in Basic Two-Stage Op Amp.png"/></div>
 -->

## Reference

- [[1]](https://www.ewadirect.com/proceedings/ace/article/view/17296) [Design and Analysis of Miller Compensated Two-Stage Operational Amplifier](https://www.ewadirect.com/proceedings/ace/article/view/17296/pdf)
- [[2]](https://ieeexplore.ieee.org/document/10527553) [Design of Two Stage Miller Compensated CMOS Opamp with Nulling Resistor in 90nm Technology](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10527553)
- [[3] Design of Analog CMOS Integrated Circuits (Razavi) (2nd edition, 2017)](https://www.zhihu.com/question/452068235/answer/95164892409)
- [知乎 > 模集王小桃: 两级运放的米勒补偿与 Cascode 米勒补偿](https://zhuanlan.zhihu.com/p/10217022358)
- [知乎 > 模集王小桃: Miller 补偿与 Cascode 补偿的比较与仿真](https://zhuanlan.zhihu.com/p/1906792046129311751)
- [知乎 > 模集王小桃: 王小桃带你读文献：两级运放的 Cascode 补偿方法](https://zhuanlan.zhihu.com/p/11681962059)

