# BJT's Small-Signal Terminal Resistances (三极管的小信号节点电阻)

> [!Note|style:callout|label:Infor]
> Initially published at 16:44 on 2025-03-05 in Beijing.


## 前言

为了快速且准确地得出三极管放大器的 $G_m$, $R_{out}$ 和增益 $A_v$，我们有相当的必要求解三极管的小信号节点电阻。常见的近似结果有 $r_{O},\ r_{\pi},\ \frac{1}{g_m}$ 等，但它们在某些情况下并不适用（误差很大），因此我们需要更加普适的表达式，本文将给出这些表达式及其推导过程。

若无特别说明，后文的讨论将包括三极管的 $r_{\pi}, g_m (\mathrm{or\ } \beta), r_O$ 等小信号参数。同时，为了使结果的表达形式更简洁，我们利用公式 $r_{\pi} = \frac{\beta}{g_m} \Longrightarrow g_m = \frac{\beta}{r_{\pi}}$，将结果中的 $g_m$ 全部替换为了 $\beta$。


为方便查阅，我们先给出结果汇总：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-19-35-43_BJT's Terminal Resistances.png"/></div>



## BJT's Intrinsic Resistance (三极管本征电阻)

在研究三极管与电阻耦合情形之前，我们需要先求解三极管本身的节点电阻，不妨称为三极管的“本征”电阻。此情形下的计算比较简单，我们略过，直接给出结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-18-49-16_BJT's Terminal Resistances.png"/></div>


与之类似的概念还有 intrinsic gain (本征增益) $A_{int} = g_m r_O$，其中 $r_O$ 是三极管的厄利电阻（对其他类型晶体管也类似）。


## BJT with Series Terminal Resistances (带有串联电阻的三极管)

现在，我们来考虑下图所示的三极管模型：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-19-38-51_BJT's Terminal Resistances.png"/></div>

计算某一个节点的电阻时，由于串联等效性，我们可以假设此节点串接电阻为零。例如计算 $R_{coll}$ 时，我们假设 $R_C = 0$，这样，对于 $R_C \ne 0 $ 的情况，只需用计算得到的 $R_{coll}$ 加上 $R_C$ 即可。**注意：另外两个节点的串联电阻不能直接忽略，因为它们耦合在了 BJT 的小信号模型中**。

下面我们分别计算 $R_{coll}$, $R_{base}$ 和 $R_{emitter}$。$R_{coll}$ 的计算过程如下：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-19-43-33_BJT's Terminal Resistances.png"/></div>
 -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-12-14-08-33_BJT's Terminal Resistances.png"/></div>

$R_{base}$ 的计算过程如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-19-43-46_BJT's Terminal Resistances.png"/></div>

$R_{emitter}$ 的计算过程如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-19-43-55_BJT's Terminal Resistances.png"/></div>

至此，我们便得到了三极管（小信号）节点电阻的普适结果。对于一些常见的情况，只需简单令 $R_C$, $R_B$ 和 $R_E$ 为相应的值（或者 0）即可。

## Conclusion (总结)

列出所有结果，加深印象：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-19-35-43_BJT's Terminal Resistances.png"/></div>

有时图片查看并不方便，我们再单独列出一遍：


$$
\begin{gather}
\begin{cases}
R_{coll} = r_O \cdot \left[ 1 + \left(\beta + \frac{r_{\pi} + R_B}{r_O}\right)\cdot \left(R_E \parallel \left(r_{\pi} + R_B\right) \right) \right]
\\
R_{coll}|_{R_B = 0} = r_O \cdot \left[ 1 + \left(\beta + \frac{r_{\pi}}{r_O}\right)\cdot \left(R_E \parallel r_{\pi} \right) \right]
\\
R_{coll}|_{R_E = 0} = r_O 
\end{cases}
\\
\begin{cases}
R_{emit} = \left(1 + \frac{R_C}{r_O}\right) \cdot \left(\frac{r_{\pi} + R_B}{1 + \frac{R_C}{r_O}} \parallel \frac{r_{\pi} + R_B}{\beta} \parallel r_O\right)
\\
R_{emit}|_{R_C = 0} =  \frac{r_{\pi} + R_B}{1 + \beta} \parallel r_O
\\
R_{emit}|_{R_B = 0} = \left(1 + \frac{R_C}{r_O}\right) \cdot \left(\frac{r_{\pi}}{1 + \frac{R_C}{r_O}} \parallel \frac{r_{\pi}}{\beta} \parallel r_O\right)
\end{cases}
\\
\begin{cases}
R_{base} = r_{\pi} + R_E \cdot \frac{\beta\, r_O + (r_O + R_C)}{R_E + (r_O + R_C)}
\\
R_{base}|_{R_C = 0} = r_{\pi} + (1 + \beta) (R_E\parallel r_O)
\\
R_{base}|_{R_E = 0} = r_{\pi}
\end{cases}
\end{gather}
$$