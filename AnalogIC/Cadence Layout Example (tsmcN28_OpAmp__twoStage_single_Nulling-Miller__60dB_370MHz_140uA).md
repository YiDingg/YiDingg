# Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA)

> [!Note|style:callout|label:Infor]
> Initially published at 18:52 on 2025-07-22 in Beijing.


## 1. Preparations


本文，我们将对 `tsmcN28` 工艺下设计的运放 [A Basic Two-Stage Op Amp with Nulling-Miller Compensation for Low-Voltage BGR in 28nm CMOS Technology](<AnalogICDesigns/tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA.md>) 进行版图设计，并完成后续一系列工作，这包括：
- Layout (版图设计)
- DRC (设计规则检查)
- LVS (版图与原理图比对)
- PEX (寄生参数提取)
- Post-Layout Simulation (后仿真)



### 1.1 Configure Settings

在 Layout GXL 中打开版图，点击 `Options > Display`, 修改以下设置：
- `Grid Controls`: `X/Y Snap Spacing` = 0.005 (这是根据 DRC 中的最小网格规则设置的)
- `Display Controls`: 在 `Option > Display` 中 Enable `Pin Names` and `Show Name Of > both`，然后打开 `Option > Net Name Display > Draw labels on top`, 并调整合适的颜色 (例如将白色改为黄色)
- `Dimming`: Enable `Dimming` (选中器件时会高亮对应器件，同时暗化其它器件)



### 1.2 Identifying Layers

开始版图设计之前，得先确定此工艺库下的各个 layer 简称代表什么意思，以及阅读工艺库下的 DRC 文件，确定几个基本 DRC 规则的数值。

不妨先问问 AI 各 layer 层的含义，我们再改正其输出结果中的错误：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-22-37-06_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>

``` bash
tsmcN28 库的版图中，下面各个 layer 分别是什么？给出其英文全称，并用中文详细解释

NW
OD
OD
PO
PP
NP
RPO
CO
M1
VIA1
M2
VIA2
M3
PM
IP
RPDMY
RH
text
PO
DMEXCL
DMEXCL
DMEXCL
MOMDMY
MOMDMY
MOMDMY
MOMDMY
MOMDMY
PDK
```


**DeepSeek 的回答 (2025.07.19)：**

以下是 TSMC N28 工艺库中各 Layer 的 Markdown 表格形式，包含英文全称和中文解释：  

| **Layer** | **英文全称**              | **中文解释**                                                                 |
|-----------|--------------------------|-----------------------------------------------------------------------------|
| NW        | N-Well                   | N型阱，用于在P型衬底上形成NMOS晶体管的区域。                                      |
| OD        | Oxide Definition         | 有源区 (Active Area) ，定义晶体管源/漏/沟道的区域，未被场氧 (STI) 隔离的部分。          |
| PO        | Poly Gate                | 多晶硅栅极，用于形成晶体管的栅极结构 (可能被金属栅替代，但名称保留) 。                     |
| PP        | P-Plus Implant           | P型高浓度掺杂层，用于PMOS的源/漏区或P-Well的接触区。                              |
| NP        | N-Plus Implant           | N型高浓度掺杂层，用于NMOS的源/漏区或N-Well的接触区。                              |
| RPO       | Resist Protect Oxide     | 保护性氧化层，在特定工艺步骤 (如离子注入) 中保护特定区域不被修改。                         |
| CO        | Contact Opening          | 接触孔，连接有源区 (OD) 或多晶硅栅 (PO) 与第一层金属 (M1) 。                           |
| M1        | Metal 1                  | 第一层金属互连，通常为铝或铜，用于局部布线。                                        |
| VIA1      | Via 1                    | 连接 Metal 1 和 Metal 2 的垂直通孔。                                           |
| M2        | Metal 2                  | 第二层金属互连，布线密度和厚度可能与 M1 不同。                                      |
| VIA2      | Via 2                    | 连接 Metal 2 和 Metal 3 的垂直通孔。                                           |
| M3        | Metal 3                  | 第三层金属互连，通常用于更全局的信号或电源布线。                                      |
| PM        | Passivation Metal        | 钝化金属层，覆盖钝化层 (如SiN或SiO₂) ，保护芯片免受环境侵蚀。                          |
| IP        | Integrated Passivation   | 集成钝化层，用于芯片表面的最终保护，防止划伤或湿气侵入。                               |
| RPDMY     | Resist Protect Dummy     | 光刻保护虚设层，用于工艺均匀性 (如CMP) 或填充无电路区域。                              |
| RH        | Resist Hardmask          | 硬掩模层，用于复杂图形刻蚀 (如双重曝光技术) 。                                        |
| TEXT      | Text Annotation Layer    | 文本标注层，仅用于标识或注释，不参与实际制造。                                        |
| DMEXCL    | Dummy Metal Exclusion    | 禁止放置虚设金属 (Dummy Metal) 的区域，确保信号完整性。                               |
| MOMDMY    | MOM Dummy Capacitor      | 金属-氧化物-金属 (MOM) 电容的虚设结构，用于提高工艺均匀性或匹配特性。                   |
| PDK       | Process Design Kit       | 工艺设计套件，包含设计规则、模型文件和工艺参数，非物理层。                             |

