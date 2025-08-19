# PLL System-Level Simulation using LTspice

> [!Note|style:callout|label:Infor]
Initially published at 14:13 on 2025-08-15 in Lincang.


## Introduction


本文的主要目的是对文章 [Design Sheet for Third-Order Type-II CP-PLL](<AnalogICDesigns/Design Sheet for Third-Order Type-II CP-PLL.md>) 中的理论结果做一个的仿真验证，让我们 "有信心" 正式去设计一个 PLL 系统，后续详见 [Design of A Third-Order Type-II Integer-N CP-PLL](<Projects/Design of A Third-Order Type-II Integer-N CP-PLL.md>)。类似的仿真验证还有 [PLL Behavior-Level Simulation using Cadence IC618](<AnalogIC/PLL Behavior-Level Simulation using Cadence IC618.md>)。

先看最终成果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-15-23-52-48_PLL System-Level Simulation using LTspice.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-15-23-53-28_PLL System-Level Simulation using LTspice.png"/></div>

## LTspice Simulation

### 1. PFD/CP/LPF/VCO

选择 LTspice 库中自带的 `phidet` 器件，路径 `LTspice/lib/sym/Digital`。这个器件是 PFD + CP 的组合，在触发状态下输出的是固定电流 $I_P = 100\ \mathrm{uA}$.

对于 LPF, 考虑 $(R_P + \frac{1}{sC_P})\parallel \frac{1}{sC_2}$ 构成的二阶低通滤波器。

然后是 VCO + Divider, 这部分模块 LTspice 中并没有自带的理想器件，于是去官网搜了一下有仿真模型的压控振荡器, 发现只有类似 LTC6900 这样 resistor-set 型的振荡器 (等价于 current-set), 也就是振荡频率与 SET 端输入电流 $I_{set}$ 成正比。为了将其设置为 voltage-controlled oscillator, 我们需要用到库中的 `bi` 器件 (注意不是 `current`)。除此之外，还需要通过仿真来确定输入电流 $I_{set}$ 与振荡频率 $f_{osc}$ 的比例系数 $a$，仿真所得数据如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-00-02-11_PLL System-Level Simulation using LTspice.png"/></div>

由此得到：

$$
\begin{gather}
f_{osc} = a I_{set},\quad a = 0.1768 \mathrm{MHz}/\mathrm{uA}= 0.1768 \times 10^{12} \mathrm{Hz}/\mathrm{A}
\end{gather}
$$

然后就可以将它们全部连接起来，图中 B2 的作用是给 $V_{cont2}$ 一个初始值，相当于设置 $V_{cont} = 0$ 时 VCO 的振荡频率。

另外，由于 LTC6900 内部结构原因，输入 $I_{set}$ 发生改变时，输出频率并不能立即改变，这在 $I_{set}$ 变化很快时尤为明显。因此我们将 LTC6900 的 DIV 端拉到 VDD, 也即设置 N-Divider 的 $N = 100$, 此时 $K_{VCO,eq} = K_{VCO}/N =  K_{VCO}/100$.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-00-09-01_PLL System-Level Simulation using LTspice.png"/></div>

by the way, 将 LTC6900 设置为 VCO 的方法很多，例如这篇文章 [How to Use the LTC6900 Low Power SOT-23 Oscillator as a VCO](https://www.analog.com/en/resources/technical-articles/ltc6900-low-power-sot-23-oscillator-as-a-vco.html)，我们不多赘述。

### 2. Theoretical Values

现在只剩 LPF 中的阻容参数还没有确定，由 design sheet 给出的公式：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-00-12-11_PLL System-Level Simulation using LTspice.png"/></div>

计算得到：

$$
\begin{gather}
\omega_{in} = 2\pi f_{in},\quad f_{osc} = a I_P = a G_m V_{cont} \Longrightarrow  K_{VCO} = 2\pi a G_m
\\
\begin{cases}
f_{in} = 100 \ \mathrm{kHz}
\\
I_P = 100 \ \mathrm{uA}
\\
G_m = 40 \ \mathrm{uS}
\\
a = 0.1768 \times 10^{12} \ \mathrm{Hz/A}
\end{cases}
\Longrightarrow 
\begin{cases}
R_P = 16.9656 \ \mathrm{k}\Omega
\\
C_P = 982.379 \mathrm{pF}
\end{cases}
\end{gather}
$$



### 3. Simulation Results

设定好 SPICE 语句，运行仿真，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-15-23-52-48_PLL System-Level Simulation using LTspice.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-15-23-53-28_PLL System-Level Simulation using LTspice.png"/></div>


当然，我们也可以适当调整 $R_P$ 和 $C_P$ 的值，看看系统性能是否与理论预测一致。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-00-24-33_PLL System-Level Simulation using LTspice.png"/></div>

仅降低 $K_{VCO}$ (即降低 $G_m$):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-00-30-01_PLL System-Level Simulation using LTspice.png"/></div>

仅增大 $R_P$:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-00-30-33_PLL System-Level Simulation using LTspice.png"/></div>

仅增大 $C_P$:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-00-31-32_PLL System-Level Simulation using LTspice.png"/></div>