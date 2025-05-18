# Basic Op Amp Measurement Board v2

> [!Note|style:callout|label:Infor]
Initially published at 23:43 on 2025-04-22 in Beijing.

## Infor

本板是 [Basic Op Amp Measurement Board](<ElectronicDesigns/Basic Op Amp Measurement Board.md>) 的改进，用于测量运算放大器包括失调电压 $V_{IO}$、偏置电流 $I_{B\pm}$、开环增益 $A_{OL}$ 在内的 8 种运放基本参数（低频增益的精确测量, SR 和小信号输入输出阻抗的测量另做一板来实现）。

- Time: 2025.04.22
- Notes: 可以直接测量运放输入失调电压 $V_{IO}$、正负输入偏置电流 $I_{B\pm}$、 DC/AC 开环增益 $A_{OL}$、 DC/AC CMRR 、 DC/AC PSRR 共 8 种运放基本参数 (DC/AC 算两种)
- Details: 全部测试结果都汇总在 [The Collection of My Measurement Experiments](<Electronics/The Collection of My Measurement Experiments.md>)
- Relevant Resources: 测量原理 [Blog > *Op Amp Measurement Methods*](<Electronics/Op Amp Measurement Methods.md>)，相关资料在 [https://www.123684.com/s/0y0pTd-HsUj3](https://www.123684.com/s/0y0pTd-HsUj3)







<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-22-23-50-12_Basic Op Amp Measurement Board v2.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-22-23-49-19_Basic Op Amp Measurement Board v2.png"/></div> |
</div>

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-22-23-50-30_Basic Op Amp Measurement Board v2.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-22-23-50-46_Basic Op Amp Measurement Board v2.png"/></div> |
</div>

<div class='center'>

| Demo (top view) | 
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-15-57-32_Basic Op Amp Measurement Board v2.png"/></div> |
</div>

## Measurement Steps

- Reset all the switches;
- Connect the DUT (device under test) and AUX (auxiliary op amp);
- Connect power supply to the DUT and AUX;
- Connect [AD1](https://digilent.com/reference/test-and-measurement/analog-discovery/start).

<div class='center'>

| Switch | SW1 | SW2 | SW3 | IN1+ (CH1) | IN2+ (CH2) | SW6 | WP | DUTVCC |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | **Initial state** | `0R` | `0R` | `0 OFF` | `TP1` | `TP2` | `0 10K` | `W12` | `WP+-` or `AUX+-`  |

</div>

Note that if `DUTVCC` is connected to `WP+-`, the DUT is powered by the isolated supply, which is connected at the pin header of DUT. By contrast, if `DUTVCC` is connected to `AUX+-`, then DUT and AUX share the same power supply, i.e., the supply at the pin header of AUX.

Then, we can start the measurement:

<div class='center'> <span style='color:red'>

**Assuming we reset all switches before measuring each parameter.**
</span></div>

<!-- <div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-00-37-00_Basic Op Amp Measurement Board.png"/></div>
 -->
<div class='center'>

| Num | Parameter | Steps | Formula |
|:-:|:-:|:-:|:-:|
 | 1 | $V_{IO}$ |record $V_{TP1}$ | $V_{IO} = \frac{V_{TP1}}{1001}$  | 
 | 2 | $I_{B\pm}$ |S2 `0R`, S1 from `0R` to `R7`, write $(\Delta V_{TP1})_{1}$ <br> S1 `0R`, S2 from `0R` to `R6`, write $(\Delta V_{TP1})_{2}$ | $I_{B-} = - \frac{(\Delta V_{TP1})_1}{1001\,R7}$ <br> $I_{B+} = +\frac{(\Delta V_{TP1})_2}{1001\,R6}$ | - |
 | 3 | DC Gain | S6 from `0 10K` to `1 +1V`, write $\Delta V_{TP2}$ and $\Delta V_{TP1}$ | $A_{OL} = \frac{1001\, \Delta V_{TP2}}{\Delta V_{TP1}}$  | - |
 | 4 | AC Gain | S4 to `R9`, 'AD1 Impedance' inputs ac signal (500Hz ~ 5MHz), measure $v_{TH2}$ | $A_{OL} = \left(1 + \frac{R_9}{R_1}\right)\cdot \frac{v_{TP2, amp}}{v_{IN, amp}}$ |  |  |
 | 5 | DC CMRR |W1 and W2 from ±4V to +5V and -3V, write $\Delta V_{TP1}$ | $\mathrm{CMRR} = \frac{1001\, \Delta V_{CM}}{\Delta V_{TP1}}$ |
 | 6 | DC PSRR |W1 and W2 from ±4V to ±12V (or ±5V), write $\Delta V_{TP1}$ | $\mathrm{PSRR} = \frac{1001\, \Delta V_{PS,total}}{\Delta V_{TP1}}$ |
 | 7 | AC CMRR | <span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = 0}}$ and measure $v_{TP1, amp}$ | $\mathrm{CMRR} = \frac{1001\, v_{W1, amp}}{v_{TP1,amp}}$ |
 | 8 | AC PSRR |<span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = \pi}}$ and measure $v_{TP1, amp}$ | $\mathrm{CMRR} = \frac{2002\, v_{W1, amp}}{v_{TP1,amp}}$ |

</div>

