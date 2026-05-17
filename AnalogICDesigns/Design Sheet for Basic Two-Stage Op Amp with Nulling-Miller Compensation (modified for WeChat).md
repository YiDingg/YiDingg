# Design Sheet for Basic Two-Stage Op Amp with Nulling-Miller Compensation 

## Intro
**Design Sheet for Basic Two-Stage Op Amp with Nulling-Miller Compensation**

本文是此次两级运放设计的 **理论分析与设计指导**，具体的 **设计过程与前仿结果** 过两天会发。

先展示一下最终设计成果：

**A Basic Two-Stage Op Amp with Nulling-Miller Compensation Achieving 84.35dB Gain, 55.75MHz GBW and 56.31V/us Slew Rate**

此次设计很好地满足了指标要求，相比上一次的 202506 台积电 180nm 单端输出折叠式运放设计，各方面性能有明显提升。

## 1. Design Sheet

### 1.1 Reference Formulas 

我们之前在下面这篇文章中给出了 nulling-Miller compensation 的理论推导：
> 《模拟 CMOS 集成电路：两级运放米勒补偿详解——传递函数、零极点分布、DC Gain 和 GBW》
> **https://zhuanlan.zhihu.com/p/1945826367590601619**


令零点 $z$ 和第二极点 $p_2$ 恰好抵消，推导得到 design sheet 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-14-42-24_Design Sheet of Basic Two-Stage Op Amp with Nulling-Miller Compensation.png"/></div>

### 1.2 Generation of I_ref

详见文章：
> 《低压共源共栅电流镜的偏置结构考量——如何产生偏置电压 (Biasing Circuits for Low-Voltage Cascode Current Mirror)》
> **https://zhuanlan.zhihu.com/p/1935398118490367665**


下面是一个设计参考：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-14-44-11_Design Sheet of Basic Two-Stage Op Amp with Nulling-Miller Compensation.png"/></div>

## 2. Formula Derivations

### 2.1 DC Gain

详见文章 [Miller Compensation in Basic Two-Stage Op Amp](<AnalogIC/Miller Compensation in Basic Two-Stage Op Amp.md>)。

### 2.2 GBW and PM

详见文章 [Miller Compensation in Basic Two-Stage Op Amp](<AnalogIC/Miller Compensation in Basic Two-Stage Op Amp.md>)。

### 2.3 Slew Rate 

<!-- 参考 [知乎 > 模集王小桃: 运放的压摆过程与压摆率 Slewing of OTA with Capacitive Feedback](https://zhuanlan.zhihu.com/p/13230451810) 第三小节**三、两级运放的压摆过程** -->

参考 [Paper [1]](https://ieeexplore.ieee.org/document/7804049) table 1 中的 step 2, 我们有：

$$
\begin{gather}
\mathrm{SR} = \min \ \{\frac{I_{D5}}{C_c},\ \ \frac{I_{D6}}{C_c + C_L}\}
\end{gather}
$$


## Relevant Resources

### Relevant Literature
- [[1] An Accurate Design Approach for Two-Stage CMOS Operational Amplifiers](https://ieeexplore.ieee.org/document/7804049)
- [[2] Design of Two Stage Miller Compensated CMOS Op Amp with Nulling Resistor](https://ieeexplore.ieee.org/document/10527553/)

### Design Examples
- [知乎 > 模集王小桃: 基于 gm-ID 的运放设计 (单端输出的两级运放设计)](https://zhuanlan.zhihu.com/p/18217441114)
- [知乎 > 基于 gm/Id 法的五管 OTA 的设计](https://zhuanlan.zhihu.com/p/621225975)
- [知乎 > 两级运放调参记录](https://zhuanlan.zhihu.com/p/1913346894513546931)