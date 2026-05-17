# Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology

**An Ultra-Low-Power CP-PLL for sub-MHz Clock Generation Achieving 600 nW Power Consumption at 1.25 V Supply in ONC 180nm Technology**

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 23:19 on 2025-10-12 in Beijing.


## 1. Information

项目基本信息：
- 时间: 2025.10.13 ~ 2025.12.25
- 工艺:  <span style='color:red'>ONC 180nm CMOS</span> (ON Semiconductor onc18 process design kit)
- 目标: 设计一个满足指标要求的 CP-PLL，包括前仿、版图和后仿
- 作者: 丁毅 (Yi Ding)

系统架构：
- PLL Type: Type-II (Third-Order) Charge-Pump PLL (CP-PLL)
- Reference Frequency (f_REF): 32.768 kHz (X03)
- Output Frequency (f_out): 3\*32.768 kHz ~ 24\*32.768 kHz (X03/X06/X12/X24, 98.304 kHz ~ 786.432 kHz)
- Power Supply Voltage: 1.25 V
- Target Current Consumption: < 500 nA @ no load, < 550 nA @ 40 fF load (each channel)
- Target Cycle Jitter: RMS cycle jitter of X03 < 100 ns (Jc_rms < 100 ns @ 98.304 kHz)

<!-- 系统架构：

f_REF = 32.768 kHz, f_out = 5\*32.768 kHz ~ 20\*32.768 kHz (163.84 kHz ~ 655.36 kHz) -->

项目相关链接：
- [(本文) Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology](<Projects/Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology.md>)
    - (1) 工艺库文档与基本信息：
        - [Basic Information of onc18 (ONC 180nm CMOS Process Library)](<AnalogICDesigns/Basic Information of onc18 (ONC 180nm CMOS Process Library).md>)
    - (2) 理论基础与设计指导：
        - [(old) Prerequisite Digital Electronics Knowledge for PLL](<AnalogIC/Prerequisite Digital Electronics Knowledge for PLL.md>)
        - [Loop Analysis of Typical Type-II CP-PLL](<AnalogIC/Loop Analysis of Typical Type-II CP-PLL.md>)
        - [Large Resistor Implementation Techniques for Low-Power Analog IC Designs](<AnalogIC/Large Resistor Implementation Techniques for Low-Power Analog IC Designs.md>)
        - [The Differences Between Latch and Flipflop (D Latch vs. D Flipflop)](<AnalogIC/From Basic Logic Gates to D Latch and D Flipflop.md>)
    - (3) VCO 设计/选型/迭代与环路验证：
        - [202510_onc18_CPPLL (1) VCO Design Iteration](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (1) VCO Design Iteration.md>)
        - [202510_onc18_CPPLL (2) VCO Iteration and Layout](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.md>)
    - (4) 设计迭代与前仿结果：
    - (5) 版图设计与后仿结果：
        - [202510_onc18_CPPLL (3) Design of Other Modules](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (3) Design of Other Modules.md>)
        - [202510_onc18_CPPLL (4) Pre-Layout Simulation and Layout Details](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (4) Pre-Simulation, Layout Details and Post-Simulation Results.md>)
    - 其它：
        - [Virtuoso Tutorials - 15. Several Methods for PEX and How to Speed Up Your Post-Simulation](<AnalogIC/Virtuoso Tutorials - 15. Several Methods for PEX and How to Speed Up Your Post-Simulation.md>)
        - [Virtuoso Tutorials - 16. Using Config Sweep and CALIBREVIEW to Speed Up Your Post-Layout Simulation](<AnalogIC/Virtuoso Tutorials - 16. Using Config Sweep and CALIBREVIEW to Speed Up Your Post-Layout Simulation.md>)
        - [Virtuoso Tutorials - 17. Creating Parameter Passing Symbol as The Standard PCell](<AnalogIC/Virtuoso Tutorials - 17. Creating Parameter Passing Symbol as The Standard PCell.md>)
        - [Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation](<AnalogIC/Phase Noise and Jitter Characterization in Mixed-Signal Circuits, and the MATLAB Implementation.md>)
        - [All You Need to Know About Fourier Analysis (FS, DFS, FT, DTFT, DFT)](<AnalogIC/All You Need to Know About Fourier Analysis (FS, DFS, FT, DTFT, DFT).md>)

