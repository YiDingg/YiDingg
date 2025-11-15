# 202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 23:31 on 2025-09-16 in Beijing.

**<span style='color:red'> 注：本次设计的迭代/前仿篇幅过长，故而分为了 (1) (2) 上下两个部分，以保证较好的阅读体验： </span>**
- [前文: 202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (1)](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (1).md>)
- [本文: 202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2)](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).md>)


## 10. NMOS Pass Design (v4)

NMOS as the pass transistor 的频率响应详见文章 [Stability Analysis and Loop Compensation Mechanism of Capacitor-less LDO](<AnalogIC/LDO Stability Analysis and Loop Compensation Mechanism.md>).

在 gate 极点 $-\frac{1}{R_{out1}C_{eq}}$ 较高的情况下，上述结构一定是稳定的，因为 GBW_LDO 仅为 GBW_opamp 的一半，而 op amp 具有较高的 PM.

需要注意的是 NMOS pass 时 VREF 应该接在运放正端。并且 nch_na25 作为功率管时，高输出电流下的导通是关键点，因为 $V_{GS,\max} = 1.7 - 1.2 = 0.5 \ \mathrm{V}$ 很小，必须保证 nch_na25 有足够的开通能力来提供 15 mA 电流。


为探究 NMOS pass 的性能，我们以下面各参数为初始值进行仿真：
- L = 360 nm
- LN_PT = 1.4 um (minimum 1.2 um), AN_PT = 600, FN_PT = 30
- (R1, C1) = (7.0 kOhm, 250 fF)
- (Cc1, Rc1, Cc2, Rc2) = (0, 0, 0, 0) (暂不使用补偿网络)
- (IBIAS, Cc, Rz) = (150 uA, 325 fF, 5.0 kOhm)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-12-41-44_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

此时 (ILOAD, Cc) = (10 uA, 325 fF) 的频率响应为：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-12-43-55_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

pole2 和 pole3 中的一个其实就是运放 $\omega_{p2}$，可通过调整 (Rz, Cc) 来显著改善 (几乎不影响 PSRR)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-12-49-46_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

于是参数变为 
- L = 360 nm
- LN_PT = 1.4 um (minimum 1.2 um), AN_PT = 600, FN_PT = 30
- (R1, C1) = (7.0 kOhm, 250 fF)
- (Cc1, Rc1, Cc2, Rc2) = (0, 0, 0, 0) (暂不使用补偿网络)
- (IBIAS, **Cc, Rz**) = (150 uA, **425 fF, 0.7 kOhm**)


然后调整 R1 来提升 PSRR_5MHz:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-12-57-40_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

根据 10 mA 下的 PSRR 结果，**R1 = 1.0 kOhm** 似乎是个不错的选择：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-13-01-35_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-13-01-53_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

高输出电流下 PSRR 下降是因为 op amp 输出电压过高，导致 op amp 工作状态发生变化，可通过提高 AN_PT 来改善：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-13-03-56_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

由上图选择 **AN_PT = 700**，此时的全部参数值为：

- L = 360 nm
- LN_PT = 1.4 um (minimum 1.2 um), **AN_PT = 700, FN_PT = 35**
- (**R1**, C1) = (**1.0 kOhm**, 250 fF)
- (Cc1, Rc1, Cc2, Rc2) = (0, 0, 0, 0) (不使用补偿网络)
- (IBIAS, **Cc, Rz**) = (150 uA, **425 fF, 0.7 kOhm**)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-13-10-13_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-13-11-39_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

不妨极端一点，选择 AN_PT = 1000 看看 15 mA 下的 PSRR 能否过全工艺角：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-13-14-09_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-13-14-31_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

拿 (TT65, ILOAD = 10 uA) 下的频率响应看看：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-13-19-54_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

以及此参数在不同负载电容下的稳定性：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-13-25-28_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-13-27-20_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>


