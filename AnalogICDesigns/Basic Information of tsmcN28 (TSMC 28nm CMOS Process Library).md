# Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library) (台积电 tsmcN28 工艺库基本信息)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 00:01 on 2025-06-25 in Beijing.



## 1. PDK Docs

整个 PDK 所有的文档如下：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-00-08-51_Basic Information of TSMC Process Libraries.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-00-09-16_Basic Information of TSMC Process Libraries.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-00-05-39_Basic Information of TSMC Process Libraries.png"/></div>

其中比较关键的几个文档是：
- `PDK_doc/TSMC_DOC_WM/ReleaseNote.txt`: README 文件，介绍了 PDK 的安装流程和器件基本情况 (但其实不看也行，因为下面的 PDK_usage 比它介绍得更详细)
- `PDK_doc/TSMC_DOC_WM/PDK/TSMCN28_PDK_Usage_20190322.pdf`: PDK 使用手册，介绍了 PDK 的基本使用方法和注意事项


## 2. PDK Usage Guide

打开 `PDK_doc/TSMC_DOC_WM/PDK/TSMCN28_PDK_Usage_20190322.pdf` 文件，其目录如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-00-33-34_Basic Information of TSMC 28nm Process Library.png"/></div>


## 3. Devices Information



在 `PDK_doc/TSMC_DOC_WM/readme.txt` 中找到工艺库目录结构信息，以及库中所含器件的基本描述：

``` bash
# 工艺库目录结构信息 (PDK_doc/TSMC_DOC_WM/readme.txt)

3. PDK Install Directory Structure

    Techfile/            : Includes all temporary files which are used for install program
    Calibre/             : Calibre DRC/LVS/XRC command files
    CCI/                 : Calibre Star-RCXT CCI flow technology files directory
    PDK_doc/             : Includes all documents, please check ReleaseNote 
                           before using this PDK.
    REVISION             : Revision history
    cds.lib              : cds library mapping file
    lib.defs             : library mapping file OA version
    display.drf          : Virtuoso display file
    readme               : readme file
    ReleaseNote.txt      : PDK detail information
    pdkInstall.pl        : PDK installation utility
    pdkInstall.cfg       : PDK installation configuration
    skill/               : skill directory includes all callback and utility
    models/              : hspice/spectre models
    techfile             : Virtuoso tech file
    Tcl/                 : Tcl directory include all callback and utility used by iPDK
    PycellStudio_46.tar.gz          : PycellStudio 4.6 library compress file
    PycellStudio_2016.06-1.tar.gz   : PycellStudio 2016.06-1 library compress file
    tsmcN28/             : PDK library
    PycellStudio/                   : PycellStudio library and shell script to run PycellStudio
    PDK.config                      : config file for Techfile PlugIn Utility
    Calibre_DRC.config              : config file of Techfile PlugIn Utility for Calibre DRC deck 
    Calibre_LVS.config              : config file of Techfile PlugIn Utility for Calibre LVS deck 
    Calibre_XRC.config              : config file of Techfile PlugIn Utility for Calibre XRC deck 
    StarRCXT_XRC.config             : config file of Techfile PlugIn Utility for Star RCX deck
    Calibre_QCI_LVS.config              : config file of Techfile PlugIn Utility for QCI LVS deck
    QRC.config                          : config file of Techfile PlugIn Utility for QRC RCX deck
    PlugIn_bin                      : The corresponding source files of Techfile PlugIn Utility directory
    tsmcDeckPlugIn_Utility.pl       : Techfile PlugIn Utility installation execution file
    Recommended_tool_version_number.txt : Recommended tool versions for PDK

```

