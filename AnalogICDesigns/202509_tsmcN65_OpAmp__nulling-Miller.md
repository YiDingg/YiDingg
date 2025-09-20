# 202509_tsmcN65_OpAmp__nulling-Miller

> [!Note|style:callout|label:Infor]
> Initially published at 23:11 on 2025-09-09 in Lincang.


## Introduction

本文是项目 [2025.09 Design of A Basic Low Dropout Regulator (LDO)](<Projects/Design of A Basic Low Dropout Regulator (LDO) for BB-PLL.md>) 的附属文档，用于记录 LDO 内部运放的设计和前仿过程。

本文，我们借助 [gm-Id](<AnalogIC/Virtuoso Tutorials - 5. An Introduction to gm-Id Methodology.md>) 方法，使用台积电 65nm CMOS 工艺库 `tsmcN65` 来完整地设计一个 **basic two-stage op amp with nulling-Miller compensation**，**<span style='color:red'> 并完成前仿、版图、验证和后仿工作。 </span>** 

## 1. Design Considerations

### 1.1 op amp specs

我们已经在 [这篇文章](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (1).md>) 中给出了运放的设计指标：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-12-23-56-26_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>


<div class='center'>
<span style='font-size:12px'> 


| Type | DC Gain | GBW | PM | Slew Rate | Input CM | Output Swing | Power Dissipation | Corner |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Specifications | 60 dB | 600 MHz @ 0.5 pF | 65° | - | 0.6 V | - | 300 uA ~ 500 uA | all-corner |

</span>
</div>

具体而言，我们以下列参数为初始目标：

$$
\begin{gather}
g_{m1} > 650 \ \mathrm{uS},\quad g_{m6} > 5.0 \ \mathrm{mS}
\\
C_c = \frac{1}{3}C_L = \frac{1}{3} \times 0.5 \ \mathrm{pF} = 0.167 \ \mathrm{pF}
\\
V_{in,CM} = 0.6 \ \mathrm{V},\quad A_{v,DC} > 60 \ \mathrm{dB}
\end{gather}
$$

<span style='color:red'> 本次设计基本无需关注功耗，可以适当增加电流已获得更好的 opamp/LDO 性能，但要注意输出噪声需尽量小。 </span>

### 1.2 dc gain consideration

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-02-22-10_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

## 2. Design Details

注意运放中的 NMOS/PMOS 需分别使用 `nch_25_dnw` 和 `pch_25`，我们已经在这篇文章 [Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library)](<AnalogICDesigns/Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).md>) 中给出了 `nch_25_dnw` 和 `pch_25` 的 gm/Id 数据，后续就直接使用即可：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-12-23-32-36_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>


### 2.0 gm/Id considerations

此次运放设计需要较高的 gm, 因此对于 M1/M2 和 M6 来讲，不同于以往 "先给定支路电流和 gm/Id 再确定 length" 的做法，对于这几个晶体管，这次我们先根据所需 gm 选择合适的 (a, L, gm/Id)，再由此计算出电流，必要时可调整 length 的值。

至于其它晶体管，仍然采用老办法，给定预期 gm/Id 值如下：

<div class='center'>

| MOS | (p) M3, M4 | (n) M5 | (n) M7 |
|:-:|:-:|:-:|:-:|
 | gm/Id        | 13 | 11 | 11 |
</div>


下面就来详细确定每一对晶体管的尺寸，**<span style='color:red'> 若无特别说明，均默认取 vds = 300 mV 的 gm/Id 仿真结果。 </span>**

### 2.1 (n) M1 ~ M2

如图，不妨取 (a, gm/Id) = (40, 13) 来满足 gm1 > 650 uS 的要求：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-02-16-44_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

gm/Id = 13 时, nch_25_dnw 的 I_nor = 1.445 uA @ 0.42 um 和 1.312 uA @ 2.10 um. 

$$
\begin{gather}
I_{nor} \approx 1.4 \ \mathrm{uA} \Longrightarrow I_{D1,2} = a \times I_{nor} = 40 \times 1.4 \ \mathrm{uA} = 56 \ \mathrm{uA},\quad I_{SS1} = 2 I_{D1,2} = 112 \ \mathrm{uA}
\end{gather}
$$

先看看增益情况再选择长度：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-02-26-47_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

不妨选择 length = 0.84 um, 则 M1 ~ M2 的预期参数为：


