# 202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 20:47 on 2026-07-19 in LinCang.
> dingyi233@mails.ucas.ac.cn

## 1. Design of PCB 

### 1.1 前期准备

详见 [Altium Designer 23 安装与使用教程](<AnalogIC/Altium Designer 23 安装与使用教程.md>)


### 1.2 元件选型

LDO: 
- 参考：YWJ 师姐之前用的是 LT3060
- 选型：https://www.analog.com/cn/parametricsearch/2459#/
    - 图片：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-19-21-07-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>
    - 本来想采用 LT3027 (双通道 100mA/100mA) 的，但是发现其可调输出范围是 (1.22 V, 20 V) 不满足要求，遂放弃
    - 经过考察，上图列出的几个双通道 LDO 都不能满足输出范围要求 (都在 1.2V 以上)
    - 于是又来选单通道的，经过输出电压、PIN 脚数筛选，几个比较合适的是：
        - LT3020: 100 mA, VOUT > 200 mV, 250uVrms, EN, 5-Pin, 2-cap (PIN 和外围非常简洁)
        - LT3060: 100 mA, VOUT > 600 mV,  30uVrms, EN, 6-Pin, 3-cap
        - LT3061: 100 mA, VOUT > 600 mV,  30uVrms, EN, 6-Pin, 3-cap (相比 LT3060, 带有输出自动放电)
        - LT3062: 200 mA, VOUT > 600 mV,  30uVrms, EN, 6-Pin, 3-cap
        - LT3063: 200 mA, VOUT > 600 mV,  30uVrms, EN, 6-Pin, 3-cap (相比 LT3062, 带有输出自动放电)
        - LT3082: 200 mA, VOUT >   0 mV,  20uVrms,   , 4-Pin, 2-cap (单个电阻器设置输出电压)
        - LT3035: 300 mA, VOUT > 400 mV, 150uVrms,   , 8-Pin, 4-cap
    - 最终选择 LT3063 (200 mA) 作为我们的 LDO
    - 在 [here](https://www.bocangku.cn/component/detail/438953766558939673) 下载 Altium 格式元件库，


### 1.3 LT3603 (200 mA) 模块设计

依据 LT3603 的 Datasheet 来设计其外围电路：在使用 0201 电容的情况下，力求获得最佳的噪声和瞬态性能：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-20-18-43-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>

- 0201 MLCC (贴片陶瓷电容) 的容值范围在 0.1 pF ~ 4.7 uF 之间
- LT3603 一共用到四处电容 (IN/REF/OUT/FF) 和两个电阻，其中 C_FF 是 feedforward cap 可以有效降低输出噪声
- cap @ IN: 越大越好 (stability), 手册推荐 C_IN = 1 uF + L/20cm x 1 uF, 其中 L 为电源到 LDO 输入端走线长度，我们不妨选用 **C_IN = 4.7 uF**
- cap @ OUT: 越大越好 (stability, transient-response), 手册推荐大于 3.3 uF, 我们使用 **C_OUT = 10 uF = 22 nF + 2 x 4.7 uF**
- cap @ REF: 越大越好 (noise, soft-start), 手册推荐 10 nF, 我们选用 **C_REF = 22 nF**
- cap @ FF: 越大越好 (noise, transient-response)，右图看出 I_FB = 5 uA 时 10 nF 已经足够，我们一开始打算使用较小的电阻 R2/R1 = 10k/12k (I_FB = 60 uA)，不过后来想了下还是算了，改成稍微大些的阻值吧。取 **R2/R1 = 51k/60.4k** (对应 1.107 V), 由图二计算出 C_FF > 10 nF，不妨取 **C_FF = 22 nF**
    1. <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-20-18-57-04_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>
    2. <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-20-19-01-16_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>



PCB 设计：
- **Solid Region 和 Fill 区域不具有电气连接特性，过不了 DRC，只能用多边形 Polygon 来铺铜**
- VCC/GND 铺铜时不整片覆盖 SMD PAD，是因为规则 Rules 对应网络的连接方式设置不对 (Rules > Plane > Polygon Connect Style)，然后铺铜的默认参数值在 Preferences > PCB Editor > Defaults 里面改
- 使用 Polygon 铺铜来连接 SMD PAD 时，注意：
    - 1. 勾选 Pour Over All Same Net Objects
    - 2. Polygon 框范围需包含 SMD PAD 中心点，否则认为是未连接到 PAD (尽管铺出来的铜实际是连了的)，不能过 DRC
    - 3. Pour 具有优先级，在 `T + G + M` 里改
- 铺铜区域不透明度在 `L` (View Configuration) 里改
- `T + H + A` 批量添加过孔时遇到 "unable to locate any suitable locations on net" 的问题，后面尝试时发现是第二层 GND 的铺铜给第一、第三层隔开了导致过孔创建失败 (神经得很)
- 模块复用：
    - 先画好一个，然后 `D + M + T` 创建 Room
    - 给其它模块也创建 Room
    - 选中已经画好的模块，右下角 Panels > PCB List
    - 左上角第一个改为 Edit 模式，第二个 Selected Objects，第三个 Component
    - 复制 Channel Offset 一列，Ctrl + S 保存一下
    - 框选待命模块 (没有画好的)，在 PCB List 中粘贴刚刚复制的 Channel Offset，**然后 Ctrl + S 保存**
    - 重复上一步，直到所有待命模块都粘贴并保存了 Channel Offset
    - 框选画好的模块，快捷键 `D + M + C`，先点击画好的 Room，再点击待命 Room
- 我们这里遇到一个问题是：(调整复制选项后) 走线过孔和铺铜可以正常复制，但是元器件布局不能正常复制过来，猜测是 "通道号对应" 的问题？



效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-22-15-49-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>



### 1.4 LT3045/LT3085 (500 mA)

看了一下各路电源电流消耗情况，发现 LT3603 (200 mA) 其实不太够。为了保证足够带载能力，我们还是全部改用 500 mA LDO 芯片。综合看下来 LT3085 是性能不错，但是发现立创没货，有点尴尬。最后还是选了 LT3045, 这是一个 ultra-low-noise 的芯片，倒也挺好。

模块效果大致如下：



### 1.5 PCB 设计

参考杨师姐今年的测试板，设置 layer stack 如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-23-16-43-50_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>

(最好不要设置 Blind 盲孔，一般都是 Thru 通孔)

设计：
- 修改 GND/PWR 层的属性 Plane/Signal 会删除所有涉及到的 primitives, 包括过孔！！
- GND/PWR 层内缩: Rules > Manufacturing > Board Outline Clearance, 选择 Layer 进行设置
    - TOP: 内缩 60mil
    - GND: 内缩 40mil
    - PWR: 内缩 (40 + 20*H) mil, 其中 H 为 GND/PWR 层间厚度；一般此层间厚度 12.8 mil (0.6mm 四层板)，20H 太大了，推荐内缩 100 mil
    - ALL: 内缩 60mil
- 双击 Plane 设置 Net
- 画好的一个模块效果如下：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-23-18-06-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>
- 然后进行多个模块复制：手动放置丝印来进行元器件布局，再把走线/过孔/铺铜之类的复制过来
- 复制走线时使用 Edit > Paste Special
- 先弄一个模块看看是否能正常复制过来：可以的，DRC 没问题 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-23-18-37-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>
- 移动模块时，由于 Top Overlay 层上的 Rectangle 不会被选中，需要框选并移动两次，非常麻烦，解决方法是：把丝印的 Rectangle 换成走线
- 验证成功后，进行大规模布局与复制，**记得布局前先 Align to Grid**
- VDD_x 铺铜前，记得 `T + G + M` 设置优先级，`T + G + A` 可以全部重铺
- 四路模块成功，效果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-23-20-58-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>
- 我们将走线整体复制到了临时 PCB 文件暂存，复制回来时发现会导致 1-4 层的 Layer 变成 1-5 层，多了一个 GND (Signal)，这是为何？
- **选中一条走线后按 `Tap` 可以快速选中邻近走线或焊盘**
- **在 Rules > Clearance 修改铺铜间距时 (Polygon)，记得提高此条 priority 否则无效**
    - 我们设置为 20mil 时，可以正常保持间距 20mil，但是设置为 8mil 或更低时，间距仍保持 10mil，这是为什么？
    - 检查发现是 Rules > Electrical > Creepage distance 中勾选了 "Apply to Polygon" 导致的，取消勾选即可
- 最终得到 15 路电源效果如下：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-24-20-41-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>
- 注意原理图中设置 net 颜色时，其 PCB 上的颜色也会同步 (快捷键 `F5` 切换显示，View > Set Net Colors 恢复默认)
- `T + M` 清除当前 DRC 报错标识
- 常规框选是无法选中 Designator 丝印的，这时 `Ctrl + 框选` 即可选中
- 在同网络上的多个过孔之间走线时，过孔会被自动删除，关闭此功能：Preferences > PCB Edit > Auto Remove Loop
- 在原理图更换器件的 Design Item ID 同时保持 comment 等参数不变 (例如电容电阻)：选中器件，打开 Tools > Parameter Manager, 如图勾选，随后修改 lib_name 和 lib_reference 即可 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-27-18-52-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>
- 沿板边沿内缩覆铜：
    - 自动: Design Rules > Manufacturing > Board Outline
    - 手动: 
- `U + M` 进行 BUS 走线 (多根走线同时进行)
- 内缩覆铜：
    - 先在 Mechanical 1 或者 Mechanical 3 绘制好板框外形，并复制一份到 TOP 层
    - 在 Rules 设置好想要内缩的 Clearance Value (内缩完再改回来)
    - 选中 TOP 层的板框：Tools > Outline Selected Objects
- DRC 58 个报错是正常的 (主要是 Board Outline Clearance 方面，已验证过无问题)
- 添加屏蔽孔：选中网络 > Tools > Add Via Shielding
- DRC 61 个报错是正常的 (又多了 3 个报错是在 DC 母座的丝印上)
- 原理图导入更新到 PCB 时，会把 PCB 中的 net class 删了，如何解决？
- 加了通孔、调整板子外形，最后 DRC 有 **66 个错误，已确认都符合要求**，没有问题

### 1.6 导出、交付、焊接

**项目打包：**
- 方法一 (推荐，适合备份)：右键项目 > Project Packager (可以导出完整项目 + 用到的原理图/PCB 封装库)，注意封装库是完整导出的而不是仅导出了用到的元件封装
- 方法二 (适合备份)：直接复制粘贴除 history 文件夹之外的内容
- 方法三 (适合交付制版)：在方法一的基础上，不勾选封装库，然后手动 Design > Make Integrated Library 并复制到对应路径

**相关文档导出：**
1. 导出 2D PDF (包括原理图、PCB 各层、BOM)：File > Smart PDF
    - PCB 导出设置这里右键选择 Create Final
    - 记得调整 PCB 导出颜色并勾选 Export Bills
    - 这里 PCB 设置导出颜色似乎有些 bug, 需要选择之后点一下 "save as defaults" 菜鸟
2. 导出 3D 视图：
    - 方法一：File > Export > PCB 3D Print 导出 .png
    - 方法二：File > Export > PDF3D (尝试失败，导出来是全空白)
3. 导出用到的元器件封装库
    - 原理图界面 > Design > Make Schematic Library：仅导出用到的元件封装，不会更改原理图中元件的来源 source


**交付制版包含：**
1. Project Packager 打包的 .zip
2. 导出的 3D .png 图片
3. 制版说明文档 (.pdf 或 .docx)


## 2. TRX 仿真记录

### 2.1 TB_RX

**RX 主体部分 (不含 AFE)：**
- interactive.394 (未成功)
    - TB_RX > 1_TB_RX
- interactive.395 (未成功)
- interactive.396 (接近成功)
    - 参数设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-05-18-25-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div> 
    - 如图，LD_LEVEL_dec = 48 的这一点已经接近锁定，甚至已经 deep-lock 锁定了，但是为什么出现脱锁呢？ <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-05-18-33-18_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>
- interactive.397 (初始频率设置过高，未成功)
    - 参数设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-06-23-08-22_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>
- interactive.398 (成功了一半，耗时 1d 0h 54m)
    - 参数设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-07-15-52-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>
    - 阈值为 46 的这一点已经完全进入 deep lock 状态了，但是不知道为什么仍然脱锁 (是 VCO 问题吗？)
- interactive.400
    - 参数设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-08-16-57-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB Design and Measurement.png"/></div>
    - 这里换成了 Spectre X + MX (CX 速度太慢了，每个 step 只有约 8p% 进度)
    - 结果总结：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-20-19-37-49_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
        - (LD_LEVEL_dec, EN_PD_num) = (40/44, 5/8)
        - 除了 (LD_LEVEL_dec, EN_PD_num) = (40, 8) 这一组因为仿真时长不够，没能锁定到 14 GHz 以外，其它的都“锁定到了 14GHz”，但是存在一定脱锁情况
        - 得到
        - 猜测是锁定后 DFE_dec 又降低导致的脱锁，于是尝试固定 DFE_dec. **注意 DFE tap weight 控制码内部存在反相，使用 MN<7:0> 时需输入 (255 - 预设值)**
- interactive.406
    - **设置数据保存为 lvl @ level = 1** 以减小硬盘开销，同时提速仿真
        - allpub 似乎是全保存? save 137 current + 8480 voltage
        - lvl @ level = 1:    save 149 current + 252 voltage
    - TB_RX > 2_TB_RX_manualDFE
    - 用 interactive.400/406 的数据尝试寻找失锁原因：
    - interactive.406: 脱锁曲线情况总览 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-21-23-45-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - interactive.400 未脱锁时 (0.9us ~ 1.17us @ 44/8) 眼图情况：summer 眼图稍差一些 (似乎是有一处误码)，但是 slicer 眼图又很好 (前仿，比较器速度快)，整体应当是没什么问题的，为什么会出现脱锁呢？ <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-00-44-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - interactive.406 未达到 14G 的这条曲线可以看出，PD/FD 和 CP 相关的控制 (开关、电流大小等) 都没有问题：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-00-58-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 从 interactive.406 达到 14G 但脱锁的这条曲线来看，似乎确实有点像是 CP 电流过小导致的 (LPF_rst 存在漏电，需补偿这部分)；另外，从 f_VCO > PD > CP > LPF > f_VCO 的这条反馈路径存在较大延时，可能也是脱锁的影响因素之一 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-01-07-09_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 猜测是 PD/CP 这边出的问题，也许是 deep_lock 之后电流过小导致的 (毕竟 VCO 抖动挺大，需要较大的 CP 电流才能跟上)？于是在下一次仿真时使用较大的 CP 电流试试
- interactive.411
    - calibre of AFE + SH
    - 保存 lvl @ level = 1 (仅保存 exp. + top 层数据, level = 0 是仅保存 exp.)
    - 对 PD/FD 输出信号加了 RC 滤波器以查看不同时间下的输出情况
    - D_RC2_dec = 17 -> 11
    - EN_PD_num = 8 -> 14
    - (D_DFE_EN, D_DFE_MNB_dec) = {(1, xxx), (0, 10)} (一个开启自动，一个手动给 20)
    - LD_LEVEL_dec = 43 -> 44
    - **仿真时 DINP_act/DINN_act 信号根本不正常 (DIN_unideal 正常)，发现是师兄给的原 TB of AFE 这边仿真时 S/H 模块的电源/地给反了，S/H 模块根本就没能正常作为负载。于是无奈重新仿一下 AFE 带负载的情况** <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-04-13-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.414
    - calibre pf AFE + S/H
    - AFE 输出情况与 interactive.417 类似
- interactive.417
    - 全前仿
    - Testbench 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-16-26-09_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真设置：
    - 全前仿，AFE 波形情况如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-16-24-07_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 图中可以看出，是 CTLE_OUT 的 dc value 偏高，使后级 Buffer 输出偏低，进一步使 S2D 输出 P/N 的 dc value 不等，最终导致差分输出严重偏移
    - 和 AFE_SE_TOP_TB 中的波形作对比，进一步寻找原因：
        - TB_AFE (全前仿): <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-16-41-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
        - TB_RX (全前仿): <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-16-55-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
        - 对比可以发现，是 CTLE_IN 的 dc value 偏置导致的问题。我们的 VDD 模块具有一个上电过程，与 TB_AFE 中的不同，而 CTLE_IN 这个节点的 tau = RC = 944 ns, 需要约 3 us 才能从初始直流点达到目标 dc value. 
        - 为解决这个问题，我们人工给 CTLE_IN 节点施加一个初始 dc value，使其在仿真开始时就处于正确的 VDD/2 状态 (注意 VB_bias 和 DIN_unideal 节点也需要给初始值，否则 VB_bias 上升会使 CTLE_IN 又上升一次)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-17-11-44_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
        - **将 VDD_withWhiteNoise 换为普通 DC + 0.1 Ohm 时，仿真速度得到了极大的提升 (估计速度约为原来的 2 ~ 3 倍？)**
        - 尝试了半天各种设置初始值，效果都不太行，估计是 CTLE 内部还有些容性节点与输入有关，各种充放电
        - 发现我们的其它所有节点初始值都为 0，又查找原因，发现是之前在仿真中勾选了 skip dc 选项，遂取消勾选以
- interactive.432: 关闭 dc skip (正常 dc), 关闭 initial
- interactive.434: 关闭 dc skip (正常 dc), 开启 initial
- interactive.435: 开启 dc skip, 关闭 initial, 开关持续赋值 (利用 deepprobe 接到里面)
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-19-51-16_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 出现 +offset 时，应当适当降低 VB_bias, 且大致满足 1:1
- interactive.440: 最终我们开启 dc skip, 关闭 initial, 开关持续赋值 (利用 deepprobe 接到里面)，终于能正常进行仿真了。
- interactive.441: CN_INT_dec = 49 -> 51 (本来 49 应该是初始 14.1 GHz 掉到 13.8 GHz, 但 interactive.400 里不知道为啥变成 13.8 GHz 掉到 13.5 GHz, 遂提升频率额外仿一次)
- interactive.442: 
    - 设置 lvl @ level = 1
    - FD_SLOW_dec = 40
    - 刚刚 440/441 的 AFE 为前仿，原 variable 设置不适用，这里用后仿 AFE 重新跑一下
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-23-19-48-00_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.445: 
    - 调整 Q_AFE_DAC2_dec 以降低 AFE 输出 offset，在 AFE 后仿的情况下 dec = 118 最合适 (几乎无 offset)
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-23-19-23-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.446: 
    - 调整 EN_PD_num = (14, 10, 8, 6) 和 D_DFE_MNB_dec = (0, 20) 参数，看看锁定后效果有何区别
    - 为探究 deep_lock 之后为什么脱锁，我们降低 LPF 中 C1/C2 的值：
        - D_LPF_C1_dec = (10-1) -> (8-1), 20 pF -> 16 pF
        - D_LPF_C2_dec = (4-1)  -> (3-1), 1.00 pF -> 0.75 pF
    - 已取消
- interactive.452:
    - **为验证是否是 deep_lock 的锅，我们在原理图中将 CP 的 deep_lock 输入信号直接置地，然后用与 interactive.442 完全相同的条件来跑**
    - 仿真开始运行之后，我们已将原理图中 deep_lock 信号改回，不会影响后续其它仿真
    - 结果如图 (成功锁定)：
- interactive.455:
    - 452 是用的 442 仿真条件，AFE 输出仍具有一定 offset，我们大致按 446 的仿真条件，优化参数后 (降低 AFE 输出 offset 并提高理想数据输入摆幅) 再跑一个作为保险 (deep_lock 输入信号直接置地)
    - 3 points:
        - **deep_lock 输入信号直接置地**
        - FD_SLOW_dec/FAST_dec = 36/12
        - EN_PD_num = (14, 10, 6)
        - (D_DFE_MN_EN, D_DFE_MNB_dec) = (1, 20)
        - D_LPF_C1_dec = (10-1) 不变
        - D_LPF_C2_dec = (4-1) 不变
    - 失败，甚至没能锁到 14 GHz (这是为什么？)，如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-25-16-17-05_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.456:
    - 将 deep_lock 的连接关系还原，然后再跑 4 points:
        - deep_lock 正常连接
        - FD_SLOW_dec/FAST_dec = 36/12
        - EN_PD_num = (14, 10, 8, 6)
        - (D_DFE_MN_EN, D_DFE_MNB_dec) = (1, 20)
        - D_LPF_C1_dec = (10-1) -> (8-1), 20 pF -> 16 pF
        - D_LPF_C2_dec = (4-1)  -> (3-1), 1.00 pF -> 0.75 pF
    - 根据 interactive.455 的结果，此仿真已取消



### 2.2 TB_AFE

**AFE 仿真：**
- AFE_SE_TOP_TB > TOP_tb: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-20-21-19-20_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.7 (AFE 完整后仿, 成功) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-21-22-48-07_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- **仿真时 DINP_act/DINN_act 信号根本不正常 (DIN_unideal 正常)，发现是师兄给的原 TB of AFE 这边仿真时 S/H 模块的电源/地给反了，S/H 模块根本就没能正常作为负载。于是无奈重新仿一下 AFE 带负载的情况**
- interactive.8 (calibre of AFE + S/H)
    - 不对啊，更正 S/H 负载后，我这设置也没变，AFE 输出是正常的啊，如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-16-08-13_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-16-00-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-22-15-56-50_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.9 (calibre of AFE, schematic of S/H)
    - 这里也是正常的




### 2.3 TB_DFE
- interactive.352
    - calibre of SSS w/o extra slicers
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-14-02-55-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-14-02-55-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真结果：约 (56m 28.5s)/point，眼图如下
- interactive.353
    - 全前仿 w/o extra slicers
- interactive.355
    - 全前仿 w/i 2 extra slicers (for each summer)
- interactive.356
    - 全后仿 w/i 2 extra slicers (for each summer)
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-14-03-12-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.357
    - w/i 2 extra slicers (for each summer)
    - summer 前仿，其它模块后仿
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-14-23-21-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.358
    - w/o extra slicers
    - summer 前仿，其它模块后仿
- interactive.359
    - w/i **4** extra slicers (for each summer)
    - 全后仿
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-16-01-34-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.358 与 interactive.359 对比效果 (64 Gbaud)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-16-01-51-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.375: VDD = 1.0V, no offset, 2^15 bits, RC = 0.3 ~ 2.0
- interactive.377: VDD = 1.1V, no offset, 2^15 bits, RC = 0.3 ~ 2.0
- interactive.379: VDD = 1.1V, +40mV offset, 2^15 bits, RC = 0.6 ~ 1.2
    - 数值结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-23-23-22-58_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.380: VDD = 1.1V, +40mV offset, 2^15 bits, RC = {0.8, 1.0}, **no DFE adaptation**
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-23-23-22-06_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.383:
    - VDD = 1.1V, +40mV offset, **2^13 bits**, RC = {0.8, 1.0}
    - 用于论文 Figure.2 DFE 中的右下角眼图
- interactive.384:
    - VDD = 1.1V, +40mV offset, **2^13 bits**, RC = {0.8, 1.0}, no DFE adaptation
    - 用于论文 Figure.2 DFE 中的左下角眼图
- interactive.385:
    - VDD = 1.1V, no offset, **2^13 bits**, RC = {0.8, 1.0}, w/o extra slicers (summer 前仿，其它后仿)
- interactive.386:
    - VDD = 1.1V, no offset, **2^13 bits**, RC = {0.8, 1.0}, w/i 4 extra slicers (全后仿)



### 2.4 TB_TX_TOP_56Gbaud
- interactive.3: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-23-19-50-51_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>



``` bash
VT("/I245/I0/POS_DTH<7:0>")
VT("/I245/I0/NEG_DTH<7:0>")
VT("/I245/I0/DFE_TAP1<7:0>")

  VT("/I245/I0/POS_DTH<7>")*2**7
+ VT("/I245/I0/POS_DTH<6>")*2**6
+ VT("/I245/I0/POS_DTH<5>")*2**5
+ VT("/I245/I0/POS_DTH<4>")*2**4
+ VT("/I245/I0/POS_DTH<3>")*2**3
+ VT("/I245/I0/POS_DTH<2>")*2**2
+ VT("/I245/I0/POS_DTH<1>")*2**1
+ VT("/I245/I0/POS_DTH<0>")*2**0

  VT("/I245/I0/NEG_DTH<7>")*2**7
+ VT("/I245/I0/NEG_DTH<6>")*2**6
+ VT("/I245/I0/NEG_DTH<5>")*2**5
+ VT("/I245/I0/NEG_DTH<4>")*2**4
+ VT("/I245/I0/NEG_DTH<3>")*2**3
+ VT("/I245/I0/NEG_DTH<2>")*2**2
+ VT("/I245/I0/NEG_DTH<1>")*2**1
+ VT("/I245/I0/NEG_DTH<0>")*2**0

  VT("/I245/I0/DFE_TAP1<7>")*2**7
+ VT("/I245/I0/DFE_TAP1<6>")*2**6
+ VT("/I245/I0/DFE_TAP1<5>")*2**5
+ VT("/I245/I0/DFE_TAP1<4>")*2**4
+ VT("/I245/I0/DFE_TAP1<3>")*2**3
+ VT("/I245/I0/DFE_TAP1<2>")*2**2
+ VT("/I245/I0/DFE_TAP1<1>")*2**1
+ VT("/I245/I0/DFE_TAP1<0>")*2**0


channel 衰减：
- 0.35dB @ DC
- 2.14dB @ 28G
- 2.34dB @ 32G

RC 衰减：
%  1 % RC = 0.2 ( 2.0 dB @ 32GHz)
%  1 % RC = 0.3 ( 3.5 dB @ 32GHz)
%  2 % RC = 0.4 ( 4.9 dB @ 32GHz)
%  3 % RC = 0.5 ( 6.3 dB @ 32GHz)
%  4 % RC = 0.6 ( 7.5 dB @ 32GHz)
%  5 % RC = 0.7 ( 8.6 dB @ 32GHz)
%  6 % RC = 0.8 ( 9.6 dB @ 32GHz)
%  x % RC = 0.9 (10.5 dB @ 32GHz)
%  7 % RC = 1.0 (11.4 dB @ 32GHz)
%  8 % RC = 1.2 (12.9 dB @ 32GHz)
%  9 % RC = 1.4 (14.2 dB @ 32GHz)
% 10 % RC = 1.6 (15.3 dB @ 32GHz)
% 11 % RC = 1.8 (16.3 dB @ 32GHz)
% 12 % RC = 2.0 (17.2 dB @ 32GHz)

"IL =  3.5 dB"
"IL =  4.9 dB"
"IL =  6.3 dB"
"IL =  7.5 dB"
"IL =  8.6 dB"
"IL =  9.6 dB"
"IL = 11.4 dB"
"IL = 12.9 dB"
"IL = 14.2 dB"
"IL = 15.3 dB"
"IL = 16.3 dB"
"IL = 17.2 dB"

clip((VT("/I245/I0/SHP<0>") - VT("/I245/I0/SHN<0>")) time_clip time_end)
eyeDiagram((VT("/I245/I0/SHP<0>") - VT("/I245/I0/SHN<0>")) time_clip time_end (2 * CK_period) ?intensityPlot t ?autoCenter nil)
leafValue( vtime('tran "/I245/I0/SAM_H<0>") "LD_LEVEL_dec" 44 "EN_PD_num" 8 ) - leafValue( vtime('tran "/I245/I0/SAMB_H<0>") "LD_LEVEL_dec" 44 "EN_PD_num" 8 )


eyeWidthAtXY(eye_SH4 (VAR("SH2_CK_tdelay") - (2 * CK_period)) eye_Y ?output "total")
```










## 3. 论文仿真数据准备

### 3.1 频率锁定过程示意图

不同初始频率锁定到 14 GHz:
- MyLib_tsmcN28_BK_20260427 > TB_CDR_PD_FD > 9_TB_PAM3_PFDLKtest
- interactive.382
    - testbench 原理图：略
    - config 设置：全前仿 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-09-18-03-30_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真器：Spectre FX + AX 
    - 仿真设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-09-18-17-31_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真结果：
        - 13.0G 这一组因为 FD_SLOW_dec 设置过高导致失锁，改一下就正常了，我们又额外仿了 interactive.384 作为补充
        - 382/384 仿真结果汇总：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-10-16-50-35_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>


随数据速率变化锁定到目标频率：
- MyLib_tsmcN28_BK_20260427 > TB_CDR_PD_FD > 13_TB_BiD-FD_example
- interactive.391
    - testbench 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-11-02-20-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - config 设置：全前仿 
    - 仿真器：Spectre FX + AX @ 32-thread
    - 仿真设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-11-02-08-52_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真结果：每 point 约 (4h 34m 40s)，结果如图 
- interactive.392: 两条曲线有一条达到预期
- interactive.399: time_end = 6us, (10h 4m 29s)/point 



### 3.2 FD 增益图

使用 VA_CDR_FD_BiDirectional_2XOS_withGainControl (SLOW = slow x 16, FAST = fast x 11 @ SLOW = 0)：
- MyLib_tsmcN28_BK_20260427 > TB_CDR_PD_FD > 13_TB_BiD-FD_example
- interactive.193
    - 仿真器：Spectre X + MX @ 16-thread
    - TB 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-11-02-22-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 使用的 BiD-FD 内部增益配置情况：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-11-02-31-32_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真设置：PRBS10 @ 2^12 bit periods <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-11-19-07-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真结果：37 points, 每 point 约 (36m 17.1s)，结果如图
- interactive.194
    - 评论：没有问题，就用这组数据作为我们的曲线 @ PRBS10
    - 仿真器：Spectre FX + AX @ 8-thread
    - TB 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-11-19-04-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真设置：PRBS10 @ 2^12 bit periods <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-11-19-04-44_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真结果：101 points, 每 point 约 (14m  21.4s)，结果如图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-11-19-02-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.195
    - 评论：没有问题，作为 PRBS10 的细节图
    - 仿真器：Spectre FX + AX @ 8-thread
    - 仿真设置：PRBS10 @ 2^12 bit periods
    - 仿真结果：82 points, 每 point 约 (4m 28.1s)，结果如图 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-11-22-40-38_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.196
    - 评论：作为 PRBS07 的细节图
    - 仿真器：Spectre FX + AX @ 8-thread
    - 仿真设置：PRBS07 @ 2^10 bit periods
    - 仿真结果：101 points, 每 point 约 ，结果如图 


总结一下：
- interactive.194: 主图中的 PRBS10 (DM, Slow, Fast) 三条
- interactive.195: 细节图中的 PRBS10 (DM)
- interactive.196: 细节图中的 PRBS07 (DM)
- interactive.197: 主图中的 PRBS07 (DM)
- interactive.198: 主图中的 PRBS10 w/o coupling logic (DM)
- interactive.199: 细节图中的 PRBS10 w/o coupling logic (DM)
- xxx: 主图中的 prior A-PFD [1] [2] 两条

感觉这里的数据有点太多了，我们不妨：
左图共 4 条：PRBS10 (DM, Slow, Fast), PRBS10 w/o coupling logic (DM)
右图共 4 条：PRBS10 (DM), PRBS07 (DM), prior A-PFD [1] [2]


### 3.3 Summer w/i/o extra slicers

MyLib_tsmcN28 > TB_DFE > TB_SSS (注意仿真速率为 **64 Gbaud**)
- interactive.352
    - calibre of SSS w/o extra slicers
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-14-02-55-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-14-02-55-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真结果：约 (56m 28.5s)/point，眼图如下
- interactive.353
    - 全前仿 w/o extra slicers
- interactive.355
    - 全前仿 w/i 2 extra slicers (for each summer)
- interactive.356
    - 全后仿 w/i 2 extra slicers (for each summer)
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-14-03-12-43_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.357
    - w/i 2 extra slicers (for each summer)
    - summer 前仿，其它模块后仿
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-14-23-21-23_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.358
    - w/o extra slicers
    - summer 前仿，其它模块后仿
- interactive.359
    - w/i **4** extra slicers (for each summer)
    - 全后仿
    - config 设置：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-16-01-34-47_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.358 与 interactive.359 对比效果 (64 Gbaud)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-16-01-51-01_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>



### 3.4 Adaptation 过程示意图 (TB_DFE)

- 短时间内的 adaptation 效果用：**3.3 Summer w/i/o extra slicers** 一节中的 interactive.358，长约 130ns (不带 sub-sampling)
- 长时间的的 adaptation 效果用：MyLib_tsmcN28 > TB_RX > interactive.400 > (LD_LEVEL_dec, EN_PD_num) = (40, 8)，长约 1200ns (不带 sub-sampling)
- 不同衰减情况下的 adaptation 效果用：MyLib_tsmcN28 > TB_DFE > TB_SSS
    - interactive.364 (成功, 已 lock) **(记得做时域 x4 处理)**
    - interactive.369 (成功, 已 lock) **(记得做时域 x4 处理)**
    - interactive.375 (四倍 time_end) (成功, 已 lock)
- 带有 offset 的 adaptation 效果用：**3.6 Offset 下 w/i/o Bilateral Ada. 效果**

不同 RC_timeconstant 时的 Channel Loss 情况总结在这里：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-20-18-41-35_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>


``` bash
RC_tc (相对于 56 Gbaud)   28 GHz  32 GHz
1	nom	        200m    -1.458	-1.813
2	nom	        300m    -2.767	-3.348
3	nom	        400m    -4.11	-4.861
4	nom	        500m    -5.385	-6.253
5	nom	        600m    -6.56	-7.509
6	nom	        700m    -7.632	-8.637
7	nom	        800m    -8.608	-9.655
8	nom	        900m    -9.501	-10.58
9	nom	        1       -10.32	-11.42
10	nom	        1.1     -11.08	-12.19
11	nom	        1.2     -11.78	-12.91
12	nom	        1.3     -12.43	-13.57
13	nom	        1.4     -13.04	-14.18
14	nom	        1.5     -13.61	-14.76
15	nom	        1.6     -14.14	-15.31
16	nom	        1.7     -14.65	-15.82
17	nom	        1.8     -15.13	-16.3
18	nom	        1.9     -15.59	-16.76
19	nom	        2       -16.02	-17.2

计算 RC 对应的 IL, 可用公式：
H(x) = 1/(1j*pi*x + 1);
IL(x) = -20*log10(abs(H(x)));
其中 x = RC_timeconstant_UI \in (0, +∞)
```




### 3.5 S/H: Proposed and Conventional

MyLib_tsmcN28 > TB_DFE > TB_SSS (注意仿真速率为 **64 Gbaud**)
- interactive.367 (成功)

MyLib_tsmcN28 > TB_SH
- interactive.9: 找出不同 SH 的最佳采样点 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-23-05-43-29_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.12: 更正 SH0 时钟输入之后，寻找最佳采样点：
- interactive.20: 后仿 S/H 不带负载的效果，通道衰减 + 7.5 dB RC 衰减 (共 9.8 dB)
    - 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-24-00-31-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.21: 后仿 S/H 带后仿 Summer 下的效果，通道衰减 + 7.5 dB RC 衰减 (共 9.8 dB)
    - 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-24-00-28-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.23: 后仿 S/H + Summer + 2 Slicers 的效果，通道衰减 + 7.5 dB RC 衰减 (共 9.8 dB)
    - 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-24-01-01-55_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- 通道衰减情况如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-24-01-16-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 0.35dB @ DC
    - 2.14dB @ 28G
    - 2.34dB @ 32G
- interactive.28 ~ 29: 换回原来的数据输入方式 (RC = 0.8, 9.7dB 衰减)，后仿 S/H + Summer + 2 Slicers 
    - 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-24-18-19-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - SH2 + SUM2 如图 (和之前仿真结果是一致的)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-24-01-57-14_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.30: 在 interactive.28 ~ 29 的基础上，提高衰减 (RC = 0.9 ~ 1.2) 仿真 SH2 眼图效果

论文选图：在 interactive.28 ~ 29 条件下仿真 SH 眼图，然后数据输入眼用 interactive.23 的

- interactive.38: 
    - 先根据之前数据拟合最佳 sampling instant, 然后在不同 RC 衰减下仿真对比 SH with/without GAL 的眼图效果 (粗扫)
    - 设置如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-03-00-13-48_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.39: (细扫) 在不同 RC 衰减下仿真对比 SH with/without GAL 的眼图效果
    - RC = 0:0.05:1.0
- RC_timeConstant_UI 与 IL (dB) 换算关系 (事失固定 data rate): <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-03-03-52-24_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.jpg"/></div>



### 3.6 Offset 下 w/i/o Bilateral Ada. 效果 (Summer 眼图 + Ada 过程)

带 Bilateral Adaptation 的效果：
MyLib_tsmcN28 > TB_DFE > TB_SSS_offset (注意仿真速率为 **64 Gbaud**)
- interactive.368 (全后仿) (失败，错误用成 SSS_v5 了)
- interactive.371 (Summer 前仿，其它模块后仿) (成功, 已 lock)
- interactive.374 (Summer 前仿，其它模块后仿) (用作 bil. adaptation 过程示例，time_end 为原来的四倍) (耗时 5h 10m 6s) (成功, 已 lock)
- interactive.377

不带 Adaptation 的效果 (直接给固定值)：
- interactive.372 (Summer 前仿，其它模块后仿) (成功是成功了，但是对比效果不明显)
- interactive.373 (Summer 前仿，其它模块后仿) (成功, 已 lock) 



### 3.7 TB_CDR_PD_FD 大范围频率锁定仿真

**下面这几个都是还没加 coupling logic 时的仿真：**
TB_CDR_PD_FD > 9_TB_PAM3_PFDLKtest
- interactive.401/402/403
    - 从低频 {4, 7, 10} GHz 锁到 14 GHz
    - SLOW/FAST = 24/16
    - time_end = 2^17 bit periods
    - 如图，仿真时长有些不够：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-29-18-04-02_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.407
    - 从低频 {4, 6, 8, 10} GHz 锁到 14 GHz
    - SLOW/FAST = 24/16
    - time_end = 2^18 bit periods (原先 2^17 不够些)
    - 错用成了 Spectre X, 已取消
- interactive.409
    - 从 14 GHz 锁到低频 8 GHz
    - SLOW/FAST = 16/{16, 24, 32, 40}
    - 错用成了 Spectre X, 已取消



在 interactive.401/402/403 仿真时又遇到了 FATAL (SPECTRE-18): Segmentation fault. 的问题，尝试了：
- (失败) Create Test Copy 进行仿真
- (成功) 一次仅跑 1-point @ Spectre FX, 同时跑多个 interactive；但是除了第一个 interactive 可以边跑边看波形，其它的都是得全部跑完才会有 (怀疑是 Segmentation fault 导致的)
- (失败) 另外新建一个端口进行 Spectre FX 多 point 仿真
- (成功) 在新建的端口上使用 Spectre X 进行仿真
- (失败) 把所有端口删了后，新建一个端口进行仿真
- **(成功)** 把所有端口删了后，新建一个端口的基础上，将原 cell 复制一份出来进行仿真 (TB_CDR_PD_FD_copy_new1 > interactive.415)


``` bash
Starting Circuit DB Creation ...
  *********************************************************
  ** TMI Share Library                   Version is V102031.100001 (Apr 10 2019 18:47:24)
  ** Built OS                            Version is Red Hat Enterprise Linux AS release 4 (Nahant Update 6)
  ** Built compiler                      Version is gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)
  *********************************************************

Warning from spectre.
    WARNING: Node or net Vin_CM is connected to more than one grounded voltage sources with different values: V12 V0 V11 
Internal error found in spectre.
    FATAL (SPECTRE-18): Segmentation fault. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem. Encountered a critical error during simulation. Run `mmsimpack' (see mmsimpack -h for detailed usage information) to package the netlist and log files as a compressed tar file. Then, contact your Cadence representative or submit a service request via Cadence Online Support, including the tar file and any other information that could help identify the problem.

Version 21.1.0.785.isr20 64bit -- 6 Jul 2023
****ASSERTION STACK****
        0x6cc72bc
        ......
        ......
        0x816a11
****LIBRARIES****
        spectre/bin/64bit/spectre [0x400000]
        /lib64/libpthread.so.0 [0x2ada24c01000]
        giganta/lib/64bit/libgiganta_sh.so [0x2ada25d60000]
```



**下面是使用了 FDLogic_v3 的仿真 (202602_CDR__FDLogic_BiD_div4_gainControl_v3_couplingLogic, 带有 CL)：**
- interactive.411
    - 从低频 4 GHz 锁到 16 GHz
    - SLOW/FAST = {16, 24, 32, 40}/16
    - 错用成了 Spectre X, 已取消
- interactive.412
    - 从高频 16 GHz 锁到低频 8 GHz
    - SLOW/FAST = 16/{16, 24, 32, 40}
    - 错用成了 Spectre X, 已取消
- interactive.413
    - 从低频 4 GHz 锁到 16 GHz
    - SLOW/FAST = {24, 32, 40}/16
    - 已改为 Spectre FX
- interactive.414
    - 从高频 16 GHz 锁到低频 8 GHz
    - SLOW/FAST = 16/{16, 24, 32, 40}
    - 已改为 Spectre FX


下面是解决 Segmentation fault 错误之后的仿真 (**TB_CDR_PD_FD_copy_new1** > 9_TB_PAM3_PFDLKtest)：
- interactive.416
    - FDLogic_v3
    - 从低频 4 GHz 锁到 16 GHz
    - SLOW/FAST = {24, 32}/16
    - time_end = 2^18 bit periods
    - Spectre FX + AX @ 8-thread
    - 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-30-10-52-08_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
        - 一方面即便是 2^18 bit periods 的 time_end 时间也有些不够，另一方面 SLOW/FAST = 32/16 的这一组是直接越过 16GHz 了，锁定失败
- interactive.417
    - FDLogic_v3
    - 从高频 16 GHz 锁到低频 8 GHz
    - SLOW/FAST = 16/{24, 32}
    - time_end = 2^18 bit periods
    - Spectre FX + AX @ 8-thread
    - 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-30-07-50-39_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 频率维持在 16 GHz 完全没有动，经过检查，发现 FAST/SLOW 输出完全正常，是因为 lock detection 一直保持 flag_lock = 1 所以频率才不动。根本原因是初识频率 16 GHz 恰好是数据速率 8 GHz 两倍，offset sampler 识别到的输出完全相同，因此保持了锁定状态。
- interactive.418
    - 之前是 FDLogic_qR_BiD_qR_v1 用了后仿，其它均前仿，这里改为全前仿
    - **FDLogic_v2**
    - 从高频 16 GHz 锁到低频 8 GHz
    - SLOW/FAST = 16/{24, 32}
    - time_end = 2^18 bit periods
    - Spectre FX + AX @ 8-thread
    - 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-30-07-50-55_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 情况同 interactive.417 频率维持在 16 GHz 完全没有动
- interactive.419 (成功, 已锁定)
    - FDLogic_v3
    - 从高频 16 GHz 锁到低频 10 GHz (不能恰好整数倍是 16 GHz)
    - SLOW/FAST = 16/{24, 32}
    - time_end = 2^18 bit periods
    - Spectre FX + AX @ 8-thread
- interactive.420
    - **FDLogic_v2**
    - 从高频 16 GHz 锁到低频 10 GHz (不能恰好整数倍是 16 GHz)
    - SLOW/FAST = 16/{24, 32}
    - time_end = 2^18 bit periods
    - Spectre FX + AX @ 8-thread
- interactive.421 (成功, 已锁定)
    - FDLogic_v3
    - 从低频 4 GHz 锁到 16 GHz
    - SLOW/FAST = {24, 32}/16
    - Icp_fd = 250u -> 400u
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
- interactive.423
    - FDLogic_v3
    - 从低频 4 GHz 锁到 16 GHz
    - SLOW/FAST = {20, 24}/16
    - Icp_fd = 250u (保持不变，与 interactive.416 一致)
    - time_end = **2^19** bit periods (更长)
    - Spectre FX + AX @ 8-thread
- interactive.424 (在 421 基础上)
    - FDLogic_v3
    - 从不同低频 {4G, 6G, 8G, 10G, 12G, 14G} 锁到 16 GHz
    - SLOW/FAST = 20/16
    - Icp_fd = 250u -> 400u
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
- interactive.425 (在 419 基础上)
    - FDLogic_v3
    - 从不同高频 {16G, 14G, 12G, 10G, 8G, 6G} 锁到低频 4G
    - 已取消


下面是使用带 band ctrl VCO 的仿真 (**TB_CDR_PD_FD_copy_new1** > 9_TB_PAM3_PFDLKtest)：
- interactive.428
    - FDLogic_v3
    - 从低频 4 GHz 锁到 16 GHz
    - SLOW/FAST = {20, 24, 26}/16
    - Icp_fd = 250u -> 400u
    - Jc_rms_UI = 1m -> 0.2m
    - (f_BD, alpha_BD) = (0.4G, 0.2)
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
- interactive.431
    - FDLogic_v3
    - 从高频 16 GHz 锁到低频 5.3 GHz (5 GHz 试过无法脱锁)
    - SLOW/FAST = 16/{20, 24, 26}
    - Icp_fd = 250u -> 400u
    - time_end = 2^18 bit periods
    - Jc_rms_UI = 1m -> 0.2m
    - (f_BD, alpha_BD) = (0.4G, 0.2)
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
    - 无法脱锁，已取消
- interactive.434
    - 手动给 EN_FD 加 reset 以实现脱锁
    - FDLogic_v3
    - 从高频 16 GHz 锁到低频 4 GHz
    - SLOW/FAST = 16/{20, 24, 26}
    - Icp_fd = 250u -> 400u
    - time_end = 2^18 bit periods
    - Jc_rms_UI = 1m -> 0.2m
    - (f_BD, alpha_BD) = (0.4G, 0.2)
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
    - 仿真遇到错误自己取消了
- interactive.435
    - FDLogic_v3
    - 加了 0.5us 的 RST_width (此期间 FD 不工作)
    - 从不同低频 {6G, 10G, 14G} 锁到 16 GHz
    - SLOW/FAST = 26/16
    - Icp_fd = 250u -> 400u
    - Jc_rms_UI = 1m -> 0.2m
    - (f_BD, alpha_BD) = (0.4G, 0.2)
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
- interactive.438
    - 手动给 EN_FD 加 MUX 以实现脱锁 (前 0.2us 关闭 FD, 接着 0.5us 开启 FD)
    - FDLogic_v3
    - 从不同高频 {16G, 14G, 10G, 6G} 锁到低频 4 GHz
    - SLOW/FAST = 16/{20, 26}
    - Icp_fd = 250u -> 400u
    - Icp_total = 120u -> 150u
    - Jc_rms_UI = 1m -> 0.1m
    - (f_BD, alpha_BD) = (0.4G, 0.2)
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
    - 仿真设置如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-01-16-41-56_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - TB 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-01-18-50-17_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - FD 增益范围问题，已取消
- **注：观察 interactive.438 终于想起来，16GHz 无法向 4GHz 锁不是 EN_FD 的问题，而是 BiD-FD 增益的问题：在目标频率 (-100%, +100%) 有增益，再高就没有了** <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-01-20-59-53_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- interactive.441
    - 手动给 EN_FD 加 MUX 以实现脱锁 (前 0.2us 关闭 FD, 接着 0.2us 开启 FD)
    - FDLogic_v3
    - 从不同高频 {16G, 14G, 12G, 10G} 锁到低频 9 GHz
    - SLOW/FAST = 16/{20, 26}
    - Icp_fd = 250u -> 400u
    - Icp_total = 120u -> 150u
    - Jc_rms_UI = 1m -> 0.1m
    - (f_BD, alpha_BD) = (0.4G, 0.2)
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
- 2026.09.02 21:00 与导师讨论后，需要一张类似这样的频率捕获示意图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-02-21-10-27_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.jpg"/></div>
- interactive.446
    - Reset 信号：前 0.2us 关闭 FD, 然后交由 flag_LK
    - FDLogic_v3
    - 从初始态 f0 = 6.73214G 到 f1 = {6G, 8G}
    - SLOW/FAST = {20, 26}/16 or 16/{20, 26} 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-02-23-59-15_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - Icp_fd = 400u
    - Icp_total = 150u
    - Jc_rms_UI = 0.1m
    - (f_BD, alpha_BD) = (0.4G, 0.2) -> (0.5G, 0.3)
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
    - 结果如图，没问题 (已导出)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-03-13-01-34_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - 仿真到一半即有可用数据，导出确认后即取消
- interactive.447/449/452
    - Reset 信号：前 0.2us 关闭 FD, 然后交由 flag_LK
    - FDLogic_v3
    - 从 f1 = 8G 到 f2 = {16G, 12G, 7G, 4G}
    - SLOW/FAST = {20, 26}/16 or 16/{20, 26} 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-02-21-32-49_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - Icp_fd = 400u
    - Icp_total = 150u
    - Jc_rms_UI = 0.1m
    - (f_BD, alpha_BD) = (0.4G, 0.2) -> (0.5G, 0.3)
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
- interactive.448/450
    - Reset 信号：前 0.2us 关闭 FD, 然后交由 flag_LK
    - FDLogic_v3
    - 从 f1 = 6G 到 f2 = {16G, 12G, 7G, 4G}
    - SLOW/FAST = {20, 26}/16 or 16/{20, 26} 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-03-04-48-36_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - Icp_fd = 400u
    - Icp_total = 150u
    - Jc_rms_UI = 0.1m
    - (f_BD, alpha_BD) = (0.4G, 0.2) -> (0.5G, 0.3)
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
    - 已取消
- 2026.09.09 17:16 构建了带滞回控制的 verilog VCO band control (频带控制)，仿真结果如图，有了滞回之后 Vctrl 上的电压噪声不会引起频带切换异常：
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-03-17-18-19_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-03-17-16-41_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- **后续的仿真都是使用带滞回控制的 verilog VCO band control (alpha_hyst = 0.3)**
- interactive.463
    - interactive.452 中，from 8 GHz to 4 GHz 恰好是两倍，RST 区间 FD 几乎无输出保持了 8G 导致 flag_LK 恒为高，无法脱锁；这里手动使用 dynamic parameter 来仿真，设置如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-03-17-35-12_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
        - 注意 dynamic parameter 里设置不能出现括号 `()` 或者 `*` 等运算符或者其它 variable
    - Reset 信号：前 0.2us 关闭 FD, 然后交由 flag_LK
    - FDLogic_v3
    - 从 f1 = 8G 到 f2 = {16G, 12G, 7G, 4G}
    - SLOW/FAST = {20, 26}/16 or 16/{20, 26} 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-03-17-22-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - Icp_fd = 400u
    - Icp_total = 150u
    - Jc_rms_UI = 0.1m
    - (f_BD, alpha_BD) = (0.4G, 0.2) -> (0.5G, 0.3)
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
- interactive.465
    - Reset 信号：前 0.2us 关闭 FD, 然后交由 flag_LK
    - FDLogic_v3
    - 从 f1 = 8G 到 f2 = {16G, 12G, 7G} **(不包括 4G)**
    - SLOW/FAST = {20, 26}/16 or 16/{20, 26} 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-03-17-22-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - Icp_fd = 400u
    - Icp_total = 150u
    - Jc_rms_UI = 0.1m
    - (f_BD, alpha_BD) = (0.4G, 0.2) -> (0.5G, 0.3)
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread
    - 463/465 结果如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-04-16-37-40_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
- **下面是使用 VA_VCO_whiteCycleJitter_8Phase_unlimitedFreq_bandCtrl_v3_PS_20260903_hysteresis 的仿真**，前面使用了 VA_VCO_v2 时，初始频率存在 -f_BD/2 = -0.25 GHz 的偏差，作图时需更正
- interactive.466
    - Reset 信号：前 0.2us 关闭 FD, 然后交由 flag_LK
    - FDLogic_v3
    - 从 f1 = 6G 到 f2 = {16G, 12G, 7G, 4G}
    - SLOW/FAST = {20, 26}/16 or 16/{20, 26} 如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-03-17-22-46_202602_tsmcN28_CDR_PAM3_56GTs_quarterRate (5) PCB, Measurement and Paper Writing.png"/></div>
    - Icp_fd = 400u
    - Icp_total = 150u
    - Jc_rms_UI = 0.1m
    - (f_BD, alpha_BD) = (0.4G, 0.2) -> (0.5G, 0.3)
    - time_end = **1.5*2^18** bit periods
    - Spectre FX + AX @ 8-thread