# Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 16:55 on 2025-09-20 in Beijing.



## Introduction

起因是在最近的项目 [Design of A Basic Low Dropout Regulator (LDO) for BB-PLL](<Projects/Design of A Basic Low Dropout Regulator (LDO) for BB-PLL.md>) 做版图时，遇到了寄生参数提取时间过长的问题。其中 PEX 提取倒不算慢，但是 calibre view 生成非常非常慢，一个 LDO 的版图等了三个小时也没见生成好，因此果断放弃这种方法，改用提取 netlist 进行后仿。

本文就先介绍最通用的 **"提取并生成 calibre view"** 方法，然后介绍速度明显更快的 **"提取并生成 netlist"** 方法 (包括 DSPF/SPECTRE/HSPICE 等多种格式)。当然，也会顺便介绍一下如何利用提取得到的 calibre 或者 netlist 进行后仿真 (post-simulation)。

>注，后文所有寄生参数提取都是以  [202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.md>) 中的 **v7_layout__PS_0920_1451** 为例。



## 1. PEX Steps 

无论使用哪种格式/方法在 PEX 界面提取寄生参数网表，它们的操作都基本相同，因此这里先介绍如何进行 PEX 提取：
- (1) 打开 PEX 并设置 file 和 dir: 
    - `Calibre > Run PEX`，设置好 `PEX Rules File` 和 `run directory`；`PEX Rules File` 通常是以 `.rcx` 为后缀的文件，例如我们的路径是 `/home/IC/Cadence_Process_Library/tsmcN65/Calibre/rcx/calibre.rcx`；**其中 `run directory` 建议设置在当前 cellview 目录下，且新建一个标明本次提取格式的子文件夹** `PEX_HSPICE/PEX_DSPF/PEX_SPECTRE` 等 (这个子文件夹与 schematic/layout/symbol 同级)；例如设置为 `/home/xxx/our_cellview/PEX_HSPICE` 
- (2) 设置 Netlist 来源: 
    - `Inputs > Netlist > Export from schematic viewer`
    - `Inputs > Netlist > Spice Files` 添加文件 `source.added`
- (3) 设置输出精度: 
    - `Output > Extraction Type` 选择提取精度，一般都是 **`Gate Level` (配合 x-cells)** 或 **`Transistor Level` (不配合 x-cells)**，然后阻容选择 `R + C + CC` (电阻 + 电容 + 互容)
    - **(Optional)** `Inputs > H-Cells > PEX x-Cells file` 导入 x-cell 文件，如果是 Transistor Level 则不需要导入 (也不建议导入，否则可能出现重复提取寄生参数的问题)
- (4) 设置输出格式: 
    - `Output > Netlist > Format`，常用的有 `CALIBREVIEW`, `DSPF`, `HSPICE`, `SPECTRE` 等；本文所介绍的后仿方法适用于后三种: `DSPF`, `HSPICE`, `SPECTRE`；而 `CALIBREVIEW` 格式需要生成专门的 calibre view 进行后仿，生成这一步所耗的时间太长太长，而且容易出错，因此被我们抛弃
- (5) 设置 PEX Options:
    - `PEX Options > Netlist > Format > Ground node name` (与 schematic/layout 中的地名称保持一致)
    - **(Optional)** 如果需要减小网表大小/加快提取速度/加快仿真速度 (但是牺牲一定精度)，可以在 `PEX Options > Netlist > Reduction and CC` 中设置 `Enable MinCap Reduction` 和 `Enable MinRes Reduction`；COMBINE 就是将阈值以下的电阻/电容的节点合并到最近的节点，REMOVE 就是阈值以下所有的寄生电阻或寄生电容去掉不提取 (一般仅设置 COMBINE)；**常规电路 (核心频率 1 GHz 以下) 通常设为 (0.01 Ohm, 0.01 fF)**，再高频的电路可以设为 (0.0001 Ohm, 0.0001 fF).
    - `PEX Options > LVS Options > Power nets / Ground nets` 设置电源和地 (与 schematic/layout 中的电源/地名称保持一致)
    - **`PEX Options > Misc > Create top level pin order + SOURCE + All Pins` (若不勾选，后仿时还需要手动修改网表端口，很麻烦)**
- (6) 设置多线程以加快提取速度:
    - `Run Control > Run Calibre > Multi-Threaded`
- (7) 运行寄生参数提取：
    - 点击 `RUN PEX` 运行 PEX, 等待结果；在多线程情况下，导出 10 MB 左右的寄生网表需要 30s ~ 60s，单线程 60s ~ 120s (耗时仅作参考)


**可能上面的文字描述比较抽象，下面以一个 LDO 的版图为例，演示如何进行 PEX 提取：**

- (1) 打开 PEX 并设置 file 和 dir: 
    - `Calibre > Run PEX`，设置好 `PEX Rules File` 和 `run directory`；`PEX Rules File` 通常是以 `.rcx` 为后缀的文件，例如我们的路径是 `/home/IC/Cadence_Process_Library/tsmcN65/Calibre/rcx/calibre.rcx`；**其中 `run directory` 建议设置在当前 cellview 目录下，且新建一个标明本次提取格式的子文件夹** `PEX_HSPICE/PEX_DSPF/PEX_SPECTRE` 等 (这个子文件夹与 schematic/layout/symbol 同级)；例如设置为 `/home/xxx/our_cellview/PEX_HSPICE` 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-00-43-46_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>


