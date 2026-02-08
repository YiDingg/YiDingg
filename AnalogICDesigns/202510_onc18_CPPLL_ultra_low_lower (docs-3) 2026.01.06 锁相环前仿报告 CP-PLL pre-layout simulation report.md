# 202510_onc18_CPPLL (docs-3) <br> 电荷泵锁相环前仿报告 <br> (updated on 2026.01.27)




本报告为 `202510_onc18_CPPLL_ultra_low_lower` (超低功耗电荷泵锁相环) 项目的前仿报告 (CP-PLL pre-layout simulation report)，主要内容包括：
1. 锁相环设计总览 (包括框图、接口说明、性能总览)
2. 性能指标与电路设计/优化思路
3. 锁相环理论基础与环路设计
4. 各条件下的前仿结果展示与分析
5. library 使用说明、设计总结


## 1. PLL Overview and Interface Description

所设计的超低功耗 CP-PLL 系统框图如下图所示 (updated at 2025.01.10)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-10-19-01-11_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

其输入输出端口的定义如下 (updated at 2025.01.10, big BUF 换为 level shifter)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-10-19-02-08_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>


锁相环设置为 **<span style='color:red'> `EN_BUF = 0, T<4:0> = <01111>, SL<1:0> = <11>` </span>** (CK_OUT = X24) 时的典型前仿性能如下：

$$
\begin{gather}
t_{lock} = 2.8 \ \mathrm{ms}  \\
I_{DD} = 333.2 \ \mathrm{nA} \,@\, \mathrm{40\ fF\ (per\ ch)} = 277.9 \ \mathrm{nA} \,@\, \mathrm{no\ load} \\
\mathrm{CK\_ADC:}\ \ J_{c,rms,ADC} = 20.45 \ \mathrm{ns},\ \ J_{e,rms,ADC} = 33.06 \ \mathrm{ns} \\
\mathrm{CK\_OUT:}\ \ J_{c,rms,OUT} = 4.334 \ \mathrm{ns},\ \ J_{e,rms,OUT} = 32.07 \ \mathrm{ns}
\end{gather}
$$


## 2. Specifications

### 2.1 updated at 2026.01.06 (original)

本次 ultra-low-power CP-PLL 设计的主要性能指标如下：
- **(1) Reference Clock:** 32.768 kHz (X01) reference clock;
- **(2) Output Clocks (Four Channels in Total):**
    - **System Clock (`CK_OUT`):** 98.304 kHz ~ 786.432 kHz (X03 ~ X24) controlled by 2-bit digital code `SL<1:0>` for X03/X06/X12/X24 output frequency selection;
    - **ADC Clock (`CK_ADC`):** 98.304 kHz (fixed X03), serving as the sampling clock for the subsequent ADC circuit;
    - **Buffered System Clock to PAD (`CK_OUT_BUF`):** buffered output with configurable frequency controlled by `SL<1:0>` and enable/disable control `EN_BUF;`
    - **Buffered ADC Clock to PAD (`CK_ADC_BUF`):** buffered output at fixed X03 frequency with enable/disable control `EN_BUF;`
- **(3) Jitter Performance:** RMS cycle jitter of `CK_ADC` (ADC clock) <span style='color:red'> $J_{c,rms,ADC} < 100 \ \mathrm{ns}$ </span>;
- **(4) Power Consumption:** total average current consumption <span style='color:red'> $I_{DD} < 500 \ \mathrm{nA}$ @ no load (with disabled big BUFs) </span>;
- **(5) Supply Voltage:** 1.25V ± 0.05 V digital power supply;
- **(6) Temperature Range:** nominally at human body temperature (≈ 37°C), <span style='color:red'> -20°C ~ 80°C </span> should be covered for robustness;
- **(7) Process Corners:** <span style='color:red'> TT/SS/FF </span> process corners;
- **(8) Process Technology:** ONC 180nm CMOS.


