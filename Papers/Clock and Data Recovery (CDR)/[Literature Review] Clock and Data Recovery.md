# [Literature Review] Clock and Data Recovery

## 1. Introduction


在高速通信系统中 (例如高速收发器 transceiver)，随着传输线长度的增加和信号频率的提高，数据信息可能会受到严重影响，导致数据信号失真等一系列负面效应。这些系统中接收到的数据既不同步又存在噪声，因此需要提取时钟以实现同步操作。此外，数据必须进行 "重定时" (retiming), 以消除传输过程中累积的抖动和偏移 (jitter and skew)。基于以上因素, Clock and Data Recovery (CDR, 时钟数据恢复) 应运而生。 

如下图, CDR 的主要功能是：从接收到的串行数据流提取出时钟信号，然后根据此时钟信号对数据进行 "重建"，从而达到数据恢复的目的。也就是分为两步："clock generation (时钟信号生成)" 和 "retiming data (数据信号恢复)"。引入 CDR 不仅可以提高数据传输的可靠性和稳定性，还避免了时钟信号单独传输带来的功耗、成本和噪声问题，显著提升了信道利用率与抗干扰能力。


图源文献 [1]
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-19-56-33_[Literature Review] Clock and Data Recovery.png"/></div>


图源文献 [1]
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-02-19-53-40_[Literature Review] Clock and Data Recovery.png"/></div>


目前，大多数的 CDR 都是基于 PLL (Phase-Locked Loop) 或者 DLL (Delay-Locked Loop) 实现的，少部分基于其它架构，例如 phase-interpolator, injection locking, oversampling, gated oscillator, high-Q bandpass filter 等等，详见论文 [1] 的参考文献。


上面这么多种架构大致可以分为三类 [1]：
1) **Topologies using feedback phase tracking**, including, phase locked loop (PLL), delay locked loop (DLL), phase interpolator (PI) and injection locked (IL) structures. 
2) **An oversampling-based (OS-based) topology without feedback phase tracking**. 
3) **Topologies using phase alignment but without feedback phase tracking**, including gated oscillator (GO) structures.

本文不会详细介绍每一种结构的原理，仅对 CDR 当前的研究进展进行总结。




## 2. 

## 3. 

## Relevant Links

以下是与本文主题 TSPC 相关的一些链接，在正文中不一定有所参考，但也陈列于此，以期对读者有所帮助：

## References

- [\[1\]](https://people.engr.tamu.edu/spalermo/ecen689/cdr_comparisons_hsieh_cas_2008.pdf) M. Hsieh and G. E. Sobelman, “Architectures for multi-gigabit wire-linked clock and data recovery,” IEEE Circuits Syst. Mag., vol. 8, no. 4, pp. 45–57, 2008, doi: 10.1109/MCAS.2008.930152.
- [\[2\]](https://seas.ucla.edu/brweb/papers/Journals/BRAug02.pdf) B. Razavi, “Challenges in the design high-speed clock and data recovery circuits,” IEEE Commun. Mag., vol. 40, no. 8, pp. 94–101, Aug. 2002, doi: 10.1109/MCOM.2002.1024421.
- [\[3\]](https://picture.iczhiku.com/resource/eetop/WhIFtjfwiOSRDCvx.pdf) J. Lee, K. S. Kundert, and B. Razavi, “Analysis and modeling of bang-bang clock and data recovery circuits,” IEEE J. Solid-State Circuits, vol. 39, no. 9, pp. 1571–1580, Sep. 2004, doi: 10.1109/JSSC.2004.831600.
- [4] S. Gondi and B. Razavi, “Equalization and Clock and Data Recovery Techniques for 10-Gb/s CMOS Serial-Link Receivers,” IEEE J. Solid-State Circuits, vol. 42, no. 9, pp. 1999–2011, Sep. 2007, doi: 10.1109/JSSC.2007.903076.
- [5] C. Hogge, “A self correcting clock recovery curcuit,” J. Lightwave Technol., vol. 3, no. 6, pp. 1312–1314, Dec. 1985, doi: 10.1109/JLT.1985.1074356.
- [6] Jri Lee and B. Razavi, “A 40-Gb/s clock and data recovery circuit in 0.18-μm CMOS technology,” IEEE J. Solid-State Circuits, vol. 38, no. 12, pp. 2181–2190, Dec. 2003, doi: 10.1109/JSSC.2003.818566.
- [7] T. H. Lee and J. F. Bulzacchelli, “A 155-MHz clock recovery delay- and phase-locked loop,” IEEE J. Solid-State Circuits, vol. 27, no. 12, pp. 1736–1746, Dec. 1992, doi: 10.1109/4.173100.
- [8] J. Savoj and B. Razavi, “A 10-Gb/s CMOS clock and data recovery circuit with a half-rate linear phase detector,” IEEE J. Solid-State Circuits, vol. 36, no. 5, pp. 761–768, May 2001, doi: 10.1109/4.918913.
- [9] J. Savoj and B. Razavi, “A 10-Gb/s CMOS clock and data recovery circuit with a half-rate binary phase/frequency detector,” IEEE J. Solid-State Circuits, vol. 38, no. 1, pp. 13–21, Jan. 2003, doi: 10.1109/JSSC.2002.806284.
- [10] J. L. Sonntag and J. Stonick, “A Digital Clock and Data Recovery Architecture for Multi-Gigabit/s Binary Links,” IEEE J. Solid-State Circuits, vol. 41, no. 8, pp. 1867–1875, Aug. 2006, doi: 10.1109/JSSC.2006.875292.

