# 常见 NPN 三极管特性曲线测量

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 00:22 on 2025-02-21 in Lincang.

## 前言

本文对几种较为常见的 NPN 三极管进行测试，并得到它们的 $I_{CE}-V_{CE}$ 曲线、 $I_{CE}-V_{BE}$ 曲线和 reserve (反向特性) 曲线。为了使增大（信号发生器的）输出功率，我们用一个 VCVS (Voltage Controlled Voltage Source) 进行功率放大。

如图所示，将 Adapter Board 和 Transistor Tester 连接到 AD1 [(Analog Discovery 1)](https://digilent.com/reference/test-and-measurement/analog-discovery/start) 上，依次连接待测晶体管，正确调整按钮，通过 WaveForms 软件进行测量任务。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-15-35-12_常见 NPN 三极管特性曲线测量.png"/></div>

注：由于现有的 VCVS 和 Transistor Tester 设计不够完善，3V@2A 以上的曲线，以及 Transfer Characteristics 暂时无法得到，待更换新的 VCVS 电路后再行补充。

## 2SC1318 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-15-29-16_常见 NPN 三极管特性曲线测量.png"/></div>

<div class='center'>

| [Static Chara](https://item.szlcsc.com/datasheet/2SC1318/20529143.html) | Experiment Result |  Experiment Result (detail) |
|:-:|:-:|:-:|
 | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-26-27_常见 NPN 三极管特性曲线测量.png"/></div> | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-26-05_常见 NPN 三极管特性曲线测量.png"/></div> | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-23-39_常见 NPN 三极管特性曲线测量.png"/></div> |
</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-37-44_常见 NPN 三极管特性曲线测量.png"/></div>


## SS8050

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-15-29-42_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-46-12_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-46-48_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-47-19_常见 NPN 三极管特性曲线测量.png"/></div>

## 2N3904
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-15-29-53_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-53-57_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-54-25_常见 NPN 三极管特性曲线测量.png"/></div>


## BC547C
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-15-29-31_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-41-01_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-41-47_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-43-47_常见 NPN 三极管特性曲线测量.png"/></div>

## BC549B
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-15-30-02_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-01-59-36_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-02-00-42_常见 NPN 三极管特性曲线测量.png"/></div>

## BC550C
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-15-30-14_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-02-03-26_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-02-02-51_常见 NPN 三极管特性曲线测量.png"/></div>

## BC550B
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-15-30-23_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-02-05-40_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-02-06-10_常见 NPN 三极管特性曲线测量.png"/></div>

## MJE13001
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-15-30-33_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-15-14-10_常见 NPN 三极管特性曲线测量.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-21-15-14-48_常见 NPN 三极管特性曲线测量.png"/></div>























<!-- 
<div class='center'>

| [Static Chara]() | Experiment Result |  Experiment Result (detail) |
|:-:|:-:|:-:|
 | <div class="center"><img width = 400px src=""/></div> | <div class="center"><img width = 400px src=""/></div> | <div class="center"><img width = 400px src=""/></div> |
</div>






## 

<div class='center'>

| [Data Sheet]() | Experiment Result | 
|:-:|:-:|
 | <div class="center"><img width = 400px src=""/></div> | <div class="center"><img width = 400px src=""/></div> |
</div> -->