# A Low-Voltage Bandgap Reference (BGR) achieving xxx ppm/°C in 28nm CMOS Technology

> [!Note|style:callout|label:Infor]
Initially published at 18:56 on 2025-07-14 in Beijing.

## 0. Introduction

本文，我们使用台积电 28nm CMOS 工艺库 `tsmcN28` **(VDD = 0.9 V)** 来完整地设计一个 low-voltage bandgap reference (BGR), 依次完成前仿、版图、后仿等工作。

BGR 的主要优化方向是 PSRR (Power Supply Rejection Ratio) 和温度系数 (其实温度系数不太好优化，一般需要 curvature correction).

## 1. Design Consideration

### 1.1 reference formulas

相关资料：
- [Razavi CMOS - Chapter 12. Bandgap References](<AnalogIC/Razavi CMOS - Chapter 12. Bandgap References.md>)
- [tsmcN28 (TSMC 28nm CMOS Process Library)](<AnalogIC/Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).md>)



本文所用 BGR 架构及主要参考公式如下：

<!-- <div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-00-46-15_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
 -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-18-17-45-51_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

<!--  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-00-50-12_tsmcN28_BGR__scientific_research_practice_1.png"/></div> -->


$$
\begin{gather}
\Delta V_{YX} = V_Y - V_X = V_{OS} + \frac{V_Z}{A_0}
\\
V_{R1} = V_{BE1} - V_{BE2} + \Delta V_{YX} = V_T \ln n + \Delta V_{YX}
\\
I_{D4} = \frac{V_{R1}}{R_1} + \frac{V_Y}{R_2} 
= \frac{1}{R_2} \left[V_{BE1} + \frac{R_2}{R_1} V_T \ln n + \left(1 + \frac{R_2}{R_1}\right)\left(V_{OS} + \frac{V_Z}{A_0} \right) \right]
\\
V_{BG} = a \,I_{D4} R_4 = \frac{a R_4}{R_2} \left[V_{BE1} + \frac{R_2}{R_1} V_T \ln n + \left(1 + \frac{R_2}{R_1}\right)\left(V_{OS} + \frac{V_Z}{A_0} \right) \right]
\\
\frac{\partial V_{BG} }{\partial T } \approx \frac{a R_4}{R_2} \left[ \frac{1}{T}\left(V_{BE1} - (3 + m)V_T - \frac{E_e}{q_e}\right) + \ln n \,\frac{R_2}{R_1}\cdot\frac{k}{q_e} \right] 
\\
\mathrm{PSRR} = a\, g_{m3}R_4 \times \frac{s + \omega_0}{s + (1 + A_0 g_{m3}\Delta R)\omega_0},\ \ \mathrm{zero} = - \omega_0,\ \ \mathrm{pole} = - (1 + A_0 g_{m3}\Delta R)\omega_0
\end{gather}
$$



推导过程：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-01-43-49_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

PSRR 的具体推导过程：

$$
\begin{align}
\mathrm{let\ } &g_{m1} \approx g_{m2},\ g_{m3}\approx g_{m4},\ \mathrm{we\ have:}
\\ 
v_z &= A_v(s) \cdot g_{m3}(v_{DD} - v_z) \cdot \left[\left(1 + \frac{1}{g_{m1}}\right) - \frac{1}{g_{m1}} \parallel R_2\right]
\\
\Longrightarrow v_z & = \frac{A_v(s) g_{m3}\Delta R}{1 + A_v(s) g_{m3}\Delta R} v_{DD}
\\
\mathrm{where\ } \Delta R &= \left[\left(1 + \frac{1}{g_{m1}}\right) - \frac{1}{g_{m1}} \parallel R_2\right] 
\\ &= \frac{g_{m1}^2 R_2^2 R_1}{(1 + g_{m1}R_2)(1 + g_{m1}R_2 + g_{m1}R_1)} 
\\ &\approx R_1 \parallel R_2
\\ \Longrightarrow i_{D4} & = g_{m4}(v_{DD} - v_z) = \frac{g_{m4}v_{DD}}{1 + A_v(s) g_{m3}\Delta R}
\\ i_{BG} & = a\times i_{D4} = \frac{a\, g_{m4}v_{DD}}{1 + A_v(s) g_{m3}\Delta R}
\\ v_{BG} & = i_{BG}  R_4 = \frac{a\, g_{m4}R_4v_{DD}}{1 + A_v(s) g_{m3}\Delta R} 
\\ \Longrightarrow \mathrm{PSRR} &= \frac{v_{BG}}{v_{DD}} = \frac{ a R_4 }{ \frac{1}{g_{m3}} + A_v(s) \Delta R}
\end{align}
$$

代入 $A_v(s) = \frac{A_0}{1 + \frac{s}{\omega_0}}$ (一阶模型)，得到：

$$
\begin{gather}
\mathrm{PSRR} = a\, g_{m3}R_4 \times \frac{s + \omega_0}{s + (1 + A_0 g_{m3}\Delta R)\omega_0},\quad \mathrm{zero} = - \omega_0,\ \mathrm{pole} = - (1 + A_0 g_{m3}\Delta R)\omega_0
\\
\mathrm{PSRR_{DC}} \approx \frac{a R_4}{A_0 \Delta R} \approx \frac{a R_4}{A_0 (R_1 \parallel R_2)},\quad \mathrm{PSRR_{\infty}} = a\, g_{m3} R_4,\quad \mathrm{GBW_{PSRR}} = \frac{\omega_0}{\mathrm{PSRR_{DC}}} = \frac{(A_0 \omega_0) \Delta R}{a R_4}
\end{gather}
$$

