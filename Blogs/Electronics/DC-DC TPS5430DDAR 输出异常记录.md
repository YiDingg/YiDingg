# DC-DC TPS5430DDAR 输出异常

> [!Note|style:callout|label:Infor]
Initially published at 18:23 on 2025-02-24 in Beijing.

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

测量结果：

| Pin | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Pin Name | BOOT | NC | NC | VSENSE | ENA | GND | VIN | PH |
 | Voltage | 4.70V | 0V | -1.2mV | 0.192V | 2.87V | 0.202V | 5.09V | -1.2mV |
 | Voltage (with respect to GND) | 4.50V | -0.2V | -0.2V | 0.010V | 2.67V | 0 | 4.89V | -0.2V |
 | Nominal Range | BOOT-PH = -0.3V to 6V |  |  | -0.3V~3V | -0.3V~7V |  | -0.3V~40V | -0.3V~40V |
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