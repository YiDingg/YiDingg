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
    - (data_rate, RC, POS_volt_scale) = 
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
    - (data_rate, RC, POS_volt_scale) = 
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
    - (data_rate, RC, POS_volt_scale) = 
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
    - (data_rate, RC, POS_volt_scale) = 
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
    - (data_rate, RC, POS_volt_scale) = (56G, 0.4, 0.43)
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
    - (data_rate, RC, POS_volt_scale) = (56G, 0.4, 0.43)
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
```



### 21.4 complete layout and post-sim

搭建完整 `202602_CDR__Adaptation_VTH_v2_20260415` 版图并解决所有 DRC 问题，得到 layout 效果和 PEX 结果如下：
- layout 效果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-16-39-50_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- PEX 结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-16-40-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


进行仿真验证：
- interactive.436 (CK 提前 2.6 ps + 2.5 ps)
    - 2026.04.16 傍晚 (周四傍晚)
    - TB_CDR_CORE_test > **TB_6_CDR_CORE_CKDIV4_ADAVTH**
    - MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2d1_addedGuardRingAndDummy
    - Iss = 6m
    - CML_IR = 250m
    - VDD = 1.1
    - (data_rate, RC, POS_volt_scale) = (56G, 0.4, 0.43)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
    - (D_RC1_dec, D_RC2_dec) = (5, 17), 对应 DC volt_scale ≈ 0.43 然后实际 volt_scale ≈ 0.427
- config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-18-44-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真时间 @ (16-thread, 1-job)：7h 22m 50s
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-18-09-21-32_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结果总结：没有啥问题
- 部分关键结果展示：懒得展示了




## 22. AFE with CKBUF

这一小节主要是把之前单独验证过的 CKBUF (calibre) 模块引入到 AFE 中，进行整体仿真验证，先看一下 VCO<7:0> 到 CK<7:0> (buffered clock) 的时序关系 (延迟情况)，然后对应提前 VCO 的开启时间，即可将 CK 与 DIN_unideal 的对齐关系调整到和之前 "正确结果" 一致的状态。
- 手动标出延迟时间：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-20-05-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 作出全部延迟时间： **mean = 23.7784 ps** @ sigma = 6.18556 fF <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-20-10-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


有了数据后重新设置 CK 的发生时间，进行仿真验证：
- interactive.435 (CK 提前 2.6 ps + 2.5 ps)
    - 2026.04.16 凌晨 (周四凌晨)
    - **TB_CDR_CORE_test** > **TB_4d3_CDR_CORE_CKDIV4_VTHADA_Rbank**
    - MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2d1_addedGuardRingAndDummy
    - Iss = 6m
    - CML_IR = 250m
    - VDD = 1.1
    - (data_rate, RC, POS_volt_scale) = (56G, 0.4, 0.43)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
    - (D_RC1_dec, D_RC2_dec) = (5, 17), 对应 DC volt_scale ≈ 0.43 然后实际 volt_scale ≈ 0.427
    - CKBUF_tdelay = {22.8p, 23.3p, 23.8p, 24.3p}
- config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-20-14-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 设置 8-thread @ 4-job 进行过程观察：
    - 不同 CKBUF_tdelay 的 0 ~ 20 ns SH0 波形观察：其实四个 CKBUF_tdelay 值下的 SH 输出基本没有啥差别 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-23-38-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 不同 CKBUF_tdelay 的 20n ~ 100 ns SH0 眼图观察：在都复现了正确结果的同时，确实区别不大，从 22.8p, 23.3p, 23.8p 到 24.3p 对应的 SH0 眼高依次为 91.14 mV -> 95.15 mV -> 106.81 mV -> 102.88 mV，这与我们预测的 edge 位置一致，所以我们的 CKBUF network 应该是没有啥问题的 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-15-23-50-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真时间 @ (8-thread, 4-job)：14h 47m 22s
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-18-39-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结果总结：此次仿真的数值结果与使用理想 verilog CK 的 interactive.432 (CK 提前 2.6 ps + 2.5 ps) of TB_CDR_CORE_test > TB_4d3_CDR_CORE_CKDIV4_VTHADA_Rbank 大致一样，但数值结果稍有不同，具体体现在 SH 眼高稍降低 (140mV -> 110 mV) 然后数字码稳定值自然也发生变化。
    - (IDD_AFE, POS_dec, NEG_dec, TAP1_dec)
    - (56G, 0.4, 0.43) @ 第四点 (CKBUF_tdealy = 24.3p) (成功) -> (262.0m, 52.9%, 56.68%, 12.06%)
- 部分关键结果展示：
    - 数字码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-13-46-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - SH0 眼图对比：从长时间眼图上看，第四个点 (CKBUF_tdealy = 24.3p) 对应的结果最佳 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-13-42-32_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - actual_volt_scale_t 曲线 @ 第四点 (CKBUF_tdealy = 24.3p)：设定值为 dec = 5/17 对应 volt_scale = 0.4291 ≈ 0.43，实际 mean = 427.5m/427.2m，分压模块和 interactive.432 (CK 提前 2.6 ps + 2.5 ps) of TB_CDR_CORE_test > TB_4d3_CDR_CORE_CKDIV4_VTHADA_Rbank 是一样的，结果也基本一样，这里就不总结了



## 23. Adaptation_DFE

``` bash
DH_N DL_N DADA_H_N DADA_L_N DH_NM1 DL_NM1
dffIn_DH_N dffIn_DL_N dffIn_DADA_H_N dffIn_DADA_L_N dffIn_DH_NM1 dffIn_DL_NM1
dffIn_DH_N,dffIn_DL_N,dffIn_DADA_H_N,dffIn_DADA_L_N,dffIn_DH_NM1,dffIn_DL_NM1
div4_DH_N,div4_DL_N,div4_DADA_H_N,div4_DADA_L_N,div4_DH_NM1,div4_DL_NM1
div4B_DH_N,div4B_DL_N,div4B_DADA_H_N,div4B_DADA_L_N,div4B_DH_NM1,div4B_DL_NM1

