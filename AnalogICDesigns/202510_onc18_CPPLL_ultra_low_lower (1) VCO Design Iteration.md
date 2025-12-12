# 202510_onc18_CPPLL_ultra_low_lower (1)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 22:05 on 2025-09-23 in Beijing.

>注：本文是项目 [Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology](<Projects/Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology.md>) 的附属文档，用于全面记录 PLL 的设计/迭代/仿真/版图/后仿过程。

## 1. Design Exploration

### 1.1 preliminary specs

2025.10.13 经过于导师的讨论，确定 PLL 的初步设计指标：

 PLL 初步设计指标：

<span style='font-size:10px'> 
<div class='center'>

| Reference Freq. | Output Freq. | RMS Cycle Jitter | RMS Cycle-to-Cycle Jitter | Static Current | External Supply | Corner ＆ Temperature |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 32.768 kHz | 5\*32.768 kHz ~ 20\*32.768 kHz <br> (163.84, 327.68, 655.36) | < 1% | < 1% | < 400nA | DC-DC 2.6V <br> Battery 1.6V ~ 3.3V | TT, SS, FF, SF, FS <br> **0°C ~ 60°C** |
</div>
</span>

其中：
- (1) 电池提供的 1.6V ~ 3.3V 外部电源，会经过 LDO (由我们自行设计) 降到合适电压后供给 PLL 使用，具体电压值需根据 VCO 的仿真情况来定
- (2) 总静态电流 400 nA 需包括 LDO 和整个 PLL, 一共三部分：(a) LDO 静态电流; (b) LDO 固有的空载电流; (c) LDO 供给 PLL 的电流
- (3) 也许可以考虑用两个 LDO 分别给 VCO 和 PFD/CP/FD 供电以隔离噪声影响，但面积增大，还得与需求方商量
- (4) 给 LDO 提供的外部参考为 VREF = 0.625V
- (5) 运放等模块 (可能需要的) 参考电流都由外部提供，如果方便，也可以自行集成在电路里 (例如用 2-T reference).


按甲方要求，配置工艺库如下：
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-15-12-04_202510_onc18_CPPLL_ultra_low_lower.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-11-48-19_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

### 1.2 structure options

锁相环考虑下面两种架构之一：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-00-17-41_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

我个人还是更倾向于第一种架构 (Type-II CP-PLL with CP Mismatch Cancellation)，一方面是这种结构更简单，也更接近我们之前做过的 CP-PLL；另一方面是第二种架构的 VREF 通常是数控的，这里纯模拟的话不好确定具体值。

## 2. RVCO exploration

我们先摸索摸索此工艺下 VCO 的性能参数，为环路设计 (主要是 LPF) 提供参考。

在系统总电流 400nA 的条件下，不妨先给 RVCO 分配 300nA, 对应到不同的输出频率，其频率密度要求 (freq_density) 如下：

<div class='center'>

| Output Frequency | 163.84kHz = 5\*32.768kHz | 327.68kHz = 10\*32.768kHz | 655.36kHz = 20\*32.768kHz |
|:-:|:-:|:-:|:-:|
 | Frequency Density | 2.1845 THz/A | 1.0923 THz/A | 0.5461 THz/A |
</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-00-48-25_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

考虑在以下条件进行前仿测试：
- using `nmos1p8v` and `pmos1p8v`
- IDD = 400 nA @ VCT = VDD - 0.1V
- VDD = 0.8V ~ 1.2V
- stage = 5, 7 or 9


先看一下环振性能与各参数间的关系：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-00-48-55_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-02-24-28_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-23-10-42_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-02-25-59_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-02-32-06_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-02-36-15_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-02-40-18_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-14-20-27_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

上面一系列仿真揭示出如下规律：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-14-24-30_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

由于现在需求方还没有确定输出频率到底要 5\*32.768kHz, 10\*32.768kHz 还是 20\*32.768kHz，因此对这几种情况都进行仿真测试 (其实工作量增加挺多的)。

## 3. RVCO Test (5-stage)


### 3.1 freq_density = 2THz/A


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-18-10-33_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-18-09-42_202510_onc18_CPPLL_ultra_low_lower.png"/></div>


### 3.2 freq_density = 1THz/A


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-18-12-04_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-18-11-15_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

### 3.3 freqDensity = 0.5THz/A

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-18-13-32_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-18-12-29_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

