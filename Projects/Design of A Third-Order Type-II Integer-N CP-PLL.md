# Design of A Third-Order Type-II Integer-64 CP-PLL with 0.5 GHz ~ 3.0 GHz Locking Range Achieving 2.800 ps RMS Jitter and -234.3 dB FoM in 28nm CMOS Technology

> [!Note|style:callout|label:Infor]
Initially published at 18:03 on 2025-08-13 in Lincang.


## Infor and Summary

- 时间: 2025.08.10 - 2025.08.25
- 工艺: TSMC 28nm CMOS (台积电 28nm CMOS 工艺)
- 目标：设计一个 Third-Order Type-II Integer-N CP-PLL **(仅包括前仿)**


项目相关链接：
- [(本文) Design of A Third-Order Type-II Integer-N CP-PLL](<Projects/Design of A Third-Order Type-II Integer-N CP-PLL.md>)
    - (1) 理论准备：[Design Sheet for Third-Order Type-II CP-PLL](<AnalogICDesigns/Design Sheet for Third-Order Type-II CP-PLL.md>)
    - (2) 行为仿真：[PLL Behavior-Level Simulation using Cadence IC618](<AnalogIC/PLL Behavior-Level Simulation using Cadence IC618.md>)
    - (3) 设计记录：[202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N](<AnalogICDesigns/202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.md>)



