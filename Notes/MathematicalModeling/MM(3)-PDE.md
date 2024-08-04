# Mathematical Modeling (3): PDE

考虑到数学建模得到的微分方程（组）常常具有不平凡的初始条件和边界条件，通常难以求得解析解，因此本文着重考虑微分方程的数值解。

利用 Matlab 求数值解，我们有多种方法。例如，手动实现有限差分算法、利用 Matlab 的 `ode` 函数求解 ODE、利用 Matlab 的 `pdepe` 函数求解 PDE、利用 pdetool 工具箱等。`ode`函数、`pdepe` 函数和 pdetool 工具箱能够解决的问题较为有限，有限差分法更为普适，也是我们重点关注的对象。下面先给出已经构建的 Matlab 函数，实现原理见后文。

文章理论主要参考了书籍[《科学计算中的偏微分方程数值解法 (张文生)》](https://www.writebug.com/static/uploads/2024/8/4/ce21a47157bfcba5b44bf27dbfa9fb1c.pdf)、[《偏微分方程数值解法 (陆金甫)》 ](https://www.writebug.com/static/uploads/2024/8/4/f70d655ff4aed3522498fa632f42d7fe.pdf)和知乎，参考资料详见 References 一节。

介于有限差分法的理论较为繁杂，后续我们会在专栏 Numerical Methods for PDE 中讨论。

## Matlab 有限差分法 

在写 Matlab 代码时要特别注意，把求解区域离散为网格，并将函数离散值存储为 Matlab 矩阵时，矩阵的行号对应纵坐标 $y$，列号对应横坐标 $x$。相当于以矩阵的左上角建立 $Oxy$ 坐标系，向右为 $x$ 轴正方向，向下为 $y$ 轴正方向。这与通常的“行列直觉”不同。

例如，函数 $\phi(x,y) = x^2 + 100y$，将其在区域 $[0, 1]\times [0, 1]$ 上离散为网格，记得到的矩阵为 $A$，则`A(:,1)`对应 $x=0$，而 `A(1,:)` 对应 $y=0$的情况（Matlab 的矩阵索引从 1 开始）。 


### MyPDESolver_2Var_Level2_Center

源代码见 GitHub [here](https://github.com/YiDingg/Matlab/blob/main/MyPDESolver_2Var_Level2_Center.m)。

<details>
<summary>示例：求解二维泊松方程</summary>

$$
\Delta u(x,y) = -2\pi^2\sin(\pi x)\sin(\pi y)\ ,\ \ (x,y) \in [0, 1]\times [0, 1] \\ 
\mathrm{s.t.}\ u(x,0) = u(0,x) = u(0,y) = u(y,0) = 0
$$

解析解：$$u(x,y) = \sin(\pi x)\sin(\pi y)\ ,\ \ (x,y) \in [0, 1]\times [0, 1] \\ $$
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-30-16-17-12_MM(4)-DifferencialEquation.jpg"/></div>


数值解（$N_x = N_y = 50$）：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-30-16-17-52_MM(4)-DifferencialEquation.jpg"/></div>

相对误差图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-30-16-28-02_MM(4)-DifferencialEquation.jpg"/></div>

可以看到，相对误差的数量级仅为 $10^{-4}$，一般情况下完全可以忽略。

``` matlab 
% 定义结构体
    PdeProblem.N_x = 50;
    PdeProblem.N_y = 50;

    PdeProblem.x_beg = 0;
    PdeProblem.x_end = 1;
    PdeProblem.y_beg = 0;
    PdeProblem.y_end = 1;

    PdeProblem.a = 0;
    PdeProblem.b_x = 0;
    PdeProblem.b_y = 0;
    PdeProblem.c_xx = 1;
    PdeProblem.c_yy = 1;
    PdeProblem.PhiIsZero = false;
    PdeProblem.phi = @(x,y) -2*pi^2*sin(pi*x).*sin(pi*y);    % 注意要用 .^ .* ./ 等符号
    
    PdeProblem.u_xbeg_y = @(y) 0;
    PdeProblem.u_xend_y = @(y) 0;
    PdeProblem.u_x_ybeg = @(x) 0;

    PdeProblem.u_x_yend = @(x) 0;

% 调用函数
PdeProblem = MyPDESolver_2Var_Level2_Center(PdeProblem);
MySurf(PdeProblem.X,PdeProblem.Y,PdeProblem.Result, false)
```


</details>

<details>
<summary>示例：求解连续介质热传导方程</summary>

$$
T_t'(t,x) = kT_{xx}''(t,x) \\ 
\mathrm{s.t.}\ T(0,x) = T_0\ ,\ \ T(t,0) = T_1,\ T(t,x_{\mathrm{end}}) = T_2
$$

数值解（$N_x = N_y = 50$）：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-30-21-47-10_MM(4)-DifferencialEquation.jpg"/></div>

``` matlab 
k = 2;
% 定义结构体
    PdeProblem.N_x = 50;
    PdeProblem.N_y = 20;

    PdeProblem.x_beg = 0;
    PdeProblem.x_end = 0.5;
    PdeProblem.y_beg = 0;
    PdeProblem.y_end = 1;

    PdeProblem.a = 0;
    PdeProblem.b_x = 1;
    PdeProblem.b_y = 0;
    PdeProblem.c_xx = 0;
    PdeProblem.c_yy = -k;
    PdeProblem.PhiIsZero = true;
    PdeProblem.phi = @(x,y) 0;    % 注意要用 .^ .* ./ 等符号
    
    PdeProblem.u_xbeg_y = @(y) 0;
    PdeProblem.u_xend_y = @(y) 10*y;
    PdeProblem.u_x_ybeg = @(x) 0;
    PdeProblem.u_x_yend = @(x) 10;

% 调用函数
PdeProblem = MyPDESolver_2Var_Level2_Center(PdeProblem);
% MySurf(PdeProblem.X,PdeProblem.Y,PdeProblem.Result, false)
MyMesh(PdeProblem.X,PdeProblem.Y,PdeProblem.Result,1);
```

</details>

### MyPDESolver_2Var_Level2_Center_DF

`MyPDESolver_2Var_Level2_Center` 采用的是中心差分 Richardson 格式，稳定性较差，`MyPDESolver_2Var_Level2_Center_DF` 采用的是 DuFort-Frankel (DF) 格式，它是无条件 $L^2$ 稳定的。

源码见 GitHub here。

### MyPDESolver_2Var_Level2_Forward



### MyPDESolver_2Var_Level2_Backward

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

则可得二元二阶中心差分公式（R 格式）：

$$
u_x'=\frac{1}{2h_x}(u_{i+1,j}-u_{i-1,j})\ ,\ \  
u_y'=\frac{1}{2h_y}(u_{i,j+1}-u_{i,j-1})\\
u_{xx}''=\frac{1}{h_x^2}(u_{i-1,j}-2u_{i,j}+u_{i+1,j})\ , \ \ 
u_{yy}''=\frac{1}{h_y^2}(u_{i,j-1}-2u_{i,j}+u_{i,j+1})\\ 
u_{xy}''=\frac{u_{i,j+1}^{'x}-u_{i,j-1}^{'x}}{2h_y} 
= \frac{1}{4h_xh_y}(u_{i-1,j-1} - u_{i-1,j+1} - u_{i+1,j-1} +u_{i+1,j+1})
$$

其中 $h_x = \frac{a}{N_x}, h_y = \frac{b}{N_y}$ 为求解步长。

物理上常见的形式为 $u = u(t, x)$ ，如下：

$$
u_{tt}''=\frac{u_{i+1,j}-2u_{i,j}+u_{i-1,j}}{h_t^2}, 
u_{xx}''=\frac{u_{i,j+1}-2u_{i,j}+u_{i,j-1}}{h_x^2} 
$$

当然，对于多元函数，不同方向上的差分方式可以有所不同，例如 $x$ 方向上向前差分（the Euler explicit scheme），而 $y$ 方向上采用中心差分。


## 二元二阶中心差分（R）

中心差分具有较高的精度，也是最常用的方法之一，我们先推导中心差分，再讨论其他情形。事实上，中心差分也有多种格式，这里讨论的是 Richardson 格式，其它还有 DuFort-Frankel (DF), Lax-Wendroff (LW) 格式等。

我们所说的“二元二阶中心差分”，“二元”是指待求函数有两个自变量，“二阶”指泰勒展开在二阶处截断，例如 $u(x+h) = u(x) + hu(x)' + \frac{h^2}{2}u(x)'' + o(h^2)$。特别地，中心差分精度比截断阶数要更高一级。例如，在二阶处截断时，向前和向后差分仅具有二阶截断精度，而中心差分具有三阶截断精度。

必须指出的是，虽然 Richardson 格式无条件具有 (2,2) 阶局部截断误差 $o(h_x^2 + h_y^2)$. 但是，它无法用于大规模的数值运算，这是因为它的稳定性（相容性、收敛性）不佳，在许多问题中无法得到收敛解。作为一个著名的反面教材, 它让人们意识到数值稳定的重要性。具体可参考 [here](https://zhuanlan.zhihu.com/p/129681229)。一个较好的改进方法是采用 DuFort-Frankel 格式，它是无条件 $L^2$ 模稳定的，我们将在后文讨论。


### 矩阵方程

有限差分法求微分方程的关键步骤是写出差分方程的矩阵形式，只要写出了矩阵方程，之后的工作都是简单的。但是，随着函数变元个数的增多，矩阵的维度呈指数级增长，这常为求解带来一定困难。

并且，需要注意的是，如果在某个方向上（例如 $x$ 方向）采用中心差分，则求解区域在 $x$ 轴两端的边界值必须已知，即 $u(0,y)$ 和 $u(a,y)$ ，否则无法求解矩阵方程。在工程中，我们常常对 $t$ 方向上的右边界值进行合理猜测，这样才能在 $t$ 方向上使用中心差分。

考虑二阶线性微分方程：

$$
au + b_xu_x' + b_yu_y' + c_{xx}u_{xx}'' + c_{xy}u_{xy}'' + c_{yy}u_{yy}'' = \phi(x,y) \\ 
\mathrm{s.t.} \ \begin{cases}u(x_{\mathrm{beg}},y)=d(y),\mathrm{~}u(x_{\mathrm{end}},y)=e(y)\\u(x,y_{\mathrm{beg}})=f(x),\mathrm{~}u(x,y_{\mathrm{end}})=g(x)\end{cases}
$$

将上面的二元二阶中心差分公式代入，可以得到由 $u_{i-1,j-1},\  u_{i-1,j},\  u_{i,j-1},\  u_{i,j},\  u_{i+1,j},\  u_{i,j+1},\  u_{i+1,j+1}$ 构成的线性方程（组）。$u_{xy}$ 系数非零的情况比较少见，为简化模型，不妨令 $c_{xy} = 0$。另外，为叙述方便，分别将 $u_{i-1,j-1},\  u_{i-1,j},\  u_{i,j-1},\  u_{i,j},$ $ u_{i+1,j},\  u_{i,j+1},\  u_{i+1,j+1}$ 前的系数简记为 $\lambda_{-1,-1}, \lambda_{-1,0}, \lambda_{0,-1}, \lambda_{0,0}, \lambda_{1,0}, \lambda_{0,1}, \lambda_{1,1}$，则有：

$$
\lambda_{-1,-1}u_{i-1,j-1} + \lambda_{-1,0}u_{i-1,j} + \lambda_{0,-1}u_{i,j-1} + \lambda_{0,0}u_{i,j} + \lambda_{0,1}u_{i,j+1} + \lambda_{1,0}u_{i+1,j}  + \lambda_{1,1}u_{i+1,j+1} = \phi_{i,j}
$$
其中：
$$
\begin{align*}
&\lambda_{-1,-1} = \lambda_{1,1} = 0 \\ 
&\lambda_{0,0}  = a - \frac{2c_{xx}}{h_x^2}-\frac{2c_{yy}}{h_y^2} \\ 
&\lambda_{-1,0}  = -\frac{b_x}{2h_x} + \frac{c_{xx}}{h_x^2} \ ,\ \ \lambda_{0,-1}  = -\frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2} \\ 
&\lambda_{1,0}  =  \frac{b_x}{2h_x} + \frac{c_{xx}}{h_x^2}\ ,\ \ \lambda_{0,1}  =  \frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2}\\ 
\end{align*}
$$

依次令$j = 1, 2, ..., N_y-1$，得到：

$$
\begin{cases}
    \hspace{40px} \lambda_{-1,0}u_{i-1,1} + {\color{red}\lambda_{0,-1}u_{i,0}} + \lambda_{0,0}u_{i,1} + \lambda_{0,1}u_{i,2} + \lambda_{1,0}u_{i+1,1}= \phi_{i,1} \\ 
    \hspace{40px} \lambda_{-1,0}u_{i-1,2} + \lambda_{0,-1}u_{i,1} + \lambda_{0,0}u_{i,2} + \lambda_{0,1}u_{i,3} + \lambda_{1,0}u_{i+1,2}= \phi_{i,2} \\ 
    \hspace{140px}\vdots \\
    \lambda_{-1,0}u_{i-1,N_y-1} + \lambda_{0,-1}u_{i,N_y-2} + \lambda_{0,0}u_{i,N_y-1} + {\color{red}\lambda_{0,1}u_{i,N_y}} + \lambda_{1,0}u_{i+1,N_y-1}= \phi_{i,N_y-1} \\ 
\end{cases}
$$

标红的两项在边界上，是我们的已知条件而非未知量，将其移到右侧，并记：
$$
\vec{\phi}_i = 
\begin{bmatrix}\phi_{i,1}\\\phi_{i,2}\\\vdots\\\phi_{i,N_y-1}\end{bmatrix}_{(N_y-1)\times 1},\ 
\vec{\varphi}_i = 
\begin{bmatrix}-\lambda_{0,-1}u_{i,0}\\0\\\vdots\\0\\-\lambda_{0,1}u_{i,N_y}\end{bmatrix}_{(N_y-1)\times 1}, \vec{u}_i = \begin{bmatrix}u_{i,1}\\u_{i,2}\\\vdots\\u_{i,N_y-1}\end{bmatrix}_{(N_y-1)\times 1},\ i \in \{1,...,N_x-1\} \\ 
G = 
\begin{bmatrix}
\lambda_{0,0} & \lambda_{0,1} & 0 &  &  & & \\
\lambda_{0,-1} & \lambda_{0,0} & \lambda_{0,1} & &  &  & \\
0 & \lambda_{0,-1} & \lambda_{0,0} & \ddots  &  & & \\
 &  & \ddots & \ddots & \ddots &  & \\
  &  & & \ddots & \lambda_{0,0} & \lambda_{0,1} & 0 \\
 &  & &  & \lambda_{0,-1} & \lambda_{0,0} & \lambda_{0,1}  \\
  &  & & & 0&\lambda_{0,-1} & \lambda_{0,0} \\
\end{bmatrix}_{(N_y-1)\times(N_y-1)}
$$

则方程组等价于：

$$
\lambda_{-1,0}\vec{u}_{i-1} + G\cdot \vec{u}_i + \lambda_{1,0}\vec{u}_{i+1} = \vec{\phi}_i + \vec{\varphi}_i\ ,\ \ i \in \{1,...,N_x-1\}
$$

简记对角矩阵 $D_m = \lambda_{-1,0}\cdot I_{N_y-1}\ ,\ \ D_p = \lambda_{1,0}\cdot I_{N_y-1}$，依次令 $i = 1,...,N_x-1$，并用类似的思路做移项，又得到：

$$
K\vec{U} = \vec{\Phi} \Longrightarrow \vec{U} = K^{-1}\vec{\Phi}
$$

其中：
$$
\vec{U} = \begin{bmatrix}\vec{u}_{1}\\\vec{u}_{2}\\\vdots\\\vec{u}_{N_x-1}\end{bmatrix} =\begin{bmatrix}u_{1,1}\\u_{1,2}\\\vdots\\u_{1,N_y-1}\\u_{2,1}\\\vdots\\u_{N_x-1,N_y-1}\end{bmatrix}_{(N_x-1)(N_y-1)\times 1} \\
K = 
\begin{bmatrix}
  G&  D_p&  O&\cdots  &O &O \\
  D_m&  G&  D_p&\cdots  &O  &O \\
  O&  D_m&  G&\cdots  &O  &O \\
  \vdots&  \vdots&  \vdots&  \ddots &\vdots  &\vdots \\
  O&  O&  O&  \cdots&  G& D_p\\
  O&  O&  O&  \cdots&  D_m&G
\end{bmatrix}_{(N_x-1)(N_y-1)\times(N_x-1)(N_y-1)}\\ 
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
\begin{bmatrix}
    -\lambda_{-1,0}\vec{u}_0 \\ 
    \vec{0} \\ 
    \vdots \\ 
    \vec{0}
\end{bmatrix}+
\begin{bmatrix}
    \vec{0} \\ 
    \vdots \\ 
    \vec{0} \\ 
    -\lambda_{1,0}\vec{u}_{N_x} \\ 
\end{bmatrix}_{(N_x-1)(N_y-1)\times 1}
$$


当边界条件都已知时，未知量的个数和方程的个数是相同的，都为 $(N_x-1)(N_y-1)$，且容易证明线性无关，因此矩阵方程有唯一解。
<!-- 
### 矩阵方程推导示例

下面是化为矩阵方程的过程示例（先展开 $i$ 后展开 $j$）：

$$
\phi_{i,j}-\frac14(\phi_{i+1,j}+\phi_{i-1,j}+\phi_{i,j+1}+\phi_{i,j-1})=0
$$

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
-\frac{I_{N_x-1}}{4}\vec{\varphi}_{j-1}+G\vec{\varphi}_j-\frac{I_{N_x-1}}{4}\vec{\varphi}_{j+1}=\vec{b}_j
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

 -->

## 二元二阶中心差分（DF）

这里讨论 DuFort-Frankel (DF) 格式，差分公式如下：
$$
u_x'=\frac{1}{2h_x}(u_{i+1,j}-u_{i-1,j})\ ,\ \  
u_y'=\frac{1}{2h_y}(u_{i,j+1}-u_{i,j-1})\\
u_{xx}''=\frac{1}{h_x^2}(u_{i-1,j}-u_{i,j-1}-u_{i,j+1}+u_{i+1,j}) \\
u_{yy}''=\frac{1}{h_y^2}(u_{i,j-1}-u_{i-1,j}-u_{i+1,j}+u_{i,j+1})\\ 
$$

### 矩阵方程

代入二阶线性偏微分方程，得到：

$$
\begin{align*}
& \lambda_{-1,-1} = \lambda_{1, 1} = 0\ ,\  \ \lambda_{0,0}  =  a\\ 
& \lambda_{-1,0} = -\frac{b_x}{2h_x} + \frac{c_{xx}}{h_x^2} - \frac{c_{yy}}{h_y^2}\ ,\ \ \lambda_{0,-1} = -\frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2} - \frac{c_{xx}}{h_x^2}\\ 
& \lambda_{1,0}  =  \frac{b_x}{2h_x} + \frac{c_{xx}}{h_x^2} - \frac{c_{yy}}{h_y^2}\ ,\ \ \lambda_{0,1}  = \frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2} - \frac{c_{xx}}{h_x^2}
\end{align*} 
$$