## 4. RVCO Test (7-stage)
### 4.1 freq_density = 2THz/A

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-18-03-57_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-17-58-03_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

### 4.2 freq_density = 1THz/A

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-18-02-33_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-18-02-02_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

### 4.3 freq_density = 0.5THz/A

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-18-07-07_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-18-05-51_202510_onc18_CPPLL_ultra_low_lower.png"/></div>



## 5. RVCO Summary


下表总结了 5-stage 和 7-stage 在不同输出频率下的结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-22-22-13_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-22-33-10_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

我们把每一种输出频率的 best points 挑出来做全温度-工艺角仿真。注意本次项目的温度范围是 0°C ~ 60°C 而不是 -40°C ~ 130°C.

设置全温度-工艺角如下：
- TT: 27°C
- SS: 0°C, 60°C
- FF: 0°C, 60°C
- worst RC (high R, low C)
- FS: 0°C, 60°C


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-23-12-51_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-23-16-45_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-23-17-12_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-23-31-21_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

嗯，可以看到，RVCO 各项参数随工艺波动不大，这与预期相符，毕竟我们的管子 gm/Id 算非常低了，所以工艺波动小。反相器管的 (gm/Id)_min = 1 ~ 3, 而电流管的 (gm/Id)_ave = 1 ~ 3, 像下图这样：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-14-23-39-30_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

<!-- <div class='center'>

| Target Frequency Range | Best Arguments | Performance | Note |
|:-:|:-:|:-:|:-:|
 | 0 ~ 1MHz |  |  |
 | 0 ~ 500kHz |  |  |
 | 0 ~ 200kHz |  |  |
</div> -->

## 6. RVCO Optimization

### 6.0 overview

我们在 **2. RVCO exploration** 一节给出了环振各参数与性能之间的影响关系，这里再放一遍：



### 6.1 duty cycle adjustment

VCO duty cycle ≠ 50% 时如何调整？一种方法是调整 VCO 输出 buffer (inverter) 的阈值电压来修正，考虑到版图一致性，只需加入一个电阻即可起到调节作用：加在 PMOS source 可以提高阈值电压从而降低占空比，加在 NMOS source 则相反，会降低阈值电压从而提高占空比。


需要注意，对于我们此次的 nA-level RVCO, 此电阻需达到 MOhm 量级才能对占空比产生明显影响。这么大的电阻会显著降低反相器的增益，因此这种方法对此次设计并不适用：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-01-11-11_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

另一种方法是在 VCO 的原始输出端 (未经输出 buffer) 处级联两组 buffer, 调整两个缓冲器内部 MOS 的并联和串联 (multiplier/series)  来修正占空比。当然，由于原始输出端驱动能力较差，第一缓冲级的 multiplier 不能太大。类似地，如果两级缓冲不能满足要求，可以再额外增加一个/多个缓冲，但是注意这会增加电路功耗 (降低 frequency density)。

下面是一个 series = 1 而调整 multiplier 的例子：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-01-16-12_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-01-24-47_202510_onc18_CPPLL_ultra_low_lower.png"/></div>


当然，我们也可以让 output buffer 的长宽与内部不同，通常在内部单元原有尺寸的基础上进行微调即可：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-01-29-34_202510_onc18_CPPLL_ultra_low_lower.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-01-50-16_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-01-49-05_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-01-57-00_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-02-04-45_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

顺便看一下三级 buffer 的效果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-02-08-11_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-02-10-22_202510_onc18_CPPLL_ultra_low_lower.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-02-11-54_202510_onc18_CPPLL_ultra_low_lower.png"/></div>

嗯，看来三级的效果确实不一定好，可能起不到降低占空比的作用。

### 6.2 jitter optimization

在频率密度 (frequency density) 非常高的情况下，我们振荡器的 jitter 很难达到 1% 的 RMS Jitter, 下面是 5-stage 和 7-stage 的 jitter 结果汇总：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-00-39-18_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

上图可以看出，即便在 VCT = VDD (频率最高，抖动性能最好) 时，不同尺寸振荡器下的 jitter 也才堪堪达到 1%；而在主要工作点 VCT = VDD/2 附近，jitter 便基本上在 2% ~ 5% 之间徘徊。



相比之下，正常功耗的 RVCO 更容易达到 1% 的 RMS Jitter, 下面是一个 4um/4um 和 8um/2um 的例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-23-52-20_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-23-50-26_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>




