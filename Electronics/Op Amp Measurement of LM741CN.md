# Op Amp Measurement of LM741CN

> [!Note|style:callout|label:Infor]
> Initially published at 14:01 on 2025-05-30 in Beijing.

## 实验记录

### 基本信息

- Time: 2025.05.30 
- Location: Beijing
- Auxiliary device (辅助运放): [LF412CN](https://www.ti.com/cn/lit/ds/symlink/lf412-n.pdf?ts=1748586410585&ref_url=https%253A%252F%252Fitem.szlcsc.com%252F)
- Device under test (待测运放): [LM741CN](https://www.ti.com/cn/lit/ds/symlink/lm741.pdf?ts=1748585151142&ref_url=https%253A%252F%252Fitem.szlcsc.com%252F)
- Measurement board (测试板): [Basic Op Amp Measurement Board v2](<ElectronicDesigns/Basic Op Amp Measurement Board v2.md>)
- AUX: 始终由直流电源供电 (VCC = ± 12 V)
- DUT: 多数情况下 DUT 均由 AUXVCC 供电 (与 AUX 供电相同)，只有在测试 AC CMRR 和 AC PSRR 时, DUT 的供电由 [-5V, +5V] 的信号发生器提供


<div class='center'>

| 测试板 [Basic Op Amp Measurement Board v2](<ElectronicDesigns/Basic Op Amp Measurement Board v2.md>) | 辅助板 [Voltage Linear Operation Board](<ElectronicDesigns/Voltage Linear Operation Board.md>) | 待测运放 [LM741CN](https://www.ti.com/cn/lit/ds/symlink/lm741.pdf?ts=1748585151142&ref_url=https%253A%252F%252Fitem.szlcsc.com%252F) |
|:-:|:-:|:-:|
 | <div class="center"><img height=300px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-14-14-06_Op Amp Measurement of LM741CN.png"/></div> | <div class="center"><img height=300px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-14-14-19_Op Amp Measurement of LM741CN.png"/></div> | <div class="center"><img height=300px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-14-15-05_Op Amp Measurement of LM741CN.png"/></div> |
</div>


各开关初始状态如下:
<div class='center'>

| Switch | SW1 | SW2 | SW3 | IN1+ (CH1) | IN2+ (CH2) | SW6 | AC INPUT | WP | DUTVCC |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | **Initial state** | `0R` | `0R` | `0 OFF` | `TP1` | `TP2` | `0 10K` | `NC` | `W12` |  `AUX+-` |

</div>

实验备注：
- **<span style='color:red'> 开始实验前，应先给电路板供电，使运放处于工作状态，然后静置一段时间，使电路漂移尽量稳定，再进行测量实验 </span>**
- 第一步测量 $V_{IO}$ 时，CH1 (TP1) 多在 100mV ~ 5V, CH2 (TP2) 多在 5mV ~ 50mV
- 第三步测量 DC Gain 时，CH1 (TP1) 多在 10mV ~ 500 mV, CH2 (TP2) 多在 1V ~ 10V, 且两者增减方向相同
- 测量 AC Gain 时，对 DC Gain < 80 dB 的运放，使用 10 nF + 51kOhm; 对 DC Gain > 80 dB 的运放，使用 1 nF + 1MOhm

### 实验记录 1 

实验记录如下：
<div class='center'>

| Data Num | Parameter | Steps | Formula | Figure |
|:-:|:-:|:-:|:-:|:-:|
 | 0 | 示波器校准 | CH1 和 CH2 接地，测量示波器 dc 偏移量，最后数据处理时去除这部分偏移 | $V_{CH1, cor} = V_{CH1} - V_{CH1, 0}$ <br> $V_{CH2, cor} = V_{CH2} - V_{CH2, 0}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-14-48-50_Op Amp Measurement of LM741CN.png"/></div> |
 | 1 | $V_{IO}$ |record $V_{TP1}$ | $V_{IO} = \frac{V_{TP1}}{1001}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-15-06-10_Op Amp Measurement of LM741CN.png"/></div> |
 | 2.1 | $I_{B-}\ \ (R_7)$ |S2 `0R`, S1 from `0R` to `R7`, write $(\Delta V_{TP1})_{1}$ <br> S1 `0R`, S2 from `0R` to `R6`, write $(\Delta V_{TP1})_{2}$ | $I_{B-} = - \frac{(\Delta V_{TP1})_1}{1001\,R7}$ <br> $I_{B+} = +\frac{(\Delta V_{TP1})_2}{1001\,R6}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-15-12-21_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-15-13-07_Op Amp Measurement of LM741CN.png"/></div>  |
 | 2.2 | $I_{B+}\ \ (R_6)$ |S2 `0R`, S1 from `0R` to `R7`, write $(\Delta V_{TP1})_{1}$ <br> S1 `0R`, S2 from `0R` to `R6`, write $(\Delta V_{TP1})_{2}$ | $I_{B-} = - \frac{(\Delta V_{TP1})_1}{1001\,R7}$ <br> $I_{B+} = +\frac{(\Delta V_{TP1})_2}{1001\,R6}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-15-13-38_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-15-14-11_Op Amp Measurement of LM741CN.png"/></div> |
 | 3.1 | DC Gain (1) | S6 from `0 10K` to `1 +1V`, write $\Delta V_{TP2}$ and $\Delta V_{TP1}$ | $A_{OL} = \frac{1001\, \Delta V_{TP2}}{\Delta V_{TP1}}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-14-48-50_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-15-07-12_Op Amp Measurement of LM741CN.png"/></div>   |
 | 3.2 | DC Gain (2) | S6 from `0 10K` to `1 +1V`, write $\Delta V_{TP2}$ and $\Delta V_{TP1}$ | $A_{OL} = \frac{1001\, \Delta V_{TP2}}{\Delta V_{TP1}}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-15-09-49_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-15-10-29_Op Amp Measurement of LM741CN.png"/></div> |
 | 4 | AC Gain | S4 to `R9`, **AD1 Impedance** inputs ac signal (100Hz ~ 1MHz), measure $v_{TP2}$ | $A_{OL} = \left(1 + \frac{R_9}{R_1} + \frac{1}{j 2 \pi f R_1 C_3}\right) \times \left(- \frac{v_{TP2}}{v_{acin}}\right)$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-15-22-30_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-15-38-42_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-15-51-40_Op Amp Measurement of LM741CN.png"/></div> |
 | 6 | DC PSRR (先测量这个) |W1 and W2 from ±4V to ±12V (or ±5V), write $\Delta V_{TP1}$ | $\mathrm{PSRR} = \frac{1001\, \Delta V_{PS,total}}{\Delta V_{TP1}}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-16-10-14_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-16-11-38_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-16-12-29_Op Amp Measurement of LM741CN.png"/></div> |
 | 5.1 | DC CMRR | ±AUXVCC from ±12V to +15V and -9V, write $\Delta V_{TP1}$, $\Delta V_{CM} = \frac{\Delta V_{CC+} + \Delta V_{CC-}}{2}$ | $\mathrm{CMRR} = \frac{1001\, \Delta V_{CM}}{\Delta V_{TP1}}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-16-01-25_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-16-03-14_Op Amp Measurement of LM741CN.png"/></div>  |
 | 5.2 | DC CMRR | ±AUXVCC from ±12V to +15V and -9V, write $\Delta V_{TP1}$, $\Delta V_{CM} = \frac{\Delta V_{CC+} + \Delta V_{CC-}}{2}$ | $\mathrm{CMRR} = \frac{1001\, \Delta V_{CM}}{\Delta V_{TP1}}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-16-07-21_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-16-08-02_Op Amp Measurement of LM741CN.png"/></div>  |
 | 7 | AC CMRR <span style='color:red'> (ac coupling) </span> | <span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = 0}}$ and measure $v_{TP2, amp}$ |  $\mathrm{CMRR} = \left(101 + \frac{10^5}{j\, 2 \pi f}\right) \times \left(- \frac{v_{W1}}{v_{TP2}}\right)$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-16-30-03_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-16-56-27_Op Amp Measurement of LM741CN.png"/></div> |
 | 8 | AC PSRR |<span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = \pi}}$ and measure $v_{TP2, amp}$ <span style='color:red'> (ac coupling) </span> | $\mathrm{PSRR} = \left(202 + \frac{2\times 10^5}{j \, 2\pi f}\right) \times \left(\frac{v_{W1}}{v_{TP2}}\right)$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-17-11-53_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-17-17-17_Op Amp Measurement of LM741CN.png"/></div> |

