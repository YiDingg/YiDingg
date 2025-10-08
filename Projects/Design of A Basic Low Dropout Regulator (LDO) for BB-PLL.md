# Design of A Basic Low Dropout Regulator (LDO) for BB-PLL <br> <span style='font-size:12px'> A Basic Capacitor-Less LDO with High-Stability (450-pF Maximum Load Capacitance) Achieving -46.68-dB @ 5-MHz PSRR and 20.38 uVrms Output Noise in TSMC 65-nm Technology</span>


> [!Note|style:callout|label:Infor]
> Initially published at 22:33 on 2025-09-09 in Lincang.


## 1. Information

项目基本信息：
- 时间: 2025.09.09 ~ 2025.09.23
- 工艺:  <span style='color:red'>TSMC 65NM COMS </span> Mixed Signal RF SALICIDE Low-K IMD 1P6M-1P9M PDK (CRN65GP)
- 目标：设计一个满足指标要求的 Basic Low Dropout Regulator (LDO), 包括前仿、版图和后仿


项目相关链接：
- [(本文) Design of A Basic Low Dropout Regulator (LDO)](<Projects/Design of A Basic Low Dropout Regulator (LDO) for BB-PLL.md>)
    - (1) 理论与指导：[LDO Stability Analysis and Loop Compensation Mechanism](<AnalogIC/LDO Stability Analysis and Loop Compensation Mechanism.md>)
    - (2) 设计与前仿：[202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (1)](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (1).md>) 和 [202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2)](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).md>)
    - (3) 版图与后仿：[202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.md>)