上面几张图片都说明 AN_PT = 1000 时性能似乎好得不可思议，那么这个面积是否可行呢？我们来算一下。取 finger = 40, 所占面积为 (40*L) \* (25\*L) = 56um * 35um, 好像确实是可以接受的，毕竟我们没有加任何补偿网络，也就没有那些很占面积的大电容。

上面都忘记看 C1 对性能的影响了，这里补一下 (设置 CLOAD = 5 pF):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-00-30-43_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

由图知道 C1 对稳定性和 PSRR peaking 有略微影响，但区别不大，不妨就选择 C1 = 0, 将面积让给 VREF 和 VOUT 的滤波电容。此时的参数和性能如下：

- L = 360 nm
- LN_PT = 1.4 um (minimum 1.2 um), **AN_PT = 1000, FN_PT = 50**
- **(R1, C1)** = **(1.0 kOhm, 0)**
- (Cc1, Rc1, Cc2, Rc2) = (0, 0, 0, 0) (不使用补偿网络)
- (IBIAS, **Cc, Rz**) = (150 uA, **425 fF, 0.7 kOhm**)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-00-34-04_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

## 11. Pre-Simulation (v4_160015)



### 11.0 schematic preview

生成 schematic 时注意，由于单个 nch_na25 的 max totalW = 900 um, 而我们需要的是 1.4um * 1400 um 的管子，因此得拆分为两个 (各 700 um)。此时 nch_na25 管子的参数为：

- L * totalW = 1.4um * 1400um
- totalW = multiplier * finger * fingerW = 2 * 35 * 20um

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-00-51-28_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 11.1 (tran) start-up

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-01-08-53_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-01-11-51_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-01-14-46_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 11.2 (ac) stability
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-00-56-59_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-01-04-42_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-01-07-23_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-01-07-56_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>


### 11.3 (ac) all C_L stability



### 11.4 (ac) PSRR

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-00-53-34_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-00-53-20_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-01-03-02_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 11.5 (tran) step response

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-02-00-40_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-02-09-02_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-02-02-40_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-02-08-36_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 11.6 (noise) output noise

设置好 outputs 后运行 noise 仿真，得到各工艺角下的输出噪声：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-23-39-53_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-23-37-31_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

### 11.7 (sm) simul. summary


设置 **ILOAD = 10 mA, CLOAD = 10.0 pF** 进行全工艺角仿真 (VDD = 1.7 V)，与张钊老师提供的参考电路 `LDO_3.3_to_1.3_Low_Noise` 在相同条件下 (VDD = 3.3 V) 的仿真结果作对比，红色表示更优：
<div class='center'>

| Parameter | This Work | Reference |
|:-:|:-:|:-:|
 | PM | 33.44° ~ 60.50° | <span style='color:red'> 80.8° ~ 82.62° </span> |
 | GM | 6.079 dB ~ 8.636 dB | <span style='color:red'> 42.55 dB ~ 46.09 dB </span> |
 | PSRR @ DC    | <span style='color:red'> -58.83 dB ~ -83.42 dB </span> | -60.79 dB ~ -63.94 dB |
 | PSRR @ 5 MHz | <span style='color:red'> -49.12 dB ~ -64.11 dB </span> | -38.44 dB ~ -40.51 dB |
 | Output Noise @ 1 MHz | <span style='color:red'> 14.65 nV/sqrt(Hz) ~ 21.24 nV/sqrt(Hz) </span> | 38.71 nV/sqrt(Hz) ~ 44.48 nV/sqrt(Hz) |
 | Integrated Noise (100 Hz ~ 1 MHz) | <span style='color:red'> 32.13 uVrms ~ 39.38 uVrms </span> | 50.25 uVrms ~ 68.55 uVrms |
</div>


## 12. Design Iteration (v5)