**<span style='color:red'> 但是注意：一方面我们要求的是 PLL rms jitter < 1% 而不是 VCO rms jitter < 1%, 另一方面 pnoise 的抖动结果会比 tran 的结果更高一些 (也可能高许多)</span>** , PLL/VCO 两者之间的抖动呈现一个什么关系？以及 pnoise/tran 的抖动结果相差多少？下面便来探讨一下。

先看看 tran 下的 jitter 仿真结果 (仿真设置中开启 transient noise 0 ~ 1GHz)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-00-52-24_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

将 pnoise 与 tran 的结果列成表进行对比：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-01-00-11_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

嗯，比例大概是 25:1 (Jc) 和 63:1 (Jcc) 这样子。

为了找到最佳 RVCO 参数，我们作如下遍历：
- stage = 5 (interactive.128) or 7 (interactive.129)
- VDD = 0.625, 0.7:0.1:1.1, 1.25
- LN = 1 : 1 : 14 (LP = LN)
- WN = 0.22 : 0.04 : 0.50 (WP = KA*WN)
- Else: **VCT = VDD - 0.1**, KA = 3, M1 = 1, M2 = 3

上面一共 2\*7\*14\*8 = 1568 个点，在 16 jobs 并行的情况下耗时 45 min。

仿真结束后，对这些结果进行筛选，将符合条件的结果导出到表中。表中可以看出, 5-stage 的抖动性能确实比 7-stage 好那么一点点，也就是同样的筛选条件下, 5-stage 符合要求的点更多一些。

由于筛选后数据量仍然较大，为挑选最合适的参数，我们列出每种条件下的几个 best points (按 RMS Jc 升序)：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-13-12-10_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>








## 7. Verilog-A Modeling

本小节基于上面的 RVCO 结果，对整个环路进行 Verilog-A 建模与仿真，以验证环路的可行性，同时确定 LPF 参数范围。

我们在 [Design of A Third-Order Type-II Integer-N CP-PLL](<Projects/Design of A Third-Order Type-II Integer-N CP-PLL.md>) 练手时已经给出了环路各个模块的 Verilog-A 代码，这里只需稍作修改： FD 原有代码其实仅适用于 even-divider (偶数分频) 的情况，这里先写出 odd-divider 的代码，然后改成自动识别奇偶分频方便后续使用。



### 7.1 FD (verilog-a)


下面是 Integer-N Frequency Divider (even/odd) 的 Verilog-A 代码：

```verilog
// This model exhibits no jitter
// modified by https://github.com/YiDingg (2025.10.15)

`include "disciplines.vams"

