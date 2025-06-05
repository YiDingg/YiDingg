# Design Example of Folded-Cascode using Gm-Id Method in Cadence Virtuoso

> [!Note|style:callout|label:Infor]
> Initially published at 15:03 on 2025-06-02 in Beijing.


## 0. Introduction

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


## 1. Design Considerations

### 1.0 Design Specifications


<div class='center'>

| DC Gain | GBW | Load | PM | SR | Input CM | Swing | Power Dissipation |
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


下面是各指标的理论公式，推导过程见文章 [[Razavi CMOS] Detailed Explanation of Cascode Op Amp](<Electronics/[Razavi CMOS] Detailed Explanation of Cascode Op Amp.md>)，这里直接给出结论：
- `DC Gain > 80dB` : $A_v = g_{m1} \cdot \left( \left[ (g_{m3} + g_{mb3})r_{O3}  (r_{O1}\parallel r_{O5}) \right] \parallel \left[ (g_{m7} + g_{mb7})r_{O7} r_{O9} \right] \right)$
- `GBW > 50 MHz` : $f_{p1} \approx \frac{1}{2\pi R_{out}C_L},\quad  \mathrm{GBW} = A_v \cdot f_{p1} = \frac{g_{m1}}{2\pi C_L}$
- `PM > 60°` : $f_{p2} \approx \frac{1}{2 \pi (\frac{1}{g_{m4}\parallel r_{O2} \parallel r_{O6}}) C_{Y}} > f_{p2}|_{\mathrm{PM = 60^\circ}} \approx 1.5 \,\mathrm{GBW}$,其中 $C_Y$ 是 Y 节点的等效总电容
- `SR > 50 V/us` : $SR = \frac{\min \{I_{SS},\ I_{D9}\}}{C_L}$, 令 $I_{SS} = I_{D9}$, 则 $SR = \frac{I_{SS}}{C_L}$
- `Input CM` : $(V_{in,CM})_{\max} = V_{DD} - |V_{OV11}| - |V_{OV1}| - |V_{TH1}| $, $(V_{in,CM})_{\min} = V_{OV5} - |V_{TH1}|$
- `Swing > 1 V` : $\mathrm{swing} = |V_{TH5}| + V_{TH3} + (V_{b2} - V_{b1})$
    - $(V_{b2})_{\max} = V_{DD} - |V_{OV7}| - |V_{OV5}| - |V_{TH5}|$
    - $(V_{b1})_{\min} = V_{OV5} + V_{OV3} + V_{TH3}$



### 1.3 Satisfying Specification



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
    - 主电路需要消耗 $2\,I_{SS}$, 偏置电路需要 2 ~ 3 路 $I_{REF}$, 不妨令 $I_{REF} = 8 I_{SS}$ 以方便 layout 工作，总 600 uA 最大可以有 252.6316 uA 的 $I_{SS}$, 因此我们令 $I_{SS} = 250 \ \mathrm{uA}$
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
- 所有 NMOS (M3 ~ M6) 的 bulk 连接 GND, PMOS bulk 默认连接 source
- (P) M1, M2 : A = 300, gm/Id = 1.5708 mS / (0.5 * 0.25 mA) = 12.5664
- (N) M3, M4 : A = 250, 通过调整它们 (和 M5, M6) 的面积来控制 PM
- (N) M5, M6 : 高 L (高 rout), 无 A 需求, 通过调整它们 (和 M3, M4) 的面积来控制 PM
- (P) M7, M8 : A = 300, 适当降低 overdrive, bulk 接 VDD
- (P) M9, M10 : 如果可以的话, W9/L9 = W7/2*L7, 否则 M9, M10 = M7, M8
- (P) M11 : 低 overdrive, 暂无其它要求



### 1.4 Biasing Generations



$V_{b2}$ 的生成有多种方法，详见 [Biasing Circuits for Low-Voltage Cascode Current Mirror](<Electronics/Biasing Circuits for Low-Voltage Cascode Current Mirror.md>)，我们这里使用文中的第二种方法 **diode-connected series transistor**. 

对于 $V_{b1}$, $V_{b3}$ 和 $V_{b4}$, 直接用 multiplier 作 biasing 即可。




## 2. Design Example

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




## 3. simul. verification 1

### 3.0 dc operation point

设置好端口 VDD, VSS 和 Vin+- 的值，依次设置 `Vin_CM = 0.9 V, 0.4 V, 0 V`, 运行 dc 仿真，结果如下：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-15-34-18_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
 -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-16-01-39_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-16-02-22_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-16-03-11_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>


