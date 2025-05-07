# The Extra Element Theorem (EET)

> [!Note|style:callout|label:Infor]
Initially published at 23:46 on 2025-04-02 in Beijing.


## Infor 

- Paper: [*Null Double Injection and the Extra Element Theorem*](https://ieeexplore.ieee.org/document/34149)
- DOI: [10.1109/13.34149](https://doi.org/10.1109/13.34149)
- Author:  [R. D. MIDDLEBROOK](https://ieeexplore.ieee.org/author/37299930400)
- Publication Date: 06 August 2002
- Published in: [IEEE Transactions on Education](https://ieeexplore.ieee.org/xpl/RecentIssue.jsp?punumber=13) (Volume: 32, Issue: 3, August 1989)

> **Full Citation:**
R. D. Middlebrook, "Null double injection and the extra element theorem," in IEEE Transactions on Education, vol. 32, no. 3, pp. 167-180, Aug. 1989, doi: 10.1109/13.34149.

## 1 - Abstract 
<!-- details begin -->
<details>
<summary>Abstract</summary>

The extra element theorem (EET) states that any transfer function of a linear system can be expressed in terms of its value when a given 'extra' element is absent, and a correction factor involving the extra element and two driving-point impedances are seen by the element. 

In the present work, the EET is derived and applied to several examples in a manner that has been developed and refined in the classroom over a number of years. 
The concept of null double injection is introduced first, because it is the key to making easy the calculation of the two driving-point impedances needed for the EET correction factor.

The EET for series and parallel elements is then considered, and attention is also given to the EET as an analysis tool, to the symmetry of the two forms of the EET, and to return ratios and sensitivity.
</details>




<div>

<details>
<summary>AI 全文总结 (Kimi, 2025.04.02)</summary>

这篇文章由R. D. Middlebrook撰写，发表于1989年8月的《IEEE Transactions on Education》第32卷第3期，题为“Null Double Injection and the Extra Element Theorem”。文章主要介绍了额外元素定理（Extra Element Theorem, EET）及其在电路分析中的应用，通过引入“空双重注入”（null double injection）的概念，简化了线性系统中额外元件对传递函数的影响分析。

### 背景知识
在电路设计过程中，通常需要对电路模型进行各种传递函数（如增益）的分析。当需要在已有的电路模型中添加一个额外元件时，传统的做法是重新对整个电路进行分析，这无疑增加了分析的复杂性。额外元素定理（EET）提供了一种避免从头开始分析的方法。它通过计算两个关键的驱动点阻抗（driving point impedances），将额外元件对传递函数的影响以修正因子的形式表达出来。

### 研究方法
文章首先介绍了“空双重注入”的概念。在一个线性系统中，如果有两个驱动信号，通过调整这两个信号使得其中一个输出为零，这种条件被称为“空双重注入”。在这种条件下，系统的传递函数可以通过特定的公式表达，这个公式是EET的基础。

EET的核心思想是：任何线性系统的传递函数都可以表示为在缺少某个“额外”元件时的值，以及一个包含该额外元件和两个驱动点阻抗的修正因子。这两个驱动点阻抗分别是在额外元件位置处，有无该元件时的阻抗。

### 实验与案例分析
文章通过多个例子展示了EET的应用。以下是一些关键的案例：

1. **共发射极放大器（CE Amplifier）**：文章以一个简单的共发射极放大器为例，展示了如何使用EET来考虑发射极旁路电容（C2）对增益的影响。通过计算参考电路（没有C2时的电路）的增益和两个驱动点阻抗，文章展示了如何通过EET修正因子直接得到包含C2时的增益。

2. **输入阻抗计算**：在另一个例子中，文章展示了如何使用EET来计算包含C2时的输入阻抗。通过将C2视为额外元件，文章详细说明了如何计算两个驱动点阻抗，并最终得到输入阻抗的表达式。

3. **依赖源的EET**：文章还扩展了EET的应用，考虑了额外元件是依赖源的情况。通过一个例子，展示了如何使用EET来分析依赖源对系统增益的影响。

### 关键结论
- **EET的应用**：EET不仅适用于增益的计算，还可以用于任何传递函数的分析，包括输入阻抗、输出阻抗等。
- **修正因子的物理意义**：修正因子直接揭示了额外元件对原始结果的修改。
- **简化分析**：EET允许通过分析一个更简单的电路（缺少额外元件的电路）来获得完整的传递函数结果。
- **对称性**：EET的两种形式（并联和串联）之间存在对称性，可以通过已知的三个参数计算第四个参数。
- **敏感度分析**：EET还可以用于分析传递函数对元件值变化的敏感度。

### 方法细节
- **空双重注入的计算**：通过调整两个输入信号，使得一个输出为零，从而简化了驱动点阻抗的计算。
- **修正因子的计算**：修正因子包含额外元件和两个驱动点阻抗，这些阻抗在额外元件存在和不存在的情况下分别计算。
- **EET的两种形式**：对于并联和串联的额外元件，EET有两种形式，分别对应于额外元件的阻抗为无穷大和零的情况。

### 观点与现象
文章强调了EET作为一种分析工具的价值，尤其是在处理复杂电路时，它可以显著简化分析过程。通过将复杂的电路分析分解为对更简单电路的分析，EET使得工程师能够更高效地处理电路设计中的问题。此外，文章还指出，尽管EET的概念可能对学生来说较为陌生，但通过实践和例子，他们可以逐渐掌握这一强大的工具。

</details>
</div>

``` txt
Abstract: 

The extra element theorem (EET) states that any transfer function of a linear system can be expressed in terms of its value when a given 'extra' element is absent, and a correction factor involving the extra element and two driving-point impedances are seen by the element. 

In the present work, the EET is derived and applied to several examples in a manner that has been developed and refined in the classroom over a number of years. 
The concept of null double injection is introduced first, because it is the key to making easy the calculation of the two driving-point impedances needed for the EET correction factor.

The EET for series and parallel elements is then considered, and attention is also given to the EET as an analysis tool, to the symmetry of the two forms of the EET, and to return ratios and sensitivity.
```


``` txt
AI 全文总结 (Kimi, 2025.04.02): 

这篇文章由R. D. Middlebrook撰写，发表于1989年8月的《IEEE Transactions on Education》第32卷第3期，题为“Null Double Injection and the Extra Element Theorem”。文章主要介绍了额外元素定理（Extra Element Theorem, EET）及其在电路分析中的应用，通过引入“空双重注入”（null double injection）的概念，简化了线性系统中额外元件对传递函数的影响分析。

### 背景知识
在电路设计过程中，通常需要对电路模型进行各种传递函数（如增益）的分析。当需要在已有的电路模型中添加一个额外元件时，传统的做法是重新对整个电路进行分析，这无疑增加了分析的复杂性。额外元素定理（EET）提供了一种避免从头开始分析的方法。它通过计算两个关键的驱动点阻抗（driving point impedances），将额外元件对传递函数的影响以修正因子的形式表达出来。

### 研究方法
文章首先介绍了“空双重注入”的概念。在一个线性系统中，如果有两个驱动信号，通过调整这两个信号使得其中一个输出为零，这种条件被称为“空双重注入”。在这种条件下，系统的传递函数可以通过特定的公式表达，这个公式是EET的基础。

EET的核心思想是：任何线性系统的传递函数都可以表示为在缺少某个“额外”元件时的值，以及一个包含该额外元件和两个驱动点阻抗的修正因子。这两个驱动点阻抗分别是在额外元件位置处，有无该元件时的阻抗。

### 实验与案例分析
文章通过多个例子展示了EET的应用。以下是一些关键的案例：

1. **共发射极放大器（CE Amplifier）**：文章以一个简单的共发射极放大器为例，展示了如何使用EET来考虑发射极旁路电容（C2）对增益的影响。通过计算参考电路（没有C2时的电路）的增益和两个驱动点阻抗，文章展示了如何通过EET修正因子直接得到包含C2时的增益。

2. **输入阻抗计算**：在另一个例子中，文章展示了如何使用EET来计算包含C2时的输入阻抗。通过将C2视为额外元件，文章详细说明了如何计算两个驱动点阻抗，并最终得到输入阻抗的表达式。

3. **依赖源的EET**：文章还扩展了EET的应用，考虑了额外元件是依赖源的情况。通过一个例子，展示了如何使用EET来分析依赖源对系统增益的影响。

### 关键结论
- **EET的应用**：EET不仅适用于增益的计算，还可以用于任何传递函数的分析，包括输入阻抗、输出阻抗等。
- **修正因子的物理意义**：修正因子直接揭示了额外元件对原始结果的修改。
- **简化分析**：EET允许通过分析一个更简单的电路（缺少额外元件的电路）来获得完整的传递函数结果。
- **对称性**：EET的两种形式（并联和串联）之间存在对称性，可以通过已知的三个参数计算第四个参数。
- **敏感度分析**：EET还可以用于分析传递函数对元件值变化的敏感度。

### 方法细节
- **空双重注入的计算**：通过调整两个输入信号，使得一个输出为零，从而简化了驱动点阻抗的计算。
- **修正因子的计算**：修正因子包含额外元件和两个驱动点阻抗，这些阻抗在额外元件存在和不存在的情况下分别计算。
- **EET的两种形式**：对于并联和串联的额外元件，EET有两种形式，分别对应于额外元件的阻抗为无穷大和零的情况。

### 观点与现象
文章强调了EET作为一种分析工具的价值，尤其是在处理复杂电路时，它可以显著简化分析过程。通过将复杂的电路分析分解为对更简单电路的分析，EET使得工程师能够更高效地处理电路设计中的问题。此外，文章还指出，尽管EET的概念可能对学生来说较为陌生，但通过实践和例子，他们可以逐渐掌握这一强大的工具。
```


## 2 - Null Double Injection

考虑一个两输入两输出的线性系统，由于系统是线性的，我们一定有：

$$
\begin{gather}
u_{o1} = A_1 u_{i1} + B_1 u_{i2} ,\quad 
u_{o2} = A_2 u_{i1} + B_2 u_{i2}
\end{gather}
$$

这里的 $u$ 可以是任何一种信号形式，包括但不限于电压、电流等。

我们将上式重写为：

$$
\begin{gather}
u_{o1} = B_1 u_{i1} \left(\frac{A_1}{B_1} + \frac{u_{i2}}{u_{i1}}\right)
 ,\quad 
u_{o2} = B_2 u_{i1} \left(\frac{A_2}{B_2} + \frac{u_{i2}}{u_{i1}}\right)
\end{gather}
$$

从这种写法可以看出，如果我们保持 $\frac{u_{i2}}{u_{i1}}$ 为某个特殊的常数，输出（中的一个）将会恒为零，此时我们说 we "null" the output. 作数学上的处理，我们可以得到：

$$
\begin{gather}
\left.\frac{u_{o2}}{u_{i2}}\right|_{u_{o1}=0} = Z_{v_{out} = 0} = \frac{A_1 B_2 - A_2 B_1}{A_1}
\end{gather}
$$

这便是 null double injection 的内容。简单来说， null double injection 中的 "null" 是指在某种输入信号下，输出 $v_{out} = 0$（<span style='color:red'> 不是简单的接地 </span>）；而 "double" 是指这时我们共有两个输入量，一个是 $v_{in}$，另一个是并联到两节点的电压源或者电流源。

相应地，另一个阻抗 $\left.\frac{u_{o2}}{u_{i2}}\right|_{u_{i1}=0} = Z_{v_{in} = 0}= B_2$ 称为 "single injection" 。

再次强调，<span style='color:red'> "Nulling is not the same as shorting" </span>，不能简单接地处理。

利用 null double injection 求解等效阻抗时的 <span style='color:red'> 一个小技巧是：当某条支路上没有电流通过时，支路所连的两节点可看作“虚短+虚断” </span>；无论支路上的总阻抗 $Z$ 是多少，只要 $|Z| < \infty$，都可视为“虚短+虚断”。

## 3 - EET for a Parallel Element

现在，如下图，我们假设 $u_{i2}$ 为电流，$u_{o2}$ 为电压，且两者在同一端口上（后文称为 2 号端口），也就是：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-09-09-34_Null Double Injection and the Extra Element Theorem.png"/></div>

这样，无论是 $u_{o1} = 0 $ 还是 $u_{i1} = 0$，$\frac{u_{o2}}{u_{i2}} = \frac{v}{i}$ 的比值都是一个常数，分别记作 $Z_{dp}|_{u_{o1} = 0 } = Z_n$ 和 $Z_{dp}|_{u_{i1} = 0 } = Z_d$, "dp" here stands for "driving point". 也就是：

$$
\begin{gather}
Z_n = \frac{A_1 B_2 - A_2 B_1}{A_1},\quad 
Z_d = B_2
\end{gather}
$$

在上面一步，我们相当于是在 2 号端口上施加了一个电流源 $u_{i2} = i$，现在，我们在二号端口并联一个阻抗 $Z$ (没有电流源)，如下：

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-09-15-03_Null Double Injection and the Extra Element Theorem.png"/></div>

可以注意到，当加入的阻抗 $Z= \infty$ 时 (也就是还没有把 $Z$ 并联进电路的时候)，2 号 端口的电流输入量 $u_{i2} = i = 0$，把 $u_{i1}$ 和 $u_{o1}$ 分别视为系统的输入、输出量，则系统的原始传递函数 (或者说 original gain) 可以表示为：

$$
\begin{gather}
(u_{o1} = A_1 u_{i1} + B_1 u_{i2} )_{u_{i2} = 0} \Longrightarrow 
H_0 = \left(\frac{u_{o1}}{u_{i1}}\right)_{u_{i2} = 0} =  A_1
\end{gather}
$$

当加入的阻抗 $Z$ 为有限值时 (也就是现在把 $Z$ 并联进电路)，将 $\frac{u_{o2}}{u_{i2}} = -Z$ 代入 (消去 $u_{i2}$)，再联立线性系统的两个方程解出 $u_{o2}$ 和 $u_{o1}$ (写成关于 $u_{i1}$ 的表达式)，得到：

$$
\begin{gather}
\frac{u_{o2}}{u_{i1}} = \frac{B_1}{1 + \frac{B_2}{Z}} ,\quad 
\frac{u_{o1}}{u_{i1}} = A_1 \frac{1 + \frac{1}{Z} \frac{A_1 B_2 - A_2 B_1}{A_1}}{1 + \frac{B_2}{Z}}
\end{gather}
$$

我们前面已经得到了 $Z_n = \frac{A_1 B_2 - A_2 B_1}{A_1}$ 和 $Z_d = B_2$，并且注意 $A_1$ 就是系统的原始增益（原始传递函数 $H_0$），所以可以将上面的第二个等式改写为：

$$
\begin{gather}
\boxed{
H = H_0 \cdot \frac{1 + \frac{Z_n}{Z}}{1 + \frac{Z_d}{Z}}
,\quad 
\mathrm{or}
\quad 
A_{Z} = A_{Z=\infty} \cdot \frac{1 + \frac{Z_n}{Z}}{1 + \frac{Z_d}{Z}}
}
\end{gather}
$$

至此，我们便证明了 extra element theorem (EET) 的并联形式。


## 4 - Example 1: CE Stage

考虑如下图所示的共射单极放大器 (common-emitter amplifier stage):
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-12-14-26-22_Null Double Injection and the Extra Element Theorem.png"/></div>

对 base 左端的输入/偏置部分作戴维南等效，得到：

$$
\begin{gather}
V_{Thev} = \frac{ R_1 \parallel R_2}{ R_1 \parallel R_2 + R_S}
,\quad 
R_{S} = R_S \parallel R_1 \parallel R_2
\end{gather}
$$

在之前的文章中 ([BJT 三种基本放大器的增益、跨导与输出阻抗](https://mp.weixin.qq.com/s/5ifWKEfBFn1nUKo4Rq7aVw))，我们已经讨论过标准 CE Stage 的增益，忽略沟道调制效应时，结论为：

$$
\begin{gather}
A_v = \frac{ \alpha R_C}{R_E + \frac{1}{g_m} + \frac{R_B}{\beta + 1}} \approx
\frac{R_C}{R_E + \frac{1}{g_m} + \frac{R_B}{\beta + 1}}
,\quad \alpha = \frac{\beta}{\beta + 1}
\end{gather}
$$

将这个结论应用到上图中，得到总增益为：

$$
\begin{gather}
A_v = \frac{ R_1 \parallel R_2}{ R_1 \parallel R_2 + R_S} \cdot \frac{R_L}{R + \frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1}}
\end{gather}
$$

下面我们用两种方法来计算加入旁路电容 $C_b$ 后的总增益。

### Direct Calculation

第一种是直接计算，由于 $C_b$ 与 $R$ 是并联关系，直接将 $R$ 替换为 $R \parallel \frac{1}{sC_b} = \frac{R}{1 + sRC_b}$，便得到并入电容后的结果：

$$
\begin{gather}
A_v' = \frac{ R_1 \parallel R_2}{ R_1 \parallel R_2 + R_S} \cdot \frac{R_L}{\frac{R}{1 + sRC_b} + \frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1}} =
\end{gather}
$$

我们将 $A_v'$ 重写为 $A_v$ 的形式：

$$
\begin{align}
\frac{A_v'}{A_v} &= \frac{R + \frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1}}{\frac{R}{1 + sRC_b} + \frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1}} 
\\
&= \frac{(1 + sRC_b)(R + \frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1})}{R + (1 + sRC_b)(\frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1})}
\\
&= \frac{(1 + sRC_b)(R + \frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1})}{R + \frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1} + sRC_b(\frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1})}
\\
&= \frac{1 + sRC_b}{1 + sC_b \frac{R(\frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1})}{R + \frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1}}}
\\
&= \frac{1 + sC_bR}{1 + sC_b \left[R \parallel \left(\frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1}\right)\right]}
\end{align}
$$

