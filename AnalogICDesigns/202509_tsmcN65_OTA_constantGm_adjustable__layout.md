# 202509_tsmcN65_OTA_constantGm_adjustable__layout

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 16:31 on 2025-09-27 in Beijing.

>注：本文是项目 [Design of An Adjustable Constant-Gm OTA for Low Pass Filters in BB-PLL](<Projects/Design of An Adjustable Constant-Gm OTA for Low Pass Filters in BB-PLL.md>) 的附属文档，用于记录 OTA 的版图和后仿过程。

## 1. General Considerations

### 1.0 Overview

本文，我们将对 `tsmcN65` 工艺下所设计的 An Adjustable Constant-Gm OTA 进行版图设计，并完成后续的一系列工作：
- Layout (版图设计)
- DRC (设计规则检查)
- LVS (版图与原理图比对)
- PEX (寄生参数提取)
- Post-Layout Simulation (后仿)

### 1.1 layers and DRC

开始版图设计之前，得先确定此工艺库下的各个 layer 简称代表什么意思，以及阅读工艺库下的 DRC 文件，确定几个基本 DRC 规则的数值。我们已经在前两天的 LDO 设计中详细介绍过，这里不多赘述：[202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.md>).

### 1.2 layout steps

版图的步骤也提过多次了，这里略过。

## 2. Layout Details (v1_271731)

### 2.0 circuit preview

下面是准备进行版图的 OTA 电路原理图及其前仿结果，取自设计与前仿文档 [202509_tsmcN65_OTA_constantGm_adjustable](<AnalogICDesigns/202509_tsmcN65_OTA_constantGm_adjustable.md>)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-41-29_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-41-19_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-46-33_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-50-28_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

### 2.1 modify schematic

这一小节对 schematic 作一些修改，以方便后续版图设计。还记得我们在设计时又加入了一个 multiple = 2 的管子作为最小偏置电流吗？这破坏了原有版图的对称性，我们加一个 multiple = 7 的 dummy 管子使版图对称一些，如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-19-05-21_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

另外，EN 开关那里的 NMOS 不小心设置了 multiplier = 4, 直接改为 1 就好，基本不影响电路性能。以及电阻的 contacts 也要从 1 改为 3 (max) 以提高过孔性能。


### 2.1 generate layout

**<span style='color:red'> 建议后续每几小步操作就做一次 DRC, 以免出现问题时不能及时发现。 </span>**

器件导入版图后，先做大致的排版，将器件分为一组一组的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-20-40-07_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

进一步排版：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-21-19-30_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

修改器件属性，把 gate contacts 打开：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-21-30-47_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>



然后放置 n/p guard ring (enclose by 0.4), dnw 和 n-well:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-22-25-01_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

报错 M1.A.1 是 source/drain 上自带的 M1 太小，没有其它问题，可以开始金属布线了。

**<span style='color:red'> 做到这一步时，导师突然加要求说四位二进制输入需要加 buffer 隔离一下，我们用两个反相器作为 buffer 进行隔离。</span>** 另一方面，为减小电阻所占面积，将 segment width 从 1u 修改为 400nm (min), 效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-23-10-35_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-23-21-45_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-23-22-12_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

要是再说晚一点，那就麻烦了，因为金属布线说不定已经做了大半。

加入后重新仿真一遍，确保没有问题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-28-19-30-16_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-28-19-41-28_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-28-19-39-48_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

嗯，确实没有什么问题，可以继续了。


### 2.2 metal routing

一组组进行金属布线，完成了可调偏置电路和左下角控制单元的效果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-28-01-16-04_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-28-01-15-40_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-28-01-19-56_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

继续布线，将除 VDD/VSS 外的所有网络都先布线好；可以利用 `schematic > Navigator > Nets` 或者 `layout > Connectivity > Incomplete Nets > Show All` 检查各网络连接情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-28-22-37-23_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-28-22-39-29_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-28-22-37-49_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>


