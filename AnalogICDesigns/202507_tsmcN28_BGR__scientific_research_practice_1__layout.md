# Layout and Post-Simulation for 202507_tsmcN28_BGR__scientific_research_practice_1

> [!Note|style:callout|label:Infor]
> Initially published at 20:15 on 2025-07-26 in Beijing.

本次科研实践相关链接：
- [Scientific Research Practice 1 (Low-Voltage BGR)](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>)
    - [Design of the Low-Voltage Bandgap Reference (BGR)](<AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1.md>)
        - [Design of the Op Amp for Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller.md>)
        - [Layout of the Op Amp for Low-Voltage BGR](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller__layout.md>)
    - [(本文) Layout of  the Low-Voltage Bandgap Reference (BGR)](<AnalogIC/Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).md>)


## 1. General Considerations


### 1.0 Overview

本文，我们将对 `tsmcN28` 工艺下设计的 low-voltage BGR [A Low-Voltage Bandgap Reference (BGR) in 28nm CMOS Technology](<AnalogICDesigns/202507_tsmcN28_BGR__scientific_research_practice_1.md>) 进行版图设计，并完成后续一系列工作，这包括：
- Layout (版图设计)
- DRC (设计规则检查)
- LVS (版图与原理图比对)
- PEX (寄生参数提取)
- Post-Layout Simulation (后仿真)

整个 layout 过程可以参考 [202507_tsmcN28_OpAmp__nulling-Miller__layout](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller__layout.md>).

### 1.1 Configure Settings

为提高 layout 设计效率，建议调整部分设置。在 Layout GXL 中打开版图，点击 `Options > Display`, 修改如下：
- <span style='color:red'> 打开布线时的 DRC 提示: `Options > DRD Edit` 中 enable `Notify` </span>
- `Grid Controls`: `X/Y Snap Spacing` = 0.005 (这是根据 DRC 中的最小网格规则设置的)
- `Display Controls`: 在 `Option > Display` 中 Enable `Pin Names` and `Show Name Of > both`，然后打开 `Option > Net Name Display > Draw labels on top`, 并调整合适的颜色 (例如将白色改为黄色)
- `Dimming`: Enable `Dimming` (选中器件时会高亮对应器件，同时暗化其它器件)




### 1.2 Identifying Layers

开始版图设计之前，得先确定此工艺库下的各个 layer 简称代表什么意思，以及阅读工艺库下的 DRC 文件，确定几个基本 DRC 规则的数值。

我们已经在文章 [202507_tsmcN28_OpAmp__nulling-Miller__layout](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller__layout.md>) 中介绍过 `tsmcN28` 工艺库各个 layer 的含义，这里不再赘述。

### 1.3 Basic Design Rules


在进行正式的版图设计之前，我们需要找到工艺库对应的 DRC 文件，重点关注文件比较重要的一些规则。下表是  `tsmcN28` 工艺库的部分关键 design rules:


<div class='center'>