此项目最终的 Report 和 Slides 已经上传到链接 [(2025.08) Type-II Third-Order Integer-64 CP-PLL (https://www.123684.com/s/0y0pTd-3XSj3)](https://www.123684.com/s/0y0pTd-3XSj3)，原始数据在链接 [202508_CPPLL_rawData.zip (https://www.writebug.com/static/uploads/2025/8/22/4437bf0044ac47139b9e685831ff203b.zip)](https://www.writebug.com/static/uploads/2025/8/22/4437bf0044ac47139b9e685831ff203b.zip)。

主要仿真结果总结如下：

<div class='center'><span style='font-size: 14px'> 

| Parameter | Process | Locking Range | Locking Time | RMS Jitter | Power Consumption | FoM_J | FoM_JN |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| **Value** | 28nm CMOS | 0.5 GHz ~ 3.0 GHz | 779.6 ns | 2.800 ps | 472.9 uA @ 1 V | -234.3 dB | -252.4 dB |

</span>
</div>



## 1. Objective and Schedule


本次设计目标和条件的基本参考 SJSU (美国圣何塞州立大学) [EE230 RFIC II](https://www.sjsu.edu/people/sang-soo.lee/courses/EE230/index.html) 课程中的 group project (相当于我们这边的期末小组大作业), EE230 课程的 project descriptions 见链接 [EE230_PLL_project_description_2018.pdf](https://www.writebug.com/static/uploads/2025/8/13/933f511c983c1dca54d563e65c7fb9ac.pdf).


理论准备 (按学习顺序)：
- [Prerequisite Digital Electronics Knowledge for PLL](<AnalogIC/Prerequisite Digital Electronics Knowledge for PLL.md>)
- [Razavi CMOS - Chapter 13. Switched-Capacitor Circuits](<AnalogIC/Razavi CMOS - Chapter 13. Switched-Capacitor Circuits.md>)
- [Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL](<AnalogIC/Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.md>)
- [Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 CP-PLL ~ 16.5 Applications](<AnalogIC/Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 CP-PLL ~ 16.5 Applications.md>)
- [Paper Reading - [F. Gardner] Charge-Pump Phase-Lock Loops](<Papers/Phase-Locked Loop/[F. Gardner] Charge-Pump Phase-Lock Loops.md>)
- [Design Sheet for Third-Order Type-II CP-PLL](<AnalogICDesigns/Design Sheet for Third-Order Type-II CP-PLL.md>)
- [Razavi PLL - Chapter 15. Frequency Dividers](<AnalogIC/Razavi PLL - Chapter 15. Frequency Dividers.md>)
- [Jitter and Phase Noise in Mixed-Signal Circuits](<AnalogIC/Jitter and Phase Noise in Mixed-Signal Circuits.md>)



<!-- - [Implementation Collection of Typical PLL Modules (PFD, CP, LPF, VCO, FD)](<AnalogIC/Implementation Collection of Typical PLL Modules (PFD, CP, LPF, VCO, FD).md>) -->




时间安排：
- [x] (2025.08.10 ~ 2025.08.15) 1\. 理论准备：包括理论学习、论文阅读、 design sheet 等，相关链接详见上面 "理论准备"
- [x] (2025.08.15 ~ 2025.08.16) 2\. 理论验证：对 PLL 进行 behavior-level simulation 以验证理论正确性
    - LTspice: [PLL System-Level Simulation using LTspice](<AnalogIC/PLL System-Level Simulation using LTspice.md>) 
    - Cadence: [PLL Behavior-Level Simulation using Cadence IC618](<AnalogIC/PLL Behavior-Level Simulation using Cadence IC618.md>)
- [x] (2025.08.17 ~ 2025.08.18) 3\. 模块设计：确定各模块的具体结构、完成模块设计与仿真
- [x] (2025.08.19 ~ 2025.08.21) 4\. 仿真迭代：对整个 PLL 系统进行仿真迭代
- [x] (2025.08.21 ~ 2025.08.23) 5\. 系统前仿：对整个 PLL 系统进行前仿测试
- [x] (2025.08.23 ~ 2025.08.25) 6\. 报告总结：对仿真结果进行总结，撰写报告和 slides

完成此项目后，将设计与仿真记录导出并汇总为 report, 然后写一个 PPT 用来展示电路结构和关键成果。

## 2. Design Considerations

### 2.1 CP-PLL structure

本次的 CP-PLL 采用 PFD + CP + LPF + VCO + Integer-N Divider 架构。然而，对现阶段 (刚接触 PLL) 的我们而言，在每一种模块众多实现方式中挑挑选选是不现实的 (time-consuming and back-breaking)，因此我们选择直接复现 [Paper [1]](https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system) 中的成果，也就是和 [1] 使用几乎相同的模块结构。

### 2.2 design constraints

我们的 design constraints 如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-13-21-44-27_Design of A Type-II Integer-N Charge Pump PLL.png"/></div>



经过行为级仿真 [PLL Behavior-Level Simulation using Cadence IC618](<AnalogIC/PLL Behavior-Level Simulation using Cadence IC618.md>) 验证后，我们对上述要求做一些修改：

<div class='center'>

| Parameter | Value |
|:-:|:-:|
 | VDD | 0.9 V ~ 1.1 V (nominal 1.0 V) |
 | Integer-N | 64 |
 | Reference Clock | 20 MHz ~ 30 MHz <br> (1.28 GHz ~ 1.92 GHz) |
 | Tuning Range | 1.0 GHz ~ 2.0 GHz  |
 | Corner | TT, SS, FF |
 | Temperature | -40 °C ~ 125 °C |
 | <span style='color:red'> FoM </span> | <span style='color:red'> < -220 dB </span> |
</div>


锁相环的 FoM 公式参考 [Paper [3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9847207):

$$
\begin{gather}
\mathrm{FoM}_{J} = 10 \log_{10} \left[ \left(\frac{\sigma_{jitter, rms}}{1 \ \mathrm{s}}\right)^2\cdot \left(\frac{\mathrm{power}}{1 \ \mathrm{mW}}\right) \right]
= \mathrm{\sigma_{jitter, rms}}_{\mathrm{dB}} + \mathrm{power}_{\mathrm{dBm}}
\\
\mathrm{FoM}_{JAN} = 10 \log_{10} \left[
    \left(\frac{\sigma_{jitter, rms}}{1 \ \mathrm{s}}\right)^2
    \cdot 
    \left(\frac{\mathrm{power}}{1 \ \mathrm{mW}}\right) 
    \cdot 
    \left( \frac{\mathrm{area}}{1 \ \mathrm{mm^2}} \right)
    \cdot 
    \left( \frac{1}{N} \right)
    \right]
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-13-04-59_Design of A Third-Order Type-II Integer-N CP-PLL.png"/></div>


另外，这个 PLL 设计里也会用到 opamp 和 bias current，运放的话我们可以把科研实践一 [Scientific Research Practice 1 (Low-Voltage BGR)](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>) 中的直接搬过来用，但是 BGR 就不打算拿过来了，因为 PLL 需要在 VDD = 0.9V ~ 1.1V 正常工作，而 BGR 最低也要 0.984 V.


## 3. Behavior-Level Simul.

详见文章 [PLL System-Level Simulation using LTspice](<AnalogIC/PLL System-Level Simulation using LTspice.md>) 和 [PLL Behavior-Level Simulation using Cadence IC618](<AnalogIC/PLL Behavior-Level Simulation using Cadence IC618.md>), 这里不多赘述，直接给出结果：

N = 64, RP = 6.5 kOhm, CP = 20 pF, C2 = 2 pF:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-02-31-03_PLL Behavior-Level Simulation using Cadence IC618.png"/></div>

N = 64, RP = 6.5 kOhm, CP = 100 pF, C2 = 10 pF:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-02-23-10_PLL Behavior-Level Simulation using Cadence IC618.png"/></div>

## 4. Design of Modules

每个模块的具体设计过程和仿真结果见 [202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N](<AnalogICDesigns/202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.md>)，这里直接列出最终成果。

### 4.1 PFD and CP

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-23-02-44-04_Design of A Third-Order Type-II Integer-N CP-PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-23-02-46-25_Design of A Third-Order Type-II Integer-N CP-PLL.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-03-22-28_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-03-27-25_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>

### 4.3 LPF

$$
\begin{gather}
R_P = 1 \ \mathrm{k}\Omega,\ C_P = 50 \ \mathrm{pF},\ C_2 = 2.5 \ \mathrm{pF}
\end{gather}
$$

### 4.4 VCO

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-23-02-49-18_Design of A Third-Order Type-II Integer-N CP-PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-00-27-57_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>

### 4.5 FD

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-23-02-54-00_Design of A Third-Order Type-II Integer-N CP-PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-20-01-22-53_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


## 5. Pre-Layout Simulation

详细的前仿结果还是见文章 [202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N](<AnalogICDesigns/202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.md>), 这里直接给出原理图和仿真结果总结：

<div class='center'><span style='font-size: 14px'> 

| Parameter | Process | Locking Range | Locking Time | RMS Jitter | Power Consumption | FoM_J | FoM_JN |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| **Value** | 28nm CMOS | 0.5 GHz ~ 3.0 GHz | 779.6 ns | 2.800 ps | 472.9 uA @ 1 V | -234.3 dB | -252.4 dB |

</span>
</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-17-40-37_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-01-55-51_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-02-00-35_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>



本次设计的原始数据已上传到链接 [202508_CPPLL_rawData.zip (https://www.writebug.com/static/uploads/2025/8/22/4437bf0044ac47139b9e685831ff203b.zip)](https://www.writebug.com/static/uploads/2025/8/22/4437bf0044ac47139b9e685831ff203b.zip)

## 6. Report and Slides

此项目最终的 Report 和 Slides 已经上传到 123 云盘链接 [(2025.08) Type-II Third-Order Integer-64 CP-PLL (https://www.123684.com/s/0y0pTd-3XSj3)](https://www.123684.com/s/0y0pTd-3XSj3) 



<!-- ## 7. Project Retrospective
 -->
<!-- 困难：$R_P \times C_2$ 过大导致锁定后的振荡。 -->
<!-- 
本次项目的设计与实现过程充分考虑了各个模块的协同工作，最终成功实现了一个性能优越的三阶二型整数N相位锁定环。通过对各个模块的深入分析与优化，我们在锁定范围、锁定时间、相位噪声等关键指标上都达到了预期目标。不仅如此，我们还在功耗和面积等方面进行了有效的控制，使得整个系统更加高效和紧凑。另外，项目过程中也遇到了一些挑战，例如在某些模块的设计中需要进行多次迭代才能达到理想的性能指标，但最终都得以克服。但也积累了最宝贵的经验，为今后的设计提供了有益的参考。 -->



## Relevant Resources

下面是与本文主题相关的一些资源，在设计过程中不一定有所参考，但也陈列于此，以期对读者有所帮助：

- [TI Books > PLL Performance, Simulation, and Design (5th Edition)](https://www.ti.com/lit/ml/snaa106c/snaa106c.pdf)
- [TI Technical Brief > Fractional/Integer-N PLL Basics](https://www.ti.com/lit/an/swra029/swra029.pdf?ts=1755068131703)
- [Altair PSIM Tutorial > Implementation and Design of PLL and Enhanced PLL Blocks](https://2023.help.altair.com/psim-tut/tutorials/Tutorial%20-%20Implementation%20and%20Design%20of%20PLL%20and%20Enhanced%20PLL%20Blocks.pdf)
- [Tsinghua University > Pll Design And Clock/Frequency Generation](https://picture.iczhiku.com/resource/eetop/SykGEWFJKYGgRcXX.pdf)
- [TI > PLL Phase Noise Figures of Merit](https://www.ti.com/content/dam/videos/external-videos/en-us/5/3816841626001/6145905652001.mp4/subassets/clocks-and-timing-phase-locked-loop-phase-noise-figures-of-merit-presentation-quiz.pdf)
- [Fitz's Blog > TSPC](https://zhouyuqian.com/2020/11/17/TSPC/)
- [Fitz's Blog > PLL Charge Pump](https://zhouyuqian.com/2020/11/20/PLL-CP/)
- [Fitz's Blog > VCO 参数选取及仿真](https://zhouyuqian.com/2021/05/08/vco-param/)
- [Cadence_PLL_Jitter_measurment_in_Spectre.pdf](https://www.writebug.com/static/uploads/2025/8/22/705f40616dd3afd7796ddfbe1d5b66d8.pdf)
- [Jitter measurement using SpectreRF Application Note.pdf](https://www.writebug.com/static/uploads/2025/8/22/28c1f61cd30eb054e8a9d5c6824f4d7e.pdf)
- [SpectreRF Periodic Analysis.pdf](https://www.eecis.udel.edu/~vsaxena/courses/ece614/Handouts/SpectreRF%20Periodic%20Analysis.pdf)
- [ELEN 6901 > PLL Phase Noise/Jitter Modeling and Simulation.pdf](https://www.columbia.edu/~ktj2102/PLLnoise_simulation.pdf)
- [Cadence Community > RF Design > [help] pll simulation in spectre](https://community.cadence.com/cadence_technology_forums/f/rf-design/29861/help-pll-simulation-in-spectre)
- [Cadence Community > RF Design > PSS & PNOISE simulation for VCO and PLL](https://community.cadence.com/cadence_technology_forums/f/rf-design/49390/pss-pnoise-simulation-for-vco-and-pll)
- [Bilibili > 【LC VCO实例仿真 \pss \pnoise\ hb】](https://www.bilibili.com/video/BV1Gw41197m2)
- [知乎 > Cadence pss 仿真](https://zhuanlan.zhihu.com/p/16816066025)
- [知乎 > 五分频电路（占空比50%）的原理以及在Cadence中模拟电路的实现](https://zhuanlan.zhihu.com/p/23660012763)
- [知乎 > 锁相环PLL学习记录2-压控振荡器VCO搭建和仿真](https://zhuanlan.zhihu.com/p/691772078)
- [知乎 > PLL 硕士论文——24GHz毫米波锁相环](https://zhuanlan.zhihu.com/p/1938715765181219397)
- [知乎 > Chapter 21 Sub-sampling PLL techniques](https://zhuanlan.zhihu.com/p/680376514)
- [知乎 > Virtuoso AMS仿真实例（320MHz PLL设计与仿真）](https://zhuanlan.zhihu.com/p/683253827)




## References

- [[1]](https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system) M. Aldacher, “muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system.” Accessed: Jun. 30, 2025. [Online]. Available: https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system
- [[2]](https://u.dianyuan.com/bbs/u/29/1116306785.pdf) F. Gardner, “Charge-Pump Phase-Lock Loops,” IEEE Transactions on Communications, vol. 28, no. 11, pp. 1849–1858, Nov. 1980, doi: 10.1109/TCOM.1980.1094619.
- [[3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9847207) W. Bae, “Benchmark Figure of Merit Extensions for Low Jitter Phase Locked Loops Inspired by New PLL Architectures,” IEEE Access, vol. 10, pp. 80680–80694, 2022, doi: 10.1109/ACCESS.2022.3195687.
- [[4]](https://www.zhihu.com/question/452068235/answer/95164892409) B. Razavi, Design of Analog CMOS Integrated Circuits, Second edition. New York, NY: McGraw-Hill Education, 2017.
- [[5]](https://www.zhihu.com/question/23142886/answer/108257466853) B. Razavi, Design of CMOS Phase-Locked Loops. New York, NY: Cambridge University Press, 2020.
- [[6]](https://www.ideals.illinois.edu/items/49560) R. Ratan, Design of a Phase-Locked Loop Based Clocking Circuit for High Speed Serial Link Applications. [Online]. Available: https://www.ideals.illinois.edu/items/49560
- [[7]](https://snehilverma41.github.io/PLL_Report.pdf) Phase-Locked Loop (Design and Implementation). Accessed: Jun. 30, 2025. [Online]. Available: https://snehilverma41.github.io/PLL_Report.pdf
- [[8]](https://www.ideals.illinois.edu/items/50583) D. Wei, Clock Synthesizer Design With Analog and Digital Phas-Locked Loop. [Online]. Available: https://www.ideals.illinois.edu/items/50583
- [[9]](https://seas.ucla.edu/brweb/papers/Journals/BRFall16TSPC.pdf) B. Razavi, “TSPC Logic [A Circuit for All Seasons],” IEEE Solid-State Circuits Mag., vol. 8, no. 4, pp. 10–13, 2016, doi: 10.1109/MSSC.2016.2603228.
- [[10]](https://ieeexplore.ieee.org/document/7754138) H. Ashwini, S. Rohith, and K. A. Sunitha, “Implementation of high speed and low power 5T-TSPC D flip-flop and its application,” in 2016 International Conference on Communication and Signal Processing (ICCSP), Melmaruvathur, Tamilnadu, India: IEEE, Apr. 2016, pp. 0275–0279. doi: 10.1109/ICCSP.2016.7754138.
- [11] H.-T. Ahn and S.-S. Lee, “A 216µW 281MHz-1.126GHz Self-Calibrated SSCG PLL with 0.6V Supply Voltage in 55nm DDC™ CMOS Process”, doi: 10.1587/elex.18.20200441.
- [14] J. Yuan and C. Svensson, “High speed CMOS circuit technique,” IEEE Journal of Solid-State Circuits, vol. 24, no. 1, pp. 62–70, 1989, doi: 10.1109/4.16303.
- [15] “Jitter measurement using SpectreRF Application Note.” [Online]. Available: https://www.writebug.com/static/uploads/2025/8/22/28c1f61cd30eb054e8a9d5c6824f4d7e.pdf
- [16] “PLL_Jitter_measurment_in_Spectre.” [Online]. Available: https://www.writebug.com/static/uploads/2025/8/22/705f40616dd3afd7796ddfbe1d5b66d8.pdf
- [17] Snehil Verma, “Phase-Locked Loop (Design and Implementation)”, Accessed: Jun. 30, 2025. [Online]. Available: https://snehilverma41.github.io/PLL_Report.pdf



以及 EE230 的 project description [EE230_PLL_project_description_2018.pdf](https://www.writebug.com/static/uploads/2025/8/13/933f511c983c1dca54d563e65c7fb9ac.pdf).

