# Op Amp Measurement of Discrete uA741


> [!Note|style:callout|label:Infor]
> Initially published at 09:31 on 2025-03-15 in Beijing.

## 实验记录

测量实验汇总: [The Collection of My Measurement Experiments](<Electronics/The Collection of My Measurement Experiments.md>).

- Time: 2025.04.13 
- Location: Beijing
- Auxiliary device (辅助运放): NE5532DR (absolute max supply range: ±22V or 44V)
- Device under test (待测运放): [Discrete uA741](<ElectronicDesigns/μA741 using Discrete BJTs (SOT-23).md>) (absolute max supply range: ±22V or 44V)
- Measurement board (测试板): [Basic Op Amp Measurement Board v2](<ElectronicDesigns/Basic Op Amp Measurement Board v2.md>)
- AUX: 始终由直流电源供电 (±12V)
- DUT: 除了测试 AC CMRR 和 AC PSRR 时, DUT 的供电由信号发生器提供 (不超过 [-5V, +5V]), 其它参数测试时, DUT 均由直流电源供电 (±12V, 与 AUX 供电相同)。


<div class='center'>

| 测试板 ([Basic Op Amp Measurement Board v2](<ElectronicDesigns/Basic Op Amp Measurement Board v2.md>)) | 待测运放 ([Discrete uA741](<ElectronicDesigns/μA741 using Discrete BJTs (SOT-23).md>)) |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-15-57-32_Basic Op Amp Measurement Board v2.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-23-11-14-31_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> |
</div>








各开关初始状态如下:
<div class='center'>

| Switch | SW1 | SW2 | SW3 | IN1+ (CH1) | IN2+ (CH2) | SW6 | AC INPUT | WP | DUTVCC |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | **Initial state** | `0R` | `0R` | `0 OFF` | `TP1` | `TP2` | `0 10K` | `NC` | `W12` | `WP+-` or `AUX+-`  |

</div>









实验备注：
- 第一步测量 $V_{IO}$ 时，CH1 (TP1) 多在几百毫伏至几伏, CH2 (TP2) 多在几毫伏至几十毫伏
- 第三步测量 DC Gain 时，CH1 (TP1) 多在几十毫伏至几百毫伏, CH2 (TP2) 多在几伏
- 测量 AC Gain 时，对 DC Gain < 80 dB 的运放，使用 10 nF + 51kOhm; 对 DC Gain > 80 dB 的运放，使用 1 nF + 1MOhm








实验记录如下：
<div class='center'>

| Data Num | Parameter | Steps | Formula | Figure |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | $V_{IO}$ |record $V_{TP1}$ | $V_{IO} = \frac{V_{TP1}}{1001}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-19-13-28_Op Amp Measurement of Discrete uA741.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-20-28-23_Op Amp Measurement of Discrete uA741.png"/></div> |
 | 2 | $I_{B\pm}$ |S2 `0R`, S1 from `0R` to `R7`, write $(\Delta V_{TP1})_{1}$ <br> S1 `0R`, S2 from `0R` to `R6`, write $(\Delta V_{TP1})_{2}$ | $I_{B-} = - \frac{(\Delta V_{TP1})_1}{1001\,R7}$ <br> $I_{B+} = +\frac{(\Delta V_{TP1})_2}{1001\,R6}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-19-15-41_Op Amp Measurement of Discrete uA741.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-19-21-17_Op Amp Measurement of Discrete uA741.png"/></div> |
 | 3 | DC Gain | S6 from `0 10K` to `1 +1V`, write $\Delta V_{TP2}$ and $\Delta V_{TP1}$ | $A_{OL} = \frac{1001\, \Delta V_{TP2}}{\Delta V_{TP1}}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-19-23-33_Op Amp Measurement of Discrete uA741.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-19-32-53_Op Amp Measurement of Discrete uA741.png"/></div> |
 | 5 | DC CMRR |W1 and W2 from ±4V to +5V and -3V, write $\Delta V_{TP1}$, $\Delta V_{CM} = \frac{\Delta V_{CC+} + \Delta V_{CC-}}{2}$ | $\mathrm{CMRR} = \frac{1001\, \Delta V_{CM}}{\Delta V_{TP1}}$ |  |
 | 6 | DC PSRR |W1 and W2 from ±4V to ±12V (or ±5V), write $\Delta V_{TP1}$ | $\mathrm{PSRR} = \frac{1001\, \Delta V_{PS,total}}{\Delta V_{TP1}}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-19-37-10_Op Amp Measurement of Discrete uA741.png"/></div> |
 | 4 | AC Gain | S4 to `R9`, **AD1 Impedance** inputs ac signal (50Hz ~ 5MHz), measure $v_{TP2}$ | $A_{OL} = \left(1 + \frac{\frac{1}{2\pi f C_{in}} + R_9}{R_1}\right)\cdot \left(- \frac{v_{TP2, amp}}{v_{IN, amp}}\right)$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-20-06-59_Op Amp Measurement of Discrete uA741.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-20-08-31_Op Amp Measurement of Discrete uA741.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-20-10-02_Op Amp Measurement of Discrete uA741.png"/></div> |
 | 7 | AC CMRR | <span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = 0}}$ and measure $v_{TP2, amp}$ | $\mathrm{CMRR} = \frac{10001\, V_{W1, \mathrm{amp}}}{V_{TP2, \mathrm{amp}}}$ |  |
 | 8 | AC PSRR |<span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = \pi}}$ and measure $v_{TP2, amp}$ | $\mathrm{PSRR} = \frac{20002\, V_{W1, \mathrm{amp}}}{V_{TP2, \mathrm{amp}}}$ |  |

