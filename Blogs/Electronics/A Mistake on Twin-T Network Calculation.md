# A Mistake on Twin-T Network Calculation

> [!Note|style:callout|label:Infor]
Initially published at 11:27 on 2025-03-23 in Beijing.

在昨天的 transfer function of twin-T network 计算中，我们犯了一些计算错误，得到了不正确的结果。文本对原计算的错误进行了更正（采用二端口矩阵来计算）。


## Wrong Calculation

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-00-04-19_Classical RC Oscillators.png"/></div>

图中的 $Y$ 是指各元件的导纳，我们利用 MATLAB 求解上述方程：
<!-- <div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-00-04-48_Classical RC Oscillators.png"/></div>
 -->

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-00-05-47_Classical RC Oscillators.png"/></div>

也即：

$$
\begin{align}
H(j\omega)
&= \frac{V_{out}}{V_{in}} 
\\
&=  \frac{{\left(Y_1 +Y_2 \right)}\,{\left(Y_3 \,Y_6 -Y_4 \,Y_5 \right)}}{Y_1 \,Y_3 \,Y_6 -Y_2 \,Y_3 \,Y_5 +Y_1 \,Y_4 \,Y_6 -Y_2 \,Y_4 \,Y_5 }
\\
&=  \frac{{\left(Y_1 +Y_2 \right)}\,{\left(Y_3 \,Y_6 -Y_4 \,Y_5 \right)}}{Y_1 Y_6 (Y_3 + Y_4) - Y_2 Y_5 (Y_3 + Y_4)}
\\
&= \frac{{\left(Y_1 +Y_2 \right)}\,{\left(Y_3 \,Y_6 -Y_4 \,Y_5 \right)}}{(Y_3 + Y_4) (Y_1 Y_6 - Y_2 Y_5) }
\end{align}
$$

代入各元件导纳值，得到：

$$
\begin{gather}
\begin{cases}
Y_1 = j \,\omega\, C\\
Y_2 = \frac{1}{R}\\
Y_3 = j \,\omega\, C\\
Y_4 = \frac{1}{R}\\
Y_5 = \frac{1}{(\frac{R}{2})}\\
Y_6 = j \,\omega\, (2C)
\end{cases}
\Longrightarrow 
H(j\omega) = 1
\end{gather}
$$

<div class='center'>

<span style='color:red'> 这里为什么 $H(s)$ 恒为 1 ？我们已核对过电路图和计算过程，似乎并没有错误，仿真结果也是正常的，那么问题出在哪里？ </span>
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-01-07-14_Classical RC Oscillators.png"/></div>
</div>

## What's the Right Answer

为了寻找答案，我们查阅了一些文章，下面几篇文章/博客都给出了**相同的传递函数**结果：


