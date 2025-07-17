# Razavi CMOS - Chapter 12. Bandgap References

> [!Note|style:callout|label:Infor]
> Initially published at 19:03 on 2025-07-14 in Beijing.

参考教材：[*Design of Analog CMOS Integrated Circuits (Behzad Razavi) (2nd edition, 2015)*](https://www.zhihu.com/question/452068235/answer/95164892409)

## 1. General Considerations

参考电压/电流的生成目标是建立一个与电源和工艺无关、且具有明确温度特性的直流电压或电流。在大多数应用中，所需的温度依赖性有三种形式：
- (1) PTAT, proportional to absolute temperature
- (2) Constant-Gm, 即某些晶体管的跨导保持恒定
- (3) Temperature-independent

因此，我们可以将任务分为两个的设计步骤: supply-independent biasing and definition of the temperature variation. 除了电源、工艺和温度的失配之外, BGR 的其它参数例如输出阻抗、输出噪声和功率消耗也很重要，我们将在本章后面再次讨论这些问题。

## 2. Supply-Independent Biasing

详见 [Reference Current Generation Methods](<AnalogIC/Reference Current Generation Methods.md>) 一文。

## 3. Tempe-Independent References

一般情况下，一个 temp-independent 的电压或者电流，通常也是 process-independent 的，因为许多工艺参数都是温度的函数 (随温度而变)。产生 temp-independent 的基本思想是将两个具有相反 temperature coefficients (TCs) 的效应叠加，实现相互抵消。


从哪里找这些具有相反温度系数的电压呢？下面是几个例子：
<div class='center'>

| Parameter | Note | Temp Coefficient |
|:-:|:-:|:-:|
 | $V_D$ | forward voltage of a pn-junction diode | **<span style='color:blue'> negative </span>** |
 | $\Delta V_{BE}$ | voltage difference between two base-emitter junctions with different area but the same currents | **<span style='color:red'> positive </span>** |
</div>

### 3.1 Negative-TC Voltage

The base-emitter voltage $V_{BE}$ of bipolar transistors or, more generally, the forward voltage of a pn-junction diode $V_D$ exhibits a **<span style='color:blue'> negative TC</span>**.


$$
\begin{gather}
I_C = I_S \left(e^\frac{V_{BE}}{V_T} - 1\right) \approx I_S \exp\left(\frac{V_{BE}}{V_T}\right),\quad V_T = \frac{kT}{q_e},\ \  I_S \propto \mu k T n_i^2  
\\ \Longrightarrow 
I_S \propto (\mu_0 T^{\,m}) k T \left(T^3e^{\frac{-E_g}{kT}}\right) 
\propto T^{4 + m}\exp\left(\frac{-E_g}{kT}\right)
,\quad m \approx -\frac{3}{2},\ E_g \approx 1.12 \ \mathrm{eV}
\\ \Longrightarrow 
I_S = b\,T^{4 + m}\exp\left(\frac{-E_g}{kT}\right)
,\quad
\frac{\partial I_S }{\partial T } = b\, (4 + m) T^{3 + m} \exp\left(\frac{-E_g}{kT}\right) + b\, T^{4 + m} \exp\left(\frac{-E_g}{kT}\right) \cdot \frac{E_g}{kT^2}
\end{gather}
$$


where $E_g$ is the energy bandgap of silicon. Therefore, writing $V_{BE}$ as a function of temperature $V_{BE} = V_T \ln \left(\frac{I_C}{I_S}\right) $, we have:

$$
\begin{align}
\frac{\partial V_{BE} }{\partial T } &= \frac{\partial V_T }{\partial T } \ln \left(\frac{I_C}{I_S}\right) - \frac{V_T}{I_S} \frac{\partial I_S }{\partial T }
\\
& = \frac{\partial V_T }{\partial T } \ln \left(\frac{I_C}{I_S}\right) - (4 + m) \frac{V_T}{T} - \frac{E_g}{kT^2} V_T
\\
& =  \frac{1}{T}\left[V_{BE} - (4 + m) V_T - \frac{E_g}{q_e}\right]
\\
& \approx \color{blue}{\boxed{\frac{1}{T}\left[V_{BE} - 2.5\, V_T - 1.12 \ \mathrm{Volt}\right]}}
< 0
\end{align}
$$

举一个例子，当 $V_{BE} = 750 \ \mathrm{mV},\ T = 300 \ \mathrm{K}$ 时，我们有 **<span style='color:blue'> $\frac{\partial V_{BE} }{\partial T }\approx - 1.5 \ \mathrm{mV/K}$ </span>**. 

并且，从上式可以看出，$V_{BE}$ 的温度系数 $\frac{\partial V_{BE} }{\partial T }$ 本身会随温度变化而变化 (非线性性)，如果正温度系数量具有恒定的温度系数，就会导致的 constant-reference 出现误差。

### 3.2 Positive-TC Voltage

如果两个双极型晶体管的工作电流不相等，那么它们的 base-emitter voltages 之间的差值与绝对温度成正比，即 $(V_{BE1} - V_{BE2}) \propto T$.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-14-19-49-25_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>


以上图为例，我们有：

$$
\begin{align}
\Delta V_{BE} &= V_{BE1} - V_{BE2} 
\\& = V_T \ln \left(\frac{n I_0}{I_{S}}\right) - V_T \ln \left(\frac{I_0}{I_{S}}\right)
\\& = V_T \ln \left(n\right)
\\
\Longrightarrow 
\frac{\partial \Delta V_{BE} }{\partial T } &= \color{red}{\boxed{ \frac{k}{q_e}\ln n = \ln n \times 0.087 \ \mathrm{mV/K}}}
\end{align}
$$


Interestingly, this TC is independent of the temperature or behavior of the collector currents.



还是举个例子，欲获得 $+ 1.5  \mathrm{mV/K}$ 的温度系数，我们需要 $\ln n \approx 17.2 \Longrightarrow n = 2.95 \times 10^7$, 这显然不现实，因此我们必须对电路进行修改，以避免这两路电流之间出现如此大的差异 (这便引出了我们后面将提到的 opamp-based bandgap reference)。


也可以通过 multiplier 进一步提高电流比例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-04-25-39_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>

### 3.3 Bandgap Reference

#### (1) Basic Idea

将上述正负电压结合，我们便可以得到具有 a nominally zero temperature coefficient 的 bandgap. 

$$
\begin{gather}
V_{REF} = \alpha_1 V_{BE} + \alpha_2 (V_T \ln n),\quad \frac{\partial V_{REF} }{\partial V_T } = \alpha_1 \times (- 1.5 \ \mathrm{mV/K}) + \alpha_2 \ln n \times 0.087 \ \mathrm{mV/K}
\\
\frac{\partial V_{REF} }{\partial V_T } = 0 \Longrightarrow 1.5 \,\alpha_1 = 0.087 \,\alpha_2 \ln n
\end{gather}
$$

最常见的设计就是令 $\alpha_1 = 1$ 从而 $\alpha_2 \ln n = 17.2$, 此时 $V_{REF} = V_{BE} + 17.2 V_T \approx 1.25 \ \mathrm{V}\ \ (V_{BE} \approx 800 \ \mathrm{mV}) $, 这也是为什么普通 bandgap reference 的输出电压一般都在 1.25 V 左右。

如何实现 $V_{BE}$ 和 $V_T \ln n$ 的相加呢？考虑下图电路：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-14-21-03-54_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>

假设运放增益足够高，则有：

$$
\begin{gather}
V_{BE1} = V_{X} = V_Y = V_{BE2} + V_{R_3} \Longrightarrow V_{R_3} = I R_3 = V_T \ln n,\ V_Y = V_{BE2} + V_T \ln n
\\
R_1 = R_2 \Longrightarrow 
V_{out} = V_{BE2} + \left(1 + \frac{R_2}{R_3}\right)V_T \ln n = 0 \Longrightarrow 
\boxed{\left(1 + \frac{R_2}{R_3}\right)\ln n \approx 17.2}
\end{gather}
$$

一个比较经典的取值是 $n = 31,\ \frac{R_2}{R_3} = 4$. 值得一提的是电阻的温度系数 (几乎) 不会对 bandgap 产生影响，因为 $R_2$ 和 $R_3$ 相除后抵消了此效应。



下面讨论 Figure 12.9 中的一些设计关键点。

#### (2) Design Issues

**Collector Current Variation:** 在上面的计算中，我们是在 $I_C$ 恒定 (因为 $I_C$ 由理想电流源提供) 且 $V_{BE2} = 750 \ \mathrm{mV}$ 的条件下得出 $+ 1.5 \ \mathrm{mV/K}$ 的温度系数，进而得到 $\left(1 + \frac{R_2}{R_3}\right)\ln n \approx 17.2$。也就是说，上述的计算仅在 $V_{BE2} = 750 \ \mathrm{mV}$ 这一点实现了 zero TC, 那么当 $V_{BE2}$ 变化时 (等价于 collector current 变化), 我们的温度系数会变为多少呢，还会是零吗？

假设 $I_{C1} = I_{C2} \approx \frac{V_T \ln n}{R_3}$, 则有：


$$
\begin{align}
V_{BE} &= V_T \ln \left(\frac{I_{C}}{I_S}\right) = V_T \left(\ln I_C - \ln I_S\right) \Longrightarrow
\\
\frac{\partial V_{BE} }{\partial T } &= \frac{\partial V_T }{\partial T } \ln \left(\frac{I_C}{I_S}\right) + V_T \left( \frac{1}{I_C} \frac{\partial I_C }{\partial T } - \frac{1}{I_S} \frac{\partial I_S }{\partial T } \right)
\\
&= \frac{\partial V_T }{\partial T } \ln \left(\frac{I_C}{I_S}\right) + \frac{V_T}{T} \frac{\partial I_C }{\partial T } - \frac{V_T}{I_S} \frac{\partial I_S }{\partial T }
\\
&= \boxed{\frac{1}{T} \left[V_{BE} - (3 + m) V_T - \frac{E_g}{q_e}\right]}
\end{align}
$$

注意之前的计算中得到的是 $\frac{\partial V_{BE} }{\partial T } = \frac{1}{T} \left[V_{BE} - (4 + m) V_T - \frac{E_g}{q_e}\right]$, 之前的是 $-(4 + m)$, 现在的是 $-(3 + m)$. 表明 TC 比原来的 - 1.5 mV/K 更大一些 (向零靠近)。在实际的设计中，必须通过精确而小心的仿真来预测电路的 temperature coefficient.

**Op Amp Offset and Output Impedance:** 实际设计出来的 op amp 都会有一定的 $V_{OS}$ 以及非零的 $R_{out}$, 我们必须考虑这些因素对电路性能的影响。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-03-50-33_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>

如上图，需要注意引入 input offset voltage 后，$I_{C1} = I_{C2}$ 不再成立，而是变为 $I_{C1}R_1 - V_{OS} = I_{C2} R_2 \Longrightarrow I_{C1} = I_{C2} + \frac{V_{OS}}{R_2}$，进而得到：

$$
\begin{align}
V_{R3} &= V_{BE1} - V_{BE2} - V_{OS} 
\\ &= V_T \ln \left(\frac{I_{C1}}{I_{S1}}\right) - V_T \ln \left(\frac{I_{C2}}{I_{S2}}\right) - V_{OS}
\\ & = V_T \ln n - V_T \ln \left(1 + \frac{V_{OS}}{I_{C2} R_2}\right) - V_{OS}
\\ & \approx V_T \ln n - V_T \left(\frac{V_{OS}}{I_{C2} R_2}\right) - V_{OS} \quad (\mathrm{for\ small\ } V_{OS})
\\ & = \boxed{V_T \ln n - \left(1 + \frac{1}{g_m R_2}\right)V_{OS}}
\\
\Longrightarrow
V_{out} &= V_{BE2} + (R_2 + R_3) \frac{V_{R3}}{R_3}
\\ &= V_{BE2}  + \left(1 + \frac{R_2}{R_3}\right) V_T \ln n - \left(1 + \frac{R_2}{R_3}\right) \left(1 + \frac{1}{g_m R_2}\right)V_{OS}
\\ & \approx V_{BE2}  + \left(1 + \frac{R_2}{R_3}\right) V_T \ln n - \left(1 + \frac{R_2}{R_3}\right) V_{OS}
\end{align}
$$

<!-- $$
\begin{align}
\mathrm{without\ offset:\ \ } V_{out} &= V_{BE2} + \left(1 + \frac{R_2}{R_3}\right)\left(V_{BE1} - V_{BE2}\right)
\\
\Longrightarrow\mathrm{with\ offset:\ \ } V_{out} &= V_{BE2} + \left(1 + \frac{R_2}{R_3}\right)\left(V_{BE1} - V_{OS} - V_{BE2}\right)
\\ &= V_{BE2} + \left(1 + \frac{R_2}{R_3}\right) (V_T \ln n - V_{OS} )
\\ &= V_{BE2} + \left(1 + \frac{R_2}{R_3}\right) V_T \ln n - \boxed{\left(1 + \frac{R_2}{R_3}\right) V_{OS}}
\end{align}
$$ -->

方框中的一项是 op amp 的 offset 所导致，由于运放的失调电压也是温度的函数，因此 $\frac{\partial V_{OS} }{\partial T } \ne 0$，对 bandgap 的性能产生显著负面影响。更进一步，我们可以计算 $V_{OS}$ 到 $V_{out}$ 的 small-signal gain, 以预测 $V_{OS}$ 发生 (由温度导致的) 微小变化时，输出电压 $V_{out}$ 的变化量。将两个三极管替换为 $\frac{1}{g_m}$, 则有：

$$
\begin{gather}
\frac{\frac{1}{g_m}}{\frac{1}{g_m} + R_1} v_{out} - v_{os} = \frac{\frac{1}{g_m} + R_3}{\frac{1}{g_m} + R_3 + R_2}v_{out} 
\Longrightarrow
\\
\frac{v_{out}}{v_{os}} = - \left[1 + \frac{1}{g_m R_2} + \frac{\left( \frac{1}{g_m} + R_2 \right)^2}{R_2 R_3}\right] \approx - \left(1 + \frac{R_2}{R_3}\right)\quad \  \left(\mathrm{if\ } \frac{1}{g_m} \ll R_2\right) 
\end{gather}
$$

这与前面 large-signal 下的推导结果一致。

#### (3) Suppress Offset

降低运放 offset 的方法有很多种，基本的思想是：
1. the op amp incorporates large devices in a carefully chosen topology so as to minimize the offset (Chapter 19)
2. as illustrated in Fig. 12.7, the collector currents of Q1 and Q2 can be ratioed by a factor of m such that $\Delta V_{BE} = V_T \ln (mn)$
3. each branch may use two pn junctions in series to double $\Delta V_{BE}$

考虑上面的第三条 "double $\Delta V_{BE}$", 如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-15-14-40_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>

上面的电路还需要一些修改，因为 CMOS 工艺实现 PNP 时，三极管的 collector 就是 p-substrate (如下图 Figure 12.10, collector 一般都是接地，除非额外作隔离)，而上图中的 collector 并没有接地。一种改进方法是将两个串联的 PNP 改为 PNP 型 Darlington pair (如 Figure 12.14), 注意两个 PNP 的电流要相等，所以用一个 current mirror 来将 Q2 的电流复制到 Q1, 完整电路如 Figure 12.15 所示。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-15-15-45_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-15-27-48_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-15-29-17_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>

在该电路中，运放的负载为纯容性，但 PMOS 器件 (用作 current mirror) 的失调和沟道长度调制会在输出端引入误差。另外, Q2 和 Q4 的 base current 也会带来误差和，在精度要求比较高的情况下，需要加入 "base current cancellation technique" 以消除 base current 的影响。

#### (4) Feedback Polarity

上面的结构，对运放来讲既有负反馈又有正反馈，要使电路能稳定工作，负反馈系数 $\beta_N$ 必须大于正反馈系数 $\beta_P$, 且最好是 $\beta_P < \frac{1}{3} \beta_N$.
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-15-41-37_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>

#### (5) Bandgap Reference


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-15-45-15_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>


#### (6) Start-Up Circuit

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-15-47-03_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>

#### (7) Curvature Correction

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-15-52-00_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>

## 4. PTAT Current Generation

生成 PTAT current 的关键在于 $I_{C1} \approx I_{C2}$ 的同时 $A_1 \ne A_2 \ \ (I_{S1} \ne I_{S2})$。以 Figure 12.18 为例，我们有：

$$
\begin{gather}
I_{C2} = I_{C1} + \frac{V_{OS}}{r_{O4}}, \quad 
V_{R1} = V_{BE1} - V_{BE2} - V_{OS} = V_T \ln \left(\frac{I_{C1}}{I_{C2}}\right) - V_T \ln n - V_{OS}
\\
\Longrightarrow 
V_{R1} = V_T \ln \left(1 - \frac{V_{OS}}{I_{C2}r_{O4}}\right) + V_T \ln n - V_{OS}
\approx V_T \ln n - V_{OS} \left(1 + \frac{V_{OS}}{I_{C2}r_{O4}}\right)
\end{gather}
$$

$$
\begin{align}
I_{C2} &= I_{C1} + \frac{V_{OS}}{r_{O4}}
\\ V_{R1} &= V_{BE1} - V_{BE2} - V_{OS} 
\\ &= V_T \ln \left(\frac{I_{C1}}{I_{C2}}\right) - V_T \ln n - V_{OS}
\\
\Longrightarrow
V_{R1} &= V_T \ln \left(1 - \frac{V_{OS}}{I_{C2}r_{O4}}\right) + V_T \ln n - V_{OS}
\\ & \approx - \frac{V_{OS}V_T}{I_{C2}r_{O4}}  + V_T \ln n - V_{OS}
\\ & = V_T \ln n - V_{OS} \left(1 + \frac{V_{OS}}{I_{C2}r_{O4}}\right)
\\ & \approx V_T \ln n - V_{OS}
\end{align}
$$

也就是：
$$
\begin{gather}
\boxed{V_{R1} \approx V_T \ln n - V_{OS}},\quad I_{R1} \approx \frac{V_T \ln n - V_{OS}}{R_{1}}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-17-32-44_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-17-34-40_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>

## 5. Constant-Gm Biasing

To be completed...

## 6. Speed and Noise Issues

To be completed...


## 7. Low-Voltage Bandgap

$V_{REF} = V_{BE} + 17.2 V_T \approx 1.25 \ \mathrm{V}$ 给出的 reference voltage 对于 low-supply voltage applications 来说太高了，因此需要设计低压 bandgap. 考虑将两个具有相反温度系数的电流相加，得到分子是 zero-TC 的电流 $I_{REF}$ (分母是电阻), 便可以再通过一个 mirror + resistor 得到一个 zero-TC 的 voltage (需要两个电阻的 TC 抵消). 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-18-13-38_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-18-12-57_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-15-18-41-27_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>

如果考虑运放的 offset, 则有：

$$
\begin{gather}
I_{C2} = \frac{V_T \ln n - V_{OS}}{R_1},\quad I_{R2} = \frac{|V_{BE1}|- V_{OS}}{R_2}
\\
|I_{D2}| = I_{C2} + I_{R2} = \frac{V_T \ln n - V_{OS}}{R_1} + \frac{|V_{BE1}|- V_{OS}}{R_3}
\\
\Longrightarrow 
V_{BG} =  |I_{D2}| R_4 = \frac{R_4}{R_3}\, \left[ |V_{BE1}| + \frac{R_3}{R_1} \,V_T \ln n - \left(1 + \frac{R_3}{R_1} \right)V_{OS} \right]
\end{gather}
$$

只要 $V_{BG}$ 括号内的一项为 zero-TC, 则 $V_{BG}$ 便是 zero-TC 的 bandgap reference (因为 $R_4$ 和 $R_3$ 的一阶 TC 可以互相抵消)。

上述电路所需的最小电源约为 $(V_{DD})_{\min} = V_{BE1} + |V_{DS3}| \approx 800 \ \mathrm{mV}$.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-16-02-00-05_Razavi CMOS - Chapter 12. Bandgap References.png"/></div>

Other low-voltage bandgaps are described in [this paper](https://link.springer.com/article/10.1007/s10470-009-9352-4), 全引是：
[Fayomi, C.J.B., Wirth, G.I., Achigui, H.F. et al. Sub 1 V CMOS bandgap reference design techniques: a survey. Analog Integr Circ Sig Process 62, 141–157 (2010). https://doi.org/10.1007/s10470-009-9352-4](https://link.springer.com/article/10.1007/s10470-009-9352-4)

## 8. Case Study

To be completed...


## References

- [1] R. A. Blauschild et al., “A New NMOS Temperature-Stable Voltage Reference,” IEEE J. of Solid-State Circuits, vol. 13, pp. 767–774, December 1978.
- [2] Y. P. Tsividis and R. W. Ulmer, “A CMOS Voltage Reference,” IEEE J. of Solid-State Circuits, vol. 13, pp. 774778, December 1978.
- [3] D. Hilbiber, “A New Semiconductor Voltage Standard,” ISSCC Dig. of Tech. Papers, pp. 32–33, February 1964.
- [4] K. E. Kujik, “A Precision Reference Voltage Source,” IEEE J. of Solid-State Circuits, vol. 8, pp. 222–226, June 1973.
- [5] G. C. M. Meijer, P. C. Schmall, and K. van Zalinge, “A New Curvature-Corrected Bandgap Reference,” IEEE J. of Solid-State Circuits, vol. 17, pp. 1139–1143, December 1982.
- [6] M. Gunawan et al., “A Curvature-Corrected Low-Voltage Bandgap Reference,” IEEE J. of Solid-State Circuits, vol. 28, pp. 667–670, June 1993.
- [7] T. Brooks and A. L. Westwisk, “A Low-Power Differential CMOS Bandgap Reference,” ISSCC Dig. of Tech. Papers, pp. 248–249, February 1994.
- [8] H. Banba et al., “A CMOS Bandgap Reference Circuit with Sub-1-V Operation,” IEEE J. of Solid-State Circuits, vol. 34, pp. 670–674, May 1999.
- [9] [H. Neuteboom et al., “A DSP-Based Hearing Instrument IC,” IEEE J. of Solid-State Circuits, vol. 32, pp. 17901806, November 1997.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=760378)
- [10] [C. J. B. Fayomi et al., “Sub-1-V CMOS Bandgap Reference Design Techniques: A Survey,” Analog Integrated Circuits and Signal Processing, vol. 62, pp. 141–157, February 2010.](https://link.springer.com/article/10.1007/s10470-009-9352-4)
- [11] B. Gilbert, “Monolithic Voltage and Current References: Themes and Variations,” pp. 269–352 in Analog Circuit Design, J. H. Huijsing, R. J. van de Plassche, and W. M. C. Sansen, eds. (Boston: Kluwer Academic Publishers, 1996).