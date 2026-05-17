# A 56 GT/s Quarter-Rate PAM3 CDR (84 Gb/s, 14 GHz) in TSMC 28nm CMOS Technology

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
- Data Rate: 56 GT/s (84 Gb/s)
- Clock Rate: 14-GHz 8-phase Ring-VCO (quarter-rate)
- Power Supply Voltage:
- Power Consumption:
- Jitter Performance:
    - rms (data) jitter of recovered clock < xx fs
    - rms (edge) jitter of retimed data < xx fs
- BER Specification: < 1E-12 at stressed conditions
- Technology: TSMC 28nm CMOS 

前置工作是这篇文献：
> [1] L. Feng, T. Li, X. Zou, X. Xiong, and Z. Zhang, “A 6–64-Gb/s 0.41-pJ/Bit Reference-Less PAM4 CDR Using a Frequency-Detection-Gain-Enhanced PFD Achieving 19.8-Gb/s/μs Acquisition Speed,” IEEE Trans. Circuits Syst. II, vol. 72, no. 1, pp. 68–72, Jan. 2025, doi: 10.1109/TCSII.2024.3481436.

做项目时可以复用之前已有的模块，例如 VCO 和 comparator (slicer) 等。


## 2. Objective and Schedule

- [x] (2026.01.20 ~ 2026.01.28) 1. 依次学习 CDR/SerDes/PAM3 理论知识，建立理论基础
- [x] (2026.01.28 ~ 2026.01.30) 2. 阅读 PAM3 CDR/SerDes 相关论文，了解前沿技术
- [x] (2026.02.00 ~ 2026.02.02) 3. 基于之前已有的理想 VCO (verilog-a)，创建具有相位噪声/抖动的 VCO，包括 VCO with white edge jitter 以及 VCO with white cycle jitter 两种模型 (后者更接近实际器件)，并进行仿真验证；
- [x] (2026.02.02 ~ 2026.02.03) 4. 更深入地学习 verilog-a，以及学习 Bus Wires 的使用方法
- [x] (2026.02.03 ~ 2026.02.03) 5. 创建可直接通过宏定义修改 bit 宽度的理想 ADC/DAC 模块，并进行仿真验证；
- [x] (2026.02.03 ~ 2026.02.05) 6. 用 verilog-a 搭建一系列 basic logic gates/modules, 包括 BUF, INV, AND, NAND, OR, NOR, XOR, XNOR, TG (transmission gate), MUX2, SRL (Gated SR-Latch), DL (Gated D-Latch), DFF (D-FlipFlop) 等，并进行仿真验证；分成两套，第一套是通过 parameter 来指定 vin_th 和 vout_high/vout_low，第二套则是引出 VSS/VDD 端口且默认 vth = (VDD + VSS)/2；
- [x] (2026.02.06 ~ 2026.02.07) 7. <s> 用 verilog-a 搭建 CML (current mode logic) gates/modules, 包括 BUF, INV, AND, NAND, OR, NOR, XOR, XNOR, MUX2, SRL (Gated SR-Latch), DL (Gated D-Latch), DFF (D-FlipFlop) 等，并进行仿真验证；</s>
- [x] (2026.02.06 ~ 2026.02.06) 8. 用 verilog-a 搭建 PLL 行为级模型，要求可以设置分频比 N 和环路参数；
- [x] (2026.02.06 ~ 2026.02.07) 9. 学习 PRBS 相关基础及电路实现方法，学习 `analogLib > vsource > prbs/bits` 使用方法；用 verilog-a 搭建 PRBS (Pseudo-random binary sequence) 和 RRBS (real-random binary sequence) Generator，并进行仿真验证；
- [x] (2026.02.07 ~ 2026.02.08) 10. 用 verilog-a 搭建 VCDL (voltage-controlled delay line)，然后基于之前的 VCO 模型，进一步给出 multi-phase VCO.
- [x] (2026.02.08 ~ 2026.02.09) 11. 用 verilog-a 搭建 Alexander-PD 和 Hogge-PD，并进行仿真验证；
- [x] (2026.02.09 ~ 2026.02.11) 12. 详细阅读并用 verilog-a 仿真验证 frequency detector for reference-less CDR 的各种方案，从中选出适合本项目的 quarter-rate bi-directional FD 方案；截至 2026.02.11 22:19，我们从数十篇论文中选取了 9 种 FD 方案进行验证，但无一能达到预期要求；
- [x] (2026.02.12 ~ 2026.02.15) 13. 用 2X-oversampling 自行设计 NRZ quarter-rate bi-directional FD 方案，并进行仿真验证与可用性评估；截至 2026.02.15 11:18, 带有 gain control 的 NRZ FD 方案已经基本验证成功，达到了很宽的 pull-in range $(0,\ 0.5 f_b) \to 0.25 f_b$；后续准备进一步评估功耗，以及从 NRZ 推广到 PAM3；
- [x] (2026.02.16 ~ 2026.02.17) 14. 在 T28 下搭建一系列 std. Vt CMOS Logic 基本模块，包括 INV/NAND/TG 等基本逻辑门，以及 D-Latch 和 D-FlipFlop 等时序模块，并进行仿真验证； 
- [x] (2026.02.16 ~ 2026.02.17) 15. 仿真发现 TG-based DFF (12T) 的后仿正常工作速率仅有约 5 GHz $(t_{cq} \approx )$，也即配置为 DIV2 时最大输入频率 15 GHz，无法满足 14 GHz 工作要求，遂寻找更高性能的 D-Latch 和 D-FlipFlop 结构，并进行仿真验证；
- [x] (2026.02.18 ~ 2026.02.21) 16. 阅读 high-speed DL/DFF 相关论文，从中选取了十余种 DL/DFF 结构进行仿真对比，最终确认 ETPSC-DFF 结构具有优于 TPSC-DFF 的最佳性能 (8T 满足常规需求，10T 满足 QB 输出需求)，并对其尺寸进行了迭代优化和 post-layout 验证。
- [x] (2026.02.22 ~ 2026.02.23) 17. 对 ETPSC-DFF 的 8T/10T 以及 with/without duty cycle correction 四种结构做了版图与后仿验证，最终确认 ETSPC-DFF-8T/10T with duty cycle correction 结构具有最佳性能 (8T 满足常规需求，10T 满足 QB 输出需求)，工作速率可达 28 GHz 以上 (as DIV2 47 GHz 以上)，全工艺角也能 24 GHz 以上 (as DIV2 40 GHz 以上)，很好地满足了项目 14 GHz 要求；
- [x] (2026.02.23 ~ 2026.02.23) 18. 用 verilog-a 搭建 BER Calculator 模块，实现 two-DATA + two-CK 输入下的 BER 计算功能，并进行仿真验证，方便后续 CDR loop 的 BER 仿真验证；
- [x] (2026.02.24 ~ 2026.02.24) 19. 用 verilog-a 搭建完整 full-rate NRZ CDR loop (Alexander-PD, Hogge-PD 两种)，仿真验证其 data recovery 和 jitter performance；
- [x] (2026.02.24 ~ 2026.02.24) 20. 用已有 DFF 模块搭建 Hogge-PD 和 Alexander-PD 放到 full-rate NRZ CDR loop 中，仿真验证其 data recovery 和 jitter performance；
- [x] (2026.02.24 ~ 2026.02.25) 21. 分别用 verilog-a 和已有 DFF 模块搭建 quarter-rate Alexander-PD 放到 quarter-rate NRZ CDR loop 中进行验证，同时构建 quarter-rate BER Calculator 模块；
- [x] (2026.02.25 ~ 2026.02.25) 22. 分别用 verilog-a 和已有 DFF 模块搭建 quarter-rate slice-and-align (S/A) 模块，然后搭建 NRZ quarter-rate PD/FD logic；
- [x] (2026.02.25 ~ 2026.02.26) 23. 搭建 verilog-a slicer (CML input) 模块，将 NRZ CDR loop 的输入从 CMOS Logic 换为 CML input，仿真验证无问题；
- [x] (2026.02.27 ~ 2026.03.01) 24. 基于 NRZ 时的思路，搭建 PAM3 PD/FD Logic，并将 NRZ CDR Loop 推广到 PAM3 CDR Loop 进行仿真验证，同时构建 PAM3 BER Calculator 进行验证；
- [x] (2026.03.02 ~ 2026.03.03) 25. 基于 offset sampler (slicer) 构建 lock detector 模块，同时根据 unlock/locked/deep-locked 三种状态自动调整相应的 CP 电流大小，仿真验证无问题；
- [x] (2026.03.03 ~ 2026.03.04) 26. 搭建 slicer 实际电路，搭建 S/H (sample and hold) 行为级电路，放到 PAM3 CDR loop 中进行仿真验证
- [x] (2026.03.05 ~ 2026.03.11) 27. 由于一般的 slicer 速度完全不够 (主要是 DFE 的 18 ps feedback 这块)，我们在一个星期内尝试了 StrongARM, double-tail, 7TXCP, 5TCML, 5TCMLXCP 等多种结构，最终后仿结果对比下来还是 StrongARM 表现最佳 (虽然距离理想性能仍有一定距离)。但没办法了，只能先用着这个，如果后面有时间的话会再迭代优化一下。
- [x] (2026.03.11 ~ 2026.03.11) 28. StrongARM 输入管尺寸较大，导致原来临时用的 summer 带不动，于是重新迭代设计了一版
- [x] (2026.03.11 ~ 2026.03.12) 29. 为抑制 StrongARM 较明显的 kickback noise, 我们在输入端引入了一对交叉耦合的电容 (后称 slicercap)；又为了抑制 slicer 反馈到 TH input pair of DFE (next summer) 时大摆幅造成的 summer 输出波动，我们在 TH input pair of DFE 也引入了一对交叉耦合的电容 (后称 summercap)；2026.04.04 注：后续仿真结果表明，还是不要有任何交叉耦合电容时效果好一些，所以最终核心里没有加入交叉耦合电容。
- [x] (2026.03.12 ~ 2026.03.13) 30. 在环路中验证各模块无问题，包括：calibre of SH (肖师兄提供的)、rf of summer 和 calibre of StrongARM_ENT；确认无问题之后，进入 VTH/DFE adaptation，先搭建 VTH adaptation.
- [x] (2026.03.14 ~ 2026.03.18) 31. 搭建并验证 VTH/DFE adaptation，注意确定每一个行为级的具体电路如何实现
- [x] (2026.03.19 ~ 2026.03.21) 32. 尝试了下 auto-zero (calibration of slicer global offset)，发现效果不是很好 (存在振荡，应是反馈裕度的问题)，遂放弃
- [x] (2026.03.20 ~ 2026.03.22) 33. 一边考虑 SH + Summer + Slicer 整体版图如何安排，一边完成 Summer 版图：时钟通过 M8 竖着走在一起，SH/Summer 向两边让开以避免时钟向下 "看到的" 电路不一样导致耦合问题。随后完成 SSS_1bitUnit (SH + Summer + Slicer) 的版图。
- [x] (2026.03.22 ~ 2026.03.23) 34. 给 Slicer 集成上 CK BUF 以减轻主时钟线负载，注意加入 CKBUF 后的时序问题；加入 CKBUF 后再次仿真验证
- [x] (2026.03.24 ~ 2026.03.27) 35. 用 SSS_1bitUnit 进行仿真，全方面评估电路性能，同时尝试升压至 1.1V/1.2V 看看性能极限在哪，最好是能达到 64Gbaud
- [x] (2026.03.27 ~ 2026.03.29) 36. 完成 dataPath 版图 (最关键是 DFE 走线) 后，仿真发现速率掉得挺多 (之前可以 1.0V @ 64G，拼到一起后只能 1.1V @ 62G)；
- [x] (2026.03.29 ~ 2026.03.31) 37. 尝试将 summer 电阻从 250 Ohm 改为 200 Ohm 以获得更高带宽，但仿真结果表明性能恶化十分严重，连 1.1V @ 56G 都不太行了，原因未知但只能放弃
- [x] (2026.03.31 ~ 2026.04.01) 38. 搭建 offset sampler path 用于后续的 lock detection，搭建完成后合并为 dataPath_ADA_OFS，并进行仿真验证


