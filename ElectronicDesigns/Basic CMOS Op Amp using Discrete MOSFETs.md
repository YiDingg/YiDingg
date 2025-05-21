# Basic CMOS Op Amp using Discrete MOSFETs

> [!Note|style:callout|label:Infor]
> Initially published at 16:15 on 2025-05-06 in Beijing.

## Information

- Time: 2025.05.05 23:12
- Notes: 用分立贴片 MOSFET 实现典型两级运算放大器
- Details: MOSFET 封装为 SOT-23, NMOS 全部使用 2N7002, PMOS 全部使用 BSS84
- Relevant Resources: https://www.123684.com/s/0y0pTd-Q8Uj3, 与 [μA741 using Discrete BJTs (SOT-23)](<ElectronicDesigns/μA741 using Discrete BJTs (SOT-23).md>) 合并打板


<div class='center'>


| Demo (top view)| Demo (bottom view) | 
|:-:|:-:|
 |  |  |
</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-20-34-23_μA741 using Discrete BJTs (SOT-23).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-20-34-07_μA741 using Discrete BJTs (SOT-23).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-20-33-38_μA741 using Discrete BJTs (SOT-23).png"/></div>

### Op Amp 1 (CS Output)

<div class='center'>

| Schematic 1 (CS Output Stage) | 3D view 1 (CS Output Stage) | 
|:-:|:-:|
 |<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-07-48_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>|<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-06-15_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>|
 | Top view | Bottom view |
 |<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-06-34_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>|<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-06-48_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>|
</div>





### Op Amp 2 (PP Output)


<div class='center'>

| Schematic 2 (PP Output Stage) | 3D view 2 (PP Output Stage) | 
|:-:|:-:|
 |<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-13-35_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>|<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-13-58_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>|
 | Top view | Bottom view |
 |<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-14-10_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>|<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-14-20_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>|
</div>




<!-- 
<table>
  <tr>
    <td colspan="3">合并的标题</td>
  </tr>
  <tr>
    <td>单元格1</td>
    <td>单元格2</td>
    <td>单元格3</td>
  </tr>
</table>
 -->




### MOS Op Amp + uA741

将两个 MOSFET Op Amp 和 [μA741 using Discrete BJTs (SOT-23)](<ElectronicDesigns/μA741 using Discrete BJTs (SOT-23).md>) 组合在一起进行打板：


<div class='center'>

<table  style="text-align: center">
  <tr>
    <td colspan="2">3D overview</td>
  </tr>
  <tr>
    <td colspan="2"><div class="center"><img height=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-19-54-18_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div></td>
  </tr>
  <tr>
    <td>PCB layout (top)</td>
    <td>PCB layout (bottom)</td>
  </tr>
  <tr>
    <td><div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-24-38_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div></td>
    <td><div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-24-50_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div></td>
  </tr>
  <tr>
    <td>3D view (top)</td>
    <td>3D view (bottom)</td>
  </tr>
  <tr>
    <td><div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-00-36_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div></td>
    <td><div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-00-49_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div></td>
  </tr>
<!--   <tr>
    <td>Demo (top view)</td>
    <td>Demo (bottom view)</td>
  </tr>
  <tr>
    <td><div class="center"><img height = 250px src=""/></div></td>
    <td><div class="center"><img height = 250px src=""/></div></td>
  </tr> -->
</table>
</div>




<!-- 
<div class='center'>

| PCB layout (top) | PCB layout (bottom) |
|:-:|:-:|
 |<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-24-38_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>|<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-24-50_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>|
 | 3D view (top) | 3D view (bottom) |
 |<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-00-36_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>|<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-20-00-49_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>|
| Demo (top view)| Demo (bottom view) | 
 | <div class="center"><img height = 250px src=""/></div> | <div class="center"><img height = 250px src=""/></div> |
</div>
 -->


## LTspice Simulation

### Op Amp 1 (CS Output)

Frequency response:
- $V_{S} = 20 \ \mathrm{V}$
- $C_c = 20 \ \mathrm{pF} \sim 100 \ \mathrm{pF},\ R_L = 10 \ \mathrm{k\Omega}$
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-17-21-02_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-16-46-08_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> -->

