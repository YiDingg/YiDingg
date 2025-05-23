# Op Amp Measurement of LM412CN.md


> [!Note|style:callout|label:Infor]
> Initially published at 09:31 on 2025-03-15 in Beijing.

## 实验记录

测量实验汇总: [The Collection of My Measurement Experiments](<Electronics/The Collection of My Measurement Experiments.md>)

- Time: 2025.04.13 
- Location: Beijing
- Auxiliary device (辅助运放): NE5532DR (absolute max supply range: ±22V or 44V)
- Device under test (待测运放): [TI: LM412CN](<https://www.ti.com/cn/lit/ds/symlink/lf412-n.pdf?ts=1747371346599&ref_url=https%253A%252F%252Fso.szlcsc.com%252F>) (absolute max supply range: ±18V or 36V)
- Measurement board (测试板): [Basic Op Amp Measurement Board v2](<ElectronicDesigns/Basic Op Amp Measurement Board v2.md>)
- AUX: 始终由直流电源供电 (±12V)
- DUT: 除了测试 AC CMRR 和 AC PSRR 时, DUT 的供电由信号发生器提供 (不超过 [-5V, +5V]), 其它参数测试时, DUT 均由直流电源供电 (±12V, 与 AUX 供电相同)。


<div class='center'>

| 测试板 ([Basic Op Amp Measurement Board v2](<ElectronicDesigns/Basic Op Amp Measurement Board v2.md>)) (序列号 0001) | 待测运放 ([TI: LM412CN](<https://www.ti.com/cn/lit/ds/symlink/lf412-n.pdf?ts=1747371346599&ref_url=https%253A%252F%252Fso.szlcsc.com%252F>)) |
|:-:|:-:|
 |  |  
</div>








各开关初始状态如下:
<div class='center'>

| Switch | SW1 | SW2 | SW3 | IN1+ (CH1) | IN2+ (CH2) | SW6 | AC INPUT | WP | DUTVCC |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | **Initial state** | `0R` | `0R` | `0 OFF` | `TP1` | `TP2` | `0 10K` | `NC` | `W12` | `WP+-` or `AUX+-`  |

</div>









实验备注：
- 第一步测量 $V_{IO}$ 时，CH1 (TP1) 多在几十至几百毫伏, CH2 (TP2) 多在几伏至几十毫伏
- 第三步测量 DC Gain 时，CH1 (TP1) 多在几十毫伏, CH2 (TP2) 多在几伏









实验记录如下：
<div class='center'>

| Data Num | Parameter | Steps | Formula | Figure |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | $V_{IO}$ |record $V_{TP1}$ | $V_{IO} = \frac{V_{TP1}}{1001}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-18-51-04_Op Amp Measurement of Discrete uA741.png"/></div> |
 | 2 | $I_{B\pm}$ |S2 `0R`, S1 from `0R` to `R7`, write $(\Delta V_{TP1})_{1}$ <br> S1 `0R`, S2 from `0R` to `R6`, write $(\Delta V_{TP1})_{2}$ | $I_{B-} = - \frac{(\Delta V_{TP1})_1}{1001\,R7}$ <br> $I_{B+} = +\frac{(\Delta V_{TP1})_2}{1001\,R6}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-18-55-06_Op Amp Measurement of Discrete uA741.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-18-55-57_Op Amp Measurement of Discrete uA741.png"/></div> |
 | 3 | DC Gain | S6 from `0 10K` to `1 +1V`, write $\Delta V_{TP2}$ and $\Delta V_{TP1}$ | $A_{OL} = \frac{1001\, \Delta V_{TP2}}{\Delta V_{TP1}}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-16-18-58-44_Op Amp Measurement of Discrete uA741.png"/></div> |
 | 5 | DC CMRR |W1 and W2 from ±4V to +5V and -3V, write $\Delta V_{TP1}$, $\Delta V_{CM} = \frac{\Delta V_{CC+} + \Delta V_{CC-}}{2}$ | $\mathrm{CMRR} = \frac{1001\, \Delta V_{CM}}{\Delta V_{TP1}}$ |  |
 | 6 | DC PSRR |W1 and W2 from ±4V to ±12V (or ±5V), write $\Delta V_{TP1}$ | $\mathrm{PSRR} = \frac{1001\, \Delta V_{PS,total}}{\Delta V_{TP1}}$ |  |
 | 4 | AC Gain | S4 to `R9`, **AD1 Impedance** inputs ac signal (50Hz ~ 5MHz), measure $v_{TP2}$ | $A_{OL} = \left(1 + \frac{\frac{1}{2\pi f C_{in}} + R_9}{R_1}\right)\cdot \left(- \frac{v_{TP2, amp}}{v_{IN, amp}}\right)$ |  |
 | 7 | AC CMRR | <span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = 0}}$ and measure $v_{TP2, amp}$ | $\mathrm{CMRR} = \frac{10001\, V_{W1, \mathrm{amp}}}{V_{TP2, \mathrm{amp}}}$ |  |
 | 8 | AC PSRR |<span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = \pi}}$ and measure $v_{TP2, amp}$ | $\mathrm{PSRR} = \frac{20002\, V_{W1, \mathrm{amp}}}{V_{TP2, \mathrm{amp}}}$ |  |

</div>