``` bash
# 工艺库所含器件
4. Supported Devices

    - Mosfets macro device

nch_18_dnw_mac           : 1.8V nominal VT NMOS in DNW transistor
nch_18_dnw_macx          : 1.8V nominal VT NMOS in DNW transistor
nch_18_mac               : 1.8V nominal VT NMOS transistor
nch_18_macx              : 1.8V nominal VT NMOS transistor
nch_18ud12_dnw_mac       : 1.8V under-drive 1.2V NMOS in DNW transistor
nch_18ud12_dnw_macx      : 1.8V under-drive 1.2V NMOS in DNW transistor
nch_18ud12_mac           : 1.8V under drive 1.2V nominal VT NMOS transistor
nch_18ud12_macx          : 1.8V under drive 1.2V nominal VT NMOS transistor
nch_18ud15_dnw_mac       : 1.8V under-drive 1.5V NMOS in DNW transistor
nch_18ud15_dnw_macx      : 1.8V under-drive 1.5V NMOS in DNW transistor
nch_18ud15_mac           : 1.8V under drive 1.5V nominal VT NMOS transistor
nch_18ud15_macx          : 1.8V under drive 1.5V nominal VT NMOS transistor
nch_25_dnw_mac           : 2.5V nominal VT NMOS in DNW transistor
nch_25_dnw_macx          : 2.5V nominal VT NMOS in DNW transistor
nch_25_mac               : 2.5V nominal VT NMOS transistor
nch_25_macx              : 2.5V nominal VT NMOS transistor
nch_25od33_dnw_mac       : 2.5V over drive 3.3V nominal VT NMOS in DNW transistor
nch_25od33_dnw_macx      : 2.5V over drive 3.3V nominal VT NMOS in DNW transistor
nch_25od33_mac           : 2.5V over drive 3.3V nominal VT NMOS transistor
nch_25od33_macx          : 2.5V over drive 3.3V nominal VT NMOS transistor
nch_25ud18_dnw_mac       : 2.5V under drive 1.8V nominal VT NMOS in DNW transistor
nch_25ud18_dnw_macx      : 2.5V under drive 1.8V nominal VT NMOS in DNW transistor
nch_25ud18_mac           : 2.5V under drive 1.8V nominal VT NMOS transistor
nch_25ud18_macx          : 2.5V under drive 1.8V nominal VT NMOS transistor
nch_avt_dnw_mac          : core volt AVT NMOS in DNW transistor
nch_avt_dnw_macx         : core volt AVT NMOS in DNW transistor
nch_avt_mac              : core volt AVT NMOS transistor
nch_avt_macx             : core volt AVT NMOS transistor
nch_dnw_mac              : core volt standard VT NMOS in DNW transistor
nch_dnw_macx             : core volt standard VT NMOS in DNW transistor
nch_ehvt_dnw_mac         : core volt Extreme_High VT NMOS in DNW transistor
nch_ehvt_dnw_macx        : core volt Extreme_High VT NMOS in DNW transistor
nch_ehvt_mac             : core volt Extreme High VT NMOS transistor
nch_ehvt_macx            : core volt Extreme High VT NMOS transistor
nch_hia18_dnw_mac        : 1.8V standard VT HIA NMOS DNW transistor
nch_hia18_dnw_macx       : 1.8V standard VT HIA NMOS DNW transistor
nch_hia18_mac            : 1.8V standard VT HIA NMOS transistor
nch_hia18_macx           : 1.8V standard VT HIA NMOS transistor
nch_hia25_dnw_mac        : 2.5V standard VT HIA NMOS DNW transistor
nch_hia25_dnw_macx       : 2.5V standard VT HIA NMOS DNW transistor
nch_hia25_mac            : 2.5 standard VT HIA NMOS transistor
nch_hia25_macx           : 2.5 standard VT HIA NMOS transistor
nch_hia_dnw_mac          : core volt standard VT HIA NMOS DNW transistor
nch_hia_dnw_macx         : core volt standard VT HIA NMOS DNW transistor
nch_hia_mac              : core volt standard VT HIA NMOS transistor
nch_hia_macx             : core volt standard VT HIA NMOS transistor
nch_hv18_mac             : 1.8V high voltage NMOS transistor
nch_hv18_macx            : 1.8V high voltage NMOS transistor
nch_hvt_dnw_mac          : core volt HIGH VT NMOS in DNW transistor
nch_hvt_dnw_macx         : core volt HIGH VT NMOS in DNW transistor
nch_hvt_mac              : core volt HIGH VT NMOS transistor
nch_hvt_macx             : core volt HIGH VT NMOS transistor
nch_lvt_dnw_mac          : core volt LOW VT NMOS in DNW transistor
nch_lvt_dnw_macx         : core volt LOW VT NMOS in DNW transistor
nch_lvt_mac              : core volt LOW VT NMOS transistor
nch_lvt_macx             : core volt LOW VT NMOS transistor
nch_mac                  : core volt standard VT NMOS transistor
nch_macx                 : core volt standard VT NMOS transistor
nch_na18_mac             : 1.8V NATIVE NMOS transistor
nch_na18_macx            : 1.8V NATIVE NMOS transistor
nch_na25_mac             : 2.5V NATIVE NMOS transistor
nch_na25_macx            : 2.5V NATIVE NMOS transistor
nch_na_mac               : core volt NATIVE NMOS transistor
nch_na_macx              : core volt NATIVE NMOS transistor
nch_uhvt_dnw_mac         : core volt Ultra_High VT NMOS in DNW transistor
nch_uhvt_dnw_macx        : core volt Ultra_High VT NMOS in DNW transistor
nch_uhvt_mac             : core volt Ultra High VT NMOS transistor
nch_uhvt_macx            : core volt Ultra High VT NMOS transistor
nch_ulvt_dnw_mac         : core volt Ultra_LOW VT NMOS in DNW transistor
nch_ulvt_dnw_macx        : core volt Ultra_LOW VT NMOS in DNW transistor
nch_ulvt_mac             : core volt Ultra LOW VT NMOS transistor
nch_ulvt_macx            : core volt Ultra LOW VT NMOS transistor
pch_18_mac               : 1.8V nominal VT PMOS transistor
pch_18_macx              : 1.8V nominal VT PMOS transistor
pch_18ud12_mac           : 1.8V under drive 1.2V nominal VT PMOS transistor
pch_18ud12_macx          : 1.8V under drive 1.2V nominal VT PMOS transistor
pch_18ud15_mac           : 1.8V under drive 1.5V nominal VT PMOS transistor
pch_18ud15_macx          : 1.8V under drive 1.5V nominal VT PMOS transistor
pch_25_mac               : 2.5V nominal VT PMOS transistor
pch_25_macx              : 2.5V nominal VT PMOS transistor
pch_25od33_mac           : 2.5V over drive 3.3V nominal VT PMOS transistor
pch_25od33_macx          : 2.5V over drive 3.3V nominal VT PMOS transistor
pch_25ud18_mac           : 2.5V under drive 1.8V nominal VT PMOS transistor
pch_25ud18_macx          : 2.5V under drive 1.8V nominal VT PMOS transistor
pch_ehvt_mac             : core volt Extreme High VT PMOS transistor
pch_ehvt_macx            : core volt Extreme High VT PMOS transistor
pch_hv18_mac             : 1.8V high voltage PMOS transistor
pch_hv18_macx            : 1.8V high voltage PMOS transistor
pch_hvt_mac              : core volt HIGH VT PMOS transistor
pch_hvt_macx             : core volt HIGH VT PMOS transistor
pch_lvt_mac              : core volt LOW VT PMOS transistor
pch_lvt_macx             : core volt LOW VT PMOS transistor
pch_mac                  : core volt standard VT PMOS transistor
pch_macx                 : core volt standard VT PMOS transistor
pch_uhvt_mac             : core volt Ultra High VT PMOS transistor
pch_uhvt_macx            : core volt Ultra High VT PMOS transistor
pch_ulvt_mac             : core volt Ultra LOW VT PMOS transistor
pch_ulvt_macx            : core volt Ultra LOW VT PMOS transistor


    - RF_Mosfets

nmos_rf_18_5t                : 1.8v IO NMOS 5T w/i DNW
nmos_rf_18_6t                : 1.8v IO NMOS 6T w/i DNW
nmos_rf_18_nw                : 1.8v IO NMOS 4T w/o DNW
nmos_rf_18ud15_5t            : 1.8vUD 1.5v IO NMOS 5T w/i DNW
nmos_rf_18ud15_6t            : 1.8vUD 1.5v IO NMOS 6T w/i DNW
nmos_rf_18ud15_nw            : 1.8vUD 1.5v IO NMOS 4T w/o DNW
nmos_rf_25_5t                : 2.5v IO NMOS 5T w/i DNW
nmos_rf_25_6t                : 2.5v IO NMOS 6T w/i DNW
nmos_rf_25_nw                : 2.5v IO NMOS 4T w/o DNW
nmos_rf_25od33_5t            : 2.5vOD 3.3v IO NMOS 5T w/i DNW
nmos_rf_25od33_6t            : 2.5vOD 3.3v IO NMOS 6T w/i DNW
nmos_rf_25od33_nw            : 2.5vOD 3.3v IO NMOS 4T w/o DNW
nmos_rf_5t                   : SVT NMOS 5T w/i DNW
nmos_rf_5t_110g              : mmWAVE SVT NMOS 5T w/i DNW
nmos_rf_6t                   : SVT NMOS 6T w/i DNW
nmos_rf_6t_110g              : mmWAVE SVT NMOS 6T w/i DNW
nmos_rf_lvt_5t               : LVT NMOS 5T w/i DNW
nmos_rf_lvt_5t_110g          : mmWAVE LVT NMOS 5T w/i DNW
nmos_rf_lvt_6t               : LVT NMOS 6T w/i DNW
nmos_rf_lvt_6t_110g          : mmWAVE LVT NMOS 6T w/i DNW
nmos_rf_lvt_nw               : LVT NMOS 4T w/o DNW
nmos_rf_lvt_nw_110g          : mmWAVE LVT NMOS 4T w/o DNW
nmos_rf_nw                   : SVT NMOS 4T w/o DNW
nmos_rf_nw_110g              : mmWAVE SVT NMOS 4T w/o DNW
nmos_rf_ulvt_5t              : ULVT NMOS 5T w/i DNW
nmos_rf_ulvt_5t_110g         : mmWAVE ULVT NMOS 5T w/i DNW
nmos_rf_ulvt_6t              : ULVT NMOS 6T w/i DNW
nmos_rf_ulvt_6t_110g         : mmWAVE ULVT NMOS 6T w/i DNW
nmos_rf_ulvt_nw              : ULVT NMOS 4T w/o DNW
nmos_rf_ulvt_nw_110g         : mmWAVE ULVT NMOS 4T w/o DNW
pmos_rf_18_5t                : 1.8v IO PMOS 5T w/i DNW
pmos_rf_18_nw                : 1.8v IO PMOS 4T w/o DNW (NW)
pmos_rf_18_nw_5t             : 1.8v IO PMOS 5T w/o DNW (NW)
pmos_rf_18ud15_5t            : 1.8vUD 1.5v IO PMOS 5T w/i DNW
pmos_rf_18ud15_nw            : 1.8vUD 1.5v IO PMOS 4T w/o DNW (NW)
pmos_rf_18ud15_nw_5t         : 1.8vUD 1.5v IO PMOS 5T w/o DNW (NW)
pmos_rf_25_5t                : 2.5v IO PMOS 5T w/i DNW
pmos_rf_25_nw                : 2.5v IO PMOS 4T w/o DNW (NW)
pmos_rf_25_nw_5t             : 2.5v IO PMOS 5T w/o DNW (NW)
pmos_rf_25od33_5t            : 2.5vOD 3.3v IO PMOS 5T w/i DNW
pmos_rf_25od33_nw            : 2.5vOD 3.3v IO PMOS 4T w/o DNW (NW)
pmos_rf_25od33_nw_5t         : 2.5vOD 3.3v IO PMOS 5T w/o DNW (NW)
pmos_rf_5t                   : SVT PMOS 5T w/i DNW
pmos_rf_5t_110g              : mmWAVE SVT PMOS 5T w/i DNW
pmos_rf_lvt_5t               : LVT PMOS 5T w/i DNW
pmos_rf_lvt_5t_110g          : mmWAVE LVT PMOS 5T w/i DNW
pmos_rf_lvt_nw               : LVT PMOS 4T w/o DNW (NW)
pmos_rf_lvt_nw_110g          : mmWAVE LVT PMOS 4T w/o DNW (NW)
pmos_rf_lvt_nw_5t            : LVT PMOS 5T w/o DNW (NW)
pmos_rf_lvt_nw_5t_110g       : mmWAVE LVT PMOS 5T w/o DNW (NW)
pmos_rf_nw                   : SVT PMOS 4T w/o DNW (NW)
pmos_rf_nw_110g              : mmWAVE SVT PMOS 4T w/o DNW (NW)
pmos_rf_nw_5t                : SVT PMOS 5T w/o DNW (NW)
pmos_rf_nw_5t_110g           : mmWAVE SVT PMOS 5T w/o DNW (NW)
pmos_rf_ulvt_5t              : ULVT PMOS 5T w/i DNW
pmos_rf_ulvt_5t_110g         : mmWAVE ULVT PMOS 5T w/i DNW
pmos_rf_ulvt_nw              : ULVT PMOS 4T w/o DNW (NW)
pmos_rf_ulvt_nw_110g         : mmWAVE ULVT PMOS 4T w/o DNW (NW)
pmos_rf_ulvt_nw_5t           : ULVT PMOS 5T w/o DNW (NW)
pmos_rf_ulvt_nw_5t_110g      : mmWAVE ULVT PMOS 5T w/o DNW (NW)


    - Resistor

rnmg                 : N+ metal gate resistor
rnmg_m               : Three terminal N+ metal gate resistor
rnmg_mx              : Three terminal N+ metal gate resistor
rnod                 : N+ diffusion resistor with salicide
rnod_m               : N+ diffusion resistor with salicide (3 terminal)
rnod_mx              : N+ diffusion resistor with salicide (3 terminal)
rnodwo               : N+ diffusion resistor without salicide
rnodwo_m             : N+ diffusion resistor without salicide (3 terminal)
rnodwo_mx            : N+ diffusion resistor without salicide (3 terminal)
rnwod                : NWell resistor under OD
rnwod_m              : NWell resistor under OD (3 terminal)
rnwod_mx             : NWell resistor under OD (3 terminal)
rnwsti               : NWell resistor under STI
rnwsti_m             : NWell resistor under STI (3 terminal)
rnwsti_mx            : NWell resistor under STI (3 terminal)
rpmg                 : P+ metal gate resistor
rpmg_m               : Three terminal P+ metal gate resistor
rpmg_mx              : Three terminal P+ metal gate resistor
rpod                 : P+ diffusion resistor with salicide
rpod_m               : P+ diffusion resistor with salicide (3 terminal)
rpod_mx              : P+ diffusion resistor with salicide (3 terminal)
rpodwo               : P+ diffusion resistor without salicide
rpodwo_m             : P+ diffusion resistor without salicide (3 terminal)
rpodwo_mx            : P+ diffusion resistor without salicide (3 terminal)
rupolym              : P+ poly resistor without salicide
rupolym_m            : Three terminal P+ poly resistor without salicide
rupolym_mx           : Three terminal P+ poly resistor without salicide
rupolym_rf           : P+Poly w/o silicide RF resistor
rupolym_rf_110g      : mmWave High-R resistor


    - MetalRes

rm10w      : Metal 10 resistor
rm1w       : Metal 1 resistor
rm2w       : Metal 2 resistor
rm3w       : Metal 3 resistor
rm4w       : Metal 4 resistor
rm5w       : Metal 5 resistor
rm6w       : Metal 6 resistor
rm7w       : Metal 7 resistor
rm8w       : Metal 8 resistor
rm9w       : Metal 9 resistor
rmap       : AL RDL resistor


    - Varactor

cmoscap_rf                : 0.9V N+/NW MOSVAR w/i DNW
cmoscap_rf18              : 1.8V N+/NW MOSVAR w/i DNW
cmoscap_rf18_110g         : mmWave 1.8V N+/NW C-type MOSVAR w/i DNW
cmoscap_rf18_nw           : 1.8V N+/NW MOSVAR w/o DNW (NW)
cmoscap_rf18_nw_110g      : mmWave 1.8V N+/NW C-type MOSVAR w/o DNW (NW)
cmoscap_rf25              : 2.5V N+/NW MOSVAR w/i DNW
cmoscap_rf25_110g         : mmWave 2.5V N+/NW C-type MOSVAR w/i DNW
cmoscap_rf25_nw           : 2.5V N+/NW MOSVAR w/o DNW (NW)
cmoscap_rf25_nw_110g      : mmWave 2.5V N+/NW C-type MOSVAR w/o DNW (NW)
cmoscap_rf_110g           : mmWave 0.9V N+/NW C-type MOSVAR w/i DNW
cmoscap_rf_nw             : 0.9V N+/NW MOSVAR w/o DNW (NW)
cmoscap_rf_nw_110g        : mmWave 0.9V N+/NW C-type MOSVAR w/o DNW (NW)
nmoscap                   : Core Voltage Standard-Vt NMOS in N-Well varactor
nmoscap_18                : 1.8V Standard-Vt NMOS in N-Well varactor
nmoscap_25                : 2.5V Standard-Vt NMOS in N-Well varactor
pcmoscap_rf               : 0.9V P+/PW MOSVAR w/i DNW
pcmoscap_rf18             : 1.8V P+/PW MOSVAR w/i DNW
pcmoscap_rf25             : 2.5V P+/PW MOSVAR w/i DNW
pmoscap                   : Core Voltage Standard-Vt PMOS in P-Well varactor
pmoscap_18                : 1.8V Standard-Vt PMOS in P-Well varactor
pmoscap_25                : 2.5V Standard-Vt PMOS in P-Well varactor


    - Bipolars

npn          : N+/PW/DNW VERTICAL NPN BIPOLAR
npn_mis      : N+/PW/DNW VERTICAL NPN BIPOLAR
pnp          : P+/NW/PSUB VERTICAL PNP BIPOLAR
pnp_mis      : P+/NW/PSUB VERTICAL PNP BIPOLAR


    - Diodes

dnwpsub          : DNW/PSUB diode
ndio             : N+/PW Core Voltage diode
ndio_18          : N+/PW 1.8V diode
ndio_18ll        : 1.8V Low Leakage N+/PW diode
ndio_18ud12      : N+/PW 1.8V_under_drive_1.2V_diode
ndio_18ud15      : N+/PW 1.8V_under_drive_1.5V_diode
ndio_25          : N+/PW 2.5V diode
ndio_25ll        : 2.5V Low Leakage N+/PW diode
ndio_25od33      : N+/PW 2.5V over-drive 3.3V diode
ndio_25ud18      : N+/PW 2.5V under-drive 1.8V diode
ndio_avt         : AVT N+/PW Core diode
ndio_ehvt        : Extreme High Vt N+/PW Core diode
ndio_esd         : ESD diode
ndio_hvt         : Core High Vt N+/PW diode
ndio_ll          : Low Leakage N+/PW Core diode
ndio_lvt         : Core Low Vt N+/PW diode
ndio_na          : Core Native N+/PW diode
ndio_na18        : Native N+/PW 1.8V diode
ndio_na25        : Native N+/PW 2.5V diode
ndio_uhvt        : Ultra High Vt N+/PW Core diode
ndio_ulvt        : Ultra Low Vt N+/PW Core diode
nwdio            : Nwell/PSUB diode
pdio             : P+/NW Core Voltage diode
pdio_18          : P+/NW 1.8V diode
pdio_18ll        : 1.8V Low Leakage P+/NW diode
pdio_18ud12      : P+/NW 1.8V under-drive 1.2V diode
pdio_18ud15      : P+/NW 1.8V under-drive 1.5V diode
pdio_25          : P+/NW 2.5V diode
pdio_25ll        : 2.5V Low Leakage P+/NW diode
pdio_25od33      : P+/NW 2.5V over-drive 3.3V diode
pdio_25ud18      : P+/NW 2.5V under-drive 1.8V diode
pdio_ehvt        : Extreme High Vt P+/NW Core diode
pdio_hvt         : Core High Vt P+/NW diode
pdio_ll          : Low Leakage P+/NW Core diode
pdio_lvt         : Core Low Vt P+/NW diode
pdio_uhvt        : Ultra High Vt P+/NW Core diode
pdio_ulvt        : Ultra Low Vt P+/NW Core diode
pwdnw            : PW/DNW diode


    - Capacitors

cfmom_2t              : CFMOM_2T
cfmom_mx_4t           : CFMOM_MX_4T
cfmom_wo              : CFMOM_WO
cfmom_wo_mx           : CFMOM_WO_MX
cfmom_wo_rf           : CFMOM_WO_RF
cfmom_wo_rf_110g      : CFMOM_WO_RF_110G


    - Inductors

spiral_std_mu_a28_dm             : standard inductor, coil Mu, crosspass 28KA Al-RDL, with dummy metal
spiral_std_mu_z_dm               : standard inductor, coil Mu, crosspass Mz, with dummy metal
spiral_sym_ct_mu_a28_a28_dm      : symmetry center-tap inductor, coil Mu, crosspass 28KA Al-RDL, tap 28KA Al-RDL, with dummy metal
spiral_sym_ct_mu_z_a28_dm        : symmetry center-tap inductor, coil Mu, crosspass Mz, tap 28KA Al-RDL, with dummy metal
spiral_sym_mu_a28_dm             : symmetry inductor, coil Mu, crosspass 28KA Al-RDL, with dummy metal
spiral_sym_mu_z_dm               : symmetry inductor, coil Mu, crosspass Mz, with dummy metal


    - RF_Device

nmosgr      : Guard-Ring for NMOS
pmosgr      : Guard-Ring for PMOS


    - ESD

ndio_hia_mac      : N-type HIA diode
pdio_hia_mac      : P-type HIA diode


    - Logic Gates

inv_18_mac            : 1.8V Inverter
inv_hv18_mac          : 1.8V high voltage Inverter
inv_18ud12_mac        : 1.8V under-drive 1.2V Inverter
inv_18ud15_mac        : 1.8V under-drive 1.5V Inverter
inv_25_mac            : 2.5V Inverter
inv_25od33_mac        : 2.5V over-drive 3.3V Inverter
inv_25ud18_mac        : 2.5V under-drive 1.8V Inverter
inv_ehvt_mac          : Extreme High Vt Inverter
inv_hvt_mac           : High Vt Inverter
inv_lvt_mac           : Low Vt Inverter
inv_uhvt_mac          : Ultra High Vt Inverter
inv_ulvt_mac          : Ultra Low Vt Inverter
inv_mac               : Standard Vt Inverter
nand2_18_mac          : 1.8V NAND
nand2_hv18_mac        : 1.8V high voltage NAND
nand2_18ud12_mac      : 1.8V under-drive 1.2V NAND
nand2_18ud15_mac      : 1.8V under-drive 1.5V NAND
nand2_25_mac          : 2.5V NAND
nand2_25od33_mac      : 2.5V over-drive 3.3V NAND
nand2_25ud18_mac      : 2.5V under-drive 1.8V NAND
nand2_ehvt_mac        : Extreme High Vt NAND
nand2_hvt_mac         : High Vt NAND
nand2_lvt_mac         : Low Vt NAND
nand2_uhvt_mac        : Ultra High Vt NAND
nand2_ulvt_mac        : Ultra Low Vt NAND
nand2_mac             : Standard Vt NAND
nand3_18_mac          : 1.8V NAND
nand3_hv18_mac        : 1.8V high voltage NAND
nand3_18ud12_mac      : 1.8V under-drive 1.2V NAND
nand3_18ud15_mac      : 1.8V under-drive 1.5V NAND
nand3_25_mac          : 2.5V NAND
nand3_25od33_mac      : 2.5V over-drive 3.3V NAND
nand3_25ud18_mac      : 2.5V under-drive 1.8V NAND
nand3_ehvt_mac        : Extreme High Vt NAND
nand3_hvt_mac         : High Vt NAND
nand3_lvt_mac         : Low Vt NAND
nand3_uhvt_mac        : Ultra High Vt NAND
nand3_ulvt_mac        : Ultra Low Vt NAND
nand3_mac             : Standard Vt NAND
nand4_18_mac          : 1.8V NAND
nand4_hv18_mac        : 1.8V high voltage NAND
nand4_18ud12_mac      : 1.8V under-drive 1.2V NAND
nand4_18ud15_mac      : 1.8V under-drive 1.5V NAND
nand4_25_mac          : 2.5V NAND
nand4_25od33_mac      : 2.5V over-drive 3.3V NAND
nand4_25ud18_mac      : 2.5V under-drive 1.8V NAND
nand4_ehvt_mac        : Extreme High Vt NAND
nand4_hvt_mac         : High Vt NAND
nand4_lvt_mac         : Low Vt NAND
nand4_uhvt_mac        : Ultra High Vt NAND
nand4_ulvt_mac        : Ultra Low Vt NAND
nand4_mac             : Standard Vt NAND
nor2_18_mac           : 1.8V NOR
nor2_hv18_mac         : 1.8V high voltage NOR
nor2_18ud12_mac       : 1.8V under-drive 1.2V NOR
nor2_18ud15_mac       : 1.8V under-drive 1.5V NOR
nor2_25_mac           : 2.5V NOR
nor2_25od33_mac       : 2.5V over-drive 3.3V NOR
nor2_25ud18_mac       : 2.5V under-drive 1.8V NOR
nor2_ehvt_mac         : Extreme High Vt NOR
nor2_hvt_mac          : High Vt NOR
nor2_lvt_mac          : Low Vt NOR
nor2_uhvt_mac         : Ultra High Vt NOR
nor2_ulvt_mac         : Ultra Low Vt NOR
nor2_mac              : Standard Vt NOR
nor3_18_mac           : 1.8V NOR
nor3_hv18_mac         : 1.8V high voltage NOR
nor3_18ud12_mac       : 1.8V under-drive 1.2V NOR
nor3_18ud15_mac       : 1.8V under-drive 1.5V NOR
nor3_25_mac           : 2.5V NOR
nor3_25od33_mac       : 2.5V over-drive 3.3V NOR
nor3_25ud18_mac       : 2.5V under-drive 1.8V NOR
nor3_ehvt_mac         : Extreme High Vt NOR
nor3_hvt_mac          : High Vt NOR
nor3_lvt_mac          : Low Vt NOR
nor3_uhvt_mac         : Ultra High Vt NOR
nor3_ulvt_mac         : Ultra Low Vt NOR
nor3_mac              : Standard Vt NOR
nor4_18_mac           : 1.8V NOR
nor4_hv18_mac         : 1.8V high voltage NOR
nor4_18ud12_mac       : 1.8V under-drive 1.2V NOR
nor4_18ud15_mac       : 1.8V under-drive 1.5V NOR
nor4_25_mac           : 2.5V NOR
nor4_25od33_mac       : 2.5V over-drive 3.3V NOR
nor4_25ud18_mac       : 2.5V under-drive 1.8V NOR
nor4_ehvt_mac         : Extreme High Vt NOR
nor4_hvt_mac          : High Vt NOR
nor4_lvt_mac          : Low Vt NOR
nor4_uhvt_mac         : Ultra High Vt NOR
nor4_ulvt_mac         : Ultra Low Vt NOR
nor4_mac              : Standard Vt NOR
trans_18_mac          : 1.8V Transmission Gate
trans_hv18_mac        : 1.8V high voltage Transmission Gate
trans_18ud12_mac      : 1.8V under-drive 1.2V Transmission Gate
trans_18ud15_mac      : 1.8V under-drive 1.5V Transmission Gate
trans_25_mac          : 2.5V Transmission Gate
trans_25od33_mac      : 2.5V over-drive 3.3V Transmission Gate
trans_25ud18_mac      : 2.5V under-drive 1.8V Transmission Gate
trans_ehvt_mac        : Extreme High Vt Transmission Gate
trans_hvt_mac         : High Vt Transmission Gate
trans_lvt_mac         : Low Vt Transmission Gate
trans_uhvt_mac        : Ultra High Vt Transmission Gate
trans_ulvt_mac        : Ultra Low Vt Transmission Gate
trans_mac             : Standard Vt Transmission Gate
tri_18_mac            : 1.8V Tri State Inverter
tri_hv18_mac          : 1.8V high voltage Tri State Inverter
tri_18ud12_mac        : 1.8V under-drive 1.2V Tri State Inverter
tri_18ud15_mac        : 1.8V under-drive 1.5V Tri State Inverter
tri_25_mac            : 2.5V Tri State Inverter
tri_25od33_mac        : 2.5V over-drive 3.3V Tri State Inverter
tri_25ud18_mac        : 2.5V under-drive 1.8V Tri State Inverter
tri_ehvt_mac          : Extreme High Vt Tri State Inverter
tri_hvt_mac           : High Vt Tri State Inverter
tri_lvt_mac           : Low Vt Tri State Inverter
tri_uhvt_mac          : Ultra High Vt Tri State Inverter
tri_ulvt_mac          : Ultra Low Vt Tri State Inverter
tri_mac               : Standard Vt Tri State Inverter

    - Parasitic Devices

parasitic_rc         : Parasitic RC device, Please refer to parasitic_rc_UserGuide.pdf in PDK_doc for detail usage.
parasitic_rc_3T      : Parasitic RC device, Please refer to parasitic_rc_UserGuide.pdf in PDK_doc for detail usage.

```

