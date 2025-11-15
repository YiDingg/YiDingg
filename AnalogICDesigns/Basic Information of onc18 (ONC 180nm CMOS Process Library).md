# Basic Information of onc18 (ONC 180nm CMOS Process Library)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 22:06 on 2025-09-09 in Lincang.

## 1. PDK Docs

整个 PDK 所有的文档如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-01-37-39_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>

其中比较关键的其实也就下面三个：
- (1) ONC18 Device Catalog `onc18_device_catalog_rev40.pdf` (3560 pages): 详细介绍了此工艺库的所有器件，包括器件结构、参数和模型等
- (2) ONC18 Electrical Specification `ONC18_Electrical_Specification.pdf` (34 pages): 简要介绍了工艺库所有器件的电气特性，例如电阻密度/电容密度和管子的主要参数
- (3) ONC18 Design Rules Manual `onc18_design_rules_manual.pdf` (417 pages): 详细介绍了此工艺库的 DRC 规则并给出具体数值要求



### 1.1 ONC18 Device Catalog

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-12-19-13_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-15-38-30_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-12-52-26_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-13-01-20_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>

### 1.2 ONC18 Design Rules Manual
### 1.3 docs summary

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-14-01-33_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-13-56-59_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>

## 2. Main Devices

在文件 (1) ONC18 Device Catalog `onc18_device_catalog_rev40.pdf` (3560 pages) 中可以找到此工艺库所有器件的详细参数，包括晶体管、电阻、电容等。

### 2.1 resistors (all flow)

下图截自文件 (2) ONC18 Electrical Specification `ONC18_Electrical_Specification.pdf` (34 pages):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-16-57-37_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-16-55-54_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>


<!-- <span style='font-size:8px'> 
<div class='center'>

| Resistor | Sheet Resistance | Device Arguments | Other Parameters | Diagram and Model |  |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | (1) 7.45 rnplus | 70.3 ohm/sq <br> 64.8 ~ 75.8 <br> PC = 0.67 | Vmax = 5.5V <br> TC1 = +1.31e-03 /K <br> TC2 = +0.754e-06 /K² <br> sigma_narrow = 3.54% <br> sigma_wide = 1.21% |
 | (2) 7.46 rnpluss | 6.29 ohm/sq <br> nan ~ nan <br> PC = nan | Vmax = 15V <br> TC1 = +2.91e-03 /K <br> TC2 = +0.00938e-06 /K² <br> sigma_narrow = nan% <br> sigma_wide = nan% |
 | (3) 7.47 rnpoly | 290 ohm/sq <br> 232 ~ 348 <br> PC = nan | Vmax = 15V <br> TC1 = -1.27e-03 /K <br> TC2 = +2.34e-06 /K² <br> sigma_narrow = 5.04% <br> sigma_wide = 4.38% |
 | (4) 7.48 rnpolys | 6.55 ohm/sq <br> nan ~ nan <br> PC = nan | Vmax = 15V <br> TC1 = +2.90e-03 /K <br> TC2 = +0.250e-06 /K² <br> sigma_narrow = nan% <br> sigma_wide = nan% |
 | (5) 7.49 rnwsti | 950 ohm/sq <br> 760 ~ 1140 <br> PC =  | Vmax = 15V <br> TC1 = +3.97e-03 /K <br> TC2 = +11.5e-06 /K² <br> sigma_narrow = 5.56% <br> sigma_wide = 3.73% |
 | (6) 7.50 rpplus | 127 ohm/sq <br> 101 ~ 153 <br> PC =  | Vmax = 5.5V <br> TC1 = +1.36e-03 /K <br> TC2 = +0.567e-06 /K² <br> sigma_narrow = 3.98% <br> sigma_wide = 2.81% |
 | (7) 7.51 rppluss | 5.31 ohm/sq <br> nan ~ nan <br> PC = nan | Vmax = 5.5V <br> TC1 = +3.59e-03 /K <br> TC2 = +0.0847e-06 /K² <br> sigma_narrow = nan% <br> sigma_wide = nan% |
 | (8) 7.52 rppoly | 290 ohm/sq <br> 232 ~ 348 <br> PC =  | Vmax = 15V <br> TC1 = -0.230e-03 /K <br> TC2 = +0.855e-06 /K² <br> sigma_narrow = 4.24% <br> sigma_wide = 4.00% |
 | (9) 7.53 rppolyhr | 1037 ohm/sq <br> 778 ~ 1296 <br> PC =  | Vmax = 15V <br> TC1 = -1.10e-03 /K <br> TC2 = +2.49e-06 /K² <br> sigma_narrow = 5.51% <br> sigma_wide = 5.09% |
 | (10) 7.54 rppolyltc | 295 ohm/sq <br> 221 ~ 369 <br> PC =  | Vmax = 15V <br> TC1 = -0.139e-03 /K <br> TC2 = +0.852e-06 /K² <br> sigma_narrow = 2.98% <br> sigma_wide = 2.56% |
 | (11) 7.55 rppolys | 5.78 ohm/sq <br> nan ~ nan <br> PC = nan | Vmax = 15V <br> TC1 = +3.32e-03 /K <br> TC2 = +0.650e-06 /K² <br> sigma_narrow = nan% <br> sigma_wide = nan% |
