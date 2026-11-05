# Experience Summary of Analog IC Design, Simulation, Layout, and PEX

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 14:32 on 2025-09-22 in Beijing.
> dingyi233@mails.ucas.ac.cn



## Introduction

最近几个月学习/参与的项目比较多，包括 OTA/OPA, BGR, LDO, PLL 等等，每个项目或多或少都会遇到一些困难，杂七杂八的经验也积累不少，特此总结在这里，方便日后查阅。

## 0. Misc 

首先是一些杂七杂八的经验/问题：
1. **任何设计/前仿/版图/后仿过程都应做好记录：** 不仅要记录设计思路和细节、遇到的问题和解决方案，还要记录下各个版本之间的迭代过程和参数变化，方便之后参考和复现。没有任何记录的电路设计，就好比 "无根之木，无源之水"，徒有空中楼阁其而无内在支撑。否则，即便是设计者本人，一段时间后也会几乎完全忘记当时的思路和细节，更何况是阅读/接收此设计的他人了。
2. swap activity warning 弹窗
3. **仿真要能回溯：** 每次仿真记下 `interactive` 编号 + testbench / config / cell view / 关键变量 / corner / 耗时，后期几百次仿真里能否快速回溯直接决定排错效率
4. **跑通即归档：** 成功状态的原理图/版图立刻备份，并让版本号自带语义 (如 `BK_20260304_v1_succeeded`) 
5. **<span style='color:red'> calibre view 是不可复现的隐变量：</span>** 同一版图重新提参，大小从 153.7 MB 变成 110~120 MB，仿真结果随之完全翻转 (PEX 报告看不出差别) 。**任何"跑通了"的结果都要连 calibre view 一起备份。**
6. **不要在同一个库上做实验性修改：** 用 `copy hierarchical` 复制到新库再改，这是"结果无法复现"的头号元凶


## 1. Design and Iteration

设计中的一些经验：
- 像 BGR 和 LDO 这种不需要极快瞬态响应的电路/环路 (特殊快速 LDO 除外)，相位裕度基本上越高越好，保持 80° 以上的裕度能使电路的鲁棒性大大增强 (人话：更耐造)；当然，提高相位裕度必定会牺牲其它性能指标，要根据具体情况进行权衡
- LDO 输出电流 10 mA 量级算是电流比较大的了，如果想用 NMOS Pass, 要么有相当不错的 voltage headroom (1.3 V 左右)，要么用 native device 或者 low Vth device
- 按 "通常的经验"，LDO 应该是负载电容越大越稳定，但实际上 "并非如此"；在设计中我们发现，系统的相位裕度随负载电容增大会先减小再增大，在小电容 (pF) 或大电容 (uF) 下可以正常工作，对于中等大小电容则会不稳定；之前 "LDO 负载电容越大越稳定" 的经验是对于含有外部电容的 LDO 而言，其工作在右端的大电容区间，而 capacitor-less LDO 则工作在左端的小电容区间
- 对 capacitor-less LDO 而言，NMOS Pass 的稳定性比 PMOS 好得多 (NMOS Pass 下的 GBW_LDO 小得多), PMOS Pass 可以通过降低功率管增益/运放GBW/引入补偿网络来提高稳定性 (牺牲 PSRR 性能)
- 设计 LDO 时，如果仅对 PSRR @ DC 有要求，可以考虑加一个 buffer stage 来驱动功率管，这会大幅降低环路的 GBW, 从而显著提高稳定性 (牺牲中频 PSRR)
- 尽管理论上使用 NMOS Pass 的 LDO PSRR 性能会更好，但我们实际设计下来却是 NMOS 比 PMOS 差了一点点，也不知是 native device 还是 vgs 的原因
- 对于 capacitor-less LDO, 其在低电流 (轻载) 时稳定性差，在大电流 (重载) 时稳定性会更好；至于 PSRR，前仿和 Gate Level 后仿倒都是轻载差重载好，但 Tran Level 的后仿却是轻载好而重载差 (仅个例，暂未广泛验证)
- 65nm 下的运放，输入共模距离 VDD 有 0 ~ 0.7V 时可以考虑 nmos input, 距离 VSS 有 0 ~ 0.7 V 时可以考虑 pmos input, 对于卡在中间的情况，还是建议用 constant-gm op amp
- 设计 constant-Gm OTA 时, VDD 在不同范围适用不同的补偿方法：
    - no compensation: VDD = 1.7\*VTH ~ 2.3\*VTH
    - current-reuse: VDD >= 2.2\*VTH
    - ...... (待补充)
- 由于电流源的非理想性，OTA 的总跨导 Gm 一般都达不到 (Gm_N + Gm_P), 多数在 40\% ~ 70\% 之间

