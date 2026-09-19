# Altium Designer 23 (AD23) 安装与使用教程


> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 17:53 on 2025-06-25 in Lincang.
> dingyi233@mails.ucas.ac.cn

## 1. AD23 破解汉化版安装教程

1. 主要参考这篇文章：[知乎 > Altium Designer 23 安装教程](https://zhuanlan.zhihu.com/p/696629320)，我们在其分享的 AD 各版本中选择 AD23，下载并安装
2. 参考这个视频 [Bilibili > Altium Designer 基础培训 (一) 软件介绍和常用参数设置](https://www.bilibili.com/video/BV1L7411R7AM) 调整软件基本设置 (24:30 ~ 38:00)
3. 一些 AD 实用技巧：[知乎 > 相见恨晚的AltiumDesigner使用技巧第二弹](https://zhuanlan.zhihu.com/p/399819184)
4. 参考这个视频 [Bilibili > 【AD 库资源分享】 带你认识 Altium Designer 的原理图库、PCB 封装库和集成库](https://www.bilibili.com/video/BV1eo4y1L7KH) 导入常用元器件库
5. 参考官网教程完成一次完整设计：[Altium > Altium Designer 文档](https://www.altium.com/cn/documentation/altium-designer/tutorial)
6. **<span style='color:red'> 从立创导入元件封装到 AD：https://www.bilibili.com/video/BV14jKP6zEPb </span>**
    - https://github.com/ref42/npnp
    - https://github.com/ref42/seex
    - https://www.ref42.com/utils/npnp/






## 2. 全流程操作教材

- 参考官网教程完成一次完整设计：[Altium > Altium Designer 文档](https://www.altium.com/cn/documentation/altium-designer/tutorial)
- 我们用的是破解版，在元件/封装这里没法直接下载 AD 官网提供的，这里就用到了开头提到的 “常用元器件库”：下面是几个常用的
    - 二极管、三极管、MOS管
    - 电阻、电容
    - 排针、排母
- 原理图：复制元件除了 Ctrl + C，还可以 Shift + 左键拖动
- PCB：
    - `G` 或 `Ctrl + G`: 设置网格尺寸
    - 参考 [https://www.bilibili.com/video/BV11u4y1Z76b](https://www.bilibili.com/video/BV11u4y1Z76b) 设置 PCB 相关规则 (Rules)
    - 先添加器件到 PCB，设置好 net class，再使用已定义好的走线规则 (记得设置 priority)
    - 在布线时遇到两个问题：一个是设置了 Power 和 Signal 默认走线规则但没用，另一个是元件焊盘处总报 DRC 错误 (后来发现是快捷键 `W` 设置成了 `Line` 而非交互式布线，修改后即正常)
    - 又遇到一个问题是：过孔 via 尺寸不是 rule 中设置的默认尺寸但 min/max 限制正常存在 (走线时按数字 `2` 可添加规则预设过孔)
    - `Shift + W` 快速切换线宽，走线时按数字 `2` 可添加过孔并切换层

大致设计流程如下：
- 构建元件库：
    - 参考 [Altium > Altium Designer 文档 > 构建和维护您的元器件及元器件库](https://www.altium.com/cn/documentation/altium-designer/components-libraries)
- 创建元件库 (含原理图符号、PCB 封装、3D 模型及器件参数) 
- 原理图设计 (绘制电路，完成电气连接) + Validate 检查
- 新建 PCB 并完成基础配置 (板层数、板框尺寸、材料、单位栅格等)
    - 板层: `D + K` 或 `Alt + D, K` 或 Design > Layer Stack Manager
    - 设置各层内缩: Stack Manager > Properties > Pullback Distance (仅 Plane 层有，Signal 层无) (20H 原则: PWR 比 GND 内缩 20H, H 是 PWR/GND 间板层厚度)
    - 粗吸附: `Ctrl + G` 设置为 `5mm`
    - PCB 原点：Edit > Origin > Set
    - PCB 尺寸：按 `1` 进入多层模式，然后 Design > Edit Board Shape
    - PCB 层可见性：快捷键 `L` 或者 Panels > View Configuration
    - 细吸附: `Ctrl + G` 设置为 `1mil`
    - **导入 Rules 和 Preference**
- 从原理图导入器件到 PCB (含网表与元件) 
- 设定关键设计规则 (线宽、过孔尺寸、间距、差分对等，作为布局布线的基础约束)，优先设置 Clearance (安全间距)
    - 高速线阻抗计算: [嘉立创阻抗计算神器使用说明](https://www.jlc.com/portal/server_guide_37381.html)
- PCB 布局 (含器件摆放、模块化分区、散热及结构考量)
- PCB 布线 (含电源/地处理、信号完整性等)
    - 铺铜: 
        - 推荐：`T + G + M` > New Polygon from > Board Outline
        - 传统：`P + G` 或 `Alt + P, G` 或 Place > Polygon Pour`
    - 泪滴: `T + E` 或 `Alt + T, E` 或 Tools > Teardrops (补/除)
    - DRC: `T + D` 或 `Alt + T, D` 或 Tools > Design Rule Check
- 执行设计规则检查 (DRC) ，验证所有规则是否满足
- 根据DRC结果，微调规则或布局布线，直至无错误/警告
- 生成生产文件 (Gerber、钻孔文件、装配图、BOM等) 

一些技巧：
- 创建元件库时可以借助 [嘉立创 to AD 工具 (https://www.bilibili.com/video/BV14jKP6zEPb)](https://www.bilibili.com/video/BV14jKP6zEPb) 或者 IPC Compliant Footprint Wizard（IPC兼容封装向导）生成标准封装
- 信号用 label, 电源地用 Port
- PCB 布局善用 Edit > Align
- `Shift + W` 快速切换线宽
- `2` 走线添加过孔并切换层，Shift + V 切换过孔类型 (待验证)




## 3. 常用快捷键与功能

搜索/修改快捷键：菜单栏空白处右键 > Customize

常用快捷键：
- `Shift + S`: 切换单层显示
- `G`: 调整吸附粗细
- `Q`: mil 与 mm 尺寸切换
- `D + R`: PCB 规则设置
- `A`: 调出对齐菜单
- `Ctrl + Shift + W/S/A/D`: 快速对齐元件上下左右 (默认是 `+ T/B/L/R`)
- `M + I`: 将器件翻转到背面
- `拖动 + L`: 元件在层之间快速切换
- `Ctrl + Shift + 滚轮`: 快速切换当前显示层
- `K`: 量尺 (默认是 `Ctrl + M`)
- `Shift + C`: 清楚标记 (高亮、量尺)
- `Ctrl + Shift + PgUp/PgDown`: 移动所选对象
- `Shift + E/Q`: 切换上一层/下一层 (默认是 `+/-` 号, next/previous layer)
- `Shift + W` 或 `G`: (拖拽/画线时) 切换吸附模式 (共三种) (默认 `Shift + E`)
- `8/9/0`: 3D 视图的不同视角
- `Ctrl + F`: 镜像显示
- `Ctrl + Shift + V`: Paste Special
- `选中走线 + Tap`: 快速选中邻近走线或焊盘
- `T + M`: 清除当前 DRC 报错标识
- `N + H/S + A`: 隐藏/显示所有飞线提示
- `-/=`: Decrease/Increase Horizontal Spacing (默认是 Align 里面找)
- `[/]`: Decrease/Increase Vertical Spacing (默认是 Align 里面找)
- `A + D/S`: Distribute Horizontally/Vertically
- `Ctrl + 框选`: 强制框选 (主要是 Designator 丝印)


常用功能：
- 板层: `D + K` 或 `Alt + D, K` 或 Design > Layer Stack Manager
- 铺铜: `P + G` 或 `Alt + P, G` 或 Place > Polygon Pour
- 重铺: `P + G + A`
- 泪滴: `T + E` 或 `Alt + T, E` 或 Tools > Teardrops (补/除)
- DRC: `T + D` 或 `Alt + T, D` 或 Tools > Design Rule Check


## 4. 四层板设计学习

参考资源：
- [Bilibili > Altium Designer 23 入门实战课程 - STM32 四层板 PCB 设计](https://www.bilibili.com/video/BV1uc411N7Ux)


四层板设计：
- 板层：
    - TOP/GND/PWR/BOT 四层，其中 TOP 为高速信号层
    - CJJ 陈师兄 2025_MC4_PLL 板层：铜厚 1oz，层间 FR-4 @ 2.8 mil <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-19-15-37-31_Altium Designer 23 安装与使用教程.png"/></div>
    - YWJ 杨师姐 2025_TX 板层：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-19-16-07-12_Altium Designer 23 安装与使用教程.png"/></div>
- 阻抗计算：
    - 共面波导一：间距 4 mil --> 线宽 8.15 mil, 插损 1.785 dB/in @ 14 GHz <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-19-16-41-47_Altium Designer 23 安装与使用教程.png"/></div>
    - 共面波导二：间距 8 mil --> 线宽 14.89 mil, 插损 1.685 dB/in @ 14 GHz <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-19-16-49-21_Altium Designer 23 安装与使用教程.png"/></div>
    - 微带线：线宽 3.68 mil <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-19-16-46-40_Altium Designer 23 安装与使用教程.png"/></div>


## 5. 202602_CDR 测试 PCB 板

基本信息：
- 四层板
- 芯片尺寸 (含 sealring)：宽 1697.01 um x 高 1340.00 um, 厚度约 12 mil = 0.3048 mm 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-19-17-18-00_Altium Designer 23 安装与使用教程.png"/></div>

### 5.1 绘制元件库

原理图给 Pin 标号时，可以用 formula = X1/100 + ... (其中 X1 代表横坐标)

利用 [npnp](https://www.bilibili.com/video/BV14jKP6zEPb) 或 [国创元器件库](https://www.bocangku.cn/) 来添加/生成 LDO 元件封装，我们最终使用的是前者 (更方便也更好)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-07-20-08-52-48_Altium Designer 23 安装与使用教程.png"/></div>




## 99. 实用功能与技巧

### 99.1 阻抗计算


相关工具：
- **[1. (推荐) 免费在线 PCB 阻抗计算器 (https://impedancecalculator.com/zh/)](https://impedancecalculator.com/zh/)**: 设定厚度、介电等计算信号线对应参数
- [2. 嘉立创阻抗计算神器使用说明 (https://www.jlc.com/portal/server_guide_37381.html)](https://www.jlc.com/portal/server_guide_37381.html): 只能计算立创已有的板材方案
- [3. Polar_SI9000 阻抗计算工具及汉化包 (https://gitcode.com/open-source-toolkit/2e551)](https://gitcode.com/open-source-toolkit/2e551)
    - [Polar SI9000 2025 v25.01 阻抗计算神器安装包分享 (2021 ~ 2025 全版本)](https://www.mr-wu.cn/polar-si9000-v25-01-free-download/): [百度网盘下载](https://pan.baidu.com/s/12glYT8k7NHem1a1mmMOOrg?pwd=7896)
    - [Polar SI9000 软件的安装及中文汉化教程](https://blog.csdn.net/m0_56196482/article/details/146947694)
    - [Polar Si9000 软件详细使用教程](https://blog.csdn.net/weixin_42107954/article/details/140244198)
    - [(推荐) 基于 Polar Si9000e 计算传输线特征阻抗的全攻略](http://uinio.com/Electronics/SI9000/)


2026.07.20: 推荐使用 **[3. Polar_SI9000 阻抗计算工具及汉化包 (https://gitcode.com/open-source-toolkit/2e551)](https://gitcode.com/open-source-toolkit/2e551)** 或者 **[1. (推荐) 免费在线 PCB 阻抗计算器 (https://impedancecalculator.com/zh/)](https://impedancecalculator.com/zh/)**，可以设定厚度、介电等计算信号线对应参数。一些说明：
- Er 与 Dk 完全等价，都是指 PCB 的相对介电常数 $\varepsilon_r$
- 这个 [3. Polar_SI9000 阻抗计算工具及汉化包](https://gitcode.com/open-source-toolkit/2e551)，我们是在 [Polar SI9000 2025 v25.01 阻抗计算神器安装包分享 (2021 ~ 2025 全版本)](https://www.mr-wu.cn/polar-si9000-v25-01-free-download/) 里下载了 2025 版本来用，挺好的
- 注意下线宽 = 设计线宽，上线宽 = 设计线宽 - 0.4mil



### 99.2 元件库下载/生成

- 从立创导入元件封装到 AD (自动填入元件原 description)：[npnp (https://www.bilibili.com/video/BV14jKP6zEPb)](https://www.bilibili.com/video/BV14jKP6zEPb) (https://github.com/ref42/npnp), 直接复制所需器件 ID, 或者导出多个器件的 `.csv` 文件
- AD 元件库在线下载：
    - [国创元器件库 (https://www.bocangku.cn/)](https://www.bocangku.cn/): 原理图 + PCB (不含 3D 模型)
    - [npnp (https://www.bilibili.com/video/BV14jKP6zEPb)](https://www.bilibili.com/video/BV14jKP6zEPb): 原理图 + PCB + 3D + Description
- 3D 模型下载：[3D Content Central (https://www.3dcontentcentral.cn/)](https://www.3dcontentcentral.cn/)

