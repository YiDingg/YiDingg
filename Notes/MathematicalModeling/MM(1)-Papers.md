# Mathematical Modeling (1): Papers

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 12:45 on 2024-08-17 in Lincang.

## 官网

- [CUMCM](http://www.mcm.edu.cn/)
- [MCM/ICM](https://www.contest.comap.com/undergraduate/contests/index.html)

下面的内容大致按照实际做题时间顺序排列。

## CUMCM 2022-A

- 主题：波浪能最大输出功率设计
- 重点：ODE，二维曲线拟合，最优化
- 时间：2024 年 1 月（集训）
- 目前进度：已全部完成。
- 详见：[MM (1.4): CUMCM 2022-A](Notes/MathematicalModeling/MM(1.4)-CUMCM2022A.md)


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
- 重点：PDE，ODE，二维曲线拟合，最优化
- 时间：2023年11月（自研）
- 重做时间：2024年7月（自研）
- 目前进度：完成问题一、二，问题三完成 80%。需要构建数值积分函数，重新优化问题三的参数，然后完成问题四；网格和模拟退火改为进度条。
- 详见：[MM(1.1): CUMCM 2020-A](Notes/MathematicalModeling/MM(1.1)-CUMCM2020A.md)


## CUMCM 2023-A 
- 主题：定日镜场的优化设计
- 重点：坐标系转换，逻辑矩阵与逻辑索引，投影计算，平面离散
- 时间：2024年8月（集训）
- 目前进度：问题一完成 70%。需要完成问题一塔阴影的收尾，并修改镜阴影干涉的计算原理（改为仅离散 $A$，确定 $B$ 的阴影面和 $A$ 的反射遮挡面后，计算重合情况），最后整理自定义离散函数 `MyDiscrete()`。
- 详见：[MM(1.2): CUMCM 2023-A](Notes/MathematicalModeling/MM(1.2)-CUMCM2023A.md)

## CUMCM 2023-B

- 主题：多波束测线布设与优化
- 重点：迭代，二维三维曲线拟合，最优化
- 时间：2024年8月（集训）
- 目前进度：问题一二三已完成，问题四勉强算完成，需要进一步处理已知 bug。
- 详见：[MM(1.3): CUMCM 2023-B](Notes/MathematicalModeling/MM(1.3)-CUMCM2023B.md)



## CUMCM 2021-A 
- 主题：
- 重点：
- 时间：
- 目前进度：
- 详见：[]()


## MCM 2023-A
- 主题：
- 重点：
- 时间：
- 目前进度：
- 详见：[]()

<!-- - 成果：
  - pdf: <button onclick="window.open('')" type="button">click</button>
  - tex: <button onclick="window.open('')" type="button">click</button> -->