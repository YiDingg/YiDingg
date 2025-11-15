# Verilog - 1. Environment Setup

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 12:30 on 2025-10-09 in Beijing.

## Introduction

本文，我们就来完成 Verilog 的环境搭建工作，包括 iverilog 和 vivado 两款软件的安装与配置。

## 1. Icarus Verilog

### 1.1 installation

到 Icarus Verilog (iverilog) 的官方网址 https://bleyer.org/icarus/ 下载 Windows 版本的安装包 `iverilog-v12-20220611-x64_setup.exe` [18.2MB]，双击进行安装。

安装过程很简单，双击安装程序启动安装，注意勾选添加系统环境变量 `Add executable folder(s) to the user PATH`，然后一路 next 即可。注意安装路径中不要有任何中文和空格。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-12-52-54_Verilog - 1. Environment Setup.png"/></div>

安装完成后在命令行中输入以下内容，能够看到版本信息，说明安装成功：

``` bash
iverilog -v
gtkwave -v
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-14-36-41_Verilog - 1. Environment Setup.png"/></div>


为了使用 makefile 来管理编译和仿真过程，我们还需要下载 [Make for Windows](https://gnuwin32.sourceforge.net/packages/make.htm)。参考这篇文章 [知乎 > 在 windows 上安装 make](https://zhuanlan.zhihu.com/p/630244738), 官方下载链接在 https://gnuwin32.sourceforge.net/packages/make.htm, 我们这里下载的是 version 3.81, 如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-14-52-54_Verilog - 1. Environment Setup.png"/></div>

如果下载速度太慢，可以到阿里云镜像网址 https://mirrors.aliyun.com/gnu/make/ 进行下载。

安装后注意手动添加环境变量路径，如果未修改安装目录，默认是 `C:\Program Files (x86)\GnuWin32\bin`，完成后重启命令行并输入 `make -v`, 检查是否安装成功：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-15-00-54_Verilog - 1. Environment Setup.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-15-01-19_Verilog - 1. Environment Setup.png"/></div>



### 1.2 vscode + iverilog

接下来，我们便在 VScode 中配置 iverilog 的运行环境，先在 VScode 中安装这个插件：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-14-24-45_Verilog - 1. Environment Setup.png"/></div>

进行一些 Verilog 插件的设置：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-16-06-41_Verilog - 1. Environment Setup.png"/></div>


随后构建项目结构如下：

``` bash
├── adder.v
└── tb_adder.v
```

将下列代码依次填入 `adder.v` 和 `tb_adder.v` 文件中：

``` verilog
// adder.v
// 1-bit adder

module adder(
    input  i_bit1,
    input  i_bit2,
    input  i_carry,
    output o_sum,
    output o_carry

    );
    assign o_sum   = i_bit1 ^ i_bit2 ^ i_carry;
    assign o_carry = ((i_bit1 ^ i_bit2) & i_carry) | (i_bit1 & i_bit2);

endmodule
```

``` verilog
// tb_adder.v
// Testbench for 1-bit adder

`include "adder.v" // Update the path if adder.v is in the parent directory, or provide the correct relative path

module tb_adder;

   reg in_bit1;
   reg in_bit2;
   reg in_car;
   wire out_car;
   wire out_res;

adder DUT (
    .i_bit1   (in_bit1),
    .i_bit2   (in_bit2),
    .i_carry  (in_car),
    .o_sum    (out_res),
    .o_carry  (out_car)
    );

initial begin

    in_bit1 = 1'b0;
    in_bit2 = 1'b0;
    in_car  = 1'b0;

    # 10
    in_bit1 = 1'b0;
    in_bit2 = 1'b0;
    in_car  = 1'b1;

    # 10
    in_bit1 = 1'b0;
    in_bit2 = 1'b1;
    in_car  = 1'b0;

    # 10
    in_bit1 = 1'b1;
    in_bit2 = 1'b0;
    in_car  = 1'b0;

    # 10
    in_bit1 = 1'b0;
    in_bit2 = 1'b1;
    in_car  = 1'b1;

    # 10
    in_bit1 = 1'b1;
    in_bit2 = 1'b0;
    in_car  = 1'b1;

    # 10
    in_bit1 = 1'b1;
    in_bit2 = 1'b1;
    in_car  = 1'b0;

    # 10
    in_bit1 = 1'b1;
    in_bit2 = 1'b1;
    in_car  = 1'b1;
    #10 $finish;

end

 // Monitor values of these variables and print them into the log file for debug
initial begin
    $monitor ("in_bit1 = %b, in_bit2 = %b, in_car= %b, out_car = %b, out_res = %b", in_bit1, in_bit2, in_car, out_car, out_res);  
    $dumpfile("tb_adder.vcd");
    $dumpvars; // dump all signal and show waves
end 

endmodule
```