$$
\begin{gather}
\left(\frac{g_m}{I_D}\right)_{1,2} = 13 \ \mathrm{S/A},\quad a_{1,2} = \left(\frac{W}{L}\right)_{1,2} = 40 = \frac{33.6 \ \mathrm{um}}{0.84 \ \mathrm{um}} = \frac{10 \times 3.36 \ \mathrm{um}}{0.84 \ \mathrm{um}}
\\
I_{D1,2} = \frac{I_{SS1}}{2} = 56 \ \mathrm{uA},\quad g_{m1,2} = 668 \ \mathrm{uS}
\\
finger = 10,\quad area = 3.36 \ \mathrm{um} \times (10 \times 0.84 \ \mathrm{um}) = 3.36 \ \mathrm{um} \times 8.4 \ \mathrm{um}
\end{gather}
$$

### 2.2 (p) M6

如图，可取 (a, L, gm/Id) = (500, 0.70 um, 9) 来满足 gm6 > 5 mS 的要求：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-00-29-17_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

gm/Id = 9 时, pch_25 的 I_nor = 1.223 uA @ 0.56 um 和 0.956 uA @ 2.10 um, 由于我们的 0.70 um 接近 0.56 um, 不妨取 I_nor = 1.15 uA, 则所需电流为：

$$
\begin{gather}
I_{SS2} = I_{D6} = a \times I_{nor} = 500 \times 1.15 \ \mathrm{uA} = 575 \ \mathrm{uA}
\end{gather}
$$

综上, M6 的预期参数为：

$$
\begin{gather}
\left(\frac{g_m}{I_D}\right)_6 = 9 \ \mathrm{S/A},\quad a_6 = \left(\frac{W}{L}\right)_6 = 500 = \frac{350 \ \mathrm{um}}{0.70 \ \mathrm{um}} = \frac{40 \times 8.75 \ \mathrm{um}}{0.70 \ \mathrm{um}}
\\
I_{SS2} = I_{D6} = 575 \ \mathrm{uA},\quad g_{m6} = 5.138 \ \mathrm{mS}
\\
finger = 40 ,\quad area = 8.75 \ \mathrm{um} \times (40 \times 0.70 \ \mathrm{um}) = 8.75 \ \mathrm{um} \times 28 \ \mathrm{um}
\end{gather}
$$


### 2.3 (p) M3 ~ M4, (n) M5, M7

剩余晶体管的长宽比如下：

<div class='center'>

| MOS | (p) M3, M4 | (n) M5 | (n) M7 |
|:-:|:-:|:-:|:-:|
 | gm/Id        | 13 | 11 | 11 |
 | I_nor_range  | 0.356u ~ 0.528u | 2.090u ~ 2.223u | 2.090u ~ 2.223u |
 | I_nor_approx | 0.45u | 2.15u | 2.15u |
 | I_D          | 56u | 112u | 575u |
 | a = I_D/I_nor | 124.4 | 52.1 | 267.4 |
 | a_regulated   | 125 | 50 | 270 |
</div>

然后将它们的 length 设为 variable, 通过仿真来选择合适的 length.

### 2.4 biasing circuit

Biasing circuit 采用普通 current mirror. 由于 ISS1 = 112 uA 和 ISS2 = 575 uA, 考虑使用 IBIAS = 55 uA 且 a_Mb = 0.5 * a_5, 这样 ISS1 ≈ 2 × IBIAS, ISS2 ≈ 10 × IBIAS.

### 2.5 RC compensation

$$
\begin{gather}
C_c = \frac{1}{3}C_L = \frac{1}{3} \times 0.5 \ \mathrm{pF} = 0.167 \ \mathrm{pF}
\\
R_z = \left(1 + \frac{1}{\alpha}\right)\frac{1}{g_{m6}} \approx \frac{4}{g_{m6}} = \frac{4}{5.138 \ \mathrm{mS}} = 778.5 \ \Omega
\end{gather}
$$

## 3. Using PMOS-Input

**<span style='color:red'> 上面犯了一个严重的错误是：要保证运放在 Vin_CM = 0.6 V 的情况下具有较高的 GBW, 不能使用 nmos-input 而应使用 pmos-input, 否则 GBW 会因第一级电流不足而严重下降。 </span>** 以往我们都是以 dc gain 作为 Vin_CM 的衡量标准，从而忽略了这一点。但这次的 LDO 更关注的是 PSRR, 因此必须保证运放的 GBW 足够高。

下面重新设计晶体管，整体思路不变。

### 3.1 (p) M1 ~ M2

对 pch_25, 如图，取 (a, L, gm/Id) = (160, 900 nm, 14) 来满足 gm1 > 650 uS 的要求：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-11-50-55_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

此时 gm1 ≈ 750 uS, 然后计算 pch_25 所需电流：

$$
\begin{gather}
I_{nor} \approx 0.35 \ \mathrm{uA} \Longrightarrow I_{D1,2} = a \times I_{nor} = 160 \times 0.35 \ \mathrm{uA} = 56 \ \mathrm{uA}
\\
I_{SS1} = 2 I_{D1,2} = 112 \ \mathrm{uA}
\end{gather}
$$