| Rule Name       | Value (tsmcN28) | Full Name & Description | Original content |
|:----------------|:------------:|:------------------------|:-----------------|
| **G.1**        |   0.005 um | **Grid Rule**: Grid must be an integer multiple of 0.005 um | Grid must be an integer multiple of 0.005 um |
|   NW.S.1       | > 0.24 um  | **N-Well Minimum Spacing Rule**: Minimum spacing between adjacent N-Wells | Space >= 0.24 |
|   NW.S.2       | > 0.8 um   | **N-Well Different Potential Spacing Rule**: Minimum spacing of 2 NW1V with different potentials | Space of 2 NW1V with different potentials >= 0.8  |
|   NW.W.1       | > 0.24 um  | **N-Well Minimum Width Rule**: Minimum width for N-Well regions | Width >= 0.24 |
|   NW.EN.1      | > 0.065 um | **N-Well Enclosure Rule**: N-Well must enclose PMOS active | Enclosure of NW STRAP >= 0.065 |
| **M1.S.1**     | > 0.05 um  | **Metal1 Minimum Spacing Rule**: Minimum spacing between Metal1 traces | Space >= 0.05 |
| **M1.S.2**     | > 0.06 um  | **Metal1 Minimum Spacing Rule**: Minimum spacing between Metal1 traces | Space [at least one metal line width > 0.1 um (W1) and the parallel run length > 0.22 um (L1)] >= 0.06  |
| **M1.S.3**     | > 0.10 um  | **Metal1 Minimum Spacing Rule**: Minimum spacing between Metal1 traces | Space [at least one metal line width > 0.18 um (W2) and the parallel run length > 0.22 um (L2)] >= 0.10  |
| **M1.S.4**     | > 0.13 um  | **Metal1 Minimum Spacing Rule**: Minimum spacing between Metal1 traces |  Space [at least one metal line width > 0.47 um (W3) and the parallel run length > 0.47 um (L3)] >= 0.13 |
| **M1.A.4**     | > 0.2 um   | **Metal1 Area Rule**: Minimum area for Metal1 traces | Enclosed area >= 0.2 |
| **M1.W.1**     | > 0.05 um  | **Metal1 Minimum Width Rule**: Minimum width for Metal1 traces | Width >= 0.05 |
| **M1.EN.1**    | > 0 um     | **Metal1 Enclosure Rule**: M1 must enclose contacts | Enclosure of CO >= 0 |
| **M1.EN.3**    | > 0.03 um  | **Metal1 Enclosure Rule**: M1 must enclose contacts | Enclosure of CO [M1 width > 0.7 um] >= 0.03  |
|   PO.S.3       | > 0.08 um  | **Poly Minimum Spacing Rule**: Minimum spacing between PO (poly) | Space >= 0.08 |
|   PO.W.1       | > 0.03 um  | **Poly Minimum Width Rule**: Minimum width for polysilicon lines | Width >= 0.03 |
| **OD.S.1**     | > 0.08 um  | **Active Area Spacing Rule**: Minimum spacing between diffusion regions | Space >= 0.08 |
| **OD.W.1**     | > 0.05 um  | **Active Width Rule**: Minimum width for diffusion regions | Width >= 0.05 |
| **OD.DN.1**    | > 25%      | **Active Density Rule**: Minimum active area density in 20x20 um window | Minimum {{OD OR DOD} OR SR_DOD} density across full chip >= 25%  |
|   CO.S.1       | > 0.07 um  | **Contact Minimum Spacing Rule**: Minimum spacing between contact vias | Space >= 0.07 |
|   CO.EN.1      | > 0.005 um | **Contact Enclosure Rule**: Metal must enclose contacts (via) | Enclosure by OD >= 0.005  |

</div>


关于如何找到工艺库对应的 DRC 文件，同样参考文章 [202507_tsmcN28_OpAmp__nulling-Miller__layout](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller__layout.md>)



如果对版图设计和验证的全流程还不太熟悉，建议先完成一次简单的反相器版图设计，详见文章 [Cadence Layout Example in tsmcN28 (including DRC, LVS, PEX and Post-Simulation)](<AnalogIC/Virtuoso Tutorials - 8. Cadence Layout Example of Inverter in tsmcN28 (including DRC, LVS, PEX and Post-Simulation).md>)。



### 1.4 Layout Step Overview

版图设计的主要流程与操作如下，其中 (1) ~ (5) 属于 **step 1: layout** 部分，算上后续的 DRC, LVS, PEX 和后仿，一共有五个部分：
- (1) Add Dummy Devices
    - (1.1) 在 schematic 中添加 dummy 器件 (length = 30nm, fingers = 2)
    - (1.2) 检查所有器件参数是否正确
- (2) Generate layout
    - (2.1) 点击 `Generate All from Source`
    - (2.2) 选择 `Place as in schematic`
- (3) Add Gate Contacts
    - (3.1) 利用 align 功能分离每一组器件 (这一步要注意 DRC)
    - (3.2) 分别选中 NMOS 和 PMOS, 编辑属性 <span style='color:red'> 添加 gate contacts </span>
    - (3.3) 将每一组晶体管 group 起来
- (4) Add Guard Ring and N-Well
    - (4.1) 手动添加 guard ring (这一步要注意 DRC)
    - (4.2) 手动添加 n-well (这一步要注意 DRC)
- (5) Metal Routing
    - (5.1) 进行整体布局 (这一步要注意 DRC)
    - (5.2) 开始金属连线，遵循 "奇竖偶横" 原则 (奇数层尽量走竖线, 偶数层尽量走横线), 并且优先连接每一组晶体管的内部网络