</div>
</span> -->



下表从文件 (1) ONC18 Device Catalog `onc18_device_catalog_rev40.pdf` (3560 pages) 总结得到：



<!-- <span style='font-size:12px'> 
<div class='center'>

| Resistor | Sheet Resistance | Process Coefficient | Vmax | TC1 | TC2 | sigma_narrow | sigma_wide |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | (1)  rnplus    | 70.3 ohm/sq | 0.17 | 5.5V | +1.31e-03 /K | +0.754e-06 /K² | 3.54% | 1.21% |
 | (2)  rnpluss   | 6.29 ohm/sq | nan  | 15V  | +2.91e-03 /K | +0.009e-06 /K² | nan%  | nan%  |
 | (3)  rnpoly    | 290 ohm/sq  | 0.50 | 15V  | -1.27e-03 /K | +2.340e-06 /K² | 5.04% | 4.38% |
 | (4)  rnpolys   | 6.55 ohm/sq | nan  | 15V  | +2.90e-03 /K | +0.250e-06 /K² | nan%  | nan%  |
 | (5)  rnwsti    | 950 ohm/sq  | 0.50 | 15V  | +3.97e-03 /K | +11.50e-06 /K² | 5.56% | 3.73% |
 | (6)  rpplus    | 127 ohm/sq  | 0.51 | 5.5V | +1.36e-03 /K | +0.567e-06 /K² | 3.98% | 2.81% |
 | (7)  rppluss   | 5.31 ohm/sq | nan  | 5.5V | +3.59e-03 /K | +0.085e-06 /K² | nan%  | nan%  |
 | (8)  rppoly    | 290 ohm/sq  | 0.50 | 15V  | -0.23e-03 /K | +0.855e-06 /K² | 4.24% | 4.00% |
 | (9)  rppolyhr  | 1037 ohm/sq | 0.67 | 15V  | -1.10e-03 /K | +2.490e-06 /K² | 5.51% | 5.09% |
 | (10) rppolyltc | 295 ohm/sq  | 0.67 | 15V  | -0.14e-03 /K | +0.852e-06 /K² | 2.98% | 2.56% |
 | (11) rppolys   | 5.78 ohm/sq | nan  | 15V  | +3.32e-03 /K | +0.650e-06 /K² | nan%  | nan%  |

</div>
</span> -->


<span style='font-size:12px'> 
<div class='center'>

| Resistor | Sheet Resistance | Process Coefficient | Vmax | TC1 | TC2 | sigma_narrow | sigma_wide |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | (1)  rnplus    | 70.3 ohm/sq | 0.157 | 5.5V | +1.31e-03 /K | +0.754e-06 /K² | 3.54% | 1.21% |
 | (2)  rnpluss   | 6.29 ohm/sq | nan   | 15V  | +2.91e-03 /K | +0.009e-06 /K² | nan%  | nan%  |
 | (3)  rnpoly    | 290 ohm/sq  | 0.400 | 15V  | -1.27e-03 /K | +2.340e-06 /K² | 5.04% | 4.38% |
 | (4)  rnpolys   | 6.55 ohm/sq | nan   | 15V  | +2.90e-03 /K | +0.250e-06 /K² | nan%  | nan%  |
 | (5)  rnwsti    | 950 ohm/sq  | 0.400 | 15V  | +3.97e-03 /K | +11.50e-06 /K² | 5.56% | 3.73% |
 | (6)  rpplus    | 127 ohm/sq  | 0.409 | 5.5V | +1.36e-03 /K | +0.567e-06 /K² | 3.98% | 2.81% |
 | (7)  rppluss   | 5.31 ohm/sq | nan   | 5.5V | +3.59e-03 /K | +0.085e-06 /K² | nan%  | nan%  |
 | (8)  rppoly    | 290 ohm/sq  | 0.400 | 15V  | -0.23e-03 /K | +0.855e-06 /K² | 4.24% | 4.00% |
 | (9)  rppolyhr  | 1037 ohm/sq | 0.500 | 15V  | -1.10e-03 /K | +2.490e-06 /K² | 5.51% | 5.09% |
 | (10) rppolyltc | 295 ohm/sq  | 0.502 | 15V  | -0.14e-03 /K | +0.852e-06 /K² | 2.98% | 2.56% |
 | (11) rppolys   | 5.78 ohm/sq | nan   | 15V  | +3.32e-03 /K | +0.650e-06 /K² | nan%  | nan%  |

</div>
</span>




更详细的信息：


