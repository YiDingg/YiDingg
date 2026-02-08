# 202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 01:03 on 2025-11-16 in Beijing.
> dingyi233@mails.ucas.ac.cn

>注：本文是项目 [Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology](<Projects/Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology.md>) 的附属文档，用于全面记录 PLL 的设计/迭代/仿真/版图/后仿过程，以及最终的项目报告和相关资料等。

续前文 [202510_onc18_CPPLL_ultra_low_lower (4) Pre-Simulation, Layout Details and Post-Simulation Results](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (4) Pre-Simulation, Layout Details and Post-Simulation Results.md>), 本文档继续补充项目的相关资料和项目报告。




## 1. 修正：unit of K_VCO

今天 (2025.12.31) 才注意到，VCO model 中的 **<span style='color:red'> K_VCO 的单位应该是 rad/s/V 而不是 Hz/V </span>** , 也就是要在 Hz/V 的基础上再乘以 2π。之前的建模都是用的 Hz/V, 导致 K_VCO 只有实际值的 $\frac{1}{2\pi}$，从而得到了错误的环路参数。这也解释了为什么在接近锁定频率时 vcont 要经过很多轮才能稳定下来，本质上是环路的阻尼因子 $\zeta$ 过大的同时放电太慢 (放电时间占比过大)，从而导致环路响应过慢。

注意放电时长 $\tau_0 = 5 \times R_1 (C_1 \parallel C_2) = \frac{5 \times R_1 C_1}{1 + \frac{1}{\alpha}}$ 是主要取决于小电容 $C_2$。

之前我们的参数为 R1 = 10 MOhm, C1 = 42 pF; 经过重新仿真确定了 K_VCO_MHzV = 11.43 MHz/V (在 24*32.768 kHz 附近，对应 static vcont ≈ 440 mV)，此时的环路参数为：

$$
\begin{gather}
\begin{cases}
R_1 = 10\ \mathrm{M}\Omega,\ \ C_1 = 42\ \mathrm{pF},\ \ I_P = 20 \ \mathrm{nA}
\\
K_{VCO} = 2 \pi \times 11.43 \ \mathrm{MHz/V} = 71.84 \ \mathrm{Mrad/s/V}
\\
N = 24,\ \ f_{REF} = 32.768 \ \mathrm{kHz}
\end{cases}
\\
\Longrightarrow 
\begin{cases}
\tau_P = 0.42 \ \mathrm{ms},\ \ \zeta = 3.1625 \\
\mathrm{ratio}_{\tau} = \frac{\tau_0}{T_{ref}} = 5.2933,\ \ \mathrm{ratio}_{BW} = \frac{f_{in}}{f_{BW}} = 2.11 \\
\mathrm{PM} = 89.94^\circ,\ \ f_{UGF} = 363.8 \ \mathrm{kHz},\ \ f_{BW} = 15.54 \ \mathrm{kHz}
\end{cases}
\end{gather}
$$

先将 C1 改为 30 pF (alpha = 1/12) 保持不变，不同 R1 下的阻尼因子和仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-31-02-18-05_临时文件.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-31-02-15-24_临时文件.png"/></div>

第一张图是 vcp 电压波形，能够很好地体现 zeta 对系统响应的影响；第二张图这是 vcont 电压波形，体现了 ratio_tau 对系统响应的影响，随着 R1*C2 增大，所需放电时间变长，无法在一个周期内完成放电，导致 vcont 出现锯齿波纹。



## 2. Noise Modeling and Prediction

由于报告中需要简单交代电路设计思路，强迫症迫使我们完成锁相环的完整噪声建模和预测，也就是依据各模块噪声源及其噪声传函，对 CP-PLL 总输出相噪进行建模和预测，与仿真结果对比。

理论建模详见文章：[Phase Noise Modeling and Prediction of CP-PLL](<AnalogIC/Phase Noise Modeling and Prediction of CP-PLL.md>)，这里直接给出预测结果：

