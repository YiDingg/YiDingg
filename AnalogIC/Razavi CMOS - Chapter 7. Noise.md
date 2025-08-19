# Razavi CMOS - Chapter 7. Noise

> [!Note|style:callout|label:Infor]
> Initially published at 15:34 on 2025-06-22 in Beijing.

参考教材：[*Design of Analog CMOS Integrated Circuits (Behzad Razavi) (2nd edition, 2017)*](https://www.zhihu.com/question/452068235/answer/95164892409)


## Introduction

噪声限制了电路能够以可接受的质量处理的最小信号幅度。当今的模拟设计人员常常不得不噪声问题，因为它与功耗、速度和线性度相互制约。在本章，我们将对噪声现象进行建模，并探讨噪声对模拟电路的影响。在对噪声在频率域和时间域的特性进行一般性描述之后，我们将介绍热噪声和闪烁噪声。接下来，我们考虑在电路中表示噪声的方法（等效噪声源）。最后，我们将描述噪声在单级放大器和差分放大器中的影响，以及与其他性能参数之间的权衡。


## 1. Statistical Chara.

### 1.1 Definitions of Noise

噪声是一种 "任何时刻"，这意味我们无法预测未来任何时刻噪声的值——它的值永远是随机的。


如果无法预测时域中噪声的瞬时值，那么我们又该如何在电路分析中考虑噪声呢？这可以通过长时间观察噪声，并利用所测结果构建一个“统计模型”来实现。尽管噪声的瞬时振幅无法预测，但统计模型却能提供有关噪声的一些其他重要特性的信息，这些特性在电路分析中是很有用且足够的。

那么，噪声的哪些特性是可以预测的呢？在很多情况下，噪声的平均功率是可以预测的。读者可能会问，是否存在一种随机过程 "太过随机"，以至于其平均功率都无法预测？确实存在这样的过程，但很幸运的是，电路中的大多数噪声源都具有恒定的平均功率。

噪声平均功率的定义如下：

$$
\begin{gather}
P_{av} := \lim_{T \to \infty} \frac{1}{T}\int_0^T v_{noise}^2(t) dt,\quad \mathrm{(unit:\ V^2)}
\end{gather}
$$

与确定性信号类似，我们也可以为噪声定义一个均方根电压 (RMS noise), 其值为：

$$
\begin{gather}
V_{noise,\ RMS} :=  \sqrt{P_{av}} = \sqrt{\lim_{T \to \infty} \frac{1}{T}\int_0^T v_{noise}^2(t) dt},\quad \mathrm{(unit:\ V)}
\end{gather}
$$

至于为什么这里是 RMS 而不是 amplitude, 是因为它要与噪声功率相对应。举个例子，如果一个电压 $v(t)$ 加在了电阻 $R$ 上，那么它产生的平均功率为 $P_{av} = \frac{V_{RMS}^2}{R_L}$，如果令 $R_L = 1$，那么 $\sqrt{P_{av}}$ 所得的值就是 $V_{RMS}$。


有时，为了强调所得到的 $V_{RMS}$ 是 RMS 而不是 amplitude, 我们可以把它的单位写作 $\mathrm{V_{RMS}}$ 而不是 $\mathrm{V}$.

## 2. Types of Noise



### 1.2 Noise Spectrum

如果将平均功率的概念与噪声的频率成分相结合来定义，那么它就会变得更加灵活。一组男性发出的噪声包含的高频成分比一组女性发出的噪声要弱，这种差异可以从每种类型的噪声的“频谱”中观察到。这种频谱也被称为 "power spectral density" (PSD, 功率谱密度)，记作 $S_x = S_x(f)$，它展示了噪声信号 $x(t)$ 在每个频率上所携带的功率大小。由帕塞瓦尔定理可推出 $S_x(f)$ 满足公式：

$$
\begin{gather}
P_{av} = \int_0^{\inf} S(f) \ \mathrm{d}f
\end{gather}
$$

**Theorem:** If a signal with power spectrum $S_x(f)$ is applied to a LTI (linear time-invariant) system with transfer function $H(s)$, then the output power spectrum is given by:

$$
\begin{gather}
S_y(f) = |H(j 2\pi f)|^2\, S_x(f)
\end{gather}
$$

### 1.3 Amplitude Distribution

如前所述，噪声的瞬时振幅通常是不可预测的。然而，通过长时间观察噪声波形，我们可以构建出振幅的“分布”，表明每个值出现的频率。这种分布也被称为 "probability density function" (PDF, 概率密度)。下图是概率密度估计的一个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-16-01-08_An Introduction to Noise.png"/></div>

概率密度函数的一个重要例子就是高斯（即正态）分布。中心极限定理指出，如果将许多具有任意概率密度函数的独立随机过程相加，那么这些过程的总和的概率密度函数将趋近于高斯分布。因此，许多自然现象表现出高斯统计特性也就不足为奇了。例如，由于电阻的噪声是由大量电子的随机“移动”产生的，而每个电子的统计特性又相对独立，所以噪声的总体振幅遵循高斯概率密度函数。在本书中，我们对噪声的频谱和平均功率的使用远多于振幅分布。不过，为了完整性起见，我们还要指出，高斯概率密度函数的定义为：

$$
\begin{gather}
p(x) = \frac{1}{\sigma \sqrt{2\pi}} \exp \left( - \frac{(x - \mu)^2}{2 \sigma^2} \right)
\end{gather}
$$

### 1.4 Multiple Noise Sources

如果一个线性电路中存在多个噪声源，从时域上来看，我们可以用叠加定理 (superposition principle) 直接求出叠加后的效果。但大多数时候，我们关心的是叠加后的平均噪声功率，这便不能将各个噪声功率简单相加了，必须引入 "相关性 (correlation)" 的概念：

$$
\begin{align}
P_{av,total} 
&= \lim_{T \to \infty} \frac{1}{T}\int_0^T [x_1(t) + x_2(t)]^2 dt
\\
&=\lim_{T \to \infty} \frac{1}{T}\int_0^T x_1(t)^2 dt + \lim_{T \to \infty} \frac{1}{T}\int_0^T x_2(t)^2 dt + \color{red}{ 2\times \lim_{T \to \infty} \frac{1}{T}\int_0^T x_1(t) x_2(t) dt }
\\
&=P_{av,1} + P_{av,2} + \color{red}{ 2\times \lim_{T \to \infty} \frac{1}{T}\int_0^T x_1(t) x_2(t) dt }
\end{align}
$$

上式第三项表明了这两个波形的“相似度”程度。如果是由独立的设备生成的，噪声波形通常是“不相关的”，使式中的第三项积分为零。这时，功率上的 "叠加" 便是成立的。在本书，除非特别说明，我们都默认各噪声源之间完全独立，因此功率也满足 "叠加定理"。"功率的叠加" 可以等价地描述为 "功率谱的叠加"：

$$
\begin{gather}
S(f) = S_1(f) + S_2(f) \Longleftrightarrow 
P_{av} =  P_{av,1} + P_{av,2}
\end{gather}
$$



### 1.5 Signal-to-Noise Ratio

假设一个放大器接收到正弦信号，其输出包含放大后的信号以及电路产生的噪声，我们定义此放大电路的 "Signal-to-Noise Ratio" (SNR, 信噪比) 为：

$$
\begin{gather}
\mathrm{SNR}(t) := \frac{P_{sig}(t)}{P_{noise}(t)},\quad 
\mathrm{SNR_{av}} := \frac{P_{sig,av}}{P_{noise,av}}
\end{gather}
$$

需要注意的是，由于 $P_{noise,av} = \int_0^{\inf} S_x(f) \ \mathrm{d}f$, 所以电路的带宽必须始终被限制在可接受的最小值以内，以最大程度降低噪声功率，带宽可以通过放大器内部的处理或者通过后续放置的低通滤波器来降低。

### 1.6 Analysis Procedure

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-18-12-23_An Introduction to Noise.png"/></div>

## 2. Types of Noise

由集成电路处理的模拟信号会受到两种不同类型的噪声的干扰：器件电子噪声和“环境”噪声。后者指的是（看似）随机的干扰，这些干扰是电路通过电源线、接地线或基板所经历的。本文我们重点讨论前者——器件电子噪声。

### 2.1 Thermal Noise

下面，我们从 thermal noise 功率谱 $S(f)$ 的形式可以看出, thermal noise 显然是一种 “白噪声 (white noise)”，白噪声的特点是其功率谱密度 $S(f)$ 在所有频率上都是恒定的。


#### Resistor Thermal Noise

$$
\begin{gather}
S_v(f) = (4 k T R) u(f),\quad \mathrm{or\ equivalently:}\quad 
S_v(f) = 4 k T R,\ \ f \ge 0
\end{gather}
$$


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-16-35-39_An Introduction to Noise.png"/></div>

我们也可以将其等效为 "电流噪声"：

$$
\begin{gather}
S_i(f) = \overline{I_n^2} = \frac{\overline{V_n^2}}{R^2} = \frac{4 k T}{R} u(f),\quad \mathrm{or\ equivalently:}\quad
S_i(f) = \overline{I_n^2} = \frac{4 k T}{R},\ \ f \ge 0
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-16-39-19_An Introduction to Noise.png"/></div>

#### MOSFET Thermal Noise

MOS 晶体管也会产生热噪声。最主要的噪声来源是沟道中产生的噪声。可以证明，对于工作在**饱和状态**下的 MOS 器件，沟道噪声可以用一个连接在 drain 和 source 之间的电流源来表示，其频谱密度为：

$$
\begin{gather}
\mathrm{in\ saturation:\ }
\overline{I_n^2} = 4 k T \gamma\, g_{ds},\quad g_{ds} = \left(\frac{\mathrm{d} I_D }{\mathrm{d} V_{DS} }\right)_{V_{DS} = 0} = \frac{1}{R_{ON}}
\end{gather}
$$

对长沟道器件来讲 (平方律器件)，我们有 $g_{ds} = \mu_n C_{ox} \frac{W}{L} (V_{GS} - V_{TH}) = \sqrt{2 \mu_n C_{ox} \frac{W}{L} I_D} = g_m$. 因此上式也常常写作：

$$
\begin{gather}
\overline{I_n^2} = 4 k T \gamma_{noise}\, g_m
\end{gather}
$$

上式的系数 $\gamma_{noise}$ (切勿与 body-effect 的系数 $\gamma$ 混淆！)，对于长沟道晶体管而言有 $\gamma_{noise} = \frac{2}{3}$，而对于亚微米级的 MOSFET 则可能需要替换为更大的值，并且其值还会随 $V_{DS}$ 电压的变化而有所变化。作为一个经验定律，我们一般都取近似：

$$
\begin{gather}
\gamma_{noise} \approx 1
\end{gather}
$$



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-16-49-20_An Introduction to Noise.png"/></div>



更详细的理论分析可以见论文 [High-Frequency Noise Measurements on FETs with Small Dimensions](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1485960), 全引是：
>A. A. Abidi, "High-frequency noise measurements on FET's with small dimensions," in IEEE Transactions on Electron Devices, vol. 33, no. 11, pp. 1801-1805, Nov. 1986, doi: 10.1109/T-ED.1986.22743.

下面是一个具体的例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-16-57-03_An Introduction to Noise.png"/></div>

#### MOSFET Ohmic Noise

由于 MOSFET 栅极、源极和漏极材料都具有一定的电阻率，各区的等效电阻也会产生热噪声。对于相对较宽的晶体管而言, drain 和 source 的电阻通常可以忽略不计，而栅极的分布电阻可能导致比较显著的等效噪声。

$$
\begin{gather}
R_1 = \frac{R_G}{3} \Longrightarrow \overline{V_{n,R_G}^2} = \frac{4 k T R_G}{3}
\end{gather}
$$

**In general, if the gate is decomposed into N parallel fingers, the distributed resistance falls by a factor of $N^2$.**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-16-57-49_An Introduction to Noise.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-16-59-21_An Introduction to Noise.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-17-03-24_An Introduction to Noise.png"/></div>

### 2.2 Flicker Noise

在 MOSFET 中，栅极氧化层 (SiO$_2$) 与硅衬底之间的界面存在一种有趣的现象：由于硅晶体在该界面处达到边界，会出现许多“悬空”键合，从而产生额外的能量状态。当电荷载流子在该界面处移动时，有些会随机被捕获，随后由这些能量状态释放出来，从而在漏电流中引入“闪烁”噪声。除了捕获之外，还有其他几种机制被认为会生成闪烁噪声，这超出了本课的内容，我们不多赘述。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-17-05-45_An Introduction to Noise.png"/></div>

与热噪声不同，闪烁噪声的平均功率难以准确预测。其数值会因氧化硅与硅界面的“清洁度”不同而有很大差异，因此在不同的 CMOS 技术中闪烁噪声的数值也会有所变化。闪烁噪声更易于被建模为与栅极串联的电压源，在饱和区其数值大致为：

$$
\begin{gather}
\overline{V_n^2} = \frac{K}{C_{ox} WL}\cdot \frac{1}{f}
\end{gather}
$$

其中 $K$ 是与工艺相关的常数，其数量级约为 $10^{-25} \mathrm{V^2\cdot F\cdot Hz}$。一般来说, PMOS 器件的 1/f 噪声比 NMOS 晶体管要小，这是因为前者中的载流子是在“埋入型通道”中移动的，即在与硅-氧化层界面有一定距离的位置，因此其对载流子的捕获和释放作用较小。



下面是一个例子：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-17-15-30_An Introduction to Noise.png"/></div>

## 3. Noise in Circuits

### 3.1 Output Noise

考虑一个具有一个输入端口和一个输出端口的通用电路。我们如何量化此处噪声的影响呢？自然的方法是将输入端设置为零，然后计算电路中各种噪声源导致的输出端噪声总值。这正是在实验室或仿真电路中测量噪声的方式。依照我们在 **1.6 Analysis Procedure** 一节中给出的方法，可以很容易求出一个电路的 output noise.



### 3.2 Input-Referred Noise

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-17-35-15_An Introduction to Noise.png"/></div>

但是，只用 input-referred voltage noise source 来作等效会存在一个问题：如果电路具有有限的输入阻抗，当源阻抗变得很大时，输出噪声会消失——这显然是不正确的。为了解决这个问题，我们采用串联电压源和并联电流源的组合来模拟输入端的噪声，这样，如果前一级的输出阻抗很大 (降低了 $\overline{V_{n,in}^2}$ 的影响)，噪声电流源仍会通过有限的阻抗流动，在输入端产生噪声。可以证明，$\overline{V_{n,in}^2}$ 和 $\overline{I_{n,in}^2}$ 是表示任何线性二端口电路噪声的充要条件。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-17-39-48_An Introduction to Noise.png"/></div>

### 3.3 Another Approach


在某些情况下，考虑输出短路噪声电流而非输出开路噪声电压会更为简便。然后，将此电流乘以电路的输出电阻，即可得到输出噪声电压；或者将其除以适当的增益，即可得到输入参考量。下面的例子就使用了这种方法：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-17-43-36_An Introduction to Noise.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-17-43-53_An Introduction to Noise.png"/></div>

## 4. Noise in One-Stage Amp

在分析单级放大器的噪声性能之前，我们先介绍一个定理，它在简化噪声分析时非常有用：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-22-17-46-51_An Introduction to Noise.png"/></div>

### 4.1 Common-Source Stage

对于一个普通的 common-source stage ($R_S = 0$), 我们有等效输入噪声：

$$
\begin{gather}
\overline{V_{n,in}^2} = 4kT \left(\gamma + \frac{1}{g_m R_D}\right)\frac{1}{g_m} + \frac{K}{C_{ox}WL}\cdot \frac{1}{f}
\end{gather}
$$

对于 $R_S \ne 0$ 的情况，只需将 $g_m$ 替换为：

$$
\begin{gather}
g_m \longmapsto G_m = \frac{g_m}{1 + \frac{R_S}{R_{S0}}} \approx \frac{g_m}{1 + g_m R_S}
\\
\Longrightarrow 
\overline{V_{n,in}^2} = 
4kT \left(\gamma + \frac{1 + g_m R_S}{g_m R_D}\right)\left(\frac{1}{g_m} + R_S\right) + \frac{K}{C_{ox}WL}\cdot \frac{1}{f}
\end{gather}
$$


### 4.2 Common-Drain Stage 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-12-26-25_Razavi CMOS - Chapter 7. Noise.png"/></div>

### 4.3 Common-Gate Stage

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-12-25-58_Razavi CMOS - Chapter 7. Noise.png"/></div>

### 4.4 Cascode Stage

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-08-12-26-48_Razavi CMOS - Chapter 7. Noise.png"/></div>


<!-- 
## 5. Noise in Current Mirrors

## 6. Noise in Differential Pairs

## 7. Noise-Power Trade-off

## 8. Noise Bandwidth
 -->
