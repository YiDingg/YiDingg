# Voltage Source with Ammeter

> [!Note|style:callout|label:Infor]
> Initially published at 20:41 on 2025-03-13 in Beijing.

## Infor

- Time: 2025.03.13
- Notes: 自带电流检测的压控电源 (VCCS)，由常规 [VCVS](<ElectronicDesigns/Versatile Voltage-Controlled Power Source.md>) 电路 (或者说 [Precision Voltage-Controlled Current Source](<ElectronicDesigns/Precision Voltage-Controlled Current Source.md>)) 修改而来。
- Details:
    - 可选择 10Ohm\~100KOhm (内置) 电流检测电阻, 在消耗 5V voltage headroom 的情况下，电流检测量程为 0\~50uA, 0\~500uA, ..., 0\~500mA
    - 在常规测量任务中表现出较高的精度, 例如：
        - 使用 100KOhm 时 (作为运放外围电阻), (理论) 电流精度为 0\~200mA (error = 0 \~ -25uA or 0\% \~ -0.0125\%) 和 0\~2mA (error = 0 \~ -5uA or 0 \% \~ -0.25\%)
        - 使用 10KOhm 时 (作为运放外围电阻), (理论) 电流精度为 0\~200mA (error = 0 \~ -250uA or 0\% \~ -0.125\%) 和 0\~2mA (error = 0 \~ -50uA or 0 \% \~ -2.5\%)
    - 留有排针接口, 可外接 (低 dropout) 电流表，例如搭配 [Current Sense Amplifiers](<ElectronicDesigns/Current Sense Amplifiers.md>) 使用
- Relevant Resources:

<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-00-01-33_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-00-01-59_Voltage Source with Ammeter.png"/></div> |
</div>

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-00-02-30_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-00-02-59_Voltage Source with Ammeter.png"/></div> |
</div>


<div class='center'>

| Demo (top view)| Demo (bottom view) | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-13-14-24_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-13-14-37_Voltage Source with Ammeter.png"/></div> |
</div>


## Design Notes

设计思路如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-20-51-12_Voltage Source with Ammeter.png"/></div>
<!-- 
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-20-46-47_Voltage Source with Ammeter.png"/></div>
 -->

## Test Results

若无特别说明，下面的测试在室温 (约 25°C) 下进行，VCC = VCC_OPA+ = +12V, VCC_OPA- = -12V, frequency response 中输入信号为 1V (实际约为 1.022V) amplitude (2V offset) 的 sine wave。


<div class='center'>

| Op Amp | Test Condition | Output <br> (input 100KHz Sine) | Output <br> (input 100KHz RampUp) | Output <br> (input 100KHz Square) | Frequency Response |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | NE5532P | $R_L = 100 \ \mathrm{\Omega}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-01-12-01_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-01-11-42_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-01-10-59_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-01-07-23_Voltage Source with Ammeter.png"/></div> |
  | NE5532P | $R_L = 100 \ \mathrm{\Omega}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-00-54-18_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-00-53-59_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-00-53-29_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-00-52-00_Voltage Source with Ammeter.png"/></div> |
  | LM258P | $R_L = 100 \ \mathrm{\Omega}$ <br> (这里是 258, 后面两图错写为 358) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-00-59-27_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-00-59-47_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-01-00-04_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-00-58-45_Voltage Source with Ammeter.png"/></div> | 
  | JRC4558D | $R_L = 100 \ \mathrm{\Omega}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-01-03-01_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-01-03-59_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-01-02-39_Voltage Source with Ammeter.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-01-05-16_Voltage Source with Ammeter.png"/></div> | 
  |  | $R_L = 100 \ \mathrm{\Omega}$ |  |  |  |  | 
  |  | $R_L = 100 \ \mathrm{\Omega}$ |  |  |  |  | 
</div>

