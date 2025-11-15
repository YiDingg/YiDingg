# Razavi PLL - Chapter 15. Frequency Dividers

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 19:09 on 2025-08-18 in Lincang.

参考教材：[*Design of CMOS Phase-Locked Loops (Behzad Razavi) (1st Edition, 2020)*](https://www.zhihu.com/question/23142886/answer/108257466853)

## Introduction

## 15.1 General Considerations

分频器 FD (Frequency Divider) 的性能通常通过四个参数来描述：
- (1) 分频比 $N$
- (2) 最大输入频率 $f_{in,max}$, 或者说输入频率范围 (频率过低可能导致 dynamic logic 失效)
- (3) 功耗 $P$
- (4) 最小输入电压摆幅 $V_{in,swing}$ (也称为 "灵敏度 sensitivity")

虽然分频器的相位噪声也很重要，但在大多数情况下都可以忽略不计，因此多数分频器结构都不引入额外相位噪声。分频器通常设计得非常保守，以避免对整个系统带来不良影响，也即其最大输入频率 $f_{in,max}$ 远大于实际输入频率。另外，分频器的电源噪声可能会产生额外干扰，必须谨慎处理。

下面是一个 FD 在不同频率下的灵敏度示例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-02-21-00_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div>

## 15.2 Latch Design Styles

大多数频率分频器都由 D latches 实现。在本节，我们将讨论各种静态和动态触发器的设计方式，并阐述它们的优缺点。对我们而言，重要的参数包括最大速度、功耗以及受控制的晶体管数量 (也即输入端所承受的负载)。



### 15.2.1 Static Latches

详见 [Prerequisite Digital Electronics Knowledge for PLL](<AnalogIC/Prerequisite Digital Electronics Knowledge for PLL.md>)，这里略。

### 15.2.2 Dynamic Latches 

在动态锁存器中，数据 (状态) 是存储在晶体管的寄生电容中的。与静态锁存器相比，这种锁存器所使用的晶体管数量更少，并且通常在速度与功耗方面更具优势。但由于电荷泄露等问题，节点寄生电容只能将信号保持几毫秒 (甚至更短)。因此我们需要不断地刷新各节点的值，以保证信号的完整性。这也揭示出动态时序电路的另一个特点：在高频率下能正常工作的模块，降低频率时可能就无法工作了 (有时可以通过增大信号幅度、增大晶体管面积等操作来解决)。

**1) Clocked CMOS Dynamic Latch**

下图 (Figure 15.10) 是一个 “clocked CMOS” (C²MOS) dynamic latch 的例子：当 CK = 1 时, M2/M3 打开，电路化为一个 inverter; 而当 CK = 0 时, M2/M3 关闭，输出信号由输出节点的电容保持。也就是说，下图实际上是一种 C²MOS D latch, 它需要两相时钟 $\mathrm{CK}$ 和 $\mathrm{\overline{CK}}$。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-19-26-06_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div>

有读者可能会想，是否能 "反过来"，将 M1/M4 作为开关受时钟信号控制，而将 D 接到 M2/M3 呢？原教材的 Problem 15.7 进行了分析，解释了不这样做的原因: "the circuit suffers from charge sharing and a degraded output level".

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-20-37-55_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div>

C²MOS D-Latch 的主要缺点在于其在时钟 CK 上升沿的 "透明性"，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-02-23-48_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div>

在 CK 上升前 (CK = 0), Master in store mode and slave in sense mode, 而在 CK 上升瞬间, Master from store to sense mode, slave from sense to store mode. 这可能导致两种结果：
- (1) master 先进入 sense mode, 此时 master 和 slave 都位于 sense mode, 过了一小段时间后, slave 才转变为 store mode.
- (2) slave 先进入 store mode, 此时 master 和 slave 都位于 store mode, 过了一小段时间后, master 才转变为 sense mode.

显然第一种情况不是我们想要的，因为这可能使 B 和 Q 的值被同时更改 (Q 本应该在下一个时钟下降沿被更改)，导致时序上的错误。对于这个问题, Razavi 书上的原话是：
> As a conservative measure, the two latches should be driven by nonoverlapping clock phases: i.e., two nonoverlapping clocks and their complements. But for frequency divider implementations, fast clock transitions suffice.

**2) True Single-Phase Clocking**

一种简洁、优雅的动态逻辑电路是基于 "“true single-phase clocking" (TSPC) ，其最初的设计目的是为了避免使用互补时钟 (两相时钟)。相比于 C²MOS counterparts, TSPC counterparts 具有更快的速度和更低的功耗，从二十世纪末便流行至今。其基本结构如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-02-51-55_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div>

上图 (a) 是以 NMOS 作为时控开关器件，通常称为 TSPC N-Latch, 与之对应的，如果使用 PMOS 作为时控开关器件，则称为 TSPC P-Latch; 而 (b) 和 (c) 都构成 TSPC D-Latch, 只是前者共六个晶体管 (6T), 后者共九个 (9T)。另外需要注意的是，作为一个 dynamic latch, TSPC N-Latch (or P-Latch) 并不能直接当作 static latch 使用，因为其静态真值表有缺陷，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-16-10-58_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div>

由两个 N-Latch 可以构成 D-Latch (6T), 由一个 P-Latch 和两个 N-Latch 可以构成 D-Latch (9T)。两者的区别在于：输入同为 $\mathrm{D}$ 时，前者 (6T) 输出的是 $\mathrm{Q}$，而后者 (9T) 输出的是 $\mathrm{\overline{Q}}$。其实这里我不是很明白 (9T) 结构的意义 (明明可以用 INV 来取反)，也许是 9T 结构在速度或功耗等方面有优势？有待后续验证。

下图解读了两种 TSPC D-Latch 的工作原理：

<!--  -->
<!--  -->
<div class='center'>

**<span style='color:red'> 经过好几个小时的尝试，我们的推导与预期结果和仿真结果仍是对不上，无奈只能暂时放弃，先直接套用正确 (仿真) 结果来用。 </span>**
</div>
<!--  -->
<!--  -->

下面是 TSPC D Flip-Flop 作为触发器和 divide-by-2 时的仿真示例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-18-40-58_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-19-56-34_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div>

从上图仿真结果来看，此 TSPC D Flip-Flop 起到 "positive-edge triggered D flip-flop" 的作用。

<!-- 图中可以看到，作为触发器时，此电路的输出情况也是 "有问题" 的，具体原因有待进一步探索。为了避免这个问题，我们之后只讨论由此电路构成的 frequency divide-by-2 circuit:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-18-46-09_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div> -->

下图是这篇文章 [知乎 > 动态门/TSPC](https://zhuanlan.zhihu.com/p/266585623) 中给出的一种 New TSPC D Flip-Flop (12T):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-19-58-35_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-19-19-56-59_Razavi PLL - Chapter 15. Frequency Dividers.png"/></div>




## 15.3 Divide-by-2 Circuit Design 
## 15.4 Dual-Modulus Prescalers 
## 15.5 Divider Design for RF Synthesis
### 15.5.1 Pulse Swallow Divider
### 15.5.2 Vaucher Divider 
## 15.6 Miller Divider
## 15.7 Injection-Locked Dividers
## 15.8 Fractional Dividers
## 15.9 Divider Delay and Phase Noise