<span style='font-size:8px'> 
<div class='center'>

| Resistor | Full Name | Sheet Resistance | Device Arguments | Other Parameters | Diagram and Model |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | (1) 7.45 rnplus | N+ Un-Salicided in Pwell resistor | 70.3 ohm/sq <br> 64.8 ~ 75.8 <br> PC = 0.157 | w = 0.45um ~ 100um <br> l = 0.72um ~ 100um <br> np = 1 ~ inf, ns = 1/inf <br> nsrows = 1 ~ inf | Vmax = 5.5V <br> TC1 = +1.31e-03 /K <br> TC2 = +0.754e-06 /K² <br> sigma_narrow = 3.54% <br> sigma_wide = 1.21% | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-21-16-02_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div> |
 | (2) 7.46 rnpluss | N+ Salicided in Pwell resistor | 6.29 ohm/sq <br> nan ~ nan <br> PC = nan | w = 0.22um ~ 100um <br> l = 0.92um ~ 1000um <br> np = 1 ~ inf, ns = 1/inf <br> nsrows = 1 ~ inf | Vmax = 15V <br> TC1 = +2.91e-03 /K <br> TC2 = +0.00938e-06 /K² <br> sigma_narrow = nan% <br> sigma_wide = nan% | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-21-22-17_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div> |
 | (3) 7.47 rnpoly | NPOLY Un-Salicided resistor | 290 ohm/sq <br> 232 ~ 348 <br> PC = 0.400 | w = 0.45um ~ 500um <br> l = 0.72um ~ 500um <br> np = 1 ~ inf, ns = 1/inf <br> nsrows = 1 ~ inf | Vmax = 15V <br> TC1 = -1.27e-03 /K <br> TC2 = +2.34e-06 /K² <br> sigma_narrow = 5.04% <br> sigma_wide = 4.38% | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-21-26-02_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div> |
 | (4) 7.48 rnpolys | N+POLY Salicided resistor | 6.55 ohm/sq <br> nan ~ nan <br> PC = nan | w = 0.18um ~ 500um <br> l = 0.72um ~ 1000um <br> np = 1 ~ inf, ns = 1/inf <br> nsrows = 1 ~ inf | Vmax = 15V <br> TC1 = +2.90e-03 /K <br> TC2 = +0.250e-06 /K² <br> sigma_narrow = nan% <br> sigma_wide = nan% | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-21-30-52_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div> |
 | (5) 7.49 rnwsti | Nwell under STI resistor | 950 ohm/sq <br> 760 ~ 1140 <br> PC = 0.400 | w = 1.35um ~ 1000um <br> l = 1.35um ~ 1000um <br> np = 1 ~ inf, ns = 1/inf <br> nsrows = 1 ~ inf | Vmax = V <br> TC1 = +3.97e-03 /K <br> TC2 = +11.5e-06 /K² <br> sigma_narrow = 5.56% <br> sigma_wide = 3.73% | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-21-32-54_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div> |
 | (6) 7.50 rpplus | P+ Un-Salicided in Nwell resistor | 127 ohm/sq <br> 101 ~ 153 <br> PC = 0.409 | w = 0.45um ~ 100um <br> l = 0.72um ~ 1000um <br> np = 1 ~ inf, ns = 1/inf <br> nsrows = 1 ~ inf | Vmax = 5.5V <br> TC1 = +1.36e-03 /K <br> TC2 = +0.567e-06 /K² <br> sigma_narrow = 3.98% <br> sigma_wide = 2.81% | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-21-35-14_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div> |
 | (7) 7.51 rppluss | P+ Salicided in Nwell resistor | 5.31 ohm/sq <br> nan ~ nan <br> PC = nan | w = 0.22um ~ 100um <br> l = 0.92um ~ 1000um <br> np = 1 ~ inf, ns = 1/inf <br> nsrows = 1 ~ inf | Vmax = 5.5V <br> TC1 = +3.59e-03 /K <br> TC2 = +0.0847e-06 /K² <br> sigma_narrow = nan% <br> sigma_wide = nan% | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-21-37-08_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div> |
 | (8) 7.52 rppoly | PPOLY Un-Salicided resistor | 290 ohm/sq <br> 232 ~ 348 <br> PC = 0.400 | w = 0.45um ~ 500um <br> l = 0.72um ~ 500um <br> np = 1 ~ inf, ns = 1/inf <br> nsrows = 1 ~ inf | Vmax = 15V <br> TC1 = -0.230e-03 /K <br> TC2 = +0.855e-06 /K² <br> sigma_narrow = 4.24% <br> sigma_wide = 4.00% | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-21-39-57_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div> |
 | (9) 7.53 rppolyhr | (High resistance) PPOLY Un-Salicided resistor | 1037 ohm/sq <br> 778 ~ 1296 <br> PC = 0.500 | w = 0.45um ~ 500um <br> l = 2.56um ~ 500um <br> np = 1 ~ inf, ns = 1/inf <br> nsrows = 1 ~ inf | Vmax = 15V <br> TC1 = -1.10e-03 /K <br> TC2 = +2.49e-06 /K² <br> sigma_narrow = 5.51% <br> sigma_wide = 5.09% | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-21-42-55_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div> |
 | (10) 7.54 rppolyltc | (Low temperature coefficient) PPOLY Un-Salicided resistor | 295 ohm/sq <br> 221 ~ 369 <br> PC = 0.502 | w = 0.45um ~ 500um <br> l = 0.78um ~ 500um <br> np = 1 ~ inf, ns = 1/inf <br> nsrows = 1 ~ inf | Vmax = 15V <br> TC1 = -0.139e-03 /K <br> TC2 = +0.852e-06 /K² <br> sigma_narrow = 2.98% <br> sigma_wide = 2.56% | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-21-45-17_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div> |
 | (11) 7.55 rppolys | P+POLY Salicided resistor | 5.78 ohm/sq <br> nan ~ nan <br> PC = nan | w = 0.18um ~ 500um <br> l = 0.72um ~ 1000um <br> np = 1 ~ inf, ns = 1/inf <br> nsrows = 1 ~ inf | Vmax = 15V <br> TC1 = +3.32e-03 /K <br> TC2 = +0.650e-06 /K² <br> sigma_narrow = nan% <br> sigma_wide = nan% | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-16-21-47-45_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div> |

