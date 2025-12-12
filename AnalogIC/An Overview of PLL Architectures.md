# An Overview of PLL Architectures 

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 17:22 on 2025-12-08 in Beijing.

## 1. Evolution of PLL

本小节主要阅读 [[1]](https://digital-library.theiet.org/doi/book/10.1049/pbcs064e) 的第一章: Chapter 1. Evolution of Monolithic Phase-Locked Loops (by Woogeun Rhee), 对 PLL 的发展历程进行简单回顾。

<div class='center'>

| Chapter 1. Evolution of Monolithic Phase-Locked Loops (by Woogeun Rhee) of [[1]](https://digital-library.theiet.org/doi/book/10.1049/pbcs064e) Woogeun Rhee, Phase-Locked Frequency Generation and Clocking: Architectures and circuits for modern wireless and wireline systems. The Institution of Engineering and Technology, 2020.  |  |
|:-:|:-:|
 | 一个大致的时间线如下 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-21-55-17_An Overview of PLL Architectures.png"/></div> |
 | 最开始先是 PFD/CP 的经典结构 (右图)  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-21-57-17_An Overview of PLL Architectures.png"/></div> |
 | 对于最简单的架构来讲，上图给出的 PFD 架构比 Razavi 书中 [[2]](https://www.cambridge.org/highereducation/books/design-of-cmos-phaselocked-loops/0F328C818F3735C72DC6DD5557E42D07#overview) 的更实用，它考虑了简单 CP 实际所需的两个开关信号分别为 UP 和 DN' (DN_BAR), 这样就不用给 DN 端口额外加一个反相器，具有更好的延时对称性。| 上图说加了一个 DLY (delay) 单元可以有效消除 PFD/CP gain 的死区，但我们在最近的项目 ["An Ultra-Low-Power CP-PLL in ONC 180nm Technology"](<Projects/Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology.md>) 中曾试过 2-INV ~ 128-INV 的延时组合，带来了数十个 ns 的延迟 (输入频率 32.768 kHz)，增益曲线却几乎没有任何变化。也许是这个延时太小，CP 开关仍不足以完全打开？ **背后原因还有待进一步探讨。** | 
 | 随后 singled-ended RVCO 被引入 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-22-09-12_An Overview of PLL Architectures.png"/></div>  |
 | 上图的 (singled-ended) current-starved RVCO 和我们最近这个项目用的几乎一致，只不过我们把 VCT 放在了 PMOS-input 以获得更好的 PSRR (在 VCT 和 VDD 之间加电容，其实也就是把 LPF 接在 VCT 和 VDD 之间) | 另外，值得注意的是，上图中 **RVCO 的输出端使用了一个 Schmitt Trigger (SMIT)**, 这个思路是很不错的，值得借鉴 |
 | singled-ended RVCO 的低 PSR 大大限制了其适用范围，于是人们又提出 differential RVCO。相比于 singled-ended, differential 结构具有好得多的 PSR (power supply rejection) (书上说的，至于为什么，还需进一步分析) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-22-12-56_An Overview of PLL Architectures.png"/></div> |
 | 上图 VCO 输出经过一个 ÷2, 应该是为了得到 50% duty cycle; 另外 PFD 的 FB 输入端还用 NAND 做了一个简单的 retiming, 这个重定时思路还是第一次见，具体效果有待进一步分析 | differential RVCO 中指明需要一个 replica biasing, 是为了构造 Symmetric Load 从而实现输入输出在大信号下的 “中心对称”，具体可见下图： <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-23-00-09_An Overview of PLL Architectures.png"/></div> (VBN and VBP produced by Vctr) |
 |  DLL is designed to re-buffer the input clock without adding any effective delay. <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-23-06-20_An Overview of PLL Architectures.png"/></div> | |
 |  differential RVCO 被提出后，SB-PLL (self-biased PLL) 迅速成为一大热门，从名字上看它似乎只是一个不需要外部提供偏置电压/电流的差分锁相环，但其实整个系统设计思路已经非常不同了。 | 相比与传统 CP-PLL, SB-PLL 的特点/优点为：(1) 根据相同的延迟 delay (由 REF 决定)，在不同的 PVT 和 VCO 输出频率下自动调整偏置电流等环路参数，保证环路带宽恒定，从而大大提高 PVT 鲁棒性和工作频率范围；(2) 完全对称的负载设计，使得两相时钟输出的对称性很好 (这其实是 differential RVCO 的特点)；(3) 即便是最小的 PFD pulse 也能使 CP 开关正常打开 (待验证)，天生避免了 PFD/CP dead zone, 实现更低的相噪和抖动 |
 | 随后是 HDL-PLL (Hybrid Dual-Loop PLL), 用在 CP-PLL 上其实就是 Type-III CP-PLL, 可以是 2nd/3rd order (实现方式稍有不同) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-22-49-57_An Overview of PLL Architectures.png"/></div> |
 | 继续往后，数字锁相环和 DPLL-based CDR 开始兴起，最先出现的是 Bang-Bang PLL (BB-PLL), 并由此衍生出 TDC (Time-to-Digital Converter) 的概念。其实 Bang-Bang PD 本质上就是一个 1-bit TDC, 这个角度能很好地理解 BB-PLL 工作原理。 | Delta-sigma fractional-N PLL based CDR 也开始出现，这里不多赘述 |
 | 随着工艺发展，TDC 精度迅速提升 (ps, sub-ps level), 并且 LC-VCO 逐渐实现了片上集成，锁相环迎来了超低相噪/抖动的快速发展时期，并由此发展出了多种新型架构，如 SS-PLL (Sub-Sampling PLL), RS-PLL (Reference-Sampling PLL), IL-PLL (Injection-Locked PLL) 等等 | 
</div>

根据上述内容，我们自己总结一个 PLL 发展时间线：
- (1) PFD/CP (CP-PLL)
- (2) Singled-ended RVCO 片上集成
- (3) Differential RVCO, DLL, SB-PLL (Self-Biased PLL)
- (4) HDL-PLL (Hybrid Dual-Loop PLL)
- (5) BB-PLL (Bang-Bang PLL), TDC-based PLL, Digital PLL, AD-PLL (All-Digital PLL)
- (6) LC-VCO 片上集成, 超低相噪/抖动 PLL 架构 (SS-PLL, RS-PLL, IL-PLL 等)
- (7) …… (现今)


## 2. Differential CP-PLL 
### 2.x reference

本小节的参考文献如下：

## 3. Self-Biased PLL (SB-PLL)
### 3.x reference

本小节的参考文献如下：

## 4. Sub-Sampling PLL (SS-PLL)
### 4.x reference

本小节的参考文献如下：

## 5. Dual-Loop PLL (HDL-PLL)

### 5.x reference

本小节的参考文献如下：
- **(主要参考)** [[3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9278255) Z. Zhang and N. Wu, “Design of High-Performance Phase-Locked Loop Using Hybrid Dual-Path Loop Architecture: an Overview (Invited Paper),” in 2020 IEEE 15th International Conference on Solid-State & Integrated Circuit Technology (ICSICT), Kunming, China: IEEE, Nov. 2020, pp. 1–4. doi: 10.1109/ICSICT49897.2020.9278255.
## Reference

资料/博客：
- [{1} University of Nevada Las Vegas > Self-Biased PLL/DLL (60-minute Final Project Presentation)](https://cmosedu.com/jbaker/courses/ecg721/f15/lec22_ecg721.pdf) 

文献：
- [[1]](https://digital-library.theiet.org/doi/book/10.1049/pbcs064e) Woogeun Rhee, Phase-Locked Frequency Generation and Clocking: Architectures and circuits for modern wireless and wireline systems. The Institution of Engineering and Technology, 2020. 
- [[2]](https://www.cambridge.org/highereducation/books/design-of-cmos-phaselocked-loops/0F328C818F3735C72DC6DD5557E42D07#overview) B. Razavi, Design of CMOS Phase-Locked Loops: From Circuit Level to Architecture Level. Cambridge: Cambridge University Press, 2020.
- [[3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9278255) Z. Zhang and N. Wu, “Design of High-Performance Phase-Locked Loop Using Hybrid Dual-Path Loop Architecture: an Overview (Invited Paper),” in 2020 IEEE 15th International Conference on Solid-State & Integrated Circuit Technology (ICSICT), Kunming, China: IEEE, Nov. 2020, pp. 1–4. doi: 10.1109/ICSICT49897.2020.9278255.
- [[4]](https://ietresearch.onlinelibrary.wiley.com/doi/epdf/10.1049/ell2.70293) Y. Kang et al., “A 6.6-GHz Dual-Path Reference-Sampling PLL With 139.6-fs RMS Jitter and −75.2-dBc Spur in 28-nm CMOS,” Electronics Letters, vol. 61, no. 1, p. e70293, 2025, doi: 10.1049/ell2.70293.
- [[5]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5783227) M. Wang, B. Zhou, W. Rhee, and Z. Wang, “Continuously auto-tuned and self-ranged dual-path PLL design with hybrid AFC,” in 2011 IEEE International Conference on IC Design & Technology, May 2011, pp. 1–4. doi: 10.1109/ICICDT.2011.5783227.
- [[6]](https://www.semanticscholar.org/paper/C-12-58-A-Dual-Loop-Injection-Locked-PLL-with-PVT-%E3%82%A6%E3%82%A7%E3%82%A4-%E3%82%A2%E3%83%8F%E3%83%9E%E3%83%89/e7a9d3b9c0049bc68ce874cb74373c0f5e96ce43) ウェイデン, アハマドムサ, シリブラーノンティーラショート, 正也宮原, 健一岡田, and 昭松澤, “A Dual-Loop Injection-Locked PLL with All-Digital PVT Calibration System,” Mar. 2013. Accessed: Dec. 08, 2025. [Online]. Available: https://www.semanticscholar.org/paper/
- [[7]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6412806) S. Golestan, M. Monfared, F. D. Freijedo, and J. M. Guerrero, “Advantages and Challenges of a Type-3 PLL,” IEEE Transactions on Power Electronics, vol. 28, no. 11, pp. 4985–4997, Nov. 2013, doi: 10.1109/TPEL.2013.2240317.
- [[8]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6423804) M. Ferriss et al., “An Integral Path Self-Calibration Scheme for a Dual-Loop PLL,” IEEE Journal of Solid-State Circuits, vol. 48, no. 4, pp. 996–1008, Apr. 2013, doi: 10.1109/JSSC.2013.2239114.
- [[9]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10489983) H. Xu, S. Ji, Y. Wang, X. Lin, H. Min, and N. Yan, “Analysis and Design of a Sub-Sampling PLL of Low Phase Noise and Low Reference Spur,” IEEE Transactions on Circuits and Systems I: Regular Papers, vol. 71, no. 8, pp. 3597–3607, Aug. 2024, doi: 10.1109/TCSI.2024.3380600.
- [[10]](https://www.mdpi.com/2079-9292/11/14/2133) X. Wei et al., “Design and Analysis of the Self-Biased PLL with Adaptive Calibration for Minimum of the Charge Pump Current Mismatch,” Electronics, vol. 11, no. 14, July 2022, doi: 10.3390/electronics11142133.
- [[11]](https://ris.utwente.nl/ws/files/6036605/thesis_X_Gao.pdf) X. Gao, “Low jitter low power phase locked loops using sub-sampling phase detection,” PhD, University of Twente, Enschede, The Netherlands, 2010. doi: 10.3990/1.9789036530224.
- [[12]](https://ietresearch.onlinelibrary.wiley.com/doi/epdf/10.1049/cje.2018.02.003) H. Yuan, Y. Guo, Y. Liu, B. Liang, and Q. Guo, “A Self-Biased Low-Jitter Process-Insensitive Phase-Locked Loop for 1.25Gb/s-6.25Gb/s SerDes,” Chinese Journal of Electronics, vol. 27, no. 5, pp. 1009–1014, 2018, doi: 10.1049/cje.2018.02.003.



