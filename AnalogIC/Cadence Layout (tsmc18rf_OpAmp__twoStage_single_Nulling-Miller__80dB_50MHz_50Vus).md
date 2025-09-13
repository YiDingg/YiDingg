# Cadence Layout Example (tsmc18rf_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus)

> [!Note|style:callout|label:Infor]
> Initially published at 00:29 on 2025-06-19 in Beijing.

## Introduction

本文是 analog ic design [A Basic Two-Stage Nulling-Miller Compensation Op Amp with 80 dB Gain, 50 MHz UGF and 50 V/us SR at 5pF Load (Simulated 84.35 dB, 55.75 MHz and +56.31/-45.35 V/us)](<AnalogICDesigns/202506_tsmc18rf_OpAmp__twoStage_single_Nulling-Miller__80dB_50MHz_50Vus.md>) 的 layout example, 主要是为了展示如何在 Cadence Virtuoso 中进行基本的 layout 操作。

## 1. Basic Setup

### 1.1 choose capacitor

**打开 schematic, 将理想电容换为 `tsmc18rf` 库中的 `mimcap_m4`。由于单个 `mimcap_m4` 电容最大只能有 0.95 pF 左右，因此考虑两个 0.835 pF 并联得到 Cc =  1.67 pF.**下图是 `tsmc18rf` 工艺库中所包含的 capacitor 和 resistor 器件：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-19-01-39-15_Cadence Layout Example of The Basic Two-Stage Op Amp.png"/></div>





### 1.2 choose resistor

下图是 `tsmc18rf` 工艺库中所包含的 resistor 器件：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-19-01-39-02_Cadence Layout Example of The Basic Two-Stage Op Amp.png"/></div>

它们之间的区别和用途为 (2025.06.19 由 DeepSeek 生成):

**(1) 金属电阻（Metal Resistor）**

<div class='center'>

| **Cell Name** | **材料/结构**       | **特点**                                                                 | **适用场景**               |
|--------------|---------------------|--------------------------------------------------------------------------|---------------------------|
| `rm1` ~ `rm5`| 金属层（Metal1~5）  | 低阻值（~0.1Ω/□）、温度系数小，但精度低（±20%）。                        | 电源布线、ESD保护         |
| `rmt`        | 顶层金属（Top Metal）| 高频损耗小，寄生电容低。                                                | RF匹配网络、电感串联电阻  |

</div>

**(2) 多晶硅电阻（Poly Resistor）**

<div class='center'>

| **Cell Name**       | **掺杂类型**        | **特点**                                                                 | **适用场景**               |
|----------------------|---------------------|--------------------------------------------------------------------------|---------------------------|
| `rnhpoly`            | N+ 高掺杂多晶硅     | 低阻值（~50Ω/□），温度系数较高，匹配性一般。                             | 数字电路、一般偏置        |
| `rnhpoly_dis`        | N+ 高掺杂（可调）   | 可调整尺寸，匹配性稍好。                                                | 需要参数化的设计          |
| `rphpoly`            | P+ 高掺杂多晶硅     | 类似 `rnhpoly`，但极性相反。                                             | CMOS对称设计             |
| `rphpoly_rf`         | P+ 高掺杂（RF优化） | 高频寄生电容小，Q值高。                                                  | RF电路（如VCO）          |
| `rplpoly`            | P- 轻掺杂多晶硅     | 高阻值（~1kΩ/□），温度系数低，精度高（±10%）。                           | 高精度模拟电路（如ADC）  |

</div>

**(3) 扩散区/阱电阻（Diffusion/Well Resistor）**


<div class='center'>

| **Cell Name** | **材料/结构**       | **特点**                                                                 | **适用场景**               |
|--------------|---------------------|--------------------------------------------------------------------------|---------------------------|
| `rnplus`     | N+ 扩散区           | 低阻值（~50Ω/□），但寄生电容大，漏电高。                                 | 非关键路径                |
| `rnwell`     | N阱                 | 高阻值（~1kΩ/□），温度系数大，匹配性差。                                 | 高压或隔离电阻            |
| `rnwod`      | N阱（深掺杂）       | 阻值更低，寄生效应更小。                                                | 改进版阱电阻              |

</div>

**(4) 特殊用途电阻**

<div class='center'>

