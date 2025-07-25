# A Low-Voltage Bandgap Reference (BGR) achieving xxx ppm/°C in 28nm CMOS Technology

> [!Note|style:callout|label:Infor]
Initially published at 18:56 on 2025-07-14 in Beijing.

## 0. Introduction

本文，我们使用台积电 28nm CMOS 工艺库 `tsmcN28` **(VDD = 0.9 V)** 来完整地设计一个 low-voltage bandgap reference (BGR), 依次完成前仿、版图、后仿等工作。要求能在 (-40 °C, 125 °C) 的温度范围内 (汽车级) 输出一个约 500 mV 的 bandgap voltage, 具有较小的温度系数和较高的 PSRR. 另外，电路的供电电压在 0.9V ~ 1.1V 之间可选，供电精度 ±10%.

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



具体推导过程：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-16-06-46_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-01-43-49_tsmcN28_BGR__scientific_research_practice_1.png"/></div> -->



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


## 3. Deisgn of BGR Core

### 3.1 theoretical value

按 **1.1 reference formulas** 一节中的理论推导, 取 $I_0 = 50 \ \mathrm{uA}$, 则 BGR Core 中各器件的参数设置如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-16-07-22_tsmcN28_BGR__scientific_research_practice_1.png"/></div>


对两个 MOS 管而言，在 a = W/L 不变的情况下, Vdsat 随 gm/Id 的升高而降低。为了匹配性不会过低，不妨选择 gm/Id = 14, 此时 PMOS 的 I_nor 约为 2.20 uA. 由于 Id4 = 50 uA, MOS 管的长宽比 a = Id3/I_nor = 23. 

如果仿真得到的 gm/Id 稍高，可以降低 a (等价于提高 I_nor) 以降低 gm/Id, 从而降低失配率。


综上，我们有各器件的理论参考值：

$$
\begin{gather}
I_0 = |I_{D4}| = 50 \ \mathrm{uA},\quad I_{R_1} = 18.26 \ \mathrm{uA},\quad I_{R_2} = 31.74 \ \mathrm{uA}
\\
a = \frac{W}{L} \approx 23,\quad 
n = 14,\quad 
R_1 = 3.77 \ \mathrm{k}\Omega,\  R_2 = R_3 = 24.58 \ \mathrm{k}\Omega
\\
b = 2,\quad  R_4 = 5.0 \ \mathrm{k}\Omega
\end{gather}
$$

<!-- $$
\begin{gather}
I_0 = |I_{D4}| = 25 \ \mathrm{uA},\quad I_{R_1} = 9.13 \ \mathrm{uA},\quad I_{R_2} = 15.87 \ \mathrm{uA}
\\
a = \frac{W}{L} \approx 11.5,\quad 
n = 14,\quad 
R_1 = 7.54 \ \mathrm{k}\Omega,\  R_2 = R_3 = 49.16 \ \mathrm{k}\Omega
\end{gather}
$$ -->







### 3.2 iteration 1 (ideal)

运放保持 calibre 模型不变, BGR Core 中的电阻先用理想器件，理论参数的仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-16-17-27_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-17-51-21_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-16-15-47_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

**<span style='color:red'> 注意，我们在上图设置的是 multiplier_Q1 = 2 和 multiplier_Q2 = 32 (相当于 n = 16). </span>** 后续可以适当调整 multiplier_Q2 来改变 zero-TC temperature point (希望 27 °C 左右), 以及改善整个温度范围内的 temp-coefficient. 初步估计一共使用 6*6 = 36 个 BJT, 剩下几个没用到的作为 dummy 即可。

另外需要注意的是，上面两个 MOS 管的 region = 1, 位于线性区。我们不得不先扫描 VDD 看看目前电路的最小工作电压：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-16-26-42_tsmcN28_BGR__scientific_research_practice_1.png"/></div>



图中可以看出，电路在 VDD = 0.95 V 或 1.0 V 左右才能正常工作。 **<span style='color:red'> 为了在后续的仿真中保证 M3 和 M4 位于饱和区，我们都令 VDD = 1.1 V 进行仿真 </span>** ，确定完整个电路的参数之后，再来看 BGR 的最小工作电压是多少。