DH_n DL_n DERR_pos_n DERR_neg_n DH_nm1 DL_nm1
div4_DH_N div4_DL_N div4_DADA_H_N div4_DADA_L_N div4_DH_NM1 div4_DL_NM1
```


### 23.1 将内部 verilog 换为实际电路 (Adaptation_DFE_v1)

初步替换效果如下 (VREF to Vout 这里要用多比特数控，还没画在里面)，这里顺便对 EN 的计算逻辑做了优化，但 UPDN 的计算逻辑懒得优化了 (比较麻烦)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-22-08-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


仿真一下看看是否有改错了的地方：
- interactive.437
    - 2026.04.16 夜晚 (周四夜晚)
    - TB_CDR_CORE_test > **TB_6_CDR_CORE_CKDIV4_ADAVTH**
    - MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2d1_addedGuardRingAndDummy
    - Iss = 6m
    - CML_IR = 250m
    - VDD = 1.1
    - (data_rate, RC) = (56G, **0.6**, 0.43)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
    - (D_RC1_dec, D_RC2_dec) = (5, 17), 对应 DC volt_scale ≈ 0.43 然后实际 volt_scale ≈ 0.427
- config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-18-44-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 过程观察：
    - 140ns ~ 220ns 数字码曲线和 SAM0 眼图观察：应该是没有啥问题 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-00-48-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真时间 @ (8-thread, 1-job)：8h 57m 39s
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-17-43-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - actual_POS_voltScale_ave	428.6m
    - actual_NEG_voltScale_ave	426.9m
    - POS_DTH_dec_ave (%)	    46.47
    - NEG_DTH_dec_ave (%)	    51.25
    - TAP1_dec_ave (%)	        8.23
    - IDD_ave	                252.2m
- 结果总结：没有啥问题



### 23.2 VREF to VOUT converter

将 DAC 线性输出的电压转换为线性电流偏置，然后通过电压给到 AFE 的 VB_MAIN。预计 PMOS 这里弄一个 2-bit control (倍数 x1 ~ x4，每一倍对应 100 uA)，先设置 pmos unit = 1.2u/30n 来试试效果 (diode-connected nmos = 2.4u/30n 与 Summer 中的 nmos tail of TAP1 尺寸保持一致)：
- (1.0) 设置 pmos = 1.2u/30n，固定 VDD = 1.1V，在不同 Rs 下扫描 VREF: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-22-16-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- (1.1) 选择 Rs = 4k，观察最大偏置在不同 PV 下的变化：
- (2.0) 设置 pmos = 0.6u/30n，在不同 Rs 下扫描 VREF: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-22-21-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 注：不对，这里为了实现线性的 V to I 转换，应该让 PMOS 尺寸尽量大，这样它的 Vgs 小，自然就能形成 Iout = VREF/Rs 的线性效果，然后我们的数字码调控可以用 TG 控制 Rs 的并联关系来做。
- (3.0) 设置 pmos = 4.8u/30n，看看 Rs = 10 kOhm 在 PV 下的电流情况：最大 50 uA ~ 100 uA (nom = 72.5 uA)，这样的话四倍能覆盖 200 uA ~ 400 uA，还是再稍微减小点 Rs 吧 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-23-00-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- (3.1) 设置 pmos = 4.8u/30n，看看 Rs = 7 kOhm 在 PV 下的电流情况：最大 71 uA ~ 143 uA (nom = 99.5 uA)，四倍就能覆盖 280 uA ~ 560 uA，没有问题 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-16-23-12-05_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


构建 2-bit 数控，查看 VREF = 0 (对应 Imax) 时的 PV 波动情况：D_DFE_IMAX_dec = 3 时最低也有 250 uA，然后 D_DFE_IMAX_dec = 0 时最高也仅有 143 uA，可以实现较好的范围覆盖 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-00-23-50_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>





### 23.3 Adaptation_DFE_v2

在 `202602_CDR__Adaptation_DFE_v2_20260417` 中搭建完整 adaptation 模块，版图效果和 PEX 结果如下：
- v1 版图效果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-04-11-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- v1 PEX 效果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-04-10-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


代入 calibre of Adaptation_DFE_v2 仿真验证一下效果如何：
- interactive.438
    - 2026.04.17 凌晨 (周五凌晨)
    - TB_CDR_CORE_test > **TB_7_CDR_CORE_AdaDFE**
    - MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2d1_addedGuardRingAndDummy
    - Iss = 6m
    - CML_IR = 250m
    - VDD = 1.1
    - (data_rate, RC) = (56G, **0.6**)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
    - (D_RC1_dec, D_RC2_dec) = (5, 17), 对应 DC volt_scale ≈ 0.43 然后实际 volt_scale ≈ 0.427
    - D_DFE_IMAX_dec = 3, 对应 Imax = 340 uA @ nom (应该是这么大？)
- config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-04-24-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 过程观察：没有啥问题
- 仿真时间 @ (8-thread, 1-job)：7h 9m 56s
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-17-38-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - actual_POS_voltScale_ave		427.3m
    - actual_NEG_voltScale_ave		426.5m
    - actual_POS_voltScale_stddev	5.01m
    - actual_NEG_voltScale_stddev	5.928m
    - POS_DTH_dec_ave (%)		    43.34
    - NEG_DTH_dec_ave (%)		    46.51
    - TAP1_dec_ave (%)		        33.32
    - VB_TAP1_ave		            277.0m
    - IDD_ave		                261.6m
- 结果总结：功能上没有任何问题，但是注意 DFE_Imax 的覆盖范围
    - (IDD_AFE, POS_dec, NEG_dec, VB_TAP1_ave)
    - (56G, 0.6, 0.43) (成功) -> (260.6m, 57.26%, 61.85%, 277.0m)
- 部分关键结果展示：
    - 数字码曲线：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-17-26-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 分压曲线：在 420 mV ~ 437 mV 之间波动，<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-17-28-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 从 DIN_undieal -> SH -> SUM -> SAM -> SAMQ 的全流程展示 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-17-06-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 讨论与思考：
    - (1) 在 TB_DCtest 中扫描一下不同 VREF/VOUT 对应的偏置电流大小，如右图所示：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-17-24-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - (2) 从上图可以看出 VOUT = VB_TAP1_ave = 277.0 mV (TAP1_dec_ave = 33.32%) 对应电流 IB_TAP1 = 76 uA (似乎不是很符合 340 uA x 33.32% = 112 uA?)，从 eye_SUM0 中看出大约有 46.75 mV 的均衡效果。



### 23.4 Adaptation_DFE_v3 (with VB_MAIN)

从 interactive.438 看出 Iss = 6m 设置下，VB_MAIN = 689.45 mV (ulvt_nmos = 9.6u/30n, width = 2 x 8 x 600n)。此时 1.1 V 的电压，如果要用 Rs 连接到 VDD 的话就是对应 Rs = 68.425 Ohm。这么小的电阻就不用之前的 `rupolym` 来实现了，结合 AI 结果考虑使用 `rnod` (PVT 波动小，方块阻值小)。
- 这里同样使用 2-bit 来控制，初步考虑使用 TG_x16 (Req = 125 Ohm)，MATLAB 计算结果如下：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-18-16-28_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 显然，Runit = 140 Ohm 是一个比较合适的值，仿真验证一下 TT50 (142.5 Ohm)：嗯，没有什么问题，四档分别为 3.54m/5.19m/5.87m/6.90m <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-18-23-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 再看看 PT 情况：
    - 1.1V 下：
        - D_dec = 0 -> 3.604m (2.619m ~ 5.398m)
        - D_dec = 1 -> 5.283m (3.983m ~ 7.340m)
        - D_dec = 2 -> 5.973m (4.633m ~ 7.937m)
        - D_dec = 3 -> 7.023m (5.512m ~ 9.123m)
- 不是哥们，这 PT 一点都不小啊，再试试 `rupolym` 的效果：
    - 1.1V 下：
        - D_dec = 0 -> 3.649m (2.971m ~ 4.512m)
        - D_dec = 1 -> 5.322m (4.438m ~ 6.419m)
        - D_dec = 2 -> 6.005m (5.075m ~ 7.149m)
        - D_dec = 3 -> 7.053m (5.975m ~ 8.352m)
- `rupolym` 的 PT 效果明显好得多，我们还是就用它吧。
- Main biasing 的电压电流对应关系如右图 (TT50)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-18-03-13-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 4 mA <-> 576.2 mV
    - 6 mA <-> 689.9 mV
    - 8 mA <-> 798.0 mV
    - 658.0 mV <-> 5.427 mA


版图效果和 PEX 结果如下：
- 版图效果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-21-21-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- PEX 结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-22-46-45_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


代入 calibre of Adaptation_DFE_v3 仿真验证一下效果如何：
- interactive.439
    - 2026.04.17 凌晨 (周六凌晨)
    - TB_CDR_CORE_test > **TB_7_CDR_CORE_AdaDFE**
    - MyLib_tsmcN28 > CDR_CORE_v1 > calibre_v2d1_addedGuardRingAndDummy
    - CML_IR = 250m
    - VDD = 1.1
    - (data_rate, RC) = (56G, **0.6**)
    - NEG_volt_scale = POS_volt_scale
    - fnoise_max = 100G
    - temperature = 65°C
    - (D_RC1_dec, D_RC2_dec) = (5, 17), 对应 DC volt_scale ≈ 0.43 然后实际 volt_scale ≈ 0.427
    - D_DFE_IMAX_dec = 3, 对应 Imax = 340 uA @ TT50
    - D_MAINVB_dec = 2, 对应 Iss = 6.005 mA @ TT50 (实际为 VB_MAIN = 658.0 mV <-> IB_MAIN = 5.427 mA)
- config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-17-23-05-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 过程观察：没啥问题
- 仿真时间 @ (8-thread, 1-job)：6h 52m 42s
- 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-18-09-22-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结果总结：没有啥问题
    - (IDD_AFE, POS_dec, NEG_dec, VB_TAP1_ave, VB_MAIN_ave)
    - (56G, 0.6, 0.43)
- 部分关键结果展示：懒得展示了



``` bash
Logic_std_2d0_200n_30n_PAM3_PDLogic_quarterRate_Alxd_4out_v2
Logic_std_2d0_200n_30n_PAM3_PDLogic_quarterRate_Alxd_4out_withDFF
```


## 24. CP Test (1)

肖师兄提供了之前师姐做的 CP，有几个不同模块我们这里用的是 `CP_MAIN_2_SEL_1p3_NEGATIV_CP`：
- 简要说明：五个 CP unit 并联，由 SL<4:0> 选通，通常是一个 SL<0> 恒导通剩下四个由 2-bit binary code D<1:0> + Bin2Therm 控制；
- 注：此模块的 UP/DN 信号是反的，我们一般认为 UP -> 电流流向 cap -> Vctrl 增大，但这里是 UP -> 电流流向 CP -> Vctrl 降低

进行仿真验证：
- testbench 原理图：
- 仿真结果波形：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-20-00-38-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 图中可以观察到，
    - (1) calibre_tran 和 calibre_gate 基本无区别，说明我们提参的方法是对的
    - (2) calibre_gate (9m 5.5s) 仿起来比 calibre_tran 快得多 (31m 38.6s)，后面仿真想提速可以多用 gate level 提取




## 25. Design of PFD


### 25.1 PD with 3 outputs

``` bash
Logic_std_2d0_200n_30n_PAM3_PDLogic_quarterRate_Alxd_4out
```

搭建 PAM3 PD Logic 如下，并做仿真验证：
- 原理图：`Logic_std_2d0_200n_30n_PAM3_PDLogic_quarterRate_Alxd_3out`
- 仿真验证：
    - MyLib_tsmcN28 > Logic_std_2d0_200n_30n_PAM3_PDLogic_quarterRate_Alxd_3out > schematic
    - TB_CDR_PD_FD > 1_TB_PAM3_PD
    - interactive.273
    - time_end/pattern = 11/10
    - VTH_DM = CML_IR/2
    - 仿真设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-18-17-47-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 结果曲线 (delta_phase vs. output_ave_nor)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-18-17-39-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 讨论：
    - (1) 图中可以看出，deltaPhase_UI = 0 对应的点并不是 PD 输出曲线的中心零点，而是约为 deltaPhase_UI = -180.1m，眼图上对应 CK 左移 3.214 ps @ 56G (已标在眼图中)
    - (2) deltaPhase_UI = 300m 时出现的 "异常点"，经排查是理想 verilog slicer 设置 VTH_DM = CML_IR/2 导致的，在 deltaPhase_UI = 300m 时 RC 衰减波形恰好在 ±CML_IR/2 临界点，真正的正常衰减时不会出现这种情况
    - (3) 这里的 UP/DN 输出是不是反了？
        - 按理来说 PD 应该是左边低 (输出 DN) 而右边高 (输出 UP)。这是因为 deltaPhase_UI < 0 时，CK 边沿在理想采样点的左侧，输出 CK_nowLeft = DN -> vctrl ⬇️ -> freq ⬇️ -> 时钟边沿右移 -> 回到理想采样点，反之输出 CK_nowRight = UP，这是正确的才对。
        - 而 FD 应该是左边高 (CK Slow 时输出 UP) 而右边低 (CK Fast 时输出 DN)。
        - 但这里的结构和之前的 verilog 模块完全一样呀，如果这里反了的话，之前的结果为什么正确呢？
        - 核实了一下，当 DATA<0> oplus DATA<1> = 1 时，对应 output = CK_nowRight = UP，所以确实是 <0,1> 产生 UP 然后 <1,2> 产生 DN，所以我们的原理图结构没问题
        - 又核实了一下，输出表达式也没问题和 PAM3 PD Logic 也没问题，如右图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-18-18-13-49_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
        - 难道说真正的曲线中心在 deltaPhase_UI = 425.4m 而不是 deltaPhase_UI = -180.1m？偏得有这么离谱吗，我们用 verilog PD logic 仿了一下和实际曲线也是一样的呀
        - 破案了：原因是我们的 symbol UP/DN 上下放反了，如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-18-18-33-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


将 UP/DN 输出改为正常连接后，我们先仿一下 withDFF_3out 的输出曲线，看看输出特性有多少改善：
- 仿真验证：
    - **注意这里 PD 用到 DFF，因此需要调整 DATA lags CK_SYS by 18ps 左右，以匹配实际电路中输出的时钟和数据时序**
    - MyLib_tsmcN28 > Logic_std_2d0_200n_30n_PAM3_PDLogic_qR_Alxd_**withDFF_3out** > schematic
    - TB_CDR_PD_FD > 1_TB_PAM3_PD
    - interactive.280
    - time_end/pattern = 11/10
    - VTH_DM = **CML_IR/3**
- 结果曲线 (delta_phase vs. output_ave_nor)：
- 讨论：
    - (1) PD 时序与结果检查：时序和功能都没有问题 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-18-19-00-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - (2) 尴尬的是，这里 UP/DN 输出仍然是 "反的 (左高右低)"；罢了，先不管这个问题，大不了搭环路的时候 UP/DN 反过来用
    - (3) 再分别仿真一下 3out 和 withDFF_4out，方便对比它们之间的性能：
        - interactive.280 -> withDFF_3out
        - interactive.281 -> 3out
        - interactive.282 -> withDFF_4out 
            - 对比 3out/4out/withDFF_4out 结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-19-02-24-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
        - interactive.283 -> withDFF_4out @ VTH_DM = CML_IR/3
        - interactive.284 -> withDFF_3out @ VTH_DM = CML_IR/3
        - interactive.285 -> 3out @ VTH_DM = CML_IR/3
            - 对比 VTH_DM = CML_IR/3 时的结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-19-02-51-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 上图 (VTH_DM = CML_IR/3) 的 PD 输出曲线可以看出：
    - (1) 中心点在 deltaPhase_UI = -211m 左右
    - (2) withDFF_4out 的输出效果比 3out with/without DFF 效果要好，即便仅使用前三个输出也更好，这是为什么？

``` bash
UP<0>,DN<0>,UP<1>,DN<1>,UP<2>,DN<2>,UP<3>,DN<3>
pd_UP<0>,pd_DN<0>,pd_UP<1>,pd_DN<1>,pd_UP<2>,pd_DN<2>,pd_UP<3>,pd_DN<3>
```

``` bash
Logic_std_2d0_200n_30n_PAM3_PDLogic_quarterRate_Alxd_DFF_3out
Logic_std_2d0_200n_30n_PAM3_PDLogic_qR_Alxd_4out_v1_20260417
```



### 25.2 loop verification

只看输出特性曲线的话终究是不太够，毕竟曲线存在 "明显的中心点偏移"？不过其实按上述设置来讲，中心点在 deltaPhase_UI = -0.25 的地方，所以从这个角度来讲中心点 "偏到" deltaPhase_UI = -210m 是比较正常的。

搭建 PD -> CP -> VCO 环路来验证 PD 功能并比较性能，仿真如下：
- (1) 先使用 PD_3out 尝试了只用一个电容 C1 = 3p/10p 的情况 (交换了 UP/DN, Icp_total = 150u/600u)，发现环路存在明显振荡，遂改为二阶 LPF (R1, C1, C2)
- (2) 在固定的 24 组参数下看看各类型 PD 能做到多低的 jitter：
    - 仿真设置截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-19-03-55-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 仿真设置概要：
        - time_end/data_pattern = 12/10
        - dataRate = 14G
        - data_Je_rms_UI = 30m
        - **Jc_rms_UI = 3m**
        - k_vco = 200 MHz/V
        - R1 = {200, 400, 800}
        - C1 = {6p, 12p, 18p}, C2 = C1/12
        - Icp_total = {150u, 300u, 450u}
    - (a) interactive.296 -> PD_withDFF_4out 结果 **(注意修改为 Icp = Icp_total/4)** ：最佳 Je_rms_UI = 12.61m @ (400 Ohm, 18 pF, 450 uA)，仿真时间每组 14m 5.8s @ (4-thread, 9-job) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-19-16-03-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - (b) interactive.297 -> PD_4out 结果 **(注意修改为 Icp = Icp_total/4)** ：最佳 Je_rms_UI = 11.96m @ (800 Ohm, 6 pF, 450uA) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-19-16-05-24_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - (c) interactive.298 -> PD_withDFF_4out 但是仅使用前三个输出：最佳 Je_rms_UI = 13.00m @ (400 Ohm, 18 pF, 450 uA) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-19-16-07-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - (d) interactive.299 -> PD_withDFF_3out 结果：最佳 Je_rms_UI = 12.49m @ (800 Ohm, 6 pF, 450uA) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-19-16-08-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - (e) interactive.300 -> PD_3out 结果：最佳 Je_rms_UI = 12.17m @ (800 Ohm, 6 pF, 450uA) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-19-16-09-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 讨论：从数值结果可以看出，无论使用哪种 PD，一方面最佳 Je_rms_UI ≈ 12 mUI，另一方面环路参数的话是下面几个最佳：
        - (aa) point.18 -> (400 Ohm, 18 pF, 450 uA)
        - (bb) point.15 -> (400 Ohm, 12 pF, 450 uA)
        - (cc) point.21 -> (800 Ohm, 06 pF, 450 uA)
        - 这三组参数的抖动性能差距不大，我们还是使用 PD_withDFF_4out 模块，这样 (a) (b) (c) 三种输出都可以选


### 25.3 find best loop para.

使用 PD_withDFF_4out 模块扫描环路参数，结果如下：
- 按照肖师兄推荐参数范围进行仿真：
    - interactive.302
        - **time_end/data_pattern = 13/10**
        - dataRate = 14G
        - data_Je_rms_UI = 30m
        - **Jc_rms_UI = 3m**
        - k_vco = 200 MHz/V
        - R1 = {600, 800, 1000}
        - C1 = {22p, 30p, 40p}, C2 = C1/12
        - Icp_total = {400u, 600u, 800u}
    - 结果如图：
- 上面的抖动实在是过大，我们还是按照自己之前的仿真结果来尝试：
    - interactive.303
        - KVCO = 300 MHz/V
        - R1 = {300, 400, 600}
        - C1 = {10p, 14p, 22p}, C2 = C1/12
        - Icp_total = {300u, 400u, 600u}
    - 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-19-23-22-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 抖动范围在 Je_rms = 11.41 mUI ~ 16.12 mUI 之间，最佳组合为：
        - (1) (400 Ohm, 10 pF, 600 uA) -> 11.41 mUI
        - (2) (600 Ohm, 10 pF, 400 uA) -> 12.03 mUI
        - (3) (300 Ohm, 10 pF, 600 uA) -> 12.21 mUI
        - (4) (400 Ohm, 14 pF, 600 uA) -> 12.22 mUI
- 进一步尝试：
    - interactive.305/306 (306 是补 C1 = 6p, 因为 304 误设置为了 6 = 6p*1e12)
        - KVCO = 300 MHz/V
        - R1 = {300, 400, 600}
        - C1 = {6p, 8p, 10p, 14p}, C2 = C1/12
        - Icp_total = {400u, 600u, 800u}
    - 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-20-15-32-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 推荐参数为 (300/400 Ohm, 6p/8p/10p/14p, 600u/800u)，这些参数基本都能实现 **Je_rms_UI < 12 mUI (@ Jc_rms = 3 mUI)**
    - 三组最佳参数为：
        - (1) (300 Ohm, 08 pF, 800 uA) -> 11.16 mUI
        - (2) (400 Ohm, 08 pF, 600 uA) -> 11.29 mUI
        - (3) (300 Ohm, 10 pF, 800 uA) -> 11.32 mUI
- 后仿验证：
    - interactive.308.RO/309.RO
    - calibre of `Logic_std_2d0_200n_30n_PAM3_PDLogic_qR_Alxd_withDFF_4out_v3`
    - KVCO = 300 MHz/V
    - loop = {(300 Ohm, 8 pF, 800 uA), (400 Ohm, 10 pF, 600 uA)}
    - 结果如图：都没有什么问题 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-20-15-35-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- Jc_rms = 1 mUI 时的抖动验证 (后仿 PD)：
    - interactive.311
        - Jc_rms = 1.0 mUI
        - KVCO = 300 MHz/V
        - R1 = 300
        - C1 = 10p, C2 = C1/12
        - Icp_total = {200u, 400u, 600u, 800u, 1000u}
    - 结果如图：Icp_total = 600 uA 时性能最佳 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-20-16-24-08_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 低衰减、低相噪时的抖动验证 (后仿 PD)：
    - interactive.312
        - RC_timeConstant = **0.15**
        - Jc_rms = {0.5 mUI, 1 mUI}
        - KVCO = 300 MHz/V
        - R1 = 300
        - C1 = 10p, C2 = C1/12
        - Icp_total = {200u, 400u, 600u, 800u, 1000u}
    - 结果如图：在 RC_timeConstant = 0.15 @ Jc_rms = 0.5mUI/1.0mUI 时，最佳 Icp_pd_total 均低于 200 uA <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-20-17-21-55_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仅使用两对 PD 输出时的情况：
    - interactive.314
        - TB_3_PAM3_PD_2out_loop
        - NODFF<1:3> 的延迟最小，这里使用 **NODFF_UP/DN<1,3>**
        - RC_timeConstant = **0.2**
        - Jc_rms = 3.0 mUI
        - KVCO = 300 MHz/V
        - R1 = 300
        - C1 = 10p, C2 = C1/12
        - Icp_total = {100u, 200u, 400u, 600u, 800u, 1000u}
        - **注意修改 Icp = Icp_total/2**
    - 结果如图：I_cp_pd_total = 400 uA 性能最佳，低于 200 uA 时性能迅速恶化 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-20-17-30-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仅使用两对 PD 输出时，进一步验证：
    - 与导师这边沟通后，估计采用两个 PD CP，每个电流为 20u ~ 240u，两个就是 40u ~ 480u
    - interactive.315
        - TB_3_PAM3_PD_2out_loop
        - NODFF<1:3> 的延迟最小，这里使用 **NODFF_UP/DN<1,3>**
        - RC_timeConstant = **0.2**
        - Jc_rms = **1.0 mUI**
        - KVCO = 300 MHz/V
        - R1 = 300
        - C1 = 10p, C2 = C1/12
        - Icp_total = {480u 320u 200u 100u 60u 40u}
        - **注意修改 Icp = Icp_total/2**
    - 结果如图：200 uA 时性能最佳，低于 100 uA 时性能迅速恶化 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-20-17-59-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - VCTRL 和 FREQ_MHz 波形：没有什么问题 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-20-18-01-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 注：其实从 FREQ_MHz 波形上看，60uA/100uA/200uA 的性能都挺好，40 uA 的也还可以
    - 这个结果作为后面的主要参考结果。


### 25.4 layout of PD_withDFF_4out


`Logic_std_2d0_200n_30n_PAM3_PDLogic_qR_Alxd_withDFF_4out_v3` 版图和 PEX 结果如下：
- 版图效果：
- PEX 结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-19-18-00-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


上面 **24.3 find best loop para.** 一节已经得到最佳环路参数为 xxx，这里用 calibre of PD_withDFF_4out 后仿验证一下：


### 25.5 FD and lock detection

给环路加入 FD 和 lock detection，FD gain control 先不降速，复现之前结果后再降速：
- (1) 先尝试了 no lock -> locked -> deeplocked 的每个 PD CP 电流依次为 8 x Icp -> 2 x Icp -> 1 x Icp，发现每次 no lock 达到阈值进入到 locked 后，也许是电流下降太多导致性能降低？反正进入到 locked 后反而达不到阈值了。
- (2) 上面这个问题，仔细观察了一下 SH 输出情况，发现 SH 输出异常，如下图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-20-20-55-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 于是替换为了 Ideal_Sampler 重新进行仿真，发现错误出在 verilog 代码上：未实时更新 vth 这个错误只会导致 sampler_ideal 实际触发点发生偏移，在环路中无实际影响，但会导致单个 SH 单元出现异常，因为等价于它的上升沿左偏而下降沿右偏 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-20-21-53-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 已于 2026.04.20 21:56 更新两个模块 (>= interactive.327)
- interactive.327: 看看是否与 RC_timeConstant 有关
    - 设置 fc = 14 GHz 和 **RC_timeConstant = 0.05 (接近理想方波)**，然后 disable 掉 FD 模块，观察不同 pd 电流下的 LD_CNT_dec 情况 (time_end = 2^13)
    - 结果如图：
- interactive.328: 看看是否之前交换了 UP/DN 输入有关
    - 在 327 的基础上，**修改 CP 输入为 IN_UP = UP, IN_DN = DN 而不是原来那种反着的**
    - 结果如图：
        - 80 uA 时锁定前 (8 x 80u = 640u) 便可实现 LD_CNT_dec = 255：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-21-16-49-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
        - 320uA 时锁定前 (8 x 320u = 2560u) 抖动较大，但 LD_CNT_dec = 246 仍能正常锁定：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-21-16-53-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 破案了，还真的是之前错误地交换 UP/DN 信号所导致，交换之后 CK<6> 锁定在 edge of data，使得 14G 锁定之后 DAE<6> 和 DAE<6.5> 反而不同概率很大
- interactive.330: 
    - 在 interactive.328 的基础上，设置为 "正常" 情况，也即 RC_timeConstant = 0.2，fc = 13G/15G，然后 FD 开启。
    - 前面知道 CK Fast 时收敛较难，这里调整增益为 (slow = 34, fast = 32) -> (slow = 30, fast = 32)
    - 将三级 PD CP 电流 8 x Icp -> 2 x Icp -> 1 x Icp 改为 **2 x Icp -> 2 x Icp -> 1 x Icp**
    - 设置 Icp_total = {80u, 160u} 以及 time_end = 2^15，Icp_fd = 800 uA 保持不变 (CK slow 时约 200 ns/GHz，然后 CK fast 时约 300ns/GHz，容易在 14.5 GHz 附近徘徊，也许需要较大 PD CP 电流以帮助锁定？但是目前 kvco = 300 MHz/V，要想实现 0.5 GHz 的跨度，有些麻烦)
    - 结果如图：@ Icp_total = 80u (锁定前 PD = 160u, FD = 800u)，能完成 CK Fast 锁定，位于 14.5 GHz 时 SLOW 信号有 65ns 空闲片段：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-21-16-59-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- interactive.331: 验证长时间 (2^16，约 1.17 us) 内 CK Fast 是否能正常收敛并锁定
    - 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-22-00-47-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 结论：只有 (Icp_pd_total, Icp_fd) = (80u, 720u) 这一组因为运气好而在 1.0 us 时实现了锁定，其它的都没能在 1.17 us 内完成锁定
- interactive.332: 固定 FD_CP = 480 uA，验证 CK Fast 增益较大 (slow/fast gain = 30/48) 时，2^15 约 0.6 us 内 CK Fast 是否能正常收敛并锁定
    - 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-22-00-51-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 结论：只有 (Icp_pd_total, Icp_fd) = (80u, 480u) 这一组在 400 ns 时实现了锁定，其它的 (Icp_fd 更小) 都没能在 0.6 us 内完成锁定
- interactive.333: 在 332 的基础上 (固定 FD_CP = 480 uA)，选取不同的 PD CP 电流
    - 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-22-00-58-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 结论：除了 (Icp_pd_total, Icp_fd) = (160u, 480u) 这一组没能锁定，其它三组 (Icp_pd_total >= 240u) 都能在 0.6 us 内完成锁定

<!-- 在 KVCO = 300 MHz/V 情况下，我们还得注意 VCTRL 的波动范围，像 Icp_total = 1 mA 这种就有些太大了，很容易使 VCO 频繁产生频带切换，可能导致失锁。 -->

综合上面结果，我们知道：
- (1) CK Slow 锁定非常容易，锁定时间也非常短，没有任何问题
- (2) CK Fast 锁定相对较难（由 CK Slow 在 1/4 速率处的误码导致），在常规情况下 (slow/fast gain = 32/32) 锁定时间较长 (1 us 以上)，在 Fast 增益较高情况下 (slow/fast gain = 30/48) 一般能在 700 ns 以内完成锁定。
- (3) 有利于 CK Fast 锁定的措施：增大 Icp_pd_total、减小 slow gain、增大 fast gain



### 25.6 quarter-rate FD test (1) (wrong)

将 FD 降速到 quarter-rate (4 GHz) 进行验证 (使用 verilog 模块)：
- interactive.335
    - 5_TB_PAM3_PFD_DIV4_loop
    - RC_timeConstant = 0.4
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = 10p, C2 = C1/12
    - Icp_pd_total = {80u, 160u}
    - Icp_fd = {320u, 480u}
    - (fc, fd slow/fast gain) = {(13G, 30/32), (16G, 24/48)}
    - time_end = 2^16 = 1.17 us
- 仿真耗时：第一组 8h 34m 29s，第二组被手动取消
- 结果如图：
    - Icp_pd_total = 80u 时：四组中没有任何一组完成了锁定，甚至连两组 CK Slow 的都没能正确锁定 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-22-15-38-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - Icp_pd_total = 160u 时：

调整 RC，降低 FD gain 之后重新尝试：
- interactive.336
    - 5_TB_PAM3_PFD_DIV4_loop
    - RC_timeConstant = **0.2**
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = 10p, C2 = C1/12
    - Icp_pd_total = {120u, 180u}
    - Icp_fd = 250u
    - **(fc, fd slow/fast gain)** = 
        - (13.9G, 08/09)
        - (14.1G, 06/12)
    - LD_LEVEL_dec = 212
    - time_end = 2^15 = 0.6 us



### 25.7 quarter-rate FD test (2)

**注：上面 24.6 quarter-rate FD test (1) (wrong) 一节所使用的 5_TB_PAM3_PFD_DIV4_loop 是 "错误的"，这个原理图是从很早的 3_TB 复制而来，不仅 PD CP 输入不是两组，而且当时错误交换的 UP/DN 也还没有改回来。所以上一小节的结果均全部作废，这里在 6_TB_PAM3_PFD_DIV4_loop 重新进行仿真验证：**

将 FD 降速到 quarter-rate (4 GHz) 进行验证 (使用 verilog 模块)，记得适当降低 FD gain：
- interactive.337
    - 6_TB_PAM3_PFD_DIV4_loop
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = 10p, C2 = C1/12
    - Icp_pd_total = {120u, 180u}
    - Icp_fd = 250u
    - (fc, fd slow/fast gain) = 
        - (13.9G, 15/16)
        - (14.1G, 12/24)
    - LD_LEVEL_dec = 215
    - time_end = 2^15 = 0.6 us
- 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-22-19-00-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：起始频率 ±0.1 GHz 时，两侧均能正常锁定



搭建完 1/4 sub-sampling FD Logic 原理图后，配合 6-bit 1/4-sub-sampling (8-bit 时间窗口) lock detection 模块进行仿真验证：
- interactive.338: 验证 FD Logic 功能是否正常 (初始频率差距大时)
    - 6_TB_PAM3_PFD_DIV4_loop
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = 10p, C2 = C1/12
    - Icp_pd_total = 120u
    - Icp_fd = 250u
    - (fc, fd slow/fast gain) = 
        - (12.0G, 15/16)
        - (16.0G, 12/24)
    - LD_LEVEL_dec = 55/63 = 87.3%
    - time_end = 2^15 = 0.6 us
- 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-22-21-07-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：降为 quarter-rate 后 FD Logic 虽然增益减小但是功能正常，可以搭建完整电路。


这里中途设计了一个新的 pulse multiplier 模块，不用之前那种 pulse wider 了 (比较差)，现在这种是真正 "理想" 的 pulse multiplier，原理图和仿真结果如下：
- 原理图 `VA_PulseMultiplier_6bit`：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-22-21-37-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 低 DIN 密度仿真结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-22-21-36-28_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 高 DIN 密度仿真结果：**注意它只能在 OFF 时读取 DIN 输入**，如果需要在 ON 时也读取 DIN 输入，需要额外加电路，我们懒得加了 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-22-21-49-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


然后验证频率接近 14 GHz 时能否正常锁定：
- 注意这里将 pulse_wider 更换为了新版 pulse_multiplier **(注意它只能在 OFF 时读取 DIN 输入)**，以及使用的是 6-bit 1/4-sub-sampling lock detection 模块
- interactive.339: 验证频率接近 14 GHz 时能否正常锁定：
    - 7_TB_PAM3_actualPFDtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = 10p, C2 = C1/12
    - Icp_pd_total = 120u
    - Icp_fd = 250u
    - (fc, fd slow/fast gain) = 
        - (13.85G, 15/16)
        - (14.15G, 12/24)
    - LD_LEVEL_dec = 55/63 = 87.3%
    - time_end = 2^15 = 0.6 us
- 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-24-15-29-28_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：新版 pulse_multiplier 没有问题，14 GHz 附近可以正常锁定


进行长时间验证：
- interactive.340: 验证 1.17 us 内能否正常锁定
    - 7_TB_PAM3_actualPFDtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = 10p, C2 = C1/12
    - Icp_pd_total = 120u
    - Icp_fd = 250u
    - (fc, fd slow/fast gain) = 
        - (13.5G, 16/16)
        - (14.5G, 12/24)
    - LD_LEVEL_dec = 55/63 = 87.3%
    - time_end = 2^16 = 1.17 us
- Testbench 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-23-15-56-54_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-24-15-32-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：初始频率 ± 0.5 GHz 时，在 1 us 左右能够正常锁定，没有问题



### 25.8 6-bit UP counter

原理图和仿真结果如下：
- 1-bit 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-22-23-25-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 8-bit 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-22-23-25-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 8G ~ 14G 仿真结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-22-23-26-50_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 14G ~ 24G 仿真结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-23-03-31-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 上图看出 **前仿能覆盖 14 GHz 但不能覆盖 16 GHz** ，预计后仿能覆盖 7 GHz (只能使用 1/4 sub-sampling)

版图和 PEX 结果如下：
- 版图效果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-23-18-12-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- PEX 结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-23-18-08-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 2G ~ 9G 后仿结果：后仿能覆盖 9 GHz，没有问题 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-23-18-29-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



### 25.9 layout of FD Logic

完整 FD Logic (with gain control) 如下：
- 版图效果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-03-17-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- PEX 结果 `Logic_std_2d0_200n_30n_PAM3_FDLogic_qR_BiD_qR_v1`：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-23-20-34-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>

``` bash
DH<0> DL<0> DH<1> DL<1> 
DH<1> DL<1> DH<2> DL<2> 