- (6) DRC Check
    - (6.1) 运行 DRC 检查并修复所有报错
    - (6.2) 除个别可忽略的规则外，通过其它所有 design rules 以确保版图符合设计规范
- (7) LVS Check
    - (7.1) 运行 LVS 检查并修复所有报错
    - (7.2) 完全通过 LVS 检查以确保版图与原理图一致
- (8) PEX (parasitic extraction)
- (9) Post-Layout Simulation (后仿)



## 2. Layout Details


### 2.0 initial schematic

直接从前仿完成后 copy 而来，未经修改的 schematic 及其生成的 layout 如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-21-27-11_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-21-39-37_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

注意：由于电阻比值 $\frac{R_2}{R_1}$ 对温度曲线的影响很大，**如果时间充足**，我们在基本完成版图工作后，需要不断根据后仿的结果调整 $R_1$ 与 $R_2$ 的导线，从而间接地调整 $R_2$ 与 $R_1$ 的比值，直到 zero-TC point 和 TC (temperature coefficient) 都达到最佳 (比如 zero-TC point 在 27℃ 附近, 且 TC 约为 3.5 ppm/°C).

### 2.1 add dummy devices


给各个器件添加 dummy devices:
- Q1, Q2: Multiplier_Q1 = 2, Multiplier_Q2 = 40, 这里一共是 42 = 6\*7 units, 如果要在外面完整地围上一圈 dummy, 一共 8\*9 = 72 个单位三极管 (其中 dummy 30 个)，这是否有些太多了？这里有 dummy 的思路就行，在本次设计，我们就不给它们添加 dummy devices 了 (按照 6*7 进行排布，并注意匹配即可)。
- M3, M4, M5: 管子 M5 = 2\*M3 = 2\*M4, 一共四个 units, 考虑 1*6 的布局 (共 2 个 dummy)，具体而言 dummy-M5@1-M3-M4-M5@2-dummy
- R1, R2, R3, R4: 暂不添加 dummy (有版图自带的一点点)
- start-up circuit: 尺寸较小，可以多加一些 dummy

修改后的 schematic 和 layout 如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-22-07-07_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-22-08-25_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

<span style='color:red'> 然后检查 shcematic 中各器件的参数是否正确，检查完毕后继续下一步 (这一步很重要！要是等 layout 做完了才发现器件参数弄错了，那实在令人崩溃) </span>



### 2.2 generate layout

在 schematic 中调整所有 MOS 器件的设置，使其在 generate 时自动生成 M1_PO contact. <span style='color:red'> 注意左上角选择 apply to all selected, 否则只会应用到一个器件 </span>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-21-17-21_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

当然，也可以调整电阻的设置 (例如 Cont columns, 也即 contact 的列数, 但这会略微改变电阻的值，建议在设计过程中添加电阻时就修改)。

调整完毕后 generate layout:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-21-19-55_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

**注意检查是不是所有晶体管都已自动生成了 gate contact, 若没有，到 schematic 中修改属性后重新 generate.**

### 2.3 align, contact and group

利用 align 功能分离出每一组器件，其中 PMOS 的 NW 间距无需考虑 (后续会用大 NW 包住小 NW), 只需考虑 PO (poly) 的间距，也即 DRC 中的 **PO.S.3 (Poly Minimum Spacing Rule) > 0.08 um**。


注意调整 dummy 器件位置的同时，合理设置 align 间距使组内管子之间的 spacing 与自带的 dummy poly 间距相同 (默认 0.10um 或 0.18um)。

下面是部分细节展示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-22-41-22_202507_tsmcN28_OpAmp__nulling-Miller__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-22-44-11_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-22-49-29_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

将每一组都处理好，并分别 group 起来：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-22-52-59_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

### 2.4 add guard ring and n-well

现在，为晶体管们添加 guard ring 和 n-well (对于 PMOS), 建议添加 guard ring 时 enclosure by 0.3 um 以避免违反 DRC, 效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-22-57-02_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-23-17-40_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

### 2.5 DRC test

