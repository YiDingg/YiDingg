# Phase Noise Spectrum Calculation using MATLAB

> [!Note|style:callout|label:Infor]
Initially published at 20:18 on 2025-09-05 in Lincang.


## 1. Introduction

在之前的 VCO/PLL 设计与仿真中 [1-2]，我们就曾参考 [3-4] 的 MATLAB 代码进行了 transient phase noise 的计算。但是当时我们对 phase noise and jitter 的理解还不够深入，很多理论知识还没有学习，因此不清楚整个处理过程背后的理论原理。

后来学习了相噪的理论知识 [5-6]，我们逐渐理清了这些概念。因此，本文将基于相噪相关理论，参考先前的 MATLAB 代码，给出 **正弦/方波信号相位噪声** 的理论计算方法及其 MATLAB 代码实现，真正实现对 phase noise 的准确计算。



## 2. Phase Noise for Sinusoid Wave



对于一个已知的，或者仿真/测量得到的非理想正弦信号 $V_{out}(t)$，我们可以用公式 $V_{eq}(t) = V_0 \cos \left[\omega_0 t + \phi_n(t)\right]$ 对其进行建模。


要计算 phase noise spectrum $S_{\phi_n}(\omega)$，首先需要得到 $\phi_n(t)$，受资料 [3] 的启发，我们可以用周期序列 $T(n)$ 来计算 $\phi(t)$。我们大致思路是：设置合理的 crossing threshold, 将时域信号 $V_{out}(t)$ 转化为周期序列 $T(n)$，也就相当于得到了频率序列 $f(n)$，由此积分得到 total phase $\phi(t) = \omega_0 t + \phi_n(t)$，再减去理想相位 $\omega_0 t$ 即得 $\phi_n(t)$。

举个例子，对于一个幅度为 ±1V 的正弦信号，可以设置 crossing threshold 为 0V, 然后在 cadence 中通过函数 `period` 来计算周期序列，或者通过 `freq` 函数得到频率序列。下面直接给出计算 $\phi_n(t)$ 的 MATLAB 代码：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-05-19-05-37_Phase Noise Spectrum Calculation using MATLAB.png"/></div>

``` matlab
%% Calculation of jitter and phase noise spectrum using periods of the signal


% 1. 导入频率序列并计算周期序列
clear, clc, close all
data = readmatrix("D:\a_Win_VM_shared\202508_CPPLL_best_pass_1k_50p_1G-1500periods_tran__vout_freq.csv"); nfft=2^16;
time = data(:, 1);
freq = data(:, 2);
periods = 1./freq;
N = length(periods);


% 2. 通过周期序列计算 T_0 (nominal period), Jc (cycle jitter) 和 Jcc (cycle-to-cycle jitter)
T_0 = mean(periods);
f_0 = 1/T_0;
omega_0 = 2*pi*f_0;
delta_T_relative_max = max(abs(periods-T_0)/T_0)*100; % unit: %
delta_f_relative_max = max(abs(freq-f_0)/f_0)*100; % unit: %

Jc = periods - T_0;
Jc_rms = std(Jc);
Jcc = Jc(2:end) - Jc(1:(end - 1));
Jcc_rms = std(Jcc);

disp(['number of periods = ', num2str(N)])
disp(['T_0 = ', num2str(T_0*10^9, '%.4f'), ' ns, f_0 = ', num2str(f_0/10^9, '%.4f'), ' GHz'])
disp(['max abs relative delta T = ', num2str(delta_T_relative_max, '%.4f'), ' %'])
disp(['max abs relative delta f = ', num2str(delta_f_relative_max, '%.4f'), ' %'])
disp(['Jc_rms = ', num2str(Jc_rms*10^12, '%.4f'), ' ps'])
disp(['Jcc_rms = ', num2str(Jcc_rms*10^12, '%.4f'), ' ps'])
disp(['Jc_rms*sqrt(2) = ', num2str(Jc_rms*sqrt(2)*10^12), ' ps'])


% 3. 积分后分离出 phi_n (phase noise)
phases = 2*pi*cumsum(periods/T_0); % 积分得到 phase noise (unit: rad) 
periods_ideal = zeros(N, 1) + T_0;
phi_n = phases - 2*pi*cumsum(periods_ideal/T_0); % unit: rad

stc = MyPlot(time*10^6, phi_n);
xlim([0 100])
stc.label.x.String = ['Time $t$ (us)'];
stc.label.y.String = 'Phase Noise $\phi_n(t)$ (rad)';
MyFigure_ChangeSize([1.8, 1]*512*1.3)
```


