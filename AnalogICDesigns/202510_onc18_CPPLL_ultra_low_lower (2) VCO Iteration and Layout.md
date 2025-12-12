# 202510_onc18_CPPLL_ultra_low_lower (1)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 00:48 on 2025-10-17 in Beijing.

>注：本文是项目 [Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology](<Projects/Design of An Ultra-Low-Power CP-PLL in ONC 180nm Technology.md>) 的附属文档，用于全面记录 PLL 的设计/迭代/仿真/版图/后仿过程。

续前文 [202510_onc18_CPPLL_ultra_low_lower (1)](<AnalogICDesigns/202510_onc18_CPPLL_ultra_low_lower (1) VCO Design Iteration.md>), 本文继续记录 PLL 的设计进展。



## 10. Stage Summary

**2025.10.16 23:30 ~ 2025.10.17 00:40 与导师在腾讯会议上进行对接，讨论了一下进度和信息，会议纪要如下：**
- (1) 环路验证时未开 transient noise 导致结果虚优 (rms jitter 达到万分之几)，后面仿真时要注意开启 transient noise (开启后结果约在千分之二)
- (2) 我们目前主要验证的 VCO 是 0.625V 的 VBN + VBP 结构，导师认为此结构 (VBN + VBP) 不好，建议 **改为 VBP 结构** ，并且在 **VDD = 1.25V** 条件下查找最优参数
    - 导认为一方面 VBP 的功耗比 VBN + VBP 更低，另一方面可以将电容 C1/C2 接到 VCT/VDD 之间，抑制 VDD 方向传来的噪声 **(但是注意 VBP 结构的 KVCO < 0 为负)**
    - 对于导的看法，第一点等验证后便能揭晓，第二点我们不太赞同
- (3) 锁相环系统的输出频率，最后需要 1.25V 的摆幅，因为我们的 PLL 是为 1.25V 数字电路提供时钟的。如果 PLL 真的采用了 0.625V, 需要通过 buffer 将高电平扩展到 1.25V, 由于两者电源不同，推荐用 1.25V 下的开环差分放大器作为 buffer.
- (4) 关于 PLL 的环路参数，导师建议我们的电容稍大一些 (十几皮法)，然后电阻稍小一些 (几兆欧)，算是经验指导吧，同时可以适当减小噪声的影响
- (5) 需求方确定输出频率范围为 5/10/15/20 倍可调 (一路输出，四选一)，我们考虑用如下方案：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-15-27-39_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

## 11. PLL Loop Veri. (2)

### 11.1 simple test

保持 VCO 各项设置不变，开启 transient noise (10MHz) 重新仿真一下 PLL 环路。

5-stage VCO 中适用于 655.36 kHz 的第一、二、四个 VCO (TT, 27°C):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-01-05-59_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

5-stage VCO 中适用于 655.36 kHz 的第三个 VCO (VDD = 1.0V 那个) (all-corner):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-01-21-25_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

将第二个 VCO (VDD = 1.1V 那个) 直接拉到 VDD = 1.25V 看看:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-01-34-06_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

N = 20 @ (FF, 60°C) 时功耗为全工艺角最高，仿真出来是 423.6nA, 确实很大了。

### 11.2 VCO options (1.25V)

这里看看之前 "被我们筛掉的 VCO 参数" 直接拉到 VDD = 1.25V 后表现如何：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-15-45-32_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

采用以下 VCO 参数和环路参数范围进行扫描：
- VCO 
    - VDD = 1.25, LN = 1, WN = 0.38
    - VDD = 1.25, LN = 1, WN = 0.42
    - VDD = 1.25, LN = 2, WN = 0.42
- I_P = 4n, 6n, 10n
- C1 = 4p, 6p, 10p, 15p (C2 = C1/10)
- R1 = 4M, 7M, 10M, 15M

一共 432 组参数，环路筛选结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-14-44-01_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

在电流镜支路加了电阻和晶体管仍不行，说明不是映射支路导致的功耗问题：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-15-41-40_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-15-14-02_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-15-13-24_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

看来上面的几个 VCO 都不太行，但是注意到下面两点：
- (1) LN/WN = 1/0.22 的 VCO 达到了 4.586 THz/A @ 1.541 MHz 的功耗，说明此尺寸附近有满足指标的点
- (2) 上面尝试了三个 VCO, 它们由 pss/pnoise 仿真得到的 jitter 分别为 0.247UI, 2.858UI 和 0.088UI, 但是环路抖动结果却基本一致 (都在 2mUI 左右)，说明我们在挑选 VCO 参数时可以主要看功耗和频率，不必过于关注 VCO 的抖动



### 11.3 1.25V VCO sweep (1)

上一小节最后给出了两条线索，我们基于此进行更细致的参数搜索。设置环路参数和 VCO 参数范围如下进行扫描：
- 5-stage VCO (without RB):
    - VDD = 1.25
    - **VCT = VDD - 0.2**
    - LN = 0.36:0.18:1.80, 2.00
    - WN = 0.22:0.04:0.42

一共 60 组参数，筛选结果如下 (不用这个结果)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-16-41-18_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

顺便看一下环路全工艺验证结果：

<div class='center'>

| VCO1 (0.90/0.22) | VCO2 (0.90/0.26) | VCO2 (1.26/0.22) | VCO4 (1.08/0.30) |
|:-:|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-17-32-22_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-17-33-36_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-17-34-02_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-17-34-37_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div> |
</div>



<!-- <div class='center'>

| VCO | Results |
|:-:|:-:|
 | VCO1 (0.90/0.22) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-17-32-22_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div> |
 | VCO2 (0.90/0.26) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-17-33-36_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div> |
 | VCO2 (1.26/0.22) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-17-34-02_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div> |
 | VCO4 (1.08/0.30) | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-17-34-37_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div> |
