# General-Purpose VCVS and VCCS <br> (通用压控电压源和压控电流源)

> [!Note|style:callout|label:Infor]
Initially published at 17:27 on 2025-01-08 in Beijing.

## Infor

- Time: 2025.01.07
- Details: 输入 $\pm 5 \ \mathrm{V} \sim \pm 15 \ \mathrm{V}$，输出一路 VCVS 和一路 VCCS, 最大峰值电流取决于电源最大输出电流 (和输出电压)
- Relevant Resources: [https://www.123684.com/s/0y0pTd-1euj3](https://www.123684.com/s/0y0pTd-1euj3)

## Background (背景)

出于自身实验需求 (主要是测量和驱动)，设计了一种通用 VCVS (Voltage Controlled Voltage Source) 和 VCCS (Voltage Controlled Current Source)，主要特性如下：
- 输入 12V (2A max) 或 5V (5A max)，压控电压源 VCVS 输出 0 ~ 5V or 0 ~ 10V 可调 (input 5V 时 max 5A, input 12V 时 max 2A)，压控电流源 VCCS 输出 0 ~ 2A (input 12V) 或 0 ~ 5A (input 5V)；
- 输出峰值功率可达 25W (12V@2A or 5V@5A)，可长时间工作在 12W (12V@1A or 5V@2A)，以满足大多数实验需求。

如果有时间，之后会进一步优化设计：借助 voltage inverter 将单电源输入转为正负双电源（负电源用于运放供电），再利用 buck 电路将输入电压调整为 5V，通过滑动开关切换输入电压，以灵活地满足不同输出需求。这样，只需要输入一路 +12V 电源，即可得到 -12V, +5V, 以及 VCVS 和 VCCS 共四路输出。

## Perforated Board

在面包板上搭建电路：
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

## Matters Needing Attention

需要注意的是，此电路中 MOSFET 的耗散功率较大，长时间工作在较大的电流（和较低的输出电压）可能会导致 MOS 管烧坏。之所以是较低的输出电压，是因为 MOS 管 DS 两端电压为： 

$$
V_{\mathrm{GS}} = \mathrm{VCC} - V_{\mathrm{out} }
$$

于是 MOS 上的功率为（以热量形式耗散）：

$$
P_{\mathrm{MOS}} = I_{\mathrm{out}}\cdot \left( \mathrm{VCC} - V_{\mathrm{out}} \right)
$$

只要注意不让 MOS 温度过高，那么电路的输出特性是非常好的（对常规测量而言），既保持了很大的输出功率（如果连接的 VCC 输出电流够大），也有非常不错的响应速度。

另外，还需要选择合适的补偿电容（接在运放负输入端和输出端之间）。补偿电容 C_comp 对 unit output 模式影响较小，但对 double output 模式至关重要，如果没有补偿电容，输出负反馈的相位裕度很可能不够大，从而出现欠阻尼震荡，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-04-35_General VCVS and VCCS (up to 10 A).png"/></div>

经过实际测试，补偿电容 C_comp 在 10pF ~ 0.1nF 之间，可以得到较好的输出特性。所需的输出响应速度越高（即输入输出信号频率越高），补偿电容越小。例如用作信号发生器的功率放大时，可以选择 20pF 的补偿电容，而用作恒压源时，可以选择 0.1nF 的补偿电容。

选择补偿电容为 20pF，得到的输出曲线如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-10-35_General VCVS and VCCS (up to 10 A).png" /></div>

## Test Results

部分测试数据在 [*Analog Circuits Handbook*](Books/Analog%20Circuits%20Manual) 中的 "General Voltage Controlled Voltage Source (up to 5 A)" 一节，也可以到知乎 [here](https://zhuanlan.zhihu.com/p/19723936453) 查看测试结果。为了方便查看，我们仍在这里给出相关测试结果：


下面对此电路进行一些常规测试，包括 output characteristics、output response、transient response 等。
<span style='color:red'> 
如无特别说明，均使用上面的 PCB 在室温下进行测试，且补偿电容 C_comp = 20pF
</span>


### Output Characteristics (输出特性)

<div class='center'>

| Unit output (x1) | Double output (x2) | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-09-50_General VCVS and VCCS (up to 10 A).png"  height = 250px/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-10-00_General VCVS and VCCS (up to 10 A).png"  height = 250px/></div> |
</div>


### Output Response (输出响应), unit output (x1)

<div class='center'>

| 1KHz sine wave 输出误差在 +-20mV 以内 <br> (作了纵坐标平移处理, 以方便看清输入输出波形) | 100KHz sine wave 输出摆幅开始减小 | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-10-14_General VCVS and VCCS (up to 10 A).png"  height = 250px/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-10-20_General VCVS and VCCS (up to 10 A).png"  height = 250px/></div> |
</div>

<div class='center'>

| 1MHz sine wave, 输出明显失真 | 10KHz ramp-up | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-10-27_General VCVS and VCCS (up to 10 A).png"  height = 250px/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-10-35_General VCVS and VCCS (up to 10 A).png"  height = 250px/></div> |
</div>

### Output Response (输出响应), double output (x2)

<div class='center'>

| 1KHz sine wave 输出误差在 [-100mV, +50mV] 以内 | 10KHz ramp-up | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-31-22_General VCVS and VCCS (up to 10 A).png"  height = 250px/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-31-26_General VCVS and VCCS (up to 10 A).png"  height = 250px/></div> |
</div>



### Transient Input Response (瞬态输入响应)

<div class='center'>

| Unit output | Double output |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-31-42_General VCVS and VCCS (up to 10 A).png"  height = 250px/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-31-46_General VCVS and VCCS (up to 10 A).png"  height = 250px/></div> |
</div>

## Measure MOSFET Characteristics

利用此电路，对信号发生器的输出进行功率放大，测量 IRF540N 和 IRF3205（两个 NMOS）的常见参数，包括 Output characteristics、Transfer characteristics、Drain-source on-state resistance 等，结果如下图所示：

<div class='center'>

| IRF540NPBF | IRF3205PBF |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-36-21_General VCVS and VCCS (up to 10 A).png"  width = 400px/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-22-12-36-08_General VCVS and VCCS (up to 10 A).png"  width = 400px/></div> |
</div>