**注：本次项目的所有相关资料/原理图/版图已经上传到 123 云盘链接 <span style='color:red'> (待上传) </span>, 点击即可下载。**

## 2. Objective and Schedule

- (2025.10.13 ~ 2025.10.13) 1. 回顾理论知识，给出设计指导
- (2025.10.14 ~ 2025.10.15) 2. 熟悉 ocn18 工艺库，提取工艺库关键信息
- (2025.10.14 ~ 2025.10.16) 3. 考虑不同 PLL 架构，探索 VCO 性能参数，给出全系统设计指导
- (2025.10.15 ~ 2025.10.16) 4. VCO 初步设计与迭代，为架构打下基础 (VCO 好自然就能用更简单的架构)
- (2025.10.15 ~ 2025.10.16) 5. 完成环路 Verilog 建模与行为级仿真测试，初步确定环路参数
- (2025.10.15 ~ 2025.10.16) 6. 将实际 VCO 模型代入环路，初步验证 VCO 和环路性能
- (2025.10.16 ~ 2025.10.21) 7. 对几种可用 VCO 架构进行迭代，对比最优性能，选出最终架构
- (2025.10.21 ~ 2025.10.22) 8. 严谨推导 Type-II CP-PLL 理论环路公式，进一步优化环路参数
- (2025.10.23 ~ 2025.10.25) 9. 完成 VCO 版图设计与后仿验证
- (2025.10.25 ~ 2025.11.06) 10. 完成环路剩余模块的设计、优化与环路仿真验证
- (2025.11.06 ~ 2025.11.10) 11. 完成 PLL 的全温度/工艺角前仿，从三种方案中选出最终方案 (最终选了 Option 2, 也即 RVCO2 @ X24 with FB retiming)
- (2025.11.11 ~ 2025.11.16) xx. 受 "非线性电路" 期中考试影响，此时间段基本无进度
- (2025.11.17 ~ 2025.11.25) 12. 完成 PLL 大部分模块的版图设计与环路后仿验证 (完成了 PFD/CP/VCO/FD, 还差 LPF/BUF)
- (2025.11.26 ~ 2025.12.02) xx. 受 "数字逻辑电路" 期中考试影响，此时间段基本无进度 
- (2025.12.03 ~ 2025.12.05) 13. 完成 PLL 剩余模块的版图设计与环路后仿验证
- (2025.12.05 ~ 2025.12.07) 14. 完成 PLL 的全温度/工艺角后仿，全面确认最终性能指标
- (2025.12.08 ~ 2025.12.14) 15. 撰写项目总结报告与相关文档
- (2025.12.15 ~ 2025.12.18) 16. 进一步完善相关文档与资料 **(完整的设计与报告其实到这里就结束了，后面是根据需求方反馈结果进行修改/补充的过程)**
- (2025.12.19 ~ 2025.12.25) 17. 结合需求方提供的数字开关电源作联合仿真验证
- (2026.01.06 ~ 2026.01.11) 18. 根据需求方最新要求，将 PAD 级驱动 (big BUF) 换为 level shifter，PAD 端会自带 BUF 不需要我们这边设计
；又因为先交付原理图及其前仿报告 (不含版图)，所以需要对电路重新进行前仿并出具报告 (之前做的是后仿)
- (2026.01.22 ~ 2026.01.25) 19. 对修改后的电路进行版图设计与后仿验证，出具最终后仿报告 (在之前的后仿验证基础上修改即可)





## 3. Design Summary




## 4. Experience Summary



