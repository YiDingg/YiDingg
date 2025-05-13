# Compound BJT - Sziklai and Darlington

> [!Note|style:callout|label:Infor]
Initially published at 00:21 on 2025-04-01 in Beijing.


## Summary

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-01-00-29-05_Compound BJT - Sziklai and Darlington.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-01-00-29-28_Compound BJT - Sziklai and Darlington.png"/></div>

See [Compound Pair Vs. Darlington Pairs](https://www.sound-au.com/articles/cmpd-vs-darl.htm) for more details.

## Sziklai Pair

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-01-00-31-55_Compound BJT (Sziklai and Darlington).png"/></div>
 -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-01-00-32-17_Compound BJT (Sziklai and Darlington).png"/></div>

## Darlington Pair

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-01-00-30-34_Compound BJT - Sziklai and Darlington.png"/></div>

## Reference

- [Compound Pair Vs. Darlington Pairs](https://www.sound-au.com/articles/cmpd-vs-darl.htm)

## LTspice Simulation

### Sziklai pair

NCP (NPN, Sziklai pair):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-34-43_Compound BJT (Sziklai and Darlington).png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-39-21_Compound BJT (Sziklai and Darlington).png"/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-48-19_Compound BJT (Sziklai and Darlington).png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-49-22_Compound BJT (Sziklai and Darlington).png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-52-53_Compound BJT (Sziklai and Darlington).png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-54-52_Compound BJT (Sziklai and Darlington).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-43-54_Compound BJT (Sziklai and Darlington).png"/></div>

### Darlington pair

NEN (NPN, Darlington pair):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-36-27_Compound BJT (Sziklai and Darlington).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-37-50_Compound BJT (Sziklai and Darlington).png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-56-57_Compound BJT (Sziklai and Darlington).png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-59-19_Compound BJT (Sziklai and Darlington).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-43-01_Compound BJT (Sziklai and Darlington).png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-18-32-44_Compound BJT (Sziklai and Darlington).png"/></div> -->

2025.05.14 01:03 重新计算 Darlington 的 $r_{O,eq}$, 结果如下：

$$
\begin{gather}
r_{O,eq} = -\frac{r_{\textrm{O2}} \,{\left(r_{\textrm{O1}} -r_{\textrm{pi2}} +g_{\textrm{m1}} \,r_{\textrm{O1}} \,r_{\textrm{pi2}} \right)}}{r_{\textrm{O2}} -r_{\textrm{O1}} +r_{\textrm{pi2}} -g_{\textrm{m1}} \,r_{\textrm{O1}} \,r_{\textrm{pi2}} +g_{\textrm{m2}} \,r_{\textrm{O2}} \,r_{\textrm{pi2}} } \approx r_{O2} + \frac{g_{m1}r_{O1}}{g_{m2}} \approx 2 r_{O2}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-14-01-04-13_Compound BJT (Sziklai and Darlington).png"/></div>

``` matlab
syms v_y v_x r_O1 r_O2 r_pi2 i_x g_m1 g_m2
eq1 = (v_y - v_x) / r_O1 - g_m1*v_y == v_y/r_pi2
eq2 = i_x == v_y/r_pi2 + g_m2*v_y + v_x/r_O2
re_v_y = solve(eq1, v_y)
eq2 = subs(eq2, v_y, re_v_y);
re_i_x = solve(eq2, i_x);
r_O_eq = simplify(re_i_x/v_x)^(-1);
simplify(r_O_eq)
```
