# Use Virtuoso Efficiently - 5. How to Save Your Settings and Workspace Setup

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 17:15 on 2026-01-25 in Lincang.
> dingyi233@mails.ucas.ac.cn

## Introduction

在使用 Cadence Virtuoso 时，有些设置和工作区是非常常用的，比如：
- (1) 原理图中的 `Dynamic NEt Highlighting` (动态网络高亮显示)：鼠标放到某个节点 (网络) 上时，会在原理图中自动高亮显示此网络，方便查看有哪些元件连接到了这个网络上
- (2) 版图中的 `Grid Type = none`：取消网格显示，可以更清晰地查看版图
- (3) 版图中的 `Dimming > Enable`：选择对象后自动将未选择对象变暗，方便查看当前选择的对象
- (4) 版图中的 `Toolbars > Align, Net transceiver`：前者显示对齐工具栏 (默认是不显示的)，方便进行元件对齐操作；后者可以 "点亮" 指定网络，方便查看网络走线情况
- (5) 版图中的 `Assistants > Navigator, Dynamic Selection, Property Editor`：一些常用的辅助面板，方便版图选择、查看和编辑

其中类似 (1) (2) (3) 的设置可以直接在 `.cdsinit` 文件中进行环境变量赋值，或者直接在 `.cdsenv` 文件中进行设置。 这两种方法是几乎等价的，但注意软件是先运行 `.cdsinit` 再运行 `.cdsenv`，后者会覆盖前者。但类似 (4) (5) 这种涉及 workspace window setup 的设置，就没法直接通过 `.cdsinit` 或 `.cdsenv` 来实现了，

## 保存 workspace 和默认环境变量设置

调整好版图工作区设置后，点击 `Save Workspace` 按钮，也可以点击上方工具栏的 `Window > Workspaces > Save As` (效果是一样的)，保存当前的 layout workspace setup 到 **home** 路径下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-18-14-42_Use Virtuoso Efficiently - 5. How to Save Your Settings and Workspace Setup.png"/></div>

注意：
- 保存到 home 路径相当于全局设置，之后打开任意 layout 时 workspace 都会是这样
- 保存到 ./.cadence 相当于局部设置，仅当前 cell 打开 layout 时 workspace 会是这样
- 注意 grid/dimming 等设置由 .cdsenv 文件控制，与 .cadence 文件夹无关（仅控制 workspace 样式）

如果有需求，也可以对 schematic workspace 进行设置和保存。

设置并导出 layout/schematic workspace 后，不要退出这些界面，直接回到 CIW 窗口保存环境变量：点击 `Options > Save Defaults`，所有属性均保持默认值 (导出模式为 merge, 也即用最新值覆盖原有值，这样不会影响原来的设置)；设置好保存路径后点击 `OK`，会将当前的所有设置 (包括 workspace setup) 保存到指定路径下的 `cdsenv` 文件中。

在导出的一大堆内容基础上，我们再把很久之前这篇文章中 [Use Virtuoso Efficiently - 1. Shortcuts and Initialization](<AnalogIC/Use Virtuoso Efficiently - 1. Shortcuts and Initialization.md>) 就提到过的仿真相关设置加上，代码详见后文。




## layout 设置保存后未生效的问题

这里遇到一个问题是：workspace 和 schematic 设置确实是正常保存下来了，但 layout 中的相关设置 (如 grid type, dimming) 等都 "没能生效"，也检查过导出的 `.cdsenv` 文件，里面 layout dimming 等环境变量都是正确的，为什么会没生效呢？找了半天没找到原因，无奈采取退一步方案：设置好 layout display settings 后，直接将其保存到 `Library` 和 `Tech Lib` 而不是 `File > ./.cdsenv`。


后来又发现是应该使用环境变量 `layout drawGridOn boolean nil` 来关闭网格显示，于是在原有仿真相关设置的基础上，又手动加了下面几行：



