# How to Install Cadence IC618 (Virtuoso)

> [!Note|style:callout|label:Infor]
> Initially published at 20:46 on 2025-05-19 in Beijing.

!> **<span style='color:red'>Attention:</span>**<br>
本文所分享的所有资料、资源仅供学习参考，请在下载 24 小时后删除，禁止商用！

## Intro

### Basic Info

- [Cadence Official](https://www.cadence.com/en_US/home.html)
- [Cadence 官方网站](https://www.cadence.com/zh_CN/home/company.html)

Cadence 是一家公司的名称，我们在模拟 IC 中所说的 "cadence" 通常是指 cadence 公司旗下的 "Cadence IC"  (集成电路设计平台), 有时也单指 Cadence IC (集成电路设计平台) 下的 EDA 平台 "Virtuoso Studio"。通俗的来讲, Cadence IC 是 "Office 全家桶", Virtuoso Studio 是其中的 "高级版图工具 PowerPoint". Cadence IC 主要包括以下功能：
- 原理图设计 (Schematic)
- 版图设计 (Layout)
- 电路仿真 (Spectre, HSPICE)
- 物理验证 (DRC/LVS)

在后文，我们将 "cadence" 作为 "Cadence IC" 或 "Virtuoso Studio" 的简称。

### Cadence IC 版本区别


- (1) IC5141（旧版）发布年代：2000 年左右，较老版本。特点：基于 32 位系统，依赖老旧库（如 libXt.so.6）。界面较原始，功能有限，但占用资源少。支持旧版 Linux (如RHEL 4/5)。此版本已淘汰，仅少数老项目可能使用。
- (2) IC617（主流稳定版）发布年代：2016 年左右，目前仍广泛使用。特点：支持 64 位系统，兼容性较好。功能完善，稳定性高。支持较新 Linux (如 CentOS 7/RHEL 7)。此版本是高效和企业常用版本。
- (3) IC618（新版）发布年代：2018 年后，持续更新。特点：新增 AI 辅助设计、高性能仿真等功能。对硬件要求更高（需要更多 CPU/内存）。支持最新 Linux (如 RHEL 8/CentOS 8)。此版本适用于先进工艺节点（7nm 以下）或研究需求。


## Install Cadence IC618

### Installation Requirements

Cadence IC 需要在 Linux 系统上安装，整体比较复杂。网络上别人分享的 Linux 虚拟机安装包，通常已经预装好了 Cadence IC 的软件包和库文件（并配置好了 license 和环境变量），我们只需下载/安装好虚拟机，然后用虚拟机打开 Cadence 文件包即可。

比如，某宝的某商家提供的虚拟机安装包就自带了如下 Cadence 组件：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-19-20-09-54_Cadence.png"/></div>

2025.05.19, 花了 16 块钱，买了一份 Cadence IC618, 链接 [https://pan.baidu.com/s/1LajnGZD1Ii9VL75wTmuenA?pwd=XEf4](https://pan.baidu.com/s/1LajnGZD1Ii9VL75wTmuenA?pwd=XEf4) (提取码 `XEf4`). 安装教程、虚拟机解压密码 `minlei618`, IC618 解压密码 `minlei816`. 注意两个解压密码不一样，一个 618 一个 816。如果上面链接失效，或者不想用百度网盘，可以用 123 云盘的链接下载: [https://www.123684.com/s/0y0pTd-RuUj3](https://www.123684.com/s/0y0pTd-RuUj3).

!> **<span style='color:red'>Attention:</span>**<br>
压缩包有大约 25 GB, 解压后文件夹约占 75 GB, 因此在下载/安装之前，请先确保电脑有足够的硬盘空间 (建议留有 100 GB 以上)。


### My Installation Process


- Time: 2025.05.19
- System: Windows 11
- 下载 [链接 1 (https://pan.baidu.com/s/1LajnGZD1Ii9VL75wTmuenA?pwd=XEf4)](https://pan.baidu.com/s/1LajnGZD1Ii9VL75wTmuenA?pwd=XEf4) 或 [链接 2 (https://www.123684.com/s/0y0pTd-RuUj3)](https://www.123684.com/s/0y0pTd-RuUj3) 中的压缩包
- 在安装 VMWare 之前，建议从磁盘专门分一个区放置虚拟机
- 解压 VMWare 虚拟机压缩包，双击安装 VMware-workstation-full-16.2.0-18760230.exe
    - 下一步
    - **勾选** “自动安装 Windows Hypervisor Platform (WHP)”, 下一步
    - **更改安装位置**为 `D:\VMware\` (或其它, 例如 `E:\VMware\`)
    - **勾选** “将 VMware Workstation 控制台工具添加到系统 PATH”，下一步
    - **取消勾选** “启加时检查产品更新 (C)”, **取消勾选** “加入 VMware 客户体验提升计划 (J)”, 下一步
    - 下一步
    - 安装
    - 安装向导结束之后，点击 “许可证”
    - 输入解压文件中 `SN.txt` 中的序列号，点击 “输入”, 点击 “完成”
- 解压 IC618 压缩包, 只需选中 `IC618-OK.part01.rar` 进行解压，后面两个压缩包会自动跟随解压 (用 Unarchiver One 或 WinRAR 等常见软件都可以)
- 在虚拟机环境中打开 Cadence IC618
    - 将刚刚解压好的 `IC618-OK` 文件夹移动到合适的位置
    - 打开刚刚安装好的 VMWare
    - 点击 “打开虚拟机”
    - 在 `IC618-OK` 文件夹中，找到文件 `IC618.vmx`, 选择并打开它
    - 点击 VMware 窗口左上角的 “开启此虚拟机”
    - **<span style='color:red'> （如果是第一次打开）点击 “我已移动虚拟机” </span>**
    - 等待启动虚拟机
    - 在主界面右键，点击 “Open Terminal” (打开终端)
    - 输入 `virtuoso` 并回车 (如果输入 `virtuoso&`, & 代表后台运行)
    - 成功打开 `Cadence Virtuoso`, 安装步骤全部结束

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-00-12-09_Cadence.png"/></div>


<div class='center'>
<span style='color:red'> Cadence IC 的仿真教程、小技巧等详见文章 []0) </span>
</div>


注，如果想对虚拟机内的文件进行移动、复制等操作，需要使用 root 权限：
- 从 user 转为 root 权限：
    - 右键打开 Terminal, 输入 `su root`
    - 输入密码 (默认 `123456`), 这一步光标不会移动（看起来像没输入一样），这是正常的；输入完密码后直接回车即可
    - 此时终端待输入行前面的方框内显示 `[root@...]`, 则表示操作成功
- 从 root 转为 user 权限：
    - 右键打开 Terminal, 输入 `su IC` (我们的 user 名叫 `IC`)
    - 输入密码后回车
- 如果仍报错 `Operation not supported by the backend`，请关闭虚拟机，然后用管理员模型重新打开



该虚拟环境中自带的资料和工艺库如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-00-36-49_Cadence.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-01-06-37_Cadence.png"/></div>

### Other Installation Methods

如果不想按照上面的方法，也可以参考 [Bilibili: Cadence IC618 Virtuoso 虚拟机安装](https://www.bilibili.com/video/BV1Z14y197qF), 安装包到 https://pan.quark.cn/s/aac217e76e2f (提取码 `4ddb`) 下载

## Add Process Library

### How to Add a Process Library

暑期科研时间需要用到 tsmc28 (台积电 28nm) 工艺库，我们在上一小节安装的 Cadence IC 并不附带这个工艺库的相关文件。于是在淘宝又花几块钱买到 tsmc28 的压缩包，下面介绍工艺库添加流程。

<span style='color:red'> 此部分待补充 </span>

### More Process Libraries

下面我们分享几个常见的工艺库，仅供学习参考，禁止商用！

- 下载链接：[123 云盘链接 1](https://www.123684.com/s/0y0pTd-0uUj3), [123 云盘链接 2 (备用链接)](https://www.123912.com/s/0y0pTd-0uUj3)
- 上面的链接包含以下工艺库：
    - TSMC18RF_PDK_v13d: 台积电 18nm FinFET 射频工艺库
    - SMIC_018_MMRF: 中芯国际 0.18μm CMOS 射频工艺库
    - SMIC_13mmrf_1P6M_30k: 中芯国际 0.13μm CMOS 射频工艺库
    - NCSU-FreePDK45-1.4: 北卡罗莱纳州立大学 (NCSU) 45nm CMOS 开源工艺库
    - NCSU-FreePDK3D45-1.1: 北卡罗莱纳州立大学 (NCSU) 3D 45nm CMOS 开源工艺库
    - NCSU-FreePDK15-1.2: 北卡罗莱纳州立大学 (NCSU) 15nm FinFET 开源工艺库
    - CSU-LithoSim-FreePDK45-1: LithoSim for FreePDK45 (光刻仿真工具包)
- 其它工艺库：[百度网盘链接 1](https://pan.baidu.com/s/1aQNJ6KGsq4raYPxRUwHEew?pwd=8888) (提取码 `8888`)
    - TSMC28: 台积电 28nm CMOS 工艺库 (文件大小 164.59 GB)


