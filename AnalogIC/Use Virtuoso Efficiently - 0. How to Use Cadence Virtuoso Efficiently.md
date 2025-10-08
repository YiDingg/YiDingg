# How to Use Cadence Efficiently

> [!Note|style:callout|label:Infor]
> Initially published at 17:05 on 2025-05-20 in Beijing.


Cadence 相关教程见 [知乎 > YiDingg > Cadence Virtuoso (IC618) 教程汇总](https://zhuanlan.zhihu.com/p/1923539215657959730).



## Install Cadence IC618


详见文章 [How to Install Cadence IC618](<AnalogIC/Virtuoso Tutorials - 1. How to Install Cadence IC618.md>).


## Setting Tips

### 1. Recommended Settings

- 修改字体、字号：`初始窗口 > Options > Fonts`
- 修改快捷键：`初始窗口 > Options > Bindkeys`, 关于 `Bindkeys`, 下面是修改建议的一部分： **<span style='color:red'> 建议在 .cdsinit 文件中使用脚本语言来设置快捷键，详见后一小节 </span>**



<div class='center'>
<span style='font-size:11px'> 


| 快捷键 | 默认设置及其效果 | 修改建议与修改后的效果 |
|:-:|:-:|:-:|
 | `Schematic -> None<Btn4Down>` 鼠标滚轮上滑 (食指上滑) | `hiZoomInAtMouse` 放大界面 | `geScroll(nil "n" nil)`  界面上移 |
 | `Schematic -> None<Btn5Down>` 鼠标滚轮下滑 (食指下滑) | `hiZoomOutAtMouse` 缩小界面 | `geScroll(nil "s" nil)` 界面下移 |
 | `Schematic -> Ctrl<Btn4Down>` Ctrl + 鼠标滚轮上滑 (食指上滑) | `geScroll(nil "n" nil)` 界面上移 | `hiZoomInAtMouse` 放大界面 |
 | `Schematic -> Ctrl<Btn5Down>` Ctrl + 鼠标滚轮下滑 (食指下滑) | `geScroll(nil "s" nil)` 界面下移 | `hiZoomOutAtMouse` 缩小界面 |
 | `Schematic -> Ctrl<Key>Z` Ctrl + Z | `hiZoomOut()` 缩小界面 | `hiUndo()` undo (撤销) |
 | `Schematic -> Ctrl<Key>Y` Ctrl + Y | - (无) | `hiRedo()` redo (重做) |

</span>
</div>

<!-- 修改完成后记得左下角 `Save Bindings for All > Save`，以免下次又要重新设置。也可以直接在 `.cdsinit` 文件中添加代码，详见后一小节。 -->

### 2. .cdsinit and .cdsenv settings

本小节参考了以下资料：
- [重要: Virtuoso® Schematic Editor SKILL Functions Reference](<https://picture.iczhiku.com/resource/eetop/sykRGZGTDTSiYmCv.pdf>)
- [University of Southern California: Cadence Virtuoso Tutorial](https://ee.usc.edu/~redekopp/ee209/virtuoso/setup/USCVLSI-VirtuosoTutorial.pdf)
- [.cdsenv Tips & Tricks](https://aselshim.github.io/blogposts/2019-03-21-cdsenv/)
- [Cadence Tips and Tricks: Change Waveform Graph windows default settings](https://wikis.ece.iastate.edu/vlsi/index.php?title=Tips_%26_Tricks)
- [Bilibili: Cadence IC ADE 仿真学习笔记- 配置文件](https://www.bilibili.com/video/BV15T42197PQ)
- [Setting Bind Keys in Cadence Virtuoso Using SKILL Code](https://analoghub.ie/category/skill/article/skillBindkeysSetup)


我们可以利用 `.cdsinit` (cadence software initialization) 和 `.cdsenv` (cadence software environment parameters) 文件来配置一些每次启动 virtuoso 都生效的默认设置，这两个文件需要与 `cds.lib` 在同一目录。

- 按教程 [How to Install Cadence IC618](<AnalogIC/Virtuoso Tutorials - 1. How to Install Cadence IC618.md>) 安装的 cadence, 其安装路径 `<Cadence_Install_Directory>` 为 `/opt/eda/cadence/IC618`
- 找到 `<Cadence_Install_Directory>/tools/dfII/samples/.cdsenv` 文件，将其复制到工作目录 (virtuoso 启动目录) 下，例如 `/home/IC/.cdsenv` 
- 找到 `<Cadence_Install_Directory>/tools/dfII/samples/local.cdsinit` 文件，将其复制到工作目录 (virtuoso 启动目录) 下，例如 `/home/IC/.cdsinit`。然后需要做修改：<span style='color:red'> 搜索 `LOAD USER CUSTOMIZATION` (文件的最后几行), 在其下每一行添加一个分号 `;`, 将这一部分的内容全部注释掉，否则 virtuoso 不能正常启动</span>

<!-- - `.cdsinit` 我们就不复制了，因为直接复制过来会导致 virtuoso 无法启动
-->

`.cdsinit` 和 `.cdsenv` 使用的是 Cadence Skill 语言（一种用于 Cadence EDA 工具的脚本语言），其基本语法如下：

``` Cadence Skill
; 分号是单行注释符号，可以单独使用 ; 或多写几个 ;;; 增强可读性

/*
这是类似 C 语言的多行注释符号
多行注释符号
多行注释符号
*/ 
```


可以根据不同的需要，在两个文件中设置不同的内容。相对而言，我更喜欢在 `.cdsenv` 文件里做设置 (不涉及 SKILL 语言的相关语法, 通常更简洁一些)

``` bash
; 下面是 .cdsenv 配置内容 (截至 2025.07.14)
; 来源于知乎作者 https://www.zhihu.com/people/YiDingg
; 直接将本段代码粘贴到 .cdsenv 文件末尾, 后加载的 env (环境变量) 便可覆盖原始值, 不需要一个一个搜索然后修改 (直接覆盖 .cdsenv 文件也是可以的)



;设置lable字体：将原理图和版图中的 lable 字体都改为 roman, 这样看起来会更清晰一些
;其它可选字体还有 "stick", "Helvetica" "Open Sans", "monospace", "euroStyle", "gothic", "math", "script", "fixed", "swedish", "milSpec" 等等
schematic  createLabelFontStyle  cyclic  "roman"
schematic	createLabelFontHeight	float	0.05 ; 默认 lable 字体高度为 0.0625 (1/16 英寸, 即 1.5875 mm), 
schematic	symbolLabelFontHeight	float	0.05
layout  labelFontStyle  cyclic  "roman"

; 设置仿真波形图的背景颜色
viva.rectGraph    background  string  "white"
viva.graphFrame  background  string  "white"

; 设置仿真波形图的宽度和高度 (默认 1024x256)
viva.graphFrame width string "1800"
viva.graphFrame height string "900"

; 设置仿真图的字体字号：
viva.graph  titleFont  string  "roman,10,-1,5,45,0,0,0,0,0" ; 包括仿真结果上方的时间显示、左上角的 title
viva.axis     font   string   "Default,12,-1,5,45,0,0,0,0,0" ; 仿真图横纵坐标上的文字、数字
viva.traceLegend	font	string	"roman,8,-1,5,40,0,0,0,0,0" ; 仿真图左侧的 legend, 建议至 8 或 9, 以免挤占仿真结果图的显示
viva.horizMarker font    string   "roman,10,-1,5,45,0,0,0,0,0"
viva.vertMarker     font    string   "roman,10,-1,5,45,0,0,0,0,0"
viva.referenceLineMarker    font  string    "roman,10,-1,5,45,0,0,0,0,0"
viva.interceptMarker	font	string	"roman,10,-1,5,45,0,0,0,0,0"

; lineThickness 由细到粗依次为: "fine", "medium", "thick", "extraThick"
; lineStyle 可调整为 "none" (无), "solid" (实线), "dash" (虚线), "dot" (点线), "dashDot", "dashDotDot"
; 设置线条粗细和样式 (必须修改第三句才能生效)
; boolean 的 nil 表示空值, 可以理解为 false, 而 t 则表示 true
viva.trace  lineThickness  string  "medium"
viva.trace  lineStyle  string  "solid"
asimenv.plotting useDisplayDrf boolean nil

; 设置 marker 显示的有效位数
viva.pointMarker sigDigitsMode string "Manual"
viva.pointMarker significantDigits string "4"
viva.vertMarker sigDigitsMode string "Manual"
viva.vertMarker significantDigits string "4"
viva.horizMarker sigDigitsMode string "Manual"
viva.horizMarker significantDigits string "4"

; 设置仿真图中 marker 始终显示坐标点, 可设置为 "on", "off", "OnWhenHover"(默认), 建议 "OnWhenHover"
viva.vertMarker	interceptStyle	string	"on" ; 
viva.horizMarker	interceptStyle	string	"on"
viva.referenceLineMarker	interceptStyle	string	"on"

; 其它设置
auCore.misc    labelDigits int 6 ;设置仿真结果显示 6 位小数
layout displayPinName boolean t ; ; 在布局中默认显示 pin name
schematic	schWindowBBox	string	"((300 50) (2000 950))" ; 修改 schematic 打开时的默认窗口大小、位置
layout	leWindowBBox	string	"((500 50) (2200 950))" ; 修改 layout 打开时的默认窗口大小、位置
ui	ciwCmdInputLines	int	12 ; 设置 CIW 窗口 input area 的行数 (默认为 1)
schematic	showUndoRedoHistoryInEditor	boolean	t ; 在 schematic 中显示撤销重做历史
```


另外，在 `.cdsinit` 文件中，我们也有一些实用的设置：

``` bash
; .cdsinit
; 下面是 .cdsinit 配置内容 (截至 2025.08.17)
; 来源于知乎作者 https://www.zhihu.com/people/YiDingg

; None<Btn2Down> 是中键
hiSetBindKeys("Schematics" list(
    ; 下面是通用操作
    list("None<Btn4Down>" "geScroll(nil \"n\" nil)")        ; 鼠标滚轮上滑, 界面上移:
    list("None<Btn5Down>" "geScroll(nil \"s\" nil)")        ; 鼠标滚轮下滑, 界面下移:
    list("Ctrl<Btn4Down>" "hiZoomInAtMouse()")              ; Ctrl + 鼠标滚轮上滑, 放大界面:
    list("Ctrl<Btn5Down>" "hiZoomOutAtMouse()")             ; Ctrl + 鼠标滚轮下滑, 缩小界面:
    list("Ctrl<Key>Z" "hiUndo()")                           ; Ctrl + Z, 撤销:
    list("Ctrl<Key>Y" "hiRedo()")                           ; Ctrl + Y, 重做:
    list("<Key>F5" "simulate")                              ; F5 仿真
    list("<Key>space" "schSetEnv(\"rotate\" t)")            ; 空格旋转
    list("Ctrl<Key>s" "schHiCheckAndSave()")                ; Ctrl + S 检查与保存
    list("<Key>x" "schSetEnv(\"sideways\" t)")              ; x 翻转
        ; list("<Key>d" "cancelEnterFun()")                 ; d 取消, 用作 esc 的替代 (esc 太远了)
    list("None<Btn3Down>" "" "cancelEnterFun()")            ; 鼠标右键用作 esc (esc 太远了)
    list("None<Btn3Down>(2)" "" "")                         ; 删除原有的冗余右键绑定
    list("Ctrl<Key>c" "schHiCopy()")                        ; Ctrl + C 复制
    list("<Key>d" "schHiDelete()")                          ; 按键 D 用于删除 (delete 按键太远了)
    list("Ctrl Shift<Key>f" "leZoomToSelSet()")                   ; Ctrl Shift + f 缩放到选中区域
    ; 下面是特殊操作
    list("<Key>a" "schHiCreateInst()")                      ; 按键 A 添加 instance (默认功能是 geSingleSelectPoint()), 用于替代按键 I
    list("Ctrl<Key>1" "AnnotationSlider->annDCOpPoint->checked=t") ; 在 schematic 中标出器件的 operation points
    list("Ctrl<Key>2" "AnnotationSlider->annparameter->checked=t") ; 在 schematic 中标出器件的尺寸信息
    list("Ctrl<Key>3" "AnnotationSlider->annmodel->checked=t")     ; 在 schematic 中标出器件的模型信息 (例如阈值电压 vto)
    list("Ctrl<Key>4" "AnnotationSlider->annDCVoltage->checked=t") ; 在 schematic 中标出 dc voltages
        ; list("<Key>g" "schHiCreatePin(\"GND\" \"input\" \"schematic\" \"full\" nil nil nil \"roman\")")       ; 按键 G 创建 GND pin, 默认是 schHiFindMarker()
    list("<Key>g" "schHiCreateInst(\"analogLib\" \"gnd\" \"symbol\")")                                      ; 按键 G 创建 gnd
    list("<Key>v" "schHiCreateInst(\"analogLib\" \"vdc\" \"symbol\")")                                      ; 按键 v 创建 dc source
    list("<Key>r"  "schHiCreateInst(\"analogLib\" \"res\" \"symbol\")")                                     ; 按键 R 创建理想电阻
    list("<Key>c"  "schHiCreateInst(\"analogLib\" \"cap\" \"symbol\")")                                     ; 按键 C 创建理想电容 (默认是复制 schHiCopy())
        ; list("Ctrl<Key>1" "sevAnnotateResults('sevSession1 'dcOpPoints)")                                     ; 在 schematic 中标出器件的 operation points
        ; list("Ctrl<Key>2" "sevAnnotateResults('sevSession1 'componentParameters)")                            ; 在 schematic 中标出器件的尺寸信息
        ; list("Ctrl<Key>3" "sevAnnotateResults('sevSession1 'modelParameters)")                                ; 在 schematic 中标出器件的模型信息 (例如阈值电压 vto)
        ; list("Ctrl<Key>4" "sevAnnotateResults('sevSession1 'dcNodeVoltages)")                                 ; 在 schematic 中标出 dc voltages
	)
)

hiSetBindKeys("Symbol" list(
    ; 下面是通用操作
    list("None<Btn4Down>" "geScroll(nil \"n\" nil)")    ; 鼠标滚轮上滑, 界面上移:
    list("None<Btn5Down>" "geScroll(nil \"s\" nil)")    ; 鼠标滚轮下滑, 界面下移:
    list("Ctrl<Btn4Down>" "hiZoomInAtMouse()")          ; Ctrl + 鼠标滚轮上滑, 放大界面:
    list("Ctrl<Btn5Down>" "hiZoomOutAtMouse()")         ; Ctrl + 鼠标滚轮下滑, 缩小界面:
    list("Ctrl<Key>Z" "hiUndo()")                       ; Ctrl + Z, 撤销:
    list("Ctrl<Key>Y" "hiRedo()")                       ; Ctrl + Y, 重做:
    list("<Key>space" "schSetEnv(\"rotate\" t)")        ; 空格旋转
    list("Ctrl<Key>s" "schHiVICAndSave()")              ; Ctrl + S 检查与保存 (与 schematic 中的命令不同)
    list("<Key>x" "schSetEnv(\"sideways\" t)")          ; x 翻转
        ; list("<Key>d" "cancelEnterFun()")             ; d 取消, 用作 esc 的替代 (esc 太远了)
        ; None<Btn2Down> 是中键 
    list("None<Btn3Down>" "" "cancelEnterFun()")        ; 鼠标右键用作 esc (esc 太远了)
    list("None<Btn3Down>(2)" "" "")                     ; 删除原有的冗余右键绑定
    list("Ctrl<Key>c" "schHiCopy()")                    ; Ctrl + C 复制
    list("Ctrl Shift<Key>f" "leZoomToSelSet()")              ; Ctrl Shift + f 缩放到选中区域
    ; 下面是特殊操作
    list("<Key>d" "schHiDelete()")                          ; 按键 D 用于删除 (delete 按键太远了)
	)
)

hiSetBindKeys("Layout" list(
    ; 下面是通用操作
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
    list("Ctrl Shift<Key>f" "leZoomToSelSet()")                      ; Ctrl Shift + f 缩放到选中区域
    ; 下面是特殊操作
    list("<Key>w" "leAlign(\"top\")")                           ; 按键 W 按照 top 进行 align
    list("Ctrl<Key>w" "leAlign(\"bottom\")")                    ; 按键 Ctrl + W 按照 bottom 进行 align
    list("<Key>c" "leAlign(\"vertical\")")                      ; 按键 C 按照 vertical (center) 进行 align
    list("<Key>a" "leAlign(\"left\")")                          ; 按键 A 按照 left 进行 align
    list("<Key>d" "leAlign(\"right\")")                         ; 按键 D 按照 right 进行 align
    list("<Key>g" "_leCreateQuickFigGroup(getCurrentWindow())") ; 按键 G 进行 group
    list("Shift<Key>g" "leHiUngroup()")                         ; Shift + G 进行 ungroup
    list("Ctrl<Key>g" "leHiCreateGuardRing()")                  ; Ctrl + G 以创建 guard ring
    list("<Key>m" "_weHiInteractiveRouting()")                  ; 按键 m 进行交互式布线 (默认按键是 p)
    list("<Key>s" "leHiQuickAlign()")                           ; 按键 s 进行快速对齐 (边界对齐), 默认是 leHiStretch()
    list("Shift<Key>s" "leHiStretch()")                         ; Shift + s 进行拉伸
	)
)

; 设置 label, text, ciw 的字体和字号, 如果 "roman" 不起作用改为 "times" 即可
hiSetFont( "ciw" ?name "mono" ?size 18 ?bold nil ?italic nil ) ; "mono" 即为 "monospace"
hiSetFont( "label" ?name  "Open Sans" ?size 14 ?bold nil ?italic nil ) ; "label" 既是 toolbar 的字体, 也是打开某些设置界面的字体, 因此 "label" 字号不宜过大, 否则会导致表单文字重叠
hiSetFont( "text" ?size 15 ?bold nil ?italic nil ) ; text 是各表单内部白色背景里的文字

; 设置 log filter 的默认输出
; hiSetFilter() ; 此命令是打开 log filter 窗口
hiSetFilterForm->accelInput->value= t   ; 将默认不输出的值全部勾选为输出
; hiSetFilterForm->accelRetval->value= t ; 这个没啥必要
hiSetFilterForm->promptOutput->value= t ; 
_hiFormApplyCB(hiSetFilterForm)     ; 应用已修改的 log filter 结构体


; 将 Calibre 集成到 Cadence Virtuoso 工具栏
skillPath=getSkillPath();
setSkillPath(append(skillPath list("/opt/eda/mentor/calibre2019/aoj_cal_2019.3_15.11/lib"))); the installing path of your Calibre
load("calibre.OA.skl");

; 其它设置
; editor="gedit" ; 设置 Cadence 中默认文本编辑器为 gedit (script 和 verilog-A 的编辑器), 可选的通常有 vim, gedit, emacs, atom
ExportImageDialog->fileName->value = "/home/IC/a_Win_VM_shared/a_Misc/schematic.png" ; 设置 schematic 导出为 image 时的默认路径
dbSetAutoSave(t 20) ; 设置自动保存时间, 单位是 second (秒), 但是这行好像没有什么作用
hiResizeWindow(window(1) list(400:0 1800:1000)) ; 设置初始 CIW 窗口的大小和位置, 其中 400:150 代表窗口左下角坐标，1200:600 代表窗口右上角坐标
schViewMenu->NetHighlights->checked=t ; 打开 shcematic 界面的 net highlight (鼠标放上去就会高亮对应网络)
geNetNameDisplayOptionForm->drawOnTop->value= t ; layout pin names: draw on top
geNetNameDisplayOptionForm->userColor->value= list(ptrnum@0x55f25f30 106 26 "yellow") ; layout pin name color: pink
```





<!-- hiSetBindKeys(
    list("&Hierarchy Editor" "ADE Assembler" "ADE Explorer" "ADE State" "BBTEditor"
        "Command Interpreter" "Concurrent Layout" "Debug Abutment" "Debug CDF" "Diva"
        "Dracula Interactive" "EAD" "Graphics Browser" "Hman-Schematic" "Innovus"
        "Layout" "   PcellIDE Layout" "   VLS-GXL" "   Virtuoso XL" "   adegxl-maskLayout"
        "   adexl-maskLayout" "   assembler-maskLayout" "   explorer-maskLayout" "ModelWriter" "NC-Test-HDL"
        "NC-Verilog" "Other" "Palette" "Pcell" "Read HDL"
        "Read spectre" "Read veriloga" "SDR" "SMG" "SMGIpInfoEditor"
        "Sche-Migrate" "Schematic Test Generator (STG)" "Schematics" "   PcellIDE Schematic" "   Power Manager"
        "   Schematics XL" "   adegxl-schematic" "   adexl-schematic" "   assembler-schematic" "   explorer-schematic"
        "Show File" "SkillIDE" "   TechfileIDE" "Spectre-Plugin" "Symbol"
        "   PcellIDE Symbol" "   Symbol XL" "Text" "Text Editor" "UltraSim-Plugin"
        "VHDL" "VHDL Toolbox" "VHDLAMS" "VLS-CPH-Editor" "VLS-EAD"
        "Verilog-AMS" "Virtuoso ADE Verifier" "adegxl" "adexl" "amsArtist-Schematic"
        "amsCreateConfigArtist-Schematic" "amsDmv" "analogArtist-Layout" "analogArtist-MaskLayout" "analogArtist-Schematic"
        "analogArtist-Simulation" "assembler" "encap" "explorer" "maskLayoutVFIL"
        "maskLayoutVPS" "maskLayoutVSA" "ncSystemVerilog" "parasitics-MaskLayout" "parasitics-Schematic"
        "systemVerilog" "systemVerilogPackage" "vivaBrowser" "vivaCalculator" "vivaGraph"
    )
    list(
        list("None<Btn4Down>" "geScroll(nil \"n\" nil)")            ; , :
        list("None<Btn5Down>" "geScroll(nil \"s\" nil)")            ; , :
        list("Ctrl<Btn4Down>" "hiZoomInAtMouse()")                  ; Ctrl + , :
        list("Ctrl<Btn5Down>" "hiZoomOutAtMouse()")                 ; Ctrl + , :
        list("Ctrl<Key>Z" "hiUndo()")                               ; Ctrl + Z, :
        list("Ctrl<Key>Y" "hiRedo()")                               ; Ctrl + Y, :
	)
) -->











也可以在 `.cdsinit` 文件中用 SKILL 语言修改上面的环境变量，语法为：

``` bash
envSetVal(list(
    list("auCore.misc" "labelDigits" 'int 6)
    list("schematic" "createLabelFontStyle" 'cyclic "roman")
    list("layout" "labelFontStyle" 'cyclic "roman")
    list("viva.graphFrame" "background" 'string "white")
	)
)

envSetVal("schematic" "createLabelFontStyle" 'cyclic "roman")
```

当然，我们也可以通过修改 `display.drf` 文件来改变某些颜色、线条设置，这里不多赘述。


可选的字体种类 fontfamily 汇总 (大小写不能错):
``` bash
"roman", "monospace", "stick", "Helvetica" "Open Sans"
```

可选的 .cdsinit 文件代码：

``` bash
envSetVal("asimenv.startup" "simulator" 'string "THE NAME FOR THE SIMULATOR YOU WANT AT START UP OF CADENCE VIRTUOSO")
envSetVal("asimenv.startup" "projectDir" 'string "PATH YOU WANT TO SAVE SIMULATION RESULTS")
envSetVal("layout" "xSnapSpacing" 'float 0.05)
envSetVal(“adexl.distribute” “defaultRunInParallel” 'boolean t) 
```











### 3. Command Definitions

再次强调参考资料 [Virtuoso® Schematic Editor SKILL Functions Reference](<https://picture.iczhiku.com/resource/eetop/sykRGZGTDTSiYmCv.pdf>)

以下是 cadence 中部分常用 commands 的定义和用法：

- `schHiCreatePin`

``` bash
schHiCreatePin(
    [ t_terminalName ]
    [ t_direction ]
    [ t_usage ]
    [ t_interpret ] member, full (default)
    [ t_mode ]      array, single (default)
    [ t_netExpr ]
    [ t_justify ]
    [ t_fontStyle ]
    [ n_fontHeight ]
    )
schHiCreatePin("GND" "input" "schematic" "full" nil nil nil "roman")
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-01-44-41_How to Use Cadence Efficiently.png"/></div>


- ` schHiCreateInst`

``` bash
 schHiCreateInst(
 [ t_libraryName ]
 [ t_cellName ]
 [ t_viewName ]
 [ t_instanceName ]
 [ x_rows ]
 [ x_columns ]
 )
schHiCreateInst("analogLib" "res" "symbol")
schHiCreateInst("analogLib" "cap" "symbol")
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-02-01-14_How to Use Cadence Efficiently.png"/></div>














### 4. Shared Folders

要想在主机 (windows) 和虚拟机之间互传文件，最简单的方法就是在原机和虚拟机之间建立一个共享文件夹。具体步骤如下：

- 在虚拟机主页面打开 `设置 > 选项 > 共享文件夹`, 选择 `总是启用`
- 点击 `添加`，自动进入共享文件夹向导页面

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-12-23-16_How to Use Cadence Efficiently.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-12-24-17_How to Use Cadence Efficiently.png"/></div>


- 填入合适的主机路径，或者点击 `浏览` 选择需要共享的文件夹，`名称`即为此文件夹在虚拟机显示的名称，建议与文件夹名称相同。例如，我们共享 `D:\Test_Folder`，如图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-12-30-04_How to Use Cadence Efficiently.png"/></div>

- 点击 `下一步`，点击 `完成`，完成设置
- 现在，共享文件夹已经创建完成，我们还需要在虚拟机中“挂载”才能找到这个文件夹
- 在虚拟机中，右键打开终端，先进入 root 模式：

```bash
su - root   # 切换到 root 用户 (需要输入密码)
```

- 输入以下命令创建并挂载共享文件夹 (假设共享文件夹名称为 `Test_Folder`，虚拟机中挂载点为 `/home/IC/Test_Folder`):

```bash
sudo mkdir -p /home/IC/Test_Folder
sudo mount -t fuse.vmhgfs-fuse .host:/Test_Folder  /home/IC/Test_Folder -o allow_other
```

- `-o allow_other` 表示普通用户也能访问共享目录。挂载成功后，即可在 `/home/IC/Test_Folder` 目录下访问主机共享的文件夹内容。若提示找不到 `vmhgfs-fuse`，请先安装：

```bash
sudo apt update
sudo apt install open-vm-tools open-vm-tools-desktop
```

- 这样，共享文件夹就创建完成了。例如，我们将主机的某个文件放入共享文件夹，便可以从虚拟机中访问到这个文件：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-13-07-35_How to Use Cadence Efficiently.png"/></div>

- 另外，我们还可以继续创建多个共享文件夹（只需重复上述步骤），共享文件夹不会额外占用存储空间，不必担心硬盘空间不足。
- 代码汇总如下：

```bash
su - root   # 切换到 root 用户 (需要输入密码)

sudo mkdir -p /home/IC/Test_Folder  # 创建 Test_Folder, 用于挂载主机的 Test_Folder 文件夹
sudo mount -t fuse.vmhgfs-fuse .host:/Test_Folder  /home/IC/Test_Folder -o allow_other  # 挂载主机的 Test_Folder 文件夹

sudo mkdir -p /home/IC/a_Win_VM_shared  # 创建 a_Win_VM_shared, 用于挂载主机的 a_Win_VM_shared 文件夹
sudo mount -t fuse.vmhgfs-fuse .host:/a_Win_VM_shared  /home/IC/a_Win_VM_shared -o allow_other  # 挂载主机的 a_Win_VM_shared 文件夹

vmware-hgfsclient # 查看当前虚拟机的共享文件夹 (有无挂载都会显示)
```

- 注意：到这个时候，共享文件夹的挂载仍是一次性的，重启虚拟机后需要重新挂载。为解决这个问题，我们在虚拟机的 `/etc/fstab` 文件中添加一行 `.host:/a_Win_VM_shared /home/IC/a_Win_VM_shared fuse.vmhgfs-fuse allow_other,defaults 0 0`。但 `/etc/fstab` 通常是只读的，我们需要在 bash 中使用管理员权限编辑它：

```bash 
tail -n 5 /etc/fstab  # 查看文件末尾 5 行内容
printf '.host:/a_Win_VM_shared /home/IC/a_Win_VM_shared fuse.vmhgfs-fuse allow_other,defaults 0 0\n' | sudo tee -a /etc/fstab   # 将共享文件夹挂载信息添加到 /etc/fstab 文件末尾, 以实现重启后自动挂载
tail -n 5 /etc/fstab  # 再次查看文件末尾 5 行内容, 检查是否添加成功
```

如果想像 windows 的文本编辑器一样编辑 `/etc/fstab` 文件，可以使用 `gedit` 编辑器打开文件：

``` bash
# 使用 gedit 编辑器打开 /etc/fstab 文件
sudo gedit /etc/fstab
```

修改完成后，`ctrl+s` 保存即可。



### 5. Add Process Library

详见文章 [How to Add New Process Libraries in Cadence IC618](<AnalogIC/Virtuoso Tutorials - 3. How to Add New Process Libraries in Cadence IC618.md>).


### 6. Screenshot Path

- 修改 screenshot path: 虚拟机界面找到 `Edit > Preferences > Workspace`, 然后修改路径  (参考 [Configuring the Default Locations for Virtual Machine Files and Screenshots](https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors/workstation-pro/17-0/using-vmware-workstation-pro/changing-workstation-pro-preference-settings/configuring-workspace-preference-settings/configuring-the-default-locations-for-virtual-machine-files-and-screenshots.html))
- 修改 screenshot keybindings: 虚拟机界面 `Applications > System Tools > Settings > Devices > Keyboard`, 然后搜索 `screenshot`, 进行修改即可

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-23-14-50-28_How to Use Cadence Efficiently.png"/></div>














## Simulation Tips


### 0. Simulation Examples

- [Simulate CMOS Inverter in Cadence IC618 (Virtuoso)](<AnalogIC/Virtuoso Tutorials - 2. Simulate CMOS Inverter in Cadence IC618 (Virtuoso).md>)
- [Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso)](<AnalogIC/Virtuoso Tutorials - 4. Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).md>)


### 1. annotate self_gain

如何在 schematic 上直接标出器件的直流工作点，包括 self_gain, r_out 等？只需在 `schematic > view > annotations > setup` 中进行调整，效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-01-02-44_How to Use Cadence Efficiently.png"/></div>

对于 `tsmc18rf` 工艺库，经过摸索，也可以先点击 schematic 界面，使主窗口定位于此，然后在 CIW 窗口中输入下面代码：

``` bash
; 快速设置 schematic 界面上的 dc annotation, 标出器件的 region, id, self_gain 等参数

name_processLibrary = "tsmcN28"; 设置工艺库名称
name_nmos = "nch_mac" ; 设置 NMOS 器件名称
name_pmos = "pch_mac" ; 设置 PMOS 器件名称
schSingleSelectPt()
asaEditCompDisplay()

; 下面是 nmos
_annInstanceChanged(annotationSetupForm->annNativeWidget name_processLibrary "*" "*")
_annInstanceChanged(annotationSetupForm->annNativeWidget name_processLibrary name_nmos "*")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (4 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 4 3 "region")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (5 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 5 3 "id")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (6 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 6 3 "gm/(2*3.1415926*cgg)")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (7 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 7 3 "vdsat")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (8 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 8 3 "gm/gds")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (9 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 9 3 "1/gds")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (10 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 10 3 "gm")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (11 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 11 3 "gm/id")

; 应用上面的设置
_annApplyAndRedraw(hiGetCurrentWindow())

; 下面是 pmos
_annInstanceChanged(annotationSetupForm->annNativeWidget name_processLibrary "*" "*")
_annInstanceChanged(annotationSetupForm->annNativeWidget name_processLibrary name_pmos "*")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (4 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 4 3 "region")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (5 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 5 3 "id")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (6 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 6 3 "gm/(2*3.1415926*cgg)")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (7 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 7 3 "vdsat")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (8 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 8 3 "gm/gds")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (9 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 9 3 "1/gds")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (10 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 10 3 "gm")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (11 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 11 3 "gm/id")
; 应用上面的设置
_annApplyAndRedraw(hiGetCurrentWindow())
_annOKFormCB(hiGetCurrentWindow())

; 选中并关闭提示窗
hiiSetCurrentForm('notifyStarLevelSettingsNotAppliedToAll)
notifyStarLevelSettingsNotAppliedToAll->dontShowStarLevelSettingsWarning->value= t
notifyStarLevelSettingsNotAppliedToAll->applyStarLevelSettingsToAll->value= t
hiFormDone(notifyStarLevelSettingsNotAppliedToAll)
```











类似地，对于 `tsmcN28` 工艺库，代码如下：

``` bash
; 快速设置 schematic 界面上的 dc annotation, 标出器件的 region, id, self_gain 等参数

name_processLibrary = "tsmcN28"; 
name_nmos = "nch_mac" ;  NMOS 
name_pmos = "pch_mac" ;  PMOS 
schSingleSelectPt()
asaEditCompDisplay()

;  nmos
_annInstanceChanged(annotationSetupForm->annNativeWidget name_processLibrary "*" "*")
_annInstanceChanged(annotationSetupForm->annNativeWidget name_processLibrary name_nmos "*")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (4 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 4 3 "region")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (5 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 5 3 "id")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (6 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 6 3 "gm/(2*3.14*cgg)")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (7 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 7 3 "vdsat")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (8 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 8 3 "gm/gds")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (9 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 9 3 "1/gds")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (10 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 10 3 "gm")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (11 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 11 3 "gm/id")

; 
_annApplyAndRedraw(hiGetCurrentWindow())

;  pmos
_annInstanceChanged(annotationSetupForm->annNativeWidget name_processLibrary "*" "*")
_annInstanceChanged(annotationSetupForm->annNativeWidget name_processLibrary name_pmos "*")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (4 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 4 3 "region")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (5 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 5 3 "(-id)")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (6 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 6 3 "gm/(2*3.14*cgg)")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (7 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 7 3 "(-vdsat)")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (8 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 8 3 "gm/gds")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (9 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 9 3 "1/gds")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (10 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 10 3 "gm")
_annSelectItem(annotationSetupForm->annNativeWidget "'(  (11 3)  )")
_annSetData(annotationSetupForm->annNativeWidget 11 3 "gm/(-id)")
; 
_annApplyAndRedraw(hiGetCurrentWindow())
_annOKFormCB(hiGetCurrentWindow())

; 
hiiSetCurrentForm('notifyStarLevelSettingsNotAppliedToAll)
notifyStarLevelSettingsNotAppliedToAll->dontShowStarLevelSettingsWarning->value= t
notifyStarLevelSettingsNotAppliedToAll->applyStarLevelSettingsToAll->value= t
hiFormDone(notifyStarLevelSettingsNotAppliedToAll)
```

### 2. output GBW and PM

参考 [知乎 > AC 仿真中直接打印 GBW 和 PM 的设置方法【cadence使用】](https://zhuanlan.zhihu.com/p/681899170)




### 3. save simulation data

在 `ADE L` 中，我们常常希望在仿真完成后保存相关仿真数据 (在软件中称为 results) ，以便后续重新查看或分析。但是，常规的 `ADE L > Save State` 只能保存当前仿真状态下的各项设置 (只能保存 state) ，而无法保存仿真数据本身。而仿真数据默认存放在了 `<current_schematic>/spectre/schematic` 目录下，一旦我们运行新的仿真，之前的仿真数据就会被覆盖，无法再被查看。例如我的一个仿真数据就默认保存在了 `/home/IC/simulation/gmId_nmos2v/spectre/schematic`.

虽然其它的仿真器可能会自动保存的历史仿真记录 (包括了 state 和 results)，但历史记录也是有上限的，超过上限后会被自动删除，调整上限又太浪费硬盘空间。

因此，我们的解决方案是：在仿真运行完成后，手动点击 `ADE L > Results > Save` 保存此次 results. 这样，下次在需要查看某一次的仿真数据时，我们只需在 `ADE L > Results > Select` 中选择之前保存的 results 即可。 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-11-20-17-05_How to Use Cadence Efficiently.png"/></div>

需要注意的是，在保存所需数据前, 必须勾选 "output" 一栏中各数据的 `save` 选项，未勾选 `save` 的数据不会被保存。如果全部数据都没有勾选，那么 `Save Results` 操作将完全无效。


### 4. output the cur/vol inside the symbol


以运放为例，在打开了只有运放 symbol 的 schematic 中，对着运放 `shift + e` 可以打开其运放内部的原理图，然后 `Calculator > It` 点击刚刚打开的运放原理图，即可进行选择，将晶体管级的信息加入到 output 栏。


### 5. accelerate the simulation speed

如何加快仿真速度？ ADE L 和 ADE XL 都有相应的设置可以调节。

对于 ADE L, xxx...


对于 ADE XL, 一种方法是 `ADE XL > Data View > 双击 "Tests" 下方的 cellview name > Setup > High-Performance Simulation > APS > Processor affinity` 修改“处理器亲和度”；另一种方法是多个仿真并行 (同时进行)，点击 `ADE XL > Option > Job Setup > Max Jobs` 修改最大并行仿真数量，然后 点击 `ADE XL > Option > Run Options > Parallel`

### 6. more schematics in one cellview

很多时候，为了测试一个已经搭建好的模块 (例如 op amp) ，我们需要多种不同的外围仿真电路来测试它的性能。此时，我们可以在同一个 cellview 中添加多个 schematic, 而不需要新建多个 cellview. 类似地，如果一个模块在不同的测试环境下会有所改动，那么我们也可以在同一个 cellview 中添加多个 schematic, 以便于测试。

## Other Tips and Tricks

### 0. CIW Coding Tips

下面是一些 CIW 界面的使用命令 (SKILL 语言):

``` bash
startFinde(); 打开 "Cadence SKILL API Finder", 用于查找函数及其定义
```


### 1. Export Schematic Img

参考资料：
- [How to take a screen capture for complete schematic view in batch mode](https://community.cadence.com/cadence_technology_forums/f/custom-ic-skill/53283/how-to-take-a-screen-capture-for-complete-schematic-view-in-batch-mode-because-i-have-many-schematic-views-need-do-it)

在 schematic 界面打开后，我们可以运行下面的代码以快速导出 image:

``` bash
; 以原样式导出 (已测试过无问题)
    hiExportImageDialog(getCurrentWindow()) ; 打开 export image 窗口
    ExportImageDialog->fileName->value = "/home/IC/a_Win_VM_shared/a_Misc/schematic.png" ; 设置导出为 image 时的路径
    ExportImageDialog->entireDesign->value = t ; 设置导出整个 schematic
    ExportImageDialog->save->value = t  ; 执行导出操作
    ExportImageDialog->close->value = t ; 关闭 export image 窗口
```


``` bash
; 以白底黑线导出, 带 dotting (已测试过无问题)
    hiExportImageDialog(getCurrentWindow()) ; 打开 export image 窗口
    ExportImageDialog->fileName->value = "/home/IC/a_Win_VM_shared/a_Misc/schematic.png" ; 设置导出为 image 时的路径
    ExportImageDialog->entireDesign->value = t ; 设置导出整个 schematic
    ExportImageDialog->biColor->value = t ; 设置颜色样式为 bi-color
    ExportImageDialog->swapFgBgColors->value = nil ; 先重置 swap 选项 (因为重新 open 一个 schematic, 新 sch 的 value 没有被重置, 仍是 t, 本质是设置为 nil 或 t 时才会触发相关动作)
    ExportImageDialog->swapFgBgColors->value = t ; 再开启 swap
    ExportImageDialog->save->value = t  ; 执行导出操作
    ExportImageDialog->close->value = t ; 关闭 export image 窗口
```

``` bash
; 以白底黑线导出, 不带 dotting (已测试过无问题)
    ; 先修改 dotting, 导出后再修改回来
    schHiDisplayOptions() ; 打开 schematic display options 窗口
    schDisplayOptionsForm->gridType->value="none" ; 设置网格类型为 none
    _hiFormApplyCB(schDisplayOptionsForm) ; 应用已修改的 display options 结构体
    hiFormDone(schDisplayOptionsForm) ; 关闭 schDisplayOptionsForm
    ; 以白底黑线导出
    hiExportImageDialog(getCurrentWindow()) ; 打开 export image 窗口
    ExportImageDialog->fileName->value = "/home/IC/a_Win_VM_shared/a_Misc/schematic.png" ; 设置导出为 image 时的路径
    ExportImageDialog->entireDesign->value = t ; 设置导出整个 schematic
    ExportImageDialog->biColor->value = t ; 设置颜色样式为 bi-color
    ExportImageDialog->swapFgBgColors->value = nil ; 先重置 swap 选项 (因为重新 open 一个 schematic, 新 sch 的 value 没有被重置, 仍是 t, 本质是设置为 nil 或 t 时才会触发相关动作)
    ExportImageDialog->swapFgBgColors->value = t ; 再开启 swap
    ExportImageDialog->save->value = t  ; 执行导出操作
    ExportImageDialog->close->value = t ; 关闭 export image 窗口
    ; 恢复 dotting 设置
    schHiDisplayOptions() ; 打开 schematic display options 窗口
    schDisplayOptionsForm->gridType->value="dotted" ; 恢复网格类型为 dotted
    _hiFormApplyCB(schDisplayOptionsForm) ; 应用已修改的 display options 结构体
    hiFormCancel(schDisplayOptionsForm) ; 关闭 schematic display options 窗口
    hiFormDone(schDisplayOptionsForm) ; 关闭 schDisplayOptionsForm
```

但是，要如何实现打开 schematic 前就设置好默认导出路径，并且可以自定义导出的颜色？我们尝试了几个小时，仍未找到解决方案，只能作罢。


### 2. Export Simulation PDF



经过测试, print 窗口为函数 `_ddtExecuteAction(awvGetCurrentWindow()->vivaSession "graphPrint")` 的内部进程，无法通过代码快速设置、调用。

### 3. Export Simulation Data


详见 [Design of Op Amp using gm-Id Methodology Assisted by MATLAB](<AnalogIC/Design of Op Amp using gm-Id Methodology Assisted by MATLAB.md>).

示例代码如下：
``` bash
; 2025.05.29: cadence virtuoso 快速导出 gm-Id 仿真数据

    ; 设置数据导出路径和器件名称
        ; 完整路径例如 "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data/tsmc18rf_gmIdData_nmos2v/tsmc18rf_gmIdData_nmos2v_test.txt"
        export_path = "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data"
        export_deviceName = "tsmc18rf_gmIdData_nmos2v"
        export_fileFormat = ".txt"
    ; 创建各个数据的 filePathAndName
        path_selfGain = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_selfGain", export_fileFormat)
        path_currentDensity = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_currentDensity", export_fileFormat)
        path_transientFreq = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_transientFreq", export_fileFormat)
        path_overdrive = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_overdrive", export_fileFormat)
        path_vgs = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_vgs", export_fileFormat)
    ; 导出数据
        ocnPrint(   ; 1. 导出 self gain (gm*rO)
            ?output path_selfGain
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "self_gain"))
        )
        ocnPrint(   ; 2. 导出 current density (Id/W)
            ?output path_currentDensity
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "id") / VAR("W")))
        )
        ocnPrint(   ; 3. transient freq (gm/2*pi*((Cgs+Cgd)))
            ?output path_transientFreq
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "gm") / (2 * 3.1415926 * abs((OS("/NMOS" "cgs") + OS("/NMOS" "cgd"))))))
        )
        ocnPrint(   ; 4. 导出 minimum overdrive (Vdsat)
            ?output path_overdrive
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vdsat"))
        )
        ocnPrint(   ; 5. gate-source voltage (Vgs)
            ?output path_vgs
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vgs"))
        )
```

### 4. Decorate Lib. Directory

参考 [知乎 > 让你的 Cadence Library 更加美观](https://zhuanlan.zhihu.com/p/20739660), 文中的步骤同样适用于 Cadence IC618, 我们的调整效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-19-31-21_How to Use Cadence Efficiently.png"/></div>

### 5. Autosave Your Work

参考 [Cadence Community > autosave option in 6.1.3 version](https://community.cadence.com/cadence_technology_forums/f/custom-ic-design/14627/autosave-option-in-6-1-3-version)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-19-56-11_How to Use Cadence Efficiently.png"/></div>

``` bash
dbSetAutoSave(
    t  ; 是否开启自动保存
    20 ; 自动保存间隔时间 (unit: second)
)
```


### 6. Backup Your Files

毫无疑问，希望对虚拟机上的某些重要文件进行备份，以避免虚拟机损坏导致虚拟机内部数据丢失。一种思路就是将虚拟机的文件夹“挂载”到共享文件夹，然后在 windows 主机用“坚果云”等平台同步共享文件夹中的内容，以达到备份的效果。但是，经过我们的尝试，虚拟机中已有内容的文件夹，一旦挂载为共享，就会被 windows 主机的文件夹所“遮蔽”，就无法访问虚拟机中的文件夹内容了。

因此，我们考虑另外一种方法，定期手动将需要备份的文件夹复制到共享文件夹中，然后在 windows 主机上进行备份。例如我们想备份 cadence 的仿真数据，这些数据默认存放在 `/home/IC/simulation` 目录下，只需定期将这个目录下的内容复制到共享文件夹中。但是，如果直接复制文件夹中的内容，由于 `simulation` 文件夹中含有符号链接 "link" ，但目标文件系统 (如 VMware 共享文件夹) 不支持 Linux 符号链接，因此会报错 `cp: cannot create symbolic link 'copy_target_path': Operation not supported`。解决方案是直接将 `simulation` 打包成 `.tar` 文件，然后再复制到共享文件夹中。具体代码如下：

<!-- 
``` bash
tar -cvf simulation_backup_20250610.tar simulation/ # 将 simulation 文件夹打包成 tar 文件
mv simulation_backup_20250610.tar /home/IC/a_Win_VM_shared/Cadence_simulation_backup/   # 将 tar 文件移动到共享文件夹 a_Win_VM_shared 中
# 顺便备份一下 .cdsinit 和 .cdsenv 文件
cp /home/IC/.cdsinit /home/IC/a_Win_VM_shared/Cadence_simulation_backup/.cdsinit_backup_20250610
cp /home/IC/.cdsenv /home/IC/a_Win_VM_shared/Cadence_simulation_backup/.cdsenv_backup_20250610
```
 -->

``` bash
# tar -czvf simulation_backup_20251002.tar.gz simulation/ # 将 simulation (仿真数据) 文件夹打包成 tar 文件
tar -czvf Cadence_Projects_backup_20251002.tar.gz Cadence_Projects/ # 将 Cadence_Projects (项目文件) 文件夹打包成 tar 文件
mkdir -p /home/IC/a_Win_VM_shared/Cadence_backup # 确保备份目录存在
mkdir -p /home/IC/a_Win_VM_shared/Cadence_backup/Cadence_backup_20251002 # 创建备份文件夹
# mv simulation_backup_20251002.tar.gz /home/IC/a_Win_VM_shared/Cadence_backup/Cadence_backup_20251002/   # 将仿真数据 tar 文件移动到共享文件夹中
mv Cadence_Projects_backup_20251002.tar.gz /home/IC/a_Win_VM_shared/Cadence_backup/Cadence_backup_20251002/   # 将项目数据 tar 文件移动到共享文件夹中
cp /home/IC/.cdsinit /home/IC/a_Win_VM_shared/Cadence_backup/Cadence_backup_20251002/.cdsinit_backup_20251002 # 顺便备份一下 .cdsinit 和 .cdsenv 文件
cp /home/IC/.cdsenv /home/IC/a_Win_VM_shared/Cadence_backup/Cadence_backup_20251002/.cdsenv_backup_20251002 # 顺便备份一下 .cdsinit 和 .cdsenv 文件
# rm -r <directory>
```

这样便可以在 windows 主机上，利用坚果云对 `a_Win_VM_shared/Cadence_simulation_backup/` 文件夹进行备份。




<!-- tar -cvf tsmc28n.tar /home/library/TSMC/tsmc28n/1p9m6x1z1u_2v5/ # 将 Cadence_Projects (项目文件) 文件夹打包成 tar 文件
 -->



### 7. Multiple Workspace



Loading the Specified .cdsinit File from Another Workspace: 参考 https://wiki.to.infn.it/vlsi/workbook/analog/cdsenv

## Fix Bugs and Errors

### 1. wrong schematic colors



如果出现原理图器件一片黄的问题，大概是 attach library 时 `display.drf` 文件出现了某些错误，解决方法如下：直接将工艺库的 `display.drf` 文件复制到 virtuoso 的启动目录 `/home/IC/`，然后重启 virtuoso. 


还有一种 merge 多个 `display.drf` 文件的方法：
- `virtuoso > Tools > Display Resources Tool > Merge > OK > From Library > Browse`
- 随便选择一个工艺库的 `display.drf` 文件，例如选择 tsmc18rf 的 `/home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d_OA/display.drf`
- 点击 `Add` 将 `TSMC18RF_PDK_v13d_OA/display.drf` 添加到 Merge 栏里
- Destination DRF 一栏，点击 `Browse`，选择 virtuoso 启动目录下的 `display.drf` 文件 `/home/IC/display.drf`，这一步是让 merge 的结果覆盖掉 Destination 的 `display.drf` 文件
- 点击 `OK` 进行 merge 并覆盖


### 2. is referencing an undefined model

仿真报错：<span style='color:red'> The instance 'NMOS1' is referencing an undefined model or subcircuit, 'nch'. Either include the file containing the definition of 'nch', or define 'nch' before running the simulation. </span> 这是工艺信息文件设置错误导致的，因为一般都是默认用中芯科技 smic18 工艺库的工艺模型文件，但是台积电 tsmc18 的工艺模型与其不同 (通常每一个工艺库都有自己对应的模型文件)。

解决办法： `ADE L > Setup > Model Libraries`，添加 model file `/home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d_OA/models/spectre/cor_std_mos.scs`，然后 <span style='color:red'> 记得在 section 一栏填入 tt 表示标准等级</span>。重新运行仿真即可。

如果仍未解决，可参考 [this article](https://blog.csdn.net/coocoock/article/details/128053280)


另外，在面对一个新的工艺库时，我们通常难以猜到到底应该添加哪一个 model file. 此时可以打开 ADE XL 然后直接运行仿真, ADE XL 会根据 schematic 中的器件，自动选择所需要的 model files (及其 section). 下面是一个 tsmcN28 工艺库的例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-00-38-12_How to Use Cadence Virtuoso Efficiently.png"/></div>





### 3. Virtual machine has crashed

虚拟机卡死时，只能丢失未保存的数据，强制重启虚拟机。我尝试了多种方法，目前最快重启 cadence 的步骤是：在任务管理器中找到 `VMware Workstation VMX` 进程，右键结束任务，然后重新打开 cadence 虚拟机即可。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-14-35-08_How to Use Cadence Efficiently.png"/></div>

卡死的具体原因、如何调整设置以避免卡死、如何设置 cadence 自动保存等问题，还有待进一步探索。

一些小探索：
- 一种说法是 IC618 比 IC617 更容易卡死，一种说法是输入法导致的卡死
- [ADE-XL Simulation Lost After Cadence Crash](https://community.cadence.com/cadence_technology_forums/f/custom-ic-design/40071/ade-xl-simulation-lost-after-cadence-crash)


我们的一些测试：

<div class='center'>

| 测试条件 | 现象 | 结果一 | 结果二 |
|:-:|:-:|:-:|:-:|
 | (2025.05.25 16:21) 仅打开 virtuoso, 然后静置不动 | (2025.05.25 16:48) 查看时仍正常 <br> (2025.05.25 17:01) 查看时仍正常 | 刚打开时 (2025.05.25 16:21) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-16-24-30_How to Use Cadence Efficiently.png"/></div> | 第二次查看 (2025.05.25 17:01) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-17-04-23_How to Use Cadence Efficiently.png"/></div> |
 | 打开 virtuoso, ADE L, run simulation + plot results, 然后静置不动 | 一段时间后 (约四十分钟), 虚拟机 IC618 卡死，点击无反应 (但 VMware Workstation 正常) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-16-22-39_How to Use Cadence Efficiently.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-16-19-32_How to Use Cadence Efficiently.png"/></div> |
 |(2025.05.25 17:05) 打开 virtuoso, ADE L, run simulation + plot results, 然后静置不动 | (2025.05.25 17:28) 查看时仍正常 <br> (2025.05.25 17:50) 查看时发现已经闪退, 虚拟机 IC618 已关机, 故重新打开 <br> (2025.05.25 18:15) 正常使用突现卡死 | 刚打开时 (2025.05.25 17:05) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-17-06-27_How to Use Cadence Efficiently.png"/></div> | (2025.05.25 18:15) 卡死后虚拟机 IC618 自动关机, 未来得及记录当时的任务管理器 |
 | (2025.05.25 18:25) 尝试用我们的 `.cdsenv` 代码覆盖原 `.cdsenv` 文件的全部内容, 启动 ADE L + load state + plot 进行测试 | (2025.05.25 20:11) 查看时发现已经卡死, 19:30 左右都还正常 | (无图片) | (2025.05.25 20:11) 卡死时 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-20-11-39_How to Use Cadence Efficiently.png"/></div> |
</div>


从上面的测试结果来看，卡死的原因就出在 VMware mksSandbox 这个进程上，于是又去搜索：
- [GitHub > vmware > open-vm-tools > issue > mksSandbox error on VMware Workstation 17.0 #624](https://github.com/vmware/open-vm-tools/issues/624), 表示这就是 VMware Workstation 的 bug, 
- [知乎: 电脑打开 VMware 虚拟机出现 VMware workstation 不可恢复错误 mks 的原因及解决方法](https://zhuanlan.zhihu.com/p/589135132), 给出了一种解决方法是关闭虚拟机设置中的 `加速 3D 图形`, 主机不支持 3D 支持的话，开启此项会导致错误；于是继续进行我们的测试：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-20-24-00_How to Use Cadence Efficiently.png"/></div>

<div class='center'>

| 测试条件 | 现象 | 结果一 | 结果二 |
|:-:|:-:|:-:|:-:|
 | (2025.05.25 20:23) 用我们的 `.cdsenv` 代码覆盖原 `.cdsenv` 文件的全部内容, 启动 ADE L + load state + plot 进行测试 |  | (2025.05.25 20:11) 刚开始测试时，可以看到 `VMware mksSandbox` 进程已经不存在，是否还会出现卡死的问题呢？ <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-20-27-58_How to Use Cadence Efficiently.png"/></div> | (2025.05.25 22:50) 查看时发现已经卡死 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-22-50-20_How to Use Cadence Efficiently.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-22-52-19_How to Use Cadence Efficiently.png"/></div> |
</div>

于是又继续尝试下面的方法：
- [VMware 不可恢复错误 mks 解决方案](https://blog.csdn.net/Dark_Volcano/article/details/128658228)
- [VMware Workstation 17 出現 mks ISBRendererComm: Lost connection to mksSandbox 該怎麼辦?](https://wordpress.cine.idv.tw/index.php/2022/11/20/vmware-workstation-17-hangs-with-isbrenderercomm-lost-connection-to-mkssandboxvmware-error/)
- [VMware Workstation 虚拟机性能调优](https://www.yongz.fun/posts/516e2ab0.html)

于是，我们又作了如下修改：

``` .vmx
mks.sandbox.socketTimeoutMS = "200000"
mks.dx12.vendorID = "4318"
```


<div class='center'>

| 修改 `.vmx` 文件 (并重新打开 3D 加速) | 给予管理员权限 | 其它修改 |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-23-18-14_How to Use Cadence Efficiently.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-23-18-50_How to Use Cadence Efficiently.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-23-19-21_How to Use Cadence Efficiently.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-23-19-17_How to Use Cadence Efficiently.png"/></div> |
</div>

问题有没有被解决呢？测试结果如下：

<div class='center'>

| 测试条件 | 现象 | 结果一 | 结果二 |
|:-:|:-:|:-:|:-:|
 | (2025.05.25 23:21) 按上面的条件进行测试 | 进入虚拟机和打开 virtuoso 软件的速度明显变快 | (2025.05.25 23:22) 刚开始测试时的进程如下 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-23-24-40_How to Use Cadence Efficiently.png"/></div> | (2025.05.26 01:25) 查看时仍正常工作 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-01-28-30_How to Use Cadence Efficiently.png"/></div>|
 | (2025.05.26 17:57) 按上面的条件进行第二次测试，边设计 [F-OTA](<AnalogIC/Virtuoso Tutorials - 6. Design Example of F-OTA using Gm-Id Method.md>) 边测试 | (无) | (2025.05.26 17:58) 刚开始测试时的进程如下 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-18-00-26_How to Use Cadence Efficiently.png"/></div> | (2025.05.26 19:25) 出现卡死现象  |
</div>

于是又加长上面代码中的 timeout 时间：

``` .vmx
mks.sandbox.socketTimeoutMS = "200000000"
mks.dx12.vendorID = "4318"
```

<div class='center'>

| 测试条件 | 结果 |
|:-:|:-:|
 | (2025.05.26 19:29) 按上面的条件进行第三次测试，静置不动 | (2025.05.26 20:34) 查看时发现已经卡死 |
</div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-01-27-47_How to Use Cadence Efficiently.png"/></div> -->

于是又继续调整设置，先在 `.vmx` 文件中添加以下代码 (来自 [GitHub](https://github.com/vmware/open-vm-tools/issues/624#issuecomment-2224017940)):

``` bash
svga.allowAsyncReadback = "FALSE"
virtualHW.version = "17"
```

然后参考链接 [win11 系统下的 VMware 优化: 输入延迟、卡顿，大小核调度](https://blog.csdn.net/ArthurCai/article/details/130068796) 关闭内存完整性、关闭 hyper-v 和 windows 沙盒的相关服务、调整 `mksSandbox` 进程的 CPU 核心，具体情况如下：

<div class='center'>

| 修改 `.vmx` 文件 | 关闭内存完整性| 关闭 hyper-v 和 windows 沙盒的相关服务 | 调整 `mksSandbox` 进程的 CPU 核心 | 调整 `vmware-vmx` 进程的 CPU 核心 |
|:-:|:-:|:-:|:-:|:-:|
 | 修改一行代码、添加一行代码 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-21-02-17_How to Use Cadence Efficiently.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-21-01-38_How to Use Cadence Efficiently.png"/></div> | 我们暂时没有关闭这一项  | 我们没找到相关服务, 所以没有作出调整 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-20-59-22_How to Use Cadence Efficiently.png"/></div> | 在 [bitsum](https://bitsum.com/) 下载 Process Lasso 并打开; 搜索 vmw, 右键 `mksSandbox`, 打开 `触发 性能模式`, 打开 `更多 > 保持运行 (自动重启)`; 然后设置 CPU, 点击 `CPU 亲和性 > 总是 > 选择 CPU 亲和性 > 选择与虚拟机处理器个数相同的大核 (带 E 的是小核)`, 同理设置 `CPU 集合 > 总是` (我们给 `CPU 亲和性` 和 `CPU 集合` 选择的是 CPU0 ~ CPU7) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-21-12-48_How to Use Cadence Efficiently.png"/></div>  | 与 `mksSandbox` 进程同理，进行调整  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-21-15-53_How to Use Cadence Efficiently.png"/></div> |
</div>

然后打开 virtuoso 进行测试：

<div class='center'>

| 测试条件 | 结果 |
|:-:|:-:|
 | (2025.05.26 21:18) 按上面的条件进行第四次测试，静置不动 (使用时感觉明显变卡, 经过尝试, 是 CPU 过少导致的) | (2025.05.27 02:06) 我们一直使用到第二天得到 02:06, 并没有出现任何卡死现象，问题终于得到解决！！ |
</div>

2025.05.27 22:07 记录：今天又出现了卡死现象，仅打开虚拟机，在桌面挂机也会死机，唉 ε(´ο｀*)))。于是又尝试关闭了内存完整性，重启电脑进行测试：

| 测试条件 | 结果 |
|:-:|:-:|
 | (2025.05.27 22:09) 关闭内存完整性，在 process lasso 中将 `mksSandbox` 和 `vmware-vmx` 从智能内存整理中排除，修改 IO 优先级为 `高`，`更多 > 停用空闲节能`；然后打开 virtuoso 进行挂机 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-22-12-33_How to Use Cadence Efficiently.png"/></div> | (2025.05.28 02:11) 查看时发现没有卡死，虚拟机正常运行，好像确实是解决了！ |

- 2025.05.29 12:15 记录: 未更改任何设置，又卡死了。
- 2025.05.30 01:36 记录：从 (2025.05.29 12:15) 重启虚拟机过后，一直用到现在（约 13 个小时），没有再出现卡死现象，看来是之前的设置确实有用。
- 2025.06.04 17:27 记录：这个卡死不卡死是真的玄学，昨天用了一整天，没卡死，今天四个小时已经卡死三次了
- 2025.06.04 18:08 记录：今天已经第四次卡死了，检查时发现不知为何 `mksSandbox` 和 `vmware-vmx` 的设置都变为了默认设置，于是重新设置了一遍，重新打开虚拟机进行测试。
- 2025.06.04 18:09 记录：设置完成发现，虚拟机无法正常打开了，一直报错 `VMware Workstation 未能开启 "...\IC618.vmx"`, 即使还原设置并重启也不行。于是尝试了在 Process Lasso 中 “关闭并重启” `vmware.exe` 进程，然后虚拟机可以正常打开了。于是还原各项设置，继续测试是否会卡死。


2025.08.19: 看到这篇文章 [知乎 > 【Cadence 使用技巧 1】解决虚拟机使用中途鼠标突然失灵](https://zhuanlan.zhihu.com/p/1936898339963666762) 受到启发，猜测会不会是 VMware 与虚拟机之间的版本兼容性问题。于是去搜到这个视频 [Bilibili > 【VM虚拟机如何升、降及打开虚拟系统的各个版本呢？】](https://www.bilibili.com/video/BV1sBHxebEbn), 提出两种可能的原因：
- (1) 我们的 VMware 版本为 17.5, 而虚拟机 `IC618.vmx` 的硬件兼容性默认是 `ESXi 7.0`, 可能这俩版本直接兼容性不好
- (2) 我们的虚拟机操作系统为 Windows 11, 而 VMware 17.5 可能对 Windows 11 的支持不够完善

于是提出解决方案：先重新安装 VMware 17.6.4 (截至 2025.08.19 的最新版本)，下载链接在 [link 1](https://www.123684.com/s/0y0pTd-5YSj3) 或 [link 2](https://changjiu365.cn/download/vmware)，然后将虚拟机 `IC618.vmx` 的硬件兼容性改为 `Workstation 17.5 or later`，最后正常使用看看还会不会卡死。

在 VMware 17.6.4 下更改虚拟机 `IC618.vmx` 硬件兼容性为 `Workstation 17.5 or later` 的效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-13-17-07_Use Virtuoso Efficiently - 0. How to Use Cadence Virtuoso Efficiently.png"/></div>

**<span style='color:red'> 我们从 2025.08.19 更新并修改兼容性后，一直使用到 2025.09.04, 期间没有出现任何卡死现象！！！这个 bug 终于修好了 (\:\_o\_\:) </span>**


### 4. ERROR (PRINT-1032): Unable to write to output file

一般是文件导出位置的文件夹不存在导致的，用 `mkdir` 命令先创建好文件夹再导出即可解决。`mkdir` 命令的用法如下：

``` bash
mkdir -p /home/IC/a_Win_VM_shared/a_Misc/Cadence_Data/tsmc18rf_gmIdData_nmos2v
```

可选的几个参数：
- `-p`：如果上级目录不存在，则创建上级目录，但即使上级目录已存在也不会报错
- `-v`：显示创建目录的详细信息
- `-m`：设置新目录的权限 (例如 `-m 755` 设置为 rwxr-xr-x)

### 5. Could not open "xxx" for edit

报错如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-18-51-42_How to Use Cadence Efficiently.png"/></div>

出现这种情况，通常是在上一次编辑 cellview 时软件异常关闭导致的。因为后缀带 lck 的文件会在你打开 schematic 的时候出现，正确关闭 schematic 该文件会消失。如果你错误的关闭了 schematic, 这个文件将会被保留，在你下次打开的时候就无法编辑。

解决方法：到工程目录的 Cadence_Projects 文件夹下找到 `sch.oa.cdslck` 和 `sch.oa.cdslck.RHEL30.IC.6615` 两个文件，删除后即可恢复正常。


如果软件异常关闭，导致多个 schematic 下存在 lck 文件，一个个删除太过繁琐，该怎么办呢？参考 [Bilibili > 模拟 IC 设计中的软件操作: Cadence Virtuoso Library Manager 库的管理与工程移植](https://www.bilibili.com/video/BV1Xd4y147ZG) 的第 21 分 05 秒，我们可以在工作目录打开 terminal, 输入以下代码：

``` bash
find . -name "*.cdslck" -exec rm -f {} \;   # 递归搜索并删除当前目录下所有名称结尾是 ".cdslck" 字符的文件
```


<!-- AnalogIC/How to Use Cadence Virtuoso Efficiently.md
AnalogIC/How to Use Cadence Virtuoso Efficiently.md -->


### 6. Error: argument #1 should be either a string or a symbol

在 ADE XL 中加载之前的仿真数据时报错：

``` bash
WARNING (OCN-6040): The specified directory does not exist, or the directory does not contain valid PSF results.
        Ensure that the path to the directory is correct and the directory has a logFile and PSF result files.
WARNING (ADE-1065): No simulation results are available.
*Error* ("strcat" 0 t nil ("*Error* strcat: argument #1 should be either a string or a symbol (type template = \"S\")" nil))
```

<!-- 参考 [this article](), 只需重新生成一下 netlist 即可。于是打开 schematic 并点击 `Save and Netlist` -->

是因为导入了错误的仿真数据文件，正确的数据文件都是在 `adexl` 文件夹下面，例如：

``` bash
/home/IC/simulation/MyLib_tsmcN28/simu_MOSFET_nch_mac/adexl/results/data/gmId_nch_mac_125mV/psf/tsmcN28__nch_mac
```

### 7. ".../toplevel.scs" No section found with name 'fs_res_bip_dio_disres' defined in file ".../crn28ull_2d5_elk_v1d0_2p1_shrink0d9_embedded_usage.scs"

最近在用 `tsmcN28` 工艺库仿真运放 [(this design)](<AnalogICDesigns/202507_tsmcN28_OpAmp__nulling-Miller.md>) 时出现了 FS 和 SF 工艺角模型缺失导致的仿真报错，具体情况如下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-14-50-58_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-14-50-05_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

参考 [this blog](https://blog.eetop.cn/blog-1780399-6952706.html), 我们知道报错是因为 model file `crn28ull_2d5_elk_v1d0_2p1_shrink0d9_embedded_usage.scs` 里并没有包含 resistor, capacitor 和 inductor 的 FS 和 SF 工艺角模型。而 TT, FF 和 SS 能正常仿真，就是因为文件中包含了这些工艺角：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-14-54-28_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>
 -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-14-54-52_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

依上图，找到 `cln28ull_2d5_elk_v1d0_2.scs` 文件，查看一下其中是否有阻容器件的 FS 和 SF 工艺角模型：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-14-57-55_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

可以看到确实是没有的。那么如何 “间接” 地解决 FS, SF 的工艺角仿真问题呢？我们不妨将阻容器件的 FS, SF 模型设置为对应的 TT 模型 (相当于只有晶体管的 FS, SF 模型起作用)，这样就可以避免报错了 (聊胜于无)。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-15-05-00_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>

修改后再仿真一次 (ac) frequency response, 仿真正常完成：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-19-15-08-22_tsmcN28_OpAmp__twoStage_single_Nulling-Miller__55dB_75MHz_120uA.png"/></div>


### 8. output current in the dc-sweep simulation

在 TT (typical-typical) 工艺角下，仿真带隙电压 V_BG 在不同温度下 (-40 °C, 0 °C, 27 °C, 75 °C, 125 °C) 随供电电压 VDD 的变化情况，结果如下：


室温 27 °C 时：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-00-33-40_tsmcN28_BGR__scientific_research_practice_1.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-00-38-34_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

<span style='color:red'> 上面仿真 op amp 的总电流时出现了一些挫折，后面靠手动添加 `oppoint > /I0 > VDD` 解决了。 </span>

### 9. pending QUESTION (ADEXL-1921)

<span style='color:red'> 同时仿真多个温度时，出现了一直 pending 而不进行仿真的情况，等待一段时间后报错如下： </span>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-26-00-51-35_tsmcN28_BGR__scientific_research_practice_1.png"/></div>

尝试过重启虚拟机，也试过用 root 权限进入软件，但是没有效果。最终是参考 [this blog](https://bbs.eetop.cn/thread-945221-1-1.html), 在 `/home/.bashrc` 中加了下面两行代码解决的：

``` bash
export CDS_XVNC_TENBASE=9 # 端口号的十位 (本地的话无所谓, 随便写一个数字)
export CDS_XVNC_OFFSET=9  # 端口号的个位 (本地的话无所谓, 随便写一个数字)
```


下面是与本问题相关的其它资料，有多种不同的解决方案成功过：
- [edaboard > IC 616: ADE-XL 1921 error](https://www.edaboard.com/threads/ic-616-ade-xl-1921-error.394350/)
- [edaboard > Compatibility question Cadence](https://www.edaboard.com/threads/compatibility-question-cadence.383369/#post-1645399)
- [知乎 > Cadence 跑 adexl 多个 corner 卡 pending 的问题?](https://www.zhihu.com/question/505839455)
- [EETOP > ADE XL 多 corner 一直 PENDING](https://bbs.eetop.cn/thread-967362-1-1.html)
- [CSDN > 解决在高版本系统中 IC617 无法使用 ADE XL Explorer 等进行多线程仿真 Pending 的问题](https://blog.csdn.net/qq_42761840/article/details/127625571)
- [EETOP > 请问 corners 仿真报错__ADEXL Message1921 如何解？](https://bbs.eetop.cn/thread-870417-1-1.html): 认为是文件夹写入权限的问题 (个人虚拟机有权限的状态下也会出现这个)


### 10. pcellEvalFailed

在文章 [Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library)](<AnalogICDesigns/Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).md>) 中出现了 `pcellEvalFailed` 的问题 (即便是修改 MOS 的 length 或者 width 也会报错)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-23-37-45_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-23-41-35_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>

于是参考这两篇问答 [EETOP > [求助] tsCreateDiffusionL 函数调用, pcellEvalFailed](https://bbs.eetop.cn/thread-992729-1-1.html) 和 [EETOP > [讨论] PcellEvalFailed是什么原因](https://bbs.eetop.cn/thread-343615-5-1.html)，可能是我们的 `tsmcN65_old` 工艺库与 `tsmcN65` 产生了冲突（尽量不要一个 workspace 下，装/引入两个同类工艺库），于是在 `cds.lib` 中将 `tsmcN65_old` 工艺库的代码注释掉，重启 virtuoso 再次尝试，发现问题并没有解决。

那么我们又想，会不会是 `tsmcN65` 与其它工艺库之间产生了冲突呢？于是又单独创建一个 `Workspace_tsmcN65` 文件夹，此文件夹中的 `cds.lib` 仅引入 `tsmcN65` 和几个基本工艺库，重启 virtuoso 再次尝试，问题得到解决：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-11-00-52-35_Use Virtuoso Efficiently - 0. How to Use Cadence Virtuoso Efficiently.png"/></div>

**<span style='color:red'> 这个问题告诉我们，尽量避免在同一个 workspace 下引入多个工艺库 (即便它们不同类)，以免产生冲突。 </span>** 建议每一个工艺库都有自己的 workspace.

### is a invalid register number

生成 mom cap 的版图时报错：

``` bash
is a invalid register number, Need a valid register number from TSMC
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-22-22-27_Use Virtuoso Efficiently - 0. How to Use Cadence Virtuoso Efficiently.png"/></div>

生成 mom cap 版图需要 licence, 找老师要到 licence 文件后，参考 []