**说明：**  
1. **重复 Layer** (如 `OD`, `PO`, `DMEXCL`, `MOMDMY`) 可能因不同上下文 (如不同光刻掩模或层次派生) 出现多次，需结合 PDK 规则确认。  
2. **FinFET 工艺差异**：在先进工艺 (如 N28) 中，部分 Layer (如 `OD`) 可能与平面晶体管不同 (例如对应 Fin 结构) 。  
3. **PDK 依赖**：具体定义请以 TSMC N28 官方文档为准。  

如果需要进一步调整格式或补充内容，请随时告知！

**Kimi 的回答 (2025.07.19)**

在 TSMC 28 nm (N28) 工艺的设计规则文档/PDK 中，版图 (layout) 里出现的各类 layer 名称及其英文全称、中文含义如下。  
 (注：TSMC 的 layer 命名在不同节点基本保持一致，以下解释以 28 nm bulk CMOS 为基准，并补充了 Dummy、Marker 等辅助层。) 


<div class='center'>

| 版图字符 | 英文全称 | 中文解释 |
|---|---|---|
| NW | N-Well | N 型深阱，用来放置 PMOS，为 PMOS 提供背栅/体区。 |
| OD | Oxide-Definition (或 Active Area)  | 有源区/扩散区，硅表面被 STI 包围的“岛”区域，真正做源/漏/沟道的位置。 |
| PO | Poly-Silicon | 多晶硅栅极层，形成 MOS 管的栅。 |
| PP | P+ Implant (P-Plus) | P 型重掺杂注入掩膜，用于在 OD 内形成 PMOS 的源/漏、P+ 保护环等。 |
| NP | N+ Implant (N-Plus) | N 型重掺杂注入掩膜，用于形成 NMOS 的源/漏、N+ 保护环等。 |
| RPO | Resistor Protect Oxide / Resist Protect Oxide | 在需要保留高阻 poly 电阻的区域，阻挡 silicide 形成，从而得到高阻 poly 电阻。 |
| CO | Contact | 第一层金属 (M1) 与 poly、OD 之间的钨塞接触孔。 |
| M1 | Metal-1 | 第一层铝/铜互连金属。 |
| VIA1 | Via-1 | M1 与 M2 之间的通孔。 |
| M2 | Metal-2 | 第二层金属。 |
| VIA2 | Via-2 | M2 与 M3 之间的通孔。 |
| M3 | Metal-3 | 第三层金属 (更高层依次为 M4、M5…) 。 |
| PM | Pad-Metal / Top-Metal | 最顶层厚铝/铜，用于打线焊盘。 |
| IP | I/O Pad | 芯片封装用焊盘开口层 (定义 bump/bond pad 区域) 。 |
| RPDMY | Resist-Poly Dummy | 多晶硅 dummy 图形层，用于保持图形密度、提高 CMP 均匀性。 |
| RH | Resistor High-sheet | 高阻 poly 电阻模型层，与 RPO 一起使用，做高值电阻。 |
| text | Text Layer | 版图标注层，只用于显示文字、不产生掩膜。 |
| DMEXCL | Density-Mark Exclude | 密度检查排除标记，告诉 DRC 在该区域不计算金属或多晶硅密度。 |
| MOMDMY | MOM-Cap Dummy | MOM (Metal-Oxide-Metal) 电容 dummy 金属块，用于保持电容区域金属密度。 |
| PDK | Process Design Kit | 工艺设计套件总称，并非版图层，而是包含 DRC/LVS/PEX rule file、器件模型、标准单元库、IO 库等整套设计支持文件。 |

