# Monthly Summary (2025.05)

> [!Note|style:callout|label:Infor]
Initially published at 12:19 on 2025-05-30 in Beijing.

## 本月概览


本月主要是在学习 CMOS 的第九章 Op Amp 和 Cadence 的使用方法，另外还熟悉了 LTspice 在 analog IC 层面的仿真，学习了运放设计的 gm-Id 方法。月初读完 OCTC (ZTC) 的论文之后，频响分析的学习便告一段落了，如果之后确实有必要使用 TTC 等方法，再找相关的论文学习即可。

## 本月具体内容

具体而言，我们：
- 学习了频响分析的开路时间常数法 (OCTC, open-circuit time constant method)
- 分析、设计并验证了 discrete uA741 等三个运放，测量了 uA741 分立运放的具体参数，包括 Vos, Av, PSRR, 和 GBW 等
- 学习了 *Razavi CMOS* 第九章 "Op Amp" 和第十章 "Stability and Compensation"
- 利用平方律模型 (SPICE Level 1) 和常规的 overdrive voltage 方法设计了 differential folded-cascode stage, 并在 LTspice 完成仿真验证
- 在本地部署 Cadence IC618, 学习了 schematic 层面的仿真方法
- 详细配置了 cadence 的环境变量文件 `.cdsenv` 和初始化文件 `.cdsinit` 以提高 cadence 使用效率，例如键盘快捷键、界面字体和窗口大小、仿真图的样式和颜色等
- 学习了 cadence 的工艺库添加方法，包括常见的 CDB 和 OA 格式等 (PDK 一般都是 CDB 格式)，并依此在 cadence 中添加了台积电 180 nm CMOS 工艺库 `tsmc18rf`
- 学习了 Cadence SKILL 语言的基本用法，构建常用操作的 SKILL 代码，例如导出仿真数据、导出仿真波形图等
- 学习了运放设计的 gm-Id 方法，在 cadence 的 `tsmc18rf` 工艺库中，依此方法设计了经典五管 OTA (five-transistor OTA), 进行了仿真验证，最终满足各项设计指标
- 开发了基于 gm-Id 方法的 MATLAB 程序，用于辅助晶体管参数的计算和设计：在给定的指标要求下，评估晶体管的综合性能分数，绘制出性能分数关于自变量 $\frac{g_m}{I_D}$ 和 $L$ 的变化情况 (三维图)，确定满足所有指标要求的自变量取值范围，最终给出满足指标要求的“最佳晶体管参数”



## 下月计划

科研实践共有两个题目，一个比较基础 (BGR, LDO 等)，另一个更进阶一些 (PPL, CDR, RX TX 等)，而我们仨都选择了更难的一题。具体而言，我选择的是 RX 方向，因为它与我目前的知识库直接接轨，可以在学习众多新内容的同时，很好地利用、巩固已学过的基础知识。

因此，接下来一段时间（科研实践开始之前）需要学习的内容非常多，还未学习的理论知识便包括 Razavi CMOS 第十一章 "Nanometer Design" 、第十六章 "phase-locked loop" ，以及 Razavi RF 中与 RX 相关的内容；除此之外，还需要进一步熟悉 cadence 的使用，学习版图设计的具体内容（我们到时候需要自己画版图）。
