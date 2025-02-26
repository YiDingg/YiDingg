# DC-DC TPS5430DDAR 输出异常

> [!Note|style:callout|label:Infor]
Initially published at 18:23 on 2025-02-24 in Beijing.

## 异常现象记录

原理图：

PCB Layout: 

实物照片：


<div class='center'>

| Pin | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Pin Name | BOOT | NC | NC | VSENSE | ENA | GND | VIN | PH |
 | Voltage | 4.70V | 0V | -1.2mV | 0.192V | 2.87V | 0.202V | 5.09V | -1.2mV |
 | Voltage (with respect to GND) | 4.50V | -0.2V | -0.2V | 0.010V | 2.67V | 0.022V | 4.89V | -0.2V |
 | Nominal Range | BOOT-PH = -0.3V to 6V |  |  | -0.3V~3V | -0.3V~7V |  | -0.3V~40V | -0.3V~40V |
</div>

## 已确认无误的部分

- 芯片无虚焊 (包括 PowerPAD), 共焊接过三个芯片, 异常现象基本不变
- 反馈电阻阻值正确
- 输入电压 5V 正常