``` bash
k = 1.381e-23;
T = 300;
gamma = 1;
gmId = 5;
gmId_VCON = 3;
gmId_VCOP = 3;
gmId_CPN = 3; gmId_CPP = 3; 

I_B = 50e-09;
I_D = 1e-06;
D_pd = 8e-09 * f_in;
D_pulse = 0.01;
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-05-11-10-36_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

上图看出预测误差和着实有些大。为方便对比，再给出 post-simulation 中的仿真结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-05-10-29-37_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-05-10-29-27_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>


## 3. pre-layout simulation results

**<span style='color:red'> 若无特别说明，下面均为 PLL 与 digital LDO 联合仿真，LDO 的输出 VDD_1V25 作为 PLL 供电，且不在 VDD_1V25 上额外添加白噪声 (但仍可调节 fnoise_max 来控制仿真步长)。 </span>**


### 3.1 digital LDO 

在开始正式仿真之前，我们需要先对数字 LDO 进行前仿以确保其性能满足要求，仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-05-19-56-15_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

图中可以看到，相比于我们锁相环 PVT 覆盖范围 (-20° ~ 80°C @ TT/SS/FF)，需求方提供的数字 LDO 覆盖范围稍小一些，无法覆盖 80°C @ TT 和 60°C ~ 80°C @ FF 工艺角  (pre-sim)。

**举个例子，在 (FF, 80°C) 工艺角下，数字 LDO 输出电压明显偏高，平均值达到 1.45 V 左右 (如下图)，远高于预期 1.25 V，这可能会导致锁相环功率异常升高。若要进一步加强设计可靠性，进而提高产品良率，需要需求方这边自行对数字 LDO 进行优化。**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-05-21-10-56_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>




### 3.2 all-selection


下面我们就可进入正式的锁相环前仿环节。 **<span style='color:red'> 若无特别说明，后续内容均默认为联合仿真，也即数字 LDO 的输出电压 (nominal 1.25 V) 作为 PLL 供电电压。 </span>**

在 (TT, 27°C) 工艺角下，保持其它参数为合适值不变，改变 PLL output setting 中的 `SL<1:0>`, 得到 `CK_OUT` 的不同输出频率，详细设置和前仿结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-01-54-35_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-15-48-32_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

下面是 VCO 实际控制电压 (VDD - Vcont) 的波形情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-15-59-01_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

可以看到， PLL 在不同分频设置下均能正常锁定和输出，输出频率符合预期，时钟抖动也满足要求。



至于为什么 allSL_0 (output freq. = X03) 和 allSL_3 (output freq. = X24) 下的 cycle jitter 和 edge jitter 有明显上升，我们也在之前就提过：是数字 LDO 输出 1.25 V 供电突变 (给输出端电容充电) 导致的，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-05-20-50-30_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

如果不考虑 VDD 供电突变这一段，锁相环两路时钟输出 `CK_ADC` 和 `CK_OUT` 的 rms cycle jitter (Jc_rms) 和 rms edge jitter (Je_rms) 均非常低，都满足 Jc_rms < Je_rms < 30ns，符合预期要求。即便是不忽略 freq. ripple, 由此计算所得两路输出 `CK_ADC` 和 `CK_OUT` 的 Jc_rms 也均小于 50 ns，仍然满足 100 ns 的指标要求。


>有关 VDD ripple 导致 freq. ripple 进而影响锁相环性能的问题，我们之前在另一篇文档详细讨论过：[202510_onc18_CPPLL_ultra_low_lower (docs-2) 2025.12.19 电源上升纹波导致的输出频率波动问题](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (docs-2) 2025.12.19 电源上升纹波导致的输出频率波动问题.md>)




### 3.2 all-load

在 (TT, 27°C) 工艺角下，保持其它参数为合适值后不变，改变 PLL 输出负载情况 (包括负载电容和负载漏电流) 进行仿真，具体负载设置和仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-13-43-33_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-20-14-43_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-20-18-31_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>


`EN_BUF = 0` 时，VDD ripple 直接间隔较大 (> 30 ms)，在数十毫秒内都无突变，几乎不会对 PLL 输出频率造成扰动；但是当 `EN_BUF = 1` 时，电流消耗较大 (30 uA @ 20 pF per channel)，VDD ripple 间隔缩小到毫秒级 (约 2.5 ms)，PLL 输出频率受到频繁扰动，导致从统计角度计算得到的时钟抖动明显升高。

不过，升高归升高，即便频繁受到扰动，输出时钟的 Jc_rms (rms cycle jitter) 仍小于 100 ns，满足指标要求。

根据图中数据，单独把典型工艺角和典型负载条件下的锁相环性能列出，方便参考：

<div class='center'>

| Parameter | Nominal | Spec. |
|:-:|:-:|:-:|
 | IDD (total current consumption) <br> @ 40 fF (per channel) | 332.9 nA | < 500 nA <br> @ no load |
 | Jc_rms_ADC (rms cycle jitter of CK_ADC) | 20.45 ns | < 100 ns |
 | Je_rms_ADC (rms edge  jitter of CK_ADC) | 33.06 ns | NA |
 | Jc_rms_OUT (rms cycle jitter of CK_OUT) | 4.334 ns | NA |
 | Je_rms_OUT (rms edge  jitter of CK_OUT) | 32.07 ns | NA |

</div>



### 3.3 all-corner

上面提到过，需求方提供的这个数字电源，在 (FF, 80°C) 工艺角下出现明显问题，输出电压稳定在了 1.45 V 左右，远高于预期 1.25 V，导致锁相环功率上升到约 850 nA (pre-sim)，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-02-21-21-00_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

于是，我们先利用自行构建的 noisy voltage supply 替代数字 LDO，在 -20°C ~ 80°C 的所有 PVT 下对 PLL 进行 pre-simulation，详细设置和前仿结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-01-41-08_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-07-00-15-29_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

上图看出，锁相环在所有 PVT (-20°C ~ 80°C, 1.25 V ~ 1.30 V, TT/SS/FF) 下均能正常锁定和输出。验证没有问题后，再缩小 PVT 范围并使用数字 LDO 进行联合仿真。将温度范围缩小到 0°C ~ 50°C 进行联合前仿，也即 {0°C, 10°C, 20°C, 30°C, 40°C, 50°C} @ TT/SS/FF，详细设置和前仿结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-01-48-22_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-16-08-09_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

图中可以看到，在 0 °C ~ 50°C @ TT/SS/FF 工艺角下，PLL 均能正常锁定和输出，输出频率符合预期，功耗和时钟抖动也满足要求。具体数据为：


<div class='center'>

| Parameter | Nominal | Min | Max | Spec. |
|:-:|:-:|:-:|:-:|:-:|
 | IDD (total current consumption) <br> @ 40 fF (per channel)  | 332.9 nA | 329.3 nA | 417.8 nA | < 500 nA <br> @ no load |
 | Jc_rms_ADC (rms cycle jitter of CK_ADC) | 20.45 ns | 16.23 ns | 28.83 ns | < 100 ns |
 | Jc_rms_OUT (rms cycle jitter of CK_OUT) | 3.100 ns | 2.726 ns | 4.225 ns | NA |

</div>


## 4. pre-layout simulation report

将上一小节的内容，补充上接口说明、电路设计说明、top-level 原理图和 testbench 原理图等等，最终整理成报告形式。由于内容较长，我们就不复制到这里来了，详见附属文档 (前仿报告)：[202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.md>)。



## 5. 202510_PLL_withDigitalLDO_v1 (202510_PLL_v3)

### 5.1 big BUF to level shifter

一方面，我们需要将 digital LDO 和 PLL 合并到一个 cell；另一方面，前仿报告给甲方那边之后，甲方又提出 **"不需要 big BUF 将输出负载能力提升到 20 pF，而是在 `EN_BUF = 1` 时直接将输出从 1.25V-level 通过 level shifter 转到 vbat-level (3.3V)"** ，无奈只能重新修改我们的输出缓冲：将原来的 big BUF 改为 level shifter (1.25 V to vbat)，这样 `CK_ADC_BUF` 和 `CK_OUT_BUF` 就是 vbat-level 的时钟输出。 

而且我们需要把数字 LDO 和我们的模拟 PLL 拼到一个 cell 中，这里遇到了 `vss!` 等全局网络如何连接的问题，或许可以像数字标准库中一样处理，也就是把数字模块中的 `vss_inherit` 模块直接复制过来？

检查发现需求方提供的 level shifter (1.25 V to vbat) 有问题，没法把 0 ~ 1.25 V 的时钟信号正常转到 vbat 电压域，似乎是因为输入端用的是 5v 器件，阈值电压过高导致的？不不不不，不是 level shifter 有问题，是这个 level shifter 不能带 20 pF 这么大的负载，导致上升太慢 (786 kHz 只能上升几百 mV)，于是将 CL_PAD 都改为 10 fF 进行仿真。

**注意 `CK_ADC_BUF` 和 `CK_OUT_BUF` 未经过超大缓冲器来提升带负载能力，驱动能力仍在 fF 级，不能直接带动 20 pF 负载。** 若要将其接到 PAD 用作测试，需要甲方这边自行添加较大的缓冲器 BUF (如果 PAD 前已经内置了 BUF 则无此问题)。



修改后的原理图如下：

<div class='center'>

| schematic of `202510_PLL_withDigitalLDO` <br> (将 LDO 与 PLL 合并到一个 cell，PLl 使用的是 `v3`) | schematic of `202510_PLL_BUF_output_v2` <br> (`PLL_v3` 中使用的 BUF cell, big BUF 换为了 level shifter) |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-10-17-19-53_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-10-17-19-46_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> |


</div>


### 5.2 pre-simulation verification

全面的仿真在前文已经有了，我们这里只需简单验证一下使用 level shifter 后系统能否正常工作 (保持性能不变)。仿真设置和前仿结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-10-16-34-51_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-10-16-48-06_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>



### 5.3 tran time adjustment

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-10-15-26-11_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

由上图，保持 `delay_I_pulse = 260 ms` 不变，将 `width_I_pulse` 从 100 ms 改为 66 ms (326 ms 停止), 使 TT/FF/SS @ 27°C 下的瞬态仿真遇不到 VDD 突变，以获得更准确的时钟抖动数据。

## 6. Pre-Simulation Report

2026.01.10 18:43 交付了原理图库与前仿报告，这里记录一下 "一键导出工艺库" 的小技巧，参考自文章 [写给模拟初级工程师的几个 Virtuoso 高效率技巧（一） - 知乎](https://zhuanlan.zhihu.com/p/370246510)：
- 右键选中 top cell (或者 top testbench) > 点击 copy
- 设置好到新的 lib name，建议在原 lib name 后面加上 `__EX_20260110` 以表示在 2026.01.10 导出 (export)
- 勾选 `copy Hierarchical` (skip analoglib 这些基础库和 pdk 工艺库)
- 勾选 `update instance of Entry library`
- 点击导出，这样新的 library 里就包含所有涉及到的的 cell 了，把这个 library 提交给项目管理者，他就再也不会找你麻烦。




## 7. PLL_v3 layout details

之前将 big BUF 改为了 level shifter, 所以需要更新一下锁相环的版图，分别提取 digital LDO 和 PLL 的寄生网表进行单独后仿和联合后仿，最后把数字 LDO 和 PLL 的版图拼一下，简单后仿验证一下，就可以准备交付了。

在拼 cell 的过程中，我们需要把 PLL 的 `GND` 与数字全局地 `vss!` 连接起来，最终拼出来的 cell 就不具有 `VSS` 端口。


先把新的 BUF (BUF_v2, 其内 big BUF 换为了 level shifter) 版图做好，然后更新 PLL_v3 的版图 (更换 BUF cell)，最后把数字 LDO 和 PLL 拼到一起，得到最终的 `202510_PLL_withDigitalLDO_v1` 版图：

<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | `202510_PLL_levelShifter_1V25_to_vbat` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-26-00-25-55_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | `202510_PLL_levelShifter_1V25_to_vbat` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-26-00-25-06_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> |  DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-26-00-23-19_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> |
 | `202510_PLL_BUF_output_v2_01092135` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-26-02-33-50_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | `202510_PLL_BUF_output_v2_01092135` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-26-02-33-36_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-26-02-32-59_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> |
 | `202510_PLL_v3_01092139` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-26-15-01-29_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | `202510_PLL_v3_01092139` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-26-15-01-14_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-26-14-59-59_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> |
 | `202510_PLL_withDigitalLDO_v1_01101649` 原理图  | `202510_PLL_withDigitalLDO_v1_01101649` 版图  | DRC/LVS 结果  |

</div>

最后拼 cell 时发现需求方提供的 LDO 是 m4top，而我们的是 m5top, 是谁的错了？




## 8. M4 as the Top Metal? (这是一个乌龙事件，最终还是 M5 作顶层)

### 8.1 change m5top to m4top

**<span style='color:red'> 2026.01.27 00:13 在拼 LDO 和 PLL 版图时，发现我们错将 M5 设置为了顶层金属 (应该是 M4 作顶层)！ </span>**  天啊。本来都想着终于要交付了，结果发现这个错误，好多东西都要重新改：
- LPF 的 mim 电容之前设置的是 m5top (用到 m4/m5 两层)，现在要改成 m4top (用到 m3/m4 两层)
- 其它模块的话，之前最高只用到 m3 (没有用到 m4)，倒不需要修改，算是不幸中的万幸了
- 本来其它模块用 M1 ~ M3，然后 LPF 用 M4 ~ M5，所以各模块能放在 LPF 下面；现在 LPF 用 M3 ~ M4，就没法把其他模块都放在 LPF 下面了，只能单独拿出来放。

总的来讲，需要做如下修改：
- `LPF_v1` 换为 `LPF_v2`，主要是修改其中的 mim 电容为 m4top, **注意确认电容前后参数是否不变**
- `202510_PLL_v3` 换为 `202510_PLL_v4`，更换新的 `LPF_v2` 后重新进行顶层走线

下图验证了更改顶层金属前后，`cmimhc` 电容参数并未发生变化：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-27-00-34-47_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

### 8.2 和需求方确认了仍是 M5 作顶层

经过导师和需求方那边核实，最终确认仍是 M5 作顶层金属，他们一开始用的 m4top, 后面又改成了 m5top，但提供的 LDO 是旧版 (m4top)。估计是之前和导师打电话讨论时说到改为了 m5top，所以我这边才改成了 m5 作顶层，我还奇怪为啥聊天记录里一直都是 m4top. 

于是，我们还是继续使用之前的 `202510_PLL_v3` 版图，不需要更改顶层金属了，松了一口气。待需求方提供新版 LDO (m5top) 后，我们再进行最终的版图拼接和后仿验证即可。




## 9. PLL testbench explanation

之前交付的原理图库和前仿报告中，没有对 testbench 使用方法和参数设置进行详细说明，后来在前仿报告 [202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.md>) 中作了补充，又顺便单独整理出来方便差异，详见附属文档：[202510_onc18_CPPLL_ultra_low_lower (docs-4) 2026.01.27 锁相环 testbench 使用说明 PLL testbench explanation](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (docs-4) 2026.01.27 锁相环 testbench 使用说明 PLL testbench explanation.md>)。





## 10. Final Layout and Post-Simulation

### 10.1 final layout

需求方提供了更新后的 digital LDO (m5top)，现在终于可以把 PLL 和 LDO 拼到一起，并进行最终的后仿验证。

LVS 时发现需求方这边更新后的 digital LDO, 原理图中表示寄生参数的 `db2bisodnw` 等元件参数不对，需要设置为 LVS 中 layout 对应的正确值，我们这边手动修改了一下以确保 LVS 能完整通过。

最终拼接所得的版图如下：

<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | `CJ1_LJH_m5t08_layout > vplus_gen_top` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-29-15-32-42_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | `CJ1_LJH_m5t08_layout > vplus_gen_top` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-29-15-32-25_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-29-15-31-11_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> |
 | `202510_PLL_v3_01092139` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-26-15-01-29_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | `202510_PLL_v3_01092139` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-26-15-01-14_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-26-14-59-59_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> |
 | `202510_PLL_withDigitalLDO_v1_01101649` 原理图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-29-14-28-27_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | `202510_PLL_withDigitalLDO_v1_01101649` 版图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-29-14-50-33_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | DRC/LVS 结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-29-14-47-56_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> |

</div>

现在进入最后的后仿环节，验证 PLL 在后仿情况下的性能，以及数字 LDO 和 PLL 联合后仿的性能。

### 10.2 all-SL (post-sim)

all-SL 仿真条件设置如下：
- (1) {1-point} Testbench: `TB_PLL`
- (2) {1-point} Netlist: calibre of `202510_PLL_v3`
- (3) {1-point} VDD Ripple/Noise and Output Impedance:
    - (rout_VDD, cout_VDD) = (20 Ohm, 50 pF) with rise time = 5 cycles of REF (152.6 us)
    - 10 mVamp triangular ripple @ 0.2 kHz (rise time = 5%, fall time = 95%)
    - 2 mVrms white noise @ fnoise_max = 10 MHz
- **(4) {4-point} Output Frequency:**
    - (SL1, SL0) = (0, 0)
    - (SL1, SL0) = (0, 1)
    - (SL1, SL0) = (1, 0)
    - (SL1, SL0) = (1, 1)
- (5) {1-point} level shifter control: EN_BUF = 0
- (6) {1-point} Load Condition: EN_BUF = 0, load = (40 fF, 40 fF, 40 fF, 40 fF)
- (7) {1-point} Trimming Setting: T⟨4:0⟩ = ⟨01111⟩_2 = ⟨15⟩_10
- (8) {1-point} PVT Corner: (TT,  27°C, 1.25 V)
- (9) {1-point} Simulation Mode: Spectre X (preset = CX) with 0 ~ 10 MHz transient noise
- (10) {1-point} Simulation Time: transient time = 15 ms (typical locking time < 3 ms)

all-SL 后仿结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-28-21-11-19_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

### 10.3 all-load (post-sim)

all-load 仿真条件设置如下：
- (1) {1-point} Testbench: `TB_PLL`
- (2) {1-point} Netlist: calibre of `202510_PLL_v3`
- (3) {1-point} VDD Ripple/Noise and Output Impedance:
    - (rout_VDD, cout_VDD) = (20 Ohm, 50 pF) with rise time = 5 cycles of REF (152.6 us)
    - 10 mVamp triangular ripple @ 0.2 kHz (rise time = 5%, fall time = 95%)
    - 2 mVrms white noise @ fnoise_max = 10 MHz
- (4) {1-point} Output Frequency: (SL1, SL0) = (0, 0)
- (5) {1-point} level shifter control: EN_BUF = 0
- **(6) {8-point} Load Condition:**
    - EN_BUF = 0, load = (0.1 fF, 0.1 fF, 40 fF, 40 fF) 
    - EN_BUF = 0, load = (40 fF, 40 fF, 40 fF, 40 fF)
    - EN_BUF = 0, load = (40 fF, 40 fF, 40 fF, 40 fF) with 1 nA/ch leakage current at `CK_ADC` and `CK_OUT`
    - EN_BUF = 0, load = (40 fF, 40 fF, 40 fF, 40 fF) with 10 nA/ch leakage current at `CK_ADC` and `CK_OUT`
    - EN_BUF = 0, load = (40 fF, 40 fF, 40 fF, 40 fF) with 100 nA/ch leakage current at `CK_ADC` and `CK_OUT`
    - EN_BUF = 1, load = (40 fF, 40 fF, 40 fF, 40 fF)
    - EN_BUF = 1, load = (100 fF, 100 fF, 40 fF, 40 fF)
    - EN_BUF = 1, load = (200 fF, 200 fF, 40 fF, 40 fF)
- (7) {1-point} Trimming Setting: T⟨4:0⟩ = ⟨01111⟩_2 = ⟨15⟩_10
- (8) {1-point} PVT Corner: (TT,  27°C, 1.25 V)
- (9) {1-point} Simulation Mode: Spectre X (preset = CX) with 0 ~ 10 MHz transient noise
- (10) {1-point} Simulation Time: transient time = 15 ms (typical locking time < 3 ms)

all-load 后仿结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-28-21-10-17_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

### 10.4 all-corner (post-sim)

all-corner 仿真条件设置如下：
- (1) {1-point} Testbench: `TB_PLL`
- (2) {1-point} Netlist: calibre of `202510_PLL_v3`
- (3) {1-point} VDD Ripple/Noise and Output Impedance:
    - (rout_VDD, cout_VDD) = (20 Ohm, 50 pF) with rise time = 5 cycles of REF (152.6 us)
    - 10 mVamp triangular ripple @ 0.2 kHz (rise time = 5%, fall time = 95%)
    - 2 mVrms white noise @ fnoise_max = 10 MHz
- (4) {1-point} Output Frequency: (SL1, SL0) = (0, 0)
- (5) {1-point} level shifter control: EN_BUF = 0
- (6) {1-point} Load Condition: EN_BUF = 0, load = (40 fF, 40 fF, 40 fF, 40 fF)
- (7) {1-point} Trimming Setting: T⟨4:0⟩ = ⟨01111⟩_2 = ⟨15⟩_10
- **(8) {12-point} PVT Corner:**
    - (TT,  -20°C, 1.25 V)
    - (TT,  +27°C, 1.25 V)
    - (TT,  +50°C, 1.25 V)
    - (TT,  +80°C, 1.25 V)
    - (SS,  -20°C, 1.25 V)
    - (SS,  +27°C, 1.25 V)
    - (SS,  +50°C, 1.25 V)
    - (SS,  +80°C, 1.25 V)
    - (FF,  -20°C, 1.25 V)
    - (FF,  +27°C, 1.25 V)
    - (FF,  +50°C, 1.25 V)
    - (FF,  +80°C, 1.25 V)
- (9) {1-point} Simulation Mode: Spectre X (preset = CX) with 0 ~ 10 MHz transient noise
- (10) {1-point} Simulation Time: transient time = 15 ms (typical locking time < 3 ms)

all-corner 后仿结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-28-21-07-01_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>


### 10.5 joint simulation (top cell)

top cell 联合后仿条件设置如下：
- (1) {1-point} Testbench: `TB_TOP`
- (2) {1-point} Netlist: calibre of `202510_PLL_withDigitalLDO_v1`
- (3) {1-point} VBAT Supply: ideal 3.3 V supply (no ripple/noise)
- (4) {1-point} Output Frequency: (SL1, SL0) = (0, 0)
- **(5) {2-point} level shifter control:**
    - EN_BUF = 0
    - EN_BUF = 1
- (6) {1-point} Load Condition: load = (40 fF, 40 fF, 40 fF, 40 fF)
- (7) {1-point} Trimming Setting: T⟨4:0⟩ = ⟨01111⟩_2 = ⟨15⟩_10
- **(8) {3-point} PVT Corner:**
    - (TT,  +27°C)
    - (SS,  +27°C)
    - (FF,  +27°C)
- (9) {1-point} Simulation Mode: Spectre X (preset = CX) with 0 ~ 10 MHz transient noise
- (10) {1-point} Simulation Time: transient time = 15 ms (typical locking time < 3 ms)

top cell 联合后仿结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-30-12-15-55_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>


不妨用 `TB_PLL_withDigitalLDO` 再跑一次，结果如下：

<span style='color:red'> 这里放图 </span>

为什么 digital LDO 单独拿出来跑的时候，其输出就不正常了？不仅是在 `TB_PLL_withDigitalLDO` 这里，我们在 `TB_digitalLDO` 中单独对其仿真时也遇到过，稍有不同的是单独仿真 LDO 时 schematic 正常而 calibre 不正常，而这里是 schematic 和 calibre 都不正常。原因是什么？



## 11. Post-Simulation Report

终于可以写最终的后仿报告并准备交付了，《后仿报告》有中英文两版，详见附属文档：
- [202510_onc18_CPPLL_ultra_low_lower (docs-6) 2026.01.28 CP-PLL post-layout simulation report](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (docs-6) 2026.01.28 锁相环后仿报告 CP-PLL post-layout simulation report (English).md>)
- [202510_onc18_CPPLL_ultra_low_lower (docs-5) 2026.01.28 CP-PLL post-layout simulation report (Chinese ver.)](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (docs-5) 2026.01.28 锁相环后仿报告 CP-PLL post-layout simulation report (Chinese).md>) 和 。


``` latex
% all-load:
\begin{tabular}{cccccccccccccccccccccccccccccccccccccccc}
    \toprule\toprule
    Test Point & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 \\
    \bottomrule\toprule
    EN\_BUF & 0 & 0 & 0 & 0 & 0 & 1 & 1 & 1 \\
    CL1 (Per Channel) & 0.1 fF & 40 fF & 40 fF & 40 fF & 40 fF & 40 fF & 100 fF & 200 fF \\
    CL2 (Per Channel) & 40 fF & 40 fF & 40 fF & 40 fF & 40 fF & 40 fF & 40 fF & 40 fF \\
    Leakage (Per Channel) & 0 nA & 0 nA & 1 nA & 10 nA & 100 nA & 0 nA & 0 nA & 0 nA \\
    \bottomrule\toprule
    \midrule
    $I_{DD}$ w/o load (nA)  & 
    $I_{DD}$ w/i load (nA)  & 
    $t_{lock}$  (ms)        & 
    $D_{ADC}$ (\%)          & 
    $t_{rise,ADC}$ (ns)     & 
    $t_{fall,ADC}$ (ns)     & 
    $J_{c,rms,ADC}$ (ns)    & 
    $J_{e,rms,ADC}$ (ns)    & 
    $J_{int,rms,ADC}$ (ns)  & 
    $L_{ADC}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)       & 
    $L_{ADC}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)      & 
    $L_{ADC}(f_m)\,@\, \frac{f_{CK\_ADC}}{2}$ (dBc/Hz) & 
    $D_{OUT}$ (\%)          & 
    $t_{rise,OUT}$ (ns)     & 
    $t_{fall,OUT}$ (ns)     & 
    $J_{c,rms,OUT}$ (ns)    & 
    $J_{e,rms,OUT}$ (ns)    & 
    $J_{int,rms,OUT}$ (ns)  & 
    $L_{OUT}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)       & 
    $L_{OUT}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)      & 
    $L_{OUT}(f_m)\,@\, \frac{f_{CK\_OUT}}{2}$ (dBc/Hz) & 
    \midrule
    \bottomrule\bottomrule