</div>
 -->



**<span style='color:red'> 这里出现一个问题是，pss/pnoise 仿真结果与 pss 设定的基频有关： </span>**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-17-27-15_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

**于是重新进行 tran 仿真而非 pss/pnoise 仿真，结果如下：**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-17-29-09_202510_onc18_CPPLL_ultra_low_lower (1).png"/></div>

果然，VCO 的实际振荡频率远高于我们设置的基频，导致 pss/pnoise 仿真结果不准确。

不过，必须提到的是，这几个 VCO 参数在上面的环路验证中表现得其实还不错 (jitter 稍高一丢丢)，说明 VCO 的最大频率其实可以稍大一些，不必拘泥于 1MHz ~ 2MHz 这个范围。



### 11.4 1.25V VCO sweep (2)

为避免 pss 仿真不准确的问题，下面直接用 tran 仿真对 VCO 进行参数搜索，设置如下：
- 5-stage VCO:
    - VDD = 1.25
    - **VCT = VDD - 0.2**
    - LN = 0.36:0.36:3.60, 6
    - WN = 0.22:0.08:0.62, 1

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-17-57-41_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

唉，确实不堪大用，能满足功耗要求的 VCO 频率都太高了。

另外可以发现，tran 仿真得到的 VCO jitter (已开启 transient noise) 确实比整体环路 jitter 要低，后者大约是前者的 4 ~ 6 倍，这是符合直觉的。



### 11.5 1.25V VCO sweep (3)

这一小节试一下导师推荐的 VBP-only VCO 结构，参数范围保持不变，修改 **VCT = 0.1V** 进行扫描：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-18-22-17_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

为方便对比，将之前 VBN + VBP 的结果也放在这里：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-18-20-57_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

在相同尺寸下，相比 VBN + VBP， VBP-only 结构有以下变化：
- 频率升高 25\% 的情况下，功耗降低 50\% (两倍频率密度)；相当于频率不变的情况下，节省约 60\% 功耗
- 占空比有所恶化 (可通过调整 buffer 改善)
- 上升/下降速率有所恶化 (可通过调整 buffer 改善)

确实如导师所说，VBP-only 结构在功耗方面有一些优势，至于恶化的占空比和上升/下降速率，可以通过调整后级 buffer 来改善。



既然 VBP-only 结构表现不错，那么 VBN-only 结构 (只用 NMOS) 是否也有类似优势呢？下面进行对比：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-22-52-00_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

最后将三种结构的结果放在一起对比：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-22-52-23_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

嗯，这样看下来，VBP-only 和 VBN-only 的性能差不多，均优于 VBN + VBP 结构，前两者中，VBP-only 的功耗略胜一筹，而 VBN-only 的抖动更好一些，我们最后还是决定采用 VBP-only 结构作为 PLL 的 VCO。





### 11.6 loop veri.

上面的 VBP-only VCO 中，有一些性能是比较不错的，这里挑几个出来进行环路验证 (图中标为青色的三组参数)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-23-03-14_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

**注意 VBp-only 结构的 KVCO < 0, 需要将 PFD 的两个输入位置调换一下，并且将 LPF 的 "地端" 接到 VDD，然后给 VCONT 赋一个初值 VDD (模拟上电时 VCONT 跟随上升到 VDD).**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-23-02-05_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

全工艺角 (N = 20) 环路验证结果如下：
- VCO (VDD = 1.25V)
    - (1) LN/WN = 1.80/0.22
    - (2) LN/WN = 2.52/0.22
    - (3) LN/WN = 2.88/0.22
    - (4) LN/WN = 3.24/0.22
- Loop: I_P = 5n, C1 = 10p (C2 = C1/10), R1 = 6M

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-23-27-21_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-23-33-15_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-23-33-57_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

图中看出，虽然功耗都已经满足要求，抖动也还可以，但是出现几个新问题：
- (1) 输出波形占空比严重失调
- (2) 锁定时间明显变长

vout 波形基本上弄成这样了，这对 20 倍频直接输出是非常不可取的：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-17-23-38-57_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

## 12. VCO Optimization

这一小节优化 VCO 的输出占空比，可这个样子的输出波形，我们该如何下手呢？

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-00-01-59_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

注意到我们之前的 buffer 都是用 inverter, 这种 buffer 适用于 "对称电路"，也就是 VCO 波形上下比较对称的情况。其实只需换个思路，将 inverter buffer 换为差分输入的 buffer, 输出占空比便会好得多：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-00-21-25_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-00-22-53_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-00-24-05_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

用 OTA buffer 的另一个好处是，支路的电流是 well-defined 的，而 inverter buffer 的电流则可能很大。

一级效果不够好的话，可以试试两级：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-00-47-52_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

效果貌似更差了。改为 OTA + inverter 组合试试看：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-00-56-45_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

噢？M1 = M2 的数据貌似出奇地好，进一步仿真看看：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-01-03-10_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

在 OTA + inverter 组合的基础上，我们尝试了在 inverter 上方/上下方加一个被偏置的 MOS, 但效果都非常不好，不予考虑。

在环路中验证一下上面的 OTA + inverter buffer，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-01-21-00_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-01-23-58_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

嗯，上升/下降速度太慢了，不太能满足要求。


试一试 OTA + INV1 +INV2 的组合，效果似乎不错：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-01-26-33_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

代入环路验证一下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-01-35-04_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-01-35-26_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

在 FF 工艺角功耗比较大，并且随温度上升非常明显，试一试更小或大的 length 能否满足功耗要求：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-01-52-44_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-01-54-15_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

我们又尝试了 (1) 保持 a 不变升高 L; (2) 保持 L 不变升高 W; 但效果均不好。


