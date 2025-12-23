# Test Experiment of The DC-DC Converter Modules

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 18:26 on 2025-02-28 in Beijing.

## Introduction

本文是对 [Electric Designs > DC-DC Converter Modules](<ElectronicDesigns/DC-DC Converter Modules.md>) 的测试实验，旨在测量/验证不同 DC-DC 转换器模块的性能和适用性。

<span style='color:red'> 这里放图片 </span>

本次实验需要测试 (某几个) 模块的多种输出性能，包括：
1. 输入输出范围 (input/output range)
2. 开关波形 (switching waveform)
3. 输出纹波 (output ripple)
4. 输出效率 (output efficiency)
5. 电源调整率 (line regulation)
6. 负载调整率 (load regulation) 
7. 瞬态响应 (transient response)

设计所包含模块的所有芯片如下：

<div class='center'>

| Num | Modules | Type | I_out | Input | Output | Note |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 1 | TPS63070 RNMR | buck-boost | 2A | 800mV~16V | 2V~9V |  |
| 2 | TPS563201 DDCR | buck | 3A | 4.5V~17V | 768mV~7V |  |
| 3 | SX1308 | boost | 1A/4A | 2V~24V | 4V~28V |  |
| 4 | TPS5430 DDAR | buck | 3A | 5.5V~36V | 1.3V~32V |  |
| 5 | TPS54331 | buck | 3A | 3.5V~28V | 800mV~25V |  |
| 6 | RY8310 | buck | 1A/2A | 4.5V~30V | 800mV~24.6V |  |
| 7 | MT2492 | buck | 2A/3A | 4.5V~16V | 600mV~14.7V | (同 RY8310) |
| 8 | MT3608 | boost | 1A/4A | 2V~24V | 4V~28V | (同 SX1308) |
| 9 | MC34063 ADR2G | multi | 1A/1.5A | 3.0V~40V | 1.25V~40V |  |

</div>

