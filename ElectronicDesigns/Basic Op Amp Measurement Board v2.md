# Basic Op Amp Measurement Board v2

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 23:43 on 2025-04-22 in Beijing.

## Infor

本板是 [Basic Op Amp Measurement Board](<ElectronicDesigns/Basic Op Amp Measurement Board.md>) 的改进，用于测量运算放大器包括失调电压 $V_{IO}$、偏置电流 $I_{B\pm}$、开环增益 $A_{OL}$ 在内的 8 种运放基本参数（低频增益的精确测量, SR 和小信号输入输出阻抗的测量另做一板来实现）。

- Time: 2025.04.22
- Notes: 可以直接测量运放输入失调电压 $V_{IO}$、正负输入偏置电流 $I_{B\pm}$、 DC/AC 开环增益 $A_{OL}$、 DC/AC CMRR 、 DC/AC PSRR 共 8 种运放基本参数 (DC/AC 算两种)
- Details: 全部测试结果都汇总在 [The Collection of My Measurement Experiments](<Electronics/The Collection of My Measurement Experiments.md>)
- Relevant Resources: [https://www.123684.com/s/0y0pTd-HsUj3](https://www.123684.com/s/0y0pTd-HsUj3)







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
 | 2 | $I_{B\pm}$ |S2 `0R`, S1 from `0R` to `R7`, write $(\Delta V_{TP1})_{1}$ <br> S1 `0R`, S2 from `0R` to `R6`, write $(\Delta V_{TP1})_{2}$ | $I_{B-} = - \frac{(\Delta V_{TP1})_1}{1001\,R7}$ <br> $I_{B+} = +\frac{(\Delta V_{TP1})_2}{1001\,R6}$ |
 | 3 | DC Gain | S6 from `0 10K` to `1 +1V`, write $\Delta V_{TP2}$ and $\Delta V_{TP1}$ | $A_{OL} = \frac{1001\, \Delta V_{TP2}}{\Delta V_{TP1}}$  | - |
 | 4 | AC Gain | S4 to `R9`, 'AD1 Impedance' inputs ac signal (10Hz ~ 1MHz), measure $v_{TH2}$ | $A_{OL} = \left(1 + \frac{R_9}{R_1} + \frac{1}{j 2 \pi f R_1 C_3}\right) \times \left(- \frac{v_{TP2}}{v_{acin}}\right)$ |
 | 5 | DC CMRR |W1 and W2 from ±4V to +5V and -3V, write $\Delta V_{TP1}$ | $\mathrm{CMRR} = \frac{1001\, \Delta V_{CM}}{\Delta V_{TP1}}$ |
 | 6 | DC PSRR |W1 and W2 from ±4V to ±12V (or ±5V), write $\Delta V_{TP1}$ | $\mathrm{PSRR} = \frac{1001\, \Delta V_{PS,total}}{\Delta V_{TP1}}$ |
 | 7 | AC CMRR | <span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = 0}}$ and measure $v_{TP1, amp}$ | $\mathrm{CMRR} = \left(101 + \frac{10^5}{j\, 2 \pi f}\right) \times \left(- \frac{v_{W1}}{v_{TP2}}\right)$ |
 | 8 | AC PSRR |<span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), ${\color{red}{\Delta \varphi = \pi}}$ and measure $v_{TP1, amp}$ | $\mathrm{PSRR} = \left(202 + \frac{2\times 10^5}{j \, 2\pi f}\right) \times \left(\frac{v_{W1}}{v_{TP2}}\right)$ |

</div>



- 2025.05.28 注: 发现 AC CMRR 和 PSRR 的计算公式有误，将 $\mathrm{CMRR} = \frac{1001\, v_{W1, amp}}{v_{TP1,amp}}$ 修正为 $\mathrm{CMRR} = \left(101 + \frac{10^5}{j\, 2 \pi f}\right) \times \left(- \frac{v_{W1}}{v_{TP2}}\right)$, 将 $\mathrm{PSRR} = \frac{2002\, v_{W1, amp}}{v_{TP1,amp}}$ 修正为 $\mathrm{PSRR} = \left(202 + \frac{2\times 10^5}{j \, 2\pi f}\right) \times \left(\frac{v_{W1}}{v_{TP2}}\right)$, 但 v1 中的公式暂未修正。


## Formula Derivations

此部分参考文章 [Op Amp Measurement Methods](<Electronics/Op Amp Measurement Methods.md>), 后文中的小写字母都表示小信号量，或者说带有幅值和相位的交流量。