其余推导过程与之前完全相同，不再赘述。

在 $G\vec{u}_i + \lambda_{1,0}\vec{u}_{i+1} = \vec{\phi}_i + \vec{\varphi}_i$ 中依次令 $i = 0, ..., N_x-1$ 而不是之前的 $1, ..., N_x-1$，得到矩阵方程：

$$
K\vec{U} = \vec{\Phi} \Longrightarrow \vec{U} = K^{-1}\vec{\Phi}
$$

其中：
$$
\vec{U} = \begin{bmatrix}\vec{u}_{1}\\\vec{u}_{2}\\\vdots\\\vec{u}_{N_x}\end{bmatrix} =\begin{bmatrix}u_{1,1}\\u_{1,2}\\\vdots\\u_{1,N_y-1}\\u_{2,1}\\\vdots\\u_{N_x,N_y-1}\end{bmatrix}_{{\color{red}N_x}(N_y-1)\times 1}\\
K = 
\begin{bmatrix}
  D_p&  O&  O&\cdots  &O &O \\
  G&  D_p&  O&\cdots  &O  &O \\
  O&  G&  D_p&\cdots  &O  &O \\
  \vdots&  \vdots&  \vdots&  \ddots &\vdots  &\vdots \\
  O&  O&  O&  \cdots&  D_p& O\\
  O&  O&  O&  \cdots&  G&D_p
