# 202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 13:48 on 2026-02-15 in Lincang.
> dingyi233@mails.ucas.ac.cn

> 注：本文是项目 [A 56 GT/s Quarter-Rate Reference-Less PAM3 CDR (84 Gb/s, 14 GHz) in TSMC 28nm Technology](<Projects/A 56-GTs PAM3 CDR (84 Gbps, 14 GHz) in TSMC 28nm Technology.md>) 的附属文档，用于全面记录 CDR 的设计/迭代/仿真/版图/后仿过程。



## 1. Architecture Considerations

## 2. Basic CMOS Logic (std. Vt)


### 2.1 std. cell example

以一个 `ka = 1, fw/fl = 100n/30n, fn = mu = 1` 的反相器 `LogicVDD_1d0_100n_30n_INV` 为例，说一下我们希望的 "标准形式" 以及版图风格。

- (1) `VDD/VSS` 端口用 `signal` 而不是 `power`
- (2) 除 `VDD/VSS` 端口外，留给外部连接的输入输出端口 (Pin) 均拉到上层金属 (`VDD/VSS` 留 M1 pin)，例如 INV 在 M1 layer 完成自身连接后，用过孔拉到 M2, 并在 M2 打 Pin 供外部连接；进一步地，像 DFF 这样的较复杂单元，可能就要在 M2 上完成内部连接，并在 M3 上打 Pin 供外部连接。
- (3) 版图风格上，尽量规整化，保证相同单元可以通过 "平移复制 + 简单金属连线" 来完成布局，无需对底部 `PP/NP/NW` 等层进行修改；
- (4) 由于 M1 连线也需要空间
- (5) 金属连线宽度推荐：
    - M1: 0.11 um (min = 0.05 um)
    - M2: 0.15 um (min = 0.1 um)


<div class='center'>

|  |  |  |
|:-:|:-:|:-:|
 | `LogicVDD_1d0_100n_30n_INV` (原理图和版图) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-15-15-45-29_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div> | `LogicVDD_1d0_100n_30n_INV` (DRC/LVS 结果) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-15-22-31-53_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div> |
 | 两个 `LogicVDD_1d0_100n_30n_INV` 拼接 (原理图和版图) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-15-16-01-29_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div> | 两个 `LogicVDD_1d0_100n_30n_INV` 拼接 (DRC/LVS 结果) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-15-16-00-26_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div> |
</div>

### 2.2 std. logic performance @ 0.8V

详见 [Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library)](<AnalogICDesigns/Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).md>) 的 **9.1 std. CMOS logic** 一节。这里把仿真条件和典型结果复制过来 (前仿结果，没有用 calibre view)：

仿真条件：
- **<span style='color:red'> VDD = 0.8 V </span>**
- nmos of INV = `nch_mac`
- pmos of INV = `pch_mac`
- corner = TT @ 27°C
- input signal = 1 GHz square wave (0 ~ VDD, trans time = 1 ps)
- time_end = 30 periods

<div class='center'>

| Parameter @ TT27 | minimum INV | typical INV | large INV |
|:-:|:-:|:-:|:-:|
 | ka = WP/WN   | 1.5           | 2             | 2.5           |
 | nmos W/L     | 100n/30n      | 300n/30n      | 4800n/60n     |
 | $I_{DD}$     | 0.334 uA/GHz  | 1.06 uA/GHz   | 22.8 uA/GHz   |
 | $t_{delay}$  | 3.61 ps       | 3.93 ps       | 7.70 ps       |
 | $t_{trans}$  | 2.62 ps       | 2.73 ps       | 3.62 ps       |

</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-15-22-04-49_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>

### 2.3 Logic_std_1d0_100nX2_30n_INV @ 0.8V

对 `Logic_std_1d0_100nX2_30n_INV` 进行了后仿验证，结果如下：

<div class='center'>
<span style='font-size:10px'> 

| Parameter | schematic | calibre_original | calibre_modified |
|:-:|:-:|:-:|:-:|
 | $I_{DD}$     | 0.496 uA/GHz (0.463 ~ 1.042) | 0.993 uA/GHz (0.969 ~ 1.386) | 1.025 uA/GHz (1.000 ~ 1.669) |
 | $t_{delay}$  | 3.185 ps (2.395 ~ 4.700)     | 7.883 ps (5.550 ~ 12.42)     | 7.66 ps (5.548 ~ 11.64)      |
 | $t_{rise}$   | 2.192 ps (1.992 ~ 2.832)     | 6.083 ps (5.411 ~ 9.244)     | 6.335 ps (5.752 ~ 8.698)     |
 | $t_{fall}$   | 2.031 ps (1.911 ~ 2.556)     | 5.858 ps (5.158 ~ 7.949)     | 5.977 ps (5.291 ~ 7.422)     | 

</span>
</div>



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-16-01-13-54_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>

其中，`calibre_original` 是指经 cellmap 后直接得到的 calibre view 结果，其中每个晶体管虽标着 `total_m = 2`，但实际上就是 1 (从 mu = fg = 1 可以看出这一点)，`calibre_modified` (手动改为 `total_m = 1`) 的结果也印证了这一点。其实从 `Generate Netlist` 生成的网表也能看出这一点：

``` bash
XI0_MM0 (XI0_MM0_d XI0_MM0_g XI0_MM0_s VSS__2) nch_mac l=3e-08 w=1e-07 \
    multi=1 nf=1 sd=100n ad=7.5e-15 as=7.5e-15 pd=3.5e-07 ps=3.5e-07 \
    nrd=2.57663 nrs=2.57663 sa=7.5e-08 sb=7.5e-08 sca=38.2422 \
    scb=0.0492998 scc=0.00240049 sa1=7.5e-08 sa2=7.5e-08 sa3=7.5e-08 \
    sa4=7.5e-08 sb1=7.5e-08 sb2=7.5e-08 sb3=7.5e-08 spa=1e-07 \
    spa1=1e-07 spa2=1e-07 spa3=1e-07 sap=9.19776e-08 sapb=1.14444e-07 \
    spba=1.15715e-07 spba1=1.17043e-07 enx=3.15e-07 enx1=3.15e-07 \
    eny=6.78221e-07 eny1=5.99507e-07 eny2=6.74297e-07 rex=1.34409e-06 \
    rey=1.89933e-06 sa5=7.5e-08 sa6=7.5e-08 sodx=1.4925e-05 \
    sodxa=1.4925e-05 sodxb=1.4925e-05 sodx1=8.02576e-07 \
    sodx2=1.61177e-06 sody=1.07545e-06 dfm_flag=1 _ccoflag=0 \
    _rcoflag=0 _rgflag=0 dw1=-1.03993e-20 dw=0 sa7=7.5e-08 \
    sodx4=1.61787e-07 dvt_dfm=0 spmt=1.11111e+15 spomt=0 \
```

