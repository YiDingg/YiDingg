# Common Emitter Amplifier Experiment

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 23:45 on 2025-03-25 in Beijing.

## Intro

- Time: 2025-03-29
- Location: Beijing
- Author: Yi Ding

In this experiment, we will calculate, simulate and conduct a practical test of the CE (Common Emitter) amplifier circuit. The schematic is shown below:

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-13-35-41_Common Emitter Amplifier Experiment.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-13-35-56_Common Emitter Amplifier Experiment.png"/></div>

Considering the NPN BJT that we have and that the LTspice simulation library also has, we will use the BC547C transistor. 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-15-22-16_Common Emitter Amplifier Experiment.png"/></div>

## 1 - Static Chara Simulation

Below is the static characteristic simulation results of BC547C (NPN). 
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-13-57-47_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-14-20-47_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-14-19-17_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-12-40-25_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-12-40-54_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-12-46-14_Common Emitter Amplifier Experiment.png"/></div>

## 2 -  Extracting SPICE Model Parameters

Below is the SPICE model of BC547C in LTspice:

``` SPICE
.model bc547c npn(is=4.679e-14 nf=1.01 ise=2.642e-15 ne=1.581 bf=458.7 ikf=0.1371 vaf=52.64 nr=1.019 isc=2.337e-14 nc=1.164 br=11.57 ikr=0.1144 var=364.5 rb=1 irb=1.00e-06 rbm=1 re=0.2598 rc=1 xtb=0 eg=1.11 xti=3 cje=1.229e-11 vje=0.5591 mje=0.3385 tf=4.689e-10 xtf=160 vtf=2.828 itf=0.8842 ptf=0 cjc=4.42e-12 vjc=0.1994 mjc=0.2782 xcjc=0.6193 tr=1.00e-32 cjs=0 vjs=0.75 mjs=0.333 fc=0.7936 vceo=45 icrating=100m mfg=nxp)

% or rewrite it to improve readability
.model bc547c npn(
is=4.679e-14 nf=1.01 ise=2.642e-15 ne=1.581 bf=458.7 ikf=0.1371 vaf=52.64 
nr=1.019 isc=2.337e-14 nc=1.164 br=11.57 ikr=0.1144 var=364.5 rb=1 irb=1.00e-06 
rbm=1 re=0.2598 rc=1 xtb=0 eg=1.11 xti=3 cje=1.229e-11 vje=0.5591 mje=0.3385 
tf=4.689e-10 xtf=160 vtf=2.828 itf=0.8842 ptf=0 cjc=4.42e-12 vjc=0.1994 mjc=0.2782 
xcjc=0.6193 tr=1.00e-32 cjs=0 vjs=0.75 mjs=0.333 fc=0.7936 vceo=45 icrating=100m mfg=nxp
)
```

We extract a few parameters that we've learned so far. They are:

``` matlab
is=4.679e-14    % I_S, transport saturation current
nf=1.01         % nf*V_T, forward mode ideality factor
bf=458.7        % ideal maximum forward beta
vaf=52.64       % V_A, forward early voltage
rb=1            % R_B0, base resistance
irb=1.00e-06    % the base current where R_B0 drops by 50 percent
rbm=1           % R_B0_min, the minimum base resistance in high base current situation
re=0.2598       % R_E0, emitter resistance
rc=1            % R_C0, collector resistance
```

Therefore, we have:

$$
\begin{gather}
I_S = 4.679 \times 10^{-14} \ \mathrm{A}\\
n_f = 1.01,\ 
\beta = 458.7,\ 
V_A = 52.64 \ \mathrm{V},\ 
\\
R_{B0} = 1 \ \Omega,\ 
R_{E0} = 0.2598 \ \Omega,\ 
R_{C0} = 1 \ \Omega
\end{gather}
$$

## 3 - DC Operation Point

### 3.1 - Theoretical

Now, we will calculate the DC operating point and AC small signal parameters of the CE amplifier circuit.

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-15-06-23_Common Emitter Amplifier Experiment.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-15-22-35_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-15-09-30_Common Emitter Amplifier Experiment.png"/></div>

