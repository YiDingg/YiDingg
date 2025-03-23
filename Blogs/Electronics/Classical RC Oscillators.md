# Classical RC Oscillators: Wien-Bridge, T-Bridge and Twin-T Oscillators

> [!Note|style:callout|label:Infor]
> Initially published at 14:23 on 2025-03-21 in Beijing.

## Intro

本文，我们介绍三种经典的 RC 振荡器： Wien-Bridge Oscillator (文氏振荡器)， T-Bridge Oscillator (T 桥振荡器) 和 Twin-T Oscillator (双 T 桥振荡器)。其中，文氏振荡器是以 band-pass filter 作为放大器的输入回路产生振荡，而 T 桥和双 T 桥振荡器则是以 band-stop filter 作为放大器的反馈回路产生振荡。



## Wien-Bridge Oscillator

我们之前对 Wien-Bridge Oscillator 作过比较详细的分析和仿真验证，内容如下：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-14-58-13_Classical RC Oscillators.png"/></div>
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-14-58-24_Classical RC Oscillators.png"/></div>
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-14-59-04_Classical RC Oscillators.png"/></div>

关于如何利用 band-pass network 来构建振荡器，可以参考下面这篇文章：
- Kushwaha, A.K., Kumar, A. [Sinusoidal Oscillator Realization Using Band-Pass Filter](https://rdcu.be/eeBAB)  J. Inst. Eng. India Ser. B 100, 499–508 (2019). https://doi.org/10.1007/s40031-019-00408-w 

## T-Bridge Network (1)

事实上， T-Bridge Network 有两种“对称”的结构，如下图所示，

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-15-14-06_Classical RC Oscillators.png"/></div>

我们指出，两种结构所实现的效果是类似的（都是带阻滤波器），且滤波质量差别不大。这一小节，我们先讨论第一种结构，第二种结构的讨论可以参考 [A Note on a Bridged-T Network](https://tf.nist.gov/general/pdf/2526.pdf) ，文章对其进行了很详细的分析。


为提高普适性，我们将电路结构抽象为下图：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-16-23-59_Classical RC Oscillators.png"/></div>

其中 $Y_1,\ Y_2, Y_3,\ Y_4$ 是对应元件的 **导纳 (注意是 admittance, 而不是 impedance 阻抗)** ，则有：

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-16-24-15_Classical RC Oscillators.png"/></div>

也就是：

$$
\begin{gather}
H(s) = \frac{1}{1 + \frac{Y_3}{Y_0}},\ \mathrm{where\ } Y_0 = Y_1 + Y_2  + \frac{Y_1 Y_2 + Y_2 Y_3}{Y_4}
\end{gather}
$$

在第一种 T-bridge 结构中， 我们有：

$$
\begin{gather}
\begin{cases}
Y_1 = \frac{1}{R}\\
Y_2 = j \omega \frac{C}{\alpha}\\
Y_3 = j \omega \alpha C\\
Y_4 = \frac{1}{R}
\end{cases}
\Longrightarrow 
H(j \omega) = \frac{1}{1 + \frac{j \omega \alpha C}{\frac{1}{R} - \omega^2 R C^2 + j \omega\frac{2 C}{\alpha}}} = \frac{-\alpha \,C^2 \,R^2 \,\omega^2 +2\,C\,R\,\omega \,\mathrm{i}+\alpha }{-C^2 \,R^2 \,\alpha \,\omega^2 +C\,R\,\alpha^2 \,\omega \,\mathrm{i}+2\,C\,R\,\omega \,\mathrm{i}+\alpha }
\end{gather}
$$


不同的 $\alpha$ 导致不同的传递函数，相应的带通效果也不同。我们取 $R = 10 \ \mathrm{k\Omega},\ C = 10 \ \mathrm{nF}$, 理论计算结果 (用 MATLAB 作图) 和 LTspice 仿真结果如下：

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-16-37-19_Classical RC Oscillators.png"/></div>
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-15-46-17_Classical RC Oscillators.png"/></div>




## T-Bridge Network (2)

上文提到了第二种 T-Bridge 结构，其在实际电路中更实用，因为相比可变电容，可变电阻的价格显然更加便宜。

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-16-38-55_Classical RC Oscillators.png"/></div>

还是利用下面的公式进行计算，其中 $Y_1 = Y_4 = j \omega C,\ Y_2 = \frac{1}{\alpha R},\ Y_3 = \frac{\alpha}{R}$: 

$$
\begin{gather}
H(s) = \frac{1}{1 + \frac{Y_3}{Y_0}},\ \mathrm{where\ } Y_0 = Y_1 + Y_2  + \frac{Y_1 Y_2 + Y_2 Y_3}{Y_4}
\end{gather}
$$

可以得到：  

$$
\begin{gather}
H(j \omega) = \frac{1}{\frac{\alpha }{R\,{\left(C\,\omega \,\mathrm{i}+\frac{2}{R\,\alpha }-\frac{\mathrm{i}}{C\,R^2 \,\omega }\right)}}+1} = \frac{\mathrm{i}\,\alpha \,C^2 \,R^2 \,\omega^2 +2\,C\,R\,\omega -\alpha \,\mathrm{i}}{C^2 \,R^2 \,\alpha \,\omega^2 \,\mathrm{i}+C\,R\,\alpha^2 \,\omega +2\,C\,R\,\omega -\alpha \,\mathrm{i}}
\end{gather}
$$

上下同乘 $i$, 得到与 T-Bridge Network (1) 完全相同的传递函数：
$$
\begin{gather}
H(j \omega) = \frac{-\alpha \,C^2 \,R^2 \,\omega^2 +2\,C\,R\,\omega \,\mathrm{i}+\alpha }{-C^2 \,R^2 \,\alpha \,\omega^2 +C\,R\,\alpha^2 \,\omega \,\mathrm{i}+2\,C\,R\,\omega \,\mathrm{i}+\alpha }
\end{gather}
$$

因此其波特图也完全相同：

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-16-41-32_Classical RC Oscillators.png"/></div>


## T-Bridge Oscillator

Wien-Bridge 和 T-Bridge 两种结构，前者是带通，后者是带阻，因此放大器的连接方法有所不同。以 T-Bridge Network (1) 为例，其连接方式如下：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-15-02-18_Classical RC Oscillators.png"/></div>

$\alpha$ 取值不同时 $\alpha$, 带阻网络的“质量”也不同。在一定范围内，$\alpha$ 越大，电路越容易起振。 LTspice 仿真结果如下：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-22-47-14_Classical RC Oscillators.png"/></div>

可以看到，在取正反馈电阻为 $10 \ \mathrm{k\Omega}$ 时（ noninverting 端电源等效输入电阻为 $5 \ \mathrm{k\Omega}$），$\alpha = 1,\ 2$ 的电路无法起振，而 $\alpha = 5$ 的电路可以起振。

在进一步的仿真验证中，我们采用 $\alpha = 10$ 的 T-bridge (2) 型网络。理论振荡频率为：
$$
\begin{gather}
f = \frac{1}{2 \pi R C} = \frac{1}{2 \pi \times 10 \ \mathrm{k\Omega} \times 10 \ \mathrm{nF}} = 1.5915 \ \mathrm{kHz}
\end{gather}
$$



$R_F = 100 \ \mathrm{k\Omega}$ 的仿真结果如下：
<!-- <div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-22-58-14_Classical RC Oscillators.png"/></div> -->
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-23-02-30_Classical RC Oscillators.png"/></div>

$R_F = 200 \ \mathrm{k\Omega}$ 的仿真结果如下：
<!-- <div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-23-01-12_Classical RC Oscillators.png"/></div> -->
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-23-01-45_Classical RC Oscillators.png"/></div>

常见的 Amplitude adjustment circuit 的原理是，当振荡器输出摆幅大于二极管阈值电压时，向电路中并联进一个元件（通常是电阻）。在这个电路中，我们该如何添加此电路，从而在不改变振荡频率的情况下进行限幅？

由于 T-bridge 是通过减少 $f_c$ 的负反馈，增加其它频率的负反馈来产生振荡。因此，我们只需将 amplitude adjustment circuit 并联在在运放的 inverting 端和 output 端，即可（在起振后）增加对 $f_c$ 的负反馈，从而达到限幅的目的。仿真结果如下：
<!-- <div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-23-11-46_Classical RC Oscillators.png"/></div> -->
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-23-13-38_Classical RC Oscillators.png"/></div>

可以看到，在有输出限幅的情况下，输出频谱变得相当干净 (但是振荡频率稍有误差)。限幅电阻 $R_{a}$ (图中的 $R_{26}$) 越大，输出幅度就越大。

不同 $R_a$ 时的振荡频率和输出摆幅如下：
<div class='center'>

| $R_a$ | 1k | 10k | 100k | 200k | 300k |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | $f_c$ | 1.738 KHz | 1.738 KHz | 1.760 KHz | 1.760 KHz | 1.760 KHz |
 | $V_{pp}$ | 1.05 V | 1.10 V | 1.55 V | 2.45 V | 5.25 V |
</div>

## Band-stop Network

将低通和高通滤波器并联处理，可以得到一个带阻滤波器，我们参考 [Band Stop Filter Basics, Diagram, Examples](https://www.electronicshub.org/band-stop-filter/) ，给出一些主要原理。

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-17-12-26_Classical RC Oscillators.png"/></div>


<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-23-31-31_Classical RC Oscillators.png"/></div>

即中心频率和带宽分别为（有待考证）：
$$
\begin{gather}
f_c = \sqrt{f_{c1}f_{c2}},\ \mathrm{BW} = f_{c2} - f_{c1}
\end{gather}
$$

## Twin-T Network

在众多的 Band-stop Network 中， Twin-T Network 是十分特殊的一种，因为它在中心频率 $f_c$ 处提供了**无穷大**的抑制能力，更像是一个“点阻”滤波器，或称为 notch filter (窄阻带滤波器)。其电路图如下：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-14-32-00_双 T 桥振荡器.png"/></div>

对 $RC$ 低通网络，我们有：

$$
\begin{gather}
f_{c1} = \frac{1}{2 \pi} \sqrt{\frac{\frac{1}{C} + \frac{1}{C}}{2C R^2}} = \frac{1}{2 \pi R C}
\end{gather}
$$

对于 $RC$ 高通网络，我们也有：
$$
\begin{gather}
f_{c2} = \frac{1}{2 \pi} \sqrt{\frac{1}{C^2 \frac{R}{2} (R + R)}} = \frac{1}{2 \pi R C}
\end{gather}
$$

调整两网络的底部元件数值后， $f_{c1} = \frac{1}{2 \pi (\frac{1}{2} R) C},\ f_{c2} = \frac{1}{2 \pi R (2C)}$。然后将两网络并联，可以得到 Twin-T Bridge 的中心频率：
$$
\begin{gather}
f_{c} = \sqrt{f_{c1} f_{c2}} = \frac{1}{2 \pi R C}
\end{gather}
$$

之所以要调整为 $\frac{R}{2}$ 和 $2 C$, 是因为这样能将传递函数从 3 阶降为 2 阶，同时对 $f_c$ 有无穷大的抑制能力，使得 twin-T network 成为一个 ideal notch band-stop filter (不考虑 tolerance 的情况下)。通过推导传递函数，可以看出这一点，具体过程见 [A Mistake on Twin-T Network Calculation](<Blogs/Electronics/A Mistake on Twin-T Network Calculation.md>)。我们这里直接给出结论：

$$
\begin{gather}
H(j\omega) = \frac{\omega^2 R^2 C^2 - 1}{\omega^2 R^2 C^2 - 1 - 4 j \omega C R}
\Longleftrightarrow 
H(s) = \frac{s^2 R^2 C^2 + 1}{s^2 R^2 C^2 + 1 + 4 s R C}
\\
\omega_c = \frac{1}{RC},\quad  f_c = \frac{1}{2\pi R C}
\end{gather}
$$



<!-- 
双 T 振荡器产生频率为 $f_c = \frac{1}{2 \pi RC}$ 的正弦波，但是 $f_c$ 处的传递函数（幅值）不能达到 0 dB 。因此，要想实现自激振荡，还需要外围的放大电路。下面是一个应用实例：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-14-35-11_双 T 桥振荡器.png"/></div>


<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-23-27-05_Classical RC Oscillators.png"/></div>

 -->
## Twin-T Oscillator


LTspice 仿真结果如下：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-22-22-17_Classical RC Oscillators.png"/></div>

通过改变 $R_9$ (或 $R_{10}$) 的值，可以调整输出的幅度。通常调整正反馈回路的 $R_9$ 更好，因为这样（理论上）不会对输出频率产生任何影响。

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-22-26-18_Classical RC Oscillators.png"/></div>

作为一个经验定律， $R_9$ 的值在 $R_S$ (信号源等效输出电阻, 在这里是 5 kOhm) 的 100 倍以上，且基本不超过 500 倍，我们在上述仿真中选择的是 500 倍。同时，可以注意到， noninverting 端信号源的输出电压就是输出正弦波的偏置电压。

## Reference

- [Electronics-Tutorials: Twin-T Oscillator](https://www.electronics-tutorials.ws/oscillator/twin-t-oscillator.html)
- [Twin-T oscillator](http://www.discovercircuits.com/Andy/Twin-Toscillator.pdf)
- [A Note on a Bridged-T Network](https://tf.nist.gov/general/pdf/2526.pdf)
- [Classical R-C Oscillators: The Bridged-T Network and the Wien Oscillator Network](https://www.allaboutcircuits.com/technical-articles/classical-r-c-oscillator-bridged-t-network-wien-oscillator-network/)
- [Band Stop Filter Basics, Diagram, Examples](https://www.electronicshub.org/band-stop-filter/)
- [Kushwaha, A.K., Kumar, A. Sinusoidal Oscillator Realization Using Band-Pass Filter  J. Inst. Eng. India Ser. B 100, 499–508 (2019). https://doi.org/10.1007/s40031-019-00408-w](https://rdcu.be/eeBAB)
- [Twin-T RC Oscillators](https://electronicspedia.com/Topics/analog_electronics/sinusoidal_oscillators/twin-t_rc_oscillators.html)
- [Realization of Nonminimum Phase Transfer Functions Using Twin-T RC Networks](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1083308)
- [Twin-T Notch Filter Design Tool](http://sim.okawa-denshi.jp/en/TwinTCRkeisan.html)
- [实验二 单双T网络频率特性](https://max.book118.com/html/2019/0801/7115051026002044.shtm)
- [双T型陷波滤波器](https://blog.csdn.net/weixin_34405557/article/details/85574624)
