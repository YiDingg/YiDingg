# Negative VCVS Test

> [!Note|style:callout|label:Infor]
Initially published at 12:20 on 2025-02-20 in Lincang.

## 前言

先前我们在 [General VCVS and VCCS (up to 10 A)](<ElectronicDesigns/General VCVS and VCCS (up to 10 A).md>) 已经介绍过 VCVS ，但是当时的 VCVS 仅限于输出电压为正的情况，也就是正输出半区。在实际电路中，我们有时候也需要输出负电压，这时候就需要使用负输出半区的 VCVS ，即负 VCVS 。

本文基于正半区的 VCVS 电路，对负半区的 VCVS 提出几种猜想，并进行实际测试。



## 方案一

直接对正半区的 VCVS 电路的输出部分做一个 level shift ，得到第一种负半区 VCVS ，如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-02-30-01_Negative VCVS Test.png"/></div>

这种电路的好处是简单，与正半区 VCVS 电路的思路基本一致，只是输出电压的极性相反。但是缺点也很明显，那便是输出电压的负端是 `VCC-`，这不便于输出接近 0 的负压。尤其是低负载的情况，假设我们的 `VCC-` 是 -5V ，负载电阻 1Ohm，输出 -1V 会导致 4A 的电流（正端 -1V，负端 -5V），这会带来一些潜在的问题。从另一个方面考虑，输出电压负端是 `VCC-` 会导致电路的输出与 `VCC-` 电源严重耦合。

下面是测试结果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-12-53-58_Negative VCVS Test.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-12-54-03_Negative VCVS Test.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-12-54-07_Negative VCVS Test.png"/></div>


## 方案二

另一种方案是将输出电压换到 MOS 的 Drain 端，如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-12-51-52_Negative VCVS Test.png"/></div>

要达成负反馈，反馈线应接到 OPA 的正输入端。经过测试，输出有明显的振荡，无法达到要求（即使添加补偿电容也无明显改善），如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-12-53-46_Negative VCVS Test.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-12-53-27_Negative VCVS Test.png"/></div> -->