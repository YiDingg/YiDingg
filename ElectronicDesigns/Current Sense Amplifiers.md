# Current Sense Amplifiers

> [!Note|style:callout|label:Infor]
> Initially published at 23:36 on 2025-03-06 in Beijing.

## Infor

- Time: 2025-03-05
- Details: 
    - [General-Purpose Transistor Tester](<ElectronicDesigns/General-Purpose Transistor Tester.md>) 的电流采样部分
    - Using INA180A3, INA180A4, INA240A3 and OP07CP to design current sense amplifiers.
- Relevant Resources: 


<!-- <div class='center'>

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
 -->
## Design Notes

- [TI Data Sheet: INA240](https://www.ti.com/cn/lit/ds/symlink/ina240.pdf)
- [TI Data Sheet: INAx180](https://www.ti.com/cn/lit/ds/symlink/ina180.pdf)

### INA180

- [TI Data Sheet: INAx180](https://www.ti.com/cn/lit/ds/symlink/ina180.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-23-47-06_[Verification] INA180 and INA240 Current Sampling.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-23-48-40_[Verification] INA180 and INA240 Current Sampling.png"/></div>

设计实例：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-23-55-21_Current Sense Amplifiers.png"/></div>
 -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-23-56-17_Current Sense Amplifiers.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-23-56-38_Current Sense Amplifiers.png"/></div>

### INA240

- [TI Data Sheet: INA240](https://www.ti.com/cn/lit/ds/symlink/ina240.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-23-45-20_[Verification] INA180 and INA240 Current Sampling.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-23-45-35_[Verification] INA180 and INA240 Current Sampling.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-23-42-00_[Verification] INA180 and INA240 Current Sampling.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-23-42-07_[Verification] INA180 and INA240 Current Sampling.png"/></div>

REF 引脚连接方法：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-06-00-05-46_Current Sense Amplifiers.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-06-00-06-00_Current Sense Amplifiers.png"/></div>
 -->
 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-06-00-06-17_Current Sense Amplifiers.png"/></div>

### Using NE5532

- [TI Data Sheet: NE5532](https://www.ti.com/cn/lit/ds/symlink/ne5532.pdf)

此方案不可行（不达标）。

### Using OP07CP

- [TI Data Sheet: OP07CP](https://www.ti.com/cn/lit/ds/symlink/op07.pdf)

此设计中, OP07CP 的一些关键指标：
<div class='center'>

| Supply Range | Input Offset Voltage | Input Offset Current |
|:-:|:-:|:-:|
 | 6V\~36V (4V\~44V) | ±60uV (typ.) | ±0.8nA (typ.) |
</div>

参考 [Instrument Amplifier Using Op Amp](<Electronics/Instrument Amplifier Using Op Amp.md>), 考虑如下设计目标：

<div class='center'>

| Power Supply | Output Voltage | Gain |Voltage Dropout |
|:-:|:-:|:-:|:-:|
 | -5V, +7V | 0~5V | 100 | 0~50mV |
 | -5V, +12V | 0~10V | 100 | 0~100mV |
 | -5V, +18V | 0~15V | 100 | 0~150mV |
 | -5V, +16V | 0~30V | 100 | 0~300mV |
</div>

-5V 是为了避免过低的共模输入电压, 保持 0 输入附近的测量精度。本质上讲, 我们还是在设计一个较为精准而稳定的 100 倍电压放大器，至于 current sampling range, 通过选择合适的采样电阻即可实现。

选用 OP07CP 的另一个好处是，它的 input offset voltage 是可调的，外接一个电位器即可调节。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-06-00-31-47_Current Sense Amplifiers.png"/></div>

设计示例如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-06-00-46-44_Current Sense Amplifiers.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-06-00-46-19_Current Sense Amplifiers.png"/></div>
 -->


## Test Results

为 [General-Purpose Transistor Tester](<ElectronicDesigns/General-Purpose Transistor Tester.md>) 而设计 一共需要测试下面几种电流采样方案：

<div class='center'>



| sampling range | dropout | product | gain | V_out | R_sense | BW | slew rate |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 0 \~ 5A    | 50mV  | <span style='color:red'> INA240 A3 </span> | 100 | 0 ~ 5V | 10 mOhm   | 400KHz | 2 V/us |
 | 0 \~ 2.5A  | 50mV  | <span style='color:red'> INA240 A3 </span> | 100 | 0 ~ 5V | 20 mOhm   | 400KHz | 2 V/us |
 | 0 \~ 5mA   | 50mV  | <span style='color:red'> INA240 A3 </span> | 100 | 0 ~ 5V | 10  Ohm   | 400KHz | 2 V/us |
 | 0 \~ 500mA | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 ~ 5V | 50 mOhm  | 105KHz | 2 V/us |
 | 0 \~ 50mA  | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 ~ 5V | 500 mOhm | 105KHz | 2 V/us |
 | 0 \~ 5mA   | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 ~ 5V | 5 Ohm    | 105KHz | 2 V/us |
 | 0 \~ 500mA | 50mV | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 100 mOhm  | 150KHz | 2 V/us |
 | 0 \~ 5mA   | 50mV  | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 10 Ohm   | 150KHz | 2 V/us |


<!--  | 0 ~ 50mA  | 50mV  | <span style='color:green'> INA180 A3 </span> | 100 | 0 ~ 5V | 1 Ohm    | 150KHz | 2 V/us | -->
</div>

需要 INA180A4, INA180A3, INA240A3，以及低阻值采样电阻 10 mOhm, 30mOhm, 50mOhm 。每个电流量程都用两种方案 (三组共六套方案), 我们将在上面三组中, 每组选出一种, 作为 [General-Purpose Transistor Tester](<ElectronicDesigns/General-Purpose Transistor Tester.md>) 自带的电流采样电路。

对每一种方案，我们测试模块输入 10KHz sine wave (current signal), 10KHz RampUp (current signal) 和 10KHz Square (current signal) 的输出波形，并测量其 gain 的 bode plot (给出 3dB BW)。

下面是测试结果汇总：

<span style='color:red'> 注意：我们的电流源仅有约 400KHz 的带宽，详见 [Precision Voltage-Controlled Current Source](<ElectronicDesigns/Precision Voltage-Controlled Current Source.md>) 的测试结果 </span>

<div class='center'>

| product | gain | R_sense (R_eq) | $V_{out}$ <br> (input 10KHz Sine) | $V_{out}$ <br> (input 10KHz RampUp) | $V_{out}$ <br> (input 10KHz Square) | Frequency Response |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | INA240A3 | 100 | 10mR (1R) |  |  |  |  |
 | INA240A3 | 100 | 500mR (50R) |  |  |  |  |
 | INA240A3 | 100 | <span style='color:red'> 100R (10k) </span> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-16-49_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-18-06_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-18-32_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-23-14_Current Sense Amplifiers.png"/></div> |
 | INA180A4 | 200 | <span style='color:red'> 500mR (100R) </span> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-23-21-29_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-23-21-56_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-23-22-18_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-23-27-14_Current Sense Amplifiers.png"/></div> |
  | INA180A4 | 200 | 50mR (10R) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-46-54_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-46-42_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-47-09_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-46-11_Current Sense Amplifiers.png"/></div> |
  | INA180A4 | 200 | - |  |  |  |  |
  | INA180A3 | 100 | 100mR (10R) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-23-45-08_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-23-46-07_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-23-46-54_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-23-49-05_Current Sense Amplifiers.png"/></div> |
  | INA180A3 | 100 | <span style='color:red'> 100mR (10R) </span> (重测) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-37-45_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-39-05_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-39-22_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-40-38_Current Sense Amplifiers.png"/></div> |
  | INA180A3 | 100 | 10mR (1R) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-12-46-34_Current Sense Amplifiers.png"/></div> |  |  |  |
  | INA180A3 | 100 | <span style='color:red'> 10R (1K) </span> (这里的测试是 5mA, 后图错写成了 50mA) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-00-40_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-00-59_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-01-18_Current Sense Amplifiers.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-13-13-06-21_Current Sense Amplifiers.png"/></div> |
</div>

标红的是最终被选中的方案。