# Virtuoso Tutorials - 13. VCO/PLL Simulation (Periodical Steady-State and Phase Noise)

> [!Note|style:callout|label:Infor]
Initially published at 16:02 on 2025-08-21 in Lincang.

## Introduction

在上一篇文章 [Virtuoso Tutorials - 12. Behavior-Level Simulation using Verilog-A in Cadence IC618](<AnalogIC/Virtuoso Tutorials - 12. Behavior-Level Simulation using Verilog-A in Cadence IC618.md>) 中，我们已经介绍了如何使用 Verilog-A 模型构建行为级仿真，本文则以实际的 VCO 为例，介绍如何进行相噪仿真 (pss, pnoise 等)。介绍完 VCO 的相噪仿真之后，再对一个完整的 Type-II Third-Order Charge Pump PLL 系统进行相噪仿真。

## 1. VCO Simulation

### 1.0 schematic preview

VCO 外围测试电路 (testbench) 和原理图 (schematic) 如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-22-04-17_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-22-05-41_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>

### 1.1 tran simulation

为确定 VCO 的振荡频率，我们不妨先设置振荡器的控制电压 Vcont = 0.5 V 进行一次瞬态仿真。此 VCO 工作频率在 GHz 级别，设置瞬态仿真时间为 20 ns 并运行，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-21-22-10-11_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>

图中可以看到, Vcont = 0.5 V 对应频率 903.4 MHz, 下面进行 pss 仿真。

### 1.2 pss simulation


PSS (Periodical Steady-State) Simulation, 即周期性稳态仿真，专门用于仿真稳定工作时呈现周期性变化的电路/系统。许多电路，如振荡器、开关电容滤波器、锁相环等，达到稳定工作状态后都是周期性的 (或可以近似为周期性)，这时就可以用 PSS 来仿真。相比于最常见的瞬态仿真, PSS 通过数学算法直接求解周期性稳态解，从而绕过了耗时的初始瞬态过程，极大提高仿真速度。

在开始仿真之前，我们先介绍一下 pss 仿真设置中各个选项代表什么意思：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-18-05-24_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