综上, M1 ~ M2 的预期参数为：

$$
\begin{gather}
\left(\frac{g_m}{I_D}\right)_{1,2} = 14 \ \mathrm{S/A},\quad a_{1,2} = \left(\frac{W}{L}\right)_{1,2} = 160 = \frac{144 \ \mathrm{um}}{0.9 \ \mathrm{um}} = \frac{40 \times 3.6 \ \mathrm{um}}{0.9 \ \mathrm{um}}
\\
I_{D1,2} = \frac{I_{SS1}}{2} = 56 \ \mathrm{uA},\quad
g_{m1,2} = 750 \ \mathrm{uS}
\end{gather}
$$


### 3.2 (n) M6

如图，为保持一定增益，取 (a, L, gm/Id) = (300, 0.70 um, 13) 来满足 gm6 > 5 mS 的要求 (此参数约 5.2 mS)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-12-00-09_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

则 M6 的预期参数为：

$$
\begin{gather}
I_{nor} \approx 1.4 \ \mathrm{uA} \Longrightarrow I_{D6} = a \times I_{nor} = 300 \times 1.4 \ \mathrm{uA} = 420 \ \mathrm{uA}
\\
\left(\frac{g_m}{I_D}\right)_{6} = 13 \ \mathrm{S/A},\quad a_6 = \left(\frac{W}{L}\right)_6 = 300 = \frac{210 \ \mathrm{um}}{0.7 \ \mathrm{um}} = \frac{60 \times 3.5 \ \mathrm{um}}{0.7 \ \mathrm{um}}
\\
I_{D6} = I_{SS2} = 420 \ \mathrm{uA},\quad g_{m6} = 5.20 \ \mathrm{mS}
\end{gather}
$$

### 3.3 (n) M3 ~ M4, (p) M5, M7

剩余晶体管的长宽比如下：

<div class='center'>

| MOS | (n) M3, M4 | (p) M5 | (p) M7 |
|:-:|:-:|:-:|:-:|
 | gm/Id        | 13 | 11 | 11 |
 | I_nor_approx | 1.4u | 0.7u | 0.7u |
 | I_D          | 56u | 112u | 420u |
 | a = I_D/I_nor | 40 | 160 | 600 |
 | a_regulated   | 40 | 160 | 600 |
</div>

## 4. Design Iteration

设置 Vin_CM = 0.6 V, C_L = 0.5 pF 进行仿真，一个比较正常的初始参数是 600 fF + 700 Ohm:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-20-48_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

此时 LDO 的 PSRR 情况为：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-14-18_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-13-41_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

Pass transistor 的初始值不足以驱动 15 mA 也没关系，我们后续增加尺寸即可 (但要注意面积消耗)。

现在就以运放的 ac frequency response 和 LDO 的 PSRR 作为主要优化目标进行迭代。



### 4.1 (200uA, 300f, 1k)

事实上，我们并不需要很高的 PM, 可以适当降低 Cc 来提升运放 GBW (牺牲一定的 PM)，从而提升 LDO 的 PSRR_GBW. 将 PM 的 spec 修改为 > 45°, 运放在 100uA/200 uA biasing 下的频响如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-21-58_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-22-38_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

看一下 (200uA, 300fF, 1kOhm) 的 PSRR 情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-29-59_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

为什么 PMOS PT 的 PSRR_GBW 有明显提升，但是 NMOS PT 的 PSRR_GBW 却基本不变？

### 4.2 (200uA, 400f, 500)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-36-57_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

### 4.3 Cc and Rz iteration

下面设定 ILOAD = 500 uA, 观察 PSRR 随 Cc 和 Rz 的变化情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-45-11_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-44-24_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-47-35_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

图中可以看出, PMOS PT 具有更好的 PSRR 性能，且最佳参数在 Cc = 300 fF ~ 500 fF 之间，不妨做更精细的扫描：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-51-13_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-52-34_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

最佳参数出现在 Cc = 425 fF, 再根据 200 uA 下运放的频响情况选择 Rz:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-55-33_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

显然， Rz = 700 Ohm 时性能最好。


**综上，我们最终得到最佳参数为 PMOS PT + (200 uA, 425 fF, 700 Ohm)** ，此时运放和 LDO 的性能为：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-55-33_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-14-59-10_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-19-53-21_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

或者 PMOS PT + (150 uA, 425 fF, 700 Ohm)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-19-54-21_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>

### 4.4 design summary

后续有关 pass transistor, bypass capacitor 等设计迭代详见 [202509_tsmcN65_LDO__in-1d8-to-2d5_out-1d0](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (1).md>) 的 **3. Design of LDO** 一节。

## 5. Pre-Simulation

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-13-40-01_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-23-29-21_202509_tsmcN65_OpAmp__nulling-Miller.png"/></div>