在 `Vin_CM = 0.9 V` 和 `Vin_CM = 0.4 V` 时，通过 vds 和 vdsat 可以看出：所有的 MOSFET 都处于 saturation 区域 (NMOS vds > vdsat > 0, PMOS vds < vdsat < 0), 因此我们的设计整体是没有什么大问题的。但是 `Vin_CM = 0 V` 时，输入管进入 triode region, 这是因为我们在偏置电路中犯了一个典型错误，错误地设置了 M3, M4 的 gate voltage $V_{b1}$。在上面的几个图中，$V_{b1} \approx 1.5 \ \mathrm{V}$ 过高，应该按照本文开头就提高的 biasing voltage requirements 来设置 $V_{b1}$，具体示例见文章 [[Razavi CMOS] Design Example of Folded-Cascode Stage](<Electronics/[Razavi CMOS] Design Example of Folded-Cascode Stage.md>)。下面就先解决这个问题。

### 3.1 biasing correction


从文章 [[Razavi CMOS] Design Example of Folded-Cascode Stage](<Electronics/[Razavi CMOS] Design Example of Folded-Cascode Stage.md>) 中可以看到， **<span style='color:red'> $V_{b1}$ 应该与 $V_{b2}$ 一齐被设置，通常与 $V_{b2}$ 差别不大，并且要尽量降低 $V_{b1}$ (提高 $V_{b2}$) 以提高 output swing. </span>** 如果 swing 已经足够，或者不希望在电路中加入电阻，可以直接将 $V_{b1}$ 连接到 $V_{b2}$ (其实早晚得加入，毕竟 $I_{REF}$ 的生成一般都需要电阻)。对我们来讲，为了提高电路性能，还是对 $V_{b1}$ 和 $V_{b2}$ 作一些分析和调整比较好。

先将各晶体管的 model parameters 列出，因为计算时需要用到 VTH (vto):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-17-02-54_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

在 **1.2 Theoretical Formulas** 一节中我们知道，要使 Vin_CM 达到 - 0.1 V 时还正常工作，$V_{b1}$ 的绝对范围是：

$$
\begin{gather}
V_{I_{SS1}} + V_{VO3} + V_{TH3} < V_{b1} < V_{in,CM} + V_{OV3} + V_{TH3} + |V_{TH1}|
\\
V_{OV5} + V_{VO3} + V_{TH3} < V_{b1} < (-0.1 \ \mathrm{V}) + V_{OV3} + V_{TH3} + |V_{TH1}|
\\
227 \ \mathrm{mV} + 166 \ \mathrm{mV} + 430\ \mathrm{mV} < V_{b1} < -100 \ \mathrm{mV} + 166 \ \mathrm{mV} + 430\ \mathrm{mV} + 452 \ \mathrm{mV}
\\
\Longrightarrow 
V_{b1} \in (0.823 \ \mathrm{V}, 0.948 \ \mathrm{V})
\end{gather}
$$

而 $V_{b2}$ 的范围是：

$$
\begin{gather}
V_{b2} < V_{DD} - |V_{OV9}| - |V_{OV7}| - |V_{TH7}| = 1800 \ \mathrm{mV} - 185 \ \mathrm{mV} - 150 \ \mathrm{mV} - 452 \mathrm{mV} = 1.013 \ \mathrm{V}
\end{gather}
$$

我们当前的 $V_{b1} = 1.474 \ \mathrm{V},\ \ V_{b2} = 0.743 \ \mathrm{V}$，仍有很多调整的空间。为了提高性能，我们希望将 $V_{b2}$ 提升至 0.95 V 左右，同时将 $V_{b1}$ 降低至 0.85 V 左右。此时，$V_{b1}$ 略低于 $ V_{b2}$，先调整 Vb2 至目标值 (修改 Mb9 的尺寸)，然后从 $V_{b2}$ 下方串联一个电阻来获得 $V_{b1}$。 250/8 = 31.25 uA 的 Iref, 要产生 0.1 V 的压差，需要电阻 3.2 kOhm。

我们将 Mb9 的 fraction 从 1/3 调整为了 1，然后添加了电阻，参数和结果如下图所示：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-17-36-58_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-18-02-16_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-17-39-03_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

可以发现 $V_{b1}$ 和 $V_{b2}$ 都较好地达到了预期值，并且所有的晶体管都位于饱和区，处在正常工作状态。此时，$V_{in,CM}$ 和 output swing 的范围大约是：

