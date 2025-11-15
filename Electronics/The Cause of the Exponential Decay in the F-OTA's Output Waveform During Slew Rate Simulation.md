# The Cause of the Exponential Decay in the F-OTA's Output Waveform During Slew Rate Simulation <br> (五管 OTA 在压摆率仿真中输出波形呈指数下降的原因)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 23:53 on 2025-05-28 in Beijing.


在文章 [Design Example of F-OTA using Gm-Id Method](<AnalogIC/Virtuoso Tutorials - 6. Design Example of F-OTA using Gm-Id Method.md>) 中，我们利用 gm-Id 方法设计了一个经典 five-transistor OTA, 并在 cadence 中进行了仿真验证。我们注意到，在 SR 的仿真结果中 (F-OTA 设置为 unit buffer)，输出波形在下降时具有明显的指数衰减特性，本文将探讨这一现象的具体原因。

事实上，这一指数衰减现象是输入/输出电压超过阈值，导致某些晶体管进入 triode region or cut-off region 的结果，是典型的非线性效应。具体分析过程如下：

<div class="center"><img width=600px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-29-00-00-36_The Cause of the Exponential Decay in the F-OTA's Output Waveform During Slew Rate Simulation.png"/></div>

至于为什么上升沿没有出现类似现象（或者说不明显），这是因为 $V_{out}$ 在达到稳定之前, OTA 提供给电容的电流 $I_C$ 基本可以维持在 $I_{SS}$ 的水平，如下：

<div class="center"><img width=600px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-29-00-02-33_The Cause of the Exponential Decay in the F-OTA's Output Waveform During Slew Rate Simulation.png"/></div>

