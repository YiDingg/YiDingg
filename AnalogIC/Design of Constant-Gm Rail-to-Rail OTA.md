# Design of Constant-Gm Rail-to-Rail OTA

> [!Note|style:callout|label:Infor]
> Initially published at 00:33 on 2025-09-24 in Beijing.

## Introduction

## 1. Basic Constant-Gm

Constant-Gm OTA 的基本原理是利用 NMOS pair 和 PMOS pair 分别在共模电压的高端和低端工作，然后将它们的小信号跨导相加来实现总跨导恒定 (constant-Gm)，如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-24-21-09-55_Design of Constant-Gm Rail-to-Rail OTA.png"/></div>

上图左侧电路中：
- 黑色大箭头：表示支路必需的偏置电流方向
- 小箭头：表示$V_{in+}$ 升高时的 **小信号电流** 方向，红色表示与直流偏置电流方向相同，蓝色表示相反

$G_{mn,eq} = 2(g_{mn1}\parallel g_{mn2})$ 的计算思路：在小信号电路中，将 $I_{BN}$ 开路，且 source of MN1/MN2 都接地，然后在 $V_{in+}$ 施加小信号 $v_{in,DM}$，计算回路中的小信号电流得到 $i_{out} = (g_{mn1}\parallel g_{mn2})v_{in,DM}$，注意差分情形下这个电流 **is reused**, 比如 $i_{out1} = + i_{out}$ 且 $i_{out2} = - i_{out}$, 总的差分输出电流是 $i_{out,DM} = i_{out1} - i_{out2} = 2(g_{mn1}\parallel g_{mn2})v_{in,DM}$，因此总差分跨导为：

$$
\begin{gather}
G_{mn,eq} = \frac{i_{out,DM}}{v_{in,DM}} = 2(g_{mn1}\parallel g_{mn2})
\end{gather}
$$

知道基本原理后，一个自然的问题是：如何将这些小信号电流 "加起来"？要传递小信号电流，我们必须利用带有恒定电流源的节点，下图给出了一个基本例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-24-16-39-13_Design of Constant-Gm Rail-to-Rail OTA.png"/></div>

上图中，第二级的四个 MOSFET 都工作在合适的 gate 偏置下。事实上，我们也可以全部采用 diode-connected 的方式 (最简单的自偏置)，这对小信号 $G_{m,eq}$ 没有任何影响。因为无论采用 $V_{B}$ 还是 diode-connected，计算 $G_{m,eq}$ 时，四个晶体管的 **the gate and source of each transistor are both ac-grounded respectively, hence gate and source are shorted, acting like a diode**。它们之间的区别在于，用 $V_{B}$ 作为偏置时，相当于用一个额外的 biasing circuit 换取更大的输出电压范围。

## 2. Single-Ended Output

如何实现上述电路的单端输出版本呢？巧合的是，我们刚好可以利用 low-voltage cascode 结构来实现 current mirror 功能，如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-24-16-12-36_Design of Constant-Gm Rail-to-Rail OTA.png"/></div>

上面是三种略有不同的 low-voltage cascode current mirror, 三种结构都可以在转为单端输出的同时保持总跨导 $G_{m}$ 不变。

## 3. Constant-Gm Op Amp

上面的输入级接上输出级便构成一个 constant-gm op amp, 但本文的重点在于 OTA 而非 OPA，因此这里仅给出几个参考例子，不深入讨论：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-24-16-18-36_Design of Constant-Gm Rail-to-Rail OTA.png"/></div>

