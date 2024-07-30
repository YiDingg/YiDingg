# Mathematical Modeling (4): Differencial Equation

考虑到数学建模得到的微分方程（组）常常具有不平凡的初始条件和边界条件，通常难以求得解析解，因此本文着重考虑微分方程的数值解。

利用 Matlab 求数值解，我们有多种方法。例如，手动实现有限差分算法、利用 Matlab 的 `ode` 函数求解 ODE、利用 Matlab 的 `pdepe` 函数求解 PDE、利用 pdetool 工具箱等。

`ode`函数、`pdepe` 函数和 pdetool 工具箱能够解决的问题十分有限，有限差分法更为普适，也是我们重点关注的对象。

## ODE

## PDE

## 有限差分法

### Intro

有限差分法是一种求解微分方程（包括常微分方程和偏微分方程）的数值方法，它对微分进行离散近似，使用某一点周围若干点的函数值的线性组合近似表示该点的微分，从而将微分方程（组）转化为线性差分方程组。

有限差分法在工程中的应用非常广泛，分类也十分丰富。依被求解函数的变元个数，可分为一维（一元，也即 ODE）、二维…… $n$ 维（$n$ 元）；依近似时截断阶数的不同，可分为一阶…… $n$ 阶；依近似的方式，又可分为显式（向前）、中心、隐式（向后）差分。

下面将从有限差分法的原理、基本差分公式、误差估计等方面进行展开，给出基本的应用方法，对于一些深入的问题不做讨论。

### 原理

有限差分法利用泰勒级数，做适当的截断，结合微分的定义得到微分近似表达式，称为差分公式。每一种差分公式，事实上是一组公式，每一项对应着一个导数，分别给出 $f'(x), f''(x), ..., f^{(n)}(x)$ 的近似表达式。

例如，给定一元函数$f(x)$，我们有：

$$f(x+h)=f(x)+hf^{\prime}(x)+\frac{h^2}2f^{\prime\prime}(x)+\cdots+\frac{h^k}{k!}f^{(k)}(x)+\ldots $$

将上式另写为：

$$f(x+h)=f(x)+hu^{\prime}(x)+\frac{h^2}2u''(x + \xi)$$

其中 $\xi\in(0,h)$，再移项并同除 $h$ 即可以得到一元一阶向前差分公式：

$$f_F^{\prime}(x)=\frac{f(x+h)-f(x)}h-\frac h2u^{\prime\prime}(x+\xi) \approx \frac{f(x+h)-f(x)}h $$

F standing for Forward，同理可以得到一元一阶向后差分和一元二阶中心差分公式（结合 $f(x-h)$ 的泰勒级数）：

$$f'_B(x)=\frac{f(x)-f(x-h)}h+\frac h2u''(x+\xi)\approx \frac{f(x)-f(x-h)}h $$

$$f_C^{\prime}(x)=\frac{f(x+h)-f(x-h)}{2h}-\frac{h^2}6f^{(3)}(x+\xi) \approx \frac{f(x+h)-f(x-h)}{2h}$$

B stands for Backward，C stands for Central.

由最后一项可以看出，上面的中心差分具有三阶精度，而另外两种具有二阶精度。更高阶的差分公式可以由类似的方法，结合对比系数或解线性方程组得到，这里不再赘述。

当变元数量大于等于 1 时（PDE 的情形），需要网格化（离散化）求解区域。以二元函数 $u = u(x,y)$ 为例，假设 $Oxy$ 坐标系中的求解区域为矩形 $[0, a] \times [0, b]$，沿 $x$、$y$ 方向离散为 $n_x$、$n_y$ 个单元（常等分为 $n$ 个单元），则分别有 $n_x+1$、$n_y+1$ 个网格点。两个方向的离散坐标分别记为 $x_i, i = 0, 1, ...,N_x$ 和 $y_j, j = 0, 1, ..., N_y$，各结点的函数值简记为 $u_{i,j} = u(x_i,y_j)$，如图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-28-18-33-08_MM(4)-DifferencialEquation.jpg"/></div>

则可得二元二阶中心差分公式：