module FD_integer_N_va (VOUT, VIN);
    // external varible: VDD, N, EDGE
    output VOUT; voltage VOUT;              // output
    input VIN;   voltage VIN;               // input (edge triggered)
    
    parameter real      VDD     =   1       from [0:inf); 	// to be set in the "design varible"
    parameter real      vh      =   VDD;                    // output voltage high state
    parameter real      vl      =   0;                   	// output voltage low state
    parameter real      vth     =   VDD/2;          		// threshold voltage at input
    parameter integer   N       =   2       from [2:inf); 	// to be set in the "design varible"
    parameter integer   ratio   =   N; 				        // divide ratio
    parameter real      tt      =   0       from [0:inf);   // transition time of output signal
    parameter real      td      =   0       from [0:inf);   // average delay from input to output
    parameter integer   EDGE    =   1       from [-1:1] exclude 0; 	// to be set in the "design varible"
    parameter integer   dir     =   EDGE;							// EDGE=1 for positive edge trigger, EDGE=-1 for negative edge trigger

    integer count, n;
    integer count_p, count_n;
    integer clk_p, clk_n;
    integer is_odd;
    integer out_flag;
	integer out_count;
	integer dir_flag;
    real output_voltage;

    analog begin
        // Determine if N is odd or even
        is_odd = (ratio % 2 == 1);
        
        // Initialize variables
        @(initial_step) begin
            count = 0;
            n = 0;
            count_p = 0;
            count_n = 0;
            clk_p = 0;
            clk_n = 0;
            out_flag = 1;
			out_count = 1;
            output_voltage = vl;
        end

        // Even divider logic - single edge counting
        @(cross(V(VIN) - vth, dir)) begin
            if (!is_odd) begin
                count = count + 1;
                if (count >= ratio)
                    count = 0;
                n = (2*count >= ratio);
                output_voltage = n ? vh : vl;
            end
        end

        // Odd divider logic - both edges counting but output only updates on main edge
        @(cross(V(VIN) - vth, 1)) begin
            if (is_odd) begin
                if (dir == +1) begin
                    // Positive edge trigger: count_p on rising edge
                    count_p = count_p + 1;
                    if (count_p >= ratio) count_p = 0;
                    if (count_p == (ratio-1)/2 || count_p == ratio-1)
                        clk_p = !clk_p;
                end else begin
                    // Negative edge trigger: count_n on rising edge  
                    count_n = count_n + 1;
                    if (count_n >= ratio) count_n = 0;
                    if (count_n == (ratio-1)/2 || count_n == ratio-1)
                        clk_n = !clk_n;
                end
            end
        end
        @(cross(V(VIN) - vth, -1)) begin
            if (is_odd) begin
                if (dir == +1) begin
                    // Positive edge trigger: count_n on falling edge
                    count_n = count_n + 1;
                    if (count_n >= ratio) count_n = 0;
                    if (count_n == (ratio-1)/2 || count_n == ratio-1)
                        clk_n = !clk_n;
                end else begin
                    // Negative edge trigger: count_p on falling edge
                    count_p = count_p + 1;
                    if (count_p >= ratio) count_p = 0;
                    if (count_p == (ratio-1)/2 || count_p == ratio-1)
                        clk_p = !clk_p;
                end
            end
        end
	    // Update output voltage for odd divider on the main trigger edge
        @(cross(V(VIN) - vth, dir)) begin
            if (is_odd && clk_p || clk_n) begin output_voltage =  vh; end
        end

        @(cross(V(VIN) - vth, -dir)) begin
            if (is_odd && !(clk_p || clk_n)) begin output_voltage =  vl; end
        end

        // Final output transition
        V(VOUT) <+ transition(output_voltage, td, tt);

    end
endmodule

```

**<span style='color:red'> 注意上述代码中，需要用外部变量赋值的参数 (例如 dir) 不能设置 from 范围，否则会出问题。</span>**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-16-39-25_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>


### 7.2 PFD + CP (verilog-a)

下面是 Phase-Frequency Detector with Charge Pump 的 Verilog-A 代码：

``` verilog
// Phase-Frequency Detector with Charge Pump
//
// pfd_cp1: a simple three state phase-frequency detector
// pfd_cp2: a phase-frequency detector that exhibits Gaussian synchronous jitter
//
// Both charge pumps include an output clamp that encourages the output voltage to
// fall within the rails.
//
// Version 1e, 3 August 2010
//
// Ken Kundert (ken@designers-guide.com)
//
// Downloaded from The Designer's Guide Community (www.designers-guide.org).
// Post any questions to www.designers-guide.org/Forum

`include "disciplines.vams"
`include "constants.vams"

//
// This model exhibits no jitter
//

// modified by https://github.com/YiDingg (2025.10.15)
module PFD_CP_va (IOUT, VREF, VFB);	// external varible: IP, VDD, EDGE

output IOUT; electrical IOUT;   // current output
input  VREF; voltage    VREF;   // positive input (edge triggered)
input  VFB;  voltage    VFB;    // inverting input (edge triggered)

parameter real      IP      =   1u  from (0:inf);	    // to be set in the "design varible"
parameter real      iout    =   IP;		                // charge current
parameter real      VDD     =   1       from [0:inf); 	// to be set in the "design varible"
parameter real      vh      =   VDD;			        // input voltage in high state
parameter real      vl      =   0;			            // input voltage in low state
parameter real      vth     =   VDD/2;		            // threshold voltage at input
parameter real      tt      =   0       from [0:inf);	// transition time of output signal
parameter real      td      =   0       from [0:inf);	// average delay from input to output
parameter real      rclamp  =   100     from (0:inf);	// output clamp resistance
parameter integer   EDGE    =   1       from [-1:1] exclude 0; 	// to be set in the "design varible"
parameter integer   dir     =   EDGE;                           // dir=1 for positive edge trigger, dir=-1 for negative edge trigger
integer state;