## 4. Main Devices

下面是一些普通设计中常用的 devices:
- MOSFET:
    - nch_mac, pch_mac: core voltage standard VT NMOS/PMOS transistor
    - nch_lvt_mac, pch_lvt_mac: core voltage low VT NMOS/PMOS transistor
    - nch_hvt_mac, pch_hvt_mac: core voltage high VT NMOS
    - nch_macx, pch_macx: core voltage standard VT NMOS/PMOS transistor, x 表示带有扩展模型，适合精密与中高速 (~ GHz) 设计
- Resistor: 
    - rnmg, rpmg (several tens of Ohms): N+/P+ metal gate resistor, 最常用 (例如模拟电路的分压偏置)
    - rupolym (several thousands of Ohms): P+ poly resistor without salicide, 高精度低电容电阻 (如 ADC 的参考电阻)
    - rnod, rpod (several Ohms): N+/P+ diffusion resistor with salicide, 常用于数字电路
- Capacitor:
    - cfmom_2t: 2 端 MOM (metal-oxide-metal) 电容 (标准电容)
    - cfmom_wo_rf: 无屏蔽 RF MOM 电容 (射频电路的高 Q 电容)
- Infuctors: 
    - spiral_std_mu_a28_dm: standard inductor, coil Mu, crosspass 28KA Al-RDL, with dummy metal
    - spiral_sym_ct_mu_a28_a28_dm: symmetry center-tap inductor, coil Mu, crosspass 28KA Al-RDL, tap 28KA Al-RDL, with dummy metal, 对称中心抽头电感 (用于射频差分电路)
