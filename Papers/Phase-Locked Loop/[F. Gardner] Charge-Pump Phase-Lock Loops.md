# [F. Gardner] Charge-Pump Phase-Lock Loops

> [!Note|style:callout|label:Infor]
> Initially published at 22:22 on 2025-08-12 in Lincang.

本文分析了二阶和三阶 Type-II CP-PLL (Charge Pump PLL) 的典型特征，并为实际设计提供了理论方程和图表参考。

原文链接: 
- [Charge-Pump Phase-Lock Loops (主链接)](https://u.dianyuan.com/bbs/u/29/1116306785.pdf) 
- [Charge-Pump Phase-Lock Loops (备用链接)](https://ieeexplore.ieee.org/abstract/document/1094619)

论文全引是：
>F. Gardner, "Charge-Pump Phase-Lock Loops," in IEEE Transactions on Communications, vol. 28, no. 11, pp. 1849-1858, November 1980, doi: 10.1109/TCOM.1980.1094619. 

## Abstract

鉴频鉴相器 (PFD, phase frequency detector) 以三态数字逻辑的形式输出频率/相位比较信号，而电荷泵 (CP, charge pump) 则用于将 PFD 输出的逻辑电平转换为模拟量，通过低通滤波器输出给压控振荡器。本文分析了 CP-PLL (Charge Pump PLL) 中典型的电荷泵电路，指出其显著特点，并为设计工程师提供了理论方程和图表参考。


## 1. Introduction

近年来 (1980 以前)，采用 PFD 的锁相环 (PLL) 得到了广泛应用 [1]-[6]。其受欢迎的原因包括跟踪范围广、频率辅助捕获以及实现成本低等。如图 1 所示，电荷泵 CP 通常与 PFD 配合使用, CP 的作用是将 PFD 的逻辑状态转换为适合控制压控振荡器 (VCO) 的模拟信号。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-22-32-08_[F. Gardner] Charge-Pump Phase-Lock Loops.png"/></div>

本文旨在为 CP-PLL (Charge Pump PLL) 的设计分析奠定坚实基础，以便识别其特殊特征，并在必要时加以利用或避免。

在第二节中，我们介绍基本的电荷泵 CP 模型，并基于小误差（线性化环路）和带宽与输入频率相比较窄（连续时间近似）的假设，推导环路传递函数。第三节专门讨论二阶 PLL, 其中表明即使使用无源环路滤波器，也能实现 type-II PLL (II 型锁相环). 这种与传统 PLL 中的效果相反，是电荷泵带来的一个特别优势。

当环路带宽 $BW_{\omega}$ 足够接近输入频率 $\omega_{in}$ 时，连续时间近似就不再有效。在这种情况下，必须认识到环路的离散时间或采样特性。特别是，采样会带来连续时间网络中不存在的稳定性问题，本文利用 z 变换给出了二阶环路的稳定性极限。

在二阶 LPF (low-pass filter) 的基础上，通常在 CP 之后添加滤波器以减少纹波。第四节描述了添加单个电容器 (最简单的纹波滤波器) 后的环路性能。此时环路为三阶 (尽管仍然是 II 型)，因此分析更为复杂。文中给出了连续时间近似下的根轨迹图 (s 变换)。对于更高的带宽，连续时间近似不再成立，利用离散时间线性化分析得到 z 平面特征函数，推导除极点位置和稳定性极限。

第五节描述了二阶环路的非线性离散状态变量分析结果。事实证明，通过离散时间分析获得的宽带环路的瞬态建立时间，与通过普通连续时间方法得到的建立时间非常相似。三阶环路也可以进行类似分析，但尚未开展。

## 2. Models 

### 2.1 PFD + CP (Charge Pump) 

将 PFD (Phase Frequency Detector) 和 CP (Charge Pump) 视为一个整体进行建模。

假设锁相环已锁定，将输入信号的频率表示为 $\omega_{i}$ (rad/s)，并设相位误差为 $\theta_e = \theta_{in} - \theta_{out}$，也即 ${\color{red} \theta_{in} = \theta_{out} + \theta_e}$。与输入频率相比，当锁相环的带宽足够大时 (一般需要 $ \omega_{BW} > \omega_{in}/20$)， PFD 的输出端 U/D 在每个周期的导通时间为：

$$
\begin{gather}
t = \frac{|\theta_e|}{\omega_{in}}
\end{gather}
$$

(The subscript "p" connotes "pump".) 

当环路带宽足够高时，上式在 "1. 周期时间平均"、"2. 传输理想性假设 (即假设逻辑门传输无延迟)" 和 "3. 带宽理想性假设" 下是精确的。但是当环路带宽 $\omega_{BW}$ 低于 $< \frac{\omega_{in}}{30}$ 时，逐渐出现明显误差。


在每个周期的导通时间段 $t_p$ 内，电流 $I_p$ 被输送至 LPF, 每个周期的持续时间为 $T = \frac{2\pi}{\omega_{in}}$ 秒，因此，利用 $t = \frac{|\theta_e|}{\omega_{in}}$，可以得到一个周期内 CP 向 LPF 输送的平均电流为：

$$
\begin{gather}
I_{out}ut = \frac{I_P\theta_e}{2\pi},\quad \theta_e = \theta_{in} - \theta_{out}
\end{gather}
$$

由此可以将 CP 建模为：

$$
\begin{gather}
H_{PFD,CP}(s) = \frac{\mathrm{output}(s)}{\mathrm{input}(s)} = \frac{I_{out}(s)}{\theta_e(s)} = \frac{I_p}{2\pi}
\end{gather}
$$


### 2.2 LPF (Low-Pass Filter)

LPF 的形式多种多样，可以是无源/有源，也可以是低阶/高阶。我们考虑普适性最高的阻抗式无源滤波器，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-23-06-53_[F. Gardner] Charge-Pump Phase-Lock Loops.png"/></div>

上面建模 CP 时认为其输出量为电流的优势就体现在这里，我们可以直接将 LPF 视为一个阻抗单元，则有：

$$
\begin{gather}
H_{LPF}(s) = \frac{\mathrm{output}(s)}{\mathrm{input}(s)} = \frac{V_{out}(s)}{I_{in}(s)} = Z_F(s)
\end{gather}
$$

### 2.3 VCO (Voltage-Controlled Oscillator)

在文章 [Razavi CMOS - Chapter 15. Oscillators](<AnalogIC/Razavi CMOS - Chapter 15. Oscillators.md>) 中已经讨论过 VCO 的建模：

$$
\begin{gather}
\omega_{osc} = \omega_0 + K_{VCO}V_{cont},\quad \omega = \frac{\mathrm{d} \theta }{\mathrm{d} t }
\\
\Longrightarrow 
H_{VCO}(s) = \frac{\mathrm{output}(s)}{\mathrm{input}(s)} = \frac{\theta_{out}(s)}{V_{cont}(s)} = \frac{K_{VCO}}{s}
\end{gather}
$$

### 2.4 PLL (Phase-Locked Loop)

按 Fig.1 中的反馈路径，反馈系数为 1, 则 PLL 的传递函数为：

$$
\begin{gather}
H_{OL}(s) = H_{PFD,CP}(s)\cdot H_{LPF}(s) \cdot H_{VCO}(s) = \frac{K_{VCO}I_P Z_F(s)}{2\pi s}
\\
H_{CL}(s) = \frac{\theta_{out}(s)}{\theta_{in}(s)}|_{\mathrm{closed\,loop}} = \frac{H_{OL}(s)}{1 + H_{OL}(s)} = \frac{K_{VCO}I_PZ_F(s)}{2\pi s + K_{VCO}I_PZ_F(s)}
\end{gather}
\\
\frac{\theta_e(s)}{\theta_{in}(s)} = \frac{\theta_{in}(s) - \theta_{out}(s)}{\theta_{in}(s)} = 1 - H_{CL}(s) = \frac{2\pi s }{2\pi s + K_{VCO}I_PZ_F(s)}
$$

利用拉普拉斯变换的终止定理，可以推出锁定后的静态相位误差 (系统误差) 为：

$$
\begin{gather}
\varphi_{static} = \frac{2\pi \Delta \omega}{K_{VCO}I_P Z_F(0)} = \frac{2\pi (\omega_{in} - \omega_0)}{K_{VCO}I_P Z_F(0)}
\end{gather}
$$

其中 $\omega_0$ 是 VCO 的中心角频率，也即 $V_{cont} = 0$ 时的输出角频率。实际应用的 LPF 都有 $Z_F(0) = \infty$, 但 PLL 的静态相位误差却通常不为零，这是 VCO 有限的直流输入阻抗 $R_b$ 和非零的漏电流 $I_b$ 共同造成的。

由直流电阻和漏电流造成的静态相位误差和分别为：

$$
\begin{gather}
\varphi_{R_b} = \frac{2\pi \Delta \omega}{K_{VCO}I_P R_b},\quad 
\varphi_{I_b} = \frac{2\pi I_b}{I_P}
\\
\Longrightarrow 
\varphi_{static} = \varphi_{R_b} + \varphi_{I_b} = \frac{2\pi \left(\Delta \omega + K_{VCO}R_b I_b\right)}{K_{VCO}I_P R_b} 
\end{gather}
$$



## 3. Second-Order PLL

### 3.1 Continuous-Time Analysis

现在用一个电阻 $R_P$ 和电容 $C_P$ 串联作为 LPF, 有 $Z_F(s) = R_P + \frac{1}{sC_P}$。

为了将结果表达式系统化，我们定义下面四个参数：

$$
\begin{gather}
\begin{cases}
\tau_P &= R_P C_P
\\
\omega_n &= \sqrt{\frac{K_{VCO}I_P}{2\pi C_P}}
\\
\zeta &= \frac{\tau_P}{2}\sqrt{\frac{K_{VCO}I_P}{2\pi C_P}} 
\\
K &= \frac{K_{VCO}I_P R_P}{2\pi}
\end{cases}
,\quad \Longrightarrow 
K = 2 \zeta \omega_n = \frac{4\zeta^2}{\tau_P} = \omega_n^2 \tau_P
\end{gather}
$$

此时 PLL 的传递函数为：
$$
\begin{gather}
H_{CL}(s) 
= \frac{I_PK_{VCO}}{2\pi C_P}\times 
\frac{1 + s R_P C_P}{s^2 + \frac{K_{VCO}R_PI_P}{2\pi}s + \frac{K_{VCO}I_P}{2\pi C_P}} 
= \frac{K}{\tau_P}\times 
\frac{1 + s \tau_P}{s^2 + K s + \frac{K}{\tau_P}} 
\end{gather}
$$

闭环下的两个极点为：

$$
\begin{gather}
p_{1,2} = - K \pm j \sqrt{\frac{4K}{\tau_P} - K^2} = - K \pm \sqrt{K^2 - \frac{4K}{\tau_P}}
\end{gather}
$$

假设极点在复数域，也即 $K \tau_P < 4 \Longleftrightarrow K_{VCO}I_P C_P R_P^2 < 8\pi$，仅改变总增益 $K$ 时，两极点的根轨迹为：

$$
\begin{gather}
x^2 + y^2 = \frac{4 K}{\tau_P} = -\frac{4x}{\tau_P} 
\Longleftrightarrow 
\left(x - \frac{2}{\tau_P}\right)^2 + y^2 = \left(\frac{2}{\tau_P}\right)^2
\end{gather}
$$


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-01-17-19_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>





### 3.2 Discrete-Time Analysis

前面所有的分析都是在基于连续时间域得到的，具体而言，我们作了下面几条假设：
- averaged-response
- continuous-time
- constant-element
- ideal-transmission

但是，当环路总增益过高，或者环路带宽过高时 (一般认为 $\omega_{BW} > \omega_{in}/10$)，粒度效应 (granularity effect) 变得明显，上述假设就不能再近似成立了，此时系统的行为更倾向于 discrete sampled system 而不是连续时间系统。

论文指出，即使在环路带宽很小的情况下，我们也需要注意系统的离散性。也就是说，利用 z 变换对环路进行建模，得到特征函数 (传递函数的分母) 如下：

$$
\begin{gather}
D(z) = (z - 1)^2 + (z - 1)\frac{2\pi K'}{\omega_{in}\tau_P}\left(1 + \frac{2\pi}{\omega_{in}\tau_P}\right) + \frac{4\pi^2 K'}{\omega_{in}^2\tau_P^2}
,\quad K' = K \tau_P
\end{gather}
$$

我们知道, 在 z 变换中，传递函数的 stability limit 是单位圆，而上述方程中两个极点的根轨迹如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-15-01-54-58_[F. Gardner] Charge-Pump Phase-Lock Loops.png"/></div>

也就是说，要在离散时间域上保证 PLL 的收敛性，需要满足：
$$
\begin{gather}
K' = K\tau_P < \frac{1}{\frac{\pi}{\omega_{in}\tau_P}\left(1 + \frac{\pi}{\omega_{in}\tau_P}\right)} 
\Longleftrightarrow 
K_{VCO}I_P < \frac{\frac{2\omega_{in}}{R_P}}{1 + \frac{\pi}{\omega_{in}R_PC_P}} = \frac{2\omega_{in}}{R_P + \frac{\pi}{\omega_{in}C_P}}
\end{gather}
$$

这便是前半篇论文的精华所在。当然，一般情况下我们会用 **3.1 continuous-time analysis** 一节中的公式来确定各个参数的值，一般都选择 $\zeta = \frac{\sqrt{2}}{2}$ 以获得最佳 transient response.

### 3.3 Ripple analysis

Ripple (纹波) 也是导致粒度效应的重要原因之一。

由于 LPF 中 $C_P$ 的电压不会瞬间发生变化，在每个 charging 开始和结束瞬间, LPF 的输出电压 (也即 VCO 的控制电压) $V_{cont} = I_P R_P + V_{C_P}$ 都会出现 $(\Delta V)_{ripple} = I_P R_P$ 的瞬时变化，形成电压纹波。这使得 VCO 出现频率偏移 (frequency excursion) $(\Delta \omega)_{ripple} = K_{VCO}I_PR_P = 2 \pi K$，最终导致这段 charging 时间 $t_P$ 内出现相位抖动 $(\Delta \theta)_{ripple} = 2\pi K |\theta_e|/\omega_{in}$.

上面的电压纹波还可能导致 VCO 的 "overloading", 也就是 $V_{cont}$ 超过一定值时， VCO 不能正常工作，轻则罢工，重则导致电路损坏。实际设计时需要保证控制电压一直在 VCO 的正常输入范围内。

一般情况下，合理的 overload limit 比 stability limit 更强，也就是满足 overload limit 就基本上满足了 stability limit. 下面是一个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-15-02-23-25_[F. Gardner] Charge-Pump Phase-Lock Loops.png"/></div>

再次强调，上面所有关于粒度效应的讨论中，我们都默认所有的传输都是无延迟的 (ideal transmission)。 
If transitions can be missing at random, as in bit-clock recovery applications, then there may be a data-pattern-dependent jitter induced into the VCO phase. 
这个问题并不在本论文的讨论范围中。

## 4. Third-Order PLL

上面 $V_{cont}$ 所具有的纹波 $(\Delta V)_{ripple}$ 及其导致的频率偏移 (抖动) 通常比较大，在实际应用中难以接受，因此需要对 LPF 进行改进以降低纹波和抖动，这便引出了 third-order PLL.

### 4.1 Passive LPF

最简单的方法便是给 LPF 并联一个滤波电容 $C_2 = \alpha C_P$, 此时 LPF 的阻抗变为：

$$
\begin{gather}
Z_F(s) = \frac{1 + s R_P C_P }{sC_P(1 + \alpha + \alpha R_P C_P s)} = \frac{1 + s R_P C_P }{\alpha R_P C_P ^2 s^2 + (1 + \alpha)C_P s} = \frac{1 + s \tau_P}{sC_P(1 + \alpha + \alpha \tau_P s)}
\end{gather}
$$

根据实际电路情况和噪声性能要求，$\alpha = \frac{C_2}{C_P}$ 的值通常取 $\frac{1}{20} \sim \frac{1}{5}$ 不等, 太小则滤波效果不好，太大则恶化系统的动态性能。

### 4.2 Active LPF

另一种想法是用有源滤波器作为 LPF 以获得更佳的滤波效果，论文给出了下图作为一个例子，但是没有进一步的分析。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-15-15-57-11_[F. Gardner] Charge-Pump Phase-Lock Loops.png"/></div>

### 4.3 Third-Order Properties

将 **4.1 Passive LPF** 中给出的阻抗 $Z_F(s)$ 代入传递函数，得到三阶闭环传递函数如下：

$$
\begin{gather}
H_{CL}(s) = \frac{I_P \,K_{\textrm{VCO}} \,{\left(C_P \,R_P \,s+1\right)}}{I_P \,K_{\textrm{VCO}} +2\,\pi \,C_P \,s^2 +2\,\pi \,C_P \,\alpha \,s^2 +2\,\pi \,{C_P }^2 \,R_P \,\alpha \,s^3 +C_P \,I_P \,K_{\textrm{VCO}} \,R_P \,s}
\\
\Longrightarrow 
H_{CL}(s) = \frac{\frac{K}{1 + \alpha} \left(s + \frac{1}{\tau_P}\right)}{\frac{\alpha}{\alpha + 1}\tau_P s^3 + s^2 + \frac{K}{1 + \alpha}s + \frac{K}{(1 + \alpha)\tau_P}}
\end{gather}
$$

假设 $\alpha$ 足够小，由 $\alpha$ 所产生的极点为：

$$
\begin{gather}
p_3 \approx -\frac{1 + \frac{1}{\alpha}}{\tau_P} \approx -\frac{1}{\alpha\,\tau_P},\quad |p_3| = \frac{1}{\alpha\,\tau_P}
\end{gather}
$$

由于 $\alpha$ 足够小，对 $p_{1,2}$ 的影响可以忽略不计，两个主极点的模 $|p_{1,2}| = \frac{2\zeta}{\tau_P}$ 仍保持不变。并且 $\frac{1}{\alpha} \gg 2\zeta \Longrightarrow  |p_3| \gg |p_{1,2}|$，使得新产生的极点对系统动态性能几乎没有影响。

与之前的思路类似，我们接着来研究系统在离散时间域 (z 变换) 下的特征函数，并由此确定系统收敛时总增益 $K' = K\tau_P$ 的最大值。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-15-17-00-01_[F. Gardner] Charge-Pump Phase-Lock Loops.png"/></div>

<!-- $$
\begin{gather}
\beta = \exp \left(-\frac{2\pi \left(1 + \frac{1}{\alpha}\right)}{\omega_{in}\tau_P}\right)
,\quad 
G = \frac{2\pi K}{(1 + \alpha)\omega_{in}}
\\
D(z) = z^3 + z^2 \left[- \beta - 2 + G \left(\frac{2\pi}{\omega_{in}\tau_P} + \frac{1 - \beta}{1 + \alpha}\right)\right] + z \left[2 \beta + 1 - G \left(\frac{2\pi \beta}{\omega_{in}\tau_P} + \frac{1 - \beta}{1 + \alpha}\right) \right] - \beta
\\
K'_{\max} = (K\tau_P)_{\max} = \frac{4}{}
\end{gather}
$$
 -->

## 5. Overall Transient Response

上面所有的分析都基于 small-signal, 也就是系统面对小信号输入 ($\Delta \phi$ or $\Delta \omega$) 时的动态性能。但是锁相环在 "捕获" 过程中面对的是大信号输入，这就需要从时域的角度来研究系统 "启动 > 捕获 > 锁定" 的整个瞬态响应。



对于 simple PLL (type-I) 的情况，我们已经在文章 [Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL](<AnalogIC/Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.md>) 中的 **2.2 Simple PLL Structure** 一节作了详细讨论，这里直接给出结果：

$$
\begin{gather}
\phi_{out}(t) = \omega_{in} t - \frac{\omega_{0} - \omega_{in}}{A} + \left(\frac{\omega_{0} - \omega_{in}}{A} + \varphi_0\right) \cdot e^{At}
\\
\Delta \phi(t) = \phi_{out}(t) - \phi_{in}(t) = \frac{\omega_{in} - \omega_{0}}{A} + \left(\frac{\omega_{0} - \omega_{in}}{A} + \varphi_0\right) \cdot e^{At}
\end{gather}
$$

式中 $A = K_{PD}K_{VCO}$ 是 type-I PLL 的总增益。

论文中并没有给出 (second-order) type-II PLL 瞬态响应的具体推导过程，但是给出了大信号输入下的瞬态响应图像，图中 $K\tau_P = 2 \Longleftrightarrow \zeta = \frac{\sqrt{2}}{2}$：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-15-17-29-48_[F. Gardner] Charge-Pump Phase-Lock Loops.png"/></div>