令 VDD = 1.1 V, 仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-16-31-58_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

MOS 管的 gm/Id = 13.46 并没有太高，因此不必再修改长宽比 a 了。保持其它参数不变，扫描 R4 的值使得 VBG = 500 mV, 得到 **R4 = 4.618 kOhm**.


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-17-16-08_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

<!-- 按照上图，其实选择一个位于 4.418k 和 4.668k 之间的 R4 更好一些，因为这样可以提高电压 V_BG 在蒙特卡罗中的表现。换句话说，这样做可以降低实际电路中 V_BG 的标准差 sigma. -->

此时电路的静态工作点为：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-17-18-55_tsmcN28_BGR__scientific_research_practice_1.png"/></div>



### 3.3 start-up circuit

当然，要保证电路的稳定性，我们还需要一个 start-up circuit. 对我们的电路架构而言, start-up 的关键一步在于打开 M3 ~ M4 的 gate, 这样 Q1 和 Q2 才会有电流通过，最终达到正常的稳态工作点。对于不太高的 VDD (以 1.1 V 为例), 当电路分别处于 zero-current stage (也即所谓的 zero-voltage state) 和正常工作状态时，我们有：

<div class='center'>

| Node | zero-current | normal |
|:-:|:-:|:-:|
 | VDD | 1.1 V | 1.1 V |
 | Vz (output of op amp) | 1.1 V | VDD - Vgs = 0.6 V |
 | Vx | 0 V | Vbe1 = 0.8 V |
</div>

显然，我们可以在 VDD 和 Vx 之间加入一个 diode-connected MOSFET 作为启动电路。如果希望启动电路能在更高的 VDD 下工作，不妨将其加在 Vz 和 Vz 之间 (提高了一个 Vgs 的电压范围)，**但是此方法的可行性有待验证**。

如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-19-45-16_tsmcN28_BGR__scientific_research_practice_1.png"/></div>


<!-- 为确定两种方法哪种更好，我们做一个上电瞬间的瞬态仿真来比较。另外，为方便监测总电流，我们在 VDD 处加一个理想的 0 V 电压源，将 start-up circuit 和 op amp 都接到这个电压源之后，如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-19-37-40_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

设置 VDD 从 0 V 开始上升到 1.3 V, 仿真结果如下：

**无启动电路时：**

**start-up circuit 1 (VDD-Vx):**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-19-40-23_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

**start-up circuit 2 (Vz-Vx):**
 -->

### 3.4 (discarded)  iteration 2 (practical)

在 iteration 2 中，我们所有器件都使用 `tsmcN28` 中的实际器件，因此称为 "practical" 版本。并且这次，我们将调整 Multiplier_Q2, R1 和 R2 (R3 = R2) 的值以获得更好的温度特性。


考虑到 R2 = R3 电阻的值比较大，我们使用方块电阻最高的 `rnwsti` 电阻 (square res = 2.11 kOhm)。然后将刚刚的 variable 输入到 MOS 管 (后续就基本不变了)，注意同步修改 schematic 和 config 文件：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-19-55-33_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-20-00-02_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

**<span style='color:red'> 本小节使用 VDD = 1.0 V, 以便 BGR 性能接近最小供电电压。</span>**

<!-- 这里突然发现之前的 BJT 设置的是 multiplier_Q1 = 2, multiplier_Q2 = 32, 相当于 n = 16, 而不是 14. 我们将 multiplier_Q2 改为 -->



仿真静态工作点：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-20-10-14_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

仿真 Nominal (TT) 工艺角下的温度曲线，注意扫描温度时 output 应设置为 VS/IS/OS 而非 VDC/IDC/OP, 结果如下：

上图发现低温时 BGR 没有正常工作，说明 start-up 电路没有起到作用，于是换为 start-up 1 (VDD-Vx) 的版本，此时仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-20-38-54_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-20-48-00_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

很不幸，这个结果和理论预测差了十万八千里，下面就来查找原因。