- Varactor (变容二极管): 
    - cmoscap_rf: 0.9V N+/NW MOSVAR w/i DNW (deep n well), 适用于标准 RF 调谐
    - nmoscap, pmoscap: Core Voltage Standard-Vt NMOS/PMOS in N/P-Well varactor, 通用模拟/数字调谐
- Bipolars: 
    - npn_mis, pnp_mis: npn/pnp bipolar transistor with mismatch model
- Diodes: 
    - ndio: N+/PWell Core Voltage diode
    - ndio_18ll: 1.8V Low Leakage N+/PWell diode
    - nwdio: : Nwell/PSUB diode, 带有 Psubstrate + Nwell 隔离噪声的二极管


几种主要电阻的具体参数：
<div class='center'>

| Resistor | Type | (n-type) minimum value (Ohm) | (n-type) maximum value (Ohm) | Square resistor (Ohm) |
|:-:|:-:|:-:|:-:|:-:|
 | rnmg/rpmg | N+/P+ metal gate resistor                    | 59.9223 @ 0.14u/0.1u | 12.7891K @ 29.88u/0.1u | 42.80 |
 | rnod/rpod | N+/P+ diffusion resistor with salicide       | 1.30726 @ 0.14u/2u   | 887.071 @ 95u/2u | 18.68 |
 | rnodwo/rpodwo | N+ diffusion resistor without salicide   | 151.916 @ 2u/2u      | 6.80481K @ 95u/2u | 0.14K |
 | rnwod/rpwod | NWell/PWell resistor under OD              | 561.622 @ 1.8u/2u    | 2.5978K @ 95u/2u | 54.69 |
 | rnwsti | NWell resistor under STI                        | 2.12502K @ 1.8u/2u   | 100.123K @ 95u/2u | 2.11K |
 | rupolym | P+ poly resistor without salicide              | 594.805 @ 2u/2u      | 7.19K @ 24.64u/2u | 0.58K |
 | rupolym_rf_110g | mmWave (RF) High-R resistor            | 662.509 @ 1u/1u      | 6.11098K @ 1u/0.1u | 0.61K |
