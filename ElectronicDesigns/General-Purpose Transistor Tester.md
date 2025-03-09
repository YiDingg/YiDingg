# General-Purpose Transistor Tester

> [!Note|style:callout|label:Infor]
> Initially published at 18:49 on 2024-02-26 in Beijing.

## Infor

- Time: 
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
 |<div class="center"><img height = 250px src=""/></div>|<div class="center"><img height = 250px src=""/></div>|

</div>

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img height = 250px src=""/></div> | <div class="center"><img height = 250px src=""/></div> |
</div>



## MOSFET 

### 测试原理

在不考虑温度的情况下， MOSFET 的三个参数 $V_{GS}$, $I_D$ 和 $V_{DS}$ 仅含有 2 个自由度，也就是说，任意给定两个限制条件，即可确定三个参数的值。最典型的例子，给定 $V_{DS}$（作为横坐标） 和 $V_{GS}$（作为第二变量），便可确定 $I_D$ 的值。随着 $V_{DS}$（和 $V_{GS}$）不断变化，我们便绘制出了 MOSFET 的 Static Characteristics

### 可测曲线概览

下面是本测试板可测量的特性曲线（仅列出一部分），括号内三个参数表示 (y, x, var)，分别为横坐标、纵坐标和第二变量。

<div class='center'>

| $y$ (纵坐标) | $x$ (横坐标) | var (第二变量) |
|:-:|:-:|:-:|
 |  |  |  |
 |  |  |  |
</div>


### 具体测试方法

在实际应用中，我们只对众多特性曲线的一部分感兴趣，也是比较重要的几个特性曲线，下面将介绍它们的测试方法：

## BJT

### 测试原理

同理，在不考虑温度的情况下，BJT 的四个参数 $V_{CE}$, $I_C$, $V_{BE}$ 和 $I_B$ 仅含有 2 个自由度，也就是说，任意给定两个限制条件，即可确定四个参数的值。最典型的例子，给定 $V_{CE}$（作为横坐标） 和 $I_B$（作为第二变量），便可确定 $I_C$ 和 $V_{BE}$ 的值。随着 $V_{CE}$（和 $I_B$）不断变化，我们便绘制出了 BJT 的 Static Characteristics。



### 可测曲线概览

下面是本测试板可测量的特性曲线（仅列出一部分），括号内三个参数表示 (y, x, var)，分别为横坐标、纵坐标和第二变量。


<div class='center'>

| Num | $y$ (纵坐标) | $x$ (横坐标) | var (第二变量) |
|:-:|:-:|:-:|:-:|
| 1 | $I_C$ | $V_{CE}$ | $I_B$ |
| 2 | $I_C$ | $V_{BE}$ | $V_{CE}$ |
| 3 | $I_B$ | $V_{BE}$ | $V_{CE}$ |
| 4 | $I_C$ | $V_{CE}$ | $V_{BE}$ |
| 5 | $I_B$ | $V_{CE}$ | $V_{BE}$ |
| 6 | $V_{CE,sat}$ | $I_C$ | $\beta$ (通常取 10) |
| 7 | $V_{BE,sat}$ | $I_C$ | $\beta$ (通常取 10) |
</div>


由上表所示的测量数据，我们还可以计算得到以下曲线：

<div class='center'>

| Using Data | $y$ (纵坐标) | $x$ (横坐标) | var (第二变量) |
|:-:|:-:|:-:|:-:|
| 1 | $\beta$ | $V_{CE}$ | $I_B$ |
| 2, 3 | $\beta$ | $V_{BE}$ | $V_{CE}$ |
| 2, 3 | $\beta$ | $I_C$ | $V_{CE}$ |
| 4, 5 | $\beta$ | $V_{CE}$ | $V_{BE}$ |
| 4, 5 | $\beta$ | $I_C$ | $V_{BE}$ |
| 1 | $r_O$ | $V_{CE}$ | $I_B$ |
| 1 | $r_O$ | $I_C$ | $I_B$ |
| 4 | $r_O$ | $V_{CE}$ | $V_{BE}$ |
| 5 | $r_{\pi}$ | $V_{CE}$ | $V_{BE}$ |
| 3 | $r_{\pi}$ | $V_{BE}$ | $V_{CE}$ |
| 3 | $r_{\pi}$ | $I_B$ | $V_{CE}$ |
| 2 | $g_m$ | $V_{BE}$ | $V_{CE}$ |
| 2 | $g_m$ | $I_C$ | $V_{CE}$ |
</div>

### 具体测试方法


在实际应用中，我们只对众多特性曲线的一部分感兴趣，也是比较重要的几个特性曲线，下面将介绍它们的测试方法：


<div class='center'>

