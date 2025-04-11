# Null Double Injection and the Extra Element Theorem

> [!Note|style:callout|label:Infor]
Initially published at 23:46 on 2025-04-02 in Beijing.


## Infor 

- Title: [*Null Double Injection and the Extra Element Theorem*](https://ieeexplore.ieee.org/document/34149)
- DOI: [10.1109/13.34149](https://doi.org/10.1109/13.34149)
- Author:  [R. D. MIDDLEBROOK](https://ieeexplore.ieee.org/author/37299930400)
- Publication Date: 06 August 2002
- Published in: [IEEE Transactions on Education](https://ieeexplore.ieee.org/xpl/RecentIssue.jsp?punumber=13) (Volume: 32, Issue: 3, August 1989)

## Abstract

The extra element theorem (EET) states that any transfer function of a linear system can be expressed in terms of its value when a given 'extra' element is absent, and a correction factor involving the extra element and two driving-point impedances are seen by the element. 

In the present work, the EET is derived and applied to several examples in a manner that has been developed and refined in the classroom over a number of years. 
The concept of null double injection is introduced first, because it is the key to making easy the calculation of the two driving-point impedances needed for the EET correction factor.

The EET for series and parallel elements is then considered, and attention is also given to the EET as an analysis tool, to the symmetry of the two forms of the EET, and to return ratios and sensitivity.

<!-- details begin -->
<details>
<summary>Abstract</summary>

The extra element theorem (EET) states that any transfer function of a linear system can be expressed in terms of its value when a given 'extra' element is absent, and a correction factor involving the extra element and two driving-point impedances are seen by the element. 

In the present work, the EET is derived and applied to several examples in a manner that has been developed and refined in the classroom over a number of years. 
The concept of null double injection is introduced first, because it is the key to making easy the calculation of the two driving-point impedances needed for the EET correction factor.

The EET for series and parallel elements is then considered, and attention is also given to the EET as an analysis tool, to the symmetry of the two forms of the EET, and to return ratios and sensitivity.
</details>


<!-- 
原文摘要：
``` txt
Abstract:

The extra element theorem (EET) states that any transfer function of a 
linear system can be expressed in terms of its value when a given 'extra' 
element is absent, and a correction factor involving the extra element 
and two driving-point impedances are seen by the element. In the present 
work, the EET is derived and applied to several examples in a manner that 
has been developed and refined in the classroom over a number of years. 

The concept of null double injection is introduced first, because it is 
the key to making easy the calculation of the two driving-point impedances 
needed for the EET correction factor. The EET for series and parallel 
elements is then considered, and attention is also given to the EET as an 
analysis tool, to the symmetry of the two forms of the EET, and to return 
ratios and sensitivity.
```
 -->
<!-- details begin -->

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


## Null Double Injection

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
\left.\frac{u_{o2}}{u_{i2}}\right|_{u_{o1}=0} = \frac{A_1 B_2 - A_2 B_1}{A_1},\quad 
\left.\frac{u_{o2}}{u_{i2}}\right|_{u_{i1}=0} = B_2
\end{gather}
$$

这便是 null double injection 的内容。

## EET for a parallel element

现在，如下图，我们假设 $u_{i2}$ 为电流，$u_{o2}$ 为电压，且两者在同一端口上（后文称为 2 号端口），也就是：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-09-09-34_Null Double Injection and the Extra Element Theorem.png"/></div>

这样，无论是 $u_{o1} = 0 $ 还是 $u_{i1} = 0$，$\frac{u_{o2}}{u_{i2}} = \frac{v}{i}$ 的比值都是一个常数，分别记作 $Z_{dp}|_{u_{o1} = 0 } = Z_n$ 和 $Z_{dp}|_{u_{i1} = 0 } = Z_d$, "dp" here stands for "driving point".

在上面一步，我们相当于是在 2 号端口上施加了一个电流源 $u_{i2} = i$，现在，我们在二号端口并联一个阻抗 $Z$ (没有电流源)，如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-09-15-03_Null Double Injection and the Extra Element Theorem.png"/></div>

可以注意到，当加入的阻抗 $Z= \infty$ 时，2 号 端口的电流输入量 $u_{i2} = i = 0$，把 $u_{i1}$ 和 $u_{o1}$ 分别视为系统的输入、输出量，此时系统的传递函数 (或者说 gain) 可以表示为：

$$
\begin{gather}
H_0 = A_{z=\infty}
\end{gather}
$$

## EET for a series element






## Summary

总的来讲