Therefore, the dc operating point is:
$$
\begin{gather}
I_C = 2.2518 \ \mathrm{mA},\quad 
I_B = 4.9091 \ \mathrm{\mu A} 
\\
V_{CE} = 1.9550 \ \mathrm{V},\quad
V_{BE} = 0.6440 \ \mathrm{V}
\\
V_C = 2.7459 \ \mathrm{V},\quad
V_B = 1.4359 \ \mathrm{V},\quad
V_E = 0.7910 \ \mathrm{V},\quad
\end{gather}
$$


Here are the MATLAB codes for the calculations:

``` matlab
% 线电期中实验：CE Amp
clc, clear, close all

% 电路参数
R_1 = 24e3;
R_2 = 10e3;
R_C1 = 1e3;
R_E1 = 51;
R_E2 = 300;

% SPICE 参数
Vcc = 5;
I_S = 4.679e-14;
R_B0 = 1;
R_C0 = 1;
R_E0 = 0.2598;
beta = 458.7;
n_f = 1.01;
V_A = 52.64;

% 其它参数
R_E_all = R_E0 + R_E1 + R_E2
R_all = R_C0 + R_C1 + R_E0 + R_E1 + R_E2
V_T = 26e-3;


tv_Ic = Vcc/R_all*1000
tv_Ib = tv_Ic/beta*1000

func_I_C = @(V_BE, V_CE) I_S*exp(V_BE/(n_f*V_T)).*(1 + V_CE/V_A)
array_V_BE = linspace(600, 670, 8)*10^(-3);
array_V_CE = linspace(1, 5, 100);
matrix_I_C = func_I_C(array_V_BE, array_V_CE');

MyPlot(array_V_CE, matrix_I_C');

V_B = @(I_C) (Vcc - I_C*R_1/beta) / (1 + R_1/R_2)
eq = @(I_C) I_C - I_S .* exp(  (V_B(I_C) - I_C.*R_E_all) / (n_f*V_T)  ) .* (1 + (Vcc - I_C.*R_all)/V_A)
range_I_C = linspace(0, 5e-3, 200);
stc = MyPlot_2window(range_I_C, eq(range_I_C), range_I_C, abs(eq(range_I_C)));
stc.ax1.YLim = [-1 1]; 
stc.ax1.XLim = [0 range_I_C(end)];
stc.ax2.YLim = [-1 1]; 
stc.ax2.XLim = [0 range_I_C(end)];
stc.ax2.YScale = 'log';

I_C = fzero(eq, [0 4e-3]);
disp(['I_C = ', num2str(I_C*1000, '%.8f') ' mA'])  

I_B = I_C/beta
V_B(I_C)
V_C = Vcc - I_C*(R_C0 + R_C1)
V_E = I_C*R_E_all
V_BE = V_B(I_C) - V_E
V_CE = V_C - V_E
```


### 3.2 - Simulated

Now, we perform the DC operating point simulation in LTspice. The results are shown below:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-15-31-53_Common Emitter Amplifier Experiment.png"/></div>

Rewrite the simulation result, the dc operating point is:
$$
\begin{gather}
\mathrm{simulated:\ }
\begin{cases}
I_C = 2.2544 \ \mathrm{mA},\quad 
I_B = 4.8986 \ \mathrm{\mu A} 
\\
V_{CE} = 1.9526 \ \mathrm{V},\quad
V_{BE} = 0.6430 \ \mathrm{V}
\\
V_C = 2.7456 \ \mathrm{V},\quad
V_B = 1.4360 \ \mathrm{V},\quad
V_E = 0.7930 \ \mathrm{V},\quad
\end{cases}
\end{gather}
$$

Compared with the theoretical calculation results, the two are basically consistent:

$$
\begin{gather}
\mathrm{theoretical:\ }
\begin{cases}
I_C = 2.2518 \ \mathrm{mA},\quad 
I_B = 4.9091 \ \mathrm{\mu A} 
\\
V_{CE} = 1.9550 \ \mathrm{V},\quad
V_{BE} = 0.6440 \ \mathrm{V}
\\
V_C = 2.7459 \ \mathrm{V},\quad
V_B = 1.4359 \ \mathrm{V},\quad
V_E = 0.7910 \ \mathrm{V},\quad
\end{cases}
\end{gather}
$$