| Num | 名称 | $(y,\ x,\ var)$ | 测试方法 | 图片示例 |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | <span style='color:red'> Static Characteristics </span> | $(I_C,\ V_{CE},\  I_B)$ | 电压源提供 $V_{CE}$，精密电流源提供 $I_B$ <br> CH1 (纵坐标) 测 $I_C$，CH2 (横坐标) 测 $V_{CE}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-27-21-55-48_General-Purpose Transistor Tester Transistor Tester.png"/></div> |
 | 4 | Static Characteristics (voltage) | $(I_C,\ V_{CE},\  V_{BE})$ | 两个电压源提供 $V_{CE}$ 和 $V_{BE}$ <br> CH1 (y) 测 $I_C$，CH2 (x) 测 $V_{CE}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-04-01-04-20_General-Purpose Transistor Tester Transistor Tester.png"/></div> |
 | 5 | Base Current (voltage) | $(I_B,\ V_{CE},\  V_{BE})$ | 在上一条的基础上，CH1 改为测 $I_B$ | - | 
 | 2 | <span style='color:red'> Transfer Characteristics </span> | $(I_C,\ V_{BE},\  V_{CE})$ | 两个电压源提供 $V_{BE}$ 和 $V_{CE}$ <br> CH1 (y) 测 $I_C$，CH2 (x) 测 $V_{BE}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-27-21-56-39_General-Purpose Transistor Tester Transistor Tester.png"/></div> |
 | 3 | 用于计算 $\beta$ | $(I_B,\ V_{BE},\  V_{CE})$ | 在上一条的基础上，CH1 改为测 $I_B$ | - |
 | 6 | CE Saturation Voltage | $(V_{CE,sat},\ I_C,\  \beta)$ | 两个输出系数 10:1 的电流源提供 $I_C$ 和 $I_B$ ($\beta = 10$) <br> CH1 (y) 测 $V_{CE,sat}$，CH2 (x) 测 $I_C$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-27-21-57-44_General-Purpose Transistor Tester Transistor Tester.png"/></div> |
 | 7 | BE Saturation Voltage | $(V_{BE,sat},\ I_C,\  \beta)$ | 以上一条基础为基础，CH1 (y) 改为 $V_{BE,sat}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-27-21-57-46_General-Purpose Transistor Tester Transistor Tester.png"/></div> |
</div>

依据上面数据，进一步计算得到以下曲线：

<div class='center'>

| Using Data | 名称 | $(y,\ x,\ var)$ | 计算方法 | 图片示例 |
|:-:|:-:|:-:|:-:|:-:|
 | 2,3 | <span style='color:red'> Current Gain </span> | $(\beta,\ I_C,\ V_{CE})$ | $\beta = \frac{I_C}{I_B}$，用 num2 的 $I_C$ 作横坐标 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-27-21-57-59_General-Purpose Transistor Tester Transistor Tester.png"/></div> |
 | 1 | Early Resistance | $(r_O,\ I_C,\ I_B)$ | $r_O = \frac{\partial V_{CE} }{\partial I_C } = \left(\frac{\partial I_C }{\partial V_{CE} }\right)^{-1}$ | - |
 | 2 | Transconductance <br> (small-signal) | $(g_m,\ I_C,\ V_{CE})$ | $g_m = \frac{\partial I_C }{\partial V_{BE} }$ | - |
 | 2, 3 | Base Input Resistance <br> (small-signal) | $(r_{\pi},\ I_C,\ V_{CE})$ | $r_{\pi} = \frac{\partial I_B }{\partial V_{BE} }$，用 num2 的 $I_C$ 作横坐标 | - |
</div>

将上面的结果全部合并，最终得到九张结果图。至此，一个 BJT 的在低频下的特性曲线测试便全部完成了。

事实上，很多时候上面的测试太过繁琐，我们没法对每一种 BJT 都进行如此详尽的测试，这时候我们会选择去关注下面三个最重要、也是最基本的特性曲线：

<div class='center'>

| (y, x, var) | note |
|:-:|:-:|
 | $(I_C,\ V_{BE},\ V_{CE})$ | determine $V_{BE}$ by the desired $I_C$ |
 | $(\beta,\ I_C,\ V_{CE})$ | determine $\beta$, hence $I_B$ |
 | $(I_C,\ V_{CE},\ I_B)$ | calculate $V_{CE}$ |
</div>

在大多数情况下，上面三种特性曲线已经足够我们较精确地设计有关 BJT 的电路了（例如三种基本放大器）。

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
 | 0 ~ 50mA  | 50mV  | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 1 Ohm    | 150KHz | 2 V/us |
 | 0 ~ 500mA | 50mV  | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 100 mOhm | 150KHz | 2 V/us |

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
 | 0 ~ 5A  | 50mV  | <span style='color:red'> INA240 A3 </span> | 100 | 0 ~ 5V | 10 mOhm   | 400KHz | 2 V/us |
 | 0 ~ 5A  | 150mV  | <span style='color:red'> INA240 A3 </span> | 100 | 0 ~ 5V | 30 mOhm   | 400KHz | 2 V/us |
 | 0 ~ 500mA | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 ~ 5V | 50 mOhm  | 105KHz | 2 V/us |
 | 0 ~ 50mA  | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 ~ 5V | 500 mOhm | 105KHz | 2 V/us |
 | 0 ~ 5mA   | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 ~ 5V | 5 Ohm    | 105KHz | 2 V/us |
 | 0 ~ 500mA | 50mV | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 100 mOhm  | 150KHz | 2 V/us |
 | 0 ~ 50mA  | 50mV  | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 1 Ohm    | 150KHz | 2 V/us |
 | 0 ~ 5mA   | 50mV  | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 10 Ohm   | 150KHz | 2 V/us |
</div>

需要 INA180A4, INA180A3, INA240A3，以及低阻值采样电阻 10 mOhm, 30mOhm, 50mOhm 。我们将在上面三组共六套方案中, 每组各选出一种, 作为 General-Purpose Transistor Tester 自带的电流采样电路。

对每一种方案，我们测试模块输入 100KHz sine wave (current signal) 和 100KHz RampUp (current signal) 的输出波形，并测量其 gain 的 bode plot (给出 3dB BW)。