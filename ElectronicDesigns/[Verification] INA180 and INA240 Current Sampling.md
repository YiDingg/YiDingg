# [Verification] INA180 and INA240 Current Sampling

> [!Note|style:callout|label:Infor]
> Initially published at 23:36 on 2025-02-26 in Beijing.

## Infor

- Time: 
- Notes: 
- Details: [General-Purpose Transistor Tester Transistor Tester](<ElectronicDesigns/General-Purpose Transistor Tester Transistor Tester.md>) 电流采样部分的验证版
- Interactive BOM: 
- Relevant Resources: 


<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img height = 250px src=""/></div> | <div class="center"><img height = 250px src=""/></div> |
</div>


<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 |<div class="center"><img height = 250px src=""/></div>|<div class="center"><img height = 250px src=""/></div>|

</div>

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img height = 250px src=""/></div> | <div class="center"><img height = 250px src=""/></div> |
</div>

<div class='center'>

| Demo (top view)| Demo (bottom view) | 
|:-:|:-:|
 | <div class="center"><img height = 250px src=""/></div> | <div class="center"><img height = 250px src=""/></div> |
</div>

## Design Notes

- [TI Data Sheet: INA240](https://www.ti.com/cn/lit/ds/symlink/ina240.pdf)
- [TI Data Sheet: INAx180](https://www.ti.com/cn/lit/ds/symlink/ina180.pdf)


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-23-45-20_[Verification] INA180 and INA240 Current Sampling.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-23-45-35_[Verification] INA180 and INA240 Current Sampling.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-23-42-00_[Verification] INA180 and INA240 Current Sampling.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-23-42-07_[Verification] INA180 and INA240 Current Sampling.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-23-47-06_[Verification] INA180 and INA240 Current Sampling.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-23-48-40_[Verification] INA180 and INA240 Current Sampling.png"/></div>

## Test Details

一共需要测试下面几种电流采样方案：

<div class='center'>



| sampling range | dropout | product | gain | V_out | R_sense | BW | slew rate |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 0 ~ 5A  | 50mV  | <span style='color:red'> INA240 A3 </span> | 100 | 0 ~ 5V | 10 mOhm   | 400KHz | 2 V/us |
 | 0 ~ 5A  | 150mV  | <span style='color:red'> INA240 A3 </span> | 100 | 0 ~ 5V | 30 mOhm   | 400KHz | 2 V/us |
 | 0 ~ 500mA | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 ~ 5V | 50 mOhm  | 105KHz | 2 V/us |
 | 0 ~ 50mA  | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 ~ 5V | 500 mOhm | 105KHz | 2 V/us |
 | 0 ~ 5mA   | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 ~ 5V | 5 Ohm    | 105KHz | 2 V/us |
 | 0 ~ 500mA | 50mV | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 100 mOhm  | 150KHz | 2 V/us |
 | 0 ~ 50mA  | 50mV  | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 1 Ohm    | 150KHz | 2 V/us |
 | 0 ~ 5mA   | 50mV  | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 10 Ohm   | 150KHz | 2 V/us |
</div>

需要 INA180A4, INA180A3, INA240A3，以及低阻值采样电阻 10 mOhm, 30mOhm, 50mOhm 。每个电流量程都用两种方案 (三组共六套方案), 我们将在上面三组中, 每组选出一种, 作为 [General-Purpose Transistor Tester](<ElectronicDesigns/General-Purpose Transistor Tester Transistor Tester.md>) 自带的电流采样电路。

对每一种方案，我们测试模块输入 100KHz sine wave (current signal) 和 100KHz RampUp (current signal) 的输出波形，并测量其 gain 的 bode plot (给出 3dB BW)。