简单来讲就是需要两路输出，一路 `CK_ADC` 固定 X03 (98.304 kHz) 作为 ADC 采样时钟，另一路 `CK_OUT` 可配置输出为 X03/X06/X12/X24 四档频率 (98.304 kHz ~ 786.432 kHz)，抖动要求 `CK_ADC` 的 rms cycle jitter 小于 100 ns，同时整个锁相环的功耗要非常低 (< 500 nA @ no load with disabled big BUFs)，其它就是一些 robustness 方面的要求了。

### 2.2 updated at 2026.01.10 (big BUF > level shifter)


本次 ultra-low-power CP-PLL 设计的主要性能指标如下 (updated at 2026.01.10, 换为 level shifter 而不是 big BUFs)：
- **(1) Reference Clock:** 32.768 kHz (X01) reference clock from crystal oscillator;
- **(2) Output Clocks (Four Channels in Total):**
    - **System Clock (`CK_OUT`):** 98.304 kHz ~ 786.432 kHz (X03 ~ X24) controlled by 2-bit digital code `SL<1:0>` for X03/X06/X12/X24 output frequency selection;
    - **ADC Clock (`CK_ADC`):** 98.304 kHz (fixed X03), serving as the sampling clock for the subsequent ADC circuit;
    - **Shifted ADC Clock (`CK_ADC_BUF`):** shifted output (from 1.25V-level to vbat-level) at fixed X03 frequency with enable/disable control `EN_BUF;`
    - **Shifted System Clock (`CK_OUT_BUF`):** shifted output (from 1.25V-level to vbat-level) with configurable frequency controlled by `SL<1:0>` and enable/disable control `EN_BUF;`
- **(3) Jitter Performance:** RMS cycle jitter of `CK_ADC` (ADC clock) <span style='color:red'> $J_{c,rms,ADC} < 100 \ \mathrm{ns}$ </span>;
- **(4) Power Consumption:** total average current consumption <span style='color:red'> $I_{DD} < 500 \ \mathrm{nA}$ @ no load (with disabled level shifters) </span>;
- **(5) Supply Voltage:** 1.25V ± 0.05 V digital power supply;
- **(6) Temperature Range:** nominally at human body temperature (≈ 37°C), <span style='color:red'> -20°C ~ 80°C </span> should be covered for robustness;
- **(7) Process Corners:** <span style='color:red'> TT/SS/FF </span> process corners;
- **(8) Process Technology:** ONC 180nm CMOS.


简单来讲就是需要四路输出，一路 `CK_ADC` 固定 X03 (98.304 kHz) 作为 ADC 采样时钟，另一路 `CK_OUT` 可配置输出为 X03/X06/X12/X24 四档频率 (98.304 kHz ~ 786.432 kHz)，剩下两路 `CK_ADC_BUF` 和 `CK_OUT_BUF` 则是转到 vbat 电压域的时钟输出，以满足 PAD 端测量需求；抖动方面需要 `CK_ADC` 的 rms cycle jitter 小于 100 ns，同时整个锁相环的功耗要非常低 (< 500 nA @ no load with disabled level shifters)，其它就是一些 robustness 方面的要求了。

>注：后文部分内容仍然保留 big BUF 设计的描述，仅供参考，不再一一修改为 level shifter 设计。


## 3. Design Considerations



### 3.1 ultra-low-power optimization

总功耗预算仅有极低的 500 nA，这要求我们在各个层面都要进行功耗优化。为此，所有数字逻辑门均采用超高阈值电压 (uhvt) 器件 (`nmosuhvt1p8v`, `pmosuhvt1p8v`) 以大幅降低泄漏电流，从而将 NMOS 和 PMOS 器件在 1.8V 下的泄漏电流分别从 78 pA 和 209 pA 降低到仅有 0.25 pA 和 0.5 pA (数据来自 ONC 180nm CMOS Process Design Kit PDK device catalog `onc18_device_catalog_rev40.pdf`)

