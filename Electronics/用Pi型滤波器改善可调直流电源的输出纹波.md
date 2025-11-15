# 用 Pi 型滤波器改善可调直流电源的输出纹波

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 20:32 on 2025-01-03 in Beijing.

最近在某宝上买了一个可调直流电源 (3.6V ~ 12.1V, 3A max)，但是发现输出的电压纹波较大，不足以满足我常规的实验需求，于是决定用 Pi 型滤波器来改善输出的纹波。

## 输出波形及纹波

下面分别测量电源在不同输出电压和不同负载下的输出波形及纹波：

<div class='center'>

| 负载 $R_L$ | 输出 $V_{\mathrm{out}}$ | 纹波 Peak-Peak $V_{\mathrm{r, pp}}$ | 主纹波频率 |
|:-:|:-:|:-:|:-:|
 | 10 $\Omega$ | $5$ V | 801 mV | 642 Hz $\times 1, 2, 3, ...$ |
 | 47.0 $\Omega$ | $5$ V | 547 mV | 314 Hz $\times 1, 2, 3, ...$ |
 | 100 $\Omega$ | $5$ V | 438 mV | 237 Hz  $\times 1, 2, 3, ...$ | 
 | 10 $\Omega$ | $9$ V | 257 mV | 7.1 KHz ~ 8.7 KHz | 
 | 47.0 $\Omega$ | $9$ V | 182 mV | 267 Hz ~ 890 Hz | 
 | 100 $\Omega$ | $9$ V | 162 mV | 1.2 KHz ~ 1.4 KHz | 
 | 10 $\Omega$ | $12$ V | 300 mV <br>(drop 0.5V) | 4.3 KHz ~ 10.9 KHz | 
 | 47.0 $\Omega$ | $12$ V | 182 mV | 2.9 KHz ~ 4.1 KHz | 
 | 100 $\Omega$ | $12$ V | 182 mV | 9.5 KHz ~ 10.8 KHz |
</div>

<div class='center'>

下面是带相关图片的测量结果：

| 负载 $R_L$ | 输出 $V_{\mathrm{out}}$ | 纹波 $V_{\mathrm{ripple, pp}}$ | 主纹波频率 | 波形图片 | FFT 结果 |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | 100 $\Omega$ | $5$ V | 438 mV | 237 Hz  $\times 1, 2, 3, ...$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-20-36_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-22-00_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |
 | 47 $\Omega$ | $5$ V | 547 mV | 314 Hz $\times 1, 2, 3, ...$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-20-53-54_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-20-54-55_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |
 | 10 $\Omega$ | $5$ V | 801 mV | 642 Hz $\times 1, 2, 3, ...$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-08-56_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-11-06_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |
 | 100 $\Omega$ | $9$ V | 162 mV | 1.2 KHz ~ 1.4 KHz | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-23-22_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-24-36_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |
 | 47 $\Omega$ | $9$ V | 182 mV | 267 Hz ~ 890 Hz | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-20-57-10_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-01-30_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |
 | 10 $\Omega$ | $9$ V | 257 mV | 7.1 KHz ~ 8.7 KHz | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-13-00_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-13-49_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |
 | 100 $\Omega$ | $12$ V | 182 mV | 9.5 KHz ~ 10.8 KHz | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-26-53_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-29-14_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |
 | 47 $\Omega$ | $12$ V | 182 mV | 2.9 KHz ~ 4.1 KHz | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-04-50_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-05-51_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |
 | 10 $\Omega$ | $12$ V | 300 mV <br>(drop 0.5V) | 4.3 KHz ~ 10.9 KHz | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-17-04_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-03-21-18-11_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |
</div>


## 设计思路

我们主要想改善 9V ~ 12V 时的输出纹波，于是可以考虑构建一个截止频率约为 100 Hz 的 Pi 型低通滤波器。理想 Pi 型低通滤波器的传递函数由下式给出：
$$
H(s) = \frac{1}{1 - \omega^2CL }
$$

仅将电感视为实际电感，将其 DCR (直流电阻) 视作 ESR (等效串联电阻)，则传递函数变为：
$$
H(s) = \frac{1}{1  + j \omega C R_L - \omega^2CL }
$$

如果还要考虑电容的 ESR (记作 $R_C$)，传递函数为：
$$
H(s) = \frac{1 + j \omega C R_C }{1 + j \omega C(R_C + R_L) - \omega^2CL }
$$

## 洞洞板验证

我们利用 $L = 2 mH$ (DCR 3 $\Omega$) 的工字电感和 $C = 220 $ uF (ESR = 0.5 $\Omega$) 的电解电容构建 Pi 型滤波器，验证滤波效果，如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-05-23-40-00_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div>

此参数下，滤波器的截止频率为：
$$
f_c = \frac{1}{2 \pi \sqrt{LC}} = 239.9351 \mathrm{Hz}
$$
但是，受电感 DCR (以及 ESR) 和电容 ESR 的影响，实际截止频率会有所偏离，输出电压也会有一定下降 (电流流过电感 DCR 带来电压降)。设定无负载时输出 12.1 V 左右，下面进行实际测量：

<div class='center'>

| 负载 $R_L$ | 实际输出 $V_{\mathrm{out}}$ | 纹波 $V_{\mathrm{ripple, pp}}$ |
|:-:|:-:|:-:|
 | 100 $\Omega$ | 11.76 V | 40 mV |
 | 47 | 11.33 V | 40 mV |
 | 10 | 8.99 V | 40 mV |
</div>

<div class='center'>

| 负载 $R_L$ | 实际输出 $V_{\mathrm{out}}$ | 纹波 $V_{\mathrm{ripple, pp}}$ | 波形图片 |
|:-:|:-:|:-:|:-:|
 | 100 $\Omega$ | 11.76 V | 40 mV | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-05-23-24-47_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |
 | 47 | 11.33 V | 40 mV | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-05-23-27-50_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |
 | 10 | 8.99 V | 40 mV | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-05-23-29-47_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div> |
</div>

由图可以看到，Pi 型滤波器的效果还是很明显的，纹波得到了明显的改善，基本都限制在了 40 mV ($\pm$ 20 mV) 以内。但是，受电感 DCR 影响，输出电压有一定下降，这在电流较大时尤为明显。

因此，如果需要提高滤波效率和功率，建议使用大功率、低电阻的磁环电感，以及低 ESR 的电解电容，或者在原电容上并联 0.1 uF 的小电容以降低电容 ESR 对滤波的负面影响。例如 6 mH (DCR < 0.1 $\Omega$, 5A max) 的磁环电感和 220 uF // 0.1 uF 的电解电容（截止频率 107 Hz）。