然后在命令行输入以下命令进行编译，并利用 gtkwave 查看波形：

``` bash
iverilog -o tb_adder.out tb_adder.v
vvp tb_adder.out
gtkwave tb_adder.vcd
```

效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-16-20-53_Verilog - 1. Environment Setup.png"/></div>

到这里，最简单的 iverilog + vscode 环境就搭建完成了。


### 1.3 vscode + makefile

上面的例子中，任何编译、仿真和查看波形的命令都需要手动输入，比较麻烦。与 C 语言类似，我们希望用 makefile 来管理整个编译/仿真/查看波形的过程。

我们在 **1.1 installation** 小节就已经下载并安装好了 make, 这里直接构建项目结构如下：

``` bash
├── makefile
├── build
├── src
│   └── adder.v
└── test
    └── tb_adder.v
```


`adder.v` 的代码不变，但 `tb_adder.v` 稍有变化 (仅修改了 `$dumpfile("build/build.vcd");` 一行) 

``` verilog
//`include "src/adder.v"

module tb_adder;

   reg in_bit1;
   reg in_bit2;
   reg in_car;
   wire out_car;
   wire out_res;

adder DUT (     // module instantiation
    .i_bit1   (in_bit1),
    .i_bit2   (in_bit2),
    .i_carry  (in_car),
    .o_sum    (out_res),
    .o_carry  (out_car)
    );

initial begin

    in_bit1 = 1'b0;
    in_bit2 = 1'b0;
    in_car  = 1'b0;

    # 10
    in_bit1 = 1'b0;
    in_bit2 = 1'b0;
    in_car  = 1'b1;

    # 10
    in_bit1 = 1'b0;
    in_bit2 = 1'b1;
    in_car  = 1'b0;

    # 10
    in_bit1 = 1'b1;
    in_bit2 = 1'b0;
    in_car  = 1'b0;

    # 10
    in_bit1 = 1'b0;
    in_bit2 = 1'b1;
    in_car  = 1'b1;

    # 10
    in_bit1 = 1'b1;
    in_bit2 = 1'b0;
    in_car  = 1'b1;

    # 10
    in_bit1 = 1'b1;
    in_bit2 = 1'b1;
    in_car  = 1'b0;

    # 10
    in_bit1 = 1'b1;
    in_bit2 = 1'b1;
    in_car  = 1'b1;
    #10 $finish;

end

 // Monitor values of these variables and print them into the log file for debug
initial begin
    $monitor ("in_bit1 = %b, in_bit2 = %b, in_car= %b, out_car = %b, out_res = %b", in_bit1, in_bit2, in_car, out_car, out_res);  
    $dumpfile("build/build.vcd");
    $dumpvars; // dump all signal and show waves
end 

