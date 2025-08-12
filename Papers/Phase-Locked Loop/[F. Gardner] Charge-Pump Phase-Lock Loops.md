# [F. Gardner] Charge-Pump Phase-Lock Loops

> [!Note|style:callout|label:Infor]
> Initially published at 22:22 on 2025-08-12 in Lincang.

原文链接: 
- [Charge-Pump Phase-Lock Loops (主链接)](https://u.dianyuan.com/bbs/u/29/1116306785.pdf) 
- [Charge-Pump Phase-Lock Loops (备用链接)](https://ieeexplore.ieee.org/abstract/document/1094619)

论文全引是：
>F. Gardner, "Charge-Pump Phase-Lock Loops," in IEEE Transactions on Communications, vol. 28, no. 11, pp. 1849-1858, November 1980, doi: 10.1109/TCOM.1980.1094619. 

## Abstract

鉴频鉴相器 (PFD, phase frequency detector) 以三态数字逻辑的形式输出频率/相位比较信号，而电荷泵 (CP, charge pump) 则用于将 PFD 输出的逻辑电平转换为模拟量，通过低通滤波器输出给压控振荡器。本文分析了 CP-PLL (Charge Pump PLL) 中典型的电荷泵电路，指出其显著特点，并为设计工程师提供了理论方程和图表参考。


## 1. Introduction

近年来 (1980 以前)，采用 PFD 的锁相环 (PLL) 得到了广泛应用 [1]-[6]。其受欢迎的原因包括跟踪范围广、频率辅助捕获以及实现成本低等。如图 1 所示，电荷泵 CP 通常与 PFD 配合使用, CP 的作用是将 PFD 的逻辑状态转换为适合控制压控振荡器 (VCO) 的模拟信号。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-22-32-08_[F. Gardner] Charge-Pump Phase-Lock Loops.png"/></div>

本文旨在为 CP-PLL (Charge Pump PLL) 的设计分析奠定坚实基础，以便识别其特殊特征，并在必要时加以利用或避免。

在第二节中，我们介绍基本的电荷泵 CP 模型，并基于小误差（线性化环路）和带宽与输入频率相比较窄（连续时间近似）的假设，推导环路传递函数。第三节专门讨论二阶 PLL, 其中表明即使使用无源环路滤波器，也能实现 type-II PLL (II 型锁相环). 这种与传统 PLL 中的效果相反，是电荷泵带来的一个特别优势。

当环路带宽 $BW_{\omega}$ 足够接近输入频率 $\omega_{in}$ 时，连续时间近似就不再有效。在这种情况下，必须认识到环路的离散时间或采样特性。特别是，采样会带来连续时间网络中不存在的稳定性问题，本文利用 z 变换给出了二阶环路的稳定性极限。

在二阶 LPF (low-pass filter) 的基础上，通常在 CP 之后添加滤波器以减少纹波。第四节描述了添加单个电容器 (最简单的纹波滤波器) 后的环路性能。此时环路为三阶 (尽管仍然是 II 型)，因此分析更为复杂。文中给出了连续时间近似下的根轨迹图 (s 变换)。对于更高的带宽，连续时间近似不再成立，利用离散时间线性化分析得到 z 平面特征函数，推导除极点位置和稳定性极限。

第五节描述了二阶环路的非线性离散状态变量分析结果。事实证明，通过离散时间分析获得的宽带环路的瞬态建立时间，与通过普通连续时间方法得到的建立时间非常相似。三阶环路也可以进行类似分析，但尚未开展。

## 2. Models 


假设锁相环已锁定，将输入信号的频率表示为 $\omega_{i}$ (rad/s)。设相位误差为 $\theta_e = \theta_o - \theta_i$。与输入频率相比，当锁相环的带宽足够大时 (一般需要 $ \omega_{BW} > \omega_i/20$)， PFD 的输出端 U/D 在每个周期的导通时间为：

$$
\begin{gather}
t = \frac{|\theta_e|}{\omega_i}
\end{gather}
$$

(The subscript "p" connotes "pump".) 

上式在 "传输理想性假设 (即假设逻辑门传输无延迟)" 和 "带宽理想性假设" 下是精确的，但是当环路带宽 $\omega_{BW}$ 低于 $< \frac{\omega_i}{20}$ 时，逐渐出现明显误差。


LPF 的形式多种多样，可以是无源/有源，也可以是低阶/高阶。我们考虑普适性最高的阻抗式无源滤波器，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-12-23-06-53_[F. Gardner] Charge-Pump Phase-Lock Loops.png"/></div>



在每个周期的导通时间段 $t_p$ 内，电流 $I_p$ 被输送至 LPF, 每个周期的持续时间为 $T = \frac{2\pi}{\omega_i}$ 秒，因此，利用 $t = \frac{|\theta_e|}{\omega_i}$，可以得到一个周期内 LPF 接收到的平均电流为：

ga

将 CP 建模为 $H(s) = \frac{I_{out}(s)}{\theta_e(s)} = \frac{I_p}{2\pi}$ 的线性模块，
