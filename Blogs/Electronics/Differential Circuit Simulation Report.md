# Basic Differential Circuit Simulation Report

> [!Note|style:callout|label:Infor]
Initially published at 23:45 on 2025-03-25 in Beijing.

## Intro

### Infor

- Time: 2025-03-25
- Location: Beijing
- Author: Yi Ding

In this simulation experiment, we will simulate a basic differential circuit (using BJT). The circuit is shown below:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-25-23-47-23_Differential Circuit Simulation Report.png"/></div>

We use LTspice and the transistor BC847C (NPN) in LTspice for the simulation.


## Static Chara Simulation

Below is the static characteristic simulation result of BC847C (NPN).

High-current situation:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-00-11-26_Differential Circuit Simulation Report.png"/></div>

Low-current situation:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-00-59-24_Differential Circuit Simulation Report.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-00-03-05_Differential Circuit Simulation Report.png"/></div>
 -->

## Extracting SPICE Model Parameters


Below is the SPICE model of BC847C in LTspice:
``` SPICE
.model bc847c npn(is=2.375e-14 nf=0.9925 ise=5.16e-16 ne=1.3 bf=524.9 ikf=0.09 vaf=49.77 nr=0.9931 isc=7.064e-12 nc=1.78 br=10.04 ikr=0.132 var=16 rb=10 irb=5.00e-06 rbm=5 re=0.653 rc=0.78 xtb=0 eg=1.11 xti=3 cje=1.132e-11 vje=0.7685 mje=0.3733 tf=4.258e-10 xtf=6.319 vtf=6.4 itf=0.1845 ptf=0 cjc=3.379e-12 vjc=0.5444 mjc=0.3968 xcjc=0.6193 tr=0.000000095 cjs=0 vjs=0.75 mjs=0.333 fc=0.999 vceo=45 icrating=100m mfg=nxp)

% or rewrite it to improve readability
.model bc847c npn(
 is=2.375e-14 nf=0.9925 ise=5.16e-16 ne=1.3 bf=524.9 ikf=0.09 vaf=49.77
 nr=0.9931 isc=7.064e-12 nc=1.78 br=10.04 ikr=0.132 var=16 rb=10 irb=5.00e-06
 rbm=5 re=0.653 rc=0.78 xtb=0 eg=1.11 xti=3 cje=1.132e-11 vje=0.7685 mje=0.3733
 tf=4.258e-10 xtf=6.319 vtf=6.4 itf=0.1845 ptf=0 cjc=3.379e-12 vjc=0.5444 
 mjc=0.3968 xcjc=0.6193 tr=0.000000095 cjs=0 vjs=0.75 mjs=0.333 fc=0.999 
 vceo=45 icrating=100m mfg=nxp
)
```

We extract a few parameters that we've learned so far. They are:

``` matlab
is=2.375e-14    % I_S, transport saturation current
nf=0.9925       % nf*V_T, forward mode ideality factor
bf=524.9        % ideal maximum forward beta
vaf=49.77       % V_A, forward early voltage
rb=10           % R_B0, base resistance
irb=5.00e-06    % the base current where R_B0 drops by 50 percent
rbm=5           % R_B0_min, the minimum base resistance in high base current situation
re=0.653        % R_E0, emitter resistance
rc=0.78         % R_C0, collector resistance
```

Therefore, we have:

$$
\begin{gather}
n_f = 0.9925,\ 
\beta = 524.9,\ 
V_A = 49.77 \ \mathrm{V},\ 
R_{B0} = 10 \ \Omega
\\
I_{RB} = 5.00 \  \mu\mathrm{A},\ 
R_{B0,min} = 5 \ \Omega,\ 
R_{E0} = 0.653 \ \Omega,\ 
R_{C0} = 0.78 \ \Omega
\end{gather}
$$



In the following theoretical calculation, we use $R_{B} = \frac{1}{2}\left(R_{B0} + R_{B0_{min}}\right) = 7.5 \ \Omega$, because our base current is about $2 \ \mathrm{\mu A} \sim 5 \ \mathrm{\mu A}$ (we have seen this in the preceding simulation).


<!-- 
.model bc847c npn(
ise=5.16e-16 
ne=1.3 
ikf=0.09 
 nr=0.9931 
 isc=7.064e-12 
 nc=1.78 
 br=10.04 
 ikr=0.132 
 var=16 
 xtb=0 
 eg=1.11 
 xti=3 
 cje=1.132e-11 
 vje=0.7685 
 mje=0.3733
 tf=4.258e-10 
 xtf=6.319 
 vtf=6.4 
 itf=0.1845 
 ptf=0 
 cjc=3.379e-12 
 vjc=0.5444 
 mjc=0.3968 
 xcjc=0.6193 
 tr=0.000000095 
 cjs=0 
 vjs=0.75 
 mjs=0.333 
 fc=0.999 
 vceo=45 
 icrating=100m 
 mfg=nxp
)
-->