RVCO (Ring-VCO) 方面，在对比了使用 uhvt 器件的 VBN+VBP、VBP-only 和 VBN-only 三种 RVCO 结构后，最终选择了 VBN+VBP uhvt 设计作为最佳方案。该结构在保持最佳相位噪声性能的同时，提供了更优的功耗效率 $I_{DD,VCO} \approx 200 \ \mathrm{nA}$。

### 3.2 VDD-referenced techniques for better PSR

在 VCO 和 LPF 设计中均采用了 VDD-referenced 技术 (即 VCO 采用 PMOS 输入控制，LPF 采用 VDD-referenced 结构) 以实现比传统 GND-referenced 设计更优的电源抑制比 (PSR, power supply rejection)。这对工作于 nA current level 的 high-gain VCO 尤为重要，因为电源噪声会显著影响其相位噪声性能。通过 VDD-referenced 技术，可以降低电源电压波动对 VCO 频率的影响，从而提升整体 PLL 抖动性能。

>这里，“VDD-referenced LPF” 是指 LPF 连接在 `VDD` 和 `Vcont` (VCO 控制端) 之间，而 “GND-referenced LPF” 则是指 LPF 连接在 `Vcont` 和 `GND` 之间。 


### 3.3 parameterized cell (Pcell)

需求方这边提供的标准数字单元库并不适用于本次超低功耗设计，主要有两个原因：
- 首先，PFD 和 CP 模块需要精确的时序对称性，而标准单元在 nA current level 下无法提供所需的对称性；
- 其次，标准单元仅有几组固定晶体管尺寸，无法在抖动、动态功耗和静态泄漏功耗之间实现良好平衡。只有自定义的参数化单元 (Pcells) 才能灵活调整每个晶体管的宽度 (W)、长度 (L) 以及 PMOS/NMOS 宽度比 (KA = WP/WN)。因此，我们为所有基本逻辑门 (如 NOR、NAND、INV、TG 等) 创建了自定义 Pcells，不断迭代优化以实现超低功耗目标，同时确保关键路径上的时序性能。


### 3.4 output clock buffers

输出缓冲器分为两部分以确保时钟信号质量和驱动能力。第一部分称为 **small BUFs**，通过小型超低功耗缓冲器提高两路内部时钟 `CK_OUT` 和 `CK_ADC` 的驱动能力，避免后级负载过大导致时钟失真和抖动恶化。

除此之外，为了满足 PAD 端测量需求，设计了第二部分称为 **big BUFs** 的多级级联缓冲器链路，可通过数字控制信号 `EN_BUF` 来启用或禁用 big BUFs, 启用后能够可靠驱动约 30 pF 的负载电容以满足常见示波器探头测量需求，同时几乎不影响原始时钟质量。

在 `EN_BUF = 0` 时，big BUFs 被禁用，此时仅额外产生 < 5 nA 的静态漏电流，对整体功耗无显著影响。但是注意 `EN_BUF = 1`, big BUFs 被启用时，由于需要驱动较大负载，整体功耗会显著增加，平均电流消耗达到约 30 uA @ 20 pF (per channel)。


### 3.5 PVT corner robustness

为满足严格的 PVT 鲁棒性要求，我们在设计时已经特别注意了这一点：一方面借助 gm/Id 方法的思想，在各关键模块中均使用了 gm/Id 值较低的晶体管以降低工艺变化对晶体管工作状态的影响；另一方面通过全面的 PVT corner 仿真 (包括 TT/FF/SS, VCO 还额外验证了 FS/SF 工艺角)、宽温度范围 (-20°C ~ 80°C) 和电源电压变化 (1.20 V ~ 1.30 V) 来确保设计具有较高可靠性。

### 3.6 trimming strategy

仅仅在宽 PVT 范围下能正常工作还不够，我们还需保证不同 PVT 条件下锁相环输出性能的一致性，毕竟 process variation 和 temperature 对环路滤波器 LPF 的影响较大 (±20% res. variation, ±15% mim cap. variation)，可能导致输出抖动/相噪性能大幅波动，甚至出现 "失锁 (locking failure)"。

