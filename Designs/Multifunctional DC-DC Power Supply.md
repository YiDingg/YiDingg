# All-in-one Multifunctional DC-DC Power Supply

> [!Note|style:callout|label:Infor]
Initially published at 10:02 on 2024-12-18 in Beijing.

>本文先给出具体的性能测试，然后介绍设计思路及原理等，另外，会将设计成品及数据手册总结到书籍 *[Practical Reference to Electronic Circuit Design](<Books/Practical Reference to Electronic Circuit Design.md>)* 中。如果读者对具体原理不感兴趣，只需参考电路图以复现设计，建议参考书籍而非网页（书籍内容精简且排版更正式）。

## 背景
受 Digilent 的 Analog Discovery 1 函数发生器功率限制（约 60 mW/channel ，事实上 AD2 也是约 60mW/channel ），很多元件的 I/V 特性不能完整测量。因此，想设计一个压控电压源（ voltage controlled voltage source ），可以由函数发生器控制，且有一定的响应速度（也即一定的 voltage slew rate ）。这样便从侧面提高了函数发生器的输出功率，可以更方便、完整地测量元件的 I/V 特性等。但是想了想，既然都有压控电压源了，不如直接设计一个多功能的、足以满足我自己绝大多数需求的 DC-DC 电源，作为自己今后的供电工具。这样，就可以不用再费心费钱购买各种电源，也不会因为电源功率不足而无法进行实验。


## Design Reference


### 设计要求


下面是设计至少需要满足的要求：
- **Input Voltage**: DC 12V, max 2A (24W)
- **Output**: 9 channels in total
    - Fixed Voltage Source (6 channels): $\pm$ 12V, $+$ 9V, $\pm$ 5V and $+$ 3.3V, guaranteed 1A for each channel.
    - Adjustable Current Source (1 channel): guaranteed 1A, voltage controlled or resistor controlled 
    - Adjustable Output Voltage (2 channels): guaranteed [-10V, +10V] and 500 mW per channel, voltage controlled or resistor controlled
- **Efficiency**: > 65%

### 设计思路


### 电路设计

### 电路参数及元件选择


### PCB 设计


## Data Sheet


### Features


### General Descriptions

这是一个多功能 DC-DC 电源，可以提供 6 通道固定电压输出，1 通道可调电流输出，以及 2 通道可调电压输出。

This is an all-in-one multifunctional DC-DC power supply, especially suitable for small electronic equipment, student lab, and programmable measurement.


### Pin Configuration and Functions

### Typical Applications