### Using EET

下面考虑利用 EET, 先求 $Z_n = Z_{v_{out} = 0}$。注意到 $v_{out} = 0$ 时，$R_L$ 断路 <span style='color:red'> （这与直接把 $V_{out}$ 接地不同！） </span>，$I_C$ 断路，因此 $I_B$ 也断路，看入的阻抗就是 $R$，也即：

$$
\begin{gather}
Z_n = Z_{v_{out} = 0} = R
\end{gather}
$$

对于 $Z_d = Z_{v_{in} = 0}$, 看入的阻抗是：

$$
\begin{gather}
 Z_d = R \parallel R_{emit} =  R \parallel \left(\frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1}\right)
\end{gather}
$$

应用 EET，得到：

$$
\begin{gather}
A_v' = A_v \cdot \frac{1 + sC_bR}{1 + sC_b \cdot \left[R \parallel \left(\frac{1}{g_m} + \frac{R_S \parallel R_1 \parallel R_2}{\beta + 1}\right)\right]}
\end{gather}
$$

这与我们前面直接分析得到的结果相同。

## 5 - EET for a Series Element

将 EET 的并联形式改写为：

$$
\begin{gather}
A|_Z = A|_{Z = \infty} \cdot \frac{1 + \frac{Z_n}{Z}}{1 + \frac{Z_d}{Z}}
\Longleftrightarrow 
A|_Z = \left[A|_{Z = \infty} \frac{Z_n}{Z_d}\right] \cdot \frac{1 + \frac{Z}{Z_n}}{1 + \frac{Z}{Z_d}}
\end{gather}
$$

