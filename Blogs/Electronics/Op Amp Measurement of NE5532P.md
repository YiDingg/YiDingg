# Op Amp Measurement of NE5532P (运算放大器 NE5532P 的测试记录)

> [!Note|style:callout|label:Infor]
> Initially published at 09:31 on 2025-03-15 in Beijing.

## 实验目的

测量 TI 公司运算放大器 NE5532P 的常见参数，包括 input offset voltage $V_{OS}\ (\mathrm{or\ }V_{IO})$, input bias current $I_{B\pm}$ (and input offset current $I_{OS}$), open-loop dc/ac gain $A_{OL}$, dc/ac CMRR, dc/ac PSRR 共八个参数。

实验原理与具体测试步骤见 [Op Amp Measurement Methods](<Blogs/Electronics/Op Amp Measurement Methods.md>)。

## 实验记录

- Time: 2025.04.13 
- Location: Beijing
- Auxiliary device (辅助运放): NE5532P (absolute max supply range: ±22V or 44V)
- Device under test (待测运放): NE5532P (absolute max supply range: ±22V or 44V)
- Measurement board (测试板): [Basic Op Amp Measurement Board](<ElectronicDesigns/Basic Op Amp Measurement Board.md>)
- 依次测量: V_IO, I_B; DC gain, DC CMRR, DC PSRR; AC gain, AC CMRR, AC PSRR
- AUX: 始终由直流电源供电 (±12V)
- DUT: 除了测试 AC CMRR 和 AC PSRR 时, DUT 的供电由信号发生器提供 (不超过 [-5V, +5V]), 其它参数测试时, DUT 均由直流电源供电 (±12V, 与 AUX 供电相同)。


<div class='center'>

| 测试板 ([Basic Op Amp Measurement Board](<ElectronicDesigns/Basic Op Amp Measurement Board.md>)) | 待测运放 (NE5532P) |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-22-21-21_Op Amp Measurement of NE5532P.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-22-21-34_Op Amp Measurement of NE5532P.png"/></div> |
</div>

各开关初始状态如下:
<div class='center'>

| Switch | AC Input | SW1 | SW2 | SW3 | IN1+ | IN2+ | SW6 | DUTVCC | WP |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | **Initial state** | `NC` | `0R` | `0R` | `OFF` | `TP2` | `TP1` | `0 10K` | `AUX+-` | `W` |

</div>

实验记录如下：
<div class='center'>

| Data Num | Parameter | Steps | Formula | Figure |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | $V_{IO}$ |record $V_{TP1}$ | $V_{IO} = \frac{V_{TP1}}{1001}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-16-15-51_Op Amp Measurement of NE5532P.png"/></div> |
 | 2 | $I_{B\pm}$ |S2 `0R`, S1 from `0R` to `R7`, write $(\Delta V_{TP1})_{1}$ <br> S1 `0R`, S2 from `0R` to `R6`, write $(\Delta V_{TP1})_{2}$ | $I_{B-} = - \frac{(\Delta V_{TP1})_1}{1001\,R7}$ <br> $I_{B+} = +\frac{(\Delta V_{TP1})_2}{1001\,R6}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-16-16-17_Op Amp Measurement of NE5532P.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-16-16-38_Op Amp Measurement of NE5532P.png"/></div> |
 | 3 | DC Gain | S6 from `0 10K` to `1 +1V`, write $\Delta V_{TP2}$ and $\Delta V_{TP1}$ | $A_{OL} = \frac{1001\, \Delta V_{TP2}}{\Delta V_{TP1}}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-16-18-14_Op Amp Measurement of NE5532P.png"/></div> |
 | 5 | DC CMRR |W1 and W2 from ±4V to +5V and -3V, write $\Delta V_{TP1}$, $\Delta V_{CM} = \frac{\Delta V_{CC+} + \Delta V_{CC-}}{2}$ | $\mathrm{CMRR} = \frac{1001\, \Delta V_{CM}}{\Delta V_{TP1}}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-16-22-14_Op Amp Measurement of NE5532P.png"/></div> |
 | 6 | DC PSRR |W1 and W2 from ±4V to ±12V (or ±5V), write $\Delta V_{TP1}$ | $\mathrm{PSRR} = \frac{1001\, \Delta V_{PS,total}}{\Delta V_{TP1}}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-16-28-12_Op Amp Measurement of NE5532P.png"/></div> |
 | 4 | AC Gain | S4 to `R9`, **AD1 Impedance** inputs ac signal (50Hz ~ 5MHz), measure $v_{TP2}$ | $A_{OL} = \left(1 + \frac{\frac{1}{2\pi f C_{in}} + R_9}{R_1}\right)\cdot \frac{v_{TP2, amp}}{v_{IN, amp}}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-16-58-51_Op Amp Measurement of NE5532P.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-18-31-16_Op Amp Measurement of NE5532P.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-19-26-25_Op Amp Measurement of NE5532P.png"/></div> |
 | 7 | AC CMRR | <span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = 0}}$ and measure $v_{TP2, amp}$ | $\mathrm{CMRR} = \frac{10001\, V_{W1, \mathrm{amp}}}{V_{TP2, \mathrm{amp}}}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-19-14-12_Op Amp Measurement of NE5532P.png"/></div> |
 | 8 | AC PSRR |<span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = \pi}}$ and measure $v_{TP2, amp}$ | $\mathrm{PSRR} = \frac{20002\, V_{W1, \mathrm{amp}}}{V_{TP2, \mathrm{amp}}}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-19-34-24_Op Amp Measurement of NE5532P.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-19-46-16_Op Amp Measurement of NE5532P.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-19-47-21_Op Amp Measurement of NE5532P.png"/></div> |

