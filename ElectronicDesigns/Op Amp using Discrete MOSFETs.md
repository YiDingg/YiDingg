# Op Amp using Discrete MOSFETs

> [!Note|style:callout|label:Infor]
Initially published at 00:01 on 2025-03-18 in Beijing.



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

## Design Notes

考虑 DIS + VAS + OS 的典型三级运放，即 Differential input stage + voltage amplifier stage + output stage. 为了满足高增益的需求, VAS 可由一个增益一般的 level shift 和一个增益较高的 voltage amplifier 构成。

设计思路如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-19-45-54_Op Amp using Discrete MOSFETs.jpeg"/></div>

在进行设计之前，我们需要先测量所用晶体管的特性曲线和小信号参数，实验记录见 [待完成](待完成)。

完成测量之后，可以对每一级分别进行计算：

### Differential Input Stage



Using null circuit to reduce the input offset voltage:
- https://www.ti.com/lit/an/sloa045/sloa045.pdf
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-18-41-34_Op Amp using Discrete MOSFETs.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-19-00-45-02_Op Amp using Discrete MOSFETs.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-19-00-52-37_Op Amp using Discrete MOSFETs.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-19-00-55-52_Op Amp using Discrete MOSFETs.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-19-00-56-31_Op Amp using Discrete MOSFETs.png"/></div>

驱动 10 kOhm 时的增益曲线：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-19-17-38-19_Op Amp using Discrete MOSFETs.png"/></div>

no load 时的增益曲线：
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-19-17-39-51_Op Amp using Discrete MOSFETs.png"/></div>
 -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-19-17-45-12_Op Amp using Discrete MOSFETs.png"/></div>
 -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-19-17-45-56_Op Amp using Discrete MOSFETs.png"/></div>

### Voltage Amplifier

我们先设计 Voltage Amplifier, 确定所需的直流工作点, 再考虑 Level-Shift。

### Level-Shift

### Output Stage

## LTspice Simulation

结合淘宝价格和设计情况，可选的 MOSFET 型号有（都为 SOT-23 封装）：
- [2N7002 (NMOS)](https://item.szlcsc.com/datasheet/2N7002LT1G/17020.html), 长沟道 (可用国产的 MMBT7002 代替)
- [BSS84 (PMOS)](https://item.szlcsc.com/datasheet/BSS84LT1G/83234.html), 长沟道

其中，典型长沟道的 MOS, gm 小, rO 大, 适合作电流源。短沟道的 MOS, gm 大, rO 较小, 适合作放大器。

已排除的型号：
- AO3415 (NMOS) 和 AO3416 (PMOS)
- SI2308 (NMOS) 和 SI2309 (PMOS)
- [ZVN3306FTA (NMOS)](https://item.szlcsc.com/datasheet/ZVN3306FTA/166652.html) 和 [ZVP3306FTA (PMOS)](https://item.szlcsc.com/datasheet/ZVP3306FTA/162357.html): $r_O$ 较小

其它备用型号：
- [BC847BS (2*NPN)](https://item.szlcsc.com/datasheet/BC847BS/43142126.html) 和 [BC857BS (2*PNP)](https://item.szlcsc.com/datasheet/BC857BS/43142127.html): $r_O$ 一般
- [S9013 (NPN)](https://item.szlcsc.com/datasheet/S9013/21397165.html) 和 [S9012 (PNP)](https://item.szlcsc.com/datasheet/S9012/21397167.html): NPN $r_O$ 较大, PNP $r_O$ 一般
- [BC846B (NPN)](https://item.szlcsc.com/datasheet/BC846B/21397172.html) 和 [BC856B (PNP)](https://item.szlcsc.com/datasheet/BC856B/21397174.html): $r_O$ 一般

### 2N7002 (NMOS)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-23-04-01_Op Amp using Discrete MOSFETs.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-22-40-55_Op Amp using Discrete MOSFETs.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-22-44-06_Op Amp using Discrete MOSFETs.png"/></div>

### BSS84 (PMOS)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-23-41-21_Op Amp using Discrete MOSFETs.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-23-42-17_Op Amp using Discrete MOSFETs.png"/></div>

### ZVP4424G (PMOS)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-23-05-45_Op Amp using Discrete MOSFETs.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-23-00-59_Op Amp using Discrete MOSFETs.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-23-02-03_Op Amp using Discrete MOSFETs.png"/></div>

### SI2308 (NMOS)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-22-51-11_Op Amp using Discrete MOSFETs.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-22-54-51_Op Amp using Discrete MOSFETs.png"/></div>