从 **11.7 (sm) pre-simul summary** 一节的表格可以看出，相比于老师提供的参考电路 (实际流片验证过)，我们的电路在稳定性上稍有不足，为此，我们考虑在负载端引入一个补偿网络 $(R_{c1} + C_{c1})$，将补偿网络带来的零点放在 $\mathrm_{GBW_{LDO}}$ 附近以提升 PM 和 GM. 

顺便给出参考电路在不同负载电容下的稳定性，为我们的迭代目标提供参考：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-00-04-08_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>


具体的理论推导见文章 [Stability Analysis and Loop Compensation Mechanism of Capacitor-less LDO](<AnalogIC/LDO Stability Analysis and Loop Compensation Mechanism.md>)，这里不多赘述，直接给出希望得到的补偿效果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-16-23-51-59_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

呃，**设置 CLOAD = 20.0 pF 进行仿真**，发现这个补偿网络几乎没有效果，这就有点尴尬了：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-00-10-43_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-00-11-26_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

我们又依次尝试了 C1, (Rc2, Cc2), 均没有明显改善 PM 和 GM. 那么就只能修改运放内部的补偿网络 (Rz, Cc) 了：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-00-21-20_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

随着 Cc 增大, LDO 的 PSRR 竟然变得更好？这与我们先前的分析/仿真矛盾啊。细看一下 PSRR 曲线：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-00-22-43_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

不行，这着实有些诡异，我们进一步仿真看看：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-00-28-00_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

选择 (Cc, Rz) = (2.5 pF, 500 Ohm) 看看这结果在全工艺下是不是 "真的"：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-00-31-47_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-00-33-06_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

还真是可行的？？？以 (Cc, Rz) = (2.5 pF, 500 Ohm) 为中心，进一步微调 (ILOAD = 10 uA)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-00-41-21_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

我们仅有这一个电容，因此多占一点面积也无妨，所以也扫描 Cc = 3.0 pF ~ 5.0 pF 看看效果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-00-42-57_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

图中看出，当 Cc >= 4.5 pF 时，PSRR_5MHz 开始下降，因此我们仅考虑 Cc <= 4.0 pF 的情况。综合考虑 area/PM/GM/PSRR 后，我们最终选择 **(Cc, Rz) = (2.5 pF, 500 Ohm)**。此时整个电路的全部参数为：
- L = 360 nm
- LN_PT = 1.4 um, AN_PT = 1000
- (R1, C1) = (1.0 kOhm, 0)
- (Cc1, Rc1, Cc2, Rc2) = (0, 0, 0, 0) (不使用补偿网络)
- (IBIAS, **Cc, Rz**) = (150 uA, **2.5 pF, 500 Ohm**)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-00-52-58_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>


搭建非 variable 电路仿真一下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-04-55_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-05-15_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-04-10_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

关于提高 $C_c$ 使稳定性变好的原因，我们的解释如下：
- 两级米勒运放的零极点 $p_1 \approx - \frac{g_{m1}}{A_{v0}C_c},\ p_2 \approx - \frac{g_{m6}}{C_{L2}},\ p_3 \approx - \frac{1}{R_{z}C_c}\left(1 + \frac{C_c}{C_{L1}} + \frac{C_c}{C_{L2}}\right),\ z = - \frac{g_{m6}}{(g_{m6}R_z - 1)C_c}$
- 当 $C_c$ 升高而 $R_c C_c$ 几乎不变时，所有极点中仅有 $p_1$ 向低频移动，这使得 GBW_LDO 降低，提高稳定性牺牲了一定的 PSRR_5MHz (PSRR_DC 不变)
- 另外，当 $R_z$ 过高时，零点 $z$ 也向低频移动，一但低于 GBW_LDO 太多反而会降低 PM 和 GM, 因此出现 "随 Rz 增大，PM/GM 先增后减" 的现象

看来并不是玄学，背后还是有理论依据的，只是我们一时间没转过弯来。

## 13. Pre-Simulation (v5_170053)

**<span style='color:red'> 若无特别说明，均设置 CLOAD = 10 pF 进行仿真。 </span>**

