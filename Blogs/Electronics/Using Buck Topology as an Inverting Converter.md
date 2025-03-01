# Using Buck Topology as an Inverting Converter (Buck-Boost)

> [!Note|style:callout|label:Infor]
Initially published at 13:57 on 2025-02-16 in Lincang.

## 前言

由于 buck 和 buck-boost 在拓扑上的“同一性”，即拓扑结构完全相同，仅端口定义不同（但是反馈环路稍有不同，我们不作细究），**我们可以将 buck 电路用作 buck-boost 电路，从而获得负电压输出**。当然，反过来将 buck-boost 用作 buck 也是可以的。下面我们先介绍为什么说“两者拓扑相同”，再讨论实现负电压输出的具体方法。

## Buck and Buck-Boost Topology

一个 Buck Topology ，通常可以简化为具有 $V_{in}$、$V_{out}$ 和 $\mathrm{GND} (V_{ref})$ 的三端（三节点）网络，并且满足 $V_{in} > V_{out} > \mathrm{GND}$，如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-17-05-30_Using Buck Topology as an Inverting Converter.png"/></div>

而 buck-boost 输出电压为负，因此也满足 $V_{in} > V_{out} > \mathrm{GND}$，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-17-07-45_Using Buck Topology as an Inverting Converter.png"/></div>




由图中可以看出，两者的拓扑结构完全相同，只是端口定义不同（序号不同）。 buck 中的 GND (2号端口) 是 boost 中的 V_out (3号端口)，buck 中的 V_out (3号端口) 是 boost 中的 GND (2号端口)。


## Configure Buck Topology to an Inverting Converter (Buck-Boost)

如何将 buck 电路当作 buck-boost 来使用呢？ <span style='color:red'> 在注意滤波电容（不是储能电容）位置的情况下</span>，只需简单交换 buck 中的 `GND` 和 `V_out` 节点，即可实现负电压输出，下面我们研究输入输出的范围关系。设 buck 输入电压范围被限制在 $[(V_{in,\min})_{\mathrm{buck}},\ (V_{in,\max})_{\mathrm{buck}}]$ (Absolute Maximum Ratings)，输出电压至少为 $(V_{out,\min})_{\mathrm{buck}}$ 同时 buck 输入电压至少比输出电压高 $\Delta V$。写成数学形式：

$$
\begin{gather}
\begin{cases}
(V_{in})_{\mathrm{buck}} \geqslant (V_{in,\min})_{\mathrm{buck}}\\
(V_{in})_{\mathrm{buck}} \leqslant (V_{in,\max})_{\mathrm{buck}}\\
(V_{out})_{\mathrm{buck}} \geqslant (V_{out,\min})_{\mathrm{buck}}\\
(V_{out})_{\mathrm{buck}} \leqslant (V_{in})_{\mathrm{buck}} - \Delta V
\end{cases}
\end{gather}
$$

buck 向 inverting 的转换关系为：

$$
\begin{gather}
\begin{cases}
(V_{in})_{\mathrm{inv}} = (V_{in})_{\mathrm{buck}} - (V_{out})_{\mathrm{buck}}\\ 
(V_{out})_{\mathrm{inv}} = -(V_{out})_{\mathrm{buck}}
\end{cases}
\Longrightarrow 
\begin{cases}
(V_{in})_{\mathrm{buck}} = (V_{in})_{\mathrm{inv}} - (V_{out})_{\mathrm{inv}}\\
(V_{out})_{\mathrm{buck}} = -(V_{out})_{\mathrm{inv}}
\end{cases}
\end{gather}
$$

代入转换关系，得到 inverting 结构下的输入输出电压限制：