在布线之前，先进行一下 DRC 以确定没有什么奇奇怪怪的问题。关于 DRC/LVS/PEX 和后仿的详细教程见 [Cadence Layout Example of Inverter in tsmcN28 (including DRC, LVS, PEX and Post-Simulation)](<AnalogIC/Virtuoso Tutorials - 8. Cadence Layout Example of Inverter in tsmcN28 (including DRC, LVS, PEX and Post-Simulation).md>), 这里直接给出 DRC 结果：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-00-02-32_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

嗯，除了 density rule 之外并没有其他报错，符合我们的预期。关于 DRC 时是否需要满足 density rule 的问题，可以参考这篇问答 [EETOP > 金属层的density 必须要满足 drc 规则才可以吗](https://bbs.eetop.cn/thread-920360-1-1.html). 总的来讲，像我们这样小模块的设计，基本上是无需满足 density rule 的。

如果要节省面积，可以将 BJT 个各个单位模块紧贴仿真，这样也是符合 DRC 的，下面是一个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-23-53-33_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>


我们这里还是采取原来有间隔的一种，无需太过纠结。

### 2.6 LVS test

再运行一下 LVS, 确保版图除网络连接外的各参数与原始 schematic 一致：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-00-02-55_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

Extraction Results 中出现了一个 warning:

``` bash
Warning: #1 in 202507_BGR_lowVoltage_layout_v1_0725
WARNING:  Stamping conflict in SCONNECT - Multiple source nets stamp one target net.
          Use LVS REPORT OPTION S or LVS SOFTCHK statement to obtain detailed information.
```

这是正常的，因为 guard ring 没有正确连接到对应网络 (一般是 VDD/VSS) 便会导致这个 warning. 其它报错和预料中差不多，可以开始金属布线了。


### 2.7 metal routing and DRC/LVS

把除了 VDD/VSS 外的全部网络连接完毕，同时通过 DRC 检查：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-02-34-25_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-02-35-20_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-02-52-54_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>


在外围分别创建 VSS/VDD 的 guard ring (选择 `PSubMPP6` 和 `NwellMPP6` 以获得较大宽度), 包围整个电路 (建议 VSS 在内)，然后再来连接 VDD 和 VSS, 并进行 DRC 和 LVS 检查：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-21-36-55_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

注意到上面的 ERC 并没有完全通过，详情如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-21-37-55_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

第一条 `Check floating.psub` 将整个版图给 highlight 了，第二条 `Check floating.nxwell_float` 则指向最左下角三极管的 N-Well (但其它的三极管正常), 这是为什么？

经过检查，并没有发现所谓的 psub 和 n-well 的 floating 问题，没有头绪。我们暂时不管它，继续进行后续的工作，也就是带寄生参数的后仿迭代。

后补：参考这篇问答 [EETOP > 版图验证 ERC 出问题了](https://bbs.eetop.cn/thread-278627-1-1.html), 应该是导入 `PSubMPP6` 和 `NwellMPP6` 时出现的 layer `PSUB2` 导致的，如图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-23-16-54_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

### 2.8 PEX Test

提取寄生参数：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-22-01-39_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-22-44-08_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

生成 calibre view 时卡了很久 (大概二十分钟)，最终生成了一个 size = 11.9M 的 calibre, 对于需要后仿迭代的我们来讲，这并不是个好消息。

先仿真静态工作点看一下情况：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-22-58-34_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

发现导出得到 calibre 中的电阻参数有误 (这也是为什么 vbg 高达九百多毫伏), 于是又回去检查 schematic 和 layout, 并没有发现错误，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-23-00-41_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

于是重新导出 PEX, 参考 [this article](https://zhuanlan.zhihu.com/p/6580714389) 在之前设置的基础上，又修改了 `PEX Options` 的下面两项：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-23-06-15_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

导出结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-23-33-37_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-23-34-45_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-27-23-35-38_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

令人沮丧的是，导出得到的 calibre 中电阻参数仍然有误 (如上图)。检查发现，所有设置了 `segment number ≠ 1` 的电阻都没有被正确处理，这包括 BGR Core 中的全部电阻 (R1, R2, R3, R4) 和运放中的一个电阻 (Rz). 这也解释了为什么当时运放的后仿性能明显差于前仿。

## 3. Extraction Correction


为更正上面提到的导出错误，一种方法是直接修改 calibre view 中的电阻参数 (将 segment number 改为 1)，但这种方法毕竟不够严谨，只能说是临时解决方案。


为彻底解决问题，我们进行如下操作：
- (1) 先更正运放: copy 原运放的 cell 到新 cell `202507_OpAmp__nulling_Miller__layout_v3_0727`, 将新 cell 中的 schematic 电阻 Rz (segment number = 2) 改为两个 segment number = 1 的相同电阻串联 (毕竟我们不清楚 multiplier 是否会出现相同的问题), 修改版图并通过 DRC 和 LVS (无需 PEX)
- (2) 更正 BGR Core: copy BGR 的 cell 到新 cell `202507_BGR_lowVoltage_layout_v2_0727` 中，修改新 cell 中 schematic 的运放 symbol 和电阻参数 (全部改为 segment number = 1), 修改版图并通过 DRC 和 LVS 
- (3) 重新导出 PEX, 生成 calibre view, 并进行后仿

### 3.1 Op Amp Correction

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-00-01-57_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-00-07-03_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

上面修改电阻时，记得同步修改电阻的 `cont columns`, 否则 cont columns 默认为 1 对连接性能不友好 (单个 cont 的电阻约为 50 Ohm)。

<span style='color:red'> 打开 layout 并修改 layout 的依赖关系 (复制而来的 layout 仍依赖原先的 schematic)。 </span> 

具体而言，打开 `Connectivity > Update > Connectivity Reference` 进行修改：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-00-12-50_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

然后更新 layout 中的电阻版图：选择电阻 Rz, 点击 `Connectivity > Update > Components and Nets`. (或者直接 generate selected from source 也可以)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-00-16-53_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

然后重新过一遍 DRC 和 LVS:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-00-26-12_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-00-28-04_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>


### 3.2 BGR Correction

修改 BGR 的 schematic:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-00-33-53_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-00-50-07_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

然后打开 layout, 先修改 schematic 依赖关系，再更新版图：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-01-31-42_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-01-33-08_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

上面额外添加的 PP + OD 是用作 Dummy OD 来避免 OD.S.14 规则的，也即：

``` bash
OD.S.14 { @ Maximum space between {{OD OR SR_DOD} OR DOD} <= 10 
   ((CHIP NOT (SIZE ALL_OD BY OD_S_14/2)) NOT EMPTY_AREA_P4) NOT (EXPAND EDGE CHIP_CHAMFERED_P4 INSIDE BY OD_S_14/2)
}
```

### 3.3 PEX Correction

然后就可以重新导出寄生参数并生成 calibre view:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-02-02-41_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-02-03-31_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-02-04-08_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

现在的电阻参数便正常了，仿真静态工作点看一下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-02-09-10_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

这次是 Id_BG 变成了 200 uA ??? 检查发现所有 MOS 的 finger 和 multiplier 也没有正确被处理，εε(´ο｀*)))唉。查看一下以前 Op Amp 导出的 calibre view, 发现具有同样的问题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-02-10-54_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>


下面是一些与本问题相关的链接：
- [Calibre-PEX 碰到的关于 m 和 fingers 的问题](http://ee.mweda.com/ask/326458.html)
- [EETOP > SMIC Calibre PEX 求助](https://bbs.eetop.cn/thread-434486-1-1.html)

我们又尝试了导出 `Gate Level` 的 PEX (需要选择工艺库对应的 X-Cell Files). `.cellmap` 文件没变，结果还是不行。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-02-39-18_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

从上图的报错来看，基本就是 `.cellmap` 文件的锅了。因为没在工艺库文件夹中找到 `tsmcN28` 的 `.cellmap` 文件，我们之前一直使用的是 `tsmc18rf` 的。又去服务器里找了一下该文件，仍旧没有找到，无奈向师兄请求此文件。

拿到文件后，在 layout 点击 `Calibre > Setup > Calibre View` 重新导出 calibre view, 选择正确的 `.cellmap` 文件后运行生成 `layout_v1` 的寄生原理图 (v1 就是仍保持电阻 segment num = 2 的那一版)：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-14-26-46_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-14-36-46_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-14-45-04_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

这次，电阻和晶体管的各个参数便正常了。以 MM5 为例，虽然上面 schematic 中仍显示 m/nf = 2/3, 但打开 edit object property 发现实际为 m/nf = 1/1, 因此是正常的。

TT 工艺角的温度曲线及上电瞬态响应仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-14-52-09_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-15-12-16_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

回顾一下 $V_{BG}$ 的公式：

$$
\begin{gather}
V_{BG} = a \,I_{D4} R_4 = \frac{a R_4}{R_2} \left[V_{BE1} + \frac{R_2}{R_1} V_T \ln n + \left(1 + \frac{R_2}{R_1}\right)\left(V_{OS} + \frac{V_Z}{A_0} \right) \right]
\end{gather}
$$

图中看到 TC 恒为负，因此版图迭代的思路就是适当增加正温度系数的比例，也就是增加 $\frac{R_2}{R_1} V_T \ln n$ 一项，这相当于增大 $R_2$ 的串联寄生电阻 (反过来减小 $R_1$ 是不太容易的)，可以通过增加 R2 的走线电阻实现。

作为一个简单的科研实践，我们这里就不再修改了。

但是，后续仿真发现电路在 SF 工艺角下无法正常工作：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-17-20-16_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>


这并不是 start-up circuit 的锅，因为 SF 工艺角下电路仍处于正常工作状态。真正的原因是工艺角导致的阈值电压变化使 Id_M4 和 I_BG 均比较明显下降，这才使得输出电压下降到约 400 mV. 

至于如何修复这个问题，使电路在全工艺角都能正常工作，仍有待进一步探究。

<!-- ## 4. Start-up Circuit Correction

为了使电路正常启动，我们需要一个 SF 工艺角下阈值电压在 480 mV 左右的 start-up circuit.

先给出原启动电路在各个工艺角下的阈值电压：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-17-03-31_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

SF 工艺角对应的阈值电压为 444.9 mV, 按理来说能够保证 V_BG > 450 mV, 可为什么仿真时出现了 V_BG = 404.6 mV 的结果？


尝试了下面六种结构，发现阈值电压分别为 370 mV 和 550 mV, 行不通：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-16-36-24_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-16-37-21_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

又尝试把上面的 diode-connected PMOS 改为 multiplier = 2, 仍行不通。随后又尝试了下面几种结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-16-58-30_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-16-59-38_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

-->


## 4. Post-Layout Simulation

<!-- 
### 6.1 (dc) temp-curve (all-temp, TT)
### 6.2 (dc) lowest supply voltage (all-temp, TT)
### 6.3 (tran) start-up response (all-temp, TT)
### 6.4 (ac) PSRR (27 °C, TT)
### 6.5 (mc) Monte Carlo simulation (27 °C, TT)
-->

### 4.0 layout preview

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-15-13-58_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>


在 layout 界面点击 `File > Export Img`, 设置如下后导出：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-15-23-11_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-16-05-27_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>


### 4.1 (dc) temp-curve (all-temp, all-corner, 1.2 V)

在 VDD = 1.2 V 条件下，仿真 TT (Nominal) 工艺角的温度曲线 (-40 °C ~ 125 °C)，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-17-29-38_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

然后仿真不同工艺角下的温度曲线，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-22-10-23_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

### 4.2 (dc) minimum supply voltage (all-temp, TT, all-supply)

在 TT (typical-typical) 工艺角下，仿真带隙电压 V_BG 在不同温度下 (-40 °C, 0 °C, 27 °C, 75 °C, 125 °C) 随供电电压 VDD 的变化情况，结果如下：

室温 27 °C 时，最小供电电压 0.984 V:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-18-32-32_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

全温度 (-40 °C, 0 °C, 27 °C, 75 °C, 125 °C) 的仿真结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-18-36-13_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-18-38-46_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

### 4.3 (tran) start-up response (27 °C, TT, 1.2 V)


在 VDD = 1.2 V 的 TT 工艺角下，仿真 BGR 在室温下的上电瞬态响应 (分别设置 VDD 的上升时间为 1us 和 100us), 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-17-52-13_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-17-50-46_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

stand-by current = 351.1 uA, maximum current = 464.3 uA.


### 4.4 (ac) PSRR (27 °C, TT, 1.2 V)


注意 config 文件配置 symbol 为 calibre, 同时 ADE XL Test 中要选择 Design > config:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-22-43-05_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-22-44-39_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

为了避免 dc opt 与 tran 仿真得到的直流工作点不一致 ，我们不采用普通 dc opt 作为 ac 仿真的直流工作点，而是先进行 tran 仿真，待电路完全启动后，保存此时刻的直流工作点，在此点基础上进行 ac 小信号仿真。具体操作参考 [xxx](xxx)，我们这里直接给出结果：

先进行一个 tran 仿真查看一下电路要多久才能达到稳态：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-04-53_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-29-23-50-34_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>


然后加上基于瞬态工作点的 ac 仿真 (TT + 27 °C, VDD = 1.2 V)，设置瞬态工作点在 2.5 us 处，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-07-30_Virtuoso Tutorials - 7. Using Tran Result as the DC Operation Point for AC Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-15-36_Virtuoso Tutorials - 7. Using Tran Result as the DC Operation Point for AC Simulation.png"/></div>



### 4.5 (mc) average and TC (all-temps, all-corners, 1.2 V)


在 VDD = 1.2 V 的室温 (27 °C) 条件下，调整蒙特卡洛仿真设置为:
- Statistical Variation = All (process + mismatch, namely, global + local variation)
- Sampling Method = Low-Discrepancy Sequence
- Samples = 250
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-19-23-34_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-19-25-06_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-19-28-43_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

有部分 V_BG 为 408 mV 左右的数据是因为工艺角接近 SF 导致输出异常，这依旧是我们在 **4.4 (ac) PSRR (27 °C, TT, 1.2 V)** 中提到过的 “dc opt 得到的直流工作点与实际的 tran 得到的瞬态工作点不同” 导致的。在 SF 工艺角验证电路是否能正常启动，如下图，显然是可以正常工作的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-30-00-29-19_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

因此我们有充分的理由去掉这部分异常数据，筛选后的蒙卡结果如下 (以 450 mV 为界限)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-19-35-13_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

或者干脆凑一个 num = 200:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-19-36-23_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-28-19-36-55_Cadence Layout (202507_tsmcN28_BGR__scientific_research_practice_1).png"/></div>

### 4.6 simulation summary

默认 VDD = 1.2 V.

<span style='font-size:12px'>
<div class='center'>

| Parameter | Definition | Post-Simulation Results | Simulation Conditions |
|:-:|:-:|:-:|:-:|
 | VDD_min | minimum supply voltage | 0.984 V | (dc) TT, 27 °C |
 | IDD | total supply current | 351.1 uA (0.42132 mW @ 1.2 V) | (dc) TT, 27 °C |
 | average V_BG | average bandgap voltage <br> @ (-40 °C, 125 °C) | 522.2 mV <br> 521.2 mV ~ 525.1 mV <br> 517.587 mV ± 22.9332 mV (± 4.43 %) | (dc) TT <br> (dc) all-corner <br> (mc) samples = 200 |
 | TC of V_BG (ppm/°C) | V_BG temperature coefficient <br> @ (-40 °C, 125 °C) | 14.82 ppm/°C <br> 2.146 ppm/°C ~ 39.55 ppm/°C <br> -17.3894 ppm/°C ± 55.1812 ppm/°C | (dc) TT <br> (dc) all-corner <br> (mc) samples = 200 |
 | average I_REF | reference current <br> @ (-40 °C, 125 °C) | 53.24 uA <br> 46.57 uA ~ 62.48 uA <br> 53.4288 uA ± 3.64341 uA (± 6.82 %) |  (dc) TT <br> (dc) all-corner <br> (mc) VDD = 1.2 V, samples = 200 |
 | TC of I_REF (ppm/°C) | I_REF temperature coefficient <br> @ (-40 °C, 125 °C) | -36.38 ppm/°C <br> -50.99 ppm/°C ~ -22.78 ppm/°C <br> -34.2794 ppm/°C ± 44.0326 ppm/°C | (dc) TT <br> (dc) all-corner <br> (mc) samples = 200 |
 | Delta_t | settling time | < 0.05 us | (tran) TT, 27 °C, VDD from 0 to 1.2 V (SR = 1 V/us) |
 | PSRR | power supply rejection ratio | 36.9 dB @ DC, BW = 31.51 MHz, UGF = 834.5 MHz <br> 36.5 dB @ 10 MHz, 26.1 dB @ 100 MHz | (ac) TT, 27°C |
</div>
</span>


### 4.7 postscript: mc simul after dc opt correction

发现 dc opt 得到的工作状态与 tran 得到的工作状态不一致，于是按文章 [Resolving Discrepancies Between DC and Transient Simulation Results](<AnalogIC/Virtuoso Tutorials - 11. Resolving Discrepancies Between DC and Transient Simulation Results.md>) 中的方法设置初始状态后重新运行蒙卡仿真，结果如下：


设置 `Vx = MM3_d = VDD` 和 `Vy = MM4_d = 0`, 结果可以正确收敛，进行 samples = 20 的蒙卡测试：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-00-17-36_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-00-13-14_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-00-06-20_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

设置 `Vx = MM3_d = VDD`, `Vy = MM4_d = 0` 和 `V_BG = MM5_d = 0`, 结果不能正确收敛：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-00-15-10_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-00-12-58_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-00-12-20_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div> -->

设置 `Vx = MM3_d = VDD`, `Vy = MM4_d = 0` 和 `V_BG = MM5_d = VDD`, 结果可以正确收敛，进行 samples = 20 的蒙卡测试：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-00-19-03_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-00-32-39_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-00-31-57_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

第一种初始状态设置要稍微好一些。选用第一种设置 先看一下不同工艺角的工作点：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-00-39-33_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

SF 工艺角仍不能收敛到正确工作状态 (我们在 tran 仿真中试过，是可以正常收敛的)。我们又尝试了多种初始状态设置，也尝试过将 tran 仿真收敛前一刻/后一刻的电压状态输入进去，都没能收敛到正确的工作状态 (SF 工艺角)。

无奈，仍选用第一种设置 (`Vx = MM3_d = VDD` 和 `Vy = MM4_d = 0`) 进行 samples = 200 的蒙卡仿真，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-01-48-49_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-01-51-13_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-01-52-29_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

将工作点明显异常的数据清除后 (以 vbg = 450 mV 为界), 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-31-01-56-14_202507_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

更新蒙卡数据后的 simulation summary 如下：

<span style='font-size:12px'>
<div class='center'>

| Parameter | Definition | Post-Simulation Results | Simulation Conditions |
|:-:|:-:|:-:|:-:|
 | VDD_min | minimum supply voltage | 0.984 V | (dc) TT, 27 °C |
 | IDD | total supply current | 351.1 uA (0.42132 mW @ 1.2 V) | (dc) TT, 27 °C |
 | average V_BG | average bandgap voltage <br> @ (-40 °C, 125 °C) <br> mean ± sigma | 522.2 mV <br> 521.2 mV ~ 525.1 mV <br> 521.771 mV ± 23.2498 mV (± 4.456 %) | (dc) TT <br> (dc) all-corner <br> (mc) samples = 170 |
 | TC of V_BG (ppm/°C) | V_BG temperature coefficient <br> @ (-40 °C, 125 °C) <br> mean ± sigma | 14.82 ppm/°C <br> 2.146 ppm/°C ~ 39.55 ppm/°C <br> -12.6862 ppm/°C ± 53.9893 ppm/°C | (dc) TT <br> (dc) all-corner <br> (mc) samples = 170 |
 | average I_REF | reference current <br>  @ (-40 °C, 125 °C) <br>  mean ± sigma | 53.24 uA <br> 46.57 uA ~ 62.48 uA <br> 53.5068 uA ± 3.66081 uA (± 6.842 %) |  (dc) TT <br> (dc) all-corner <br> (mc) VDD = 1.2 V, samples = 170 |
 | TC of I_REF (ppm/°C) | I_REF temperature coefficient <br> @ (-40 °C, 125 °C) <br> mean ± sigma | -36.38 ppm/°C <br> -50.99 ppm/°C ~ -22.78 ppm/°C <br> -31.7456 ppm/°C ± 43.3075 ppm/°C | (dc) TT <br> (dc) all-corner <br> (mc) samples = 170 |
 | Delta_t | settling time | < 0.05 us | (tran) TT, 27 °C, VDD from 0 to 1.2 V (SR = 1 V/us) |
 | PSRR | power supply rejection ratio | 36.9 dB @ DC, BW = 31.51 MHz, UGF = 834.5 MHz <br> 36.5 dB @ 10 MHz, 26.1 dB @ 100 MHz | (ac) TT, 27°C |
</div>
</span>