本文所用的测试仪器如下：
- 电流探头： Tektronix TCP3112A (C012006)
- 数字万用表： Unit UT61E (C190241394)
- 信号发生器： GWINSTEK AFG-22225 (GER910370)
- 数字示波器： RIGOL 200MSO2202A (DS2F192200361)
- 电子负载仪： ITECH IT8512B (800025051787070024), 英文手册 [here](https://www.itechate.com/uploadfiles/2019/06/201906211049264926.pdf), 中文手册 [here](https://www.itechate.com/uploadfiles/2019/06/201906201647484748.pdf)
- 数字直流电源： GWINSTEK GPD-3303S (GES813705) 
- 电流电压转换器： Tektronix TCPA300 (B017520)
- 多功能数字测量仪： [Analog Discovery 1](https://digilent.com/reference/test-and-measurement/analog-discovery/start) (D704387)
- 多功能模块化 DC-DC 开关电源： [All-In-One DC-DC Converter Modules](<ElectronicDesigns/All-In-One DC-DC Power Supply (5V Input).md>) <!-- (https://yidingg.github.io/YiDingg/#/ElectronicDesigns/DC-DC%20Converter%20Modules) -->




下面几个小节介绍各性能的测试方法及测试结果。

## Test Results


**<span style='color:red'> 若无特别说明，本次测试模块的输入电压均为 DC 5.2V, 由金升阳 5V@10A 开关电源提供。</span>**

### 1. Input/Output Range

为保证模块的使用安全和稳定，我们在设计时便主动限制了反馈电阻的调整范围，从而限制了模块输出范围 (使其不会超过芯片最大输出范围) ，而输入范围则由模块所使用的芯片决定。因此这一部分的测试主要是验证模块的输出范围是否符合预期。


设定负载电阻为 1kOhm (接近空载), 测试结果如下：

<div class='center'>

| Num | Module | Type | Test Load | Output Range |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | TPS63070 RNMR    | buck-boost| 1 kOhm |  |
 | 2 | TPS563201 DDCR   | buck      | 1 kOhm |  |
 | 3 | SX1308           | boost     | 1 kOhm |  |
 | 4 | TPS5430 DDAR     | buck      | 1 kOhm |  |
 | 5 | TPS54331         | buck      | 1 kOhm |  |
 | 6 | RY8310           | buck      | 1 kOhm |  |
 | 7 | MT2492           | buck      | 1 kOhm |  |
</div>

### 2. Switching Waveform

**<span style='color:red'> 从这一小节测试开始，均只考虑 TPS63070 (buck-boost) 和 TPS54331 (buck)，如果有时间和精力，再考虑测量其它模块。</span>**

Switching waveform, output ripple, output efficiency 一起测试，分别在轻载和中载条件下，测量模块的开关波形和输出纹波，并且计算其输出效率。其中开关波形用 <span style='color:red'> dc coupling (CH1) </span>，输出纹波用 <span style='color:red'> ac coupling </span> (CH2) 进行测量，并且输出纹波同步利用 FFT 窗口计算其频谱信息。




利用电子负载仪改变负载电阻，得到波形测试结果如下：

<div class='center'>

| Module | Nominal Output (No Load) | Test Condition | Output Voltage | Switching Waveform | Output Ripple |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | TPS54331 (buck) | 4.07 V | 80 Ohm | 4.04 V | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-18-15_Test Experiment of The DC-DC Converter Modules.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-19-48_Test Experiment of The DC-DC Converter Modules.png"/></div> |
 | TPS54331 (buck) | 4.07 V | 8 Ohm  | 3.80 V | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-22-46_Test Experiment of The DC-DC Converter Modules.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-20-27_Test Experiment of The DC-DC Converter Modules.png"/></div> |
 | TPS54331 (buck) | 4.07 V | 2 Ohm  | 3.21 V | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-23-15_Test Experiment of The DC-DC Converter Modules.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-21-34_Test Experiment of The DC-DC Converter Modules.png"/></div> |
 | SX1308 (boost)  | 10.03 V | 200 Ohm | 10.01 V | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-00-23_Test Experiment of The DC-DC Converter Modules.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-01-24_Test Experiment of The DC-DC Converter Modules.png"/></div> |
 | SX1308 (boost)  | 10.03 V | 20 Ohm  | 9.78 V | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-03-36_Test Experiment of The DC-DC Converter Modules.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-02-36_Test Experiment of The DC-DC Converter Modules.png"/></div> |
 | SX1308 (boost)  | 10.03 V | 10 Ohm  | 9.61 V | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-04-58_Test Experiment of The DC-DC Converter Modules.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-05-47_Test Experiment of The DC-DC Converter Modules.png"/></div> |
</div>

其中 nominal output 为电子负载仪读出的无负载输出电压。





### 3. Output Ripple


在上一小节已经完成测量。

### 4. Output Efficiency


利用电流探头测量输入电流 (电流探头设置为 <span style='color:red'> 1 A/V </span>) ，用万用表测量输入电压，从负载仪上读出输出的电压电流，得到效率测试结果如下：

<div class='center'>

| Module | Test Condition | Input | Output | Efficiency | Input Current |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | TPS54331 (buck) | 轻载 | 5.224 V @ 0.046 A | 4.05 V @ 0.050 A | 84.27 % | <div class="center"><img height=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-53-43_Test Experiment of The DC-DC Converter Modules.png"/></div> |
 | TPS54331 (buck) | 中载 | 5.190 V @ 0.389 A | 3.81 V @ 0.473 A | 89.26 % | <div class="center"><img height=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-48-35_Test Experiment of The DC-DC Converter Modules.png"/></div> |
 | TPS54331 (buck) | 重载 | 5.092 V @ 1.378 A | 3.15 V @ 1.578 A | 70.84 % | <div class="center"><img height=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-54-48_Test Experiment of The DC-DC Converter Modules.png"/></div> |
</div>


<div class='center'>

| Module | Test Condition | Input | Output | Efficiency | Input Current |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | SX1308 (boost)  | 轻载 | 5.217 V @ 0.220 A | 10.12 V @ 0.049 A | 43.20 % | <div class="center"><img height=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-16-59-50_Test Experiment of The DC-DC Converter Modules.png"/></div> |
 | SX1308 (boost)  | 中载 | 5.122 V @ 1.176 A | 9.87 V @ 0.492 A | 80.62 % | <div class="center"><img height=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-17-00-45_Test Experiment of The DC-DC Converter Modules.png"/></div> |
 | SX1308 (boost)  | 重载 | 4.990 V @ 2.410 A | 9.68 V @ 0.967 A | 77.84 % | <div class="center"><img height=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-17-01-12_Test Experiment of The DC-DC Converter Modules.png"/></div> |
</div>

<span style='color:red'> 注：模块含有两个 LED 输出指示灯，电流约为 2 mA, 在轻载测试中具有系统误差。</span>


### 5. Line Regulation

在中载条件下 (输出约 500 mA), 先设定好输出电压，然后改变模块输入电压，用万用表测量输出电压的变化情况。结果如下：

<div class='center'>

| Module | Test Condition | Input @ Output | Input @ Output | Line Regulation |
|:-:|:-:|:-:|:-:|:-:|
 | TPS54331 (buck) | nominal output 4 V @ 8 Ohm   | 4.887 V @ 3.886 V  | 6.317 V @ 3.893 V  | 4.90 mV/V |
 | SX1308 (boost)  | nominal output 10 V @ 20 Ohm | 4.810 V @ 10.099 V | 6.261 V @ 10.093 V | -4.14 mV/V |
</div>

### 6. Load Regulation

<!-- 利用电子负载仪，测试负载从 10 mA 变化到 1000 mA 时，输出电压的变化情况。结果如下：
 -->

利用 **4. Output Efficiency** 一小节中所得的数据，计算负载调整率和电源内阻，结果如下：

<div class='center'>

| Module | 轻载至中载 | 中载至重载 |
|:-:|:-:|:-:|
 | TPS54331 (buck) | -5.93 % @ 0.57 Ohm | -17.32 % @ 0.60 Ohm |
 | SX1308 (boost)  | -2.47 % @ 0.56 Ohm | -1.93 %  @ 0.40 Ohm |
</div>




### 7. Transient Response

利用电子负载仪，设置负载电流从 50 mA 突变到 500 mA, 测量输出电压的瞬态响应。设置示波器 CH1 为输出电压, CH2 为输出电流，测量结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-17-31-05_Test Experiment of The DC-DC Converter Modules.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-17-29-21_Test Experiment of The DC-DC Converter Modules.png"/></div>

不妨也测一下 TPS54331 (buck) 从 50 mA 到 1000 mA 的瞬态响应，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-13-20-56-17_Test Experiment of The DC-DC Converter Modules.png"/></div>


## Results Summary

不妨在 MATLAB 中作出效率和负载调整率的曲线，并与数据手册上的值进行对比：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-14-14-39-00_Test Experiment of The DC-DC Converter Modules.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-14-14-39-23_Test Experiment of The DC-DC Converter Modules.png"/></div>