为此，我们在 CP 和 LPF 上均设置了 trimming 机制以补偿 PVT 变化带来的影响：
- (1) 2-bit trimming for CP (charge pump) 输出电流 $I_P$
- (2) 3-bit trimming for LPF (loop filter) 电容 $C_1$ 和 $C_2$

合起来一共 5-bit trimming control, 记作 `T<4:0>`，其中 `T<4:3>` 用于 CP 电流调节，`T<2:0>` 用于 LPF 电容调节。

### 3.7 optimized loop Parameters

由于超低功耗限制，尽管 RVCO 的抖动性能已经过优化，但其相位噪声仍然较高，是环路所有模块中相位噪声贡献最大的部分。因此，我们选择了相对较高的闭环带宽来平衡 RVCO 和其它模块之间的噪声性能，从而最小化总相位噪声和抖动 (本设计中 $\mathrm{BW} = 15.5 \ \mathrm{kHz}$)。

同时，为避免高闭环带宽带来的稳定性问题，我们采用了较高的阻尼系数 $\zeta$ 来确保足够的相位裕度和环路稳定性 (本设计中 $\zeta = 3.16$)。


## 4.  Theoretical Basics and Loop Design

### 4.1 theoretical basics

典型 Type-II CP-PLL 由鉴频鉴相器 (PFD)、电荷泵 (CP)、环路滤波器 (LPF)、分频器 (FD) 和压控振荡器 (VCO) 五个主要模块组成，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-14-36-06_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

其开环传递函数为 $H_{OL}(s) = \frac{K_d Z_{LF}(s) K_{VCO}}{s}$，闭环传递函数为 $H_{CL}(s) = \frac{H_{OL}(s)}{1 + F H_{OL}(s)} = \frac{H_{OL}(s)}{1 + \frac{1}{N} H_{OL}(s)} = \frac{N \times H_{OL}(s)}{N + H_{OL}(s)}$，注意其中反馈系数 $F = \frac{1}{N}$ 而不是 1.

为方便设计，我们用 $\zeta$ (damping factor) 和 $\omega_n$ (natural frequency) 等参数来描述系统传函，得到开环/闭环传递函数和关键环路参数如下：

$$
\begin{gather}
\begin{aligned}
H_{OL}(s) &= \omega_n^2 \times \frac{1 + s \frac{2\zeta}{\omega_n}}{s^2} &&= \frac{4\zeta^2}{\tau_1^2} \times \frac{1 + s\tau_1}{s^2}
\\
H_{CL}(s) &= {\color{red} N \times\,}  \omega_n^2 \times \frac{1 + s\frac{2\zeta}{\omega_n}}{s^2 + 2\zeta \omega_n s + \omega_n^2} && ={\color{red} N \times\,}  \frac{4\zeta^2}{\tau_1^2} \times \frac{1 + s\tau_1}{s^2 + \frac{4\zeta^2}{\tau_1} s + \frac{4\zeta^2}{\tau_1^2}}
\end{aligned}
\\
\zeta = \frac{R_1 C_1}{2}\sqrt{\frac{I_PK_{VCO}}{{\color{red} N \times\,} 2\pi C_1}},\ \  \tau_1 = R_1 C_1,\quad 
\omega_n = \frac{2\zeta}{\tau_1}
\\
\text{BW}_\omega = \frac{2\zeta}{\tau_1} \left[1 + 2\zeta^2 + \sqrt{4\zeta^4 + 4\zeta^2 + 2}\right]^\frac{1}{2} \ \ \mathrm{(rad/s)}
\\
\text{PM} = \mathrm{atan}\left(2\sqrt{N\zeta^2} \sqrt{2\,N\,\zeta^2 +\sqrt{4\,N^2 \,\zeta^4 +1}}\right) \ \ \mathrm{(rad)}
\\
\text{UGF}_\omega = \frac{1}{\tau_1} \times \sqrt{N\zeta^2\,} \times 2\,\sqrt{2} \,\sqrt{N\,\zeta^2 + \sqrt{N^2 \,\zeta^4 +\frac{1}{4}}} \ \ \mathrm{(rad/s)}
\end{gather}
$$

