# Use Virtuoso Efficiently - 3. Decorate Your Library Manager

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 13:33 on 2025-08-19 in Lincang.

## 调整后的示例

参考 [知乎 > 让你的 Cadence Library 更加美观](https://zhuanlan.zhihu.com/p/20739660)，文中的例子是 IC617, 但其步骤同样适用于我们的 Cadence IC618 。

调整之前是这个样子的：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-13-36-31_Use Virtuoso Efficiently - 3. Decorate Your Library Manager.png"/></div>

最终调整效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-14-12-46_Use Virtuoso Efficiently - 3. Decorate Your Library Manager.png"/></div>


## 具体调整步骤

打开 `Library Manager > View > Display Options > Custom library display attributes`, 点击 add 创建一个新的 Library Display Attributes, 不妨命名为 `MyLibraries`, 并勾选样式 `Using color` 和 `Using icon`。至于颜色和图标，自己凭喜好选择即可 (icon 图片可以使用自己导入的)。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-13-39-53_Use Virtuoso Efficiently - 3. Decorate Your Library Manager.png"/></div>


然后去工作目录下打开 `cds.lib` 文件，将想要修改样式的工艺库归到 `MyLibraries` 类：

``` bash
# 此部分放在 cds.lib 文件末尾 (先 DEFINE 才能 ASSIGN)
ASSIGN MyLib_fileBackup DISPLAY MyLibraries
ASSIGN MyLib_general    DISPLAY MyLibraries
ASSIGN MyLib_tsmc18rf   DISPLAY MyLibraries
ASSIGN MyLib_tsmcN28    DISPLAY MyLibraries
ASSIGN MyLib_verilog    DISPLAY MyLibraries
```

保存并重新打开 Library Manager 即可，效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-13-53-42_Use Virtuoso Efficiently - 3. Decorate Your Library Manager.png"/></div>

有人说，这样看起来还是很乱，能不能进一步分类呢？其实是可以的。

我们再新建一个**Library**叫 `TechLib`，然后在 `cds.lib` 加入下面一行代码，将自带的一些默认库都添加进去：

``` bash
ASSIGN TechLib COMBINE US_8ths ahdlLib analogLib basic cdsDefTechLib functional m1815_g2 rfExamples rfLib rfTlineLib
```

这样是不是就清晰多了呢：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-14-03-26_Use Virtuoso Efficiently - 3. Decorate Your Library Manager.png"/></div>

照这个思路，我们将其它的 PDK 工艺库归到名为 `ProcessLib` 的新库中。全部代码汇总如下：

``` bash
#####################################################
# 此部分代码放在 cds.lib 文件末尾 (先 DEFINE 才能 ASSIGN)
ASSIGN MyLib_fileBackup DISPLAY MyLibraries
ASSIGN MyLib_general    DISPLAY MyLibraries
ASSIGN MyLib_tsmc18rf   DISPLAY MyLibraries
ASSIGN MyLib_tsmcN28    DISPLAY MyLibraries
ASSIGN MyLib_verilog    DISPLAY MyLibraries

ASSIGN TechLib COMBINE US_8ths ahdlLib analogLib basic cdsDefTechLib functional m1815_g2 rfExamples rfLib rfTlineLib

ASSIGN ProcessLib COMBINE smic13mmrf_1233 smic18ee smic18mmrf tsmc18rf tsmcN28 tsmcN65
ASSIGN ProcessLib DISPLAY ProcessLib
ASSIGN smic13mmrf_1233 DISPLAY ProcessLib
ASSIGN smic18ee DISPLAY ProcessLib
ASSIGN smic18mmrf DISPLAY ProcessLib
ASSIGN tsmc18rf DISPLAY ProcessLib
ASSIGN tsmcN28 DISPLAY ProcessLib
ASSIGN tsmcN65 DISPLAY ProcessLib
#####################################################
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-14-12-46_Use Virtuoso Efficiently - 3. Decorate Your Library Manager.png"/></div>








