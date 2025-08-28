# Basics of Clock Data Recovery (CDR)

> [!Note|style:callout|label:Infor]
Initially published at 23:40 on 2024-08-27 in Lincang.

## Introduction

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-41-33_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-43-54_Basics of Clock Data Recovery (CDR).png"/></div>

## 1. List of Proper Names


- PRBS: "Pseudo-Random Bit Stream" (伪随机比特流) or "Pseudo-random Binary Sequence" (伪随机比特序列)

## 2. Linear Phase Detector 

### 2.1 Hogge PD

**Hogge phase detector** 是实现 data-clock phase comparison 的最经典 **linear phase detector** (与之相对的是 binary phase detector)。它由一个 positive-edge triggered D flip-flop, 一个 negative-edge triggered D flip-flop 和两个 XOR gates (异或门) 构成：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-36-29_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-40-16_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-06-37_Basics of Clock Data Recovery (CDR).png"/></div>


Hogge phase detector  有两个输出端 UP 和 DN 。 DN 产生固定宽度的脉冲信号作为 reference, 其脉宽和 CLK 脉宽相同；而 UP 波形与 DN 类似，区别在于占空比 (脉宽) 随着 CLK 与 DATA 相对位置的变化而变化。

当 sampling edge (the positive-edge of CLK) **leads DATA** 时, the duty cycle of **UP < 50%**；
反之，当 sampling edge **lags DATA** 时, the duty cycle of **UP > 50%**。下面是一个例子：


The sampling edge (the positive-edge of CLK) **leads DATA**, hence the duty cycle of **UP < 50%**:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-00-08_Basics of Clock Data Recovery (CDR).png"/></div>


The sampling edge (the positive-edge of CLK) **lags DATA**, hence the duty cycle of **UP > 50%**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-04-19_Basics of Clock Data Recovery (CDR).png"/></div>

因此, Hogge PD 所生成的一系列 PWM 信号 (pulse width modulated signals) 能够指示 CLK 相对于 DATA 的相位关系。达到锁定状态后, UP 和 DN 的脉宽应完全相等，此时 PD 的平均输出值为零 (VCO 的 VCONT 才能不变)。

需要特别注意的是，如果输入数据流恒为 0 或 1, 则 UP 和 DN 信号也恒为零，在 VCONT leakage 可以忽略的情况下，这会维持 VCONT 不变，也即 CLK 频率不变。实际的 VCONT 节点都会有一定电流泄露，因此 CDR 对传入数据中所允许 0/1 的最大连续数量有限制，通常在发送端考虑这一点。

通常将 Hogge PD 的增益表示为：

$$
\begin{gather}
K_{PD} = \frac{\mathrm{TD}}{\pi},\quad \mathrm{TD\ (transition\ density)} = 0.5\ \mathrm{for\ random\ data}
\end{gather}
$$

### 2.2 Modified Hogge PD

文献 [2] page.47 提到了 Hogge PD 的一种改进方法，能够有效降低由 triwaves (triangular output waves) 导致的系统性抖动：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-02-24-27_Basics of Clock Data Recovery (CDR).png"/></div>


### 2.3 Mueller-Muller PD

<!-- Mueller-Muller phase detector 是一种典型的 linear phase detector 结构，广泛应用于高性能的时钟数据恢复系统中。它通过对输入信号进行四象限乘法运算，实现对相位差的精确检测。 -->


## 3. Binary Phase Detector


### 3.1 Alexander PD

文献 [7] page.13, 文献 [9] page.32 和文献 [[14]](https://www.zhihu.com/question/23142886/answer/108257466853) 都提到 **Alexander phase detector**, 又称 **bang-bang phase detector**, 是最典型的 **binary phase detector**.



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-37-10_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-01-47-49_Basics of Clock Data Recovery (CDR).png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-02-03-09_Basics of Clock Data Recovery (CDR).png"/></div>


### 3.2 Pottbacker PD

详见文献 [2] page.51

## 4. Loop Analysis



## 4. 

## Simulation Tips


### x.1 random data generator

参考这篇问答 [Cadence Community Forums > RF Design > set a random input data](https://community.cadence.com/cadence_technology_forums/f/rf-design/12922/set-a-random-input-data)。


使用库中器件 `ahdlLib > rand_bit_stream` (一定可行) 或 `analogLib > vsource > prbs` (需要较新版本) 即可生成 Pseudo-Random Bit Stream" (伪随机比特流)，前者 `rand_bit_stream` 的效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-00-31-22_Basics of Clock Data Recovery (CDR).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-28-00-30-46_Basics of Clock Data Recovery (CDR).png"/></div>




### x.2 


## References


- [1] F. Spagna, “Clock and data recovery systems,” in 2018 IEEE Custom Integrated Circuits Conference (CICC), San Diego, CA: IEEE, Apr. 2018, pp. 1–120. doi: 10.1109/CICC.2018.8357111.
- [2] J. Savoj and B. Razavi, Eds., “Clock and Data Recovery Architectures,” in Clock and Data Recovery Architectures, Boston, MA: Springer US, 2001. doi: 10.1007/0-306-47576-6_3.
- [[3]](https://download.tek.com/document/65W_26023_0_Letter.pdf) “Clock Recovery Primer, Part 1.” Accessed: Jun. 21, 2025. [Online]. Available: https://download.tek.com/document/65W_26023_0_Letter.pdf
- [4] H.-C. Lee, “An Estimation Approach to Clock And Data Recovery.”
- [5] S. Ravikumar, “Circuit Architectures for High-Speed CMOS Clock and Data Recovery Circuits.”
- [6] Y. Ren, “Design of a Clock and Data Recovery Circuit in 65 NM Technology.”
- [7] “Design of a Clock and Data Recovery Circuit in FDSOI Technology for High Speed Serial Links.”
- [8] M. H. Perrott, “Clock and Data Recovery (CDR) Design Using the PLL Design Assistant and CppSim Programs.” 
- [9] A. Amirkhany, “Basics of Clock and Data Recovery Circuits: Exploring High-Speed Serial Links,” IEEE Solid-State Circuits Magazine, vol. 12, no. 1, pp. 25–38, 2020, doi: 10.1109/MSSC.2019.2939342.
- [10] B. Casper and F. O’Mahony, “Clocking Analysis, Implementation and Measurement Techniques for High-Speed Data Links—A Tutorial,” IEEE Transactions on Circuits and Systems I: Regular Papers, vol. 56, no. 1, pp. 17–39, Jan. 2009, doi: 10.1109/TCSI.2008.931647.
- [[11]](https://ocw.snu.ac.kr/sites/default/files/NOTE/Lec%206%20-%20Clock%20and%20Data%20Recovery.pdf) “Clock and Data Recovery (Jeong, 2020),” Accessed: Jun. 21, 2025. [Online]. Available: https://ocw.snu.ac.kr/sites/default/files/NOTE/Lec%206%20-%20Clock%20and%20Data%20Recovery.pdf
- [12] “Clock and Data Recovery for Serial Digital Communication,” 
- [13] “What is Clock and Data Recovery (CDR),” Accessed: Jun. 21, 2025. [Online]. Available: https://www.ti.com/content/dam/videos/external-videos/en-us/7/3816841626001/6195321713001.mp4/subassets/what_is_clock_and_data_recovery.pdf
- [[14]](https://www.zhihu.com/question/23142886/answer/108257466853) Behzad Razavi, Design of CMOS Phase-Locked Loops. New York, NY: Cambridge University Press, 2020.
