# Current Sense Amplifiers

> [!Note|style:callout|label:Infor]
> Initially published at 23:36 on 2025-02-26 in Beijing.

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

参考 [Instrument Amplifier Using Op Amp](<Blogs/Electronics/Instrument Amplifier Using Op Amp.md>), 考虑如下设计目标：

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


## Test Details

为 [General-Purpose Transistor Tester](<ElectronicDesigns/General-Purpose Transistor Tester.md>) 而设计 一共需要测试下面几种电流采样方案：

<div class='center'>



| sampling range | dropout | product | gain | V_out | R_sense | BW | slew rate | Input CM Voltage |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 0 \~ 5A  | 50mV  | <span style='color:red'> INA240 A3 </span> | 100 | 0 \~ 5V | 10 mOhm   | 400KHz | 2 V/us    | -4V \~ 80V |
 | 0 \~ 5A  | 150mV  | <span style='color:red'> INA240 A3 </span> | 100 | 0 \~ 5V | 30 mOhm   | 400KHz | 2 V/us   | -4V \~ 80V |
 | 0 \~ 500mA | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 \~ 5V | 50 mOhm  | 105KHz | 2 V/us  | –0.2V \~ +26V |
 | 0 \~ 50mA  | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 \~ 5V | 500 mOhm | 105KHz | 2 V/us  | –0.2V \~ +26V |
 | 0 \~ 5mA   | 25mV  | <span style='color:blue'> INA180 A4 </span> | 200 | 0 \~ 5V | 5 Ohm    | 105KHz | 2 V/us  | –0.2V \~ +26V |
 | 0 \~ 500mA | 50mV | <span style='color:green'> INA180 A3 </span> | 100 | 0 \~ 5V | 100 mOhm  | 150KHz | 2 V/us | –0.2V \~ +26V |
 | 0 \~ 50mA  | 50mV  | <span style='color:green'> INA180 A3 </span> | 100 | 0 \~ 5V | 1 Ohm    | 150KHz | 2 V/us | –0.2V \~ +26V |
 | 0 \~ 5mA   | 50mV  | <span style='color:green'> INA180 A3 </span> | 100 | 0 \~ 5V | 10 Ohm   | 150KHz | 2 V/us | –0.2V \~ +26V |
</div>

需要 INA180A4, INA180A3, INA240A3，以及低阻值采样电阻 10 mOhm, 30mOhm, 50mOhm 。每个电流量程都用两种方案 (三组共六套方案), 我们将在上面三组中, 每组选出一种, 作为 [General-Purpose Transistor Tester](<ElectronicDesigns/General-Purpose Transistor Tester.md>) 自带的电流采样电路。

对每一种方案，我们测试模块输入 100KHz sine wave (current signal) 和 100KHz RampUp (current signal) 的输出波形，并测量其 gain 的 bode plot (给出 3dB BW)。