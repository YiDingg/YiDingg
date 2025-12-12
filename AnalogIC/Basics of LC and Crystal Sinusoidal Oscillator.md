# Basics of LC and Crystal Sinusoidal Oscillator

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 03:09 on 2025-12-03 in Beijing.

## Introduction

三点式 LC 正弦振荡器 (three-point LC sinusoidal oscillator, 后文简称 **TPSO**) 是正弦振荡器最常见的拓扑结构之一。它利用 LC 谐振回路作为频率选择网络，通过正反馈实现自激振荡。本文将介绍三点式 LC 振荡器的基本原理、工作机制及其设计要点。

## 1. LC Sine Oscillator

本文仅介绍基于晶体管的电容式三点 LC 振荡器，根据反馈网络的不同，三点式 LC 振荡器主要分为以下三种类型：

<div class='center'>

| Type | Colpitts Oscillator <br> (考毕兹振荡器) | Clapp Oscillator <br> (克拉泼振荡器) | Seiler Oscillator <br> (西勒振荡器) |
|:-:|:-:|:-:|:-:|
 | 振荡频率 | $f_{osc} = \frac{1}{\sqrt{L(C_1\parallel C_2)}}$ | $f_{osc} = \frac{1}{\sqrt{L(C_1\parallel C_2 \parallel C_3)}} \approx \frac{1}{\sqrt{L C_3}}$ | $f_{osc} = \frac{1}{\sqrt{L[(C_1\parallel C_2 \parallel C_3) + C_4]}} \approx \frac{1}{\sqrt{L (C_3 + C_4)}}$ |
 | 描述 | 电容式 TPSO 的最基本形式，由一个晶体管、两个电容和一个电感构成核心振荡部分 | Colpitts (考毕兹) 振荡器的改进型，通过在电感支路中串联一个小电容 $C_3$ 来保证不同频率下的振荡稳定性 | Clapp (克拉泼) 振荡器的进一步改良，在电感两端并联一个可变电容 $C_4$ 来实现宽范围调谐，同时保持高频率稳定性 | 
 | 详细描述 | 结构最为简单，但存在一个主要缺点：反馈系数由电容比值 $\frac{C_1}{C_2}$ 决定，当通过可变电容 $C_1$ 或 $C_2$ 来调整振荡频率时，会不可避免地改变反馈系数，引起输出振幅不稳定甚至停振。 | Clapp Oscillator (克拉泼振荡器) 在 Colpitts (考毕兹) 的电感支路中串联了一个小电容 $C_3$，使得回路的总谐振电容主要由这个数值较小的 $C_3$ 决定，而原来负责提供反馈的 $C_1$ 和 $C_2$ 可以取较大值；这样，使用可变电容 C3 来调整振荡频率时，对反馈系数的影响就微乎其微，大大提高了频率稳定性。然而，克拉泼电路引入了一个新限制：为了保持 $C_3$ 对总电容的主导作用，其值必须很小，这导致谐振时回路阻抗 (等效负载阻抗) 降低。因此，当调高频率 (减小 $C_3$) 时，振荡幅度会显著下降，使得它在高频段的调谐范围很窄，实用性受限。 | Seiler Oscillator (西勒振荡器) 是 Clapp (克拉泼) 电路的进一步改良，在电感两端并联了一个可变电容 $C_4$ (其它三个电容不变)，由 $C_4$ 来调节振荡频率。这种设计的妙处在于，调谐时不仅不影响反馈系数，而且回路阻抗 (等效负载阻抗) 在很宽的频率范围内较为平缓。因此，西勒振荡器在保持高频率稳定性的同时，获得了非常宽的调谐范围，且在整个范围内输出幅度较为均匀，特别适合于需要宽范围、高稳定度调谐的场合。 |
 | 电路图与高频等效电路 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-21-29-57_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-21-31-24_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-21-32-26_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> |
</div>

