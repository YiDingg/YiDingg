# Loop Analysis of Typical Type-II CP-PLL

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 21:28 on 2025-10-22 in Beijing.

## 1. Introduction

我们在之前的两篇文章已经较全面地介绍了 PLL 的作用、基本模型与理论基础：
- [Razavi CMOS - Chapter 16. Phase-Locked Loops (16.1 Simple PLL)](<AnalogIC/Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.md>)
- [Razavi CMOS - Chapter 16. Phase-Locked Loops (16.2 CP-PLL ~ 16.5 Applications)](<AnalogIC/Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 CP-PLL ~ 16.5 Applications.md>)

但这两篇文章的重点主要集中在 PLL 的基本模型，对 PLL 环路的理论分析较少，在实际设计中，读者可能很难借助这两篇文章进行深入的环路分析。

本文便是来解决这个问题的：在本文，我们将详细剖析 **Second-Order Type-II CP-PLL** 的环路特性，并延伸到实际设计时最常用的 **Third-Order** Type-II CP-PLL.




## 2. Type-II PLL Model

经典 Type-II PLL 电路和模型如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-21-55-40_Loop Analysis of Typical Type-II CP-PLL.png"/></div>

其中 Second-Order 和 Third-Order 的区别仅仅是 LPF 处是否存在额外的补偿电容 $C_2$ (用于抑制瞬态充放电纹波)。

这里直接给出 Type-II CP-PLL 的关键结论，后文会作详细推导：


$$
\begin{gather}
\mathrm{Second-Order\ (C_2 = 0)}:\ 
\begin{cases}
H_{OL}(s) = \frac{4\zeta^2}{\tau_P^2} \times \frac{1 + s\tau_P}{s^2}
\\
H_{CL}(s) = \frac{4\zeta^2}{\tau_P^2} \times \frac{1 + s\tau_P}{s^2 + \frac{4\zeta^2}{\tau_P} s + \frac{4\zeta^2}{\tau_P^2}}
\\
\zeta = \frac{R_P C_P}{2}\sqrt{\frac{I_PK_{VCO}}{2\pi C_P}},\quad \tau_P = R_P C_P
\\
\mathrm{UGF}_\omega = \frac{2\sqrt{2}\,\zeta}{\tau_P }\left(\sqrt{\zeta^4 +\frac{1}{4}}+\zeta^2 \right)^{\frac{1}{2}} \approx \frac{2\zeta}{\tau_P}\ (\zeta < 0.5)
\\
\mathrm{PM} = \arctan \left(2\,\zeta \left[2\,\zeta^2 +\sqrt{4\,\zeta^4 +1}\right]^{\frac{1}{2}}\right)\ \mathrm{(rad)}
\\
\mathrm{BW}_\omega = \frac{2\zeta}{\tau_P} \left[1 + 2\zeta^2 + \sqrt{4\zeta^4 + 4\zeta^2 + 2}\right]^{\frac{1}{2}} \ \mathrm{(rad/s)}
\\
\mathrm{BW}_f = \mathrm{BW}_\omega/(2\pi)\ \mathrm{(Hz)}
\\
\mathrm{Q\ Factor} = \left[2\zeta^2 + \sqrt{4\zeta^4 + 1}\right]^{\frac{1}{2}}
\\
\mathrm{Damping\ Factor} = \frac{1}{2Q}
\end{cases}
\end{gather}
$$

令 $C_2 = \alpha C_1$, 当 $\alpha \ll 1$ 时 (例如 $\alpha = \frac{1}{10}$)，系统的环路特性与 Second-Order 情况基本相同，只是在开环传递函数引入了一个额外的极点 $p_3$：

$$
\begin{gather}
p_3 = - \frac{1 + \frac{1}{\alpha}}{\tau_P},\quad 
\alpha \ll 1 \Longrightarrow |p_3| \gg |z_1|\ \mathrm{or}\ |p_{1,2}|
\end{gather}
$$

实际设计时，$\alpha$ 取值范围一般在 $(\frac{1}{40},\ \frac{1}{5})$ 之间，典型值是 $\frac{1}{10}$ 和 $\frac{1}{20}$。








## 3. Second-Order Loop Analysis
### 3.1 transfer function

先考虑二阶 (无 $C_2$) 的情况，此时 PLL 的开环/闭环传递函数为：

$$
\begin{gather}
H_{OL}(s) = \frac{\Phi_{out}}{\Phi_{in}}(s) = \frac{I_PK_{VCO}}{2\pi C_P}\times \frac{1 + sR_PC_P}{s^2},\quad H_0 = \frac{I_PK_{VCO}}{2\pi C_P}
\\
H_{CL}(s) = \frac{H_{OL}(s)}{1 + H_{OL}(s)} = \frac{I_PK_{VCO}}{2\pi C_P}\times \frac{1 + sR_PC_P}{s^2 + \frac{I_PK_{VCO}}{2\pi C_P}\cdot R_PC_P s + \frac{I_PK_{VCO}}{2\pi C_P}}
\end{gather}
$$

其中 $K_{VCO}$ 是 VCO 的增益，$I_P$ 是 Charge Pump 的充/放电电流大小。