\end{tabular}


% all-load-BUF:
\begin{tabular}{cccccccccc}
    \toprule\toprule
    Test Point & 6 & 7 & 8 \\
    \bottomrule\toprule
    EN\_BUF                 & 1 & 1 & 1 \\
    CL1 (Per Channel)       & 40 fF & 100 fF & 200 fF \\
    CL2 (Per Channel)       & 40 fF & 40 fF & 40 fF   \\
    Leakage (Per Channel)   & 0 nA & 0 nA & 0 nA \\
    \bottomrule\toprule
    \midrule
    $I_{DD}$ w/o load (nA)      & 
    $I_{DD}$ w/i load (nA)      & 
    $t_{lock}$  (ms)            & 
    $D_{ADC\_BUF}$ (\%)         & 
    $t_{rise,ADC\_BUF}$ (ns)    & 
    $t_{fall,ADC\_BUF}$ (ns)    & 
    $J_{c,rms,ADC\_BUF}$ (ns)   & 
    $J_{e,rms,ADC\_BUF}$ (ns)   & 
    $J_{int,rms,ADC\_BUF}$ (ns) & 
    $L_{ADC\_BUF}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)       & 
    $L_{ADC\_BUF}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)      & 
    $L_{ADC\_BUF}(f_m)\,@\, \frac{f_{CK\_ADC}}{2}$ (dBc/Hz) & 
    $D_{OUT\_BUF}$ (\%)         & 
    $t_{rise,OUT\_BUF}$ (ns)    & 
    $t_{fall,OUT\_BUF}$ (ns)    & 
    $J_{c,rms,OUT\_BUF}$ (ns)   & 
    $J_{e,rms,OUT\_BUF}$ (ns)   & 
    $J_{int,rms,OUT\_BUF}$ (ns) & 
    $L_{OUT\_BUF}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)       & 
    $L_{OUT\_BUF}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)      & 
    $L_{OUT\_BUF}(f_m)\,@\, \frac{f_{CK\_OUT}}{2}$ (dBc/Hz) & 
    \midrule
    \bottomrule\bottomrule