$$
\frac{\partial u}{\partial x}=\frac{1}{2h_x}(u_{i+1,j}-u_{i-1,j})\ ,\ \  
\frac{\partial u}{\partial y}=\frac{1}{2h_y}(u_{i,j+1}-u_{i,j-1})\\
\frac{\partial^2u}{\partial x^2}=\frac{1}{h_x^2}(u_{i-1,j}-2u_{i,j}+u_{i+1,j})\ , \ \ 
\frac{\partial^2u}{\partial y^2}=\frac{1}{h_y^2}(u_{i,j-1}-2u_{i,j}+u_{i,j+1})\\ 
\frac{\partial^2u}{\partial x \partial y}=\frac{u_{i,j+1}^{'x}-u_{i,j-1}^{'x}}{2h_y} 
= \frac{1}{4h_xh_y}(u_{i-1,j-1} - u_{i-1,j+1} - u_{i+1,j-1} +u_{i+1,j+1})
$$

其中 $h_x = \frac{a}{N_x}, h_y = \frac{b}{N_y}$ 为求解步长。

物理上常见的形式为 $u = u(t, x)$ ，如下：

$$
\frac{\partial^2u}{\partial t^2}=\frac{u_{i+1,j}-2u_{i,j}+u_{i-1,j}}{h_t^2}, 
\frac{\partial^2u}{\partial x^2}=\frac{u_{i,j+1}-2u_{i,j}+u_{i,j-1}}{h_x^2} 
$$

当然，对于多元函数，不同方向上的差分方式可以有所不同，例如 $x$ 方向上采样中心差分，而 $y$ 方向上采用显示差分（经典欧拉差分）。

### 矩阵方程

有限差分法求微分方程的关键步骤是写出差分方程的矩阵形式，只要写出了矩阵方程，之后的工作都是简单的。但是，随着函数变元个数的增多，矩阵的维度呈指数级增长，这常为求解带来一定困难。

并且，需要注意的是，如果在某个方向上（例如 $x$ 方向）采用中心差分，则求解区域在 $x$ 轴两端的边界值必须已知，即 $u(0,y)$ 和 $u(a,y)$ ，否则无法求解矩阵方程。在工程中，我们常常对 $t$ 方向上的右边界值进行合理猜测，这样才能在 $t$ 方向上使用中心差分。

考虑二阶线性微分方程：

$$
au + b_xu_x' + b_yu_y' + c_{xx}u_{xx}'' + c_{xy}u_{xy}'' + c_{yy}u_{yy}'' = \phi(x,y) \\ 
\mathrm{s.t.} \ \begin{cases}u(0,y)=d(y),\mathrm{~}u(a,y)=e(y)\\u(x,0)=f(x),\mathrm{~}u(x,b)=g(x)\end{cases}
$$

$u_{xy}$ 的情况比较少见，为简化模型，不妨令 $c_{xy} = 0$ ，将上面的二元二阶中心差分公式代入，得到：

$$
\begin{align*}
&u_{i-1,j-1}  \cdot 0\   + \\ 
&u_{i-1,j}  \cdot (-\frac{b_x}{2h_x} + \frac{C_{xx}}{h_x^2} )\  + \\ 
&u_{i,j-1}  \cdot (-\frac{b_y}{2h_y} + \frac{C_{yy}}{h_y^2})\  + \\ 
&u_{i,j}    \cdot (a - \frac{2C_{xx}}{h_x^2}-\frac{2C_{yy}}{h_y^2})\ + \\ 
&u_{i+1,j}  \cdot (\frac{b_x}{2h_x} + \frac{C_{xx}}{h_x^2})\   + \\ 
&u_{i,j+1}  \cdot (\frac{b_y}{2h_y} + \frac{C_{yy}}{h_y^2})\   + \\ 
&u_{i+1,j+1} \cdot 0\   + \\ 
&= \phi_{i,j}\ ,\ \ i = 1, ..., N_x-1, \ j = 1, ..., N_y-1
\end{align*}
$$

将上面方程写为矩阵形式，最终得到（先展开 $j$ 后展开 $i$）：

$$
K\vec{U} = \vec{\Phi} \Longrightarrow \vec{U} = K^{-1}\vec{\Phi}
$$

