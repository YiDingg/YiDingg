# Design of An Adjustable Constant-Gm OTA for Low Pass Filters in BB-PLL

**A Constant-Gm OTA with 1.306-uS ~ 22.06-uS Adjustable Range in TSMC 65-nm Technology**

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 22:48 on 2025-09-23 in Beijing.

## 1. Information

项目基本信息：
- 时间: 2025.09.23 ~ 2025.10.02
- 工艺:  <span style='color:red'>TSMC 65NM COMS </span> Mixed Signal RF SALICIDE Low-K IMD 1P6M-1P9M PDK (CRN65GP)
- 目标：设计一个满足指标要求的 Adjustable Constant-Gm OTA, 包括前仿、版图和后仿
- 作者：丁毅 (Yi Ding)

项目相关链接：
- [(本文) Design of An Adjustable Constant-Gm OTA for Low Pass Filters](<Projects/Design of An Adjustable Constant-Gm OTA for Low Pass Filters in BB-PLL.md>)
    - (1) 理论与指导：[Design of Constant-Gm Rail-to-Rail OTA](<AnalogIC/Design of Constant-Gm Rail-to-Rail OTA.md>)
    - (2) 设计与前仿：[202509_tsmcN65_OTA_constantGm_adjustable](<AnalogICDesigns/202509_tsmcN65_OTA_constantGm_adjustable.md>)
    - (3) 版图与后仿：[202509_tsmcN65_OTA_constantGm_adjustable__layout](<AnalogICDesigns/202509_tsmcN65_OTA_constantGm_adjustable__layout.md>)


具体的分析、设计、迭代、版图和后仿等内容都放在了三个附属文档中，本文是对项目的整体介绍和总结。

本次 OTA 设计和上一个项目 [A Basic Low Dropout Regulator (LDO) for BB-PLL](<Projects/Design of A Basic Low Dropout Regulator (LDO) for BB-PLL.md>) 类似，也是最近这个 BB-PLL 中需要的模块。此 OTA 作为一个低通滤波器构成 VCO 两条 tuning path 其中之一，总体方案如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-23-23-06-16_Design of A Constant-Gm Rail-to-Rail OTA for Low Pass Filters.png"/></div>


经过与导师的讨论，我们初步确定了以下设计要求：
- VDD (supply voltage): 1.2 V (external)
- Gm (transconductance): 1 uS ~ 20 uS (adjustable)
- ICMR (input common-mode range): 0.3 V ~ 0.9 V (external digital controlled)
- IBIAS (biasing current): 10 uA (external)
- VOUT (output voltage range): 0.15 V ~ 0.9 V
- CL (load capacitance): 150 pF (100 pF ~ 200 pF)
- GBW (gain-bandwidth product): very low (具体看情况)

由于 ICMR 往下和往上的余量都不到 0.4 V, 常规的 input stage 肯定是行不通的 (无论 NMOS-input 还是 PMOS-input)，再考虑到这个输出电压范围，我们考虑做一个 **constant-gm OTA**.

单级设计时无需考虑稳定性问题，因为单级情况下，负载电容越大，环路的相位裕度越高。我们 150 pF 这么大的负载电容，相位裕度基本能保证在 80° 以上。



## 2. Objective and Schedule

我们将在前仿/后仿阶段进行 **全温度-工艺角仿真** ，确保 OTA 在各种工况下都能稳定工作：
- (2025.09.23 ~ 2025.09.25) 1. 回顾理论知识，给出设计指导
- (2025.09.25 ~ 2025.09.25) 2. 熟悉 tsmcN65 工艺库，完成 gm/Id 仿真
- (2025.09.25 ~ 2025.09.27) 3. 完成 OTA 基本设计，不断迭代以提高 OTA 性能
- (2025.09.27 ~ 2025.09.27) 4. 完成 OTA 的全温度-工艺角前仿
- (2025.09.27 ~ 2025.09.30) 5. 完成 OTA 版图
- (2025.09.30 ~ 2025.09.30) 6. 完成 OTA 的全温度-工艺角后仿
- (2025.09.30 ~ 2025.10.02) 7. 撰写设计报告

## 3. Design Summary

下表总结了 OTA 的全温度-工艺角仿真结果：

<div class='center'>