## 13. VCO Sweep

为了探寻最佳参数，我们在环路中对 VCO 进行参数遍历：
- Loop: I_P = 8n, R1 = 10M, C1 = 10p (C2 = C1/10)
- VCO:
    - num of INV = 1 or 2
    - LN = 0.2:0.1:4.2
    - WN = 0.22:0.02:0.42

注意从 (TT, 27°C) 到 (FF, 60°C), 功耗大约增加 50\%, 因此要保证 (FF, 60°C) 下电流小于 300nA, (TT, 27°C) 下电流应小于 200nA (但是这太难做到).


一共 2\*41\*11 = 902 组参数，预估数据大小 902/36\*1.6GB = 40.1GB, 仿真耗时约 6.5h = 390min (32 job 并行)。实际数据大小 551.0 GB, 因为有一些参数陷入 **VCT = 0** 对应的高频波形，这些参数每一个都产生 37GB 数据 (而正常波形约 100MB)，需要用 fout < 700k (或者 vct_static > 0.2) 来筛去这些异常数据。


仿真结束后进行筛选，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-10-53-47_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-10-54-19_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

从这些数据中提取出最佳参数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-11-09-19_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-11-11-40_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>


后续部分只看 OTA + IN1 + INV2 的情况，调整 buffer multiplier 以获得更佳占空比：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-11-32-37_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>


经过这么多轮优化，此结构的 VCO 还是难以完全达到指标要求，主要问题有：
1. 占空比受 PVT 影响较大，难以精确校准
2. 部分温度/工艺角下功耗偏高
3. 锁定时间较长
4. 抖动表现较差

占空比、功耗、抖动、锁定时间这四个指标完全无法兼顾，只能选择性地优化其中几个，实在令人头疼。




## 14. VBN-VBP uhvt VCO (std Vth in fact)

>2025.10.20 23:50 注：由于我们在将 std Vth 器件替换为 uhvt 器件时，使用的是 "Find and Replace > Replace `cell name`"，但 onc18 这个工艺库生成网表使用的是 macro model name, 而不是像台积电工艺库那样用 cell name 去匹配仿真模型，导致看似替换了，实则并没有替换成功，所以本小节 **14. VBN-VBP uhvt VCO** 的所有仿真结果均为 std Vth 器件的结果，并非真正的 uhvt 器件结果。我们会在下一小节重新进行 uhvt 器件的仿真迭代，并更新相关结果。请读者注意区分！

为了突破上述瓶颈，我们回顾 VCO 最开始设计时考虑的 VDD = 0.625V VBN + VBP 结构，当时我们在这个结构上取得了非常不错的性能，基本上完全达到了指标要求。而现在我们的电源固定为 VDD = 1.25V, 能否延续 0.625V 的思路，设计出 1.25V 下也能取得类似好结果的 VCO 呢？

其实思路很简单，既然 VDD 升高了，那么我们就把 MOS 的 threshold voltage 也随之升高，这样就能在更高电压下 "重现" 0.625V 下的工作状态。考虑电压比值关系，低电源下为 Vth/VDD = 0.476/0.625 = 0.7616 (NMOS), 那么 1.25V 下的 Vth 应该为 0.7616 \* 1.25V = 0.952V, 这么高的 Vth 只能通过 uhvt (ultra high threshold voltage) 器件来实现，例如 nmosuhvt1p8v 的 Vth ≈ 0.809 V (0.703 ~ 0.916), 算是比较接近的。



简单验证一下 VBN-VBP uhvt VCO 的性能是不是有明显优势：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-15-26-48_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-18-15-26-15_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

可以看到优势非常明显，于是直接进入参数遍历：
- (1) 先同时遍历 LN, WN, KA 和 M2, 给出如下优秀参数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-19-00-06-01_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

- (2) 分别固定 M2 = 1 和 M2 = 2, 扫描 LN, WN, KA 以寻求最佳参数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-19-00-16-55_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-19-00-17-41_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

- (3) 结合上面两种情况，给出下面两组综合最优参数：
    - VCO1: M2 = 1, LN/WN = 1.50/0.22, KA = 2
    - VCO2: M2 = 1, LN/WN = 1.25/0.22, KA = 2.5

这两组最优参数的全温度-工艺角结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-19-01-36-21_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-19-00-45-10_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

这两组参数甚至在 -40°C ~ 130°C 也能保持非常良好的性能：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-19-01-46-12_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>



继续看一下第一组参数 (真正的最优参数) 在不同电源电压下的全工艺角表现：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-19-16-22-09_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-19-16-23-01_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

电路的工作范围非常广，整体看下来还是 VDD = 0.80V ~ 1.10V 表现最好。



## 15. VBN-VBP uhvt VCO (real uhvt)

这一小节重新进行 VBN-VBP uhvt VCO 的仿真迭代，这次确保了真正使用 uhvt 器件。



先验证一下 std 器件最佳参数 (LN/WN = 1.5/0.22, KA = 2) 在 uhvt 下是否有明显性能提升：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-00-31-07_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

非常明显的性能提升！


这么低的电流，我们完全可以将 VCO 输出频率抬高到 40 倍，然后二分频以进一步优化占空比，效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-00-19-30_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-00-25-50_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

非常好的输出性能！以及低得令人震惊的功耗工艺波动！

尽管目前这个参数下的性能已经非常好了，我们还是希望进行一次迭代，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-16-40-43_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-16-42-08_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

图中的三个优秀参数为：
- (1) KA = 1.0, LN/WN = 0.5/0.22
- **(2) KA = 1.0, LN/WN = 1.0/0.22**
- (3) KA = 2.5, LN/WN = 1.0/0.26

下面是这三组参数的全温度-工艺角表现：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-16-58-11_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>





