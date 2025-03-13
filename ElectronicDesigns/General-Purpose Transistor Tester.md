# General-Purpose Transistor Tester

> [!Note|style:callout|label:Infor]
> Initially published at 18:49 on 2025-02-26 in Beijing.

## Infor

- Time: 2025.02.26
- Notes: for diodes and transistors (NFET/PFET/NPN/PNP) testing
- Details:
    - 可外接功率放大电路 (例如 VCVS 和 VCCS)
    - 自带（不同量程的）三通道电流采样，满足不同功率大小的测试需求
    - 可用于测试 TO-220, TO-263, SOT-23, TO-92, SOP-8 等常见封装
    - 测试 BJT 时，建议搭配 [Precision VCCS](<ElectronicDesigns/Precision Voltage-Controlled Current Source.md>) 使用（用于输入确定电流）
- Interactive BOM:
- Relevant Resources:


<div class='center'>

| Schematic | 3D view |
|:-:|:-:|
 |<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-10-17-47-43_General-Purpose Transistor Tester.png"/></div>| <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-10-17-48-34_General-Purpose Transistor Tester.png"/></div> |

</div>

<!--
<div class='center'>

| Top view | Bottom view |
|:-:|:-:|
 |  |  |
</div>

 -->

## Transistor Measurement Methods

Go to [Transistor Measurement Methods](<Blogs/Electronics/Transistor Measurement Methods.md>).

## Design Notes


- 待测电流信号：10KHz ~ 100KHz RampUp
- Nominal Dropout Voltage: 25mV for low current sampling, 100 mV for high current sampling
- Minimum Sampling Resistance: 50 mOhm (to ensure sampling accuracy)


部分元件选型表如下（太贵的芯片我们没有列出）：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-21-58-11_Transistor Tester for ADx.png"/></div>

下面是一些可选的解决方案：


Using INA180Ax (A1/A2/A3/A4) series:

<div class='center'>

| sampling range | dropout | product | gain | V_out | R_sense | BW | slew rate |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 0 ~ 5mA   | 25mV  | INA180 A4 | 200 | 0 ~ 5V | 5 Ohm    | 105KHz | 2 V/us |
 | 0 ~ 50mA  | 25mV  | INA180 A4 | 200 | 0 ~ 5V | 500 mOhm | 105KHz | 2 V/us |
 | 0 ~ 500mA | 25mV  | INA180 A4 | 200 | 0 ~ 5V | 50 mOhm  | 105KHz | 2 V/us |
 | 0 ~ 5mA   | 50mV  | INA180 A4 | 100 | 0 ~ 5V | 10 Ohm   | 150KHz | 2 V/us |
 | 0 ~ 50mA  | 50mV  | INA180 A3 | 100 | 0 ~ 5V | 1 Ohm    | 150KHz | 2 V/us |
 | 0 ~ 500mA | 50mV  | INA180 A3 | 100 | 0 ~ 5V | 100 mOhm | 150KHz | 2 V/us |

</div>

Using INA240Ax (A1/A2/A3/A4) series:

<div class='center'>

| sampling range | dropout | product | gain | V_out | R_sense | BW | slew rate |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 0 ~ 50mA | 25mV  | INA240 A4 | 200 | 0 ~ 5V | 500 mOhm | 400KHz | 2 V/us |
 | 0 ~ 500mA | 25mV | INA240 A4 | 200 | 0 ~ 5V | 50 mOhm | 400KHz | 2 V/us |
 | 0 ~ 50mA | 50mV  | INA240 A3 | 100 | 0 ~ 5V | 1 Ohm | 400KHz | 2 V/us |
 | 0 ~ 500mA | 50mV | INA240 A3 | 100 | 0 ~ 5V | 100 mOhm | 400KHz | 2 V/us |
</div>


you can also use a smaller $R_{sense}$ for higher sampling range:

<div class='center'>

| sampling range | dropout | gain | V_out | R_sense |
|:-:|:-:|:-:|:-:|:-:|
 | 0 ~ 500mA | 25mV  | 200 | 0 ~ 5V | 50 mOhm |
 | 0 ~ 2.5A  | 25mV  | 200 | 0 ~ 5V | 10 mOhm |
 | 0 ~ 1A  | 50mV  | 100 | 0 ~ 5V | 50 mOhm  |
 | 0 ~ 5A  | 50mV  | 100 | 0 ~ 5V | 10 mOhm |
</div>

## Current Sampling Veri

我们 Layout 一个验证版，链接 [Current Sense Amplifiers](<ElectronicDesigns/Current Sense Amplifiers.md>), 用于验证下面几种方案：

<div class='center'>



| sampling range | dropout | product | gain | V_out | R_sense | BW | slew rate |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 0 ~ 5A    | 50mV  | <span style='color:red'> INA240 A3 </span> | 100 | 0 ~ 5V | 10 mOhm   | 400KHz | 2 V/us |
 | 0 ~ 2.5A  | 50mV  | <span style='color:red'> INA240 A3 </span> | 100 | 0 ~ 5V | 20 mOhm   | 400KHz | 2 V/us |
 | 0 ~ 5mA   | 50mV  | <span style='color:red'> INA240 A3 </span> | 100 | 0 ~ 5V | 10  Ohm   | 400KHz | 2 V/us |
 | 0 ~ 500mA | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 ~ 5V | 50 mOhm  | 105KHz | 2 V/us |
 | 0 ~ 50mA  | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 ~ 5V | 500 mOhm | 105KHz | 2 V/us |
 | 0 ~ 5mA   | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 ~ 5V | 5 Ohm    | 105KHz | 2 V/us |
 | 0 ~ 500mA | 50mV | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 100 mOhm  | 150KHz | 2 V/us |
 | 0 ~ 5mA   | 50mV  | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 10 Ohm   | 150KHz | 2 V/us |


<!--  | 0 ~ 50mA  | 50mV  | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 1 Ohm    | 150KHz | 2 V/us | -->
</div>

需要 INA180A4, INA180A3, INA240A3，以及低阻值采样电阻 10 mOhm, 30mOhm, 50mOhm 。我们将在上面共六套方案中, 选出合适且较精确的方案, 作为 General-Purpose Transistor Tester 的电流采样电路。

对每一种方案，我们测试模块输入 100KHz sine wave (current signal) 和 100KHz RampUp (current signal) 的输出波形，并测量其 gain 的 bode plot (给出 3dB BW)。