</div>

<!-- 下面是 RF 设计中常用的器件：
 -->


## 5. Devices Models

<!-- - minimum/maximum MOSFET length and width:
      - d
 -->

- `PDK_doc/TSMC_DOC_WM/model/1d8/crn28ull_1d8_elk_v1d8_2p2_release_note.pdf`: RF SPICE Model Release Note, 包含了 RF 器件 SPICE 模型的一些基本信息

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-01-08-50_Basic Information of TSMC 28nm Process Library.png"/></div>

- `PDK_doc/TSMC_DOC_WM/model/1d8/cln28ull_1d8_elk_v1d8_3_corner_release_note.pdf`: 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-01-16-23_Basic Information of TSMC 28nm Process Library.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-01-16-37_Basic Information of TSMC 28nm Process Library.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-01-11-15_Basic Information of TSMC 28nm Process Library.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-01-11-26_Basic Information of TSMC 28nm Process Library.png"/></div>

## 6. Design Rules




**DeepSeek 的回答 (2025.07.19)：**

以下是 TSMC N28 工艺库中各 Layer 的 Markdown 表格形式，包含英文全称和中文解释：  

| **Layer** | **英文全称**              | **中文解释**                                                                 |
|-----------|--------------------------|-----------------------------------------------------------------------------|
| NW        | N-Well                   | N型阱，用于在P型衬底上形成NMOS晶体管的区域。                                      |
| OD        | Oxide Definition         | 有源区 (Active Area) ，定义晶体管源/漏/沟道的区域，未被场氧 (STI) 隔离的部分。          |
| PO        | Poly Gate                | 多晶硅栅极，用于形成晶体管的栅极结构 (可能被金属栅替代，但名称保留) 。                     |
| PP        | P-Plus Implant           | P型高浓度掺杂层，用于PMOS的源/漏区或P-Well的接触区。                              |
| NP        | N-Plus Implant           | N型高浓度掺杂层，用于NMOS的源/漏区或N-Well的接触区。                              |
| RPO       | Resist Protect Oxide     | 保护性氧化层，在特定工艺步骤 (如离子注入) 中保护特定区域不被修改。                         |
| CO        | Contact Opening          | 接触孔，连接有源区 (OD) 或多晶硅栅 (PO) 与第一层金属 (M1) 。                           |
| M1        | Metal 1                  | 第一层金属互连，通常为铝或铜，用于局部布线。                                        |
| VIA1      | Via 1                    | 连接 Metal 1 和 Metal 2 的垂直通孔。                                           |
| M2        | Metal 2                  | 第二层金属互连，布线密度和厚度可能与 M1 不同。                                      |
| VIA2      | Via 2                    | 连接 Metal 2 和 Metal 3 的垂直通孔。                                           |
| M3        | Metal 3                  | 第三层金属互连，通常用于更全局的信号或电源布线。                                      |
| PM        | Passivation Metal        | 钝化金属层，覆盖钝化层 (如SiN或SiO₂) ，保护芯片免受环境侵蚀。                          |
| IP        | Integrated Passivation   | 集成钝化层，用于芯片表面的最终保护，防止划伤或湿气侵入。                               |
| RPDMY     | Resist Protect Dummy     | 光刻保护虚设层，用于工艺均匀性 (如CMP) 或填充无电路区域。                              |
| RH        | Resist Hardmask          | 硬掩模层，用于复杂图形刻蚀 (如双重曝光技术) 。                                        |
| TEXT      | Text Annotation Layer    | 文本标注层，仅用于标识或注释，不参与实际制造。                                        |
| DMEXCL    | Dummy Metal Exclusion    | 禁止放置虚设金属 (Dummy Metal) 的区域，确保信号完整性。                               |
| MOMDMY    | MOM Dummy Capacitor      | 金属-氧化物-金属 (MOM) 电容的虚设结构，用于提高工艺均匀性或匹配特性。                   |
| PDK       | Process Design Kit       | 工艺设计套件，包含设计规则、模型文件和工艺参数，非物理层。                             |