### 13.0 schematic preview



### 13.1 (tran) start-up

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-41-57_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-42-55_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-45-42_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

### 13.2 (ac) stability

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-29-11_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-34-48_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-37-00_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

### 13.3 (ac) all C_L stability

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-04-10_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>


### 13.4 (ac) PSRR

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-28-57_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-37-55_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-38-48_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>


### 13.5 (tran) step response



### 13.6 (noise) output noise

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-31-25_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-40-08_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-41-30_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

### 13.7 (ac) opamp transfer

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-22-09_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-22-26_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-01-25-21_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

### 13.8 (sm) simul. summary

下表总结了 **ILOAD = 10 mA, CLOAD = 10 pF** 条件下的全工艺角仿真结果 (VDD = 1.7 V)，与张钊老师提供的参考电路 `LDO_3.3_to_1.3_Low_Noise` 在相同条件下 (VDD = 3.3 V) 的结果作对比，红色表示更优：
<div class='center'>

| Parameter | This Work | Reference |
|:-:|:-:|:-:|
 | PM | <span style='color:red'> 84.36° ~ 96.53° </span> | 80.8° ~ 82.62° |
 | GM | 16.13 dB ~ 22.61 dB | <span style='color:red'> 42.55 dB ~ 46.09 dB </span> |
 | PSRR @ DC    | <span style='color:red'> -58.83 dB ~ -83.42 dB </span> | -60.79 dB ~ -63.94 dB |
 | PSRR @ 5 MHz | <span style='color:red'> -38.88 dB ~ 47.66 dB </span> | -38.44 dB ~ -40.51 dB |
 | Output Noise @ 1 MHz | <span style='color:red'> 14.64 nV/sqrt(Hz) ~ 21.21 nV/sqrt(Hz) </span> | 38.71 nV/sqrt(Hz) ~ 44.48 nV/sqrt(Hz) |
 | Integrated Noise (100 Hz ~ 1 MHz) | <span style='color:red'> 32.13 uVrms ~ 39.37 uVrms </span> | 50.25 uVrms ~ 68.55 uVrms |
 | Maximum Load Capacitance | 470 pF @ PM = 45° | <span style='color:red'> 5.0 nF @ PM = 45° </span> |
</div>

## 13. Design Iteration

老师这边改要求了，输入参考电压从 0.6 V 改为 0.8 V (输出电压 1.2 V 不变)，因此我们需要重新调整 LDO 的反馈电阻。下面设置 $R_2 = 2 R_1$，在 **CLOAD = 20 pF** 条件下进行仿真 (ILOAD = 10 uA for stability, 10 mA for PSRR)。先找出合适的 R1 值，再稍微调整运放的补偿参数 (Cc, Rz) 以提升 PM 和 GM.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-11-10-57_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-11-10-25_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-11-12-20_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

R1/R2 比值减小时，PSRR_DC 有非常明显的恶化，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-11-22-51_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>


但是按我们之前的理论分析， NMOS pass 时 $\mathrm{PSRR} = \frac{1 + \frac{R_1}{R_2}}{g_{m1}r_{O1}A(s)}$，PSRR 应该变好才对，为什么会变差呢？看下图的仿真后，我们认为是运放 Vin_CM = VREF (Vmirror) 的升高导致输入级尾电流源工作状态变差，影响了运放的直流增益，从而影响了 PSRR_DC:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-11-29-29_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>


为验证这一观点，只需修改 VDD = 2.65 V 进行仿真，结果与我们的推论基本一致：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-11-34-03_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

如何避免 PSRR_DC @ VDD = 1.7 V 的显著恶化？从上图取 R1 = 400 Ohm, R2 = 800 Ohm, 调整 M3 管子的 a = W/L 试一下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-11-45-19_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-11-42-48_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>