## 16. VBP-Only uhvt VCO

2025.10.20 晚上与导师见面讨论了一下，导师仍然坚持使用 VBP-Only 结构。没办法，这里先验证一下之前 VBP best point 在 uhvt 下的表现：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-00-57-44_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-01-01-04_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

嗯……虽然功耗确实有所进步，但其它方面显然比不上 VBN-VBP 结构，ε=(´ο｀*))) 唉。而且这波形的 overshoot 也太大了吧。


再挣扎一下，做一个 1.28MHz 120 points 的扫描以寻求最佳参数 (MB = 1, M1 = 1, M2 = 3)，筛选结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-13-25-55_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

咦？抛开占空比不谈，似乎还真的有一些不错的点。我们看一下这九组参数的全温度-工艺角表现：
- (1) KA = 1.5, LN/WN = 1.0/0.22
- (2) KA = 1.5, LN/WN = 1.0/0.26
- (3) KA = 1.5, LN/WN = 1.0/0.30
- (4) KA = 1.5, LN/WN = 1.5/0.22
- (5) KA = 2.0, LN/WN = 1.5/0.22
- (6) KA = 1.5, LN/WN = 2.0/0.22
- (7) KA = 1.5, LN/WN = 2.5/0.22
- (8) KA = 2.0, LN/WN = 2.5/0.22
- (9) KA = 3.0, LN/WN = 1.5/0.30




<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-13-23-38_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-13-24-26_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-13-28-36_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

唉，结果可以看出，VBP-Only uhvt 结构的性能明显比不上 VBN-VBP uhvt 结构，我还是认为导师的坚持并不合理 (´ο｀*))).

上面九组参数，在要求最严格，需保证抖动、上升/下降速率的情况下，参数 (9) 为最佳，但是功耗较高 (269nA ~ 283nA)；而在要求稍宽松，可稍牺牲上升/下降速率的情况下，参数 (5) 188nA ~ 201nA 或者参数 (6) 228nA ~ 247nA 为最佳。下面是这三组参数的结果汇总：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-16-13-46_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>


## 17. VBP-Only std VCO 

这一小节重新对 VBP-Only std VCO 进行遍历，数据用于作图对比。

扫描结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-17-15-39_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-17-17-55_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

最佳参数的全温度-工艺角结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-17-46-21_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

## 18. Stage Summary (VCO)

到目前为止，我们已经尝试并迭代了多种 RVCO 结构，包括 VBN + VBP, VBP-Only, VBN-Only 以及前两种的 uhvt 版本，下面几张图总结了各架构的最佳性能情况：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-14-53-43_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-18-22-43_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-18-38-22_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

所有架构和方案中，最佳的有两个：
- 第一个是功耗最优：4.2 VBN + VBP (uhvt) @ 1.28MHz/2 (VCO.1)，在保证其它参数均不错的情况下能达到 140nA (最大 172nA @ FF 130°C) 的功耗，此时  RMS Cycle Jitter = 2.33 mUI
- 第二个是抖动最优：5.2 VBP-Only (uhvt)  @ 1.28MHz/2，在保证其它参数均不错的情况下达到 RMS Cycle Jitter = 1.84 mUI，此时 IDD = 209 nA (最大 231.61 nA @ FF 130°C)

<!-- 按导师要求，我们选择第二种方案 (其实我更愿意选第一种)。 -->

在进入版图之前，对方案进行一次全面的验证和评估，以确保其在实际应用中的可行性和稳定性，这包括：
- **(1) 在原理图中加入 parasitic res and cap 之后, 验证电路在大 RC 寄生范围下 (主要是电容) 的 (TT, 27°C) 性能**
- **(2) 验证电路在较小、中等、较大三种 RC 寄生下的全温度-工艺角性能**
- **(3) 验证电路在中等 RC 寄生、不同电源电压下的全温度-工艺角性能**


方案一加入寄生参数后的原理图和仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-19-47-09_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-20-22-30_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-21-25-51_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

方案二加入寄生参数后的原理图和仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-19-14-36_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-19-46-19_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-21-17-17_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

综合对比：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-21-20-47-11_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>


2025.10.21 晚上与导师讨论/辩论两个多小时后，确定最终方案：
- (1) 架构采用方案一 (uhvt VBN + VBP @ 1.28MHz/2)，只是上对 VCT 部分稍作修改以方便在 VCT/VDD 之间加一个滤波电容，
- (2) uhvt VBN + VBP 架构我们给出了两组最优参数，这两组我们都做版图和后仿验证，待整个环路搭建完毕之后，再根据整体性能二选一即可
    - VCO.1: KA = 1.0, LN/WN = 1.0/0.22 (better jitter)
    - VCO.2: KA = 2.5, LN/WN = 1.0/0.26 (better power)

修改后的 VCO 架构如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-00-30-21_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-00-32-34_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>

- (2) 环路参数留出 trimming 空间 (用 MOS 开关):
    - I_P = 8 nA (trimming 8 nA ~ 12 nA, 分为 2\*2 nA)
    - R1 = 10 MOhm
    - C1 = 10 pF (trimming 10 pF ~ 20 pF, 分为 2\*5 pF)
    - C2 = 1 pF





## 19. VCO2 Post-Layout Veri.

**<span style='color:red'> 这一小节对 VCO 进行版图和后仿验证。 </span>** 所用 RVCO 参数如下：
- 架构: uhvt VBN + VBP
- 参数：
    - VBN+VBP (uhvt) Best VCO.1: KA = 1.0, LN/WN = 1.0/0.22 (better power)
    - VBN+VBP (uhvt) Best VCO.2: KA = 2.5, LN/WN = 1.0/0.26 (better jitter)
