# Mathematical Modeling (1.3): CUMCM 2023-B

## 概览

- 主题：多波束测线布设与优化
- 重点：迭代，二维三维曲线拟合，最优化
- 时间：2024年8月（集训）
- 赛题：
  - [CUMCM 2023-B 赛题.pdf](https://www.writebug.com/static/uploads/2024/8/9/4693a624a6cea21bcf2a071afa57d43a.pdf)
  - [CUMCM 2023-B 赛题附件.xlsx](https://www.writebug.com/static/uploads/2024/8/9/4b2680c148c0fa58fc4dde784cc46555.xlsx)
- 优秀论文：
  - [ ] [CUMCM 2023-B 优秀论文 B226.pdf](https://www.writebug.com/static/uploads/2024/8/9/220dd99474853db8c327a481ed31bf4a.pdf)
  - [ ] [CUMCM 2023-B 优秀论文 B311.pdf](https://www.writebug.com/static/uploads/2024/8/9/fb15a9a26d41b7eaa0811c5743b96623.pdf)
  - [ ] [CUMCM 2023-B 优秀论文 B477.pdf](https://www.writebug.com/static/uploads/2024/8/9/d3f32b081197d7a84470b5d36504a560.pdf)

## 问题一 


## 问题二


问题二的建模我们提出了两种思路，第一种为椭圆，第二种为两仰角，两种方法都能得到相同的正确结果。

### 思路一：椭圆

如图，随着 $\beta$ 的变化，覆盖宽度的两端点不断旋转，本质上是圆锥被斜平面所截，最终构成一个椭圆。$x$ 轴（横轴）上为短轴，短轴长见后文 公式，$y$ 轴上为长轴，长轴即为问题一的结果。更清晰的矢量图见 [多波束测线示意图.pdf](https://www.writebug.com/static/uploads/2024/8/12/27841290640d405aa1059cbf4ba783ed.pdf)。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-11-13-13-46_MM(1.3)-CUMCM2023B.jpg"/></div>

$\beta = 90^\circ$ 时，覆盖长度（未投影到水平面）为椭圆长轴：$W = 2a = \frac{H\cos\alpha\sin\theta}{\cos(\alpha+\frac\theta2)\cos(\alpha-\frac\theta2)}$，$\beta = 180^\circ$ 时，覆盖长度（未投影到水平面）为椭圆短轴：$W = 2b = H\tan(\frac{\theta}{2})$，一般情况下，我们有：$W = 2\sqrt{b^2\cos^2\beta + a^2\sin^2\beta}$。再将其投影到水平面，得到覆盖宽度：

$$
W = 2\sqrt{b^2\cos^2\beta+a^2\sin^2\beta}\cdot\sqrt{\frac{x^2+y^2}{x^2+y^2+z^2}} \\ 
其中 
\begin{bmatrix}
  x \\ y \\ z
\end{bmatrix} = \vec{v}' \times \vec{S} = 
\begin{bmatrix}
  0 \\ -\sin\alpha \\ \cos\alpha
\end{bmatrix} \times 
\begin{bmatrix}
  \sin\beta \\ -\cos\beta \\ -\cos\beta\tan\alpha
\end{bmatrix}
$$

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-11-13-05-51_MM(1.3)-CUMCM2023B.jpg"/></div> -->

### 思路二：两个仰角

如下图，用两个仰角来计算多波束的覆盖宽度，具体可以参考论文 [多波束测深系统下的测线优化模型.pdf](https://www.writebug.com/static/uploads/2024/8/11/3680c12dd70e2a25cde080d6ca7c30fb.pdf)，我们不过多赘述。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-11-18-35-51_MM(1.3)-CUMCM2023B.jpg"/></div>

## 问题三

问题三需要注意，测线不是航线，无需考虑转弯等其他因素。再由第二问的结论，容易判断出 $\beta = 90^\circ$ 时有最大覆盖宽度，因此问题三的结果便是一系列相互平行的、$\beta = 90^\circ$ 的直测线。

## 问题四

问题四的提问太过定性，为建模带来了一些款困难，为方便分析，我们硬性规定覆盖重复率为 $10 \%$，且覆盖全部给定区域，仅优化测线长度。

此问题的关键在于迭代，有多种思路，我们提出两种。第一种：以给定区域的某条边界（海底线）为起点（例如西侧边界），向东依次求解平面线（海平面线）、海底线……，直至测线覆盖全部区域。第二种：以给定海底区域中某一点为起点，呈不规则圆形向外扩散，直至覆盖全部区域。

附录数据可视化：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-11-23-34-29_MM(1.3)-CUMCM2023B.jpg"/></div>

### 思路一：边界起点

迭代原理如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-11-23-45-19_MM(1.3)-CUMCM2023B.png"/></div>

迭代测试：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-11-23-31-40_MM(1.3)-CUMCM2023B.jpg"/></div>

正式迭代：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-11-23-30-32_MM(1.3)-CUMCM2023B.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-11-23-29-50_MM(1.3)-CUMCM2023B.jpg"/></div>

待解决问题：迭代中后期直线与平面交点超出给定区域使数据缺失，进而时迭代侧线紊乱。可考虑用“双调和”对原始数据拟合从而得到合理的区域扩展。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-11-23-38-16_MM(1.3)-CUMCM2023B.jpg"/></div>

### 思路二：一点起点

以中心点为迭代起点：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-11-23-40-42_MM(1.3)-CUMCM2023B.jpg"/></div>

以西南方边界点（左下角）为迭代起点：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-20-18-09-33_MM(1.3)-CUMCM2023B.jpg"/></div>