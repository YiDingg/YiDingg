# DCE 数字电路实验 - 实验 1. 阻塞与非阻塞 (week 5 - 2025.10.18, week 6 - 2025.10.25)


> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 08:51 on 2025-10-18 in Beijing.

## 1. 实验时间

- 实验 1: week 5 Sat (2025.10.18), week 6 Sat (2025.10.25)
- 报告提交截止: week 7 Fri (2025.10.31)


## 2. 实验记录

### 2.1 create project

选择最后一个 `xc7a35tcsg324-1` (`xc7a35 tcsg324 - 1`):
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

### 2.2 add sources

本次实验需要以下内容：
- (1) 组合 + 阻塞赋值：`md_combinational_blocking.v`
- (2) 时序 + 非阻塞赋值：`md_sequential_nonblocking.v`
- (3) 时序 + 阻塞赋值：`md_sequential_blocking.v`
- (4) testbench (组合电路)：`tb_combinational.v`
- (5) testbench (时序电路)：`tb_sequential.v`

下面依次给出这些文件的代码内容：

- (1) 组合 + 阻塞赋值：`md_combinational_blocking.v`
``` verilog
// (1) 组合 + 阻塞赋值
// md_combinational_blocking.v

module md_combinational_blocking( 
    input IN_A, 
    input IN_B, 
    input IN_D, 
    output OUT_A0, 
    output reg [1:0] OUT_E
); 

    // 1. Variable Declaration (变量声明)
    reg[1:0] c = 0;  // 在 Verilog 中，reg 变量可以在声明时赋初始值（如 reg [1:0] c = 0;），但这主要用于仿真；在 FPGA 综合时，初始值通常被忽略，建议在 always 块中通过复位逻辑设置初始值以确保可综合性。

    // 2. Main Code (主代码)
    always @(IN_A, IN_B, IN_D) begin  // 这里逗号和 or 的作用等价
        c = IN_A + IN_B; 
        OUT_E = c + IN_D; 
    end 

    // 3. Output Assignment (输出赋值)
    assign OUT_A0 = IN_A; 

endmodule
```



- (2) 时序 + 非阻塞赋值：`md_sequential_nonblocking.v`

``` verilog
// (2) 时序 + 非阻塞赋值
// md_sequential_nonblocking.v

module md_sequential_nonblocking(
    input clk,
    input IN_A,
    input IN_B,
    input IN_D,
    output OUT_A0,
    output reg [1:0] OUT_E
);

    // 1. Variable Declaration (变量声明)
    reg [1:0] c = 0;  // 在 Verilog 中，reg 变量可以在声明时赋初始值（如 reg [1:0] c = 0;），但这主要用于仿真；在 FPGA 综合时，初始值通常被忽略，建议在 always 块中通过复位逻辑设置初始值以确保可综合性。

    // 2. Main Code (主代码)
    always @(posedge clk) begin
        c <= IN_A + IN_B;  // 非阻塞赋值：后语句 **不可见** 前语句结果
        OUT_E <= c + IN_D;
    end

    // 3. Output Assignment (输出赋值)
    assign OUT_A0 = IN_A;

endmodule
```



- (3) 时序 + 阻塞赋值：`md_sequential_blocking.v`
``` verilog
// (3) 时序 + 阻塞赋值
// md_sequential_blocking.v

module md_sequential_blocking(
    input clk,
    input IN_A,
    input IN_B,
    input IN_D,
    output OUT_A0,
    output reg [1:0] OUT_E
);

    // 1. Variable Declaration (变量声明)
    reg [1:0] c = 0;  // 在 Verilog 中，reg 变量可以在声明时赋初始值（如 reg [1:0] c = 0;），但这主要用于仿真；在 FPGA 综合时，初始值通常被忽略，建议在 always 块中通过复位逻辑设置初始值以确保可综合性。

    // 2. Main Code (主代码)
    always @(posedge clk) begin
        c = IN_A + IN_B;  // 阻塞赋值：按顺序执行，后语句可见前语句结果
        OUT_E = c + IN_D;
    end

    // 3. Output Assignment (输出赋值)
    assign OUT_A0 = IN_A;

endmodule
```







- (4) testbench for combinational circuit (组合电路)：`tb_combinational.v`

``` verilog
// (4) testbench for combinational circuit (组合电路)：`tb_combinational.v`

/*
说明（针对 Verilog `timescale 1ns/1ps`）：

- 时间单位（time unit = 1ns）：
    - 源代码中的时间延迟字面量以 1 纳秒 为单位。例如 `#1` 表示 1 纳秒，`#2` 表示 2 纳秒。
    - 所有以单位为基础的延迟都会按此单位来解释和显示。