- (2) 设置 Netlist 来源: 
    - `Inputs > Netlist > Export from schematic viewer`
    - `Inputs > Netlist > Spice Files` 添加文件 `source.added`

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-00-47-29_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>



- (3) 设置输出精度: 
    - `Output > Extraction Type` 选择提取精度，一般都是 **`Gate Level` (配合 x-cells)** 或 **`Transistor Level` (不配合 x-cells)**，然后阻容选择 `R + C + CC` (电阻 + 电容 + 互容)
    - **(Optional)** `Inputs > H-Cells > PEX x-Cells file` 导入 x-cell 文件，如果是 Transistor Level 则不需要导入 (也不建议导入，否则可能出现重复提取寄生参数的问题)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-00-48-22_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

- (4) 设置输出格式: 
    - `Output > Netlist > Format`，常用的有 `CALIBREVIEW`, `DSPF`, `HSPICE`, `SPECTRE` 等；本文所介绍的后仿方法适用于后三种: `DSPF`, `HSPICE`, `SPECTRE`；而 `CALIBREVIEW` 格式需要生成专门的 calibre view 进行后仿，这一步可能需要非常非常久的时间，而且容易出错，因此被我们抛弃

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-00-50-12_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

- (5) 设置 PEX Options:
    - `PEX Options > Netlist > Format > Ground node name` (与 schematic/layout 中的地名称保持一致)
    - `PEX Options > LVS Options > Power nets / Ground nets` 设置电源和地 (与 schematic/layout 中的电源/地名称保持一致)
    - **`PEX Options > Misc > Create top level pin order + SOURCE + All Pins` (若不勾选，后仿时还需要手动修改网表端口，很麻烦)**
    - **(Optional)** 如果需要减小网表大小/加快提取速度/加快仿真速度 (但是牺牲一定精度)，可以在 `PEX Options > Netlist > Reduction and CC` 中设置 `Enable MinCap Reduction` 和 `Enable MinRes Reduction`；COMBINE 就是将阈值以下的电阻/电容的节点合并到最近的节点，REMOVE 就是阈值以下所有的寄生电阻或寄生电容去掉不提取 (一般仅设置 COMBINE)；**常规电路 (核心频率 1 GHz 以下) 通常设为 (0.01 Ohm, 0.01 fF)**，再高频的电路可以设为 (0.0001 Ohm, 0.0001 fF).



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-00-56-04_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

<!-- 四张分图片：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-00-52-02_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-00-53-03_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-00-53-58_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-00-55-47_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
-->

- (6) 设置多线程以加快提取速度:
    - `Run Control > Run Calibre > Multi-Threaded`

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-00-57-30_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>


- (7) 运行寄生参数提取：
    - 点击 `RUN PEX` 运行 PEX, 等待结果；在多线程情况下，导出 10 MB 左右的寄生网表需要 30s ~ 60s，单线程 60s ~ 120s (耗时仅作参考)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-00-57-48_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

导出完毕后还可以点击 `Start RVE` 查看寄生电容情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-27-56_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>


## 2. Post-Simulation

### 2.1 Using CALIBREVIEW

由于 CALIBREVIEW 格式无法通过 netlist 进行后仿 (必须生成 calibre view)，不但生成时间太长太长 (30 s 就能导出的 10 MB netlist，生成 calibre view 却要三个多小时)，而且生成得到器件属性容易出错 (必须合理设置 reset 参数)，因此被本文抛弃。


