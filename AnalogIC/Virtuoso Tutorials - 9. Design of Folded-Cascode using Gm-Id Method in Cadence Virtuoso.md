# Design Example of Folded-Cascode Stage using Gm-Id Method in Cadence Virtuoso

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 15:03 on 2025-06-02 in Beijing.

!> **<span style='color:red'>Attention:</span>**<br>
注意：本文所使用的 gm-Id 方法是错误的，这会导致对晶体管静态工作点的估计有很大偏差（仅有部分参数基本准确），详见 [Design Conclusion of the Folded-Cascode Op Amp (v1_20250605)](<Electronics/Design Conclusion of the Folded-Cascode Op Amp (v1_20250605).md>)；正确的 gm-Id 方法请见 [An Introduction to gm-Id Methodology](<AnalogIC/Virtuoso Tutorials - 5. An Introduction to gm-Id Methodology.md>)。


## 0. Introduction

本文，我们基于 gm-Id 方法，在 MATLAB 的辅助下，使用台积电 180nm CMOS 工艺库 `tsmc18rf` 设计一个 **PMOS-input single-ended output folded-cascode stage**, 并进行比较充分的前仿验证。

开始设计之前，可以先回顾一下这几篇文章：
- [An Introduction to gm-Id Methodology](<AnalogIC/Virtuoso Tutorials - 5. An Introduction to gm-Id Methodology.md>)
- [Design Example of F-OTA using Overdrive and Gm-Id Methods](<AnalogIC/Virtuoso Tutorials - 6. Design Example of F-OTA using Gm-Id Method.md>)
- [Design of Op Amp using gm-Id Methodology Assisted by MATLAB](<AnalogIC/Design of Op Amp using gm-Id Methodology Assisted by MATLAB.md>)

主要设计指标如下：

<div class='center'>

| DC Gain | GBW | Load | PM | SR | CM Input Range | Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 80 dB | 50 MHz | 5 pF | 60° | 50 V/us | - 0.1 V ~ + 1.2 V | 1 V | 600 uA @ 1.8V (1.08 mW) |
</div>


## 1. Design Considerations

### 1.0 Design Specifications


<div class='center'>

| DC Gain | GBW | Load | PM | SR | CM Input Range | Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | 80 dB | 50 MHz | 5 pF | 60° | 50 V/us | - 0.1 V ~ + 1.2 V | 1 V | 600 uA @ 1.8V (1.08 mW) |
</div>


### 1.1 Export Transistor Data


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
; 快速导出 NMOS gm-Id 仿真数据

    ; 设置数据导出路径和器件名称
        ; 完整路径例如 "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data/tsmc18rf_gmIdData_nmos2v/tsmc18rf_gmIdData_nmos2v_test.txt"
        export_path = "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data"
        export_deviceName = "export_deviceName_export_deviceName"
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
; 快速导出 PMOS gm-Id 仿真数据

    ; 设置数据导出路径和器件名称
        ; 完整路径例如 "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data/tsmc18rf_gmIdData_nmos2v/tsmc18rf_gmIdData_nmos2v_test.txt"
        export_path = "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data"
        export_deviceName = "export_deviceName_export_deviceName"
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
            waveVsWave(?x OS("/PMOS" "gmoverid") ?y (abs(OS("/PMOS" "id")) / VAR("W")))
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

### 1.2 Theoretical Formulas

运放架构和 voltage requirements 如下图（注意第一个图中的是全差分，第二个图才是我们的实际架构）：


<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-17-16-13_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-17-21-04_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-20-51-42_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>


