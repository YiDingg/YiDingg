# Scientific Research Practice 1 (Design of A Low-Voltage Bandgap Reference)

> [!Note|style:callout|label:Infor]
Initially published at 18:48 on 2025-07-14 in Beijing.



## 1. Information

- 时间: 2025.07.14 - 2025.08.08
- 地点: 中国科学院半导体研究所 (Institute of Semiconductors, Chinese Academy of Sciences)
- 工艺: TSMC 28nm CMOS (台积电 28nm CMOS 工艺)
- 目标：设计一个低压带隙参考电压源 (Low-Voltage Bandgap Reference, BGR), 包括前仿、版图设计、版图验证和后仿。

本次科研实践相关链接：
- [(本文) Scientific Research Practice 1 (Low-Voltage BGR)](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>)
    - [Design of the Op Amp for Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller.md>)
    - [Layout and Post-Layout Simulation of the Op Amp for Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller__layout.md>)
    - [Design of the Low-Voltage Bandgap Reference (BGR)](<AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1.md>)
    - [Layout and Post-Layout Simulation of the Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1__layout.md>)

## 2. General Considerations

### 2.1 objective and schedule

本次科研实践的主要目标是完整地设计一个带隙参考电压源 (bandgap reference, BGR), 完成前仿、版图和后仿工作。初步计划如下:

- [x] (2025.07.14 ~ 2025.07.17) 1\. 学习理论知识，确定 BGR 架构
- [x] (2025.07.18 ~ 2025.07.22) 2\. 设计用于 BGR 的运算放大器，包括运放的版图、验证和后仿
- [x] (2025.07.23 ~ 2025.07.24) 3\. 完成整个 BGR 的设计并进行前仿 
- [x] (2025.07.25 ~ 2025.07.27) 4\. 进行 BGR 版图设计和验证
- [x] (2025.07.27 ~ 2025.07.29) 5\. 完成 BGR 的完整后仿
- [x] (2025.08.05 ~ 2025.08.07) 7\. 撰写科研实践报告
- [x] (2025.08.07 ~ 2025.08.08) 8\. 准备答辩 slides

### 2.2 report and paper

最终的报告需写得详细一些，将此项目完成过程中产生的几篇博客都涵盖进去。如果考虑据此写一篇论文，可以参考 [Paper [2]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7049929) 的格式。

下面是一些可以借鉴的报告/论文内容：
- 加入不同文献中 BGR 的设计对比. [Example: Paper [9]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7527288)
- 仿真 Vref vs. VDD for different parameter corners and temperatures. [Example: Paper [1]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=4641493)



## 3. Design Summary

本小节展示了此次设计的 BGR 结构与主要成果 (关键性能指标)，图片摘自项目总览的 PPT [科研实践一-成果总览 (丁毅, 2025.08.03).pptx](https://www.writebug.com/static/uploads/2025/8/5/6903e0d4c0922bfeb167773ddf1498a3.pptx).


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-38-04_Scientific Research Practice 1 (Low-Voltage BGR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-38-20_Scientific Research Practice 1 (Low-Voltage BGR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-38-32_Scientific Research Practice 1 (Low-Voltage BGR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-38-45_Scientific Research Practice 1 (Low-Voltage BGR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-38-52_Scientific Research Practice 1 (Low-Voltage BGR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-39-12_Scientific Research Practice 1 (Low-Voltage BGR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-39-24_Scientific Research Practice 1 (Low-Voltage BGR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-39-37_Scientific Research Practice 1 (Low-Voltage BGR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-39-52_Scientific Research Practice 1 (Low-Voltage BGR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-40-03_Scientific Research Practice 1 (Low-Voltage BGR).png"/></div>




## References

- [1] T. V. Cao, D. T. Wisland, T. S. Lande, F. Moradi, and Y. H. Kim, “Novel start-up circuit with enhanced power-up characteristic for bandgap references,” in 2008 IEEE International SOC Conference, Sep. 2008, pp. 123–126. doi: 10.1109/SOCC.2008.4641493. [(this link)](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=4641493)
- [2] H. Shrimali and V. Liberali, “The start-up circuit for a low voltage bandgap reference,” in 2014 21st IEEE International Conference on Electronics, Circuits and Systems (ICECS), Dec. 2014, pp. 92–95. doi: 10.1109/ICECS.2014.7049929. [(this link)](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7049929)
- [3] H. Banba et al., “A CMOS bandgap reference circuit with sub-1-V operation,” IEEE Journal of Solid-State Circuits, vol. 34, no. 5, pp. 670–674, May 1999, doi: 10.1109/4.760378.
- [4] C. J. B. Fayomi, G. I. Wirth, H. F. Achigui, and A. Matsuzawa, “Sub 1 V CMOS bandgap reference design techniques: a survey,” Analog Integr Circ Sig Process, vol. 62, no. 2, pp. 141–157, Feb. 2010, doi: 10.1007/s10470-009-9352-4. [(this link)](http://ieeexplore.ieee.org/document/4734888/) 
- [5] N. Gupta and P. Pirya, “Design and Implementation of Bandgap Reference Circuits,” vol. 5, no. 2, 2017.
- [6] Dong-Ok Han, Jeong-Hoon Kim, and Nam-Heung Kim, “Design of bandgap reference and current reference generator with low supply voltage,” in 2008 9th International Conference on Solid-State and Integrated-Circuit Technology, Beijing, China: IEEE, Oct. 2008, pp. 1733–1736. doi: 10.1109/icsict.2008.4734888. [(this link)](https://doi.org/10.1007/s10470-009-9352-4) 
- [7] B. Razavi, “The Design of a Low-Voltage Bandgap Reference [The Analog Mind],” IEEE Solid-State Circuits Mag., vol. 13, no. 3, pp. 6–16, 2021, doi: 10.1109/mssc.2021.3088963. [(this link)](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9523469)
- [8] B. Razavi, Design of analog CMOS integrated circuits, Second edition. New York, NY: McGraw-Hill Education, 2017.
- [9] A. I. Kamel, A. Saad, and L. S. Siong, “A high wide band PSRR and fast start-up current mode bandgap reference in 130nm CMOS technology,” in 2016 IEEE International Symposium on Circuits and Systems (ISCAS), May 2016, pp. 506–509. doi: 10.1109/ISCAS.2016.7527288.



再次给出本次科研实践相关链接：
- [(本文) Scientific Research Practice 1 (Low-Voltage BGR)](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>)
    - [Design of the Low-Voltage Bandgap Reference (BGR)](<AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1.md>)
        - [Design of the Op Amp for Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller.md>)
        - [Layout and Post-Layout Simulation of the Op Amp for Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller__layout.md>)
    - [Layout and Post-Layout Simulation of the Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1__layout.md>)