**说明：**  
1. **重复 Layer** (如 `OD`, `PO`, `DMEXCL`, `MOMDMY`) 可能因不同上下文 (如不同光刻掩模或层次派生) 出现多次，需结合 PDK 规则确认。  
2. **FinFET 工艺差异**：在先进工艺 (如 N28) 中，部分 Layer (如 `OD`) 可能与平面晶体管不同 (例如对应 Fin 结构) 。  
3. **PDK 依赖**：具体定义请以 TSMC N28 官方文档为准。  

如果需要进一步调整格式或补充内容，请随时告知！

**Kimi 的回答 (2025.07.19)**

在 TSMC 28 nm (N28) 工艺的设计规则文档/PDK 中，版图 (layout) 里出现的各类 layer 名称及其英文全称、中文含义如下。  
 (注：TSMC 的 layer 命名在不同节点基本保持一致，以下解释以 28 nm bulk CMOS 为基准，并补充了 Dummy、Marker 等辅助层。) 


<div class='center'>

| 版图字符 | 英文全称 | 中文解释 |
|---|---|---|
| NW | N-Well | N 型深阱，用来放置 PMOS，为 PMOS 提供背栅/体区。 |
| OD | Oxide-Definition (或 Active Area)  | 有源区/扩散区，硅表面被 STI 包围的“岛”区域，真正做源/漏/沟道的位置。 |
| PO | Poly-Silicon | 多晶硅栅极层，形成 MOS 管的栅。 |
| PP | P+ Implant (P-Plus) | P 型重掺杂注入掩膜，用于在 OD 内形成 PMOS 的源/漏、P+ 保护环等。 |
| NP | N+ Implant (N-Plus) | N 型重掺杂注入掩膜，用于形成 NMOS 的源/漏、N+ 保护环等。 |
| RPO | Resistor Protect Oxide / Resist Protect Oxide | 在需要保留高阻 poly 电阻的区域，阻挡 silicide 形成，从而得到高阻 poly 电阻。 |
| CO | Contact | 第一层金属 (M1) 与 poly、OD 之间的钨塞接触孔。 |
| M1 | Metal-1 | 第一层铝/铜互连金属。 |
| VIA1 | Via-1 | M1 与 M2 之间的通孔。 |
| M2 | Metal-2 | 第二层金属。 |
| VIA2 | Via-2 | M2 与 M3 之间的通孔。 |
| M3 | Metal-3 | 第三层金属 (更高层依次为 M4、M5…) 。 |
| PM | Pad-Metal / Top-Metal | 最顶层厚铝/铜，用于打线焊盘。 |
| IP | I/O Pad | 芯片封装用焊盘开口层 (定义 bump/bond pad 区域) 。 |
| RPDMY | Resist-Poly Dummy | 多晶硅 dummy 图形层，用于保持图形密度、提高 CMP 均匀性。 |
| RH | Resistor High-sheet | 高阻 poly 电阻模型层，与 RPO 一起使用，做高值电阻。 |
| text | Text Layer | 版图标注层，只用于显示文字、不产生掩膜。 |
| DMEXCL | Density-Mark Exclude | 密度检查排除标记，告诉 DRC 在该区域不计算金属或多晶硅密度。 |
| MOMDMY | MOM-Cap Dummy | MOM (Metal-Oxide-Metal) 电容 dummy 金属块，用于保持电容区域金属密度。 |
| PDK | Process Design Kit | 工艺设计套件总称，并非版图层，而是包含 DRC/LVS/PEX rule file、器件模型、标准单元库、IO 库等整套设计支持文件。 |