**高速 wireline/SerDes 相关：**
- **VCO 频带控制必须带滞回**，否则 Vctrl 上的噪声会引起频带乱切；初始频带/频率要与 kvco 匹配，否则初始频差太大时 VCO 频率根本过不去
- **版图完全对称时比较器也会存在 offset：** 版图完全对称仍可能出现 16~20 mV 的阈值 offset，常见根因是 **reset 开关管尺寸不足** (fn 2 → 4 后明显改善) 。建议预留 calibration input pair
- **数字逻辑的速率瓶颈往往不是触发器，而是组合链：** counter 受限于多级 AND 链的累计延迟 (8 级 ≈ 100 ps) 。**AND 不能简单换成 NAND** (AND 的输出要同时给本级 XOR 和下一级 AND) ，除非改用多输入 AND 把各级运算解耦
- **逻辑门不是越大越快：** TFF 中 TG 从 x2x2 增到 x8x8，最高频率反而从 24 GHz 降到 16 GHz (瓶颈是门的固有延迟而非级间 RC) 。**单元级最快 ≠ 系统级最快**：XOR 输入端交换让 TFF 从 24 提到 28 GHz，但 counter 整体从 6.5 掉到 5.0 GHz
- **驱动大负载的最佳 BUF 级联比例约 3 ~ 4** (考虑 MOS 漏极电容) ；时钟路径上不宜级联过多级 INV (延迟与 jitter 会累积) 
- **PI 的占空比失真比相位误差更致命** (直接影响后级 slicer 的 reset) 


## 2. Pre-Layout Simulation


- 要想将 ADE L/XL 的设置转到 Explorer/Assembler, 只需先 save state 再到 Explorer 里导入
- 扫描多个变量并作图时，如果横坐标不是想要的变量，到 `Axis > Y vs. Y` 或者 `Axis > Sweep Varible` 即可更改。当然， **最好是将需要作为横坐标的变量放在 variables 的最后** ，从根源上解决问题
- 对绝大多数设计而言，无论什么工艺，基本上都可使用下面的八个 corners 作为全温度-工艺角，可以覆盖绝大多数情况：
    - TT: +27°C, +65°C
    - FF: -40°C, +130°C
    - SS: -40°C, +130°C
    - FS: -40°C
    - SF: +130°C
- 仿真时遇到报错 `Internal error found in spectre during hierarchy flattening, during circuit read-in. Encountered a critical error during simulation.` 可能是因为管子的 finger 设置为了非整数 (例如 2.5)，将 finger 设置为整数即可解决
- Verilog-A 注意： 不要用节点电压直接参与运算 (先赋给 `real` 变量，输出统一在 `analog` 块最后赋值) ；**不要把 `transition()` 直接写在 `analog` 块里** (相当于恒成立，仿真步长会被压到 fs 级、慢几十倍) ，要放进事件控制；多个 `analog block` 会自动拼接
- **<span style='color:red'> Verilog-A 宏的整数除法陷阱：</span>** `PHASE_NUM = 8` 做除法会得到 0 (整除) ，需另定义 `PHASE_NUM_float = 8.0` (曾困扰我们两三周) 。另外 `cell name` 必须等于 `module name`；`electrical` 报 syntax error 且无提示，多半是忘了 include `disciplines.vams`
- **"怎么调都不对" 时，先换仿真器 / 换精度：** 我们排查了两天的 CP 漏电问题，最终发现是 Spectre FX 精度不足导致的假象，换 APS 后立刻正常
- **变量填完要复跑确认：** 把 variable 数值填入晶体管后重新仿真，电路性能可能发生变化 (管子尺寸未变)，怀疑是变量模式下部分寄生参数未正确计算；定稿前应固化参数复跑一遍


## 3. Layout and DRC/LVS

