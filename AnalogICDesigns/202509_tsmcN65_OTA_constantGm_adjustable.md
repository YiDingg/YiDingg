# 202509_tsmcN65_OTA_constantGm_adjustable

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 22:05 on 2025-09-23 in Beijing.

>注：本文是项目 [Design of An Adjustable Constant-Gm OTA for Low Pass Filters in BB-PLL](<Projects/Design of An Adjustable Constant-Gm OTA for Low Pass Filters in BB-PLL.md>) 的附属文档，用于记录 OTA 的设计和前仿过程。

## 1. Design Considerations

### 1.1 specs and topology

我们已经在项目主文档 [here](<Projects/Design of An Adjustable Constant-Gm OTA for Low Pass Filters in BB-PLL.md>) 给出了 OTA 的大致设计要求，这里再重复一遍：
- VDD (supply voltage): 1.2 V (external)
- Gm (transconductance): 1 uS ~ 20 uS (adjustable)
- ICMR (input common-mode range): 0.3 V ~ 0.9 V (external digital controlled)
- IBIAS (biasing current): an integer multiple of 10 uA (external digital controlled)
- VOUT (output voltage range): 0.15 V ~ 0.9 V
- GBW (gain-bandwidth product): very low (具体看情况)

由于 ICMR 往下和往上的余量都不到 0.4 V, 常规的 input stage 肯定是行不通的 (无论 NMOS-input 还是 PMOS-input)，再考虑到这个输出电压范围，我们考虑做一个 **constant-gm OTA**。单级设计时无需考虑稳定性问题，因为单级情况下，负载电容越大，环路的相位裕度越高。我们 150 pF 这么大的负载电容，相位裕度基本能保证在 80° 以上。


Constant-Gm OTA 的理论分析和设计指导见文章 [Design of An Adjustable Constant-Gm OTA for Low Pass Filters in BB-PLL](<Projects/Design of An Adjustable Constant-Gm OTA for Low Pass Filters in BB-PLL.md>)，这里直接给出我们选定的架构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-24-21-14-58_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

也就是用 two-pairs with current-reuse technique 作为整个 OTA 的输入级，current-reuse 中的控制开关只是示意，最终不一定用这种结构。至于是否加上输出级以满足 rail-to-rail output 要求，由于我们需要的是纯粹的 OTA 而非 OPA, 还在斟酌中。如何在添加输出级后仍保持电路 Gm 不变 (仍为输入级跨导)？

输入级的 cascode 采用 series transistor 作为偏置，详见这篇文章 [低压共源共栅电流镜的偏置结构考量——如何产生偏置电压](https://zhuanlan.zhihu.com/p/1935398118490367665):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-24-21-37-18_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

### 1.2 parameter setting

本次设计对 GBW 和 Voltage Gain 均没有要求 (甚至希望越低越好)，为提高设计效率，我们设置电路中 **所有 NMOS/PMOS 具有相同的长度 (记为 L)** ，并且 PMOS 的宽度均设置为对应 NMOS 的 **KA** 倍。

至于各晶体管之间宽长比 a = W/L 的比例关系 (电流比例关系)，参考这篇论文的 Figure.2:

>R. Hogervorst, J. P. Tero, R. G. H. Eschauzier, and J. H. Huijsing, “A compact power-efficient 3 V CMOS rail-to-rail input/output operational amplifier for VLSI cell libraries,” in Proceedings of IEEE International Solid-State Circuits Conference - ISSCC ’94, San Francisco, CA, USA: IEEE, 1994, pp. 244–245. doi: 10.1109/ISSCC.1994.344656.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-24-21-32-29_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

注意仅仅是参考比例关系，我们要先用 gm/Id 方法确认输入管的 a = W/L, 再根据比例关系确定其他管的宽长比。

未包含 current-reuse 的电路图及其参数设置如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-00-16-11_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-02-14-40_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

注意 MBN2/MBN3 的宽度分别为 2\*WN 和 2\*WN/3 而非 WBN, MBP2/MBP3 同理。

将 current-reuse 包含进来：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-19-20-13_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

待会我们分别对 without/with current-reuse 两种情况进行仿真迭代，看一下它们的性能差异。

## 2. Design Details (2.5 V)

### 2.1 gm/Id considerations

要实现 1 uS ~ 20 uS 的跨导范围，N/P 管匹配较好的情况下各占一半，导师给指标时已经留了非常充足的裕量 (实际需求大约是 5 uS ~ 10 uS)，因此我们不必再留。我们已经在文章 [Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library)](<AnalogICDesigns/Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).md>) 中给出了所用器件的 gm/Id 参考数据：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-00-32-38_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

