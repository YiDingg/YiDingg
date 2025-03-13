# Voltage Linear Operation Board (电压线性运算器)

> [!Note|style:callout|label:Infor]
> Initially published at 18:13 on 2025-02-27 in Beijing.


## Infor

- Time: 2025.02.20
- Details: 8 units 共八路输出，包括两个 voltage follower 、两个 noninverting amplifier 、两个 inverting amplifier 、一个 voltage adder 和一个 voltage subtractor 。
- Relevant Resources: [https://www.123684.com/s/0y0pTd-hyuj3](https://www.123684.com/s/0y0pTd-hyuj3)

本文设计了几种常见的线性运算单元，例如同相/反相放大器、加法器和减法器。利用基本线性运算器的拓扑结构，我们可以轻松设计出多种所需的线性运算，像加法器和减法器，也可以实现更复杂的多元线性运算。

<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 |<div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-21-10-13_Voltage Linear Operation Board.png"/></div>|<div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-21-09-01_Voltage Linear Operation Board.png"/></div>|
</div>

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-21-09-20_Voltage Linear Operation Board.png"/></div> | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-21-08-42_Voltage Linear Operation Board.png"/></div> |
</div>



## 原理讲解


### Linear Operational Unit

本文，我们用下图所示的线性运算器电路来实现加法器和减法器的功能：

<div class='center'>

|  |  |
|:-:|:-:|
 | <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-18-00-12_Voltage Adder and Subtractor using Op Amp.png"/></div> | <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-18-00-26_Voltage Adder and Subtractor using Op Amp.png"/></div> |
</div>




### Adder and Subtractor (加法器和减法器)

要构建加法器，令 $R_m = R_4 = \infty$、$R_3 = R_f$、$R_1 = R_2 = R_p$；取 $u_1$ 和 $u_3$ 分别作为输入信号 $V_1$ 和 $V_2$，我们有：

$$
\begin{gather}
V_{out} = V_1 + V_2
\end{gather}
$$

要构建减法器，令 $R_m = R_2 = R_4 = \infty$、$R_3 = R_f$、$R_1 = R_p$；取 $u_1$ 和 $u_3$ 分别作为输入信号 $V_1$ 和 $V_2$，我们有：

$$
\begin{gather}
V_{out} = V_1 - V_2
\end{gather}
$$

下面的 LTspice 仿真验证了这两个结果：
<div class='center'>

| Adder | Subtractor |
|:-:|:-:|
 | <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-18-01-00_Voltage Adder and Subtractor using Op Amp.png"/></div> | <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-18-04-05_Voltage Adder and Subtractor using Op Amp.png"/></div> |
</div>



### Configuration Demo 

基于上面的线性运算器，选择合适的电阻值，我们可以实现很多电路。下面是两个例子：



<div class='center'>

|  |  |
|:-:|:-:|
 | <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-21-32-23_Voltage Linear Operation Board.png"/></div> | <div class="center"><img width=500px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-26-21-33-30_Voltage Linear Operation Board.png"/></div> |
</div>

## Test Results

若无特别说明，下面的测试在室温 (约 25°C) 下进行，VCC+ = +12V, VCC- = -12V, frequency response 中输入信号为 1V (实际约为 1.022V) amplitude (0 offset) 的 sine wave。

<div class='center'>

| Channel | Test Condition | Output 1 <br> (input 100KHz sine wave) | Output 2 <br> (input 100KHz RampUp) | Frequency Response |
|:-:|:-:|:-:|:-:|:-:|
 | Follower | $C_p = 20 \ \mathrm{pF}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-06-21_Voltage Linear Operation Board.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-07-16_Voltage Linear Operation Board.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-12-32_Voltage Linear Operation Board.png"/></div> |
 | Inverter | $A_v = -1$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-22-49_Voltage Linear Operation Board.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-23-12_Voltage Linear Operation Board.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-25-44_Voltage Linear Operation Board.png"/></div> |
 | Non-Inverter | $A_v = +2$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-29-32_Voltage Linear Operation Board.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-29-03_Voltage Linear Operation Board.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-28-42_Voltage Linear Operation Board.png"/></div> |
 | Adder | $V_1 = 4 \sin (\omega t)\ \mathrm{V},\ V_2 = 4 \ \mathrm{V}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-33-31_Voltage Linear Operation Board.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-34-23_Voltage Linear Operation Board.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-37-55_Voltage Linear Operation Board.png"/></div> |
 | Subtractor | $V_1 = 4 \sin (\omega t)\ \mathrm{V},\ V_2 = 4 \ \mathrm{V}$  | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-40-49_Voltage Linear Operation Board.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-41-11_Voltage Linear Operation Board.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-09-01-41-54_Voltage Linear Operation Board.png"/></div> |
</div>

我们还额外测试了 Follower 补偿电容从 20pF ~ 10nF 的频率响应 (分别测试了 20pF, 100pF, 1n 和 10nF)，事实证明，此范围中补偿电容变化对频率响应几乎无影响。