# Introduction to SerDes and High-Speed Data Communication

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 02:09 on 2026-01-25 in Lincang.
> dingyi233@mails.ucas.ac.cn

## Introduction

我们在模电/数电课程中学到的通信协议，大多需要同时传输数据和时钟信号 (如 SPI, I2C 等)，但高速有线通信往往无法直接传输时钟信号 (因为高速信号线的数量有限，且时钟线极易受干扰)。于是人们就想：能不能只传输数据，然后在接收端从数据中恢复出时钟信号，从而实现通信？这就是时钟数据恢复 (Clock Data Recovery, CDR) 技术的基本思想。

在此基础上，人们又根据 CDR 本身特性，在发送端和接收端加入各种预处理和后处理电路 (如均衡器、扰码器、预编码器等)，以进一步提升通信性能和可靠性，逐渐形成了现代高速有线通信 (high-speed wireline) 系统的完整架构，这就是 SerDes (Serializer/Deserializer, 串并转换器) 技术的基本框架。

SerDes 主要有以下优点：
- (1) 减少布线冲突 (串行且无单独时钟线，时钟被嵌入在数据流中，同时也解决了限制数据传输速率的信号时钟偏移问题)；
- (2) 抗噪声、抗干扰能力强 (差分传输)；
- (3) 降低开关噪声；
- (4) 扩展能力强；
- (5) 更低的功耗和封装成本；

现代高速有线通信协议几乎全部依赖于 SerDes (Serializer/Deserializer, 串并转换器) 技术，它是构建当今数字基础设施的物理层基石。

在芯片与板级互连领域，PCIe (PCI Express) 是绝对主流，其版本已从早期的 1.0 演进至当前采用 PAM4 调制的 PCIe 6.0，并继续向更高速率发展，是 CPU/GPU/NVMe/SSD 等核心部件的主要连接方式。类似地，USB 和 SATA 协议的高速版本本质上也是 SerDes，它们支撑着外部存储和各类外设的通用连接。前沿的高级封装与 Chiplet (芯片互连) 技术则将 SerDes 的应用推向极致，使得单个封装内集成不同工艺和功能的裸片成为可能 (如计算芯粒与内存芯粒)，标志着高性能计算与系统集成的未来方向。

这些协议的实现正推动 SerDes 技术本身不断突破极限。可以说，从手机内部的处理器互连，到全球数据中心的光纤网络，SerDes 是实现所有高速数据流生成、传输与恢复的底层引擎，是现代高速数字世界不可或缺的支柱技术。

## 1. SerDes System Overview

## 2. Key Techniques in TX
### 2.1 FFE (Feed-Forward Equalizer)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-31-02-16-41_Introduction to SerDes and High-Speed Data Communication.png"/></div>

### 2.2 Pre-coding
### 2.3 Scrambling
### 2.4 Encoding

8b/10b 等编码：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-31-03-11-03_Introduction to SerDes and High-Speed Data Communication.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-01-31-03-11-42_Introduction to SerDes and High-Speed Data Communication.png"/></div>

### 2.5 PAM Signaling



### 2.6 

## 3. Key Techniques in RX
### 3.1 CTLE (Continuous-Time Linear Equalizer)
### 3.2 Slicing and Decision
### 3.3 DFE (Decision-Feedback Equalizer)
### 3.4 Clock Data Recovery (CDR)



## Chinese-English Translation Table

- SerDes (Serializer/Deserializer) - 串并转换器
- Serializer - 串行器 (并转串)
- Deserializer - 解串器 (串转并)
- PAM (Pulse Amplitude Modulation) - 脉冲幅度调制
- ISI (Inter-Symbol Interference) - 码间干扰
- BER (Bit Error Rate) - 误码率
- FEC (Forward Error Correction) - 前向纠错
- Equalization - 均衡
- Pre-emphasis/De-emphasis - 预加重/去加重
- FFE (Feed-Forward Equalizer) - 前馈均衡器
- DFE (Decision Feedback Equalizer) - 判决反馈均衡器
- CTLE (Continuous-Time Linear Equalizer) - 连续时间线性均衡器
- Pre-coder - 预编码器
- Scrambler - 扰码器
- Descrambler - 解扰码器
- Slicer - 判决/采样
- Clock Data Recovery (CDR) - 时钟数据恢复
- 

## Reference

文章/资料类参考：
- [{1} 知乎 > 同样冒雨 > SerDes 简单介绍](https://zhuanlan.zhihu.com/p/113737215)

文献类参考：
- [1] S. Chen, F. de Paulis, D. Stauffer, and B. Holden, “PAM3 - History, Algorithm, and Performance Comparison to NRZ and PAM4,” 2023, pp. 137–160. doi: 10.1007/978-981-99-4476-7_9.
