# xxx

> [!Note|style:callout|label:Infor]
Initially published at xx:xx on 2025-xx-xx in Beijing.


## 0. Introduction

本文，我们借助 [gm-Id](<Electronics/An Introduction to gm-Id Methodology.md>) 方法，使用台积电 180nm CMOS 工艺库 `tsmc18rf` 来设计一个 **xxx** 。暂时只作前仿练习，未进行 layout 和 post-layout simulation, 之后如果有需求再补上这一部分。


运放主要指标如下：

<div class='center'>

| DC Gain | UGF | Load | PM | SR | Input CM | Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 80 dB | 50 MHz | 5 pF | 60° | 50 V/us | - 0.1 V ~ + 1.2 V | 1 V | 600 uA @ 1.8V (1.08 mW) |
</div>

主要优化方向为 xxx, 其次为 xxx

## 1. Design Considerations


### 1.1 theoretical formulas

理论参考公式如下图 (2025.xx.xx), 后续如有更新会放在 [Design Sheet of xxx](<xxx>).

<span style='color:red'> 这里放图 </span>


### 1.2 biasing circuits

在已有参考电流的情况下，各个偏置电源如何生成？

### 1.3 satisfying specs


在考虑如何满足 Specifications 之前，需要对当前工艺的 NMOS/PMOS 性能有大致的了解，建议先在 cadence 中对需要用到的晶体管进行仿真，了解各性能参数范围，再考虑 "satisfying specifications":
- 若无特别说明, NMOS 的 bulk 默认接到 GND, PMOS 的 bulk 默认接 source (以避免 body-effect 导致的阈值电压上升)
- 先考虑 `SR` 和 `UGF`, 因为这两个参数可以直接确定电路的 $I_D$ 和输入管的 $g_m$
- `SR > xxx V/us` : 
- `UGF > xxx MHz` :

对于直流增益，需要多大的 self gain 和 rout 才能满足增益要求呢？参考下图：

<span style='color:red'> 这里放图 </span>


- `DC Gain > xxx dB` : 
    - 考虑上图的第 xxx 种方案 (xxx dB), 也即 xxx
- `PM > xxx` : 
    - xxx
- `Input CM = xxx` : 
    - xxx
- `Swing > xxx` : 
    - xxx

### 1.4 summary

上面的考虑可汇总为以下几条：
- xxx 这里是各晶体管的电流情况
- 所有 NMOS (M3 ~ M6) 的 bulk 连接 GND, PMOS bulk 连接 source
- () M1, M2  : xxx
- () M3, M4  : xxx
- () M5, M6  : xxx
- () M7, M8  : xxx
- () M9, M10 : xxx
- () M11     : xxx

## 2. Design Details


### 2.xxx Summary

上面各晶体管的参数汇总如下：

<div class='center'>

| MOSFET | W/L | a | gm/Id |
|:-:|:-:|:-:|:-:|
| M1, M2  |  |  |  |
| M3, M4  |  |  |  |
| M5, M6  |  |  |  |
| M7, M8  |  |  |  |
| M9, M10 |  |  |  |
| M11     |  |  |  |
</div>

## 3. Design Iteration

### 3.1 dc - operation point

### 3.2 dc - io-range and gain

### 3.3 dc: CM input range

### 3.4 ac: UGF and PM

### 3.5 iteration 1 (PM and UGF)

## 4. Simulation Results

### 3.1 dc: operation point


### 3.2 dc: io-range and gain

``` bash
vout = VS("/Vout")
dc_gain = dB20(deriv(VS("/Vout")))
max dc gain = ymax(dB20(deriv(VS("/Vout"))))
swing @ -3dB = (value(vout cross(dc_gain, max_dc_gain-3, 2)) - value(vout cross(dc_gain, max_dc_gain-3, 1)))
swing @ 80dB = (value(vout cross(dc_gain 80 2)) - value(vout cross(dc_gain 80 1)))
swing @ 60dB = (value(vout cross(dc_gain 60 2)) - value(vout cross(dc_gain 60 1)))

```



### 3.3 dc: CM input range



### 3.4 ac: UGF and PM


顺便看一下运放在不同负载电容下的频率响应，结果如下：



### 3.5 tran: slew rate

SR 是 large-signal 下的非线性行为，将输入信号设置为幅度较大的 step signal, 运行仿真，结果如下：


顺便看一下不同幅度 step 信号下的 SR 情况 (幅度需足够大以使运放进入 slewing 状态):



``` bash
SR+ = slewRate(vout 0 t 7e-07 t 20 80 nil "time")
SR- = slewRate(vout 7e-07 t 20e-07 t 20 80 nil "time")
```


### 3.6 tran: step response


将 vout 和 vin- 短接，设置输入信号为幅度足够小的 step signal, 考察运放的 (small-signal) step response, 看看相位和增益裕度是不是“真的”, 并且计算运放的 settling time 和 overshoot:


``` bash
# 注意 settlingTime 返回的是横坐标 (时间), 还需要减去 step 信号起始点才是 settling time
setting time @ 0.05% (rising) = (settlingTime(vout 0 t 7e-07 t 0.05 nil "time") - 2e-07)
setting time @ 0.05% (falling) = (settlingTime(vout 7e-07 t 20e-07 t 0.05 nil "time") - 7e-07)
overshoot (%) (rising) = overshoot(vout 0 t 7e-07 t)
overshoot (%) (falling) = overshoot(vout 7e-07 t 2e-06 t)
```


注：在两极点二阶系统中, PM 与 overshoot 的关系如下图 (from [this slide](https://pallen.ece.gatech.edu/Academic/ECE_6412/Spring_2003/L240-Sim&MeasofOpAmps(2UP).pdf)):

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-14-51-55_Relationship Between GBW and fp2 in a Two-Order System.png"/></div>


### 3.7 (noise) input-referred noise

### 3.8 (mc) Monte Carlo Simulation



## 5. Design Summary

本文设计的 **xxx** 基本满足了指标要求，其主要性能如下：

<div class='center'>

| Parameter | Value |
|:-:|:-:|
 | DC Gain              | maximum xxx dB <br> xxx dB @ Vin = 0.8 V in unit buffer |
 | UGF                  | xxx MHz @ Vin = 0.8 V in unit buffer |
 | PM                   | xxx @ Vin = 0.8 V in unit buffer |
 | GM                   | xxx dB @ Vin = 0.8 V in unit buffer |
 | Output swing         | xxx V @ -3dB drop <br> xxx V @ 60dB gain |
 | CM Input range       | xxx V @ -3dB drop <br> xxx V @ 60dB gain |
 | Overshoot (r, f)     | (xxx %, xxx %) @ 10 mV step <br> (xxx %, xxx %) @ 50 mV step |
 | Settling time (r, f) | (xxx ns, xxx ns) @ 0.05% (50 mV step) |
 | Slew rate            | +xxx V/us, -xxx V/us |
 | Power dissipation    | xxx uA @ 1.8V (xxx mW) |
</div>

下表是仿真值与指标要求的对比：

<div class='center'>

<span style='font-size:12px'> 


| Type | DC Gain | GBW | PM | Slew Rate | CM Input Range | Output Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Specifications     |
 | Simulation Results |

</span>
</div>