注意到 $\left[A|_{Z = \infty} \frac{Z_n}{Z_d}\right]$ 就是 $A|_{Z = 0}$，因为 $Z = 0$ 时，$\frac{1 + \frac{Z}{Z_n}}{1 + \frac{Z}{Z_d}} = 1$。这样，上式变为：

$$
\begin{gather}
A|_Z = A|_{Z = 0} \cdot \frac{1 + \frac{Z}{Z_n}}{1 + \frac{Z}{Z_d}}
\end{gather}
$$

这就是 EET 的串联形式。也就是说，原本电路中的某条支路是导线（$Z=0$），计算得到的增益为 $A|_{Z = 0}$，当我们想在这条支路上串联进一个阻抗 $Z$ 时（$Z\ne 0$），增益就变为 $A|_Z = A|_{Z = 0} \cdot \frac{1 + \frac{Z}{Z_n}}{1 + \frac{Z}{Z_d}}$。$Z_n$ 与 $Z_d$ 的含义仍不变，也就是 $Z_n = Z_{v_{out} = 0}$ 和 $Z_d = Z_{v_{in} = 0}$。


注意，在准备利用 EET 的串联形式，正在计算 $Z_n$ 和 $Z_d$ 时，<span style='color:red'> 需要将这条支路“断开” </span>，因为 $Z_n$ 和 $Z_d$ 是在 $Z = \infty$ 的条件下得到的。

