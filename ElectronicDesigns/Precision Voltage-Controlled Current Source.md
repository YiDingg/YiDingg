# Precision VCCS (Voltage-Controlled Current Source)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 18:59 on 2025-03-01 in Beijing.

## Infor

- Time: 2025.03.01
- Notes: 
    - 输入：OPA+ (运放正电源), OPA- (运放负电源), VCC (电流输出电源), V_IN1 (CH 1 输入电压), V_IN2 (CH 2 输入电压)
    - 输出：I_OUT1+ (CH1 输出电流), I_OUT2+ (CH2 输出电流)
- Details: 
    - 输出电流范围从 0\~50uA, 0\~500uA, ..., 0\~5A 可调
    - 采用 1x3P 排母的直插式方案，方便配合实际情况更换 MOSFET
    - 配有 OPA+, VCC, OPA- 电源指示灯
    - Ro 系列 (100Ohm ~ 100KOhm) 建议使用 0.1% ±25PPMM 的低温漂高精密电阻
- Relevant Resources: [https://www.123684.com/s/0y0pTd-svUj3](https://www.123684.com/s/0y0pTd-svUj3)



<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 |<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-01-12-25-42_Precision Voltage-Controlled Current Source.png"/></div>|<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-01-12-22-28_Precision Voltage-Controlled Current Source.png"/></div>|

</div>


<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-01-12-27-25_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-01-12-27-44_Precision Voltage-Controlled Current Source.png"/></div> |
</div>

<div class='center'>

| Demo (top view)| Demo (bottom view) | 
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-14-28-34_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-14-32-27_Precision Voltage-Controlled Current Source.png"/></div> |
</div>


## Design Notes

下图是本设计的灵感来源与精度分析：
<div class="center"><img height=200px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-15-23-24_Precision Voltage-Controlled Current Source.png"/></div>

$V_{in}$ 端可以由电阻分压实现 1 和 0.1 的输入系数，为了使此电流源具有最高 0 ~ 5A、最低 0 
~ 50uA 的精确输出范围，我们选择 $R_o$ 的值为 1Ohm ~ 100KOhm。下面是这些电阻可能承受的最大功率（输入 0~5V）：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-16-36-06_Precision Voltage-Controlled Current Source.png"/></div>

满足功率要求的同时，为了使输出电流尽可能的精准，对于 R = 1 ，我们选择 5W 1% 金属膜电阻，对于 R = 10 ，选择 3W 1% 金属膜电阻，对于 R = 100 ~ 100K，选择 0603 (0.1W) 0.1% ±25PPMM 的低温漂精密电阻。 

## LTspice Simulation

若无特别说明，下面的仿真测试输入都为 100KHz sine wave (2.5V offset, 2.5V amplitude)。

### R_o = 1

R_o = 1 (coefficient = 1), I_out = 0 ~ 5A

<div class='center'>

| Resistance at MOS Gate | Simulation Result |
|:-:|:-:|
 | 0 | <div class="center"><img height=200px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-16-01-15_Precision Voltage-Controlled Current Source.png"/></div> |
 | 100 | <div class="center"><img height=200px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-16-02-42_Precision Voltage-Controlled Current Source.png"/></div> |
 | 500  | <div class="center"><img height=200px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-16-03-59_Precision Voltage-Controlled Current Source.png"/></div> |
</div>

### R_o = 10 ~ 10K
R_o = 10 ~ 10K (coefficient = $10^{-1} \sim 10^{-4}$), $I_{out,\max}$ = 500mA ~ 0.5mA

<div class='center'>

| $R_o\ (\Omega)$ | Coefficient | $I_{out}$ | Simulation Result |
|:-:|:-:|:-:|:-:|
 | 10 | $10^{-1}$ | 0 ~ 500mA | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-16-06-57_Precision Voltage-Controlled Current Source.png"/></div> |
 | 100 | $10^{-2}$ | 0 ~ 50mA | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-16-16-48_Precision Voltage-Controlled Current Source.png"/></div> |
 | 1K | $10^{-3}$ | 0 ~ 5mA | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-16-17-24_Precision Voltage-Controlled Current Source.png"/></div> |
 | 10K | $10^{-4}$ | 0 ~ 500uA | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-16-17-57_Precision Voltage-Controlled Current Source.png"/></div> |
 | 100K | $10^{-5}$ | 0 ~ 50uA | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-16-20-38_Precision Voltage-Controlled Current Source.png"/></div> |
</div>

由仿真结果可以看到，对于相当宽的 $R_o$ 范围（和频率 $f$ 范围），输出电流都能够稳定地跟随输入电压变化，且电压映射精度保持在 $\pm 1.5 \,\%$ 以内（相比于最大值）。事实上，这里的精度误差主要是由输出相位延迟引起（因为误差呈现正弦值），而不是电流值的 DC 输出偏差。下面的 DC sweep 仿真印证了这一点：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-16-27-29_Precision Voltage-Controlled Current Source.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-16-23-39_Precision Voltage-Controlled Current Source.png"/></div> -->

由图可以看到，除了在输入接近零的很小一段，$R_o$ 两端的电压与输入电压近乎完美匹配，相对误差仅仅只有 $\frac{\Delta V}{V} = 1.0 \times 10^{-5} \sim 4.5 \times 10^{-5}$。

## Test Results

若无特别说明，下面的测试在室温 (约 25°C) 下进行，VCC+ = +12V, VCC- = -12V, frequency response 中输入信号为 1V (实际约为 1.022V) amplitude (1V offset) 的 sine wave。

<div class='center'>

| Test Condition | Resistor Voltage Drop $V_R$ <br> (input 100KHz Sine) | Resistor Voltage Drop $V_R$ <br> (input 100KHz RampUp) | Resistor Voltage Drop $V_R$ <br> (input 100KHz Square) | Frequency Response |
|:-:|:-:|:-:|:-:|:-:|
 | $R_L = 0,\ R_o = 1 \ \mathrm{K\Omega}\ (I_{\max} = 5 \ \mathrm{mA})$ <br> using 2N7000 (NMOS) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-00-01_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-00-24_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-24-11_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-06-47_Precision Voltage-Controlled Current Source.png"/></div> |
 | $R_L = 0,\ R_o = 1 \ \mathrm{K\Omega}\ (I_{\max} = 5 \ \mathrm{mA})$ <br> using IRF540NPBF (Power NMOS) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-13-59_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-14-15_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-20-37_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-08-21_Precision Voltage-Controlled Current Source.png"/></div> |
 | $R_L = 0,\ R_o = 1 \ \mathrm{K\Omega}\ (I_{\max} = 5 \ \mathrm{mA})$ <br> using SS8050 (NPN) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-13-00_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-12-28_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-23-08_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-11-43_Precision Voltage-Controlled Current Source.png"/></div> |
 | $R_L = 0,\ R_o = 1 \ \mathrm{K\Omega}\ (I_{\max} = 5 \ \mathrm{mA})$ <br> using 2SD882 (Power NPN) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-17-35_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-18-10_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-21-27_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-15-17-10_Precision Voltage-Controlled Current Source.png"/></div> |
</div>

我们还发现，（在上述测试条件下）输入端浮空时，$I_{out+}$ 可能会有一定的漏电流，下面是一些参考数据：



<div class='center'>

| $I_{\max}$ | $R_L$ | $V_{out}$ | $V_{R}$ | $I_{R, leak}$ |
|:-:|:-:|:-:|:-:|:-:|
 | 0.5A (10R) | 10R | 10.81V | 26.0mV | 2.60mA |
 | 0.5A (10R) | 100R | 9.57V | <span style='color:red'> 970mV </span> | <span style='color:red'> 97mA </span> |
 | 0.5A (10R) | 1K | 10.52V | 121mV | 12.1mA |
 | 0.5A (10R) | 10K | 10.79V | 26.2mV | 2.62mA |
 | 0.5A (10R) | $\infty$ | 10.87V | 15.4mV | 1.54mA |
</div>


<div class='center'>

| $I_{\max}$ | $R_L$ | $V_{out}$  | $V_{R}$ | $I_{R, leak}$ |
|:-:|:-:|:-:|:-:|:-:|
 | 50mA (100R) | 10R     | 0.0129V | 20.24mV | 0.20mA |
 | 50mA (100R) | 100R    | 0.0129V | 20.682mV | 0.21mA |
 | 50mA (100R) | 1K      | 9.692V | <span style='color:red'> 981.45mV </span> | <span style='color:red'> 9.81mA </span> |
 | 50mA (100R) | 10K     | 10.687V | 122.28mV | 1.22mA |
 | 50mA (100R) |$\infty$ | 10.859V | 17.244mV | 0.17mA |
</div>


<div class='center'>

| $I_{\max}$ | $R_L$ | $V_{G}$ (Gate)  | $V_{R}$ | $I_{R, leak}$ |
|:-:|:-:|:-:|:-:|:-:|
 | 5mA (1K) | 10R     | -11.382V | 22.394mV | 22.394uA |
 | 5mA (1K) | 100R    | -11.384V | 22.514mV | 22.514uA |
 | 5mA (1K) | 1K      | -11.369V | 22.548mV | 22.548uA |
 | 5mA (1K) | 10K     | 11.979V | <span style='color:red'> 959.6mV </span> |  <span style='color:red'> 959.6uA </span> |
 | 5mA (1K) |$\infty$ | 11.977V | 26.202mV | 26.202uA |
</div>

0 输入时（输入端接 GND）, $V_G = -11.381 \ \mathrm{V}$, $V_R = 22.532 \ \mathrm{mV}$。由此可以知道，$V_R$ 约 22mV 的偏移量是由运放的输入失调和偏置引起的，但是当负载电阻为 $R_o$ 的十倍时（输入浮空），漏电流会比较明显，这是为什么？有待进一步讨论。

另外，当负载为二极管时（例如一个导通压降约 2.5V）的 LED, 漏电流（漏电压）也会比较明显，且漏电流随着档位的升高而逐渐增大（和上面类似）。


为了使输入端浮空时 MOS 正常关断（输出电流为 0），我们首先尝试了将输入端下拉到 GND, 但效果不尽人意。即使在下拉电阻为 100KOhm 的情况，$V_{G}$ 也无法被下拉到 $-11 \ \mathrm{V}$（仍维持在 +11.9V）。