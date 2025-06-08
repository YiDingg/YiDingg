# [Razavi CMOS] Detailed Explanation of Cascode Op Amp (Telescopic Op Amp)

> [!Note|style:callout|label:Infor]
> Initially published at 18:39 on 2025-05-08 in Beijing.

## Introduction

- 参考教材: *Design of Analog CMOS Integrated Circuits (Razavi) (Second Edition, 2015)*, Chapter 9  (Operational Amplifiers), Section 9.2 (One-Stage Op Amps)


本文介绍了经典的 telescopic op amp 和 folded-cascode op amp 的工作原理，给出两种结构偏置电压的详细要求，推导出开环小信号增益的具体公式，并给出传统 overdrive 方法的设计思路。另外， cascode 结构具有较好的频率响应，我们将在后续的文章中详细介绍。
<div class='center'>
<span style='color:red'> 
若无特别说明，本文的讨论都忽略 body effect 对 small-signal 性能的影响。
</span>
</div>


Telescopic op amp, 也称 cascode op amp, 是在 FOTA (Five-Transistor OTA) 的基础上，将输入管和负载管都换为 cascode 结构，从而大大提高增益。其结构如下所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-08-23-30-02_[Razavi CMOS] Design Procedure of Telescopic Op Amp.png"/></div>

当然，由于此结构具有很高的输出电阻，因此也常常看作 OTA (operational transconductance amplifier) 而不是 Op Amp. 在本文，我们还是将其看作 Op Amp 来处理。



## Cascode Op Amp

### Performance Parameters

在分析 op amp 之前，我们先对 op amp 的 performance parameters 作一些介绍，了解它们与什么物理量有关，对设计中的 tradeoff 有一个定性认识：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-09-00-12-45_[Razavi CMOS] Design Procedure of Telescopic Op Amp.png"/></div>






### Voltage Requirements

Telescopic 结构最大的 drawback 之二便是消耗了额外的 voltage headroom, 以及 biasing generation 上的额外工作 (output swing 越大, 对 $V_{b1}$ 和 $V_{b2}$ 的 generation accuracy 要求越高)。因此，我们需要小心的分析其各晶体管的电压值，给出 output swing 和 biasing voltage 之间的联系（限制）。

我们先给出结论，再给出详细分析过程：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-23-25-37_[Razavi CMOS] Detailed Explanation of Cascode Op Amp.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-09-00-23-05_[Razavi CMOS] Design Procedure of Telescopic Op Amp.png"/></div>
 -->

最终结论汇总在了上面的左图，其中 $V_{X}$ (其范围便是 swing) 和 $V_{b1}$, $V_{b2}$ 是相互限制的关系。

当 $V_{DD}$ 和 $V_{I_{SS}}$ 给定时，$V_{X}$ 的范围决定了 $V_{b1}$ 和 $V_{b2}$ 的范围，或者反过来说，$V_{b1}$ 和 $V_{b2}$ 的取值限制着 $V_{X}$ 的范围。图中标注的 $(V_{X})_{max}$ 和 $(V_{X})_{min}$ 是理论上的（理想）极限值，实际上是不能达到的。因此，在由 output swing 和 VDD 来确定 overdrive 时，我们需要先让 $[V_{X,low},\ V_{X,high}]$ 落在 $[(V_{X})_{min},\ (V_{X})_{max}]$ 之内，并且留有一定余量，这部分余量便是生成 $V_{b1}$ 和 $V_{b2}$ 时的 margin。余量越小，对 $V_{b1}$ 和 $V_{b2}$ 的 generation accuracy 要求越高，也就需要越复杂的 biasing circuit。

从另一方面来看，给定 $V_{b1}$ 和 $V_{b2}$ 的值时，$V_{X}$ 的范围被限制在 $[V_{b1} - V_{TH3},\ V_{b2} + |V_{TH5}|]$ 之间，也就是 $V_{X}$ 的 swing 等于 $V_{b2} + |V_{TH5}| - (V_{b1} - V_{TH3})$。如果 $V_{b1}$ 和 $V_{b2}$ 的值不合适，可能会导致 $V_{X}$ 的 swing 过小，甚至无法工作。

上面左图结论的推导过程如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-23-26-12_[Razavi CMOS] Detailed Explanation of Cascode Op Amp.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-09-00-24-01_[Razavi CMOS] Design Procedure of Telescopic Op Amp.png"/></div>
 -->

### Voltage Gain

考虑图中右侧的全差分结构（单端输出的分析也类似，只是频响稍微有些不同）：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-08-23-37-29_[Razavi CMOS] Design Procedure of Telescopic Op Amp.png"/></div>


由于差分结构的对称性，我们将 $g_{m1,3},\ r_{O1,3}$ 等参数简写为 $g_{m1},\ r_{O1}$。其跨导、输出电阻和增益分别为：

$$
\begin{gather}
G_{m} = g_{m1} \cdot \frac{r_{O1}}{r_{O1} + \frac{1}{g_{m3}} \parallel r_{O3}} \approx g_{m1}
,\quad 
R_{out} = g_{m3}r_{O3}r_{O1} \parallel g_{m5}r_{O5}r_{O7}
\\
|A_v| = G_{m} R_{out} \approx g_{m1} \left( g_{m3}r_{O3}r_{O1} \parallel g_{m5}r_{O5}r_{O7} \right)
\end{gather}
$$