## Theoretical Calculation

We first calculate the required small-signal parameters:
$$
\begin{gather}
R_B = 7.5 \ \mathrm{\Omega},\
R_E = 0.653 \ \Omega
\\
R_C = 0.78 \ \Omega + 5.1 \ \mathrm{k\Omega} = 5100.78 \ \Omega
\\
g_m = \frac{I_C}{n_fV_T} = \frac{I_{EE}}{2 n_fV_T} = 38.8 \ \mathrm{mS}
\\
r_{\pi} = \frac{\beta}{g_m} = \frac{2 \beta \, n_fV_T}{I_{EE}} = 13.545 \ \mathrm{k\Omega}
\\
r_{o} = \frac{V_A}{I_C} = \frac{2 V_A}{I_{EE}} = 49.770 \ \mathrm{k\Omega}
\end{gather}
$$

Assuming $v_{in,DM}$ is small enough so that the "half-circuit" can be used. Note that $g_{m} = \frac{I_C}{n_fV_T}$, we have:

$$
\begin{gather}
R_{out} = R_C \parallel R_{coll},\quad 
R_{coll} = r_O \cdot \left[ 1 + \left( \frac{\beta}{r_{\pi} + R_B} + \frac{1}{r_O} \right) \left(R_E \parallel (r_{\pi} + R_B)\right) \right]
\\
\Longrightarrow R_{coll} = 51.092 \ \mathrm{k\Omega},\quad 
R_{out} = 4.6373 \ \mathrm{k\Omega}
\\
G_m = \frac{\beta}{r_{\pi} + R_B} \cdot \frac{R_E \parallel \frac{r_{\pi} + R_B}{\beta + 1} \parallel r_O}{R_E} = 37.8 \ \mathrm{mS}
\end{gather}
$$

Therefore, the DM voltage gain is given by:

$$
\begin{gather}
A_{DM} = - G_m R_{out} = -175.1633 = 44.8689 \ \mathrm{dB}
\end{gather}
$$

And the DM output resistance is given by:

$$
\begin{gather}
R_{out,DM} = 2 R_{out} =  9.2745 \ \mathrm{k\Omega}
\end{gather}
$$

## Transient Simulation

To obtain better voltage gain and phase margin performance, we use a cascode current structure as the tail current source. The circuit is shown below:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-01-52-43_Differential Circuit Simulation Report.png"/></div>

Before the transient simulation, we conduct a dc operation point simulation to ensure the circuit is properly biased.
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-01-30-20_Differential Circuit Simulation Report.png"/></div>

Then, set the input DM voltage to be 1mV (1kHz, 0V offset) with 0V CM level, and run the transient simulation. Here are the results:
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-01-40-25_Differential Circuit Simulation Report.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-01-41-15_Differential Circuit Simulation Report.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-01-43-08_Differential Circuit Simulation Report.png"/></div>

Noticing that the amplitude of $v_A$ is about 3uV, which is very minimal so that $v_A$ can be seen as an ac-ground. 

Another interesting fact is that $v_A$ has twice the frequency of $v_{in,DM}$ (also $v_{out,DM}$), as shown below:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-01-50-46_Differential Circuit Simulation Report.png"/></div>

This is because the circuit is ideally symmetric and the variation of $v_{A}$ has the same frequency as $|v_{in,DM}|$, i.e., twice the frequency of $v_{in,DM}$.


## Open-Loop Gain A_DM

Now, we use the ac sweep to obtain the open-loop gain $A_{DM}$ and its bode plot. 

In most single-ended amplifier situations, to achieve this kind of simulation with higher accuracy, we are expected to set the dc point via negative feedback, and add the ac input signal to the circuit. In this case, how do we isolate the dc operation point and the ac input signal? An extremely large capacitor and induction play the role. 

However, in the differential circuit below, we can directly add the ac input signal to the circuit without any isolation or negative feedback. Here are the results:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-02-05-51_Differential Circuit Simulation Report.png"/></div>

The simulation results give that:
$$
\begin{gather}
A_{DM} = 44.7787 \ \mathrm{dB}
,\quad 
\mathrm{GB} = 21.01 \ \mathrm{MHz}
,\quad 
\mathrm{GBW} = 1.868 \ \mathrm{GHz}
,\quad 
\mathrm{PM} = 3.83^{\,\circ}
\end{gather}
$$

Recall that the theoretical calculation gives $A_{DM} = 44.8689 \ \mathrm{dB}$, which is very close to the simulation result. 




