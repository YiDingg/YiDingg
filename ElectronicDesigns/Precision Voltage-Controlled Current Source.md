# Precision VCCS (Voltage-Controlled Current Source)

> [!Note|style:callout|label:Infor]
> Initially published at  on  in .

## Infor

- Time: 2025.03.01
- Notes: 
    - 输入：OPA+ (运放正电源), OPA- (运放负电源), VCC (电流输出电源), V_IN1 (CH 1 输入电压), V_IN2 (CH 2 输入电压)
    - 输出：I_OUT1+ (CH1 输出电流), I_OUT2+ (CH2 输出电流)
- Details: 
    - 输出电流范围从 0~50uA, 0~500uA, ..., 0~5A 可调
    - 采用 1x3P 排母的直插式方案，方便配合实际情况更换 MOSFET
    - 配有 OPA+, VCC, OPA- 电源指示灯
    - Ro 系列 100Ohm ~ 100KOhm 电阻建议使用 0.1% ±25PPMM 的低温漂高精密电阻
- Relevant Resources: [https://www.123684.com/s/0y0pTd-svUj3](https://www.123684.com/s/0y0pTd-svUj3)



<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 |<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-01-12-25-42_Precision Voltage-Controlled Current Source.png"/></div>|<div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-01-12-22-28_Precision Voltage-Controlled Current Source.png"/></div>|

</div>


<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-01-12-27-25_Precision Voltage-Controlled Current Source.png"/></div> | <div class="center"><img height = 250px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-01-12-27-44_Precision Voltage-Controlled Current Source.png"/></div> |
</div>

<div class='center'>

| Demo (top view)| Demo (bottom view) | 
|:-:|:-:|
 | <div class="center"><img height = 250px src=""/></div> | <div class="center"><img height = 250px src=""/></div> |
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