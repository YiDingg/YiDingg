# Voltage Adder and Subtractor using Op Amp

> [!Note|style:callout|label:Infor]
Initially published at 17:58 on 2025-02-20 in Lincang.

## Infor

- Time: 2025.02.20
- Details: 8 units 共八路输出，包括两个 voltage follower 、两个 noninverting amplifier 、两个 inverting amplifier 、一个 voltage adder 和一个 voltage subtractor 。
- Relevant Resources: [https://www.123684.com/s/0y0pTd-hyuj3](https://www.123684.com/s/0y0pTd-hyuj3)

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


### Linear Operational Element

本文，我们用下图所示的线性运算器电路来实现加法器和减法器的功能：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-18-00-12_Voltage Adder and Subtractor using Op Amp.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-18-00-26_Voltage Adder and Subtractor using Op Amp.png"/></div>

### Voltage Adder (加法器)

令 $R_m = R_4 = \infty$、$R_3 = R_f$、$R_1 = R_2 = R_p$；取 $u_1$ 和 $u_3$ 分别作为输入信号 $V_1$ 和 $V_2$，我们有：
$$
\begin{gather}
V_{out} = V_1 + V_2
\end{gather}
$$
下面的 LTspice 仿真验证了这个结果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-18-01-00_Voltage Adder and Subtractor using Op Amp.png"/></div>

### Voltage Subtractor (减法器)

令 $R_m = R_2 = R_4 = \infty$、$R_3 = R_f$、$R_1 = R_p$；取 $u_1$ 和 $u_3$ 分别作为输入信号 $V_1$ 和 $V_2$，我们有：
$$
\begin{gather}
V_{out} = V_1 - V_2
\end{gather}
$$
下面的 LTspice 仿真验证了这个结果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-20-18-04-05_Voltage Adder and Subtractor using Op Amp.png"/></div>