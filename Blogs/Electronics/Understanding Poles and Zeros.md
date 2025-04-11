# Understanding poles and zeros

> [!Note|style:callout|label:Infor]
Initially published at 18:05 on 2025-04-08 in Beijing.

## Intro

- 参考资料：
    - [MIT:  Understanding Poles and Zeros](https://web.mit.edu/2.14/www/Handouts/PoleZero.pdf)
    - [What Are Transfer Functions, Poles, And Zeroes?](https://blog.mbedded.ninja/electronics/circuit-design/what-are-transfer-functions-poles-and-zeroes/)

## Basic Concepts

传递函数的形式：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-08-18-12-47_Understanding poles and zeros.png"/></div>


上面表面，传递函数的系数多项式一定是实系数多项式，因此一定可以被分解为有实根的一次项和无实根的二次项（有一对共轭复根）。

极点与系统齐次解（自由响应）的关系：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-08-18-15-06_Understanding poles and zeros.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-08-18-16-10_Understanding poles and zeros.png"/></div>

线性系统是稳定系统的必要条件是，所有的极点都在左半平面 (LHP, left-half of the s-plane) 内，也就是都必须有负实部。特别地，虚轴上存在极点时，系统是临界稳定的 (marginally stable)，此时系统的自由响应不会发散，但也不会收敛到某个值，呈周期性振荡。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-08-18-18-26_Understanding poles and zeros.png"/></div>


传递函数 $H(s)$ 的几何意义（传递函数的几何求法）：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-08-18-20-05_Understanding poles and zeros.png"/></div>

## Pole-Zero Plot

基于上面的几何意义，我们发展出频率响应 $H(j\omega)$ 的几何表示，称为 **Pole-Zero Plot**:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-08-18-30-05_Understanding poles and zeros.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-08-18-30-37_Understanding poles and zeros.png"/></div>
<span style='color:red'> 上面“频率响应 $H(j\omega)$ 的几何表示”是非常重要的知识点 </span>，对我们认识、理解和求解频率响应，将零极点与频率响应联系起来，都是非常有帮助的。

对于一个 LTI 系统（线性时不变系统），其零极点位置对传递函数的影响如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-08-18-31-51_Understanding poles and zeros.png"/></div>

## Bode Plot

用波特图近似画出频率响应的图像：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-08-18-32-36_Understanding poles and zeros.png"/></div>

## Relevant Resources



- [OKAWA Electric Design: Transfer Function Analysis and Design Tool](http://sim.okawa-denshi.jp/en/dtool.php)