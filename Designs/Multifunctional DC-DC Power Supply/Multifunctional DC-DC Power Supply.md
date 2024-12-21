# Multifunctional DC-DC Power Supply (Design Reference)

> [!Note|style:callout|label:Infor]
Initially published at 10:02 on 2024-12-18 in Beijing.

>本文介绍设计思路及原理等，在 [Multifunctional DC-DC Power Supply (Data Sheet)](<Designs/Multifunctional DC-DC Power Supply/Multifunctional DC-DC Power Supply (Data Sheet).md>) 一文中会给出具体的性能测试，最后会将设计成品及性能总结到书籍 *[Practical Reference to Electronic Circuit Design](<Books/Practical Reference to Electronic Circuit Design.md>)* 中。如果读者对具体原理不感兴趣，只需参考电路图以复现设计，建议参考书籍而非网页（书籍内容精简且排版更正式）。

## 背景
受 Digilent 的 Analog Discovery 函数发生器功率限制（约 60 mW/channel），很多元件的 I/V 特性不能较为完整的测量，因此想设计一个压控电压源（Volatge controlled voltage Source），由函数发生器控制，这样便提高了可变电压的输出功率，可以更方便、完整地测量元件的 I/V 特性等。但是想了想，既然都有压控电压源了，不如直接设计一个多功能的
足以满足我自己绝大多数需求的 DC-DC 电源，作为自己今后的供电工具。这样，就可以不用再费心费钱购买各种电源，也不会因为电源功率不足而无法进行实验。


## Data Sheet


### General Descriptions

### Features


### Pin Configuration and Functions

### Typical Applications






### 设计目标

- **Input Voltage**: DC 13V~24V (3A max)
- **Output**: 9 channels in total
    - Fixed Voltage Source (6 channels): $\pm$ 12V, $+$ 9V, $\pm$ 5V and $+$ 3.3V 
    - Adjustable Current Source (1 channel): guaranteed 1A, voltage controlled or resistor controlled 
    - Adjustable Output Voltage (2 channels): guaranteed [-10V, +10V] and 500 mW per channel, voltage controlled or resistor controlled
- **Efficiency**: > 65%

### 设计思路


### 电路设计

### 电路参数及元件选择


### PCB 设计