- 时间精度（time precision = 1ps）：
    - 仿真的时间分辨率为 1 皮秒，所有时间值在内部按 1ps 的精度进行表示和四舍五入。
    - 比如 0.5ns = 500ps，会以 1ps 为最小步长来表示；小于 1ps 的值将按 1ps 精度舍入。
- 影响与注意事项：
    - 精度应小于或等于时间单位（通常选择比单位更细的精度以获得准确结果）。
    - 更细的时间精度能提高仿真精度，但会增加仿真开销（时间和内存）。
    - `timescale` 指令对当前源文件中的模块有效，通常应在模块声明之前出现；如果缺省，仿真器会使用默认 timescale。
- 示例（概念性）：
    - `#1` → 1 ns
    - `#0.5` → 0.5 ns = 500 ps（在 1ps 精度下表示为 500 ps）
*/

`timescale 1ns/1ps 

module tb_combinational;

    // 1. Variable Declaration (变量声明)
    reg in_a;
    reg in_b;
    reg in_d;
    wire out_a0;
    wire [1:0] out_e;

    // 2. Instantiate the Unit Under Test (UUT) (被测单元实例化)
    md_combinational_blocking uut (
        .IN_A(in_a),
        .IN_B(in_b),
        .IN_D(in_d),
        .OUT_A0(out_a0),
        .OUT_E(out_e)
    );

    // 3. Testbench Logic (测试逻辑)
    initial begin
        // 1. Initialize Inputs (初始化输入)
        in_a = 0;
        in_b = 0;
        in_d = 0;

        // 2. Apply Test Vectors (施加测试向量)
        #10 in_a = 1; in_b = 0; in_d = 1;
        #10 in_a = 0; in_b = 1; in_d = 0;
        #10 in_a = 1; in_b = 1; in_d = 1;

        // 3. Finish Simulation (结束仿真)
        #10 $finish;

        // 4. Monitor Outputs (监测输出)
        $monitor("Time: %0t | IN_A: %b | IN_B: %b | IN_D: %b | OUT_A0: %b | OUT_E: %b", $time, in_a, in_b, in_d, out_a0, out_e);
        
    end

endmodule
```




- (5) testbench for sequential circuit (时序电路)：`tb_sequential.v`
``` verilog
// (5) testbench for sequential circuit (时序电路)：`tb_sequential.v`

`timescale 1ns/1ps 

module tb_sequential;

// 1. Variable Declaration (变量声明)
reg clk;
reg in_a;
reg in_b;
reg in_d;
wire out_a0;
wire [1:0] out_e;

parameter PERIOD = 20;

// 2. Instantiate the Unit Under Test (UUT) (被测单元实例化)
// 假设测试 md_sequential_blocking（可根据需要切换为 md_sequential_nonblocking）
md_sequential_blocking uut (
    .clk(clk),
    .IN_A(in_a),
    .IN_B(in_b),
    .IN_D(in_d),
    .OUT_A0(out_a0),
    .OUT_E(out_e)
);

// 3. Testbench Logic (测试逻辑)
initial begin
    // Clock generation (时钟生成)
    clk = 1'b0;
    #(PERIOD/2);
    forever #(PERIOD/2) clk = ~clk;
end

integer delay1_a, delay2_a, k_a;
initial begin
    // Initialize Inputs (初始化输入)
    in_a = 0;
    in_b = 0;
    in_d = 0;
    #10;

    // Generate random signals for in_a (生成 in_a 的随机信号)
    for(k_a = 0; k_a < 200; k_a = k_a + 1) begin
        delay1_a = (PERIOD/3) * ({$random} % 3);
        delay2_a = (PERIOD/3) * ({$random} % 3);
        #delay1_a in_a = 1;
        #delay2_a in_a = 0;
    end
end

integer delay1_b, delay2_b, k_b;
initial begin
    // Generate random signals for in_b (生成 in_b 的随机信号)
    #10 in_b = 0;
    for(k_b = 0; k_b < 200; k_b = k_b + 1) begin
        delay1_b = (PERIOD/3) * ({$random} % 5);
        delay2_b = (PERIOD/3) * ({$random} % 5);
        #delay1_b in_b = 1;
        #delay2_b in_b = 0;
    end
end

integer delay1_d, delay2_d, k_d;
initial begin
    // Generate random signals for in_d (生成 in_d 的随机信号)
    #10 in_d = 0;
    for(k_d = 0; k_d < 200; k_d = k_d + 1) begin
        delay1_d = (PERIOD/3) * ({$random} % 6);
        delay2_d = (PERIOD/3) * ({$random} % 6);
        #delay1_d in_d = 1;
        #delay2_d in_d = 0;
    end
