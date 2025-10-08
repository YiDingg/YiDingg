# Experience Summary of Analog IC Design, Simulation, Layout, and PEX

> [!Note|style:callout|label:Infor]
> Initially published at 14:32 on 2025-09-22 in Beijing.


## Introduction

最近几个月学习/参与的项目比较多，包括 OTA/OPA, BGR, LDO, PLL 等等，每个项目或多或少都会遇到一些困难，杂七杂八的经验也积累不少，特此总结在这里，方便日后查阅。

## 0. Misc 

首先是一些杂七杂八的经验/问题：
1. **任何设计/前仿/版图/后仿过程都应做好记录：**不仅要记录设计思路和细节、遇到的问题和解决方案，还要记录下各个版本之间的迭代过程和参数变化，方便之后参考和复现。没有任何记录的电路设计，就好比 "无根之木，无源之水"，徒有空中楼阁其而无内在支撑。否则，即便是设计者本人，一段时间后也会几乎完全忘记当时的思路和细节，更何况是阅读/接收此设计的他人了。
2. swap activity warning 弹窗


## 1. Design and Iteration

设计中的一些经验：
- 像 BGR 和 LDO 这种不需要极快瞬态响应的电路/环路 (特殊快速 LDO 除外)，相位裕度基本上越高越好，保持 80° 以上的裕度能使电路的鲁棒性大大增强 (人话：更耐造)；当然，提高相位裕度必定会牺牲其它性能指标，要根据具体情况进行权衡。
- xxx

## 2. Pre-Layout Simulation

要想将 ADE L/XL 的设置转到 Explorer/Assembler, 只需先 save state 再到 Explorer 里导入。

扫描多个变量并作图时，如果横坐标不是想要的变量，到 `Axis > Y vs. Y` 或者 `Axis > Sweep Varible` 即可更改。当然， **最好是将需要作为横坐标的变量放在 variables 的最后** ，从根源上解决问题。

## 3. Layout and DRC/LVS

- 使用 DNW + NW 来隔离器件 (形成 local p-sub) 时，用作包围的 N-Well 不能太窄，否则会 DRC 会报错 DNW.S.5, 例如 tsmcN65 中应满足 NW >= 1.2 um (详见 [这篇文章](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.md>) 的 "2.10 DRC and LVS" 一节)
- 小型电路建议所有 net 都手动命名，避免版图复制后的 net 更新问题；这是因为有时我们要更新电路的 schematic, 可能因为新元件/删元件等原因导致多个 net 名称发生变化，如果这时直接将原理图更新到版图，版图只会更新各器件的连接关系，而 (可能) 不会更新金属连线的 net 名称，导致出现 "fake short-circuit"，虽然这不影响 DRC/LVS/PEX 结果，但会严重影响后续的版图迭代 (让阅读版图的人非常迷惑)。
- 从其它 cell > layout 手动复制部分版图到新 cell > layout 时，可能出现版图元件 ROD 属性不对应的问题 (被刷新覆盖了)，这时如果直接点击 `Update Components and Nets` 会出现 `unbounded` 报错；解决这个问题，只需在左下角找到 `Define Device Correspondence`，更新一下版图元件和原理图的对应关系即可
- `Ctrl + Shift + X`: 画 BUS 线的快捷键，可以同时走多条平行走线

常见 DRC 报错与解决方案：
- **NW.S.5 { @ Space to PW STRAP >= 0.16 um:**

## 4. PEX and Post-Simulation

1. 后仿时间/空间消耗一般比较大，为节省硬盘、提高仿真速度，可以采用文章 [Virtuoso Tutorials - 14. Understanding Substrate, Well, Tap, and Guard Ring in Analog IC Layouts](<AnalogIC/Virtuoso Tutorials - 14. Understanding Substrate, Well, Tap, and Guard Ring in Analog IC Layouts.md>) 末尾提到的几种方法：
    - (1) 设置仅保存特定节点 (save selected node)
    - (2) ADE XL 中设置 multi-job simulation, 可以同时并行跑多个仿真
2. 版图完成后做 PEX，选择 Transistor Level 时如果输入了 x-cells 文件链接也不会导致寄生参数重复提取 (对 tsmcN65 工艺库，其它暂不清楚)，因为导出后会发现警告 **WARNING: PEX IDEAL XCELL is only applied in gate-level extraction.** 表示本次提取并没有应用 XCELL, 也就没有重复提取。





