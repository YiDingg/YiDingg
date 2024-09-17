# Mathematical Modeling (1.1): CUMCM 2020-A

> [!Note|style:callout|label:Infor]
Initially published at 13:31 on 2024-08-18 in Lincang.

## 概览

- 主题：炉温曲线
- 重点：PDE、ODE、最优化
- 时间：2023年11月（自研），2024年7月（重做，自研）
- 赛题：
  - [CUMCM 2020-A 赛题.pdf](https://www.writebug.com/static/uploads/2024/8/15/95f9eb580f188250f445102a9dda24d2.pdf)
  - [CUMCM 2020-A 赛题附件.xlsx](https://www.writebug.com/static/uploads/2024/8/9/508db691b838cb1c76f89d0e425dd127.xlsx)
- 优秀论文：
  - [x] [CUMCM 2020-A 优秀论文 A070.pdf](https://www.writebug.com/static/uploads/2024/7/27/3d504a7e2fc22b936b92dacc8e403c41.pdf)
  - [x] [CUMCM 2020-A 优秀论文 A147.pdf](https://www.writebug.com/static/uploads/2024/7/27/a246ab85e0b87d9dd7aeb681e725ef2a.pdf)
  - [x] [CUMCM 2020-A 优秀论文 A195.pdf](https://www.writebug.com/static/uploads/2024/7/27/1fcd73a55232834c3d8e1eb7241a3518.pdf)
  - [x] [CUMCM 2020-A 优秀论文 A212.pdf](https://www.writebug.com/static/uploads/2024/7/27/30fd4c6d0ad2dd6cfc7230d921b74867.pdf)


## 示意图与数据准备

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

## 问题一

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
k_{\mathrm{best,sin}} = [0.015046, 0.02284, 0.01845]\, \ \ obj_{\mathrm{best,sin}} = -19675.5288
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

可以明显的看到，模拟退火与网格搜索效率上的差异，前者花约 100 s 得到的结果甚至要优于后者花 10676 s = 178 min 的结果。

这样就完成了模型建立，问题一的主要内容也到此结束。对于问题一最后需要的数据，利用 `writematrix` 函数可以方便实现。

## 问题一（补充）

### ode 初始点修改

在上面的模型中，我们设置 ode 解算时间为 $[0, t_{end}]$，这只能得到一个可以接受的结果，勉强达到我们的要求：

$$
k_{\mathrm{best,sin}} = [0.015046,\     0.02284,\      0.01845]\, \ \ obj_{\mathrm{best,sin}} = -19675.5288 \\ 
残差平方和\  \mathrm{SSE} = 19675.5288, \ 决定系数\  \mathrm{R^2}= 0.9900, \ 平均绝对误差 \ \mathrel{MAE} = 3.4605\  \mathrm{K}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-05-21-41-20_MM(1)-Papers.png"/></div>

``` matlab 
---------------------------------
历时 275.751771 秒。
一共寻找新解：339
change_1次数：18
change_2次数：1
最优参数为：
0.015046    0.02284     0.01845
此参数下的目标函数值：-19675.5288
---------------------------------
```

为了建立更精确的模型，我们在保持离散单元数不变的情况下，将 ode 的初始时间和温度调整为附录数据的初始时间和温度，重新计算后得到：

$$
k_{\mathrm{best,sin}} = [0.017156,\    0.022332,\    0.018784]\, \ \ obj_{\mathrm{best,sin}} = -6700.1746 \\ 
残差平方和\  \mathrm{SSE} = 6700.1746, \ 决定系数\  \mathrm{R^2}= 0.9966, \ 平均绝对误差 \ \mathrel{MAE} = 2.1833\  \mathrm{K}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-05-21-51-01_MM(1)-Papers.png"/></div>

``` matlab 
---------------------------------
历时 268.586637 秒。
一共寻找新解：339
change_1次数：14
change_2次数：0
最优参数为：
0.017156    0.022332    0.018784
此参数下的目标函数值：-6700.1746
---------------------------------
```

显然，后者的结果更优，从图像上可以明显看出这一点。

### 2024.8.20 PDE求解器测试


``` matlab
----------------------------------------------------------------------
---- PDE 求解器：二元，DF格式（一阶导两点中心差分，二阶导四点中心差分）----
用时：1.0477
x 轴单元数：1000, x 轴步长：0.37329
y 轴单元数：25, y 轴步长：0.004
---- PDE 求解器：二元，DF格式（一阶导两点中心差分，二阶导四点中心差分）----
----------------------------------------------------------------------
```

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-20-21-46-32_MM(1.1)-CUMCM2020A.jpg"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-20-21-48-47_MM(1.1)-CUMCM2020A.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-20-21-48-51_MM(1.1)-CUMCM2020A.png"/></div>

``` matlab
X = [0 25 55.5 60.5 91 96 126.5  131.5 162 167 197.5 202.5 233 238 268.5 273.5 304 309 339.5 344.5 375 380 410.5 435.5];


% 问题一温度参数

T = [175 195 235 255 25];

% 炉内温度曲线
c = 10^5
k = - log((T(4) - 25)/c)/X(19)
T_sx = @(x) ...
    (X(1)<=x & x<X(2)) .* (  ( T(1)-25 )/( X(2)-X(1) )*(x-X(1)) + 25  )  + ...
    (X(2)<=x & x<X(11)) .* (  T(1)  )  + ...
    (X(11)<=x & x<X(12)).* (  ( T(2)-T(1) )/( X(12)-X(11) )*(x-X(11)) + T(1)  )  + ...
    (X(12)<=x & x<X(13)).* T(2)  + ...
    (X(13)<=x & x<X(14)).* (  ( T(3)-T(2) )/( X(14)-X(13) )*(x-X(13)) + T(2)  )  + ...
    (X(14)<=x & x<X(15)).* T(3)  + ...
    (X(15)<=x & x<X(16)).* (  ( T(4)-T(3) )/( X(16)-X(15) )*(x-X(15)) + T(3)  )  + ...
    (X(16)<=x & x<X(19)).* T(4)  + ...
    (X(19)<=x & x<=X(24)).* ( c*exp(-k*x) +25 );

v = 70;
v = v/60;
Time = X/v;


T_st = @(t) T_sx(v*t)
figure
fplot(T_st, [0, Time(end)])
integral(T_st,0,Time(end))
figure

K = 0.23*10^(-4);
% 定义结构体
    PdeProblem.N_x = 1000;
    PdeProblem.N_y = 25;

    PdeProblem.x_beg = 0;
    PdeProblem.x_end = Time(end);
    PdeProblem.y_beg = 0;
    PdeProblem.y_end = 0.1;

    PdeProblem.a = 0;
    PdeProblem.b_x = 1;
    PdeProblem.b_y = 0;
    PdeProblem.c_xx = 0;
    PdeProblem.c_yy = -K;
    PdeProblem.PhiIsZero = true;
    PdeProblem.phi = @(x,y) 0;    % 注意要用 .^ .* ./ 等符号
    
    PdeProblem.u_xbeg_y = @(y) 0;
    PdeProblem.u_x_ybeg = @(x) T_st(x);
    PdeProblem.u_x_yend = @(x) T_st(x);

% 调用函数
PdeProblem = Test_MyPDESolver_2Var_Level2_Center_DF(PdeProblem);
% MySurf(PdeProblem.X,PdeProblem.Y,PdeProblem.Result, false)
MyMesh(PdeProblem.X,PdeProblem.Y,PdeProblem.Result',1);

si = size(Appendix);
%MyPlot(Appendix(:,1)', [Appendix(:,2)'; T_sx(linspace(0, X(end), si(1))); PdeProblem.Result(10,:)], ["$t/ \mathrm{s}$"; "$T_s(t)/ \mathrm{K}$"])

fitX = PdeProblem.X(91:end);
fitY = PdeProblem.Result( 91:end , floor(size(PdeProblem.Result,2)/2) )' ;

[Temp_fit, gof] = SinFit(fitX, fitY);

myplot = MyPlot(Appendix(:,1)', [Appendix(:,2)'; T_st( linspace(Appendix(1,1), Appendix(end,1), si(1)) );Temp_fit(Appendix(:,1))'])
myplot.leg.String = ["Appendix", "LuWen",  'Result']
```


## 问题二

毋庸置疑，问题一中采用牛顿冷却定律的方式结果更优，在之后的问题中，我们都基于牛冷进行操作。

对于任意给定的锅炉速度 $v$，检查其是否满足制程界限：

- 依据 $v$ 和问题一中的 $k$，计算出环境温度 $T_s(t)$ 和炉温曲线 $T(t)$
- 峰值温度：  $\mathrm{Logic_1} = (240 \mathrm{°C}<T_{\mathrm{max}}\  \&\ T_{\mathrm{max}} <250 \mathrm{°C})$
- 导函数：$\mathrm{Logic_2} = \mathrm{prod}( -3 \mathrm{°C/s}<T'(t)\  \&\ T'(t) <3 \mathrm{°C/s})$
- 150 °C ~ 190 °C 时间范围（上升）：$\mathrm{Logic_3} = (60\  \mathrm{s}<\mathrm{range_1}\  \&\ \mathrm{range_1} <120\ \mathrm{s})$
- $>$ 217 °C 时间范围：$\mathrm{Logic_4} = (40\  \mathrm{s}<\mathrm{range_2}\  \&\ \mathrm{range_2} <90\ \mathrm{s})$
- 最后取 $\mathrm{Logic} = \prod_{i=1}^4 \mathrm{Logic_i}$，即为是否满足制程界限的逻辑值。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-05-17-44-13_MM(1)-Papers.png"/></div>

先设定速度范围为 $v \in [50\  \mathrm{cm/min}, 100\  \mathrm{cm/min}]$，步长为 $0.05$ 进行搜索，锁定最大过炉速度所在区间为 $[69.5,\ 72.5]$。然后再对该区间进行搜索，步长设置 $0.01$，最终得到最大过炉速度 $v_{\mathrm{max}} = 71.61\  \mathrm{cm/min}$。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-05-17-58-42_MM(1)-Papers.png"/></div>

## 问题三

本题需要对炉温曲线进行积分，一种算法是进行离散积分，直接用 ODEs 解得的炉温曲线向量值进行积分，另一种是对拟合曲线进行积分。我们在问题一中建立的模型便是得到拟合曲线，因此这里采用后者。

最优化参数共有 5 个：
$$
\overrightarrow{var} = [T_1,\  T_2,\  T_3,\  T_4,\  v]\\ 
\overrightarrow{var}^T = 
\begin{bmatrix}
  T_1 \\ 
  T_2 \\ 
  T_3 \\ 
  T_4 \\ 
  v
\end{bmatrix}
\in 
\begin{bmatrix}
  165\mathrm{°C},\  185\mathrm{°C} \\ 
  185\mathrm{°C},\  205\mathrm{°C} \\ 
  225\mathrm{°C},\  245\mathrm{°C} \\ 
  245\mathrm{°C},\  265\mathrm{°C} \\ 
  65\ \mathrm{cm\cdot min^{-1}},\  100\ \mathrm{cm\cdot min^{-1}}
\end{bmatrix}
$$

我们设定目标函数为面积值的相反数，利用模拟退火算法最大化目标函数，以得到最优解。另外，勿忘验证每个参数下是否满足制程界限。

对任意给定的 $\overrightarrow{var}$，求解目标函数的步骤如下：

- 计算环境温度 $T_s(t)$ 和炉温曲线 $T(t)$
- 验证制程界限
- 确定 $T(t) \in [217 \mathrm{°C},  T_{max} ]$ 的时间范围
- 计算目标函数（面积的相反数）

利用模拟退火算法最优化目标函数，得到最优解如下：

$$
\overrightarrow{var} = [T_1,\  T_2,\  T_3,\  T_4,\  v] = [167.5253,\  200.5031,\ 238.0173 ,\ 251.0402 ,\ 65.23086] \\ 
\mathrm{object_{best}} = -371.2401,\ 面积\  S = 371.2401\ \mathrm{°C\cdot s}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-06-01-14-20_MM(1)-Papers.png"/></div>

## 问题四