首先看一下两个关键的温度系数，发现 $\frac{\partial V_{BE1} }{\partial T } = - 1.437 \ \mathrm{mV/°C}$ 和 $\frac{\partial V_T }{\partial T } = + 0.08832 \ \mathrm{mV/°C}$ 符合理论预测中 -1.5 mV/K 和 +0.087 mV/K 的估计。

那么问题出在哪里？按公式 $V_{BG}$ 来看，问题只能出在电阻了 (R1, R2, R3, R4):

$$
\begin{gather}
I_{D4} = \frac{V_{R1}}{R_1} + \frac{V_Y}{R_2} 
= \frac{1}{R_2} \left[V_{BE1} + \frac{R_2}{R_1} V_T \ln n + \left(1 + \frac{R_2}{R_1}\right)\left(V_{OS} + \frac{V_Z}{A_0} \right) \right]
\\
V_{BG} = b \,I_{D4} R_4 = \frac{b R_4}{R_2} \left[V_{BE1} + \frac{R_2}{R_1} V_T \ln n + \left(1 + \frac{R_2}{R_1}\right)\left(V_{OS} + \frac{V_Z}{A_0} \right) \right]
\\
\frac{\partial V_{BG} }{\partial T } \approx \frac{b R_4}{R_2} \left[ \frac{1}{T}\left(V_{BE1} - (3 + m)V_T - \frac{E_e}{q_e}\right) + \ln n \,\frac{R_2}{R_1}\cdot\frac{k}{q_e} \right] 
\\
\end{gather}
$$


别忘了求偏导的过程中假设了电阻只有一阶温度系数，是不是我们选择的 `rnwsti` 具有不只一阶的温度系数呢？我们来仿真看一下：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-21-08-55_tsmcN28_BGR__scientific_research_practice_1.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-21-11-39_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

仿真结果看出确实是这样的，`rnwsti` 的温度系数从 18.56 Ohm/°C @ -40 °C 逐渐变为 47.59 Ohm/°C @ 125 °C. 这就导致了公式中的比值 $\frac{R_2}{R_1}$ 不对。

将 BGR 中的电阻换为 `rupolym` 重新仿真试一试：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-21-29-48_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-21-31-09_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

确实是质的改变！<span style='color:red'> （但是低温时仍有较大偏差，有待改善） </span>

VBG 的温度系数恒为负，说明系数 $\frac{R_2}{R_1}\ln n$ 偏小。用 n 作为变量扫描看一看：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-21-56-32_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

部分数据点出现异常时有下面的报错：

``` bash

Notice from spectre at temp = -40 C during DC analysis `dc'.
    Bad pivoting is found during DC analysis. Option dc_pivot_check=yes is recommended for possible improvement of convergence.
Notice from spectre at temp = -36.7 C during DC analysis `dc'.
    Bad pivoting is found during DC analysis. Option dc_pivot_check=yes is recommended for possible improvement of convergence.
Notice from spectre at temp = -33.4 C during DC analysis `dc'.
    Bad pivoting is found during DC analysis. Option dc_pivot_check=yes is recommended for possible improvement of convergence.
