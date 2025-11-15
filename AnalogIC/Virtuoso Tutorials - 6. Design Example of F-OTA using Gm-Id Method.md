# Design Example of F-OTA using Gm-Id Method

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 00:42 on 2025-05-26 in Beijing.


!> **<span style='color:red'>Attention:</span>**<br>
注意：本文所使用的 gm-Id 方法是错误的，这会导致对晶体管静态工作点的估计有很大偏差（仅有部分参数基本准确），详见 [Design Conclusion of the Folded-Cascode Op Amp (v1_20250605)](<Electronics/Design Conclusion of the Folded-Cascode Op Amp (v1_20250605).md>)；正确的 gm-Id 方法请见 [An Introduction to gm-Id Methodology](<AnalogIC/Virtuoso Tutorials - 5. An Introduction to gm-Id Methodology.md>)。

## 1. Design Specifications



设计一个经典的五管 OTA (F-OTA, five-transistor operational transconductance amplifier), 要求基本满足以下指标：
<div class='center'>

| Process | Current | $V_{DD}$ | $C_L$ | $A_{OL}$ | $\mathrm{GBW}_f$ | $\mathrm{SR}$ | $V_{in,CM}$ | Output Swing |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | TSMC 0.18um <br> (`tsmc18rf`) | $500 \ \mathrm{uA}$ | $1.8 \ \mathrm{V}$  | $5\ \mathrm{pF}$ | $40 \ \mathrm{dB}\ (100 \ \mathrm{V/V})$  | $50 \ \mathrm{MHz}$ | $60 \ \mathrm{V/us}$ | $1 \ \mathrm{V} \pm 0.3 \ \mathrm{V}$ | $1 \ \mathrm{V}$ |
</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-01-25-04_Design Example of F-OTA using Overdrive and Gm-Id Methods.png"/></div>




## 2. Gm-Id Design Steps


gm-Id 方法的基本设计步骤如下：
- (0) 基于经验，选择可以满足设计要求的运放架构，并推导出各个指标的理论公式 (与器件的具体模型公式无关)
- (1) 由 $\mathrm{GBW}$ (or $BW$) 确定 $g_m$,  (通常所有器件同 length)
- (2) 由 $A_v$ 和其它指标确定跨导效率 $\frac{g_m}{I_D}$ 和器件长度 $L$ (这一步需要作相当明显的 trade-off)
    - (2.1) 具体方法：作出 $g_m r_O$ 关于 $\frac{g_m}{I_D}$ 和 $L$ 的变化情况，选择合适的 $\frac{g_m}{I_D}$ 和 $L$
    - (2.2) 范围选择: 
        - strong inversion: $\frac{g_m}{I_D} \in (0,\ 10)$
        - moderate inversion: $\frac{g_m}{I_D} \in (10,\ 20)$
        - weak inversion (subthreshold region): $\frac{g_m}{I_D} \in (20,\ 30)$
    - (2.3) 较小的 $\frac{g_m}{I_D}$ (strong inversion): 
        - 更快的响应速度: $V_{OV}$ 增大使 $C_{gs}$ 减小, 从而使 $f_T \approx \frac{g_m}{2\pi C_{gs}}$ 增大
        - 更好的匹配度: 在 strong inversion, 由于 $V_{OV}$ 较大，$V_{TH}$ 的失配对电流的影响相对较小
        - 缺点：需要更高的电源电压和电流、更明显的 channel-length modulation: 在长沟道模型中 $r_O = \frac{1}{\lambda I_D} = \frac{\frac{g_m}{I_D}}{\lambda \,g_m}$
        - 适合：高速电路（优先带宽）、高精度电路（优先线性度和匹配）、高驱动能力电路（如输出级）
    - (2.4) 较大的 $\frac{g_m}{I_D}$ (weak inversion):
        - 更低的功耗: 在 $g_m$ 不变的条件下 (由 GBW 确定), 可通过降低 $I_D$ 来获得更高的 $\frac{g_m}{I_D}$, 从而降低功耗
        - 更大的摆幅: 长沟道模型中 $\frac{g_m}{I_D} = \frac{2}{V_{OV}} \propto \frac{1}{V_{OV}}$, $\frac{g_m}{I_D}$ 的升高使得 $V_{OV}$ 降低
        - 更高的增益: 在长沟道模型中，$g_m r_O = \frac{\frac{g_m}{I_D}}{\lambda}$, 因此 $\frac{g_m}{I_D}$ 的升高使得 $g_m r_O$ 增大
        - 缺点：载流子迁移率 $\mu$ 降低、寄生电容更大，导致 $f_T$ 大幅降低 (可能仅 $\mathrm{MHz}$ 量级)；匹配度也有所下降 (失配更明显)
        - 适合：低功耗电路（生物医疗）、高增益电路（优先增益）、低频电路（优先摆幅和功耗）、低电压电路（电源电压较低）
