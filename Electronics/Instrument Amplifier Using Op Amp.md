# Instrument Amplifier Using Op Amp

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 22:40 on 2025-02-26 in Beijing.

## Using Single Op Amp

设计一个 single op amp 的 high-side current sampling, 参考 [TI Application Notes:  Using An Op Amp for High-Side Current Sensing](https://www.ti.com/lit/ab/sboa347a/sboa347a.pdf)

电路图：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-22-01-13_Current Sense Amplifiers.png"/></div>
输出增益为：

$$
\begin{gather}
A_v = \frac{R_1}{R_2},\quad (R_1 = R_4,\ R_2 = R_3)
\end{gather}
$$

考虑共模输入：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-22-01-21_Current Sense Amplifiers.png"/></div>

电阻 mismatch 问题：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-22-08-26_Instrument Amplifier Using Op Amp.png"/></div>

Input offset voltage ($V_{\mathrm{offset}}$) 问题：
<div class="center"><img width=400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-05-22-11-50_Instrument Amplifier Using Op Amp.png"/></div>

NE5532 的 $V_{\mathrm{offset}}$ 为 0.5mV (typ.), 要实现较高的测量精度, $R_{shunt}$ 上的压降应该在 50mV 以上。这显然太高了, 因为我们的预期压降范围在 0\~25mV or 0\~50mV 之间, 低压降时, $V_{\mathrm{offset}}$ 会对测量结果产生相当大的影响。

如果使用 OP07CP, 其 $V_{\mathrm{offset}}$ 为 ±60uV (typ.), 压降在 6mV 左右便能达到约 1% 的精度, 是可以接受的。

其它参考资料：
- [TI: High-side current sensing with discrete difference amplifier circuit](https://www.ti.com/tool/CIRCUIT060005)
- [TI: High-Side Current-Sensing Circuit Design](https://www.ti.com/lit/an/sboa310b/sboa310b.pdf)

## Using Two Op Amp

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-06-14-45-26_Instrument Amplifier Using Op Amp.jpg"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-08-17-23-48_Instrument Amplifier Using Op Amp.jpg"/></div>

## Using Three Op Amp

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-23-40-02_Instrument Amplifier Using Op Amp.png"/></div>

## References

- [TI: Three Op Amp Instrumentation Amplifier Circuit](https://www.ti.com/lit/an/sboa282a/sboa282a.pdf)
- [TI: Two Op Amp Instrumentation Amplifier Circuit](https://www.ti.com/lit/an/sboa281a/sboa281a.pdf)
- [TI: The Instrumentation Amplifier Handbook](https://e2e.ti.com/cfs-file/__key/communityserver-discussions-components-files/14/Burr_2D00_Brown-The-Instrumentation-Amplifier-Handbook_2D00_1.pdf)
- [TI: Using An Op Amp for High-Side Current Sensing](https://www.ti.com/lit/ab/sboa347a/sboa347a.pdf)
- [ADI: A Designer’s Guide to Instrumentation Amplifiers](https://www.analog.com/media/en/training-seminars/design-handbooks/designers-guide-instrument-amps-complete.pdf)
- [ADI: Basic Two Op Amp In-Amp Configuration](https://www.analog.com/media/en/training-seminars/tutorials/MT-062.pdf)