## 6 - Example 2: CS Stage with Miller Effect

MOS gate 和 drain 之间的寄生电容 (记作 $C_{GD}$) 通常是限制增益带宽的主要因素。下面，我们便尝试利用 EET 求出 CS 的传递函数 $H(s)$, 并与直接列 KCL/KVL 所得结果进行比较。

CS Stage with Miller Effect 电路图如下：

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-12-21-47-43_Null Double Injection and the Extra Element Theorem.png"/></div>


列出 KCL/KVl 求解等效小信号电路的过程比较繁琐，详见 [Frequency Response of CE and CS Stages (共射/共源放大器的频率响应)](https://zhuanlan.zhihu.com/p/1892732378264339436)，这里直接给出结论：

$$
\begin{gather}
\frac{V_{out}}{V_{in}} = -g_m R_L \cdot \frac{1 - \frac{s}{\frac{g_m}{C_{GD}}}}{a s^2 + bs + 1}
\\
a = R_{S}R_L \left( C_{GS} C_{GD} + C_{GS} C_{DB} + C_{GD}C_{DB} \right)
\\
b = g_m R_L R_{S}C_{GD}  + R_{S} (C_{GD} + C_{GS}) + R_L (C_{GD} + C_{DB})
\\ \Longrightarrow 
\begin{cases}
\frac{1}{\omega_{p1}}\frac{1}{\omega_{p2}} = a\\
\frac{1}{\omega_{p1}} + \frac{1}{\omega_{p2}} = b
\end{cases}
\\ \Longrightarrow 
\begin{cases}
\omega_{zero} = \frac{g_m}{C_{GD}} \\
\omega_{p1} = \frac{2}{b + \sqrt{b^2 - 4a}} \approx \frac{1}{b}\\
\omega_{p2} = \frac{2}{b - \sqrt{b^2 - 4a}} \approx \frac{b}{a}\\
\end{cases}
\end{gather}
$$

其中 $R_S$ 是前级的等效输出阻抗，$R_L$ 是 CS 的总负载电阻（可以包括 $r_O$）。


下面就用 EET 来求解这个传递函数。
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-00-23-37_Calcu CS Transfer Function using EET.png"/></div>
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-00-23-50_Calcu CS Transfer Function using EET.png"/></div>

可以看到，用 EET 所得结果与直接分析法完全一致。

## 7 - Z_d Calculation Tip

实际使用 EET 时，我们通常需要计算三个量： $A|_{Z = \infty}$ (or $A|_{Z = 0}$), $Z_n$, $Z_d$，前两个量的计算通常很简单，而 $Z_d$ 的计算可能会比较困难（例如 $C_{GD}$ 两端的 $Z_d$ 就稍显繁琐）。回想我们之前提到过的，$A|_{Z = \infty}$ 和 $A|_{Z = 0}$ 满足关系：

$$
\begin{gather}
A|_{Z = \infty} \cdot \frac{Z_n}{Z_d} = A|_{Z=0}
\Longrightarrow 
Z_d = \frac{A|_{Z = \infty}}{A|_{Z = 0}} \cdot Z_n
\end{gather}
$$

这为 $Z_d$ 的计算提供了另一种方法，在 $Z_d$ 的计算稍复杂时，选用上式进行计算通常会简单很多。

仍以上面 CS Stage with Miller Effect 为例，此时的 $Z$ 是电容 $C_{GD}$ 的阻抗，我们先求解两个增益 $A|_{Z = \infty}$ 和 $A|_{Z = 0}$：

$$
\begin{gather}
A|_{Z = \infty} = \frac{\frac{1}{sC_{GS}}}{\frac{1}{sC_{GS}} + R_S} \cdot (-g_m) \left(R_L \parallel \frac{1}{s C_{DB}}\right) 
= \frac{1}{1 + s R_S C_{GS}} \cdot \frac{-g_m R_L}{1 + s R_L C_{DB}}
\end{gather}
$$

$A|_{Z = 0}$ 的求解不是那么 intuitive ，我们列出 KCL 得到：

$$
\begin{gather}
\frac{V_{in} - V_{out}}{R_S} = \frac{V_{out}}{\frac{1}{s C_{GS}} \parallel \frac{1}{g_m} \parallel \frac{1}{s C_{DB}} \parallel R_L} 
\\
\Longrightarrow A|_{Z = 0} = \frac{V_{out}}{V_{in}} = \frac{\frac{1}{R_S}}{\frac{1}{R_S} + \frac{1}{R_L} + g_m + s(C_{GS} + C_{DB})}
\end{gather}
$$

由容易知道 $Z_n = Z_{out,0} = - \frac{1}{g_m}$，代入得到：

$$
\begin{align}
Z_d 
&= \frac{A|_{Z = \infty}}{A|_{Z = 0}} \cdot Z_n 
= \frac{\frac{1}{1 + s R_S C_{GS}} \cdot \frac{-g_m R_L}{1 + s R_L C_{DB}}}{\frac{\frac{1}{R_S}}{\frac{1}{R_S} + \frac{1}{R_L} + g_m + s(C_{GS} + C_{DB})}} \cdot -\frac{1}{g_m} 
\\
&= \frac{s R_S R_L (C_{GS} + C_{DB}) + g_m R_S R_L + R_S + R_L}{(1 + s R_S C_{GS})(1 + s R_L C_{DB})}
\end{align}
$$

就像我们所预期的，这个结果与直接求解 $Z_d$ 是一致的，而且过程也简单很多。另外，求解时要注意增益的正负，因为 $Z_n$ (或者 $Z_d$) 在某些情况下可以是负值，所以正负问题不能忽略。

## 8 - General Form of EET 

上面的两个形式中（串联和并联），都假设了输入输出在同一端口，也即 $u_{i2} = i$ 和 $u_{o2} = v$ 在同一端口的情况。实际上， EET 也可以用于输出是受控源的一般情形。此时，输入输出不在同一个端口，相应的传递函数公式变为：

<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-12-22-12-12_Null Double Injection and the Extra Element Theorem.png"/></div>

论文中对 $W$ 的定义与 $\frac{u_{o2}}{u_{i2}}$ 的量纲相反，不便于理解，我们这里采取一种新的定义方式（相应的公式形式也会变化）。将上式中的 $W$ 定义为受控源的映射关系，也即：

$$
\begin{gather}
W \ :=\   (- 1) \times \frac{\mathrm{controlled\ signal}}{\mathrm{controlling\ signal}}
\\
A = A|_{W = \infty} \cdot 
\frac{
    1 + \frac{\left(\frac{u_{o2}}{u_{i2}}\right)_{u_{o1} = 0}}{W}
    }{
    1 + \frac{\left(\frac{u_{o2}}{u_{i2}}\right)_{u_{i1} = 0}}{W}
    }
= A|_{W = 0} \cdot 
\frac{
    1 + \frac{W}{\left(\frac{u_{o2}}{u_{i2}}\right)_{u_{o1} = 0}}
    }{
    1 + \frac{W}{\left(\frac{u_{o2}}{u_{i2}}\right)_{u_{i1} = 0}}
    }
\end{gather}
$$

计算 $\frac{u_{o2}}{u_{i2}}$ 时，我们需要用一个独立元件 (independent element) 替换掉 $W$，这个元件可以是电压源、电流源或者阻抗/导纳，哪个计算方便我们就选哪一个。对于 $W$ 的含义，注意有一个负号，然后我们举两个例子：一个受控电流源，控制信号为 $i$, 受控信号为 $i' = \beta i$，其 $W = -\frac{i'}{i} = -\beta$ (unit: 1)；又或者一个受控电压源，控制信号为 $i$, 受控信号为 $v = \lambda i$, 其 $W = -\frac{v}{i} = -\lambda$ (unit: Ohm); 特别地，当控制信号 $i$ 和受控信号 $v$ 在同一端口时，$W$ 就相当于接在此端口的阻抗 $Z$，这便回到了 EET 的前两种形式。

