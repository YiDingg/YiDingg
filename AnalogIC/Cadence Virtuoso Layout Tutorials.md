# Cadence Virtuoso Layout Tutorials

> [!Note|style:callout|label:Infor]
> Initially published at 00:13 on 2025-06-19 in Beijing.



## Introduction

Layout (版图设计) 是 IC 设计的核心环节，主要包括 layout, DRC/LVS 和寄生参数提取等步骤。

在绘制版图之前，我们需要先确保完成了 schematic 层面的全部设计工作，并且完成所有的前仿工作 (pre-layout simulation), 包括但不限于 op, dc, ac, tran, noise 等基本仿真，以及 corner, monte carlo 等鲁棒性仿真。因为一旦开始绘制版图，就意味着我们将进入后仿阶段 (post-layout simulation)，原理图中的任何更改都需要重新绘制版图并重新进行后仿。

**<span style='color:red'> 注意: 绘制板图之前，原理图中所有元器件的模型必须来自目标工艺库 (不能是理想工艺库之类的)，并且元器件的所有参数必须为确定的值 (而不能是 variables)。 </span>**



## Basic Procedure




<div class='center'>

| **步骤** | **操作** | **关键命令/工具** |
|----------|----------|------------------|
| **1. 启动 & 创建** | 打开 Virtuoso，新建 Layout | `virtuoso &` → `New Cell View` |
| **2. 绘制版图** | 放置 MOSFET、金属连线 | `i` (Instance) 、`p` (Path) 、`o` (Contact)  |
| **3. DRC 检查** | 验证设计规则 | `Verify → DRC` |
| **4. LVS 检查** | 对比版图与电路图 | `Verify → LVS` |
| **5. PEX 提取** | 提取寄生参数 | `Verify → PEX` |
| **6. 导出 GDSII** | 生成流片文件 | `File → Export → Stream` |

</div>

## Keyboard Shortcuts

### Default Shortcuts

最基本的几个默认快捷键：

- **快捷键**：
    - `Shift + F`：适合窗口 (Fit to View) 
    - `F3`：调出当前工具的选项面板
    - `r`：绘制矩形 (Rectangle) 
    - `p`：绘制路径 (Path) 
    - `c`：复制 (Copy) 
    - `m`：移动 (Move) 
    - `q`：属性编辑 (Property) 
    - `k`：标尺 (Ruler) 
    - `Ctrl + D`：取消选择
    - `shift + m`：合并同层金属连线 (显著提高布局可读性)
    - 