\end{bmatrix}_{{\color{red}N_x}(N_y-1)\times {\color{red}N_x}(N_y-1)}\\ 
\vec{\Phi} = 
\begin{bmatrix}
    \vec{\phi}_{\color{red}0} \\ 
    \vec{\phi}_1 \\ 
    \vdots \\ 
    \vec{\phi}_{N_x-1}
\end{bmatrix} + 
\begin{bmatrix}
    \vec{\varphi}_{\color{red}0} \\ 
    \vec{\varphi}_1 \\ 
    \vdots \\ 
    \vec{\varphi}_{N_x-1}
\end{bmatrix}+
\begin{bmatrix}
    G\vec{u}_0 \\ 
    \vec{0} \\ 
    \vdots \\ 
    \vec{0}
\end{bmatrix}_{{\color{red}N_x}(N_y-1)\times 1}
$$

``` matlab 
function PdeProblem = MyPDESolver_2Var_Level2_Center_DF(PdeProblem)
% PDE 求解器（二元，二阶，中心差分， DuFort-Frankel (DF) 格式）

% 若待求函数为 u = u(t,x)
% 方程：a*u + b_t*u_t + b_x*u_x + c_tt*u_tt + c_xx*u_xx = phi(t,x)
% 注：无法解决 u_tx 前系数不为零的方程
% 输入：PdeProblem 结构体
    % PdeProblem.N_t       ：t 轴单元数，步长为 x_end/N_t
    % PdeProblem.N_x       ：x 轴单元数，步长为 x_end/N_x

    % PdeProblem.t_beg     ：t 轴范围 [t_beg, t_end]
    % PdeProblem.t_end     ：t 轴范围 [t_beg, t_end]
    % PdeProblem.x_beg     ：x 轴范围 [x_beg, x_end]
    % PdeProblem.x_end     ：x 轴范围 [x_beg, x_end]

    % PdeProblem.a         ：u 的系数
    % PdeProblem.b_t       ：u_t 的系数
    % PdeProblem.b_x       ：u_x 的系数
    % PdeProblem.c_tt      ：u_tt 的系数
    % PdeProblem.c_xx      ：u_xx 的系数
    % PdeProblem.PhiIsZero ：右侧函数是否为零，ture 或 false
    % PdeProblem.phi       ：右侧函数，@(t,x)

    % PdeProblem.u_xbeg_y  ：边界条件 @(y)
    % PdeProblem.u_xend_y  ：边界条件 @(y)
    % PdeProblem.u_x_ybeg  ：边界条件 @(x)
    % PdeProblem.u_x_yend  ：边界条件 @(x)
% 输出：
% 注：无法解决 u_xy 前系数不为零的方程

% 若待求函数为： u = u(x,y)
% 方程：a*u + b_x*u_x + b_y*u_y + c_xx*u_xx + c_yy*u_yy = phi(x,y)
% 输入：PdeProblem 结构体
    % PdeProblem.N_x       ：x 轴单元数，步长为 x_end/N_x
    % PdeProblem.N_y       ：y 轴单元数，步长为 y_end/N_y

    % PdeProblem.x_beg     ：x 轴范围 [x_beg, x_end]
    % PdeProblem.x_end     ：x 轴范围 [x_beg, x_end]
    % PdeProblem.y_beg     ：y 轴范围 [y_beg, y_end]
    % PdeProblem.y_end     ：y 轴范围 [y_beg, y_end]

    % PdeProblem.a         ：u 的系数
    % PdeProblem.b_x       ：u_x 的系数
    % PdeProblem.b_y       ：u_y 的系数
    % PdeProblem.c_xx      ：u_xx 的系数
    % PdeProblem.c_yy      ：u_yy 的系数
    % PdeProblem.PhiIsZero ：右侧函数是否为零，ture 或 false
    % PdeProblem.phi       ：右侧函数，@(x,y)

    % PdeProblem.u_xbeg_y  ：边界条件 @(y)
    % PdeProblem.u_xend_y  ：边界条件 @(y)
    % PdeProblem.u_x_ybeg  ：边界条件 @(x)
    % PdeProblem.u_x_yend  ：边界条件 @(x)
% 输出：
% 注：无法解决 u_xy 前系数不为零的方程

tic

% 数据准备
    x_beg = PdeProblem.x_beg;
    x_end = PdeProblem.x_end;
    y_beg = PdeProblem.y_beg;
    y_end = PdeProblem.y_end;
    N_x = PdeProblem.N_x;
    N_y = PdeProblem.N_y;
    a = PdeProblem.a;
    b_x = PdeProblem.b_x;
    b_y = PdeProblem.b_y;
    c_xx = PdeProblem.c_xx;
    c_yy = PdeProblem.c_yy;
    phi = PdeProblem.phi;
    u_xbeg_y = PdeProblem.u_xbeg_y;
    u_xend_y = PdeProblem.u_xend_y;
    u_x_ybeg = PdeProblem.u_x_ybeg;
    u_x_yend = PdeProblem.u_x_yend;
    
    h_x = x_end/N_x;
    h_y = y_end/N_y;
     
    lam_m0 = -b_x/(2*h_x) + c_xx/h_x^2 - c_yy/h_y^2;         % lamda_{-1,0}
    lam_0m = -b_y/(2*h_y) + c_yy/h_y^2 - c_xx/h_x^2;         % lamda_{0，-1}
    lam_00 = a;   % lamda_{i, j}
    lam_p0 = b_x/(2*h_x) + c_xx/h_x^2 - c_yy/h_y^2;          % lamda_{1,0}
    lam_0p = b_y/(2*h_y) + c_yy/h_y^2 - c_xx/h_x^2;          % lamda_{0,1}

    PdeProblem.X = linspace(x_beg, x_end, N_x+1);    % X 轴
    PdeProblem.Y = linspace(y_beg, y_end, N_y+1);
    X = PdeProblem.X;
    Y = PdeProblem.Y;    % Y 轴

% 矩阵初始化
    [GridX, GridY] = meshgrid(X,Y); 
    D_m = lam_m0*eye(N_y-1);
    D_p = lam_p0*eye(N_y-1);
    U = zeros((N_x-1)*(N_y-1), 1);     % 待求函数
    K = zeros((N_x-1)*(N_y-1), (N_x-1)*(N_y-1));      % 系数矩阵

    Phi = zeros((N_x-1)*(N_y-1), 1);
    phi_matrix = zeros(N_y+1,N_x+1);
    if ~PdeProblem.PhiIsZero
        phi_matrix = phi(GridX,GridY);
    end
    
    varphi_matrix = zeros(N_y-1, N_x-1);
    varphi_matrix(1, :) = -lam_0m*u_x_ybeg(X(2:N_x)); % 矩阵索引比网格索引多 1
    varphi_matrix(end, :) = -lam_0p*u_x_yend(X(2:N_x)); % 矩阵索引比网格索引多 1
    
    Result = zeros(N_y+1,N_x+1);
    Result(1,:) = u_x_ybeg(X);
    Result(end,:) = u_x_yend(X);
    Result(:,1) = u_xbeg_y(Y);
    Result(:,end) = u_xend_y(Y);
    % 平滑边缘突变
    Result(1,1) = 0.5*( u_x_ybeg(X(1)) +  u_xbeg_y(Y(1)));
    Result(1,end) = 0.5*( u_x_ybeg(X(end)) + u_xend_y(Y(1)) );
    Result(end, 1) = 0.5*( u_x_yend(X(1)) + u_xbeg_y(Y(end)) );
    Result(end, end) = 0.5*( u_x_yend(X(end)) + u_xend_y(Y(end)) );

% 赋入矩阵数据
    G = lam_00*eye((N_y-1)) ...
        + [
            zeros((N_y-1)-1, 1) , lam_0p*eye((N_y-1)-1);
            zeros(1,(N_y-1))
          ] ...
        + [
            zeros(1, (N_y-1));
            lam_0m*eye((N_y-1)-1), zeros((N_y-1)-1, 1);
          ];
    for i = 1: N_x-1
        K( (i-1)*(N_y-1)+1 : i*(N_y-1), (i-1)*(N_y-1)+1 : i*(N_y-1) ) = G;
    end
    for i = 1: N_x-2
        K( (i)*(N_y-1)+1 : (i+1)*(N_y-1), (i-1)*(N_y-1)+1 : i*(N_y-1) ) = D_m;
        K( (i-1)*(N_y-1)+1 : (i)*(N_y-1), (i)*(N_y-1)+1 : (i+1)*(N_y-1) ) = D_p;
    end
    % 第一、二项 \vec{\phi} + \vec{\varphi}
    for i = 1: N_x-1    
        Phi( (i-1)*(N_y-1)+1 : i*(N_y-1), 1 ) = phi_matrix(2:N_y, i+1) + varphi_matrix(:, i);;   % 网格索引 0 ~ N，矩阵索引 1 ~ N+1
    end
    % 第三项 -\lambda_{-1,0}\vec{u}_0
    Phi(1:(N_y-1), 1) = Phi(1:(N_y-1), 1) -lam_m0*u_xbeg_y(Y(2:N_y))';  % 这里需要有转置，否则可能行向量 + 列向量构成新矩阵

    % 第四项 -\lambda_{1,0}\vec{u}_{N_x}
    Phi( (N_x-2)*(N_y-1)+1:(N_x-1)*(N_y-1), 1) = Phi( (N_x-2)*(N_y-1)+1:(N_x-1)*(N_y-1), 1) - lam_p0*u_xend_y(Y(2:N_y))';   % 这里需要有转置，否则可能行向量 + 列向量构成新矩阵

% 求解矩阵方程
    mn = size(K);
    disp( [ num2str(rank(K)), '尺寸：', num2str(mn(1)) ] )
    disp(det(K))
    U = K\Phi;

% 展开结果
    for i = 1: N_x-1    
        Result(2:N_y, i+1) = U( (i-1)*(N_y-1)+1 : i*(N_y-1), 1 );   % 网格索引 0 ~ N，矩阵索引 1 ~ N+1
    end

time = toc;

% 返回结果
    PdeProblem.Result = Result;
    disp("----------------------------------------------")
    disp("------- PDE 求解器（二元，二阶，中心差分）-------")
    disp(['用时：', num2str(time)])
    disp(['x 轴单元数：', num2str(N_x), ', x 轴步长：', num2str(h_x)])
    disp(['y 轴单元数：', num2str(N_y), ', y 轴步长：', num2str(h_y)])
    % disp("PDE结构体：")
    % disp(PdeProblem)
    disp("------- PDE 求解器（二元，二阶，中心差分）-------")
    disp("----------------------------------------------")
end
```