注意其中 $\mathrm{PM}$ 和 $\mathrm{UGF}$ 分别表示开环传递函数 $H_{OL}(s)$ 的相位裕度 (phase margin) 和单位增益频率 (unity-gain frequency)，而 $\mathrm{BW}$ 则表示闭环传递函数 $H_{CL}(s)$ 的带宽 (bandwidth)。因为开环传递函数 DC gain 无穷大，不存在所谓 "-3 dB bandwidth" 的概念，所以这里的 $\mathrm{BW}$ 指的是闭环带宽。

为方便分析系统相位噪声性能，这里也给出各模块的相位噪声传递函数 (phase noise transfer functions)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-25-00-17-58_Advanced PLL Architecture - Sub-Sampling PLL (SS-PLL).png"/></div>

<div class='center'>

| Module | Transfer Definition | Noise Transfer $H_{n,xx}(s)$ | Pass Type | Value @ DC | Value @ INF |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | VCO | $ H_{n,\ VCO}(s) = \frac{\phi_{out}}{\phi_{n,\ VCO}}$ | $H_{n,\ VCO}(s) = N \times \frac{1}{N + H_{OL}(s)}$ | High-pass | $0$ | N |
 | PFD | $ H_{n,\ PFD}(s) = \frac{\phi_{out}}{\phi_{n,\ PFD}}$ | $H_{n,\ PFD}(s) = N \times \color{red}{\frac{ H_{OL}(s)}{N + H_{OL}(s)}}$ | Low-pass | $N$ | 0 |
 | CP | $ H_{n,\ CP}(s) = \frac{\phi_{out}}{I_{n,\ CP}}$ | $H_{n,\ CP}(s) = \frac{N}{K_d} \times \color{red}{\frac{ H_{OL}(s)}{N + H_{OL}(s)}}$ | Low-pass | $\frac{N}{K_d}$ | 0 |
 | LPF | $ H_{n,\ LPF}(s) = \frac{\phi_{out}}{V_{n,\ LPF}}$ | $H_{n,\ LPF}(s) = N \times \frac{\frac{K_{VCO}}{s}}{N + H_{OL}(s)}$ | Band-pass | $0$ | $0$ |
 | FD | $ H_{n,\ FD}(s) = \frac{\phi_{out}}{\phi_{n,\ FD}}$ | $ H_{n,\ FD}(s) = -N \times \color{red}{\frac{ H_{OL}(s)}{N + H_{OL}(s)}}$ | Low-pass | $-N$ | 0 |
 | REF | $ H_{n,\ REF}(s) = \frac{\phi_{out}}{\phi_{n,\ REF}}$ | $ H_{n,\ REF}(s) = N \times \color{red}{\frac{ H_{OL}(s)}{N + H_{OL}(s)}}$ | Low-pass | $N$ | 0 |

</div>





### 4.2 analysis and loop design

根据前面提到的 Type-II CP-PLL 理论基础，我们可以分析各模块的噪声贡献，并据此设计环路参数以优化整体相位噪声性能。综合考虑指标要求和实际电路设计结果，最终确定最佳环路参数如下：