如果对其它仿真类型如 pac, pstb, pxf 等感兴趣，可以参考资料 [[3] SpectreRF Periodic Analysis](https://www.eecis.udel.edu/~vsaxena/courses/ece614/Handouts/SpectreRF%20Periodic%20Analysis.pdf).


然后是 pss 仿真中一些常见的 Outputs 设置：
``` bash
tstab simulation of Vout = v("/Vout" ?result "pss-tran.pss")
spectrum of f_osc = getData("Vout" ?result "pss_fd")
fundamental frequency of f_osc = harmonic(xval(getData("Vout" ?result "pss_fd")) '1)
```

现在如图设置 pss 参数，运行仿真：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-00-10-46_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-00-14-42_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>

pss 仿真给出的振荡频率与瞬态完全相同 (903.4 MHz)。

### 1.3 pss variable-sweep

下面仿真振荡频率随 Vcont 的变化情况。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-00-19-36_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-00-27-57_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>

振荡频率在 0.5 GHz ~ 3.0 GHz 之间可调，也即所谓的 tuning range, 其中线性度比较好的区间是 0.5 GHz ~ 2.1 GHz, 增益基本上在 7.5 GHz/V ~ 8.3 GHz/V 之间。

### 1.4 pnoise simulation


有关 jitter 和 phase noise 的基础知识，详见文章 [Jitter and Phase Noise in Mixed-Signal Circuits](<AnalogIC/Jitter and Phase Noise in Mixed-Signal Circuits.md>)，这里不多赘述。


下面仿真 VCO 的相位噪声和抖动。**先取消 pss 中的 sweep, 固定 Vcont = 0.5 V**，然后在 pss 仿真之后添加 pnoise 仿真 (pss 是必需的)，如图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-01-04-36_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>


作出 phase noise 在整个频段上的曲线：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-01-02-29_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>

如下图，计算某一频率范围内的 RMS jitter, 注意不要改变 Frequency Multiplier 的值，这是因为: 
>it is only used when the signal frequency is not the same as the PSS analysis’ fundamental, which would happen when there is a frequency division or multiplication in the circuit.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-00-57-46_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-01-15-46_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>

上面有一个选项是 Modifier, 表示 phase noise 的单位，下面是参考资料 [[2] Jitter measurement using SpectreRF Application Note.pdf](https://www.writebug.com/static/uploads/2025/8/22/28c1f61cd30eb054e8a9d5c6824f4d7e.pdf) 的原话：

>Measuring timing jitter involves several basic units. The default unit is seconds. Absolute units such as seconds are not always optimal. Using absolute units, you cannot see the effect of the jitter on the system period or on other timing properties.<br>
Relative units such as parts per million (PPM) and the unit interval (UI), UI can be the clock period or another characteristic time cycle.


也可以直接设置 Outputs 来读出总 phase noise:
``` bash
RMS jitter integrated from 5 Hz to 500 MHz =  drplRFJc(?from 5 ?to 5e+08 ?k 1 ?multiplier 1 ?result "pnoise_sample_pm0" ?unit "Second" ?event 0)
RMS jitter integrated from 10k Hz to 500 MHz =  drplRFJc(?from 5 ?to 5e+08 ?k 1 ?multiplier 1 ?result "pnoise_sample_pm0" ?unit "Second" ?event 0)
```


### 1.5 outputs configuration


pss:
``` bash
表达式：
v("/Vout" ?result "pss-tran.pss")
getData("Vout" ?result "pss_fd")
harmonic(xval(getData("Vout" ?result "pss_fd")) '1)

从上到下依次是：
tstab simulation of Vout
spectrum of f_osc
fundamental frequency of f_osc 
```


pnoise:
``` bash
表达式：
drplRFJc(?from 5 ?to 5e+08 ?k 1 ?multiplier 1 ?result "pnoise_sample_pm0" ?unit "Second" ?event 0)
drplRFJc(?from 5 ?to 5e+08 ?k 1 ?multiplier 1 ?result "pnoise_sample_pm0" ?unit "Second" ?event 0)

从上到下依次是：
RMS jitter integrated from 5 Hz to 500 MHz
RMS jitter integrated from 10k Hz to 500 MHz
```



## 2. PLL Simulation

### 2.0 schematic preview

选用一个 Type-II Third-Order Integer-64 Charge Pump PLL 作为例子，其 schematic 及其外围测试电路如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-17-40-37_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>


### 2.1 tran simulation

设置好瞬态仿真和 outputs, 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-01-56-50_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-01-55-51_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-02-00-35_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-02-02-03_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-02-04-16_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>

因为下一小节 **2.2 transient jitter analysis** 中我们会用瞬态仿真的数据来求出 jitter, 所以需要再进行一次仿真，得到尽量多的周期数据。


上面已经知道，我们的 PLL 能在约 1 us 时达到锁定状态，为保证 jitter 计算的准确性，我们希望稳定之后能有至少 70000 个周期的数据，因此设定仿真结束时间为 time_end = 1500/f_REF = 96 us, 其中 f_REF = 1GHz/64 = 15.625 MHz.

修改之后运行仿真，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-14-46-06_Virtuoso Tutorials - 12. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

锁定之后的波形：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-14-59-15_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

选中 vout_freq_settled 波形 > 右键 > Send To > Export, 导出数据为 `.csv`.


### 2.2 transient jitter analysis


Phase Noise 结果不仅可以从 pnoise 等仿真中得到，还可以从 transient simulation results 中计算。也就是参考资料 [1](https://www.writebug.com/static/uploads/2025/8/22/705f40616dd3afd7796ddfbe1d5b66d8.pdf) page.28 中所介绍的，我们可以将系统锁定之后 VOUT 节点的周期数据 (频率数据) 导出，在 MATLAB 中分析 jitter 情况。


原文代码如下：
``` bash
echo off;
nfft=32768;
% nfft should be power of two
winLength=nfft;
overlap=nfft/2;
winNBW=1.5;
% Noise bandwidth given in bins
% Load the data from the file generated by the VCO load periods.m
% output estimates of period and jitter
T=mean(periods);
J=std(periods);
maxdT = max(abs(periods-T))/T;
fprintf('T = %.3gs, F = %.3gHz\n',T, 1/T);
fprintf('Jabs = %.3gs, Jrel = %.2g%%\n', J, 100*J/T);
fprintf('max dT = %.2g%%\n', 100*maxdT);
fprintf('periods = %d, nfft = %d\n', length(periods), nfft);
% compute the cumulative phase of each transition
phases=2*pi*cumsum(periods)/T;
% compute power spectral density of phase 
[Sphi,f]=psd(phases,nfft,1/T,winLength,overlap,'linear');
% correct for scaling in PSD due to FFT and window 
Sphi=winNBW*Sphi/nfft;
% plot the results (except at DC) 
K = length(f);
semilogx(f(2:K),10*log10(Sphi(2:K)));
title('Noise Power Spectral Density at the output of the PLL');
xlabel('Frequency (Hz)');
ylabel('S phi (dB/Hz)');
rbw = winNBW/(T*nfft);
RBW=sprintf('Resolution Bandwidth = %.0f Hz (%.0f dB)', rbw, 10*log10(rbw));
line1=sprintf('Period = %.3gs, Frequency = %.3gHz\n',T, 1/T);
line2=sprintf('Jitter = %.3gs',J);
line3=sprintf('max dT = %.2g%%\n', 100*maxdT);
line4=sprintf('periods = %d, Nfft = %d\n', length(periods), nfft);

imtext(0.3,0.11, line4);
imtext(0.3,0.17, line3);
imtext(0.3,0.24, line2);
imtext(0.3,0.27, line1);
imtext(0.3,0.07, RBW);
```

我们只需将 VOUT 在锁定后的频率数据导出，取倒数得到周期数据，并赋值给代码中的 `periods` 变量即可。特别地，我们使用的是 MATLAB 2022a, 此版本中函数 `psd()` 已被启用，将其改为函数 `pwelch()` 即可。


下面是我们测试用的代码 (用的是仅仿真了 9.6 us 的小数据集)：

``` bash
vout_freq = readmatrix("D:\a_Win_VM_shared\202508_CPPLL_1k_50p_vout_freq_settled.csv");
vout_freq = vout_freq(:, 2);
vout_period = 1./vout_freq;
periods = vout_period;

%% 下面的代码主要参考 Cadence_PLL_Jitter_measurment_in_Spectre.pdf
echo off;
% nfft=32768;
nfft=2^12;
% nfft should be power of two
winLength=nfft;
overlap=nfft/2;
winNBW=1.5;
% Noise bandwidth given in bins
% Load the data from the file generated by the VCO load periods.m
% output estimates of period and jitter
T=mean(periods);
J=std(periods);
maxdT = max(abs(periods-T))/T;
fprintf('T = %.3gs, F = %.3gHz\n',T, 1/T);
fprintf('Jabs = %.3gs, Jrel = %.2g%%\n', J, 100*J/T);
fprintf('max dT = %.2g%%\n', 100*maxdT);
fprintf('periods = %d, nfft = %d\n', length(periods), nfft);
% compute the cumulative phase of each transition
phases=2*pi*cumsum(periods)/T;

% compute power spectral density of phase 
% function psd() has been deprecated, use function pwelch as an alternative solution
% [Sphi,f]=psd(phases,nfft,1/T,winLength,overlap,'linear');
[Sphi, f] = pwelch(phases, winLength, overlap, nfft, 1/T, 'psd');

% correct for scaling in PSD due to FFT and window 
Sphi=winNBW*Sphi/nfft;
% plot the results (except at DC) 
K = length(f);
semilogx(f(2:K),10*log10(Sphi(2:K)));
title('Noise Power Spectral Density at the output of the PLL');
xlabel('Frequency (Hz)');
ylabel('S phi (dB/Hz)');
rbw = winNBW/(T*nfft);
RBW=sprintf('Resolution Bandwidth = %.3f kHz (%.3f dB)', rbw/10^3, 10*log10(rbw));
line1=sprintf('Period = %.3e s, Frequency = %.3e Hz\n',T, 1/T);
line2=sprintf('Jitter = %.3e s',J);
line3=sprintf('max dT = %.2g%%\n', 100*maxdT);
line4=sprintf('periods = %d, Nfft = %d\n', length(periods), nfft);

imtext(0.3,0.11, line4);
imtext(0.3,0.17, line3);
imtext(0.3,0.24, line2);
imtext(0.3,0.27, line1);
imtext(0.3,0.07, RBW);
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-02-07-11_Virtuoso Tutorials - 12. Phase Noise Simulation (pss and pnoise).png"/></div>


下面是实际使用的代码 (提高了图片美观性)：

``` bash
vout_freq = readmatrix("D:\a_Win_VM_shared\best_pass_1k_50p_1G-1500periods_tran__vout_freq.csv");
vout_freq = vout_freq(:, 2);
vout_period = 1./vout_freq;
periods = vout_period;

%% 下面的代码主要参考 Cadence_PLL_Jitter_measurment_in_Spectre.pdf
echo off;
% nfft=32768;
nfft=2^16;
% nfft should be power of two
winLength=nfft;
overlap=nfft/2;
winNBW=1.5;
% Noise bandwidth given in bins (defult 1.5)
% Load the data from the file generated by the VCO load periods.m
% output estimates of period and jitter
T=mean(periods);
J=std(periods);
maxdT = max(abs(periods-T))/T;
fprintf('T = %.3gs, F = %.3gHz\n',T, 1/T);
fprintf('Jabs = %.3gs, Jrel = %.2g%%\n', J, 100*J/T);
fprintf('max dT = %.2g%%\n', 100*maxdT);
fprintf('periods = %d, nfft = %d\n', length(periods), nfft);
% compute the cumulative phase of each transition
phases=2*pi*cumsum(periods)/T;

% compute power spectral density of phase 
% function psd() has been deprecated, use function pwelch as an alternative solution
% [Sphi,f]=psd(phases,nfft,1/T,winLength,overlap,'linear');
[Sphi, f] = pwelch(phases, winLength, overlap, nfft, 1/T, 'psd');

% correct for scaling in PSD due to FFT and window 
Sphi=winNBW*Sphi/nfft;
% plot the results (except at DC) 
K = length(f);

%{
semilogx(f(2:K), 10*log10(Sphi(2:K)));
title('Noise Power Spectral Density at the output of the PLL');
xlabel('Frequency (Hz)');
ylabel('S phi (dB/Hz)');
%}

rbw = winNBW/(T*nfft);
RBW=sprintf('Resolution bandwidth = %.3f kHz (%.3f dB)', rbw/10^3, 10*log10(rbw));
line1=sprintf('Period = %.3f ns, Frequency = %.3f GHz\n', T*10^9, 1/T/10^9);
line2=sprintf('Std jitter = %.3f ps, max dT = %.2g%%\n', J*10^12, 100*maxdT);
line4=sprintf('Number of periods = %d, FFT points = %d\n', length(periods), nfft);

% 作图
stc = MyPlot(f(2:(K-1))', 10*log10(Sphi(2:(K-1)))');
stc.axes.XScale = 'log';
xlim([10^5 10^9])
ylim([-100 0])
stc.axes.Title.String = 'Noise Power Spectral Density at the output of the PLL';
stc.label.x.String = 'Frequency (Hz)';
stc.label.y.String = 'S phi (dB/Hz)';
MyFigure_ChangeSize([1.7, 1]*512*1.2)
text.num1 = imtext(0.3,0.11, line4);
text.num2 = imtext(0.3,0.17, line2);
text.num3 = imtext(0.3,0.23, line1);
text.num4 = imtext(0.3,0.07, RBW);

for i = 1:4
    text.(['num', num2str(i)]).FontName = 'Times New Roman';
    text.(['num', num2str(i)]).FontSize = 13;
end
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-15-48-14_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>


利用 **2.1 tran simulation** 中仿真了 96 us 的大数据集，可以将 FFT points 提高到 2^16 = 65536, 此时的噪声功率谱就完整很多了：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-16-31-01_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-16-44-17_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

频率较低 (< 100 kHz) 时波形异常是因为我们的仿真只进行了 96 us (稳定后约九万个周期)，不足以得到频率过低的噪声功率谱。因此作图时将下限频率设置为 100 kHz, 效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-15-39-44_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>


参考资料 [[1] Cadence_PLL_Jitter_measurment_in_Spectre.pdf](https://www.writebug.com/static/uploads/2025/8/22/705f40616dd3afd7796ddfbe1d5b66d8.pdf) 中仿真了整整 7.500M 个周期 (频率 0.25 GHz), 因此得到的噪声功率谱可以很好地展示出低频时的情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-15-41-40_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>


上面计算的是 vout_freq 的相噪，不妨也算一下 vfb_freq 的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-16-48-30_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

### 2.3 would pss works?

事实上，在分频比不为 1 的锁相环中, pss (periodical steady-state) 仿真很难收敛，这篇问答 [Cadence Community > RF Design > PSS & PNOISE simulation for VCO and PLL](https://community.cadence.com/cadence_technology_forums/f/rf-design/49390/pss-pnoise-simulation-for-vco-and-pll) 的原话是：

>**PLLs are difficult to get convergence with in SpectreRF**. All signals must be periodic and the circuit must respond periodically, otherwise you won't get convergence.<br>
This is what I recommend to designers: **simulating PLLs and DLLs are best accomplished with transient noise analysis**. 

以及这篇问答 [Cadence Community > RF Design > [help] pll simulation in spectre](https://community.cadence.com/cadence_technology_forums/f/rf-design/29861/help-pll-simulation-in-spectre) 中的原话：

>Yes, this is possible (to run a PSS analysis of a closed-loop PLL), but it can be difficult if you have a large divide ratio. It's also only possible for integer-N PLLs (not Fractional PLLs).

因此，我们并不能保证闭环锁相环在 pss 仿真中能够收敛，但还是斗胆尝试一下。

### 2.3 pss simulation

如图设置 pss 仿真参数：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-17-51-14_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

**<span style='color:red'> 这里的关键点是 number of harmonics 的设置！ </span>** 我们的 PLL 为 64 分频的，因此 number of harmonics 至少也要填 64, 保险起见，我们填写 70.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-17-48-02_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-17-49-39_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

这里 tstab 仿真给了 1.5 us 有些长，所以仿真总共花了 26 min 比较长。在下面加入 pnoise 仿真前可以适当缩短 (比如 10 ns).

### 2.4 pnoise simulation

将 pss 的 tstab time 改为 10 ns, 设置好 pnoise 并运行仿真，发现 pss 不能正常收敛，于是重新修改回 1.5 us 进行仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-19-43-28_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-19-42-55_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

看一下 $J_{ee}$ (edge-to-edge jitter) 的情况 :

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-19-51-33_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

将 **<span style='color:red'> RMS Jee</span>** 的数据导出，到 MATLAB 中进行运算，先平方再积分，最后开根号得到总 RMS jitter 。按文献 [[4]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9847207) 的说法, RMS jitter 一般要从 1 kHz ~ 1 MHz 积分得到 (并且包含 PLL 的环路带宽)，原话是：

>Note that the RMS jitter is generally obtained by integrating PLL phase noise by 3 ~ 5 decades of frequency range, while the PLL loop bandwidth locates within the range.

我们的环路参数及其带宽为：

$$
\begin{gather}
I_P = 100 \ \mathrm{uA},\ K_{VCO} = 8 \ \mathrm{GHz/V},\ N = 64,\ R_P = 1 \ \mathrm{k}\Omega
\\
\Longrightarrow f_{BW} = 0.416 \ \mathrm{MHz}
\end{gather}
$$

确实落在了 1 kHz ~ 1 MHz 之间，因此直接在这个范围内积分就好：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-22-20-33-17_Virtuoso Tutorials - 13. Periodical Steady-State and Phase Noise Simulation (pss and pnoise).png"/></div>

RMS jitter = 3.901 ps, 这与 **2.2 transient jitter analysis** 一节中得到的结果基本一致。


### 2.5 figure of merit (FoM)

锁相环的 FoM 公式详见参考文献 [[4]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9847207):

$$
\begin{gather}
\mathrm{FoM}_{J} = 10 \log_{10} \left[ \left(\frac{\sigma_{jitter, rms}}{1 \ \mathrm{s}}\right)^2\cdot \left(\frac{\mathrm{power}}{1 \ \mathrm{mW}}\right) \right]
= \mathrm{\sigma_{jitter, rms}}_{\mathrm{dB}} + \mathrm{power}_{\mathrm{dBm}}
\\
\mathrm{FoM}_{JAN} = 10 \log_{10} \left[
    \left(\frac{\sigma_{jitter, rms}}{1 \ \mathrm{s}}\right)^2
    \cdot 
    \left(\frac{\mathrm{power}}{1 \ \mathrm{mW}}\right) 
    \cdot 
    \left( \frac{\mathrm{area}}{1 \ \mathrm{mm^2}} \right)
    \cdot 
    \left( \frac{1}{N} \right)
    \right]
\end{gather}
$$

根据 **2.2 transient jitter analysis** 一节得到的瞬态抖动结果，可以计算出我们锁相环的 FoM:

$$
\begin{gather}
I_{DD} = 472.9 \ \mathrm{uA},\ \sigma_{jitter} = 2.800 \ \mathrm{ps},\ N = 64
\\
\Longrightarrow 
\mathrm{FoM}_J = -234.3 \ \mathrm{dB},\quad 
\mathrm{FoM}_{JN} = -252.4 \ \mathrm{dB}
\end{gather}
$$

如果按 pnoise 仿真得到的 RMS jitter = 3.901 ps 来算，则有：

$$
\begin{gather}
I_{DD} = 472.9 \ \mathrm{uA},\ \sigma_{jitter} = 3.901 \ \mathrm{ps},\ N = 64
\\
\Longrightarrow 
\mathrm{FoM}_J = -231.4 \ \mathrm{dB},\quad 
\mathrm{FoM}_{JN} = -249.5 \ \mathrm{dB}
\end{gather}
$$



## 3. PSS or HB?

VCO 等周期性稳态仿真中还有一种方法是用 hb 仿真而非 pss, 例如这篇文章 [知乎 > 压控振荡器 (VCO) 的设计与仿真](https://zhuanlan.zhihu.com/p/693742034)，这和 pss 中选择 harmonic balance engine 是类似的，我们不多赘述。




## References

- [[1] Cadence_PLL_Jitter_measurment_in_Spectre.pdf](https://www.writebug.com/static/uploads/2025/8/22/705f40616dd3afd7796ddfbe1d5b66d8.pdf)
- [[2] Jitter measurement using SpectreRF Application Note.pdf](https://www.writebug.com/static/uploads/2025/8/22/28c1f61cd30eb054e8a9d5c6824f4d7e.pdf)
- [[3] SpectreRF Periodic Analysis.pdf](https://www.eecis.udel.edu/~vsaxena/courses/ece614/Handouts/SpectreRF%20Periodic%20Analysis.pdf)
- [[4]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9847207) W. Bae, “Benchmark Figure of Merit Extensions for Low Jitter Phase Locked Loops Inspired by New PLL Architectures,” IEEE Access, vol. 10, pp. 80680–80694, 2022, doi: 10.1109/ACCESS.2022.3195687.
- [[5]](https://www.ideals.illinois.edu/items/49560) R. Ratan, Design of a Phase-Locked Loop Based Clocking Circuit for High Speed Serial Link Applications. [Online]. Available: https://www.ideals.illinois.edu/items/49560



其它相关资料：

- [ELEN 6901 > PLL Phase Noise/Jitter Modeling and Simulation.pdf](https://www.columbia.edu/~ktj2102/PLLnoise_simulation.pdf)
- [Cadence Community > RF Design > [help] pll simulation in spectre](https://community.cadence.com/cadence_technology_forums/f/rf-design/29861/help-pll-simulation-in-spectre)
- [Cadence Community > RF Design > PSS & PNOISE simulation for VCO and PLL](https://community.cadence.com/cadence_technology_forums/f/rf-design/49390/pss-pnoise-simulation-for-vco-and-pll)
- [知乎 > Cadence pss 仿真](https://zhuanlan.zhihu.com/p/16816066025)