```

猜测是低温时 VDD = 1.0 V 不够导致的。设置 VDD = 1.1 V 并继续扩大 n 的值进行仿真：


### 3.4 iteration 2 (practical)

在 iteration 2 中，我们所有器件都使用 `tsmcN28` 中的实际器件，因此称为 "practical" 版本。并且这次，我们将调整 Multiplier_Q2, R1 和 R2 (R3 = R2) 的值以获得更好的温度特性。


考虑到 R2 = R3 电阻的值比较大，我们需使用方块电阻较高的电阻类型，比如 `rupolym` 或者 `rnwsti`. **但是 `rnwsti` 在这里完全用不了，这是因为 `rnwsti` 具有非常明显的高阶 temperature coefficient (如下图)**. 我们先前给出的参考公式中，$V_{BG}$ 的求导就用到了 "电阻具有一阶温度系数" 的假设，所以只能用 `rupolym` 作为实际电阻。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-21-11-39_tsmcN28_BGR__scientific_research_practice_1.png"/></div>


**<span style='color:red'> 注：本小节使用 VDD = 1.2 V 以保证 BGR 正常工作。</span>**

<!-- 这里突然发现之前的 BJT 设置的是 multiplier_Q1 = 2, multiplier_Q2 = 32, 相当于 n = 16, 而不是 14. 我们将 multiplier_Q2 改为 -->



n = 16 时，仿真静态工作点和温度曲线，注意扫描温度时 output 应设置为 VS/IS/OS 而非 VDC/IDC/OP, 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-20-10-14_tsmcN28_BGR__scientific_research_practice_1.png"/></div>


（这里当时忘记温度曲线的图了）

上图发现低温时 BGR 没有正常工作，说明 start-up 电路没有起到作用，于是换为 start-up 1 (VDD-Vx) 的版本 (修改为两个尺寸 W/L = 500n/500n 的串联以减小对 VBG 的影响), 仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-22-24-05_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-22-32-49_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-22-34-38_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

需要注意的是, start-up circuit 的管子也会对 TC 产生一定影响。我们的 TC 始终为负，其中一部分原因就是这个。增大 n 的值以改善 TC, 使得 zero-TC point 接近 27 °C, 仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-22-45-20_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-22-46-38_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

由此给出此次迭代的最佳参数: **n = 20 (VDD = 1.2 V)**.

看看全工艺角的温度曲线：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-22-54-16_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

FF 工艺角时工作异常，说明我们的 start-up 电路还是有些问题，需要再次调整。先仿真一下没有 start-up circuit 的情况，以便对比：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-22-58-15_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

### 3.5 iteration 3 (start-up)

看来在 start-up circuit 问题上还是不能马虎，毕竟这是 BGR 能否正常工作的关键。受 *Analog Design Essentials (Sansen, 2006)* 一书 page 476 (slide 1640) 的启发，我们给出下图这样由 "两反相器 + 一电流源" 构成的 start-up circuit, 并附上全工艺角的仿真结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-23-40-01_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-23-43-24_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

图中使用了 2.5V MOSFET 而非 core voltage MOSFET, 是因为后者有 0.9 V 的最大电压限制。

看一下 TT 工艺角的上电瞬态仿真结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-24-23-55-30_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-25-00-23-00_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

在 VDD 上升时间为 1us 的条件下, V_BG 的 settling time = 1.99 us @ 0.05 %.

看一下 temp-curve 随 VDD 的变化情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-25-00-31-59_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

呃，很明显, zero-TC point 随 VDD 呈线性变化，这是为什么？我们猜测是因为 V_BG 随 VDD 基本不变，这意味管子 M5 的 Vds 随 VDD 线性升高，导致 Id5 随 VDD 线性升高，从而使不同 VDD 下的 zero-TC point 发生漂移 (也是线性变化)。

如何解决这个问题呢？一种方法是提高晶体管的 rout, 但我们的 rout 已经在 50 kOhm 左右了，不方便进一步提高太多；另一种方法是用 low-voltage cascode 结构，这需要同步 M3 ~ M4 的结构，后续有精力的话再尝试。

**<span style='color:red'> 后面在 mc 仿真时发现目前用的 start-up 还是不够好，因此又对启动电路作了优化，如下：</span>**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-25-17-28-03_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

优化之后，跑一个 samples = 30 的 Monto Carlo 仿真大致看一下，我们选择 global variation + local variation, 也就是设置 model file 的 section 为 `globalmc_local_mc`.

仿真时报错说：

``` bash
 ------------------------------
ERROR (ADEXL-5069): Cannot complete the Monte Carlo simulation because of the following error for the test 
 ------------------------------
 Spectre simulator stopped due to following reasons:
Error found by spectre during circuit read-in.
Error found by spectre during circuit read-in.
ERROR: "/home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/tsmcN28/../models/spectre/toplevel.scs" 70: No section found with name `globalmc_localmc_r_metal' defined in file `/home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/tsmcN28/../models/spectre/./crn28ull_2d5_elk_v1d0_2p1_shrink0d9_embedded_usage.sc
s'.