### AC Gain 

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-28-16-11-03_Basic Op Amp Measurement Board v2.png"/></div>

$$
\begin{gather}
\begin{cases}
v_{out} = v_{TP2} = A_v v_{eff}
\\
v_{eff} = 0 - \frac{R_1}{R_1 + R_9 + \frac{1}{j \omega C_3}} \cdot  v_{acin} 
\end{cases}
\Longrightarrow 
\\
\boxed{
A_{v} 
    = \frac{R_1 + R_9 + \frac{1}{j\omega C_3}}{R_1}\times \left(- \frac{v_{out}}{v_{acin}}\right) 
    = \left(1 + \frac{R_9}{R_1} + \frac{1}{j 2 \pi f R_1 C_3}\right) \times \left(- \frac{v_{TP2}}{v_{acin}}\right)
}
\\
|A_v| = \left|\frac{v_{TP2}}{v_{acin}}\right| \times \left|1 + \frac{R_9}{R_1} + \frac{1}{j 2 \pi f R_1 C_3}\right| = \left|\frac{v_{TP2}}{v_{acin}}\right| \times \sqrt{\left(1 + \frac{R_9}{R_1}\right)^2 + \frac{1}{(2 \pi f R_1 C_3)^2}}
\end{gather}
$$

For instance, if using `1nF + 1MOhm` or `10nF + 51kOhm`, we have:

$$
\begin{gather}
\mathrm{1\ nF\ +\ 1\ M\Omega} 
\Longrightarrow  
A_v = \left(10001 + \frac{10^7}{j 2\pi f} \right)\times \left(- \frac{v_{TP2}}{v_{acin}}\right)
,\quad 
|A_v| = \sqrt{10001^2 + \left(\frac{10^7}{2 \pi f}\right)^2} \times \left|\frac{v_{TP2}}{v_{acin}}\right|
\\
\mathrm{10\ nF\ +\ 51\ k\Omega} \Longrightarrow  
A_v = \left(511 + \frac{10^6}{j 2\pi f} \right)\times \left(- \frac{v_{TP2}}{v_{acin}}\right)
,\quad 
|A_v| = \sqrt{511^2 + \left(\frac{10^6}{2 \pi f}\right)^2} \times \left|\frac{v_{TP2}}{v_{acin}}\right|
\end{gather}
$$

