# Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 13:48 on 2026-02-04 in Lincang.
> dingyi233@mails.ucas.ac.cn

## Introduction

最近在做一个 56-Gbaud Quarter-Rate PAM3 CDR 的项目，需要在 cadence virtuoso 中用 Verilog-A 来建模一些 SerDes 中常用的模块。本文总结/记录了这些模块的 Verilog-A 建模方法，供大家参考。

首先是基本逻辑门和基本模块：
- **(1) Basic logic gates and modules: (高低电平电压由 parameter 定义)**
    - BUF, INV, AND, NAND, OR, NOR, XOR, XNOR, TG (transmission gate)
    - MUX2, SRL (Gated SR-Latch), DL (Gated D-Latch), DFF (D-FlipFlop)
- **(2) Basic logic gates with VSS and VDD pins:**
    - BUF, INV, AND, NAND, OR, NOR, XOR, XNOR, TG (transmission gate)
    - MUX2, SRL (Gated SR-Latch), DL (Gated D-Latch), DFF (D-FlipFlop)
- **(3) High-speed CML (Current Mode Logic) with VSS and VDD pins:**
    - BUF, INV, AND, NAND, OR, NOR, XOR, XNOR
    - MUX2, SRL (Gated SR-Latch), DL (Gated D-Latch), DFF (D-FlipFlop)

其次是一些常用的 SerDes/Wireline 模块：
- (1) Ideal ADC (Analog to Digital Converter) and DAC (Digital to Analog Converter)
- (2) Ideal VCO (Voltage Controlled Oscillator) and Jittered VCO (with phase noise/jitter)

xxx
- (7) PRBS (Pseudo-Random Bit Sequence) and PRTS (Pseudo-Random Ternary Sequence) generator
- (8) PLL (Phase-Locked Loop) and DLL (Delay-Locked Loop)
- (9) Alexander-PD (Alexander Phase Detector) and CDR (Clock and Data Recovery)
- (10) Simple LPF (first-order low-pass filter)
- (11) Simple CTLE (Continuous-Time Linear Equalizer)
- (12) Simple DFE (Decision Feedback Equalizer)
- (13) NRZ/PAM3 and PAM3/NRZ Converter
- (14) NRZ/PAM4 and PAM4/NRZ Converter




## 1. Basic Syntax of Verilog-A 



## 2. Verilog-A Tips and Attentions

### 2.0 basic tips/attentions

下面是一些在 Verilog-A 建模过程中建议遵循的基本原则和注意事项：
- 尽量不要用节点电压直接参与运算，而是将输入端口赋值到一个 real 变量，再用该变量参与运算；同时，输出端口的电压统一在 analog 块的最后通过 `V(out) <+ ...` 语句赋值 (避免出现奇怪的仿真错误)。


### 2.1 attention when using transition() 

假设 `VDD` 是外部的供电输入，不要用下面这种语句，尤其是 VDD 非理想定值 (具有瞬态噪声时或纹波时)：
``` verilog
module VA_LogicVDD_INV (Y, A, VSS, VDD);
// ......
analog begin
    // ......
    V(Y) <+ transition(V(VDD), t_delay, t_rise, t_fall );
end
endmodule
```

这是因为当 `V(Y) <+ transition(V(VDD), t_delay, t_rise, t_fall );` 语句直接放在了 `analog` 块里，意味着 **"此语句恒成立"** ，也就是 `V(VDD)` 每发生一次变化 (一个仿真步长)，`V(Y)` 就会经过一次 `transition()` 更新，无数个 `transition()` 语句叠加起来，导致仿真步长极小 (fs-level) 且仿真极慢，本来几十 ms 就能仿完的事情，可能需要几分钟甚至几十分钟。

类似地，不要将任何节点的 transition 直接放在 `analog` 块中 (恒成立)，而是要放在控制语句里。

那么解决办法是什么呢？这里给出一种思路：

``` verilog
`include "constants.vams"
`include "disciplines.vams"

module VA_LogicVDD_INV (Y, A, VSS, VDD);

input A, VSS, VDD; 
output Y;
voltage A, Y, VSS, VDD;

parameter real t_delay = 1p from (0:inf);	// delay to start of output transition
parameter real t_rise = 1p from (0:inf);	// rise time of output signals
parameter real t_fall = 1p from (0:inf);	// fall time of output signals
real vin_th; 
integer logic_out;

analog begin
    vin_th = (V(VDD) + V(VSS))/2;
    @(cross(V(A) - vin_th)); // make sure simulator sees the threshold crossing

    if (V(A) < vin_th) logic_out = 1; else logic_out = 0;  // INV operation
    V(Y) <+ V(VDD) * transition(logic_out, t_delay, t_rise, t_fall); // output transition
end
endmodule
```


### 2.2 syntax error of "electrical"