论文还指出， EET 的普遍形式（受控源形式）表示了传递函数关于 $W$ 的变化情况，因此非常适用于 sensitivity 的计算和分析，例如 gain 关于 $\beta$ 的 sensitivity 。

## 9 - Example 3: CE Stage with Beta Variation

按我们自己对 general form 的定义， CE Stage with Beta Variation 的增益可以表示为：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-01-39-40_Null Double Injection and the Extra Element Theorem.png"/></div>

也就是：

$$
\begin{gather}
W = -\beta
\\
\left(\frac{u_{o2}}{u_{i2}}\right)_{u_{o1} = 0} = 0
,\quad 
\left(\frac{u_{o2}}{u_{i2}}\right)_{u_{i1} = 0} = - \frac{R_g + r_E}{r_E} = - (g_m R_B + 1)
\\
A|_{W = \infty} = A|_{\beta = \infty} = \frac{- R_C}{\frac{1}{g_m}}
\\
A|_{W} = A|_{W = \infty} \cdot \frac{\frac{1}{g_m} \alpha}{\frac{1}{g_m} + \frac{R_B}{\beta + 1}}
= \frac{- \alpha R_C}{\frac{1}{g_m} + \frac{R_B}{\beta + 1}}
\end{gather}
$$

显然，$A|_{W}$ 与我们直接计算得到的结果相同，侧面验证了 general form of EET 的正确性。

