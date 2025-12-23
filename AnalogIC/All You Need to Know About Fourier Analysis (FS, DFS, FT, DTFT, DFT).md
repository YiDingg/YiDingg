# All You Need to Know About Fourier Analysis (FS, DFS, FT, DTFT, DFT).md

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 23:21 on 2025-11-27 in Beijing.

## Introduction

起因是在最近的 “非线性电路实验” 中，需要从频谱图中计算出某一频率分量的幅值。当目标信号和频谱分辨率恰好匹配时，幅度计算是 trivial 的，只需直接在频谱图上读取该频率点的幅值即可。然而，当目标信号的频率并不与频谱分辨率对齐时，由于频谱泄漏效应，单纯读取目标频率附近单个点的幅值将无法准确反映目标信号的实际幅值。

查阅资料后，发现除 “简单峰值法” (直接读取目标频率附近单个点) 外，常用的功率/幅度计算方法还有很多种：
- 无窗函数直接功率积分
- 加窗函数对功率积分后除以窗函数噪声带宽 (noise power bandwidth)
- auto-correlation [{2}](https://mathematica.stackexchange.com/questions/42783/how-do-you-find-the-frequency-and-amplitude-from-fourier/43006#43006)
- Prony series (普朗尼级数) [{3}](https://mathematica.stackexchange.com/questions/42783/how-do-you-find-the-frequency-and-amplitude-from-fourier/94713#94713)
- looking for periodicities [{4}](https://mathematica.stackexchange.com/questions/42783/how-do-you-find-the-frequency-and-amplitude-from-fourier/43001#43001)
- Fourier series 


本文，我们对其中几种方法进行详细分析，并给出 MATLAB 代码实现。

## 1. FS/DFS and FT/DTFT/DFT

在讨论频谱分析方法之前，先简要回顾一下傅里叶分析的几种常见变换：
- FS: Fourier Series (傅里叶级数)
- DFS: Discrete Fourier Series (离散傅里叶级数)
- FT: Fourier Transform (傅里叶变换)
- DTFT: Discrete Time Fourier Transform (离散时间傅里叶变换)
- DFT: Discrete Fourier Transform (离散傅里叶变换)

它们之间的区别如下表所示：

<span style='font-size:10px'> 
<div class='center'>

 | Transform | FS | DFS | FT | DTFT | DFT |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | 操作对象 <br> (时域特性) | 连续时间 + 周期 | 离散时间 + 周期 | 连续时间 + 非周期 <br> (可理解为周期无限长) | 离散时间 + 非周期 <br> (采样点数无限) | 离散时间 + “非周期” <br> (事实上，受采样点数 $N$ 限制，<br> 运算过程中隐含了周期为 N 的假设) |
 | 时域简记 | $t,\ T$ | $n,\ N$ | $t,\ T = \infty$ | $n,\ N = \infty$ | $n,\ N$ |
 | 所得结果 <br> (频域特性) | 离散频率 + 非周期 | 离散频率 + 周期 | 连续频率 + 非周期 | 连续频率 + 非周期 | 离散频率 + 周期 $N$ |
 | 频域简记 | $m\omega_0 = m \frac{2\pi}{T}$ | $m\Omega_0 = m \frac{2\pi}{N}$ | $\omega$ | $\Omega$ | $m\Omega_0 = m \frac{2\pi}{N}$ |
 | 定义 | $$\tilde{X}[m]  = \frac{1}{T} \int_{0}^{T} \tilde{x}(t) e^{-j m \omega_0 t} \ \mathrm{d}t $$ | $$\tilde{X}[m] = \frac{1}{N} \sum_{n=0}^{N-1} \tilde{x}[n] e^{-j m \Omega_0 n} $$ | $$X(j\omega) = \int_{-\infty}^{+\infty} x(t) e^{-j \omega t} \ \mathrm{d}t $$ | $$X(e^{j\Omega}) = \sum_{n=-\infty}^{+\infty} x[n] e^{-j \Omega n} $$ | $$X[m] = \sum_{n=0}^{N-1} x[n] e^{-j m \Omega_0 n} $$ |
 | 定义域 | $m = 0, \pm 1, \pm 2, ...$ | $\Omega_m = \frac{2\pi}{N}m$ <br> $m = 0, 1, 2, ..., N-1$ | $\omega \in (-\infty, +\infty)$ |  $\Omega \in (0, 2\pi)$ <br> or $\Omega \in (-\pi, \pi)$ | $\Omega_m = \frac{2\pi}{N}m$ <br> $m = 0, 1, 2, ..., N-1$ |

</div>
</span>

像我们常说的，对采样所得序列 $v[n]$ 作“傅里叶变换”，实际上是指对 $v[n]$ 作离散傅里叶变换 (DFT)，得到频率离散且周期为 $N$ 的频谱 $V[m]$。并且，由于 DFT 实际上隐含了周期为 $N$ 的假设 (从无限长周期性序列中截取单个周期，也就是 $N$ 个点进行分析)，因此 DFT 本质上就是 DFS (离散傅里叶级数)。换句话说，DFT 是 DFS 在实际限制条件下的实现。

这也解释了为什么 DFT 结果具有周期 N，这是因为暗含 “采样序列周期为 N，仅取其中一个周期作 DFS” 的条件。

## 2. More on FS/DFS

上面给出的 FS 定义是指数级数形式，国内教材在这一部分更多介绍的是实信号的三角形式：

$$
\begin{gather}
x(t) = \frac{a_0 + b_0}{2} + \sum_{k=1}^{\infty} \left[ a_k \cos(k \omega_0 t) + b_k \sin(k \omega_0 t) \right] \\
a_k = \frac{2}{T} \int_{0}^{T} x(t) \cos(k \omega_0 t) \ \mathrm{d}t,\quad k = 0, 1, 2, ... \\
b_k = \frac{2}{T} \int_{0}^{T} x(t) \sin(k \omega_0 t) \ \mathrm{d}t,\quad k = 0, 1, 2, ... \\
\omega_0 = \frac{2\pi}{T},\quad A_k = \sqrt{a_k^2 + b_k^2},\quad \phi_k = \angle \left( a_k - j b_k \right) 
\end{gather}
$$

为了统一格式，上面引入了一个恒为零的系数 $b_0$，使得直流分量可以写成 $(a_0 + b_0)/2$ 的形式。实际上，$b_0$ 恒为零，因为 $k = 0$ 时，$\int_{0}^{T} x(t) \sin(0) \ \mathrm{d}t = 0$。


由 $\exp(j k \omega_0 t) = \cos(k \omega_0 t) + j \sin(k \omega_0 t)$ 很容易将指数形式和三角形式联系起来。具体而言，指数系数 $\tilde{X}[k]$ 与三角系数 $a_k, b_k$ 之间的关系为：

$$
\begin{gather}
\begin{cases}
\tilde{X}[k] = \frac{a_{k} - j b_{k}}{2},\quad k = 0, 1, 2, ... \\
\tilde{X}[k] = \frac{a_{k} + j b_{k}}{2},\quad k = -1, -2, ...
\end{cases}
\end{gather}
$$

上面正负号有区别，是因为 $x(t)$ or $x[n]$ 为实信号时，其 FS or DFS 系数满足共轭对称性：$\tilde{X}[-k] = \tilde{X}^*[k]$，也就是“实数部分偶对称 + 虚数部分奇对称”。

DFS 指数形式的正逆变换为：

$$
\begin{gather}
\tilde{X}[k] = \frac{1}{N} \sum_{n=0}^{N-1} \tilde{x}[n] e^{-j k \Omega_0 n},\quad 
\tilde{x}[n] = \sum_{k=0}^{N-1} \tilde{X}[k] e^{j k \Omega_0 n} \\
\end{gather}
$$

参照 FS 的两种形式，我们也可以类似地写出 DFS 的三角形式：

$$
\begin{gather}
\tilde{x}[n] = \frac{a_0 + b_0}{2} + \sum_{k=1}^{N_{mid}} \left[ a_k \cos(k \Omega_0 n) + b_k \sin(k \Omega_0 n) \right],\quad N_{mid} = \left \lfloor \frac{N}{2} \right \rfloor
\\
a_k = \frac{2}{N} \sum_{n=0}^{N-1} \tilde{x}[n] \cos(k \Omega_0 n),\quad k = 0, 1, 2, ..., \left \lfloor \frac{N}{2} \right \rfloor \\
b_k = \frac{2}{N} \sum_{n=0}^{N-1} \tilde{x}[n] \sin(k \Omega_0 n),\quad k = 0, 1, 2, ..., \left \lfloor \frac{N}{2} \right \rfloor \\
\tilde{X}[k] = 
\begin{cases}
\frac{a_k - j b_k}{2}, & k = 0, 1, 2, ..., \left \lfloor \frac{N}{2} \right \rfloor \\
\frac{a_{N-k} + j b_{N-k}}{2}, & k = \left \lfloor \frac{N}{2} \right \rfloor + 1, ..., N-1
\end{cases}
\end{gather}
$$


## 3. Spectrum vs. Spectral Density

在使用频谱进行幅度/功率估计时，务必确认所使用的频谱类型是 Power Spectrum 还是 Power Spectral Density (PSD)。例如，对电压信号而言，前者的单位是 Vrms^2，而后者的单位则为 Vrms^2/Hz。Power Spectrum 是采样序列进行 DFT 后直接得到的结果，而 Power Spectral Density (PSD) 则属于连续频谱中的概念，两者满足：

$$
\begin{gather}
\mathrm{PSD\ (V_{rms}^2/Hz)} = \frac{\mathrm{Power\ Spectrum\ (V_{rms}^2)}}{ \Delta f \ \mathrm{(Hz)}\times  \mathrm{B_{en}}\ (1) } \\
\end{gather}
$$

其中 $B_{en}$ 指 NENBW (normalized equivalent noise bandwidth)，即窗函数的归一化等效噪声带宽。

(上面公式有待验证)

又或者写作：

$$
\begin{gather}
\mathrm{PSD\ (V_{rms}^2/Hz)} = \frac{\mathrm{Corrected\ Power\ Spectrum\ (V_{rms}^2)}}{ \Delta f \ \mathrm{(Hz)}} \\
\end{gather}
$$



## 4. DFT using MATLAB

根据 DFT (本质上还是 DFS) 的定义，我们在 MATLAB 中编写代码，这里直接给出源码和最终效果：

``` matlab
clc, clear
f = 1e3;
T = 1/f;
omega = 2*pi*f;
Je_rms_mUI = 5;
% 带有 AM/PM noise + guass voltage noise + 杂七杂八噪声的信号
v_t = @(t) (1 + rand/10)*cos(omega * (t + randn*(Je_rms_mUI/1e3*T)) ) ...
    + (0.1 + rand/10)*cos(2*omega * (t + randn*(Je_rms_mUI/1e3*T)) ) ...
    +  rand/10*cos(rand(size(t)) .* 10*omega .* (t + randn*(Je_rms_mUI/1e3*T)) ) + rand/10;  

% 对信号进行采样
Je_rms_mUI = 10;
fs = f*(pi*10);
%fs = f*(32);
N = 2048*4;
t_n = 0:1/fs:(N-1)/fs;
v_n = v_t(t_n)

time_array = 0:0.1/fs:(N-1)/fs;
MyPlot(time_array(1:3000), v_t(time_array(1:3000)));

% 不加窗直接作 DFT (window = none, namely uniform)
stc1 = MyAnalysis_Spectrum_v1_20251124(v_n, fs, 1, 10);
stc1.plot4.axes.YLim = [-100 0];
```


``` matlab
function stc = MyAnalysis_Spectrum_v1_20251124(voltage, fs, plot_fig, detail_divide)


if nargin <= 3
    flag_timeRange = 0;
else
    flag_timeRange = 1;
end

    STC = MyAnalysis_DiscreteFourierTransform(voltage, fs);
    stc.STC = STC;

    N = STC.N;
    f = STC.fAxis_oneSided;
    P1 = STC.y_oneSided;
    P1_dB = 10*log10(P1);

if plot_fig ~= 0  % 正常作图
    
    % 绘图准备
    stc.fig = figure('Color', [1 1 1]);
    stc.layout = tiledlayout(2, 2, 'Parent', stc.fig);
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';


    i = 1;
    % 绘制信号时域图像
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, i);
    stc.(['ax',num2str(i)]).Title.String = 'Signal Waveform';
    %stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), (0:(N-1))/fs, voltage);
    %warning('Large sampling points detected (N > 10000), only the first 8192 points are ploted.')
    
    N_max = 1024*4;
    if N > N_max
        % warning(['Large sampling points detected, all points are used for spectrum calculation but only the first ', num2str(N_max), ' points are ploted.'])
        time = STC.t_nX10(1:10*(N_max));
        N_plot = N_max;
    else
        time = STC.t_nX10;
        N_plot = N;
    end

    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), time, STC.volt_recovered_func(time));
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), (0:(N-1))/fs, voltage(1:N));
    stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'r';
    stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = 150;
    stc.(['scatter',num2str(i)]).axes.XLim(1) = 0;
    %stc.plot0.axes.XScale = 'log';
    stc.(['plot',num2str(i)]).leg.Visible = 'on';
    stc.(['plot',num2str(i)]).leg.String = [
        "Recovered Signal"
        "Sampling Points"
    ];
    stc.(['plot',num2str(i)]).leg.Location = 'northeast';
    stc.(['plot',num2str(i)]).label.x.String = 'Time (s)';
    stc.(['plot',num2str(i)]).label.y.String = 'Voltage (V)';

   
    % 找到幅度最大的三个频率
    [~, index] = sort(P1, 'descend'); % P1 降序排序
    index = index(1:3);
    markersize = 400;


    % 绘制时域波形细节 or 单边 frequency spectrum in dB10 (对数横坐标)
    
    if flag_timeRange

        N_plot_detail = N_plot/detail_divide;
        time_detail = STC.t_nX10(1:min(10*N_plot_detail, length(STC.t_nX10)));

        i = i+1;
        stc.(['ax',num2str(i)]) = nexttile(stc.layout, i);
        stc.(['ax',num2str(i)]).Title.String = 'Signal Waveform Details';
        %stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), (0:(N-1))/fs, voltage);
        stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), time_detail, STC.volt_recovered_func(time_detail));
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), (0:(N_plot_detail-1))/fs, voltage(1:N_plot_detail));
        stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'r';
        stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = 150;
        stc.(['scatter',num2str(i)]).axes.XLim(1) = 0;
        stc.(['plot',num2str(i)]).leg.Visible = 'on';
        stc.(['plot',num2str(i)]).leg.String = [
            "Recovered Signal"
            "Sampling Points"
        ];
        stc.(['plot',num2str(i)]).leg.Location = 'northeast';
        stc.(['plot',num2str(i)]).label.x.String = 'Time (s)';
        stc.(['plot',num2str(i)]).label.y.String = 'Voltage (V)';
        %xlim(plot_timeRange)

    else
        i = i+1;
        % 绘制单边 frequency spectrum in V (对数横坐标)
        stc.(['ax',num2str(i)]) = nexttile(stc.layout, i);
        stc.(['ax',num2str(i)]).Title.String = 'Frequency Spectrum';
        stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), f, P1_dB);
        stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), f(index), P1_dB(index));
        stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'red';
        stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = markersize;
        stc.(['plot',num2str(i)]).leg.Visible = 'off';
        stc.(['plot',num2str(i)]).label.x.String = 'Frequency (Hz)';
        stc.(['plot',num2str(i)]).label.y.String = 'Amplitude $\mathrm{dB_{10}V}$';
        stc.(['plot',num2str(i)]).axes.XScale = 'log';
    end
    
   
    i = i+1;   
    % 绘制单边 frequency spectrum in V (linear x-axis scale)
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, i);
    stc.(['ax',num2str(i)]).Title.String = 'Frequency Spectrum';
    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), f, P1);
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), f(index), P1(index));
    stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = markersize;
    stc.(['plot',num2str(i)]).leg.Visible = 'off';
    stc.(['plot',num2str(i)]).label.x.String = 'Frequency (Hz)';
    stc.(['plot',num2str(i)]).label.y.String = 'Amplitude (V)';
    stc.(['scatter',num2str(i)]).axes.YLim(1) = 0;

    
    % 在合适的位置添加注释
    XLIM = stc.(['scatter',num2str(i)]).axes.XLim;
    YLIM = stc.(['scatter',num2str(i)]).axes.YLim;
    text(stc.(['ax',num2str(i)]), ...
        XLIM(2) - 0.5*(XLIM(2) - XLIM(1)), YLIM(2) - 0.3*(YLIM(2) - YLIM(1)), ...
        [ ...
            "Sampling Points $N$ = " + num2str(N) + " points";
            "Sampling Frequency $f_s$ = " + num2str(fs/1e6, '%.3f') + " MHz";
            "Frequency Resolution $f_r = \Delta f$ = " + num2str(STC.fr/1e6, '%.3f') + " MHz";
        ], ...
        'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
        'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
        'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
        'EdgeColor', 'k', ...               % 设置黑色边框（可选）
        'Margin', 2, ...                    % 设置文本与边框的边距（可选）
        'FontSize', 12, ...
        'Interpreter', 'latex' ...
    );
    


    i = i+1;
    % 绘制单边 power spectrum in dB(V^2) (对数横坐标)
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, i);
    stc.(['ax',num2str(i)]).Title.String = 'Power Spectrum';
    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), f, 10*log10(STC.power_oneSided)  );
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), f(index), 10*log10(STC.power_oneSided(index)));
    stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = markersize;
    stc.(['plot',num2str(i)]).axes.XScale = 'log';
    stc.(['plot',num2str(i)]).leg.Visible = 'off';
    stc.(['plot',num2str(i)]).label.x.String = 'Frequency (Hz)';
    stc.(['plot',num2str(i)]).label.y.String = 'Power $\mathrm{dB(V^2)}$';

    MyFigure_ChangeSize([2.2, 1]*512 .* [2, 2] * 0.8)
end

end


function stc = MyAnalysis_DiscreteFourierTransform(volt_n, fs)
    % 输入 N-points 的离散时间信号 volt[n] 以及采样频率 fs, 返回信号与 FT 相关的各种分析结果

%% 数据准备
    Ts = 1/fs;
    N = length(volt_n);
    if mod(N, 2) == 1   % 检查 N 的奇偶情况
          warning('Odd sampling number detected, one zero point was added.')
          % x_n = volt_n(1:(end-1));
          x_n = [volt_n, 0];
          N = length(x_n);
    else 
        x_n = volt_n;
    end
    if N > 10000    % 检查 N 的大小
        warning('Large sampling number detected (N > 10000), the FFT algorithm is used.')
        flag_largeN = 1;
    else
        flag_largeN = 0;
    end
    t_n = Ts*(0:(N-1));     % 采样时间 t[n]
    fr = fs/N;  % 频谱分辨率
    
    % 保存结果
    stc.volt_n = volt_n;
    stc.x_n = x_n;
    stc.t_n = t_n;
    stc.N = N;
    stc.fr = fr;
    stc.fs = fs;
    stc.Ts = Ts;
    


%% 计算 DFT
    % 对 x[n] 做 DFT 得到离散频谱 X[m], 横坐标范围 Omega = 2*pi*(m/N), m = 0, 1, 2, ..., N-1
    n = 0:(N-1); m = 0:(N-1);
    
    if flag_largeN
        X_m = fft(x_n');
    else
        tv1 = x_n + zeros(N, 1);         % 利用 1xN array + Nx1 array 来复制 x_n, 得到 NxN 矩阵 = [x_n; x_n; ...; x_n], 每一行都是一个 x_n
        tv2 = exp(-1j*2*pi/N * (m'*n) ); % m'*n 得到大小为 NxN 的矩阵，第一行对应 m = 0 (n = 0, 1, ..., N-1), 第一行对应 m = 1 (n = 0, 1, ..., N),
        X_m = sum(tv1.*tv2, 2);          % 计算 DFT 结果 X[m], sum([], 2) 是对每一行求和，结果是列 array, 注意 X[m] 中是复数序列
    end
    
    f_m = fs/N*m;           % 根据 fs 还原频率坐标
    y_m = 1/N * abs(X_m)';  % 根据 X_m 计算信号在不同频率处的幅度 (amplitude)，注意有一个系数 1/N
    phaseDeg_m = MyArcTheta_complex_deg(X_m)';
    power_m = y_m.^2/2; power_m(1) = 2*power_m(1);     % power 是 rms 值的平方, 注意 DC 处不应除以二 

    stc.X_m = X_m;
    stc.f_m = f_m;
    stc.y_m = y_m;
    stc.phaseDeg_m = phaseDeg_m;
    stc.power_m = power_m;

%% 计算 two-sided spectrum

%{
    原始结果 y_m 共 N points, m = 0, 1, ..., N-1, 其中 m = 0 为 DC, m = N 对应 fs
    two-sided 共 N + 1 points, m = 0, ±1, ..., ±N/2, 其中 m = 0 对应 DC, m = N/2 对应 fs/2
    从 y_m 计算 y_twoSided 时, 注意将 y_m 在 fs/2 (m = N/2) 处的值减半，分为 y_twoSided 中的 ±N/2 两点
    在 MATLAB 中，索引从 1 开始，于是 DC 和 fs/2 分别对应 index = 1 和 N/2+1, 于是索引 y_twoSide 被分为三组：
    index     = 1 ~ N/2, (N/2+1), (N/2+2) ~ (N+1)
    对应频率 f = -fs/2 ~ -fs/N, DC, +fs/N ~ +fs/2
    可以由实信号在频谱上的对称性简单求解 y_twoSide
%}
    y_twoSided = [y_m( (N/2+1):-1:2 ), y_m( 1 ), y_m( 2:1:(N/2+1) )];
    y_twoSided([1 end]) = y_twoSided([1 end])/2;  % 从 y_m 计算 y_twoSided 需要将 fs/2 处折半
    fAxis_twoSided = [-f_m( (N/2+1):-1:2 ), f_m( 1 ), f_m( 2:1:(N/2+1) )];
    phaseDeg_twoSided = [phaseDeg_m( (N/2+1):-1:2 ), phaseDeg_m( 1 ), phaseDeg_m( 2:1:(N/2+1) )];
    power_twoSided = y_twoSided.^2/2; power_twoSided(N/2+1) = 2*power_twoSided(N/2+1);  % power 是 rms 值的平方, 注意 DC 处不应除以二 

    stc.y_twoSided = y_twoSided;
    stc.fAxis_twoSided = fAxis_twoSided;
    stc.phaseDeg_twoSided = phaseDeg_twoSided;
    stc.power_twoSided = power_twoSided;


%% 计算 one-sided spectrum


%{
    one-sided 共 (N/2 + 1) points (默认 N 为偶数), m = 0, 1, ..., N/2, 其中 m = 0 对应 DC, m = N/2 对应 fs/2
    如果是从 y_twoSided 计算 y_oneSide, 注意 y_twoSided 中仅 DC (m = 0) 一个点的值 "不要" 翻倍
    如果是从 y_m 计算 y_oneSide, 注意 y_m 中的 DC (m = 0) 和 fs/2 (m = N/2) 两个点都 "不要" 翻倍
%}

    y_oneSided = y_twoSided( (N/2+1):end );
    y_oneSided(2:end) = 2*y_oneSided(2:end);    % 将除 DC 点之外的所有点翻倍
    fAxis_oneSided = fAxis_twoSided( (N/2+1):end );
    phaseDeg_oneSided = phaseDeg_twoSided( (N/2+1):end );
    power_oneSided = y_oneSided.^2/2; power_oneSided(1) = 2*power_oneSided(1);    % power 是 rms 值的平方, 注意 DC 处不应除以二 

    stc.y_oneSided = y_oneSided;
    stc.fAxis_oneSided = fAxis_oneSided;
    stc.phaseDeg_oneSided = phaseDeg_oneSided;
    stc.power_oneSided = power_oneSided;

%% 验证与恢复
    % 验证 x_n_recovered 与 x_n 是否相同
    if flag_largeN
        x_n_recovered = 0;
    else
        tv1 = X_m + zeros(N, 1); % 注意 X_m 为列向量，因此 tv1 第一行对应 m = 0, 第二行对应 m = 1
        tv2 = exp( 1j*2*pi/N * (n'*m) ) ;
        x_n_recovered = 1/N * sum(tv1.*tv2, 1);   % 注意这里求 x[n] 时是对 m 求和，前面求 X[m] 时是对 n 求和
        x_n_recovered = real(x_n_recovered);    % 用于验证 x_n_recovered 是否与原始 x_n 相同
    end
    
    % 从已知频谱中恢复出 "连续时间" 信号
    t_nX10 = 0:Ts/10:((N-1)*Ts);
    if flag_largeN
        volt_recovered_nX10 = zeros(size(t_nX10));
        % volt_recovered_func = @(t) t;
        warning('Large sampling number detected (N > 10000), the recovered continuous signal x(t) only contains the 5000 frequency points with the greatest amplitude.')
        [~, index_5000Max] = maxk(y_oneSided, 5000);
        y_oneSided_5000Max = y_oneSided(index_5000Max);
        fAxis_oneSided_5000Max = fAxis_oneSided(index_5000Max);
        phaseDeg_oneSided_5000Max = phaseDeg_oneSided(index_5000Max);
        % volt_recovered_func = @(t) sum( y_oneSided(index_5000Max)' .* cos(2*pi*fAxis_oneSided(index_5000Max)'.* t + deg2rad(phaseDeg_oneSided(index_5000Max)')) , 1);
        volt_recovered_func = @(t) sum( y_oneSided_5000Max' .* cos(2*pi*fAxis_oneSided_5000Max'.* t + deg2rad(phaseDeg_oneSided_5000Max')) , 1);
        stc.index_5000Max = index_5000Max;
    else 
        tv = y_oneSided' .* cos(2*pi*fAxis_oneSided'.*t_nX10 + deg2rad(phaseDeg_oneSided'));   % 所得 tv 是一个矩阵，第一行对应 f = 0, 第二行对应 f = fs/N, ... 
        volt_recovered_nX10 = sum(tv, 1);   % 对列求和，计算 t = t_0 时的所有频率分量之和
        volt_recovered_func = @(t) sum( y_oneSided' .* cos(2*pi*fAxis_oneSided'.* t + deg2rad(phaseDeg_oneSided')) , 1);
    end
    

    stc.x_n_recovered = x_n_recovered;
    stc.t_nX10 = t_nX10;
    stc.volt_recovered_nX10 = volt_recovered_nX10;
    stc.volt_recovered_func = volt_recovered_func;

end
```


## 5. Use of Windows

### 5.1 basics of windows

<div class='center'>

| Basics of windows |
|:-:|
 | 常见 window 的基本特性： <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-00-20-13_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-00-22-31_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> page.14-16 of [{5} The Fundamentals of FFT-Based Signal Analysis and Measurement](https://www.sjsu.edu/people/burford.furman/docs/me120/FFT_tutorial_NI.pdf) |
 | window 在时域和频域上的波形 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-23-35-41_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-23-38-25_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-23-39-05_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> page.3992 of [[2]](https://www.sciencedirect.com/org/science/article/pii/S152614922000168X) “Windowing Techniques, the Welch Method for Improvement of Power Spectrum Estimation,” Computers, Materials and Continua, vol. 67, no. 3, pp. 3983–4003, Jan. 2021, [doi: 10.32604/cmc.2021.014752.](https://www.sciencedirect.com/org/science/article/pii/S152614922000168X) |
 | 如何选择 window: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-00-21-07_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> page.15 of [{5} The Fundamentals of FFT-Based Signal Analysis and Measurement](https://www.sjsu.edu/people/burford.furman/docs/me120/FFT_tutorial_NI.pdf) |

</div>

下面对几种常见窗函数进行对比实验，观察它们在频谱分析中的表现差异。当频谱分辨率与信号频率恰好匹配，没有频谱泄露时，例如设置 $f_s = 32\times f_{0}$：

<div class='center'>

| Window | None (Uniform) | Hanning (without amplitude/power correction) | Flat Top (without amplitude/power correction) |
|:-:|:-:|:-:|:-:|
 | Waveform and Spectrum | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-00-17-51_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-00-17-55_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-00-17-59_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> |
 | Power Spectrum Comparison | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-00-18-03_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> |  |  |
</div>



当频谱分辨率与信号频率不匹配，发生频谱泄露时，例如设置 $f_s = (10\pi)\times f_{0}$：

<div class='center'>

| Window | None (Uniform) | Hanning (without amplitude/power correction) | Flat Top (without amplitude/power correction) |
|:-:|:-:|:-:|:-:|
 | Waveform and Spectrum | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-00-15-54_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-00-15-58_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-00-16-03_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> |
 | Power Spectrum Comparison | Uncorrected Power Spectrum <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-00-16-08_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> | Corrected Power Spectrum Comparison <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-29-09-57-25_All You Need to Know About Fourier Analysis (FS, DFS, FT, DTFT, DFT).png"/></div> | Corrected Power Spectrum Comparison <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-01-03-33_All You Need to Know About Fourier Analysis (FS, DFS, FT, DTFT, DFT).png"/></div> |
</div>

``` bash
%% 窗函数对比

clc, clear
f = 1e3;
T = 1/f;
omega = 2*pi*f;
Je_rms_mUI = 5;
% 带有 AM/PM noise + guass voltage noise + 杂七杂八噪声的信号
v_t = @(t) (1 + rand/10)*cos(omega * (t + randn*(Je_rms_mUI/1e3*T)) ) + rand/10*cos(rand(size(t)) .* 10*omega .* (t + randn*(Je_rms_mUI/1e3*T)) ) + rand/10;  

% 对信号进行采样
Je_rms_mUI = 10;
fs = f*(pi*10);
%fs = f*(32);
N = 2048*8;
t_n = 0:1/fs:(N-1)/fs;
v_n = v_t(t_n)

time_array = 0:0.1/fs:(N-1)/fs;
MyPlot(time_array(1:3000), v_t(time_array(1:3000)));

% 不加窗直接作 DFT (window = none, namely uniform)
stc1 = MyAnalysis_Spectrum_v1_20251124(v_n, fs, 1, 10);
stc.plot4.axes.YLim = [-100 0];
%MyExport_png(100)

% 作 DFT 之前先对时域信号加 Hanning 窗
window = hanning(N);
v_n_hanning = v_n .* window';
stc2 = MyAnalysis_Spectrum_v1_20251124(v_n_hanning, fs, 1, 10);
stc.plot4.axes.YLim = [-100 0];
%MyExport_png(100)

% 作 DFT 之前先对时域信号加 flat top 窗
window = flattopwin(N);
v_n_flattop = v_n .* window';
stc3 = MyAnalysis_Spectrum_v1_20251124(v_n_flattop, fs, 1, 10);
stc.plot4.axes.YLim = [-100 0];
%MyExport_png(100)

% 功率谱对比
freq = stc1.STC.fAxis_oneSided;
y1 = stc1.STC.y_oneSided;
y2 = stc2.STC.y_oneSided;
y3 = stc3.STC.y_oneSided;
p1_dB = 10*log10(stc1.STC.power_oneSided);
p2_dB = 10*log10(stc2.STC.power_oneSided);
p3_dB = 10*log10(stc3.STC.power_oneSided);

stc = MyPlot(freq, [p1_dB; p2_dB; p3_dB])
stc.axes.XScale = 'log';
stc.label.y.String = 'Power $\mathrm{dB(V^2)}$';
stc.label.x.String = 'Frequency (Hz)';
stc.leg.String = [
    "None (Uniform)"
    "Hanning (Hann)"
    "Flat Top"
];
ylim([-100 0])
stc.leg.Location = 'northeast';

MyFigure_ChangeSize([2.2, 1]*512)
%MyExport_png(100)
```


### 5.2 window correction

While a window helps reduce leakage, the window itself distorts the data in two different ways:
- Amplitude: the amplitude of the signal is reduced
- Power: the area under the curve, or power of the signal, is reduced

Window correction factors are used to try and compensate for the effects of applying a window to data. There are both amplitude correction factor (ACF) and energy correction factor (ECF). The ACF is used when measuring amplitude, while the ECF is used when measuring power or energy.

<div class='center'>

| window correction 部分的主要参考资料 |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-29-01-18-55_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-29-01-24-04_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> page.192 of [[3]](https://onlinelibrary.wiley.com/doi/book/10.1002/9780470978160) Brandt, A., 2011. Noise and vibration analysis: signal analysis and experimental procedures, John Wiley & Sons, [doi: 10.1002/9780470978160.](https://onlinelibrary.wiley.com/doi/book/10.1002/9780470978160) (备用连接 [here](https://www.doc88.com/p-7344867524140.html)) |

</div>

根据上述理论，我们将几个矫正因子总结如下：

<div class='center'>

| Correction Parameter | Description | Formula |
|:-:|:-:|:-:|
 | $\mathrm{ACF}$ | Amplitude Correction Factor | $$\mathrm{ACF} = \frac{1}{\displaystyle \frac{1}{N} \sum_{n = 0}^{N - 1} w[n]}$$ |
 | $\mathrm{ECF}$ | Energy Correction Factor | $$\mathrm{ECF} = \frac{1}{\displaystyle \frac{1}{N} \sum_{n = 0}^{N - 1} w^2[n]}$$ |
 | $B_{en}$ | window normalised equivalent noise bandwidth | $$B_{en} = \frac{\displaystyle N \sum_{n = 0}^{N - 1} w^2[n]}{\displaystyle \left(\sum_{n = 0}^{N - 1} w[n]\right)^2} = \frac{\mathrm{ACF}^2}{\mathrm{ECF}}$$ | 
</div>

上面的 ACF 在幅度矫正验证中似乎有一些问题，相应代码如下：


我们暂不深究原因，直接给出“正确”的 amplitude/power 矫正公式：

$$
\begin{gather}
\begin{cases}
X[m] = \mathrm{DFT}\{x[n]\},\ m = 0, 1, 2, ..., N-1 \\
A[m] = \frac{2}{N} \cdot \mathrm{abs}\{X[m]\},\ m = 0, 1, 2, ..., \left \lfloor \frac{N}{2}\right \rfloor  \\
P[m] = A[m]^2/2,\quad m = 0, 1, 2, ..., \left \lfloor \frac{N}{2}\right \rfloor
\end{cases}
\\
\Longrightarrow 
{\color{red} 
\begin{cases}
P_{cor}[m] = \mathrm{ECF} \cdot P[m]
\\
A_{cor}[m] = \sqrt{2 \cdot P_{cor}[m]} = \sqrt{\mathrm{ECF}} \cdot A[m]
\end{cases}
}
\end{gather}
$$

### 5.3 multi-window DFT

有了 `MyAnalysis_Spectrum_v1_20251124` 的示例，我们完全可以在一个 Spectrum Analysis 中同时给出采样信号在多种窗函数下的频谱分析结果，下面是一个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-29-02-35-50_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div>

``` bash
function stc = MyAnalysis_Spectrum_multiWindow(voltage, fs, plot_fig)

% 在 MyAnalysis_Spectrum_v1_20251124 (Uniform window) 的基础上，再增加 Hanning 和
% Flat Top 两种 window 的 corrected spectrum 结果

N_max = 1024*4;

if nargin <= 3
    flag_timeRange = 0;
else
    flag_timeRange = 1;
end

%% 三种不同窗函数的 DFT
    STC1 = MyAnalysis_DiscreteFourierTransform(voltage, fs);
    stc.STC1_uniform = STC1;
    N = STC1.N;
    f = STC1.fAxis_oneSided;
    AS_1 = STC1.y_oneSided;

    warning('off')

    win = hanning(length(voltage), 'periodic');
    STC2 = MyAnalysis_DiscreteFourierTransform(voltage.*win', fs);
    STC2.win = win;
    STC2.ACF = 1/mean(win);
    STC2.ECF = 1/rms(win)^2;
    STC2.B_en = STC2.ACF^2/STC2.ECF;
    STC2.power_oneSided_corrected = STC2.power_oneSided * STC2.ECF;
    STC2.y_oneSided_corrected = STC2.y_oneSided * sqrt(STC2.ECF);
    stc.STC2_hanning = STC2;
    AS_2 = STC2.y_oneSided;
    

    win = flattopwin(length(voltage), 'periodic');
    STC3 = MyAnalysis_DiscreteFourierTransform(voltage.*win', fs);
    STC3.win = win;
    STC3.ACF = 1/mean(win);
    STC3.ECF = 1/rms(win)^2;
    STC3.B_en = STC3.ACF^2/STC3.ECF;
    STC3.power_oneSided_corrected = STC3.power_oneSided * STC3.ECF;
    STC3.y_oneSided_corrected = STC3.y_oneSided * sqrt(STC3.ECF);
    stc.STC3_flattop = STC3;
    AS_3 = STC3.y_oneSided;

    warning('on')

%% 准备绘图
if plot_fig ~= 0  % 正常作图
    
    % 绘图准备
    stc.fig = figure('Color', [1 1 1]);
    stc.layout = tiledlayout(3, 2, 'Parent', stc.fig);
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';

%% 1. Unirform
    i = 1;
    % 绘制 Uniform 信号时域图像
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, i);
    stc.(['ax',num2str(i)]).Title.String = 'Signal Waveform';
    %stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), (0:(N-1))/fs, voltage);
    %warning('Large sampling points detected (N > 10000), only the first 8192 points are ploted.')
    
    if N > N_max
        % warning(['Large sampling points detected, all points are used for spectrum calculation but only the first ', num2str(N_max), ' points are ploted.'])
        time = STC1.t_nX10(1:10*(N_max));
        N_plot = N_max;
    else
        time = STC1.t_nX10;
        N_plot = N;
    end

    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), time, STC1.volt_recovered_func(time));
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), (0:(N-1))/fs, STC1.volt_n(1:N));
    stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'r';
    stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = 150;
    stc.(['scatter',num2str(i)]).axes.XLim(1) = 0;
    %stc.plot0.axes.XScale = 'log';
    stc.(['plot',num2str(i)]).leg.Visible = 'on';
    stc.(['plot',num2str(i)]).leg.String = [
        "Recovered Signal"
        "Sampling Points"
    ];
    stc.(['plot',num2str(i)]).leg.Location = 'northeast';
    stc.(['plot',num2str(i)]).label.x.String = 'Time (s)';
    stc.(['plot',num2str(i)]).label.y.String = 'Voltage (V)';

   
    % 找到幅度最大的三个频率
    [~, index] = sort(AS_1, 'descend'); % P1 降序排序
    index = index(1:3);
    markersize = 400;
    
    i = i+1;   
    % 绘制 (Uniform) single-sided power spectrum in (log x-axis scale)
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, i);
    stc.(['ax',num2str(i)]).Title.String = 'Power Spectrum (Uniform)';
    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), f, 10*log10(STC1.power_oneSided)  );
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), f(index), 10*log10(STC1.power_oneSided(index)));
    stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = markersize;
    stc.(['plot',num2str(i)]).axes.XScale = 'log';
    stc.(['plot',num2str(i)]).leg.Visible = 'off';
    stc.(['plot',num2str(i)]).label.x.String = 'Frequency (Hz)';
    stc.(['plot',num2str(i)]).label.y.String = 'Power $\mathrm{dB(V^2)}$';

    % 在合适的位置添加注释
    XLIM = stc.(['scatter',num2str(i)]).axes.XLim;
    YLIM = stc.(['scatter',num2str(i)]).axes.YLim;
    text(stc.(['ax',num2str(i)]), ...
         XLIM(1)*2, YLIM(2) - 0.4*(YLIM(2) - YLIM(1)), ...
        [ ...
            "Sampling Points $N$ = " + num2str(N/1e3, '%.3f') + " kPoints";
            "Sampling Frequency $f_s$ = " + num2str(fs, '%.3e') + " Hz";
            "Frequency Resolution $f_r$ = " + num2str(STC1.fr, '%.3e') + " Hz";
        ], ...
        'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
        'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
        'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
        'EdgeColor', 'k', ...               % 设置黑色边框（可选）
        'Margin', 2, ...                    % 设置文本与边框的边距（可选）
        'FontSize', 12, ...
        'Interpreter', 'latex' ...
    );
    
%% 2. Hanning
    % 绘制信号时域图像
    i = i+1;   
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, i);
    stc.(['ax',num2str(i)]).Title.String = 'Signal Waveform';
    if N > N_max
        time = STC2.t_nX10(1:10*(N_max));
        N_plot = N_max;
    else
        time = STC2.t_nX10;
        N_plot = N;
    end
    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), time, STC2.volt_recovered_func(time));
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), (0:(N-1))/fs, STC2.volt_n(1:N));
    stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'r';
    stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = 150;
    stc.(['scatter',num2str(i)]).axes.XLim(1) = 0;
    %stc.plot0.axes.XScale = 'log';
    stc.(['plot',num2str(i)]).leg.Visible = 'on';
    stc.(['plot',num2str(i)]).leg.String = [
        "Recovered Signal"
        "Sampling Points"
    ];
    stc.(['plot',num2str(i)]).leg.Location = 'northeast';
    stc.(['plot',num2str(i)]).label.x.String = 'Time (s)';
    stc.(['plot',num2str(i)]).label.y.String = 'Voltage (V)';

   
    % 找到幅度最大的三个频率
    [~, index] = sort(AS_2, 'descend'); % P1 降序排序
    index = index(1:3);
    markersize = 400;
    
    i = i+1;   
    % 绘制 (Uniform) single-sided power spectrum in (log x-axis scale)
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, i);
    stc.(['ax',num2str(i)]).Title.String = 'Corrected Power Spectrum (Hanning)';
    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), f, 10*log10(STC2.power_oneSided_corrected)  );
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), f(index), 10*log10(STC2.power_oneSided_corrected(index)));
    stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = markersize;
    stc.(['plot',num2str(i)]).axes.XScale = 'log';
    stc.(['plot',num2str(i)]).leg.Visible = 'off';
    stc.(['plot',num2str(i)]).label.x.String = 'Frequency (Hz)';
    stc.(['plot',num2str(i)]).label.y.String = 'Power $\mathrm{dB(V^2)}$';

    % 在合适的位置添加注释
    XLIM = stc.(['scatter',num2str(i)]).axes.XLim;
    YLIM = stc.(['scatter',num2str(i)]).axes.YLim;
    text(stc.(['ax',num2str(i)]), ... 
        ... % XLIM(2) - 0.5*(XLIM(2) - XLIM(1)), YLIM(2) - 0.3*(YLIM(2) - YLIM(1))
        XLIM(1)*2, YLIM(2) - 0.4*(YLIM(2) - YLIM(1)), ...
        [ ...
            "Sampling Points $N$ = " + num2str(N/1e3, '%.3f') + " kPoints";
            "Sampling Frequency $f_s$ = " + num2str(fs, '%.3e') + " Hz";
            "Frequency Resolution $f_r$ = " + num2str(STC2.fr, '%.3e') + " Hz";
        ], ...
        'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
        'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
        'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
        'EdgeColor', 'k', ...               % 设置黑色边框（可选）
        'Margin', 2, ...                    % 设置文本与边框的边距（可选）
        'FontSize', 12, ...
        'Interpreter', 'latex' ...
    );


%% 3. Flattop
    % 绘制信号时域图像
    i = i+1;   
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, i);
    stc.(['ax',num2str(i)]).Title.String = 'Signal Waveform';
    if N > N_max
        time = STC3.t_nX10(1:10*(N_max));
        N_plot = N_max;
    else
        time = STC3.t_nX10;
        N_plot = N;
    end
    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), time, STC3.volt_recovered_func(time));
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), (0:(N-1))/fs, STC3.volt_n(1:N));
    stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'r';
    stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = 150;
    stc.(['scatter',num2str(i)]).axes.XLim(1) = 0;
    %stc.plot0.axes.XScale = 'log';
    stc.(['plot',num2str(i)]).leg.Visible = 'on';
    stc.(['plot',num2str(i)]).leg.String = [
        "Recovered Signal"
        "Sampling Points"
    ];
    stc.(['plot',num2str(i)]).leg.Location = 'northeast';
    stc.(['plot',num2str(i)]).label.x.String = 'Time (s)';
    stc.(['plot',num2str(i)]).label.y.String = 'Voltage (V)';

   
    % 找到幅度最大的三个频率
    [~, index] = sort(AS_3, 'descend'); % P1 降序排序
    index = index(1:3);
    markersize = 400;
    
    i = i+1;   
    % 绘制 (Uniform) single-sided power spectrum in (log x-axis scale)
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, i);
    stc.(['ax',num2str(i)]).Title.String = 'Corrected Power Spectrum (Flattop)';
    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), f, 10*log10(STC3.power_oneSided_corrected)  );
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), f(index), 10*log10(STC3.power_oneSided_corrected(index)));
    stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = markersize;
    stc.(['plot',num2str(i)]).axes.XScale = 'log';
    stc.(['plot',num2str(i)]).leg.Visible = 'off';
    stc.(['plot',num2str(i)]).label.x.String = 'Frequency (Hz)';
    stc.(['plot',num2str(i)]).label.y.String = 'Power $\mathrm{dB(V^2)}$';

    % 在合适的位置添加注释
    XLIM = stc.(['scatter',num2str(i)]).axes.XLim;
    YLIM = stc.(['scatter',num2str(i)]).axes.YLim;
    text(stc.(['ax',num2str(i)]), ...
         XLIM(1)*2, YLIM(2) - 0.4*(YLIM(2) - YLIM(1)), ...
        [ ...
            "Sampling Points $N$ = " + num2str(N/1e3, '%.3f') + " kPoints";
            "Sampling Frequency $f_s$ = " + num2str(fs, '%.3e') + " Hz";
            "Frequency Resolution $f_r$ = " + num2str(STC3.fr, '%.3e') + " Hz";
        ], ...
        'VerticalAlignment', 'bottom', ... % 文本底部对齐到y_pos
        'HorizontalAlignment', 'left', ...  % 文本左对齐到x_pos
        'BackgroundColor', [1, 1, 1], ... % 设置浅黄色背景（可选）
        'EdgeColor', 'k', ...               % 设置黑色边框（可选）
        'Margin', 2, ...                    % 设置文本与边框的边距（可选）
        'FontSize', 12, ...
        'Interpreter', 'latex' ...
    );

    MyFigure_ChangeSize([2.2, 1]*512 .* [2, 2] * 0.8)
end

end
```


## 6. Zero-Padding

零填充 (Zero-Padding) 实现了 “高密度 (high-density)” 频谱，由此带来观感更好的绘图结果，但是它并没有给出 “高分辨率 (high-resolution)” 的频谱，这是因为没有任何新信息被添加到采样序列中，只在数据中添加了额外的零。从频率来看，零填充相当于对 DFT 结果做了插值，随着 Zero-Padding Factor 的增加，零填充点数逐渐增多，频谱曲线变得越来越平滑，逐渐接近无限采样点时 DTFT 得到的连续频谱曲线。



## 7. Amplitude Calculation



### 7.1 integral method

现在，假设我们有一个频率为 $f_0$ 但是带有噪声的正弦信号 $v(t)$，在已知采样序列 $v[n]$ 的情况下，如何计算出目标信号的幅值 $A_0$ (或功率 $P_0$) 及其频率 $f_0$？参考资料 [{5}](https://www.sjsu.edu/people/burford.furman/docs/me120/FFT_tutorial_NI.pdf) page.16 中提供一种思路，不妨称为积分法，对任意 window 均适用：

$$
\begin{gather}
\mathrm{Estimated\ Power:\ \ } P_0 = \frac{\displaystyle \sum_{n = n_0 - L}^{n_0 + L} P[n]}{\mathrm{noise\ power\ BW\ of\ the\ window}}
\\
\mathrm{Estimated\ Frequency:\ \ } f_0 = \frac{\displaystyle \sum_{n = n_0 - L}^{n_0 + L} \left[P[n] \cdot (n \Delta f)\right] }{\displaystyle \sum_{n = n_0 - L}^{n_0 + L} P[n]},\quad L \in [1, 5] \\
\end{gather}
$$

上式中的 $L$ 代表“积分带宽”，即在目标频率点 $n_0$ 的左右各取 $L$ 个频率点进行积分 (连续频谱的积分是对 df, 离散频谱的积分是乘上 dn 后求和，也就是乘上 1 后求和)。

下面是窗函数未经矫正时的积分结果：

<div class='center'>

| Window (Without Correction) | Uniform | Hanning | Flat Top |
|:-:|:-:|:-:|:-:|
 | L = 3 | 
 | Estimated Power (Vrms^2)   | 0.4892    | 0.1299   | 0.0241   |
 | Estimated Amplitude (Vamp) | 0.9892    | 0.5096   | 0.2197   |
 | Estimated Frequency (Hz)   | 1000.0972 | 999.9995 | 999.9973 |
 | L = 5 |
 | Estimated Power (Vrms^2)   | 0.5004    | 0.1299   | 0.0241   |
 | Estimated Amplitude (Vamp) | 1.0004    | 0.5096   | 0.2197   |
 | Estimated Frequency (Hz)   | 1000.0777 | 999.9995 | 999.9973 |
 | L = 20 |
 | Estimated Power (Vrms^2)   | 0.5144    | 0.1299   | 0.0241   |
 | Estimated Amplitude (Vamp) | 1.0143    | 0.5096   | 0.2197   |
 | Estimated Frequency (Hz)   | 1000.0641 | 999.9995 | 999.9973 |
</div>

``` bash
%% 估计信号频率和幅度/功率

L = 20;
BW_noise = [
    1.00    % Uniform
    1.50    % Hanning
    3.77   % Flat Top
];

num = 0;
for stc = [stc1, stc2, stc3]
    num = num + 1
    [ymax, ind] = max(stc.STC.y_oneSided(2:end));
    index = 1 + (ind-L:1:ind+L);
    ymax_array = stc.STC.y_oneSided(index);
    pmax_array =  stc.STC.power_oneSided(index);
    fr = stc.STC.fr;

    P0 = sum(pmax_array)/BW_noise(num)
    A0 = sqrt(2*P0)
    f0 = sum(pmax_array.*(index - 1)*fr)./sum(pmax_array);
    vpa(f0)
end
```

显然，未经窗函数矫正的积分法结果并不理想，只要带有窗函数，幅度/功率误差会非常大。


相反，带有窗函数矫正后的积分结果如下 (图中 $L = 0.1$ 特指 $L = 0$)：

<div class='center'>

| 积分法 (带有窗函数矫正) |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-01-34-15_All You Need to Know About Fourier Analysis (FS, DFS, FT, DTFT, DFT).png"/></div> |
</div>

可以看到，经过窗函数矫正后的积分法结果非常理想，频率/幅度/功率误差均非常小。且随着积分带宽 L 的增加，带有窗函数的结果收敛极快，这从侧面说明了窗函数对频谱泄漏的抑制效果。

特别地，在当前测试信号下, Hanning 窗的幅度/功率收敛速度最快，其次是 Flat Top 窗，最后才是 Uniform 窗。不妨再用信号总功率 `ECF*sum(v_n.^2)/N` 检验一下，发现确实满足 $P_{0,cor} \approx P_{total,cor}$ 且 $P_{0,cor} < P_{total,cor}$。

上面带有窗函数矫正的积分法代码如下：

``` matlab
估计信号频率和幅度/功率
%% 积分法

L = 5;
B_en = [
    1.00    % Uniform
    1.50    % Hanning
    3.77   % Flat Top
];
num = 0;


%% amplitude/energy correction factor
% Calculate windowing correction factor
% https://www.mathworks.com/matlabcentral/answers/372516-calculate-windowing-correction-factor
N = stc1.STC.N;
i = 1;
for w = [1 + zeros(N, 1),  hanning(N), flattopwin(N)]
    if i == 1
        ECF = 1/rms(w)^2;
        ACF = 1/mean(w);
    else
        ECF = [ECF, 1/rms(w)^2];
        ACF = [ACF, 1/mean(w)];
    end
    
    i = i + 1;
end

ECF
ACF
BW_n_nor = ACF.^2./ECF


disp('-------------------------------')
disp(['L = ', num2str(L)])
for stc = [stc1, stc2, stc3]
    num = num + 1
    [ymax, ind] = max(stc.STC.y_oneSided(2:end));
    index = 1 + (ind-L:1:ind+L);
    ymax_array = stc.STC.y_oneSided(index);
    pmax_array =  stc.STC.power_oneSided(index);
    fr = stc.STC.fr;

    %P0 = sum(pmax_array)/B_en(num)
    P0 = ECF(num) * sum(pmax_array)
    A0 = sqrt(2 * ECF(num) * sum(pmax_array))
    sqrt(2*sum(pmax_array))
    ACF(num) * sqrt(2*sum(pmax_array))
    ACF(num) * sqrt(2*sum(pmax_array) / B_en(num) )
    f0 = sum(pmax_array.*(index - 1)*fr)./sum(pmax_array);
    f0 = vpa(f0)
end



L = 200; num = 0;
disp('-------------------------------')
disp(['L = ', num2str(L)])
for stc = [stc1, stc2, stc3]
    num = num + 1
    [ymax, ind] = max(stc.STC.y_oneSided(2:end));
    index = 1 + (ind-L:1:ind+L);
    ymax_array = stc.STC.y_oneSided(index);
    pmax_array =  stc.STC.power_oneSided(index);
    fr = stc.STC.fr;

    P0 = ECF(num) * sum(pmax_array)
    A0 = sqrt(2*P0)
    sqrt(2*sum(pmax_array))
    ACF(num) * sqrt(2*sum(pmax_array))
    ACF(num) * sqrt(2*sum(pmax_array) / B_en(num) )
    f0 = sum(pmax_array.*(index - 1)*fr)./sum(pmax_array);
    f0 = vpa(f0)
end



%% 不同 window 用积分法的 amp 与 power 提取结果对比

% 实际数据处理版本（需要您提供stc1, stc2, stc3变量）
L_values = [0, 1, 2, 3, 5, 10, 20, 50, 100, 200];
% B_en = [1.00, 1.50, 3.77]; % Uniform, Hanning, Flat Top
% window_names = {'Uniform', 'Hanning', 'Flat Top'};
window_names = ["Uniform", "Hanning", "Flat Top"]

% 初始化结果存储
results_table = table();
results_cell = cell(1, 5);
results_cell{1, 1} = 'L';
results_cell{1, 2} = 'Window';
results_cell{1, 3} = 'P0';
results_cell{1, 4} = 'A0';
results_cell{1, 5} = 'f0';

row_idx = 2;

for i = 1:length(L_values)
    L = L_values(i);
    
    num = 0;
    for stc = [stc1, stc2, stc3]
        num = num + 1;
        
        [ymax, ind] = max(stc.STC.y_oneSided(2:end));
        index = 1 + (ind-L:1:ind+L);
        ymax_array = stc.STC.y_oneSided(index);
        pmax_array = stc.STC.power_oneSided(index);
        fr = stc.STC.fr;

        P0 = ECF(num) * sum(pmax_array);
        A0 = sqrt(2 * P0);
        f0 = sum(pmax_array .* (index - 1) * fr) / sum(pmax_array);
        
        % 添加到table
        new_row = table(L, P0, A0, f0, ...
                       'VariableNames', {'L', 'P0', 'A0', 'f0'});
        if isempty(results_table)
            results_table = new_row;
        else
            results_table = [results_table; new_row];
        end
        
        % 添加到cell
        results_cell{row_idx, 1} = L;
        results_cell{row_idx, 2} = window_names{num};
        results_cell{row_idx, 3} = P0;
        results_cell{row_idx, 4} = A0;
        results_cell{row_idx, 5} = f0;
        
        row_idx = row_idx + 1;
        
        fprintf('-------------------------------\n');
        fprintf('L = %d, Window = %s\n', L, window_names{num});
        fprintf('P0 = %.6f\n', P0);
        fprintf('A0 = %.6f\n', A0);
        fprintf('f0 = %.6f\n', f0);
    end
end

% 显示最终结果
fprintf('\n=========== 最终结果汇总 ===========\n');
disp(results_table);

fprintf('\n=========== Cell格式结果 ===========\n');
disp(results_cell);

% 作图
re = table2array(results_table)

P0_matrix = zeros(3, length(L_values));
A0_matrix = zeros(3, length(L_values));
f0_matrix = zeros(3, length(L_values));

for i = 1:3
    P0_matrix(i, :) = re(i-1 + (1:3:end), 2)';
    A0_matrix(i, :) = re(i-1 + (1:3:end), 3)';
    f0_matrix(i, :) = re(i-1 + (1:3:end), 4)';
end
%A0_matrix

L_values(1) = 1e-1;

tiledlayout(2, 1)
ax = nexttile;
stc = MyPlot_ax(ax, L_values, P0_matrix);
stc.axes.XScale = 'log';
stc.leg.String = [
    "Uniform"
    "Hanning"
    "Flat Top"
];
stc.label.x.String = 'Integral Length $L$';
stc.label.y.String = 'Estimated Power $P_0\ \mathrm{(V_{rms}^2)}$ ';



ax = nexttile;
stc = MyPlot_ax(ax, L_values, A0_matrix);
stc.axes.XScale = 'log';
stc.label.x.String = 'Integral Length $L$';
stc.label.y.String = 'Estimated Amplitude $A_0\ \mathrm{(V_{amp})}$';
stc.leg.String = [
    "Uniform"
    "Hanning"
    "Flat Top"
];

MyFigure_ChangeSize([2.2, 1.6]*512)


[ymax, ind] = max(stc.STC.y_oneSided(2:end));
index = 1 + [ind-1, ind, ind+1];
ymax_three = stc.STC.y_oneSided(index);
Y_p1 = ymax_three(3);
Y_m1 = ymax_three(1);

    % 步骤4: 计算频率偏移量 δ
    if abs(Y_p1) > abs(Y_m1)
        alpha = abs(Y_m1) / abs(Y_p1);
        delta = (alpha - 1) / (alpha + 1);  % 注意符号
    else
        alpha = abs(Y_p1) / abs(Y_m1);
        delta = (1 - alpha) / (1 + alpha);
    end
    
    % 限制 delta 在合理范围内
    % delta = max(min(delta, 0.5), -0.5);
    
% 步骤 5: 计算幅度校正因子 (Hanning 窗)
delta
if delta == 0
    W_delta = 1;
else
    W_delta = (pi * delta) / sin(pi * delta);
end

amplitude = ymax*W_delta
corrected_freq = stc.STC.fAxis_oneSided(index(2)) + delta * (fs / N)

```




### 7.2 discrete Fourier series 

另一种思路是利用离散傅里叶级数 (discrete Fourier series)，给定基频 $f_0$ 后，将采样序列 $v[n]$ 直接展开为傅里叶级数。理论考量如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-01-31-42_All You Need to Know About Fourier Analysis (FS, DFS, FT, DTFT, DFT).png"/></div>


下面直接给出代码实现和使用示例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-03-01-22-29_All You Need to Know About Fourier Analysis (FS, DFS, FT, DTFT, DFT).png"/></div>

DFS 方法给出的目标频率 (1 kHz) 处的幅值为 1.0815 Vamp, 这与前面积分法得到的 1.0825 Vamp 非常接近，说明 DFS 方法同样可以有效地提取目标频率处的幅值信息。

DFS 这种方法的优点是可以直接得到目标频率处的幅值，不受频谱泄露影响，且普适性较好：既不需要选择窗函数，也不关系频谱积分带宽 $L$。只要事先知道目标频率 $f_0$，就可以直接计算出该频率处的幅值。


``` bash
% 参数设置
f0 = 1000;           % 基频 1 kHz
fr = stc1.STC.fr;

% 执行 DFS
stc = MyAnalysis_DiscreteFourierSeries(v_n, fs, f0);
stc.amplitude_k

function stc = MyAnalysis_DiscreteFourierSeries(v_n, fs, f0)
% 离散傅里叶级数展开
% 输入:
%   v_n  - 采样电压序列
%   Fs   - 采样频率 (Hz)
%   f0   - 基频 (Hz)
%   df   - 频谱分辨率 (Hz)
% 输出:
%   a0   - 直流分量
%   ak   - 余弦项系数
%   bk   - 正弦项系数
%   k_harmonics - 谐波次数

    % 数据长度和时间向量
    N = length(v_n);
    fr = fs/N;
    T = 1/fr;
    T0 = 1/f0;
    omega_0 = 2*pi*f0;

    % 计算与 f0 匹配的最大点数 N_0
    r_array = 1:ceil(N/(T0*fr));
    N0_array = ceil( r_array*T0*fr );
    N0 = max(N0_array(N0_array <= N));
    r = floor(T/T0);
    N0 = round(r*T0*fs);

    if (N0 <= 0) || (N0 > N)
        error(['Wrong valuro of N0 = ', num2str(N0)])
    else
        disp([num2str(N0/N*100), '% points are used for DFS calculation (', num2str(N0), ' of ', num2str(N), ')'])
    end
    
    % 计算最大谐波次数
    k_max = floor((fs/2) / f0);   % 根据奈奎斯特频率限制
    k_max_res = floor(1/fr * f0); % 根据分辨率限制
    k_max = min(k_max, k_max_res);
    
    k_harmonics = 1:k_max;
    
    % 计算直流分量 a0
    a0 = mean(v_n);
    
    % 预分配系数数组
    ak = zeros(1, k_max);
    bk = zeros(1, k_max);
    
    % 计算各次谐波系数
    time_N0 = (0:N0-1) / fs;  % 对 n = 0 ~ (N0 - 1) 求和
    for k = 1:k_max
        ak(k) = (2/N0) * sum( v_n(1:N0) .* cos(k*omega_0 * time_N0) );   % 计算余弦项系数 ak
        bk(k) = (2/N0) * sum( v_n(1:N0) .* sin(k*omega_0 * time_N0) );   % 计算正弦项系数 bk
    end
    
    % 显示结果
    fprintf('Base frequency f0 = %.3f kHz\n', f0/1000);
    fprintf('Sampling frequency fs = %.3f kHz\n', fs/1000);
    fprintf('Frequency resolution fr = %.3f Hz\n', fr);
    fprintf('Maximum harmonic order = %d\n', k_max);

    stc.a_0 = a0;
    stc.a_k = ak;
    stc.b_k = bk;
    stc.amplitude_k = sqrt(ak.^2 + bk.^2);
    stc.phase_k = atan2(bk, ak) * 180/pi;  % unit: °
end
```


## MATLAB Codes

``` bash
% 2025.12.03 01:37 备份

窗函数与目标信号幅度/功率/频率计算

clc, clear
f = 1e3;
T = 1/f;
omega = 2*pi*f;
Je_rms_mUI = 5;
% 带有 AM/PM noise + guass voltage noise + 杂七杂八噪声的信号
v_t = @(t) (1 + rand/10)*cos(omega * (t + randn*(Je_rms_mUI/1e3*T)) ) ...
    + (0.1 + rand/10)*cos(2*omega * (t + randn*(Je_rms_mUI/1e3*T)) ) ...
    +  rand/10*cos(rand(size(t)) .* 10*omega .* (t + randn*(Je_rms_mUI/1e3*T)) ) + rand/10;  

% 对信号进行采样
Je_rms_mUI = 10;
fs = f*(pi*10);
%fs = f*(32);
N = 2048*4;
t_n = 0:1/fs:(N-1)/fs;
v_n = v_t(t_n)

time_array = 0:0.1/fs:(N-1)/fs;
MyPlot(time_array(1:3000), v_t(time_array(1:3000)));

% 不加窗直接作 DFT (window = none, namely uniform)
stc1 = MyAnalysis_Spectrum_v1_20251124(v_n, fs, 1, 10);
stc1.plot4.axes.YLim = [-100 0];
%MyExport_png(100)

% 作 DFT 之前先对时域信号加 Hanning 窗
window = hanning(N, 'periodic');
v_n_hanning = v_n .* window';   
% 注意需要乘上 ACF/ECF 才能得到修正后的 amplitude/power spectrum
stc2 = MyAnalysis_Spectrum_v1_20251124(v_n_hanning, fs, 1, 10);
stc2.plot4.axes.YLim = [-100 0];
%MyExport_png(100)


% 作 DFT 之前先对时域信号加 flat top 窗
window = flattopwin(N, 'periodic');
v_n_flattop = v_n .* window';
stc3 = MyAnalysis_Spectrum_v1_20251124(v_n_flattop, fs, 1, 10);
stc3.plot4.axes.YLim = [-100 0];
%MyExport_png(100)


% 功率谱对比
EFC = [1, 2.6663, 5.7078];
freq = stc1.STC.fAxis_oneSided;
y1 = stc1.STC.y_oneSided;
y2 = stc2.STC.y_oneSided;
y3 = stc3.STC.y_oneSided;
p1_dB = 10*log10(stc1.STC.power_oneSided * EFC(1));
p2_dB = 10*log10(stc2.STC.power_oneSided * EFC(2));
p3_dB = 10*log10(stc3.STC.power_oneSided * EFC(3));


tiledlayout(2, 1)
ax = nexttile;
stc = MyPlot_ax(ax, freq, [p1_dB; p2_dB; p3_dB]);
stc.axes.XScale = 'log';
stc.label.y.String = 'Power $\mathrm{dB(V^2)}$';
stc.label.x.String = 'Frequency (Hz)';
stc.leg.String = [
    "Uniform (No Window)"
    "Hanning (Corrected)"
    "Flat Top (Corrected)"
];
ylim([-100 0])
%xlim([1e3/5, 1e3*5])
stc.leg.Location = 'northwest';

ax = nexttile;
stc = MyPlot_ax(ax, freq, [p1_dB; p2_dB; p3_dB]);
stc.axes.XScale = 'log';
stc.label.y.String = 'Power $\mathrm{dB(V^2)}$';
stc.label.x.String = 'Frequency (Hz)';
stc.leg.String = [
    "Uniform (No Window)"
    "Hanning (Corrected)"
    "Flat Top (Corrected)"
];
ylim([-100 0])
xlim([1e3 - 100, 1e3 + 100])
stc.leg.Location = 'northwest';

MyFigure_ChangeSize([2.2, 2]*512)
%MyExport_png(100)

估计信号频率和幅度/功率
%% 积分法

L = 5;
B_en = [
    1.00    % Uniform
    1.50    % Hanning
    3.77   % Flat Top
];
num = 0;


%% amplitude/energy correction factor
% Calculate windowing correction factor
% https://www.mathworks.com/matlabcentral/answers/372516-calculate-windowing-correction-factor
N = stc1.STC.N;
i = 1;
for w = [1 + zeros(N, 1),  hanning(N), flattopwin(N)]
    if i == 1
        ECF = 1/rms(w)^2;
        ACF = 1/mean(w);
    else
        ECF = [ECF, 1/rms(w)^2];
        ACF = [ACF, 1/mean(w)];
    end
    
    i = i + 1;
end
ECF
ACF
BW_n_nor = ACF.^2./ECF


disp('-------------------------------')
disp(['L = ', num2str(L)])
for stc = [stc1, stc2, stc3]
    num = num + 1
    [ymax, ind] = max(stc.STC.y_oneSided(2:end));
    index = 1 + (ind-L:1:ind+L);
    ymax_array = stc.STC.y_oneSided(index);
    pmax_array =  stc.STC.power_oneSided(index);
    fr = stc.STC.fr;

    %P0 = sum(pmax_array)/B_en(num)
    P0 = ECF(num) * sum(pmax_array)
    A0 = sqrt(2 * ECF(num) * sum(pmax_array))
    sqrt(2*sum(pmax_array))
    ACF(num) * sqrt(2*sum(pmax_array))
    ACF(num) * sqrt(2*sum(pmax_array) / B_en(num) )
    f0 = sum(pmax_array.*(index - 1)*fr)./sum(pmax_array);
    f0 = vpa(f0)
end



L = 200; num = 0;
disp('-------------------------------')
disp(['L = ', num2str(L)])
for stc = [stc1, stc2, stc3]
    num = num + 1
    [ymax, ind] = max(stc.STC.y_oneSided(2:end));
    index = 1 + (ind-L:1:ind+L);
    ymax_array = stc.STC.y_oneSided(index);
    pmax_array =  stc.STC.power_oneSided(index);
    fr = stc.STC.fr;

    P0 = ECF(num) * sum(pmax_array)
    A0 = sqrt(2*P0)
    sqrt(2*sum(pmax_array))
    ACF(num) * sqrt(2*sum(pmax_array))
    ACF(num) * sqrt(2*sum(pmax_array) / B_en(num) )
    f0 = sum(pmax_array.*(index - 1)*fr)./sum(pmax_array);
    f0 = vpa(f0)
    power_total = ECF(num) * sum( stc.STC.volt_n.^2)/N
end


%% 不同 window 用积分法的 amp 与 power 提取结果对比

% 实际数据处理版本（需要您提供stc1, stc2, stc3变量）
L_values = [0, 1, 2, 3, 5, 10, 20, 50, 100, 200];
% B_en = [1.00, 1.50, 3.77]; % Uniform, Hanning, Flat Top
% window_names = {'Uniform', 'Hanning', 'Flat Top'};
window_names = ["Uniform", "Hanning", "Flat Top"]

% 初始化结果存储
results_table = table();
results_cell = cell(1, 5);
results_cell{1, 1} = 'L';
results_cell{1, 2} = 'Window';
results_cell{1, 3} = 'P0';
results_cell{1, 4} = 'A0';
results_cell{1, 5} = 'f0';

row_idx = 2;

for i = 1:length(L_values)
    L = L_values(i);
    
    num = 0;
    for stc = [stc1, stc2, stc3]
        num = num + 1;
        
        [ymax, ind] = max(stc.STC.y_oneSided(2:end));
        index = 1 + (ind-L:1:ind+L);
        ymax_array = stc.STC.y_oneSided(index);
        pmax_array = stc.STC.power_oneSided(index);
        fr = stc.STC.fr;

        P0 = ECF(num) * sum(pmax_array);
        A0 = sqrt(2 * P0);
        f0 = sum(pmax_array .* (index - 1) * fr) / sum(pmax_array);
        
        % 添加到table
        new_row = table(L, P0, A0, f0, ...
                       'VariableNames', {'L', 'P0', 'A0', 'f0'});
        if isempty(results_table)
            results_table = new_row;
        else
            results_table = [results_table; new_row];
        end
        
        % 添加到cell
        results_cell{row_idx, 1} = L;
        results_cell{row_idx, 2} = window_names{num};
        results_cell{row_idx, 3} = P0;
        results_cell{row_idx, 4} = A0;
        results_cell{row_idx, 5} = f0;
        
        row_idx = row_idx + 1;
        
        fprintf('-------------------------------\n');
        fprintf('L = %d, Window = %s\n', L, window_names{num});
        fprintf('P0 = %.6f\n', P0);
        fprintf('A0 = %.6f\n', A0);
        fprintf('f0 = %.6f\n', f0);
    end
end

% 显示最终结果
fprintf('\n=========== 最终结果汇总 ===========\n');
disp(results_table);

fprintf('\n=========== Cell格式结果 ===========\n');
disp(results_cell);

% 作图
re = table2array(results_table)

P0_matrix = zeros(3, length(L_values));
A0_matrix = zeros(3, length(L_values));
f0_matrix = zeros(3, length(L_values));

for i = 1:3
    P0_matrix(i, :) = re(i-1 + (1:3:end), 2)';
    A0_matrix(i, :) = re(i-1 + (1:3:end), 3)';
    f0_matrix(i, :) = re(i-1 + (1:3:end), 4)';
end
%A0_matrix

L_values(1) = 1e-1;

tiledlayout(3, 1)

ax = nexttile;
stc = MyPlot_ax(ax, L_values, f0_matrix);
stc.axes.XScale = 'log';
stc.leg.String = [
    "Uniform"
    "Hanning"
    "Flat Top"
];
stc.label.x.String = 'Integral Length $L$';
stc.label.y.String = 'Extracted Frequency $f_0\ \mathrm{(Hz)}$ ';
ylim([1e3 - 1 1e3 + 1])
stc.leg.Location = 'southeast';

ax = nexttile;
stc = MyPlot_ax(ax, L_values, P0_matrix);
stc.axes.XScale = 'log';
stc.leg.String = [
    "Uniform"
    "Hanning"
    "Flat Top"
];
stc.label.x.String = 'Integral Length $L$';
stc.label.y.String = 'Extracted Power $P_0\ \mathrm{(V_{rms}^2)}$ ';
stc.leg.Location = 'southeast';

ylim([0 0.6])


ax = nexttile;
stc = MyPlot_ax(ax, L_values, A0_matrix);
stc.axes.XScale = 'log';
stc.label.x.String = 'Integral Length $L$';
stc.label.y.String = 'Extracted Amplitude $A_0\ \mathrm{(V_{amp})}$';
stc.leg.String = [
    "Uniform"
    "Hanning"
    "Flat Top"
];
stc.leg.Location = 'southeast';

ylim([0 1.2])

MyFigure_ChangeSize([2.2, 2.1]*512)

构建多 window DFT 函数

stc = MyAnalysis_Spectrum_multiWindow(v_n, fs, 1);
% stc.STC2_hanning.volt_n


FS 方法
% 参数设置
f0 = 1000;           % 基频 1 kHz
fr = stc1.STC.fr;

% 执行 DFS
stc = MyAnalysis_DiscreteFourierSeries(v_n, fs, f0);
stc.amplitude_k




%% functions

function stc = MyAnalysis_DiscreteFourierTransform(volt_n, fs)
    % 输入 N-points 的离散时间信号 volt[n] 以及采样频率 fs, 返回信号与 FT 相关的各种分析结果

%% 数据准备
    Ts = 1/fs;
    N = length(volt_n);
    if mod(N, 2) == 1   % 检查 N 的奇偶情况
          warning('Odd sampling number detected, the last sampling point was discarded.')
          x_n = volt_n(1:(end-1));
          N = length(x_n);
    else 
        x_n = volt_n;
    end
    if N > 10000    % 检查 N 的大小
        warning('Large sampling number detected (N > 10000), the FFT algorithm is used.')
        flag_largeN = 1;
    else
        flag_largeN = 0;
    end
    t_n = Ts*(0:(N-1));     % 采样时间 t[n]
    fr = fs/N;  % 频谱分辨率
    
    % 保存结果
    stc.volt_n = volt_n;
    stc.x_n = x_n;
    stc.t_n = t_n;
    stc.N = N;
    stc.fr = fr;
    stc.fs = fs;
    stc.Ts = Ts;
    


%% 计算 DFT
    % 对 x[n] 做 DFT 得到离散频谱 X[m], 横坐标范围 Omega = 2*pi*(m/N), m = 0, 1, 2, ..., N-1
    n = 0:(N-1); m = 0:(N-1);
    
    if flag_largeN
        X_m = fft(x_n');
    else
        tv1 = x_n + zeros(N, 1);         % 利用 1xN array + Nx1 array 来复制 x_n, 得到 NxN 矩阵 = [x_n; x_n; ...; x_n], 每一行都是一个 x_n
        tv2 = exp(-1j*2*pi/N * (m'*n) ); % m'*n 得到大小为 NxN 的矩阵，第一行对应 m = 0 (n = 0, 1, ..., N-1), 第一行对应 m = 1 (n = 0, 1, ..., N),
        X_m = sum(tv1.*tv2, 2);          % 计算 DFT 结果 X[m], sum([], 2) 是对每一行求和，结果是列 array, 注意 X[m] 中的元素是复数
    end
    
    f_m = fs/N*m;           % 根据 fs 还原频率坐标
    y_m = 1/N * abs(X_m)';  % 根据 X_m 计算信号在不同频率处的幅度 (amplitude)，注意有一个系数 1/N
    phaseDeg_m = MyArcTheta_complex_deg(X_m)';
    power_m = y_m.^2/2; power_m(1) = 2*power_m(1);     % power 是 rms 值的平方, 注意 DC 处不应除以二 

    stc.X_m = X_m;
    stc.f_m = f_m;
    stc.y_m = y_m;
    stc.phaseDeg_m = phaseDeg_m;
    stc.power_m = power_m;

%% 计算 two-sided spectrum

%{
    原始结果 y_m 共 N points, m = 0, 1, ..., N-1, 其中 m = 0 为 DC, m = N 对应 fs
    two-sided 共 N + 1 points, m = 0, ±1, ..., ±N/2, 其中 m = 0 对应 DC, m = N/2 对应 fs/2
    从 y_m 计算 y_twoSided 时, 注意将 y_m 在 fs/2 (m = N/2) 处的值减半，分为 y_twoSided 中的 ±N/2 两点
    在 MATLAB 中，索引从 1 开始，于是 DC 和 fs/2 分别对应 index = 1 和 N/2+1, 于是索引 y_twoSide 被分为三组：
    index     = 1 ~ N/2, (N/2+1), (N/2+2) ~ (N+1)
    对应频率 f = -fs/2 ~ -fs/N, DC, +fs/N ~ +fs/2
    可以由实信号在频谱上的对称性简单求解 y_twoSide
%}
    y_twoSided = [y_m( (N/2+1):-1:2 ), y_m( 1 ), y_m( 2:1:(N/2+1) )];
    y_twoSided([1 end]) = y_twoSided([1 end])/2;  % 从 y_m 计算 y_twoSided 需要将 fs/2 处折半
    fAxis_twoSided = [-f_m( (N/2+1):-1:2 ), f_m( 1 ), f_m( 2:1:(N/2+1) )];
    phaseDeg_twoSided = [phaseDeg_m( (N/2+1):-1:2 ), phaseDeg_m( 1 ), phaseDeg_m( 2:1:(N/2+1) )];
    power_twoSided = y_twoSided.^2/2; power_twoSided(N/2+1) = 2*power_twoSided(N/2+1);  % power 是 rms 值的平方, 注意 DC 处不应除以二 

    stc.y_twoSided = y_twoSided;
    stc.fAxis_twoSided = fAxis_twoSided;
    stc.phaseDeg_twoSided = phaseDeg_twoSided;
    stc.power_twoSided = power_twoSided;


%% 计算 one-sided spectrum


%{
    one-sided 共 (N/2 + 1) points (默认 N 为偶数), m = 0, 1, ..., N/2, 其中 m = 0 对应 DC, m = N/2 对应 fs/2
    如果是从 y_twoSided 计算 y_oneSide, 注意 y_twoSided 中仅 DC (m = 0) 一个点的值 "不要" 翻倍
    如果是从 y_m 计算 y_oneSide, 注意 y_m 中的 DC (m = 0) 和 fs/2 (m = N/2) 两个点都 "不要" 翻倍
%}

    y_oneSided = y_twoSided( (N/2+1):end );
    y_oneSided(2:end) = 2*y_oneSided(2:end);    % 将除 DC 点之外的所有点翻倍
    fAxis_oneSided = fAxis_twoSided( (N/2+1):end );
    phaseDeg_oneSided = phaseDeg_twoSided( (N/2+1):end );
    power_oneSided = y_oneSided.^2/2; power_oneSided(1) = 2*power_oneSided(1);    % power 是 rms 值的平方, 注意 DC 处不应除以二 

    stc.y_oneSided = y_oneSided;
    stc.fAxis_oneSided = fAxis_oneSided;
    stc.phaseDeg_oneSided = phaseDeg_oneSided;
    stc.power_oneSided = power_oneSided;

%% 验证与恢复
    % 验证 x_n_recovered 与 x_n 是否相同
    if flag_largeN
        x_n_recovered = 0;
    else
        tv1 = X_m + zeros(N, 1); % 注意 X_m 为列向量，因此 tv1 第一行对应 m = 0, 第二行对应 m = 1
        tv2 = exp( 1j*2*pi/N * (n'*m) ) ;
        x_n_recovered = 1/N * sum(tv1.*tv2, 1);   % 注意这里求 x[n] 时是对 m 求和，前面求 X[m] 时是对 n 求和
        x_n_recovered = real(x_n_recovered);    % 用于验证 x_n_recovered 是否与原始 x_n 相同
    end
    
    % 从已知频谱中恢复出 "连续时间" 信号
    t_nX10 = 0:Ts/10:((N-1)*Ts);
    if flag_largeN
        volt_recovered_nX10 = zeros(size(t_nX10));
        % volt_recovered_func = @(t) t;
        warning('Large sampling number detected (N > 10000), the recovered continuous signal x(t) only contains the 5000 frequency points with the greatest amplitude.')
        [~, index_5000Max] = maxk(y_oneSided, 5000);
        y_oneSided_5000Max = y_oneSided(index_5000Max);
        fAxis_oneSided_5000Max = fAxis_oneSided(index_5000Max);
        phaseDeg_oneSided_5000Max = phaseDeg_oneSided(index_5000Max);
        % volt_recovered_func = @(t) sum( y_oneSided(index_5000Max)' .* cos(2*pi*fAxis_oneSided(index_5000Max)'.* t + deg2rad(phaseDeg_oneSided(index_5000Max)')) , 1);
        volt_recovered_func = @(t) sum( y_oneSided_5000Max' .* cos(2*pi*fAxis_oneSided_5000Max'.* t + deg2rad(phaseDeg_oneSided_5000Max')) , 1);
        stc.index_5000Max = index_5000Max;
    else 
        tv = y_oneSided' .* cos(2*pi*fAxis_oneSided'.*t_nX10 + deg2rad(phaseDeg_oneSided'));   % 所得 tv 是一个矩阵，第一行对应 f = 0, 第二行对应 f = fs/N, ... 
        volt_recovered_nX10 = sum(tv, 1);   % 对列求和，计算 t = t_0 时的所有频率分量之和
        volt_recovered_func = @(t) sum( y_oneSided' .* cos(2*pi*fAxis_oneSided'.* t + deg2rad(phaseDeg_oneSided')) , 1);
    end
    

    stc.x_n_recovered = x_n_recovered;
    stc.t_nX10 = t_nX10;
    stc.volt_recovered_nX10 = volt_recovered_nX10;
    stc.volt_recovered_func = volt_recovered_func;

end
```


## Advanced Reading


<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-28-23-43-32_Calculating Amplitude of a Specific Frequency from Spectrum.png"/></div> |  |  |
 |  |  |  |
</div>


## Reference

参考博客/文章：
- [{1} How do you find the frequency and amplitude from Fourier?](https://mathematica.stackexchange.com/questions/42783/how-do-you-find-the-frequency-and-amplitude-from-fourier)
- [{2} How do you find the frequency and amplitude from Fourier? > auto-correlation](https://mathematica.stackexchange.com/questions/42783/how-do-you-find-the-frequency-and-amplitude-from-fourier/43006#43006)
- [{3} How do you find the frequency and amplitude from Fourier? > Prony series](https://mathematica.stackexchange.com/questions/42783/how-do-you-find-the-frequency-and-amplitude-from-fourier/94713#94713)
- [{4} How do you find the frequency and amplitude from Fourier? > looking for periodicities](https://mathematica.stackexchange.com/questions/42783/how-do-you-find-the-frequency-and-amplitude-from-fourier/43001#43001)
- [{5} The Fundamentals of FFT-Based Signal Analysis and Measurement](https://www.sjsu.edu/people/burford.furman/docs/me120/FFT_tutorial_NI.pdf)
- [{6} 知乎 > 如何从复杂信号中提取特定频率的幅值和相位？ (Fourier Series Method)](https://www.zhihu.com/question/648361591)
- [{7} Digital Signals Theory > 6.4. Spectral leakage and windowing](https://brianmcfee.net/dstbook-site/content/ch06-dft-properties/Leakage.html)
- [{8} DSP Related > The Discrete Fourier Transform and the Need for Window Functions](https://radiosystemdesign.com/assets/pdf/downloads/dft_and_windows_94682.pdf)
- [{9} DSP Related > The Discrete Fourier Transform and the Need for Window Functions](https://www.dsprelated.com/showarticle/1433.php)
- [{10} SIEMENS > Simcenter - Testing > Window Correction Factors](https://community.sw.siemens.com/s/article/window-correction-factors)
- [{11} SIEMENS > Windows and Spectral Leakage](https://community.sw.siemens.com/s/article/windows-and-spectral-leakage)
- [{12} MATLAB Community > Calculate windowing correction factor](https://www.mathworks.com/matlabcentral/answers/372516-calculate-windowing-correction-factor)
- [{13} Zurich Instruments > How to Control Spectral Leakage with Window Functions](https://blogs.zhinst.com/ch/cn/blogs/how-control-spectral-leakage-window-functions-labone)

参考文献：
- [1] Oppenheim, Alan V., Ronald W. Schafer, and John R. Buck. Discrete-Time Signal Processing. Upper Saddle River, NJ: Prentice Hall, 1999.
- [[2]](https://www.sciencedirect.com/org/science/article/pii/S152614922000168X) “Windowing Techniques, the Welch Method for Improvement of Power Spectrum Estimation,” Computers, Materials and Continua, vol. 67, no. 3, pp. 3983–4003, Jan. 2021, [doi: 10.32604/cmc.2021.014752.](https://www.sciencedirect.com/org/science/article/pii/S152614922000168X)
- [[3]](https://onlinelibrary.wiley.com/doi/book/10.1002/9780470978160) Brandt, A., 2011. Noise and vibration analysis: signal analysis and experimental procedures, John Wiley & Sons, [doi: 10.1002/9780470978160.](https://onlinelibrary.wiley.com/doi/book/10.1002/9780470978160) (备用连接 [here](https://www.doc88.com/p-7344867524140.html))