先计算 NMOS input pair, 我们有：

$$
\begin{gather}
\begin{cases}
g_{mN} = 0.5 \ \mathrm{uS}\\
\left(\frac{g_m}{I_D}\right)_{N} = 10\\
I_{nor} = 2.7255 \ \mathrm{uA}\\
\end{cases}
\Longrightarrow 
\begin{cases}
I_{DN} = 50 \ \mathrm{nA}\\
a_{N} = \frac{W_{N}}{L} = 0.0183
\end{cases}
\\
\begin{cases}
g_{mN} = 0.5 \ \mathrm{uS}\\
\left(\frac{g_m}{I_D}\right)_{N} = 15\\
I_{nor} = 0.8940 \ \mathrm{uA}\\
\end{cases}
\Longrightarrow 
\begin{cases}
I_{DN} = 33.3 \ \mathrm{nA}\\
a_{N} = \frac{W_{N}}{L}  = 0.0373
\end{cases}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-00-53-19_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

因此，如果以最低 $g_{mN}$ 为目标进行设计，我们的宽长比 a = W/L 必须做得非常小 (0.0139 ~ 0.0434)，例如 gm/Id = 16 时 W/L = 0.4u/9.2u, 这么 "畸形" 的宽长比会严重影响晶体管的性能。

先分析一下 $g_m$ 随 $I_D \propto I_{BIAS}$ 的变化情况，看看设计时 gm 到底取多少比较合适。在 $I_D$ 较小时 (< 1 uA), 晶体管工作在 weak inversion 区，$\frac{g_m}{I_D} = \frac{1}{nV_T} \approx 25$ 保持不变；随着 $I_D$ 增大，管子由 weak inversion 向 strong inversion 过渡，$\frac{g_m}{I_D}$ 逐渐减小，向曲线 $\frac{g_m}{I_D} = \sqrt{\frac{\mu_n C_{ox} (W/L)}{I_D}}$ 靠近，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-01-09-22_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

不妨直接以最大 $g_{mN}$ 为目标进行设计，这样，在 $I_{BIAS}$ 减小时，虽然 $\frac{g_m}{I_D}$ 在增大，但总体 $g_m$ 会一直减小，只需保证 $I_{BIAS} = 10 \ \mathrm{uA}$ 时 $I_B = \frac{I_{BIAS}}{K_I}$ 足够小即可 (这样就能实现 $g_{mN} < 1 \ \mathrm{uS}$)。

先设置 g_mN = 15 uS (总跨导 30 uS) 进行计算：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-01-14-12_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

宽长比 a = 0.4170 ~ 1.3012, 是一个完全没问题的范围。如何选择此时的 gm/Id 呢？我们需要考虑到偏置电流 $I_B$ 的范围：如果取较小的 gm/Id, 初始时 $I_B = I_{B,\max}$ 较大，且晶体管较慢进入 weak inversion 区，$\frac{g_m}{I_D}$ 的值保持在较低水平 (相比选取较高的 gm/Id 作为初始值)，使 $g_{m,\min}$ 对应的 $I_{B,\min}$ 较高，这正是我们想要的！