| Parameter | Pre-Simulation | Post-Simulation |
|:-:|:-:|:-:|
 | **Narrowest Gm Range** | **1.369 uS ~ 18.68 uS** | **1.403 uS ~ 18.76 uS** |
 | **Widest Gm Range**    | **1.093 uS ~ 28.75 uS** | **1.110 uS ~ 28.96 uS** |
 | Gm @ `(0)_10  = (0000)_2`  | 1.290 uS (1.093 uS ~ 1.369 uS) | 1.306 uS (1.110 uS ~ 1.403 uS) |
 | Gm @ `(7)_10  = (0111)_2`  | 13.54 uS (12.26 uS ~ 16.94 uS) | 13.64 uS (12.35 uS ~ 17.14 uS) |
 | Gm @ `(15)_10 = (1111)_2`  | 21.91 uS (18.68 uS ~ 28.75 uS) | 22.06 uS (18.76 uS ~ 28.96 uS) |
 | IDD @ `(0)_10  = (0000)_2` | 118.2 uA (79.67 uA ~ 249.8 uA) | 113.7 uA (77.67 uA ~ 229.2 uA) |
 | IDD @ `(7)_10  = (0111)_2` | 161.4 uA (118.6 uA ~ 297.5 uA) | 156.5 uA (116.4 uA ~ 276.4 uA) |
 | IDD @ `(15)_10 = (1111)_2` | 188.2 uA (140.1 uA ~ 329.5 uA) | 183.1 uA (137.7 uA ~ 308.2 uA) |
</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-20-42-39_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>


原理图和版图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-20-08-22_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-18-18-21_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>


<!-- ## 4. Material Detail Record

本次设计所创建/用到的 cell view 不少，有多个 test bench 和多个仿真迭代版本，这里统一对它们做一下解释说明，方便后续回顾和复用：
 -->


## 4. Experience Summary

本小节总结了本次 OTA 设计中的一些经验，供后续设计参考：
- 无论什么工艺，对绝大多数设计而言，基本上都可使用下面的八个 corners 作为全温度-工艺角，可以覆盖绝大多数温度-工艺变化情况：
    - TT: +27°C, +65°C
    - FF: -40°C, +130°C
    - SS: -40°C, +130°C
    - FS: -40°C
    - SF: +130°C
- 仿真时遇到报错 `Internal error found in spectre during hierarchy flattening, during circuit read-in. Encountered a critical error during simulation.` 可能是因为管子的 finger 设置为了非整数 (例如 2.5)，将 finger 设置为整数即可解决
- 对 constant-Gm OTA, VDD 在不同范围适用不同的补偿方法：
    - no compensation: VDD = 1.7\*VTH ~ 2.3\*VTH
    - current-reuse: VDD >= 2.2\*VTH
    - ...... (待补充)
- 由于电流源的非理想性，OTA 的总跨导 Gm 一般都达不到 (Gm_N + Gm_P), 多数在 40\% ~ 70\% 之间
- **<span style='color:red'> 在版图中导入器件，仅放置器件、修改器件版图属性、放置 VSS/VDD label，还未连线时，我们运行一次 LVS, 正确的报错应该为 layout 中的器件在 schematic 中显示 missing instance 而不是 missing injected instance，如果出现后者，说明 schematic 中的器件有问题，需要重新放置一遍器件再试；反之，schematic 中的器件在 layout 中显示 missing injected instance 是正常的，这不会影响后续的 LVS。 </span>** (这个问题曾困扰我们好几天)
- 模拟电路中，为提高流片稳定性，一般要保证所有的 via/CO 都至少有两个，尤其是 CO, 在管子 L or W 较小时容易只有一个
- 仿真设计好的模块版图时，如果遇到 "模块版图边界比实际边界大得多" 的问题，打开模块 layout 后在 CIW 输入 `(foreach st geGetEditCellView()~>steiners dbDeleteObject(st))` 便可解决

## References

本次 OTA 设计与另外两个 LDO/DAC 设计都属于同一项目，项目主页在这里：

- [**A 2.2-GHz ~ 3.3-GHz BB-PLL with Multiple Output Frequencies in TSMC 65-nm Technology**](<Projects/A 3.3-GHz BB-PLL with Multiple Output Frequencies in TSMC 65-nm Technology.md>)