注意，上面给出的振荡频率公式均为理想化近似表达式，实际设计中需考虑电感的寄生电容、晶体管的输入输出电容等因素对电路的影响。需特别注意的是，晶体管的寄生电容一般会使得实际振荡频率低于理论值，以 Colpitts Oscillator (考毕兹振荡器) 为例：

$$
\begin{gather}
f_{osc} = \frac{1}{\sqrt{L(C_1\parallel C_2)}}
\longmapsto
f_{osc} = \frac{1}{\sqrt{L\{[(C_1 + C_{ce})\parallel (C_2 + C_{\pi})] + C_{\mu}\}} + C_p}
\end{gather}
$$

其中 $C_{ce},\ C_{\pi},\ C_{\mu}$ 分别为晶体管在 CE, CB, BE 端的寄生电容，$C_p$ 为电感的寄生并联电容。

## 2. Quartz Crystal Oscillator

石英晶体振荡器 (quartz crystal oscillator) 是利用石英晶体的压电效应和高 Q 值特性来实现高稳定度振荡的电路。石英晶体在电路中通常表现为一个高 Q 值的谐振器，其等效电路可以表示为一个串联谐振回路 (由 $L_s, C_s, R_s$ 组成) 并联一个静态电容 $C_s$。

石英晶体的等效模型及其阻抗特性如下；

<div class='center'>

| 等效模型 | 阻抗特性 |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-04-00-41-00_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-04-00-19-23_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> |

</div>


下面是几种常见的石英晶体振荡器电路拓扑：

<div class='center'>

| Colpitts Crystal Oscillator | Pierce Crystal Oscillator | CMOS Quartz Crystal Oscillator | Microprocessor Crystal Quartz Clocks |
|:-:|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-04-00-31-56_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-04-00-30-42_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-04-00-32-37_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-04-00-32-51_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> |
</div>

## Further Reading

<div class='center'>

|  |
|:-:|
 | [{2} 知乎 > 皮尔斯振荡器电路工作原理图解，几分钟，立马搞定皮尔斯震荡电路](https://zhuanlan.zhihu.com/p/530018592)  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-22-34-49_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-22-35-39_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> |
 | [{3} 知乎 > Colpitts 振荡器电路图分析，几分钟，立马搞定Colpitts 振荡器电路](https://zhuanlan.zhihu.com/p/529633200) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-22-36-07_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-22-37-50_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-22-38-01_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> |
 | [{4} Electronic Tutorials > The Colpitts Oscillator](https://www.electronics-tutorials.ws/oscillator/colpitts.html) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-22-36-40_Basics of Three-Point LC Sinusoidal Oscillator.png"/></div> |
</div>



## Reference

相关资料/博客/文章：
- [{1} 知乎 > 电容三点式振荡电路怎么形成的正反馈？](https://www.zhihu.com/question/332937900/answer/1918031620067291899)
- [{2} 知乎 > 皮尔斯振荡器电路工作原理图解，几分钟，立马搞定皮尔斯震荡电路](https://zhuanlan.zhihu.com/p/530018592)
- [{3} 知乎 > Colpitts 振荡器电路图分析，几分钟，立马搞定Colpitts 振荡器电路](https://zhuanlan.zhihu.com/p/529633200)
- [{4} Electronic Tutorials > The Colpitts Oscillator](https://www.electronics-tutorials.ws/oscillator/colpitts.html)
- [{5} Electronic Tutorials > Quartz Crystal Oscillators](https://www.electronics-tutorials.ws/oscillator/crystal.html)

相关文献：
- [[1]](https://picture.iczhiku.com/resource/eetop/shigwIRlqyQHIxbb.pdf) E. A. Vittoz, M. G. R. Degrauwe and S. Bitz, "High-performance crystal oscillator circuits: theory and application," in IEEE Journal of Solid-State Circuits, vol. 23, no. 3, pp. 774-783, June 1988, [doi: 10.1109/4.318.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=318) 