| **Cell Name**       | **用途**            | **特点**                                                                 |
|----------------------|---------------------|--------------------------------------------------------------------------|
| `rnIplus` / `rplplus`| 离子注入电阻        | 高精度，低温度系数，但需要额外工艺步骤。                                |
| `rphripoly`          | 高阻值P+多晶硅      | 用于超高压或高阻需求（如分压网络）。                                    |
| `*_dis` 后缀         | 可调尺寸（Discrete）| 支持参数化调整宽度/长度，匹配性更好。                                   |
| `*_rf` 后缀          | RF优化              | 减少高频寄生效应，提升Q值。                                             |


</div>


**总结：TSMC18RF 电阻推荐**

<div class='center'>

| **场景**                | **推荐电阻**       | **理由**                              |
|-------------------------|--------------------|---------------------------------------|
| 常规模拟电路            | `rphpoly`/`rnhpoly`| 平衡精度和面积                        |
| 高精度基准/ADC          | `rplpoly`          | 低温漂、高匹配性                      |
| 高频/RF电路             | `rphpoly_rf`/`rmt` | 低寄生、高 Q 值                         |
| 电源网络/ESD            | `rm1`/`rnplus`     | 低阻值、低成本                        |

</div>


**总结：按阻值推荐模型**

<div class='center'>

| **阻值范围**   | **推荐模型**          | **关键优势**                          |
|----------------|-----------------------|---------------------------------------|
| **< 100 Ω**      | `rm1`~`rm5`, `rnplus` | 低阻值、低成本                        |
| **100 Ω ~ 1 kΩ**   | `rnhpoly`, `rphpoly`  | 平衡精度和面积                        |
| **1 kΩ ~ 100 kΩ**  | `rplpoly`             | 高精度、低温漂                        |
| **> 100 kΩ**     | `rnwell`, `rphripoly` | 超高阻值实现                          |
| **高频/RF**    | `rmt`, `*_rf`         | 低寄生、高Q值                         |

</div>

我们将两个理想电阻替换为了 `rnhpoly` 电阻，并设置其 segment width/length 为 2u/8.2u, 这样可以得到 1.29512 kOhm 的电阻值。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-19-01-57-29_Cadence Layout Example of The Basic Two-Stage Op Amp.png"/></div>

### 1.3 choose multiplier

**并且，需要修改原理图中部分 width 过长晶体管的 multiplier, 否则 layout 工作难以进行。** 具体而言，我们修改了：
- Mb3 : width = 528u = 132u\*4
- M6 : width = 370u = 92.5u\*4
- M7 : width = 400u = 100u\*4

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-19-01-37-29_Cadence Layout Example of The Basic Two-Stage Op Amp.png"/></div>

注：事实上，将近 100 um 的 unit width 仍然是非常大的，我们在实际中可能需要更多的 multiplier 以降低 width. 但是，作为一个 "layout example", 我们只需给出 layout 的基本思路和方法，因此便不进一步增大 multiplier 了。

### 1.4 create layout

从 schematic 界面打开 Layout GXL, 然后进行如下基本设置：
- `Connectivity > Generate > All From Source`
    - `Generate >  > 取消勾选 PR Boundary`
    - `IO Pins > 选中所有 Pins > M1 (pin)`
    - `IO Pins > Pin Label > Create Label As "Label" > Options > Label Name > Same As Pin`
    - `IO Pins > Pin Label > Create Label As "Label" > Options > Label Purpose > Same As Pin`
- `Connectivity > Generate > Place As in Schematic` (自动排布所有器件)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-19-01-59-37_Cadence Layout Example of The Basic Two-Stage Op Amp.png"/></div>




## 2. Layout Details



Layout 时用到的各种快捷键详见文章 [Cadence Virtuoso Layout Tutorials](<AnalogIC/Virtuoso Tutorials - 7. Cadence Layout Tutorials.md>)，下面是几个最基本的快捷键：
- `f`: 适合窗口 (Fit to View) 
- `Shift + f`: 显示器件详细样式
- `Ctrl + f`: 不显示器件详细样式
- `r`：绘制矩形 (Rectangle) 
- `p`：绘制路径 (Path) 
- `c`：复制 (Copy) 
- `m`：移动 (Move) 
- `q`：属性编辑 (Property) 
- `k`：直尺 (Ruler) 
- `shift + k`: 删除所有 ruler
- `shift + o`: rotate