$$
\begin{align}
V_{in,CM} &\in 
\left(  
    V_{b1} - V_{OV3} - V_{TH3} - |V_{TH1}|,\ \ 
    V_{DD} - V_{I_{SS}} - |V_{OV1}| - |V_{TH1}|
\right)
\\
& = \left(  
    863 \ \mathrm{mV} - 152 \ \mathrm{mV} - 526 \mathrm{mV} - 460 \mathrm{mV},\ \ 
    1800 \ \mathrm{mV} - 134 \ \mathrm{mV}  - 152 \mathrm{mV} - 460 \mathrm{mV}
\right) 
\\
& = \left(  
    -0.275 \ \mathrm{V},\ 1.054 \ \mathrm{V}
\right)
\\
V_{out} &\in 
\left(  
    V_{b1} - V_{TH3},\ \ 
    V_{b2} + |V_{TH7}|
\right)
\\
& = \left(  
    863 \ \mathrm{mV} - 526 \mathrm{mV},\ 
    963 \ \mathrm{mV} + 522 \mathrm{mV}
\right) 
\\
& = \left(  
    337 \ \mathrm{mV},\ 1.485 \ \mathrm{V}
\right)
\end{align}
$$



后续我们会通过仿真来验证这个输入输出范围。现在不妨看一看其它 fraction 对应的电压状况：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-17-41-13_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-17-42-06_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-17-44-31_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-17-45-51_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>



### 3.2 create symbol

在开始进一步的仿真之前，我们需要先创建电路的 symbol, 但是注意，如果我们的 schematic 中存在 variables, 那么在添加这个 symbol 作为 instance 时，这些 design variables 也会被添加进来，需要在 `ADE L > Copy From Cellview` 并设置它们的值。


创建 symbol 的具体步骤为：在 schematic 界面，点击 `Create > Cellview > From Cellview`，无需改名，直接创建即可 (这里创建的是 symbol, 它会和 schematic 在同一 cellview 下), 创建好的 symbol 如图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-12-51-00_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

我们这里把 `instanceName` 放在了运放正中间，这样，放置运放时所设置的 name (例如 `OPA1`) 就会显示在运放的正中间，便于识别。这里的 `partName` 就是 symbol 对应 schematic 的 cellview 名称。


### 3.3 dc io-curve

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-20-30-52_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-20-31-38_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-20-31-10_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->

增益只有 60 dB, 需要重新调整 Vb1 和 Vb2. 我们通过修改电阻 $R$ 和参数 frac 来实现。经过迭代，将 Vb1 调整至高于 Vb2, 且 R = 2 kOhm, frac = 0.65, 此时的 IO-curve 为：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-20-50-12_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

### 3.4 dc gain correction

大概有 76 dB 的最高增益，这仍然无法达到要求，这是为什么呢？参考文章 [How to Use Cadence Efficiently](<Electronics/How to Use Cadence Efficiently.md>) 中的 tip, 将晶体管的 self_gain 等静态工作点在 schematic 中直接标出，结果如下：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-23-12-17_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
 -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-23-20-06_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-23-23-50_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

按照上面的工作点来计算直流增益，结果为 $A_v \approx 3210.6 = 70.13 \ \mathrm{dB}$ 确实是不够的。这说明我们在增益公式中作安排时，大概是存在不合理的地方，重新回顾增益公式：

$$
\begin{gather}
A_v \approx g_{m1} \cdot \left( \left[ g_{m3}r_{O3}  (r_{O1}\parallel r_{O5}) \right] \parallel \left[ g_{m7}r_{O7} r_{O9} \right] \right)
\end{gather}
$$

需要多大的 rout 才能满足增益要求？看下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-04-23-41-56_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

### 3.5 determine sizes

从上面可以看出，我们直接令 `width = 2u, vds = 450 mV` 扫描得到的数据，其“可信度”非常有限。为了使扫描所得数据更贴近实际情况，我们令 `W = 50u, vdc = 300 mV`, **<span style='color:red'> 并且在晶体管的 drain 串联一个大小合适的电阻 </span>**，使晶体管在 strong inversion 时恰好进入 saturation. 

NMOS: 
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-00-01-35_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-00-11-01_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

PMOS: 
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-00-18-15_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-00-17-32_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

然后重新确定 M1, M3, M5, M7 和 M9 的参数。需要说明的是，为了达到增益要求，我们不得不放宽 currentDensity, 也即消耗更大的面积

