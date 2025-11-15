# Stability Analysis and Loop Compensation Mechanism of Capacitor-less LDO

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 16:14 on 2025-09-13 in Lincang.

## 1. Overview

本文所讨论的 basic capacitor-less LDO 结构如下图 (继承 LDO, 无片外电容)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-18-19-19_LDO Stability Analysis and Loop Compensation Mechanism.png"/></div>

图中的 LIR (Line Regulation) 其实就是 DC PSRR, 将各阻抗换为频率的函数即得 $\mathrm{PSRR}(s)$。


注意 PMOS as the pass transistor 时，参考电压 $V_{REF}$ 应该接运放的负输入端 (inverting input)，而 NMOS as the pass transistor 时，$V_{REF}$ 应该接运放的正输入端 (non-inverting input)。


## 2. PMOS pass (单补偿)

用 PMOS 作为功率管时, LDO 的环路传递函数如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-18-38-33_LDO Stability Analysis and Loop Compensation Mechanism.png"/></div>

这里 PMOS 作为 CS (common-source) 级存在，其放大作用使 LDO 环路的增益带宽积 GBW_LDO 比 GBW_opamp 要高，导致运放的第二极点 $-\omega_2$ 落在 GBW_LDO 内。我们知道，增益带宽积内落有两个极点的系统通常都不太稳定 (PM < 45°)，甚至就是不稳定的，因此这种结构需要额外的补偿电路，通过引入零点来提高 PM.

除 $\omega_2$ 以外，功率管 gate 端导致的极点 $-\frac{1}{R_{out}C_{eq}}$ 和 (Rc, Cc) 引入的第四极点 $-\frac{1}{R_cC_c + 2R_1 C_c}$ 也是必须考虑的因素。作为一条经验定律，对大多数 capacitor-less LDO 设计来讲，这个极点一般与 $\omega_2$ 同数量级，但是比 $\omega_2$ 稍高一些。

为了在这样一个四极点/单零点系统中提高 PM, 我们需要满足两个条件：
- (1) 使第三、第四极点落在 GBW_LDO 外 (前两个极点一定在 GBW_LDO 内)
- (2) 在 pole2 和 GBW_LDO 之间引入一个零点 $\frac{1}{R_cC_c}$，利用零点产生的 phase peaking 来获得较好的 PM (如下图)



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-18-58-42_LDO Stability Analysis and Loop Compensation Mechanism.png"/></div>