analog begin
    // Implement phase detector
    @(cross(V(VREF)-vth, dir))
	if (state > -1) state = state - 1;
    @(cross(V(VFB)-vth, dir))
	if (state < 1) state = state + 1;

    // Implement charge pump
    I(IOUT) <+ transition(iout*state, td, tt);

    // Implement output clamp (optional)
    if (V(IOUT) > vh)
        I(IOUT) <+ (V(IOUT) - vh)/rclamp;
    else if (V(IOUT) < vl)
        I(IOUT) <+ (V(IOUT) - vl)/rclamp;

    // Add gmin to output to avoid convergence issues (optional)
    I(IOUT) <+ V(IOUT)/10T;
end
endmodule
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-17-44-44_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-17-44-17_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

### 7.3 VCO (verilog-a)

下面是 Voltage-Controlled Oscillator (Square Wave) 的 Verilog-A 代码：

``` verilog
// Voltage-controlled oscillator
//
// Version 1a, 1 June 04
//
// Ken Kundert
//
// Downloaded from The Designer's Guide Community (www.designers-guide.org).
// Post any questions on www.designers-guide.org/Forum.
// Taken from "The Designer's Guide to Verilog-AMS" by Kundert & Zinke.
// Chapter 3, Listing 22.


// modified by https://github.com/YiDingg (2025.10.15)
`include "disciplines.vams"
`include "constants.vams"

module VCO_square_va (OUT, VCONT); // external varible: VDD, KVCO, Fmin, Vin_min, Vin_max
    parameter real vin_min  =   0       from [0:inf);           // to be set in the "design varible"
    parameter real Vin_min  =   vin_min;                        // minimum input voltage (V)
    parameter real vin_max  =   0       from [0:inf);           // to be set in the "design varible"
    parameter real Vin_max  =   vin_max;                        // maximum input voltage (V)
    parameter real VDD      =   0.5     from (0:inf);           // maximum input voltage (V)
    parameter real fmin     =   1       from (0:inf);           // to be set in the "design varible"
    parameter real Fmin     =   fmin;                           // minimum output frequency (Hz)
    parameter real KVCO     =   1       from [0:inf);           // to be set in the "design varible"
    parameter real Fmax     =   fmin + KVCO*VDD;                // maximum output frequency (Hz)
    parameter real Vout_min =   0.0;                            // minimum output voltage (V)
    parameter real Vout_max =   VDD;                            // maximum output voltage (V)
    parameter real duty     =   0.5     from [0:1];             // duty cycle (0 to 1)

    input  VCONT; voltage VCONT;
    output OUT;   voltage OUT;
    real freq, phase;

    analog begin
        // compute the freq from the input voltage
        if (V(VCONT) > Vin_min && V(VCONT) < Vin_max) begin
            freq = (V(VCONT) - Vin_min)*(Fmax - Fmin) / (Vin_max - Vin_min) + Fmin;
        end else if (V(VCONT) <= Vin_min) begin
            freq = Fmin;
        end else if (V(VCONT) >= Vin_max) begin
            freq = Fmax;
        end

        // bound the frequency (optional)
        if (freq > Fmax) freq = Fmax;
        if (freq < Fmin) freq = Fmin;

        // phase is the integral of the freq modulo 2
        phase = 2*`M_PI*idtmod(freq, 0.0, 1.0, 0);
		
        // generate rectangular wave
        if (phase < 2*`M_PI*duty) V(OUT) <+ Vout_max;     	// High level
        if (phase > 2*`M_PI*duty) V(OUT) <+ Vout_min;       // Low level
		
        // generate sine wave
	    //V(OUT) <+ sin(phase);
		//V(OUT) <+ (phase < `M_PI) ? 1.0:0.0;

        // bound the time step to period/20
        $bound_step(0.05/freq);
    end
endmodule

```

瞬态仿真示例 (tran)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-19-39-46_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>


下面是 pss 和 pss-sweep 仿真示例, VCO 用了 onc18 RVCO 作为测试例子 (verilog 模型无法进行 pss 仿真)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-18-47-35_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-19-09-04_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

pnoise 和 pnoise-sweep 仿真示例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-15-23-11-55_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>



## 7.4 PFD (verilog-a) 

当然，有时候我们需要测试实际搭建的 Charge Pump, 这时候就需要单独的 PFD 模块：

``` verilog
// VerilogA for MyLib_verilog, PFD_va, veriloga

// modified by https://github.com/YiDingg (2025.10.28)

`include "constants.vams"
`include "disciplines.vams"