在解决热传导方程时报错 “警告：矩阵为奇异工作精度”，是因为此时 $a=0$，矩阵 $K$ 非满秩，无法求逆。一个可能的解决方法（不推荐）是将 $a$ 设为一个很小的数，如 $10^{-10}$*。

另一种解决方案是将 R 格式与 DF 格式结合来避免 $\lambda_{0,0}=0$。例如在热传导方程 $u_x'(x,y) = au_{yy}''(x,y)$ 中，在 $x$ 轴上采用 DF 格式，在 $y$ 轴上采用 R 格式。此时的 $\lambda$ 系数为：

$$
\begin{align*}
& \lambda_{-1,-1} = \lambda_{1, 1} = 0\ ,\  \ \lambda_{0,0}  =  a - \frac{2c_{yy}}{h_y^2}\\ 
& \lambda_{-1,0} = -\frac{b_x}{2h_x} + \frac{c_{xx}}{h_x^2}\ ,\ \ \lambda_{0,-1} = -\frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2} - \frac{c_{xx}}{h_x^2}\\ 
& \lambda_{1,0}  =  \frac{b_x}{2h_x} + \frac{c_{xx}}{h_x^2}\ ,\ \ \lambda_{0,1}  = \frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2} - \frac{c_{xx}}{h_x^2}
\end{align*} 
$$

