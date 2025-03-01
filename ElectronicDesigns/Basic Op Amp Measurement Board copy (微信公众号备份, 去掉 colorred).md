# Basic Op Amp Measurement Board

## Infor


- Time: 2025.02.13
- Notes: suitable for [AD1](https://digilent.com/reference/test-and-measurement/analog-discovery/start) (Analog Discovery 1), [AD2](https://digilent.com/reference/test-and-measurement/analog-discovery-2/start), and [AD3](https://digilent.com/reference/test-and-measurement/analog-discovery-3/start)
- Details: 可以直接测量包括失调电压 $V_{IO}$、偏置电流 $I_{B\pm}$、开环增益 $A_{OL}$ 在内的 8 种运放基本参数 (详见后文)
- Relevant Resources: 原理 [Blog > *Op Amp Measurement Methods*](<Blogs/Electronics/Op Amp Measurement Methods.md>)，相关资料在 [https://www.123684.com/s/0y0pTd-ezuj3](https://www.123684.com/s/0y0pTd-ezuj3)


<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 |<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-14-07-05_Basic Op Amp Measurement Board.png"/></div>|<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-13-59-58_Basic Op Amp Measurement Board.png"/></div>|
</div>

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img height = 200px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-14-09-16_Basic Op Amp Measurement Board.png"/></div> | <div class="center"><img height = 200px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-14-09-32_Basic Op Amp Measurement Board.png"/></div> |
</div>

<!-- 
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-13-59-58_Basic Op Amp Measurement Board.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-14-07-05_Basic Op Amp Measurement Board.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-14-09-16_Basic Op Amp Measurement Board.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-14-09-32_Basic Op Amp Measurement Board.png"/></div> -->

## Usage

### Range and Accuracy


下面是本板可测量的参数范围及精度：
<div class='center'>

| Num | Parameters | Measurement Range | Accuracy | Note |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | $V_{IO}$ | $ \pm[20 \ \mathrm{uV}, 10\ \mathrm{mV}]$ | $\pm 10 \ \mathrm{uV}$ | - |
 | 2 | $I_{B\pm}$ | $ \pm [0.1 \ \mathrm{nA},\ 1000 \ \mathrm{nA}] $ | $\pm\, 10 \ \mathrm{uA}$ | - |
 | 3 | DC Gain | $\leqslant 2000 \ \mathrm{V/mV} \ (126 \ \mathrm{dB})$ | $\pm\, 3 \ \mathrm{dB}$ | - |
 | 4 | AC Gain | $\leqslant 100 \ \mathrm{V/mV} \ (100 \ \mathrm{dB})$ | $\pm\, 5 \ \mathrm{dB}$  | 500Hz ~ 5MHz |
 | 5 | DC CMRR | $\leqslant 100 \ \mathrm{V/mV} \ (100 \ \mathrm{dB})$ | $\pm\, 3 \ \mathrm{dB}$ | - |
 | 6 | DC PSRR | $\leqslant 1600 \ \mathrm{V/mV} \ (124 \ \mathrm{dB})$ | $\pm\, 3 \ \mathrm{dB}$ | - |
 | 7 | AC CMRR | $\leqslant 100\ \mathrm{V/mV} \ (100 \ \mathrm{dB})$ | $\pm\, 5 \ \mathrm{dB}$ | 500Hz ~ 5MHz |
 | 8 | AC PSRR | $\leqslant 200\ \mathrm{V/mV} \ (106 \ \mathrm{dB})$ | $\pm\, 5 \ \mathrm{dB}$ | 500Hz ~ 5MHz |
</div>

部分参数的测量范围可以超出上表所示，但是精度会有所下降（或者无法保证精度）。

### Measurement Steps

- Reset all the switches;
- Connect the DUT (device under test);
- Connect the $\pm 12 \ \mathrm{V}$ power supply;
- Connect [AD1](https://digilent.com/reference/test-and-measurement/analog-discovery/start), configure W1 and W2 to $\pm 4V$ (or $\pm 5V$) respectively;

<div class='center'>

| Switch | SW1 | SW2 | IN1+ | IN2+ | SW6 | DUTVCC | WP |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | **Initial state** | `0R` | `0R` | `TP2` | `TP1` | `0 10K` | `WP+-` | `W` or `P` |

</div>

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
 | 7 | AC CMRR | <span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset),   <span style='color:red'> $\Delta \varphi = 0$</span> and measure $v_{TP1, amp}$ | $\mathrm{CMRR} = \frac{1001\, v_{W1, amp}}{v_{TP1,amp}}$ |
 | 8 | AC PSRR |<span style='color:red'> S3 to 1</span>, configure W1 to sine wave (1V amplitude, +4V offset), W2 to sine wave (1V amplitude, -4V offset), <span style='color:red'> $\Delta \varphi = \pi$</span> and measure $v_{TP1, amp}$ | $\mathrm{CMRR} = \frac{2002\, v_{W1, amp}}{v_{TP1,amp}}$ |

</div>


## Design Notes

初始参考电路如图所示，其用法详见文章 [*Op Amp Measurement Methods*](<Blogs/Electronics/Op Amp Measurement Methods.md>)，现在我们来一步步实现电路图中的各项要求。
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-22-25-46_Basic Op Amp Measurement Board.png"/></div>


### AUX Op Amp Selection

在 $\pm 12V$ 的开关电源供电下，对于一般精度，LM358 或 NE5532 即可胜任测量任务；如果需要更高的精度，可以考虑 OP07CP 或者 AD797。刚好上面我们用到了一路反相比例放大器，刚好可以用一个 NE5532 的两路分别作为 Inverter 和 AUX Op Amp 。

### Resistance Selection

电路中的一些阻值是没有直接对应的 0603 电阻的（电阻本中拥有的阻值见下图），因此有必要对这些电阻进行调整：
- $R_3 = 99.9 \ \mathrm{K\Omega} \longrightarrow R_9 = 100 \ \mathrm{K\Omega}$
- $R_8 = 9.9 \ \mathrm{K\Omega} \longrightarrow R_9 = 10 \ \mathrm{K\Omega}$
- $R_9 = 999 \ \mathrm{K\Omega} \longrightarrow R_9 = 1 \ \mathrm{M\Omega}$

相应的，各参数的计算公式也需要做相应的修改，我们留到最后一并讨论。

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-22-48-17_Basic Op Amp Measurement Board.png"/></div>

电路中需要自行确定阻值的电阻有 $R_6$ 和 $R_7$ 两个，它们仅在 S1 (或 S2) 打开 (open, logic 0) 时起作用，用来测量 bias current $I_B$ 和 input offset current $I_{IO}$。考虑到一般的运放偏置电流在 10 nA ~ 100 nA，为了维持 $\Delta V_{TP2} = 1001 R_6I_{B+} $ 在几十 mV 至 1 V 之间，我们令 $R_6 = R_7 = 100 \ \Omega$。对于低偏置的运放，将其改为 $R_6 = R_7 = 10 \ \mathrm{K\Omega}$（用一个三档三脚开关来控制）。

除此之外，考虑到我们打算用 NE5532 来作为 AUX Op Amp，其输入失调电流还是比较大的，因此需要降低 $R_4$ 和 $R_5$ 的阻值以减小输入失调电流带来的误差。我们将其改为 $R_4 = R_5 = 20 \ \mathrm{K\Omega}$。

### Power Supply

DUT (device under test) 的供电，由于其变化灵活，我们考虑使用 [AD1](https://digilent.com/reference/test-and-measurement/analog-discovery/start) 的 Power Supply (for +V and -V) 和 Wave Generator (W1 和 W2 两通道 for else)。需要注意的是，[AD1](https://digilent.com/reference/test-and-measurement/analog-discovery/start) 的函数发生器输出功率只有大约 60mW ~ 120mW (per channel)，因此对于静态电流较大的运放，需要 AUX 电源（将 W1 和 W2 转为 P1 和 P2 供电）。

AUX Op Amp 的供电，虽然图中标注的是 $\pm 15V$，但是考虑到手边刚好有一个 $\pm 12V$ 的开关电源，因此改为 $\pm 12V$。


至于 S6 开关处的 +1V，其仅作用在下面的电路中：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-23-54-37_Basic Op Amp Measurement Board.png"/></div>

该如何产生这个 +1V？为了减小函数发生器的输出负担，我们考虑用开关电源的 $\pm 12V$ 来产生 +1V。因为输出功率要求很低，不妨用一个 inverting amplifier (反相比例放大器) 来提供 +1V，用 (20K 定值 + ) 50K 可变电阻与 5K 定值电阻产生 $[\frac{1}{14},\ \frac{1}{4}]$ 的可变系数 ($+0.86V \sim +3V$ 可调)，方便调节较为准确的 +1V。如果需要较大的范围，可以考虑用 5K 定值电阻与 (2K 定值 + ) 50K 可变电阻产生：

$$
\begin{gather}
12 \ \mathrm{V} \times \frac{2K + [0,\ 50K]}{50K} = [0.48 \ \mathrm{V},\ 12 \ \mathrm{V}]
\end{gather}
$$





## Formula Derivations

### 1. V_IO (Offset Voltage)

保持所有开关都在初始档位， DUT 的输出 (node TP2) 应为 AUX Op Amp 的失调电压加上电阻 $R_4$ 和 $R_5$ 上由于 AUX 偏置电流带来的压降，也即：

$$
\begin{gather}
V_{TP2} = V_{IO, AUX} + I_{B-} (R_4 \parallel R_5)
\end{gather}
$$

通常情况下，$V_{IO, AUX}$ 在几 mV 以下（例如 NE5532 为 0.5mV typ 和 4mV max）。另外，参考文章给出 $R_4 = R_5 = 220 \ \mathrm{K\Omega}$，如果我们沿用此设计，那么 $I_{B-} (R_4 \parallel R_5)$ 一项将会带来一定的误差。这是因为 NE5532 的 $I_{B} \in [\mathrm{typ}, \ \mathrm{max}] = [200 \ \mathrm{nA}, 800 \ \mathrm{nA}]$，$I_{IO} \in [10 \ \mathrm{nA},\ 150 \ \mathrm{nA}]$，近似按 $I_{B-} = I_{B}$ 来计算，TP2 处的电压将为：

$$
\begin{gather}
V_{TP2} = V_{IO, AUX} + I_{B-} (R_4 \parallel R_5) 
\approx 4 \ \mathrm{mV} + I_{B-} (R_4 \parallel R_5)
\in [26 \ \mathrm{mV}, \ \mathrm{92 mV}]
\end{gather}
$$

显然 $92 \ \mathrm{mV}$ 已经是一个比较大的值，这可能会对 AUX 的工作产生影响，因此我们令 $R_4 = R_5 = 20 \ \mathrm{K\Omega}$，将 $V_{TP2}$ 的值锁定在 20mV 以内，此时 $V_{TP2}$ 的范围是：

$$
\begin{gather}
V_{TP2} \in [\mathrm{typ}, \ \mathrm{max}] = [8 \ \mathrm{mV}, \ \mathrm{20 mV}]
\end{gather}
$$

为了保持 AUX 作为一个 Integrator 的带宽不变（即保持 $R C$ 的乘积不变），我们将 $C_1$ 修改为 $10 \ \mathrm{uF}$。在参考文章 [here](https://www.analog.com/media/en/analog-dialogue/volume-45/number-2/articles/simple-op-amp-measurements.pdf) 的末尾标注写，最开始使用的是 $C_1 = 1 \ \mathrm{uF}$ 的版本，我们将 $R_4$ 和 $R_5$ 缩小了约 10 倍，因此将 $C_1$ 放大约 10 倍取 10uF。

这样，我们可以由 $V_{TP1}$ 计算得到 $V_{IO}$：

$$
\begin{gather}
V_{TP1} = \left(1 + \frac{R_3}{R_2}\right) \times V_{IO} = \left(1 + \frac{100 \ \mathrm{K\Omega}}{100}\right) \times V_{IO}
\Longrightarrow 
{{V_{IO} = \frac{V_{TP1}}{1001}}} 
\end{gather}
$$

事实上，在这一步 (When S1 and S2 are closed), IOS still flows in the 100-Ω resistors (R1 and R2) and introduces an error in VOS, but unless Ios is large enough to produce an error of greater than 1% of the measured VOS, it may usually be ignored in this calculation.

### 2. I_B (Bias Current)

保持所有开关都在初始档位，以计算 $I_{B-}$ 为例，当 (S2 保持 `0R`) S1 从 `0R` 拨至 `R7` 时，串联电阻 $R_7$ 被接入电路，使得 DUT 的 inverting 输入端电压降低 $R_7I_{B-}$，这等价于 $V_{IO}$ 降低 $R_7I_{B-}$，也就是：

$$
\begin{gather}
\Delta V_{IO} = -R_7I_{B-} = \frac{\Delta V_{TP1}}{1001} \Longrightarrow  
{{I_{B-} = - \frac{\Delta V_{TP1}}{1001\,R_7}}}
\end{gather}
$$

同理，当 (S1 保持 `0R`) S2 从 `0R` 拨至 `R6` 时，$R_6$ 被接入，使得 DUT 的 noninverting 输入端电压降低 $R_6I_{B+}$，这等价于 $V_{IO}$ 升高 $R_6I_{B+}$，也就是：

$$
\begin{gather}
\Delta V_{IO} = R_6I_{B+} = \frac{\Delta V_{TP1}}{1001} \Longrightarrow  
{{I_{B+} = +\frac{\Delta V_{TP1}}{1001\,R_6}}}
\end{gather}
$$

对于不同大小的 $I_{B\pm}$，应选用不同的阻值，为了测量 $I_{B\pm} \in [10 \ \mathrm{nA},\ 1000 \ \mathrm{nA}]$ 的 DUT，我们这里选用 3.9KOhm 和 390KOhm 的电阻，这样：

$$
\begin{gather}
R = 3.90 \ \mathrm{K\Omega},\ |I_{B,\pm}| \in [0.1 \ \mathrm{nA},\ 10 \ \mathrm{nA}] \Longrightarrow |\Delta V_{TP1}| \in [39.039 \ \mathrm{mV}, \ 3903.9 \ \mathrm{mV}]
\\
R = 390 \ \mathrm{K\Omega},\ |I_{B,\pm}| \in [10 \ \mathrm{nA},\ 1000 \ \mathrm{nA}] \Longrightarrow |\Delta V_{TP1}| \in [39.039 \ \mathrm{mV}, \ 3903.9 \ \mathrm{mV}]
\end{gather}
$$

不直接用 4K 和 400K 的是因为没有这个阻值。


For values of IB of the order of 5 pA or less, it becomes quite difficult to use this circuit because of the involved large resistors. In this case, we can measure $I_B$ by involving the rate at which IB charges low-leakage capacitors (that replace RS).

### 3. DC Gain (Open-Loop)

保持所有开关都在初始档位，然后利用开关 S6 将 DUT 的输出移动一个确定的值并测量输入端的信号变化（已经被放大到 TP1），我们可以得到 DUT 的 DC Gain ：

$$
\begin{gather}
A_{OL} = \frac{\Delta V_{TP2}}{\frac{\Delta V_{TP1}}{1001}} \Longrightarrow {{ A_{OL} = 1001 \times \frac{\Delta V_{TP2}}{\Delta V_{TP1}}}}
\end{gather}
$$

此阶段我们给 DUT 的供电（通常）是 $\pm 4V$，即使 DUT 不是 rail-to-rail output ，也大致有 $[-3V,\ 3V]$ 的输出摆幅，因此 S6 另一端的 +1V 电压可视情况改为 +2V 或 +3V。如果取 +3V，按示波器电压变化 10mV 来算，最大可测的增益为 $ 1001 \times \frac{3 \ \mathrm{V}}{10 \ \mathrm{mV}} = 300 \ \mathrm{V/mV} \approx 110 \ \mathrm{dB}$。当 DUT 增益较大，TP1 电压变化不明显时，可以用电阻限流电容充电+仪表（差分）放大器采样并放大电流信号，也可以修改 $R_3$ 和 $R_2$ 的比例。

当然，最简单的方法还是增大 DUT 的供电电压范围，例如改为 $\pm 12 \ \mathrm{V}$ (如果可以的话)，这样，用 +10V 的摆幅和 10mV 变化来计算，可以测量 $1000 \ \mathrm{V/mV} \approx 120 \ \mathrm{dB}$。

### 4. AC Gain (Open-Loop)

保持所有开关都在初始档位，将 S4 (AC Input) 开关拨至 `R9`，以此将 AD1 的 W1 作为 ac 信号源，通过 RC 高通滤波器输入不同频率的正弦波，然后测量 DUT 的输出 (TP1)，计算得到 ac gain 。下面公式中的各物理量都表示 ac 信号（不含有 dc bias）：

$$
\begin{gather}
A_{OL} = \frac{V_{TP2}}{V_{DUT, in}} ,\quad 
V_{DUT, in} = - \frac{R_1}{R_1 + R_9} V_{IN}
\\
\Longrightarrow
{ A_{OL} = (1 + \frac{R_9}{R_1}) \cdot \frac{V_{TP2, \mathrm{amplitude}}}{V_{IN,\mathrm{amplitude}}} }
\end{gather}
$$

$R_1$ 为 100Ohm，而 $R_9$ 我们提供了 20K 和 1M 两种，因此相应的 $\frac{R_9}{R_1}$ 分别为 200 和 10000。假设可测量的 $V_{TP2, \mathrm{amplitude}}$ 最大为 1V，同时取 $V_{IN,\mathrm{amplitude}}$ 为 1V，那么可测量的最大 ac gain 分别为 201 和 10001。前者适用于较高频率下 (>10KHz) ac gain 的测量，而后者适用于较低频率 (1KHz ~ 100KHz)。至于输入不同频率的 ac input ，同时测量输出信号的 amplitude ，这可以由 AD1 的 impedance analyzer 轻易实现。

如果采用常见示波器探头的 x10 倍率，最大可测量 ac gain 可以分别提升到 2001 和 100001 (即 2 V/mV 和 100 V/mV, 或者 66dB 和 100dB)。

### 5. DC CMRR

保持所有开关都在初始档位，我们通过改变 DUT 的供电电压来等效地改变 common-mode voltage ，然后测量由于 CM voltage 引起的 $V_{IO}$ 变化 (改变 $V_{CM}$ 等价于改变 $V_{IO}$, 从而影响 $V_{TH2}$)，即可得到 CMRR 。默认情况下， DUT 是由 WP 来供电，假设 WP+ 和 WP- 分别接的是 W1 和 W2 。

先 configure W1 and W2 to $\pm 4V$ respectively ，待输出稳定后，将 W1 和 W2 都提高 1V (W1 from +4V to +5V, W2 from -4V to -3V)，测量 $\Delta V_{IO}$：

$$
\begin{gather}
\mathrm{CMRR} = \frac{\Delta V_{CM}}{\Delta V_{IO}} = \frac{1001\,\Delta V_{CM}}{\Delta V_{TP1}}
\\
\Longrightarrow 
{{\mathrm{CMRR} = \frac{1001 \times \Delta V_{CM}}{\Delta V_{TP1}}}}
\end{gather}
$$

按 1V 的 $\Delta V_{CM}$ 和 10mV 的 $\Delta V_{TP1}$ 来算，可以测量最高为 100000 (即 100 V/mV, 100dB) 的 CMRR 。常见运放的 CMRR 多在 80dB ~ 120dB，如果需要提高 CMRR 的测量范围，可以考虑用更大的 $\Delta V_{CM}$（将 WP 开关连接到 P ，利用外置的 P1 和 P2 来提供更大的 $\Delta V_{CM}$）。

### 6. DC PSRR

保持所有开关都在初始档位，然后将 W1 和 W2 恢复到 ±4V。

同理，我们通过改变 DUT 的供电电压来等效地改变 power supply voltage ，然后测量由于 PS voltage 引起的 $V_{IO}$ 变化 (改变 $V_{PS}$ 等价于改变 $V_{IO}$, 从而影响 $V_{TH2}$)，即可得到 PSRR 。我们有现成的 ±12V 可以使用，因此，如果可以的话，直接将 DUT 的供电从 WP (±4V) 切换到 ±12V (否则切换到 ±5V) ，然后测量 $\Delta V_{TH1}$：

$$
\begin{gather}
\mathrm{PSRR} = \frac{\Delta V_{PS, total}}{\Delta V_{IO}} = \frac{1001\,\Delta V_{PS, total}}{\Delta V_{TP1}}
\\
\Longrightarrow 
{{\mathrm{PSRR} = \frac{1001 \times \Delta V_{PS, total}}{\Delta V_{TP1}}}}
\end{gather}
$$

如果从 ±4V 切换到 ±5V，$\Delta V_{PS, total} = 10 - 8 = 2 \ \mathrm{V}$，设 $\Delta V_{TP1} = 10 \ \mathrm{mV}$，那么 PSRR 最大可测 200 V/mV (106dB)；如果从 ±4V 切换到 ±12V，$\Delta V_{PS, total} = 24 - 8 = 16 \ \mathrm{V}$，设 $\Delta V_{TP1} = 10 \ \mathrm{mV}$，那么 PSRR 最大可测 1600 V/mV (124dB)。

### 7. AC CMRR

保持所有开关都在初始档位，将 DUT 的供电恢复到 W1 和 W2 提供的 ±4V，然后<span style='color:red'> 将 S3 调整为 `1 ON` </span>。Configure W1 to sine wave (1V amplitude, +4V offset), and W2 to sine wave (1V amplitude, -4V offset) ，<span style='color:red'> 注意开启 W1 和 W2 的同步输出 (两者相位相同) </span>。测量由 $V_{IO}$ 改变而受影响的 $V_{TH1}$：

下面公式中的各物理量都表示 ac 信号：

$$
\begin{gather}
\mathrm{CMRR} = \frac{V_{CM}}{V_{IO}} = \frac{1001\,V_{CM}}{V_{TP1}}
\\
\Longrightarrow 
{{
\mathrm{CMRR} = \frac{1001\, V_{W1, \mathrm{amplitude}}}{V_{TP1, \mathrm{amplitude}}}
}}
\end{gather}
$$

类似的，按 1V 的 $V_{CM, \mathrm{amplitude}}$ 和 10mV 的 $V_{TP1, \mathrm{amplitude}}$ 来算，可以测量最高为 100000 (即 100 V/mV, 100dB) 的 CMRR 。

### 8. AC PSRR

与第七条类似，保持所有开关都在初始档位，将 DUT 的供电恢复到 W1 和 W2 提供的 ±4V，然后 <span style='color:red'> 将 S3 调整为 `1 ON` </span>。 Configure W1 to sine wave (1V amplitude, +4V offset), and W2 to sine wave (1V amplitude, -4V offset) ，注意开启 W1 和 W2 的同步输出  <span style='color:red'> (两者相位相反) </span>。测量由 $V_{IO}$ 改变而受影响的 $V_{TH1}$：

$$
\begin{gather}
\mathrm{PSRR} = \frac{V_{PS}}{V_{IO}} = \frac{1001\,V_{PS}}{V_{TP1}}
\\
\Longrightarrow 
{{
\mathrm{PSRR} = \frac{2002\, V_{W1, \mathrm{amplitude}}}{V_{TP1, \mathrm{amplitude}}}
}}
\end{gather}
$$

按 1V 的 $V_{CM, \mathrm{amplitude}}$ 和 10mV 的 $V_{TP1, \mathrm{amplitude}}$ 来算，可以测量最高为 200000 (即 200 V/mV, 106dB) 的 CMRR 。