从上面可以发现环路增益 $H_{OL}(0) = \infty$ 和 $H_{CL}(0) = 1$，其它信息则很难一眼看出来。简洁起见，也是为了深入分析，我们将闭环传递函数化为标准二阶系统的形式：

$$
\begin{gather}
H_{CL}(s) = \frac{I_PK_{VCO}}{2\pi C_P}\times \frac{1 + sR_PC_P}{s^2 + \frac{I_PK_{VCO}}{2\pi C_P}\cdot R_PC_P s + \frac{I_PK_{VCO}}{2\pi C_P}}
= \omega_n^2 \times \frac{1 + sR_PC_P}{s^2 + 2\zeta \omega_n s + \omega_n^2} 
\\
\Longrightarrow 
\zeta = \frac{R_P C_P}{2}\sqrt{\frac{I_PK_{VCO}}{2\pi C_P}},\quad \omega_n = \sqrt{\frac{I_PK_{VCO}}{2\pi C_P}},\quad \omega_n = \frac{2\zeta}{\tau_P},\quad \tau_P = R_P C_P
\end{gather}
$$

这样就能很轻松地解出闭环传递函数的零极点情况：

$$
\begin{gather}
\mathrm{Close-Loop:\ \ }
z_1 = -\frac{1}{\tau_P}= -\frac{1}{R_P C_P}
,\quad 
p_{1,2} = 
\begin{cases}
-\zeta \omega_n \pm j \omega_n \sqrt{1 - \zeta^2}, & \zeta < 1
\\
-\zeta \omega_n \pm \omega_n \sqrt{\zeta^2 - 1}, & \zeta > 1
\end{cases}
\end{gather}
$$

其中 $\omega_n$ 和 $\zeta$ 分别是系统的自然频率和阻尼比，这两个参数对 PLL 的动态性能有着重要影响。

显然，从零极点分布可以看出，无论 $\zeta$ 的值为多少，传函中的一个零点和两个零点都位于左半平面 (复平面)，因此系统一定是稳定的，只是稳定程度不同而已。

上面表达式中一共有三个参数：$\tau_P$, $\zeta$ 和 $\omega_n$, 由于 $\omega_n = \frac{2\zeta}{\tau_P}$ 可以写为前两者的函数，因此可以将 $\omega_n$ 消去，只用 $\tau_P$ 和 $\zeta$ 两个参数来描述系统性能：

$$
\begin{gather}
H_{OL}(s) = \frac{\Phi_{out}}{\Phi_{in}}(s) = \frac{4\zeta^2}{\tau_P^2} \times \frac{1 + s\tau_P}{s^2}
,\quad 
H_{CL}(s) = \frac{4\zeta^2}{\tau_P^2} \times \frac{1 + s\tau_P}{s^2 + \frac{4\zeta^2}{\tau_P} s + \frac{4\zeta^2}{\tau_P^2}}
\end{gather}
$$

这样做的好处在于，此时 $\zeta$ 和 $\tau_P$ 这两个变量便是 **完全独立的** ，它们俩共同决定了整个系统的动态性能。也就是说，只要确定了 $\tau_P$ 和 $\zeta$ 的值，系统的动态性能就唯一确定；换个思路，只要我们能独立调节 $\tau_P$ 和 $\zeta$，就能实现对系统动态性能的精确控制。



### 3.2 phase margin analysis

现在，我们从传递函数入手，分析系统的一些关键性能，包括相位裕度和环路带宽等。我们先求 Phase Margin (PM) 再求 Bandwidth (BW), 至于原因稍后便知。

求解 PM 的流程与放大器 amplifier 是完全类似的，找到 unit-gain frequency (UGF), 计算此点的相位 phase shift, 由此得到相位裕度：

$$
\begin{gather}
|H_{OL}(j\omega_{UGF})| = 1 
\Longrightarrow 
\omega_{UGF} = \frac{2\sqrt{2}\,\zeta}{\tau_P }\left(\sqrt{\zeta^4 +\frac{1}{4}}+\zeta^2 \right)^{\frac{1}{2}} \approx \frac{2\zeta}{\tau_P}\ (\zeta < 0.5)
\\
\mathrm{Q\ Factor}:=\frac{\omega_{UGF}}{\omega_n} = \left(2\sqrt{\zeta^4 +\frac{1}{4}}+2\zeta^2 \right)^{\frac{1}{2}},\quad \mathrm{Damping\ Factor} = \frac{1}{2Q}
\\
\Longrightarrow 
\begin{cases}
\left. \mathrm{Re} \{H_{OL}\} \right|_{s = j\omega_{UGF}} = -\left(\sqrt{4\,\zeta^4 +1} - 2\,\zeta^2 \right) < 0
\\
\left. \mathrm{Im} \{H_{OL}\} \right|_{s = j\omega_{UGF}} = -\left(\sqrt{4\,\zeta^4 +1} - 2\,\zeta^2 \right)\times 2\,\zeta \sqrt{2\,\zeta^2 +\sqrt{4\,\zeta^4 +1}} < 0
\end{cases}
\\
\left. H_{OL}(s) \right|_{s = j\omega_{UGF}} = -\left(\sqrt{4\,\zeta^4 +1} - 2\,\zeta^2 \right) \times \left[1 + j\,2\zeta \,\sqrt{2\,\zeta^2 +\sqrt{4\,\zeta^4 +1}}\right]
\\
\Longrightarrow 
\left. \angle H_{OL}(s) \right|_{s = j\omega_{UGF}} 
= \arctan \left(2\,\zeta \,\sqrt{2\,\zeta^2 +\sqrt{4\,\zeta^4 +1}}\right)  - \pi 
\end{gather}
$$

