# Using Transient Operation Point for AC Simulation

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 23:27 on 2025-07-29 in Beijing.


## 1. 背景

起因是在最近 “科研实践一” 的 [Low-Voltage BGR](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>) 设计中，需要仿真 BGR 的 PSRR 情况，但是发现后仿结果中 dc opt (dc operation point) 得到的直流工作点异常，导致 PSRR 结果不对。


经过测试, dc opt 仿真下 BGR 无法正常启动，但瞬态仿真下可以正常启动。具体而言, dc opt 得到的 V_BG ≈ 430 mV, 而 tran 得到的 V_BG ≈ 520 mV, 如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-23-36-41_Virtuoso Tutorials - 7. Using Tran Result as the DC Operation Point for AC Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-23-32-00_Virtuoso Tutorials - 7. Using Tran Result as the DC Operation Point for AC Simulation.png"/></div>

上网搜了下，这个现象并不少见，很多网友都提到过类似的现象，主要原因是 dc opt 不能正确识别启动电路的作用，从而导致了错误的仿真结果。那么我们该相信哪一种仿真结果呢？问过师兄和老师，综合网上的各路回答，可以总结成一句话：
**<span style='color:red'> you must believe tran simulation result. </span>**


## 2. 在瞬态工作点进行 ac 仿真 (正确结果)

在进行瞬态工作点的 ac 仿真之前，先进行一次 tran 仿真，找到我们需要的时间点 (例如电路状态充分收敛之后的某个时刻)。然后：
- 打开 Tran 仿真进入 Options
- 找到 Output 一栏，滑到最下方的 ACTIMES SETTINGS 处
- 输入 `actimes = 2.5 us` (或其他你需要的时间点)，输入 `acnames = ac` (也即在此时间点进行 ac 仿真)
- 按照常规方式设置 ac 仿真，<span style='color:red'> 并确保 ac 仿真在 tran 仿真之后 </span>
- 正常运行仿真即可

具体操作如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-23-57-24_Virtuoso Tutorials - 7. Using Tran Result as the DC Operation Point for AC Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-23-58-28_Virtuoso Tutorials - 7. Using Tran Result as the DC Operation Point for AC Simulation.png"/></div>

得到正确的仿真结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-07-30_Virtuoso Tutorials - 7. Using Tran Result as the DC Operation Point for AC Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-15-36_Virtuoso Tutorials - 7. Using Tran Result as the DC Operation Point for AC Simulation.png"/></div>

## 3. 在 dc opt 进行 ac 仿真 (错误结果)

为了方便对比，我们给出用 dc opt 作为 ac 仿真直流工作点所得到的**错误结果**：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-20-23_Virtuoso Tutorials - 7. Using Tran Result as the DC Operation Point for AC Simulation.png"/></div>


## References

- [Cadence IC618 中如何在时域 TRAN 仿真的特定时刻进行 AC 仿真](https://www.analog-life.com/2022/12/how-to-perform-ac-simulation-at-specific-moments-of-tran-simulation-in-cadence-ic-618/)
- [知乎 > 如何在 tran 仿真的过程中进行小信号相关的仿真？](https://zhuanlan.zhihu.com/p/344932538)
- [微波 EDA 网 > bandgap 做 tran 仿真和 dc 仿真时看到结果不同](http://ee.mweda.com/ask/410728.html)