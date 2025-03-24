# Simplified Light Painting

## Infor

- Time: 2025.03.24
- Notes:
- Details:
- Relevant Resources:

<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 |  |  |
</div>

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 |  |  |
</div>


<div class='center'>

| Demo (top view)| Demo (bottom view) | 
|:-:|:-:|
 |  |  |
</div>

设计原理见博客 [How to Design a PCB Light Painting](<Blogs/Electronics/How to Design a PCB Light Painting.md>)

## Design Notes

作为一个简化版的灯光画，我们采用打印的方式来展示照片，而不是利用丝印。电路必需有的部分是**开关控制灯光恒流供电**（电池组其实不是必需的，谁说不可以必需插电用呢），为了使灯光画效果更好，我们再另外加入几个功能。

下面分别讨论这几个功能的设计。



### Constant Current Power Supply (恒流供电)

采用我们之前设计的压控电流源源为 LED 提供恒流供电。注意运放的供电只有 VCC = 5V 和 GND = 0V，NE5532 在此供电下的输出范围约为 1.4V ~ 4.4V (参考 [运算放大器 NE5532P 输出摆幅与输出功率测试](https://zhuanlan.zhihu.com/p/23436867090))，这个范围可以很好的控制 2N7000 (或者其它特性相似的 NMOS, 比如 SOT-23 封装的 2N7002), 此时，受运放输出范围限制，单个恒流源的输出在 0mA ~ 500mA 可调 (输出电压范围在 0V ~ 5V 之间)。如果使用 2N7002, 其在 $V_{GS} = 4 \ \mathrm{V}$ 的情况下，需消耗 0.25V\@100mA 的压降。

### Light Intensity Control (光强控制)

基于上面的恒流电路，我们只需通过模拟的方式，改变输出电流（滑动变阻器改变压控电流源的输入），即可改变 LED 的亮度。由于我们打算使用手头的 0603 LED, 其压降为 3.3V\@20mA，阈值电压 2.6V，因此 5V 的供电只能串联一个 LED 。

如果使用 5V 给 LED 供电，每个 LED 需串联 100 Ohm 的保护电阻（在 20mA 时功耗 40mW），限流的同时起到平衡电流的作用。为提高电路效率，我们将 5V 供电通过 Buck 电路 (TPS563201) 降到约 4.0V，则串联电阻变为 20 Ohm, (8mW\@20mA)。

这样，运放的供电采用 5V, 输入和输出采用 4.0V (输入采用 4.0V 是因为 4.0V 比模块升的 5V 更准), 提高电路效率的同时，保持了较大的可调范围。每个恒流源驱动 5 个 LED (0\~200mA), 一个运放构成两个恒流源，共 10 个 LED 。

为了方便控制，我们将每个 LED 的输出电流范围限制在 0.5mA ~ 20mA 之间, 即每个恒流源输出 2.5mA ~ 100mA, 

### Power Supply Management (供电管理)


我们采用锂电池 + 外围供电的方式为灯光画供电。也就是说，在外部插入电源时，外部电源为灯光画供电，同时给锂电池充电；拔掉外部电源时，锂电池为灯光画供电。为节省设计时间，考虑在淘宝买一个锂电池充放一体模块 (升压 5V, 适用 3.7V 锂电池)、一个 3.7V 锂电池。

使用 5.8x5.8mm 自锁作为电源总开关。开关断开时，可以对锂电池充电，但是不会给后级电路 (包括 LED) 供电。