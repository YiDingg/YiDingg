# Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 23:58 on 2025-12-21 in Beijing.

## 1. Introduction

在上一篇文章 [Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation](<AnalogIC/Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.md>) 中，我们介绍了基于 zero-crossing method 的相位噪声和抖动计算方法，并给出了完整的 MATLAB 代码实现。 本文将对比 zero-crossing method 和 direct power spectrum method 两种常用的相位噪声计算方法，直观感受它们在计算结果上的差异，并讨论各自适用场景和优缺点。

## 2. Zero-Crossing Method

之前已经介绍过，zero-crossing method 通过检测信号的过零点 (zero-crossing time) 来提取相位信息，进而计算相位噪声谱密度 L(f_m) 和积分抖动。该方法能够有效捕捉信号的抖动特性，适用于对抖动敏感的数字和混合信号电系统；<span style='color:red'> 缺点是提取 zero-crossing time 需要极高的时间分辨率，需要满足采样率 $f_s \gg f_0$ (信号频率) 才能获得准确结果 </span>，从后文的对比结果可以得到一个 <span style='color:red'> 经验值是： $f_s > 5 f_0 \sim 100 f_0$ @ sine clock, $f_s > 20 f_0 \sim 1000 f_0$ @ square clock. </span>



这里给出实现 zero-crossing method 的步骤思路：
- (1) 从采样所得离散信号 $v[n]$ 中提取 zero-crossing time sequence $t[n]$, 也常记作 $\mathrm{edge}[n]$.
- (2) 从边沿序列 $\mathrm{edge}[n]$ 计算周期序列 $T[n] = \mathrm{edge}[n+1] - \mathrm{edge}[n]$, 进一步得到 nominal period $T_0$ 和 nominal frequency $f_0 = 1/T_0$. 最常见的方法是对 $T[n]$ 求平均值，也有的是对 $\mathrm{edge}[n]$ 作线性拟合，两种方法稍有区别但效果相近，不会对结果产生本质影响。
- (3) 计算相位偏移序列 $2\pi f_0 ( \mathrm{edge}[n] - n T_0 ) $, 它近似等于在采样率 $f_s = f_0$ 时的相位噪声序列 $\phi_n[n]$, 即 $\phi_n[n] \approx 2\pi f_0 ( \mathrm{edge}[n] - n T_0 )$.
- (4) 有了相位噪声序列 $\phi_n[n]$ (采样率 $f_s = f_0$), 就可以计算其功率谱密度 $S_{\phi_n}(f_m)$ (这一步可以适当引入窗函数，但记得对结果作矫正), 进而得到 SSB phase noise $L(f_m) \approx \frac{1}{2} S_{\phi_n}(f_m)$.
- (5) 注意对 $S_{\phi_n}(f_m)$ 做傅里叶分析后直接得到的单位是 $\mathrm{rad_{rms}^2}$，此时 $L(f_m) = S_{\phi_n}(f_m)$ 的单位是 $1$ 或者 $\mathrm{dBc}$ <span style='color:red'> (注意这里不要除以二) </span>，这样的功率谱称为 power spectrum 而不是 power spectral density (PSD)；按业界习惯，我们应该将 $L(f_m)$ 的单位转化为 $\mathrm{dBc/Hz}$ (dB relative to carrier per Hertz)，只需让 $L(f_m)$ 除以频率分辨率 $\Delta f = f_s / N$ 即可 (先除以 $\Delta f$ 再取 dB)。
- 这样就得到了 **SSB normalized phase noise spectral density** $L(f_m)$，单位为 $\mathrm{1/Hz}$ 或 $\mathrm{dBc/Hz}$。


## 3. Power Spectrum Methodd

另一种常用的相位噪声计算方法是 direct power spectrum method, 它直接计算输出信号 $v[n]$ 的功率谱密度 $S_v(f_m)$，然后再作归一化和平移，得到相位噪声谱密度 $L(f_m)$。这种方法的优势在于实现简单，直接利用信号的频谱信息，无需提取过零点，并且对 spur 等频谱特性有较好的捕捉能力；相比 zero-crossing method, 它对采样率的要求较低 (通常只需 $f_s > 3 f_0$ 即可)，适用于频谱分析和系统级仿真场景，缺点是对抖动的捕捉能力较弱，且在低频段的相位噪声估计可能不够准确。

实现 direct power spectrum method 的步骤思路如下：
- (1) 直接对输出信号采样，得到输出信号序列 $v[n]$, 进行傅里叶分析得到输出信号功率谱密度 $S_v(f)$ (建议引入窗函数以抑制频谱泄漏，但记得对结果作矫正), 注意这里的单位是 $\mathrm{V_{rms}^2}$ 或 $\mathrm{dBV_{rms}^2}$ (power spectrum)。
- (2) 从功率谱密度 $S_v(f)$ 中提取载波频率 $f_0$ 处的功率 $P_{0}$, 一般是使用积分法在 $f_0$ 附近取一个小带宽 $\Delta f$ 进行积分得到 $P_{0}$
- (3) 有了载波功率 $P_{0}$ 后，可以计算归一化的功率谱，并进一步得到 SSB phase noise $L(f_m) \approx \frac{1}{2}\times \frac{S_v(f_0 + f_m)}{P_{0}}$
- (4) 注意上面的单位仍是 $\mathrm{1}$ 或 $\mathrm{dBc}$ (power spectrum)，需要除以频率分辨率 $\Delta f = f_s / N$ 转化为 PSD 单位 $\mathrm{1/Hz}$ 或 $\mathrm{dBc/Hz}$。
- (5) 这样就得到了 **SSB normalized phase noise spectral density** $L(f_m)$，单位为 $\mathrm{1/Hz}$ 或 $\mathrm{dBc/Hz}$。




## 4. Comparison of Results

不妨将上述两种方法分别封装为函数，记作 `MyAnalysis_PhaseNoise_zeroCrossing` 和 `MyAnalysis_PhaseNoise_powerSpectrum`，然后将这两个函数再合并为一个函数 `MyAnalysis_PhaseNoise_multiMethod`，这样方便后续对比和调用。具体代码详见文末，这里就先不放出来，以免影响观感。


### 4.1 sine clock @ 10.245 MHz

本小节利用 "非线性电路实验" 课中采样得到的 10.245 MHz 正弦振荡信号来对比两种方法的计算结果。采样参数如下：
- 采样设备: RIGOL MSO2202A (analog 8-bit, 200 MHz bandwidth, 2 GSa/s maximum real-time sample rate, 14 MB memory depth)
- 采样率: 1 GSa/s
- 采样点数: 140 kPoints (fr = 7.143 kHz)

下图展示了两种方法计算得到的相位噪声谱密度 $L(f_m)$ 对比结果：
<div class='center'>

| 1. sine clock @ 10.245 MHz |  |
|:-:|:-:|
 | 先看信号的波形和基本信息 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-17-48-26_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-17-48-31_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div> | 然后给出相位噪声计算结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-17-48-40_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-17-56-32_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div> |

</div>






### 4.2 square clock @ 786.432 kHz

