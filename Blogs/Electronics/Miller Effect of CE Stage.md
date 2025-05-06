# Miller Effect of Common-Emitter Stage

> [!Note|style:callout|label:Infor]
Initially published at 23:13 on 2025-03-23 in Beijing.

## Intro 

起因是线电作业 (week 10, 2025.04.28 ~ 2025.05.04) 中有一道题目需要计算 CE stage 的高频截止频率，我们使用了 Miller Approximation 进行计算，同时用 LTspice 对结果进行了验证，最终仿真结果与理论计算一致。关于频响分析和米勒定理的基本内容，详见 [Frequency Response of CE and CS Stages](<Blogs/Electronics/Frequency Response of CE and CS Stages.md>)，我们不再赘述。

下面记录了题目的理论分析与 LTspice 仿真结果。

## Theoretical Analysis

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-29-22-16-56_Miller Effect of CE Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-29-22-17-05_Miller Effect of CE Stage.png"/></div>

## LTspice Simulation

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-29-22-27-48_Miller Effect of CE Stage.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-29-22-27-01_Miller Effect of CE Stage.png"/></div>

仿真结果给出了：

$$
\begin{gather}
\mathrm{LTspice:}\ 
\begin{cases}
R_L = 16 \ \mathrm{k}\Omega, && f_c = 1.1630 \ \mathrm{MHz}\\
R_L = 1.6 \ \mathrm{k}\Omega, && f_c = 1.9238 \ \mathrm{MHz}
\end{cases}
\end{gather}
$$

由于 Miller Approximation 在第一极点的位置用 $- g_m R_L$ 替代了 $\frac{- g_m R_L}{\sqrt{2}}$, 因此会有一定比例的误差。作为一个经验定律，我们在 Miller Approximation 得到的结果上，再乘一个修正系数 1.1, 可以得到：

$$
\begin{gather}
\mathrm{Theoretical:\ }
\begin{cases}
R_L = 16 \ \mathrm{k}\Omega, && f_c = 1.038 \ \mathrm{MHz}\\
R_L = 1.6 \ \mathrm{k}\Omega, && f_c = 1.733 \ \mathrm{MHz}
\end{cases}
\\
\overset{\times 1.1}{\quad  \longmapsto \quad }
\mathrm{Theoretical:\ }
\begin{cases}
R_L = 16 \ \mathrm{k}\Omega, && f_c = 1.1418 \ \mathrm{MHz}\\
R_L = 1.6 \ \mathrm{k}\Omega, && f_c = 1.9063 \ \mathrm{MHz}
\end{cases}
\end{gather}
$$

这样，理论计算的结果便与仿真几乎一致了。

## Accuracy Analysis

作为一条经验定则，我们指出：如果利用 Miller Approximation 得到的第二极点是第一极点的十倍以上，那么 Miller Approximation 对第一极点 (需要乘上修正系数 1.1) 的估计是非常好的。

## 2nd Pole Iteration

<span style='color:red'> 此部分有待研究 </span>

如何用 Miller Theorem 来计算 amp 的第二极点呢？在原始的近似计算中，我们是利用 $-g_m R_L$ 作为增益估计的第一、第二极点，但实际上，在经过第一极点后， BJT 的 base 到 collector 的增益便开始下降，可以近似为一个一阶低通。也就是：

$$
\begin{gather}
A = -g_m R_L \longmapsto A = \frac{-g_m R_L}{1 + \frac{j \omega}{\omega_1}},\quad |A| = \frac{g_m R_L}{\sqrt{1 + \left(\frac{\omega}{\omega_1}\right)^2}}
\end{gather}
$$

其中 $\omega_1$ 是第一极点的角频率。这时，我们利用 $A = A(j\omega)$ 在 (第一次 Miller 时得到的) $\omega_2$ 处的增益大小，来替换原本的 $g_m R_L$，也就是：

$$
\begin{gather}
|A| = \frac{g_m R_L}{\sqrt{1 + \left(\frac{\omega_2}{\omega_1}\right)^2}},\quad 
C_{X} = \left(1 + |A|\right) C_{bc} = \left(1 + \frac{g_m R_L}{\sqrt{1 + \left(\frac{\omega_2}{\omega_1}\right)^2}}\right) C_{bc}
\end{gather}
$$

我们以 $R_L = 16 \ \mathrm{k}\Omega$ 为例，第一次计算 (第一次迭代) 可以得到 (未乘上修正系数):

$$
\begin{gather}
\mathrm{1st\ Iteration:}\ 
f_1 = 1.038 \ \mathrm{MHz},\ f_2 = 36.46\ \mathrm{MHz}
\Longrightarrow 
|A_1| = \frac{g_m R_L}{\sqrt{1 + \left(\frac{f_2}{f_1}\right)^2}} = \frac{84.175}{\sqrt{x}} = 2.3955
\end{gather}
$$

此时，$R_1 = 541.57 \ \Omega$ 和 $R_2 = 1.6 \ \mathrm{k}\Omega \parallel 16 \ \mathrm{k}\Omega = 1.4545 \ \mathrm{k}\Omega$ 仍不变。重新计算等效米勒电容，注意只需计算输出等效电容 $C_Y = \left(1 + \frac{1}{|A_1|}\right) C_{bc}$，因为现在我们是想通过迭代来 (近似) 求解第二极点：

$$
\begin{gather}
\begin{cases}
C_2 = \left(1 + \frac{1}{|A_1|}\right) C_{bc} = 4.2524  \ \mathrm{pF}
\end{cases}
\\
\Longrightarrow 
f_2 =  \frac{1}{2 \pi R_1 C_1} = 25.731 \ \mathrm{MHz}
\end{gather}
$$

