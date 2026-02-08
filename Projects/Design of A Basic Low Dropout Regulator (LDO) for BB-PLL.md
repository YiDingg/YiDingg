# Design of A Basic Low Dropout Regulator (LDO) for BB-PLL <br> <span style='font-size:12px'> A Basic Capacitor-Less LDO with High-Stability (450-pF Maximum Load Capacitance) Achieving -46.68-dB @ 5-MHz PSRR and 20.38 uVrms Output Noise in TSMC 65-nm Technology</span>


> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 22:33 on 2025-09-09 in Lincang.
> dingyi233@mails.ucas.ac.cn


## 1. Information

项目基本信息：
- 时间: 2025.09.09 ~ 2025.09.23
- 工艺:  <span style='color:red'>TSMC 65NM COMS </span> Mixed Signal RF SALICIDE Low-K IMD 1P6M-1P9M PDK (CRN65GP)
- 目标：设计一个满足指标要求的 Basic Low Dropout Regulator (LDO), 包括前仿、版图和后仿


项目相关链接：
- [(本文) Design of A Basic Low Dropout Regulator (LDO)](<Projects/Design of A Basic Low Dropout Regulator (LDO) for BB-PLL.md>)
    - (1) 理论与指导：[LDO Stability Analysis and Loop Compensation Mechanism](<AnalogIC/LDO Stability Analysis and Loop Compensation Mechanism.md>)
    - (2) 设计与前仿：
        - [202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (1)](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (1).md>)
        - [202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2)](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).md>)
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

## 5. Experience Summary

本小节总结一些设计过程中积累的经验，供后续参考：
- 像我们这类 10 mA 级别的 LDO 算是电流比较大的了，如果想用 NMOS Pass, 要么有相当不错的 voltage headroom (1.3 V 左右)，要么用 native device 或者 low Vth device
- 按以前的经验，LDO 应该是负载电容越大越稳定，但实际上 "并非如此"；在本次设计中我们发现，系统的相位裕度随负载电容增大会先减小再增大，在小电容 (pF) 或大电容 (uF) 下可以正常工作，对于中等大小电容则会不稳定；之前 "LDO 负载电容越大越稳定" 的经验是对于含有外部电容的 LDO 而言，其工作在右端的大电容区间，而 capacitor-less LDO 则工作在左端的小电容区间
- 对 capacitor-less LDO 而言，NMOS Pass 的稳定性比 PMOS 好得多 (NMOS Pass 下的 GBW_LDO 小得多), PMOS Pass 可以通过降低功率管增益/运放GBW/引入补偿网络来提高稳定性 (牺牲 PSRR 性能)
- 如果仅对 PSRR @ DC 有要求，可以考虑加一个 buffer stage 来驱动功率管，这会大幅降低环路的 GBW, 从而显著提高稳定性 (牺牲中频 PSRR)
- 尽管理论上 NMOS Pass 的 PSRR 会更好，但我们本次设计中却是比 PMOS Pass 差了一点点，也不知是 native device 还是 vgs 的原因
- 本次的 capacitor-less LDO, 在低电流 (轻载) 时稳定性差，在大电流 (重载) 时稳定性会更好；至于 PSRR，前仿和 Gate Level 后仿倒都是轻载差重载好，但 Tran Level 的后仿却是轻载好而重载差
- 提取寄生参数时，无论选择哪种输出格式，提取结果都几乎一致，仅在仿真速度上有略微差异 (SPECTRE 比 HSPICE/DSPF 稍长些)
- 对于一个走线电阻均非常小的优秀版图，如果电路中不存在 mim/mom cap 这类特殊器件，Gate Level 和 Transistor Level 的后仿结果是几乎找不出区别的
- 后仿时用 maestro 似乎不需要再单独设置保存节点数 (我们也没找到在哪设置)，几个项目仿真下来感觉 maestro 会保存电路中与 schematic 对应的一些主节点，可以大幅度节省空间 (但自然没有仅保存顶层节省得多)
- 也不清楚是什么原因，后仿时仿真器总是在 opening psf file 这一步卡很久 (从 output log 中看出)，如果能解决这个问题，仿真速度会大大提高
- 65nm 下的运放，输入共模距离 VDD 有 0 ~ 0.7V 时可以考虑 nmos input, 距离 VSS 有 0 ~ 0.7 V 时可以考虑 pmos input, 对于卡在中间的情况，还是建议用 constant-gm op amp
- 从其它 cell > layout 复制部分版图到新 cell > layout 时，可能出现版图元件 ROD 属性不对应的问题 (被刷新覆盖了)，如果直接点击 Update Components and Nets 会出现 unbounded 报错；这时只需在左下角找到 Define Device Correspondence 更新以下版图元件和原理图的对应关系即可
- NMOS 的 bulk/body 不想连 VSS/GND 的话，一般都要使用 DNW 隔离出 local p-sub, 否则会产生 stamping conflict 报错，也即 "高阻短路" 现象，这是一个比较严重的 ERC 问题，后仿不一定能仿出来，导致流片后结果与后仿差异较大
- 使用 crtmom 时 ERC 检查中出现 floating n-well 报错，可以通过将其版图属性 "Well Type" 从 N 修改为 P 来解决 (使用 PW 而非 NW)
- 模块设计完毕之后，我们通常会在整个模块外围套上多层 guard ring 以提供较好的隔离效果，一般是内 p-ring (VSS) 外 n-ring (VDD), 围上后 LVS > ERC 会报一条 floating p-sub 的错误，这是因为整个电路的 p-sub 未连接到外部，是正常现象，因为我们还没把模块集成到系统中去



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