这一小节是最近项目 ultra-low-power CP-PLL 中仿真得到的 786.432 kHz (CK_OUT) 输出时钟，从 cadence 中导出以下数据：
- (1) 输出时钟采样结果 v[n], 一开始使用的是 resampling 10 MHz, 发现 edge time 提取效果很不好，遂提高到 100 MHz resampling 
- (2) calculation 中 `PN()` 函数对 v[n] 的相位噪声计算结果，方便待会对比

<div class='center'>

| 2. square clock @ 786.432 kHz |  |
|:-:|:-:|
 | 先看信号的波形和基本信息 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-18-13-00_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-18-12-49_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div> | 然后给出相位噪声计算结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-18-11-47_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-18-22-23_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div> |

</div>

``` bash
"D:\aa_MyExperimentData\Raw data backup\202510_PLL_v2_SpectreXCX_tran15ms_allCorner_40fF_outX24_12points__CK_OUT_at_TT27_resample_100MHz.csv"
"D:\aa_MyExperimentData\Raw data backup\202510_PLL_v2_SpectreXCX_tran15ms_allCorner_40fF_outX24_12points__CK_OUT_phaseNoise__at_TT27.csv"
```

作为对比，我们利用准确的 edge time 数据再做一遍 zero-crossing method 计算，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-18-14-15_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>

对比 100 MHz resampling 和 accurate edge time 的结果，可以看出采用 **100 MHz resampling (f0 = 786.432 kHz, 原信号的 127.16 倍)** 时：
- (1) 受时间分辨率限制，$J_{c}[n]$ 和 $J_{cc}[n]$ 的分布存在明显误差，RMS value 也偏大 (约 2 倍)
- (2) TIE_L 有一定误差 (也增大，约 1.5 倍)，但整体趋势还算接近
- (3) <span style='color:red'> $J_{e}[n]$ 和 SSB phase noise $L(f_m)$ 结果基本一致，spur 结果也基本一致 </span>



### 4.3 square clock @ 98.304 kHz

这一小节是最近项目 ultra-low-power CP-PLL 中仿真得到的 98.304 kHz (CK_ADC) 输出时钟，从 cadence 中导出以下数据：
- (1) 输出时钟采样结果 v[n], resampling 100 MHz 
- (2) calculation 中 `PN()` 函数对 v[n] 的相位噪声计算结果，方便待会对比

<div class='center'>

| 2. square clock @ 98.304 kHz |  |
|:-:|:-:|
 | 先看信号的波形和基本信息 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-18-30-27_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-18-30-32_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div> | 然后给出相位噪声计算结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-18-34-04_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-18-35-27_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div> |

</div>

``` bash
"D:\aa_MyExperimentData\Raw data backup\202510_PLL_v2_SpectreXCX_tran15ms_allCorner_40fF_outX24_12points__CK_ADC_at_TT27_resample_100MHz.csv"
"D:\aa_MyExperimentData\Raw data backup\202510_PLL_v2_SpectreXCX_tran15ms_allCorner_40fF_outX24_12points__CK_ADC_phaseNoise_at_TT27.csv"
```

作为对比，我们利用准确的 edge time 数据再做一遍 zero-crossing method 计算，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-18-30-06_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>


对比 100 MHz resampling 和 accurate edge time 的结果，可以看出采用 **100 MHz resampling (f0 = 98.304 kHz, 原信号的 1017.25 倍)** 时：
- (1) 时间分辨率仍有一定影响，但基本可以忽略，因为各类型抖动的分布、RMS value 都和 accurate edge time 很接近，SSB phase noise 和 spur 结果也基本一致。





### 4.4 square clock @ 1.0 GHz

这一小节利用之前 1 GHz ~ 2 GHz CP-PLL 练手项目的仿真结果，来对比不同方法的相位噪声计算，从 cadence 中导出以下数据：
- (1) **1.0 GHz** 输出时钟采样结果 v[n], **resampling 0.051 ns (≈ 19.6078 GHz, f0 = 1.0 GHz, 是原信号的 19.61 倍)**, 使用 0.051 ns 是避免采样率恰好是信号频率的整数倍
- (2) calculation 中 `PN()` 函数对 v[n] 的相位噪声计算结果，方便待会对比

<div class='center'>

| 4. square clock @ 1.0 GHz |  |
|:-:|:-:|
 | 先看信号的波形和基本信息 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-19-01-37_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-19-01-41_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div> | 然后给出不同方法的相位噪声计算结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-19-01-46_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-19-02-09_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div> |

</div>

``` bash
"D:\aa_MyExperimentData\Raw data backup\202508_CPPLL_1GHz_1k_50p_400periods__vout_settled.csv"
"D:\aa_MyExperimentData\Raw data backup\202508_CPPLL_1GHz_1k_50p_400periods__vout_settled_phaseNoise.csv"
"D:\aa_MyExperimentData\Raw data backup\202508_CPPLL_1GHz_1k_50p_400periods__vout_freq_settled.csv"
```

类似地，作为对比，我们利用准确的 edge time 数据再做一遍 zero-crossing method 计算，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-18-59-49_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>


奇怪的是，对比 19.6078 GHz resampling (f0 = 1.0 GHz) 和 accurate edge time 的结果，可以看出尽管现在 resampling freq 虽然只有信号频率的 19.61 倍，但抖动和相噪结果仍非常接近 (仅在 high-offset 下有一定误差)，说明在高频信号下，zero-crossing method 对采样率的要求似乎没有想象中那么高？这点有待进一步验证。



### 4.5 square clock @ 1.28 GHz

还是利用 1 GHz ~ 2 GHz CP-PLL 练手项目的仿真结果，只是这次输出频率设置为了 1.28 GHz，从 cadence 中导出以下数据：
- (1) **1.28 GHz** 输出时钟采样结果 v[n], **resampling 0.051 ns (≈ 19.6078 GHz, f0 = 1.28 GHz, 是原信号的 15.32 倍)**, 使用 0.051 ns 是避免采样率恰好是信号频率的整数倍
- (2) calculation 中 `PN()` 函数对 v[n] 的相位噪声计算结果，方便待会对比

``` bash
"D:\aa_MyExperimentData\Raw data backup\202508_CPPLL_1d28GHz_1k_50p_400periods__vout_settled.csv"
"D:\aa_MyExperimentData\Raw data backup\202508_CPPLL_1d28GHz_1k_50p_400periods__vout_settled_phaseNoise.csv"
"D:\aa_MyExperimentData\Raw data backup\202508_CPPLL_1d28GHz_1k_50p_400periods__vout_freq_settled.csv"
```

<div class='center'>

| 5. square clock @ 1.28 GHz|  |
|:-:|:-:|
 | 先看信号的波形和基本信息 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-23-01-12_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-23-01-16_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div> | 然后给出不同方法的相位噪声计算结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-23-01-22_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-23-01-26_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div> |

</div>

类似地，作为对比，我们利用准确的 edge time 数据再做一遍 zero-crossing method 计算，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-23-23-01-36_Phase Noise Calculation Methods Comparison - Zero-Crossing and Power-Spectrum.png"/></div>


### 4.6 summary of comparison

