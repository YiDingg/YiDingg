# [Razavi CMOS] Gain Boosting Techniques

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 18:22 on 2025-05-18 in Beijing.

## Intro

在上一篇文章 [[Razavi CMOS] Detailed Explanation of Cascode Op Amp](<Electronics/[Razavi CMOS] Detailed Explanation of Cascode Op Amp.md>), 我们介绍了 cascode op amp (telescopic op amp) 和 folded-cascode op amp 的基本结构、电压条件和小信号参数。但是，某些应用 (例如 ADC ) 在需要更高增益的同时，还需要非常高的带宽。如果采用 two-stage op amp 结构，虽然增益明显升高，但是带宽却大大降低了。因此，我们需要一些提升单极放大器增益的技术，这便是本文所介绍的 gain boosting techniques. 

!> **<span style='color:red'>Attention:</span>**<br>
若无特别说明，本文的讨论都忽略 body effect 对直流 biasing 和 small-signal 性能的影响。

## General Considerations

考虑下图所示的 "supper-transistor (transconductance-boosting)" 结构，我们先分别计算它作为 CS (common-source) 组态和 CD (common-drain) 组态 的等效 $G_{m}$ 和 $R_{out}$:

$$
\begin{gather}
G_m = \frac{A_1 g_m}{1 + (A_1 + 1)g_m (R_S\parallel r_O)} \approx \frac{1}{\frac{1}{A_1 g_m} + R_S}
\\
R_{out} = R_S + r_O + (A_1 + 1)g_m r_O R_S \approx R_S + r_O + A_1g_m r_O R_S \approx A_1 R_{drain}
\\
A_{v0} \approx - \frac{r_O (1 + A_1 g_m R_S)}{\frac{1}{A_1 g_m} + R_S} \approx A_1 (- g_m r_O) = A_1 A_{v0}
\end{gather}
$$

从 source 端看入时，我们也有等效 $G_m$ 和 $R_{out}$:

$$
\begin{gather}
G_m = \frac{- A_1 g_m}{1 + \frac{R_D}{r_O}} \approx A_1 \left(\frac{- g_m}{1 + \frac{R_D}{r_O}}\right) = A_1 G_{m,source}
\\
R_{out} = \frac{R_D + r_O}{1 + (A_1 + 1)g_m r_O} = \left(1 + \frac{R_D}{r_O}\right)\left( \frac{1}{(A_1 + 1)g_m} \parallel r_O\right) \approx \frac{R_{source}}{A_1}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-18-18-52-22_[Razavi CMOS] Gain Boosting Techniques.png"/></div>



也就是说，无论是哪一种配置， supper-transistor 都可以近似等效为一个跨导被 boosting (从 $g_m$ 提升至 $A_1 g_m$) 的普通 transistor, 也称为 transconductance-boosted transistor. 这样，当配置为 CS (common-source) 结构时，等效输出电阻便被提高到原来的 $A_1$ 倍，从而将本征增益提高了  $A_1$ 倍；当配置为 CD (common-drain) 结构时, 则是等效跨导提高了 $A_1$ 倍 (等效输出电阻变为原来的 $\frac{1}{A_1}$)。

举一个 single-ended cascode stage with ideal current source load 的例子，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-18-18-53-36_[Razavi CMOS] Gain Boosting Techniques.png"/></div>

通常 cascode stage 的增益在 $(g_m r_O)^2$ 量级，经过 gain-boosting 之后，达到了 $A_1(g_m r_O)^2$。特别地，如果 $A_1$ 我们也用一个 cascode stage 来构成，那么这个单级放大器的增益便可达到 $(g_m r_O)^4$ 量级。与两个 cascode stage 级联相比， gain-boosting 结构通常具有更好的频率响应（更高的带宽）。


## Gain-Boosted Cascode Stage

下面，我们就来探讨 (folded) cascode stage using (folded) cascode stage as a gain-boosting amplifier. 

先看一下用 NMOS-input CS, PMOS-input CS, 和 PMOS-input folded-cascode 作为 gain-boosting amplifier 的 single-ended cascode stage 结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-18-20-40-21_[Razavi CMOS] Gain Boosting Techniques.png"/></div>

由上面的 single-ended cascode stage, 我们容易推广到 differential cascode stage 结构，同时将 gain-boosting amplifier 也配置为 differential structure, 如图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-18-20-42-10_[Razavi CMOS] Gain Boosting Techniques.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-18-20-42-54_[Razavi CMOS] Gain Boosting Techniques.png"/></div>