- 注：这两组我们都做版图和后仿验证，待整个环路搭建完毕之后，再根据整体性能二选一即可

本小节做的是第二组参数 (VCO.2) 的版图和后仿验证，VCO.1 的版图和后仿验证见下一小节。

### 19.1 schematic veri.

将 schematic 中的参数从 variables 换为具体值，验证电路性能与替换前是否一致。

<!-- <div class='center'>

| Test Condition | Simulation Results |
|:-:|:-:|
 | **VCO.1** (1) Initial VCT = 0, VDD = {1.1V, 1.25V, 1.4V} <br> all-temp-corner | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-02-56_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-05-46_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> |
 | **VCO.1** (2) Initial VCT = 0, VDD = 1.25V, VDD rise time = {0.01, 0.1, 100}/CLK_REF = {0.305us, 3.05us, 3.05ms} <br> all-temp-corner | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-07-16_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-09-57_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-15-01_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> |
 | **VCO.2** (1) Initial VCT = 0, VDD = {1.1V, 1.25V, 1.4V} <br> all-temp-corner | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-01-03-45_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-01-06-18_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div> |
 | **VCO.2** (2) Initial VCT = 0, VDD = 1.25V, VDD rise time = {0.01, 0.1, 100}/CLK_REF = {0.305us, 3.05us, 3.05ms} <br> all-temp-corner | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-02-02-12_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-02-12-57_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-02-11-47_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div> |
</div> -->



<div class='center'>

| Test Condition | **VCO.1** (1) Initial VCT = 0, VDD = {1.1V, 1.25V, 1.4V} <br> all-temp-corner | **VCO.1** (2) Initial VCT = 0, VDD = 1.25V, VDD rise time = {0.01, 0.1, 100}/CLK_REF = {0.305us, 3.05us, 3.05ms} <br> all-temp-corner | **VCO.2** (1) Initial VCT = 0, VDD = {1.1V, 1.25V, 1.4V} <br> all-temp-corner | **VCO.2** (2) Initial VCT = 0, VDD = 1.25V, VDD rise time = {0.01, 0.1, 100}/CLK_REF = {0.305us, 3.05us, 3.05ms} <br> all-temp-corner |
|:-:|:-:|:-:|:-:|:-:|
 | **Simulation Results** | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-02-56_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-05-46_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-07-16_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-09-57_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-15-01_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-01-03-45_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-01-06-18_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-02-02-12_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-02-12-57_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div>   <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-22-02-11-47_202510_onc18_CPPLL_ultra_low_lower (2).png"/></div> |
</div>


嗯，前后性能是一致的，可以进入版图阶段。

### 19.2 layout example

