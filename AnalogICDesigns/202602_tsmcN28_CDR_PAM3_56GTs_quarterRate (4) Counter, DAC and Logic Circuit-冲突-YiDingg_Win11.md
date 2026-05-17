# 202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 22:18 on 2026-04-04 in Beijing.
> dingyi233@mails.ucas.ac.cn


> 注：本文是项目 [A 56 GT/s Quarter-Rate Reference-Less PAM3 CDR (84 Gb/s, 14 GHz) in TSMC 28nm Technology](<Projects/A 56-GTs PAM3 CDR (84 Gbps, 14 GHz) in TSMC 28nm Technology.md>) 的附属文档，用于全面记录 CDR 的设计/迭代/仿真/版图/后仿过程。
> 前置文章是：
> [(1) Preparatory Work](<AnalogICDesigns/202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.md>)
> [(2) Design of Key Modules](<AnalogICDesigns/202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (2) Design of Key Modules.md>)
> [(3) Adaptation and DFE Layout](<AnalogICDesigns/202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.md>)





## 15. Design of LUT_4bit

考虑用 MUX16 (四级 MUX2) 直接构成 LUT_4bit，原理图和版图如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-04-20-49-08_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


上面使用的是 MUX2_x4，由 TG_x4 构成，下面对 TG 进行仿真以推测 LUT 性能上限：
- 等效导通电阻/关断电阻 @ (1.0 V,TT, 27°C)
    - Logic_std_2d0_200n_30n_TG_x2: 1016  Ohm / > 163.7 MOhm
    - Logic_std_2d0_200n_30n_TG_x4: 483.2 Ohm / > 53.51 MOhm
    - Logic_std_2d0_200n_30n_TG_x6: 317.5 Ohm / > 29.90 MOhm
    - Logic_std_2d0_200n_30n_TG_x8: 236.6 Ohm / > 20.19 MOhm
    - 注：(VA, VB) = (VSS, VDD) or (VDD, VSS) 时导通电阻差别不大，可双向工作
- 导通时的仿真截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-04-21-12-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 关断时的仿真截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-04-22-37-29_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>


``` bash
0:(VAR("VDD")/12):(VAR("VDD")/2 - 10m), (VAR("VDD")/2 + 10m):(VAR("VDD")/12):VAR("VDD")
```



采用 TG_x4 四级级联构成 LUT_4bit 时，其任意一路工作时导通电阻 **大于 > 4 x TG_x4 ≈ 2 kOhm** ，这是因为 TG 电阻随两端电压先变大再变小，在中间处导通电阻更大，两边电阻更高。考虑 62.5 ps 的周期，时间常数在 10 ps 左右比较稳当，对应 10 ps = 2 kOhm x 5 fF，也即 LUT 后负载电容建议不超过 5 fF。当然，实际中由于走线电阻和晶体管导通延迟等，性能会比这里预测的更差些？


**考虑用 tri-state INV 替代部分 TG？：EN = 1 时为正常反相器，EN = 0 时输出为高阻**




## 16. Design of UP/DN Counter

先把 adaptation 这边需要的 UP/DN Counter 给设计出来，其 base 1-bit unit 原理图如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-17-47-05_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>

用到了 NAND/XOR/MUX2 以及 TFF_synRst，下面先考虑最关键的 TFF_synRst。


### 16.1 design of TFF_synRst

对这里用到的 TFF_synRst 做仿真，先看看 `Logic_std_2d0_200n_30n_TFF_synRst_ETSPC_TGx4x4` 的后仿结果：
- TB_TFF @ interactive.5
    - fnoise_max = 4*CK_freq
    - VDD = 1.0
    - CK_freq = 14G ~ 28G
    - Corner = (TT, 27°C)
    - Cell view = calibre of Logic_std_2d0_200n_30n_TFF_synRst_ETSPC_TGx4x4 **(std x4x4)**
- 结论：在 TT27 下最高频率仅为 21 GHz (这个频率实在有些低啊，我们真的能做出 16 GHz 的计数器吗？)
- TB 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-17-40-29_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 数值结果图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-18-22-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


进行一个较全面的工艺角仿真看看：
- TB_TFF @ interactive.6
    - fnoise_max = 4*CK_freq
    - VDD = 1.0
    - CK_freq = 14G ~ 28G
    - Corner = (TT/SS/FF, 50°C)
    - Cell view = calibre of Logic_std_2d0_200n_30n_TFF_synRst_ETSPC_TGx4x4 **(std x4x4)**
- 结论：最高速率为 21G (18G ~ 23G)
- 数值结果图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-18-43-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>




先看看提速 DFF 能否有明显效果，我们利用 ulvt_DFF_ETSPC 搭建 ulvt_TFF，其它 XOR/MUX2 暂时不变 (仍用 std)，得到仿真结果如下：
- TB_TFF @ interactive.7
    - VDD = 1.0
    - Corner = (TT/SS/FF, 50°C)
    - Cell view = calibre of Logic_ulvt_2d0_200n_30n_TFF_synRst_ETSPC_TGx4x4_test  **(ulvt x4x4)**
- 结论：最高速率为 21G (20G ~ 21G) 提升不大，但是 FF50 下的输出波形却存在明显失真，因此不考虑用 ulvt_DFF
- 数值结果图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-19-01-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 14 GHz 输出波形：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-19-04-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



又回到 std. Vt 这边来，考虑 XOR/MUX 中的 TG 使用不同尺寸：
- TB_TFF @ interactive.9/10/11
    - VDD = 1.0
    - Corner = (TT/SS/FF, 50°C)
    - Cell view = 
        - calibre of Logic_std_2d0_200n_30n_TFF_synRst_ETSPC_TGx2x4 **(std x2x4)**
        - calibre of Logic_std_2d0_200n_30n_TFF_synRst_ETSPC_TGx4x8 **(std x4x8)**
        - calibre of Logic_std_2d0_200n_30n_TFF_synRst_ETSPC_TGx8x8 **(std x8x8)**
- 结论：
    - x2x4 --> 21G (19G ~ 24G)
    - x4x4 --> 21G (20G ~ 21G)
    - x4x8 --> 18G (16G ~ 20G)
    - x8x8 --> 16G (15G ~ 18G)
    - 竟然是 TG 尺寸越大时速度越低吗？看来限制 TFF 最高速率的主要原因是逻辑门的固有延迟，而不是级间传播时的 RC 延迟。
- 数值结果 @ x2x4: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-20-29-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 数值结果 @ x4x8: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-21-31-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 数值结果 @ x8x8: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-22-02-49_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



于是又试试更小尺寸的 TFF：
- TB_TFF @ interactive.9/10/11
    - VDD = 1.0
    - Corner = (TT/SS/FF, 50°C)
    - Cell view = 
        - calibre of Logic_std_2d0_200n_30n_TFF_synRst_ETSPC_TGx2x2 **(std x4x2)**
        - calibre of Logic_std_2d0_200n_30n_TFF_synRst_ETSPC_TGx2x2 **(std x2x2)**
        - calibre of Logic_std_2d0_200n_30n_TFF_synRst_ETSPC_TGx1x2 **(std x1x2)**
- 结论：
    - x4x2 --> 22G (19G ~ 25G)
    - x2x2 --> 24G (21G ~ 27G)
    - x1x2 --> 20G (18G ~ 22G)
- 数值结果 @ x4x2: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-23-49-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 数值结果 @ x2x2: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-22-35-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 数值结果 @ x1x2: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-06-22-54-09_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



- 把所有结果综合在这里：
    - x1x2 --> 20G (18G ~ 22G)
    - x2x2 --> 24G (21G ~ 27G)
    - x2x4 --> 21G (19G ~ 24G)
    - x4x2 --> 22G (19G ~ 25G)
    - x4x4 --> 21G (20G ~ 21G)
    - x4x8 --> 18G (16G ~ 20G)
    - x8x8 --> 16G (15G ~ 18G)
- 按速率从快到慢排序：
    - x2x2 --> 24G (21G ~ 27G)
    - x4x2 --> 22G (19G ~ 25G)
    - x2x4 --> 21G (19G ~ 24G)
    - x4x4 --> 21G (20G ~ 21G)
    - x1x2 --> 20G (18G ~ 22G)
    - x4x8 --> 18G (16G ~ 20G)
    - x8x8 --> 16G (15G ~ 18G)


我们选用速度最快的 x2x2 作为计数器所使用的 TFF。



再顺便看看 TFF 的最低工作频率：
- TB_TFF @ interactive.16
    - VDD = 1.0
    - Corner = (TT, 27°C)
    - Cell view = calibre of Logic_std_2d0_200n_30n_TFF_synRst_ETSPC_TGx2x2 **(std x2x2)**
- 结论：最低工作频率为 180 MHz = 0.18 GHz @ (TT, 27°C)，也就是 0.18 GHz ~ 24G (21G ~ 27G)
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-02-17-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>





2026.04.07 23:16 这里做一个小插曲：我们的 XOR 是非对称 XOR (A/B 两个输入端非对称)，因此不妨交换 XOR in TFF 中的两个输入端来看看速率变化如何：
- TB_TFF @ interactive.18
    - VDD = 1.0
    - Corner = (TT/SS/FF, 50°C)
    - Cell view = calibre of Logic_std_2d0_200n_30n_TFF_synRst_ETSPC_stc2_TGx2x2 **(std stc2_x2x2)**
- 结论：
    - 最低频率：
        - = 328 MHz @ TT
        - < 100 MHz @ SS
        - = 1.4 GHz @ FF
    - 最高频率：
        - = 28 GHz @ TT
        - = 24 GHz @ SS
        - = 32 GHz @ FF
    - 总范围 0.33 GHz ~ 28 GHz (1.4G ~ 24G)
    - **令人意外的是，修改后的 TFF 速度有了显著提升：T = A of XOR 改为 T = B of XOR，也即 Q = B of XOR 改为 Q = A of XOR，这说明我们的 XOR gate，其输入端 A 的速度比 B 快得多吗？(待定)**
    - 但是我们又得思考，如果上面判断无误，改为 T = B of XOR 之后，相当于把延时更高的路径留在了 TFF 输入端，如果 TFF 输入端再加几个逻辑门，就可能导致整个计算超时，因此这里的高速率并不一定意味着更高的计数器性能，得具体验证了才知道。
- 低频截图 (< 10 GHz)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-23-56-25_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 高频截图 (> 10 GHz)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-23-57-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>







### 16.2 test of 1-bit UPDN counter


搭建 1-bit unit 并提参后，先搭好 2-bit UPDN counter 进行仿真验证 (使用 calibre of Counter_syn_UPDN_EN_synRst_1bitUnit)：

**注意，由于我们将 1bitUnit 输入端的两个 ANDs 换为了 NANDs，因此实际 UP/DN 信号应该反过来：UPDN = 1 时为 DN，而 UPDN = 0 时为 UP。**