## Output Resistance R_out

Using the SPICE command `.step` and `.meas` flexibly do significantly improve the simulation efficiency. For instance, if we would like to know the $A_{DM}$ curve with different load resistance, here is an example: `run simulation > view SPICE output log`

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-02-33-14_Differential Circuit Simulation Report.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-02-29-35_Differential Circuit Simulation Report.png"/></div>
 -->

To obtain the output resistance $R_{out}$, we set $R_{L}$ to be `.step dec param R_L 100 1Meg 20`, and use the `.meas` command to measure the output voltage gain.
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-17-03-49_Differential Circuit Simulation Report.png"/></div>



Export the data and perform the calculation in MATLAB:

``` matlab
% Step  A_eq  (dB)
     1	5.28967
     2	6.27844
     3	7.26585
     4	8.25175
     5	9.23596
     6	10.2183
     7	11.1985
     8	12.1763
     9	13.1515
    10	14.1238
    11	15.0927
    12	16.058
    13	17.0193
    14	17.976
    15	18.9277
    16	19.8739
    17	20.8138
    18	21.7469
    19	22.6725
    20	23.5897
    21	24.4978
    22	25.3958
    23	26.2827
    24	27.1576
    25	28.0193
    26	28.8668
    27	29.6987
    28	30.514
    29	31.3112
    30	32.0893
    31	32.8468
    32	33.5825
    33	34.2953
    34	34.9839
    35	35.6474
    36	36.2846
    37	36.8949
    38	37.4775
    39	38.0318
    40	38.5576
    41	39.0546
    42	39.5229
    43	39.9627
    44	40.3743
    45	40.7584
    46	41.1156
    47	41.4469
    48	41.7531
    49	42.0355
    50	42.2951
    51	42.5333
    52	42.7512
    53	42.9501
    54	43.1313
    55	43.296
    56	43.4455
    57	43.581
    58	43.7035
    59	43.8142
    60	43.914
    61	44.004
    62	44.0849
    63	44.1578
    64	44.2232
    65	44.2819
    66	44.3346
    67	44.3818
    68	44.4241
    69	44.4619
    70	44.4958
    71	44.5261
    72	44.5532
    73	44.5775
    74	44.5991
    75	44.6185
    76	44.6357
    77	44.6512
    78	44.6649
    79	44.6772
    80	44.6882
    81	44.698
```

$$
\begin{gather}
A_{DM,eq} = \frac{R_L}{R_L + R_{out}} \cdot A_{DM} 
,\quad 
10^{\frac{(A_{DM,eq})_{dB}}{20}} = \frac{R_L}{R_L + R_{out}} \cdot 10^{\frac{(A_{DM})_{dB}}{20}}
\\
\Longrightarrow 
R_{out} = R_L \cdot 
\left(10^{\frac{(A_{DM})_{dB} - (A_{DM,eq})_{dB}}{20}} - 1\right),\quad 
A_{DM,dB} = 44.7787 \ \mathrm{dB}
\end{gather}
$$

Then we obtain:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-17-27-45_Differential Circuit Simulation Report.png"/></div>

and the mean value of simulated $R_{out}$ is:
$$
\begin{gather}
R_{out,simu} = 9.3294 \ \mathrm{k\Omega},\quad R_{out,theo} = 9.2745\ \mathrm{k\Omega},\quad 
\eta = \frac{R_{out,simu} - R_{out,theo}}{R_{out,theo}} = 0.59168\,\%
\end{gather}
$$

## Simple Forward Compensation

To achieve better frequency response performance, we add a forward compensation capacitor $C_{f}$ to the circuit. This method significantly improves the phase margin, while sacrificing BW and GBW. 

Setting $C_f$ to be 0, 1pF, 10pF and 100pF, the simulation results are shown below:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-17-44-17_Differential Circuit Simulation Report.png"/></div>

At $C_f = 10 \ \mathrm{pF}$, simulation gives that:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-26-17-48-48_Differential Circuit Simulation Report.png"/></div>

$$
\begin{align}
C_f &= 0:&&
\mathrm{BW} = 21.01 \ \mathrm{MHz},\quad \mathrm{GBW} = 1.868 \ \mathrm{GHz},\quad \mathrm{PM} = 3.83^{\,\circ}
\\
C_f &= 10 \ \mathrm{pF}:&&
\mathrm{BW} = 2.976 \ \mathrm{MHz},\quad 
\mathrm{GBW} = 331.85 \ \mathrm{MHz},\quad \mathrm{PM} = 93.7^{\,\circ}
\end{align}
$$
There is an improvement in phase margin, but the BW and GBW is significantly reduced.