下面是各指标的理论公式，推导过程见文章 [Detailed Explanation of Cascode Op Amp](<Electronics/[Razavi CMOS] Detailed Explanation of Cascode Op Amp.md>)，这里直接给出结论：
- `DC Gain > 80dB` : $A_v = g_{m1} \cdot \left( \left[ (g_{m3} + g_{mb3})r_{O3}  (r_{O1}\parallel r_{O5}) \right] \parallel \left[ (g_{m7} + g_{mb7})r_{O7} r_{O9} \right] \right)$
- `GBW > 50 MHz` : $f_{p1} \approx \frac{1}{2\pi R_{out}C_L},\quad  \mathrm{GBW} = A_v \cdot f_{p1} = \frac{g_{m1}}{2\pi C_L}$
- `PM > 60°` : $f_{p2} \approx \frac{1}{2 \pi (\frac{1}{g_{m4}}\parallel r_{O2} \parallel r_{O6}) C_{Y}} > f_{p2}|_{\mathrm{PM = 60^\circ}} \approx 1.5 \,\mathrm{GBW}$,其中 $C_Y$ 是 Y 节点的等效总电容
- `SR > 50 V/us` : $SR = \frac{\min \{I_{SS},\ I_{D5}\}}{C_L}$, 令 $I_{SS} = I_{D5}$, 则 $SR = \frac{I_{SS}}{C_L}$
- `Input CM` : $(V_{in,CM})_{\max} = V_{DD} - |V_{OV11}| - |V_{OV1}| - |V_{TH1}|$, $(V_{in,CM})_{\min} = V_{OV5} - |V_{TH1}|$
- `Swing > 1 V` : $\mathrm{swing} = |V_{TH5}| + V_{TH3} + (V_{b2} - V_{b1})$
    - $(V_{b2})_{\max} = V_{DD} - |V_{OV7}| - |V_{OV5}| - |V_{TH5}|$
    - $(V_{b1})_{\min} = V_{OV5} + V_{OV3} + V_{TH3}$



### 1.3 Satisfying Specification



在考虑如何满足 Specifications 之前，需要对当前工艺的 NMOS/PMOS 性能有大致的了解，这也是为什么我们先 "Export Transistor Data" 再考虑 "Satisfying Specifications"
- (1) <span style='color:red'> 所有 NMOS 的 bulk 都接到 GND </span>, PMOS 的 bulk 默认接 source
- (2) `DC Gain > 80 dB` : 用近似 $A_v \approx g_{m1} \cdot \left( \left[ g_{m3}r_{O3}  (r_{O1}\parallel r_{O5}) \right] \parallel \left[ g_{m7}r_{O7} r_{O9} \right] \right)$ 来分配 DC Gain, 具体如下：
    - (2.1) <span style='color:red'> M7, M8 的 bulk 接到 VDD </span>, 留住 body-effect 以提高 DC Gain (尽管这会降低 swing), 仿真后如果发现 swing 确实偏小, 再改为连接 source, 牺牲增益换摆幅
    - (2.2) 令 $(g_m r_O)_3 = 250,\quad (g_m r_O)_7 = 300,\quad (g_m r_O)_{1} = 300$, 
    - (2.3) $\left(\frac{W}{L}\right)_9 = \left(\frac{W_7}{2 L_7}\right)$ 以适当增大 $r_{O9}$
    - (2.4) $L_5$ 应适当大一些以提高 $r_{O5}$
    - (2.5) 按照上面的考虑，我们的增益大约会有 $A_v = 300 \cdot (\frac{250}{2} \parallel 300 ) = 88 \ \mathrm{dB}$
- (3) `SR > 50 V/us` : 
    - (3.1) $SR = \frac{I_{SS}}{C_L} = \frac{I_{D5}}{C_L} \Longrightarrow I_{SS} = I_{D5} > 250 \ \mathrm{uA}$
    - (3.2) 主电路需要消耗 $2\,I_{SS}$, 偏置电路需要 2 ~ 3 路 $I_{REF}$, 不妨令 $I_{REF} = 8 I_{SS}$ 以方便 layout 工作，总 600 uA 最大可以有 252.6316 uA 的 $I_{SS}$, 因此我们令 $I_{SS} = 250 \ \mathrm{uA}$
- (4) `GBW > 50 MHz` :
    - (4.1) 从经验上来讲，我们说一个电路的 GBW 如果不高于晶体管截止频率的 1/50, 那么这个电路基本上是可以由当前工艺实现的。例如我们的指标要求 GBW = 50 MHz, 那么截止频率至少要达到 2.5 GHz. 在 TSMC 180nm 工艺中, NMOS 标准单元 (2u/180n) 的截止频率约 40 GHz, PMOS 标准单元 (2u/180n) 的截止频率约 13 GHz, 因此是可以实现的，但是 PMOS 的截止频率已经相对很低了，在设计中需要考虑到这一点（尺寸不能太大）
    - (4.2) $GBW = \frac{g_{m1}}{2\pi C_L} > 50 \ \mathrm{MHz}$, 我们令 GBW = 55 MHz, 则 $g_{m1} = 1.5708 \ \mathrm{mS} = \frac{1}{636.6} \ \mathrm{k\Omega}$, 这里的 $g_{m1}$ 与下面 `SR` 中的 $I_{SS}$ 共同决定了 M1, M2 的 $\left(\frac{g_m}{I_D}\right)$
