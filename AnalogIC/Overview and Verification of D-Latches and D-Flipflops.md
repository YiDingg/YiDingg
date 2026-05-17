# Overview and Verification of D-Latches and D-Flipflops


> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 02:32 on 2026-02-18 in Lincang.
> dingyi233@mails.ucas.ac.cn

## 1. Introduction

在最近的 [A 56-GTs PAM3 CDR (84 Gbps, 14 GHz) in TSMC 28nm Technology](<Projects/A 56-GTs PAM3 CDR (84 Gbps, 14 GHz) in TSMC 28nm Technology.md>) 项目中，需要构建一系列能在 14 GHz (quarter-rate) 下工作的 logic gates and modules，包括 INV/NAND/TG 等基本逻辑门，以及 D-Latch 和 D-FlipFlop 等时序模块。但是，我们根据下图搭建经典 TG-based D-Latch 结构时 (`tsmcN28` 工艺库)，发现最大工作频率后仿只有约 15 GHz **(configured as DIV2)**:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-17-17-21-31_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-04-34-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

由于上述数据是将 DFF 设置为 DIV2 所得，因此 DFF 的实际正常工作频率要低得多，大约只有设置为 DIV2 时最大频率的 $\frac{1}{3} \sim \frac{1}{4}$，也即 $5.0 \ \mathrm{GHz} \sim 3.75 \mathrm{GHz}$，这对于 14 GHz 的工作频率是远远不够的。为此，我们需要更换更高性能的 D-Latch 和 D-FlipFlop 结构，以满足 14 GHz 工作频率要求，同时还要兼顾功耗和稳定性等其他性能指标。


本文就来介绍一些高性能 D-Latch 和 D-FlipFlop 结构，并进行仿真验证 (将 DL 或 DFF 配置为 DIV2 进行仿真)，以找到符合需求的最佳方案。


注：
- (1) 本文所指的 "DFF as DIV2 最大工作频率" 是指在仿真中将 DFF 配置为 DIV2 时，能正常工作的最高时钟频率； **这里的 "正常工作" 是指 $t_{cq}$ (CK to Q delay) 相比低频值变化不大，比如 ±10% 以内**
- (2) 若无特别说明，后面所说 "最大工作频率" 均指 DFF 配置为 DIV2 时的最大工作频率。
- (3) 为统一对比条件，所有 D-Latch 和 D-FlipFlop 内部晶体管均使用同一长宽，部分具有明确比例关系的管子，通过改变其 finger num 来调整宽度
- (4) 仿真时默认 **VDD = 0.9 V @ (TT, 27°C)** ，先用前仿对比，然后挑出较好的几种进行后仿验证，最后选出最优方案。




## 2. Overview of digital DLs/DFFs

### 2.1 basic NAND-based DLs

下图展示了两种 NAND-based DL 结构，分别称为 18T-DL 和 16-DL (不是严谨的命名，只是本文为了区分而起的名字)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-16-38-12_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

前者 (18T-DL) 是经典的 NAND-based SR-Latch + INV 结构，后者则是将 INV "合并" 到 NAND 中，形成 4*NAND = 16T 结构。


搭建所得原理图 (cell view) 分别称为：
- `LogicVDD_std_DL_18T` (18T-DL)
- `LogicVDD_std_DL_16T` (16T-DL)



### 2.2 basic TG-based DLs

下图则展示了两种 TG-based DL 结构，分别称为 12T-DL 和 10T-DL：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-16-49-46_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

它们由 TG + INV 构成，原理都挺简单但稍有不同。搭建所得原理图 (cell view) 分别称为：
- `LogicVDD_std_DL_12T` (12T-DL)
- `LogicVDD_std_DL_10T` (10T-DL)


### 2.3 TG/NAND based DLs simulation

这一小节先简单看看 std. Vt 下的各种 DLs 性能，包括：
- `LogicVDD_std_DL_NAND_16T`
- `LogicVDD_std_DL_NAND_18T`
- `LogicVDD_std_DL_TG_10T`
- `LogicVDD_std_DL_TG_12T`
- `LogicVDD_std_DL_XCP_7T`

将它们的原理图都复制到 cell `LogicVDD_std_DL_configSweep` 下，然后利用 config sweep 进行原理图切换，得到前仿结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-22-09-25_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

### 2.4 TSPC-DFF and MTSPC-DFF

下图给出了经典 TSPC-DFF (true-single-phase-clock DFF) 结构，以及其改进版本 MTSPC-DFF (modified TSPC-DFF) 结构：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-16-35-38_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