## 二元二阶向前差分

容易看出，不同的差分方式，仅会影响 $\lambda_{r,s},\ r,s \in \{-1,0,1\}$ 的值，其他推导完全一致。这也是为什么在中心差分的推导中，我们将其单独命名为 $\lambda_{r,s}$。

在时域问题中，最终态 $t = t_{\mathrm{end}}$ 时的状态常常未知，$Otx$ 上的待求区域仅有三条边界已知，分别是 $x=x_{\mathrm{beg}}$、$x=x_{\mathrm{end}}$ 和 $t=t_{\mathrm{beg}}$（$t=t_{\mathrm{end}}$ 未知），此时无法（在 $t$ 轴上）使用中心差分。因此，在这一小节，我们考虑 $t$ 轴上向前差分而 $x$ 轴仍中心差分的情况（$u = u(t,x)$），或者说 $x$ 轴上向前差分而 $y$ 轴仍中心差分（$u = u(x,y)$）的情况。


另外，必须指出的是，向前差分不是无条件稳定格式，需要满足稳定性条件，这要求时间步长较短，一般考虑库朗数  $ \mathrm{CFL} =  | \frac{2\lambda_{0,1}}{\lambda_{1,0}} | \leq 1 \Longleftrightarrow h_t \leq |  \frac{b_t}{2\lambda_{0,1}} |$，具体可以参考 CFL 条件（库朗数）[here](https://zhuanlan.zhihu.com/p/363699096) and [here](https://zhuanlan.zhihu.com/p/365006118)。


### 矩阵方程

前差 $x$ 中差 $y$：
$$
u_x' = \frac{1}{h_x}(u_{i+1,j} - u_{i,j})\ ,\ \ u_{xx}''=\frac{1}{h_x^2}(u_{i-1,j}-2u_{i,j}+u_{i+1,j}) \\
u_y'=\frac{1}{2h_y}(u_{i,j+1}-u_{i,j-1})\ ,\ \ 
u_{yy}''=\frac{1}{h_y^2}(u_{i,j-1}-2u_{i,j}+u_{i,j+1})\\ 
$$
代入二阶线性偏微分方程，得到：

$$
\begin{align*}
& \lambda_{-1,-1} = \lambda_{1, 1} = 0 \\
& \lambda_{0,0}  =  a- \frac{b_x}{h_x} - \frac{2c_{xx}}{h_x^2}-\frac{2c_{yy}}{h_y^2}\\ 
& \lambda_{-1,0} =  \frac{c_{xx}}{h_x^2}\ ,\ \ \lambda_{0,-1} =  -\frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2}\\ 
& \lambda_{1,0}  =  \frac{b_x}{h_x} + \frac{c_{xx}}{h_x^2}\ ,\ \ \lambda_{0,1}  =  \frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2}\\ 
\end{align*}
$$

