# Transistor Measurement Methods

> [!Note|style:callout|label:Infor]
> Initially published at 15:44 on 2025-03-12 in Beijing.

## 前言

本文主要介绍了如何对晶体管 (包括 MOS, BJT 等) 的特性曲线进行测量，以及如何根据测量结果计算得到其它的基本参数。建议使用 [General-Purpose Transistor Tester](<ElectronicDesigns/General-Purpose Transistor Tester.md>) 或 [Simplified Transistor Tester](<ElectronicDesigns/Simplified Transistor Tester.md>) 进行测试。

## MOSFET

### 测试原理
在不考虑温度的情况下， MOSFET 的三个参数 $V_{GS}$, $I_D$ 和 $V_{DS}$ 仅含有 2 个自由度，也就是说，任意给定两个限制条件，即可确定三个参数的值。最典型的例子，给定 $V_{DS}$（作为横坐标） 和 $V_{GS}$（作为第二变量），便可确定 $I_D$ 的值。随着 $V_{DS}$（和 $V_{GS}$）不断变化，我们便绘制出了 MOSFET 的 Static Characteristics

### 可测曲线概览

下表列出了本板 ([General](<ElectronicDesigns/General-Purpose Transistor Tester.md>) or [Simplified](<ElectronicDesigns/Simplified Transistor Tester.md>)) 可以测量的特性曲线（列列出一部分），括号内三个参数表示 (y, x, var)，分别为横坐标、纵坐标和第二变量。

<div class='center'>

| 数据号 | $y$ (纵坐标) | $x$ (横坐标) | var (第二变量) | note (备注) |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | $I_D$ | $V_{DS}$ | $V_{GS}$ | static chara |
 | 2 | $I_D$ | $V_{GS}$ | $V_{DS}$ | transfer curve |
 | 3 | $g_m$ | $f$ | $I_{D}$ | - |
</div>

特别地，对于 $(g_m, f, I_D)$ 的测试，我们的初步想法如下：
1. MOSFET 由 resistor divider + $R_G = 100 \ \mathrm{k}\Omega$（用于提高输入阻抗）来给定 $V_{GS}$ 偏置，手动调节 $V_{CC1}$ 以使 $I_D$ 处于待测值
2. $V_{DS}$ 固定，由自带电流检测的电压源给出 (比如 5V)，以保证 MOS 处于饱和区
3. 用 capacitor coupling 在 gate 端进行输入，输入幅度应尽量小以保证小信号近似成立 (可以考虑 10 kOhm + 100 Ohm 分压以获得 40dB 的衰减)；需要注意耦合电容不应大于 10uF ($f_c = 391.93 \ \mathrm{kHz}$)
4. 1、2 两条共用一个电源 VCC1, 第 3 条直接用 AD1 的 W1 输入即可。

由上面的测量数据，可以进一步计算得到：

<div class='center'>

| Using Data | $y$ (纵坐标) | $x$ (横坐标) | var (第二变量) | 参考计算方法 |
|:-:|:-:|:-:|:-:|:-:|
| 1 | $r_O$ | $V_{DS}$ | $V_{GS}$ | 取饱和区数据作线性拟合 |
| 1 | $R_{ON}$ | $V_{DS}$ | $V_{GS}$ | 横坐标 $V_{DS}$ 直接除以纵坐标 $I_D$ |
| 2 | $g_m$ | $V_{GS}$ | $V_{DS}$ | （数据滤波后）直接求导 |
</div>




### 具体测试方法

在实际应用中，我们只对众多特性曲线的一部分感兴趣，也是比较重要的几个特性曲线，下面将介绍它们的测试方法：

| Data Num (数据序列号) | 名称 | $(y,\ x,\ var)$ | 测试方法 | 图片示例 |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | <span style='color:red'> Static Characteristics </span> | $(I_D,\ V_{DS},\  V_{GS})$ | 两个电压源分别提供 $V_{DS}$ 和 $V_{GS}$ <br> CH1 (纵坐标) 测 $I_D$，CH2 (横坐标) 测 $V_{DS}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-22-17-07-30_Transistor Measurement Methods.png"/></div> |
 | 2 | <span style='color:red'> Transfer Characteristics </span> | $(I_D,\ V_{GS},\  V_{DS})$ | 两个电压源分别提供 $V_{DS}$ 和 $V_{GS}$ <br> CH1 (纵坐标) 测 $I_D$，CH2 (横坐标) 测 $V_{GS}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-22-17-13-01_Transistor Measurement Methods.png"/></div> |


