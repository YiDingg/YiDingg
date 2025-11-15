# Versatile Voltage-Controlled Power Source

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 17:58 on 2025-02-20 in Lincang.

## Infor

- Time: 2025.02.20
- Notes: 
    - 输入：OPA+ (运放正电源), OPA- (运放负电源), VCC (电流输出电源), 以及四路控制电压
    - 输出：两路电压输出，两路电流输出
- Details: 
    - 两 VSVS + 两 VSCS ，共四通道输出
    - 功率输出供电与运放供电分离
    - 电流源输出比例三档可调 (0.1, 1, 10)
- Relevant Resources: [https://www.123684.com/s/0y0pTd-3yuj3](https://www.123684.com/s/0y0pTd-3yuj3)

<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 |<div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-22-01-35-06_Versatile Voltage-Controlled Power Source.png"/></div>|<div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-22-01-35-25_Versatile Voltage-Controlled Power Source.png"/></div>|
</div>

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-22-01-35-49_Versatile Voltage-Controlled Power Source.png"/></div> | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-22-01-36-12_Versatile Voltage-Controlled Power Source.png"/></div> |
</div>


<div class='center'>

| Demo (top view)| Demo (bottom view) | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-00-00-16_Versatile Voltage-Controlled Power Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-00-00-26_Versatile Voltage-Controlled Power Source.png"/></div> |
</div>


## Design Notes

本电路是 [General VCVS and VCCS](<ElectronicDesigns/General VCVS and VCCS (up to 10 A).md>) 的改进版，分离了功率输出供电与运放供电，增加了电流源输出比例三档可调 (0.1, 1, 10)。

## Test Results

若无特别说明，下面的测试在室温 (约 25°C) 下进行，VCC = +7V, VCC_OPA+ = +12V, VCC_OPA- = -12V, frequency response 中输入信号为 1V (实际约为 1.022V) amplitude (1V offset) 的 sine wave。


<div class='center'>

| Channel | Test Condition | Output <br> (input 100KHz RampUp) | Output <br> (input 100KHz Square) | Frequency Response |
|:-:|:-:|:-:|:-:|:-:|
 | VCVS | $R_L = 10 \ \Omega$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-21-29-24_Versatile Voltage-Controlled Power Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-21-29-39_Versatile Voltage-Controlled Power Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-21-38-16_Versatile Voltage-Controlled Power Source.png"/></div> |
 | VCCS | $I_{out}\ \mathrm{(A)}  = 10*V_{in} \ \mathrm{(V)}$ <br> $R_L = 10 \ \Omega$ | - | - | - |
 | VCCS |$I_{out}\ \mathrm{(A)}  = 1*V_{in} \ \mathrm{(V)}$ <br> $R_L = 10 \ \Omega$ |  |  |  |
 | VCCS |$I_{out}\ \mathrm{(A)}  = 0.1*V_{in} \ \mathrm{(V)}$ <br> $R_L = 10 \ \Omega$ |  |  |  |
</div>

测试时发现，电流源的输出有明显振荡现象，猜测这是由 MOSFET 的寄生电容造成的。于是我们改变 MOS 的 Gate 串联电阻 (0 Ohm ~ 30KOhm)，依次测试，得到结果如下：

<div class='center'>

| $R_G = 0$ | $R_G = 10 \ \Omega$ | $R_G = 100 \ \Omega$ | $R_G = 1 \ \mathrm{KOmega}$ | $R_G = 10 \ \mathrm{KOmega}$ | $R_G = 30 \ \mathrm{KOmega}$ |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-22-03-31_Versatile Voltage-Controlled Power Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-22-06-31_Versatile Voltage-Controlled Power Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-22-04-57_Versatile Voltage-Controlled Power Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-21-58-05_Versatile Voltage-Controlled Power Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-22-02-46_Versatile Voltage-Controlled Power Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-22-01-49_Versatile Voltage-Controlled Power Source.png"/></div> |
</div>

可以看到，在 $R_G = 10 \ \Omega,\ 100 \ \Omega$ 时输出振荡较小，但效果差强人意。如何继续减小振荡，还有待进一步研究。

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-21-56-44_Versatile Voltage-Controlled Power Source.png"/></div> -->




<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-21-59-21_Versatile Voltage-Controlled Power Source.png"/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-11-22-00-29_Versatile Voltage-Controlled Power Source.png"/></div> -->