</div>

补充说明  
1. “OD” 在列表里出现了两次，只是重复列出，含义不变。  
2. 不同 PDK 版本对 Dummy、Marker 层的命名可能略有差异 (如 DMEXCL 也可能写作 DENSTY_EXCL、MOM_DMY 等) ，但功能一致。  
3. 若后续金属层继续向上，则依次为 M4/VIA3/M5/VIA4…，28 nm 一般提供 8~10 层金属供 SoC 使用。

### 1.3 Basic Design Rules


在进行正式的版图设计之前，我们需要找到工艺库对应的 DRC 文件，并重点关注文件比较重要的一些规则。下面是 DeepSeek (2025.07.20) 认为其中比较重要的规则：

(注: 下表内容及数值由 AI 生成，仅作参考，可能含有错误，也不是 `tsmcN28` 工艺库对应的实际值)

1. NW.S.1 (N-Well Minimum Spacing Rule): Minimum spacing between adjacent N-Wells       > 0.24 um
2. PO.S.1 (Poly Minimum Spacing Rule): Minimum spacing between polysilicon gates        > 0.05 um
3. OD.S.1 (Active Area Spacing Rule): Minimum spacing between diffusion regions         > 0.12 um
4. M1.S.1 (Metal1 Minimum Spacing Rule): Minimum spacing between Metal1 traces          > 0.05 um
5. CO.S.1 (Contact Minimum Spacing Rule): Minimum spacing between contact vias          > 0.07 um
6. PO.W.1 (Poly Minimum Width Rule): Minimum width for polysilicon lines                > 0.05 um
7. M1.W.1 (Metal1 Minimum Width Rule): Minimum width for Metal1 traces                  > 0.05 um
8. NW.W.1 (N-Well Minimum Width Rule): Minimum width for N-Well regions                 > 0.3 um
9. PO.EN.1 (Poly Enclosure Rule): Poly must enclose active area by at least             > 0.05 um
10. M1.EN.1 (Metal1 Enclosure Rule): Metal1 must enclose contacts by at least           > 0.03 um
11. NW.EN.1 (N-Well Enclosure Rule): N-Well must enclose PMOS active by at least        > 0.2 um
12. OD.DN.1 (Active Density Rule): Minimum active area density in 20x20 um window       > 20%
13. M1.DN.1 (Metal1 Density Rule): Minimum Metal1 density in 10x10 um window            > 30%
14. LUP.1 (Latch-Up Prevention Rule): Maximum distance from NMOS to P-Well tap          < 20 um
15. ANT.1 (Antenna Rule): Maximum ratio of metal/poly area to gate area                 < 500:1
16. M1.S.8 (Metal1 End-to-End Spacing Rule): Minimum spacing between dense Metal1 ends  > 0.07 um
17. VI.S.1 (Via Spacing Rule): Minimum spacing between adjacent vias                    > 0.08 um
18. VI.EN.1 (Via Enclosure Rule): Metal must enclose via by at least                    > 0.03 um
19. OD.W.1 (Active Width Rule): Minimum width for diffusion regions                     > 0.1 um
20. CT.S.1 (Contact to Gate Spacing Rule): Minimum spacing from contact to poly gate    > 0.05 um

然后我们再添几条 AI 没有提到的：

21. G.1 (Grid Rule): grid must be an integer multiple of 0.005 um
22. NW.S.2 (N-Well Space Rule 2): Space of 2 NW1V with different potentials >= 0.8 um
23. M1.S.2 (M1 Spacing Rule 2): Space [at least one metal line width > 0.1 um (W1) and the parallel run length > 0.22 um (L1)] >= 0.06
24. M1.EN.3 (M1 Enclosure Rule 3): Enclosure of CO (Contact) [M1 width > 0.7 um] >= 0.03 
25. M1.A.4 (M1 Area Rule 4): Enclosed area >= 0.2

下面就来确定这些规则的具体数值。找到 DRC 文件，路径为：

``` bash
/home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre/drc/calibre.drc.20b_core_wb
```