### MOSFET 测量流程示例

<div class='center'>

**被测元件: NMOS 2N7002, 2D current level: `low (0 ~ 5mA)`, 3D current level: `moderate (0 ~ 25mA)`**

(这里放实物图)
</div>

<div class='center'>

**3D Measurement, current level: `moderate (0 ~ 25mA)`**

| 测量序号 | 数据号 | <span style='color:red'> 3D </span> $(y,\ x,\ var)$ | Test condition | 图片记录 |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | 1 | $(I_D,\ V_{DS},\ V_{GS})$ | 电流检测 $R_{I_D} = \ \mathrm{\Omega}$ |  |
 | 2 | 2 | $(I_D,\ V_{GS},\ V_{DS})$ | 电流检测 $R_{I_D} = \ \mathrm{\Omega}$ |  |

</div>

<div class='center'>

**2D Measurement, current level: `low (0 ~ 5mA)`**

| 测量序号 | 数据号 | <span style='color:red'> 2D </span> $(y,\ x,\ var)$ | Test condition | 图片记录 |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | 1 | $(I_D,\ V_{DS},\ V_{GS})$ | 电流检测 $R_{I_D} = \ \mathrm{\Omega}$ |  |
 | 2 | 2 | $(I_D,\ V_{GS},\ V_{DS})$ | 电流检测 $R_{I_D} = \ \mathrm{\Omega}$ |  |
</div>

## BJT (Bipolar Transistor)

### 测试原理

同理，在不考虑温度的情况下， BJT 的四个参数 $V_{CE}$, $I_C$, $V_{BE}$ 和 $I_B$ 仅含有 2 个自由度，也就是说，任意给定两个限制条件，即可确定四个参数的值。最典型的例子，给定 $V_{CE}$（作为横坐标） 和 $I_B$（作为第二变量），便可确定 $I_C$ 和 $V_{BE}$ 的值。随着 $V_{CE}$（和 $I_B$）不断变化，我们便绘制出了 BJT 的 Static Characteristics。



### 可测曲线概览

下面是本测试板 ([General](<ElectronicDesigns/General-Purpose Transistor Tester.md>) or [Simplified](<ElectronicDesigns/Simplified Transistor Tester.md>)) 可测量的特性曲线（仅列出一部分），括号内三个参数表示 (y, x, var)，分别为横坐标、纵坐标和第二变量。


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
| 8 | $I_{B,actual}$ | $V_{CE}$ | $I_B$ |
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

