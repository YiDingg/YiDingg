# Basic Op Amp Measurement Board

> [!Note|style:callout|label:Infor]
Initially published at 20:03 on 2025-02-12 in Lincang.


- Time: 2025.02.13
- Notes: suitable for Analog Discovery [1](https://digilent.com/reference/test-and-measurement/analog-discovery/start), [2](https://digilent.com/reference/test-and-measurement/analog-discovery-2/start), and [3](https://digilent.com/reference/test-and-measurement/analog-discovery-3/start)
- Details: 可以直接测量 $V_{IO}$ 和 $I_{B}$ 在内的 8 种运放基本参数 (详见后文)
- Interactive BOM: 
- Relevant Resources: [Blog > *Op Amp Measurement Methods*](<Blogs/Electronics/Op Amp Measurement Methods.md>) and 

## Usage

Bear in mind that before connecting [AD1](https://digilent.com/reference/test-and-measurement/analog-discovery/start) and the DUT (device under test), reset all the switches to the initial state:
<div class='center'>

| Switch | SW1 | SW2 | CH1 AC/DC | CH2 AC/DC | CH1+ | CH2+ | SW6 | DUTVCC |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | **Initial state** | 0R | 0R | DC | DC | TP2 | TP1 | 0 (10K) | V+- |

</div>

After that, connect $\pm 12 \ \mathrm{V}$, [AD1](https://digilent.com/reference/test-and-measurement/analog-discovery/start), and the DUT, don't forget to open AD1's $\pm 5V$ power supply for the DUT. Voltage $\pm 12 \ \mathrm{V}$ is necessary to power the Aux Op Amp. Then, we can start the measurement:

<div class='center'> <span style='color:red'>

**Assuming we measure the seven parameters one by one in order.**
</span></div>

<div class='center'>

| Num | Parameter | Switch | Steps | Test Point | Formula |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | 1 | $V_{IO}$ |  |  |  |  |
 | 2 | $I_{B+},\ I_{B-}$ |  |  |  |  |
 | 3 | Open-Loop DC Gain |  |  |  |  |
 | 4 | Open-Loop AC Gain |  |  |  |  |
 | 5 | DC CMRR |  |  |  |  |
 | 6 | DC PSRR |  |  |  |  |
 | 7 | AC CMRR |  |  |  |  |
 | 8 | AC PSRR |  |  |  |  |

</div>

$$
\begin{gather}
I_{B}\quad 
\begin{cases}
\mathrm{S1=1,\ S2\ from\ 1\ to\ 0 } \Longrightarrow  \Delta V_{TP1} = 1000 I_{B+} (R_2 + R_6) \\
\mathrm{S1\ from\ 1\ to\ 0,\ S2=1 } \Longrightarrow  \Delta V_{TP1} = 1000 I_{B-} (R_1 + R_7)
\end{cases}
\end{gather}
$$

## Formula Derivations

### 1. V_IO (Offset Voltage)



### 2. I_B (Bias Current)

### 3. Open-Loop DC Gain

### 4. Open-Loop AC Gain

### 5. DC CMRR

### 6. DC PSRR

### 7. AC CMRR

### 8. AC PSRR


## Design Notes

初始参考电路如图所示，其用法详见文章 [*Op Amp Measurement Methods*](<Blogs/Electronics/Op Amp Measurement Methods.md>)，现在我们来一步步实现电路图中的各项要求。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-22-25-46_Basic Op Amp Measurement Board.png"/></div>


### AUX Op Amp Selection

在 $\pm 12V$ 的开关电源供电下，对于一般精度，LM358 或 NE5532 即可胜任测量任务；如果需要更高的精度，可以考虑 OP07CP 或者 AD797。刚好上面我们用到了一路反相比例放大器，刚好可以用一个 NE5532 的两路分别作为 Inverter 和 AUX Op Amp 。

### Resistance Selection

电路中的一些阻值是没有直接对应的 0603 电阻的（电阻本中拥有的阻值见下图），因此有必要对这些电阻进行调整：
- $R_3 = 99.9 \ \mathrm{K\Omega} \longrightarrow R_9 = 100 \ \mathrm{K\Omega}$
- $R_8 = 9.9 \ \mathrm{K\Omega} \longrightarrow R_9 = 10 \ \mathrm{K\Omega}$
- $R_9 = 999 \ \mathrm{K\Omega} \longrightarrow R_9 = 1 \ \mathrm{M\Omega}$

相应的，各参数的计算公式也需要做相应的修改，我们留到最后一并讨论。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-22-48-17_Basic Op Amp Measurement Board.png"/></div>

电路中需要自行确定阻值的电阻有 $R_6$ 和 $R_7$ 两个，它们仅在 S1 (或 S2) 打开 (open, logic 0) 时起作用，用来测量 bias current $I_B$ 和 input offset current $I_{IO}$。考虑到一般的运放偏置电流在 10 nA ~ 100 nA，为了维持 $\Delta V_{TP1} = 1000 R_6I_{B+} $ 在几十 mV 至 1 V 之间，我们令 $R_6 = R_7 = 100 \ \Omega$；对于低偏置的运放，将其改为 $R_6 = R_7 = 10 \ \mathrm{K\Omega}$（用一个三档三脚开关来控制）。需要注意的是，此时 $R_1$ 和 $R_2$ 带来的误差不能轻易忽略，因此 $I_{B\pm}$ 的计算公式应将 $R_1$ 和 $R_2$ 考虑在内：

除此之外，考虑到我们打算用 NE5532 来作为 AUX Op Amp，其输入失调电流还是比较大的，因此需要降低 $R_4$ 和 $R_5$ 的阻值以减小输入失调电流带来的误差。我们将其改为 $R_4 = R_5 = 20 \ \mathrm{K\Omega}$。

### Power Supply

DUT (device under test) 的供电，由于其变化灵活，我们考虑使用 [AD1](https://digilent.com/reference/test-and-measurement/analog-discovery/start) 的 Power Supply (for +V and -V) 和 Wave Generator (W1 和 W2 两通道 for else)。需要注意的是，[AD1](https://digilent.com/reference/test-and-measurement/analog-discovery/start) 的函数发生器输出功率只有大约 60mW ~ 120mW (per channel)，因此对于静态电流较大的运放，需要 AUX 电源（将 W1 和 W2 转为 P1 和 P2 供电）。

AUX Op Amp 的供电，虽然图中标注的是 $\pm 15V$，但是考虑到手边刚好有一个 $\pm 12V$ 的开关电源，因此改为 $\pm 12V$。


至于 S6 开关处的 +1V，其仅作用在下面的电路中：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-12-23-54-37_Basic Op Amp Measurement Board.png"/></div>

该如何产生这个 +1V？为了减小函数发生器的输出负担，我们考虑用开关电源的 $\pm 12V$ 来产生 +1V。因为输出功率要求很低，不妨用一个 inverting amplifier (反相比例放大器) 来提供 +1V，用 (20K 定值 + ) 50K 可变电阻与 5K 定值电阻产生 $[\frac{1}{14},\ \frac{1}{4}]$ 的可变系数 ($+0.86V \sim +3V$ 可调)，方便调节较为准确的 +1V。


