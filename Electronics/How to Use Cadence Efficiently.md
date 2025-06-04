# How to Use Cadence Efficiently

> [!Note|style:callout|label:Infor]
> Initially published at 17:05 on 2025-05-20 in Beijing.
<!-- 
- Cadence 相关文章汇总：
    - [How to Use Cadence Efficiently](<Electronics/How to Use Cadence Efficiently.md>)
    - [How to Install Cadence IC618](<Electronics/How to Install Cadence IC618.md>)
    - [How to Add New Process Libraries in Cadence IC618](<Electronics/How to Add New Process Libraries in Cadence IC618.md>)
    - [Simulate CMOS Inverter in Cadence IC618 (Virtuoso)](<Electronics/Simulate CMOS Inverter in Cadence IC618 (Virtuoso).md>)
    - [Simulate Chara. of MOSFET in Cadence IC618 (Virtuoso)](<Electronics/Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).md>)
    - [Design Example of F-OTA using Overdrive and Gm-Id Methods](<Electronics/Design Example of F-OTA using Gm-Id Method.md>)
    - [Design of Op Amp using gm-Id Methodology Assisted by MATLAB](<Electronics/Design of Op Amp using gm-Id Methodology Assisted by MATLAB.md>)

 -->

## Install Cadence IC618


详见文章 [How to Install Cadence IC618](<Electronics/How to Install Cadence IC618.md>).


## Setting Tips

### 1. Recommended Settings

- 修改字体、字号：`初始窗口 > Options > Fonts`
- 修改快捷键：`初始窗口 > Options > Bindkeys`, 关于 `Bindkeys`, 下面是修改建议的一部分： **<span style='color:red'> 建议在 .cdsinit 文件中使用脚本语言来设置快捷键，详见后一小节 </span>**



<div class='center'>

| 快捷键 | 默认设置及其效果 | 修改建议与修改后的效果 |
|:-:|:-:|:-:|
 | `Schematic -> None<Btn4Down>` 鼠标滚轮上滑 (食指上滑) | `hiZoomInAtMouse` 放大界面 | `geScroll(nil "n" nil)`  界面上移 |
 | `Schematic -> None<Btn5Down>` 鼠标滚轮下滑 (食指下滑) | `hiZoomOutAtMouse` 缩小界面 | `geScroll(nil "s" nil)` 界面下移 |
 | `Schematic -> Ctrl<Btn4Down>` Ctrl + 鼠标滚轮上滑 (食指上滑) | `geScroll(nil "n" nil)` 界面上移 | `hiZoomInAtMouse` 放大界面 |
 | `Schematic -> Ctrl<Btn5Down>` Ctrl + 鼠标滚轮下滑 (食指下滑) | `geScroll(nil "s" nil)` 界面下移 | `hiZoomOutAtMouse` 缩小界面 |
 | `Schematic -> Ctrl<Key>Z` Ctrl + Z | `hiZoomOut()` 缩小界面 | `hiUndo()` undo (撤销) |
 | `Schematic -> Ctrl<Key>Y` Ctrl + Y | - (无) | `hiRedo()` redo (重做) |


</div>

<!-- 修改完成后记得左下角 `Save Bindings for All > Save`，以免下次又要重新设置。也可以直接在 `.cdsinit` 文件中添加代码，详见后一小节。 -->

### 2. file .cdsinit and .cdsenv