</div>
</span>





### 2.2 capacitors (all flow)

下图截自文件 (2) ONC18 Electrical Specification `ONC18_Electrical_Specification.pdf` (34 pages):
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-16-59-21_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>

下表总结自文件 (1) ONC18 Device Catalog `onc18_device_catalog_rev40.pdf` (3560 pages):

<span style='font-size:8px'> 
<div class='center'>

| Capacitor | Full Name | Capacitor Density | Device Arguments  | Other Parameters | Diagram and Model |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | (1) 7.1 CLINPNW1P8V | Linear Poly-Nwell over thin gate oxide capacitor | bias-dependent <br> 8.4 fF/μm² <br> 5.93 ~ 9.88 <br> PC = 0.67 | w = 2um ~ 100um<br> l = 1um ~ 100um<br> nf = 1 ~ 16 | Vmax = 2V<br>fringing cap = 0.042 fF/μm² <br> TC1 ≈ +200e-6 /°C | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-13-18-15_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>  <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-17-17-16_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div> |
 | (2) 7.2 CMFINGER | Metal finger capacitor | 0.484 fF/μm² <br> 0.332 ~ 0.689 <br> PC = 1.08 | w = 5.06um ~ 200.1um <br> l = 5.04um ~ 200.48um  | Vmax = 20V<br>fringing cap = NA <br> \|TC1\| < 5e-6 /°C, \|TC2\| < 3e-6 /°C² | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-13-26-51_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div> |
 | (3) 7.3 CMFINGER_HC | Metal finger capacitor (high-cap) | 0.6905 fF/μm² <br> 0.475 ~ 0.967 <br> PC = 1.04 | w = 5.06um ~ 200.1um <br> l = 5.04um ~ 200.48um | Vmax = 20V <br> fringing cap = 0.2380 fF/μm² <br> edge cap = 9.764 aF <br> \|TC1\| < 5e-6 /°C, \|TC2\| < 3e-6 /°C² <br> VC1 = VC2 = 0 | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-13-35-31_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div> |
 | (4) 7.4 CMIM | Standard Metal-Insulator-Metaltop Capacitor | 0.9588 fF/μm² <br> 0.89 ~ 1.19 <br> PC = 0.34 | w = 2.2um ~ 33.9um <br> l = 2.2um ~ 33.9um | Vmax = 15V <br> fringing cap = 0.0674 fF/μm² <br> edge cap = nan  <br> TC1 = +36.0e-06 /°C, TC2 = +65.0e-09 /°C² <br> VC1 = -1.0e-06 /V, VC2 = +2.5e-06 /V² | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-13-46-45_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>  <div class="center"><img width=100px height=80px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-13-44-41_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div></div> |
 | (5) 7.5 CMIMHC | Metal-Insulator-Metaltop Capacitor (high-cap) | 2.04 fF/μm² <br> 1.58 ~ 2.32 <br> PC = 0.47 | w = 2.2um ~ 33.9um <br> l = 2.2um ~ 33.9um | Vmax = 7.5V <br> fringing cap = 0.0965 fF/μm² <br> edge cap = 4.90aF <br> TC1 = +38.8e-06 /°C, TC2 = +38.3e-09 /°C² <br> VC1 = -18.4e-06 /V, VC2 = +19.8e-06 /V² | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-13-51-49_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>  <div class="center"><img width=100px height=80px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-15-58-05_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div> |
 | (6) 7.6 CMIMHK | Metal-Insulator-Metaltop Capacitor with high-K dielectric | 6.02 fF/μm² <br> nan ~ nan <br> PC = nan | w = 2.2um ~ 33.9um <br> l = 2.2um ~ 33.9um | Vmax = 4.5V <br> fringing cap = 0.013 fF/μm² <br> edge cap = nan <br> TC1 = +130e-06 /°C, TC2 = 0 /°C² <br> VC1 = -1000e-06 /V, VC2 = +800e-06 /V² | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-15-51-31_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>  <div class="center"><img width=100px height=80px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-15-59-20_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div> |
 | (7) 7.7 CPNW1P8V | Poly-Nwell over thin oxide capacitor | bias-dependent <br> 8.71 fF/μm² <br> 8.5 ~ 9.5 <br> PC = 0.12 | w = 2um ~ 100um <br> l = 1um ~ 100um | Vmax = 2V <br> fringing cap = 0.005 fF/μm² <br> edge cap = nan F <br> TC1 ≈ -120e-06 /°C, TC2 = nan /°C² <br> VC1 = nan /V, VC2 = nan /V² | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-16-09-35_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>   <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-16-12-11_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>|
 | (8) 7.8 CSMIM | Stacked MIM Capacitor | 3.92 fF/μm² <br> 3.32 ~ 4.52 <br> PC = 0.36 | w = 2.2um ~ 33.9um <br> l = 2.2um ~ 33.9um | Vmax = 7.5V <br> fringing cap = 0.0427 fF/μm² <br> edge cap = 0 F <br> TC1 ≈ -45.3e-06 /°C, TC2 = 32.1e-09 /°C² <br> VC1 = 0 /V, VC2 = 17.0e-06 /V² | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-16-18-16_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>  <div class="center"><img width=100px height=80px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-16-18-42_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div> |
 | (9) 7.9 CSMIMHK | Stacked MIM Capacitor with high-K dielectric | 12.04 fF/μm² <br> nan ~ nan <br> PC = nan | w = 2.2um ~ 33.9um <br> l = 2.2um ~ 33.9um | Vmax = 4.5V <br> fringing cap = 0.026 fF/μm² <br> edge cap = nan <br> TC1 = +45.3e-06 /°C, TC2 = 32.1e-09 /°C² <br> VC1 = -1000e-06 /V, VC2 = +800e-06 /V² | <div class="center"><img width=200px height=60px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-16-37-08_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div> |
