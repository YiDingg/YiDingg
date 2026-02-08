# Basics of Clock Data Recovery (CDR)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 23:40 on 2024-08-27 in Lincang.

## 1. Introduction

在高速通信系统中 (例如高速收发器 transceiver)，随着传输线长度的增加和信号频率的提高，数据信息可能会受到严重影响，导致数据信号失真等一系列负面效应。这些系统中接收到的数据既不同步又存在噪声，因此需要提取时钟以实现同步操作。此外，数据必须进行 "重定时" (retiming), 以消除传输过程中累积的抖动和偏移 (jitter and skew)。基于以上因素, Clock and Data Recovery (CDR, 时钟数据恢复) 应运而生。 

如下图, CDR 的主要功能是：从接收到的串行数据流提取出时钟信号，然后根据此时钟信号对数据进行 "重建"，从而达到数据恢复的目的。也就是分为两步："clock generation (时钟信号生成)" 和 "retiming data (数据信号恢复)"。引入 CDR 不仅可以提高数据传输的可靠性和稳定性，还避免了时钟信号单独传输带来的功耗、成本和噪声问题，显著提升了信道利用率与抗干扰能力。


图源文献 [[1] (M. Hsieh)](https://people.engr.tamu.edu/spalermo/ecen689/cdr_comparisons_hsieh_cas_2008.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-19-56-33_[Literature Review] Clock and Data Recovery.png"/></div>


图源文献 [[1] (M. Hsieh)](https://people.engr.tamu.edu/spalermo/ecen689/cdr_comparisons_hsieh_cas_2008.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-19-53-40_[Literature Review] Clock and Data Recovery.png"/></div>


目前，大多数的 CDR 都是基于 PLL (Phase-Locked Loop) 或者 DLL (Delay-Locked Loop) 实现的，少部分基于其它架构，例如 phase-interpolator, injection locking, oversampling, gated oscillator, high-Q bandpass filter 等等，详见论文 [[1] (M. Hsieh)](https://people.engr.tamu.edu/spalermo/ecen689/cdr_comparisons_hsieh_cas_2008.pdf) 的参考文献。


上面这么多种架构大致可以分为三类 [[1] (M. Hsieh)](https://people.engr.tamu.edu/spalermo/ecen689/cdr_comparisons_hsieh_cas_2008.pdf)：
1) **Topologies using feedback phase tracking**, including, phase locked loop (PLL), delay locked loop (DLL), phase interpolator (PI) and injection locked (IL) structures. 
2) **An oversampling-based (OS-based) topology without feedback phase tracking**. 
3) **Topologies using phase alignment but without feedback phase tracking**, including gated oscillator (GO) structures.

这些结构的主要优缺点和适用场景如下图 [[1] (M. Hsieh)](https://people.engr.tamu.edu/spalermo/ecen689/cdr_comparisons_hsieh_cas_2008.pdf)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-21-39-01_Basics of Clock Data Recovery (CDR).png"/></div>

本文不会详细介绍每一种结构及其原理，仅在后文详细介绍第一种 **Topologies using feedback phase tracking** 中的 PLL-based structure.


下图展示了最基础的 PLL-based CDR 工作原理，图源文献 [4]：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-41-33_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-43-54_Basics of Clock Data Recovery (CDR).png"/></div>

>注: CDR 设计/仿真时常常假设/设置输入信号为伪随机比特流 Pseudo-Random Bit Stream (PRBS) ，也称 "Pseudo-random Binary Sequence" (伪随机比特序列)。

另外，与 PLL 类似，高性能 CDR 基本都有至少两个环路，下图是一个典型例子，图源文献 [[1] (M. Hsieh)](https://people.engr.tamu.edu/spalermo/ecen689/cdr_comparisons_hsieh_cas_2008.pdf)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-20-51-22_Basics of Clock Data Recovery (CDR).png"/></div>

本文仅对单个环路的情况进行介绍和分析 (仅有 PD)，下面先介绍几种常见的 linear/binary phase detector.

## 2. Linear Phase Detector 


### 2.1 Hogge PD

**Hogge phase detector** 是最经典的 **linear phase detector** for data-clock phase comparison. 它由一个 **positive**-edge-triggered D flip-flop, 一个 **negative**-edge-triggered D flip-flop 和两个 XOR gates (异或门) 构成：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-36-29_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-40-16_Basics of Clock Data Recovery (CDR).png"/></div>

Hogge phase detector  有两个输出端 UP 和 DN 。 DN 产生固定宽度的脉冲信号作为 reference, 其脉宽和 CLK 脉宽相同；而 UP 波形与 DN 类似，区别在于占空比 (脉宽) 随着 CLK 与 DATA 相对位置的变化而变化。

当 sampling edge (the positive-edge of CLK) **leads DATA** 时, the duty cycle of **UP < 50%**；
反之，当 sampling edge **lags DATA** 时, the duty cycle of **UP > 50%**。下面是仿真示例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-06-37_Basics of Clock Data Recovery (CDR).png"/></div>


The sampling edge (the positive-edge of CLK) **leads DATA**, hence the duty cycle of **UP < 50%**:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-00-08_Basics of Clock Data Recovery (CDR).png"/></div>


The sampling edge (the positive-edge of CLK) **lags DATA**, hence the duty cycle of **UP > 50%**:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-04-19_Basics of Clock Data Recovery (CDR).png"/></div>

因此, Hogge PD 所生成的一系列 PWM 信号 (pulse width modulated signals) 能够指示 CLK 相对于 DATA 的相位关系，从而通过平均输出量控制 VCO 的频率，起到锁相作用。达到锁定状态后, UP 和 DN 的脉宽应完全相等，此时 PD 的平均输出值为零, VCO 的 VCONT 才能不变。

**需要特别注意的是，对 Hogge PD 而言，如果输入数据流恒为 0 或 1, 则 UP 和 DN 信号也恒为零。** 在 VCONT leakage 可以忽略的情况下，这会维持 VCONT 不变，也即 CLK 频率不变。实际的 VCONT 节点都会有一定电流泄露，因此 CDR 对传入数据中所允许 0/1 的最大连续数量有限制，通常在发送端考虑这一点。

Hogge PD 的增益可以表示为：

$$
\begin{gather}
K_{PD} = \frac{\mathrm{TD}}{\pi}\\
\mathrm{TD\ (transition\ density)} = 0.5\ \mathrm{\ for\ random\ data}
\end{gather}
$$

当然，一般情况下我们不会单独讨论 phase detector 的增益，而是将 PD 和 CP 视为一个模块进行建模。

举个例子，假设输入信号为 Pseudo-Random Bit Stream (PRBS), 且频率为 f_CLK/2, 这在数学上可以等价为频率为 f_CLK/2 的 square wave.

当 sampling edge lags DATA by π rad/s 时, UP 占空比达到最大值 100 %, PD 的 average output 等价于一个 PWM with duty cycle = 50 %。

将 CP 考虑进来后：每个 CLK 周期的一半时间 PD + CP 输出恒定电流 Ip, 另一半时间输出电流为零，那么 average output current 就是 Ip/2, 于是得到 PD + CP 的线性模型：

$$
\begin{gather}
H_{HPD/CP}(s) = \frac{I_{out}}{\Phi_{in}}(s) = K_{PD/CP} = \frac{I_P}{2\pi}
\end{gather}
$$

其中 $I_P$ 是 CP 的充放电电流。



### 2.2 Modified Hogge PD

文献 [2] (J. Savoj) page.47 提到了 Hogge PD 的一种改进方法，能够有效降低由 triwaves (triangular output waves) 导致的系统性抖动：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-02-24-27_Basics of Clock Data Recovery (CDR).png"/></div>


### 2.3 Mueller-Muller PD

文献 [[6]](https://www.mdpi.com/2079-9292/10/16/1888) 中提到：
>The rapid growth of data rate makes the classical Bang-Bang phase detector (BBPD) no longer suitable for high-speed clock and data recovery (CDR). However, the advantage of the Mueller–Muller phase detector (MMPD)...... making Mueller–Muller baud-rate sampling widely used in the serial IO design.


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-22-00-19_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-22-02-10_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-22-08-22_Basics of Clock Data Recovery (CDR).png"/></div>

下图来自文献 [7]:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-21-56-27_Basics of Clock Data Recovery (CDR).png"/></div>

where $2\phi_m$ is the drift bit width,namely the part of the input data whose voltage amplitude is greater than +Vref or less than Vref.

如果认为 $2\phi_m$ 较小，可以忽略，则有：

$$
\begin{gather}
H_{MMPD/CP}(s) = \frac{2\sigma^2 - \phi_m^2}{2 \sqrt{2\pi} \sigma^3}\cdot I_P \approx \frac{I_P}{\sigma\sqrt{2\pi}}
\end{gather}
$$

## 3. Binary Phase Detector


### 3.1 Bang-Bang PD

文献 [3] page.13, 文献 [4] page.32 和文献 [[5]](https://www.zhihu.com/question/23142886/answer/108257466853) 都提到 **Alexander phase detector**, 又称 **bang-bang phase detector (BBPD)**, 是最典型的 **binary phase detector**.


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-03-01-05-23_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-37-10_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-47-49_Basics of Clock Data Recovery (CDR).png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-02-03-09_Basics of Clock Data Recovery (CDR).png"/></div>

下面几张图来自文献 [8]:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-22-16-19_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-22-16-46_Basics of Clock Data Recovery (CDR).png"/></div>

由于 BBPD 是非线性 phase detector, 一般只有在 jitter analysis (jitter transfer) 中可以线性化。关于 BBPD 的分析与建模，详见文献 [8] 和文献 [9]。

### 3.2 Pottbacker PD

详见文献 [2] (J. Savoj) page.51, 这里略过。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-23-17-57_Basics of Clock Data Recovery (CDR).png"/></div>

## 4. Loop/Jitter Analysis

采用 HPD (Hogge PD) 时，也即 PLL-based CDR with linear phase detector 结构，由于 HPD/CP 的传递函数 $H(s) = \frac{I_P}{2\pi}$ 不变 (与 CP-PLL 相比)，因此推导过程和结果与文章 [Design Sheet for Third-Order Type-II CP-PLL](<AnalogICDesigns/Design Sheet for Third-Order Type-II CP-PLL.md>) 中的完全相同，这里便不再重复了。

至于采用 BBPD (bang-bang PD) 等 binary PD 的 jitter transfer analysis, 这个比较复杂，我们留到之后单独写一篇文章来讨论。

## 5. Simulation Tips


### 5.1 random data generator

参考这篇问答 [Cadence Community Forums > RF Design > set a random input data](https://community.cadence.com/cadence_technology_forums/f/rf-design/12922/set-a-random-input-data)。


使用库中器件 `ahdlLib > rand_bit_stream` (一定可行) 或 `analogLib > vsource > prbs` (需要较新版本) 即可生成 Pseudo-Random Bit Stream" (伪随机比特流)，前者 `rand_bit_stream` 的效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-00-31-22_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-00-30-46_Basics of Clock Data Recovery (CDR).png"/></div>


### 5.2 xxx


## References


- [[1]](https://people.engr.tamu.edu/spalermo/ecen689/cdr_comparisons_hsieh_cas_2008.pdf) M. Hsieh and G. E. Sobelman, “Architectures for multi-gigabit wire-linked clock and data recovery,” IEEE Circuits Syst. Mag., vol. 8, no. 4, pp. 45–57, 2008, doi: 10.1109/MCAS.2008.930152.
- [2] J. Savoj and B. Razavi, Eds., “Clock and Data Recovery Architectures,” in Clock and Data Recovery Architectures, Boston, MA: Springer US, 2001. doi: 10.1007/0-306-47576-6_3.
- [3] Hugo Ernesto Safadi Figueroa, “Design of a Clock and Data Recovery Circuit in FDSOI Technology for High Speed Serial Links.”
- [4] A. Amirkhany, “Basics of Clock and Data Recovery Circuits: Exploring High-Speed Serial Links,” IEEE Solid-State Circuits Magazine, vol. 12, no. 1, pp. 25–38, 2020, doi: 10.1109/MSSC.2019.2939342.
- [[5]](https://www.zhihu.com/question/23142886/answer/108257466853) Behzad Razavi, Design of CMOS Phase-Locked Loops. New York, NY: Cambridge University Press, 2020.
- [[6]](https://www.mdpi.com/2079-9292/10/16/1888) T. Liu et al., “Analysis and Modeling of Mueller–Muller Clock and Data Recovery Circuits,” Electronics, vol. 10, no. 16, p. 1888, Aug. 2021, doi: 10.3390/electronics10161888.
- [7] T. Liu, F. Lv, B. Liang, H. Wang, J. Wang, and M. Wu, “An Analytical Jitter Transfer Model for Mueller-Muller Clock and Data Recovery Circuits,” in 2021 IEEE 14th International Conference on ASIC (ASICON), Kunming, China: IEEE, Oct. 2021, pp. 1–4. doi: 10.1109/ASICON52560.2021.9620396.
- [8] B. Razavi, J. Lee, and K. S. Kundert, “Analysis and modeling of bang-bang clock and data recovery circuits,” IEEE J. Solid-State Circuits, vol. 39, no. 9, pp. 1571–1580, Sep. 2004, doi: 10.1109/JSSC.2004.831600.
- [9] H. Abdel-Maguid, “Analysis of bang-bang clock and data recovery,” Master of Applied Science, Carleton University, Ottawa, Ontario, 2006. doi: 10.22215/etd/2006-07544.
- [10] F. Spagna, “Clock and data recovery systems,” in 2018 IEEE Custom Integrated Circuits Conference (CICC), San Diego, CA: IEEE, Apr. 2018, pp. 1–120. doi: 10.1109/CICC.2018.8357111.
- [[11]](https://download.tek.com/document/65W_26023_0_Letter.pdf) “Clock Recovery Primer, Part 1.” Accessed: Jun. 21, 2025. [Online]. Available: https://download.tek.com/document/65W_26023_0_Letter.pdf
- [12] Y. Ren, “Design of a Clock and Data Recovery Circuit in 65 NM Technology.”
- [13] M. H. Perrott, “Clock and Data Recovery (CDR) Design Using the PLL Design Assistant and CppSim Programs.” 
- [14] B. Casper and F. O’Mahony, “Clocking Analysis, Implementation and Measurement Techniques for High-Speed Data Links—A Tutorial,” IEEE Transactions on Circuits and Systems I: Regular Papers, vol. 56, no. 1, pp. 17–39, Jan. 2009, doi: 10.1109/TCSI.2008.931647.
- [[15]](https://ocw.snu.ac.kr/sites/default/files/NOTE/Lec%206%20-%20Clock%20and%20Data%20Recovery.pdf) “Clock and Data Recovery (Jeong, 2020),” Accessed: Jun. 21, 2025. [Online]. Available: https://ocw.snu.ac.kr/sites/default/files/NOTE/Lec%206%20-%20Clock%20and%20Data%20Recovery.pdf
- [16] “Clock and Data Recovery for Serial Digital Communication,” 
- [17] “What is Clock and Data Recovery (CDR),” Accessed: Jun. 21, 2025. [Online]. Available: https://www.ti.com/content/dam/videos/external-videos/en-us/7/3816841626001/6195321713001.mp4/subassets/what_is_clock_and_data_recovery.pdf
- [18] S. Ravikumar, “Circuit Architectures for High-Speed CMOS Clock and Data Recovery Circuits.”
- [19] H.-C. Lee, “An Estimation Approach to Clock And Data Recovery.”