用 `Ctrl + F` 搜索上面规则的对应数值，总结成下表：


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


<!-- 
``` bash
不同工艺库的 DRC 文件大同小异，其中有一些规则在所有工艺库都很重要，例如 NW.S.1 (NW Space 1, N-Well Minimum Spacing Rule) 表示相邻 N-Well (NW) 之间的最小间距。除 NW.S.1 外，还有哪些是比较重要的规则？列出它们的简称与含义解释，用 list 的形式，下面是一个示例：

- rule 1: xxx spacing > xxx um
- rule 2: xxx spacing > xxx um
- rule 3: xxx spacing > xxx um
``` -->



另外，假设这是我们第一次接触此工艺库的版图，对 design rules 和其他流程还不那么熟悉 (甚至完全未知)，那么完全有必要先完成一次简单的反相器版图设计，详见文章 [Cadence Layout Example in tsmcN28 (including DRC, LVS, PEX and Post-Simulation)](<AnalogIC/Cadence Layout Example of Inverter in tsmcN28 (including DRC, LVS, PEX and Post-Simulation).md>)



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

新创建一个 cellview 进行 layout iteration 2, 以便于对比和修改。

### 3.1 Add Dummy Devices

在 **2.1 Add Dummy Devices** 一节中已经完成，将原 schematic 复制过来即可。

### 3.2 Generate Layout

与之前的步骤类似，在复制得到的 schematic 中点击 `Generate All from Source` 并 `Place as in schematic`，得到的版图如下： 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-20-22-38-48_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-20-22-15-13_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>
 -->

### 3.3 Align and Contact

利用 align 功能分离出每一组器件, NW 间距无需考虑 (后续会用大 NW 包住小 NW), 考虑 PO (poly) 的间距，也即 DRC 中的 **PO.S.3 (Poly Minimum Spacing Rule) > 0.08 um**, 我们设置 align 间距为 0.05 um (此时 dummy poly 的间距为 0.11 um), 效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-20-22-42-45_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>

将全部组别都分离开，添加 gate contacts 并分别 group 起来：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-20-22-47-35_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>


### 3.4 Add Guard Ring and N-Well


添加 guard ring 时无需考虑 NW 间距 (因为我们会用大 NW 包住整组 PMOS 管)，但是要注意 guard ring 的边界与内部晶体管各区域之间的间距，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-02-26-58_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>