与之前的做法类似，我们通过一个简单的反相器后仿来熟悉新工艺库得到版图风格和设计规则。之前 `tsmcN28` 的版图示例在 [here](https://zhuanlan.zhihu.com/p/1937319302949769830)，本次 `onc18` 的版图示例在 [onc18 (ONC 180nm CMOS Process Library)](<AnalogICDesigns/Basic Information of onc18 (ONC 180nm CMOS Process Library).md>) 的 **3. Layout Example** 一节。

### 19.3 VCO2 layout

我们先做 RVCO2 的版图和后仿，再视仿真情况考虑是否要做 RVCO1 的。

RVCO2 开始版图前的效果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-15-23-50_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>

先调整器件版图属性，再做布局排版：
- (1) 所有器件 Gate Contacts = both
- (2) PMOS align = 0.0, NMOS align = 0.5
- (3) PMOS 上下两组间距 = 0.30 (minimum p1 to p1 space = 0.25), NMOS 同理
- (4) PMOS ring (m1_n) enclose by 0.5 (然后放置一个大 NWell 恰好覆盖紫色 nimp), NMOS ring (m1_p) enclose by 0.5
- (5) guard ring 内部套上一个大的 nimp/pimp 以避免 nimp_to_nimp DRC 错误
- (6) 将最上一行的第三至七个 PMOS 设置为 MY (沿 Y 轴镜像翻转), 最下一行的 NMOS 同理

一些常见问题：
- DRC 报错 `naa_ui_nw: naa undersize of nw, if they interact is '0.12'`: nw 需完全覆盖 naa 且 enclose 一定距离，否则会报此错误 (恰好覆盖是不行的)

准备工作全部完成后，就可以开始走线了：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-16-00-51_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-15-59-43_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>

**<span style='color:red'> 注意走线需要尽量细，以保证较低的寄生电容 (寄生电阻影响极小)。 </span>** 每一个晶体管有两个 gate, 我们用细 m1 = 0.28um 将其合并后，把所有 gate 用过孔拉到 M2 来走线，部分特殊的 source/drain 网络 (例如 `OSC`) 也拉到 M2/M3 来走线。

先连接好 VCO core 的五个管子 (除去 VDD/VSS)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-16-31-23_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>

然后连接 VCO buffer 部分：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-17-09-30_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>

最后连接 VCT 和 VDD/VSS, 确认 DRC/LVS 均通过：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-17-25-14_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-17-26-20_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-17-24-07_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>


然后 PEX 提取寄生参数，这里强调几点设置：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-17-44-26_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-17-40-39_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>

导出后出现 `WARNING: Cannot enable LVS PUSH DEVICES because pin location information was requested.` 的警告，查阅 [this article](https://blog.csdn.net/weixin_54385241/article/details/140215290) 知道是正常现象，一般无需理会：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-17-50-01_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>


**<span style='color:red'> 注意原理图/版图中不要有除大小写外完全相同的 net, 否则后仿时 netlist 会报错说 "出现重复定义"。</span>**

导出结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-37-14_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>

VCO core 内部的几个网络，总寄生电容均在 0.2fF ~ 3.0fF 范围内，符合预期，由此推断后仿时除功耗有所增加外，其余性能不会有太大变化。

### 19.4 Loop Parameters

2025.10.22 晚，我们重新推导了一遍 Type-II CP-PLL, 给出了 PM 等关键参数的精确计算公式，详见这篇文章 [Loop Analysis of Typical Type-II CP-PLL](<AnalogIC/Loop Analysis of Typical Type-II CP-PLL.md>)。根据这些公式，我们将环路参数修改为：
- 环路参数: K_VCO = 4.7761 MHz/V, N_divide = 40, **I_P = 10 nA, R_P = 15 MOhm, C_P = 30 pF** (C_2 = C_1/10 = 3 pF)
- 环路参数：zeta = 0.5663, tau_P = 0.45 ms, BW = 4.75 krad/s = 0.756 kHz
- 环路性能：PM = 56.86°, ratio_BW = f_in/f_BW = 43.34

下面是一些其它参数的结果，用于参考对比：

<span style='font-size:12px'>
<div class='center'>

| (I_P, R_P, C_P) | tau_P | zeta | PM  | BW | BW ratio (f_in/f_BW) |
|:-:|:-:|:-:|:-:|:-:|:-:|
| (8  nA, 10 MOhm, 20 pF) | 0.20 ms | 0.2757 | 30.74° | 718.02 Hz | 45.64 |
| (8  nA, 15 MOhm, 20 pF) | 0.30 ms | 0.4136 | 44.37° | 762.02 Hz | 43.00 |
| (8  nA, 20 MOhm, 20 pF) | 0.40 ms | 0.5514 | 55.79° | 812.13 Hz | 39.91 |
| (10 nA, 10 MOhm, 30 pF) | 0.30 ms | 0.3775 | 40.99° | 683.71 Hz | 47.93 |
| (10 nA, 15 MOhm, 30 pF) | 0.45 ms | 0.5663 | 56.86° | 756.15 Hz | 43.34 |
| (10 nA, 20 MOhm, 30 pF) | 0.60 ms | 0.7551 | 67.89° | 849.97 Hz | 38.55 |
| (5  nA, 15 MOhm, 30 pF) | 0.45 ms | 0.4004 | 43.16° | 488.73 Hz | 67.05 | 
| (8  nA, 15 MOhm, 30 pF) | 0.45 ms | 0.5065 | 52.35° | 653.48 Hz | 50.14 |
| (10 nA, 15 MOhm, 40 pF) | 0.60 ms | 0.6539 | 62.57° | 690.56 Hz | 47.45 |
| (12 nA, 15 MOhm, 50 pF) | 0.75 ms | 0.8009 | 69.90° | 742.72 Hz | 44.12 |
| (15 nA, 15 MOhm, 50 pF) | 0.75 ms | 0.8954 | 73.36° | 882.44 Hz | 37.13 |


</div>
</span>


若无特殊说明，后仿均采用上述环路参数进行 **(I_P = 10 nA, R_P = 15 MOhm, C_P = 30 pF).** 并且将 PFD_CP_va 的输出上升下降时间从 `tt = 0` (0 其实是 1ns) 改为 `tt = 1p` (对应 1ps), 这会带来什么影响呢？由于上升/下降时间可以忽略，这会使 $V_{CT}$ 上出现大小为 $(\Delta V_{CT})_{pp} = I_P R_P $ 的纹波 (ripple)，导致 verilog 环路的 jitter 仿真结果比真实值要大 (主要是 cycle jitter)。

这是因为实际 Charge Pump 的电流上升/下降时间没有这么小，完全稳定之后不会输出理想的矩形窄脉冲电流，而是输出类似三角形的窄电流脉冲，使纹波 $(\Delta V_{CT})_{pp}$ 减小，因此实际电路的 jitter 比 verilog 环路结果要小。因此，我们在观察 verilog 环路仿真结果时 (特别是 Spectre FX)，可以用 Jcc (cycle-to-cycle jitter) 来估算 Jc (cycle jitter)，两者大约满足 $J_c \approx J_{cc} / \sqrt{2}$ 的关系。




### 19.5 VCO2 Post-Sim. (v1)



**<span style='color:red'> 注意进入到 Explorer 中设置 `Output > Save Options > lvl + level=1` 仅保存 top level 节点以节省空间。</span>**

RVCO2 v1 (M2 = 3) 仿真结果如下：



<!-- <div class='center'>

| Test Condition | Simulation Results |
|:-:|:-:|
 | **VCO.2** (1) Initial VCT = 0, VDD = {1.1V, 1.25V, 1.4V} <br> all-temp-corner | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-10-40-04_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-10-43-32_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> |
 | **VCO.2** (2) Initial VCT = 0, VDD = 1.25V, VDD rise time = {0.01, 0.1, 100}/CLK_REF = {0.305us, 3.05us, 3.05ms} <br> all-temp-corner | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-10-32-04_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-10-37-32_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> |
</div>

<div class='center'> -->



<div class='center'>

| Test Condition | **VCO.2** (1) Initial VCT = 0, VDD = {1.1V, 1.25V, 1.4V} <br> all-temp-corner | **VCO.2** (2) Initial VCT = 0, VDD = 1.25V, VDD rise time = {0.01, 0.1, 100}/CLK_REF = {0.305us, 3.05us, 3.05ms} <br> all-temp-corner | 结果汇总在表中 |
|:-:|:-:|:-:|:-:|
 | Simulation Results | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-10-40-04_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-10-43-32_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-10-32-04_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-10-37-32_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-11-07-58_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> |
</div>

上表的结果是用默认的 `Simulation Performance Mode = Spectre` 所得，我们也在 [这篇文章](<AnalogIC/Virtuoso Tutorials - 15. Several Methods for PEX (Parasitic Extraction) and Post-Simulation.md>) 中对比了 APS/X/FX 等高性能模式的仿真结果，结论是 Spectre X + CX 是综合性能和速度的最佳选择。后面也可能用 Spectre X + CX 以提高速度，到时我们会单独强调，否则均采用默认 Spectre.

**除功耗上升到 300.9n (294.7n ~ 321.4n) @ VDD = 1.25 外，其它性能均没有明显变化。** 但这个功耗还是有点高，毕竟我们将 VCO 输出接到 FD 之后功耗还会再上升一个台阶 (需要给寄生电容充放电)，所以还是再尝试一下 RVCO1 的版图和后仿，对比一下

<!-- 272.7n  (259n	~ 300.7n) @ VDD = 1.10 <br>
300.9n  (294.7n	~ 321.4n) @ VDD = 1.25 <br>
332.6n  (331.1n	~ 391.6n) @ VDD = 1.40  

2.253m  (1.89m	~ 2.51m)  @ VDD = 1.10 <br>
2.242m  (2.043m	~ 2.481m) @ VDD = 1.25 <br>
2.179m  (2.034m	~ 2.42m)  @ VDD = 1.40     

2.801m  (2.311m ~ 3.163m) @ VDD = 1.10 <br>
2.764m  (2.427m ~ 3.041m) @ VDD = 1.25 <br>
2.661m  (2.457m ~ 2.89m)  @ VDD = 1.40
 -->

<!-- 
300.9n  (294.8n ~ 321.4n) @ Rise Time = 0.01/CLK_REF
300.9n  (294.7n ~ 321.4n) @ Rise Time = 1.00/CLK_REF
300.8n  (294.6n ~ 321.3n) @ Rise Time = 100./CLK_REF

2.35m   (2.141m ~ 2.535m) @ Rise Time = 0.01/CLK_REF
2.245m  (2.044m ~ 2.481m) @ Rise Time = 1.00/CLK_REF
2.245m  (2.078m ~ 2.483m) @ Rise Time = 100./CLK_REF

2.818m  (2.69m  ~ 3.028m) @ Rise Time = 0.01/CLK_REF
2.768m  (2.428m ~ 3.041m) @ Rise Time = 1.00/CLK_REF
2.727m  (2.417m ~ 3.05m ) @ Rise Time = 100./CLK_REF
 -->

### 19.6 M2 Modification

RVCO 的输出只驱动一个 Integer-2 FD, 所以 rise/fall time 可以适当放宽，并且占空比要求很低，因此可以考虑减小 the multiplier of 2nd INV in VCO buffer 来降低功耗。


改变 M2 看看前仿效果：

<div class='center'>

| 参数总览 | 电流波形总览 | 上升沿波形细节 | 下降沿波形细节 |
|:-:|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-12-10-45_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-13-14-30_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-13-17-13_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-13-19-03_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> |
</div>

总的来讲，从 M2 = 3 改为 M2 = 1, 各方面性能基本不变，但功耗从 209.8 nA 降到 184.8 nA (12.5 nA/INV), 由此估计后仿功耗大概从 300.9 nA 下降到 265 nA 左右。



### 19.6 VCO2 Post-Sim. (v2)

原理图中修改至 M2 = 1 (同步修改 dummy num)，版图布局完全不变 (剩余的位置用 dummy 补上去)，效果如下：

<div class='center'>

| Schematic (RVCO2 v2) | Layout (RVCO2 v2) | DRC | LVS | PEX (HSPICE Tran) | (RVCO2 v2) Post-Sim. | (RVCO2 v2) Monte Carlo @ 200 points |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-13-28-27_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-13-28-38_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-13-30-52_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-13-31-10_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-13-36-52_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-20-51-11_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-16-23-38_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> |
</div>






## 20. VCO1 Post-Layout Veri.

### 20.1 schematic veri.

VCO1 的原理图验证已经在 **19.1 schematic veri.** 中做过，这里直接把结果搬下来：

<div class='center'>

| Test Condition | **VCO.1** (1) Initial VCT = 0, VDD = {1.1V, 1.25V, 1.4V} <br> all-temp-corner | **VCO.1** (2) Initial VCT = 0, VDD = 1.25V, VDD rise time = {0.01, 0.1, 100}/CLK_REF = {0.305us, 3.05us, 3.05ms} <br> all-temp-corner |
|:-:|:-:|:-:|
 | **Simulation Results** | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-02-56_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-05-46_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-07-16_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-09-57_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>    <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-26-18-15-01_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> |
</div>

### 20.2 M2 Modification

有了 VCO2 的后仿经验，我们也看看 VCO1 在不同 M2 下的前仿效果 (原先是 M2 = 1)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-12-10-12_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>

从 129.3 nA (M2 = 3) 降到 114.5 nA (M2 = 1) 一共下降 14.8 nA (7.4 nA/INV)，由此估计后仿功耗 (比前仿高 80 nA) 大概从 209.3 nA (M2 = 3) 下降到 194.5 nA (M2 = 1)。尽管 M2 = 1 的上升/下降速率稍有不足，但考虑到 VCO1 只需驱动一个 Integer-2 FD, 倒也没什么影响。因此就决定用 M2 = 1 来做版图。

### 20.3 VCO1 Post-Sim. (v1)


版图时先调整器件版图属性，再做布局排版：
- (1) 所有器件 Gate Contacts = both
- (2) PMOS align = 0.0, NMOS align = 0.5
- (3) PMOS 上下两组间距 p1 to p1 = 0.30 (minimum p1 to p1 space = 0.25), NMOS 同理
- (4) PMOS ring (m1_n) enclose by 0.5 (然后放置一个大 nw 恰好覆盖紫色 nimp), NMOS ring (m1_p) 同样 enclose by 0.5
- (5) guard ring 内部套上一个大的 nimp/pimp 以避免 nimp_to_nimp DRC 错误
- (6) 将最上一行的第三至七个 PMOS 设置为 MY (沿 Y 轴镜像翻转), 最下一行的 NMOS 同理


这里遇到一个问题是：由于管子宽度过小，设置 lg2ctd and lg2cts ("drain contact to gate" and "source contact to gate") = 0.20 时, M1 of gate 和 M1 of source/drain 之间的距离小于 0.23, 导致 DRC 报错 "m1_to_m1"。于是考虑将此值改为 **0.24** (without moving the MOSFETs, the horizontal pimp-to-pimp space changed from 0.50 to 0.42).



RVCO1 v1 (M2 = 1) 版图与后仿结果如下：


<div class='center'>

| Schematic (RVCO1 v1) | Layout (RVCO1 v1) | DRC | LVS | PEX (HSPICE Tran) | Post-Sim. @ VDD (RVCO1 v1) <br> Spectre X + CX |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-22-55-58_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-22-55-30_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-22-55-09_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-22-54-18_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-27-22-58-32_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-28-12-16-37_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> |
</div>

嗯，功耗情况和我们预测的非常接近，在 VDD = 1.25 V 下达到 194.6 nA (189.9 nA ~ 210.7 nA) and 2.583 mUI (2.357 mUI ~ 2.919 mUI) 这样子。别忘了经过 1/40 分频后, RMSJc 和 RMSJcc 会降低 $\sqrt{40}$ 倍，因此最终 jitter 表现肯定是更好一些的。


2025.11.02 补：做一下蒙特卡罗仿真，看一下考虑了 global/local variation 后的仿真结果：

<div class='center'>

| time_end = 3\*1600/(CLK_REF\*N) | time_end = 10\*1600/(CLK_REF\*N) |  |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-02-13-48-03_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> |  |  |
</div>


### 20.4 phase noise analysis

按照导师要求，我们需要给出 PLL 的如下噪声结果：
- (1) eye diagram (直观展示 edge jitter 和 edge-to-edge jitter): 直接从稳定后的 VCO 输出波形中截取若干周期 (例如 1000 个周期)，然后 plot 即可
- (2) phase noise spectrum: 需要根据锁定后的频率序列 ${f_{n}}$ 计算相位噪声谱，详见这篇文章 [Phase Noise and Jitter Calculation using MATLAB](<AnalogIC/Phase Noise and Jitter Calculation using MATLAB.md>).
- (3) integrated jitter (RMS): 通过相位噪声谱积分得到 RMS jitter, 需要利用第二步所还原 phase noise spectrum.

<div class='center'>

| Eye Diagram (3\*1600/CLK_REF) | Phase Noise (3\*1600/CLK_REF) | Phase Noise ( **30** \*1600/CLK_REF) |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-09-14-55_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | 仿真耗时 1.16 ks (19m  19.4s)  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-09-07-58_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div>  | 仿真耗时 13.5 ks (3h 45m 9s)  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-01-42-03_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> |
</div>

图中的低频相噪并不是很好，积分后 RMS Jitter (edge jitter) 达到了 50 mUI 级别。我们利用 Spectre FX + AX 进行一系列仿真，看看是不是环路参数或者 RVCO 本身的问题：


<div class='center'>

| RVCO1 (v1_calibre) | RVCO2 (v2_calibre) |
|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-09-54-03_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-01-09-55-11_202510_onc18_CPPLL_ultra_low_lower (2) VCO Iteration and Layout.png"/></div> |
</div>

看来并不是。

















































































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
    layout (注意修改复制后新 cell > layout 的 reference source, 不过其实只需要删除 physConfig 就能自动更新到本 cell)
    symbol
    v1_10272243_layout
    v1_10272243_PEX_HSPICE
    v1_10281026_layout
    v1_10281026_PEX_HSPICE


2025_PLL_RVCO1_layout_v2
    schematic
    layout (注意修改复制后新 cell > layout 的 reference source, 不过其实只需要删除 physConfig 就能自动更新到本 cell)
    symbol
    v2_10290000_layout
    v2_10290000_PEX_HSPICE
```

这样的好处是，可以直接用 config sweep 快速切换 2025_PLL_RVCO1_layout 的 schematic/v1_PEX/v2_PEX, 十分方便。具体例子见 [Virtuoso Tutorials - 16. Using Config Sweep and CALIBREVIEW to Speed Up Your Post-Layout Simulation](<AnalogIC/Virtuoso Tutorials - 16. Using Config Sweep and CALIBREVIEW to Speed Up Your Post-Layout Simulation.md>)。


例如下面这样 (用了 Spectre FX + AX 以提高仿真速度)：

<div class='center'>

| 性能汇总与对比 | 锁定波形图 | 电流波形图 | 电流 floor 波形 | 前后仿电流 floor 对比 |
|:-:|:-:|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-28-02-35-36_Virtuoso Tutorials - 16. Using Config Sweep and CALIBREVIEW to Speed Up Your Post-Layout Simulation.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-28-02-37-10_Virtuoso Tutorials - 16. Using Config Sweep and CALIBREVIEW to Speed Up Your Post-Layout Simulation.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-28-02-41-36_Virtuoso Tutorials - 16. Using Config Sweep and CALIBREVIEW to Speed Up Your Post-Layout Simulation.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-28-12-25-33_Virtuoso Tutorials - 16. Using Config Sweep and CALIBREVIEW to Speed Up Your Post-Layout Simulation.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-28-12-29-15_Virtuoso Tutorials - 16. Using Config Sweep and CALIBREVIEW to Speed Up Your Post-Layout Simulation.png"/></div> |
</div>




























