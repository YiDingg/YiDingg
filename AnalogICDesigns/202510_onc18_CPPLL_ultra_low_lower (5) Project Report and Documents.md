# 202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 01:03 on 2025-11-16 in Beijing.


>注：本文是项目 [Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology](<Projects/Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology.md>) 的附属文档，用于全面记录 PLL 的设计/迭代/仿真/版图/后仿过程，以及最终的项目报告和相关资料等。

续前文 [202510_onc18_CPPLL_ultra_low_lower (4) Pre-Simulation, Layout Details and Post-Simulation Results](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (4) Pre-Simulation, Layout Details and Post-Simulation Results.md>), 本文档继续补充项目的相关资料和项目报告。




## 1. 修正：unit of K_VCO

今天 (2025.12.31) 才注意到，VCO model 中的 **<span style='color:red'> K_VCO 的单位应该是 rad/s/V 而不是 Hz/V </span>** , 也就是要在 Hz/V 的基础上再乘以 2π。之前的建模都是用的 Hz/V, 导致 K_VCO 只有实际值的，从而得到了错误的环路参数。这解释了为什么在接近锁定频率时 vcont 要经过很多轮才能稳定下来，本质上是环路的阻尼因子 $\zeta$ 过大，也可以说是放电太慢，放电时间占比过大，从而导致环路响应过慢。

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

将上一小节的内容，补充上接口说明、电路设计说明、top-level 原理图和 testbanch 原理图等等，最终整理成报告形式。由于内容较长，我们就不复制到这里来了，详见附属文档 (前仿报告)：[202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.md>)。



## 5. post-layout simulation report



## x. Experience Summary
 
- Verilog-A 代码修改后却 "没有变化" 时，记得在 verilog 界面点击左上角的保存按钮 `Build a databese of instances, nets and pins found in file`，这会重新提取 verilog 代码对应网表；如果还不行，可能是原理图未刷新导致的，重新放置器件即可。 
- 在 Assembler 的 Global Variables 处右键可以 Add Config Sweep.
- VCO 输出波形 (CK_OUT) 占空比不为 50% 时，不会对 CK_FB 产生影响，因为 PFD 比较的是两路时钟的上升沿对齐情况，即便 CK_FB 是窄脉冲也可以正常工作
- 偶数分频 (2 分频) 可以完全修正时钟占空比，奇数分配只能部分修正，具体如下：

$$
\begin{gather}
N = 2k + 1 \Longrightarrow  D' = \frac{100\%\times k + D}{100\%\times (2k + 1)} = \frac{D  - 50\%}{N} + 50\% 
\\
\mathrm{for\ example:}\ D = 53\%,\ N = 15 \Longrightarrow D' = \frac{53\% - 50\%}{15} + 50\% = 50.2\%
\end{gather}
$$


- global 变量用于扫描，sweep 变量由于存放最佳值
- VCO 设置时分为 VCO_core 和 VCO_buffer 两部分，方便迭代
- Current-Starved Ring VCO: VDD = 1.2\*Vth ~ 2.8\*Vth 有良好性能；如果要求功耗尽量低，那么 1.5\*Vth 左右能在保证其它性能的前提下尽量降低功耗；综合性能最优的点一般在 2.0\*Vth 附近
- 蒙卡点数太少是看不了 mismatch contribution 的，例如只设了 10 个点不行，改成 100 个点后可以
- **Analog multiplexers can be used as digital multiplexers too however digital multiplexers cannot be used as analog multiplexers.**
- 对小面积 nA 级低功耗设计而言，除寄生电容影响外，后仿总比前仿功耗高出 40 nA ~ 100 nA 不等 (与版图面积有关)，这是因为后仿考虑了版图寄生器件漏电流的影响 (主要是寄生 PN 结)



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

VCO 的输出时钟，理论上经过分频后 edge jitter 不变，而 cycle jitter 变为原来的 $\sqrt{N}$ 倍 (假设 cycle jitter 满足高斯分布)。实际情况中 edge jitter 确实基本不变，但是 cycle jitter 因为存在 spur 等非高斯噪声成分，比理论值要更大一些，一般在 $1.4 \sqrt{N} \sim 2.0 \times \sqrt{N}$ 范围内 (视具体设计而定)，我们这次的约为 $1.65 \sqrt{N}$ 倍。





**<span style='color:red'> 仿真时遇到一个问题是：不小心将变量 "copy to cellview" 之后，每次运行仿真，仿真器会自动执行一遍 "copy from cellview"，导致新设置的变量被当时 copy 进来的值覆盖掉。 </span>** 关键是还找不到在哪里 (或如何) 还原设置，这个功能是真的纯恶心人。

经过检查，发现是一个 cellview 中存在多个 schematic 时，非默认的 schematic 会以 edit mode 而不是 read mode 打开，导致这个 schematic 对应 test 被 "copy to cellview" 才是真的被 copy 进去。默认 schematic/config 只能以 read mode 打开，因此其 "copy to cellview" 不会生效。

所以解决方法就呼之欲出了：在非默认 schematic/config 对应的 test 中，先删除全部 variables，点击 "copy to cellview" 之后，再重新添加 variables 并设置好值即可。


将一个 cell > maestro 复制为新 cell > maestro 后，如果在新 maestro 中删去之前的仿真历史而不影响原 maestro 的仿真历史和数据查看，直接 `右键 > Delete` 即可。虽然 ADE Assembler 会弹出窗口提醒说 "此操作会删除所有仿真数据"，但实际上，由于路径不对应，原 maestro 的仿真数据并不会被删除，仍然可以正常查看 (没有任何影响)。


**<span style='color:red'> ！！！！！直接替换 cell name 后, Macro Model Name 没改, 导致实际 netlist 没变??? </span>**



**FD 不仅要能在低频工作，高频也是需要的？**