\end{tabular}


% all-SL:
\begin{tabular}{ccccccccccc}
    \toprule\toprule
    Test Point & 1 & 2 & 3 & 4 \\
    \bottomrule\toprule
    SL<1:0> & <00> & <01> & <10> & <11> \\
    EN\_BUF & 0 & 0 & 0 & 0 \\
    CL1 (Per Channel) & 40 fF & 40 fF & 40 fF & 40 fF \\
    CL2 (Per Channel) & 40 fF & 40 fF & 40 fF & 40 fF \\
    \bottomrule\toprule
    \midrule
    $I_{DD}$ w/o load (nA)  & 
    $I_{DD}$ w/i load (nA)  & 
    $t_{lock}$  (ms)        & 
    $f_{CK\_ADC}$ (kHz)     & 
    $D_{ADC}$ (\%)          & 
    $t_{rise,ADC}$ (ns)     & 
    $t_{fall,ADC}$ (ns)     & 
    $J_{c,rms,ADC}$ (ns)    & 
    $J_{e,rms,ADC}$ (ns)    & 
    $J_{int,rms,ADC}$ (ns)  & 
    $L_{ADC}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)       & 
    $L_{ADC}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)      & 
    $L_{ADC}(f_m)\,@\, \frac{f_{CK\_ADC}}{2}$ (dBc/Hz) & 
    $f_{CK\_OUT}$ (kHz)     & 
    $D_{OUT}$ (\%)          & 
    $t_{rise,OUT}$ (ns)     & 
    $t_{fall,OUT}$ (ns)     & 
    $J_{c,rms,OUT}$ (ns)    & 
    $J_{e,rms,OUT}$ (ns)    & 
    $J_{int,rms,OUT}$ (ns)  & 
    $L_{OUT}(f_m)\,@\,1 \ \mathrm{kHz}$ (dBc/Hz)       & 
    $L_{OUT}(f_m)\,@\,10 \ \mathrm{kHz}$ (dBc/Hz)      & 
    $L_{OUT}(f_m)\,@\, \frac{f_{CK\_OUT}}{2}$ (dBc/Hz) & 
    \midrule
    \bottomrule\bottomrule
