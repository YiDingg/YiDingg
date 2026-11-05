# Basic Information and Tutorials for tsmcN12 (TSMC 12nm FinFET Process Library)

> [!Note|style:callout|label:Infor]
> Initially created by YiDingg at 00:50 on 2026-10-10 in Beijing.
> dingyi233@mails.ucas.ac.cn

## 1. 资料总览与学习指引

### 1.0 我们整理后的资料

2026-10 TSMC 12nm 教程：
- 123 云盘：
- 百度网盘：https://pan.baidu.com/s/1sxMXg_6bL5Y6n9AHII5gwA?pwd=8888
- 注：123 云盘中我们仅分享整理后的、需要看的、需要用到的资料，其它原始资料以及尺寸较大的教学视频仅在百度网盘链接中有


``` bash


通过网盘分享的文件：2026-10 TSMC 12nm 教程
链接: https://pan.baidu.com/s/1sxMXg_6bL5Y6n9AHII5gwA?pwd=8888 提取码: 8888 
--来自百度网盘超级会员v3的分享
```



### 1.1 版图教程



结合 `MyLib_tutorials_tsmcN12` 中的 cell `tutorial_layout_basic` 来看各层、晶体管各设置的作用/效果：
- **最小分辨率: 0.001um? (待确定)**
- DFM: 孔的 DFM (Design for Manufacturability) 要打开，DFM 规则也要打开：打开 DFM，包围孔的金属面积会变大，边缘会扇出更多，提高良率 (这里放图)
- fin: 可理解为绝缘竖层，2 个 fin = 1 个有效沟道，4 个 fin = 3 个有效沟道；如图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-10-02-17-54_(AAA) Basic Information and Tutorials for tsmcN12 (TSMC 12nm FinFET Process Library).png"/></div>
- M0OD/M0PO layer：当作 M0 看待，只不过一个是连接 OD，另一个是连接 PO
- polyCnt ON > polyCntType = staggered (default) 或者 nonstaggered (推荐)：俯视图中，前者 staggered 是将 via0 打在 PO 上方，后者是将 via0 打在 PO 之间；如图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-10-02-34-53_(AAA) Basic Information and Tutorials for tsmcN12 (TSMC 12nm FinFET Process Library).png"/></div>
- polyCnt ON > nonstaggered > connected M1 layer ON/OFF：暂时不知道区别
- P96 layer ON/OFF：能开则开，利于良率 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-10-02-48-27_(AAA) Basic Information and Tutorials for tsmcN12 (TSMC 12nm FinFET Process Library).png"/></div>
- leftCnt/rightCnt/innerCnt：OD 自动连接到 M1，推荐打开 ON (默认 MD) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-10-03-03-22_(AAA) Basic Information and Tutorials for tsmcN12 (TSMC 12nm FinFET Process Library).png"/></div>
- CPO: only necessary for fL<=20n, 大于此值也可以 ON 但不知道是好是坏；Cut Poly，poly 切割层，也即一层专门用来 "把多余 poly 切断" 的掩模层 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-10-03-23-40_(AAA) Basic Information and Tutorials for tsmcN12 (TSMC 12nm FinFET Process Library).png"/></div>
- Symmetry M1 Switch：推荐打开 ON (默认 OFF)，打开后 OD 上下两侧 M1 才对称
- length 可选值：
    - `nch/pch_svt_mac`: 16n/18n/20n/36n 以及 72n~240n 的任意值 (min step = 1nm)
    - `nch/pch_lvt_mac`: 

### 1.x 其它原始资料

组里提供的资料 (主要来自张老师)：
- FinFET 12nm 版图教程：
    - 18 个 `.mp4` 教学视频：
    - 一个示例 library `tsmc12nm.zip` (不是 PDK)：
    - 三个教学文档
        - `1-基础知识.docx`
        - `2-器件基础知识.docx`
        - `3-DRC规则经验.docx`
- 12nm 56G SerDes IP GDS from Synopys (版图示例):
    - `sb_txrx_aup3ple.gds.gz`：TOP TRX 版图
    - `sb_cm_agp1p5e.gds.gz`：外围公共模块 (PLL, 基准, 偏置)