项目完整指标要求已上传到 123 云盘链接 [https://www.123684.com/s/0y0pTd-FRSj3](https://www.123684.com/s/0y0pTd-FRSj3)，下面是几个关键点：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-12-23-44-14_Design of A Basic Low Dropout Regulator (LDO).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-12-23-47-18_Design of A Basic Low Dropout Regulator (LDO).png"/></div>



## 2. Objective and Schedule


本次 LDO 是导师一个 3.3 GHz BB-PLL 合作项目中需要的模块，性能是其次的，最关键是保证稳定性，因此需要非常充分的 PVT 仿真。我们将在前仿/后仿阶段进行 **全温度-工艺角仿真**，确保 LDO 在各种工况下都能稳定工作。

- [x] (2025.09.09 ~ 2025.09.10) 1\. 回顾理论知识，给出设计指导
- [x] (2025.09.11 ~ 2025.09.12) 2\. 熟悉 tsmcN65 工艺库，完成 gm/Id 仿真
- [x] (2025.09.13 ~ 2025.09.14) 3\. 完成内部运放的设计与前仿
- [x] (2025.09.14 ~ 2025.09.16) 4\. 不断迭代以提高 LDO 性能
- [x] (2025.09.16 ~ 2025.09.17) 5\. 完成 LDO 的全温度-工艺角前仿
- [x] (2025.09.17 ~ 2025.09.21) 6\. 完成完整 LDO 的版图，提取寄生参数
- [x] (2025.09.21 ~ 2025.09.22) 7\. 完成完整 LDO 的全温度-工艺角后仿
- [x] (2025.09.22 ~ 2025.09.23) 8\. 撰写设计报告


## 3. Design Summary



下表总结了 **v6_171321 (前仿)**、**v7_201154_layout (后仿)** 的全工艺角仿真结果 (ILOLAD = 15 mA, CLOAD = 20 pF)，与张钊老师提供的参考电路 **LDO_3.3_to_1.3_Low_Noise** 的结果作对比 (ILOAD = 10 mA, CLOAD = 10 pF)，红色表示更优：

<span style='font-size:11px'>
<div class='center'>

| Parameter | Pre-Simulation <br> (v6_171321) | Post-Simulation <br> (v7_201154_layout) | Reference |
|:-:|:-:|:-:|:-:|
 | PM |  76.90° ~ 93.26° | <span style='color:red'> 85.86° ~ 98.96° </span> | 80.8° ~ 82.62° |
 | GM | 15.15 dB ~ 17.85 dB | 16.07 dB ~ 23.69 dB | <span style='color:red'> 42.55 dB ~ 46.09 dB </span> |
 | PSRR Peaking | -2.305 dB ~ -4.585 dB <br> (-12.62 dB ~ -20.82 dB @ ILOAD = 10 uA) | -2.934 dB ~ -5.081 dB <br> (-13.27 dB ~ -19.14 dB @ ILOAD = 10 uA) | <span style='color:red'> -23.23 dB ~ -23.88 dB </span> |
 | PSRR @ DC    | <span style='color:red'> -52.24 dB ~ -84.37 dB </span> | -54.16 dB ~ -72.95 dB | -60.79 dB ~ -63.94 dB |
 | PSRR @ 5 MHz | <span style='color:red'> -44.79 dB ~ -55.79 dB </span> | -41.79 dB ~ -47.02 dB | -38.44 dB ~ -40.51 dB |
 | Output Noise @ 1 MHz | <span style='color:red'> 9.993 nV/sqrt(Hz) ~ 14.73 nV/sqrt(Hz) </span> | 10.25 nV/sqrt(Hz) ~ 14.92 nV/sqrt(Hz) | 38.71 nV/sqrt(Hz) ~ 44.48 nV/sqrt(Hz) |
 | Integrated Noise (100 Hz ~ 1 MHz) | <span style='color:red'> 20.35 uVrms ~ 25.03 uVrms </span> | 20.73 uVrms ~ 25.28 uVrms | 50.25 uVrms ~ 68.55 uVrms |
 | Maximum Load Cap | 460 pF @ PM = 45° | 450 pF @ PM = 45° | <span style='color:red'> 5.0 nF @ PM = 45° </span> |
</div></span>

更细致的仿真结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-51-04_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-18-00_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-16-14-53_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-16-13-35_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>


最终交付的原理图和版图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-22-14-26-11_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-22-14-25-19_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

此项目所产生的所有设计成果，包括项目要求、Cadence 原理图/版图/寄生参数网表、自己写的设计文档，以及最终的 Report 和 Slides 均已上传到 123 云盘链接 [https://www.123684.com/s/0y0pTd-FRSj3](https://www.123684.com/s/0y0pTd-FRSj3).






## 4. Material Detail Record

本次设计所创建/用到的 cell view 不少，有多个 test bench 和多个仿真迭代版本，这里统一对它们做一下解释说明，方便后续回顾和复用：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-22-21-04-32_Design of A Basic Low Dropout Regulator (LDO) for BB-PLL.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-21-55-37_Design of A Basic Low Dropout Regulator (LDO) for BB-PLL.png"/></div>


## Relevant Resources

下面是与本文相关的一些资源，在设计过程中不一定有所参考，但也陈列于此，以期对读者有所帮助：

- [知乎 > LDO 结构分析以及进阶——Aze 的 Analog IC Design 随记](https://zhuanlan.zhihu.com/p/46250208)
- [Bilibili > 版图技巧 17: Layout XL 下几种高亮提示的方法](https://www.bilibili.com/video/BV1Nkuzz8EBk)
- [知乎 > LDO 与设计与 Cadence 详细仿真 (1)](https://zhuanlan.zhihu.com/p/1941963651746608768)
- [知乎 > SealRing, PadRing, PowerRing, 去耦电容, dummy 管, 导出 GDS 文件操作教程](https://zhuanlan.zhihu.com/p/1930271122324166107)
- [Bilibili > virtuoso 工具之 EAD 获取寄生参数，快速进行 EMIR 检查分析](https://www.bilibili.com/video/BV1wk9tY4EZG)
- [知乎 > IC617 基础问题指南](https://zhuanlan.zhihu.com/p/695729053)
- [知乎 > Cadence Virtuoso 概念知识--Config](https://zhuanlan.zhihu.com/p/614286236)

## References

本次 LDO 设计与另外两个 OTA/DAC 设计都属于同一个项目，项目主页在这里：

- [**A 2.2-GHz ~ 3.3-GHz BB-PLL with Multiple Output Frequencies in TSMC 65-nm Technology**](<Projects/A 3.3-GHz BB-PLL with Multiple Output Frequencies in TSMC 65-nm Technology.md>)


下面是参考资料：
- [[1] 知乎 > 王小桃带你读文献：低压差线性稳压器 LDO Low Dropout Regulator](https://zhuanlan.zhihu.com/p/19362115112)
- [[2]](https://libyw.ucas.ac.cn/https/63HNga92DoxwAYPr51CYnV8eWBha67Ly8CNtBH8tNL/document/10762683/) X. Liang, X. Kuang, J. Yang, and L. Wang, “A Fast Transient Response Output-capacitorless LDO With Low Quiescent Power,” in 2024 3rd International Conference on Electronics and Information Technology (EIT), Chengdu, China: IEEE, Sep. 2024, pp. 314–317. doi: 10.1109/EIT63098.2024.10762683.
- [[3]](https://ieeexplore.ieee.org/document/7847927) M. M. Elkhatib, “A capacitor-less LDO with improved transient response using neuromorphic spiking technique,” in 2016 28th International Conference on Microelectronics (ICM), Giza, Egypt: IEEE, Dec. 2016, pp. 133–136. doi: 10.1109/ICM.2016.7847927.