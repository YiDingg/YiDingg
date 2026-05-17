# Overview and Verification of CDR Phase and Frequency-Detectors 

## Introduction

传统 CDR (clock and data recovery) 仅带有一路 BB-PD (bang-bang phase detector) 或 Linear-PD，虽然能实现相位误差检测，但无法直接检测频率误差，因此频率锁定范围 (pull-in range) 较窄，在初始频率误差较大的情况下常常无法成功锁定。

本文先介绍两种最常见的 CDR 相位检测器 (Hogge-PD 和 Alexander-PD)，就近年来提出/常用的几种 Bi-Directional Frequency Detector for CDR 方案进行讨论 (主要讨论双向 FD)，分析其原理、优缺点以及适用场景，并通过 verilog-a 搭建行为级模型进行仿真验证。



## 1. CDR Phase-Detector


### 1.1 Hogge-PD (H-PD)
- Oversampling: 2X
- Operation clock: full-rate/half-rate/quarter-rate
- PD output: linear @ $\Delta \phi \in [-\pi, \pi]$ 
- FD pull-in range: $f_{CK} \in (0,\ f_b) \to f_b$ (full-rate, uni-directional)



Hogge-PD 是由 C. R. Hogge 在 1985 年提出的一种 linear phase detector for CDR，也是最常见的 Linear-PD 方案，它通过比较原始数据在首次采样 (first sampling) 后延时了多少来获取 data/CK 之间的相位信息。

为方便分析，假设 sampling period $T_s$ 等于 bit period $T_b$，则 Hogge-PD 的基本原理是：
- (1) 由 pos-edge of CK 作为时钟输入的 DFF 先对原始输入数据进行一次采样，此时 1st-sampled data 相比 raw data 的延时为 sampling-instant 减去 pos-edge of raw data, 即 $(\Delta t)_1 = t_{s} - t_{d}$
- (2) 然后利用 DFF 再对 1st-sampled data 做一次 time shift，这里的 DFF 仍由 CK 作为时钟，但输入边沿是 neg-edge (或者说是 neg-edge-triggered DFF)，因此延时量恰好为时钟周期的一半 $(\Delta t)_2 = \frac{1}{2} T_s$
- (3) 由 XOR gate 进行异或操作提取出这两个延时 $(\Delta t)_1$ 和 $(\Delta t)_2$ 进行比较，即可看出当前的 sampling-instant 是落在 data bit 正中央 (ideal case)，还是偏向前 (early/leading) 或偏向后 (late/lagging)，即实现了相位误差检测

