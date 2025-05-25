# Design Example of F-OTA using Overdrive and Gm-Id Methods

> [!Note|style:callout|label:Infor]
> Initially published at 00:42 on 2025-05-26 in Beijing.

## Design Requirements



设计一个经典的五管 OTA (F-OTA, five-transistor operational transconductance amplifier), 要求基本满足以下指标：
<div class='center'>

| Process | Current | $V_{DD}$ | $C_L$ | $A_{OL}$ | $\mathrm{GBW}_f$ | $\mathrm{SR}$ | $V_{in,CM}$ | Output Swing |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | TSMC 0.18um <br> (`tsmc18rf`) | $500 \ \mathrm{uA}$ | $1.8 \ \mathrm{V}$  | $5\ \mathrm{pF}$ | $40 \ \mathrm{dB}\ (100 \ \mathrm{V/V})$  | $50 \ \mathrm{MHz}$ | $60 \ \mathrm{V/us}$ | $1 \ \mathrm{V} \pm 0.3 \ \mathrm{V}$ | $1 \ \mathrm{V}$ |
</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-01-25-04_Design Example of F-OTA using Overdrive and Gm-Id Methods.png"/></div>

参考公式：

<div class='center'>

| $A_{OL}$ | $\omega_{p1}$ | $\mathrm{GBW}_f$ | $\mathrm{SR}$ | $V_{in,CM}$ | Output Swing |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | $g_{m1}(r_{O2}\parallel r_{O4})$ | $\frac{1}{(r_{O2}\parallel r_{O4})C_L}$ | $\frac{g_{m1}}{2\pi C_L}$ | $\frac{I_{SS}}{C_L}$ | $\footnotesize \begin{aligned}(V_{in,CM})_{\min} &= V_{OV5} + V_{GS1,2} \\ (V_{in,CM})_{\max} &= V_{DD} - V_{OV1,2} - V_{OV3,4} \end{aligned}$ | $\small V_{DD} - V_{OV1,2} - V_{OV4} - V_{OV5}$ |
</div>


参考资料：
- [知乎 > 两级运放设计过程总结-Allen](https://zhuanlan.zhihu.com/p/631329993)
- [知乎 > 基于 gm/Id 的运放设计:单端输出的两级运放设计](https://zhuanlan.zhihu.com/p/18217441114)
- [知乎 > 5-T OTA 的设计与仿真](https://zhuanlan.zhihu.com/p/467542830)
- [知乎 > 基于 gm/Id 法的五管 OTA 的设计](https://zhuanlan.zhihu.com/p/621225975)


## Overdrive Method

### 0. Design Steps 

### 1. 

### 2. 

## Gm-Id Method

### 0. Design Steps

### 1. 

### 2. 