endmodule
```



然后将下列代码填入 `makefile` 文件中：

``` makefile
TARGET = build
SRC = $(wildcard src/*.v)
TEST_BENCH = $(wildcard test/*.v)
OBJ = build/$(TARGET).vvp
WAVE = build/$(TARGET).vcd

all: comp sim wave
vcd: comp sim


comp : $(SRC)
	@echo [comp] Compiling $(SRC)
	iverilog -o $(OBJ) $(SRC) $(TEST_BENCH)

sim : $(OBJ)
	@echo [sim] Running simulation
	vvp $(OBJ)

wave: $(WAVE)
	@echo [wave] Opening waveform
	gtkwave $(WAVE)

clean:
	@echo [clean] Cleaning up
	rm -f build/*
```

现在就可以愉快地使用 makefile 了，在命令行输入 `make all` 或其它设置好的命令，效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-16-53-51_Verilog - 1. Environment Setup.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-16-57-17_Verilog - 1. Environment Setup.png"/></div>

**<span style='color:red'> 这里如果遇到报错 `makefile:16: *** 遗漏分隔符 。 停止。` 或者 `makefile:16: *** 閬楁紡鍒嗛殧绗?銆?`，是因为 makefile 中的缩进使用了空格而不是制表符 `Tab`。 </span>** Make 对制表符 Tab 非常严格，不允许用空格替代任何制表符。VScode 可以在右下角 `空格: 4` 或者 `制表符: 4` 中查看当前缩进使用的是哪一种，如果是空格，将其改为制表符后，把 `makefile` 文件中的所有空格缩进全部替换为制表符缩进即可。

如果想用其他项目结构，也可以仿照上面代码进行编写，思路是完全类似的。


### 1.4 iverilog tips

### references


- [知乎 > 在 windows 上安装 make](https://zhuanlan.zhihu.com/p/630244738)
- [Bilibili > 在 vscode 下用 DIDE 优雅的使用 vivado || All your need for FPGA&IC: Digital-IDE v0.4.3](https://www.bilibili.com/video/BV1ftXnYfEu1)
- [Bilibili > 写代码也可以很享受——基于 VS Code 的 Verilog 编写环境搭建](https://www.bilibili.com/video/BV1Ww411Z7NA)
- [知乎 > 轻量级 verilog 仿真环境搭建](https://zhuanlan.zhihu.com/p/685632238)
- [知乎 > 在 windows 上的快速 verilog 仿真工具——Icarus Verilog--安装篇](https://zhuanlan.zhihu.com/p/436976157)
- [知乎 > 在 windows 上的快速 verilog 仿真工具——Icarus Verilog--使用篇](https://zhuanlan.zhihu.com/p/437665412)
- [知乎 > 开源 verilog 仿真工具 iverilog + GTKWave 初体验](https://zhuanlan.zhihu.com/p/163379637)
- [知乎 > iverilog + vscode 配置 (推荐一个既能写 verilog 又能仿真看波形的软件 vscode) ](https://zhuanlan.zhihu.com/p/593091162)
- [知乎 > 走近 FPGA 之工具篇 (上) -- Vivado](https://zhuanlan.zhihu.com/p/152589392)
- [知乎 > vivado + vscode 配置](https://www.zhihu.com/question/266342337/answer/121775711093)

## 2. Vivado

### 2.1 installation (failed)

数电张德生老师提供的是 vivado 2019.1:
- [百度网盘 > Vivado 2019.1](https://pan.baidu.com/share/init?surl=soW4faU6McdAvpIebV7sMA&pwd=0ygk) (提取码 0ygk)
- [Vivado 安装步骤.docx](https://www.writebug.com/static/uploads/2025/10/9/d9222b433b69583a6e0fc352961f8331.docx)

大致搜了一下，下面是一些可选的下载地址：
- [知乎 > Vivado 全版本下载分享](https://zhuanlan.zhihu.com/p/637955706): 提供了 Vivado 2017.4 ~ 2023.1 版本的下载链接，但不太清楚有没有带 license
- [知乎 > 有 Vivado 的下载链接吗？](https://www.zhihu.com/question/345565827/answer/117690612640): 这篇文章提到：如果你只需要烧录程序或调试硬件，不必安装数十 GB 的完整版！Lab Edition堪称“小而美”的解决方案：体积仅 1GB, 安装后占用约 2.4GB 空间，对硬盘空间友好。

综合考虑，我们还是到官网去下载。因为官网新旧版本都有，而且貌似只有 "企业版" 才需要收费。

接下来参考这两篇文章进行下载和安装：
- [CSDN > 【FPGA】Vivado 保姆级安装教程 | 从官网下载安装包开始到安装完毕 | 每步都有详细截图说明 | 支持无脑跟装](https://blog.csdn.net/weixin_50502862/article/details/126856879)
- [CSDN > FPGA 基础入门 【1】Vivado 官方免费版安装](https://blog.csdn.net/qimoDIY/article/details/86710618)


到官网注册好账号，然后找到下载页面 https://www.xilinx.com/support/download.html, 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-17-44-27_Verilog - 1. Environment Setup.png"/></div>

点击 Vivado Archive 可以找到更早的版本，我们选择最新的 2025.1 版本，下滑找到 **Vivado Lab Solutions Update 1 - 2025.1** 这个版本：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-17-53-15_Verilog - 1. Environment Setup.png"/></div>

这是今年九月份刚刚更新的版本，算是非常新了，并且总大小不到 2GB, 比较适合我们捉襟见肘的硬盘。从此版本的描述还可以发现 **Lab Edition requires no certificate or activation license key** ，不需要考虑 license 问题。

我们这里下载 windows 版本，点进去填写信息：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-17-58-52_Verilog - 1. Environment Setup.png"/></div>

呃，有点尴尬，好像 China 被出口管制了，不让我下载这个软件。按照这个视频 [Bilibili > Vivado 2023.2 安装](https://www.bilibili.com/video/BV1NuE2zBExh) 中的经验，似乎无需如实填写，但我们参考 [here](https://people-ece.vse.gmu.edu/coursewebpages/ECE/ECE448/S23/resources/Xilinx_Vivado_Installation_Instructions.pdf) 改了一下还是不行：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-18-20-33_Verilog - 1. Environment Setup.png"/></div>

又看到这篇文章 [CSDN > Vivado 下载问题](https://blog.csdn.net/weixin_65191557/article/details/133824577) 说，注册时最好用非国内的邮箱账号 (比如 outlook)，否则会在下载时遇到错误信息 `your account has failed export compliance verification`，看来是邮箱地址问题导致的。

### 2.2 installation (success)

唉，网上搜了一下也找不到 Lab Edition 的其它下载链接，只能凑合凑合在老师提供的链接上下载 2019.1 (windows + linux 完整版)：
- [百度网盘 > Vivado 2019.1](https://pan.baidu.com/share/init?surl=soW4faU6McdAvpIebV7sMA&pwd=0ygk) (提取码 0ygk)
- [Vivado 安装步骤.docx](https://www.writebug.com/static/uploads/2025/10/9/d9222b433b69583a6e0fc352961f8331.docx)


在淘宝上花三块钱弄一个 24h 的极速下载：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-18-44-53_Verilog - 1. Environment Setup.png"/></div>

下载完成后解压，双击 `xsetup.exe` 进行安装：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-18-54-07_Verilog - 1. Environment Setup.png"/></div>

如果双击后没有反应，可能是因为当前路径含有空格、中文字符或其它特殊字符，修改一下即可：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-19-02-01_Verilog - 1. Environment Setup.png"/></div>

这里仅提安装过程中的几个重要步骤，第一个是安装版本：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-19-04-56_Verilog - 1. Environment Setup.png"/></div>


- **Vivado HL WebPACK:** Vivado HL WebPACK is the no cost, device limited version of Vivado HL Design Edition. Users can optionally add Model Composer and System Generator for DSP to this installation.
- **Vivado HL Design Edition:** Vivado HL Design Edition includes the full complement of Vivado Design Suite tools for design, including C-based design with Vivado High-Level Synthesis, implementation, verification and device programming. Complete device support, cable drivers and Documentation Navigator are included. Users can optionally add Model Composer to this installation.
- **Vivado HL System Edition:** Vivado HL System Edition is a superset of Vivado HL Design Edition with the addition of System Generator for DSP. Complete device support, cable drivers and Documentation Navigator are included. Users can optionally add Model Composer to this installation.
- **Documentation Navigator (Standalone):** Xilinx Documentation Navigator (DocNav) provides access to Xilinx technical documentation both on the Web and on the Desktop. This is a standalone installation without Vivado Design Suite.

DeepSeek 给出的三个版本之间区别如下：

<div class='center'>

| 特性 / 版本 | **2019.1 WebPACK** | **2019.1 Design Edition** | **2019.1 System Edition** |
| :--- | :--- | :--- | :--- |
| **价格** | **免费** | **收费** | **收费 (最贵) ** |
| **支持的器件** | **有限制** | **完整支持** | **完整支持** |
| | 主要支持主流和中低端器件，如：<br>• Artix-7<br>• Kintex-7 (部分)<br>• Zynq-7000 (部分) | 支持所有Xilinx (AMD) 7系列及更新器件，包括：<br>• 所有 Artix-7, Kintex-7, Virtex-7<br>• Zynq-7000 (全部)<br>• UltraScale/UltraScale+<br>• Versal | 与 Design Edition 相同 |
| **核心工具** | 包含基础的FPGA设计和实现工具。 | **包含WebPACK所有功能**，并增加：<br>• **Vivado High-Level Synthesis (HLS)** <br>• 更高级的调试和分析工具 | **包含Design Edition所有功能**，并增加：<br>• **System Generator for DSP** |
| **高级工具 (可选安装)** | **可选**安装：<br>• Model Composer<br>• System Generator for DSP | **可选**安装：<br>• **Model Composer** | **可选**安装：<br>• **Model Composer** |
| **默认大小** | 30.05 GB | 44.13 GB | 44.32 GB |
</div>

显然，虽然老师给的安装教程是选择 System Edition, 但其实 WebPACK 就完全够用了。

选择 WebPACK 后，在可选安装项中设置如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-19-18-04_Verilog - 1. Environment Setup.png"/></div>

(System Generator for DSP 需要正版 MATLAB, 这里可以不选) 

然后设置一下安装路径：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-19-20-53_Verilog - 1. Environment Setup.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-19-21-07_Verilog - 1. Environment Setup.png"/></div>

等待安装完成即可：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-09-19-28-32_Verilog - 1. Environment Setup.png"/></div>



### 2.2 vivado usage

先创建工程，我们数电实验使用的是板子 `xc7a35 tcsg324 - 1`，即下图的最后一个：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-11-53-26_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>

创建之后的主界面如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-15-15-10_Verilog - 1. Environment Setup.png"/></div>


常用功能速查表（大概率会用到）：
<div class='center'>

| 功能        | 入口位置                                                    | 说明                                        |
| --------- | ------------------------------------------------------- | ----------------------------------------- |
| **新建工程**  | File → Project → New                                    | 第一步，选芯片型号（你的是 `xc7a35tcsg324-1`，Artix-7）。 |
| **添加源文件** | PROJECT MANAGER → Add Sources                           | 添加 `.v` 或 `.vhd` 文件，或约束文件 `.xdc`。         |
| **打开仿真**  | SIMULATION → Run Simulation → Run Behavioral Simulation | 快速跑行为级仿真（不依赖综合）。                          |
| **综合**    | SYNTHESIS → Run Synthesis                               | 把 RTL 转成门级网表。                             |
| **实现**    | IMPLEMENTATION → Run Implementation                     | 布局布线，生成比特流前的关键步骤。                         |
| **生成比特流** | PROGRAM AND DEBUG → Generate Bitstream                  | 最终生成 `.bit` 文件，下载到 FPGA。                  |
| **查看波形**  | 仿真运行后自动弹出                                               | 可添加信号、放大缩小、保存为 `.wcfg`。                   |


</div>


### 2.3 references

Vivado 下载与安装：
- [Geoge Mason University > Instructions on how to install Xilinx Vivado](https://people-ece.vse.gmu.edu/coursewebpages/ECE/ECE448/S23/resources/Xilinx_Vivado_Installation_Instructions.pdf)
- [CSDN > 【FPGA】Vivado 保姆级安装教程 | 从官网下载安装包开始到安装完毕 | 每步都有详细截图说明 | 支持无脑跟装](https://blog.csdn.net/weixin_50502862/article/details/126856879)
- [CSDN > FPGA 基础入门 【1】Vivado 官方免费版安装](https://blog.csdn.net/qimoDIY/article/details/86710618)
- [CSDN > Vivado 下载问题](https://blog.csdn.net/weixin_65191557/article/details/133824577)
- [Bilibili > Vivado 2023.2 安装](https://www.bilibili.com/video/BV1NuE2zBExh)
- [知乎 > Vivado 全版本下载分享](https://zhuanlan.zhihu.com/p/637955706): 提供了 Vivado 2017.4 ~ 2023.1 版本的下载链接，但不太清楚有没有带 license
- [知乎 > 有 Vivado 的下载链接吗？](https://www.zhihu.com/question/345565827/answer/117690612640): 这篇文章提到：如果你只需要烧录程序或调试硬件，不必安装数十 GB 的完整版！Lab Edition堪称“小而美”的解决方案：体积仅 1GB, 安装后占用约 2.4GB 空间，对硬盘空间友好。
- [清华大学 > 计系 2024 数字逻辑电路实验](https://lab.cs.tsinghua.edu.cn/digital-logic-lab/doc/lab2/lab/)

Vivado 操作与使用：


## 3. Verilog Tips

### 3.1 模块例化 (Module Instantiation)



## Related Resources

- [数电开源仿真软件 logisim 官网](https://www.cburch.com/logisim/)