上面这一大串推导，最终都是为了得到下面这个式子：

$$
\begin{gather}
\mathrm{Phase\ Margin\ (rad/s)\ } = \arctan \left(2\,\zeta \,\sqrt{2\,\zeta^2 +\sqrt{4\,\zeta^4 +1}}\right)
\end{gather}
$$

如下图所示，在 $\zeta$ 达到 0.5 的时候，系统的相位裕度 = 76.3° 就已经非常高了，$\zeta \to 1$ 时便已经有最高裕度 90°:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-23-14-48_Loop Analysis of Typical Type-II CP-PLL.png"/></div>




### 3.3 bandwidth analysis

上面我们提过，开环传递函数 $H_{CL}(s) = \frac{H_{OL}(s)}{1 + H_{OL}(s)}$ 的值在低频时趋近于无穷大，也就 **不存在 Open-Loop -3dB BW (开环环路带宽)** 的概念。事实上，人们口中常说的 "锁相环环路带宽" 都是指 **Close-Loop -3dB BW (闭环环路带宽)** ，下面便来推导它的 (近似) 值。


$$
\begin{gather}
|H_{CL}(j\omega)|^2 = \frac{1}{2} 
\Longleftrightarrow 
\frac{16\,\zeta^4 \,{{\left(1+\omega \,\tau_P \,\mathrm{i}\right)}}^2 }{{{\left(-\omega^2 \,{\tau_P }^2 +4\,\omega \,\tau_P \,\zeta^2 \,\mathrm{i}+4\,\zeta^2 \right)}}^2 } = \frac{1}{2}
\\
\Longleftrightarrow 
\frac{16\,\zeta^4 \,{\left(\omega^2 \,{\tau_P }^2 +1\right)}}{\omega^4 \,{\tau_P }^4 +16\,\omega^2 \,{\tau_P }^2 \,\zeta^4 -8\,\omega^2 \,{\tau_P }^2 \,\zeta^2 +16\,\zeta^4 } = \frac{1}{2}
\end{gather}
$$

这看起来是个四次方程，其实可以化为二次方程来求解，得到：

$$
\begin{gather}
(\omega_{BW}\cdot\tau_P)^2 = 4\,\zeta^2 \,{\left(4\,\sqrt{\frac{\zeta^4 }{4}+\frac{\zeta^2 }{4}+\frac{1}{8}}+2\,\zeta^2 +1\right)}
\\
\Longrightarrow 
\omega_{BW} = \frac{2\,\sqrt{\zeta^2 \,{\left(4\,\sqrt{\frac{\zeta^4 }{4}+\frac{\zeta^2 }{4}+\frac{1}{8}}+2\,\zeta^2 +1\right)}}}{\tau_P } 
\\
\Longrightarrow
\omega_{BW} 
= \frac{2\zeta}{\tau_P} \left[2\zeta^2 +1 + \sqrt{4\zeta^4 + 4\zeta^2 + 2}\right]^{\frac{1}{2}}
\end{gather}
$$

上面这个式子不太友好，我们不妨在 $\zeta = 0, 0.5, 1$ 处对其进行泰勒展开，得到：

$$
\begin{gather}
(\omega_{BW} \times \tau_P) \approx 
\begin{cases}
2.197\,\zeta^3 +3.108\,\zeta &, \zeta \to 0
\\
1.290\,\zeta^3 +0.9039\,\zeta^2 +2.772\,\zeta +0.04438 &, \zeta \to 0.5
\\
0.2292\,\zeta^3 +3.131\,\zeta^2 +1.154\,\zeta +0.4498 &, \zeta \to 1
\end{cases}
\end{gather}
$$

这几个公式仅作手算参考，我们自己还是比较喜欢用近似前的原式，毕竟它在整个 $\zeta \in (0, +\infty)$ 上都是准确的。


### 3.4 conclusion verification

举个我们在项目中实际验证过的例子，假设我们的环路参数为：

$$
\begin{gather}
I_P = 8 \ \mathrm{nA},\quad K_{VCO} = 4.7761 \ \mathrm{MHz/V},\quad N_{\mathrm{divide}} = 40,\quad R_P = 15\ \mathrm{M\Omega},\quad C_P = 20\ \mathrm{pF}
\\
\Longrightarrow \zeta = 0.1950,\quad \tau_P = 0.1\times 10^{-3} \ \mathrm{s}
\end{gather}
$$

根据 PM 和 BW 的公式，可以得到：

