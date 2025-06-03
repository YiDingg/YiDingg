# Design Example of Folded-Cascode using Gm-Id Method in Cadence Virtuoso

> [!Note|style:callout|label:Infor]
> Initially published at 15:03 on 2025-06-02 in Beijing.


## Introduction

本文，我们基于 gm-Id 方法，在 MATLAB 的辅助下，使用台积电 180nm CMOS 工艺库 `tsmc18rf` 设计一个 **PMOS-input single-ended output folded-cascode stage**, 并进行比较充分的前仿验证。

开始设计之前，可以先回顾一下这几篇文章：
- [An Introduction to gm-Id Methodology](<Electronics/An Introduction to gm-Id Methodology.md>)
- [Design Example of F-OTA using Overdrive and Gm-Id Methods](<Electronics/Design Example of F-OTA using Gm-Id Method.md>)
- [Design of Op Amp using gm-Id Methodology Assisted by MATLAB](<Electronics/Design of Op Amp using gm-Id Methodology Assisted by MATLAB.md>)

主要设计指标如下：

<div class='center'>

| DC Gain | GBW | Load | PM | SR | Input CM | Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 80 dB | 50 MHz | 5 pF | 60° | 50 V/us | - 0.1 V ~ + 1.2 V | 1 V | 600 uA @ 1.8V (1.08 mW) |
</div>


## Design Considerations

### 1. Export Transistor Data


在 cadence 中进行仿真，设置 $V_{DS} = \frac{V_{DD}}{4} = 450 \ \mathrm{mV}$，第一变量为 $V_{gs}$，第二变量为 $L$，设置好 outputs, 运行仿真，结果如下：

``` bash
self gain (gm*rout)              = waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "self_gain"))
current density (Id/W)         = waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "id") / VAR("W")))
transient freq (gm/(Cgs+Cgd))  = waveVsWave(    ?x OS("/NMOS" "gmoverid")  ?y (OS("/NMOS" "gm") / (2*pi*abs((OS("/NMOS" "cgs") + OS("/NMOS" "cgd")))))    )
minimum overdrive (Vdsat)      = waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vdsat"))
gate-source voltage (Vgs)      = waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vgs"))
transconductance (gm)          = waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "gm"))
early resistance (rout)          = waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "rout"))
```



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-02-15-27-34_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-02-15-22-33_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

在 CIW 窗口输入下面代码，将数据导出为 `.txt` 格式 **<span style='color:red'> (注意修改导出路径) </span>** ：