**<span style='color:red'> PSRR 越小越好！ </span>** 所以，要想获得更好的 PSRR, 需要：
- **Higher:** $\omega_0,\ A_0,\ \Delta R$
- **Lower:** $(aR_4),\ g_{m3}$

其中可以优化的是 $\omega_0, A_0$ 和 $g_{m3}$, 前两者通过设计高速高增益运放实现，最后一个 $g_{m3}$ 通过降低 MOSFET 的 $a = \frac{W}{L}$ 来实现。


### 1.2. op amp specifications

对运放而言，除了 $(A_0)\omega_0$ 需要较高以外，还需注意运放的输入输出范围。上面已经推导出 $V_{BE1} \approx 710 \ \mathrm{mV}$, 因此运放的共模输入范围至少要满足 $(650 \mathrm{mV},\ 750 \ \mathrm{mV})$, 最好是在 $(600 \mathrm{mV},\ 800 \ \mathrm{mV})$ 甚至 $(550 \mathrm{mV},\ 850 \ \mathrm{mV})$ 的范围内能正常工作。

由于我们的 VDD 只有 0.9 V, 要想使运放在 Vin_CM = 850 mV 仍正常工作，可以考虑用 nmos-input 的 folded op amp 架构。而 Razavi 在 [this paper](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9523469) 中使用的是普通的 nmos-input F-OTA 运放 (28nm CMOS, VDD = 1 V)，我们能否也用它呢？看起来有点悬，毕竟留给我们的 Vds 只有不到 100 mV. 

但 F-OTA 的优势也是明显的：设计和偏置电路都很简单，并且输出范围广。因此我们还是先试试由 F-OTA + CS 构成的普通两级运放, 也就是 the basic two-stage op amp with nulling-Miller compensation. 有了先前的经验 [this article](<AnalogICDesigns/tsmc18rf_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.md>), 相信这一次设计会高效很多。

为了确定 op amp 的 spec, 一方面我们需要考虑刚刚提到的优化方向，另一方面还需要关注 28nm 工艺的性能极限 [(this article)](<AnalogIC/Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).md>)。综合上面几点，我们给出 op amp 的 specifications:

<div class='center'>

| DC Gain | UGF | Load | PM | SR | ICMR | Swing | Power Dissipation | Process Corner |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | - | - | - | 60° | - | (600 mV, 800 mV) | (400 mV, 700 mV) | 100 uA @ 0.9V (0.090 mW) | TT, SS, FF, SF, FS |
</div>

主要优化方向为 UGF, 其次是 DC Gain 和 ICMR.

除了上面的 specifications, 还有一个需要注意的问题是：运放的 reference current 由谁提供？是像完全模块化的运放一样，由额外的 current reference circuit 提供，还是利用现有的 BGR 提供？如果是后者，如何确保接入电源时整个 BGR 可以正常进入工作状态？



关于这个问题, Razavi 在 [Paper [1]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9523469) 中所使用的是后者 (运放单独含有一个 reference current circuit), [Paper [2]](https://doi.org/10.1007/s10470-009-9352-4) 中给出的众多例子也没有明确指出运放的 reference current 从哪里来，猜测都是运放内部单独含有参考电路。除此之外,  [Paper [3]](http://ieeexplore.ieee.org/document/4734888/) 则是用一个电阻替代了位于底部的 current transistor. 

因此，我们运放的 reference current 也将由运放内部的 biasing circuit 来提供，独立于 BGR 之外。



## 2. Design of Op Amp

详见文章 [this design](<AnalogICDesigns/tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA.md>).

## 3. Start-Up Circuit



## 4. Pre-Simulation

## 5. Layout of BGR

## 6. Post-Simulation

## References


- [1] [(this link)](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9523469) RAZAVI B. The Design of a Low-Voltage Bandgap Reference \[The Analog Mind]\[J/OL]. IEEE Solid-State Circuits Magazine, 2021, 13(3): 6-16. DOI:10.1109/mssc.2021.3088963. 
- [2] [(this link)](https://doi.org/10.1007/s10470-009-9352-4) DONG-OK HAN, JEONG-HOON KIM, NAM-HEUNG KIM. Design of bandgap reference and current reference generator with low supply voltage[C/OL]//2008 9th International Conference on Solid-State and Integrated-Circuit Technology. Beijing, China: IEEE, 2008: 1733-1736[2025-07-14]. http://ieeexplore.ieee.org/document/4734888/. DOI:10.1109/icsict.2008.4734888.
- [3] [(this link)](http://ieeexplore.ieee.org/document/4734888/) FAYOMI C J B, WIRTH G I, ACHIGUI H F, 等. Sub 1 V CMOS bandgap reference design techniques: a survey[J/OL]. Analog Integrated Circuits and Signal Processing, 2010, 62(2): 141-157. DOI:10.1007/s10470-009-9352-4.