并没有明显改善作用，因此不考虑调整 a3 这个参数。仿真 VDD = 1.5 V ~ 1.8 V, 看看电源电压为多少是，PSRR_DC 可以 "回归正常"：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-12-02-06_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-12-08-10_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-12-06-57_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-12-13-26_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-12-12-16_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

果然，是因为 VDD 较低时 M3 进入线性区导致的，并且 VDD = 1.78 V 左右才能回归正常，实在是不太好。为解决这个问题，我们需要降低 M1/M2 在低压下的 Vgs, 这等价于：

$$
\begin{gather}
V_{GS} \downarrow, \ \ 
\frac{g_m}{I_D} \uparrow, \ \ 
I_{nor} \downarrow \Longrightarrow 
I_{bias} \downarrow \ \mathrm{or} \  a = \frac{W}{L} \uparrow
\end{gather}
$$

我们考虑同时增加 M1/M2/5 的 a = W/L (它们原先都是 40*4 = 160)，经过几次尝试，最终选择 **a1 = a5 = 320**。这虽然导致 LDO 的稳定性稍有降低，但是无妨，我们可以再次调整运放的补偿参数 (Cc, Rz) 稍微提升一下，并且只要最大负载电容能保持在 200 pF 以上就是完全够用的。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-12-38-33_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-12-38-41_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-12-41-47_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

先列出迭代之前 (R1, Cc, Rz) = (700 Ohm, 3.0 pF, 500 Ohm) 的仿真结果，再给出 (v5_170053) 版图所占面积，作为参考 (spec 要求 150um*200um)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-12-44-59_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-12-54-03_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

版图可以看出仍有一定的空间冗余，因此可以将 Cc 适当增大一些 (<= 5.0 pF) 以获得更好的稳定性。现在先调整 R1 再调整 (Cc, Rz)，仿真时设置 **CLOAD = 20 pF, ILOAD = 15 mA**:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-13-02-41_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

R1 升高时，PSRR_DC 基本不变，PSRR_5MHz 稍有提升，不妨选择 R1 = 1 kOhm (R2 = 2 kOhm)，然后调整 (Cc, Rz):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-13-10-54_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-13-13-40_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

最终选择 (Cc, Rz) = (3.5 pF, 450 Ohm), 此时 LDO 的全部参数为：
- L = 360 nm
- LN_PT = 1.4 um, AN_PT = 1000
- (**R1, R2**, C1) = (**1.0 kOhm, 2.0 kOhm**, 0)
- (Cc1, Rc1, Cc2, Rc2) = (0, 0, 0, 0) (不使用补偿网络)
- (IBIAS, **Cc, Rz**) = (150 uA, **3.5 pF, 450 Ohm**)
- **(a1, a5) = (320, 320)**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-13-16-35_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

PSRR_DC 之所以有这么大的跨度，是因为我们把 M1/M2 和 M5 的 gm/Id 放在很高，不同工艺角下的失配较大。但各个工艺角下的性能都很好地满足指标要求，因此不再调整。毕竟我们也不可能降低其 gm/Id, 否则又回到最开始的问题，归根结底还是 VREF = 0.8 V 实在不好，对 VDD = 1.7 V 来说，向下 0.8 V 向上 0.9 V, 无论是 pmos-input 还是 nmos-input 都没有明显优势。

## 14. Pre-Simulation (v6_171321)



### 14.0 schematic preview

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-13-27-10_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-13-27-42_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>


### 14.1 (ac) stability

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-14-16-58_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-14-17-31_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-14-22-28_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

### 14.2 (ac) all C_L stability


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-14-47-37_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-14-47-05_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-15-04-40_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

### 14.3 (ac/ns) PSRR/Noise

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-14-15-45_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-14-16-35_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-14-19-50_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

### 14.4 (tran) start-up

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-16-22-03_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-16-26-41_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2 (2).png"/></div>

### 14.5 (tran) step response
### 14.6 (ac) opamp transfer
### 14.7 (sm) simul. summary