有了 $\phi_n(t)$ 之后就简单多了，要么直接对 $\phi_n(t)$ 作 FFT (fast Fourier transformation) 然后平方得到功率谱 $S_{\phi_n}(\omega)$，要么利用 MATLAB 中的函数 `pwelch` 进行 **Welch’s power spectral density estimate**。

由于各种参数设置不同，两者的结果会有一定差异，但基本上是一致的，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-05-19-20-50_Phase Noise Spectrum Calculation using MATLAB.png"/></div>

下面给出了上图的 MATLAB 代码。**<span style='color:red'> 但是需要注意：下列代码虽然是参考 [3] 来写的，几乎没有什么改动，但是得到的结果却和 "正确值" 对不上。</span>** 具体而言，下面代码得到的功率谱，其总功率远远大于实际总功率 $\overline{\phi_n^2(t)} = \frac{1}{T}\int \phi_n^2 \ \mathrm{d}t$（但功率谱形状是相似的）。背后的具体原因，还有待进一步探索。

``` matlab

% 4. 通过函数 pwelch 内置的 DFT (FFT) 功能计算相位噪声功率谱 S_phi_n
nfft_array = 2.^log10(logspace(1, 20, 20));
nfft_array = nfft_array(nfft_array < length(periods));
nfft = nfft_array(end);  % nfft (number of FFT points) should be the power of two
overlap = 100;
winLength = nfft;
fs = 1/T_0;  % sampling frequency of the periods sequence
[S_phi_n, f] = pwelch(phi_n, winLength, overlap, nfft, fs, 'power');
S = S_phi_n;
S_dB = 10*log10(S_phi_n);
S_dB_filted = MyFilter_mean(S_dB, 50);
S_filted = 10.^(S_dB_filted/10);

K = length(S_phi_n);
stc = MyPlot(f', [S_dB'; S_dB_filted']);
stc.axes.XScale = 'log';
xlim([10^4 10^9])
ylim([-140 0])
stc.axes.Title.String = 'Power Spectral Density (PSD) of the Phase Noise';
stc.label.x.String = 'Frequency $f$ (Hz)';
stc.label.y.String = 'Phase Noise Power Density $S_{\phi_n}$ (dB/Hz)';
stc.leg.String = ["Raw data"; "Filted data"];
MyFigure_ChangeSize([2, 1]*512)


% 第四步直接用 FFT 方法

stc = MyAnalysis_Spectrum(phi_n', time', [0 time(end)], 0);
stc.power = stc.P1.^2;
stc.power_dB = 10*log10(stc.power);
stc.power_dB_filted = MyFilter_mean(stc.power_dB, 50);
stc = MyPlot(stc.f, [stc.power_dB; stc.power_dB_filted]);
stc.axes.XScale = 'log';
xlim([10^4 10^9])
stc.axes.YLim = [-140 0];
MyFigure_ChangeSize([2, 1]*512)
stc.axes.Title.String = 'Power Spectral Density (PSD) of the Phase Noise';
stc.label.x.String = 'Frequency $f$ (Hz)';
stc.label.y.String = 'Phase Noise Power Density $S_{\phi_n}$ (dB/Hz)';
stc.leg.String = ["Raw data"; "Filted data"];
```

