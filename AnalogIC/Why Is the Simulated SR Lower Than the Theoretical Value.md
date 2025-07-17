# Why Is the Simulated SR Lower Than the Theoretical Value ? <br> (in the Folded-Cascode Op Amp)

> [!Note|style:callout|label:Infor]
> Initially published at 00:59 on 2025-06-15 in Beijing.


## Introduction

在前两天的运放设计中 [(A Single-Ended Output Folded-Cascode Op Amp with 80 dB Gain, 50 MHz UGF and 50 V/us SR)](<AnalogICDesigns/tsmc18rf_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.md>), 我们依照理论公式 $\mathrm{SR} = \frac{\min \{I_{SS},\ I_{D5}\}}{C_L}$ 来指导运放的设计 (确定了各支路的电流)，但是最终仿真得到的 $\mathrm{SR}$ 却只有 +32.58 V/us 和 -35.22 V/us, 这与设计的 50 V/us 相差较大。

因此，在这篇文章，我们便对此现象背后的原因进行探讨。最可能的原因有两种：
- **Possible cause 1**: 输出节点的寄生电容较大，导致实际的负载电容比 $5 \ \mathrm{pF}$ 要大
- **Possible cause 2**: 由于电路内部的电流分配问题，大差分信号输入时，某些支路无法完全达到零电流，导致负载电容上输入/输出的电流无法达到理论值

我们猜测 SR 的降低与上面两种原因都有关系，下面便来作详细的讨论。

## Discussion

### Possible Causes

重新运行 tran 仿真，查看各晶体管在 slewing 时的电流分配情况：

**<span style='color:red'> 这里有一个小技巧是对着运放 `shift + e` 可以打开其原理图，然后 `Calculator > It` 点击刚刚打开的运放原理图即可将晶体管级的信息加入到 output. </span>**


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-15-01-22-36_Why is the Simulated SR Lower Than The Theoretical Value.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-15-01-28-09_Why is the Simulated SR Lower Than The Theoretical Value.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-15-01-33-32_Why is the Simulated SR Lower Than The Theoretical Value.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-15-13-29-28_Why is the Simulated SR Lower Than The Theoretical Value.png"/></div>

从图中可以看出，整个 slewing 过程可以分为两段，有下面几点特征：
- **Possible cause 1**:
    - slewing 第一阶段: 大幅度差分信号输入后, M4 的电流的确趋近于 0, M8 的电流达到 276 uA
    - slewing 第二阶段: 此阶段 M4 的电流从零上升并维持在约 85 uA, 导致总输出电流下降到 190 uA, 这是 SR 下降的原因之一
- **Possible cause 2**:
    - slewing 第一阶段: 运放输出的 260 uA 电流，仅有 200 uA 流向了负载 $C_L$ (带来约 40 V/us 的 SR), 剩下的 60 uA 都流向了 Vin- terminal, 导致 SR 下降
    - slewing 第二阶段: 此阶段 Vin- 端基本不接受电流，运放输出的电流全部流向了负载 $C_L$ (约 140 uA, 带来 27 V/us 的 SR)

<!-- 也就是说，当运放进入 slewing 阶段时, Vin- 端的寄生电容大约有 1.5 pF, 导致 260 uA 的输出电流有 60 uA 流向了 Vin- 端，这是导致运放 SR 下降的主要原因。在看看下降沿的 slewing 阶段：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-15-01-45-37_Why is the Simulated SR Lower Than The Theoretical Value.png"/></div>

也是类似的情况，运放的输出电流有相当一部分流向了 Vin- 端的寄生电容，导致 SR 下降。
 -->

也就是说，第一阶段导致 SR 下降的主要原因是 Vin- 端流入电流较大 (等效寄生电容较大)，而第二阶段则是由于 M4 的电流从零上升到 85 uA, 导致总输出电流下降到 190 uA。

### Detailed Analysis

下面就来分析上面两种现象背后的原理：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-15-13-55-23_Why is the Simulated SR Lower Than The Theoretical Value.png"/></div>

第一阶段 cause 1 之所以有这么大的等效电容，是受 Miller effect 的影响: M1 |Vgs| 下降的同时, |Vds| 却在上升，使 M1 构成一个具有数十倍增益的 Av, Ggd 被放大，导致等效输入电容较大。在第二阶段，由于 Vout 节点 (drain of M4) 电压上升, M4 从 linear region 过渡到 saturation region, 具有一定的电流 (这也解释了 vout 继续上升而 Id4 变化不大)，从而使输出电流降低。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-15-14-08-39_Why is the Simulated SR Lower Than The Theoretical Value.png"/></div>



## Conclusion

综上所述，运放 SR 下降主要有两个原因：其一是第一阶段的 Miller effect 导致的 Vin- 等效电容较大，其二是第二阶段晶体管由 linear region 回到 saturation region 导致的输出电流减小。这两个因素共同导致了 SR 的下降。

因此，在之后有关 folded-cascode 运放的设计中，如果对 SR 的要求比较严格，我们需要在设计时留有足够的 margin, 以便在实际仿真中能够达到指标。一个不太严谨的经验是依照 $1.6 \, \mathrm{SR}_0 = I_C/C_L$ 来设计运放的支路电流 ($\mathrm{SR}_0$ 为指标要求) 。这样，在仿真测试中, SR 往往能达到设计值的 60% 左右，也即达到 $0.96 \, \mathrm{SR}_0$。 

<!-- 
## Optimization Method

下面，我们就尝试来优化一下运放的设计，看看能否将 SR 提升到约 45 V/us 甚至 50 V/us 。要降低输入管的寄生电容，也即等价于提升 fug, 可以通过缩放输入管的尺寸来实现 (保持 a 大致不变，同时减小 W 和 L)。但是输入管的参数与 DC Gain 和 UGF 有关，减小输入管的尺寸对 gm 影响不大 (因为 a 不变, gm/Id 不变)，但是会降低运放的增益。

为了在提升 SR 的同时保持增益不变，我们考虑同步调整 M9, M10 的尺寸。具体而言，减小 M1 尺寸以提升 fug, 同时提高 M9, M10 的 gm/Id 以获得更高的增益。需要特别注意的是，提高 M1 的 fug 会使 UGF 增大 (因为实际负载电容容值减小)，从而降低 PM (因为次极点位置基本不变)。所以，还需要同步降低 M1 管的 gm, 也就是降低其 gm/Id 值。

具体的优化步骤是：先提升 M1 管的 fug, 并降低其 gm/Id 值，然后再调整 M9 管使直流增益回升到 80 dB 以上。

### Adjust M1, M2


### Adjust M9, M10

 -->

