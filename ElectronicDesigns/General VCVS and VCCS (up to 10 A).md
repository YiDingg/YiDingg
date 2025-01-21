# General VCVS and VCCS (up to 5 A)

> [!Note|style:callout|label:Infor]
Initially published at 17:27 on 2025-01-08 in Beijing.

## 背景

出于自身实验需求 (主要是测量和驱动)，设计了一种通用 VCVS (Voltage Controlled Voltage Source) 和 VCCS (Voltage Controlled Current Source)，主要特性如下：
- 输入 12V (2A max) 或 5V (5A max)，压控电压源 VCVS 输出 0 ~ 5V or 0 ~ 10V 可调 (input 5V 时 max 5A, input 12V 时 max 2A)，压控电流源 VCCS 输出 0 ~ 2A (input 12V) 或 0 ~ 5A (input 5V)；
- 输出峰值功率可达 25W (12V@2A or 5@5A)，可长时间工作在 12W (12V@1A or 5V@2A)，以满足大多数实验需求。

如果有时间，之后会进一步优化设计：借助 voltage inverter 将单电源输入转为正负双电源（负电源用于运放供电），再利用 buck 电路将输入电压调整为 5V，通过滑动开关切换输入电压，以灵活地满足不同输出需求。这样，只需要输入一路 +12V 电源，即可得到 -12V, +5V, 以及 VCVS 和 VCCS 共四路输出。

## Perforated Board

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-21-15-02-41_General VCVS and VCCS (up to 10 A).jpg"/></div> | <div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-21-15-02-52_General VCVS and VCCS (up to 10 A).jpg"/></div>|
</div>

## PCB Layout

下面是预览图、原理图和 PCB Layout 参考点击链接 [here](https://www.123865.com/s/0y0pTd-pXuj3) 以下载相关文件（预览图、原理图和 Gerber 文件等）

<div class='center'>

| Schematic | 3D | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-08-18-28-58_General VCVS and VCCS (up to 10 A).png" height = 250px/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-08-18-48-01_General VCVS and VCCS (up to 10 A).png" height = 250px/></div> |
</div>
<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-08-18-52-03_General VCVS and VCCS (up to 10 A).png" /></div> | <div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-21-15-04-58_General VCVS and VCCS (up to 10 A).png"/></div> |
</div>


<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-08-18-47-15_General VCVS and VCCS (up to 10 A).png"/></div> -->


<!-- 
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-08-18-51-05_General VCVS and VCCS (up to 10 A).png"  height = 250px/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-08-18-51-17_General VCVS and VCCS (up to 10 A).png"  height = 250px/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-08-18-32-20_General VCVS and VCCS (up to 10 A).png"/></div>
 -->

## PCB Verification

PCB 实物如下图所示：

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-20-12-15-57_General VCVS and VCCS (up to 10 A).jpg"  height = 250px/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-20-12-10-20_General VCVS and VCCS (up to 10 A).jpg"  height = 250px/></div> |
</div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-20-12-10-10_General VCVS and VCCS (up to 10 A).jpg"/></div> -->



## Test Results

具体测试数据见 [*Analog Circuits Handbook*](Books/Analog%20Circuits%20Manual) 中的 "General Voltage Controlled Voltage Source (up to 5 A)" 一节。