下面参考 [this video](https://www.bilibili.com/video/BV1r24y1f7kP) 进行基本的 layout 操作。

### 2.0 Add Dummy

添加 dummy 管, nmos dummy 端口都连接 VSS, pmos dummy 端口都连接 VDD. 

### 2.1 器件布局

`Connectivity > Generate > Place As in Schematic` (按原理图结构排布所有器件)。可以适当修改 display style, 使得 layout 界面更清晰：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-15-50-32_Cadence Layout Example of The Basic Two-Stage Op Amp.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-15-49-42_Cadence Layout Example of The Basic Two-Stage Op Amp.png"/></div>

在我们的工艺库 (tsmc18rf), align 对齐时所设置的距离就是外边界的距离 (unit: um), 有的工艺库可能是有源区的距离。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-16-00-17_Cadence Layout Example of The Basic Two-Stage Op Amp.png"/></div>

依次对各组晶体管进行 “对齐 + 组合” 操作：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-18-48-56_Cadence Layout Example of The Basic Two-Stage Op Amp.png"/></div>

一些细节的东西，像如何摆放晶体管可以提高匹配性 (ABAB 之类的)，比较进阶且繁琐，我们在本文不涉及。等后续专门写一篇/几篇文章来介绍。

### 2.2 金属连接


这一步包括各种 via, guard ring 和 metal connection 等，关于如何创建 guard ring template, 参考文章 [Cadence Virtuoso Layout Tutorials](<AnalogIC/Virtuoso Tutorials - 7. Cadence Layout Tutorials.md>)

1. Gate to `METAL1`: 
    - (1) 点击工具栏中的 `Transparent Group`, 暂时隐藏所有 group 关系，然后在各 mos 的 gate 处添加 M1_POLY1 的 via, 将 gate 连接到 M1 (metal 1) 金属层
    - (2) 这一步可以利用阵列复制来提高效率
    - (3) 对于 gate 两端较长的晶体管 (width 较长), 可以考虑在两端都添加 via 连接到 M1



2. 金属连线
    - 依据“奇数层 (M1, M3, ...) 走竖线，偶数层 (M2, M4, ...) 走横线”的原则，对电路进行连接
    - 走线时需注意尽量减少寄生电容和电感，并且大电流支路的走线不能太窄




3. Add guard ring: 对每一组 nmos/pmos 都添加一个 guard ring, 注意 nmos guard ring 连接到 VSS, pmos guard ring 连接到 VDD. 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-19-54-46_Cadence Layout Example of The Basic Two-Stage Op Amp.png"/></div>


### 2.3 衬底与阱



### 2.4 IO Pad and ESD


<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-15-30-32_Cadence Layout Example of The Basic Two-Stage Op Amp.png"/></div> -->


## 3. DRC and LVS


### 3.1 DRC 


将 Calibre 集成到 Cadence Virtuoso 工具栏：
``` bash
; 将 Calibre 集成到 Cadence Virtuoso 工具栏
skillPath=getSkillPath();
setSkillPath(append(skillPath list("/opt/eda/mentor/calibre2019/aoj_cal_2019.3_15.11/lib"))); the installing path of your Calibre
load("calibre.OA.skl");
```

重新打开 layout 界面，点击工具栏上的 `Calibre`，选择 design rule check file, 然后 `Run DRC`。如果 inputs 一栏中的 `Layout File` 和 `Top Cell` 没有正确显示，关闭并重新打开 `Calibre` 即可。

如果遇到报错：

``` bash
ERROR: Specified primary cell xxx is not located within the input layout database.
```

大概率是 cellview 的名称中使用了小数点 `.` 或连字符 `-`，将 cellview 重命名之后即可解决 (from [this article](https://bbs.eetop.cn/thread-616018-3-1.html))。我们一开始就是因为 cellview 的名称中含有连字符 `-` 从而报错，修改后即可正常 Run DRC.

双击错误可以高亮，如果觉得高亮不明显，可以随便选择一个 layer 然后 `NV` 隐藏其它层。

如果只想看 DRC 的错误，点击左上角的 `filter > show unresolved`。可以到 design rule 的文档中搜索错误代码具体是指哪些错误，下面是几个常见的 DRC 错误：
- `NW.S.1 { @ Minimum different potential NWEL space < 1.40`: 报错说不同电位的 nwell 距离小于了 1.40 um, 通常是一组 pmos 直接 nwell 间距过小导致的，用一个大的 nwell 包含整个 pmos 组 (包括 guard ring) 即可解决
- `PP.R.1_NP.R.1 { @ PP and NP not allowed to overlap`

2025.06.21 00:52, layout 暂时到这里吧，没有人带真的太慢了。 

file:///opt/eda/mentor/calibre2019/aoj_cal_2019.3_15.11/docs/pdfdocs/calbr_admin_gd.pdf