</div>

**<span style='color:red'> 注：上面的 data num 7 (AC CMRR) 和 (AC PSRR), 不小心将 Resistor 设为了 1 MOhm, 此时 Vout 恰好是实际值的 2 倍, 我们将在后续的数据处理中修正这个失误。</span>**


### 实验记录 2

下面我们测量运放的摆率 $\mathrm{SR_{\pm}}$ 和全功率带宽 $f_p$ (理论值 $f_p = \frac{\mathrm{SR}}{2\pi V_{out,amp}}$). 将运放配置为 unit buffer (Vout 直接连接 Vin-), 进行以下测量:

<div class='center'>

| Data Num | Parameter | Steps | Formula | Figure |
|:-:|:-:|:-:|:-:|:-:|
 | 9 | SR+, SR- | <span style='color:red'> (dc coupling) </span> 输入方波，测量上升、下降速率 | $\mathrm{SR} = \frac{\Delta V_{out}}{\Delta t}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-17-32-02_Op Amp Measurement of LM741CN.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-17-34-04_Op Amp Measurement of LM741CN.png"/></div> |
 | 10 | $f_p$ | 输入正弦波，进行扫频，以输出幅度降低到 99% nominal amplitude 的频率为 $f_p$ | $f_p = f_{V_{out,amp} = 99\,\% \times V_0}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-17-50-05_Op Amp Measurement of LM741CN.png"/></div> |