上面的 NMOS-input differential cascode stage 结构中，之所以使用 folded-cascode 作为 auxiliary amplifier  而不是普通 cascode, 是因为普通 cascode 的最低输入共模电压高于零，这会导致 Figure 9.34 图中点 X, Y 处的点电压受限制，从而限制了整个电路的输入共模范围。相反， folded-cascode 的最低输入共模可以低于零，不会对整个电路的输入共模范围带来额外限制。


Figure 9.34 结构的输出电阻如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-18-20-48-45_[Razavi CMOS] Gain Boosting Techniques.png"/></div>

将 ideal current source 替换为实际的 cascode stage 作为负载，得到下图中的示例结构：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-18-20-55-30_[Razavi CMOS] Gain Boosting Techniques.png"/></div>


## Frequency Response

下面，我们就来较为完整地分析一下 Figure 9.37 (下图) 所示结构的频率响应特性。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-18-21-10-04_[Razavi CMOS] Gain Boosting Techniques.png"/></div>


注：在本小节的频响分析中，为简化分析过程，我们作下面两条近似：
- 用理想一阶放大器来近似替代 auxiliary amplifier 的频率响应, 也即 $A_1 = \frac{A_0}{1 + \frac{s}{\omega_0}}$, 有唯一极点 $\omega_0$.
- 由于 cascode 结构没有明显的 Miller effect, 我们仅考虑负载电容 $C_L$ 对电路增益的影响，而忽略其它所有寄生电容


### G_m Calculation

先分别计算 $G_m$ 和 $Z_{out}$，然后由 $A_v = - G_m Z_{out}$ 求出总的频率响应。先求跨导，在 Figure 9.37 中，令 M2 的 drain shorted to ground, 利用第二小节 **General Considerations** 中的结论：$R_D = 0$ 时，一个 supper-transistor 从 source 端看入的等效电阻为

$$
\begin{gather}
r_{source2} = \frac{1}{(A_1 + 1) g_{m2}} \parallel r_{O2}
\end{gather}
$$


结合 CC stage 的 $A_v|_{R_S = 0} = - g_{m1}(r_{O1} \parallel R_D) =  - g_{m1}(r_{O1} \parallel r_{source2})$, 得到：

$$
\begin{gather}
G_m = - \frac{A_v|_{R_S = 0}}{r_{source2}} = g_{m1} \cdot \frac{r_{O1}}{r_{O1} + r_{source2}} = \frac{g_{m1}r_{O1}}{r_{O1} +  \frac{1}{(A_1 + 1) g_{m2}} \parallel r_{O2}}
= \frac{g_{m1}}{1 +  \left(\frac{1}{(A_1 + 1) g_{m2}} \parallel r_{O2}\right)\cdot \frac{1}{r_{O1}}}
\end{gather}
$$

这是一个非常接近 $g_{m1}$ 的跨导。

### Z_out Calculation

又利用到第二节 **General Considerations** 中的结论，一个 supper-transistor 从 drain 看入的电阻为：

$$
\begin{gather}
r_{drain} = R_S + r_O + (A_1 + 1)g_m r_O R_S = r_{O1} + r_{O2} + (A_1 + 1)g_{m2}r_{O2}r_{O1}
\end{gather}
$$

总的等效阻抗为：

$$
\begin{gather}
Z_{out} = \frac{1}{s\,C_L} \parallel r_{drain}
\end{gather}
$$

### A_v Calculation

将 $G_m$ 和 $A_v$ 合并，得到图 Figure 9.37 中的增益：

$$
\begin{gather}
A_v(s) = \frac{V_{out}}{V_{in}}(s) = - G_m Z_{out} 
= \frac{- g_{\mathrm{m1}} \,r_{\mathrm{O1}} \,{\left[(A_1 + 1) \,g_{\mathrm{m2}} \,r_{\mathrm{O2}} +1\right]}}{s(r_{\mathrm{O1}} + r_{\mathrm{O2}})C_L  +  (A_1 + 1) \,C_L \,g_{\mathrm{m2}} \,r_{\mathrm{O2}} \,r_{\mathrm{O1}} \,s+1}
\end{gather}
$$

别忘了 $A_1$ 在高频处会低于 $1$, 因此我们不做近似 $A_1 + 1 \approx A_1$。将 $A_1(s) = \frac{A_0}{1 + \frac{s}{\omega_0}}$ 代入上式，计算得到：