DH<2:0>,DH<3:1>,DH<4:2>,DH<5:3>,DH<6:4>,DH<7:5>
DL<2:0>,DL<3:1>,DL<4:2>,DL<5:3>,DL<6:4>,DL<7:5>

Logic_std_2d0_200n_30n_PAM3_FDLogic_qR_ckSlow_baseUnit
Logic_std_2d0_200n_30n_PAM3_FDLogic_qR_ckSlow_v2_20260422

Logic_std_2d0_200n_30n_XNOR_x2
VA_LogicBit2_XNOR
LogicBit2_std_2d0_200n_30n_XNOR_x2

VA_CDR_PAM3_LockDetection_6bit_halfRate

DATA_H DATA_L DOFS_H DOFS_L
buf_DATA_H buf_DATA_L buf_DOFS_H buf_DOFS_L
div2_DATA_H div2_DATA_L div2_DOFS_H div2_DOFS_L
div4_DATA_H div4_DATA_L div4_DOFS_H div4_DOFS_L

buf_DATA_H,buf_DATA_L,buf_DOFS_H,buf_DOFS_L
div2_DATA_H,div2_DATA_L,div2_DOFS_H,div2_DOFS_L
div4_DATA_H,div4_DATA_L,div4_DOFS_H,div4_DOFS_L
```



前仿验证完整 FD Logic 是否正常：
- interactive.341: 前仿验证完整 FD Logic 是否正常 `202602_CDR__FDLogic_BiD_div4_gainControl_v1`
    - 7_TB_PAM3_actualPFDtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = 10p, C2 = C1/12
    - Icp_pd_total = 120u
    - Icp_fd = 250u
    - (fc, fd slow/fast gain) = 
        - (13.5G, 16/16)
        - (14.5G, 12/24)
    - LD_LEVEL_dec = 55/63 = 87.3%
    - time_end = 2^15 = 0.58 us
- 结果如图：（仿真结果没来得及整理就被覆盖了）
- 结论：没有什么问题，增益虽然小了些但整体功能正常



## 26. Design of Lock Detector

### 26.1 8-bit magnitude comparator

虽然 lock detector 只用到 6-bit counter，但我们这里仍搭一个 8-bit magnitude comparator，以后用到时就不用再搭了。
- 参考链接：[TI > 8-bit magnitude comparator](https://www.ti.com/lit/ds/symlink/sn74ls688.pdf?ts=1776671143427&ref_url=https%253A%252F%252Fcn.bing.com%252F)
- 参考图片：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-24-00-21-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.jpg"/></div>
- 搭建的原理图：
- 前仿结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-24-01-06-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 版图效果：
- PEX 结果：


### 26.2 pre-sim test

代入实际 6-bit 1/4-sub-sampling lock detector 模块进行仿真，验证是否正常工作：
- interactive.348: 验证 lock detector 模块
    - 8_TB_PAM3_FDtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = 10p, C2 = C1/12
    - Icp_pd_total = 120u
    - Icp_fd = 250u
    - (fc, fd slow/fast gain) = 
        - (13.85G, 14/14)
        - (14.00G, 16/16)
        - (14.15G, 10/26)
    - LD_LEVEL_dec = 55/63 = 87.3%
    - time_end = 2^15 = 0.58 us
- 仿真耗时 (10-thread @ 3-job)： **0.58 us 仿真耗时从原来的 4h 左右降到了 50 min** ！！！是因为实际模块前仿比 verilog 模型快得多吗？
- 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-02-56-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：CK_LD 的脉冲宽度为 4 GHz，但是中间空闲宽度达到 256 个 4 GHz 宽，ETSPC DFF (dynamic) 无法正常工作，需要更换为 static DFF；另外 flag_deeplk 这边用到的 2-bit UP counter 也需换为静态的。

``` bash
Logic_std_2d0_200n_30n_PAM3_LockDetection_6bit_v1_dffError
Logic_std_2d0_200n_30n_Counter_static_UP_EN_synRst_HS6A_1bit
```


换为静态 DFF 之后重新仿真验证：
- interactive.351: 重新验证 lock detector 模块
    - 8_TB_PAM3_FDtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = 10p, C2 = C1/12
    - Icp_pd_total = 120u
    - Icp_fd = 250u
    - (fc, fd slow/fast gain) = 
        - (13.85G, 14/14)
        - (14.00G, 16/16)
        - (14.15G, 10/26)
    - LD_LEVEL_dec = 55/63 = 87.3%
    - time_end = 2^15 = 0.58 us
- 仿真耗时 (10-thread @ 3-job)：
- 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-03-07-32_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- LD_CNT_dec 波形细节：注意这里出现的 "异常" 是 verilog 模块计算错误导致的，从 magnitude comparator 的比较结果可以看出计数器输出其实是正常的 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-03-10-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：lock detector 模块没有问题



反正现在仿真很快，不妨再仿一下四个不同起始频率看看锁定情况：
- interactive.351: 不同起始频率锁定验证
    - 8_TB_PAM3_FDtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = 10p, C2 = C1/12
    - Icp_pd_total = 120u
    - Icp_fd = 250u
    - (fc, fd slow/fast gain) = 
        - (12G, 14/14)
        - (13G, 14/14)
        - (15G, 12/24)
        - (16G, 12/24)
    - LD_LEVEL_dec = 55/63 = 87.3%
    - time_end = 2^17 = 2.34 us
- 仿真耗时 (10-thread @ 3-job)：每组 2h 32m 32s
- 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-03-05-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：双向频锁没有任何问题，完全可以正常工作



### 26.3 layout of lock detector

完整 6-bit 1/4-sub-sampling lock detector 如下：
- 版图效果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-03-00-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- PEX 结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-03-00-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


``` bash
Logic_std_2d0_200n_30n_PAM3_LockDetection_6bit_quarterRate_v2
```




### 26.4 complete post-sim

现在，PD/FD/LK 三个模块都已经搭完版图了，可以全部使用 calibre 进行后仿验证：
- interactive.355: PFD + LK 后仿验证
    - 9_TB_PAM3_PFDLKtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = 10p, C2 = C1/12
    - Icp_pd_total = 120u
    - Icp_fd = 250u
    - (fc, fd slow/fast gain) = 
        - (13.00G, 16/16)
        - (13.50G, 16/16)
        - (13.90G, 16/16)
        - (14.10G, 10/26)
        - (14.50G, 10/26)
        - (15.00G, 10/26)
    - LD_LEVEL_dec = 55/63 = 87.3%
    - time_end = 2^17 = 2.34 us
- config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-04-15-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真耗时 (10-thread @ 3-job)：第一组 5h 25m 41s，第二组 7h 10m 2s
- 结果如图：
    - 时钟频率与锁定情况：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-22-43-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 时钟眼图与抖动分布：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-22-53-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 锁定后抖动结果如图：Je_rms = 6.5 mUI ~ 10.0 mUI @ Jc_rms = 1 mUI <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-22-45-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 初始频差与锁定时间：初始频差较小时 300 ns 内锁定，初始 13 GHz 在 2us 内锁定，初始 15 GHz 在 1.2 us 内锁定 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-22-57-44_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：后仿验证没有任何问题，可以放心进行下一步




## 27. CP Test (2)

2026.04.25 (周六) 拿到了导师提供的 CP_forPD 和 CP_forFD：
- PDCD 这边有 12 档电流可调，然后两个输出模式 (一个是 x10uA，另一个是 x20uA)；也就是低电流模式下 10u ~ 120u，高电流模式下 20u ~ 240u
- FDCP 这边有 12 档电流可调，仅一种输出模式 (x60 uA)，也就是 60u ~ 720u
- **我们需要搭建 Bin_to_Therm 转换模块，用于输出电流大小的控制，这样可以从总的 24-bit 缩减为 4-bit。**


### 27.1 pre-sim test

先跑着前仿，跑的过程中我们就可以来搭 Bin_to_Therm converter，或者同步去验证 VCO 那边。十二档电流控制这边先手动给一下：
- FDCP 设置为第 4 档，也即 4 x 60u = 240u
- PDCP 设置为第 6 档，也即锁定前 6 x (20u + 20u) = 240u，锁定后 6 x (10u + 10u) = 120u
- interactive.359: 实际 CP 仿真验证
    - 10_TB_PAM3_CPtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = 10p, C2 = C1/12
    - Icp_pd_total = 120u (第 6 档)
    - Icp_fd = 240u (第 4 档)
    - (fc, fd slow/fast gain) = 
        - (13.90G, 16/16)
        - (14.00G, 16/16)
        - (14.10G, 10/26)
    - LD_LEVEL_dec = 55/63 = 87.3%
    - time_end = 2^16 = 1.17 us
    - 10-thread @ 3-job
- Testbench 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-19-07-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真耗时：
- 仿真结果 (10-thread @ 3-job)：
    - 时钟频率与锁定情况：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-23-41-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 时钟眼图与抖动分布：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-23-46-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：仿真精度不知道为什么明显变低 (是实际 CP 模块引起的吗？)，导致整个仿真结论出问题，三个点中仅有一个点完成了正常锁定


于是更换为 Spectre X + CX 重新进行仿真，但是却出现了如下报错：

``` bash
~~~~~~~~~~~~~~~~~~~~~~
Pre-Simulation Summary
~~~~~~~~~~~~~~~~~~~~~~
   -   (Spectre X) Multi-threading. The recommended number of threads is [2, 4], consider adding +mt=2 or +mt=4 on command line.
