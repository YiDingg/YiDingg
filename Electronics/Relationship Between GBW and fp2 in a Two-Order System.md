# Relationship Between GBW and fp2 in a Tow-Order System

> [!Note|style:callout|label:Infor]
> Initially published at 11:58 on 2025-06-05 in Beijing.

在运放设计时，常常需要考虑多大的第二极点可以达到足够的相位裕度，也就是多大的 $\frac{f_{p2}}{\mathrm{GBW}}$ 比值可以满足相位裕度要求。本文从二阶系统的传递函数出发，推导了 $\mathrm{PM}$ 和比值 $\frac{f_{p2}}{\mathrm{GBW}}$ 之间的关系，为补偿操作提供了理论依据。


考虑一个仅有两个极点的二阶系统（假设零点以及更高阶极点可以忽略），系统的传递函数为：

$$
\begin{gather}
H(s) = \frac{H_0}{(1 + \frac{s}{\omega_{p1}})(1 + \frac{s}{\omega_{p2}})}
\end{gather}
$$