- (5) `PM > 60°` : $f_{p2} = \frac{1}{2 \pi R_{Y} C_{Y}} > \sqrt{3} \,\mathrm{GBW} \Longrightarrow C_Y < \frac{1}{2 \pi R_{Y} \cdot \sqrt{3}\mathrm{GBW}}$, 我们先不考虑 PM 进行设计，仿真后如果发现 PM 过大或过小 ，再相应地放大或缩小 W/L
- (6) `Input CM = -0.1 V ~ +1.2 V` : 
    - (6.1) <span style='color:red'> M1 和 M2 的 bulk 短接到 source </span> 以避免 body-effect, 提高共模输入范围
    - (6.2) M11 的 overdrive 应尽量小，以增大输入共模范围，对 M11 的 $A,\ f_T$ 等要求不高，因此可以取较小的 overdrive
- (7)`Swing > 1 V` : 
    - (7.1) 先将 M5, M6 作为增大摆幅的主要方式，使其 overdrive 尽量小，以增大输出摆幅和共模输入范围，同时
    - (7.2) 如果最终摆幅仍不够, 可令 M3, M4, M7 ~ M10 在满足 $g_mr_O$ 的要求下，牺牲部分增益以减小 overdrive

上面的考虑可汇总为以下几条：
- $I_{D5} = I_{D11} = 250 \ \mathrm{uA}$
- 所有 NMOS (M3 ~ M6) 的 bulk 连接 GND, PMOS bulk 默认连接 source
- (P) M1, M2 : A = 300, gm/Id = 1.5708 mS / (0.5 * 0.25 mA) = 12.5664
- (N) M3, M4 : A = 250, 通过调整它们 (和 M5, M6) 的面积来控制 PM
- (N) M5, M6 : 高 L (高 rout), 无 A 需求, 通过调整它们 (和 M3, M4) 的面积来控制 PM
- (P) M7, M8 : A = 300, 适当降低 overdrive, bulk 接 VDD
- (P) M9, M10 : 如果可以的话, W9/L9 = W7/2*L7, 否则 M9, M10 = M7, M8
- (P) M11 : 低 overdrive, 暂无其它要求



### 1.4 Biasing Generations



$V_{b2}$ 的生成有多种方法，详见 [Biasing Circuits for Low-Voltage Cascode Current Mirror](<AnalogIC/Biasing Circuits for Low-Voltage Cascode Current Mirror.md>)，我们这里使用文中的第二种方法 **diode-connected series transistor**. 

对于 $V_{b1}$, $V_{b3}$ 和 $V_{b4}$, 直接用 multiplier 作 biasing 即可。




## 2. Design Details

上面的几个 subsection 都是在做设计前的准备工作，从这一 subsection 开始，我们便来一步步地确定每一个晶体管的具体尺寸。把上面 **3. Satisfying Specification** 一节中主电路的晶体管要求搬下来：
- $I_{D5} = I_{D11} = 250 \ \mathrm{uA}$
- 所有 NMOS (M3 ~ M6) 的 bulk 连接 GND, PMOS bulk 默认连接 source
- (P) M1, M2 : A = 300, gm/Id = 1.5708 mS / (0.5 * 0.25 mA) = 12.5664
- (N) M3, M4 : A = 250, 通过调整它们 (和 M5, M6) 的面积来控制 PM
- (N) M5, M6 : 高 L (高 rout), 无 A 需求, 通过调整它们 (和 M3, M4) 的面积来控制 PM
- (P) M7, M8 : A = 300, 适当降低 overdrive, bulk 接 VDD
- (P) M9, M10 : W9/L9 = W7/2*L7, 适当降低 overdrive
- (P) M11 : 低 overdrive, 暂无其它要求