~~~~~~~~~~~~~~~~~~~~~~

Notice from spectre during transient analysis `tran'.
    Specified 'noisefmin' is smaller than 1/stop time. 'noisefmin' has been changed to 1.70898 MHz.


*****************************************************
Transient Analysis `tran': time = (0 s -> 585.143 ns)
*****************************************************

Opening the PSFXL file ../psf/tran.tran.tran ...
Important parameter values:
    start = 0 s
    outputstart = 0 s
    stop = 585.143 ns
    step = 585.143 ps
    maxstep = 5.85143 ns
    ic = all
    useprevic = no
    skipdc = yes
    reltol = 100e-06
    abstol(V) = 1 uV
    abstol(I) = 1 pA
    temp = 27 C
    tnom = 27 C
    tempeffects = all
    errpreset = conservative_sigglobal
    method = gear2only
    lteratio = 10
    relref = sigglobal
    cmin = 0 F
    gmin = 1 pS
    rabsshort = 1 mOhm
    trannoisemethod = default
    noisefmax = 50 GHz
    noisefmin = 1.70898 MHz
    noiseseed = 1


Output and IC/nodeset summary:
                 save   46      (current)
                 save   2768    (voltage)
                 save   1       (unitless)


Warning from spectre at time = 1.59619 ps during transient analysis `tran'.
    WARNING (CMI-2752): I481.I0.M0: Vgs(=993.018 mV) has exceeded vgs_max(=990 mV). Check and update the settings of the SOA-related model parameters and terminal bias of the instance
    WARNING (CMI-2753): I481.I0.M0: Vgb(=993.018 mV) has exceeded vgb_max(=990 mV). Check and update the settings of the SOA-related model parameters and terminal bias of the instance
    WARNING (CMI-2754): I481.I0.M0: Vgd(=999.253 mV) has exceeded vgd_max(=990 mV). Check and update the settings of the SOA-related model parameters and terminal bias of the instance
Warning from spectre at time = 2.50163 ps during transient analysis `tran'.
    WARNING (CMI-2754): I481.I0.M3: Vgd(=1.0061 V) has exceeded vgd_max(=990 mV). Check and update the settings of the SOA-related model parameters and terminal bias of the instance
        Further occurrences of this warning will be suppressed.

    tran: time = 12.05 ps   (2.06 m%), step = 759.3 fs     (130 u%)
    tran: time = 19.67 ps   (3.36 m%), step = 10.96 fs    (1.87 u%)
    tran: time = 20.73 ps   (3.54 m%), step = 9.822 fs    (1.68 u%)
    tran: time = 22.89 ps   (3.91 m%), step = 1.676 fs     (286 n%)
    tran: time = 25.68 ps   (4.39 m%), step = 250.1 as    (42.7 n%)
    tran: time = 25.68 ps   (4.39 m%), step = 104.6e-21 s (17.9 p%)
    ......
    tran: time = 25.68 ps   (4.39 m%), step = 50.43e-21 s (8.62 p%)
    tran: time = 25.68 ps   (4.39 m%), step = 42.56e-21 s (7.27 p%)
    tran: time = 25.68 ps   (4.39 m%), step = 27.87e-21 s (4.76 p%)
    tran: time = 25.68 ps   (4.39 m%), step = 66.55e-21 s (11.4 p%)
    tran: time = 25.68 ps   (4.39 m%), step = 26.07e-21 s (4.46 p%)

