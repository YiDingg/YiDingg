# Basic Two-Stage Op Amp using Discrete MOSFETs

> [!Note|style:callout|label:Infor]
> Initially published at 16:15 on 2025-05-06 in Beijing.

## Information

- Time: 2025.05.05 23:12
- Notes: 用分立贴片 MOSFET 实现典型两级运算放大器
- Details: MOSFET 封装为 SOT-23, NMOS 全部使用 2N7002, PMOS 全部使用 BSS84
- Relevant Resources: https://www.123684.com/s/0y0pTd-Q8Uj3


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

## 2025-05-06 PCB.1

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
 | $C_c = 1 \ \mathrm{nF}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-18-36_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-17-21_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-21-18-00_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
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


<div class='center'>

| uA741 | zero input | sine input 1 | sine input 2 |
|:-:|:-:|:-:|:-:|
 | $C_c = 47 \ \mathrm{pF}$ (MLCC) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-22-07-49_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-22-08-58_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-12-22-09-37_Basic Two-Stage Op Amp using Discrete MOSFETs.png"/></div> |
</div>


## 2025-05-12 PCB.2

在 **2025-05-06 PCB.1** 的基础上，我们对电路作了如下改动：
- 将两个 CMOS op amp 的补偿电容换为圆孔插件，方便更换不同容值的补偿