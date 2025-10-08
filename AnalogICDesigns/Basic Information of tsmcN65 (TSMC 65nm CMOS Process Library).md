# Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library)

> [!Note|style:callout|label:Infor]
> Initially published at 22:06 on 2025-09-09 in Lincang.

## 0. PDK Installation

由于我们的虚拟机没有配置网络，只能先将打包好的工艺库文件夹传输到本地 windows, 然后再通过共享文件夹传输到虚拟机中。

将 "练手" 服务器 `182.48.105.253` 的工艺库文件夹打包好：

``` bash
# 将 tsmcN65 工艺库复制到 dy2025 目录下
cp -r /home/library/TSMC/tsmc65n/v1.0c_RF/ /home/dy2025/Cadence_Data/tsmcN65/
cp -r /home/library/TSMC/tsmc65n/user_ref  /home/dy2025/Cadence_Data/tsmcN65/

# 将工艺库打包成压缩包
tar -czvf /home/dy2025/Cadence_Data/tsmcN65.tar.gz /home/dy2025/Cadence_Data/tsmcN65
```

然后在本地 windows 下载打包好的文件：

``` bash
# 将压缩包从服务器 username@111.11.111.111 下载到本地 windows
scp dy2025@182.48.105.253:/home/dy2025/Cadence_Data/tsmcN65.tar.gz D:/a_Win_VM_shared_2_largeFiles/Cadence_Process_Library_Backup/
# 回车后会让输入密码，输入完成再回车即可开始下载
```

上一步如果报错 `Ensure the remote shell produces no output for non-interactive sessions.`, 大概是服务器主机上设置了 shell 初始化文件 `.cshrc` ，将此文件改名为 `ttt.cshrc` 即可暂时禁用，传输完成后再改回来即可。

通过共享文件夹将工艺库传输到虚拟机中，最后打开本地虚拟机，解压后导入工艺库即可。由于我们的虚拟机之前已经自带了一个的 N65 工艺库，我们先在 `cds.lab` 中将原有的工艺库重命名为 `tsmcN65_old` 以避免冲突。


然后直接复制并导入工艺库路径，具体步骤如下：

``` bash
# 创建工艺库存放目录
mkdir -p /home/IC/Cadence_Process_Library/tsmcN65/
# 解压工艺库到指定目录
tar -xzvf /home/IC/a_Win_VM_shared_2_largeFiles/Cadence_Process_Library_Backup/tsmcN65.tar.gz -C /home/IC/Cadence_Process_Library/tsmcN65/
# 移动工艺库文件夹内容到上级目录
mv /home/IC/Cadence_Process_Library/tsmcN65/home/dy2025/Cadence_Data/tsmcN65/* /home/IC/Cadence_Process_Library/tsmcN65/
# 删除多余的嵌套目录
rm -rf /home/IC/Cadence_Process_Library/tsmcN65/home

# 在 cds.lib 文件中添加工艺库路径
echo "DEFINE tsmcN65_old Tech/65NTSMC/tsmcN65" >> /home/IC/cds.lib
echo "ASSIGN tsmcN65_old DISPLAY ProcessLib" >> /home/IC/cds.lib
echo "DEFINE tsmcN65 /home/IC/Cadence_Process_Library/tsmcN65/tsmcN65" >> /home/IC/cds.lib
echo "ASSIGN tsmcN65 DISPLAY ProcessLib" >> /home/IC/cds.lib
```



在新建的库 `MyLib_tsmcN65` 的一个 schematic 生成版图时遇到报错：

``` bash
Technology 'cdsDefTechLib' does not have a constraint group named 'virtuosoDefaultExtractorSetup'. Thus the XL connectivity extractor is disabled. To enable it, add a 'validLayers' constraint to the appropriate constraint group, and ensure that this constraint group is specified by the 'setupConstraintGroup' environment variable.
```

我们尝试重新使用 cadence 内部的 `Add Process Lib` 来添加库，看看能否解决此问题。打开 `CIW = Tools = Library Path Editor = Edit = Add Library Path`，然后选择 `tsmcN65` 工艺库所在路径 `/home/IC/Cadence_Process_Library/tsmcN65/tsmcN65`，添加之后仍有报错，问题未解决。

