# Mathematical Modeling (1): Papers

## 官网

- [CUMCM](http://www.mcm.edu.cn/)
- [MCM/ICM](https://www.contest.comap.com/undergraduate/contests/index.html)

下面的内容大致按照实际做题时间顺序排列。

## CUMCM 2022-A

- 时间：2024 年 1 月（集训）
- 赛题：
  - [CUMCM 2022-A 赛题.pdf](https://www.writebug.com/static/uploads/2024/7/27/91b5c39794e5df771b298069a401e878.pdf)
  - [CUMCM 2022-A 赛题附件 1.gif](https://www.writebug.com/static/uploads/2024/8/9/369ab5ccd30ffe6911d9e504bf7a2c46.gif)
  - [CUMCM 2022-A 赛题附件 2.gif](https://www.writebug.com/static/uploads/2024/8/9/764e317726592cb42b1523f5870fd046.gif)
  - [CUMCM 2022-A 赛题附件 3.xlsx](https://www.writebug.com/static/uploads/2024/8/9/ec3d771f7d76291890719d24e845cde4.xlsx)
  - [CUMCM 2022-A 赛题附件 4.xlsx](https://www.writebug.com/static/uploads/2024/8/9/17a60fecb9187c65837e205c6d961ec3.xlsx)
- 优秀论文：
  - [CUMCM 2022-A 优秀论文 A001.pdf](https://www.writebug.com/static/uploads/2024/7/27/12180c187ed5a3f4cdbbbd697d57b236.pdf)
  - [CUMCM 2022-A 优秀论文 A022.pdf](https://www.writebug.com/static/uploads/2024/7/27/f5ff8104f75b57dfd4b5383a6608f768.pdf)
  - [CUMCM 2022-A 优秀论文 A171.pdf](https://www.writebug.com/static/uploads/2024/7/27/152e6220668abf09f9da22a60cc8a86c.pdf)
- 成果：
  - pdf: <button onclick="window.open('https://s.b1n.net/y52Nc')" type="button">click</button>
  - tex: <button onclick="window.open('https://www.writebug.com/git/YiDingg/WB.YiDingg/raw/branch/main/%E5%9B%BD%E8%B5%9B2022A.tex')" type="button">click</button>

<!-- ### ode 求解器的函数句柄

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
 -->

## CUMCM 2020-A 

- 主题：炉温曲线
- 重点：PDE、ODE、最优化
- 时间：2023年11月（自研）
- 重做时间：2024年7月（自研）
- 赛题：
  - [CUMCM 2020-A 赛题.docx](https://www.writebug.com/static/uploads/2024/7/27/f2103d42290b446d13197930ec1c9258.docx)
  - [CUMCM 2020-A 赛题附件.xlsx](https://www.writebug.com/static/uploads/2024/8/9/508db691b838cb1c76f89d0e425dd127.xlsx)
- 优秀论文：
  - [CUMCM 2022-A 优秀论文 A070.pdf](https://www.writebug.com/static/uploads/2024/7/27/3d504a7e2fc22b936b92dacc8e403c41.pdf)
  - [CUMCM 2022-A 优秀论文 A147.pdf](https://www.writebug.com/static/uploads/2024/7/27/a246ab85e0b87d9dd7aeb681e725ef2a.pdf)
  - [CUMCM 2022-A 优秀论文 A195.pdf](https://www.writebug.com/static/uploads/2024/7/27/1fcd73a55232834c3d8e1eb7241a3518.pdf)
  - [CUMCM 2022-A 优秀论文 A212.pdf](https://www.writebug.com/static/uploads/2024/7/27/30fd4c6d0ad2dd6cfc7230d921b74867.pdf)
- 目前进度：完成问题一、二，问题三完成 80%。需要构建数值积分函数，重新优化问题三的参数，然后完成问题四；网格和模拟退火改为进度条。

详见 [MM(1.1): CUMCM 2022-A](Notes/MathematicalModeling/MM(1.1)-CUMCM2022A.md)。


## CUMCM 2023-A 
- 主题：定日镜场的优化设计
- 重点：坐标系转换，逻辑矩阵与逻辑索引，投影计算，平面离散
- 时间：2024年8月（集训）
- 赛题：
  - [CUMCM 2023-A 赛题.pdf](https://www.writebug.com/static/uploads/2024/8/6/fb38a2f5e0f1435bf0ad9804633bb0e2.pdf)
  - [CUMCM 2023-A 赛题附件.xlsx](https://www.writebug.com/static/uploads/2024/8/6/de25c88e35f98a56e71c59165d4f2036.xlsx)
- 优秀论文：
  - [CUMCM 2023-A 优秀论文 A092.pdf](https://www.writebug.com/static/uploads/2024/8/6/f7c567e8924efa866ba54e83443276df.pdf)
  - [CUMCM 2023-A 优秀论文 A127.pdf](https://www.writebug.com/static/uploads/2024/8/6/79a0777f982a0db762adc5d7fc4febb2.pdf)
  - [CUMCM 2023-A 优秀论文 A165.pdf](https://www.writebug.com/static/uploads/2024/8/6/6423084bd3029444d7604312440d941b.pdf)
  - [CUMCM 2023-A 优秀论文 A175.pdf](https://www.writebug.com/static/uploads/2024/8/6/83f95a4d8175e51ab53d50a9b587ccf5.pdf)
- 目前进度：问题一完成 70%。需要完成问题一塔阴影的收尾，并修改镜阴影干涉的计算原理（改为仅离散 $A$，确定 $B$ 的阴影面和 $A$ 的反射遮挡面后，计算重合情况）。还要整理离散函数 `Discrete()`。

详见 [MM(1.2): CUMCM 2023-A](Notes/MathematicalModeling/MM(1.2)-CUMCM2023A.md)。

## CUMCM 2023-B
- 时间：2024年8月（集训）
- 赛题：
  - [CUMCM 2023-B 赛题.pdf](https://www.writebug.com/static/uploads/2024/8/9/4693a624a6cea21bcf2a071afa57d43a.pdf)
  - [CUMCM 2023-B 赛题附件.xlsx](https://www.writebug.com/static/uploads/2024/8/9/4b2680c148c0fa58fc4dde784cc46555.xlsx)
- 优秀论文：





## CUMCM 2021-A 
- 时间：待定

## MCM 2023-A

- 时间：待定

<!-- - 成果：
  - pdf: <button onclick="window.open('')" type="button">click</button>
  - tex: <button onclick="window.open('')" type="button">click</button> -->