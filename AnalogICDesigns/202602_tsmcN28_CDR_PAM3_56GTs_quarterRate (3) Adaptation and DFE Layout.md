# 202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 13:48 on 2026-03-17 in Beijing.
> dingyi233@mails.ucas.ac.cn


> 注：本文是项目 [A 56 GT/s Quarter-Rate Reference-Less PAM3 CDR (84 Gb/s, 14 GHz) in TSMC 28nm Technology](<Projects/A 56-GTs PAM3 CDR (84 Gbps, 14 GHz) in TSMC 28nm Technology.md>) 的附属文档，用于全面记录 CDR 的设计/迭代/仿真/版图/后仿过程。
> 前置文章是：
> [202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work](<AnalogICDesigns/202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.md>)
> [202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (2) Design of Key Modules](<AnalogICDesigns/202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (2) Design of Key Modules.md>)






## 10. VTH Adaptation 

TX-FFE/RX-DFE/RX-CTLE 的作用详见下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-02-23-18-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 图源：[A. Roshan-Zamir et al., “A 56-Gb/s PAM4 Receiver With Low-Overhead Techniques for Threshold and Edge-Based DFE FIR- and IIR-Tap Adaptation in 65-nm CMOS,” IEEE Journal of Solid-State Circuits, vol. 54, no. 3, pp. 672–684, Mar. 2019, doi: 10.1109/JSSC.2018.2881278.](https://ieeexplore.ieee.org/document/8580386/)



### 10.1 VTH adaptation algorism


原理和结构框图看导师之前发的那个 [DFE_Adaptation_Submit_内部.pdf](https://www.123865.com/s/0y0pTd-nelj3) 即可，我们将关键框图截个图放在这里：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-22-50-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

### 10.2 circuit implementation

具体到电路实现上，就分为了两种：
- (1) 模拟实现：利用上一小节的逻辑原理生成 UP/DN 信号驱动 charge pump 生成电压 Vref，并通过 CML 完成单转差同时保持合适的共模电平 for slicer TH input pair；这里 Vref 的默认值可以是 VDD，这样 CML 的另一边输入直接接 VDD 即可，这样做是为了用 nmos-input 得到偏 VDD 的输出共模电压
- (2) 数字实现：利用原理生成 EN 和 UP/DN 信号并由此驱动 8-bit up/dn courter (双向计数器，累加累减器)，计数器输出控制 R-2R DAC 输出参考电平 Vref；与模拟类似，这里 Vref 的默认值取 Vref = VDD @ TH<7:0> = <00...0>


在评估哪种方案更优之前，我们先看看数字的具体实现方法是怎样的：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-13-37-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.jpg"/></div>

然后是模拟方案的具体实现方法：
（这里放图）



### 10.3 design of up/dn counter


两个参考链接：
- [All About Circuits > Synchronous Counters](https://www.allaboutcircuits.com/textbook/digital/chpt-11/synchronous-counters/?__cf_chl_tk=gXl0sxxy10xy.8GS1fuNFQkV_QzYLEvEkw39aEaKbxc-1773041757-1.0.1.1-4esUzndadvfWrgnocn_j8Ti6ZSdZhAcPz7TA4GoKsU4)
- [Hackatronic > 4 Bit Synchronous Counters: Working and Applications](https://hackatronic.com/4-bit-synchronous-counters-working-and-applications/)

先参考下图搭建出最基本的 1-bit unit of UP/DN counter (不带有 EN 使能控制)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-16-42-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-16-43-08_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


其中 TFF 由 DFF + XOR gate 构成，只需将 Q 接到 XOR 输入端，然后 XOR 的另一个输入端即可作为 TFF 输入：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-16-47-44_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.jpg"/></div>


一个方便理解 XOR 作用的思路是将 XOR 理解为受控的 BUF/INV 门。也就是说： **将 XOR 的其中一个输入 B 看作控制信号，当 B = 0 时 XOR 输出就是 output = A，也即 A "穿过了 XOR 来到输出"，XOR 表现为 BUF；而当 B = 1 时，XOR 输出就是 output = A'，此时 XOR 表现为反相器 INV。** 简记就是 "0-BUF, 1-INV"



思考了一下，要加入 EN 控制有两种思路：
- (1) TFF 视作整体，在 TFF 和前面 XOR gate 中间插入一个 MUX2：当 EN = 1 时，MUX2_output = XOR 正常工作，当 EN = 0 时，MUX2_output = VSS 使 TFF 不发生翻转；
- (2) 将 TFF 拆开成 XOR + DFF，此时 DFF 前面共有两个 XOR gate, 不妨称为 1st/2nd XOR (2nd 离 DFF 更近)，然后在 2nd XOR 和 DFF 之间插入一个 3rd XOR：当 EN = 1 时；3rdXOR_output = 2ndXOR_output 正常工作，当 EN = 0 时，呃……好像这种思路不太行。

那我们采取第一种方法插入 MUX2 构成使能控制，得到 1-bit unit of UP/DN counter with EN control 如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-17-04-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


起始 1-bit unit 需要保持 XOR 输出恒为 1 (然后由 MUX2 控制是否工作)，并且生成正常的 CH/CL (carry_high/carry_low) 信号通往后级，想了一下如果用一位 UPDN 作为输入信号的话，前面这个 INV 确实省不掉。那我们还是把 UPDN 信号拆出来，形成 UP/DN 两个输入，然后 AND gate 的另一个输入端直接接 VDD 即可 (或者两个输入短接也行)。像下面这样：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-17-18-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.jpg"/></div>


这样做的思路是：输入正常时 UP/DN 恒保持反相，NAND 看作 BUF 直通，然后 XOR 输出恒为 1，保持正常工作的同时具有正常的 CH/CL 输出。

但是注意这样做有一个缺点：
- (1) 当 UP = DN = 1 (输入都为 ONE)，此时电路的状态取决于 1st TFF 的输出；1st_TFF_Q = 1 会导致后续 TFF 处于 UP 状态 (但 1st_TFF 输出维持不变)；1st_TFF_Q = 0 则会导致后续 TFF 处于 DN 状态 (但 1st_TFF 输出维持不变)；
- (2) 当 UP = DN = 0 (输入都为 ZERO) 时，所有 TFF 输出保持不变，相当于电路 EN = 0，这时倒不会出现异常。



构成 8-bit up/dn counter 来验证一下功能是否正常：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-18-44-54_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-18-45-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，看来确实是没有什么问题的。



### 10.4 VTH adaptation

在 ±200 mV PAM3 信号输入下 (input of SH)，我们的 summer 输出摆幅约为 ±170 mV。保险起见，我们要让 error slicer (amplitude detection) 能覆盖 ±340 mV 的实际差分阈值 (对应 ±400 mV PAM3 输入)，也即 ±170 mV actual THP --> ±460 mV input THP --> ±920 mV Vin_DM，这其实已经相当于一端为 VDD = 0.9 而另一端为 VSS = 0 了。

由此可见，我们用于单端转差分的 CML 输出摆幅得足够大，不妨设置 R = 0.5 kOhm 和 Iss = 2000 uA，这样理想情况下能有 ±1000 mV 的输出摆幅。当然，考虑到 current mirror 会占用一定 voltage headroom，可能最终输出摆幅在 ±850 mV 左右。


可是摆幅这么大的话，CML 输出共模电压怎么办？这里 0.5 kOhm @ 2 mA 的配置，输出共模为 0.5 V。相了一下，也是没办法的事情，只能说我们需要重新仿真 Vin_CM = 0.5 时的 CTH control characteristic (之前是 Vin_CM = 0.7)。


以及这里得到 CML output (input of error slicer) 之后，要进行分压。由于 VTH control 存在明显非线性，所以分压比也需尤为注意。初步打算如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-19-29-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.jpg"/></div>

先简单搭一个 CML 试试水，输入对尺寸可稍小一些以取得优良线性度：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-19-30-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


``` bash
Rp/R            = 0.0, 0.50, 1.00, 1.50, 2.00, 3.00
Vth_DM/Vout_DM  = 0.0, 0.20, 0.33, 0.43, 0.50, 0.60
```



搭建 VTH adaptation 电路如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-23-57-55_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-23-57-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


设置好条件进行仿真：
- time_end = 2^14 of bit_periods
- **Rp_rela = 1.5 (对应分压比 0.43)**
- RC_timeConstant = 0.9 @ tap_scale = 1.0
- fn_summercap = 4

结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-16-00-03-24_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-16-00-31-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



为避免出现 up/dn counter 从 all-zero 向下计数从而跳变到 all-one 的情况，我们对其 DN 机制进行微调，加入了 AND 和 OR8 gate 使得输出为 all-zero 时 DN 恒为零 (不能 EN 恒为零)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-16-01-31-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



设置 VTH_cap = {100f, 200f, 500f} 和 Rp_rela = {1.2, 1.5, 2.0} (依次对应分压比 0.375, 0.43, 0.50)，以及 SpectreFXAX @ 32-thread @ 1-job (每个 job 耗时 40 min)，得到仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-16-14-42-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-16-14-51-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>




将正负两边的 peak detection 交由两部分来实现 (POS/NEG)，并分别控制高位/低位的 slicer group。

仿真时遇到了 POS_THP 和 POS_ERRS_THP 节点电压完全相同的问题，然而原理图中并没有做短接，而是正常分压得到的 POS_THP。搞不懂问题出在哪里，最终无奈只能重新创建 pos 端的 peak detection 并重新给 net 命名，问题得到解决。此时的设置和仿真结果如下：
- time_end = 2^13 of bit_periods
- Rp_rela = 1.5 (对应分压比 0.43)
- RC_timeConstant = 0.9 @ tap_scale = 1.0
- fn_summercap = 4
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-00-52-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-01-04-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


我们将 POS_ERRS_THP/POS_ERRS_THN 的电压拉出来作分压，竟然还复现了这个问题，如下所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-00-37-25_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



### 10.5 eye optimization

注意到上一小节的结果中，summer 输出眼图在 kickback 之后出现了 "异常分叉"，初步认为主要由 slicer 从 summer TH input pair 耦合到 summer output 造成，于是保持其它参数不变而遍历 **fn_summercap = {1, 2, 4, 6, 8, 12} @ pre-sim**，结果如下 (interactive.259)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-13-49-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-13-46-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

上图可以观察到，随着 fn_summercap 增大，slicer 和 summer 输出眼图都有所恶化，这说明：
- (1) 之前 "用 summercap 来抑制 DFE feedback 时产生的反向电压波动" 这个思路是错误的，不应该加任何 summercap
- (2) 在做 summer 版图时，应当尽量减少 TP 和 OUTP 之间的寄生电容，以及 TN 和 OUTN 之间的寄生电容 (TP 上面是 OUTN, TN 上面是 OUTP)



为了对比有无 slicercap 的效果，我们又提取了 StrongARM_PET_v1d5 (使用 StrongARM_ENT_v2 + SRL8T_v2) 的 calibre，仿真设置同上 fn_summercap = {1, 2, 4, 6, 8, 12} @ pre-sim，结果如下 (interactive.260)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-13-58-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

上图显示：
- (1) 相比于 StrongARM_PET_v1d5 (w/o slicercap)，StrongARM_PET_v2 (w/i slicercap) 的输出眼图 "宽度略微增大，但是高度有所减小"。这是意料之中的，毕竟 slicercap 是算在 slicer 负载里
- (2) 有无 slicercap 哪种更好，从上面的结果暂时无法分辨，先持保留意见



固定 fn_summercap = 1，得到 StrongARM_PET_v1d5 在不同分压比下的表现 (interactive.261)：
- calibre of StrongARM_PET_v1d5
- time_end = 2^13 of bit_periods
- volt_scale = {0.35 0.38 0.40 0.42 0.45 0.50}
- RC_timeConstant = 0.9 @ tap_scale = 1.0
- fn_summercap = 1
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-14-09-24_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-14-13-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

上图可以看出：
- (1) 当前信号摆幅下的最佳分压比为 volt_scale = 0.42
- (2) 分压比可以稍微偏小，但尽量不要偏大 (<= 0.43)



interactive.262 是 StrongARM_PET_v2 在不同分压比下的表现：
- calibre of StrongARM_PET_v2
- time_end = 2^13 of bit_periods
- volt_scale = {0.35 0.38 0.40 0.42 0.45 0.50}
- RC_timeConstant = 0.9 @ tap_scale = 1.0
- fn_summercap = 1
- 注：当时设置 interactive.262 时有点失误，实际用的仍是 StrongARM_PET_v1d5，所以结果与 interactive.261 完全一致。正确使用 StrongARM_PET_v2 的结果重新仿了在 interactive.266，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-22-25-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

(⊙o⊙)…这个性能似乎比 v1d5 的又好一些，看来到底用哪个版本还不确定。


interactive.263 是 StrongARM_PET_v2 在不同 tap weight 下的表现：
- calibre of StrongARM_PET_v2
- time_end = 2^13 of bit_periods
- volt_scale = 0.43
- RC_timeConstant = 0.9
- tap_scale = {0.5, 0.7, 0.9, 1.1, 1.3, 1.5}
- fn_summercap = 1
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-16-28-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-16-32-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

上图可以看出，其实 **"summer 在 slicer 采样之后输出出现分岔" 这件事是 DFE tap weight 过高导致的** 。当然，这里说的 "过高" 是指 DFE fb 满偏之后的 summer 波形。由于 slicer 在 16 ps 处无法达到最大摆幅，所以我们的确是需要适当增大 DFE tap weight 来获得采样点瞬间的最佳性能。这一点从 tap weight from 0.5 to 1.5 时，slicer 眼图由差变好再变差可以看出。




interactive.264 是 StrongARM_PET_v1d5 在不同 tap weight 下的表现：
- calibre of StrongARM_PET_v2
- time_end = 2^13 of bit_periods
- volt_scale = 0.43
- RC_timeConstant = 0.9
- tap_scale = {0.5, 0.7, 0.9, 1.1, 1.3, 1.5}
- fn_summercap = 1
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-16-41-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

结论和上面 interactive.263 类似，不过 v1d5 的 slicer 和 summer 输出确实要更好一些。



interactive.265 是 StrongARM_PET_v2 在不同 volt_scale/RC_timeConstant/tap_weight 下的表现：
- calibre of StrongARM_PET_v2
- time_end = 2^13 of bit_periods
- volt_scale = {0.40 0.45 0.50}
- RC_timeConstant = {0.4, 0.8, 1.0, 1.2}
- tap_scale = {0.5, 0.7, 0.9, 1.1, 1.3, 1.5}
- fn_summercap = 1
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-21-47-50_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-21-48-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

这里总结一下不同 RC_timeConstant 下的最佳 tap weight，为后面 DFE adaptation 作参考 (下面数据默认 volt_scale = 0.45)：
- RC = 0.4 --> tap_scale = 1.1, ITAP1 = 66.31u (ITAP1/2 =  33.2u) --> eyeHW_SAM1_H = 0.311 = 0.693 x 0.499, eyeHW_SAM1_L = 0.414 = 0.866 x 0.478
- RC = 0.8 --> tap_scale = 0.9, ITAP1 = 147.2u (ITAP1/2 =  73.6u) --> eyeHW_SAM1_H = 0.727 = 1.370 x 0.531, eyeHW_SAM1_L = 0.759 = 1.403 x 0.541
- RC = 1.0 --> tap_scale = 0.9, ITAP1 = 167.4u (ITAP1/2 =  83.7u) --> eyeHW_SAM1_H = 0.670 = 1.237 x 0.542, eyeHW_SAM1_L = 0.653 = 1.214 x 0.538
- RC = 1.2 --> tap_scale = 1.3, ITAP1 = 255.6u (ITAP1/2 = 127.8u) --> eyeHW_SAM1_H = 0.647 = 1.209 x 0.535, eyeHW_SAM1_L = 0.557 = 1.084 x 0.514


<!-- ### 9.1 design considerations

``` bash
how to solve the issue of the extremely short feedback time interval of DEF in CDR，i.e., you must "design" the current data D[0] and feedback it to summer/slicer to cancel the ISI at D[1] caused by D[0]. 
For example, for a data rate of 56 Gb/s, the time interval between D[0] and D[1] is only 17.8571 ps. To obtain a best eyediagram performance, the best "desision-feedback time interval" should be 8.9286 ps, which is half of the data interval. However, it is very difficult to design a feedback loop with such a short time interval. How to solve this issue?
``` -->

从 interactive.259 中我们看出：增大 fn_summercap 会使 summer/slicer 眼图恶化，反过来减小能优化。那么我们能不能继续减小 fn_summercap? 比如 fn_summercap = 2 --> 1 --> -1 --> -2 --> -4 这样子，也就是当 fn_summercap < 0 时，意味着我们将原来 "交叉耦合" 的 summercap 修改为了 "非交叉耦合" (相当于增大输入管的 C_GD)。

说做就做，利用 v1d5 来尝试一下 (interactive.267)：
- calibre of StrongARM_PET_v1d5
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- RC_timeConstant = 0.9
- tap_scale = 0.9
- **(非交叉耦合)** fn_summercap = {1, 2, 4, 6, 8, 12} (使用 summer_v4，v2 是交叉耦合，v3 是没有 summercap)
- **注意这里 summer 的 main input pair 没有加电容，只在 DFE input pair 上加了电容**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-16-56-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




最后总结：




## 11. DFE adaptation

### 11.1 DFE adaptation algorism

参考资料 [DFE_Adaptation_Submit_内部.pdf](https://www.123865.com/s/0y0pTd-nelj3) 中介绍的 DFE adaptation for NRZ/PAM4 CDR，需要用到三种 slicer：
- DERR[n]  : output of peak slicer (slicer for peak detection)，前面 VTH adaptation 就用到这个，用于指示当前数据有没有超过 peak
- DUPP[n]  : output of top slicer (slicer for logic-high detection)，前面 VTH adaptation 也用到这个，用于指示当前数据是 HIGH
- DZTH[n-k]: delayed output of tap slicer (slicer with zero-threshold for DFE tap adaptation)，用于指示之前数据是 HIGH/LOW


对于 PAM3，上述逻辑需要做一些修改。同时，由于我们是分别做的 positive/negative peak detection，可以将 "DFE tap adaptation 仅在当前数据为 HIGH 时启用" 推广到 --> "DFE tap adaptation 在当前数据为 HIGH or LOW (NOT-CENTER) 时启用"。具体实现方法如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-17-18-04-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.jpg"/></div>



### 11.2 sim. verification

<!-- 仿真时又遇到了上次那个问题： **明明毫不相关的两个节点，却莫名出现了节点电压完全相同 (相当于短接) 的情况。** 具体而言，是 VA_DFE_Adaptation 模块中的节点 DL_nm1 出了问题。如下图 (后级没有任何负载，接的是理想 verilog-a 模块)，具体而言，DH_NM1/DL_NM1 两个节点是正常的，DH_nm1 也正常继承了 DH_NM1 的电压，但是 DL_nm1 的电压却与 DH_nm1 完全相同，好似短接一般：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-00-14-50_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

我们尝试过：
- 失败：使用 1 Ohm 电阻
- 失败：使用 cds_thru 来进行电压赋值 (继承)
- 使用 1 kOhm 电阻 -->

interactive.274 是 ERROR slicer 前带有理想 BUF 时，使用 StrongARM_PET_v2 在不同 RC_timeConstant 下的结果 (同时带有 VTH/DFE adaptation)：
- w/i summer BUF
- calibre of StrongARM_PET_v2
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- RC_timeConstant = {0.4, 0.8, 0.9, 1.0, 1.2, 1.5}

（图还没截，数据被覆盖掉了，心碎）



interactive.277 是 ERROR slicer 前带有理想 BUF 时，使用 StrongARM_PET_v1d5 在不同 RC_timeConstant 下的结果 (同时带有 VTH/DFE adaptation)：
- w/i summer BUF
- calibre of StrongARM_PET_v1d5
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- RC_timeConstant = {0.4, 0.8, 0.9, 1.0, 1.2, 1.5}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-17-33-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




interactive.276 是 ERROR slicer 前无理想 BUF 时 (两个 peak slicer 都由 summer0 带动)，使用 StrongARM_PET_v2 在不同 RC_timeConstant 下的结果 (同时带有 VTH/DFE adaptation)：
- w/o summer BUF
- calibre of StrongARM_PET_v2
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- RC_timeConstant = {0.4, 0.8, 0.9, 1.0, 1.2, 1.5}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-17-34-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



interactive.278 是 ERROR slicer 前无理想 BUF 时 (两个 peak slicer 都由 summer0 带动)，使用 StrongARM_PET_v1d5 在不同 RC_timeConstant 下的结果 (同时带有 VTH/DFE adaptation)：
- w/o summer BUF
- calibre of StrongARM_PET_v1d5
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- RC_timeConstant = {0.4, 0.8, 0.9, 1.0, 1.2, 1.5}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-17-35-07_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




interactive.279 是 ERROR slicer 前有理想 BUF 时 (两个 peak slicer 都由 summer0 带动)，使用 StrongARM_PET_v2 在不同 RC_timeConstant 和 CML_IR 下的结果 (同时带有 VTH/DFE adaptation)：
- w/i summer BUF
- calibre of StrongARM_PET_v2
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- RC_timeConstant = {0.4, 0.8, 0.9, 1.0, 1.2, 1.5}
- CML_IR = {200m, 250m, 300m, 350m}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-17-36-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



interactive.280 是 ERROR slicer 前有理想 BUF 时 (两个 peak slicer 都由 summer0 带动)，使用 StrongARM_PET_v1d5 在不同 RC_timeConstant 和 CML_IR 下的结果 (同时带有 VTH/DFE adaptation)：
- w/i summer BUF
- calibre of StrongARM_PET_v1d5
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- RC_timeConstant = {0.4, 0.8, 0.9, 1.0, 1.2, 1.5}
- CML_IR = {200m, 250m, 300m, 350m}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-17-38-27_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


从上述几个仿真结果可以看出：
- (1) slicer peak detection 的 cover range 不太够，导致 CML_IR 较大且 RC_timeConstant 较小时 peak detection 失败
- (2) 有 ideal summer BUF 条件下，StrongARM_PET_v1d5 (w/o slicercap) 的性能似乎更好一些；但是无 ideal summer BUF 条件下，StrongARM_PET_v2 (w/i slicercap) 的性能似乎更好一些？
- (3) 相同条件下，有无 ideal summer BUF 对 positive slicer 影响稍小，对 negative slicer 影响更大些；然后在没有 ideal summer BUF 的情况相爱，
- 该如何避免一个 summer 带载四个 slicer 的情况 (kickback 更明显)？还得再考量考量




### 11.3 larger VTH cover range


为扩大 VTh control 范围以避免 peak detection 失败，我们将 500 Ohm --> 600 Ohm (x 1.2)，fn_tail of slicer VTH control = 16 --> 24 (x 1.5)



interactive.281 是 ERROR slicer 前有理想 BUF 时，使用 StrongARM_PET_v1d6 (w/o slicercap) 的效果：
- **w/i summer BUF**
- calibre of StrongARM_PET_v1d6 **(w/o slicercap)**
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- RC_timeConstant = {0.4, 0.6, 0.7, 0.8, 0.9, 1.0, 1.2, 1.5}
- CML_IR = 300m
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-19-37-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

查看 POS_ERRS_THP/POS_ERRS_THN 的电压波形可知，用于 VTH 单转差的 CML BUF，其任意一个输出端，最高电压等于 VDD 没错，但最低电压被限制在了 Vov_Iss ≈ 200 mV，导致虽然有 Iss\*R = 2 mA \* 600 Ohm = 1200 mV，但最大差分输出实际被限制在了 (VDD - Vov_Iss) = 700 mV。为解决此问题，我们：
- (1) 将 Iss\*R 改回 2 mA \* 500 Ohm = 1000 mV (没必要过大)
- (2) 增大 CML BUF 尾管尺寸以降低 Vov_Iss

当然，其实也可以不改尾管尺寸，而是换为 Iss\*R = 1 mA \* 1000 Ohm = 1000 mV。这样尾管只需承载 1 mA 电流，Vov_Iss 也能有效降低。

观察到 negative slicer 表现略差于 positive slicer，认为是 slicer offset 所导致的：如下图，相比于 nominal volt_scale 值，positive volt_scale 应当稍微减小，而 negative volt_scale 应当稍微增大，才能得到最佳效果。 **当然，最好还是加一个 calibration input pair 来进行校准。**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-18-30-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.jpg"/></div>



interactive.285 是增大 CMLBUF 尾管尺寸 fn_tail from 16 to 32 后，ERROR slicer 前无理想 BUF 时，使用 StrongARM_PET_v1d6 的效果：
- **CMLBUF = 2 mA \* 500 Ohm = 1000 mV @ fn_tail = 32 (原来是 16)**
- **w/o summer BUF**
- calibre of StrongARM_PET_v1d6 **(w/o slicercap)**
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- RC_timeConstant = {0.4, 0.6, 0.7, 0.8, 0.9, 1.0, 1.2, 1.5}
- CML_IR = 300m
- 这个仿真是和上面的 interactive.281 作对比，看看增宽尾管后的 CMLBUF 怎么样
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-20-42-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

增大 CMLBUF tail 管尺寸后，可输出的最大差分却并没有增大，反而有所减小，真是怪事，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-19-32-44_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


不仅如此，增大 CMLBUF tail 管尺寸后，本来能正常工作的地方也不能正常工作了。也许跟没使用 summer BUF 有点关系，但主要原因应当还是这个 CMLBUF tail。既然这样，我们还是使用原来的 CMLBUF = 2 mA \* 500 Ohm = 1000 mV @ fn_tail = 16 这个参数吧。





### 11.4 offset auto-calibration


考虑到：
- (1) 从之前 summercap 时的结果可以看出，一个 slicer 输出即便反馈到两个 summer DFE input pair 也是 OK 的；虽说牺牲了一定 slew rate，但影响并不是那么大
- (2) 当前 summer0 后级除了带 pos/neg data slicer0 两个比较器之外，还带了 pos/neg peak slicer 两个比较器，一共四个比较器会使 kickback 更加明显，不仅影响到 slicer0 本身的鲁棒性，更是影响到了 VTH/DFE adaptation，从而影响整个系统的性能
- (3) slicer 的 equi. input offset 比较大，导致最佳 pos/neg volt_scale 的值不同。为充分抑制 slicer input offset 带来的负面影响，需引入 calibration input pair

我们：
- **(1) 限制 UP/DN counter 溢出：** 将 UP/DN counter 从原来的仅 bound0 (from all ZERO to all ONE is forbidden) 进一步修改为 bound01，也就是 all ZERO --> DN --> all ONE 和 all ONE --> UP --> all ZERO 都是不允许的；以 VH control 为例，这样做的好处是避免了 "计数 --> 溢出 --> 计数 --> ..." 的循环，使得本来进入循环没有结果的环路得到一个眼图稍差些的结果。
- **(2) 增加 summer_copy：** 将两个 peak slicer 从原来的 summer0 中抽出来，复制一个与 summer0 输入完全相同的 SUM 称为 summer_copy。此时 summer_copy 的输入与 summer0 相同，包括 output of SH0 以及 output of last slicer for DFE；并且 summer_copy 的输出接两个 peak slicer。
- **(3) 增加 slicer calibration input：** 当前 StrongARM 的尾管尺寸为：fn_main = 20, fn_VTH = 24 (覆盖约 ±250 mV DM_swing of summer)；我们加入 calibration input pair 的同时设置各支路尺寸为：fn_main = 20, fn_VTH = 24, fn_cali = 4 (覆盖约 ±40 mV DM_input offset of slicer)；
- **(4) 增加 auto-calibration of slicer offset：** 将 calibration DM voltage 的生成交给另一路 adaptation，具体而言：将 summer0 (or summer_copy) 的输出引出来，接上两组低通滤波器 (R = 50k, C = 1 pF, tau = 50 ns) 从而得到 summer 输出共模电压，记作 summer_VoutCM。将此共模电压接到 slicer_cali 作为输入 (DINP = VTHP = summer_VoutCMP)，根据 slicer_cali 的输出来作 calibration；最终在 (summer_VoutCMP - summer_VoutCMN) = 0 时所有 slicer 的 input offset 得到矫正。



把 "(1) 限制 UP/DN counter 溢出" 和 "(2) 增加 summer_copy" 做了之后先简单验证一下 (interactive.286)：
- **w/o ideal summer BUF** (若无特别说明，后面都没有 ideal summer BUF)
- calibre of StrongARM_PET_v1d6 **(w/o slicercap)**
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- RC_timeConstant = 0.9
- CML_IR = {200m, 300m}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-21-20-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-21-58-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-21-28-49_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

嗯，adaptation 正常工作，summer_copy 的眼图也与 summer0 几乎相同，与预期相符，应当是没有其它问题。


然后是给 slicer 加入 calibration input，我们命名为了 `CDR_ulvt_1d0_1000nx2_30n_Slicer_ENT_StrongARM_VTH_CALI_v1` 和 `CDR_ulvt_1d0_1000nx2_30n_Slicer_PET_StrongARM_VTH_CALI_v1`，ENT_schematic 和 PET_layout 如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-21-46-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

两路输出分别使用 RC LPF 以分别获得 DC value，波形如下 (两电容不能合并为一个，否则共模电压存在波动，只能对差分进行滤波)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-22-32-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

这里唯一的难点是如何生成 "可正可负的差分电压 CALIDM = (CALIP - CALIN)"，我们上面的 VTH/DFE adaptation 都只需要生成正的就行，所以只需一个 up/dn counter 和一个 DAC。想半天暂时想不出什么方法，还是先搞两个 DAC 上去，后面看看情况再做修改。


auto-calibration of slicer offset (或许也能起到 IIR DFE 的作用？) 的具体实现方法如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-18-23-07-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.jpg"/></div>


搭建完电路，仿真环路之前先看看 StrongARM_PET_VTH_CALI_v1 的 offset 情况怎样，在 TB_Slicer 中作仿真：

（这里放图）

果然，和之前预料的一样，我们的 slicer offset 应该极小才对，毕竟我们的版图非常对称。像上面的结果就表明 |Vin_DM_offset| < 2 mV，之前整整 40 mV 的 Vin_DM_offset 完全是意外 (虽然我也不知道这意外是咋来的)。


interactive.290 是用理想源设置 CALIP = CALIN = (VDD - 500*1m) = 0.4 时的结果：
- **w/o auto-calibration** of slicer offset (CALIP = CALIN = 0.4)
- calibre of PET_StrongARM_VTH_CALI_v1 (w/o slicercap)
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- RC_timeConstant = 0.9
- CML_IR = 200m
- SpectreFXAX @ 16-thread x 2-job, time used = 27 min
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-01-12-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-01-13-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

相比前面的 StrongARM_PET_v1d6 或者 StrongARM_PET_v2d1，这里 slicer 输出眼图似乎更优秀了些？



interactive.292 是带有 auto-calibration 时的结果：
- **w/i auto-calibration** of slicer offset
- calibre of PET_StrongARM_VTH_CALI_v1 (w/o slicercap)
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- RC_timeConstant = 0.9
- CML_IR = {200m, 300m}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-01-22-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-01-46-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

（尝试过用 CK_DIV4 作为 calibration 部分的时钟，抖动现象一致，说明不是 slicer 速度问题；而是在 Vin_DM 较小时，存在一定 "滞回效应" 导致的）为验证 offset calibration 到底会不会影响正常性能，我们在 CALI 前再加一个 LPF (RC = 1 ns)，使得 CALIP/CALIN 只能缓慢变化。 **实际电路实现时，由于 calibration 的时钟肯定不会有 14 GHz，估计在 1.75 GHz 左右 (0.57 ns)，我们可以考虑加一个 lock detection 来取滞回的中间值。**

加了 RC LPF 之后发现系统存在振荡，看来不是 "滞回效应" 的问题，而是系统稳定性的问题，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-01-54-44_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>






上面 interactive.292 表明稳定时应当有 CALI_DM = -14 mV，具体而言有 CALIP = 630m + (-14m)/2 而 CALIN = 630m - (-14m)/2。我们这样设置之后，先用同样参数 (CML_IR = 200m @ RC = 0.9) 仿一次，看看眼图是不是比 interactive.290 稍好一些：
- interactive.298
- **w/o auto-calibration** of slicer offset
- CALIP = 630m + (-14m)/2, CALIN = 630m - (-14m)/2, CALI_DM = -14m
- calibre of PET_StrongARM_VTH_CALI_v1 (w/o slicercap)
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- CML_IR = 200m
- RC_timeConstant = 0.9
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-15-55-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



随后再进行详细仿真：
- interactive.299
- **w/o auto-calibration** of slicer offset
- CALIP = CALIN = 0.4
- calibre of PET_StrongARM_VTH_CALI_v1 (w/o slicercap)
- time_end = 2^13 of bit_periods
- volt_scale = 0.42
- CML_IR = {200m, 300m, 350m, 250m} = 3-point
- RC_timeConstant = {0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6} = 8-point
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-13-52-31_markdown.png"/></div>

上图观察到：
- (1) 随着 CML_IR 增大，环路的 cover range 应该更大才对，可这里却有明显恶化，难道是 offset 或者 volt_scale 导致的吗？
- (2) 随着 CML_IR 增大，negative 端的比较器眼图明显差于 positive 端，而且 cover range 也更小，难道是 offset 和 volt_scale 共同导致的吗？



以 (CML_IR, RC) = (350m, 1.0) 为例，此时 pos_eyeHW = 0.415 还算能接受但 neg_eyeHW = 0.054 已经存在误码。看看各关键波形：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-14-05-49_markdown.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-14-09-56_markdown.png"/></div>

然后结合 slicer 的 VTH control characteristic (interactive.410/411 of TB_Slicer) 曲线来分析下原因：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-15-41-36_markdown.png"/></div>

上图显示稳定后有：
- (1) NEG_ERRS_VTH = 559.4 mV, NEG_VTH = 236.9 mV (volt_scale = 0.42)
- (2) POS_ERRS_VTH = 520.4 mV, POS_VTH = 225.2 mV (volt_scale = 0.42)
- (3) TAP1_IB = 65.62 uA
- (4) eye_peak of summer0 = 185 mV, best slicer VTH = 84 mV (actual_scale = 0.454)
- (5) 当前电压比：
    - POS: f(x) = 185/559.4 = 0.331, f(x) = 84/236.9 = 0.355
    - NEG: f(x) = 185/520.4 = 0.355, f(x) = 84/225.2 = 0.373
- (6) VTH control chara @ CALI_CM = 0.4
    - f(x) = actual_VTH/Vin_DM = 191.5m/559.4m = 0.342, 98.8m/236.9m = 0.417
    - f(x) = actual_VTH/Vin_DM = 180.0m/520.4m = 0.346, 96.0m/225.2m = 0.426

简单来讲，最佳实际阈值比为 actual_scale = 0.454 = actual 84m/185m 对应有 volt_scale = input 189.9m/551.4m = 0.344，而我们之前设置的是 volt_scale = 0.42 明显偏大，导致输出眼图不好。


为验证上述猜想，我们固定 (CML_IR, RC) = (350m, 1.0)，设置 volt_scale = 0.32 ~ 0.57 进行仿真，得到结果如下：
- CALIP = CALIN = 0.4 (w/o auto-zero)
- calibre of PET_StrongARM_VTH_CALI_v1 (w/o slicercap)
- time_end = 2^13 of bit_periods
- volt_scale = {0.32, 0.35, ..., 0.57} = 8-point
- CML_IR = 350m
- RC_timeConstant = 1.0
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-17-39-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

上图显示 (CML_IR, RC) = (350m, 1.0) 时，环路在 volt_scale = {0.51, 0.54, 0.57} 时可正常工作，其中 volt_scale = 0.54 时表现最佳，在 volt_scale <= 0.42 时反而不能正常工作。

呃 (⊙o⊙)…… 仿真结果与我们的推测相反：我们认为应该减小 volt_scale，而结果显示增大 volt_scale 才能得到更优性能，这是为什么？虽然不知道为什么，但是无妨，只要能 cover 住就可以。




### 11.5 detailed verification


最后验证一下环路在不同 CML_IR 下都能正常工作：
- CALIP = CALIN = 0.4 (w/o auto-zero)
- calibre of PET_StrongARM_VTH_CALI_v1 (w/o slicercap)
- time_end = 2^13 of bit_periods
- (CML_IR, volt_scale) = {(200m, 0.32), (300m, 0.50), (350m, 0.54)}
- RC_timeConstant = {1.0, 1.2}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-20-17-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

``` bash
  IT("/I118<0>/VDD")
+ IT("/I118<1>/VDD")
+ IT("/I118<2>/VDD")
+ IT("/I118<3>/VDD")
+ IT("/I117<0>/VDD")
+ IT("/I117<1>/VDD")
+ IT("/I117<2>/VDD")
+ IT("/I117<3>/VDD")
```

对于 CML_IR = 300m @ RC = 1.2 的情况，再试试不同的 volt_scale:
- interactive.305/306
- CALIP = CALIN = 0.4 (w/o auto-zero)
- calibre of PET_StrongARM_VTH_CALI_v1 (w/o slicercap)
- time_end = 2^13 of bit_periods
- CML_IR = 300m
- volt_scale = {0.45, 0.47, 0.49, 0.53, 0.55, 0.58}
- RC_timeConstant = 1.2
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-20-00-07-28_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

在 CML_IR = 300m @ RC = 1.2 下，至少增大至 volt_scale = 0.55 时 neg 端比较器才能正常工作，真是怪事。




固定 (CML_IR, RC, volt_scale) = (300m, 1.2, 0.54) 用理想源施加 calibration 电压进行仿真，结果如下：
- interactive.310/312
- CALI_DM = {-160m, -80m, -40m, -20m, -10m, 0, 10m, 20m, 40m, 80m, 160m} @ CALIP = 0.45
- calibre of PET_StrongARM_VTH_CALI_v1
- time_end = 2^13 of bit_periods
- CML_IR = 300m
- volt_scale = 0.54
- RC_timeConstant = 1.2
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-20-16-05-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

<!-- 上图中 calibration 的作用不是很明显，但还是能依稀看出：上述参数设置下，合适的 calibration 设置大概是 CALI_DM = +40m
 -->

然后看看不同 calibration 电压下的所有结果：
- interactive.313
- CALI_DM = {-80m, -40m, -20m, 0, 20m, 40m, 80m} @ CALIP = 0.55
- calibre of PET_StrongARM_VTH_CALI_v1
- time_end = 2^13 of bit_periods
- (CML_IR, volt_scale) = {(200m, 0.45), (250m, 0.49), (300m, 0.53), (350m, 0.55)}
- RC_timeConstant = 1.2
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-20-16-07-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

上图结果显示：
- (1) 从 CML_IR = 200 mV 时的结果可以明显看出，随着 CALI_DM 增大，pos 端眼图恶化而 neg 端眼图优化，说明 calibration 确实起到了 offset control 的效果。
- (2) 但 CML_IR 更大时就不太明显，尤其是 CML_IR = 300m or 350m 时，neg 端基本不能正常工作，猜测是 volt_scale 设置不合适导致的。毕竟我们在 interactive.305/306 中看出，CML_IR = 300m 时应设置 volt_scale >= 0.55，而 CML_IR = 350m 时 volt_scale 估计还得大很多。


然后来考察 (CML_IR, RC) = (300m, 1.2) 时 calibration 的作用：
- interactive.314
- CML_IR = 300m
- volt_scale = 0.56
- RC_timeConstant = 1.2
- CALI_DM = {-80m, -40m, -20m, 0, 20m, 40m, 80m} @ CALIP = 0.55

结果发现环路在上述条件下竟然不能工作，真是奇怪了！无奈进一步仿真更详细的设置，看看问题出在哪里：
- interactive.315
- CML_IR = 300m
- RC_timeConstant = 1.2
- CALI_DM = {-40m, 0} @ CALIP = 0.55
- volt_scale = {0.55, 0.57, 0.59, 0.64}

竟还是不能正常工作！这到底是个什么情况。



将 adaptation-path 的 SH 也 copy 上来 (copy 的 SH0)，构成相对 "独立" 的一路，然后重新仿真看看：
- interactive.316
- CML_IR = 300m
- RC_timeConstant = 1.2
- **CALIP = CALIN = 0**
- volt_scale = {0.49, 0.52, 0.55, 0.58}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-22-00-08-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

从 eyeH_min 可以看到，除了 volt_scale = 0.49 时勉强通过，其它 volt_scale 都或多或少存在可能的误码现象。


设置不同的 calibration 电压进行全面仿真：
- interactive.317
- CML_IR = 300m
- RC_timeConstant = 1.2
- CALI_CM = {0.40, 0.65}, CALI_DM = {-80m, -30m, 0, 30m, 80m}
- volt_scale = {0.42, 0.45, 0.49, 0.52, 0.55, 0.58}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-22-00-15-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

也是有一些参数组合是没有误码现象的，比如下面几个，但从中实在看不出什么规律来：
- (volt_scale, CALI_CM, CALI_DM)
- 0.45, 400m, -80m
- 0.49, 400m, {-80m, 30m, 80m}
- 0.49, 650m, 30m
- 0.52, 400m, {-80m, -30m, 30m}
- 0.52, 650m, 0
- 0.55, 650m, 30m





``` bash
0.25*(eyeH_SAM0_H + eyeH_SAM1_H + eyeH_SAM2_H + eyeH_SAM3_H)
0.25*(eyeH_SAM0_L + eyeH_SAM1_L + eyeH_SAM2_L + eyeH_SAM3_L)
```


开启 auto-zero 看看情况：
- interactive.318
- RC_timeConstant = 1.2
- (CML_IR, volt_scale) = {(200m, 0.42), (300m, 0.49)}
- enabled auto-zero (w/o lock detection)
- auto-zero CML R = 700 Ohm

CALI 输出仍存在振荡 (-80 mV ~ 30 mV)，平均值为 CALI = -17.72 mV (CALIP = 536.6 mV, CALIN = 554.3 mV)，CALI_dec = 127


开启 auto-zero 看看情况：
- interactive.319: 相比 318，这里将 auto-zero 中 CML 的电阻从 R = 700 Ohm 改为 R = 1 kOhm
- RC_timeConstant = 1.2
- (CML_IR, volt_scale) = {(200m, 0.42), (300m, 0.49)}
- enabled auto-zero (w/o lock detection)
- auto-zero CML R = 1 kOhm

CALI 输出仍存在振荡，平均值为 CALI = -8.786 mV (CALIP = 539.5 mV, CALIN = 548.3 mV)，CALI_dec = 127


- interactive.320: 相比 319，这里将校准输出改为了 CALI_pre，不引入额外的 RC LPF (猜测是引入额外极点导致的稳定性问题？)
- RC_timeConstant = 1.2
- (CML_IR, volt_scale) = {(200m, 0.42), (300m, 0.49)}
- enabled auto-zero (w/o lock detection)
- auto-zero CML R = 1 kOhm

CALI 输出仍存在振荡，数字码振荡幅度减小 (121 ~ 131)，但是输出电压振荡幅度基本不变 (-80 mV ~ 30 mV)，平均值为 CALI = -25 mV (共模电压约 550 mV)，CALI_dec = 127


- interactive.322: 相比 320，在 CML 输出端两个接地电容上额外加了 1 kOhm 电阻 (类似 ESR)，中间的电容倒是没加
- RC_timeConstant = 1.2
- (CML_IR, volt_scale) = (200m, 0.42)
- enabled auto-zero (w/o lock detection)
- auto-zero CML R = 1 kOhm

结果和 320 一模一样，没啥区别。



- interactive.323/324: 去除刚刚加的 1 kOhm 电阻，把校准模块的时钟降速到 CK_DIV4
- RC_timeConstant = 1.2
- (CML_IR, volt_scale) = (200m, 0.42)
- enabled auto-zero (w/o lock detection)
- auto-zero CML R = 1 kOhm

振荡范围变为 122 ~ 129 (-80 mV ~ 10 mV)，共模电压约为 550 mV。但是相比之前的结果，此次八个 slicer 中有且仅有一个 (SAM2_L) 出现误码情况，其它均能正常工作，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-22-16-23-28_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




ε=(´ο｀*)))唉，没办法了，看来 auto-zero 部分的 lock-detection 是必须的。也许我们加入 lock detection 后，性能上会有一定提升？没有也无妨，直接不用就是。






## 12. layout of DFE

### 12.0 next arrangement

2026.03.19 下午与导师讨论之后，下一步计划是：
- (1) 在 slicer CK input 前面集成 CK BUF (两个反相器)，降低时钟负载；这里不宜用四个反相器因为 delay 和 jitter 会被累积；
- (2) 把 summer 版图先做出来，暂时先用着 2 mA 偏置电流 (肖师兄那边是 1.6 mA，所以也省不到哪去)
- (2) 然后把 1-SH + 1-summer + 2-Slicer 的一路 layout 做出来
- (3) 将 adaptation 从原来的 "COPY_summer" 改为 "COPY_SH"，也即从前面的 SH 开始就直接 copy 上来
- (4) 把 4-data + 1-adaptation 的五路 SH-Summer-Slicer 版图做出来，用这一坨的 calibre 来做后仿

至于其它：
- (1) adaptation 用到的 Counter/DAC/CMLBUF 等前面完成后再做
- (2) DAC 的速率目前考虑用 3.5 GHz @ 14 Gbaud (4.0 GHz @ 16 Gbaud)，也即四分之一时钟速率；这样的话从 Counter 到 DAC 之间似乎可以加一个 digital LF，比如 4-data 平均 FIR 滤波器？但这样会需要 8 x 3 = 24 个 DFF @ 14 GHz，每个 DFF 功耗 13.24 uA/GHz，算下来一共是 4.5 mA，确实是不小。到时候具体再看吧
- (3) 


下面是我们自己的 DFE layout standard:

上下边界规范：
- 上下 OD/M1 边界高度 = 6.56 um
- 上下 PP/NW 边界高度 = 6.62 um
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-20-01-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

NW-tap 规范：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-20-05-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

一半单元上下边界规范：
- 上下 OD/M1 边界高度 = 6.56 um
- 上下 PP/NW 边界高度 = 6.62 um




### 12.1 relayout of SH

原 S/H 电路架构如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-22-38-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

对 SH 版图进行适当修改，使其符合我们的 layout standard，后面拼起来大概是这个样子 (中间 summer 没画)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-23-06-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


**我们在原版的基础上，修改了上下拼接细节，去除了杂七杂八的无用端口，schematic/symbol 中修改了 Pin 属性，版图上加了 IO Pins，修改了 Symbol 样式，最终得到结果如下：**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-20-00-23-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-20-00-24-29_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



### 12.2 layout of summer


summer 前面接 SH，这个好说，直接 IO 对应连接就好。后面这里一个 summer 对应两个 slicer，而且两个 slicer 的 SAMQ/SAMQB (Q_PRE/QB_PRE) 输出还要接到下一路的 summer，我们考虑使用 M5/M6 两层这样走线：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-20-17-12-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-20-17-19-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


这样的话，summer 的 I/O 就全部连接完成，slicer 也只剩 CK/TH/CALI 三组端口。CK 可以走 M7，而 THP/THN 可以分成左右两条都走 M5 (所有 slicer 的连到一起)，最后 CALIP/CALIN 的话是在右侧分成上下两条走 M4/M5 即可。这样内部连接就完全不涉及 M7 及以上端口，给 CK 和 VSS/VDD 留出充足空间。


最终版图效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-20-17-51-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

直接上下拼接也不会有 DRC 报错：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-20-17-53-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


PEX 提取结果显示，MAIN_VB (or TAP1_VB) 与 VSS 之间具有 25 fF 左右的总电容，这与我们之前的预期一致。其它剩余网络的总 CC 寄生均在 6 fF 以内，无明显影响。尤其是负载比较敏感的 DFE 接口 T1_HP/T1_HN/T1_LP/T1_LN，总 CC 寄生均在 1 fF 以内，符合要求。





### 12.3 slicer with CK BUF

CK BUF 要求：
- (1) CK 上升沿要快些，下降沿稍慢也无妨
- (2) 

在 `CDR_ulvt_1d0_1000nx2_30n_Slicer_PET_StrongARM_VTH_CALI_v1` 的基础上加入 CK BUF (两个反相器)，设置和仿真结果如下：
- ka = 1.5 ~ 2.5
- fn_inv1 = 4 ~ 12
- fn_inv2 = 8 ~ 24
- 得到 rf-sim 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-20-26-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-20-31-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


修改参数进一步仿真：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-19-22-32-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

最终选用 PMOS/NMOS = 8um/6um --> 16um/12um



### 12.4 Core 1-bit unit (SSS, SH + Summer + Slicer)

1-bit unit 初步布局如下 `202602_CDR__SSS_1bitUnit_v1_20260321`，从左到右依次是 SH/Summer/Slicer：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-21-19-45-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


2026.03.21 19:45 与导师讨论后，作出以下调整：
- (1) SH 整体往左移，中间空出来在 M8 竖着走八相时钟 (总宽度约 10um)；
    - 虽然我们的 M8 本来就有预留，但是如果直接在上面走，会导致每一相时钟下面 “看到” 的电路不一样，引入相差；
    - 空出来之后，虽然 SH -> Summer 走线变长，但影响不大，毕竟时钟更重要。
- (2) Slicer 的 CKBUF 从左边移到右边，然后在 SR-Latch 后面加反相器做解耦；
    - 因为给 Slicer 的 CK 要在右边竖着走下来，CKBUF 移到右边自然更好；
    - 与上面类似，右边需要空出一段距离竖着走 CK，所以 SRL 后面的 data 走线距离较远，因此要加一个 INV 作解耦。





### 12.5 veri. of Slicer_CKBUF and Summer

**记得更新一下 eyeX 位置 (从 78.93 ps to 90.0 ps)**

大致仿真：
- interactive.326 (8-point)
- using calibre Slicer_CKBUF
- RC_timeConstant = {1.0, 1.2}
- (CML_IR, volt_scale) = {(200m, 0.42), (250m, 0.45), (300m, 0.49), (300m, 0.52)}
- CALIP = CALIN = 0 (disabled auto-zero)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-22-16-33-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

上图中的结果倒也算还行吧，除了 (CML_IR, volt_scale, RC) = (300m, 0.49, 1.2) 和 (300m, 0.52, 1.2) 这两组，其它六组都能正常工作。


详细仿真：
- interactive.327 (16-point)
- using calibre of Slicer_CKBUF and calibre of Summer
- RC_timeConstant = {0.4, 0.8, 1.0, 1.2}
- (CML_IR, volt_scale) = {(200m, 0.42), (250m, 0.45), (300m, 0.49), (300m, 0.52)}
- CALIP = CALIN = 0 (disabled auto-zero)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-22-16-26-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

和之前的情况仍类似，环路在 CML_IR = 300m 时效果不怎么好。具体而言，可能存在误码情况的参数组合为：
- (CML_IR, volt_scale, RC)
- (250m, 0.45, 1.2): 在 RC 偏大时出现问题，说明 250m 时随着 RC 增大，peak VTH 有所减小，volt_scale 也应当稍小一些，比如缩小到 0.43 (暂未试验过)
- (300m, 0.49, 1.2): 应稍减小 volt_scale
- (300m, 0.52, 0.8): 应稍减小 volt_scale
- (300m, 0.52, 1.2): 应稍减小 volt_scale

**<span style='color:red'> 需要特别注意的是：slicer 加入 CKBUF，功耗从 1.5 mA 上升到 3.0 mA，也就是说 BUF 整整消耗了 1.5 mA，实在是不小。 </span>**


``` bash
  IT("/I114<0>/VDD")
+ IT("/I114<1>/VDD")
+ IT("/I114<2>/VDD")
+ IT("/I114<3>/VDD")
+ IT("/I308/VDD")
```


### 12.6 Slicer_CKBUF_v2

将 CKBUF 移到右侧后的 Slicer 版图如下：
- (1) 输入 CK 留的 M6/M7 进来 (从 M8 打孔)
- (2) 输出 Q/QB 留的 M5/M6 出去

PEX 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-22-17-58-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


和已经验证过没问题的 Slicer_CKBUF_v1 PEX 结果对比下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-22-18-13-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

嗯，几个关键路径的寄生基本上区别不大。可以不必重新验证，直接通过。


### 12.7 layout and post-sim of SSS_v2

顺便把 SSS_v2 (使用 Slicer_CKBUF_v2) 的版图画了一下，DRC/LVS 都是正常通过的，上下拼接也不会有 DRC 报错：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-22-19-04-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



设置好 testbench 对 SSS_v2 进行后仿，结果如下：
- interactive.329
- using calibre of SSS_v2
- CALIP = CALIN = 0 (disabled auto-zero)
- (CML_IR, volt_scale) = (200m, 0.42)
- RC_timeConstant = {1.0, 1.2}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-23-00-24-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

虽然都正常通过了，可 slicer_eyeH_min 有明显下降：RC = 1.0 时从 1.55 降低到 1.38，而 RC = 1.2 时更是从 1.45 降低到 1.13，这是为什么？明明之前用的也是 calibre of SH + Summer + Slicer，难道是 Slicer_CKBUF_v2 的问题？我们回到上一个 testbench 使用 Slicer_CKBUF_v2 来看看是什么情况：
- interactive.330
- using calibre of SH + Summer + Slicer_CKBUF_v2
- CALIP = CALIN = 0 (disabled auto-zero)
- (CML_IR, volt_scale) = (200m, 0.42)
- RC_timeConstant = {1.0, 1.2}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-23-01-25-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

回到上一个 testbench 使用 Slicer_CKBUF_v2 时，眼图高度仍然是正常的 (>1.5 和 >1.45)，那就奇怪了，难道问题出在互连导致的寄生上吗？按理来说不应该呀，SH to Summer 以及 Summer to Slicer 的 I/O 口连接都是非常可靠的，附近也没有明显寄生。


经过考察：
- (1) 回到上一个 testbench 使用 Slicer_CKBUF_v2 时眼高正常，不是这方面的问题
- (2) POS_DTH_dec/NEG_DTH_dec 几乎无区别，不是这方面的问题
- (3) 最差的 slicer 眼图，其上下不怎么对称，估计有 volt_scale 方面的问题，从眼图看是 volt_scale 稍微偏大了 (但真的是主要原因吗？)



没办法，还是做一个全面仿真来看看到底是啥情况吧：
- interactive.337.part1 (8-point)
    - using calibre of SSS_v2
    - VDD = 0.9 @ 56 Gbaud
    - CALIP = CALIN = 0 (disabled auto-zero)
    - RC_timeConstant = 1.0
    - CML_IR = 200m @ volt_scale = 0.38:0.01:0.45
- part2 (8-point): CML_IR = 250m @ volt_scale = 0.40:0.01:0.47
- part3 (9-point): CML_IR = 300m @ volt_scale = 0.44:0.01:0.52
- part4 (9-point): CML_IR = 250m @ volt_scale = 0.45:0.01:0.53
- 仿真共耗时 11h using SpectreFXAX @ 16-thread @ 2-job
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-23-15-02-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-23-15-24-25_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

上图结果虽然是在 RC = 1.0 下仿的，但效果竟然出奇的好？从中还能得出在 RC = 1.0 UI 时，最佳 volt_scale 值为：
- RC = 1.0 UI
- CML_IR --> volt_scale
- 200m --> 0.41
- 250m --> 0.42
- 300m --> 0.46
- 350m --> 0.47
- 并且上述 volt_scale 都不必太精确，附近的几个 volt_scale 值都能正常工作

<!-- 保险起见，我们还是通过观察眼图的 "对称程度" 来确定最佳 volt_scale 值： -->

经过检查，swe_350m_7 这一组参数 (CML_IR = 350m, volt_scale = 0.52) 其实也没有任何问题，只是中途 up/dn counter 不知为何出现 "抽风"，其数字码直接飙升到 255 才导致眼图出了问题，否则也是完全正常的眼图。虽然出现 "异常飙升"，但 up/dn counter 仍不断 down 锁定回来了，说明 pull-in range 确实比较大，不必担心失锁问题。

这结果确实好得让人有点怀疑人生。我们挑出上面的四个最佳点用 SpectreFXAX 和 SpectreXCX 分别重新验证看看：
- interactive.337/338
    - {SpectreFXAX, SpectreXCX}
    - using calibre of SSS_v2
    - VDD = 0.9 @ 56 Gbaud
    - CALIP = CALIN = 0 (disabled auto-zero)
    - RC_timeConstant = 1.0
    - (CML_IR, volt_scale) = {(200m, 0.41), (250m, 0.42), (300m, 0.46), (350m, 0.47)}
    - SpectreXCX 设置的是 24-thread @ 2-job，但是由于电路尺寸不够大，被限制在了 16-thread @ 2-job；这种情况下仿真耗时为 (4/2) x 9.0 = 18h。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-24-16-39-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

上图证明了 RC = 1.0 UI 时四个最佳点都能正常工作。这里特别给出 (200m, 0.41) 和 (250m, 0.42) 在 SpectreXCX 下的 summer/slicer 输出眼图，作为后续参考：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-24-16-44-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-24-01-55-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




与上面类似，现在我们对 RC = 1.2 时的最佳 volt_scale 进行扫描：
- interactive.340.part1 (8-point)
    - using calibre of SSS_v2
    - VDD = 0.9 @ 56 Gbaud
    - CALIP = CALIN = 0 (disabled auto-zero)
    - RC_timeConstant = 1.2
    - CML_IR = 200m @ volt_scale = 0.38:0.01:0.45
- part2 (8-point): CML_IR = 250m @ volt_scale = 0.40:0.01:0.47
- part3 (9-point): CML_IR = 300m @ volt_scale = 0.44:0.01:0.52
- part4 (9-point): CML_IR = 250m @ volt_scale = 0.45:0.01:0.53
- 仿真共耗时 10.5h using SpectreFXAX @ 16-thread @ 2-job
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-24-16-58-08_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


上图可以看出，POS/NEG 端的最佳 volt_scale 分别为：
- **RC = 1.2 UI**
- CML_IR = 200m --> POS_volt_scale = 0.39, NEG_volt_scale = 0.42
- CML_IR = 250m --> POS_volt_scale = 0.41, NEG_volt_scale = 0.44
- CML_IR = 300m 和 CML_IR = 350m 未能找到可正常工作的 volt_scale 值，估计得把 POS/NEG_volt_scale 分开设置才行 (毕竟 250m 时就已经 0.41/0.44 差距较大)


再看看 CML_IR = 300m 时不同 volt_scale 的情况：
- interactive.341
    - using calibre of SSS_v2
    - VDD = 0.9 @ 56 Gbaud
    - CALIP = CALIN = 0 (disabled auto-zero)
    - RC_timeConstant = 1.2
    - CML_IR = 300m
    - volt_scale = {0.40, 0.41, 0.42, 0.43, 0.44, 0.53, 0.54, 0.55, 0.56, 0.57}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-24-22-15-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

上图只能看出 (CML_IR, RC) = (250m, 1.0UI) 时，最佳 POS_volt_scale = 0.425，其它看不出什么。




### 12.8 from (0.9V, 56G) to (1.0V, 64G)

按导师想法，我们看看能不能在 64 Gbaud @ 1.0V 下正常工作：
- interactive.344
- RC = 1.0
- CML_IR = 200m
- volt_scale = 0.415
- (VDD, data_rate) = {(0.9 V, 56 Gbaud), (1.0 V, 60 Gbaud), (1.0 V, 64 Gbaud)}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-24-17-12-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-24-17-13-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

上图可以看出，64 Gbaud @ 1.0 V @ 1.0 UI 还是能正常工作的。**若无特别说明，后续将默认使用 (1.0 V, 64 Gbaud) 做仿真。**




### 12.98 find best volt_scale

在 interactive.340 中我们得到了 (CML_IR, RC) = (200m, 1.2 UI) 和 (250m, 1.2 UI) 时的最佳 POS/NEG_volt_scale 值，这一小节继续考察不同设置下的最佳 volt_scale。

参考着 (250m, 1.2 UI) 的最佳 volt_scale 简单尝试下 (250m, 1.0 UI) 时的最佳值：
- interactive.346
- (VDD, data_rate) = (1.0 V, 64 Gbaud)
- RC = 1.0
- CML_IR = 250m
- (POS, NEG_volt_scale) = 
    - (0.40, 0.44)
    - (0.41, 0.44)
    - (0.42, 0.43)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-24-22-29-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

上图表明最佳 POS/NEG_volt_scale 为：(250m, 1.0 UI) --> (0.42, 0.43)


然后是 (300m, 1.0 UI) 时的最佳值：
- interactive.347
    - (VDD, data_rate) = (1.0 V, 64 Gbaud)
    - (CML_IR, RC) = (300m, 1.0 UI)
    - POS_volt_scale = 0.40
    - NEG_volt_scale = {0.44, 0.45, 0.47, 0.48, 0.49, 0.54} 
    - 结论：
    - 图片：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-24-22-43-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- interactive.348 (12-point)
    - 大范围寻找最佳 volt_scale
    - (VDD, data_rate) = (1.0 V, 64 Gbaud)
    - (CML_IR, RC) = (300m, 1.0 UI)
    - POS_volt_scale = 0.42
    - NEG_volt_scale = 0.40 ~ 0.51
    - 结论：NEG_volt_scale = 0.42/0.47/0.49 四个值下都有较好的正常眼高，详细对比 slicer 眼图认为优秀程度 0.49 > 0.47 > 0.42，但是 0.49/0.47 附近的 0.46/0.48/0.50 效果都不好 (甚至不能正常工作)，所以鲁棒性存疑
    - 图片：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-25-14-15-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - 眼图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-25-14-20-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- interactive.349 (9-point)
    - 在上一次仿真的基础上，进一步确认最佳 volt_scale 的值
    - (VDD, data_rate) = (1.0 V, 64 Gbaud)
    - (CML_IR, RC) = (300m, 1.0 UI)
    - POS_volt_scale = {0.41, 0.42, 0.43}
    - NEG_volt_scale = {0.42, 0.47, 0.49}
    - 结论：以下 volt_scale 组合都能正常工作，其中以 (0.42, 0.49) 效果最好：
        - (POS, NEG_volt_scale)
        - (0.41, 0.47)
        - (0.42, 0.42)
        - (0.42, 0.47)
        - (0.42, 0.49)
        - (0.43, 0.42)
    - 图片：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-25-14-23-07_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - 眼图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-25-14-25-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



然后是 (300m, 1.2 UI) 时的最佳值：
- interactive.340
    - (VDD, data_rate) = (0.9 V, 56 Gbaud)
    - RC = 1.2
    - CML_IR = 300m
    - volt_scale = 0.44 ~ 0.52 (0.10 step)
    - 结论：只能看出 volt_scale = 0.44 ~ 0.48 时勉强能正常工作，其它看不出来
- interactive.341
    - (VDD, data_rate) = (0.9 V, 56 Gbaud)
    - RC = 1.2
    - CML_IR = 300m
    - volt_scale = {0.40, 0.41, 0.42, 0.43, 0.44, 0.53, 0.54, 0.55, 0.56, 0.57}
    - 结论：只能看出 volt_scale <= 0.43 时 SAM_H_min >= 1.15 算是能正常工作，Low 端的找不出能正常工作的。
- interactive.341 (26-point)
    - 大范围寻找最佳 volt_scale
    - (VDD, data_rate) = (1.0 V, 64 Gbaud)
    - RC = 1.2
    - CML_IR = 300m
    - POS_volt_scale = {0.40, 0.41}
    - NEG_volt_scale = 0.38 ~ 0.50
    - 结论：没有完全正常工作的参数组合，眼图 L_max 参差不齐，看不出正常范围在哪里
    - 图片：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-25-14-29-08_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- TB_CDR_Core @ interactive.354 (48-point)
    - 2026.03.26 凌晨
    - (VDD, data_rate) = (1.0 V, 64 Gbaud)
    - RC = 1.2
    - CML_IR = 300m
    - POS_volt_scale = {0.38, 0.39, 0.42}
    - NEG_volt_scale = 0.37 ~ 0.52
- 结论：此次仿真失败，原因是使用的 calibre of dataPath_v1 存在非对称时钟串扰，300m @ 64G 下没有任何一组参数可以正常工作


``` bash
CDR_ulvt_1d0_1000nx2_30n_Slicer_PET_StrongARM_VTH_CALI_CB_v1
Logic_std_2d0_200n_30n_Counter_UPDN_syn_2bitUnit_AbutDN
Logic_std_2d0_200n_30n_Counter_UPDN_syn_EN_2bitUnit_AbutDN
```



### 12.99 summary of best volt_scale

这一小节总结一下仿真过程中尝试过的 volt_scale 及其最佳值：
- (CML_IR, RC)   --> (POS,  NEG_volt_scale)
- (200m, 1.0 UI) --> (0.40, 0.42) @ interactive.344
- (200m, 1.2 UI) --> (0.39, 0.42) @ interactive.340
- (250m, 1.0 UI) --> (0.42, 0.43) @ interactive.346
- (250m, 1.2 UI) --> (0.41, 0.44) @ interactive.340
- (300m, 1.0 UI) --> (0.42, 0.49) @ interactive.347/348/349
- (300m, 1.2 UI) --> (0.41, 0.48) @ 猜测
- (350m, 1.0 UI) --> (0.43, 0.49) @ 猜测
- (350m, 1.2 UI) --> (0.42, 0.48) @ 猜测

或者换个排序：
- 1.0 UI
- (200m, 1.0 UI) --> (0.40, 0.42) @ interactive.344
- (250m, 1.0 UI) --> (0.42, 0.43) @ interactive.346
- (300m, 1.0 UI) --> (0.42, 0.49) @ interactive.347/348/349
- (350m, 1.0 UI) --> (0.43, 0.49) @ 猜测
- 1.2 UI
- (200m, 1.2 UI) --> (0.39, 0.42) @ interactive.340
- (250m, 1.2 UI) --> (0.41, 0.44) @ interactive.340
- (300m, 1.2 UI) --> (0.41, 0.48) @ 猜测
- (350m, 1.2 UI) --> (0.42, 0.48) @ 猜测





## 13. Layout and Post-Sim of CDR Core
### 13.1 SSS_v3

2026.03.24 23:30 与导师讨论之后：
- (1) CK group 走 M8, 宽 0.52 + 间距 0.4, 每一对差分线由两条 VSS 夹住；从 CK group 拉进来 Slicer 时同时走 M6/M7 两层
- (2) VSS/VDD 走 M9, 宽 4.0 + 间距 1.0 交替出现
- (3) Slicer 后面的 following DFF 也归并到 Slicer 里

效果如下，DRC/LVS 均正常通过 (已加了 OD/PO dummy 以满足 density 规则)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-25-01-30-45_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


### 13.2 layout of dataPath_v1 (SSS_4bit)

2026.03.25 22:08 完成初步版图和寄生提取：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-25-22-09-24_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-25-22-11-27_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

从 PEX 结果中关注以下几点：
- (1) MAIN_VB/TAP1_VB 的寄生电容在 100 fF 左右 (由 moscap 贡献)，这与我们的预期相符 (4 x 25 fF)
- (2) CK<:> 每一路的寄生在 55 fF 左右，倒是不算小
- (3) slicer 内部 ck_buffered 寄生在 22 fF 左右 (由被驱动的 mos gate 贡献)，与之前结果相符，
- (4) DFE 关键路径 SAM/SAMB 每一路寄生在 12 fF 左右，还真不小，这里可能对仿真结果有较大影响；这里的寄生应该是把走线和 mos gate of DFE input pair 都算进去了？
- (5) 比较器后续 DFF 的关键路径，比如 DFFQ/DFFQB，每一路寄生分别在 3.5fF/5.3fF 左右，倒是正常，不会有明显影响
- (6) POS/NEG 的 THP/THN 这边，每一路寄生只有约 10 fF，后面最好还是外挂些电容 (moscap + momcap) 来稳定电压 (降低 kickback 影响)

进行 5-point 仿真验证：
- TB_CDR_Core @ interactive.353 (5 known best points)
    - (VDD, data_rate) = (1.0 V, 64 Gbaud)
    - (CML_IR, RC, POS, NEG_volt_scale) = 
        - (200m, 1.0, 0.40, 0.42)
        - (200m, 1.2, 0.39, 0.42)
        - (250m, 1.0, 0.42, 0.43)
        - (250m, 1.2, 0.41, 0.44)
        - (300m, 1.0, 0.42, 0.49)
- 结论：所得结果如下，五组参数中没有任何一组能完全正常工作
- 结果与 summer/slicer 眼图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-26-15-12-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 各数字码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-26-15-41-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


**进行 calibre view 生成后，未打开 calibre 时大小约 75 MB，打开 calibre 后需要加载 > 4h (具体多少不知道，因为睡觉了)，手动保存后大小变为 100 MB，也不清楚保存前后有没有什么区别。**

经过考察，认为原因之一是 SH 输出与时钟发生非对称串扰，下图展示了之前 (时钟串扰对称) 和现在 (时钟串扰不对称) 的 SH0 输出情况 (CK = <2>, CKB = <6>)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-26-14-19-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


从版图上可以解释这一点：SH 在 CK (上升沿) 进行采样之后，遇到 CKB (上升沿) 时，由于 CKB 离 SHP 更近 (离 SHN 更远)，会导致 SHDM = (SHP - SHN) 被向上拉高，这与眼图中 eye_CK2 (CKB) 上升沿处 SH 输出被拉高是相符的。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-26-14-27-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


降低速率重新仿真看看：
- TB_CDR_Core @ interactive.356 (3 point with different data rates)
    - calibre of 202602_CDR__Core_dataPath_v1_20260325 (手动保存过)
    - VDD = 1.0 V
    - data_rate = {48G, 56G, 64G}
    - (CML_IR, RC, POS, NEG_volt_scale) = (250m, 1.0, 0.42, 0.43)
- 结论：
    - (1) 在 48G/56G 下，SAM_L 可以正常工作，但是 SAM_H 不能正常工作，这进一步验证了 SH 的非对称时钟串扰问题
    - (2) 在 64G 下，SAM_L 和 SAM_H 均不能正常工作
    - (3) 64G 时的仿真结果与 point_5 of interactive.353 完全一致，说明 calibre 生成后无需手动保存 (手动保存前后仍完全一致)
- 结果和 SH/Summer/Slicer 眼图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-26-15-33-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




### 13.3 layout of dataPath_v1d1

对 dataPath_v1 中的 CK 走线进行修正，修改后的版图如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-26-16-17-50_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

在不同速率下重新仿真：
- TB_CDR_Core @ interactive.357 (3 point with different data rates)
    - calibre of 202602_CDR__Core_dataPath_v1d1_20260326
    - VDD = 1.0 V
    - data_rate = {48G, 56G, 64G}
    - (CML_IR, RC, POS, NEG_volt_scale) = (250m, 1.0, 0.42, 0.42) (注意这里两个都是 0.42)
- 结论：
    - (1) 在 48G/56G 下，SAM_L 和 SAM_H 都能完全正常工作，且 SH/Summer/slicer 眼图对称性较好，说明非对称时钟串扰问题得到解决
    - (2) 但是在 64G 下，SAM_L 和 SAM_H 均超出极限速率，主要问题在哪？
    - (3) 还有一点比较奇怪的是，明明设置的是 POS/NEG_volt_scale = 0.42/0.43，但是 POS/NEG_actual_volt_scale_ave = 0.43/0.42 是反过来的，这是为何？
    - (4) 虽然 RC = 1.0 UI 恒定不变，但是随着 data rate 增加，SH 的均衡能力有所下降，因此 TAP1_dec 值相应升高，以及 PEAK_dec 略微升高，或许这也是不能工作的原因之一？但是之前用 SSSD<0:3> 作仿真时，64G @ 1.0 UI 也是能正常工作的，也就是说均衡能力确实受了影响，但这并不是导致工作异常的原因，
- 结果和 Slicer 眼图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-26-16-25-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- SH/Summer 眼图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-26-16-29-50_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 数字码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-26-16-30-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




无奈进行大范围扫描，看看什么情况下才能在 64G 正常工作 (以及让 56G 具有更稳定的性能)：
- TB_CDR_Core @ interactive.360
    - 2026.03.26 傍晚
    - calibre of 202602_CDR__Core_dataPath_v1d1_20260326
    - VDD = 1.0 V
    - data_rate = {56G, 64G}
    - CML_IR = 250m
    - RC = {1.0, 0.9, 0.8}
    - Iss (I_bias of summer main tail) = {2.0m, 2.5m, 3.0m, 4.0m}
    - (POS, NEG_volt_scale) = (0.42, 0.43) (又调回了 0.42/0.43)
- 结论：
    - (1) 56Gbaud 下基本都能正常工作，并且随着 Iss 增大，总功耗几乎没有什么变化 (90 mA --> 93 mA)，猜测是因为 summer 中的 tail mos 已进入深线性区，实际支路电流与其几乎无关；
    - (2) 但注意 Iss 增大对眼图确实有优化左右 (尽管功耗没变)，因此若无特别说明，后续将默认使用 Iss = 4 mA 甚至 6 mA
    - (3) 64Gbaud 下，上述参数没有任何一组能完全正常工作；只有 point_20 = (250m, 0.9 UI, 4 mA) 这一组参数勉强算是能正常工作 (eyeH_SAM_L = 1.360/1.298, eyeH_SAM_ave = 1.468/1.547)，这一组参数中最差眼图出现在 eyeH_SAM3_L = 1.298 和 eyeH_SAM3_H = 1.360，这是预料之中的，因为 SAM3 这组 slicer 的输出需要经过更长的 DFE 版图走线才能达到 summer0，长走线意味着高寄生，这拖累了 SAM3 的输出。有没有什么办法能够优化一下？
    - (4) 从 point_4 = (56G, 1.0 UI, 4 mA) 这组参数下的比较器眼图可以看出，POS_volt_scale 有些偏小 (两组路径这里稍差)，而 NEG_volt_scale 也是一样有些偏小 (两组路径这里稍差)
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-27-02-15-55_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- Summer 眼图 at 56 Gbaud @ (250m, 1.0 UI) with different Iss：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-27-02-12-28_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- Slicer 眼图 @ point_4 = (56G, 1.0 UI, 4 mA) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-27-02-27-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



在不同 VDD 和 data rate 下进行全面仿真，看看具体情况怎么样：
- TB_CDR_Core @ interactive.362
    - 2026.03.27 凌晨
    - calibre of 202602_CDR__Core_dataPath_v1d1_20260326
    - VDD = {1.0, 1.2}
    - data_rate = {56G, 60G, 64G}
    - (CML_IR, RC, POS, NEG_volt_scale) = 
        - (200m, 1.0, 0.40, 0.42)
        - (200m, 1.2, 0.39, 0.42)
        - (250m, 1.0, 0.425, 0.435)
        - (250m, 1.2, 0.415, 0.445)
        - (300m, 1.0, 0.42, 0.49)
        - (300m, 1.2, 0.41, 0.48)
        - (350m, 1.0, 0.43, 0.49)
    - Iss (I_bias of summer main tail) = 6m
- 结论：1.0 V 可很好覆盖 60G，1.2 V 可一般覆盖 64G (或较好？需更准确 volt_scale 值)
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-27-18-09-45_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




### 13.4 layout of dataPath_v1d2


2026.03.27 17:30 结合上一小节仿真结果和后级电路所需数据 (offset sampler)，与导师讨论后，下一步：
- (1) 目前是 CK<6> = DATA<3> 这一路通过长走线反馈到 CK<0> = DATA<0> 的同时，还额外反馈给了 adaptation 这一路，也就是 adaptation = copy of DATA<0>；需要将其改为 adaptation = copy of DATA<1> 以避免 CK<6> = DATA<3> 这一路的 DFE 反馈负载过大，也就是由 **CK<0> = DATA<0> 反馈到 CK<2> = DATA<1> 的同时又反馈给 adaptation = copy of DATA<1>**。按仿真结果来看，也是 SAM3_H/L 最容易出问题，所以肯定是得这样做的
- (2) 版图这边，一方面尝试提参只提取 C + CC (不提取 R) 来看看能不能覆盖 64Gbaud；另一方面尝试将 CK<6> = DATA<3> 反馈到 DATA<0> 这两个节点在版图中断开，正常提参后在原理图层面进行理想连接 (这似乎和打两个 same name pin 的效果一致？)
- (3) 版图整体布局是：ADA (adaptation) 这一路放在 data path 上方，由 DATA<0> = CK<0> 向下反馈到 DATA<1> = CK<2> 的同时，再向上反馈给 ADA = copy of DATA<1>；然后 CK<6.5> = OFS (offset sampler) = copy of DATA<3> 这一路放在 data path 下方，由 CK<4> = DATA<2> 反馈到 CK<6> = DATA<3> 的同时，再继续反馈给 CK<6.5> = OFFSET
- (4) 一个关键问题是，CK<6.5> = OFFSET 需要用到额外一对时钟相位 CK<2.5,6.5>，其中 SH 用到两个而 Slicer 只用到 CK<6.5>

两个关键路径：
- ADA --> copy of DATA<1> = CK<2>  , 由 DATA<0> = CK<0> 向上提供 DFE
- OFS --> copy of DATA<3> = CK<6.5>, 由 DATA<2> = CK<4> 向下提供 DFE


将 adaptation 从 ADA = copy of DATA<0> 改为 copy of DATA<1> 之后 (需要更改后续电路对应时钟)，进行仿真验证，看看性能是不是有所提升：
- TB_CDR_Core @ interactive.364
    - 2026.03.27 晚上
    - calibre of 202602_CDR__Core_dataPath_v1d1_20260326
    - VDD = 1.0
    - data_rate = {56G, 60G, 64G}
    - (CML_IR, RC, POS, NEG_volt_scale) = 
        - (200m, 1.0, 0.40, 0.42)
        - (300m, 1.0, 0.42, 0.49)
    - Iss (I_bias of summer main tail) = 4m
- 结论：仿真性能有所恶化，甚至连 60G 都覆盖不了
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-27-21-52-29_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


无奈再改回 ADA = copy of DATA<0> 看看性能有没有变化，以避免是 testbench 出错：
- TB_CDR_Core @ interactive.366
    - 2026.03.27 晚上
    - calibre of 202602_CDR__Core_dataPath_v1d1_20260326
    - VDD = 1.0
    - data_rate = {56G, 60G, 64G}
    - (CML_IR, RC, POS, NEG_volt_scale) = 
        - (200m, 1.0, 0.40, 0.42)
        - (300m, 1.0, 0.42, 0.49)
    - Iss (I_bias of summer main tail) = 4m
- 结论：改回原来的 ADA = copy of DATA<0> 之后，性能竟然没有回到之前那么好？这是为什么？除了时钟顺序从 <2,4,6,0> 变为 <0,2,4,6>，按理来说没有任何区别才是
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-28-01-18-32_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



进行详细仿真以找出原因：
- (0) 原始参考：使用原来的 testbench (2_dataPath_schematic) 进行仿真，提供参考数据
- (1) 修改网络名：将原来的 testbench (2_dataPath_schematic) 复制一份 (4_copyDataPath_schematic)，除了修改 ADA 输出网络名之类的 "等价操作"，不做其它调整
- (2) 更换时钟：时钟顺序从 CK<2,4,6,0> 改为 CK<0,2,4,6>
- (3) 更换 data path 版本 (v1d1 --> v1d2)：将 202602_CDR__Core_dataPath_v1d1_20260326 换为 202602_CDR__Core_dataPath_v1d2_20260327
- (4) 更换 ADA 位置：copy of DATA<0> --> copy of DATA<1>，记得同步修改时钟和 adaptation 数据输入
- 其它默认仿真条件：
    - interactive.372
    - 2026.03.28 凌晨
    - TB_2d1_dataPath @ dataPath_v1d1
    - VDD = 1.0
    - data_rate = {56G, 60G, 64G}
    - (CML_IR, RC, POS, NEG_volt_scale) = 
        - (200m, 1.0, 0.40, 0.42)
        - (300m, 1.0, 0.42, 0.49)
    - Iss (I_bias of summer main tail) = 6m
- 其它默认仿真条件：
    - interactive.372
    - 2026.03.28 凌晨
    - TB_2d1_dataPath @ dataPath_v1d1
    - VDD = 1.0
    - data_rate = {56G, 60G, 64G}
    - (CML_IR, RC, POS, NEG_volt_scale) = 
        - (200m, 1.0, 0.40, 0.42)
        - (300m, 1.0, 0.42, 0.49)
    - Iss (I_bias of summer main tail) = 6m
- 五组仿真，一共 5 x 6 = 30 points
- 结论：
- 数值结果：
    - (0) TB_2d0 原始参考：正常覆盖 60G, 300m @ 1.0 UI 下可勉强覆盖 64G <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-28-21-02-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - (1) TB_2d1 修改网络名：性能有所下降，似乎无法覆盖 64G，这是为什么？按理来说只是修改了网络名，删了一些用不到的东西，不应该有任何变化。<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-28-21-07-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - (2) TB_2d2 更换时钟：性能有一定提升 (意料之中)，如果能解决 SAM3_H/L 的眼高问题，应当可以勉强覆盖 64G <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-28-21-20-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - (3) 更换 data path 版本 (v1d1 --> v1d2)：性能有所提升 (意料之中)，甚至不作任何修改就能勉强覆盖 64G <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-28-21-23-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - (4) 更换 ADA 位置 copy of DATA<0> --> copy of DATA<1>：性能有所提升 (意料之中)，不作任何修改就能勉强覆盖 64G <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-28-21-42-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

``` bash
ADA_SAM_H ADA_SAMB_H
ADA_SAM_L ADA_SAMB_L
ADA_SAMQ_H ADA_SAMQB_H
ADA_SAMQ_L ADA_SAMQB_L
ADA_DFFQ_H ADA_DFFQB_H
ADA_DFFQ_L ADA_DFFQB_L

OFS_SH_INP OFS_SH_INN
OFS_SHP    OFS_SHN
OFS_SUMP   OFS_SUMN
OFS_SAM_H  OFS_SAMB_H
OFS_SAM_L  OFS_SAMB_L
OFS_SAMQ_H OFS_SAMQB_H
OFS_SAMQ_L OFS_SAMQB_L
OFS_DFFQ_H OFS_DFFQB_H
OFS_DFFQ_L OFS_DFFQB_L
```




下图可以看出，SSSD 本身的 DFE 路径寄生电容为 7.8 fF + 1 fF = 8.8 fF，所以 dataPath 中 DFE 反馈路径 (短的那一条) 的 11 fF = 8.8 fF + 2.2 fF，短走线带来的寄生电容仅占 2.2 fF，按理来说不应该显著拉低最高速率。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-28-20-51-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




### 13.5 layout of dataPath_ADA_OFS

将 adaptation/data/offset 三部分合并到一起，原理图和版图效果如下：
（这里放图）
（这里放图）


DRC/LVS 是正常通过的，提参结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-28-11-31-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

从中注意：
- (1) CK 负载平衡稍差，尤其是 CK<2,6> 达到 90 fF 而 CK<0,4> 仅 60 fF
- (2) DFE 反馈路径上的寄生电容在 11 fF ~ 15 fF 不等，倒是和之前 dataPath_v1d1/v1d2 差别不大


对合并后的 dataPath_ADA_OFS 进行 56G ~ 64G 仿真验证：
- 2026.03.28 下午
- interactive.375
- TB_3_dataPath_ADA_OFS @ dataPath_ADA_OFS_v1
- VDD = 1.0
- data_rate = {56G, 60G, 62G, 64G}
- (CML_IR, RC, POS, NEG_volt_scale) = 
    - (200m, 1.0, 0.40, 0.42)
    - (250m, 1.0, 0.42, 0.44)
    - (300m, 1.0, 0.42, 0.49)
- Iss (I_bias of summer main tail) = 6m
- 结论：
    - (1) 从四对 (八个) 比较器的输出眼图来看，如果能进一步调整更合适参数，应当能较好地覆盖 62G，但是 64G 不太行
    - (2) 八个比较器中最容易出问题的是 SAM1_H = DATA_H<1>，使用的是 SAM_CK = <2> 和 SH_CK = <6>；其次是 SAM2_L = DATA_L<2>，使用的是 SAM_CK = <4> 和 SH_CK = <0>，在对这两路的 summer DFE routing 和 slicer output routing 进行仔细优化之前，思考根本原因是什么？
    - (3) 结合 PEX 结果猜测根本原因：可能是 SAM1_H/L 这一对 net 的寄生电容与其它三组反馈路径不匹配 (偏小)，导致 SAM1_H/L 这一对出现问题 (虽然这理由有些站不住脚，但也没办法) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-28-19-25-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div> 这是因为四组 SAM 输出中，有且仅有 SAM1_H/L 这一对的寄生最小，为 11 fF/route，而其它三组走线的寄生均在 13.5 ~ 15.0 fF/route 之间。
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-28-19-05-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>





对 dataPath_ADA_OFS 走线进行优化后重新仿真，看看性能有没有改善：
- 优化后的 PEX 结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-29-02-52-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 2026.03.29 凌晨
- interactive.377
- TB_3_dataPath_ADA_OFS @ dataPath_ADA_OFS_v1
- VDD = 1.0
- data_rate = {56G, 60G, 62G, 64G}
- (CML_IR, RC, POS, NEG_volt_scale) = 
    - (200m, 1.0, 0.40, 0.42)
    - (250m, 1.0, 0.42, 0.44)
    - (300m, 1.0, 0.42, 0.49)
- 结论：性能差别不大，仍然是可以覆盖 62G 但没法达到 64G
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-29-23-56-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>






### 13.6 find best volt_scale


在总结 **12.10 layout of dataPath_v1d2** 一节中 interactive.373 的仿真结果时，突然注意到： **我们在计算 Rp_rela 时，误将 NEG_volt_scale 代入了 POS_Rp_rela (将 POS_volt_scale 代入了 NEG_Rp_rela)，导致 POS/NEG_volt_scale 设置和实际分压比是反过来的。** 这也解释了我们提到过的 "POS/NEG_actual_volt_scale_ave" 实际值与设置值相反。不过这一点并不影响最终仿真结果，因为从一开始迭代 POS/NEG_volt_scale 到现在，我们都没有修改过计算表达式，所以直接反过来就行。


选取 CML_IR = 250m 进行详细扫描，原本弄反时的最佳设置是 (POS, NEG_volt_scale) = (0.42, 0.44)，现在将其改正回 (POS, NEG_volt_scale) = (0.44, 0.42)，然后在此范围附近进行扫描：
- 2026.03.29 凌晨
- interactive.379
- PEX 结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-29-02-52-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- TB_3_dataPath_ADA_OFS @ dataPath_ADA_OFS_v1
- VDD = 1.0
- **data_rate = 62G**
- Iss = 6m
- (CML_IR, RC) = (CML_IR, 1.0)
- POS_volt_scale = 0.41:0.010:0.46
- NEG_volt_scale = 0.41:0.005:0.43
- 结论：在 1.0V 下能够很好地覆盖 62G，下面这些组合都可以作为较优选择
    - (POS, NEG_volt_scale)
    - (0.460, 0.410)
    - (0.430, 0.420)
    - (0.450, 0.410)
    - (0.440, 0.430)
    - (0.440, 0.425)
    - (0.440, 0.415)
    - (0.440, 0.420)
    - (0.460, 0.415)
    - (0.440, 0.410)
    - (0.420, 0.420)
    - (0.450, 0.430)
    - (0.420, 0.415)
    - (0.420, 0.410)
    - (0.420, 0.430)
    - (0.410, 0.415)
    - (0.420, 0.425)
    - (0.410, 0.430)
- 上述结果简单来讲就是：
    - (0.42, 0.410 ~ 0.430)
    - (0.44, 0.410 ~ 0.430)
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-30-00-00-25_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


``` bash
- (POS, NEG_volt_scale)

- (0.410, 0.415)
- (0.410, 0.430)

- (0.420, 0.410)
- (0.420, 0.415)
- (0.420, 0.420)
- (0.420, 0.425)
- (0.420, 0.430)

- (0.430, 0.420)

- (0.440, 0.410)
- (0.440, 0.415)
- (0.440, 0.420)
- (0.440, 0.425)
- (0.440, 0.430)

- (0.450, 0.410)
- (0.450, 0.430)

- (0.460, 0.410)
- (0.460, 0.415)
```




### 13.7 VDD = 1.1V or 1.2V

2026.03.28 与导师讨论后，尝试以下效果：
- (1) 升压到 VDD = 1.1 V 甚至 VDD = 1.2 V
- (2) 提高 Summer 带宽：减小电阻的同时适当增大电流，我们选择将电阻从 250 Ohm 减小到 200 Ohm
    - 要实现上述操作，最方便的是将 202602_CDR__Core_dataPath_ADA_OFS_v1_20260327 通过 copy hierarchical 复制到一个新的 library `MyLib_tsmcN28_test_Summer` 中，然后就可以依次修改其中的 Summer --> SSSD_1bitUnit --> dataPath --> 202602_CDR__Core_dataPath_ADA_OFS_v1_20260327_test_Summer，并得到修改后的 calibre


首先是升压到 VDD = 1.1 V @ (250m, 1.0 UI) 时，对 volt_scale 进行大范围扫描：
- 2026.03.29 凌晨
- interactive.380
    - TB_3_dataPath_ADA_OFS @ dataPath_ADA_OFS_v1
    - **VDD = 1.1**
    - **data_rate = 64G**
    - Iss = 6m
    - (CML_IR, RC) = (250m, 1.0)
    - POS_volt_scale = {0.41, 0.42, 0.44}
    - NEG_volt_scale = {0.410, 0.415, 0.420, 0.425, 0.430}
- 结论：距离覆盖 64G 仍有相当一定距离，也许 300m/350m 输入能勉强正常工作，但也不太可靠
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-30-00-24-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



``` bash
min(eyeH_SAM0_H eyeH_SAM1_H eyeH_SAM2_H eyeH_SAM3_H  eyeHH_SAM0_H eyeHH_SAM1_H eyeHH_SAM2_H eyeHH_SAM3_H)
max(eyeH_SAM0_H eyeH_SAM1_H eyeH_SAM2_H eyeH_SAM3_H  eyeHH_SAM0_H eyeHH_SAM1_H eyeHH_SAM2_H eyeHH_SAM3_H)
0.125*(eyeH_SAM0_H + eyeH_SAM1_H + eyeH_SAM2_H + eyeH_SAM3_H +  eyeHH_SAM0_H + eyeHH_SAM1_H + eyeHH_SAM2_H + eyeHH_SAM3_H)

min(eyeH_SAM0_L eyeH_SAM1_L eyeH_SAM2_L eyeH_SAM3_L  eyeHH_SAM0_L eyeHH_SAM1_L eyeHH_SAM2_L eyeHH_SAM3_L)
max(eyeH_SAM0_L eyeH_SAM1_L eyeH_SAM2_L eyeH_SAM3_L  eyeHH_SAM0_L eyeHH_SAM1_L eyeHH_SAM2_L eyeHH_SAM3_L)
0.125*(eyeH_SAM0_L + eyeH_SAM1_L + eyeH_SAM2_L + eyeH_SAM3_L +  eyeHH_SAM0_L + eyeHH_SAM1_L + eyeHH_SAM2_L + eyeHH_SAM3_L)
```



然后再看看 VDD = 1.2 V @ (250m, 1.0 UI) 时的情况：
- 2026.03.29 凌晨
- interactive.381
    - TB_3_dataPath_ADA_OFS @ dataPath_ADA_OFS_v1
    - **VDD = 1.2**
    - data_rate = {62G, 64G}
    - Iss = 6m
        - (CML_IR, RC, POS, NEG_volt_scale) =
            - (250m, 1.0, 0.44, 0.43)
            - (300m, 1.0, 0.49, 0.42)
            - (300m, 1.0, 0.49, 0.43)
- 结论：**在 (1.2 V, 250m, 1.0 UI, 0.44, 0.43) @ 64G 这一组参数下能够完全正常工作 (已验证过眼图无问题)**，但是其它参数 (包括 62G) 都无法正常工作，根本原因未知，可能和 volt_scale 有些关系吧
- 数值结果：
    - 62G: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-30-16-30-29_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - 64G: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-30-16-32-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>





### 13.8 test of 200-Ohm summer

这一小节在升压的基础上，试试 **Summer 电阻改为 200 Ohm 的情况 (先使用原来的最佳 volt_scale 组合)：**
- 2026.03.30 凌晨
- interactive.385
    - TB_3_dataPath_ADA_OFS @ **dataPath_ADA_OFS_v1_test_Summer**
    - VDD = {1.0, 1.1, 1.2}
    - data_rate = {56G, 60G, 62G, 64G}
    - Iss = 6m
    - (CML_IR, RC, POS, NEG_volt_scale) =
        - (250m, 1.0 UI, 0.42, 0.42)
        - (250m, 1.0 UI, 0.44, 0.42)
        - (300m, 1.0 UI, 0.47, 0.42)
        - (300m, 1.0 UI, 0.49, 0.42)
- 结论：
    - (1) 仅在 VDD = 1.2 V 时才能覆盖 60G (但无法覆盖 62G/64G)，在 1.0V/1.1V 下就连 56G 都无法正常工作
    - (2) 从眼图可以看出原因之一是设置的 volt_scale 过小，但真的是主要原因吗？
- 数值结果：
    - (250m, 1.0 UI, 0.42, 0.42)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-30-18-33-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - (250m, 1.0 UI, 0.44, 0.42)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-30-18-34-07_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - (300m, 1.0 UI, 0.47, 0.42)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-30-18-34-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - (300m, 1.0 UI, 0.49, 0.42)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-30-18-35-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



<!-- - 结论：
    - (250m, 1.0, 0.42, 0.42)：能在 1.2V @ 56G/60G 下正常工作，其它不能完整正常工作，结合 Slicer 眼图猜测是 volt_scale 偏小导致的 (阈值偏小，导致双路那半边较差)，但有望实现 64G @ 1.2V (通过调整 volt_scale) 
    - (250m, 1.0, 0.44, 0.42)：1.1V 性能比上一组要好 (归功于 POS_volt_scale 的增大)，但 1.2V 性能更差 (原因未知)，猜测同步增大 NEG_volt_scale 可获得更佳性能，其它描述同上
    - (300m, 1.0, 0.47, 0.42)：眼图性能与第一组差不多，但不太稳定，其它描述同第一组
    - (300m, 1.0, 0.49, 0.42)：性能比上一组要好 (归功于 POS_volt_scale 的增大)，猜测同步增大 NEG_volt_scale 可获得更佳性能，其它描述同第一组
- 数值结果：
    - (250m, 1.0, 0.42, 0.42)
    - (250m, 1.0, 0.44, 0.42)
    - (300m, 1.0, 0.47, 0.42)
    - (300m, 1.0, 0.49, 0.42) -->




在 250m 下增大 volt_scale 试试情况如何：
- 2026.03.30 傍晚
- interactive.392
    - TB_3_dataPath_ADA_OFS @ **dataPath_ADA_OFS_v1_test_Summer**
    - (VDD, data_rate) = {(1.0V, 62G), (1.1V, 62G), (1.1V, 64G), (1.2V, 64G)}
    - Iss = 6m
    - (CML_IR, RC) = (250m, 1.0)
    - POS_volt_scale = {0.43, 0.44, 0.45, 0.47}
    - NEG_volt_scale = POS_volt_scale
- 结论：所有 16-point 组合中，没有任何一组能够正常工作或勉强正常工作 (即便 1.2V @ 56G 也不行)，背后原因未知，猜测 volt_scale 有一定影响但不是主要因素。
- 数值结果：
    - 62G @ 1.0V/1.1V <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-31-13-46-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - 64G @ 1.1V/1.2V <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-31-13-46-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>





### 13.9 reverify dataPath_ADA_OFS_v1


为什么上一小节的结果会这么差，难不成是哪里设置出了问题？回到原来的 dataPath_ADA_OFS_v1 (using 250-Ohm summer) 重新仿真验证一下：
- 2026.03.31 凌晨
- interactive.397
    - TB_3_dataPath_ADA_OFS
    - **calibre_BK_20260329_v4_optimized_summer_DFEinput** of dataPath_ADA_OFS_v1 in MyLib_tsmcN28
    - VDD = {1.0, 1.1, 1.2}
    - data_rate = {56G, 60G, 62G, 64G}
    - Iss = 6m
    - (CML_IR, RC) = (250m, 1.0)
    - POS_volt_scale = {0.42, 0.44}
    - NEG_volt_scale = POS_volt_scale
- 结论：
    - 在 (0.42, 0.42) 下结果不是很好：只有 60G @ 1.1V 实现了完全正常工作，然后 60G @ 1.0V 实现了勉强正常工作，其它都没能正常工作
    - 在 (0.44, 0.44) 下结果稍好一些，但仍达不到预期：1.0V @ 56G、1.1V @ 56G/62G 和 1.2V @ 60G 实现了完全正常工作，然后 1.0V @ 62G 实现了勉强正常工作，其它都没能正常工作
    - 这里把上述能正常工作的点总结一下：
        - (0.42, 0.42) @ (1.1V, 60G)
        - (0.42, 0.42) @ (1.0V, 60G)
        - (0.44, 0.44) @ (1.0V, 56G)
        - (0.44, 0.44) @ (1.0V, 62G)
        - (0.44, 0.44) @ (1.1V, 62G)
        - (0.44, 0.44) @ (1.2V, 56G)
        - (0.44, 0.44) @ (1.2V, 60G)
    - 也就是：
        - 1.0V
            - (0.44, 0.44) @ 56G
            - (0.42, 0.42) @ 60G
            - (0.44, 0.44) @ 60G
        - 1.1V
            - (0.42, 0.42) @ 60G
            - (0.44, 0.44) @ 62G
        - 1.2V
            - (0.44, 0.44) @ 56G
            - (0.44, 0.44) @ 60G
- 数值结果：
    - (0.42, 0.42) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-31-13-53-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - (0.44, 0.44) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-31-13-54-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- (0.44, 0.44) @ (1.0V, 62G) 比较器眼图：除 SAM0_L 出现了一个 “接近误码” 点，其它都能算是完全正常工作了 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-31-13-59-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



为什么复现不了之前的结果？唯一的不同应该只有 fnoise_max 从 100G 改为了 3*data_rate，我们改回 100G 再看看什么情况：
- 2026.03.31 中午
- interactive.400
    - TB_3_dataPath_ADA_OFS @ dataPath_ADA_OFS_v1
    - VDD = 1.0
    - data_rate = 62G
    - Iss = 6m
    - (CML_IR, RC) = (250m, 1.0)
    - POS_volt_scale = {0.42, 0.44}
    - NEG_volt_scale = {0.41, 0.42, 0.43}
    - fnoise_max = 100G
- 结论：
    - (1) 对比 (0.42, 0.42) @ (1.0V, 62G) 结果可以看出，修改 fnoise_max 后，仿真结果和仿真时间基本一致，说明不是 fnoise_max 导致的问题
    - (2) 又想起来我们优化过 summer DFE input via (增加了过孔个数)，难道是这里导致的吗？一方面直觉上认为不是，另一方面 dataPath_ADA_OFS_v1_test_Summer 的 summer DFE input via 是没有增加过的 (仍是四个)，但前面结果仍然不好，所以认为不是这个过孔导致。
    - 此次验证未能找出原因
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-31-23-00-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



用 calibre_BK_20260329_v3_optimized_via (153.7MB) 这个疑似最接近原版的 calibre 仿真试试：
- 2026.03.31 下午
- interactive.403
    - TB_3_dataPath_ADA_OFS
    - **MyLib_tsmcN28 > dataPath_ADA_OFS_v1 > calibre_BK_20260329_v3_optimized_via**
    - VDD = {1.0, 1.1}
    - data_rate = 62G
    - Iss = 6m
    - (CML_IR, RC) = (250m, 1.0)
    - POS_volt_scale = 0.44
    - NEG_volt_scale = {0.41, 0.42, 0.43}
    - fnoise_max = 100G
- 结论：
    - (1) 1.0V @ 62G 完全正常工作 (已通过眼图验证)，1.1V @ 62G 未能正常工作；这个性能符合原先的仿真情况，算是成功复现。
    - (2) **这个 calibre_BK_20260329_v3_optimized_via 大小是 153.7MB，而我们后面再导出的基本都在 110MB ~ 120MB 之间，也许是这里导致的问题？** 可是我 PEX 这边应该没有动过相关设置，前后为何会有 30MB 的差距，难道是 calibre_BK_20260329_v3_optimized_via 是我们当时手动保存过？不应该啊，我们在 **12.8 layout of dataPath_v1 (SSS_4bit)** 一节就验证过手动保存前后无区别 (但大小会变)，从那之后就再也没有手动保存过。
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-31-20-11-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




我们后面再提取的这个是 calibre_BK_20260329_v4_optimized_summer_DFEinput (没改 summer)，看看它具体是什么情况：
- 2026.03.31 晚上
- interactive.404
    - TB_3_dataPath_ADA_OFS
    - **MyLib_tsmcN28 > dataPath_ADA_OFS_v1 > calibre_BK_20260329_v4_optimized_summer_DFEinput**
    - VDD = 1.1
    - data_rate = 62G
    - Iss = 6m
    - (CML_IR, RC) = (250m, 1.0)
    - POS_volt_scale = {0.43, 0.44, 0.45}
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
- 结论：仿的三个点都没能正常工作，没能复现之前的 1.0V 覆盖 62G
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-01-01-54-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




傍晚突然发现我们之前有过一个备份库名为 `MyLib_tsmcN28_BK_20260329`，将这个库复制一遍称为 `MyLib_tsmcN28_BK_20260329_postSimTest`，然后不动里面的 dataPath_ADA_OFS 版图，直接重新提取 PEX 记作 `calibre_BK_20260331_postSimTest_RCC` (115.9 MB)，用这个来仿真试试：
- 2026.03.31 晚上
- interactive.405
    - TB_3_dataPath_ADA_OFS
    - **MyLib_tsmcN28_BK_20260329_postSimTest > dataPath_ADA_OFS_v1 > calibre_BK_20260331_postSimTest_RCC**
    - VDD = {1.0, 1.1}
    - data_rate = 62G
    - Iss = 6m
    - (CML_IR, RC) = (250m, 1.0)
    - POS_volt_scale = {0.43, 0.44, 0.45}
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
- **结论：成功复现了之前的 1.0V @ 62G 性能！！！虽然从 PEX 结果和 calibre 大小上看基本没啥区别，但总归是复现成功了。**
    - (1) 1.0V @ 62G 下实现了完全正常工作 (已通过眼图验证)，但 1.1V @ 62G 下没能正常工作。
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-01-01-52-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




### 13.10 reduce RC and retry

经过上一小节的 “心态折磨”，以及和导师的讨论，我们认为：
- (1) 原版 (1.0V 能覆盖 62G 这个) 虽然能在 1.0V @ 62G 正常工作，但在 1.0V @ 60G 或者 1.1V @ 62G 却似乎不能，说明这个原版似乎陷入了某种 "敏感区间" 内，需要进一步仿真验证才行。
- (2) 后来不知道哪里改过的这个版本 (summer 仍是 250 Ohm)，虽然在 1.0V @ 62G 下不能工作，但可以在 1.0V @ 60G 或 1.1V @ 62G 下正常工作，似乎是脱离了 "敏感区间"？
- (3) 导师认为输入衰减不必用 1.0 UI 这么大的，只需让眼图接近闭合即可 (0.6 UI ~ 0.8 UI)，毕竟前面还有个 CTLE


综上来讲，为验证我们的核心究竟能在多大速率下工作，我们需要在以下条件考察/验证整体性能：
- (1) VDD = 1.1
- (2) data_rate = {56G, 60G, 62G}
- (3) RC = {0.6, 0.8, 1.0}
- (4) POS_volt_scale = {0.41, 0.42, 0.43, 0.44, 0.45}
- (5) NEG_volt_scale = POS_volt_scale



还是认为后来 “无法复现 1.0V @ 62G” 的这个性能要稳定一些，于是用其做仿真如下：
- 2026.04.01 凌晨
- interactive.407
    - TB_3_dataPath_ADA_OFS
    - **MyLib_tsmcN28 > dataPath_ADA_OFS_v1 > calibre_BK_20260329_v4_optimized_summer_DFEinput**
    - Iss = 6m
    - CML_IR = 250m
    - VDD = 1.1
    - data_rate = {56G, 60G, 62G}
    - RC = {0.6, 0.8, 1.0}
    - POS_volt_scale = {0.41, 0.42, 0.43, 0.44, 0.45}
    - fnoise_max = 100G
    - temperature = 27°C
- 结论和数值结果：
    - 56G 在以下参数组合可以正常或勉强工作： <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-01-23-26-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
        - 0.6 UI @ 0.41 ~ 0.45，推荐 0.42 其次 0.43
        - 0.8 UI @ 0.42 ~ 0.45 (0.44/0.45 疑似存在一处误码)，推荐 0.43 其次 0.42
        - 1.0 UI @ 0.41/0.42/0.44 (0.41/0.42 疑似存在一处误码)，推荐 0.44
    - 60G 在以下参数组合可以正常或勉强工作：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-01-23-30-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
        - 0.6 UI @ 0.41 ~ 0.45 (0.43 疑似存在一处误码)，推荐 0.45 其次 0.44
        - 0.8 UI @ 0.41/0.42/0.44 (完全正常工作)，推荐 0.44 其次 0.42
    - 62G 在以下参数组合可以正常或勉强工作：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-01-23-37-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
        - 0.6 UI @ 0.41/0.43/0.45 (0.41 勉强正常工作，0.43/0.45 疑似存在一处误码)
- 数字码曲线 @ (1.1 V, 56G): <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-04-22-45-08_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - sw_01: (0.6 UI, 0.42, 0.42)
    - sw_06: (0.8 UI, 0.42, 0.42)
    - sw_14: (1.0 UI, 0.45, 0.45)
- 数字码曲线 @ (1.1 V, 60G): <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-04-22-52-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - sw_00: (0.6 UI, 0.42, 0.42)
    - sw_08: (0.8 UI, 0.44, 0.44)
    - sw_11: (1.0 UI, 0.42, 0.42)


升压到 1.2V 看看性能极限如何：
- interactive.408
    - TB_3_dataPath_ADA_OFS
    - **MyLib_tsmcN28 > dataPath_ADA_OFS_v1 > calibre_BK_20260329_v4_optimized_summer_DFEinput**
    - Iss = 6m
    - CML_IR = 250m
    - **VDD = 1.2**
    - data_rate = {62G, 64G}
    - RC = 0.6
    - POS_volt_scale = 0.39 ~ 0.47
    - fnoise_max = 100G
    - **temperature = 65°C**
- 结论和数值结果：
    - 62G 在以下参数组合可以正常或勉强工作：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-05-00-26-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
        - 0.6 UI @ 0.40 ~ 0.43 以及 0.45 ~ 0.46 (0.40 疑似存在误码，0.41 最佳)
    - 64G 在以下参数组合可以正常或勉强工作：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-05-00-24-29_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
        - 0.6 UI @ 0.44/0.47 (0.47 疑似存在误码)



应导师要求，看看小衰减 @ 56G 的情况如何：
- interactive.409
    - TB_3_dataPath_ADA_OFS
    - **MyLib_tsmcN28 > dataPath_ADA_OFS_v1 > calibre_BK_20260329_v4_optimized_summer_DFEinput**
    - Iss = 6m
    - CML_IR = 250m
    - **VDD = 1.1**
    - data_rate = 56G
    - RC = {0.4, 0.5}
    - POS_volt_scale = 0.39 ~ 0.47
    - fnoise_max = 100G
    - **temperature = 65°C**
- 结论：
    - 在 RC = 0.4 UI 时虽然能正常工作，但是 volt_scale 范围较小 (在 0.44 附近，猜测 0.437 最佳)
    - 在 RC = 0.5 UI 时能大范围稳定工作，可行的 volt_scale 范围包括 0.39 ~ 0.43 以及 0.46 ~ 0.47，猜测 0.38 最佳
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-04-19-26-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


``` bash
Logic_std_2d0_200n_30n_MUX2_dummy_x4
```





## 14. Post-Sim of CDR CORE

### 14.1 change of CK_ADA

2026.04.04 01:33 发现之前 dataPath_ADA_OFS_v1 中的 adaptation 时钟直接接到了 CK<2>/CK<6>，但事实上应该接到 CK_ADA/CK_ADAB，只是说 CK_ADA/CK_ADAB 是 copy of CK<2>/CK<6> 而已。修改后得到 `dataPath_ADA_OFS_v2`，PEX 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-04-01-39-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




### 14.2 CDR_CORE_v1 


2026.04.04 凌晨完整拼完了 `CDR_CORE_v1`，版图效果如下，DRC/LVS 是正常通过的 (包括 density)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-04-14-22-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

PEX 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-04-04-25-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



对其进行仿真验证，我们先尝试了设置 VDD 上电时间 t_rise = 10 * CK_period = 625 ps ~ 714 ps，然后 CK/data 额外延迟 1 ns (只需修改 delay_signal 参数)。但是发现这样上电后 verilog 计数器的初始状态不对，遂暂时放弃，等后面直接使用带同步复位的实际计数器。


先验证下 56 Gbaud 是否正常工作：
- interactive.414
    - TB_4_CDR_CORE
    - **MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2**
    - Iss = 6m
    - CML_IR = 250m
    - **VDD = 1.1**
    - data_rate = 56G
    - RC = {0.6, 0.8}
    - POS_volt_scale = {0.42, 0.43}
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - **temperature = 65°C**
- 仿真耗时 @ (24-thread, 2-job)：第一组 4h 47m 34s (为什么这么长？)，第二组 2h 24m 27s
- 结论：虽然性能稍有变化 (似乎是恶化了？)，但 56G 可以正常工作，算是通过了初步验证
    - 这里验证了之前能正常工作的 0.6UI/0.8UI @ 0.42/0.43 共四个点，在 0.6 UI @ 0.42 性能一般般 (但能算正常工作)，然后在 0.8 UI @ 0.42 出现误码，另外两个 (0.6UI/0.8UI @ 0.43) 倒是都能正常工作
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-00-50-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



再验证下 60G 的性能有没有变化 (之前 dataPath_ADA_OFS_v1 是可以覆盖 0.6 UI 和 0.8 UI 的)：
- interactive.417/419/420
    - TB_4_CDR_CORE
    - **MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2**
    - Iss = 6m
    - CML_IR = 250m
    - **VDD = 1.1**
    - **data_rate = 60G**
    - (RC, POS_volt_scale) = 
        - (0.6, 0.41 ~ 0.45)
        - (0.8, 0.42/0.44)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- 仿真耗时 @ interactive.417 (16-thread, 1-job)：第一组 2h 48m 47s，第二组 2h 40m 22s
- 结论：
    - (60G, 0.6, 0.41)：实现了完全正常工作
    - (60G, 0.6, 0.42)：实现了完全正常工作
    - (60G, 0.6, 0.43)：不能正常工作 (离正常工作有一定距离)
    - (60G, 0.6, 0.44)：能正常工作，但是离误码不远 (主要是 eyeHH_SAM4_H = 559.4m，其它倒还好)
    - (60G, 0.6, 0.45)：不能正常工作 (离正常工作有一定距离)
    - (60G, 0.8, 0.42)：这一组完全不能正常工作，离正常工作还有相当远的距离
    - (60G, 0.8, 0.44)：这一组完全不能正常工作，离正常工作还有相当远的距离
- 数值结果： <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-01-18-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div> <!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-00-59-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div> -->


``` bash
min(eyeH_SAM0_H eyeH_SAM2_H eyeH_SAM4_H eyeH_SAM6_H eyeHH_SAM0_H eyeHH_SAM2_H eyeHH_SAM4_H eyeHH_SAM6_H)
max(eyeH_SAM0_H eyeH_SAM2_H eyeH_SAM4_H eyeH_SAM6_H eyeHH_SAM0_H eyeHH_SAM2_H eyeHH_SAM4_H eyeHH_SAM6_H)
0.125*(eyeH_SAM0_H + eyeH_SAM2_H + eyeH_SAM4_H + eyeH_SAM6_H + eyeHH_SAM0_H + eyeHH_SAM2_H + eyeHH_SAM4_H + eyeHH_SAM6_H)

min(eyeH_SAM0_L eyeH_SAM2_L eyeH_SAM4_L eyeH_SAM6_L eyeHH_SAM0_L eyeHH_SAM2_L eyeHH_SAM4_L eyeHH_SAM6_L)
max(eyeH_SAM0_L eyeH_SAM2_L eyeH_SAM4_L eyeH_SAM6_L eyeHH_SAM0_L eyeHH_SAM2_L eyeHH_SAM4_L eyeHH_SAM6_L)
0.125*(eyeH_SAM0_L + eyeH_SAM2_L + eyeH_SAM4_L + eyeH_SAM6_L + eyeHH_SAM0_L + eyeHH_SAM2_L + eyeHH_SAM4_L + eyeHH_SAM6_L)
```



在 60G 下最后做一次全面仿真，以完整评估整个核心的性能：
- interactive.421
    - TB_4_CDR_CORE
    - **MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2**
    - Iss = 6m
    - CML_IR = 250m
    - **VDD = 1.1**
    - **data_rate = 60G**
    - (RC, POS_volt_scale) = 
        - (0.6, 0.38 ~ 0.40)
        - (0.8, 0.39 ~ 0.45)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- 仿真耗时 @ (24-thread, 1-job)：每组 1.5h ~ 2.0h
- 结论：
    - 0.6 UI @ 0.40/0.38 完全正常工作，但是 0.39 不行 (有相当一段距离)
    - 0.8 UI @ 0.39 ~ 0.45 的没有任何一个实现完全正常工作，只有 0.8 UI @ 0.43 最接近正常工作，但仍存在 eyeH_SAM0_H = 375.4m 以及 eyeH_SAM6_L = 56.01m




### 14.3 summary of CDR_CORE_v1

这一小节总结下上面做的一系列仿真：
- 仿真条件：
    - TB_4_CDR_CORE
    - MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2
    - Iss = 6m
    - CML_IR = 250m
    - VDD = 1.1
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- (56G, 0.6 UI) @ 0.42 ~ 0.43：0.43 性能很好但 0.42 性能一般般 (存在 eyeHH_SAM4_H = 599.0m 以及 eyeH_SAM6_L = 604.1m)
- (56G, 0.8 UI) @ 0.42 ~ 0.43：0.43 可正常工作，0.42 不正常但接近
- (60G, 0.6 UI) @ 0.38 ~ 0.45
    - 完全正常工作；0.38, 0.40, 0.41, 0.42
    - 勉强正常工作：0.44
    - 不正常但接近：无
    - 无法正常工作：0.39, 0.43, 0.45
- (60G, 0.8 UI) @ 0.39 ~ 0.45
    - 完全正常工作；无
    - 勉强正常工作：无
    - 不正常但接近：0.43
    - 无法正常工作：0.39, 0.40, 0.41, 0.42, 0.44, 0.45




### 14.4 using CK_DIV4

后级计数器无法在 full-rate 下工作 (相对于时钟)，这边考虑使用 quarter-rate，也即 CK_DIV4 作为其工作时钟，每四个周期对应的四组数据中，取一组而丢弃其它三组。

初步仿真验证结果如下：
- interactive.422
    - TB_CDR_CORE -> TB_4d1_CDR_CORE_CKDIV4
    - **MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2**
    - Iss = 6m
    - CML_IR = 250m
    - **VDD = 1.1**
    - (data_rate, RC, POS_volt_scale) = 
        - (56G, 0.6, 0.43)
        - (56G, 0.8, 0.43)
        - (60G, 0.6, 0.38)
        - (60G, 0.6, 0.40)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- 仿真耗时 @ (24-thread, 2-job) (实际约 16-thread 因为被 qsy 师兄占完了)：平均每组 10h
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-01-32-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 数字码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-03-26-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 各信号时序图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-02-12-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 结论：56G @ 0.6/0.8 UI 实现正常工作，但是 60G @ 0.6UI 的两个点不能正常工作 (后面会解释原因)
- 讨论：
    - (1) 仿真时发现我们的 adaptation 不能正常工作：这是因为用于 DFE adaptation 这边的数据，其中 DH_NM1/DL_NM1 错误地对齐到了 CK<2> (CK<0> 延时一个 bit_period 后是 CK<2>)，这就奇怪了，为什么之前的 adaptation 却可以正常工作呢？
    - (2) 虽然 DFE adaptation 不能正常工作，但是其在 56G 下的两个点均是 "关闭 DFE 状态"，因此对 Summer 的影响要比 60G 时更小，毕竟后者的 adaptation 值乱飘，会导致 VTH adaptation 也不能正常工作。结果也体现了这一点：56G 的两个点可以正常工作，但 60G 却不可以。
    - (3) 令人费解的一点是，为什么 TAP1_dec 会出现突然的上下跳变？我们将在后面的仿真中使用 `VA_Converter_Bin_to_Dec_8bit_precise` 以避免十进制转换问题；但是从右图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-03-44-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div> 又能看出，这里确实发生了数字码的跳变，而不是 1-step UP/DN 这样子，这是为什么？？？我们想不到任何可能的原因，毕竟这里的 verilog 计数器根本没有 RST 等接口，只有 UP/DN/EN 和 CK 输入；稳当起见，我们还是使用 `VA_Converter_Bin_to_Dec_8bit_precise`。


这里给一张时序图以方便后续设计：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-02-12-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>




``` bash
(eyeWidthAtXY(eye_SAMQ0_H eyeX_SAMQ0 eyeY_SAMQ ?output "total") / CK_period)

min(eyeWidthAtXY(eye_SAMQ0_H eyeX_SAMQ0 eyeY_SAMQ ?output "total") eyeWidthAtXY(eye_SAMQ0_H eyeXX_SAMQ0 eyeY_SAMQ ?output "total")) / CK_period
```



更正 DFE adaptation 时序对齐后，重新验证是否正常工作：
- interactive.424
    - TB_CDR_CORE -> TB_4d1_CDR_CORE_CKDIV4
    - **MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2**
    - Iss = 6m
    - CML_IR = 250m
    - **VDD = 1.1**
    - (data_rate, RC, POS_volt_scale) = 
        - (56G, 0.6, 0.43)
        - (56G, 0.8, 0.43)
        - (60G, 0.6, 0.38)
        - (60G, 0.6, 0.40)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- 仿真耗时 @ (24-thread, 2-job)：第一组 5h, 第二组 6h
- 数字码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-18-11-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-18-09-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 结果总结：
    - (1) 仿真的四个点中，有三个点都不能正常工作，天有点小塌 (只有 56G @ 0.8UI 实现完全正常工作)
    - (2) 关键结果总结：
        - (IDD, POS_dec, NEG_dec, TAP1_dec)
        - (56G, 0.6, 0.43) (失败) -> (267.3m, 43.53%, 43.42%, 9.473%)
        - (56G, 0.8, 0.43) (成功) -> (268.1m, 39.91%, 40.17%, 25.63%)
        - (60G, 0.6, 0.38) (失败) -> (272.9m, 46.71%, 48.07%, 10.43%)
        - (60G, 0.6, 0.40) (失败) -> (272.9m, 45.90%, 46.54%, 10.28%)
- 讨论：
    - (1) 右图可以看出 (56G, 0.6, 0.43) 这一组，问题主要出在 eye_SAM0_L，其它 slicer 倒是基本都算正常工作了。<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-14-31-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div> 
    - (2) 总数字码曲线可以看到，adaptation 的数字码输出还算比较稳定，比如 56G @ 0.8UI 正常工作的这一组就正常实现了 DFE adaptation 功能
    - (3) 与前面 56G @ 0.6 UI (14GHz 计数器) 时的数字码对比可以看到，VTH_dec 有所下降而 DFE_dec 有所上升：从 50%/55%/4.5% 变为 43.5%/43.5/9.5% (这个 DFE_dec 值大概对应之前的 0.7 UI 这样)，这是因为将 dataPath/edgePath 等拼到一起后，等效输入电容增大，使得相同的 0.6 UI 对应的实际衰减增大，引起 TAP1 上升同时 PEAK_VTH 下降。如果想沿用之前的最佳分压比结论，我们需要适当减小前置 RC 衰减以抵消这个效应，减小到 0.5 UI 估计差不多。



减小 RC 衰减再次仿真看看效果如何：
- interactive.426
    - 2026.04.10 凌晨 (周五凌晨)
    - TB_CDR_CORE -> TB_4d1_CDR_CORE_CKDIV4
    - **MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2**
    - Iss = 6m
    - CML_IR = 250m
    - **VDD = 1.1**
    - (data_rate, RC, POS_volt_scale) = 
        - (56G, 0.4, 0.44)
        - (56G, 0.5, 0.43)
        - (60G, 0.4, 0.40)
        - (60G, 0.4, 0.42)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- 仿真耗时 @ (24-thread, 2-job)：第一组 6h 9m 8s，第二组 7h 43m 22s
- 数字码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-16-22-44_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-16-23-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 结果总结：
    - (1) 56G @ 0.4/0.5 UI 两个点是能正常工作的 (DFE 基本关闭)，60G 的两个点不太行
    - (2) 关键结果总结：
        - (IDD, POS_dec, NEG_dec, TAP1_dec)
        - (56G, 0.4, 0.44) (成功) -> (266.5m, 51.29%, 51.20%, 0.440%)
        - (56G, 0.5, 0.43) (成功) -> (266.8m, 48.36%, 48.29%, 3.869%)
        - (60G, 0.4, 0.40) (失败) -> (272.0m, 50.69%, 53.87%, 0.903%)
        - (60G, 0.4, 0.42) (失败) -> (272.0m, 50.86%, 53.67%, 0.949%)
- 讨论：

``` bash
POS_DTH_dec_ave (%)		51.29	48.36	50.69	50.86
NEG_DTH_dec_ave (%)		51.2	48.29	53.87	53.67
TAP1_dec_ave (%)		440.8m	3.869	903m	948.6m
IDD_ave		            266.5m	266.8m	272m	272m

```



### 14.5 CORE_v2d1 with actual DAC

给 CDR_CORE 加入 guard ring，优化 dummy 摆放，以及给主输入线加入 VSS 屏蔽后，新的 CORE_calibre_v2d1 PEX 提参结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-04-29-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>

与之前 CORE_calibre_v1 时的 PEX 结果做对比，总结如下：
- (1) 时钟负载情况基本没变
- (2) 主输入电容寄生略微增大 (因为两侧加了 VSS 屏蔽)：
    - SH_INN: 69.9 fF = 31.1 fF + 36.7 fF  ->  73.5 fF = 24.4 fF + 49.1 fF
    - SH_INP: 61.1 fF = 24.7 fF + 36.3 fF  ->  64.7 fF = 14.7 fF + 50.0 fF
    - 讨论：其实之前就觉得有些奇怪了，SH_INP/INN 应该是完全对称的才对，这里 9 fF 之间的电容差距出在哪里？我们将 SH_INP 和 SH_INN 交换后重新提参，发现寄生电容情况确实反过来了，那就破案了：是在左边这一条由过孔给到 SH 时，多层走线更长 (约两倍) 导致寄生更大。
- 其它都基本没什么变化。


2026.04.12 对 AFE (CDR_CORE) 进行了优化，主要是加了 guard ring 以及优化 OD/PO dummy，同时我们完成了 8-bit R-2R DAC 的搭建。提取新 CORE_calibre_v2d1 后，配合实际 DAC (将 verilog_adaptation 中的 DAC 换为实际 DAC) 再次仿真试试效果：
- interactive.429
    - 2026.04.12 凌晨 (周日凌晨)
    - TB_CDR_CORE -> TB_4d1_CDR_CORE_CKDIV4
    - **MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2**
    - Iss = 6m
    - CML_IR = 250m
    - **VDD = 1.1**
    - (data_rate, RC, POS_volt_scale) = 
        - (56G, 0.4, 0.44)
        - (56G, 0.5, 0.43)
        - (60G, 0.4, 0.44) (相比 interactive.426, 适当增大了些)
        - (60G, 0.4, 0.45) (相比 interactive.426, 适当增大了些)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- **注：DAC 的输出挂了 300 fF 电容以避免后级 slicer kickback noise 耦合回 DAC 输出** ，不额外带电容时的 DAC 输出是这样的：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-04-56-05_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>，而加了 300 fF 电容后的效果就比较稳定：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-16-46-16_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 仿真耗时 @ (16-thread, 2-job)：第一组 10h 4m 24s
- 数字码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-16-47-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-16-48-25_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 结果总结：
    - (1) 56G 的两个点都不能正常工作，所以我们仿一半后取消了 60G 的仿真
    - (2) 关键结果总结：
        - (IDD, POS_dec, NEG_dec, TAP1_dec)
        - (56G, 0.4, 0.44) (失败) -> (260.1m, 47.16%, 45.96%, 0.869%)
        - (56G, 0.5, 0.43) (失败) -> (261.0m, 49.96%, 48.88%, 2.316%)
- 讨论：原因是什么？是什么东西设置错了来着我忘了。

``` bash
        - (56G, 0.4, 0.44) (成功) -> (266.5m, 51.29%, 51.20%, 0.440%)
        - (56G, 0.5, 0.43) (成功) -> (266.8m, 48.36%, 48.29%, 3.869%)
```




**14.99 summary of recommended volt_scale** 一节总结了目前为止成功过的参数组合，从中可以看到 volt_scale = 0.43 是一个比较好的值，于是固定分压比为 0.43，看看 56G 不同衰减下的情况如何：
- interactive.432
    - 2026.04.13 凌晨 (周一凌晨)
    - TB_CDR_CORE -> TB_4d1_CDR_CORE_CKDIV4
    - **MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2d1_addedGuardRingAndDummy**
    - Iss = 6m
    - CML_IR = 250m
    - **VDD = 1.1**
    - (data_rate, RC, POS_volt_scale) = 
        - (56G, 0.4, 0.43)
        - (56G, 0.6, 0.43) (0.5 UI @ 0.43 以及仿过了，是成功的)
        - (56G, 0.7, 0.43)
        - (56G, 0.8, 0.43)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- 仿真耗时 @ (16-thread, 2-job)：第一组 10h 50m 53s，第二组 10h 8m 9s
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-14-36-54_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 结果总结：
    - (1) 这里 (56G, 0.43) 的四个点，实现了 0.4UI ~ 0.7UI 的完全正常工作，然后 0.8UI 不能正常工作 (但距离不远，也许适当增加 volt_scale 就能正常工作)
    - (2) 关键结果总结：
        - (IDD, POS_dec, NEG_dec, TAP1_dec)
        - (56G, 0.4, 0.43) (成功) -> (260.4m, 55.55%, 60.02%, 0.462%)
        - (56G, 0.6, 0.43) (成功) -> (260.9m, 44.60%, 46.74%, 10.16%)
        - (56G, 0.7, 0.43) (成功) -> (261.9m, 41.37%, 42.74%, 19.79%)
        - (56G, 0.8, 0.43) (失败) -> (261.8m, 37.54%, 38.86%, 25.53%)
- 其它结果展示 @ (56G, 0.4, 0.43)：
    - 数字码曲线：稳定后 POS_dec ≈ 140 = 55.55%, NEG_dec ≈ 153 = 60.02%, TAP1_dec ≈ 1.1781 = 0.462% <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-14-34-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - SH0/SUM0 眼图：眼高宽分别为 100 mV @ 56.7 ps (+48 mV ~ +145 mV) 和 195 mV @ 45.8 ps (+80 mV ~ +275 mV) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-01-24-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
    - actual_volt_scale_t 曲线：设置值为 0.43, 在 420.0m ~ 440.7m 之间波动 (mean = 429.7m, sigma = 4.09m/3.61m) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-16-20-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>



### 14.99 summary of recommended volt_scale

根据 POS_dec/NEG_dec 的百分比来调整合适 volt_scale 值：
- (POS_dec, NEG_dec, TAP1_dec) --> 推荐值 --> 参考来源
- (51.29%, 51.20%, 0.440%) -> 0.44 --> interactive.426 @ (56G, 0.4, 0.44) (成功)
- (55.55%, 60.02%, 0.462%) -> 0.44 --> interactive.432 @ (56G, 0.4, 0.44) (成功)
- (48.36%, 48.29%, 3.869%) -> 0.43 --> interactive.426 @ (56G, 0.5, 0.43) (成功)
- (44.60%, 46.74%, 10.16%) -> 0.43 --> interactive.432 @ (56G, 0.6, 0.43) (成功)
- (41.37%, 42.74%, 19.79%) -> 0.43 --> interactive.432 @ (56G, 0.7, 0.43) (成功)
- (39.91%, 40.17%, 25.63%) -> 0.43 --> interactive.424 @ (56G, 0.8, 0.43) (成功) (但 interactive.432 这一组是失败的，建议增大 volt_scale 至 0.44 或 0.45)


这里是失败过的参数组合：
- 56G 的：
    - (56G, 0.4, 0.44) (失败) -> (260.1m, 47.16%, 45.96%, 0.869%) @ interactive.429
    - (56G, 0.5, 0.43) (失败) -> (261.0m, 49.96%, 48.88%, 2.316%) @ interactive.429
    - (56G, 0.8, 0.43) (失败) -> (261.8m, 37.54%, 38.86%, 25.53%) @ interactive.432
    - (56G, 0.6, 0.43) (失败) -> (267.3m, 43.53%, 43.42%, 9.473%) @ interactive.424
- 60G 的：
    - (60G, 0.4, 0.40) (失败) -> (272.0m, 50.69%, 53.87%, 0.903%) @ interactive.426
    - (60G, 0.4, 0.42) (失败) -> (272.0m, 50.86%, 53.67%, 0.949%) @ interactive.426
    - (60G, 0.6, 0.38) (失败) -> (272.9m, 46.71%, 48.07%, 10.43%) @ interactive.424
    - (60G, 0.6, 0.40) (失败) -> (272.9m, 45.90%, 46.54%, 10.28%) @ interactive.424