``` bash
; 快速导出 gm-Id 仿真数据

    ; 设置数据导出路径和器件名称
        ; 完整路径例如 "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data/tsmc18rf_gmIdData_nmos2v/tsmc18rf_gmIdData_nmos2v_test.txt"
        export_path = "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data"
        export_deviceName = "tsmc18rf_gmIdData_nmos2v_450mVds"
        export_fileFormat = ".txt"
    ; 检查文件夹是否存在, 若不存在则创建 (否则无法导出数据, 会报错 "ERROR (PRINT-1032): Unable to write to output file")
    ; 通过 `system` 调用系统 shell 命令
        create_folder = strcat("mkdir -p ", export_path, "/", export_deviceName)
        system create_folder; mkdir -p /home/IC/a_Win_VM_shared/a_Misc/Cadence_Data/export_deviceName
    ; 创建各个数据的 filePathAndName
        path_selfGain = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_selfGain", export_fileFormat)
        path_currentDensity = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_currentDensity", export_fileFormat)
        path_transientFreq = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_transientFreq", export_fileFormat)
        path_overdrive = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_overdrive", export_fileFormat)
        path_vgs = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_vgs", export_fileFormat)
        path_gm = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_gm", export_fileFormat)
        path_rout = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_rout", export_fileFormat)
    ; 导出数据
        ocnPrint(   ; 1. 导出 self gain (gm*rout)
            ?output path_selfGain
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "self_gain"))
        )
        ocnPrint(   ; 2. 导出 current density (Id/W)
            ?output path_currentDensity
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y abs(OS("/NMOS" "id") / VAR("W")))
        )
        ocnPrint(   ; 3. transient freq (gm/2*pi*((Cgs+Cgd)))
            ?output path_transientFreq
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "gm") / (2 * 3.1415926 * abs((OS("/NMOS" "cgs") + OS("/NMOS" "cgd"))))))
        )
        ocnPrint(   ; 4. 导出 minimum overdrive (Vdsat)
            ?output path_overdrive
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vdsat"))
        )
        ocnPrint(   ; 5. gate-source voltage (Vgs)
            ?output path_vgs
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vgs"))
        )
        ocnPrint(   ; 6. transconductance (gm)
            ?output path_gm
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "gm"))
        )
        ocnPrint(   ; 7. early resistance (rout)
            ?output path_rout
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "rout"))
        )
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-02-15-44-33_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>


在 MATLAB 中运行程序，读取这些数据，得到图像如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-18-05-01_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

上面的 `rout` (最后一个图) 的 z 坐标取了 `log10`, 也即 z 坐标 5 对应 $10^5 \ \Omega$。


同理，对 PMOS 进行仿真扫描，输入代码导出数据，得到以下结果：

``` bash
; 快速导出 gm-Id 仿真数据

    ; 设置数据导出路径和器件名称
        ; 完整路径例如 "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data/tsmc18rf_gmIdData_nmos2v/tsmc18rf_gmIdData_nmos2v_test.txt"
        export_path = "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data"
        export_deviceName = "tsmc18rf_gmIdData_pmos2v_450mVds"
        export_fileFormat = ".txt"
    ; 检查文件夹是否存在, 若不存在则创建 (否则无法导出数据, 会报错 "ERROR (PRINT-1032): Unable to write to output file")
    ; 通过 `system` 调用系统 shell 命令
        create_folder = strcat("mkdir -p ", export_path, "/", export_deviceName)
        system create_folder; mkdir -p /home/IC/a_Win_VM_shared/a_Misc/Cadence_Data/export_deviceName
    ; 创建各个数据的 filePathAndName
        path_selfGain = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_selfGain", export_fileFormat)
        path_currentDensity = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_currentDensity", export_fileFormat)
        path_transientFreq = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_transientFreq", export_fileFormat)
        path_overdrive = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_overdrive", export_fileFormat)
        path_vgs = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_vgs", export_fileFormat)
        path_gm = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_gm", export_fileFormat)
        path_rout = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_rout", export_fileFormat)
    ; 导出数据
        ocnPrint(   ; 1. 导出 self gain (gm*rout)
            ?output path_selfGain
            ?numberNotation 'scientific
            waveVsWave(?x OS("/PMOS" "gmoverid") ?y OS("/PMOS" "self_gain"))
        )
        ocnPrint(   ; 2. 导出 current density (Id/W)
            ?output path_currentDensity
            ?numberNotation 'scientific
            waveVsWave(?x OS("/PMOS" "gmoverid") ?y (OS("/PMOS" "id") / VAR("W")))
        )
        ocnPrint(   ; 3. transient freq (gm/2*pi*((Cgs+Cgd)))
            ?output path_transientFreq
            ?numberNotation 'scientific
            waveVsWave(?x OS("/PMOS" "gmoverid") ?y (OS("/PMOS" "gm") / (2 * 3.1415926 * abs((OS("/PMOS" "cgs") + OS("/PMOS" "cgd"))))))
        )
        ocnPrint(   ; 4. 导出 minimum overdrive (Vdsat)
            ?output path_overdrive
            ?numberNotation 'scientific
            waveVsWave(?x OS("/PMOS" "gmoverid") ?y abs(OS("/PMOS" "vdsat")))
        )
        ocnPrint(   ; 5. gate-source voltage (Vgs)
            ?output path_vgs
            ?numberNotation 'scientific
            waveVsWave(?x OS("/PMOS" "gmoverid") ?y abs(OS("/PMOS" "vgs")))
        )
        ocnPrint(   ; 6. transconductance (gm)
            ?output path_gm
            ?numberNotation 'scientific
            waveVsWave(?x OS("/PMOS" "gmoverid") ?y OS("/PMOS" "gm"))
        )
        ocnPrint(   ; 7. early resistance (rout)
            ?output path_rout
            ?numberNotation 'scientific
            waveVsWave(?x OS("/PMOS" "gmoverid") ?y OS("/PMOS" "rout"))
        )
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-18-26-38_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-18-31-46_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