module PFD (REF, FB, UP, UPB, DN, DNB);
output UP, UPB, DN, DNB;
input REF, FB;
voltage UP, UPB, DN, DNB, REF, FB;

parameter real VDD          = 1       from (0:inf); 	// to be set in the "design varible"
parameter real vlogic_high  = VDD;                      // Logic high voltage
parameter real vlogic_low   = 0;                        // Logic low voltage
parameter real vth          = VDD/2;                    // Threshold voltage for cross detection
parameter real t_transi     = 1p      from (0:inf);     // transition time of output signal
parameter real t_delay      = 10p;                      // output delay time
parameter real minWidth     = 1n      from (0:inf); 	// to be set in the "design varible"
parameter real t_reset      = minWidth;                 // minimum pulse width (reset pulse width)
parameter integer EDGE      = 1       from [-1:1] exclude 0; 	// to be set in the "design varible"
parameter integer dir       = EDGE;                             // Edge detection direction: 1=rising, -1=falling

integer ref_state, fb_state;
integer up_state, dn_state;
integer reset_state;
real last_ref_edge, last_fb_edge;
real reset_start;

analog begin
    @(initial_step) begin
        ref_state = 0;
        fb_state = 0;
        up_state = 0;
        dn_state = 0;
        reset_state = 0;
        last_ref_edge = 0;
        last_fb_edge = 0;
        reset_start = 0;
    end

    // Detect edges of REF signal using cross function
    @(cross(V(REF) - vth, dir)) begin
        ref_state = 1;
        last_ref_edge = $abstime;
    end

    // Detect edges of FB signal using cross function
    @(cross(V(FB) - vth, dir)) begin
        fb_state = 1;
        last_fb_edge = $abstime;
    end

    // Clear edge detection states
    if (ref_state == 1 && (dir > 0 ? V(REF) < vth : V(REF) > vth)) begin
        ref_state = 0;
    end

    if (fb_state == 1 && (dir > 0 ? V(FB) < vth : V(FB) > vth)) begin
        fb_state = 0;
    end


    // PFD state machine
    if (reset_state == 0) begin
        // Normal detection mode
        if (last_ref_edge > last_fb_edge && up_state == 0) begin            // REF lags FB
            up_state = 1;
            reset_start = $abstime;
        end else if (last_ref_edge < last_fb_edge && dn_state == 0) begin   // REF leads FB
            dn_state = 1;
            reset_start = $abstime;
        end else if (last_ref_edge != 0 && last_fb_edge != 0 && last_ref_edge == last_fb_edge && up_state == 0 && dn_state == 0) begin	// REF = FB
			up_state = 1;
			dn_state = 1;
			reset_start = $abstime;
		end
        
        // Enter reset state when both UP and DN are high
        if (up_state == 1 && dn_state == 1) begin
            reset_state = 1;
        end
    end else begin
        // Reset mode
        if ($abstime - reset_start > t_reset) begin
            up_state = 0;
            dn_state = 0;
            reset_state = 0;
            last_ref_edge = 0;
            last_fb_edge = 0;
        end
    end

    // Output signal generation
    V(UP)  <+ transition(up_state ? vlogic_high : vlogic_low, t_transi, t_delay);
    V(UPB) <+ transition(up_state ? vlogic_low : vlogic_high, t_transi, t_delay);
    V(DN)  <+ transition(dn_state ? vlogic_high : vlogic_low, t_transi, t_delay);
    V(DNB) <+ transition(dn_state ? vlogic_low : vlogic_high, t_transi, t_delay);
