# Other Circuit Boards

> [!Note|style:callout|label:Infor]
Initially published at 15:40 on 2025-01-21 in Lincang.

仅由洞洞板搭建 (未做PCB) 的电路统一放在这里

## Pi Filter (0 ~ 12 V, 0.2 A max)

- Time: 2025.01.03
- Notes: input 0 ~ 12 V, 0.2 A max (continuously)
- Details: 2 mH (DCR = 3 $\Omega$) 工字电感, 220 uF (16V, ESR = 0.5 $\Omega$) 电解电容, 0.1 uF (50V, ESR = ) 电解电容, $f_0 \approx 240 \ \mathrm{Hz}$ 

构建一个简单的 Pi 型滤波器对电源进行滤波，如下图所示：
<div class="center"><img width = 300px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-01-05-23-40-00_用Pi型滤波器改善可调直流电源的输出纹波.png"/></div>

## Voltage Inverter (3.5V ~ 12V, ICL7660)

- Time: 2025.01.28
- Notes: input 3.5V ~ 12 V, $V_{out} = -V_{in}$
- Details: using ICL7660, $R_{out} = 50 \ \mathrm{m\Omega}$,  max 10 mA (continuous) or 30 mA (pulsed).

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-11-15-08-18_Other Circuit Boards.png"/></div> | <div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-11-15-08-34_Other Circuit Boards.png"/></div> |
</div>

<!-- ## Pi Filter (0 ~ 40 V, 3 A max)

- Time: 
- Notes: input 0 ~ 40 V, 3 A max (continuously)
- Details: 1 mH (DCR $ = \Omega$) 工字电感, 220 uF (50V, ESR = $\Omega$) 电解电容, 0.1 uF (50V, ESR = ) 电解电容, $f_0 \approx 480 \ \mathrm{Hz}$  -->

<!-- ##  DC-DC Converter 10V~36V to ± 12 V (max 2A / channel) -->