### 3.3 - Practical

In the following contents, we will use the practical circuit to examine the results we have obtained so far. The practical circuit is shown below:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-14-32-44_Common Emitter Amplifier Experiment.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-14-32-52_Common Emitter Amplifier Experiment.jpg"/></div>

## 4 - Small-Signal Gain

### 4.1 - Theoretical

Assuming $f = 1 \ \mathrm{kHz}$, we can calculate the AC small-signal gain of the CE amplifier:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-16-08-00_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-16-08-21_Common Emitter Amplifier Experiment.png"/></div>

``` matlab
% ac gain calculation
f = 1e3;
omega = 2*pi*f;
C_in = 10e-6;
C_out = 10e-6;
C_E = 100e-6;

R_B = R_B0 + MyParallel_n([1/(1j*omega*C_in), R_1, R_2])
R_C = R_C1
R_E = R_E1 + MyParallel(R_E2, 1/(1j*omega*C_E))

r_O = V_A/I_C
g_m = I_C/(n_f*V_T)
r_pi = beta/g_m

R_coll = r_O * (  1 + (beta/(r_pi + R_B) + 1/r_O)*MyParallel(R_E, r_pi) )
R_out = MyParallel(R_C, R_coll)
G_m = beta/(r_pi + R_B) / R_E * MyParallel_n([R_E, (r_pi + R_B)/(beta + 1), r_O])
A_v = -G_m*R_out
A_v_abs = abs(A_v)
```

By simply changing the frequency, we can sketch the AC small-signal gain curve of the circuit, i.e., the frequency response in the medium frequency. The result is shown below:

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-16-49-03_Common Emitter Amplifier Experiment.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-17-36-03_Common Emitter Amplifier Experiment.png"/></div>

``` matlab
% ac gain frequency response
f = logspace(0, 6, 7*100);
omega = 2*pi*f;
C_in = 10e-6;
C_out = 10e-6;
C_E = 100e-6;

R_B = R_B0 + MyParallel_n([1./(1j*omega*C_in), R_1, R_2]);
R_C = R_C1;
R_E = R_E1 + MyParallel(R_E2, 1./(1j*omega*C_E));

r_O = V_A/I_C;
g_m = I_C/(n_f*V_T);
r_pi = beta/g_m;

R_coll = r_O * (  1 + (beta./(r_pi + R_B) + 1/r_O) .* MyParallel(R_E, r_pi) );
R_out = MyParallel(R_C, R_coll);
%G_m = beta./(r_pi + R_B) ./ R_E .* MyParallel_n([R_E, (r_pi + R_B)./(beta + 1), r_O])
tv_1 = zeros(size(R_E)) +  (r_pi + R_B)./(beta + 1);
tv_2 = zeros(size(R_E)) +  r_O;
G_m = beta./(r_pi + R_B) ./ R_E .* MyParallel_n([R_E', tv_1', tv_2']);
A_1 = -G_m.*R_out;  % 注意这里还不是实际的小信号增益, 因为没有考虑输入电阻
A_v = A_1 .* (1j*omega*C_in) .* MyParallel_n([zeros(size(omega')) + R_1, zeros(size(omega')) + R_2, 1./(1j*omega'*C_in)])
A_v_abs = abs(A_v);
A_v_dB = 20*log(A_v_abs)/log(10);
abs(A_v(1));
phase = rad2deg(angle(A_v));
%phase(phase > 90) = phase(phase > 90) - 360;

stc = MyYYPlot([f; f], [A_v_abs; phase]);
stc.axes.XScale = 'log';
stc.label.x.String = 'Frequency $f$ (Hz)';
stc.label.y_left.String = 'Gain $A_v$ (V/V)';
stc.label.y_right.String = 'Phase $\theta$ ($^\circ$)';
stc.leg.Visible = 'off';

stc = MyYYPlot([f; f], [A_v_dB; phase]);
stc.axes.XScale = 'log';
stc.label.x.String = 'Frequency $f$ (Hz)';
stc.label.y_left.String = 'Gain $A_v$ (dB)';
stc.label.y_right.String = 'Phase $\theta$ ($^\circ$)';
stc.leg.Visible = 'off';
```