## 10 - Return Ratio and Sensitivity

论文原文如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-00-58-28_Null Double Injection and the Extra Element Theorem.png"/></div>

按我们对 general form 的定义， the return ratio, the null return ratio, 以及 $A$ 应改写为：

$$
\begin{gather}
A = A|_{W = \infty} \cdot 
\frac{
    1 + T_{nW} 
    }{
    1 + T_{dW}
    }
= A|_{W = 0} \cdot 
\frac{
    1 + \frac{1}{T_{nW}}
    }{
    1 + \frac{1}{T_{dW}}
    }
\\ 
T_{nW} = \frac{\left(\frac{u_{o2}}{u_{i2}}\right)_{u_{o1} = 0}}{W}
,\quad 
T_{dW} = \frac{\left(\frac{u_{o2}}{u_{i2}}\right)_{u_{i1} = 0}}{W}
\\
W \ :=\   (- 1) \times \frac{\mathrm{controlled\ signal}}{\mathrm{controlling\ signal}}
\end{gather}
$$

再次强调 $W$ 定义中的负号。

仍然用上面 Example 3: CE Stage with Beta Variation 作为例子，传递函数 $A$ 关于物理量 $W$ 的灵敏度定义为：

$$
\begin{gather}
S_W^A := \frac{\frac{\mathrm{d}A}{A}}{\frac{\mathrm{d}W}{W}} = \frac{W}{A} \frac{\mathrm{d} A }{\mathrm{d} W }
\end{gather}
$$