显然，需要注意的间距有: NW-PO, NW-PP, PP-NP 和 PP-PO, 它们分别位于 DRC 文件中的:
- NW-PO: 没找到
- NW-PP: PP.S.5 { @ Space to NW STRAP (non-butted) >= 0.02
- PP-NP: PP.S.3 { @ Space to N+ ACTIVE (non-butted) >= 0.065
- PP-PO: 
    - (1) PP.S.6 { @ {PP edge on OD} space to NMOS GATE >= 0.16
    - (2) PP.S.7 { @ Butted PW STRAP space to PO in the same OD [the butted N+ ACTIVE extending 0 < J1 < 0.08 um] >= 0.16


于是我们选择添加 guard ring 时 enclosure by 0.2 um, 此时间距情况如下图，符合要求：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-02-40-52_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>


另外，注意 Mb5 (PMOS) 的 guard ring 不接到 VDD 而是接到 bulk of Mb5 (net 62). 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-02-42-33_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>

接下来就是为每一组 PMOS 添加一个大的 N-Well, 将它们包在里面 (建议 enclose by 0.1 um), 添加 NW 后将每一组再 group 起来：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-03-14-41_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>


### 3.5 DRC Test

不妨 Run 一下 DRC 以确定没有什么奇奇怪怪的问题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-03-15-10_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>

其中的 M1.A.1 和 M1.A.3 暂时不用管，它们是晶体管 gate contact 上的 M1 面积太小导致的，后续会通过添加 M1 来解决。

### 3.6 LVS Test

在开始走线之前，我们不妨再运行一下 LVS 测试，确保版图除网络连接外的各参数与原始 schematic 一致。大致步骤如下：


- (1) 在版图中点击 `Run nmLVS`, 选择此工艺库的 LVS 文件，例如 `/home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/lvs/calibre.lvs`
- (2) 设置 LVS Run Directory, 及 LVS 输出结果保存的文件夹
- (3) 开启 `Inputs > Netlist > Export from schematic viewer`, 这样就不用手动导出并设置 netlist 了
- (4) 在 `Setup > LVS Options` 中设置好电源网络和地网络，我们这里设置的是 VDD 和 VSS
- (5) 点击 `Run LVS`, 等待结果

这里如果报错 `source primary cell not found in source database`，通常是 top cell name 设置错误，一种可能是 cellview 名称里有斜杠 (减号) `-` 或小数点 `.` 导致报错，另一种可能是名字超过了 60 个字符 (大白话：名字太长了)。我们的就属于后者：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-15-09-11_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>

将整个 cellview 复制为另一个名为 `OpAmp_Check_LVS` 的 cellview, 按照上面方法重新进行 LVS 检查：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-15-16-21_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>

报错 `Source netlist references but does not define 2 subckts`，可以参考这两篇博客来解决：
- [CSDN > 版图 LVS 验证出现未定义问题](https://blog.csdn.net/qq_36686804/article/details/117249268)
- [EETOP > 求助 LVS 的时候 Source netlist references but does not define 1 subckt: mom_2t_ckt](https://bbs.eetop.cn/thread-860774-1-1.html)

我们尝试了在 `Inputs > Netlist > Spice Files` 中添加文件 `/home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre/lvs/source.added`, 但是此时出现了新的报错 `Syntax Error in file "/home/IC/OpAmp_LVS_20250721/OpAmp_Check_LVS.src.net" at line 14.`。

打开文件一看，发现是不知道哪里冒出来的 Rs, Cc 和 Rz 三个参数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-16-38-29_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>

将它们删除，将 `Export from schematic viewer` 取消 (否则会重新生成)，然后重新运行 LVS, 终于成功运行：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-16-40-10_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>

至于出现的警告 `WARNING: XDB Database not available: No comparison was made.`, 可以参考下面几个链接来解决：

- [EETOP > LVS 出现 warning：XDB Database not available: No comparison was made](https://bbs.eetop.cn/thread-890385-1-1.html): 可能是电源或地没有打 label 造成的
- [CSDN > WARNING : XDB Database not available. No comparison was  made.](https://blog.csdn.net/2301_81250487/article/details/134505683): 原理图和版图的 label 打的不一致
- [EDA Board > XDB Database not available Error (Cadence Virtuoso, Calibre LVS)](https://www.edaboard.com/threads/xdb-database-not-available-error-cadence-virtuoso-calibre-lvs.397303/): 提出了 in the "LVS Options" open the "Gates" tab and select "Turn off" in the "Gate Recognition" section 的解决方案

按照上面最后一条提到的 in the "LVS Options" open the "Gates" tab and select "Turn off" in the "Gate Recognition" section, 修改后重新运行 LVS, warning 确实不见了，此时的结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-17-02-25_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>



<!-- 下面是一个示例：

(1) 导出 schematic 的 `.cdl` 文件 (CIW > Export > CDL 然后选择对应的 schematic)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-14-41-56_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-14-42-33_Cadence Layout Example (tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).png"/></div>

(2) 在版图中点击 `Run nmLVS`, 选择此工艺库的 LVS 文件，然后在 Input > Spice File 中选择刚刚导出的 `.cdl` 文件
 -->



### 3.6 Metal Routing

一切准备工作就绪后，可以开始进行金属走线了。按组里师兄的说法，我们目前用 `tsmcN28` 工艺库，走线基本上都可以用到 M7 ~ M8, 因此不必担心走线层数不足的问题。另外，一些电流较大的走线一般要用过孔连接到更高的金属层，这是因为 M1, M2 等金属层的厚度和最大宽度都不如上层金属，其方块电阻和发热量也更大。

## 3. DRC Check 

注意, cellview 的名称里不能有小横杠 (减号) `-` 或小数电 `.`, 否则会导致 DRC 报错，下面是一个名称中含有小横杠 `-` 导致报错的例子：

``` bash
Specified primary cell OpAmp__twoStage_single_basic-nulling-Miller__60dB_370MHz_140uA__layout-v1-20250718 is not located within the input layout database.
```

## 4. LVS Check

并且 cellview 的名称不能过长 (最高好像是 60 字符)，否则

## 5. PEX

## 6. Post-layout Simulation