</div>

补充说明  
1. “OD” 在列表里出现了两次，只是重复列出，含义不变。  
2. 不同 PDK 版本对 Dummy、Marker 层的命名可能略有差异 (如 DMEXCL 也可能写作 DENSTY_EXCL、MOM_DMY 等) ，但功能一致。  
3. 若后续金属层继续向上，则依次为 M4/VIA3/M5/VIA4…，28 nm 一般提供 8~10 层金属供 SoC 使用。


以下是我们手动整理的 `tsmcN28` 工艺库 (台积电 28nm CMOS 工艺库) 的 **Cadence Virtuoso 版图 DRC 报错规则** 详细解释，包含 **缩写全称**、**规则全称** 及 **含义说明**，数据在 `calibre.drc` 等文件中直接搜索得到：

<span style='font-size:10px'>
<div class='center'>

| **DRC Rule** | **缩写全称** | **规则全称** | **含义解释** |
|-------------|-------------|-------------|-------------|
| **G.1** | **Grid Rule 1** | **Metal-1 Grid Alignment Rule** | M1 层所有图形必须对齐 **0.005 µm 的整数倍网格**，确保制造精度。 |
| **NW.S.1** | **NW Space 1** | **N-Well Minimum Spacing Rule** | 相邻 **N-Well (NW)** 之间的最小间距必须 **≥ 0.24 µm**，防止阱区漏电。 |
| **NW.S.2** | **NW Space 2** | **N-Well Different Potential Spacing Rule** | 不同电位的 **NW1V (N-Well with Voltage)** 间距必须 **≥ 0.8 µm**，避免电压干扰。 |
| **NW.S.9** | **NW Space 9** | **N-Well Parallel Run Length Spacing Rule** | 当 NW 平行走线长度 **> 0.5 µm** 且未与 **OD/SR_DOD/DOD** 交互时，间距需 **≥ 0.3 µm**。 |
| **NW.A.1** | **NW Area 1** | **N-Well Minimum Area Rule** | 单个 NW 图形的最小面积必须 **≥ 0.4 µm²**，确保工艺均匀性。 |
| **NW.A.2** | **NW Area 2** | **Composite N-Well/OD2 Area Rule** | 组合层（如 **OD2 OR NW, NW NOT OD2, OD2 AND NW**）的最小面积需 **≥ 0.4 µm²**。 |
| **OD.DN.3** | **OD Density 3** | **Active Layer Local Density Rule** | 在 **20 µm × 20 µm** 窗口（步进 10 µm）内，**OD/DOD/SR_DOD** 的密度必须 **≥ 20%**，防止刻蚀不均匀。 |
| **OD2.S.5** | **OD2 Space 5** | **OD2 Exclusion Spacing Rule** | **NW 层中非 OD2 区域（NW NOT OD2）** 的最小间距需 **≥ 0.24 µm**。 |
| **PO.DN.3.1** | **PO Density 3.1** | **Poly Local Density Rule** | 在 **10 µm × 10 µm** 窗口（步进 5 µm）内，**PO/SR_DPO/DPO（排除 CPO）** 的密度必须 **≥ 10%**。 |
| **M1.S.2** | **M1 Space 2** | **M1 Width-Dependent Spacing (W1/L1)** | 当至少一条 M1 线宽 **> 0.1 µm** 且平行走线长度 **> 0.22 µm** 时，间距需 **≥ 0.06 µm**。 |
| **M1.S.3** | **M1 Space 3** | **M1 Width-Dependent Spacing (W2/L2)** | 当至少一条 M1 线宽 **> 0.18 µm** 且平行走线长度 **> 0.22 µm** 时，间距需 **≥ 0.1 µm**。 |
| **M1.S.4** | **M1 Space 4** | **M1 Width-Dependent Spacing (W3/L3)** | 当至少一条 M1 线宽 **> 0.47 µm** 且平行走线长度 **> 0.47 µm** 时，间距需 **≥ 0.13 µm**。 |
| **M1.S.5** | **M1 Space 5** | **M1 Width-Dependent Spacing (W4/L4)** | 当至少一条 M1 线宽 **> 0.63 µm** 且平行走线长度 **> 0.63 µm** 时，间距需 **≥ 0.15 µm**。 |
| **M1.S.8** | **M1 Space 8** | **M1 Dense Line-End Spacing Rule** | 对 **密集 M1 线端**（定义见注释）的最小间距需 **≥ 0.07 µm**，防止短路。 |
| **M1.EN.3** | **M1 Enclosure 3** | **M1 Over CO (Contact) Enclosure Rule** | 当 M1 线宽 **> 0.7 µm** 时，M1 对 **CO (Contact)** 的覆盖必须 **≥ 0.03 µm**。 |
| **M1.EN.4** | **M1 Enclosure 4** | **M1 Narrow Space CO Enclosure Rule** | 当 M1 线宽 **≥ 0.08 µm**、M1 间距 **< 0.06 µm** 且平行走线 **> 0.18 µm** 时，M1 对 CO 的覆盖需 **≥ 0.015 µm**（不适用于 CO 间距 **< 0.08 µm** 的情况）。 |
| **M1.A.1** | **M1 Area 1** | **M1 Minimum Area Rule** | M1 图形的最小面积必须 **≥ 0.0115 µm²**。 |
| **M1.A.3** | **M1 Area 3** | **M1 Small Feature Area Rule** | 当 M1 图形所有边长 **< 0.13 µm** 时，面积需 **≥ 0.038 µm²**（排除 **0.05 µm × 0.13 µm** 的填充图形）。 |
| **M1.A.4** | **M1 Area 4** | **M1 Enclosed Area Rule** | M1 封闭区域的最小面积必须 **≥ 0.2 µm²**。 |
| **LUP.6** | **Latch-Up 6** | **NMOS/PMOS Substrate Tap Proximity Rule** | **NMOS 源/漏区** 到同 **PW (P-Well) STRAP** 的距离 **≤ 33 µm**，**PMOS 源/漏区** 到同 **NW (N-Well) STRAP** 的距离 **≤ 33 µm**，防止闩锁效应（Latch-Up）。 |