</div>
</span>

上表中 PC (Process Coefficient) 工艺角系数是由 $\mathrm{PC} = \frac{\max - \min}{\mathrm{typ}}$ 计算得到。

全部器件汇总如下，截图自文件 (2) ONC18 Electrical Specification `ONC18_Electrical_Specification.pdf` (34 pages):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-16-40-53_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-16-42-16_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-16-45-10_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>



### 2.3 mosfets (1.8V)

下表从文件 (1) ONC18 Device Catalog `onc18_device_catalog_rev40.pdf` (3560 pages) 总结得到：

**注：除 native 管子默认测试尺寸为 10u/10u, 其它管子默认测试尺寸都是 W/L = 10u/0.18u**

<span style='font-size:12px'> 
<div class='center'>

| MOSFET | Full Name | Size (W/L) | Vmax (Vds, Vgs) | Vth @ 0.1Vds | ID @ 1.8Vgs, 1.8V ds | Lambda @ 1.8Vgs, 1.0Vds, 0Vbs | Leakage @ 0Vgs, 1.8Vds |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | (N1)  7.20 nmos1p8v | 1.8V nominal VT NMOS        | 0.22\~100 / 0.18\~100 | 2 V | 0.476 V (0.410 ~ 0.542) | 6.00 mA (5.01 ~ 6.99) | 0.169 /V | 78.0 pA |
 | (N2)  7.23 nmoshvt1p8v | 1.8V high VT NMOS        | 0.22\~100 / 0.18\~100 | 2 V | 0.649 V (0.597 ~ 0.701) | 4.42 mA (3.54 ~ 5.30) | 0.110 /V | 0.93 pA |
 | (N3)  7.24 nmosuhvt1p8v | 1.8V Ultra High VTH NMOS| 0.22\~100 / 0.18\~100 | 2 V | 0.809 V (0.703 ~ 0.916) | 2.59 mA (2.10 ~ 3.09) | 0.051 /V | 0.25 pA |
 | (N4)  8.16 nmosnvt1p8v |1.8V Native threshold NMOS| **0.42**\~100 / **1.00**\~100 | 2V | -0.093 (-0.126 ~ -0.060) | 0.55 mA (0.52 ~ 0.57) | 0.069 /V | 77 uA |
 | (P1)  7.31 pmos1p8v | 1.8V nominal VT PMOS        | 0.22\~100 / 0.18\~100 | 2 V | 0.505 V (0.415 ~ 0.595) | 2.60 mA (1.89 ~ 3.31) | 0.460 /V | 209 pA |
 | (P2)  7.34 pmoshvt1p8v | 1.8V high VT PMOS        | 0.22\~100 / 0.18\~100 | 2 V | 0.650 V (0.573 ~ 0.727) | 2.07 mA (1.37 ~ 2.77) | 0.150 /V | 9.85 pA |
 | (P3)  7.35 pmosuhvt1p8v | 1.8V Ultra High VTH PMOS| 0.22\~100 / 0.18\~100 | 2 V | 0.822 V (0.697 ~ 0.946) | 1.28 mA (0.78 ~ 1.79) | 0.100 /V | 0.82 pA |