$$
\begin{gather}
\displaystyle
I_P = 20 \ \mathrm{nA},\ \  R_1 = 10 \ \mathrm{M}\Omega,\ \  
\displaystyle
C_1 = 42 \ \mathrm{pF},\ \ C_2 = 2.75 \ \mathrm{pF},\ \ N = 24
\\
\displaystyle
K_{VCO} = 71.72 \ \mathrm{\frac{Mrad/s}{V}} = 11.43 \ \mathrm{MHz/V}\ \ \text{\small (determined by the designed VCO)}
\\
\Longrightarrow 
\begin{cases}
\tau_1 =  0.42 \ \mathrm{ms},\ \ \zeta = 3.1625,\ \ \mathrm{UGF} = 363.8 \ \mathrm{kHz},\ \ \mathrm{PM} = 88.6^\circ \\ 
f_{BW} = 15.54 \ \mathrm{kHz},\ \ \frac{f_{REF}}{f_{BW}} = 2.11,\ \ \frac{5 R_1 C_2}{T_{ref}} = 5.29
\end{cases}
\end{gather}
$$

此时，系统的开环和闭环传递函数如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-14-53-53_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>


## 5. Pre-layout Simulation Results

### 5.0 testbench

我们先给出锁相环原理图和 testbench 原理图，然后再展示各条件下的前仿结果。

锁相环 schematic 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-14-55-29_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

`TB_PLL` 单独对锁相环进行仿真的 testbench schematic 如下 (all-corner 中用到)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-15-31-40_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

`TB_PLL_withDigitalLDO` 锁相环与数字 LDO 联合仿真的 testbench schematic 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-15-31-45_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

`TB_TOP` LDO 与 PLL 合并后的顶层 testbench schematic 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-10-18-20-12_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>



### 5.1 digital LDO pre-sim.

在开始正式仿真之前，我们需要先对数字 LDO 进行前仿以确保其性能满足要求，仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-05-19-56-15_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

图中可以看到，相比于我们锁相环 PVT 覆盖范围 (-20° ~ 80°C @ TT/SS/FF)，需求方提供的数字 LDO 覆盖范围稍小一些，无法覆盖 80°C @ TT 和 60°C ~ 80°C @ FF 工艺角  (pre-sim)。

**举个例子，在 (FF, 80°C) 工艺角下，数字 LDO 输出电压明显偏高，平均值达到 1.45 V 左右 (如下图)，远高于预期 1.25 V，这可能会导致锁相环功率异常升高。若要进一步加强设计可靠性，进而提高产品良率，需要需求方这边自行对数字 LDO 进行优化。**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-05-21-10-56_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>




### 5.2 PLL pre-sim. @ all-selection


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




### 5.3 PLL pre-sim. @ all-load

在 (TT, 27°C) 工艺角下，保持其它参数为合适值后不变，改变 PLL 输出负载情况 (包括负载电容和负载漏电流) 进行仿真，具体负载设置和仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-13-43-33_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-20-14-43_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-20-18-31_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>


`EN_BUF = 0` 时，VDD ripple 直接间隔较大 (> 30 ms)，在数十毫秒内都无突变，几乎不会对 PLL 输出频率造成扰动；但是当 `EN_BUF = 1` 时，电流消耗较大 (30 uA @ 20 pF per channel)，VDD ripple 间隔缩小到毫秒级 (约 2.5 ms)，PLL 输出频率受到频繁扰动，导致从统计角度计算得到的时钟抖动明显升高。

不过，升高归升高，即便频繁受到扰动，输出时钟的 Jc_rms (rms cycle jitter) 仍小于 100 ns，满足指标要求。


### 5.3 PLL pre-sim. @ all-corner

上面提到过，需求方提供的这个数字电源，在 (FF, 80°C) 工艺角下出现明显问题，输出电压稳定在了 1.45 V 左右，远高于预期 1.25 V，导致锁相环功率上升到约 850 nA (pre-sim)，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-02-21-21-00_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

于是，我们先利用自行构建的 noisy voltage supply 替代数字 LDO，在 -20°C ~ 80°C 的所有 PVT 下对 PLL 进行 pre-simulation，详细设置和前仿结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-01-41-08_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-07-00-15-29_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