- Verilog-A 代码修改后却 "没有变化" 时，记得在 verilog 界面点击左上角的保存按钮 `Build a databese of instances, nets and pins found in file`，这会重新提取 verilog 代码对应网表；如果还不行，可能是原理图未刷新导致的，重新放置器件即可。 
- 在 Assembler 的 Global Variables 处右键可以 Add Config Sweep.
- VCO 输出波形 (CK_OUT) 占空比不为 50% 时，一般不会对 CK_FB 产生影响，因为经典 tri-state PFD 比较的是两路时钟的上升沿对齐情况，即便 CK_FB 是窄/宽脉冲也可以正常工作 (但不能太窄/太宽)
- 偶数分频 (2 分频) 可以 "完全" 修正时钟占空比，奇数分频一般只能部分修正（公式如下），除非使用 50%-duty 奇数分频电路 (可以在非 50-duty 电路的基础上进行改造)

$$
\begin{gather}
N = 2k + 1 \Longrightarrow  D' = \frac{100\%\times k + D}{100\%\times (2k + 1)} = \frac{D  - 50\%}{N} + 50\% 
\\
\mathrm{for\ example:}\ D = 53\%,\ N = 15 \Longrightarrow D' = \frac{53\% - 50\%}{15} + 50\% = 50.2\%
\end{gather}
$$


- 建议 global 变量用于扫描/测试，test 里的 design variable 用于存放最佳值
- VCO 设置时分为 VCO_core 和 VCO_buffer 两部分，方便迭代
- Current-Starved Ring VCO: VDD = 1.2\*Vth ~ 2.8\*Vth 有良好性能；如果要求功耗尽量低，那么 1.5\*Vth 左右能在保证其它性能的前提下尽量降低功耗；综合性能最优的点一般在 2.0\*Vth 附近
- 蒙卡点数太少是看不了 mismatch contribution 的，例如只设了 10 个点不行，改成 100 个点后可以
- **Analog multiplexers can be used as digital multiplexers but digital multiplexers cannot be used as analog ones.**
- 多数工艺下，对小面积 nA 级低功耗设计而言，除寄生电容影响外，后仿总比前仿功耗高出 20 nA ~ 100 nA 不等 (与版图面积有关)，这是因为后仿考虑了版图寄生器件漏电流的影响 (主要是寄生 PN 结)



模块文件结构：
``` bash
2025_PLL_RVCO1_layout
    schematic
    layout
    symbol
```


做完一个版本后复制（备份）到另一个 cell: **<span style='color:red'> (注意修改复制后新 cell > layout 的 reference source) </span>**

``` bash
2025_PLL_RVCO1_layout_v1
    schematic
    layout
    symbol
    v1_10272243_PEX_HSPICE
    v1_10272243_layout
```


v1_10272243_layout 是为了再次备份，因为后面有可能修改 v1 的 layout，此时可保存为 v1_10281026_layout (仍属于 v1)
另外，将寄生网表复制到主 cell (config 均使用主 cell，直接从此处调用寄生网表)，最终得到这样的结构：

``` bash
2025_PLL_RVCO1_layout
    schematic
    layout
    symbol
    v1_10272243_PEX_HSPICE
    v1_10281026_PEX_HSPICE
    v2_10290000_PEX_HSPICE

2025_PLL_RVCO1_layout_v1
    schematic
    layout (注意修改复制后新 cell > layout 的 reference source)
    symbol
    v1_10272243_layout
    v1_10272243_PEX_HSPICE
    v1_10281026_layout
    v1_10281026_PEX_HSPICE


2025_PLL_RVCO1_layout_v2
    schematic
    layout (注意修改复制后新 cell > layout 的 reference source)
    symbol
    v2_10290000_layout
    v2_10290000_PEX_HSPICE
```

这样的好处是，可以直接用 config sweep 快速切换 2025_PLL_RVCO1_layout 的 schematic/v1_PEX/v2_PEX, 十分方便。


