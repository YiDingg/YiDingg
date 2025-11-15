# Monthly Summary (2025.03)

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 16:11 on 2025-04-05 in Beijing.


这个月主要还是在学习模电，或者说我校的“线性电子电路”课程。当然，我是完全不使用我校“电子技术基础（线性部分）”这本教材的，看的是 Razavi 的 Fundamentals of Microelectronics 。系统地学习了 BJT 和 MOS 的基本特性、基本放大器、 biasing 、差分放大器（差分-差分与差分-单端）、输出级、多级放大电路、简单的运放结构等，几乎所有的公式、结论都自己推导了（至少）一遍，自认为掌握得比较扎实（ MOS 的内容其实算复习）。当然，相关的仿真也做了不少，也实际搭过几个放大电路。

除了上面的理论知识，对晶体管的完整测量工作流也已经搭建完成。前不久才对 SS8050 (NPN) 作了全面的测量 (实验记录见 [https://mp.weixin.qq.com/s/g6ipoFPNAyWVrZp3coHYbQ](https://mp.weixin.qq.com/s/g6ipoFPNAyWVrZp3coHYbQ))，得到其常见的几个特性曲线。我们还利用 MATLAB 处理了相关数据，计算得到各种小信号参数，包括 $\beta$, $g_m$, $r_O$, $r_{\pi}$ 等（这部分代码已作了封装）。作了一些简单的拟合，将理论中的内容和实际测得的数据结合起来，进一步加深对晶体管的理解。

Razavi CMOS 的进度没有推多少，只在本月中旬时抽空对已学的内容（前五章）稍微回顾了一下。

下个月进入学习频响和反馈的学习，这些部分是模电的难点，也是绝对的重点，必须熟练掌握。我打算在 microelectronics 的基础上（ BJT 与 MOS 并进），（如果有时间的话）同步推进 CMOS 的频响和反馈章节。两者从原理、内容上其实是有相似的，但是，考虑到国科大《线性电子线路》课程的无聊却成绩占比很高的期中期末考试，我不得不把主要精力放在 microelectronics 上（因为这本书的内容和我校线电教材能大致对应，但显然前者的质量比后者高太多）。

另外，最近也了解到一些传递函数的辅助分析方法，例如 Miller 的 Miller theorem, 各种 time constant methods, Middlebrook 的 EET (extra element theorem) 及其衍生的 TEET 和 NEET, 以及 Hajimiri 的 TTC (time and transfer constants method) 等 。后续将会在相关资料的辅助下，分别找几篇论文读一读，感受它们的联系与区别，最后熟练掌握其中一两种即可。毕竟我们的目的是快速而准确地求出（或估计）传递函数，方法太多反而浪费时间。