假设 $c_{xx} = c_{xy} = 0$，则有：

$$
\begin{align*}
& \lambda_{-1,-1} = \lambda_{1, 1} =  0\\ 
& \lambda_{0,0}  =  a- \frac{b_x}{h_x} -\frac{2c_{yy}}{h_y^2}\\ 
&  \lambda_{-1,0} = 0\ ,\ \ \lambda_{0,-1} =  -\frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2}\\ 
& \lambda_{1,0}  =  \frac{b_x}{h_x}\ , \ \ \lambda_{0,1}  =  \frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2}\\ 
\end{align*}
$$

在 $G\vec{u}_i + \lambda_{1,0}\vec{u}_{i+1} = \vec{\phi}_i + \vec{\varphi}_i$ 中依次令 $i = 0, ..., N_x-1$ 而不是之前的 $1, ..., N_x-1$，得到矩阵方程：

$$
K\vec{U} = \vec{\Phi} \Longrightarrow \vec{U} = K^{-1}\vec{\Phi}
$$

其中：
$$
\vec{U} = \begin{bmatrix}\vec{u}_{1}\\\vec{u}_{2}\\\vdots\\\vec{u}_{N_x}\end{bmatrix} =\begin{bmatrix}u_{1,1}\\u_{1,2}\\\vdots\\u_{1,N_y-1}\\u_{2,1}\\\vdots\\u_{N_x,N_y-1}\end{bmatrix}_{{\color{red}N_x}(N_y-1)\times 1}\\
K = 
\begin{bmatrix}
  D_p&  O&  O&\cdots  &O &O \\
  G&  D_p&  O&\cdots  &O  &O \\
  O&  G&  D_p&\cdots  &O  &O \\
  \vdots&  \vdots&  \vdots&  \ddots &\vdots  &\vdots \\
  O&  O&  O&  \cdots&  D_p& O\\
  O&  O&  O&  \cdots&  G&D_p