$$
\begin{gather}
\begin{cases}
(V_{in})_{\mathrm{inv}} - (V_{out})_{\mathrm{inv}} \geqslant (V_{in,\min})_{\mathrm{buck}}\\
(V_{in})_{\mathrm{inv}} - (V_{out})_{\mathrm{inv}} \leqslant (V_{in,\max})_{\mathrm{buck}}\\
(V_{out})_{\mathrm{inv}} \leqslant -(V_{out,\min})_{\mathrm{buck}}\\
(V_{out})_{\mathrm{inv}} \geqslant  \Delta V - (V_{in})_{\mathrm{buck}} 
\end{cases}
\end{gather}
$$

进一步化简第四条，得到：

$$
\begin{gather}
\begin{cases}
(V_{in})_{\mathrm{inv}} - (V_{out})_{\mathrm{inv}} \geqslant (V_{in,\min})_{\mathrm{buck}}\\
(V_{in})_{\mathrm{inv}} - (V_{out})_{\mathrm{inv}} \leqslant (V_{in,\max})_{\mathrm{buck}}\\
(V_{out})_{\mathrm{inv}} \leqslant -(V_{out,\min})_{\mathrm{buck}}\\
(V_{in})_{\mathrm{inv}} \geqslant \Delta V
\end{cases}
\end{gather}
$$

这便得到了 inverting 结构下的输入输出电压限制。举个例子，设 $(V_{in,\min})_{\mathrm{buck}} = 4 \ \mathrm{V}$，$(V_{in,\max})_{\mathrm{buck}} = 40 \ \mathrm{V}$，$(V_{out,\min})_{\mathrm{buck}} = 2 \ \mathrm{V}$，$\Delta V = 2 \ \mathrm{V}$，那么 inverting 结构下的输入输出电压范围是：

$$
\begin{gather}
\begin{cases}
(V_{in})_{\mathrm{inv}} - (V_{out})_{\mathrm{inv}} \geqslant 4 \ \mathrm{V}\\
(V_{in})_{\mathrm{inv}} - (V_{out})_{\mathrm{inv}} \leqslant 40 \ \mathrm{V}\\
(V_{out})_{\mathrm{inv}} \leqslant -2 \ \mathrm{V}\\
(V_{in})_{\mathrm{inv}} \geqslant 2 \ \mathrm{V}
\end{cases}
,\quad 
\begin{cases}
给定 (V_{in})_{\mathrm{inv}} = +5 \ \mathrm{V} \\
(V_{out})_{\mathrm{inv}} \leqslant 1 \ \mathrm{V} \\
(V_{out})_{\mathrm{inv}} \geqslant -35 \ \mathrm{V}\\
(V_{out})_{\mathrm{inv}} \leqslant -2 \ \mathrm{V}
\end{cases}
,\quad 
\begin{cases}
给定 (V_{out})_{\mathrm{inv}} = -5 \ \mathrm{V}\\
(V_{in})_{\mathrm{inv}} \geqslant -1 \ \mathrm{V}\\
(V_{in})_{\mathrm{inv}} \leqslant 35 \ \mathrm{V}\\
(V_{in})_{\mathrm{inv}} \geqslant 2 \ \mathrm{V}
\end{cases}
\end{gather}
$$


## Demo

作为一个例子，我们用手上现有的一个 Buck 电路进行实验（如下图）。
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-16-10-54_Using Buck Topology as an Inverting Converter.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-16-17-44_Using Buck Topology as an Inverting Converter.png"/></div>

