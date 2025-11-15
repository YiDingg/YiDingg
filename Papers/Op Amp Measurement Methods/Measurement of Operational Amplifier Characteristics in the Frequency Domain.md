# Measurement of Operational Amplifier Characteristics in the Frequency Domain

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 16:50 on 2025-04-15 in Beijing.

## Infor 

- Paper: [Measurement of Operational Amplifier Characteristics in the Frequency Domain](https://ieeexplore.ieee.org/document/4315257)
- DOI: [10.1109/TIM.1985.4315257](https://doi.org/10.1109/TIM.1985.4315257)
- Author:  [Willy M. C. Sansen](https://ieeexplore.ieee.org/author/37275189100) and ...
- Publication Date: 12 November 2007
- Published in: [ IEEE Transactions on Instrumentation and Measurement (Volume: IM-34, Issue: 1, March 1985)](https://ieeexplore.ieee.org/xpl/RecentIssue.jsp?punumber=19)

## Abstract


<details>
<summary>Abstract</summary>

A test circuit for the automatic measurement of integrated-circuit operational amplifiers in the frequency domain has been developed. The main advantage of this test circuit over those previously reported in the literature is that it uses buffers in the feedback loop to reduce the influence of the output impedance of the operational amplifier. A fit program has been developed to extract the relevant parameters such as the transfer characteristics, the common mode rejection ratio, and the power supply rejection ratio. Examples of measurements are added for several operational amplifiers.
</details>
<div>





<details>
<summary>AI 全文总结 (Kimi, 2025.04.15)</summary>

这篇论文的标题是《Measurement of Operational Amplifier Characteristics in the Frequency Domain》，由Willy M. C. Sansen、Michael Steyaert和Paul J. V. Vandeloof撰写，发表于1985年3月的《IEEE Transactions on Instrumentation and Measurement》。论文主要介绍了一种用于自动测量集成电路运算放大器（op-amp）频率域特性的测试电路，并提出了一种新的测量技术，以减少运算放大器输出阻抗对测量结果的影响。

### 背景知识
运算放大器（op-amp）是电子设备设计中最常用的线性电路之一。在大多数设计中，通常假设op-amp的性能是理想的，例如假设其差分模式开环增益非常高。然而，这种假设仅在低频下合理。在高频下，为了确保在单位增益跟随器模式下的无条件稳定性，增益会降低，因此需要内部相位补偿。补偿的关键在于了解op-amp在单位增益附近的传递特性。传统的传递函数测量技术通常会受到op-amp输出阻抗的影响。

### 研究方法
论文首先讨论了两种现有的测量方法，并指出它们在高频下会产生错误的结果。然后，作者提出了一种新的测量设置，通过在反馈环路中使用缓冲器来减少输出阻抗对测量传递函数的影响。

#### 现有测试电路
1. **第一种测试电路**：如图1所示，假设V(+)在交流（ac）地，差分模式开环增益由Vo与V(-)的比值给出。然而，当频率升高时，op-amp的输出阻抗（Z）呈感性，导致测量传递特性在1 MHz以上出现额外的峰值。
2. **第二种测试电路**：如图4所示，被测设备（D.U.T.）连接在直接反馈环路中。如果Vo被测量，可以计算出差分模式开环增益。但同样，高频下输出阻抗（Z）的影响会导致误差。

#### 新测试电路
新测试电路如图5所示，通过在反馈环路中添加一个额外的缓冲器来解决输出阻抗问题。缓冲器提供反馈信号，但输入信号不能通过缓冲器。通过分析小信号等效电路，得出传递函数。为了满足测量精度要求，添加了两个额外的缓冲器（图6中的缓冲器II和III），并进行了校准。

### 实验结果
实验中使用了HP3040网络分析仪和HP 9826桌面计算机来提供输入信号并控制测量过程。开发了一个拟合程序，通过最小二乘法将测量到的传递函数拟合到特定表达式中，从而提取出低频截距、极点等参数。

#### 测量结果
- **CMOS op-amp**：如图7所示，测量的传递特性可以覆盖整个网络分析仪的频率范围（10 Hz-10 MHz）。提取的参数包括低频截距、单位增益频率、相位裕度等，如表I所示。
- **其他op-amp**：表II列出了其他几种op-amp的测量结果，包括LM741、CMOS1、CMOS2、BIPOL和TLO81。这些结果表明，新测试电路能够准确测量高频下的开环增益和其他参数。

### 关键结论
1. **输出阻抗的影响**：在高频下，op-amp的输出阻抗会导致开环增益测量的误差。通过在反馈环路中使用缓冲器，可以显著减少这种影响。
2. **测量精度**：新测试电路能够准确测量高频下的开环增益、共模抑制比（CMRR）和电源抑制比（PSRR）。
3. **拟合程序**：开发的拟合程序能够通过最小二乘法提取传递函数的关键参数，如单位增益频率和相位裕度，从而为设计人员提供重要的设计参数。

### 其他测量
论文还讨论了如何使用相同的测试电路测量CMRR和PSRR，并提供了相应的测量结果和计算方法。例如，图8展示了LM741的共模增益和CMRR，图9展示了LM741的PSRR。

### 总结
这篇论文提出了一种改进的测试电路和测量技术，能够准确测量运算放大器在高频下的开环增益、CMRR和PSRR等关键参数。通过在反馈环路中使用缓冲器，有效减少了输出阻抗对测量结果的影响，提高了测量精度。开发的拟合程序进一步简化了参数提取过程，为电子电路设计人员提供了重要的工具和数据支持。
</details>
</div>



``` txt
Abstract: 

A test circuit for the automatic measurement of integrated-circuit operational amplifiers in the frequency domain has been developed. The main advantage of this test circuit over those previously reported in the literature is that it uses buffers in the feedback loop to reduce the influence of the output impedance of the operational amplifier. A fit program has been developed to extract the relevant parameters such as the transfer characteristics, the common mode rejection ratio, and the power supply rejection ratio. Examples of measurements are added for several operational amplifiers.
```

``` txt
AI 全文总结 (Kimi, 2025.04.15): 

这篇论文的标题是《Measurement of Operational Amplifier Characteristics in the Frequency Domain》，由Willy M. C. Sansen、Michael Steyaert和Paul J. V. Vandeloof撰写，发表于1985年3月的《IEEE Transactions on Instrumentation and Measurement》。论文主要介绍了一种用于自动测量集成电路运算放大器（op-amp）频率域特性的测试电路，并提出了一种新的测量技术，以减少运算放大器输出阻抗对测量结果的影响。

### 背景知识
运算放大器（op-amp）是电子设备设计中最常用的线性电路之一。在大多数设计中，通常假设op-amp的性能是理想的，例如假设其差分模式开环增益非常高。然而，这种假设仅在低频下合理。在高频下，为了确保在单位增益跟随器模式下的无条件稳定性，增益会降低，因此需要内部相位补偿。补偿的关键在于了解op-amp在单位增益附近的传递特性。传统的传递函数测量技术通常会受到op-amp输出阻抗的影响。

### 研究方法
论文首先讨论了两种现有的测量方法，并指出它们在高频下会产生错误的结果。然后，作者提出了一种新的测量设置，通过在反馈环路中使用缓冲器来减少输出阻抗对测量传递函数的影响。

#### 现有测试电路
1. **第一种测试电路**：如图1所示，假设V(+)在交流（ac）地，差分模式开环增益由Vo与V(-)的比值给出。然而，当频率升高时，op-amp的输出阻抗（Z）呈感性，导致测量传递特性在1 MHz以上出现额外的峰值。
2. **第二种测试电路**：如图4所示，被测设备（D.U.T.）连接在直接反馈环路中。如果Vo被测量，可以计算出差分模式开环增益。但同样，高频下输出阻抗（Z）的影响会导致误差。

#### 新测试电路
新测试电路如图5所示，通过在反馈环路中添加一个额外的缓冲器来解决输出阻抗问题。缓冲器提供反馈信号，但输入信号不能通过缓冲器。通过分析小信号等效电路，得出传递函数。为了满足测量精度要求，添加了两个额外的缓冲器（图6中的缓冲器II和III），并进行了校准。

### 实验结果
实验中使用了HP3040网络分析仪和HP 9826桌面计算机来提供输入信号并控制测量过程。开发了一个拟合程序，通过最小二乘法将测量到的传递函数拟合到特定表达式中，从而提取出低频截距、极点等参数。

#### 测量结果
- **CMOS op-amp**：如图7所示，测量的传递特性可以覆盖整个网络分析仪的频率范围（10 Hz-10 MHz）。提取的参数包括低频截距、单位增益频率、相位裕度等，如表I所示。
- **其他op-amp**：表II列出了其他几种op-amp的测量结果，包括LM741、CMOS1、CMOS2、BIPOL和TLO81。这些结果表明，新测试电路能够准确测量高频下的开环增益和其他参数。

### 关键结论
1. **输出阻抗的影响**：在高频下，op-amp的输出阻抗会导致开环增益测量的误差。通过在反馈环路中使用缓冲器，可以显著减少这种影响。
2. **测量精度**：新测试电路能够准确测量高频下的开环增益、共模抑制比（CMRR）和电源抑制比（PSRR）。
3. **拟合程序**：开发的拟合程序能够通过最小二乘法提取传递函数的关键参数，如单位增益频率和相位裕度，从而为设计人员提供重要的设计参数。

### 其他测量
论文还讨论了如何使用相同的测试电路测量CMRR和PSRR，并提供了相应的测量结果和计算方法。例如，图8展示了LM741的共模增益和CMRR，图9展示了LM741的PSRR。

### 总结
这篇论文提出了一种改进的测试电路和测量技术，能够准确测量运算放大器在高频下的开环增益、CMRR和PSRR等关键参数。通过在反馈环路中使用缓冲器，有效减少了输出阻抗对测量结果的影响，提高了测量精度。开发的拟合程序进一步简化了参数提取过程，为电子电路设计人员提供了重要的工具和数据支持。
```








## Circuit 1

> 注：论文事实上可以分为两部分，一部分讲 open-loop gain, 另一部分讲 CMRR ，我们在本文只讨论 open-loop gain 的部分，如果有必要， CMRR 会在之后另写一篇文章进行介绍。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-16-00-09-09_Measurement of Operational Amplifier Characteristics in the Frequency Domain.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-16-00-09-28_Measurement of Operational Amplifier Characteristics in the Frequency Domain.png"/></div>

注：上图中公式 (2) 的合理性有待斟酌，因为我们推导得到的结果与论文中不同。下面是我们的过程与结果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-16-00-11-05_Measurement of Operational Amplifier Characteristics in the Frequency Domain.png"/></div>

## Circuit 2

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-16-00-11-21_Measurement of Operational Amplifier Characteristics in the Frequency Domain.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-16-00-11-42_Measurement of Operational Amplifier Characteristics in the Frequency Domain.png"/></div>

上图公式 (3) 的合理性有待验证，因为我们还暂时没有自己推导一遍。

## Circuit 3

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-16-00-12-49_Measurement of Operational Amplifier Characteristics in the Frequency Domain.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-16-00-13-00_Measurement of Operational Amplifier Characteristics in the Frequency Domain.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-16-00-13-33_Measurement of Operational Amplifier Characteristics in the Frequency Domain.png"/></div>

## Circuit 4

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-16-00-13-49_Measurement of Operational Amplifier Characteristics in the Frequency Domain.png"/></div>

## Summary


论文事实上可以分为两部分，一部分讲 open-loop gain, 另一部分讲 CMRR 。其中，第一部分共提到了并分析了四种用于 open-loop gain measurement 的电路，分别是原文的 Fig.1, Fig.4, Fig.5 和 Fig.6。然后，作者给出了使用最后一种电路 (Fig.6) 的实验结果，并对所得结果进行了最小二乘拟合，且实验数据与理论拟合公式符合得非常好。