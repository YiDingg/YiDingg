# 求解答 TPS5430DDAR 构建的 Buck 电路输出异常

> [!Note|style:callout|label:Infor]
Initially published at 18:23 on 2025-02-24 in Beijing.

## 前言

我们利用 buck 芯片，构建 buck-boost 电路来获得负电压输出（不妨称为 inverting buck，实际上就是 buck-boost）。期望的转换是 inverting buck (buck-boost) : +5V to -12V，这可以等价于 buck 拓扑的 buck: +17V to +12V。但是，我们在测试时发现输出电压为 +0.2V（原始故障），与预期的 -12V 相差甚远。

经过一些努力，我们已经找出了原始问题的原因，但尚未完全解决异常输出，希望有网友能帮忙找出问题所在，感激不尽！

注：若读者对 buck 与 buck-boost 之间的等效不熟悉，可以先转到这篇文章：[YiDingg：Using Buck Topology as an Inverting Converter (Buck-Boost)](<Blogs/Electronics/Using Buck Topology as an Inverting Converter.md>)

我们先叙述问题的排查结果，将原始故障的记录放在文末，以供随时参考。


## 原始故障排查结果

截至目前，我们对电路进行了多方面的测试，以期找出问题所在。
- 先检查了输入电压正常，然后尝试了从 +5V 至 +12V 的电源输入，故障现象基本不变
- 在确认反馈电阻阻值正确，且芯片无虚焊后，我们对所用元件进行逐个排查
- 依次拆下并检查了二极管、电感、BOOT 电容和储能电容
- 当检查到储能电容（220uF 35V）时，我们发现电容已经损坏（表现为电容短路）；于是检查芯片 pin6 和 pin8 情况，发现两引脚间的电阻仅有 3.4Ohm，这显然不正常
- 用新的 TPS5430 测量两引脚间电阻，阻值在 10MOhm 以上
- 于是猜测是原始电容损坏（短路），导致芯片内部击穿，无法正常工作；这也解释了为什么焊接了三个芯片，都出现相同的故障
- 在一块新的板子上重新焊接芯片和元件（在焊接之前检查已元件是否正常），原始故障被修复，电路可以正常工作。
- 本以为故障已经完全解决，但此时却出现了新的故障！（在下面的测试中，如无特殊说明，负载都接 20Ohm 电阻）
- 按我们的设计指标，依据芯片的输入电压范围和最大占空比（以及我们选择的反馈电阻），输出电压的调整范围大约是 -3V ~ -23V 之间可调。但新的故障在于，当我们将输出电压（的绝对值）逐渐调高，达到约 -11.5V 时，芯片会发生周期性的开关（重启）现象，输出在 -11.5V 和 0V 之间跳变，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-12-41-24_DC-DC TPS5430DDAR 输出异常记录.png"/></div>

- 举个例子，我们将输出电压从 -3V 调整到 -11V，电路都能正常工作；继续调高电压，达到约 -11.5V 时，便会出现周期性的重启现象。我们将新故障的排查结果放在下一小节。类似地，新故障现象记录放在文末，以便随时参考。


## 新故障排查结果

若无特别说明，后文的测试中输入电压均为 +5V。

新故障主要表现为：输出电压增大到一定值，且负载电流达到一定值后（例如 -12 V 接 15Ohm），电路出现周期性的重启现象，减小负载电流（增大负载电阻）可恢复正常状态，如下图所示。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-12-41-24_DC-DC TPS5430DDAR 输出异常记录.png"/></div>


- 经过考察，当负载电流较小（例如负载电阻 100Ohm），或者输出电压较小时（例如输出 -10V），并不会出现故障现象。
- 为了得到更多信息，我们测量了输出和负载电阻分别为 -10V@1KOhm、-10V@15Ohm、-15V@1KOhm 时的 SW 开关波形和 Vout 输出波形，结果如下：

<div class='center'>

| 输出与负载 | 输出波形 | 开关波形 |
|:-:|:-:|:-:|
 | -10V@1KOhm (输出 10mA) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-00-53_DC-DC TPS5430DDAR 输出异常记录.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-12-59-18_DC-DC TPS5430DDAR 输出异常记录.png"/></div> |
  | -10V@15Ohm (输出 0.7A) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-02-29_DC-DC TPS5430DDAR 输出异常记录.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-03-53_DC-DC TPS5430DDAR 输出异常记录.png"/></div> |
 | -15V@1KOhm (输出 15mA) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-12-51-12_DC-DC TPS5430DDAR 输出异常记录.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-12-57-11_DC-DC TPS5430DDAR 输出异常记录.png"/></div> |
 | -15V@15Ohm (输出 1A) <br> (发生振荡前) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-06-21_DC-DC TPS5430DDAR 输出异常记录.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-07-19_DC-DC TPS5430DDAR 输出异常记录.png"/></div> |
