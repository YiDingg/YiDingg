# 202509_tsmcN65_DAC_R2R_5bit

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 21:05 on 2025-09-30 in Beijing.

>注：本文是项目 [Design of A 5-Bit RDR DAC for Reference Generation in BB-PLLs](<Projects/Design of A 5-Bit RDR DAC for Reference Generation in BB-PLLs.md>) 的附属文档，用于记录 OTA 的设计和前仿过程。


## 1. Design Considerations

### 1.1 design reference

本次设计是参考着之前 28nm 中已流片验证过的 9-bit R-2R DAC 进行的，参考电路及版图见下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-21-59-35_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-22-00-06_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

(名称中标的是 7-bit, 实际是 9-bit)

整个 DAC 是由多个相同模块级联得到的，单个模块的电路和版图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-22-01-01_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-22-01-44_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

### 1.2 design consideration

本次设计是需要做一个 5-bit 的 R-2R DAC, 也就是一共五个单元级联起来，具体原理如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-22-39-48_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

版图结构：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-23-01-20_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

注意我们这里用的是 `nch_dnw` 和 `pch` 器件，左右两端的 NW 宽度可以设置为 1.2 um 以满足 DRC 要求，DNW 位于 0.6 um 处，方便后续直接拼接 (重合部分宽 0.6 um 即可直接拼成)。


至于单刀双掷开关的具体实现方式，完全可以把上个 OTA 设计中用到的开关搬过来用，也就是每一组控制单元涵盖两个反相器和两个开关，如下：



管子两边要加 dummy, 因此版图作如下调整：
- (1) `routeUPoly_SP_INC` = `routeDPoly_SP_INC` = 70n 为过孔留出空间，但我们只在一边连接 gate, 因为打完过孔后，管子的 gate/drain/source 从上到下依次排列
- (2) 管子与管子之间排版时，保持有源区上的 M1 间距一致
- (3) 电阻的排布也是类似，保持 poly 间距一致


综合各方考虑，电阻/管子的具体参数如下：
- 开关管子: 
    - L = 120nm
    - fingerW_N = 480nm, fingerW_P = 960nm
    - fingers = 8
- 反相器管子: fingers = 4, 其它参数同上
- 电阻: 
    - totalRes = 5kOhm
    - segmentL = 1u
    - segmentL = 18.635u
    - seriesSegments = 2 (totalL = 37.27u)
    - segmentSpacing = 250n (min)
    - contColumns = 3
- 看情况加电阻和管子的 dummy (主要是电阻)

无 dummy 的原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-00-21-14_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

`EN` = 0 时，NMOS 打开而 PMOS 关闭，`vb` 接到 `VSS`；反之，`EN` = 1 时，NMOS 关闭而 PMOS 打开，`vb` 接到 `VREF`。

添加 dummy 之后的效果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-18-54-13_202509_tsmcN65_DAC_RDR_5bit.png"/></div>


### 1.3 pre-layout simulation

为验证电路的正确性，先进行一下前仿，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-18-48-15_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-18-49-15_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-18-51-14_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

**平均输出误差为 -0.140\%**, 其实可以在开头接地的地方串联一个相同尺寸的晶体管以减小误差，但我们有自信版图走线不会带来太大误差，这里就不作调整了。



作为对比，我们也看一下参考电路 (师姐之前设计的 7-bit R-2R DAC) 的前/后仿结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-18-50-07_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-18-46-05_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-18-43-12_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

**前仿平均误差 -0.031\%, 后仿平均误差 -0.378\%** ，看了一下版图，后仿误差和升高主要是走线电阻过高导致的 (走线都比较细长)。


## 2. Layout Details

下面开始 DAC 的版图设计，版图时需要关注多个模块之间的拼接问题。

特别注意版图之前运行一下 LVS, 检查 **没有** "layout 器件在 schematic 中显示 **missing injected instance**" 的错误：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-18-57-37_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

嗯，确实没有，可以放心做版图。

### 2.1 single unit layout

用 `text drw` 层标出拼接后重合的部分，然后进行布线，效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-20-28-26_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-20-26-53_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-20-26-17_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-20-28-09_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

DRC 是完全通过的，但 LVS 出现了三个 property 错误，它们分别是：
- (1) 原理图中的电阻 `R3` (XR3) 与版图长度差了 0.01um
- (2) 原理图中的电阻 `R1` (XR1) 与版图长度差了 0.02um
- (3) 六个 dummy 电阻构成的大电阻 property 对不上

前两个报错，尝试过重新 `generate selected instances`，但没有解决。和师兄、导师讨论之后，决定修改电阻的长度为更规整的值 (例如整数个 um)；至于第三个报错 (dummy 电阻无法正确识别)，我们将文件传到服务器上跑 LVS, 发现根本不存在此错误，寻求原因，未果。最后只能归结于 Calibre 自身的 bug, 并且在服务器的新版本 Calibre 2023 中已被修复 (我们本地的是 Calibre 2019)。

先修改电阻长度再说，从 18.635u 修改为 20.000u, 放到版图中重新跑一下 LVS:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-23-05-52_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

嗯，这下只有 dummy 电阻无法识别的错误了。因为要以服务器上的 LVS 结果为准，我们这里直接开启 `LVS Option > Gates > RC (Resistors with POS and NEG pins tied together)` 以过滤被短路的电阻，此时 LVS 就完全通过了：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-23-08-38_202509_tsmcN65_DAC_RDR_5bit.png"/></div>


