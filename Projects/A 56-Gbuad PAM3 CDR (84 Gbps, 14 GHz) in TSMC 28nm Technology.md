# A 56-Gbuad Quarter-Rate PAM3 CDR (84 Gbps, 14 GHz) in TSMC 28nm Technology

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 01:40 on 2026-01-22 in Lincang.
> dingyi233@mails.ucas.ac.cn

## 1. Project Information

项目基本信息：
- 时间: 2025.02.01 ~ 2026.05.xx
- 工艺:  <span style='color:red'>TSMC 28nm CMOS</span> process design kit `tsmcN28`
- 目标: 设计一个满足指标要求的 Quarter-Rate PAM3 CDR 电路，包括前仿、版图和后仿，要流片测试最后发论文
- 作者: 
    - PAM3 CDR: 丁毅 (Yi Ding)
    - TX & RX Other Parts: 梁智诚师兄、王静扬师兄


系统架构：
- Output Channel: xx channels
- Output Signaling: PAM3
- Data Rate: 56 Gbaud/s (84 Gbps)
- Clock Rate: 14 GHz Ring-VCO (Quarter-Rate)
- Power Supply Voltage:
- Power Consumption:
- Jitter Performance:
    - rms (data) jitter of recovered clock < xx fs
    - rms (edge) jitter of retimed data < xx fs
- BER Specification: < 1E-12 at stressed conditions
- Technology: TSMC 28nm CMOS 


## 2. Objective and Schedule

- (2026.01.20 ~ 2026.01.28) 1. 依次学习 CDR/SerDes/PAM3 理论知识，建立理论基础
- (2026.01.28 ~ 2026.01.30) 2. 阅读 PAM3 CDR/SerDes 相关论文，了解前沿技术
- (2026.02.00 ~ 2026.02.02) 3. 基于之前已有的理想 VCO (verilog-a)，创建具有相位噪声/抖动的 VCO，包括 VCO with white edge jitter 以及 VCO with white cycle jitter 两种模型 (后者更接近实际器件)，并进行仿真验证；
- (2026.02.02 ~ 2026.02.03) 4. 更深入地学习 verilog-a，以及学习 Bus Wires 的使用方法
- (2026.02.03 ~ 2026.02.03) 5. 创建可直接通过宏定义修改 bit 宽度的理想 ADC/DAC 模块，并进行仿真验证；
- (2026.02.03 ~ 2026.02.05) 6. 用 verilog-a 搭建一系列 basic logic gates/modules, 包括 BUF, INV, AND, NAND, OR, NOR, XOR, XNOR, TG (transmission gate), MUX2, SRL (Gated SR-Latch), DL (Gated D-Latch), DFF (D-FlipFlop) 等，并进行仿真验证；分成两套，第一套是通过 parameter 来指定 vin_th 和 vout_high/vout_low，第二套则是引出 VSS/VDD 端口且默认 vth = (VDD + VSS)/2；
- (2026.02.06 ~ 2026.02.07) 7. <s> 用 verilog-a 搭建 CML (current mode logic) gates/modules, 包括 BUF, INV, AND, NAND, OR, NOR, XOR, XNOR, MUX2, SRL (Gated SR-Latch), DL (Gated D-Latch), DFF (D-FlipFlop) 等，并进行仿真验证；</s>
- (2026.02.06 ~ 2026.02.06) 8. 用 verilog-a 搭建 PLL 行为级模型，要求可以设置分频比 N 和环路参数；
- (2026.02.06 ~ 2026.02.07) 9. 用 verilog-a 搭建 PRBS (Pseudo-random binary sequence) 和 RRBS (real-random binary sequence) Generator 模块，并进行仿真验证；
- (2026.02.xx ~ 2026.02.xx) 11. 用 verilog-a 搭建 Alexander Phase Detector 模块 (Full Rate 和 Half Rate)，并进行仿真验证；
- (2026.02.xx ~ 2026.02.xx) 12. 用 verilog-a 搭建 NRZ CDR (Alexander-PD + CP + LPF + VCO) 行为级模型，并进行仿真验证；
- (2026.02.06 ~ 2026.02.06) 10. 用 verilog-a 搭建 8b/10b Encoder 和 Decoder 模块，用于后续的 NRZ 数据编码 (限制 max run length)；
- (2026.02.xx ~ 2026.03.xx) 13. 用 verilog-a 搭建 NRZ-to-PAM3 和 PAM3-to-NRZ 模块 (采用 3B2T 编码)，并进行仿真验证；PRBSn 倒是可以直接用 `analogLib > vsource` 模块；
- (2026.02.xx ~ 2026.03.xx) 14. 用 verilog-a 搭建 reference-less PAM3 CDR 行为级模型，并进行仿真验证；
- (2026.02.xx ~ 2026.02.xx) 13. **详细阅读并总结 reference-less CDR 的各种方案，选取其中合适的几个，利用已有的 NRZ CDR 模型进行对比择优**


和 PRTS Generator (采用 PRBSn + NRZ-to-PAM3)








高速 wireline/serdes/CDR 设计的基本模块，包括 CML D-Latch AND/XOR, PRBS/PRTS, Alexander-PD 以及 LPF 等；
- (2026.02.03 ~ 2026.03.xx) 7.