上图中 class AB 输出时采用了 "浮动控制单元 (浮动电流源)"，其作用和推导相加参考资料 [{2} Bilibili > 1224 Class AB输出的浮动电流源偏置问题](https://www.bilibili.com/opus/704842448804773954)，另外这篇文章中也使用了浮动控制单元 [知乎 > 王小桃带你读文献：基于反相器结构的电流复用 OTA Current-Reused OTA (Inverter-Based OTA)](https://zhuanlan.zhihu.com/p/29718141017)

## 4. Gm-Variation Reduction


上面对 "如何实现两份跨导相加" 作了非常详细的介绍，但读者是否注意到，在最开始的 Figure.1 中，$V_{DD} = 1.2 \ \mathrm{V}$ 的示意图出现了 **总跨导中间高而两边低** 的情况。

这是因为在 $V_{DD} >= 2 V_{TH}$ 的供电下, NMOS pair 和 PMOS pair 有一段 "共同工作区间"，在这个区间内，两个 pair 都贡献一份跨导，使得总跨导较高 (共两份跨导)。而在共模电压接近 $V_{SS}$ 或 $V_{DD}$ 时，只有一个 pair 在工作，导致总跨导较低 (仅一份跨导)。


为解决这个问题，人们提出了多种方法，其中最主流的有三种：
- **(1) DC Level Shift**
- **(2) Current Mirror Control**
- **(3) Multiple Input Pairs**

参考资料 [{1} 知乎 > 运算放大器跨导恒定轨到轨输入级 (Constant-gm Rail-to-Rail Input Stage)](https://zhuanlan.zhihu.com/p/658369226?) 中介绍了多达 17 种 Gm-Variation Reduction Techniques, 同时给出了每一种方法的参考文献，有兴趣的读者可以深入阅读。

### 4.1 dc level shift

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-24-16-07-32_Design of Constant-Gm Rail-to-Rail OTA.png"/></div>


### 4.2 current mirror control

**Current mirror control**, 也称 **current-reuse**, 是 "检测" 输入共模电压的高低，从而给 active pair 分配额外电流的一种方法。

根据输入管工作区间的不同 (strong/weak inversion), 可以分别配置为三倍/一倍电流溢出控制，使整个共模范围内都具有 "两份" 跨导。

三倍电流溢出控制是因为晶体管在 strong inversion 时，根据平方律有 $g_{m} \propto \sqrt{I_{D}}$，因此需要额外的三份电流才能获得两份跨导。类似地，一倍电流溢出控制是因为晶体管在 weak inversion 时 $g_m \propto I_D$，因此只需要额外的一份电流就能获得两份跨导。

下图是 current mirror control 的实现方法之一：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-24-17-46-05_Design of Constant-Gm Rail-to-Rail OTA.png"/></div>

### 4.3 multiple input pairs

暂略。


## References

文章/博客类：
- [{1} 知乎 > 运算放大器跨导恒定轨到轨输入级 (Constant-gm Rail-to-Rail Input Stage)](https://zhuanlan.zhihu.com/p/658369226?): 介绍了多达 17 种 Gm-Variation Reduction Techniques
- [{2} Bilibili > 1224 Class AB 输出的浮动电流源偏置问题](https://www.bilibili.com/opus/704842448804773954): 详细讨论了 constant-gm OPA with Class AB 输出中的浮动电流源偏置问题及其解决方案
- [{3} GihHub > Constant gm rail-to-rail OP-AMP input stage](https://github.com/AhmedHamdyy19/constant-gm-rail-to-rail-opamp-input-stage): 利用 current mirror control 的 singled-ended output 实例 (180nm CMOS)

下面是文献类：
- [1] R. Hogervorst, J. P. Tero, R. G. H. Eschauzier, and J. H. Huijsing, “A compact power-efficient 3 V CMOS rail-to-rail input/output operational amplifier for VLSI cell libraries,” in Proceedings of IEEE International Solid-State Circuits Conference - ISSCC ’94, San Francisco, CA, USA: IEEE, 1994, pp. 244–245. doi: 10.1109/ISSCC.1994.344656.
- [2] G.-D. Dai, P. Huang, L. Yang, and B. Wang, “A Constant Gm CMOS Op-Amp with Rail-to-Rail input/output stage,” in 2010 10th IEEE International Conference on Solid-State and Integrated Circuit Technology, Shanghai, China: IEEE, Nov. 2010, pp. 123–125. doi: 10.1109/ICSICT.2010.5667830.
- [3] Il Kwon Chang, Jang Woo Park, Se Jun Kim, and Kae Dal Kwack, “A global operational amplifier with constant-gm input and output stage,” in Proceedings of IEEE. IEEE Region 10 Conference. TENCON 99. “Multimedia Technology for Asia-Pacific Information Infrastructure” (Cat. No.99CH37030), Cheju Island, South Korea: IEEE, 1999, pp. 1051–1054. doi: 10.1109/TENCON.1999.818603.
- [4] X. Zhao, H. Fang, and J. Xu, “A low power constant-Gm rail-to-rail operational transconductance amplifier by recycling current,” in 2011 IEEE International Conference of Electron Devices and Solid-State Circuits, Tianjin, China: IEEE, Nov. 2011, pp. 1–2. doi: 10.1109/EDSSC.2011.6117572.
- [5] W. Xichuan, D. Huan, and Z. Ting, “A Rail-To-Rail Op-Amp with Constant Gm Using Current Switches,” in High Density Design Packaging and Microsystem Integration, 2007 International Symposium on, IEEE, Jun. 2007, pp. 1–3. doi: 10.1109/HDP.2007.4283626.
- [6] L. L. Malavolta, R. L. Moreno, and T. C. Pimenta, “A self-biased operational amplifier of constant gm for 1.5 V rail-to-rail operation in 130nm CMOS,” in 2016 28th International Conference on Microelectronics (ICM), Giza, Egypt: IEEE, Dec. 2016, pp. 45–48. doi: 10.1109/ICM.2016.7847904.
- [7] J. Wang, L. Huang, and J. Li, “Constant- $g_{m}$ Rail-To-Rail Input/Output Operational Amplifier,” in 2025 IEEE 14th International Conference on Communications, Circuits and Systems (ICCCAS), Wuhan, China: IEEE, May 2025, pp. 87–92. doi: 10.1109/ICCCAS65806.2025.11102681.
- [8] J.-L. Lai, T.-Y. Lin, C.-F. Tai, Y.-T. Lai, and R.-J. Chen, “Design a low-noise operational amplifier with constant-gm”.
- [9] Y. Hao, S. He, and P. Xiao, “Design of a Constant-Gm Rail-to-Rail Operational Amplifier with Chopper Stabilization,” in 2025 5th International Conference on Electronics, Circuits and Information Engineering (ECIE), Guangzhou, China: IEEE, May 2025, pp. 583–587. doi: 10.1109/ECIE65947.2025.11086613.
- [10] Z. Wu, F. Rui, Z. Zhi-Yong, and C. Wei-Dong, “Design of a Rail-to-Rail Constant-gm CMOS Operational Amplifier,” in 2009 WRI World Congress on Computer Science and Information Engineering, Los Angeles, California USA: IEEE, 2009, pp. 198–201. doi: 10.1109/CSIE.2009.173.
- [11] A. C. Veselu, C. Stanescu, and G. Brezeanu, “Low Current Constant-gm Technique for Rail-to-Rail Operational Amplifiers,” in 2020 International Semiconductor Conference (CAS), Sinaia, Romania: IEEE, Oct. 2020, pp. 253–256. doi: 10.1109/CAS50358.2020.9267977.
- [12] N. Baxevanakis, I. Georgakopoulos, and P. P. Sotiriadis, “Rail-to-rail operational amplifier with stabilized frequency response and constant-gm input stage,” in 2017 Panhellenic Conference on Electronics and Telecommunications (PACET), Xanthi, Greece: IEEE, Nov. 2017, pp. 1–4. doi: 10.1109/PACET.2017.8259966.
