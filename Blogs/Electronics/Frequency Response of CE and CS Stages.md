# Frequency Response of CE and CS Stages (共射/共源放大器的频率响应)

> [!Note|style:callout|label:Infor]
Initially published at 18:53 on 2025-04-07 in Beijing.

## 1. Intro

- 参考教材： *Fundamentals of Microelectronics (Razavi) (2nd edition, 2014)*, Chapter 11: Frequency Response
- 下载链接： [Fundamentals of Microelectronics (Razavi) (Second Edition, 2014).pdf](https://www.writebug.com/static/uploads/2025/4/8/5a55e0a23da277ad840c26464cc08ea5.pdf)

先给出共射/共源放大器频率响应的总结，再作详细的推导：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-18-08-15-19_Frequency Response of CE and CS Stages.png"/></div>

本文目录如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-18-08-21-44_Frequency Response of CE and CS Stages.png"/></div>

## 2. Transfer Function

Transfer function (传递函数), 一般写作 $H(s)$ 的形式，其中 $s$ 是拉普拉斯变换中的复变量。要从 transfer function 得到系统的频率响应，只需简单地令 $s = j\omega$，便得到频率响应的表达式 $H(j\omega)$。当然，在很多场景下，我们并不会去严格区分“传递函数”和“频率响应”这两个名称。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-22-31-29_Frequency Response of CE and CS Stages.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-22-31-50_Frequency Response of CE and CS Stages.png"/></div>



## 3. Bode Plot

手画 $H(s)$ 的函数图像对我们分析系统频响性能有很大帮助，由此发展出了 bode plot ，它是频率响应的一种近似画法，规则如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-22-33-17_Frequency Response of CE and CS Stages.png"/></div>

之所以把 bode plot 称为 bode approximation ，一个典型的例子是 "Complex poles may result in sharp peaks in the frequency response, an effect neglected in Bode’s approximation."


## 4. Node Pole Theorem

下面这个定理非常实用，可以快速求出系统的极点 (poles) ，是直觉上的好工具。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-22-36-32_Frequency Response of CE and CS Stages.png"/></div>

## 5. Miller's Theorem

米勒定理用于将一个“浮空”的阻抗转化为两个对地的阻抗，从而简化电路分析，其具体内容如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-22-38-01_Frequency Response of CE and CS Stages.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-22-38-25_Frequency Response of CE and CS Stages.png"/></div>

特别地，作为一个例子，我们可以在差分-差分放大器中，使用米勒定理来进行电容补偿，以降低等效输入电容：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-22-50-18_Frequency Response of CE and CS Stages.png"/></div>

上面的米勒定理，如果满足定理使用条件的话，并没有作任何的近似，是完全等价的变化。但需要注意的是，米勒定理的内容中并没有对定理的适用条件作规定，因此使用时要谨慎。下面是一些经验法则：
- 当两个节点 A, B 之间有且仅有一条通路时（阻抗 $Z$ 在这条通路上），米勒定理通常 <span style='color:red'> 不适用 </span>。
- 使用米勒定理时，要注意这个等效是在 small-signal 下的，还是 large-signal 下的（会影响直流工作点的求解）

注意，在利用米勒定理分析放大器的频率响应时，我们通常会用放大器的 midband gain 作为 $A_v$，并由此求出系统的零极点。显然，这一步作了近似，称为 "Miller approximation"，因为不同频率下有不同的 gain ，而我们直接使用了 midband gain 作为 $A_v$。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-22-53-48_Frequency Response of CE and CS Stages.png"/></div>

## 6. High-Frequency Model

BJT 的高频模型：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-22-58-17_Frequency Response of CE and CS Stages.png"/></div>

MOSFET 的高频模型：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-22-58-58_Frequency Response of CE and CS Stages.png"/></div>

总结下来就是：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-22-59-11_Frequency Response of CE and CS Stages.png"/></div>



## 7. Transit Frequency f_T

Transit frequency $f_T$ (transition frequency), 称为“截止频率”或“转移频率”, 实际中也常直接看作 Current Gain Bandwidth Product, 是晶体管的重要参数之一，它与晶体管的响应速率呈正相关。一般情况下，$f_T$ 越大，晶体管速度越快，高频性能越好。$f_T$ 定义为：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-23-03-50_Frequency Response of CE and CS Stages.png"/></div>

进一步地，对于常规的长沟道 MOSFET, 我们有 $C_{GS} = W C_{ov,GD} + \frac{2}{3} WL C_{ox} > \frac{2}{3} WL C_{ox}$ (也可以写作约等于, 因为前一项一般比较小)，于是：（忽略沟道调制效应）

$$
\begin{gather}
\omega_T = \frac{g_m}{C_{GS}} < \frac{\mu_n C_{ox} \frac{W}{L} (V_{GS} - V_{TH})}{\frac{2}{3} WL C_{ox}} = \frac{3\mu_n}{2 L^2} (V_{GS} - V_{TH})
\end{gather}
$$

我们还可以用电感进行补偿，从而提高 $f_T$ ：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-23-18-16_Frequency Response of CE and CS Stages.png"/></div>

$f_T$ 更精确的表达式如下：

$$
\begin{gather}
\mathrm{MOS:\ \ } 
\omega_T = \sqrt{\frac{g_m^2}{C_{GS}^2 + 2 C_{GS}C_{GD}}} \approx \frac{g_m}{C_{GS}},\quad 
f_T \approx \frac{g_m}{2\pi C_{GS}} 
\\
\mathrm{BJT:\ \ }
\omega_T = \sqrt{\frac{g_m^2 - \frac{1}{r_{\pi}^2}}{C_{\pi}^2 + 2 C_{\pi}C_{\mu}}} \approx \frac{g_m}{C_{\pi}},\quad 
f_T \approx \frac{g_m}{2\pi C_{\pi}} 
\end{gather}
$$

下面是具体推导过程：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-10-19-38-03_Frequency Response of CE and CS Stages.png"/></div>

也就是：



另外提一句，测量实际晶体管的 $f_T$ 时，通常是测量某一较高频率下的 current gain (例如 50MHz)，然后用 Current Gain Bandwidth Product 作为 $f_T$。

## 8. Freq Response of CS/CE

### 8.1 Low-Mid-Freq Resp.

CS Stage 采用 $C_S$ (下图中的 $C_b$) 来 cancel degeneration 以提高 midband gain 时，电容会影响中低频响应：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-23-21-00_Frequency Response of CE and CS Stages.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-23-21-39_Frequency Response of CE and CS Stages.png"/></div>

简单来讲，就是导致了一个零点和一个极点：

$$
\begin{gather}
\omega_z = \frac{1}{R_S C_S},\quad \omega_p = \frac{1 + g_m R_S}{R_S C_S}
\end{gather}
$$

### 8.2 Miller Approximation

利用 Miller approximation 求解 High-Frequency Response 时，为了能同时得到 CS 和 CE 的求解结果，我们将这两个 stages 统一为下图的形式 (unified model):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-23-29-19_Frequency Response of CE and CS Stages.png"/></div>

化简到  Figure 11.30 之后，求解便简单了。利用我们前面提到的 Node Pole Theorem, 我们可以很快地求出系统的（两个）极点：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-23-30-31_Frequency Response of CE and CS Stages.png"/></div>

通常情况下我们都有 $ \omega_{out} > \omega_{in}$，如果故意想让 $\omega_{out} < \omega_{in}$，需要满足：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-23-32-31_Frequency Response of CE and CS Stages.png"/></div>

也就是：

$$
\begin{gather}
C_{CE} + C_{\mu} - g_m (R_S \parallel r_{\pi}) C_{\mu} > 0 \Longleftrightarrow 
C_{CE} > \left[g_m (R_S \parallel r_{\pi}) - 1 \right] C_{\mu} 
\\
\mathrm{and\ \ }
R_L > \frac{(R_S \parallel r_{\pi}) C_{\pi}}{C_{CE} + C_{\mu} - g_m (R_S \parallel r_{\pi}) C_{\mu}}
\end{gather}
$$


需要注意的是，沟道宽度 W 的减半会使得所有的寄生电容减半，例如：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-23-38-13_Frequency Response of CE and CS Stages.png"/></div>

### 8.3 Precision Analysis

下面我们用普通的 KCL/KVL 来分析 CS 和 CE Stage 的频率响应，以得到精确的结果，并与上面的结果进行比较。推导过程比较繁琐，我们直接黏在这里，并在图片之后给出结论：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-23-41-33_Frequency Response of CE and CS Stages.png"/></div>

结论为：

$$
\begin{gather}
\frac{V_{out}}{V_{Thev}} = -g_m R_L \cdot \frac{1 - \frac{s}{\frac{g_m}{C_{XY}}}}{a s^2 + bs + 1}
\\
\mathrm{where\ } a = R_{Thev}R_L \left( C_{in} C_{XY} + C_{in} C_{out} + C_{XY}C_{out} \right)
\\
b = (1 + g_m R_L) R_{Thev} C_{XY} + R_{Thev} C_{in} + R_L (C_{XY} + C_{out})
\\ \Longrightarrow 
\begin{cases}
\frac{1}{\omega_{p1}}\frac{1}{\omega_{p2}} = a\\
\frac{1}{\omega_{p1}} + \frac{1}{\omega_{p2}} = b
\end{cases}
\\ \Longrightarrow 
\begin{cases}
\omega_{zero} = \frac{g_m}{C_{XY}} \\
\omega_{p1} = \frac{2}{b + \sqrt{b^2 - 4a}} \approx \frac{1}{b}\\
\omega_{p2} = \frac{2}{b - \sqrt{b^2 - 4a}} \approx \frac{b}{a}\\
\end{cases}
\end{gather}
$$

上面的“约等于”近似，利用的是 $\omega_{p2} \gg \omega_{p1}$，这也等价于 $b \gg a$，称为 <span style='color:red'> dominant-pole approximation </span> (主极点近似)。

对于第一个极点 $\omega_{p1}$，其分母为 $b = (1 + g_m R_L) R_{Thev} C_{XY} + R_{Thev} C_{in} + {\color{red} R_L (C_{XY} + C_{out})}$, 比 Miller approximation 多了第三项 $R_L (C_{XY} + C_{out})$ 。
特别地，为了更好的对比 Miller approximation, dominant-pole approximation 和 precision result 的结果，我们看下面这个例题：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-23-53-21_Frequency Response of CE and CS Stages.png"/></div>

## 9. Input/Output Impedance

我们用 Miller approximation 来求解 input impedance:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-07-23-58-27_Frequency Response of CE and CS Stages.png"/></div>

同样的道理，求解输出阻抗时，我们有：

$$
\begin{gather}
\mathrm{BJT:\ \ } Z_{out} \approx \frac{1}{\left[ C_{CS} + \frac{C_{\mu}}{1 + g_m R_C} \right]} \parallel R_C \parallel R_{coll}
\\
\mathrm{MOS:\ \ } Z_{out} \approx \frac{1}{\left[ C_{DB} + \frac{C_{GD}}{1 + g_m R_D} \right]} \parallel R_D \parallel R_{drain}
\end{gather}
$$

## Summary

为方便查阅，我们将共射/共源放大器的结论总结在下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-18-08-15-19_Frequency Response of CE and CS Stages.png"/></div>