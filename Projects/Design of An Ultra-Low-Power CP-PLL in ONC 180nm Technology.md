# Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology

**An Ultra-Low-Power CP-PLL for xxx kHz Clock Generation Achieving xxx nW Power Consumption at xxx V Supply in ONC 180nm Technology**

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 23:19 on 2025-10-12 in Beijing.


## 1. Information

项目基本信息：
- 时间: 2025.10.13 ~ 2025.12.25
- 工艺:  <span style='color:red'>ONC 180nm CMOS</span> (ON Semiconductor onc18 process design kit)
- 目标: 设计一个满足指标要求的 CP-PLL，包括前仿、版图和后仿
- 作者: 丁毅 (Yi Ding)

系统架构：
- PLL Type: Type-II (Third-Order) Charge-Pump PLL (CP-PLL)
- Reference Frequency (f_REF): 32.768 kHz
- Output Frequency (f_out): 3\*32.768 kHz ~ 24\*32.768 kHz (98.304 kHz ~ 786.432 kHz)
- Power Supply Voltage: 1.25 V
- Target Current Consumption: < 500 nA @ no load, < 550 nA @ 40 fF load (each channel)


<!-- 系统架构：

f_REF = 32.768 kHz, f_out = 5\*32.768 kHz ~ 20\*32.768 kHz (163.84 kHz ~ 655.36 kHz) -->

项目相关链接：
- [(本文) Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology](<Projects/Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology.md>)
    - (1) 工艺库文档与基本信息：
        - [Basic Information of onc18 (ONC 180nm CMOS Process Library)](<AnalogICDesigns/Basic Information of onc18 (ONC 180nm CMOS Process Library).md>)
    - (2) 理论基础与设计指导：
        - [(old) Prerequisite Digital Electronics Knowledge for PLL](<AnalogIC/Prerequisite Digital Electronics Knowledge for PLL.md>)
        - [Loop Analysis of Typical Type-II CP-PLL](<AnalogIC/Loop Analysis of Typical Type-II CP-PLL.md>)
        - [Large Resistor Implementation Techniques for Low-Power Analog IC Designs](<AnalogIC/Large Resistor Implementation Techniques for Low-Power Analog IC Designs.md>)
        - [The Differences Between Latch and Flipflop (D Latch vs. D Flipflop)](<AnalogIC/From Basic Logic Gates to D Latch and D Flipflop.md>)
    - (3) VCO 设计/选型/迭代与环路验证：
        - [202510_onc18_CPPLL (1) VCO Design Iteration](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (1) VCO Design Iteration.md>)
        - [202510_onc18_CPPLL (2) VCO Iteration and Layout](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.md>)
    - (4) 设计迭代与前仿结果：
    - (5) 版图设计与后仿结果：
        - [202510_onc18_CPPLL (3) Design of Other Modules](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (3) Design of Other Modules.md>)
        - [202510_onc18_CPPLL (4) Pre-Layout Simulation and Layout Details](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (4) Pre-Layout Simulation and Layout Details.md>)
    - 其它：
        - [Virtuoso Tutorials - 15. Several Methods for PEX and How to Speed Up Your Post-Simulation](<AnalogIC/Virtuoso Tutorials - 15. Several Methods for PEX and How to Speed Up Your Post-Simulation.md>)
        - [Virtuoso Tutorials - 16. Using Config Sweep and CALIBREVIEW to Speed Up Your Post-Layout Simulation](<AnalogIC/Virtuoso Tutorials - 16. Using Config Sweep and CALIBREVIEW to Speed Up Your Post-Layout Simulation.md>)
        - [Virtuoso Tutorials - 17. Creating Parameter Passing Symbol as The Standard PCell](<AnalogIC/Virtuoso Tutorials - 17. Creating Parameter Passing Symbol as The Standard PCell.md>)
        - [Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation](<AnalogIC/Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.md>)
        - [All You Need to Know About Fourier Analysis (FS, DFS, FT, DTFT, DFT)](<AnalogIC/All You Need to Know About Fourier Analysis (FS, DFS, FT, DTFT, DFT).md>)

**注：本次项目的所有相关资料/原理图/版图已经上传到 123 云盘链接 <span style='color:red'> (待上传) </span>, 点击即可下载。**

## 2. Objective and Schedule

- (2025.10.13 ~ 2025.10.13) 1. 回顾理论知识，给出设计指导
- (2025.10.14 ~ 2025.10.15) 2. 熟悉 ocn18 工艺库，提取关键信息
- (2025.10.14 ~ 2025.10.16) 3. 考虑不同 PLL 架构，探索 VCO 性能参数，给出全系统设计指导
- (2025.10.15 ~ 2025.10.16) 4. VCO 初步设计与迭代，为架构打下基础 (VCO 好自然就能用更简单的架构)
- (2025.10.15 ~ 2025.10.16) 5. 完成环路 Verilog 建模与行为级仿真测试，初步确定环路参数
- (2025.10.15 ~ 2025.10.16) 6. 将实际 VCO 模型代入环路，初步验证 VCO 和环路性能
- (2025.10.16 ~ 2025.10.21) 7. 对几种可用 VCO 架构进行迭代，对比最优性能，选出最终架构
- (2025.10.21 ~ 2025.10.22) 8. 严谨推导 Type-II CP-PLL 理论环路公式，进一步优化环路参数
- (2025.10.23 ~ 2025.10.25) 9. 完成 VCO 版图设计与后仿验证
- (2025.10.25 ~ 2025.11.06) 10. 完成环路剩余模块的设计、优化与环路仿真验证
- (2025.11.06 ~ 2025.11.10) 11. 完成 PLL 的全温度/工艺角前仿，从三种方案中选出最终方案 (最终选了 Option 2, 也即 RVCO2 @ X24 with FB retiming)
- (2025.11.11 ~ 2025.11.16) xx. 受 "非线性电路" 期中考试影响，此时间段基本无进度
- (2025.11.17 ~ 2025.11.25) 12. 完成 PLL 大部分模块的版图设计与环路后仿验证 (完成了 PFD/CP/VCO/FD, 还差 LPF/BUF)
- (2025.11.26 ~ 2025.12.02) xx. 受 "数字逻辑电路" 期中考试影响，此时间段基本无进度 
- (2025.12.03 ~ 2025.12.xx) 13. 完成 PLL 剩余模块的版图设计与环路后仿验证
- (2025.12.xx ~ 2025.12.xx) 14. 完成 PLL 的全温度/工艺角后仿，全面确认最终性能指标
- (2025.12.xx ~ 2025.12.25) 15. 撰写项目总结报告与相关文档



## 3. Design Summary
## 4. Experience Summary
## References