\end{tabular}
```

导出工艺库的技巧是：
- 右键选中 top cell (或者 top testbench) > 点击 copy
- 设置好到新的 lib name，建议在原 lib name 后面加上 `__EX_20260110` 以表示在 2026.01.10 导出 (export)
- 勾选 `copy Hierarchical`，skip analoglib 这些基础库和 pdk 工艺库，其它都不要 skip
- 勾选 `update instance of Entry library`
- 点击导出，这样新的 library 里就包含所有涉及到的的 cell 了，把这个 library 提交给项目管理者，他就再也不会找你麻烦。

最终导出的工艺库名为 `202510_onc18_CPPLL_ultra_low_lower__EX_20260131`，后仿报告有英文 (原版) 和中文两版，详见附属文档：
- [202510_onc18_CPPLL_ultra_low_lower (docs-5) 2026.01.30 Post-Layout Simulation Report (updated on 2026.01.30).pdf](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (docs-5) 2026.01.30 Post-Layout Simulation Report (updated on 2026.01.30).pdf>)
- [202510_onc18_CPPLL_ultra_low_lower (docs-5) 2026.01.30 锁相环后仿报告 (updated on 2026.01.30).pdf](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (docs-5) 2026.01.30 锁相环后仿报告 (updated on 2026.01.30).pdf>)

## x. Experience Summary

- Verilog-A 代码修改后却 "没有变化" 时，记得在 verilog 界面点击左上角的保存按钮 `Build a databese of instances, nets and pins found in file`，这会重新提取 verilog 代码对应网表；如果还不行，可能是原理图未刷新导致的，重新放置器件即可。 
- 在 Assembler 的 Global Variables 处右键可以 Add Config Sweep.
- VCO 输出波形 (CK_OUT) 占空比不为 50% 时，一般不会对 CK_FB 产生影响，因为经典 tri-state PFD 比较的是两路时钟的上升沿对齐情况，即便 CK_FB 是窄/宽脉冲也可以正常工作 (但不能太窄/太宽)
- 偶数分频 (2 分频) 可以 "完全" 修正时钟占空比，奇数分频一般只能部分修正（公式如下），除非使用 50%-duty 奇数分频电路 (可以在非 50-duty 电路的基础上进行改造)

$$
\begin{gather}
N = 2k + 1 \Longrightarrow  D' = \frac{100\%\times k + D}{100\%\times (2k + 1)} = \frac{D  - 50\%}{N} + 50\% 
\\
\mathrm{for\ example:}\ D = 53\%,\ N = 15 \Longrightarrow D' = \frac{53\% - 50\%}{15} + 50\% = 50.2\%
\end{gather}
$$


- 建议 global 变量用于扫描/测试，test 里的 design variable 用于存放最佳值
- VCO 设置时分为 VCO_core 和 VCO_buffer 两部分，方便迭代
- Current-Starved Ring VCO: VDD = 1.2\*Vth ~ 2.8\*Vth 有良好性能；如果要求功耗尽量低，那么 1.5\*Vth 左右能在保证其它性能的前提下尽量降低功耗；综合性能最优的点一般在 2.0\*Vth 附近
- 蒙卡点数太少是看不了 mismatch contribution 的，例如只设了 10 个点不行，改成 100 个点后可以
- **Analog multiplexers can be used as digital multiplexers but digital multiplexers cannot be used as analog ones.**
- 多数工艺下，对小面积 nA 级低功耗设计而言，除寄生电容影响外，后仿总比前仿功耗高出 20 nA ~ 100 nA 不等 (与版图面积有关)，这是因为后仿考虑了版图寄生器件漏电流的影响 (主要是寄生 PN 结)



模块文件结构：
``` bash
2025_PLL_RVCO1_layout
    schematic
    layout
    symbol
