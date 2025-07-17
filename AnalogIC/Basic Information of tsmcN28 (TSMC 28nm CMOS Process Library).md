# Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library) (台积电 tsmcN28 工艺库基本信息)

> [!Note|style:callout|label:Infor]
> Initially published at 00:01 on 2025-06-25 in Beijing.



## PDK Docs

整个 PDK 所有的文档如下：

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-00-08-51_Basic Information of TSMC Process Libraries.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-00-09-16_Basic Information of TSMC Process Libraries.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-00-05-39_Basic Information of TSMC Process Libraries.png"/></div>

其中最关键的几个文档如下：
- `PDK_doc/TSMC_DOC_WM/ReleaseNote.txt`: README 文件，介绍了 PDK 的安装流程和器件基本情况 (但其实不看也行，因为下面的 PDK_usage 比它介绍得更详细)
- `PDK_doc\TSMC_DOC_WM\PDK\TSMCN28_PDK_Usage_20190322.pdf`: PDK 使用手册，介绍了 PDK 的基本使用方法和注意事项
- d


## PDK Usage Guide

打开 `PDK_doc\TSMC_DOC_WM\PDK\TSMCN28_PDK_Usage_20190322.pdf` 文件，其目录如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-00-33-34_Basic Information of TSMC 28nm Process Library.png"/></div>


## Devices Information



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

## Main Devices

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

下面是 RF 设计中常用的器件：



## Devices Models

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

## Design Rules


- A1 : Active−Active Spacing
- A2 : Metal Width
- A4 : Enclosure of Contact by Active
- A3 : Metal−Metal Spacing
- A5 : Poly−Active Spacing
- A6 : Active−Well Spacing
- A8 : Poly−Poly Spacing
- A7 : Enclosure of Active by Well

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-19-12-04_Basic Information of TSMC 28nm Process Library.png"/></div>

## Frequently Asked Qu.

**问题 1: tsmc28n 工艺库中含有 Mosfets macro device 和 RF_Mosfets, 它们有什么区别，常规设计中应该用谁？用段落回答我，不要 list**

**回答 1: (2025.06.25 由 DeepSeek 生成)**

在 TSMC 28nm 工艺库中, MOSFETs (macro device) 和 RF_MOSFETs 的主要区别在于它们的优化目标和适用场景。常规 MOSFETs 是针对通用数字和模拟电路设计的，注重面积、功耗和速度的平衡，适用于大多数标准逻辑电路、存储器和低频模拟模块。它们提供多种阈值电压选项 (如 LVT, RVT, HVT)，但在高频性能 (如噪声、线性度) 方面未做特殊优化。相比之下, RF_MOSFETs 专门针对射频应用 (如 LNA, PA, 混频器等) 优化，通过降低寄生参数 (如栅极电阻和漏源电容) 来提高高频性能，并包含更精确的射频模型 (如 S 参数和噪声系数) 。  

在常规设计中，如果电路工作频率较低 (如数字逻辑或低频模拟电路) ，应优先使用标准 MOSFETs, 因为它们面积更小、成本更低且设计流程成熟。然而，如果设计涉及高频或射频应用 (如 5G、Wi-Fi 或毫米波电路) ，则必须使用 RF_MOSFETs, 以确保性能指标 (如噪声、增益和线性度) 满足要求。选择错误的器件类型可能导致仿真结果与流片实测严重不符，因此在设计初期就应根据应用需求明确选用哪种器件。建议参考 TSMC 的 PDK 文档或与 Foundry 支持团队沟通，以确认具体器件的设计规范。

## Simulated MOSFET

- `nch_mac`: 
    - vgs_max = 990 mV
    - vgb_max = 990 mV
    - L_range = (27 nm, 900.1 nm)
    - W_range = (90 nm, 2700.1 nm)
    - a_max = 100
- `pch_mac`:
    - vgs_max = 990 mV
    - vgb_max = 990 mV
    - L_range = 
    - W_range = 



### nch_mac (Vds = 225 mV)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-27-50_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-16-54_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-17-45_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-21-59_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-24-10_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-25-13_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-26-26_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-07-17-19-27-03_Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library).png"/></div>

### pch_mac (Vds = 225 mV)