end

// 4. Monitor Outputs (监测输出)
initial begin
    $monitor("Time: %0t | clk: %b | IN_A: %b | IN_B: %b | IN_D: %b | OUT_A0: %b | OUT_E: %b", $time, clk, in_a, in_b, in_d, out_a0, out_e);
end

endmodule
```


也可以同时测试两个时序电路：
- (6) testbench for both sequential modules (两个时序电路同时测试)：`tb_sequential_both.v`

``` verilog
// Testbench for both sequential modules simultaneously (两个时序电路同时测试)：`tb_sequential_both.v`

`timescale 1ns/1ps 

module tb_sequential_both;

    // 1. Variable Declaration (变量声明)
    reg clk;
    reg in_a;
    reg in_b;
    reg in_d;
    wire out_a0_blocking;
    wire [1:0] out_e_blocking;
    wire out_a0_nonblocking;
    wire [1:0] out_e_nonblocking;

    parameter PERIOD = 20;

    // 2. Instantiate the Units Under Test (UUTs)
    md_sequential_blocking uut_blocking (
        .clk(clk),
        .IN_A(in_a),
        .IN_B(in_b),
        .IN_D(in_d),
        .OUT_A0(out_a0_blocking),
        .OUT_E(out_e_blocking)
    );

    md_sequential_nonblocking uut_nonblocking (
        .clk(clk),
        .IN_A(in_a),
        .IN_B(in_b),
        .IN_D(in_d),
        .OUT_A0(out_a0_nonblocking),
        .OUT_E(out_e_nonblocking)
    );

    // 3. Testbench Logic (测试逻辑)
    initial begin
        // Clock generation (时钟生成)
        clk = 1'b0;
        #(PERIOD/2);
        forever #(PERIOD/2) clk = ~clk;
    end

    integer delay1_a, delay2_a, k_a;
    initial begin
        // Initialize Inputs (初始化输入)
        in_a = 0;
        in_b = 0;
        in_d = 0;
        #10;
        // Generate random signals for in_a (生成 in_a 的随机信号)
        for(k_a = 0; k_a < 200; k_a = k_a + 1) begin
            delay1_a = (PERIOD/3) * ({$random} % 3);
            delay2_a = (PERIOD/3) * ({$random} % 3);
            #delay1_a in_a = 1;
            #delay2_a in_a = 0;
        end
    end

    integer delay1_b, delay2_b, k_b;
    initial begin
        // Generate random signals for in_b (生成 in_b 的随机信号)
        #10 in_b = 0;
        for(k_b = 0; k_b < 200; k_b = k_b + 1) begin
            delay1_b = (PERIOD/3) * ({$random} % 5);
            delay2_b = (PERIOD/3) * ({$random} % 5);
            #delay1_b in_b = 1;
            #delay2_b in_b = 0;
        end
    end

    integer delay1_d, delay2_d, k_d;
    initial begin
        // Generate random signals for in_d (生成 in_d 的随机信号)
        #10 in_d = 0;
        for(k_d = 0; k_d < 200; k_d = k_d + 1) begin
            delay1_d = (PERIOD/3) * ({$random} % 6);
            delay2_d = (PERIOD/3) * ({$random} % 6);
            #delay1_d in_d = 1;
            #delay2_d in_d = 0;
        end
    end

    // 4. Monitor Outputs (监测输出)
    initial begin
        $monitor("Time: %0t | clk: %b | IN_A: %b | IN_B: %b | IN_D: %b | Blocking OUT_A0: %b | OUT_E: %b | Nonblocking OUT_A0: %b | OUT_E: %b", $time, clk, in_a, in_b, in_d, out_a0_blocking, out_e_blocking, out_a0_nonblocking, out_e_nonblocking);
    end

endmodule
```


### 2.3 run simulation

在 `Project Manager > Add Sources > Design Sources` 中添加上述 module 和 testbench, 然后 `右键 tb_combinational > Set as Top` 设置仿真顶层，点击 `Run Behavioral Simulation` 即可。

组合电路测试结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-16-19-20_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>

组合电路不含时序元件，输入变化后，输出会通过一系列逻辑门 (构成的组合电路) 立即响应。

`右键 Simulation > Close Simulation`，然后将 top cell 改为 `tb_sequential_both`，再次运行仿真，得到时序电路测试结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-16-35-05_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>

