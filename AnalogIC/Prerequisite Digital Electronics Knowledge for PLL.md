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

在本文, flip-flop 与 latch 的唯一区别便是其仅在时钟 (上或下) 边沿透明，在这一瞬间对输入数据进行处理，并调整输出信号。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-09-17-07-24_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

<!-- 边沿触发一般是用 CLK + Differentiator (微分器) + Comparator (比较器) 来实现的。-->

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-18-12-46_Prerequisite Digital Electronics Knowledge for PLL.png"/></div> -->

## 4. Conversion of Latches/FFs

通过合适的逻辑门构建前级电路，可实现各触发器之间的相互转换，详见 [*Digital Electronics (Betty Lincoln) (1st Edition, 2014)*](https://www.zhihu.com/question/283747173/answer/1937200146287945093) 的 page.210 - page.215, 我们不多赘述。

## 5. Application of Flip-Flops

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-01-34-33_Prerequisite Digital Electronics Knowledge for PLL.png"/></div>

## 6. Register (寄存器)

## 7. Counter (计数器)