>猜测电阻长度出现误差的原因是：之前一个电阻分为两个 segments，每个长度 18.635u，可能在版图提取过程中不知为何被软件处理为了 18.64u，这样两个 segments 拼起来就是 37.28um (多了 0.01um)。类似地，另外两个电阻一共四个 segments, 总长度 4*18.64u = 74.56u，就多了 0.02um。另外，我们还尝试了一下，没有修改精度错误时，直接在顶层调用此 cell, 甚至出现了网络短路的情况？！真是匪夷所思。

依师兄的建议，在管子再加一点 STRAP 用于连接 n-well 和 p-sub:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-23-30-29_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-23-31-17_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

### 2.2 integration layout


模块设计通过，下面只需将五个模块拼在一起，并在外围加上 dummy. 模块单元设计好之后，拼接起来是非常轻松的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-23-41-46_202509_tsmcN65_DAC_RDR_5bit.png"/></div>


我们只加电阻的 dummy, 一共需要三大八小共 11 dummies:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-23-55-26_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-01-23-55-48_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

这里 DRC 时遇到报错 **EPO.EX.1.1**：

``` bash
EPO.EX.1.1 { @ Extension on unsilicided OP/PO [RPO width > 10 um] >= 0.30
```

只需在电阻两侧加宽一点 `RPO` 层即可。最后给管子的 NW 围上，连接好走线，打上 Pin 脚，便可大功告成！



先看一下没有围 NW 的效果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-02-00-39-51_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-02-00-41-04_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

DRC 和 LVS 都完全通过，下面围上 NW 和最外围的保护 ring:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-02-01-03-01_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-02-01-05-26_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

没有问题，可以进入后仿阶段了！

## 3. Post-Layout Simulation

分别导出  Gate Level 和 Transistor Level 的 HSPICE netlist, 利用 config 文件进行后仿：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-02-01-17-59_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-02-01-18-18_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-02-01-20-08_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

图中可以看出，由于不存在 mom cap 等特殊器件，Gate Level 和 Transistor Level 的仿真结果看不出区别。并且，我们的电路 **在全温度-工艺角下能保持 -0.199\% ~ -0.116\% 的平均输出误差，算是比较不错的。**

作为对比，我们把参考电路的前/后仿结果也放在这里：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-07-22-05-11_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-07-22-05-39_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-07-22-03-13_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-07-22-03-55_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

## 4. LVS Correction

2025.10.08 将配置和项目都转移到 104 服务器后，按导师要求对 LVS dummy 电阻的识别问题进行修正。参考下面两篇问答知道，这里 dummy 电阻识别错误是 series = 2 的同时 LVS Reduction Priority = Parallel 导致的：
- [[求助] 请问Series 为2的电阻使其短路，LVS为什么无法识别出](https://bbs.eetop.cn/thread-960270-1-1.html)
- [[求助] 请教一下为什么LVS识别不了两端短接的电阻](https://bbs.eetop.cn/thread-944716-1-1.html)

因此有两种解决方法：
- **(1) 修改 LVS Reduction Priority = Series**, 这需要修改 LVS 的规则文件，我们尝试了一下但没有找到相关语句，遂放弃
- **(2) 将 series = 2 的电阻改为两个 series = 1 电阻串联**, 这样就不会被 LVS 误判为并联电阻了

我们考虑用第二种方法，先把之前的版本给备份一下，命名为 `202509_DAC_RDR_5bit_v1_10012345_PS`，后面改的这版通过后便备份为 v2.

先运行一下 DRC 看看：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-14-14-22_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

这么多报错是因为 DRC 文件中开启了 `FULL_CHIP` 检查导致的，只需将 DRC 文件中的 `#DEFINE FULL_CHIP` 改为 `//#DEFINE FULL_CHIP` 即可，修改后的 DRC 结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-14-18-32_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

嗯，这样就没有报错了。

新版 Calibre (2023) LVS 中 source.added 文件无法在 `LVS > input` 一栏添加，而是需要在 `Layout > Calibre > Setup > Netlist Export > Include Files` 中添加：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-14-28-26_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

诶？奇怪的是，这里并没有 dummy 电阻识别报错？按照导师的说法，他那边跑了 LVS 之后有下面这条报错：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-14-32-45_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

导师跑的是 TOP cell, 这是我们直接复制过去的，按理来说不应该有问题，这里重新跑一下试试：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-14-36-09_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

也是没有问题的。这表明，即便 top cell 是复制得到的，其 layout 与 schematic 的对应关系还未修改，也不会导致 LVS 识别错误呀。

<!-- 噢，我知道原因了，大概是因为 top cell 复制过去后，layout 与 schematic 的对应关系还未修改，导致 LVS 识别错误。

 -->



<!-- 新版 Calibre (2023) LVS 时 source.added 需要在 ` -->

与导师讨论之后，发现是因为导师这边跑 LVS 开了 `LVS Options > LVS Filter Unused Option > Enable` 选项，即便没有勾选其下的任何过滤项，也会导致识别出问题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-20-17-52_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

由于这个电路是要交付给甲方的，我们还是作一下修改，以防后期扯皮。在 schematic 中将 series = 2 的 dummy 电阻拆为两个 series = 1 电阻串联，但修改后发现还是不行：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-21-49-38_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-21-49-47_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

无奈，只能将两个电阻中间的那个 net 单独悬空 (不设为 VSS)，再尝试一下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-22-25-03_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-22-32-37_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-22-26-07_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-22-26-32_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

将此 unit cell 保存，命名为 `v2_10082158_PS_202509_DAC_RDR_bitUnit`，并以此构建 5-bit 总电路：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-22-35-09_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-22-35-44_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-22-36-38_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

到此终于是全部通过，将其命名为 `v2_10082158_PS_202509_DAC_RDR_5bit`，设为 top cell 后便可以收工了。