图中可以观察到，时序电路中，阻塞赋值和非阻塞赋值的结果还是有明显不同的。我们尝试了添加模块内部变量 `c`，发现没有波形，这时只需重新运行一次仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-16-54-18_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-16-56-27_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-16-58-30_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>

首先明确： 如果时钟上升沿瞬间模块的输入发生了变化， **模块看的是上升沿之前的值 (D Flipflop 的性质所致)** ，而不是之后的值。

在我们的时序代码中，第一句 `c = a + b` or `c <= a + b` 的运算是完全相同的，因为它们都是在时钟上升沿瞬间 "保存输入初始值 (上升沿之前的值)"，然后进行运算 `a + b` 并赋值给 `c`。这里阻塞和非阻塞的区别体现在第二句 `e = c + d` or `e <= c + d` 上：
- 时序 + 非阻塞：等号右端所有用到的值，也即 `a, b, c, d` 都是上升沿时保存下来的初始值 (保存的是上升沿前一瞬间的值)，本次 `c + d` 运算 "看不到" `c <= a + b` 的新结果值；换句话说，本次 `c + d` 运算使用的是上次 `c <= a + b` 计算得到的值。 **等价于 `e_{n} = a_{n-1} + b_{n-1} + d_{n}` 的效果。**
- 时序 + 阻塞：时钟上升沿到来时，仅保存整个模块几个输入端口的初始值，也即 `a, b, d` 在上升沿被保存下来。语句 `e = c + d` 会先等待 `c` 完成更新，被赋值为 `a + b` 的新结果，然后才来计算 `c + d` 并赋值给 `e`，所以本次 `c + d` 运算 "看到了" 本次 `c = a + b` 的新结果值。 **等价于 `e = (a + b) + d`，也即 `e_{n} = a_{n} + b_{n} + d_{n}` 的效果。**



我们在图中找一个具体的例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-17-12-17_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>


### 2.4 synthesis and implementation


点击左侧 `Run Synthesis` 将 Verilog 代码综合成门级网表：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-17-17-26_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>

在运行 Implementation 之前，我们需要设置输入输出引脚。点击左侧 `Synthesis > Open Synthesized Design`，然后在窗口右上角选择 `I/O Planning`：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-17-24-40_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>

**<span style='color:red'> 设置接口这一步需要我们对照着板子实物和板子使用手册，根据需要来分配 I/O 口。 </span>** 这一步其实只是为了生成 `.xdc` constraints file (约束文件)，我们直接在 `Project Manager` 中添加约束文件也是可以的，下面给出一个简单示例：

``` bash
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports clk ]
#set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports sw]

set_property -dict {PACKAGE_PIN M4 IOSTANDARD LVCMOS33} [get_ports a]
set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS33} [get_ports b]
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports d]

set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports {e[1]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {e[0]}]

set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports a_0]
```

平时我们自己弄的话就不必从 `I/O Planning` 上设置了，直接添加并修改 `constraints.xdc` 文件更方便。

**注意 constraints file 需要与 `tb.v` 中的端口定义保持一致，否则 implementation 会报错。** 约束文件编写好之后，可以进行 Implementation, **先连接好 FPGA 板子：**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-08-47-25_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>


然后点击 `Run Implementation`，软件会自动进行布局布线，随后点击 `Program and Debug > Generate Bitstream` 即可生成 bitstream 文件 (这个文件就类似单片机的 hex 文件，就是下载到芯片的代码文件)。



### 2.5 program and measurement

开始测量之前，需要先从 constraints file 和板子使用手册中找到我们所用的引脚：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-09-12-59_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-09-16-39_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-09-18-32_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>

点击 `Program and Debug > Open Hardware Manager > Program Device`，写入第一个 bitstream 文件 `top1_tb_combinational.bit`, 连接好示波器，我们连的是：
- CH1 (yellow) = `a_0` 
- CH2 (blue) = `e[1]`

板子上先保持 `abd = 010`，然后拨动 `a: 0 -> 1` 即可发现 CH1/CH2 都变高，说明电路 (模块) 工作正常。利用 single trigger 功能观察波形变化， **拍照保存** 。

类似地，写入第二个文件 `top2_tb_sequential_nonblocking.bit`，重复上述步骤；最后写入第三个 `top3_tb_sequential_blocking.bit`，再重复，结果汇总如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-11-24-43_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-11-24-53_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-11-25-01_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-09-42-17_DCE 数字电路实验 - 实验 1. 阻塞与非阻塞.png"/></div> -->

到这一步，整个实验就基本完成了，可以撰写实验报告。这次数电实验报告我们就不用 LaTex 了，一方面是不太想在数电实验上花过多时间，一方面是不敢保证老师的 "习性"。


