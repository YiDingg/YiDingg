# WaveForms Insight

## 

## Impedance

### Formula inversion

Formula inversion: 
$$
\begin{gather}
由\ V_1\ 和\ V_2\ 得到\ V_{DUT}\ 和 \ V_{Res}
\\
I_{DUT} = I_{Res} = \frac{V_{Res}}{R}
\\
\mathrm{InputGain} = \frac{V_{DUT}}{V_{Res}}\ \ {\color{red} \mathrm{(unit:\ dB)}}
\\
\begin{cases}
\mathrm{InputPhase} = \varphi_{V_{Res}} = \angle V_{Res} = \angle I_{Res}\ \ {\color{red} \mathrm{(unit:\ deg)}}\ \ \mathrm{(with\ respect\ to\ W1\ or\ W2)} 
\\
\mathrm{OutputPhase} = \varphi_{V_{DUT}}= \angle V_{DUT}\ \ {\color{red} \mathrm{(unit:\ deg)}}
\\
\mathrm{Phase} = \theta = \varphi_{out} - \varphi_{in} = \angle V_{DUT} - \angle V_{Res}\ \ {\color{red} \mathrm{(unit:\ deg)}}\ \ (官方文档上写错了)
\\
注：V_{DUT} 或 V_{Res} 幅值过小时，其相位值不准确，接近随机值 (而不是恒为 0)
\end{cases}
\end{gather}
$$

### Coding Tips

**Condition 1: `W1-C1-R-C2-DUT-GND`**

``` WaveForms
Condition 1: W1-C1-DUT-C2-R-GND


```

**Condition 2: `W1-C1-R-C2-DUT-GND`**

``` WaveForms
Condition 2: W1-C1-R-C2-DUT-GND

待确定 V_1 = V_Res + V_DUT = IRMS*Resistor *sqrt(2) + VRMS*sqrt(2)
作图时直接加上的是绝对值, 不含相位信息, 因此不能在此模式下简单加减得到 V1
待确定 V_1 = sqrt( pow(IRMS*Resistor*sqrt(2)*sin(InputPhase) + VRMS*sqrt(2)*sin(Phase+InputPhase), 2) ) + sqrt( pow(IRMS*Resistor*sqrt(2)*cos(InputPhase) + VRMS*sqrt(2)*cos(Phase+InputPhase), 2) )
V_2 = V_DUT = VRMS*sqrt(2)
```

**Condition 3: `W1-C1P-DUT-C1N-C2-R-GND`**

``` WaveForms
Condition 3: W1-C1P-DUT-C1N-C2-R-GND

V_1 = V_DUT = VRMS*sqrt(2)
V_2 = IRMS*Resistor *sqrt(2)
```

