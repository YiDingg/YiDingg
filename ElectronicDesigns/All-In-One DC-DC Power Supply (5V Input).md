# All-In-One DC-DC Power Supply (5V~12V Input)

> [!Note|style:callout|label:Infor]
Initially published at 18:18 on 2025-02-15 in Lincang.

## Infor


- Time: 2025.02.15
- Notes:
    - Input: +5V ~ +12V
    - Output: 4 channels in total (guaranteed 2A per channel)
- Details: 
    - 共四路输出，可覆盖 ±3V ~ ±15V 输出范围
    - 多种输入接口：排针排母、 USB 、接线端子和 DC005母座
    - 两种输出接口：排针排母和接线端子
    - 配有电源总开关，且每一路都有单独控制开关
    - 配有电源输入指示灯，且每一路都有输出指示灯
    - 适用于 ±5V 和 ±12V (3A 以内电流) 输出场景
    - 适用于运放供电
    - 四通道共四枚 DC-DC 芯片的价格仅 1 元, 整板成本约 5 元
- Relevant Resources: [https://www.123684.com/s/0y0pTd-lquj3](https://www.123684.com/s/0y0pTd-lquj3)

<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 |<div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-18-23-40-47_All-in-one DC-DC Power Supply (5V Input).png"/></div>|<div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-18-23-42-25_All-in-one DC-DC Power Supply (5V Input).jpg"/></div>|
</div>

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-18-23-43-18_All-in-one DC-DC Power Supply (5V Input).png"/></div> | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-18-23-43-35_All-in-one DC-DC Power Supply (5V Input).png"/></div> |
</div>

<div class='center'>

| Demo (Top view) | Demo (Bottom view) | 
|:-:|:-:|
 | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-02-13-25-31_All-In-One DC-DC Power Supply (5V Input).png"/></div> | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-02-13-21-56_All-In-One DC-DC Power Supply (5V Input).png"/></div> |
</div>



## Output Test Results

我们分别测试了四个通道的输出纹波和开关波形，结果如下 (输入 +5V, 室温)：
<div class="center"><img width = 500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-02-12-45-46_All-In-One DC-DC Power Supply (5V Input).png"/></div>


<div class='center'>

 | Channel | DC-DC Chip | Actual Output Range <br> (Input +5V) | Test Condition | Output Voltage Ripple  | SW Waveform |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | CH1 (+3V ~ +8V) | TPS63070 RNMR | +2.90V ~ +8.57V | +5V@15Ohm | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-33-18_All-In-One DC-DC Power Supply (5V Input).png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-36-05_All-In-One DC-DC Power Supply (5V Input).png"/></div> |
 | CH2 (-3V ~ -7V) | TPS563201 DDCR | -3.08V ~ -7.22V | +5V@15Ohm | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-37-53_All-In-One DC-DC Power Supply (5V Input).png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-38-46_All-In-One DC-DC Power Supply (5V Input).png"/></div> |
 | CH3 (+8V ~ +16V) | SX1308 | +7.68V ~ +16.8V | +12V@15Ohm | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-14-45-43_All-In-One DC-DC Power Supply (5V Input).png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-14-44-01_All-In-One DC-DC Power Supply (5V Input).png"/></div> |
 | CH4 (-3V ~ -16V) | TPS5430 DDAR | -2.7V ~ -16.2V | -12V@15Ohm | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-02-29_DC-DC TPS5430DDAR 输出异常记录.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-03-53_DC-DC TPS5430DDAR 输出异常记录.png"/></div> |

</div>


<!-- LM2596S-ADJ SW 波形：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-14-02-37_All-In-One DC-DC Power Supply (5V Input).png"/></div> -->


## Design Notes


### Design Requirements

- 输入 +5V（+3V 至 +10V）
- 输出 ±5V 和 ±12V 至少四路电压，每一路有至少 2 A 的持续输出能力（峰值电流至少 3A）
- 考虑是否再添加 0 ~ ±15V 可调输出，用于运放供电


### Output +5V (TPS63070)

采用 buck-boost [TPS63070](https://www.ti.com/cn/lit/ds/symlink/tps63070.pdf)，下面是参考电路及其参数。

+5V 输出参考（注意 TPS63070 输出电压可调，但是 TPS630701 输出电压固定 +5V）：
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-22-24-06_All-in-one DC-DC Power Supply (5V Input).png"/></div>
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-22-24-54_All-in-one DC-DC Power Supply (5V Input).png"/></div>
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-22-26-06_All-in-one DC-DC Power Supply (5V Input).png"/></div>

Adjustable 输出参考：
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-22-26-53_All-in-one DC-DC Power Supply (5V Input).png"/></div>
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-22-27-08_All-in-one DC-DC Power Supply (5V Input).png"/></div>

电感参数选择：
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-22-24-10_All-in-one DC-DC Power Supply (5V Input).png"/></div>

我们选用 Adjustable 参考电路，电感选用 1.5uH (CD54, DCR < 25mOhm, I_sat 4.8A)，反馈电阻选择 $R_2 = 1.3 \ \mathrm{K\Omega}$，$R_1$ 为 10K电位器 + 3.3K定值，这样输出电压可在 3V~9V 间调节，如下图所示：
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-22-53-57_All-in-one DC-DC Power Supply (5V Input).png"/></div> 

上面这种做法是将 10K电位器作为一个 0~10K 的可变电阻，以此调节实际 $R_1$ 的值。我们也可以采用另一种做法，即将电位器的三个引脚都利用上，如下图所示：
<!-- <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-23-04-38_All-in-one DC-DC Power Supply (5V Input).png"/></div> -->
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-23-08-51_All-in-one DC-DC Power Supply (5V Input).png"/></div>

这种接法在低功耗电路中更常见，它可以显著减小反馈电阻上消耗的功率。对应需要的 $R_1$ 和 $R_2$ 为：
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-23-05-47_All-in-one DC-DC Power Supply (5V Input).png"/></div>

考虑 0603 电阻的规格，我们可以选用 $R_1 = 39K$ 和 $R_2 = 5K$。

### Output -5V (TPS563201)

采用 buck [TPS563201](https://item.szlcsc.com/datasheet/TPS563201DDCR/117846.html)。我们的主要目的是 `inverting buck +5V to -5V`，这等价于 `buck +10V to +5V`，下面是参考电路及其参数：

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-23-38-01_All-in-one DC-DC Power Supply (5V Input).png"/></div>
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-23-40-25_All-in-one DC-DC Power Supply (5V Input).png"/></div>
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-23-41-17_All-in-one DC-DC Power Supply (5V Input).png"/></div>
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-23-58-06_All-in-one DC-DC Power Supply (5V Input).png"/></div>

输入 TPS563201 的电压范围与限制条件，计算得到 inverting buck 的输出电压范围如下：
<!-- <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-23-45-33_All-in-one DC-DC Power Supply (5V Input).png"/></div> -->
<!-- <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-01-35-22_All-in-one DC-DC Power Supply (5V Input).png"/></div> -->
<!-- <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-01-40-43_All-in-one DC-DC Power Supply (5V Input).png"/></div>
 -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-14-10-34_All-in-one DC-DC Power Supply (5V Input).png"/></div>

因此，我们直接设计一个 `buck: input 10V (3V ~ 12V), output 5V` 即可。依照上面小节的第二种反馈电阻接法（利用电位器的全部引脚），我们有：
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-23-53-31_All-in-one DC-DC Power Supply (5V Input).png"/></div>
这等价于 inverting buck 的输出在 -7V ~ -3V 间可调。

### Output +12V (SX1308)

考虑 boost [SX1308](https://item.szlcsc.com/79296.html)。我们的主要目的是 `boost +5V to +12V`，下面是参考电路及相关参数：
<!-- <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-00-22-09_All-in-one DC-DC Power Supply (5V Input).png"/></div> -->
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-00-23-48_All-in-one DC-DC Power Supply (5V Input).png"/></div>
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-00-24-19_All-in-one DC-DC Power Supply (5V Input).png"/></div>

计算反馈电阻：
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-00-26-00_All-in-one DC-DC Power Supply (5V Input).png"/></div>

选用 4.7uH 电感，33uF 的输入输出电容， Schottky 二极管选用 SS34 (550mV@3A) 或 1N5822 (525mV@3A)。



### Output -12V (TPS5430)

考虑 buck [TPS5430](https://www.ti.com/cn/lit/ds/symlink/tps5430.pdf)。目的是 `inverting buck +5V to -12V`，这等价于 `buck +17V to +12V`，参考电路及相关参数如下：

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-01-16-11_All-in-one DC-DC Power Supply (5V Input).png"/></div>

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-01-17-45_All-in-one DC-DC Power Supply (5V Input).png"/></div>

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-01-18-31_All-in-one DC-DC Power Supply (5V Input).png"/></div>

计算从 buck 到 inverting buck 的电压限制：
<!-- <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-01-25-15_All-in-one DC-DC Power Supply (5V Input).png"/></div> -->
<!-- <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-01-32-45_All-in-one DC-DC Power Supply (5V Input).png"/></div> -->
<!-- <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-01-41-19_All-in-one DC-DC Power Supply (5V Input).png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-14-09-01_All-in-one DC-DC Power Supply (5V Input).png"/></div>

计算反馈电阻：
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-01-50-49_All-in-one DC-DC Power Supply (5V Input).png"/></div>

Schottky 二极管选用 SS34 (550mV@3A)、B340A (550mV@3A) 或 1N5822 (525mV@3A)。

下面是利用 TI WEBENCH 工具定制的设计方案（点击 [here](https://webench.ti.com/power-designer/switching-regulator?base_pn=TPS5430&origin=ODS&litsection=application)，利用 Filter by Part Number 搜搜想使用的器件）：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-02-11-58_All-in-one DC-DC Power Supply (5V Input).png"/></div>

还可以进行仿真操作 [here](https://webench.ti.com/power-designer/switching-regulator/simulate/2?noparams=0)：
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-02-17-19_All-in-one DC-DC Power Supply (5V Input).png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-17-02-18-49_All-in-one DC-DC Power Supply (5V Input).png"/></div>