\end{bmatrix}_{{\color{red}N_x}(N_y-1)\times {\color{red}N_x}(N_y-1)}\\ 
\vec{\Phi} = 
\begin{bmatrix}
    \vec{\phi}_{\color{red}0} \\ 
    \vec{\phi}_1 \\ 
    \vdots \\ 
    \vec{\phi}_{N_x-1}
\end{bmatrix} + 
\begin{bmatrix}
    \vec{\varphi}_{\color{red}0} \\ 
    \vec{\varphi}_1 \\ 
    \vdots \\ 
    \vec{\varphi}_{N_x-1}
\end{bmatrix}+
\begin{bmatrix}
    G\vec{u}_0 \\ 
    \vec{0} \\ 
    \vdots \\ 
    \vec{0}
\end{bmatrix}_{{\color{red}N_x}(N_y-1)\times 1}
$$


## 二元二阶向后差分

### 矩阵方程

后差 $x$ 中差 $y$：
$$
u_x' = \frac{1}{h_x}(u_{i,j} - u_{i-1,j})\ ,\ \ u_{xx}''=\frac{1}{h_x^2}(u_{i-1,j}-2u_{i,j}+u_{i+1,j}) \\
u_y'=\frac{1}{2h_y}(u_{i,j+1}-u_{i,j-1})\ ,\ \ 
u_{yy}''=\frac{1}{h_y^2}(u_{i,j-1}-2u_{i,j}+u_{i,j+1})\\ 
$$