end
endmodule
```


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-28-16-09-24_202510_onc18_CPPLL_ultra_low_lower (1) VCO Design Iteration.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-28-16-12-16_202510_onc18_CPPLL_ultra_low_lower (1) VCO Design Iteration.png"/></div>

## 8. PLL loop veri.

下面我们对整个环路进行测试。环路中仅有 VCO 用实际模块，其他模块均用 Verilog-A 模型：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-16-33-00_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

### 8.1 simple test

利用 MATLAB 寻求一个满足收敛条件的环路参数：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-16-42-44_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>


这里采用 **5-stage options for 655.36 kHz @ 2.1845 THz/A (> 2.4 THz/A)** 的其中一个 VCO, 结合下面参数进行全工艺角仿真：
- 5-stage, N = 20, VDD = 0.7, LN = 3, WN = 0.34
- I_P = 5n, R1 = 10M, C1 = 2p (C2 = C1/10)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-16-41-08_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-16-59-47_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-17-04-47_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

### 8.2 parameter sweep

仍采用上面的 VCO 设置，设置环路参数范围进行扫描：
- I_P = 2n, 4n, 6n, 10n
- C1 = 1p, 2p, 4p, 6p, 10p (C2 = C1/10)
- R1 = 1M, 2M, 4M, 5M, 7M, 10M

仿真结束后对结果进行筛选，如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-16-53-24_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

这个结果主要是给环路参数取值作参考。

### 8.3 all-freq-range test

看一下 5-stage 适用于 655.36 kHz 的两个 VCO 在低频的抖动表现如何 (全工艺角)：

- first VCO: VDD = 0.7, LN = 3, WN = 0.34
- second VCO: VDD = 0.625, LN = 2, WN = 0.22
- I_P = 6n, R1 = 10M, C1 = 6p (C2 = C1/10)
- sweep N = 5, 10, 20 (all-corner)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-17-33-30_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-17-39-17_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-17-40-37_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

嗯，这俩 VCO 在低频下的抖动表现都还不错 (甚至更好)。如何解释低频时 VCO 相噪/抖动升高，环路抖动反而下降了呢？初步猜测是因为：PLL 环路对 VCO 的相噪表现为高通，也就是抑制低频相噪，当输出频率降低时，整个环路的相噪积分范围 "变小"，使得环路抖动反而下降。

## 9. Large Resistor Options

### 9.1 high-res resistor

最简单的方法就是用方块电阻较高的器件来实现大电阻，我们已经在文章 [Basic Information of onc18 (ONC 180nm CMOS Process Library)](<AnalogICDesigns/Basic Information of onc18 (ONC 180nm CMOS Process Library).md>) 中给出了 onc18 中的全部电阻器件参数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-22-00-51_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

其中电阻密度最高的是 `rnwsti` (950 ohm/sq) 和 `rppolyhr` (1037 ohm/sq), 我们看一下它们实现 10M 电阻需要多大面积：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-22-06-25_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

噢？后者 `rppolyhr` (1037 ohm/sq) 所需面积出乎意料地小，只需 40um*115um = 4600um², 与旁边的 6pf cmimhc 电容面积接近。

看来用 `rppolyhr` 来实现大电阻是个不错的选择，我们不妨也试试其它方法，见后几个小节。



### 9.2 diode-connected MOS

先用一个 diode-connected NMOS/PMOS 作为等效电阻试试水，仿真看一下什么尺寸比较合适：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-19-28-57_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

我们选择 fingerW/L = 4u/0.18u (finger = 10, multiplier = 3) 的 PMOS 作为等效电阻，其在 2nA ~ 8.5nA 时呈现 20M ~ 10M 的等效电阻。

将电阻换为这个 PMOS 看一下 PLL 的表现：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-20-56-29_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-22-09-07_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-22-11-16_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

啊哈，比较尴尬的是，采用这种方法的 "等效电阻" 完全无法工作。这是 diode-connected MOS 管在极低电流下两端无法降到零电压导致的。

这并不是说 diode-connected MOS 就完全不能用作大电阻了，而是它仅能用于完全静态的场合 (例如给 LDO 提供空载电流)，对于 charge pump 这种动态场合就不适用了。

### 9.3 linear-region MOS

这一小节讨论一下栅极接到 VDD/VSS, 处于线性区的 MOS 管能呈现多少电阻：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-22-35-03_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-22-34-27_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>
 -->


嗯，在宽长比 a = W/L 特别小的情况下，倒也不是不能实现大电阻。并且这里的 gmId_max 也算比较小，工艺角波动应该比较小，我们看一下是不是这样：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-22-53-39_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

嗯，工艺角波动确实还好。

**<span style='color:red'> 但是：我们这里其实不能用这种方式来实现大电阻，因为我们需要能够双向流动的电流！ </span>** 即便把 linear-region NMOS source 接到 VSS 当作电阻，电容放在电阻上面，也只能给电容充电而无法放电。能否再添加一个 PMOS 提供放电路径？我们试了一下，应该是不行的。

### 9.4 other techniques

详见文章 [Large Resistor Implementation Techniques for Low-Power Analog IC Designs](<AnalogICDesigns/Large Resistor Implementation Techniques for Low-Power Analog IC Designs.md>)

## To be continued...