See [Correction of the AC Gain Equation in ADI's Op Amp Measurement Methods](<Electronics/Correction of the AC Gain Equation in the ADI Op Amp Measurement Methods.md>) for more details.

### AC CMRR

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-28-01-28-21_Basic Op Amp Measurement Board v2.png"/></div>

$$
\begin{gather}
\begin{cases}
\mathrm{CMRR}  = \frac{A_{DM-DM}}{A_{CM-DM}} = \frac{\frac{A_v \Delta V_{in,DM}}{ \Delta V_{in,DM}}}{\frac{A_v \Delta V_{OS}}{\Delta V_{CM}}} = \frac{\Delta V_{CM}}{\Delta V_{OS}}
\\
v_{W1} = v_{W2} \Longrightarrow \Delta V_{CM} =  v_{CM} = - v_{W1}
\\
\Delta V_{OS} = v_{OS} = \frac{v_{out}}{1 + \frac{R_8}{R_1} + \frac{1}{j\omega R_1 C_2}} = \frac{v_{TP2}}{101 + \frac{10^5}{j\omega}}
\end{cases}
\\
\Longrightarrow 
\boxed{
\mathrm{CMRR} 
    = \frac{- v_{W1}}{\frac{v_{TP2}}{101 + \frac{10^5}{j\omega}}}
    = \left(101 + \frac{10^5}{j\, 2 \pi f}\right) \times \left(- \frac{v_{W1}}{v_{TP2}}\right)
}
,\quad |\mathrm{CMRR}| = \left|101 + \frac{10^5}{j \, 2 \pi f}\right| \times \left|\frac{v_{W1}}{v_{TP2}}\right|
\end{gather}
$$

Note that we used 10 kOhm for R8 and 100 Ohm for R1 so the ratio is 101 instead of 100. The approximate formula is given by setting $|Z_{C2,\mathrm{100 nF @ 1kHz}}| = 1.59 \ \mathrm{k}\Omega \approx 0$:

$$
\begin{gather}
\begin{cases}
\mathrm{CMRR} = \frac{A_{DM-DM}}{A_{CM-DM}} = \frac{\frac{A_v \Delta V_{in,DM}}{ \Delta V_{in,DM}}}{\frac{A_v \Delta V_{OS}}{\Delta V_{CM}}} = \frac{\Delta V_{CM}}{\Delta V_{OS}}
\\
v_{W1} = v_{W2} \Longrightarrow \Delta V_{CM} =  v_{CM} = - v_{W1}
\\
\Delta V_{OS} = v_{OS} = \frac{-v_{out}}{1 + \frac{R_8}{R_1}} = \frac{- v_{TP2}}{101}
\end{cases}
\\
\Longrightarrow \mathrm{CMRR} \approx 101 \times \left(- \frac{v_{W1}}{v_{TP2}}\right),\quad |\mathrm{CMRR}| \approx 101 \times \left|\frac{v_{W1}}{v_{TP2}}\right|
\end{gather}
$$

### AC PSRR

Similar to the AC CMRR, we can derive the AC PSRR as follows:

$$
\begin{gather}
\begin{cases}
\mathrm{PSRR} = \frac{A_{DM-DM}}{A_{PS-DM}} = \frac{\frac{A_v \Delta V_{in,DM}}{ \Delta V_{in,DM}}}{\frac{A_v \Delta V_{OS}}{\Delta V_{S}}} = \frac{\Delta V_{S}}{\Delta V_{OS}}
\\
v_{W1} = v_{W2} \Longrightarrow \Delta V_{S} = v_{S} = 2 \,v_{W1}
\\
\Delta V_{OS} = v_{OS} = \frac{v_{TP2}}{101 + \frac{10^5}{j\omega}}
\end{cases}
\\
\Longrightarrow 
\boxed{
\mathrm{PSRR} 
    = \frac{2 \,v_{W1}}{\frac{v_{TP2}}{101 + \frac{10^5}{j\omega}}} 
    = \left(202 + \frac{2\times 10^5}{j \, 2\pi f}\right) \times \left(\frac{v_{W1}}{v_{TP2}}\right)
}
,\quad 
|\mathrm{PSRR}| = \left|202 + \frac{2\times 10^5}{j \, 2\pi f}\right| \times \left|\frac{v_{W1}}{v_{TP2}}\right|
\end{gather}
$$



## WaveForms Codes

!> **<span style='color:red'>Attention:</span>**<br>
若无特别说明，下面的代码均默认在 WaveForms > `Impedance` > `Mode 3: W1-C1P-DUT-C1N-C2-R-GND` 下运行。

参考文章 [Electronics/WaveForms Insight](<Electronics/WaveForms Insight.md>)，代码背后的公式及其推导过程见上一小节。

### Input and Output Voltages

**<span style='color:red'> 测试结果表明, `|V_TP2| = IRMS*Resistor*sqrt(2)` 仅在 Resistor 较小的时候成立。 </span>** 具体而言, Resistor = 10 Ohm 时, `IRMS*Resistor ≈ |V_TP2|`, Resistor = 1 MOhm 时, `IRMS*Resistor ≈ 2*|V_TP2|`。因此，实际使用时，为避免测量误差，**<span style='color:red'> 应设置 Resistor = 10 kOhm </span>**

``` bash
# WaveForms > `Impedance` > `Mode 3: W1-C1P-DUT-C1N-C2-R-GND`

|V_TP1| = |CH1| = V_DUT = VRMS*sqrt(2)  # |V_TP1|
|V_TP2| = |CH2| = IRMS*Resistor*sqrt(2) # |V_TP2|
phase = phase_Vout - phase_Vin = phase_CH2 - phase_CH1 = - InputPhase # output phase shift, 注意有负号!
```


### AC Gain using 51kOhm

`AC INPUT (WP)` 按钮调至 `R9 50K` 时：
``` bash
# AC Gain, using 10nF + 51kOhm, CH1 = AC_input, CH2 = TP2:

# A_v_AC_abs (unit: V/V)
sqrt(511*511+pow(10, 12)/pow(2*PI*Frequency, 2)) * (IRMS*Resistor/VRMS)
# A_v_AC_dB (unit: dB)
20*log10(  sqrt(511*511+pow(10, 12)/pow(2*PI*Frequency, 2)) * (IRMS*Resistor/VRMS)  )
```

### AC Gain using 1MOhm


`AC INPUT (WP)` 按钮调至 `R99 1M` 时：
``` bash
# AC Gain, using 1nF + 1MOhm, CH1 = AC_input, CH2 = TP2:

# A_v_AC_abs (unit: V/V)
sqrt(10001*10001+pow(10, 14)/pow(2*PI*Frequency, 2)) * (IRMS*Resistor/VRMS)
# A_v_AC_dB (unit: dB)
20*log10(  sqrt(10001*10001+pow(10, 14)/pow(2*PI*Frequency, 2)) * (IRMS*Resistor/VRMS)  )
```

### AC CMRR

``` bash
# AC CMRR, using 100nF + 10kOhm, CH1 = V_W1, CH2 = TP2

# AC CMRR (unit: V/V)
sqrt(101*101 + pow(10, 10)/pow(2*PI*Frequency, 2)) * VRMS/(IRMS*Resistor)
# AC CMRR (unit: dB)
20*log10(sqrt(101*101 + pow(10, 10)/pow(2*PI*Frequency, 2)) * VRMS/(IRMS*Resistor))
```


### AC PSRR 

``` bash
# AC PSRR, using 100nF + 10kOhm, 

# AC PSRR (unit: V/V)
  2  *  sqrt(101*101 + pow(10, 10)/pow(2*PI*Frequency, 2)) * VRMS/(IRMS*Resistor)
# AC PSRR (unit: dB)
  20*log10(2  *  sqrt(101*101 + pow(10, 10)/pow(2*PI*Frequency, 2)) * VRMS/(IRMS*Resistor))
```


## MATLAB Codes

下面是数据处理所用的 MATLAB 代码，供参考。

``` matlab
%% AC Gain 数据处理

% 导入数据
clc, clear, close all
data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[op amp] ac gain, discrete uA741, input 1 Vamp, 10 nF + 51 kOhm.txt");
V_in_abs = data(:, 4)';     % AC INPUT, 为参考相位
V_out_abs = data(:, 5)';    % TP2
f = data(:, 1)';
InputPhase = data(:, 2)';
V_out_phase = - InputPhase;

% 先对数据后半段重点滤波
index = 360:length(f);
window = 20;
InputPhase(index) = MyFilter_mean(InputPhase(index), window);
V_in_abs(index) = MyFilter_mean(V_in_abs(index), window);
V_out_phase(index) = MyFilter_mean(V_out_phase(index), window);


% 再对数据整体进行滤波
window = 3;
InputPhase = MyFilter_mean(InputPhase, window);
V_in_abs = MyFilter_mean(V_in_abs, window);
V_out_phase = MyFilter_mean(V_out_phase, window);

% 选择所使用的电容和电阻
if 1 % 51 kOhm + 10 nF
    R_9 = 51e3;
    C_3 = 10e-8;
end
if 0 % 1 MOhm + 1 nF
    R_9 = 1e6;
    C_3 = 1e-9;
end

% 将模长和相位转化为复数表达
R_1 = 100;
v_acin = V_in_abs;
v_TP2 = V_out_abs .* (cosd(V_out_phase) + 1j*sind(V_out_phase));
%v_TP2'
%MyArcTheta_complex_rad(v_TP2)'
%test = atand(real(v_TP2)./imag(v_TP2)) - 180

% 作出 A_v 波特图
A_v = ( 1 + R_9/R_1 + 1./(1j*2*pi.*f*R_1*C_3) ) .* (- v_TP2./v_acin);
A_v_abs = abs(A_v);
A_v_dB = 20*log(A_v_abs)/log(10);
A_v_phase = MyArcTheta_complex_deg(A_v) - 360;
stc = MyYYPlot(f, f, A_v_dB, A_v_phase);
stc.axes.XScale = 'log';

% 调整图像属性
ylim([0 80])
xlim([2e2, 2e5])
stc.axes.XTick = [2e2, 1e3, 2e3, 1e4, 2e4, 1e5, 2e5];
stc.axes.XTickLabel = ["200 Hz", "1 kHz", "2 kHz", "10 kHz", "20 kHz", "100 kHz", "200 kHz"];
yyaxis('right');
ylim([-180 0])
YTick = -180:22.5:0;
stc.axes.YTick = YTick;
stc.axes.YTickLabel =  num2str(YTick', '%.1f');
stc.axes.XScale = 'log';
stc.leg.String = ["Gain $A_v$ (dB)"; "Phase $\varphi\ (^\circ)$"];
stc.label.x.String = 'Frequency $f$';
stc.label.y_left.String = 'Open-Loop Small-Signal Gain $A_v$ (dB)';
stc.label.y_right.String = 'Output Phase Shift $\varphi\ (^\circ)$';

% 导出图像
%MyFigure_ChangeSize_2048x512
%MyExport_pdf
```
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-28-18-22-59_Basic Op Amp Measurement Board v2.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-28-18-20-41_Basic Op Amp Measurement Board v2.png"/></div>