在环路中验证

- [] (2026.02.24 ~ 2026.02.25) 19. 用已有 DFF 模块搭建 4-bit counter，然后进一步搭建 quarter-rate bi-directional FD，配合 quarter-rate PD 放到 NRZ CDR loop 中进行仿真验证；

- [] (2026.02.24 ~ 2026.02.24) 19. 基于已有的 PRBS Generator，给出带有 rms edge jitter 的 PRBS Generator 模型，以及带有 rms edge jitter 的 PRTS Generator (pseudo-random ternary sequence)，后续用于生成 jittered data 给 CDR loop 进行仿真；



- [] (2026.02.24 ~ 2026.02.xx) 20. 用已有的 ETPSC-DFF 搭建 FD/PD for quarter-rate NRZ CDR，仿真验证后放到 verilog-a 搭建的 quarter-rate NRZ CDR loop 中进行验证；
- [] (2026.02.xx ~ 2026.02.xx) 21. 尝试将 quarter-rate PD 也融合进上述 quarter-rate bi-directional NRZ FD 方案中，进行优化以减少总资源消耗，构成 quarter-rate NRZ Bi-PFD 方案，并进行仿真验证；
- [] (2026.02.xx ~ 2026.02.xx) 22. 将 NRZ PFD 方案推广到 PAM3，并进行仿真验证；
- [] (2026.02.xx ~ 2026.02.xx) 23. 根据现有 quarter-rate NRZ/PAM3 PFD 模块，构建 lock-detector 模块，并进行仿真验证；