别忘了我们的外源偏置电流 $I_{BIAS}$ 必须是 10 uA 的整数倍，这么大的一个电流，必须经过 current mirror 分出很小的一份才能作为 $I_B$, $I_B$ 整体较高意味着 multiplier 不必设得太大，显著提高了设计的可行性。

综合上面分析，我们选择以下初始值进行仿真迭代：
- $a_N = W_N/L = 0.5$ (对应较低的 gm/Id)
- $K_A = 3\ \ (a_P = K_A \times a_N = 1.5)$ 
- $I_D = 1.7 \ \mathrm{uA} \Longrightarrow $
- 看一下 $I_B$ 范围多大才能满足 $G_m$ 的范围要求，若 $I_B$ 范围太广可适当降低 $a_N$.


<!-- 我们的外源偏置电流 IBIAS 只能是 10 uA 的整数倍，要想实现  -->


### 2.2 iteration 1 (a_N = 0.5)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-02-14-06_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

仿真时遇到了报错：
``` bash
Internal error found in spectre during hierarchy flattening, during circuit read-in.  
Encountered a critical error during simulation. Please run `mmsimpack' to pack the test case (use mmsimpack -h option to get detailed usage), and submit the case via Cadence Online Support, including the package tar file and any other information that can help identify the problem.
    FATAL (CMI-2010): Assertion failed in file `b4.c' at line 2355.
    FATAL (SPECTRE-21): Assertion failed.

Version 18.1.0.077 64bit -- 1 Aug 2018

****ASSERTION STACK****
        0x47ebfce
        0x51bd04
        0x7f1af57c63b0
        0x7f1af57c6337
        0x7f1af57c7a28
        0x6b200f
        0x18ca12b
        0x4169590
        0x416e21e
        0x4160e3e
        0x4160f1b
        0x1857da6
        0x4067484
        0x404b730
        0x4055316
        0x18690ba
        0x604002
        0x60440d
        0x54f867
        0x55b83f
        0x55ceae
        0x4a2189
        0x7f1af57b2505
        0x4f6025
```

