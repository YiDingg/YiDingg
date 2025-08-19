# Miller Compensations in Basic Two-Stage Op Amp

> [!Note|style:callout|label:Infor]
Initially published at 18:29 on 2025-06-15 in Beijing.

## Introduction

在常见的两级运放架构中, Miller 补偿是最重要的基础之一。本文将对由 F-OTA + CS 构成的基本两级运放的三种补偿方式进行分析和比较，它们分别是: no compensation, Miller compensation 和 Nulling-Miller Compensation (Miller compensation with nulling resistor)。

我们将给出每一种补偿方式传递函数的具体表达式，并从传函表达式提取出其 DC 增益、零极点分布情况、增益带宽积 (GBW) 和相位裕量 (PM) 等重要参数，由此为运放设计提供直观的理论指导。



## 1. No Compensation

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-23-52-14_Miller Compensation in Basic Two-Stage Op Amp.png"/></div>

## 2. Miller Compensation

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-23-52-36_Miller Compensation in Basic Two-Stage Op Amp.png"/></div>

## 3. Nulling-Miller

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-23-53-06_Miller Compensation in Basic Two-Stage Op Amp.png"/></div>

<!-- ## 4. Negative-Miller
 -->

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

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-23-51-42_Miller Compensation in Basic Two-Stage Op Amp.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-23-51-49_Miller Compensation in Basic Two-Stage Op Amp.png"/></div>


## Reference

- Paper 1: [Design and Analysis of Miller Compensated Two-Stage Operational Amplifier](https://www.ewadirect.com/proceedings/ace/article/view/17296/pdf), 备用链接 [here](https://www.ewadirect.com/proceedings/ace/article/view/17296)
- Paper 2: [Design of Two Stage Miller Compensated CMOS Opamp with Nulling Resistor in 90nm Technology](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10527553), 备用 [here](https://ieeexplore.ieee.org/document/10527553)
- Book: Design of Analog CMOS Integrated Circuits (Razavi) (2nd edition, 2017)
- [知乎 > 模集王小桃: 两级运放的米勒补偿与 Cascode 米勒补偿](https://zhuanlan.zhihu.com/p/10217022358)
- [知乎 > 模集王小桃: Miller 补偿与 Cascode 补偿的比较与仿真](https://zhuanlan.zhihu.com/p/1906792046129311751)
- [知乎 > 模集王小桃: 王小桃带你读文献：两级运放的 Cascode 补偿方法](https://zhuanlan.zhihu.com/p/11681962059)