文章/博客类：
- [{1} 知乎 > 运算放大器跨导恒定轨到轨输入级 (Constant-gm Rail-to-Rail Input Stage)](https://zhuanlan.zhihu.com/p/658369226?): 介绍了多达 17 种 Gm-Variation Reduction Techniques
- [{2} Bilibili > 1224 Class AB 输出的浮动电流源偏置问题](https://www.bilibili.com/opus/704842448804773954): 详细讨论了 constant-gm OPA with Class AB 输出中的浮动电流源偏置问题及其解决方案
- [{3} GihHub > Constant gm rail-to-rail OP-AMP input stage](https://github.com/AhmedHamdyy19/constant-gm-rail-to-rail-opamp-input-stage): 利用 current mirror control 的 singled-ended output 实例 (180nm CMOS)

下面是文献类：
- [1] R. Hogervorst, J. P. Tero, R. G. H. Eschauzier, and J. H. Huijsing, “A compact power-efficient 3 V CMOS rail-to-rail input/output operational amplifier for VLSI cell libraries,” in Proceedings of IEEE International Solid-State Circuits Conference - ISSCC ’94, San Francisco, CA, USA: IEEE, 1994, pp. 244–245. doi: 10.1109/ISSCC.1994.344656.
- [2] G.-D. Dai, P. Huang, L. Yang, and B. Wang, “A Constant Gm CMOS Op-Amp with Rail-to-Rail input/output stage,” in 2010 10th IEEE International Conference on Solid-State and Integrated Circuit Technology, Shanghai, China: IEEE, Nov. 2010, pp. 123–125. doi: 10.1109/ICSICT.2010.5667830.
- [3] Il Kwon Chang, Jang Woo Park, Se Jun Kim, and Kae Dal Kwack, “A global operational amplifier with constant-gm input and output stage,” in Proceedings of IEEE. IEEE Region 10 Conference. TENCON 99. “Multimedia Technology for Asia-Pacific Information Infrastructure” (Cat. No.99CH37030), Cheju Island, South Korea: IEEE, 1999, pp. 1051–1054. doi: 10.1109/TENCON.1999.818603.
- [4] X. Zhao, H. Fang, and J. Xu, “A low power constant-Gm rail-to-rail operational transconductance amplifier by recycling current,” in 2011 IEEE International Conference of Electron Devices and Solid-State Circuits, Tianjin, China: IEEE, Nov. 2011, pp. 1–2. doi: 10.1109/EDSSC.2011.6117572.
- [5] W. Xichuan, D. Huan, and Z. Ting, “A Rail-To-Rail Op-Amp with Constant Gm Using Current Switches,” in High Density Design Packaging and Microsystem Integration, 2007 International Symposium on, IEEE, Jun. 2007, pp. 1–3. doi: 10.1109/HDP.2007.4283626.
- [6] L. L. Malavolta, R. L. Moreno, and T. C. Pimenta, “A self-biased operational amplifier of constant gm for 1.5 V rail-to-rail operation in 130nm CMOS,” in 2016 28th International Conference on Microelectronics (ICM), Giza, Egypt: IEEE, Dec. 2016, pp. 45–48. doi: 10.1109/ICM.2016.7847904.
- [7] J. Wang, L. Huang, and J. Li, “Constant- $g_{m}$ Rail-To-Rail Input/Output Operational Amplifier,” in 2025 IEEE 14th International Conference on Communications, Circuits and Systems (ICCCAS), Wuhan, China: IEEE, May 2025, pp. 87–92. doi: 10.1109/ICCCAS65806.2025.11102681.
- [8] J.-L. Lai, T.-Y. Lin, C.-F. Tai, Y.-T. Lai, and R.-J. Chen, “Design a low-noise operational amplifier with constant-gm”.
- [9] Y. Hao, S. He, and P. Xiao, “Design of a Constant-Gm Rail-to-Rail Operational Amplifier with Chopper Stabilization,” in 2025 5th International Conference on Electronics, Circuits and Information Engineering (ECIE), Guangzhou, China: IEEE, May 2025, pp. 583–587. doi: 10.1109/ECIE65947.2025.11086613.
- [10] Z. Wu, F. Rui, Z. Zhi-Yong, and C. Wei-Dong, “Design of a Rail-to-Rail Constant-gm CMOS Operational Amplifier,” in 2009 WRI World Congress on Computer Science and Information Engineering, Los Angeles, California USA: IEEE, 2009, pp. 198–201. doi: 10.1109/CSIE.2009.173.
- [11] A. C. Veselu, C. Stanescu, and G. Brezeanu, “Low Current Constant-gm Technique for Rail-to-Rail Operational Amplifiers,” in 2020 International Semiconductor Conference (CAS), Sinaia, Romania: IEEE, Oct. 2020, pp. 253–256. doi: 10.1109/CAS50358.2020.9267977.
- [12] N. Baxevanakis, I. Georgakopoulos, and P. P. Sotiriadis, “Rail-to-rail operational amplifier with stabilized frequency response and constant-gm input stage,” in 2017 Panhellenic Conference on Electronics and Telecommunications (PACET), Xanthi, Greece: IEEE, Nov. 2017, pp. 1–4. doi: 10.1109/PACET.2017.8259966.
