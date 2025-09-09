# 202509_tsmcN65_OpAmp__nulling-Miller

> [!Note|style:callout|label:Infor]
> Initially published at 23:11 on 2025-09-09 in Lincang.


## Introduction

本文是项目 [2025.09 Design of A Basic Low Dropout Regulator (LDO)](<Projects/Design of A Basic Low Dropout Regulator (LDO).md>) 的附属文档，用于记录 LDO 内部运放的设计和前仿过程。

本文，我们借助 [gm-Id](<AnalogIC/Virtuoso Tutorials - 5. An Introduction to gm-Id Methodology.md>) 方法，使用台积电 65nm CMOS 工艺库 `tsmcN64` 来完整地设计一个 **basic two-stage op amp with nulling-Miller compensation**，**<span style='color:red'> 并完成前仿、版图、验证和后仿工作。 </span>** 

## 1. Design Considerations

我们已经在 [这篇文章](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.md>) 中给出了运放的设计指标：

<span style='font-size:12px'>
<div class='center'>

| Load | DC Gain | GBW | PM | SR | ICMR | Swing | Power Dissipation | Process Corner |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | xx pF | xx dB | xx MHz | 65° | xx V/us | (xx mV, xx mV) = xx mV | (xx mV, xx mV) = xx mV | xx uA @ 1.6 V (1.6 V ~ 2.7 V) | (TT, 27°C), (SS, -45°C), (FF, 125°C), (SF, 125°C), (FS, -45°C) |
</div>
</span>


### 2.1 (n) M1 ~ M2, M5, M7

根据 gm/Id 找出各管子的 I_nor, 由此确定长宽比 a = W/L:

### 2.2 (p) M3 ~ M4, M6

根据 gm/Id 仿真结果，找出各管子的 I_nor, 由此确定长宽比 a = W/L:


### 2.3 biasing circuit

Biasing circuit 仍采用上次 [TSMC 28nm](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller.md>) 中的结构，**但为了保证运放在 1.6 V ~ 2.7 V 下都能正常工作，我们需要对启动电路进行一些修改。**