> 图源：[[1] J. Shaikh and H. Rahaman, “High speed and low power preset-able modified TSPC D flip-flop design and performance comparison with TSPC D flip-flop,” in 2018 International Symposium on Devices, Circuits and Systems (ISDCS), Howrah: IEEE, Mar. 2018, pp. 1–4. doi: 10.1109/ISDCS.2018.8379677.](https://ieeexplore.ieee.org/document/8379677/)


对上面结构稍作修改 (取消了 RST 功能)，搭建所得原理图如下：

<div class='center'>

| `LogicVDD_std_DFF_TSPC_12T` 原理图 | `LogicVDD_std_DFF_MTSPC_12T` 原理图 |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-17-42-44_Overview and Verification of D-Latches and D-Flipflops.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-17-42-11_Overview and Verification of D-Latches and D-Flipflops.png"/></div> |
</div>

### 2.5 Hybrid-Logic DFF

下图给出了一种 low-delay low-power hybrid-logic DFF (HL-DFF) 结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-16-31-42_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

> 图源：[[2] S. S. Vali and A. kumar N, “Design of low delay low power hybrid logic based flip-flop using FinFET,” e-Prime - Advances in Electrical Engineering, Electronics and Energy, vol. 9, p. 100648, Sep. 2024, doi: 10.1016/j.prime.2024.100648.](https://www.sciencedirect.com/science/article/pii/S2772671124002286)


搭建得到原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-18-35-50_Overview and Verification of D-Latches and D-Flipflops.png"/></div>



### 2.6 Jayadeva DFF

下图提出了一种看起来很简单的 single-edge-triggered DFF 结构，以及一种 high-speed DFF 结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-18-39-41_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

> 图源：[[3] Jayadeva G. S., N. Murali, M. S., R. K. Kumar, and N. A. Nair, “Design and Implementation of a High-Speed D Flip Flop using CMOS Inverter Logic,” WSEAS TRANSACTIONS ON ELECTRONICS, vol. 13, pp. 125–129, Dec. 2022, doi: 10.37394/232017.2022.13.16.](https://wseas.com/journals/electronics/2022/a345117-145.pdf)


作者为 Jayadeva G. S.h，因此不妨分别称为 `Jayadeva_12T` 和 `Jayadeva_28T` (删除了 SET/RST 功能)，搭建原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-00-38-46_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-00-20-44_Overview and Verification of D-Latches and D-Flipflops.png"/></div>


### 2.7 comparison of DLs and DFFs

前仿设置如下：
- 晶体管: 
    - ka = 1.5
    - fw/fl = 300n/30n
    - fn = 2
    - mu = 1 (total fn = 2)
- 外部条件: 
    - **VDD = 0.9** @ 4.5 mVrms white noise
    - Corner = (TT, 27°C)
    - time_end = 40*pulse_period
    - pulse_freq = 1G, ..., 50G
    - fnoise_max = 50*pulse_freq


前仿结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-00-40-18_Overview and Verification of D-Latches and D-Flipflops.png"/></div>


由于高频下 rise/fall edge 的对应关系可能存在一定偏差，可能某些结构少了个 rise or fall edge，因此光看上面的 delay 曲线还不行，需要手动查看高频下的输出波形。比较 40 GHz input 下的输出波形发现，只有三种结构能在 40 GHz input 下正常工作：
- `LogicVDD_std_DFF_DLTG10T_22T`
- `LogicVDD_std_DFF_MTSPC_12T`
- `LogicVDD_std_DFF_TSPC_12T`

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-00-29-15_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

看来 TSPC 结构的 DFF 还是最经典的，这也解释了为什么它的出场率极高，且各种改进版本层出不穷了。我们将在下一小节对 TSPC 及其相关改进结构进行考察，以找到满足 14 GHz 频率要求的最佳方案。


注意前文所提到的某些 DFF 结构，在上面的测试下并不能正常工作 (低频也不能)，它们是：
- `LogicVDD_std_DFF_Jayadeva_12T`
- `LogicVDD_std_DFF_Jayadeva_28T`

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-00-52-23_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

### 2.8 digital DFFs comparison

这里补一下 C2MOS (clocked CMOS) DFF 的仿真，毕竟它是 TSPC 的前身，也具有较好的高频性能。下图给出了 C2MOS DFF 的典型结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-00-55-57_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

> 图源：[[4] 知乎 > 模集王小桃 > 动态锁存器 Dynamic latch：TG C2MOS TSPC](https://zhuanlan.zhihu.com/p/1910058311988021237)

搭建原理图如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-01-32-27_Overview and Verification of D-Latches and D-Flipflops.png"/></div>



对 TG10T/TSPC/MTSPC/C2MOS 四种 DFF 进行前仿对比，最高频率结果如下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-03-29-17_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-14-59-20_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

30 GHz 下仿真其电流消耗，结果如下：

将频率范围和功率汇总在这里：
- `LogicVDD_std_DFF_TSPC_12T`   : 2.56 GHz  ~ 75.43 GHz @ 3.722 uA/GHz
- `LogicVDD_std_DFF_C2MOS_12T`  : 0         ~ 51.79 GHz @ 4.673 uA/GHz
- `LogicVDD_std_DFF_MTSPC_12T`  : 5.43 GHz  ~ 51.79 GHz @ 3.854 uA/GHz
- `LogicVDD_std_DFF_DLTG10T_22T`: 0         ~ 39.07 GHz @ 11.88 uA/GHz

显然，还是 conventional TSPC (12T) 的速率最高，功耗也很低，综合性能最好。下图是它们在 30 GHz input 下的输出波形 (output 15 GHz):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-15-03-42_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

可以看出 C2MOS DFF 的输出波形其实不是很好，因此后续不再考虑用它，专心对比 TSPC 及其改进过的几种版本。




## 3. Exploration of TSPC DFFs

### 3.1 basic PET/NET TSPC-DFF

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-01-41-51_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

> 图源：[[5] F. Yuan, “Metastability Correction Techniques for TSPC-DFF with Applications in Vernier TDC,” in 2022 IEEE International Symposium on Circuits and Systems (ISCAS), May 2022, pp. 1449–1452. doi: 10.1109/ISCAS48785.2022.9937432.](https://ieeexplore.ieee.org/document/9937432/)

根据上图先搭建 `TSPC_widthOptimized` 原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-15-16-48_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

版图的话这样做即可 (只是一个示例，最终尺寸是多少我们还没定呢)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-15-38-21_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

然后搭建 `TSPC_NET` (width not optimized) 原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-15-46-14_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

最后搭建 `TSPC_NET_widthOptimized` 原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-15-53-42_Overview and Verification of D-Latches and D-Flipflops.png"/></div>



### 3.2 NET-TSPC-DFF with asy-rst

下图给出了一种 NET-TSPC-DFF with asy-rst, 以及一种 proposed negative-edge-triggered D-flipflop with asy-rst 结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-01-45-29_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

> 图源：[[7] K. L. B. Reddy, K. B. D. Kumar, and V. Pudi, “Design of Energy-Efficient TSPC based D Flip-flop for CNTFET Technology,” in 2021 25th International Symposium on VLSI Design and Test (VDAT), Sep. 2021, pp. 1–4. doi: 10.1109/VDAT53777.2021.9600906.](https://ieeexplore.ieee.org/document/9600906/)

这个 rst 机制感觉不太靠谱，有可能形成 VDD to GND 的短路路径，因此不用。基于 proposed negative-edge-triggered D-flipflop with asy-rst，搭建 `DFF_Reddy` 和 `DFF_Reddy_NET` 原理图如下 (去掉了 RST 功能)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-16-23-33_Overview and Verification of D-Latches and D-Flipflops.png"/></div>



### 3.3 MTSPC-DFF

下图给出了经典 TSPC-DFF 的改进版本 MTSPC-DFF (modified TSPC-DFF)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-16-35-38_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

> 图源：[[1] J. Shaikh and H. Rahaman, “High speed and low power preset-able modified TSPC D flip-flop design and performance comparison with TSPC D flip-flop,” in 2018 International Symposium on Devices, Circuits and Systems (ISDCS), Howrah: IEEE, Mar. 2018, pp. 1–4. doi: 10.1109/ISDCS.2018.8379677.](https://ieeexplore.ieee.org/document/8379677/)

当然，为了统一电路测试接口，我们这里搭建原理图时去掉了 SET/RST 功能，所得原理图 `LogicVDD_std_DFF_MTSPC_12T` 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-17-42-11_Overview and Verification of D-Latches and D-Flipflops.png"/></div> 


### 3.4 ETSPC-DFF (1)

下图给出了 ETSPC-DFF (extended TSPC-DFF) 的结构，属于 TSPC 的 low-power/high-speed 改进版本，不妨称为 **ETSPC-DFF-8T (1)** (因为我们需要加一个 INV, 于是 6T + 2T = 8T):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-02-06-42_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

> 图源：[[8] M. Jung, J. Fuhrmann, A. Ferizi, G. Fischer, R. Weigel, and T. Ussmueller, “Design of a 12 GHz Low-Power Extended True Single Phase Clock (E-TSPC) Prescaler in 0.13µm CMOS technology,” in Asia-Pacific Microwave Conference 2011, Dec. 2011, pp. 1238–1241.](https://ieeexplore.ieee.org/document/6173982/)

**本来这应该是个 negative-edge-triggered ETSPC-DFF** ，但是搭建原理图仿真后发现电路不能正常工作，遂抛弃。

### 3.5 ETSPC-DFF (2)

下图给出了另一种 ETSPC-DFF (extended TSPC-DFF) 结构，属于 TSPC 的 high-speed 改进版本，不妨称为 **ETSPC-DFF-8T (2)**  (因为我们需要加一个 INV, 于是 6T + 2T = 8T):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-02-27-29_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

> 图源：[[9] F. Probst, J. Weninger, A. Engelmann, V. Issakov, and R. Weigel, “Design of an E-TSPC Flip-Flop for a 43 Gb/s PRBS Generator in 22 nm FDSOI,” in 2023 18th European Microwave Integrated Circuits Conference (EuMIC), Sep. 2023, pp. 353–356. doi: 10.23919/EuMIC58042.2023.10288736.](https://ieeexplore.ieee.org/document/10288736/)

论文验证了其作为 43 Gb/s PRBS Generator 时的性能 (22nm FDSOI)，此时时钟频率为 43 GHz，说明此结构至少能在 43 GHz 下正常工作。

### 3.6 comparison of all PET-DFFs

这一小节，对上述几种 TSPC-DFF 结构，以及之前提到的几种较高速 digital DFF 结构进行对比。

由于配置为 DIV2 时输出 Q 总是或多或少有些问题，导致 outputs 中表达式不能准确识别触发器最大工作频率，因此我们改用 Hogge PD 来测试这些 DFF 的最大工作频率。换句话说，用两个实际 DFFs 配合两个 Verilog-A XORs 构成 Hogge PD 结构，在不同频率下测试 PD 输出情况，以此来判断并对比各种 DFF 的最大工作频率。这里用 Verilog-A XORs 是为了避免实际 XOR 门的速度限制影响测试结果。


几点说明：
- (1) 通过观察 DN_ave 的值，即可直接判断 DFF 是否能在该频率下正常工作 (例如不超过低频值的 10%)，避免了繁杂的 output_delay 数学分析 (DN_ave nominal 值为 VDD*25%, 因为 PRBS data density = 0.5, 因此 50% * 50% = 25%)
- (2) 至于这里的频率要多高才能满足 14 GHz 的正常工作要求，可以参考师兄 ISSCC'26 论文里用的这个 `DFF_X1_lvt` 以及 `TSPC_DFF_RVT_1`；
    - 前者在原理图中标注了配置为 DIV2 时的最大工作频率为 31 GHz @ (TT, 0.9V, 0°C) 和 36 GHz @ (SS, 0.9V, 85°C)，以及 (CK to Q delay) t_cq = 21.2 ps @ (SS, 0.9V, 85°C)，也不知是前仿还是后仿；虽然它不是核心 DFF，但也具有一定参考价值；
    - 后者的话原理图里没标，但也可以拿过来仿真看一看，然后我们最终选用的 DFF 要比它俩更快才行。
- (3) 如何在 outputs 中调用不同频率下的 DN_ave 值，然后用 cross + (10% of VDD/4) 来计算最大工作频率？这点我还没尝试成功。所以我们还是 plot 之后通过 horizontal line 来标出 DN_ave 的 nominal 值 (VDD/4)，以及 +10% 的范围，交点即为最大工作频率。


设置 **VDD = 0.9 V @ (TT, 27°C)**，先对师兄 `CDR_TB` 库中的 `TSPC_DFF_RVT_1` 和 `DFF_X1_lvt` 进行前仿/后仿以作参考，结果如下图：
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-19-04-27_Overview and Verification of D-Latches and D-Flipflops.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-19-49-43_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

可能图片不太方便看，这里列一下结果 @ (TT, 0.9V, 27°C)：
- `fromLib_CDRTB_DFF_X1_lvt`:     21.04 GHz @ 后仿，38.03 GHz @ 前仿
- `fromLib_CDRTB_TSPC_DFF_RVT_1`: 16.48 GHz @ 后仿，30.63 GHz @ 前仿

lvt 管子在相同电压下的电流更大，因此速率更快，这是意料之中的。

然后固定晶体管参数为：
- ka = 1.5
- fw/fl = 300n/30n
- fn = 2
- mu = 1 (total fn = 2)

在此参数下对所有 PET-DFFs 结构进行前仿，包括重新设置好的 `TSPC_DFF_RVT_1__pPar` 和 `DFF_X1_lvt__pPar` (保持相同尺寸以更好地对比速率)。但是注意这里不能仿 NET (negative-edge-triggered) 结构，否则 delta_delay_UI = 0 (for PET-DFF) 设置下 Hogge-PD 无法正常工作，需要设置 delta_delay_UI = +0.5 (or -0.5) 才行。

所有 PET-DFFs 前仿结果如下：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-21-58-25_Overview and Verification of D-Latches and D-Flipflops.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-22-18-48_Overview and Verification of D-Latches and D-Flipflops.jpg"/></div>

从高到低依次列出它们的最大工作频率 @ (TT, 0.9V, 27°C)：
- `schematic_LogicVDD_std_DFF_ETSPC_8T`                : 59.88 GHz
- `schematic_fromLib_CDRTB_DFF_X1_lvt__pPar`           : 46.95 GHz
- `schematic_LogicVDD_std_DFF_ETSPC_8T_widthOptimized` : 40.74 GHz
- `schematic_fromLib_CDRTB_TSPC_DFF_RVT_1__pPar`       : 33.81 GHz
- `schematic_LogicVDD_std_DFF_C2MOS_12T`               : 31.16 GHz
- `schematic_LogicVDD_std_DFF_MTSPC_12T`               : 28.49 GHz
- `schematic_LogicVDD_std_DFF_TSPC_12T`                : 27.71 GHz
- `schematic_LogicVDD_std_DFF_TSPC_12T_widthOptimized` : 27.55 GHz
- `schematic_LogicVDD_std_DFF_DLTG10T_22T`             : 25.60 GHz
- `schematic_LogicVDD_std_DFF_DLTG12T_26T`             : 21.95 GHz
- `schematic_LogicVDD_std_DFF_Reddy_12T_widthOptimized`: 15.03 GHz
- `schematic_LogicVDD_std_DFF_DLNAND16T_34T`           : 15.03 GHz
- `schematic_LogicVDD_std_DFF_DLXCP7T_16T`             : 13.79 GHz
- `schematic_LogicVDD_std_DFF_DLNAND18T_38T`           : 12.54 GHz
- `schematic_LogicVDD_std_DFF_Reddy_12T`               : 12.54 GHz
- `schematic_LogicVDD_std_DFF_HL_20T`                  : 11.06 GHz


令人意外的是，PET-ETSPC-DFF (8T) 的速率竟然高达 60 GHz，远超其他结构，甚至比 TSPC-DFF 的 lvt 版本 `DFF_X1_lvt` 还快不少，值得进一步仔细研究。

## 4. exploration of ETSPC-DFFs

### 4.1 nominal performance of ref. DFFs

这一小节给出 ref. DFFs 的详细前后仿性能作为参考，包括以下三个 cells:
- (1) `fromLib_CDRTB_TSPC_DFF_RVT_1`
- (2) `fromLib_CDRTB_DFF_X1_lvt`
- **(3) `fromLib_CDRTB_DFF_X1_ulvt_T28_REF_FOR_XYQ_V0` (CDR 参考电路里最终使用的触发器)**

其中 (2) lvt 和 (3) ulvt 版本的结构、管子 size/fingers 都完全相同，(1) rvt (regular Vt) 的管子尺寸比它们稍大些，输出级 INV 的尺寸也更大些；应该是本来想用 lvt DFF，发现速率不够后换为了 ulvt 版本。



它们的原理图和版图如下：

<div class='center'>

| (1) `fromLib_CDRTB_TSPC_DFF_RVT_1` | (2) `fromLib_CDRTB_DFF_X1_lvt` | **(3) `fromLib_CDRTB_DFF_X1_ulvt_T28_REF_FOR_XYQ_V0` (CDR 电路里最终使用的触发器)** |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-00-16-09_Overview and Verification of D-Latches and D-Flipflops.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-00-15-09_Overview and Verification of D-Latches and D-Flipflops.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-17-15-17_Overview and Verification of D-Latches and D-Flipflops.png"/></div> |
</div>


Ref. DFFs 在 As DIV2 时的 **后仿 @ (TT, 27°C)** 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-18-00-28_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-00-52-43_Overview and Verification of D-Latches and D-Flipflops.png"/></div>



Ref. DFFs 在 As Hogge-PD 时的 **后仿 @ (TT, 27°C)** 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-18-22-22_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

这里先列出三个触发器的速率后仿结果：
- (1) calibre of `fromLib_CDRTB_TSPC_DFF_RVT_1` @ (TT, 0.9V, 27°C):
    - min freq. as DIV2: < 1 GHz 
    - max freq. as DIV2: 27.35 GHz
    - max freq. as Hogge-PD: 15.93 GHz
- (2) calibre of `fromLib_CDRTB_DFF_X1_lvt` @ (TT, 0.9V, 27°C):
    - min freq. as DIV2: < 1 GHz 
    - max freq. as DIV2: 42.78 GHz
    - max freq. as Hogge-PD: 20.73 GHz
- (3) calibre of `fromLib_CDRTB_DFF_X1_ulvt_T28_REF_FOR_XYQ_V0` @ (TT, 0.9V, 27°C):
    - min freq. as DIV2: < 1 GHz 
    - max freq. as DIV2: 46.78 GHz
    - max freq. as Hogge-PD: 21.55 GHz


然后关注一下 (3) `fromLib_CDRTB_DFF_X1_ulvt_T28_REF_FOR_XYQ_V0` 的全工艺角后仿结果 (As DIV2 or Hogge-PD)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-24-02-18-37_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-24-00-40-58_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-01-03-54_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

将其所有后仿结果总结在这里：
- (3) calibre of `fromLib_CDRTB_DFF_X1_ulvt_T28_REF_FOR_XYQ_V0`
- As DIV2 @ (**30 GHz**, TT, 0.9V, 27°C)
    - max freq. = 47.18 GHz (39.79 ~ 51.35)
    - CK to Q delay (t_cq) = 12.54 ps (11.31 ~ 14.57)
    - Q_riseTime = 6.041 ps (6.041 ~ 6.196)
    - Q_fallTime = 3.784 ps (3.693 ~ 4.393)
    - Q_duty  = 51.15% (50.89% ~ 51.27%)
    - QB_duty = 45.81% (44.95% ~ 45.99%)
    - IDD = 227.0 uA (211.2 ~ 281.1) = 7.568 uA/GHz (7.039 ~ 9.368)
- As Hogge-PD @ (**10 GHz**, 0.9V)
    - max freq. = 21.63 GHz (17.53 ~ 26.42)
    - DOUT eyeHeight = 991.3 mUI (978.0 ~ 992.9)
    - DOUT eyeWidth  = 960.3 mUI (953.3 ~ 964.1)

关于此性能的几点说明：
- 嗯……在 ulvt 下仅有这个速率，其实有些慢了；
- 另外，虽然用了 ulvt 管子，但功耗其实没有想象中大，比 `LogicVDD_std_DFF_DLTG10T_22T` 或者 `LogicVDD_std_DFF_ETSPC_8T/10T` 还低一点；
- 也许是 ulvt 的原因， 其 rise/fall time 还挺快的？


### 4.2 nominal performance of ETSPC-DFF

经过上面的仿真，可以确定 ETSPC-DFF 的速度最快，是肯定能用得到的 DFF，因此这里先对其进行扫描遍历，寻找适合 ETSPC-DFF 的最佳尺寸。

As DIV2 (input 1 GHz ~ 100 GHz) 时的 ETSPC-DFF 仿真结果如下：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-01-49-07_Overview and Verification of D-Latches and D-Flipflops.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-01-55-17_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

然后固定 input = 50 GHz, 仿真 1024 个相同单元的电流消耗，得到单个 DFF 功率消耗：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-02-36-53_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

As Hogge-PD (CK 1 GHz ~ 70 GHz) 时的 ETSPC-DFF 仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-02-15-42_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-02-17-34_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

不妨看一下 40 GHz CK 下的 recovered data 眼图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-02-27-27_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

ETSPC-8T 的反向输出端 `QB` 波形不怎么好，这也是我们加上一个 INV 构成 ETSPC-10T 的主要原因 (牺牲了部分速率)。 **由于反相器 INV 的输入阈值电压 vin_th 与 ka = WP/WN 呈正相关** ，因此可以通过调整 ka 来优化 `Q/QB` 的平衡性 (占空比)，从而改善输出波形。

特别地， **眼图中上升沿/下降沿的交点 (纵坐标) 其实就近似等于 INV 的输入阈值电压** ，于是改进方案就很明确了，下面是一个 ETSPC-10T 的具体例子：
- 将 first INV 从 fn = P/N = 1/1 改为 fn = 1/2: 降低 ka 以降低 vin_th, 也即降低 Q_eyeDiagram 的边沿交点
- 将 second INV 从 fn = P/N = 1/1 改为 fn = 4/1: 提高 ka 以提高 vin_th, 也即提高 QB_eyeDiagram 的边沿交点

改进后的仿真结果如下，效果还是很明显的：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-02-33-29_Overview and Verification of D-Latches and D-Flipflops.png"/></div>


也许图片看起来不太方便，那么把上面结果汇总在这里：

- nominal ETSPC-DFF-8T 仿真结果：
    - ka = 1.5, fw/fl = 300n/30n, fn = 2, mu = 1 (total fn = 2)
    - `schematic_LogicVDD_std_DFF_ETSPC_8T`
    - min freq. as DIV2: ≈ 1.921 GHz @ (TT, 0.9V, 27°C)
    - max freq. as DIV2: > 100 GHz @ (TT, 0.9V, 27°C)
    - max freq. as Hogge-PD: 59.53 GHz @ (TT, 0.9V, 27°C)
    - As DIV2 @ (50 GHz, TT, 0.9V, 27°C):
        - CK to Q delay (t_cq) = 6.148 ps
        - rise time (t_rise) = 1.788 ps
        - fall time (t_fall) = 5.692 ps
        - IDD = 416.2 uA = 8.324 uA/GHz
- nominal ETSPC-DFF-10T 仿真结果：
    - VDD = 0.9 V @ (TT, 27°C)
    - ka = 1.5, fw/fl = 300n/30n, fn = 2, mu = 1 (total fn = 2)
    - `schematic_LogicVDD_std_DFF_ETSPC_10T`
    - min freq. as DIV2: ≈ 1.921 GHz @ (TT, 0.9V, 27°C)
    - max freq. as DIV2: ≈ 75.43 GHz @ (TT, 0.9V, 27°C)
    - max freq. as Hogge-PD: 50.09 GHz @ (TT, 0.9V, 27°C)
    - As DIV2 @ (50 GHz, TT, 0.9V, 27°C):
        - CK to Q delay (t_cq) = 7.354 ps
        - rise time (t_rise) = 3.217 ps
        - fall time (t_fall) = 7.794 ps
        - IDD = 456.0 uA = 9.119 uA/GHz


### 4.3 size iteration of ETSPC-DFF-10T (as DIV2)

在 DIV2 TB 下对管子尺寸进行遍历，输入 10 GHz 时的结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-01-16-02_Overview and Verification of D-Latches and D-Flipflops.png"/></div>


输入 70 GHz 时的结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-01-13-09_Overview and Verification of D-Latches and D-Flipflops.png"/></div>


得到两个 70 GHz 下的最佳尺寸：
-  (1) ka = 2.5, fw/fl = 200n/30n, fn = 1, mu = 1 (total fn = 1)
-  (2) ka = 2.0, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2)

它们在 10 GHz 和 70 GHz input 时的输出波形如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-01-24-19_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

嗯，输出波形确实是没有问题的。看看这两个尺寸的最高工作频率，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-00-02-03_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

然后看看这两个最佳尺寸在 as Hogge-PD 下的表现，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-01-24-19_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-01-23-22_Overview and Verification of D-Latches and D-Flipflops.png"/></div>




总结一下它们的表现：


- `schematic_LogicVDD_std_DFF_ETSPC_10T`:
    - (1) ka = 2.5, fw/fl = 200n/30n, fn = 1, mu = 1 (total fn = 1):
        - As DIV2 @ (50 GHz input, TT, 0.9V, 27°C)
            - max freq. = 75.43 GHz
            - CK to Q delay (t_cq) = 7.348 ps
            - Q_riseTime/Q_fallTime = 3.337ps/7.610ps
            - Q_duty/QB_duty = 55.97%/43.78%
        - As Hogge-PD @ (30 GHz, TT, 0.9V, 27°C)
            - max freq. = 59.88 GHz 
            - DOUT eyeHeight/eyeWidth = 988.6mUI/873.7mUI
    - (2) ka = 2.0, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2):
        - As DIV2 @ (50 GHz input, TT, 0.9V, 27°C)
            - max freq. = 82.86 GHz
            - CK to Q delay (t_cq) = 6.634 ps
            - Q_riseTime/Q_fallTime = 3.061ps/7.350ps
            - Q_duty/QB_duty = 55.94%/43.07%
        - As Hogge-PD @ (30 GHz, TT, 0.9V, 27°C)
            - max freq. = 64.06 GHz
            - DOUT eyeHeight/eyeWidth = 992.6mUI/878.4mUI
- `schematic_LogicVDD_std_DFF_ETSPC_10T_betterDuty`:
    - (1) ka = 2.5, fw/fl = 200n/30n, fn = 1, mu = 1 (total fn = 1):
        - As DIV2 @ (50 GHz input, TT, 0.9V, 27°C)
            - max freq. = 68.66 GHz
            - CK to Q delay (t_cq) = 8.867 ps
            - Q_riseTime/Q_fallTime = 6.070ps/8.845ps
            - Q_duty/QB_duty = 51.74%/56.45%
        - As Hogge-PD @ (30 GHz, TT, 0.9V, 27°C)
            - max freq. = 42.72 GHz 
            - DOUT eyeHeight/eyeWidth = 992.1mUI/954.4mUI
    - (2) ka = 2.0, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2):
        - As DIV2 @ (50 GHz input, TT, 0.9V, 27°C)
            - max freq. = 76.73 GHz
            - CK to Q delay (t_cq) = 8.046 ps
            - Q_riseTime/Q_fallTime = 6.078ps/8.508ps
            - Q_duty/QB_duty = 51.65%/54.50%
        - As Hogge-PD @ (30 GHz, TT, 0.9V, 27°C)
            - max freq. = 45.96 GHz 
            - DOUT eyeHeight/eyeWidth = 992.5mUI/947.2mUI

<!-- 
                                                                                    DOUT_eyeHeight (UI) DOUT_eyeWidth (UI)
161	nom	32.08G	2.5	200n	1	schematic_LogicVDD_std_DFF_ETSPC_10T                988.6m	873.7m
162	nom	32.08G	2.5	200n	1	schematic_LogicVDD_std_DFF_ETSPC_10T_betterDuty     992.1m	954.4m
163	nom	32.08G	2	200n	2	schematic_LogicVDD_std_DFF_ETSPC_10T                992.6m	878.4m
164	nom	32.08G	2	200n	2	schematic_LogicVDD_std_DFF_ETSPC_10T_betterDuty     992.5m	947.2m
 -->


### 4.4 size iteration of ETSPC-DFF-10T (as Hogge-PD)

在 Hogge-PD TB 下对管子尺寸进行遍历，设置 CK 频率范围为 40 GHz ~ 67 GHz (10 points) 进行仿真。

先看看 ETPSC-10T w/o duty improvement 结构 (普通 ETPSC-10T) 的遍历结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-15-53-57_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-00-51-14_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

普通 ETPSC-10T (w/o duty improvement) 结构在不同尺寸下的最大速率在 45 GHz ~ 70 GHz 之间，下面列出两个较好的：
- **ka = 2.5, fw/fl = 100n/30n, fn = 2, mu = 1 (total fn = 2)**: 66.09 GHz @ (TT, 0.9V, 27°C)
- **ka = 2.5, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2)**: 65.38 GHz @ (TT, 0.9V, 27°C)
- **ka = 2.5, fw/fl = 300n/30n, fn = 2, mu = 1 (total fn = 2)**: 64.44 GHz @ (TT, 0.9V, 27°C)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-00-58-14_Overview and Verification of D-Latches and D-Flipflops.png"/></div>


然后看看 ETPSC-10T w/i duty improvement 结构的遍历结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-15-12-55_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-20-15-21-16_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

ETPSC-10T w/i better duty 结构在不同尺寸下的最大速率在 42 GHz ~ 47 GHz 之间，下面列出两个较好的：
- **ka = 2.0, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2)**: 46.34 GHz @ (TT, 0.9V, 27°C)
- **ka = 1.5, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2)**: 46.22 GHz @ (TT, 0.9V, 27°C)



### 4.5 post-sim. of ETSPC-DFF-10T (w/o duty improvement)

(1) ka = 2.5, fw/fl = 200n/30n, fn = 1, mu = 1 (total fn = 1):
(2) ka = 2.0, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2):

这一小节对上面提到 ETSPC-DFF-10T 的几种最优尺寸进行版图和后仿验证，看看它们的实际性能表现：
- ETSPC-10T (w/o duty improvement):
    - (1) **ka = 2.5, fw/fl = 200n/30n, fn = 1, mu = 1 (total fn = 1)**: 75.43 GHz as DIV2 @ (TT, 0.9V, 27°C)
    - (2) **ka = 2.0, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2)**: 82.86 GHz as DIV2 @ (TT, 0.9V, 27°C)
    - (3) **ka = 2.5, fw/fl = 100n/30n, fn = 2, mu = 1 (total fn = 2)**: 66.09 GHz as Hogge-PD @ (TT, 0.9V, 27°C)
    - (4) **ka = 2.5, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2)**: 65.38 GHz as Hogge-PD @ (TT, 0.9V, 27°C)
    - (5) **ka = 2.5, fw/fl = 300n/30n, fn = 2, mu = 1 (total fn = 2)**: 64.44 GHz as Hogge-PD @ (TT, 0.9V, 27°C)