其中 `multi=1 nf=1` 就说明了这个晶体管的实际倍数就是 1，而不是 2。



**<span style='color:red'> 但无论从哪方面讲，后仿结果都比前仿差很多，延迟和功耗都近乎翻倍了。 </span>**

2026.02.16 01:22 发现，calibre view 中的 bulk of mos 并未连接，直接是悬空的，这与我们的版图结果一致 (版图上没连)，而且应该就是性能恶化的根本原因 (说明上面的后仿结果不是很靠谱)。为更准确地评估性能，我们另复制两个 calibre view 并将其 bulk 连接到 VSS/VDD 后重新进行仿真验证，结果如下：


<div class='center'>
<span style='font-size:10px'> 

| Parameter | $I_{DD}$ (uA/GHz) | $t_{delay}$ (ps) | $t_{rise}$ (ps) | $t_{fall}$ (ps) |
|:-:|:-:|:-:|:-:|:-:|
| schematic | 0.496 (0.463 ~ 1.042) | 3.185 (2.395 ~ 4.700) | 2.192 (1.992 ~ 2.832) | 2.031 (1.911 ~ 2.556) |
| calibre_original | 0.993 (0.969 ~ 1.386) | 7.883 (5.550 ~ 12.42) | 6.083 (5.411 ~ 9.244) | 5.858 (5.158 ~ 7.949) |
| calibre_modified | 1.025 (1.000 ~ 1.669) | 7.660 (5.548 ~ 11.64) | 6.335 (5.752 ~ 8.698) | 5.977 (5.291 ~ 7.422) |
| calibre_original_bulkConnected | 1.006 (0.977 ~ 1.249) | 8.882 (5.984 ~ 15.15) | 6.803 (5.695 ~ 10.3) | 6.152 (5.431 ~ 8.625) |
| calibre_modified_bulkConnected | 1.065 (1.038 ~ 1.49) | 8.459 (5.98 ~ 13.29) | 6.963 (6.247 ~ 9.577) | 6.503 (5.895 ~ 8.274) |

</span>
</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-16-01-30-08_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>

**心碎了一地——连接 bulk 后性能竟然没有明显改善，甚至还有些恶化了。**


### 2.4 Logic_std_1d0_100n_30n_INV @ 0.8V

刚刚仿的是 `Logic_std_1d0_100nX2_30n_INV`，其总长宽为 `W/L = 200n/30n`。这一小节回头来试试最小尺寸的 `Logic_std_1d0_100n_30n_INV`，其总长宽为 `W/L = 100n/30n`。

后仿结果如下：

<div class='center'>
<span style='font-size:10px'> 

| Parameter | $I_{DD}$ (uA/GHz) | $t_{delay}$ (ps) | $t_{rise}$ (ps) | $t_{fall}$ (ps) |
|:-:|:-:|:-:|:-:|:-:|
| schematic | 0.273 (0.258 ~ 0.477) | 4.195 (3.072 ~ 6.384) | 3.189 (2.854 ~ 4.416) | 2.864 (2.606 ~ 3.829) |
| calibre_original | 0.843 (0.841 ~ 0.962) | 14.19 (9.642 ~ 23.52) | 9.549 (7.739 ~ 14.44) | 8.932 (7.818 ~ 12.72) |
| calibre_modified | 0.862 (0.856 ~ 0.962) | 16.09 (10.44 ~ 28.61) | 10.15 (8.149 ~ 16.65) | 9.46 (8.168 ~ 14.11) |

</span>
</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-16-01-55-42_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>

显然，相比前一小节的 `Logic_std_1d0_100nX2_30n_INV = 200n/30n`，最小单元的后仿延迟要高得多，都快达到两倍了，功耗也没减少多少。

### 2.5 std. with different VDD

这一小前前仿看看不同 VDD 下的性能趋势以寻求最优点，仿真设置如下：
- nmos of INV = `nch_mac`
- pmos of INV = `pch_mac`
- corner = TT @ 27°C
- input signal = 1 GHz square wave (0 ~ VDD, trans time = 1 ps)
- time_end = 40 periods
- VDD = 0.8 V, 0.9 V, 1.0 V, 1.1 V
- fl = 30n, 60n, 90n
- ka = 2.0
- fa = 1 2 4 7 10
- fn = 1 2 4 8 16
- mu = 1

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-16-18-02-04_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>


### 2.5 std. 100n/30n ~ 2400n/30n

这一小节在 **ka = 1.5** 下搭建一系列 INV 单元，宽度从 100n 到 600n，并通过后仿观察其性能变化趋势以寻求最佳点：
- `Logic_std_1d5_100n_30n_INV` (100n/30n @ ka = 1.5)
- `Logic_std_1d5_180n_30n_INV` (180n/30n @ ka = 1.5)
- `Logic_std_1d5_300n_30n_INV` (300n/30n @ ka = 1.5)
- `Logic_std_1d5_300nx2_30n_INV` (600n/30n @ ka = 1.5)
- `Logic_std_1d5_300nx4_30n_INV` (1200n/30n @ ka = 1.5)
- `Logic_std_1d5_300nx8_30n_INV` (2400n/30n @ ka = 1.5)

后仿结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-16-18-15-47_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>