在 `electrical` 处报错说 `syntax error` 而没有其它任何提示信息时，一般是忘记 include 头文件 ``include "disciplines.vams"`， 导致 `electrical` 关键字无法识别，加上即可。


### 2.3 Circular Integrator Operator `idtmod`

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-01-48-31_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-01-49-09_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div>


### 2.4 Event Control with `cross()`
### 2.5 Random Num Generator `$rdist_normal()`


## 3. Basic Logic Gates and Modules

### 3.1 basic logic gates 

注意 `cell name` 和 veriloga 中的 `module name` 必须相同，否则会影响其它文件调用该模块时的识别。举个例子，如果 `cell name = VA_Logic_TG` 而 `module name = TG`，那么使用了此 TG (实例化) 的 MUX2 代码仿真时就会报错：

``` bash
ERROR (SFE-23): "/data/Work_dy2025/Cadence_Projects/MyLib_verilog/VA_Logic_analogMUX2/veriloga/veriloga.va" 48: The instance `tg0' is referencing an undefined model or subcircuit, `VA_Logic_TG'. Either include the file containing the definition of `VA_Logic_TG', or define `VA_Logic_TG' before running the simulation.

ERROR (SFE-23): "/data/Work_dy2025/Cadence_Projects/MyLib_verilog/VA_Logic_analogMUX2/veriloga/veriloga.va" 61: The instance `tg1' is referencing an undefined model or subcircuit, `VA_Logic_TG'. Either include the file containing the definition of `VA_Logic_TG', or define `VA_Logic_TG' before running the simulation.
```

构建得到一系列基本逻辑门模块，这里给出 `NAND` 的代码作为示例，其他逻辑门类似：

``` verilog
`include "disciplines.vams"

// 2-input Nand gate

module VA_Logic_NAND (Y, A, B);

output Y; voltage Y;
input A, B; voltage A, B;
parameter real vout_high = 1;			// output voltage in high state
parameter real vout_low = 0;			// output voltage in low state
parameter real vin_th = (vout_high + vout_low)/2;	// threshold voltage at inputs
parameter real t_delay = 1p from [0:inf);	// delay to start of output transition
parameter real t_rise = 1p from [0:inf);	// rise time of output signals
parameter real t_fall = 1p from [0:inf);	// fall time of output signals

analog begin
    @(cross(V(A) - vin_th) or cross(V(B) - vin_th));
    V(Y) <+ transition( !((V(A) > vin_th) && (V(B) > vin_th)) ? vout_high : vout_low, t_delay, t_rise, t_fall );
end
endmodule
```



### 3.2 MUX2

依据如下 MUX2 原理图进行 Verilog-A 建模 (在 verilog-a 中进行实例化和连接)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-04-18-17-34_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div>

所得 MUX2 代码如下：

``` verilog
`include "constants.vams"
`include "disciplines.vams"

// 2:1 Analog Multiplexer (MUX) using Transmission Gates
// when SL = 0, Y = A0; when SL = 1, Y = A1

module analog_MUX2(A0, A1, SL, Y);
input SL;
inout A0, A1, Y;
electrical A0, A1, SL, Y;

// Parameters matching the required naming convention
parameter real vout_high = 1.0;       // High output voltage level
parameter real vout_low = 0.0;        // Low output voltage level
parameter real SL_th = 0.5;           // Select signal threshold
parameter real R_on = 100;            // TG ON resistance
parameter real R_off = 1G;            // TG OFF resistance
parameter real C_parallel = 1f;       // TG parasitic capacitance
parameter real t_delay = 1p;          // TG delay time
parameter real t_trans = 1p;          // TG transition time
parameter real t_rise = 1p;         // INV rise time
parameter real t_fall = 1p;         // INV fall time

// Internal signal
electrical SLB;

// Instantiate inverter with specified parameters
VA_Logic_INV #(
    .vout_high(vout_high),     // Using vout_high parameter
    .vout_low(vout_low),       // Using vout_low parameter
    .vin_th(SL_th),
    .t_delay(t_delay),
    .t_rise(t_rise),
    .t_fall(t_fall)
) inv0 (
    .A(SL),
    .Y(SLB)
);

// Instantiate transmission gates
VA_Logic_TG #(
    .EN_th(SL_th),
    .R_on(R_on),
    .R_off(R_off),
    .t_delay(t_delay),
    .t_trans(t_trans),
    .C_parallel(C_parallel)
) tg0 (
    .A(A0),
    .B(Y),
    .EN(SLB)
);

VA_Logic_TG #(
    .EN_th(SL_th),
    .R_on(R_on),
    .R_off(R_off),
    .t_delay(t_delay),
    .t_trans(t_trans),
    .C_parallel(C_parallel)
) tg1 (
    .A(A1),
    .B(Y),
    .EN(SL)
);

endmodule
```


### 3.3 SRL (Gated SR-Latch)

依据如下原理图对 Gated SR-Latch 进行建模 (在 verilog-a 中进行实例化和连接)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-04-18-25-00_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div>


