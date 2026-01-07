# 202510_onc18_CPPLL_ultra_low_lower (3) Design of Other Modules

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 17:46 on 2025-10-23 in Beijing.

>注：本文是项目 [Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology](<Projects/Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology.md>) 的附属文档，用于全面记录 PLL 的设计/迭代/仿真/版图/后仿过程。


续前文 [202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.md>), 本文继续记录 PLL 的设计进展。

## 1. Basic Logic Gates

本次 `onc18` 工艺，虽然需求方也发来了 1.8V/5.0V 标准数字单元库，但是在 PFD 等对称性要求较高的模块中，这些 "粗略的" 数字版图是无法满足要求的。因此需要讨论哪些数字单元需要我们自己搭建：
- PFD (NOR, NAND, INV): 对称性要求很高，需要自己搭建
- CP (PG or TG): 对称性要求较高，需要自己搭建
- FD (D Latch or D Flipflop): 可以直接使用标准单元库


也就是需要自行搭建 NOR/NAND/INV/PG 四个模块。为了方便修改和调用，我们可以将每一个 cell 封装成 parameter passing symbol 的形式，类似 `tsmcN28` 那样，可以直接在 symbol 界面修改管子参数，并且可以正常导入到版图。具体做法见这篇文章 [Virtuoso Tutorials - 17. Creating Parameter Passing Symbol as The Standard PCell](<AnalogIC/Virtuoso Tutorials - 17. Creating Parameter Passing Symbol as The Standard PCell.md>)，这里我们直接展示最终效果：


开始之前，再回顾一遍 D Latch 和 D Flipflop 的区别： [From Basic Logic Gates to D Latch and D Flipflop](<AnalogIC/From Basic Logic Gates to D Latch and D Flipflop.md>)


<span style='color:red'> 

注：为了减小功耗，降低管子关断时的漏电流，我们用到的 **所有逻辑门的搭建都是使用 uhvt 器件** 来搭建；以 1.8V nmos 为例, nominal device leakage = 78.0 pA, uhvt device leakage = 0.25 pA, 1.8V nominal pmos 甚至达到了 209 pA 的漏电流，因此使用 uhvt 器件是非常有必要的。

</span>



## 2. PFD (PF Detector)

PFD 基于 Razavi CMOS 书上提到的经典结构稍作改进，将 AND (NAND + INV) 改为 NOR 结构以同时降低功耗和传输延迟，原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-14-55-40_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>


``` bash
CK D Q(CK_OUT) QB(CK_OUT_B)
up 0 1 0
dn 0 1 0

up 1 0 1
dn 1 0 1

up 0 1 0
dn 0 1 0

up 1 0 1
dn 1 0 1

up 0 1 0
dn 0 1 0
```

**<span style='color:red'> 测试时发现 using AND Gate 在 REF lags FB (delay_FG < 0) 时出现了 DN 异常的问题？ </span>** 2025.11.03 23:00 发现是因为输入时钟的 delay 设置不足，导致两个 DFF 的时序没有 "对齐"，并不是 PFD 本身的问题。给予额外的 delay 时间后，问题消失。


环路锁定之后，我们的 PFD 只需工作在 32.768 kHz, 对于由逻辑门搭建的 PFD 来讲，这个频率非常低，功耗很小 (nA 级别)，因此可以主要关注 PFD 的其它性能指标，例如最小脉冲宽度 (Minimum Pulse Width) 和最大工作频率 (Maximum Operating Frequency)。为保证可靠性，我们需要 PFD 的最大工作频率远高于 32.768 kHz, 不妨先设定为 1 MHz (这其实非常容易达到，不必过于担心)。



测试效果如下：


<div class='center'>

| NORrst 遍历与筛选情况 | 波形总览 @ REF = FB | 波形总览 @ REF leads FB (delay_FB > 0) | 波形总览 @ REF lags FB (delay_FB < 0) | 输入输出曲线 I/O Relationship | 最大工作频率 and 功耗曲线 |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | 选取 **(KA, WN, L) = (1, 0.22, 0.18)** 进行详细测试 (最窄脉冲之一 + 最低功耗) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-16-25-45_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-16-34-37_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-16-38-37_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-16-40-05_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-16-55-11_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-17-29-41_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 选取 **(KA, finger, fWN, L) = (2.5, 2, 0.42, 0.18)** (total WN = 0.84) 进行详细测试 (较合适的参数) |  |  |  |  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-22-50-56_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>

- 最低功耗参数 (KA, WN, L) = (1, 0.22, 0.18): IDD = 150 nA @ 3 MHz (5.0 nA @ 100 kHz), Minimum Pulse Width = 1.873 ns, Maximum Operating Frequency > 10 MHz
- 较合适参数 (KA, finger, fWN, L) = (2.5, 2, 0.42, 0.18): 550 nA @ 3 MHz (14.5 nA @ 100 kHz), Minimum Pulse Width = 1.477 ns, Maximum Operating Frequency > 100 MHz

综合考虑 PFD 的版图安排，我们选择 **(KA, finger, fWN, L) = (2.5, 1, 0.84, 0.18)** 作为 PFD (NORrst) 的最终参数。


**<span style='color:red'> 2025.11.03 补：在第五小节 (5. Practical Loop Simu.) 的环路测试时发现 NORrst PFD 容易进入 "假锁定状态"，比如卡在 2\*f_out 或 0.5\*f_out 这样的非预期输出频率， </span>** 我们猜测这是 UPB/DNB 与 UP/DN 不完全满足 "与非" 关系导致的 (待验证)。若无特别说明，后续均改用 "正确的" ANDrst PFD, 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-03-11-08-47_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>


<!-- <div class='center'>

| 2025.11.03 补： PFD + CP 联合仿真结果 |
|:-:|
 | (KA, WN, L) of PFD and CP = (2.5, 0.84, 0.18) <br>  |
</div>
 -->



## 3. CP (Charge Pump)

对于 Third-Order Type-II 来讲，如果 C1 足够大使得 C2 也足够大 (相比于晶体管寄生电容)，也即 C2 在几十 fF 以上时，电荷泵 charge sharing 带来的影响基本可以忽略，此时便不需要再加一个额外的 Voltage Buffer 了。

电荷泵的话也是用最经典的结构，参考下面这篇论文：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-23-34-56_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>

我们实际使用时，一方面把四个开关全部替换为 PG (Pass Gate)，另一方面对比一下无/有运放的效果。按我们的预测，无运放时应该也基本没什么区别。


在设计 CP 时，需注意以下几点：
- (1) 偏置电流 Ibias 输入端最好采用 cascode 方式以提高 mirror 精度 (减小 ID_P 与 ID_N 的误差)
- (2) 偏置电流 Ibias 输入端可根据情况采用合适 multiplier 倍数，简单起见，我们在前仿迭代时直接设置 multiplier = 1
- (3) 电荷泵的 N/P 两个电流源都需要作 current mirror, 需要较好的版图匹配，因此需要确保 gm/Id 值不能太低

<div class='center'>

| 原理分析 | **(Bias_W/Bias_L = 0.42/10)** 输出特性曲线 @ IB = 5nA | **(Bias_W/Bias_L = 0.42/10)** DC Operating Point @ IB = 5nA, Vout = 0.625V (UP = 1, DN = 0) at (TT, 27°C) |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-17-48-17_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-01-14-42_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-01-16-19_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-01-11-42_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>


<div class='center'>

| 不同长度 (Bias_L) 下的性能情况 @ IB = 10nA | **(Bias_W/Bias_L = 0.42/10)** 整体性能情况 @ IB = 10nA |  **(Bias_W/Bias_L = 0.42/6)** 整体性能情况 @ IB = 10nA |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-01-28-02_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-01-20-22_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-01-36-36_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>

在合理的长度范围内，保持 10% 的输出电流精度只需消耗约 2\*60mV 的 voltage headroom, 算是非常不错的。我们对几个 "看起来还不错" 的参数进行蒙特卡洛仿真验证：

<div class='center'>

