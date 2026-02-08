# Analog Design Examples from GitHub User HarshitSri-Analog

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 13:41 on 2026-01-24 in Lincang.
> dingyi233@mails.ucas.ac.cn

做项目滑水时发现 GitHub 上有位用户 [HarshitSri-Analog](https://github.com/HarshitSri-Analog) 分享了不少模拟 IC 基础设计的实例，本来这并不足为奇，但难得的是他在这些设计中都给出了完整的设计文档和详细的仿真结果 (包括 testbench 设置)，非常适合直接拿来作为参考，既方便我们把握 180nm 制程下的性能情况，也可以直接拿来做 sizing 从而快速完成其它工艺节点下的模块设计。

截至 2026.01.24, 其 [GitHub](https://github.com/HarshitSri-Analog?tab=repositories) 共包含下面几个仓库 (都是 180nm)：
- **(1) 5T-OTA** [(Single-Stage-Differential-Amplifiers-Design-Analysis)](https://github.com/HarshitSri-Analog/Single-Stage-Differential-Amplifiers-Design-Analysis)
    - 设计了一个 nmos-input 5T-OTA with 1.8-V supply and 100-uA bias current
    - 除了输入管为 4u/500n, 其它管子尺寸均为 4u/2u，其中输入管 gm/Id ≈ 20 (Id = 50 uA, gm = 922 uS).
    - 文档中给出了 dc opt, dc gain, ac rout, ac gain 和 ac gain @ PVT 的仿真情况，主要仿真结果为 dc gain = 45 dB @ rout = 19.5 kOhm (gm = 922 uS)
- **(2) Miller-OTA** [(Two-Stage-Miller-Compensated-OTA)](https://github.com/HarshitSri-Analog/Two-Stage-Miller-Compensated-OTA): 
    - 设计了一个 two-stage miller-compensated OTA with 1.8-V supply and 100-uA bias current (nmos-input)
    - 除了输入管为 4u/500n, 其它管子尺寸均为 4u/2u, (R, C) = (1.5 kOhm, 0.62 pF)；
    - 文档给出了 dc opt, ac gain 的仿真情况，在总电流消耗 200 uA (1.8-V, 未包括 100 uA bias) 的情况下，dc gain = 91 dB @ GBW = 6.5 MHz, SR = 20 V/us, PM = 63°, ICMR (input common-mode range) = 0.9 V to VDD
- **(3) BGR** [(Bandgap-Reference-Bias-Circuit)](https://github.com/HarshitSri-Analog/Bandgap-Reference-Bias-Circuit):
    - 一个 3.3-V 供电下的经典 BGR 架构 (带运放)
    - Vref = 1.2 V @ 8.905 ppm/°C (from -40°C to 125°C), delta_vref_temp = 1.68 mV, delta_vref_supply = 12 mV
- **(4) LDO** [(Low-Drop-Out-Voltage-Regulator)](https://github.com/HarshitSri-Analog/Low-Drop-Out-Voltage-Regulator):
    - 一个 2.7-V to 1.8-V 的 PMOS-pass LDO, 输出级带 RC 补偿 (R, C) = (0.5 kOhm, 15 pF)
    - Vout = 1.807 V, PM = 63.9°, loop UGF = 5.74 MHz
- **(5) Current Mirror** [Current-Mirror-Topologies](https://github.com/HarshitSri-Analog/Current-Mirror-Topologies):
    - 验证并对比了四种经典的电流镜架构 (basic, cascode, low-voltage cascode, self-biased cascode), 自偏置电阻 R = 2.5 kOhm
    - 结果证明了在 1.8-V supply 和 100-uA current 下，self-biased cascode 的性能和鲁棒性最好，有 rout = 6.36 MOhm, rin = 3.63 kOhm, vout_min = 400 mV (for 1% mirror error)
- **(6) CML** [(Current-Mode-Logic-Circuits-180nm)](https://github.com/HarshitSri-Analog/Current-Mode-Logic-Circuits-180nm):
    - 设计并验证了 1.8-V supply 下 current-mode logic (CML) 的一些基本逻辑门，包括 INV, NOR/OR, NAND/AND, MUX2, gated D-Latch, D-FF；其中 D-Latch 和 D-FF 既是 pos-tri 也是 neg-tri, 因为 EN/CK 信号也是差分输入的
    - 注意 CML 输出和输入均为差分信号 (NOT-full-swing)，库中的例子差分摆幅约为 600 mVamp (1200 mVpp)；库中使用的电阻都为 6 kOhm, 本来在 100 uA bias 下应该有 600 mVamp 的摆幅，但是 HarshitSri 错误使用了 self-biased cascode current mirror 下面那一对管子的 gate 作为普通电流镜的偏置电压，导致电流镜进入线性区，实际电流和摆幅都被拉低
    - 除了偏置管 (bias current = 100 uA)，在其它所有管子 "等效尺寸" 均为 3u/210n 的情况下，仿真得到传输延迟 (propagation delay) 为：INV = 65 ps, NOR/OR = AND/NAND = MUX2 = 130 ps, D-Latch = D-FF = 200 ps, 上述模块 rise/fall time 均为 300 ps 左右

当然，上面这些结果都是前仿，HarshitSri-Analog 并没有在上述库中做任何版图方面的工作，所以参考价值稍有折扣。

>『来自123云盘用户星星不亮了的分享』Analog Design Examples from GitHub User HarshitSri-Analog
> 链接：https://www.123865.com/s/0y0pTd-OWlj3

