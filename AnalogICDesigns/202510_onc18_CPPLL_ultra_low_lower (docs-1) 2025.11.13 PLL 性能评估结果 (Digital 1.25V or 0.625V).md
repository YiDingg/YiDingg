# 202510_onc18_CPPLL_ultra_low_lower (docs-1) 2025.11.13 PLL 性能评估结果 (Digital 1.25V or 0.625V)

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 16:42 on 2025-11-13 in Beijing.


## 13. 1.25V/0.625V Option Test


### 13.2 1.25V option test

先用 Spectre FX + AX 简单测试：

<div class='center'>

| testbench 原理图设置 | FD chain without/with retiming 原理图 |  |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-12-17-33-57_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-12-17-35-05_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | Spectre FX + AX 仿真结果总览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-12-17-44-18_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |

</div>


然后用 Spectre X + CX 进行正式仿真，具体设置如下：
- (1) PFD (1 point): `PFD_ANDrst` with (KA, WN, L) = (2.5, 0.84, 0.18)
- (2) CP (1 point): 模拟尺寸为 (KA, WN, L) = (2.0, 0.42, 8.00), 数字部分尺寸与 PFD 保持一致
- (3) LPF (1 point): 使用两组最佳 LPF 参数
    - RVCO1: (IP, R1, C1, alpha) = **(20 nA, 10.5 MOhm, 24 pF, 1/12)**
    - RVCO2: (IP, R1, C1, alpha) = **(20 nA, 10.5 MOhm, 33 pF, 1/11)**
- (4) VCO (2 points): 仍然使用 RVCO1_v1/RVCO2_v2 两种
- (5) FD (5+2 = 7 point):
    - CK_OUT = X24: 一共五种，分别是 `sche_FD24_X01`, `sche_FD24_X02`, `sche_FD24_X04`, `sche_FD24_X08` 和 `sche_FD24_X01_retiming`
    - CK_OUT = X48: 一共两种，分别是 `sche_FD48_X01` 和 `sche_FD48_X01_retiming` (1.25V @ X48 时功耗较高，没有必要尝试尺寸更大的 FD)
- (6) VDD ripple (1 point): 仅考虑 300 kHz 正弦纹波
- (7) Corner (1 point): TT27 only
- (8) Start-up (1 point): no start-up circuit
- (9) Else: transient time = 15 ms. (当前 LPF 参数下 settling time < 5 ms)
- 上面一共是 2 x 7 = 14 种组合，每次仿真五个点的话，大约要 3\*2.5h = 7.5h

<div class='center'>

| Spectre X + CX 仿真结果，耗时 3 x 8.05 ks (2h 14m 8s) = 24.15 ks (6h 42m 24s) |  |
|:-:|:-:|
 | 结果总览 (按 RVCO 排序) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-00-15-05_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | 将 CK_X24 数据导出到 MATLAB 进行可视化和分析，数据导出顺序同下图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-00-26-00_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
 | Je_rms 和 Jc_rms 结果可视化 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-01-35-10_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | IDD, Je_rms 和 Jc_rms 共同对比 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-01-43-05_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |
</div>

对 1.25V Operation 来讲, 前仿就达到 450 nA 的点我们不予考虑，由此筛选出上面几个可行组合：

<div class='center'>

| Num | Argument | IDD | Je_rms | Jc_rms |
|:-:|:-:|:-:|:-:|:-:|
 | Num.1 | RVCO1 @ FDX24_X01            | 233.2 nA | 26.88 mUI | 3.70 mUI |
 | Num.6 | RVCO2 @ FDX24_X01            | 274.1 nA | 25.08 mUI | 3.18 mUI |
 | Num.7 | RVCO2 @ FDX24_X01_retiming   | 293.2 nA | 22.35 mUI | 3.01 mUI |
 | Num.11 | RVCO1 @ FDX48_X01           | 406.7 nA | 20.88 mUI | 2.30 mUI |
 | Num.12 | RVCO1 @ FDX48_X01_retiming  | 444.0 nA | 19.76 mUI | 2.34 mUI |
</div>

总这几个点中选取最佳方案：
- (1) RVCO1: 两个方案
    - Num.1 (RVCO1 @ FDX24_X01), IDD = 233.2 nA, Je_rms = 26.88 mUI, Jc_rms = 3.70 mUI
    - Num.11 (RVCO1 @ FDX48_X01), IDD = 406.7 nA, Je_rms = 20.88 mUI, Jc_rms = 2.30 mUI
- (2) RVCO2: 一个方案
    - Num.7 (RVCO2 @ FDX24_X01_retiming), IDD = 293.2 nA, Je_rms = 22.35 mUI, Jc_rms = 3.01 mUI

下面分别给出这三个方案的详细相噪结果：

<!-- <div class='center'>

| Num.1 (RVCO1 @ FDX24_X01), IDD = 233.2 nA, Je_rms = 26.88 mUI, Jc_rms = 3.70 mUI | Num.11 (RVCO1 @ FDX48_X01), IDD = 406.7 nA, Je_rms = 20.88 mUI, Jc_rms = 2.30 mUI | Num.7 (RVCO2 @ FDX24_X01_retiming), IDD = 293.2 nA, Je_rms = 22.35 mUI, Jc_rms = 3.01 mUI |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-13-32-18_临时文件.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-13-34-20_临时文件.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-13-34-27_临时文件.png"/></div> |
</div> -->

<div class='center'>

| Num | Argument | Output Freq. | IDD | Je_rms | Jc_rms | Phase Noise |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
 | Num.1 | RVCO1 @ FDX24_X01            | 786.432 kHz | 233.2 nA | 26.88 mUI | 3.70 mUI | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-13-32-18_临时文件.png"/></div> |
 | Num.7 | RVCO2 @ FDX24_X01_retiming   | 786.432 kHz | 293.2 nA | 22.35 mUI | 3.01 mUI | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-13-34-27_临时文件.png"/></div> |
 | Num.11 | RVCO1 @ FDX48_X01           | 1.5729 MHz  | 406.7 nA | 20.88 mUI | 2.30 mUI | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-13-34-20_临时文件.png"/></div> |
</div>

**注意 Num.1 和 Num.7 的 VCO 工作频率为 CK_X24 (24 x 32.768 kHz = 786.432 kHz), 而 Num.11 的 VCO 工作在 CK_X48 (48 x 32.768 kHz = 1.5729 MHz)**



### 13.3 0.625V option test

先用 tb_FD 测试下 DFF 能否正常工作，其实也就是测试 DFF 中的逻辑门：



<div class='center'>

| FD 测试结果总览 (未排序) | FD 测试结果总览 (按 VDD 排序) | 0.625V 极限测试结果 |
|:-:|:-:|:-:|
 | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-02-21-13_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-02-21-55_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-13-02-27-53_202510_onc18_CPPLL_ultra_low_lower (3) Other Modules Design and Layout.png"/></div> |

</div>

上面结果表明, uhvt 器件/逻辑门在 0.625V supply 下确实没法工作，至少到 0.975V 左右才能正常工作。

在当前工艺库设置下，我们仅能使用 native/standard/ultra-high Vt 三种器件，而 std (nominal) Vt 器件的漏电又太大，因此 0.625V 甚至 0.8V 供电方案都不可行。

