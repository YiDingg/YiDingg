# μA741 (Op Amp) using Discrete BJTs (SOT-23)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 01:40 on 2025-04-30 in Beijing.

## Information

- Time: 2025.04.30 00.12
- Notes: 用分立贴片三极管实现运算放大器 μA741
- Details: 三极管封装为 SOT-23, NPN 全部使用 MMBT3904, PNP 全部使用 MMBT3906
- Relevant Resources: https://www.123684.com/s/0y0pTd-E8Uj3, 设计思路详见 [Detailed Explanation of uA741](<Electronics/Detailed Explanation of uA741.md>), 与 [Basic CMOS Op Amp using Discrete MOSFETs](<ElectronicDesigns/Basic CMOS Op Amp using Discrete MOSFETs.md>) 合并打板

| Demo |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-23-11-14-31_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | 
</div>

<div class='center'>

| Rendering Image |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-20-34-23_μA741 using Discrete BJTs (SOT-23).png"/></div> |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-20-34-07_μA741 using Discrete BJTs (SOT-23).png"/></div> |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-20-33-38_μA741 using Discrete BJTs (SOT-23).png"/></div> |
</div>

<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 |<div class="center"><img height=240px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-01-35-25_μA741 using Discrete BJTs (SOT-23).png"/></div>|<div class="center"><img height=240px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-01-32-17_μA741 using Discrete BJTs (SOT-23).png"/></div>|
| Top view | Bottom view | 
 | <div class="center"><img height=240px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-01-31-33_μA741 using Discrete BJTs (SOT-23).png"/></div> | <div class="center"><img height=240px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-01-31-48_μA741 using Discrete BJTs (SOT-23).png"/></div> |
</div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-15-02-27-02_μA741 using Discrete BJTs (SOT-23).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-15-02-27-41_μA741 using Discrete BJTs (SOT-23).png"/></div>
 -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-15-02-27-59_μA741 using Discrete BJTs (SOT-23).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-15-02-28-16_μA741 using Discrete BJTs (SOT-23).png"/></div> -->





## Detailed Explanation

运放原理解读、参数计算和仿真结果详见 [Detailed Explanation of uA741](<Electronics/Detailed Explanation of uA741.md>)。

## Typical Applications

<!-- 详见 [Basic CMOS Op Amp using Discrete MOSFETs](<ElectronicDesigns/Basic CMOS Op Amp using Discrete MOSFETs.md>) 的 PCB 验证部分。 -->

### Unit Buffer

将 uA741 的 $V_{IN-}$ 与 $V_{OUT}$ 短接，从 $V_{IN+}$ 注入信号，测量结果如下：

<div class='center'>

| uA741 | zero input | sine input 1 | sine input 2 | sine input 3 |
|:-:|:-:|:-:|:-:|:-:|
 | $C_c = 47 \ \mathrm{pF}$ (MLCC) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-22-07-49_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-22-08-58_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-14-16-42_μA741 using Discrete BJTs (SOT-23).png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-22-09-37_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
</div>

### Inverting Amplifier

10 kOhm + 10 kOhm 构成 $A_v = -1$ 的 inverting amplifier, 测量结果如下：

<div class='center'>

| inverting amplifier | harmonic distortion | frequency response |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-14-31-35_μA741 using Discrete BJTs (SOT-23).png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-14-32-04_μA741 using Discrete BJTs (SOT-23).png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-14-39-45_μA741 using Discrete BJTs (SOT-23).png"/></div> |
</div>

### Integrating Circuit

利用 2 kOhm + 1 uF 构成 $RC = 2 \ \mathrm{ms}$ 的 integrating circuit. 为避免运放输出端饱和，在 $1 \ \mathrm{uF}$ 两端并联 1 MOhm 电阻，同时将示波器 CH2 改为 ac coupling ($f_c = 32 \ \mathrm{Hz}$), 输出波形如下：

$$
\begin{gather}
\mathrm{input 5 Vamp square,\ 理论斜率：} k = \frac{5 \ \mathrm{V}}{2 \ \mathrm{ms}} = 2.5 \ \mathrm{V/ms},\quad 
\mathrm{实际斜率：} k = + 2.539 \ \mathrm{V/ms},\ \ - 2.554\ \mathrm{V/ms}
\end{gather}
$$
<div class='center'>

| rise speed | fall speed |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-15-03-38_μA741 using Discrete BJTs (SOT-23).png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-15-02-02_μA741 using Discrete BJTs (SOT-23).png"/></div> |
</div>




此电路相关信息可见 [Electronic Tutorials: The Integrator Amplifier](https://www.electronics-tutorials.ws/opamp/opamp_6.html)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-14-54-59_μA741 using Discrete BJTs (SOT-23).png"/></div>

### Square Wave Generator

搭建如图所示的方波发生器（占空比可调）：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-15-23-08_μA741 using Discrete BJTs (SOT-23).png"/></div>
-->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-16-08-21_μA741 using Discrete BJTs (SOT-23).png"/></div>

电容为 10nF 独石电容，电阻都为 10 kOhm, 二极管选用的是 1N4148, $V_D = 0.6043 \ \mathrm{V},\ R_D \approx 26\ \Omega$，则理论频率和占空比为：

$$
\begin{gather}
f = \frac{1}{T},\ T = 2RC \ln \left( \frac{V_{OH} - \frac{V_{OL}}{1 + \frac{R_1}{R_f}}}{\frac{V_{OH}}{1 + \frac{R_1}{R_f}}} \right),\quad R = R_k (待定)
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-16-18-06_μA741 using Discrete BJTs (SOT-23).png"/></div>

有二极管时：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-17-38-32_μA741 using Discrete BJTs (SOT-23).png"/></div>

### Wien-Bridge Oscillator

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-16-34-34_μA741 using Discrete BJTs (SOT-23).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-16-37-46_μA741 using Discrete BJTs (SOT-23).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-16-33-30_μA741 using Discrete BJTs (SOT-23).png"/></div>

## Meas. of Discrete uA741

详见 [Op Amp Measurement of Discrete uA741](<Electronics/Op Amp Measurement of Discrete uA741.md>).