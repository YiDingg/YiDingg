# Relationship Between GBW and fp2 in a Two-Order System

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 11:58 on 2025-06-05 in Beijing.

## Introduction

在运放设计时，常常需要考虑多大的第二极点可以达到足够的相位裕度，也就是多大的 $\frac{f_{p2}}{\mathrm{GBW}_f}$ 比值可以满足相位裕度要求。本文从二阶系统的传递函数出发，推导了 $\mathrm{PM}$ 和比值 $\frac{f_{p2}}{\mathrm{GBW}_f}$ 之间的关系，为补偿操作提供了理论依据。

## GBW and Omega_u

考虑仅有两个极点的二阶系统（假设零点以及更高阶极点可以忽略），系统的传递函数为：

$$
\begin{gather}
A(s) = \frac{A_0}{(1 + \frac{s}{\omega_{p1}})(1 + \frac{s}{\omega_{p2}})},\quad \mathrm{GBW}_\omega = A_0 \,\omega_{p1} 
\end{gather}
$$

注意 $\mathrm{GBW}_\omega$ 和 $\omega_u$ 的定义是不同的，对于 $\omega_u$，我们有：

$$
\begin{gather}
|A(j \omega_u)| = 1 \Longrightarrow \omega_u = \frac{1}{\sqrt{2}}\cdot \left[ 
\sqrt{\omega_{p1}^4 + \omega_{p2}^4 + 4 A_0^2 \omega_{p1}^2 \omega_{p2}^2 - 2 \omega_{p1}^2 \omega_{p2}^2} - \omega_{p1}^2 - \omega_{p2}^2
\right]^{\frac{1}{2}}
\end{gather}
$$

这是一个非常不友好的结果，对我们的设计没有丝毫帮助。放在这里仅作为参考，下面我们将用另一种思路来推导 $\mathrm{PM}$ 和 $\frac{\omega_{p2}}{\mathrm{GBW}_{\omega}}$ 之间的关系。

<!-- 这个结果看着就非常不友好，我们作一些近似：

$$
\begin{align}
\omega_u &= \frac{1}{\sqrt{2}}\cdot \left[ 
\sqrt{\omega_{p1}^4 + \omega_{p2}^4 + 4\,\mathrm{GBW}_\omega^2 \, \omega_{p2}^2 - 2 \omega_{p1}^2 \omega_{p2}^2} - \omega_{p1}^2 - \omega_{p2}^2
\right]^{\frac{1}{2}}
\\
& \approx \frac{1}{\sqrt{2}}\cdot \left[ 
\sqrt{\omega_{p2}^4 + 4\,\mathrm{GBW}_\omega^2 \, \omega_{p2}^2} - \omega_{p2}^2
\right]^{\frac{1}{2}}
\\
&=  \frac{1}{\sqrt{2}}\cdot \left[ \omega_{p2}^2
\sqrt{1 + \left(\frac{2\,\mathrm{GBW}_\omega}{\omega_{p2}}\right)^2} - \omega_{p2}^2
\right]^{\frac{1}{2}}
\\
&\approx  \frac{1}{\sqrt{2}}\cdot \left[ \omega_{p2}^2
\left(1 + \frac{x}{2} - \frac{x^2}{8} - 1 \right)
\right]^{\frac{1}{2}}\quad {\footnotesize x = \left(\frac{2\,\mathrm{GBW}_\omega}{\omega_{p2}}\right)^2 = \frac{4\,\mathrm{GBW}_\omega^2}{\omega_{p2}^2} }
\\
& =  \frac{1}{\sqrt{2}}\cdot \left[ \omega_{p2}^2
\left( \frac{2\, \mathrm{GBW}_\omega^2}{\omega_{p2}^2} - \frac{2\, \mathrm{GBW}_\omega^4}{\omega_{p2}^4} \right)
\right]^{\frac{1}{2}}
\\
& = \sqrt{\mathrm{GBW}_\omega^2 - \frac{\mathrm{GBW}_\omega^4}{\omega_{p2}^2}}
\\
& = \mathrm{GBW}_\omega \cdot \sqrt{1 - \left(\frac{\mathrm{GBW}_\omega}{\omega_{p2}}\right)^2}
\end{align}
$$

也就是说，当 $\omega_{p2}$ 足够大时，$\omega_u \approx \mathrm{GBW}_\omega$；但是 $\omega_{p2}$ 不够大时，$\omega_u < \mathrm{GBW}_\omega$ 会逐渐减小，这与直觉相符合。 -->

## PM and Omega_p2

还是以上面的两极点系统为例，假设 $\omega_u \gg \omega_{p1}$, 则 $\omega \to \omega_u$ 时，系统的传递函数可以写为：

$$
\begin{gather}
A(j\omega_u) = \frac{A_0}{(1 + j\frac{\omega_u}{\omega_{p1}})(1 + j\frac{\omega_u}{\omega_{p2}})} 
\approx \frac{A_0}{j\frac{\omega_u}{\omega_{p1}}}\cdot \frac{1}{1 + j\frac{\omega_u}{\omega_{p2}}} 
\end{gather}
$$

前一项的相位恒为 $-90^\circ$，后一项的相位为 $\theta = - \angle \left(1 + j\frac{\omega_u}{\omega_{p2}}\right) = - \arctan \left(\frac{\omega_u}{\omega_{p2}}\right)$, 两者相加即为 phase shift, 要得到 phase margin 需要再加上 $180^\circ$：