在常规的 telescopic op amp 设计中， M1 ~ M4 是完全相同的， M5 ~ M8 也是完全相同的。也就是说，它们具有相同的 current, overdrive 以及 size 。此时，上式可以简写为：

$$
\begin{gather}
G_{m} \approx g_{mN}
,\quad 
R_{out} = g_{mN}r_{ON}^2 \parallel g_{mP}r_{OP}^2
\\
|A_v| \approx g_{mN} \left(\,g_{mN}r_{ON}^2 \parallel g_{mP}r_{OP}^2\right)
\end{gather}
$$

### Similar Structures

由差分结构可以很快速地给出 single-ended output 的结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-23-36-57_[Razavi CMOS] Detailed Explanation of Cascode Op Amp.png"/></div>

左图的输出 swing 浪费了一个 $V_{TH7}$ (因为它使 $V_{D7} = V_{G7}$), 因此实际中基本上都是用右图所示的 low-voltage cascode, 设置合适的偏置使得 M7 at the edge of saturation.

### Design Procedure


在学习 Design Procedure 之前，不妨先看一看 telescopic op amp 的 design tips, 或者说经验定律：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-09-00-39-25_[Razavi CMOS] Design Procedure of Telescopic Op Amp.png"/></div>


假设设计指标给定了 VDD, DM Output Swing, Power Budget 以及 Voltage Gain, 如何去设计一个比较合理的 telescopic op amp ？一种参考方法如下：
- 为使总面积最小，先默认所有晶体管的 length 都是此工艺的最小 length
- 依据 VDD 和 Power Budget, 给各支路分配合适的电流
- 按照 Design Tips, 初步分配 overdrive (要满足 swing 条件)
- 依据给定的 overdrive, 计算电路是否满足 voltage gain 要求；若不满足，对 $W/L$ 作适当的 scale ($g_m r_O \propto \sqrt{\frac{W L}{I_D}}$)
- 依据给定的 overdrive, 计算所需的 $V_{b1}$ 和 $V_{b2}$
- 现在，电路已经满足了题目中的三个指标要求 (DM Output Swing, Power Budget, Voltage Gain), 进入微调阶段
- 微调各晶体管的 overdrive 和 size, 尽量提升电路在 biasing margin, body effect, speed 和 noise 方面的性能


当然，在严谨的设计中， biasing margin, body effect (increasing $V_{TH}$) 以及 CMFB 都是必须考虑在内的。


## Folded-Cascode Op Amp

### Advantages and Drawbacks

折叠式 cascode op amp 原理和具体结构如下所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-23-27-20_[Razavi CMOS] Detailed Explanation of Cascode Op Amp.png"/></div>

一般来讲，我们认为折叠式的主要优点是更广的 input common-mode range (构成 unit buffer 时不会 reducing output swing), 而缺点是牺牲了部分增益和带宽，并且引入了更高的噪声和功耗。但是，由于其优点非常明显，因此在实际设计中，折叠式的 cascode op amp 比常规 telescopic op amp 更常用。

### Voltage Requirements

同样的，我们也需要分析折叠式 cascode op amp 结构中各电压之间的关系，结论如下：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-23-44-59_[Razavi CMOS] Detailed Explanation of Cascode Op Amp.png"/></div>
 -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-17-20-35_[Razavi CMOS] Detailed Explanation of Cascode Op Amp.png"/></div>

### Voltage Gain

对 $M_{1,2},\ M_{5,6}$ 作戴维南等效后，便还原为了 telescopic op amp 结构，很容易求出跨导、阻抗和增益为：

$$
\begin{gather}
G_m \approx g_{m1},\quad R_{out} = \left[ (g_{m3} + g_{mb3}) r_{O3} (r_{O1}\parallel r_{O5}) \right] \parallel \left[ (g_{m7} + g_{mb7}) r_{O7} r_{O9} \right]
\\
A_v \approx g_{m1} \left[ (g_{m3} + g_{mb3}) r_{O3} (r_{O1}\parallel r_{O5}) \right] \parallel \left[ (g_{m7} + g_{mb7}) r_{O7} r_{O9} \right]
\end{gather}
$$

忽略 body effect 时，增益可写作：

$$
\begin{gather}
A_v \approx g_{m1} \left[ g_{m3} r_{O3} (r_{O1}\parallel r_{O5}) \right] \parallel \left[ g_{m7} r_{O7} r_{O9} \right]
\end{gather}
$$

### Similar Structures

在上面的内容中，我们是以 PMOS-input 为例，当然也有 NMOS-input folded-cascode op amp, 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-23-36-27_[Razavi CMOS] Detailed Explanation of Cascode Op Amp.png"/></div>


## Linear Scaling

在集成电路设计中，一个重要的设计思想是 **Linear Scaling**, 它可以让我们更轻松地将原电路设计应用到不同功耗情形，具体内容如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-09-00-52-20_[Razavi CMOS] Design Procedure of Telescopic Op Amp.png"/></div>