然后将 VDD/VSS 布线好，检查一下 DRC 和 LVS, 发现反相器部分的 LVS 有报错：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-12-38-42_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

从晚上 22:00 折腾到凌晨 03:30 硬是没能解决，无奈睡觉。第二天早上，把模块拆分出来单独做 LVS, 首先是主模块没有任何问题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-13-57-21_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-12-47-59_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

然后看一下反相器这一部分：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-14-05-13_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-14-05-01_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

仍是一样的错误，看不出问题在哪。

## 3. Layout Revision (v2_291406)

经过与导师沟通，决定将开关控制部分 (反相器) 拆分出来单独做一个 cell, 重新画版图。除此之外，电路中还有以下部分需要调整：
- (1) DNW 必须全部被 NW "覆盖" 住：这个问题不大，我们用把所有 VDD-NW 用 NW 连起来，然后重新放置一下 DNW 就行
- (2) 主电路部分最好还是每个差分对都有 dummy, 但暂时不改了，否则改动太大
- (3) 隔离 label 的电阻换为 metal resistor
- (4) 反相器 L 太大了，改为 60nm
- (5) 反相器 (开关控制部分) 单独拉一个 cell, 重新画版图
- (6) 偏置电路管子 width 过小 (120nm) 导致 CO 只有一个，**加宽为至少 2 个 CO (fingerW >= 360nm)**, 外源偏置电流可以换为更大的 100 uA
- (7) 修改偏置电路版图，使用 multi-finger 方法连接 (dummy 看情况加一加)


总的来讲就是：
- 修改 (1)(3)(4) 等小细节
- 一共三个 cell 分开来做: 主电路 + 开关控制 (反相器 + 开关) + 偏置电路
- 修改偏置电路的参数:
    - 原参数：      10 uA / 75 = 133.33 nA, fingerW = 120n (L = 2u),     units = 4 + 8 + 16 + 32 = 60 以及 unit=2 恒开启
    - 10uA 新参数： 10 uA / 38 = 263.16 nA, **fingerW = 360n (L = 3u)**, units = 2 + 4 + 8  + 16 = 31 以及 unit=1 恒开启
    - <s>100uA 新参数：100 uA / 38 = 2631.6 nA, fingerW = 360n (L = 2u), units = 2 + 4 + 8  + 16 = 31 以及 unit=1 恒开启</s>



<!-- 
130nA ~ 120nm/2um = 60nm/1um
260nA ~ 240nm/2um = 120nm/1um
260nA ~ 360nm/3um
390nA ~ 360nm/2um 
-->

### 3.0 layout test



### 3.1 main circuit

先把主电路给拆出来，通过 DRC 和 LVS, 确保没有问题：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-14-47-04_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-12-26-41_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-14-54-08_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-14-55-57_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

### 3.2 bias control

然后把偏置电路拆出来，修改参数后重新画版图 (用 multi-finger 方法)。经过与导师的讨论，我们采用以下参数和版图布局：

- 10uA 新参数： 10 uA / 38 = 263.16 nA, **fingerW = 360n (L = 3u)**, units = 2 + 4 + 8  + 16 = 31 以及 unit=1 恒开启
- 也就是： units = {1} + {2 + 4 + 8 + 16} + {38} + {41} = 110 = 11*10

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-16-18-31_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

**<span style='color:red'> 注意版图里的 dummy 是可以不加入到原理图中的</span>** ，只需在 LVS 时勾选 `LVS Options > Gates > AG > Enable L and S` 即可。但这里我们还是把 dummy 加入到原理图中，也方便对比检查。

下面是原理图和版图布局：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-16-33-06_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-16-34-24_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

然后将最外圈的 dummy 们也围上：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-16-46-22_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-16-46-40_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

没啥问题，可以开始这一部分的金属连线了。先打上过孔：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-17-00-40_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

加上内 p-ring 和外 n-ring, 别忘了在每一行间隙给一个 PP 将 p-sub 连接到 VSS, 然后连接就是很简单的事：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-17-14-18_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-17-14-37_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>


