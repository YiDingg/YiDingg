# Virtuoso Tutorials - 22. Detailed Explanations of Latch-Up and Fixing LUP DRC in tsmcN28

> [!Note|style:callout|label:Infor]
> Initially created by YiDingg at 16:00 on 2026-10-19 in Beijing.
> dingyi233@mails.ucas.ac.cn

## Introduction

从 2026.09 开始，组里大幅提高了对 latch up 和 LUP DRC/LVS 的重视程度。因此有必要对此专题专门做一次笔记，加深影响的同时方便后来者学习。

本文的主要参考资料为 tsmcN28 PDK 的 DRC Rule File v1.8，路径为 `/data/library/TSMC/tsmc28n/DRC_Rule_File_PDF/DRC_TN28CLDR002_1_8_R(1).pdf`，后文不妨简称为 "drc file" 或者 "文档"。

本文主要是介绍 drc 文档中与 latch-up 有关部分，并对其做总结归纳，以得到更明确的设计指导。另外也简要提了一些 ESD 方面的内容。



## 1. Basics of Latch-Up

此小节主要参考：

关于 latch-up 的等效电路、产生原因等，网上有挺多杂七杂八的资料，参考上面链接简要看看即可，重点是理解并掌握怎么版图上抑制/避免 latch-up。