2026.04.07 00:46，我们突然注意到一个之前都忽略了的点： **UPDN counter 的速率上限，其实不取决于 TFF 速度，而是取决于整个 AND (or NAND) "传输链" 的传输延迟。** 具体而言，像我们上面那样 "能直接前后拼接" 的 1-bit unit，需要先等前级完成了 NAND 运算，然后后级才能开始 NAND 运算。以 8-bit 为例，会导致 UPDN 信号更新后，要经过八级 NAND 运算延迟才能到达最后一个 bit 的 XOR 输入 (经过这个 XOR 后，再经过一个 XOR 才能到达 DFF)。

我们仿真试了一下，如果不做修改，2-bit 的速率最高只能到 10 GHz (< 12 GHz) @ TT27，而 4-bit 的速率最高只能到 ??? (不能正常工作！！！)。经过检查找到原因：**不能将 XOR 前面的两个 AND 改为 NAND，因为 AND 的输出不仅提供给本级 XOR，还要提供给下一级 AND (AND 可以把乘法拆分成一级一级的，但是 NAND 不可以)。除非使用多输入 AND 将各级之间的运算完全独立开来，才能改为 NAND，否则只能使用 AND。**


无奈又还原回 AND 的版本，暂时名为 `Logic_std_2d0_200n_30n_Counter_UPDN_EN_synRst_AND_1bitUnit` 并由此构成 `Logic_std_2d0_200n_30n_Counter_UPDN_EN_synRst_AND_4bit`，设置 CK_freq = 0.5 GHz ~ 4 GHz 进行仿真，结果为：
- 别提更高频率，就连 0.5 GHz 时输出便已经存在误码，这是为什么？如下图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-01-46-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 又使用 schematic 而不是 calibre 仿了一遍，仍然存在这个问题，难道是电路结构本身出了问题，而不是速率导致？
- 如果暂时忽略此处错误，那么 `Logic_std_2d0_200n_30n_Counter_UPDN_EN_synRst_AND_4bit` 的后仿速率大概在 2G ~ 4G 之间 (< 4G)。

这该如何是好？？



我们又利用 `Logic_std_2d0_200n_30n_Counter_UPDN_EN_synRst_AND_1bitUnit` 搭建了 8-bit UP/DN counter 并进行仿真验证：
- interactive.32 后仿结果显示：不存在上面所看到的 "从 MAX/2 往下跨的这一步出问题"，而是在 4 GHz 下都可以正常工作
- 考虑到八级 AND 延迟约为 100 ps (8 x 12 ps = 96 ps)，4 GHz (period = 250 ps) 下能正常工作是在意料之内的
- 这里给出 interactive.32 的输出码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-03-07-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 注：虽然不知道为什么 4-bit 时出现了莫名误码，但是没关系，8-bit 能用就可以，我们暂时不深究


我们又在 interactive.33 验证了一下 2G 时的 UP/DN 和 EN 控制，都是没有问题的，如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-03-20-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>




设置 flag_UP = 0/1 以及 flag_useEN = 0/1，以及不同的时钟速率，全面验证当前计数器的工作情况以及最高速率：
- TB_TFF @ interactive.34/35
    - VDD = 1.0
    - Corner = (TT, 50°C)
    - Cell view = Logic_std_2d0_200n_30n_Counter_UPDN_EN_synRst_AND_8bit
    - (using calibre of Logic_std_2d0_200n_30n_Counter_UPDN_EN_synRst_AND_1bitUnit)
    - CK_freq = **0.25G ~ 16G (粗扫)** and **1.5G ~ 10G (细扫)**
    - flag_UP = {0, 1}
    - flag_useEN = {0, 1}
- 结论：在 flag_UP/flag_useEN 四种不同情况下，工作频率范围为 0.5 GHz ~ 4.0 GHz @ (TT, 50°C)
- 输出码 @ 4.0 GHz：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-16-22-05_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


再试试 6-bit 能达到多高的速率：
- TB_TFF @ interactive.36
    - VDD = 1.0
    - Corner = (TT, 50°C)
    - Cell view = Logic_std_2d0_200n_30n_Counter_syn_UPDN_EN_synRst_6bit
    - (using calibre of Logic_std_2d0_200n_30n_Counter_syn_UPDN_EN_synRst_1bitUnit, 这里已经改回了 AND gate)
    - CK_freq = 1.5G ~ 8.0G
    - flag_UP = {0, 1}
    - flag_useEN = {0, 1}
- 结论：
    - 不是哥们，没有任何一个速率能实现完全无误码，这又是为什么？
    - **会不会是 verilog 这个 Bin_to_Dec 模块出了问题？** 感觉很有可能，于是做一下优化，然后在 outputs 中也手动设置一下
- 输出码示例 @ 2.0 GHz (Q_dec 存在误码，猜测是 verilog 模块的问题)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-18-32-24_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>




``` bash
Logic_std_2d0_200n_30n_Counter_syn_UPDN_HS_EN_synRst_1bitUnit
Logic_std_2d0_200n_30n_Counter_syn_UPDN_HS_EN_synRst_1bit_8A
Logic_std_2d0_200n_30n_Counter_syn_UPDN_EN_synRst_HS9A_1bit
Logic_std_2d0_200n_30n_Counter_syn_UPDN_EN_synRst_HS8A_1bit_v2
Logic_std_2d0_200n_30n_Counter_UPDN_ENENB_synRst_HS8A_1bit

    @( cross(V(DIN[0]) - vth) 
    or cross(V(DIN[1]) - vth)
    or cross(V(DIN[2]) - vth)
    or cross(V(DIN[3]) - vth)
    or cross(V(DIN[4]) - vth)
    or cross(V(DIN[5]) - vth)
    or cross(V(DIN[6]) - vth)
    or cross(V(DIN[7]) - vth)
    ); // make sure the simulator sees the crossing


  VT("/Q<0>")/VDD * 2**0
+ VT("/Q<1>")/VDD * 2**1
+ VT("/Q<2>")/VDD * 2**2
+ VT("/Q<3>")/VDD * 2**3
+ VT("/Q<4>")/VDD * 2**4
+ VT("/Q<5>")/VDD * 2**5
+ VT("/Q<6>")/VDD * 2**6
+ VT("/Q<7>")/VDD * 2**7


  VT("/Q<0>")/VDD * 2**0
+ VT("/Q<1>")/VDD * 2**1
+ VT("/Q<2>")/VDD * 2**2
+ VT("/Q<3>")/VDD * 2**3
+ VT("/Q<4>")/VDD * 2**4
+ VT("/Q<5>")/VDD * 2**5
+ VT("/Q<6>")/VDD * 2**6
+ VT("/Q<7>")/VDD * 2**7

analog2Digital(VT("/Q<0>")  "hilo" ?vHigh VAR("VDD") ?vLow 0 ?timeX 1f)


analog2Digital(VT("/Q<0>")  "center" ?vCenter VAR("VDD")/2)
analog2Digital(VT("/Q<1>")  "center" ?vCenter VAR("VDD")/2)
analog2Digital(VT("/Q<2>")  "center" ?vCenter VAR("VDD")/2)
analog2Digital(VT("/Q<3>")  "center" ?vCenter VAR("VDD")/2)



  Q0_dig/5 * 2**0
+ Q1_dig/5 * 2**1
+ Q2_dig/5 * 2**2
+ Q3_dig/5 * 2**3
+ Q4_dig/5 * 2**4
+ Q5_dig/5 * 2**5
+ Q6_dig/5 * 2**6
+ Q7_dig/5 * 2**7


  Q0_dig*2/10 * 2**0
+ Q1_dig*2/10 * 2**1
+ Q2_dig*2/10 * 2**2
+ Q3_dig*2/10 * 2**3
+ Q4_dig*2/10 * 2**4
+ Q5_dig*2/10 * 2**5
+ Q6_dig*2/10 * 2**6
+ Q7_dig*2/10 * 2**7
```


把 `VA_Converter_Bin_to_Dec_8bit` 优化后得到 `VA_Converter_Bin_to_Dec_8bit_precise`，再次做 8-bit 仿真，结果如下：
- TB_TFF @ interactive.52
    - VDD = 1.0
    - Corner = (TT, 50°C)
    - Cell view = Counter_UPDN_EN_synRst_8bit
    - (using calibre of Counter_UPDN_EN_synRst_1bit)
    - CK_freq = 1.5G ~ 8.0G
    - flag_UP = {0, 1}
    - flag_useEN = {0, 1}
- 结论：
    - (flag_UP = 0, flag_useEN = 0): 1.5G ~ 4.0G
    - (flag_UP = 1, flag_useEN = 0): 1.5G ~ 4.5G
    - (flag_UP = 0, flag_useEN = 1): 3.0G ~ 8.0G (实际不到 8.0G, 这里是 DN 所以后级 "来不及" 不会引起误码)
    - (flag_UP = 1, flag_useEN = 1): 3.0G ~ 4.5G
    - 总的工作范围：3.0G ~ 4.5G
- 可正常工作的输出码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-23-02-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>





### 16.3 1-bit UP/DN counter with MI-AND

尝试改为 MI-AND gate (multi-input AND gate) 以提高计数器速率：
- (1) 8-bit 需要 8-input AND (最后一级需要对前面七个 Q<6:0> 以及 UP 做 AND 运算)，可以考虑：
    - a. AND8 = AND4/AND4 + AND3：UP 作为 AND3 的其中一个输入，Logic_std_2d0_200n_30n_AND8_7P1
    - b. AND8 = AND4/AND4 + AND2：UP 作为 AND4 的其中一个输入，感觉没有 AND8_7P1 好？不过也可以试试，记作 的其中一个输入，Logic_std_2d0_200n_30n_AND8_8P0
