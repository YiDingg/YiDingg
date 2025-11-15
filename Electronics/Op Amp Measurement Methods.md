# Basic Op Amp Measurement Methods

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 19:12 on 2025-02-12 in Lincang.


## Introduction

为了测量运算放大器的各项性能，我们使用参考文章 [*Simple Op Amp Measurements*](https://www.analog.com/media/en/analog-dialogue/volume-45/number-2/articles/simple-op-amp-measurements.pdf) 中的电路来测量运算放大器的直流增益、交流增益、输入失调、输入偏置等性能。测试电路如下：
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-19-23-51_Simple Op Amp Measurements.png"/></div>

Notes:
- The additional “auxiliary” op amp does not need better performance than the op amp being measured. But it is helpful if it has dc open-loop gain of one million or more.
- If the offset of the device under test (DUT) is likely to exceed a few mV, the auxiliary op amp should be operated from ±15-V supplies.
- If the DUT’s input offset can exceed 10 mV, the 99.9-kΩ resistor, R3, will need to be reduced.
- The supply voltages, +V and –V, of the DUT are of equal magnitude and opposite sign. For single supply op amps, the system ground reference is the midpoint of the supply.

运放测量的实验结果都汇总在了 [The Collection of My Measurement Experiments](<Electronics/The Collection of My Measurement Experiments.md>).

## V_IO 

An ideal op amp has zero offset voltage ($V_{IO}$), i.e., if both inputs are joined together and held at a voltage midway between the supplies, the output voltage should also be midway between the supplies.

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-19-35-25_Op Amp Measurement Methods.png"/></div>


Figure 2 shows the configuration for the most basic test—offset measurement. 
The DUT output voltage is at ground when the voltage on TP1 is 1000 times its offset. 
Changing TP1 to adjust DUT output to ground (midway between the supplies) gives the offset voltage:

$$
\begin{gather}
V_{DUT, out} = 0 \Longrightarrow 
V_{IO} = \frac{V_{TP1}}{1000}
\end{gather}
$$

Noticing that TP2 and $V_{DUT, out}$ are at the same voltage, we abbreviate $V_{DUT, out}$ as $V_{TP2}$ in the following contents.

When S1 and S2 are closed, $I_{IO}$ still flows in the 100-Ω resistors and introduces an error in $V_{IO}$, but unless Ios is large enough to produce an error of greater than 1% of the measured $V_{IO}$, it may usually be ignored in this calculation.


## I_B

Figure 3 shows how $I_{B+}$ and $I_{B-}$ can be measured. 
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-19-40-04_Op Amp Measurement Methods.png"/></div>

When S1 and S2 are both closed (on, 1), the circuit is the same as the offset measurement circuit. 
Remain S2 closed (on, 1) and open S1 (off, 0), the bias current from the inverting input flows in RS, and the voltage difference adds to the offset (TP1), yielding:

$$
\begin{gather}
\Delta V_{TP1} = 1000\,I_{B-}R_7
\end{gather}
$$

Similarly, by closing S1 and opening S2 we can measure $I_{B+}$:

$$
\begin{gather}
\Delta V_{TP1} = 1000\,I_{B+}R_6
\end{gather}
$$

If the voltage is measured at TP1 with S1 and S2 both closed (denoted by $V_1$), and then both open (denoted by $V_2$), the “input offset current” $I_{IO}$ (the difference between IB+ and IB–) is measured by the change:

$$
\begin{gather}
\Delta V_{TP1} = V_2 - V_1 = 1000\,I_{IO}R_7
\end{gather}
$$

Therefore, $I_{B}$ and $I_{IO}$ can be calculated as:

$$
\begin{gather}
I_{B} = \frac{I_{B+} + I_{B-}}{2},\quad 
I_{IO} = I_{B+} - I_{B-}
\end{gather}
$$

Note that for values of $I_B$ of the order of 5 pA or less, it becomes quite difficult to use this circuit because of the large resistors involved; other techniques may be required, probably involving the rate at which IB charges low-leakage capacitors (that replace RS).

## DC Gain

The open-loop dc gain is measured by switching R5 between the DUT output and a 1-V reference with S6. If R5 is at +1 V, then the DUT output must move to –1 V if the input of the auxiliary amplifier is to remain unchanged near zero.

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-20-09-55_Op Amp Measurement Methods.png"/></div>

The voltage change at TP1, attenuated by 1000:1, is the input to the DUT, which causes a 1-V change of output. Thus, the gain can be calculated from:

$$
\begin{gather}
A_{OL} = \frac{1 \ \mathrm{V}}{ \frac{\Delta V_{TP1}}{1000} } = \frac{1000}{\Delta V_{TP1}} \cdot 1 \ \mathrm{V}
\end{gather}
$$

## AC Gain

To measure the open-loop ac gain, it is necessary to inject a small ac signal of the desired frequency at the DUT input and measure the resulting signal at its output (TP2 in Figure 5). While this is being done, the auxiliary amplifier continues to stabilize the mean dc level at the DUT output.

In Figure 5, the ac signal is applied to the DUT input via a 10,000:1 attenuator. This large value is needed for low-frequency measurements, where open-loop gains may be near the dc value.
The simple attenuator shown will only work at frequencies up to 100 kHz or so, even if great care is taken with stray capacitance; at higher frequencies a more complex circuit would be needed

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-20-15-28_Op Amp Measurement Methods.png"/></div>

Set ac input with 1V amplitude (2V peak-peak) and measure the output ac amplitude at $V_{TP2}$. Assuming $V_{TP2}$ has an ac amplitude of x volts, the ac gain is given by:

$$
\begin{gather}
A_{OL} = \frac{x}{ \frac{1 \ \mathrm{V}}{10000} } = \frac{10000}{1 \ \mathrm{V}} \cdot x
\end{gather}
$$

## DC CMRR

We adjust the common-mode voltage by changing supply voltages instead of changing the input CM voltage.

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-21-20-30_Op Amp Measurement Methods.png"/></div>

In the circuit of Figure 6, the offset is measured at TP1 with supplies of ±V (in the example, +2.5 V and –2.5 V) and again with both supplies moved up by +1 V to +3.5 V and –1.5 V. The change of offset corresponds to a change of common mode of 1 V, so the dc CMRR is given by:

$$
\begin{gather}
\mathrm{DC\ \   CMRR} = \frac{\Delta V_{IO}}{\Delta V_{CM}} = \frac{1000\, \Delta V_{TP1}}{1 \ \mathrm{V}}
\end{gather}
$$

## DC PSRR

The power-supply rejection ratio (PSRR), on the other hand, is the ratio of the change of offset to the change of total power supply voltage, with the common-mode voltage being unchanged at the midpoint of the supply (Figure 7).

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-21-25-44_Op Amp Measurement Methods.png"/></div>

The circuit used is exactly the same; the difference is that the total supply voltage is changed, while the common level is unchanged. Here the switch is from +2.5 V and –2.5 V to +3 V and –3 V, a change of total supply voltage from 5 V to 6 V. The common-mode voltage remains at the midpoint. And the calculation is the same:

$$
\begin{gather}
\mathrm{DC\ \  PMRR} = \frac{\Delta V_{IO}}{\Delta V_{PM}} = \frac{1000\, \Delta V_{TP1}}{1 \ \mathrm{V}}
\end{gather}
$$


## AC CMRR


To measure ac CMRR, the positive and negative supplies to the DUT are modulated with ac voltages with amplitude of 1-V peak. The modulation of both supplies is the same phase, so that the actual supply voltage is steady dc, but the common-mode voltage is a sine wave of 2 V p-p, which causes the DUT output to contain an ac voltage, which is measured at TP2.

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-22-16-10_Op Amp Measurement Methods.png"/></div>

If the ac voltage at TP2 has an amplitude of x volts peak (2x volts peak-to-peak), then the CMRR is given by:

$$
\begin{gather}
\mathrm{AC\ \   CMRR} = \frac{1 \ \mathrm{V}}{\frac{x\ \mathrm{V}}{100}} = \frac{100}{x}
\end{gather}
$$


## AC PSRR

AC PSRR is measured with the ac on the positive and negative supplies 180° out of phase. This results in the amplitude of the supply voltage being modulated (again, in the example, with 1 V peak, 2 V p-p) while the common-mode voltage remains steady at dc.

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-22-23-13_Op Amp Measurement Methods.png"/></div>

The calculation is very similar to the previous one:

$$
\begin{gather}
\mathrm{AC\ \   PSRR} = \frac{2\times 1 \ \mathrm{V}}{\frac{x\ \mathrm{V}}{100}} = \frac{200}{x}
\end{gather}
$$