Transient response under buffer configuration:
- $V_{S} = 20 \ \mathrm{V}$, input 5Vamp sine wave (10V offset)
- $C_c = 100 \ \mathrm{pF}, R_L = 10 \ \mathrm{k}\Omega$
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-17-22-53_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-16-48-33_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>
 -->

Voltage headroom under buffer configuration:
- $V_{S} = 20 \ \mathrm{V}$, input 0V ~ 20V
- $C_c = 100 \ \mathrm{pF}, R_L = 10 \ \mathrm{k}\Omega$
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-17-23-58_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>

### Op Amp 2 (PP Output)

Frequency response:
- $V_{S} = 20 \ \mathrm{V}$
- $C_c = 20 \ \mathrm{pF} \sim 100 \ \mathrm{pF},\ R_L = 10 \ \mathrm{k\Omega}$
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-16-32-17_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>

Transient response under buffer configuration:
- $V_{S} = 20 \ \mathrm{V}$, input 5Vamp sine wave (10V offset)
- $C_c = 100 \ \mathrm{pF}, R_L = 10 \ \mathrm{k}\Omega$
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-16-40-49_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>

Voltage headroom under buffer configuration:
- $V_{S} = 20 \ \mathrm{V}$, input 0V ~ 20V
- $C_c = 100 \ \mathrm{pF}, R_L = 10 \ \mathrm{k}\Omega$
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-06-17-16-44_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div>

## 2025-05-06 PCB Verification

### Compensation Test