- ETSPC-10T w/i duty improvement:
    - (1) **ka = 2.5, fw/fl = 200n/30n, fn = 1, mu = 1 (total fn = 1)**: 68.66 GHz as DIV2 @ (TT, 0.9V, 27°C)
    - (2) **ka = 2.0, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2)**: 76.73 GHz as DIV2 @ (TT, 0.9V, 27°C)
    - (3) 尺寸同上: 46.34 GHz as Hogge-PD @ (TT, 0.9V, 27°C)
    - (4) **ka = 1.5, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2)**: 46.22 GHz as Hogge-PD @ (TT, 0.9V, 27°C)

这里的尺寸实在有些多，我们从中选一个来先试试：**ka = 2.0, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2)**，原理图和版图效果如下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-14-47-24_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

**这里原理图没有用 p-cell (parameterized cell) 而是直接复制器件过来修改参数，是为了避免后续 p-cell 原理图发生改动导致原理图/版图不对应。**



DRC/LVS 都是正常通过的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-14-48-33_Overview and Verification of D-Latches and D-Flipflops.png"/></div>


As DIV2 和 As Hogge-PD 的后仿结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-24-02-18-37_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-24-01-31-58_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-24-00-45-22_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-15-20-33_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-19-05-31_Overview and Verification of D-Latches and D-Flipflops.png"/></div>