布线完成后检查 DRC 和 LVS, 确保没有问题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-12-25-12_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-18-14-00_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-18-14-42_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-18-15-14_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

这里 LVS 的两个 ERC 错误是因为最外围的 NW/P-Sub 没有连接，在集成后便消失，无需在意。

### 3.3 switch control

最后把开关控制部分拆出来，修改参数后重新画版图。修改参数前不妨看一下不同尺寸对应的导通电阻大小：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-18-32-42_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-18-32-59_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-18-36-35_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-18-37-40_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

图中可以看出：
- (1) 保持 L 不变，宽长比 a = W/L 越大，导通电阻越小
- (2) 保持宽长比 a 不变，L 越大，导通电阻越小

考虑到上面两点，我们将控制部分的新参数设置为：
- NMOS: L = 60n, W = 4*180n = 720n  (f = 4, m = 1)
- PMOS: L = 60n, W = 4*450n = 1800n (f = 4, m = 1)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-18-46-21_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

先不忙着开始版图，将三个 cell 集成起来做个仿真看看，确保没有问题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-18-59-31_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-19-00-12_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-19-11-49_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

嗯，完全没有问题，甚至比 v1_271731 版本的性能还要好一些，可以继续我们的版图。

这里跟导师沟通了下，决定把 finger 数再增多一些，综合考虑三个小板块的拼接，以及至少两个 contacts (fingerW >  360nm)，我们将尺寸修改为：
- NMOS: L = 120n, W = 11*360n = 3960n (f = 11, m = 1)
- PMOS: L = 120n, W = 11*700n = 7700n (f = 11, m = 1)

**这里使用奇数个 finger 是为了使用 `route_Source_Drain` 参数从而简化连线。**


类似地，生成版图，先做排版，给各管子打上过孔，然后放置 n/p guard ring, nw 和 dnw:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-20-33-56_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

连完线后运行 DRC 和 LVS:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-21-31-32_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-21-31-44_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-29-21-32-18_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

令人无语的是，这个 **missing injected instance** 的错误还是存在，实在搞不懂是哪里的问题，四组管子，每组只有输入接的第一个反相器被成功识别，其他的都不行。



和导师讨论了之后，仍无果，只能怀疑是 schematic 中器件参数出现了 bug (毕竟之前版图完全重新画了，只有原理图是复制过来的)。无奈尝试这种方法：在新的 cell view > schematic 里 **重新手动放置一组器件 (一共四组，仅放置一组)** ，重新完成这一组的版图，效果如下：

在版图中仅生成器件，还未连线时：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-12-05-46_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-12-06-15_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

连线完成后：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-11-59-36_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-12-00-55_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

这次 LVS 终于是完全通过了。随后将四组器件拼在一起，LVS 也是没有任何问题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-12-03-28_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-12-04-51_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

<span style='color:red'> 

上面遇到的问题，总结下来就是：在版图中导入器件，仅放置器件、修改器件版图属性、放置 VSS/VDD label，还未连线时，我们运行一次 LVS, 正确的报错应该为 layout 中的器件在 schematic 中显示 **missing instance** 而不是 **missing injected instance**，如果出现后者，说明 schematic 中的器件有问题，需要重新放置一遍器件再试；反之，schematic 中的器件在 layout 中显示 **missing injected instance** 是正常的，这不会影响后续的 LVS。

</span>


### 3.4 switch layout 

上面最后 LVS 通过的版图太宽 (94.36 um)，仅做测试用，不能作为最终版图。我们将四组器件放在同一个 schematic 里重新画版图，效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-12-19-06_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

仅放置器件、修改器件版图属性、放置 VSS/VDD label, 运行 LVS 看一下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-12-32-02_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

嗯，版图中的器件在 schematic 中显示 **missing instance**, 说明原理图 **没有问题** ，可以继续版图了。最终效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-13-49-37_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-13-50-10_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-13-50-32_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-13-44-49_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

