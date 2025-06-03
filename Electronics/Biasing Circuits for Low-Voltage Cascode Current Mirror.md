# Biasing Circuits for Low-Voltage Cascode Current Mirror

> [!Note|style:callout|label:Infor]
> Initially published at 16:53 on 2025-06-02 in Beijing.


## General Considerations

低压共源共栅镜像负载如下所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-02-17-15-04_Biasing Circuits for Low-Voltage Cascode Current Mirror.png"/></div> 


先在台积电 180nm CMOS 工艺库 `tsmc18rf`中做一个基本的仿真，对它有一个定性的认识：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-02-20-45-12_Biasing Circuits for Low-Voltage Cascode Current Mirror.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-02-20-44-37_Biasing Circuits for Low-Voltage Cascode Current Mirror.png"/></div>

## Biasing Generation

下面我们就按照“实现难度”顺序，由易到难，讨论几种常见的偏置结构 (用于生成 $V_b$)。



### 1. diode-connected

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-16-29-28_Biasing Circuits for Low-Voltage Cascode Current Mirror.png"/></div>

在这种最基本的偏置结构中，$V_b$ 由 diode-connected 的 M4 生成。假设 M3 和 M5 的尺寸相同，都为 $a = \left(\frac{W}{L}\right)_{3,5}$, 按照平方律模型进行推导 (忽略 channel-length modulation)，可以得到 M4 的尺寸应为 $a_4 = \frac{a}{4} = \frac{1}{4}\cdot \left(\frac{W}{L}\right)_{3,5}$. 这种偏置结构的精度如何呢？由于 body-effect 和短沟道效应的影响，一方面晶体管 M5 的 $V_{TH}$ 会增大 (M3 不变)，另一方面平方律模型也会有偏差，因此这种结构的误差比较明显。但由于其实现简单，容易通过仿真进行矫正，在简单电路中仍然是一个不错的选择。

另外，在很多应用中, low-voltage cascode current mirror 的 M3 和 M5 尺寸并不相同，M3 的 $L$ 通常更大，以获得更大的输出阻抗。记 M3 和 M5 的尺寸分别为 $a_3 = \left(\frac{W}{L}\right)_{3}$ 和 $a_5 = \left(\frac{W}{L}\right)_{5}$, M4 尺寸的一个经验值是：

$$
\begin{gather}
a_4 = a_5 \parallel \frac{a_3}{3}
\end{gather}
$$


### 2. series transistor

第二种方法是通过两个“串联”的晶体管构成偏置。没错，晶体管除了作并联 multiplier 之外，还可以有串联上的等效，具体见文章 [知乎 > Self-Cascode Composite Transistor (晶体管的串联)](https://zhuanlan.zhihu.com/p/1895511081201420257)。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-16-40-01_Biasing Circuits for Low-Voltage Cascode Current Mirror.png"/></div>

这种方法从原理上讲，是与 diode-connected 类似的，但是 M7 的 body-effect 一定程度上修正了 M0 体效应带来的误差。 M6 和 M7 的平方律理论（或经验）尺寸为：

$$
\begin{gather}
\begin{aligned}
a_0 &= a_1 = a \Longrightarrow &&a_7 = a,\ a_6 = \frac{a}{3}\\
a_0 &\ne a_1 \Longrightarrow &&a_7 = a_0,\ a_6 = \frac{a_1}{3}
\end{aligned}
\end{gather}
$$



### 3. resistive-diode-connected

通过在 drain-resistor-gate 的类似 diode-connected 连接，使 current mirror 能够形成自偏置，无需外部电路。这种结构在 BGR 里用得比较多，毕竟 BGR 本身就是产生 $V_{REF}$ 或者 $I_{REF}$, 要是其内部电路还需要一个 $I_{REF}$, 那就无限套娃了。缺点就是电阻无法做得很大（自偏置形成的电流不能很小），毕竟“面积就是金钱”，做 BGR 最后做成了一大个 resistor “附带”几十个小晶体管便得不偿失了。当然，我们也可以用晶体管来实现这里的电阻，用更高的设计难度、更低的精度来换更小的面积。


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-16-58-51_Biasing Circuits for Low-Voltage Cascode Current Mirror.png"/></div>



## Reference

- [知乎 > 模拟 IC 设计——低压 cascode 电流镜怎么用？](https://zhuanlan.zhihu.com/p/588832807)
- [知乎 > Self-Cascode Composite Transistor (晶体管的串联)](https://zhuanlan.zhihu.com/p/1895511081201420257)
- [知乎 > 共源共栅补偿——Cascode Compensation](https://zhuanlan.zhihu.com/p/701456207)
