# Basic Two-Stage Op Amp using Discrete MOSFETs

> [!Note|style:callout|label:Infor]
> Initially published at 16:15 on 2025-05-06 in Beijing.

## Information

- Time: 2025.05.05 23:12
- Notes: 用分立贴片 MOSFET 实现典型两级运算放大器
- Details: MOSFET 封装为 SOT-23, NMOS 全部使用 2N7002, PMOS 全部使用 BSS84
- Relevant Resources: 


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
  <tr>
    <td>Demo (top view)</td>
    <td>Demo (bottom view)</td>
  </tr>
  <tr>
    <td><div class="center"><img height = 250px src=""/></div></td>
    <td><div class="center"><img height = 250px src=""/></div></td>
  </tr>
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