上图看出，锁相环在所有 PVT (-20°C ~ 80°C, 1.25 V ~ 1.30 V, TT/SS/FF) 下均能正常锁定和输出。验证没有问题后，再缩小 PVT 范围并使用数字 LDO 进行联合仿真。将温度范围缩小到 0°C ~ 50°C 进行联合前仿，也即 {0°C, 10°C, 20°C, 30°C, 40°C, 50°C} @ TT/SS/FF，详细设置和前仿结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-01-48-22_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-06-16-08-09_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div>

图中可以看到，在 0 °C ~ 50°C @ TT/SS/FF 工艺角下，PLL 均能正常锁定和输出，输出频率符合预期，功耗和时钟抖动也满足要求。



将 PLL 的 all-corner (PVT) 前仿结果整理如下，方便参考：

<div class='center'>

| Parameter | Nominal | Min | Max | Spec. |
|:-:|:-:|:-:|:-:|:-:|
 | IDD (total current consumption) <br> @ 40 fF (per channel)   | 333.2 nA | 321.5 nA | 371.0 nA | < 500 nA <br> @ no load |
 | Jc_rms_OUT (rms cycle jitter of CK_OUT)                      | 4.334 ns | 4.100 ns | 4.714 ns | NA |
 | Je_rms_OUT (rms edge  jitter of CK_OUT)                      | 32.07 ns | 31.65 ns | 46.36 ns | NA |
 | Jc_rms_ADC (rms cycle jitter of CK_ADC)                      | 20.45 ns | 18.88 ns | 23.40 ns | < 100 ns |
 | Je_rms_ADC (rms edge  jitter of CK_ADC)                      | 33.06 ns | 32.38 ns | 44.99 ns | NA |

</div>


## 6. Change `Big BUF` to `Level Shifter`



一方面，我们需要将 digital LDO 和 PLL 合并到一个 cell；另一方面，前仿报告给甲方那边之后，甲方又提出 **"不需要 big BUF 将输出负载能力提升到 20 pF，而是在 `EN_BUF = 1` 时直接将输出从 1.25V-level 通过 level shifter 转到 vbat-level (3.3V)"** ，无奈只能重新修改我们的输出缓冲：将原来的 big BUF 改为 level shifter (1.25 V to vbat)，这样 `CK_ADC_BUF` 和 `CK_OUT_BUF` 就是 vbat-level 的时钟输出。 

**注意 `CK_ADC_BUF` 和 `CK_OUT_BUF` 未经过超大缓冲器来提升带负载能力，驱动能力仍在 fF 级，不能直接带动 20 pF 负载。** 若要将其接到 PAD 用作测试，需要甲方这边自行添加较大的缓冲器 BUF (如果 PAD 前已经内置了 BUF 则无此问题)。



修改后的原理图如下：

<div class='center'>

| schematic of `202510_PLL_withDigitalLDO` <br> (将 LDO 与 `PLL_v3` 合并到一个 cell) | schematic of `202510_PLL_BUF_output_v2` <br> (也即 `PLL_v3` 中使用的 BUF cell, big BUF 被换为了 level shifter) |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-10-17-19-53_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-10-17-19-46_202510_onc18_CPPLL_ultra_low_lower (5) Project Report and Documents.png"/></div> |


</div>



全面的仿真在前文已经有了，我们这里只需简单验证一下使用 level shifter 后系统能否正常工作 (保持性能不变)。仿真设置和前仿结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-10-16-34-51_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-10-16-48-06_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

换为 level shifter 后，锁相环各项性能均与之前保持一致，几乎没有变化，满足需求方最新要求。


## 7. Testbench Instructions

### 7.1 testbench overview

我们这边交付给需求方的 lib 称为 `MyLib_202510_PLL_onc18__EX_20260110`，表示在 2026.01.10 导出的版本。该 lib 共包含三个 testbench cell, 分别为：
- `TB_PLL`： 单独对 PLL 进行仿真
- `TB_PLL_withDigitalLDO`：数字 LDO 和 PLL 的联合仿真，此时两部分还未合并到一个 cell 中
- `TB_TOP`： digital LDO 和 PLL 合并为一个 cell `202510_PLL_withDigitalLDO` 后，对整体进行仿真

