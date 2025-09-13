# Design of A Ultra-Low-Power Low Dropout Regulator (LDO) for BB-PLL


> [!Note|style:callout|label:Infor]
> Initially published at 22:33 on 2025-09-09 in Lincang.


项目相关链接：
- [(本文) Design of A Basic Low Dropout Regulator (LDO)](<Projects/Design of A Basic Low Dropout Regulator (LDO).md>)
    - (1) 理论与指导：
    - (2) 设计与前仿：
    - (3) 版图与后仿：

## 1. Information

- 时间: 2025.09.09 ~ 2025.09.25
- 工艺:  <span style='color:red'>TSMC 65NM COMS </span> Mixed Signal RF SALICIDE Low-K IMD 1P6M-1P9M PDK (CRN65GP)
- 目标：设计一个 Basic Low Dropout Regulator (LDO), 包括前仿、版图和后仿


项目完整指标要求已上传到 123 云盘链接 [https://www.123684.com/s/0y0pTd-FRSj3](https://www.123684.com/s/0y0pTd-FRSj3)，下面是几个关键点：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-12-23-44-14_Design of A Basic Low Dropout Regulator (LDO).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-12-23-47-18_Design of A Basic Low Dropout Regulator (LDO).png"/></div>



## 2. Objective and Schedule


本次 LDO 是导师一个 3.3 GHz BB-PLL 合作项目中需要的模块，性能是其次的，最关键是保证稳定性，因此需要非常充分的 PVT 仿真。我们将依次在前仿/后仿阶段进行 **全温度-工艺角仿真** 和 **蒙特卡罗仿真**，确保 LDO 在各种工况下都能稳定工作。

- [x] (2025.09.09 ~ 2025.09.10) 1\. 学习理论知识，给出设计指导
- [x] (2025.09.11 ~ 2025.09.12) 2\. 熟悉 65nm 工艺库，完成 gm/Id 仿真
- [x] (2025.09.13 ~ 2025.09.xx) 3\. 完成内部运放的设计与前仿
- [x] (2025.09.xx ~ 2025.09.xx) 4\. 完成内部运放的版图与后仿
- [x] (2025.09.xx ~ 2025.09.xx) 5\. 完成 LDO 的简单前仿
- [x] (2025.09.xx ~ 2025.09.xx) 6\. 完成 LDO 的版图与后仿
- [x] (2025.09.xx ~ 2025.09.xx) 7\. 撰写设计报告


## 3. Design Summary

主要仿真结果如下：

<div class='center'><span style='font-size: 12px'>

| Parameter | Process | Supply Range | Output Voltage | Static Current | Settling Time | Overshoot | Linear Regulation | Load Regulation | PSRR |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| **Specification**   | TSMC 65nm CMOS | 1.710 V ~ 2.625 V | 1.2 V | not given | not given | not given | < -40 dB | not given | -40 dB @ 5 MHz |
| **Pre-Simulation**  | TSMC 65nm CMOS | x.xV ~ x.xV |  | xx.xx V | xxx ns | mV (xx%) |  |  |  |
| **Post-Simulation** | TSMC 65nm CMOS | x.xV ~ x.xV |  | xx.xx V | xxx ns | mV (xx%) |  |  |  |

</span>
</div>

此项目最终的 Report 和 Slides 已经上传到 123 云盘链接 [https://www.123684.com/s/0y0pTd-FRSj3](https://www.123684.com/s/0y0pTd-FRSj3)


## Relevant Resources

下面是与本项目主题相关的一些资源，在设计过程中不一定有所参考，但也陈列于此，以期对读者有所帮助：

- [知乎 > LDO 结构分析以及进阶——Aze 的 Analog IC Design 随记](https://zhuanlan.zhihu.com/p/46250208)

## References

- [[1] 知乎 > 王小桃带你读文献：低压差线性稳压器 LDO Low Dropout Regulator](https://zhuanlan.zhihu.com/p/19362115112)
- [[2]](https://libyw.ucas.ac.cn/https/63HNga92DoxwAYPr51CYnV8eWBha67Ly8CNtBH8tNL/document/10762683/) X. Liang, X. Kuang, J. Yang, and L. Wang, “A Fast Transient Response Output-capacitorless LDO With Low Quiescent Power,” in 2024 3rd International Conference on Electronics and Information Technology (EIT), Chengdu, China: IEEE, Sep. 2024, pp. 314–317. doi: 10.1109/EIT63098.2024.10762683.
- [3] M. M. Elkhatib, “A capacitor-less LDO with improved transient response using neuromorphic spiking technique,” in 2016 28th International Conference on Microelectronics (ICM), Giza, Egypt: IEEE, Dec. 2016, pp. 133–136. doi: 10.1109/ICM.2016.7847927.