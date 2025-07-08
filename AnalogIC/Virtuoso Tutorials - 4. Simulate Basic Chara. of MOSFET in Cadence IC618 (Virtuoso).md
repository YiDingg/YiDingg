# Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso)

> [!Note|style:callout|label:Infor]
> Initially published at 17:08 on 2025-05-20 in Beijing.

## Introduction

Cadence 安装教程、实用技巧和仿真示例等详见 [How to Use Cadence Efficiently](<AnalogIC/How to Use Cadence Virtuoso Efficiently.md>).

## 1. 仿真步骤

### 1.1 单变量扫描

- (1) 先正常选择工艺库，我们选择 `tsmc18rf`，即台积电 180nm CMOS 射频工艺库
- (2) 放置 MOSFET 和 `analogLib` 库中的 `gnd` 和 `vdc` (DC voltage source)，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-11-33-19_Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).png"/></div>

- (3) 然后调整仿真设置：
    - (3.1) `ADE L > Variables > Edit > Cellview Variables > Copy From`, 这会自动将 schematic 中的变量复制到仿真设置中，然后设置一下它们的初值
    - (3.2) 单参数扫描：`ADE L > Analyses > Choose > dc > Sweep Variable`
- (4) Output 设置：`Output > Edit > From Design > 选中 NMOS 的 drain`, 或者用 `Calculator` 手动选择 `if > /NMOS/D` (表示 $I_D$)
    - (4.1) id: `/NMOS/D`
    - (4.2) gm/id: 先随便仿真一次，然后在 `Tools > Results Browser > dcOpInfo` 找到 `NMOS > gm`, 右键加入 calculator
    - (4.3) `calculator > os`: 挑选一个元器件, 然后选择直创建表达式
- (5) 查看仿真结果：鼠标右键拖选可放大局部图像


单参数扫描结果如下 (`Vds = 1`, 扫描 `Vgs`):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-12-06-07_Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-13-46-25_Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-14-01-43_Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).png"/></div>

### 1.2 多变量扫描

- (1) 先按单参数进行一次扫描 (即设置第一变量, 作为横坐标), 运行仿真
- (2) 再设置第二变量: `ADE L > Tools > Parametric Analysis > 设置第二变量`, 点击 Parametric Analysis 的 `Run`
- (3) 查看多参数扫描结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-14-18-50_Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-14-29-07_Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).png"/></div>

## 2. 其它参数

简明起见，上面的例子中我们只展示了 `rout`, `gm` 和 `self_gain` 等基本参数的仿真结果。实际上，在实际的 gm/Id 设计方法中，我们常常会关注管子的下面几个关键参数： **<span style='color:red'> 横坐标通常设置为 gm/Id </span>**
- (1) `Id/(W/L)`: normalized current $I_{nor} = \frac{I_D}{a} = \frac{I_D}{\frac{W}{L}}$, 归一化电流，表示单位长宽比下的电流大小，是根据 $\frac{g_m}{I_D}$ 和电流 $I_D$ 计算长宽比的关键参数
- (2) `fug`: unity gain frequency (transient frequency) $f_T$, MOS 管的单位增益频率 (瞬态频率), 与管子的速度直接相关
- (3) `region`: 工作区域 (region), MOS 管的工作区域, 例如饱和区、线性区等
- (4) `self_gain`: self gain $A = g_m r_O$, 本征增益, 反映了管子的增益大小
- (5) `rout`: output resistance $r_{out} = \frac{1}{g_{ds}}$, 输出电阻
- (6) `gm`: transconductance $g_m = \frac{dI_D}{dV_{gs}}$, 跨导
- (7) `Vdsat`: saturation voltage $V_{dsat} = V_{gs} - V_{th}$, 管子进入饱和区的最小 Vds 电压
- (8) `Vgs`: gate-source voltage $V_{gs}$, 当前 gm/Id 值所对应的栅源电压 Vgs

有关 gm/Id 方法的设计思想与具体实例，我们会在过几天发出来（到时会把链接也放在这里）。

## 3. 相关资源

下面是与 Cadence Virtuoso 相关的一些资料/教程：

- [西安交通大学 Cadence 入门教程 (2006.07.19)](https://picture.iczhiku.com/resource/eetop/whiRzEWyJywsSmBc.pdf)
- [Cadence Official > Cadence Course Learning Maps](https://www.cadence.com/content/dam/cadence-www/global/en_US/documents/training/learning-maps.pdf)

其它官方文档：
- [Cadence Official > Virtuoso Analog Design Environment XL User Guide (Product Version 6.1.6 August 2014)](https://picture.iczhiku.com/resource/eetop/syIfptILiLPyrvCB.pdf)
- [Cadence Official > Virtuoso® Spectre® Circuit Simulator and Accelerated Parallel Simulator User Guide (Product Version 10.1.1 June 2011)](https://picture.iczhiku.com/resource/eetop/wYkfLuEsZIWWJBVC.pdf)
- [Cadence Official > Virtuoso Visualization and Analysis XL User Guide (Product Version 6.1.5 January 2012)](https://home.engineering.iastate.edu/~hmeng/EE501lab/TAHelp/wavescanug.pdf)