### 4.2 - Simulated

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-16-15-13_Common Emitter Amplifier Experiment.png"/></div> -->


The maximum small-signal voltage gain:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-16-16-12_Common Emitter Amplifier Experiment.png"/></div>

The frequency with $10 \,\%$ decrease in voltage gain:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-16-18-40_Common Emitter Amplifier Experiment.png"/></div>


The voltage gain's 3 dB bandwidth:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-16-19-13_Common Emitter Amplifier Experiment.png"/></div>

$$
\begin{gather}
\mathrm{BW} = 59.948425 \ \mathrm{MHz} - 30.515276 \ \mathrm{Hz} =  59.9480 \ \mathrm{MHz}
\end{gather}
$$

### 4.3 - Practical

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-13-57-54_Common Emitter Amplifier Experiment.png"/></div>


## 5 - Input/Output Impedance



Since the presence of the coupling capacitors, the input/output impedance is a function of frequency. Considering the impedance of input/output capacitors, it can be derived that:

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-17-50-08_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-20-38-33_Common Emitter Amplifier Experiment.png"/></div>
 -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-20-58-41_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-11-20-59-11_Common Emitter Amplifier Experiment.png"/></div>

We can see that $|R_{in}| = 5.571 \ \mathrm{k}\Omega$ and $|R_{out}| = 1.007 \ \mathrm{k\Omega}$ at $f = 1 \ \mathrm{kHz}$.



## 6 - Large-Signal Gain (f = 10 kHz, Theoretical)

A relatively large input signal can disturb the DC operating point, thus changing the collector current and the voltage gain. The figure below illustrate the situation:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-17-41-59_Common Emitter Amplifier Experiment.png"/></div>

``` matlab
% Large-Signal Gain (f = 10 KHz)

I_C = linspace(0, 4e-3, 100);

f = 10e3;
omega = 2*pi*f;
C_in = 10e-6;
C_out = 10e-6;
C_E = 100e-6;

R_B = R_B0 + MyParallel_n([1./(1j*omega*C_in), R_1, R_2]);
R_C = R_C1;
R_E = R_E1 + MyParallel(R_E2, 1./(1j*omega*C_E));

r_O = V_A./I_C;
g_m = I_C/(n_f*V_T);
r_pi = beta./g_m;

R_coll = r_O .* (  1 + (beta./(r_pi + R_B) + 1./r_O) .* MyParallel(R_E, r_pi) );
R_out = MyParallel(R_C, R_coll);
%G_m = beta./(r_pi + R_B) ./ R_E .* MyParallel_n([R_E, (r_pi + R_B)./(beta + 1), r_O])
tv_1 = (r_pi + R_B)./(beta + 1);
tv_2 = r_O;
tv_R_E = zeros(size(I_C)) + R_E;
G_m = beta./(r_pi + R_B) ./ R_E .* MyParallel_n([tv_R_E', tv_1', tv_2']);
A_1 = -G_m.*R_out;  % 注意这里还不是实际的小信号增益, 因为没有考虑输入电阻
A_v = A_1 .* (1j*omega*C_in) .* MyParallel_n([zeros(size(omega')) + R_1, zeros(size(omega')) + R_2, 1./(1j*omega'*C_in)]);
A_v_abs = abs(A_v);
A_v_dB = 20*log(A_v_abs)/log(10);
abs(A_v(1));
phase = rad2deg(angle(A_v));
%phase(phase > 90) = phase(phase > 90) - 360;

stc = MyYYPlot([I_C; I_C]*10^3, [A_v_abs; A_v_dB]);
stc.label.x.String = 'Collector Current $I_C$ (mA)';
stc.label.y_left.String = 'Gain $A_v$ (V/V)';
stc.label.y_right.String = 'Gain $A_v$ (dB)';
stc.leg.Visible = 'off';
stc.axes.YLim = [0 20];
yyaxis('right')
stc.axes.YLim = [0 30];
```
## 7 - Transient Response

### 7.1 - Simulated

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-13-45-31_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-23-28-45_Common Emitter Amplifier Experiment.png"/></div>