那么，我们该正确地如何计算相噪功率谱呢？查阅资料 [here](https://ww2.mathworks.cn/help/signal/ug/measure-the-power-of-a-signal.html) 知道， MATLAB 中其实早已有内置函数 `obw` 或 `periodogram` 可以做到这一点。例如 `obw(phi_n, fs);` 的效果为：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-05-20-15-31_Phase Noise Spectrum Calculation using MATLAB.png"/></div>

由于 `powerbw` 默认使用 `periodogram` 方法，我们基于 `periodogram` 函数重新编写 MATLAB 代码，效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-05-20-39-49_Phase Noise Spectrum Calculation using MATLAB.png"/></div>


可以看到，与之前的 "错误" 做法相比，现在这种方法的频谱曲线几乎不变，只是整体向下平移了一些。

``` matlab
% 8. (实际采用) 用函数 periodogram 计算功率谱、功率和抖动
% powerbw 默认使用 periodogram 方法
[S_phi_n, f] = periodogram(phi_n, [], [], fs);
% 横坐标 (频率): f
% 纵坐标 (功率谱密度): S_phi_n
S = S_phi_n';
S_dB = 10*log10(S);
S_dB_filted = MyFilter_mean(S_dB, 50);
S_filted = 10.^(S_dB_filted/10);

[bw, ~, ~, power] = obw(phi_n, fs);
ave_power = power;
RMS_Sphin_rad = sqrt(ave_power);
RMS_Jc = RMS_Sphin_rad/(2*pi*f_0);
disp(['RMS_phi = ', num2str(RMS_Sphin_rad), ' rad'])
disp(['RMS_Jc = ', num2str(RMS_Jc*10^12), ' ps'])

stc = MyPlot(f', [S_dB; S_dB_filted]);
stc.axes.XScale = 'log';
xlim([10^4 10^9])
stc.axes.YLim = [-180 0];
MyFigure_ChangeSize([2, 1]*512)
stc.axes.Title.String = 'Power Spectral Density (PSD) of the Phase Noise';
%stc.axes.Subtitle.FontSize = 10;
%stc.axes.Subtitle.String = ['RMS_Jc = ', num2str(RMS_Jc*10^12), ' ps'];
stc.label.x.String = 'Frequency $f$ (Hz)';
stc.label.y.String = 'Phase Noise Power Density $S_{\phi_n}$ (dB/Hz)';
%xline(bw)
%stc.leg.String = ["Raw data"; "Filted data"; "99\% noise = " + num2str(bw/10^6, '%.1f') + " MHz"];
stc.leg.String = ["Raw data"; "Filted data"];

x_limits = xlim; % 获取横坐标范围
y_limits = ylim; % 获取纵坐标范围

% 计算一个合适的位置（例如，位于X轴起点偏右5%，Y轴起点偏上5%的位置）
x_pos = 20e3;
y_pos = -60;

% 在计算好的位置添加文本
text(x_pos, y_pos, [ ...
    "Average power = " + num2str(power, '%.6f') + " rad^2"
    "RMS phase noise = " + num2str(RMS_Sphin_rad, '%.3f') + " rad"
    "RMS phase jitter = " + num2str(RMS_Jc*10^12, '%.3f') + " ps"
    "Bandwidth for 99% noise = " + num2str(bw/10^6) + " MHz" ...
    ], ...
    'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
    'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
    'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
    'EdgeColor', 'k', ...               % 设置黑色边框（可选）
    'Margin', 2, ...                    % 设置文本与边框的边距（可选）
    'FontSize', 10 ...
    );                    % 设置字体大小
```


## 3. Phase Noise for Square Wave

方波的处理方法也是完全相同的：正常设定 crossing threshold 并得到 frequency/period 序列后运行代码即可。这是因为方波的基频和更高次的奇谐波都在 sampling frequency $f_s$ = nominal frequency $f_0$ 以外，而我们整个分析过程的所关注频谱范围是 $[0,\ f_s/2]$，因此不会产生额外影响。


## 4. MATLAB Codes

综上所述，正确的完整 MATLAB 代码如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-05-21-05-38_Phase Noise Spectrum Calculation using MATLAB.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-05-21-05-50_Phase Noise Spectrum Calculation using MATLAB.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-05-21-09-01_Phase Noise Spectrum Calculation using MATLAB.png"/></div>

``` matlab
(完整代码) %% Calculation of jitter and phase noise spectrum using periods of the signal


% 1. 导入频率序列并计算周期序列
    clear, clc, close all
    data = readmatrix("D:\a_Win_VM_shared\202508_CPPLL_best_pass_1k_50p_1G-1500periods_tran__vout_freq.csv"); nfft=2^16;
    time = data(:, 1);
    freq = data(:, 2);
    periods = 1./freq;
    N = length(periods);


% 2. 通过周期序列计算 T_0 (nominal period), Jc (cycle jitter) 和 Jcc (cycle-to-cycle jitter)
    T_0 = mean(periods);
    f_0 = 1/T_0;
    omega_0 = 2*pi*f_0;
    delta_T_relative_max = max(abs(periods-T_0)/T_0)*100; % unit: %
    delta_f_relative_max = max(abs(freq-f_0)/f_0)*100; % unit: %
    
    Jc = periods - T_0;
    Jc_rms = std(Jc);
    Jcc = Jc(2:end) - Jc(1:(end - 1));
    Jcc_rms = std(Jcc);
    
    disp(['number of periods = ', num2str(N)])
    disp(['T_0 = ', num2str(T_0*10^9, '%.4f'), ' ns, f_0 = ', num2str(f_0/10^9, '%.4f'), ' GHz'])
    disp(['max abs relative delta T = ', num2str(delta_T_relative_max, '%.4f'), ' %'])
    disp(['max abs relative delta f = ', num2str(delta_f_relative_max, '%.4f'), ' %'])
    disp(['Jc_rms = ', num2str(Jc_rms*10^12, '%.4f'), ' ps'])
    disp(['Jcc_rms = ', num2str(Jcc_rms*10^12, '%.4f'), ' ps'])
    disp(['Jc_rms*sqrt(2) = ', num2str(Jc_rms*sqrt(2)*10^12), ' ps'])

    % 作出 periods 图像：
    stc = MyPlot(time*10^6, periods*10^9);
    ylim([0.98, 1.02])
    xlim([0 100])
    stc.label.x.String = 'Time $t$ (us)';
    stc.label.y.String = 'Period $T(t)$ (ns)';
    MyFigure_ChangeSize([3, 1]*512*1.3)
    % 在计算好的位置添加文本
    text(5, 0.981, [ ...
        "Number of periods = " + num2str(N)
        "Nominal period $T_0$ = " + num2str(T_0*10^9, '%.4f') + " ns"
        "Nominal frequency $f_0$ = " + num2str(f_0/10^9, '%.4f') + " GHz"
        "RMS cycle jitter $J_{c,rms}$ = " + num2str(Jc_rms*10^12, '%.4f') + " ps"
        "RMS cycle jitter $J_{cc,rms}$ = " + num2str(Jcc_rms*10^12, '%.4f') + " ps"
        ], ...
        'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
        'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
        'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
        'EdgeColor', 'k', ...               % 设置黑色边框（可选）
        'Margin', 2, ...                    % 设置文本与边框的边距（可选）
        'FontSize', 13, ...
        'Interpreter', 'latex' ...
        );                    % 设置字体大小

% 3. 积分后分离出 phi_n (phase noise)
    phases = 2*pi*cumsum(periods/T_0); % 积分得到 phase noise (unit: rad) 
    periods_ideal = zeros(N, 1) + T_0;
    phi_n = phases - 2*pi*cumsum(periods_ideal/T_0); % unit: rad
    
    % 计算 phi_n 的功率
    fs = f_0;
    [bw, ~, ~, power] = obw(phi_n, fs);
    ave_power = power;
    RMS_Sphin_rad = sqrt(ave_power);
    RMS_Jc = RMS_Sphin_rad/(2*pi*f_0);
    disp(['RMS_phi = ', num2str(RMS_Sphin_rad), ' rad'])
    disp(['RMS_Jc = ', num2str(RMS_Jc*10^12), ' ps'])

    stc = MyPlot(time*10^6, phi_n);
    xlim([0 100])
    ylim([-0.5 0.5])
    stc.label.x.String = 'Time $t$ (us)';
    stc.label.y.String = 'Phase Noise $\phi_n(t)$ (rad)';
    MyFigure_ChangeSize([3, 1]*512*1.3)
    
    % 在计算好的位置添加文本
    text(5, -0.48, [ ...
        "Average power $\overline{\phi_n(t)^2}$ = " + num2str(power, '%.6f') + " rad$^2$"
        "RMS phase noise $J_{\phi_n, rms}$ = " + num2str(RMS_Sphin_rad, '%.4f') + " rad"
        "RMS phase jitter $J_{t, rms}$ = " + num2str(RMS_Jc*10^12, '%.4f') + " ps"
        "RMS cycle jitter $J_{c, rms}$ = " + num2str(Jc_rms*10^12, '%.4f') + " ps"
        "RMS cycle-to-cycle jitter $J_{cc, rms}$ = " + num2str(Jcc_rms*10^12, '%.4f') + " ps"
        "Bandwidth for 99\% noise $\mathrm{BW}_{99\%}$ = " + num2str(bw/10^6, '%.4f') + " MHz"
        ], ...
        'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
        'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
        'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
        'EdgeColor', 'k', ...               % 设置黑色边框（可选）
        'Margin', 2, ...                    % 设置文本与边框的边距（可选）
        'FontSize', 13, ...
        'Interpreter', 'latex' ...
        );                    % 设置字体大小

% 4. (实际采用) 用函数 periodogram 计算功率谱、功率和抖动
    % powerbw 默认使用 periodogram 方法
    fs = f_0;
    [S_phi_n, f] = periodogram(phi_n, [], [], fs);
    % 横坐标 (频率): f
    % 纵坐标 (功率谱密度): S_phi_n
    S = S_phi_n';
    S_dB = 10*log10(S);
    S_dB_filted = MyFilter_mean(S_dB, 50);
    S_filted = 10.^(S_dB_filted/10);
    
    stc = MyPlot(f', [S_dB; S_dB_filted]);
    stc.axes.XScale = 'log';
    xlim([10^4 10^9])
    stc.axes.YLim = [-180 0];
    MyFigure_ChangeSize([3, 1]*512*1.3)
    stc.axes.Title.String = 'Power Spectral Density (PSD) of the Phase Noise';
    %stc.axes.Subtitle.FontSize = 10;
    %stc.axes.Subtitle.String = ['RMS_Jc = ', num2str(RMS_Jc*10^12), ' ps'];
    stc.label.x.String = 'Frequency $f$ (Hz)';
    stc.label.y.String = 'Phase Noise Power Density $S_{\phi_n}$ (dB/Hz)';
    %xline(bw)
    %stc.leg.String = ["Raw data"; "Filted data"; "99\% noise = " + num2str(bw/10^6, '%.1f') + " MHz"];
    stc.leg.String = ["Raw data"; "Filted data"];
    
    x_limits = xlim; % 获取横坐标范围
    y_limits = ylim; % 获取纵坐标范围
    
    % 在计算好的位置添加文本
    text(20e3, -70, [ ...
        "Average power $\overline{\phi_n(t)^2}$ = " + num2str(power, '%.6f') + " rad$^2$"
        "RMS phase noise $J_{\phi_n, rms}$ = " + num2str(RMS_Sphin_rad, '%.4f') + " rad"
        "RMS phase jitter $J_{t, rms}$ = " + num2str(RMS_Jc*10^12, '%.4f') + " ps"
        "RMS cycle jitter $J_{c, rms}$ = " + num2str(Jc_rms*10^12, '%.4f') + " ps"
        "RMS cycle-to-cycle jitter $J_{cc, rms}$ = " + num2str(Jcc_rms*10^12, '%.4f') + " ps"
        "Bandwidth for 99\% noise $\mathrm{BW}_{99\%}$ = " + num2str(bw/10^6, '%.4f') + " MHz"
        ], ...
        'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
        'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
        'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
        'EdgeColor', 'k', ...               % 设置黑色边框（可选）
        'Margin', 2, ...                    % 设置文本与边框的边距（可选）
        'FontSize', 13, ...
        'Interpreter', 'latex' ...
        );                    % 设置字体大小
   
```


## References

- \[1\] [Design of A Third-Order Type-II Integer-N CP-PLL](<Projects/Design of A Third-Order Type-II Integer-N CP-PLL.md>)
- \[2\] [Virtuoso Tutorials - 13. VCO and PLL Simulation (Periodical Steady-State and Phase Noise)](<AnalogIC/Virtuoso Tutorials - 13. VCO and PLL Simulation (Periodical Steady-State and Phase Noise).md>)
- \[3\] [Cadence_PLL_Jitter_measurment_in_Spectre.pdf](https://www.writebug.com/static/uploads/2025/8/22/705f40616dd3afd7796ddfbe1d5b66d8.pdf)
- \[4\] [Jitter measurement using SpectreRF Application Note.pdf](https://www.writebug.com/static/uploads/2025/8/22/28c1f61cd30eb054e8a9d5c6824f4d7e.pdf)
- \[5\] [Razavi PLL - Chapter 2. Jitter and Phase Noise](<AnalogIC/Razavi PLL - Chapter 2. Jitter and Phase Noise.md>)
- \[6\] [Jitter and Phase Noise in Mixed-Signal Circuits](<AnalogIC/Phase Noise and Jitter in Mixed-Signal Circuits.md>)
