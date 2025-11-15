# Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology

**An Ultra-Low-Power CP-PLL for xxx kHz Clock Generation Achieving xxx nW Power Consumption at xxx V Supply in ONC 180nm Technology**

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 23:19 on 2025-10-12 in Beijing.


## 1. Information

项目基本信息：
- 时间: 2025.10.13 ~ 2025.12.25
- 工艺:  <span style='color:red'>ONC 180nm CMOS</span> (ON Semiconductor onc18 process design kit)
- 目标: 设计一个满足指标要求的 Type-III CP-PLL，包括前仿、版图和后仿
- 作者: 丁毅 (Yi Ding)



系统架构：



f_REF = 32.768 kHz, f_out = 5\*32.768 kHz ~ 20\*32.768 kHz (163.84 kHz ~ 655.36 kHz)

项目相关链接：
- [(本文) Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology](<Projects/Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology.md>)
    - (1) 工艺库文档与基本信息：[Basic Information of onc18 (ONC 180nm CMOS Process Library)](<AnalogICDesigns/Basic Information of onc18 (ONC 180nm CMOS Process Library).md>)
    - (2) 理论基础与设计指导：
        - [(old) Prerequisite Digital Electronics Knowledge for PLL](<AnalogIC/Prerequisite Digital Electronics Knowledge for PLL.md>)
        - [(old) Loop Analysis of Third-Order Type-II CP-PLL](<AnalogICDesigns/Design Sheet for Third-Order Type-II CP-PLL.md>)
    - (3) 振荡器选型与环路验证：
        - (3.1) Design of RVCO and Loop Verification: 
            - [202510_onc18_CPPLL_ultra_low_lower (1)](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (1).md>)
            - [202510_onc18_CPPLL_ultra_low_lower (2)](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (2).md>)
    - (4) 设计迭代与前仿结果：
    - (5) 版图设计与后仿结果：



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
- (2025.10.23 ~ 2025.10.xx) 9. 完成 VCO 版图设计与后仿验证
- (2025.10.xx ~ 2025.10.xx) 10. 完成环路剩余模块的设计、优化、版图与后仿
- (2025.10.xx ~ 2025.10.xx) 11. 完成 PLL 的全温度-工艺角前仿
- (2025.10.xx ~ 2025.10.xx) 12. 完成 PLL 版图设计与后仿
- (2025.10.xx ~ 2025.10.xx) 13. 撰写设计报告

## 3. Design Summary
## 4. Experience Summary
## References