对比 NMOS 和 PMOS 的性能数据，可以粗略看出下面几点：
- PMOS 的 `gm` 稍低，但 `rout` 高得更多一些, 使得 self gain (gm*rout) 相对更高
- PMOS 的 curren density (Id/W), transient freq (gm/(Cgs+Cgd)) 更低

### 2. Theoretical Formulas

运放架构和 voltage requirements 如下图（注意第一个图中的是全差分，第二个图才是我们的实际架构）：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-17-16-13_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-20-51-42_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>


下面是各指标的理论公式，推导过程见文章 [[Razavi CMOS] Detailed Explanation of Cascode Op Amp](<Electronics/[Razavi CMOS] Detailed Explanation of Cascode Op Amp.md>)，这里直接给出结论：
- `DC Gain > 80dB` : $A_v = g_{m1} \cdot \left( \left[ (g_{m3} + g_{mb3})r_{O3}  (r_{O1}\parallel r_{O5}) \right] \parallel \left[ (g_{m7} + g_{mb7})r_{O7} r_{O9} \right] \right)$
- `GBW > 50 MHz` : $f_{p1} \approx \frac{1}{2\pi R_{out}C_L},\quad  \mathrm{GBW} = A_v \cdot f_{p1} = \frac{g_{m1}}{2\pi C_L}$
- `PM > 60°` : $f_{p2} \approx \frac{1}{2 \pi (\frac{1}{g_{m4}\parallel r_{O2} \parallel r_{O6}}) C_{Y}} > f_{p2}|_{\mathrm{PM = 60^\circ}} \approx \sqrt{3} \,\mathrm{GBW}$,其中 $C_Y$ 是 Y 节点的等效总电容
- `SR > 50 V/us` : $SR = \frac{\min \{I_{SS},\ I_{D9}\}}{C_L}$, 令 $I_{SS} = I_{D9}$, 则 $SR = \frac{I_{SS}}{C_L}$
- `Input CM` : $(V_{in,CM})_{\max} = V_{DD} - |V_{OV11}| - |V_{OV1}| - |V_{TH1}| $, $(V_{in,CM})_{\min} = V_{OV5} - |V_{TH1}|$
- `Swing > 1 V` : $\mathrm{swing} = |V_{TH5}| + V_{TH3} + (V_{b2} - V_{b1})$
    - $(V_{b2})_{\max} = V_{DD} - |V_{OV7}| - |V_{OV5}| - |V_{TH5}|$
    - $(V_{b1})_{\min} = V_{OV5} + V_{OV3} + V_{TH3}$



### 3. Satisfying Specification



在考虑如何满足 Specifications 之前，需要对当前工艺的 NMOS/PMOS 性能有大致的了解，这也是为什么我们先 "Export Transistor Data" 再考虑 "Satisfying Specifications"
- <span style='color:red'> 所有 NMOS 的 bulk 都接到 GND </span>, PMOS 的 bulk 默认接 source
- `DC Gain > 80 dB` : 用近似 $A_v \approx g_{m1} \cdot \left( \left[ g_{m3}r_{O3}  (r_{O1}\parallel r_{O5}) \right] \parallel \left[ g_{m7}r_{O7} r_{O9} \right] \right)$ 来分配 DC Gain, 具体如下：
    - <span style='color:red'> M7, M8 的 bulk 接到 VDD </span>, 留住 body-effect 以提高 DC Gain (尽管这会降低 swing), 仿真后如果发现 swing 确实偏小, 再改为连接 source, 牺牲增益换摆幅
    - 令 $(g_m r_O)_3 = 250,\quad (g_m r_O)_7 = 300,\quad (g_m r_O)_{1} = 300$, 
    - $\left(\frac{W}{L}\right)_9 = \left(\frac{W_7}{2 L_7}\right)$ 以适当增大 $r_{O9}$
    - $L_5$ 应适当大一些以提高 $r_{O5}$
    - 按照上面的考虑，我们的增益大约会有 $A_v = 300 \cdot (\frac{250}{2} \parallel 300 ) = 88 \ \mathrm{dB}$
