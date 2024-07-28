# Mathematical Modeling (1): Papers

下面的内容按做题时间顺序排列。

## CUMCM 2022-A

### 概览
- 时间：2024年1月（集训）
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

设炉内温度分布为$T = T(x)$，给定过炉速度后，可由 $x = vt \Longrightarrow T = T(t)$ 得到焊件环境温度曲线。

### 问题一

在问题一，焊接区域整体与外界的热交换由牛顿冷却定律给出，焊接区域内部的热交换由热传导定律给出。给定了过炉速度，即给定了环境温度曲线 $T(t)$，也即微分方程的边界条件，再算上初始条件，即可求微分方程数值解。

为了更好地解决后续问题，我们希望模型在够用的同时少复杂一些。例如，这里焊接区域厚度极薄，可以考虑近似，因此可以在问题一中给出近似的理由：验证温度传导率远大于温度变化率，在此后便不再区分焊接区域与焊接区域中心。

### 问题二

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