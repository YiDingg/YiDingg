# Design Sheet for Third-Order Type-II CP-PLL

> [!Note|style:callout|label:Infor]
> Initially published at 17:38 on 2025-08-15 in Lincang.

## Design Sheet

此锁相环结构的 Design sheet 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-24-19-51-06_Design Sheet for Third-Order Type-II CP-PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-24-19-51-32_Design Sheet for Third-Order Type-II CP-PLL.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-24-19-52-28_Design Sheet for Third-Order Type-II CP-PLL.png"/></div>

记得考虑 $R_P C_2$ 过大导致锁定后出现振荡问题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-24-19-53-18_Design Sheet for Third-Order Type-II CP-PLL.png"/></div>


## Relevant Links

理论准备：
- [Prerequisite Digital Electronics Knowledge for PLL](<AnalogIC/Prerequisite Digital Electronics Knowledge for PLL.md>)
- [Razavi CMOS - Chapter 13. Switched-Capacitor Circuits](<AnalogIC/Razavi CMOS - Chapter 13. Switched-Capacitor Circuits.md>)
- [Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL](<AnalogIC/Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.1 Simple PLL.md>)
- [Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 CP-PLL ~ 16.5 Applications](<AnalogIC/Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 CP-PLL ~ 16.5 Applications.md>)
- [Paper Reading - [F. Gardner] Charge-Pump Phase-Lock Loops](<Papers/Phase-Locked Loop/[F. Gardner] Charge-Pump Phase-Lock Loops.md>)



相关设计：
- [Design of A Third-Order Type-II Integer-N CP-PLL](<Projects/Design of A Third-Order Type-II Integer-N CP-PLL.md>)
- [PLL Behavior-Level Simulation using Cadence IC618](<AnalogIC/PLL Behavior-Level Simulation using Cadence IC618.md>)
- [PLL System-Level Simulation using LTspice](<AnalogIC/PLL System-Level Simulation using LTspice.md>) 