选取 $I_{DD} \times t_{d}^2$ 作为性能指标 (越小越好)，则 `calibre_bulkConnected_Logic_std_1d5_300nx2_30n_INV` (600n/30n @ ka = 1.5) 表现出最佳性能。不过有的又是用 $\mathrm{PDP} = V_{DD} \times I_{DD} \times t_{d}$ 作为性能指标，称为 power delay product (越小越好)，比如这篇论文：
>[](https://www.ijitee.org/wp-content/uploads/papers/v11i5/E98500411522.pdf)



### 2.6 std. INV performance @ 0.9V

我们对 `Logic_std_1d5_300nx2_30n_INV` (600n/30n @ ka = 1.5) 在 VDD = 0.9 V 下的性能进行了后仿验证，主要观察其最大工作频率，结果如下：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-17-22-37-03_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-17-23-09-06_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>

<!-- 除了 (SS, -40°C) 下最大工作频率约为 26.15 GHz，(TT, 27°C) 和 (FF, 130°C) 的最大工作频率均在 30 GHz 以上。
 -->

不同工艺角下的最大工作频率总结如下：
- TT @ +27°C: 29.84 GHz
- SS @ -40°C: 26.59 GHz
- FF @ +130°C: 31.99 GHz

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-04-02-51_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>









### 2.6 std. DL performance @ 0.9V

利用上面的结论，std. mos 在 600n/30n @ ka = 1.5 下性能最佳，基于这个尺寸来搭建 DL (Gated D-Latch) 和 DFF (D-FlipFlop)，并进行仿真验证，看看其性能如何。


DL 采用 TG-based DL 结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-17-17-21-31_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>

导出 calibre view 时的 setup 如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-17-17-27-14_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>


先前仿看看下面三个 cell 的波形：
- `Logic_std_1d5_300nx2_30n_INV`: 600n/30n @ ka = 1.5
- `Logic_std_1d5_300nx2_30n_BUF_x2` (2+4)*300n/30n @ ka = 1.5
- `Logic_std_1d5_300nx2_30n_DL` (4+2)*300n/30n @ ka = 1.5

INV 和 BUF 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-17-17-45-00_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>

DL 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-17-17-55-38_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>

然后对 DL 进行单独的后仿验证，结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-17-18-23-02_202602_tsmcN28_CDR_PAM3_56GT_quarterRate (1) Preparatory Work.png"/></div>

<div class='center'>
<span style='font-size:10px'>

| Parameter | $I_{DD}$ (uA/GHz) | $t_{cq}$ CK to Q delay (ps) | $t_{dq}$ D to Q delay (ps) | $t_{rise}$ Q rise time (ps) | $t_{fall}$ Q fall time (ps) |
|:-:|:-:|:-:|:-:|:-:|:-:|
| schematic | 9.068 (8.622 ~ 12.16) | 8.561 (7.209 ~ 10.49) | 9.921 (8.57 ~ 11.84) | 5.432 (5.432 ~ 5.689) | 5.922 (5.751 ~ 6.347) |
| calibre_bulkConnected | 13.94 (13.78 ~ 16.73) | 15.52 (12.74 ~ 19.54) | 16.97 (14.17 ~ 21.05) | 9.613 (9.613 ~ 9.95) | 10.02 (9.806 ~ 10.57) |

</span>
</div>

``` bash

Parameters: CONFIG/MyLib_tsmcN28/Logic_std_1d5_300nx2_30n_DL_12T=schematic										
1	TB_LogicDelay	IDD_unit (A)				8.622u	12.16u	9.068u	8.622u	12.16u
1	TB_LogicDelay	CK_to_Q_riseDelay (s)		7.209p	10.49p	8.561p	10.49p	7.209p
1	TB_LogicDelay	D_to_Q_fallDelay (s)		8.57p	11.84p	9.921p	11.84p	8.57p
1	TB_LogicDelay	Q_riseTime (s)				5.432p	5.689p	5.432p	5.479p	5.689p
1	TB_LogicDelay	Q_fallTime (s)				5.751p	6.347p	5.922p	5.751p	6.347p
Parameters: CONFIG/MyLib_tsmcN28/Logic_std_1d5_300nx2_30n_DL_12T=calibre_bulkConnected										
2	TB_LogicDelay	IDD_unit (A)				13.78u	16.73u	13.94u	13.78u	16.73u
2	TB_LogicDelay	CK_to_Q_riseDelay (s)		12.74p	19.54p	15.52p	19.54p	12.74p
2	TB_LogicDelay	D_to_Q_fallDelay (s)		14.17p	21.05p	16.97p	21.05p	14.17p
2	TB_LogicDelay	Q_riseTime (s)				9.613p	9.95p	9.613p	9.95p	9.634p
2	TB_LogicDelay	Q_fallTime (s)				9.806p	10.57p	10.02p	9.806p	10.57p
```

虽然看起来这个 delay 挺小，但 DL 的最大工作频率到底如何？还得仿真看一看。


**仿真过程中遇到了报错：**

``` bash
    ERROR (SFE-1996): "/home/dy2025/Work/Cadence_Config/spectre_modelFile_tsmcN28/./cln28ull_1d8_elk_v1d8_3.scs" 24576: Cannot run the simulation because the expression of the parameter `lef': Function `pPar' is not defined. Update the netlist to define the function.
        , correct the expression and rerun the simulation.
Error found by spectre in `pch_mac':`I14<0>_turbo_m32.I0.I13.M1', in `LogicVDD_std_INV':`I14<0>_turbo_m32.I0.I13', in `LogicVDD_std_DL_12T':`I14<0>_turbo_m32.I0', in `LogicVDD_std_DFF_DL12T':`I14<0>_turbo_m32', during hierarchy flattening.
    ERROR (SFE-1996): "/home/dy2025/Work/Cadence_Config/spectre_modelFile_tsmcN28/./cln28ull_1d8_elk_v1d8_3.scs" 24576: Cannot run the simulation because the expression of the parameter `lef': Function `pPar' is not defined. Update the netlist to define the function.
        , correct the expression and rerun the simulation.
Error found by spectre in `pch_mac':`I14<0>_turbo_m32.I0.I13.M1', in `LogicVDD_std_INV':`I14<0>_turbo_m32.I0.I13', in `LogicVDD_std_DL_12T':`I14<0>_turbo_m32.I0', in `LogicVDD_std_DFF_DL12T':`I14<0>_turbo_m32', during hierarchy flattening.
    ERROR (SFE-1996): "/home/dy2025/Work/Cadence_Config/spectre_modelFile_tsmcN28/./cln28ull_1d8_elk_v1d8_3.scs" 24576: Cannot run the simulation because the expression of the parameter `lef': Function `pPar' is not defined. Update the netlist to define the function.
        , correct the expression and rerun the simulation.
Error found by spectre in `pch_mac':`I14<0>_turbo_m32.I0.I13.M1', in `LogicVDD_std_INV':`I14<0>_turbo_m32.I0.I13', in `LogicVDD_std_DL_12T':`I14<0>_turbo_m32.I0', in `LogicVDD_std_DFF_DL12T':`I14<0>_turbo_m32', during hierarchy flattening.
    ERROR (SFE-1996): "/home/dy2025/Work/Cadence_Config/spectre_modelFile_tsmcN28/./cln28ull_1d8_elk_v1d8_3.scs" 24581: Cannot run the simulation because the expression of the parameter `lmonte_flagp_ms': Function `pPar' is not defined. Update the netlist to define the function.
        , correct the expression and rerun the simulation.
Error found by spectre in `pch_mac':`I14<0>_turbo_m32.I0.I13.M1', in `LogicVDD_std_INV':`I14<0>_turbo_m32.I0.I13', in `LogicVDD_std_DL_12T':`I14<0>_turbo_m32.I0', in `LogicVDD_std_DFF_DL12T':`I14<0>_turbo_m32', during hierarchy flattening.
    ERROR (SFE-1996): "/home/dy2025/Work/Cadence_Config/spectre_modelFile_tsmcN28/./cln28ull_1d8_elk_v1d8_3.scs" 24581: Cannot run the simulation because the expression of the parameter `lmonte_flagp_ms': Function `pPar' is not defined. Update the netlist to define the function.
        , correct the expression and rerun the simulation.
Error found by spectre in `pch_mac':`I14<0>_turbo_m32.I0.I13.M1', in `LogicVDD_std_INV':`I14<0>_turbo_m32.I0.I13', in `LogicVDD_std_DL_12T':`I14<0>_turbo_m32.I0', in `LogicVDD_std_DFF_DL12T':`I14<0>_turbo_m32', during hierarchy flattening.
    ERROR (SFE-1996): "/home/dy2025/Work/Cadence_Config/spectre_modelFile_tsmcN28/./cln28ull_1d8_elk_v1d8_3.scs" 24581: Cannot run the simulation because the expression of the parameter `lmonte_flagp_ms': Function `pPar' is not defined. Update the netlist to define the function.
        , correct the expression and rerun the simulation.
Error found by spectre in `pch_mac':`I14<0>_turbo_m32.I0.I13.M1', in `LogicVDD_std_INV':`I14<0>_turbo_m32.I0.I13', in `LogicVDD_std_DL_12T':`I14<0>_turbo_m32.I0', in `LogicVDD_std_DFF_DL12T':`I14<0>_turbo_m32', during hierarchy flattening.
    ERROR (SFE-1996): "/home/dy2025/Work/Cadence_Config/spectre_modelFile_tsmcN28/./cln28ull_1d8_elk_v1d8_3.scs" 24576: Cannot run the simulation because the expression of the parameter `lef': Function `pPar' is not defined. Update the netlist to define the function.
        , correct the expression and rerun the simulation.
```


经尝试，只需在 CDF Edit 中重新 Apply 一下参数 (如有错误先进行修改)，就能解决此问题。




利用两个 `Logic_std_1d5_300nx2_30n_DL_12T` 构成 DFF 并 **配置为 DIV2** 后，仿真得到前仿/后仿最大工作频率为 **前仿 27.5 GHz 和后仿 15.0 GHz**:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-18-04-34-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>







## 3. Overview and Verification of D-Latches and D-Flipflops.md

详见文章：[Overview and Verification of D-Latches and D-Flipflops](<AnalogIC/Overview and Verification of D-Latches and D-Flipflops.md>)。

## 4. full-rate NRZ CDR loop

using Hogge-PD:
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-25-02-34-49_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-25-02-41-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



## 5. quarter-rate NRZ CDR loop

### 5.1 using verilog-DFF

quarter-rate timing diagram @ 56 Gb/s (14 GHz):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-25-15-59-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

仿真时百思不得其解：已经试过多组环路参数，为什么 BER 都非常高？锁定后频率出现振荡，像下面这样：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-25-20-14-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

经过大半天的尝试，终于发现了问题所在：quarter-rate PD 的输出 UP[3:0] 和 DN[3:0] 搞反了，交换之后即可得到正确的环路仿真结果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-25-20-16-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

环路效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-25-20-36-09_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


固定 num. of CP = 3, 看看不同环路参数下的效果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-25-20-43-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-25-20-50-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


嗯，看来在当前测试条件下 (jitter of data = 0)，verilog-a 模型的一个较优的环路参数是：
- num. of CP = 3
- I_cp_total = 500 uA
- (R1, C1) = (100 Ohm, 30 pF) or (100 Ohm, 15 pF)


``` bash
DN<1>,UP<1>,DN<2>,UP<2>,DN<3>,UP<3>

UP<0>,DN<0>,UP<1>,DN<1>,UP<2>,DN<2>,UP<3>,DN<3>
```

### 5.2 using calibre of ETSPC-DFF

后仿发现，即便是采用 3 Charge Pumps logic 以避免 CK[7] of CK[0:7] 的时序问题，quarter-rate CDR 仍然存在明显 BER，因为 CK[6] 倒 next CK[0] 之间的间隔仍不足以满足时序要求：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-26-01-31-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

无奈对 CK[0,2] 采样得到的 DATA[0,2] 进行额外 align，然后于 CK[4] 再对所有数据进行正式 align 操作，以此将 sampling 和 align 之间的最小间隔从 2/8 of CK period 提升到 (2/8 + 4/8) of CK period 以降低时序要求。

经过尝试，**实际最多只能提升到 4/8 of CK period** ，具体实现思路如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-26-02-18-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

上面原理图一共使用了 5 x 4 = 20 个 DFFs (原始架构使用了 4 x 4 = 16 个 DFFs)。

### 5.3 slicer test

NRZ slicer 的效果如下： **当 CK = 0 时，CMOS Logic 输出 OUT/OUTB 都被拉高到 VDD，同时内部电路 “跟踪 DIN”；当 CK = 1 时，sample DIN at pos-edge of CK 并将结果输出到 OUT/OUTB 上，与 DFF 相比 slicer 的 CK to Q delay 很小 (前仿约 2 ps，估计后仿约 4 ps)。**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-28-20-02-05_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-28-20-36-42_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

然后试试 PAM3 slicer：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-28-20-59-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-28-21-26-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


### 5.4 verilog-a slicer

理想了 slicer 的原理/行为后，用 verilog-a 搭建其行为级模型，并进行仿真验证。我们搭建了 `ENT/PET` 和 `有/无阈值设置` 共四种版本，分别代表：
- ENT: slicer controlled by EN signal, i.e., sample DIN at pos-edge of EN and reset OUT/OUTB to VDD at neg-edge (neg-level) of EN
- PET: slicer controlled by CK signal, i.e., sample DIN at pos-edge of CK (no rst); 这里是用 Slicer_ENT + SR-Latch 做到的
- with/without threshold setting: 有/无 THP 和 THN 输入端口，用于设置 DIN = (DINP - DINN) 差分输入阈值

仿真结果就不在这里赘述了。

### 5.5 NRZ CDR with CK-Slow FD

利用 slicer 和 DFF 构建 sample-align 模块后，将 `VA_CDR_NRZ_FDLogic_quarterRate_CKslow_outX16` 也加入到 CDR 中，设置较合适的环路参数进行仿真，看看 FD 的锁频功能是否正常：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-28-23-59-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-01-00-28-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，CDR 的整体功能还是正常的，锁定后也没有出现误码，可以继续加入 CK-Fast FD Logic。

2026.02.28 晚加入 CK-Fast FD 仿真时出现些问题：一个是 CK-SLow Logic 在 CK Fast 时出现误判，看了波形但暂时没找到原因；另一个是 CK-Fast Logic 在 CK Fast 较少时不足以将频率拉下来 (增益不够？)，导致环路无法锁定。

仿真时又遇到了这个问题：解决方案是， **将当前 TB 所在 cell 复制倒一个新 cell，然后即可正常仿真**
``` bash
FATAL (SPECTRE-18): Segmentation fault. Encountered a critical error during simulation.
```



### 5.6 FD gain control

为获得最佳 FD 性能，我们引入 4-bit 甚至 6-bit gain control 来调整 FD 的 SLOW/FAST 增益。

4-bit gain control (0 ~ 15) 的仿真结果如下图，已将无法正常锁定的曲线隐去。图中可以看出，最佳增益比约为 SLOW/FAST = 10/16 = 40/64 (设置时有点小错，10/16 实际应为 11/16 = 44/64)，更精确点大概在 9.75/16 = 39/64 (实际应为 10.75/16 = 43/64)；更低的 8/16 = 32/64 (实际为 9/16 = 36/64) 就非常不好了。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-01-16-23-35_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>




6-bit gain control (0 ~ 63) 的仿真结果如下图，由于 X64-pulse-wider 过长，导致 CK Slow 时几乎恒有 FAST/SLOW = 1，导致频率无法拉上或拉下，无法正常锁定：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-01-17-22-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



再试试 3-bit gain control (0 ~ 7)，仿真结果如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-01-18-09-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-01-19-09-07_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

感觉效果都不是很好。


### 5.7 fixing locking-failed problem


在修改 FD 之前，我们先将 Alexander-PD 的输出从三组 UP/DN 输出缩减为一组 (用 OR gate 将原本的输出综合起来)，在 4-bit gain control 下仿真，效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-01-19-56-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

上图表明 SLOW/FAST gain = 10/16 时效果最好，8/16 以及 12/16 时虽然也能正常锁定 (locking time < 1 us)，但效果稍差一些。固定 SLOW/FAST gain = 10/16 看看不同初始频率的锁定效果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-01-20-45-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

还是之前说的那个问题，以初始 16 GHz，目标是 14 GHz = 56 Gbaud/s 为例：在合理的 gain control code 下，CK Fast 时环路经常卡在 14.4 GHz 左右下不去，需要一定 "运气" 才能锁定到 14 GHz；CK Slow 时倒是基本没有这个问题，只要增益合理都能锁到 14 GHz。

于是乎，既然需要一定 "运气" 才能打破 14.4 GHz 达到 14 GHz，那么一个比较直接的方案就是增大 PD/FD 对应电荷泵的电流，同时引入 Lock Detection Logic 来在锁定后降低电荷泵电流以提高抖动性能。下面是尝试结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-01-21-58-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-01-22-13-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


**还是把 PD 改回原来那种。** 我们将 FD 中的 CK-Slow-Logic 更换为组里之前 PAM4 论文中提到的 modified PFD Logic。也即在 A-PD 输出 UP/DN 的基础上，添加一个 INV + AND 使得仅当 UP/DN = 0/1 时才输出 DN (UP 不变)。这相当于提高了 UP 的优先级，当 UP/DN = 1/1 时会输出 UP 而非 DN，从而实现 CK-Slow Detection. **2026.03.01 20:56 经过仿真验证，这种 CK-Slow-Logic 方案不行，其在 CK Fast 时仍有大量误判 (为什么?)**



### 5.8 loop verification

固定 3-CP for PD 和 1-CP for FD，I_cp_pd = 3x100 uA 以及 I_cp_fd = 150 uA 不变，仿真不同起始频率下的锁定过程，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-01-23-27-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-01-23-40-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>




## 6. quarter-rate PAM3 CDR loop

**在继续之前，将 CML PRTS 产生的理想 PAM3 接到 RC 低通滤波器上 (引入通道衰减)，这样可以产生 ISI (inter-symbol interference)，更接近实际情况。** 目前设置的是 $RC = \frac{T_b}{6}$，衰减后的信号还算比较理想，如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-02-16-26-50_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

如果想引入更明显的 衰减/ISI，可以考虑使用 $RC = 0.30 T_b \sim 0.55 T_b$，效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-17-28-09_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>



### 6.1 find best Icp and FD-gain

将 NRZ PD/FD Logic 改为 PAM3 的之后，我们需要重新调整 FD SLOW/FAST gain 系数以获得双向频锁能力，仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-02-14-20-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
图中可以看出，最佳 SLOW/FAST 增益系数在 16/16 ~ 32/16 之间，16/16 的话 CK Slow 没法锁定，32/16 的话 CK Fast 没法锁定。为了得到最佳增益系数，我们对 SLOW/FAST gain 进行 200 points sweep，筛选后的详细结果如下：



``` bash
在初始频率 -150 mUI (CK Slow) 时能锁定的参数如下：

point corner I_cp_total FAST_gain SLOW_gain delta_freq_UI
8	nom	300u	4	8	-150m
10	nom	300u	4	12	-150m
12	nom	300u	4	16	-150m
14	nom	300u	4	24	-150m
16	nom	300u	4	32	-150m
18	nom	300u	4	48	-150m
20	nom	300u	4	64	-150m
30	nom	300u	8	12	-150m
32	nom	300u	8	16	-150m
34	nom	300u	8	24	-150m
36	nom	300u	8	32	-150m
38	nom	300u	8	48	-150m
40	nom	300u	8	64	-150m
54	nom	300u	16	24	-150m
56	nom	300u	16	32	-150m
58	nom	300u	16	48	-150m
60	nom	300u	16	64	-150m
76	nom	300u	32	32	-150m
78	nom	300u	32	48	-150m
80	nom	300u	32	64	-150m
110	nom	500u	4	12	-150m
112	nom	500u	4	16	-150m
114	nom	500u	4	24	-150m
116	nom	500u	4	32	-150m
118	nom	500u	4	48	-150m
120	nom	500u	4	64	-150m
130	nom	500u	8	12	-150m
132	nom	500u	8	16	-150m
134	nom	500u	8	24	-150m
136	nom	500u	8	32	-150m
138	nom	500u	8	48	-150m
140	nom	500u	8	64	-150m
152	nom	500u	16	16	-150m
154	nom	500u	16	24	-150m
156	nom	500u	16	32	-150m
176	nom	500u	32	32	-150m
178	nom	500u	32	48	-150m
180	nom	500u	32	64	-150m


然后是在初始频率 +150 mUI (CK Fast) 时能锁定的参数：
41	nom	300u	16	1	150m
43	nom	300u	16	2	150m
45	nom	300u	16	4	150m
61	nom	300u	32	1	150m
63	nom	300u	32	2	150m
65	nom	300u	32	4	150m
67	nom	300u	32	8	150m
69	nom	300u	32	12	150m
71	nom	300u	32	16	150m
73	nom	300u	32	24	150m
75	nom	300u	32	32	150m
81	nom	300u	64	1	150m
83	nom	300u	64	2	150m
85	nom	300u	64	4	150m
87	nom	300u	64	8	150m
89	nom	300u	64	12	150m
91	nom	300u	64	16	150m
93	nom	300u	64	24	150m
95	nom	300u	64	32	150m
97	nom	300u	64	48	150m
99	nom	300u	64	64	150m
141	nom	500u	16	1	150m
143	nom	500u	16	2	150m
145	nom	500u	16	4	150m
147	nom	500u	16	8	150m
161	nom	500u	32	1	150m
163	nom	500u	32	2	150m
165	nom	500u	32	4	150m
167	nom	500u	32	8	150m
169	nom	500u	32	12	150m
171	nom	500u	32	16	150m
173	nom	500u	32	24	150m
175	nom	500u	32	32	150m
177	nom	500u	32	48	150m
179	nom	500u	32	64	150m
187	nom	500u	64	8	150m
189	nom	500u	64	12	150m
191	nom	500u	64	16	150m
193	nom	500u	64	24	150m
195	nom	500u	64	32	150m
197	nom	500u	64	48	150m
199	nom	500u	64	64	150m


从中筛选出两边都能锁定的参数：
point corner I_cp_total FAST_gain SLOW_gain delta_freq_UI
75	nom	300u	32	32	150m 和 76	nom	300u	32	32	-150m
175	nom	500u	32	32	150m 和 176	nom	500u	32	32	-150m
177	nom	500u	32	48	150m 和 178	nom	500u	32	48	-150m
179	nom	500u	32	64	150m 和 180	nom	500u	32	64	-150m

一共只有四组
```

下面是它们的锁定过程：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-02-14-52-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

图中可以看出，最佳电流和增益范围是：
- I_cp_total = **500 uA**
- I_cp_pd = 3 x I_cp_total/3 (3 CPs for PD)
- I_cp_fd = 1 x I_cp_total/2 (1 CP for FD)
- **SLOW/FAST gain = 32/32 ~ 64/32**

于是后续最优方案就呼之欲出了： **未锁定时，在较大电流 (如上面的 500 uA) 下同时开启 PD/FD，(通过 lock detection) 确认锁定之后，关闭 FD 的同时减小电流 (比如减小为一半)。**


为保证鲁棒性，给出 SLOW/FAST gain = 32/32 ~ 64/32 时的仿真结果，包括 SLOW_gain = 32, 36, ..., 52 (6-point)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-02-16-50-49_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，都是能正常锁定的。后面若无特别说明，我们将以 I_cp_total = 500 uA 和 **SLOW/FAST gain = 36/32** 作为默认初始参数 (锁定之前) 进行仿真。




``` bash
  2**0 *VT("/I34/UP0_Q<0>")
+ 2**1 *VT("/I34/UP0_Q<1>")
+ 2**2 *VT("/I34/UP0_Q<2>")
+ 2**3 *VT("/I34/UP0_Q<3>")
+ 2**4 *VT("/I34/UP0_Q<4>")
+ 2**5 *VT("/I34/UP0_Q<5>")
+ 2**6 *VT("/I34/UP0_Q<6>")
+ 2**7 *VT("/I34/UP0_Q<7>")

  2**0 *VT("/I34/UP0_Q<0>") + 2**1 *VT("/I34/UP0_Q<1>") + 2**2 *VT("/I34/UP0_Q<2>") + 2**3 *VT("/I34/UP0_Q<3>") + 2**4 *VT("/I34/UP0_Q<4>") + 2**5 *VT("/I34/UP0_Q<5>") + 2**6 *VT("/I34/UP0_Q<6>") + 2**7 *VT("/I34/UP0_Q<7>")

  2**0 *VT("/I34/DN0_Q<0>")
+ 2**1 *VT("/I34/DN0_Q<1>")
+ 2**2 *VT("/I34/DN0_Q<2>")
+ 2**3 *VT("/I34/DN0_Q<3>")
+ 2**4 *VT("/I34/DN0_Q<4>")
+ 2**5 *VT("/I34/DN0_Q<5>")
+ 2**6 *VT("/I34/DN0_Q<6>")
+ 2**7 *VT("/I34/DN0_Q<7>")

  2**0 *VT("/I34/DN0_Q<0>") + 2**1 *VT("/I34/DN0_Q<1>") + 2**2 *VT("/I34/DN0_Q<2>") + 2**3 *VT("/I34/DN0_Q<3>") + 2**4 *VT("/I34/DN0_Q<4>") + 2**5 *VT("/I34/DN0_Q<5>") + 2**6 *VT("/I34/DN0_Q<6>") + 2**7 *VT("/I34/DN0_Q<7>")

( 2**0 *VT("/I34/LD_count<0>")
+ 2**1 *VT("/I34/LD_count<1>")
+ 2**2 *VT("/I34/LD_count<2>")
+ 2**3 *VT("/I34/LD_count<3>")
+ 2**4 *VT("/I34/LD_count<4>")
+ 2**5 *VT("/I34/LD_count<5>")
+ 2**6 *VT("/I34/LD_count<6>")
+ 2**7 *VT("/I34/LD_count<7>")
)/VAR("VDD")
```




### 6.2 lock detection logic

经过和导师讨论，同时查阅网上的一些资料，目前简单而可行的有下面几种方案：
- (1) 模拟监测：用一个 "differentiating circuit (微分电路，比如 RC 耦合的 INV，或者 C + R + OPA 电路)" 对 LPF 中电容 C1 电压进行微分，然后用比较器监视其输出，检查有无超过阈值的行为；注意微分电路应具有合理且有限的带宽。
- (2) 数字逻辑：引入一个或多个 offset sampler 构成 (局部) X4-oversampling, 比如现在 X2-OS 的间隔是 $\frac{T_b}{8} = 8.93 \ \mathrm{ps}$，那么在 CK<0> (data sample) 和 CK<1> (edge sample) 之间插入一个 CK<0.5> (offset sample)，若一段时间内在 CK<0,0.5> 之间没有检测到边沿穿过 (数据不变化)，则认为锁定；思路来自这篇文章 [AMD > Serial Transceiver > how to check that the CDR is locked to incoming data](https://adaptivesupport.amd.com/s/article/66699?language=en_US)
- (3) 数字逻辑：......

首先尝试最简单且准确的方案 (2)。将 `flag_same` 和 8-bit counter 产生的 `preRst_counter` (每 256 周期出现一次) 信号都作为 lock detection counter 的复位信号，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-02-19-23-45_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-02-19-15-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-02-21-17-10_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

嗯，看来要求 256 periods 周期内一次边沿都没有还是过于严格了，毕竟为了提高锁定鲁棒性，我们的环路在未锁定时 PD 电流较大且有 FD, 抖动自然就比较高。那么改进思路就是两种：
- (1) 仍然使用 `flag_same` 作为复位信号之一，但降低 "连续 n 个周期都没有出现边沿的" 输出阈值，比如原来是 255/255，现在改为 127/255 或 100/255。
- (2) 不用 `flag_same` 作为 lock detection counter 复位信号之一，直接在 256 周期内 "无边沿" 次数进行计数，达到一定阈值 (例如 250 次或 240 次) 即认为锁定；

从电路实现来讲，第二种是更简单的，用 (8-bit) 温度计码即可得到 0, 128, 192, 224, 240, 248, 252, 254, 255 一共九个档位。但第一种方案只能使用 "多比特数比较器" 来做，虽然也没难到哪去，但相对更麻烦一点。

综合考虑，我们使用第二种方案，也即 **不使用 `flag_same` 作为 lock detection counter 的复位信号，而是直接在 counter 内部进行计数，达到一定阈值 (比如 250/256) 即认为锁定**。


``` bash
8 --> 128*(1/2^0 + 1/2^1 + 1/2^2 + 1/2^3 + 1/2^4 + 1/2^5 + 1/2^6 + 1/2^7) = 255 --> LD_LEVEL<7:0> = <1111,1111>
7 --> 128*(1/2^0 + 1/2^1 + 1/2^2 + 1/2^3 + 1/2^4 + 1/2^5 + 1/2^6 + 0/2^7) = 254 --> LD_LEVEL<7:0> = <1111,1110>
6 --> 128*(1/2^0 + 1/2^1 + 1/2^2 + 1/2^3 + 1/2^4 + 1/2^5 + 0/2^6 + 0/2^7) = 252 --> LD_LEVEL<7:0> = <1111,1100>
5 --> 128*(1/2^0 + 1/2^1 + 1/2^2 + 1/2^3 + 1/2^4 + 0/2^5 + 0/2^6 + 0/2^7) = 248 --> LD_LEVEL<7:0> = <1111,1000>
4 --> 128*(1/2^0 + 1/2^1 + 1/2^2 + 1/2^3 + 0/2^4 + 0/2^5 + 0/2^6 + 0/2^7) = 240 --> LD_LEVEL<7:0> = <1111,0000>
3 --> 128*(1/2^0 + 1/2^1 + 1/2^2 + 0/2^3 + 0/2^4 + 0/2^5 + 0/2^6 + 0/2^7) = 224 --> LD_LEVEL<7:0> = <1110,0000>
2 --> 128*(1/2^0 + 1/2^1 + 0/2^2 + 0/2^3 + 0/2^4 + 0/2^5 + 0/2^6 + 0/2^7) = 192 --> LD_LEVEL<7:0> = <1100,0000>
1 --> 128*(1/2^0 + 0/2^1 + 0/2^2 + 0/2^3 + 0/2^4 + 0/2^5 + 0/2^6 + 0/2^7) = 128 --> LD_LEVEL<7:0> = <1000,0000>
0 --> 128*(0/2^0 + 0/2^1 + 0/2^2 + 0/2^3 + 0/2^4 + 0/2^5 + 0/2^6 + 0/2^7) = 0   --> LD_LEVEL<7:0> = <0000,0000>
```


**设置 LD_LEVEL = 4 (对应 240/255)** ，引入了 FD enable/disable (controlled by flag_locked) 但是暂未引入 CP current 自动调整，仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-02-23-37-33_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-02-23-28-21_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-02-23-49-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-02-23-47-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

这里有一个问题是：8-bit counter 的 CARRY 输出，在每 256 个计数周期会出现 7 + 1 次脉冲，其中前七次脉冲宽度为两倍 Q to EQ delay (也即 AND propagation delay)，最后一次才是正确的脉冲输出，宽度为一个计数周期。我们设置的 verilog logic gates 具有 t_delay = 1 ps, 这 2 ps 的 CK_LD 脉冲已经足够触发后续 DFF，导致 flag_locked 的 sample and update 其实每 256 周期会出现八次，这八次中的最后一次其实才是我们想要的。前面七次错误的 sample and update 会导致 flag_locked 的值发生更新 (比如从 1 到 0)，从而又错误地开启了 FD, 使得 256 周期的后半部分抖动增大，本该 locked 的环路又被打破。

之前之所以没有发现这个问题，是因为 CARRY 都是用在时序电路里做后级 data，而非做后级 CK。要解决这个问题也是很简单的：只需将 CARRY 信号从 Counter 模块原输出换为 Q<7:0> 接 AND8 后的输出即可。

**更正 CARRY 导致的 CK_LD 问题后，引入电流自适应 (flag_locked = 0 时电流大，= 1 时电流小且关闭 FD)** ，得到仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-00-13-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-00-17-35_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

Perfect! 现在无论是 CK Slow 还是 CK Fast，环路都能在较大电流和 FD 的帮助下快速锁定到目标频率，锁定后自动降低电流并关闭 FD 来提高抖动性能并保持零误码了。


进一步地，同时打开 high/low bit BER Calculator，再用 flag_locked 作为其使能信号，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-00-57-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-01-03-27_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-00-56-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

这里 lock detection 是用 offset sampler 配合一点逻辑来做的，也就是用到采样时钟介于 CK<0> 和 CK<1> 之间的一个 slicer，比如 CK<0.5> 这样子。CK<0> 是 data sample，通过检测 CK<0> 和 CK<0.5> 之间 “是否有边沿穿过”，配合计数器构成 lock detection，效果挺好的。

### 6.3 different channel loss

这一小节考察 THP = +100 mV 和 +66.6 mV 两种情况在不同通道损耗 (channel loss) 下的表现。这里的通道损耗由一阶 RC LPF 构成 (引入 post ISI)，RC_timeConstant 设置为 0.3 ~ 0.5 of bit period 等不同值，仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-17-20-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-17-21-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-17-31-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-17-28-09_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


从中观察到：所有 12-point 结果中，仅有 (THP, RC_timeConstant) = (+100 mV, 0.3 Tb) 这一组正常锁定了，其它的要么直接没能锁频，要么锁频了但是不满足 lock 条件。

- THP = +100 mV: 在通道损耗较大时 (RC >= 0.45\*Tb)，CK-FAST Logic 输出异常 (几乎恒为 1)，CK-SLOW Logic 都扳不回来。以 (THP, RC) = (+100 mV, 0.50\*Tb) 为例，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-17-51-45_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

- THP = +66.6 mV: 在通道损耗较大时 (RC >= 0.45\*Tb)，FD 输出倒是无明显异常，主要是 Lock Detection 太严格导致无法满足 lock 条件。以 (THP, RC) = (+66.6 mV, 0.50\*Tb) 为例，如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-18-23-35_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


为解决上述问题：
- (1) 将 THP 从原来的 CML_IR/2 = +100 mV 调整到 CML_IR/3 = +66.6 mV
- (2) 将 LD_LEVEL (lock detection threshold level) 从原来的 level = 4 (240/255) 调整到 level = 2 (192/255)，也即在 256 个周期内至少有 192 次无边沿穿过就认为锁定；


### 6.4 find best loop parameters

这一小节考察锁定之后的最佳环路参数，固定初始频差为零，data rms edge jitter = 30 mUI，锁定前 I_pd_total = 500 uA 和 SLOW/FAST gain = 36/32，锁定后 I_pd_total = 500 uA \* currentScale_locked 进行仿真。在 500 ns 窗口内观察 DATA 和 CK 情况，结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-18-36-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-03-18-43-03_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

图中看出当前环路参数及抖动设置下，锁定后的最佳电流为 I_cp_pd_total = 0.2\*500 uA = 110 uA。若无特别说明，后续将以此为锁定后的默认电流参数。 **在未锁定时，仍保持 I_cp_fd = I_cp_pd_total/2 的设置。**


本小节优化了锁定后的 CP current，以及上一小节优化了 THP 和 LD_LEVEL，调整后的仿真结果如下 (RC_timeConstant = 0.4\*Tb)：

（这里放图）



### 6.5 optimize lock detection logic

考虑到：
- (1) 保持 I_fd/I_pd 比例不变时，适当增大 I_pd 可以提升锁定能力，但会使锁定后的 jitter 变差，从而影响 LD_count 阈值设置
- (2) 适当降低 LD_count 阈值可以提升锁定能力，但会增加误判风险

我们选择做如下优化：
- (1) 将电路状态分为三步：unlocked (PD 大电流且开启 FD) --> locked (PD 电流较小且关闭 FD) --> deep-locked (PD 电流更小且关闭 FD)；由 flag_locked 连续三次为 1 来判断是否进入 deep-locked 状态 (CK_LD samples flag_locked)；进入 deep-locked 状态后，采用前一小节所得最佳环路参数： I_cp_pd_total = 110 uA @ (k_vco, R1, C1) = (5 GHz/V, 100 Ohm, 30 pF)
- (2) 为更灵活的调节 LD count threshold, 将其从 8-bit 温度计码控制 (128, 192, 224, 240, 248, 252, 254, 255) 改为 8-bit binary code (0 ~ 255)，这样就可以设置任意的 LD count threshold 了；但是需要一个 magnitude comparator 来比较 LD_count 与 LD_threshold 的大小关系；

优化后的仿真结果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-00-48-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-01-14-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-01-17-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>


我们分别将 `VA_CDRLoop_PAM3_quarterRate_withPFD` 和 `TB_CDR_PAM3_inputCML_quarterRate` 的原理图备份保存了，记作 `schematic_BK_20260304_v1_succeeded`.



### 6.6 low k_vco test

这一小节在较低的 k_vco 进行验证，确保环路具有可靠锁定能力。

下面是 k_vco = 500 MHz/V 时的仿真结果，4-point 均成功锁定：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-04-16-58-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

下面是 k_vco = 100 MHz/V 时的仿真结果，4-point 均成功锁定：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-13-30-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

然后是 k_vco = 100 MHz/V 但不同电流大小时的结果，倒也没有什么问题：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-03-05-13-38-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (1) Preparatory Work.png"/></div>

最后仿真一下 k_vco = 100 MHz/V 且电流极小 (I_cp_pd_total = 750 uA) 时能否锁定：

（这里放图）

可以正常锁定，图当时忘记截了。









