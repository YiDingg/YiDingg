# Several Problems in Op Amp Measurement

> [!Note|style:callout|label:Infor]
> Initially published at 15:59 on 2025-03-22 in Beijing.

## Intro

先前，我们对运放 NE5532P 作了详细的测试，记录了其包括 V_IO, I_B, A_OP, CMRR, PSRR 等参数的测量过程与结果，实验记录见 [Op Amp Measurement of NE5532P](<Electronics/Op Amp Measurement of NE5532P.md>)。但是实验过程中，我们发现了一些问题，当时并没有能找到较合理的解释。因此，在这一篇文章中，我们将对这些问题进行分析与讨论。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-22-59-09_Several Problems in Op Amp Measurement.png"/></div>

## Problem 1: Abnormal Decreasing of DC Gain at Low Frequency

### Possible Cause 1 (已排除): RC 低通网络导致输入衰减

在上次的实验中我们已经提到过，测量 AC Gain 时所用的 RC 输入电路 (1nF + 1MOhm + 100Ohm) 是一个低通滤波器，会导致低频时输入信号有很大的衰减。所以我们当时处理数据时（即作图的时候），已经将 1nF 电容的阻抗考虑进去，这样得到的结果已经基本排除了输入低通衰减的影响。为了进一步验证，我们不妨将 1nF 电容更换为 1uF 电容，观察前后所得曲线是否有明显变化。

由于 WaveForm 的 Impedance 中无法同时作出两个具有不同公式的图（除非令用一个变量），我们将数据导出到 MATLAB 作图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-00-20-45_Several Problems in Op Amp Measurement.png"/></div>

可以看到，除了第一条曲线 (C = 1nF), 其它三条曲线基本没有差异，因此排除了 RC 低通网络导致输入衰减的可能性。第二至第四调曲线使用的电容分别是： 1uF 独石电容，正极指向开关的 220uF 绿金电解电容 (low ESR)，负极指向开关的 220uF 绿金电解电容 (low ESR)。


### Possible Cause 3 (待验证): 修正 RC 低通网络带来的低频增益测量误差

详见文章 [Correction of the AC Gain Equation in ADI's Op Amp Measurement Methods](<Electronics/Correction of the AC Gain Equation in the ADI Op Amp Measurement Methods.md>).




### Possible Cause 2 (待研究): 反馈网络导致的低频增益测量值下降

参考 [Bode 100 > Application Note: Operational Amplifier Measurements with Bode100](https://www.omicron-lab.com/fileadmin/assets/Bode_100/ApplicationNotes/Op-Amp_Analysis/App_Note_Op-AMP_FH_Regensburg_V1.2.pdf) 的 page 13 - page 16. 资料中指出，当运放通过一个低通滤波器将输出反馈到 inverting 输入端时，增益测量值与实际值的关系如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-00-43-00_Several Problems in Op Amp Measurement.png"/></div>

我们可以在 LTspice 中再次验证这个结论：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-00-57-04_Several Problems in Op Amp Measurement.png"/></div>

其中，增益测量值“恢复”到实际值的频率与低通网络的截止频率有关。具体而言，设低通网络的截止频率为 $f_c$，则增益测量值会在 $f_c$ 处开始上升 (这表明 $f_c$ 是增益测量值的零点)。为什么我们说上面这个理论很可能就是导致低频增益测量值下降的原因呢？我们的电路看似并没有接入低通反馈网络呀？其实，我们的测量电路是存在低通反馈网络的，它由 AUX 辅助运放 > 100kOhm > 



## Problem 2: Abnormal Increasing of AC Gain at High Frequency (Solved)

### Possible Cause 1 (验证成功): RC 输入电路衰减比降低导致增益测量值上升

当时测量 AC Gain 时，我们使用的是 1nF +  1MOhm + 100Ohm 的 RC 输入衰减器。因此我们猜测：由于 1MOhm 电阻比较大，可能带有相当的寄生电容，导致高频时“电阻”阻抗急剧下降，衰减器的衰减比降低（且比增益下降得快），导致所测得的增益在约 500kHz 之后出现异常上升。

现在，我们将输入电路更换为 10 nF + 20kOhm + 100 Ohm 的 RC 输入衰减器，观察增益的异常上升现象是否依然存在：
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-00-33-47_Several Problems in Op Amp Measurement.png"/></div>
 -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-00-38-13_Several Problems in Op Amp Measurement.png"/></div>

从图中可以看出，增益异常上升点已经从原先的约 500kHz 后移到 2MHz, 说明我们的猜测是合理的。也就是输入衰减器在高频时的衰减比下降，导致测得的增益上升。当然，我们不能绝对地说增益上升只有这一个原因，但它应该是最主要的一个。

### Possible Cause 2 (待验证): 运放输出阻抗升高导致增益测量值上升

下面这篇文献的测量结果中，也出现了与我们类似的现象，即“1MHz 左右增益测量值不降反升”。

- [https://ieeexplore.ieee.org/document/4315257](https://ieeexplore.ieee.org/document/4315257): W. M. C. Sansen, M. Steyaert and P. J. V. Vandeloo, "Measurement of Operational Amplifier Characteristics in the Frequency Domain," in IEEE Transactions on Instrumentation and Measurement, vol. IM-34, no. 1, pp. 59-64, March 1985, doi: 10.1109/TIM.1985.4315257.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-15-23-36-19_Several Problems in Op Amp Measurement.png"/></div>


## Problem 3: Abnormal Variation between DC and AC CMRR/PSRR



## References

- [Bode 100 - Application Note: Operational Amplifier Measurements with Bode100](https://www.omicron-lab.com/fileadmin/assets/Bode_100/ApplicationNotes/Op-Amp_Analysis/App_Note_Op-AMP_FH_Regensburg_V1.2.pdf)


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-23-01-11_Several Problems in Op Amp Measurement.png"/></div>


- [Bode 100 - Application Note: Op Amp Open Loop Gain Measurement](https://www.omicron-lab.com/fileadmin/assets/Bode_100/ApplicationNotes/Op-Amp_Analysis/2018-01-18_Appnote_open_loop_gain_V1.1.pdf)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-23-07-45_Several Problems in Op Amp Measurement.png"/></div>


- [SIMULATION AND MEASUREMENT OF OP AMPS](<https://aicdesign.org/wp-content/uploads/2018/08/lecture25-130418.pdf>)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-13-23-08-19_Several Problems in Op Amp Measurement.png"/></div>