其中
$$
\vec{U} = \begin{bmatrix}\vec{u}_{1}\\\vec{u}_{2}\\\vdots\\\vec{u}_{N_x-1}\end{bmatrix} =\begin{bmatrix}u_{1,1}\\u_{1,2}\\\vdots\\u_{1,N_y-1}\\u_{2,1}\\\vdots\\u_{N_x-1,N_y-1}\end{bmatrix}_{(N_x-1)(N_y-1)\times 1},\ \vec{u}_i = \begin{bmatrix}u_{i,1}\\u_{i,2}\\\vdots\\u_{i,N_y-1}\end{bmatrix}_{(N_y-1)\times 1}\\ 
$$

简记 $u_{i,j}$ 前的系数为 $\lambda_{i,j} = a - \frac{2C_{xx}}{h_x^2}-\frac{2C_{yy}}{h_y^2}$，$u_{i-1,j}, ..., u_{i,j+1}$ 的系数同理，则有：

$$
K = 
\begin{bmatrix}  
  G & 0 & \cdots & 0 \\  
  0 & G & \cdots & 0 \\  
  \vdots & \vdots & \ddots & \vdots \\  
  0 & 0 & \cdots & G  
\end{bmatrix}_ {(N_x-1)(N_y-1)\times(N_x-1)(N_y-1)}\\
G = 
\begin{bmatrix}
\lambda_{i,j} & \lambda_{i,j+1} & 0 &  &  & & \\
\lambda_{i,j-1} & \lambda_{i,j} & \lambda_{i,j+1} & &  &  & \\
0 & \lambda_{i,j-1} & \lambda_{i,j} & \ddots  &  & & \\
 &  & \ddots & \ddots & \ddots &  & \\
  &  & & \ddots & \lambda_{i,j} & \lambda_{i,j+1} & 0 \\
 &  & &  & \lambda_{i,j-1} & \lambda_{i,j} & \lambda_{i,j+1}  \\
  &  & & & 0&\lambda_{i,j-1} & \lambda_{i,j} \\
\end{bmatrix}_{(N_y-1)\times(N_y-1)}
$$

$$
\vec{\Phi} = 
\begin{bmatrix}
    \vec{\phi}_1 \\ 
    \vec{\phi}_2 \\ 
    \vdots \\ 
    \vec{\phi}_{N_x-1}
\end{bmatrix} + 
\begin{bmatrix}
    \vec{\varphi}_1 \\ 
    \vec{\varphi}_2 \\ 
    \vdots \\ 
    \vec{\varphi}_{N_x-1}
\end{bmatrix}+
(-\lambda_{i,j-1})\begin{bmatrix}
    \vec{u}_0 \\ 
    \vec{0} \\ 
    \vdots \\ 
    \vec{0}
\end{bmatrix}+
(-\lambda_{i,j+1})\begin{bmatrix}
    \vec{0} \\ 
    \vdots \\ 
    \vec{0} \\ 
    \vec{u}_{N_x - 1} \\ 
\end{bmatrix}_{(N_x-1)(N_y-1)\times 1} \\ 
\vec{\phi}_i = 
\begin{bmatrix}\phi_{i,1}\\\phi_{i,2}\\\vdots\\\phi_{i,N_y-1}\end{bmatrix}_{(N_y-1)\times 1},\ 
\vec{\varphi}_i = 
\begin{bmatrix}-\lambda_{i,j-1}\phi_{i,0}\\0\\\vdots\\0\\-\lambda_{i,j+1}\phi_{i,N_y}\end{bmatrix}_{(N_y-1)\times 1}
$$


当边界条件都已知时，未知量的个数和方程的个数是相同的，都为 $(N_x-1)(N_y-1)$，且容易证明线性无关，因此矩阵方程有唯一解。

### 矩阵方程示例

下面是化为矩阵方程的过程示例（先展开 $i$ 后展开 $j$）：

令 $i = 1, 2, 3, ..., N_x-1$，得到方程组（含有 $N_x-1$ 个方程）：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-28-23-25-52_MM(4)-DifferencialEquation.png"/></div>

其中蓝色框出来的数值点在边界上，是我们的已知量而非未知量，因此将他们移到等式右边，得到：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-28-23-26-49_MM(4)-DifferencialEquation.png"/></div>

