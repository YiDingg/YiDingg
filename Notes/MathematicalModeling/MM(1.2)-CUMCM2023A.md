# Mathematical Modeling (1.2): CUMCM 2023-A

## 概览

- 主题：定日镜场的优化设计
- 重点：
- 时间：2024年8月（集训）
- 赛题：[CUMCM 2023-A 赛题.pdf](https://www.writebug.com/static/uploads/2024/8/6/fb38a2f5e0f1435bf0ad9804633bb0e2.pdf)，[CUMCM 2023-A 赛题附件.xlsx](https://www.writebug.com/static/uploads/2024/8/6/de25c88e35f98a56e71c59165d4f2036.xlsx)
- 优秀论文：
  - [CUMCM 2023-A 优秀论文 A092.pdf](https://www.writebug.com/static/uploads/2024/8/6/f7c567e8924efa866ba54e83443276df.pdf)
  - [CUMCM 2023-A 优秀论文 A127.pdf](https://www.writebug.com/static/uploads/2024/8/6/79a0777f982a0db762adc5d7fc4febb2.pdf)
  - [CUMCM 2023-A 优秀论文 A165.pdf](https://www.writebug.com/static/uploads/2024/8/6/6423084bd3029444d7604312440d941b.pdf)
  - [CUMCM 2023-A 优秀论文 A175.pdf](https://www.writebug.com/static/uploads/2024/8/6/83f95a4d8175e51ab53d50a9b587ccf5.pdf)
- 成果：
  - pdf: <button onclick="window.open('')" type="button">click</button>
  - tex: <button onclick="window.open('')" type="button">click</button>

## 赛题参考

赛题参考文献：
- [百度百科，太阳方位角](https://baike.baidu.com/item/%E5%A4%AA%E9%98%B3%E6%96%B9%E4%BD%8D%E8%A7%92?fromModule=lemma_search-box)
- [百度百科，太阳高度角](https://baike.baidu.com/item/%E5%A4%AA%E9%98%B3%E9%AB%98%E5%BA%A6%E8%A7%92?fromModule=lemma_search-box)
- [张平等，太阳能塔式光热镜场光学效率计算方法](https://www.writebug.com/static/uploads/2024/8/6/36b2b74b36f28316d124b4b8947e5b80.pdf)
  - [郭苏，刘德有. 考虑接收塔阴影的定日镜有效利用率计算](https://www.writebug.com/static/uploads/2024/8/6/a2e9f19a64b7b432fdd6172a9c8ff2da.pdf)
  - [魏秀东，王瑞庭，张红鑫，等. 太阳能塔式热发电聚光场的光学性能分析](https://www.writebug.com/static/uploads/2024/8/6/1b4efe831d3a4d80dc82e2a8039d976f.pdf)
  - [张国勋，饶孝枢. 塔式太阳能聚光系统太阳影像方程]
  - [王瑞庭. 太阳能塔式电站镜场对地面的遮阳分析](https://www.writebug.com/static/uploads/2024/8/6/a694f5b427bb14d5feb635161e56895d.pdf)
- [蔡志杰，太阳影子定位](https://www.writebug.com/static/uploads/2024/8/6/0240387e2925be24c4583620f89aa98d.pdf)
- [杜宇航等，塔式光热电站定日镜不同聚焦策略的影响分析](https://www.writebug.com/static/uploads/2024/8/6/2f86f7edc7912218b19c83e5ac0cbc1c.pdf)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-06-10-33-10_MM(1.2)-CUMCM2023A.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-06-10-30-37_MM(1.2)-CUMCM2023A.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-06-10-31-17_MM(1.2)-CUMCM2023A.jpg"/></div>

其它参考：
- 镜场光学效率模型：[刘建兴，塔式光热电站光学效率建模仿真及定日镜场优化布置.pdf](https://www.writebug.com/static/uploads/2024/8/6/b31db11947701a560c9acaa36f2f5d40.pdf)


## 示意图与数据准备

物理量规定：
$$
\begin{align*}
    & 安装高度：H_{\mathrm{he}}，H_{\mathrm{he}} \ge \frac{l_{\mathrm{he}}}{2} （定日镜中心高度，两转轴交点，heliostat）\\
    & 吸收塔高度：H_{\mathrm{co}} = 80\ \mathrm{m}（集热器中心高度，collector）\\ 
    & 集热器高度：h_{\mathrm{co}} = 8\ \mathrm{m}\\
    & 集热器半径：r_{\mathrm{co}} = 3.5\  \mathrm{m}\\
    & 镜面宽度：d_{\mathrm{he}}，2\ \mathrm{m}  \le d_{\mathrm{he}} \le 8\ \mathrm{m}，d_{\mathrm{he}} \ge h_{\mathrm{he}}  \\ 
    & 镜面纵长：l_{\mathrm{he}}，2\ \mathrm{m}  \le l_{\mathrm{he}} \le 8  \\ 
    & 镜面高度：h_{\mathrm{he}} \\ 
    & 相邻底座中心距离：\Delta r，\Delta r \ge d_{\mathrm{he}} + 5\ \mathrm{m} \\ 
\end{align*}
$$

还有：

$$
\begin{align*}
    &太阳高度角：\alpha_{\mathrm{s}}  = \alpha_{\mathrm{s}}(D,ST,\varphi)\\ 
    &太阳方位角：\gamma_s = \gamma_s(D,ST,\varphi)\\ 
    &法向辐射辐照度：\mathrm{DNI} = \mathrm{DNI}(\alpha_s, H)\\ 
    &镜场输出热功率：E_{\mathrm{field}} = E_{\mathrm{field}}(\mathrm{DNI}, N, A_i, \eta_i) \\
    &定日镜光学效率：\eta = \eta_{\mathrm{sb}} \eta_{\mathrm{cos}} \eta_{\mathrm{at}} \eta_{\mathrm{trunc}} \eta_{\mathrm{ref}} \\
    &\eta_{\mathrm{sb}}：阴影遮挡效率，涉及镜阴影损失、镜挡光损失、塔阴影损失 \\ 
    &\eta_{\mathrm{trunc}}：集热器截断效率\\ 
    &\eta_{\mathrm{cos}}：余弦效率 \\ 
    &\eta_{\mathrm{at}}：大气透射率 =0.99321-0.0001176d_{\mathrm{HR}}+1.97\times10^{-8}\times d_{\mathrm{HR}}^2\quad(d_{\mathrm{HR}}\leq1000) \\ 
    &\eta_{\mathrm{ref}}：镜面反射率，赛题中取常数 0.92 \\ 
\end{align*}
$$


## 问题一

问题一的难点在于建立镜场光学效率计算模型。

### 镜面各参数求解

给定镜面 $A$ 中心坐标（地面坐标系） $\vec{O}_A = (x_{OA}, y_{OA}, H_{\mathrm{he}})$、吸收塔坐标 $\vec{O}_C = (0,0,H_{\mathrm{co}})$，求从镜面中心指向集热器的光线的单位向量 $\vec{V}_{A,\mathrm{co}}$（其它位置反射后视为光锥）：

$$
\vec{V}_{A,\mathrm{co}} = \frac{\vec{O}_C - \vec{O}_A}{ \left|  \vec{O}_C - \vec{O}_A \right| } 
$$

给定太阳高度角 $\alpha_s$、太阳方位角 $\gamma_s$，求太阳入射方向的单位向量 $\vec{V}_{\mathrm{sun}}$（地面坐标系，从镜面指向太阳）：

$$
\vec{V}_{\mathrm{sun}} = 
\begin{bmatrix}a\\ b\\ c\end{bmatrix} = 
\begin{bmatrix}
\cos\alpha_s\sin\gamma_s\\ 
\cos\alpha_s\cos\gamma_s\\ 
\sin\alpha_s
\end{bmatrix}
$$

根据上面两个向量，求镜面 $A$ 的单位法向量 $\vec{S}_A$：

$$
\vec{S}_A = (x,y,z) = 
\frac{\vec{V}_{A,\mathrm{co}} + \vec{V}_{\mathrm{sun}}}{\left|\vec{V}_{A,\mathrm{co}} + \vec{V}_{\mathrm{sun}}\right|}
$$

直角坐标转为球坐标 $(r,\theta,\phi)$ 后，依据 $\theta + \theta_z = \frac{\pi}{2}$ 和 $\phi + \theta_s = \frac{\pi}{2}$，求得定日镜的俯仰角 $\theta_z$ 和方位角 $\theta_s$（方位角数值规定与太阳方位角相同）：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-06-17-58-30_MM(1.2)-CUMCM2023A.png"/></div>

$$
\theta_z = \frac{\pi}{2} - \arccos z \\ 
\theta_s = \frac{\pi}{2} - \mathrm{Arctan}(y,x) \\
\mathrm{Arctan}(y,x) = \begin{cases}\arctan\left(y/x\right)&(x>0)\\\arctan\left(y/x\right)+\pi&(x<0,y\geqslant0)\\\arctan\left(y/x\right)-\pi&(x<0,y<0)\\\pi/2&(x=0,y>0)\\-\pi/2&(x=0,y<0)\\0&(x=0,y=0)&\end{cases}
$$

记镜面宽度 $d_{\mathrm{he}} = P_1P_2$，镜面长度 $l_{\mathrm{he}} = P_1P_4$ ，利用 $\overrightarrow{O_AP_1} = \vec{e}_1 + \vec{e}_2，\vec{e}_1 = (-\cos\theta_s, \sin\theta_s, 0)$ 和 $\vec{e_2} = \vec{S}_A \times \vec{e}_1$，$ 求得定日镜的四个顶点坐标 $\vec{P}_1, \vec{P}_2, \vec{P}_3, \vec{P}_4$：

$$
\vec{P}_1 = \vec{e_1} + \vec{e_2} = (\begin{bmatrix}1 \\1 \\1\end{bmatrix} + \vec{S}_A ) \times \vec{e}_1 \\ 
\vec{P}_2 = -\vec{e_1} + \vec{e_2} = (-\begin{bmatrix}1 \\1 \\1\end{bmatrix} + \vec{S}_A ) \times \vec{e}_1 \\ 
\vec{P}_3 = -\vec{e_1} - \vec{e_2} = (-\begin{bmatrix}1 \\1 \\1\end{bmatrix} - \vec{S}_A ) \times \vec{e}_1 \\ 
\vec{P}_4 = \vec{e_1} - \vec{e_2} = (\begin{bmatrix}1 \\1 \\1\end{bmatrix} - \vec{S}_A ) \times \vec{e}_1 \\ 
$$

<!-- $$
\begin{cases}
    x_{P1}=x_{OA}
    +\frac{1}{2}d_{\mathrm{he}}\cdot\left(\cos\theta_s- \sin\theta_s\right)\\
    x_{P2}=x_{OA}
    +\frac{1}{2}d_{\mathrm{he}}\cdot\left(-\cos\theta_s- \sin\theta_s \right)\\ 
    x_{P3}=x_{OA}
    +\frac{1}{2}d_{\mathrm{he}}\cdot\left(-\cos\theta_s+ \sin\theta_s \right)\\
    x_{P4}=x_{OA}
    +\frac{1}{2}d_{\mathrm{he}}\cdot\left(+\cos\theta_s+ \sin\theta_s \right)
\end{cases} \\
\begin{cases}
y_{P1}=y_{OA}
+\frac{1}{2}l_{\mathrm{he}}\cdot\left(+ \cos\theta_s+ \sin\theta_s \right)\\
y_{P2}=y_{OA}
+\frac{1}{2}l_{\mathrm{he}}\cdot\left(+ \cos\theta_s- \sin\theta_s \right)\\ 
y_{P3}=y_{OA}
+\frac{1}{2}l_{\mathrm{he}}\cdot\left(- \cos\theta_s- \sin\theta_s \right)\\
y_{P4}=y_{OA}
+\frac{1}{2}l_{\mathrm{he}}\cdot\left(- \cos\theta_s+ \sin\theta_s \right) \\ 
\end{cases} \\
\begin{cases}
z_{P1}=z_{P2}=H_{\mathrm{he}}
+\frac{1}{2}l_{\mathrm{he}}\cdot\sin(\theta_z)\\
z_{P3}=z_{P4}=H_{\mathrm{he}}
-\frac{1}{2}l_{\mathrm{he}}\cdot\sin(\theta_z)
\end{cases}
$$
 -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-06-18-40-46_MM(1.2)-CUMCM2023A.png"/></div>

### 阴影遮挡效率

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-06-17-05-59_MM(1.2)-CUMCM2023A.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-06-17-06-31_MM(1.2)-CUMCM2023A.png"/></div>
























---

分界线（下面的不要了）

---
题目物理量要求：
$$
d_{\mathrm{he}} = l_{\mathrm{he}} = 6\  \mathrm{m}\ ,\ \ H_{\mathrm{he}} = 4\  \mathrm{m}
$$

光学效率计算模型主要参考了 [刘建兴，塔式光热电站光学效率建模仿真及定日镜场优化布置.pdf](https://www.writebug.com/static/uploads/2024/8/6/b31db11947701a560c9acaa36f2f5d40.pdf)

### 镜阴影损失、挡光损失

阴影挡光损失 = 镜阴影损失 + 镜挡光损失 + 塔阴影损失 

前两种损失参考：[张平等，太阳能塔式光热镜场光学效率计算方法[J]，技术与市场，2021，28(6):5-8.](https://www.writebug.com/static/uploads/2024/8/6/36b2b74b36f28316d124b4b8947e5b80.pdf)

在 $A$ 镜坐标系下，$A$ 镜中某一点 $H_A$，经过光线落入 $B$ 镜中的坐标为 $H_B$，计算阴影挡光损失的过程，即由已知 $H_A$ ，求 $H_B$，再判断 $H_B$ 是否在镜面内。

$A$ 镜到 $B$ 镜的坐标转换矩阵为（传统定日镜旋转机制）：

$$
H_{B} = T\cdot H_{A}
T=
\begin{bmatrix}l_x&l_y&l_z\\\\m_x&m_y&m_z\\\\n_x&n_y&n_z\end{bmatrix} = 
\begin{bmatrix}-\sin E_H&-\sin A_H&\cos E_H&\cos A_H&\cos E_H\\\\\cos E_H&-\sin A_H&\sin E_H&\cos A_H&\sin E_H\\\\0&\cos A_H&\sin A_H \end{bmatrix}
$$


设光线向量在地面坐标系中为 $\vec{V}_0 = \begin{bmatrix}a,b,c\end{bmatrix}^T$，在镜面坐标系中为 $\vec{V}_1$，则有 $\vec{V}_0 = T \cdot \vec{V}_1$

记 $A$ 镜中某点为 $H_{A} = \begin{bmatrix}x_A,y_A,0\end{bmatrix}^T$，此点在 $B$ 镜坐标系下的坐标记为 $H' = \begin{bmatrix}x',y',z'\end{bmatrix}^T$，$O_A = \begin{bmatrix}x_{OA}, y_{OA}, z_{OA}\end{bmatrix}^T$ 为 $A$ 镜坐标系原点在地面坐标系的坐标值，$O_B = \begin{bmatrix}x_{OB}, y_{OB}, z_{OB}\end{bmatrix}^T$ 为 $B$ 镜坐标系原点在地面坐标系的坐标值，下面求解 $H_B$：

$$
H_0 = T \cdot H_A + O_A\ （A 镜坐标与地面坐标）\\ 
H_0 = T \cdot H' + O_B\ （B 镜坐标与地面坐标）\\ 
\Longrightarrow H' = H_A + T^{-1} (O_A - O_B) = T^{*} (O_A - O_B)\ （T 为实正交矩阵）
$$

类似地，再对光线向量 $\vec{V}_0$ 进行坐标转换，求$H'$与光线向量所确定的直线与镜面$B$的交点，最终可以得到：

$$
H_{B} = 
\begin{bmatrix}x_B\\ y_B\\ 0\end{bmatrix} = 
\begin{bmatrix}
\frac{cx' - az'}{c}\\
\frac{cy' - bz'}{c}\\ 
0
\end{bmatrix}\ ,\ \ 
\vec{V}_0 = \begin{bmatrix}a\\ b\\ c\end{bmatrix} = 
\begin{bmatrix}
a\\ b\\ c
\end{bmatrix}
 为光线向量（地面坐标系）\\
H' = 
\begin{bmatrix}x'\\ y'\\ z'\end{bmatrix} = 
H_A + T^{*} (O_A - O_B) = 
\begin{bmatrix}x_A\\ y_A\\ 0\end{bmatrix} + T^*\cdot 
\begin{bmatrix}x_{OA}-x_{OB}\\ y_{OA}-y_{OB}\\ z_{OA}-z_{OB}\end{bmatrix}
$$

计算镜阴影损失时，设 $A$ 镜在前 $B$ 镜在后，光线向量大致指向镜面，若计算出的 $H_B$ 在 $B$ 镜内，则说明此点被 $A$ 镜所阴，无法接收到光线。计算镜挡光损失时，设光线向量为 $B$ 镜反射后的光线，若计算出的 $H_B$ 在 $B$ 镜内，则说明此点反射出的光线被 $A$ 镜所挡，无法到达集热器。

构建函数：$\mathrm{Logic} = f(H_B, H_A, \vec{V}_0, H_D, O_A, O_B, T)$。

对于镜阴影损失，

### 塔阴影损失 

阴影挡光损失 = 镜阴影损失 + 镜挡光损失 + 塔阴影损失 

塔阴影损失参考 [考虑接收塔阴影的定日镜有效利用率计算.pdf](https://www.writebug.com/static/uploads/2024/8/6/a2e9f19a64b7b432fdd6172a9c8ff2da.pdf)

### 截断效率

截断效率参考 [张平等，太阳能塔式光热镜场光学效率计算方法[J]，技术与市场，2021，28(6):5-8.](https://www.writebug.com/static/uploads/2024/8/6/36b2b74b36f28316d124b4b8947e5b80.pdf)

### 

### 阴影遮挡效率

