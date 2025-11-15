# 202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout (v6_171321)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 16:34 on 2025-09-17 in Beijing.

## 1. General Considerations

### 1.0 overview

本文，我们将对 `tsmcN65` 工艺下设计的 [basic capacitor-less LDO (v6_171321)](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).md>) 进行版图设计，并完成后续一系列工作，这包括：
- Layout (版图设计)
- DRC (设计规则检查)
- LVS (版图与原理图比对)
- PEX (寄生参数提取)
- Post-Layout Simulation (后仿)


本次 Layout 工作不直接用 v6_171321 的 schematic 进行，而是新建一个 cell view 命名为 `202509_LDO_basic_in1d7to2d65_out1d2__v6_171321_layout`，因为我们要基于 v6_171321 的原理图做一些小小的修改：
- (1) 将所有电容 (mim cap) 更换为 mom cap (单位容值稍小，但是高频特性极好)
- (2) 在 VREF 输入端加一个电容 (CREF)，起到滤波/去耦/降噪的作用，因为 VREF 是由其它组的 BGR 提供，我们不太清楚其输出噪声如何
- (3) 在 OUT 输出端加一个电容 (COUT)，起到滤波/稳定的作用，尽管会牺牲一定的 PM, 但通常对输出噪声/纹波有一定改善作用
- (4) 将 IBIAS 输入端管子的 multiplier 修改一下，使得接口处输入 100 uA 时，实际 IBIAS = 150 uA, 这可以通过 (m1, m2) = (2, 3) 来实现
- 注：(2) (3) 两条提到的电容均为 mom cap, 并且其具体容值暂时还不清楚，需要先生成 layout 后看看剩余面积如何，再决定容值大小；我们优先把面积给 CREF，因为 COUT 可以于最后集成阶段在 LDO 四周添加 (空余面积都可以利用)

### 1.1 layout settings

为提高 layout 设计效率，建议调整部分设置。在 Layout GXL 中打开版图，点击 `Options > Display`, 修改如下：
- <span style='color:red'> 打开布线时的 DRC 提示：`Options > DRD Edit > Enable Notify` </span>
- `Display Controls`: 在 `Option > Display` 中 Enable `Pin Names` and `Show Name Of > both`，然后打开 `Option > Net Name Display > Draw labels on top`, 并调整合适的颜色 (例如将白色改为黄色)
- `Dimming`: Enable `Dimming` (选中器件时会高亮对应器件，同时暗化其它器件)

### 1.2 layers and DRC rules

开始版图设计之前，得先确定此工艺库下的各个 layer 简称代表什么意思，以及阅读工艺库下的 DRC 文件，确定几个基本 DRC 规则的数值。详细的信息在文章 [Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library)](<AnalogICDesigns/Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).md>) 中有介绍，这里列出之前在 **tsmcN28** 28nm 工艺库下总结的表格，作为参考：


<span style='font-size:10px'>
<div class='center'>

| **DRC Rule** | **缩写全称** | **规则全称** | **含义解释** |
|-------------|-------------|-------------|-------------|
| **G.1** | **Grid Rule 1** | **Metal-1 Grid Alignment Rule** | 所有图形必须对齐 **0.005 µm 的整数倍网格**，确保制造精度。 |
| **NW.S.1** | **NW Space 1** | **N-Well Minimum Spacing Rule** | 相邻 **N-Well (NW)** 之间的最小间距必须 **≥ 0.24 µm**，防止阱区漏电。 |
| **NW.S.2** | **NW Space 2** | **N-Well Different Potential Spacing Rule** | 不同电位的 **NW1V (N-Well with Voltage)** 间距必须 **≥ 0.8 µm**，避免电压干扰。 |
| **NW.A.1** | **NW Area 1** | **N-Well Minimum Area Rule** | 单个 NW 图形的最小面积必须 **≥ 0.4 µm²**，确保工艺均匀性。 |
| **NW.A.2** | **NW Area 2** | **Composite N-Well/OD2 Area Rule** | 组合层（如 **OD2 OR NW, NW NOT OD2, OD2 AND NW**）的最小面积需 **≥ 0.4 µm²**。 |
| **OD2.S.5** | **OD2 Space 5** | **OD2 Exclusion Spacing Rule** | **NW 层中非 OD2 区域（NW NOT OD2）** 的最小间距需 **≥ 0.24 µm**。 |
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

</div>
</span>




