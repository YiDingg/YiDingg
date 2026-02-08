# 202510_onc18_CPPLL_ultra_low_lower (docs-4) 2026.01.27 锁相环 testbench 使用说明

>本文内容已在 **《202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 (updated on 2026.01.27)》** (后简称《前仿报告》) 中的 **7.2 testbench explanations** 一节中给出过，现单独提取出来，以便阅读和查阅。

## 1. Testbench Overview

我们这边交付给需求方的 lib 称为 `MyLib_202510_PLL_onc18__EX_20260110`，表示在 2026.01.10 导出的版本。该 lib 共包含三个 testbench cell, 分别为：
- `TB_PLL`： 单独对 PLL 进行仿真
- `TB_PLL_withDigitalLDO`：数字 LDO 和 PLL 的联合仿真，此时两部分还未合并到一个 cell 中
- `TB_TOP`： digital LDO 和 PLL 合并为一个 cell `202510_PLL_withDigitalLDO` 后，对整体进行仿真

它们的原理图在《前仿报告》的 **5.0 testbench** 一节中已经展示过，这里不再重复给出。TB 打开后直接运行即可，仿真变量命名都比较直观，可根据情况自行调整，也可参考《前仿报告》文中给出的 `all_SL/all_load/all_corner` 等各项仿真设置。

## 2. Testbench Explanations (updated on 2026.01.27)

下面是仿真变量即设置的一些详细说明。

先从需求方提到的 `TB_PLL_withDigitalLDO` 说起，这是数字 LDO 和 PLL 联合仿真的 testbench (两部分并未合并到一个 cell 中)，也就是 testbench schematic 中手动调用了 `vplus_gen_top` 和 `202510_PLL_v3` 两个 cell 进行仿真。

`TB_PLL_withDigitalLDO` 的默认打开方式是 `ADE Assembler`，打开可以看到其中有多个仿真项 (每条都是一个 Explorer)，除一部分已废弃的之外，剩余几个只在 "高性能仿真模式设置" 上存在区别，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-27-23-31-14_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

然后在 ADE Assembler 视图，说明一下仿真变量的含义和设置：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-28-00-26-52_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

一般情况下，上述参数的值都不需要修改，直接运行仿真即可。

至于 outputs 中的一系列输出表达式/值是什么意思，我们已在前仿报告的仿真结果 (图片中) 给出过详细说明，这里不再赘述。




