# Cadence Layout Tutorials

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 00:13 on 2025-06-19 in Beijing.



## Introduction

Layout (版图设计) 是 IC 设计的核心环节，主要包括下面几个步骤：
- Layout: 版图设计
- DRC: design rule check, 设计规则检查
- LVS: layout vs. schematic, 版图原理图对比
- PEX: parasitic extraction, 寄生参数提取

在绘制版图之前，我们需要先确保完成了 schematic 层面的全部设计工作，并且完成所有的前仿工作 (pre-layout simulation), 包括但不限于 op, dc, ac, tran, noise 等基本仿真，以及 temp, corner, monte carlo 等鲁棒性仿真。因为一旦开始绘制版图，就意味着我们将进入后仿阶段 (post-layout simulation)，原理图中的任何更改都需要重新绘制版图并重新进行后仿。

**<span style='color:red'> 注意: 绘制板图之前，原理图中所有元器件的模型必须来自目标工艺库 (不能是理想工艺库之类的)，并且元器件的所有参数必须为确定的值 (而不能是 variables)。 </span>**



## 1. Procedure and Example

### 1.1 basic procedure


版图设计的主要流程与操作如下，其中 (1) ~ (5) 属于 **step 1: layout** 部分，算上后续的 DRC, LVS, PEX 和后仿，一共有五个部分：
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
- (10) 全部仿真和检查都结束之后，进入流片工序，生成流片文件提供给厂家，并根据厂家回复不断修改



<!-- <div class='center'>

| **步骤** | **操作** | **关键命令/工具** |
|----------|----------|------------------|
| **1. 启动 & 创建** | 打开 Virtuoso，新建 Layout | `virtuoso &` → `New Cell View` |
| **2. 绘制版图** | 放置 MOSFET、金属连线 | `i` (Instance) 、`p` (Path) 、`o` (Contact)  |
| **3. DRC 检查** | 验证设计规则 | `Verify → DRC` |
| **4. LVS 检查** | 对比版图与电路图 | `Verify → LVS` |
| **5. PEX 提取** | 提取寄生参数 | `Verify → PEX` |
| **6. 导出 GDSII** | 生成流片文件 | `File → Export → Stream` |

</div> -->

### 1.2 layout example

关于 layout 的具体步骤和示例，包括后续 DRC, LVS, PEX 和 Post-Layout Simulation (后仿) 等操作，详见教程 [Cadence Layout Example in tsmcN28 (including DRC, LVS, PEX and Post-Simulation)](<AnalogIC/Virtuoso Tutorials - 8. Cadence Layout Example of Inverter in tsmcN28 (including DRC, LVS, PEX and Post-Simulation).md>)。


## 2. Keyboard Shortcuts

### 2.1 default shortcuts

最基本的几个默认快捷键：

- **快捷键**：
    - `F`：适合窗口 (Fit to View) 
    - `F3`：调出当前工具的选项面板
    - `r`：绘制矩形 (Rectangle) 
    - `p`：绘制路径 (Path) 
    - `c`：复制 (Copy) 
    - `m`：移动 (Move) 
    - `q`：属性编辑 (Property) 
    - `k`：标尺 (Ruler) 
    - `Ctrl + D`：取消选择
    - `shift + m`：合并同层金属连线 (显著提高布局可读性)


