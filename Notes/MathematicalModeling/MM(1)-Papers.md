# Mathematical Modeling (1): Papers

下面的内容按做题时间顺序排列。

## CUMCM 2022-A

### 概览
- 时间：2024 年 1 月（集训）
- 赛题：[CUMCM 2022-A 赛题.pdf](https://www.writebug.com/static/uploads/2024/7/27/91b5c39794e5df771b298069a401e878.pdf)
- 优秀论文：
  - [CUMCM 2022-A 优秀论文 A001.pdf](https://www.writebug.com/static/uploads/2024/7/27/12180c187ed5a3f4cdbbbd697d57b236.pdf)
  - [CUMCM 2022-A 优秀论文 A022.pdf](https://www.writebug.com/static/uploads/2024/7/27/f5ff8104f75b57dfd4b5383a6608f768.pdf)
  - [CUMCM 2022-A 优秀论文 A171.pdf](https://www.writebug.com/static/uploads/2024/7/27/152e6220668abf09f9da22a60cc8a86c.pdf)
- pdf: <button onclick="window.open('https://s.b1n.net/y52Nc')" type="button">click</button>
- tex: <button onclick="window.open('https://www.writebug.com/git/YiDingg/WB.YiDingg/raw/branch/main/%E5%9B%BD%E8%B5%9B2022A.tex')" type="button">click</button>

### ode 求解器的函数句柄

例如问题一第一小问，我们需要求下面微分方程的数值解：

$$
\rho g(V_{0}-Sy_{1})+fcos(\omega t)-C_{zx}\dot{y}_{1}+k_{zz}(y_{2}-y_{1}-l)-k_{zz}(\dot{y}_{1}-\dot{y}_{2})-m_{1}g-m_{\mathrm{f}}\ddot{y}_{1}=m_{1}\ddot{y}_{1}\\k_{\mathrm{zt}}(y_{1}-y_{2}+l)-k_{\mathrm{zz}}(\dot{y}_{2}-\dot{y}_{1})-m_{2}g=m_{2}\ddot{y}_{2}
$$

需要求解的变量有四个：$y_{1}(t)$、$\dot{y}_{1}(t)$、$y_{2}(t)$、$\dot{y}_{2}(t)$。考虑`ode`函数，可以将函数句柄写为如下形式：

$$
Y = \begin{bmatrix}
 Y(1)\\
 Y(2)\\
 Y(3) \\
 Y(4) 
\end{bmatrix} = \begin{bmatrix}
 y_1\\
 y_2\\
 \dot y_1 \\
 \dot y_2 
\end{bmatrix}\ ,\ \ 
dYdt 
= \begin{bmatrix}
\dot y_1\\
 \dot y_2\\
 \ddot y_1 \\
 \ddot y_2 
\end{bmatrix}
= \begin{bmatrix}
 Y(3)\\
 Y(4)\\
 formula \\
 formula
\end{bmatrix}
$$

`dYdt`即为所需的函数句柄。另外，$\ddot y_1$ 和 $\ddot y_2$ 的表达式手动化简即可，无需用Matlab进行化简。

## CUMCM 2020-A 

### 概览

- 时间：2023年11月（自研）
- 重做时间：2024年7月（自研）
- 赛题：[CUMCM 2020-A 赛题.docx](https://www.writebug.com/static/uploads/2024/7/27/f2103d42290b446d13197930ec1c9258.docx)
- 优秀论文：
  - [CUMCM 2022-A 优秀论文 A070.pdf](https://www.writebug.com/static/uploads/2024/7/27/3d504a7e2fc22b936b92dacc8e403c41.pdf)
  - [CUMCM 2022-A 优秀论文 A147.pdf](https://www.writebug.com/static/uploads/2024/7/27/a246ab85e0b87d9dd7aeb681e725ef2a.pdf)
  - [CUMCM 2022-A 优秀论文 A195.pdf](https://www.writebug.com/static/uploads/2024/7/27/1fcd73a55232834c3d8e1eb7241a3518.pdf)
  - [CUMCM 2022-A 优秀论文 A212.pdf](https://www.writebug.com/static/uploads/2024/7/27/30fd4c6d0ad2dd6cfc7230d921b74867.pdf)

### 示意图与数据准备

炉内区域示意图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-28-13-41-05_MM(1)-Papers.jpg"/></div>

各点坐标 $\mathrm{(cm)}$：
``` matlab
X = [0 25 55.5 60.5 91 96 126.5	131.5 162 167 197.5 202.5 233 238 268.5 273.5 304 309 339.5 344.5 375 380 410.5 435.5]
```

设炉内温度分布为 $T = T(x)$，给定过炉速度后，可由 $x = vt \Longrightarrow T = T(t)$ 得到炉内温度曲线。

由热传导定律 $\begin{cases}j = -\nabla T\\ T_t' = a^2T_{xx}''\end{cases}$ 确定温区间隙的温度，由于达到稳态，$\nabla T \equiv C$ 为定值，因此间隙温度呈线性分布，由此得到炉内温度曲线：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-30-23-36-14_MM(1)-Papers.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-30-23-46-05_MM(1)-Papers.png"/></div>

``` matlab
X = [0 25 55.5 60.5 91 96 126.5	131.5 162 167 197.5 202.5 233 238 268.5 273.5 304 309 339.5 344.5 375 380 410.5 435.5];

% 问题一温度参数

T = [175 195 235 255 25];

% 炉内温度曲线
T_s = @(x) ...
    (X(1)<=x & x<X(2)) .* (  ( T(1)-25 )/( X(2)-X(1) )*(x-X(1)) + 25  )  + ...
    (X(2)<=x & x<X(11)) .* (  T(1)  )  + ...
    (X(11)<=x & x<X(12)).* (  ( T(2)-T(1) )/( X(12)-X(11) )*(x-X(11)) + T(1)  )  + ...
    (X(12)<=x & x<X(13)).* T(2)  + ...
    (X(13)<=x & x<X(14)).* (  ( T(3)-T(2) )/( X(14)-X(13) )*(x-X(13)) + T(2)  )  + ...
    (X(14)<=x & x<X(15)).* T(3)  + ...
    (X(15)<=x & x<X(16)).* (  ( T(4)-T(3) )/( X(16)-X(15) )*(x-X(15)) + T(3)  )  + ...
    (X(16)<=x & x<X(19)).* T(4)  + ...
    (X(19)<=x & x<X(20)).* (  ( T(5)-T(4) )/( X(20)-X(19) )*(x-X(19)) + T(4)  )  + ...
    (X(20)<=x & x<X(24)).* T(5);

fplot(T_s, [0, X(end)])
integral(T_s,0,X(end))
```

不妨对最后两个区间进行温度修正，用 $T = ce^{-kx} + T_0$，则有：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-31-00-25-26_MM(1)-Papers.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-31-01-02-56_MM(1)-Papers.png"/></div>

``` matlab
X = [0 25 55.5 60.5 91 96 126.5	131.5 162 167 197.5 202.5 233 238 268.5 273.5 304 309 339.5 344.5 375 380 410.5 435.5];

% 问题一温度参数

T = [175 195 235 255 25];

c = 10^5
k = - log((T(4) - 25)/c)/X(19)

% 炉内温度曲线 T = 
T_sx = @(x) ...
    (X(1)<=x & x<X(2)) .* (  ( T(1)-25 )/( X(2)-X(1) )*(x-X(1)) + 25  )  + ...
    (X(2)<=x & x<X(11)) .* (  T(1)  )  + ...
    (X(11)<=x & x<X(12)).* (  ( T(2)-T(1) )/( X(12)-X(11) )*(x-X(11)) + T(1)  )  + ...
    (X(12)<=x & x<X(13)).* T(2)  + ...
    (X(13)<=x & x<X(14)).* (  ( T(3)-T(2) )/( X(14)-X(13) )*(x-X(13)) + T(2)  )  + ...
    (X(14)<=x & x<X(15)).* T(3)  + ...
    (X(15)<=x & x<X(16)).* (  ( T(4)-T(3) )/( X(16)-X(15) )*(x-X(15)) + T(3)  )  + ...
    (X(16)<=x & x<X(19)).* T(4)  + ...
    (X(19)<=x & x<=X(24)).* ( c*exp(-k*x) +25 )

MyPlot(0:X(end)/800:X(end), T_sx(0:X(end)/800:X(end)), ["$x/ \mathrm{cm}$"; "$T_s(x)/ \mathrm{K}$"])
legend("炉内温度曲线")
```

### 问题一

在问题一，焊接区域整体与外界的热交换由牛顿冷却定律给出，焊接区域内部的热交换由热传导定律给出。显然，这是一个偏微分方程问题，几乎无法得出解析解，所以考虑数值解。算上时间变量 $t$，如果将焊接区域视为二维薄片，则为三变元（三维）偏微分方程，这是不易求解的。因此，我们希望能将焊接区域近似为一维细棒，这要求我们验证温度传导率远大于温度变化率（不验证问题也不大）。这样，此后便不再区分焊接区域与焊接区域中心，在求解和分析时也具有了更强的可行性。

给定了过炉速度 $v$，相当于给定了炉内温度曲线 $T(t)$，也即微分方程的边界条件，再算上初始条件和边界条件（将炉内温度曲线视为边界条件），可求此二维 PDE 数值解。

在求解二维热传导方程时发现结果不稳定，于是利用函数拟合来观察焊接区域中心温度曲线： 
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-31-01-00-35_MM(1)-Papers.png"/></div> -->

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-31-01-04-15_MM(1)-Papers.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-31-01-05-38_MM(1)-Papers.png"/></div>

``` matlab 
k = 0.3*10^(-4);
% 定义结构体
    PdeProblem.N_x = 708;
    PdeProblem.N_y = 20;

    PdeProblem.x_beg = 0;
    PdeProblem.x_end = t(end);
    PdeProblem.y_beg = 0;
    PdeProblem.y_end = 0.1;

    PdeProblem.a = 0;
    PdeProblem.b_x = 1;
    PdeProblem.b_y = 0;
    PdeProblem.c_xx = 0;
    PdeProblem.c_yy = -k;
    PdeProblem.PhiIsZero = true;
    PdeProblem.phi = @(x,y) 0;    % 注意要用 .^ .* ./ 等符号
    
    PdeProblem.u_xbeg_y = @(y) 25;
    PdeProblem.u_xend_y = @(y) 30;
    PdeProblem.u_x_ybeg = T_st;
    PdeProblem.u_x_yend = T_st;

% 调用函数
PdeProblem = MyPDESolver_2Var_Level2_Center(PdeProblem);
% MySurf(PdeProblem.X,PdeProblem.Y,PdeProblem.Result, false)
MyMesh(PdeProblem.X,PdeProblem.Y,PdeProblem.Result,1);
% MySurf(PdeProblem.X,PdeProblem.Y,PdeProblem.Result,1,1);
MyPlot(Appendix(:,1)', [Appendix(:,2)'; T_sx(linspace(0, X(end), si(1)));PdeProblem.Result(10,:)], ["$t/ \mathrm{s}$"; "$T_s(t)/ \mathrm{K}$"])

fitX = Appendix(:,1)';
fitY = PdeProblem.Result(10,:);

       a1 =      -9.411 
       b1 =       281.8  
       c1 =       23.55  
       a2 =      -1.134  
       b2 =       288.2  
       c2 =       3.107  
       a3 =         213  
       b3 =       307.1 
       c3 =       77.07  
       a4 =       148.8  
       b4 =       184.3  
       c4 =       102.4 
       a5 =          15 
       b5 =       366.1 
       c5 =       13.85  
       a6 =      -1.954  
       b6 =       219.1  
       c6 =       4.251 
       a7 =        63.5 
       b7 =       107.7 
       c7 =       54.14  
       a8 =       40.35  
       b8 =       69.65  
       c8 =       30.33   

f = @(x) a1*exp(-((x-b1)/c1).^2) + a2*exp(-((x-b2)/c2).^2) + ...
              a3*exp(-((x-b3)/c3).^2) + a4*exp(-((x-b4)/c4).^2) + ...
              a5*exp(-((x-b5)/c5).^2) + a6*exp(-((x-b6)/c6).^2) + ...
              a7*exp(-((x-b7)/c7).^2) + a8*exp(-((x-b8)/c8).^2)

[fitresult, gof] = createFit(fitX, fitY);
       a1 =       228.2  
       b1 =    0.007358  
       c1 =     -0.1637  
       a2 =       41.39  
       b2 =     0.02626  
       c2 =      -0.398  
f2 = @(x) a1*sin(b1*x+c1) + a2*sin(b2*x+c2)
MyPlot(Appendix(:,1)', [Appendix(:,2)'; T_sx(linspace(0, X(end), si(1)));f(fitX);f2(fitX)], ["$t/ \mathrm{s}$"; "$T_s(t)/ \mathrm{K}$"])
```

我们又先后尝试了 DF 格式、Euler 向前差分和向后差分，但结果都不尽人意。

然后便是最优化参数 $k$，以拟合函数值与附录数据的残差平方和为目标函数（除以样本总数即为方差），最小化目标函数以得到最优参数 $k$。为了方便最优化操作，不妨以残差平方和的相反数作为目标函数，然后在实数域上最大化目标函数即可。

优秀论文 A07 在这里有一个闪光点，由附录所给数据，作 $k = \frac{T'(t)}{T(t) - T_s(t)}$ 图像，可以发现 $k$ 并不严格是常数，但可以分段视为常数。因此在不同的区间内，可以认为 $k$ 的值不同，这样优化后得到的 $k = k(x)$ 便能更好的符合附录所给数据。虽然在热传导方程中，我们无法依据附录数据作出 $k = \frac{T_t'}{T_{xx}''}$ 的图像，但我们也可以有类似的思路，将 $k$ 分为多段，在每段中都视为常量。

$k$ 在整个区间上为常数时，由模拟退火和网格法分别得到（数据拟合分别采用傅里叶、高斯和正弦）：

模拟退火：
$$
k_{\mathrm{best,sin}} = 1.9991 \times 10^{-5}\, \ \ obj_{\mathrm{best,sin}} = -40296.116 \\
k_{\mathrm{best,gauss}} = 2.2041 \times 10^{-5}\, \ \ obj_{\mathrm{best,gauss}} = -46318.0169 \\
k_{\mathrm{best,fourier}} = 2.1013 \times 10^{-5}\, \ \ obj_{\mathrm{best,fourier}} = -80014.7308
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-03-23-24-48_MM(1)-Papers.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-00-41-26_MM(1)-Papers.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-00-42-32_MM(1)-Papers.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-00-47-40_MM(1)-Papers.png"/></div>

网格法：
$$
k_{\mathrm{best,sin}} = 1.96 \times 10^{-5}\, \ \ obj_{\mathrm{best,sin}} = -40469.4337 \\
k_{\mathrm{best,gauss}} = 2.212 \times 10^{-5}\, \ \ obj_{\mathrm{best,gauss}} = -35844.81 \\
k_{\mathrm{best,fourier}} = 2.1013 \times 10^{-5}\, \ \ obj_{\mathrm{best,fourier}} = -80014.7308
$$
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-20-30-32_MM(1)-Papers.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-20-28-59_MM(1)-Papers.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-20-29-37_MM(1)-Papers.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-03-22-54-54_MM(1)-Papers.png"/></div> -->



将 $k$ 分为三段时（区间），由模拟退火和网格法分别得到（热传导方程的 $k$ 分为三段时，有限差分法的结果及其不稳定，难以实现，以后有机会再尝试）。

问题一另外一种思路是（类似优秀论文 A07），将焊接区域直接看作 $0$ 维温度点，即整个焊接区域温度一致，仅依靠牛顿冷却定律 $T'(t) = k(T_s(t) - T(t))$ 与外界发生热交换（炉内温度即为环境温度），利用 `ODEs` 函数解此常微分方程，并最优化得到系数 $k$。

下面的内容仅采用高斯拟合进行计算。

依据附录数据作出 $k = \frac{T'(t)}{T_s(t) - T(t)}$ 的图像：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-01-01-37_MM(1)-Papers.png"/></div>
 -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-21-01-24_MM(1)-Papers.png"/></div>

$k$ 在整个区间上为常数时，由模拟退火得到（高斯拟合）：

$$
k_{\mathrm{best,gauss}} = 0.017238\, \ \ obj_{\mathrm{best,gauss}} = -31183.7644
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-21-20-07_MM(1)-Papers.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-21-21-14_MM(1)-Papers.png"/></div>

由网格搜索得到：

$$
k_{\mathrm{best,gauss}} = 0.0176\, \ \ obj_{\mathrm{best,gauss}} = -33944.8928
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-21-25-46_MM(1)-Papers.png"/></div>

将 $k$ 分为三段时（炉前及温区 1 ~ 5，温区 6 ~ 9，温区 10 ~ 11 及炉后），由模拟退火得到（正弦拟合，耗时约 30 s）：

$$
k_{\mathrm{best,sin}} = [0.015246, 0.02154, 0.01866]\, \ \ obj_{\mathrm{best,sin}} = -19466.0694
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-22-09-40_MM(1)-Papers.png"/></div>

由网格搜索得到：

$$
k_{\mathrm{best,sin}} = [0.0154, 0.022, 0.0184]\, \ \ obj_{\mathrm{best,sin}} = -19933.614
$$

``` matlab 
---------------------------------
>> --------  网格搜索  -------- <<
总计算次数：9261
历时 10675.887018 秒。
最优参数：0.0154       0.022      0.0184
最优目标值：-19933.614
>> --------  网格搜索  -------- <<
---------------------------------
```

可以明显的看到，模拟退火与网格搜索效率上的差异，前者花 30 s 得到的结果甚至要优于后者花 10676 s = 178 min 的结果。

这样就完成了模型建立，问题一的主要内容也到此结束。对于问题一最后需要的数据，利用 `writematrix` 函数可以方便实现。

### 问题二

毋庸置疑，问题一中采用牛顿冷却定律的方式结果更优，在之后的问题中，我们都基于牛冷进行操作。

### 问题三

### 问题四

## CUMCM 2021-A 
- 时间：待定

## CUMCM 2023-A 
- 时间：2024年8月（集训）
- 赛题：
- 优秀论文：
- pdf: <button onclick="window.open('')" type="button">click</button>
- tex: <button onclick="window.open('')" type="button">click</button>

## CUMCM 2023-B
- 时间：2024年8月（集训）
- 赛题：
- 优秀论文：
- pdf: <button onclick="window.open('')" type="button">click</button>
- tex: <button onclick="window.open('')" type="button">click</button>


## MCM/ICM 2023-A

- 官网：[here](https://www.contest.comap.com/undergraduate/contests/index.html)
- 时间：待定