# Design of A Ultra-Low-Power Low Dropout Regulator (LDO)


> [!Note|style:callout|label:Infor]
> Initially published at 22:33 on 2025-09-09 in Lincang.

## 1. Infor and Results

- 时间: 2025.09.09 ~ 2025.09.xx
- 工艺: <span style='color:red'> TSMC 65nm CMOS </span> (台积电 65nm CMOS 工艺)
- 目标：设计一个 Basic Low Dropout Regulator (LDO), 包括前仿、版图和后仿


项目相关链接：
- [(本文) Design of A Basic Low Dropout Regulator (LDO)](<Projects/Design of A Basic Low Dropout Regulator (LDO).md>)
    - (1) 理论与指导：
    - (2) 设计与前仿：
    - (3) 版图与后仿：


此项目最终的 Report 和 Slides 已经上传到链接 [待上传]()。

主要仿真结果如下：

<div class='center'><span style='font-size: 12px'>

| Parameter | Process | Supply Range | Output Voltage | Static Current | Settling Time | Overshoot | Linear Regulation | Load Regulation | PSRR |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| **Specification** | TSMC 65nm CMOS | 1.8 V ~ 2.8 V @ xxx mA | xxx uA | 1.0 V | xxx ns | mV (xx%) |  |  |  |
| **Pre-Simulation** | TSMC 65nm CMOS | x.xV ~ x.xV |  | xx.xx V | xxx ns | mV (xx%) |  |  |  |
| **Post-Simulation** | TSMC 65nm CMOS | x.xV ~ x.xV |  | xx.xx V | xxx ns | mV (xx%) |  |  |  |

</span>
</div>

## 2. Objective and Schedule


本次 LDO 是导师一个横向项目需要的模块，性能是其次的，最关键是保证稳定性，因此需要非常充分的 PVT 仿真。我们将分别在前仿/后仿阶段进行 **全温度-工艺角仿真** 和 **蒙特卡罗仿真** ，确保设计的 LDO 在各种工况下都能稳定工作。

- [x] (2025.09.09 ~ 2025.09.xx) 1\. 学习理论知识，给出设计指导
- [x] (2025.09.xx ~ 2025.09.xx) 2\. 完成内部运放的设计与前仿
- [x] (2025.09.xx ~ 2025.09.xx) 3\. 完成内部运放的版图与后仿
- [x] (2025.09.xx ~ 2025.09.xx) 4\. 完成 LDO 的简单前仿
- [x] (2025.09.xx ~ 2025.09.xx) 7\. 完成 LDO 的版图与后仿
- [x] (2025.09.xx ~ 2025.09.xx) 8\. 撰写设计报告

## 3. Design Summary

本小节展示了此次设计的 LDO 结构与主要成果 (关键性能指标)。

## Relevant Resources

下面是与本项目主题相关的一些资源，在设计过程中不一定有所参考，但也陈列于此，以期对读者有所帮助：

- [知乎 > LDO 结构分析以及进阶——Aze 的 Analog IC Design 随记](https://zhuanlan.zhihu.com/p/46250208)

## References

- [[1] 知乎 > 王小桃带你读文献：低压差线性稳压器 LDO Low Dropout Regulator](https://zhuanlan.zhihu.com/p/19362115112)
- 