Error found by spectre at time = 25.6787 ps during transient analysis `tran'.
    ERROR (SPECTRE-16928): Cannot run the simulation because transient analysis has reached the maximum number of times allowed to approach minstep (within 5% of stop time or 5 us, whichever is less).
        Use the `max_approach_minstep' option to change the maximum number of times allowed to approach minstep and rerun the simulation.


The following set of suggestions might help you avoid convergence difficulties.  

 1. Enable diagnostic messages using the `+diagnose' option.

 2. Evaluate and resolve any notice, warning, or error messages.
 3. Use realistic device models. Check all component parameters, particularly nonlinear device model parameters, to ensure that they are reasonable.
 4. Small floating resistors connected to high impedance nodes can cause convergence difficulties. Avoid very small floating resistors, particularly small parasitic resistors in semiconductors. Instead, use voltage sources or iprobes to measure current.
 5. Ensure that a complete set of parasitic capacitors is used on nonlinear devices to avoid jumps in the solution waveforms. On MOS models, specify nonzero source and drain areas.
 6. Perform sanity check on the parameter values by using the parameter range checker (use ``+param param-limits-file'' as a command line argument) and heed any warnings.  Print the minimum and maximum parameter value by using `info' analysis.  Ensure that the bounds given for instance, model, output, temperature-dependent, and operating-point (if possible) parameters are reasonable.

 7. Check the direction of both independent and dependent current sources. Convergence problems might result if current sources are connected such that they force current backward through diodes.
 8. Use the `cmin' parameter to install a small capacitor from every node in the circuit to ground.  This usually eliminates any jump in the solution.
 9. Loosen tolerances, particularly absolute tolerances like `iabstol' (on options statement). If tolerances are set too tight, they might preclude convergence.
10. Try to simplify the nonlinear component models to avoid regions that might contribute to convergence problems in the model.

Analysis `tran' was terminated prematurely due to an error.

Notice from spectre.
    2258 warnings suppressed.

finalTimeOP: writing operating point information to rawfile.

Opening the PSF file ../psf/finalTimeOP.info ...
Trying Fast DC 0.

Notice from spectre during DC analysis, during info `finalTimeOP'.
    Bad pivoting is found during DC analysis. Option dc_pivot_check=yes is recommended for possible improvement of convergence.
Warning from spectre during DC analysis, during info `finalTimeOP'.
    WARNING (CMI-2751): I208.I7<0>.I3.I0<2>.I1.I5.M3: Vds(=-1.09649 V) has exceeded vds_max(=990 mV). Check and update the settings of the SOA-related model parameters and terminal bias of the instance
    WARNING (CMI-2755): I208.I7<0>.I3.I0<2>.I1.I5.M3: Vbd(=1.09649 V) has exceeded vbd_max(=990 mV). Check and update the settings of the SOA-related model parameters and terminal bias of the instance
        Further occurrences of this warning will be suppressed.

DC simulation time: CPU = 22.2589 s, elapsed = 2.81806 s.

Notice from spectre.
    13404 warnings suppressed.

modelParameter: writing model parameter values to rawfile.

Opening the PSF file ../psf/modelParameter.info ...
element: writing instance parameter values to rawfile.

Opening the PSF file ../psf/element.info ...
outputParameter: writing output parameter values to rawfile.

Opening the PSF file ../psf/outputParameter.info ...
designParamVals: writing netlist parameters to rawfile.

Opening the PSFASCII file ../psf/designParamVals.info ...
primitives: writing primitives to rawfile.

Opening the PSFASCII file ../psf/primitives.info.primitives ...
subckts: writing subcircuits to rawfile.

Opening the PSFASCII file ../psf/subckts.info.subckts ...
Licensing Information:
Lic Summary:
[23:43:52.001304] cdslmd servers: centos7
[23:43:52.001304] Feature usage summary:
[23:43:52.016536]  spectre_X_cpu_accelerator  
[23:43:52.512111]   spectre_X_sc  


Aggregate audit (11:43:52 PM, Sat Apr 25, 2026):
Time used: CPU = 608 s (10m  8.4s), elapsed = 85.7 s (1m  25.7s), util. = 710%.
Time spent in licensing: elapsed = 508 ms.
Peak memory used = 561 Mbytes.
Simulation started at: 11:42:26 PM, Sat Apr 25, 2026, ended at: 11:43:52 PM, Sat Apr 25, 2026, with elapsed time (wall clock): 85.7 s (1m  25.7s).
spectre completes with 1 error, 61 warnings, and 16 notices.

```

具体原因未知，又试了下所有模块都用 calibre，是可以正常仿真的：
- config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-00-40-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 部分仿真日志：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-00-40-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>

但是这样仿真时间太长了，一个小时竟然只仿了不到 0.7%，显然不行。




### 27.2 post-sim test

于是又回到 Spectre FX + AX，试试仅 CP 使用 calibre 而其它模块均前仿：
- interactive.362: 实际 CP 仿真验证
    - 10_TB_PAM3_CPtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 300 MHz/V
    - R1 = 300
    - C1 = {10p, 15p, 20p}, C2 = C1/12
    - Icp_pd_total = 100u (X5 档)
    - Icp_fd = 240u (X4 档)
    - (fc, fd slow/fast gain) = (14.05G, **14/14**)
    - LD_LEVEL_dec = 53/63 = 84.1%
    - time_end = 2^15 = 1.17 us
    - 10-thread @ 3-job
- 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-04-13-16_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 时钟波形：时钟波形没啥问题 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-04-14-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：三种电容取值都锁定失败了，无奈修改 slow/fast gain 再仿一次



- interactive.363: 实际 CP 仿真验证
    - 10_TB_PAM3_CPtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = **500 MHz/V**
    - R1 = 250
    - C1 = 15p, C2 = C1/12
    - Icp_pd_total = 100u (X5 档)
    - Icp_fd = 240u (X4 档)
    - (fc, fd slow/fast gain)
        - (13.85G, 14/14)
        - (14.00G, 14/14)
        - (14.15G, 10/24)
    - LD_LEVEL_dec = 53/63 = 84.1%
    - time_end = 2^15 = 0.58 us
    - 10-thread @ 3-job
- 结果如图：



- interactive.364: 长时间仿真验证
    - 10_TB_PAM3_CPtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = **500 MHz/V**
    - R1 = 250
    - C1 = 15p, C2 = C1/12
    - Icp_pd_total = 100u (X5 档)
    - Icp_fd = 240u (X4 档)
    - (fc, fd slow/fast gain)
        - (13.5G, 14/14)
        - (14.1G, 10/24)
        - (14.5G, 10/24)
    - LD_LEVEL_dec = 53/63 = 84.1%
    - time_end = 2^16 = 1.17 us
    - 10-thread @ 3-job
- 结果如图：
- 结论：锁定失败，原因是 我们这边之前是用理想 CP + VCO 来仿（行为级 VCO 输入电压范围无限以实现大频率范围），换成实际 CP 后，控制电压范围是有限定范围的，必须配合 LPF RST 电路仿才行。昨晚仿的压根没有频带切换，而且设置的初始频差比 kvco 大，所以 VCO 频率根本过不去。
- 此次仿真作废，调整初始频差后重新仿真做验证：



- interactive.367: 长时间仿真验证
    - 10_TB_PAM3_CPtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = **600 MHz/V**
    - R1 = 250
    - C1 = 15p, C2 = C1/15
    - Icp_pd_total = 60u (X3 档)
    - Icp_fd = 180u (X3 档)
    - (fc, fd slow/fast gain)
        - (13.8G, 32/10)
        - (14.0G, 16/16)
        - (14.2G, 10/32)
    - LD_LEVEL_dec = 51/63 = 80.95%
    - time_end = 2^16 = 1.17 us
    - 10-thread @ 3-job
- 结果如下：
    - 时钟频率与锁定情况：
        - "锁定后" 的 freq_t 波动明明只有 30 MHz，比之前理想 CP 仿真时的 60 MHz 还小 (因为使用了更小的 CP 电流)，可为什么仍出现失锁情况？
    - 考察 13.8G 这一组的详细波形：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-22-32-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
        - 从时钟-数据时序关系来看，似乎 CK<6> 对齐了数据边沿而不是 CK<7>（0/2/4/6 是数据，1/3/5/7 是边沿），所以初步怀疑是 PD CP 这边 UP/DN 信号反了
        - 可我之前检查过挺多遍，应该没有问题才对？而且设置初始频率为 14G 的这一组，锁定后是正常的，不会出现失锁，如果 UP/DN 信号反了这一组应该也失锁才对。
    - 考察 14.0G 这一组的详细波形：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-22-45-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 上图可以看出，14.0G 这一组结果，就是正常 CK<7> 对齐数据边沿，诶我去这就奇怪了啊。
    - 排除了 CP 这边 VCM 的问题 (电容电压和输出电压基本一致)
    - 单独仿仿 CP，看看是不是 CP 这边的输入与输出不对应：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-23-12-07_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 上图可以知道 CP 这边输入输出对应关系是对的，没有问题啊。
    - 看一下 14 GHz 这一组的 PD 输入输出：是正常的 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-23-56-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 看一下 14 GHz 这一组从采样到 PD 输出的流程：是正常的。从 CK<6> 采样，经过 125 ps 得到 aligned DATA，经过 200 ps 得到 PD 输入 (pd_DATA) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-00-02-27_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 看一下 13.8 GHz 这一组从采样到 PD 输出的流程：也是正常的。<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-00-19-44_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 仔细观察发现，这一段时间里几乎一直保持了 (UP, DN) = (1, 0)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-00-22-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 那么答案似乎就呼之欲出了：FD CP 这边关闭后，存在明显漏电流。


给 FD CP 这边加一个开关，构成 `202602_CDR__CPs_v2_withSW` 进行仿真验证：
- interactive.368: `202602_CDR__CPs_v2_withSW` 仿真验证
    - 10_TB_PAM3_CPtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 600 MHz/V
    - R1 = 250
    - C1 = 15p, C2 = C1/15
    - Icp_pd_total = 60u (X3 档)
    - Icp_fd = 180u (X3 档)
    - (fc, fd slow/fast gain)
        - (13.9G, 32/10)
        - (14.0G, 16/16)
        - (14.1G, 10/48)
    - LD_LEVEL_dec = 51/63 = 80.95%
    - time_end = 2^16 = 1.17 us
    - 10-thread @ 3-job
- 结果如图：
- 结论：
    - (1) 14.1 GHz 这一组，在每次 flag_deeplk 之后电流不够大 (相比漏电流，此时 VCTR 约为 380 mV)，导致不断重复循环 "锁定 -> flag_deeplk = 1 -> 失锁"
    - (2) 其它两组倒是正常锁定了



``` bash
Logic_std_2d0_200n_30n_Dummy_moscap_momcapM2M8_x32_v2
```


