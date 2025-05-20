# Improved Push-Pull Stage

> [!Note|style:callout|label:Infor]
Initially published at 12:52 on 2025-03-27 in Beijing.


## Improved Push-Pull Stage

### Basic Idea

从 Basic Push-Pull Stage 到 improved push-pull stage 的改进思路如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-27-13-22-50_Improved Push-Pull Stage.png"/></div>

上图 Figure 14.15 (b) 中的 improved push-pull stage 在实际中应用非常广泛。大多数的运算放大器，为了提高带载能力，都会使用这种 improved push-pull 作为输出级，只是在输出保护、输出平衡上会稍作修改。因此，它值得我们去仔细研究。

### Razavi's Calculation

*Razavi Fundamentals* 一书中，对忽略 $r_{O4},\ r_{D_1},\ r_{D_2}$ 的情形进行了计算（得到等效增益 $A_{eq}$ 和输出电阻 $R_{out}$），且计算时并没有使用 Thevenin 等效，而是考虑后级 EF 对前级 CE 的增益影响（利用节点电阻 $R_N$）。如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-27-13-25-04_Improved Push-Pull Stage.png"/></div>

为保证计算的准确性，在下文，我们将 $r_{O4}$ 包含进来，并且先按戴维南定理计算 improved push-pull stage 的增益 $A_v$ 和输出电阻 $R_{out}$ (Approach 1)。在这之后，我们再仿照 Razavi 的方法，利用 $R_N$ 体现后级 EF 对 $v_N$ 实际增益的影响，然后 $v_N$ 直接作用在 EF 上，进一步得到总增益 (Approach 2)。

必须指出，按“正规”的方法来看，我们应该使用戴维南等效进行计算，也就是 Approach 1 中的方法。 Approach 2 虽然也可以得到近似相等的结果，但其准确性存疑（我认为是不准确的）。


### Approach 1 (High R_L)

当负载电阻 $R_L$ 较高时，我们直接计算电路的 $A_v$ 和 $R_{out}$，再由 $A_{eq} = \frac{R_L}{R_L + R_{out}}$ 可以很方便地计算实际等效增益。具体过程如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-27-13-31-20_Improved Push-Pull Stage.png"/></div>


### Approach 1 (Low R_L)

当负载电阻 $R_L$ 较低时，虽然我们仍可以通过 $A_{eq} = \frac{R_L}{R_L + R_{out}}$ 计算实际等效增益，但为了使结果更 intuitive ，我们在计算时将 $R_L$ 包含进来，也就是直接计算等效增益 $A_{eq}$。

具体过程如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-27-13-33-44_Improved Push-Pull Stage.png"/></div>

### Approach 2

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-27-13-33-54_Improved Push-Pull Stage.png"/></div>


### Input Impedance (using BJT)

用 MOSFET 搭建 output stage 时，我们一般不会去考虑 gate 端的输入阻抗（一般都非常大）。但是对于 BJT 的情形，输入阻抗可能只有十几千欧，这时就不得不考虑输入阻抗对电路的影响。

求解 input impedance of  的具体过程如下：


### Power Dissipation and Efficiency

Conclusions:
$$
\begin{gather}
P_{S, av} = \frac{2V_P V_{CC}}{\pi R_L},\quad 
P_{O,av} = \frac{V_P^2}{2 R_L} ,\quad 
P_{Q,av} = P_{S, av} - P_{O,av}
\\
\eta = \frac{P_{O,av}}{P_{S,av}} = \frac{\pi V_P}{4 \,V_{CC}} < \frac{\pi}{4} \approx 78.5 \,\%
\\
P_{Q,peak}  = \frac{V_{CC}^2}{\pi^2 R_L}\quad \left(V_P = \frac{2}{\pi} V_{CC} \approx V_{CC}\times 64\,\% \right)
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-01-00-23-31_Improved Push-Pull Stage.png"/></div>