# Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 18:13 on 2025-12-24 in Beijing.
> dingyi233@mails.ucas.ac.cn

## Introduction

Sub-Sampling PLL (SS-PLL，欠采样锁相环) 是 Xiang Gao 等人在 ISSCC'09 正式发表/提出的一种新型锁相环架构，其核心创新在于从锁相路径中 **完全移除了反馈分频器 $N$** ，这一设计革命性地改变了传统锁相环的工作方式，避免了传统 CP-PLL 中 PFD/CP 噪声被 “放大 N^2 倍” 导致的相位噪声问题，这 **使得 SS-PLL 在相位噪声性能上实现了重大突破** 。开山原始论文为：
>[[2]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5342373) X. Gao, E. A. M. Klumperink, M. Bohsali, and B. Nauta, “A Low Noise Sub-Sampling PLL in Which Divider Noise is Eliminated and PD/CP Noise is Not Multiplied by $N ^{2}$,” IEEE J. Solid-State Circuits, vol. 44, no. 12, pp. 3253–3263, Dec. 2009, doi: 10.1109/JSSC.2009.2032723.

2009 ~ 2016 年，大量有前景的 SS-PLL 架构被提出，但主要仍停留在研究阶段。2016 年后，随着高速串行链路和低抖动时钟源需求的激增，SS-PLL 技术得到快速发展，随着大量 sub-ps 级甚至 sub-100fs 级低抖动 SS-PLL 被报道 (传统 CP-PLL 抖动通常在 10-ps 量级)，逐渐演变出先进数模融合架构以及全数字架构等，并开始应用于实际产品中，成为 SerDes、高速数据转换器、毫米波系统等高性能时钟解决方案的热点。


在 ISSCC'23 上，SS-PLL 与 Digital-Enhanced PLL、Cascading PLL 等架构一起，被明确指出是高性能 PLL 设计的重要趋势，这标志着它已在工业界前沿研发中被广泛采纳和优化。直到今年 (2025)，学术界和工业界仍在发表关于改进 SS-PLL 架构的最新研究成果，并持续向更低抖动 (< 50fs)、更快重锁定时间 (relock < 5us) 等更高性能演进，表明该技术目前仍处于活跃发展期。


## 1. Jitter in High-Speed Systems

时钟的抖动性能常常从根本上决定关键模块的模拟带宽，从而限制了系统的整体性能。关上面这样干巴巴的讲，可能没什么意思，我们不如举一个实际例子 (高速 ADC) 来体会为什么低抖动时钟源如此重要。

一个 N-bit ADC 对频率为 $f_{in}$ 的信号进行采样时，为保证 N-bit 电压分辨率精度，其边沿抖动 (edge jitter, 与相位抖动 phase jitter 对应) $J_{e}$ 需满足：

$$
\begin{gather}
\Delta V = \mathrm{SR} \times \Delta t \le  \frac{1}{2} \times \frac{V_{FS}\  \ \mathrm{(in\ V_{pp})}}{2^N}  = \frac{V_{FA}\  \ \mathrm{(in\ V_{amp})}}{2^N}
\\
\Longrightarrow
J_{e,pp} \le (\Delta t)_{\max} = \frac{1}{2^N \times (2 \pi f_{in})}
\\
J_{e,pp} = k J_{e,rms},\quad k = 5 \sim 10 \ (\mathrm{depends\ on\ BER, \mathrm{typ.}\ 6})
\end{gather}
$$

那么 8-bit ADC 对 1 GHz 信号进行采样时，边沿抖动要求为：

$$
\begin{gather}
J_{e,rms} \le \frac{1}{k \times 2^8 \times (2 \pi \times 1 \ \mathrm{GHz})} = 
\begin{cases}
103.62 \ \mathrm{fs} \,@\, k = 6 \\
77.71 \ \mathrm{fs} \ \ \,@\, k = 8 \\
62.17 \ \mathrm{fs} \ \ \,@\, k = 10 \\
\end{cases}
\end{gather}
$$

这显然是一个很高的抖动性能要求了，也是高速 ADC/DAC 必须使用先进低抖动时钟源的主要原因 (之一)。



## 2. Basics of Sub-Sampling PLL

本节主要参考 [[1]](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-36.pdf) 中的 Chapter 21. Sub-Sampling PLL Techniques (page.583-603)，这一部分的核心内容其实就是 SS-PLL 开山论文 [[2]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5342373) 的详细讲解和分析。


### 2.1 classic CP-PLL recap

传统 CP-PLL 框图及其相位域模型如下图所示 [[1]](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-36.pdf)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-25-00-17-58_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-25-00-37-12_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>