``` bash

/*
\u4e0b\u9762\u662f .cdsenv \u914d\u7f6e\u5185\u5bb9 (\u622a\u81f3 2025.07.14), \u6765\u6e90\u4e8e\u77e5\u4e4e\u4f5c\u8005 https://www.zhihu.com/people/YiDingg
\u76f4\u63a5\u5c06\u672c\u6bb5\u4ee3\u7801\u590d\u5236\u5230 .cdsenv \u6587\u4ef6\u7684\u672b\u5c3e, \u540e\u52a0\u8f7d\u7684 env \u4fbf\u53ef\u8986\u76d6\u539f\u59cb\u503c, \u4e0d\u9700\u8981\u4e00\u4e2a\u4e00\u4e2a\u641c\u7d22\u7136\u540e\u4fee\u6539
*/

viva.application	vivaWindowMode	string	"window"

;\u8bbe\u7f6elable\u5b57\u4f53\uff1a\u5c06\u539f\u7406\u56fe\u548c\u7248\u56fe\u4e2d\u7684 lable \u5b57\u4f53\u90fd\u6539\u4e3a roman, \u8fd9\u6837\u770b\u8d77\u6765\u4f1a\u66f4\u6e05\u6670\u4e00\u4e9b
;\u5176\u5b83\u53ef\u9009\u5b57\u4f53\u8fd8\u6709 "stick", "Helvetica" "Open Sans", "monospace", "euroStyle", "gothic", "math", "script", "fixed", "swedish", "milSpec" \u7b49\u7b49
schematic  createLabelFontStyle  cyclic  "roman"
schematic	createLabelFontHeight	float	0.05 ; \u9ed8\u8ba4 lable \u5b57\u4f53\u9ad8\u5ea6\u4e3a 0.0625 (1/16 \u82f1\u5bf8, \u5373 1.5875 mm), 
schematic	symbolLabelFontHeight	float	0.05
layout  labelFontStyle  cyclic  "roman"

; \u8bbe\u7f6e\u4eff\u771f\u6ce2\u5f62\u56fe\u7684\u80cc\u666f\u989c\u8272
viva.rectGraph    background  string  "white"
viva.graphFrame  background  string  "white"

; \u8bbe\u7f6e\u4eff\u771f\u6ce2\u5f62\u56fe\u7684\u5bbd\u5ea6\u548c\u9ad8\u5ea6 (\u9ed8\u8ba4 1024x256)
viva.graphFrame width string "1800"
viva.graphFrame height string "900"

; \u8bbe\u7f6e\u4eff\u771f\u56fe\u7684\u5b57\u4f53\u5b57\u53f7\uff1a
viva.graph  titleFont  string  "roman,10,-1,5,45,0,0,0,0,0" ; \u5305\u62ec\u4eff\u771f\u7ed3\u679c\u4e0a\u65b9\u7684\u65f6\u95f4\u663e\u793a\u3001\u5de6\u4e0a\u89d2\u7684 title
viva.axis     font   string   "Default,12,-1,5,45,0,0,0,0,0" ; \u4eff\u771f\u56fe\u6a2a\u7eb5\u5750\u6807\u4e0a\u7684\u6587\u5b57\u3001\u6570\u5b57
viva.traceLegend	font	string	"roman,8,-1,5,40,0,0,0,0,0" ; \u4eff\u771f\u56fe\u5de6\u4fa7\u7684 legend, \u5efa\u8bae\u81f3 8 \u6216 9, \u4ee5\u514d\u6324\u5360\u4eff\u771f\u7ed3\u679c\u56fe\u7684\u663e\u793a
viva.horizMarker font    string   "roman,10,-1,5,45,0,0,0,0,0"
viva.vertMarker     font    string   "roman,10,-1,5,45,0,0,0,0,0"
viva.referenceLineMarker    font  string    "roman,10,-1,5,45,0,0,0,0,0"
viva.interceptMarker	font	string	"roman,10,-1,5,45,0,0,0,0,0"

; lineThickness \u7531\u7ec6\u5230\u7c97\u4f9d\u6b21\u4e3a: "fine", "medium", "thick", "extraThick"
; lineStyle \u53ef\u8c03\u6574\u4e3a "none" (\u65e0), "solid" (\u5b9e\u7ebf), "dash" (\u865a\u7ebf), "dot" (\u70b9\u7ebf), "dashDot", "dashDotDot"
; \u8bbe\u7f6e\u7ebf\u6761\u7c97\u7ec6\u548c\u6837\u5f0f (\u5fc5\u987b\u4fee\u6539\u7b2c\u4e09\u53e5\u624d\u80fd\u751f\u6548)
; boolean \u7684 nil \u8868\u793a\u7a7a\u503c, \u53ef\u4ee5\u7406\u89e3\u4e3a false, \u800c t \u5219\u8868\u793a true
viva.trace  lineThickness  string  "medium"
viva.trace  lineStyle  string  "solid"
asimenv.plotting useDisplayDrf boolean nil

; \u8bbe\u7f6e marker \u663e\u793a\u7684\u6709\u6548\u4f4d\u6570
viva.pointMarker sigDigitsMode string "Manual"
viva.pointMarker significantDigits string "4"
viva.vertMarker sigDigitsMode string "Manual"
viva.vertMarker significantDigits string "4"
viva.horizMarker sigDigitsMode string "Manual"
viva.horizMarker significantDigits string "4"

; \u8bbe\u7f6e\u4eff\u771f\u56fe\u4e2d marker \u59cb\u7ec8\u663e\u793a\u5750\u6807\u70b9, \u53ef\u8bbe\u7f6e\u4e3a "on", "off", "OnWhenHover"(\u9ed8\u8ba4), \u5efa\u8bae "OnWhenHover"
viva.vertMarker	interceptStyle	string	"on" ; 
viva.horizMarker	interceptStyle	string	"on"
viva.referenceLineMarker	interceptStyle	string	"on"

; \u5176\u5b83\u8bbe\u7f6e
auCore.misc labelDigits int 6                           ;\u8bbe\u7f6e\u4eff\u771f\u7ed3\u679c\u663e\u793a 6 \u4f4d\u5c0f\u6570
layout displayPinName boolean t                         ;\u5728\u5e03\u5c40\u4e2d\u9ed8\u8ba4\u663e\u793a pin name
schematic schWindowBBox string "((300 50) (2000 950))"  ; \u4fee\u6539 schematic \u6253\u5f00\u65f6\u7684\u9ed8\u8ba4\u7a97\u53e3\u5927\u5c0f\u3001\u4f4d\u7f6e
layout leWindowBBox string "((500 50) (2200 950))"      ; \u4fee\u6539 layout \u6253\u5f00\u65f6\u7684\u9ed8\u8ba4\u7a97\u53e3\u5927\u5c0f\u3001\u4f4d\u7f6e
ui ciwCmdInputLines	int	12                      ; \u8bbe\u7f6e CIW \u7a97\u53e3 input area \u7684\u884c\u6570 (\u9ed8\u8ba4\u4e3a 1)
schematic showUndoRedoHistoryInEditor boolean t         ; \u5728 schematic \u4e2d\u663e\u793a\u64a4\u9500\u91cd\u505a\u5386\u53f2
adexl.testEditor adexlTestEditorSetupValidateMsg boolean nil
asimenv.startup  projectDir  string "/data/Work_dy2025/simulation" ; set simulation data path

; \u89e3\u51b3\u591a corner \u4eff\u771f\u4e0b\u5361\u6b7b\u5728 pending \u540e\u51fa\u73b0\u7684\u62a5\u9519 QUESTION (ADEXL-1921)
;setenv CDS_XVNC_TENBASE 2                 ; \u81ea\u5df1\u7528\u7684 vnc \u7aef\u53e3\u53f7\u7684\u5341\u4f4d\u6570
;setenv CDS_XVNC_OFFSET 4                  ; \u81ea\u5df1\u7528\u7684 vnc \u7aef\u53e3\u53f7\u7684\u4e2a\u4f4d\u6570


/* updated on 2026.01.25 22:26 */
layout drawGridOn boolean nil   ; Grid Controls Type - The default is "dots", but it is now changed to "none".
layout displayPinName boolean t ; The pin name is not displayed by default, but it is now set to be displayed by default.
layout viaRows int 2            ; The number of VIA holes is modified. The default is (Rows, Column) = (1, 1), but it is now changed to (Rows, Column) = (2, 1). 
layout keepCopying boolean t    ; Keep copying remains false by default. Now it has been changed to be true by default.
```



## 多个路径下的 .csdenv 文件有什么关系？


参考这篇文章 [kaixinspace > Virtuoso 配置文件 .cdsenv 介绍和使用](https://www.kaixinspace.com/virtuoso-cdsenv-file-introduce/) 可以知道，`.cdsenv` 文件的默认调用顺序为：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-25-19-15-22_Use Virtuoso Efficiently - 5. How to Save Your Settings and Workspace Setup.png"/></div>

**如想验证修改的相关环境变量是否起作用，而又无需反复重启Virtuoso，只需在 CIW 窗口输入如下代码即可： `envLoadFile("./.cdsenv")`** (但需要重新打开 schematic/layout).
