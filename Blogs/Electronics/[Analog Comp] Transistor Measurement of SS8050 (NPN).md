# Transistor Measurement of SS8050 (NPN) (NPN 三极管 SS8050 的测试实验记录)

> [!Note|style:callout|label:Infor]
> Initially published at 09:31 on 2025-03-15 in Beijing.


## SS8050 实验记录

本文测量了 SS8050 的常见特性曲线，测试结果大致符合理论预测，对认识 BJT 或其他类型晶体管有很大帮助。同时，我们保存了晶体管的实测数据，以便日后进行数据处理，求出 $g_m$, $\beta$, $r_O$ 等小信号参数，为小信号模型提供参考数据，

2025.03.14, 15:50, Beijing. 对 SS8050 进行了特性曲线测试，具体测试原理见 [Transistor Measurement Methods](<Blogs/Electronics/Transistor Measurement Methods.md>), 下面是实验记录：

用三个 DC-DC module 分别输出 +12V, -12V 和 +5V (用于电流表供电)；若无特别说明, +12V 作为 VCC 和 VCC_OPA+, -12V 作为 VCC_OPA-


<div class='center'>

**测试元件: SS8050**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-19-37-09_Transistor Measurement Methods.png"/></div>

| 测量序号 | 数据号 | $(y,\ x,\ var)$ | source and ammeter | test condition | 图片记录 |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | 1  | <span style='color:red'> 1 </span> | $(I_C,\ V_{CE},\ I_B)$ | V (Vce) + C (Ib) | $I_C\ (I_B)$ 大, $R_{I_B} = 1\ \mathrm{K\Omega}$ | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-18-06-47_Transistor Measurement Methods.png"/></div> |
 | 2  | <span style='color:red'> 1 </span> | $(I_C,\ V_{CE},\ I_B)$ | V (Vce) + C (Ib)| $I_C\ (I_B)$ 小, $R_{I_B} = 10\ \mathrm{K\Omega}$ | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-18-11-29_Transistor Measurement Methods.png"/></div> |
 | 3  | <span style='color:red'> 1 </span> | $(I_C,\ V_{CE},\ I_B)$ | V (Vce) + C (Ib) | <span style='color:red'> 3D</span>, $I_C\ (I_B)$ <span style='color:red'> 小 </span>, $R_{I_B} = 10\ \mathrm{K\Omega}$ | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-18-12-00_Transistor Measurement Methods.png"/></div> |
 | 4  | <span style='color:red'> 8 </span> | $(I_{B, actual},\ V_{CE},\ I_B)$ | V (Vce) + C (Ib, sou) | 同上, 改测 $I_{B}$, $R_{I_B} = 10\ \mathrm{K\Omega}$ | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-18-13-37_Transistor Measurement Methods.png"/></div> |
 | 5  | <span style='color:blue'> 6 </span> | $(V_{CE, sat},\ I_C,\ \beta=10)$ | C (Ic, sou) + C (Ib, -) | $I_C\ (I_B)$ 大| <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-18-22-51_Transistor Measurement Methods.png"/></div> |
 | 6 | <span style='color:blue'> 7 </span> | $(V_{BE, sat},\ I_C,\ \beta=10)$ |  C (Ic, sou) + C (Ib, -) | 同上, 改测 $V_{BE, sat}$ | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-18-24-14_Transistor Measurement Methods.png"/></div> |
 | 7  | <span style='color:blue'> 5 </span> | $(I_B,\ V_{CE},\ V_{BE})$ | V (Vce) + V (Vbe) | $I_C\ (I_B)$ 大| <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-19-23-26_Transistor Measurement Methods.png"/></div> |
 | 8  | <span style='color:blue'> 4 </span> | $(I_C,\ V_{CE},\ V_{BE})$ | V (Vce) + V (Vbe) | 同上, 改测 $I_{C}$ | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-19-24-58_Transistor Measurement Methods.png"/></div> |
 | 9  | <span style='color:red'> 2 </span> | $(I_C,\ V_{BE},\ V_{CE})$ | V (Vce, amp) + V (Vbe, -) |  $I_C\ (I_B)$ 大 | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-19-30-31_Transistor Measurement Methods.png"/></div> |
 | 10 | <span style='color:red'> 3 </span> | $(I_B,\ V_{BE},\ V_{CE})$ | V (Vce, amp) + V (Vbe, -) | 同上, 改测 $I_{B}$ | <div class="center"><img width=100px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-19-31-27_Transistor Measurement Methods.png"/></div> |
</div>

注：在本次实验中，为方便测量，同时保证测试条件的一致性，我们在 7, 8, 9, 10 四个测试中，都使用了 current sense amplifier 作为 ammeter (而不是使用电阻)。

我们还顺便额外测了一个 $(Ic,\ V_{CE},\ V_{BE})$ 的 3D 图，如下：
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-19-17-40_Transistor Measurement Methods.png"/></div>
 -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-14-19-26-47_Transistor Measurement Methods.png"/></div>