<!-- - interactive.369: `202602_CDR__CPs_v2_withSW` 仿真验证 ()
    - 10_TB_PAM3_CPtest
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 600 MHz/V
    - R1 = 250
    - C1 = 15p, C2 = C1/15
    - Icp_pd_total = 100u (X5 档)
    - Icp_fd = 180u (X3 档)
    - (fc, fd slow/fast gain)
        - (14.1G, 10/48)
        - (14.2G, 10/48)
        - (14.3G, 10/48)
    - LD_LEVEL_dec = 51/63 = 80.95%
    - time_end = 2^16 = 1.17 us
    - 10-thread @ 3-job
- 结果如下： -->



### 27.2 Bin_to_Therm converter

关于 Bin_to_Therm 如何实现，我们考虑用 "Bin_to_Line + Line_to_Therm" 来做，具体思路如下：
- 利用 2-bit Bin_to_Line 构成 3-bit Bin_to_Line：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-21-12-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.jpg"/></div>
- 利用 Bin_to_Line + Line_to_Therm 构成 Bin_to_Therm：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-21-14-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div> 来自 [A Note On The Binary to Thermometer Code Decoder](https://www.diyaudio.com/community/threads/a-note-on-the-binary-to-thermometer-code-decoder.408621/)


直接先构建 3-bit Bin_to_Line converter，抄 74HC138 的原理图：
- 参考原理图： [3-8 线译码器/多路分解器 74HC138](http://www.lensemi.cn/DataSheets/IC/74HC138.pdf) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-02-41-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 我们的原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-05-48-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真验证：没有问题 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-03-36-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


然后搭建 3-bit Line_to_Therm converter，使用 AND 来做，思路如下：
- 思路：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-03-32-45_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.jpg"/></div>
- 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-03-36-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真验证：没有问题 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-04-17-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


``` bash
  VT("/T<0>")
+ VT("/T<1>")
+ VT("/T<2>")
+ VT("/T<3>")
+ VT("/T<4>")
+ VT("/T<5>")
+ VT("/T<6>")
+ VT("/T<7>")

Logic_std_2d0_200n_30n_Converter_Bin_to_Therm_EN_3bit_v2_twoEN


  VT("/T<0>")
+ VT("/T<1>")
+ VT("/T<2>")
+ VT("/T<3>")
+ VT("/T<4>")
+ VT("/T<5>")
+ VT("/T<6>")
+ VT("/T<7>")
+ VT("/T<8>")
+ VT("/T<9>")
+ VT("/T<10>")
+ VT("/T<11>")
+ VT("/T<12>")
+ VT("/T<13>")
+ VT("/T<14>")
+ VT("/T<15>")
```


最后搭建 4-bit Bin_to_Therm 模块，如下：
- 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-05-53-50_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真验证：没有问题 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-05-55-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



### 27.3 loop test 


FDCP 输出路径加开关后，CP 漏电流问题得到缓解，但仍然存在。我们在每个 PDCP cell 输出路径上也加开关后进行验证：

- interactive.376: 在 CK Fast 下验证 `202602_CDR__CPs_v3_swPD`
    - 11_TB_CPwithB2T
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 800 MHz/V
    - R1 = 250
    - C1 = 20p, C2 = C1/20
    - EN_PD_num = {3, 5, 7} -> {60uA, 100 uA, 140 uA}
    - EN_FD_dec = 3 -> 180 uA
    - (fc, fd slow/fast gain) = (14.15G, 10/48)
    - LD_LEVEL_dec = 51/63 = 80.95%
    - time_end = 2^15 = 0.58 us
    - 10-thread @ 3-job 
- 结果如图：

尝试 uhvt 开关：
- interactive.377: 在 CK Fast 下验证 `202602_CDR__CPs_v4_uhvtSW`
    - 11_TB_CPwithB2T
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 600 MHz/V
    - R1 = 250
    - C1 = 20p, C2 = C1/20
    - EN_PD_num = 3 -> 60 uA
    - EN_FD_dec = 3 -> 180 uA
    - (fc, fd slow/fast gain) = (14.10G, 10/48)
    - LD_LEVEL_dec = 51/63 = 80.95%
    - time_end = 2^15 = 0.58 us
    - 10-thread @ 3-job 
- 结果如图：

更改参数再次验证：
- interactive.377: 在 CK Fast 下验证 `202602_CDR__CPs_v5_onlyFDsw`
    - 11_TB_CPwithB2T
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 700 MHz/V
    - R1 = 250
    - C1 = 20p, C2 = C1/20
    - EN_PD_num = 4 -> 80 uA
    - EN_FD_dec = 3 -> 180 uA
    - (fc, fd slow/fast gain) =
        - (13.8G, 32/10)
        - (13.9G, 32/10)
        - (14.0G, 04/48)
        - (14.1G, 04/48)
    - LD_LEVEL_dec = 51/63 = 80.95%
    - time_end = 2^15 = 0.58 us
    - 10-thread @ 3-job 
- 结果如图：

### 27.4 CP test

单独仿真 FD CP 这边，效果如下：
- 202602_CDR__CPs_v1_initial: 输出路径无 SW
- 202602_CDR__CPs_v2_withSW_schematic: 仅 FD 路径上有 std sw (x16)
- 202602_CDR__CPs_v3_swPD_schematic: FD 和 PD 路径上都有 std sw
- 202602_CDR__CPs_v5_onlyFDsw_schematic: 仅 FD 路径上有 uhvt sw (x08)
- 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-18-48-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 结论：
        - (1) 不要用 uhvt SW
        - (2) 一个加 TG 有利于输出电流整型
- 202602_CDR__CPs_v6_onlyFDstdSW_schematic: 仅 FD 路径上有 std sw (x48) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-19-12-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 结论：

``` bash
202602_CDR__CPs_v1_initial_schematic 202602_CDR__CPs_v2_withSW_schematic 202602_CDR__CPs_v3_swPD_schematic 202602_CDR__CPs_v5_onlyFDsw_schematic
```

上面仿的都是 20 uA 模式，仿个 10 uA 模式试试：看过了也没有问题。




### 27.5 APS sim veri.

2026.04.28 23:45，经过一系列杂七杂八的尝试与验证，确定应该是 Spectre FX 仿真精度过低导致的，因为我们替换为 APS 后仿真就完全正常了：
- interactive.384.RO:
    - 12_TB_findLeakage
    - 202602_CDR__CPs_v5_onlyFDsw
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 700 MHz/V
    - R1 = 250
    - C1 = 20p, C2 = C1/20
    - EN_PD_num = {4, 7, 10} -> {80 uA, 140 uA, 200 uA}
    - EN_FD_dec = 3 -> 180 uA
    - (fc, fd slow/fast gain) = (14.1G, 04/48)
    - LD_LEVEL_dec = 51/63 = 80.95%
    - time_end = 2^15 = 0.58 us
    - 10-thread @ 3-job 
- 仿真耗时：5h 57m 52s
- 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-03-28-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：结果终于是正常了，一块大石头落下
- 初始频率为 14.1G @ EN_PD_num = 4 的这一组详细结果如下：虽然还是有 UP > DN，但总归是正常锁定着？ <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-03-30-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


## 28. VCO Test

### 28.1 LPF_rst module

肖师兄这边没有提供 LPF rst 模块，需要我们自己实现一个。
- 第一种方案是 DAC 提供预期复位后电压，但现有 DAC 输出电阻 10 kOhm，如果是 20 pF 电容，时间常数就达到 200 ns 过大，不能接受
- 第二种方案如图：采用 2-bit trimming 控制预期复位后电压，R_unit 取值在 50Ohm ~ 100Ohm 左右 (没算 TG)，这样输出电阻为 2R||2R = R = 50Ohm ~ 100 Ohm，时间常数在 1ns ~ 2ns 之间，存在可实现性


### 28.2 VCO pre-sim test

2026.04.24 从肖师兄那边拿到了带 8-bit 频带控制的 VCO，接口说明如下：
``` bash
DAC 电压调高一点，DAC_INB<7:0> = <1111,1111>，DAC_VREF = VDD（建议 VB_IC = 500 mV）
IB 30uA for 滞回比较器，响应快建议 80u ~ 100u（建议 100 uA）
DISC_LPF 是输出的复位脉冲
VC_I 是 C1 端电压
IOUT_CCO 指示偏置电流大小的电压量
8-bit 频带控制和初始频率设置，给前 8-bit 即可
```


进行前仿验证时，按照肖师兄建议，除正常连接外，在每相时钟输出上挂 40 fF 电容负载。搭建 test bench 如下：
- Testbench 原理图：
- Testbench 仿真设置：
    - VCTRL 接二阶 LPF 的总电压 (R1 上面)
    - VC1 接二阶 LPF 的 C1 电压
    - VREF_DAC 接 VDD
    - VREF_0V25 接 0.20 V = 18.2% of VDD (由 DAC 提供, DIN_dec = 46)
    - VREF_0V75 接 0.65 V = 59.0% of VDD (由 DAC 提供, DIN_dec = 150)
- LPF_RST 模块：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-21-23-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 详细仿真设置与仿真结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-21-22-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：
    - (1) DAC_IN_dec: 首先是不能太小，否则 CCO 不正常工作；增大 DAC_IN_dec 会使：
        - 相同频带序号下的频率升高
        - kvco 降低 (DAC_IN_dec = 128 对应 kvco = 1.2 GHz/V)，断代可能性增大
    - (2) 当前 LPF_RST 模块在 500ps 脉宽下不足以完成复位 (在直接接 VSS 时只能使电容电压降低 delta = 200 mV)，需要进一步延长脉宽。

将复位脉冲增大至 1.17ns @ pre-sim 后 (202602_CDR__LPF_rst_v2_withPulseWider)，设置和结果如下：
- 初始频带 CN_INI_dec = 14/255 
- LPF 复位电压 D_LPF_VRST_dec = 0
- 比较器参考电压 = 0.20V/0.70V
- 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-02-26-55_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- DAC_IN_dec = 128 和 160 详细结果图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-02-37-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：
    - (1) 目前前仿结果下 (VCO 配合 LPF_v2)，电压只能从 0.75 V 复位到 0.3V (复位电压 = 0V, 前仿脉宽 1.17ns) ，此时 DAC_IN_dec 不应高于 160 (160 已经出现断带)。
    - (2) VCO 输出频率超过 15 GHz 时，抖动恶化明显


VCO PEX 结果如下：
- `CCO_LOGIC_DAC_FOR_DY` PEX 结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-02-50-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


### 28.3 pulse_wider


参考下图实现 pos/neg-edge detection：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-25-23-53-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>

然后配合 SR-Latch 和延迟单元进一步实现 pulse_wider.


### 28.3 VCO post-sim test

后仿 VCO 结果：
- interactive.12：验证了 DAC_IN_dec = 128/140/152 下无法正常工作 (LPF_RST 信号恒为高)，详细设置如图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-04-25-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- interactive.13：进一步考察发现，似乎是我们的 pulse_wider 电路在上电后，SR-Latch 初始状态就为高导致的工作状态异常 (换为 LPF_v1 仿真后验证了这一观点)。为修正这个错误，除了加 RST 输入外，我们有一种更好的方法是：之前仅利用了 LPF_RST 的下降沿来 reset SR-Latch (先 reset 再 set？)，不妨也同时利用 LPF_RST 的上升沿来 reset SR-Latch；这样，即便 SR-Latch 初始状态为高 (LPF_RST_WIDER 为高电平) 触发了滤波器复位，在频带切换后 (LPF_RST 变高)，SR-Latch 也会……
- 不对！这里是因为我们复位后的电压不在两个滞回比较器中间范围，才导致频带切换触发后 LPF_RST 恒为高的！所以只需要修改 D_LPF_VRST_dec 即可。
- 用 MATLAB 计算 VDD = 1.1 V 下的 VRST 数值，结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-05-08-05_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 经过仔细考察，我们选择使用 R1 = [300, 150, 75, 43] 配合 R2 = 75||300 = 60 来做 4-bit trimming，效果如右图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-05-26-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div> 此时有：
    - dec   VRST @ 1.1V
    -  0    0
    -  1    0.1643
    -  **2    0.2623**
    -  3    0.3611
    -  4    0.3736
    -  **5    0.4491**
    -  6    0.4980
    -  7    0.5508
    -  8    0.4562
    -  9    0.5162
    - 10    0.5559
    - 11    0.5994
    - 12    0.6052
    - **13    0.6414**
    - 14    0.6662
    - 15    0.6943


``` bash
Logic_std_2d0_200n_30n_PulseWider_BUFx2x2_256units_2bit_v1

D_matrix = [
0 0 0
0 0 1
0 1 0
0 1 1
1 0 0
1 0 1
1 1 0
1 1 1
];

D_matrix = [
0 0 0 0
0 0 0 1
0 0 1 0
0 0 1 1
0 1 0 0
0 1 0 1
0 1 1 0
0 1 1 1
1 0 0 0
1 0 0 1
1 0 1 0
1 0 1 1
1 1 0 0
1 1 0 1
1 1 1 0
1 1 1 1
];


 0    0
 1    0.1643
 2    0.2623
 3    0.3611
 4    0.3736
 5    0.4491
 6    0.4980
 7    0.5508
 8    0.4562
 9    0.5162
10    0.5559
11    0.5994
12    0.6052
13    0.6414
14    0.6662
15    0.6943
```


仿了一下，现在 LPF_RST 信号是正常了，**但还是那个问题：SR-Latch 初始态为高导致 LPF_RST_WIDER 恒为 1 不降下来** (没有任何信号给它复位)。我们这样：将 SR-Latch 型长时间 pulse_wider 改为多个小 pulse_wider 串联 (每个由 32unit 构成，)





### 28.4 layout of LPF_RST

`202602_CDR__LPF_rst_v5_7bitCtrl` LPF_RST 模块版图如下：
- 版图效果：
- PEX 结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-26-20-45-55_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>




## 29. Design of LPF 

### 29.1 cap cell w/o SW

- `202602_CDR__LPF_CAP_momcapM2M7_x64_v1_initial` PEX 结果： 203 fF/cell <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-16-52-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- `202602_CDR__LPF_CAP_momcapM2M7_x64_v3_onlyNMOS` PEX 结果：213 fF/cell <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-18-58-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


### 29.2 pre-sim test

- 仿真验证 `202602_CDR__LPF_capCell_sw_1800fF`：
    - 结果图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-22-24-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 结论：功能正常，实际等效电容约为 2.0 pF
- 前仿验证 `202602_CDR__LPF_C1_16t`：功能正常，可调范围是 2.0 pF ~ 32.0 pF <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-22-49-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 前仿验证 `202602_CDR__LPF_C2_8t`：功能正常，可调范围是 0.25 pF ~ 2.00 pF <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-27-23-44-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 前仿验证 `202602_CDR__LPF_R1_16t_v2_unit800Ohm`：功能正常，可调范围是 55 Ohm ~ 850 Ohm <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-00-59-07_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


``` bash
D<2:0>_dec  sum{T<0:15>}   sum{T<1:15>}
00          01             00
01          02             01
02          03             02
03          04             03
......
14          15             14
15          16             15

  VS("/EN_C1<0>")
+ VS("/EN_C1<1>")
+ VS("/EN_C1<2>")
+ VS("/EN_C1<3>")
+ VS("/EN_C1<4>")
+ VS("/EN_C1<5>")
+ VS("/EN_C1<6>")
+ VS("/EN_C1<7>")
```


2026.04.28 完成初版 LPF 版图：
- 版图效果：（这里放图）


这里列出 R1/C1/C2 的控制字与实际对应值：
- C1 = (D_C1_dec + 1) x 2.0 pF
- C2 = (D_C2_dec + 1) x 0.25 pF
- R1:

``` bash
D_R1_dec    R1 (Ohm)
00          850
01          425
02          283
03          212
04          170
05          142
06          122
07          106
08          95
09          85
10          77
11          74
12          65
13          61
14          57
15          55
```



## 30. PFD + LPF

### 30.1 pre-sim veri.

仿真验证修改后的 PFD/LPF：
- interactive.389:
    - 13_TB_PFDandLPF
    - `202602_CDR__PFD_v2_morePINs` + `202602_CDR__CPs_v1_initial` **(注意是 CP_v1)**
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 700 MHz/V
    - R1 = 250
    - C1 = 20p, C2 = C1/20
    - EN_PD_num = 5 -> 100 uA
    - EN_FD_num = 3 -> 180 uA
    - (fc, fd slow/fast gain) =
        - (13.9G, 32/04)
        - (14.0G, 16/48)
        - (14.1G, 08/48)
    - LD_LEVEL_dec = 51/63 = 80.95%
    - D_dec of (R1, C1, C2) = (03, 10-1, 04-1)
    - time_end = 1.25*2^14 = 0.363 us
    - 10-thread @ 3-job (APS++, moderate)
- Testbench 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-07-16-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真设置截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-07-16-08_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真耗时：4h 11m 48s
- 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-14-46-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>

- interactive.390:
    - 13_TB_PFDandLPF
    - `202602_CDR__PFD_v2_morePINs` + `202602_CDR__CPs_v5_onlyFDsw` **(CP_v5)**
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 700 MHz/V
    - R1 = 250
    - C1 = 20p, C2 = C1/20
    - EN_PD_num = 5 -> 100 uA
    - EN_FD_num = 3 -> 180 uA
    - (fc, fd slow/fast gain) =
        - (13.9G, 32/04)
        - (14.0G, 16/48)
        - (14.1G, 08/48)
    - LD_LEVEL_dec = 51/63 = 80.95%
    - D_dec of (R1, C1, C2) = (03, 10-1, 04-1)
    - time_end = 1.25*2^14 = 0.363 us
    - 10-thread @ 3-job (APS++, moderate)
- Testbench 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-07-19-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真设置截图：与 interactive.389 完全相同
- 仿真耗时：4h 3m 51s
- 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-14-48-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 结论：CP_v1 更好，不改了



### 30.2 layout of PFD

``` bash
NODFF_UP<3:0>,NODFF_DN<3:0>,UP<3:0>,DN<3:0>
```

2026.14.18 完成第三版，有较为可靠的 VDD/VSS 连接。



### 30.3 LPF_RST leakage and CP_v7 very.

已经在 TB_basic_DCtest 中验证过 LPF_RST 模块的漏电情况，结果如图：等效电阻基本上在 1 GOhm 以上，没有问题

在 interactive.389 基础上，将 LPF_RST 模块挂到 VC1 处 (EN = VSS)，验证漏电下能否正常工作：
- interactive.391:
    - 13_TB_PFDandLPF
    - `202602_CDR__PFD_v2_morePINs` + `202602_CDR__CPs_v1_initial` + `202602_CDR__LPF_rst_v6_largerWidth`
    - RC_timeConstant = 0.2
    - Jc_rms = 1.0 mUI
    - KVCO = 700 MHz/V
    - R1 = 250
    - C1 = 20p, C2 = C1/20
    - EN_PD_num = {4, 6} -> {80 uA, 120 uA}
    - EN_FD_num = 3 -> 180 uA
    - (fc, fd slow/fast gain) = (14.0G, 32/08)
    - LD_LEVEL_dec = 51/63 = 80.95%
    - D_dec of (R1, C1, C2) = (03, 10-1, 04-1)
    - time_end = 1.25*2^14 = 0.363 us
    - 10-thread @ 3-job (APS++, moderate)
- 结果如下：


## 31. AFE_SE_TOP 对接


``` bash
LVS:
(1) include spice files "EMX_subcircuits.added"
    ***************************************
    .SUBCKT Rectangular_300p_Ldiff GND n1 n2
    .ENDS
    ***************************************
    .SUBCKT Rectangular_50p_Ldiff GND n1 n2
    .ENDS
    ***************************************
    .SUBCKT Rectangular_150p_Ldiff GND n1 n2
    .ENDS
    ***************************************
(2) Include Rule Statements
    LVS BOX Rectangular_50p_Ldiff
    LVS BOX Rectangular_150p_Ldiff
    LVS BOX Rectangular_300p_Ldiff
    LVS NETLIST BOX CONTENTS NO

PEX: 
(1) include spice files "EMX_subcircuits.added"
    ***************************************
    .SUBCKT Rectangular_300p_Ldiff GND n1 n2
    .ENDS
    ***************************************
    .SUBCKT Rectangular_50p_Ldiff GND n1 n2
    .ENDS
    ***************************************
    .SUBCKT Rectangular_150p_Ldiff GND n1 n2
    .ENDS
    ***************************************
(2) Include Rule Statements:
LVS BOX Rectangular_50p_Ldiff
LVS BOX Rectangular_150p_Ldiff
LVS BOX Rectangular_300p_Ldiff
LVS NETLIST BOX CONTENTS NO
PEX XCELL "Rectangular_50p_Ldiff" PRIMITIVE
PEX XCELL "Rectangular_150p_Ldiff" PRIMITIVE
PEX XCELL "Rectangular_300p_Ldiff" PRIMITIVE
(3) add the statements in cellmap "icellmap.yaml":
    - model: Rectangular_50p_Ldiff
    cellview: { lib: RX_AFE_layout, cell: Rectangular_50p_Ldiff, view: symbol }
    pin: {  GND: GND, n1: n1, n2: n2 }

    - model: Rectangular_300p_Ldiff
    cellview: { lib: RX_AFE_layout, cell: Rectangular_300p_Ldiff, view: symbol }
    pin: {  GND: GND, n1: n1, n2: n2 }

    - model: Rectangular_150p_Ldiff
    cellview: { lib: RX_AFE_layout, cell: Rectangular_150p_Ldiff, view: symbol }
    pin: {  GND: GND, n1: n1, n2: n2 }
```


## 32. AFE (CORE + Ada) 拼接

### 32.1 pre-sim veri.

仿真验证 `202602_CDR__AFE_v2_test`：
- TB_AFE > TB_8_AFE
- interactive.448:
    - Testbench 原理图：
    - Testbench 设置图：
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-19-18-08_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 仿真结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-19-20-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 结论：POS_Adaptation 这边似乎有接错线？
    - 注：这里仿错了，用的 config 调用的是 7_schematic 而不是 8_schematic
- 重新仿真：
- TB_AFE > TB_8_AFE > interactive.449:
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-21-26-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 结果如图：没有问题 


### 32.2 design of decoder

解码器思路如下：
- (1) 理想情况下，每个周期 4-ternary 解码得到 6-bit (两个 2T/3B 解码)，且带有奇偶切换
- (2) 我们改为：每个周期 4-ternary 解码得到 6-bit 中的第一个比特，也即模型模式下 D<0,2> 解码出 3-bit 中的第一个比特。
- (3) 具体实现电路如下：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-20-16-24_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.jpg"/></div>

``` bash
dff
DAE_H<0>,DAE_H<2>,DAE_H<4>,DAE_L<0>,DAE_L<2>
dff_DAE_H<0>,dff_DAE_H<2>,dff_DAE_H<4>,dff_DAE_L<0>,dff_DAE_L<2>
DAE_L<2,0>,DAE_H<4,2,0>
```

- 前仿验证解码器：
- interactive.448:
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-21-34-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 仿真结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-28-23-12-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 结论：功能正常，符合预期





## 33. CP + VCO layout 

### 33.1 一键提取下层 label

``` bash
load "/data/share/LZC/skill/CopyBottomLabelFromInstOrMosaic.il"
hiSetBindKeys("Layout" list(
    list("Ctrl Shift<Key>l" "CopyBottomLabelFromInstOrMosaic()"); 
)
)
```

### 33.2 CP layout

2026.04.28 19:10 完成 `202602_CDR__CPs_v7_final` 版图。

### 33.3 VCO layout 

``` bash
CK315 CK135 CK180 CK0 CK225 CK45 CK270 CK90
```

2026.04.29 02:29 完成原 VCO 的 VDD/VSS virtual 问题，具体路径是：`CCO_FORDY` > `CCO_LOGIC_DAC_FOR_DY_v2_clearLVS` > `BK_20260428_0229_v3_PS_layout`



### 33.4 top VCO cell


之前在 `MyLib_202602_CDR_tsmcN28` > `202602_CDR__VCO_withBandControl_v2` 中，我们将 VCO 的 DAC 正负输入交换了 (反相)：
- 交换后的效果是：随着 DIN_dec 增大，kvco 减小而频带跳跃量 (约 300 MHz ~ 400 MHz) 增大；在 DIN_dec = 128 附近寻找正常工作点
- 在这次的 `MyLib_tsmcN28` > `202602_CDR__VCO_v1` 中，我们就 **不交换 VCO 的 DAC 正负输入了** ，也就是随着 DIN_dec 增大，kvco 逐渐增大。
- VB_IC 的内部底层如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-29-02-46-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>

``` bash
Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit_withBUF
```

- 构建 `Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit_withBUF_VDD` 如图：（这里放图）
- 原来的 `MyLib_202602_CDR_tsmcN28` > `202602_CDR__VCO_withBandControl_v2` 仿真结果：
    - `MyLib_202602_CDR_tsmcN28` > `202602_CDR___TB_VCO` > 202602_CDR___TB_VCO
    - 原理图设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-29-04-13-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-29-04-14-32_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 仿真结果 @ interactive.22：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-29-04-13-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 仿真验证我们准备使用的 `202602_CDR__VCO_v1`：
    - Testbench 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-29-04-22-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-29-04-47-16_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 仿真结果 @ interactive.23：没有问题 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-29-06-34-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


### 33.4 PAD Ring 对接

``` bash
/home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/GSGSG_PAD
/home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/PAD_RING_YHX_PAM3_BGR_SR
/home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/PAD_SR_REF


DEFINE GSGSG_PAD /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/GSGSG_PAD
DEFINE PAD_RING_YHX_PAM3_BGR_SR /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/PAD_RING_YHX_PAM3_BGR_SR
DEFINE PAD_SR_REF /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/PAD_SR_REF

ASSIGN GSGSG_PAD DISPLAY OtherResources
ASSIGN PAD_RING_YHX_PAM3_BGR_SR DISPLAY OtherResources
ASSIGN PAD_SR_REF DISPLAY OtherResources
```

说明：
- GSGSG_PAD: 差分数据输入的库，GSGSG 指 GND - Signal - GND - Signal - GND
- PAD_RING_YHX_PAM3_BGR_SR: PAD Ring 的库，用总的、TX 端、RX 端三个主要 cell
- PAD_SR_REF: Shift Register 的库
- 注：我这边只需调用 PAD_RING_YHX_PAM3_BGR_SR 中的内容，其它两个均为设计到的引用库

### 33.5 SFR bit 数对接

梁师兄那边一开始是双通道 174-bit，合并之后一共为 108-bit，SFR 这边一共 280-bit (0 ~ 279)。



统计我这边的：
- VCO: 44-bit
    - **0V25 和 0V75: 8 + 8**
    - DAC_IN: 8
    - **CN_INIT: 8**
    - LOGIC_STEP: 2
    - MN_BANDCTRL_EN + MN_BANDCTRL_D: 1 + 8
    - RST_N: 1
- CDR_CORE (SSSD + Adaptation): 39-bit
    - MN_DFE_EN + **MN_DFE_D**: 1 + **8**
    - D_IMAX: 2
    - D_MAINVB: 2
    - D_NEG_R1 + D_NEG_R2: 3 + 5
    - D_POS_R1 + D_POS_R2: 3 + 5
    - MN_VTH_EN + MN_VTH_D: 1 + 8 (注意这里 POS/NEG 端已经 share 了)
    - RST: 1
- Digital 部分：23-bit
    - LK: 
        - LD_LEVEL<5:0>: 6
    - PFD: 
        - **D_FDGAIN_SLOW: 6**
        - **D_FDGAIN_FAST: 6**
        - D_PD_MODE: 2
        - MN_CTRL_EN + MN_CTRL_ENFD: 2
    - Decoder:
        - D_MODE: 1

三块一共是: 44 + 39 + 23 = 106-bit (双通道 212-bit)

我这边可以使用 (280 - 108) = 172-bit，那么就一共需要 share (212 - 172) = 40-bit。保险起见我们 share 44 ~ 48 bits，包括：
- VCO > 0V25 和 0V75: 16-bit
- VCO > CN_INIT: 8-bit
- CDR_CORE > MN_DFE_D: 8-bit
- Digital > D_FDGAIN_SLOW 和 D_FDGAIN_FAST: 12-bit
- 上面这些一共是 44-bit，如果后面有突发情况还得继续 share，就进一步 share MN_VTH_D (8-bit)





## 34. Finial Records 截止前的记录

### 34.1 CDR CORE

- 2026.04.29 06:35 完成 VCO：`202602_CDR__VCO_v1`
- 2026.04.29 06:41 RX 总布局考虑 (单通道)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-29-06-41-28_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
- 2026.04.29 10.30 完成 CDR_CORE 拼接
- 2026.04.29 10:51 准备验证次顶层：
    - VCO 这边，一个频带跳跃约为 225 MHz
    - 设置 DAC_IN_dec = 128 @ CN_INT_dec = 14 (0 ~ 255) 时，起始频率为 4.3 GHz
    - 那么如果需要 14 GHz 的初始频率，我们需要设置 CN_INT_dec = 57
    - 考虑到这里我们只做前仿，保险起见，我们分别设置 CN_INT_dec = {40, 70} 进行仿真
- 2026.04.29 13:00 完成 RX_0 拼接 `202602_CDR_RX_0_v2_moreCKpins` (VCO + BUF + CDR)
- 2026.04.29 13:41 开始 RX_1 拼接 `202602_CDR_RX_1_v2_lessPINs` (VCO + BUF + CDR + LKD + PFD + DECODER)
- 2026.04.29 16:50 完成 RX_1 拼接 `202602_CDR_RX_1_v2_lessPINs`
- 初步搭建 RX_2 (几乎完整)，在开始仿真验证之前，先统计一下比特数：**这里发现之前初步统计时漏了 LPF + CP 这部分！**
    - 比特数计算结果：单通道是 133-bit，我们这边双通道一共可用 (280 - 108) = 172-bit，需要 share 的比特数为 (2 x 133 - 172) = 94-bit
    - 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-29-17-54-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.jpg"/></div>
    - 按照图中这种初步 share 方法，恰好是 share 了 94-bit，控制字一个不剩，似乎有些不保险；不管了，先把单通道做出来再说
- 边仿真 top cell `202602_CDR_RX_2_v1` 边做版图，仿真设置如下：
    - 仿真设置截图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-29-18-08-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - 注：前面设置的 CN_INT_dec = {40, 70} 分别对应初始频率 12.3 G 和 17.6 G，中心点是 55 预计对应 14.95 GHz，我们设置 51 或 52 以接近 14 GHz
    - testbench 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-29-18-04-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>
    - interactive.392 是之前仿的 `202602_CDR_RX_0_v2_moreCKpins`，interactive.393 是刚刚仿的顶层 CDR
+ 2026.04.29 21:30 完成了 CORE 核心 `202602_CDR_RX_2_v2`



``` bash
DAE_H<0>,DAE_H<1>,DAE_H<2>,DAE_H<3>,DAE_H<4>,DAE_H<5>,DAE_H<6>,DAE_H<7>,DAE_L<0>,DAE_L<1>,DAE_L<2>,DAE_L<3>,DAE_L<4>,DAE_L<5>,DAE_L<6>,DAE_L<7>
CK_SYS,VSS_DATA,VSS_DATA,DAE_H<7:0>,DAE_L<7:0>

(  2**0*VT("/I245/I0/POS_DTH<0>")
+ 2**1*VT("/I245/I0/POS_DTH<1>")
+ 2**2*VT("/I245/I0/POS_DTH<2>")
+ 2**3*VT("/I245/I0/POS_DTH<3>")
+ 2**4*VT("/I245/I0/POS_DTH<4>")
+ 2**5*VT("/I245/I0/POS_DTH<5>")
+ 2**6*VT("/I245/I0/POS_DTH<6>")
+ 2**7*VT("/I245/I0/POS_DTH<7>"))/VAR("VDD")
```



``` bash
VSS_DATA,CK_SYS,CK_SYSB,VSS_DATA
DAE_H<7:0>,DAE_L<7:0>
ADA_H,ADA_L
OFS_H,OFS_L
```

### 34.2 AFE 拼接

上面我们已经得到了 `202602_CDR_RX_2_v2`，接下来要拼 AFE 上去，思路如下：
- (1) 将 `202602_CDR_RX_2_v2` 复制为 `202602_CDR_RX_2_v2d1_layout_for_AFE`，拼接 AFE 时就在此基础上
- 如图，在一个 "模版 cell" 中放置好 PAD 环以及我们的模块，镜像复制一个到上面，这时双击下面这个模块就会进入 "在当前背景板下编辑低层模块" 的模式，上面镜像复制的这个自然也就同步更新。<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-30-00-28-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>


``` bash
D_CTLE_GM<3:0>,D_CTLE_CAP<4:0>,MUX_SL,D_DAC1<7:0>,D_DAC2<7:0>
Q_AFE_CTLE_GM<3:0>,Q_AFE_CTLE_CAP<4:0>,Q_AFE_MUX_SL,Q_AFE_DAC1<7:0>,Q_AFE_DAC2<7:0>
```


**注意翻转 `CAP_CELL_4uM9_load_DY` 会影响 VDD/VSS 连接情况，不能有的翻有的不翻**


AFE 这边单通道需要 9 + 1 + 16 = 26-bit 控制字 (已经尽可能节省了)，我们自己的单通道 CDR 是 133-bit 控制字，合起来一共 159-bit 但是我们这边总可用比特数只有 172-bit。看来需要同时 share 所有控制字，我们看看有没有啥特别关键的控制字值得不 share (单通道可以有 13-bit 不 share)：仔细看了一圈，其实没有什么很特殊的控制字有必要不 share。那就全部共用，免得额外麻烦。

我们这边算上 AFE 一共是 159-bit，连接序号应为 1 ~ 159 = 0 ~ 158 = **108 ~ 266**，剩下的 267 ~ 279 (13-bit) 空闲。


控制字映射顺序按下图，从上至下依次为 Q<158>, Q<158>, ..., Q<1>。用 MATLAB 做了加法验证，确实是 159-bit

``` bash
1+8+2+8+8+1+8+8+2+2+1+8+1+1+1+8+3+5+3+5+4+4+3+6+6+6+2+1+1+1+4+3+4+4+4+5+1+8+8
```

梁师兄那边 108-bit 用 Q<107:0>，我这边 159-bit 用 Q<266:108>


``` bash

DEFINE 8_4_2_1_MUX_FOR_XYH /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/MUX_DEMUX_FOR_LZC/8_4_2_1_MUX_FOR_XYH
DEFINE DEMUX_NEW /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/MUX_DEMUX_FOR_LZC/DEMUX_NEW
DEFINE DEMUX_NEW2 /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/MUX_DEMUX_FOR_LZC/DEMUX_NEW2
DEFINE PLL_DLY_XYD_2024 /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/MUX_DEMUX_FOR_LZC/PLL_DLY_XYD_2024
DEFINE PLL_DLY_XYD_2024_v2 /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/MUX_DEMUX_FOR_LZC/PLL_DLY_XYD_2024_v2
DEFINE SerDes_PAM3_TRX_test /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/SerDes_PAM3_TRX_test
DEFINE 8_4_2_1_MUX_FOR_XYH_1 /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/MUX_DEMUX_FOR_LZC/8_4_2_1_MUX_FOR_XYH_1
DEFINE Tcoil_GCPW /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/For_LZC/Tcoil_GCPW
DEFINE GCPW /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/For_LZC/GCPW
DEFINE tsmcN28PAD /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/For_LZC/PAD/tsmcN28PAD
DEFINE ESD_EXAMPLE /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/For_LZC/PAD/ESD_EXAMPLE
DEFINE GSGSG_PAD /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/For_LZC/PAD/GSGSG_PAD

DEFINE SBD_D2D_TRX_LANE_WO_HYBRID /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/SBD_D2D_TRX_LANE_WO_HYBRID
DEFINE LZC_MUX /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/LZC_MUX
DEFINE LZC_PAD /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/LZC_PAD
DEFINE LZC_41MUX_V1 /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/LZC_41MUX_V1
DEFINE BGR_YHX /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/BGR_YHX
DEFINE 8_4_2_MUX_LZC /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/8_4_2_MUX_LZC
DEFINE TX_PhaseAlign_FORLZC /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/TX_PhaseAlign_FORLZC

DEFINE HOPPING_LOGIC_FOR_YWJ /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/HOPPING_LOGIC_FOR_YWJ
DEFINE Comp_DFE_FOR_XYD /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/Comp_DFE_FOR_XYD
DEFINE tcbn28hpcplusbwp12t30p140 /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/tcbn28hpcplusbwp12t30p140
DEFINE PI_MPG_2023 /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/PI_MPG_2023
DEFINE MCG_XYD /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/MCG_XYD
DEFINE DTC_AFC_Logic_7sw /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/DTC_AFC_Logic_7sw
DEFINE DTC_AFC_Logic_4bit /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/DTC_AFC_Logic_4bit
DEFINE PAD_RING_YHX_PAM3_BGR_SR /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/PAD_RING_YHX_PAM3_BGR_SR
DEFINE PAD_SR_REF /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/PAD_SR_REF
DEFINE DAC_FORYWJ /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/DAC_FORYWJ
DEFINE CAP_100fF_XYD /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/CAP_100fF_XYD
DEFINE Multi_BUFFER_FOR_YWJ /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/Multi_BUFFER_FOR_YWJ
DEFINE REF_FOR_XYD_V4 /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/REF_FOR_XYD_V4
DEFINE PLL_DLY_YWJ_2025_FOR_XYD /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/PLL_DLY_YWJ_2025_FOR_XYD
DEFINE IB_20U_FORXYH /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/IB_20U_FORXYH
DEFINE CLK_BUF_IN_OUT /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX/CLK_BUF_IN_OUT
```

## 35. Experience Summary

- M9 要求 density < 50%：核心附近放置带 CAP 的 PowerCell，将电源/地从 PAD 连接到核心附近这一段使用 **不带 CPA 的 PowerCell**。
- 重要：导入任何 gds (stream) 时，新建库导入，否则 gds 中包含的所有层次模块将会覆盖原有模块 (的 layout)
- 脚本填 M9 dummy 时，由于 50% 密度限制，建议直接全部 block M9 然后手动解决 M9 局部低密度问题
- 电感的使用：应该带 NT_N 层，用不闭合 p-ring，然后 p-ring 通过仅一处金属接出去
    - 闭合的话，相当于给电感构成一个感生涡旋电流的通路，增加损耗降低 Q；如果多处引出，也有可能构成环，引起涡旋电流损耗
- OD/PO 这种东西，小模块以及小模块互连时能填还是尽量填好，免得后续拼版时报错，修改起来比较耗时 (DRC 时间长)


``` bash
CB2.EN.1:ST_M8
CB2.S.2:M9
CUPCB2.EN.4:M8
CUPCB2.R.3
CUPCB2.R.7:CB
CUPCB2.R.7:CB2
CUPCB2.R.7:M9
CUPCB2.R.7:M8
CUPCB2.R.7:AP
CUPVIAT.DN.1
CUPVIAT.DN.2


CB2.EN.1:ST_M8, CB2.S.2:M9, CUPCB2.EN.4:M8, CUPCB2.R.3, CUPCB2.R.7:CB, CUPCB2.R.7:CB2, CUPCB2.R.7:M9, CUPCB2.R.7:M8, CUPCB2.R.7:AP, CUPVIAT.DN.1, CUPVIAT.DN.2
```




## 99. overall die diagram

2026.04.07 19:22 导师提供：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-04-07-19-22-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (4) Counter, DAC and Logic Circuit.png"/></div>