</div>



</div>

DC 数据处理：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-16-48-34_Op Amp Measurement of NE5532P.png"/></div>

AC 数据处理：

``` script
AC Gain (unit: dB, using 1nF + 1MOhm):
20*log10((1+(1/(2*PI*Frequency*pow(10,-9))+pow(10,6))/100)*(VRMS*sqrt(2)/(Amplitude*1.02)))

AC Gain (unit: V/V, using 1nF + 1MOhm):
(1+(1/(2*PI*Frequency*pow(10,-9))+pow(10,6))/100)*(VRMS*sqrt(2)/(Amplitude*1.02))

AC CMRR (unit: dB):

AC PSRR (unit: dB):
```

注：在上面测量 PSRR 时，误将公式 $\mathrm{PSRR} = \frac{20002\, V_{W1, \mathrm{amp}}}{V_{TP2, \mathrm{amp}}}$ 写成 $\mathrm{PSRR} = \frac{10001\, V_{W1, \mathrm{amp}}}{V_{TP2, \mathrm{amp}}}$, 因此实际结果应在原图片的基础上加 6dB.

## 异常现象讨论

在 AC Gain 的测试中, 我们惊讶地发现，测得的增益曲线竟然与输入信号的幅度有关（已保证输出信号在摆幅内，即输出无斩波），下面是一部分测试结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-20-38-35_Op Amp Measurement of NE5532P.png"/></div>

由我们对运放的常识来看，运放的通常会有一个比较靠近虚轴的低频极点，因此会在此极点对应频率附近产生一个增益曲线的 "peak" ，这表明 `amp = 0.1V` 的曲线更接近真实增益曲线。产生差异的原因，可能与“输入信号是否足够小”有关，具体原理，有待进一步讨论。

如何验证我们的增益曲线是正确的呢？注意到数据手册中专门列出了 $f = 10 \ \mathrm{kHz}$ 时的小信号增益，我们可以通过这各特殊点来验证测量结果是否准确：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-20-49-26_Op Amp Measurement of NE5532P.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-20-48-44_Op Amp Measurement of NE5532P.png"/></div>

数据手册给出的值是 2.2 kV/V @ 10 kHz, 而我们测得的值是 2.172 kV/V @ 10 kHz, 显然是非常接近的。我们还可以由此估计出增益带宽积：

$$
\begin{gather}
\mathrm{GBW} = 2.172 \ \mathrm{kV/V} \cdot 10 \ \mathrm{kHz} = 21.72 \ \mathrm{MHz}
\end{gather}
$$

我们将扫频前调至 10Hz, 所得增益曲线如下 (amp = 0.1V):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-21-01-44_Op Amp Measurement of NE5532P.png"/></div>

如何解释 200Hz 前增益处于上升状态？这个现象也有待后续进一步讨论。

## 其它运放的增益曲线

如下图所示，其它运放测得的增益曲线也出现了低频时增益异常下降的现象，因此这很可能是系统误差导致的，也就是目前测量原理的设计上具有某种缺陷。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-21-24-19_Op Amp Measurement of NE5532P.png"/></div>

尝试了将 AUX 运放更改为 LM358P 和 JRC4558D, 现象无明显变化。
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-21-18-12_Op Amp Measurement of NE5532P.png"/></div>
 -->

我们还特意用信号发生器的扫频来验证低频增益是否有异常降低，结果与上面的一致，确实有非常明显的降低：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-22-11-12_Op Amp Measurement of NE5532P.png"/></div>

## 结果汇总

下面是 DC 相关参数的结果汇总：
<div class='center'>

| Op Amp | Parameter | $V_{IO}$ | $I_{B+}$ | $I_{B-}$ | $I_{B}$ | $I_{OS}$ | DC Gain | DC CMRR | DC PSRR |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| NE5532P | Value | +0.4981 mV | +220.51 nA | +218.15 nA | +219.33 nA | +2.3566 nA | 2.0019e6 (126.0285 dB) | -2.3553e6 (127.4409 dB) | 0.6518e6 (116.2825 dB) |
</div>

## 测试板改进思路

- Bug fix: DUTOUT 未接入 AUX 的 input-, 板子上已飞线修正, 原理图上已更正
- Bug fix: 板子上标的丝印, DUT_Vin+ 和 DUT_Vin- 反了, 板子上已马克笔更正, 原理图上已更正
- New feature: 将示波器接口换为 test point, 以便于连接示波器探头
- New feature: 将 `+1V` 网络引出，并增大其可调范围，相当于自带了一个 0~VCC 的参考电压，可以用于 AC CMRR, AC PSRR 测试环节中 W2 输入信号的生成 (与线性运算器搭配使用)
- New feature: 在 new version 的设计中，加入多个 auxiliary package adapter (例如 SOP-8 转 DIP-8), 便于测量不同封装的运放
- New feature: AUX 辅助运放也采用杜邦线进行连接, 方便更换不同型号的运放