# Use Virtuoso Efficiently - 1. Shortcuts and Initialization

> [!Note|style:callout|label:Infor]
> Initially published at 15:51 on 2025-07-14 in Beijing.


## 1. 起因

Cadence Virtuoso 的很多默认快捷键和初始化设置都不符合日常使用习惯，包括界面的缩放和移动，最近操作的重做与撤销，以及波形界面的颜色样式等。下面是几个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-14-15-58-08_Use Virtuoso Efficiently - 1. Shortcuts and Initialization.png"/></div>

我们可以通过配置 `.cdsinit` 和 `.cdsenv` 文件来调整这些设置，进而提高工作效率。

那么，这两个文件到底是什么呢，修改之后会有什么效果？在 Cadence Virtuoso 中，`.cdsinit` 和 `.cdsenv` 是两个关键的配置文件，用于定制工具的行为和优化用户的工作流程。其中，`.cdsinit` 文件是一个启动脚本，使用 SKILL 语言编写，它在 Virtuoso 启动时自动执行。该文件允许用户加载自定义的 SKILL 脚本、设置环境变量、定义快捷键或修改默认工具行为，通过 `.cdsinit`，用户可以自动化重复任务或集成第三方工具，从而显著提升设计效率。另一个文件 `.cdsenv` 文件主要用于配置 Virtuoso 的环境参数，例如默认的显示选项（比如波形颜色和粗细）、编辑模式设置或工具偏好。该文件采用特定的语法结构，允许用户调整界面布局、颜色方案、网格设置等。