把数据总结在这里：
- ETSPC-10T (w/o duty improvement): **ka = 2.0, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2)**
- schematic of `Logic_std_2d0_200nx2_30n_DFF_ETSPC_10T` (pre-layout simulation)
    - As DIV2 @ (**30 GHz**, TT, 0.9V, 27°C)
        - max freq. = 82.86 GHz
        - CK to Q delay (t_cq) = 7.515 ps
        - Q_riseTime/Q_fallTime = 3.309ps/8.854ps
        - Q_duty/QB_duty = 54.40%/45.22%
        - IDD = 331.1 uA = 11.04 uA/GHz
    - As Hogge-PD @ (**10 GHz**, TT, 0.9V, 27°C)
        - max freq. =  57.64 GHz
        - DOUT eyeHeight/eyeWidth = 990.3mUI/971.2mUI
- calibre of `Logic_std_2d0_200nx2_30n_DFF_ETSPC_10T` (post-layout simulation)
    - As DIV2 @ (**30 GHz**, 0.9V)
        - max freq. = 41.54 GHz (36.06 ~ 45.21)
        - IDD = 327.9 uA (280.6 ~ 403.8) = 10.93 uA/GHz (9.352 ~ 13.46)
        - CK to Q delay (t_cq) = 13.58 ps (12.45 ~ 15.36)
        - Q_riseTime = 6.574 ps (6.574 ~ 7.387)
        - Q_fallTime = 12.99 ps (11.43 ~ 14.67)
        - Q_duty  = 59.96% (57.59% ~ 61.99%)
        - QB_duty = 39.17% (38.13% ~ 40.76%)
    - As Hogge-PD @ (**10 GHz**, 0.9V)
        - max freq. = 28.92 GHz (23.81 ~ 33.46)
        - DOUT eyeHeight = 991.5 mUI (987.7 ~ 994.0)
        - DOUT eyeWidth  = 877.6 mUI (838.3 ~ 891.6)
