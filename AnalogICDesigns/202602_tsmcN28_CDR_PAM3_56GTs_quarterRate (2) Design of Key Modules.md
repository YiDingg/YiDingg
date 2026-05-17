# 202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (2) Design of Key Modules

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 13:48 on 2026-03-17 in Beijing.
> dingyi233@mails.ucas.ac.cn


> 注：本文是项目 [A 56 GT/s Quarter-Rate Reference-Less PAM3 CDR (84 Gb/s, 14 GHz) in TSMC 28nm Technology](<Projects/A 56-GTs PAM3 CDR (84 Gbps, 14 GHz) in TSMC 28nm Technology.md>) 的附属文档，用于全面记录 CDR 的设计/迭代/仿真/版图/后仿过程。
> 前置文章是：[202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work](<AnalogICDesigns/202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.md>)


## 7. CML BUF and Summer
### 7.1 overall architecture

下图展示了我们整个 PAM3 CDR 环路的完整架构 (未标出 lock detection)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-16-46-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.jpg"/></div>


### 7.2 overview of summers

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-47-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 上图源： [W.-J. Choi, J.-S. Jeong, H.-W. Lim, and B.-S. Kong, “A Power-and Area-Efficient DFE Receiver with Tap Coefficient-rotating Summer for IoT Applications,” in 2021 IEEE International Conference on Consumer Electronics-Asia (ICCE-Asia), Nov. 2021, pp. 1–4. doi: 10.1109/ICCE-Asia53811.2021.9641947.](https://ieeexplore.ieee.org/document/9641947/)



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-48-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 上图源：[A. Roshan-Zamir et al., “A 56-Gb/s PAM4 Receiver With Low-Overhead Techniques for Threshold and Edge-Based DFE FIR- and IIR-Tap Adaptation in 65-nm CMOS,” IEEE Journal of Solid-State Circuits, vol. 54, no. 3, pp. 672–684, Mar. 2019, doi: 10.1109/JSSC.2018.2881278.](https://ieeexplore.ieee.org/document/8580386/)



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-49-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 上图源：[Y. Kang, S.-M. Yu, J. An, W. Choi, and J. Song, “A 28Gb/s quad-rate 1-FIR 2-IIR DFE with 20dB Loss Compensation in 65nm CMOS Process,” in 2021 International Conference on Electronics, Information, and Communication (ICEIC), Jan. 2021, pp. 1–4. doi: 10.1109/ICEIC51217.2021.9369760.](https://ieeexplore.ieee.org/document/9369760)



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-55-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 上图源：[H. Park, Y.-U. Jeong, and S. Kim, “A 24-Gb/s/pin Single-Ended PAM-4 Receiver With 1-Tap Decision Feedback Equalizer Using Inverter-Based Summer for Memory Interfaces,” IEEE Access, vol. 10, pp. 91888–91896, 2022, doi: 10.1109/ACCESS.2022.3199429.](https://ieeexplore.ieee.org/document/9858044/)



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-56-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 上图源：[Y. Fu, Z. Wen, L. Chen, and J. Zhang, “A 3.75Gbps Configurable Continuous Time Linear Equalizer and 3-tap Decision Feedback Equalizer in 65nm CMOS,” in Proceedings of the 2016 4th International Conference on Machinery, Materials and Information Technology Applications, Xi’an, China: Atlantis Press, 2016. doi: 10.2991/icmmita-16.2016.300.](http://www.atlantis-press.com/php/paper-details.php?id=25868345)


### 7.3 reference CML BUF

把肖师兄提供的 `CML_SHIFT_V3` 拿出来仿真，观察其性能作为参考。这个 BUF 前加了一个 common-mode level shifter，使得整个模块的输入共模从 nmos-input 的 Vin_CM > xxx 变为 pmos-input 的 Vin_CM < xxx (这里是 < 300 mV)。

ac 和 dc 仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-22-03-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-22-07-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-22-10-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


### 7.4 design of CML BUF

这一小节来仔细研究一下 CML BUF 的设计，后面便可以此为基础搭建 Summer。

注意，为了降低电路带宽要求，我们将 CML Summer 放在了 S/H 模块之后，因此 Summer 的输入为 14 Gbaud/s 而非 56 Gbaud/s，所以后面仿真的时候注意带宽 **BW > 20 GHz** 左右即可。为模块后级 slicer 负载，先用 2 x 10 fF 作为负载挂着 (实际估计得更大)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-21-40-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>




首先是 CML BUF，如下图这样设置参数，扫描不同 Vin_CM 下的 dc/ac 结果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-21-05_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-29-25_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

设置 IDD = 800 uA 时，即便共模输入已达到 VDD，但电流镜的实际输出电流只有 Iss = 688.8 uA，显然是不够的。为解决这个问题，需要进一步增大电流管尺寸，或者换用阈值电压更低 (e.g. ulvt) 的管子。


先修改宽度看看效果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-39-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

固定 (fn, fw) = (12, 0.5 um)，看看全工艺角效果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-59-29_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，全工艺角下也没什么问题。看看 dc sweep 结果，主要关注输入范围和线性度。


不对，我们这里设置的是 Vin_CM = 0.9 V，应该设置为 0.6 V 甚至更低来遍历管子宽度，以保证 BUF 能在 Vin_CM >= 0.6 V 的范围内正常工作才对。调整后重新遍历，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-18-13-55_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


看起来不太行，我们将管子换为 lvt 的试一试：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-18-21-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，lvt 的话到时有几个可选项，比如 (fn, fw) = (10, 0.5 um) 就能满足要求。

然后再看看 ulvt 的情况，这也是之前师兄所用的阈值：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-18-28-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>




选择 ulvt @ (fn, fw) = (10, 0.5 um) 进行全工艺角 ac 验证，效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-21-37-28_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

以及其在 dc sweep 下的输入输出范围和线性度：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-21-45-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



嗯，看起来都还行。然后考察不同输入共模下的情况：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-21-55-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

也倒还可以。最后看看不同速率下的输出眼图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-22-33-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-22-34-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-22-37-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，都没什么问题。









### 7.5 channel loss model

为了得到更真实的输入眼图，我们用 `analogLib` 中的 `svcvs` 器件来模拟通道损耗 (channel loss)，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-00-14-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-00-16-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


``` bash
loss_factor dB@10G      dB@20G      dB@50G      BW_Hz
10m         -2.142	    -4.864	    -11.14	    13.56G
69.61m      -6.468	    -9.51	    -15.95	    1.449G
125.6m      -10.83	    -14.18	    -20.77	    16.43M
178.3m      -15.23	    -18.86	    -25.59	    2.325M
227.8m      -19.66	    -23.56	    -30.42	    985.1K
274.2m      -24.12	    -28.28	    -35.25	    509.6K
317.9m      -28.61	    -33.01	    -40.08	    300.4K
359m        -33.13	    -37.75	    -44.91	    214.3K
397.6m      -37.68	    -42.5	    -49.75	    169.7K
433.9m      -42.25	    -47.27	    -54.59	    142K
468m        -46.85	    -52.04	    -59.43	    121.9K
500m        -51.47	    -56.83	    -64.27	    107.6K
```

常规仿真从下面三组参数中选择即可：
- (1) loss_factor = 10m,  gain = -2.14 dB @ 10 GHz, -4.86 dB @ 20 GHz, -11.1 dB @ 50 GHz
- (2) loss_factor = 70m,  gain = -6.50 dB @ 10 GHz, -9.50 dB @ 20 GHz, -16.0 dB @ 50 GHz
- (3) loss_factor = 125m, gain = -10.5 dB @ 10 GHz, -14.0 dB @ 20 GHz, -20.5 dB @ 50 GHz
- (4) loss_factor = 230m, gain = -20.0 dB @ 10 GHz, -24.0 dB @ 20 GHz, -30.5 dB @ 50 GHz


仿真时遇到了报错：
``` bash
ERROR (ADE-5014): Variable 'libNameSel': value Test_Cadence not found in choices list (
```

是因为我们将 `svcvs` 的 symbol 复制到 `Module_ChannelLoss` 后，没有更新后者的 CDF 信息。




### 7.6 design of CML summer

搭建 CML Summer 如图：


先粗略设置 I_tap1 = 80 uA (Iss = 800 uA)，得到眼图结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-23-45-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

不同 tap weight 时的眼图结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-00-54-28_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


## 8. Design of Slicer

### 8.1 overview of slicers

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-51-08_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 上图源： [W.-J. Choi, J.-S. Jeong, H.-W. Lim, and B.-S. Kong, “A Power-and Area-Efficient DFE Receiver with Tap Coefficient-rotating Summer for IoT Applications,” in 2021 IEEE International Conference on Consumer Electronics-Asia (ICCE-Asia), Nov. 2021, pp. 1–4. doi: 10.1109/ICCE-Asia53811.2021.9641947.](https://ieeexplore.ieee.org/document/9641947/)




<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-48-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 上图源：[A. Roshan-Zamir et al., “A 56-Gb/s PAM4 Receiver With Low-Overhead Techniques for Threshold and Edge-Based DFE FIR- and IIR-Tap Adaptation in 65-nm CMOS,” IEEE Journal of Solid-State Circuits, vol. 54, no. 3, pp. 672–684, Mar. 2019, doi: 10.1109/JSSC.2018.2881278.](https://ieeexplore.ieee.org/document/8580386/)




<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-50-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 上图源：[Y. Kang, S.-M. Yu, J. An, W. Choi, and J. Song, “A 28Gb/s quad-rate 1-FIR 2-IIR DFE with 20dB Loss Compensation in 65nm CMOS Process,” in 2021 International Conference on Electronics, Information, and Communication (ICEIC), Jan. 2021, pp. 1–4. doi: 10.1109/ICEIC51217.2021.9369760.](https://ieeexplore.ieee.org/document/9369760)





<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-23-28-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 上图源：[判决反馈均衡器 DFE](https://www.eet-china.com/mp/a77946.html)




肖师兄 (XYD) 于 2026.03.04 提供的结构：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-15-07-35_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>




建议阅读这篇文章，理解 XCP (cross-coupled pair) 在 sense amplifier / slicer 中的作用：
> [知乎 > 模集王小桃 > 王小桃带你读文献：交叉耦合对在数字电路中的应用 (2) (The Cross-Coupled Pair - II)](https://zhuanlan.zhihu.com/p/1913642362875393925)


然后阅读这两篇文章，感受一下 StrongARM-Latch 结构的特点和设计：
> [知乎 > 模集王小桃 > 王小桃带你读文献：StrongARM Latch 比较器基本知识](https://zhuanlan.zhihu.com/p/16672774067)
> [知乎 > 模集王小桃 > 王小桃带你读文献：StrongARM Latch 比较器设计与仿真分析](https://zhuanlan.zhihu.com/p/16347220323)

### 8.2 design of StrongARM-Latch Slicer

在开始设计之前，先看一下设计要求：
- CK freq = 14 GHz (max freq. > 20 GHz)
- CML input, CMOS logic output
- input common mode = 0.6 V ~ 0.8 V
- input CML_IR = 200 mV ~ 400 mV
- CK to Q delay < 10 ps (ideally < 4 ps)

我们参考着前面这篇文章的设计来搭建电路：[知乎 > 模集王小桃 > 王小桃带你读文献：StrongARM Latch 比较器设计与仿真分析](https://zhuanlan.zhihu.com/p/16347220323)。论文中给出的 28nm 推荐尺寸为：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-15-31-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

``` bash
Recommended Sizes:
    S1~S4 = 1.0 um (X1)
    W1,2  = 10  um (X8)
    W3,4  = 5.0 um (X4)
    W5,6  = 2.5 um (X2)
    W7    = 2.5 um or 4.0 um (X2 or X4)

Recommended Following INVs: WP/WN = 400n/200n
```


设置尾电流源尺寸为 X2，在 14 GHz CK 得到仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-16-47-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

当前尺寸下 CK to Q delay 约为 10.0 ps，又尝试将尾电流管尺寸增大到 X4，得到 CK to Q delay 约为 7.2 ps。


随后一个新的 testbench 来做扫描/迭代优化，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-17-38-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

综合考虑输入管失配、功耗、面积和输出延迟，我们考虑采用如下参数：
- ka = 1.0
- totalW = 1.5u, fn = 1, fw = totalW/fn
- fl = 30n
- mu = 1
- **fn_tail = 8**

然后加入 SR-Latch 结构，不采用下图中带 INV 的这种 (会引入额外延迟)，而是直接修改成 pmos-input + nmos-XCP，如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-18-20-32_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


随着 SR-Latch 尺寸增大，原 Slicer_ENT 的输出延迟会有所增加 (负载增大)，而 SR-Latch 本身的输出延迟会减小，因此这中间有个最佳点，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-18-24-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

此时 Slicer 的输出延迟为 tcq ≈ 9.05 ps = 5.8 ps + 3.2 ps，也不算小了。


可以参考下面这种方式给任意 comparator 加入 threshold control:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-19-06-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


### 8.3 design of CML+XCP Slicer

这一小节参考下图来设计 CML+XCP Slicer：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-19-12-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

尝试了几种 modification 效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-19-37-09_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


### 8.4 find best architecture

经过好几个小时、杂七杂八的调试/尝试/修改/优化/重做，得到对比结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-23-48-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

然后是 `CDR_TB` 库中原本就有的这个 Slicer：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-23-51-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

从它们的输出波形再次对比一下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-23-56-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

无奈，我们所尝试的所有方案性能都不如 `CDR_TB` 库中的这个 Slicer 优秀，无奈只能将其原模原样复制过来用。


### 8.5 slicer verification

仿真发现，这个 slicer 的实际 sample instant 不像 StrongARM-Latch 那样正好在 pos-edge of CK，而是往前偏移大约 6.0 ps (这已经很大了)。背后原因是意料之内的：这种 slicer 电路在 XCP 前加入了一个 2-stage pre-amplifier (sense amp)，导致 DIN 输入端与 XCP 的实际输入存在一定延迟 (通常 3ps ~ 8ps)，体现到外围电路上就是 sample instant 会相应地往前偏移。下图是一个例子：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-01-16-35_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

作为对比，我们看一下 StrongARM-Latch 的表现：

**我们还额外发现，当前结构引入 VTH control 后，即便是 THP = 0，也会导致 CK to Q delay 严重恶化到 18ps ~ 28ps 左右。**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-01-22-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

我们也将其放入 CDR loop 进行了仿真测试，在未修改参数的情况下，环路不能正常工作，频率一直上升到 16 GHz 左右才停止 (为什么环路会认为 CK Slow 从而提高频率？)。


研究又陷入了瓶颈，该如何破局？

### 8.6 recap of StrongARM-Latch slicer

2026.03.06 决定重新回到 StrongARM-Latch 结构上来，因为我们之前提到过：加入 SR-Latch 之后的 StrongARM-Latch 能做到 tcq = 9.05 ps = 5.8 ps + 3.2 ps 的总延迟，这比上面这个参考结构还要好。而且 StrongARM 绝不会出现 sample instant 往前偏移的情况，因为它没有 pre-amplifier 结构，sample instant 就是 pos-edge of CK。

令 Slicer 带 2 x 5 fF 的负载进行参数扫描，得到结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-14-32-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

Slicer_ENT (不带 SR-Latch) 时的最佳参数为：
- (1) point.590, (ka, fw, fl, fn, fn_tail) = (1.50, 2.0u, 30n, 2, 12),  (t_cq_50%, t_cq_high_80%, t_cq_low_20%) = (5.016 ps, 10.50 ps, 10.01 ps)
- (2) point.330, (ka, fw, fl, fn, fn_tail) = (1.25, 1.4u, 30n, 2, 12),  (t_cq_50%, t_cq_high_80%, t_cq_low_20%) = (4.886 ps, 10.80 ps, 09.85 ps)
- (3) point.589, (ka, fw, fl, fn, fn_tail) = (1.50, 2.0u, 30n, 2, 08),  (t_cq_50%, t_cq_high_80%, t_cq_low_20%) = (5.819 ps, 10.90 ps, 10.61 ps)
- (4) point.150, (ka, fw, fl, fn, fn_tail) = (1.00, 1.6u, 30n, 2, 12),  (t_cq_50%, t_cq_high_80%, t_cq_low_20%) = (4.587 ps, 10.95 ps, 09.45 ps)

从波形上再验证一下这个结果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-14-37-32_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-14-38-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，确实没什么问题。

随后便是加入 SR-Latch 结构，我们先用 **(2) point.330, (ka, fw, fl, fn, fn_tail) = (1.25, 1.4u, 30n, 2, 12)** 这组参数来试试：在不同的 SRL 结构下，扫描 SRL 尺寸，得到结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-15-06-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-15-08-25_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

显然，XCP8T 具有最好的性能，且 fn_SRL = 2 时性能最佳，此时总 delay 约为 t_CK_to_Q = 15.69 ps 和 t_CK_to_QB = 10.85 ps。

带 SRL 的情况下，对所有参数进行扫描，看看能否得到更好的组合：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-15-46-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

所有参数中性能最好的也只能达到 t_CK_to_Q = 15.18 ps 和 t_CK_to_QB = 10.73 ps，区别不大。

综合考虑，我们选择下面组合作为最佳参数，它在 Slicer_ENT 和 Slicer_PET (带 XCP8T) 两种结构下都能得到最佳性能：
- **(ka, fw, fl, fn, fn_tail, fn_SRL) = (1.00, 1.6u, 30n, 2, 12, 2)**
- As Slicer_ENT: (t_cq_50%, t_cq_high_80%, t_cq_low_20%) = (4.587 ps, 10.95 ps, 09.45 ps)
- As Slicer_PET: 
    - (t_CK_to_Q, t_CK_to_QB) = (15.18 ps, 10.73 ps) @ Q from 1 to 0
    - (t_CK_to_Q, t_CK_to_QB) = (10.85 ps, 15.32 ps) @ Q from 0 to 1

其全工艺角验证结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-15-55-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



### 8.7 StrongARM with VTH control

在上面 StrongARM-Latch 的基础上加入 VTH control，验证结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-16-52-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-16-47-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，看来暂时没有什么问题。要特别注意的是：这里所用的 StrongARM + SRL 结构，输出端 Q/QB from 0 to 1 (rise delay) 的延迟稍小一些 (约 9.5 ps ~ 12 ps)，而输出端 Q/QB from 1 to 0 (fall delay) 的延迟稍大一些 (约 14 ps ~ 17 ps)。


在 PAM3 input 下验证看看：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-17-56-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-18-02-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，这里也没有什么问题，阈值控制是正常工作的。

最关键的一步来了，我们将其放入 CDR loop 中进行仿真，看看环路能否正常工作。 **这里仿真时发现，之前 THP/THN 的电压设置都错误了，忘了在差分电压基础上加共模电压，导致 VTH control pair 被关闭，实际阈值变为 zero，也许这才是之前 reference slicer 无法正常工作的原因？**

先把我们自己这个 StrongARM Slicer 仿了再说，结果如下：

（这里放图）

仿真时发现，当设置 THP = 66.67 mV (CML_IR = 200 mV) 时，无论输入是多少，Slicer 的输出总是 Q = 0 和 QB = 1。又到 TB_Slicer 中单独仿真了一下，也是这样，这是为什么？
经过检查，有以下几点不正常：
- (1) 由于未知原因 (或许是 Slicer 电流太大？)，VDD 从标称值 0.9 V 降到了 0.6 V 左右且稳定，下降了约 300 mV。其输出电阻为 10 Ohm 因此可推测 IDD_DC = 30 mA 左右，这个电流是哪里来的？
- (2) 由于 VDD 降低，导致 PRTS 输出的的 DINP/DINN 共模电平从 0.8 V 降到了 0.5 V，single-ended swing 仍为 200 mVpp (差分 400 mVpp)；而 Slicer 的阈值控制 THP/THN 电压是直接拿理想源来设置的，电压为 800 mV ± 66.67 mV，共模电平仍为 0.8 V，也许是这一点导致 DINP/DINN input pair 被关闭/出现异常，从而导致 Slicer 输出异常？


经过 TB_Slicer 测试，维持 VTH_CM = 800 mV 不变时，Slicer 允许的 DINP/DINN 共模输入范围是 DIN_CM > 650 mV，所以大概率就是这个原因导致的。至于为什么共模电平不一致会导致输入管异常？有待进一步分析。

为解决这个问题，我们：
- (1) 将 TB_CDR 中 THP/THN 的生成改为从实际 VDD 减去相应电压，也即 V(VDD) - CML_IR/2 ± THP；而不是直接拿理想源来得到 Vin_CM ± THP。
- (2) 为了使共模电平明显不同时输入管也能正常工作，将 TH control pair 从原尾电流脱离开来 (本来是和 input pair 共用一个 tail)，改为单独的 tail 电流源来驱动；这样在两者共模电平相同时，仍有实际阈值 = THP value，在共模电平不同时，虽不是完全相等，但也保持了正比关系，而不会使输入管产生异常。


修改之后，维持 VTH_CM = 800 mV 不变时，Slicer 在 400 mV ~ 900 mV 的共模输入范围内都能正常工作了。

注意不同的 VTH_CM 值也会稍微影响 Slicer 转换延迟 (输出延迟)，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-22-56-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


这个时候再放入 CDR loop 中仿真，结果是正常的：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-08-44-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



然后再仿一下 REF Slicer 在环路中的表现，结果如下：

（这里放图）



### 8.8 size iteration of slicer

这一小节对 StrongARM-Latch Slicer 进行尺寸迭代优化，看看能否得到更好的性能，原理图设置和仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-23-24-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-02-19-07_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

注意这里不小心将 VDD 设置为了 1.0 V，Vin_CM = 0.7 V 倒是还算正常，然后设置的是巨大的 Vin_DMP = 100 mV (Vin_DM = ± 200 mV)。 **但我们又忘记给后级 SRL 也设置 fn 了我靠。** 

上图可以观察到以下几点：
- (1) 随着 fw 增大，输出延迟逐渐减小，但 1.0um 以上时性能提升不是很明显了
- (2) 最佳 (fn1, fn2, fn3, fn4) 差不多为这几种：
    - (2, 2, 12, 18)
    - (2, 2, 10, 18)
    - (2, 2, 10, 16)
    - (2, 2,  8, 16)


从中筛选出综合性能最好，包括面积、功耗 (瞪眼法) 和输出延迟：
- (fw, fn1, fn2, fn3, fn4, fn_SRL) = (1.0u, 2, 2, 8, 16, 4)

其在不同 Vin_DMP 时的输出效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-02-32-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-08-36-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

相比原来 1.6u 宽度时的性能，这里其实稍有恶化，几乎所有延迟都增长了约 0.5 ps ~ 1.5 ps，对比图如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-08-55-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

但综合考虑版图 RC、功耗和面积，倒也可以接受。



### 8.8 pre-sim of StrongARM

这一小节记录一下 StrongARM 的前仿结果，利用 stair signal generator 搭建 testbench 以获得不同 THP 设置下的 actual_THP 以及各种 delay 性能，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-13-39-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-13-43-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


如果将 TH control 的 input pair 从 fn = 10 改为 fn = 6 (降低宽度，增大线性范围)，同时将 TH tail 从 fn = 12 改为 fn = 20 (与 input tail 相同)，得到的结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-13-49-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

这种情况下的 VTH control 具有更佳的线性度和线性范围，输出延迟倒是基本没变。


经过几次调整，我们考虑将 TH control 设置为 input fn = 6 和 tail fn = 16，这样在保持良好阈值控制性能的同时还能节省一些面积。此时的原理图和仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-14-06-16_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-14-05-45_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-14-13-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-14-10-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



### 8.9 use StrongARM as DFE

下面是使用 StrongARM-Latch 结构来搭建 DFE 的一些思路：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-02-39-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-02-39-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



### 8.10 post-sim of StrongARM

**<span style='color:red'>2026.03.07 00:55 经过与导师讨论，StrongARM 的话要注意 (1) kickback noise (回踢噪声) 和 (2) VDD noise 电源噪声对判决阶段的影响。尤其是我们的管子 unit fw = 1.4um 已经挺大了，会导致这两个噪声更加明显。</span>** 

这一小节完成 StrongARM-Latch Slicer 的 layout 和 post-sim 验证，看看后仿性能会恶化多少。上面 fw = 1.0um 时的尺寸被命名为了：
- `CDR_ulvt_1d0_1000nx2_30n_SRL_XCP8T_invIN`
- `CDR_ulvt_1d0_1000nx2_30n_Slicer_ENT_StrongARM`
- `CDR_ulvt_1d0_1000nx2_30n_Slicer_PET_StrongARM_SRL8T_inputTH`

原理图如下，尺寸稍有修改 (fn2 从 2 改为了 4)：
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-09-52-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-09-53-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div> -->

如果后面有所修改，会将上面的保存为 `BK_20260307_v1_initial`，然后新版本保存为 `BK_202603xx_v2_...` 以此类推。

**注意版图 data 方向是从左到右的，输入在左侧，输出在右侧。**


首先是 Slicer_ENT `CDR_ulvt_1d0_1000nx2_30n_Slicer_PET_StrongARM_SRL8T_inputTH` 的原理图和版图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-17-46-35_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-17-45-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-17-44-24_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


然后是 SRL8T `CDR_ulvt_1d0_1000nx2_30n_SRL_XCP8T_invIN_x2` (注意是 x2，也即 fn = 4 的 SRL) 的原理图和版图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-18-35-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-18-35-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-18-36-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


最后是 Slicer_PET `CDR_ulvt_1d0_1000nx2_30n_Slicer_PET_StrongARM_SRL8T_inputTH` 的原理图和版图。这里 Slicer_PET 就可以顺手把 VSS/VDD tap 连上了，而不是像 INV/NOR 那样把 tap 空着，布局效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-19-56-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

我们这里专门设计成了可上下拼接的布局，可直接堆叠连接 VDD/VSS 而不产生额外操作和 DRC 错误，效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-19-58-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-22-54-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


**间距最小时，TAP 距离 DUMMY PO >= 0.035um**



然后进行 post-sim 验证，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-23-07-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



心碎了，心碎了，心碎了，心碎了，心碎了，心碎了，心碎了，心碎了。后仿出来成了一坨：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-23-14-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


<!-- 经过验证，后仿时 StrongARM 即便在 Vin_CM = 0.6 V 且 Vin_DMP = +30 mV 时都不能正常工作。 -->

<!-- - Slicer_ENT 的输出 Q_PRE/QB_PRE，其 200 mV DM delay 从之前的
- 总的输出延迟，即 CK to Q of SRL delay 达到了 **20 ps (0 to 1) 和 27 ps (1 to 0)** ，之前约为 **10 ps (0 to 1) 和 15 ps (1 to 0)** 。
- 虽然这样仍能满足 14 Gbaud 的要求 (18 ps for Q_PRE/QB_PRE and 35.7 ps for CK to Q delay)，但与前仿相比确实掉了好多。
 -->



后仿时的 actual_THP 以及各种 delay 情况如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-16-10-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

简单来讲就是：
- (1) THP = 0 时的 actual_THP = +21 mV，整整 offset 了 22 mV
- (2) 典型输入 Vin_CM = 0.7 V, (Vin_DMP - THP) = +10 mV 时的延迟为：pre -> post
    - tcq_PRE_DM200mV =  9.8 ps -> 11.5 ps  (11.5 ps =  9.8 ps + 1.7 ps)
    - tcq_PRE_DM450mV = 12.8 ps -> 17.0 ps  (17.0 ps = 12.8 ps + 4.2 ps)
    - tcq_PRE_80%VDD  = 14.5 ps -> 21.0 ps  (21.0 ps = 14.5 ps + 6.5 ps)
    - tcq_SRL_0to1 = 18 ps -> 30 ps         (30 ps   =   18 ps + 7 ps + 5 ps)
    - tcq_SRL_1to0 = 24 ps -> 41 ps         (41 ps   =   24 ps + 7 ps + 10 ps)


这么大的延迟，既无法满足 36 ps 的 Q/QB 输出要求，也无法满足 18 ps 的 Q_PRE/QB_PRE 满摆幅输出要求。

**经过验证，calibre of SRL8T 对前面 Slicer_ENT 的影响/负载并不大，但是它本身会对 tcq_SRL_0to1 额外引入约 5 ps 的延迟，对 tcq_SRL_1to0 额外引入约 10 ps 的延迟，这也是导致 tcq_SRL 输出延迟大幅增加的主要原因之一。**


2026.03.08 补：我们还对 SRL 做了一个新版本 layout，第二版采用了最小/最细/最短布线，希望能够降低延迟恶化。但事实证明，采用最短布线时 SRL 的延迟性能并没有任何提升，甚至有非常轻微的恶化，仿真结果如下图 (注意这里用的 5TCML-XCP slicer 而不是 StrongARM)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-17-20-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



其实这里最大的问题不是 StrongARM 本身，毕竟虽然满摆幅输出延迟较大 (14.5 ps -> 21.0 ps)，但我们可以将 DFE 输入接口从原来的 "满摆幅 + 内嵌逻辑门" 改为 "多个 CML input pair"，这样也能实现补偿效果。主要是 StrongARM + SRL8T 构成的 Slicer_PET 输出延迟太大了，达到了 30 ps (0 to 1) 和 41 ps (1 to 0)，我们需要的是两延迟都小于 36 ps 才行，否则就得修改 Sample & Align 结构以放宽时序要求。

哦对，还有另外一个问题是 StrongARM 的实际 THP 偏离比较大，如果后面其它结构 Slicer 也有类似问题的话，估计得像 `CDR_TB > TR_Slicer_2p3_T28_REF_FOR_XYQ_V0` 那样引入一个 calibration input pair 来进行 THP 的偏移校准。




### 8.11 design of 5TCML-XCP slicer

StrongARM 被证伪之后，无奈只能回来重新设计 CML + XCP 结构的 Slicer，参考下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-17-48-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 上图源：[A. Roshan-Zamir et al., “A 56-Gb/s PAM4 Receiver With Low-Overhead Techniques for Threshold and Edge-Based DFE FIR- and IIR-Tap Adaptation in 65-nm CMOS,” IEEE Journal of Solid-State Circuits, vol. 54, no. 3, pp. 672–684, Mar. 2019, doi: 10.1109/JSSC.2018.2881278.](https://ieeexplore.ieee.org/document/8580386/)


但我们不是照搬上面的结构，而是像 StrongARM-Latch 那样在 CK = 0 时 reset，在 CK = 1 时进行判决，这样就能保证 sample instant 正好在 pos-edge of CK 上，而不是往前偏移了。

先试试下面这种结构，一组还算不错的参数是：(fw, fn1, fn2, fn3, fn4, fn_tail) = (1.0u, 6, 2, 12, 6, 12)，达到了 300 mVamp 的差分输出，以及 9.5 ps 的 half amplitude delay (输出达到 ±150 mV 时的延迟)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-07-23-51-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


先来个 2100 points 的扫描，注意这里设置的是 **Vin_CM = 0.7 V** ，看看性能分布情况：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-02-34-45_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


选择 (fw, fn1, fn2, fn3, fn4, fn_tail) = (0.8u, 6, 2, 12, 10, 10) 作为最佳参数，看看其在不同差分输入幅度、不同共模电平下的表现：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-02-57-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

合适工作条件下 (比如 Vin_CM <= 700 mV)，输出延迟大概是这样的：
- t_cq = 8  ps @ DM out = 100 mV
- t_cq = 13 ps @ DM out = 200 mV


在 Vin_DMP = +10 mV 的典型输入，其输出波形如下 (Vin_CM = 0.7)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-03-09-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

加入 SRL8T 之后，得到 CMOS logic 输出波形如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-03-26-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

从 CK 到 SRL 输出的延迟大概是 **21 ps (0 to 1) 和 30 ps (1 to 0)** ，这算是比较慢的了，Vin_CM 或 corner 稍微偏一点说不定就超过 35.7 ps 上限。





### 8.12 iteration of 5TCML-XCP slicer

没办法只能重新进行迭代，这次设置 **Vin_CM = 0.8 V** ，把 SRL 囊括进来扫描，一共 5400 points 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-15-31-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

5400 points 筛选出来只有这么一点，看来 Vin_CM = 0.8 V 对 ulvt 的管子实在是有些过高，使得管子电流过大，gm 发生饱和反而大幅下降，从而降低了电路速度和性能。也可能是 Vgs 过高导致管子进入线性区，从而 gm 下降。


选择 (fw, fn1, fn2, fn3, fn4, fn_tail, fn_SRL) = (1.0u, 8, 2, 10, 12, 14, 4) 作为最佳参数，其典型延迟情况如下：
- **using schematic of SRL8T_x2**
- condition: Vin_CM = 0.6 V, Vin_DMP = +20 mV
    - CML_DMSwing     = 510 mV
    - tcq_PRE_DM100mV = 7.0 ps
    - tcq_PRE_DM200mV = 10.1 ps
    - tcq_PRE_DM300mV = 12.7 ps
    - tcq_SRL_CKtoQ   = 21 ps or 30 ps
- condition: Vin_CM = 0.7 V, Vin_DMP = +20 mV
    - CML_DMSwing     = 450 mV
    - tcq_PRE_DM100mV = 6.5 ps
    - tcq_PRE_DM200mV = 9.7 ps
    - tcq_PRE_DM300mV = 12.5 ps
    - tcq_SRL_CKtoQ   = 20 ps or 28 ps
- condition: Vin_CM = 0.8 V, Vin_DMP = +20 mV
    - CML_DMSwing     = 344 mVamp
    - tcq_PRE_DM100mV = 6.5 ps
    - tcq_PRE_DM200mV = 10.8 ps
    - tcq_PRE_DM300mV = 16.5 ps
    - tcq_SRL_CKtoQ   = 20 ps (0 to 1) or 30 ps (1 to 0)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-17-43-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


和上面 fw = 0.8u 的这组参数也对比一下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-17-48-05_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，确实还是后面 fw = 1.0u 这组更好。



### 8.13 design of RCML-XCP slicer

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-18-33-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-18-30-05_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

效果不太行，还是必须得用 CK = 0 时会 reset 的 Slicer 结构才行，然后用 Slicer_ENT + SRL 构成 Slicer_PET 才有可能满足时序要求。



### 8.14 optimization of SRL8T

经过 StrongARM 后仿一节，我们意识到 SRL8T 的延迟性能不是很好，于是这一小节就来 "榨干" SRL8T 的性能，看看最低延迟能做到多少。

先对 SRL8T 的工作原理做简单分析，如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-20-16-27_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


保持 fw = 1.0u 不变，Slicer_ENT 使用 schematic of `CDR_ulvt_1d0_1000nx2_30n_Slicer_ENT_StrongARM_inputTH` ，参数扫描结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-23-41-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-20-23-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-20-24-16_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


以 (fn1, fn2, fn3, fn4) = (4, 1, 2, 2) 作为最佳参数，相比优化之前，性能变化如下：
- 优化之前 -> 优化之后
- tcq_PRE_DM200mV = 12.59 ps -> 11.55 ps (-1.04 ps)
- tcq_PRE_DM300mV = 14.14 ps -> 13.04 ps (-1.10 ps)
- tcq_PRE_DM450mV = 15.90 ps -> 14.73 ps (-1.17 ps)
- tcq_SRL_0to1    = 16.04 ps -> 13.31 ps (-2.73 ps)
- tcq_SRL_1to0    = 23.35 ps -> 22.87 ps (-0.48 ps)

嘶，虽然说整体延迟降低了 1 ps 左右，但是 tcq_SRL_1to0 的改善却非常有限，只有 0.48 ps，这样的优化还是不太够。

于是再细化参数进一步扫描，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-21-21-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

确实没有更好的参数了，看来 ulvt SRL8T 的性能已被榨干。


不妨也试试 std SRL8T 的性能，扫描结果如下 (Slicer_ENT 仍不变)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-21-44-55_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，std SRL8T 的性能，虽然 tcq_SRL_0to1 还可以，但是 tcq_SRL_1to0 实在太差 (毕竟要等 Q = 0to1 几乎完成后才能开始 QB = 1to0 的翻转)。


### 8.15 design of SRL10T

基于 SRL8T 的 transition 过程，我们就想：能不能在 Q = 0 to 1 的 transition 过程中就提前让 QB = 1 to 0 开始翻转？于是我们在原电路的基础上额外加入一个 PMOS input pair 来实现这个功能，不仅能提前开启 QB = 1 to 0 的翻转，还能进一步促进 Q = 0 to 1 的翻转，从而同时降低 tcq_SRL_0to1 和 tcq_SRL_1to0 的延迟。

具体电路结构及其工作原理如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-21-50-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-21-51-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.jpg"/></div>

扫描结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-22-11-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


选取 (fn1, fn2, fn3, fn4, fn5) = (4, 1, 2, 2, 2) 作为最佳参数，性能如下：
- SRL8T 优化之前 -> SRL8T 优化之后 -> SRL10T 优化之后
- tcq_PRE_DM200mV = 12.59 ps -> 11.55 ps (-1.04 ps) -> 12.37 ps (-0.18 ps, +0.82 ps) 
- tcq_PRE_DM300mV = 14.14 ps -> 13.04 ps (-1.10 ps) -> 13.86 ps (-0.28 ps, +0.82 ps)
- tcq_PRE_DM450mV = 15.90 ps -> 14.73 ps (-1.17 ps) -> 15.56 ps (-0.34 ps, +0.66 ps)
- tcq_SRL_0to1    = 16.04 ps -> 13.31 ps (-2.73 ps) -> 14.27 ps (-1.77 ps, +0.96 ps)
- tcq_SRL_1to0    = 23.35 ps -> 22.87 ps (-0.48 ps) -> 21.71 ps (-1.64 ps, -1.16 ps)



经过详细检查，发现 StrongARM 的 TH offset 过大并不是版图问题 (毕竟我们的版图已经非常对称和工整了)， **而是 reset 开关管尺寸不够大使 CK = 0 的半周期内无法完全 reset 导致的。** 因此我们先将 StrongARM 的 (其中一对) reset 开关管尺寸从 fn = 2 改为 fn = 4 并更新版图，然后再把优化后的 SRL8T/SRL10T 版图都做一下，看看后仿性能如何。


先是用优化前的 SRL8T_v1 + 更改后的 Slicer_ENT 进行后仿，结果如下：
- schematic -> calibre of Slicer_ENT_v2 + schematic of SRL8T_v1
- condition: Vin_CM = 0.7 V, Vin_DMP = +10 mV
    - tcq_PRE_DM200mV = 10.19 ps -> 19.54 ps (+ 9.35 ps)
    - tcq_PRE_DM450mV = 13.22 ps -> 25.08 ps (+11.86 ps)
    - tcq_SRL_0to1    = 17.89 ps -> 27.26 ps (+ 9.37 ps)
    - tcq_SRL_1to0    = 24.65 ps -> 36.64 ps (+11.99 ps)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-08-23-48-44_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


然后是 post-Slicer_ENT_v2 + pre-SRL8T_v2 的结果：
- schematic -> calibre of Slicer_ENT_v2 + schematic of SRL8T_v2
- condition: Vin_CM = 0.7 V, Vin_DMP = +10 mV
    - tcq_PRE_DM200mV = 10.05 ps -> 19.52 ps (+ 9.47 ps)
    - tcq_PRE_DM450mV = 12.94 ps -> 24.89 ps (+11.95 ps)
    - tcq_SRL_0to1    = 13.15 ps -> 19.00 ps (+ 5.85 ps)
    - tcq_SRL_1to0    = 23.94 ps -> 39.01 ps (+15.07 ps)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-00-56-27_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-01-19-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


最后是 post-Slicer_ENT_v2 + pre-SRL10T 的结果：
- schematic -> calibre of Slicer_ENT_v2 + schematic of SRL10T
- condition: Vin_CM = 0.7 V, Vin_DMP = +10 mV
    - tcq_PRE_DM200mV = 11.16 ps -> 18.89 ps (+ 7.73 ps)
    - tcq_PRE_DM450mV = 14.15 ps -> 24.33 ps (+10.18 ps)
    - tcq_SRL_0to1    = 14.49 ps -> 20.08 ps (+ 5.59 ps)
    - tcq_SRL_1to0    = 25.36 ps -> 35.27 ps (+ 9.91 ps)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-00-13-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



综合来讲确实是 SRL10T 性能更好一些，但后仿 tcq_SRL_1to0 仍然接近 36 ps，很容易超上限。





### 8.16 return to 5TCML-XCP slicer


加入 VTH control 之后，在使用 calibre of SRL8T_v1 的情况下进行参数扫描，一共 6000 points 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-01-53-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-15-59-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


选取 (fn1, fn2, fn3, fn4, fn5, fn_tail) = (6, 4, 6, 14, 16, 10) 作为最佳参数，看看其在不同后级 SRL 下的性能如何：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-16-22-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-16-25-49_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-17-37-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯……这个性能确实还算可以，具体数值如下：
- schematic of CMLXCP_inputTH + schematic of **SRL8T_v1** -> calibre of SRL8T_v1
- condition: Vin_CM = 0.7 V, Vin_DMP = +20 mV
    - CML_DMSwing     = 448 mVamp -> 445 mVamp
    - tcq_PRE_DM100mV =  8.43 ps ->  8.45 ps (+0.02 ps)
    - tcq_PRE_DM200mV = 12.08 ps -> 12.15 ps (+0.07 ps)
    - tcq_PRE_DM300mV = 15.14 ps -> 15.31 ps (+0.17 ps)
    - tcq_SRL_0to1    = 16.01 ps -> 18.09 ps (+2.08 ps)
    - tcq_SRL_1to0    = 22.94 ps -> 27.57 ps (+4.63 ps)
- schematic of CMLXCP_inputTH + schematic of **SRL10T**
- condition: Vin_CM = 0.7 V, Vin_DMP = +20 mV
    - CML_DMSwing     = 449.7 mVamp
    - tcq_PRE_DM100mV =  8.03 ps
    - tcq_PRE_DM200mV = 11.58 ps
    - tcq_PRE_DM300mV = 14.54 ps
    - tcq_SRL_0to1    = 14.18 ps
    - tcq_SRL_1to0    = 21.26 ps

**注意：将 variable 数值填入晶体管后再次仿真时，性能会稍有恶化 (整体延迟增长 +0.5 ps)，而前后晶体管尺寸并没有任何变化，可能是使用 variable 时部分寄生参数不能正确计算导致的。**

顺便看看其在较理想 Vin_DMP 下的眼图，也即调整 CK edge 位置使得 |Vin_DMP - THP| >= 20 mV：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-17-58-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-18-15-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

眼图可以看出 SRL8T_v2 在 reset 阶段存在误码可能，如果后面用它的话需要注意这一点 (用严密的全工艺角后仿进行考察)。




### 8.17 post-sim of 5TCML-XCP slicer

这里接着上一小节来做版图和后仿。版图效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-20-55-32_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-20-54-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

后仿结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-21-44-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

心碎 💔💔💔💔💔💔💔💔💔💔💔💔💔💔💔💔💔，这后仿掉得比 StrongARM 还多，人家起码后仿 tcq_SRL_0to1 还挺快，这个无论 QPRE 还是 SRL_out 都完全不行了。



### 8.18 design of 8TCML slicer


这一小节尝试肖师兄之前推荐的 slicer 结构：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-09-23-17-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

扫描结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-00-52-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-01-03-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

上图可以看出，这种结构确实是不怎么好的，理由有下：
- (1) reset 由 active load (PMOS) 的断开来实现，当 CK = 0 时 pmos 关闭，Q/QB 都被拉低到 VSS 而不是 VDD；而每次启动时 Q/QB 共模电平会被拉高到 600 mV ~ 700 mV，从 VSS 到这么高的电压自然需要更长的实际，导致延迟增大。
- (2) 单单 CML stage 这一级的延迟就不小了，更别说后面还加一个带 reset 的 Latch stage，而且想要完整的 CMOS logic 输出还得在 1st latch 后面再加一个 latch，最后都不知道延到哪八百年




### 8.19 design of modified 7TXCP slicer

这一小节来尝试一下 modified double-tail slicer 结构，参考下图中的 (c)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-06-23-28-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 上图源：[判决反馈均衡器 DFE](https://www.eet-china.com/mp/a77946.html)


先试试 XCP7T + SRL10T 的组合，看看性能如何：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-01-32-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

前仿只能达到 tcq_SRL_1to0 = 27.23 ps，这性能实在是不够好啊。


不疯魔，不成活。我们直接将晶体管 fn 上限增大到 28 甚至 32 (slicer 这么点面积消耗完全不用管)，我就不信后仿还会掉这么多。扫描结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-16-34-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

上图中，设置的 fn 上限为 32，从 0.6u -> 0.8u -> 1.0u 的性能情况如下：
- schematic of 7TXCP + schematic of SRL10T
- condition: Vin_CM = 0.7 V, Vin_DMP = +20 mV
- best points: (fw, fn1, fn2, fn3, fn_tail) = (0.6u, 16, 32, 6, 32) -> (0.8u, 12, 32, 6, 32) -> (1.0u, 12, 32, 6, 32)
    - CML_DMSwing     = 649.0 mVamp -> 701.7 mVamp -> 704.6 mVamp
    - tcq_PRE_DM100mV =  6.31 ps ->  6.30 ps ->  6.04 ps
    - tcq_PRE_DM200mV =  8.42 ps ->  7.84 ps ->  7.81 ps
    - tcq_PRE_DM300mV =  9.90 ps ->  9.41 ps ->  9.00 ps
    - tcq_SRL_0to1    = 10.67 ps -> 10.87 ps -> 10.49 ps
    - tcq_SRL_1to0    = 19.05 ps -> 18.36 ps -> 17.93 ps
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-16-58-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

选择 (fw, fn1, fn2, fn3, fn_tail) = (1.0u, 16, 32, 6, 32) 作为较优参数，并在此基础上尝试进一步迭代：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-17-11-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


最终选择 **(fw, fn1, fn2, fn3, fn_tail) = (1.0u, 16, 40, 8, 40)** 作为最佳参数，看看其在不同后级 SRL 下的性能如何：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-17-42-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


### 8.20 iteration of SRL10T

与前面类似，我们大幅提高 SRL10T 的 fn 上限，看看其性能极限如何。使用 schematic of 7TXCP + schematic of SRL10T 进行扫描，先看看 **SRL 使用 std. Vt** 时的性能：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-17-53-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-18-07-44_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-18-19-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

经过三次迭代，确定 **std. Vt SRL10T** 的最佳参数为 **(fn1, fn2, fn3, fn4, fn5) = (16, 1, 6, 12, 8)**，此时性能如下：
- schematic of 7TXCP + schematic of std SRL10T
- condition: Vin_CM = 0.7 V, Vin_DMP = +20 mV
    - CML_DMSwing     = 699.7 mVamp
    - tcq_PRE_DM100mV =  6.55 ps
    - tcq_PRE_DM200mV =  8.56 ps
    - tcq_PRE_DM300mV =  9.90 ps
    - tcq_SRL_0to1    = 10.55 ps
    - tcq_SRL_1to0    = 15.54 ps


然后试试 ulvt 版本的 SRL10T，扫描结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-18-33-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-18-42-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

经过两次扫描迭代，确定 **ulvt SRL10T** 的最佳参数为 **(fn1, fn2, fn3, fn4, fn5) = (12, 1, 4, 12, 10)**，此时性能如下：
- schematic of 7TXCP + schematic of ulvt SRL10T
- condition: Vin_CM = 0.7 V, Vin_DMP = +20 mV
    - CML_DMSwing     = 699.7 mVamp
    - tcq_PRE_DM100mV =  6.52 ps
    - tcq_PRE_DM200mV =  8.50 ps
    - tcq_PRE_DM300mV =  9.82 ps
    - tcq_SRL_0to1    =  9.31 ps
    - tcq_SRL_1to0    = 13.16 ps
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-22-19-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

确实还是 ulvt SRL10T 的性能更好一些。


难道说，希望又重新燃起了吗？我们先不急着做版图和后仿，先把 StrongARM 也重新迭代一次试试。



### 8.21 iteration of StrongARM slicer

和上面类似，将 StrongARM 的 fn 上限大幅提高，看看性能极限如何。使用刚刚优化得到的 ulvt SRL10T_v2 进行仿真，扫描结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-19-01-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-19-10-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-19-25-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-19-35-54_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

经过三次迭代，确认 **StrongARM slicer** 的最佳参数为 **(fw, fn1, fn2, fn3, fn4, fn_tail) = (1.0u, 40, 36, 8, 10, 40, 40)**，此时性能如下：
- schematic of StrongARM + schematic of ulvt SRL10T_v2
- condition: Vin_CM = 0.7 V, Vin_DMP = +20 mV
    - CML_DMSwing     = 864.6 mVamp
    - tcq_PRE_DM100mV =  7.36 ps
    - tcq_PRE_DM200mV =  9.71 ps
    - tcq_PRE_DM300mV = 11.18 ps
    - tcq_SRL_0to1    = 10.72 ps
    - tcq_SRL_1to0    = 14.38 ps



### 8.22 post-sim of 7TXCP slicer

7TXCP 的性能比 StrongARM 要好些，更别说前者版图面积更小，所以这一小节先来做 7TXCP + SRL10T 的版图和后仿，看看性能如何。

按导师说法，相同参数下的 RF 管子可以比普通管更接近后仿效果，于是用 RF 管来验证看看，眼图如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-23-58-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-10-23-56-54_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

这里的是将 slicer sampling point 调整到 |Vin_DMP| >=  130 mV 下得到的眼图，然后是各种 delay 的对比结果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-00-07-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

RF 管仿出来的性能确实更接近后仿，总结如下：
- rf schematic of 7TXCP + rf schematic of ulvt SRL10T_v2
- condition: Vin_CM = 0.7 V, Vin_DMP = +20 mV
    - CML_DMSwing     = 699.7 mVamp -> 677 mVamp (-22.7 mVamp)
    - tcq_PRE_DM100mV =  6.52 ps -> 13.32 ps (+6.80 ps)
    - tcq_PRE_DM200mV =  8.50 ps -> 16.97 ps (+8.47 ps)
    - tcq_PRE_DM300mV =  9.82 ps -> 19.48 ps (+9.66 ps)
    - tcq_SRL_0to1    =  9.31 ps -> 16.32 ps (+7.01 ps)
    - tcq_SRL_1to0    = 13.16 ps -> 23.95 ps (+10.79 ps)

虽然各项延迟有大幅增加，但 RF 管仿出来的性能总归是符合要求了。

另外，从具体波形可以看出，reset 管子 (fn3) 似乎有些不够大，无法完全复位，因此这里我们将 fn3 = 8 增大到 fn = 10，此时的参数为：
- (fw, fn1, fn2, fn3, fn_tail) = (1.0u, 16, 40, 10, 40)

不妨用 RF 管也做一下迭代扫描，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-00-26-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>s


嗯……还是按 RF 仿真结果为准，我们将最佳参数修改为：
- **(fw, fn1, fn2, fn3, fn_tail) = (1.0u, 18, 40, 12, 40)**
- rf schematic of 7TXCP + rf schematic of ulvt SRL10T_v2
- condition: Vin_CM = 0.7 V, Vin_DMP = +20 mV
    - CML_DMSwing     = 658.5 mVamp
    - tcq_PRE_DM100mV = 11.21 ps
    - tcq_PRE_DM200mV = 15.06 ps
    - tcq_PRE_DM300mV = 17.73 ps
    - tcq_SRL_0to1    = 14.59 ps
    - tcq_SRL_1to0    = 22.23 ps
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-00-43-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，虽然在差分输入较小时，Q/QB 会在 conversion 初始有异常上升/下降，但后续 DFF 做 align 并不会出现误码情况，因此这个性能是完全可以接受的了：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-00-45-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>




按新的参数进行版图设计，版图效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-14-31-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


后仿结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-14-33-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

后仿数据总结在这里：
- calibre of 7TXCP + rf_schematic of ulvt SRL10T_v2
- condition: Vin_CM = 0.7 V, Vin_DMP = +20 mV
    - CML_DMSwing     = 658.5 mVamp -> 491.9 mVamp (-166.6 mVamp)
    - tcq_PRE_DM100mV = 11.21 ps -> 19.43 ps (+8.22 ps)
    - tcq_PRE_DM200mV = 15.06 ps -> 25.68 ps (+10.62 ps)
    - tcq_PRE_DM300mV = 17.73 ps -> 30.07 ps (+12.34 ps)
    - tcq_SRL_0to1    = 14.59 ps -> 21.97 ps (+7.38 ps)
    - tcq_SRL_1to0    = 22.23 ps -> 31.92 ps (+9.69 ps)



## 9. Design of Slicer (2)

### 9.1 tcq_SRL_CKtoQ < 72 ps

2026.03.11 我突然意识到： **<span style='color:red'> 我们之前一直纠结于 slicer 无法达到 "tcq_SRL_CKtoQ < 36 ps" 这项指标，但事实上这个延迟只需要小于 CK period = 72 ps 即可！！！ </span>** 只需在 slicer 后面额外加入一排 DFF，比如 slicer at CK<0> 然后 DFF at CK<0>，这样便无需修改原本的 sample and align 结构，直接搬过来接在其后即可！最终也只是相当于 sample and align 结构多引入了一个 CK period 的数据延迟而已。

按这个思路，其实从 1\*delta_t ~ 8\*delta_t 之间的任何一个点都可以作为 tcq_SRL_CKtoQ 的上限指标，只需对应更改 slicer 后续 DFF 的时钟位置即可。

在这种情况下，我们唯一需要特别优化的只有 Q_PRE/QB_PRE 在 18 ps 时的输出效果，这个是用来做 DFE feedback 的，自然是越快、摆幅越高越好。


这显然是一个好消息，之前不知为何完全没有想到这一点。虽说确实令人振奋，但也有些尴尬了，毕竟之前我们为了追求更短的 tcq_SRL_CKtoQ 而对 slicer 进行了大量的迭代和优化，浪费了将近一周的时间。



回顾了一下前面做过后仿的 StrongARM, 5TCML-XCP 和 7TXCP 的性能，它们的 16ps 后仿性能均不是很好，一般只有几十个 mV 这样子：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-15-46-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

不过竟然是 StrongARM 的性能最好，还是有些出乎意料的。


### 9.2 ref slicer from XYD

仿了以下肖师兄提供的这个 slicer，差分输出只有几十 mV，明明几乎无法工作啊：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-17-31-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-17-30-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-17-57-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

差分输出达到 tcq_PRE_DM50mV ≈ 16 ps @ pre-sim，这显然是一个及其糟糕的性能了。

肖师兄发过来的眼图，差分输出足足有 400 ~ 500 mVamp，完全不一样，也不知道他是咋仿出来的。我们这里还是坚持自己的思路。



### 9.2 iteration of 5TOTA

于是这一小节尝试迭代 5TOTA 的性能，看看能不能在 16 ps 时得到更高的摆幅。

5TOTA 的原理图和迭代结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-16-01-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-16-08-54_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

果然是不太行，无论输出摆幅还是速度都不太好调，遂放弃这种结构。


### 9.3 iteration of 7TXCP

之前我们迭代 7TXCP 时是以 tcq_SRL_1to0 作为性能指标的，当时得到的结果是：
- schematic of 7TXCP + schematic of SRL10T
- condition: Vin_CM = 0.7 V, Vin_DMP = +20 mV
- pre-sim @ (1.0u, 12, 40, 6, 32) -> rf @ (1.0u, 18, 40, 12, 40) -> post-sim @ (1.0u, 18, 40, 12, 40)
    - CML_DMSwing     = 704.6 mVamp -> 658.5 mVamp -> 491.9 mVamp
    - tcq_PRE_DM100mV =  6.04 ps -> 11.21 ps -> 19.43 ps
    - tcq_PRE_DM200mV =  7.81 ps -> 15.06 ps -> 25.68 ps
    - tcq_PRE_DM300mV =  9.00 ps -> 17.73 ps -> 30.07 ps
    - tcq_SRL_0to1    = 10.49 ps -> 14.59 ps -> 21.97 ps
    - tcq_SRL_1to0    = 17.93 ps -> 22.23 ps -> 31.92 ps

显然，由于管子 fn 数太大，寄生参数非常明显，导致 pre-sim -> rf -> post-sim 的性能掉得非常厉害，尤其 tcq_PRE_DM 几乎是原来的三倍多。



7TXCP 的迭代结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-16-34-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

最佳参数及其 rf-sim 结果如下：
- schematic of 7TXCP + calibre of SRL8T_v1
- condition: Vin_CM = 0.7 V, Vin_DMP = +20 mV
- (fw, fn1, fn2, fn3, fn_tail) = (1.0u, 6, 16, 4, 16)
- pre-sim -> rf-sim
    - CML_DMSwing     = 729.2 mVamp -> 717.6 mVamp (-11.6 mVamp)
    - tcq_absDMat16ps = 658.7 mV -> 232.6 mV (-426.1 mV)
    - tcq_PRE_DM100mV = 7.053 ps -> 11.54 ps (+4.487 ps)
    - tcq_PRE_DM200mV = 9.125 ps -> 15.13 ps (+6.005 ps)
    - tcq_PRE_DM300mV = 10.50 ps -> 17.53 ps (+7.03 ps)
    - tcq_SRL_0to1    = 16.40 ps -> 21.88 ps (+5.48 ps)
    - tcq_SRL_1to0    = 28.37 ps -> 34.27 ps (+5.9 ps)

我的天啊，这里 tcq_absDMat16ps 虽然能在 pre-sim 达到 658.7 mV，但 rf-sim 就已经掉到 232.6 mV 了，说不定 post-sim 还会掉到约 100 mV 左右，这差得也太多了。



### 9.4 iteration of 5TCML-XCP

5TCML-XCP 的我们也试过了，仍然不行，还不如 7TXCP 的性能好。



### 9.5 iteration of StrongARM

在重新开始迭代前，先看看之前所得 StrongARM 的全工艺角后仿性能如何，也算有一个大概参考。 **注意这里我们用 spectre 而非 SpectreXCX 来仿真，顺便验证验证两者仿真差别如何** 全工艺角 (TT/SS/FF @ -40°C ~ +130°C) 仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-18-39-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-18-44-16_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，全 PVT 下性能虽有波动，但都能正常工作，尤其是 tcq_SRL_CKtoQ 都小于 48 ps，满足 72 ps 要求。


顺便把前仿也给做了，得到性能如下：
- schematic of StrongARM + calibre of SRL8T_v1 -> calibre of StrongARM + calibre of SRL8T_v1
- (fw, fn1, fn2, fn3, fn4, fn_tail) = (1.0u, 16, 8, 4, 4, 20)
- condition: VDD = 0.9 V, Vin_CM = 0.7 V, Vin_DMP = +20 mV, CL_se = 10 fF
    - CML_DMSwing_amp = 894.2 mV (880.4 ~ 896.4) -> 795.4 mV (646.4 ~ 854.8)
    - V_absDMat16ps   = 613.6 mV (364.3 ~ 782.7) -> 104.5 mV (56.41 ~ 161.2)
    - tcq_PRE_DM100mV = 7.995 ps (6.574 ~ 10.02) -> 15.71 ps (13.19 ~ 20.44)
    - tcq_PRE_DM200mV = 10.55 ps (8.602 ~ 13.10) -> 20.34 ps (17.27 ~ 25.64)
    - tcq_PRE_DM300mV = 12.10 ps (9.872 ~ 14.99) -> 23.09 ps (19.64 ~ 28.83)
    - tcq_SRL_0to1    = 18.21 ps (15.11 ~ 21.81) -> 27.40 ps (23.09 ~ 33.00)
    - tcq_SRL_1to0    = 29.70 ps (24.89 ~ 35.14) -> 39.62 ps (33.48 ~ 47.19)
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-18-38-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


这里的前仿性能可作为 pre-sim 迭代时的指标参考，pre-sim 迭代结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-19-48-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-19-54-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

迭代之后的全工艺角性能如下：
- schematic of StrongARM + calibre of SRL8T_v1
- (fw, fn1, fn2, fn3, fn4, fn_tail) = (1.0u, 16, 8, 4, 4, 20)
- condition: VDD = 0.9 V, Vin_CM = 0.7 V, Vin_DMP = +20 mV, CL_se = 10 fF
    - CML_DMSwing_amp = 896.0 mV (883.0 ~ 897.3)
    - V_absDMat16ps   = 735.9 mV (518.9 ~ 843.5)
    - tcq_PRE_DM100mV = 7.411 ps (6.064 ~ 9.031)
    - tcq_PRE_DM200mV = 9.526 ps (7.742 ~ 11.62)
    - tcq_PRE_DM300mV = 10.81 ps (8.770 ~ 13.20)
    - tcq_SRL_0to1    = 17.48 ps (14.49 ~ 20.86)
    - tcq_SRL_1to0    = 28.84 ps (24.18 ~ 34.02)

相比迭代之前的性能，这里 V_absDMat16ps 确实有一定提高，估计后仿性能也会有所提升，值得做一做版图。



### 9.6 comparison between ref and ours

在相同条件的 NRZ input 下，将肖师兄的 slicer 和我们的 slicer 作后仿对比，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-11-21-37-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-12-03-02-27_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

显然，如果 summer 驱动能力足够的话，我们的 StrongARM 是最佳选择。






## 9. Design of DFE

### 9.1 full-rate DFE loop

跟肖师兄和导师仔细讨论了一下，决定先搭个 DFE 环路再做下一步打算。由于之前的 StrongARM 性能已经比较好了，所以先在这个基础上搭一个 DFE 环路看看效果如何。

先看看 DFE 的理想效果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-12-03-34-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.jpg"/></div>


设置 actual THP = +100 mV，采用 StrongARM 和 summer 搭建 1-tap DFE 时效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-12-18-55-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-12-02-38-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

将 (RC_timeConstant, ITAP1) = (0.8, 40 uA) 时的眼图拿出来做对比，DFE 效果就比较明显了。下面分别是 DIN_unideal, Summer w/o DFE 和 Summer w/i DFE 的眼图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-12-02-42-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


下面是设置 actual THP = +100 mV 时，使用 DFE 以降低误码率的一个成功例子：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-12-02-35-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-12-19-15-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

其中黄线/蓝线分别为 DIN_unideal 和 Summer w/o DFE，可以看到在没有 DFE 的情况下会出现误码，而加入 DFE 后就被成功纠正了。


``` bash
ideal_Q_H
ideal_QB_H
ideal_Q_L
ideal_QB_L

slicer_Q_H
slicer_QB_H
slicer_Q_L
slicer_QB_L

slicer_Q_H_2tap
slicer_QB_H_2tap
slicer_Q_L_2tap
slicer_QB_L_2tap

DFF_Q_H_2tap
DFF_QB_H_2tap
DFF_Q_L_2tap
DFF_QB_L_2tap
```

2-tap 也没有什么问题，效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-12-19-35-37_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



### 9.2 quarter-rate DFE loop (1)

搭建 quarter-rate DFE 时，发现原先临时用的 summer 带载能力不够，在后面挂两个 StrongARM slicer 时输出电压出现明显 slewing，如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-12-19-50-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

奇怪的是，在前面 full-rate 时，summer 的输入速率也是 14 GT/s，后面也挂了两个 StrongARM slicers (使用 calibre)，但当时为什么能正常输出？

没办法，还是找不到原因。无奈只能重新来设计 CML summer，详见下一小节。



### 9.3 design of CML summer



设置 tap 管子宽度为 main 管宽度一半进行扫描，同时默认 **CL_se = 20 fF** 。

首先是 R = 0.5 kOhm 时的情况：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-12-21-28-35_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

其中有四组参数还算可以，分别为：
- R = 0.5 kOhm, CL_se = 20 fF
- dc_gm,  Av_dB @ DC,  Av_BW,  Av_GBW
- (Iss, fw, fn1, fn_tail) = (1.5m, 600n, 12, 4): 6.095m, 2.219, 28.79G, 37.17G
- (Iss, fw, fn1, fn_tail) = (1.5m, 800n, 10, 4): 6.367m, 1.831, 30.47G, 37.62G
- (Iss, fw, fn1, fn_tail) = (1.5m, 600n, 16, 4): 6.829m, 1.674, 31.85G, 38.63G
- (Iss, fw, fn1, fn_tail) = (1.5m, 1.0u, 10, 4): 6.916m, 1.013, 34.22G, 38.45G


然后是 R = 0.25 kOhm 时的情况：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-12-21-48-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

其中有五组参数不错，分别是：
- **R = 0.25 kOhm**, CL_se = 20 fF
- dc_gm,  Av_dB @ DC,  Av_BW,  Av_GBW
- (Iss, fw, fn1, fn_tail) = (2.0m, 600n, 12,  8): 7.458m, 3.327, 31.14G, 45.68G
- (Iss, fw, fn1, fn_tail) = (2.0m, 800n,  8,  6): 6.968m, 3.284, 30.10G, 43.93G
- (Iss, fw, fn1, fn_tail) = (2.0m, 800n, 10, 10): 7.906m, 3.221, 32.42G, 46.97G
- (Iss, fw, fn1, fn_tail) = (2.0m, 1.0u,  8, 10): 7.913m, 3.149, 33.04G, 47.47G
- (Iss, fw, fn1, fn_tail) = (2.0m, 1.0u, 12, 10): 9.569m, 3.142, 35.55G, 51.04G

``` bash
355	nom	0.002	6E-07	12	8	pass	2	0.0008754	8.52	0.007458	1.467	3.327	2.901	2.42	1.83	31140000000	45680000000
366	nom	0.002	8E-07	8	6	near	2	0.0008633	8.072	0.006968	1.459	3.284	2.829	2.32	1.698	30100000000	43930000000
372	nom	0.002	8E-07	10	10	pass	2	0.0009068	8.718	0.007906	1.449	3.221	2.826	2.377	1.821	32420000000	46970000000
388	nom	0.002	1E-06	8	10	pass	2	0.0009167	8.632	0.007913	1.437	3.149	2.768	2.333	1.794	33040000000	47470000000
396	nom	0.002	1E-06	12	10	pass	2	0.0009425	10.15	0.009569	1.436	3.142	2.811	2.429	1.948	35550000000	51040000000
```


选择 R = 0.25 kOhm 中的第一组参数来试试水，也即：
- (Iss, fw, fn1, fn_tail) = (2.0m, 600n, 12,  8): 7.458m, 3.327, 31.14G, 45.68G

不同负载时效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-12-22-01-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，应该是不会有问题了，起码 summer 前仿不会。



放到 DFE 中仿真时发现，即便后面不带任何负载，summer 输出也从输入的 ±200 mV 衰减到了 ±125 mV，这是为什么？观察 summer 输出，并没有像带不动负载那样的 slewing，说明不是负载过大的问题，而是 summer 本身的增益问题。

噢我知道问题在哪了，我们这里看的增益只是 "小信号增益"，而 summer 输入的 ±200 mV 是大信号，大信号下的输出摆幅不仅与线性度有关，还受限于 CML 结构的 Iss\*R，也就是差分输出摆幅不会超过 ±Iss\*R。这里我们的参数是 R = 0.25 kOhm 而 Iss = 2 mA，所以输出摆幅不会超过 ±500 mV。诶不对啊，这摆幅这么大，怎么会受限在 ±125 mV 呢？

我们也扫了一下 summer 的 dc point，扫出来 ±200 mV 输入对应的输出是 ±255 mV，这里也没问题。那么问题会在哪里？

又在 full-rate DFE 中跑了一下，此时 DFE 输出摆幅在 ±240 mV 也是没有问题的，我嘞个豆啊。

**噢~我知道了，是因为我们四个 Summer 共用了一个电流偏置，导致每一个只分到四分之一，所以摆幅从 ±500 mV 衰减到 ±125 mV。修改之后，问题得到解决。**

<!-- 所以我们需要关注 summer 在 ±200 mV 差分输入下的输出情况。如果 summer 线性度衰减很快，那么自然输出摆幅就小，如果线性度极好，输出摆幅就可近似用小信号增益计算。
 -->



### 9.4 quarter-rate DFE loop (2)

**这里 Summer 的电阻为 250 Ohm，所以记得将 tap current 也做对应修改。**

为获得更佳仿真效果，若无特别说明，后续 summer 均用射频管来仿真。验证之后确认环路无问题。


### 9.5 kickback noise reduction


summer 直接连接比较器负载时，会有一段莫名向中间“收窄”的波形，我昨天没能找出背后原因，所以先加了个 BUF 验证了下 DFE 环路没问题。我尝试过：
1. Summer 不接 slicer，而是接 2 x 30 fF 电容负载，仍可以正常工作，所以不是 summer 的问题
2. slicer 前仿后仿都试过，summer 输出波形无区别，所以不是 slicer 版图问题
3. 将驱动 slicer 的时钟从梯形波变缓为正弦波，summer 输出波形无区别，所以也不是时钟馈通导致的

**经过与导师讨论，这个问题是比较器的 kickback noise (回踢噪声) 导致的。** 之所以叫回踢噪声，就是因为比较器在决策期间会给输入端 (input of slicer, i.e., output of summer) 带来一个噪声信号，使得比较器输入发生波动甚至导致判决错误。这个噪声信号的幅度主要与比较器输入管尺寸有关，许多结构的比较器都存在此问题
，一般在 20 mV ~ 100 mV 不等，只是 StrongARM 相对更明显些，我们这里的回踢就有大概 80 mV。



简单搜了下文献，发现使用电容交错连接，与原输入管 C_GD 构成 "对称耦合" 时可以有效抑制回踢噪声，原理如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-16-09-16_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

> 图源：[P. M. Figueiredo and J. C. Vital, “Kickback noise reduction techniques for CMOS latched comparators,” IEEE Transactions on Circuits and Systems II: Express Briefs, vol. 53, no. 7, pp. 541–545, Jul. 2006, doi: 10.1109/TCSII.2006.875308.](https://ieeexplore.ieee.org/document/1658186/)


我们尝试了：
- (1) 在 DINP/DINN 和 netx/nety 之间添加电容 C_kb: 效果并不好，可以说基本上没有效果
- (2) 在 DINP/DINN 和 Q/QB 之间添加电容 C_kb: 效果还不错，注意连接方向是 DINP-Q, DINN-QB，这样才能形成对称耦合


前仿效果 @ RC = 0.4 UI:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-14-28-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


后仿效果 @ RC = 0.4 UI:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-16-14-26_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，确实能起到一定作用。从上面也能看出，最佳电容值在 5 fF ~ 20 fF 之间，具体是多少还得试。


``` bash
SAM_H<0:3>
SAMB_H<0:3>
SAM_L<0:3>
SAMB_L<0:3>

SAM_H_noKB<0:3>
SAMB_H_noKB<0:3>
SAM_L_noKB<0:3>
SAMB_L_noKB<0:3>

SAM_H_noKB<3,0:2>
SAMB_H_noKB<3,0:2>
SAM_L_noKB<3,0:2>
SAMB_L_noKB<3,0:2>

SAM_H_noDFE<0:3>
SAMB_H_noDFE<0:3>
SAM_L_noDFE<0:3>
SAMB_L_noDFE<0:3>
```




利用 nmos_rf_ulvt_nw 构建 `Pcell_CAP_moscap_nmos_rf_ulvt_nw` 以获得接近后仿的电容效果。**以 slicer output 的眼图作为衡量标准** ，对 moscap 尺寸进行扫描。

先试试 PLUS = Gate 而 MINUS = Source 的情况，Strong ARM 输入管尺寸为 fn = 16，于是我们扫描 C_kb_fn = 8/12/16/20 看看，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-17-56-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-18-01-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

上面这里的时序是 ideal sample at CK<0> --> summer --> slicer at CK<2>，不妨也试试 **ideal sample at CK<-2> --> summer --> slicer at CK<2>** 的情况，也即 SH 和 slicer 隔了 4\*delta_t 的情况，对比看看效果如何。结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-18-24-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-18-24-50_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-18-38-29_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

调整了时序之后，slicer 输出眼图得到明显改善。那就先用着这种时序，也就是 SH 和 slicer 隔了 4\*delta_t = 0.5\*CK_period 的情况。



为了得到更符合实际的仿真结果，我们一方面将 ideal sampler 更换为实际的 SH 模块，另一方面考虑到 slicer 16ps 输出摆幅不怎么大 (差分 250 mV 左右)，适当调整 summer TH input pair 的宽度 (原 fn = 6，这里尝试 fn = 6/8/10/12)。

**注意实际 SH 存在大约 6ps ~ 10ps 的 setup time，也即实际 sampling instant 是在 pos-edge of CK 之前 8ps 左右。** 于是调整 CK 与 data 相对位置 (将 SH 的 CK 输入向后延迟 8 ps, CK_tstart = delay_signal - 1p 保持不变)，重新仿真，得到结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-20-21-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-20-35-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

上图是不同 RC 衰减下的 SH 输出情况，可以看到 SH 存在一定均衡效果，在衰减较大时已经能恢复一部分眼睛。

注：现在是一个 SH 带载两个 summer，但实际电路里是一个 SH 带载一个 summer，所以从上面眼图也能看出 SH 带载能力还是足够的，即便 summer 后仿也不会有什么问题。

为得到 SH 的最佳采样位置，我们固定 RC = 0.6 UI 来看看不同 SH_tsetup 设置下的情况，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-21-09-35_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-21-22-07_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

上面两张图表明最佳设置为 SH_tsetup = 7.5 ps，现在便可以关闭 ideal SH 并且将全局时钟起始时间设置为 **CK_tstart = delay_signal - 1p + SH_tsetup**。


SH 替换是完成了，但还不到扫描 moscap for kickback cancellation 的时候，因为 SH 已自带一定均衡能力，所以我们之前按 RC 衰减计算得到的 tap weight 不一定准确，需要进行调整。设置 tap_scale = 0.5 ~ 1.1 进行仿真，得到 Summer_noDFE 结果如下，重点观察其中的 Summer_noKB 和 SAM_noKB:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-21-40-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

这看起来怎么有点怪啊。增大至 RC = 0.8 且 tap_scale = 0.2 ~ 0.8 重新仿真试试：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-21-52-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

这下倒还算正常些。



**注意到这里 summer 的输出摆幅有所降低，是因为 SH 输出共模在 VDD/2 左右，而 summer 的输入共模应为 0.7 ~ 0.8，所以 CML 输入端需要 source follower 来切换共模电平。** 

在修改之前，先回顾一下 summer 本来的性能如何。设置 Vin_CM = VDD - CML_IR/2 时的 pre-sim 和 rf-sim 结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-22-28-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

参考肖师兄的搭建一下，得到 summer @ rf-sim 的参数扫描结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-22-41-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-22-41-27_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嘶，这个性能恶化有点严重，还不如不带 source follower 直接用呢；而且 ac 性能这么差，dc 性能都没必要看了。

再试试前面接 common-source stage (CS) 时的情况，先是 nmos-input:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-22-51-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

显然是不太行，带宽掉得很多，基本上只有原来的一半。

然后是 pmos-input (active nmos load) 的情况：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-23-01-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-23-05-09_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，确实是不太行。我们还是保持原来的 summer，不在前面另加 level shifter 了。



设置 RC = {0.8, 1.0} 和 tap weight = {0.2, 0.4} 来试试水，仿出来感觉好奇怪啊，尤其是在 slicer reset 时会导致后级 summer 输出出现异常 "外摆"，这是为什么？


于是先把 slicer 换成 ideal slicer 来看看其它模块有无问题，设置 RC = {0.4, 0.8} 和 tap weight = {0.1, 0.5, 1.0} 进行仿真，这个现象就更明显了，如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-00-34-49_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

注意到：
- (1) slicer 已经是理想的，所以不是 slicer 本身问题
- (2) Summer 和 Summer_noDFE 都存在这个现象，而 Summer_noKB 没有，说明 Summer 后面加 BUF 会 "隔绝" 这个现象

所以这个现象应该是 summer 前级 slicer 在 reset 阶段由 moscap for kickback cancellation 导致的，看看波形验证一下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-00-46-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

呃看来是推测错误了：并非前级 slicer 在 reset 阶段所导致，而是 **本级两个 slicer 在输出同时上升 (或同时下降) 时，由电容耦合到 slicer 输入端。** 比如 summer0 后面两个 slicer0 输出同时上升时，会导致 summer0 差分输出也上升。不妨将其称为 **二次回踢噪声**。


估计与 moscap 在正偏时的非线性电容有关，于是尝试将 moscap 的 PLUS/MINUS 端交换，从 PLUS = G 改为 PLUS = S，看看能不能解决这个问题，结果发现几乎没什么区别 (也许这个现象与它无关？毕竟我们之前也没发现有这个问题啊)。那么再试试直接将 moscap for kickback cancellation 去掉，看看这个现象还在不在：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-01-01-55_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

此时异常消失，看来确实是 moscap for kickback cancellation 导致的。我们又依次尝试了：


``` bash
199: slicer-cap 开启，summer-cap 关闭；设置了 C_kb_fn = 2/4/8/12 @ RC = 0.8, tap_scale = 0.3
200: 错误
201: 错误
202: slicer-cap 开启，summer-cap 开启；设置了 C_kb_fn = 2/4/8/12 @ RC = 0.8, tap_scale = 0.3
203: 取消
204: 取消
205: slicer-cap 关闭，summer-cap 开启；设置了 RC = {0.4, 0.8}, tap_scale = {0.3, 0.5}

206: 使用 7TXCP slicer (calibre of CDR_ulvt_1d0_1000n_30n_Slicer_ENT_7TXCP_inputTH, 自然也关闭 slicer-cap)，summer-cap 开启；设置了 RC = {0.4, 0.8, 1.0, 1.2}, tap_scale = 0.3
207: 使用 5TCMLXCP slicer (calibre of CDR_ulvt_1d0_1000n_30n_Slicer_ENT_5TCMLXCP_inputTH, 自然也关闭 slicer-cap)，summer-cap 开启；设置了 RC = {0.4, 0.8, 1.0, 1.2}, tap_scale = 0.3
```


- interactive.199: slicer-cap 开启，summer-cap 关闭；设置了 C_kb_fn = 2/4/8/12 @ RC = 0.8, tap_scale = 0.3 时的结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-08-40-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

可以明显观察到，随着 moscap 容值增大，kickback 噪声得到一定抑制，但是电容耦合变得严重，导致判决完成后的输出又耦合回 summer 输出端。不妨称为 **二次回踢噪声** ，也就是 moscap 容值增大能稍微抑制一次回踢噪声，但又引入更明显的二次回踢噪声。


<!-- 那就暂时先不用这些电容来仿真看看，我们刚刚到哪步了来着，哦对到调整 tap weight 这一步，刚刚这几次仿真顺便试出了较合适的 tap weight = 0.2 ~ 0.4。
将 slicer 换回 StrongARM 进行仿真，设置 RC = {0.8, 1.0} 和 tap weight = {0.2, 0.4} -->

- interactive.202: slicer-cap 开启，summer-cap 开启；设置了 C_kb_fn = 2/4/8/12 @ pre-sim ,RC = 0.8, tap_scale = 0.3 时的结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-08-38-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

**可以观察到：summer-cap 开启后，有效抑制了 slicer 输出 (TH input pair of summer) 突变时导致的 summer 输出端反向起始突变，从而大幅提高 summer/slicer 输出眼图质量，效果是非常明显的。** 上面时钟 slicercap 设置中，C_kb_fn = 4 较为合适。


- interactive.205: slicer-cap 关闭，summer-cap 开启；设置了 RC = {0.4, 0.8}, tap_scale = {0.3, 0.5}
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-08-51-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


interactive.206 和 207 的图这里就不放了，两种 slicer 的输出都非常不好，眼图也张不开。



### 9.6 channel loss simulation

这里顺便记录下 RC 通道衰减情况 (插损)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-13-21-57-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

总结下来就是：
- RC = 0.4 UI, S21 = -1.458 dB @ 0.25\*f_b, -4.110 dB @ 0.50\*f_b, -8.608 dB @ 1.00\*f_b
- RC = 0.8 UI, S21 = -4.110 dB @ 0.25\*f_b, -8.608 dB @ 0.50\*f_b, -14.14 dB @ 1.00\*f_b
- RC = 1.0 UI, S21 = -5.385 dB @ 0.25\*f_b, -10.32 dB @ 0.50\*f_b, -16.02 dB @ 1.00\*f_b


比如 f_b = 56 Gb/s 或 56 Gbaud/s 的数据，quarter-rate 就对应 14 GHz 处，而 Nyquist 频率就是 28 GHz (half-rate)


<!-- 如何挑选 kickback 抑制最佳的情况？要注意在一定范围内，电容越大 kickback 抑制效果越好，但是相应地会导致 slicer 输出速度变慢。
那就先用着这种时序，也就是 SH 和 slicer 隔了 4\*delta_t = 0.5\*CK_period 的情况。 -->


$RC = 0.30 \ \mathrm{UI} \sim 0.55 \ \mathrm{UI}$ 的眼图效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-17-28-09_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

然后 RC = 0.6 UI ~ 1.0 UI 的眼图效果如下：



### 9.7 summer/slicer optimization

经过上面尝试，我们确定：
- (1) summer 应该重新进行优化，旨在:
    - a. 将共模电平降低到 Vin_CM = 0.45;
    - b. 适当降低 Iss 电流
    - c. 调整 summer TH input pair 尺寸使得输入差分在 ±100 mV 左右即可达到满摆
- (2) 同时开启 slicer-cap 和 summer-cap，前者需稍小一些；注意这两个电容都会近似算在 slicer 的负载里，所以需要进行迭代
- (3) 确认没有问题之后，将 slicer-cap 画到 slicer 版图里，然后再后仿验证


在开始上面三步之前，我们先看看当前情况下的环路性能。
- slicer-cap 和 summer-cap 都开启
- fn_Ckb = 4 @ rf-sim, fn_summercap = {4, 6}
- RC = 0.8, tap_scale = {0.2, 0.4} 时的结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-09-18-11_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

保持其它参数不变，修改 RC = 1.0、tap_scale = {0.2, 0.4} 和 fn_summercap = {6, 8}，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-09-34-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

可以看出，当前参数下最佳情况是 fn_summercap = 6 (or 5) 和 0、tap_scale = 0.3。


以及看一下当前情况下的 summer 性能用作参考，此时 summer 带载两个 slicer calibre (CK = 0)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-09-28-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


下面进行 summer 优化，扫描结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-09-59-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-09-57-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-10-17-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

两次迭代得到最佳参数为：
- (fn1, fn2, fn_summercap) = (12, 20, 4): dc_gm = 5.798m, Av_dB @ DC = 1.356, Av_BW = 18.94G, Av_GBW = 22.13G


验证下步骤 (1) summer optimization 的效果，设置 RC = 1.0 和 tap_scale = 0.3，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-10-45-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


使用 `CDR_ulvt_1d0_600n_30n_Summer_CML_PAM3_1Tap_RFverify_v2_20260314` @ slicercap = 4 时的性能如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-11-14-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

最后看看使用 summer_1tap_v2 但是不放 slicercap 的情况：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-18-30-24_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯……目前看来是没有什么问题了，可以将 slicercap 合并到 slicer 中，验证完即可进入 adaptation 搭建。


**经过 RC = 1.0, tap_weight = 0.4 @ no slicercap 测试，得到 summercap 的最佳尺寸为 fn_summercap = 4 (rf-sim of summer)，结果如下图所示：**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-19-23-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


固定 RC = 1.0 和 fn_summercap = 4，扫描 tap_scale = 0.1 ~ 2.0，发现 **tap_scale = 1.0 时输出效果最佳：**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-14-23-01-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

顺便记录下 **RC = 1.2** 时的效果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-00-03-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



### 9.8 DFE with post-sim of StrongARM_PET

将 StrongARM_ENT + slicercap + SRL8T 的版图合并到一起，构成 `CDR_ulvt_1d0_1000nx2_30n_Slicer_PET_StrongARM_inputTH_v2`，称为 StrongARM_PET。版图效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-03-14-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-03-13-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


我们设计的是可直接上下拼接的样式，拼接后 VSS/VDD 自动连接上，并且无 DRC 报错等，如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-03-20-59_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



相比 StrongARM_ENT 后仿，StrongARM_PET 后仿时 SH 输出眼图质量有所下降。下面是 RC = {0.4, 0.8, 1.0, 1.2} @ tap_scale = 0.1 ~ 2.0 时的结果总览：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-15-45-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-15-57-57_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


### 9.9 VTH control of StrongARM_PET

对 input THP vs. actual THP 曲线进行仿真，验证其 VTH control 线性度和极限范围，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-15-49-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-15-15-52-24_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

经反向输入再仿真确认，这个 StrongARM_PET 确实具有约 16 mV ~ 20 mV 的 THP offset (32 mV ~ 40 mV 的 Vin_DM offset)，啊这就实在有些大了。而且令人不解的是：明明我们版图是完全对称着来画的，这么大的 offset 从哪来？(已确认过不存在 reset 力度不足的情况)。

t_CK_to_Q 倒是保持在大约 33 ps (0 to 1) 和 44 ps (1 to 0) 不存在什么问题。

