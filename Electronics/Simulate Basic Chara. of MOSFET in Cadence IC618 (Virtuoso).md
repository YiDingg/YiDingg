# Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso)

> [!Note|style:callout|label:Infor]
> Initially published at 17:08 on 2025-05-20 in Beijing.

## Introduction

Cadence 安装教程、实用技巧和仿真示例等详见 [How to Use Cadence Efficiently](<AnalogIC/How to Use Cadence Virtuoso Efficiently.md>).

## Simulation Steps

### 单参数 dc 扫描

- 先正常选择工艺库 (我们选择 `tsmc18rf` 台积电 180nm CMOS 工艺库)，放置 MOSFET 和 `analogLib` 库中的 `gnd` 和 `vdc` (DC voltage source)，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-11-33-19_Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).png"/></div>

- 然后调整仿真设置：
    - `ADE L > Variables > Edit > Cellview Variables > Copy From`, 这会自动将 schematic 中的变量复制到仿真设置中，然后设置一下它们的初值
    - 单参数扫描：`ADE L > Analyses > Choose > dc > Sweep Variable`
- Output 设置：`Output > Edit > From Design > 选中 NMOS 的 drain`, 或者用 `Calculator` 手动选择 `if > /NMOS/D` (表示 $I_D$)
    - id: `/NMOS/D`
    - gm/id: 先随便仿真一次，然后在 `Tools > Results Browser > dcOpInfo` 找到 `NMOS > gm`, 右键加入 calculator
    - `calculator > os`: 挑选一个元器件, 然后选择直创建表达式
- 查看仿真结果：鼠标右键拖选可放大局部图像


单参数扫描结果 (`Vds = 1`, 扫描 `Vgs`):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-12-06-07_Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-13-46-25_Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-14-01-43_Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).png"/></div>

### 多参数 dc 扫描

- 先按单参数进行一次扫描 (即设置第一变量, 作为横坐标), 运行仿真
- 再设置第二变量: `ADE L > Tools > Parametric Analysis > 设置第二变量`, 点击 Parametric Analysis 的 `Run`
- 查看多参数扫描结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-14-18-50_Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-14-29-07_Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).png"/></div>