令 $\vec{\varphi}$、$\vec{b}$ 和矩阵 $G$ 如下：
$$
\vec{\varphi}_j=\begin{bmatrix}\phi_{1,j}\\\phi_{2,j}\\\vdots\\\phi_{N_x-1,j}\end{bmatrix}_{(N_x-1)\times 1},\quad\vec{b}_j=\frac{1}{4}\begin{bmatrix}\phi_{0,j}\\0\\\vdots\\0\\\phi_{N_x,j}\end{bmatrix}_{(N_x-1)\times 1}\\ 
G=\begin{bmatrix}1&-\frac{1}{4}&0&\cdots&0\\-\frac{1}{4}&1&-\frac{1}{4}&&0\\0&-\frac{1}{4}&1&\ddots&\vdots\\\vdots&\vdots&\ddots&\ddots&-\frac{1}{4}\\0&0&\cdots&-\frac{1}{4}&1\end{bmatrix}_{(N_x-1)\times (N_x-1)}
$$
则有：
$$
-\frac{I_{N_x}}{4}\vec{\varphi}_{j-1}+G\vec{\varphi}_j-\frac{I_{N_x}}{4}\vec{\varphi}_{j+1}=\vec{b}_j
$$

再令 $j = 1, 2, ..., N_y-1$，得到矩阵方程组（含有 $N_y-1$ 个矩阵方程）。考虑到 $\vec{\varphi}_0$ 和 $\vec{\varphi}_N$ 都是已知量，写出方程组后移项，令 $\vec{\Phi}$、$\vec{B}$ 和矩阵 $K$ 如下：

$$
\vec{\Phi}=\begin{bmatrix}\vec{\varphi}_1\\\vec{\varphi}_2\\\vdots\\\vec{\varphi}_{N_y-1}\end{bmatrix}_{(N_x-1)(N_y-1)\times 1},\quad \vec{B}=\begin{bmatrix}\vec{b}_1+\frac I4\vec{\varphi}_0\\\vec{b}_2\\\vdots\\\vec{b}_{N-2}\\\vec{b}_{N-1}+\frac I4\vec{\varphi}_{N_y}\end{bmatrix}_{(N_x-1)(N_y-1)\times 1}\\ 
K=\begin{bmatrix}G&-\frac I4&0&\cdots&0\\-\frac I4&G&-\frac I4&\cdots&0\\0&-\frac I4&\ddots&\ddots&\vdots\\\vdots&\vdots&\ddots&G&-\frac I4\\0&0&\cdots&-\frac I4&G\end{bmatrix}_{(N_x-1)(N_y-1)\times (N_x-1)(N_y-1)}
$$

最终得到：

$$
K\vec{\Phi} = \vec{B} \Longrightarrow \vec{\Phi} = K^{-1}\vec{B}
$$



<!-- 
初值处理：
有时边界条件会发生突变，为了减小误差，我们可以作如下处理（以 $\phi = \phi(x,y)$ 为例）：
$$
(\frac{\partial\phi}{\partial x})_0\approx\frac{h_3^2(\phi_1-\phi_0)-h_1^2(\phi_3-\phi_0)}{h_1h_3(h_3+h_1)}, (\frac{\partial^2\phi}{\partial x^2})_0\approx2\frac{h_1(\phi_1-\phi_0)+h_3(\phi_3-\phi_0)}{h_1h_3(h_3+h_1)}
$$

$y$方向上同理。

原理详见 https://zhuanlan.zhihu.com/p/493362666。 -->

### 例子

## pdepe() 函数

## pdetool 工具箱

## References 

知乎：
- [x] [微分方程数值求解——有限差分法](https://zhuanlan.zhihu.com/p/411798670)
- [x] [微分方程数值解法1.1:有限差分方法_定义与误差分析](https://zhuanlan.zhihu.com/p/353590423)
- [ ] [数值计算（三）matlab pdepe()函数 求解一般的偏微分方程组](https://zhuanlan.zhihu.com/p/110277324)
- [ ] [matlab求解偏微分方程 更新中](https://zhuanlan.zhihu.com/p/493362666)
- [ ] [数值计算（三）matlab求解一般的偏微分方程组](https://zhuanlan.zhihu.com/p/110277324)
- [ ] [数值计算（五十二）一维连续介质热传导方程](https://zhuanlan.zhihu.com/p/239710629)
- [ ] [数值计算（七十九）matlab求解复杂偏微分方程](https://zhuanlan.zhihu.com/p/675966238)
- [ ] [数学物理方程 - 第二章 热传导方程](https://zhuanlan.zhihu.com/p/260066673)

论文：