- 注：括号外为 (TT, 0.9V, 27°C) 下的 nominal 值，括号内为 (TT, 27°C), (SS, -40°C), (FF, 130°C) 三种工艺角下的最小/最大值






### 4.6 post-sim. of ETSPC-DFF-10T w/i duty improvement


管子尺寸同上，仍是 **ka = 2.0, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2)**，只是某些管子的 finger 数进行了调整以改善占空比，原理图和版图效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-01-54-48_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

**这里原理图也没有用 p-cell (parameterized cell) 以避免后续 p-cell 原理图发生改动导致原理图/版图不对应。** DRC/LVS 也是正常通过的：

（这里放图）


As DIV2 后仿结果如下，包括：
- (1) 30 GHz input 下的全工艺角后仿结果 (1 个单元)
- (2) 30 GHz input 下的全工艺角功耗后仿结果 (1024 个相同单元)
- (3) 1 GHz ~ 60 GHz input 下的全工艺角速率结果
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-02-13-15_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-15-16-36_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-23-09-36_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

As Hogge-PD 后仿结果如下，包括：
- (1) 10 GHz 下的全工艺角后仿结果
- (2) 1 GHz ~ 50 GHz 下的全工艺角速率结果

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-02-11-53_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-02-19-07_Overview and Verification of D-Latches and D-Flipflops.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-02-45-45_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