由于表达式 $A = A|_{W = \infty} \cdot \frac{1 + T_{nW} }{1 + T_{dW} }$ 中，$A|_{W = \infty}$ 与 $W$ 无关，可以重写为：

$$
\begin{gather}
\ln A = \ln A|_{W = \infty} + \ln (1 + T_{nW}) - \ln (1 + T_{dW})
\\
\Longrightarrow 
\frac{1}{A} \frac{\mathrm{d} A }{\mathrm{d} W } = \frac{1}{1 + T_{nW}}\frac{\mathrm{d} T_{nW} }{\mathrm{d} W } - \frac{1}{1 + T_{dW}}\frac{\mathrm{d} T_{dW} }{\mathrm{d} W } 
= \frac{1}{1 + T_{nW}}\cdot\frac{T_{nW}}{- W } - \frac{1}{1 + T_{dW}}\cdot\frac{T_{dW}}{- W }
\\
\Longrightarrow 
\frac{W}{A} \frac{\mathrm{d} A }{\mathrm{d} W } = \frac{T_{dW}}{1 + T_{dW}} - \frac{T_{nW}}{1 + T_{nW}}
\end{gather}
$$

也就是：

$$
\begin{gather}
S_W^A = \frac{T_{dW}}{1 + T_{dW}} - \frac{T_{nW}}{1 + T_{nW}}
= \frac{1}{1 + T_{nW}} - \frac{1}{1 + T_{dW}}
\end{gather}
$$

