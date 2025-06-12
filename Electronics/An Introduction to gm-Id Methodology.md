# An Introduction to gm-Id Methodology

> [!Note|style:callout|label:Infor]
> Initially published at 22:14 on 2025-06-05 in Beijing.

## gm-Id Methodology


### Design Parameters

在我们的 gm-Id 方法中，三个关键设计变量是 $\frac{g_m}{I_D}$, $\frac{W}{L}$ 和 $L$。而最为关键的图像便是 $(x,\ y) = (\frac{g_m}{I_D},\ I_{nor})$, 其中 $I_{nor} = \frac{I_D}{\left(\frac{W}{L}\right)}$ 称为 normalized current.

**<span style='color:red'> 注意，我们本文所讨论的 gm-Id 方法忽略了 body-effect 的影响，也就是默认不存在 (或可以忽略) body-effect. </span>**

### Physical Significance

作为 gm-Id 方法的最关键变量，$\frac{g_m}{I_D}$ 有没有什么具体的物理意义呢？其实是有的：

$$
\begin{gather}
\frac{g_m}{I_D} = \frac{1}{I_D}\, g_m = frac{1}{I_D} \frac{\partial I_D }{\partial V_{GS} } = \frac{\partial (\ln I_D) }{\partial V_{GS} } = \frac{\partial \left[\ln \frac{I_D}{(W/L)}\right] }{\partial V_{GS} }
\end{gather}
$$

