# Prerequisite Digital Electronics Knowledge for PLL

> [!Note|style:callout|label:Infor]
> Initially published at 16:19 on 2025-08-08 in Lincang.

## References

参考教材：
- [*Digital Electronics (Betty Lincoln) (1st Edition, 2014)*](https://www.zhihu.com/question/283747173/answer/1937200146287945093)
- [*Digital Electronics Principles and Applications (Roger L. Tokheim, Patrick E. Hoppe) (9th Edition, 2022)*](https://www.zhihu.com/question/283747173/answer/1937200146287945093)

## 1. Logic Gate (逻辑门)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-17-24-32_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-17-24-47_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

## 2. Latch (锁存器)

- Latch：电平敏感 (level-sensitive)，在使能信号（时钟）为有效电平（高或低）期间持续透明，或者干脆就不需要时钟信号
- Flip-Flop：边沿敏感 (edge-triggered)，只在时钟信号的上升沿或下降沿采样输入

当然，也可以吧 latch 归到 FF (flip-flop) 中，这时不使用时钟脉冲的触发器便称为锁存器。从大类上讲, latch 共分为两种: SR (set-reset) latch 和 D (data) latch, 其中 SR latch 是最基本的锁存器。

为避免产生歧义，本文将电平敏感 (在有效电平器件持续透明) 的触发器称为 latch, 而将边沿敏感 (仅在时钟边沿采样输入) 的触发器称为 flip-flop. 

### 2.1 Summary of Latch

To be completed...

### 2.2 SR Latch (SR 锁存器)


When Q = 1, it is called SET (or high) and if Q = 0 it is called RESET (or low). 
$\mathrm{Q_n}$ refers to the previous or preset state and $\mathrm{Q_{n+1}}$ the next state.

SR latch 有两个输入端，共四种输入情况，分别对应 hold, reset, set 和 prohibited/undefined 四种输出状态。高电平有效 (active HIGH inputs) 的 SR Latch 如下表所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-02-24-51_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

**<span style='color:red'> 注意上图 (Fig.9.7) 中 R 端口右侧应该对应 Q 端口，教材中 S 端口右侧对应 Q 端口是错误的。 </span>**

<div class='center'>

| S | R | $\mathrm{Q_{n+1}}$ | Mode |
|:-:|:-:|:-:|:-:|
| 0 | 0 | $\mathrm{Q_n}$ | hold |
| 0 | 1 | 0 | reset |
| 1 | 0 | 1 | set |
| 1 | 1 | - | prohibited/undefined |
</div>

上表中，我们暂时不理解的是，如果 S = R = 1, 明明可以得到两个输出端口都为 0 的结果，为什么我们要说这种情况是 prohibited/undefined 呢？类似地，下图中用 NAND 门构成的 (LOW active) SR latch, 如果输入同时为零，可以得到输出均为 1 的结果。背后原因有待进一步探究。


与之相反，低电平有效 (active LOW inputs) 的 SR Latch 在输入端有 inverting 标志 (小圆圈)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-00-45-15_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

<div class='center'>

| S | R | $\mathrm{Q_{n+1}}$ | Mode |
|:-:|:-:|:-:|:-:|
| 0 | 0 | - | prohibited/undefined |
| 0 | 1 | 1 | set |
| 1 | 0 | 0 | reset |
| 1 | 1 | $\mathrm{Q_n}$ | hold |
</div>


SR latch 还可以用于按键消抖 (Contact Bounce Eliminator):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-00-48-17_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

### 2.3 Clocked SR Latch (时控 SR 锁存器)

上面的普通 SR latch 是典型的异步触发器，这在需要顺序逻辑处理的任务中十分受限，引入时钟信号的时控 SR latch 便应运而生：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-00-51-06_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

<div class='center'>

| CLK | S | R | $\mathrm{Q_{n+1}}$ | Mode |
|:-:|:-:|:-:|:-:|:-:|
| 1 | 0 | 0 | $\mathrm{Q_n}$ | hold |
| 1 | 0 | 1 | 0 | reset |
| 1 | 1 | 0 | 1 | set |
| 1 | 1 | 1 | - | prohibited/undefined |
</div>

将右半边看作 active LOW inputs 的 SR latch, 不难发现 clocked SR latch 仅在 CLK (clock signal) = 1 时可以改变输出信号，否则 (CLK = 0 时) 一直处于 hold 状态，输出信号不变。通常情况下，一个触发器/锁存器的最大时钟频率都定义为器件能够可靠触发/翻转的最高频率。

下面是一个输入输出波形示例：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-12-56-51_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

### 2.4 D Latch (D 锁存器)

D latch, 其实也是 clocked D latch, 名称中的字母 D 表示 "data", 因为该锁存器会暂时存储一位 bit. D latch 的符号如图 9.17 所示，当时钟为高电平时, D latch 会将存储一位比特传输到输出端 Q, 而在时钟为低电平时, Q 的状态保持不变，直到时钟信号到达下一个高电平。

换句话说，当时钟为高电平时，D 锁存器是 "透明" 的, D 输入的任何变化都会立即反映在输出端 Q 上。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-02-41-35_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-12-58-52_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-02-40-42_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>


<div class='center'>

| CLK | D | $\mathrm{Q_{n+1}}$ |
|:-:|:-:|:-:|
| 1 | 0 | 0 |
| 1 | 1 | 1 |
</div>



### 2.5 Master-Slave D Latch (主从式 D 锁存器)

Master-slave D latch, 也常称作 master-slave D flip-flop, 由两个 D latch 和一个 NOT gate 级联而成。第一个时钟先改变 master latch 的状态，然后在第二个时钟到来时，slave latch 才会根据 master latch 的状态更新输出。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-02-47-06_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

Master-slave D latch 可由 NAND gate 构成，下面是一个例子：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-02-48-40_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-13-02-44_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

### 2.6 JK Latch (JK 锁存器)

JK latch 是所有 latch or flip-flop 中最常用的一种。与 clocked SR latch 类似, JK latch 也在时钟信号的控制下工作，当且仅当 CLK = 1 时, JK latch 才会根据 J 和 K 的输入状态改变输出 Q (否则 hold 不变)。其结构和符号如下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-16-39-52_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-16-57-57_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

其真值表/功能表如下：
<div class='center'>

| CLK | J | K | $\mathrm{Q_{n+1}}$ | Mode |
|:-:|:-:|:-:|:-:|:-:|
| 1 | 0 | 0 | $\mathrm{Q_n}$ | hold |
| 1 | 0 | 1 | 0 | reset |
| 1 | 1 | 0 | 1 | set |
| 1 | 1 | 1 | $\mathrm{\overline{Q_n}}$ | toggle |
</div>

下图展示了 JK latch 的另一种结构，其真值表仍同上：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-16-51-05_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>


上式的加号 `+` 指逻辑运算中的 OR (或) 操作，而不是普通的加法运算。并且，可以写出 JK latch 的卡诺图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-16-54-39_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

当然，也有一些边沿采样的 JK 触发器, 即 JK flip-flop. 下图是一个 negative-edge JK flip-flop:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-17-03-15_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>




### 2.7 T Latch/FF

特别地，如果将 J 和 K 短接成一个端口，它还可以充当一个 T latch (toggle latch), 也即 T flip-flop, 从而实现对输出的 toggle 操作，这种 toggle 操作在二进制计数器中有着广泛的应用。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-17-12-08_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

### 2.7 Master-Slave JK Latch/FF

主从 JK 触发器的工作原理与主从 D 触发器类似，我们不多赘述。

## 3. Flip-Flop (触发器)

### 3.1 Latch vs. Flip-Flop

在本文, flip-flop 与 latch 的唯一区别便是其仅在时钟 (上或下) 边沿透明，在这一瞬间对输入数据进行处理，并调整输出信号。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-17-07-24_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

<!-- 边沿触发一般是用 CLK + Differentiator (微分器) + Comparator (比较器) 来实现的。-->

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-18-12-46_Prerequisite Digital Electronics Knowledge for PLL.png"/></div> -->

### 3.2. Latch/FF Conversion

通过合适的逻辑门构建前级电路，可实现各触发器之间的相互转换，详见 [*Digital Electronics (Betty Lincoln) (1st Edition, 2014)*](https://www.zhihu.com/question/283747173/answer/1937200146287945093) 的 page.210 - page.215, 我们不多赘述。

### 3.3. Application of FF

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-01-34-33_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

## 4. Verilog Language

本小节参考 [菜鸟教程 > Verilog 教程](https://www.runoob.com/w3cnote/verilog-tutorial.html) 介绍 Verilog 语言的基本语法和用法，为后续用 Verilog-AMS 搭建行为级模块和仿真打下基础。

### 4.1 Basic Syntax

- Verilog 区分大小写，空白符（换行、制表、空格）都没有实际的意义每个语句必须以分号为结束符。
- 注释方式与 C 语言完全相同，有 `// 这里是注释` 和 `/* 这里是注释 */` 两种方式
- 标识符与关键字：与 C 语言类似，标识符 (变量名) 的第一个字符必须是字母或者下划线，关键字则是 Verilog 中预留的用于定义语言结构的特殊标识符 **(Verilog 中关键字全部为小写)**

``` verilog
wire [1:0] results;  // 声明一个 2 位宽的 wire 信号 results
assign results = (a == 1'b0) ? 2'b01 :  // 如果 a == 0, results = 01 (2-bit)
                 (b == 1'b0) ? 2'b10 :  // 如果 b == 0, results = 10 (2-bit)
                 2'b11;                 // 否则, results = 11 (2-bit)
```

### 4.2 Logic Signal

Verilog HDL 有下列四种基本的值来表示硬件电路中的电平逻辑：

- `0`：逻辑 0 或 "False"
- `1`：逻辑 1 或 "True"
- `x` 或 `X`：未知
- `z` 或 `Z`：高阻 (断路)

`x` 意味着信号数值的不确定，即在实际电路里，信号可能为 1，也可能为 0。`z` 则意味着信号处于高阻状态，常见于信号 (input, reg) 没有驱动时的逻辑结果。例如一个 pad 的 input 呈现高阻状态时，其逻辑值和上下拉的状态有关系。上拉则逻辑值为 1，下拉则为 0 。

### 4.3 Number Representation

数字声明时，合法的进制共有四种，数值可指明位宽，也可不指明位宽：
- 二进制 binary: `'b` 或 `'B`
- 八进制 octal: `'o` 或 `'O`
- 十进制 decimal: `'d` 或 `'D`
- 十六进制 hexadecimal: `'h` 或 `'H`

非负整数表示：

``` verilog
// 八进制每位是 3-bit, 十六进制每位是 4-bit

// 指明位宽
4'b1011         // 4-bit binary number (二进制)
12'o0003       // 12-bit octal number (八进制)
32'h3022_c0de   // 32-bit (4-byte) hexadecimal number (十六进制), 下划线用于提高可读性, 无实际作用

// 不指明位宽和进制时，默认为十进制，编译器会自动分配位宽 (常见的为 32-bit)
// 下面三种写法完全等效
counter = 'd100 ;
counter = 100 ;
counter = 32'h64 ;
```

负数表示：

``` verilog

// 在表示位宽的数字前面加一个减号来表示负数，例如：
-6'd15  
-15 
// 负数的二进制表示是用 "取反加一" 的补码规则
// 例如 +15 为 4'b1111, 则 -15 在 5-bit 二进制的形式为 5'b1_0001, 在 6 位二进制中的形式为 6'b11_0001

// 需要注意的是，减号放在基数和数字之间是非法的，例如下面的表示方法是错误的：
4'd-2   // 非法语句
-4'd2   // 正确语句
-2      // 正确语句
```

实数表示：

``` verilog
// 小数点
30.123
6.0
3.0
0.001

// 科学计数法
1.2e4         // 12000
1_0001e4      // 100010000, 下划线无实际作用
1E-3          // 0.001
```

字符串：

``` verilog
// 字符串是由双引号包起来的字符队列。字符串不能多行书写，即字符串中不能包含回车符
// Verilog 将字符串当做一系列的单字节 ASCII 字符队列 (每字节 8-bit)

// 例如, 为存储字符串 "www.runoob.com", 需要 14*(8-bit) 的存储单元
reg [0: 14*8-1]       str ;
initial begin
    str = "www.runoob.com";
end
```



### 4.4 Data Types

Verilog 中常用的数据类型有以下几种：

- (1) `wire`: 用于连接不同模块的信号，表示物理连线。
    - `wire` 类型的信号不能存储值，只能通过驱动来改变其值。
    - 如果没有驱动元件连接到 `wire` 型变量，默认值一般为 `z` (高阻)
- (2) `reg`: 寄存器 register, 用来表示存储单元，它会保持数据原有的值，直到被改写
    - `reg` 类型的信号可以存储值，但不能直接连接到模块的端口
    - `reg` 不一定需要时钟信号，在仿真时，寄存器的值可在任意时刻通过赋值操作进行改写
- (3) `integer`: 整数类型，通常为 32-bit
- (4) `real`: 实数类型，通常为 64-bit
- (5) `time`: 时间类型，通常为 64-bit
- (6) `parameter`: 参数类型，用于定义常量，只能赋值一次
- (7) `string`: 现在许多 Verilog 仿真器都支持字符串类型，可以用来表示文本数据 (相当于 char 数组)


整数，实数，时间等数据类型其实也属于寄存器类型。

``` verilog
wire a;         // 声明一个 wire 信号 a
reg [7:0] b;    // 声明一个 8-bit 的 reg 信号 b
integer c;      // 声明一个 integer 信号 c
real d;         // 声明一个 real 信号 d
time e;         // 声明一个 time 信号 e
```

下面是具体的例子：

``` verilog
// wire
wire interrupt;             // 声明一个 wire 信号 interrupt
wire flag1, flag2;          // 声明两个 wire 信号 flag1 和 flag2
wire gnd = 1'b0;            // 声明一个 wire 信号 gnd, 并赋值为 0 (1'b0)
wire [8:2] addr;            // 声明 32-bit 的线型变量 addr, 位宽范围为 8:2
wire [32-1:0] gpio_data;    // 声明 32-bit 的线型变量 gpio_data (相当于 C 语言的数组)
// 注意，在 Verilog 中，像 addr_temp[3:2] = addr[8:7] + 1'b1; 这样的写法是合法的
// wire 其实还有其他数据类型, 包括 wand, wor, wri, triand, trior, trireg 等，这些数据类型用的频率不是很高, 这里不做介绍

// reg
reg [7:0] data;         // 声明一个 8-bit 的 reg 信号 data
reg [3:0][7:0] data;    // 声明一个二阶 Packed Array, 所有数据连续存储, 支持位访问 data[0][1]
reg [7:0] data[3:0];   // 声明一个 Unpacked Array, 每个元素都是 8-bit 的 reg 信号, 不支持位访问 data[0][1]

```

Verillog 还支持指定 bit 位后固定位宽的向量域选择访问：
- `[<bit>+: <width>]` : 从起始 bit 位开始递增，位宽为 width
- `[<bit>-: <width>]` : 从起始 bit 位开始递减，位宽为 width

``` verilog
//下面 2 种赋值是等效的
A = data1[31-:8] ;
A = data1[31:24] ;

//下面 2 种赋值是等效的
B = data1[0+:8] ;
B = data1[0:7] ;
```



## 5. Dynamic Logic Circuit


静态时序电路大多通过两个首尾相连的反相器来存储高低电平信号，并且只要有电源供电，该电路就能一直存储信号，因此这种电路被称为“静态电路”。相比之下，动态时序电路依靠各节点的寄生电容存储信号，但由于电荷泄露等问题，节点寄生电容只能将信号保持几毫秒 (甚至更短)。因此我们需要不断地刷新各节点的值，以保证信号的完整性。这也揭示出动态时序电路的另一个特点：在高频率下能正常工作的模块，降低频率时可能就无法工作了 (有时可以通过增大信号幅度、增大晶体管面积等操作来解决)。

动态时序电路广泛用于数字电路的设计中，常见于高速电路，并且具有功耗低、面积小的优点。例如从上世纪就爆火至今的 ture single-phase clock (TSPC) logic.

这部分内容比较繁杂，感兴趣的读者可以自行搜索，我们仅给出几篇文献作为参考：
- [[1]](https://seas.ucla.edu/brweb/papers/Journals/BRFall16TSPC.pdf) B. Razavi, “TSPC Logic [A Circuit for All Seasons],” IEEE Solid-State Circuits Mag., vol. 8, no. 4, pp. 10–13, 2016, doi: 10.1109/MSSC.2016.2603228.
- [[2]](https://ieeexplore.ieee.org/document/9218362) Z. Tibenszky, C. Carta and F. Ellinger, "A 0.35 mW 70 GHz Divide-by-4 TSPC Frequency Divider on 22 nm FD-SOI CMOS Technology," 2020 IEEE Radio Frequency Integrated Circuits Symposium (RFIC), Los Angeles, CA, USA, 2020, pp. 243-246, doi: 10.1109/RFIC49505.2020.9218362.
- [3] M. Jung, J. Fuhrmann, A. Ferizi, G. Fischer, R. Weigel and T. Ussmueller, "A 10 GHz low-power multi-modulus frequency divider using Extended True Single-Phase Clock (E-TSPC) Logic," 2012 7th European Microwave Integrated Circuit Conference, Amsterdam, Netherlands, 2012, pp. 508-511.
- [4] A. Bazzazi and A. Nabavi, “Design of a low-power 10GHz frequency divider using Extended True Single Phase Clock (E-TSPC) logic,” in 2009 International Conference on Emerging Trends in Electronic and Photonic Devices & Systems, Varanasi: IEEE, Dec. 2009, pp. 173–176. doi: 10.1109/ELECTRO.2009.5441145.
- [5] M. S. Hossain, M. B. Moreira, F. Sandrez, F. Rivet, H. Lapuyade, and Y. Deval, “Low Power Frequency Dividers using TSPC logic in 28nm FDSOI Technology,” in 2022 IEEE 13th Latin America Symposium on Circuits and System (LASCAS), Puerto Varas, Chile: IEEE, Mar. 2022, pp. 1–4. doi: 10.1109/LASCAS53948.2022.9789073.
- [6] P. Xu, C. Gimeno, and D. Bol, “Optimizing TSPC frequency dividers for always-on low-frequency applications in 28nm FDSOI CMOS,” in 2017 IEEE SOI-3D-Subthreshold Microelectronics Technology Unified Conference (S3S), Burlingame, CA: IEEE, Oct. 2017, pp. 1–2. doi: 10.1109/S3S.2017.8308751.
- [[7]](https://www.mdpi.com/2079-9292/9/5/725/xml) X. Li, J. Gao, Z. Chen, and X. Wang, “High-Speed Wide-Range True-Single-Phase-Clock CMOS Dual Modulus Prescaler,” Electronics, vol. 9, no. 5, p. 725, Apr. 2020, doi: 10.3390/electronics9050725.