如果对版图设计和验证的全流程还不太熟悉，建议先完成一次简单的反相器版图设计，详见文章 [知乎 > Cadence Virtuoso 教程 (八)：台积电 28nm 版图设计示例——包括 Layout, DRC, LVS, PEX 和后仿 (Post-Simulation)](https://zhuanlan.zhihu.com/p/1937319302949769830)。

### 1.3 layout steps

版图设计的主要流程与操作如下：
- (1) Preparations
    - (1.1) 修改原 schematic 中关键器件的参数，使其在版图中匹配性更好/性能更好 **(例如输入差分对使用 AB/BA + dummy 器件以提高匹配性)**
    - (1.2) 在 schematic 中添加 dummy 器件 (length = 30nm, fingers = 2)
    - (1.3) 检查所有器件参数是否正确
- (2) Generate layout
    - (2.1) 点击 `Generate All from Source`, **注意 I/O Pins 的金属属性应使用默认的 drw, 并且要在网络上打 pin label 才能过 LVS**
    - (2.2) 选择 `Place as in schematic`
- (3) Setting layout properties
    - (3.1) 利用 align 功能分离每一组器件 (这一步要注意 DRC)
    - (3.2) 依次选中各 MOS 管，在属性编辑中开启 gate contacts 和 route_Source_Drain 等，也即自动生成 gate contacts 和自动连接 multi-finger MOS 的 source/drain. **(在本次设计中，我们所有晶体管的 source/drain 都使用 M2 及以上金属层进行走线，因此无需打开 route_Source_Drain)**
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

从前仿 schematic 复制过来，仅修改了电容类型 (mim to mom) 时的 schematic/layout 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-18-42-16_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

顺便给一下参考电路的版图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-19-09-54_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-19-12-51_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>


### 2.1 modify schematic

参考电路中仅对输入差分对添加了 dummy devices 以提高 matching 性能，降低直流偏移以提高输出电压精度。简便起见，本次设计我们也仅对输入差分对添加 dummy devices. 输入管的原参数为：
- L = 0.9 um
- fingers = 40
- fingerWidth = 7.2u
- totalW = 40\*7.2u = 288 um (单个 multiplier 的宽度)
- multiplier = 1
- a = 1\*40\*8 = 320

我们将其修改为：
- L = 0.9 um
- fingers = 20 (减半)
- fingerWidth = 7.2u
- multiplier = 2 (乘二)

一共仿真四个 dummy, 每个 dummy 相当于两个 finger:
- L = 0.9 um
- fingers = 2
- fingerWidth = 7.2u
- multiplier = 4 (共四个 dummy)

除输入管外，功率管的参数也需要调整。因为连接 source/drain 的 M1 太过细长，达到了大约两百个 sheet resistor (0.160 Ohm/sq)，一共有 32 Ohm 左右了。尽管 finger 数很多，每个 S/D route 上分到的电流不到 0.5 mA, 但仍会对性能有一定影响。

功率管的原参数为：
- L = 1.4 um
- fingerW = 20 um
- fingers = 35
- multiplier = 2

我们将其修改为：
- L = 1.4 um
- fingerW = 5 um (除以四)
- fingers = 35
- multiplier = 8 (乘以四)

排版时发现 M6 过宽 (fingers*length 过高)，于是也将其拆分成两个 multiplier, 其原参数为：
- L = 0.7 um
- fingerW = 3.5 um
- fingers = 60
- multiplier = 1

修改后的参数为：
- L = 0.7 um
- fingerW = 3.5 um
- fingers = 30 (减半)
- multiplier = 2 (乘二)

202509_OTA_1V2_constantGm_adjustable__v1_271731

最后便是修改 MB1/MB2 的参数，这两个管子共五个 multiplier, 我们再添加一个 dummy 以方便排版。

**<span style='color:red'> 另外，我们还需要在版图剩下的空余面积中添加电容 CREF, 这件事情等 2.6 metal routing 一节完成后再来做。 </span>**

### 2.2 verify schematic

为了方便连接运放补偿网络 (Cc, Rz), 我们再将两个元件换一下位置，使电容靠近输出端。修改后的原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-20-27-06_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

做一下 Stability/PSRR/Noise 仿真，以检查没有引入新的问题：

稳定性仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-14-17-55_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-14-23-44_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>


PSRR/Noise 仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-14-04-23_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-14-30-46_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

和修改之前的仿真结果对比，没有出现什么明显差异，可以开始版图设计了。

### 2.3 verify schematic (2)

**2025-09-18 21:38 补：上面功率管的 bulk 接的是 VSS, 为了简化版图设计，我们将其改接 source (OUT)，重新验证一下：**

稳定性仿真：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-21-52-19_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-21-41-16_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

PSRR/Noise 仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-21-52-41_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-21-51-08_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

嗯，也是没有什么明显差异，可以继续版图设计。

### 2.4 generate layout

这一步主要是生成版图、大致排版，然后调整管子的自动连接属性。

生成版图并大致排版：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-21-53-09_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

调整各管子的自动连接属性：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-22-02-55_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

调整晶体管间距，并将各组晶体管 group 起来：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-22-06-50_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

### 2.5 guard ring and n-well

给每一组晶体管添加 guard ring, PSubGuardting for NMOS, NWellGuardring for PMOS, 并且 PMOS 的组还需要在外围套上大 n-well. 我们设置 **enclose by 0.5 (um)** 以避免 DRC 报错。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-22-16-21_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

然后套上大的 n-well:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-22-18-50_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

### 2.6 DRC test

在布线之前，先进行一下 DRC 以确定没有什么奇奇怪怪的问题。关于 DRC/LVS/PEX 和后仿的详细教程见 [知乎 > Cadence Virtuoso 教程 (八)：台积电 28nm 版图设计示例——包括 Layout, DRC, LVS, PEX 和后仿 (Post-Simulation)](https://zhuanlan.zhihu.com/p/1937319302949769830), 这里直接给出 DRC 结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-22-24-56_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

先一条一条看看，有没有现在就可以改的地方：

- **(1) NW.S.1 { @ Space >= 3.5**, 是 nch_25_dnw 中的 dnw (deep n-well) 间距过小造成的，只需给每组 nch_25_dnw 外面套上一个大 dnw 即可
- **(2) PO.R.8{@ It is prohibited for Floating Gate if the effective source/drain is not connected together**: 晶体管的 gate 未连线 (floating) 导致的，等做完 metal routing 后自然就没有了
- **(3) LUP.6 { @ Any point inside NMOS source/drain space to the nearest PW STRAP in the same PW <= 30 um** 等等 LUP 报错，通常是这是 N-Well/P-Sub 没有正确连接到 VDD/VSS 导致的
- **(4) DOD.R.1, DPO.R.1, DM1.R.1, DM2.R.1** 等等: 需要添加对应的 dummy, 例如 DOD 就是 dummy OD, 模块级设计无需考虑 
- **(5) CSR.R.1.DNWi, CSR.R.1.NWi** 等等 CSR 报错：这些是 full_chip 设计才需要考虑的，模块级设计无需考虑 (如果不想看见这些报错，可以参考 [这篇问答](https://bbs.eetop.cn/thread-967870-1-1.html) 关闭它们)
- **(6) ESD.WARN.1 {@ SDI is  not in whole chip** 等等 ESD 报错也是，模块级设计无需考虑

也就是说，除了前三个报错需要修正外，其它均可忽略，暂时没有什么问题。

为了方便观察，我们将第 (5) 条中的 FULLE_CHIP 检查关闭 (注释掉)，此时的 DRC 结果就简洁多了：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-01-21-01_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

### 2.7 LVS test

然后做一下 LVS check, 过程同样见文章 [here](https://zhuanlan.zhihu.com/p/1937319302949769830)，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-23-04-22_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-23-13-20_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

第一张图中有两个错误：
- **(1) Stamping conflict**: 两个网络通过某高阻 non-metal 路径短接，或者 Guardring 没有全部连到 VDD/VSS 上都会导致这个错误，我们等布线完再来修正
- **(2) WARNING: Invalid PATHCHK request "! POWER": no POWER nets present, operation aborted.** 这是 VDD/VSS 网络上没有打 pin 属性的 label 导致的，LVS 识别不到这俩网络，自然就会报错

第二张图中有三个 Softchk (soft check) 报错，事实上这三个报错都是 "一样的"，由 Guardring 未连到 VDD/VSS 上导致，布线完自然就没有了。

综上，LVS 检查也没有什么问题，可以开始金属布线了。

### 2.8 metal routing

布线前的版图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-23-37-14_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

**开始布线前最好是把 cell view 复制备份一下。**

先把最特殊的功率管大致布线一下。根据参考电路中的版图，我们直接在管子的 S/D 打孔，连接到 M7, 然后再从 M7 通过大过孔连接到 M9, 最后在 M9 上画大电流走线。功率管的 gate 则通过低层金属 M2 连接到一起，引出备用，之后会连到运放上 (这条金属是低电流线，因此走低层金属即可)。


**<span style='color:red'> 布线时一定要多多 DRC, 否则等步了一大堆才发现错误就白瞎了，删也删不完，追悔莫及。 </span>**

功率管走线画完后差不多是这样的：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-02-06-59_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

然后做输入差分管的版图，用 M2/M3 对称连接以提高匹配性。具体做法为：
- 先打过孔: 将四个 multiplier 的 source/drain 都直接由过孔打到 M5
- gate 由过孔打到 M3 并在 M2/M3 上对称连接 (引出 M3), M4/M5 用于 drain 的对称连接 (引出 M4), source 则在 M5 上全部连接到一起 (引出 M5)

打完过孔做好每个 multiplier 的连接，准备差分走线是这样的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-13-01-25_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

Gate 对称布线 (M2/M3):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-15-05-51_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

drain 对称布线 (M4/M5):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-15-07-34_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

source 由 M5 全部连接到一起 (也要中心对称), 然后用 M6 拉出。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-15-38-39_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

调整一下各器件的摆放和方向，准备进行杂七杂八的布线：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-20-32-06_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

**之前功率管的 bulk 连接的是 VSS, 我们将其改为了 OUT (直接连 source), 详见 2.3 verify schematic (2) 一节。** 修改后的功率管如下 (添加了 OUT/VDD 两层 guard ring)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-18-22-05-47_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

继续完成几个晶体管的连线：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-01-10-31_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-01-10-45_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

继续：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-02-01-23_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-02-14-24_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

布线基本完成后，再来连 VSS/VDD/OUT 等大电流路径：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-14-28-24_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

**<span style='color:red'> 利用 schematic 中的 navigator 检查布线情况，还可以右键固定网络高亮 (颜色可选)</span>**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-02-20-26_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

版图基本完成后的效果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-18-06-09_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-18-09-02_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

利用 `Connectivity > Show All Incomplete Nets` 可以检查各网络的链接情况，如下图：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-18-06-27_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

版图已经基本完成，下面进入 DRC 和 LVS 检查阶段。



### 2.10 DRC and LVS


图中除了功率管的 bulk (OUT) 和其中一组 NMOS 的 bulk (VSS) 高亮外，其它网络均未高亮，说明其它网络均已正确连接。可是为什么 OUT 和 VSS 却高亮了呢？我们运行以下 LVS 便能找到原因：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-18-10-16_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

笑脸表示各网络和器件均与原理图一致对应。但是 ERC (electrical rule check) 中却出现了 **stamping conflict** 的错误，这个错误意思是 **两个或多个网络通过某高阻 non-metal 路径短接到了一起**。

从 LVS 的报错可以看出这里是 **OUT** 和 **VSS** 两个网络短接了。查阅多方资料后发现，原来是我们的 OUT 和 VSS 都接到 global p-substrate 导致了高阻抗短接。这可以通过 deep n-well (DNW) 来解决，具体解释见这篇文章 [Virtuoso Tutorials - 14. Understanding Substrate, Well, Tap, and Guard Ring in Analog IC Layouts](<AnalogIC/Virtuoso Tutorials - 14. Understanding Substrate, Well, Tap, and Guard Ring in Analog IC Layouts.md>).

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-10-36-37_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

我们的电路中共有两种 NMOS: nch_na25 和 nch_25_dnw, 一种思路是给 nch_25_dnw (已有 PSubGR) 外围再加一个 n-well guard ring, 此时 global p-sub 就是功率管的 bulk (OUT)；另一种思路是将 nch_na25 (已有 PSubGR/NWellGR) 的 p-sub 隔离出来，此时 global p-sub 就是 nch_25_dnw 的 bulk (VSS)。

除了考虑哪种方法更好外，我们还必须考虑当前版图能不能支持这样修改，毕竟我们已经做了这么多版图，不可能将其全部推倒重来。观察一下当前版图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-22-38-53_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

我们考虑第一种方法 (将所有 nch_25_dnw 单独隔离出来)，此时 global p-sub 就是功率管的 bulk (OUT)，原因如下：
- 对于 nch_25_dnw: 我们用 dnw 的原因就是其具有更好的抗 latch-up 和抗噪声能力，若不选择将其衬底隔离开的话，则与普通器件无二，白白浪费了这个器件的优势


给 nch_25_dnw 创建 NWellGR 时，至少需要 enclose by 0.33 um 以 DRC 报错说避免 NW/PP 间距过小。**<span style='color:red'> Guard ring 添加完别忘了套上一个比 NWellGR 更大的 DNW, 否则起不到隔离作用。 </span>**

**关于 crtmom 导致 ERC 检查中出现的 floating n-well 报错，可以通过将其版图属性 "Well Type" 从 N 修改为 P 来解决。**

经过一番折腾，DRC 和 LVS 终于全部通过了？？？？LVS 确实全部通过了，但是 DRC 出现了一条 **DNW.S.5** 始终解决不了：

``` bash
DNW.S.5 { @  {RW OR PW} space to {RW interact with OD2} with different potential >= 1.2 um
  (EXT RW2V_NODAL < DNW_S_5 ABUT < 90 NOT CONNECTED SINGULAR REGION) NOT INSIDE SRAM_EXCLUDE
  (EXT RW2V_NODAL RW1V_NODAL < DNW_S_5 ABUT < 90 NOT CONNECTED SINGULAR REGION) NOT INSIDE SRAM_EXCLUDE
  (EXT RW2V_NODAL PWEL_NODAL < DNW_S_5 ABUT < 90 NOT CONNECTED SINGULAR REGION) NOT INSIDE SRAM_EXCLUDE
}
```


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-00-14-52_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-00-15-02_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-00-15-36_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

查资料查了整整一天，没有找到任何与 DNW.S.5 相关的解释和解决方案。最后还是回去看参考电路里的版图才找到解决方案： **<span style='color:red'> 将 DNW 上方用作包围的 NW 厚度增加到 >= 1.2 um 即可解决。 </span>** 虽然不知道为什么厚度不足时报的是 DNW.S.5 错误，并且错误描述也不太好理解，但总之问题解决了。


为保证隔离性能，**我们修改 nch_25_dnw 外围 NW 厚度 = 1.5 um**, 修改后的版图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-11-32-39_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

此时 DRC **(除 LUP.6 规则外)** 和 LVS 均全部通过了：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-11-53-04_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-11-53-41_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

这里的 LUP.6 报错是因为功率管中间的几个 source/drain 所在 OD 区域距离最近的 PP 太远。具体而言，我们的是通过 p-ring 上的 M1/OD/PP 将 VSS 连接到 p-sub, 要保证 source/drain 区域的性能，它们的 OD 附近必须有一个 "良好的 p-sub 环境"，也就是 source/drain 区域到最近的 p-sub 连接点 M1/OD/PP 的距离不能太远 (<= 30 um). 

我们到下一小节来解决这个问题。

### 2.11 bulk to VSS (v7_201154)

为了保证交接时的 DRC, 我们的 global p-sub (功率管的 bulk) 必须接到 VSS, 不能通过功率管 BS 短接从而接到输出端 OUT. 顺便再解决一下上一小节末尾提到的 LUP.6 报错。

这小节我们做下面几件事情：
- (1) 先修改功率管的 bulk, 将其从 OUT 改为 VSS (同步修改 p-ring 及其相关过孔)，
- (2) 为解决 LUP.6 报错，我们从 p-ring 的 VSS 上拉一条金属到功率管的中间位置，然后通过 M1/OD/PP 将其连接到 p-sub 上。
- (3) 应导师要求，对 VSS/VDD/OUT 等大电流路径进行加宽、加多处理，尤其是 VSS.



经过几轮优化，修改后的原理图和版图 **(v7_layout__PS_0920_1451)** 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-15-00-52_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-14-57-25_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

DRC 和 LVS 均全部通过了：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-15-02-18_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-15-03-13_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

名称中的 "PS" 表示 "Passed"，意思是完整通过了 DRC 和 LVS 检查。


## 3. PEX and Post-Simulation

### 3.1 (ac) PSRR and noise

下面先对这个 v7_layout__PS_0920_1451 (无 CREF 等额外电容) 进行 PEX 和后仿，看看后仿性能如何。



一开始我们用的是 CLIBREVIEW 格式，但是生成 calibre view 时等了整整两个小时不见生成完毕，果断放弃，改用生成 spice netlist 的方法 (生成 spice netlist 还有一个优势是无需担心 calibre.cellmap 时参数出错)。具体操作详见这篇文章 [Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation](<AnalogIC/Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.md>)，这里直接给出 PEX 和后仿结果。


设置 **Transistor Level** (不导入 x-cells 文件) 和 R + C + CC, 导出 DSPF 格式网表并进行后仿，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-49-16_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-23-15-41_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-23-21-15_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-51-04_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-18-00_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>


也顺便看一下各种输出格式/精度的后仿结果对比 (DSPF + Gate, DSPF + Transistor, HSPICE + Transistor)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-17-40-57_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-17-42-10_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

从 PSRR/Noise 的结果来看, Gate Level 仿真出来与前仿更接近。


这里的后仿只能作 Opt/PSRR/Noise 仿真，没办法仿真环路稳定性。要想仿真稳定性，我们需要另开一个版图，把反馈路径上的 `Vin-` 和 `Vmirror` 断开，并单独设置成两个 Pin, 详见下一小节。



### 3.2 (ac) loop stability

为避免名称过长，我们将新开的版图所在 cell view 命名为：

``` bash
202509_LDO_basic_in1d7to2d65_out1d2__v7_PS_0920_1451_stabili
```


名称长度 **不能超过 60 个英文字符**，例如下面的例子刚好是 60 个字符/字母：

``` bash
202509_LDO_basic_in1d7to2d65_out1d2__v7_layout__PS_0920_1451
```


**<span style='color:red'> 注意从原 cell view 复制过来后，symbol 必须重新创建，因为我们修改了端口的数量 (或名称)，symbol 的 CDF 信息发生了变化。</span>** 我们一开始就是因为没有重新创建 symbol, 导致仿真时 netlist 出错，具体表现为：

``` bash
# output log error:
 ERROR (SFE-45): "input.scs" 32: `I20': An instance of `202509_LDO_basic_in1d7to2d65_out1d2__v7_PS_0920_1451_stabili' needs at least 9 terminals (but has only 5).

# generated netlist:
LDO (IBIAS OUT VDD VREF VSS) \
        202509_LDO_basic_in1d7to2d65_out1d2__v7_PS_0920_1451_stabili

# correct netlist should be:
LDO (IBIAS OUT VDD VREF VSS VMIRROR VINN) \
        202509_LDO_basic_in1d7to2d65_out1d2__v7_PS_0920_1451_stabili
```



修改后的原理图和版图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-15-19-35_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-15-20-05_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

DRC/LVS 均全部通过：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-13-29-23_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-13-29-52_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

为提高 PEX 和后仿效率，我们考虑导出 DSPF 网表进行后仿。下面是用 DSPF (Transistor Level) 仿真不同负载下的稳定性结果：




为说明结果可靠性，我们又分别导出了 DSPF (Gate Level) 和 HSPICE (Transistor Level) 网表，在 20 pF 负载下统一进行后仿，对比它们的 RVE 和后仿结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-13-37-48_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-13-40-27_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-16-00-14_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-16-13-35_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-16-14-53_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>


**上面几张图可以看出，无论是 RVE 还是后仿, 不同格式 (同为 Transistor Level) 之间的结果基本没有差异，但是 Gate Level 和 Transistor Level 之间差异较大。** 哪一种更准确呢？这个问题其实没有绝对的答案，我们在文章 [Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation](<AnalogIC/Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.md>) 的 **6. Gate or Transistor Level?** 一节进行了具体的讨论，这里就不再赘述。

<!-- 我们认为是 Transistor Level. 从提取的角度来讲，它的精度更高/提取更细致，从后仿的角度来看，它的结果更接近已充分验证过的前仿 (是我们想要的)。 -->

<!-- 下面是 DeepSeek (2025.09.21) 对这两种方式的看法：

>**问：**在模拟集成电路设计进行后仿时，有的人用 Transistor Level (不导入 x-cells 文件) 进行参数提取和后仿，有的人则使用 Gate Level (导入 x-cells 文件)，这两种方法所得后仿结果哪种更准确？这里 x-cells 文件的作用是什么？用段落而非 list 回答我，并将结论总结成表格。<br><br> **答：** 在模拟集成电路设计中进行后仿真时，选择 Transistor Level（不导入 x-cells 文件）或 Gate Level（导入 x-cells 文件）的方法会影响结果的准确性和仿真效率。Transistor Level 后仿直接基于晶体管级网表进行参数提取，包括所有晶体管的寄生参数（如电阻、电容和电感），以及互连线的寄生效应，因此它更全面地反映了实际工艺的物理特性，尤其是对模拟电路中的匹配、噪声和高频行为等敏感效应捕捉得更精确，结果通常更接近流片后的实测性能。然而，这种方法计算量大、仿真速度慢，尤其适用于关键模块或高精度模拟电路的设计验证。
<br>相比之下，Gate Level 后仿通过导入 x-cells 文件（通常包含标准单元或预定义子电路的抽象模型，如门级网表或行为级模型），将部分电路（如数字逻辑单元）替换为等效的逻辑门级表示，从而减少仿真复杂度。x-cells 文件的作用是提供一种简化表示，以加速仿真并降低计算资源需求，但它可能忽略某些晶体管级的寄生细节或模拟行为，导致对混合信号电路中的模拟部分精度不足，尤其在高频或匹配要求高的场景中可能引入误差。因此，Gate Level 方法在数字主导或大规模混合信号电路中更高效，但准确性较低，尤其不适合纯模拟电路或高精度应用。
<br>总体而言，Transistor Level 后仿更准确，但仿真成本高；Gate Level 后仿效率高，但准确性有妥协，尤其依赖于 x-cells 文件的质量和覆盖范围。设计者需根据电路类型（如模拟、数字或混合信号）和验证目标（如精度 vs. 速度）选择合适方法。以下表格总结了关键比较：
| 方面                | Transistor Level (不导入 x-cells) | Gate Level (导入 x-cells) |
|---------------------|----------------------------------|--------------------------|
| 准确性              | 更高，包含完整寄生效应和晶体管细节    | 较低，依赖抽象模型，可能忽略部分寄生效应 |
| 仿真速度            | 慢，计算密集型                   | 快，资源高效             |
| 适用场景            | 高精度模拟电路、敏感匹配和高频应用   | 数字或大规模混合信号电路，注重效率 |
| x-cells 文件作用    | 不适用                           | 提供标准单元或子电路的简化模型，加速仿真 |
| 资源需求            | 高（内存和计算时间）             | 低                       |
| 推荐使用            | 关键模拟模块和后签核验证         | 初步验证或数字部分占主导的设计 |

 -->
### 3.3 post-simul. summary

下表总结了上面两节的后仿结果：

<span style='font-size:12px'>
<div class='center'>

| Parameter | Post-Simulation <br> using DSPF (Transistor Level) | Test Condition |
|:-:|:-:|:-:|
 | PM           | 85.86° ~ 98.96° | ILOAD = 15 mA |
 | GM           | 16.07 dB ~ 23.69 dB | ILOAD = 15 mA |
 | PSRR Peaking | -13.27 dB ~ -19.14 dB <br> -2.934 dB ~ -5.081 dB |  ILOAD = 10 uA <br> ILOAD = 15 mA |
 | PSRR @ DC    | -51.56 dB ~ -77.55 dB <br> -54.16 dB ~ -72.95 dB | ILOAD = 10 uA <br> ILOAD = 15 mA |
 | PSRR @ 5 MHz | -41.79 dB ~ -47.02 dB <br> -33.76 dB ~ -44.88 dB | ILOAD = 10 uA <br> ILOAD = 15 mA |
 | Output Noise @ 1 MHz | 10.25 nV/sqrt(Hz) ~ 14.97 nV/sqrt(Hz) <br> 10.25 nV/sqrt(Hz) ~ 14.92 nV/sqrt(Hz) | ILOAD = 10 uA <br> ILOAD = 15 mA |
 | Integrated Noise (100 Hz ~ 1 MHz) | 20.74 uVrms ~ 25.32 uVrms <br> 20.73 uVrms ~ 25.28 uVrms | ILOAD = 10 uA <br> ILOAD = 15 mA |
 |  Maximum Load Cap | 200 pF @ PM = 45° <br> 450 pF @ PM = 45° | ILOAD = 10 uA <br> ILOAD = 15 mA |
</div>
</span>

<!-- <div class='center'>

| Parameter | This Work | Reference |
|:-:|:-:|:-:|
 | PM | <span style='color:red'> 76.90° ~ 93.26° </span> | 80.8° ~ 82.62° |
 | GM | 15.15 dB ~ 17.85 dB | <span style='color:red'> 42.55 dB ~ 46.09 dB </span> |
 | PSRR Peaking | -2.305 dB ~ -4.585 dB <br> (-12.62 dB ~ -20.82 dB @ ILOAD = 10 uA) | -23.23 dB ~ -23.88 dB |
 | PSRR @ DC    | <span style='color:red'> -52.24 dB ~ -84.37 dB </span> | -60.79 dB ~ -63.94 dB |
 | PSRR @ 5 MHz | <span style='color:red'> -44.79 dB ~ -55.79 dB </span> | -38.44 dB ~ -40.51 dB |
 | Output Noise @ 1 MHz | <span style='color:red'> 9.993 nV/sqrt(Hz) ~ 14.73 nV/sqrt(Hz) </span> | 38.71 nV/sqrt(Hz) ~ 44.48 nV/sqrt(Hz) |
 | Integrated Noise (100 Hz ~ 1 MHz) | <span style='color:red'> 20.35 uVrms ~ 25.03 uVrms </span> | 50.25 uVrms ~ 68.55 uVrms |
 | Maximum Load Cap | 460 pF @ PM = 45° | <span style='color:red'> 5.0 nF @ PM = 45° </span> |
</div> -->

## 4. Additional CREF


**<span style='color:red'> 别忘了按导师要求，我们还需要在版图剩下的空余面积中添加电容 CREF (无需添加 CIN 和 COUT)，并且同时添加一个电阻 RREF。</span>** 对于这个电阻的作用，我的考虑是这样：
- (1) 滤波：BGR 那边参考电压过来类似于一个低输出电阻的含噪声电压源，这个 RC 网络可以滤掉一部分噪声
- (2) 稳定：平稳启动过程，启动时 VREF 这条线不至于电流过大，起到稳定作用
- (3) 隔离：VREF 传输过程中可能突然受到较大的干扰，RC 网络带来的较大时间常数可以 "缓冲/滤掉" 这种干扰，起到隔离作用

如下图，将所剩的版图面积填满得到 CREF = 14.52 pF:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-23-48-32_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

那么我们的电阻该选多少比较合适呢？电阻越大 (时间常数越大)，滤波/稳定/隔离性能越好，但是电阻带来的热噪声也越明显。只考虑输入噪声和 RREF 热噪声的分析如下：


上面的理论分析表明, RREF 越大，噪声性能越好。但其实我们粗略仿真下来，发现 RREF 对 Noise 的影响不大，反而会影响 LDO 的 PSRR 性能，下面的仿真说明了这一点：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-22-00-17-43_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-22-00-17-55_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-22-00-18-58_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-22-00-21-00_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

显然，这里过大的 RREF 只会恶化 PSRR 性能，所以我们考虑加 100 Ohm 以下的电阻。具体是多少呢？不妨选择 **RREF = 50 Ohm**. 毕竟 RREF 小了是可以的，但是绝对不能过大。


在原理图和版图中添加 CREF 和 RREF 后，记得将 CREF 的属性 Well Type 从 N 修改为 P 以避免 floating n-well 报错，版图做完之后在模块最外围加上 "内 P 外 N 的 guard ring" 以实现良好的隔离效果，最终原理图/版图如下 **(v7_PS_0920_1451_CREF)**：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-22-14-26-11_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-22-14-25-19_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-22-14-26-38_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

DRC/LVS 也是全部通过了的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-22-13-06-17_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-22-13-07-41_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

上面 LVS 报错说 "ERC > floating p-sub", 这是我们在模块最外围套了 n-well guard ring 导致的，是预料之中的，并且完全无害，到集成阶段正常连接 VSS 报错便自动消失。换句话说，将 n ring 去掉便不会存在任何 LVS 报错。



**这一小节的版图中也遇到过一些问题/经验，一并总结在这里：**
- 小型电路建议所有 net 都手动命名，避免版图复制后的 net 更新问题
- 从其它 cell > layout 复制部分版图到新 cell > layout 时，对出现版图元件 ROD 属性不对应的问题 (被刷新覆盖了)，如果直接点击 `Update Components and Nets` 会出现 `unbounded` 报错；这时只需在左下角找到 `Define Device Correspondence` 更新以下版图元件和原理图的对应关系即可

下图给出了 `v7_PS_0920_1451_CREF` 的 PSRR/Noise 后仿结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-23-19-23-36_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-23-19-24-28_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

和预期中的一样，上述结果与无电容版本 `v7_201154_layout` 的几乎没有区别。

## 5. P.S. (Postscript)

- 2025.10.08: 按导师要求，DNW 应该完全被 NW 覆盖，否则其隔离效果会大打折扣，我们在原 top cell `202509_LDO_basic_in1d7to2d65_out1d2__v7_PS_0920_1451_CREF` 的基础上修改了 DNW, 保存为 `202509_LDO_CREF_v8_10081442_PS` 并设置为新的 top cell. 其 Layout/DRC/LVS 效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-14-58-51_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-15-00-32_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-15-02-01_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

这里给出新版 PEX 的一些设置：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-15-12-20_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-15-30-14_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-15-23-14_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

分别提取 Gate 和 Transistor Level:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-15-30-33_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-15-35-34_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

顺便后仿验证一下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-15-44-56_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-16-32-58_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

前仿结果放在这里方便对比 (标注 Gate/Tran 但其实是前仿)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-15-44-17_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>

我们对比了一下 `Option > Job Setup` 中的 LSCS 和 ICRP control mode, 两者的仿真耗时分别为：
- LSCS: 29min
- ICRP: 30min

看来区别不大。观察发现，主要是卡在 opening psf 文件这一步，会卡很久。

