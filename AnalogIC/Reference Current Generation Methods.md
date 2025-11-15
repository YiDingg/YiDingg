# Reference Current Generation Methods

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 22:36 on 2025-06-17 in Beijing.


## Basic Beta Multiplier

### output current

参考 *Design of Analog CMOS Integrated Circuits (Razavi) (2nd edition, 2017)* , 电路基本结构如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-23-51-34_Reference Current Generation Methods.png"/></div>

$$
\begin{gather}
I_{out} = \frac{2}{\mu_n C_{ox}\left(\frac{W}{L}\right)_N}\cdot \frac{1}{R_S^2}\left(1 - \frac{1}{\sqrt{K}}\right)^2,\quad 
I_D =  \mu_n C_{ox}\left(\frac{W}{L}\right) \cdot \frac{4}{\left(\frac{g_m}{I_D}\right)^2}
\\
\Longrightarrow I_{out} = \frac{2\sqrt{2}}{\left(\frac{g_m}{I_D}\right)_N }\cdot \frac{1 - \frac{1}{\sqrt{K}} }{R_S} \quad 
\mathrm{(square\ low)},\quad \mathrm{let\ } K = 4,\ \mathrm{we\ have:}
\\
I_{out} = \frac{\sqrt{2}}{\left(\frac{g_m}{I_D}\right)_N }\cdot \frac{1}{R_S},\quad 
R_S = \frac{\sqrt{2}}{I_{out}\left(\frac{g_m}{I_D}\right)_N } =  \frac{\sqrt{2}}{g_{mN}}
\end{gather}
$$

图中的 $I_{out}$ 即为我们所需的 biasing current. 要作 nmos current mirror, 令 Figure 12.3 (b) 的 M2 为"相同"尺寸后从 gate of M2 取出 biasing voltage 即可；类似，要作 pmos current mirror 时，令 Figure 12.3 (1) 的 M3 为"相同"尺寸后从 gate of M3 取出 biasing voltage 即可。



此结构关于 VDD 的 sensitivity 为：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-23-56-19_Reference Current Generation Methods.png"/></div>

也即：
$$
\begin{gather}
\frac{\mathrm{d} I_{out} }{\mathrm{d} V_{DD} } = \frac{1}{r_{O4}} \cdot \frac{1}{\frac{1}{G_{m2}(r_{O4}\parallel \frac{1}{g_{m1}})} - \frac{g_{m4}}{g_{m3}}} \approx \frac{1}{r_{O4}} \cdot \frac{1}{\frac{g_{m1}}{G_{m2}} - \frac{g_{m4}}{g_{m3}}}
, \quad 
G_{m2} = \frac{g_{m2}}{1 + \frac{R_S}{R_{S0,2}}} \approx \frac{g_{m2}}{1 + g_{m2}R_S}
\\
S^{I_{out}}_{V_{DD}} = \frac{\mathrm{d} I_{out}}{\mathrm{d} V_{DD}} \cdot \frac{V_{DD}}{I_{out}} \approx \frac{1}{r_{O4}}\cdot \left[ g_{m1}\left(\frac{1}{g_{m2}}+  R_S\right) - \frac{g_{m4}}{g_{m3}} \right]^{-1} \cdot \frac{\beta_N R_S^2}{2 \left(1 - \frac{1}{\sqrt{K}}\right)^2}
\end{gather}
$$

注意上式是由平方律推导得到，因此不可避免的会有 PVT 之外的模型误差。或者将上面的式子写成：

$$
\begin{gather}
I_{out} = \frac{2}{\mu_n C_{ox}R_S^2}\cdot \left( \frac{1}{\sqrt{(W/L)_1}} - \frac{1}{\sqrt{(W/L)_2}} \right)^2,\quad \frac{\mathrm{d} I_{out} }{\mathrm{d} V_{DD} }\approx \frac{1}{r_{O4}} \cdot \frac{1}{\frac{g_{m1}}{G_{m2}} - \frac{g_{m4}}{g_{m3}}}
\\
S^{I_{out}}_{V_{DD}} = \frac{\mathrm{d} I_{out}}{\mathrm{d} V_{DD}} \cdot \frac{V_{DD}}{I_{out}} \approx \frac{1}{r_{O4}}\cdot \left[ g_{m1}\left(\frac{1}{g_{m2}}+  R_S\right) - \frac{g_{m4}}{g_{m3}} \right]^{-1} \cdot \frac{2}{\mu_n C_{ox}R_S^2}\cdot \left( \frac{1}{\sqrt{(W/L)_1}} - \frac{1}{\sqrt{(W/L)_2}} \right)^2
\end{gather}
$$