参考这篇文章 [CSDN = Virtuoso 原理图生成版图时报错 LX-2063](https://blog.csdn.net/ZiroWang/article/details/142481204) 后发现是 library = property = techLibName 错误地设置成了 `cdsDefTechLib`，将其修改为 `tsmcN65` 后，问题解决。




## 1. PDK Docs

整个 PDK 所有的文档如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-22-24-52_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>

其中比较关键的几个文档是：
- `tsmcN65\PDK_doc\ReleaseNote.txt`: 类似 README 文件，介绍了 PDK 的版本信息、库文件列表和库中器件全称 (但其实不看也行，因为下面的 PDK usage guide 比它介绍得更详细)
- `tsmcN65\PDK_doc\TSMC_DOC_WM\PDK\CRN65_CDF_Usage.pdf`: PDK 使用手册，介绍了 PDK 所含器件、基本使用方法和注意事项
- `tsmcN65\PDK_doc\TSMC_DOC_WM\model\TN65CMSP018_1.0.pdf`: PDK model 手册，介绍了 PDK 所含器件的模型参数
- `tsmcN65\TN65CLDR001_2_0.pdf`: PDK design rule 手册，介绍了此 PDK 的设计规则

从第一个 `ReleaseNote.txt` 文件可以看出， **<span style='color:red'> 本工艺库的 core voltage = 1.0 V, 即未标有电压后缀的 MOS 均为 1.0 V 器件。 </span>**

文件夹中还给出了几个带有后仿的设计示例：

``` bash
# (1) A LNA Design Flow Example of TSMC CRN65LP PDK: 
tsmcN65\PDK_doc\RF_flow\N65_PDK_rf_flow_guide_v0d1_IC61.pdf

# (2) 1.0-V RF LNA:
tsmcN65\PDK_doc\TSMC_DOC_WM\PDK\RF_LNA_TV_Report_v1d0.pdf

# (3) 1.0-V 2.4-GHz VCO:
tsmcN65\PDK_doc\TSMC_DOC_WM\PDK\2D4GHz_VCO_Process_Vehicle_Design_Report_2007
```

另外，文档还介绍了 TIF (TSMC inductor finder) 和 TCF (TSMC capacitor finder) 两个工具的使用方法，用于高效查找工艺库中合适的电感和电容。详见相关文档，这里不多赘述。



### 1.1 CRN65_CDF_Usage.pdf

本小节分析 `CRN65_CDF_Usage.pdf` 文档中的关键内容：

工艺库所含器件：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-19-13-07_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-22-43-50_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>


图中各器件后缀含义如下：
- **dnw** = deep n-well: 
- **18** = 1.8V, **25** = 2.5V, **33** = 3.3V
- **na** = native threshold voltage (zero VT), **lvt** = low threshold voltage, **hvt** = high threshold voltage
- **x** = three-terminal device (bulk/nwell connected to VSS/VDD)
- **m** = three terminal (resistor)
- **OD** = over drive, **UD** = under drive
- **BJT_mis** = with mismatch model: 工艺角仿真时无 mis 后者也可，但 BJT 的 mc 仿真必须带 mis (某些工艺库的 BJT 没有 mis 后缀，所有 BJT 都自带 mis)


下面具体举几个例子：

``` bash
nch_25_dnwod33 :  2.5V over drive 3.3V nominal VT NMOS in DNW transistor
解释: 2.5V 是此 MOS 的 core voltage, 也就是此 nch 是在 2.5V 下设计和优化的 (以达到最佳速度/功耗/漏电流), 而 over drive 3.3V 是指此 MOSFET 经过特殊工艺处理 (例如增加栅氧厚度)，过驱动到 3.3V 仍能正常工作，至于 dnw 就是 deep n-well 

nch_25_dnwud18_macx : three-terminal 2.5V under drive 1.8V nominal VT NMOS in DNW transistor with macro model
解释：2.5V 是此 MOS 的 core voltage, 也就是此 nch 是在 2.5V 下设计和优化的 (以达到最佳速度/功耗/漏电流), 而 under drive 1.8V 是指此 MOSFET 经过特殊工艺处理 (例如减小栅氧厚度)，必须欠驱动到 1.8V 才能正常工作，至于 dnw 就是 deep n-well 


意思是该器件的核心工作电压为2.5V，但其工艺参数基于1.8V的标准阈值 (nominal VT) 设计，并且支持deep n-well结构。`macx`表示该器件为三端模型（macro model），便于仿真和版图设计。
```

下图展示了 `nch/nch_dnw/nch_dnwx/nch_mac/nch_dnw_mac/nch_dnw_macx` 等相似器件之间的 property 和 layout 差异：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-22-17-19_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>


<!-- 图中可以看出，此工艺库并不像 [tsmcN28](<AnalogICDesigns/Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).md>) 那么 "智能"。T28 MOS 管的 property 中还提供了 contact (CO) 和 dummy 的设置，为版图设计提供了很多便利。唯一与版图相关的 property 是这几条：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-22-53-30_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div> -->

此 T65 工艺库也是可以设置自动生成 gate contact 的，但不是在 schematic 中设置，而是在 layout 中设置器件的 `routePolydir` 参数，例如设置为 `both` (已在服务器上验证过)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-23-30-10_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-23-30-24_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>