终于等到你\~还好我没放弃\~\~\~，DRC 和 LVS 均完全通过，可以将三个 cell 集成起来做最后的版图和后仿了。

### 3.5 final layout

如图，将三个子模块集成起来，进行最后的排版和布线，最后在外围加上 p-ring 和 n-ring. 这里出现了 "导入后的子模块版图边界比实际边界大得多" 的问题，参考这篇问答 [EETOP > [求助] 求助版图边界问题](https://bbs.eetop.cn/thread-883031-3-1.html)，在 CIW 输入 `(foreach st geGetEditCellView()~>steiners dbDeleteObject(st))` 后保存，问题解决。



仅导入模块，未连线时检查过，并没有出现 "schematic 的器件在 layout 为 missing injected instance" 的问题。于是继续连接各个模块，曾出现过一堆 LVS 报错的情况，借助 RVE 左下角的版图对比功能，经过多次尝试，仔细再仔细检查 (找了三个多小时)，发现是网络 `VB` 和 `VSS` 在连接时不小心短路 (报错里完全没有任何短路提示)，修正之后，功夫不负有心人，终于是全部通过了：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-17-28-18_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-17-28-04_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-17-29-29_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-17-30-25_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

与之前 LDO 的版图类似，我们在整个版图外围套上几层 guard ring 作隔离，然后将模块的 IO Pins 全部拉到最外围，方便后续集成，最后优化一下顶层走线，完成最终版图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-18-18-21_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-18-18-41_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-18-19-56_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-18-19-19_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>




## 4. Post-Layout Simulation



### 4.0 pre-layout simulation

不妨先做一下 pre-layout simulation, 方便后续对比：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-20-08-22_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-20-08-01_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-20-11-51_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-20-16-34_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>


<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-13-56-38_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-13-57-05_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-14-05-30_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-14-05-04_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div> -->

### 4.1 gate level simul.

我们分别导出 HSPICE 格式下 Gate Level 和 Transistor Level 的寄生参数网表并进行后仿，先看 Gate Level 的结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-20-33-31_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-20-38-47_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

### 4.2 transistor level simul.

然后是 Transistor Level 的结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-20-39-19_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-20-42-39_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-30-20-47-08_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>

嗯，和 Gate Level 的结果几乎一致。

### 4.3 summary of results

下表总结了 OTA 的全温度-工艺角仿真结果：

<div class='center'>

| Parameter | Pre-Simulation | Post-Simulation |
|:-:|:-:|:-:|
 | **Narrowest Gm Range** | **1.369 uS ~ 18.68 uS** | **1.403 uS ~ 18.76 uS** |
 | **Widest Gm Range**    | **1.093 uS ~ 28.75 uS** | **1.110 uS ~ 28.96 uS** |
 | Gm @ `(0)_10  = (0000)_2`  | 1.290 uS (1.093 uS ~ 1.369 uS) | 1.306 uS (1.110 uS ~ 1.403 uS) |
 | Gm @ `(7)_10  = (0111)_2`  | 13.54 uS (12.26 uS ~ 16.94 uS) | 13.64 uS (12.35 uS ~ 17.14 uS) |
 | Gm @ `(15)_10 = (1111)_2`  | 21.91 uS (18.68 uS ~ 28.75 uS) | 22.06 uS (18.76 uS ~ 28.96 uS) |
 | IDD @ `(0)_10  = (0000)_2` | 118.2 uA (79.67 uA ~ 249.8 uA) | 113.7 uA (77.67 uA ~ 229.2 uA) |
 | IDD @ `(7)_10  = (0111)_2` | 161.4 uA (118.6 uA ~ 297.5 uA) | 156.5 uA (116.4 uA ~ 276.4 uA) |
 | IDD @ `(15)_10 = (1111)_2` | 188.2 uA (140.1 uA ~ 329.5 uA) | 183.1 uA (137.7 uA ~ 308.2 uA) |
</div>