将上述几个例子的对比图汇总如下：


## 5. Conclusion

上面的对比结果表明：
- (1) zero-crossing method 和 direct power spectrum method 在计算结果上基本一致，均能较好地反映信号的相位噪声特性
- (2) zero-crossing method 对采样率要求较高，通常需要 $f_s > 5 f_0 \sim 100 f_0$ @ sine clock, $f_s > 20 f_0 \sim 1000 f_0$ @ square clock 才能获得准确结果
- (3) direct power spectrum method 实现简单，对采样率要求较低 (通常只需 $f_s > 3 f_0$ 即可)，spur 计算结果更准确，但对抖动的捕捉能力较弱
- (4) RBW (resolution bandwidth) 的大小对功率谱和相噪计算结果均有影响，需要根据具体需求进行选择和调整
- (5) 注意计算 spur 时，需选择合适 RBW 进行积分，以避免 spur 能量被过度平滑



## Appendix: MATLAB Codes

本文所用到的 MATLAB 代码如下：

``` matlab
2025.12.22
Phase Noise Calculation Methods Comparison: Zero-Crossing and Power-Spectrum



1. sine clock @ 10.245 MHz
clc, clear
warning('off')
filename = "D:\aa_MyExperimentData\Raw data backup\2025-12-18_22-08-02__NCE-10__volt_vs_time 短电源线 + 无去耦电容 (Crystal, 10.244428 MHz @ 131.290 mVamp).txt"; 
data = readmatrix(filename);
v_n = data(:, 3)';
t_n = data(:, 4)';
fs = 1/(t_n(2) - t_n(1));


% 信号波形与基本信息
stc = MyPlot(t_n, v_n);
ylim([-0.2, 0.2]);
xlim([0, 10*(1/10e6)]);
stc.label.x.String = 'Time (s)';
stc.label.y.String = 'Voltage (V)';
MyFigure_ChangeSize_2048x512

f0 = 10.245e6;
delta_f = 0.5e6;
stc = MyAnalysis_Get_PowerAndFrequency(v_n, fs, f0, delta_f);
sig_f0 = stc.target.f0; disp(['f0 = ', num2str(sig_f0, '%.6f'), ' Hz'])  % Hz
sig_A0 = stc.target.A0; disp(['A0 = ', num2str(sig_A0, '%.6f'), ' Vamp']) % Vamp
sig_P0 = stc.target.P0; disp(['P0 = ', num2str(sig_P0, '%.6f'), ' Vrms^2']) % Vrms^2
stc = MyAnalysis_Spectrum_hanningWindow(v_n, fs, 1);


%% zero-crossing method
clc, clear
filename = "D:\aa_MyExperimentData\Raw data backup\2025-12-18_22-08-02__NCE-10__volt_vs_time 短电源线 + 无去耦电容 (Crystal, 10.244428 MHz @ 131.290 mVamp).txt"; 
data = readmatrix(filename);
v_n = data(:, 3)';
t_n = data(:, 4)';
fs = 1/(t_n(2) - t_n(1));

V_hysteresis = 1e-3;
stc = MyAnalysis_FindCrossingTime(v_n, fs, V_hysteresis);   % 提取 crossing time
edge_n = stc.edge_pos((1 + 10):(end - 10));  % 丢弃开头/结尾 edge 以避免异常数据
T_n = diff(edge_n);
f_n = 1./T_n;
N = length(T_n);

[para, ~, ~, ~] = MyFit_linear(0:(length(edge_n)-1), edge_n', 0);
T0 = para.k;
f0 = 1/T0;
vpa((T0 - mean(T_n))*1e12)
vpa(f0 - mean(f_n))

n_1toN = 1:length(edge_n);
phi_n = 2*pi*f0 * (edge_n - n_1toN * T0);
phi_n = phi_n - mean(phi_n);   % 去除 DC 偏移
stc = MyPlot(n_1toN, phi_n);
stc.label.x.String = 'Crosing Number';
stc.label.y.String = 'Je_n';
MyFigure_ChangeSize_2048x512

stc = MyAnalysis_Spectrum_hanningWindow(phi_n, f0, 1);
f_axis_1 = stc.STC.fAxis_oneSided;
S_phin = stc.STC.power_oneSided_corrected;
L_fm = S_phin/2; fr = stc.STC.fr;
L_fm_dBcHz_1 = 10*log10(L_fm / fr);
stc = MyPlot(f_axis_1, L_fm_dBcHz_1);
stc.label.x.String = 'Offset Frequency $f_m$ (Hz)';
stc.label.y.String = 'SSB phase noise $L(f_m)$ (dBc/Hz)';
MyFigure_ChangeSize_2048x512


%% Power Spectrum Method
filename = "D:\aa_MyExperimentData\Raw data backup\2025-12-18_22-08-02__NCE-10__volt_vs_time 短电源线 + 无去耦电容 (Crystal, 10.244428 MHz @ 131.290 mVamp).txt"; 
data = readmatrix(filename);
v_n = data(:, 3)';
t_n = data(:, 4)';
fs = 1/(t_n(2) - t_n(1));

stc = MyAnalysis_Spectrum_hanningWindow(v_n, fs, 1);
t_axis = stc.STC.t_n;
f_axis_2 = stc.STC.fAxis_oneSided;
S_vout = stc.STC.power_oneSided_corrected;
fr = stc.STC.fr;

f0 = 10.245e6;
delta_f = 0.5e6;
tv = MyAnalysis_Get_PowerAndFrequency(v_n, fs, f0, delta_f);
f0 = tv.target.f0;
P0 = tv.target.P0;
L_fm = S_vout/P0;
sum(S_vout)
L_fm_dBcHz_2 = 10*log10(L_fm / fr);   % 注意这里要除以 fr 才能将单位从 V^2 化为 V^2/Hz, 再除以 P0 归一化得到 dBc


stc = MyPlot(f_axis_2 - f0, L_fm_dBcHz_2);
%stc.axes.XLim = [f0/200, f0/2];
stc.axes.XLim = [0, f0/2];
stc.axes.XScale = 'log';
stc.axes.YLim = [-140, -40];
stc.label.x.String = 'Offset Frequency $f_m$ (Hz)';
stc.label.y.String = 'SSB phase noise $L(f_m)$ $\mathrm{(dBc/Hz)}$';
MyFigure_ChangeSize_2048x512



%% 合并对比
colors = MyGet_colors_nok;
tiledlayout(2, 1, 'TileSpacing', 'loose')

ax = nexttile; 
stc = MyPlot_ax(ax, f_axis_1, L_fm_dBcHz_1);
stc = MyPlot_ax(ax, f_axis_2 - f0, L_fm_dBcHz_2);
stc.plot.plot_1.Color = colors{4};
stc.label.y.String = 'SSB Phase Noise $L(f_m)$ (dBc/Hz)';
stc.label.x.String = 'Offset Frequency $f_m$ (Hz)';
stc.leg.Visible = 'on';
stc.leg.String = [
"Zero-Crossing Method"
"Power-Spectrum Method"
];
stc.axes.YLim = [-140, -40];
stc.axes.XLim = [0, f0/2];
stc.axes.XScale = 'linear';

title('1. sine clock @ 10.245 MHz', 'FontWeight', 'bold', 'Interpreter', 'none')

ax = nexttile;
stc = MyPlot_ax(ax, f_axis_1, L_fm_dBcHz_1);
stc = MyPlot_ax(ax, f_axis_2 - f0, L_fm_dBcHz_2);
stc.plot.plot_1.Color = colors{4};
stc.label.y.String = 'SSB Phase Noise $L(f_m)$ (dBc/Hz)';
stc.label.x.String = 'Offset Frequency $f_m$ (Hz)';
stc.leg.Visible = 'on';
stc.leg.String = [
"Zero-Crossing Method"
"Power-Spectrum Method"
];
stc.axes.YLim = [-140, -40];
stc.axes.XLim = [0, f0/2];
stc.axes.XScale = 'log';

MyFigure_ChangeSize([4, 2]*512*0.8)
MyFigure_Show
MyExport_png(100)


将两种方法封装为单个函数 
1. sine clock @ 10.245 MHz
warning('off')
file_names = [
"D:\aa_MyExperimentData\Raw data backup\2025-12-18_22-08-02__NCE-10__volt_vs_time 短电源线 + 无去耦电容 (Crystal, 10.244428 MHz @ 131.290 mVamp).txt"
];
filename = file_names(1); 
data = readmatrix(filename);
t_n = data(:, 4)'; t_n = t_n - t_n(1);
v_n = data(:, 3)';
fs = 1/(t_n(2) - t_n(1));

%%%%%%%%%%%%%%%%%%%%
flag_export_fig = 0;
%%%%%%%%%%%%%%%%%%%%

stc = MyPlot(t_n, v_n);
ylim([-0.2, 0.2])
xlim([0, 10*(1/(10.245e6))])
stc.label.x.String = 'Time (s)';
stc.label.y.String = 'Voltage (V)';
MyFigure_ChangeSize_2048x512
if flag_export_fig; MyExport_png(100); end
MyAnalysis_Spectrum_hanningWindow(v_n, fs, 1, 10);
if flag_export_fig; MyExport_png(100); end


stc = MyAnalysis_Get_CrossingTime(v_n, fs, 1e-03);   % 提取 crossing time
edge_n = stc.edge_pos((1 + 10):(end - 10));  % 丢弃开头/结尾 edge 以避免异常数据
figure;
MyAnalysis_PhaseNoise_v2_20251112(edge_n, 1);
if flag_export_fig; MyExport_png(100); end


stc = MyAnalysis_PhaseNoise_multiMethod(v_n, fs, 1);
title(stc.plot_stc1.axes, '1. sine clock @ 10.245 MHz', 'FontWeight', 'bold', 'Interpreter', 'none')
stc.plot_stc1.axes.YLim = [-120 0];
stc.plot_stc2.axes.YLim = [-160 -40];
stc.plot_stc3.axes.YLim = [-160 -40];






2. square clock @ 786.432 kHz
warning('off')
file_names = [
"D:\aa_MyExperimentData\Raw data backup\202510_PLL_v2_SpectreXCX_tran15ms_allCorner_40fF_outX24_12points__CK_OUT_at_TT27_resample_100MHz.csv"
"D:\aa_MyExperimentData\Raw data backup\202510_PLL_v2_SpectreXCX_tran15ms_allCorner_40fF_outX24_12points__CK_OUT_phaseNoise__at_TT27.csv"
];
filename = file_names(1); 
data = readmatrix(filename);
t_n = data(:, 1)'; t_n = t_n - t_n(1);
v_n = data(:, 2)';
fs = 1/(t_n(2) - t_n(1));

%%%%%%%%%%%%%%%%%%%%
flag_export_fig = 0;
%%%%%%%%%%%%%%%%%%%%

stc = MyPlot(t_n, v_n);
ylim([0 - 0.01, 1.25 + 0.01])
xlim([0, 10*(1/(24*32.768e3))])
stc.label.x.String = 'Time (s)';
stc.label.y.String = 'Voltage (V)';
MyFigure_ChangeSize_2048x512
if flag_export_fig; MyExport_png(100); end
MyAnalysis_Spectrum_hanningWindow(v_n, fs, 1, 5);
if flag_export_fig; MyExport_png(100); end


stc = MyAnalysis_Get_CrossingTime(v_n, fs, 1e-03);   % 提取 crossing time
edge_n = stc.edge_pos((1 + 10):(end - 10));  % 丢弃开头/结尾 edge 以避免异常数据
figure;
MyAnalysis_PhaseNoise_v2_20251112(edge_n, 1);
if flag_export_fig; MyExport_png(100); end


stc = MyAnalysis_PhaseNoise_multiMethod(v_n, fs, 1);
title(stc.plot_stc1.axes, '2. square clock @ 786.432 kHz', 'FontWeight', 'bold', 'Interpreter', 'none')
filename_virtuoso_PN = file_names(2);
data = readmatrix(filename_virtuoso_PN);
f_axis = data(:, 1)';
L_fm_dBcHz = data(:, 2)';
tv = MyPlot_ax(stc.plot_stc3.axes, f_axis, L_fm_dBcHz);
stc.plot_stc1.axes.YLim = [-100 0];
stc.plot_stc2.axes.YLim = [-120 -20];
stc.plot_stc3.axes.YLim = [-120 -20];
tv.plot.plot_1.Color = 'r';
tv.leg.Visible = 'on';
tv.leg.String = [
"Zero-Crossing Method"
"Power-Spectrum Method"
"PN() in Virtuoso Calculator"
];
stc.plot_stc3.label.x.String = stc.plot_stc2.label.x.String;
stc.plot_stc3.label.y.String = stc.plot_stc2.label.y.String;
stc.plot_stc3.label.x.FontSize = 14;
stc.plot_stc3.label.y.FontSize = 14;





3. square clock @ 98.304 kHz
file_names = [
"D:\aa_MyExperimentData\Raw data backup\202510_PLL_v2_SpectreXCX_tran15ms_allCorner_40fF_outX24_12points__CK_ADC_at_TT27_resample_100MHz.csv"
"D:\aa_MyExperimentData\Raw data backup\202510_PLL_v2_SpectreXCX_tran15ms_allCorner_40fF_outX24_12points__CK_ADC_phaseNoise_at_TT27.csv"
];
filename = file_names(1); 
data = readmatrix(filename);
t_n = data(:, 1)'; t_n = t_n - t_n(1);
v_n = data(:, 2)';
fs = 1/(t_n(2) - t_n(1));

%%%%%%%%%%%%%%%%%%%%
flag_export_fig = 0;
%%%%%%%%%%%%%%%%%%%%

stc = MyPlot(t_n, v_n);
ylim([0 - 0.01, 1.25 + 0.01])
xlim([0, 10*(1/(03*32.768e3))])
stc.label.x.String = 'Time (s)';
stc.label.y.String = 'Voltage (V)';
MyFigure_ChangeSize_2048x512
if flag_export_fig; MyExport_png(100); end
MyAnalysis_Spectrum_hanningWindow(v_n, fs, 1, 0.5);
if flag_export_fig; MyExport_png(100); end


stc = MyAnalysis_Get_CrossingTime(v_n, fs, 1e-03);   % 提取 crossing time
edge_n = stc.edge_pos((1 + 10):(end - 10));  % 丢弃开头/结尾 edge 以避免异常数据
MyAnalysis_PhaseNoise_v2_20251112(edge_n, 1);
if flag_export_fig; MyExport_png(100); end


stc = MyAnalysis_PhaseNoise_multiMethod(v_n, fs, 1);
title(stc.plot_stc1.axes, '3. square clock @ 98.304 kHz', 'FontWeight', 'bold', 'Interpreter', 'none')
filename_virtuoso_PN = file_names(2);
data = readmatrix(filename_virtuoso_PN);
f_axis = data(:, 1)';
L_fm_dBcHz = data(:, 2)';
tv = MyPlot_ax(stc.plot_stc3.axes, f_axis, L_fm_dBcHz);
stc.plot_stc1.axes.YLim = [-100 0];
stc.plot_stc2.axes.YLim = [-120 -20];
stc.plot_stc3.axes.YLim = [-120 -20];
tv.plot.plot_1.Color = 'r';
tv.leg.Visible = 'on';
tv.leg.String = [
"Zero-Crossing Method"
"Power-Spectrum Method"
"PN() in Virtuoso Calculator"
];
stc.plot_stc3.label.x.String = stc.plot_stc2.label.x.String;
stc.plot_stc3.label.y.String = stc.plot_stc2.label.y.String;
stc.plot_stc3.label.x.FontSize = 14;
stc.plot_stc3.label.y.FontSize = 14;

对比 3. square clock @ 98.304 kHz 不同 resampling freq 时的结果
file_names = [
"D:\aa_MyExperimentData\Raw data backup\202510_PLL_v2_SpectreXCX_tran15ms_allCorner_40fF_outX24_12points__CK_ADC_at_TT27_resample_10MHz.csv"
"D:\aa_MyExperimentData\Raw data backup\202510_PLL_v2_SpectreXCX_tran15ms_allCorner_40fF_outX24_12points__CK_ADC_at_TT27_resample_100MHz.csv"
];
filename = file_names(1);
data = readmatrix(filename);
t_n = data(:, 1)'; t_n = t_n - t_n(1);
v_n = data(:, 2)';
fs = 1/(t_n(2) - t_n(1));
stc = MyAnalysis_Get_CrossingTime(v_n, fs, 1e-03);   % 提取 crossing time
edge_n = stc.edge_pos((1 + 10):(end - 10));  % 丢弃开头/结尾 edge 以避免异常数据
MyAnalysis_PhaseNoise_v2_20251112(edge_n, 0);
MyAnalysis_PhaseNoise_multiMethod(v_n, fs, 1);
fr = fs/length(v_n)


filename = file_names(2);
data = readmatrix(filename);
t_n = data(:, 1)'; t_n = t_n - t_n(1);
v_n = data(:, 2)';
fs = 1/(t_n(2) - t_n(1));
stc = MyAnalysis_Get_CrossingTime(v_n, fs, 1e-03);   % 提取 crossing time
edge_n = stc.edge_pos((1 + 10):(end - 10));  % 丢弃开头/结尾 edge 以避免异常数据
MyAnalysis_PhaseNoise_v2_20251112(edge_n, 1);
MyAnalysis_PhaseNoise_multiMethod(v_n, fs, 1);
fr = fs/length(v_n)


filename = file_names(2);
data = readmatrix(filename);
t_n = data(:, 1)'; t_n = t_n - t_n(1);
v_n = data(:, 2)'; 
v_n = v_n(1:ceil(end/pi)); t_n = t_n(1:ceil(end/pi));

fs = 1/(t_n(2) - t_n(1));
stc = MyAnalysis_Get_CrossingTime(v_n, fs, 1e-03);   % 提取 crossing time
edge_n = stc.edge_pos((1 + 10):(end - 10));  % 丢弃开头/结尾 edge 以避免异常数据
MyAnalysis_PhaseNoise_v2_20251112(edge_n, 0);
MyAnalysis_PhaseNoise_multiMethod(v_n, fs, 1);
fr = fs/length(v_n)


filename = file_names(2);
data = readmatrix(filename);
t_n = data(:, 1)'; t_n = t_n - t_n(1);
v_n = data(:, 2)';
fs = 1/(t_n(2) - t_n(1));
fr = fs/length(v_n)
f0 = MyAnalysis_Get_PowerAndFrequency(v_n, fs).target.f0
P0 = MyAnalysis_Get_PowerAndFrequency(v_n, fs).target.P0
f_ref = 32.768e3; delta_f = f_ref/4;
f_spur = f0 + f_ref;
stc = MyAnalysis_Get_PowerAndFrequency(v_n, fs, f_spur, delta_f).target
f_offset = stc.f0 - f0
ref_spur_dBc = 10*log10(P0./stc.P0)


v_n = v_n(1:ceil(end/pi/2)); t_n = t_n(1:ceil(end/pi/2));
fr = fs/length(v_n)
f0 = MyAnalysis_Get_PowerAndFrequency(v_n, fs).target.f0
P0 = MyAnalysis_Get_PowerAndFrequency(v_n, fs).target.P0
f_ref = 32.768e3; delta_f = f_ref/4;
f_spur = f0 + f_ref;
stc = MyAnalysis_Get_PowerAndFrequency(v_n, fs, f_spur, delta_f).target
f_offset = stc.f0 - f0
ref_spur_dBc = 10*log10(P0./stc.P0)

v_n = v_n(1:ceil(end/2)); t_n = t_n(1:ceil(end/2));
fr = fs/length(v_n)
f0 = MyAnalysis_Get_PowerAndFrequency(v_n, fs).target.f0
P0 = MyAnalysis_Get_PowerAndFrequency(v_n, fs).target.P0
f_ref = 32.768e3; delta_f = f_ref/4;
f_spur = f0 + f_ref;
stc = MyAnalysis_Get_PowerAndFrequency(v_n, fs, f_spur, delta_f).target
f_offset = stc.f0 - f0
ref_spur_dBc = 10*log10(P0./stc.P0)




4. square clock @ 1.0 GHz
file_names = [
"D:\aa_MyExperimentData\Raw data backup\202508_CPPLL_1GHz_1k_50p_400periods__vout_settled.csv"
"D:\aa_MyExperimentData\Raw data backup\202508_CPPLL_1GHz_1k_50p_400periods__vout_settled_phaseNoise.csv"
"D:\aa_MyExperimentData\Raw data backup\202508_CPPLL_1GHz_1k_50p_400periods__vout_freq_settled.csv"
];
filename = file_names(1); 
data = readmatrix(filename);
t_n = data(:, 1)'; t_n = t_n - t_n(1);
v_n = data(:, 2)';
fs = 1/(t_n(2) - t_n(1));

%%%%%%%%%%%%%%%%%%%%
flag_export_fig = 1;
%%%%%%%%%%%%%%%%%%%%

stc = MyPlot(t_n, v_n);
ylim([0 - 0.01, 1.0 + 0.01])
xlim([0, 10*(1/(1e9))])
stc.label.x.String = 'Time (s)';
stc.label.y.String = 'Voltage (V)';
MyFigure_ChangeSize_2048x512
if flag_export_fig; MyExport_png(100); end
MyAnalysis_Spectrum_hanningWindow(v_n, fs, 1, 20);
if flag_export_fig; MyExport_png(100); end


stc = MyAnalysis_Get_CrossingTime(v_n, fs, 1e-03);   % 提取 crossing time
edge_n = stc.edge_pos((1 + 10):(end - 10));  % 丢弃开头/结尾 edge 以避免异常数据
figure;
MyAnalysis_PhaseNoise_v2_20251112(edge_n, 1);
if flag_export_fig; MyExport_png(100); end


stc = MyAnalysis_PhaseNoise_multiMethod(v_n, fs, 1);
title(stc.plot_stc1.axes, '4. square clock @ 1.0 GHz', 'FontWeight', 'bold', 'Interpreter', 'none')
filename_virtuoso_PN = file_names(2);
data = readmatrix(filename_virtuoso_PN);
f_axis = data(:, 1)';
L_fm_dBcHz = data(:, 2)';
tv = MyPlot_ax(stc.plot_stc3.axes, f_axis, L_fm_dBcHz);
stc.plot_stc1.axes.YLim = [-120 0];
stc.plot_stc2.axes.YLim = [-140 -40];
stc.plot_stc3.axes.YLim = [-140 -40];
tv.plot.plot_1.Color = 'r';
tv.leg.Visible = 'on';
tv.leg.String = [
"Zero-Crossing Method"
"Power-Spectrum Method"
"PN() in Virtuoso Calculator"
];
stc.plot_stc3.label.x.String = stc.plot_stc2.label.x.String;
stc.plot_stc3.label.y.String = stc.plot_stc2.label.y.String;
stc.plot_stc3.label.x.FontSize = 14;
stc.plot_stc3.label.y.FontSize = 14;



%% 准确 edge time 结果对比
filename = file_names(3);
data = readmatrix(filename);
f_n = data(:, 2)';  T_n = 1./f_n;
% 找出并剔除异常值
mean_val = mean(T_n);
std_val = std(T_n);
threshold = 10;  % 几倍标准差
normal_idx = abs(T_n - mean_val) <= threshold * std_val;    % 找出正常值的索引
T_cleaned = T_n(normal_idx);
disp(['剔除的异常值: ', num2str(T_n(~normal_idx))]);


edge_n = cumsum(T_cleaned);   % 将 f_n 转化为 edge_n
stc = MyAnalysis_PhaseNoise_v2_20251112(edge_n, 1);


修改 power-spectrum method 的函数：
作 FFT 得到功率谱后，先令 RBW = delta_f * L 作 “积分”，得到新的频谱后再除以 RBW 得到 dBc/Hz 频谱，这样算出来的结果更准确？(有待考察)。注意这里的 “积分” 应该用求和，因为傅里叶分析直接得到的是 Vrms^2 而非 Vrms^2/Hz
file_names = [
"D:\aa_MyExperimentData\Raw data backup\202510_PLL_v2_SpectreXCX_tran15ms_allCorner_40fF_outX24_12points__CK_ADC_at_TT27_resample_10MHz.csv"
"D:\aa_MyExperimentData\Raw data backup\202510_PLL_v2_SpectreXCX_tran15ms_allCorner_40fF_outX24_12points__CK_ADC_at_TT27_resample_100MHz.csv"
];
filename = file_names(2);
data = readmatrix(filename);
t_n = data(:, 1)'; t_n = t_n - t_n(1);
v_n = data(:, 2)';
fs = 1/(t_n(2) - t_n(1));

%v_n = v_n(1:floor(end/10))
v_n = v_n(  floor(end/(300*pi)) : (end-floor(end/(300*pi)))  )
MyAnalysis_Spectrum_hanningWindow(v_n, fs, 1).STC
MyAnalysis_Get_PowerAndFrequency(v_n, fs).target


%stc = MyAnalysis_PhaseNoise_powerSpectrum(v_n, fs, 1)
stc = MyAnalysis_PhaseNoise_multiMethod(v_n, fs, 1)
stc.plot_stc1
stc.STC_powerSpectrum.S_vout
stc.STC_powerSpectrum.P0


5. square clock @ 1.28 GHz
file_names = [
"D:\aa_MyExperimentData\Raw data backup\202508_CPPLL_1d28GHz_1k_50p_400periods__vout_settled.csv"
"D:\aa_MyExperimentData\Raw data backup\202508_CPPLL_1d28GHz_1k_50p_400periods__vout_settled_phaseNoise.csv"
"D:\aa_MyExperimentData\Raw data backup\202508_CPPLL_1d28GHz_1k_50p_400periods__vout_freq_settled.csv"
];
filename = file_names(1); 
data = readmatrix(filename);
t_n = data(:, 1)'; t_n = t_n - t_n(1);
v_n = data(:, 2)';
fs = 1/(t_n(2) - t_n(1));

%%%%%%%%%%%%%%%%%%%%
flag_export_fig = 0;
%%%%%%%%%%%%%%%%%%%%

stc = MyPlot(t_n, v_n);
ylim([0 - 0.01, 1.0 + 0.01])
xlim([0, 10*(1/(1e9))])
stc.label.x.String = 'Time (s)';
stc.label.y.String = 'Voltage (V)';
MyFigure_ChangeSize_2048x512
if flag_export_fig; MyExport_png(100); end
MyAnalysis_Spectrum_hanningWindow(v_n, fs, 1, 20);
if flag_export_fig; MyExport_png(100); end


stc = MyAnalysis_Get_CrossingTime(v_n, fs, 1e-03);   % 提取 crossing time
edge_n = stc.edge_pos((1 + 10):(end - 10));  % 丢弃开头/结尾 edge 以避免异常数据
figure;
MyAnalysis_PhaseNoise_v2_20251112(edge_n, 1);
if flag_export_fig; MyExport_png(100); end


stc = MyAnalysis_PhaseNoise_multiMethod(v_n, fs, 1);
title(stc.plot_stc1.axes, '5. square clock @ 1.28 GHz', 'FontWeight', 'bold', 'Interpreter', 'none')
filename_virtuoso_PN = file_names(2);
data = readmatrix(filename_virtuoso_PN);
f_axis = data(:, 1)';
L_fm_dBcHz = data(:, 2)';
tv = MyPlot_ax(stc.plot_stc3.axes, f_axis, L_fm_dBcHz);
stc.plot_stc1.axes.YLim = [-120 0];
stc.plot_stc2.axes.YLim = [-140 -40];
stc.plot_stc3.axes.YLim = [-140 -40];
tv.plot.plot_1.Color = 'r';
tv.leg.Visible = 'on';
tv.leg.String = [
"Zero-Crossing Method"
"Power-Spectrum Method"
"PN() in Virtuoso Calculator"
];
stc.plot_stc3.label.x.String = stc.plot_stc2.label.x.String;
stc.plot_stc3.label.y.String = stc.plot_stc2.label.y.String;
stc.plot_stc3.label.x.FontSize = 14;
stc.plot_stc3.label.y.FontSize = 14;



%% 准确 edge time 结果对比
filename = file_names(3);
data = readmatrix(filename);
f_n = data(:, 2)';  T_n = 1./f_n;
% 找出并剔除异常值
mean_val = mean(T_n);
std_val = std(T_n);
threshold = 10;  % 几倍标准差
normal_idx = abs(T_n - mean_val) <= threshold * std_val;    % 找出正常值的索引
T_cleaned = T_n(normal_idx);
disp(['剔除的异常值: ', num2str(T_n(~normal_idx))]);


edge_n = cumsum(T_cleaned);   % 将 f_n 转化为 edge_n
stc = MyAnalysis_PhaseNoise_v2_20251112(edge_n, 1);




函数区
function STC = MyAnalysis_PhaseNoise_zeroCrossing(edge_n, flag_drawFigure)

    [para, ~, ~, ~] = MyFit_linear(0:(length(edge_n)-1), edge_n', 0);
    T0 = para.k;
    f0 = 1/T0;
    
    n_1toN = 1:length(edge_n);
    phin_n = 2*pi*f0 * (edge_n - n_1toN * T0);
    phin_n = phin_n - mean(phin_n);   % 去除 DC 偏移
    

    stc = MyAnalysis_Spectrum_hanningWindow(phin_n, f0, flag_drawFigure);
    fm_axis = stc.STC.fAxis_oneSided;
    S_phin = stc.STC.power_oneSided_corrected;
    L_fm = S_phin/2; fr = stc.STC.fr;
    L_fm_dBcHz = 10*log10(L_fm / fr);

    % 输出相关结果
    STC.fourierAnalysis = stc;
    STC.T0 = T0;
    STC.f0 = f0;
    STC.n_1toN = n_1toN;
    STC.edge_n = edge_n;
    STC.phin_n = phin_n;
    STC.fm_axis = fm_axis;
    STC.S_phin = S_phin;
    STC.L_fm = L_fm;
    STC.L_fm_dBcHz = L_fm_dBcHz;


    % 作图
    if flag_drawFigure
        figure
        tiledlayout(3, 1, 'TileSpacing', 'loose')

        ax = nexttile;
        stc = MyPlot_ax(ax, n_1toN - 1, rad2deg(phin_n));
        stc.label.x.String = 'Crosing Number $n$ (0 to N-1)';
        stc.label.y.String = 'Edge Phase Noise $\phi_n[n]$ ($^\circ$)';
        stc.label.x.FontSize = 14;
        stc.label.y.FontSize = 14;
        STC.plot_stc1 = stc;

        ax = nexttile;
        stc = MyPlot_ax(ax, fm_axis, L_fm_dBcHz);
        stc.label.x.String = 'Offset Frequency $f_m$ (Hz)';
        stc.label.y.String = 'SSB Phase Noise $L(f_m)$ (dBc/Hz)';
        stc.label.x.FontSize = 14;
        stc.label.y.FontSize = 14;
        STC.plot_stc2 = stc;

        ax = nexttile;
        stc = MyPlot_ax(ax, fm_axis, L_fm_dBcHz);
        stc.label.x.String = 'Offset Frequency $f_m$ (Hz)';
        stc.label.y.String = 'SSB Phase Noise $L(f_m)$ (dBc/Hz)';
        stc.axes.XScale = 'log';
        stc.label.x.FontSize = 14;
        stc.label.y.FontSize = 14;
        STC.plot_stc3 = stc;

        MyFigure_ChangeSize([4, 3]*512*0.7)
    end

end


function STC = MyAnalysis_PhaseNoise_powerSpectrum(v_n, fs, flag_drawFigure, f0_expected, delta_f)

    stc = MyAnalysis_Spectrum_hanningWindow(v_n, fs, flag_drawFigure);
    t_axis = stc.STC.t_n;
    f_axis = stc.STC.fAxis_oneSided;
    S_vout = stc.STC.power_oneSided_corrected;
    fr = stc.STC.fr;
    
    if nargin == 3
        [~, ind] = max(S_vout(2:end));    % 最大值所在频率作为 f0_expected
        f0_expected = f_axis(ind);
        delta_f = 8*fr;
    end

    tv = MyAnalysis_Get_PowerAndFrequency(v_n, fs, f0_expected, delta_f);
    f0 = tv.target.f0;
    P0 = tv.target.P0;
    L_fm = S_vout/P0;
    L_fm_dBcHz = 10*log10(L_fm / fr);   % 注意这里要除以 fr 才能将单位从 V^2 化为 V^2/Hz, 再除以 P0 归一化得到 dBc
    
    flag_use_RBW = 0;
    if flag_use_RBW
        % 利用 RBW 再计算一下
        stc_withRBW = MyAnalysis_Get_PowerAndFrequency_Spectrum(stc);
        RBW = stc_withRBW.RBW;
        S_vout_RBW = stc_withRBW.power_RBW;
        L_fm_RBW = S_vout_RBW/P0;
        L_fm_RBW_dBcHz = 10*log10(L_fm_RBW / RBW);
    end

    % 提取特定频率范围内的结果, 准备作图
    index = (f_axis - f0) >= 0 & (f_axis - f0) <= f0/2;
    fm_axis = f_axis(index) - f0;
    L_fm = L_fm(index);
    L_fm_dBcHz = L_fm_dBcHz(index);
    if flag_use_RBW
        L_fm_RBW = L_fm_RBW(index);
        L_fm_RBW_dBcHz = L_fm_RBW_dBcHz(index);
    end


    

    % 输出相关结果
    STC.spectrum = stc;
    STC.fs = fs;
    STC.fr = fr;
    STC.T0 = 1/f0;
    STC.f0 = f0;
    STC.P0 = P0;
    STC.f_axis = f_axis;
    STC.S_vout = S_vout;
    STC.fm_axis = fm_axis;
    STC.L_fm = L_fm;
    STC.L_fm_dBcHz = L_fm_dBcHz;
    
    if flag_use_RBW
        STC.spectrum_withRBW = stc_withRBW;
        STC.S_vout_RBW = S_vout_RBW;
        STC.L_fm_RBW = L_fm_RBW;
        STC.L_fm_RBW_dBcHz = L_fm_RBW_dBcHz;
    end

    if flag_drawFigure
        figure
        tiledlayout(2, 1, 'TileSpacing', 'loose')

        leg_str = [
          "Raw DFT Results"
          "RBW Corrected Results"
        ];

        ax = nexttile;
        if flag_use_RBW
            stc = MyPlot_ax(ax, f_axis, [10*log10(S_vout/P0); 10*log10(S_vout_RBW/P0)]);
            stc.leg.String = leg_str;
        else
            stc = MyPlot_ax(ax, f_axis, 10*log10(S_vout/P0));
        end
        stc.axes.XLim = [f0 - f0/2, f0 + f0/2];
        stc.label.x.String = 'Frequency $f$ (Hz)';
        stc.label.y.String = 'Normalized Power Spectrum $\frac{S_{v}(f)}{P_c}$ $\mathrm{(dBc)}$';
        stc.label.x.FontSize = 14;
        stc.label.y.FontSize = 14;
        STC.plot_stc1 = stc;

        ax = nexttile;
        if flag_use_RBW
            stc = MyPlot_ax(ax, fm_axis, [L_fm_dBcHz; L_fm_RBW_dBcHz]);
            stc.leg.String = leg_str;
        else
            stc = MyPlot_ax(ax, fm_axis, L_fm_dBcHz);
        end
        
        stc.label.x.String = 'Offset Frequency $f_m$ (Hz)';
        stc.label.y.String = 'SSB Phase Noise $L(f_m)$ (dBc/Hz)';
        stc.label.x.FontSize = 14;
        stc.label.y.FontSize = 14;
        STC.plot_stc2 = stc;

        MyFigure_ChangeSize([4, 2]*512*0.8)
    end
end


function STC = MyAnalysis_PhaseNoise_multiMethod(v_n, fs, flag_drawFigure, f0_expected, delta_f)
    
    V_hysteresis = 1e-3;
    stc = MyAnalysis_Get_CrossingTime(v_n, fs, V_hysteresis);   % 提取 crossing time
    edge_n = stc.edge_pos((1 + 10):(end - 10));  % 丢弃开头/结尾 edge 以避免异常数据

    if nargin == 3
        STC = MyAnalysis_PhaseNoise_multiMethod_giveEdgeTime(v_n, fs, flag_drawFigure, edge_n);
    else
        STC = MyAnalysis_PhaseNoise_multiMethod_giveEdgeTime(v_n, fs, flag_drawFigure, edge_n, f0_expected, delta_f);
    end

end


function STC = MyAnalysis_PhaseNoise_multiMethod_giveEdgeTime(v_n, fs, flag_drawFigure, edge_n, f0_expected, delta_f)
    
    stc = MyAnalysis_PhaseNoise_zeroCrossing(edge_n, 0);
    STC.STC_zeroCrossing = stc;

    if nargin == 4
        stc = MyAnalysis_PhaseNoise_powerSpectrum(v_n, fs, 0);
    else
        stc = MyAnalysis_PhaseNoise_powerSpectrum(v_n, fs, 0, f0_expected, delta_f);
    end
    STC.STC_powerSpectrum = stc;
    
    f0 = STC.STC_zeroCrossing.f0;
    fm_axis_1 = STC.STC_zeroCrossing.fm_axis;
    L_fm_dBcHz_1 = STC.STC_zeroCrossing.L_fm_dBcHz;
    fm_axis_2 = STC.STC_powerSpectrum.fm_axis;
    L_fm_dBcHz_2 = STC.STC_powerSpectrum.L_fm_dBcHz;
    %L_fm_dBcHz_2 = STC.STC_powerSpectrum.L_fm_RBW_dBcHz;

    f_axis = STC.STC_powerSpectrum.f_axis;
    P0 = STC.STC_powerSpectrum.P0;
    S_vout = STC.STC_powerSpectrum.S_vout;
    % S_vout_RBW = STC.STC_powerSpectrum.S_vout_RBW;
    
    if flag_drawFigure
        colors = MyGet_colors_nok;
        figure
        tiledlayout(3, 1, 'TileSpacing', 'loose')
        
        ax = nexttile;
        stc = MyPlot_ax(ax, f_axis, 10*log10(S_vout/P0));
        stc.plot.plot_1.Color = colors{4};
        stc.axes.XLim = [f0 - f0/2, f0 + f0/2];
        stc.axes.YLim(2) = 0;
        stc.label.x.String = 'Frequency $f$ (Hz)';
        stc.label.y.String = 'Normalized Power Spectrum $\frac{S_{v}(f)}{P_c}$ $\mathrm{(dBc)}$';
        stc.label.x.FontSize = 14;
        stc.label.y.FontSize = 14;
        STC.plot_stc1 = stc;

        % 在合适的位置添加注释
        XLIM = stc.axes.XLim;
        YLIM = stc.axes.YLim;
        text(stc.axes, ...
            XLIM(2) - 0.42*(XLIM(2) - XLIM(1)), YLIM(2) - 0.42*(YLIM(2) - YLIM(1)), ...
            [ ...
                "Sampling Points $N$ = " + num2str(length(v_n)/1e3, '%.3f') + " kPoints";
                "Sampling Frequency $f_s$ = " + num2str(fs, '%.3e') + " Hz";
                "Frequency Resolution $f_r$ = " + num2str(fs/length(v_n), '%.3e') + " Hz";
                "Nominal Frequency $f_0$ = " + num2str(STC.STC_powerSpectrum.f0, '%.3e') + " Hz";
                "Nominal Amplitude $A_0$ = " + num2str(sqrt(2*STC.STC_powerSpectrum.P0), '%.4f') + " $\mathrm{V_{amp}}$";
                "Nominal Power $P_0$ = " + num2str(STC.STC_powerSpectrum.P0, '%.4f') + " $\mathrm{V_{rms}^2}$";
                
            ], ...
            'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
            'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
            'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
            'EdgeColor', 'k', ...               % 设置黑色边框（可选）
            'Margin', 2, ...                    % 设置文本与边框的边距（可选）
            'FontSize', 10, ...
            'Interpreter', 'latex' ...
        );
    


        ax = nexttile; 
        stc = MyPlot_ax(ax, fm_axis_1, L_fm_dBcHz_1);
        stc = MyPlot_ax(ax, fm_axis_2, L_fm_dBcHz_2);
        stc.plot.plot_1.Color = colors{4};
        stc.label.y.String = 'SSB Phase Noise $L(f_m)$ (dBc/Hz)';
        stc.label.x.String = 'Offset Frequency $f_m$ (Hz)';
        stc.label.x.FontSize = 14;
        stc.label.y.FontSize = 14;
        stc.leg.Visible = 'on';
        stc.leg.String = [
        "Zero-Crossing Method"
        "Power-Spectrum Method"
        ];
        stc.axes.XLim = [0, f0/2];
        stc.axes.XScale = 'linear';
        STC.plot_stc2 = stc;

        ax = nexttile;
        stc = MyPlot_ax(ax, fm_axis_1, L_fm_dBcHz_1);
        stc = MyPlot_ax(ax, fm_axis_2, L_fm_dBcHz_2);
        stc.plot.plot_1.Color = colors{4};
        stc.label.y.String = 'SSB Phase Noise $L(f_m)$ (dBc/Hz)';
        stc.label.x.String = 'Offset Frequency $f_m$ (Hz)';
        stc.label.x.FontSize = 14;
        stc.label.y.FontSize = 14;
        stc.leg.Visible = 'on';
        stc.leg.String = [
        "Zero-Crossing Method"
        "Power-Spectrum Method"
        ];
        stc.axes.XLim = [0, f0/2];
        stc.axes.XScale = 'log';
        STC.plot_stc3 = stc;

        MyFigure_ChangeSize([4, 3]*512*0.7)
    end
end

```