# Cadence Layout Example of Inverter in tsmcN28 (including DRC, LVS, PEX and Post-Simulation)

> [!Note|style:callout|label:Infor]
> Initially published at 17:30 on 2025-07-21 in Beijing.

## 1. Background

最近在做科研实践一的 [low-voltage bandgap reference](<Projects/Scientific Research Practice 1 (Low-Voltage BGR).md>)，这个项目需要在 `tsmcN28` (台积电 28nm CMOS 工艺库) 下进行完整的设计、前仿、版图和后仿流程。然而版图验证阶段就卡了我好几天，主要是 DRC, LVS 和 PEX 的流程不熟悉，每出现一个问题或报错就需要好几个小时寻找解决方案。因此我决定写一篇关于 DRC, LVS, PEX 和 Post-Simulation 的教程，记录下我在这个过程中遇到的问题和解决方案，以便以后参考，同时也是为了帮助其他同学入门。


本文，我们就以一个最简单的 CMOS Inverter 为例，完整地过一遍 DRC, LVS 和 PEX 流程，并在文末总结一些常见问题和解决方案。

先创建一个名为 `learning_DRC_LVS_PEX` 的 cellview, 然后随便放一对 PMOS 和 NMOS, 添加四个 Pin (VDD, VSS, VIN, VOUT).

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-17-45-05_DRC-LVS-PEX Example in tsmcN28.png"/></div>

然后完成版图工作。版图设计的主要流程与操作如下，其中 (1) ~ (5) 属于 **step 1: layout** 部分，算上后续的 DRC, LVS, PEX 和后仿，一共有五个部分：
- (1) Add Dummy Devices
    - (1.1) 在 schematic 中添加 dummy 器件 (length = 30nm, fingers = 2)
    - (1.2) 分别选中 NMOS 和 PMOS, 编辑属性 <span style='color:red'> 添加 gate contacts </span>
    - (1.2) 检查所有器件参数是否正确
- (2) Generate layout
    - (2.1) 点击 `Generate All from Source`
    - (2.2) 选择 `Place as in schematic`
- (3) Add Gate Contacts
    - (3.1) 利用 align 功能分离每一组器件 (这一步要注意 DRC)
    - (3.2) 将每一组晶体管 group 起来
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


<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-18-12-34_DRC-LVS-PEX Example in tsmcN28.png"/></div>
 -->


具体的版图教程见 [here (待补充)]()。简洁起见，我们就不添加什么 dummy 了，最终效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-18-17-21_DRC-LVS-PEX Example in tsmcN28.png"/></div>





## 2. DRC Example

在 `Calibre > Run nmDRC` 中打开 DRC 界面，主要步骤为：
- (1) 设置 DRC 文件和 Run Directory
- (2) 点击 `Run DRC` 以运行 DRC 检查
- (3) 查看检查结果并依次更正，直至达到 DRC 要求

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-18-13-06_DRC-LVS-PEX Example in tsmcN28.png"/></div>


我们的 DRC 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-18-18-53_DRC-LVS-PEX Example in tsmcN28.png"/></div>