下表总结了 v6_171321 的全工艺角仿真结果 (ILOLAD = 15 mA, CLOAD = 20 pF)，与张钊老师提供的参考电路 `LDO_3.3_to_1.3_Low_Noise` 的结果作对比 (ILOAD = 10 mA, CLOAD = 10 pF)，红色表示更优：


<div class='center'>

| Parameter | This Work | Reference |
|:-:|:-:|:-:|
 | PM | <span style='color:red'> 76.90° ~ 93.26° </span> | 80.8° ~ 82.62° |
 | GM | 15.15 dB ~ 17.85 dB | <span style='color:red'> 42.55 dB ~ 46.09 dB </span> |
 | PSRR Peaking | -2.305 dB ~ -4.585 dB <br> (-12.62 dB ~ -20.82 dB @ ILOAD = 10 uA) | -23.23 dB ~ -23.88 dB |
 | PSRR @ DC    | <span style='color:red'> -52.24 dB ~ -84.37 dB </span> | -60.79 dB ~ -63.94 dB |
 | PSRR @ 5 MHz | <span style='color:red'> -44.79 dB ~ -55.79 dB </span> | -38.44 dB ~ -40.51 dB |
 | Output Noise @ 1 MHz | <span style='color:red'> 9.993 nV/sqrt(Hz) ~ 14.73 nV/sqrt(Hz) </span> | 38.71 nV/sqrt(Hz) ~ 44.48 nV/sqrt(Hz) |
 | Integrated Noise (100 Hz ~ 1 MHz) | <span style='color:red'> 20.35 uVrms ~ 25.03 uVrms </span> | 50.25 uVrms ~ 68.55 uVrms |
 | Maximum Load Cap | 460 pF @ PM = 45° | <span style='color:red'> 5.0 nF @ PM = 45° </span> |
</div>

<!-- 
### 14.0 schematic preview
### 14.1 (tran) start-up
### 14.2 (ac) stability
### 14.3 (ac) all C_L stability
### 14.4 (ac) PSRR
### 14.5 (tran) step response
### 14.6 (noise) output noise
### 14.7 (ac) opamp transfer
### 14.8 (sm) pre-simul summary
-->

<!-- ## 12. Layout (v4_160015)


- VREF 输入处需要加电容，因为由 BGR 给出的 VREF 本身就有输出阻抗和噪声，需要加电容进行滤波
- 输出端需要加电容，起到滤波/稳定作用 (尽管会牺牲一定的 PM), 但是对输出噪声有明显改善 -->

## 15. Layout (v6_171321)

Layout 工作不直接用 v6_171321 的 schematic 进行，而是新建一个 cell view 命名为 `202509_LDO_basic_in1d7to2d65_out1d2__v6_171321_layout`，因为我们要基于 v6_171321 的 schematic 做一些小小的修改：
- (1) 将所有电容 (mim cap) 更换为 mom cap (单位容值稍小，但是高频特性极好)
- (2) 在 VREF 输入端加一个电容 (CREF)，起到滤波/去耦/降噪的作用，因为 VREF 是由其它组的 BGR 提供，我们不太清楚其输出噪声如何
- (3) 在 OUT 输出端加一个电容 (COUT)，起到滤波/稳定的作用，尽管会牺牲一定的 PM, 但通常对输出噪声/纹波有一定改善作用
- (4) 将 IBIAS 输入端管子的 multiplier 修改一下，使得接口处输入 100 uA 时，实际 IBIAS = 150 uA, 这可以通过 (m1, m2) = (2, 3) 来实现
- 注：(2) (3) 两条提到的电容均为 mom cap, 并且其具体容值暂时还不清楚，需要先生成 layout 后看看剩余面积如何，再决定容值大小；我们优先把面积给 CREF，因为 COUT 可以于最后集成阶段在 LDO 四周添加 (空余面积都可以利用)

修改后的结果，以及 Layout 等后续过程见文章 [202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout](<AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.md>).