</div>


<!-- 
第二次测量：

<div class='center'>

| Data Num | Parameter | Steps | Formula | Figure |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | $V_{IO}$ |record $V_{TP1}$ | $V_{IO} = \frac{V_{TP1}}{1001}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-20-35-00_Op Amp Measurement of Discrete uA741.png"/></div> |
 | 2 | $I_{B\pm}$ |S2 `0R`, S1 from `0R` to `R7`, write $(\Delta V_{TP1})_{1}$ <br> S1 `0R`, S2 from `0R` to `R6`, write $(\Delta V_{TP1})_{2}$ | $I_{B-} = - \frac{(\Delta V_{TP1})_1}{1001\,R7}$ <br> $I_{B+} = +\frac{(\Delta V_{TP1})_2}{1001\,R6}$ |  |
 | 3 | DC Gain | S6 from `0 10K` to `1 +1V`, write $\Delta V_{TP2}$ and $\Delta V_{TP1}$ | $A_{OL} = \frac{1001\, \Delta V_{TP2}}{\Delta V_{TP1}}$  |  |
 | 5 | DC CMRR |W1 and W2 from ±4V to +5V and -3V, write $\Delta V_{TP1}$, $\Delta V_{CM} = \frac{\Delta V_{CC+} + \Delta V_{CC-}}{2}$ | $\mathrm{CMRR} = \frac{1001\, \Delta V_{CM}}{\Delta V_{TP1}}$ |  |
 | 6 | DC PSRR |W1 and W2 from ±4V to ±12V (or ±5V), write $\Delta V_{TP1}$ | $\mathrm{PSRR} = \frac{1001\, \Delta V_{PS,total}}{\Delta V_{TP1}}$ |  |
 | 4 | AC Gain | S4 to `R9`, **AD1 Impedance** inputs ac signal (50Hz ~ 5MHz), measure $v_{TP2}$ | $A_{OL} = \left(1 + \frac{\frac{1}{2\pi f C_{in}} + R_9}{R_1}\right)\cdot \left(- \frac{v_{TP2, amp}}{v_{IN, amp}}\right)$ |  |
 | 7 | AC CMRR | <span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = 0}}$ and measure $v_{TP2, amp}$ | $\mathrm{CMRR} = \frac{10001\, V_{W1, \mathrm{amp}}}{V_{TP2, \mathrm{amp}}}$ |  |
 | 8 | AC PSRR |<span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = \pi}}$ and measure $v_{TP2, amp}$ | $\mathrm{PSRR} = \frac{20002\, V_{W1, \mathrm{amp}}}{V_{TP2, \mathrm{amp}}}$ |  |

</div>
 -->


<!-- 
ac gain 废弃数据
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-20-02-59_Op Amp Measurement of Discrete uA741.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-19-56-21_Op Amp Measurement of Discrete uA741.png"/></div>
 -->


