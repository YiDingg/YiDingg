# Using Buck Topology as an Inverting Converter

> [!Note|style:callout|label:Infor]
Initially published at 13:57 on 2025-02-16 in Lincang.

一个 Buck Topology ，通常可以简化为具有 $V_{in}$、$V_{out}$ 和 $\mathrm{GND} (V_{ref})$ 的三端（三节点）网络，并且满足 $V_{in} > V_{out} > \mathrm{GND}$。大多数情况下，我们都可以利用这样的电压关系实现负电压输出，下面就来看看如何实现。

## Configure Buck Topology to an Inverting Converter

<span style='color:red'> 在注意滤波电容位置的情况下</span>，只需简单交换 buck 中的 `GND` 和 `V_out` 节点，即可实现负电压输出，下面我们研究输入输出的范围关系。设 buck 输入电压范围被限制在 $[(V_{in,\min})_{\mathrm{buck}},\ (V_{in,\max})_{\mathrm{buck}}]$ (Absolute Maximum Ratings)，输出电压至少为 $(V_{out,\min})_{\mathrm{buck}}$ 同时 buck 输入电压至少比输出电压高 $\Delta V$。写成数学形式：
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


## Inverting Converter Demo

作为一个例子，我们用手上现有的一个 Buck 电路进行实验（如下图）。
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-16-10-54_Using Buck Topology as an Inverting Converter.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-16-17-44_Using Buck Topology as an Inverting Converter.png"/></div>

此电路使用了 [LM2596S-ADJ](https://www.ti.com/cn/lit/ds/symlink/lm2596.pdf) 作为 Buck 芯片。我们先正常接入 +10V，调整电位器，使输出电压为 +5V。然后，将 V_out 与 GND 节点互换，观察是否能够得到预期的 -5V 输出，结果如下：
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-15-51-18_Using LDO or Buck Topology as an Inverting Converter.png"/></div>

显然，输出为 -5V，这与我们的预测完全一致。此时，作为  `Inverting: +5V to -5V` 的 Buck 电路实际上（以为自己）工作在 `Buck: +10V to +5V` 的条件下。在 `Inverting: +5V to -5V` 条件下分别测试 1A ~ 3A 负载的 Load Regulation 和 Output Ripple ，所得结果与 `Buck: +10V to +5V` 时无明显差异。

## Can we use LDO as an Inverting Converter?

LDO 的输入输出电压与 Buck 电路类似，那么 LDO 是否可以实现负电压输出呢？
仿照上面的思路，我们利用一个 LDO (AMS1117-5.0) 来尝试实现负压输出，事实证明，这是不可行的。具体原因与 LDO 的工作原理有关，我们不多赘述。
<!-- <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-16-08-38_Using Buck Topology as an Inverting Converter.png"/></div> -->
<div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-16-16-12-19_Using Buck Topology as an Inverting Converter.png"/></div>



## References

- [TI Application Note: *Create an Inverting Power Supply Using a TPS6293x Buck Converter*](https://www.ti.com/lit/an/slvafh1a/slvafh1a.pdf)
- [TI Application Note: *Using the TPS6215x in an Inverting Buck-Boost Topology*](https://www.ti.com/lit/an/slva469d/slva469d.pdf)
- [TI Application Note: *Using the TPS5430 as an Inverting Buck-Boost Converter*](https://www.ti.com/lit/an/slva257a/slva257a.pdf)
- [TI Application Note: *Using the TPS54335A to Create an Inverting Power Supply*](https://e2e.ti.com/cfs-file/__key/communityserver-discussions-components-files/196/Using-the-TPS54335A-to-Create-an-Inverting-Power-Supply.pdf)
- [TI Application Note: *Creating an Inverting Power Supply Using a Synchronous Step-Down Regulator*](https://www.ti.com/lit/an/slva458b/slva458b.pdf)
- [TI Application Note: *Create an Inverting Power Supply From a Step-Down Regulator*](https://www.ti.com.cn/cn/lit/an/slva317b/slva317b.pdf?ts=1739696725394&ref_url=https%253A%252F%252Fitem.szlcsc.com%252F)