</div>

## 数据处理

### DC 数据处理


``` matlab
%% 20250530 LM741CN DC 数据处理

%%% 运放测量板测量运放参数
R_7 = 3.9e3;
R_77 = 390e3;
R_6 = 3.9e3;
R_66 = 390e3;

%%% 实验数据处理

% 0. 示波器 dc 校准
V_CH1_0 = -6.154e-3;
V_CH2_0 = 7.863e-3;

% 1. Vos
Vos_TP1 = -420.55e-3;
Vos_TP2 = 19.709e-3;
Vos = (Vos_TP1 - V_CH1_0)/(1001);
disp(['Vos = ', num2str(Vos*1000), ' mV'])

% 2.1 Ib+ (R6) 
Ib_pos_DeltaTP1 = (-187.59e-3) - (-420.5e-3);
Ib_pos_Resistor = R_6;   % R_6 or R_66
Ib_pos = +(Ib_pos_DeltaTP1)/(1001*Ib_pos_Resistor);
disp(['Ib+ = ', num2str(Ib_pos*10^9), ' nA'])

% 2.2 Ib- (R7)
Ib_neg_DeltaTP1 = (-639.45e-3) - (-419.2e-3);
Ib_neg_Resistor = R_7;   % R_7 or R_77
Ib_neg = -(Ib_neg_DeltaTP1)/(1001*Ib_neg_Resistor);
disp(['Ib- = ', num2str(Ib_neg*10^9), ' nA'])

Ib = 0.5*(Ib_pos + Ib_neg);
Ib_os = 0.5*(Ib_pos - Ib_neg);
disp(['Ib    = ', num2str(Ib*10^9), ' nA'])
disp(['Ib_os = ', num2str(Ib_os*10^9), ' nA'])

% 3.1 DC Gain (1)
DC_Gain_1_DeltaTP1 = (-421.35e-3) - (Vos_TP1);
DC_Gain_1_DeltaTP2 = (-7.955) - (Vos_TP2);
Av_dc_1 = 1001*DC_Gain_1_DeltaTP2/DC_Gain_1_DeltaTP1;
disp(['DC Gain 1 = ', num2str(Av_dc_1, '%.2e'), ' = ', num2str(20*log(abs(Av_dc_1))/log(10)), ' dB'])

% 3.2 DC Gain (2)
DC_Gain_2_DeltaTP1 = (-419.65e-3) - (-420.35e-3);
DC_Gain_2_DeltaTP2 = (-7.956) - (20.194e-3);
Av_dc_2 = 1001*DC_Gain_2_DeltaTP2/DC_Gain_2_DeltaTP1;
disp(['DC Gain 2 = ', num2str(Av_dc_2, '%.2e'), ' = ', num2str(20*log(abs(Av_dc_2))/log(10)), ' dB'])

% DC PSRR
PSRR_DeltaVs = 2*(15 - 5);
PSRR_DeltaTP1 = (-445.7e-3) - (-364.14e-3);
PSRR = 1001*PSRR_DeltaVs/PSRR_DeltaTP1;
disp(['DC PSRR = ', num2str(PSRR), ' = ', num2str(20*log(abs(PSRR))/log(10)), ' dB'])

% DC CMRR (1)
CMRR_DeltaVcm = 0.5*(15 - 9) - 0.5*(12 - 12);
CMRR_DeltaTP1 = (-424.3e-3) - (-423.3e-3);
CMRR_1 = 1001*CMRR_DeltaVcm/CMRR_DeltaTP1;
disp(['DC CMRR = ', num2str(CMRR_1), ' = ', num2str(20*log(abs(CMRR_1))/log(10)), ' dB'])

% DC CMRR (2)
CMRR_DeltaVcm = 0.5*(15 - 9) - 0.5*(9 - 15);
CMRR_DeltaTP1 = (-425.05e-3) - (-423e-3);
CMRR_2 = 1001*CMRR_DeltaVcm/CMRR_DeltaTP1;
disp(['DC CMRR = ', num2str(CMRR_2), ' = ', num2str(20*log(abs(CMRR_2))/log(10)), ' dB'])

disp('----------------------------- LM741CN DC 参数汇总 -----------------------------')
disp(['Vos = ', num2str(Vos*1000), ' mV'])
disp(['Ib+ = ', num2str(Ib_pos*10^9), ' nA'])
disp(['Ib- = ', num2str(Ib_neg*10^9), ' nA'])
disp(['Ib- = ', num2str(Ib_neg*10^9), ' nA'])
disp(['Ib_os = ', num2str(Ib_os*10^9), ' nA'])
disp(['DC Gain (1) = ', num2str(Av_dc_1, '%.2e'), ' = ', num2str(20*log(abs(Av_dc_1))/log(10)), ' dB'])
disp(['DC Gain (2) = ', num2str(Av_dc_2, '%.2e'), ' = ', num2str(20*log(abs(Av_dc_2))/log(10)), ' dB'])
disp(['DC PSRR = ', num2str(PSRR), ' = ', num2str(20*log(abs(PSRR))/log(10)), ' dB'])
disp(['DC CMRR (1) = ', num2str(CMRR_1), ' = ', num2str(20*log(abs(CMRR_1))/log(10)), ' dB'])
disp(['DC CMRR (2) = ', num2str(CMRR_2), ' = ', num2str(20*log(abs(CMRR_2))/log(10)), ' dB'])
```


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-31-18-05-07_Op Amp Measurement of LM741CN.png"/></div>