<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-17-23-48-44_Reference Current Generation Methods.png"/></div>
 -->

### start-up circuit

为避免在 VDD 开启时 current reference 处于 zero current 状态 (这也是一个稳态)，我们需要添加一个 start-up circuit。常见的启动电路很多，这里列举三种：

第一种是 *Razavi CMOS* 中给出的 poor man's start-up:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-00-11-17_Reference Current Generation Methods.png"/></div>
上面这种 start-up 需要 $VDD > V_{TH1} + |V_{TH3}| + V_{TH5}$ 以及 $V_{DD} < V_{GS1} +  |V_{GS3}| + V_{TH5}$ 才能正常工作，虽说可以通过减小 $\left(\frac{g_m}{I_D}\right)_5$ 来增大 $|V_{GS5}|$, 但可行范围仍比较受限。



第二种是 [知乎 > 自偏置电流基准 (Beta Multiplier)](https://zhuanlan.zhihu.com/p/555389065) 中的例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-00-11-57_Reference Current Generation Methods.png"/></div>

第三种是论文 [Paper: A PVT-robust Beta-Multiplier Current Reference with Body-Effect-based Temperature Dependency Modulation](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10559712) 中给出的建议：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-18-00-12-46_Reference Current Generation Methods.png"/></div>

### design constraints

需要注意的是, basic beta multiplier 内部存在正反馈环路，因此要想保证其稳定工作，需要满足环路增益 < 1. 以图 (a) 为例，也即：

$$
\begin{gather}
T_0 =  - \frac{g_{m4}}{g_{m1}}\cdot \frac{g_{m2}}{g_{m3}} \cdot \frac{- 1}{1 + g_{m2}R_S} < 1 \Longrightarrow 
R_S > \frac{1}{g_{m2}}\cdot \left( \frac{g_{m2}g_{m4}}{g_{m1}g_{m3}} - 1 \right)
\end{gather}
$$

### design steps

一个小技巧是, 图中的 I_REF 和 I_out 都可以作为产生 biasing 的参考电流，在某些情况下，通过良好的设计，可以使得 pmos current mirror 和 nmos current mirror 共用一个 current reference.

假设现在需要的是 nmos current mirror, 考虑 gate of M2 取出 biasing voltage, 设计步骤如下：
- 令 M1 = M2 = Mb (Mb 是 current mirror)
- 根据经验，选择 K = 3 ~ 5 (例如选择 4 作为 initial guess)
- 选择合适的 (W/L)_P, 例如选择 (W/L)_P = 4 (W/L)_N 作为 initial guess
- 调整 R_S 使 I_out 达到预期值
- 选择合适的 M5 作为 start-up 电路

### design example

下面是 Figure 12.5 (a) 中一组比较常用的设计考量：

$$
\begin{gather}
\left(\frac{W}{L}\right)_P = 4 \left(\frac{W}{L}\right)_N,\quad \left(\frac{W}{L}\right)_{5} < \frac{1}{10}
,\quad 
K = 4,\quad R_S = \frac{\sqrt{2}}{I_{out}\left(\frac{g_m}{I_D}\right)_N } =  \frac{\sqrt{2}}{g_{mN}}
\end{gather}
$$


## Cascode Beta Multiplier



## Reference

读者可自行以 "reference current" 为关键词在 IEEE Xplore 上搜索其它相关论文，下面列举几篇：
- [Paper 1: A PVT-robust Beta-Multiplier Current Reference with Body-Effect-based Temperature Dependency Modulation](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10559712)
- [Paper 2: A Sub-200nW All-in-One Bandgap Voltage and Current Reference Without Amplifiers](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9134412)
- [Paper 3: A Current Reference With Multiple Nonlinear Current Mirrors to Reduce Noise, Mismatch, and Impact of Supply Voltage Variation](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10077754)
- [Paper 4: A Simple Current Reference with Low Sensitivity to Supply Voltage and Temperature](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8005156): 介绍了一种能够产生数百 uA 的、结构简单的 current reference, 适用于电流较大的场景
- [Paper 5: A Stable CMOS Current Reference Based on the ZTC Operating Point](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7974160&tag=1): 介绍、设计并验证了一个 uA 级别的 current reference, 具有较好的温度稳定性
