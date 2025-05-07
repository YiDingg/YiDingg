# Monthly Summary (2025.04)

> [!Note|style:callout|label:Infor]
Initially published at 19:21 on 2025-04-30 in Beijing.

四月中旬到五月中旬是国科大特有的“期中月”，课程复习消耗了我太多青春，因此本月只有不到两周的时间在学习新知识。具体而言，我们学习了 CMOS 和微电子的频响、反馈两个章节。目前打算在五一器件阅读、学习时间常数法的相关论文，把所谓“node-pole theorem”的理论基础打扎实，因为这个定理（思想）在传函分析中用得非常多。

频响自认为掌握得还算比较熟练，关于反馈, CMOS 中介绍了 two-port analysis, Bode's method, Blackman's impedance theorem 和 Middlebrook's method 共四块内容，除了 Blackman 主要用于阻抗分析，剩下的三种都是用于分析传函的经典方法。我们较熟练了掌握了前两种，
在“反馈”一章结束之后，学校线电课程的内容便和 CMOS 或微电子对不上了，如何在学习线电课程的同时，尽可能推进 CMOS 的进度（以满足暑期科研实践要求）成了一个问题。目前我还没有想到很好的解决方案。

除了理论知识上的学习，我们也多次搭建各种组态 amplifier 的实际或仿真电路，对理论分析进行了验证，同时对 Miller approximation 的精度有了定量的感受，明白了什么情况下 Miller 近似精度较高，也清楚了如何用 Miller 来求解第二极点的位置 (用 integration)。除了最经典的 Miller theorem 及其对偶形式 (导纳的 Miller theorem)，我们还学习了 EET (extra element theorem)，为电路传函的精确求解提供了便利。

另外，借助之前搭建的 basic op amp measurement board (参考 ADI 的技术手册)，我们测量了 NE5532 通用运放的基本参数，包括输入失调电压、输入偏置/失调电流、 open-loop gain (包括 DC 值和 AC 频响曲线)、以及 DC 和 AC 下的 CMRR 和 PSRR. 为了实现运放中低频增益的更精确测量，我们又读了几篇运放测量的论文，并从中找出了两种比较合适的测量电路，后续会先用面包板验证，然后搭建 PCB, 并用此 PCB 对运放的中低频增益曲线、 SR 、输出摆幅等进行测量。这样，我们就完成了运放测量的全部基本内容。

在下个月，我们将利用分立 BJT 元件搭建运放 uA741，用分立 MOS 搭建 basic two-stage op amp, 对它们的原理进行分析，并利用上面提到的板子进行实际测量。