| Data Num (数据序列号) | 名称 | $(y,\ x,\ var)$ | 测试方法 | 图片示例 |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | <span style='color:red'> Static Characteristics </span> | $(I_C,\ V_{CE},\  I_B)$ | 电压源提供 $V_{CE}$，精密电流源提供 $I_B$ <br> CH1 (纵坐标) 测 $I_C$，CH2 (横坐标) 测 $V_{CE}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-27-21-55-48_General-Purpose Transistor Tester Transistor Tester.png"/></div> |
 | 8 | 用于计算 $\beta$ | $(I_{B,actual},\ V_{CE},\  I_B)$ | 在上一条的基础上，CH1 (纵坐标) 测 $I_B$  | - |
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
 | 2,3 | Current Gain <br> (large-signal) | $(\beta,\ I_C,\ V_{CE})$ | $\beta = \frac{I_C}{I_B}$，用 num2 的 $I_C$ 作横坐标 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-27-21-57-59_General-Purpose Transistor Tester Transistor Tester.png"/></div> |
 | 1 | Early Resistance <br> (small-signal) | $(r_O,\ I_C,\ I_B)$ | $r_O = \frac{\partial V_{CE} }{\partial I_C } = \left(\frac{\partial I_C }{\partial V_{CE} }\right)^{-1}$ <br> 拟合 $r_O = \frac{V_A}{I_C}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-14-26-03_General-Purpose Transistor Tester.png"/></div> |
 | 1 | Early Resistance <br> (small-signal) | $(r_O,\ V_{CE},\ I_B)$ | $r_O = \frac{\partial V_{CE} }{\partial I_C } = \left(\frac{\partial I_C }{\partial V_{CE} }\right)^{-1}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-14-26-38_General-Purpose Transistor Tester.png"/></div> |
 | 2 | Transconductance <br> (small-signal) | $(g_m,\ I_C,\ V_{CE})$ | $g_m = \frac{\partial I_C }{\partial V_{BE} }$ | - |
 | 2 | Transconductance <br> (small-signal) | $(\frac{g_m}{I_C},\ I_C,\ V_{CE})$ | $g_m = \frac{\partial I_C }{\partial V_{BE} }$ | - |
 | 2 | Transconductance <br> (small-signal) | $(g_m,\ V_{BE},\ V_{CE})$ | $g_m = \frac{\partial I_C }{\partial V_{BE} }$ | - |
 | 2, 3 | Base Resistance <br> (small-signal) | $(r_{\pi},\ I_C,\ V_{CE})$ | $r_{\pi} = \frac{\partial V_{BE} }{\partial I_B }$，用 num2 的 $I_C$ 作横坐标 | - |
 | 2, 3 | Base Resistance <br> (small-signal) | $(r_{\pi},\ V_{BE},\ V_{CE})$ | $r_{\pi} = \frac{\partial V_{BE} }{\partial I_B }$，用 num2 的 $I_C$ 作横坐标 | - |
</div>

将上面的结果全部合并，最终得到多张结果图。至此，一个 BJT 的在低频下的特性曲线测试便全部完成了。

事实上，很多时候上面的测试太过繁琐，我们没法对每一种 BJT 都进行如此详尽的测试，这时候我们会选择去关注下面三个最重要、也是最基本的特性曲线：

<div class='center'>

| (y, x, var) | note |
|:-:|:-:|
 | $(I_C,\ V_{BE},\ V_{CE})$ | determine $V_{BE}$ by the desired $I_C$ |
 | $(\beta,\ I_C,\ V_{CE})$ | determine $\beta$, hence $I_B$ |
 | $(I_C,\ V_{CE},\ I_B)$ | calculate $V_{CE}$ |
</div>

在大多数情况下，上面三种特性曲线已经足够我们较精确地设计有关 BJT 的电路了（例如三种基本放大器）。

### BJT 测试流程示例

<div class='center'>

**测试元件: SS8050**

(这里是实物图)