</div>
</span>

除上述器件外，工艺库还提供了 IOD 和 IODS 器件(表中未列出)，它们与普通器件的区别在于多了 drain/source 上的 I/O 保护，是用于 I/O 接口的专用器件：
- **要速度，在芯片内部用** -> **`nmos1p8v`**
- **做输出驱动，要平衡性能和耐压/ESD** -> **`NMOS1P8V_IOD`**
- **做输入保护或双向端口，要最高的可靠性** -> **`NMOS1P8V_IODS`**



下图取自文件 (2) ONC18 Electrical Specification `ONC18_Electrical_Specification.pdf` (34 pages)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-20-32-49_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-20-43-10_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-20-39-37_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-20-39-57_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>




### 2.4 mosfets (5.0V)

下表从文件 (1) ONC18 Device Catalog `onc18_device_catalog_rev40.pdf` (3560 pages) 总结得到：


**注，除 nominal VTH 管默认测试尺寸为 10u/0.6u, 其它各管默认测试尺寸都为 10u/1.2u**

<!-- - nominal VTH: 
- (lvt) low VTH: 
- (nvt) native VTH: 10u/1.2u
- (xvt) intermediate VTH: 10u/1.2u -->

<span style='font-size:12px'> 
<div class='center'>

| MOSFET | Full Name | Size (W/L) | Vmax (Vds, Vgs) | Vth @ 0.1Vds | ID @ 5Vgs, 5Vds | Lambda @ 1.5Vgs, 3Vds, 0Vbs | Leakage @ 0Vgs, 5Vds |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | (N1)  9.36 nmos5v    | 5V nominal VTH NMOS | 0.6\~100 / 0.6\~100 | 5.5 V | 0.83 V (0.66 ~ 1.00) | 5.45 mA (4.69 ~ 6.21) | 0.0403 /V | 0.473 pA |
 | (N2)  9.39 nmoslvt5v | 5V LOW VTH NMOS     | 0.6\~100 / 1.2\~100 | 5.5 V | 0.43 V (0.34 ~ 0.52) | 3.82 mA (3.06 ~ 4.58) | 0.0058 /V | 27.0  pA |
 | (N3)  9.42 nmosnvt5v | 5V native VT NMOS   | 0.6\~100 / 1.7\~100 | 5.5 V | -0.13 V (-0.16 ~ -0.10) | - | 0.0177 /V @ 5Vgs, 4Vds, 0Vgs | 0.117 mA <br> < 1pA @ -2Vgs, 5Vds |
 | (N4)  9.43 nmosxvt5v | 5V intermediate voltage threshold NMOS | 0.6\~100 / 1.0\~100 | 5.5 V | 0.567 V (0.457 ~ 0.677) | 4.61 mA (3.68 ~ 5.53) | 0.0113 /V | 3.4 pA |
 | (P1)  9.56 pmos5v    | 5V nominal VTH PMOS | 0.6\~100 / 0.6\~100 | 5.5 V | 0.81 V (0.65 ~ 0.98) | 2.95 mA (2.41 ~ 3.49) | 0.0598 /V | 1.05 pA |
 | (P2)  9.59 pmoslvt5v | 5V LOW VTH PMOS     | 0.6\~100 / 1.2\~100 | 5.5 V | 0.42 V (0.31 ~ 0.53) | 1.28 mA (1.02 ~ 1.53) | 0.0095 /V | 3.73 pA |
 | (P3)  9.60 pmosxvt5v | 5V intermediate voltage threshold PMOS | 0.6\~100 / 1.0\~100 | 5.5V | 0.62 V (0.49 ~ 0.74) | 1.71 mA (1.36 ~ 2.05) | 0.0161 /V | 0.55 pA |

</div>
</span>




``` bash
 | ()  9.  |  | \~100 / \~100 |  V |  V ( ~ ) |  mA ( ~ ) |  /V |  pA |

nmos5v
nmos5v_iod
nmos5v_lods
nmoslvt1p8v_5v
nmoslvt5v
nmosnvt1p8v_5v
nmosnvt5v
nmosxvt5v

pmos5v
pmos5v_iod
pmos5v_iods
pmoslvt5v
pmosxvt5v
```