$$
\begin{gather}
\mathrm{PM} = \arctan \left(2\,\zeta \,\sqrt{2\,\zeta^2 +\sqrt{4\,\zeta^4 +1}}\right) = 44.3714°
\\
\omega_{BW} = \frac{2\zeta}{\tau_P} \left[1 + 2\zeta^2 + \sqrt{4\zeta^4 + 4\zeta^2 + 2}\right]^{\frac{1}{2}} = 4.7879 \ \mathrm{krad/s}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-17-35-21_Loop Analysis of Typical Type-II CP-PLL.png"/></div>


作出系统开环和闭环传递函数图像如下，确实验证了 PM = 44.4° 和 BW = 4.8 krad/s = 0.762 kHz : 


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-01-03-42_Loop Analysis of Typical Type-II CP-PLL.png"/></div>


顺便给出改动 $I_P$, $R_P$ 和 $C_P$ 对环路动态性能的影响：

<span style='font-size:12px'>
<div class='center'>

| (I_P, R_P, C_P) | tau_P | zeta | PM  | BW | BW ratio (f_in/f_BW) |
|:-:|:-:|:-:|:-:|:-:|:-:|
| (8  nA, 10 MOhm, 20 pF) | 0.20 ms | 0.2757 | 30.74° | 718.02 Hz | 45.64 |
| (8  nA, 15 MOhm, 20 pF) | 0.30 ms | 0.4136 | 44.37° | 762.02 Hz | 43.00 |
| (8  nA, 20 MOhm, 20 pF) | 0.40 ms | 0.5514 | 55.79° | 812.13 Hz | 39.91 |
| (10 nA, 10 MOhm, 30 pF) | 0.30 ms | 0.3775 | 40.99° | 683.71 Hz | 47.93 |
| (10 nA, 15 MOhm, 30 pF) | 0.45 ms | 0.5663 | 56.86° | 756.15 Hz | 43.34 |
| (10 nA, 20 MOhm, 30 pF) | 0.60 ms | 0.7551 | 67.89° | 849.97 Hz | 38.55 |
| (4  nA, 15 MOhm, 30 pF) | 0.45 ms | 0.3582 | 39.12° | 428.62 Hz | 76.45 |
| (6  nA, 15 MOhm, 30 pF) | 0.45 ms | 0.4386 | 46.63° | 545.68 Hz | 60.05 |
| (8  nA, 15 MOhm, 30 pF) | 0.45 ms | 0.5065 | 52.35° | 653.48 Hz | 50.14 |
| (10 nA, 15 MOhm, 30 pF) | 0.45 ms | 0.5663 | 56.86° | 756.15 Hz | 43.34 |
| (4  nA, 15 MOhm, 40 pF) | 0.60 ms | 0.4136 | 44.37° | 381.01 Hz | 86.00 |
| (6  nA, 15 MOhm, 40 pF) | 0.60 ms | 0.5065 | 52.35° | 490.11 Hz | 66.86 |
| (8  nA, 15 MOhm, 40 pF) | 0.60 ms | 0.5849 | 58.16° | 592.20 Hz | 55.33 |
| (10 nA, 15 MOhm, 40 pF) | 0.60 ms | 0.6539 | 62.57° | 690.56 Hz | 47.45 |
| (5  nA, 15 MOhm, 30 pF) | 0.45 ms | 0.4004 | 43.16° | 488.73 Hz | 67.05 | 
| (8  nA, 15 MOhm, 30 pF) | 0.45 ms | 0.5065 | 52.35° | 653.48 Hz | 50.14 |
| (10 nA, 15 MOhm, 40 pF) | 0.60 ms | 0.6539 | 62.57° | 690.56 Hz | 47.45 |
| (12 nA, 15 MOhm, 50 pF) | 0.75 ms | 0.8009 | 69.90° | 742.72 Hz | 44.12 |
| (15 nA, 15 MOhm, 50 pF) | 0.75 ms | 0.8954 | 73.36° | 882.44 Hz | 37.13 |


</div>
</span>



## 4. Third-Order Loop Analysis


引入电容 $C_2$ 后，滤波器的传函发生变化：

$$
\begin{gather}
\alpha = 0,\ \ Z_F(s) = R_P + \frac{1}{sC_P} \longmapsto
\\
 \alpha \ne 0,\ \ Z_F(s) = \left(R_P + \frac{1}{sC_P}\right) \parallel \frac{1}{sC_2} = \frac{1 + s\tau_P}{sC_P(1 + \alpha + s\alpha \tau_P)}
\end{gather}
$$

作变量替换 $sC_P \longmapsto sC_P(1 + \alpha + s \alpha\tau_P)$ 即可得到新的开环传递函数：

$$
\begin{gather}
H_{OL}(s) = \frac{I_PK_{VCO}}{2\pi C_P}\times \frac{1 + sR_PC_P}{s^2(1 + \alpha + s\alpha \tau_P)},\quad p_3 = - \frac{1 + \frac{1}{\alpha}}{\tau_P}
\end{gather}
$$


因此，系统的环路特性就与 Second-Order 基本相同，只是引入了一个额外的开环极点 $p_3$。只要 $\alpha \ll 1$ (例如 $\alpha = \frac{1}{10}$)，这个第三极点就会远离 UGF，从而对系统的动态性能影响甚微：

