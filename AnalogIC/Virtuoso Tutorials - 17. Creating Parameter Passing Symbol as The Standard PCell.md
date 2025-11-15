# Virtuoso Tutorials - 17. Creating Parameter Passing Symbol as The Standard PCell

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 23:55 on 2025-10-25 in Beijing.

## Background

本次 `onc18` 工艺库没有自带标准数字单元库，像常用的 INV/NOR 等基本逻辑门都需要我们自己搭建。为了方便修改和调用，我们可以将每一个 cell 封装成 parameter passing symbol 的形式，类似 `tsmcN28 > nand2_18_mac` 那样，可以直接在 symbol 属性编辑中修改管子参数，并且正常导入到版图。

## Parameter Passing Symbol

下面以一个 2-input NAND gate 为例，介绍如何创建 parameter passing symbol.

首先创建 cell view 命名为 `parameter_Logic_1p8vuhvt_NAND`，其中 parameter 特指此 cell 是一个 parameter passing cell. 在原理图层面放置好管子：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-00-36-14_Use Virtuoso Efficiently - 5. Create Parameter Passing Symbol.png"/></div>

然后需要创建 CDF parameter 并填入器件的各参数，可以通过版图来查看原始 CDF parameter 名称，也可以自行创建新的 CDF parameter (推荐后者)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-23-50-41_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>



看了下库中原始 CDF parameter 名称，综合各方面考虑，我们决定创建/使用以下 CDF parameters:
- `mu`: multiplier number
- `ng`: number of fingers
- `wg`: NMOS finger width
- `lg`: NMOS finger length
- `ka`: width adjustment factor (fingerWP = KA\*fingerWN)

将 CDF parameters 填入器件之前，我们需要确定单位问题：按普通方法填写器件参数时 (例如 width)，参数后面是否有自动添加单位 (um/nm 等)？像 onc18 这个工艺库就没有，也就是说我们的 CDF parameter `wg` 既不需要在后面手动输入单位，也不需要在 CDF parameter 处设置单位。




考虑好之后，就可以开始创建了，先是原理图层面：
- (1) 在原理图中用 `pPar()` 函数设置好器件各参数值
    - 对于 NMOS, 填入 width = `pPar("wg")`, length = `pPar("lg")`, fingers = `pPar("ng")`, multiplier = `pPar("mu")`
    - 对于 PMOS, 填入 width = `pPar("wg")*pPar("ka")`, length = `pPar("lg")`, fingers = `pPar("ng")`, multiplier = `pPar("mu")`
- (2) 保存并创建 symbol view **(如果已经有 symbol view, 需要 modify 以更新)**，symbol 里可以用 `[@CDF_parameter]` 语法来显示 CDF parameter 的值，方便 top 原理图层面查看

原理图设置效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-01-52-52_Use Virtuoso Efficiently - 5. Create Parameter Passing Symbol.png"/></div>


然后设置 CDF 参数：
- (1) 属性：在 `CIW > Tools > CDF Edit` 找到刚刚的 cell, 设置 CDF 属性为 **Type = Base (重要！默认 Effective 是不会自动保存并加载的)**；然后上面这些 CDF 参数，没有自动导入手动添加即可
- (2) 单位：某些工艺库需要将宽度和长度的 units 改为 `lengthMetric`， **但是注意 onc18 库不需要** ，保持默认 `don't use` 就行
- (3) 解析：设置 `ParseAs Number = yes` 和 `Parse as CEL = yes`
- (4) 注记 Prompt: Prompt 是可以任意修改的自定义注记 (但 Name 就是 CDF Parameter 名称，不可随意修改)

设置好后的效果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-03-08-03_Use Virtuoso Efficiently - 5. Create Parameter Passing Symbol.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-02-59-12_Use Virtuoso Efficiently - 5. Create Parameter Passing Symbol.png"/></div>

## Matters Need Attention

一些注意事项：
- (1) 一般情况下必须设置 `ParseAs Number = yes` 和 `Parse as CEL = yes`, 否则可能无法正常识别参数值 (设为 no 可能会出问题, 参考 [here](https://hui-shao.com/cadence-ic514-symbol-cdf/#fn1))；特别地，对于 ng (finger length)，由于其不参与任何 pPar 层面运算，可以设置 `Parse as CEL = no` 以避免 (工程) 科学计数法显示问题 (仍保持 `ParseAs Number = yes`)，此时 0.18um 会显示为 0.18 而不是 180e-03
- (2) CDF parameter 的单位要与 "手动填入具体数值" 时匹配，如果手动填入时不会自动补充单位，那么 CDF parameter 也不要设置单位


## Reference

- [Community Forums Custom IC Design Symbol with design variable](https://community.cadence.com/cadence_technology_forums/f/custom-ic-design/24600/symbol-with-design-variable)
- [Community Forums Custom IC Design how to create parameter passing symbol?](https://community.cadence.com/cadence_technology_forums/f/custom-ic-design/28287/how-to-create-parameter-passing-symbol)
- [Cadence Virtuoso IC 514 Symbol 可变参数设置指南](https://hui-shao.com/cadence-ic514-symbol-cdf/)
- [CSDN > 快速建立尺寸不同的反相器等单元](https://blog.csdn.net/qq_40007892/article/details/119246219)
- [Creating a Parameterized Cell in Cadence](https://wikis.ece.iastate.edu/vlsi/index.php?title=Creating_a_Parameterized_Cell_in_Cadence)
- [知乎 > Create a Parameterized Cell using SKILL](https://zhuanlan.zhihu.com/p/694567297)