# Structure Options and Design Considerations for Analog PLLs

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 20:48 on 2025-10-13 in Beijing.

## 1. Overview

## 2. Design Considerations
## 3. Key Modules Structures
### 3.1 Ring Oscillator
### 3.2 LC Oscillator
### 3.3 PFD and CP
### 3.4 LPF
### 3.5 FD

## 4. D-Latch and D-Flipflop

### 4.1 Static DL/DFF


图 16.24(a) 就展示了一种典型的 PFD 结构：由两个 resettable D latch (DL) 和一个 AND Gate 构成，其中 D 触发器的输入端 "D" 连接到逻辑 "1" (VDD).

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-01-43-10_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>


上图 Figure 16.24 (b) 所示的 resettable D latch (flip-flop), 其实是由两个 SR latch 构成：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-02-42-33_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

其工作原理如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-10-02-43-33_Razavi CMOS - Chapter 16. Phase-Locked Loops - 16.2 Charge-Pump PLL.png"/></div>

### 4.2 Dynamic DL/DFF