Latch-up 产生原理 (https://www.bilibili.com/video/BV1Cp4y1C7NT)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-19-22-37-53_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>

Latch-up 避免方法：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-19-22-37-43_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>




## 2. LUP 的相关概念名称和解释

此部分主要参考 [[0] tsmcN28 DRC File (v1.8)](xxx) 和 [[2] kaixinspace > 版图 Latch up DRC 规则解读 (2024.09.19)](https://www.kaixinspace.com/latch-up-rule/)：
- PAD 通常分为 IO PAD (信号) 和 Power PAD (电源/地) 两大类，相对来讲 IO PAD 及其连接的电路部分对 LUP 要求更高 (也是主要来源之一)
- Internal circuit (内部电路)：指不和 IO PAD 直接相连的各种器件/电路
- OD injector (有源注入区, 也称 I/O circuit)：任何直接连接到 IO PAD 的 OD layer (有源区) 都被视为 OD injector

下面是 [[0] tsmcN28 DRC File (v1.8)](xxx) 的 (page.470) 9.1.2 中给出的概念表格：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-20-16-46-33_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-20-16-48-42_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>


本文所用的其它概念和简写：
- gr: guard-ring
- nr (n-ring): N+ guard-ring (连接 n-well)
- pr (p-ring): P+ guard-ring (连接 p-sub/p-well)
- strap: 条状保护带，也称 guard-band，如图所示 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-20-17-13-49_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>
- ogr/bgr: open guard-ring, broken guard-ring, 断开的 gr, 比如 U 形或者仅断一个小口的方形



## 3. DRC File LUP 部分解读

drc file 中与 LUP 直接相关的部分有：
- (page.467) 9.1.1 Latch-up Introduction (原理、等效结构、触发条件)
- (page.470) 9.1.2 Layout Rules and Guidelines for Latch-up Prevention (规则主体)
- (page.530) 9.4   Tips for the ESD/Latchup design

下面就一部分一部分来看。

### (page.467) 9.1.1 Latch-up Introduction (原理、等效结构、触发条件)

LUP 原理及等效结构：略

文档对 3 种典型 LUP DRC violation 举了具体例子：

- **LUP.1:** Any OD injector cluster connected to an I/O pad must be surrounded by guard-ring. (nmos 围 p-ring, pmos 围 n-ring)
``` bash
LUP.1 { @ Any N+ OD injector or an N+ OD injector cluster connected to an I/O pad must be surrounded by a P+ guard-ring.
        @ Any P+ OD injector or a P+ OD injector cluster connected to an I/O pad must be surrounded by a N+ guard-ring.
  POST_DRIVER_NACT NOT INSIDE PTAP_guard_ring_hole
  POST_DRIVER_PACT NOT INSIDE NTAP_guard_ring_hole
}
```
- LUP.1 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-20-16-39-52_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>


- **LUP.2:** 以 OD injector 为圆心画半径 15um 的圆，此范围内的 internal circuit 必须带有 guard-ring
``` bash
LUP.2 { @ Within 15 um space from the OD injector connected to an I/O pad, a P+ guard-ring is required to surround an NMOS or an NMOS cluster. And an N+ guard-ring is required to surround a PMOS or a PMOS cluster.
  X = BESIDE_POST_DRIVER_NMOS_RW INTERACT (DNW INTERACT ((NWEL INTERACT (DNW INTERACT BESIDE_POST_DRIVER_NMOS_RW)) INTERACT POST_DRIVER_PMOS_NW))
  Y = EXT POST_DRIVER_PMOS_NWi [BESIDE_POST_DRIVER_NMOS_RWi] < LUP_2 ABUT < 90 SINGULAR NOT CONNECTED
  BESIDE_POST_DRIVER_NMOS_waive = (BESIDE_POST_DRIVER_NMOS_RWi NOT INTERACT X) NOT WITH EDGE Y
  (BESIDE_POST_DRIVER_NMOS NOT BESIDE_POST_DRIVER_NMOS_waive) NOT INSIDE PTAP_guard_ring_hole
  BESIDE_POST_DRIVER_PMOS NOT INSIDE NTAP_guard_ring_hole
}
```
- LUP.2 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-20-16-58-23_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>


- **LUP.3:** guard-ring 的厚度，以及 p-ring (内含 nmos) 与 n-ring (内含 pmos) 的间距需满足特定要求；不同厚度、器件电压对应的距离要求不同
- LUP.3 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-20-16-59-07_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>



### (page.470) 9.1.2 Layout Rules and Guidelines for Latch-up Prevention (规则主体)

文档此小节先介绍了 LUP 相关概念，我们已在 **2. LUP 的相关概念名称和解释** 中讲过，这里略过。然后讲了 DRC 如何正确识别 OD injector (这是正确执行 LUP 检查的基础)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-20-17-06-02_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>

关于 LUPWDMY layer 的使用，文档中也给出了具体例子，只需覆盖对应 OD 区域即可，无需覆盖 gr 或 strap，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-20-18-16-12_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>

<span style='color:red;font-weight:bold;'> 

重要的是，文档 page.475 中给出了 check LUP DRC without PAD 的方法：
- (1) Attach top-level text on metal. E.g. "PAD"
- (2) Turn on DEFINE_PAD_BY_TEXT option.
- 经实测，应当在 metal 上放置内容为 "PAD" (不包含双引号) 的 
- 原文如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-20-18-19-13_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>

</span>

page.476 ~ page.478 的内容主要是讲怎么避免 LUP，我们将其内容总结如下：
1. 对于 I/O circuit (OD inject)，"裸的" nmos/pmos 不能同时被一个 gr 所围 (nr/pr 都不行)
2. 对于 I/O circuit (OD inject)，

DRC 文档推荐的 latch-up 规避操作：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-21-02-08-00_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>



### (page.530) 9.4 Tips for the ESD/Latchup design

此小节详见文档 page.532-535。

- 直连 PAD 的 Pass Gate 应当加 SDI layer 以触发 ESD.1g DRC check
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-23-17-16-58_Virtuoso Tutorials - 22. Detailed Explanations of Latch-Up and Fixing LUP DRC.png"/></div>



## 4. 2026-10 问题排查：涉及电阻的内部电路在 top full chip 中误报 LUP.1

**<span style='color:red'> 结论：电阻如果有一端直接连到 VDD/VSS PAD，若整个等效阻值 > 200 Ohm，需在电阻上覆盖 RES200 layer (page.473)，否则 VDD-res-circuit 路径上的 circuit 会报 LUP.1 错误 (也即判定为 OD injector)。这个问题曾困扰我们很久，花了许多天时间才排查出来。</span>**
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-23-17-04-19_Virtuoso Tutorials - 22. Detailed Explanations of Latch-Up and Fixing LUP DRC.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-23-17-07-37_Virtuoso Tutorials - 22. Detailed Explanations of Latch-Up and Fixing LUP DRC.png"/></div>

修正效果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-23-18-09-42_Virtuoso Tutorials - 22. Detailed Explanations of Latch-Up and Fixing LUP DRC.png"/></div>

下面是一些详细讨论：
  - 这个问题是这样的：一般情况下，DRC 是以与 I/O PAD 直接相连的 OD (也即 OD injector) 为基础来进行 LUP 检查；与 VDD/VSS/MIXED PAD 直接相连的 OD 一定不会被判定为 OD injector (drc 代码中直接排除掉了)
  - 但有时候会遇到一种情况：PAD 经过了一个电阻再连接到电路，比如 PAD --> res --> circuit，drc 为这种情况单独设置了 OD injector 的判定方法：如果 res 上无 RES200 layer，将此 res 视作短路导线继续进行原 OD injector 判定；如果 res 上标了 RES200 layer，则判定就此断开，后续 circuit 均判定为 internal circuit (之所以要手动标 RES200，是因为 drc 不知道此电阻阻值具体是多少，只知道这里有个电阻图形)。**这个判定本质是通过在网表上 "连通/断开 net (得到一个或两个 net node)" 来实现的。**
  - 问题就出在 "如果 res 上无 RES200 layer，则将此 res 视作短路线继续进行 OD 判定"。我们试验下来的效果像是 drc 误把 res 前的所有 PAD 类型都当作了 IO PAD 来 "继续进行 OD 判定"，但看 drc 里的代码又是正常的，很奇怪
  - 猜测可能的原因是 MIXED_PAD (同时具有 VDD_PAD 和 VSS_PAD 属性) 导致判定异常：但又估计不是这个，看过代码应当不影响正常判定才对。具体根本原因，有待进一步排查

下面给出几种报了 LUP.1 错误的、含电阻的原理图：
1. R-2R DAC 中的 MUX (也可以说是 TG): <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-23-17-57-09_Virtuoso Tutorials - 22. Detailed Explanations of Latch-Up and Fixing LUP DRC.png"/></div>
2. LPF_rst 模块中的 TG: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-23-17-58-33_Virtuoso Tutorials - 22. Detailed Explanations of Latch-Up and Fixing LUP DRC.png"/></div>


## 5. Tips for Gate-Power/Ground ESD Protection

此小节详见文档 page.532-535。

一些 ESD 的总述 tips 就不看了，一般都不需要我们这边考虑，其它内容简要总结如下。

除了以下几种，应当 **避免其他任何情况下 mos gate 直连到 Power/Ground:**
1. Decoupling capacitor
2. Footer and header design for virtual power/ground
3. GGNMOS/GDPMOS across power/ground design for ESD protection

既然不能直连 VDD/VSS，那该怎么连呢：使用 TIE High/Low 器件向 gate 提供 logic 0/1。说白了就是电压和 VDD/VSS 相同，但是经过了 TIE 器件，保护了后级的 gate，如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-23-15-21-55_Virtuoso Tutorials - 22. Detailed Explanations of Latch-Up and Fixing LUP DRC.png"/></div>

自建的数字标准库中已提供了此类器件。

<!-- ## 6. Max ESD Current
详见 dec file 的 page.527-528：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-20-15-47-38_Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.png"/></div>
-->



## 6. Conclusion (Guidance at the Design Level)

T28 LUP 总结 (设计指导)：

1. 所有 PAD 都**必须使用 layer VDDDMY/VSSDMY 强制指定 PAD 类型** (I/O PAD 无需也没法标)，以避免 drc 将 PAD 类型识别错误，导致多报/少报 latch-up 错误
2. 数字电路版图仍采用原有风格 (基本单元 NP/PP 紧接、strap 分布在上下两侧、无 guard-ring)，用自建标准库或 PDK 标准库都可。最终模块成型后应当用双环 (内 p 外 n) 甚至三环 (p-n-p) 做隔离，且最好在最终模块级放置 dnw 隔离 psub 以降低 LUP 风险 (从这个角度，推荐用自建库)
3. 模拟电路版图，除非面积实在不允许，都严格按照 latch-up 要求去做 (尽管它不一定是 I/O circuit，也不一定在 OD injector 附近)，具体而言：
    - (1) nmos 围 p-ring, pmos 围 n-ring
    - (2) 上一条基础上额外添加 strap 隔离，此时从上到下依次为 n-ring (pmos) → p-strap → n-strap → p-ring (nmos) 
    - (3) 上一条基础上，适当拉远 pmos/nmos 间距
    - (4) 上一条基础上，单独对 nmos 围 DNW，此 DNW 不能与 pmos NW 相接，且 DNW 上方的 n-ring 电压需 ≥ pmos NW (一般用金属相连即可)
    - (5) 注意 OD injector 及其 15um 半径内的 ring 宽度 (厚度，以 OD 计算) 需 ≥ 0.1um (详见 drc 文档 page.480 LUP.4)
4. 设计中如果有用到电阻，若此电阻一端接 Power or Ground，且总等效电阻值 >200Ohm，则应使用 RES200 layer 覆盖电阻 (完整覆盖 RPDMY layer) 以避免 DRC 误报 LUP 错误




## References

- [[0] tsmcN28 DRC File (v1.8)](xxx): `/data/library/TSMC/tsmc28n/DRC_Rule_File_PDF/DRC_TN28CLDR002_1_8_R(1).pdf`
- [[1] kaixinspace > 一文 v1.8 搞懂闩锁效应 Latch up (2024.05.08)](https://www.kaixinspace.com/latch-up/)
- [[2] kaixinspace > 版图 Latch up DRC 规则解读 (2024.09.19)](https://www.kaixinspace.com/latch-up-rule/)
- [[3] EETOP > 一文搞懂 Latch up 闩锁效应（来源网上）](https://bbs.eetop.cn/blog-864347-6962151.html)
- [[4] Bilibili > CMOS 闩锁效应及版图解决办法](https://www.bilibili.com/video/BV1Cp4y1C7NT)：从学术角度，在数字电路的 INV 之类基本模块中，为了节省面积可以省略 nmos/pmos 之间的这四分之一段 ring (但仍需要很好的 tap 连接以保证低阻路径)。