引用论文 [this paper](https://people.engr.tamu.edu/spalermo/ecen474/gm_ID_methodology_silveira_jssc_1996.pdf) 的原话说就是：
>This derivative is maximum in the weak inversion region where the ID dependence versus VG is exponential while it is quadratic in strong inversion, becoming almost linear deeply in strong inversion because of the velocity saturation. The maximum is equal to l /(nU~) in the weakest inversion where n is the subthreshold slope factor and UT the thermal voltage. Therefore, the gm/Id ratio is also an indicator of the mode of operation of the transistor. 


### Key Hypotheses 

对于一般性的设计 (general designs), gm/Id 的范围通常在 5 ~ 15 (or 3 ~ 18)。在此范围下，如果晶体管的特性满足如下几个假设，那么我们的方法便是可行的：
- **Hypothesis 0:** 在给定 L 和 $V_{DS}$ 的情况下，$I_D$ 和 $W$ 满足非常好的正比例关系
    - 这是利用小的偏置电流定义支路上大电流的基础，也就是 finger 和 multiplication 的基础
- **Hypothesis 1:** 在合理的 $\frac{W}{L}$ 范围内 (通常 from 10 to 100, 甚至 from 2 to 1000), $\frac{g_m}{I_D}$ 关于 $V_{GS}$ 严格单调递减，具有良好的双射关系 (一一对应)，且基本不受其它各种参数影响
    - 这为 gm-Id 方法的第一个关键变量 $\frac{g_m}{I_D}$ 提供了基础
    - 事实上，$\frac{g_m}{I_D}$ 在 Vgs < 0 时一般是不单调。但是，目前绝大多数的 CMOS 工艺，$(V_{GS}, \frac{g_m}{I_D})$ 曲线在 $V_{GS} > 0$ 时都是严格单调的，此时的 $\frac{g_m}{I_D}$ 范围大约是 $(1,\ 30)$, 更别说我们这里只考察 $\frac{g_m}{I_D} < 18$ 的区间
- **Hypothesis 2:** $\frac{I_D}{\left(\frac{W}{L}\right)}$ 主要由 $\frac{g_m}{I_D}$ 决定，基本不受 $L$ 和 $V_{DS}$ 参数影响
    - 这为 gm-Id 方法的第二个关键变量 $I_D$ (或 $\frac{W}{L}$) 提供了基础
    - 是将 $I_D$ 和 $\frac{W}{L}$ 联系起来的根本条件。举个例子，当 $\frac{g_m}{I_D}$ 给定时，无论其它参数怎样，我们都可以得出 $\frac{I_D}{\left(\frac{W}{L}\right)}$ 的值，此时只要再敲定电流 $I_D$，便可以计算出 $\frac{W}{L}$

### Performance Parameters

下面是一些我们在设计中可能关心的（晶体管级）性能参数：

<div class='center'>

| Name | Symbol | Note |
|:-:|:-:|:-:|
 | transconductance | $g_m$ | 最重要的参数之一，不多说 |
 | self gain (intrinsic gain) | $g_m r_O$ | 最重要的参数之一，不多说 |
 | output resistance (early resistance) | $r_O$ | 通常没有前两个那么重要，因为能显著影响 $r_O$ 的参数太多，还有很多二级效应，对 $r_O$ 的精确预估比较困难，所以常常被设计者“抛弃” |
 | transient frequency | $f_T$ | 表征 MOS 速度 (或寄生电容大小) 的关键变量, 一般可以用 $f_T \approx \frac{g_m}{2 \pi (C_{gs} + C_{gd})}$ 近似计算 |
 | frequency efficiency | $\frac{f_T}{I_D}$ | 表明单位电流可以带来多少的 $f_T$，在低功耗高速设计中这个参数需要比较大。其实放大器也有类似的概念叫 "GBW efficiency", 定义为 $\frac{GBW}{I_D}$，并且 $\frac{GBW}{I_D} = \frac{GBW}{g_m \cdot \frac{I_D}{g_m}} = \frac{\frac{f_T}{FO}}{\frac{4 k T \gamma}{\overline{v_{n}^2}}} \cdot \frac{g_m}{I_D} \propto f_T \cdot \frac{g_m}{I_D}$，这个乘积通常在 gm/Id 中等偏低的时候取最大值 (5 ~ 10), 并且随着 L 的降低而升高 (见 [this slide](https://www.ieeetoronto.ca/wp-content/uploads/2020/06/20160226toronto_sscs.pdf) page 32) |
 |  |  |  |
 |  |  |  |
 |  |  |  |
 |  |  |  |

</div>

### Design Tips

- $V_{ds}$ 对 $g_m$ 一般没有什么影响，但对 $r_O$ 影响很大，两者在一定电压范围内成正相关 (通常整个 1.8 V 都可视为正相关)

## Hypotheses Verifications



下面，我们就以台积电 180nm CMOS 工艺库 `tsmc18rf` 为例，考察其工艺库中的 NMOS 模型 `nmos2v` 是否满足上面的几个假设。

### Hypothesis 0 (Verified)

见 **Hypothesis 1** 验证结论的第一条。

### Hypothesis 1 (Verified)

<!-- 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-21-03-10_An Introduction to gm-Id Methodology.png"/></div>

上面涵盖的范围太宽了，看起来并没有那么好，我们不妨固定 W = 18u, 扫描 L from 0.18u to 1.8u 看看情况：
 -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-21-09-58_An Introduction to gm-Id Methodology.png"/></div> -->
- Hypothesis 1: $\frac{g_m}{I_D}$ 关于 $V_{GS}$ 严格单调递减，具有良好的一一对应关系，且基本不受其它各种参数影响

<span style='color:red'> 若无特别说明，下面所有 $(x,\ y) = (\frac{g_m}{I_D},\ V_{GS})$ 的曲线都已检查过，确保 $\frac{g_m}{I_D} \in (5,\ 15)$ 时晶体管处于 region 2 (饱和区) </span>

给定 Vds = 450mV 和 W = 18u, 改变沟道长度 L from 0.18u to 1.8u 的同时, Vgs 从 0 V 扫描至 1.8 V, 作出 $(x,\ y) = (\frac{g_m}{I_D},\ V_{GS})$ 曲线，
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-21-15-05_An Introduction to gm-Id Methodology.png"/></div>

非常好的一一对应关系！可能有读者会怀疑“是不是这个 width 恰好有这么棒的映射”，我们不妨换个 W = 90u, 扫描 L from 0.18u to 1.8u 看看：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-21-12-32_An Introduction to gm-Id Methodology.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-21-14-17_An Introduction to gm-Id Methodology.png"/></div>


也是非常好的！事实上，对于任意的 W 和 L, 只要 W/L 的值比较合理 (10 ~ 100) 甚至 (2 ~ 1000), 都可以得到类似的结果。下面是 L from 0.18u to 1.8u, W/L 范围分别为 10 ~ 100 和 2 ~ 1000 的扫描结果，都算有比较好的“双射关系（一一对应）”：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-21-28-03_An Introduction to gm-Id Methodology.png"/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-22-17-15_An Introduction to gm-Id Methodology.png"/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-22-18-19_An Introduction to gm-Id Methodology.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-22-19-21_An Introduction to gm-Id Methodology.png"/></div>

需要说明的是，扫描 2 ~ 1000 时并没有数据扫全，因为 L 虽然满足了范围限制 (0.18u, 20.00 u), 但是部分 W 超出了 (0.22u, 900.00 u) 的范围限制。

将 Vds 从 450mV 改为 Vds = 225mV 和 900mV, 重新扫描上面图像，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-21-53-50_An Introduction to gm-Id Methodology.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-21-57-03_An Introduction to gm-Id Methodology.png"/></div>

其中 region 值的含义是： 0 (off), 1 (triode), 2 (saturation), 3 (subthreshold), 4 (damaged). 综合上面的几个图像，我们可以说已经验证了 Hypothesis 1.




### Hypothesis 2 (Verified)

- Hypothesis 2: $\frac{I_D}{\left(\frac{W}{L}\right)}$ 主要由 $\frac{g_m}{I_D}$ 决定，基本不受 $L$ 和 $V_{DS}$ 参数影响


类似的验证思路，我们令 Vds = 450 mV, 扫描 L from <span style='color:red'> 0.36u </span> to 3.6u, W/L from 5 ~ 250 的结果。 L 为最小沟道长度 0.18u 时，其特性通常有比较明显的偏移，我们在设计时也通常不用它，于是这里不做仿真，直接从 0.36 u 开始。


<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-22-40-34_An Introduction to gm-Id Methodology.png"/></div>
 -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-22-50-04_An Introduction to gm-Id Methodology.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-22-54-30_An Introduction to gm-Id Methodology.png"/></div>

上面两个图可以推出以下结论：
- 在所有的 $\frac{g_m}{I_D}$ 范围内，长宽比 $\frac{W}{L}$ 的变化完全不会影响 $\frac{I_D}{\left(\frac{W}{L}\right)}$ 的值 <span style='color:red'> (这相当于验证了 Hypothesis 0) </span>
- 在 $\frac{g_m}{I_D}$ 稍低的区域 (5 ~ 10), $\frac{I_D}{\left(\frac{W}{L}\right)}$ 的值会随着 $L$ 的增加而略微增加，但这种影响在 $L$ 足够大 (达到 $5 L_0 = 0.9 \ \mathrm{u}$) 时便可以忽略了
- 在 $\frac{g_m}{I_D}$ 稍高的区域 (10 ~ 15), $L$ 对 $\frac{I_D}{\left(\frac{W}{L}\right)}$ 的影响可以忽略了
- $\frac{I_D}{\left(\frac{W}{L}\right)}$ 的值会随着 $V_{ds}$ 的增大而略微增大，但是这种影响比较小，通常也可以忽略

综合上面几条结论， Hypothesis 2 和 Hypothesis 0 得到了验证。

<!-- 第一个图在 $\frac{g_m}{I_D} = 5$ 附近出现了较大的误差，是因为这时沟道长度较短的晶体管处在较深的 strong inversion, 其 $r_O$ 非常小的同时 
 -->




## gm-Id Design Steps


gm-Id 方法的一般设计流程如下：

0. 根据管子的工作环境，选择合适的 Vds 进行后续仿真 (比如 $\frac{1}{2}V_{DD}$ 或者 $\frac{1}{4}V_{DD}$)
1. 依据最关键性能指标确定晶体管 $\frac{g_m}{I_D}$ 的值或范围
2. 在 $(x,\ y) = (\frac{g_m}{I_D}, \ I_{nor})$ 曲线中，找到此 $\frac{g_m}{I_D}$ 对应的 $I_{nor}$ 值 (这一步可能需要考虑 length 是较大还是较小)
3. 根据 $I_D$ 和 $I_{nor} = \frac{I_D}{\left(\frac{W}{L}\right)}$ 求出长宽比 $\frac{W}{L}$
4. 根据其它性能指标，选择合适的 $L$
5. 验证晶体管的静态工作点是否满足指标要求
    - 若不满足指标或差距较大，返回第 1 步重新选择 $\frac{g_m}{I_D}$
    - 若已达到指标要求，则完成了此晶体管的设计



## gm-Id Design Examples

在一般性的设计中，晶体管基本可以分为以下几类：

- Input transistor: 输入晶体管，$g_m$ 是最关键的参数，通常对 $r_O$ 也有要求 (gm/Id 多为 11 ~ 14)
- Current transistor: 用作电流源的晶体管，匹配性通常是最关键参数，但 $V_{dsat}$ 和 $r_O$ 也非常关键，并且常常希望 $g_m$ 小一些、管子速度快一些 (gm/Id 多为 7 ~ 10)
- Load transistor: 用作负载的晶体管，$r_O$ 和 $f_T$ 是最关键参数，常希望高 rout 的同时速度快一些 (gm/Id 多为 7 ~ 11)
- Gain transistor: 用作增益的晶体管，$g_mr_O$ 是最关键参数，通常对两者没有单独的要求 (gm/Id 多为 12 ~ 15)

### E1: Input Transistor

**要求：为 nmos-input differential folded-cascode stage 设计输入管，满足指标 $C_L = 5\ \mathrm{pF},\ \mathrm{GBW_f} = 50 \ \mathrm{MHz},\ \mathrm{SR} = 50 \ \mathrm{V/us}$ 且 $r_O > 200 \ \mathrm{k}\Omega$, $\mathrm{VDD} = 1.8 \ \mathrm{V}$**

$$
\begin{gather}
\mathrm{SR} = \frac{2 I_D}{C_L},\quad \mathrm{GBW_f} = \frac{g_m}{2 \pi C_L} \Longrightarrow 
\begin{cases}
\frac{g_m}{I_D} = 4 \pi \cdot \frac{\mathrm{GBW_f}}{\mathrm{SR}} = 12.57
\\
g_m = 2\pi C_L \cdot \mathrm{GBW_f} = 1.5708 \ \mathrm{mS}
\\
I_D = \frac{1}{2}C_L \cdot \mathrm{SR} = 125 \ \mathrm{uA}
\end{cases}
\end{gather}
$$

输入管 (NMOS) 的 gm/Id = 12.57 已经确定，且在 10 ~ 15 区间，因此 Hypothesis 2 可以符合得很好。我们先通过 $\frac{I_D}{\left(\frac{W}{L}\right)}$ 的值来确定 $\frac{W}{L}$: 作为一个 1.8 V 下的 folded-cascode, 输入管一般需要承受 $1.8 \ \mathrm{V} - 2 \times 0.3 \ \mathrm{V} = 1.2 \ \mathrm{V}$ 的 Vds, 因此不妨用 Vds = 900 mV 所得曲线来确定 $\frac{I_D}{\left(\frac{W}{L}\right)}$ 。

查看曲线可知 $\frac{g_m}{I_D} = 12.57$ 时 $\frac{I_D}{\left(\frac{W}{L}\right)} = 3.161 \ \mathrm{uA}$, 而我们的电流 $I_D = 125 \ \mathrm{uA}$, 因此有：

$$
\begin{gather}
\frac{W}{L} = \frac{I_D}{\frac{I_D}{\left(\frac{W}{L}\right)}} = \frac{125 \ \mathrm{uA}}{3.161 \ \mathrm{uA}} = 39.5444 \approx 40
\end{gather}
$$

下面只需要在 $\frac{W}{L}$ 和 $\frac{g_m}{I_D}$ 给定的情况下，根据 $r_{O}$ 来确定所需要的 $L$ 。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-23-16-53_An Introduction to gm-Id Methodology.png"/></div>

根据图像，长度 $L$ 至少需要 $2.34 \ \mathrm{um}$ 才能满足要求，不妨选择 $L = 2.5 \ \mathrm{um}$，再根据 $\frac{W}{L} \approx 40$ 得 $W = 100 \ \mathrm{um}$. 因此晶体管的参数为：

$$
\begin{gather}
\frac{g_m}{I_D} = 12.57,\textbf{(1)\ \ }  I_D = 125 \ \mathrm{uA},\quad \frac{W}{L} = \frac{100 \ \mathrm{um}}{2.5 \ \mathrm{um}}\ \ (V_{ds} = 0.9 \ \mathrm{V}) \Longrightarrow g_m = 1.5708 \ \mathrm{mS},\quad r_O = 221.7 \ \mathrm{k}\Omega
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-23-29-35_An Introduction to gm-Id Methodology.png"/></div>

可以看到，我们对 $g_m$ 的预估已经非常准确了，而 $r_O$ 也满足了要求。


### E2: Current Transistor

**为上一小节的 folded-cascode stage 设计一个 current source transistor (nmos), 满足指标 $I_D = 250 \ \mathrm{uA},\ V_{dsat} = 100 \ \mathrm{mV} $ 且 $r_O > 300 \ \mathrm{k}\Omega$.**

**<span style='color:red'> 注意这里的 current source 最小可能工作在 Vds = 200 mV 左右，由于 rout 通常与 Vds 正相关, 要使 nmos 在宽 Vds 范围内满足要求，我们可以令 Vds = 225 mV 进行仿真。 </span>**



作为一个 current source, 我们希望管子具有小的 $g_m,\ V_{dsat}$ 和大的 $r_O$。注意小的 $g_m$ 和 小的 $V_{dsat}$ 是互相矛盾的，减小 $\frac{g_m}{I_D}$ 可以降低管子的 $g_m$ 但是会使 $V_{dsat}$ 增大、$r_O$ 减小；相反，增大 $\frac{g_m}{I_D}$ 可以减小 $V_{dsat}$、增大 $r_O$, 但是匹配性会变差。因此我们需要在这之间取得平衡。

先在 $(x,\ y) = (\frac{g_m}{I_D},\ V_{dsat})$ 曲线中找到满足 Vdsat 要求的 $\frac{g_m}{I_D}$ 范围，注意 $r_{out}$ 要求很高，因此我们的 $L$ 会比较大，$\frac{g_m}{I_D}$ 也需要偏大以获得更高的 rout, 在选择 $\frac{g_m}{I_D}$ 时需考虑到这两点：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-06-23-56-04_An Introduction to gm-Id Methodology.png"/></div>

为满足 $V_{dsat}$ 要求，至少也需要 $\frac{g_m}{I_D} > 12.58$, 不妨先选择 $\frac{g_m}{I_D} = 13$ 和  $ \frac{g_m}{I_D} =14$ 两个值，看看是否能满足指标。在 normalized current 图像中确定 $I_{nor}$ 的值：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-07-00-03-54_An Introduction to gm-Id Methodology.png"/></div>

$$
\begin{gather}
\frac{g_m}{I_D} = 13 \Longrightarrow I_{nor} = 2.924 \ \mathrm{uA} \Longrightarrow \frac{W}{L} = \frac{I_D}{I_{nor}} = 85.4993
\\
\frac{g_m}{I_D} = 14 \Longrightarrow I_{nor} = 2.254 \ \mathrm{uA} \Longrightarrow \frac{W}{L} = 110.9139
\end{gather}
$$

然后就是根据 $r_O$ 来选择 $L$ 的值：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-07-00-10-15_An Introduction to gm-Id Methodology.png"/></div>

很遗憾，我们的两个 $\frac{g_m}{I_D}$ 值都不能满足要求，把 Vds 放宽到 450 mV 看看 (对前两个参数影响不大)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-07-00-14-04_An Introduction to gm-Id Methodology.png"/></div>

虽说对于 nmos-input 的 folded-cascode, Vin_CM 可以达到 VDD = 1.8 V, 此时我们正在设计的这个晶体管有 Vds = 1.8 V - 0.55 V = 1.25 V, 此时的 rout 应该会更高，但我们仍希望它在 Vin_CM 不太高时便可以达到 rout 要求。这便是 trade-off 了啊！

现在的情况是，如果我们增大管子的 $\frac{g_m}{I_D}$, 会使 $V_{dsat}$ 降低和 $r_O$ 升高，可以满足我们的设计要求，但是管子的匹配性严重下降(因为管子逐渐向 weak inversion 靠近)！ 相反，如果我们减小 $\frac{g_m}{I_D}$, 管子的匹配性显著提高，但是会使 $V_{dsat}$ 升高和 $r_O$ 降低。



<!-- 一种思路是舍弃一些 voltage 来获得足够的 rout, 另一种思路是舍弃一些 rout 来保证较好的 voltage. 考虑这个 nmos 所扮演的角色，其 rout 大小基本上只对 CMRR 有影响，对整个电路的关键参数影响不大，因此这里我们选择后者：舍弃 rout 来保证较好的 voltage. <span style='color:red'> 如果是一个与增益直接相关的 load transistor, 那么我们一般会选择前者。 </span> -->

在这个例子中，我们还是取 $\frac{g_m}{I_D} = 13$，这样即保证了较好的性能，又不会使管子匹配性太差。接下来就是选择合适的 $L$：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-07-00-23-48_An Introduction to gm-Id Methodology.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-07-00-25-39_An Introduction to gm-Id Methodology.png"/></div>

在相同的 $L$ 下，$\frac{W}{L} = 110\ \ (\frac{g_m}{I_D} = 14)$ 时不但带来了更大的 width, rout 也有所降低，因此我们并不选择它，而是选择 $\frac{W}{L} = 85.5\ \ (\frac{g_m}{I_D} = 13)$ 中的 $L = 2.7\ \mathrm{um}$。此时，晶体管的 $W = 230.85 \ \mathrm{um} \approx 230 \ \mathrm{um}$ 既不会太宽，在 450 mV 时也有 93 kOhm 的 rout, 不算太低。

因此晶体管的最终参数为：

$$
\begin{gather}
\frac{g_m}{I_D} = 13 ,\quad I_D = 250 \ \mathrm{uA},\quad \frac{W}{L} = \frac{230 \ \mathrm{um}}{2.7 \ \mathrm{um}} \Longrightarrow g_m = 3.25 \ \mathrm{mS},\quad r_O = 93.0 \ \mathrm{k}\Omega \,@\, V_{ds} = 450 \ \mathrm{mV} 
\end{gather}
$$

验证其静态工作点：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-07-00-36-13_An Introduction to gm-Id Methodology.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-07-00-36-44_An Introduction to gm-Id Methodology.png"/></div>

可以看到，按我们的方法设计得到的晶体管参数是非常精确的。

### E2: Supplementary Content

作为 Example 2 的补充内容，我们不妨也看看选择更低的 $\frac{g_m}{I_D}$ 会怎样。在 $(y,\ x) = (V_{dsat},\ \frac{g_m}{I_D})$ 图中选择 $\frac{g_m}{I_D} = 10$, 对应大约 190 mV 的 $V_{dsat}$, 并且 normalized current $\frac{I_D}{\left(\frac{W}{L}\right)} = 5.6 \ \mathrm{uA}$ @ Vds = 225mV 。于是长宽比为：

$$
\begin{gather}
a = \frac{W}{L} = \frac{I_D}{\left(\frac{I_D}{\left(\frac{W}{L}\right)}\right)} = \frac{250 \ \mathrm{uA}}{5.6 \ \mathrm{uA}} = 44.64 \approx 45
\end{gather}
$$

在 schematic 的 design variable 中令 $a = 45$, 扫描 $L$ from 0.36u to 3.6u, 得到 $(y,\ x) = (r_O,\ \frac{g_m}{I_D})$ 图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-08-16-50-49_An Introduction to gm-Id Methodology.png"/></div>

图中只有不到 $10 \ \mathrm{k}\Omega$ 的 $r_O$，并且 $L$ 的变化对其基本没有影响，看来是晶体管大多在 the edge of saturation 导致的 (认为是 linear region 也可)。于是把 $V_{ds}$ 放宽到 450 mV 再看看：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-08-16-54-12_An Introduction to gm-Id Methodology.png"/></div>

$L = 3.6 \ \mathrm{um}$ 时 $r_O = 128.8 \ \mathrm{k}\Omega$, 倒也不算很小，晶体管的最终参数确定为：

$$
\begin{gather}
\frac{g_m}{I_D} = 10 ,\quad I_D = 250 \ \mathrm{uA},\quad \frac{W}{L} = 45 =  \frac{ 162 \ \mathrm{um}}{3.6 \ \mathrm{um}} 
\\
\Longrightarrow g_m = 2.5 \ \mathrm{mS},\quad r_O = 128.8 \ \mathrm{k}\Omega \,@\, V_{ds} = 450 \ \mathrm{mV},\quad V_{dsat} = 190 \ \mathrm{mV}
\end{gather}
$$

下图是静态工作点的验证，可以看到工作点参数与我们的预期基本一致：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-08-17-01-32_An Introduction to gm-Id Methodology.png"/></div>


### E3: Load Transistor

### E4: Gain Transistor

## gm-Id Reference Data

### tsmc18rf (180nm CMOS)

- `nmos2v`: L from 0.18u to 20u, W from 0.22u to 900u
- `pmos2v`: 

#### nmos2v (Vds = 225 mV)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-08-16-40-36_An Introduction to gm-Id Methodology.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-08-16-43-16_An Introduction to gm-Id Methodology.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-08-16-44-27_An Introduction to gm-Id Methodology.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-08-17-15-28_An Introduction to gm-Id Methodology.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-08-17-20-04_An Introduction to gm-Id Methodology.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-08-17-20-36_An Introduction to gm-Id Methodology.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-08-17-26-02_An Introduction to gm-Id Methodology.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-08-17-29-13_An Introduction to gm-Id Methodology.png"/></div>

#### nmos2v (Vds = 450 mV)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-08-16-39-27_An Introduction to gm-Id Methodology.png"/></div>

#### pmos2v (Vds = 225 mV)

#### pmos2v (Vds = 450 mV)



### smic18mmrf

### smic13mmrf




## References

Methodology and theory:
- [x] [Design of MOS Amplifiers Using gm/ID Methodology](https://designers-guide.org/forum/Attachments/Gm_BY_ID_Methodology.pdf)
    - 介绍了由 $\frac{g_m}{I_D}$ 和 normalized current $\frac{I_D}{\left(\frac{W}{L}\right)}$ 作为关键变量的设计方法，并给了一个简单的 CS amplifier 设计例子，但示例讲的并不是很清楚；
    - 给出了几个图像，可以帮助理解 **“在 general design 中 (gm/Id from 5 ~ 18), $\frac{g_m}{I_D}$ 由 $V_{OV} = V_{GS} - V_{TH}$ 唯一确定，而 $\frac{I_D}{\left(\frac{W}{L}\right)}$ 又由 $\frac{g_m}{I_D}$ 唯一确定”** 的思想。也就是说，在相同的 $\frac{W}{L}$ 下，给定 $\frac{g_m}{I_D}$ 就基本上完全确定了 $\frac{I_D}{\left(\frac{W}{L}\right)}$，$L$ 在 $L_0 \sim 10\, L_0$ 之间变化时所带来的影响基本可以忽略 (需要 gm/Id from 5 ~ 18), 这里的 $L_0$ 是工艺最小沟道长度。
- [x] [Systematic Design of Analog Circuits Using Pre-Computed Lookup Tables](https://www.ieeetoronto.ca/wp-content/uploads/2020/06/20160226toronto_sscs.pdf): 这部分内容已经出版为一本书, 详见 [GitHub > bmurmann > Book-on-gm-ID-design](https://github.com/bmurmann/Book-on-gm-ID-design/tree/main) 或者 [this link](https://www.cambridge.org/core/books/systematic-design-of-analog-cmos-circuits/A07A705132E9DE52749F65EB63565CE0)
    - 提出了一种基于 pre-computed table 的方法，固定 $W$, 将 $L,\ V_{GS},\ V_{DS}$ 和 $V_{BS}$ 作为四个自变量进行仿真，得到数据，但我们关心的主要是他如何根据已有的数据来设计晶体管
    - 以 $\frac{g_m}{I_D}$, $\frac{I_D}{W}$ 和 $L$ 作为关键设计变量 (曲线)，主要是举了很多例子来说明如何用他的 table 优化放大器的速度性能 (GBW, SR, settling time 等)
- [x] [Analog Design Using gm/Id and ft Metrics](https://people.eecs.berkeley.edu/~boser/presentations/2011-12%20OTA%20gm%20Id.pdf)
    - 以 $\frac{g_m}{I_D}$, $\frac{I_D}{W}$ 和 $f_T$ 作为关键设计变量 (曲线)，在提到的几个例子中 $L$ 都取了最小值 $L_0$ 以获得较低的功耗
    - 文末总结了 design flow: determine gm from specs > pick L > pick gm/Id > determine Id and W, 若不满足指标，回到 "pick L" 或 "pick gm/Id" 一步
- [x] [Stanford University: Chapter 5 gm/ID-Based Design](https://www.wangke007.com/wp-content/uploads/2024/01/ee214b_gmid.pdf): 和 [this article](https://www.ieeetoronto.ca/wp-content/uploads/2020/06/20160226toronto_sscs.pdf) 的内容差不多
- [x] [Paper: A gm/Id based Methodology for the Design of CMOS Analog Circuits and Its Application to the Synthesis of a Silicon-on-Insulator Micropower OTA](https://people.engr.tamu.edu/spalermo/ecen474/gm_ID_methodology_silveira_jssc_1996.pdf): 早期使用 gm/Id 方法的论文，介绍了 gm/Id 的设计方法和在  Silicon-on-Insulator Micropower OTA 中的应用


## Relevant Resources

下面是与 gm-Id 相关的一些资料/论文/书籍：

- Paper: [Starting Over: gm/Id-Based MOSFET Modeling as a Basis for Modernized Analog Design Methodologies](https://www.researchgate.net/publication/228717878_Starting_Over_gmId-Based_MOSFET_Modeling_as_a_Basis_for_Modernized_Analog_Design_Methodologies)
- Paper: [gm/ID Design Considerations for Subthreshold-Based CMOS Two-Stage Operational Amplifiers](https://ieeexplore.ieee.org/document/9180576)
- Book: [The gm/ID Methodology, a sizing tool for low-voltage analog CMOS Circuits](https://link.springer.com/book/10.1007/978-0-387-47101-3)
- Book: [Systematic Design of Analog CMOS Circuits (Using Pre-Computed Lookup Tables)](https://www.cambridge.org/core/books/systematic-design-of-analog-cmos-circuits/A07A705132E9DE52749F65EB63565CE0)
- Slide: [gm/Id-Based MOSFET Modeling and Modern Analog Design](https://www.mos-ak.org/wroclaw/MOS-AK_DF.pdf)


gm-Id design examples: 
- [知乎 > (模集王小桃) 基于 gm/Id 的运放设计 (单端输出的两级运放设计)](https://zhuanlan.zhihu.com/p/18217441114)
- [知乎 > 两级运放设计过程总结-Allen](https://zhuanlan.zhihu.com/p/631329993)
- [知乎 > 5-T OTA 的设计与仿真](https://zhuanlan.zhihu.com/p/467542830)
- [知乎 > 基于 gm/Id 法的五管 OTA 的设计](https://zhuanlan.zhihu.com/p/621225975)
