# WaveForms Insight

> [!Note|style:callout|label:Infor]
> Initially published at 14:59 on 2025-05-09 in Beijing.


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
\mathrm{Phase} = \theta\  (计算公式仍未知,\ 官方文档中给出的是\ \varphi_{in} - \varphi_{out},\ 但是经过考察并不是这样)
\\
\mathrm{(\mathrm{mode\ 3})\ 实际\ Input\ Phase} =  \varphi_{CH1} - \varphi_{CH2}\ \ \ {\color{red} \mathrm{(unit:\ deg)}}\\
\mathrm{在\ mode\ 3\ 且\ CH1\ 为输入,\ CH2\ 为输出时,\ -\ input\ phase\ 即为频率响应中的相位}
\\
注：V_{DUT}\ 或\ V_{Res}\ 幅值过小时，其相位值不准确，接近随机值\ (而不是恒为\ 0)
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
V_2 = IRMS*Resistor*sqrt(2)
phase = phase_Vout - phase_Vin = angle
```