仿真发现用 NAND 来直接构建 SRL 的这种方式行不通，要么是报错说 `FATAL: The following branches form a loop of rigid branches (shorts) when added to the circuit:` (构成了不合理的刚性短路)，要么是 DC point 计算不收敛。

试了很多方法，还是行不通，没办法，最终只能用 behavior-level model 来实现 SRL，代码如下：

``` verilog
`include "constants.vams"
`include "disciplines.vams"


// Verilog-A model for Gated SR-Latch (SRL) 
module VA_Logic_SRL(S, R, EN, Q, QB);
input S, R, EN;
output Q, QB;
electrical S, R, EN, Q, QB;

parameter real vout_high = 1.0;
parameter real vout_low = 0.0;
parameter real t_delay = 1p;
parameter real t_rise = 1p;
parameter real t_fall = 1p;

real vth;
integer q_state, qb_state;  // Using reg type for state storage

analog begin
    vth = (vout_high + vout_low) / 2.0;
    
    @(initial_step) begin
        if (V(EN) > vth) begin
            if (V(S) > vth && V(R) < vth) begin // SR = 10 (Set)
                V(Q) <+ vout_high;
                V(QB) <+ vout_low;
            end else if (V(S) < vth && V(R) > vth) begin // SR = 01 (Reset)
                V(Q) <+ vout_low;
                V(QB) <+ vout_high;
            end else begin // SR = 00 (Hold) or SR = 11 (Invalid)
                V(Q) <+ vout_low;
                V(QB) <+ vout_high;
            end
        end else begin
            // When EN is low at the start, initialize outputs to low
            V(Q) <+ vout_low;
            V(QB) <+ vout_high;
        end
    end
    
    // Continuous evaluation
    if (V(EN) > vth) begin
        // Latch enabled
        if (V(S) > vth && V(R) < vth) begin // SR = 10 (Set)
            q_state = 1;
            qb_state = 0;
        end
        if (V(S) < vth && V(R) > vth) begin // SR = 01 (Reset)
            q_state = 0;
            qb_state = 1;
        end
        //if (V(S) > vth && V(R) > vth) begin // SR = 11 (Invalid)
            // Maintain previous state (do nothing)
        //end
        // S=0, R=0: hold state (do nothing)
    end
    // EN=0: hold state (do nothing)
    
    V(Q) <+ transition(q_state ? vout_high : vout_low, 2*t_delay, t_rise, t_fall);
    V(QB) <+ transition(qb_state ? vout_high : vout_low, 2*t_delay, t_rise, t_fall);
end

endmodule
```