## 数据处理



**using 10nF + 51kOhm:**
``` script
using 10nF + 51kOhm:

AC Gain (unit: dB, using 10nF + 51kOhm, CH1 = Vin, CH2 = Vout):
20*log10((1+(1/(2*PI*Frequency*pow(10,-8))+51000)/100) *(IRMS*Resistor/VRMS))


AC Gain (unit: V/V, using 10nF + 51kOhm):
(1+(1/(2*PI*Frequency*pow(10,-8))+51000)/100) *(IRMS*Resistor/VRMS)

```

**using 1nF + 1MOhm:**
``` script
using 1nF + 1MOhm:

AC Gain (unit: dB, using 1nF + 1MOhm, CH1 = Vin, CH2 = Vout):
20*log10((1+(1/(2*PI*Frequency*pow(10,-9))+pow(10,6))/100) *(IRMS*Resistor/VRMS))

AC Gain (unit: V/V, using 1nF + 1MOhm):
(1+(1/(2*PI*Frequency*pow(10,-9))+pow(10,6))/100) *(IRMS*Resistor/VRMS)

```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-21-10-35_Op Amp Measurement of Discrete uA741.png"/></div>

``` matlab
% 运放测量板测量运放参数
R_7 = 3.9e3;
R_77 = 390e3;
R_6 = 3.9e3;
R_66 = 390e3;



TP1_Vos = 3.5334;  % V_IO
TP2_Vos = 13.579e-3;
TP1_Ib_R7 = 3.3392;
TP1_Ib_R6 = 3.6214;
TP1_DCGain = 4.797;
TP2_DCGain = -8.0405;
TP1_DCGain_2 = 3.9408;
TP2_DCGain_2 = -3.9738;
TP1_PSRR = 3.3278;
Delta_Vs = 2*(16 - 12);


I_B_neg = -(TP1_Ib_R7 - TP1_Vos)/(R_7*1001);
I_B_neg_2 = -(3.4266 - 3.5654)/(R_7*1001);
I_B_pos = (TP1_Ib_R6 - TP1_Vos)/(R_6*1001);
I_B_pos_2 = (3.72 - 3.5566)/(R_6*1001);
A_v_dc = abs( 1001 * (TP2_DCGain - TP2_Vos) / (TP1_DCGain - TP1_Vos));
A_v_dc_2 = abs( 1001 * (TP2_DCGain_2 - TP2_Vos) / (TP1_DCGain_2 - TP1_Vos));
PSRR_dc = abs( 1001 * Delta_Vs / (TP1_PSRR - TP1_Vos) );


disp(['V_IO = ', num2str(TP1_Vos/1001 * 1000), ' mV'])
disp(['I_B_neg = ', num2str(I_B_neg*10^9), ' nA'])
disp(['I_B_neg_2 = ', num2str(I_B_neg_2*10^9), ' nA'])
disp(['I_B_pos = ', num2str(I_B_pos*10^9), ' nA'])
disp(['I_B_pos_2 = ', num2str(I_B_pos_2*10^9), ' nA'])
I_B = 0.5*(I_B_pos_2 + I_B_neg_2)*10^9
I_OS = 0.5*(I_B_pos_2 - I_B_neg_2)*10^9

disp(['DC Gain 1 = ', num2str(A_v_dc), ' = ', num2str(20*log(A_v_dc)/log(10)), ' dB'])
A_v_dc_2
disp(['DC Gain 2 = ', num2str(A_v_dc_2), ' = ', num2str(20*log(A_v_dc_2)/log(10)), ' dB'])
disp(['DC PSRR = ', num2str(PSRR_dc), ' = ', num2str(20*log(PSRR_dc)/log(10)), ' dB'])

GBWP = 2.051e3* 199.4;
disp(['GBWP = ', num2str(GBWP/10^6), ' MHz'])


```

注：事实上，我们在数据处理时， phase 项少加了一个负号，在实验报告的图片中已修正这个错误。

## 结果汇总
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-28-18-28-52_Op Amp Measurement of Discrete uA741.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-28-18-28-39_Op Amp Measurement of Discrete uA741.png"/></div>