</div>
</span>

## 7. Frequently Asked Qu.

**问题 1: tsmc28n 工艺库中含有 Mosfets macro device 和 RF_Mosfets, 它们有什么区别，常规设计中应该用谁？用段落回答我，不要 list**

**回答 1: (2025.06.25 由 DeepSeek 生成)**

在 TSMC 28nm 工艺库中, MOSFETs (macro device) 和 RF_MOSFETs 的主要区别在于它们的优化目标和适用场景。常规 MOSFETs 是针对通用数字和模拟电路设计的，注重面积、功耗和速度的平衡，适用于大多数标准逻辑电路、存储器和低频模拟模块。它们提供多种阈值电压选项 (如 LVT, RVT, HVT)，但在高频性能 (如噪声、线性度) 方面未做特殊优化。相比之下, RF_MOSFETs 专门针对射频应用 (如 LNA, PA, 混频器等) 优化，通过降低寄生参数 (如栅极电阻和漏源电容) 来提高高频性能，并包含更精确的射频模型 (如 S 参数和噪声系数) 。  

在常规设计中，如果电路工作频率较低 (如数字逻辑或低频模拟电路) ，应优先使用标准 MOSFETs, 因为它们面积更小、成本更低且设计流程成熟。然而，如果设计涉及高频或射频应用 (如 5G、Wi-Fi 或毫米波电路) ，则必须使用 RF_MOSFETs, 以确保性能指标 (如噪声、增益和线性度) 满足要求。选择错误的器件类型可能导致仿真结果与流片实测严重不符，因此在设计初期就应根据应用需求明确选用哪种器件。建议参考 TSMC 的 PDK 文档或与 Foundry 支持团队沟通，以确认具体器件的设计规范。

## 8. gm/Id Simulation 

### 8.1 summary of I_nor

- `nch_mac`, `pch_mac`:
    - vgs_max = 990 mV
    - vgb_max = 990 mV
    - L_range = (27.001 nm, 900.1 nm)
    - W_range = (90.000 nm, 2700.1 nm)
    - a_range = (0.1, 100)

分别设置 vds = 125 mV, 225 mV 进行仿真，得到归一化电流 I_nor 结果如下 (总结成表方便查阅)：

<div class='center'>

**Normalized current I_nor = Id/a of `nch_mac` in tsmcN28 process library.**
<br>
Note that for NMOS: I_nor and length have a <span style='color:red'> positive </span> correlation.
<br>
But for PMOS: I_nor and length have a <span style='color:blue'> negative </span> correlation. 
</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-18-16-27-29_202508_tsmcN28_CP-PLL__3rd-Order_Type-II_Integer-N.png"/></div>


### 8.2 nch_mac (Vds = 225 mV)

- L from 60n to 600n (19 steps)
- a from 2 to 22 (5 steps)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-27-50_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-16-54_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-17-45_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-21-59_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-24-10_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-25-13_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-26-26_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-27-03_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>

<!-- ### 8.3 using ADE XL

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-23-14-14_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>

### 8.4 pch_mac (Vds = 225 mV) -->