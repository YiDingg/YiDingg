# Design Sheet of Basic Two-Stage Op Amp with Nulling-Miller Compensation (Single-Ended Output)

> [!Note|style:callout|label:Infor]
Initially published at 10:26 on 2025-06-17 in Beijing.

## Design Sheet

### Reference Formulas 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-14-42-24_Design Sheet of Basic Two-Stage Op Amp with Nulling-Miller Compensation.png"/></div>

### Generation of I_ref

详见文章 [Reference Current Generation Methods](<AnalogIC/Reference Current Generation Methods.md>), 下面是一个设计参考：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-14-44-11_Design Sheet of Basic Two-Stage Op Amp with Nulling-Miller Compensation.png"/></div>

## Formula Derivations

### 1. DC Gain

略

### 2. GBW and PM

详见文章 [Miller Compensation in Basic Two-Stage Op Amp](<AnalogIC/Miller Compensation in Basic Two-Stage Op Amp.md>)。

### 3. Slew Rate 

<!-- 参考 [知乎 > 模集王小桃: 运放的压摆过程与压摆率 Slewing of OTA with Capacitive Feedback](https://zhuanlan.zhihu.com/p/13230451810) 第三小节**三、两级运放的压摆过程** -->

参考 [Paper 1](https://ieeexplore.ieee.org/document/7804049) table 1 中的 step 2, 我们有：

$$
\begin{gather}
\mathrm{SR} = \min \ \{\frac{I_{D5}}{C_c},\ \ \frac{I_{D6}}{C_c + C_L}\}
\end{gather}
$$

### 4. CM Input Range

略。

### 5. Output Swing

略。

### 6. Biasing Generation

可以考虑普通 mirror 或 cascode mirror 作为偏置电路。

### 7. Noise

略。

### 8. CMRR 

略。

### 9. PSRR 

略。



## Relevant Resources

### Relevant Literature
- [Paper 1: An Accurate Design Approach for Two-Stage CMOS Operational Amplifiers](https://ieeexplore.ieee.org/document/7804049)
- [Paper 2: Design of Two Stage Miller Compensated CMOS Op Amp with Nulling Resistor](<Papers/Design of Op Amp/Design of Two Stage Miller Compensated CMOS  Opamp with Nulling Resistor.md>)



### Relevant Articles

### Design Examples
- [知乎 > 模集王小桃: 基于 gm-ID 的运放设计 (单端输出的两级运放设计)](https://zhuanlan.zhihu.com/p/18217441114)
- [知乎 > 基于 gm/Id 法的五管 OTA 的设计](https://zhuanlan.zhihu.com/p/621225975)
- [知乎 > 两级运放调参记录](https://zhuanlan.zhihu.com/p/1913346894513546931)