- (2026.02.xx ~ 2026.02.xx) 12. 用 verilog-a 搭建 NRZ CDR (PD + CP + LPF + VCO) 行为级模型，并进行仿真验证；
- (2026.02.xx ~ 2026.02.xx) 13. 用 verilog-a 搭建 NRZ-to-PAM3 和 PAM3-to-NRZ 模块 (采用 3B2T 编码)，并进行仿真验证；
- (2026.02.xx ~ 2026.02.xx) 14. 用 verilog-a 搭建 reference-less PAM3 CDR 行为级模型，并进行仿真验证；
- (2026.02.xx ~ 2026.02.xx) 13. **，选取其中合适的几个，利用已有的 NRZ CDR 模型进行对比择优**


和 PRTS Generator (采用 PRBSn + NRZ-to-PAM3)



- (2026.02.06 ~ 2026.02.06) 10. 用 verilog-a 搭建 8b/10b Encoder 和 Decoder 模块，用于后续的 NRZ 数据编码 (限制 max run length)；





高速 wireline/serdes/CDR 设计的基本模块，包括 CML D-Latch AND/XOR, PRBS/PRTS, Alexander-PD 以及 LPF 等；
- (2026.02.03 ~ 2026.03.xx) 7.




## Experience Summary

- `tsmcN28` PEX 后生成 calibre view 时，reset 有效的是 `simM=1 fingers=1`，分别代表 multi = 1 和 nf = 1



