# Precision Full-Wave Rectifier

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 17:27 on 2025-04-28 in Beijing.

## Intro

王东雷老师在“线性电子电路实验”课程的 [实验五：精密整流与有效值检测电路 (2024)](https://www.writebug.com/static/uploads/2025/4/28/64d06a65fe21d4317affb10f5a0d78c7.pdf) 中给出了几种精密整流电路的实现方法。这里的所谓“精密”，是指在普通全波整流的基础上，去除了二极管的正向压降，达到真正的 "Full Wave Rectifier" 效果。

但是，上面课件中的整流电路只是不同运放模块的级联 (半波整流 + 线性运算器), 消耗的元件较多。我们查阅了相关资料，发现有更为简洁的实现方法，使用的元件更少，且性能很不错。因此，我们将在实验中使用这种更为简洁的整流电路而不是课件上给出的整流电路电路。

下面就分别介绍这两种整流电路的原理和实现方法。

## 王老师课件中的整流电路

### Theory of Operation

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-03-40_Precision Full-Wave Rectifier.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-01-13_Precision Full-Wave Rectifier.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-20-22_Precision Full-Wave Rectifier.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-07-54_Precision Full-Wave Rectifier.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-08-14_Precision Full-Wave Rectifier.png"/></div>

### LTspice Verification


$$
\begin{gather}
V_{out} = 1 * |V_{in}|,\quad V_{in} = 5 \,sin(2\pi (50 \ \mathrm{Hz}) t) \ \mathrm{V}
\end{gather}
$$
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-26-05_Precision Full-Wave Rectifier.png"/></div>

<br>

$$
\begin{gather}
V_{out} = 5 * |V_{in}|,\quad V_{in} = 1 \,sin(2\pi(50 \ \mathrm{Hz}) t) \ \mathrm{V}
\end{gather}
$$
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-29-28_Precision Full-Wave Rectifier.png"/></div>


100 kHz 时整流波形失真明显（但对整流效果影响较小）：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-34-06_Precision Full-Wave Rectifier.png"/></div>

最高工作频率受运放和二极管限制 (主要是二极管):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-54-58_Precision Full-Wave Rectifier.png"/></div>

## TI: Precision Rectifier

- 原文链接 : [TI Verified Design: Precision Full-Wave Rectifier, Dual-Supply](https://www.ti.com/lit/ug/tidu030/tidu030.pdf)

### Design Summary

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-11-03_Precision Full-Wave Rectifier.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-10-51_Precision Full-Wave Rectifier.png"/></div>


### Theory of Operation

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-12-58_Precision Full-Wave Rectifier.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-16-40_Precision Full-Wave Rectifier.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-18-16-51_Precision Full-Wave Rectifier.png"/></div>

### Peak Detector

基于上面电路，我们还可以稍作修改，得到一个峰值检测器 (Peak Detector) 电路。参考 *The Art of Electronics (Paul Horowitz, Winfield Hill) (3rd edition, 2015)* 的 page 255:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-29-22-01-11_Precision Full-Wave Rectifier.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-29-22-01-22_Precision Full-Wave Rectifier.png"/></div>


## ADI: Absolute Circuit using LT1078 (rail-to-rail)

- 原文链接 1: [How does a precision rectifier work?](https://www.analogictips.com/how-does-a-precision-rectifier-work-faq/)
- 原文链接 2: [ADI: Datasheet of LT1078/LT1079](https://www.analog.com/media/en/technical-documentation/data-sheets/10789fe.pdf) page-14

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-20-45-01_Precision Full-Wave Rectifier.png"/></div>

LTspice 仿真验证：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-28-20-45-34_Precision Full-Wave Rectifier.png"/></div>

其它参考资料：
- [ADI: Build a Full-Wave Rectifier Circuit with a Single-Supply Op Amp](https://www.analog.com/en/resources/technical-articles/build-a-fullwave-rectifier-circuit-with-a-singlesupply-op-amp.html)
- [A New Precision Peak Detector/Full-Wave Rectifier](https://www.scirp.org/pdf/JSIP_2013022714504761.pdf)
- [Electronically Tunable Full Wave Precision Rectifier Using DVCCTAs](https://www.mdpi.com/2079-9292/10/11/1262)