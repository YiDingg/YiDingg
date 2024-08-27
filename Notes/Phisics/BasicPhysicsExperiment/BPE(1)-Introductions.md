# Basic Physics Experiment (1): Introductions 

本节课为绪论课，主要介绍物理实验的基本知识和实验方法。

相关资料：
- 辅导资料：
  - [物理实验基础.pdf](https://www.writebug.com/static/uploads/2024/8/26/b42b3ac87db6c5f377d3cd92d73f44fc.pdf)
  - [数据分析讲义.pdf](https://www.writebug.com/static/uploads/2024/8/26/e172607a4f225c03c32d06404fdc30d3.pdf)

## 实验数据记录与分析

### 误差

一般情况下，理论与实验偏差在 $3\sigma$ 内，若偏差超过 $5\sigma$，则可能引发物理学新革命。

误差一般分为三种：
- 统计误差（即随机误差，random errors）：完全随机，可以用统计分布讨论
- 系统误差（systematic errors）：由于测量方法本身导致的误差，或对特定输入信息理解不足
- 过失错误（errors）：不应犯的错误，应该避免

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-26-18-45-40_BPE(1)-Introductions.png"/></div>

数据、误差位数：
- 测量值末位应与误差末位相同：$7.55 \pm 0.02\ (\checkmark)$，$7.55 \pm 0.1 (\times)$
- 误差不小于测量精度
- 需要对多个测量值进行运算时，可将测量值多写一位估计值
- 误差最多写两位有效数字 $8.62 \pm 0.25 (\checkmark)$，$8.623 \pm 0.252 (\times)$

可以理解成一定置信概率下的置信区间。

数字式仪器误差根据仪器精度等级给出，刻度式仪器误差由最小刻度决定。一般情况下，模拟仪器的极限误差（置信概率 100%）为该设备分度值的一半，数字仪器的极限误差为该设备的分度值。
例如一把直尺（模拟仪器），最小分度值为 $1\ \mathrm{mm}$，读数为 $124\ \mathrm{mm}$，那么最后的结果应为 $ 124.0 \pm 0.5\ \mathrm{mm}$。


依据 PDG 手册数据修约规则，对误差的前3位有效数字（测量值末位与误差末位相同）：
- 位于 $100 \sim 354$：保留两位有效数字
- 位于 $355 \sim 949$：保留一位有效数字
- 位于 $950 \sim 999$：修约为 $1000$，保留一位有效数字

例如：
- $1.827 \pm 0.119 \to 1.83 \pm 0.12$
- $1.827 \pm 0.367 \to 1.8 \pm 0.4 $
- $1.827 \pm 0.966 \to 2 \pm 1$

<!-- 
对于一组数据的宽度估计（等价于求 $\sigma$），当数据量不大的情况下（$N \leqslant 10$），我们很难得到一个平滑的直方图，无法得到较好的数据分布函数，因此不便求数据的标准差。这时一般采用如下方法：

- 计算数据平均值 $\bar{x}$
- 计算数据最大偏差 $d = \max\{ x_{\mathrm{max}}-\bar{x},\ \bar{x} - x_{\mathrm{min}} \}$
- 标准差 $\sigma = \frac{2}{3}d$
 -->

### 期望值、方差

考虑连续概率密度为 $f(x)$ 的随机变量 $x$，期望值 $E[x]$（也记为 $\mu$）、方差 $V[x]$、标准差 $\sigma$ 分别定义为：

$$
\begin{gather}
E[x] = \int xf(x) dx, \\ 
V[x] = E\left[ (x-E[x])^2 \right] = E[x^2] - \mu^2 \\ 
\sigma = \sqrt{V[x]} = \sqrt{E[x^2] - \mu^2}
\end{gather}
$$

### 高斯分布

高斯分布也称为正态分布，记作 $N(\mu, \sigma^2)$，定义为：

$$
\begin{equation}
f(x; \mu, \sigma^2) = \frac{1}{\sqrt{2\pi\sigma^2}}e^{-\frac{(x-\mu)^2}{2\sigma^2}}
\end{equation}
$$

特别地，称 $N(0,1)$ 为标准正态分布：
$$
\begin{equation}
\phi(x) = \frac{1}{\sqrt{2\pi}}e^{-\frac{x^2}{2}}
\end{equation}
$$

### 合并结果

对于多种方法的多次测量，可以合并结果如下：

$$
\begin{equation}\displaystyle
a = \frac{\sum_i \frac{a_i}{\sigma_i^2}}{\sum_i \frac{1}{\sigma_i^2}}
\end{equation}
$$
 
## 实验误差传递

协方差 $\sigma_{xy}$（covariance）、相关系数 $\rho_{xy}$（correlation coefficient）：

$$
\begin{gather}
\sigma_{xy}=\mathrm{cov}[x,y]=E[(x-\mu_x)(y-\mu_y)]=E[xy]-\mu_x\mu_y \\ 
\rho_{xy}=\frac{\mathrm{cov}[x,y]}{\sigma_x\sigma_y} = \frac{E[xy]-\mu_x\mu_y}{\sigma_x\sigma_y}
\end{gather}
$$

相关系数无量纲。如果 $x,y$ 相互独立，即 $f(x,y) = f_x(x)f_y(y)$，$E[xy]=\int\int xyf(x,y)\mathrm{d}x\mathrm{d}y=\mu_x\mu_y \Longrightarrow \rho_{xy}=0$
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-27-13-47-45_BPE(1)-Introductions.jpg"/></div>

### 单变量

实验观测（测量）$N$ 次，得到原始数据 $\{ x_1, x_2, \cdots, x_N \}$，则：
- 实验观测量 $x$：$\bar{x} \pm \sigma_{\bar{x}}$
- 导出量 $f(x)$：$f(\bar{x}) \pm \sigma_f$

参考 [物理实验中各种不确定度和误差怎么区分和使用](https://www.zhihu.com/question/647340878/answer/3421575035) 可以知道，不确定度 $ \sigma_{\bar{x}} $ 由两部分构成，为方便计算，在此给出公式（置信区间为一个 $\sigma$，置信概率约 $0.683$，也即 $\sigma_A = \sigma$）：
$$
\begin{align}
\sigma_{\bar{x}}^2
&= \sigma_A^2+\sigma_B^2 = \frac{\sigma_x^2}{N} +\sigma_B^2 
= \frac{\sum_{i=1}^N(x_i - \bar{x})^2}{N(N-1)} +\sigma_B^2 \\
&= \frac{\sum_{i=1}^N x_i^2}{N(N-1)} - \frac{\bar{x}^2}{N-1} +\sigma_B^2 = \frac{\overline{x^2} - \overline{x}^{\,2}}{N-1} +\sigma_B^2 
\end{align}
$$

$$
\begin{gather}
 \sigma_f^2 = \left(\frac{\partial f }{\partial x }\right)^2 \sigma_{\bar{x}}^2 
=  \left(\frac{\partial f }{\partial x }\right)^2 \cdot \left(\frac{\overline{x^2} - \overline{x}^{\,2}}{N-1}  +\sigma_B^2 \right)
\end{gather}
$$

设 $\Delta$ 为仪器的极限不确定度，则 $\sigma_B$：
$$
\begin{gather*}
 \sigma_B = 0.683 \Delta\ \  （正态，P = 0.683） \\
 \sigma_B = 0.533 \Delta\ \  （均匀，P = 0.533） 
\end{gather*}
$$




有时计算方差用 $\sigma_x^2 = \sum_{i=1}^N \frac{(x_i - \bar{x})^2}{N}$，此时 $\sigma_{A} = \frac{\sigma_x}{\sqrt{N}} = \sqrt{\frac{\overline{x^2} - \overline{x}^{\,2}}{N}} $（何时用 $N$ 何时用 $N-1$）。


### 双变量

实验观测（测量）$N$ 次，得到原始数据 $\{ (x_1,y_1), (x_2,y_2), \cdots, (x_N,y_N) \}$，则：

- 实验观测量 $x$：$\bar{x} \pm \sigma_x$
- 实验观测量 $y$：$\bar{y} \pm \sigma_y$
- 导出量 $f(x,y)$：$f(\bar{x},\bar{y}) \pm \sigma_f$

$$
\begin{gather}
\sigma_{f}^{2}=\left(\frac{\partial f}{\partial x}\right)^{2}\sigma_{\bar{x}}^{2}+\left(\frac{\partial f}{\partial y}\right)^{2}\sigma_{\bar{y}}^{2}+2\frac{\partial f}{\partial x}\frac{\partial f}{\partial y}\sigma_{xy} \\ 
\sigma_{xy}=\frac{1}{N-1}\sum_i^N(x_i-\bar{x})(y_i-\bar{y})
\end{gather}
$$

若 $x,y$ 相互独立，则协方差 $\sigma_{xy} = 0 \Longrightarrow \sigma_f = \left(\frac{\partial f }{\partial x }\right) \sigma_x^2$.

极限误差：

$$
\begin{equation}
e_f=|\frac{\partial f}{\partial x}|e_x+|\frac{\partial f}{\partial y}|e_y
\end{equation}
$$

### 举例

## 补充阅读

- [【知识仓库】误差分析（一）何为误差](https://zhuanlan.zhihu.com/p/617547866)
- [【知识仓库】误差分析（二）测量误差](https://zhuanlan.zhihu.com/p/617068836)
- [【知识仓库】误差分析（三）误差传递](https://zhuanlan.zhihu.com/p/617554206)
- [物理实验中各种不确定度和误差怎么区分和使用](https://www.zhihu.com/question/647340878/answer/3421575035)





