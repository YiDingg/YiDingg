# Cross-Coupled Pair (XCP)

## References

- [1] [B. Razavi, "The Cross-Coupled Pair - Part I [A Circuit for All Seasons]," in IEEE Solid-State Circuits Magazine, vol. 6, no. 3, pp. 7-10, Summer 2014, doi: 10.1109/MSSC.2014.2329234.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6882880) (备用链接 [here](https://ieeexplore.ieee.org/document/6882880))
- [2] [知乎 > 模集王小桃 > 王小桃带你读文献：交叉耦合对——基本结构与分析 The Cross-Coupled Pair—Part I](https://zhuanlan.zhihu.com/p/1892499693667348596)


## 1. Small-Signal Properties

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-30-22-24-58_An Introduction to XCP (Cross-Coupled Pair).png"/></div>

$$
\begin{gather}
\begin{cases}
i_t - \frac{v_A}{r_{O1}} - g_{m1}v_B = 0
\\ - i_t - \frac{v_B}{r_{O2}} - g_{m2}v_A = 0
\end{cases}
\end{gather}
$$

在直流工作点偏移不大的情况下，作近似 $g_{m1} = g_{m2}$ 和 $r_{O1} = r_{O2}$, 则：

$$
\begin{gather}
2 i_t = v_A \left( \frac{1}{r_{O1}} - g_{m2} \right) - v_B \left( \frac{1}{r_{O2}} - g_{m1} \right)
= (v_A - v_B) \left( \frac{1}{r_{O}} - g_{m} \right) = v_t \left( \frac{1}{r_{O}} - g_{m} \right)
\\
\Longrightarrow 
\boxed{
Z_{eq} = \frac{v_t}{i_t} = \frac{2}{\frac{1}{r_{O}} - g_{m}} \approx  \frac{-2\,}{g_m}
}
\end{gather}
$$

事实上，上面的结构是“正反馈实现负电阻”的典型例子，更多内容可以参考 [知乎 > 模集王小桃 > 王小桃带你读文献：电路中的正反馈 Positive Feedback](https://zhuanlan.zhihu.com/p/1891982316227782292)。

下图是一种更通用的情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-30-22-36-47_An Introduction to XCP (Cross-Coupled Pair).png"/></div>

$$
\begin{gather}
\mathrm{Figure\ (a):}\ \ Z_{in1} = - Z_1 - \frac{2}{g_{m}}
\\
\mathrm{Figure\ (b):}\ \ Z_{in2} = - Z_2 - \frac{2}{g_{m}}
\end{gather}
$$


关于 XCP, 我们还有以下几点值得注意：


- (1) 如果把 MOS gate 端的电阻电容 $R_{G}$ 和 $C_{G}$ 也考虑进来，阻抗会变为 [1]：

$$
\begin{gather}
Z_{in,\mathrm{degraded}} = \frac{-2\,}{g_m} \parallel \frac{2}{\omega^2 R_{G}C_{G}} = \frac{1}{\frac{\omega^2 R_{G}C_{G}}{2} - \frac{g_m}{2} }
\end{gather}
$$

这会显著影响 XCP 在高频时的阻抗特性。

- (2) 如果 $Z_1$ 是一个电容那么 $Z_{in1}$ 中就存在有一个负电容 (也即电感)，并且可以与 XCP 漏端的正寄生电容相抵消。
- (3) 可以证明，当 $Z_1 = 0$ 时, XCP 的输入参考噪声 (input-referred noise, IRN) 为 $\overline{i^2_{n,in}} = \frac{2kT\gamma_n}{g_m}$


## 2. Large-Signal Properties

XCP 在大信号条件下表现为双稳态电路，能够稳定存储两种逻辑状态 (0 和 1)，且不消耗静态功耗。这一特性使其广泛应用于存储以及数字电路中。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-30-22-58-02_An Introduction to XCP (Cross-Coupled Pair).png"/></div>

下面我们简单介绍一下这种结构的工作 (分析过程中的 0 和 1 均指逻辑电平)。假设初始时，Vin1=0，Vin2=1，那么初始状态的确定过程为：
- (1) Vin1=0, Vin2=1, 那么 M2 导通，而 M1 截止, M2 抽取 Y 点电荷，使 Vy 降低。
- (2) 随着 Vy 降低, M3 逐渐导通，并向 X 点注入电荷, Vx 将逐渐增加 (因为 M1 截止)
- (3) 随着 Vx 增加, M4 逐渐关断，不再向 Y 点注入电荷，仅余 M2 抽取 Y 点电荷
- (4) 最终，我们得到稳定的 Vx=1, Vy=0

这个动态过程被称为再生过程 (regeneration). 此外, XCP 还可以用于动态 RS 锁存器。

## 3. Hysteresis vs. Amplification

XCP 的另一个重要特性是它的迟滞 (hysteresis) 和放大 (amplification) 特性。迟滞是指在输入信号变化时，输出信号的变化滞后于输入信号的变化。

例如，当 Vy=0, Vx=1 时，输入信号改变，我们希望得到 Vy=1，Vx=0 的结果。注意到，对于 X 而言，导通的 M3 会向 X 点注入电荷，所以为了能让 Vx 降低至 0, 我们需要让 M1 抽取电荷的速度比 M3 注入的更快，这意味着 Vin1 必须要足够大，才能让电路开始正常工作（即进入再生过程）。直到 M1 关断, M3 进入深线性区，再生过程才结束。

这意味着较小的 Vin 无法导致状态发生改变。为解决这一问题，人们提出了时钟 (CK) 控制的 XCP 结构，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-30-23-02-21_An Introduction to XCP (Cross-Coupled Pair).png"/></div>

在 CK=0 的情况下，只要 X 点与 Y 点之间存在一个较小的压差，我们再令 CK=1, 再生过程便会开始。以上图为例，此时 Vx>Vy， 且存在一个较小的压差 Vx > Vy. 当 CK=1 后，我们分别看 X, Y 两点的电荷以及电压变化情况：
- (1) 对于 Y 点，由于 Vx>Vy, M2 流过的电流大于 M1 流过的电流，即 M2 抽取 Y 节点电荷的速度较快, Vy 降低 (前提是 M2 抽取电荷的速率比 RD 的注入速率快)
- (2) 对于 X 点，由于 Vy 降低，这使得 M1 趋于截止，而 RD 一直向 X 点注入电荷，使得 Vx 增加

参考文献 [1] 中给出了差分输出信号的时域表达式：

$$
\begin{gather}
V_{XY}(t) = V_{XY0} e^{\frac{t}{\tau_{reg}}},\quad \tau_{reg} = \frac{R_LC_L}{g_{m}R_L - 1} = \frac{C_L}{\frac{1}{g_m}\parallel \frac{-1}{R_L}}
\end{gather}
$$

其中 $\tau_{reg}$ 称为小信号再生时间常数 (small-signal regeneration time constant)，$V_{XY0}$ 是初始差分输出电压。这种“将差模小信号输入放大为逻辑电平输出”的特性可以被用于搭建比较器 [2]，但 XCP 结构同时还会带来亚稳态的问题，我们不多赘述。

