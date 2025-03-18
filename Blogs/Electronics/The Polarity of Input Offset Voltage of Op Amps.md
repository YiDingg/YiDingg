# The Polarity of Input Offset Voltage of Op Amps

> [!Note|style:callout|label:Infor]
Initially published at 18:21 on 2025-03-18 in Beijing.


## Conclusion

看过很多资料，有的 $V_{OS}$ (也写作 $V_{IO}$) 加在运放的 noninverting 端，有的加在 inverting 端（正极指向运放），那么 $V_{OS}$ 的方向到底是怎样的呢？

经过考察，结论是：多数技术文档，包括 ADI (Analog Devices) 和 TI (Texas Instruments)，是把 $V_{OS}$ 加在 inverting 端（正极指向运放），也就是将 $V_{OS}$ 定义为：

<div class='center'>

$V_{OS}$ is **the differential voltage which must be applied to the input of an op amp to produce zero output**.
</div>




## References


### 支持 inverting 端

下面是部分支持加在 inverting 端的：

- [ADI: MT-037: Op Amp Input Offset Voltage](https://www.analog.com/media/en/training-seminars/tutorials/MT-037.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-18-37-37_The Polarity of Input Offset Voltage of Op Amps.png"/></div>

- [ADI: Simple Op Amp Measurements](https://www.analog.com/media/en/analog-dialogue/volume-45/number-2/articles/simple-op-amp-measurements.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-18-43-37_The Polarity of Input Offset Voltage of Op Amps.png"/></div>

- [TI: Input Offset Voltage (VOS) \& Input Bias Current (IB)](https://www.ti.com/content/dam/videos/external-videos/en-us/1/3816841626001/4082104055001.mp4/subassets/opamps-offset-voltage-input-bias-specifications-presentation-quiz.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-18-47-45_The Polarity of Input Offset Voltage of Op Amps.png"/></div>

- [TI: DC Parameters: Input Offset Voltage (VOS)](https://www.ti.com/lit/an/sloa059b/sloa059b.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-18-48-56_The Polarity of Input Offset Voltage of Op Amps.png"/></div>

### 支持 noninverting 端

下面是部分支持加在 noninverting 端的：
- [TI: Op Amps: What is Input Offset Voltage?](https://www.ti.com/lit/wp/sboa590/sboa590.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-18-18-45-25_The Polarity of Input Offset Voltage of Op Amps.png"/></div>