- [Gerber_CMOS_+_uA741_(捷配打板用, 铺铜) 2025-05-06.zip](https://www.writebug.com/static/uploads/2025/5/12/79051f990f464928e3e20b6d65441796.zip)


在下面的测试中，我们默认 op amp 设置为 unit buffer 模式，$V_{CC} = \pm 12 \ \mathrm{V}$ 且 $R_L = \infty$ (空载)。

<!-- <div class='center'>

| op amp 1 ($C_c = 100 \ \mathrm{pF}$) | op amp 1 ($C_c = 1000 \ \mathrm{pF}$) |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-46-48_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-48-33_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-44-52_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-43-08_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-49-26_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-51-18_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
</div> -->

<div class='center'>

| op amp 1 | zero input | sine input 1 | sine input 2 |
|:-:|:-:|:-:|:-:|
 | $C_c = 0.1 \ \mathrm{nF}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-46-48_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-44-52_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-43-08_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
 | $C_c = 1 \ \mathrm{nF}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-48-33_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-49-26_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-51-18_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
 | $C_c = 10 \ \mathrm{nF}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-18-36_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-17-21_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-18-00_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
</div>

<!-- <div class='center'>

| Op Amp 2 ($C_c = 100 \ \mathrm{pF}$) | Op Amp 2 ($C_c = 1000 \ \mathrm{pF}$) |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-55-33_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-59-49_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-57-03_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-58-04_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-01-27_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-02-02_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
</div> -->

<div class='center'>

| op amp 2 | zero input | sine input 1 | sine input 2 |
|:-:|:-:|:-:|:-:|
 | $C_c = 0.1 \ \mathrm{nF}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-55-33_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-57-03_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-20-58-04_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
 | $C_c = 1 \ \mathrm{nF}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-14-01_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-15-02_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-02-02_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
 | $C_c = 10 \ \mathrm{nF}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-11-55_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-09-29_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-08-32_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
</div>



### Current Test

在下面的测试中，我们默认 op amp 配置为 unit buffer 模式，$V_{CC} = \pm 12 \ \mathrm{V}$ 且 $C_c = 1\ \mathrm{nF\ (MLCC)},\ R_L = \infty$ (空载)。改变电流镜参考电流 $I_{REF}$, 得到不同电流下的输出性能。

注意，由于我们在这里使用了 MLCC 电容，存在明显的偏压效应，因此实际补偿容值可能只有 400 pF ~ 700 pF.

<div class='center'>

| op amp 1 (CS) | zero input | sine input 1 | sine input 2 |
|:-:|:-:|:-:|:-:|
 | $R = 3.49 \ \mathrm{k\Omega},\ V_R = 1.276 \ \mathrm{V}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-24-05_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-25-45_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-26-27_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> |
 | $R = 2.52\ \mathrm{k\Omega},\ V_R = 1.229\ \mathrm{V}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-30-26_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-31-03_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-31-36_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> |
 | $R = 0.95\ \mathrm{k\Omega},\ V_R = 1.180\ \mathrm{V}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-35-43_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-36-12_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-36-42_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> |
</div>


<div class='center'>

| op amp 2 (PP) | zero input | sine input 1 | sine input 2 |
|:-:|:-:|:-:|:-:|
 | $R = 2.77 \ \mathrm{k\Omega},\ V_R = 1.192 \ \mathrm{V}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-11-40_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-11-05_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-12-22_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> |
 | $R = 0.97 \ \mathrm{k\Omega},\ V_{R} = 0.986 \ \mathrm{V}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-18-58_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-18-20_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-13-14-17-32_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> |
</div>

### Final Test

经过上面的测试，我们确定了两个 CMOS op amps 的最终参数：
- CMOS Op Amp 1 (CS Output)
  - Compensation Capacitor: $C_c = 4.7 \ \mathrm{nF}$ (MLCC)
  - Reference Resistor: $R = 2.7 \ \mathrm{k\Omega}$
- CMOS Op Amp 2 (PP Output)
  - Compensation Capacitor: $C_c = 1 \ \mathrm{nF}$ (MLCC)
  - Reference Resistor: $R = 2.7 \ \mathrm{k\Omega}$ 

下面是它们的最终测试结果：
<!-- 
<div class='center'>

| op amp 1 | zero input | sine input 1 | sine input 2 | sine input 3 |
|:-:|:-:|:-:|:-:|:-:|
 | $C_c = 4.7 \ \mathrm{nF}$ (MLCC), $R = 2.7 \mathrm{k}\Omega$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-22-10-58_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-22-13-04_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-22-13-22_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-22-14-48_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> |
</div>
 -->



<div class='center'>

| op amp 1 (num.1) | zero input | sine input 1 | sine input 2 | sine input 3 |
|:-:|:-:|:-:|:-:|:-:|
 | $C_c = 4.7 \ \mathrm{nF}$ (MLCC), $R = 2.7 \mathrm{k}\Omega$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-12-29_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-10-08_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-10-39_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-11-46_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> |
</div>

<div class='center'>

| op amp 1 (num.2) | zero input | sine input 1 | sine input 2 | sine input 3 |
|:-:|:-:|:-:|:-:|:-:|
 | $C_c = 4.7 \ \mathrm{nF}$ (MLCC), $R = 2.7 \mathrm{k}\Omega$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-17-20_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-15-33_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-15-59_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-16-39_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> |
</div>

<!-- 
<div class='center'>

| op amp 2 | zero input | sine input 1 | sine input 2 | sine input 3 |
|:-:|:-:|:-:|:-:|:-:|
 | $C_c = 1 \ \mathrm{nF}$ (MLCC), $R = 2.7 \mathrm{k}\Omega$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-22-18-18_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-22-16-53_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-22-17-44_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-22-16-25_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> |
</div>
 -->

<div class='center'>

| op amp 2 (num.1) | zero input | sine input 1 | sine input 2 | sine input 3 |
|:-:|:-:|:-:|:-:|:-:|
 | $C_c = 1 \ \mathrm{nF}$ (MLCC), $R = 2.7 \mathrm{k}\Omega$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-25-50_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-24-44_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-24-56_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-25-13_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> |
</div>

<div class='center'>

| op amp 2 (num.2) | zero input | sine input 1 | sine input 2 | sine input 3 |
|:-:|:-:|:-:|:-:|:-:|
 | $C_c = 1 \ \mathrm{nF}$ (MLCC), $R = 2.7 \mathrm{k}\Omega$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-21-47_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-20-20_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-20-45_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-23-21-08_Basic CMOS Op Amp using Discrete MOSFETs.png"/></div> |
</div>

<!-- ## 2025-05-12 PCB.2

在 **2025-05-06 PCB.1** 的基础上，我们对电路作了如下改动：
将两个 CMOS op amp 的补偿电容换为圆孔插件，方便更换不同容值的补偿
 -->