$$
\begin{gather}
p_3 = - \frac{1 + \frac{1}{\alpha}}{\tau_P},\quad 
\alpha \ll 1 \Longrightarrow |p_3| \gg |z_1|\ \mathrm{or}\ |p_{1,2}|
\end{gather}
$$

## 5. PLL Phase Noise

这里先放一张 PLL 相位噪声的经典模型图，供读者参考：

<div class='center'>

| [知乎 > PLL Phase Noise Simulation (1)](https://zhuanlan.zhihu.com/p/672309377) | [EETOP > [求助] 请教：PLL 的总体相位噪声曲线拟合（已用 cadence 仿真出每个模块的相位噪声曲线）](https://bbs.eetop.cn/thread-305902-1-1.html)
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-06-02-30-51_Loop Analysis of Typical Type-II CP-PLL.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-06-02-32-36_Loop Analysis of Typical Type-II CP-PLL.png"/></div> |
</div>

本小节给出 PLL 中各模块的相位噪声传递函数 **(闭环)**，推导过程详见 Razavi PLL page.249, 这里直接给出关键结果：

<span style='font-size:12px'> 
<div class='center'>

| Noise | Pass Type | (Closed Loop) Phase Noise Transfer | Condition for Lower Noise |
|:-:|:-:|:-:|:-:|
 | $S_{\phi_n,REF}$ of REF  | LP | $ S_{\phi_n,REF}(f) = S_0 \\ H_{\phi_n,REF}(s) = \frac{\Phi_{n,out}}{\Phi_{n,REF}}(s) = N^2 \times H_{CL}(s) \\ \phi_{rms,REF} \approx N \sqrt{\pi S_0 \mathrm{BW}_f}\ \ \mathrm{(rad)} \\ J_{rms,REF} \approx \frac{N}{2\pi f_{out}} \sqrt{\pi S_0 \mathrm{BW}_f}\ \ \mathrm{(second)} $ | $N \downarrow,\ \mathrm{BW}_f \downarrow \ (\tau_P \uparrow,\ \zeta \downarrow) $ |
 | $S_{\phi_n,VCO}$ of VCO | HP | $ S_{\phi_n,VCO}(f) = \frac{\alpha}{f^3} + \frac{\beta}{f^2} \\ H_{\phi_n,VCO}(s) = \frac{\Phi_{n,out}}{\Phi_{n,VCO}}(s)  = \frac{s^2}{s^2 + \frac{4\zeta^2}{\tau_P} s + \frac{4\zeta^2}{\tau_P^2}} \\ \omega_{HP,VCO} = \frac{2\zeta}{\tau_P} \left[(2\zeta^2 - 1) + \sqrt{1 + (2\zeta^2 - 1 )^2}\right]^{\frac{1}{2}} $ | $ \tau_P \downarrow,\ \zeta \uparrow $ |
 | Equal REF and VCO Noise Contribution | - | $ BW_f = \sqrt{\frac{4\beta}{\pi N^2 S_0}}\\ \phi_{rms,REF,VCO} = 4 \sqrt{ N^2\pi\beta  S_0} \\ J_{rms,REF,VCO} = \frac{2}{\pi f_{out}} \sqrt{ N^2\pi\beta  S_0} $ | - |
 | $S_{V_n,VDD}$ of VDD (through VCO) | BP | $ K_{VDD}(s) = 2 \pi \frac{\partial f_{out} }{\partial V_{DD} } (s) \\ H_{\phi_n,VDD}(s) = \frac{\Phi_{n,out}}{V_{n,VDD}}(s) = \frac{s K_{VDD}(s)}{s^2 + \frac{4\zeta^2}{\tau_P} s + \frac{4\zeta^2}{\tau_P^2}} \\ \max\{H_{\phi_n,VDD} (s)\} \le \frac{K_{VDD}}{2 \zeta \omega_n} = K_{VDD}\times \frac{\tau_P}{4\zeta^2}$ | $\tau_P \downarrow,\ \zeta \uparrow $ |
 | $S_{I_n,CP,eq}$ of CP | LP | $ S_{I_n,CP,eq}(f) = 2S_{I_n,CP}(f) \cdot \frac{T_{res}}{T_{ref}} = \left(2\overline{I_{n}^2}\right) \cdot \frac{T_{res}}{T_{ref}} \\ H_{\phi_n,CP}(s) = \frac{\Phi_{n,out}}{I_{n,CP,eq}}(s) = \frac{N K_{VCO,eq}}{C_1} \times \frac{1 + s\tau_P}{s^2 + \frac{4\zeta^2}{\tau_P} s + \frac{4\zeta^2}{\tau_P^2}} \\ H_{\phi_n,CP}(0) = \frac{2\pi N}{I_P}  $ | $ N \downarrow,\ I_P \uparrow $ |
 | $S_{V_n,LPF}$ of LPF Resistor | BP | $ S_{V_n,LPF}(f) = 4kT R_1 \\ H_{\phi_n,LPF}(s) = \frac{\Phi_{n,out}}{V_{n,LPF}}(s) = \frac{s N K_{VCO,eq}}{s^2 + \frac{4\zeta^2}{\tau_P} s + \frac{4\zeta^2}{\tau_P^2}} \\ \max \{S_{\phi_n}(f)\} = \frac{16 \pi^2 N^2 kT }{R_1 I_P^2} \ \ \mathrm{(SSB)} $ | $ N \downarrow,\ I_P \uparrow,\ R_1 \uparrow $ |
</div>
</span>

<!-- $$
\begin{gather}
\mathrm{Closed\ Loop\ Phase\ Noise\ Transfer\ Function:\ \ }
\\
\mathrm{REF\ (LP):\ \ }
\begin{cases}
S_{\phi_n,REF}(f) = S_0 \\
H_{\phi_n,REF}(s) = \frac{\Phi_{n,out}}{\Phi_{n,REF}}(s) = N^2 \times H_{CL}(s)
\\
\phi_{rms,REF} \approx N \sqrt{\pi S_0 \mathrm{BW}_f}\ \ \mathrm{(rad)}
\\
J_{rms,REF} \approx \frac{N}{2\pi f_{out}} \sqrt{\pi S_0 \mathrm{BW}_f}\ \ \mathrm{(second)}
\end{cases}
\\
\mathrm{VCO\ (HP):\ \ }
\begin{cases}
S_{\phi_n,VCO}(f) = \frac{\alpha}{f^3} + \frac{\beta}{f^2}
\\
H_{\phi_n,VCO} = \frac{\Phi_{n,out}}{\Phi_{n,VCO}}(s) = \frac{s^2}{s^2 + 2\zeta \omega_n s + \omega_n^2} = \frac{s^2}{s^2 + \frac{4\zeta^2}{\tau_P} s + \frac{4\zeta^2}{\tau_P^2}}
\\
\omega_{HP,VCO} = \frac{2\zeta}{\tau_P} \left[2\zeta^2 - 1 + \sqrt{4\zeta^4 - 4\zeta^2 + 2}\right]^{\frac{1}{2}}
\end{cases}
\\
\mathrm{Equal\ REF\ and\ VCO\ Noise\ Contribution:\ \ } 
\begin{cases}
BW_f = \sqrt{\frac{4\beta}{\pi N^2 S_0}}\\
\phi_{rms,REF,VCO} = 4 \sqrt{ N^2\pi\beta  S_0} \\
J_{rms,REF,VCO} = \frac{2}{\pi f_{out}} \sqrt{ N^2\pi\beta  S_0}
\end{cases}
\\
\mathrm{CP\ (LP):\ \ }
\begin{cases}
S_{I_n,CP,eq}(f) = 2S_{I_n,CP}(f) \times \frac{T_{res}}{T_{ref}} = \left(2\overline{I_{n}^2}\right) \times \frac{T_{res}}{T_{ref}}
\\
H_{\phi_n,CP}(s) = \frac{\Phi_{n,out}}{I_{n,CP,eq}}(s) = \frac{N K_{VCO,eq}}{C_1} \times \frac{1 + s\tau_P}{s^2 + \frac{4\zeta^2}{\tau_P} s + \frac{4\zeta^2}{\tau_P^2}}
\\
H_{\phi_n,CP}(s) \approx \frac{N K_{VCO,eq}}{C_1 \omega_n^2} = \frac{2\pi N}{I_P} \ \ \mathrm{(@\ low\ frequency)}
\end{cases}
\\
\mathrm{LPF\ Resistor\ (BP):\ \ } 
\begin{cases}
S_{V_n,LPF}(f) = 4kT R_1
\\
H_{\phi_n,LPF}(s) = \frac{\Phi_{n,out}}{V_{n,LPF}}(s) = \frac{s N K_{VCO,eq}}{s^2 + \frac{4\zeta^2}{\tau_P} s + \frac{4\zeta^2}{\tau_P^2}}
\\
\max \{S_{\phi_n,LPF}(f)\} = \frac{N^2 K_{VCO,eq}^2}{4\zeta^2 \omega_n^2} \times (4kT R_1) = \frac{16 \pi^2 N^2 kT }{R_1 I_P^2} \ \ \mathrm{(SSB)}
\end{cases}
\end{gather}
$$
 -->



## 6. Other Considerations

<span style='font-size:10px'> 
<div class='center'>

| Other Design Considerations | Description | Formula |
|:-:|:-:|:-:|
 | LPF Leakage | 很多设计会用 MOSFET 来实现 LPF 中的电容 C1 or C2, 这样虽节省面积，但可能带来较大的 gate leakage, 比如 Razavi PLL page.261 举的例子： 45-nm CMOS 工艺下，一个 10um/0.5um 管子的 gate leakage current $I_{G}$ 达到 0.1 uA @ Vgs = 0.6 V 和 = 1 uA @ Vgs = 1.0 V (gate dielectric thickness = 20 Å) <br> 这个问题我们在最近的项目 (202510_PLL) 中也直观感受到了，LPF 的漏电会导致环路无法正常“静默 (关闭)”，带来周期性的开启纹波和周期性的 vcont 波动，导致系统相噪/抖动迅速恶化 | $$\phi_{pp} = \frac{1}{2}K_{VCO,eq} \frac{I_GT_{REF}^2}{4C_2} = \frac{N K_{VCO} I_G}{8C_2f_{out}^2} \\ J_{pp} = \frac{\phi_{pp}}{2\pi f_{out}} = \frac{N K_{VCO} I_G}{16 \pi C_2 f_{out}^3} $$ |
 | Ripple Reduction by Sampling Filter | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-02-21-12_Loop Analysis of Typical Type-II CP-PLL.png"/></div> | - |
 | Filter Capacitor Reduction | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-02-22-44_Loop Analysis of Typical Type-II CP-PLL.png"/></div> | $C_{eq} = \frac{1}{\alpha - 1} C,\ \alpha \in (1,\ 2)$，注意由 $R_1$ 产生的纹波仍为 $\Delta V = I_P R_1$ |
 | Divider Delay Correction | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-02-28-48_Loop Analysis of Typical Type-II CP-PLL.png"/></div> | - |
 | Duty Cycle Correction | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-02-34-03_Loop Analysis of Typical Type-II CP-PLL.png"/></div> |  |
 | High-Speed PFD | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-02-36-09_Loop Analysis of Typical Type-II CP-PLL.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-09-02-36-17_Loop Analysis of Typical Type-II CP-PLL.png"/></div> |
</div>

</span>


## 7. MATLAB Codes



本文的公式推导/作图利用 MATLAB 辅助进行，源码如下：

``` matlab
2025.10.22 Type-II CP-PLL
Second-Order (zero + p1 + p2) PM 推导
syms H_OL s
syms omega_n tau_P zeta omega x real
H_OL(s) = 4*zeta^2/tau_P^2 * (1 + s*tau_P)/s^2
MyAnalysis_TransferFunction(H_OL(s), 1, 0);



% 求解 omega_UGF: |H| = 1
    H_OL_omega = subs(H_OL, s, 1j*omega)
    H_OL_omega_conj = conj(H_OL_omega);  % 取共轭
    eq = simplify(simplify(H_OL_omega*H_OL_omega_conj) - 1)
    % eq = subs(eq, omega^2, x);
    % re_x = solve(eq, x)
    re = solve(eq, omega)
    omega_UGF = re(2)   % 得到 UGF 点

% 利用泰勒展开获得 omega_UGF 近似表达式
if 0
    Y_0 = subs(omega_UGF, tau_P, 1);
    taylor(sqrt(zeta^4 + 1/4), zeta, 1)
    
    figure
    fplot(Y_0, [0 2], "Marker", "o");
    hold on
    fplot(Y_0, [0 2], "Marker", "o");
    hold off
end

% omega_UGF 近似效果一览 (tau_P = 1)
if 0
    f_init = @(zeta) (2*sqrt(2)*zeta.*sqrt(sqrt(zeta.^4 + 1/4) + zeta.^2));
    f_1 = @(zeta) 4*zeta.^2 + zeta.^2;
    f_2 = @(zeta) 4*zeta.^2;
    zeta_array = linspace(0, 2, 21);
    
    Y_array = f_init(zeta_array);
    
    Y = [f_init(zeta_array); f_1(zeta_array); f_2(zeta_array)];
    stc = MyPlot_Marker(zeta_array, Y);
    % stc.plot.plot_1.LineWidth = 4;
    % stc.axes.XScale = 'log';
end

% 求解 PM
    H_OL_omega_UGF = simplify(subs(H_OL_omega, omega, omega_UGF))
    re = simplify(real(H_OL_omega_UGF))
    im = simplify(imag(H_OL_omega_UGF))
    ratio = simplify(imag(H_OL_omega_UGF)/real(H_OL_omega_UGF))
    phase = atan(ratio) - pi
    
    phase_UGF = @(zeta) atan(2*zeta.*sqrt(2*zeta.^2 + sqrt(4*zeta.^4 + 1))) - pi;
    zeta_array = [0, 0.2, 0.4, 0.707, 1, 2, 5, 10];
    % phase_UGF(zeta_array);
    % rad2deg(phase_UGF(zeta_array))
    rad2deg(phase_UGF([0.1950, 0.3377]) + pi)
    
    X = logspace(-2, 2, 101);
    Y_rad = phase_UGF(X);
    % Y_rad(Y_rad > 0) = - Y_rad(Y_rad > 0);
    Y = rad2deg(Y_rad);
    stc = MyPlot(X, Y);
    stc.label.x.String = '$\zeta$';
    stc.label.y.String = 'Phase at UGF (deg)';
    stc.axes.XScale = 'log';
    stc.axes.YLim = [-180 -90];
    stc.axes.YTick = -180:15:180;

    X = linspace(0, 1, 101);
    stc = MyPlot(X, Y + 180);
    stc.label.x.String = '$\zeta$';
    stc.label.y.String = 'Phase Margin (deg)';
    % stc.axes.XScale = 'log';
    stc.axes.XLim = [0 1];
    stc.axes.YLim = [0 90];
    stc.axes.YTick = -180:15:180;


% 结论

PM_rad = @(zeta) atan(2*zeta.*sqrt(2*zeta.^2 + sqrt(4*zeta.^4 + 1)));

2025.10.22 闭环 BW 推导
syms H_OL s complex
syms omega_n tau_P zeta omega real
H_CL = omega_n^2 * (1 + s*tau_P) / (s^2 + 2*zeta*omega_n*s + omega_n^2);
H_CL = simplifyFraction(subs(H_CL, omega_n, 2*zeta/tau_P))
MyAnalysis_TransferFunction(H_CL, 0, 0);
H_CL_0 = subs(H_CL, s, 0);
H_CL_omega = subs(H_CL, s, 1j*omega)
H_CL_omega_conj = conj(H_CL_omega)  % 取共轭

eq = simplify(expand(H_CL_omega*H_CL_omega_conj)) - 1/2
eq = subs(eq, (omega*tau_P)^2, x)
re = solve(eq, x)
re(2)
omega_BW = simplifyFraction(sqrt(re(2))/tau_P)

% BW 近似公式
func = 2*zeta * sqrt( 2*zeta^2 + 1 + sqrt(4*zeta^4 + 4*zeta^2 + 2) )
func = 2*sqrt(2)*zeta * sqrt( zeta^2 + sqrt(zeta^4 + 1/4) )    % PM 近似
vpa(expand(taylor(func, zeta, 0, 'order', 4)), 4)
vpa(expand(taylor(func, zeta, 0.5, 'order', 4)), 4)
vpa(expand(taylor(func, zeta, 1.0, 'order', 4)), 4)

% 结论
omega_BW = @(zeta, tau_P) (2*sqrt(zeta^2*(4*sqrt(zeta^4/4 + zeta^2/4 + 1/8) + 2*zeta^2 + 1)))/tau_P;



2025.10.22 开环/闭环传递函数可视化检验
if 1
% C_P = 10pF
tau_P = 1*1e-4
zeta = 0.1950
end

if 0
% C_P = 30pF
tau_P = 3*1e-4
zeta = 0.3377
end

I_P = 10*1e-9;   
K_VCO = 1.28e6/(0.7 - 0.432)
f_in = 32.768e3;
omega_in = 2*pi*f_in;
Divide_N = 40;
R_P = 15*1e6;   % R1
C_P = 30*1e-12; % C1
K_VCO_eq = K_VCO/Divide_N; K = K_VCO_eq*I_P*R_P/(2*pi); tau_P = R_P*C_P
zeta = sqrt(K.*tau_P)/2


% 计算 PM 和 BW
PM_rad = @(zeta) atan(2*zeta.*sqrt(2*zeta.^2 + sqrt(4*zeta.^4 + 1)));
omega_BW = @(zeta, tau_P) (2*sqrt(zeta.^2.*(4*sqrt(zeta.^4/4 + zeta.^2/4 + 1/8) + 2*zeta.^2 + 1)))./tau_P;
PM_deg = rad2deg(PM_rad(zeta))
BW_omega = omega_BW(zeta, tau_P)
BW_f = BW_omega/(2*pi)
ratio_BW = f_in./BW_f






% 作图
func_H_OL = @(omega) - (4*zeta.^2*(1 + 1j*omega*tau_P))./(omega.^2*tau_P^2);
func_H_CL = @(omega) (4*zeta.^2.*((1j*omega).*tau_P + 1))./((1j*omega).^2.*tau_P.^2 + 4*(1j*omega).*tau_P.*zeta.^2 + 4*zeta.^2);
omega_array = logspace(0, 8, 1001);

stc = MyPlot_Bode_oneH_omega_YY(omega_array, func_H_OL);
MyFigure_ChangeSize([1.5, 1]*512);
stc.axes.Title.String = 'Open-Loop Transfer Function $H_{OL}(j\omega)$';
stc = MyPlot_Bode_oneH_omega_YY(omega_array, func_H_CL);
MyFigure_ChangeSize([1.5, 1]*512);
stc.axes.Title.String = 'Close-Loop Transfer Function $H_{CL}(j\omega)$';




2025.10.22 Third-Order (zero + p1 + p2 + p3) 推导
syms R_P C_P s Z_F tau_P alpha
Z_F = simplifyFraction(MyParallel(R_P + 1/(s*C_P), 1/(s*alpha*C_P)))
```


## Reference

- [*Design of Analog CMOS Integrated Circuits (Behzad Razavi) (2nd edition, 2017)*](https://www.zhihu.com/question/452068235/answer/95164892409)
- F. Gardner, "Charge-Pump Phase-Lock Loops," in IEEE Transactions on Communications, vol. 28, no. 11, pp. 1849-1858, November 1980, doi: 10.1109/TCOM.1980.1094619. 
- [ADI > MT-086 TUTORIAL > Fundamentals of Phase Locked Loops (PLLs) ](https://www.analog.com/media/en/training-seminars/tutorials/MT-086.pdf)
- [Understanding Open Loop Bandwidth and Phase Margin in PLL Systems](https://rahsoft.com/2024/06/19/understanding-open-loop-bandwidth-and-phase-margin-in-pll-systems/)
- [EETOP > transistor7 的个人空间 > PLL 学习笔记 (1)](https://blog.eetop.cn/blog-1711599-6945557.html)