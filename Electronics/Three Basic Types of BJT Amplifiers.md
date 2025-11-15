# BJT (三极管) 三种基本放大器的增益、跨导与输出阻抗

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 00:22 on 2025-02-21 in Lincang.

## 前言

本文对 BJT 的 CE (Common Emitter, 共射), CC (Common Collector, 共集), CB (Common Base, 共基) 三种基本放大结构进行了分析，推导出它们的（小信号）输出阻抗、跨导和增益。并且，我们推导的是各节点均串有电阻的普适情况，因此所得结论可以快速运用于含有 biasing circuit (和 coupling circuit) 的实际电路。

若无特别说明，本文所指的“输出阻抗”、“跨导”和“增益”均指小信号下的参数；在推导相关物理量时，忽略 biasing circuit 和可能存在的 input/output coupling circuit ；并且认为 $\beta$ 较大，可以作近似 $I_E \approx I_C$。


## CE (Common Emitter, 共射)

CE Amplifier (Common Emitter Amplifier), 即共射极放大器，是最基本的 BJT 放大结构，在三种基本放大器中增益最大（增益为负）。因此，在需要较大增益的场合，常常使用 CE 放大器。其输出阻抗 $R_{out}$、跨导 $G_m$ 和增益 $A_{CE}$ 的推导过程如下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-19-48-32_Three Basic Types of BJT Amplifiers.jpg"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-19-47-05_Three Basic Types of BJT Amplifiers.png"/></div>
 -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-00-09-41_BJT (三极管) 三种基本放大器的增益、跨导与输出阻抗.png"/></div> -->

## CC (Common Collector, 共集)

CC Amplifier (Common Collector Amplifier), 即共集极放大器，也称为 EF (Emitter Follower, 发射极跟随器)。其增益为正且小于 1，输入阻抗较高而输出阻抗较低，常用作电压放大器的输出级。其增益推导过程如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-19-48-15_Three Basic Types of BJT Amplifiers.jpg"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-19-47-12_Three Basic Types of BJT Amplifiers.png"/></div> -->
<!-- 
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-00-09-52_BJT (三极管) 三种基本放大器的增益、跨导与输出阻抗.png"/></div>
 -->

## CB (Common Base, 共基)

CB Amplifier (Common Base Amplifier), 即共基极放大器，其增益较大且为正，具有较低的输入阻抗（一般为几十欧）。其增益推导过程如下：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-00-09-58_BJT (三极管) 三种基本放大器的增益、跨导与输出阻抗.png"/></div>
 -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-14-08-08_BJT (三极管) 三种基本放大器的增益、跨导与输出阻抗.png"/></div> -->

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-19-47-20_Three Basic Types of BJT Amplifiers.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-19-48-47_Three Basic Types of BJT Amplifiers.jpg"/></div>