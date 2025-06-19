# Cadence Layout Example of The Basic Two-Stage Op Amp

> [!Note|style:callout|label:Infor]
> Initially published at 00:29 on 2025-06-19 in Beijing.

## Introduction

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


### 1.4 create layout

从 schematic 界面打开 Layout GXL, 然后进行如下基本设置：
- `Connectivity > Generate > All From Source`
    - `Generate >  > 取消勾选 PR Boundary`
    - `IO Pins > 选中所有 Pins > M1 (pin)`
    - `IO Pins > Pin Label > Create Label As "Label" > Options > Label Name > Same As Pin`
    - `IO Pins > Pin Label > Create Label As "Label" > Options > Label Purpose > Same As Pin`
- `Connectivity > Generate > Place As in Schematic` (自动排布所有器件)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-19-01-59-37_Cadence Layout Example of The Basic Two-Stage Op Amp.png"/></div>




## 2. Layout Steps

Layout 时用到的各种快捷键详见文章 [Cadence Virtuoso Layout Tutorials](<AnalogIC/Cadence Virtuoso Layout Tutorials.md>)。

### 2.1 