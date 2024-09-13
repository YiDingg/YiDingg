# C Notes (1): Before Starting

## 环境配置

### C语言版本

C语言起始于 K＆R C(1978年)，经历过ANSI(C89,C90), C95, C99, C11, C17 等多种版本的发展。目前的版本为C23 (2024.7.1)


### 编译器
    
C 语言是一种编译型语言，源码都是文本文件，本身无法执行。必须通过编译器，生成二进制的可执行文件，才能执行。编译器将代码从文本翻译成二进制指令的过程，就称为编译阶段，又称为“编译时”（compile time），跟运行阶段（又称为“运行时”）相区分。

目前，最常见的 C 语言编译器是自由软件基金会推出的 GCC 编译器，它可以免费使用。Linux 和 Mac 系统可以直接安装 GCC，Windows 系统可以安装 MinGW (GCC的Windows版本)。但是，也可以不用这么麻烦，网上有在线编译器，能够直接在网页上模拟运行 C 代码，查看结果，下面就是两个这样的工具。

- [CodingGround](https://tutorialspoint.com/compile_c_online.php)
- [OnlineGDB](https://onlinegdb.com/online_c_compiler)

我这里已经下载并配置好了Visual Studio 2022，但考虑到更喜欢用 VSCode，还是下载了MinGW。参考 <!--  [CSDN](https://blog.csdn.net/su272009/article/details/138245549)  --> [CSDN](https://blog.csdn.net/weixin_52159554/article/details/134406628)进行下载和安装，然后配置环境变量，安装 C/C++ 插件，即可开始编写 C 代码。


### GCC编译

编译语法是`gcc [parameters] filename_1.c filename_2.c`，执行语法是`./{outputname}`。

例如`gcc filename.c` + `./a.out`，又如`gcc -std=c99 -o hello filename_1.c filename_2.c` + `./hello`。

- `-o`(Output): 指定编译产物文件名
- `-std=`(Standard): 指定编译标准


### C/C++ 环境配置

对于仅编译一个`.c`或`.cpp`文件的情况，推荐插件 Code Runner。它支持运行 C, C++, Java, JavaScript, PHP, Python, Go, PowerShell 等多种语言（即下面的方案一）。
但是，考虑到之后的学习/使用会遇到多个`.c`和`.h`文件，甚至有`.c`和`.cpp`文件混合的情况，我们不如直接配置VSCode中的C/C++ 编译、debug环境，使得所有文件可以同时被编译（即下面的方案三）。

我们有几种方案：

1. 使用Code Runner插件，只运行当前文件
2. 手动配置VSCode的`.json`文件，编译当前/多个文件
3. 使用VCDode的CMake插件，编译当前/多个文件 (更方便)

推荐第三种方案，步骤见下。

### CMake 与 C/C++ Debug 环境配置

下面在 VSCode 中配置 C/C++ 编译、debug 环境，以及 CMake 环境。

- 到 [CMake 官网](https://cmake.org/)下载并安装 CMake.
- 创建一个新项目（文件夹），用 VSCode 打开，在项目（文件夹）根目录下，创建`src`和`inc`文件夹，分别用于存放`.c`、`.h`文件。 
- 在项目根目录创建名为 `CMakeLists.txt` 的文件，将下面的代码复制到 `CMakeLists.txt` 文件中。

``` bash
# CMakeLists.txt

cmake_minimum_required(VERSION 2.8...3.13)                      # 设定Cmake的最低版本要求
project(main)                                                   # 项目名称，可以和文件夹名称不同
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/inc)            #添加头文件
file(GLOB_RECURSE SOURCES src/*.c src/*.cpp)                    # 引入src下的所有.c文件和.cpp文件, 命名 SOURCES 变量来表示多个源文件
add_executable(main ${SOURCES})                                 # 生成可执行文件 main.exe (可执行文件名 自己定义就行)

set(CMAKE_CXX_STANDARD 11)                                      # 指定 C++ 标准为 C11
set(CMAKE_CXX_STANDARD_REQUIRED True)                           # 使用指定的 C++ 标准
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -Wall -O2 ")         # 设定编译选项
set(EXECUTABLE_OUTPUT_PATH  ${CMAKE_CURRENT_SOURCE_DIR}/bin)    # 将生成的可执行文件保存至bin文件夹中
set(CMAKE_CXX_COMPILER "g++")                                   # 设定编译器


# 对于 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -Wall -O2 ")         # 设定编译选项
#-g：这个选项告诉编译器生成调试信息。调试信息对于使用调试器（如 GDB）来跟踪程序执行、查看变量值和调用堆栈等非常有用。当编译程序以进行调试时，通常会包含此选项。
#-Wall：这个选项指示编译器显示所有警告信息。默认情况下，编译器可能只显示它认为最重要的警告，但使用 -Wall 可以确保显示所有可用的警告，帮助开发者发现潜在的代码问题。
#-O2：这个选项启用了编译器优化，其中 2 表示中等程度的优化。编译器会尝试通过改变代码的布局、删除未使用的变量和代码、改进循环等方式来提高程序的运行效率。不同的编译器可能以不同的方式实现这些优化，但 -O2 通常是一个很好的起点，因为它提供了性能提升而不会引入过多的编译时间开销。
```


- 然后，打开 main.c 文件，点击窗口右上角的小齿轮按钮，选择 “C/C++: gcc.exe 生成和调试活动文件”，如下图所示。点击之后，VSCode 会自动生成 `.vscode` 文件夹，其中有 `launch.json` 和 `tasks.json` 两个文件。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-13-20-03-32_CNotes(1)-BeforeStarting.png"/></div>

- 到刚刚生成的两个文件，也即 `launch.json` 和 `tasks.json`，删去全部内容，并将下面的代码分别复制进去。


``` json 
/* launch.json */

{
    // 使用 IntelliSense 了解相关属性。
    // 悬停以查看现有属性的描述。
    // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug (gdb)",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/bin/main.exe",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${fileDirname}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            /* 
            下面是 gdb (mingw) 可执行文件的路径
            例如我的是 C:/aa_Same/mingw64/bin/gdb.exe 
            */
            "miDebuggerPath": "C:/aa_Same/mingw64/bin/gdb.exe",
            /* 上面是 gdb (mingw) 可执行文件的路径 */
            "setupCommands": [
                {
                    "description": "为 gdb 启用整齐打印",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                },
                {
                    "description": "将反汇编风格设置为 Intel",
                    "text": "-gdb-set disassembly-flavor intel",
                    "ignoreFailures": true
                }
            ] /* 下面要和tasks.json中的任务名称一致，但是报错，退出代码127，尚未解决 */
            /* "preLaunchTask": "build active file" */
        }
    ]
}
```

``` json 
/* tasks.json */

{
    "version": "2.0.0",
    "options": {
        "cwd": "${workspaceFolder}/build"
    },
    "tasks": [
        {
            "type": "shell",
            "label": "cmake",
            "command": "cmake",
            "args": [".."]
        },
        {
            "label": "make",
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "command": "mingw32-make.exe",
            "args": []
        },
        {
            "label": "build active file",
            "dependsOn": ["cmake", "make"]
        }
    ]
}
```

- 配置 `launch.json` 中的编译器路径，例如我的路径为`"miDebuggerPath": "D:/aa_my_apps_main/mingw64/bin/gdb.exe"`。
- 点击 “运行和调试” --> “CMake 调试程序” 以激活CMake配置。也可以在`CMakelists.txt`按下 ctrl + s，VSCode 会自动刷新CMake配置。

至此编译和 debug 环境配置完成，可以进行编译、debug 操作：

- 编译并运行：点击下方的“生成”按钮以编译，点击三角形按钮“启动”以编译并运行可执行文件。
- 启动 debug: 建议再添加`.clang-format`文件以自动格式化`C/C++`代码，详见后文“### 代码格式化配置”

另外，如果在编译时遇到报错“undefined reference to”、“fatal error: No such file or directory”或“error: ld returned 1 exit status”，到 `CMakelists.txt`文件 ctrl + s 刷新配置，再行编译即可。



同时编译`.c`和`.cpp`文件的环境示例见 [here](https://www.writebug.com/static/uploads/2024/7/25/bb0cfac41d5d26b1d9e32b4b4cf9f5a4.zip)。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-25-21-50-33_CNotes(1)-BeforeStarting.jpg"/></div>


Cmake的详细教程可以参考 [爱编程的大丙](https://subingwen.cn/cmake/CMake-primer/?highlight=cmake)，这里不提。

在不同设备间同步代码时，由于 CMakeLists.txt 文件路径可能不同，编译时会报错如下：

``` output
CMake Error: The current CMakeCache.txt directory D:/aa_MyRemoteRepo/GH.Gomoku/build/CMakeCache.txt is different than the directory d:/a_RemoteRepo/GH.Gomoku/build where CMakeCache.txt was created.
```

只需找到 build --> CMakeCache.txt 文件，将其删除然后刷新配置即可。

### 代码格式化配置

在 settings.json文件中，添加以下内容：
```json
"[c]": {
    "editor.defaultFormatter": "ms-vscode.cpptools"
},
/* 若根文件夹无 .clang-format 文件，则会自动使用以下配置 */
"C_Cpp.clang_format_fallbackStyle": "{BasedOnStyle: LLVM, UseTab: Never, IndentWidth: 4, TabWidth: 4, BreakBeforeBraces: Attach, AllowShortIfStatementsOnASingleLine: false, IndentCaseLabels: false, ColumnLimit: 0, AccessModifierOffset: -4, NamespaceIndentation: All, FixNamespaceComments: false, PointerAlignment: Left}"
```

若需要更详细的格式化，在项目根目录下创建`.clang-format`文件，并添加以下内容：
```txt
# 语言: None, Cpp, Java, JavaScript, ObjC, Proto, TableGen, TextProto
Language: Cpp
# BasedOnStyle:    LLVM

# 访问说明符(public、private等)的偏移
AccessModifierOffset: -4

# 开括号(开圆括号、开尖括号、开方括号)后的对齐: Align, DontAlign, AlwaysBreak (总是在开括号后换行)
AlignAfterOpenBracket: AlwaysBreak

# 连续赋值时，对齐所有等号
AlignConsecutiveAssignments: false

# 连续声明时，对齐所有声明的变量名
AlignConsecutiveDeclarations: false

# 右对齐逃脱换行(使用反斜杠换行)的反斜杠
AlignEscapedNewlines: Right

# 水平对齐二元和三元表达式的操作数
AlignOperands: true

# 对齐连续的尾随的注释
AlignTrailingComments: true

# 不允许函数声明的所有参数在放在下一行
AllowAllParametersOfDeclarationOnNextLine: false

# 不允许短的块放在同一行
AllowShortBlocksOnASingleLine: true

# 允许短的case标签放在同一行
AllowShortCaseLabelsOnASingleLine: true

# 允许短的函数放在同一行: None, InlineOnly(定义在类中), Empty(空函数), Inline(定义在类中，空函数), All
AllowShortFunctionsOnASingleLine: None

# 允许短的if语句保持在同一行
AllowShortIfStatementsOnASingleLine: true

# 允许短的循环保持在同一行
AllowShortLoopsOnASingleLine: true

# 总是在返回类型后换行: None, All, TopLevel(顶级函数，不包括在类中的函数), 
# AllDefinitions(所有的定义，不包括声明), TopLevelDefinitions(所有的顶级函数的定义)
AlwaysBreakAfterReturnType: None

# 总是在多行string字面量前换行
AlwaysBreakBeforeMultilineStrings: false

# 总是在template声明后换行
AlwaysBreakTemplateDeclarations: true

# false表示函数实参要么都在同一行，要么都各自一行
BinPackArguments: false

# false表示所有形参要么都在同一行，要么都各自一行
BinPackParameters: false

# 大括号换行，只有当BreakBeforeBraces设置为Custom时才有效
BraceWrapping:
  # class定义后面
  AfterClass: false
  # 控制语句后面
  AfterControlStatement: false
  # enum定义后面
  AfterEnum: false
  # 函数定义后面
  AfterFunction: false
  # 命名空间定义后面
  AfterNamespace: false
  # struct定义后面
  AfterStruct: false
  # union定义后面
  AfterUnion: false
  # extern之后
  AfterExternBlock: false
  # catch之前
  BeforeCatch: false
  # else之前
  BeforeElse: false
  # 缩进大括号
  IndentBraces: false
  # 分离空函数
  SplitEmptyFunction: false
  # 分离空语句
  SplitEmptyRecord: false
  # 分离空命名空间
  SplitEmptyNamespace: false

# 在二元运算符前换行: None(在操作符后换行), NonAssignment(在非赋值的操作符前换行), All(在操作符前换行)
BreakBeforeBinaryOperators: NonAssignment

# 在大括号前换行: Attach(始终将大括号附加到周围的上下文), Linux(除函数、命名空间和类定义，与Attach类似), 
#   Mozilla(除枚举、函数、记录定义，与Attach类似), Stroustrup(除函数定义、catch、else，与Attach类似), 
#   Allman(总是在大括号前换行), GNU(总是在大括号前换行，并对于控制语句的大括号增加额外的缩进), WebKit(在函数前换行), Custom
#   注：这里认为语句块也属于函数
BreakBeforeBraces: Custom

# 在三元运算符前换行
BreakBeforeTernaryOperators: false

# 在构造函数的初始化列表的冒号后换行
BreakConstructorInitializers: AfterColon

#BreakInheritanceList: AfterColon

BreakStringLiterals: false

# 每行字符的限制，0表示没有限制
ColumnLimit: 120

CompactNamespaces: true

# 构造函数的初始化列表要么都在同一行，要么都各自一行
ConstructorInitializerAllOnOneLineOrOnePerLine: false

# 构造函数的初始化列表的缩进宽度
ConstructorInitializerIndentWidth: 4

# 延续的行的缩进宽度
ContinuationIndentWidth: 4

# 去除C++11的列表初始化的大括号{后和}前的空格
Cpp11BracedListStyle: true

# 继承最常用的指针和引用的对齐方式
DerivePointerAlignment: false

# 固定命名空间注释
FixNamespaceComments: true

# 缩进case标签
IndentCaseLabels: false

IndentPPDirectives: None

# 缩进宽度
IndentWidth: 4

# 函数返回类型换行时，缩进函数声明或函数定义的函数名
IndentWrappedFunctionNames: false

# 保留在块开始处的空行
KeepEmptyLinesAtTheStartOfBlocks: false

# 连续空行的最大数量
MaxEmptyLinesToKeep: 1

# 命名空间的缩进: None, Inner(缩进嵌套的命名空间中的内容), All
NamespaceIndentation: None

# 指针和引用的对齐: Left, Right, Middle
PointerAlignment: Left

# 允许重新排版注释
ReflowComments: true

# 允许排序#include
SortIncludes: false

# 允许排序 using 声明
SortUsingDeclarations: false

# 在C风格类型转换后添加空格
SpaceAfterCStyleCast: false

# 在Template 关键字后面添加空格
SpaceAfterTemplateKeyword: true

# 在赋值运算符之前添加空格
SpaceBeforeAssignmentOperators: true

# SpaceBeforeCpp11BracedList: true

# SpaceBeforeCtorInitializerColon: true

# SpaceBeforeInheritanceColon: true

# 开圆括号之前添加一个空格: Never, ControlStatements, Always
SpaceBeforeParens: ControlStatements

# SpaceBeforeRangeBasedForLoopColon: true

# 在空的圆括号中添加空格
SpaceInEmptyParentheses: false

# 在尾随的评论前添加的空格数(只适用于//)
SpacesBeforeTrailingComments: 1

# 在尖括号的<后和>前添加空格
SpacesInAngles: false

# 在C风格类型转换的括号中添加空格
SpacesInCStyleCastParentheses: false

# 在容器(ObjC和JavaScript的数组和字典等)字面量中添加空格
SpacesInContainerLiterals: true

# 在圆括号的(后和)前添加空格
SpacesInParentheses: false

# 在方括号的[后和]前添加空格，lamda表达式和未指明大小的数组的声明不受影响
SpacesInSquareBrackets: false

# 标准: Cpp03, Cpp11, Auto
Standard: Cpp11

# tab宽度
TabWidth: 4

# 使用tab字符: Never, ForIndentation, ForContinuationAndIndentation, Always
UseTab: Never
```

## 基础内容

### 语句

最基本的语句我们不再赘述，这里简要提几点。

- 单个分号：`;`也是有效语句，称为“空语句”，虽然毫无作用。
- 语句块：C 语言允许多个语句被一对大括号`{}`所包围，构成一个块(大括号的结尾不需要添加分号。)，也称为复合语句（compounded statement）。在语法上，语句块可以视为多个语句构成的复合语句。
- 注释：语句内部可以插入注释，例如`int open(char* s /*file name*/, int mode);`，但不管哪一种注释，都不能放在双引号中。
- 注释编译：会被替换成一个空格，所以`min/*space*/Value`会变成`min Value`，而不是`minValue`。
- 赋值：赋值表达式有返回值(返回右值)，因此`x = y = z = 10;`是合法的多重赋值表达式。
- 自增运算符位置：`++var`先加法再返回，`var++`先返回再加法。
- 真伪：C 语言中，`0`表示伪，所有非零值表示真。
- 关系运算符：`i < j < k`等价于`(i < j) < k`
- 位运算符：`^` `&` `|` `<<` `>>`
- 逗号运算符：返回最后一个表达式的值，作为整个语句的值，例如`int x = 1, 2, 3;`$\Longleftrightarrow$`int x = (1, 2, 3);`$\Longleftrightarrow$`int x = 3;`

### Printf占位符

`printf()`占位符：

- `%a`：十六进制浮点数，字母输出为小写。
- `%A`：十六进制浮点数，字母输出为大写。
- `%c`：字符。
- `%d`：十进制整数。
- `%e`：使用科学计数法的浮点数，指数部分的`e`为小写。
- `%E`：使用科学计数法的浮点数，指数部分的`E`为大写。
- `%i`：整数，基本等同于`%d`。
- `%f`：小数（包含`float`类型和`double`类型）。
- `%g`：6个有效数字的浮点数。整数部分一旦超过6位，就会自动转为科学计数法，指数部分的`e`为小写。
- `%G`：等同于`%g`，唯一的区别是指数部分的`E`为大写。
- `%hd`：十进制 short int 类型。
- `%ho`：八进制 short int 类型。
- `%hx`：十六进制 short int 类型。
- `%hu`：unsigned short int 类型。
- `%ld`：十进制 long int 类型。
- `%lo`：八进制 long int 类型。
- `%lx`：十六进制 long int 类型。
- `%lu`：unsigned long int 类型。
- `%lld`：十进制 long long int 类型。
- `%llo`：八进制 long long int 类型。
- `%llx`：十六进制 long long int 类型。
- `%llu`：unsigned long long int 类型。
- `%Le`：科学计数法表示的 long double 类型浮点数。
- `%Lf`：long double 类型浮点数。
- `%n`：已输出的字符串数量。该占位符本身不输出，只将值存储在指定变量之中。
- `%o`：八进制整数。
- `%p`：指针。
- `%s`：字符串。
- `%u`：无符号整数（unsigned int）。
- `%x`：十六进制整数。
- `%zd`：`size_t`类型。
- `%%`：输出一个百分号。

### 运算符优先级

运算符的优先级顺序较为复杂。下面是部分运算符的优先级顺序（按照优先级从高到低排列）。

- 圆括号`()`
- 一元运算符`++`、`--`、`!`、`~`
- 乘法`*`，除法`/`
- 加法`+`，减法`-`
- 关系运算符`<`、`>`等
- 赋值运算符`=`

完全没有必要记住所有运算符的优先级，解决方法是多用圆括号，防止出现意料之外的情况，也有利于提高代码的可读性。

一个需要辨析的例子是`*p++`与`(*p)++`，前者改变`p`的值，后者改变`*p`的值。


### 流程控制

C 语言的程序是顺序执行，即先执行前面的语句，再执行后面的语句。开发者如果想要控制程序执行的流程，就必须使用流程控制的语法结构，主要是条件执行和循环执行。

此部分略，详情可参考 [网道: C语言](https://wangdoc.com/clang/flow-control#dowhile-%E7%BB%93%E6%9E%84)