``` bash
# PMOS M1
Points satisfying objectives = 1/4221 = 0.0237 %
Best point: gm/Id  = 14.4471, length = 0.261 um
Parameters of the best point = 
    "index"             "1346"      
    "gm/Id"             "14.4471"   
    "L"                 "2.61e-07"  
    "selfGain"          "30.6252"   
    "currentDensity"    "2.1036"    
    "transientFreq"     "2268630000"
    "overdrive"         "0.11884"   
    "vgs"               "0.576"     
    "gm"                "0.0013918" 
    "rout"              "22003.9"   


# NMOS M3
Points satisfying objectives = 9/4221 = 0.2132 %
Best point: gm/Id  = 20.2074, length = 1.8 um
Parameters of the best point = 
    "index"             "1092"      
    "gm/Id"             "20.2074"   
    "L"                 "1.8e-06"   
    "selfGain"          "256.525"   
    "currentDensity"    "0.34678"   
    "transientFreq"     "240092000" 
    "overdrive"         "0.083721"  
    "vgs"               "0.459"     
    "gm"                "0.00032192"
    "rout"              "796858"    


# NMOS M5
Points satisfying objectives = 68/4221 = 1.6110 %
Best point: gm/Id  = 18.8674, length = 1.8 um
Parameters of the best point = 
    "index"             "1155"      
    "gm/Id"             "18.8674"   
    "L"                 "1.8e-06"   
    "selfGain"          "231.787"   
    "currentDensity"    "0.56202"   
    "transientFreq"     "255555000" 
    "overdrive"         "0.097471"  
    "vgs"               "0.486"     
    "gm"                "0.00048259"
    "rout"              "480294"    

# PMOS M7
Points satisfying objectives = 4/4221 = 0.0948 %
Best point: gm/Id  = 17.3621, length = 1.8 um
Parameters of the best point = 
    "index"             "1260"      
    "gm/Id"             "17.3621"   
    "L"                 "1.8e-06"   
    "selfGain"          "209.316"   
    "currentDensity"    "0.21477"   
    "transientFreq"     "51118700"  
    "overdrive"         "0.11231"   
    "vgs"               "0.531"     
    "gm"                "0.00015297"
    "rout"              "1368360"   


# PMOS M9
Points satisfying objectives = 138/4221 = 3.2694 %
Best point: gm/Id  = 13.2763, length = 1.638 um
Parameters of the best point = 
    "index"             "1405"     
    "gm/Id"             "13.2763"  
    "L"                 "1.638e-06"
    "selfGain"          "109.23"   
    "currentDensity"    "0.50623"  
    "transientFreq"     "89218100" 
    "overdrive"         "0.15439"  
    "vgs"               "0.594"    
    "gm"                "0.0002715"
    "rout"              "402317"   

```




这样得到的增益至少为 $A_v > 7.3727e+03 = 77.35 \ \mathrm{dB}$, 各晶体管参数如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-00-51-16_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>


## 4. simul. verification 2

### 4.0 dc operation point

注意 R 的位置改变了, 然后 M3 工作在 weak inversion 区域。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-01-20-14_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>


### 4.1 dc io-curve

扫描 R 和 frac, 根据仿真结果调整它们的值：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-01-46-01_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-01-47-45_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-01-51-11_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

于是最终我们选择了：

$$
\begin{gather}
R = 2000 \ \Omega,\quad \mathrm{frac} = 0.3 
\end{gather}
$$

在这个参数下，我们看看不同共模输入对应的曲线：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-01-53-55_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

`Vin_CM` 从 - 0.1 V 至 + 1.2 V 都可正常工作，增益也足够，终于满足要求了！！！


### 4.2 frequency response


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-02-06-15_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

GBW 约为 34.4 MHz, PM 大约在 38° 左右，这个相位裕度显然是不够的，需要作出调整。从频响曲线可以看出，这是一个三阶系统，具有三个极点和一个左半平面的零点，并且 $f_{p2}, f_{p3}, f_{z}$ 的频率相近。


要改善性能，提高 PM, 一种思路是提高 $f_{p2}$ 至 1.5 GBW @ PM = 60°，或者 2.6 GBW @ PM = 70°, $f_{p2}$ 与 GBW 的关系见文章 [Relationship Between GBW and fp2 in a Tow-Order System](<Electronics/Relationship Between GBW and fp2 in a Tow-Order System.md>)；另一种思路是降低 $f_{z}$, 但是 $f_z$ 表达式的理论公式比较麻烦，需要我们完整地推导小信号模型。于是我们考虑对 $f_{p2}$ 和 $f_{p3}$ 作调整。


### 4.3 improve PM and GBW