它们的原理图在 **5.0 testbench** 一节中已经展示过，这里不再重复给出。TB 打开后直接运行即可，仿真变量命名都比较直观，可根据情况自行调整，也可参考本文档前面提到的各项仿真设置。

### 7.2 testbench explanations (updated on 2026.01.27)

下面是仿真变量即设置的一些详细说明。

先从需求方提到的 `TB_PLL_withDigitalLDO` 说起，这是数字 LDO 和 PLL 联合仿真的 testbench (两部分并未合并到一个 cell 中)，也就是 testbench schematic 中手动调用了 `vplus_gen_top` 和 `202510_PLL_v3` 两个 cell 进行仿真。`TB_PLL_withDigitalLDO` 的默认打开方式是 `ADE Assembler`，打开可以看到其中有多个仿真项 (每条都是一个 Explorer)，除一部分已废弃的之外，剩余几个只在 "高性能仿真模式设置" 上存在区别，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-27-23-31-14_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

然后在 ADE Assembler 视图，说明一下仿真变量的含义和设置：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-28-00-26-52_202510_onc18_CPPLL_ultra_low_lower (docs-3) 2026.01.06 锁相环前仿报告 CP-PLL pre-layout simulation report.png"/></div>

一般情况下，上述参数的值都不需要修改，直接运行仿真即可。

至于 outputs 中的一系列输出表达式/值是什么意思，我们已在前文介绍仿真结果 (的图片中) 时给出过详细说明，这里不再赘述。





## 8. Conclusion

本文档介绍了基于 ONC 180nm CMOS 工艺的 ultra-low-power CP-PLL 锁相环设计及其前仿结果。锁相环支持 32.768 kHz 参考时钟输入，提供四路输出时钟：一路 (称为 `CK_ADC`) 固定 98.304 kHz (X03) 作为 ADC 采样时钟，另一路 (称为 `CK_OUT`) 可配置为 98.304 kHz ~ 786.432 kHz (X03/X06/X12/X24) 四档频率；另外两路为 `CK_ADC_BUF` 和 `CK_OUT_BUF`，分别为 `CK_ADC` 和 `CK_OUT` 经过 level shifter (1.25 V to vbat) 后转到 vbat-level 的输出时钟。


尽管在 **1. PLL Overview and Interface Description** 一节中已经给出过锁相环的典型前仿性能，但这里还是再重复一次，方便总结和参考。锁相环设置为 **<span style='color:red'> `EN_BUF = 0, T<4:0> = <01111>, SL<1:0> = <11>` </span>** (CK_OUT = X24) 时的典型前仿性能如下：

$$
\begin{gather}
t_{lock} = 2.8 \ \mathrm{ms}  \\
I_{DD} = 333.2 \ \mathrm{nA} \,@\, \mathrm{40\ fF\ (per\ ch)} = 277.9 \ \mathrm{nA} \,@\, \mathrm{no\ load} \\
\mathrm{CK\_ADC:}\ \ J_{c,rms,ADC} = 20.45 \ \mathrm{ns},\ \ J_{e,rms,ADC} = 33.06 \ \mathrm{ns} \\
\mathrm{CK\_OUT:}\ \ J_{c,rms,OUT} = 4.334 \ \mathrm{ns},\ \ J_{e,rms,OUT} = 32.07 \ \mathrm{ns}
\end{gather}
$$

所设计的锁相环在所有 PVT (-20°C ~ 80°C, 1.20 V ~ 1.30 V, TT/SS/FF) 下均能正常锁定和输出，输出频率符合预期，功耗和时钟抖动也满足指标要求。



## Update History

- 2026.01.06: 完成前仿报告的最初版本
- 2026.01.10: 将 big BUF 改为 level shifter，并更新前仿结果
- 2026.01.13: 修正已发现的笔误或其它问题
- 2026.01.27: 补充 testbench 的详细说明，包括仿真设置与变量含义