把前后仿数据总结在这里：
- ETSPC-10T w/i duty improvement: same size as above
- schematic of `Logic_std_2d0_200nx2_30n_DFF_ETSPC_10T_betterDuty` (pre-layout simulation)
    - As DIV2 @ (**30 GHz**, TT, 0.9V, 27°C)
        - max freq. = 76.73 GHz
        - CK to Q delay (t_cq) = 8.046 ps
        - Q_riseTime/Q_fallTime = 6.078ps/8.508ps
        - Q_duty/QB_duty = 51.65%/54.50%
        - IDD = 456.0 uA = 9.119 uA/GHz
    - As Hogge-PD @ (**10 GHz**, TT, 0.9V, 27°C)
        - max freq. = 45.96 GHz 
        - DOUT eyeHeight/eyeWidth = 992.5mUI/947.2mUI
- calibre of `Logic_std_2d0_200nx2_30n_DFF_ETSPC_10T_betterDuty` (post-layout simulation)
    - As DIV2 @ (**30 GHz**, 0.9V)
        - max freq. = 47.47 GHz (41.34 ~ 47.47)
        - CK to Q delay (t_cq) = 12.23 ps (10.50 ~ 14.60)
        - Q_riseTime = 6.985 ps (6.985 ~ 9.458)
        - Q_fallTime = 8.813 ps (8.792 ~ 8.813)
        - Q_duty = 49.89% (48.35% ~ 50.08%)
        - QB_duty = 49.20% (48.51% ~ 52.30%)
        - IDD = 397.1 uA (334.8 ~ 516.4) = 13.24 uA/GHz (11.16 ~ 17.21)
    - As Hogge-PD @ (**10 GHz**, 0.9V)
        - max freq. = 28.92 GHz (24.89 ~ 28.92)
        - DOUT eyeHeight = 992.9 mUI (982.2 ~ 994.9)
        - DOUT eyeWidth  = 962.2 mUI (955.3 ~ 962.2)