资料 [TI Application Report > AN-1148 Linear Regulators: Theory of Operation and Compensation](https://www.ti.com/lit/an/snva020b/snva020b.pdf) page.11 中给出了一个具体的例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-18-51-20_LDO Stability Analysis and Loop Compensation Mechanism.png"/></div>

尽管图中的 $P_L$ 是大电容负载带来的极点，与我们在本文中讨论的 capacitor-less LDO (输出端极点很高，可以忽略) 不同，但是，作为一个简明的例子，我们可以将 $P_L,\ P_1$  "等效地" 看作运放的两个极点 $\omega_1,\ \omega_2$，而图中 $P_{PWR}$ 则对应功率管 gate 端的极点 $-\frac{1}{R_{out}C_{eq}}$。

由图可以看出，零点的位置对 PM 至关重要。并且按照往常经验，得到最佳 PM 时 pole3/pole4 两个极点的位置挨得很近，这便是 PMOS pass 最重要的缺点所在——**稳定性设计空间小，参数调整不易**。

PMOS pass 的另一个缺点是 PSRR 整体比 NMOS pass 差一些，我们已经在 **1. Overview** 一节中提到过，这里不再赘述。


## 3. PMOS pass (双补偿)

为解决 PMOS pass 单补偿时稳定性较差的问题，我们可以采用双补偿网络 (two compensation networks) [1-2], 如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-19-09-08_LDO Stability Analysis and Loop Compensation Mechanism.png"/></div>


相比于单补偿网络，上图在 PMOS 功率管的 gate 和 drain 之间增加了一个 RC 网络 (Rc2, Cc2)，这是 LDO with off-chip capacitor 的常用补偿方式。但是在 capacitor-less LDO 的相关论文中似乎不常见，我们在参考列表中除 [1-2] 外的其他文献中并没有找到类似的结构，但这不妨碍我们讨论这种补偿方式对系统稳定性的影响。

为了降低公式复杂度，我们仅考虑负载电容很小的情况 $(C_L \approx 0)$，此时环路为 2 + 3 = 5 阶系统 (考虑 $C_L$ 是六阶系统)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-21-21-39_LDO Stability Analysis and Loop Compensation Mechanism.png"/></div>

相比于单个补偿网络，双补偿网络多了一个零点 $-\frac{1}{R_{c2}C_{c2}}$ 和一个 (可以忽略的) 高频极点 $-\frac{B}{A}$。并且其第三、第四极点有所降低，因为：

$$
\begin{gather}
\omega_{p3}:\ 
\frac{1}{R_{out}C_{eq}} \longmapsto \frac{1}{C} = \frac{1}{R_{out}C_{eq} + [2R_1 C_{c1} + R_{c1}C_{c1} + R_{c2}C_{c2} + (1+2g_{m1}R_1)R_{out}C_{c2}]}
\\
\omega_{p4}:\ 
\frac{1}{R_{c1}C_{c1} + 2R_1 C_{c1}} \longmapsto \frac{C}{B} \approx \frac{1}{R_{c1}C_{c1} + \frac{2R_1C_{c1}+R_{c1}C_{c1}+R_{c2}C_{c2}+R_{out}C_{eq}}{1+2g_{m1}R_1}}
\end{gather}
$$

由于 $\omega_{p3}$ 和 $\omega_{p4}$ 的位置变化，双补偿网络虽然通过引入额外零点提高了 PM, 但是其提升能力非常有限。因此，在补偿电容占用面积较大的情况下，双补偿网络的优势并不明显，尤其是片上面积寸土寸金的今天，我们更倾向于使用单补偿网络来节省面积。





## 4. NMOS pass (无补偿)

上面用 PMOS 作为功率管的讨论，绕来绕去都是围绕系统稳定性展开的，而使用 NMOS 作为功率管时，情况就大不相同了。在环路内, NMOS pass 作为 SF (source follower) 存在，并不会使 loop gain 高于运放增益，因此即便没有任何补偿网络，也常常具有相当好的稳定性 (PM > 60°)，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-22-06-08_LDO Stability Analysis and Loop Compensation Mechanism.png"/></div>

显然，由于第二、第三极点都落在 GBW_LDO 之外，系统的 PM 可以做到很高 (通常 > 60°)。尽管采用低阈值晶体管 (在 dropout 较低的情况下仍能有足够的 $I_{out}$) 会带来更大的面积消耗 (因为此类晶体管的 $L_{min}$ 较大)，但由于电路几乎不需要任何补偿网络 (仅需一个小电容 Cc 来稳定运放)，整体面积消耗甚至比 PMOS pass 还要小。

也就是说，相比与 PMOS pass, NMOS pass 不仅在面积上大致持平，还带来了更好的稳定性和更简单的设计流程，以及我们之前就提到的——更好的 PSRR 性能，实乃 capacitor-less LDO 设计的首选。



## 5. NMOS pass (单补偿)

不妨看一下单个补偿网络对频率响应的作用：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-22-18-27_LDO Stability Analysis and Loop Compensation Mechanism.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-22-20-39_LDO Stability Analysis and Loop Compensation Mechanism.png"/></div>

如上图中的 "expected locations", 只有当 $R_cC_c$ 足够大，使得 $z_1 = \frac{1}{R_cC_c}$ 达到 GBW_LDO 附近时，才能对 PM 有明显的提升作用。但在实际设计中，由于面积和设计复杂度的限制，我们往往不对 LDO 做如何补偿 (也能有很高的 PM)。

## 6. 各参数对性能的影响

下表列出了设计 **PMOS pass** 结构时，各参数对 LDO 性能的影响 **(仅供参考，不一定完全准确)**：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-18-18-08_LDO Stability Analysis and Loop Compensation Mechanism.png"/></div>

图中 "大拇指" 表示此参数对性能的影响有好有坏，需要调整至合适的值以达到最佳性能。


<!-- ## 单个补偿网络

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-15-00-33-27_LDO Stability Analysis and Loop Compensation Mechanism.png"/></div>

## 两个补偿网络 -->

## MATLAB Codes

本文的传函推导借助 MATLAB 完成，代码如下：

``` matlab
AnalogICDesigns/202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2.md

1. The scaling equations for 2.5V N/PMOS transistor are shown in Table 2-8.
lr = 0.5e-06;
totalW = 50e-06;
nr = [1 3 6 10 20];
wr = totalW./nr;

nr
C_GS_fF = (0.52.*nr.*(lr+0.31e-06)*1e6./(0.022.*wr*1e6+1.26)+0.27.*wr*1e6+0.1)
C_GD_fF = (0.15.*nr.*(lr+0.31e-06)*1e6+0.05.*nr+0.1)
Ceq1_pF = (C_GS_fF + 30*C_GD_fF)/1000
Ceq2_pF = (C_GS_fF + 50*C_GD_fF)/1000


%{
CGs_M(F)
(0.52·nr·(Ir+0.31u)-1e6/(0.022·wr·1e6+1.26)+0.27·wr·1e6+0.1)·1e-15
CGD_M(F)
(0.15·nr·(Ir+0.31u)·1e6+0.05-nr+0.1)·1e-15
%}

2. 增益分配
g_m1 = 650e-6; g_m6 = 5e-3;

% 方案 1
r_O1 = 100e3; r_O3 = 100e3;
r_O6 = 100e3; r_O7 = 100e3;
A_v = g_m1*MyParallel(r_O1, r_O3)*g_m6*MyParallel(r_O6, r_O7);
A_v_dB = 20*log10(A_v)

% 方案 2
r_O1 = 50e3; r_O3 = 100e3;
r_O6 = 50e3; r_O7 = 100e3;
A_v = g_m1*MyParallel(r_O1, r_O3)*g_m6*MyParallel(r_O6, r_O7);
A_v_dB = 20*log10(A_v)

% 方案 3
r_O1 = 50e3; r_O3 = 50e3;
r_O6 = 50e3; r_O7 = 50e3;
A_v = g_m1*MyParallel(r_O1, r_O3)*g_m6*MyParallel(r_O6, r_O7);
A_v_dB = 20*log10(A_v)

% 方案 4
r_O1 = 30e3; r_O3 = 50e3;
r_O6 = 30e3; r_O7 = 50e3;
A_v = g_m1*MyParallel(r_O1, r_O3)*g_m6*MyParallel(r_O6, r_O7);
A_v_dB = 20*log10(A_v)

3. LDO Stability Analysis

3.1 P-PASS 单个补偿网络
clc, clear, close all
% 实际值
R_1_ = 5e3;
C_L_ = 0.1e-12;
%C_L_ = 10e-12;
R_c_ = 600;
C_c_ = 2e-12;
R_out_ = 10e3;
C_eq_ = 1e-12;

syms A A_0 s omega_1 omega_2 C_eq C_GS C_GD g_m1 Z_L R_1 R_2 R_L C_L s R_c C_c H_OL R_out

% 作近似
R_2 = R_1;
C_GS = 0;
C_GD = 0;
% C_L = 0;    % 低容性负载

%A = A_0/( (1+s/omega_1)*(1+s/omega_2) );
Z_L = simplifyFraction(MyParallel_n([R_1 + R_2, 1/(s*C_L), R_c + 1/(s*C_c)]));
H_OL = A/(1+s*R_out*C_eq) * (-g_m1*Z_L) * R_2/(R_1 + R_2);
stc = MyAnalysis_TransferFunction(H_OL, 1);

fun = (2*C_L*R_1*s + 2*C_c*R_1*s + C_c*R_c*s + 2*C_L*C_c*R_1*R_c*s^2 + 1);
stc = MyAnalysis_TransferFunction(1/fun, 0);
pole_num1 = stc.dominantPoleAppro.p1
pole_num2 = stc.dominantPoleAppro.p2

pole_num1 = vpa(subs(pole_num1, [R_1, C_L, R_c, C_c, C_eq], [R_1_, C_L_, R_c_, C_c_, C_eq_]));
pole_num2 = vpa(subs(pole_num2, [R_1, C_L, R_c, C_c, C_eq], [R_1_, C_L_, R_c_, C_c_, C_eq_]));

disp(['pole_num1 ≈ ', sym2cell(round(vpa(-50e3*(2*pi))/10^6, 1)), ' Mrad/s'])
disp(['pole_num2 ≈ ', sym2cell(round(vpa(-250e6*(2*pi))/10^6)), ' Mrad/s'])
disp(['pole_num3 = ', sym2cell(round(vpa(-1/(R_out_*C_eq_))/10^6)), ' Mrad/s'])
disp(['pole_num4 = ', sym2cell(round(pole_num1/10^6)), ' Mrad/s'])
disp(['pole_num5 = ', sym2cell(round(pole_num2/10^6)), ' Mrad/s'])
disp(['zero = ', sym2cell(round(vpa(-1/(R_c_*C_c_))/10^6)), ' Mrad/s'])

3.2 P-PASS 两个补偿网络
clc, clear, close all
syms A A_0 s omega_1 omega_2 C_eq C_GS C_GD g_m1 Z_L R_1 R_2 R_L C_L s R_c C_c H_OL R_out Z_eq R_c1 R_c2 C_c1 C_c2

% 作近似
R_2 = R_1;
C_GS = 0;
C_GD = 0;

low_CL = 1 % 低容/高容负载

Z_L = simplifyFraction(MyParallel_n([R_1 + R_2, 1/(s*C_L), R_c1 + 1/(s*C_c1)]));
Z_eq = (R_c2 + 1/(s*C_c2)) / (1+g_m1*Z_L);
Z_eq = MyParallel(Z_eq, 1/(s*C_eq));
H_OL = A * Z_eq/(Z_eq + R_out) * (-g_m1*Z_L) * R_2/(R_1 + R_2);
if low_CL == 1; H_OL = subs(H_OL, C_L, 0); end
stc = MyAnalysis_TransferFunction(H_OL, 1);


f_p2 = 30e6;
C_cc = [0.1 0.2 0.5 1 2 5]*10^(-12);
R_cc = 1./(2*pi*f_p2*C_cc);

disp(['C_cc (pF)   = ', num2str(C_cc*10^12)])
disp(['R_cc (kOhm) = ', num2str(round(R_cc/10^3,1))])

3.3 N-PASS 无补偿网络
clc, clear, close all
syms A A_0 s omega_1 omega_2 C_eq C_GS C_GD g_m1 Z_L R_1 R_2 R_L C_L s R_c C_c H_OL R_out Z_eq R_c1 R_c2 C_c1 C_c2

% 作近似
R_2 = R_1;
C_GS = 0;
C_GD = 0;

low_CL = 0 % 低容/高容负载

Z_L = simplifyFraction(MyParallel_n([R_1 + R_2, 1/(s*C_L)]));
H_OL = (-A)/(1 + s*R_out*C_eq) * g_m1*Z_L/(1+g_m1*Z_L) * R_2/(R_1 + R_2);
if low_CL == 1; H_OL = subs(H_OL, C_L, 0); end
stc = MyAnalysis_TransferFunction(H_OL, 1);

3.4 N-PASS 单个补偿网络
clc, clear, close all
syms A A_0 s omega_1 omega_2 C_eq C_GS C_GD g_m1 Z_L R_1 R_2 R_L C_L s R_c C_c H_OL R_out

% 作近似
R_2 = R_1;
C_GS = 0;
C_GD = 0;

low_CL = 1 % 低容/高容负载

Z_L = simplifyFraction(MyParallel_n([R_1 + R_2, 1/(s*C_L), R_c + 1/(s*C_c)]));
H_OL = (-A)/(1 + s*R_out*C_eq) * g_m1*Z_L/(1+g_m1*Z_L) * R_2/(R_1 + R_2);
if low_CL == 1; H_OL = subs(H_OL, C_L, 0); end
stc = MyAnalysis_TransferFunction(H_OL, 1);

if low_CL == 0
    fun = (2*R_1*g_m1 + 2*C_L*R_1*s + 2*C_c*R_1*s + C_c*R_c*s + 2*C_c*R_1*R_c*g_m1*s + 2*C_L*C_c*R_1*R_c*s^2 + 1)
    stc = MyAnalysis_TransferFunction(1/fun, 0);
    pole_num1 = stc.dominantPoleAppro.p1
    pole_num2 = stc.dominantPoleAppro.p2
end
```


## Reference

相关文章或技术文档：
- [TI Application Report > AN-1148 Linear Regulators: Theory of Operation and Compensation](https://www.ti.com/lit/an/snva020b/snva020b.pdf)
- [知乎 > LDO 结构分析以及进阶——Aze 的 Analog IC Design 随记 (各种结构的闭环传递函数)](https://zhuanlan.zhihu.com/p/46250208)
- [知乎 > LDO 设计与 Cadence 详细仿真 (1)](https://zhuanlan.zhihu.com/p/1941963651746608768)



以及相关文献：
- \[1\] M. M. Elkhatib, “A capacitor-less LDO with improved transient response using neuromorphic spiking technique,” in 2016 28th International Conference on Microelectronics (ICM), Giza, Egypt: IEEE, Dec. 2016, pp. 133–136. doi: 10.1109/ICM.2016.7847927.
- \[2\] V. Ngo and C. Huynh, “High-PSR Capacitor-Less LDO with Enhanced Bandgap Reference in 65nm CMOS Technology,” in 2025 10th IEEE International Conference on Integrated Circuits, Design, and Verification (ICDV), Ho Chi Minh City, Vietnam: IEEE, Jun. 2025, pp. 31–36. doi: 10.1109/ICDV66179.2025.11134969.
- [3] Y. Zeng and H. Tan, “A FVF based LDO with dynamic bias current for low power RFID chips,” in 2016 IEEE International Conference on RFID Technology and Applications (RFID-TA), Shunde, Foshan, China: IEEE, Sep. 2016, pp. 61–64. doi: 10.1109/RFID-TA.2016.7750736.
- [4] X. Liang, X. Kuang, J. Yang, and L. Wang, “A Fast Transient Response Output-capacitorless LDO With Low Quiescent Power,” in 2024 3rd International Conference on Electronics and Information Technology (EIT), Chengdu, China: IEEE, Sep. 2024, pp. 314–317. doi: 10.1109/EIT63098.2024.10762683.
- [5] X. Wang, F. Wang, and Z. Li, “The Analysis of LDO and the Stability of Loop Compensation,” in 2010 International Conference on Electrical and Control Engineering, Wuhan: IEEE, Jun. 2010, pp. 4368–4371. doi: 10.1109/iCECE.2010.1061.
- [6] J. Ding, H. Luo, and W. Shi, “Design of a Stable LDO Over the Full Load Range,” in 2023 3rd International Conference on Frontiers of Electronics, Information and Computation Technologies (ICFEICT), Yangzhou, China: IEEE, May 2023, pp. 28–32. doi: 10.1109/ICFEICT59519.2023.00015.
- [7] W. M. Ab. Halim, J. R. Rusli, S. Shafie, Y. Yusoff, and C. C. Yin, “Study on Performance of Capacitor-less LDO with Different Types of Resistor,” in 2019 IEEE International Circuits and Systems Symposium (ICSyS), Kuantan, Malaysia: IEEE, Sep. 2019, pp. 1–5. doi: 10.1109/ICSyS47076.2019.8982395.
- [8] L. Ma, X. Wang, Y. Wang, and H. Dong, “A High-Stability and Fast-Transient Response LDO Design,” in 2024 Asia Communications and Photonics Conference (ACP) and International Conference on Information Photonics and Optical Communications (IPOC), Beijing, China: IEEE, Nov. 2024, pp. 1–5. doi: 10.1109/ACP/IPOC63121.2024.10810047.
- [9] Z. Yang, M. Huang, Y. Lu, and R. P. Martins, “Relative Stability Analysis of Multi-Loop Low Dropout Regulators Using a Sub-Loop Superposition Method,” IEEE Trans. Circuits Syst. II, vol. 70, no. 11, pp. 3968–3972, Nov. 2023, doi: 10.1109/TCSII.2023.3282633.