```


做完一个版本后复制（备份）到另一个 cell: **<span style='color:red'> (注意修改复制后新 cell > layout 的 reference source) </span>**

``` bash
2025_PLL_RVCO1_layout_v1
    schematic
    layout
    symbol
    v1_10272243_PEX_HSPICE
    v1_10272243_layout
```


v1_10272243_layout 是为了再次备份，因为后面有可能修改 v1 的 layout，此时可保存为 v1_10281026_layout (仍属于 v1)
另外，将寄生网表复制到主 cell (config 均使用主 cell，直接从此处调用寄生网表)，最终得到这样的结构：

``` bash
2025_PLL_RVCO1_layout
    schematic
    layout
    symbol
    v1_10272243_PEX_HSPICE
    v1_10281026_PEX_HSPICE
    v2_10290000_PEX_HSPICE

2025_PLL_RVCO1_layout_v1
    schematic
    layout (注意修改复制后新 cell > layout 的 reference source)
    symbol
    v1_10272243_layout
    v1_10272243_PEX_HSPICE
    v1_10281026_layout
    v1_10281026_PEX_HSPICE


2025_PLL_RVCO1_layout_v2
    schematic
    layout (注意修改复制后新 cell > layout 的 reference source)
    symbol
    v2_10290000_layout
    v2_10290000_PEX_HSPICE
