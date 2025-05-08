# Analog Pulse Width Modulation 

> [!Note|style:callout|label:Infor]
> Initially published at 13:43 on 2025-03-22 in Beijing.

see [TI Precision Designs: Analog Pulse Width Modulation](https://www.ti.com/lit/ug/slau508/slau508.pdf)

Circuit Description: This circuit utilizes a triangle wave generator and comparator to generate a pulse-width-modulated (PWM) waveform with a duty cycle that is inversely proportional to the input voltage. 

An op amp and comparator generate a triangular waveform which is passed to the inverting input of a second comparator. 
By passing the input voltage to the non-inverting comparator input, a PWM waveform is produced. 
Negative feedback of the PWM waveform to an error amplifier is utilized to ensure high accuracy and linearity of the output.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-13-46-48_Analog Pulse Width Modulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-13-45-47_Analog Pulse Width Modulation.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-22-13-46-00_Analog Pulse Width Modulation.png"/></div>