其它快捷键 (from [this article](https://adityamuppala.github.io/assets/Notes_YouTube/Cadence_Hotkeys.pdf))：

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-19-02-13-33_Cadence Virtuoso Layout Tutorials.png"/></div>

或者看下面这张图 (from [this article](https://analoghub.ie/category/cadenceTricks/article/cadenceTricksHotkeys))：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-19-02-14-54_Cadence Virtuoso Layout Tutorials.png"/></div>

Layout 可能用到的一些图标如下 (from [this article](https://people.eecs.berkeley.edu/~pister/140sp25/labs/Cadence_Editing_Shortcuts_Sp25.pdf)):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-19-12-49-52_Cadence Virtuoso Layout Tutorials.png"/></div>


### Customize Shortcuts


## Layout Tips

参考 [Cadence Layout Tips_1](https://zhuanlan.zhihu.com/p/471942740) 和 xxx...

### xxx

### guard ring template

要想在 layout 时添加 guard ring, 首先库中要具有 guard ring 的模板，否则会报错 `*WARNING* (LE-103399): leHiCreateGuardRing: The create guard ring command requires MPP guard ring templates to exist in the technology file.` 导致命令无效。我们参考 [this video](https://www.bilibili.com/video/BV17t4y1N7nK), 给出创建 guard ring template 的步骤：

1. 任意选择一个 pmos, `Efit Parameter > bodytie_typeL > Integred`, 测量以下几个间距：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-17-29-08_Cadence Virtuoso Layout Tutorials.png"/></div>

2. 先来创建 pmos 的 guard ring (将 nwell 连接到 VDD 或其他 Net)
    - (1) `Layout > Create > Multipart Path > 键盘 F3 > Subpart > 选择 Offset Subpath`
    - (2) 添加 `NIWP` 层：按照上图所得的 0.18 um, 我们依次修改 `Layer > NIMP drw`, `Begin Offset > 0.18`, `End Offset > 0.18`, 点击中间的 `Add` 和下方的 `Apply`
    - (3) 添加 `NWELL` 层：类似地，保持 0.18 um, width 是 2 * 0.43 um + 0.44 um = 1.30 um, 点击 `Add` 和 `Apply`
    - (4) 添加 `METAL1` 层和 `DIFF` 层
    - (5) 刚刚是在 `Offset Subpath` 中添加了 `NIWP`, `NWELL` 和 `METAL1`; 现在在 `Subrectangle` 中添加 `CONT` 层 (通孔)
    - (6) 保存, save template 到 tech library


这样，最后弄好的 guard ring 效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-18-38-38_Cadence Virtuoso Layout Tutorials.png"/></div>

3. 类似地，创建 nmos 的 guard ring (将 psubstrate 连接到 VSS):
    - (1) `Layout > Create > Multipart Path > 键盘 F3 > Subpart > 选择 Offset Subpath`
    - (2) 依次添加 `PIWP` 层, `METAL1` 层, `DIFF` 层
    - (3) 在 `Subrectangle` 中添加 `CONT` 层 (通孔)
    - (4) 保存, save template 到 tech library

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-18-36-23_Cadence Virtuoso Layout Tutorials.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-17-57-53_Cadence Virtuoso Layout Tutorials.png"/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-17-35-26_Cadence Virtuoso Layout Tutorials.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-17-43-13_Cadence Virtuoso Layout Tutorials.png"/></div>
-->


## Frequently Asked Questions

下面是 layout 部分常见问题的解答，部分回答参考了 AI 的解答，部分回答参考了网上别人的博客、文章等。

### 1. layout 时的各个 layer 是什么意思，一般情况下会用到哪几层？

2025.06.19 由 DeepSeek 生成：

按功能划分：
<div class='center'>

| **Layer 类型**       | **作用**                                                                 | **典型层名 (以CMOS工艺为例)**       |
|----------------------|--------------------------------------------------------------------------|--------------------------------------|
| **有源层 (Active)**  | 定义晶体管 (NMOS/PMOS) 的源/漏区 (Diffusion)                            | `AA` (Active Area)、`OD` (Diffusion) |
| **栅极层 (Gate)**   | 定义晶体管的栅极 (多晶硅或金属栅)                                       | `POLY` (Poly-Si)、`PO` (Poly Gate)   |
| **金属层 (Metal)**  | 用于信号和电源布线 (多层金属互联)                                        | `M1`, `M2`, ..., `MT` (Top Metal)    |
| **接触/通孔层**      | 连接不同层 (如 Metal1 到 Poly 或 Diffusion)                             | `CONT` (Contact)、`VIA` (Via)        |
| **阱/注入层**        | 定义 NMOS/PMOS 的阱 (Well) 和掺杂区域                                   | `NWELL`, `PWELL`, `NIMP`, `PIMP`     |
| **隔离层**           | 防止器件间短路 (如 STI 浅槽隔离)                                        | `STI` (Shallow Trench Isolation)     |
| **钝化层**           | 芯片最外层的保护层 (防止划伤和腐蚀)                                     | `PASSIVATION`                        |

</div>

必须掌握的核心 Layer

<div class='center'>

| **Layer**  | **作用**                  | **关联层**               |
|------------|--------------------------|-------------------------|
| `AA/OD`    | 晶体管源/漏区            | `POLY`, `NWELL/PWELL`   |
| `POLY/PO`  | 栅极                     | `AA`, `CONT`            |
| `M1-MT`    | 金属互联                 | `VIA`, `CONT`           |
| `CONT/VIA` | 层间连接                 | `AA`, `POLY`, `M1`...   |
| `NWELL`    | PMOS 区域                | `AA`, `PIMP`            |
| `PIMP/NIMP`| 掺杂调整                 | `AA`                    |
</div>

典型 CMOS 工艺的 Layer 使用流程 (以反相器 inverter 为例)
1. **绘制 NWELL/PWELL**：定义 PMOS 和 NMOS 区域。
2. **绘制 AA (Active Area)** ：定义源/漏区。
3. **绘制 POLY**：覆盖 AA 形成栅极。
4. **添加 CONT**：连接 AA/POLY 到 M1。
5. **绘制 M1**：连接 PMOS/NMOS 的源漏极。
6. **添加 VIA** 和 **M2**：连接电源 (VDD/GND) 。

更具体的概念可以参考 [知乎 > Cadence layout 概念知识--版图图层和物理图层之间的关系](https://zhuanlan.zhihu.com/p/610274845)。

### 2. layout XL 和 layout GXL 的区别是什么，哪一个更实用、高效？

2025.06.19 由 DeepSeek 生成：

核心区别对比：

<div class='center'>

| **特性**               | **Layout XL**                            | **Layout GXL**                           |
|------------------------|-----------------------------------------|-----------------------------------------|
| **全称**               | Virtuoso Layout XL                      | Virtuoso Layout GXL (Grand XL)          |
| **定位**               | 中高端版图设计                          | 高端版图设计 (支持更复杂工艺和自动化)  |
| **自动化功能**         | 基础自动化 (如参数化单元、简单约束)     | 高级自动化 (如AI辅助布局、智能DRC修复) |
| **与Schematic的联动**  | 支持同步编辑 (Schematic-Driven Layout)  | 更强大的联动 (实时同步、自动匹配器件)  |
| **DRC/LVS支持**        | 基础DRC/LVS检查                         | 集成高级DRC/LVS优化 (如自动修复)       |
| **适用工艺**           | 成熟工艺 (如180nm/90nm)                 | 先进工艺 (如28nm/7nm以下)              |
| **学习曲线**           | 较低                                    | 较高 (需熟悉高级功能)                  |
| **价格**               | 较低                                    | 较高                                   |
</div>

总结：哪个更实用？

<div class='center'>

| **场景**                | **推荐工具** | **理由**                              |
|-------------------------|-------------|---------------------------------------|
| 成熟工艺、简单设计      | Layout XL   | 性价比高，学习成本低                 |
| 先进工艺、复杂模块      | Layout GXL  | 自动化节省时间，避免人工错误         |
| 团队协作或混合信号设计  | Layout GXL  | 协同功能和数字/模拟集成更强大        |
</div>

## Relevant Resources

### Official Resources


### Other Resources
- [Bilibili > 模拟 IC 设计中的软件操作: Cadence Virtuoso Layout 电路版图绘制技巧及其相关快捷键](https://www.bilibili.com/video/BV1Ue4y127Hb)
- [模拟 IC 版图设计](https://picture.iczhiku.com/resource/eetop/sYIFgLAoTwTuDBMv.pdf)

