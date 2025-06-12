# Detailed Explanation of Classic Op Amp uA741 (经典运放 uA741 原理详解)

> [!Note|style:callout|label:Infor]
Initially published at 16:00 on 2025-05-14 in Beijing.


## Background

起因是“线性电路实验”课程的第六、七次实验 (2025.05.16, 2025.05.23) 的主题是用分立元件设计运算放大器，我们一共设计了三个运放电路，前两个是比较简单的 two-stage CMOS op amp (cs output 和 pp output), 第三个便是 discrete uA741, 也是设计过程最详细的一个（前两个只是简单验证了一下）。

运放设计结果详见 [μA741 using Discrete BJTs (SOT-23)](<ElectronicDesigns/μA741 using Discrete BJTs (SOT-23).md>) 和 [Basic CMOS Op Amp using Discrete MOSFETs](<ElectronicDesigns/Basic CMOS Op Amp using Discrete MOSFETs.md>)。具体的实验报告见 [GitHub > YiDingg > UCAS-LinearCircuitExperiment](https://github.com/YiDingg/UCAS-LinearCircuitExperiment) 的 [《LCE-06-07 运放设计》](https://github.com/YiDingg/UCAS-LinearCircuitExperiment/tree/main/LCE-06-07-%E8%BF%90%E6%94%BE%E8%AE%BE%E8%AE%A1)。

由于报告的主要内容采用了英文进行撰写，为了方便读者学习，我们在这里用中文重新讲解一遍 uA741 的具体原理，并将实验报告原文（的部分截图）附在文末。


## Explanation of uA741

### Intro

作为 BJT 时代最经典的运算放大器之一, 近年来我们所看到的 uA741, 或者其它 741 系列运放 (例如 LM741), 或多或少都已经过一些改进， uA741 最初发行时的电路图（原理图）已经很难找到了。因此，在本文，我们以市面上常见的 uA741 型号为参考，给出 discrete uA741 的原理图，并对给出的电路作详细分析，如果有时间，进一步讨论其优化空间。




### Discrete uA741

我们给出的 discrete uA741 与 TI (德州仪器) 的原理图基本一致，只是修改了部分电阻为常见阻值，同时在输入段添加了两个二极管以调整直流电压偏置。如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-14-17-04-37_Detailed Explanation of uA741.png"/></div>

注：
- NPN 全部使用 MMBT3904 (2N3904 的 SOT-23 贴片版)，PNP 全部使用 MMBT3906 (2N3906 的 SOT-23 贴片版)
- 电阻全部使用 1% 精度的 0603 贴片电阻
- 补偿电容建议使用直插独石电容，如果要使用贴片 MLCC, 请至少使用原容值 1.5 倍的电容 (因为 MLCC 的偏压效应会使等效容值明显下降), 也即选用 30pF $\times$ 1.5 = 45pF 以上的电容 (我们在实际焊接中选择了 47 pF)。

### Diagram and Explanation

下面，我们就来一步步剖析 uA741 的工作原理。第一步便是将电路图中的每个模块进行拆分，如下图：

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-14-17-12-58_Detailed Explanation of uA741.png"/></div>

### Biasing Analysis 

先分析运放的直流工作点，也就是偏置电路。 Q3、R1 和 Q19 是整个运放的基础偏置，产生的电流为 $ I_0 = \frac{V_{CC} - 1.4 \, \mathrm{V}}{R_1} = \frac{V_{CC} - 1.4 \, \mathrm{V}}{39 \, \mathrm{k}\Omega} $。利用生成的 $I_0$, R11, Q18 和 Q19 和构成微安电流源，所 copy 的电流满足以下方程：


$$
\begin{gather}
I_1 \approx \frac{V_T}{R_{11}} \ln \left( \frac{I_{REF}}{I_1} \right) \iff I_{REF} = I_1 \cdot e^{\frac{R_{11} I_1}{V_T}}, \quad I_{REF} = I_0
\end{gather}
$$

由于 $ I_{REF} $ 随 $ I_1 $ 的变化呈指数关系，因此在$I_{REF}$ 变化时， $ I_1 $ 可以保持相对稳定，整体变化不大。我们设 $ V_T = 26 \, \mathrm{mV} $，绘制 $ I_1 = I_1 (I_{REF}) $ 曲线如下图所示：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-14-17-27-04_Detailed Explanation of uA741.png"/></div>

由上图可以看出，当电源电压在 10V 至 40V 之间变化时，$ I_1 $ 的变化范围在 15μA 和 22μA 之间。在后续分析中，我们假设 $ I_1 = 20 \, \mathrm{μA} $ 。

值得注意的是，Q6 和 Q10 的组合 (CC-CB 结构) 可等效地视为一种高性能 PNP 晶体管。因此，基于 Q18 的电流 $ I_1 $, Q1, Q2 和输入模块共同构成威尔逊镜像电流源 (Wilson current source)，将 $ I_1 $ 复制到输入级，由此为输入级提供偏置。另一方面，Q4 从 Q3 的基极复制电流 $ I_1 $，从而定义 Q4 以及 Q13 + Q17 的工作点 (Q13 和 Q17 构成达林顿 NPN 管)。

我们利用 LTspice 仿真来验证上面的结论：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-14-17-40-17_Detailed Explanation of uA741.png"/></div>

设置运放为 unit buffer 模式 ($V_{IN-}$ 与 $V_{out}$ 短接)，$V_{CC} = 24 \ \mathrm{V},\ V_{IN+} = V_{IN-} = 12 \ \mathrm{V}$, 仿真结果给出：

$$
\begin{gather}
    |I_{C,Q3}| = I_{C,Q19} = 0.58 \ \mathrm{mA},\quad 
    |I_{C,Q2}| = I_{C,Q18} = 20.21 \ \mathrm{uA},\ 
    |I_{C,Q1}| = 13.31 \ \mathrm{uA},\ 
    |I_{C,Q4}| = 0.82 \ \mathrm{mA}
\end{gather}
$$





### Small-Signal Analysis

R8, R9, R10 和 Q12, Q15, Q16 共同构成了威尔逊镜像电流源 (Wilson current mirror), 作为差分输入级的有源负载，利用镜像电流源将差分输入转化为单端输出。记威尔逊镜像电流源表现出的小信号电阻为 $r_{out1}$, 则有：

$$
\begin{align}
    r_{out1} &\approx R_{coll} 
    \\
    &= r_O \left[1 + \left(\frac{\beta}{r_{\pi} + R_B} + \frac{1}{r_O}\right)\cdot \left(R_E \parallel (r_{\pi} + R_B)\right)\right] 
    \\ 
    &\approx r_O + (1 + g_m r_O) (R_E \parallel r_{\pi})\quad {\color{gray} (R_B = 0)}
    \\ 
    &\approx r_O + (1 + g_m r_O)R_E \quad {\color{gray} (r_{\pi} = \frac{\beta V_T}{I_C} \gg R_E = 1\ \mathrm{k}\Omega)}
\end{align}
$$

上式中的 $r_O$ 表示 Q15 或 Q16 的厄利电阻，也即 $r_{O} = r_{O,Q15} = \frac{V_{AN}}{I_{C,Q15}}$，$V_{AN}$ 表示 NPN 管的厄利电压。利用 "half-circuit" 方法，可以计算输入级（第一级）的增益：

$$
\begin{gather}
G_{m1} \approx - \frac{g_{mP}}{1 + \frac{g_{mP}}{g_{mN}}} = - (g_{mP} \parallel g_{mN}),\ 
R_{out1} \approx \left[ r_{OP} + (1 + g_{mP}r_{OP})\frac{1}{g_{mN}} \right] \parallel \left[r_{ON} + (1 + g_{mN} r_{ON})R_E\right]
\\ 
A_{v1} \approx -(g_{mP} \parallel g_{mN}) \cdot \left[ r_{OP} + (1 + g_{mP}r_{OP})\frac{1}{g_{mN}} \right] \parallel \left[r_{ON} + (1 + g_{mN} r_{ON})R_E\right]
\end{gather}
$$

其中 $R_E = r_{out1} = R_2 = 1\ \mathrm{k}\Omega$, $g_{mP} = g_{mN} = \frac{I_C}{V_T}$, $r_{ON} = \frac{V_{AN}}{I_C}$, $r_{OP} = \frac{V_{PN}}{I_C}$. 假设 $V_{AN} = 100 \ \mathrm{V}$, $V_{PN} = 50 \ \mathrm{V}$, $I_C = 13 \ \mathrm{uA}$，我们有：

$$
\begin{gather}
G_{m1} = - 0.2500 \ \mathrm{mS},\ R_{out1} = 557.11 \ \mathrm{k}\Omega,\quad 
A_{v1} = -1392.8
\end{gather}
$$

对于第二级，我们要计算其输入电阻和小信号增益。两个 NPN 管构成了达林顿 NPN, 其等效模型为：

$$
\begin{gather}
\beta_{eq} = \beta_{Q13} \cdot \beta_{Q17} + \beta_{Q13} + \beta_{Q17},\quad 
g_{m,eq} \approx \frac{\beta_{Q17}}{2}g_{m,Q13} \approx \frac{1}{2}g_{m,Q17}
\\
r_{\pi,eq} \approx 2 \beta_{Q13} r_{\pi,Q17},\quad 
r_{O,eq} \approx \frac{g_{m,Q13}r_{O,Q13}}{\beta_{Q13} - 1}\cdot r_{\pi,Q17} + r_{O,Q17}
\end{gather}
$$

然后便可以计算第二级的小信号参数：

$$
\begin{gather}
G_{m2} \approx \frac{1}{R_E + \frac{1}{g_{m,eq}} \parallel r_{O,eq}},\ 
R_{out2} \approx r_{O4} \parallel \left[r_{O,eq} + (1 + g_{m,eq}r_{O,eq})(R_E \parallel r_{\pi,eq})\right],\ 
R_E = R_9 = 51\ \Omega
\\ A_{v2} = - G_{m2}R_{out2} \approx \frac{1}{R_E + \frac{1}{g_{m,eq}} \parallel r_{O,eq}} \cdot r_{O4} \parallel \left[r_{O,eq} + (1 + g_{m,eq}r_{O,eq})(R_E \parallel r_{\pi,eq})\right]
\\ 
R_{in2} = r_{\pi,eq} + R_E \cdot \frac{\beta_{eq}r_{O,eq} + r_{O,eq} + r_{O4}}{R_E + r_{O,eq} + r_{O4}}
\end{gather}
$$

假设 $\beta = 100$ 和 $I_{C,Q17} = 0.7 \ \mathrm{mA}$，代入计算得：

$$
\begin{gather}
G_{m2} = 7.9830 \ \mathrm{mS},\quad R_{out2} = 82.887 \ \mathrm{k}\Omega,\quad A_{v2} = - 661.6825,\quad R_{in2} = 1.1287 \ \mathrm{M}\Omega
\\ 
\Longrightarrow 
|A_v| = A_{v1}\cdot \frac{R_{in2}}{R_{in2} + R_{out1}}A_{v2} \cdot A_{v3} \approx 1.5525 \times 10^5 = 103.8209 \ \mathrm{dB} = 155 \ \mathrm{mV/V}
\\ 
R_{in} = R_{base,Q6} \approx r_{\pi,Q6} + (\beta + 1)(R_{emit,Q10} \parallel r_{\pi, Q6}) = 0.7716 \ \mathrm{M}\Omega,\quad 
R_{in,DM} = 2 R_{in} = 1.5431 \ \mathrm{M}\Omega
\end{gather}
$$

上面的计算结果与数据手册 [(TI: The Datasheet of μA741)](https://www.ti.com/cn/lit/ds/symlink/ua741.pdf) 中的相近，数据手册中给出的是 $A_v = 200\ \mathrm{mV/V}\ (> 20 \ \mathrm{mV/V})$ 以及 $R_{in,DM} = 2 \ \mathrm{M}\Omega\ (> 0.3 \ \mathrm{M}\Omega)$.

本小节的计算借助了 MATLAB 进行，源码如下：

``` matlab
20250513 uA741 理论计算
% 1st stage
V_AN = 100;
V_AP = 70;
I_C = 13e-6;
V_T = 26e-3;
R_E = 1e3;

r_ON = V_AN/I_C
r_OP = V_AP/I_C
g_mN = I_C/V_T
g_mP = I_C/V_T

G_m1 = MyParallel(g_mN, g_mP)
G_m1*1000
R_1 = r_OP + (1+g_mP*r_OP)/g_mN;
R_2 = r_ON + (1 + g_mN*r_ON)*R_E;
R_out1 = MyParallel(R_1, R_2)
A_v1 = G_m1 * R_out1

% 2nd stage
beta = 100;
I_C = 0.7e-3;
g_m2 = I_C/V_T
r_pi2 = beta/g_m2
r_O2 = V_AN/I_C
r_O4 = V_AP/I_C

beta_Eq = beta*(beta + 2)
g_m_eq = g_m2/2
r_O_eq = (V_AN/V_T)/(beta - 1)*r_pi2 + r_O2
r_pi_eq = 2*beta*r_pi2
R_E = 51;

G_m2 = 1 / (R_E + MyParallel(1/g_m_eq, r_O_eq))
G_m2*1000
R_out2 = MyParallel( r_O4, r_O_eq + (1 + g_m_eq*r_O_eq)*MyParallel(R_E, r_pi_eq) )
A_v2 = G_m2*R_out2
R_in = r_pi_eq + R_E * (beta_Eq*r_O_eq + r_O_eq + r_O4) / (R_E + r_O_eq + r_O4)

% overall
A_v = A_v1*R_in/(R_in + R_out1)*A_v2
A_v_dB = 20*log(A_v)/log(10)

% input resistance
I_C = 13e-6;
r_pi = beta*V_T/I_C
R_L = R_1
R_emit_Q10 = (1 + R_L/r_OP) * MyParallel( r_pi / (beta + 1 + R_L/r_OP), r_OP )
R_in = r_pi + (beta + 1) * MyParallel(R_emit_Q10, r_pi)
2*R_in

10^(83.351729/20)
```



### Frequency Analysis

此部分已经超出了我们的课程范围，读者可参考相关教材或论文 [A computer-aided evaluation of the 741 amplifier](https://ieeexplore.ieee.org/document/1050205)。论文的全引是：

>**Full Citation:**
B. A. Wooley and D. O. Pederson, "A computer-aided evaluation of the 741 amplifier," in IEEE Journal of Solid-State Circuits, vol. 6, no. 6, pp. 357-366, Dec. 1971, doi: 10.1109/JSSC.1971.1050205.

## PCB Verification

| Demo |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-23-11-14-31_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | 
</div>

PCB 版图可以到链接 [Electronic Designs > μA741 using Discrete BJTs (SOT-23)](<ElectronicDesigns/μA741 using Discrete BJTs (SOT-23).md>) 进行下载，供读者参考。



## Experiment Report

以下是 2025.05.24 提交的《LCE-06-07 分立运放设计》实验报告，原文链接在 [GitHub > YiDingg > UCAS-LinearCircuitExperiment (https://github.com/YiDingg/UCAS-LinearCircuitExperiment)](https://github.com/YiDingg/UCAS-LinearCircuitExperiment)。

原文部分截图如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-24-00-13-54_Detailed Explanation of uA741.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-24-00-15-27_Detailed Explanation of uA741.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-24-00-15-37_Detailed Explanation of uA741.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-24-00-15-50_Detailed Explanation of uA741.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-24-00-16-04_Detailed Explanation of uA741.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-24-00-16-16_Detailed Explanation of uA741.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-24-00-17-00_Detailed Explanation of uA741.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-24-00-17-22_Detailed Explanation of uA741.png"/></div>

## Reference Schematic

下面是 uA741 原理图参考链接汇总：
- [TI (德州仪器): Datasheet of µA741](https://www.ti.com/cn/lit/ds/symlink/ua741.pdf)
- [TI (德州仪器): Datasheet of LM741](https://www.ti.com/cn/lit/ds/symlink/lm741.pdf)
- [TI (德州仪器): Datasheet of LM741-MIL](https://www.ti.com/cn/lit/ds/symlink/lm741-mil.pdf)
- [ST (意法半导体): Datasheet of uA741](https://item.szlcsc.com/datasheet/UA741CDT/7583.html)
- [XINBOLE (芯伯乐): Datasheet of uA741](https://item.szlcsc.com/datasheet/UA741CP(XBLW)/24119502.html)
- [HGSEMI (华冠): Datasheet of LM741](https://item.szlcsc.com/datasheet/LM741M%252FTR/331810.html)
- [HTCSEMI (海天芯): Datasheet of uA741](https://item.szlcsc.com/datasheet/HT741ANZ/3217439.html)
- [Rochester Electronics (罗彻斯特): Datasheet of uA741](https://item.szlcsc.com/datasheet/UA741MJ%252FB/4940946.html)



下面是各参考链接给出的原理图：

- [TI (德州仪器): Datasheet of µA741](https://www.ti.com/cn/lit/ds/symlink/ua741.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-15-01-28-12_Detailed Explanation of uA741.png"/></div>

- [TI (德州仪器): Datasheet of LM741](https://www.ti.com/cn/lit/ds/symlink/lm741.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-14-16-47-43_Detailed Explanation of uA741.png"/></div>

- [TI (德州仪器): Datasheet of LM741-MIL](https://www.ti.com/cn/lit/ds/symlink/lm741-mil.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-14-16-51-27_Detailed Explanation of uA741.png"/></div>

- [ST (意法半导体): Datasheet of uA741](https://item.szlcsc.com/datasheet/UA741CDT/7583.html)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-14-16-46-26_Detailed Explanation of uA741.png"/></div>


- [XINBOLE (芯伯乐): Datasheet of uA741](https://item.szlcsc.com/datasheet/UA741CP(XBLW)/24119502.html)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-14-16-45-56_Detailed Explanation of uA741.png"/></div>




- [HGSEMI (华冠): Datasheet of LM741](https://item.szlcsc.com/datasheet/LM741M%252FTR/331810.html?lcsc_vid=FFYKBl1UQVdXBVYAEwVcUFIARlQIUAdXRVddVFNVTgIxVlNSQFNfVV1eRFVXUztW)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-14-16-48-50_Detailed Explanation of uA741.png"/></div>

- [HTCSEMI (海天芯): Datasheet of uA741](https://item.szlcsc.com/datasheet/HT741ANZ/3217439.html)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-14-16-57-11_Detailed Explanation of uA741.png"/></div>

- [Rochester Electronics (罗彻斯特): Datasheet of uA741](https://item.szlcsc.com/datasheet/UA741MJ%252FB/4940946.html)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-14-16-58-20_Detailed Explanation of uA741.png"/></div>

值得一提的是，XINBOLE (芯伯乐), HGSEMI (华冠) 和 HTCSEMI (海天芯) 三家国产公司给出的图片与 TI (德州仪器) LM741 的图片完全一致（一模一样）。
