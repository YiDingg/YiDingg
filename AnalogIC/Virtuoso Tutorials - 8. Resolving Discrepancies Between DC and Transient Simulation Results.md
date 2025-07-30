# Resolving Discrepancies Between DC and Transient Simulation Results

> [!Note|style:callout|label:Infor]
> Initially published at 21:45 on 2025-07-30 in Beijing.

## 1. Background

### 1.1 Issue Origin

起因是在最近 “科研实践一” 的 [Low-Voltage BGR](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>) 设计中，发现 dc-sweep-temperature 的仿真结果与 tran 得到的结果明显不同。对于要进行 ac 小信号分析的情况，解决方案已经在文章 [Using Tran Result as the DC Operation Point for AC Simulation](<AnalogIC/Virtuoso Tutorials - 7. Using Tran Result as the DC Operation Point for AC Simulation.md>) 中介绍过。但现在，我们需要对温度进行直流扫描，依靠上一篇文章的方案并不能解决，因此，本文就来介绍如何 “从根源” 上解决这个问题。

### 1.2 Problem Description

我们先介绍 "仿真结果不同" 具体体现在哪。所用的 BGR 电路及版图如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-22-46-21_Virtuoso Tutorials - 8. Resolving Discrepancies Between DC and Transient Simulation Results.png"/></div>

按正常设置对此电路的 calibre view 进行 dc 直流工作点仿真 (TT + 27 °C)，得到的直流工作点如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-22-53-01_Virtuoso Tutorials - 8. Resolving Discrepancies Between DC and Transient Simulation Results.png"/></div>
其中 Id_start_up = 42.94 uA 显然不正常，因此这个工作状态是错误的。在温度扫描 (dc-sweep-temperature) 中也可复现这个错误工作点 (设置起始温度为 27 °C):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-23-01-13_Virtuoso Tutorials - 8. Resolving Discrepancies Between DC and Transient Simulation Results.png"/></div>

注意，上面必须选定起始温度为 27 °C 才能得到相同的结果，因为温度扫描的后续结果是基于起始点的。如果设置起始温度为 -40 °C, 得到完全不同的起始点后，后续的结果也会不同 (如下图)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-23-00-42_Virtuoso Tutorials - 8. Resolving Discrepancies Between DC and Transient Simulation Results.png"/></div>


与上面的结果相反，进行 tran 仿真得到的 "正确" 工作点 (TT + 27 °C) 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-23-05-23_Virtuoso Tutorials - 8. Resolving Discrepancies Between DC and Transient Simulation Results.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-23-19-25_Virtuoso Tutorials - 8. Resolving Discrepancies Between DC and Transient Simulation Results.png"/></div>

我们认为 tran 仿真得到的工作点才是正确的，因此下面就寻求解决方案，使 dc 的结果尽量收敛到 tran 仿真得到的瞬态工作点。



### 1.3 Possible Solutions

在网上搜索了一下，发现有很多网友都提到过类似的现象，下面是几种可能的解决方案：

<div class='center'>

| 解决方案 | 理由 | 评价 |
|:-:|:-:|:-:|
 | (1) 直接把 schematic 中的启动电路删除 | 因为直流工作点错误基本上都是启动电路导致的 (仿真器无法正确识别启动电路的作用)，删除启动电路通常能使 dc 仿真收敛到正确的工作点 | 这对于需要严谨进行前仿和后仿的我们显然不现实，因此不考虑 |
 | (2) 在 dc 仿真的设置中，把关键点赋予一个初始态，比如拉到 VDD 或者 VSS | 使 DC 仿真收敛到正确的工作状态 | **严谨而实用，因此推荐使用此方案** |
 | (3) 在 tran 仿真中保存特定时刻 (例如结束时) 的电路状态，作为 dc 仿真的初始值 | 使 DC 仿真具有正确的工作状态 | 十分有效但是比较麻烦，详见这个问答 [微波 EDA 网 > 基准电路瞬态仿真和 DC 扫描温度结果不一致](http://ee.mweda.com/ask/402108.html) |
</div>

## 2. Solution 2 Implementation

我们先参考这个问答 [EETOP > virtuoso 如何设置某个节点的初始电压值](https://bbs.eetop.cn/thread-663990-1-1.html) 中给出的步骤试了下，发现完全没有效果。于是将步骤稍作修改：在 `Simulation > Convergence Aids > Node Set` 中找到想要有初始值的节点 (而不是在 `Convergence Aids > Initial Condition` 中)。为了使结果充分收敛，我们需要让运放成功进入负反馈回路，这可以通过设置 Vx = VDD 且 Vy = 0 得到 (Vin- = Vx, Vin+ = Vy) 做到, 也即设置 MM3_d = VDD 而 MM4_d = 0, 如下图:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-23-44-16_Virtuoso Tutorials - 8. Resolving Discrepancies Between DC and Transient Simulation Results.png"/></div>

点击 apply 应用设置，然后重新仿真：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-23-16-25_Virtuoso Tutorials - 8. Resolving Discrepancies Between DC and Transient Simulation Results.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-23-47-16_Virtuoso Tutorials - 8. Resolving Discrepancies Between DC and Transient Simulation Results.png"/></div>

这次, dc 仿真结果便与 tran 仿真结果完全一致了 (经过检查，在相当多的小数点后都相同)，问题得到解决。

这次实践告诫我们，在 BGR 的相关仿真中，包括直流工作点、温度扫描、蒙特卡洛仿真等，我们都应该重视初始条件的设置，以确保直流工作点是正确的工作点。按上面方法设置初始条件后，重新进行蒙特卡洛仿真，结果如下 (samples = 20):



与文章 [202507_tsmcN28_BGR__scientific_research_practice_1](<AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1.md>) 的 **4.5 (mc) average and TC (all-temps, all-corners, 1.2 V)** 中的结果不同，这次的新结果就明显没有那么多偏离正常工作点的情况，体现了正确设置初始条件的重要性。



## 3. Solution 3 Implementation

参考这篇文章 [一种设置瞬态仿真初始态的方法](https://zhuanlan.zhihu.com/p/24416542)，我们这里略过。


## References