代入二阶线性偏微分方程，得到：
$$
\begin{align*}
& \lambda_{-1,-1} = \lambda_{1, 1} = 0 \\
& \lambda_{0,0}  =  a- \frac{b_x}{h_x} - \frac{2c_{xx}}{h_x^2}-\frac{2c_{yy}}{h_y^2}\\ 
& \lambda_{-1,0} =  \frac{c_{xx}}{h_x^2}\ ,\ \ \lambda_{0,-1} =  -\frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2}\\ 
& \lambda_{1,0}  =  \frac{b_x}{h_x} + \frac{c_{xx}}{h_x^2}\ ,\ \ \lambda_{0,1}  =  \frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2}\\ 
\end{align*}
$$

假设 $c_{xx} = c_{xy} = 0$，则有：
$$
\begin{align*}
& \lambda_{-1,-1} = \lambda_{1, 1} =  0\\ 
& \lambda_{0,0}  =  a + \frac{b_x}{h_x} -\frac{2c_{yy}}{h_y^2}\\ 
&  \lambda_{-1,0} = \frac{b_x}{h_x}\ ,\ \ \lambda_{0,-1} =  -\frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2}\\ 
& \lambda_{1,0}  =  0 \ , \ \ \lambda_{0,1}  =  \frac{b_y}{2h_y} + \frac{c_{yy}}{h_y^2}\\ 
\end{align*}
$$

在 $\lambda_{-1,0}\vec{u}_{i-1} + G\vec{u}_i = \vec{\phi}_i + \vec{\varphi}_i$ 中依次令 $i = 1,...,N_x$，得到矩阵方程： 

$$
K\vec{U} = \vec{\Phi} \Longrightarrow \vec{U} = K^{-1}\vec{\Phi}
$$

其中：
$$
\vec{U} = \begin{bmatrix}\vec{u}_{1}\\\vec{u}_{2}\\\vdots\\\vec{u}_{N_x}\end{bmatrix} =\begin{bmatrix}u_{1,1}\\u_{1,2}\\\vdots\\u_{1,N_y-1}\\u_{2,1}\\\vdots\\u_{N_,N_y-1}\end{bmatrix}_{{\color{red}N_x}(N_y-1)\times 1} \\
K = 
\begin{bmatrix}
  G&  O&  O&\cdots  &O &O \\
  D_m&  G&  O&\cdots  &O  &O \\
  O&  D_m&  G&\cdots  &O  &O \\
  \vdots&  \vdots&  \vdots&  \ddots &\vdots  &\vdots \\
  O&  O&  O&  \cdots&  G& O\\
  O&  O&  O&  \cdots&  D_m&G
\end{bmatrix}_{{\color{red}N_x}(N_y-1)\times {\color{red}N_x}(N_y-1)}\\ 
\vec{\Phi} = 
\begin{bmatrix}
    \vec{\phi}_{\color{red}1} \\ 
    \vec{\phi}_2 \\ 
    \vdots \\ 
    \vec{\phi}_{N_x}
\end{bmatrix} + 
\begin{bmatrix}
    \vec{\varphi}_{\color{red}1} \\ 
    \vec{\varphi}_2 \\ 
    \vdots \\ 
    \vec{\varphi}_{N_x}
\end{bmatrix}+
\begin{bmatrix}
    -\lambda_{-1,0}\vec{u}_0 \\ 
    \vec{0} \\ 
    \vdots \\ 
    \vec{0}
\end{bmatrix}_{{\color{red}N_x}(N_y-1)\times 1}
$$

## PDE Toolbox
Official link [here](https://www.mathworks.com/help/pde/index.html?s_tid=CRUX_lftnav)

## References 

- [科学计算中的偏微分方程数值解法 (张文生)](https://www.writebug.com/static/uploads/2024/8/4/ce21a47157bfcba5b44bf27dbfa9fb1c.pdf)
- [偏微分方程数值解法 (陆金甫) ](https://www.writebug.com/static/uploads/2024/8/4/f70d655ff4aed3522498fa632f42d7fe.pdf)

- [x] [Stable Explicit Schemes For Simulation of Nonlinear Moisture Transfer in Porous Materials](https://arxiv.org/pdf/1701.07059)
- [x] [微分方程数值求解——有限差分法](https://zhuanlan.zhihu.com/p/411798670)
- [x] [微分方程数值解法1.1:有限差分方法_定义与误差分析](https://zhuanlan.zhihu.com/p/353590423)
- [x] [数值计算（三）matlab pdepe()函数 求解一般的偏微分方程组](https://zhuanlan.zhihu.com/p/110277324)
- [x] [matlab求解偏微分方程 更新中](https://zhuanlan.zhihu.com/p/493362666)
- [x] [数值计算（五十二）一维连续介质热传导方程](https://zhuanlan.zhihu.com/p/239710629)
- [x] [数值计算（七十九）matlab求解复杂偏微分方程](https://zhuanlan.zhihu.com/p/675966238)
- [x] [数学物理方程 - 第二章 热传导方程](https://zhuanlan.zhihu.com/p/260066673)
- [x] [PDE有限差分方法(6)——热传导方程的双层格式与三层格式](https://zhuanlan.zhihu.com/p/129681229)
- [x] [CFD理论|什么是库朗数](https://zhuanlan.zhihu.com/p/363699096)
- [x] [CFD理论|库朗数应用](https://zhuanlan.zhihu.com/p/365006118)

