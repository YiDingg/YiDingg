# Virtuoso Tutorials - 12. Behavior-Level Simulation using Verilog-A in Cadence IC618

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 14:02 on 2025-08-16 in Lincang.



## 1. Introduction

本文，我们在 Cadence Virtuoso 中使用 Verilog-A 语言搭建压控振荡器 VCO (voltage-controlled oscillator) 的行为级电路模型，并进行仿真验证。

可能有读者疑惑 Verilog-A 是什么？毕竟我们平常说的都是 Verilog, 带了一个后缀 `A` 是啥意思？  Verilog-A 是用来专门描述模拟电路的语言，`A` 就是代表 `Analog`，它由 Verilog 演变而来，基本逻辑几乎相同，但具体语法稍有区别。具体而言, Verilog-A 是 Verilog-AMS 的子集，其中 AMS 是指 "analog and mixed signal"，专门用于混合信号电路 (同时包含数字和模拟部分) 的仿真。

## 2. VCO Modeling

### 2.1 Verilog-A Modeling

到网址 [The Designer's Guide Community > Verilog-AMS Models](https://designers-guide.org/verilog-ams/index.html) 下载 VCO 的 model 文件：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-15-59-58_Virtuoso Tutorials - 11. Behavior-Level Simulation using Verilog-A in Cadence Ic618.png"/></div>

对其中参数作适当修改，得到如下模型：

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


// 2025.08.16 modified by https://www.zhihu.com/people/YiDingg
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



### 2.2 Create V-A Module

在 library 下新建 cellview, type 选择 `verilogA`。将代码复制进去后，点击左上角 `Build`, 会提示是否生成 symbol, 点击确认并调整 symbol 样式。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-23-06-58_Virtuoso Tutorials - 11. Behavior-Level Simulation using Verilog-A in Cadence Ic618.png"/></div>



### 2.3 VCO Simulation

设置好 testbench 的原理图后，打开 ADE XL 或 ADE Assembler 进行仿真 (有没有 config 文件都可以)。因为 Verilog-A 模型可以像常规模拟电路一样直接用 spectre simulator 进行仿真，所以不需要作额外调整。


仿真示例如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-23-40-15_Virtuoso Tutorials - 11. Behavior-Level Simulation using Verilog-A in Cadence Ic618.png"/></div>



## 3. Using Verilog-AMS Model

注意，如果我们在创建 cell view 时选择了 `verilogAMSText` (Verilog-AMS), 仿真时就需要将 simulator 从 spectre 换为 ams (Verilog-A 则不需要), 但是**我们运行仿真时却出现了仿真器版本过低的报错：**

``` bash
*ERROR* (AMS-2141): The INCISIV installation being used is not compatible with the AMS Unified Netlisting (AMS UNL) flow. To run AMS Unified Netlister, either use INCISIV 13.20-s007 or a later release, or use other AMS netlisters.
```

如何解决这个问题，等我们有方案了再发出来，下面几个小节 (3.1 ~ 3.3) 是此问题的复现过程。


### 3.1 Verilog-AMS Modeling

到网址 [The Designer's Guide Community > Verilog-AMS Models](https://designers-guide.org/verilog-ams/index.html) 下载 VCO 的 model 文件：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-15-59-58_Virtuoso Tutorials - 11. Behavior-Level Simulation using Verilog-A in Cadence Ic618.png"/></div>

对其中参数作适当修改，得到如下模型：

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

// 2025.08.16 modified by https://www.zhihu.com/people/YiDingg
`include "disciplines.vams"
`include "constants.vams"

module VCO_1Gto2G_1GperV (OUT, VCONT);
    parameter real Vmin=0;			// minimum input voltage (V)
    parameter real Vmax=1 from (Vmin:inf);	// maximum input voltage (V)
    parameter real Fmin=1e9 from (0:inf);		// minimum output frequency (Hz)
    parameter real Fmax=2*Fmin from (Fmin:inf);	// maximum output frequency (Hz)
    parameter real ampl=1;			// output amplitude (V)
    input VCONT; output OUT;
    voltage OUT, VCONT;
    real freq, phase;

    analog begin
	// compute the freq from the input voltage
	freq = (V(VCONT) - Vmin)*(Fmax - Fmin) / (Vmax - Vmin) + Fmin;

	// bound the frequency (this is optional)
	if (freq > Fmax) freq = Fmax;
	if (freq < Fmin) freq = Fmin;

	// phase is the integral of the freq modulo 2p
	phase = 2*`M_PI*idtmod(freq, 0.0, 1.0, -0.5);

	// generate the output
	V(OUT) <+ sin(phase);

	// bound the time step to period/20
	$bound_step(0.05/freq);
    end
endmodule
```



### 3.2 Create V-AMS Module

在 library 下新建 cellview, type 选择 `verilogAMSText` (verilogAMSText 的功能涵盖 verilog, verilogA, 因此是最佳选择)，如图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-16-43-57_Virtuoso Tutorials - 11. Behavior-Level Simulation using Verilog-A in Cadence Ic618.png"/></div>

将代码复制进去后，点击左上角 `Build`, 会提示是否生成 symbol, 点击确认并调整 symbol 样式：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-16-48-48_Virtuoso Tutorials - 11. Behavior-Level Simulation using Verilog-A in Cadence Ic618.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-16-53-53_Virtuoso Tutorials - 11. Behavior-Level Simulation using Verilog-A in Cadence Ic618.png"/></div>

这样, VCO 的模型就算搭建完成了。



### 3.3 VCO Simulation

再创建一个 cell > schematic 搭建外围测试电路：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-16-59-55_Virtuoso Tutorials - 11. Behavior-Level Simulation using Verilog-A in Cadence Ic618.png"/></div>



如果此时直接启动 ADE 进行仿真，其采用的仿真器是 spectre, 无法对含有 ams 的电路进行仿真，需要修改为 AMS (Analog and Mixed-Signal) 仿真器。

使用 ams 仿真器必须配合 config 文件，因此先创建一个 config view, 选择 `view > schematic`, Template 选择 `AMS`, 创建完毕后点击左上角保存：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-17-30-11_Virtuoso Tutorials - 11. Behavior-Level Simulation using Verilog-A in Cadence Ic618.png"/></div>



创建并打开 ADE XL, 先点击 `Design` 将 Test 的关联从 schematic 修改为 config, 然后点击 `Setup > Simulator > 选择 AMS`：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-16-17-03-20_Virtuoso Tutorials - 11. Behavior-Level Simulation using Verilog-A in Cadence Ic618.png"/></div>

运行仿真，出现报错：

``` bash
*ERROR* (AMS-2141): The INCISIV installation being used is not compatible with the AMS Unified Netlisting (AMS UNL) flow. To run AMS Unified Netlister, either use INCISIV 13.20-s007 or a later release, or use other AMS netlisters.
```

读者可以参考这个问答 [Cadence Community > AMS Simulation Error for INCISIV Version](https://community.cadence.com/cadence_technology_forums/f/mixed-signal-design/45160/ams-simulation-error-for-incisiv-version) 来解决。

## 4. Conclusion

一般情况下，无论是模拟电路还是混合信号电路，我们都推荐使用 Verilog-A 来搭建行为级模型，因为它可以直接用 spectre 仿真器进行仿真，省去了切换仿真器和配置 config 文件的麻烦，更别提切换为 AMS Simulator 可能会出现杂七杂八的仿真问题。




## References

官方文档：
- [Cadence Verilog-A Language Reference (Product Version 5.1 January 2004)](https://picture.iczhiku.com/resource/eetop/wHKHWkFiYkuOICnN.pdf)

其它资料：
- [The Designer's Guide Community > Verilog-AMS Models](https://designers-guide.org/verilog-ams/index.html)
- [The Designer's Guide Community > Verilog-AMS Tutorials](https://verilogams.com/tutorials/vloga-intro.html)
- [知乎 > Cadence Virtuoso AMS 数模混合仿真流程](https://zhuanlan.zhihu.com/p/8280687951)
- [菜鸟教程 > Verilog 教程](https://www.runoob.com/w3cnote/verilog-tutorial.html)
- [知乎 > cadence 中搭建行为级模型：先画 symbol 后输入 Verilog-A 代码](https://zhuanlan.zhihu.com/p/1911009409812914799)