- (3) 由 $g_m$ 和 $\frac{g_m}{I_D}$ 确定 $I_D$, 由 $\frac{g_m}{I_D}$ 和 $L$ 求出电流密度 $\frac{I_D}{W}$, 由此得出 $W$
- (4) 搭建实际电路进行仿真，检查是否满足各项指标
- (5) 微调 $W$ 和 $L$ 以满足设计要求（优化性能）

从以上步骤可以看出，我们这里的 gm-Id 设计方法共有三个独立变量 $g_m$, $\frac{g_m}{I_D}$ 和 $L$。当然，也有一种思路是把第三变量 $L$ 用 $\frac{I_D}{a} = \frac{I_D}{\left(\frac{W}{L}\right)}$ 来替代，称为 normalized current; 又或者是引入 $\omega_T = \frac{g_m}{C_{gs}}$ 作为 figure of merit (例如 [this article](https://designers-guide.org/forum/Attachments/Gm_BY_ID_Methodology.pdf)).


有关 gm-Id 方法的详细介绍，请参见 [An Introduction to gm-Id Methodology](<AnalogIC/Virtuoso Tutorials - 5. An Introduction to gm-Id Methodology.md>)。


## 3. Gm-Id Design Example




### 3.0 op amp architecture


架构选择：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-01-25-04_Design Example of F-OTA using Overdrive and Gm-Id Methods.png"/></div>

理论公式推导：
<div class='center'>

| Process | Current | $V_{DD}$ | $C_L$ | $A_{OL}$ | $\mathrm{GBW}_f$ | $\mathrm{SR}$ | $V_{in,CM}$ | Output Swing |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | TSMC 0.18um <br> (`tsmc18rf`) | $500 \ \mathrm{uA}$ | $1.8 \ \mathrm{V}$  | $5\ \mathrm{pF}$ | $40 \ \mathrm{dB}\ (100 \ \mathrm{V/V})$  | $50 \ \mathrm{MHz}$ | $60 \ \mathrm{V/us}$ | $1 \ \mathrm{V} \pm 0.3 \ \mathrm{V}$ | $1 \ \mathrm{V}$ |
</div>

<div class='center'>

| $A_{OL}$ | $\mathrm{BW}\ (\omega_{\mathrm{-3dB}})$ | $\mathrm{GBW}_f$ | $\mathrm{SR}$ | $V_{in,CM}$ | Output Swing |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | $g_{m1}(r_{O2}\parallel r_{O4})$ | $\frac{1}{(r_{O2}\parallel r_{O4})C_L}$ | $\frac{g_{m1}}{2\pi C_L}$ | $\frac{I_{SS}}{C_L}$ | $\footnotesize \begin{aligned}(V_{in,CM})_{\min} &= V_{OV5} + V_{GS1,2} \\ (V_{in,CM})_{\max} &= V_{DD} - V_{OV1,2} - V_{OV3,4} \end{aligned}$ | $\small V_{DD} - V_{OV1,2} - V_{OV4} - V_{OV5}$ |
</div>

设计指标中，共模输入范围和输出摆幅的 margin 还是比较宽的，因此我们不必用 weak inversion 来设计，考虑 moderate 或 strong inversion 即可。另外，为简化分析过程，本次设计中我们不考虑噪声性能。

### 3.1 determine gm

指标要求 $\mathrm{GBW}_f > 50 \ \mathrm{MHz}$, 我们令：
$$
\begin{gather}
\mathrm{GBW}_f = \frac{g_{m1}}{2\pi C_L} = \frac{g_{m1}}{2\pi \times 5 \ \mathrm{pF}} = 60 \ \mathrm{MHz}
\Longrightarrow g_m = 1.885 \ \mathrm{mS}
\end{gather}
$$




### 3.2 choose gm/Id and L

小信号增益 $A_v = g_{m1}(r_{O2}\parallel r_{O4}) \approx \frac{1}{2} g_{m1}r_{O1}$，现在 $g_m$ 已经确定，我们选用 `tsmc18rf` 库中的 `nmos2v` 和 `pmos2v` 模型，先按下图对 NMOS 进行仿真：

``` bash
从上到下依次为:
    self gain: gm*rO
    current density: Id/W
    transient angle frequency: omega_t = gm/Cgs

waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "self_gain"))
waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "id") / 2e-06))
waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "gm") / abs(OS("/NMOS" "cgs"))))
```


<div class='center'>

| 图片 | 图片 | 
|:-:|:-:|
 | 原理图 (width 无所谓, 几乎不影响仿真结果) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-18-25-35_Design Example of F-OTA using Gm-Id Method.png"/></div> | Cadence <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-18-28-06_Design Example of F-OTA using Gm-Id Method.png"/></div> |
 | 先仿真一次 op, 然后设置好 dc sweep 和 output, 进行仿真 (记得先保存 schematic) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-18-45-43_Design Example of F-OTA using Gm-Id Method.png"/></div> | 仿真结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-18-50-36_Design Example of F-OTA using Gm-Id Method.png"/></div> |
</div>


为满足增益和电流要求，我们有限制条件：

$$
\begin{gather}
A_v \approx \frac{1}{2} g_{m1}r_{O1} > 100 \ \mathrm{V/V} \Longrightarrow g_m r_O > 200
\\
SR = \frac{I_{SS}}{C_L} = \frac{2 I_D}{C_L} > 60 \ \mathrm{V/us} \Longrightarrow I_D \in (150 \ \mathrm{uA},\ \ 250 \mathrm{uA}) \Longrightarrow \frac{g_m}{I_D} \in (7.5398,\ 12.5664)
\end{gather}
$$

不妨令 $A_v = 300,\ \frac{g_m}{I_D}$, 则同时满足 $\frac{g_m}{I_D} \in (7.55,\ 12.55)$ 和 $A_v = 300$ 的长度区间是：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-19-06-46_Design Example of F-OTA using Gm-Id Method.png"/></div>

$$
\begin{gather}
L \in (1.152 \ \mathrm{um},\ 1.395 \ \mathrm{um})
\end{gather}
$$

我们取 $L_{1,2} = 1.152 \ \mathrm{um}$ 和 $\left(\frac{g_m}{I_D}\right)_{1,2} = 11$, 即图中的蓝线。



### 3.3 determine Id and W

$$
\begin{gather}
\frac{g_m}{I_D} = 11 \Longrightarrow I_D = \frac{g_m}{11} = 171.36 \ \mathrm{uA}
\end{gather}
$$

依据给定的 $L$ 和 $\frac{g_m}{I_D}$, 查找此时的电流密度 $\frac{I_D}{W}$，计算 $W$:

$$
\begin{gather}
\frac{I_D}{W} = 4.152 \Longrightarrow W_{1,2} = 41.27 \ \mathrm{um},\quad  a_{1,2} = \left(\frac{W}{L}\right)_{1,2} = \frac{41.27 \ \mathrm{um}}{1.152 \ \mathrm{um}} = 35.826
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-19-12-13_Design Example of F-OTA using Gm-Id Method.png"/></div>

### 3.4 determine PMOS 

上面我们只求解了两个 NMOS 输入管的尺寸，还需要求解 PMOS 和 tail NMOS. 它们的求解思路为：
- PMOS load: 
    - $I_D$ 已经确定 (由 input NMOS 给出)
    - 由 $g_m r_O$ 确定 $\frac{g_m}{I_D}$ 和 $L$, 例如 $\left(\frac{g_m}{I_D}\right)_{3,4} = \left(\frac{g_m}{I_D}\right)_{1,2}$ 或者 $L_{3,4} = L_{1,2}$, 进而确定 $g_m$ 和 $W$ ($\frac{g_m}{I_D}$ 应与 input NMOS 接近, 可以稍小一些)
- tail NMOS: 
    - $I_D$ 已经确定 (由 input NMOS 给出)
    - 选择较高的 $\frac{g_m}{I_D}$ 以降低 $V_{OV}$ (提高输入输出范围), 选择较大的 $L$ 以提高共模抑制比 (比如 $L_5 = 1.3 L_{1,2}$)


先对 PMOS 进行仿真：

``` bash
waveVsWave(?x OS("/PMOS" "gmoverid") ?y OS("/PMOS" "self_gain"))
waveVsWave(?x OS("/PMOS" "gmoverid") ?y (OS("/PMOS" "id") / -2e-06))
waveVsWave(?x OS("/PMOS" "gmoverid") ?y (OS("/PMOS" "gm") / abs(OS("/PMOS" "cgs"))))
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-26-23-37-58_Design Example of F-OTA using Gm-Id Method.png"/></div>

简单起见，我们这里直接令 $L_{3,4} = L_{1,2} = 1.152 \ \mathrm{um}$, 选择更低的 $\frac{g_m}{I_D} = 7$ 以缩短 PMOS 的 width, 此时的 $g_m r_O$ 和 $W$ 为：

$$
\begin{gather}
\begin{cases}
\frac{g_m}{I_D} = 7 \ \mathrm{S/A}\\ 
L_{3,4} = 1.152 \ \mathrm{um}
\end{cases} 
\Longrightarrow g_m r_O = 208.4,\quad \frac{I_D}{W} = 1.729
\\
\Longrightarrow a_{3,4} = \left(\frac{W}{L}\right)_{3,4} = \frac{99.1091 \ \mathrm{um}}{1.152 \ \mathrm{um}} = 86.0322
\end{gather}
$$


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-00-19-19_Design Example of F-OTA using Gm-Id Method.png"/></div>



### 3.5 determine tail NMOS

- tail current source M5 和电流镜 M6 求解思路 (M5 = M6): 
    - $I_D$ 已经确定 (由 input NMOS 给出)
    - 选择较高的 $\frac{g_m}{I_D}$ 以降低 $V_{OV}$ (提高输入输出范围), 选择较大的 $L$ 以提高共模抑制比 (比如 $L_5 = 1.3 L_{1,2}$)

我们令：

$$
\begin{gather}
\begin{cases}
L_{5,6} = 1.557 \ \mathrm{um} \approx 1.35 L_{1,2} \\
\left(\frac{g_m}{I_D}\right)_{5,6} = 15
\end{cases}
\Longrightarrow g_m r_O = 409.7 \mathrm{(unconcerned)},\quad \frac{I_D}{W} = 1.19
\\
\Longrightarrow a_{5,6} = \left(\frac{W}{L}\right)_{5,6} = \frac{287.9993 \ \mathrm{um}}{1.557 \ \mathrm{um}} = 184.9707
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-00-31-15_Design Example of F-OTA using Gm-Id Method.png"/></div>

### 3.6 summary and adjustment

各管子参数汇总如下：

<div class='center'>

| parameter | M1, M2 | M3, M4 | M5, M6 |
|:-:|:-:|:-:|:-:|
 | current $I_D$                            | 171.3596 uA | 171.3596 uA | 342.7192 uA |
 | current efficiency $\frac{g_m}{I_D}$     | 11.0 | 7.0 | 15.0 |
 | current density $\frac{I_D}{W}$          | 4.152 | 1.729 | 1.19 |
 | self gain $g_mr_O$                       | 300 | 208.4 | 409.7 |
 | aspect ratio $a$                         | 35.826 | 86.032 | 184.97 |
 | device size $\left(\frac{W}{L}\right)$   | $\frac{41.27 \ \mathrm{um}}{1.152 \ \mathrm{um}}$ | $\frac{99.1091 \ \mathrm{um}}{1.152 \ \mathrm{um}}$ | $\frac{287.9993 \ \mathrm{um}}{1.557 \ \mathrm{um}}$ |
</div>

不妨作一些微调，使得尺寸更合理：

<div class='center'>

| parameter | M1, M2 | M3, M4 | M5, M6 | Iref |
|:-:|:-:|:-:|:-:|:-:|
 | device size $\left(\frac{W}{L}\right)$   | $\frac{42 \ \mathrm{um}}{1.15 \ \mathrm{um}}$ | $\frac{100 \ \mathrm{um}}{1.15 \ \mathrm{um}}$ | $\frac{288 \ \mathrm{um}}{1.56 \ \mathrm{um}}$ | 342.7 uA |
</div>

**<span style='color:red'> 注：实际的电路中, 用于生成 biasing 的 M6 应具有较小的电流, 在 I_ref 的基础上, 通过 multiplication 获得正常的 Iss.</span>** 比如实际中常选用 M5 : M6 = 10, 也就是 M6:M5 = 1/10, 简便起见，我们这里直接用 M5 = M6 了。


结合仿真结果的理论计算过程借助了 MATLAB 进行，具体源码如下：

``` matlab
20250526 F-OTA 设计
% 0. design goals
C_L = 5e-12;
GBW_obj = 60e6;
SR_obj = 60e6;
VDD = 1.8;
I_suplly = 500e-6;
Av_obj = 300;

% 1. gm
GBW_f = @(g_m1) g_m1 / (2*pi*C_L) - GBW_obj;
g_m1 = fzero(GBW_f, [0 1]);
disp(['Step.1    g_m1 = ', num2str(g_m1*10^3), ' mS'])

% 2. (gm/Id)_M1_M2, L (gm*rO)_M1_M2
Id_min = 0.5*SR_obj*C_L
Id_max = 0.5*I_suplly

gmId_max = g_m1/Id_min
gmId_min = g_m1/Id_max

self_gain_N = Av_obj;
gm_Id = 11;
L_M1_M2 = 1.152e-6;
Id_W = 4.152;

% 3. Id, W_M1_M2

Id = g_m1/gm_Id;
W_M1_M2 = Id/Id_W;
a_M1_M2 = W_M1_M2/L_M1_M2;
disp(['Id = ', num2str(Id*10^6), ' uA'])
disp(['(W/L)_M1_M2 = ', num2str(W_M1_M2*10^6), ' um / ', num2str(L_M1_M2*10^6), ' um'])
disp(['a_M1_M2 = ', num2str(a_M1_M2)])

% 4. PMOS (M3, M4)

L_M3_M4 = L_M1_M2;
Id_W = 1.729;
W_M3_M4 = Id/Id_W;
a_M3_M4 = W_M3_M4/L_M3_M4;
disp(['Id = ', num2str(Id*10^6), ' uA'])
disp(['(W/L)_M3_M4 = ', num2str(W_M3_M4*10^6), ' um / ', num2str(L_M3_M4*10^6), ' um'])
disp(['a_M3_M4 = ', num2str(a_M3_M4)])

% 5. NMOS (M5, M6)

Id_M5_M6 = 2*Id
L_M5_M6 = 1.557e-6
Id_W = 1.19;
W_M5_M6 = Id_M5_M6/Id_W;
a_M5_M6 = W_M5_M6/L_M5_M6;
disp(['Id_M5_M6 = ', num2str(Id_M5_M6*10^6), ' uA'])
disp(['(W/L)_M3_M4 = ', num2str(W_M5_M6*10^6), ' um / ', num2str(L_M5_M6*10^6), ' um'])
disp(['a_M3_M4 = ', num2str(a_M5_M6)])
```


## 4. simulation test


### 4.1 dc operating point

下面，我们就来搭建电路，稍后还需要创建 OTA 的 symbol 用于后续仿真。先搭建电路，检查 dc 工作点是否正常：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-00-52-41_Design Example of F-OTA using Gm-Id Method.png"/></div>
 -->


<div class='center'>

| Schematic | DC Operation Point |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-01-08-51_Design Example of F-OTA using Gm-Id Method.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-01-07-44_Design Example of F-OTA using Gm-Id Method.png"/></div> |
</div>

### 4.2 dc in-out curve

在开始进一步的仿真之前，我们需要先创建电路的 symbol, 具体步骤为：在 schematic 界面，点击 `create > create cellview > from cellview`，无需改名，直接创建即可 (这里创建的是 symbol, 它会和 schematic 在同一 cellview 下) 

为了方便以后调用, 我们把原电路中的 `vdd`, `gnd`, `Vin1` 和 `Vin2` 等节点也替换为 Pins, 如图：

<div class='center'>

| schematic | dc operating point | symbol |
|:-:|:-:|:-:|
 | 在 Stimuli 中设置各 Pin 的仿真值 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-02-00-22_Design Example of F-OTA using Gm-Id Method.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-12-39-56_Design Example of F-OTA using Gm-Id Method.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-02-03-11_Design Example of F-OTA using Gm-Id Method.png"/></div> |
</div>


运行仿真，得到 dc sweep 静态输入输出曲线如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-12-37-08_Design Example of F-OTA using Gm-Id Method.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-12-34-54_Design Example of F-OTA using Gm-Id Method.png"/></div>

<!-- 
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-12-24-30_Design Example of F-OTA using Gm-Id Method.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-12-20-18_Design Example of F-OTA using Gm-Id Method.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-01-18-45_Design Example of F-OTA using Gm-Id Method.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-12-18-04_Design Example of F-OTA using Gm-Id Method.png"/></div>
-->

上面我们是在 $V_{in,CM} = 0.9 \ \mathrm{V}$ 时进行的仿真，观察到 $V_{out}|_{V_{in,CM} = 0} = 1.106 \ \mathrm{V} \ne 0.9 \ \mathrm{V}$，可以理解为差模输入有一定的 offset $V_{OS}$, 如果需要让 $V_{in,DM} = 0$ 时的输出电压恰好为 $\frac{VDD}{2} = 0.9 \ \mathrm{V}$，可以通过降低 PMOS 管的 $\frac{g_m}{I_D}$ 来实现，这会使 $V_{OV}$ 增大, 从而降低 $V_{out}|_{V_{in,CM} = 0}$.

### 4.3 input-output range

如图，设置 Vin_DM 为第一变量, Vin_CM 为第二变量，得到不同共模输入下的 in-out curve:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-12-53-57_Design Example of F-OTA using Gm-Id Method.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-13-01-39_Design Example of F-OTA using Gm-Id Method.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-13-04-11_Design Example of F-OTA using Gm-Id Method.png"/></div>

<!-- 
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-12-53-13_Design Example of F-OTA using Gm-Id Method.png"/></div>
 -->


由图可以大致确定输入共模的上下边界：
$$
\begin{gather}
(V_{in,CM})_{\min} \in (0.3,\ 0.6 \ \mathrm{V}),\quad (V_{in,CM})_{\max} \in (1.5\ \mathrm{V},\ 1.8 \ \mathrm{V})
\end{gather}
$$

也就是至少满足了 $(0.6 \ \mathrm{V},\ \ 1.5\ \mathrm{V})$ 的共模输入范围，符合设计要求。

另一种更合理也更实用的共模输入范围仿真方法是查看各晶体管的 region, 这需要我们回到原 schematic 进行仿真。设置 $V_{in,DM} = 0$, dc sweep $V_{in,CM}$, 观察各管子的 region, 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-13-24-25_Design Example of F-OTA using Gm-Id Method.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-13-25-42_Design Example of F-OTA using Gm-Id Method.png"/></div>

由此得到的共模输入范围是：

$$
\begin{gather}
V_{in,CM} \in (0.718 \ \mathrm{V},\ \ 1.538 \ \mathrm{V}),\quad \Delta V_{in,CM} = 0.82 \ \mathrm{V}
\end{gather}
$$

基本符合设计要求的 $V_{in,CM} = 1 \ \mathrm{V} \pm 0.3 \ \mathrm{V}$.

对于 output swing, 参考 $V_{in,CM} = 0.9 \ \mathrm{V}$ 的曲线，我们有 $\mathrm{output\ swing} \approx 1.6 - 0.43 = 1.17 \ \mathrm{V}$, 在设计要求的 $V_{in,CM} = 1 \ \mathrm{V}$ 时则有：

$$
\begin{gather}
\mathrm{output\ swing} \approx 1.07 \ \mathrm{V}
\end{gather}
$$

**事实上，像这样一个 output range 受 input 限制的 stage, 我们通常不会对电路的 output swing 提过多的要求，而是直接在其后加上轨到轨的输出级以获得 rail-to-rail output** (e.g., a CMOS inverter)。不过，某些实际应用中确实固定了 Vin_CM, 且 stage 数非常紧张 (比如只能有一级), 这时可能会对 output swing 有较高的要求。


### 4.4 frequency response

下面就来仿真开环增益的频响曲线，评估其增益带宽积是否达到设计指标。用负反馈建立直流工作点，以获得更真实的频响曲线：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-16-43-24_Design Example of F-OTA using Gm-Id Method.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-16-43-37_Design Example of F-OTA using Gm-Id Method.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-22-21-52_Design Example of F-OTA using Gm-Id Method.png"/></div>


$$
\begin{gather}
A_{v0} = 139.1 \ \mathrm{V/V} = 42.87 \ \mathrm{dB},\quad f_c = 421.3 \ \mathrm{kHz},\quad \mathrm{GBW} = 54.87 \ \mathrm{MHz}
\end{gather}
$$

### 4.5 slew rate SR

设置 pulse 激励时上升/下降沿的时间不能为零，为零会报错，无法进行仿真，不妨设为 1ps.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-16-55-22_Design Example of F-OTA using Gm-Id Method.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-27-16-58-00_Design Example of F-OTA using Gm-Id Method.png"/></div>

$$
\begin{gather}
\mathrm{SR_+} = + 63.16 \ \mathrm{V/us},\ \ \mathrm{SR_-} = - 54.55 \ \mathrm{V/us}
\end{gather}
$$

下降沿出现指数衰减的原因见文章 [The Cause of the Exponential Decay in the F-OTA's Output Waveform During Slew Rate Simulation](<Electronics/The Cause of the Exponential Decay in the F-OTA's Output Waveform During Slew Rate Simulation.md>).

### 4.6 step response

将 vout 和 vin- 短接，设置输入信号为 0.8 V ~ 1.0 V 的 step signal, 考察运放的 (small-signal) step response, 看看相位和增益裕度是不是“真的”, 并且计算运放的 settling time 和 overshoot:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-15-27-42_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>


``` bash
setting time @ 0.05% (rising) = cross(vout value(vout, 450n)*(1 + 0.05*0.01) 1 "falling" nil nil  nil ) - 200n
setting time @ 0.05% (falling) = cross(vout value(vout, 900n)*(1 - 0.05*0.01) 1 "rising" nil nil  nil ) - 700n
overshoot (%) (rising) = (ymax(vout)/value(vout, 450n) - 1)*100
overshoot (%) (falling) = (ymin(vout)/value(vout, 900n) - 1)*100
```




### 4.7 slew rate

SR 是 large-signal 下的非线性行为，将输入信号改为幅度较大的 step signal, 运行仿真，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-15-10-54_OpAmp__oneStage_single_folded-cascode__80dB_50MHz_50Vus.png"/></div>





## 5. Design Conclusion

下面是设计指标与仿真结果的对比：
<div class='center'>

| Parameter | Current | Open-Loop Gain| GBW | Slew Rate | CM input | Output Swing |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Design Goals | $500 \ \mathrm{uA}$ | $40 \ \mathrm{dB}\ (100 \ \mathrm{V/V})$  | $50 \ \mathrm{MHz}$ | $60 \ \mathrm{V/us}$ | $(0.7 \ \mathrm{V},\ 1.3 \ \mathrm{V})$ | $1 \ \mathrm{V}$ |
 | Simulation Results | $342.7 \ \mathrm{uA}$ | $42.9 \ \mathrm{dB}\ (139 \ \mathrm{V/V})$  | $54.9 \ \mathrm{MHz}$ | $+ 63.16 \ \mathrm{V/us}\\ - 54.55 \ \mathrm{V/us}$  | $(0.72 \ \mathrm{V},\ 1.54\ \mathrm{V})$ | $1.07 \ \mathrm{V}$ |
</div>

GBW 原本是按 60MHz 设计的，但由于我们使用的 transistor 已经算非常大了 (width 和 length 都比较高), 受寄生电容的影响, GBW 稍有下降。另外，上面的 current consumption 并没有考虑 biasing current, 考虑 1:10 的 bias 后总 current 约为 377.0 uA 。


这篇文章的主要目的有二，其一是借助一个简单的设计例子，学习 gm-Id 设计方法的流程和思路；其二便是进一步熟悉 cadence 的使用，尤其是如何利用 SKILL 语言修改设置、快速执行某些操作等，这对日后在 cadence 中进行更复杂的设计是非常有帮助的。总的来讲，本次设计在 design idea 上并没有花多少时间，时间主要消耗在了 cadence 的探索、配置文件的修改优化和 SKILL 语言的基本使用上，最终为文章 [How to Use Cadence Efficiently](<AnalogIC/Use Virtuoso Efficiently - 0. How to Use Cadence Virtuoso Efficiently.md>) 贡献了相当多的内容。


<!-- ### 5.1  simul.

下面两张图中左侧的那些参数无用，不用在意 (其实是仿其它运放时忘换 symbol, 不小心仿 F-OTA 了)。
 -->


## References

参考资料：
- [Analog Design Using gm/Id and ft Metrics](https://people.eecs.berkeley.edu/~boser/presentations/2011-12%20OTA%20gm%20Id.pdf)
- [Stanford University: Chapter 5 gm/ID-Based Design](https://www.wangke007.com/wp-content/uploads/2024/01/ee214b_gmid.pdf)
- [Design of MOS Amplifiers Using gm/ID Methodology]()
- [GitHub > bmurmann > Book-on-gm-ID-design](https://github.com/bmurmann/Book-on-gm-ID-design/tree/main)
- [Paper: A gm/Id based Methodology for the Design of CMOS Analog Circuits and Its Application to the Synthesis of a Silicon-on-Insulator Micropower OTA](https://people.engr.tamu.edu/spalermo/ecen474/gm_ID_methodology_silveira_jssc_1996.pdf)
- [Systematic Design of Analog Circuits Using Pre-Computed Lookup Tables](https://www.ieeetoronto.ca/wp-content/uploads/2020/06/20160226toronto_sscs.pdf)
- [知乎 > 基于 gm/Id 的运放设计:单端输出的两级运放设计](https://zhuanlan.zhihu.com/p/18217441114)
- [知乎 > 两级运放设计过程总结-Allen](https://zhuanlan.zhihu.com/p/631329993)
- [知乎 > 基于 gm/Id 法的五管 OTA 的设计](https://zhuanlan.zhihu.com/p/621225975)
- [知乎 > 5-T OTA 的设计与仿真](https://zhuanlan.zhihu.com/p/467542830)