下面就来调整其中几个晶体管，以期改善相位裕度。先记录改善前的晶体管尺寸、静态工作点与频率响应：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-10-17-25_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-10-21-54_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
 -->

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-10-53-56_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-10-55-01_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-11-16-04_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-11-16-39_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-10-32-19_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-11-01-38_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-11-01-47_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-11-04-24_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-10-39-27_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->

在 Id 不变的情况下，有平方律参考公式：

$$
\begin{gather}
r_O = \frac{1}{\lambda I_D} \propto L,\quad g_m = \sqrt{2 \beta \frac{W}{L} I_D} \propto \sqrt{\frac{W}{L}}
,\quad 
g_m r_O \propto \sqrt{W L}
\end{gather}
$$

修改思路：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-10-18-50_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

先考虑 M3, 要在提高 gm 、降低电容的同时, 保持 gm*rO 不变, 且 width 尽量不变, 可以考虑减小 length, 扫描结果如下：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-11-28-04_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-11-29-25_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

于是将 M3 的 length 修改为 `L3 = 1.8u > 1.38u`, 然后考虑 M9, 对其 width, length 进行扫描, 并不断迭代：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-11-41-34_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-11-46-06_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-11-46-21_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

上图中的绿色、青色和蓝色都具有较好的性能，也即 `width = (92u, 164u)`, 于是令 `W9/L9 = 130u/0.6u`。此时，不同 Vdc 对应的性能情况如图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-11-54-42_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

继续调整 M7, 扫描结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-12-06-27_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-12-09-55_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

根据结果，将 M7 修改为 `W7/L7 = 580u/1.8u > 600u/1.6u`, 然后对 M5 进行扫描：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-12-15-32_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

修改 M5 为 `W5/L5 = 445u/1.8u > 240u/1.8u`。到这里，对 GBW 和 PM 有明显影响的晶体管都已经调整完毕，最后看一下不同 Vdc 对应的性能情况：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-12-18-53_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-12-22-40_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-12-23-38_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>


至此，频率响应层面的优化终于完成。虽然没有完全达到指标要求，但暂时是没有特别大的拓展空间了。

## 5. simul. verification 3

### 5.0 dc operation point

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-14-10-23_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-14-09-52_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

### 5.1 dc io-curve

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-14-16-43_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-14-20-03_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

### 5.2 buffer dc range

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-12-32-35_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-12-38-45_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-14-00-10_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

### 5.3 buffer tran and SR

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-13-22-33_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-13-33-44_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

### 5.4 range of CM input

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-05-13-43-14_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>



## 6. Design Conclusion



下表总结了上面各个小节的仿真结果：
<div class='center'>

| Parameter | Value |
|:-:|:-:|
 | DC Gain | 81.49 dB @ Vin = 0.9 V in unit buffer |
 | GBW | 45.71 MHz @ Vin = 0.9 V in unit buffer |
 | PM | 57.8° @ Vin = 0.9 V in unit buffer |
 | Power dissipation | 590.3 uA @ 1.8V in unit buffer |
 | Open-loop swing  | (0.442 V, 1.416 V) = 0.974 V @ 60dB <br> (0.532 V, 1.352 V) = 0.820 V @ 74dB |
 | Buffer swing | (0.159 V, 1.416 V) = 1257 mV @ 0.900 slope in unit buffer <br> (0.450 V, 1.276 V) = 826 mV @ 0.999 slope in unit buffer <br> (0.450 V, 1.303 V) 850 mV @ 1e-4 error in unit buffer | 
 | Slew rate | + 42.22 V/us, - 38.27 V/us @ (0.5 V, 1.2 V) step pulse in unit buffer |
 | CM Input range | (0.027 V, 1.166 V) = 1.139 V @ -3dB drop at Vin_DM = 0 <br> (-0.154 V, 1.342 V) = 1.496 V @ -20dB drop at Vin_DM = 0 |
</div>


下表是仿真值与指标要求的对比：

<div class='center'>

<span style='font-size:12px'> 

| Type | DC Gain | GBW | PM | Slew Rate | CM Input Range | Output Swing | Power Dissipation |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Specifications | 80 dB | 50 MHz | 60° | 50 V/us | (-0.1 V, +1.2 V) | 1 V | 600 uA @ 1.8V (1.08 mW) |
 | Simulation Results | 81.49 dB | 45.71 MHz | 57.8° | +42.22 V/us, -38.27 V/us | (-0.154 V, +1.342 V) | 0.82 V ~ 1.26 V | 590.3 uA @ 1.8V (1.06 mW) |

</span>
</div>

总的来讲，