- 想要 annotate DC operating points 时，直接在 ADE results 处找到想看的工艺角或特定参数，右键选择 `annotate > DC Operating Points` 即可，这样就会自动选择对应参数下的直流工作点结果，显示在原理图上 (配合我们的设置代码即可快速查看晶体管的各个关键参数)
- 对于具有 Negative K_VCO 的锁相环 (假设锁定时控制电压在 VDD/2 附近，不过高或过低)，滤波器 LPF 的 "地" 端有两种基本接法：
    - (1) 接 VDD: 上电之后 V_CT = VDD (最大值)，VCO 频率最低，PLL 需要 "向高频锁定"，锁定时间较长？但是对环路模块 (主要是第一级 FD) 的频率要求大大降低； **如何 "打破" f_out/2 的假锁定状态？**
    - (2) 接 VSS: 上电之后 V_CT = VSS = 0 (最小值)，VCO 频率最高，PLL 需要 "向低频锁定"，锁定时间较短？但是对环路模块 (主要是第一级 FD) 的频率要求较高；也就是说，如果 FD 的最大工作频率不足以覆盖此频率，锁定过程中可能会出现一些问题； **如何 "打破" 2\*f_out 的假锁定状态？**
- VCT 可以设置初始值以加快环路锁定，节省一些时间来仿真稳定后的性能，但是 VDD 最好给充足的 delay 再上电，以避免可能出现的时序或其它问题；
- LPF to VSS/VDD 对 FD 的高频要求不同，如果上电后频率是从低向高锁定，则 FD 高频要求较低，反之则要求较高
- 中高频锁相环 (output > 100 MHz) 的闭环环路带宽比 (f_REF/f_BW) 常常会做到 100 以上，以获得更低的相位噪声 (尤其是低频段)，通常是 150 ~ 500 居多。对于分频比较高的锁相环又如何？
- 对于 CP-PLL, the dead zone of PFD/CP 对整个环路的 Je_rms 影响较大 (因为 Je 是很长时间的 "累积" 抖动)，死区大时，输出相位越有可能接近死区边界，这时便有较大的相位噪声/抖动。举个例子，假设 PFD/CP 对 delay = ±2% 以内都没有反应，也就是 dead zone = -2% ~ +2%, 如果这段死区内的等效电流 $I_{dz}$ 非常小，几乎相当于 "没有电流"，就会导致环路的 RMS phase noise 达到 $2\pi \times 2\% = 0.1257 \ \mathrm{rad} = 7.2^\circ$，这在低抖动时钟系统中是完全不可接受的。这个现象在 nominal $I_P$ 较小时尤为明显，比如 nA-level 低功耗设计。
- 可以用 **`basic > patch`** 元件来短接两个具有不同 net name 的网络，这在版图中也是能正常过的 (版图中会将两网络合二为一，同时保持正确的对应关系)，LVS 能不能过还待验证；但是注意，`patch` 仅能短接两个 net 或者 1 pin + 1 net, 但是不能短接两个 pin (会报错)。与之类似的还有 `basic > cds_thru` 元件 [(here)](https://zhuanlan.zhihu.com/p/370333465)，这个元件其实更好用，一方面它可以短接两个 pin, 另一方面可以明确知道两个 net 到底共用哪个名字 (src 和 dst 两个端口，公用 src 端口的 net name)，数字电路在综合时 (如果需要 "短接") 常常就是自动生成了这个元件，它的版图和 LVS 都能正常通过 (LVS 是利用了 `lvs ignore = true` 来实现的)
- 作图之后，可以通过 `Graph > Edge Browser` 查看边沿的各种信息
- 封装 pcell (parameterized cell) 时，`4*pPar("mu")` 不行但是 `pPar("mu")*4` 可以
- `schematic > View > Info Balloons` 可以打开波形信息气泡，鼠标悬停在 net/pin 上可以快速查看此位置的 voltage/current 波形。
- 管子栅极从 m1 引出，那么 m2/m3 尽量不走线以避免寄生电容耦合，并且最好拿高层金属把沟道全遮住以避免可能存在的光效应 (尤其射频、毫米波)
- Integer-N CP-PLL 的 FD chain 中，随着频率的降低，cycle jitter 逐渐增大 (近似满足$\sqrt{N}$)，而 edge jitter 则基本不变。
- **<span style='color:red'> 仿真时遇到一个问题是：不小心将变量 "copy to cellview" 之后，每次运行仿真，仿真器会自动执行一遍 "copy from cellview"，导致新设置的变量被当时 copy 进来的值覆盖掉。 </span>** 关键是还找不到在哪里 (或如何) 还原设置，这个功能是真的纯恶心人。经过检查，发现是一个 cellview 中存在多个 schematic 时，非默认的 schematic 会以 edit mode 而不是 read mode 打开，导致这个 schematic 对应 test 被 "copy to cellview" 才是真的被 copy 进去。默认 schematic/config 只能以 read mode 打开，因此其 "copy to cellview" 不会生效。所以解决方法就呼之欲出了：在非默认 schematic/config 对应的 test 中，先删除全部 variables，点击 "copy to cellview" 之后，再重新添加 variables 并设置好值即可。**<span style='color:red'> 经过测试：直接点 open design in tap 后，将 schematic 设置为 `Make Read Only`，即可将 design 从 edit 模式修改为 read 模式 </span>**
- 将一个 cell > maestro 复制为新 cell > maestro 后，如果在新 maestro 中删去之前的仿真历史而不影响原 maestro 的仿真历史和数据查看，直接 `右键 > Delete` 即可。虽然 ADE Assembler 会弹出窗口提醒说 "此操作会删除所有仿真数据"，但实际上，由于路径不对应，原 maestro 的仿真数据并不会被删除，仍然可以正常查看 (没有任何影响)。
- VCO 的输出时钟，理论上经过分频后 edge jitter 不变，而 cycle jitter 变为原来的 $\sqrt{N}$ 倍 (假设 cycle jitter 满足高斯分布)。实际情况中 edge jitter 确实基本不变，但是 cycle jitter 因为存在 spur 等非高斯噪声成分，比理论值要更大一些，一般在 $1.4 \sqrt{N} \sim 2.0 \times \sqrt{N}$ 范围内 (视具体设计而定)，我们这次的约为 $1.65 \sqrt{N}$ 倍。
- PLL 中的 LPF，一般都用积分型 LPF 来获得无穷大的直流增益，这是为了使环路稳定后的相位误差为零 (理论上)；根据开环传函得到误差传函 $H_e(s) = \frac{\Phi_{in}(s)-\Phi_{FB}(s)}{\Phi_{in}(s)} = 1 - \frac{1}{N} H_{CL}(s) = \frac{N}{N + H_{OL}(s)}$，在已知输入激励 $X(s)$ 的情况下可以得到响应函数 $Y(s) = H_e(s)X(s)$，配合终值定理即可得到 $\lim_{t\to\infty} \phi_e(t)$；注意是相位误差是 (REF - FB) 而不是 (REF - OUT)；举个例子，在相位阶跃输入情况下，$X(s) = \frac{\Delta \phi}{s}$，有 $\phi_e(\infty) = \lim_{s\to 0} \Delta \phi \times \frac{N}{N + H_{OL}(s)} = 0$，而在频率阶跃输入的情况下，$X(s) = \frac{\Delta omega}{s^2}$，有 $\phi_e(\infty) = \lim_{s\to 0} \Delta \omega \times \frac{N}{s(N + H_{OL}(s))} = \frac{N \Delta \omega}{K_d Z_{LF}(0)K_{VCO}}$，也就是说频率阶跃输入下的稳态相位误差与 LPF 的直流增益成反比 (直流增益越大，稳态相位误差越小)，这也是一般都使用积分型 LPF 的原因 (稳态相位误差为零)。





**<span style='color:red'> ！！！！！直接替换 cell name 后, Macro Model Name 没改, 导致实际 netlist 没变??? </span>**



## References