下面依次更正：
- NW.A.1 { @ Area >= 0.4 : 用一个大 NW 包住 PMOS 的小 NW
- NW.A.2 { @ Area of {OD2 OR {NW OR NT_N}}, {NW NOT OD2}, {OD2 NOT NW}, {OD2 AND NW} >= 0.4 : 上面的操作即可解决
- WEL.A.1 { @ Area of {{{{{OD2 OR NW} OR NT_N} SIZING 0.08 um} SIZING -0.16 um} SIZING 0.08 um}, {{{{{OD2 NOT NW} NOT NT_N} SIZING 0.08 um} SIZING -0.16 um} SIZING 0.08 um}, {{{{NW NOT OD2} SIZING 0.08 um} SIZING -0.16 um} SIZING 0.08 um}, {{{{NW AND OD2} SIZING 0.08 um} SIZING -0.16 um} SIZING 0.08 um} >= 0.4 : 上面的操作即可解决
- PO.DN.3.1 { @ Minimum {{{PO OR SR_DPO} OR DPO} NOT CPO} local density [window 10 um x 10 um, stepping 5 um] >= 0.1 : 此错误为 PO 密度不够所致，可以忽略
- LUP.6 { @ Any point inside PMOS source/drain space to the nearest NW STRAP in the same NW <= 33 um : 这是 N-Well 和 P-Sub 没有正确连接 VDD/VSS 导致的，我们需要添加 guard ring 和大 NW 来解决。对于 NMOS 这一块, PP 也是 p-sub 的一种, guard ring 上的 VSS 连到 PP, 也就相当于连到了 p-sub, 所以啥也不用加；而 PMOS 这一块，需要加一个大的 NW, 这样才能把 PMOS 的 NW 接到 guard ring 上的 VDD.

<!-- 画一个 CO (contact)，再画一个 OD 包裹住 CO (否则 DRC 报错)，最后用 M1 将此 contact 连接到 VDD/VSS 上即可 -->
<!-- 
上面需要注意的是, CO 的 width 是固定死的，不能大也不能小，在 `tsmcN28` 中是 0.04 um, 原文是 `Width (maximum = minimum) = 0.04`. 然后还需要用 NP (N-Plus Implant, 对应 NMOS) 或 PP (P-Plus Implant, 对应 PMOS) 将 OD 包裹住。
-->

修改后的效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-20-04-40_DRC-LVS-PEX Example in tsmcN28.png"/></div>

当然，有的观点认为给 NMOS 这一块加一个大的 PW (P-Well) 会更保险一些，这也是有道理的，效果如下: (PW 和 PP 之间并无间距要求)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-21-20-07-31_DRC-LVS-PEX Example in tsmcN28.png"/></div>

## 3. LVS Example


DRC 通过之后，就可以进行 LVS (layout versus schematic) 检查了，主要步骤为：

- (1) 在版图中点击 `Run nmLVS`, 选择此工艺库的 LVS 文件，例如 `/home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/lvs/calibre.lvs`
- (2) 在 `Rules` 中设置 LVS Rules File 和 run directory
- (3) 开启 `Inputs > Netlist > Export from schematic viewer`
- (4) 在 `Setup > LVS Options` 中设置好电源网络和地网络，我们这里设置的是 VDD 和 VSS
- (5) 勾选 `LVS Options > Gate Recognition > Turn off` (这一步是为了避免 `WARNING: XDB Database not available`)
- (6) 点击 `Run LVS`, 等待结果

其实 LVS 这一步是非常容易出现或大或小的问题的，比如报错 "WARNING: XDB Database not available: No comparison was made", 又比如报错 "source primary cell not found in source database", 以及一些其它问题，详见 **6. Common Problems in LVS** 一节。



输出结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-22-00-38-47_DRC-LVS-PEX Example in tsmcN28.png"/></div>

首先观察到有两个 warning, 这是我们没有添加对应网络的 top-level text 导致的 (参考 [this article](https://community.sw.siemens.com/s/question/0D54O00006eo5CzSAI/lvscalibre))。点击 `L` 添加 label, layer 选择 M1-text,  分别为 VDD 和 VSS 添加 label (字体选择 roman, 高度比原 label 更高以便区分)，然后点击 `Run LVS` 重新运行，此时输出如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-22-00-50-17_DRC-LVS-PEX Example in tsmcN28.png"/></div>

可以看见 warning 已经没有了，这是再来解决 comparison results 里的 **missing port** 问题。


以 `** missing port **  VDD on net: VDD` 为例，这是 netlist 中出现了 VDD 这个端口，但是在 layout 中没有标示出来导致的，最可能的原因是 VDD 的原 label 用了 drawing 属性而非 pin 属性 (参考 [this article](https://blog.csdn.net/weixin_45881793/article/details/125582866))。回去一检查，确实是这样：我们 VDD 网络的原标签 (小的那个 label) 用的是 M1-drw (M1-drawing), 将四个端口的 label 都改为 M1-pin 属性后，重新运行 LVS:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-22-00-57-11_DRC-LVS-PEX Example in tsmcN28.png"/></div>

LVS 给出了笑脸，说明检查成功通过，与原理图完全一致。


**<span style='color:red'> 上面的错误告诉我们，以后在版图 generate from source 时，应该将 Pin label 的属性设置为 M1-pin 而不是 M1-drw. </span>**


## 4. PEX Example

接下来我们提取版图参数 (PEX, Parasitic Extraction), 主要步骤如下：
- 在 `Calibre > Run PEX` 中打开 PEX 界面，设置好 PEX Rules File 和 run directory
- 在 `Input > Netlist` 一栏勾选 `Export from schematic viewer`
- 在 `Output > Extraction Type` 中选择 Transistor Level, (R + C + CC), No Inductance
- 在 `Output > Netlist` 中选择 `Format > CALIBREVIEW`
- 在 `PEX Options > Netlis > Format` 中勾选 Ground node name 并输入 VSS (点击 `PEX Options` 时可能出现报错，详见 **7.1 problem with file access** 一节)
- 在 `PEX Options > LVS Options` 中输入 power nets = VDD, ground nets = VSS
- 点击 `RUN PEX` 运行 PEX, 等待结果 (R + C + CC 通常会比较慢，因为要导出走线之间的电容) 
- 点击 `Run PEX`，等待结果

导出完成后，又弹出来两个窗口 (一共三个)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-22-01-50-41_DRC-LVS-PEX Example in tsmcN28.png"/></div>

右边窗口是导出的 PEX netlist file, 里面包含了所有的原始元件和 parasitic 元件 (电阻、电容等)，中间窗口是 PEX 的结果，左边是预览带寄生参数原理图的设置。这里还可以打开 RVE 来观察每一个网络对应的总寄生参数，详见 [this video (16 分 10 秒)](https://www.bilibili.com/video/BV1By4y1A7zC)，我们略过。

左边的 `Cellmap File` 一栏要选择工艺库对应的 `.cellmap` 文件，通常也在 `rcx` 文件夹下。但是我们的 `tsmcN28` 库却没有给这个文件，无奈拿 `tsmc18rf` 工艺库的 `.cellmap` 文件来凑合用，路径是：

``` bash
/home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d_OA/Calibre/calview.cellmap
```

设置好路径后选择 `Calibre View Type > schematic`, 勾选 `Open Calibre CellView > Read-mode`, 点击 OK 打开，效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-22-02-05-49_DRC-LVS-PEX Example in tsmcN28.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-22-02-08-04_DRC-LVS-PEX Example in tsmcN28.png"/></div>

上面这个 calibre shcematic 会保存到 cellview 下的 calibre, 与 shcematic 和 layout 平级。



## 5. Post-Simulation

最后一步便是后仿 (Post-Layout Simulation)，也是高精尖模拟电路设计中最 “激动人心” 的一步。任何一个电路设计想要有实际的应用价值，都必须过后仿这一关，尤其是低功耗、高频率等领域。如果后仿结果与前仿接近，会令人非常开心，但这基本上是一种 “奢望”，大多数情况下，后仿结果会离奇得多。

我们先给出 Pre-Layout Simulation 的示例，再做 Post-Layout Simulation, 并将两者做一个对比。正常打开 ADE L 或者其它的什么仿真器，进行瞬态仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-22-02-23-30_DRC-LVS-PEX Example in tsmcN28.png"/></div>

要想进行后仿，只需点击 `Setup > Design`, 然后选择 cell name 为 `learning_DRC_LVS_PEX` 下的 calibre, 点击 OK 并运行仿真，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-22-02-44-42_DRC-LVS-PEX Example in tsmcN28.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-22-02-48-31_DRC-LVS-PEX Example in tsmcN28.png"/></div>

可以看到，后仿的结果和前仿确实有一定差异。保险起见，我们可以点开 `SImulation > Netlist > Display` 来看一下电路的网表是不是确实是带寄生参数的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-22-02-49-43_DRC-LVS-PEX Example in tsmcN28.png"/></div>

网表确实带寄生参数的，说明后仿是成功的。至此，我们完成了一个完整的 DRC, LVS, PEX 和后仿流程。


## 5. Common Problems in DRC

### 5.1 Design Rule Reference

以下是 `tsmcN28` 工艺库 (台积电 28nm CMOS 工艺库) 的 **Cadence Virtuoso 版图 DRC 报错规则** 详细解释，包含 **缩写全称**、**规则全称** 及 **含义说明**：



| **DRC Rule** | **缩写全称** | **规则全称** | **含义解释** |
|-------------|-------------|-------------|-------------|
| **G.1** | **Grid Rule 1** | **Metal-1 Grid Alignment Rule** | M1 层所有图形必须对齐 **0.005 µm 的整数倍网格**，确保制造精度。 |
| **NW.S.1** | **NW Space 1** | **N-Well Minimum Spacing Rule** | 相邻 **N-Well (NW)** 之间的最小间距必须 **≥ 0.24 µm**，防止阱区漏电。 |
| **NW.S.2** | **NW Space 2** | **N-Well Different Potential Spacing Rule** | 不同电位的 **NW1V (N-Well with Voltage)** 间距必须 **≥ 0.8 µm**，避免电压干扰。 |
| **NW.S.9** | **NW Space 9** | **N-Well Parallel Run Length Spacing Rule** | 当 NW 平行走线长度 **> 0.5 µm** 且未与 **OD/SR_DOD/DOD** 交互时，间距需 **≥ 0.3 µm**。 |
| **NW.A.1** | **NW Area 1** | **N-Well Minimum Area Rule** | 单个 NW 图形的最小面积必须 **≥ 0.4 µm²**，确保工艺均匀性。 |
| **NW.A.2** | **NW Area 2** | **Composite N-Well/OD2 Area Rule** | 组合层（如 **OD2 OR NW, NW NOT OD2, OD2 AND NW**）的最小面积需 **≥ 0.4 µm²**。 |
| **OD.DN.3** | **OD Density 3** | **Active Layer Local Density Rule** | 在 **20 µm × 20 µm** 窗口（步进 10 µm）内，**OD/DOD/SR_DOD** 的密度必须 **≥ 20%**，防止刻蚀不均匀。 |
| **OD2.S.5** | **OD2 Space 5** | **OD2 Exclusion Spacing Rule** | **NW 层中非 OD2 区域（NW NOT OD2）** 的最小间距需 **≥ 0.24 µm**。 |
| **PO.DN.3.1** | **PO Density 3.1** | **Poly Local Density Rule** | 在 **10 µm × 10 µm** 窗口（步进 5 µm）内，**PO/SR_DPO/DPO（排除 CPO）** 的密度必须 **≥ 10%**。 |
| **M1.S.2** | **M1 Space 2** | **M1 Width-Dependent Spacing (W1/L1)** | 当至少一条 M1 线宽 **> 0.1 µm** 且平行走线长度 **> 0.22 µm** 时，间距需 **≥ 0.06 µm**。 |
| **M1.S.3** | **M1 Space 3** | **M1 Width-Dependent Spacing (W2/L2)** | 当至少一条 M1 线宽 **> 0.18 µm** 且平行走线长度 **> 0.22 µm** 时，间距需 **≥ 0.1 µm**。 |
| **M1.S.4** | **M1 Space 4** | **M1 Width-Dependent Spacing (W3/L3)** | 当至少一条 M1 线宽 **> 0.47 µm** 且平行走线长度 **> 0.47 µm** 时，间距需 **≥ 0.13 µm**。 |
| **M1.S.5** | **M1 Space 5** | **M1 Width-Dependent Spacing (W4/L4)** | 当至少一条 M1 线宽 **> 0.63 µm** 且平行走线长度 **> 0.63 µm** 时，间距需 **≥ 0.15 µm**。 |
| **M1.S.8** | **M1 Space 8** | **M1 Dense Line-End Spacing Rule** | 对 **密集 M1 线端**（定义见注释）的最小间距需 **≥ 0.07 µm**，防止短路。 |
| **M1.EN.3** | **M1 Enclosure 3** | **M1 Over CO (Contact) Enclosure Rule** | 当 M1 线宽 **> 0.7 µm** 时，M1 对 **CO (Contact)** 的覆盖必须 **≥ 0.03 µm**。 |
| **M1.EN.4** | **M1 Enclosure 4** | **M1 Narrow Space CO Enclosure Rule** | 当 M1 线宽 **≥ 0.08 µm**、M1 间距 **< 0.06 µm** 且平行走线 **> 0.18 µm** 时，M1 对 CO 的覆盖需 **≥ 0.015 µm**（不适用于 CO 间距 **< 0.08 µm** 的情况）。 |
| **M1.A.1** | **M1 Area 1** | **M1 Minimum Area Rule** | M1 图形的最小面积必须 **≥ 0.0115 µm²**。 |
| **M1.A.3** | **M1 Area 3** | **M1 Small Feature Area Rule** | 当 M1 图形所有边长 **< 0.13 µm** 时，面积需 **≥ 0.038 µm²**（排除 **0.05 µm × 0.13 µm** 的填充图形）。 |
| **M1.A.4** | **M1 Area 4** | **M1 Enclosed Area Rule** | M1 封闭区域的最小面积必须 **≥ 0.2 µm²**。 |
| **LUP.6** | **Latch-Up 6** | **NMOS/PMOS Substrate Tap Proximity Rule** | **NMOS 源/漏区** 到同 **PW (P-Well) STRAP** 的距离 **≤ 33 µm**，**PMOS 源/漏区** 到同 **NW (N-Well) STRAP** 的距离 **≤ 33 µm**，防止闩锁效应（Latch-Up）。 |

### 5.2 Error LUP.6 (STRAP Error)

DRC 的 LUP.6 错误详情：
``` bash
LUP.6 { @ Any point inside NMOS source/drain space to the nearest PW STRAP in the same PW <= 33 um
        @ Any point inside PMOS source/drain space to the nearest NW STRAP in the same NW <= 33 um
    PACT_CHECK NOT NSTP_OS
    NACT_CHECK NOT PSTP_OS
}
```

这是 N-Well 和 P-Sub 没有正确连接 VDD/VSS 导致的，我们需要添加 guard ring 和大 NW 来解决。对于 NMOS 这一块, PP 也是 p-sub 的一种, guard ring 上的 VSS 连到 PP, 也就相当于连到了 p-sub, 所以啥也不用加；而对 PMOS 这一块，需要加一个大的 NW 将 guard ring 连带内部的小 NW 包裹住, 这样才能把 PMOS 的 NW 接到 guard ring 上的 VDD.

### 5.3 



## 6. Common Problems in LVS

### 6.1 missing port

我们在 **3. LVS Example** 一节已经说明了如何处理：将各 port (pin) 的原始 label 从 M1-drw 改为 M1-pin, 重新运行 LVS 即可：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-22-00-57-11_DRC-LVS-PEX Example in tsmcN28.png"/></div>

### 6.2 Source netlist references but does not define subckts:

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

### 6.3 source primary cell not found in source database

名称字符问题或名称太长

### 6.4 ERROR: Supply error detected. ABORT ON SUPPLY ERROR is specified - aborting


### 6.5 WARNING:  Stamping conflict in SCONNECT - Multiple source nets stamp one target net.

``` bash
WARNING:  Stamping conflict in SCONNECT - Multiple source nets stamp one target net.
Use LVS REPORT OPTION S or LVS SOFTCHK statement to obtain detailed information.
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-23-03-34-57_Cadence Layout Example of Inverter in tsmcN28 (including DRC, LVS, PEX and Post-Simulation).png"/></div>


大多是因为 Guard ring 没有全部连到 VDD 或者 VSS 上。



## 7. Common Problems in PEX

### 7.1 problem with file access

在点击 PEX Option 按钮时，软件会先编译一遍刚刚设置好的 PEX Rules File, 这是可能会报错找不到某个文件：
``` bash
Error while compiling rules file /home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/calibre.rcx:
Error INCL1 on line 4126 of /home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/calibre.rcx - problem with access, file type, or file open of this include file: /home/library/TSMC/tsmc28n/1p9m6x1z1u_2v5/Calibre_new/rcx/DFM/dfm_device.
```

这是文件路径不对导致的，找到 `rcx` 文件夹下的 `dfm_device` 文件, 复制其 **绝对路径** 然后粘贴到 `calibre.rcx` 文件中，覆盖原来错误路径。报错中的 line 4126 可能不太准，我们直接 `Ctrl + F` 搜索 `/home/library/TSMC/` 字段进行修改。

将其全部替换为我们自己的 `/home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/DFM/`



例如，我们自己的正确路径是：

``` bash
// 修改前共四个不正确路径, 分别在 line 4114, 29027, 29028, 29069
INCLUDE /home/library/TSMC/tsmc28n/1p9m6x1z1u_2v5/Calibre_new/rcx/DFM/odSpace.encrypt 
INCLUDE /home/library/TSMC/tsmc28n/1p9m6x1z1u_2v5/Calibre_new/rcx/DFM/metal_boundary.encrypt
include /home/library/TSMC/tsmc28n/1p9m6x1z1u_2v5/Calibre_new/rcx/rules
INCLUDE /home/library/TSMC/tsmc28n/1p9m6x1z1u_2v5/Calibre_new/rcx/DFM/dfm_device

// 分别修改为我们自己的路径：
INCLUDE /home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/DFM/odSpace.encrypt
INCLUDE /home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/DFM/metal_boundary.encrypt
INCLUDE /home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/rules
INCLUDE /home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/DFM/dfm_device
```

然后还需要修改 `dfm_device` 中的内容，这是一个 include 其它 files 的文件，里面也是一堆路径，将其改成正确的绝对路径即可。下面是修改前后的对比：

``` bash
// 修改前
INCLUDE /home/zhangyd21/Desktop/T28/Calibre_new/rcx/DFM/variable_file
INCLUDE /home/zhangyd21/Desktop/T28/Calibre_new/rcx/DFM/logic_operation.encrypt
INCLUDE /home/zhangyd21/Desktop/T28/Calibre_new/rcx/DFM/dfm_pmos_macro_file.encrypt
INCLUDE /home/zhangyd21/Desktop/T28/Calibre_new/rcx/DFM/dfm_nmos_macro_file.encrypt



// 修改后
INCLUDE /home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/DFM/variable_file
INCLUDE /home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/DFM/logic_operation.encrypt
INCLUDE /home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/DFM/dfm_pmos_macro_file.encrypt
INCLUDE /home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/DFM/dfm_nmos_macro_file.encrypt
```

当然，其他文件也可能出现路径错误，具体需要根据报错信息来修改。比如下面几项是我们修改过的路径报错：

``` bash
Error while compiling rules file /home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/calibre.rcx:
Error INCL1 on line 126 of /home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/Calibre_new/rcx/rules - problem with access, file type, or file open of this include file: /home/library/TSMC/tsmc28n/1p9m6x1z1u_2v5/Calibre_new/rcx/xrc_mapping.
```

### 7.2 导出的晶体管尺寸正常却在后仿中报错

导出寄生参数后进行仿真，晶体管的尺寸明明在正常范围内，仿真器却仍然报错说尺寸不符合范围要求，下面是在 [this design](<AnalogIC/Cadence Layout (202507_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__60dB_370MHz_140uA).md>) 中遇到的一个例子：

``` bash
Error found by spectre during initial setup.
    ERROR (CMI-2440): "/home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/tsmcN28/../models/spectre/./cln28ull_2d5_elk_v1d0_2.scs" 23247: MMb4@10:  The length, width, or area of the instance does not fit the given lmax-lmin, wmax-wmin, or areamax-areamin range for any model in the `MMb4@10.pch' group. The channel width is 7.200000e-07 and length is 2.400000e-07. Specify channel width and length that do not exceed the referenced maximal area Lmax=9.001000e-07, Lmin=2.700000e-08, Wmax=2.700100e-06,and Wmin=9.000000e-08. You can choose the nearest model by setting the value of `soft_bin' option to `allmodels'.
    ERROR (CMI-2440): "/home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/tsmcN28/../models/spectre/./cln28ull_2d5_elk_v1d0_2.scs" 23247: MM8:  The length, width, or area of the instance does not fit the given lmax-lmin, wmax-wmin, or areamax-areamin range for any model in the `MM8.pch' group. The channel width is 1.000000e-07 and length is 3.000000e-08. Specify channel width and length that do not exceed the referenced maximal area Lmax=9.001000e-07, Lmin=2.700000e-08, Wmax=2.700100e-06,and Wmin=9.000000e-08. You can choose the nearest model by setting the value of `soft_bin' option to `allmodels'.
    ERROR (CMI-2440): "/home/IC/Cadence_Process_Library/tsmc28n_2v5_OA/tsmcN28/../models/spectre/./cln28ull_2d5_elk_v1d0_2.scs" 23247: MMb4:  The length, width, or area of the instance does not fit the given lmax-lmin, wmax-wmin, or areamax-areamin range for any model in the `MMb4.pch' group. The channel width is 7.200000e-07 and length is 2.400000e-07. Specify channel width and length that do not exceed the referenced maximal area Lmax=9.001000e-07, Lmin=2.700000e-08, Wmax=2.700100e-06,and Wmin=9.000000e-08. You can choose the nearest model by setting the value of `soft_bin' option to `allmodels'.
```

参考 [this answer](https://community.cadence.com/cadence_technology_forums/f/custom-ic-design/28893/soft_bin-allmodels/1332428#1332428), 我们在 ADE L (或 ADE XL Test Editor) 中找到 `Simulation > Options > Analog > Miscellaneous > Additional arguments`, 然后输入下面这一行：

``` bash
soft_bin=allmodels
```


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-23-19-25-31_Cadence Layout Example of Inverter in tsmcN28 (including DRC, LVS, PEX and Post-Simulation).png"/></div>

## 8. Summary 