由于此 DFF `Logic_std_2d0_200nx2_30n_DFF_ETSPC_10T_betterDuty` 可能作为 CDR 核心，我们再单独给出其在全工艺角下的 14 GHz 输出眼图作为参考，工艺角包括：
- TT @ (-40°C, 27°C, 130°C)
- SS @ (-40°C, 27°C, 130°C)
- FF @ (-40°C, 27°C, 130°C)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-23-03-15-19_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

可以看到，Q/QB 的输出眼图都非常好，全工艺角下基本上都是满眼图，鲁棒性不错。




### 4.7 post-sim. of ETSPC-DFF-8T (w/o duty improvement)

ETSPC-DFF-8T 的尺寸我们就不搞迭代了，尺寸仍同上，原理图和版图效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-15-02-17_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

DRC/LVS 也是正常通过的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-21-15-01-55_Overview and Verification of D-Latches and D-Flipflops.png"/></div>


As DIV2 后仿结果如下，包括：
- (1) 30 GHz input 下的全工艺角后仿结果 (1 个单元)
- (2) 30 GHz input 下的全工艺角功耗后仿结果 (1024 个相同单元)
- (3) 1 GHz ~ 60 GHz input 下的全工艺角速率结果

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-23-15-18_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-23-00-27-43_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-23-33-16_Overview and Verification of D-Latches and D-Flipflops.png"/></div>


As Hogge-PD 后仿结果如下，包括：
- (1) 10 GHz 下的全工艺角后仿结果 (可以顺便给眼图)
- (2) 1 GHz ~ 50 GHz 下的全工艺角速率结果

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-22-23-20-07_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-23-00-45-23_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

把后仿数据总结在这里：
- calibre of `Logic_std_2d0_200nx2_30n_DFF_ETSPC_8T` (post-layout simulation)
    - As DIV2 @ (**30 GHz**, 0.9V)
        - max freq. = 55.19 GHz (55.19 ~ 55.19)
        - IDD = 322.8 uA (283.1 ~ 391.3) = 10.76 uA/GHz (9.436 ~ 13.06)
        - CK to Q delay (t_cq) = 12.44 ps (10.90 ~ 14.09)
        - Q_riseTime = 4.423 ps (4.423 ~ 5.438)
        - Q_fallTime = 9.537 ps (7.481 ~ 11.73)
        - Q_duty  = 59.14% (57.88% ~ 62.54%)
        - QB_duty = 44.97% (42.90% ~ 44.97%)
    - As Hogge-PD @ (**10 GHz**, 0.9V)
        - max freq. = 33.77 GHz (26.74 ~ 39.50)
        - DOUT eyeHeight = 991.7 mUI (985.0 ~ 994.6)
        - DOUT eyeWidth  = 938.6 mUI (922.2 ~ 956.1)








### 4.8 post-sim. of ETSPC-DFF-8T w/i duty improvement

管子尺寸同上，仍是 **ka = 2.0, fw/fl = 200n/30n, fn = 2, mu = 1 (total fn = 2)**，只是某些管子的 finger 数进行了调整以改善占空比，原理图和版图效果如下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-23-00-00-38_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

DRC/LVS 也是正常通过的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-23-00-01-19_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

As DIV2 后仿结果如下，包括：
- (1) 30 GHz input 下的全工艺角后仿结果 (1 个单元)
- (2) 30 GHz input 下的全工艺角功耗后仿结果 (1024 个相同单元)
- (3) 1 GHz ~ 60 GHz input 下的全工艺角速率结果
 
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-23-00-20-04_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-23-02-12-16_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-23-03-07-49_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

As Hogge-PD 后仿结果如下，包括：
- (1) 10 GHz 下的全工艺角后仿结果
- (2) 1 GHz ~ 50 GHz 下的全工艺角速率结果

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-23-00-52-26_Overview and Verification of D-Latches and D-Flipflops.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-23-02-50-43_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

把后仿数据总结在这里：
- calibre of `Logic_std_2d0_200nx2_30n_DFF_ETSPC_8T_betterDuty` (post-layout simulation)
    - As DIV2 @ (**30 GHz**, 0.9V)
        - max freq. = 55.19 GHz (50.77 ~ 55.19)
        - IDD = 374.3 uA (335.1 ~ 469.9) = 12.48 uA/GHz (11.17 ~ 15.66)
        - CK to Q delay (t_cq) = 12.11 ps (10.31 ~ 14.38)
        - Q_riseTime = 5.991 ps (5.898 ~ 8.723)
        - Q_fallTime = 5.572 ps (5.572 ~ 7.021)
        - Q_duty  = 49.86% (49.59% ~ 49.86%)
        - QB_duty = 47.54% (45.68% ~ 47.54%)
    - As Hogge-PD @ (**10 GHz**, 0.9V)
        - max freq. = 29.15 GHz (26.71 ~ 29.15)
        - DOUT eyeHeight = 992.1 mUI (975.6 ~ 993.6)
        - DOUT eyeWidth  = 966.7 mUI (933.3 ~ 966.7)



由于此 DFF `Logic_std_2d0_200nx2_30n_DFF_ETSPC_8T_betterDuty` 可能作为 CDR 核心，我们再单独给出其在全工艺角下的 14 GHz 输出眼图作为参考，工艺角包括：
- TT @ (-40°C, 27°C, 130°C)
- SS @ (-40°C, 27°C, 130°C)
- FF @ (-40°C, 27°C, 130°C)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-23-03-11-29_Overview and Verification of D-Latches and D-Flipflops.png"/></div>