其它快捷键 (from [this article](https://adityamuppala.github.io/assets/Notes_YouTube/Cadence_Hotkeys.pdf))：

<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-19-02-13-33_Cadence Virtuoso Layout Tutorials.png"/></div>

或者看下面这张图 (from [this article](https://analoghub.ie/category/cadenceTricks/article/cadenceTricksHotkeys))：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-19-02-14-54_Cadence Virtuoso Layout Tutorials.png"/></div>

Layout 可能用到的一些图标如下 (from [this article](https://people.eecs.berkeley.edu/~pister/140sp25/labs/Cadence_Editing_Shortcuts_Sp25.pdf)):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-19-12-49-52_Cadence Virtuoso Layout Tutorials.png"/></div>


### 2.2 customize shortcuts

下面是我们利用 `.cdsinit` 文件所修改的快捷键：

- 未修改：
    - `F`: 适合窗口 (fit to view) 
    - `p`: 绘制路径 (path) 
    - `q`: 属性编辑 (property)
    - `o`: 绘制过孔 (via) 
    - `k`: 创建标尺 (ruler) 
    - `shift + k`: 删除所有标尺 (delete all rulers)
    - `shift + m`: 合并同层金属连线 (显著提高布局可读性)
- 已修改：
    - `space`: 空格旋转 (rotate)
    - `鼠标右键`: 用作 esc (esc 太远了)
    - `a`: 按键 A 按照 left 进行 align
    - `w`: 按键 W 按照 top 进行 align
    - `d`: 按键 D 按照 right 进行 align
    - `c`: 按键 C 按照 vertical (center) 进行 align
    - `s`: 按键 S 进行快速对齐 (边界对齐), 默认是 leHiStretch()
    - `g`: 按键 G 进行 group
    - `shift + g`: 进行 ungroup
    - `ctrl + g`: 创建 guard ring
    - `m`: 添加金属连线


下面的代码更新于 2025.07.19, 最新源码见 [How to Use Cadence Virtuoso Efficiently](<AnalogIC/Use Virtuoso Efficiently - 0. How to Use Cadence Virtuoso Efficiently.md>).
``` bash
hiSetBindKeys("Layout" list(
    list("None<Btn4Down>" "geScroll(nil \"n\" nil)")            ; 鼠标滚轮上滑, 界面上移:
    list("None<Btn5Down>" "geScroll(nil \"s\" nil)")            ; 鼠标滚轮下滑, 界面下移:
    list("Ctrl<Btn4Down>" "hiZoomInAtMouse()")                  ; Ctrl + 鼠标滚轮上滑, 放大界面:
    list("Ctrl<Btn5Down>" "hiZoomOutAtMouse()")                 ; Ctrl + 鼠标滚轮下滑, 缩小界面:
    list("Ctrl<Key>Z" "hiUndo()")                               ; Ctrl + Z, 撤销:
    list("Ctrl<Key>Y" "hiRedo()")                               ; Ctrl + Y, 重做:
    list("<Key>space" "leHiRotate()")                           ; 空格旋转
    list("Ctrl<Key>s" "leHiSave()")                             ; Ctrl + S 保存
    list("None<Btn3Down>" "" "cancelEnterFun()")                ; 鼠标右键用作 esc (esc 太远了)
    list("Ctrl<Key>c" "leHiCopy()")                             ; Ctrl + C 复制
    list("<Key>w" "leAlign(\"top\")")                           ; 按键 W 按照 top 进行 align
    list("<Key>c" "leAlign(\"vertical\")")                      ; 按键 C 按照 vertical (center) 进行 align
    list("<Key>a" "leAlign(\"left\")")                          ; 按键 A 按照 left 进行 align
    list("<Key>d" "leAlign(\"right\")")                         ; 按键 D 按照 right 进行 align
    list("<Key>g" "_leCreateQuickFigGroup(getCurrentWindow())") ; 按键 G 进行 group
    list("Shift<Key>g" "leHiUngroup()")                         ; Shift + G 进行 ungroup
    list("Ctrl<Key>g" "leHiCreateGuardRing()")                  ; Ctrl + G 以创建 guard ring
    list("<Key>s" "leHiQuickAlign()")                           ; 按键 s 进行快速对齐 (边界对齐), 默认是 leHiStretch()
    list("Shift<Key>s" "leHiStretch()")                         ; Shift + s 进行拉伸
	)
)
```

### 2.3 other practical functions


**(1) 将原理图器件导入到版图：**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-22-33-34_Cadence Virtuoso Layout Tutorials.png"/></div>

`Place > Analog > Automatic Placement`, 效果比 `place as in schematic` 好很多。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-20-01-59-58_Cadence Virtuoso Layout Tutorials.png"/></div>

**(2) 自动添加 guard ring:**

选中器件后 `Place > Modgen > Guard Ring > Add MPP Guard Ring` <span style='color:red'> (注：一次只能选一个晶体管，否则会卡住很久才生成出来，因此实用性不高，不如手动添加) </span>:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-20-02-17-50_Cadence Virtuoso Layout Tutorials.png"/></div>

但是可以通过这一招推断 DRC 所需的 spacing, 由此设置 `enclose by` 的值：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-20-02-27-46_Cadence Virtuoso Layout Tutorials.png"/></div>

**(3) 自动添加 dummy:**

选中器件后 `Place > Modgen > Dummies > Add Dummy` (其中 )。同样的，这个操作也是一次只能选择一个器件 (一个管子)，否则会卡住很久才生成出来。

## 3. Layout Tips

<!-- 参考 [Cadence Layout Tips_1](https://zhuanlan.zhihu.com/p/471942740) 和 xxx...
 -->

### 3.1 guard ring template

绝大多数完整的工艺库都会提供自带的 guard ring template, 若遇到没有模版的情况，可按下面步骤手动创建模板。

在 layout 时添加 guard ring 时, 首先库中要有 guard ring 的模板，否则会报错 `*WARNING* (LE-103399): leHiCreateGuardRing: The create guard ring command requires MPP guard ring templates to exist in the technology file.` 导致命令无效。我们参考 [this video](https://www.bilibili.com/video/BV17t4y1N7nK), 给出创建 guard ring template 的步骤：

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



### 3.2 auto abutment

参考 [Cadence Virtuoso Layout Suite XL User Guide.pdf](https://picture.iczhiku.com/resource/eetop/WYifYSQEuQhIQVBv.pdf) 的 page 185. 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-20-01-39-44_Cadence Virtuoso Layout Tutorials.png"/></div>


## 4. Q and A

下面是 layout 部分常见问题的解答，部分回答参考了 AI 的解答，部分回答参考了网上别人的博客、文章等。

### 4.1 layer definitions

**问题 1: layout 时的各个 layer 是什么意思，一般情况下会用到哪几层？**

**回答 1 (2025.06.19 由 DeepSeek 生成):**


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

### 4.2 layout XL vs. layout GXL

**问题 2: layout XL 和 layout GXL 的区别是什么，哪一个更实用、高效？**

**回答 2 (2025.06.19 由 DeepSeek 生成):**

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

## 5. Relevant Resources

### 5.1 official resources

- [Cadence Virtuoso Layout Suite XL User Guide.pdf](https://picture.iczhiku.com/resource/eetop/WYifYSQEuQhIQVBv.pdf)
- [Cadence Course Learning Maps](https://www.cadence.com/content/dam/cadence-www/global/en_US/documents/training/learning-maps.pdf)
- [Virtuoso Schematic Editor Training](https://www.cadence.com/en_US/home/training/all-courses/84443.html)
- [Virtuoso Analog Design Environment XL User Guide (Product Version 6.1.6 August 2014)](https://picture.iczhiku.com/resource/eetop/syIfptILiLPyrvCB.pdf)
- [Virtuoso® Spectre® Circuit Simulator and Accelerated Parallel Simulator User Guide (Product Version 10.1.1 June 2011)](https://picture.iczhiku.com/resource/eetop/wYkfLuEsZIWWJBVC.pdf)
- [Virtuoso Visualization and Analysis XL User Guide (Product Version 6.1.5 January 2012)](https://home.engineering.iastate.edu/~hmeng/EE501lab/TAHelp/wavescanug.pdf)

### 5.2 other resources
- [Bilibili > 模拟 IC 设计中的软件操作: Cadence Virtuoso Layout 电路版图绘制技巧及其相关快捷键](https://www.bilibili.com/video/BV1Ue4y127Hb)
- [Slides: 模拟 IC 版图设计](https://picture.iczhiku.com/resource/eetop/sYIFgLAoTwTuDBMv.pdf)