此电路使用了 [LM2596S-ADJ](https://www.ti.com/cn/lit/ds/symlink/lm2596.pdf) 作为 Buck 芯片。我们先正常接入 +10V，调整电位器，使输出电压为 +5V。然后，将 V_out 与 GND 节点互换，观察是否能够得到预期的 -5V 输出，结果如下：
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-15-51-18_Using LDO or Buck Topology as an Inverting Converter.png"/></div>

显然，输出为 -5V，这与我们的预测完全一致。此时，作为  `Inverting: +5V to -5V` 的 Buck 电路实际上（以为自己）工作在 `Buck: +10V to +5V` 的条件下。在 `Inverting: +5V to -5V` 条件下分别测试 1A ~ 3A 负载的 Load Regulation 和 Output Ripple ，所得结果与 `Buck: +10V to +5V` 时无明显差异。

## Can we use buck (or buck-boost) as a boost converter? 

Boost 电路的拓扑结构与 buck (or buck-boost) 并不相同，因此原则上无法与之等效，如下图所示。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-17-10-28_Using Buck Topology as an Inverting Converter.png"/></div>

## Can we use LDO as an Inverting Converter?

LDO 的输入输出电压关系与 Buck 电路类似，那么 LDO 是否可以实现负电压输出呢？
仿照上面的思路，我们利用一个 LDO (AMS1117-5.0) 来尝试实现负压输出，事实证明，这是不可行的。就像 boost 无法等效转换一样， LDO 的工作原理决定了它无法当作 buck 来使用，具体原因我们不多赘述。
<!-- <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-16-08-38_Using Buck Topology as an Inverting Converter.png"/></div> -->
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-16-12-19_Using Buck Topology as an Inverting Converter.png"/></div>

## Conclusion

总的来讲，若原 buck 电路的输入、输出和 GND 分别为 1、2、3 号端口，那么**生成负压源时，我们只需将正输入接 1 号端口、 GND 接 2 号端口、负输出接 3 号端口即可**。特别地，依据芯片数据手册中的公式 $V_{out} = V_{ref} \left(1 + \frac{R_1}{R_2}\right)$ 来设置反馈电阻时，反馈电阻的计算公式如下：

$$
\begin{gather}
| \mathrm{负输出} | = V_{ref} \left(1 + \frac{R_1}{R_2}\right)
\Longrightarrow 
\frac{R_1}{R_2} = \frac{| \mathrm{负输出} |}{V_{ref}} - 1
\end{gather}
$$

当所需的负输出电压已知时，$R_1$ 与 $R_2$ 的比值便唯一确定。

举个简单的例子，若我们的正输入为 +5V，负输出为 -10V，首先要保证 $|\mathrm{正输入}| + |\mathrm{负输入}|$ 不超过芯片的最大输入电压，然后便可计算所需的反馈电阻（假设 $V_{ref} = 1.25\ \mathrm{V}$）：

$$
\begin{gather}
| \mathrm{负输出} | = 10\ \mathrm{V} = 1.25\ \mathrm{V} \times\left(1 + \frac{R_1}{R_2}\right)
\Longrightarrow 
R_1 = R_2 \cdot \left( \frac{10\ \mathrm{V}}{1.25\ \mathrm{V}} - 1 \right) = 7 R_2
\end{gather}
$$

如果选择 $R_2 = 10 \ \mathrm{K\Omega}$，那么 $R_1 = 70 \ \mathrm{K\Omega}$。

## References

- [TI Application Note: *Create an Inverting Power Supply Using a TPS6293x Buck Converter*](https://www.ti.com/lit/an/slvafh1a/slvafh1a.pdf)
- [TI Application Note: *Using the TPS6215x in an Inverting Buck-Boost Topology*](https://www.ti.com/lit/an/slva469d/slva469d.pdf)
- [TI Application Note: *Using the TPS5430 as an Inverting Buck-Boost Converter*](https://www.ti.com/lit/an/slva257a/slva257a.pdf)
- [TI Application Note: *Using the TPS54335A to Create an Inverting Power Supply*](https://e2e.ti.com/cfs-file/__key/communityserver-discussions-components-files/196/Using-the-TPS54335A-to-Create-an-Inverting-Power-Supply.pdf)
- [TI Application Note: *Creating an Inverting Power Supply Using a Synchronous Step-Down Regulator*](https://www.ti.com/lit/an/slva458b/slva458b.pdf)
- [TI Application Note: *Create an Inverting Power Supply From a Step-Down Regulator*](https://www.ti.com.cn/cn/lit/an/slva317b/slva317b.pdf?ts=1739696725394&ref_url=https%253A%252F%252Fitem.szlcsc.com%252F)