# Virtuoso Tutorials - 18. How to Create a Voltage Supply Source with White Noise

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 01:14 on 2025-11-16 in Beijing.

## Introduction

起因是在最近的项目 [An Ultra-Low-Power CP-PLL in ONC 180nm Technology](<Projects/Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology.md>) 中，需要根据甲方提供的电源噪声参数对锁相环进行仿真，以评估电路在实际工作条件下的性能。除已知的特定频率纹波外，我们还需要给电源加上一定的白噪声，才能更真实地模拟锁相环的供电环境。

本文就来介绍如何在 Virtuoso 中创建一个包含白噪声的电压源/电流源，并给出具体设置以供参考。


## 1. Noisy Voltage Supply

我们知道一个电阻的热噪声 (thermal noise) $S_{V_n}(f) = 4 k T R$ 在整个频谱上都为恒定值，是最典型的白噪声之一。因此，完全可以利用电阻来实现带有白噪声的电压源。直接在电压源上串联一个大电阻吗？显然不行，这会导致电源的输出电阻非常大，反而偏离了实际供电情况。 





EETOP 上有网友提出了一个简单而实用的方案：利用 resistor + VCVS (voltage-controlled voltage source) 组合来实现 noisy supply [{1}](https://bbs.eetop.cn/thread-870992-1-1.html)，基本原理如下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-01-53-21_Virtuoso Tutorials - 18. How to Create a Supply Source with White Noise.png"/></div>


实际电路中，由于滤波/去耦电容或寄生电容的存在，电源的噪声总是存在一定带宽，这保证了 RMS voltage noise < $\infty$。具体而言，电阻 $R$ 与 RMS 噪声电压 $V_{n,rms}$ 之间的关系为：


$$
\begin{gather}
S_{V_n}(f) = 4 k T R \Longrightarrow V_{n,rms}^2 = \int_0^{f_{\max}} S_{V_n}(f) df = 4 k T R \cdot f_{\max}
\\
\mathrm{where:\ \ } k = 1.380649 \times 10^{-23} \ \mathrm{J/K} \ \mathrm{(Boltzmann\ constant)}
\\
\Longrightarrow R = \frac{V_{n,rms}^2}{4 k T f_{\max}} = \frac{V_{n,rms}^2}{f_{\max} \times 1.6567788 \times 10^{-20} \ \mathrm{V^2\cdot \Omega^{-1}\cdot Hz^{-1}} } \ (T = 300 \ \mathrm{K} = 27^\circ \mathrm{C})
\end{gather}
$$

为了得到 "与仿真时间步长无关" 的 rms voltage noise, 我们可以利用滤波器来调整白噪声频谱，手动限制噪声带宽。这里可以用理想器件搭建低阶或高阶滤波器，也可以参考 [{3} Cadence Virtuoso 中实现理想低通滤波器的方法](https://zhuanlan.zhihu.com/p/1951974455933928357) 使用理想低通滤波器，但我们不妨直接用两个 parameter (vn_rms, fnoise_max) 来做数学运算，从而实现预期 rms noise value.



为了方便调用，我们把上述电路封装成一个 parameterized cell (p-cell), 具体封装教程见 [Virtuoso Tutorials - 17. Creating Parameter Passing Symbol as The Standard PCell](<AnalogIC/Virtuoso Tutorials - 17. Creating Parameter Passing Symbol as The Standard PCell.md>)，使其在输入电压的基础上 "额外叠加" 一个白噪声电压，下面是测试结果：

<div class='center'>

| 注意 tran 仿真一定要打开 transient noise, 否则电阻等器件的噪声将不被开启 |
|:-:|
 | 下图可以看到，除了 Vn_rms 较大且 fnoise_max 过小时，输出噪声 std value 与预期值都相符 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-16-02-38-48_Virtuoso Tutorials - 18. How to Create a Supply Source with White Noise.png"/></div> |
 | 至于为什么  "Vn_rms 较大且 fnoise_max 过小时 RMS noise 变小"，还有待进一步探究 |
 | 当前电路，对于常用的 rms noise <= 10 mV, fnoise_max 在 1 kHz 及以上时模块都能正常工作，这满足了绝大多数设计需求，所以暂时不需要进一步修正 |
</div>





## 2. Noisy Current Supply

## Reference


- [{1} EETOP > [求助] 请教--自定义噪声源，高斯白噪声序列的功率谱密度](https://bbs.eetop.cn/thread-870992-1-1.html)
- [{2} Cadence 开关电容电路噪声仿真（一）: Cadence 中的理想噪声源](https://zhuanlan.zhihu.com/p/1931718989668661022)
- [{3} Cadence Virtuoso 中实现理想低通滤波器的方法](https://zhuanlan.zhihu.com/p/1951974455933928357)