但是我们在本地虚拟机上修改参数时却遇到了 pcell evaluation failed 的报错 (即便是修改 MOS 的 length 或者 width 也会报错)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-23-37-45_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-23-41-35_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>

于是参考这篇问答 [EETOP > [求助] tsCreateDiffusionL 函数调用, pcellEvalFailed](https://bbs.eetop.cn/thread-992729-1-1.html)，可能是我们的 `tsmcN65_old` 工艺库与 `tsmcN65` 产生了冲突（尽量不要一个 workspace 下，装/引入两个同类工艺库），于是在 `cds.lib` 中将 `tsmcN65_old` 工艺库的代码注释掉，重启 virtuoso 再次尝试，发现问题并没有解决。后续如何解决的，我们放到了文章 [How to Use Cadence Virtuoso Efficiently](<AnalogIC/Use Virtuoso Efficiently - 0. How to Use Cadence Virtuoso Efficiently.md>) 中。



最后给出 layout 时可能用到的其它参数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-23-29-22_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-10-23-31-18_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-11-00-57-36_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>

### 1.2 TN65CMSP018_1.0.pdf

本小节看一看 `tsmcN65\PDK_doc\TSMC_DOC_WM\model\TN65CMSP018_1.0.pdf` 中的关键内容，主要是各器件模型中一些关键参数的值和范围，例如 MOS 的长宽范围、电阻的 sheet resistance 等等：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-11-01-02-38_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>

不知为何，此文档仅给出了 RF 器件的模型参数，例如 `nmos_rf/pmos_rf/rppolys_rf` 等，而没有给出 `nch/pch/rnpoly` 等基本器件的相关参数。 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-12-21-22-51_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>

但仍然可以看到金属布线和过孔的相关参数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-12-21-39-43_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>


<!-- 那么，我们还可以在哪里找到基本器件的模型参数呢？一个方法是直接到 spectre 文件中搜索，例如文件 `tsmcN65/models/hspice/crn65gplus_2d5_lk_v1d0.l` 中搜索 `nch.5/pch.5` 可以看到：

- `nch`, `pch`:
    - L_range = (60 nm, 900.1 nm)
    - W_range = (90.000 nm, 2700.1 nm)
    - a_range = (0.1, 100)
 -->


### 1.3 docs summary



如何选择合适的器件后缀：
- (1) 同类型器件优先使用带 **mac** 的，因为 macro model 具有更高的仿真精度，与实际情形更接近
- (2) 在 bulk/nwell 全部接 VSS/VDD 的情况下，用不用 **x** 还是看个人，区别不大
- (3) **OD** 一般用于具有宽电源范围的电路，例如 2.5V ~ 3.3V 都能正常工作的锁相环 (相比直接用 3.3V 器件，这种方法的性能一般更好)
- (4) **na** 器件多用作 MOS capacitor, 某些情况下也用作 zero threshold voltage MOS.


以及建议/经常使用的几个 layout 相关参数：
- `routePolydir = both` (自动生成 gate contact)
- `route_Source_Drain = both` (自动连接 multi-finger 下的 source/drain)
- `cont columns`: 设置电阻的 contact columns, 通常 >= 3





## 2. Main Devices



从文档中总结出几种主要电阻的方块参数：
<div class='center'>

| Resistor | full name | square resistor (Ohm) |
|:-:|:-:|:-:|
 | rnod     | N+ diffusion resistor with salicide   | 15.2 |
 | rnpoly   | N+ poly resistor with salicide        | 15.4 |
 | rnpolywo | N+ poly resistor without salicide     | 124 |
 | rnwod    | NWell resistor under OD               | 316 |
 | rnwsti   | NWell resistor under STI              | 605 |
 | rpod     | P+ diffusion resistor with salicide   | 14.6 |
 | rppoly   | P+ poly resistor with salicide        | 14.8 |
 | rppolywo | P+ poly resistor without salicide     | 756 |
 | rm1      | Metal 1 resistor                      | 0.137 |
</div>

电容主要是 mim cap 和 mom cap, 一般情况下 mim cap 就完全够用了，它们的对比图如下：

<div class='center'>


| 特性 | MIM Cap (Metal-Insulator-Metal) | MOM Cap (Metal-Oxide-Metal) |
| :--- | :--- | :--- |
| **电容密度** | **较高** (1-2 fF/μm²) | **较高或较低均可** (0.5-2 fF/μm²) |
| **Q值** | **高** (低频至射频) | **非常高** (尤其在极高频) |
| **自谐振频率(SRF)** | 高 | **极高** (毫米波频段首选) |
| **适用频率范围** | DC ~ 10 GHz |  DC ~ 25 GHz (最高频率取决于具体工艺库，高性能的能做到近百 GHz) |
| **电压/温度系数** | **低** (线性度好，精度高) | 较高 (线性度较差) |
| **匹配精度** | **极高** | 高 (需精心布局) |
| **工艺成本** | **需要额外掩膜和工艺，成本高** | **无需额外成本，免费** |
| **主要应用** | 高精度模拟电路、RF IC 的 LC tank、IPD、去耦 | 毫米波电路、高速 I/O、数字去耦、匹配负载 |
</div>

下面是 mim cap 的版图示例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-13-23-18-34_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>

关于 mom cap 的版图样式和参数设置，这里多提几句 (user guide 中仅有下面第一张图提到 crtmom cap)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-17-04-11_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-17-09-43_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-17-02-28_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-17-24-40_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-17-57-08_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>

mom cap 各参数含义：
- finger width: default 100 nm (100 nm ~ 160 nm), 要想获得更高的电容密度 (单位面积电容值)，可以将此参数调整为最大值 160 nm
- finger spacing: default 100 nm (100 nm ~ 160 nm), 一般不会去调整此参数
- number of fingers: default 32 (even number between 6 and 288), 调整此参数来改变电容值，当然，电容面积也会随之改变
- bottom/top metal layer: default M3 to M5 (bottom M1 ~ M5, top M3 ~ M7), 调整此参数可以获得不同的电容密度和 Q 值，常用值为 M3 to M5 或 M1 to M7
- OD_width: default 100 nm (100 nm ~ 260 nm), 一般不调整此参数
- Create_OD2_Layer: default no, (yes/no), 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-17-17-44-40_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>

作为经验定律, number of fingers 和 bottom/top metal layer 可以这样设置：
- number of horizontal fingers = number of vertical fingers
- 统一用 M3 to M5 或者 M1 to M7 (需要节省面积时)
- 需要更高密度时，设置 finger width = 160 nm, finger spacing = 100 nm 保持不变



## 3. gm/Id Simulation


本小节对 tsmcN65 工艺库中的关键器件进行 gm/Id 仿真，给出 I_nor 图片，最后将仿真数据总结成表格，为实际设计提供参考。



<!-- 分别设置 vds = 125 mV, 225 mV 进行仿真，得到归一化电流 I_nor 结果如下 (总结成表方便查阅)： -->

### 3.1 nch_25_dnw

- `nch_25_dnw`: Lmax=9.010000e-04, Lmin=2.800000e-07, Wmax=9.010000e-04,and Wmin=4.000000e-07
    - L_range = (280 nm, 901 um)
    - W_range = (400 nm, 901 um)
    - simulation: L from 280nm to 2800nm (19 steps), a from 5 to 500 (10 steps)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-12-23-15-08_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>

### 3.2 pch_25

- `pch_25`: Lmax=9.010000e-04, Lmin=2.800000e-07, Wmax=9.010000e-04,and Wmin=4.000000e-07
    - L_range = (280 nm, 901 um)
    - W_range = (400 nm, 901 um)
    - simulation: L from 280nm to 2800nm (19 steps), a from 5 to 500 (5 steps)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-12-23-29-50_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>

### 3.3 nch_na25

- `nch_na25`: Lmin = 1.2 um, Lmax = , Wmin = , Wmax = 901.0 um

### 3.4 sizes summary

- `nch_25_dnw`: Lmax=9.010000e-04, Lmin=2.800000e-07, Wmax=9.010000e-04,and Wmin=4.000000e-07
    - L_range = (280 nm, 901 um)
    - W_range = (400 nm, 901 um)
- `pch_25`: Lmax=9.010000e-04, Lmin=2.800000e-07, Wmax=9.010000e-04,and Wmin=4.000000e-07
    - L_range = (280 nm, 901 um)
    - W_range = (400 nm, 901 um)
- `nch_dnw`: Lmax=2.000010e-05, Lmin=6.000000e-08, Wmax=9.000001e-04,and Wmin=1.200000e-07. 
    - L_range = (60 nm, 20 um)
    - W_range = (120 nm, 901 um)
- `pch`: Lmax=2.000010e-05, Lmin=6.000000e-08, Wmax=9.000001e-04,and Wmin=1.200000e-07
    - L_range = (60 nm, 20 um)
    - W_range = (120 nm, 901 um)



### 3.4 gm/Id summary

**<span style='color:red'> 将 gm/Id 仿真数据总结到表格中： </span>**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-12-23-32-36_Basic Information of tsmcN65 (TSMC 65nm CMOS Process Library).png"/></div>


## 4. Layer Definition


与之前接触 28nm 类似，我们一方面熟悉一下 T65 中各个 layer 缩写的含义，另一方面根据 `calibre.drc` 等文件，手动整理一份 DRC 规则表格，方便后续设计时查阅。



## 5. DRC Rules