- 诶不对，两级 AND 的话，我们完全可以用 NAND + NOR 来实现：
    - Y = ABCD = ((AB) (CD)) = ( ((AB)  (CD))' )' = ( (AB)' + (CD)' )'
    - a. AND8 = NAND4/NAND4 + NOR3：将 UP/DN 互换后，UP 作为 NOR3 的其中一个输入
    - b. AND8 = NAND4/NAND4 + NOR2：UP 作为 NAND4 的其中一个输入
- (2) 降为 7-bit UPDN counter，此时可以考虑 AND4/AND4 + AND2 (感觉不如就用 8-bit)


<!-- 综合考虑，我们搭建 AND3 和 AND4 门来尝试下带多输入 AND gate 的 8-bit UP/DN counter，初步估计这样做可以将 AND 链传输延迟由原来的约 100 ps 降低到约 35 ps = 20 ps + 15 ps。这样呢即便再算上后续的两个 XOR 延迟，总延迟也应该在 80 ps 以内，预计最高速率能达到 12.5 GHz 左右 (如何突破 16G 大关？)。 -->

注意 < 2 GHz 时 RST 稍微有点问题：从 RST = 1 回到 RST = 0 (正常启动) 后，有几个时钟的延迟，不过这倒是不影响后续的正常工作，只要能实现 RST 功能即可，无伤大雅。


`Logic_std_2d0_200n_30n_Counter_UPDN_EN_synRst_HS8A_1bit` 在 `Logic_std_2d0_200n_30n_Counter_syn_UPDN_EN_synRst_HS8A_1bit` 的基础上，将 MUX2 的驱动信号 ENB 单独拉了出来，变成 EN/ENB 驱动。


先试试 (1.a) AND8 = AND4/AND4 + AND3 的效果：
- TB_TFF @ interactive.44
    - VDD = 1.0
    - Corner = (TT, 50°C)
    - Cell view = Logic_std_2d0_200n_30n_Counter_syn_UPDN_EN_synRst_HS8A_8bit
    - (using calibre of Logic_std_2d0_200n_30n_Counter_syn_UPDN_EN_synRst_HS8A_1bit)
    - CK_freq = 0.25G ~ 17.0G
    - flag_UP = {0, 1}
    - flag_useEN = {0, 1}
- 结论：
    - (flag_UP = 0, flag_useEN = 0): 0.5G ~ 5G
    - (flag_UP = 1, flag_useEN = 0): 0.5G ~ 7G
    - (flag_UP = 0, flag_useEN = 1):   3G ~ 5G
    - (flag_UP = 1, flag_useEN = 1):   3G ~ 7G
    - 总的工作范围：3G ~ 5G
- 可正常工作的输出码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-20-05-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 又在 interactive.49 细扫了一下 2.5G ~ 8.0G，结果为：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-21-26-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - (flag_UP = 0, flag_useEN = 0): 2.5G ~ 6.5G
    - (flag_UP = 1, flag_useEN = 0): 3.0G ~ 7.0G
    - (flag_UP = 0, flag_useEN = 1): 3.0G ~ 6.5G
    - (flag_UP = 1, flag_useEN = 1): 2.5G ~ 7.0G
    - **总的工作范围：3.0G ~ 6.5G**
- quarter rate 的话，这个范围对应时钟速率 12 GHz ~ 26 GHz，最低频率好像有些过高了？



然后试试 (2.a) AND8 = NAND4/NAND4 + NOR3 的效果， **注意 Counter_UPDN_synRst_EN_HS8A_stc2_1bit 在 stc1 的基础上需要交换 UP/DN 信号：**
- TB_TFF @ interactive.52
    - VDD = 1.0
    - Corner = (TT, 50°C)
    - Cell view = Counter_UPDN_synRst_EN_HS8A_stc2_8bit
    - (using calibre of Counter_UPDN_synRst_EN_HS8A_stc2_1bit)
    - CK_freq = 1.5G ~ 8.0G
    - flag_UP = {0, 1}
    - flag_useEN = {0, 1}
- 结论：
    - (flag_UP = 0, flag_useEN = 0): 1.5G ~ 6.0G
    - (flag_UP = 1, flag_useEN = 0): 1.5G ~ 7.5G
    - (flag_UP = 0, flag_useEN = 1): 3.0G ~ 6.5G
    - (flag_UP = 1, flag_useEN = 1): 3.0G ~ 7.5G
    - **总的工作范围：3.0G ~ 6.0G**
- 可正常工作的输出码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-22-56-24_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


``` bash
Logic_std_2d0_200n_30n_Counter_UPDN_stc2_synRst_EN_HS8A_1bit
Logic_std_2d0_200n_30n_Counter_UPDN_synRst_EN_HS8A_stc2_1bit
```



上面这一组仿真，flag_useEN = 1 时，最低频率被限制在了 3.0G 而不是更低，这是为什么？这里 EN 作为 SL of MUX2_x2，明明后面直接就是 TFF，问题出在哪呢？我们尝试将 MUX 的 ENB 信号也拿出来，得到更佳的时序效果来试一试
- TB_TFF @ interactive.55
    - VDD = 1.0
    - Corner = (TT, 50°C)
    - Cell view = Counter_UPDN_synRst_EN_HS8A_stc3_8bit **(stc3_8bit)**
    - (using **schematic** of Counter_UPDN_synRst_EN_HS8A_stc3_1bit)
    - CK_freq = 1.5G ~ 8.0G
    - flag_UP = {0, 1}
    - flag_useEN = {0, 1}
- 结论：**前仿工作范围** 3.0G ~ 8.0G (interactive.53)
- 可正常工作的输出码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-01-08-35_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 注：上图中，flag_useEN = 1 时，7.5G/8.0G 似乎 "看起来波形有差别"，但经过实际波形对比，各项时序都是对齐的，没有问题；只是 RST 信号这边有区别导致的
- 将 EN/ENB 引出后，计数器的最高频率得到明显提升，说明 EN/ENB 这里限制的是最高频率而非最低频率。
- 注意到即便是前仿，"最低工作频率" 也仍是 3.0 GHz，感觉十分奇怪，去检查了一下发现其实是 DFF 分频这边的问题，ETSPC 在低频下无法正常工作导致的。于是后续 (>= interactive.56) 都将低频时的几个 DIV2 换为静态，这样 EN/ENB 波形就不会有问题了。


修正 CK_DIV 之后，提高速率再仿真一次：
- TB_TFF @ interactive.56
    - VDD = 1.0
    - Corner = (TT, 50°C)
    - Cell view = Counter_UPDN_synRst_EN_HS8A_stc3_8bit **(stc3_8bit)**
    - (using calibre of Counter_UPDN_synRst_EN_HS8A_stc3_1bit)
    - CK_freq = 2.0G ~ 10.0G
    - flag_UP = {0, 1}
    - flag_useEN = {0, 1}
- 结论：
    - (flag_UP = 0, flag_useEN = 0): 2G ~ 6.5G
    - (flag_UP = 0, flag_useEN = 1): 2G ~ 6.5G
    - (flag_UP = 1, flag_useEN = 0): 2G ~ 7.5G
    - (flag_UP = 1, flag_useEN = 1): 2G ~ 7.5G
    - 总工作范围：2G ~ 6.5G (实际约 0.5G ~ 6.5G)
- 可正常工作的输出码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-04-22-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>




我们在这途中顺便试了下 TFF_stc2 (将 XOR 输入端交换)，发现对 TFF 来讲工作速率有明显提升，于是基于这里的 Counter_UPDN_synRst_EN_HS8A_stc3，换为 TFF_stc2 来搭建 stc4，仿真结果如下：
- TB_TFF @ interactive.57
    - VDD = 1.0
    - Corner = (TT, 50°C)
    - Cell view = Counter_UPDN_synRst_EN_HS8A_stc4_8bit **(stc4_8bit)**
    - (using calibre of Counter_UPDN_synRst_EN_HS8A_stc4_1bit)
    - CK_freq = 2.0G ~ 10.0G
    - flag_UP = {0, 1}
    - flag_useEN = {0, 1}
- 结论：
    - (flag_UP = 0, flag_useEN = 0): 2.0G ~ 6.5G
    - (flag_UP = 1, flag_useEN = 0): 2.0G ~ 7.0G
    - (flag_UP = 0, flag_useEN = 1): 2.0G ~ 5.0G
    - (flag_UP = 1, flag_useEN = 1): 2.0G ~ 7.0G
    - 总的工作范围：2.0G ~ 5.0G (实际约 0.5G ~ 5.0G)
- 可正常工作的输出码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-14-51-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 讨论：这个结果和我们之前的判断相符，也就是 **“改为 T = B of XOR 之后，相当于把延时更高的路径留在了 TFF_stc2 输入端，如果 TFF_stc2 输入端再加几个逻辑门，就可能导致整个计算超时，因此这里的高速率其实意味着更差的计数器性能”** ，除非我们将计数器的逻辑计算单独拿一个 UI 出来，这时 TFF_stc2 才可能使计数器速率增高。



### 16.4 8-bit UP/DN counter

综上我们知道 `Counter_UPDN_synRst_EN_HS8A_stc3_1bit` 具有最佳性能，于是搭建完整 8-bit `Counter_UPDN_synRst_EN_HS8A_stc3_8bit`，版图布局效果如下：
- 版图布局：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-17-54-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - M8 横向 M9 竖向，这样 VDD/VSS 就不存在连接问题
- PEX 结果 (calibre_v1)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-17-53-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 除了 RST 寄生电容达到 11.6 fF (需要驱动一串 MUX2)，其它的寄生倒还算正常


后仿看看速率如何 (之前用 calibre of stc3_1bit 时速率是 0.5G ~ 6.5G)：
- TB_TFF @ interactive.60
    - VDD = 1.0
    - Corner = (TT, 50°C)
    - Cell view = calibre of Counter_UPDN_synRst_EN_HS8A_stc3_8bit **(stc3_8bit)**
    - CK_freq = 2.0G ~ 10.0G
    - flag_UP = {0, 1}
    - flag_useEN = {0, 1}
- 结论：
    - (flag_UP = 0, flag_useEN = 0): 2.0G ~ 5.5G
    - (flag_UP = 0, flag_useEN = 1): 2.0G ~ 5.5G
    - (flag_UP = 1, flag_useEN = 0): 2.0G ~ 7.0G
    - (flag_UP = 1, flag_useEN = 1): 2.0G ~ 7.0G
    - 总工作范围：2.0G ~ 5.5G (实际约 0.5G ~ 5.5G)
- 可正常工作的输出码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-20-33-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 进一步仿真 (TT/SS/FF, 50°C) @ (flag_UP = 0, flag_useEN = 0) 的情况，结果如下：
    - (TT, 50°C):
    - (SS, 50°C):
    - (FF, 50°C):
    - 总工作范围：





## 17. Design of CKBUF Network

2026.04.07 03:30 与张老师讨论后，确认我们的时钟 BUF 方案：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-23-03-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.jpg"/></div>

从 VCO 出来的八路时钟，每路负载为两组 BUF，以此保证负载平衡。



### 17.1 design of PI (phase interpolator)

经过仿真验证的结论：
- (1) 引入 TG 控制会导致引入额外延时，并且由于这里是高频插值，TG 尺寸增大反而使延时增大 (尽管直流电阻减小)；




### 17.2 PI with trimming

这里尝试一下 trimming control:
- 两个输入时钟分别为 0° 和 90°，预期相位在 67.5°
- 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-18-55-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真设置：
    - TB_PI @ interactive.46
        - VDD = 1.0
        - Corner = (TT/SS/FF, 50°C)
        - CK_freq = **20G**
- 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-19-46-25_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- TT50 波形截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-20-02-25_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- trimming 范围：
    - (TT, 50°C): 69.33° ~ 92.52°
    - (SS, 50°C): 70.36° ~ 94.12°
    - (FF, 50°C): 68.47° ~ 91.36°
    - 总范围：70.36° ~ 91.36° 
- **注意在 CKC = 70° 附近时占空比有严重失真 (≈ 42%)**



将 CKL 这边的 TG 去掉两路 (只留两路)，看看效果如何：
- 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-18-55-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真设置：
    - TB_PI @ interactive.46
        - VDD = 1.0
        - Corner = (TT, 50°C)
        - CK_freq = **{20G, 15G}**
- 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-20-14-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- trimming 和占空比范围：
    - (TT, 50°C) @ 20G: 56.21° -> 74.11°, 40.80% -> 40.02% -> 42.37%
    - (TT, 50°C) @ 15G: 55.77° -> 81.66°, 40.33% -> 37.38% -> 39.02%
- **注意 CKC 占空比有严重失真**
- 经过进一步仿真验证:
    - (1) CKC 的占空比与 TG A/B 方向基本无关 (交换输入后相位和占空比区别都不大)
    - (2) 增大 TG 尺寸能一丢丢改善占空比，但是引入额外延迟过高，所以不能增大


2026.04.08 20:20 与肖师兄讨论了下 VCO 的输入输出接口，肖师兄建议 VCO 输出端接的 BUF 尺寸为 6.4u @ ka = 1.08，也就是差不多 13u 的总宽度。那么我们这边如果 ka = 2.0 的话，第一级 INV 可以考虑用 WN = 4.8u (X24)，对应总宽度 14.4um；然后第二级 INV 用 X48 这样子？

>注：参考 [王小桃带你读文献：CMOS 反相器结构的五十种应用（一） Fifty Applications of the CMOS Inverter Part-1](https://zhuanlan.zhihu.com/p/32613531867) 可以知道，对于一个给定的负载电容 CL，通过设置合理的放大比例，我们可以让驱动CL的延迟降至最低。实际上，如果不考虑 MOS 管的漏电容，那么这个比例应当为自然常数 e = 2.718。**若考虑 MOS 管的漏极电容，那么这个比例需要增大，一般在 3 ~ 4 之间。**


将第一级 INV 设置为 X24，然后第二级设置为 X48，重新仿真得到结果如下：
- 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-20-41-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真设置：
    - TB_PI @ interactive.52
        - VDD = 1.0
        - Corner = (TT, 50°C)
        - CK_freq = {20G, 15G}
- 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-20-42-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- trimming 和占空比范围：
    - (TT, 50°C) @ 20G: 68.94° -> 79.42°, 44.81% -> 45.88%
    - (TT, 50°C) @ 15G: 73.46° -> 81.88°, 41.92% -> 44.60%
- 占空比不知为何有一定改善，但 15G 下仍不够好
- 后续进一步仿真尝试：
    - (1) 将 CKR 这边的第一级 INV 减少 X4 改为 dummy (不含 TG 的 X8 改为 X4)，相位范围有改善但是占空比稍恶化：
        - (TT, 50°C) @ 20G: 62.30° -> 73.60°, 44.17% -> 44.74%
        - (TT, 50°C) @ 15G: 66.34° -> 76.53°, 40.85% -> 42.15%

感觉带了 trimming 的效果不怎么好，还是试试不带 trimming 的。


### 17.3 binary to thermometer decoder

这一小节是给上面 trimming 时用的 thermometer code 做解码：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-04-04-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>

> 下图源自：https://www.researchgate.net/figure/A-2-bit-to-3-bit-binary-to-thermometer-decoder-Binary-inputs-are-on-the-left-and_fig34_354380337
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-04-13-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>

> 下图源自：https://www.researchgate.net/figure/to-7-binary-to-unary-thermometer-decoder_fig10_309031260
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-04-14-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


> 下图源自：https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9214105
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-04-14-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



### 17.4 PI w/o trimming

这里再插入一段没有 trimming control 的 PI 仿真，看看效果如何：
- X24 中，这里指明开启的部分接过去，其它的都是 INV dummy
- 仿真设置：
    - TB_PI
        - VDD = 1.0
        - Corner = (**TT/SS/FF**, 50°C)
        - CK_freq = {20G, 15G}
- (1) 首先是 INV_CKL = X08 的情况：
    - (1.1) (INV_CKL, INV_CKR) = (X08, X08) @ interactive.60： 20G: 78.31° ~ 81.06°, 45.58% ~ 45.78%； 15G: 80.72° ~ 82.81°, 44.26% ~ 44.44%
    - (1.2) (INV_CKL, INV_CKR) = (X08, X12) @ interactive.61： 20G: 78.89° ~ 82.09°, 46.90% ~ 47.36%； 15G: 81.56° ~ 83.96°, 46.31% ~ 46.99%
    - (1.3) (INV_CKL, INV_CKR) = (X08, X16) @ interactive.62： 20G: 78.35° ~ 81.64°, 47.86% ~ 48.40%； 15G: 81.23° ~ 83.66°, 47.52% ~ 48.32%
    - (1.4) (INV_CKL, INV_CKR) = (X08, X20) @ interactive.63： 20G: 77.52° ~ 80.91°, 48.53% ~ 49.05%； 15G: 80.63° ~ 83.12°, 48.30% ~ 49.02%
    - (1.5) (INV_CKL, INV_CKR) = (X08, X24) @ interactive.64： 20G: ； 15G: 
- (2) 感觉这样还是太麻烦了，我们还是直接用 pPar sweep，设置如下：
    - 仿真设置 TB_PI @ interactive.65
        - VDD = 1.0
        - Corner = (TT, 50°C)
        - CK_freq = **16G**
        - fn_CKL = 2 ~ 22, fn_CKR = 2 ~ 22
    - 几个综合来讲最优的是 (虽然仍达不到要求)：
        - (fn_CKL, fn_CKR)
        - (08, 04): 67.66°, 44.19%
        - (12, 08): 68.14°, 42.47%
        - (16, 12): 67.77°, 41.47%
        - (20, 16): 67.32°, 40.78%
        - (22, 22): 69.83°, 42.59% (这一组是延时带来的相位右移)
    - 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-22-40-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- (3) 在上一组的基础上，在进一步调整 fn_CKL/CKR，CKC 第二级 INV 的尺寸，效果如下：
    - TB_PI @ interactive.66
        - VDD = 1.0
        - Corner = (TT, 50°C)
        - CK_freq = **16G**
        - fn_CKL = 2 ~ 12, fn_CKR = {fn_CKL - 2, fn_CKL - 4, fn_CKL - 6}
        - fn_BUF = {46, 40, 32, 24}
    - 几个综合来讲最优的是：
        - (fn_CKL, fn_CKR, fn_BUF)
        - (06, 02, xx): 67.92°, 44.94%
        - (08, 04, xx): 68.81°, 43.68%
    - 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-23-10-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- (4) 验证下上面两组的 Corner 情况 (TT/SS/FF, 0° ~ 80°)：
    - (06, 02, xx): 66.01° ~ 70.47°, 44.58% ~ 45.41%
    - (08, 04, xx): 68.21° ~ 69.07°, 42.57% ~ 44.81%
    - 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-23-19-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- (5) 上面 Corner 基本没有什么问题，再看看不同 VDD 的情况：(0.9V ~ 1.2V, TT/SS/FF, 50°C)
    - (06, 02)：67.89° (62.76° ~ 72.36°), 44.94% (44.57% ~ 45.55%)
    - (07, 03)：68.65° (66.31° ~ 70.02°), 44.29% (43.92% ~ 45.12%)
    - (08, 04)：68.90° (67.84° ~ 69.69°), 43.68% (42.85% ~ 45.19%)
    - 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-23-45-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 讨论：
    - a. 从 Corner 和 VDD 结果可以看出，随着 fn 增大，phase 波动减小但占空比波动变大
    - b. 综合考虑，我们 **选用 (07, 03) 以同时平衡相位精度与占空比**；验证了下 (07, 03) 在 14G ~ 20G，倒是没什么问题


### 17.5 reduce INV size

上面一小节考虑的尺寸是第一级 9.6u/4.8，第二级 19.2u/9.6u。VCO 这边是自带了三级反相器，也就是原始输出 --> self-biased INV --> INV with bias --> INV = 5.4u/4.2u，最后一级 INV 总尺寸为 9.6u，适合带载 28.8u ~ 38.4u，我们的是两组 CKBUF Network，分到每一组就是 14.4u ~ 19.2u，然后每一组里单路时钟又带载两个 INV，因此每个 INV 总尺寸就是 7.2u ~ 9.6u。不妨选择 INV = 6.4u/3.2u 正好对应 9.6u，得到初步方案如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-00-45-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


考虑到插值这边对前后级的影响可能较大，按张老师建议，我们在上图基础上，前后再各加一级 INV 做隔离，也就是一共四级 INV，效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-00-56-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
图中标红/蓝的两个是包含 dummy 后总尺寸为 X24，但红色 = X07_INV + X17_Dummy，然后蓝色 = X03_INV + X21_Dummy。





### 17.6 CKBUF network

我们的时钟 BUF 方案：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-08-23-03-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.jpg"/></div>

结合 AFE (CDR_CORE) 的时钟位置，以及 VCO 的输出位置，考虑这样来做：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-00-56-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-14-57-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.jpg"/></div>



按照此种 CKBUF network 安排再验证下 PI，PI 输入端使用 VCO 最后一级 INV_ulvt @ 5.4u/4.2u 来做：
- 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-15-54-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- TB_PI @ interactive.52
    - VDD = 1.0
    - Corner = (TT, 50°C)
    - CK_freq = {18G, 16G, 14G}
- 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-15-44-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 相位和占空比：
    - (TT, 50°C): 24.8° ~ 28.32°, 58.43% ~ 56.89
- 结果总结：多了一级 INV 所以相位从 67.5° 翻转为 22.5°，这其实也是可以的，但占空比失真实在太大，可能严重影响 Slicer reset 功能。
- 讨论：无奈重新进行参数扫描来试一试。**按张老师的建议，我们直接用 ulvt 的来扫了，不用 std.**


- TB_PI @ interactive.52
    - VDD = 1.0
    - Corner = (TT, 50°C)
    - CK_freq = 16G
    - (fn1, fn2, fn3, fn4) = {16, 24, 24, 48}
    - ka = {1.5, 2.0}
    - fn2_CKL = 2 ~ 22
    - fn2_CKR = 2 ~ 22
- 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-16-23-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 几个比较好的参数组合是：
    - fn2_CKL >= fn2_CKR 时能实现 22.5°：
        - (ka, fn2_CKL, fn2_CKR) -> 相位/占空比
        - (1.5, 06, 02) -> 25.08/52.07
        - (1.5, 10, 06) -> 24.32/55.64
        - (2.0, 06, 02) -> 22.82/54.94
    - fn2_CKL <= fn2_CKR 时能实现 67.5°：
        - (ka, fn2_CKL, fn2_CKR) -> 相位/占空比
        - (1.5, 06, 06) -> 69.00/53.18
        - (1.5, 10, 10) -> 60.12/54.53 --> 猜测 (1.5, 07, 07) 能实现 67.0/53.5
        - (1.5, 18, 22) -> 71.92/51.64
        - (2.0, 10, 14) -> 68.22/53.06
        - (2.0, 14, 22) -> 72.58/51.54 --> 猜测 (2.0, 14, 21) 能实现 68.3/52.0
- 结果总结：
    - 增大 ka (在 fn2_CKL/fn2_CKR 不变的情况下):
        - CKC 占空比增大 (但 CKL/CKR 占空比减小)，CKC 相位左移
    - 增大 fn2_CKR (其它参数不变)：CKC 占空比减小，CKC 相位右移
    - 增大 fn2_CKL (其它参数不变)：CKC 占空比先增大后减小，CKC 左移 (fn2_CKL > fn2_CKR 时相位大幅左移)
- 进一步尝试：(ka, fn2_CKL, fn2_CKR) = (2.0, 8 ~ 16, 14 ~ 22)
    - 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-16-52-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 几个较好的参数组合：
        - 注：22.5° 这边占空比严重失真，因此不考虑
        - (ka, fn2_CKL, fn2_CKR) -> 相位/占空比
        - (2.0, 10, 14) -> 68.22/53.18
        - (2.0, 12, 18) -> 70.90/52.13
        - (2.0, 14, 20) -> 66.83/52.91
        - (2.0, 14, 22) -> 72.58/51.54
- 然后也试试：(ka, fn2_CKL, fn2_CKR) = (1.50, 8 ~ 22, 8 ~ 22)
    - 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-17-49-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 几个较好的参数组合：  
        - 注：22.5° 这边占空比严重失真，因此不考虑
        - (ka, fn2_CKL, fn2_CKR) -> 相位/占空比
        - (1.50, 12, 14) -> 71.24/52.10
        - (1.50, 14, 16) -> 68.66/52.46
        - (1.50, 16, 18) -> 66.94/52.83
        - (1.50, 18, 22) -> 71.92/51.64
- 然后也试试：(ka, fn2_CKL, fn2_CKR) = (1.25, 8 ~ 22, 8 ~ 22)
    - 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-17-54-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 几个较好的参数组合： 
        - (ka, fn2_CKL, fn2_CKR) -> 相位/占空比
        - (1.25, 22, 22) -> 68.35/51.13 
        - (1.25, 20, 20) -> 68.63/51.09 
        - (1.25, 18, 18) -> 69.19/51.06
        - (1.25, 14, 08) -> 21.61/51.07
        - (1.25, 16, 10) -> 22.78/51.31
        - (1.25, 18, 12) -> 23.88/51.59
- 总结一下不同 ka 对应的最佳参数，然后来仿真它们的 PVT 变化情况：
    - (ka, fn2_CKL, fn2_CKR)
        - (2.00, 12, 18) -> 70.90/52.13
        - (2.00, 14, 20) -> 66.83/52.91
        - (1.50, 14, 16) -> 68.66/52.46
        - (1.50, 12, 14) -> 71.24/52.10
        - (1.25, 20, 20) -> 68.63/51.09
        - (1.25, 16, 10) -> 22.78/51.31
    - 仿真设置：
        - CK_freq = {12G, 14G, 16G, 18G}
        - VDD = {0.9, 1.0, 1.1, 1.2}
        - Corner = TT/SS/FF @ 50°C
    - 仿真结果：
        - nominal = (1.1V, 14G, TT, 50°)
        - (2.00, 12, 18) -> 74.02 (67.55 ~ 76.52), 51.95 (51.59 ~ 52.51) (可考虑)
        - (2.00, 14, 20) -> 69.49 (64.46 ~ 72.26), 52.89 (52.10 ~ 53.98) (可考虑)
        - (1.50, 14, 16) -> 71.35 (58.83 ~ 74.06), 52.41 (51.78 ~ 54.94) (淘汰)
        - (1.50, 12, 14) -> 73.98 (68.54 ~ 76.41), 51.99 (51.60 ~ 52.95) (可考虑)
        - (1.25, 20, 20) -> 71.86 (53.47 ~ 75.22), 50.86 (50.17 ~ 55.63) (淘汰)
        - (1.25, 16, 10) -> 18.57 (13.69 ~ 35.22), 50.80 (50.41 ~ 51.90) (淘汰)
    - 讨论：
        - (1) CKC 相位/占空比随 VDD 的变化是多样的，不是普通正负相关
        - (2) 67.5° 这边 CKC 相位/占空比随 CK_freq 增大而稍有减小，整体变化不大
- 进一步尝试 ka = 2.0 时的结果：
    - PVTF = (1.1V, 14G, TT, 50°)
    - ka = 2.0, fn_CKL = 10 ~ 16, fn_CKR = 16 ~ 22 (step = 1)
    - 仿真结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-18-51-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 可以尝试的参数组合：
        - (2.00, 12, 18) -> 74.03/51.95 (已尝试过)
        - (2.00, 14, 20) -> 69.54/52.89 (已尝试过)
        - (2.00, 14, 22) -> 76.02/51.30
- 再进一步尝试，我就不信了：
    - PVTF = (1.1V, 14G, TT, 50°)
    - ka = 2.0, fn_CKL = 10 ~ 16, fn_CKR = 16 ~ 22 (step = 1)
    - 仿真结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-09-18-58-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 可以尝试的参数组合 (已仿过 PVTF 的两个不记在这里)：
        - (2.00, 14, 22) -> 76.02/51.30
        - (2.00, 10, 15) -> 74.87/51.94
        - (2.00, 11, 16) -> 72.39/52.44
        - (2.00, 12, 17) -> 69.73/53.01
        - (2.00, 13, 18) -> 66.52/53.68
        - (2.00, 13, 19) -> 71.97/52.38
        - (2.00, 14, 20) -> 69.54/52.89
        - (2.00, 14, 21) -> 73.48/51.94
        - (2.00, 15, 21) -> 66.80/53.49
        - (2.00, 15, 22) -> 71.52/52.36
    - 按占空比 < 52% 做筛选后：
        - (2.00, 14, 22) -> 76.02/51.30
        - (2.00, 10, 15) -> 74.87/51.94
        - (2.00, 14, 21) -> 73.48/51.94
    - 仿一下 (2.00, 14, 22) -> 76.02/51.30 和 (2.00, 14, 21) -> 73.48/51.94 的 PVTF 看看：
        - nominal = (1.1V, 14G, TT, 50°)
        - (2.00, 12, 18) -> 74.02 (67.55 ~ 76.52), 51.95 (51.59 ~ 52.51)
        - (2.00, 14, 20) -> 69.49 (64.46 ~ 72.26), 52.89 (52.10 ~ 53.98) (淘汰)
        - (2.00, 14, 21) -> 73.48 (66.52 ~ 76.12), 51.94 (51.56 ~ 52.51)
        - (2.00, 14, 22) -> 76.02 (68.19 ~ 78.47), 51.30 (51.01 ~ 51.75)


相位差点可以，但是占空比要保证稳定，否则直接影响到 OFS 这一整路的正常工作。综上，我们最终选择使用 **(2.00, 14, 21)**，如果这个的后仿不太行，就考虑用 **(2.00, 14, 22)**

按上面版图布局 (上下连接 INV)，先搭建 X16/X24/X48 的版图，再搭建 X24 (X14) 和 X24 (X21) 的版图，随后参考下图进行连接：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-02-38-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


先搭建出 `202602_CDR_CKBUF_UD_1bitBUF`，带 `SSSD_1bitUnit` 负载进行后仿验证，看看带载能力是否足够：结果显示，目前的带载能力不够，估计输出级 INV 尺寸要改为 1.5 倍或者 2.0 倍，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-15-25-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



### 17.7 post-sim of PI

搭建完各尺寸的 INV 单元后，提取各尺寸 INV 寄生参数进行仿真，看看结果如何：
- 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-16-24-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- TB_PI @ interactive.104
    - nominal = (TT, 50°C, 1.1V, 14G)
    - PVTF = (TT/SS/FF, 0° ~ 80°, 0.9V ~ 1.2V, 12G ~ 18G)
- 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-18-17-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 相位和占空比：64.18° (58.68° ~ 66.43°), 52.97% (51.27% ~ 53.44%)
- 结果总结：
    - (1) 相比前仿结果，这里相位稍微左移，同时占空比有所增大 (占空比恶化)；
    - (2) nominal 下的相位和占空比更接近全工艺角下的上限值，所以相位这边可以多右移一点
- 讨论：
    - (1) 为了降低占空比失真，我们需按照前仿趋势增大 fn_CKR from 21 to 23，预计这会带来 2 x 3.5° 的相位右移和 2 x 0.7% 的占空比减小 (更接近 50%)，从而达到 51.5% 左右的占空比。如果这样还是不够，那么就改为 fn_CKR = 24，预计会带来 3 x 3.5° 的相位右移和 3 x 0.7% 的占空比减小，从而达到 51% 左右的占空比。
    - (2) 但是在这之前，我们要先增大 CKBUF 的输出级 INV 尺寸来提升带载能力，将输出级 INV 从 X48 改为 (X48 + X48) 之后，看看相位和占空比如何 (先不带完整负载)。
- 先保持 fn_CKR = 21，增大 CKBUF 输出级 INV 尺寸后进行后仿：
    - TB_PI @ interactive.105
    - 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-18-20-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 相位和占空比：62.73°/52.15% @ nominal
    - 结果总结：相位左移的同时占空比得到优化，竟然是个更好的结果
- 增大输出级 INV 尺寸后，中间 PI 这里改为 fn_CKR = 23 后进行后仿：
    - TB_PI @ interactive.109
    - 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-18-44-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 相位和占空比：66.75°/51.32% @ nominal
    - 结果总结：相比 x21, 这里的相位右移了 4.02°，占空比减小了 0.83%，变化比例差不多符合预期
- 不妨再试试直接用 X24 的情况：
    - TB_PI @ interactive.107
    - 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-18-37-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 相位和占空比：68.37°/50.88% @ nominal
    - 结果总结：相比 x23, 这里的相位进一步右移了 1.62°，占空比进一步减小了 0.44%，结果更佳一些
- 在 fn_CKR = X24 的基础上，将 fn_CKL = 14 改为 13，看看结果如何：
    - TB_PI @ interactive.110
    - 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-18-51-09_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 相位和占空比：71.03°/50.37% @ nominal
    - 结果总结：相比 x14, 这里的相位进一步右移了 2.66°，占空比减小了 0.51%, **但是注意 CKL/CKR 的占空比从 49.0% 恶化到 48.0%**
- 试试 (X13, X24) 对应的全工艺角的性能如何：
    - TB_PI @ interactive.111
    - 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-19-15-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 相位和占空比：71.03° (65.31° ~ 73.37°), 50.37% (48.83% ~ 50.77%)  (这里只仿了全部 48 points 的一半)
    - 讨论：注意 CKL/CLR 的占空比恶化到了 47.99% (46.42% ~ 48.51%)，这是前面 "将 INV_x48 增大至 INV_x96" 导致的；这个范围，尤其是最小约 46.5% 这边实在是不够好。


这里把上面的全工艺角结果汇总一下：
- (X14, X21):
    - CKC_phase = 62.73°
    - CKC_duty  = 52.15%
    - CKL/CKR_duty = 48.01%
- (X14, X23)
    - CKC_phase = 66.75°
    - CKC_duty  = 51.32%
    - CKL/CKR_duty = 48.03%
- (X14, X24)
    - CKC_phase = 68.37°
    - CKC_duty  = 50.88%
    - CKL/CKR_duty = 48.01%
- (X13, X24)
    - CKC_phase = 71.03°
    - CKC_duty  = 50.37%
    - CKL/CKR_duty = 47.99%




综合来看，我们选择 (X13, X24) 这个参数组合，其全工艺角性能已经仿过，为：
- CKC_phase = 71.03° (65.31° ~ 73.37°)
- CKC_duty  = 50.37% (48.83% ~ 50.77%)
- CKL/CKR_duty = 47.99% (46.42% ~ 48.51%)

构成 PI 单元后提参，PEX 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-20-38-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


利用 calibre 进行全工艺角后仿，结果如下：
- 注：
    - (1) 这里注意到前面用的外部 1bitBUF 都是 v1，这改成 v2
    - (2) 然后 CKL/CKC/CKR 以及 test_CK/CKB 都带完整负载
- Testbench 原理图：
- TB_PI @ interactive.114
    - nominal = (TT, 50°C, 1.1V, 14G)
    - PVTF = (TT/SS/FF, 0° ~ 80°, 0.9V ~ 1.2V, 12G ~ 18G)
- 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-22-32-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 相位和占空比：
    - CKC_phase = 68.88° (59.51° ~ 71.41°)
    - CKC_duty  = 50.95% (48.94% ~ 51.45%)
    - CKL/CKR_duty     = 48.45% (46.32% ~ 49.05%)
    - test_CK/CKB_duty = 48.22% (45.72% ~ 48.90%)
- 典型条件下的相位和占空比 (1.1V ~ 1.2V, 14G ~ 16G, TT/FF/SS)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-23-02-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - CKC_phase = 68.88° (65.75° ~ 69.61°)
    - CKC_duty  = 50.95% (50.39% ~ 51.34%)
    - CKL/CKR_duty     = 48.45% (47.93% ~ 47.94%)
    - test_CK/CKB_duty = 48.22% (47.56% ~ 48.73%)




### 17.8 post-sim of BUF network

先不弄输入输出金属网络，提取寄参进行初步仿真验证，PEX 提参结果如下 (大小 120.8 MB)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-10-22-47-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


然后进行仿真验证，看看 CKBUF network 在带实际负载的情况下性能如何：
- TB_CKBUF_network @ interactive.116
    - Spectre X + CX
    - PVTF = (TT, 50°C, 1.1 V, 14 GHz)
    - calibre_v1 of `202602_CDR__CKBUF_UD`
- 时钟波形截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-11-21-19-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 数值结果截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-11-21-12-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 相位和占空比总结：
    - CK<7:0> = 0/1.965/2.965/3.997/4.969/5.968/6.978 @ 48.7%
    - CK_ADA/ADAB = 1.924/5.855 (delta = 3.931) @ 48.15%
    - CK_OFS/OFSB = 6.439/2.375 (delta = 4.064) @ 50.95%
- 结果讨论：
    - (1) 以 CK<0>/CK<4> 两条为相位基准时，其它六个相位比预期值左移了 2.5° 左右，猜测是 CK<0>/CK<4> 这边输出 CK_PAD/PADB 没接负载导致的 (但是后续挂 70fF 电容作为负载，仿真结果并没有变化，所以估计不是这个原因)


``` bash
clip(cross(clip(CK<0> time_start time_end) (VAR("VDD") / 2) 1 "rising" t "cycle" nil) cycle_start cycle_end)
```



### 17.9 post-sim with IO M8

向上拼接 AFE 的间隔安排：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-11-16-09-44_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


版图加上输入输出的 M8 网络，效果和 PEX 提参结果如下 (大小 131.7 MB)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-11-17-10-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>

和之前不带网络的提参结果进行对比，可以发现：
- (1) input 的寄生电容，从 CC < 18 fF 增长到 CC = 36 fF，这主要是 M8 网络相互寄生导致的。
- (2) output 的寄生电容，从 (C = 0.8 fF, CC = 20 fF) 增长到 (C = 5.5 fF, CC = 50 fF)，增长的寄生也是 M8 导致。



- TB_CKBUF_network @ interactive.119
    - Spectre X + CX
    - PVTF = (TT/SS/FF, 0°C ~ 50°C, 0.9V ~ 1.1V, 12G ~ 18G)
    - **calibre_v2 (带 IO M8 网络)** of `202602_CDR__CKBUF_UD`
- 时钟波形截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-20-21-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 数值结果截图：
    - TT 结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-11-21-16-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 完整结果 (仿真共耗时 11h，之所以这么长主要是本来 24-thread @ 2-job 后面卡住了一个，实际变成了 1-job)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-23-48-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 相位和占空比总结：
    - nominal:
        - CK<7:0> = 0/1.006/1.994/3.007/4.013/4.998/5.997/7.020 @ 49.53%
        - CK_ADA/ADAB = 1.955/5.875 (delta = 3.920) @ 49.30%
        - CK_OFS/OFSB = 6.433/2.362 (delta = 4.071) @ 52.13%
        - IDD_AFE = 298.4m
        - IDD_CKBUF = 97.42m
    - all PVTF
        - CK<7:0>_duty = 48.94% ~ 50.01%
        - IDD_AFE = 169.7m ~ 450.7m
        - IDD_CKBUF = 61.48m ~ 160.5m
- 结果讨论：在左右 PVTF 下均实现了正常工作；而且加了 M8 网络之后，各时钟的相位和占空比结果反而更好了？






## 18. Design of 8-bit R-2R DAC

### 18.1 design of 8-bit R-2R DAC

构建 8-bit R-2R DAC 如下，先进行前仿确认下电路功能没问题：
- DAC 原理图以及 testbench 设置 (调用 schematic of DAC)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-02-50-45_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- Spectre FX + AX 验证结果曲线：嗯，没有什么问题，前仿可以在 4 GHz 下很好地工作 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-02-52-54_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- Spectre X + CX 验证结果曲线：嗯，确实没有什么问题，前仿可以在 4 GHz 下很好地工作 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-03-57-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



确认没有问题后拼出 8-bit 版图，版图效果和 PEX 提取结果如下：
- 版图效果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-04-10-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- PEX 提取结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-03-51-16_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


然后在计数器这里后仿验证一下，也是没有什么问题的：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-19-06-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



### 18.2 DAC with manual control

**注意一般情况下是 Counter -> BUF -> DAC 这样，但是我们需要在 BUF 这一级前面加一个 MUX 手控路径。** 于是构建带有 MN (manual) 控制和输入的 DAC，后仿验证效果如下，也是没有什么问题的：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-12-23-56-09_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>






## 19. Adaptation_VTH

### 19.1 bounded counter
当时 verilog 模型用的方法是：
- DN_actual:
    - X = Q0 + Q1 + ... + Q7
    - Y = X * DN = [(Q0+Q1+...+Q7)' + DN']' = [(Q0+Q1+...+Q7)' + UP]', 使用 NOR8 和 NOR2 即可
- UP_actual: Y = [(Q0\*Q1\*...\*Q7)' \* UP], 使用 NAND8 + AND2 即可


但是我们细想下来，这个有点问题啊，会出现 (UP, DN, EN) = (0, 0, 1) 的情况，而此时计数器值似乎不会变？这似乎是钻了 verilog 模型中所用结构的空子？而我们实际用的 counter 结构是经过修改的，因此不能用这里的 bound 机制。改为下图这样：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-13-00-53-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.jpg"/></div>

注：
- (1) 其实如果 flag_bound_DN 用 QB<7:0> 作输入的话，这里也可以用 AND9，不过为了减少走线难度，我们还是统一用 Q<7:0> 作为输入。
- (2) 考虑到 EN 的计算耗时应该不超过 150 ps，这里 actual_EN 的计算就不额外用一个周期了 (如果额外用的话记得需要在 1/254 便启动 bound 而不是在 0/255，也就是用 Q<7:1> 作为输入)


仿真看一下 bounded counter 的最高工作速率，确保 bound_EN 机制不会影响电路速率：
- xx




### 19.2 VTH adaptation

搭建 Adaptation_VTH 模块进行一下后仿验证，设置 CK_SYS = 16 GHz (CK_DIV4 = 4 GHz)，结果如下：
- 原理图及 testbench 搭建：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-13-03-52-45_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 关键信号波形：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-13-15-46-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>





## 20. Design of RDAC

### 20.1 matlab calculation

电阻分压这边考虑用 R_L + R_C + R_R 的方式来做，其中 R_L = R_R = 1 unit，而 R_C 为可调电阻阵列。结合 MATLAB 计算结果，我们最终选择：
- 整体布局 (已验证过 DRC 无问题)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-13-20-22-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- R_L = R_R = 10.0 kOhm，具体参数如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-13-20-23-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- R_C = R_fixed + R_C1 (3-bit) + R_C2 (5-bit)，unit 具体参数如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-13-20-23-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 也就是说，对 R_C1 和 R_C2：unit_RC = unit_x1 = 2.80 kOhm，然后 unit_x2 = 5.60 kOhm 用两个 unit_x1 串联得到，类似地 unit_x4 由四个 unit_x1 串联得到。随后用数字码控制 unit_x1/~x2/x4/x8 之间的并联关系，即可得到不同电阻大小。以 5-bit 为例，可调电阻范围是 (0.516 ~ 16.0) x unit_RC 等价于 (0.145 ~ 4.49) x unit_RL 等价于 (1.45 kOhm ~ 44.93 kOhm)


### 20.2 pre-sim verification

前仿 DC 看一下引入 TG 后实际电阻值与理想值的偏差，以及不同工艺角下的情况，结果如下：
- RDAC 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-13-23-51-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-13-23-34-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 讨论：
    - (1) 这里用的 TG_x16，所以实际 Req 与理想值 Req_ideal 基本没有差别
    - (2) TT/SS/FF 下，电阻值的整体波动范围在 ±25% 左右，由于这个波动是 global variation 而不是 local variation (e.g., mismatch)，因此对整个分压电路影响不大；
    - (3) 为了方便版图操作，我们还是把 TG_x16 换成 TG_x8，反正这个导通电阻只有 125 Ohm 影响不大。


``` bash
Logic_std_2d0_200n_30n_RDAC_ParaSeries_2d8k_3bit
```



``` bash
(1 / ((((2**0) * DB0) / Runit) + (((2**1) * DB1) / Runit) + (((2**2) * DB2) / Runit)))
(1 / ((((2**0) * DB0) / Runit) + (((2**1) * DB1) / Runit) + (((2**2) * DB2) / Runit)))

1 / (  DB0/(2**0*Runit) + DB1/(2**1*Runit) + DB2/(2**2*Runit) )
1 / (  D0/(2**2*Runit) + D1/(2**1*Runit) + D2/(2**0*Runit) )


1 / (  DB0/(2**4*Runit) + DB1/(2**3*Runit) + DB2/(2**2*Runit) + DB3/(2**1*Runit) + DB4/(2**0*Runit) )


((1 - ((VS("/D<0>") - (VAR("VDD") / 2)) / abs((VS("/D<0>") - (VAR("VDD") / 2))))) / 2)
```



### 20.3 post-sim results

3-bit RDAC 版图和后仿结果如下：
- 版图效果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-00-16-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 后仿结果曲线：（这里放图）

5-bit RDAC 后仿结果如下：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-14-57-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


``` bash
(1 / ((DB0 / ((2**2) * Runit)) + (DB1 / ((2**1) * Runit)) + (DB2 / ((2**0) * Runit))))

1 / (
  (DB0 / ((2**4) * Runit))
+ (DB1 / ((2**3) * Runit))
+ (DB2 / ((2**2) * Runit))
+ (DB3 / ((2**1) * Runit))
+ (DB4 / ((2**0) * Runit))
)
```


### 20.4 post-sim of voltage divider

先不搭建 voltage divider 版图，用 calibre of 3-bit and 5-bit RDAC 配合实际电阻进行仿真，效果如下：
- Input Code vs. volt_scale 值：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-17-53-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 常用 volt_scale 值对应数字码推荐：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-02-37-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-02-34-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 常用 volt_scale 值对应数字码推荐：
    - (D_RC1_dec, D_RC2_dec) -> volt_scale
    - 一般使用 D_RC1_dec = 5 就够了
        - (5,  0) -> 0.4013 ≈ 0.40
        - (5,  6) -> 0.4093 ≈ 0.41
        - (5, 11) -> 0.4191 ≈ 0.42
        - (5, 16) -> 0.4308 ≈ 0.43
        - (5, 18) -> 0.4397 ≈ 0.44
        - (5, 20) -> 
    - 常用值全部列在这里：
    - volt_scale = 0.38
        - (4, 12) -> 0.3812 ≈ 0.38
        - (3, 17) -> 0.3810 ≈ 0.38
        - (0, 21) -> 0.3796 ≈ 0.38
    - volt_scale = 0.39
        - (4, 14) -> 0.3884 ≈ 0.39
        - (0, 22) -> 0.3909 ≈ 0.39
    - volt_scale = 0.40



然后搭建完整 `202602_CDR__Adaptation_VTH_Rbank_voltDivider` 模块，提取寄参进行后仿，结果如下：
- Input Code vs. volt_scale @ TT27：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-17-38-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- TT/SS/FF @ 50°C corner 下的 volt_scale 值对比：
- 常用 volt_scale 值对应数字码推荐：(D_RC1_dec, D_RC2_dec) -> volt_scale
    - 一般使用 D_RC1_dec = 5 就够了：
        - (5,  4) -> 400.7m ≈ 0.40
        - (5, 10) -> 410.7m ≈ 0.41
        - (5, 14) -> 421.4m ≈ 0.42
        - (5, 17) -> 429.1m ≈ 0.43
        - (5, 19) -> 438.9m ≈ 0.44
        - (5, 21) -> 451.9m ≈ 0.45




## 21. Adaptation_VTH (2)

### 21.1 overall placement

Adaptation_VTH 模块整体版图布局如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-04-55-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>

### 21.2 post-sim test

Adaptation_VTH 模块主要包括：
- (1) CK_DIV4 与 retiming
- (2) bounded UP/DN counter
- (3) R-2R DAC
- (4) S2D CMLBUF
- (5) voltage divider using RDAC

我们将已经单独验证过的 (1) ~ (4) 代入模块，然后在 TB_CDR_CORE 中与 AFE 一齐进行仿真，设置和结果如下：
- interactive.435
    - 2026.04.14 凌晨 (周二凌晨)
    - TB_CDR_CORE -> TB_4d1_CDR_CORE_CKDIV4
    - MyLib_tsmcN28 > CDR_CORE_v1 > **calibre_v2d1_addedGuardRingAndDummy**
    - Iss = 6m
    - CML_IR = 250m
    - **VDD = 1.1**
    - (data_rate， RC, POS_volt_scale) = 
        - (56G, 0.4, 0.43)
        - (56G, 0.6, 0.43) (0.5 UI @ 0.43 以及仿过了，是成功的)
        - (56G, 0.7, 0.43)
        - (56G, 0.8, 0.43)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- 仿真耗时 @ (32-thread, 1-job)：第一组 5h 5m 43s，第二至四组未仿完即取消了
- 数字码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-14-03-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-14-04-25_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (3) Adaptation and DFE Layout.png"/></div>
- 结果总结：
- 讨论：
    - (1) 2026.04.14 凌晨进行的这次仿真，POS 端的 `202602_CDR__Adaptation_VTH` 应该是正确设置了的，但是 NEG 端的 `202602_CDR__Adaptation_VTH` 设置错误，误将 CK_SYS 输入设置为了 testbench 中生成的 CK_DIV4。
    - (2) 这一方面导致 NEG 端的收敛速度过慢 (数字码曲线可以看出这一点)，另一方面导致 NEG 端的计数器可能出现 “异常” (从数字码曲线中可以看出 NEG_DTH_dec 存在非 ±1 的升降，而 POS_DTH_dec 没有)。因为 `202602_CDR__Adaptation_VTH` 内部的 CK_DIV4 生成以及时序对齐，是以 AFE 输出为基准的，也就是默认 **"AFE output: edge of DATA lags edge of CK_SYS by 18ps, hence BUFs are used to adjust the egde position"** 然后 "Edge of up_raw laging edge of CK_DIV4 by 8ps" is achieved；如果 NEG 端的 CK_SYS 错误地设置为了 CK_DIV4，那么就变成了 **edge of DATA lags edge of CK_SYS by 6ps** ，导致后面 Edge of up_raw laging edge of CK_DIV4 by **-2ps**，这会导致 DFF 做 retiming 时进入亚稳态，可能导致后续计数器逻辑出现故障。
    - (3) 同时，这也是 AFE 整体无法正常工作的根本原因：在 POS/NEG_DTH_dec 完全收敛之前，TAP1_dec 的值是无法正确收敛的，像上面这里就能看到 TAP1_dec 的值在 80 ~ 100 之间波动，这么大的 TAP1 (40% of 400 uA) 导致 Summer 输出严重变形 (看过 Summer 眼图，确实非常不好)；可以从 eye_SH 侧面验证这一点，这个眼图应该是比较好 (和之前一致) 的才对，**但是我们看了一下眼图，eye_SH 眼图也非常不好，这是为什么？难道说还有其它原因？**
- 我们将 NEG 端的时钟改为正确的 CK_SYS 后，又进行了一次仿真 (interactive.436)，这次仿真中刚刚所说 "SH 眼图不好的问题" 仍在：
    - 看一下 DIN_ideal, DIN_unideal, CK<2> 以及 SH2 的具体波形来找找原因：
    - 之前 interactive.432 的正常结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-15-07-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 这次 interactive.435 的异常结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-16-48-27_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 对比之下，可以发现两组仿真中时钟和数据输入的对齐关系不同，这是为什么？截至 220 ns 的数字码结果如右图，可以看到结果和正常曲线明显对不上：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-16-51-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 详细看了一下，在 interactive.435 中，neg-edge of CK2 在 edge of data 之后 2.0 ps ~ 2.7 ps (平均 2.35 ps)，如右图：



找了半天不知道问题出在哪里，于是回到之前的 Lib_BK_20260410 找到原来的 testbench 设置，复制过来，先验证下这里的 SH 时序后，再将 VA_Adaptation_VTH 换为实际的 `202602_CDR__Adaptation_VTH` 模块。验证结果如下：
- interactive.437
    - 2026.04.14 下午 (周二下午)
    - **TB_CDR_CORE_test** -> TB_4d1_CDR_CORE_CKDIV4
    - MyLib_tsmcN28 > CDR_CORE_v1 > **calibre_v2d1_addedGuardRingAndDummy**
    - Iss = 6m
    - CML_IR = 250m
    - VDD = 1.1
    - (data_rate， RC, POS_volt_scale) = 
        - (56G, 0.4, 0.43)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- 过程观察：
    - (0) 各数字码曲线的走势倒是基本正常，如右图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-18-25-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - (1) DIN_unideal 的波形，以及和 CK 的对齐关系和之前 "interactive.432 正确的结果" 一致，但是 SH 的输出眼高明显减小 (从 100 mV 减小到 50 mV 左右，我列个豆啊)，这是为什么？
    - 经过非常仔细的对比，我们发现 interactive.432 (正确结果) 中，neg-edge of CK2 在 edge of data 之后 2.0 ps ~ 2.7 ps (平均 2.35 ps)，如右图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-18-10-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 而现在这里把 Adaptation_VTH 换为 verilog 进行重新验证的 interactive.437，其 neg-edge of CK2 在 edge of data 之后 4.7 ps ~ 5.2 ps (平均 4.95 ps)，如右图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-18-14-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 两组放在边沿差了大概 2.6 ps 这样子，在 eye_DIN_unideal 上可以看出，相差 2.6 ps 会导致 DIN_unideal 眼高从 166.4 mV 下降到 125.3 mV (-41.1 mV)，所以最终 SH 眼高从 100 mV 减小到 50 mV 左右也许是正常的？
    - 虽然不知道这 2.6 ps 的差距是哪里来的，但为了复现仿真结果，我们还是将 CK 发生时间提前 2.6 ps，重新仿真如下：
- interactive.438 (将 CK 发生时间提前 2.6 ps)
    - 2026.04.14 下午 (周二下午)
    - **TB_CDR_CORE_test** -> TB_4d1_CDR_CORE_CKDIV4
    - MyLib_tsmcN28 > CDR_CORE_v1 > **calibre_v2d1_addedGuardRingAndDummy**
    - Iss = 6m
    - CML_IR = 250m
    - VDD = 1.1
    - (data_rate， RC, POS_volt_scale) = 
        - (56G, 0.4, 0.43)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- 过程观察：
    - (1) 修改时钟/数据对齐关系后，SH 输出确实好了很多，甚至比 interactive.432 这个 "正确结果" 的 SH 还要好，如右图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-19-12-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



于是把 Adaptation_VTH 模块换为实际的，重新进行仿真：
- interactive.439 (已在 interactive.438 将 CK 发生时间提前 2.6 ps)
    - 2026.04.14 下午 (周二下午)
    - **TB_CDR_CORE_test** -> TB_4d2_CDR_CORE_CKDIV4_VTHADA
    - MyLib_tsmcN28 > CDR_CORE_v1 > **calibre_v2d1_addedGuardRingAndDummy**
    - Iss = 6m
    - CML_IR = 250m
    - VDD = 1.1
    - (data_rate， RC, POS_volt_scale) = 
        - (56G, 0.4, 0.43)
        - (56G, 0.6, 0.43)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-23-33-16_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 过程观察：
    - (1) 不知为何 CK 和 DIN_unideal 的对齐关系又错了，变为 neg-edge of CK2 在 edge of data 之后 3.5 ps ~ 6.5 ps (平均 5.0 ps)，如右图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-23-28-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - (2) 此时 SH 眼高在短期内只有约 50 mV (确定过不是 "均衡过度" 导致)，而在长期内 (10 ms ~ 170 ms) 仅仅只有不到 25 mV，如右图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-23-32-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - (3) 在调整 DATA/SH 对齐关系，重新仿真之前，我们先记录一下数字码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-14-23-38-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


将 CK 位置再进一步提前 2.5 ps，重新进行仿真：
- interactive.430 (CK 提前 2.6 ps + 2.5 ps)
    - 2026.04.14 晚上 (周二晚上)
    - **TB_CDR_CORE_test** -> TB_4d2_CDR_CORE_CKDIV4_VTHADA
    - MyLib_tsmcN28 > CDR_CORE_v1 > **calibre_v2d1_addedGuardRingAndDummy**
    - Iss = 6m
    - CML_IR = 250m
    - VDD = 1.1
    - (data_rate， RC, POS_volt_scale) = (56G, 0.4, 0.43)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
- config 设置：同 interactive.438
- 过程观察：
    - 0 ~ 20ns SH2 波形观察：已正常复现 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-01-41-07_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 0 ~ 40ns SH2 眼图：已正常复现 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-01-39-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 0 ~ 100ns 各数字码曲线走势：算是正常走势 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-02-17-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 40ns ~ 100ns Summer 输出眼图：已正常复现 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-02-20-54_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真耗时 @ (32-thread, 1-job)：7h 29m 47s
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-16-07-35_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结果总结：
    - (IDD_AFE, POS_dec, NEG_dec, TAP1_dec)
    - (56G, 0.4, 0.43) (成功) -> (xxx mA, 57.35%, 61.38%, 3.593%)
- 部分关键结果展示：
    - 数字码曲线：稳定后 POS_dec = 57.35% ≈ 146.2, NEG_dec = 61.38% ≈ 156.5, TAP1_dec = 3.593% ≈ 9.16 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-16-26-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - SH0/SUM0 眼图：眼高宽分别为 125 mV @ 58.0 ps (+28.0mV ~ +153.5mV) 和 223.7 mV @ 43.3 ps (+59.5 mV ~ +283.2 mV) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-16-30-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - actual_volt_scale_t 曲线：设置值为理想 0.43, 在 420m ~ 440m 之间波动 (mean = 429.75m, sigma = 4.49m/3.60m) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-16-46-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 其它：Adaptation_VTH 模块里，所用的 S2D CMLBUF 偏置电流是 2 mA，对应电压为 456.4 mV <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-16-42-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



嗯，看来 interactive.430 这里是没有什么问题，我们将实际 voltage divider 也引入到 Adaptation_VTH 模块中，进行进一步仿真：
- interactive.432 (CK 提前 2.6 ps + 2.5 ps)
    - 2026.04.15 凌晨 (周三凌晨)
    - **TB_CDR_CORE_test** > **TB_4d3_CDR_CORE_CKDIV4_VTHADA_Rbank**
    - MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2d1_addedGuardRingAndDummy
    - Iss = 6m
    - CML_IR = 250m
    - VDD = 1.1
    - (data_rate， RC, POS_volt_scale) = (56G, 0.4, 0.43)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
    - (D_RC1_dec, D_RC2_dec) = **(5, 17)**, 对应 volt_scale = 0.4291 ≈ 0.43 (calibre of `202602_CDR__Adaptation_VTH_Rbank_voltDivider`)
- config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-05-07-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真耗时 @ (32-thread, 1-job)：8h 20m 0s
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-16-51-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结果总结：此次仿真的数值结果与 interactive.430 几乎完全一致 (这次 interactive.432 将分压电阻网络换为了实际的)
    - (IDD_AFE, POS_dec, NEG_dec, TAP1_dec)
    - (56G, 0.4, 0.43) (成功) -> (260.6m, 57.26%, 61.85%, 3.77%)
- 部分关键结果展示：
    - 数字码曲线：稳定后 POS_dec = 57.35% ≈ 146.2, NEG_dec = 61.38% ≈ 156.5, TAP1_dec = 3.593% ≈ 9.16（图这里懒得给了）
    - SH0/SUM0 眼图：这项结果懒得总结了这里
    - actual_volt_scale_t 曲线：设定值为 dec = 5/17 对应 volt_scale = 0.4291 ≈ 0.43, 在 415m ~ 443m 之间波动；**实际 mean = 427.0m/426.8m, sigma = 6.64m/5.80m** <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-17-05-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 注：相比理想分压网络，actual_volt_scale_t 的性能稍有下降，主要体现在分布密度的非高斯特征，导致平均值偏离和标准差增大，**建议增大外挂电容的同时优化 VTHP/VTHN 对称性以改善此现象。**



### 21.3 complete Adaptation_VTH

这一小节把 Adaptation_VTH 的版图给完整做完，Adaptation_VTH 模块的主电容分配情况如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-19-45-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>




### 21.3 self-biased CMLBUF

之前我们 CMLBUF 都是外部给 2 mA 偏置，多方面考虑下来还是决定：
- (1) 先试试 bias 直接给 VDD 的效果
- (2) 通过一个 diode-connected MOS 接到 VDD
- (3) 通过约 225 Ohm 的电阻接到 VDD
- (4) 通过一个 diode-connected MOS + 电阻接到 VDD
- (5) 如果上面几条都不行，还是在本地自己生成偏置，参考之前 OPA 设计时使用过的 biasing circuit 来做

尝试结果如下：
- (1) 理想 2 mA 偏置时的 DC 仿真结果如下 (前仿，后仿没法看 MOS 工作状态)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-20-51-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- (2) 通过相同尺寸 diode-connected MOS 接到 VDD 的效果如下：PVT 变化极大，无法满足要求 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-20-55-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- (2.1) 两个 diode-connected MOS 串联后接到 VDD 的效果如下：偏置电流过小 (意料之中) 且波动过大，无法满足要求 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-21-13-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- (3) 通过约 230 Ohm 的电阻接到 VDD 的效果如下：Corner 波动还算能接受，但是整体电流有些偏大了，不妨稍微增大电阻 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-23-53-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- (3.1) 通过约 274 Ohm 的电阻接到 VDD 的效果如下：电流仍稍微偏大一点点 (0.25 mA)，但其实也算能用了，毕竟 VDD 升高导致偏置电流增大后，输出共模这边其实会稍微抬高一些 (因为输入共模也有所升高)，所以对 VTH 调控影响不大 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-00-04-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- (3.2) 通过约 287 Ohm 的电阻接到 VDD 的效果如下：只看 1.1V 的话，自然是比 274 Ohm 的电阻效果稍好一些 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-00-08-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- (3.3) 通过约 300 Ohm 的电阻接到 VDD 的效果如下：如果用方案 (3)，这估计是最佳选择了 (虽然仍不是那么好) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-00-13-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- (4) 过一个同尺寸 diode-connected NMOS 和 107 Ohm rpmg 电阻接到 VDD 的效果如下：这个随 VDD 波动非常大，不予考虑 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-00-23-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



我们参考之前 OPA 设计时使用过的 biasing circuit 来做 (5)，考虑 biasing = 250 uA 然后八倍给到 vbias of CMLBUF，正向翻倍给到 nmos tail，所以使用 PMOS-Rs (Rs 在 PMOS 端) 型式，如下图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-20-27-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 取 gm/Id = 10 且 Iout = 250 Ohm 时，计算得到 Rs = 565.68 Ohm，作为一个参考值。我们直接扫描不同 Rs 下对应的偏置电流大小： <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-01-02-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 上图最佳点 R_length_rela = 2.8 意思是 length = 2.8 x width (两个电阻并联，对应阻值为 825.8 Ohm)，我们看看这点对应的 PVT 情况：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-01-10-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 上图这样感觉这电流关于 VDD 和 Corner 的变化也不小啊，这是为什么？是我们偏置电流那一路搞错了吗，应该用 Iout 而不是 IREF? 可是我们也看了一下 Iout, 其在 PV 下的波动为 ±65%，而 IREF 波动为 ±60% 反而更小。


综合考虑下来，我们还是选择方案 (3.3) 通过约 300 Ohm 的电阻接到 VDD，得到 PEX 结果如下 (VB 自带 75 fF 去耦电容)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-02-16-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>

``` bash
CDR_ulvt_1d0_600n_30n_CMLBUF_selfBias_500Ohm_2mA_x16
202602_CDR__Adaptation_VTH_v2_20260415_BK_PS_202604161524
```





## 22. AFE with CKBUF

这一小节主要是把之前单独验证过的 CKBUF (calibre) 模块引入到 AFE 中，进行整体仿真验证，先看一下 VCO<7:0> 到 CK<7:0> (buffered clock) 的时序关系 (延迟情况)，然后对应提前 VCO 的开启时间，即可将 CK 与 DIN_unideal 的对齐关系调整到和之前 "正确结果" 一致的状态。
- 手动标出延迟时间：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-20-05-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 作出全部延迟时间： **mean = 23.7784 ps** @ sigma = 6.18556 fF <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-20-10-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



有了数据后重新设置 CK 的发生时间，进行仿真验证：
- interactive.432 (CK 提前 2.6 ps + 2.5 ps)
    - 2026.04.15 凌晨 (周三凌晨)
    - **TB_CDR_CORE_test** > **TB_4d3_CDR_CORE_CKDIV4_VTHADA_Rbank**
    - MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2d1_addedGuardRingAndDummy
    - Iss = 6m
    - CML_IR = 250m
    - VDD = 1.1
    - (data_rate， RC, POS_volt_scale) = (56G, 0.4, 0.43)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
    - (D_RC1_dec, D_RC2_dec) = (5, 17), 对应 DC volt_scale ≈ 0.43 然后实际 volt_scale ≈ 0.427
    - CKBUF_tdelay = {22.8p, 23.3p, 23.8p, 24.3p}
- config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-20-14-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 设置 8-thread @ 4-job 进行过程观察：
    - 不同 CKBUF_tdelay 的 0 ~ 20 ns SH0 波形观察：其实四个 CKBUF_tdelay 值下的 SH 输出基本没有啥差别 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-23-38-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 不同 CKBUF_tdelay 的 20n ~ 100 ns SH0 眼图观察：在都复现了正确结果的同时，确实区别不大，从 22.8p, 23.3p, 23.8p 到 24.3p 对应的 SH0 眼高依次为 91.14 mV -> 95.15 mV -> 106.81 mV -> 102.88 mV，这与我们预测的 edge 位置一致，所以我们的 CKBUF network 应该是没有啥问题的 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-23-50-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>




## 99. overall die diagram

2026.04.07 19:22 导师提供：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-19-22-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>