试了一下其它 cell view 的仿真都能正常进行，此问题相关链接：
- [EETOP > [求助] Error found during hierarchy flattening.ERROR: I91: Too few terminals given.](https://bbs.eetop.cn/thread-611458-2-1.html): 是因为 verilog-A 里面的 module 命名重复了
- [EETOP > Spectre 仿真报错，Internal error found in spectre during AHDL read-in](https://bbs.eetop.cn/thread-887124-1-1.html)
- [Cadence > Error found by spectre during hierarchy flattening.ERROR(CMI-2116): I91: Too few terminals given(4<6).](https://community.cadence.com/cadence_technology_forums/f/custom-ic-design/36207/error-found-by-spectre-during-hierarchy-flattening-error-cmi-2116-i91-too-few-terminals-given-4-6): it turns out that the module name in add_5 and add_3 are same, so add_5 override add_3.
- [EETOP > 瞬态仿真遇到的问题，仿真跑不起来](https://bbs.eetop.cn/thread-958313-1-1.html): 虚拟机内存不足，清理一下可以了

经过检查，是我们的 OTA 带来的报错 (删除后即可正常仿真)，于是回去检查各器件的参数，发现是 **finger = FN/3** 和 **finger = FP/3** 惹的祸 (因为我们 TB 中设置了 FN = FP = 1)，改为 finger = FN, fingerW = (2*WN/FN)/3 后即可正常仿真。

仿真得到 $I_B = 1.7 \ \mathrm{uA}$ 时总跨导 $G_m \approx 5.2 \ \mathrm{uS}$，嗯这出入其实挺大的 (我们的预期值是 30 uS). 先看一下 $I_B = 1.7 \ \mathrm{uA}$ 对应的静态工作点：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-15-20-06_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-14-19-32_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-14-19-13_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

注意这里用的是负反馈建立直流工作点，图中 outputs 中 N/P 指的是 NMOS/PMOS input pair. 下面是 $I_B = 1.7 \ \mathrm{uA}$ 时，跨导随共模电压的变化情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-14-28-49_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

再看看 $(V_{in,CM} = 0.6 \ \mathrm{V})$ 时，总跨导随电流的变化情况:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-14-16-10_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-14-10-43_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

$I_{B} = 0.1 \ \mathrm{uA},\ 1 \ \mathrm{uA},\ 10 \ \mathrm{uA}$ 时，总跨导随共模电压的变化情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-14-49-02_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>


从上面几张图片中，可以总结出下面思路：
- (1) 高电流时总跨导 $G_m$ 出现两个峰值，可通过减小 NMOS/PMOS 的 Vgs 来改善 (改善为单峰)，也即增大 a = W/L 以提高 gm/Id
- (2) 上面的操作会使总跨导显著上升，为保持 $G_m$ 基本不变，我们可以减小编制电流 $I_B$，这会进一步改善双峰问题

先提高 a = W/L:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-14-59-48_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

然后提高 a 的同时适当降低 $I_B$:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-15-07-40_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

### 2.3 iteration 2 (a_N = 2)

看一下 a_N = 2 时的整体性能 (I_B = 0.2 uA ~ 5.0 uA):


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-15-14-58_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-15-15-43_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

Vin_CM = 0.3 V, 0.6 V, 0.9 V 时的跨导：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-15-17-55_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

仍然存在一点点双峰问题，我们希望取得 20 uS 跨导时仍具有较好的单峰特性，从而后续引入 current-reuse 技术来大幅降低 gm variation, 于是继续提高 a = W/L. 




### 2.4 iteration 3 (a_N = 3)

经过测试, a = 3 似乎是个比较不错的选择：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-15-25-22_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

I_B = 2 uA 时，跨导中间点约 20 uS ，通过 current-reuse 即可将两端跨导也拉高到 20 uS. 进一步看看其它电流下的情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-15-30-40_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

随着 I_B 的减小，跨导两端下降得越来越厉害，这正是我们想要的。因为小电流时晶体管向 weak inversion 过渡，相同的 current-reuse 比例会带来更大的跨导提升，正好弥补小电流时较大的跨导下降。


### 2.5 if current-reuse?

注意 current-reuse 中用作开关的两个 pairs, 其 bulk 要接 Vdw/Vup 而不是 VSS/VDD, 因为要和两个输入对保持一致，版图时放在一起绘制，current mirror 则利用 multiplier = KR 实现，版图时单独作为一组：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-19-21-23_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

KR = 1 ~ 3 时的情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-18-59-36_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

图中 $g_{mN}$ 偏大了 (相比于 $g_{mP}$)，通过提高 $\left(\frac{g_m}{I_D}\right)_P$ (等价于提高 $a_P = K_A\times a_N$) 来改善。令 KR = 2, KA = 3 ~ 4 进行仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-19-03-35_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

继续增大 KA = 4 ~ 8:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-19-09-02_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

选择 KA = 8, 适当减小 AN = 2 ~ 3, 利用双峰来降低 gm variation (这会降低当前电流下的总跨导，后续适当提高电流即可):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-19-13-23_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

继续减小 AN = 1 ~ 2:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-19-24-53_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

嗯……一方面，我们的 KA 设置得有些大了，待会降到 5 试试；另一方面，current reuse 的打开比较 "迟"，过于偏向两边，没能很好地形成 "单缝 + 两边补偿" 的效果，作用一般般 (更高的 VDD 时才比较好用，例如 1.8 V ~ 2.5 V)。先调整完 AN 和 KA 再考虑单独修改 current-reuse 的开关 (提高 a = W/L) 以加快打开。

下面将 KR 暂时关闭进行仿真，降低 KA 的同时调整 AN:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-19-35-42_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

上面两边出现跨导下降是非常正常的，因为我们在仿真时使用了单位负反馈建立直流工作点，也即 $V_{out} = V_{in,CM}$。所以上图实际上也反应了 OTA 的输出电压范围，在这里达到了 0.15 V ~ 1.05 V, 是比较不错的。

显然，KA = 5 是一个比较合适的值。继续不打开 KR, 设置 **Vin_CM = 0.2 V ~ 1.0 V 和 (AN, KA) = (1.5, 5)** 仿真不同电流下的跨导：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-19-45-13_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

大电流双峰，小电流单峰，似乎是不可避免的。仿真一下 IB = 2 uA (Gm = 15 uS @ TT+25°C) 时的工艺角：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-19-55-08_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

除了 SS-40°C 直接不工作了，其它工艺角都还能接受。

### 2.6 one-peak + reuse

我们尝试大幅提升管子的 a = W/L 来保证 (SS, -40°C) 工艺角下的正常工作，由此  (其它温度-工艺角下) 产生的跨导单峰由 current-reuse 来补偿。设置 AN = 20 的效果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-20-16-17_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

看起来还行，现在在 (TT, +65°C) 工艺角下设计 current-reuse circuit. 对于 current-reuse 的两个输入对，**保持 fingerW = WN/FN or WP/FP 不变，设置其 finger = FN\*FR or FP\*FR 以方便迭代** (改之前是 finger = FN or FP)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-20-22-10_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

**<span style='color:red'> 做到这一步时，突然发现我们一直用的 2.5 V 管子，但 VDD = 1.2 V 其实应该用 `nch_dwn` 和 `pch`。问了导师后确实是这样的，得更换全部器件，ε=(´ο｀\*))) 唉。</span>**

有始有终一点，我们先看完引入 current-reuse circuit 的效果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-20-29-58_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

不对啊，这里怎么 DC Gm 都没 gmN (gmP) 大？回去检查了一下，这个问题在前面也有，毕竟后级 low-voltage cascode 作为 current folding circuit 是非理想的，但整体不太明显。

首先排除 current-reuse circuit 的影响：将其移去后重新运行仿真，也是只有 9.5 uS 左右，因此不是它的问题。那么便是 current folding circuit 的问题了，估计是 $a_N$ 和 $a_P$ 太大，晶体管工作区异常导致的。

看了一下确实是这样，那些管子的 gm/Id 达到了 22 ~ 27, 基本等于没有导通，也就起不到 current folding 的作用。罢了，先搭一下 1.2 V 的器件吧，这下器件的阈值电压有所降低，应该会形成比较好的单峰特性。





## 3. Design Details (1.2 V)

参考这几个链接以实现批量替换元器件：
- [EETOP > [求助] 如何在cadence中批量更改晶体管类型？](https://bbs.eetop.cn/thread-870935-1-1.html)
- [EETOP > [求助] Cadence电路里的instance name无法修改要怎么弄？](https://bbs.eetop.cn/thread-959314-1-1.html)
- [CSDN > Candence virtuoso之如何替换器件](https://blog.csdn.net/weixin_62567136/article/details/142780815)

像下面这样直接替换就行：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-21-19-31_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

换为 1.2 V 器件后原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-21-20-53_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

### 3.1 no current-reuse

如图，本小节将 current-reuse circuit 关闭进行仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-21-21-22_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

为保证各工艺角下均能正常工作，(大电流时) 正常工作的 input pair 应具有较低的 gm/Id 值，降低工艺波动的同时，保证小电流下 gm/Id 不会过高。即便是小电流下 (小跨导)，我们也希望 gm/Id < 16.



下面似乎是一个不错的初始参数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-21-30-03_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

看一下 (TT, +65°C) 工艺角下跨导随电流的变化情况，以及大电流下跨导随工艺角的变化情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-21-39-56_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-21-44-37_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

图中可以看出：
- (1) 此参数下的工作电流为 0.5 uA ~ 5 uA (对应跨导 2.3 uS ~ 22 uS)
- (2) 总跨导具有较好的 single-peaking 特性，适合引入 current-reuse
- (3) 不同工艺角下平均跨导有所变化，但基本形状不变，鲁棒性较好

可以引入 current-reuse 了！

### 3.2 with current-reuse

依上一小节的结果，我们希望 current-reuse circuit 能分别在 Vin_CM < 0.4 V, 

**KR = 1**, FR = 10 的结果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-21-49-32_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

FR = 10, **不同 KR 时** 的结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-22-08-41_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

呃 (⊙o⊙)… 这有些尴尬了, current-reuse 似乎 "没有效果"。为避免输出电压过低/过高影响后级工作状态，我们在反馈路径上加一个电压源 V = 0.6 V - Vin_CM, 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-22-15-16_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

重新运行仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-22-16-54_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

没有什么明显变化，看来不是后级 current folding 的问题。我们也排除了 ac Gm 的问题，那么到底是为什么？是因为 current folding circuit 没有对应地提供 reused-current 吗？我们加入后仿真看一下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-22-29-35_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-22-30-27_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

还是不行。回到最开始的 current-reuse 结构，修改一下 "开关" 的形式：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-22-40-24_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-22-41-06_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-22-43-36_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

上面的开关形式参考的是下面这篇论文：
>R. Hogervorst, J. P. Tero, R. G. H. Eschauzier, and J. H. Huijsing, “A compact power-efficient 3 V CMOS rail-to-rail input/output operational amplifier for VLSI cell libraries,” in Proceedings of IEEE International Solid-State Circuits Conference - ISSCC ’94, San Francisco, CA, USA: IEEE, 1994, pp. 244–245. doi: 10.1109/ISSCC.1994.344656.


貌似是挺有效的，设置 **KR = 1** 进一步看看不同电流下的跨导，以及全工艺角下的结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-22-48-38_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-22-53-25_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

此结构出奇地有效。将电压源提供的参考电压改为电阻分压：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-22-59-09_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

看一下 Vin_CM = 0.3, 0.6, 0.9 V 时跨导随电流的变化情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-23-06-18_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-23-09-13_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>


可以正常工作的 IB 和 Vin_CM 范围：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-23-13-18_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

IB = 500 nA 对应 Gm = 2 uS，此时整个共模范围内几乎总有输入对保持 gm/Id < 16, 可以正常工作。因此电路在 2 uS ~ 20 uS 范围内可调，在整个共模范围上均能正常工作。工艺角也基本没啥问题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-25-23-25-39_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

<!-- 图中还能看出  PMOS 跨导 (低共模) 略高于 NMOS 的跨导 (高共模)，于是再降低一点 KA (原先是 2.5): -->


<!-- 继续降低 current-reuse 的开关阈值，可通过升高支路器件的 gm/Id 来实现，等价于提高 a = W/L (但不能太高，否则低电流时晶体管 gm/Id 过高，工艺波动大)：
 -->

另外，按导师要求，我们还需要关注输入管的栅极漏电流，仿真一下看看：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-26-00-43-05_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-26-00-49-37_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-26-00-51-02_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

IB = 400 nA ~ 10 uA 时，跨导 Gm = 1.7 uS ~ 20 uS, 输入管的栅极漏电流在 ± 3.5 nA 以内。

### 3.3 transient verification

为验证电路的可行性 (其实是让自己更心安一些)，我们对 OTA 进行瞬态仿真验证，看看和前面的仿真结果是否一致：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-01-08-44_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

方波小信号输入 (50 mVamp):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-01-19-48_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

方波大信号输入 (50 mVamp):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-01-21-51_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>


正弦小信号输入 (50 mVamp):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-01-18-04_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

正弦大信号输入 (500 mVamp):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-01-13-49_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

嗯，基本上和前面的跨导仿真结果一致，说明电路是完全可行的。

### 3.4 in-out range

事实上，即便输入共模电压保持不变，OTA 的 "实际跨导" 也会有所变化：
- (1) 保持输出电压 (近似) 不变，差分输入差分电压的大小会影响跨导大小
- (2) 保持输入差分电压不变，输出电压的高低也会影响 (正/负) 跨导大小；例如输出电压低时，正跨导 (Vin_DM > 0) 大而负跨导 (Vin_DM < 0) 小，反之亦然

这两个方面共同决定了 OTA 的输入输出范围，超过这个范围，OTA 的跨导性能会显著下降，甚至无法工作。

下面我们就搭建 test bench 来仿真一下 OTA 的输入输出范围：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-01-32-57_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

若无特别说明，下面都默认输入共模电压为 0.6 V, 偏置电流 IB = 8 uA (对应跨导 Gm = 20 uS).

以输出电压为主变量，输入差分电压为次变量，分别仿真正跨导 (在 VINP 注入小信号) 和负跨导 (在 VINN 注入小信号)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-01-42-12_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-01-40-07_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

显然，正负跨导的值并不相同，但基本都可在 Vin_DM = 0 ~ 0.5V 且 Vout = 0.3V ~ 0.9V 时正常工作。

然后以输入差分电压为主变量，输出电压为次变量，分别仿真正跨导和负跨导：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-01-47-12_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-01-48-59_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

从上面四张图来看，负跨导的性能似乎始终更好一些，这与单端输出的不完全对称有关，我们不做深入讨论。



## 4. Current Control

### 4.1 design consideration

按导师的要求，我们的偏置电流要做成数控可调 (4-bit) 的形式，例如下面这样：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-26-01-16-59_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

用 4-bit 控制的话，一共 15 个单元，可调的范围大概是 0.533 uA ~ 8 uA，对应 Gm = 2 uS ~ 20 uS 这样。我们看一下这个电流范围下的工艺波动：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-26-01-21-25_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-26-01-27-06_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-26-01-28-41_202509_tsmcN65_OTA_constantGm_rail2rail.png"/></div>

嗯，在全温度-工艺角下能保持 2.5 uS ~ 15 uS 的调整范围，可以接受。

先将作为 variable 的参数都输入到原理图各器件中，然后将上面的 current control 加进去。注意外源偏置电流是 10 uA, 我们要通过 multiplier 来将其分割。

我们在这里采用 "过分割" 的思路，例如想得到 10uA/3.5 的一个电流，可以设置 multiple = 7 然后取 multiplier = 2, 即可实现 10uA/3.5 的分割。对我们的设计来说，要想得到 0.533uA = 10uA/18.7617 ≈ 10uA/18.75, 可以设置 multiplier = 75, 取 multiplier = 4 即可得到 10uA/18.75 = 0.533uA 的电流。

但是这样 multiplier 似乎有些太多了？分割 10 uA 需要 75 个 multiplier，后续一共 15 个单元都是 multiplier = 4, 总共需要 135 个 multiplier, 虽然这样还能降低工艺波动的影响，但确实有些多。

如果使用 10uA/18.5 = 0.5405uA 呢？一共需要 37 + 15*2 = 67 个 multiplier, 可以接受。

嗯……综合考虑下来，我们还是使用 10uA/18.75 = 0.533uA (共 135 个 multiplier) 吧，毕竟也不差这点面积。这里顺便提一下：由于每个 multiplier 的电流很小 (10uA/75 = 0.133uA), 要保证较低的工艺波动，宽长比需设置得很小，大概在 0.05 ~ 0.2 左右，multiplier 管子呈现 "上下矮，左右宽" 的布局，我们可以这样做版图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-02-23-36_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

这个偏置电路作为一个小模块单独拿出来做，然后再接到 OTA 上。

### 4.2 simul. verification

共 135 个 unit, 每个 unit 的电流为 0.133 uA, 可提供 4-unit ~ 60-unit 的电流 (0.533 uA ~ 8 uA)。为保证各工艺角下均能正常工作，结合 gm/Id 数据，我们设置 **单个 unit 的尺寸为 W/L = 0.15u/1u (a = 0.12)** ，其中 10 uA 输入管占据 75-unit.

提供 IB 的管子一共四组，依次为 multiplier = 4, 8, 16, 32；每组管子的使用两个 **单向通断的 PG (Pass Gate)** 作为控制开关 (我们将双向通断记作 TG, Transmission Gate)，启用时其 gate 接到 V_bias, 关闭时其 gate 接到 VSS. 最终原理图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-14-37-53_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-14-38-06_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

放到 OTA 中进行仿真验证：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-14-46-06_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-14-48-39_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

(TT, +65°C) 工艺角下偏置电路的 gm/Id 以及 OTA 可调跨导：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-15-04-55_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

全温度-工艺角下的情况：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-15-10-04_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

一方面偏置电路中提供 Ib 的管子，导通时其 gm/Id = 16, 这是比较高的，我们将其 length 从 1u 加长到 2u 试一试。另一方面，我们现在输入 = 0001 时 Ib = 640.7 nA (589 nA ~ 872.8 nA)，按导师要求，改为输入 = 0000 的时候，输出一路 320nA (TT, +65°C)，由此将最小跨导扩展到 1.5 uS。

修改 length 并添加 320 nA (multiplier = 2) 之后的仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-15-23-35_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-15-26-49_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-15-28-39_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-15-30-01_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

修改之后呢，在 (TT, +65°C) 工艺角下，可调电流是 299.3 nA ~ 9.553 uA, 对应跨导 1.247 uS ~ 22.90 uS 和 gm/Id = 13.86, 比上面的结果更好一些。全温度-工艺角下最窄范围是 1.819 uS ~ 18.2 uS, 最宽范围是 0.983 uS ~ 32.84 uS, 也都能接受。

## 5. Pre-Simulation (v1_271731)

给出准备前仿的原理图和全部器件参数 **(下图不是 v1 的最终参数，我们后面有所修改)**：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-16-33-51_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-16-34-10_202509_tsmcN65_OTA_constantGm_adjustable__layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-15-28-39_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

<!-- 各参数汇总如下：
- 可调偏置电路：
    - 所有电流源管子 L = 2u, W_N = 0.12u, W_P = 2.5*0.12u = 0.3u, F_N = F_P = 1
    - multiplier 已经设置好，无需再调整
- OTA 主体：
    - current-reuse: 
    - 所有管子 L = 1u, W_N = W_BN = 0.3u, W_P = W_BP = 2.5*0.3u = 0.75u, 所有 finger 都为 1
 -->

将这些参数全部填入器件中，然后进行前仿：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-12-40_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-17-59-34_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-00-50_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-17-59-09_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

设置 EN_total = 5 (0101) 对应 Gm ≈ 10 uS，仿真跨导随共模电压的变化情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-09-23_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

嗯……左右不对称比较明显，是输出电压偏置的问题，还是我们某个参数输入错误了？将负反馈路径改了一下，使输出法端静态偏置为 VDD/2 重新仿真，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-16-44_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-16-28_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

嗯，看来确实是参数设置的问题，于是回去检查并修改参数。

修改 input PMOS width = 0.9u 与 current-reuse 开关 multiplier = M:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-31-38_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-30-28_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

input PMOS width = 1u, 开关 multiplier = M:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-36-23_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

确定 input PMOS width = 1u, 开关 multiplier = 10 为最佳参数，将剩余 PMOS 管的 width 也作相应调整，得到：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-41-29_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-41-19_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-46-33_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-27-18-50-28_202509_tsmcN65_OTA_constantGm_adjustable.png"/></div>

嗯，这下看起来好多了，可以进入版图和后仿。

## 6. Layout and Post-Simul. (v1_271731)

版图和后仿放在了这篇文章：[202509_tsmcN65_OTA_constantGm_adjustable__layout](<AnalogICDesigns/202509_tsmcN65_OTA_constantGm_adjustable__layout.md>)


<!-- ## Experience Summary

- (1) basic: VDD = 2\*VTH (1.7\*VTH ~ 2.3\*VTH)
- (2) current-reuse: VDD >= 2.5\*VTH
 -->