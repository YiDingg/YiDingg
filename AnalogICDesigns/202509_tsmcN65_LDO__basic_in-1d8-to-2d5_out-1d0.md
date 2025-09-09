# 202509_tsmcN65_LDO__in-1d8-to-2d5_out-1d0

> [!Note|style:callout|label:Infor]
> Initially published at 23:11 on 2025-09-09 in Lincang.


## Introduction

本文是项目 [2025.09 Design of A Basic Low Dropout Regulator (LDO)](<Projects/Design of A Basic Low Dropout Regulator (LDO).md>) 的附属文档，用于记录 LDO 的设计和前仿过程。

甲方给出的 LDO 设计指标如下：

<div class='center'><span style='font-size: 12px'>

| Parameter | Process | Supply Range | Output Voltage | Output Current | Settling Time | Overshoot | Linear Regulation | Load Regulation | PSRR |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | **Specification** | TSMC 65nm CMOS | 1.8 V ~ 2.8 V | xxx mA ~ xxx mA  (nominal xxx mA) | 1.0 V | xxx ns | mV (xx%) | xx uV/V | xx nV/mA | xx dB @ DC <br> xx dB @ 100 kHz |

</span>
</div>

## 1. Design Considerations

### 1.1 reference formulas

本次设计所用 LDO 架构及主要参考公式如下 (Design sheet for basic LDO)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-01-12-08_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0 copy.png"/></div>

注意 NMOS as the pass transistor 时，$V_{REF}$ 要接运放的 noninverting 端才是负反馈。


### 1.2. op amp specs





## 2. Design of Op Amp

设计和前仿见这篇文章 [202509_tsmcN65_OpAmp__nulling-Miller](<AnalogICDesigns/202509_tsmcN65_OpAmp__nulling-Miller.md>)，版图与后仿见这篇文章 [202509_tsmcN65_OpAmp__nulling-Miller__layout](<AnalogICDesigns/202509_tsmcN65_OpAmp__nulling-Miller__layout.md>)。


## 3. Design of LDO



## 4. Pre-Simulation

下面几个小节中的仿真条件是指：
- all-corner = {(TT, 27°C), (SS, -45°C), (FF, 125°C), (SF, 125°C), (FS, -45°C)}
- all-supply = {1.6 V, 2.15 V, 2.7 V}

### 4.1 (dc) output voltage (all-corner, all-supply)
### 4.2 (ac) linear regulation (all-corner, 2.15 V)
### 4.3 (ac) load regulation (all-corner, 2.15 V)
### 4.4 (tran) start-up response (TT, 2.15 V)
1V/ns and 1V/us

### 4.5 (tran) step response (TT, 2.15 V)
xx uA step and xx mA step.

### 4.6 (mc) output voltage (2.15 V)


## 4.xx pre-simul summary

上面的前仿结果汇总在下表：

<div class='center'><span style='font-size: 12px'>

| Parameter | Process | Supply Range | Output Voltage | Output Current | Settling Time | Overshoot | Linear Regulation | Load Regulation | PSRR |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | **Specification** | TSMC 65nm CMOS | 1.8 V ~ 2.8 V | xxx mA ~ xxx mA  (nominal xxx mA) | 1.0 V | xxx ns | mV (xx%) | xx uV/V | xx nV/mA | xx dB @ DC <br> xx dB @ 100 kHz |
 | **Pre-Simulation** | TSMC 65nm CMOS | 1.8 V ~ 2.8 V | xxx mA ~ xxx mA  (nominal xxx mA) | 1.0 V | xxx ns | mV (xx%) | xx uV/V | xx nV/mA | xx dB @ DC <br> xx dB @ 100 kHz |

</span>
</div>


后续的 layout and post-layout simulation 详见这篇文章 [202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0__layout](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.md>)。