$$
\begin{gather}
A_v(s) = A_{v0} \cdot \frac{ c s + 1 }{a s^2 + b s + 1}
\\
A_{v0} = -g_{\mathrm{m1}} \,r_{\mathrm{O1}} \,{\left[(A_0 + 1) \,g_{\mathrm{m2}} \,r_{\mathrm{O2}} +1\right]}
\\
c = \frac{g_{\mathrm{m2}} \,r_{\mathrm{O2}} +1}{\omega_0 \,{\left(g_{\mathrm{m2}} \,r_{\mathrm{O2}} +A_0 \,g_{\mathrm{m2}} \,r_{\mathrm{O2}} +1\right)}}
\\
a =\frac{1}{\omega_0} \left(r_{\mathrm{O1}} + r_{\mathrm{O2}} + g_{\mathrm{m2}} \,r_{\mathrm{O2}} \,r_{\mathrm{O1}}\right)C_L  
\\
b = \frac{1}{\omega_0 } + \left[r_{\mathrm{O1}} + r_{\mathrm{O2}} + (A_0 + 1)\,g_{\mathrm{m2}} \,r_{\mathrm{O2}} \,r_{\mathrm{O1}}\right]C_L 
\end{gather}
$$

上式表现出一个左半平面的零点 $\omega_z$ 和两个左半平面的极点 $\omega_{p1}, \omega_{p2}$. 利用 dominant-pole approximation, 可以得到：

$$
\begin{gather}
\omega_z = -\frac{\omega_0 +g_{\mathrm{m2}} \,\omega_0 \,r_{\mathrm{O2}} +A_0 \,g_{\mathrm{m2}} \,\omega_0 \,r_{\mathrm{O2}} }{g_{\mathrm{m2}} \,r_{\mathrm{O2}} +1}
\\
\omega_{p1} \approx - \frac{1}{b} = - \frac{1}{\frac{1}{\omega_0 } + \left[r_{\mathrm{O1}} + r_{\mathrm{O2}} + (A_0 + 1)\,g_{\mathrm{m2}} \,r_{\mathrm{O2}} \,r_{\mathrm{O1}}\right]C_L } \approx - \frac{1}{A_0 \,g_{\mathrm{m2}} \,r_{\mathrm{O2}} \,r_{\mathrm{O1}} \,C_L}
\\
\omega_{p2} \approx - \frac{b}{a} = \approx - \left[(A_0 + 1) \omega_0 + \frac{1}{g_{m2}r_{O2}r_{O1}C_L}\right] \approx - \left[A_0 \omega_0 + \frac{1}{g_{m2}r_{O2}r_{O1}C_L}\right]
\end{gather}
$$

容易验证 dominant-pole approximation 满足近似条件 $|\omega_{p2}| \gg |\omega_{p1}|$。下图展示了加入 gain-boosting 前后，放大器的频率响应变化：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-18-23-04-15_[Razavi CMOS] Gain Boosting Techniques.png"/></div>

顺便附上所学四种 op amp 的性能对比：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-18-23-11-56_[Razavi CMOS] Gain Boosting Techniques.png"/></div>

## Appendix

上面的结果都与 *Design of Analog CMOS Integrated Circuits (Razavi) (Second Edition, 2015), Chapter 9 (Operational Amplifiers), Section 9.4 (Gain-Boosting)* 的结果一致 (page.364 ~ page.372). 

另外，本小节的计算借助了 MATLAB 辅助进行，相关代码如下：

``` matlab
%% 20250518 Section 9.4 Gain Boosting

syms r_O1 r_O2 g_m1 g_m2 A_0 A_1 s C_L omega_0
G_m = g_m1 / ( 1 + MyParallel(1/g_m2/(A_1+1), r_O2)/r_O1 )
r_drain = r_O1 + r_O2 + (A_1 + 1)*g_m2*r_O2*r_O1
Z_out = MyParallel(1/(s*C_L), r_drain)
A_v = - G_m * Z_out;
A_v = simplify(A_v)

if 0
    % 作近似 A_1 + 1 \approx A_1
    G_m = subs(G_m, A_1+1, A_1);
    Z_out = subs(Z_out, A_1+1, A_1);
    A_v = simplify(- G_m * Z_out)
end

re_A_1 = A_0/(1+s/omega_0)
A_v = subs(A_v, A_1, re_A_1);
A_v = simplify(A_v);
A_v = simplifyFraction(A_v);

% 传函分析
stc = MyAnalysis_TransferFunction(A_v, 1);
%stc = MyAnalysis_TransferFunction_Dominant_Pole_Approximation(A_v)
stc = MyAnalysis_TransferFunction_Dominant_Pole_Approximation(A_v);
stc.nume_coefficients_standard
stc.deno_coefficients_standard
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-19-17-06-21_[Razavi CMOS] Gain Boosting Techniques.png"/></div>

## Other Considerations

当然，在实际电路中， gain-boosting amplifier 的设计还有很多需要考虑的部分，例如 CMFB (common-mode feedback), SR (slew rate), Swing (output swing) 等。其中, CMFB 在 high-gain differential op amp 中非常关键，是 op amp 能够稳定工作的必要条件。