我们这里的灵敏度公式与论文中不完全一样，是因为 $W$ 的定义不同。代入上面的例子，我们有：

$$
\begin{gather}
W = -\beta
,\quad 
\left(\frac{u_{o2}}{u_{i2}}\right)_{u_{o1} = 0} = 0,\quad 
\left(\frac{u_{o2}}{u_{i2}}\right)_{u_{i1} = 0} = - \frac{R_g + r_E}{r_E} = - (g_m R_B + 1)
\\
\Longrightarrow 
T_{nW} = \frac{\left(\frac{u_{o2}}{u_{i2}}\right)_{u_{o1} = 0}}{W} = 0,\quad 
T_{dW} = \frac{\left(\frac{u_{o2}}{u_{i2}}\right)_{u_{i1} = 0}}{W} = \frac{g_m R_B + 1}{\beta}
\end{gather}
$$

注意到 $W = -\beta \Longrightarrow \frac{\mathrm{d}W}{W} = \frac{\mathrm{d}\beta}{\beta}$, 因此：

$$
\begin{gather}
S_\beta^A = S_W^A = \frac{1}{1 + 0} - \frac{1}{1 + \frac{g_m R_B + 1}{\beta}} = \frac{g_m R_B + 1}{\beta + g_m R_B + 1} 
= \frac{1}{1 + \frac{\beta}{g_m R_B + 1}}
\end{gather}
$$

这里的 $S_\beta^A > 0$, 意味着 $\beta$ 的绝对值按百分比增大时，增益 $A$ 的绝对值也按百分比增大。举个例子，假设现在 $A = -100$, $\beta = 100$ 且 $S_\beta^A = 0.1 > 0$, 那么当 $\beta$ 从 100 增加到 101 时 (增加了 1%), 增益 $A$ 将从 -100 变为 -100.1 (绝对值增加了 0.1%)。

## 11 - Useful Observation

值得指出的是， EET 可以用于求解任何形式的传递函数，包括但不限于输入/输出阻抗/导纳、电压/电流增益，PSRR，CMRR 等，只要系统满足线性性即可（例如小信号分析）。特别地，当传递函数是 "self-impedance" 时： $v_{in} = 0$ 等价于 input 开路，$v_{out} = 0$ 等价于 input 短路（即 $v_{out}$ 的两节点短路）。



## Summary

总的来讲，论文介绍了 EET (Extra Element Theorem) 的两种基本形式，一种普遍的受控源形式（常用于灵敏度分析），还介绍了求解 $Z_d$ 的间接方法，以及每种形式的具体应用实例。