## 实验改进

经过此次实验，我们发现实验中存在一些小问题。因此，对原来的实验流程作出部分调整，同时规定整个实验中的电流测量范围，使测量更符合实际设计要求，便于实际设计时进行参考。

首先是电流 $I_C$ 的范围分级：

<div class='center'>

| Power Level | lower | low | moderate | high | higher |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | $I_C$ Range | $0 \sim 0.5 \ \mathrm{mA}$ | $0 \sim 5 \ \mathrm{mA}$ | $0 \sim 20 \ \mathrm{mA}$ | $0 \sim 100 \ \mathrm{mA}$ | $0 \sim 500 \ \mathrm{mA}$ |
 | Measurement Range | $0 \sim 0.5 \ \mathrm{mA}$ | $0 \sim 5 \ \mathrm{mA}$ | $0 \sim 25 \ \mathrm{mA}$ | $0 \sim 200 \ \mathrm{mA}$ | $0 \sim 1000 \ \mathrm{mA}$ |
</div>

对于大多数的 BJT ，或者说大多数的 BJT 电路，其晶体管的工作电流范围约在 $0 \sim 20 \ \mathrm{mA}$，也就是 moderate level 。除此之外，我们自己的设计也有相当一部分会在 $0 \sim 5 \ \mathrm{mA}$ 内工作。

因此，后续对其他晶体管进行测试时，我们先确定测量的档次，再进行实验。例如，选择 moderate level 时，我们会对 BJT 在  $0 \sim 25 \ \mathrm{mA}$ 内的特性进行较为全面的测试，同时，给出两个 $0 \sim 100 \ \mathrm{mA}$ 的静态特性 3D 图，以供参考。

改进后的实验流程（实验记录表）如下：


<div class='center'>

**被测元件: xxxx ， Ic 测量范围：0 \~ xx mA， 3D 图测量范围：0 \~ xx mA**

(这里是实物图)

| 测量序号 | 数据号 | $(y,\ x,\ var)$ | source and ammeter | test condition | 图片记录 |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | 1  | <span style='color:red'> 1 </span> | $(I_C,\ V_{CE},\ I_B)$ | V (Vce) + C (Ib) | <span style='color:red'> 3D</span>, $R_{I_B,eq} = \ \mathrm{\Omega}$ |  |
 | 2  | <span style='color:red'> 2 </span> | $(I_B,\ V_{CE},\ I_B)$ | V (Vce) + C (Ib) | <span style='color:red'> 3D</span>, $R_{I_B,eq} = \ \mathrm{\Omega}$ |  |
 | 3  | <span style='color:red'> 4 </span> | $(I_C,\ V_{CE},\ V_{BE})$ | V (Vce) + V (Vbe) | <span style='color:red'> 3D</span> |  |
 | 4  | <span style='color:red'> 5 </span> | $(I_B,\ V_{CE},\ V_{BE})$ | V (Vce) + V (Vbe) | <span style='color:red'> 3D</span> |  |

</div>

<div class='center'>

| 测量序号 | 数据号 | $(y,\ x,\ var)$ | source and ammeter | test condition | 图片记录 |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | 1  | <span style='color:red'> 1 </span> | $(I_C,\ V_{CE},\ I_B)$ | V (Vce) + C (Ib)| $I_C\ (I_B)$ 小, $R_{I_B} = \ \mathrm{\Omega}$ |  |
 | 2  | <span style='color:red'> 8 </span> | $(I_{B},\ V_{CE},\ I_B)$ | V (Vce) + C (Ib) | 同上, 改测 $I_{B}$ |  |
 | 3  | <span style='color:blue'> 5 </span> | $(I_B,\ V_{CE},\ V_{BE})$ | V (Vce) + V (Vbe) | $I_C\ (I_B)$ 大 |  |
 | 4  | <span style='color:blue'> 4 </span> | $(I_C,\ V_{CE},\ V_{BE})$ | V (Vce) + V (Vbe) | 同上, 改测 $I_{C}$ |  |
 | 5  | <span style='color:red'> 2 </span> | $(I_C,\ V_{BE},\ V_{CE})$ | V (Vce) + V (Vbe) |  $I_C\ (I_B)$ 大 |  |
 | 6  | <span style='color:red'> 3 </span> | $(I_B,\ V_{BE},\ V_{CE})$ | V (Vce) + V (Vbe) | 同上, 改测 $I_{B}$ |  |
 | 7  | <span style='color:blue'> 6 </span> | $(V_{CE, sat},\ I_C,\ \beta=10)$ | C (Ic) + C (Ib) | $I_C\ (I_B)$ 大 |  |
 | 8 | <span style='color:blue'> 7 </span> | $(V_{BE, sat},\ I_C,\ \beta=10)$ | C (Ic) + C (Ib) | 同上, 改测 $V_{BE, sat}$ |  |
</div>