<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-13-11-54_Common Emitter Amplifier Experiment.png"/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-00-08-00_Common Emitter Amplifier Experiment.png"/></div> -->


### 7.2 - Practical

Note that we use the $10 \ \mathrm{\Omega} + 1 \ \mathrm{k}\Omega$ voltage divider to achieve an attenuation coefficient of $\frac{1}{101}$, therefore giving a stable input small-signal.

In the following figures, CH1 (Orange) refers to the input signal and CH2 (Blue) refers to the output signal. 
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-29-23-00-40_Common Emitter Amplifier Experiment.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-00-45-37_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-00-44-46_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-00-46-48_Common Emitter Amplifier Experiment.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-00-47-25_Common Emitter Amplifier Experiment.png"/></div>
 -->

Higher input frequency:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-14-15-14_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-14-15-52_Common Emitter Amplifier Experiment.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-14-16-49_Common Emitter Amplifier Experiment.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-14-12-46_Common Emitter Amplifier Experiment.png"/></div>
 -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-00-52-23_Common Emitter Amplifier Experiment.png"/></div> -->

## 8 - Input Range Analysis


### 8.1 - Theoretical

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-13-38-27_Common Emitter Amplifier Experiment.png"/></div>

<!-- Remark that $R_{E2}$ is approximately shorted because of the bypass capacitor $C_E$ in <span style='color:red'> AC </span> input/output range calculation.


To avoid the saturation distortion, the collector-emitter should be greater than about $0.2 \ \mathrm{V}$, yielding:
$$
\begin{gather}
V_{CE} = V_{CC} - I_C *(R_{C0} + R_{C1} + R_{E0} + R_{E1}) > 0.2 \ \mathrm{V} 
\\
\Longrightarrow 
I_C < 4.5616 \ \mathrm{mA},\quad V_C >  0.4384 \ \mathrm{V}
\end{gather}
$$

Since $A_v$ is approximately a constant value for $I_C > 1 \ \mathrm{mA}$ (before reaching the saturation point), we can calculate the maximum input voltage using the average voltage gain:
$$
\begin{gather}
V_C >  0.4384 \ \mathrm{V} \Longrightarrow  v_{out} = V_C - V_{CQ} > 0.4384 \ \mathrm{V} - 2.7459 \ \mathrm{V} = -2.3075 \ \mathrm{V} \\
\\
\Longrightarrow
v_{in} \approx \frac{v_{out}}{16} > -144.22 \ \mathrm{mV}
\end{gather}
$$
 -->
<!-- WE also have $I_C = I_S \exp \left( \frac{V_{BE}}{n_f V_T} \right) \left(1 + \frac{V_{CE}}{V_A}\right) \approx I_S \exp \left( \frac{V_{BE}}{n_f V_T} \right)$, thus:
$$
\begin{gather}
V_{BE} < 664.5 \ \mathrm{mV}
\end{gather}
$$ -->


### 8.2 - Simulated


Edge of saturation distortion ($v_{in, \max}$, $I_{C,\max}$, and $v_{out,\min} $):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-13-21-30_Common Emitter Amplifier Experiment.png"/></div>

Edge of cut-off (threshold) distortion ($v_{in, \min}$, $I_{C,\min}$, and $v_{out,\max} $):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-13-40-21_Common Emitter Amplifier Experiment.png"/></div>

### 8.3 - Practical

Edge of saturation distortion ($v_{in, \max}$, $I_{C,\max}$, and $v_{out,\min} $):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-13-53-48_Common Emitter Amplifier Experiment.png"/></div>


Edge of cut-off (threshold) distortion ($v_{in, \min}$, $I_{C,\min}$, and $v_{out,\max} $):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-13-55-10_Common Emitter Amplifier Experiment.png"/></div>
















## 14 - Nonlinearity Distortion Analysis

Even though the CE amplifier is a linear circuit, it can still produce nonlinear distortion, especially when the input signal is relatively large (but not causing saturation or cut-off distortion). 

This is because the amp exhibits a different small-signal voltage gain for different collector current $I_C$. 
As the input signal varies, the collector current varies and thus the gain varies, leading to a nonlinear distortion.
It can be easily proved that, in the CE amp shown above, the lower half part has a larger peak-to-peak voltage than that of the upper half part. Because the lower half part has a larger collector current, thus a larger gain.