特别地，如果仅仅是遇到 dc point 不收敛的问题，可以参考 [Boise State University > Behavioral Modeling using Verilog-A](https://www.eecis.udel.edu/~vsaxena/courses/ece518/Handouts/VerilogA%20Modeling.pdf) 的 page.8, 为瞬态或其它仿真勾选 `Options > Algorithm > skipdc = yes`，这样就能跳过 dc point 的计算，直接进行瞬态仿真。




### 3.4 DL (Gated D-Latch)

D-Latch 当然也可以直接用代码来描述 behavior-level 行为，但为了更好地模拟实际电路的延迟，这里利用 SRL (Gated SR-Latch) 和 INV 对 Gated D-Latch 进行建模，原理图如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-04-18-54-23_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div>

然后是 `DL_with_set_reset`，也即 Gated D-Latch with **asynchronous** set and reset, 原理图如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-04-21-59-39_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div>





### 3.5 DFF (D-FlipFlop)

类似地，DFF 我们也不直接用代码描述，而是用两个 DL (Gated D-Latch) 构成 master-slave 结构，便可实现 D-FlipFlop，原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-04-18-58-28_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div>




### 3.6 simulation verification


<div class='center'>

|  |  |
|:-:|:-:|
 | Testbench 原理图 | Testbench 仿真设置 |
 | Basic Logic Gates 仿真结果 (BUF, INV, AND, NAND, OR, NOR, XOR, XNOR) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-05-00-10-18_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> | Basic Logic Gates 仿真结果 (SW, TG, MUX2) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-05-00-14-10_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> |
 | Basic Logic Modules 仿真结果 (SRL, DL, DFF, DFF_rst) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-05-00-18-15_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div>|  |
</div>


## 4. Ideal ADC and DAC
## 5. Ideal and Jittered VCO

### 5.1 Ideal VCO (without jitter)

**Ideal VCO (without jitter)** 的 Verilog-A 代码如下：

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



/* modified by YiDingg 2025.10.15 (https://github.com/YiDingg) */
/* 
updated by YiDingg on 2026.02.02 (https://www.zhihu.com/people/YiDingg)
- Changed the output waveform from ideal square wave to cosine-shaped rise/fall edges to better match real VCO behavior.
- Added parameters to set output voltage levels (vout_low, vout_high) and (relative) rise/fall time (t_tans_rela).
- The rise/fall time is defined as a fraction of the oscillation period (0 to 0.5).
- The output transitions are now cosine-shaped for smoother edges.
*/

`include "disciplines.vams"
`include "constants.vams"

module VA_VCO_cosine (OUT, VCONT); // external varible: VDD, KVCO, F_min, VIN_min, VIN_max
/* To be set in the "design variable" section of the testbench */
    parameter real vin_min   =   0       from [0:inf);           // minimum input voltage (V)
    parameter real vin_max   =   0       from [0:inf);           // maximum input voltage (V)
    parameter real vout_low  =   0       from [0:inf);           // minimum output voltage (V)
    parameter real vout_high =   0       from [0:inf);           // maximum output voltage (V)
    parameter real fmin      =   1       from (0:inf);           // minimum output frequency (Hz)
    parameter real kvco      =   1       from [0:inf);           // VCO gain (Hz/V)
    parameter real duty      =   0.5     from [0:1];             // output duty cycle (0 to 1)
    parameter real t_tans_rela    =   0.1     from (0:0.5];           // rise time as fraction of period (0-0.5)

/* Actual used parameters in the model */
    parameter real VIN_min   =   vin_min;                         // minimum input voltage (V)
    parameter real VIN_max   =   vin_max;                         // maximum input voltage (V)
    parameter real F_min     =   fmin;                            // minimum output frequency (Hz)
    parameter real F_max     =   fmin + kvco*(vin_max - vin_min); // maximum output frequency (Hz)
    parameter real VOUT_low  =   vout_low;                        // low level of output voltage (V)
    parameter real VOUT_high =   vout_high;                       // high level of output voltage (V)
    parameter real KVCO      =   kvco;                       // VCO gain (Hz/V)
    parameter real T_trans     =   t_tans_rela;                           // rise time fraction

    input VCONT; voltage VCONT;
    output OUT; voltage OUT;
    real freq, phase, normalized_phase;
    real voltage_range, midpoint;
	real cosine_phase;
	real adjusted_phase;
    real rise_start ;
    real rise_end   ;
    real fall_start ;
    real fall_end   ;

    analog begin
        // compute the freq from the input voltage
        if (V(VCONT) > VIN_min && V(VCONT) < VIN_max) begin
            freq = (V(VCONT) - VIN_min)*(F_max - F_min) / (VIN_max - VIN_min) + F_min;
        end else if (V(VCONT) <= VIN_min) begin
            freq = F_min;
        end else if (V(VCONT) >= VIN_max) begin
            freq = F_max;
        end

        // bound the frequency (optional)
        if (freq > F_max) freq = F_max;
        if (freq < F_min) freq = F_min;

        // phase is the integral of the freq modulo 2
        phase = 2*`M_PI*idtmod(freq, 0.0, 1.0, 0);
        
        // Normalize phase to [0, 1]
        normalized_phase = phase / (2*`M_PI);
        
        voltage_range = VOUT_high - VOUT_low;
        midpoint = (VOUT_high + VOUT_low) / 2.0;
        
        // Calculate rise and fall points
        rise_start = duty - T_trans/2.0;
        rise_end = duty + T_trans/2.0;
        fall_start = 1.0 - T_trans/2.0;
        fall_end = T_trans/2.0;
        
        // Handle wrap-around for fall transition
        if (rise_start < 0) rise_start = rise_start + 1.0;
        if (rise_end > 1.0) rise_end = rise_end - 1.0;
        
        // Generate output with cosine transitions
        if (T_trans > 0) begin
            // Rising edge (cosine shape)
            if (normalized_phase >= rise_start && normalized_phase < rise_end) begin
                // Calculate cosine transition: from 0 to 
                cosine_phase = (normalized_phase - rise_start) / T_trans * `M_PI;
                V(OUT) <+ VOUT_low + (1.0 - cos(cosine_phase))/2.0 * voltage_range;
            end
            // Falling edge (cosine shape)
            else if (normalized_phase >= fall_start || normalized_phase < fall_end) begin
                // Adjust phase for wrap-around
                adjusted_phase = normalized_phase;
                if (adjusted_phase >= fall_start) begin
                    adjusted_phase = adjusted_phase - fall_start;
                end else begin
                    adjusted_phase = adjusted_phase + (1.0 - fall_start);
                end
                
                // Calculate cosine transition: from  to 2
                cosine_phase = (adjusted_phase / T_trans) * `M_PI;
                V(OUT) <+ VOUT_high - (1.0 - cos(cosine_phase))/2.0 * voltage_range;
            end
            // High level
            else if (normalized_phase >= rise_end && normalized_phase < fall_start) begin
                V(OUT) <+ VOUT_high;
            end
            // Low level
            else begin
                V(OUT) <+ VOUT_low;
            end
        end else begin
            // Fallback to square wave if T_trans = 0
            if (normalized_phase < duty) V(OUT) <+ VOUT_high;
            else V(OUT) <+ VOUT_low;
        end

        // bound the time step to period/20
        $bound_step(0.05/freq);
    end