### 2.1 determine sizes

#### 2.1.1 (P) M1, M2

**<span style='color:red'> 注意这是两个 PMOS </span>**, 设置 $A = 300$ 进行筛选，发现最小的 gm/Id 也要 15.42, 如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-23-51-53_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

太长的 L 并不是我们所希望的，因此这里降低一些增益要求，直接下面的尺寸，此时的 $(g_mr_O)_{1,2} \approx 250$：

$$
\begin{gather}
\left(\frac{g_m}{I_D} \right)_{1, 2} = 12.5664,\quad L_{1,2} = 1.8 \ \mathrm{um}
\end{gather}
$$

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-23-59-20_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
 -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-00-17-59_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

``` bash
Points satisfying objectives = 1/4221 = 0.0237 %
Best point: gm/Id  = 12.6938, length = 1.8 um
Parameters of the best point = 
    "index"             "1428"      
    "gm/Id"             "12.6938"   
    "L"                 "1.8e-06"   
    "selfGain"          "252.093"   
    "currentDensity"    "0.51203"   
    "transientFreq"     "77664700"  
    "overdrive"         "0.16489"   
    "vgs"               "0.603"     
    "gm"                "1.0318e-05"
    "rout"              "24432700"  
```


#### 2.1.2 (N) M3, M4

这是两个 NMOS, 筛选结果如下：

$$
\begin{gather}
\left(\frac{g_m}{I_D} \right)_{3, 4} = 13.4235,\quad L_{3,4} = 1.8 \ \mathrm{um}
\end{gather}
$$

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-03-23-57-02_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-00-19-19_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

``` bash
Points satisfying objectives = 4/4221 = 0.0948 %
Best point: gm/Id  = 13.4235, length = 1.8 um
Parameters of the best point = 
    "index"             "1386"      
    "gm/Id"             "13.4235"   
    "L"                 "1.8e-06"   
    "selfGain"          "259.227"   
    "currentDensity"    "2.2064"    
    "transientFreq"     "439631000" 
    "overdrive"         "0.16624"   
    "vgs"               "0.585"     
    "gm"                "5.1274e-05"
    "rout"              "5055780"   
```



#### 2.1.3 (N) M5, M6

$$
\begin{gather}
\left(\frac{g_m}{I_D} \right)_{5, 6} = 9.024,\quad L_{3,4} = 1.719 \ \mathrm{um}
\end{gather}
$$
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-00-03-18_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-00-20-36_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

``` bash
Points satisfying objectives = 475/4221 = 11.2533 %
Best point: gm/Id  = 9.024, length = 1.719 um
Parameters of the best point = 
    "index"             "1574"      
    "gm/Id"             "9.024"     
    "L"                 "1.719e-06" 
    "selfGain"          "147.008"   
    "currentDensity"    "5.0697"    
    "transientFreq"     "704355000" 
    "overdrive"         "0.23298"   
    "vgs"               "0.666"     
    "gm"                "8.3862e-05"
    "rout"              "1752970"   
```


#### 2.1.4 (P) M7, M8

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-00-28-29_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

``` bash
Points satisfying objectives = 12/4221 = 0.2843 %
Best point: gm/Id  = 15.4172, length = 1.8 um
Parameters of the best point = 
    "index"             "1323"      
    "gm/Id"             "15.4172"   
    "L"                 "1.8e-06"   
    "selfGain"          "307.04"    
    "currentDensity"    "0.3098"    
    "transientFreq"     "60360700"  
    "overdrive"         "0.13293"   
    "vgs"               "0.558"     
    "gm"                "7.6498e-06"
    "rout"              "40136700"  
```

#### 2.1.5 (P) M9, M10

同 M7, M8.

#### 2.1.6 (P) M11

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-00-33-03_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

``` bash
Points satisfying objectives = 19/4221 = 0.4501 %
Best point: gm/Id  = 13.2196, length = 0.342 um
Parameters of the best point = 
    "index"             "1389"      
    "gm/Id"             "13.2196"   
    "L"                 "3.42e-07"  
    "selfGain"          "62.7729"   
    "currentDensity"    "2.0662"    
    "transientFreq"     "1552380000"
    "overdrive"         "0.13836"   
    "vgs"               "0.594"     
    "gm"                "4.8143e-05"
    "rout"              "1303900"   
```