$$
\begin{gather}
\mathrm{PM} = 180^\circ + \left[-90^\circ - \arctan \left(\frac{\omega_u}{\omega_{p2}}\right)\right] = \arctan  \left(\frac{\omega_{p2}}{\omega_u}\right)
\end{gather}
$$

也就是说，相位裕度由 $\omega_{p2}$ 和 $\omega_u$ 之间的比值直接确定，记此比值为 $k$，即 $k = \frac{\omega_{p2}}{\omega_u}$，这时再考虑 $\omega_u$ 和 $\mathrm{GBW}_\omega$ 之间的关系：

$$
\begin{align}
|A(j\omega_u)| &\approx \left|\frac{A_0}{j\frac{\omega_u}{\omega_{p1}}} \cdot \frac{1}{1 + j\frac{\omega_u}{\omega_{p2}}}\right|
\\
&=\left| \frac{A_0\, \omega_{p1}}{j\omega_u} \cdot \frac{1}{1 + j \frac{1}{k} }\right|
\\
&= \left|\frac{\mathrm{GBW}_\omega}{j\omega_u} \right|\cdot \left|\frac{1}{1 + j\frac{1}{k}}\right|
\\
&= \frac{\mathrm{GBW}_\omega}{\omega_u} \cdot \frac{1}{\sqrt{1 + \frac{1}{k^2}}}
\\
&= \frac{\mathrm{GBW}_\omega}{\omega_u} \cdot \frac{k}{\sqrt{k^2 + 1}}
\\
&= 1
\end{align}
\\
\Longrightarrow \quad \mathrm{GBW}_\omega = \omega_u \cdot \frac{\sqrt{k^2 + 1}}{k}
\\
\frac{\omega_{p2}}{\mathrm{GBW}_\omega} = \frac{\omega_{p2}}{\omega_u \cdot \frac{\sqrt{k^2 + 1}}{k}} = \frac{k^2}{\sqrt{1 + k^2}}
$$

也就是说，只要给定了 $\omega_{p2}$ 和  $\mathrm{GBW}_\omega$ 之间的比值，就可以解出 $k = \frac{\omega_{p2}}{\omega_u}$，从而计算得到相位裕度 $\mathrm{PM}$：

$$
\begin{gather}
\mathrm{PM} = \arctan (k),\quad \mathrm{where\ } k \mathrm{\ \ satisfies\ \ } \frac{k^2}{\sqrt{1 + k^2}}  = \frac{\omega_{p2}}{\mathrm{GBW}_\omega}
\end{gather}
$$

通常的设计指标中会直接给出 $\mathrm{GBW}_\omega$ 和 $\mathrm{PM}$ 的要求，这时就可通过上面的公式计算出 $\omega_{p2}$ 的位置。

下面给出几个常见比值所对应的 $\mathrm{PM}$，以供设计参考：

<div class='center'>

| $\mathrm{PM}$ | $k = \frac{\omega_{p2}}{\omega_u}$ | $\frac{\omega_{p2}}{\mathrm{GBW}_\omega} = \frac{k^2}{\sqrt{1 + k^2}}$ |
|:-:|:-:|:-:|
 | 45° | $1$ | $1/\sqrt{2} = 0.71$  |
 | 60° | $\sqrt{3} = 1.73$ | $3/\sqrt{4} = 1.5$ |
 | 63.43° | $2$ | $4/\sqrt{5} = 1.79$ |
 | 65° | $2.14$ | $1.94$ |
 | 70° | $2.75$ | $2.58$ |
 | 71° | $3.00$ | $2.85$ |
</div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-23-09-42_Relationship Between GBW and fp2 in a Two-Order System.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-16-23-14-49_Relationship Between GBW and fp2 in a Two-Order System.png"/></div>

``` matlab
k = linspace(0, 10, 1000);
co = k.^2./sqrt(1+k.^2);
PM = atand(k);
stc = MyPlot(co, PM);
stc = MyYYPlot(co, co, PM, k);
yyaxis('left')
stc.label.x.String = "$k' = \frac{\omega_{p2}}{\mathrm{GBW}_{\omega}}$";
stc.label.y_left.String = '$\mathrm{PM} = \arctan\,(k)$';
stc.label.y_right.String = '$k = \frac{\omega_{p2}}{\omega_{u}}$';
stc.axes.XLim = [0 10];
stc.axes.YLim = [40 90];
stc.axes.YTick = 40:5:90;
stc.axes.YTickLabel = stc.axes.YTickLabel + "$^\circ$";
stc.leg.String = ["PM"; "$k = \frac{\omega_{p2}}{\omega_{u}}$"]

yyaxis('right')
stc.axes.YLim = [0 10];
stc.axes.YTick = 0:1:10;
stc.axes.XTick = 0:1:10;
MyFigure_ChangeSize([1.3 1]*512*1.5)
```


## PM and Overshoot

在两极点二阶系统中, PM 与 overshoot 的关系如下图 (from [this slide](https://pallen.ece.gatech.edu/Academic/ECE_6412/Spring_2003/L240-Sim&MeasofOpAmps(2UP).pdf)):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-12-14-51-55_Relationship Between GBW and fp2 in a Two-Order System.png"/></div>