本小节参考了以下资料：
- [重要: Virtuoso® Schematic Editor SKILL Functions Reference](<https://picture.iczhiku.com/resource/eetop/sykRGZGTDTSiYmCv.pdf>)
- [University of Southern California: Cadence Virtuoso Tutorial](https://ee.usc.edu/~redekopp/ee209/virtuoso/setup/USCVLSI-VirtuosoTutorial.pdf)
- [.cdsenv Tips & Tricks](https://aselshim.github.io/blogposts/2019-03-21-cdsenv/)
- [Cadence Tips and Tricks: Change Waveform Graph windows default settings](https://wikis.ece.iastate.edu/vlsi/index.php?title=Tips_%26_Tricks)
- [Bilibili: Cadence IC ADE 仿真学习笔记- 配置文件](https://www.bilibili.com/video/BV15T42197PQ)
- [Setting Bind Keys in Cadence Virtuoso Using SKILL Code](https://analoghub.ie/category/skill/article/skillBindkeysSetup)


我们可以利用 `.cdsinit` (cadence software initialization) 和 `.cdsenv` (cadence software environment parameters) 文件来配置一些每次启动 virtuoso 都生效的默认设置，这两个文件需要与 `cds.lib` 在同一目录。

- 按教程 [How to Install Cadence IC618](<Electronics/How to Install Cadence IC618.md>) 安装的 cadence, 其安装路径 `<Cadence_Install_Directory>` 为 `/opt/eda/cadence/IC618`
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
; .cdsenv
; 直接将本段代码复制到 .cdsenv 文件的末尾, 后加载的 env 便可覆盖原始值, 不需要一个一个搜索然后修改

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

; 设置仿真图中 marker 始终显示坐标点
viva.vertMarker	interceptStyle	string	"OnWhenHover" ; 可设置为 "on", "off", "OnWhenHover"(默认), 建议 "OnWhenHover", 因为仿真时我们一般都有第二变量, 直接从左侧 legend 查看结果 (而不是在图上来看)
viva.horizMarker	interceptStyle	string	"OnWhenHover"
viva.referenceLineMarker	interceptStyle	string	"OnWhenHover"

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

; 设置初始 CIW 窗口的大小和位置, 其中 400:150 代表窗口左下角坐标，1200:600 代表窗口右上角坐标
hiResizeWindow(window(1) list(400:0 1800:1000))

; 设置 Cadence 中默认文本编辑器为 gedit (script 和 verilog-A 的编辑器)
; 可选的通常有 vim, gedit, emacs, atom
; editor="gedit"


hiSetBindKeys("Schematics" list(
    list("None<Btn4Down>" "geScroll(nil \"n\" nil)") ; 鼠标滚轮上滑, 界面上移:
    list("None<Btn5Down>" "geScroll(nil \"s\" nil)") ; 鼠标滚轮下滑, 界面下移:
    list("Ctrl<Btn4Down>" "hiZoomInAtMouse()") ; Ctrl + 鼠标滚轮上滑, 放大界面:
    list("Ctrl<Btn5Down>" "hiZoomOutAtMouse()") ; Ctrl + 鼠标滚轮下滑, 缩小界面:
    list("Ctrl<Key>Z" "hiUndo()") ; Ctrl + Z, 撤销:
    list("Ctrl<Key>Y" "hiRedo()") ; Ctrl + Y, 重做:
    list("<Key>F5" "simulate") ; F5 仿真
    list("<Key>space" "schSetEnv(\"rotate\" t)") ; 空格旋转
    list("Ctrl<Key>s" "schHiCheckAndSave()") ; Ctrl + S 检查与保存
    list("<Key>x" "schSetEnv(\"sideways\" t)") ; x 翻转
            ; list("<Key>d" "cancelEnterFun()") ; d 取消, 用作 esc 的替代 (esc 太远了)
            ; None<Btn2Down> 是中键
    list("None<Btn3Down>" "" "cancelEnterFun()") ; 鼠标右键用作 esc (esc 太远了)
    list("None<Btn3Down>(2)" "" "") ; 删除原有的冗余右键绑定
            ; list("<Key>g" "schHiCreatePin(\"GND\" \"input\" \"schematic\" \"full\" nil nil nil \"roman\")") ; 按键 G 创建 GND pin, 默认是 schHiFindMarker()
    list("<Key>g" "schHiCreateInst(\"analogLib\" \"gnd\" \"symbol\")") ; 按键 G 创建 gnd
    list("<Key>v" "schHiCreateInst(\"analogLib\" \"vdc\" \"symbol\")") ; 按键 v 创建 dc source
    list("<Key>r"  "schHiCreateInst(\"analogLib\" \"res\" \"symbol\")") ; 按键 R 创建理想电阻
    list("<Key>c"  "schHiCreateInst(\"analogLib\" \"cap\" \"symbol\")") ; 按键 C 创建理想电容 (默认是复制 schHiCopy())
    list("Ctrl<Key>c" "schHiCopy()") ; Ctrl + C 复制
    list("<Key>d" "schHiCreateNoteShape()") ; 按键 D 创建注释和 drawing (原本是按键 n 的默认功能)
    list("<Key>a" "schHiCreateInst()") ; 按键 A 添加 instance (默认功能是 geSingleSelectPoint()), 用于替代按键 I
    list("Ctrl<Key>1" "sevAnnotateResults('sevSession1 'dcNodeVoltages)") ; 在 schematic 中标出 dc voltages
    list("Ctrl<Key>2" "sevAnnotateResults('sevSession1 'dcOpPoints)")     ; 在 schematic 中标出器件的 operation points
    list("Ctrl<Key>3" "sevAnnotateResults('sevSession1 'componentParameters)") ; 在 schematic 中标出器件的尺寸信息
    list("Ctrl<Key>4" "sevAnnotateResults('sevSession1 'modelParameters)") ; 在 schematic 中标出器件的模型信息 (例如阈值电压 vto)
            ; list("Ctrl<Key>1" "AnnotationSlider->annDCVoltage->checked=t") ; 在 schematic 中标出 dc voltages
            ; list("Ctrl<Key>2" "AnnotationSlider->annDCOpPoint->checked=t") ; 在 schematic 中标出器件的 operation points
            ; list("Ctrl<Key>3" "AnnotationSlider->annparameter->checked=t") ; 在 schematic 中标出器件的尺寸信息
            ; list("Ctrl<Key>4" "AnnotationSlider->annmodel->checked=t")     ; 在 schematic 中标出器件的模型信息 (例如阈值电压 vto)
	)
)

hiSetBindKeys("Symbol" list(
    list("None<Btn4Down>" "geScroll(nil \"n\" nil)") ; 鼠标滚轮上滑, 界面上移:
    list("None<Btn5Down>" "geScroll(nil \"s\" nil)") ; 鼠标滚轮下滑, 界面下移:
    list("Ctrl<Btn4Down>" "hiZoomInAtMouse()") ; Ctrl + 鼠标滚轮上滑, 放大界面:
    list("Ctrl<Btn5Down>" "hiZoomOutAtMouse()") ; Ctrl + 鼠标滚轮下滑, 缩小界面:
    list("Ctrl<Key>Z" "hiUndo()") ; Ctrl + Z, 撤销:
    list("Ctrl<Key>Y" "hiRedo()") ; Ctrl + Y, 重做:
    list("<Key>F5" "simulate") ; F5 仿真
    list("<Key>space" "schSetEnv(\"rotate\" t)") ; 空格旋转
    list("Ctrl<Key>s" "schHiVICAndSave()") ; Ctrl + S 检查与保存 (与 schematic 中的命令不同)
    list("<Key>x" "schSetEnv(\"sideways\" t)") ; x 翻转
    ; list("<Key>d" "cancelEnterFun()") ; d 取消, 用作 esc 的替代 (esc 太远了)
    ; None<Btn2Down> 是中键
    list("None<Btn3Down>" "" "cancelEnterFun()") ; 鼠标右键用作 esc (esc 太远了)
    list("None<Btn3Down>(2)" "" "") ; 删除原有的冗余右键绑定
    list("Ctrl<Key>c" "schHiCopy()") ; Ctrl + C 复制
    list("<Key>d" "schHiCreateNoteShape()") ; 按键 D 创建注释和 drawing (原本是按键 n 的默认功能)
	)
)



; 设置 label, text, ciw 的字体和字号
hiSetFont( "ciw" ?name "monospace" ?size 18 ?bold nil ?italic nil )
hiSetFont( "label" ?name  "roman" ?size 13 ?bold nil ?italic nil ) ; "label" 既是 toolbar 的字体, 也是打开某些设置界面的字体, 因此 "label" 字号不宜过大, 否则会导致表单文字重叠
; hiSetFont( "text" ?name "roman" ?size 18 ?bold nil ?italic nil ) ; 2025.05.25 暂时没找到 text 是对应哪个界面的字体

; 设置 log filter 的默认输出
; hiSetFilter() ; 此命令是打开 log filter 窗口
hiSetFilterForm->accelInput->value= t   ; 将默认不输出的值全部勾选为输出
; hiSetFilterForm->accelRetval->value= t ; 这个没啥必要
hiSetFilterForm->promptOutput->value= t
_hiFormApplyCB(hiSetFilterForm)     ; 应用已修改的 log filter 结构体


; 其它设置
ExportImageDialog->fileName->value = "/home/IC/a_Win_VM_shared/a_Misc/schematic.png" ; 设置 schematic 导出为 image 时的默认路径
```
















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


可选的字体 family 汇总（大小写不能错）：
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

- 注意：到这个时候，共享文件夹的挂载仍是一次性的，重启虚拟机后需要重新挂载。为解决这个问题，我们在 `/etc/fstab` 文件中添加一行：

```bash 
.host:/a_Win_VM_shared /home/IC/a_Win_VM_shared fuse.vmhgfs-fuse allow_other,defaults 0 0
```





### 5. Add Process Library

详见文章 [How to Add New Process Libraries in Cadence IC618](<Electronics/How to Add New Process Libraries in Cadence IC618.md>).


### 6. Screenshot Path

- 修改 screenshot path: 虚拟机界面找到 `Edit > Preferences > Workspace`, 然后修改路径  (参考 [Configuring the Default Locations for Virtual Machine Files and Screenshots](https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors/workstation-pro/17-0/using-vmware-workstation-pro/changing-workstation-pro-preference-settings/configuring-workspace-preference-settings/configuring-the-default-locations-for-virtual-machine-files-and-screenshots.html))
- 修改 screenshot keybindings: 虚拟机界面 `Applications > System Tools > Settings > Devices > Keyboard`, 然后搜索 `screenshot`, 进行修改即可

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-23-14-50-28_How to Use Cadence Efficiently.png"/></div>














## Simulation Tips


### 0. Simulation Examples

- [Simulate CMOS Inverter in Cadence IC618 (Virtuoso)](<Electronics/Simulate CMOS Inverter in Cadence IC618 (Virtuoso).md>)
- [Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso)](<Electronics/Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).md>)
- [Design Example of F-OTA using Gm-Id Method](<Electronics/Design Example of F-OTA using Gm-Id Method.md>)



### 1. Config Wire Color

### 2. 











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


详见 [Design of Op Amp using gm-Id Methodology Assisted by MATLAB](<Electronics/Design of Op Amp using gm-Id Methodology Assisted by MATLAB.md>).

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




## Frequently Asked Questions

### 1. wrong schematic colors



如果出现原理图器件一片黄的问题，大概是 attach library 时 `display.drf` 文件出现了某些错误，解决方法如下：直接将工艺库的 `display.drf` 文件复制到 virtuoso 的启动目录 `/home/IC/`，然后重启 virtuoso. 


还有一种 merge 多个 `display.drf` 文件的方法：
- `virtuoso > Tools > Display Resources Tool > Merge > OK > From Library > Browse`
- 随便选择一个工艺库的 `display.drf` 文件，例如选择 tsmc18rf 的 `/home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d_OA/display.drf`
- 点击 `Add` 将 `TSMC18RF_PDK_v13d_OA/display.drf` 添加到 Merge 栏里
- Destination DRF 一栏，点击 `Browse`，选择 virtuoso 启动目录下的 `display.drf` 文件 `/home/IC/display.drf`，这一步是让 merge 的结果覆盖掉 Destination 的 `display.drf` 文件
- 点击 `OK` 进行 merge 并覆盖


### 2. is referencing an undefined model

仿真报错：<span style='color:red'> The instance 'NMOS1' is referencing an undefined model or subcircuit, 'nch'. Either include the file containing the definition of 'nch', or define 'nch' before running the simulation. </span> 这是工艺信息文件设置错误导致的，因为一般都是默认用中芯科技 smic18 工艺库的工艺信息文件，但是台积电 tsmc18 的工艺信息设置与其不同。

解决办法： `ADE L > Setup > Model Libraries`，添加 model file `/home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d_OA/models/spectre/cor_std_mos.scs`，然后 <span style='color:red'> 记得在 section 一栏填入 tt 表示标准等级</span>。重新运行仿真即可。

如果仍未解决，可参考 [this article](https://blog.csdn.net/coocoock/article/details/128053280)

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
 | 打开 virtuoso, ADE L, run simulation + plot results, 然后静置不动 | 一段时间后 (约四十分钟), 虚拟机 IC618 卡死，点击无反应 (但 VMWare Workstation 正常) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-16-22-39_How to Use Cadence Efficiently.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-16-19-32_How to Use Cadence Efficiently.png"/></div> |
 |(2025.05.25 17:05) 打开 virtuoso, ADE L, run simulation + plot results, 然后静置不动 | (2025.05.25 17:28) 查看时仍正常 <br> (2025.05.25 17:50) 查看时发现已经闪退, 虚拟机 IC618 已关机, 故重新打开 <br> (2025.05.25 18:15) 正常使用突现卡死 | 刚打开时 (2025.05.25 17:05) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-17-06-27_How to Use Cadence Efficiently.png"/></div> | (2025.05.25 18:15) 卡死后虚拟机 IC618 自动关机, 未来得及记录当时的任务管理器 |
 | (2025.05.25 18:25) 尝试用我们的 `.cdsenv` 代码覆盖原 `.cdsenv` 文件的全部内容, 启动 ADE L + load state + plot 进行测试 | (2025.05.25 20:11) 查看时发现已经卡死, 19:30 左右都还正常 | (无图片) | (2025.05.25 20:11) 卡死时 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-25-20-11-39_How to Use Cadence Efficiently.png"/></div> |
</div>


从上面的测试结果来看，卡死的原因就出在 VMware mksSandbox 这个进程上，于是又去搜索：
- [GitHub > vmware > open-vm-tools > issue > mksSandbox error on VMWare Workstation 17.0 #624](https://github.com/vmware/open-vm-tools/issues/624), 表示这就是 VMware Workstation 的 bug, 
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
 | (2025.05.26 17:57) 按上面的条件进行第二次测试，边设计 [F-OTA](<Electronics/Design Example of F-OTA using Gm-Id Method.md>) 边测试 | (无) | (2025.05.26 17:58) 刚开始测试时的进程如下 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-18-00-26_How to Use Cadence Efficiently.png"/></div> | (2025.05.26 19:25) 出现卡死现象  |
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


### 4. ERROR (PRINT-1032): Unable to write to output file

一般是文件导出位置的文件夹不存在导致的，用 `mkdir` 命令先创建好文件夹再导出即可解决。`mkdir` 命令的用法如下：

``` bash
mkdir -p /home/IC/a_Win_VM_shared/a_Misc/Cadence_Data/tsmc18rf_gmIdData_nmos2v
```

可选的几个参数：
- `-p`：如果上级目录不存在，则创建上级目录，但即使上级目录已存在也不会报错
- `-v`：显示创建目录的详细信息
- `-m`：设置新目录的权限 (例如 `-m 755` 设置为 rwxr-xr-x)