其中 LPF 从 1st-order 到 3rd-order 都行，如下图所示 [[5]](https://www.research-collection.ethz.ch/entities/publication/5165a118-9ef5-4eb9-a292-8a3245360722)，不过实际中还是 2nd-order 最常见：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-28-01-20-52_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>



文献 [[1]](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-36.pdf) 认为闭环状态下 CP 电流噪声到 VCO 相位噪声的传递函数为：

$$
\begin{gather}
H_{CP}(s) = \frac{1}{\beta_{CP}}\times \frac{H_{OL}(s)}{1 + H_{OL}(s)} = \frac{N}{K_d} \times \frac{H_{OL}(s)}{1 + H_{OL}(s)} \quad (此为错误公式)
\end{gather}
$$

**<span style='color:red'> 论文 [[1]](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-36.pdf) 中的这个式子是默认 $H_{OL}$ 包含了 $\frac{1}{N}$ 一项！事实上，以 VCO output 作为输出相位时，开环传递函数不应包括分频比，而是应该将分频比视为 feedback coefficient $F = \frac{1}{N}$，这样闭环传递函数就是 $H_{CL} = \frac{H_{OL}}{1 + F H_{OL}} = \frac{H_{OL}}{1 + \frac{H_{OL}}{N}}$. </span>**

按我们的思路，重新推导 CP noise transfer function, 可以得到：
$$
\begin{gather}
\left(x - \frac{K_d}{N} y\right) \cdot Z_{LF}(s) \cdot \frac{K_{VCO}}{s} = y \Longrightarrow \frac{H_{OL}}{K_d}\cdot x - \frac{H_{OL}}{N}\cdot y = y \\
\Longrightarrow H_{CP}(s) = \frac{y}{x} = \frac{\frac{H_{OL}}{K_d}}{1 + \frac{H_{OL}}{N}} = \frac{N}{K_d} \times \frac{H_{OL}}{N + H_{OL}} = \frac{1}{\beta_{CP}} \times \frac{H_{OL}}{N + H_{OL}}
\end{gather}
$$


其中 $H_{OL}(s) = K_d \cdot Z_{LF}(s) \cdot \frac{K_{VCO}}{s}$ 为 PLL 的开环传递函数，$\beta_{CP} = \frac{K_d}{N}$ 称为 CP 模块的反馈增益 (feedback gain)，$K_d = \frac{\overline{i_{out}}}{\phi_{in}}$ 为 PFD/CP 检测增益，典型架构时有 $K_d = \frac{I_P}{2 \pi}$。注意此时正确闭环传递函数是 $H_{CL}(s) = \frac{H_{OL}(s)}{1 + \frac{1}{N} H_{OL}(s)}$ 而不是文献 [[1]](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-36.pdf) 中的 $\frac{H_{OL}(s)}{1 + H_{OL}(s)}$。


虽然式子稍有区别，但结论是类似的： 低频 (带内) 开环增益非常大 $H_{OL} \gg N$ 时，我们有近似 $H_{CP}(s) \approx \frac{1}{\beta_{CP}} = \frac{N}{K_d}$， **CP 噪声传函上的 $N$ 倍使得 CP 噪声功率被 “放大” 了 $N^2$ 倍，这导致 CP 成为带内噪声的主要来源之一。**



我们再看看 PFD noise transfer function 的情况：

$$
\begin{gather}
\left(x - \frac{y}{N}\right) H_{OL} = y \Longrightarrow x \cdot H_{OL} - \frac{H_{OL}}{N}\cdot y = y
\\
\Longrightarrow H_{PD}(s) = \frac{y}{x} = \frac{H_{OL}}{1 + \frac{H_{OL}}{N}} = N \times \frac{H_{OL}}{N + H_{OL}} 
\end{gather}
$$

与 CP 噪声传函类似，低频时有 $H_{PD}(s) \approx N \times 1 = N$，这使得 PD 噪声功率被正正好好放大了 $N^2$ 倍，导致 PFD 也成为带内噪声的主要来源之一。

总结下来就是：

$$
\begin{gather}
\mathrm{Low\ Frequency:\quad }
H_{CP}(s) \approx \frac{N}{K_d},\quad 
H_{PD}(s) \approx N
\end{gather}
$$



### 2.2 sub-sampling concept

上面我们看到了分频比 $N$ 所带来的弊端：导致 PD/CP 噪声功率被放大 $N^2$ 倍。作为一种根本上的改进，SS-PLL 直接移除了分频器来规避这个问题。

下图展示了 SS-PLL 的基本工作原理 <span style='color:red'> (若无特别说明，默认 VCO 输出正弦波，幅度为 $A_{VCO}$) </span>：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-25-00-55-05_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-25-00-38-38_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>

相比传统 CP-PLL，SS-PLL 移除了分频器 N, 并在 REF 上升沿 (作为一个例子) 对 VCO 输出电压进行采样，记作 $V_{sam}$；这个采样电压与 VCO 输出的直流分量 $V_{DC,VCO}$ 进行比较，得到 "REF crossing-time 与 VCO crossing-time 之间的差值"，也就是相位误差；进一步转换为输出电流用于纠正此误差，便实现了相位对齐。

图中的 $g_m$ 用于将采样得到的电压差 $\Delta V = V_{sam} - V_{DC,VCO}$ 转换为电流输出 $i_{out}$，这里通常是用 OTA 或数字模块来实现，用传统 CP 的反而很少，具体细节我们等后面再来讨论。简便起见，这里将其称为为 SSCP.

这个采样得到的电压差与相位误差之间有什么关系？可以用下式来描述：

$$
\begin{gather}
\Delta V = \mathrm{SR_{VCO}} \times \Delta t = \mathrm{SR_{VCO}}  \times \frac{\Delta \phi}{2 \pi f_{VCO}}\\
\mathrm{sine\ wave:\ \ } \mathrm{SR_{VCO}}_{\mathrm{at\ small\ } \Delta \phi} = A_{VCO} 2 \pi f_{VCO} \Longrightarrow V_{sam} = A_{VCO} \Delta \phi
\end{gather}
$$


### 2.3 SS-loop analysis

首先看一下去掉分频器 $N$ 后，整个环路的开环闭环增益变成了什么样子。注意 REF 后紧跟的是一个 <span style='color:red'> "virtual freq. multiplier" </span> ，这是因为欠采样过程会将 VCO 输出与其最接近的 $N f_{ref}$ 频率关联起来，其效果就如同 VCO 是由频率比参考频率高 N 倍的信号 $(N f_{ref})$ 进行采样一样。

开环传函很容易得到，但注意闭环增益的反馈点在 input SSPD of 而不是 input of REF, 因此 REF 后紧跟的 $N$ 需要单独拿出来：

$$
\begin{gather}
H_{OL,SS}(s) = N K_{d,SS} Z_{LF}(s) \cdot \frac{K_{VCO}}{s},\quad F = 1 \,@\, A(s) = \frac{H_{OL,SS}(s)}{N}
\\
H_{CL,SS}(s) 
= N \times \frac{A(s)}{1 + F A(s)} 
= N \times \frac{\frac{H_{OL,SS}(s)}{N}}{1 + 1 \times \frac{H_{OL,SS}(s)}{N}}
= \frac{N \times H_{OL,SS}(s)}{N + H_{OL,SS}(s)} 
\end{gather}
$$

不妨将上式中引入 $A(s)$ 称为核心增益，它代表了从 input of PD 一致到 output of VCO 之间各模块的总增益情况，也即：

$$
\begin{gather}
A(s) = K_d Z_{LF}(s) \cdot \frac{K_{VCO}}{s} = \frac{H_{OL,SS}(s)}{N} = H_{OL,CP}(s)
\end{gather}
$$

换句话说，在 CP-PLL 中，核心增益 $A(s)$ 就是其开环增益，而在 SS-PLL 中，核心增益 $A(s)$ 则是其开环增益除以 $N$。


相比传统 CP-PLL 中 PFD-CP 的增益 $K_d = \frac{I_P}{2\pi}$，SS-PLL 中的 SSPFD-SSCP 增益 $K_{d,SS}$ 也稍有不同，不同结构时等效增益也不一样，下面以一个简单结构为例：  

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-26-19-35-00_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-27-00-31-07_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>


上图中，SSPD 在每次采样完成后，通过电容将采样电压暂时保存下来，然后在输出端开启时候通过 $g_m$ 将电压差值转换为输出电流，这种通过输出导通时间 $D = \frac{\tau_{pul}}{T_{ref}}$ 来控制增益的技术是非常实用的，并且越高的 $D$ 能带来越低的相噪 (这一点有些反常?)，这点我们下一小节再来讨论。

在刚刚这个 SSPD/SSCP 例子中，模块总增益 $K_{d,SS}$ 可以表示为：

$$
\begin{gather}
K_{d,SS} = \frac{\overline{i_{out}}}{\phi_{in}} = D \times \frac{2 g_m \,\mathrm{SR}}{2 \pi f_{VCO}} \overset{\mathrm{sine}}{=} D \times 2 g_m A_{VCO},\quad D \in (0,\ 0.5)
\end{gather}
$$

注意 $K_{d,SS} = D \times \frac{2 g_m \,\mathrm{SR}}{2 \pi f_{VCO}}$ 是更普适的结论，这个公式适用于 “固定相位差不为零” 或者 “VCO 输出波形非完美正弦” 的情况。对于前者，也即 “固定相位差不为零”，其可能原因多种多样，比如 OTA 单元 $g_m$ 或者使用传统 CP 但存在失配，又或者差分 VCO 两路输出存在不对称，都可能带来固定相位差，导致 SSPD/SSCP 增益曲线发生平移。当然，多数时候我们会使用 $K_{d,SS} = D \times 2 g_m A_{VCO}$ 以尽可能简化分析。

### 2.4 noise transfer function

没有了反馈路径上的分频器后，SSCP 的 PD/CP noise transfer function 变为：

$$
\begin{gather}
\mathrm{CP:\ \ } (x - K_{d,SS} y) Z_{LF} \frac{K_{VCO}}{s} = y \Longrightarrow 
H_{SSCP}(s) = \frac{y}{x} = \frac{1}{K_{d,SS}} \times \frac{H_{OL,SS}(s)}{N + H_{OL,SS}(s)}
\\
\mathrm{PD:\ \ } (x - y) \frac{H_{OL,SS}(s)}{N} = y \Longrightarrow
H_{SSPD}(s) = \frac{y}{x} = \frac{H_{OL,SS}(s)}{N + H_{OL,SS}(s)}
\end{gather}
$$


在低频带内时，开环增益 $H_{OL,SS} \gg N$，于是有近似：

$$
\begin{gather}
\mathrm{Low\ Frequency:}\ \ H_{SSCP}(s) \approx \frac{1}{K_{d,SS}},\quad H_{SSPD}(s) \approx 1
\end{gather}
$$

而对于 CP-PLL，其 PD/CP 低频下的噪声传函分别为 $H_{CP}(s) \approx \frac{N}{K_{d}},\quad H_{PD}(s) \approx N$。

也就是说，相比于原先结构，SS-PLL 中的 PD/CP noise transfer 降低到原来的 $\frac{1}{N}$ (假设 Kd 不变)，噪声功率便降低为原来的 $\frac{1}{N^2}$！这使得 SS-loop 中的 PD/CP 噪声几乎可以忽略，大大提升了环路的噪声性能。

举个具体的例子，假设 CP-PLL 和 SS-PLL 的 PD/CP 都使用经典结构，我们有：

$$
\begin{gather}
K_d = \frac{I_P}{2 \pi},\quad K_{d,SS} = 2 D g_m A_{VCO}
\\
\Longrightarrow \frac{H_{SSCP}(0)}{H_{CP}(0)} = \frac{\frac{1}{K_{d,SS}}}{\frac{N}{K_d}} 
= \frac{I_P}{N \times 2 \pi \times 2 Dg_m A_{VCO}},\quad 
\frac{H_{SSPD}(0)}{H_{PD}(0)} = \frac{1}{N}
\end{gather}
$$

对高速低抖动时钟生成来讲，REF 频率通常不会超过 0.1 GHz 或者 0.25 GHz (250 MHz)，传统 CP-PLL 要实现 GHz-level 的输出频率必须有较大的 Integer-N (比如 64, 128 甚至 256)。以 Integer-64 作为例子，代入典型环路参数，直观感受一下 PD/CP noise 到底下降了多少：

$$
\begin{gather}
I_P = 100 \ \mathrm{uA},\ \ N = 64,\quad D = 0.25,\ \ g_m = 20 \ \mathrm{uS},\quad A_{VCO} = 0.5 \ \mathrm{V}
\\
\Longrightarrow \frac{H_{SSCP}(s)}{H_{CP}(s)} = 0.0497 = \frac{1}{20.11},\quad \left(\frac{H_{SSCP}(s)}{H_{CP}(s)}\right)^2 = \frac{1}{404.26}
\end{gather}
$$

CP noise transfer 变为原来的 $\frac{1}{20}$，使得噪声功率下降为原来的 $\frac{1}{400}$ 倍，相当于噪声功率 "凭空" 降低了 26 dB，效果立竿见影！

不得不提的是， SS-PLL 虽然将 PD 和 CP 的噪声功率降低到原来的 $\frac{1}{N^2}$ 量级，但并没能降低 REF 源本身的噪声，因为其 phase-domain model 中仍存在一个 "virtual freq. multiplier"，这使得 SS-PLL 和 CP-PLL 类似，都具有 “参考源噪声功率被放大 N^2 倍” 的特性。针对这一点，目前已有一些论文提出了改进方案，这里就不多赘述，感兴趣的读者可以自行查阅。





### 2.5 CP in-band noise 

上面只是从 noise transfer function 角度进行了讨论，需要注意的是，不同结构的噪声源不同，相应的噪声功率大小也不同。为搞清楚这个噪声到底降低了多少，我们还需从等效噪声功率谱的角度来研究。

一个跨导为 $g_m$ 的 MOS 管，其电流噪声密度为：

$$
\begin{gather}
\overline{i_n^2} = S_{i_n}(f) = 4 g_m \gamma k T,\quad f \in (0,\ +\infty)
\\
\mathrm{or:\ \ } \overline{i_n^2} = S_{i_n}(f) =  2 g_m \gamma k T,\quad f \in (-\infty,\ +\infty)
\end{gather}
$$

若无特别说明，我们均默认功率谱被定义在 $(0, +\infty)$ 上，也就是 $S_{i_n}(f) = 4 g_m \gamma k T$。由于 CP 仅在每个 $T_{ref}$ 的 $\tau_{pul}$ 时间内导通，其等效噪声功率会缩小为原来的 $D = \frac{\tau_{pul}}{T_{ref}}$ 倍，因此 CP 的等效噪声功率谱为：

$$
\begin{gather}
S_{i_n,CP}(f) = D \times S_{i_n}(f) = 4 D g_m \gamma k T
\end{gather}
$$

进一步地，将其转换为 SSB phase noise, 注意从 $S(f)$ 到 $L(f_m)$ 需要乘二分之一，我们有：

$$
\begin{gather}
L_{SSCP}(f_m)_{\mathrm{in-band}} = H_{SSCP}^2(f_m) \times \left[ \frac{1}{2} S_{i_n,CP}(f) \right] = \left(\frac{1}{K_{d,SS}}\right)^2 \times \left[ \frac{1}{2} \times 4 D g_m \gamma k T \right]
\\
\Longrightarrow
L_{SSCP}(f_m)_{\mathrm{in-band}} = \frac{1}{2} \times \frac{\gamma k T}{g_m D A_{VCO}^2} \ \ \mathrm{rad^2_{rms}/Hz}
\\
L_{SSCP}(f_m)_{\mathrm{in-band}} = 10\log_{10}\left(\frac{1}{2} \times \frac{\gamma k T}{g_m D A_{VCO}^2}\right) \ \ \mathrm{dBc/Hz}
\end{gather}
$$

可以看到，随着充电占空比 $D$ 的增加，SSCP 的带内相位噪声会降低，代入典型值直观感受一下这个相位噪声有多大：

$$
\begin{gather}
\begin{cases}
k = 1.381 \times 10^{-23} \ \mathrm{J/K},\ \ T = 300 \ \mathrm{K},\ \ \gamma = 1
\\
g_m = 20 \ \mathrm{uS}, \ \ A_{VCO} = 0.5 \ \mathrm{V},\ \ D = 0.25
\end{cases}
\\
\Longrightarrow L_{SSCP}(f_m)_{\mathrm{in-band}} = -147.81 \ \mathrm{dBc/Hz\ \ (typ.)}
\end{gather}
$$

显然，这算是一个非常低的相位噪声水平了，远低于传统 CP-PLL 由 charge pump 贡献的带内相噪 (通常在 -100 至 -130 dBc/Hz 之间)，这也是为什么在 SS-PLL 中 CP 噪声通常只占 1% 甚至更少。

作为对比，我们再来看一下传统 CP-PLL 中 CP 贡献的带内相位噪声，其推导过程类似，这里直接给出结果：

$$
\begin{gather}
L_{CP}(f_m)_{\mathrm{in-band}} = D N^2 \times \frac{16 \pi^2 g_m \gamma k T}{I_P^2}  \ \ \mathrm{rad^2_{rms}/Hz},\quad D = \frac{\tau_{pulse}}{T_{ref}} \Longrightarrow
\\
L_{CP}(f_m)_{\mathrm{in-band}} = 10\log_{10}\left(D N^2 \times \frac{16 \pi^2 g_m \gamma k T}{I_P^2}\right) \ \ \mathrm{dBc/Hz}
\\
\begin{cases}
k = 1.381 \times 10^{-23} \ \mathrm{J/K},\ \ T = 300 \ \mathrm{K},\ \ \gamma = 1
\\
N = 64,\ \ g_m = 20 \ \mathrm{uS}, \ \ I_{P} = 100 \ \mathrm{uA}, \ \ D = 0.05
\end{cases}
\\
\Longrightarrow L_{CP}(f_m)_{\mathrm{in-band}} = -125.72 \ \mathrm{dBc/Hz\ \ (typ.)}
\end{gather}
$$

显然，传统 CP-PLL 中 CP 导致的带内相噪要高很多 (typ. 22.1 dBc/Hz)，侧面印证了我们前面从 noise transfer function 得到的结论。



### 2.6 PD in-band noise


上面比较了两种架构的 CP in-band noise (in dBc/Hz) 情况，下面类似地，我们再看一下 SSPD 贡献的带内相位噪声。具体推导过程比较繁琐，这里直接给出一种典型 SSPD 架构下的结论 [[3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5560323)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-26-23-52-26_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>

没错，这篇 2010 年的论文也是 Xiang Gao 2009 开山论文的后续工作 (之一)。这种 SSPD 通过引入 dummy sampler 来抑制  binary frequency shift keying (BFSK) 现象，保证 VCO 在整个周期内的负载几乎不变，从而避免周期性扰动。

如果没有 dummy sampler, 这种周期性扰动会使 VCO 控制电压 $V_{cont}$ 上叠加一个小幅度的、接近方波的纹波，整个频谱看起来就像是载波被一个低频方波 (这里是 REF) 进行了频率调制，从而在主谱线两侧对称地看到一对边带。

Xiang Gao 在论文中使用的具体参数和 SSPD 带内相噪为：

$$
\begin{gather}
L_{SSPD}(f_m)_{\mathrm{in-band}} = 10\log_{10}\left(\frac{1}{2} \times \frac{kT}{f_{ref} C_{sam} A_{VCO}^2}\right) \ \mathrm{dBc/Hz}
\\
f_{ref} = 55.25 \ \mathrm{MHz},\ \ C_{sam} = 10 \ \mathrm{fF},\ \ A_{VCO} = 0.4 \ \mathrm{V}
\\
\Longrightarrow
L_{SSPD}(f_m)_{\mathrm{in-band}} = - 136.30 \ \mathrm{dBc/Hz}
\end{gather}
$$

这同样是一个比较低的相位噪声水平，远低于传统 CP-PLL 中 PFD 贡献的带内相噪 (通常在 -100 至 -120 dBc/Hz 之间)。值得注意的是，上面的 SSPD 带内相噪与 VCO 输出频率无关，这使得 SSPD 在高频输出时仍能保持低相噪性能。




### 2.7 overall SS-PLL

整个 SS-PLL 的完整框图如下所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-27-00-55-55_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-27-00-57-12_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>


这是 Xiang Gao 在开山论文 [[2]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5342373) 中提出的最经典 SS-PLL 架构，同时也是其后续工作 [[3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5560323) 直接使用的架构。

上面已经给出了 SSPD 和 SSCP 的实现方法，更细节一点的，我们将剩余模块如何实现也一并给出，部分模块直接复制于 [[2]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5342373) 或者 [[3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5560323)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-27-01-44-49_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>

在频率误差较大时，尽管 SS-Path 处于 enable 状态 (因为我们没有加入 disable 控制)，但我们可以通过调大 CP-Path 的增益来使其主导环路行为，从而实现频率锁定 (frequency lock)。频率误差较小时 (相位误差和较小)，CP-Path 进入 dead-zone, 环路中便只有 SS-Path 在真正工作，从而实现低噪声锁相。

当然，其实 CP-PLL 中使用 typical tri-state PFD 而不是 dead-zone PFD 也是可以的。一方面是在相位误差和较小时，两个路径叠加后的增益仍能保持较好的线性度，另一方面是 tri-state PFD + CP 的设计天然就具有一定的 dead-zone 特性 (因为开关导通需要时间)，所以实际效果倒也还行，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-27-01-55-21_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>

当然，实际应用时我们一般都会主动加一个 dead-zone 控制，以确保在小相位误差下 CP-Path 完全不工作，避免 CP-Path 引入额外噪声，从而最大化 SS-Path 的低噪声优势。


### 2.8 another perspective

我们可以从另一个角度理解 “CP-PLL 中 CP-PFD 噪声功率被放大 N^2 倍” 这件事情：那就是将 CP-PLL 当作一个 transceiver，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-27-01-59-01_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>

CP-PLL 中，FD 直接将 VCO 输出频率除以 N, 相当于是一个从 RF 到 IF 的 down-converter；而 PFD 则将分频器输出的 IF 信号再次下变频为 baseband，相当于一个 IF-to-baseband down-converter。这样一来，FD 和 PFD 两个模块就是在 “检测 VCO 的输出相噪”，然后通过 CP/LPF 将其反馈到 VCO 上，以此 suppress/cancel 掉 VCO 输出端的相位噪声。

与之相反，SS-PLL 中并没有分频器 N, 而是直接由 SSPD 将 VCO 输出相噪 down-convert 到 baseband，因此 SS-PLL 中的 SSPD/SSCP 模块噪声并不会被放大。






## 3. Summary of SS-PLL vs. CP-PLL

下表给出了 CP-PLL 和 SS-PLL 的主要特性对比：

<span style='font-size:13px'> 
<div class='center'>

| Item | CP-PLL | SS-PLL |
|:-:|:-:|:-:|
 | core structure | FD + PFD | SSPD (without FD) |
 | locking range | wide | narrow <br> (needs assist like FLL) |
 | in-band noise of PD/CP | relatively high <br> (typ. 10% ~ 40%) | very low <br> (typ. < 1%) |
 | open-loop gain $H_{OL}(s)$ | $K_d \cdot Z_{LF}(s) \cdot \frac{K_{VCO}}{s}$ | $N \times K_{d,SS} \cdot Z_{LF}(s) \cdot \frac{K_{VCO}}{s}$ |
 | core-loop gain $A(s)$ | $A(s) = H_{OL}(s) = K_d \cdot Z_{LF}(s) \cdot \frac{K_{VCO}}{s}$ | $A(s) = \frac{H_{OL}(s)}{N} = K_{d,SS} \cdot Z_{LF}(s) \cdot \frac{K_{VCO}}{s}$ | 
 | feedback coefficient $F$ | $\frac{1}{N}$ | 1 |
 | closed-loop gain $H_{CL}(s)$ | $\frac{A(s)}{1 + \frac{1}{N}\times A(s)} = \frac{N\times H_{OL}(s)}{N + H_{OL}(s)}$ | $\frac{N \times A(s)}{1 + 1\times A(s)} = \frac{N \times H_{OL}(s)}{N + H_{OL}(s)}$ |
 | PD/CP gain $K_d$ | $\frac{I_P}{2 \pi}$ | $D \times 2 g_m A_{VCO}$ |
 | <span style='color:red'> CP noise transfer $H_{CP}(s)$ </span> | $\frac{N}{K_d} \times \frac{H_{OL}}{N + H_{OL}}$ | $\frac{1}{K_{d,SS}} \times \frac{H_{OL}}{N + H_{OL}}$ |
 | CP in-band noise transfer $H_{CP}(s)_{\mathrm{low\ freq.}}$ | $\frac{N}{K_d} = \frac{N \times 2 \pi}{I_P}$ | $\frac{1}{K_{d,SS}} = \frac{1}{D \times 2 g_m A_{VCO}}$ |
 | CP in-band phase noise $L_{CP}(f_m)_{\mathrm{low\ freq.}}$ | $D N^2 \times \frac{16 \pi^2 g_m \gamma k T}{I_P^2}$ | $\frac{1}{2} \times \frac{\gamma k T}{g_m D A_{VCO}^2}$ |
 | typ. CP in-band noise (dBc/Hz) | -100 to -130 dBc/Hz | -130 to -150 dBc/Hz <br> (improvement of - 20 dBc/Hz) |
 | <span style='color:red'> PD noise transfer $H_{PD}(s)$ </span> | $N \times \frac{H_{OL}}{N + H_{OL}}$ | $\frac{H_{OL}}{N + H_{OL}}$ |
 | PD in-band noise transfer $H_{PD}(s)_{\mathrm{low\ freq.}}$ | $N$ | $1$ |
 | PD in-band phase noise $L_{PD}(f_m)_{\mathrm{low\ freq.}}$ | - | $\frac{1}{2} \times \frac{k T}{f_{ref} C_{sam} A_{VCO}^2}$ | 
 | typ. PD in-band noise (dBc/Hz) | -100 to -120 dBc/Hz | -120 to -140 dBc/Hz <br> (improvement of - 20 dBc/Hz) |

</div>
</span>



## 4. Design Considerations

下面是实际设计 SS-PLL 时需要考虑的一些地方：
- (1) 相位误差较小时，SSPD + GM 模块的 (平均) 输出电流与输入相位差呈近似线性关系， **可视为 VCO 波形的缩放复制** ，因此 VCO 输出波形失真度会直接影响相位检测的线性度，这也是 SS-PLL 通常采用 LC-VCO 的原因之一。
- 由于 SSPD 无法区分频率误差，对任何参考频率的整数倍 N·f_ref ，SSPD 表现完全相同，存在频率模糊问题，因此必须增加辅助的频率锁定环路 (FLL)，或者采用 Dual-Path PLL 结构 (增加传统的 FD + PFD 路径)
- SSPD 采样开关会对 VCO 输出端引入负载扰动，导致 VCO 输出出现 BFSK (binary frequency shift keying) 现象，从而引入参考杂散 (reference spurs)，需要通过设计加以抑制，例如引入 VCO buffer 和 dummy sampler 等。


## 5. Improvements of SS-PLL

- SSPD: 线性范围窄，仅在小相位误差下有效；大误差时出现周期滑动
    - [4] 辅助锁定：引入 DZPD (dead-zone PD)，在频率未锁定时提供二进制频率锁定特性
- SSCP (GM): 用开环 OTA 结构替代传统 Charge Pump，实现高线性度的同时避免了开关 charging 影响，还具有以下优点：
    - 失配免疫：OTA 输入失配电压只映射为固定的相位偏移，且因失配通常不高于 mV-level, 对环路动态特性几乎无影响
    - 无需复杂的高摆幅、低失配 CP，降低设计难度
    - 可以优化 GM 噪声性能以充分利用 SS-PLL 的低噪声优势
- LPF: 模拟 LF 占用大面积，尤其数十 pF 的电容难以缩小
    - [4] 将积分路径 (积分电容) 移入数字域，例如 SSPD → **比较器 → 数字滤波器 → DAC** → VCO, 同时比例路径保留模拟电阻，保证稳定性
    - 进一步地，可以加入数字 Bang-Bang FLL 作为 VCO 的 coarse control (或者 CP 前的第二路径), 快速将频率拉入 SSPD 捕获范围
- VCO 输出采样：直接采样 VCO 会引入 LC 谐振腔负载泄漏，引发 BFSK (binary frequency shift keying) 并导致参考杂散
    - [4] 缓冲隔离：在 VCO 输出端增加时钟缓冲器，隔离采样开关的直接负载
- Fractional-N: Integer-N SS-PLL 无法满足现代通信的精细频率步进需求，通常会引入 fractional-N 技术，例如 $\Sigma$-$\Delta$ 调制分频器等
- 自适应增益：动态调整 $g_m$ 跨导和 $D$ 导通占空比，在频率捕获阶段提高增益，快速锁定后适当降低以优化噪声 (明明增大才能降低 CP in-band noise, 如何理解降低后能优化噪声这件事？)


## 6. Further Reading

参考文献 [[4]](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-36.pdf) 是一篇 SS-PLL based SerDes 的学位论文，里面对 SS-PLL 的各个模块都有比较细节的讨论，并且给出了挺多改进方案，感兴趣的读者可以自行查阅：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-24-18-52-15_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>


与 [[1]](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-36.pdf) 类似，参考文献 [[5]](https://www.research-collection.ethz.ch/entities/publication/5165a118-9ef5-4eb9-a292-8a3245360722) 是一本以时钟生成为核心的书籍，其中 page.31 ~ page.57 对比了 CP-PLL, SS-PLL 和 D-PLL (digital PLL) 三种架构的噪声特性，对 SS-PLL 噪声推导过程有疑惑的话也可以看看。

如果想练手/复现一下 SS-PLL 的设计，除了开山论文 [[2]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5342373) JSSC'09 和后续工作 [[3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5560323) VLSIC'10 外，我们再推荐几篇比较基础的论文：
- [[6]](https://ieeexplore.ieee.org/document/9651530/) TVLSI'21
    - 架构：经典 Dual-Path SS-PLL 架构，也即 SS-Loop + CP-Loop (FLL)
    - 亮点：对比了五种不同 SSPD 结构对 LC-VCO 谐振腔负载扰动的影响，给出了 REF-spur 的详细理论公式 (论文采用 REF-spur 最好的第五种)
    - 其它：给出了环路滤波器的详细参数，以及 FLL 是否成功达到预期频率的判定方法 (电路)，在 `FLL_EN = 0` 时关闭 `CP-Path` 进入纯 SS-PLL 模式
- [[7]](https://hdl.handle.net/10356/170916) TMTT'23
    - 架构：经典 Dual-Path SS-PLL 架构，也即 SS-Loop + CP-Loop (FLL)
    - 亮点：在经典架构的基础上，额外增加了一条 "HPF + SSCP" 路径 (与原 SSCP 并联) 用于抑制 VCO 相位噪声，rms jitter 从 3.52 ps 降低到 2.63 ps (还行吧)
    - 其它：无


## Reference

- [[1]](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-36.pdf) Woogeun Rhee, Phase-Locked Frequency Generation and Clocking: Architectures and circuits for modern wireless and wireline systems. The Institution of Engineering and Technology, 2020. Accessed: Dec. 08, 2025. [Online]. Available: https://digital-library.theiet.org/doi/book/10.1049/pbcs064e
- [[2]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5342373) X. Gao, E. A. M. Klumperink, M. Bohsali, and B. Nauta, “A Low Noise Sub-Sampling PLL in Which Divider Noise is Eliminated and PD/CP Noise is Not Multiplied by $N^{2}$,” IEEE J. Solid-State Circuits, vol. 44, no. 12, pp. 3253–3263, Dec. 2009, doi: 10.1109/JSSC.2009.2032723.
- [[3]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5560323) X. Gao, E. Klumperink, G. Socci, M. Bohsali, and B. Nauta, “A 2.2GHz sub-sampling PLL with 0.16psrms jitter and −125dBc/Hz in-band phase noise at 700µW loop-components power,” in 2010 Symposium on VLSI Circuits, June 2010, pp. 139–140. doi: 10.1109/VLSIC.2010.5560323.
- [[4]](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-36.pdf) Z. Wang, “Analog Generators for SerDes Clock Generation and Distribution,” UC Berkeley, 2021. Accessed: Dec. 24, 2025. [Online]. Available: https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-36.pdf
- [[5]](https://www.research-collection.ethz.ch/entities/publication/5165a118-9ef5-4eb9-a292-8a3245360722) L. Wu, “Design of Power-Efficient High-Purity Phase-locked Frequency Synthesis,” ETH Zurich, 2020, p. 190 p. doi: 10.3929/ETHZ-B-000454612.
- [[6]](https://ieeexplore.ieee.org/document/9651530/) Z. Yang, Y. Chen, J. Yuan, P.-I. Mak, and R. P. Martins, “A 3.3-GHz Integer N-Type-II Sub-Sampling PLL Using a BFSK-Suppressed Push–Pull SS-PD and a Fast-Locking FLL Achieving −82.2-dBc REF Spur and −255-dB FOM,” IEEE Transactions on Very Large Scale Integration (VLSI) Systems, vol. 30, no. 2, pp. 238–242, Feb. 2022, doi: 10.1109/TVLSI.2021.3131219.
- [[7]](https://hdl.handle.net/10356/170916) Y. Dong, C. C. Boon, Z. Liu, and K. Yang, “A dual-path subsampling PLL with ring VCO phase noise suppression,” IEEE Transactions on Microwave Theory and Techniques, vol. 72, no. 1, pp. 138–148, 2023, doi: 10.1109/TMTT.2023.3284279.

