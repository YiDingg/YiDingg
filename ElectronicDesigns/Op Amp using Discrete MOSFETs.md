# Op Amp using Discrete MOSFETs

> [!Note|style:callout|label:Infor]
Initially published at 00:01 on 2025-03-18 in Beijing.

## Design Notes

考虑 DIS + VAS + OS 的典型三级运放，即 Differential input stage + voltage amplifier stage + output stage. 为了满足高增益的需求, VAS 可由一个增益一般的 level shift 和一个增益较高的 voltage amplifier 构成。

在进行设计之前，我们需要先测量所用晶体管的特性曲线和小信号参数，实验记录见 [待完成](待完成)。

完成测量之后，可以对每一级分别进行计算：

### Differential Input Stage



Using null circuit to reduce the input offset voltage:
- https://www.ti.com/lit/an/sloa045/sloa045.pdf
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-18-41-34_Op Amp using Discrete MOSFETs.png"/></div>



### Voltage Amplifier

我们先设计 Voltage Amplifier, 确定所需的直流工作点, 再考虑 Level-Shift。

### Level-Shift

### Output Stage



## Design Requirements

### Design Rules

- 使用 NMOS 和 PMOS 搭建运放
- 尽量只使用两种型号的 MOSFET (一种 NMOS, 一种 PMOS), 或者在此基础上, 另找一种型号
- 尽量少用电阻 (用 MOS 搭建 biasing)
- 内部电容不超过 $10\ \mathrm{nF}$

### Operation Conditions

- Power supply range: ±5V ~ ±15V
- Output current: $> 10\ \mathrm{mA}$ (continuously)
- Input common mode range: $[V_{SS} + 2 \ \mathrm{V},\ V_{DD} - 2 \ \mathrm{V}]$
- Output swing: $> (V_S - 4\ \mathrm{V})$, i.e, $> [ (V_{DD} - V_{SS}) - 4\ \mathrm{V} ]$, or say beyond the range of $[V_{SS} + 2 \ \mathrm{V},\ V_{DD} - 2 \ \mathrm{V}]$


### Performance Requirements

<!-- 
- Open-loop gain: $A_{OL} > 100\ \mathrm{dB}$
- Gain-bandwidth product: $\mathrm{GBW} > 1\ \mathrm{MHz}$
- Input offset voltage: $V_{IO} < 20\ \mathrm{mV}$
- Input bias current: $|I_B| < 100\ \mathrm{nA}$
 -->


尽量满足下面的性能需求：

<div class='center'>

| Name | Parameter | Range |
|:-:|:-:|:-:|
 | Open-loop gain | $A_{OL}$ | $> 100\ \mathrm{dB}$ |
 | Gain-bandwidth product | $\mathrm{GBW}$ | $> 10\ \mathrm{MHz}$ (at 10kHz) |
 | Unity-gain bandwidth | $\mathrm{UGBW}$ | $> 5\ \mathrm{MHz}$ |
 | Input offset voltage | $V_{IO}$ | $< ±\, 20\ \mathrm{mV}$ |
 | Input bias current | $I_B$ | $< ±\, 100\ \mathrm{nA}$ |
 | Slew rate | $\frac{\mathrm{d} V_{out} }{\mathrm{d} t }$ | $> ±\, 2 \ \mathrm{V/us}$ |
 | Maximum output current | $I_{out}$ | $> \, 10 \ \mathrm{mA}$ |
 | Supply current | $I_S$ | $25 \ \mathrm{mA}$ (no load) |
</div>