这里仅介绍导出 CALIBREVIEW 网表的操作，具体的后仿例子，详见文章 [知乎 > Cadence Virtuoso 教程 (八)：台积电 28nm 版图设计示例——包括 Layout, DRC, LVS, PEX 和后仿 (Post-Simulation)](https://zhuanlan.zhihu.com/p/1937319302949769830)。

导出 CALIBREVIEW 网表的步骤与上一节 **2. PEX Steps** 完全一致，只是格式换成 CALIBREVIEW 而已。这里直接从寄生网表提取完毕，弹出 calibre view 生成窗口开始说起：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-21-36_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

右边窗口是导出的 `CALIBREVIEW netlist`, 里面包含了所有的原始元件和 parasitic 元件 (电阻、电容等)，中间窗口是 PEX 的结果，左边是预览带寄生参数原理图的设置。这里还可以打开 `RVE` 来观察每一个网络对应的总寄生参数，详见 this video (16 分 10 秒)，我们略过。

左边的 Cellmap File 一栏要选择工艺库对应的 .cellmap 文件，通常也在 rcx 文件夹下。在 cellmap file 处选择 tsmcN28 工艺库对应的 cellmap 文件，通常后缀为 `.cellmap` 或者 `.yaml_calibre`。

设置好 cellmap 文件后选择 `Calibre View Type > schematic` 以及 `Open Calibre CellView > Read-mode`，最重要的是设置 `Reset Parameters`，生成 calibre view 时必须 reset 的几个参数为：

``` bash
m=1 nf=1 segments=1
```
- `m=1` 和 `nf=1`: 提取后的晶体管是以 finger 为单位的，假设原来有一个晶体管 M1 是 finger = 4, m = 2, 提取出来就是 8 个晶体管；如果没有设置 `m=1` 和 `nf=1`，这八个晶体管会继承原晶体管的各项参数，也就是八个晶体管都为 finger = 4, m = 2 (fingerW 和 length 保持不变), 这样所生成的 calibre 中，这个 M1 晶体管实际上有 32 个 finger, 这就不对了。我们之前因没有设置 `nf=1` 在这点上吃过亏。
- `segments=1`: 类似地，这个参数是将所有电阻的 segments 参数 reset 为 1.


点击 OK 以生成 calibre view，生成后的效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-31-24_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-35-20_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>






### 2.2 Using DSPF/HSPICE/SPECTRE

DSPF/HSPICE/SPECTRE 格式所导出的都是网表 spice netlist, 它们可以直接用于后仿而无需其他修改，并且后仿步骤完全类似。这里以 DSPF 为例，介绍如何进行后仿 (配合 config 文件)：

导出 DSPF 格式的寄生参数后，可以看到文件夹 `/home/xxx/our_cellview/PEX_DSPF` 下有这些文件：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-04-39_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

其中 `PEX_DSPF/xxx.pex.netlist` 就是我们待会要用到的寄生参数网表。在搭建的 test bench 中创建好 config, 然后打开 ADE L 或者 ADE XL 的 Test Editor, 在 Setup 选项中选择 config 文件，这是后面操作的基础。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-08-25_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

接下来就简单了，要想使用 DSPF 导出的网表进行后仿，只需打开 config, 右键需要换成后仿的器件并点击 `Specify SPICE Source File`，选择刚刚导出的寄生参数网表 `xxx.pex.netlist`，然后点击 config 左上角的 "保存" 按钮即可：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-11-53_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-13-33_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-14-41_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>


这时运行仿真，如果生成的 `input.scs` 文件里没有任何器件参数，并且在末尾 `include` 了我们刚刚指定的寄生参数网表 `xxx.pex.netlist`，就说明后仿成功了：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-16-14_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

等待仿真完毕，便可以愉快地查看结果了：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-23-20-09_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-18-00_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

下面我们分别导出 DSPF/HSPICE/SPECTRE 三种格式进行后仿，对比它们的结果和仿真速度：

### 2.3 DSPF Results

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-49-16_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-23-15-41_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-23-21-15_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-51-04_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-18-00_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>


### 2.4 HSPICE Results

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-23-02-07_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-23-08-08_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-56-13_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

### 2.5 SPECTRE Results

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-23-25-59_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-23-25-12_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-53-02_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>


## 3. Speed and Accuracy

上面这么多中导出格式，哪种更快更准呢？我们导出的过程发现寄生参数提取所需时间差别不大，于是来对比一下不同格式的仿真速度：

<div class='center'>

| Format | Simulation Time |
|:-:|:-:|
| DSPF | 16 min |
| HSPICE | 16 min |
| SPECTRE | 30 min |
</div>


上表可以看出 DSPF 和 HSPICE 的速度差不多，且都比 SPECTRE 快不少 (快近一倍)。这与我们的经验相符，因为一般认为 SPECTRE 的精度会高一些 (相比于 DSPF/HSPICE 等格式)。

顺便对比它们的仿真结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-01-58-39_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

(上图 HSPICE 的 Vgs/Vgate 结果顺序反了)

这三组结果不是仅仅比较相似，而是近乎一模一样了，也从侧面说明了不同格式的寄生参数提取都比较可靠。当然，同一种格式下，不同提取精度 (Gate/Transistor Level) 也会影响提取结果, Gate 因为有已经封装好的 x-cell, 提取出的小寄生器件会少很多，仿真更快；Transistor Level 仿真时间稍长，但结果要更精确一些。



## 4. Other Post-Simulation Methods

本文介绍的 PEX 和后仿方法是我们目前用下来认为最简单、最高效、最可靠的方法，当然也有其他方法，下面就简要介绍一下。

### 4.1 using CALIBREVIEW

下面是几种常用的 CALIBREVIEW 后仿方法：
- **(1) calibre + ADE L:** 修改 Environmental Options 里 Switch View List 的顺序，把 calibre 放 schematic 前面 (现在基本上不单独用 ADE L 了，所以这种方式很少用，详见 [[6]](https://zhuanlan.zhihu.com/p/6580714389))
- **(2) calibre + ADE XL/Explorer:** 用 config 设置 set cell view **(常用的就是这种方法)**
- **(3) calibre + ADE Assembler:** 使用 ADE assembly 的 add config sweep, 详见参考文章 [[6]](https://zhuanlan.zhihu.com/p/6580714389)

用 calibre view 进行后仿的过程也是见文章：[知乎 > Cadence Virtuoso 教程 (八)：台积电 28nm 版图设计示例——包括 Layout, DRC, LVS, PEX 和后仿 (Post-Simulation)](https://zhuanlan.zhihu.com/p/1937319302949769830)，这里略过。



### 4.2 using DSPF



DSPF 的后仿和 CALIBREVIEW 的差不太多，区别是 DSPF **生成后缀为 .netlist 的网表**，所以不会有 Calibre view setup 界面 (其实 CALIBREVIEW 也会生成网表？)。下面是后仿方法：
- **(1) dspf + ADE L:** 和 calibre 方法一类似，通过修改 switch view list, 把 dspf view 放 schematic 前面就好了
- **(2) dspf + ADE XL/Explorer:** 和 calibre 方法二类似，通过 config 设置 set cell view 
- **(3) dspf +  ADE Assembler:** 和 calibre 方法三类似，也是 add config sweep, 详见参考文章 [[6]](https://zhuanlan.zhihu.com/p/6580714389)
- **(4) dspf + ADE L/XL/Explorer:** 打开 Test Editor (类似 ADE L 的界面)，在 `Simulation Files > Parasitic Files (DSPF)` 里添加寄生网表路径 `/xxx/xxx/xxx.pex.netlist` 就好，注意，如果设置了这一步，就不要修改 switch view list 的顺序了。


### 4.3 using SPECTRE

如果采用 spectre 提取的寄生，一定一定要遵循上一小节里 **把 create all pin 勾上，以及选上 source**，这样就不需要再手动修改网表。SPECTRE 后仿方法如下：
- **SPECTRE 方法一：** 改 input.scs, 我们不推荐 (详见 [[6]](https://zhuanlan.zhihu.com/p/6580714389))
- **SPECTRE 方法二：** 利用 `analogLib` 库中的元件 `scasubckt` 创建后仿电路模型，需要手动操作 netlist, 不推荐 (详见 [[6]](https://zhuanlan.zhihu.com/p/6580714389))
- **SPECTRE 方法三：** 在 config 中导入 spice netlist **(最简单也是最推荐)**
- **SPECTRE 方法四：** ADE assembly 同时实现 spectre view 的前后仿，也很麻烦，不推荐 (详见 [[7]](https://mp.weixin.qq.com/s?__biz=MzUyNzA2MDA0OQ==&mid=2247528418&idx=1&sn=0a799d2c6d32a8974e11fea3b2d5759b))


### 4.4 using HSPICE

使用 HSPICE 进行后仿的步骤与前面类似，这里就不再提了。

## 5. Post-Simul. Tips

后仿中也有各种提高效率的小技巧，下面详细介绍几个。

### 5.1 save selected node

后仿在寄生网表下进行，阻容特别多，如果按照默认的保存全部电压节点去仿真会严重浪费硬盘空间，因此建议只保存需要观察的节点。

在 ADE L 或者 ADE XL 的 Test Editor 里，勾选 `Outputs > Save All > Save Options > selected` (默认是 `allpub`) 即可，或者设置 `lvl + level=1` 仅保存 top level 节点 (无法查看内部节点)。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-15-35-46_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

另外，在后仿时还可以利用 `.scs` 文件指定需要保存的器件，具体例子见 [CSDN > Cadence virtuoso 保存所有静态工作点](<https://blog.csdn.net/weixin_42221495/article/details/129611418>) 和 [知乎 > 如何在 DSPF 后仿中只保存自定义节点的仿真数据？](https://zhuanlan.zhihu.com/p/9488973897)，这样就可以设置 `lvl + level=1` 以节省空间了。


下面是一些实测结果 (完全相同的仿真设置，仅数据保存设置不同)：

<div class='center'>

| Interactive | 所有 outputs 是否勾选 save | 数据保存设计 | 是否有 MM0 dcopt 数据 | 是否有噪声数据 | 数据量大小 |
|:-:|:-:|:-:|:-:|
 | interactive.180 | 否 | lvl + level=0 | no  | yes | 28.4 MB |
 | interactive.181 | 否 | lvl + level=1 | no  | no  | 72.0 MB |
 | interactive.188 | 否 | lvl + level=2 | yes | no  | 200.2 MB |
 | interactive.189 | 否 | lvl + level=3 | yes | yes | 2.6 GB |
 | interactive.182 | 否 | selected      | yes | yes | 2.6 GB |
 | interactive.192 | 是 | lvl + level=0 | no  | yes | 28.4 MB |
 | interactive.186 | 是 | lvl + level=1 | no  | no  | 72.0 MB |
 | interactive.190 | 是 | lvl + level=2 | yes | no  | 200.2 MB |
 | interactive.191 | 是 | lvl + level=3 | yes | yes | 2.6 GB |
 | interactive.184 | 是 | selected      | yes | yes | 2.6 GB |
 | interactive.199 | 是 | lvl + level=0 + <br> save I0.MM0:all (Definition Files) | no | yes | 28.4 MB |
 | interactive.200 | 是 | lvl + level=0 + <br> save I0.MM0:all (Stimuli Files)    | no | yes | 28.4 MB |
 | interactive.201 | 是 | lvl + level=0 + <br> ave I0.MM0:all + save I0/MM0:all (Stimuli Files)  | no | yes | 28.4 MB |
 | interactive.202 | 是 | lvlpub + level=0 | no  | yes | 35.2 MB |
 | interactive.203 | 是 | lvlpub + level=1 | no  | no  | 203.6 MB |
 | interactive.204 | 是 | lvlpub + level=2 | yes | no  | 396.8 MB |
 | interactive.205 | 是 | lvlpub + level=3 | yes | yes | 2.6 GB |
 | interactive.206 | 是 | allpub           | yes | yes | 2.6 GB |
</div>

上表可以得出以下结论：
- (1) 设置 `selected` 是 "无效" 的，网上似乎也存在有效的例子，但我们这里不知为何仍相当于保存全部数据
- (2) 设置 `lvl + level=0` 或者 `lvlpub + level=0` 可以显著节省空间，但是只保留了 top level 数据，无法查看任何内部节点
- (3) 利用 `.scs` 文件的 `save I0.MM0:all` 似乎也行不通，有待进一步考察

一句话总结就是，上面提到的几种方法都不能解决此问题。最终参考下面几篇文章，我们考虑使用 `analogLib` 库中的 deepprobe:
- [Cadence Blogs > Virtuosity: What's New in analogLib > Deepprobe](https://community.cadence.com/cadence_blogs_8/b/cic/posts/virtuosity-what-39-s-new-in-analoglib)
- [Cadence Blogs > Virtuoso Studio: Schematic Syntax for Hierarchical Nodes and Buses in DeepProbe](https://community.cadence.com/cadence_blogs_8/b/cic/posts/enhanced-schematic-syntax-and-buses-a-game-changer-for-analog-design)
- [Bilibili > 后仿真查看内部节点电流/电压（参考）](https://www.bilibili.com/opus/926079336561246226) 

这两篇文章是直接将 deepprobe 放在 schematic 中仿真的，我们也可以使用此方法，因为后仿所导入的网表只是 I0 这一器件的网表 (利用 config 文件), schematic of test bench 也是包含在总网表内的。下面是几个 deepprobe 的示例 (using SPECTRE format)：
- **<span style='color:red'> 查看模块 I0 内部晶体管 MM0 的 gate 端电压：`I0.N_VGATE_MM0_g` </span>**，其中 `N_VGATE_MM0_g` 是到 netlist (SPECTRE format with transistor level) 下搜索 `MM0 ` 查看的器件各端口名 (也即网络名)
- 其它尝试过但是行不通的输入：
    - 所有含 `:`, `/` 但是未转义的
    - `\/I0\/N_VGATE_MM0_g`
    - `I0\/N_VGATE_MM0_g`
    - `I0.MM0.G`
    - `I0.MM0@2.G`
    - `/I0/MM0/G`
    - `I0.MM0/G`
    - `I0.MM0.N_VGATE_MM0_g`
    - `I0.MM0\/N_VGATE_MM0_g`
    - `I0.MM0\:N_VGATE_MM0_g`
    - `I0\/MM0\/N_VGATE_MM0_g`
    - `\/I0\/MM0\:N_VGATE_MM0_g`
    - `\/I0\/MM0\/N_VGATE_MM0_g`
- 如果遇到报错 Unexpected operator "/", 说明此格式下需要转义符号，将 `top_level.level1/level0/net_name` 改为 `top_level.level1\/level0\/net_name` 即可

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-23-01-41-30_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-23-01-36-37_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-23-01-47-30_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

我们上面的例子是使用 SPECTRE format with transistor level 提取出的寄生网表，整个 netlist 是 flat 的，因此所有器件都在 I0 下面，直接输入 `I0.net_name` 即可查看各网络的电压值。

HSPICE 格式的操作和 SPECTRE 完全类似，都是在 netlist 中找到器件，其 pin name 就是 net name, 输入即可。下面是一个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-23-11-36-20_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-23-11-41-55_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-23-11-43-00_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>







我们再单独试试 DSPF 格式下如何填入网络名：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-23-01-43-42_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

我们尝试了很多，也没有找到可行的输入。下面是尝试但单行不通的输入：
- 所有 `:` 和 `/` 符号未转义的
- `I0.MM0.g`
- `I0.MM0\:g`
- `I0.MM0\/g`
- `I0\/MM0.g`
- `I0\/MM0\:g`
- `\/I0\/MM0.g`
- `\/I0\/MM0\/g`
- `\/I0\/MM0\:g`
- `I0.MM0.G`
- `I0.MM0\/G`
- `\/I0\/MM0\/G`

好吧我们暂时没找出 DSPF 格式下应该怎么输入网络名，留到之后再进一步讨论。

2025.09.23 11:01 看了一下 DSPF 格式的语法 ([here](https://wenku.baidu.com/view/d8eec221fc4ffe473368abc1.html?_wkts_=1758597812888&needWelcomeRecommand=1&unResetStore=1)), 发现上图中 `MM0:g` 之类的只是器件的 pin name 而非 net name, 于是重新查看 dspf netlist 再次尝试。


仍不行的：
- `\/I0\/VGATE`
- `I0.VGATE`
- `I0\/VGATE`
- `I0.VGATE.2`
- `\/I0\/VGATE\:2`
- `I0.VGATE\:2`
- `I0\/VGATE\:2`
- `\/I0\/MM8@20\/g`
- `\/I0\/MM8@20\:g`
- `I0\/MM8@20\:g`
- `I0.MM8@20\:g`


罢了，以后还是导出 HSPICE 和 SPECTRE 格式的网表吧，DSPF 就不用了。

### 5.2 multi-job simulation

设置 `ADE XL > Options > Job Set > Setup > Max jobs = 4`，这样可以同时跑多次仿真，加快仿真速度。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-15-53-55_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>

<!-- ## 6. Gate or Transistor Level?

有关 PEX 提取时到底是使用 Gate Level (with x-cells) 还是 Transistor Level (without x-cells), 我们这里再多讨论一下。

### 6.1 Calibre® xRC™ User's Manual

- Calibre® xRC™ User's Manual (Software Version 2009.1): https://picture.iczhiku.com/resource/eetop/wYItYWLPleWrpvNV.pdf

这篇文章主要讨论的是 Hierarchical Extraction 和  Flat Transistor-Level Extraction 之间的选择：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-21-18-40-44_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div> -->

### 5.3 high-perfor. simulator

本小节参考 Reference 中的 [9] ~ [15].

截至 2025.09.20, 除 Spectre 以外 virtuoso 还支持使用 APS, Spectre X, Spectre FX 等高性能仿真器进行仿真，在相同精度下的仿真速度为 Spectre < APS < Spectre X < Spectre FX. 参考链接 [[11]](https://picture.iczhiku.com/weixin/message1582550787289.html) 给出了一个对比示例，Spectre X 的速度是 APS 的 3.7 ~ 9.2 倍。

下面是一些使用/设置技巧：
- (1) APS: 
- (2) Spectre X: Preset 可设置为 CX/AX/MX/LX/VX, 其中 CX 精度最高 (速度最慢)，VX 为速度最快 (精度最低)；参考 [here](https://bbs.eetop.cn/thread-983266-1-1.html) 可以知道，功能性验证用 MX 甚至 VX, 指标性验证最低 AX, 最好是用 CX.
- (3) Spectre FX: FX 也是类似地，与 X 的 preset 几乎相同，只是不具有 CX 选项，最高精度为 AX.

2025.10.26 补：最近在做一个 ultra-low power PLL 的项目，环路后仿时间较长，如果使用 Spectre 来做仿真，就算仅代入 RVCO 的后仿网表 (其它模块都用 Verilog-A) 单次也需要 60min 左右，于是尝试使用其它仿真器来做后仿，并对比它们的速度和结果精度。

下表中，未指明仿真精度的话就是默认 `Do not override`，其它参数未指明的话就是使用默认设置。

<div class='center'>

| Simulator | Spectre | APS | (Spectre X using) VX, MX, CX | (Spectre FX using) VX, MX, AX |
|:-:|:-:|:-:|:-:|:-:|
| Run Time| > 20m | > 20m |  484 s (8m 3.6s), 481 s (8m 0.9s),  832 s (13m 52.1s). | 54.5 s (0m 54.5s), 69.5 s (1m 9.5s),  169 s (2m 48.7s) |

</div>

这里在测试的时候经常出现如下 Simulator 报错：
``` bash
FATAL (SPECTRE-19): Bus error signal received by Spectre. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem. 
FATAL (SPECTRE-18): Segmentation fault. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file.
```

查阅以下资料：
- [EETOP > 解决 Spectre 仿真报错Segmentation Fault (during AHDL read-in)](https://bbs.eetop.cn/thread-983285-1-1.html): 楼主是因为 linux 的 memory segments 最大数量太小了，系统是 centos 7.9 默认 4096 条，改为 16384 条后问题解决
- [CSDN > spectre 仿真器中断](https://blog.csdn.net/weixin_42221495/article/details/140003274): 认为是当前 spectre 仿真器仿不了这么大容量的仿真，需要换仿真器
- [博客园 > XPS MS 遇到 segmentation fault 错误](https://www.cnblogs.com/li2000/p/18296503/Analog-Cadence-Virtuoso-ADE-XPSMS): 博主提出/收集了多种可能原因，包括 服务器内存不够、没设置64位、未知错误（尝试重启 virtuoso 或者服务器端口）等，他认为最稳妥的方法是重启 virtuoso
- [EETOP > Spectre 仿真报错，Internal error found in spectre during AHDL read-in](https://bbs.eetop.cn/thread-887124-1-1.html): 楼主提出了三种解决方案，22楼提出了另一种：
- 使用 `ipcs -p |wc -l` 查看共享内存的条数  然后 `cat /proc/sys/kernel/shmmni` 的数值，看前面数值是否超过后面的。如果超过了，第一方法是删除共享内存的条数，把 `ipcs -p` 查询到的进程 `pid kill`；第二种是用 `sysctl -w kernel.shmmni=16384` 更改最大数值 (默认是 4096 条)

我们尝试了以下办法：
- (1) 重启 virtuoso
- (2) 勾选 `Environment > Run with 64-bit binary`，并且在 `Environment > Use Command-Line Options` 中输入 `-64`
- (3) 在 (2) 的基础上，重启 virtuoso 再次尝试
- (4) 删除之前一些比较大的仿真数据，大概删了 100 GB 左右吧，还是不行

现在 Spectre FX 完全用不了了，无论设置 multi-thread 还是 single-thread, 无论 design 用前仿还是后仿网表，总是报 segmentation fault 错误。然后 Spectre X 是仿真到一大半时才会报错，例如下面这样：

``` bash
    tran: time = 3.93 ms     (64.4 %), step = 5 ns        (81.9 u%)
    tran: time = 3.939 ms    (64.5 %), step = 1.755 ns    (28.8 u%)
    tran: time = 3.949 ms    (64.7 %), step = 1.265 ns    (20.7 u%)
    tran: time = 3.958 ms    (64.8 %), step = 5 ns        (81.9 u%)
    tran: time = 3.967 ms      (65 %), step = 5 ns        (81.9 u%)
    tran: time = 3.975 ms    (65.1 %), step = 5 ns        (81.9 u%)
    tran: time = 3.984 ms    (65.3 %), step = 5 ns        (81.9 u%)
    tran: time = 3.993 ms    (65.4 %), step = 2.5 ns        (41 u%)
    tran: time = 4.002 ms    (65.6 %), step = 5 ns        (81.9 u%)
    tran: time = 4.011 ms    (65.7 %), step = 5 ns        (81.9 u%)
    tran: time = 4.02 ms     (65.9 %), step = 2.528 ns    (41.4 u%)

Internal error found in spectre at time = 4.02582 ms during transient analysis `tran'.
FATAL (SPECTRE-19): Bus error signal received by Spectre. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem.
FATAL (SPECTRE-18):  Segmentation fault. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package 
```

非常奇怪：为什么一开始能用，用着用着反而不行了？

**2025.10.27 补：我们后来又修改了一下，Spectre/APS 的设置保持默认不变，而 Spectre X/FX 都改为 `(manual) Multi-Thread = 4` (无论 preset 是什么) 之后，莫名又全部能用了。** 最终得到不同仿真模式的 nominal corner (TT, 27°C) 结果汇总如下：

<div class='center'>

| Simulator | Spectre | APS | (Spectre X using) VX, MX, CX | (Spectre FX using) VX, MX, AX |
|:-:|:-:|:-:|:-:|:-:|
 | Run Time @ 10nA, 15MOhm, 30pF, 2.5\*1600/(CLK_REF\*N)  | 3.39 ks (56m  30.4s) | 2.32 ks (38m  41.1s) | VX = 944 s (15m  44.3s) <br> MX = 1.31 ks (21m  47.2s) <br> CX = 1.42 ks (23m  43.6s) | VX = 78.8 s (1m  18.8s) <br> MX = 123 s (2m  3.0s) <br> AX = 191 s (3m  10.8s) |

</div>

<div class='center'>

| 全部仿真结果对比 | 波形对比 (Spectre, APS, Spectre X + CX, Spectre FX + AX) | 波形对比 (Spectre X, Spectre FX) |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-00-55-08_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-01-04-54_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-01-03-01_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-01-01-24_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-00-34-26_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>    
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-00-40-38_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div>    
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-00-43-52_Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.png"/></div> |
</div>

## 6. Cautions for CALIBREVIEW

**在使用 Calibre PEX 导出 calibre view 时，有以下几点需要注意：**
- (1) Assembler Test 要用 config 作为 design, 并且这个 config (of tb schematic) 里要想 sweep 的模块需设置为 schematic view. 可以进行 config sweep 的格式，必须是像 schematic/calibre 这样可以直接选择的，这是因为这些 view 的文件夹中有一个指向 `sch.oa` 的 `master.tag` 文件，有了这个文件 Cadence 才能正确识别。像其它的寄生参数格式，例如 HSPICE/SPECTRE 之类的，我们目前还没有找到能用在 config sweep 的例子，暂时只能在 config 中手动选择 `Specify SPICE Netlist` 来调用。
- (2) 用 cellmap 导出 calibre view 时，最麻烦也是最重要的一点就是设置 `Reset Parameters` 这一步，如果没有正确 reset 管子的 finger 或者电阻/电容的 segments, 就会导致 calibre view 和实际 schematic/layout 不一致，从而得到错误的后仿结果。
- (3) config sweep 不能放在 local variable of the explorer test 中，否则一旦取值不当 (例如设定其值为 1) 会出现 `Segmentation fault` 错误，导致 virtuoso 崩溃退出；就算设置了 "正确" 的值，也没有作用，必须是在 global variable 中设置 config sweep 才能生效。




导出 calibre 的推荐设置：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-28-00-08-46_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>

没有任何警告和报错才是大概率没问题的：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-28-00-09-39_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>




## Reference


这里记录了本文参考的几篇文章，以及它们的主要内容/观点：
- [1] [cnblogs > cadence 使用 calibre 进行后仿的几种方法](https://www.cnblogs.com/Felix-sin/p/15510215.html)
    - (1.1) 生成 calibre view 将 calibre view type 从 schematic 改为 masklayout 可以加快生成速度，但这时生成的 calibre view 以 layout 的摆放位置提取寄生参数，查看各 net 信号不是那么方便
    - (1.2) 或者直接在 pex 设置中, output-Netlist-Format 更改为 SPECTRE 生成网表，此时方法生成的网表需修改 pin 参数才能用于后仿，文章中有详细说明，或者看这篇文章 [知乎 > 后仿真 calibre 寄生参数 PEX 提取方法](https://zhuanlan.zhihu.com/p/564399927) 中的步骤更好一些 (也介绍了查看寄生电容/电阻的方法)
- [2-3] [EETOP > [求助] 关于 calibre 提取寄生参数的问题](https://bbs.eetop.cn/thread-863759-1-1.html) 和 [EETOP > [求助] 寄生参数提取后，筛选的问题](https://bbs.eetop.cn/thread-599642-1-1.html): PEX 提取里有个 RC reduction 选项可以设置提取参数的最小单位 (最小值), 1 GHz 以下的电路通常设为 (0.01 Ohm, 0.01 fF), 再高频的电路可以设为 (0.0001 Ohm, 0.0001 fF).
- [4] [知乎 > 模拟 IC 设计--calibre 后仿真碎碎念](https://zhuanlan.zhihu.com/p/578599757): 
    - (4.1) xcells 或者 hcells 文件的作用就是令文件里的模块内部不在进行寄生参数提取 (已经在 xcells 里封装好了)，从而加快 PEX 速度 **(注意使用 xcells 时应选择 gate level, 选择 transistor level 会重复提取寄生参数，结果反而不准确)**
    - (4.2) 用的做多的还是 Gate Level 提取，将一些 device 进行模块化，不进一步提取这些 device 的寄生参数，Transistor Level 数据量太大
    - (4.3) RC reduction 设置中, COMBINE 就是将阈值以下的电阻/电容的节点合并到最近的节点，REMOVE 就是阈值以下所有的寄生电阻或寄生电容去掉不提取 (一般设置 COMBINE 即可)
- [5] [知乎 > 提参 PEX 中, Format：CALIBREVIEW 和 DSPF 区别](https://zhuanlan.zhihu.com/p/683150814):
    - (5.1) CALIBREVIEW（CALIBREVIEW +Net Geometry）：提出为 "schematic + 寄生参数" 合成的结果，进行后仿；DSPF：只是提出寄生参数，输出的为 "netlist" 。进行后仿真时，需要 "前仿的 schematic + 后仿的 netlist" 即可
    - (5.2) CALIBREVIEW 和 DSPF 提取的寄生参数是一致的，提参进行后仿结果对比，只是小数点后几位不同
    - (5.3) 利用 DSPF 结果进行后仿时，只需要在 ADE L > Setup > Simulation Files 中添加 PEX_DSPF.netlist 即可，操作起来也很方便
- [6] [知乎 > Cadence Virtuoso 后仿真总结 (包含 Calibre, DSPF, Spectre 提寄生)](https://zhuanlan.zhihu.com/p/6580714389)
    - (6.1) 这篇文章介绍了多种寄生参数提取格式及其后仿方法，算总结得比较全面了
    - (6.2) PEX 时建议在 `PEX Options > Misc` 中把 Layout 的电源和地加上 (要与 PEX Options > netlist 和 PEX Options > LVS Option 中的设置保持一致)
    - (6.3) 生成 netlist 用于后仿时，**把 "Create top level pin order" 勾上，选择 "source"，勾上 "All Pins"。这一步对后面的后仿很重要，就不需要再到 netlist 里手动修改寄生网表的端口名称。**
- [7] [微信文章 > 模拟集成电路设计流程——版图后仿真](https://mp.weixin.qq.com/s?__biz=MzUyNzA2MDA0OQ==&mid=2247528418&idx=1&sn=0a799d2c6d32a8974e11fea3b2d5759b)
- [8] [知乎 > Cadence Virtuoso 教程 (八)：台积电 28nm 版图设计示例——包括 Layout, DRC, LVS, PEX 和后仿 (Post-Simulation)](https://zhuanlan.zhihu.com/p/1937319302949769830)
    - (8.1) 介绍了台积电 28nm 工艺的版图设计流程，包含 DRC, LVS, PEX 和利用 CALIBREVIEW 格式进行的后仿
    - (8.2) **详细讲解了 DRC/LVS/PEX 时容易遇到的常见问题及其解决方法，任何环节出现问题都可以到里面找找答案**
- [9] [EETOP > Spectre X 讨论](https://bbs.eetop.cn/thread-983266-2-1.html)
- [10] [知乎 > Cadence加快仿真速度](https://zhuanlan.zhihu.com/p/680258606)
- [11] [Accuracy you know, Speed you need – 新一代 Spectre X 仿真器](https://picture.iczhiku.com/weixin/message1582550787289.html)
- [12] [EETOP > 解决 Spectre 仿真报错Segmentation Fault (during AHDL read-in)](https://bbs.eetop.cn/thread-983285-1-1.html): 楼主是因为 linux 的 memory segments 最大数量太小了，系统是 centos 7.9 默认 4096 条，改为 16384 条后问题解决
- [13] [CSDN > spectre 仿真器中断](https://blog.csdn.net/weixin_42221495/article/details/140003274): 认为是当前 spectre 仿真器仿不了这么大容量的仿真，需要换仿真器
- [14] [博客园 > XPS MS 遇到 segmentation fault 错误](https://www.cnblogs.com/li2000/p/18296503/Analog-Cadence-Virtuoso-ADE-XPSMS): 博主提出/收集了多种可能原因，包括 服务器内存不够、没设置64位、未知错误（尝试重启 virtuoso 或者服务器端口）等，他认为最稳妥的方法是重启 virtuoso
- [15] [EETOP > Spectre 仿真报错，Internal error found in spectre during AHDL read-in](https://bbs.eetop.cn/thread-887124-1-1.html): 楼主提出了三种解决方案，22楼提出了另一种：