endmodule

```

### 5.2 VCO with white edge jitter (white phase noise) 

**VCO with white edge jitter (white phase noise)** 的 Verilog-A 代码如下：

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



/* modified by YiDingg 2025.10.15 (https://github.com/YiDingg) */
/* updated by YiDingg on 2026.02.02 (https://www.zhihu.com/people/YiDingg)
- Changed the output waveform from ideal square wave to cosine-shaped rise/fall edges to better match real VCO behavior.
- Added parameters to set output voltage levels (vout_low, vout_high) and (relative) rise/fall time (t_trans_UI).
- The rise/fall time is defined as a fraction of the oscillation period (0 to 0.5).
- The output transitions are now cosine-shaped for smoother edges.
*/
/* updated by YiDingg on 2026.02.03 (https://www.zhihu.com/people/YiDingg)
- Added output voltage noise to simulate real-world VCO output characteristics.
- Optimized phase noise generation to avoid frequency calculation issues.
- Used event control to update phase noise at specific phase crossings (midpoints of steady states, i.e., midpoints of high/low levels), improving simulation stability.
*/
/* updated by YiDingg on 2026.02.03
- Fixed the issue where setting phase_n_rms_UI value did not affect output jitter
- (phase_n_rms_UI should be setting as a variable using "parameter real phi_n_rms_rad  =  phi_n_rms_UI * 2 * `M_PI;")
*/
/* updated by YiDingg on 2026.02.05
- Changed the cell name from "VA_VCO_withNoise" to "VA_VCO_whiteCycleJitter"
- Deleted most parameters that should be set in the "design variable" section of the testbench. To use them in "design variable", manually set them in the symbol view
- Refactored the code structure for better performance and readability
- Duty cycle is now fixed at 50%
- Added VSS/VDD pins to define output voltage levels
*/
/* updated by YiDingg on 2026.02.06
- build "VA_VCO_whiteEdgeJitter" module based on previous "VA_VCO_withNoise" module
- changed rms cycle jitter (Jc_rms_UI) to rms edge jitter (Je_rms_UI) and the jitter generation method accordingly
*/


`include "disciplines.vams"
`include "constants.vams"

/*
"@(timer(next)) begin next = next + 0.5/freq; end" this method is not suitable for VCO, but is only applicable to fixed frequency oscillator.
VCO frequency changes with input voltage, so the next transition time cannot be simply calculated at the last transition instant.
Integration of frequency over time is required to determine the next transition time.
*/


module VA_VCO_whiteEdgeJitter (OUT, VCTRL, VSS, VDD, PHASE_NOR, FLAG_TRANS, PHASE_NOISE); // external varible: VDD, k_vco, f_min, vctl_min, vctrl_max

input VCTRL, VSS, VDD;
output OUT, PHASE_NOR, FLAG_TRANS, PHASE_NOISE;
electrical VCTRL, OUT, VSS, VDD, PHASE_NOR, FLAG_TRANS, PHASE_NOISE;
/* To be set VCTRL the "design variable" section of the testbench */
parameter real vctl_min       =   0       from (-inf:inf);        // minimum input voltage (V)
parameter real vctrl_max      =   1       from (vctl_min:inf);    // maximum input voltage (V)
parameter real f_min          =   1G      from (0:inf);           // minimum output frequency (Hz)
parameter real k_vco          =   100M    from [0:inf);           // VCO gain (Hz/V)
parameter real t_trans_UI     =   0.1     from (0:0.5];           // rise time as fraction of period (0 ~ 0.5)
parameter real Je_rms_UI      =   10m     from [0:1);             // phase noise RMS value VCTRL UI
parameter real fnoise_max     =   10G     from (0:inf);           // maximum transition noise frequency

/* parameter to be set in "Design Variable" */
parameter real FNOISE_max     =   fnoise_max;

real f_max = f_min + k_vco*(vctrl_max - vctl_min); // maximum output frequency (Hz)
real noise_scale_factor_voltage = 1;
integer seed = 314;
integer flag_transition = 0;
integer last_logic, logic_out;
real phase_posEdge = `M_PI/4; // phase at which output goes high
real phase_negEdge = phase_posEdge + `M_PI; // phase at which output goes low
real phase_posEdge_normalized = phase_posEdge / (2*`M_PI);
real phase_negEdge_normalized = phase_negEdge / (2*`M_PI);

real freq, period, voltage_noise, period_jittered, freq_jittered;
real phase, phase_normalized, cosine_phase, phase_noise;
real vout, phase_jittered, phase_jittered_normalized;

