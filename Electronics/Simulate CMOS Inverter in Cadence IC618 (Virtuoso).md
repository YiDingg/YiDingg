# Simulate the CMOS Inverter in Cadence IC618 (Virtuoso)

> [!Note|style:callout|label:Infor]
> Initially published at 17:08 on 2025-05-20 in Beijing.

## Introduction

本文以 Cadence IC618 + `smic18mmrf` 工艺库为例，仿真一个简单的 CMOS inverter, 由此介绍 Cadence IC (Virtuoso) 的基本使用流程。 

- 安装教程: [How to Install Cadence IC618](<Electronics/How to Install Cadence IC618.md>)
- 使用教程: [How to Use Cadence Efficiently](<Electronics/How to Use Cadence Efficiently.md>)


## Simulation Steps

- 打开虚拟机，输入 `virtuoso` 命令，进入 Cadence IC618 界面
- 专门创建一个 Library 用来放演示文件
    - File > New > Library
    - 输入合适的名字，比如 `Test_Examples`
    - 选择 `Attach to an existing technology library`
    - 选择工艺库 `smic18mmrf`
    - 点击 `OK`，成功创建 Library
- 在刚刚创建的 Library 中新建一个设计 (CellView)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-17-00-29_Simulate CMOS Inverter in Cadence IC618 (Virtuoso).png"/></div>

- 按下键盘上的 `I`, 弹出 Add Instance 窗口，调用 NMOS `n18`，并修改长宽参数为 `2um/180nm`；点击 `Hide` 或键盘 `Enter` 然后放置器件：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-17-06-50_Simulate CMOS Inverter in Cadence IC618 (Virtuoso).png"/></div>

- 同样的操作，再放置一个 `6um/180nm` 的 `p18`. 
- 放置一个 `analogLib` 的理想电容 `cap`, 设置为 5pF (按 `Q` 键再点击器件即可修改此器件的参数)
- 按下 `W` 绘制走线 (narrow wire), 正确连接 inverter
- 按下 `P` 设置端口 `VIN`, `VOUT`, `GND` 和 `VDD`，其中，`VIN`的 direction 设置为 `Input`，`VOUT` 设置为 `Output`，`GND` 和 `VDD` 设置为 `InputOutput`
- 点击左上角工具栏的 `Check and Save` 进行保存，应该是无 warning 无 error, 也即没有任何弹窗

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-18-27-34_Simulate CMOS Inverter in Cadence IC618 (Virtuoso).png"/></div>

- 添加激励 excitation (stimuli)
    - `Launch > ADE L > Setup > Stimuli`
    - 勾选 `VDD` 的 `Enable` 小框框，设置其为 function = dc, DC voltage = 1.8V
    - Enable `GND` 为 dc 0V
    - Enable `VIN` 为 0V 至 1.8V 的 pulse, period 1us, pulse width 0.5us

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-18-28-05_Simulate CMOS Inverter in Cadence IC618 (Virtuoso).png"/></div>

- `Setup > Model Libraries`, 设置工艺库模型信息和工艺角 (我们不作任何修改，直接 OK 即可)
- 设置仿真类型：`Analyses > Choose > tran`, stop time 为 10u, accuracy 设置为最高准确度 conservative
- 设置需要 plot 的曲线：`Outputs > To Be Plotted > Select On Design`, 点击 `VIN` 和 `VOUT`，就把这两个网络添加到了 Outputs 中。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-18-28-35_Simulate CMOS Inverter in Cadence IC618 (Virtuoso).png"/></div>

- 开始仿真：在 ADE L 中点击右侧的绿色小三角 `Netlist and Run`
- 仿真完成后自动弹出 plot 图窗，仿真成功

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-18-29-16_Simulate CMOS Inverter in Cadence IC618 (Virtuoso).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-18-32-17_Simulate CMOS Inverter in Cadence IC618 (Virtuoso).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-18-35-17_Simulate CMOS Inverter in Cadence IC618 (Virtuoso).png"/></div>

我们这里的仿真背景是黑色的，也可以改为白色，方法是：`初始界面 > Options > Cdsenv Editor > viva > graphFrame`, 然后把 `viva.graphFrame` 的 `background` 改为 `white` 即可 (默认是 `black`)。修改后记得保存，否则下次再用时又变为默认值了。其它利于提高仿真效率的设置也可以参考文章 [How to Use Cadence Efficiently](<Electronics/How to Use Cadence Efficiently.md>)。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-21-20-22-00_Simulate CMOS Inverter in Cadence IC618 (Virtuoso).png"/></div>
