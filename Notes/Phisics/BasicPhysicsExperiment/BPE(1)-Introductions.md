# Basic Physics Experiment (1): Introductions 

本节课为绪论课，主要介绍物理实验的基本知识和实验方法。

相关资料：
- 辅导资料：
  - [物理实验基础.pdf](https://www.writebug.com/static/uploads/2024/8/26/b42b3ac87db6c5f377d3cd92d73f44fc.pdf)
  - [数据分析讲义.pdf](https://www.writebug.com/static/uploads/2024/8/26/e172607a4f225c03c32d06404fdc30d3.pdf)

## 实验数据记录与分析

### 误差

误差一般分为三种：
- 统计误差：完全随机，可以用统计分布讨论
- 系统误差：由于测量方法本身导致的误差，或对特定输入信息理解不足
- 过失错误：不应犯的错误，应该避免

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-26-18-45-40_BPE(1)-Introductions.png"/></div>

数据、误差位数：
- 测量值末位应与误差末位相同：$7.55 \pm 0.02\ (\checkmark)$，$7.55 \pm 0.1 (\times)$
- 误差不小于测量精度
- 需要对多个测量值进行运算时，可将测量值多写一位估计值
- 误差最多写两位有效数字 $8.62 \pm 0.25 (\checkmark)$，$8.623 \pm 0.252 (\times)$

数字式仪器误差根据仪器精度等级给出，刻度式仪器误差一般为最小刻度。

<span style='color:red'> 改掉不给误差的坏习惯！ </span>

依据 PDG 手册数据修约规则，对误差的前3位有效数字：
- 位于 $100 \sim 354$：保留两位有效数字
- 位于 $355 \sim 949$：保留一位有效数字
- 位于 $950 \sim 999$：修约为 $1000$，保留一位有效数字

例如： 
- $1.827 \pm 0.119 \to 1.83 \pm 0.12$
- $1.827 \pm 0.367 \to 1.8 \pm 0.4 $
- $1.827 \pm 0.966 \to 2 \pm 1$

### 期望值、方差

考虑概率密度为 $f(x)$ 的随机变量 $x$，期望值 $E[x]$（也记为 $\mu$）、方差、标准差分别定义为：

$$
\begin{gather}
E[x] = \int xf(x) dx, \\ 
V[x] = E\left[ (x-E[x])^2 \right] = E[x^2] - \mu^2 \\ 
\sigma = \sqrt{V[x]}
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