可以看到，Q 的输出眼图都非常好，全工艺角下基本上都是满眼图，鲁棒性不错。QB 的话波形不是很好看，这是意料之中的，毕竟 ETPSC-DFF-8T 只留了 Q 作为推荐输出端口，想同时使用 QB 的话换为 ETPSC-DFF-10T 即可。

### 4.9 summary of ETSPC-DFFs

将上面五种 ETSPC-DFF 的后仿数据总结在一起，方便对比：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-24-03-42-19_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

顺便给出三种核心 DFF 在 3-corner 下的 BER 仿真结果 (As Hogge-PD)，包括：
- `fromLib_CDRTB_DFF_X1_ulvt_T28_REF_FOR_XYQ_V0`
- `Logic_std_2d0_200nx2_30n_DFF_ETSPC_8T_betterDuty`
- `Logic_std_2d0_200nx2_30n_DFF_ETSPC_10T_betterDuty`
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-24-14-18-34_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

以及它们在 14 GHz 下的 Q/QB 输出眼图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-24-14-22-28_Overview and Verification of D-Latches and D-Flipflops.png"/></div>




## 5 comparison of NET-DFFs

## 6. Overview of CML DFFs

## 7. Overview of DET-DFFs

### 7.1 TG-based DET-DFFs

下图给出了四种常见的 digital DET-DFF 结构，都是基于 TG gate 的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-19-20-11-04_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

> 图源：[[10] M. Pedram, Q. Wu, and X. Wu, “A new design of double edge triggered flip-flops,” in Proceedings of 1998 Asia and South Pacific Design Automation Conference, Feb. 1998, pp. 417–421. doi: 10.1109/ASPDAC.1998.669513.](https://ieeexplore.ieee.org/abstract/document/669513)

四种结构中，我们只考虑 (1) (3) (4) 三种，因为第二种不是 CMOS 的，将其推广到对称 CMOS 即得 (3)。这三种结构分别命名为：
- `LogicVDD_std_DFF_DET_MUX2`
- `LogicVDD_std_DFF_DET_TG_24T`
- `LogicVDD_std_DFF_DET_TG_20T`



### 7.2 TSPC DET-DFFs

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-21-02-44_Overview and Verification of D-Latches and D-Flipflops.png"/></div>

> 图源：[[6] M. Afghahi and J. Yuan, “Double-edge-triggered D-flip-flops for high-speed CMOS circuits,” IEEE Journal of Solid-State Circuits, vol. 26, no. 8, pp. 1168–1170, Aug. 1991, doi: 10.1109/4.90071.](https://ieeexplore.ieee.org/document/90071)

搭建原理图如下：



## Reference

- [[1] J. Shaikh and H. Rahaman, “High speed and low power preset-able modified TSPC D flip-flop design and performance comparison with TSPC D flip-flop,” in 2018 International Symposium on Devices, Circuits and Systems (ISDCS), Howrah: IEEE, Mar. 2018, pp. 1–4. doi: 10.1109/ISDCS.2018.8379677.](https://ieeexplore.ieee.org/document/8379677/)
- [[2] S. S. Vali and A. kumar N, “Design of low delay low power hybrid logic based flip-flop using FinFET,” e-Prime - Advances in Electrical Engineering, Electronics and Energy, vol. 9, p. 100648, Sep. 2024, doi: 10.1016/j.prime.2024.100648.](https://www.sciencedirect.com/science/article/pii/S2772671124002286)
- [[3] Jayadeva G. S., N. Murali, M. S., R. K. Kumar, and N. A. Nair, “Design and Implementation of a High-Speed D Flip Flop using CMOS Inverter Logic,” WSEAS TRANSACTIONS ON ELECTRONICS, vol. 13, pp. 125–129, Dec. 2022, doi: 10.37394/232017.2022.13.16.](https://wseas.com/journals/electronics/2022/a345117-145.pdf)
- [[4] 知乎 > 模集王小桃 > 动态锁存器 Dynamic latch：TG C2MOS TSPC](https://zhuanlan.zhihu.com/p/1910058311988021237)
- [[5] F. Yuan, “Metastability Correction Techniques for TSPC-DFF with Applications in Vernier TDC,” in 2022 IEEE International Symposium on Circuits and Systems (ISCAS), May 2022, pp. 1449–1452. doi: 10.1109/ISCAS48785.2022.9937432.](https://ieeexplore.ieee.org/document/9937432/)
- [[6] M. Afghahi and J. Yuan, “Double-edge-triggered D-flip-flops for high-speed CMOS circuits,” IEEE Journal of Solid-State Circuits, vol. 26, no. 8, pp. 1168–1170, Aug. 1991, doi: 10.1109/4.90071.](https://ieeexplore.ieee.org/document/90071)
- [[7] K. L. B. Reddy, K. B. D. Kumar, and V. Pudi, “Design of Energy-Efficient TSPC based D Flip-flop for CNTFET Technology,” in 2021 25th International Symposium on VLSI Design and Test (VDAT), Sep. 2021, pp. 1–4. doi: 10.1109/VDAT53777.2021.9600906.](https://ieeexplore.ieee.org/document/9600906/)
- [[8] M. Jung, J. Fuhrmann, A. Ferizi, G. Fischer, R. Weigel, and T. Ussmueller, “Design of a 12 GHz Low-Power Extended True Single Phase Clock (E-TSPC) Prescaler in 0.13µm CMOS technology,” in Asia-Pacific Microwave Conference 2011, Dec. 2011, pp. 1238–1241.](https://ieeexplore.ieee.org/document/6173982/)
- [[9] F. Probst, J. Weninger, A. Engelmann, V. Issakov, and R. Weigel, “Design of an E-TSPC Flip-Flop for a 43 Gb/s PRBS Generator in 22 nm FDSOI,” in 2023 18th European Microwave Integrated Circuits Conference (EuMIC), Sep. 2023, pp. 353–356. doi: 10.23919/EuMIC58042.2023.10288736.](https://ieeexplore.ieee.org/document/10288736/)
- [[10] M. Pedram, Q. Wu, and X. Wu, “A new design of double edge triggered flip-flops,” in Proceedings of 1998 Asia and South Pacific Design Automation Conference, Feb. 1998, pp. 417–421. doi: 10.1109/ASPDAC.1998.669513.](https://ieeexplore.ieee.org/abstract/document/669513)
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()


其它：
- [[x] mbedded.ninja > Digital Logic > Latches and Flip-Flops](https://blog.mbedded.ninja/electronics/circuit-design/digital-logic/latches-and-flip-flops/)
- [知乎 > StrongARM Latch 比较器设计](https://zhuanlan.zhihu.com/p/598924151)