Resolve these errors and rerun simulation.
```

是个之前仿真 FS, SF 工艺角时类似的报错，文件里没有 r_metal 对应的 globalmc_localmc_r_metal 模型，我们将其改为 TT 工艺角模型即可，也就是：

``` bash
// 修改前
include "./crn28ull_2d5_elk_v1d0_2p1_shrink0d9_embedded_usage.scs" section=globalmc_localmc_r_metal

// 修改后
include "./crn28ull_2d5_elk_v1d0_2p1_shrink0d9_embedded_usage.scs" section=tt_r_metal
```

更正后重新运行仿真，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-25-16-32-56_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

整体看上去还能接受，再跑一次 samples = 300 的 mc 看看结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-25-17-31-15_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-25-17-06-24_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

在 Results 界面点击上面一行工具栏中的 `Mismatch Contribution`, 查看各个器件对失配的贡献情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-25-17-39-30_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

运放的失配占比达到了 79%, 是一个偏大的值 (占比 40% ~ 60% 算较好的结果)。要优化的思路也是简单的，一种方法是降低输入对管的 gm/Id, 另一种方法是增大管子面积，也就是保持 a = W/L 不变的情况下，同时增大 W 和 L 的值 (可利用晶体管的串并联以进一步增大面积)。

时间有限，我们这里就不再修改运放了，因为运放前面已经通过了版图和后仿，要修改的话是非常耗时的。作为一个科研实践，我们已经积累了宝贵的经验和思路，这便足够了。

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-25-01-35-30_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
还是出现了工作点不正常的情况，说明我们的 start-up circuit 不够好。-->

### 3.6 design summary

到这一步，整个 low-voltage bandgap reference circuit 的设计就基本完成了。如果要继续深入优化，可以考虑下面两个方面：
- (1) 优化电路在不同工艺角下的性能 (也即优化蒙卡下的性能)，这便涉及我们上面提到的失配占比问题，也就是重点降低运放的失配率
- (2) 降低电路在不同供电电压下的性能差异，我目前还没有非常明确的思路，有待进一步探究。



## 4. Pre-Simulation

下面的前仿仍然使用 VDD = 1.2 V 作为主要供电电压。

### 4.0 circuit preview

完整的电路及其参数如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-02-15-15_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-25-17-57-51_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

下面就进行正式的前仿工作 (前仿的同时可以进行 layout 以节省时间)。

### 4.1 (dc) temp-curve (all-temp, all-corners, 1.2 V)

在 VDD = 1.2 V 条件下，仿真不同工艺角的温度曲线 (-40 °C ~ 125 °C)，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-25-18-08-21_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-25-18-08-57_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

### 4.2 (dc) lowest supply voltage (all-temp, TT, all-supply)

在 TT (typical-typical) 工艺角下，仿真带隙电压 V_BG 在不同温度下 (-40 °C, 0 °C, 27 °C, 75 °C, 125 °C) 随供电电压 VDD 的变化情况，结果如下：


室温 27 °C 时：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-00-33-40_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-00-38-34_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

<span style='color:red'> 上面仿真 op amp 的总电流时出现了一些挫折，后面靠手动添加 `oppoint > /I0 > VDD` 解决了。 </span>

全温度 (-40 °C, 0 °C, 27 °C, 75 °C, 125 °C) 的仿真结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-01-38-01_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-02-12-36_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-02-14-26_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

<span style='color:red'> 同时仿真多个温度时，出现了一直 pending 而不进行仿真的情况，等待一段时间后报错如下： </span>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-00-51-35_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

尝试过重启虚拟机，也试过用 root 权限进入软件，但是没有效果。最终是参考 [this blog](https://bbs.eetop.cn/thread-945221-1-1.html), 在 `/home/.bashrc` 中加了下面两行代码解决的：

``` bash
export CDS_XVNC_TENBASE=9 # 端口号的十位 (本地的话无所谓, 随便写一个数字)
export CDS_XVNC_OFFSET=9  # 端口号的个位 (本地的话无所谓, 随便写一个数字)
```


下面是与本问题相关的其它资料，有多种不同的解决方案成功过：
- [edaboard > IC 616: ADE-XL 1921 error](https://www.edaboard.com/threads/ic-616-ade-xl-1921-error.394350/)
- [edaboard > Compatibility question Cadence](https://www.edaboard.com/threads/compatibility-question-cadence.383369/#post-1645399)
- [知乎 > Cadence 跑 adexl 多个 corner 卡 pending 的问题?](https://www.zhihu.com/question/505839455)
- [EETOP > ADE XL 多 corner 一直 PENDING](https://bbs.eetop.cn/thread-967362-1-1.html)
- [CSDN > 解决在高版本系统中 IC617 无法使用 ADE XL Explorer 等进行多线程仿真 Pending 的问题](https://blog.csdn.net/qq_42761840/article/details/127625571)
- [EETOP > 请问 corners 仿真报错__ADEXL Message1921 如何解？](https://bbs.eetop.cn/thread-870417-1-1.html): 认为是文件夹写入权限的问题 (个人虚拟机有权限的状态下也会出现这个)

### 4.3 (tran) start-up response (27 °C, TT, 1.2 V)

在 VDD = 1.2 V 条件下，仿真 BGR 在室温下的的上电瞬态响应 (分别设置 VDD 的上升时间为 1us 和 100us), 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-02-09-24_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

### 4.4 (ac) PSRR (27 °C, TT, 1.2 V)



### 4.5 (mc) average and TC (all-temps, all-corners, 1.2 V)

在 VDD = 1.2 V 的室温 (27 °C) 条件下，调整蒙特卡洛仿真设置为:
- Statistical Variation = All (process + mismatch, namely, global + local variation)
- Sampling Method = Low-Discrepancy Sequence
- Samples = 300
- 给出下面几个物理量的蒙特卡洛仿真结果：
    - (1) average of V_BG (from -40 °C to 125 °C)
    - (2) TC of V_BG (ppm/°C)
    - (3) average of I_BG = Id_M5 (from -40 °C to 125 °C)
    - (4) TC of I_BG = Id_M5 (ppm/°C)
    - (5) average of I_REF = Id_M4 (from -40 °C to 125 °C)
    - (6) TC of I_REF = Id_M4 (ppm/°C)


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-02-48-15_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-02-57-00_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-02-53-12_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-02-53-25_tsmcN28_BGR__scientific_research_practice_1.png"/></div>


## 5. Layout and Verification

详见文章 

## 6. Post-Simulation

### 6.1 (dc) temp-curve (all-temp, TT)
### 6.2 (dc) lowest supply voltage (all-temp, TT)
### 6.3 (tran) start-up response (all-temp, TT)
### 6.4 (ac) PSRR (27 °C, TT)
### 6.5 (mc) bandgap voltage/current (27 °C, TT)


## References


- [1] [(this link)](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9523469) RAZAVI B. The Design of a Low-Voltage Bandgap Reference \[The Analog Mind]\[J/OL]. IEEE Solid-State Circuits Magazine, 2021, 13(3): 6-16. DOI:10.1109/mssc.2021.3088963. 
- [2] [(this link)](https://doi.org/10.1007/s10470-009-9352-4) DONG-OK HAN, JEONG-HOON KIM, NAM-HEUNG KIM. Design of bandgap reference and current reference generator with low supply voltage[C/OL]//2008 9th International Conference on Solid-State and Integrated-Circuit Technology. Beijing, China: IEEE, 2008: 1733-1736[2025-07-14]. http://ieeexplore.ieee.org/document/4734888/. DOI:10.1109/icsict.2008.4734888.
- [3] [(this link)](http://ieeexplore.ieee.org/document/4734888/) FAYOMI C J B, WIRTH G I, ACHIGUI H F, 等. Sub 1 V CMOS bandgap reference design techniques: a survey[J/OL]. Analog Integrated Circuits and Signal Processing, 2010, 62(2): 141-157. DOI:10.1007/s10470-009-9352-4.