We can verify this point in the practical circuit:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-30-14-21-17_Common Emitter Amplifier Experiment.png"/></div>

## 99 - Conclusion


The experiment is a success. We have learned how to calculate, simulate and conduct a practical test of the CE amplifier circuit. The results are consistent with our theoretical calculations and simulation results. 


## Appendix - Matlab codes


All codes involved in the theoretical calculation of this experiment are as follows:
``` matlab
% dc point calculation
clc, clear, close all

% 电路参数
R_1 = 24e3;
R_2 = 10e3;
R_C1 = 1e3;
R_E1 = 51;
R_E2 = 300;

% SPICE 参数
Vcc = 5;
I_S = 4.679e-14;
R_B0 = 1;
R_C0 = 1;
R_E0 = 0.2598;
beta = 250;
n_f = 1.01;
V_A = 52.64;

% 其它参数
R_E_all = R_E0 + R_E1 + R_E2
R_all = R_C0 + R_C1 + R_E0 + R_E1 + R_E2
V_T = 26e-3;


tv_Ic = Vcc/R_all*1000
tv_Ib = tv_Ic/beta*1000

func_I_C = @(V_BE, V_CE) I_S*exp(V_BE/(n_f*V_T)).*(1 + V_CE/V_A)
array_V_BE = linspace(600, 670, 8)*10^(-3);
array_V_CE = linspace(1, 5, 100);
matrix_I_C = func_I_C(array_V_BE, array_V_CE');

MyPlot(array_V_CE, matrix_I_C');

V_B = @(I_C) (Vcc - I_C*R_1/beta) / (1 + R_1/R_2)
eq = @(I_C) I_C - I_S .* exp(  (V_B(I_C) - I_C.*R_E_all) / (n_f*V_T)  ) .* (1 + (Vcc - I_C.*R_all)/V_A)
range_I_C = linspace(0, 5e-3, 200);
stc = MyPlot_2window(range_I_C, eq(range_I_C), range_I_C, abs(eq(range_I_C)));
stc.ax1.YLim = [-1 1]; 
stc.ax1.XLim = [0 range_I_C(end)];
stc.ax2.YLim = [-1 1]; 
stc.ax2.XLim = [0 range_I_C(end)];
stc.ax2.YScale = 'log';

% dc point calculation 
I_C = fzero(eq, [0 4e-3]);
disp(['I_C = ', num2str(I_C*1000, '%.8f') ' mA'])  
I_B = I_C/beta
V_B_ = V_B(I_C)
V_C = Vcc - I_C*(R_C0 + R_C1)
V_E = I_C*R_E_all
V_BE = V_B(I_C) - V_E
V_CE = V_C - V_E


% dc point simulation
V_C = 2.74563
V_B = 1.43601
V_E = 0.793003
V_CE = V_C - V_E
V_BE = V_B - V_E

% ac gain calculation
f = 1e3;
omega = 2*pi*f;
C_in = 10e-6;
C_out = 10e-6;
C_E = 100e-6;

R_B = R_B0 + MyParallel_n([1/(1j*omega*C_in), R_1, R_2])
R_C = R_C1
R_E = R_E1 + MyParallel(R_E2, 1/(1j*omega*C_E))


r_O = V_A/I_C
g_m = I_C/(n_f*V_T)
r_pi = beta/g_m

R_base = r_pi + R_E * (beta*r_O + r_O + R_C)/(R_E + r_O + R_C)
R_in = MyParallel_n([R_1, R_2, R_base])
R_in_abs = abs(R_in)

R_coll = r_O * (  1 + (beta/(r_pi + R_B) + 1/r_O)*MyParallel(R_E, r_pi) )
R_out = MyParallel(R_C, R_coll)
R_out_abs = abs(R_out)
G_m = beta/(r_pi + R_B) / R_E * MyParallel_n([R_E, (r_pi + R_B)/(beta + 1), r_O])
A_v = -G_m*R_out
A_v_abs = -abs(A_v)

% ac gain frequency response
f = logspace(0, 6, 7*100);
omega = 2*pi*f;
C_in = 10e-6;
C_out = 10e-6;
C_E = 100e-6;

R_B = R_B0 + MyParallel_n([1./(1j*omega*C_in), R_1, R_2]);
R_C = R_C1;
R_E = R_E1 + MyParallel(R_E2, 1./(1j*omega*C_E));

r_O = V_A/I_C;
g_m = I_C/(n_f*V_T);
r_pi = beta/g_m;

R_coll = r_O * (  1 + (beta./(r_pi + R_B) + 1/r_O) .* MyParallel(R_E, r_pi) );
R_out = MyParallel(R_C, R_coll);
%G_m = beta./(r_pi + R_B) ./ R_E .* MyParallel_n([R_E, (r_pi + R_B)./(beta + 1), r_O])
tv_1 = zeros(size(R_E)) +  (r_pi + R_B)./(beta + 1);
tv_2 = zeros(size(R_E)) +  r_O;
G_m = beta./(r_pi + R_B) ./ R_E .* MyParallel_n([R_E', tv_1', tv_2']);
A_1 = -G_m.*R_out;  % 注意这里还不是实际的小信号增益, 因为没有考虑输入电阻
A_v = A_1 .* (1j*omega*C_in) .* MyParallel_n([zeros(size(omega')) + R_1, zeros(size(omega')) + R_2, 1./(1j*omega'*C_in)])
A_v_abs = abs(A_v);
A_v_dB = 20*log(A_v_abs)/log(10);
abs(A_v(1));
phase = rad2deg(angle(A_v));
%phase(phase > 90) = phase(phase > 90) - 360;

%stc = MyYYPlot([f; f], [A_v_abs; phase]);
stc.axes.XScale = 'log';
stc.label.x.String = 'Frequency $f$ (Hz)';
stc.label.y_left.String = 'Gain $A_v$ (V/V)';
stc.label.y_right.String = 'Phase $\theta$ ($^\circ$)';
stc.leg.Visible = 'off';

%stc = MyYYPlot([f; f], [A_v_dB; phase]);
stc.axes.XScale = 'log';
stc.label.x.String = 'Frequency $f$ (Hz)';
stc.label.y_left.String = 'Gain $A_v$ (dB)';
stc.label.y_right.String = 'Phase $\theta$ ($^\circ$)';
stc.leg.Visible = 'off';




% Input/Output Impedance
f = logspace(0, 6, 7*100);
omega = 2*pi*f;
C_in = 10e-6;
C_out = 10e-6;
C_E = 100e-6;

R_B = R_B0 + MyParallel_n([1./(1j*omega*C_in), R_1, R_2]);
R_C = R_C1;
R_E = R_E1 + MyParallel(R_E2, 1./(1j*omega*C_E));

r_O = V_A/I_C;
g_m = I_C/(n_f*V_T);
r_pi = beta/g_m;

R_coll = r_O * (  1 + (beta./(r_pi + R_B) + 1/r_O) .* MyParallel(R_E, r_pi) );
R_base = r_pi + R_E * (beta*r_O + r_O + R_C) / (R_E + r_O + R_C);


R_in = 1./(omega*C_in) + MyParallel(MyParallel(R_1, R_2), R_B0 + R_base);
R_in_abs = abs(R_in);

R_out = MyParallel(R_C, R_coll);
R_out_abs = abs(R_out);
%G_m = beta./(r_pi + R_B) ./ R_E .* MyParallel_n([R_E, (r_pi + R_B)./(beta + 1), r_O])
tv_1 = zeros(size(R_E)) +  (r_pi + R_B)./(beta + 1);
tv_2 = zeros(size(R_E)) +  r_O;
G_m = beta./(r_pi + R_B) ./ R_E .* MyParallel_n([R_E', tv_1', tv_2']);
A_1 = -G_m.*R_out;  % 注意这里还不是实际的小信号增益, 因为没有考虑输入电阻
A_v = A_1 .* (1j*omega*C_in) .* MyParallel_n([zeros(size(omega')) + R_1, zeros(size(omega')) + R_2, 1./(1j*omega'*C_in)])
A_v_abs = abs(A_v);
A_v_dB = 20*log(A_v_abs)/log(10);
abs(A_v(1));
phase = rad2deg(angle(A_v));
%phase(phase > 90) = phase(phase > 90) - 360;

stc = MyYYPlot([f; f], [R_in_abs; R_out_abs]);
stc.axes.XScale = 'log';
stc.label.x.String = 'Frequency $f$ (Hz)';
stc.label.y_left.String = 'Input Impedance $|Z_{in}|$ ($\Omega$)';
stc.label.y_right.String = 'Output Impedance $|Z_{out}|$ ($\Omega$)';
stc.leg.Visible = 'off';
yyaxis('left')
MyFigure_ChangeSize_2048x512


% input/output voltage range calculation
if 0
    eq = @(x) x*(R_C0 + R_C1 + R_E0 + R_E1) + n_f*V_T*log(x/I_S) - Vcc + I_C*R_E2 - 0.8
    I_C_max = fzero(eq, [1e-6 5e-3])
    %I_C_max = ( Vcc - I_C*R_E2 - V_BE ) / (R_C0 + R_C1 + R_E0 + R_E1)
    
    V_C_min = Vcc - I_C_max*1e3
    V_B_max = n_f*V_T * log(I_C/I_S) + I_C*R_E2 + I_C_max*(R_E0 + R_E1)
    (V_B_max - V_B)*1000
    %V_BE_max = log(I_C_max/I_S) * n_f*V_T
end

% v_in_max, saturation
I_C_max = (Vcc - I_C*R_E2 - 0.15) / (R_C0 + R_C1 + R_E0 + R_E1)
V_C_min = Vcc - I_C_max*(R_C0 + R_C1)
v_out_min = V_C_min - V_C
v_in_max = v_out_min/(-16)

% v_in_min, threshold
I_C_min = 0.5e-3
V_C_max = Vcc - I_C_min*(R_C0 + R_C1)
v_out_max = V_C_max - V_C
v_in_min = v_out_max/(-15.7*0.75)


% Large-Signal Gain (f = 10 KHz)
I_C = linspace(0, 4e-3, 100);

f = 10e3;
omega = 2*pi*f;
C_in = 10e-6;
C_out = 10e-6;
C_E = 100e-6;

R_B = R_B0 + MyParallel_n([1./(1j*omega*C_in), R_1, R_2]);
R_C = R_C1;
R_E = R_E1 + MyParallel(R_E2, 1./(1j*omega*C_E));

r_O = V_A./I_C;
g_m = I_C/(n_f*V_T);
r_pi = beta./g_m;

R_coll = r_O .* (  1 + (beta./(r_pi + R_B) + 1./r_O) .* MyParallel(R_E, r_pi) );
R_out = MyParallel(R_C, R_coll);
%G_m = beta./(r_pi + R_B) ./ R_E .* MyParallel_n([R_E, (r_pi + R_B)./(beta + 1), r_O])
tv_1 = (r_pi + R_B)./(beta + 1);
tv_2 = r_O;
tv_R_E = zeros(size(I_C)) + R_E;
G_m = beta./(r_pi + R_B) ./ R_E .* MyParallel_n([tv_R_E', tv_1', tv_2']);
A_1 = -G_m.*R_out;  % 注意这里还不是实际的小信号增益, 因为没有考虑输入电阻
A_v = A_1 .* (1j*omega*C_in) .* MyParallel_n([zeros(size(omega')) + R_1, zeros(size(omega')) + R_2, 1./(1j*omega'*C_in)]);
A_v_abs = abs(A_v);
A_v_dB = 20*log(A_v_abs)/log(10);
abs(A_v(1));
phase = rad2deg(angle(A_v));
%phase(phase > 90) = phase(phase > 90) - 360;

stc = MyYYPlot([I_C; I_C]*10^3, [A_v_abs; A_v_dB]);
stc.label.x.String = 'Collector Current $I_C$ (mA)';
stc.label.y_left.String = 'Gain $A_v$ (V/V)';
stc.label.y_right.String = 'Gain $A_v$ (dB)';
stc.leg.Visible = 'off';
stc.axes.YLim = [0 20];
yyaxis('right')
stc.axes.YLim = [0 30];
```