需要注意的是，`.cdsinit` 和 `.cdsenv` 文件的位置需要放在软件的工作目录下，也就是我们在终端输入 `virtuoso` 命令时所在的目录。按文章 [Cadence Virtuoso 教程 (一)：如何下载并安装 Cadence IC618 (How to Install Cadence IC618)](https://zhuanlan.zhihu.com/p/1917027976194810886) 中所介绍的安装方法，我们的工作目录即为 `/home`, 因此这两个文件需要放在 `/home` 目录下。



## 2. 配置文件

### 2.1 一键配置


在 `/home` 下右键打开终端，输入代码 `touch .cdsinit .cdsenv` 以创建 `/home/.cdsinit` 和 `/home/.cdsenv` 两个文件，记得打开右上角的 `show hidden files` 选项，否则不能看到以小数点 `.` 开头的隐藏文件。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-14-17-28-55_Use Virtuoso Efficiently - 1. Shortcuts and Initialization.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-14-17-29-21_Use Virtuoso Efficiently - 1. Shortcuts and Initialization.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-14-16-08-02_Use Virtuoso Efficiently - 1. Shortcuts and Initialization.png"/></div>



下面直接给出我个人目前在用的 `.cdsinit` 和 `.cdsenv` 的文件内容，读者只需将其分别覆盖到自己的 `/home/.cdsinit` 和 `/home/.cdsenv` 文件 (复制代码后，在相应文件处 `Ctrl + A` 全选，然后 `Ctrl + V` 粘贴)。考虑到知乎的代码块不会自动折叠，我们先给出两个配置文件的下载地址，再给出源码 (代码行数比较多，影响观感)。

两个配置文件 `.cdsinit` 和 `.cdsenv` 已经上传到 [123 云盘分享: Virtuoso 配置文件](https://www.123684.com/s/0y0pTd-i9Sj3).



**下面是 .cdsenv 文件的内容：**
``` bash
/*
下面是 .cdsenv 配置内容 (截至 2025.07.14), 来源于知乎作者 https://www.zhihu.com/people/YiDingg
直接将本段代码粘贴到 .cdsenv 文件即可 (覆盖全部原内容), 另外, 后加载的 env (环境变量) 可覆盖原始值, 不需要一个一个搜索然后修改
*/

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
auCore.misc labelDigits int 6                           ;设置仿真结果显示 6 位小数
layout displayPinName boolean t                         ;在布局中默认显示 pin name
schematic schWindowBBox string "((300 50) (2000 950))"  ; 修改 schematic 打开时的默认窗口大小、位置
layout leWindowBBox string "((500 50) (2200 950))"      ; 修改 layout 打开时的默认窗口大小、位置
ui ciwCmdInputLines	int	12                              ; 设置 CIW 窗口 input area 的行数 (默认为 1)
schematic showUndoRedoHistoryInEditor boolean t         ; 在 schematic 中显示撤销重做历史
```

**下面是 .cdsinit 文件内容：**
``` bash
/*
下面是 .cdsinit 配置内容 (截至 2025.07.14), 来源于知乎作者 https://www.zhihu.com/people/YiDingg
直接将本段代码粘贴到 .cdsinit 文件 即可 (覆盖全部原内容), 另外, 后加载的代码可覆盖先加载的代码

本配置代码前半部分来自示例文件 <Cadence_Install_Directory>/tools/dfII/samples/local.cdsinit>, 后半部分是我们的自定义配置, 另外还注释了几行示例部分的代码以避免无限循环导致软件卡死
*/

/* 
   filepath:        <cds_install_dir>/samples/local/cdsinit
   dfII version:    4.4
  
   This file should be copied as <cds_install_dir>/local/.cdsinit
   and customized as a site startup file. The site startup file is
   read and executed when the Design Framework II software starts.

   This file can load all the application configuration files and
   application bind key files. 

   It also sets the library search path ( which may be overriden by the
   user customization file.

   Finally this file transfers control to the user by executing the
   user customization file.

   The user customization file may be

     ./.cdsinit - .cdsinit in the working directory
     ~/.cdsinit - .cdsinit in the user's home directory

   This site file checks if a .cdsinit exists in the working directory
   and executes it. If .cdsinit does not exist in the user's working
   directory then ~/.cdsinit is executed if it exists.


###################################################################
   Please read the entire file and the comments before you start
   customizing the file. See the section below on File Installation
   for a list of sample files supplied.

   There are bind key definition files supplied for different 
   applications. The relevant bind key definitions files must
   be loaded if you want bind keys defined for that application.
   See section LOAD APPLICATION BIND KEY DEFINITIONS.
###################################################################

   In order for any window placements to work correctly the following 
   X resource must be set in the .Xdefaults or .xresources file
   pertaining to your hardware platform.

	Mwm*clientAutoPlace:             False

   After setting the resource read in the resource file with the command

	xrdb <resource_filename>
   
   and restart the Motif window manager.

   The function 

             prependInstallPath("string")

   adds the installation path to the string argument
   For this reason there should NOT be a space at the beginning of the
   string.
   There SHOULD be a space at the end of the string if more paths are to
   follow.
   This function is used to make path specification in this file
   independant of the exact installation path.

   The function let() creates local variables ( example: libPath ). 
   This makes sure that any global variables are not accidentally modified.

*/
/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;							
;  File Installation			
;  -----------------	
;
;  CONFIGURATION FILES
;
;  The following configuration files are delivered in the 4.4 release:
;  <cds_install_dir>/samples/local
;          aaConfig.il                  - analog
;          dciConfig.il                 - Cadence to Synopsys Interface
;          metConfig.il                 - Designing with Composer
;                                         using metric measurements
;          sysConfig.il                 - systems
;          uiConfig.il                  - user interface
;
;  The configuration files are used to initialize parameters and
;  forms.
;
;  ENVIRONMENT VARIABLES
;  Schematic, Layout and Graphic environment variable defaults are now found in
;  <cds_install_dir>/etc/tools/
;				layout/.cdsenv
;				schematic/.cdsenv
;				graphic/.cdsenv
;
;  These can be customized in the user's ./cdsenv and ~/.cdsenv files.
;  A .cdsenv file can be created by using CIW->options->save defaults.
;
;
;  BIND KEY DEFINITION FILES
;
;  The following bind key definition files are delivered in the 
;  4.3 release:
;  <cds_install_dir>/samples/local
;          leBindKeys.il                - layout editor
;          schBindKeys.il               - schematic editor
;
;  CUSTOMIZATION FILES
;
;  The following customization files are delivered in the 
;  4.3 release:
;  <cds_install_dir>/samples/local/cdsinit          - site customization
;  <cds_install_dir>/cdsuser/.cdsinit               - user customization
;
;									;
;  ADMINISTRATION
;
;  The site administrator should install the "site" files as follows:	;
;  
;  1. Copy <cds_install_dir>/samples/local/cdsinit 
;       to <cds_install_dir>/local/.cdsinit
;     and modify the file
;     (If <cds_install_dir>/local does not exist create it)
;
;     <cds_install_dir>/local is the site customization directory.
;     This directory is not sent as part of the software. The site
;     administrator must create this directory. Whenever software is
;     upgraded the Cadence installation process retains the site
;     administration directory if it exists.
;
;
;  2. If default configuration needs to be changed copy the
;     relevant configuration file
;             from:  4.3/samples/local
;             to:    4.3/local
;     and modify the file(s)
;
;  3. If default bind key definitions need to be changed copy the
;     relevant bind key definition file
;             from:  4.3/samples/local
;             to:    4.3/local
;     and modify the file(s)
;
;  4. Copy 4.3/cdsuser/.cdsinit to the user's home or working
;     directory - Do this step only if the user does not already
;     have a .cdsinit file.
;
;     If after site customization each user wants to customize
;     portions of the configuration or bind keys definitions 
;     they should copy the relevant sections from the files in
;     
;                4.3/samples/local 
;     into
;
;                the user's customization file
;                ./.cdsinit   or    ~/.cdsinit
;
;
;  FILE LOADING ORDER							
;  ------------------							
;  1. The configuration files are not automatically loaded.
;     Remove the comment on the filename line to load the file.
;     The search order for the configuration files is:
;
;           .
;           ~
;           4.3/local
;     
;  2. The bind key definition files are not automatically loaded. 
;     Remove the comment on the filename line to load the file.
;     The search order for the bind key definition files is:
;
;           .
;           ~
;           4.3/local
;           4.3/samples/local
;									
;  3. Load user customization file
;  
;         ./.cdsinit - load .cdsinit in the working directory if it exists
;     else
;
;         ~/.cdsinit - load .cdsinit in the user's home directory
;     This file does NOT load both user customization files even if both exist.
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
;
;
;################################################
;#                                           
;# LOAD APPLICATION CONFIGURATION FILES
;#
;################################################
;
;Remove the comment ; if you want to load the specific configuration file
;If you do not load the configuration files the applications will use the
;default configurations.
;
;
let( (configFileList file path saveSkillPath)
    configFileList = '(
;                 "aaConfig.il" 
;                 "dciConfig.il"
;                 "leConfig.il" 
;                 "metConfig.il"
;                 "schConfig.il" 
;                 "sysConfig.il" 
;                 "uiConfig.il" 
                    )
    
;   This is the path that is searched for the files
;
    path = strcat(
;
;   If you want to add another path add it here as a string
;
              ".  ~  "
              prependInstallPath("local ")
             )
    saveSkillPath=getSkillPath()
    setSkillPath(path)

    foreach(file configFileList 
       if(isFile(file) then
          loadi(file)
         )
    )
    setSkillPath(saveSkillPath)
)

;
;################################################
;#                                           
;# LOAD APPLICATION BIND KEY DEFINITIONS
;#
;################################################
;
;Add the comment ; if you do not want to load the specific
;bind key definition file.
;
;If you do not load the bind key definitions the applications will not
;have any bind keys defined.
;
;If you load the bind key definition file but the application is not
;registered ( product not licensed or checked out ) then you might get
;a warning that looks like
;
; *WARNING* "Schematics is not registered yet"
;
;This warning can be ignored if you know that the product is not
;licensed or checked out.
;
let( (bindKeyFileList file path saveSkillPath)
    bindKeyFileList = '(
                   "leBindKeys.il" 
                   "schBindKeys.il"
                    )
    
;   This is the path that is searched for the files
    path = strcat(
;
;   If you want to add another path add it here as a string
;
              ".  ~  "
              prependInstallPath("local ")
              prependInstallPath("samples/local")
             )
    saveSkillPath=getSkillPath()
    setSkillPath(path)

    foreach(file bindKeyFileList
       if(isFile(file ) then
          loadi(file)
         )
    )
    setSkillPath(saveSkillPath)
)

;  An individual user may wish to add some bindkeys of his/her own or
;  over ride some default loaded bindkeys.  For more information about
;  bindkeys see the manual "SKILL Reference Manual, Language Fundamentals", 
;  Chapter 4.
;
;  Here is an example of setting one bindkey on "F2" than prints 
;  "Hello world" to the CIW when pressed in the CIW.
;hiSetBindKey("Command Interpreter" "<Key>F2" "printf(\"Hello World\")") 
;
;  Here is an example of setting keys for more than one application
;let( (app appList)
; appList = '( 
;	"Command Interpreter"
;    "Schematics"
;    "Symbol"
;   
;    Add other applications here 
;
;    )
;
;
;  foreach(app appList
;    hiSetBindKey(app "<Key>F4" "printf(\"Hello \")") 
;    hiSetBindKey(app "<Key>F5" "printf(\"World\")") 
;  )
;)
;
;
;
;################################################
;#
;# SETTINGS FOR SKILL PATH and SKILL PROGRAMMING
;#
;################################################
;
;  The function sstatus() sets the status of variables
;  The variable writeProtect controls if a SKILL function can be
;  redefined or not;
;
;  Any functions defined after writeProtect = t CANNOT be redefined
;  Any functions defined after writeProtect = nil CAN be redefined
;  If you are going to create SKILL programs and define functions set the
;  status of writeProtect to nil at the beginning of your session.
;
;  Set skill search path. The SKILL search path contains directories
;  to be searched to locate SKILL programs when program names are
;  specified without full path names.
;  The operation could be reading, writing or loading a SKILL program.
;
;  Source technology files are considered SKILL files and when loading 
;  or dumping the technology file SKILL search path will be used.
;
;

sstatus(writeProtect nil)

let((skillPath)
   skillPath= strcat(
    ". ~ "                                          ; Current & home directory
    prependInstallPath("samples/techfile ")         ; sample source technology files
   )
   setSkillPath(skillPath)
)
;
;################################################
;#################################################
;  VERIFICATION - DIVA/INQUERY/DRACULA ENCAPS    #
;#################################################
;
; There are no configuration variables for these
; applications to be set in the .cdsinit. You may
; need to create a .simrc  file, using the example
; in <cds_install_dir>/cdsuser/.simrc
;
;#################################################
;# PLACE AND ROUTE - CELL3, CE, BE, PREVIEW,GE   #
;#################################################
; The geSetProbeNetStopLevel default is zero.
; To probe routing in channels, it must be >= 2.
; geSetProbeNetStopLevel(0)  ; 20 is a good number.
; 
;#################################################
;# LAS and COMPACTOR                             #
;#################################################
; There are no configuration variables for these
; applications to be set in the .cdsinit. You need
; to add information to your technology file. See
; the LAS and COMPACTOR reference manuals for
; details about technology file additions.
; 
;##############################################
;# Customizing the 4.x environment with:      #
;# SETTING AmPLD DEFAULTS (Data I/O Abel 4.x) #
;##############################################
; No Setup is required if using the default system shipped from Cadence.
; If you are using your own Abel or need to customize the system Please
; See Appendix A of the Programmable Logic Design System Users Guide.
;
;##############################################
;# Customizing the 4.x environment with:      #
;# DESIGN FLOWS                               #
;##############################################
; The design flows can be used with no customization, but customizing 
; them for your personal preference can greatly enhance your 
; productivity. Please See the Design Flow users guide for details.
;
;  Bring up top flow ...
;
;amdfTopFlow()
;
;
;################################################
;#
;# MISCELLANEOUS
;#
;################################################
;
; Set your own prompt in the CIW. The first argument is the prompt.
; The second argument is not used yet.
;
; The variable editor defines the text editor to be used when any of
; the applications invoke an editor. For example technology dump and 
; edit operation opens an editor window. 
;
; The editor may also be set by 
;               
;         unix environment variable EDITOR
;
;             setenv EDITOR 'xedit'
;
;
; When Design Framework is invoked the SKILL variable editor is set 
; to the value of the unix variable EDITOR.
;  
; If EDITOR is not defined the SKILL variable
; editor is set to "vi"
;
; You may also set the variable to execute a UNIX command
; that invokes an xterm window of given size and location
; and starts an editor program.
; Example:
;
;    editor = "xterm -geometry 80x40 -e emacs"
;
; Size of xterm in the above example is 80 characters by 40 lines.
; With some editors on certain platforms the variable editor must
; be defined as shown above.
;
; Some application which require a text editor may be using the UNIX
; variable EDITOR instead of the SKILL variable editor. It is a good
; idea to set the UNIX variable EDITOR to the text editor of your
; choice which will automatically set the SKILL variable editor.
; 
;
;setPrompts("Ready >" "")
;editor = "xterm -geometry 85x50 -e vi";
;
;
printf("END OF SITE CUSTOMIZATION\n")
;
;
;################################################
;#                                           
;# LOAD USER CUSTOMIZATION FILE 
;#
;################################################
;
;The site customization file is going to load the user
;customization file. In case you have copied this site
;customization file as your user customization file
;comment out or remove the next section to prevent
;recursive loading of ./.cdsinit
;
;if( isFile( "./.cdsinit" ) then
;    printf( "Loading ./.cdsinit init file from the site init file.\n" )
;    loadi( "./.cdsinit" )
;else
; if( isFile( "~/.cdsinit" ) then
;    printf( "Loading $HOME/.cdsinit init file from the site init file.\n" )
;    loadi( "~/.cdsinit" )
; )
;)
;
;END OF THE SITE CUSTOMIZATION FILE


/*
;;################################################
;;## 下面是我们的自定义设置
;;################################################
*/


/*
下面是 .cdsinit 配置内容 (截至 2025.07.14), 来源于知乎作者 https://www.zhihu.com/people/YiDingg
直接将本段代码粘贴到 .cdsinit 文件 即可 (覆盖全部原内容), 另外, 后加载的代码可覆盖先加载的代码

本配置代码前半部分来自示例文件 <Cadence_Install_Directory>/tools/dfII/samples/local.cdsinit>, 后半部分是我们的自定义配置, 另外还注释了几行示例部分的代码以避免无限循环导致软件卡死
*/

; None<Btn2Down> 是中键
hiSetBindKeys("Schematics" list(
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
        ; list("<Key>d" "cancelEnterFun()")                     ; d 取消, 用作 esc 的替代 (esc 太远了)
    list("None<Btn3Down>" "" "cancelEnterFun()")            ; 鼠标右键用作 esc (esc 太远了)
    list("None<Btn3Down>(2)" "" "")                         ; 删除原有的冗余右键绑定
    list("Ctrl<Key>c" "schHiCopy()")                        ; Ctrl + C 复制
    list("<Key>d" "schHiCreateNoteShape()")                 ; 按键 D 创建注释和 drawing (原本是按键 n 的默认功能)
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
    list("None<Btn4Down>" "geScroll(nil \"n\" nil)")    ; 鼠标滚轮上滑, 界面上移:
    list("None<Btn5Down>" "geScroll(nil \"s\" nil)")    ; 鼠标滚轮下滑, 界面下移:
    list("Ctrl<Btn4Down>" "hiZoomInAtMouse()")          ; Ctrl + 鼠标滚轮上滑, 放大界面:
    list("Ctrl<Btn5Down>" "hiZoomOutAtMouse()")         ; Ctrl + 鼠标滚轮下滑, 缩小界面:
    list("Ctrl<Key>Z" "hiUndo()")                       ; Ctrl + Z, 撤销:
    list("Ctrl<Key>Y" "hiRedo()")                       ; Ctrl + Y, 重做:
    list("<Key>space" "schSetEnv(\"rotate\" t)")        ; 空格旋转
    list("Ctrl<Key>s" "schHiVICAndSave()")              ; Ctrl + S 检查与保存 (与 schematic 中的命令不同)
    list("<Key>x" "schSetEnv(\"sideways\" t)")          ; x 翻转
        ; list("<Key>d" "cancelEnterFun()")                 ; d 取消, 用作 esc 的替代 (esc 太远了)
        ; None<Btn2Down> 是中键 
    list("None<Btn3Down>" "" "cancelEnterFun()")        ; 鼠标右键用作 esc (esc 太远了)
    list("None<Btn3Down>(2)" "" "")                     ; 删除原有的冗余右键绑定
    list("Ctrl<Key>c" "schHiCopy()")                    ; Ctrl + C 复制
    list("<Key>d" "schHiCreateNoteShape()")             ; 按键 D 创建注释和 drawing (原本是按键 n 的默认功能)
	)
)

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
    list("Shift<Key>s" "leHiStretch()")                      ; Shift + s 进行拉伸
	)
)

; 设置 label, text, ciw 的字体和字号, 如果 "roman" 不起作用改为 "times" 即可
hiSetFont( "ciw" ?name "mono" ?size 18 ?bold nil ?italic nil ) ; "mono" 即为 "monospace"
hiSetFont( "label" ?name "Open Sans" ?size 14 ?bold nil ?italic nil ) ; "label" 既是 toolbar 的字体, 也是打开某些设置界面的字体, 因此 "label" 字号不宜过大, 否则会导致表单文字重叠
hiSetFont( "text" ?size 15 ?bold nil ?italic nil ) ; text 是各表单内部白色背景里的文字

; 设置 log filter 的默认输出
; hiSetFilter() ; 此命令是打开 log filter 窗口
hiSetFilterForm->accelInput->value= t   ; 将默认不输出的值全部勾选为输出
; hiSetFilterForm->accelRetval->value= t ; 这个没啥必要
hiSetFilterForm->promptOutput->value= t
_hiFormApplyCB(hiSetFilterForm)     ; 应用已修改的 log filter 结构体


; 将 Calibre 集成到 Cadence Virtuoso 工具栏
skillPath=getSkillPath();
setSkillPath(append(skillPath list("/opt/eda/mentor/calibre2019/aoj_cal_2019.3_15.11/lib"))); the installing path of your Calibre
load("calibre.OA.skl");

; 其它设置
; editor="gedit" ; 设置 Cadence 中默认文本编辑器为 gedit (script 和 verilog-A 的编辑器), 可选的通常有 vim, gedit, emacs, atom
; ExportImageDialog->fileName->value = "/home/IC/a_Win_VM_shared/a_Misc/schematic.png" ; 设置 schematic 导出为 image 时的默认路径
dbSetAutoSave(t 20) ; 设置自动保存时间, 单位是 second (秒), 但是这行好像没有什么作用
hiResizeWindow(window(1) list(400:0 1800:1000)) ; 设置初始 CIW 窗口的大小和位置, 其中 400:150 代表窗口左下角坐标，1200:600 代表窗口右上角坐标
```

上面给出的 `.cdsinit` 代码，看似很长，但大部分都是示例文件中自带的代码，真正起作用的是文件的后半部分：

``` bash
/*
下面是 .cdsinit 配置内容 (截至 2025.07.14), 来源于知乎作者 https://www.zhihu.com/people/YiDingg
直接将本段代码粘贴到 .cdsinit 文件 即可 (覆盖全部原内容), 另外, 后加载的代码可覆盖先加载的代码

本配置代码前半部分来自示例文件 <Cadence_Install_Directory>/tools/dfII/samples/local.cdsinit>, 后半部分是我们的自定义配置, 另外还注释了几行示例部分的代码以避免无限循环导致软件卡死
*/

; None<Btn2Down> 是中键
hiSetBindKeys("Schematics" list(
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
        ; list("<Key>d" "cancelEnterFun()")                     ; d 取消, 用作 esc 的替代 (esc 太远了)
    list("None<Btn3Down>" "" "cancelEnterFun()")            ; 鼠标右键用作 esc (esc 太远了)
    list("None<Btn3Down>(2)" "" "")                         ; 删除原有的冗余右键绑定
    list("Ctrl<Key>c" "schHiCopy()")                        ; Ctrl + C 复制
    list("<Key>d" "schHiCreateNoteShape()")                 ; 按键 D 创建注释和 drawing (原本是按键 n 的默认功能)
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
    list("None<Btn4Down>" "geScroll(nil \"n\" nil)")    ; 鼠标滚轮上滑, 界面上移:
    list("None<Btn5Down>" "geScroll(nil \"s\" nil)")    ; 鼠标滚轮下滑, 界面下移:
    list("Ctrl<Btn4Down>" "hiZoomInAtMouse()")          ; Ctrl + 鼠标滚轮上滑, 放大界面:
    list("Ctrl<Btn5Down>" "hiZoomOutAtMouse()")         ; Ctrl + 鼠标滚轮下滑, 缩小界面:
    list("Ctrl<Key>Z" "hiUndo()")                       ; Ctrl + Z, 撤销:
    list("Ctrl<Key>Y" "hiRedo()")                       ; Ctrl + Y, 重做:
    list("<Key>space" "schSetEnv(\"rotate\" t)")        ; 空格旋转
    list("Ctrl<Key>s" "schHiVICAndSave()")              ; Ctrl + S 检查与保存 (与 schematic 中的命令不同)
    list("<Key>x" "schSetEnv(\"sideways\" t)")          ; x 翻转
        ; list("<Key>d" "cancelEnterFun()")                 ; d 取消, 用作 esc 的替代 (esc 太远了)
        ; None<Btn2Down> 是中键 
    list("None<Btn3Down>" "" "cancelEnterFun()")        ; 鼠标右键用作 esc (esc 太远了)
    list("None<Btn3Down>(2)" "" "")                     ; 删除原有的冗余右键绑定
    list("Ctrl<Key>c" "schHiCopy()")                    ; Ctrl + C 复制
    list("<Key>d" "schHiCreateNoteShape()")             ; 按键 D 创建注释和 drawing (原本是按键 n 的默认功能)
	)
)

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
    list("Shift<Key>s" "leHiStretch()")                       ; Shift + s 进行拉伸
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
hiSetFilterForm->promptOutput->value= t
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

```



### 2.2 基本语法

Cadence Virtuoso 使用 SKILL 语言进行配置和扩展，要自行修改 `.cdsinit` 和 `.cdsenv` 文件，需要先知道一些基本语法规则：

``` bash
; 分号是单行注释符号，可以单独使用 ; 或多写几个 ;;; 增强可读性

/*
这是类似 C 语言的多行注释符号
多行注释符号
多行注释符号
*/ 

hiSetBindKeys("Layout"  "None<Btn4Down>" "geScroll(nil \"n\" nil)")
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


### 2.3 命令定义


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





## 3. 配置效果一览

最明显的效果就是波形界面的美观性和可读性得到了显著提升，如下：

修改前：
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-14-16-51-20_Use Virtuoso Efficiently - 1. Shortcuts and Initialization.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-14-16-54-59_Use Virtuoso Efficiently - 1. Shortcuts and Initialization.png"/></div>


修改后：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-14-16-57-04_Use Virtuoso Efficiently - 1. Shortcuts and Initialization.png"/></div>


## 4. 参考资料

如果读者想要自行配置 Cadence Virtuoso, 或者在上文的基础上进行修改, 可以参考以下资料：
- [Virtuoso® Schematic Editor SKILL Functions Reference](<https://picture.iczhiku.com/resource/eetop/sykRGZGTDTSiYmCv.pdf>)
- [University of Southern California: Cadence Virtuoso Tutorial](https://ee.usc.edu/~redekopp/ee209/virtuoso/setup/USCVLSI-VirtuosoTutorial.pdf)
- [.cdsenv Tips & Tricks](https://aselshim.github.io/blogposts/2019-03-21-cdsenv/)
- [Cadence Tips and Tricks: Change Waveform Graph windows default settings](https://wikis.ece.iastate.edu/vlsi/index.php?title=Tips_%26_Tricks)
- [Bilibili: Cadence IC ADE 仿真学习笔记- 配置文件](https://www.bilibili.com/video/BV15T42197PQ)
- [Setting Bind Keys in Cadence Virtuoso Using SKILL Code](https://analoghub.ie/category/skill/article/skillBindkeysSetup)