| 测量序号 | 数据号 | $(y,\ x,\ var)$ | source and ammeter | test condition | 图片记录 |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | 1  | <span style='color:red'> 1 </span> | $(I_C,\ V_{CE},\ I_B)$ | V (Vce, res) + C (Ib, -) | $I_C\ (I_B)$ 大, $R_{I_C} = \ \mathrm{\Omega}$ |  |
 | 2  | <span style='color:red'> 1 </span> | $(I_C,\ V_{CE},\ I_B)$ | V (Vce, res) + C (Ib, -) | <span style='color:red'> 3D</span>, $I_C\ (I_B)$ <span style='color:red'> 小 </span>, $R_{I_C} = \ \mathrm{\Omega}$ |  |
 | 3  | <span style='color:red'> 1 </span> | $(I_C,\ V_{CE},\ I_B)$ | V (Vce, res) + C (Ib, -)| $I_C\ (I_B)$ 小, $R_{I_C} = \ \mathrm{\Omega}$ |  |
 | 4  | <span style='color:red'> 8 </span> | $(I_{B, actual},\ V_{CE},\ I_B)$ | V (Vce, res) + C (Ib, sou) | 同上, 改测 $I_{B}$, $R_{I_B} = \ \mathrm{\Omega}$ |  |
 | 6  | <span style='color:blue'> 5 </span> | $(I_B,\ V_{CE},\ V_{BE})$ | V (Vce, res) + V (Vbe, amp) | $I_C\ (I_B)$ 大, $R_{I_B,eq} = \ \mathrm{\Omega}$ |  |
 | 5  | <span style='color:blue'> 4 </span> | $(I_C,\ V_{CE},\ V_{BE})$ | V (Vce, res) + V (Vbe, amp) | 同上, 改测 $I_{C}$, $R_{I_C} = \ \mathrm{\Omega}$ |  |
 | 7  | <span style='color:red'> 2 </span> | $(I_C,\ V_{BE},\ V_{CE})$ | V (Vce, amp) + V (Vbe, -) |  $I_C\ (I_B)$ 大, $R_{I_C,eq} = \ \mathrm{\Omega}$ |  |
 | 8  | <span style='color:red'> 3 </span> | $(I_B,\ V_{BE},\ V_{CE})$ | V (Vce, amp) + V (Vbe, -) | 同上, 改测 $I_{B}$, $R_{I_B} = \ \mathrm{\Omega}$ |  |
 | 9  | <span style='color:blue'> 6 </span> | $(V_{CE, sat},\ I_C,\ \beta=10)$ | C (Ic, sou) + C (Ib, -) | $I_C\ (I_B)$ 大, $R_{I_C} = \ \mathrm{\Omega}$ |  |
 | 10 | <span style='color:blue'> 7 </span> | $(V_{BE, sat},\ I_C,\ \beta=10)$ |  C (Ic, sou) + C (Ib, -) | 同上, 改测 $V_{BE, sat}$, $R_{I_C} = \ \mathrm{\Omega}$ |  |
</div>

上表中的 `res` 指用外源 resistor 作为 ammeter, `amp` 指用外源 amplifier 作为 ammeter, `sou` 指用 precision current source 自带的 $R_o$ 作为 ammeter。

然后进行数据的整理、计算，并绘制出特性曲线图。
















## 相关实验记录



- 2025.03.14, 15:50, Beijing. 对 SS8050 (NPN) 进行了特性曲线测试，实验记录见 [BJT Measurement of SS8050](<Electronics/[Analog Comp] Transistor Measurement of SS8050 (NPN).md>)
- 2025.04.23, 21:37, Beijing. 对 2N7000 (NMOS) 进行了测量，实验记录见 [Transistor Measurement of 2N7000 (NMOS)](<Electronics/Transistor Measurement of 2N7000 (N VDMOS).md>)

所有测试结果（包括上面两条）都汇总在了  [The Collection of My Measurement Experiments](<Electronics/The Collection of My Measurement Experiments.md>).






## 其它

<div class='center'>

| 三极管特性曲线中出现的“凹陷”现象 (固定 $I_B$ 改变 $V_{CE}$, 测 $I_C$) | $(x, y, z) = (V_{CE},\ I_B,\ I_C)$ | $(x, y, z) = (V_{CE},\ I_B,\ V_{BE})$ | $(x, y, z) = (V_{CE},\ I_B,\ I_{B, actual})$ |
|:-:|:-:|:-:|:-:|
 | 2N3904 (NPN) | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-16-00-09_Transistor Measurement Methods.png"/></div> | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-16-02-43_Transistor Measurement Methods.png"/></div> | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-16-05-19_Transistor Measurement Methods.png"/></div> |
 | BC550C (NPN) | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-16-20-03_Transistor Measurement Methods.png"/></div> | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-16-21-43_Transistor Measurement Methods.png"/></div> | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-16-23-02_Transistor Measurement Methods.png"/></div> |
 | SS8050 (NPN) | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-16-13-27_Transistor Measurement Methods.png"/></div> | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-16-15-19_Transistor Measurement Methods.png"/></div> | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-16-17-33_Transistor Measurement Methods.png"/></div> |

<!--  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-16-01-51_Transistor Measurement Methods.png"/></div> | -->


<!--  | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-15-52-36_Transistor Measurement Methods.png"/></div> |
 | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-15-55-55_Transistor Measurement Methods.png"/></div> | -->
</div>



<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-15-52-32_Transistor Measurement Methods.png"/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-15-53-52_Transistor Measurement Methods.png"/></div> -->