- 使用 DNW + NW 来隔离器件 (形成 local p-sub) 时，用作包围的 N-Well 不能太窄，否则会 DRC 会报错 DNW.S.5, 例如 tsmcN65 中应满足 NW >= 1.2 um (详见 [这篇文章](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.md>) 的 "2.10 DRC and LVS" 一节)
- 小型电路建议所有 net 都手动命名，避免版图复制后的 net 更新问题；这是因为有时我们要更新电路的 schematic, 可能因为新元件/删元件等原因导致多个 net 名称发生变化，如果这时直接将原理图更新到版图，版图只会更新各器件的连接关系，而 (可能) 不会更新金属连线的 net 名称，导致出现 "fake short-circuit"，虽然这不影响 DRC/LVS/PEX 结果，但会严重影响后续的版图迭代 (让阅读版图的人非常迷惑)
- 从其它 cell > layout 手动复制部分版图到新 cell > layout 时，可能出现版图元件 ROD 属性不对应的问题 (被刷新覆盖了)，这时如果直接点击 `Update Components and Nets` 会出现 `unbounded` 报错；解决这个问题，只需在左下角找到 `Define Device Correspondence`，更新一下版图元件和原理图的对应关系即可
- `Ctrl + Shift + X`: 画 BUS 线的快捷键，可以同时走多条平行走线
- 从其它 cell > layout 复制部分版图到新 cell > layout 时，可能出现版图元件 ROD 属性不对应的问题 (被刷新覆盖了)，如果直接点击 Update Components and Nets 会出现 unbounded 报错；这时只需在左下角找到 Define Device Correspondence 更新以下版图元件和原理图的对应关系即可
- NMOS 的 bulk/body 不想连 VSS/GND 的话，一般都要使用 DNW 隔离出 local p-sub, 否则会产生 stamping conflict 报错，也即 "高阻短路" 现象，这是一个比较严重的 ERC 问题，后仿不一定能仿出来，导致流片后结果与后仿差异较大
- 使用 crtmom 时 ERC 检查中出现 floating n-well 报错，可以通过将其版图属性 "Well Type" 从 N 修改为 P 来解决 (使用 PW 而非 NW)
- 模块设计完毕之后，我们通常会在整个模块外围套上多层 guard ring 以提供较好的隔离效果，一般是内 p-ring (VSS) 外 n-ring (VDD), 围上后 LVS > ERC 会报一条 floating p-sub 的错误，这是因为整个电路的 p-sub 未连接到外部，是正常现象，因为我们还没把模块集成到系统中去
- **<span style='color:red'> DNW.S.5 { @  {RW OR PW} space to {RW interact with OD2} with different potential >= 1.2 um </span>**: 用作包围的 NW 厚度不足 1.2 um 导致的，将 NW 加宽到 >= 1.2 um 即可解决，但不需要保证重叠部分 >= 1.2 um (这个问题曾困扰我们好几个小时)
- **<span style='color:red'> 在版图中导入器件，仅放置器件、修改器件版图属性、放置 VSS/VDD label，还未连线时，我们运行一次 LVS, 正确的报错应该为 layout 中的器件在 schematic 中显示 missing instance 而不是 missing injected instance，如果出现后者，说明 schematic 中的器件有问题，需要重新放置一遍器件再试；反之，schematic 中的器件在 layout 中显示 missing injected instance 是正常的，这不会影响后续的 LVS。 </span>** (这个问题曾困扰我们好几天)
- 模拟电路中，为提高流片稳定性，一般要保证所有的 via/CO 都至少有两个，尤其是 CO, 在管子 L or W 较小时容易只有一个
- 仿真设计好的模块版图时，如果遇到 "模块版图边界比实际边界大得多" 的问题，打开模块 layout 后在 CIW 输入 `(foreach st geGetEditCellView()~>steiners dbDeleteObject(st))` 便可解决
- **版图中的器件并不需要完全从原理图中导入，可以在版图中直接放置，即便没有修改对应关系也是能正常过 DRC/LVS 的**；但是对应关系不对的话，可以导致版图上显示的 net 出错，从而出现很多 "假的短路"，一方面看起来很乱，另一方面也可能影响到后续的版图设计，因此最好还是在 Connectivity > Define Device Correspondence 中手动更新一下对应关系
- **<span style='color:red'> 设置为 (segments = 2, series) 的 dummy 电阻是非常容易出 LVS 错误的，一般是关闭 `LVS Options > LVS Filter Unused Option` 则不报错，但只要一打开，即便没有勾选任何过滤项也会导致报错，根本原因是 reduction parallel/series priority. 因此，为了避免 LVS 上的扯皮，要么尽量不用 series = 2 的电阻设置，要么将 series = 2 的 dummy 电阻在原理图拆分成两个电阻并且 中间节点悬空 (floating)，然后两端都接 VSS 形成短路 </span>** (这个问题曾困扰我们好几天)
- 原理图/版图中如果电阻的宽度/长度具有三位小数 (例如 1.005 um)，某些工艺的 LVS 会提取成 1.010 um 导致电阻尺寸出现误差，从而报错 discrepancy, 因此在设计时就要注意电阻尺寸不能有三位小数

**高速电路的版图经验：**
- **数字电路建立模块级 layout standard：** 统一数字模块上下边界 (如 OD/M1 6.56 um、PP/NW 6.62 um) 后，模块可直接上下拼接、VDD/VSS 自动连通且无 DRC，拼版效率提升极大
- **<span style='color:red'> 时钟走线必须严格对称并避开敏感节点：</span>** SH 的 CK/CKB 走线不对称曾导致整个 dataPath 的五组参数全部失效，修正后 48G/56G 立即恢复正常
- **顶层拼版技巧：** 用"模板 cell + 镜像复制"，双击下层模块即可在背景板下编辑并让镜像副本同步更新；可用 skill 脚本一键提取下层 label；翻转某个 cell 会影响 VDD/VSS 连接，不能有的翻有的不翻
- **tsmcN28 M9 要求 full chip density < 50%：** 核心附近放带 CAP 的 PowerCell，PAD 到核心这一段用不带 CAP 的 PowerCell；脚本填 M9 时建议直接全 block 再手动补低密度区
- **导入任何 gds (stream) 都要新建库导入**，否则会覆盖原有模块的 layout
- **电感**要带 NT_N 层、用不闭合 p-ring、且 p-ring 只从一处金属接出 (避免涡旋电流损耗) 
- **OD/PO dummy** 在小模块及模块互连时尽量填好，否则拼版时才报错，而 DRC 又慢又费时

**常见 DRC 报错与解决方案：**
- **NW.S.5 { @ Space to PW STRAP >= 0.16 um**: PW STRAP 就是定义/连接 p-sub 电位的地方，也即 M1/CO/OD/PP 这一结构，通常是用 p-ring 来定义 p-sub 电位的
- **NW.S.1 { @ Space >= 3.5**: 是 nch_25_dnw 中的 dnw (deep n-well) 间距过小造成的，只需给每组 nch_25_dnw 外面套上一个大 dnw 即可
- **LUP.6 { @ Any point inside NMOS source/drain space to the nearest PW STRAP in the same PW <= 30 um**: 等等 LUP 报错，通常是 N-Well/P-Sub 没有正确连接到 VDD/VSS 导致的
- **DOD.R.1, DPO.R.1, DM1.R.1, DM2.R.1**: 等等: 需要添加对应的 dummy, 例如 DOD 就是 dummy OD, 模块级设计无需考虑 (可以在 DRC 文件中注释掉 FULL_CHIP 一行以取消 full chip check)
- **PO.R.8{@ It is prohibited for Floating Gate if the effective source/drain is not connected together**: 晶体管的 gate 未到 PAD (floating) 导致的，等做完 full chip routing 自然就没有了, 模块级设计无需考虑 (可以在 DRC 文件中注释掉 FULL_CHIP 一行以取消 full chip check)
- **CSR.R.1.DNWi, CSR.R.1.NWi**: 等等 CSR 报错：这些是 full_chip 设计才需要考虑的，模块级设计无需考虑 (可以在 DRC 文件中注释掉 FULL_CHIP 一行以取消 full chip check)
- **ESD.WARN.1 {@ SDI is not in whole chip**: 等等 ESD 报错也是，模块级设计无需考虑 (可以在 DRC 文件中注释掉 FULL_CHIP 一行以取消 full chip check)
- **<span style='color:red'> DNW.S.5 { @  {RW OR PW} space to {RW interact with OD2} with different potential >= 1.2 um </span>**: DNW 上面用作包围的 NW 厚度不足 1.2 um 导致的，将 NW 加宽到 >= 1.2 um 即可解决，但不需要需保证重叠部分 >= 1.2 um (这个问题曾困扰我们好几个小时)
- Stamping conflict: 两个网络通过某高阻 non-metal 路径短接，或者 Guardring 没有全部连到 VDD/VSS 上都会导致这个错误，确保布线完再来修正
- WARNING: Invalid PATHCHK request "! POWER": no POWER nets present, operation aborted. 这是 VDD/VSS 网络上没有打 pin 属性的 label 导致的，LVS 识别不到这俩网络，自然就会报错



## 4. PEX and Post-Simulation

- 后仿时间/空间消耗一般比较大，为节省硬盘、提高仿真速度，可以设置仅保存特定节点 (save selected node) 或者仅保存顶层节点 (推荐)，需要考察的内部节点则由 deepprobe 引出来；也可以直接用 maestro 仿真器 而不是传统的 ADE L/XL, maestro 会自动保存与 schematic 对应的主要节点 (不需要手动设置)，也能大幅节省空间
- 版图完成后做 PEX，选择 Transistor Level 时如果输入了 x-cells 文件链接也不会导致寄生参数重复提取 (对 tsmcN65 工艺库，其它暂不清楚)，因为导出后会发现警告 **WARNING: PEX IDEAL XCELL is only applied in gate-level extraction.** 表示本次提取并没有应用 XCELL, 也就没有重复提取
- 提取寄生参数时，无论选择哪种输出格式，提取结果都几乎一致，仅在仿真速度上有略微差异 (SPECTRE 比 HSPICE/DSPF 稍长些)
- 对于一个走线电阻均非常小的优秀版图，如果电路中不存在 mim/mom cap 这类特殊器件，Gate Level 和 Transistor Level 的后仿结果是几乎找不出区别的
- 后仿时用 maestro 似乎不需要再单独设置保存节点数 (我们也没找到在哪设置)，几个项目仿真下来感觉 maestro 会保存电路中与 schematic 对应的一些主节点，可以大幅度节省空间 (但自然没有仅保存顶层节省得多)
- 也不清楚是什么原因，后仿时仿真器总是在 opening psf file 这一步卡很久 (从 output log 中看出)，如果能解决这个问题，仿真速度会大大提高
- `tsmcN28` PEX 后生成 calibre view 时，reset 有效的是 `simM=1 fingers=1`，分别代表 multi = 1 和 nf = 1
- 若报 `Cannot run the simulation because the expression of the parameter 'lef': Function 'pPar' is not defined`，只需在 CDF Edit 中重新 Apply 一下参数即可解决
- **前仿 → RF 管 → 后仿的延迟约成 1:1.5:2.5 倍化** (管子 fn 越大、寄生越明显) ，版图未完成时可用 RF 管仿真预判后仿性能
- **模块拼接后必须重新验证最高速率：** 单独的 SSS 可做到 1.0 V @ 64 Gbaud，拼成 dataPath 后只能 1.1 V @ 62 Gbaud。规划指标时要给集成后的性能下降留余量
- **对比性实验一次只改一个变量：** 我们曾同时改"网络名"和"时钟顺序"，结果无法归因；后来拆成 5 组对照才发现，"仅修改网络名并删除无用元件" 也会引起性能下降 (原因未明) 
- **PEX 结果重点看：** 时钟/主输入线的寄生是否在预期范围；关键路径 (DFE 反馈) 的寄生是否各路匹配；偏置网络 (如 MAIN_VB / TAP1_VB) 对 VSS 的电容是否足够 (不够则外挂 moscap + momcap 稳定电压) ；本该对称的两个网络寄生是否对称




## 99. Original Notes

### 99.1 202509_LDO

本小节总结一些设计过程中积累的经验，供后续参考：
- 像我们这类 10 mA 级别的 LDO 算是电流比较大的了，如果想用 NMOS Pass, 要么有相当不错的 voltage headroom (1.3 V 左右)，要么用 native device 或者 low Vth device
- 按以前的经验，LDO 应该是负载电容越大越稳定，但实际上 "并非如此"；在本次设计中我们发现，系统的相位裕度随负载电容增大会先减小再增大，在小电容 (pF) 或大电容 (uF) 下可以正常工作，对于中等大小电容则会不稳定；之前 "LDO 负载电容越大越稳定" 的经验是对于含有外部电容的 LDO 而言，其工作在右端的大电容区间，而 capacitor-less LDO 则工作在左端的小电容区间
- 对 capacitor-less LDO 而言，NMOS Pass 的稳定性比 PMOS 好得多 (NMOS Pass 下的 GBW_LDO 小得多), PMOS Pass 可以通过降低功率管增益/运放GBW/引入补偿网络来提高稳定性 (牺牲 PSRR 性能)
- 如果仅对 PSRR @ DC 有要求，可以考虑加一个 buffer stage 来驱动功率管，这会大幅降低环路的 GBW, 从而显著提高稳定性 (牺牲中频 PSRR)
- 尽管理论上 NMOS Pass 的 PSRR 会更好，但我们本次设计中却是比 PMOS Pass 差了一点点，也不知是 native device 还是 vgs 的原因
- 本次的 capacitor-less LDO, 在低电流 (轻载) 时稳定性差，在大电流 (重载) 时稳定性会更好；至于 PSRR，前仿和 Gate Level 后仿倒都是轻载差重载好，但 Tran Level 的后仿却是轻载好而重载差
- 提取寄生参数时，无论选择哪种输出格式，提取结果都几乎一致，仅在仿真速度上有略微差异 (SPECTRE 比 HSPICE/DSPF 稍长些)
- 对于一个走线电阻均非常小的优秀版图，如果电路中不存在 mim/mom cap 这类特殊器件，Gate Level 和 Transistor Level 的后仿结果是几乎找不出区别的
- 后仿时用 maestro 似乎不需要再单独设置保存节点数 (我们也没找到在哪设置)，几个项目仿真下来感觉 maestro 会保存电路中与 schematic 对应的一些主节点，可以大幅度节省空间 (但自然没有仅保存顶层节省得多)
- 也不清楚是什么原因，后仿时仿真器总是在 opening psf file 这一步卡很久 (从 output log 中看出)，如果能解决这个问题，仿真速度会大大提高
- 65nm 下的运放，输入共模距离 VDD 有 0 ~ 0.7V 时可以考虑 nmos input, 距离 VSS 有 0 ~ 0.7 V 时可以考虑 pmos input, 对于卡在中间的情况，还是建议用 constant-gm op amp
- 从其它 cell > layout 复制部分版图到新 cell > layout 时，可能出现版图元件 ROD 属性不对应的问题 (被刷新覆盖了)，如果直接点击 Update Components and Nets 会出现 unbounded 报错；这时只需在左下角找到 Define Device Correspondence 更新以下版图元件和原理图的对应关系即可
- NMOS 的 bulk/body 不想连 VSS/GND 的话，一般都要使用 DNW 隔离出 local p-sub, 否则会产生 stamping conflict 报错，也即 "高阻短路" 现象，这是一个比较严重的 ERC 问题，后仿不一定能仿出来，导致流片后结果与后仿差异较大
- 使用 crtmom 时 ERC 检查中出现 floating n-well 报错，可以通过将其版图属性 "Well Type" 从 N 修改为 P 来解决 (使用 PW 而非 NW)
- 模块设计完毕之后，我们通常会在整个模块外围套上多层 guard ring 以提供较好的隔离效果，一般是内 p-ring (VSS) 外 n-ring (VDD), 围上后 LVS > ERC 会报一条 floating p-sub 的错误，这是因为整个电路的 p-sub 未连接到外部，是正常现象，因为我们还没把模块集成到系统中去




### 99.2 202509_OTA

本小节总结了本次 OTA 设计中的一些经验，供后续设计参考：
- 无论什么工艺，对绝大多数设计而言，基本上都可使用下面的八个 corners 作为全温度-工艺角，可以覆盖绝大多数温度-工艺变化情况：
    - TT: +27°C, +65°C
    - FF: -40°C, +130°C
    - SS: -40°C, +130°C
    - FS: -40°C
    - SF: +130°C
- 仿真时遇到报错 `Internal error found in spectre during hierarchy flattening, during circuit read-in. Encountered a critical error during simulation.` 可能是因为管子的 finger 设置为了非整数 (例如 2.5)，将 finger 设置为整数即可解决
- 对 constant-Gm OTA, VDD 在不同范围适用不同的补偿方法：
    - no compensation: VDD = 1.7\*VTH ~ 2.3\*VTH
    - current-reuse: VDD >= 2.2\*VTH
    - ...... (待补充)
- 由于电流源的非理想性，OTA 的总跨导 Gm 一般都达不到 (Gm_N + Gm_P), 多数在 40\% ~ 70\% 之间
- **<span style='color:red'> 在版图中导入器件，仅放置器件、修改器件版图属性、放置 VSS/VDD label，还未连线时，我们运行一次 LVS, 正确的报错应该为 layout 中的器件在 schematic 中显示 missing instance 而不是 missing injected instance，如果出现后者，说明 schematic 中的器件有问题，需要重新放置一遍器件再试；反之，schematic 中的器件在 layout 中显示 missing injected instance 是正常的，这不会影响后续的 LVS。 </span>** (这个问题曾困扰我们好几天)
- 模拟电路中，为提高流片稳定性，一般要保证所有的 via/CO 都至少有两个，尤其是 CO, 在管子 L or W 较小时容易只有一个
- 仿真设计好的模块版图时，如果遇到 "模块版图边界比实际边界大得多" 的问题，打开模块 layout 后在 CIW 输入 `(foreach st geGetEditCellView()~>steiners dbDeleteObject(st))` 便可解决

### 99.3 202509_DAC


本小节总结一些设计过程中积累的经验，供后续参考：
- **版图中的器件并不需要完全从原理图中导入，可以在版图中直接放置，即便没有修改对应关系也是能正常过 DRC/LVS 的**；但是对应关系不对的话，可以导致版图上显示的 net 出错，从而出现很多 "假的短路"，一方面看起来很乱，另一方面也可能影响到后续的版图设计，因此最好还是在 Connectivity > Define Device Correspondence 中手动更新一下对应关系
- **<span style='color:red'> 设置为 (segments = 2, series) 的 dummy 电阻是非常容易出 LVS 错误的，一般是关闭 `LVS Options > LVS Filter Unused Option` 则不报错，但只要一打开，即便没有勾选任何过滤项也会导致报错，根本原因是 reduction parallel/series priority. 因此，为了避免 LVS 上的扯皮，要么尽量不用 series = 2 的电阻设置，要么将 series = 2 的 dummy 电阻在原理图拆分成两个电阻并且 中间节点悬空 (floating)，然后两端都接 VSS 形成短路 </span>** (这个问题曾困扰我们好几天)
- 原理图/版图中如果电阻的宽度/长度具有三位小数 (例如 1.005 um)，某些工艺的 LVS 会提取成 1.010 um 导致电阻尺寸出现误差，从而报错 discrepancy, 因此在设计时就要注意电阻尺寸不能有三位小数


### 99.4 202602_CDR (→ 202605_TRX)

B/S 短接的 nmos/pmos，如果 bulk 不是常规 VDD/VSS 网络 (不妨就叫 net BN/BP)，是会报 ERC 的 floating psub/nwell 的。要解决这个问题，需要：
1. BN/BP 在原理图和版图里需要有 pin
2. LVS 的 Power/Ground 选项需要加上 BN/BP

**工艺与器件选择**
- 高速电路优先用 **ulvt**；CML 尾管电流不够时加大尺寸或换 lvt/ulvt
- **RF 管 (`nch_rf_ulvt_nw` 等) 的仿真结果比普通管更接近后仿**，版图未完成时可用它预判性能
- 小阻值优先 `rupolym` (PT 波动 ±3~5%) ，明显优于 `rnod` (±9~10%) 

**环路与系统**
- 本项目采用的环路参数 (供参考) ：`(R1, C1, C2) = (300~400 Ω, 8~10 pF, C1/12)`、`Icp_pd ≈ 120~200 uA`、`Icp_fd ≈ 250~400 uA`、`kvco = 300~700 MHz/V`，锁定后 `Je_rms ≈ 6.5~10 mUI @ Jc_rms = 1 mUI`
- **从行为级到实际电路要逐段替换、每段回归**，不要一次性全换，否则"结果不对"就无法定位
- **理想 VCO 的输入电压范围无限，实际 CP 有限**：换成实际 CP 后必须配合 LPF 复位电路仿真，否则频带根本切不动、频率过不去
- **几 ps 的时钟/数据对齐误差就足以毁掉系统** (差 2.6 ps 使 SH 眼高从 100 mV 掉到 50 mV) 。接口时序约定 (如 "AFE 输出的 DATA 边沿比 CK_SYS 滞后 18 ps") 必须写进系统文档

**自适应**
- 用三种 slicer (peak / top / tap slicer) 分别产生 DERR / DUPP / DZTH 来驱动 VTH 与 DFE 自适应的 up/dn counter；PAM3 下把"仅 HIGH 时启用"推广为"非中心电平时启用"，并把正/负 peak detection 分开实现
- **up/dn counter 必须双端防溢出 (bound01) **，否则"计数 → 溢出 → 计数"的循环会让环路永远收敛不到确定的解
- **最佳分压比 (volt_scale) 随 CML_IR 与 RC 衰减而变，且 POS / NEG 两端的最佳值不同** (因 slicer offset) ，需分别设置或引入 calibration
- auto-zero 环路易振荡 (反馈裕度不足) ，本项目最终放弃；若要做，建议加 lock detection 取滞回中间值，并降低校准时钟

**测试台**
- 输入衰减不必用 1.0 UI 这么大，只需让眼图接近闭合即可 (0.6 ~ 0.8 UI) ，毕竟前面还有 CTLE
- SH 的实际采样点在 CK 上升沿之前约 8 ps (setup time 6 ~ 10 ps) ，要在时钟对齐里体现；一个 SH 带载两个 summer 是过度设计，testbench 的带载情况要与实际一致

**数字与顶层**
- 控制字位数要早统计、留余量 (本项目漏算了 LPF + CP 部分) ，多通道尽量 share 控制字
- **AFE + CDR 拼接时最危险的往往是非对称时钟串扰** (见第 3 节) 
- 数字码出现非 ±1 跳变时，先怀疑 verilog converter 的精度，换用 precise 版本

**论文 / 投稿**
- ISSCC 硬性要求：正文 ≤ 11000 字符 (计空格) 、连标题 ≤ 5 页、Arial Narrow 12pt 单栏双倍行距、标题 ≤ 12~14 词、摘要 ≤ 500 字符、参考文献 ≤ 30 条、严格双盲、图必须过 Figure Density Check (2027 新规) 
- **正文 / 图 / 表 / 参考文献的数值必须四方交叉核对**；DOI 逐条点开验证；投稿问卷与 COI 声明不要用模板误答




## 100. Notes Collections

``` bash
202509_LDO:
- 像我们这类 10 mA 级别的 LDO 算是电流比较大的了，如果想用 NMOS Pass, 要么有相当不错的 voltage headroom (1.3 V 左右)，要么用 native device 或者 low Vth device
- 按以前的经验，LDO 应该是负载电容越大越稳定，但实际上 "并非如此"；在本次设计中我们发现，系统的相位裕度随负载电容增大会先减小再增大，在小电容 (pF) 或大电容 (uF) 下可以正常工作，对于中等大小电容则会不稳定；之前 "LDO 负载电容越大越稳定" 的经验是对于含有外部电容的 LDO 而言，其工作在右端的大电容区间，而 capacitor-less LDO 则工作在左端的小电容区间
- 对 capacitor-less LDO 而言，NMOS Pass 的稳定性比 PMOS 好得多 (NMOS Pass 下的 GBW_LDO 小得多), PMOS Pass 可以通过降低功率管增益/运放GBW/引入补偿网络来提高稳定性 (牺牲 PSRR 性能)
- 如果仅对 PSRR @ DC 有要求，可以考虑加一个 buffer stage 来驱动功率管，这会大幅降低环路的 GBW, 从而显著提高稳定性 (牺牲中频 PSRR)
- 尽管理论上 NMOS Pass 的 PSRR 会更好，但我们本次设计中却是比 PMOS Pass 差了一点点，也不知是 native device 还是 vgs 的原因
- 本次的 capacitor-less LDO, 在低电流 (轻载) 时稳定性差，在大电流 (重载) 时稳定性会更好；至于 PSRR，前仿和 Gate Level 后仿倒都是轻载差重载好，但 Tran Level 的后仿却是轻载好而重载差
- 提取寄生参数时，无论选择哪种输出格式，提取结果都几乎一致，仅在仿真速度上有略微差异 (SPECTRE 比 HSPICE/DSPF 稍长些)
- 对于一个走线电阻均非常小的优秀版图，如果电路中不存在 mim/mom cap 这类特殊器件，Gate Level 和 Transistor Level 的后仿结果是几乎找不出区别的
- 后仿时用 maestro 似乎不需要再单独设置保存节点数 (我们也没找到在哪设置)，几个项目仿真下来感觉 maestro 会保存电路中与 schematic 对应的一些主节点，可以大幅度节省空间 (但自然没有仅保存顶层节省得多)
- 也不清楚是什么原因，后仿时仿真器总是在 opening psf file 这一步卡很久 (从 output log 中看出)，如果能解决这个问题，仿真速度会大大提高
- 65nm 下的运放，输入共模距离 VDD 有 0 ~ 0.7V 时可以考虑 nmos input, 距离 VSS 有 0 ~ 0.7 V 时可以考虑 pmos input，对于卡在中间的情况，还是建议用 constant-gm op amp
- 从其它 cell > layout 复制部分版图到新 cell > layout 时，可能出现版图元件 ROD 属性不对应的问题 (被刷新覆盖了)，如果直接点击 Update Components and Nets 会出现 unbounded 报错；这时只需在左下角找到 Define Device Correspondence 更新以下版图元件和原理图的对应关系即可
- NMOS 的 bulk/body 不想连 VSS/GND 的话，一般都要使用 DNW 隔离出 local p-sub, 否则会产生 stamping conflict 报错，也即 "高阻短路" 现象，这是一个比较严重的 ERC 问题，后仿不一定能仿出来，导致流片后结果与后仿差异较大
- 使用 crtmom 时 ERC 检查中出现 floating n-well 报错，可以通过将其版图属性 "Well Type" 从 N 修改为 P 来解决 (使用 PW 而非 NW)
- 模块设计完毕之后，我们通常会在整个模块外围套上多层 guard ring 以提供较好的隔离效果，一般是内 p-ring (VSS) 外 n-ring (VDD), 围上后 LVS > ERC 会报一条 floating p-sub 的错误，这是因为整个电路的 p-sub 未连接到外部，是正常现象，因为我们还没把模块集成到系统中去


202509_OTA:
- 无论什么工艺，对绝大多数设计而言，基本上都可使用下面的八个 corners 作为全温度-工艺角，可以覆盖绝大多数温度-工艺变化情况：
    - TT: +27°C, +65°C
    - FF: -40°C, +130°C
    - SS: -40°C, +130°C
    - FS: -40°C
    - SF: +130°C
- 仿真时遇到报错 `Internal error found in spectre during hierarchy flattening, during circuit read-in. Encountered a critical error during simulation.` 可能是因为管子的 finger 设置为了非整数 (例如 2.5)，将 finger 设置为整数即可解决
- 对 constant-Gm OTA, VDD 在不同范围适用不同的补偿方法：
    - no compensation: VDD = 1.7*VTH ~ 2.3*VTH
    - current-reuse: VDD >= 2.2*VTH
    - ...... (待补充)
- 由于电流源的非理想性，OTA 的总跨导 Gm 一般都达不到 (Gm_N + Gm_P), 多数在 40% ~ 70% 之间
- **在版图中导入器件，仅放置器件、修改器件版图属性、放置 VSS/VDD label，还未连线时，我们运行一次 LVS, 正确的报错应该为 layout 中的器件在 schematic 中显示 missing instance 而不是 missing injected instance，如果出现后者，说明 schematic 中的器件有问题，需要重新放置一遍器件再试；反之，schematic 中的器件在 layout 中显示 missing injected instance 是正常的，这不会影响后续的 LVS。** (这个问题曾困扰我们好几天)
- 模拟电路中，为提高流片稳定性，一般要保证所有的 via/CO 都至少有两个，尤其是 CO, 在管子 L or W 较小时容易只有一个
- 仿真设计好的模块版图时，如果遇到 "模块版图边界比实际边界大得多" 的问题，打开模块 layout 后在 CIW 输入 `(foreach st geGetEditCellView()~>steiners dbDeleteObject(st))` 便可解决


202509_DAC:
- **版图中的器件并不需要完全从原理图中导入，可以在版图中直接放置，即便没有修改对应关系也是能正常过 DRC/LVS 的**；但是对应关系不对的话，可以导致版图上显示的 net 出错，从而出现很多 "假的短路"，一方面看起来很乱，另一方面也可能影响到后续的版图设计，因此最好还是在 Connectivity > Define Device Correspondence 中手动更新一下对应关系
- **设置为 (segments = 2, series) 的 dummy 电阻是非常容易出 LVS 错误的，一般是关闭 `LVS Options > LVS Filter Unused Option` 则不报错，但只要一打开，即便没有勾选任何过滤项也会导致报错，根本原因是 reduction parallel/series priority. 因此，为了避免 LVS 上的扯皮，要么尽量不用 series = 2 的电阻设置，要么将 series = 2 的 dummy 电阻在原理图拆分成两个电阻并且 中间节点悬空 (floating)，然后两端都接 VSS 形成短路。** (这个问题曾困扰我们好几天)
- 原理图/版图中如果电阻的宽度/长度具有三位小数 (例如 1.005 um)，某些工艺的 LVS 会提取成 1.010 um 导致电阻尺寸出现误差，从而报错 discrepancy, 因此在设计时就要注意电阻尺寸不能有三位小数


202602_CDR (→ 202605_TRX):
- **calibre view 不可复现：** 同一版图重提参后大小从 153.7 MB 变为 110~120 MB，仿真结论直接翻转；跑通的结果要连 calibre 一起备份
- **先想清楚指标的约束来源：** slicer 的 tcq 只需 < 1 个 CK 周期 (72 ps) ，不是 36 ps，为此白做了一周结构迭代
- **"怎么调都不对" 时先换仿真器精度：** CP 漏电问题排查两天，最终是 Spectre FX 精度不足，换 APS 后正常
- **比较器 offset 与版图对称性无关：** 常见根因是 reset 开关管尺寸不足 (fn 2 → 4 后改善) ；建议预留 calibration input pair
- **kickback 抑制电容会引入二次回踢：** 本项目最终不加任何交叉耦合电容效果最好
- **CML 摆幅 ≤ Iss*R；多个 summer 共用偏置时每个只分到 1/N** (摆幅曾从 ±500 mV 掉到 ±125 mV) 
- **counter 的速率瓶颈是 AND 链不是触发器；AND 不能简单换 NAND；逻辑门越大不一定越快；单元级最快 ≠ 系统级最快。**
- **动态 DFF 低频失效；DFF as DIV2 的最高频率比真实用途高 3~4 倍。**
- **DFE tap weight 要在采样点适当偏大；PI 的占空比失真比相位误差更致命。**
- **Verilog-A 宏的整数除法陷阱** (`PHASE_NUM = 8` 做除法得 0) ；**不要把 `transition()` 写在 `analog` 块里**
- **时钟走线必须严格对称：** SH 的 CK/CKB 不对称串扰曾让整个 dataPath 五组参数全部失效
- **模块拼接后性能必下降** (单独 SSS 可 1.0 V @ 64 Gbaud，拼成 dataPath 后只能 1.1 V @ 62 Gbaud) 
- **几 ps 的时钟/数据对齐误差就足以毁掉系统** (差 2.6 ps 使 SH 眼高从 100 mV 掉到 50 mV) 
- **对比性实验一次只改一个变量**，否则无法归因
- **保存节点用 `lvl @ level = 1`；gate level 后仿与 tran level 结果一致但快约 3.5 倍；前仿→RF→后仿延迟约成 2~3 倍衰减。**
- **跑通即归档，记录 interactive 编号**；不要在同一个库上做实验性修改 (`copy hierarchical` 到新库) 
- **投稿前必须逐项核对正文/图/表/参考文献的一致性**，DOI 逐条点开验证
```

 (待补充) 