### 2.2 sizes adjustment

由于各支路的电路已经确定，$I_{D11} = I_{D5} = I_{D6} = I_{SS} = 250 \ \mathrm{uA}$, 其余的晶体管都是 $I_D = \frac{1}{2} I_{SS} = 125 \ \mathrm{uA}$, 因此，只要知道了晶体管的 gm/Id 和 L, 就可以计算出 Id/W, 进而计算出 W. 最终汇总为下面的表格：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-00-57-31_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-02-10-11_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

可以看到有几个晶体管，由于 current density 太小导致 width 过大，达到了好几百 um, 这是我们不愿看到的。因此，这里重新调整 M1, M2, M7 ~ M10 的，设置 M1 ~ M2, M7 ~ M10 的 current density 至少为 1 (对应 width = 125 um), 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-02-14-02_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-02-16-15_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-02-17-23_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

``` bash
# M1, M2
# 注意 GBW 和 Id 共同决定了 M1 的 gm/Id, 需 > 12.5664 才能满足 GBW 要求
# 为了提高 gm, 我们这里舍弃了一些 self gain
Points satisfying objectives = 30/4221 = 0.7107 %
Best point: gm/Id  = 13.2196, length = 0.666 um
Parameters of the best point = 
    "index"             "1393"     
    "gm/Id"             "13.2196"  
    "L"                 "6.66e-07" 
    "selfGain"          "117.313"  
    "currentDensity"    "1.1093"   
    "transientFreq"     "455288000"
    "overdrive"         "0.14838"  
    "vgs"               "0.594"    
    "gm"                "2.452e-05"
    "rout"              "4784370"  
```

``` bash
# M7, M8
Points satisfying objectives = 6/4221 = 0.1421 %
Best point: gm/Id  = 13.2196, length = 0.666 um
Parameters of the best point = 
    "index"             "1393"     
    "gm/Id"             "13.2196"  
    "L"                 "6.66e-07" 
    "selfGain"          "117.313"  
    "currentDensity"    "1.1093"   
    "transientFreq"     "455288000"
    "overdrive"         "0.14838"  
    "vgs"               "0.594"    
    "gm"                "2.452e-05"
    "rout"              "4784370"  
```

``` bash
# M9, M10
Points satisfying objectives = 138/4221 = 3.2694 %
Best point: gm/Id  = 10.3144, length = 1.314 um
Parameters of the best point = 
    "index"             "1527"      
    "gm/Id"             "10.3144"   
    "L"                 "1.314e-06" 
    "selfGain"          "159.271"   
    "currentDensity"    "1.0028"    
    "transientFreq"     "167308000" 
    "overdrive"         "0.19366"   
    "vgs"               "0.648"     
    "gm"                "1.7059e-05"
    "rout"              "9336700"   
```



### 2.3 devices summary

再作规整化调整，将 width 和 length 都调整为至多一位小数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-02-22-46_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-01-17-55_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-01-23-22_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->


### 2.4 biasing generations

对于 $V_{b2}$, 一种思路是 Mb7 = M7 且 Mb9 = 1/3 * M9. Mb9 的三分之一不妨缩减 width 达到, 取 multiplier 为 8, 则有：

$$
\begin{gather}
W_7 = 110 \ \mathrm{um} = 8 \times 13.75 \ \mathrm{um},\quad W_{b7} = 13.75 \ \mathrm{um} 
\\
W_9 = 125 \ \mathrm{um} = 8 \times 15.625 \ \mathrm{um},\quad W_{b9} = \frac{1}{3} \times 15.625 \ \mathrm{um} = 5.2083 \ \mathrm{um}
\end{gather}
$$

同理，对 $V_{b1},\ V_{b4}$ (M3 ~ M6) 和 $V_{b3}$ (M11), 直接用 multiplier = 8 作 biasing, 如下：

$$
\begin{gather}
I_{REF} = I_{SS}/8 = 31.25 \ \mathrm{uA}
,\quad 
W_{3,4} = 55 \ \mathrm{um} = 8 \times 6.875 \ \mathrm{um}
\\
W_{5,6} = 50 \ \mathrm{um} = 8 \times 6.25 \ \mathrm{um}
,\quad
W_{11} = 120 \ \mathrm{um} = 8 \times 15 \ \mathrm{um}
\end{gather}
$$