| Bias_W/Bias_L = 0.42/**6** 蒙卡结果 @ IB = 10nA |  Bias_W/Bias_L = 0.42/**10** 蒙卡结果 @ IB = 10nA | Bias_W/Bias_L = 0.42/**50** 蒙卡结果 @ IB = 10nA |
|:-:|:-:|:-:|
 |  |   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-02-18-19_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-02-16-30_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-01-55-58_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-02-01-21_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>

根据仿真结果，我们知道：
- (1) 要想得到可靠的电流精度, Bias_L 不宜过短 (起码 > 6um), 由于宽度只有 0.42um, 这么小的宽长比最终肯定是需要多个管子串联才行
- (2) Bias_L 过长并不能显著提升 Rout, 因为 length 提高的同时管子 gm/Id 值在变小，使得 rout 不一定变大

这里给一个 Bias_WN/Bias_L 的扫描结果：



## 4. Integer-2 FD

- 如果使用标准单元库的中的 DFF 来搭建，建议用 `dff_p0000` 类型的触发器 (`0` = `not specified`)，例如 `dffpx1_u/dffpx2_u` 等，这是因为：
- `n` or `p`: negative/positive edge triggered
- `q` or `not specified`: without/with negative Q (`QN`) output (`q` means only a single output `Q`, without `QN`)
- `r` or `not specified`: with/without (active-low) reset (`RN`) input 
- `s` or `not specified`: with/without (active-low) set (`SET`) input
- `h` or `m` or `not specified`:
    - `h`: with (active-high) clock enable (`E`) input
    - `m`: with two data inputs (`D0` and `D1`) and selection input (`SL0`) 
    - `not specified`: without clock enable or multiplexer function
- 注意：必须得有 IP 才能使用数字标准库里的元件，在本次项目是一个叫 `onSheetLib` 的工艺库


我们自己搭建 Integer-2 FD (FD2) 的话，采用这个结构： **16-T Gated D Latch > DFF > FD2**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-17-04-39_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>

仿真结果如下：

<div class='center'>

| 扫描与筛选情况 (主要看功耗和) | (KA, WN, L) = (1, 0.42, 0.18) 波形总览 | (KA, WN, L) = (1.5, 0.42, 0.18) 波形总览 |
|:-:|:-:|:-:|
 |  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-18-29-41_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-18-31-45_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-18-34-30_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>


## 5. Practical Simu. (va FD5)

### 5.1 loop simul. (va FD5)

在完成 PFD/CP/FD2 模块设计后，我们可以将这些模块集成到 PLL 的主原理图中进行实际的环路仿真，以验证整体 PLL 的性能指标是否满足要求 (FD5 仍用 verilog-a 模型替代)。

参数设置和仿真结果如下：

<div class='center'>

| PFD **(NORrst)** | CP | FD2 | PLL Loop 总览 |
|:-:|:-:|:-:|:-:|
 | (KA, WN, L) = (2.5, 0.84, 0.18) | (KA, WN, L) = (2.5, 0.84, 0.18) <br> (Bias_KA, Bias_WN, Bias_L) = (2, 0.42, 6.0) <br>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-03-00-12-57_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>  | (KA, WN, L) = (1.0, 0.42, 0.18)  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-23-39-41_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-03-01-07-39_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>



<div class='center'>

| Test Condition (using **NORrst** PFD) | 结果总览 | 锁定过程 | 输出眼图 | 相位噪声 (dBc/Hz) |
|:-:|:-:|:-:|:-:|:-:|
 | (R1 = 15 MOhm) LPF 接 VDD @ Spectre FX + AX |  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-03-01-32-27_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-03-10-52-29_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-03-10-54-50_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-03-10-57-09_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | (interactive.113) 修改 **R1 = 10 MOhm** 后 LPF 接 **VSS** (频率从高到低) @ Spectre X + CX (耗时 xxx) | 
 | (interactive.114) 修改 **R1 = 10 MOhm** 后 LPF 接 **VDD** (频率从低到高) @ Spectre X + CX (耗时 xxx) |
</div>

得到结论：
- (1) **R1 = 10 MOhm** 且 LPF 接 **VSS** 时 (频率从高到低)，建议 `time_end` = 2\*1600/(CLK_REF\*5), 注意这里是 N = 5
- (2) 出现假锁定状态 (2\*f_out or 0.5\*f_out), 估计是 NORrst PFD 造成的，建议改为 ANDrst PFD 再测一次

<div class='center'>

| Test Condition (using **ANDrst** PFD and R1 = **10MOhm**) | 结果总览 | 锁定过程 | (CK_X40) Je_n 分布情况和眼图 | X40/X20/X10/X05 相位噪声谱 |
|:-:|:-:|:-:|:-:|:-:|
 | RVCO1_v1_calibre, LPF to **VSS** (频率从高到低) @ Spectre FX + AX | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-03-13-09-16_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-03-13-19-13_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |  |  |
 | RVCO1_v1_calibre, LPF to **VDD** (频率从低到高) @ Spectre FX + AX | x | x | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-00-06-14_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | x |
 | RVCO2_v2_calibre, LPF to **VSS** (频率从高到低) @ Spectre FX + AX | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-03-13-13-29_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | x | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-00-00-15_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | x |
 | RVCO2_v2_calibre, LPF to **VDD** (频率从低到高) @ Spectre FX + AX | x | x | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-00-03-30_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | x |
</div>


得到结论：
- (1) 在当前参数下 (R1 = 10 MOhm, C1 = 30 pF), 环路完全锁定时间约为 **5 ms** (LPF to VDD, 频率从低到高) 或 **2.5 ms** (LPF to VSS, 频率从高到低)
- (2) 相位噪声以 normalized frequency 为横坐标时，提高分频比会使得相位噪声曲线整体上移 (噪声变大)，但映射回 "绝对频率" 后基本上是降低的；以 N = 2 为例，假设分频前 PN = **-63 dBc/Hz @ 1 kHz** (1 UI), **-73 dBc/Hz @ 2 kHz** (2 UI) and -81 dBc/Hz @ 4 kHz (4 UI), 则 2 分频后 1 UI 频率处的绝对相噪变为原来的两倍 (N 分频就是 N 倍)，也即提高了 3dB, 映射回绝对频率后变为 PN = -60 dBc/Hz @ 0.5 kHz (1 UI), **-70 dBc/Hz @ 1 kHz** (2 UI) and **-78 dBc/Hz @ 2 kHz** (4 UI), 相当于整体相噪有所降低。
- (3) 从 Je_n 可以看出 (由 edgeTime 和周期计算得到)，有些参数下之所以出现非常高的 Je_rms ，是因为输出频率在当前时间范围内仍有很小的 "漂移"，只有去除这些漂移带来的影响后，才能得到真实的抖动值；不仅是 Je_rms, Jc_rms 也是类似。


### 5.2 PFD/CP Optimization

2025.11.03 晚与导师讨论后，认为 PFD 原始参数 (KA, WN, L) = (2.5, 0.84, 0.18) 的最小脉冲太短 (约 1.5 ns)，可能导致 CP 死区过大，从而影响 PLL 锁定后的性能。因此我们决定对 PFD/CP 参数进行联合仿真，希望通过增大宽度/长度来提升 PFD 最小脉冲宽度 (Minimum Pulse Width)，从而提升 PFD/CP 整体电流增益的线性度。但是注意，一味提升最小脉冲宽度并不能显著提升 PFD/CP 性能，还是得综合看待 "驱动信号 (UP/DN)" 与 "被驱动模块 (CP)" 之间的匹配情况。

仿真结果如下：

<div class='center'>

| PFD + CP 联合仿真 Iout_ave (Iout_gain) |
|:-:|
 | 固定 KA = 2.5 <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-20-56-36_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 扫描全部 (KA, WN, L) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-22-12-40_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 上面这张曲线图看起来比较费劲，我们人工选几个比较不错的参数进行对比：<br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-22-23-36_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 
 | 综合考虑脉冲宽度、前仿和版图性能，我们选择 **(KA, WN, L) = (1.0, 0.22, 0.36)** 作为 PFD/CP 最终参数
</div>

## 6. Integer-5 FD


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-18-15-30_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>

<div class='center'>

| FD5_50duty_6DFF | 仿真效果 |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-19-29-14_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-18-56-49_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
| **FD5_50duty_4DFF** | **仿真效果** |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-19-32-35_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-04-19-36-13_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>

## 7. Practical Simu. (Real FD5)

### 7.1 simulation results

2025.11.04 需求方那边开会，对项目进度进行对接和讨论，会议中提到为了节省功耗，我们的 PLL 还是不单独做一个 LDO 了，而是直接使用数字电路提供的 1.25V 纯数字开关电源。这个电源工作在约 1.24 kHz 的开关频率下，输出电压带有约 0.1 kHz 的 ±10 mV 纹波，可能会对锁相环性能产生影响，因此我们需要在环路仿真中考虑这个纹波的影响 (对比一下)。

仿真参数设置如下：
- (1) PLL 环路无/有纹波 (对比)
    - 无纹波：启动后 VDD = 1.25 V 恒定电压
    - 有纹波：启动后 VDD = 1.25 V ± 10 mV @ **0.2 kHz** (不设置 0.1 kHz 是为了减小瞬态时长)
- (2) 修改 PFD/CP 参数前/后 (对比)
    - 前：(KA, WN, L) = (2.5, 0.84, 0.18), 前仿共 36.73 nA @ 32.768 kHz (PFD 3.346 nA)
    - 后：(KA, WN, L) = (1.0, 0.22, 0.36), 前仿共 31.94 nA @ 32.768 kHz
- (3) 两种 VCO 参数 (择优)
    - RVCO1_v1_calibre
    - RVCO2_v2_calibre
- (4) 三个工艺角：
    - TT @  27°C
    - SS @ -40°C
    - FF @ 130°C
- LPF 接地情况：LPF to VDD (频率从低到高) **(可以明显减弱 VDD 纹波影响)** (就不妨真 LPF to VSS 的情况了, 因为)
- 瞬态时长设置为 **30 ms** (之前 40 ms 约耗时 15 hours), 
- 一共 2\*2\*2\*3 = 24 组参数


在跑 Spectre X + CX 之前，先跑一个 Spectre FX + AX 试试水，确认设置无误后再进行 Spectre X + CX。


Spectre FX + AX 仿真结果如下：

<div class='center'>

| Practical Loop @ Spectre FX + AX, 耗时 1.65 ks (27m  26.2s) <br> (24 组参数并行，每组参数 4 线程，占用服务器 CPU 约 30%) | 图像一 | 图像二 |
|:-:|:-:|:-:|
 | 性能总览 <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-01-15-01_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 旧 PFD 参数总览 <br> (KA, WN, L) = (2.5, 0.84, 0.18)  <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-00-18-50_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 新 PFD 参数总览 <br> (KA, WN, L) = (1.0, 0.22, 0.36) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-00-20-37_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 相噪对比 @ 100 kHz <br> (包含所有纹波/PFD/RVCO, 根据 PFD/RVCO 分组) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-00-51-09_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 相噪对比 @ 32.768 kHz <br> (包含所有纹波/PFD/RVCO, 根据 PFD/RVCO 分组) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-00-51-48_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 相噪对比 @ 10 kHz <br> (包含所有纹波/PFD/RVCO, 根据 PFD/RVCO 分组) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-00-52-15_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | (TT, 27°C) 相噪对比可以看出： | (1) 无论 PFD 参数或 VDD 纹波如何，RVCO1 的相噪均更好 |  (2) 所有参数中又以 RVCO1 @ new PFD 相噪最佳 |
 | 眼图对比 (仅作出 CK_X20 with VDD Ripple @ all-corner) <br>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-01-06-12_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | Je_n(t) 对比 (仅作出 CK_X20 @ TT27) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-01-09-39_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | Je_n 分布密度对比 (仅作出 CK_X20 with VDD Ripple @ TT27) |
</div>

Spectre X + CX 仿真结果如下：

<div class='center'>

| Practical Loop @ Spectre X + CX, 耗时 28.3 ks (7h 51m 36s) <br> (24 组参数并行，每组参数 4 线程，占用服务器 CPU 约 50%) |  |  |
|:-:|:-:|:-:|
 | 性能总览 <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-17-53-57_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 旧 PFD 参数总览 <br> (KA, WN, L) = (2.5, 0.84, 0.18)  <br>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-17-54-47_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 新 PFD 参数总览 <br> (KA, WN, L) = (1.0, 0.22, 0.36) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-17-55-26_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 性能总览可以看出： | (1) **RVCO2 @ old PFD** 在 RMS TE (Je_rms) 表现最佳，在有纹波的情况下为 68.43 mUI (68.43 mUI ~ 301 mUI) | (2) **RVCO1 @ new PFD** 在 RMS TIE (Jee_rms) 表现最佳，在有纹波的情况下 RMS TIE1 (Jee1_rms) 为 2.248 mUI (2.158 mUI ~ 2.650 mUI) |
 | TT27 相噪对比 @ 100 kHz  <br> (根据有无纹波、CK_X40/CK_X20 作出四组图像) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-18-04-11_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>  | TT27 相噪对比 @ 32.768 kHz <br> (根据有无纹波、CK_X40/CK_X20 作出四组图像) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-18-04-49_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | TT27 相噪对比 @ 10 kHz <br> (根据有无纹波、CK_X40/CK_X20 作出四组图像) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-18-05-24_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
  | (TT, 27°C) 相噪对比可以看出：| (1) VDD 纹波对相位噪声影响不大，前后几乎没有什么变化 | (2) 尽管所有参数中以 **RVCO2 @ new PFD** 相噪最佳，但也只比其他参数低 1dBc ~ 2dBc 左右 (全频段)，考虑功耗后 **RVCO1 @ new PFD** 仍是首选 |
  | Je_n(t) 对比 (仅作出 CK_40 @ TT27) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-18-27-37_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | Je_n(t) 对比 (仅作出 CK_20 @ TT27) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-18-29-43_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | Je_n 分布密度对比 (仅作出 CK_20 @ TT27 without ripple) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-05-18-19-20_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
  | Je_n(t) 对比结果进一步验证了 VDD ripple 对 PLL 几乎没有影响 |   | 眼图对比 (仅作出 CK_X20 with VDD Ripple @ all-corner) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-07-22-32-18_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>

### 7.2 MATLAB analysis

从仿真结果中导出以下数据：
- (1) $v_{x40}(t)$ 波形数据 (TT27, 有/无 VDD 纹波, new/old PFD, RVCO1/RVCO2), 一共 8 组
    - **使用 resampling 进行数据处理，设置 time step = 10 ns (resample frequency = 100 MHz) 后导出；** 我们的仿真设置了 100 MHz transient noise, 最小仿真步长为 5 ns (200 MHz)，因此用 100 MHz 重采样是没有问题的
- (2) $edgeTime_{x40}[n]$ 序列数据 (TT27, 有/无 VDD 纹波, new/old PFD, RVCO1/RVCO2), 一共 8 组
    - 从 edge time 可以提取出周期等其它序列，从统计角度计算一系列抖动指标
    - 另一方面，我们需要从 edge time 序列 "还原" 出相位噪声 $\phi_n(t)$ 波形，进而计算出相位噪声谱 $S_{\phi_n}(f)$ 或者 $L(f_m)$
- (3) Phase Noise Spectrum 数据 (TT27, 有/无 VDD 纹波, new/old PFD, RVCO1/RVCO2), 一共 8 组
    - 直接从仿真结果中导出相位噪声谱数据，与第 (2) 条得到的相位噪声谱进行对比验证

计算所用到的理论原理和代码实现见文章 [Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation](<AnalogIC/Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.md>)，这里直接给出处理结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-06-15-06-41_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>

图中可以看出以下几点：
- 满足要求的：
    - (1) RMS PEJ (period jitter, namely cycle jitter $J_{c,rms}$) = 2.55 mUI, 满足要求
    - (2) RMS C2C (cycle-to-cycle jitter $J_{cc,rms}$) = 3.06 mUI, 满足要求
- 不满足要求的：
    - (1) RMS TE (timing error, namely edge jitter $J_{e,rms}$) 达到了 120.51 mUI (92 ns)
    - (2) 低频相噪较高，比如 Phase Noise @ 10 kHz = -65.19 dBc/Hz 以及 Phase Noise @ 5 kHz = -57.33 dBc/Hz

从相噪曲线可以看出，低频相噪较高且整体平缓，说明低频噪声主要来自 PFD/CP 或 FD, 需要进一步优化。


## 8. PFD optimization

### 8.1 theoretical analysis

主要参考这篇文献：
>[[1]](https://ieeexplore.ieee.org/document/6324396) A. Homayoun and B. Razavi, "Analysis of Phase Noise in Phase/Frequency Detectors," in IEEE Transactions on Circuits and Systems I: Regular Papers, vol. 60, no. 3, pp. 529-539, March 2013, [doi: 10.1109/TCSI.2012.2215792.](https://ieeexplore.ieee.org/document/6324396)

根据我们的需求来提取文献中的主要结论：

<div class='center'>

| [[1]](https://ieeexplore.ieee.org/document/6324396) A. Homayoun and B. Razavi, "Analysis of Phase Noise in Phase/Frequency Detectors," in IEEE Transactions on Circuits and Systems I: Regular Papers, vol. 60, no. 3, pp. 529-539, March 2013, [doi: 10.1109/TCSI.2012.2215792.](https://ieeexplore.ieee.org/document/6324396) |
|:-|
 | (1) A worthy effort in PFD design, therefore, is to minimize the rise and fall times. We thus modify the standard NOR-based PFD to the NAND-based topology shown in Fig. 9(a). **(就是说 NAND PFD 比 NOR PFD 上升/下降时间更短，从而抖动更低)** Note that this circuit responds to the falling edges of and CKA and CKB, and its Up and Down outputs are low when asserted. **(NAND PFD 是对齐的是 "下降沿" 而非上升沿，并且文献中所标出的 UP/DN 输出，在激活是处于低电平)** |
 | (2) one can simply enlarge the widths of all of the PFD transistors by a factor of so as to reduce the phase noise by the same factor, but at the cost of proportionally higher power consumption. **(PFD 整体噪声随宽度增加而减小，但功耗上升)** |
 | (3) We consider noise here as it dominates for offsets as high as 10 MHz, but optimization for thermal noise is similar. **(在多数 GHz 级设计中, 10 MHz offset 以下 1/f noise 占主导)** |
 | (4) The drain 1/f noise current spectrum is given by $S_{1/f}(f) = \frac{ g_m^2 K_f}{W_a L_a C_{ox} f}$ |
 | (5) The total phase noise of the PFD can be approximately expressed as: $S_{\phi_n}(f) \propto \frac{f_{in}^2VDD^2 C_L^2}{W_a^3} \cdot \frac{1}{f} $ |
 | 上面这条可等价表达为：$S_{\phi_n}(f) \propto \frac{P^2}{V_{DD}^2 W_a^3}\cdot \frac{1}{f}  \ \ (P = f_{in}C_L V_{DD}^2)$ | 
 | 或者 $S_{\phi_n}(f) \propto \frac{\left(\eta W_a + W_b \right)^2}{W_a^3} \ \ (C_L \propto \left(\eta W_a + W_b \right))$ |
 | where $W_a$ denotes the width of the "driver" transistor, and $W_b$ denotes the width of the "load" transistor. |
 | **下面分析 NAND PFD** 的具体优化建议 |
 | (6) NAND PFD 抖动主要由 PMOS of NAND1/2/4 以及 NMOS of NAND2/3 贡献, 这些管子的宽度需要较高 |
 | (7) NMOS of NAND1/4/9, PMOS of NAND3/9 这些管子的 jitter 不会累积到整体 jitter 中，因此这些管子的宽度可以较小 (可最小) |


</div>


论文中给出了一个具体的优化示例 (phase noise 下降 4 dB ~ 6 dB):

<div class='center'>

| NAND (L = 60nm) | NMOS Width (um) | PMOS Width (um) | KA |
|:-:|:-:|:-:|:-:|
 | 1 | 0.12 | 11   | 92 |
 | 2 | 5.9  | 9.1  | 1.5 |
 | 3 | 6.22 | 0.12 | 0.019 |
 | 4 | 0.12 | 7.8  | 65 |
 | 9 | 0.12 | 0.12 | 1.0 |
</div>

注意 NAND 5~8 与 1~4 完全对称。



<div class='center'>

| NAND PFD **(n_upb)** | NAND PFD **(n_upb)** |
|:-:|:-:|
 | 也就是说，如果认为 UP/DN 都是高电平有效的话，文献图中 (下图) NAND PFD 的输出端，上面两个对应 UP/DN, 下面两个对应 UPB/DNB | 根据 UP/DN 是高电平有效修改端口名，得到原理图如下： |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-06-14-06-58_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-06-14-47-04_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 进行简单的仿真验证 | 波形一览 |
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-06-14-48-12_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-06-14-50-43_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |

</div>


### 8.2 optimization ideas


根据上面的理论参考，我们将原来使用的 NOR-based PFD **改为 NAND-based** 进行仿真迭代，主要思路如下：
- (1) 所有 NAND 门都相同，进行整体层面迭代，兼顾功耗和相噪，分别给出 40 nA 和 20 nA 级别的两个 PFD 版本，记为 **PFD_n_upb_NAND**, 其中 `n_upb` 是指 negative-edge triggered, active-low UPB/DNB as the output ports, `NAND` 是指 NAND-based PFD
- (2) 将上面论文中的具体例子 "映射" 到我们的工艺库，进行参数微调，得到 NAND 尺寸优化之后的 PFD, 记为 **PFD_n_upb_NAND_optimized**, 其中 `NAND_optimized` 是指经过尺寸优化的 NAND-based PFD



### 8.3 NAND PFD (v1/v2/v3)


在 tb_PFD 中进行仿真迭代，主要是用 pss/pnoise 来仿真 PFD 的相位噪声性能，同时结合 tstab 的瞬态结果计算平均电流消耗 (IDD)，方便去除功耗过高的参数组合。

设置 PFD 的 pnoise 仿真时需要注意， PFD 是一个 jitter 型电路，其相位噪声主要体现在输出信号的时域抖动，因此 pnoise type 应设置为 **sampled (jitter)** 而不是 time average. 下面是一个具体的例子
- (1) 设置 delay_FB_perc = +20, 此时 UPB 作为输出信号，DNB 恒为 logic 1 保持不变
- (2) 设置 target = (UPB - VSS) 以及 trigger = (REF - FB) @ falling, threshold = `-0.5*VAR("VDD")` (这里不能用除以二 `/2` 否则会报错)
- (3) 同样设置 target = (UPB - VSS) 以及 trigger = (REF - FB) @ rising, threshold = `-0.5*VAR("VDD")`
- rising 仿的是 UPB 被激活时的第一边沿 (UPB is active-low, 所以是下降沿)，而 falling 仿的是 UPB 恢复 inactive 时的第二边沿 (上升沿)
- 在 output 中可以将这两个 phase noise 的低频结果取个平均，作为 PFD 相位噪声指标参考

<div class='center'>

| 思路 (1) PFD 迭代，参数总览 (未做筛选) | 参数总览 (筛选 IDD < 40 nA) | 参数总览 (筛选 IDD < 20 nA) |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-07-00-58-47_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-07-00-59-18_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-07-00-59-54_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | PFD_n_upb_NAND **(v1, 35 nA)** 参数为： | **(KA, WN, L) = (2.0, 1.68, 1.50)** | 开启边沿相噪 -110.6 dBc/Hz, 关闭边沿相噪 -122.6 dBc/Hz |
 | PFD_n_upb_NAND **(v2, 18 nA)** 参数为： | **(KA, WN, L) = (2.0, 0.84, 1.50)** | 开启边沿相噪 -106.1 dBc/Hz, 关闭边沿相噪 -119.5 dBc/Hz | 
 | PFD_n_upb_NAND **(v3, 11 nA)** 参数为： | **(KA, WN, L) = (2.5, 0.42, 1.50)** | 开启边沿相噪 -104.4 dBc/Hz, 关闭边沿相噪 -116.8 dBc/Hz | 
 | 作为对比，这里给出之前使用的 NOR-based PFD 参数与相噪： | 
 | PFD_p_up_NOR with ANDrst (v1, 14 nA)  | (KA, WN, L) = (2.5, 0.84, 0.18) | 开启边沿相噪 -89.04 dBc/Hz, 关闭边沿相噪 -75.21 dBc/Hz |
 | PFD_p_up_NOR with ANDrst (v2, 6.0 nA) | (KA, WN, L) = (1.0, 0.22, 0.36) | 开启边沿相噪 -81.19 dBc/Hz, 关闭边沿相噪 -64.92 dBc/Hz |
 | 可以看到，相比 NOR-based PFD, NAND-based PFD 在相噪方面的确有明显提升，这个提升是管子 length 提高带来的，还是结构本身带来的？看一下 0.18um 长度的 NAND-based PFD 即可知道： |
 | 0.18um PFD_n_upb_NAND | 6.0 nA, (KA, WN, L) = (2.5, 0.84, 0.18) | 开启边沿相噪 -88.94 dBc/Hz, 关闭边沿相噪 -87.72 dBc/Hz |
 | 0.18um PFD_n_upb_NAND | 2.8 nA, (KA, WN, L) = (1.0, 0.42, 0.36) | 开启边沿相噪 -84.26 dBc/Hz, 关闭边沿相噪 -93.85 dBc/Hz |
 | 由此得到两条结论： | **(1) 相比 NOR PFD,  NAND PFD 在功耗和相噪方面都有优势, 相噪优势主要体现在关闭边沿上** (NOR PFD 会不会是 ANDrst 有一个 INV 导致相噪不好？有待进一步讨论) | **(2) 适当提高管子 length 可以进一步改善相位噪声** |

</div>



### 8.4 NAND PFD (v4)



将这个例子转换到我们的 onc18 工艺库，经过仿真调试，得到下面的较优值：

<div class='center'>

| NAND (L = 0.18) | NMOS Width (um) | PMOS Width (um) | KA |
|:-:|:-:|:-:|:-:|
 | 1 | 0.22 | 2.20 | 10  |
 | 2 | 1.00 | 1.50 | 1.5 |
 | 3 | 1.10 | 0.22 | 0.2 |
 | 4 | 0.22 | 1.54 | 7.0 |
 | 9 | 0.22 | 0.22 | 1.0 |
</div>



### 8.5 simul. verification

为确保仿真效果，我们令 CP 的 digital devices 尺寸与 PFD 保持一致 (for NOR PFD)，对于 NAND 尺寸单独优化过的 `PFD_n_upb_NAND_optimized`，我们将其 NAND2/4 的尺寸赋给 digital devices in CP. 另外, CP 的模拟部分先保持不变，仍是 (KA, WN, L) = (2.5, 0.42, 8.00).

<span style='color:red'> 

开始仿真之前我们已经验证过 CP 有没有必要使用 Pass gate, **结论是完全不需要** ，使用 pass gate 反而会因为多一次 "开关抖动" 导致系统相噪变差，因此这里直接使用单个 MOS 作为 CP 的开关结构。

</span>


创建模块时注意同步修改 INV 和开关管的尺寸，然后利用 config sweep 切换不同 PFD/CP 模块，对上面一共四个版本的 PFD 进行仿真。


先做了简单的 Spectre FX 仿真，功能性验证通过后可以进行 Spectre X + CX 仿真：

<div class='center'>

| Spectre X + CX 仿真，耗时 42.2 ks (11h 44m 0s) | Note | Note |
|:-:|:-:|:-:|
 | 保持 PFD 不变，仅修改 CP 和 VDD 纹波后的结果如下 (方便作参考) ： <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-07-18-06-03_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | RVCO1 的 Je_n(t) 对比 (仅作出 CK_40 @ TT27) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-07-22-25-51_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | RVCO2 的 Je_n(t) 对比 (仅作出 CK_40 @ TT27) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-07-22-27-43_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 基于新的 CP 和 VDD 纹波，本次测试的几个新 PFD 结果如下： <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-07-18-06-30_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |  |  |

</div>

采用 采用 NAND-based PFD 时：
- (1) 功耗：
- (2) 相噪：
- (3) 其它：
    - (3.1) 启动时间：由于 NAND-based PFD 是 negative-edge triggered, 锁定时间由原来的 4 ms 增长到约 9 ms, 并且部分温度/工艺角下启动时间过慢 (> 30 ms), **需要添加额外的启动电路才能保证启动性能**


仿真时出现了一个启动问题，具体情况如下：

<div class='center'>

| 描述一 | 描述二 |
|:-:|:-:|
 | 采用新的 NAND-based PFD/CP 时，环路在某些特殊工艺角下无法正常启动 (启动时间 > 60 ms)，下面是能正常启动时的波形 (TT, 27°C) <br>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-07-15-37-28_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 下面是不能正常启动的波形 (FF, 130°C) <br>  |
 | 作为对比，我们也给出之前用 NOR-based 时的启动波形： | 可以看到，在上电之后，`CK_X40/X20/X10/X05` 等一系列时钟输出均被拉高, NOR-based PFD 通过比较 `REF/FB` 的上升沿，激活 `DN` 输出端，使整个系统能够正常启动 <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-07-15-23-39_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 原因是什么？ |


</div>

## 9. LPF Optimization

### 9.1 theoretical analysis

上面对 PFD 的优化并没有带来显著的相噪改善，差不多相当于白忙活。 **若无特别说明，下面仍使用 NOR-based PFD 进行仿真。**

考虑到环路主要是低频相位噪声较高，我们尝试对 LPF 进行优化 (修改环路参数) 来获得更好的相噪性能。具体而言：
- (1) 我们需要 **减小环路带宽** ，尽管这会使系统的锁定时间变长，但可以有效减小低频相位噪声
- (2) 电阻 R1 的热噪声主要是在 CP 被 "激活", R1 上有电流流过时才有影响，对于锁定后的相位噪声影响不大，因此我们可以适当增大 R1 来提高 PM (phase margin)，从而得到更低的环路带宽
- (3) 适当提升 alpha = C2/C1 的值，因为提高 C2 可以有效降低 CP 的开关噪声
- (4) 适当增大 C1 的值

下面是一系列具体参考值 (第一条为当前值)

<span style='font-size:12px'>
<div class='center'>

| (I_P, R_P, C_P) | tau_P | zeta | PM  | BW | BW ratio (f_in/f_BW) |
|:-:|:-:|:-:|:-:|:-:|:-:|
| **(10 nA, 10 MOhm, 30 pF)** | **0.30 ms** | **0.3775** | **40.99°** | **683.71 Hz** | **47.93** |
| (4  nA, 10 MOhm, 30 pF) | 0.30 ms | 0.2388 | 26.82° | 409.37 Hz | 80.04 |
| (6  nA, 10 MOhm, 30 pF) | 0.30 ms | 0.2924 | 32.49° | 510.87 Hz | 64.14 |
| (8  nA, 10 MOhm, 30 pF) | 0.30 ms | 0.3377 | 37.10° | 600.77 Hz | 54.54 |
| (10 nA, 10 MOhm, 30 pF) | 0.30 ms | 0.3775 | 40.99° | 683.71 Hz | 47.93 |
| (4  nA, 10 MOhm, 40 pF) | 0.60 ms | 0.4136 | 44.37° | 381.01 Hz | 86.00 |
| (6  nA, 10 MOhm, 40 pF) | 0.60 ms | 0.5065 | 52.35° | 490.11 Hz | 66.86 |
| (8  nA, 10 MOhm, 40 pF) | 0.60 ms | 0.5849 | 58.16° | 592.20 Hz | 55.33 |
| (10 nA, 10 MOhm, 40 pF) | 0.60 ms | 0.6539 | 62.57° | 690.56 Hz | 47.45 |
| (4  nA, 15 MOhm, 30 pF) | 0.45 ms | 0.3582 | 39.12° | 428.62 Hz | 76.45 |
| (6  nA, 15 MOhm, 30 pF) | 0.45 ms | 0.4386 | 46.63° | 545.68 Hz | 60.05 |
| (8  nA, 15 MOhm, 30 pF) | 0.45 ms | 0.5065 | 52.35° | 653.48 Hz | 50.14 |
| (10 nA, 15 MOhm, 30 pF) | 0.45 ms | 0.5663 | 56.86° | 756.15 Hz | 43.34 |
| (4  nA, 15 MOhm, 40 pF) | 0.60 ms | 0.4136 | 44.37° | 381.01 Hz | 86.00 |
| (6  nA, 15 MOhm, 40 pF) | 0.60 ms | 0.5065 | 52.35° | 490.11 Hz | 66.86 |
| (8  nA, 15 MOhm, 40 pF) | 0.60 ms | 0.5849 | 58.16° | 592.20 Hz | 55.33 |
| (10 nA, 15 MOhm, 40 pF) | 0.60 ms | 0.6539 | 62.57° | 690.56 Hz | 47.45 |


</div>
</span>

从中选出几个值得一试的：


<span style='font-size:12px'>
<div class='center'>

| (I_P, R_P, C_P) | tau_P | zeta | PM  | BW | BW ratio (f_in/f_BW) |
|:-:|:-:|:-:|:-:|:-:|:-:|
| **(10 nA, 10 MOhm, 30 pF)** | **0.30 ms** | **0.3775** | **40.99°** | **683.71 Hz** | **47.93** |
| (8  nA, 10 MOhm, 40 pF) | 0.60 ms | 0.5849 | 58.16° | 592.20 Hz | 55.33 |
| (6  nA, 10 MOhm, 40 pF) | 0.60 ms | 0.5065 | 52.35° | 490.11 Hz | 66.86 |
| (4  nA, 10 MOhm, 40 pF) | 0.60 ms | 0.4136 | 44.37° | 381.01 Hz | 86.00 |
| (6  nA, 15 MOhm, 40 pF) | 0.60 ms | 0.5065 | 52.35° | 490.11 Hz | 66.86 |
| (4  nA, 15 MOhm, 40 pF) | 0.60 ms | 0.4136 | 44.37° | 381.01 Hz | 86.00 |
| (4  nA, 15 MOhm, 30 pF) | 0.45 ms | 0.3582 | 39.12° | 428.62 Hz | 76.45 |


</div>
</span>

这新几个参数的 BW ratio 都在 65 以上 (原来是 47.93), 可以有效降低低频相噪，但启动时间会相应变长，仿真时需要注意这点。



### 9.2 simul. verification

算上原来的环路参数，一共是 7 种组合，对两种 RVCO 都进行仿真，详细设置如下：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 使用 NO pass gate 版本的 CP, 数字部分尺寸与 PFD 保持一致
- (3) LPF (14 points): 上面列出的 7 种组合，以及每种组合使用 alpha = C2/C1 = {1/8, 1/4} 两种
    - alpha = C2/C1 = {1/8, 1/4}
    - (I_P, R_P, C_P) = (10 nA, 10 MOhm, 30 pF), 原始参数，用于对比
    - (I_P, R_P, C_P) = (8  nA, 10 MOhm, 40 pF), 过渡参数，方便观察趋势
    - (I_P, R_P, C_P) = (6  nA, 10 MOhm, 40 pF)
    - (I_P, R_P, C_P) = (4  nA, 10 MOhm, 40 pF)
    - (I_P, R_P, C_P) = (6  nA, 15 MOhm, 40 pF)
    - (I_P, R_P, C_P) = (4  nA, 15 MOhm, 40 pF)
    - (I_P, R_P, C_P) = (4  nA, 15 MOhm, 30 pF)
- (4) VCO (2 points): 仍然使用 RVCO1_v1/RVCO2_v2 两种
- (5) FD (1 point): 尺寸仍保持 (KA, WN, L) = (1.0, 0.42, 0.18) 不变
- (6) VDD ripple (1 point): **0.2 kHz 和 300 kHz 两种纹波叠加 (注意不是用三种纹波)**
- (7) Corner (1 point): TT27 only
- (8) Start-up (1 point): NO start-up circuit
- (9) Else: transient time = 35 ms.
- 上面一共是 1 x 14 x 2 x 1 x 1 x 1 = 28 种组合



先用 Spectre FX + AX 试试水，效果如下：

<div class='center'>

| Spectre FX + AX 测试结果 |  |  |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-00-42-20_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-00-43-49_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 观察到电流减小后, **RMS Je 不降反升** ，这是为什么？是 FX 仿真的问题吗，还是我们对带宽/噪声关系的预测错误？ |

</div>



我们这里稍微修改下仿真条件再进行 Spectre X + CX 仿真：
- (6) VDD ripple (1 point): 从原来的 "0.2 kHz 和 300 kHz 两种纹波叠加" 改为 **"仅有 300 kHz 正弦纹波"**



<div class='center'>

| Spectre X + CX 仿真，耗时 35.1 ks (9h 44m 16s) |  |  |
|:-:|:-:|:-:|
 | 原理图设置 <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-10-19-12_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 仿真结果总览 <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-11-22-14_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 抖动与相噪总览 (未排序) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-11-23-42_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 抖动与相噪总览 (按 Jc_rms 排序) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-11-25-27_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 抖动与相噪总览 (按 Je_rms 排序) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-11-29-54_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 抖动与相噪总览 (按 I_P 排序) <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-11-30-40_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |

</div>

<div class='center'>

| Spectre X + CX 可视化分析 (MATLAB) | Jc_rms 可视化结果 | Je_rms 可视化结果 | Phase Noise at 1 kHz 可视化结果 |
|:-:|:-:|:-:|:-:|
 | 关于原自变量 $(I_P,\ R_1,\ C_1,\ C_2)$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-20-13-36_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-20-13-42_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-20-13-46_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 关于环路参数 $(\tau_P,\ \zeta,\ \alpha)$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-23-17-37_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-23-17-42_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-23-17-46_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>

``` bash

4  10 40 1/8
4  10 40 1/4
4  15 30 1/8
4  15 30 1/4
4  15 40 1/8
4  15 40 1/4
6  10 40 1/8
6  10 40 1/4
6  15 40 1/8
6  15 40 1/4
8  10 40 1/8
8  10 40 1/4
10 10 30 1/8
10 10 30 1/4

% Jc_rms @ RVCO1
2.567
2.582
2.579
2.572
2.579
2.583
2.587
2.594
2.587
2.607
2.575
2.600
2.594
2.583

% Je_rms @ RVCO1
115.8
172.1
116.5
172.7
127.0
151.7
102.1
130.1
86.85
114.4
82.52
105.5
61.38
80.21

$ phase_noise_1kHz-offset @ RVCO1
-37.98
-38.09
-42.33
-35.91
-41.56
-39.78
-43.52
-41.29
-44.85
41.93
-45.62
-43.32
-45.65
-45.00

% RVCO1 
2.567  115.8  -37.98
2.582  172.1  -38.09
2.579  116.5  -42.33
2.572  172.7  -35.91
2.579  127.0  -41.56
2.583  151.7  -39.78
2.587  102.1  -43.52
2.594  130.1  -41.29
2.587  86.85  -44.85
2.607  114.4  -41.93
2.575  82.52  -45.62
2.600  105.5  -43.32
2.594  61.38  -45.65
2.583  80.21  -45.00
```

``` bash
% Jc_rms @ RVCO2
2.274
2.278
2.283
2.284
2.281
2.285
2.280
2.280
2.297
2.293
2.294
2.288
2.330
2.300

% Je_rms @ RVCO2
107.8
129.1
86.73
108.1
91.37
115.1
79.04
100.7
88.17
91.78
65.00
81.64
47.02
63.40

% phase_noise_1kHz-offset @ RVCO2
43.01
40.75
44.44
42.23
44.23
39.89
45.92
43.47
42.12
44.21
45.78
45.71
50.72
48.12

% RVCO2
2.274 107.8 -43.01
2.278 129.1 -40.75
2.283 86.73 -44.44
2.284 108.1 -42.23
2.281 91.37 -44.23
2.285 115.1 -39.89
2.280 79.04 -45.92
2.280 100.7 -43.47
2.297 88.17 -42.12
2.293 91.78 -44.21
2.294 65.00 -45.78
2.288 81.64 -45.71
2.330 47.02 -50.72
2.300 63.40 -48.12
```

上面的仿真结果表明，降低环路带宽不仅没能降低相噪，反而使相噪变差了。这是为什么呢？我们也许需要重新审视一下环路参数对相噪的影响，这个后面再补上吧。


### 9.3 LPF sweep


从可视化结果的 "相关系数" 我们发现： 
- (1) 降低 Phase Noise at 1 kHz-offset (也即降低 edge jitter $J_{e,rms}$) 需要：
    - **降低 $\tau_P$ 和 $\alpha$**
    - **提高 $\zeta$**
- (2) 降低 cycle jitter $J_{c,rms}$ 需要：
    - RVCO1: 降低 $\tau_P$, $\alpha$, $\zeta$
    - RVCO2: 降低 $\zeta$, 提高 $\tau_P$, $\alpha$

于是考虑环路参数如下：
- (1) zeta >= 0.35 以保证系统稳定性
- (2) tau_P = 0.3 ms ~ 0.75 ms
- (3) alpha = C2/C1 = 1/20 ~ 1/5
- 原来的环路参数是 (10 nA, 15 MOhm, 30 pF) 或者 (10 nA, 10 MOhm, 30 pF)，分别对应 (zeta, tau_P) = (0.5663, 0.45 ms) 和 (0.3775, 0.30 ms) 由此给出值得尝试的环路参数范围：
    - zeta = 0.50 ~ 0.80 
    - tau_P = 0.15 ms ~ 0.45 ms
- 然后根据 I_P, R_1 和 C_1 的范围限制筛选出可行组合：
    - I_P = 4 nA ~ 20 nA
    - R_1 = 5 MOhm ~ 20 MOhm
    - C_1 = 20 pF ~ 50 pF



筛选结果如下：

<div class='center'>

| 筛选前 | 筛选后 | 进一步筛选后 |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-23-55-36_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-23-57-18_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-09-00-09-17_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |

</div>

### 9.4 simul. verification

上面给出了 14 组环路参数，再算上两个 RVCO 后一共是 28 种组合，这里先进行 Spectre FX 验证，仿真设置与结果如下：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 使用 NO pass gate 版本的 CP, 数字部分尺寸与 PFD 保持一致, 模拟部分尺寸仍是 (KA, WN, L) = (2.5, 0.42, 8.00)
- (3) LPF (14 points): 上图列出的 14 种组合，具体参数为
    - I_P = {12n    20n    20n    8n     12n    20n    20n    20n    10n    10n    15n    15n    20n    20n}
    - C_1 = {14.25p 23.75p 14.06p 18.62p 23.09p 32.33p 23.75p 18.19p 38.48p 22.77p 47.71p 29.45p 45.54p 30.06p}
    - R_1 = {17.54M 10.52M 17.79M 18.79M 15.16M 10.83M 14.73M 19.24M 11.69M 19.76M 09.43M 15.28M 09.88M 14.97M}
    - **C_2 = C_1/10** (等结果出来后我们再单独看看 alpha 变化的影响)
- (4) VCO (2 points): 仍然使用 RVCO1_v1/RVCO2_v2 两种
- (5) FD (1 point): 尺寸仍保持 (KA, WN, L) = (1.0, 0.42, 0.18) 不变
- (6) VDD ripple (1 point): 仅带有 300 kHz 正弦纹波 (注意只用一种纹波)
- (7) Corner (1 point): TT27 only
- (8) Start-up (1 point): NO start-up circuit
- (9) Else: transient time = **30 ms**
- 上面一共是 14 x 2 = 28 种组合

先做 Spectre FX + AX 仿真，功能性验证成功之后进行 Spectre X + CX 仿真，结果如下：

<div class='center'>

| Spectre X + CX 仿真结果，耗时 32.1 ks (8h 54m 24s) |  |  |
|:-:|:-:|:-:|
 | 结果总览 (按 RVCO 排序) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-09-16-57-58_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 结果总览 (按 IP 排序) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-09-16-59-17_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 结果总览 (按 Je_rms 排序) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-09-16-59-55_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | Je_rms 可视化总览 (MATLAB) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-09-17-55-26_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | Jc_rms 可视化总览 (MATLAB) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-09-17-55-40_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | Je_rms 与 Jc_rms 可视化结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-09-16-53-38_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 左图中，num.1 ~ num.14 为 RVCO1, num.15 ~ num.28 为 RVCO2，它们对应的环路参数如下： <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-09-16-54-28_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 作出这六组较优参数的 phase noise 进行对比 (RVCO1/2 各三组) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-09-18-14-49_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 综合 Jc_rms, Je_rms 和相噪曲线， **得出最佳的两个点分别是 Num.7 (RVCO1) 和 Num.18 (RVCO2)** | **Num.7 对应 (IP, R1, C1) = (20 nA, 10.52 MOhm, 23.75 pF) @ RVCO1** <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-09-19-14-39_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | **Num.18 对应 (IP, R1, C1) = (20 nA, 10.83 MOhm, 32.33 pF) @ RVCO2** <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-09-19-14-43_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |

</div>



``` bash
% IP @ RVCO1
15
20
10
20
20
15
20
20
15
10
08
20
12
20

% R1 @ RVCO1
09.43
09.88
11.69
10.83
14.97
15.28
14.73
10.52
15.16
19.76
18.79
19.24
17.54
17.79

$ C1 @ RVCO1
47.71
45.54
38.48
32.33
30.06
29.45
23.75
23.75
23.09
22.77
18.62
18.19
14.25
14.06

% IP, R1, C1 @ RVCO1
15 09.43 47.71
20 09.88 45.54
10 11.69 38.48
20 10.83 32.33
20 14.97 30.06
15 15.28 29.45
20 14.73 23.75
20 10.52 23.75
15 15.16 23.09
10 19.76 22.77
08 18.79 18.62
20 19.24 18.19
12 17.54 14.25
20 17.79 14.06

```

## 10. Stage Summary

到目前为止，我们已经完成了 PFD/CP (初步) 和 LPF 的优化，与导师进行简单讨论后，做出总结和下一步计划。

总结：
- (1) 我们之前做的 PFD 优化，主要是尝试了 NAND-based PFD 结构，但当时所用的管子 length 都比较长，达到了 1.5 um 左右 (根据 pnoise 结果选出来的)，但这样的长度真的合理吗？不太见得。因此，我们之后可能还会重新来优化 PFD 的尺寸，这次不会用过高的 length, 主要控制在 0.18 um ~ 0.36 um (不超过 0.54 um)
- (2) 电荷泵电流 IP 和 LPF 的优化结果还不错，改为更低的 $tau_P$ 和更高的 $\zeta$ 后，牺牲了一部分 Jc/Jcc 等高频抖动，但大幅度降低了 Je 这样的累积抖动 (从 120 mUI 降低到 30 mUi ~ 40 mUI)。但这样的参数不一定是最优，我们也许可以进一步提高 IP, 但在此之前，最好先改善一下 PFD/CP 的死区 (dead zone), 这才是能真正降低 Je 等累积抖动的根本方法
- (3) VCO 部分，基本上就是用现在的 RVCO1 和 RVCO2, 不再改动了
- (4) FD 部分，我们之前也没怎么优化过，一直用的保守尺寸 (KA, WN, L) = (1.0, 0.42, 0.18)，毕竟更大的尺寸功耗实在太大。但其实 FD 对相噪也有一定影响，之后可能会尝试优化一下
- (5) 其它：按导师那边会议结果，后面我们还需要设计一个可控制通断的 uA-level clock buffer, 以便将时钟信号引出到外部示波器进行测试

下一步计划：
- (1) 优化 CP dead zone: 主要尝试考虑 "增加 RST path delay" 这个最简单/直接的方法，其次是 CP 模拟部分的一些参数，最后看看论文里有没有能直接搬过来用的优化方案
- (2) 在优化 CP dead zone 之后，再次进行 LPF 参数优化 (主要是进一步提高 IP)；毕竟 dead zone 中等效 IP 只有原来的 20% 以下，而死区较大时，环路锁定后又相当于完全工作在死区，增大 IP 既可以理解为减小了死区，也可以理解为增大了死区等效电流 IP_dz
- (3) 优化 alpha of LPF: 目前我们一直用的都是 alpha = C2/C1 = 1/10, 但看某些经验认为更小的 alpha (比如 < 1/20) 对相噪是有利的，之后我们也可以尝试一下
- (4) 1.25V to 0.625V LDO: 按导师说法，我们这次功耗指标要求很严，目前除 VCO 外消耗电流约 150 nA, 后仿大约 240 nA, 再算上 VCO 和模块间的长连线，总电流很容易就超出 500 nA, 因此打算将数字部分 (主要是 FD) 电压从 1.25V 降到 0.625V, 以节省功耗。这样的话，数字部分功耗大约是原来的 1/4, 但由于 0.625V 过低，管子驱动能力有限，可能要加挺多 INV buffer 才能保证性能，所以最后功耗估计是原来的 1/3
- (5) uA-level clock buffer: 设计一个可控通断的超低功耗时钟缓冲器，将 PLL 输出时钟信号引出到外部示波器进行测试
- (6) nA-level clock buffer: 上面的大缓冲器是给外部测试用的，功耗允许高一些，但我们还需要设计一个 nA 级别的缓冲器，提高输出时钟的驱动能力，以便带动后续的数字电路；但这两个 buffer 都有一个问题，如果需求方不能确定输出频率，我们的 buffer 放在哪里？如果最后仍要保持选频功能，大概只能用一堆 TG 把 buffer 接在 FD 之后，根据不同输出频率，在 buffer "放到不同的位置"。如果是这样，我们大概就不用 4/1 MUX 了，直接用 TG. 但这样确实比较麻烦啊，如果 PFD/FD 用 0.625V 的话， PFD > CP 和 FD > Output 都需要做 level shift; 另一个也很关键的问题是, 0.625V 对 uhvt 管子来讲太低了，管子的开启会严重受限，如果又掺杂着 nom Vt device, 版图又不是很好做，也罢，这到后面再说吧。




## 11. Misc Optimization


### 11.1 preparation

可以尝试优化 PFD/CP ，主要目标是减弱死区 (dead zone)，从而降低 Je_rms 等累积抖动。


在开始优化之前，先看一下未做调整前整个 PFD/CP 的增益曲线是什么样子 (主要关注小相位差时)，利用 `ConfigSweep_PFD` 中的 `schematic_PFD_rstDelayX1` 进行仿真，效果如下：



<div class='center'>

| 仿真结果 | 大致建模 |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-01-17-41_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-01-30-17_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>

然后简单看一下 CP 模拟部分 ka 值对死区的影响 (也是 `schematic_PFD_rstDelayX1`)：



<div class='center'>

| 仿真结果 | 增大 KA | 增大 KA |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-01-12-51_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 会使 K_P 减小 | 会使 K_Z, K_N 增大 |
</div>

### 11.2 RST delay test


**INV delay unit 的宽度与 PFD 其它逻辑门相同，但长度取两倍以获得更佳的延迟特性？** (暂时没设置这个)

现在详细测试一下增加 RST path delay 对死区的影响，直接仿真 PFD/CP 的增益曲线即可，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-02-26-49_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>

唉，看来是几乎没有影响。这说明简单增大 minimum pulse width 并不能降低死区。



### 11.3 ka of CP


**<span style='color:red'> 仿真设置时发现, CP 模拟部分的 PMOS 宽度设置成了 `pPar("ana_wg")`，也就是说之前所有仿真实际上都是在用 `CPanalog_KA = 1.0`，在迭代记录中需要注意这一点。 </span>** 将 PMOS 宽度重新设置为 `pPar("ana_wg")*pPar("ana_ka")` 进行仿真，结果如下：


由于 analog_KA of CP 对环路的影响难以评估，我们直接在 PLL 环路中设置 KA = 1.0 ~ 3.0 进行仿真，具体设置如下：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (5 points): 使用 NO pass gate 版本的 CP, 数字部分尺寸与 PFD 保持一致，模拟部分尺寸基本不变，只改变 KA:
    - KA = {1.0, 1.5, 2.0, 2.5, 3.0}, WN = 0.42, L = 8.00
- (3) LPF (1 point): 使用分别对应 RVCO1/2 最佳点的 LPF 参数
    - RVCO1: (IP, R1, C1) = (20 nA, 10.52 MOhm, 23.75 pF)
    - RVCO2: (IP, R1, C1) = (20 nA, 10.83 MOhm, 32.33 pF)
    - C2 = C1/10 (alpha 先用着 1/10)
- (4) VCO (2 points): 仍然使用 RVCO1_v1/RVCO2_v2 两种分别用它们的最佳 LPF 参数
- (5) FD (1 point): 尺寸仍保持 (KA, WN, L) = (1.0, 0.42, 0.18) 不变
- (6) VDD ripple (1 point): 仅考虑 300 kHz 正弦纹波
- (7) Corner (1 point): (TT, 27°C)
- (8) Start-up (1 point): NO start-up circuit
- (9) Else: transient time = 15 ms. (当前 LPF 参数下 settling time < 5 ms, tran 30ms 耗时约 10h @ 4-thread)
- 上面一共是 5 x 2 = 10 种组合

Spectre X + CX 仿真结果如下：

<div class='center'>

| Spectre X + CX 仿真结果，耗时 2 x 7.14 ks (1h 59m 2s) = 14.28 ks (3h 58m 4s) |  |  |
|:-:|:-:|:-:|
 | 结果总览 (RVCO1) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-22-16-12_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>  | 结果总览 (RVCO2) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-22-16-33_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 三个工艺角下的波动情况 (错误地设置了所有 KA = 1, 将就看看工艺角吧) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-12-16-33_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 将 TT27 数据导出到 MATLAB 进行分析，数据导出顺序如下图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-12-22-20_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | MATLAB 可视化效果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-10-22-17-35_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | **左图可以看出，无论 RVCO1/2, 选取 KA = 2.0 是最佳方案 (Num.3 @ RVCO1, Num.8 @ RVCO2)** |

</div>


### 11.4 alpha of LPF

在上面 analog ka of CP = 2.0 的基础上，我们继续优化 alpha = C2/C1 对相噪的影响，具体设置如下：

- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 使用 NO pass gate 版本的 CP, 数字部分尺寸与 PFD 保持一致，模拟部分尺寸为 (KA, WN, L) = (**2.0**, 0.42, 8.00)
- (3) LPF (5 points): 使用分别对应 RVCO1/2 最佳点的 LPF 参数
    - RVCO1: (IP, R1, C1) = (20 nA, 10.52 MOhm, 23.75 pF)
    - RVCO2: (IP, R1, C1) = (20 nA, 10.83 MOhm, 32.33 pF)
    - C2 = alpha\*C1, alpha = {1/4, 1/8, 1/12, 1/20, 1/40} 共五种
- (4) VCO (2 points): 仍然使用 RVCO1_v1/RVCO2_v2 两种 (分别用它们的最佳 LPF 参数)
- (5) FD (1 point): 尺寸仍保持 (KA, WN, L) = (1.0, 0.42, 0.18) 不变
- (6) VDD ripple (1 point): 仅考虑 300 kHz 正弦纹波
- (7) Corner (1 point): (TT, 27°C)
- (8) Start-up (1 point): NO start-up circuit
- (9) Else: transient time = 15 ms. (当前 LPF 参数下 settling time < 5 ms, tran 30ms 耗时约 10h @ 4-thread)
- 上面一共是 5 x 2 = 10 种组合

Spectre X + CX 仿真结果如下：

<div class='center'>

| Spectre X + CX 仿真结果，耗时 2 x 8.82 ks (2h 27m 1s) = 17.64 ks (4h 54m 2s) |  |  |
|:-:|:-:|:-:|
 | 结果总览 (RVCO1) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-11-00-17-18_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 结果总览 (RVCO2) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-11-00-18-07_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 左边两张图可以看出, alpha 的值必须控制在一个合适的值才能有最佳性能。太大 (例如 > 1/5) 会导致 edge jitter 等累积抖动急剧升高，太小又无法有效抑制 $I_PR_1$ 开关纹波，导致各种抖动都增大 |
 | 将 TT27 数据导出到 MATLAB 进行分析，数据导出顺序同下图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-11-00-26-36_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | MATLAB 可视化效果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-11-00-35-09_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 左图可以看出，仿真的十个点中, Num.3 和 Num.8 为最佳 |
 | 对 RVCO1, alpha 最佳值在 1/8 ~ 1/20 之间 | 对 RVCO2, alpha 最佳值也在 1/8 ~ 1/20 之间 | **于是选取 alpha = 1/12 @ RVCO1, alpha = 1/11 @ RVCO2 作为最佳值** |
 | 上面之所以选取 alpha = 1/12 和 1/11, 是为了配合 LPF 参数 | 对 RVCO1, 我们将原环路参数 (IP, R1, C1, alpha) 从  (20 nA, 10.52 MOhm, 23.75 pF, 1/10) 改为 **(20 nA, 10.5 MOhm, 24 pF, 1/12)** | 对 RVCO2, 我们将原环路参数从 (20 nA, 10.83 MOhm, 32.33 pF, 1/10) 改为 **(20 nA, 10.5 MOhm, 33 pF, 1/11)** |
 | 这样, R1, C1 和 C2 的值都比较规整，方便我们利用 unit res/cap 做版图 | RVCO1 best point (Num.3) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-11-12-45-26_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | RVCO2 best point (Num.8) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-11-12-49-08_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>


</div>


### 11.5 size of FD


之前我们的 FD 都是一直用 (KA, WN, L) = (1.0, 0.42, 0.18) 的保守尺寸，主要是担心更大尺寸功耗过高，但其实 FD 对相噪也有一定影响，因此也尝试优化一下 FD 尺寸，具体设置如下：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 模拟尺寸为 (KA, WN, L) = (2.0, 0.42, 8.00), 数字部分尺寸与 PFD 保持一致
- (3) LPF (1 point): 使用刚刚得到的两组最佳 LPF 参数
    - RVCO1: (IP, R1, C1, alpha) = **(20 nA, 10.5 MOhm, 24 pF, 1/12)**
    - RVCO2: (IP, R1, C1, alpha) = **(20 nA, 10.5 MOhm, 33 pF, 1/11)**
- (4) VCO (2 points): 仍然使用 RVCO1_v1/RVCO2_v2 两种
- (5) FD (9 point): 第一个 FD2 尺寸从 (1.0, 0.42, 0.18) 改为 (1.5, 0.42, 0.18)，往后每一级 FD2 宽度依次乘上 `FD_co` (长度不变)，最后的 FD5 则与前一个 FD2 尺寸相同
    - 1st FD2: (FD_ka, FD_W1              , FD_lg)
    - 2nd FD2: (FD_ka, FD_W1\*FD_co       , FD_lg)
    - 3rd FD2: (FD_ka, FD_W1\*FD_co\*FD_co, FD_lg)
    - FD5:     (FD_ka, FD_W1\*FD_co\*FD_co, FD_lg)
    - FD_ka = {1.0, 1.2, 1.5}, FD_co = {1.0, 1.2, 1.5}, FD_W1/FD_lg = 0.42/0.18
- (6) VDD ripple (1 point): 仅考虑 300 kHz 正弦纹波
- (7) Corner (1 point): TT27 only
- (8) Start-up (1 point): no start-up circuit
- (9) Else: transient time = 15 ms. (当前 LPF 参数下 settling time < 5 ms)
- 上面一共是 3 x 3 x 2 = 18 种组合, 每次仿真五个点的话，大约要 4\*2.5h = 10h

仿真结果如下：

<div class='center'>

| Spectre X + CX 仿真结果，耗时 4 x 8 ks (2h 13m 21s) = 32 ks (8h 26m 42s) |  |  |
|:-:|:-:|:-:|
 | 结果总览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-12-02-35-14_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 将 TT27 数据导出到 MATLAB 进行分析，数据导出顺序同下图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-12-02-37-24_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | Je_rms 与 Jc_rms 可视化 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-12-03-04-32_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |

</div>

上图可以看出，目前尝试的 FD 尺寸对抖动的影响并不大，对 RVCO2 来说增大尺寸甚至会使抖动变大，因此最终还是保持原来的 FD 大小 (KA, WN, L) = (1.0, 0.42, 0.18) 不变。

## 12. Specification Update

2025.11.12, 需求方那边开会更新了一下设计目标，主要内容为：
- PLL 输入频率: 32.768KHz (来自晶振)
- PLL 输出频率: 一共四路输出，其中两路用于后级数字电路，另两路输出到 PAD 用于测试
    - (1) 一路给到 ADC, 频率为固定 98.304 kHz (X3),
    - (2) 一路给到数字电路, 记作 `sysclk`, 频率为 X6/X12/X24 可配置
    - (3) 一路将 ADC clk (X3) 输出到 PAD 用于测试 (此路可以被 disable)
    - (4) 最后一路将 sysclk (X6/X12/X24) 输出到 PAD 用于测试 (此路可以被 disable)
- 抖动要求: ADC clk (X3) rms cycle jitter < 100 ns, sysclk (X6/X12/X24) 要求暂未指明

于是更新一下我们的迭代计划：
- (1) 直接测试 X24/X48 性能：保持当前各模块参数不变，先给 FD 加上 clock retiming ，然后仿真验证一下 X24/X48 (以及有/无 retiming) 的性能情况，主要是功耗和抖动
- (2) 测试降压后的性能：将 PFD 和 FD chain 两部分供电降到 0.625V (or 0.8V), 在 PFD > CP 路径上加一个简单的 level shift (inverter 即可)，随后仿真验证 X24/X48 下的性能情况
- (3) CP 加入 OTA: 引入一个 < 10 nA 的 OTA 用于抑制 charge sharing, 随后仿真验证 (1) (2) 效果
- (4) 根据 (1)~(3) 确定供电方案，如果采用降压，即进入 LDO 设计
- (5) 主要结构完成之后，补上 4-to-1 MUX 和 output buffer, 这块后面再详细说明


## 13. 1.25V/0.625V Option Test

>注：本小节内容对比 1.25V 和 0.625V 供电方案下 PLL (数字部分) 的性能差异，从而选择最优供电方案，相关内容在这里已有，还另外整理成了一个文档提交给导师用于分析讨论，详见 [202510_onc18_CPPLL_ultra_low_lower (docs-1) 2025.11.13 PLL 性能评估结果 (Digital 1.25V or 0.625V)](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (docs-1) 2025.11.13 PLL 性能评估结果 (Digital 1.25V or 0.625V).md>).



### 13.1 Integer-3 FD

类比 Integer-5 FD 电路，可得 Integer-3 FD (50% duty) 的最简电路实现：

<div class='center'>

| **FD3_4DFF (duty = 50%)** 电路与仿真结果 |
|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-12-14-45-58_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |

</div>


**上面 FD3 中，主电路由两个 DFF 构成，得到 Divider = 2^(2-1) + 1 = 3; 而 FD5 中，主电路由三个 DFF 构成，得到 Divider = 2^(3-1) + 1 = 5; 以此类推，可以由上面结构任意 "加减" DFF 来得到 2^(N-1) + 1 的分频比，也即 3, 5, 9, 17, 33, 65, 129, 257... 等等。当然, 9/33/65/129 这样的分频比不是质数，不考虑最简实现的情况下也可用质因数分解后实现。**


### 13.2 1.25V option test

先用 Spectre FX + AX 简单测试：

<div class='center'>

| testbench 原理图设置 | FD chain without/with retiming 原理图 |  |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-12-17-33-57_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-12-17-35-05_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | Spectre FX + AX 仿真结果总览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-12-17-44-18_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |

</div>


然后用 Spectre X + CX 进行正式仿真，具体设置如下：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 模拟尺寸为 (KA, WN, L) = (2.0, 0.42, 8.00), 数字部分尺寸与 PFD 保持一致
- (3) LPF (1 point): 使用两组最佳 LPF 参数
    - RVCO1: (IP, R1, C1, alpha) = **(20 nA, 10.5 MOhm, 24 pF, 1/12)**
    - RVCO2: (IP, R1, C1, alpha) = **(20 nA, 10.5 MOhm, 33 pF, 1/11)**
- (4) VCO (2 points): 仍然使用 RVCO1_v1/RVCO2_v2 两种
- (5) FD (5+2 = 7 point):
    - CK_OUT = X24: 一共五种，分别是 `sche_FD24_X01`, `sche_FD24_X02`, `sche_FD24_X04`, `sche_FD24_X08` 和 `sche_FD24_X01_retiming`
    - CK_OUT = X48: 一共两种，分别是 `sche_FD48_X01` 和 `sche_FD48_X01_retiming` (1.25V @ X48 时功耗较高，没有必要尝试尺寸更大的 FD)
- (6) VDD ripple (1 point): 仅考虑 300 kHz 正弦纹波
- (7) Corner (1 point): TT27 only
- (8) Start-up (1 point): no start-up circuit
- (9) Else: transient time = 15 ms. (当前 LPF 参数下 settling time < 5 ms)
- 上面一共是 2 x 7 = 14 种组合，每次仿真五个点的话，大约要 3\*2.5h = 7.5h

<div class='center'>

| Spectre X + CX 仿真结果，耗时 3 x 8.05 ks (2h 14m 8s) = 24.15 ks (6h 42m 24s) |  |
|:-:|:-:|
 | 结果总览 (按 RVCO 排序) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-00-15-05_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 将 CK_X24 数据导出到 MATLAB 进行可视化和分析，数据导出顺序同下图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-00-26-00_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | Je_rms 和 Jc_rms 结果可视化 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-01-35-10_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | IDD, Je_rms 和 Jc_rms 共同对比 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-01-43-05_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>

对 1.25V Operation 来讲, 前仿就达到 450 nA 的点我们不予考虑，由此筛选出上面几个可行组合：

<div class='center'>

| Num | Argument | IDD | Je_rms | Jc_rms |
|:-:|:-:|:-:|:-:|:-:|
 | Num.1 | RVCO1 @ FDX24_X01            | 233.2 nA | 26.88 mUI | 3.70 mUI |
 | Num.6 | RVCO2 @ FDX24_X01            | 274.1 nA | 25.08 mUI | 3.18 mUI |
 | Num.7 | RVCO2 @ FDX24_X01_retiming   | 293.2 nA | 22.35 mUI | 3.01 mUI |
 | Num.11 | RVCO1 @ FDX48_X01           | 406.7 nA | 20.88 mUI | 2.30 mUI |
 | Num.12 | RVCO1 @ FDX48_X01_retiming  | 444.0 nA | 19.76 mUI | 2.34 mUI |
</div>

总这几个点中选取最佳方案：
- (1) RVCO1: 两个方案
    - Num.1 (RVCO1 @ FDX24_X01), IDD = 233.2 nA, Je_rms = 26.88 mUI, Jc_rms = 3.70 mUI
    - Num.11 (RVCO1 @ FDX48_X01), IDD = 406.7 nA, Je_rms = 20.88 mUI, Jc_rms = 2.30 mUI
- (2) RVCO2: 一个方案
    - Num.7 (RVCO2 @ FDX24_X01_retiming), IDD = 293.2 nA, Je_rms = 22.35 mUI, Jc_rms = 3.01 mUI

下面分别给出这三个方案的详细相噪结果：

<!-- <div class='center'>

| Num.1 (RVCO1 @ FDX24_X01), IDD = 233.2 nA, Je_rms = 26.88 mUI, Jc_rms = 3.70 mUI | Num.11 (RVCO1 @ FDX48_X01), IDD = 406.7 nA, Je_rms = 20.88 mUI, Jc_rms = 2.30 mUI | Num.7 (RVCO2 @ FDX24_X01_retiming), IDD = 293.2 nA, Je_rms = 22.35 mUI, Jc_rms = 3.01 mUI |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-13-32-18_临时文件.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-13-34-20_临时文件.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-13-34-27_临时文件.png"/></div> |
</div> -->

<div class='center'>

| Num | Argument | Output Freq. | IDD | Je_rms | Jc_rms | Phase Noise |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Num.1 | RVCO1 @ FDX24_X01            | 786.432 kHz | 233.2 nA | 26.88 mUI | 3.70 mUI | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-13-32-18_临时文件.png"/></div> |
 | Num.7 | RVCO2 @ FDX24_X01_retiming   | 786.432 kHz | 293.2 nA | 22.35 mUI | 3.01 mUI | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-13-34-27_临时文件.png"/></div> |
 | Num.11 | RVCO1 @ FDX48_X01           | 1.5729 MHz  | 406.7 nA | 20.88 mUI | 2.30 mUI | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-13-34-20_临时文件.png"/></div> |
</div>

**注意 Num.1 和 Num.7 的 VCO 工作频率为 CK_X24 (24 x 32.768 kHz = 786.432 kHz), 而 Num.11 的 VCO 工作在 CK_X48 (48 x 32.768 kHz = 1.5729 MHz)**



### 13.3 0.625V option test

先用 tb_FD 测试下 DFF 能否正常工作，其实也就是测试 DFF 中的逻辑门：



<div class='center'>

| FD 测试结果总览 (未排序) | FD 测试结果总览 (按 VDD 排序) | 0.625V 极限测试结果 |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-02-21-13_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-02-21-55_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-02-27-53_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |

</div>

上面结果表明, uhvt 器件/逻辑门在 0.625V supply 下确实没法工作，至少到 0.975V 左右才能正常工作。

在当前工艺库设置下，我们仅能使用 native/standard/ultra-high Vt 三种器件，而 std (nominal) Vt 器件的漏电又太大，因此 0.625V 甚至 0.8V 供电方案都不可行。





## 14. Best Option Test


### 14.1 OTA for CP

现在，我们终于来做一件 "几乎必做" 的事情——为电荷泵添加一个 OTA 用于抑制 charge sharing, 减小开关纹波，从而改善相噪。

设计考量如下：
- (1) 一方面，我们希望 OTA 有足够高的电路输出能力用于 "补偿" bypass 支路，这样才能把 V_bypass 拉到 V_cont 附近。在 IP = 20 nA 的情况下，这个电流最起码要 2 nA, 5 nA 才够保险，但我们又没法给 OTA 这么多电流，因此走一步看一步吧
- (2) 另一方面，由于 OTA 只需工作在 "直流" 状态下，因此 GBW 不需要太高，小电流完全可以胜任；至于 dc voltage gain, 其实不必要太大，差不多就行
- (3) 最后，结合 VCO 仿真结果知道，锁定后的 V_cont = 0.3 V ~ 0.4 V @ 1.28 MHz 偏低，因此 OTA 可以仅用 PMOS-input 差分对，而无需使用 constant-gm 结构 (节省一些电流)

更详细的 CP 优化可以参考下面这篇论文：

>[[1]](https://www.sciencedirect.com/science/article/abs/pii/S0167926017304741) M. K. Hati and T. K. Bhattacharyya, “Phase noise analysis of proposed PFD and CP switching circuit and its advantages over various PFD/CP switching circuits in phase-locked loops,” Integration, vol. 63, pp. 115–129, Sept. 2018, [doi: 10.1016/j.vlsi.2018.06.002.](https://www.sciencedirect.com/science/article/abs/pii/S0167926017304741)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-06-02-44-14_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div>


原先 CP 共消耗电流 $I_{DD,CP} = 3I_B = 3 I_P = 60 \ \mathrm{nA}$，现在作出修改：一方面将主支路电流设置为 $I_P = 4I_B$，两个偏置支路电流分别为 $I_B$；另一方面，给 CP 加上一个 OTA, 其偏置直接由 CP 偏置支路给出 (5 nA)。于是 CP 共消耗电流 $I_{DD,CP} = 6 I_B \sim 7 I_B = 1.5 I_P \sim 1.75 I_P = 30 \ \mathrm{nA} \sim 35 \ \mathrm{nA}$，**相比了之前起码节省了 25 nA.**

先用 Spectre FX + AX 简单测试，然后用 Spectre X + CX 进行 (全工艺角) 正式仿真，具体设置如下：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 由于输出尾电流源改成了 `multiplier = 4`，因此适当增加长度， **模拟尺寸为 (KA, WN, L) = (2.0, 0.42, 10.0)**, 数字部分尺寸与 PFD 保持一致
- (3) LPF (1 point): 使用两组最佳 LPF 参数
    - RVCO1: (IP, R1, C1, alpha) = **(20 nA, 10.5 MOhm, 24 pF, 1/12)**
    - RVCO2: (IP, R1, C1, alpha) = **(20 nA, 10.5 MOhm, 33 pF, 1/11)**
- (4) VCO (1 points): 仍然使用 RVCO1_v1/RVCO2_v2 两种
- (5) FD (3 point): 仅仿真上一小节得到的三种最佳方案:
    - Num.1 (RVCO1 @ FDX24_X01)
    - Num.7 (RVCO2 @ FDX24_X01_retiming)
    - Num.11 (RVCO1 @ FDX48_X01)
- (6) VDD ripple (1 point): 仅考虑 300 kHz 正弦纹波
- (7) Corner (8 point): 考虑下面八个工艺角
    - TT: 27°C, 40°C
    - SS: -40°C, 0°C, 65°C
    - FF: 0°C, 65°C, 125°C
- (8) Start-up (1 point): no start-up circuit
- (9) Else: transient time = 15 ms. (当前 LPF 参数下 settling time < 5 ms)
- 上面一共是 3 x 8 = 24 种组合，设置每次仿真 **6 points**, 耗时约 4\*2.5h = 10h

仿真结果如下：

<div class='center'>

| Spectre X + CX 仿真结果，耗时 3 x 9.3 ks (2h 35m 4s) = 27.9 ks (7h 45m 12s) |  |  |
|:-:|:-:|:-:|
 | 方案一结果总览 (Num.1, RVCO1 @ FDX24_X01) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-16-17-21_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 方案二结果总览 (Num.7, RVCO2 @ FDX24_X01_retiming) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-16-18-19_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 方案三结果总览 (Num.11, RVCO1 @ FDX48_X01) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-16-19-27_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | 将 CK_X24 和 CK_X03 数据导出，导出顺序同下图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-16-55-04_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 作出 IDD/Je_rms/Jc_rms 的箱线图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-17-50-10_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 下面给出三种方案的 **CK_24** 详细相噪结果 |
 | 方案一 (RVCO1 @ FDX24_X01) TT27 相噪结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-17-56-22_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 方案二 (RVCO2 @ FDX24_X01_retiming) TT27 相噪结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-17-57-42_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 方案三 (RVCO1 @ FDX48_X01) TT27 相噪结果 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-17-58-20_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 
</div>



``` bash

% IDD
% option 1, option 2, option 3

2.081136E-07 2.681383E-07 3.818391E-07
2.079652E-07 2.678644E-07 3.813230E-07
2.142857E-07 2.760771E-07 3.953657E-07
2.130349E-07 2.741298E-07 3.935243E-07
2.110272E-07 2.712672E-07 3.903869E-07
2.077638E-07 2.669361E-07 3.767392E-07
2.167085E-07 2.771812E-07 3.836992E-07
2.384766E-07 3.062954E-07 4.075421E-07



2.681383E-07
2.678644E-07
2.760771E-07
2.741298E-07
2.712672E-07
2.669361E-07
2.771812E-07
3.062954E-07


3.818391E-07
3.813230E-07
3.953657E-07
3.935243E-07
3.903869E-07
3.767392E-07
3.836992E-07
4.075421E-07
```




### 14.2 supply noise

上面的 VDD 仅含 300 kHz 正弦纹波，接下来验证一下环路在不同电源纹波下的性能。

用 Spectre X + CX 进行仿真，具体设置如下：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 由于输出尾电流源改成了 `multiplier = 4`，因此适当增加长度， **模拟尺寸为 (KA, WN, L) = (2.0, 0.42, 10.0)**, 数字部分尺寸与 PFD 保持一致
- (3) LPF (1 point): 使用两组最佳 LPF 参数
    - RVCO1: (IP, R1, C1, alpha) = **(20 nA, 10.5 MOhm, 24 pF, 1/12)**
    - RVCO2: (IP, R1, C1, alpha) = **(20 nA, 10.5 MOhm, 33 pF, 1/11)**
- (4) VCO (1 points): 仍然使用 RVCO1_v1/RVCO2_v2 两种
- (5) FD (3 point): 仅仿真上一小节得到的三种最佳方案:
    - Num.1 (RVCO1 @ FDX24_X01)
    - Num.7 (RVCO2 @ FDX24_X01_retiming)
    - Num.11 (RVCO1 @ FDX48_X01)
- (6) VDD ripple (4 point): 
    - (6.1) no ripple
    - (6.2) 300 kHz 
    - (6.3) 300 kHz + 0.2 kHz
    - (6.4) 300 kHz + 0.2 kHz + 1.0 kHz
- (7) Corner (1 point): 仅考虑 TT27
- (8) Start-up (1 point): no start-up circuit
- (9) Else: transient time = 25 ms. (当前 LPF 参数下 settling time < 5 ms)
- 上面一共是 3 x 4 = 12 种组合，设置每次仿真 **6 points**, 由于 tran = 25 ms, 耗时约 2 x 5h = 10h

仿真结果如下：


<div class='center'>

| Spectre X + CX 仿真结果，耗时 3 x 9.3 ks (2h 35m 4s) = 27.9 ks (7h 45m 12s) |  |
|:-:|:-:|
 | 结果总览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-14-18-04-12_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 左图可以看出，无论是 IDD, Je_rms, Jc_rms 还是 phase noise, 有无纹波的区别不大，甚至可以说基本上没啥区别 |
</div>