- `SR > 50 V/us` : 
    - $SR = \frac{I_{SS}}{C_L} = \frac{I_{D5}}{C_L} \Longrightarrow I_{SS} = I_{D5} > 250 \ \mathrm{uA}$
    - 主电路需要消耗 $2I_{SS}$, 偏置电路 2 ~ 3 路 $I_{REF}$, 不妨令 $I_{REF} = 8 I_{SS}$ 以方便 layout 工作，总 600 uA 最大可以有 252.6316 uA 的 $I_{SS}$, 因此我们令 $I_{SS} = 250 \ \mathrm{uA}$
- `GBW > 50 MHz` :
    - 从经验上来讲，我们说一个电路的 GBW 如果不高于晶体管截止频率的 1/50, 那么这个电路基本上是可以由当前工艺实现的。例如我们的指标要求 GBW = 50 MHz, 那么截止频率至少要达到 2.5 GHz. 在 TSMC 180nm 工艺中, NMOS 标准单元 (2u/180n) 的截止频率约 40 GHz, PMOS 标准单元 (2u/180n) 的截止频率约 13 GHz, 因此是可以实现的，但是 PMOS 的截止频率已经相对很低了，在设计中需要考虑到这一点（尺寸不能太大）
    - $GBW = \frac{g_{m1}}{2\pi C_L} > 50 \ \mathrm{MHz}$, 我们令 GBW = 55 MHz, 则 $g_{m1} = 1.5708 \ \mathrm{mS} = \frac{1}{636.6} \ \mathrm{k\Omega}$, 这里的 $g_{m1}$ 与下面 `SR` 中的 $I_{SS}$ 共同决定了 M1, M2 的 $\left(\frac{g_m}{I_D}\right)$
- `PM > 60°` : $f_{p2} = \frac{1}{2 \pi R_{Y} C_{Y}} > \sqrt{3} \,\mathrm{GBW} \Longrightarrow C_Y < \frac{1}{2 \pi R_{Y} \cdot \sqrt{3}\mathrm{GBW}}$, 我们先不考虑 PM 进行设计，仿真后如果发现 PM 过大或过小 ，再相应地放大或缩小 W/L
- `Input CM = -0.1 V ~ +1.2 V` : 
    - <span style='color:red'> M1 和 M2 的 bulk 短接到 source </span> 以避免 body-effect, 提高共模输入范围
    - M11 的 overdrive 应尽量小，以增大输入共模范围，对 M11 的 $A,\ f_T$ 等要求不高，因此可以取较小的 overdrive
- `Swing > 1 V` : 
    - 先将 M5, M6 作为增大摆幅的主要方式，使其 overdrive 尽量小，以增大输出摆幅和共模输入范围，同时
    - 如果最终摆幅仍不够, 可令 M3, M4, M7 ~ M10 在满足 $g_mr_O$ 的要求下，牺牲部分增益以减小 overdrive

上面的考虑可汇总为以下几条：
- $I_{D5} = I_{D11} = 250 \ \mathrm{uA}$
- 所有 NMOS (M3 ~ M6) 的 bulk 连接 GND, 
- M1, M2 : A = 300, gm/Id = 1.5708 mS / (0.5 * 0.25 mA) = 12.5664, bulk 接 source
- M3, M4 : A = 250, 通过调整它们 (和 M5, M6) 的面积来控制 PM
- M5, M6 : 高 L, 无 A 需求, 通过调整它们 (和 M3, M4) 的面积来控制 PM
- M7, M8 : A = 300, 适当降低 overdrive, bulk 接 VDD
- M9, M10 : W9/L9 = W7/2*L7, 适当降低 overdrive
- M11 : 低 overdrive, 暂无其它要求


### 4. Simul. without Biasing


### 5. Biasing Generations

对于 $V_{b4}$ 和 $V_{b1}$, 


$V_{b2}$ 的生成有多种方法，详见 [Biasing Circuits for Low-Voltage Cascode Current Mirror](<Electronics/Biasing Circuits for Low-Voltage Cascode Current Mirror.md>)，我们这里使用文中的第二种方法 **diode-connected series transistor**. 







## Design Example



### 0.1 General Consideration

### 1. Input Pair (M1, M2)

上面的几个 subsection 都是在做设计前的准备工作，从这一 subsection 开始，我们便来一步步地确定每一个晶体管的具体尺寸。

### 2. Load Transistors

参考 [](<>), 我们直接取




## Simulation Verification

## Design Conclusion
