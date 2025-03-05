# DC-DC Converter Modules

> [!Note|style:callout|label:Infor]
> Initially published at 18:26 on 2025-02-28 in Beijing.


## Infor

- Time: 
- Notes: 每个模块输入 VCC 和 GND, 输出 Vout
- Details: 
    - 采用模块化可拆卸设计（排针排母），方便快速安装不同的 DC-DC 转换器
    - 包括但不限于下面几个模块：TPS54331 (buck), RY8310 (buck), MT2492 (buck), MT3608 (boost) 以及 MC34063ADR (buck-boost)
    - 模块设计标准：
        - 模块倒插入总板，元件主要在背面，正面放置显眼大丝印（背面朝下，正面朝上）
        - 可调电阻在正面（方便调节）
        - 正面留出 SW 和 Vout 的 Test Point
        - 输入输出接口：输入 1x4P 排针 (VCC 和 GND)，输出 1x2P 排针 (Vout 和 GND)
        - 布局要求：水平宽 1100mil (27.94mm, 固定), 竖直高 700mil (17.78mm, 可更小), 圆角半径 40mil
        - 排针位置：输入 1x4P, 输出 1x3P, 排针左右两边竖直放置（与短边平行），底部对齐，与短边距离 0.254 mm (10mil)
        - 排针具体位置：1x4P 在左, 中心 x 60mil, 中心 y 350mil; 1x3P 在右, 中心 x 1040mil, 中心 y 300mil
        - Buck/Buck-Boost 用蓝色 LED, Boost 和 Positive-Buck-Boost 用红色 LED
- Relevant Resources: 




<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 | <div class="center">更新频率较高, 不放图片于此</div> | <div class="center">更新频率较高, 不放图片于此</div> |

</div>

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center">更新频率较高, 不放图片于此</div> | <div class="center">更新频率较高, 不放图片于此</div> |
</div>

<!-- 
<div class='center'>

| Modules | Demo (top view)| Demo (bottom view) | 
|:-:|:-:|:-:|
 | TPS54331 (buck) | <div class="center"><img height = 250px src=""/></div> | <div class="center"><img height = 250px src=""/></div> |
 | RY8310 (buck) | <div class="center"><img height = 250px src=""/></div> | <div class="center"><img height = 250px src=""/></div> |
 | MT2492 (buck) | <div class="center"><img height = 250px src=""/></div> | <div class="center"><img height = 250px src=""/></div> |
 | MT3608 (boost) | <div class="center"><img height = 250px src=""/></div> | <div class="center"><img height = 250px src=""/></div> |
 | MC34063ADR (buck-boost) | <div class="center"><img height = 250px src=""/></div> | <div class="center"><img height = 250px src=""/></div> |
</div> -->


## Design Notes

### Modules List

"multi" 标志表示此芯片可以配置为 buck, boost, buck-boost 等多种拓扑，例如 MC34063 芯片。

<div class='center'>

| Num | Modules | Type | I_out | Input | Output | Verified? |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 1 | TPS63070 RNMR | buck-boost | 2A | 2V~16V | 2V~9V | Y |
| 2 | TPS563201 DDCR | buck | 3A | 4.5V~17V | 768mV~7V | Y |
| 3 | SX1308 | boost | 1A/4A | 2V~24V | 4V~28V | Y |
| 4 | TPS5430 DDAR | buck | 3A | 5.5V~36V | 1.3V~32V | YX |
| 5 | TPS54331 | buck | 3A | 3.5V~28V | 800mV~25V |  |
| 6 | RY8310 | buck | 1A/2A | 4.5V~30V | 800mV~24.6V |  |
| 7 | MT2492 | buck | 2A/3A | 4.5V~16V | 600mV~14.7V | (同 RY8310) |
| 8 | MT3608 | boost | 1A/4A | 2V~24V | 4V~28V | (同 SX1308) |
| 9 | MC34063 ADR2G | multi | 1A/1.5A | 3.0V~40V | 1.25V~40V |  |
| 10 |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |

</div>

特别地，MC34063 可配置为多种拓扑，具体电路如下（链接 [here](https://lceda.cn/editor?lcsc_vid=ElJXVFdSElZWBFIAR1MNBgFeRlELUAEDE1hfVwICFAUxVlNSR1hdU1ZWQ1VaXztW#id=|63516121ed4e4685895664db18cdcdd2|62827c9a2b0b40f7861bfaf627b9d4aa)）：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-03-00-51-34_DC-DC Converter Modules.png"/></div>


### Buck/Buck-Boost Interface

各模块的接口网络，除了 Buck (或用作 Buck-Boost) 的模块输入接口不同，其它接口都完全相同，包括总板输入输出接口和模块输出接口。如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-03-01-15-40_DC-DC Converter Modules.png"/></div>

这样，无论是什么类型的模块，都可以直接插入总板来使用。

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-02-15-51-39_DC-DC Converter Modules.png"/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-02-15-47-58_DC-DC Converter Modules.png"/></div> -->

模块 PCB 布局示例如下：

<div class='center'>

| Layout | 3D View |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-02-18-18-56_DC-DC Converter Modules.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-02-18-19-35_DC-DC Converter Modules.png"/></div> |
 
</div>

