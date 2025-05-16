# Modeling the Non-Idealities of Op Amp

> [!Note|style:callout|label:Infor]
Initially published at 00:01 on 2025-05-16 in Beijing.

## Ideal Op Amp Model

理想运放模型十分简洁，为电路分析提供了很大的便利。然而，某些情况下，实际运放的表现与理想运放有较大的差别，因此有必要了解（并掌握）实际运放的常见非理想特征。

理想运放模型如下：
<div class="center"><img width=800px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-14-42-14_Ideal and Nonideal Op Amp.png"/></div>


## Non-Ideal Op Amp Model

实际运放模型如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-00-18-57_Modeling the Non-Idealities of Op Amp.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-14-42-30_Ideal and Nonideal Op Amp.png"/></div>

### Biasing or DC Deviation

在计算非理想特性带来的 DC 误差时，我们通常会考虑 $V_{OS} $ 和 $ I_{B\pm}$。当然，有些资料可能会提到 $I_{OS}$, 这是因为利用电阻匹配来减小输入偏置电流的影响时，$I_{IO}$ 带来的影响基本上是不可避免的。当 $I_{IO}$ 过大时，我们就不得不作出妥协，减小电路中电阻阻值来保证足够的 DC 精度。

### Small-Signal Deviation

计算小信号误差时，我们通常需要考虑这几个参数：$\mathrm{CMRR},\ \mathrm{PSRR},\ V_{\mathrm{noise}},\ I_{n\pm},\ A_v,\ R_{out}$。当然，在一些精度要求不高的场合，只考虑 $A_v$ 也是可以的。

### Large-Signal Limitations

当运放所处理的信号幅度较大，达到 Large-Signal 级别时，我们就必须考虑大信号下的一些限制，例如 $\mathrm{SR}$ 和 output limitation (包括 voltage range 和 maximum current)。

## Relevant Resources

关于运放非理想性的资料：
- [Experiment 3: Measurement of Non-Ideal Operational Amplifiers](https://classes.engineering.wustl.edu/2012/fall/ese331/331Project3.pdf)
- [MIT OpenCourseWare: Operational Amplifiers](https://ocw.mit.edu/courses/6-071j-introduction-to-electronics-signals-and-measurement-spring-2006/e7b81789ae20fd3cac8c1855359b3e10_22_op_amps1.pdf)
- [Circuit Techniques for Reducing the Effects of Op-Amp Imperfections: Autozeroing, Correlated Double Sampling, and Chopper Stabilization](https://picture.iczhiku.com/resource/eetop/SHiEeSShaisisnMM.pdf)


其它资料：
- [TI Application Note: *DC Parameters: Input Offset Voltage*](https://www.ti.com/lit/an/sloa059b/sloa059b.pdf)
- [TI Application Note: *Understanding Basic Analog ± Ideal Op Amps*](https://www.ti.com/lit/an/slaa068b/slaa068b.pdf)
- [TI Product: *OPAx991 40-V Rail-to-Rail Input/Output, Low Offset Voltage, Low Noise Op Amp*](https://www.ti.com/lit/ds/sbos969f/sbos969f.pdf)