# Jitter and Phase Noise in Mixed-Signal Circuits

> [!Note|style:callout|label:Infor]
Initially published at 16:04 on 2025-08-23 in Beijing.

## Introduction

随着技术发展，数据传输速率越来越快，对数据/时钟等关键信号的抖动要求越来越严格。在此之前，重要的是要理解抖动的概念、不同类型的抖动、其成因以及如何对其进行测量。

在本文，我们给出了几种常见 jitter 的定义和示例，并推荐相关资源以帮助读者深入理解，以及用于转换、估算和计算不同类型抖动的便捷计算器工具。


## 1. Types of Jitter

Jitter 的分类在不同领域会有一定出入，但总归是大同小异。

下图来自参考资料 [[5]](https://www.teledynelecroy.com/doc/understanding-dj-ddj-pj-jitter-calculations):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-24-00-52-39_Jitter and Phase Noise in Mixed-Signal Circuits.png"/></div>


下图来自链接 http://emlab.uiuc.edu/ece546/Lect_23.pdf
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-24-00-56-57_Jitter and Phase Noise in Mixed-Signal Circuits.png"/></div>



根据文献 [[1]](https://designers-guide.org/analysis/PLLnoise+jitter.pdf) [[2]](https://www.mouser.com/pdfdocs/timing-jitter-tutorial-and-measurement-guide-ebook.pdf) [[3]](https://picture.iczhiku.com/resource/eetop/WYkThFaorkHwkCXB.pdf) 的内容，我们将实际仿真/测量中常见的几种 jitter 类型总结如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-24-01-23-14_Jitter and Phase Noise in Mixed-Signal Circuits.png"/></div>

## 2. Jitter Calculation

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-24-01-25-35_Jitter and Phase Noise in Mixed-Signal Circuits.png"/></div>

``` matlab
T = 100;
t_i = [0 91.8 204.6 304.6 400]
T_i = t(2:end) - t(1:end-1)

% jitter
Jc = T_i - T
Jcc = Jc(2:end) - Jc(1:end-1)
Je = t_i - (0:(length(t_i)-1))*T
Jee = Je(2:end) - Je(1:end-1)

% peak-peak and rms value
Jc_pp = max(Jc) - min(Jc)
Jc_rms = sqrt(var(Jc))

Jcc_pp = max(Jcc) - min(Jcc)
Jcc_rms = sqrt(var(Jcc))

Je_pp = max(Je) - min(Je)
Je_rms = sqrt(var(Je))

Jee_pp = max(Jee) - min(Jee)
Jee_rms = sqrt(var(Jee))
```


## 3. RMS vs. PP Values

在实际的 total jitter noise 中，仿真/测量得到的波形总是含有 random noise (随机噪声)，而随机噪声是 unbounded 的 (可以任意大，只是概率很小罢了)，这使上面一节所定义的 peak-to-peak jitter 失去意义。此时简单地用最大值减去最小值并不能正确反映一个系统的噪声性能，于是人们根据 RMS jitter 的值，假设其满足 Gaussian distribution (正态分布) 定义了一种新的 peak-to-peak jitter [[1]](https://designers-guide.org/analysis/PLLnoise+jitter.pdf)。具体内容详见 [Literature [1]](https://designers-guide.org/analysis/PLLnoise+jitter.pdf) page 26 of 52, 这里直接给出截图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-24-00-34-48_Jitter and Phase Noise in Mixed-Signal Circuits.png"/></div>

上图的 Error Rate 指发生错误的概率，也就是高斯分布中两端剩余面积占总面积的比例。显然, Error Rate 越小，两端面积越小，根据 $J_{PP} = \alpha J_{RMS}$ 得到的 PP 值就越大。

## 4. Phase Noise

Phase noise 的定义与 jitter 不同。


Phase noise spectrum 是功率谱，一般以 dBc/Hz 为单位，其中 dBc 是指 noise 除以 signal (carrier) 之后再取 dB10 = 10*log10 (功率谱一般取 dB10, 幅度谱才是取 dB20)。


## 5. Phase Noise Calculation

## 6. Jitter vs. Phase Noise

Period jitter (cycle jitter) $J_{c}$ 和 Phase Noise 之间是有内在联系的。具体而言，知道 Phase Noise Spectrum 之后，可以由积分算出 $J_{c,rms}$；反之亦是，知道整个采样区间内的 $J_{c}(i)$ (一般至少 1k 个周期)，可以计算出 Phase Noise Spectrum. 


参考这篇文章 [ADI Application Note > Clock (CLK) Jitter and Phase Noise Conversion.pdf](https://www.analog.com/media/en/technical-documentation/tech-articles/clock-clk-jitter-and-phase-noise-conversion.pdf).




## Accompanying Materials

下面是参考资料 [[6]](https://www.sitime.com/zh-hans-cn/company/newsroom/blog/jitter-101-what-you-need-know) 所推荐的 **jitter application notes**:
- [Clock Jitter Definitions and Measurement Methods](https://www.sitime.com/support/resource-library/application-notes/an10007-clock-jitter-definitions-and-measurement-methods) – Learn more about different types of jitter encounter in today’s high-speed systems, plus best practices for measuring jitter using a real time oscilloscope in this application note.
- [How to Setup a Real-time Oscilloscope to Measure Jitter](https://www.sitime.com/support/resource-library/application-notes/an10073-how-setup-real-time-oscilloscope-measure-jitter) – One of the most common instruments used to measure jitter is the real-time digital oscilloscope. This application note provides guidelines for setting up an oscilloscope for best jitter measurement accuracy.
- [Removing Oscilloscope Noise from RMS Jitter Measurements](https://www.sitime.com/support/resource-library/application-notes/an10074-removing-oscilloscope-noise-rms-jitter) – Learn how to accurately measure jitter using a real-time oscilloscope when the level of jitter added to a signal from the measurement environment approaches or exceeds the signal's intrinsic jitter.

参考资料 [[6]](https://www.sitime.com/zh-hans-cn/company/newsroom/blog/jitter-101-what-you-need-know) 还推荐了一些 **free on-demand courses on jitter**:
- [Jitter Fundamentals](https://learning.sitime.com/explore/jitter-fundamentals?utm_source=sitime.com&utm_medium=site&_gl=1*l8jjj4*_gcl_au*OTE2ODU2NjU1LjE3NTU5NjM1ODk.*_ga*NjI5OTUwMzUxLjE3NTU5NjM2ODU.*_ga_3D908EQ7KW*czE3NTU5NjM2ODQkbzEkZzEkdDE3NTU5Njg3OTMkajQ5JGwwJGgxMTI2MzQyMzMx)
- [Clock Jitter in High-speed Serial Links](https://learning.sitime.com/explore/clock-jitter-high-speed-serial-links?utm_source=sitime.com&utm_medium=site&_gl=1*l8jjj4*_gcl_au*OTE2ODU2NjU1LjE3NTU5NjM1ODk.*_ga*NjI5OTUwMzUxLjE3NTU5NjM2ODU.*_ga_3D908EQ7KW*czE3NTU5NjM2ODQkbzEkZzEkdDE3NTU5Njg3OTMkajQ5JGwwJGgxMTI2MzQyMzMx)
- [How PLLs Filter Jitter](https://learning.sitime.com/explore/how-plls-filter-jitter?utm_source=sitime.com&utm_medium=site&_gl=1*p82dsx*_gcl_au*OTE2ODU2NjU1LjE3NTU5NjM1ODk.*_ga*NjI5OTUwMzUxLjE3NTU5NjM2ODU.*_ga_3D908EQ7KW*czE3NTU5NjM2ODQkbzEkZzEkdDE3NTU5Njg4MTckajI1JGwwJGgxMTI2MzQyMzMx)
- [Understanding Precision Oscillator Specifications](https://learning.sitime.com/explore/understanding-precision-oscillator-specifications?utm_source=sitime.com&utm_medium=site&_gl=1*1i52n3i*_gcl_au*OTE2ODU2NjU1LjE3NTU5NjM1ODk.*_ga*NjI5OTUwMzUxLjE3NTU5NjM2ODU.*_ga_3D908EQ7KW*czE3NTU5NjM2ODQkbzEkZzEkdDE3NTU5Njg4MTckajI1JGwwJGgxMTI2MzQyMzMx)
- [Common Timing Issues and Solutions](https://learning.sitime.com/explore/common-timing-issues-and-solutions?utm_source=sitime.com&utm_medium=site&_gl=1*1i52n3i*_gcl_au*OTE2ODU2NjU1LjE3NTU5NjM1ODk.*_ga*NjI5OTUwMzUxLjE3NTU5NjM2ODU.*_ga_3D908EQ7KW*czE3NTU5NjM2ODQkbzEkZzEkdDE3NTU5Njg4MTckajI1JGwwJGgxMTI2MzQyMzMx)


以及常用的 jitter calculators:
- [Phase Noise to Jitter Calculator](https://www.sitime.com/phase-noise-and-jitter-calculator) – Convert phase noise to phase jitter (rms) for a specified offset frequency range. Plot phase noise data and export results as a png, csv or PDF file.
- [Jitter Budget Spreadsheet Calculator](https://www.sitime.com/jitter-budget-calculator) – Estimate total jitter by connecting several elements in series, given each element's random and deterministic jitter contribution. Alternatively, begin with a jitter target, then budget jitter for each element to meet this target.
- [RMS to Eye-closure Jitter Calculator](https://www.sitime.com/rms-eye-closure-jitter-calculator) – Computes the eye-closure in a BER bathtub plot due to the random component of TIE jitter (in ps rms) in a signal. Alternatively, calculate a crest factor for your specific application.
- [RMS to Peak-peak Jitter Calculator](https://www.sitime.com/rms-peak-peak-jitter-calculator) – Evaluate a jitter distribution at a specified probability to convert an rms value of jitter into a peak-to-peak value. A quick reference table is also provided to estimate probabilities.
- [Phase Noise Spreadsheet Calculator](https://www.sitime.com/phase-noise-spreadsheet-calculator) – Calculate phase jitter from measured phase noise data, including jitter filtering. Plus, learn all the math behind these calculations.


## References

- [[1]](https://designers-guide.org/analysis/PLLnoise+jitter.pdf) “Predicting the Phase Noise and Jitter of PLLBased Frequency Synthesizers,” in Phase-Locking in High-Performance Systems, IEEE, 2009. doi: 10.1109/9780470545492.ch5.
- [[2]](https://www.mouser.com/pdfdocs/timing-jitter-tutorial-and-measurement-guide-ebook.pdf) “Timing Jitter Tutorial and Measurement Guide.” Accessed: Aug. 23, 2025. [Online]. Available: https://www.mouser.com/pdfdocs/timing-jitter-tutorial-and-measurement-guide-ebook.pdf
- [[3]](https://picture.iczhiku.com/resource/eetop/WYkThFaorkHwkCXB.pdf) D. C. Lee, “Analysis of jitter in phase-locked loops,” IEEE Trans. Circuits Syst. II, vol. 49, no. 11, pp. 704–711, Nov. 2002, doi: 10.1109/TCSII.2002.807265.
- [[4]](https://ww1.microchip.com/downloads/aemDocuments/documents/VOP/ApplicationNotes/ApplicationNotes/Clock_Jitter_Basics.pdf) “Clock_Jitter_Basics.” [Online]. Available: https://ww1.microchip.com/downloads/aemDocuments/documents/VOP/ApplicationNotes/ApplicationNotes/Clock_Jitter_Basics.pdf
- [[5]](https://www.teledynelecroy.com/doc/understanding-dj-ddj-pj-jitter-calculations) “Understanding Jitter Calculations: Why Dj Can Be Less Than DDj (or Pj).” Accessed: Aug. 24, 2025. [Online]. Available: https://www.teledynelecroy.com/doc/understanding-dj-ddj-pj-jitter-calculations
- [[6]](https://www.sitime.com/zh-hans-cn/company/newsroom/blog/jitter-101-what-you-need-know) “Jitter 101. What you need to know. | SiTime.” Accessed: Aug. 23, 2025. [Online]. Available: https://www.sitime.com/zh-hans-cn/company/newsroom/blog/jitter-101-what-you-need-know

