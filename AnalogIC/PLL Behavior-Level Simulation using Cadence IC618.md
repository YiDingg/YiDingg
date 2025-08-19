# PLL Behavior-Level Simulation using Cadence IC618

> [!Note|style:callout|label:Infor]
Initially published at 13:57 on 2025-08-16 in Lincang.

## Introduction

本文的主要目的是对文章 [Design Sheet for Third-Order Type-II CP-PLL](<AnalogICDesigns/Design Sheet for Third-Order Type-II CP-PLL.md>) 中的理论结果做一个的仿真验证，让我们 "有信心" 正式去设计一个 PLL 系统，后续详见 [Design of A Third-Order Type-II Integer-N CP-PLL](<Projects/Design of A Third-Order Type-II Integer-N CP-PLL.md>)。 类似的仿真验证还有 [PLL System-Level Simulation using LTspice](<AnalogIC/PLL System-Level Simulation using LTspice.md>)。

## 1. Create Verilog-A Module

Verilog-AMS 模数混合仿真的教程见 [Virtuoso Tutorials - 11. Behavior-Level Simulation using Verilog-A in Cadence IC618](<AnalogIC/Virtuoso Tutorials - 11. Behavior-Level Simulation using Verilog-A in Cadence IC618.md>), 我们直接在网站 [The Designer's Guide Community > Verilog-AMS Models](https://designers-guide.org/verilog-ams/index.html) 下载所需模型，然后对模型参数作适当修改，修改后的代码如下：


### 1.1 PFD + CP



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

// modified by https://github.com/YiDingg (2025.08.16)
module PFD_CP_100uA (VOUT, VREF, VFB);

output VOUT; electrical VOUT;		// current output
input VREF; voltage VREF;			// positive input (edge triggered)
input VFB; voltage VFB;			// inverting input (edge triggered)
parameter real iout=100u;		// maximum output current
parameter real vh=+1;			// input voltage in high state
parameter real vl=0;			// input voltage in low state
parameter real vth=(vh+vl)/2;		// threshold voltage at input
parameter integer dir=1 from [-1:1] exclude 0;
					// dir=1 for positive edge trigger
					// dir=-1 for negative edge trigger
parameter real tt=1n from (0:inf);	// transition time of output signal
parameter real td=1p from [0:inf);	// average delay from input to output
parameter real rclamp=100 from (0:inf);	// output clamp resistance
integer state;

analog begin
    // Implement phase detector
    @(cross(V(VREF)-vth, dir))
	if (state > -1) state = state - 1;
    @(cross(V(VFB)-vth, dir))
	if (state < 1) state = state + 1;

    // Implement charge pump
    I(VOUT) <+ transition(iout*state, td, tt);

    // Implement output clamp (optional)
    if (V(VOUT) > vh)
        I(VOUT) <+ (V(VOUT) - vh)/rclamp;
    else if (V(VOUT) < vl)
        I(VOUT) <+ (V(VOUT) - vl)/rclamp;

    // Add gmin to output to avoid convergence issues (optional)
    I(VOUT) <+ V(VOUT)/1T;
end
endmodule
```

### 1.2 VCO

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


// modified by https://github.com/YiDingg (2025.08.16)
`include "disciplines.vams"
`include "constants.vams"

module VCO__square_1Gto2G_1GperV (OUT, VCONT);
    parameter real Vin_min=0.0;                       // minimum input voltage (V)
    parameter real Vin_max=1.0 from (Vin_min:inf);    // maximum input voltage (V)
    parameter real Fmin=1e9 from (0:inf);             // minimum output frequency (Hz)
    parameter real Fmax=2e9 from (Fmin:inf);          // maximum output frequency (Hz)
    parameter real Vout_min=0.0;                      // minimum output voltage (V)
    parameter real Vout_max=1.0 from (Vout_min:inf);  // maximum output voltage (V)
    parameter real duty=0.5 from [0:1];               // duty cycle (0 to 1)
    input VCONT; output OUT;
    voltage OUT, VCONT;
    real freq, phase;

    analog begin
        // compute the freq from the input voltage
        freq = (V(VCONT) - Vin_min)*(Fmax - Fmin) / (Vin_max - Vin_min) + Fmin;

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

### 1.3 FD 

``` verilog
// Frequency dividers
//
// divider1: a simple frequency divider
// divider2: a frequency divider that exhibits gaussian synchronous jitter
//
// Version 1d, 16 June 2024
//
// Ken Kundert, Hua Li
//
// Downloaded from The Designer's Guide (www.designers-guide.org).
// Post any questions to www.designers-guide.org/Forum

`include "disciplines.vams"

//
// This model exhibits no jitter
//
// modified by https://github.com/YiDingg (2025.08.16)
module FD_Integer_64 (VOUT, VIN);

output VOUT; voltage VOUT;                // output
input VIN; voltage VIN;                   // input (edge triggered)
parameter real vh=1;                   // output voltage VIN high state
parameter real vl=0;                   // output voltage VIN low state
parameter real vth=0.5;           // threshold voltage at input
parameter integer ratio=64 from [2:inf); // divide ratio
parameter integer dir=1 from [-1:1] exclude 0;
                                        // dir=1 for positive edge trigger
                                        // dir=-1 for negative edge trigger
parameter real tt=1n from (0:inf);      // transition time of output signal
parameter real td=1p from [0:inf);       // average delay from input to output
integer count, n;

analog begin
    @(cross(V(VIN) - vth, dir)) begin
        count = count + 1;
        if (count >= ratio)
            count = 0;
        n = (2*count >= ratio);
    end
    V(VOUT) <+ transition(n ? vh : vl, td, tt);
end
endmodule
```


## 2. Behavior-Level Simulation

### Divide-N = 2

搭建仿真电路：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-00-26-32_PLL Behavior-Level Simulation using Cadence IC618.png"/></div>

尝试如下参数进行仿真：

$$
\begin{gather}
N = 2,\ f_{in} = 0.75 \ \mathrm{GHz},\ C_P = 5 \ \mathrm{pF},\ R = 5 \ \mathrm{k}\Omega
\\
\Longrightarrow 
\tau_P = 2.5e-08,\ K = 3.9789e+07,\ \zeta = 0.4987,\ \frac{f_{BW}}{f_{REF}} = 570.3438,\ \frac{\pi}{\omeg_{in}\tau_P} = 0.0133 < 0.366
\end{gather}
$$

RP = 5k and CP = 10p 仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-01-56-34_PLL Behavior-Level Simulation using Cadence IC618.png"/></div>

降低 $C_P$ 使 $\mathrm{ratio} = \frac{\omega_{in}}{\omega_{BW}}$ 降低时，相当于 $\omega_{BW}$ 增大，系统响应变快，锁定时间更短。但是降低 $C_P$ 也会导致 $\zeta$ 变小，系统的阻尼比降低，锁定时间更长。因此最佳的 $C_P$ (或者 $R_P$) 值需要通过细致的仿真来确定。


RP = 5k and CP = 2p:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-01-59-30_PLL Behavior-Level Simulation using Cadence IC618.png"/></div>

从 Vcont 的 1% settling time 来看锁定变快，但是 0.05% settling time 却反而变长了。






### Divide-N = 8

RP = 5k and CP = 10p:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-02-05-19_PLL Behavior-Level Simulation using Cadence IC618.png"/></div>

RP = 5k and CP = 2p:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-02-11-12_PLL Behavior-Level Simulation using Cadence IC618.png"/></div>

### Divide-N = 64

先试试项目原文章 [GitHub > Analog-Design-of-1.9-GHz-PLL-system](https://github.com/muhammadaldacher/Analog-Design-of-1.9-GHz-PLL-system) 中的参数：

RP = 6.5k and CP = 100p:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-02-23-10_PLL Behavior-Level Simulation using Cadence IC618.png"/></div>

上图可以看出，我们的波形和锁定时间与原文基本一致。并且从 zeta, ratio, discrete 的值来看，原文的参数设置从理论上算是比较合理的 (如果不认为 100 pF 会占据过多面积的话)。


不妨再修改阻容参数看看结果, RP = 6.5k and CP = 20p:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-17-02-31-03_PLL Behavior-Level Simulation using Cadence IC618.png"/></div>