# Mathematical Modeling (1): Papers

## 官网

- [CUMCM](http://www.mcm.edu.cn/)
- [MCM/ICM](https://www.contest.comap.com/undergraduate/contests/index.html)

下面的内容大致按照实际做题时间顺序排列。

## CUMCM 2022-A

### 概览
- 时间：2024 年 1 月（集训）
- 赛题：[CUMCM 2022-A 赛题.pdf](https://www.writebug.com/static/uploads/2024/7/27/91b5c39794e5df771b298069a401e878.pdf)
- 优秀论文：
  - [CUMCM 2022-A 优秀论文 A001.pdf](https://www.writebug.com/static/uploads/2024/7/27/12180c187ed5a3f4cdbbbd697d57b236.pdf)
  - [CUMCM 2022-A 优秀论文 A022.pdf](https://www.writebug.com/static/uploads/2024/7/27/f5ff8104f75b57dfd4b5383a6608f768.pdf)
  - [CUMCM 2022-A 优秀论文 A171.pdf](https://www.writebug.com/static/uploads/2024/7/27/152e6220668abf09f9da22a60cc8a86c.pdf)
- 成果：
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

- 主题：炉温曲线
- 重点：PDE、ODE、最优化
- 时间：2023年11月（自研）
- 重做时间：2024年7月（自研）
- 赛题：[CUMCM 2020-A 赛题.docx](https://www.writebug.com/static/uploads/2024/7/27/f2103d42290b446d13197930ec1c9258.docx)
- 优秀论文：
  - [CUMCM 2022-A 优秀论文 A070.pdf](https://www.writebug.com/static/uploads/2024/7/27/3d504a7e2fc22b936b92dacc8e403c41.pdf)
  - [CUMCM 2022-A 优秀论文 A147.pdf](https://www.writebug.com/static/uploads/2024/7/27/a246ab85e0b87d9dd7aeb681e725ef2a.pdf)
  - [CUMCM 2022-A 优秀论文 A195.pdf](https://www.writebug.com/static/uploads/2024/7/27/1fcd73a55232834c3d8e1eb7241a3518.pdf)
  - [CUMCM 2022-A 优秀论文 A212.pdf](https://www.writebug.com/static/uploads/2024/7/27/30fd4c6d0ad2dd6cfc7230d921b74867.pdf)

详见 [MM(1.1)-CUMCM2022A](Notes/MathematicalModeling/MM(1.1)-CUMCM2022A.md)。


## CUMCM 2023-A 
- 时间：2024年8月（集训）
- 赛题：
- 优秀论文：
- 成果：
  - pdf: <button onclick="window.open('')" type="button">click</button>
  - tex: <button onclick="window.open('')" type="button">click</button>

## CUMCM 2023-B
- 时间：2024年8月（集训）
- 赛题：
- 优秀论文：
- 成果：
  - pdf: <button onclick="window.open('')" type="button">click</button>
  - tex: <button onclick="window.open('')" type="button">click</button>

## CUMCM 2021-A 
- 时间：待定

## MCM/ICM 2023-A

- 时间：待定