</div>


## 原始故障现象记录

### 原始故障记录


电压测量设备：示波器 (Digilent 的 Analog Discovery 1)，100MS/s，10MHz 带宽：

| Pin | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Pin Name | BOOT | NC | NC | VSENSE | ENA | GND | VIN | SW |
 | Voltage | 4.70V | 0V | -1.2mV | 0.192V | 2.87V | 0.202V | 5.09V | -1.2mV |
 | Voltage (with respect to GND) | 4.50V | -0.2V | -0.2V | 0.010V | 2.67V | 0 | 4.89V | -0.2V |
 | Nominal Range | BOOT-PH = -0.3V to 6V |  |  | -0.3V~3V | -0.3V~7V |  | -0.3V~40V | -0.3V~40V |
</div>

下面是电路的原理图、 PCB Layout 和实物图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-09-45_DC-DC TPS5430DDAR 输出异常记录.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-09-50_DC-DC TPS5430DDAR 输出异常记录.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-09-53_DC-DC TPS5430DDAR 输出异常记录.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-09-56_DC-DC TPS5430DDAR 输出异常记录.png"/></div>

注：实物图中 220uF 储能电容在调试时已经焊接，照片中之所以没焊，是调试时取下来了。

### TPS5430 数据手册

下面是 TPS5430 的中英文数据手册：
- [TI 数据手册 (TPS5430: 3A、宽输入范围降压转换器)](https://www.ti.com/cn/lit/ds/symlink/tps5430.pdf)
- [TI Data Sheet (TPS543x: 3A, Wide Input Range, Step-Down Converter)](https://www.ti.com/lit/ds/slvs632k/slvs632k.pdf)


下面是 Data Sheet 提供的参考电路：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-11-09_DC-DC TPS5430DDAR 输出异常记录.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-11-12_DC-DC TPS5430DDAR 输出异常记录.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-28-13-11-15_DC-DC TPS5430DDAR 输出异常记录.png"/></div>



### 已确认无误的部分
- 芯片无虚焊 (包括 PowerPAD), 共焊接过三个芯片, 异常现象基本不变
- 反馈电阻阻值正确
- 输入电压 +5V 正常
- 将输入电压改为 +10V，异常现象无明显变化








































## 异常现象记录

我们在常规的 buck 拓扑的基础上，作一些变换，得到 inverting buck (实际上也就是 buck-boost) 以此获得负电压输出。期望的是 `inverting buck: +5V to -12V`，这等价于正常 buck 拓扑的 `buck: +17V to +12V`。但是，我们在测试时发现输出电压为 +0.2V，与预期的 -12V 相差甚远。下面是相关记录：

<div class='center'>

| 原理图 | PCB Layout | 实物图 |
|:-:|:-:|:-:|
 | <div class="center"><img height=120px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-24-18-40-29_DC-DC TPS5430DDAR 输出异常.png"/></div> | <div class="center"><img height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-24-20-02-04_DC-DC TPS5430DDAR 输出异常记录.png"/></div><br><div class="center"><img height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-24-20-02-25_DC-DC TPS5430DDAR 输出异常记录.png"/></div> | <div class="center"><img height=120px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-24-18-48-08_DC-DC TPS5430DDAR 输出异常记录.png"/></div> |
</div>

下面是 DataSheet 中的参考电路：

<div class='center'>

| 原理图 1 | 原理图 2 | PCB Layout|
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-24-19-05-26_DC-DC TPS5430DDAR 输出异常记录.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-24-19-05-54_DC-DC TPS5430DDAR 输出异常记录.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-24-19-06-27_DC-DC TPS5430DDAR 输出异常记录.png"/></div> |
</div>



## 已确认无误的部分

- 芯片无虚焊 (包括 PowerPAD), 共焊接过三个芯片, 异常现象基本不变
- 反馈电阻阻值正确
- 输入电压 5V 正常

## 类似案例参考

下面是利用 buck 芯片 TPS563201DDCR 实现的 +5V 转 -5V 电路（实际可转 -3V ~ -7V），已成功验证：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-24-21-01-38_DC-DC TPS5430DDAR 输出异常记录.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-24-21-00-40_Using Buck Topology as an Inverting Converter.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-24-21-00-55_Using Buck Topology as an Inverting Converter.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-24-21-04-12_DC-DC TPS5430DDAR 输出异常记录.png"/></div>

## 更详细的讨论

此文章已于 2025.02.25 停止更新，更多信息和最新讨论结果见 [https://zhuanlan.zhihu.com/p/26076121138](https://zhuanlan.zhihu.com/p/26076121138)。