analog begin
    @(initial_step) begin
        flag_transition = 0;    // reset flag
        freq = f_min + k_vco*(V(VCTRL) - vctl_min); // Initial frequency
        if (freq < f_min) freq = f_min; // Bound the frequency
        if (freq > f_max) freq = f_max; // Bound the frequency
        period = 1.0 / freq; // Initial period
        period_jittered = period;
        freq_jittered = freq;
        $bound_step(0.05/freq); // Bound the time step to period/20 for better noise simulation
        logic_out = 0; // Initial logic output
        last_logic = 1;
        voltage_noise = 0;
        phase = 0;
        phase_normalized = 0;
        cosine_phase = 0;
        phase_noise = 0;
        vout = V(VSS); // Initial output voltage
    end

    // Compute the frequency from the input voltage
    if (V(VCTRL) > vctl_min && V(VCTRL) < vctrl_max) begin freq = f_min + k_vco*(V(VCTRL) - vctl_min); end
    else if (V(VCTRL) <= vctl_min) begin freq = f_min; end
    else if (V(VCTRL) >= vctrl_max) begin freq = f_max; end

    // period, frequency and phase operations
    period = 1.0 / freq; // Update period based on frequency
    phase = 2*`M_PI*idtmod(freq, 0.0, 1.0, 0);
    phase_normalized = phase/(2*`M_PI);     // Normalized phase [0, 1)
    phase_jittered = phase + phase_noise; // phase with noise
    phase_jittered_normalized = phase_jittered / (2*`M_PI);
    // idtmod(expr, initial, modulus, offset) computes the integral of freq over time, note that modulus = 1.0 here to get phase in [0, 2pi]
    
    @(cross(phase_jittered - phase_posEdge, +1)) begin
        logic_out = 1; // high-level output
        flag_transition = 1;
    end
    @(cross(phase_jittered - phase_negEdge, +1)) begin
        logic_out = 0; // low-level output
        flag_transition = 1;
    end

    if (flag_transition == 1) begin
        last_logic = !logic_out;
        if (logic_out == 1) begin       // rising edge
            vout = V(VSS) + (1 - cos(cosine_phase))/2 * (V(VDD) - V(VSS)); // rising edge with cosine shape
            cosine_phase = (phase_jittered_normalized - phase_posEdge_normalized) / t_trans_UI * `M_PI;
        end if (logic_out == 0) begin   // falling edge
            vout = V(VDD) - (1 - cos(cosine_phase))/2 * (V(VDD) - V(VSS)); // falling edge with cosine shape
            cosine_phase = (phase_jittered_normalized - phase_negEdge_normalized) / t_trans_UI * `M_PI;
        end
        // if (cosine_phase > `M_PI) flag_transition = 0; // reset flag if transition complete
    end else begin
        vout = (logic_out == 1) ? V(VDD) : V(VSS); // steady state output
    end
    /* 
    Use "if (cosine_phase > `M_PI) flag_transition = 0;" in the above block will cause "flag reset lag",
    so we use event control @(cross(cosine_phase - `M_PI, +1)) to reset flag_transition when transition is complete.
    */
    @(cross(cosine_phase - `M_PI, +1)) begin
        flag_transition = 0; // reset flag after transition complete
        cosine_phase = 0;
        phase_noise = 2*`M_PI*Je_rms_UI * $rdist_normal(seed, 0, 1); // update phase noise at the end of each transition
    end

    voltage_noise = noise_scale_factor_voltage * Je_rms_UI * white_noise(1/FNOISE_max) * V(VDD, VSS) / ((logic_out&&(!flag_transition)) ? 1 : 2.5); // output voltage noise
    V(OUT) <+ vout + voltage_noise;	// plus noise on output voltage
    V(PHASE_NOR) <+ phase_normalized; // output normalized phase [0, 1)
    V(FLAG_TRANS) <+ flag_transition; // output transition flag
    V(PHASE_NOISE) <+ phase_noise; // output phase noise
end

endmodule
```

### 5.3 VCO with white cycle jitter (closest to real VCO)

**VCO with white cycle jitter (closest to real VCO)** 的 Verilog-A 代码如下：

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



/* modified by YiDingg 2025.10.15 (https://github.com/YiDingg) */
/* updated by YiDingg on 2026.02.02 (https://www.zhihu.com/people/YiDingg)
- Changed the output waveform from ideal square wave to cosine-shaped rise/fall edges to better match real VCO behavior.
- Added parameters to set output voltage levels (vout_low, vout_high) and (relative) rise/fall time (t_trans_UI).
- The rise/fall time is defined as a fraction of the oscillation period (0 to 0.5).
- The output transitions are now cosine-shaped for smoother edges.
*/
/* updated by YiDingg on 2026.02.03 (https://www.zhihu.com/people/YiDingg)
- Added output voltage noise to simulate real-world VCO output characteristics.
- Optimized phase noise generation to avoid frequency calculation issues.
- Used event control to update phase noise at specific phase crossings (midpoints of steady states, i.e., midpoints of high/low levels), improving simulation stability.
*/
/* updated by YiDingg on 2026.02.03
- Fixed the issue where setting phase_n_rms_UI value did not affect output jitter
- (phase_n_rms_UI should be setting as a variable using "parameter real phi_n_rms_rad  =  phi_n_rms_UI * 2 * `M_PI;")
*/
/* updated by YiDingg on 2026.02.05
- Changed the cell name from "VA_VCO_withNoise" to "VA_VCO_whiteCycleJitter"
- Deleted most parameters that should be set in the "design variable" section of the testbench. To use them in "design variable", manually set them in the symbol view
- Refactored the code structure for better performance and readability
- Duty cycle is now fixed at 50%
- Added VSS/VDD pins to define output voltage levels
*/


`include "disciplines.vams"
`include "constants.vams"

/*
"@(timer(next)) begin next = next + 0.5/freq; end" this method is not suitable for VCO, but is only applicable to fixed frequency oscillator.
VCO frequency changes with input voltage, so the next transition time cannot be simply calculated at the last transition instant.
Integration of frequency over time is required to determine the next transition time.
*/


module VA_VCO_whiteCycleJitter (OUT, VCTRL, VSS, VDD, PHASE_NOR, FLAG_TRANS); // external varible: VDD, k_vco, f_min, vctl_min, vctrl_max

output OUT, PHASE_NOR, FLAG_TRANS;
input VCTRL, VSS, VDD;
electrical VCTRL, OUT, VSS, VDD, PHASE_NOR, FLAG_TRANS;

/* To be set VCTRL the "design variable" section of the testbench */
parameter real vctl_min       =   0       from (-inf:inf);        // minimum input voltage (V)
parameter real vctrl_max      =   1       from (vctl_min:inf);    // maximum input voltage (V)
parameter real f_min          =   1G      from (0:inf);           // minimum output frequency (Hz)
parameter real k_vco          =   100M    from [0:inf);           // VCO gain (Hz/V)
parameter real t_trans_UI     =   0.1     from (0:0.5];           // rise time as fraction of period (0 ~ 0.5)
parameter real Jc_rms_UI      =   10m     from [0:1);             // phase noise RMS value VCTRL UI
parameter real fnoise_max     =   10G     from (0:inf);           // maximum transition noise frequency

/* parameter to be set in "Design Variable" */
parameter real FNOISE_max     =   fnoise_max;

real f_max = f_min + k_vco*(vctrl_max - vctl_min); // maximum output frequency (Hz)
real noise_scale_factor_voltage = 1;
integer seed = 314;
integer flag_transition = 0;
integer last_logic, logic_out;
real phase_posEdge = `M_PI/4; // phase at which output goes high
real phase_negEdge = phase_posEdge + `M_PI; // phase at which output goes low
real phase_posEdge_normalized = phase_posEdge / (2*`M_PI);
real phase_negEdge_normalized = phase_negEdge / (2*`M_PI);

real freq, period, voltage_noise, period_jittered, freq_jittered;
real phase, phase_normalized, cosine_phase;
real vout;

analog begin
    @(initial_step) begin
        flag_transition = 0;    // reset flag
        freq = f_min + k_vco*(V(VCTRL) - vctl_min); // Initial frequency
        if (freq < f_min) freq = f_min; // Bound the frequency
        if (freq > f_max) freq = f_max; // Bound the frequency
        period = 1.0 / freq; // Initial period
        period_jittered = period;
        freq_jittered = freq;
        $bound_step(0.05/freq); // Bound the time step to period/20 for better noise simulation
        logic_out = 0; // Initial logic output
        last_logic = 1;
        voltage_noise = 0;
        phase = 0;
        phase_normalized = 0;
        cosine_phase = 0;
        vout = V(VSS); // Initial output voltage
    end

    // Compute the frequency from the input voltage
    if (V(VCTRL) > vctl_min && V(VCTRL) < vctrl_max) begin freq = f_min + k_vco*(V(VCTRL) - vctl_min); end
    else if (V(VCTRL) <= vctl_min) begin freq = f_min; end
    else if (V(VCTRL) >= vctrl_max) begin freq = f_max; end

    // period, frequency and phase operations
    period = 1.0 / freq; // Update period based on frequency
    // Jcc_rms = sqrt(2)*Jc_rms for white cycle jitter, should we multiply sqrt(2) here?
    // period_jittered = period * (1 + `M_SQRT2*Jc_rms_UI * $rdist_normal(seed, 0, 1)); // Jittered period
    // period_jittered = period * (1 + Jc_rms_UI * white_noise(1/FNOISE_max)); // Jittered period
    // white_noise(1/FNOISE_max) will cause dc opt divergence issue, so we use rdist_normal() here
    @(
	// or cross(phase_normalized - 0.1, +1)
    cross(phase_normalized - 0.2, +1)
    // or cross(phase_normalized - 0.3, +1)
    // or cross(phase_normalized - 0.4, +1)
    or cross(phase_normalized - 0.5, +1)
    // or cross(phase_normalized - 0.6, +1)
    // or cross(phase_normalized - 0.7, +1)
    or cross(phase_normalized - 0.8, +1)
    // or cross(phase_normalized - 0.9, +1)
    ) begin
        period_jittered = period * (1 + Jc_rms_UI * $rdist_normal(seed, 0, 1)); // Jittered period
    end
    freq_jittered = 1.0 / period_jittered; // Jittered frequency
    // phase_normalized = idtmod(freq_jittered, 0.0, 1.0, 0); // Normalized phase [0, 1)
    phase = 2*`M_PI*idtmod(freq_jittered, 0.0, 1.0, 0);
    phase_normalized = phase/(2*`M_PI);     // Normalized phase [0, 1)
    // idtmod(expr, initial, modulus, offset) computes the integral of freq over time, note that modulus = 1.0 here to get phase in [0, 2pi]

    
    @(cross(phase - phase_posEdge, +1)) begin
        logic_out = 1; // high-level output
        flag_transition = 1;
    end
    @(cross(phase - phase_negEdge, +1)) begin
        logic_out = 0; // low-level output
        flag_transition = 1;
    end

    if (flag_transition == 1) begin
        last_logic = !logic_out;
        if (logic_out == 1) begin       // rising edge
            cosine_phase = (phase_normalized - phase_posEdge_normalized) / t_trans_UI * `M_PI;
            vout = V(VSS) + (1 - cos(cosine_phase))/2 * (V(VDD) - V(VSS)); // rising edge with cosine shape
        end if (logic_out == 0) begin   // falling edge
            cosine_phase = (phase_normalized - phase_negEdge_normalized) / t_trans_UI * `M_PI;
            vout = V(VDD) - (1 - cos(cosine_phase))/2 * (V(VDD) - V(VSS)); // falling edge with cosine shape
        end
        // if (cosine_phase > `M_PI) flag_transition = 0; // reset flag if transition complete
    end else begin
        vout = (logic_out == 1) ? V(VDD) : V(VSS); // steady state output
    end
    /* 
    Use "if (cosine_phase > `M_PI) flag_transition = 0;" in the above block will cause "flag reset lag",
    so we use event control @(cross(cosine_phase - `M_PI, +1)) to reset flag_transition when transition is complete.
    */
    @(cross(cosine_phase - `M_PI, +1)) begin
        flag_transition = 0; // reset flag after transition complete
        cosine_phase = 0;
    end

    voltage_noise = noise_scale_factor_voltage * Jc_rms_UI * white_noise(1/FNOISE_max) * V(VDD, VSS) ; // output voltage noise
    V(OUT) <+ vout + voltage_noise;	// plus noise on output voltage
    V(PHASE_NOR) <+ phase_normalized; // output normalized phase [0, 1)
    V(FLAG_TRANS) <+ flag_transition; // output transition flag
end

endmodule

```

### 5.4 simulation verification


首先是 VCO with white edge jitter 的仿真结果：
<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | Testbench 原理图 (VCO with white edge jitter) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-04-29-31_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> | Testbench 仿真设置 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-04-29-50_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> | 仿真结果总览 (VCO with white edge jitter) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-04-41-48_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> |
 | 输出眼图 (VCO with white edge jitter) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-04-43-21_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> | Jc_n 与 Je_n 分布 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-04-45-06_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> | 相位噪声谱 (VCO with white edge jitter) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-04-46-08_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> |
</div>



然后是 VCO with white cycle jitter 的仿真结果：
<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | Testbench 原理图 (VCO with white cycle jitter) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-04-32-29_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> | Testbench 仿真设置 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-04-32-47_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> | 仿真结果总览 (VCO with white cycle jitter) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-04-34-54_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> |
 | 输出眼图 (VCO with white cycle jitter) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-04-44-14_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> | Jc_n 与 Je_n 分布 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-04-39-20_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> | 相位噪声谱 (VCO with white cycle jitter) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-04-40-54_Verilog-A Modeling for Commonly Used Modules of SerDes and Wireline.png"/></div> |
</div>




## 6. PRBS and PRTS Generator

详见这篇文章：[Virtuoso Tutorials - 21. How to Generate PRBS (Pseudo-Random Binary Sequence) Signal in Virtuoso](<AnalogIC/Virtuoso Tutorials - 21. How to Generate PRBS (Pseudo-Random Binary Sequence) Signal in Virtuoso.md>)

## 7. PLL and DLL
## 8. Alexander-PD and CDR
## 9. NRZ/PAM3 and PAM3/NRZ Converter
## 10. NRZ/PAM4 and PAM4/NRZ Converter

## References

- [The Designer's Guide > Verilog-AMS > Verilog-A Models](https://designers-guide.org/verilog-ams/index.html)
- [Cadence Verilog-A Language Reference (Product Version 5.1 January 2004).pdf](https://picture.iczhiku.com/resource/eetop/wHKHWkFiYkuOICnN.pdf)