```

这样的好处是，可以直接用 config sweep 快速切换 2025_PLL_RVCO1_layout 的 schematic/v1_PEX/v2_PEX, 十分方便。


- 想要 annotate DC operating points 时，直接在 ADE results 处找到想看的工艺角或特定参数，右键选择 `annotate > DC Operating Points` 即可，这样就会自动选择对应参数下的直流工作点结果，显示在原理图上 (配合我们的设置代码即可快速查看晶体管的各个关键参数)
- 对于具有 Negative K_VCO 的锁相环 (假设锁定时控制电压在 VDD/2 附近，不过高或过低)，滤波器 LPF 的 "地" 端有两种基本接法：
    - (1) 接 VDD: 上电之后 V_CT = VDD (最大值)，VCO 频率最低，PLL 需要 "向高频锁定"，锁定时间较长？但是对环路模块 (主要是第一级 FD) 的频率要求大大降低； **如何 "打破" f_out/2 的假锁定状态？**
    - (2) 接 VSS: 上电之后 V_CT = VSS = 0 (最小值)，VCO 频率最高，PLL 需要 "向低频锁定"，锁定时间较短？但是对环路模块 (主要是第一级 FD) 的频率要求较高；也就是说，如果 FD 的最大工作频率不足以覆盖此频率，锁定过程中可能会出现一些问题； **如何 "打破" 2\*f_out 的假锁定状态？**
- VCT 可以设置初始值以加快环路锁定，节省一些时间来仿真稳定后的性能，但是 VDD 最好给充足的 delay 再上电，以避免可能出现的时序或其它问题；
- LPF to VSS/VDD 对 FD 的高频要求不同，如果上电后频率是从低向高锁定，则 FD 高频要求较低，反之则要求较高
- 中高频锁相环 (output > 100 MHz) 的闭环环路带宽比 (f_REF/f_BW) 常常会做到 100 以上，以获得更低的相位噪声 (尤其是低频段)，通常是 150 ~ 500 居多。对于分频比较高的锁相环又如何？
- 对于 CP-PLL, the dead zone of PFD/CP 对整个环路的 Je_rms 影响较大 (因为 Je 是很长时间的 "累积" 抖动)，死区大时，输出相位越有可能接近死区边界，这时便有较大的相位噪声/抖动。举个例子，假设 PFD/CP 对 delay = ±2% 以内都没有反应，也就是 dead zone = -2% ~ +2%, 如果这段死区内的等效电流 $I_{dz}$ 非常小，几乎相当于 "没有电流"，就会导致环路的 RMS phase noise 达到 $2\pi \times 2\% = 0.1257 \ \mathrm{rad} = 7.2^\circ$，这在低抖动时钟系统中是完全不可接受的。这个现象在 nominal $I_P$ 较小时尤为明显，比如 nA-level 低功耗设计。
- 可以用 **`basic > patch`** 元件来短接两个具有不同 net name 的网络，这在版图中也是能正常过的 (版图中会将两网络合二为一，同时保持正确的对应关系)，LVS 能不能过还待验证；但是注意，`patch` 仅能短接两个 net 或者 1 pin + 1 net, 但是不能短接两个 pin (会报错)。与之类似的还有 `basic > cds_thru` 元件 [(here)](https://zhuanlan.zhihu.com/p/370333465)，这个元件其实更好用，一方面它可以短接两个 pin, 另一方面可以明确知道两个 net 到底共用哪个名字 (src 和 dst 两个端口，公用 src 端口的 net name)，数字电路在综合时 (如果需要 "短接") 常常就是自动生成了这个元件，它的版图和 LVS 都能正常通过 (LVS 是利用了 `lvs ignore = true` 来实现的)
- 作图之后，可以通过 `Graph > Edge Browser` 查看边沿的各种信息
- 封装 pcell (parameterized cell) 时，`4*pPar("mu")` 不行但是 `pPar("mu")*4` 可以
- `schematic > View > Info Balloons` 可以打开波形信息气泡，鼠标悬停在 net/pin 上可以快速查看此位置的 voltage/current 波形。
- 管子栅极从 m1 引出，那么 m2/m3 尽量不走线以避免寄生电容耦合，并且最好拿高层金属把沟道全遮住以避免可能存在的光效应 (尤其射频、毫米波)
- Integer-N CP-PLL 的 FD chain 中，随着频率的降低，cycle jitter 逐渐增大 (近似满足$\sqrt{N}$)，而 edge jitter 则基本不变。
- **<span style='color:red'> 仿真时遇到一个问题是：不小心将变量 "copy to cellview" 之后，每次运行仿真，仿真器会自动执行一遍 "copy from cellview"，导致新设置的变量被当时 copy 进来的值覆盖掉。 </span>** 关键是还找不到在哪里 (或如何) 还原设置，这个功能是真的纯恶心人。经过检查，发现是一个 cellview 中存在多个 schematic 时，非默认的 schematic 会以 edit mode 而不是 read mode 打开，导致这个 schematic 对应 test 被 "copy to cellview" 才是真的被 copy 进去。默认 schematic/config 只能以 read mode 打开，因此其 "copy to cellview" 不会生效。所以解决方法就呼之欲出了：在非默认 schematic/config 对应的 test 中，先删除全部 variables，点击 "copy to cellview" 之后，再重新添加 variables 并设置好值即可。**<span style='color:red'> 经过测试：直接点 open design in tap 后，将 schematic 设置为 `Make Read Only`，即可将 design 从 edit 模式修改为 read 模式 </span>**
- 将一个 cell > maestro 复制为新 cell > maestro 后，如果在新 maestro 中删去之前的仿真历史而不影响原 maestro 的仿真历史和数据查看，直接 `右键 > Delete` 即可。虽然 ADE Assembler 会弹出窗口提醒说 "此操作会删除所有仿真数据"，但实际上，由于路径不对应，原 maestro 的仿真数据并不会被删除，仍然可以正常查看 (没有任何影响)。
- VCO 的输出时钟，理论上经过分频后 edge jitter 不变，而 cycle jitter 变为原来的 $\sqrt{N}$ 倍 (假设 cycle jitter 满足高斯分布)。实际情况中 edge jitter 确实基本不变，但是 cycle jitter 因为存在 spur 等非高斯噪声成分，比理论值要更大一些，一般在 $1.4 \sqrt{N} \sim 2.0 \times \sqrt{N}$ 范围内 (视具体设计而定)，我们这次的约为 $1.65 \sqrt{N}$ 倍。
- PLL 中的 LPF，一般都用积分型 LPF 来获得无穷大的直流增益，这是为了使环路稳定后的相位误差为零 (理论上)；根据开环传函得到误差传函 $H_e(s) = \frac{\Phi_{in}(s)-\Phi_{FB}(s)}{\Phi_{in}(s)} = 1 - \frac{1}{N} H_{CL}(s) = \frac{N}{N + H_{OL}(s)}$，在已知输入激励 $X(s)$ 的情况下可以得到响应函数 $Y(s) = H_e(s)X(s)$，配合终值定理即可得到 $\lim_{t\to\infty} \phi_e(t)$；注意是相位误差是 (REF - FB) 而不是 (REF - OUT)；举个例子，在相位阶跃输入情况下，$X(s) = \frac{\Delta \phi}{s}$，有 $\phi_e(\infty) = \lim_{s\to 0} \Delta \phi \times \frac{N}{N + H_{OL}(s)} = 0$，而在频率阶跃输入的情况下，$X(s) = \frac{\Delta omega}{s^2}$，有 $\phi_e(\infty) = \lim_{s\to 0} \Delta \omega \times \frac{N}{s(N + H_{OL}(s))} = \frac{N \Delta \omega}{K_d Z_{LF}(0)K_{VCO}}$，也就是说频率阶跃输入下的稳态相位误差与 LPF 的直流增益成反比 (直流增益越大，稳态相位误差越小)，这也是一般都使用积分型 LPF 的原因 (稳态相位误差为零)。





**<span style='color:red'> ！！！！！直接替换 cell name 后, Macro Model Name 没改, 导致实际 netlist 没变??? </span>**



**FD 不仅要能在低频工作，高频也是需要的？**