下图是 Hogge-PD 最简单的实现例子 (full-rate 2-phase CK)，共使用了 2 DFFs + 2 XORs，这里 full-rate CK 意思就是 CK period = bit period:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-17-02-09_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-08-15-14-23_Overview and Verification of CDR Frequency Detectors.png"/></div> 
>图片来自：[ECE 6440 - Frequency Synthesizers (© P.E. Allen - 2003) > Lecture 200 – Clock and Data Recovery Circuits - I (6/26/03)](https://pallen.ece.gatech.edu/Academic/ECE_6440/Summer_2003/L200-CDR-I(2UP).pdf)，但是注意原图在上图右侧的标注 "CK is ahead of data center" 错误，右半边画的其实是 "CK late (CK is behind data center)" 情况。
-->

Hogge-PD 的优点是结构简单，不但具有线性相差检测能力 (方便系统环路分析)，而且在整个 $[-\pi, \pi]$ 相差范围内都能正常工作，所以也具有一定频率捕获能力。从实现角度上讲，由于 Hogge-PD 最小采样间隔为 0.5 UI of data period, 因此也是典型的 2X-oversampling PD 结构，也就是 2-phase full-rate CK, 4-phase half-rate CK 或者 8-phase quarter-rate CK 下都可实现。

特别地，对于 full-rate CK 的情况，之所以使用两相时钟而不是 neg-edge-triggered DFF 来实现第二次采样，是因为这样可以避免时钟占空比失真带来的输出特性偏移。


不妨给一个 Hogge-PD 的仿真示例，testbench 设置和仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-08-20-33-53_Overview and Verification of CDR Frequency Detectors.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-08-20-39-10_Overview and Verification of CDR Frequency Detectors.png"/></div>

下图则给出了仿真得到的 Hogge-PD 相差特性曲线 (delta_f = 0, delta_phi ≠ 0)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-08-21-28-52_Overview and Verification of CDR Frequency Detectors.png"/></div>


那么，如何仿真 Hogge-PD 的频差特性曲线呢？我们知道，当时钟频率 $f_{CK}$ 与目标频率 $f_{tar}$ 不同时，随着时间变化相位会不断积分，使每个小间隔内 CK 与 data 的相位差 $\Delta \phi$ 都不同，因此在频差曲线中设定初始相位关系的意义不大。当然，一些特定的频率点除外，例如 $\Delta f = (f_{CK} - f_{tar}) = \pm 0.5\times f_{tar},\ \pm 1 \times  f_{tar}$，这些频率点在单个或多个 CK period or bit period 周期积分后，相位差 $\mathrm{mod}(\Delta \phi,\ 2\pi)$ 又回到初值，不断循环往复，因此在这些频率点上得到的频差输出特性一般不具有普遍性，不能用作频差特性曲线的代表点。

所以，我们在仿真 Hogge-PD 的频差特性曲线时，应该避开上述特殊频率点，选择一些不那么 trivial 的频率点进行仿真，并且每个频率点的仿真时间要足够长，以保证相位差 $\Delta \phi$ 能够覆盖多个 $[-\pi, \pi]$ 周期，平均之后便能得到比较准确的频差特性曲线了。

有了仿真思路后，便来实操一下。下图展示了仿真得到的 Hogge-PD 频差特性曲线 (delta_phi = 0, delta_f ≠ 0)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-09-01-55-15_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>


增加仿真时长可得到更平滑的频差特性曲线 (平均效果更好)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-09-02-38-47_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

图中可以看出 Hogge-PD 属于单向 (正向) 频差检测器，仅当 CK frequency < desired frequency，也即 $\Delta f = (f_{CK} - f_{tar}) < 0$ 时才能正确输出频差信息，对另一边的频率捕获 (CK freq. > desired freq.) 则无能为力。



### 1.2 Alexander-PD (A-PD)

- Oversampling: 2X
- Operation clock: full-rate/half-rate/quarter-rate
- PD output: bang-bang @ $\Delta \phi \in [-\pi, \pi]$ 
- FD pull-in range: none (no frequency detection capability)

Alexander-PD 是由 J. Alexander 在 1985 年提出的一种 bang-bang phase detector for CDR，也是最常见的 BB-PD 方案，它通过 edge and data sampling (X2-oversampling) 来获取 data 与 CK 之间的相位信息。


其具体实现方法和判决原理如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-08-21-43-47_Overview and Verification of CDR Frequency Detectors.png"/></div>

>图源：page.13 of [[1] ECE 6440 - Frequency Synthesizers > LECTURE 200 – CLOCK AND DATA RECOVERY CIRCUITS (© P.E. Allen - 2003)](https://pallen.ece.gatech.edu/Academic/ECE_6440/Summer_2003/L200-CDR-I(2UP).pdf)

我们之前在文章 [Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals](<AnalogIC/Razavi PLL - Chapter 13. Clock and Data Recovery Fundamentals.md>) 已给过更详细的原理解读，这里就不再赘述了。总的来说，Alexander-PD 也比较简单，是 CDR 中使用最广泛的 BB-PD 方案，但它的频率捕获能力非常差，任何一边频差都没法检测到，因此在实际系统中往往需要配合一个辅助 frequency detection loop 来实现频率捕获。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-08-21-46-56_Overview and Verification of CDR Frequency Detectors.png"/></div>


下图是 Alexander-PD 的相差特性仿真结果，横坐标范围为 $\Delta t \in (- 0.5 \ \mathrm{UI},\ + 0.5 \ \mathrm{UI})$：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-09-02-44-31_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>


将横坐标范围缩小到 $\Delta t \in (- 0.05 \ \mathrm{UI},\ + 0.05 \ \mathrm{UI})$，可以看到由时钟抖动引起的有限斜率：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-09-03-03-07_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

横坐标进一步缩小到 $\Delta t \in (- 10 \ \mathrm{UI},\ + 10 \ \mathrm{UI})$，并增大仿真时长到 2^12 of data periods, 可以很清楚地看到有限斜率 (due to CK jitter,  这里是 100 V/UI, 也即 100 V/ns) 和曲线偏移 (due to logic delay)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-09-15-05-23_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

下图则是 Alexander-PD 的频差特性仿真结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-09-02-41-03_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

从频差曲线可以看出，Alexander-PD 是完全没有频率捕获能力的，只能作为 Phase Detector 来使用。




## 2. CDR Frequency-Detector


### 2.1 Pottbacker-FD




- **Half-rate mode:** 2X-oversampling (4-phase @ half-rate)
  - PD output: bang-bang @ $\Delta \phi \in [-\pi, \pi]$ 
  - FD output: linear @ $\Delta f \in (-0.5 f_b,\ 0.5 f_b)$
  - FD pull-in range: $f_{CK} \in (0,\ f_b) \to 0.5f_b$ (half-rate)
  - can be used as a complete PFD (phase-frequency detector) for CDR
- **Full-rate mode:** 4X-oversampling (4-phase @ full-rate)
  - PD output: none (no phase detection capability)
  - FD output: bang-bang @ $\Delta f \in (-0.5 f_b,\ 0.5 f_b)$
  - FD pull-in range: $f_{CK} \in (0.5 f_b,\ 1.5 f_b) \to f_b$ (full-rate)
- **Can NOT be used in quarter-rate mode**


下图是一种还算简单的 FD dor CDR 方案，注意第一级的两个 DFF 是 DET-DFF (double-edge-triggered D-flipflop)，而第二级的一个 DFF 才是普通的 pos-edge-triggered DFF：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-09-16-27-19_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

>图源：page.33 of [[2] SerDes 系統簡介及相關數位訊號處理技巧 (顏睿甫, National Taiwan University, 6/5/2023)](https://djj.ee.ntu.edu.tw/SerDes.pdf)




<!-- 并且时钟是 full-rate quadrature CK (or full-rate 4-phase CK)，因此这个电路是 4X-oversampling 的 FD 方案： -->

先假设目标时钟频率为 full rate (= data rate)，则 Pottbacker-FD 的频差特性曲线仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-17-58-22_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-09-15-48-10_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

可以看到输出曲线中存在两个 zero-crossing point，分别对应于 $f_{CK} = 0.5 f_b$ 和 $f_{CK} = 1.0 f_b$，其中 $f_b$ 是数据速率 (bit rate)。这意味着 Pottbacker-FD 在 half-rate (4-phase) 和 full-rate (4-phase) CK 下都能正常工作。

工作在 half-rate CK 时，其目标频率为 $f_{tar} = 0.5 f_b$：当 $f_{CK} < 0.5 f_b$ (CK Slow) 时，输出为正，表示 CK 频率过低；反之当 $f_{CK} > 0.5 f_b$ (CK Fast) 时，输出为负，表示 CK 频率过高。此时 Pottbacker-FD 的 pull-in range = $\pm f_{tar} = \pm 0.5 f_b$，也即在 $(0,\ 1.0 f_b)$ 范围内都能成功捕获。

第二种情况，工作在 full-rate CK 时，其目标频率为 $f_{tar} = 1.0 f_b$：当 $f_{CK} < 1.0 f_b$ 时，输出为负，表示 CK 频率过低；反之则输出正。这种情况下其 pull-in range = $\pm 0.5 f_{tar} = \pm 0.5 f_b$，也即在 $(0.5 f_b,\ 1.5 f_b)$ 范围内都能成功捕获。


Pottbacker-FD 在 full-rate 时的相差特性如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-09-16-30-33_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

很明显，Pottbacker-FD 在 full-rate CK 下不具有相差检测能力，无法提供任何相位误差信息。

在 half-rate 时的相差特性如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-16-41-20_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-17-37-54_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

出乎意料的是，Pottbacker-FD 在 half-rate CK 下表现出了 bang-bang PD 的特性。


那么在 half-rate CK 下，Pottbacker-FD 能否用作完整的 PFD (phase-frequency detector) 呢？从 FD 角度，其在 CK Slow 时输出 OUT = 1；从 PD 角度，其在 CK Late (delay > 0) 时输出 OUT = 1；又因为 CK Slow 和 CK Late 是 "同向" 的，都会使 CK freq. 升高来达到锁定，因此确实 **可以作为一个完整的 PFD 来使用，相当于 Bang-Bang PD + Linear FD 的组合体。**



### 2.2 Pottbacker-FD with XOR

- **Incorrect implementation: can not use**


下面这张图是在 Pottbacker-FD 的基础上额外增加了一个 XOR gate：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-08-22-29-48_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

>图源：page.15 of [[1] ECE 6440 - Frequency Synthesizers > LECTURE 200 – CLOCK AND DATA RECOVERY CIRCUITS (© P.E. Allen - 2003)](https://pallen.ece.gatech.edu/Academic/ECE_6440/Summer_2003/L200-CDR-I(2UP).pdf)

其频差特性曲线如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-17-58-42_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-17-39-29_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

加入 XOR gate 后却失去了频率捕获能力？可能是我们错误理解了图中的 $\oplus$ 符号，原文的意思也许是 (UP - DN)，这就是他自己写得不好了，不清不楚的，存在歧义。


### 2.3 Richman-FD

其实上面 **2.1 Pottbacker-FD** 就是 Richman-FD (下图) 的简化版，但 Richman-FD 的资源消耗更多些 (主要是功耗)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-18-00-50_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

>图源：page.15 of [[1] ECE 6440 - Frequency Synthesizers > LECTURE 200 – CLOCK AND DATA RECOVERY CIRCUITS (© P.E. Allen - 2003)](https://pallen.ece.gatech.edu/Academic/ECE_6440/Summer_2003/L200-CDR-I(2UP).pdf)

至于其输出性能有何优势，不妨仿真实践一下。下图是 Richman-FD 的原理图和频差特性曲线：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-17-59-02_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-18-04-50_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

可以看出 Richman-FD 共有三个 zero-crossing points，分别对应于 $f_{CK} = 0.5 f_b,\ 1.0 f_b$ 和 $1.5 f_b$。显然，只有 $f_{CK} = 0.5 f_b$ 和 $f_{CK} = 1.0 f_b$ 这两个点是有意义的，分别对应 half-rate 和 full-rate 下的目标频率。


下图是 Richman-FD 的 full-rate (X4-oversampling) 相差特性曲线：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-18-11-46_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

full-rate 下的 PD output chara. 就有些奇怪，只能说可以起到一定的相位误差指示作用吧：可以正常检测 CK Early (delay < 0)，但是对 CK Late 的检测就存在 (0, 0.25 UI) 的死区。


下图则是 half-rate (X2-oversampling) 相差特性曲线：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-18-12-53_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

在 half-rate 下 Richman-FD 不具有任何相位检测能力，只能作为一个纯粹的 frequency detector 来使用。从这一点看，Richman-FD 的输出特性是不如 Pottbacker-FD 的，毕竟后者在 half-rate 下能作为一个完整的 PFD 来使用，更别说 Richman-FD 的功耗开销要大得多。



### 2.4 Simple-FD


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-09-15-23-09_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

> 图源：[[3] P. Anand, R. Mahadev, K. M. Le, and Z. Abbas, “A Dual-Loop CDR with an Extended Bidirectional Frequency Detection Technique for Wide Tuning Applications,” in 2025 IEEE 68th International Midwest Symposium on Circuits and Systems (MWSCAS), Aug. 2025, pp. 996–1000. doi: 10.1109/MWSCAS53549.2025.11244503.](https://ieeexplore.ieee.org/document/11244503/)

其 FD output chara. 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-19-34-13_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-19-28-42_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>


如果只看 `OUT` 端口输出，是典型的 full-rate uni-directional FD 方案，只有当 $f_{CK} < f_{tar}$ 时才能正常输出频差信息；如果再算上 `(OUTB - VDD/2)`，便能够实现双向频差检测了，当然 `VDD/2` 这个偏置电压的设置也比较麻烦，增加了电路复杂度。

PD output chara. 就不看了，这个电路也没啥意思。



### 2.5 DQFD

下图给出了一种 Half-Rate Conventional/Jitter-Tolerant DQFD (digital quadricorrelator frequency detector) 方案，用到了 half-rate 8-phase clock. 


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-10-19-51-03_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-13-47-10_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

> 图源：[[4] J. Kim, Y. Ko, J. Jin, J. Choi, and J.-H. Chun, “A Referenceless Digital CDR with a Half-Rate Jitter-Tolerant FD and a Multi-Bit Decimator,” Electronics, vol. 11, no. 4, p. 537, Jan. 2022, doi: 10.3390/electronics11040537.](https://www.mdpi.com/2079-9292/11/4/537)

这里图中的 Conventional Full-rate DQFD (digital quadricorrelator frequency detector) 就是我们前面介绍过的 **2.1 Pottbacker-FD**，当时我们指出 half-rate 才是其更合适的工作模式 (可作为完整 PFD)，而 full-rate 只能作为 FD 使用。


下面对图中 Conventional Half-rate DQFD 的输出特性进行仿真验证，首先是频差特性曲线：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-02-45-02_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-02-36-17_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

可以看出 Conventional Half-rate DQFD 可以在 half-rate 和 full-rate CK 两种模式下正常工作，但 pull-in range 都比较小：
- half-rate mode: $f_{CK} \in (0.40 f_b,\ 0.60 f_b) \to 0.50 f_b,\ \ \ \Delta f = \pm 0.10 f_b$
- full-rate mode: $f_{CK} \in (0.925 f_b,\ 1.075 f_b) \to 1.0 f_b,\ \ \ \Delta f = \pm 0.075 f_b$

quarter-rate mode 这里看似可行，但只要缩小 freq. sweep step 就会发现无法正常工作。





再来看看其在 quarter-rate mode 下的相差特性曲线：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-02-47-06_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

虽然表现出了较好的 bang-bang PD 特性，但是 "CK Early (delay < 0)" 与 "CK Slow" 两种信号 **是反向的**，前者会使 $f_{CK} \downarrow$ 而后者会使 $f_{CK} \uparrow$。因此在 quarter-rate mode 下 Conventional DQFD 的 PD output chara. 与 FD output chara. **不兼容，无法作为一个完整的 PFD 来使用。**




最后看看 half-rate mode 下的相差特性曲线：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-02-40-16_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

此模式下没有鉴相能力。


### 2.6 JT-DQFD

然后对上一小节的 JT-DQFD (Jitter-Tolerant DQFD) 进行仿真验证，其原理图和频差特性曲线如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-03-40-46_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-03-39-36_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

嗯，频响曲线没有变化 (与 conventional DQFD 相同)，说明确实只增加了 jitter-tolerant 机制，并没有改变其频率检测能力。

看看 half-rate mode 下的相差特性曲线有无变化：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-03-52-17_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

加入 JT 机制后，half-rate mode 下便基本不具有任何相位检测能力了，算是避免了之前 conventional DQFD 出现的 "矛盾" 情况。


降低 freq. sweep step 后重新仿真，仔细观察 JT-DQFD 的频差特性曲线：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-13-55-53_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

这里可以看出 quarter-rate mode 下的输出特性实在不太好，


### 2.7 M-DQFD

下图提出了一种称为 M-DQFD (modified-DQFD) 的 FD 方案：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-02-30-55_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

>图源：[[5] P. M. Ha, N. H. Tho, H. H. Hanh, and Q. Nguyen-The, “A Wide-band Reference-less Bidirectional Continuous-Rate Frequency Detector,” in 2019 3rd International Conference on Recent Advances in Signal Processing, Telecommunications & Computing (SigTelCom), Mar. 2019, pp. 25–29. doi: 10.1109/SIG℡COM.2019.8696267.](https://ieeexplore.ieee.org/document/8696267)

其原理图和频差特性曲线如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-14-18-42_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-04-25-53_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

降低 freq. sweep step 后重新仿真，得到更细致的频差特性曲线结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-14-21-59_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>


### 2.8 QR-DQFD

下图提出了一种 quarter-rate DQFD 方案：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-14-55-05_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

>图源：page.105 of [[6] M. Assaad, “Design and modeling of clock and data recovery integrated circuit in 130 nm CMOS technology for 10 Gb/s serial data communications,” THE DEGREE OF DOCTOR OF PHILOSOPHY, UNIVERSITY OF GLASGOW, 2009.](https://theses.gla.ac.uk/707/1/2009assaadphd.pdf)

经验证，此结构只能在 half-rate or full-rate CK (16-phase) 下正常工作，我也不清楚作者这 quarter-rate 是怎么来的，其在论文中对 FD 的仿真验证也比较粗糙。


### 2.9 QR-QRFD

下图提出了一种 quarter-rate QRFD (quadrature rotational frequency detector) 方案：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-22-10-28_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

>图源：[[8] J.-P. Hong, M. Lee, J. Koo, and J.-Y. Sim, “A Synthesizable Quarter-Rate CDR based on All Digital Fractional-N PLL with Quadrature Rotational Frequency Detector,” IEICE Electronics Express, vol. advpub, 2025, doi: 10.1587/elex.22.20250358.](https://www.jstage.jst.go.jp/article/elex/22/17/22_22.20250358/_article)

搭建原理图后对频差特性曲线进行仿真，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-22-28-29_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-22-24-33_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

缩小 freq. sweep step 以得到更细致的频差特性曲线：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-12-03-11-05_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

图中可以看出，QR-QRFD 共有三种工作模式：
- full-rate @ 16-phase (16X-OS): pull-in range = $\pm 0.15 f_b$
- half-rate @ 16-phase (8X-OS): pull-in range = $\pm 0.07 f_b$
- quarter-rate @ 16-phase (4X-OS): pull-in range = $\pm 0.04 f_b$


论文中仅对初始频偏 $(\Delta f)_0 = + 3\,\%$ 进行了仿真验证，能够成功捕获，也符合我们上面所说的 pull-in range @ quarter-rate mode = $\pm 0.04 f_b = \pm 4\,\%$，当然，这里是默认了论文中 "freq. offset" 是相对 data rate 而言的。

但看论文里的语气，更像是相对 target CK freq. 而言，这样的话论文中给出的例子就是初始频偏 $(\Delta f)_0 = \frac{+0.03 f_b}{4} = \frac{+7.5}{1000} f_b$，算是非常小了，一般来讲这个范围直接用 PD 就行，FD 只能做到这地步的话也完全没必要。






### 2.10 summary of CDR FDs


- **2.1 Pottbacker-FD**:
    - (4X-OS) full-rate @ 4-phase: Bi-FD, pull-in range = $(0.5 f_b,\ 1.5 f_b) = f_{tar} \pm 0.5 f_b$
    - (2X-OS) half-rate @ 4-phase: Bi-PFD, pull-in range = $(0,\ 1.0 f_b) = f_{tar} \pm 0.5 f_b$
- **2.3 Richman-FD**:
    - (4X-OS) full-rate @ 4-phase: Bi-FD, pull-in range = $(0.5 f_b,\ 1.5 f_b) = f_{tar} \pm 0.5 f_b$
    - (2X-OS) half-rate @ 4-phase: Bi-FD + partial-PD, pull-in range = $(0,\ 1.0 f_b) = f_{tar} \pm 0.5 f_b$
- **2.4 Simple-FD**:
    - (4X-OS) full-rate @ 4-phase: Uni-FD, pull-in range = $(0,\ 1.0 f_b) \to f_b$
    - With additional biasing `VDD/2`: Bi-FD, pull-in range = $(0,\ 2.0 f_b) = f_{tar} \pm f_b$
- **2.5 DQFD**:
    - (8X-OS) full-rate @ 8-phase: Bi-FD, pull-in range = $(0.925 f_b,\ 1.075 f_b) = f_{tar} \pm 0.075 f_b$
    - (4X-OS) half-rate @ 8-phase: Bi-FD, pull-in range = $(0.40 f_b,\ 0.60 f_b) = f_{tar} \pm 0.10 f_b$
- **2.6 JT-DQFD**:
    - (8X-OS) full-rate @ 8-phase: Bi-FD, pull-in range = $(0.925 f_b,\ 1.075 f_b) = f_{tar} \pm 0.075 f_b$ (with improved CK jitter tolerance)
    - (4X-OS) half-rate @ 8-phase: Bi-FD, pull-in range = $(0.425 f_b,\ 0.575 f_b) = f_{tar} \pm 0.075 f_b$ (with improved CK jitter tolerance)
- **2.7 M-DQFD**:
    - (4X-OS) full-rate @ 4-phase: Bi-FD, pull-in range = $(0.85 f_b,\ 1.15 f_b) = f_{tar} \pm 0.15 f_b$
    - (2X-OS) half-rate @ 4-phase: Bi-FD, pull-in range = $(0.4 f_b,\ 0.6 f_b) = f_{tar} \pm 0.1 f_b$
- **2.8 QR-DQFD**:
    - (16X-OS) full-rate @ 16-phase
    - (8X-OS) half-rate @ 16-phase
- **2.9 QR-QRFD**:
    - (16X-OS) full-rate @ 16-phase: Bi-FD, pull-in range = $(0.85 f_b,\ 1.15 f_b) = f_{tar} \pm 0.15 f_b$
    - (8X-OS) half-rate @ 16-phase: Bi-FD, pull-in range = $(0.43 f_b,\ 0.57 f_b) = f_{tar} \pm 0.07 f_b$
    - (4X-OS) quarter-rate @ 16-phase: Bi-FD, pull-in range = $(0.46 f_b,\ 0.54 f_b) = f_{tar} \pm 0.04 f_b$

注意上面所有 FD, 除了 Simple-FD 是 CK samples DATA, 其它都是 DATA samples CK 架构，因此很难直接拓展到其它时钟速率。

<!-- 而 Simple-FD 只需保证两条时钟输入的上升沿延迟为 0.5 bit period 即可，因此可以在 full-rate @ 2-phase, half-rate @ 4-phase, quarter-rate @ 8-phase 等多种模式下工作，具有更好的灵活性。但缺点是如果没有 `VDD/2` 这个偏置电压，它只能实现单向频差检测 (CK Slow)，对 CK Fast 则无能为力。
 -->





## 3. Some Ideas

### 3.1 divider-2 to reduce data rate (failed)

上面所介绍的 CDR FD 方案，基本上都只能在 full-rate or half-rate CK 下工作，那么，我们能否直接在输入端增加一个 divider-2 来降低数据速率，从而将原来的 full-rate mode 变成 half-rate mode，原来的 half-rate mode 变成 quarter-rate mode 呢？

下面以 Pottbacker-FD 为例来验证一下这个想法：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-18-34-44_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-18-36-08_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

嘶，结果和我们预想的差别挺大，加入 DIV2 for input data 后，反而只有 full-rate CK (原先的 double-rate) 下能正常工作了，这是为什么？

再试试本来能在 half-rate CK 下工作的 Richman-FD 和 M-DQFD：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-15-25-14_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-15-26-25_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>


嘶，Richman-FD 和 M-DQFD 也不行，看来是 DIV2 for input data 这个方案本身就不太行，虽然不知为什么行不通，但也没办法，无奈放弃。



### 3.2 simple logic for CK-Slow detection (succeeded)

之前在有篇论文中看到的思路 (具体哪篇忘了)，利用 2X-oversampling CK 实现 CK **Slow** detection，大致思路如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-15-51-11_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

2X-oversampling CK 下，每次采样间隔为 0.5 UI (0.5 bit period) of data，假设连续三次采样值分别记为为 S0, S1, S2 (S0 在先)，如果满足 `S[0:2] = [010] or [101]`，则说明有一个宽度为 bit period 的脉冲被 "夹在三次采样中间"，并且前后两次采样点在脉冲外，中间这个采样点在脉冲内，由此推断出 $2T_{sam} > T_{bit}$，也即 CK Slow。

当然，按上面思路只能对 $T_{sam} < 1.5 T_{bit}$ 范围做到无误检测，此时三次采样 S0, S1, S2 (S0 在先) 应 D0, D1, D2 (D0 在先)。一旦 $T_{sam} > 1.5 T_{bit}$，三次采样值就可能依次对应 D-1, D1, D3, 导致错误的逻辑判断，无法完全正确地检测 CK Slow。不过这种误判实际上没啥影响，毕竟这种误判会使输出 CK Slow = 1，反而一定程度上 "加强" 了 CK Slow 的检测能力。




<!-- 在 quarter-rate mode (8-phase) 下对应有 $T_{sam} = \frac{1}{8} T_{CK}$，因此四分之一速率下的 pull-in range = $(\frac{f_b}{12},\ \frac{f_b}{4}) \to \frac{f_b}{4}$，也即 $f_{CK} \in (0.083 f_b,\ 0.25 f_b) \to 0.25 f_b$，也算是一个不错的 CK-Slow detection 方案了。
 -->

下面就搭建电路来验证一下上述思路。我们希望其工作在 quarter-rate CK，所以设置 VCO 输出为 8-phase CK (这样 CK 间隔就是 0.5 UI of data)，并将其中连续四路 `CK<3:0>` 拿过来做 sampling 和 aligning，原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-16-34-44_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-16-40-37_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

嗯，是一个非常理想的 CK-Slow detection 输出特性，很好地验证了我们的思路。

**这个思路最大优势之一是：它基于 2X-oversampling CK 来实现 CK-Slow detection，因此可以在 full-rate @ 2-phase, half-rate @ 4-phase, quarter-rate @ 8-phase 等多种模式下工作，具有非常好的灵活性。** 另一大优势则是资源消耗小，只需几个 DFF 和简单的 combinational logic 就能实现所有速率下的 CK-Slow detection。


### 3.3 extend CK-Slow to CK-Fast detection (succeeded)

在上一小节的基础上，我就在想，能不能利用类似的思路来实现 CK-Fast detection 呢？经过数天的摸索和头脑风暴 (其实就是瞎想)，还真让我想出一种方案：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-16-05-33_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>


**核心思路是类似的：抓住输入数据 010/101 码型所构成的 bit period pulse (比特周期脉冲) 来实现频率判定。**


有了思路后，立马就来搭建电路试验一下，原理图和仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-16-55-58_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-16-48-38_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

将 CK Slow/Fast 输出叠加在一起，得到总的输出特性曲线如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-17-42-36_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

图中可以看到，由于 CK-Fast detection 的输出特性不太理想，在 CK slow 区域 (f_CK < f_b/4) 也有一定输出，导致总输出特性在 f_CK ≈ f_b/4 附近比较模糊，无法明显区分 CK Slow 和 CK Fast 区域。


### 3.4 fix fuzzy area by CK-Slow Enhancement (succeeded)

为解决上面提到的 "模糊区域" 问题，我们可以对 CK-Slow detection 的输出信号进行增强。
- 第一种思路是：将 CK-Slow detection 的输出脉冲进行 "拉宽" 处理，使其在 f_CK < f_b/4 区域内的输出更强，从而 "覆盖过" CK-Fast detection 在该区域内的误判输出。
- 第二种思路是：在一定时间窗口内 (如 CK_DIV8) 对 CK-Slow 和 CK-Fast detection 的输出进行监视。(1) 如果这段时间内 CK-Slow detection 存在输出脉冲，则 "无视" CK-Fast 输出信号，判定该时间段为 CK Slow，并在下一时间段输出 CK SLow 信号；(2) 若该时间段内 CK-Slow detection 没有输出脉冲，且 CK-Fast 存在输出脉冲，则判定该时间段为 CK Fast，并在下一时间段输出 CK Fast 信号；(3) 若该时间段内 CK-Slow 和 CK-Fast 都没有输出脉冲，则判定该时间段为 "NONE"，不输出任何信号。 <!-- 由于 CK Slow 和 CK-Fast detection 的输出都是基于 `010/101` data pattern 来实现的，所以应该不会出现漏判/误判的情况，因此这种监视机制是可行的。 -->

本小节就来尝试第一种思路 (第二种思路留在下一小节)。第一种思路其实就是利用移位寄存器 (register) 或计数器 (counter) 等具有 "记忆" 功能的电路结构来 "拉宽" CK-Slow detection 的输出脉冲。

如果选用寄存器 (register)，从电路拓扑来讲就比较简单了，直接移位寄存然后做 OR 操作即可。原理图如下:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-18-49-31_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>


利用 8-bit 寄存器 (八倍增益) 实现的 gain control 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-19-00-03_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>



如果选用计数器 (counter) 74161，具体实现方法是：
- CK-Slow detection 的输出信号作为计数器的使能输入 (EN)
- 因为组合逻辑输出更新是在 CK<3> 之后，因此这里可以用 CK<0> ~ CK<2> 作为计数器的时钟输入 (CLK)，以保证计数器在 CK-Slow detection 输出脉冲后能够及时响应并进行计数
- 当 CK-Slow detection 输出脉冲时 (Slow = 1)，计数器 EN = 1 得到使能，对 CK<0> 的上升沿进行计数；当 Slow = 0 时，计数器 EN = 0 保持当前计数值不变 (hold state)；这样便实现了 Slow 信号的记录；
- 随后利用 OR gate 对计数输出 Q<3:0> 进行或操作，即可得到一个 "拉宽" 了的 CK Slow signal (记为 Slow_enh)
- 但是还得加入 reset 机制来避免时钟频率更新后计数器一直处于 "拉宽" 状态无法恢复，实现方法是：利用 CK_DIV8 对计数器进行周期性复位 (reset)，CK_DIV8 = 1 时按上述逻辑进行记录并输出，CK_DIV8 = 0 时复位计数器 (reset)，使其回到初始状态，准备下一轮的 CK-Slow detection。
- 原理图如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-18-14-49_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>


当然，更简单的方法是用一个计数器实现 16 个脉冲计数，计数完成后输出一个脉冲用于其它计数器复位，这样就能在 15 个脉冲时长内保持 "拉宽状态"。原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-18-48-36_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>


利用计数器 (4-bit 16-pulse 计数) 实现的 gain control 仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-19-08-26_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>


进一步地，我们可以将原 Slow signal 加入进来，作为 16-pulse 计数器的 RESET (or CLEAR) 输入。这样当 Slow = 1 时计数器被复位，后级计数器维持 "拉宽状态"；直到 Slow = 0 维持一段时间 (16 pulses)，后级计数器才会被复位，结束 "拉宽状态"。这样便用两个计数器 (2x4 DFFs) 实现了 16X output gain enhancement (十六倍输出增益)。

修改后的仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-19-57-36_Overview and Verification of CDR Phase and Frequency Detectors.png"/></div>

显然，经过 gain control 后，总输出特性 (Slow minus Fast) 得到明显改善，已经可以很清晰地分辨出 CK Slow/Fast 区域了。



### 3.5 improvement of CK-Fast detection (failed)

刚刚我们实现了 CK-Slow detection 的 gain control，不妨将这思路也推广到 CK-Fast detection 上来，也实现 CK-Fast detection 的 gain control。


刚刚我们在 CK-Slow detection 上的 "十六脉冲计数" 机制，不妨看作 Slow signal 的 enable/disable 机制：只有当 Slow = 0 维持一段时间 (16 pulses) 后，才会进入 Slow-disabled 状态；只要出现 Slow = 1 就会立即进入 Slow-enabled 状态，同时开启计数器的 "脉冲拉宽" 功能。

那么，我们不妨将 Slow-disabled 和 Fast-enabled 这两个状态进行绑定，称作 **mode = Fast-detection**，在此状态下也对 CK-Fast detection 的输出进行 gain enhancement；反之，Slow-enabled 和 Fast-disabled 这两个状态进行绑定，称作 **mode = Slow-detection**；两个模式结合起来，这样就能得到增益高且线性度更好的总输出特性了。

注意到 output of `VA_CDR_FD_CKslow_2XOS_outEnhenced_16X` (CK-Slow detection with gain control) 这个模块就相当于 `flag_slowMode` (不是未经处理的 slow signal, 那个在原理图里命名为了 `out0`)：当 Slow = 1 时 `flag_slowMode = 1`，当 Slow = 0 时 `flag_slowMode = 0`。因此只需用这个 `Slow` 信号来对 CK-Fast detection 的输出进行增益控制即可。总原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-20-24-10_Overview and Verification of CDR Phase and Frequency Detectors.png"/></div>


仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-13-20-31-49_Overview and Verification of CDR Phase and Frequency Detectors.png"/></div>

加入 FAST gain control 后，整体线性度看着倒是好挺多，但总输出特性曲线在 -758.6m $f_b = 0.241.4 f_b$ 附近出现了一个 "峰谷"，这显然不是我们想要的，但也没办法，检测机制如此，暂时想不到什么改进思路。


### 3.6 final Bi-FD scheme

一方面，先改回原来的 `VA_CDR_FD_CKslow_2XOS_outEnhenced_16X` + `VA_CDR_FD_CKfast_2XOS` 方案，构成总的 quarter-rate Bi-FD；另一方面 PRBS07 + 2^10 bits 仿真可能还不够细致，为获得更准确的频差特性曲线，我们使用 PRBS15 + 2^16 bits 来进行仿真，得到的结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-14-16-23-53_Overview and Verification of CDR Phase and Frequency Detectors.png"/></div>

在目标频率附近的细节如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-14-16-08-01_Overview and Verification of CDR Phase and Frequency Detectors.png"/></div>



以 PRBS15 @ 2^16 bits 结果为准。从上图看出可以给 CK Fast 一个八倍增益，这样 f_tar 两边的输出特性就比较对称了，线性度较好。

八倍增益的话注意 **不能** 将计数器的预设值 (pre-set data) 设置为 `D[3:0] = (8)_10 = (1000)_2` (计数 8 ~ 15 后回到 8)，因为这样计数器输出 `Q<3:0>` 一直存在零，会导致 `FAST` 恒为 ONE。

而是 **应该** 设置将计数范围设置在 0 ~ 7, 达到 `(7)_10 = (0111)_2` 之后激活 RST，并在下一次时钟回到 `(0)_10 = (0000)_2` 重新开始计数，这样才能得到正确的八倍增益。


原理图和仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-14-16-27-26_Overview and Verification of CDR Phase and Frequency Detectors.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-15-22-12-40_Overview and Verification of CDR Phase and Frequency Detectors.png"/></div>

八倍增益时，频差特性曲线已经有较好的线性度了，斜率约为 10 V/MHz, 且 zero-crossing point 是非常理想的 $f_{tar} = 0.25 f_b$。实际使用时 CK Fast 是否需要八倍增益，或者说增益多少合适，还得看实际情况来定，建议 4X ~ 8X for CK Fast 这样子。


不妨也仿真一下没有任何 gain enhancement 的情况 (Slow/Fast 都是原始输出)，看看它在 PRBS15 @ 2^16 bits 下的频差特性曲线是什么样子 (之前仿的是 PRBS07 @ 2^10 bits)，仿真结果如下：

（这里放图）




### 3.7 summary of our Bi-FD scheme @ quarter-rate mode

Bi-FD scheme @ quarter-rate mode:
- CK-Slow detection: `VA_CDR_FD_CKslow_2XOS_outEnhenced_16X` (16X gain enhancement)
- CK-Fast detection: `VA_CDR_FD_CKfast_2XOS` + 8X gain enhancement (4X ~ 8X recommended)
- Pull-in range: $(0,\ 0.5 f_b) \to 0.25 f_b$, i.e., $f_{tar} \pm 0.25 f_b$
- output slope: 10 V/MHz (with 8X gain for CK Fast)

### 3.8 else

仿真时意外将 `VA_CDR_FD_CKfast_2XOS` (CK-Fast detection) 的时钟设置为了 16-phase VCO 中的八路 CK<7:0>，然后发现此时输出曲线呈现非常良好的 uni-directional FD for CK-Slow detection (4X-oversampling)。具体而言，当 f_CK < f_b/4 时输出为正，表示 CK Slow, 当 f_CK > f_b/4 输出恒为零 (没错，就是理想的恒零)，由此又构成一个 uni-directional FD for CK-Slow detection @ 4X-OS 方案。

但我们毕竟已有更高效的 `VA_CDR_FD_CKslow_2XOS` 以及 `VA_CDR_FD_CKslow_2XOS_outEnhenced_16X` 两个方案，所以这个意外发现也没啥用，只是简要记录在这里。其背后详细原理，只能等有缘再回来分析了。

<!-- 将时钟改为 "正确" 的 8-phase CK<7:0> 后，与意料的一致，电路在 CK Fast 区域呈现一定输出，虽然有一小段与 CK Slow 区域的输出差别不大，但综合来看还是可以实现有效 CK-Fast 检测的。


注意电路在 f_CK > f_b/2 之后没有任何输出，pull-in range 只能覆盖 $(0.25 f_b,\ 0.5 f_b) \to 0.25 f_b$。


诶？那我们是否可以将这两个方案组合起来？前者 (16-phase CK) 用于 CK-Slow detection，后者 (8-phase CK) 用于 CK-Fast detection，这样就能实现一个完整的 quarter-rate Bi-FD？

说做就做，从十六相时钟中抽出八相时钟来构建 CK-Fast detection 的电路，与 CK-Slow detection 电路合并起来，输出包含 SLOW 与 FAST (总输出是两者相减)，仿真结果如下： -->

## 4. Quarter-Rate PD



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-11-15-39-48_Overview and Verification of CDR Phase and Frequency-Detectors.png"/></div>

>上图源自：[[7] Y. Wang, H. Xian, X. Li, F. Lai, W. Han, and X. Liu, “A 12.5Gbps dual loop quarter rate CDR using lock detecting technique in 55nm CMOS process,” in 2016 13th IEEE International Conference on Solid-State and Integrated Circuit Technology (ICSICT), Oct. 2016, pp. 1431–1433. doi: 10.1109/ICSICT.2016.7998760.](https://ieeexplore.ieee.org/document/7998760/)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-14-16-44-19_Overview and Verification of CDR Phase and Frequency Detectors.png"/></div>

>上图源自：[[9] “A CMOS 5.4/3.24‐Gbps Dual‐Rate CDR with Enhanced Quarter‐Rate Linear Phase Detector.” Accessed: Feb. 11, 2026. [Online]. Available: https://onlinelibrary.wiley.com/doi/epdf/10.4218/etrij.11.0110.0578](https://onlinelibrary.wiley.com/doi/epdf/10.4218/etrij.11.0110.0578)


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-14-16-50-20_Overview and Verification of CDR Phase and Frequency Detectors.png"/></div>

>上图源自：[[10] S. Yan, Y. Chen, T. Wang, and H. Wang, “A 40-Gb/s quarter rate CDR with 1∶4 demultiplexer in 90-nm CMOS technology,” in 2010 IEEE 12th International Conference on Communication Technology, Nov. 2010, pp. 673–676. doi: 10.1109/ICCT.2010.5688510.](https://ieeexplore.ieee.org/document/5688510/)


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-15-42-03_Overview and Verification of CDR Phase and Frequency Detectors.png"/></div>

>上图源自：[[11] G. Sung and J. Han, “High-speed StrongARM-latch-based Bang-bang Phase Detector in 40-nm CMOS Technology,” in 2021 18th International SoC Design Conference (ISOCC), Oct. 2021, pp. 377–378. doi: 10.1109/ISOCC53507.2021.9613931.](https://ieeexplore.ieee.org/document/9613931/)

## Reference


- [[1] ECE 6440 - Frequency Synthesizers > LECTURE 200 – CLOCK AND DATA RECOVERY CIRCUITS (© P.E. Allen - 2003)](https://pallen.ece.gatech.edu/Academic/ECE_6440/Summer_2003/L200-CDR-I(2UP).pdf)
- [[2] SerDes 系統簡介及相關數位訊號處理技巧 (顏睿甫, National Taiwan University, 6/5/2023)](https://djj.ee.ntu.edu.tw/SerDes.pdf)
- [[3] P. Anand, R. Mahadev, K. M. Le, and Z. Abbas, “A Dual-Loop CDR with an Extended Bidirectional Frequency Detection Technique for Wide Tuning Applications,” in 2025 IEEE 68th International Midwest Symposium on Circuits and Systems (MWSCAS), Aug. 2025, pp. 996–1000. doi: 10.1109/MWSCAS53549.2025.11244503.](https://ieeexplore.ieee.org/document/11244503/)
- [[4] J. Kim, Y. Ko, J. Jin, J. Choi, and J.-H. Chun, “A Referenceless Digital CDR with a Half-Rate Jitter-Tolerant FD and a Multi-Bit Decimator,” Electronics, vol. 11, no. 4, p. 537, Jan. 2022, doi: 10.3390/electronics11040537.](https://www.mdpi.com/2079-9292/11/4/537)
- [[5] P. M. Ha, N. H. Tho, H. H. Hanh, and Q. Nguyen-The, “A Wide-band Reference-less Bidirectional Continuous-Rate Frequency Detector,” in 2019 3rd International Conference on Recent Advances in Signal Processing, Telecommunications & Computing (SigTelCom), Mar. 2019, pp. 25–29. doi: 10.1109/SIG℡COM.2019.8696267.](https://ieeexplore.ieee.org/document/8696267)
- [[6] M. Assaad, “Design and modeling of clock and data recovery integrated circuit in 130 nm CMOS technology for 10 Gb/s serial data communications,” THE DEGREE OF DOCTOR OF PHILOSOPHY, UNIVERSITY OF GLASGOW, 2009.](https://theses.gla.ac.uk/707/1/2009assaadphd.pdf)
- [[7] Y. Wang, H. Xian, X. Li, F. Lai, W. Han, and X. Liu, “A 12.5Gbps dual loop quarter rate CDR using lock detecting technique in 55nm CMOS process,” in 2016 13th IEEE International Conference on Solid-State and Integrated Circuit Technology (ICSICT), Oct. 2016, pp. 1431–1433. doi: 10.1109/ICSICT.2016.7998760.](https://ieeexplore.ieee.org/document/7998760/)
- [[8] J.-P. Hong, M. Lee, J. Koo, and J.-Y. Sim, “A Synthesizable Quarter-Rate CDR based on All Digital Fractional-N PLL with Quadrature Rotational Frequency Detector,” IEICE Electronics Express, vol. advpub, 2025, doi: 10.1587/elex.22.20250358.](https://www.jstage.jst.go.jp/article/elex/22/17/22_22.20250358/_article)
- [[9] “A CMOS 5.4/3.24‐Gbps Dual‐Rate CDR with Enhanced Quarter‐Rate Linear Phase Detector.” Accessed: Feb. 11, 2026. [Online]. Available: https://onlinelibrary.wiley.com/doi/epdf/10.4218/etrij.11.0110.0578](https://onlinelibrary.wiley.com/doi/epdf/10.4218/etrij.11.0110.0578)
- [[10] S. Yan, Y. Chen, T. Wang, and H. Wang, “A 40-Gb/s quarter rate CDR with 1∶4 demultiplexer in 90-nm CMOS technology,” in 2010 IEEE 12th International Conference on Communication Technology, Nov. 2010, pp. 673–676. doi: 10.1109/ICCT.2010.5688510.](https://ieeexplore.ieee.org/document/5688510/)
- [[11] G. Sung and J. Han, “High-speed StrongARM-latch-based Bang-bang Phase Detector in 40-nm CMOS Technology,” in 2021 18th International SoC Design Conference (ISOCC), Oct. 2021, pp. 377–378. doi: 10.1109/ISOCC53507.2021.9613931.](https://ieeexplore.ieee.org/document/9613931/)