### AC Gain 数据处理

``` bash
"D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, LM741CN, input 250 mVamp, 10 nF + 51 kOhm, 10 Hz to 1 MHz.txt"
"D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, LM741CN, input 1 Vamp, 10 nF + 51 kOhm, 100 Hz to 1 MHz.txt"
"D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, LM741CN, input 5 Vamp, 1 nF + 1 MOhm, 10 Hz to 100 kHz.txt"
"D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, LM741CN, input 5 Vamp, 1 nF + 1 MOhm, 100 Hz to 100 kHz.txt"
"D:\aa_MyExperimentData\Raw data backup\[op amp] LM741CN, Full Power Frequency, input 5Vamp, 100 Hz to 100 kHz.txt"
"D:\aa_MyExperimentData\Raw data backup\[op amp] LM741CN, PSRR, VCC = 4V + 1Vamp, 100 Hz to 100 kHz.txt"
"D:\aa_MyExperimentData\Raw data backup\[op amp] LM741CN, CMRR, VCC = 4V + 1Vamp, 100 Hz to 100 kHz.txt"
```


``` matlab
%% 20250530 LM741CN AC Gain 数据处理

clc, clear
data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, LM741CN, input 250 mVamp, 10 nF + 51 kOhm, 10 Hz to 1 MHz.txt");
stc1 = MyDataProcessor_OpAmp_ACGain_10Hzto1MHz(data, 1);

data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, LM741CN, input 1 Vamp, 10 nF + 51 kOhm, 100 Hz to 1 MHz.txt");
stc2 = MyDataProcessor_OpAmp_ACGain_10Hzto1MHz(data, 1);
stc2.axes.XLim(1) = 10;

data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, LM741CN, input 5 Vamp, 1 nF + 1 MOhm, 10 Hz to 100 kHz.txt");
stc3 = MyDataProcessor_OpAmp_ACGain_10Hzto1MHz(data, 0);

data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, LM741CN, input 5 Vamp, 1 nF + 1 MOhm, 100 Hz to 100 kHz.txt");
stc4 = MyDataProcessor_OpAmp_ACGain_10Hzto1MHz(data, 0);

X_1 = [stc1.f; stc2.f; stc3.f; stc4.f];
Y_1 = [stc1.A_v_dB; stc2.A_v_dB; stc3.A_v_dB; stc4.A_v_dB];
X_2 = X_1;
Y_2 = [stc1.A_v_phase; stc2.A_v_phase; stc3.A_v_phase; stc4.A_v_phase];

stc = MyPlot_2window(X_1, Y_1, X_2, Y_2, 1);

% 调整图像属性
stc.ax1.XScale = 'log';
stc.ax1.XTick = logspace(1, 6, 6);
stc.ax1.XTickLabel = ["10 Hz", "100 Hz", "1 kHz", "10 kHz", "100 kHz", "1 MHz"];
stc.ax1.YLim = [0 120];
%xlim([2e2, 2e5])

stc.ax2.XScale = 'log';
stc.ax2.XTick = logspace(1, 6, 6);
stc.ax1.XTickLabel = ["10 Hz", "100 Hz", "1 kHz", "10 kHz", "100 kHz", "1 MHz"];
stc.ax2.YLim = [-180 0]; YTick = -180:22.5:0;
stc.ax2.YTick = YTick;
stc.ax2.YTickLabel =  num2str(YTick', '%.1f');

stc.plot1.leg.String = [
    "10 nF + 51 kOhm, input 250 mVamp"
    "10 nF + 51 kOhm, input 1.0  Vamp"
    "1\,\,\, nF + 1 \,MOhm, input 4.0  Vamp"
    "1\,\,\, nF + 1 \,MOhm, input 5.0  Vamp"
    ];
stc.plot1.leg.Location = 'northeast';
stc.plot2.leg.String = [
    "10 nF + 51 kOhm, input 250 mVamp"
    "10 nF + 51 kOhm, input 1.0  Vamp"
    "1\,\,\, nF + 1 \,MOhm, input 4.0  Vamp"
    "1\,\,\, nF + 1 \,MOhm, input 5.0  Vamp"
    ];
stc.plot2.leg.Visible = 'on';
stc.plot2.leg.Location = 'northeast';

stc.plot1.label.x.String = 'Frequency $f$';
stc.plot1.label.y.String = 'Open-Loop Gain $A_v$ (dB)';
stc.plot2.label.x.String = 'Frequency $f$';
stc.plot2.label.y.String = 'Output Phase Shift $\varphi\ (^\circ)$';
MyFigure_ChangeSize(512*[2.5, 1]);
%MyFigure_ChangeSize_2048x512
%stc.fig.WindowStyle = 'modal';
%MyExport_pdf
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-31-18-04-49_Op Amp Measurement of LM741CN.png"/></div>

### AC CMRR 和 PSRR 数据处理

``` matlab
%% 20250530 LM741CN CMRR PSRR 数据处理
clc, clear
data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] LM741CN, CMRR, VCC = 4V + 1Vamp, 100 Hz to 100 kHz.txt");
data(:, 4) = 0.5*data(:, 4);
stc1 = MyDataProcessor_OpAmp_ACCMRR_100Hzto100kHz(data);
%stc1.leg.String = ["CMRR (dB)", "CMRR = 40 dB", "Phase"];
%MyExport_pdf_modal

data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] LM741CN, PSRR, VCC = 4V + 1Vamp, 100 Hz to 100 kHz.txt");
data(:, 4) = 0.5*data(:, 4);
stc2 = MyDataProcessor_OpAmp_ACPSRR_100Hzto100kHz(data);
%hold(stc2.axes, 'on')
%MyExport_pdf_modal

```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-31-18-50-16_Op Amp Measurement of LM741CN.png"/></div>

### SR 和 FPBW 数据处理

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-31-22-35-11_Op Amp Measurement of LM741CN.png"/></div>

## 测试结果汇总


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-31-20-21-30_Op Amp Measurement of LM741CN.png"/></div>
