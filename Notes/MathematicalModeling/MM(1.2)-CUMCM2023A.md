# Mathematical Modeling (1.2): CUMCM 2023-A

## 概览

- 主题：定日镜场的优化设计
- 重点：
- 时间：2024年8月（集训）
- 赛题：
  - [CUMCM 2023-A 赛题.pdf](https://www.writebug.com/static/uploads/2024/8/6/fb38a2f5e0f1435bf0ad9804633bb0e2.pdf)
  - [CUMCM 2023-A 赛题附件.xlsx](https://www.writebug.com/static/uploads/2024/8/6/de25c88e35f98a56e71c59165d4f2036.xlsx)
- 优秀论文：
  - [CUMCM 2023-A 优秀论文 A092.pdf](https://www.writebug.com/static/uploads/2024/8/6/f7c567e8924efa866ba54e83443276df.pdf)
  - [CUMCM 2023-A 优秀论文 A127.pdf](https://www.writebug.com/static/uploads/2024/8/6/79a0777f982a0db762adc5d7fc4febb2.pdf)
  - [CUMCM 2023-A 优秀论文 A165.pdf](https://www.writebug.com/static/uploads/2024/8/6/6423084bd3029444d7604312440d941b.pdf)
  - [CUMCM 2023-A 优秀论文 A175.pdf](https://www.writebug.com/static/uploads/2024/8/6/83f95a4d8175e51ab53d50a9b587ccf5.pdf)

<!-- - 成果：
  - pdf: <button onclick="window.open('')" type="button">click</button>
  - tex: <button onclick="window.open('')" type="button">click</button>
 -->

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

给定太阳高度角 $\alpha_s$、太阳方位角 $\gamma_s$，求太阳入射方向的单位向量 $\vec{V}_{\mathrm{sun}}$（地面坐标系，从太阳指向镜面）：

$$
\vec{V}_{\mathrm{sun}} = 
\begin{bmatrix}a\\ b\\ c\end{bmatrix} = -
\begin{bmatrix}
\cos\alpha_s\sin\gamma_s\\ 
\cos\alpha_s\cos\gamma_s\\ 
\sin\alpha_s
\end{bmatrix}
$$

根据上面两个向量，求镜面 $A$ 的单位法向量 $\vec{S}_A$：

$$
\vec{S}_A = (x,y,z) = 
\frac{\vec{V}_{A,\mathrm{co}} - \vec{V}_{\mathrm{sun}}}{\left|\vec{V}_{A,\mathrm{co}} - \vec{V}_{\mathrm{sun}}\right|}（注意这里的正负号）
$$

直角坐标转为球坐标 $(r,\theta,\phi)$ 后，依据 $\theta + \theta_z = \frac{\pi}{2}$ 和 $\phi + \theta_s = \frac{\pi}{2}$，求得定日镜的俯仰角 $\theta_z$ 和方位角 $\theta_s$（方位角数值规定与太阳方位角相同）：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-06-17-58-30_MM(1.2)-CUMCM2023A.png"/></div>

$$
\theta_z = \frac{\pi}{2} - \arccos z \\ 
\theta_s = \frac{\pi}{2} - \mathrm{Arctan}(y,x) \\
\mathrm{Arctan}(y,x) = 
\begin{cases}\arctan\left(y/x\right)&(x>0)\\
\arctan\left(y/x\right)+\pi&(x<0,y\geqslant0)\\
\arctan\left(y/x\right)&(x<0,y<0)\\
\pi/2&(x=0,y>0)\\-\pi/2&(x=0,y<0)\\
0&(x=0,y=0)&\end{cases}
$$

记镜面宽度 $d_{\mathrm{he}} = P_1P_2$，镜面长度 $l_{\mathrm{he}} = P_1P_4$ ，利用 $\overrightarrow{O_AP_1} = \vec{e}_1 + \vec{e}_2，\vec{e}_1 = (-\cos\theta_s, \sin\theta_s, 0)$ 和 $\vec{e_2} = \vec{S}_A \times \vec{e}_1$， 求得定日镜的四个顶点坐标 $\vec{P}_1,\vec{P}_2,\vec{P}_3,\vec{P}_4$ ：

$$
\vec{P}_1 =\vec{O}_A +  \vec{e_1} + \vec{S}_A \times \vec{e}_1\\ 
\vec{P}_2 =\vec{O}_A   -\vec{e_1} +\vec{S}_A \times \vec{e}_1\\ 
\vec{P}_3 =\vec{O}_A   -\vec{e_1} - \vec{S}_A \times \vec{e}_1\\ 
\vec{P}_4 =\vec{O}_A +  \vec{e_1} - \vec{S}_A \times \vec{e}_1\\ 
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-06-18-40-46_MM(1.2)-CUMCM2023A.png"/></div>


### 阴影遮挡效率


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-06-17-05-59_MM(1.2)-CUMCM2023A.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-06-17-06-31_MM(1.2)-CUMCM2023A.png"/></div>

阴影挡光损失 = 镜阴影损失 + 镜挡光损失 + 塔阴影损失 

**根据下面步骤求解所有镜面的阴影效率：**

- 在一定范围内（最大干涉距离，见后文），选取一个可能发生干涉的镜面 $B$
- 计算镜面 $B$ 在镜面 $A$ 上的遮光量
- 计算镜面 $A$ 反射光被 $B$ 所挡住的量
- 计算吸收塔在 $A$ 镜上的遮光量
- 确定 $A$ 镜的阴影遮挡效率
- 重复上述步骤，直至得到所有镜面的阴影遮挡效率

已知镜 $A$ 四个顶点 $\vec{P}_i = (x_i,y_i,z_i)$ 和太阳入射向量 $\vec{V}_{\mathrm{sun}} = (V_x, V_y, V_z)$，求解地面投影区域的公式：

$$
\vec{P}_{i,\mathrm{gnd}} = 
\begin{bmatrix}
    x_i - \frac{V_x}{V_z}z_i \\
    y_i - \frac{V_y}{V_z}z_i \\
    0
\end{bmatrix}\ ,\ \ i = 1,2,3,4
$$

**求解最大干涉距离（针对问题一）的思路：**

- 任意选取一个镜面 $A$，计算其在时刻 09:00 ~ 15:00 内的最远干涉距离（间隔一小时）
- 重复上面计算，直至得到所有镜面的最远干涉距离
- 最远中取最大，即得结果

``` matlab 
tic
Result = zeros(length(Appendix(:,1)),4);
for i = 1: length(Appendix(:,1))
    OA = [Appendix(i,:), H_he];
    for j = 1:12
        D = D_Array(j);
        for ST = 9:1:15
            P_gnd =  GetShade(OA, OC, D, varphi, ST);
            test = sqrt(sum((P_gnd(1:2,:) - OA(1:2)').^2));
            Result(i,:) = max(Result(i,:),test);
        end
    end
    %disp([num2str(i/length(Appendix(:,1))*100), '%'])
end
distance_max = max(Result,[],"all")
toc
```

``` output
distance_max = 20.2165
历时 0.808092 秒。
```


然后大致确定一下所有镜面的干涉情况，镜面最小距离为 $11.6805\  \mathrm{m}$，最大干涉距离 $20.2165\  \mathrm{m}$，因此会产生阴影或遮挡干涉。

``` matlab 
Result = zeros(Num_heliostat,1);
Distans_min = Inf;
for i = 1:Num_heliostat
    OA = Heliostat(i,:);
    x = (Heliostat - OA).^2;
    x(i,:) = [100 100 100];
    Distans = sqrt(sum(x,2));
    Distans_min = min( Distans_min, min(Distans) );
end
disp(num2str(Distans_min))
if Distans_min < 20.22
   disp("发生阴影或遮挡干涉！")
end
```

``` output 
11.6805
发生阴影或遮挡干涉！
```



**计算镜面 $A$ 在镜面 $B$ 上的遮光量：**


在 $A$ 镜坐标系下，$A$ 镜（目标镜）中某一点 $P$ 的坐标 $\vec{x}_{P,A}$，沿太阳入射光投影到 $B$ 镜（最大范围内任意选取的）上记为点 $Q$，坐标 $\vec{x}_{Q,B}$（镜 $B$ 坐标系），计算阴影挡光损失的过程，即由已知 $\vec{x}_{P,A}$ ，求 $\vec{x}_{Q,B}$，再判断 $\vec{x}_{Q,B}$ 是否在镜面内。

在一定范围（第一层筛选）内选取镜面 $B$ 后，需要判断 $B$ 的影子方向是否朝 $A$，将太阳光线向量（指向镜面）在地面坐标系中为 $\vec{V}_{\mathrm{sun},O} = \begin{bmatrix}a,b,c\end{bmatrix}^T$，这作了第二层筛选：

$$
\vec{x}_{AB,O}\cdot\vec{V}_{\mathrm{sun},O} > 0
$$

然后建立 $\vec{x}_{Q,B}$ 的计算公式：

记 $A$ 镜中一点 $P$ 为 $\vec{x}_{P,A} = \begin{bmatrix}x_A,y_A,0\end{bmatrix}^T$，此点在地面坐标系下的坐标记为 $\vec{x}_{P,O}$，在 $B$ 镜坐标系下的坐标记为 $\vec{x}_{P,B} = \begin{bmatrix}x_{P,B},y_{P,B},z_{P,B}\end{bmatrix}^T$，$\vec{x}_{A,O}$ 为 $A$ 镜坐标系原点在地面坐标系的坐标值，$\vec{x}_{B,O}$ 为 $B$ 镜坐标系原点在地面坐标系的坐标值，下面求解投影点 $\vec{x}_{Q,B}$：

镜面坐标系 $A$ 与地面坐标系 $O$ 之间的转换矩阵记为 $T$，则有：

$$
\vec{x}_{P,O} - \vec{x}_{A,O}= T_A \cdot (\vec{x}_{P,A} - \vec{x}_{A,A}) = T_A \cdot \vec{x}_{P,A}\\
T=\begin{bmatrix}\sin\theta_s&-\sin\theta_z\cos\theta_s&\cos\theta_z\cos\theta_s\\\\-\cos\theta_s&-\sin\theta_z\sin\theta_s&\cos\theta_z\sin\theta_s\\\\0&\cos\theta_z&\sin\theta_z\end{bmatrix}
$$

于是：

$$
\vec{x}_{P,O} = T_A \cdot \vec{x}_{P,A} + \vec{x}_{A,O}\ （A 镜坐标与地面坐标）\\ 
\vec{x}_{P,O} = T_B \cdot \vec{x}_{P,B} + \vec{x}_{B,O}\ （B 镜坐标与地面坐标）\\ 
\Longrightarrow \vec{x}_{P,B} = T_B^{*} \cdot \left( T_A\cdot \vec{x}_{P,A} + \vec{x}_{A,O} - \vec{x}_{B,O}\right)（T 为实正交矩阵）
$$

然后沿光路 $\vec{V}_{\mathrm{sun},O}$ 计算在 $B$ 镜上的投影点 $Q$：

$$
\vec{V}_{\mathrm{sun},O} = T_B \cdot \vec{V}_{\mathrm{sun},B} + \vec{x}_{B,O}
\Longrightarrow 
\vec{V}_{\mathrm{sun},B} = T_B^* \cdot (\vec{V}_{\mathrm{sun},O}  - \vec{x}_{B,O})（T 为实正交矩阵）
$$

这样便得到了 B 镜坐标系中的点 $P$ 坐标 $\vec{x}_{P,B}$ 和光线向量 $ \vec{V}_{\mathrm{sun},B}$，由此确定直线，令 $z$ 坐标为零即得投影点 $Q$：

$$
\vec{x}_{Q,B}  = 
\begin{bmatrix}
    x_{P,B} - \frac{V_{x,B}}{V_{z,B}}z_{P,B} \\
    y_{P,B} - \frac{V_{y,B}}{V_{z,B}}z_{P,B} \\
    0
\end{bmatrix}
$$

然后判断 $\vec{x}_{Q,B}$ 的横纵坐标范围即可。

为了检验代码正确性，可以考虑验证 $\vec{x}_{Q,O}$ 的位置并作图：

$$
\vec{x}_{Q,O} = 
T_B\cdot\vec{x}_{Q,B} + \vec{x}_{B,O}
$$

<span style="color:red">
采用上面方法计算转换矩阵 T 时，似乎有些不对，我们摒弃，改为采用下面的方法：
</span>

镜面坐标系 $A$ 到地面坐标系 $O$ 的转换关系单位矩阵为：
$$
T =
\begin{bmatrix}
l_x&l_y&l_z\\
m_x&m_y&m_z\\
n_x&n_y&n_z
\end{bmatrix}
$$



$\begin{bmatrix}l_x \\ m_x \\ n_x\end{bmatrix}, 
\begin{bmatrix}l_y \\ m_y \\ n_y\end{bmatrix}, 
\begin{bmatrix}l_z \\ m_z \\ n_z\end{bmatrix}$ 是镜面坐标系 $A$ 的 3 个轴在地面坐标系 $O$ 的向量表示，也即 $\vec{e}_{A,O,1}^T, \vec{e}_{A,O,2}^T, \vec{e}_{A,O,3}^T$

设镜 $A$ 的横轴在地面坐标系中的向量表示为 $\vec{e}_{A,O,1}$，其与地面坐标系 $O$ 的 $xy$ 平面平行，而镜面的法向量即为 $A$ 系的 $z$ 轴，即 $\vec{e}_{A,O,3} = \vec{S}_A$，我们有：
$$
\begin{align*}
 &\vec{e}_{A,O,1} = -\frac{\vec{S}_A \times [0, 0, 1]^T}{\left| \vec{S}_A \times [0, 0, 1]^T \right| }（负号为考虑方向所得） \\ 
 &\vec{e}_{A,O,2}  = \vec{S}_A \times \vec{e}_{A,O,1}  \\
 &\vec{e}_{A,O,3}  = \vec{S}_A
\end{align*}
$$

由此得到转换矩阵 $T = [\vec{e}_{A,O,1}^T, \vec{e}_{A,O,2}^T, \vec{e}_{A,O,3}^T]$。

这样算出的投影点是正确的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-07-23-02-51_MM(1.2)-CUMCM2023A.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-07-23-03-23_MM(1.2)-CUMCM2023A.jpg"/></div>

``` matlab
（测试，修改了转换矩阵理论）镜A被镜B遮挡情况
ST = 9;
D = D_Array(4);

X_A_O = Heliostat(1,:)';
disp("镜A选择第一面镜")
X_B_O = Heliostat(2,:)';
disp("镜B选择第二面镜")
disp("点P在A系中的坐标：")
X_P_A = [0 0 0]'



[delta, omega, alpha, gamma, V_sun_O] = GetSun(D, varphi, ST);

figure
[P_A, S_A, ~, V_A_co, theta_z_A, theta_s_A] =  GetHeliostat(X_A_O', OC, V_sun_O); 
disp("镜A俯仰角")
rad2deg(theta_z_A)
disp("镜A方位角")
rad2deg(theta_s_A)
hold on 
[P_B, S_B, ~, V_B_co, theta_z_B, theta_s_B] =  GetHeliostat(X_B_O', OC, V_sun_O);
hold on

% 计算转换矩阵

e_A_O_1 = - cross(S_A, [0 0 1]') / norm( cross(S_A, [0 0 1]') )
e_A_O_2 = cross(S_A, e_A_O_1)
e_A_O_3 = S_A

quiver3(X_A_O(1), X_A_O(2), X_A_O(3), e_A_O_1(1),e_A_O_1(2),e_A_O_1(3))
hold on
quiver3(X_A_O(1), X_A_O(2), X_A_O(3), e_A_O_2(1),e_A_O_2(2),e_A_O_2(3))
quiver3(X_A_O(1), X_A_O(2), X_A_O(3), e_A_O_3(1),e_A_O_3(2),e_A_O_3(3))

e_B_O_1 = - cross(S_B, [0 0 1]') / norm( cross(S_B, [0 0 1]') )
e_B_O_2 = cross(S_B, e_A_O_1)
e_B_O_3 = S_B

    disp("A与O的转换矩阵：")
    T_A = [e_A_O_1, e_A_O_2, e_A_O_3]
    disp("B与O的转换矩阵：")
    T_B = [e_B_O_1, e_B_O_2, e_B_O_3]

disp("点P在B系中的坐标：")
X_P_B = T_B' * ( T_A*X_P_A + X_A_O - X_B_O )
disp("入射光向量（O系）：")
V_sun_O
disp("入射光向量（B系）：")
V_sun_B = T_B' * (V_sun_O - 0)
disp("投影点Q在B系中的坐标：")
X_Q_B = [
    X_P_B(1) - V_sun_B(1)/V_sun_B(3)*X_P_B(3)
    X_P_B(2) - V_sun_B(2)/V_sun_B(3)*X_P_B(3)
    0
    ]
disp("投影点Q在O系中的坐标：")
% 验证位置
X_Q_O  = T_B*X_Q_B + X_B_O
scatter3(X_Q_O(1),X_Q_O(2),X_Q_O(3),Marker="*")
```

镜面的离散可以使用向量来操作，即考虑 $\vec{x}_{P_2P_1,O}$ 和 $\vec{x}_{P_2P_3,O}$，如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-07-23-59-33_MM(1.2)-CUMCM2023A.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-08-00-03-24_MM(1.2)-CUMCM2023A.jpg"/></div>

``` matlab 
O = [0 0 0]';
X = [2 0 6]';
Y = [3 3 9]';
Area = [O, X, Y]
N_array = [5, 5]

% 数据准备
    OX = Area(:,2) -  Area(:,1);
    OY = Area(:,3) -  Area(:,1);
    N_x = N_array(1); N_y = N_array(2);
    e_x = OX/N_x; e_y = OY/N_y;
    % 矩阵初始化
    disc_x = 0:1:N_x;
    disc_y = 0:1:N_y;
    Discrete_matrix = zeros(N_x+1, N_y+1, 3);

    Add_x = disc_x * OX(1)/N_x + disc_y' * OY(1)/N_y;
    Add_y = disc_x * OX(2)/N_x + disc_y' * OY(2)/N_y;
    Add_z = disc_x * OX(3)/N_x + disc_y' * OY(3)/N_y;
    Discrete_matrix(:,:,1) = O(1) + Add_x
    Discrete_matrix(:,:,2) = O(2) + Add_y
    Discrete_matrix(:,:,3) = O(3) + Add_z

if 1
    figure
    scatter3(Discrete_matrix(:,:,1),Discrete_matrix(:,:,2),Discrete_matrix(:,:,3))
    hold on
    quiver3(O(1),O(2),O(3),OX(1),OX(2),OX(3))
    quiver3(O(1),O(2),O(3),OY(1),OY(2),OY(3))
end
```

需要注意的是：在写代码时，我们先给定镜面 $A$，再利用最大干涉距离和阴影方向，筛选出可能对 $A$ 产生干涉的镜面 $B$（一般有多个），然后对每个镜面 $B$，需要计算 $B$ 的阴影对 $A$ 的覆盖情况，再计算 $A$ 的反射光被 $B$ 遮挡情况。我们上面的公式讨论的是 $A$ 阴影对 $B$ 的覆盖情况，而不是代码中需要的 $B$ 阴影对 $A$ 的覆盖，在写代码时不要忘了对称过来。

另外，计算阴影覆盖时需要对 $B$ 离散，计算反射遮挡时需要对 $A$ 进行离散。

**计算镜面 $A$ 反射光遮挡情况：**


只需要将太阳入射向量 $\vec{V}_{\mathrm{sun}}$ 换为镜 $A$ 的反射光向量 $\vec{V}_{A2\mathrm{co}}$，其它过程完全类似：

$$
\vec{V}_{A2\mathrm{co},B} = T_B^* \cdot (\vec{V}_{A2\mathrm{co},O}  - \vec{x}_{B,O})（T 为实正交矩阵）
$$

 $B$ 镜坐标系中点 $P$（为镜 $A$ 上一点） 坐标公式不变，这样便得到了 $\vec{x}_{P,B}$ 和光线向量 $ \vec{V}_{A2\mathrm{co},B}$，由此确定直线，令 $z$ 坐标为零即得投影点 $Q$：

$$
\vec{x}_{Q,B}  = 
\begin{bmatrix}
    x_{P,B} - \frac{V_{x,B}}{V_{z,B}}z_{P,B} \\
    y_{P,B} - \frac{V_{y,B}}{V_{z,B}}z_{P,B} \\
    0
\end{bmatrix}
$$

然后判断 $\vec{x}_{Q,B}$ 的横纵坐标范围即可，若在 $B$ 镜之内，则此点反射光被挡，应舍去。

**计算吸收塔阴影对 $A$ 镜的覆盖**

为简化计算，将吸收塔和集热器视为半径与集热器半径 $r_{\mathrm{co}}$ 相同，高度为 $ H_{\mathrm{co}} + \frac{h_{\mathrm{co}}}{2}$ 的圆柱体。

为确定是否有镜面受到吸收塔影响，先计算吸收塔在地面上的最大投影距离。在入射阳光视角，吸收塔顶部椭圆的上半部分中点的投影即为最远投影距离。并且，当塔的高度角达到最低时（09:00 或 15:00），具有最大投影距离（直接遍历 ST_array 也无妨）。

记太阳入射向量在 $xy$ 平面的投影为 $\vec{V}_{sun,Oxy} = \vec{V}_{\mathrm{sun},O}|_{z=0}$，圆柱体顶面中心坐标为 $\overrightarrow{top} = (0,0,H_{\mathrm{co}} + \frac{h_{\mathrm{co}}}{2})$，则最远点为：

$$
\vec{x}_0 = (x_0,y_0,z_0) = \overrightarrow{top} + \frac{\vec{V}_{sun,Oxy}}{\left| \vec{V}_{sun,Oxy}\right| }\cdot r_{\mathrm{co}}
$$

得到地面投影点：

$$
\vec{x} = 
\begin{bmatrix}
    x_0 - \frac{V_{\mathrm{sun},x}}{V_{\mathrm{sun},z}}z_0 \\
    y_0 - \frac{V_{\mathrm{sun},y}}{V_{\mathrm{sun},z}}z_0 \\
    0 
\end{bmatrix}
$$

于是可以计算塔的最大干涉距离：

``` matlab 
tic
MaxDistance_co = 0;
figure

scatter(0,0)
hold on

for D = D_Array
    for ST = ST_Array 
    %for ST = [9 15]
        [~, ~, ~, ~, V_sun_O] = GetSun(D, varphi, ST);
        V_sun_Oxy = [V_sun_O(1) V_sun_O(2) 0];
        X_0 = (  Top + V_sun_Oxy/norm(V_sun_Oxy)*r_co  )';
        X = [
            X_0(1) - V_sun_O(1)/V_sun_O(3)*X_0(3)
            X_0(2) - V_sun_O(2)/V_sun_O(3)*X_0(3)
            0
            ];
        MaxDistance_co = max(norm(X), MaxDistance_co);
        scatter(X(1),X(2))
    end
end

hold off

save("Data_Q1.mat","MaxDistance_co",'-mat');
MaxDistance_co
toc
```

``` matlab 
MaxDistance_co = 330.5511
历时 0.022772 秒。
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-09-10-20-08_MM(1.2)-CUMCM2023A.png"/></div>

我们顺便看一眼塔阴影分布：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-09-10-17-53_MM(1.2)-CUMCM2023A.png"/></div>

``` matlab
% 塔阴影分布可视化
clc,clear,close all
load("Data_Q1.mat")
D = D_Array(1);
ST = ST_Array(1); 
N_array = [4 40];


% Area = [
%         -r_co,  r_co, -r_co
%         -Top(3)/2, -Top(3)/2, Top(3)/2 
%         0,0,0
%         ];
figure
tiledlayout(2,3)
for D = [D_Array(1) D_Array(7)]
    for ST = [ST_Array(1) ST_Array(4) ST_Array(7)]
        [delta, omega, alpha, gamma, V_sun_O] = GetSun(D, varphi, ST)
        axes = nexttile;
        %axes.PlotBoxAspectRatio = [1.1 1 0.65];
        Area = [
            -r_co,  r_co, -r_co
            -Top(3)/2, -Top(3)/2, Top(3)/2 
            0,0,0
            ];
        X_A_O = [0 0 0]';
        T_A = eye(3,3)
        S_B = [V_sun_O(1); V_sun_O(2); 0];
        S_B = S_B/norm(S_B);
        X_B_O = Top'/2;
        T_B = GetTransformMatrix(S_B);  % 计算 B 的转换矩阵
        V_sun_A = T_A' * V_sun_O ;
        Area = [
                -r_co,  r_co, -r_co
                -Top(3)/2, -Top(3)/2, Top(3)/2 
                0,0,0
                ];
        Discrete_tower = Discrete(Area, 2, N_array); % 离散塔 B
        %figure
        scatter3(0,0,0,'MarkerFaceColor','b')
        hold on
        
            % 计算阴影覆盖后的逻辑矩阵
                for i = 1:size(Discrete_tower(:,:,1),1)
                    for j = 1:size(Discrete_tower(:,:,1),2)
                        X_P_B(:,1) = Discrete_tower(i,j,:);
                        X_P_A = T_A' * ( T_B*X_P_B + X_B_O - X_A_O );
                        X_Q_A = [
                            X_P_A(1) - V_sun_A(1)/V_sun_A(3)*X_P_A(3)
                            X_P_A(2) - V_sun_A(2)/V_sun_A(3)*X_P_A(3)
                            0
                        ];
                        
                        if 1
                            scatter3(X_P_A(1),X_P_A(2),X_P_A(3),'b.');
                            scatter3(X_Q_A(1),X_Q_A(2),X_Q_A(3),'black.');
                        end
                    end
                end
        scatter3(Top(1),Top(2),Top(3),'MarkerFaceColor','r')  
        hold off
        xlim([-50 50])
        ylim([-50 50])
        title(['D = ',num2str(D),', ST = ',num2str(ST)])
    end
end
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-08-14-54-33_MM(1.2)-CUMCM2023A.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-08-14-50-03_MM(1.2)-CUMCM2023A.png"/></div> -->

获取最大投影距离后，可以计算塔阴影对镜面的干扰。与上面的类似，我们有两层镜面筛选：距离筛选和方向筛选。在代码中，为简化计算，我们将塔视为矩形，且法向量就是 $\vec{V}_{sun,Oxy}$，这样便可将塔视为一个特殊的镜面，使用 “$A$ 的阴影覆盖 $B$” 中的理论。当然，在代码中我们对称过来了，构建了函数 `BKillA()`，此时塔对应 $B$，镜对应 $A$。


需要注意，在写代码时，对于任意给定目标镜面 $A$，应按顺序 “塔阴影损失 --> 阴影覆盖损失 --> 反射遮挡损失” 来计算镜面 $A$ 的阴影效率。




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
H_{B} = T\cdot H_{A} \\
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

