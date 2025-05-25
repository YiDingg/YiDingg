# How to Use Cadence Efficiently

> [!Note|style:callout|label:Infor]
> Initially published at 17:05 on 2025-05-20 in Beijing.

- Cadence 教程汇总：
    - [How to Install Cadence IC618](<Electronics/How to Install Cadence IC618.md>)
    - [How to Use Cadence Efficiently](<Electronics/How to Use Cadence Efficiently.md>)
    - [How to Add New Process Libraries in Cadence IC618](<Electronics/How to Add New Process Libraries in Cadence IC618.md>)
    - [Simulate CMOS Inverter in Cadence IC618 (Virtuoso)](<Electronics/Simulate CMOS Inverter in Cadence IC618 (Virtuoso).md>)

## Install Cadence IC618


详见文章 [How to Install Cadence IC618](<Electronics/How to Install Cadence IC618.md>).


## Setting Tips and Tricks

### Recommended Settings

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

### .cdsinit and .cdsenv

本小节参考了以下资料：
- [重要: Virtuoso® Schematic Editor SKILL Functions Reference](<https://picture.iczhiku.com/resource/eetop/sykRGZGTDTSiYmCv.pdf>)
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
viva.graphFrame height string "600"

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
schematic	schWindowBBox	string	"((300 0) (2000 900))" ; 修改 schematic 打开时的默认窗口大小、位置
layout	leWindowBBox	string	"((500 0) (2200 900))" ; 修改 layout 打开时的默认窗口大小、位置
ui	ciwCmdInputLines	int	4 ; 设置 CIW 窗口 input area 的行数 (默认为 1)
schematic	showUndoRedoHistoryInEditor	boolean	t ; 在 schematic 中显示撤销重做历史
```


另外，在 `.cdsinit` 文件中，我们也有一些实用的设置：

``` bash
; .cdsinit

; 设置初始 CIW 窗口的大小和位置, 其中 400:150 代表窗口左下角坐标，1200:600 代表窗口右上角坐标
hiResizeWindow(window(1) list(400:150 1680:950))

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
    list("<Key>g" "schHiCreatePin(\"GND\" \"input\" \"schematic\" \"full\" nil nil nil \"roman\")") ; 按键 G 创建 GND pin, 默认是 schHiFindMarker()
    list("<Key>r"  "schHiCreateInst(\"analogLib\" \"res\" \"symbol\")") ; 按键 R 创建理想电阻
    list("<Key>c"  "schHiCreateInst(\"analogLib\" \"cap\" \"symbol\")") ; 按键 C 创建理想电容 (默认是复制 schHiCopy())
    list("Ctrl<Key>c" "schHiCopy()") ; Ctrl + C 复制
    list("<Key>d" "schHiCreateNoteShape()") ; 按键 D 创建注释和 drawing (原本是按键 n 的默认功能)
    list("<Key>a" "schHiCreateInst()") ; 按键 A 添加 instance (默认功能是 geSingleSelectPoint()), 用于替代按键 I
	)
)


; 设置 label, text, ciw 的字体和字号
hiSetFont( "ciw" ?name "monospace" ?size 18 ?bold nil ?italic nil )
hiSetFont( "label" ?name  "roman" ?size 13 ?bold nil ?italic nil ) ; "label" 既是 toolbar 的字体, 也是打开某些设置界面的字体, 因此 "label" 字号不宜过大, 否则会导致表单文字重叠
; hiSetFont( "text" ?name "roman" ?size 18 ?bold nil ?italic nil ) ; 2025.05.25 暂时没找到 text 是对应哪个界面的字体


```
















也可以在 `.cdsinit` 文件中用 SKILL 语言修改上面的环境变量，语法为：

``` bash
; .cdsinit

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











### Command Definitions

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














### Shared Folders

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





### Add New Process Library

详见文章 [How to Add New Process Libraries in Cadence IC618](<Electronics/How to Add New Process Libraries in Cadence IC618.md>).


### Screenshot Path and Keybindings

- 修改 screenshot path: 虚拟机界面找到 `Edit > Preferences > Workspace`, 然后修改路径  (参考 [Configuring the Default Locations for Virtual Machine Files and Screenshots](https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors/workstation-pro/17-0/using-vmware-workstation-pro/changing-workstation-pro-preference-settings/configuring-workspace-preference-settings/configuring-the-default-locations-for-virtual-machine-files-and-screenshots.html))
- 修改 screenshot keybindings: 虚拟机界面 `Applications > System Tools > Settings > Devices > Keyboard`, 然后搜索 `screenshot`, 进行修改即可

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-23-14-50-28_How to Use Cadence Efficiently.png"/></div>














## Simulation Tips


### Collection of Simulation Examples

- [Simulate CMOS Inverter in Cadence IC618 (Virtuoso)](<Electronics/Simulate CMOS Inverter in Cadence IC618 (Virtuoso).md>)
- [Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso)](<Electronics/Simulate Basic Chara. of MOSFET in Cadence IC618 (Virtuoso).md>)
- [Design Example of F-OTA using Overdrive and Gm-Id Methods](<Electronics/Design Example of F-OTA using Overdrive and Gm-Id Methods.md>)

### 1. Config Wire Color

### 2. 

















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
- [VMware Worksation 虚拟机性能调优](https://www.yongz.fun/posts/516e2ab0.html)

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
</div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-01-27-47_How to Use Cadence Efficiently.png"/></div> -->