需要注意的是，由于我们没有在 biasing 中使用电阻，而是用 diode-connected 结构，一个晶体管便会消耗 0.6 ~ 0.7 的 voltage headroom, 因此需要分两或三路来做 biasing, 不能不管 voltage headroom 然后随意串接起来。具体而言, NMOS $V_{b1}$ 和 $V_{b4}$ 需要约 1.3 V, PMOS $V_{b2}$ 需要 0.5 V ~ 0.7 V, PMOS $V_{b3}$ 需要约 0.6 V. 需要注意， Mb7 的 bulk 要连接 VDD 以产生 body-effect, 减小对 M7 的偏置误差。





设置 biasing circuit 和 main circuit, **<span style='color:red'> 我们直接用 variables 来设置各晶体管的尺寸，这在设计初期是非常有用的，便于后续的调整和修改 </span>** 。如下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-15-28-14_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>


当然，如果对自己的设计有充分自信，直接填入尺寸也是可以的：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-12-37-50_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-02-44-08_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-02-31-17_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
 -->



## 3. simul. verification 3

<!-- 注：本文是 modified 版本，将冗余的两次仿真结果都删除了，并且把 design conclusion 加进来。 -->

### 3.0 dc operation point

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-18-18-57_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-18-19-32_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-18-18-12_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-18-27-59_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-14-10-23_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-14-09-52_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->

### 3.1 dc io-curve

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-14-16-43_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-14-20-03_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

### 3.2 buffer dc range

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-12-32-35_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-12-38-45_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-14-00-10_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

### 3.3 buffer tran and SR

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-13-22-33_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-13-33-44_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

从 step response 的瞬态仿真来看，似乎并没有达到 **PM improvement** 一节中所展示的 58°.

### 3.4 range of CM input

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-13-43-14_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>



## 4. Design Conclusion



下表总结了上面各个小节的仿真结果：
<div class='center'>

| Parameter | Value |
|:-:|:-:|
 | DC Gain | 80.27 dB @ Vin = 0.6 V |
 | GBW | 47.78 MHz @ Vin = 0.6 V in unit buffer |
 | PM | 52.09° @ Vin = 0.6 V in unit buffer |
 | Power dissipation | 590.3 uA @ 1.8V in unit buffer |
 | Open-loop swing  | (0.532 V, 1.352 V) = 0.820 V @ 60dB |
 | Buffer swing | (0.166 V, 1.413 V) = 1.247 V @ 0.900 V/V in unit buffer <br> (0.450 V, 1.276 V) = 0.826 V @ 0.999 V/V in unit buffer <br> (0.450 V, 1.303 V) = 0.850 V @ 1e-4 error in unit buffer | 
 | Slew rate | + 42.22 V/us, - 38.27 V/us @ (0.5 V, 1.2 V) step pulse in unit buffer |
 | CM Input range | (0.027 V, 1.342 V) = 1.315 V @ 60 dB |
</div>


下表是仿真值与指标要求的对比：

<div class='center'>

<span style='font-size:12px'> 

| Type | DC Gain | GBW | PM | Slew Rate | CM Input Range | Output Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Specifications | 80 dB | 50 MHz | 60° | 50 V/us | - 0.1 V ~ + 1.2 V | 1 V | 600 uA @ 1.8V (1.08 mW) |
 | Simulation Results | 80.27 dB | 47.78 MHz | 52.09° | +42.22 V/us, -38.27 V/us | + 0.027 V ~ + 1.342 V | 1.247 V| 590.3 uA @ 1.8V (1.063 mW) |

</span>
</div>

本文的篇幅已经相当长了，因此本次设计的总结将在另一篇文章 [this article](<Electronics/Design Conclusion of the Folded-Cascode Op Amp (v1_20250605).md>) 中进行。事实上，我们在本次设计 (以及上一次 [F-OTA](<AnalogIC/Virtuoso Tutorials - 6. Design Example of F-OTA using Gm-Id Method.md>) 的设计) 中，都犯了一个非常根本的错误：使用了错误的 gm-Id 设计流程。