### 2.4 else


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-16-59-53_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-17-03-16_Basic Information of ocn18 (OCN 180nm CMOS Process Library).png"/></div>

<!-- ## 3. gm/Id Simulation

### 3.4 sizes summary
### 3.4 gm/Id summary 

## 3. Layer Definition
## 5. DRC Rules
-->


## 3. Layout Example

与之前的做法类似，我们通过一个简单的反相器后仿来熟悉新工艺库得到版图风格和设计规则。之前 tsmcN28 的版图示例在 [Cadence Virtuoso 教程 (八)：台积电 28nm 版图设计示例——包括 Layout, DRC, LVS, PEX 和后仿 (Post-Simulation)](https://zhuanlan.zhihu.com/p/1937319302949769830)。

### 3.1 layer definitions

`onc18` 工艺库的 layer definitions 与我们常用的 tsmc 不同，名字缩写和颜色都大相径庭，这里放一张图片供参考：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-22-17-01_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>



### 3.2 DRC/LVS/PEX


未连线时的版图和 DRC 结果：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-23-22-38-43_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>

完成连线后的 DRC/LVS 结果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-11-12-51_onc18 LVS Error (missing instance).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-11-12-14_onc18 LVS Error (missing instance).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-11-20-21_onc18 LVS Error (missing instance).png"/></div>

**<span style='color:red'> 注意这里版图端口定义是用 m1port drw 来做，而不是像往常 `tsmc` 那样用 m1 pin. </span>**

这里 LVS 报错 `missing instance`，并不是指晶体管出现错误，而是寄生器件 `DNWCON` 和 `DNWPSUB` 在原理图中找不到对应元件。在文件 (1) ONC18 Device Catalog `onc18_device_catalog_rev40.pdf` (3560 pages) 中可以找到这两个器件：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-11-55-57_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-15-11-01_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>

将这两个器件添加到原理图后，先进行一次 LVS, 根据 LVS 提取结果修改 `DNWPSUB` 的具体参数 (与版图提取结果一致)，然后便可全部通过：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-15-14-53_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-15-15-19_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>



### 3.3 layout example 2

为了更充分地了解工艺库，还是用这个 inverter 再做一次版图。但这次，我们使用 guard ring 定义管子 bulk 电位，而不是手动拉一个 n-tap/p-tap 来接 VDD/VSS。



版图效果如下 (guard ring enclose by 0.5)：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-21-49-09_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>


DRC/LVS 均完整通过：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-21-51-43_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-25-21-50-09_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>



### 3.4 post-layout simulation

### 3.5 layout summary

此工艺库版图的几个注意事项：
- (1) 版图上每一个单独 NW 都需要在原理图上手动放置 `DNWCON` 器件
- (2) 版图上每一个单独 PSUB 都需要在原理图上手动放置 `DNWPSUB` 器件 (包括 global psub)
- (3) 版图端口定义是用 m1port drw 来做，而不是像往常 `tsmc` 那样用 m1 pin
- (4) NMOS guard ring 使用 `m1_p` (m1/aa/pimp, 也即以往的 M1/OD/PP)，这里的 m1_p 其实是指 m1 ptap (接在 psub 上)； PMOS guard ring 则使用 `m1_n` (m1/aa/nimp, 也即以往的 M1/OD/NP)，这里的 m1_n 是指 m1 ntap (接在 nwell 上)。

DRC tips:
- (1) NMOS 的 bulk 未正确连接时，DRC 会报错 `paa_to_naa_un_max_space_in_pw: Maximum paa outside nw (pw tap) spacing to any point inside naa outside nw (for the same pw region) is '32'`，这是正常现象；类似地, PMOS bulk 未正确连接时，会报错 `naa_to_paa_un_max_space_in_nw`


## 4. PDK Setup

此工艺库有一些需要配置的地方，在第一次打开 (还未配置) 工艺库时会自动弹出下面这个窗口：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-13-17-37-17_Basic Information of onc18 (ONC 180nm CMOS Process Library).png"/></div>

如果之前不小心关闭了，只需将文件夹 `....../Work/AA_Workspace_onc18/proc_opt` 删除，然后重新打开 virtuoso 即可。

当然，具体该如何设置，还是看甲方的要求，如果是自己的项目，自然可以根据实际情况进行调整。

## 5. Digital Std Library

onc18 的标准数字工艺库有以下几种：
- (1) `onnn180cxosci`: 5.0V digital standard cell library (using **nom 5.0V mosfets**)
- (2) `onnn180cxoscu`: 1.8V digital standard cell library (using **uhvt 1.8V mosfets**)
- (3) ……

这些数字库的模块命名方式是类似的，下面列举一些常用类别和模块 (u stands for 1.8V, i stands for 5.0V):
- Buffers: buffers of different sizes
- Clock Drivers: logic gates optimized for clock operation
- Flipflops: a series of DFFs (D-flipflops) and DLs (D-latches)
- Inverters: inverters of different sizes
- Muxs: 2-to-1 or 4-to-1 (digital) multiplexers of different sizes
- Simple: basic logic gates, including AND, NAND, OR, NOR, XOR and XNOR



<div class='center'>

| Category | Cell | Description | Structure | Unit Arguments |
|:-:|:-:|:-:|:-:|:-:|
| Buffer | bufx0_u | buffer with size x0 | INV + INV    | KA = 1,   INV = 0.42/0.18 |
| Buffer | bufx1_u | buffer with size x1 | INV + 2\*INV | KA = 1.5, INV = 0.565/0.18 |
| Buffer | bufx2_u | buffer with size x2 | INV + 2\*INV | KA = 1.5, INV = 1.13/0.18 |
| Buffer | bufx3_u | buffer with size x3 | 2\*INV + 3\*INV | KA = 1.5, INV = 1.13/0.18 |
| Buffer | bufx4_u | buffer with size x4 | 2\*INV + 4\*INV | KA = 1.5, INV = 1.13/0.18 |
| Buffer | bufx6_u | buffer with size x6 | 2\*INV + 6\*INV | KA = 1.5, INV = 1.13/0.18 |
| Buffer | esdbufx1_u | x1 size buffer with (mos) ESD protection | INV1 + INV2 | = bufx1_u |
| Buffer | esddbufx1_u | x1 size buffer with (diode) ESD protection | INV1 + INV2 | = bufx1_u |
</div>


<div class='center'>

| Category | Cell | Description | Input Pins | Output Pins |
|:-:|:-:|:-:|:-:|:-:|
| Clock Drivers | clkmux2x1_u | 2-to-1 clock multiplexer (size x1) | D0, D1, SL0 | Q |
| Clock Drivers | clkmuxi2x1_u | 2-to-1 clock multiplexer with inverting output (size x1) | D0, D1, SL0 | QN |
</div>


<div class='center'>

- `n` or `p`: negative/positive edge triggered
- `q` or `not specified`: without/with negative Q (`QN`) output (`q` means only a single output `Q`, without `QN`)
- `r` or `not specified`: with/without (active-low) reset (`RN`) input 
- `s` or `not specified`: with/without (active-low) set (`SET`) input
- `h` or `m` or `not specified`:
    - `h`: with (active-high) clock enable (`E`) input
    - `m`: with two data inputs (`D0` and `D1`) and selection input (`SL0`) 
    - `not specified`: without clock enable or multiplexer function
</div>


<div class='center'>

| Category | Cell | Description | Input Pins | Output Pins |
|:-:|:-:|:-:|:-:|:-:|
| Flipflops | dffn    | negative-triggered DFF                                  | D, CLK        | Q, QN |
| Flipflops | dffnq   | negative-triggered DFF without QN                       | D, CLK        | Q     |
| Flipflops | dffnr   | negative-triggered DFF with reset                       | D, CLK, RST   | Q, QN |
| Flipflops | dffnrq  | negative-triggered DFF with reset without QN            | D, CLK, RST   | Q     |
| Flipflops | dffp    | positive-triggered DFF                                  | D, CLK        | Q, QN |
| Flipflops | dffpq   | positive-triggered DFF without QN                       | D, CLK        | Q     |
| Flipflops | dffpr   | positive-triggered DFF with reset                       | D, CLK, RST   | Q, QN |
| Flipflops | dffprq  | positive-triggered DFF with reset without QN            | D, CLK, RST   | Q     |
| Flipflops | dffps   | positive-triggered DFF with set                         | D, CLK, SN    | Q, QN |
| Flipflops | dffpsq  | positive-triggered DFF with set without QN              | D, CLK, SN    | Q     |
| Flipflops | dffph   | positive-triggered DFF with clock enable                | D, CLK, EN    | Q, QN |
| Flipflops | dffphq  | positive-triggered DFF with clock enable without QN             | D, CLK, EN        | Q     |
| Flipflops | dffphr  | positive-triggered DFF with clock enable and reset              | D, CLK, EN, RST   | Q, QN |
| Flipflops | dffphrq | positive-triggered DFF with clock enable and reset without QN   | D, CLK, EN, RST   | Q     |
| Flipflops | dffpmr  | positive-triggered DFF with preset and reset                    | D, CLK, PRE, RST  | Q, QN |
| Flipflops | dffpmrq | positive-triggered DFF with preset and reset without QN         | D, CLK, PRE, RST  | Q     |
</div>


dff_pr

``` bash
AND
QA QB Y
0 0 0
0 1 0
1 0 0
1 1 1


NAND
QAN QBN Y
1 1 0
1 0 1
0 1 1
0 0 1

NOR
QAN QBN Y
1 1 0
1 0 0
0 1 0
0 0 1
```