1. 文章 [Twin-T RC Oscillators](https://electronicspedia.com/Topics/analog_electronics/sinusoidal_oscillators/twin-t_rc_oscillators.html) 给出的传递函数是：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-01-23-10_Classical RC Oscillators.png"/></div>


2. 文章 [双T型陷波滤波器](https://blog.csdn.net/weixin_34405557/article/details/85574624) 给出的传递函数是：
<!-- <div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-01-27-27_Classical RC Oscillators.png"/></div> -->
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-01-27-46_Classical RC Oscillators.png"/></div>

3. 文章 [实验二 单双T网络频率特性](https://max.book118.com/html/2019/0801/7115051026002044.shtm) 给出的传递函数是：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-01-28-28_Classical RC Oscillators.png"/></div>


下面几篇文章给出的是三阶的传递函数结果：

1. 网页 [Twin-T Notch Filter Design Tool](http://sim.okawa-denshi.jp/en/TwinTCRkeisan.html) 给出的传递函数是：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-01-23-57_Classical RC Oscillators.png"/></div>


2. 论文 [Realization of Nonminimum Phase Transfer Functions Using Twin-T RC Networks](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1083308)
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-01-32-10_Classical RC Oscillators.png"/></div>

为了找到这些传递函数的推导过程，我们查阅了几篇论文，得到结论：

上面的传递函数都是正常且等价的，对 3 阶的式子，只需消去公因式，即可得到 2 阶的结果。之所以后面两篇会出现 3 阶，是因为它是由 Y-matrix 间接计算得到，也就是 $T(s) = \frac{V_{2}}{V_1}|_{I_2 = 0} = -\frac{Y_{21}}{Y_{22}}$。参考论文 [The general second-order twin-t and its Application to frequency-emphasizing networks](<https://ieeexplore.ieee.org/document/6768715>) ，全引是：

> E. Lueder, "The general second-order twin-t and its Application to frequency-emphasizing networks," in The Bell System Technical Journal, vol. 51, no. 1, pp. 301-316, Jan. 1972, doi: 10.1002/j.1538-7305.1972.tb01915.x.



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-01-43-47_Classical RC Oscillators.png"/></div>




## Proper Calculation

下面，我们利用二端口网络的参数矩阵来计算传递函数。我们给出 T 型二端口的 Y-Matrix 公式  (即国内教材的 G 矩阵), 以及如何从 Y-Matrix 求 T 型网络的传递函数 $T(s)$:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-12-20-30_A Mistake on Twin-T Network Calculation.png"/></div>

也即：

$$
\begin{align}
Y_{21} 
&= -\frac{1}{R\,{\left(2+C_0 \,R\,\omega \,\mathrm{i}\right)}}+\frac{C^2 \,R_0 \,\omega^2 }{1+2\,C\,R_0 \,\omega \,\mathrm{i}} 
\\
&= -\frac{{\left(-C_0 \,R_0 \,C^2 \,R^2 \,\omega^3 +2\,\mathrm{i}\,R_0 \,C^2 \,R\,\omega^2 +2\,R_0 \,C\,\omega -\mathrm{i}\right)}\,\mathrm{i}}{R\,{\left(2+C_0 \,R\,\omega \,\mathrm{i}\right)}\,{\left(1+2\,C\,R_0 \,\omega \,\mathrm{i}\right)}}
\\
Y_{22} &= \frac{1+C_0 \,R\,\omega \,\mathrm{i}}{R\,{\left(2+C_0 \,R\,\omega \,\mathrm{i}\right)}}+\frac{C\,\omega \,{\left(1+C\,R_0 \,\omega \,\mathrm{i}\right)}\,\mathrm{i}}{1+2\,C\,R_0 \,\omega \,\mathrm{i}}
\\
&= \frac{{\left(-C_0 \,R_0 \,C^2 \,R^2 \,\omega^3 +2\,\mathrm{i}\,R_0 \,C^2 \,R\,\omega^2 +\mathrm{i}\,C_0 \,C\,R^2 \,\omega^2 +2\,\mathrm{i}\,C_0 \,R_0 \,C\,R\,\omega^2 +2\,C\,R\,\omega +2\,R_0 \,C\,\omega +C_0 \,R\,\omega -\mathrm{i}\right)}\,\mathrm{i}}{R\,{\left(2+C_0 \,R\,\omega \,\mathrm{i}\right)}\,{\left(1+2\,C\,R_0 \,\omega \,\mathrm{i}\right)}}
\end{align}
$$

从第一种表达式（两分式相加）可以看出，只要满足 $ j \omega R \frac{C_0}{2} = j \omega (2R_0) C \Longrightarrow \frac{C_0}{C} = \frac{4R_0}{R} $，那么分母会具有公因式，传递函数会从 3 阶降为 2 阶。一个最普遍的做法就是 $R_0 = \frac{R}{2},\ C_0 = 2 C$。为求陷波频率 $f_c$，我们直接设 $C_0 = C \frac{4R_0}{R}$，代入化简：

$$
\begin{gather}
Y_{21} = -\frac{2\,C^2 \,R\,R_0 \,\omega^2 \,\mathrm{i}-\mathrm{i}}{2\,R\,{\left(2\,C\,R_0 \,\omega -\mathrm{i}\right)}},\quad 
Y_{22} = \frac{2\,C\,R\,\omega +4\,C\,R_0 \,\omega +2\,C^2 \,R\,R_0 \,\omega^2 \,\mathrm{i}-\mathrm{i}}{2\,R\,{\left(2\,C\,R_0 \,\omega -\mathrm{i}\right)}}
\end{gather}
$$

由此求得传递函数 $T(j\omega)$ :

$$
\begin{gather}
T(j\omega) = \frac{V_{out}}{V_{in}}|_{I_2 = 0} = - \frac{Y_{21}}{Y_{22}} = \frac{2\,C^2 \,R\,R_0 \,\omega^2 \,\mathrm{i}-\mathrm{i}}{2\,C\,R\,\omega +4\,C\,R_0 \,\omega +2\,C^2 \,R\,R_0 \,\omega^2 \,\mathrm{i}-\mathrm{i}}
\end{gather}
$$

写成更方便观察的形式：

$$
\begin{gather}
T(j \omega) = \frac{2 \,\omega^2\,R\,R_0\,C^2 -1}{2 \,\omega^2\,R\,R_0\,C^2  + \mathrm{i}\,\omega (2 R C + 4 R_0 C) - 1}\\
2 \,\omega_c^2\,R\,R_0\,C^2 -1 = 0 \Longrightarrow 
\omega_c = \frac{1}{\sqrt{2 R R_0} C},\quad f_c = \frac{1}{2 \pi \sqrt{2 R R_0} C}
\end{gather}
$$

由于分子上始终有零点，因此只要满足条件 $C_0 = C \frac{4R_0}{R}$ (任意选择不太离谱的 $R_0$)，都可以起到 ideal-notch band-stop filter 的效果。不妨用 LTspice 仿真来验证我们的猜想，我们分别令 $R_0 = \frac{R}{4},\ \frac{R}{2},\ R$，也就是分别令：

$$
\begin{gather}
R = 10 \ \mathrm{k\Omega},\quad C = 10 \ \mathrm{nF},\quad 
\begin{cases}
R_0 = \frac{R}{4} \\
C_0 = C \\
f_c = 2.2508 \ \mathrm{kHz}
\end{cases}
,\quad 
\begin{cases}
R_0 = \frac{R}{2} \\
C_0 = 2 C \\
f_c = 1.5915 \ \mathrm{kHz}
\end{cases}
,\quad 
\begin{cases}
R_0 = R \\
C_0 = 4 C \\
f_c = 1.1254 \ \mathrm{kHz}
\end{cases}
\end{gather}
$$

仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-12-45-33_A Mistake on Twin-T Network Calculation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-12-55-47_A Mistake on Twin-T Network Calculation.png"/></div>

可以看到，理论预测与仿真结果符合的非常好；