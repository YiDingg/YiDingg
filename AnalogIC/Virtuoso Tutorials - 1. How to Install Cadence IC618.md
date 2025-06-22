# How to Install Cadence IC618 (Virtuoso)

> [!Note|style:callout|label:Infor]
> Initially published at 20:46 on 2025-05-19 in Beijing.

**<span style='color:red'>本文所分享的所有资料和资源仅供学习参考使用，请在下载 24 小时后全部删除！</span>**<br>


## Introduction

**模拟 IC 苦 Cadence 教程久矣！** 在本文，我们先介绍一下常说的 "cadence" 到底是什么意思，不同的软件版本之间有什么区别，然后便进入我们的主题：**下载并安装 Cadence IC618**。另外，我们给出的安装包已经包含了 Virtuoso, Calibre, Hspipce, Spectre 和 Innovus 等组件，可以满足 IC 设计的绝大部分需求。


### Basic Info

- [Cadence Official](https://www.cadence.com/en_US/home.html)
- [Cadence 官方网站](https://www.cadence.com/zh_CN/home/company.html)

Cadence 是一家公司的名称，我们在模拟 IC 中所说的 "cadence" 通常是指 cadence 公司旗下的 "Cadence IC"  (集成电路设计平台), 有时也单指 Cadence IC 下的 EDA 平台 "Virtuoso Studio"。不妨作一个类比, Cadence IC 就像 "Office 全家桶",而 Virtuoso Studio 就是其中的 "PowerPoint". 

Cadence IC 主要包括以下功能：
- 原理图设计 (Schematic)
- 版图设计 (Layout)
- 电路仿真 (Spectre, HSPICE)
- 物理验证 (DRC/LVS)

在后文，我们将 "cadence" 作为 "Cadence IC" 或 "Cadence Virtuoso" 的简称。

### Cadence IC 版本区别


- IC5141（旧版）发布年代：2000 年左右，较老版本。特点：基于 32 位系统，依赖老旧库（如 libXt.so.6）。界面较原始，功能有限，但占用资源少。支持旧版 Linux (如RHEL 4/5)。此版本已淘汰，仅少数老项目可能使用。
- IC617（主流稳定版）发布年代：2016 年左右，目前仍广泛使用。特点：支持 64 位系统，兼容性较好。功能完善，稳定性高。支持较新 Linux (如 CentOS 7/RHEL 7)。此版本是高效和企业常用版本。
- IC618（新版）发布年代：2018 年后，持续更新。特点：新增 AI 辅助设计、高性能仿真等功能。对硬件要求更高（需要更多 CPU/内存）。支持最新 Linux (如 RHEL 8/CentOS 8)。此版本适用于先进工艺节点（7nm 以下）或其它研究需求。


## Install Cadence IC618

### Installation Requirements

Cadence IC 的完整安装需要在 Linux 系统 (或虚拟机) 上进行，并且配置操作十分繁杂。这里，我们考虑使用别人已经配置好的虚拟机：这种虚拟机内已经预装好了 Cadence IC 的软件包和库文件（并配置好了 license 和环境变量等），我们只需下载并安装虚拟机，然后便可以在虚拟机上愉快地使用 cadence 了！

比如，某宝的某商家提供的虚拟机安装包就自带了如下 Cadence 组件：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-19-20-09-54_Cadence.png"/></div>

2025.05.19, 笔者花了十几块钱块钱，买了一份 Cadence IC618, 安装包已经放在了 123 云盘：[https://www.123684.com/s/0y0pTd-RuUj3](https://www.123684.com/s/0y0pTd-RuUj3)，点击链接即可下载 (123 云盘下载免费且不限速，但是需要先登录)。

**注意：压缩包有大约 25 GB, 解压后文件夹约占 75 GB, 因此在下载/安装之前，请先确保电脑有足够的硬盘空间 (至少留有 100 GB 以上)。**


### My Installation Process

- 示例时间与环境: 2025.05.19, Windows 11

下面是具体的下载安装步骤：

1. 下载 [123 云盘链接 (https://www.123684.com/s/0y0pTd-RuUj3)](https://www.123684.com/s/0y0pTd-RuUj3) 中的压缩包
2. 在安装 VMWare 之前，建议从磁盘专门分一个区，用来放置虚拟机。磁盘分析可以参考 [知乎 > Windows磁盘分区详尽教程（无需第三方工具篇）](https://zhuanlan.zhihu.com/p/95133122)
3. 解压 VMWare 虚拟机压缩包，双击安装 VMware-workstation-full-16.2.0-18760230.exe
    - (1) 点击“下一步”
    - (2) **勾选** “自动安装 Windows Hypervisor Platform (WHP)”, 点击“下一步”
    - (3) **更改安装位置**为 `D:\VMware\` (或其它, 例如 `E:\VMware\`)
    - (4) **勾选** “将 VMware Workstation 控制台工具添加到系统 点击“下一步”
    - (5) **取消勾选** “启动时检查产品更新 (C)”, **取消勾选** “加入 VMware 客户体验提升计划 (J)”, 点击“下一步”
    - (6) 点击“下一步”，点击“安装”
    - (7) 安装向导结束之后，点击 “许可证”
    - (8) 输入解压文件中 `SN.txt` 中的序列号，点击 “输入”, 点击 “完成”
4. 解压 IC618 压缩包, 只需选中 `IC618-OK.part01.rar` 进行解压，后面两个压缩包会自动跟随解压 (用 Unarchiver One 或 WinRAR 等常见软件都可以)
5. 在虚拟机环境中打开 Cadence IC618
    - (1) 将刚刚解压好的 `IC618-OK` 文件夹移动到合适的位置
    - (2) 打开刚刚安装好的 VMWare, 点击 “打开虚拟机”
    - (3) 在 `IC618-OK` 文件夹中，找到文件 `IC618.vmx`, 选择并打开它
    - (4) 点击 VMware 窗口左上角的 “开启此虚拟机”
    - (5) **<span style='color:red'> （如果是第一次打开）点击 “我已移动虚拟机” </span>**
    - (6) 等待启动虚拟机
    - (7) 在主界面右键，点击 “Open Terminal” (打开终端)
    - (8) 输入 `virtuoso` 并回车 (如果输入 `virtuoso&`, & 代表后台运行)
6. 成功打开 `Cadence Virtuoso`, 安装步骤全部结束

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-00-12-09_Cadence.png"/></div>

该虚拟机中自带的资料和工艺库如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-00-36-49_Cadence.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-20-01-06-37_Cadence.png"/></div>


注，如果想对虚拟机内的文件进行移动、复制等操作，需要使用 root 权限：
1. 从 user 转为 root 权限：
    - (1) 右键打开 Terminal, 输入 `su root`
    - (2) 输入密码 (默认 `123456`), 这一步光标不会移动（看起来像没输入一样），这是正常的；输入完密码后直接回车即可
    - (3) 此时终端待输入行前面的方框内显示 `[root@...]`, 则表示操作成功
2. 从 root 转为 user 权限：
    - (1) 右键打开 Terminal, 输入 `su IC` (我们的 user 名叫 `IC`)
    - (2) 输入密码后回车
3. 如果仍报错 `Operation not supported by the backend`，请关闭虚拟机，然后用管理员模型重新打开




### Other Installation Methods

如果不想按照上面的方法，也可以参考 [Bilibili: Cadence IC618 Virtuoso 虚拟机安装](https://www.bilibili.com/video/BV1Z14y197qF), 安装包到 https://pan.quark.cn/s/aac217e76e2f (提取码 `4ddb`) 下载。

## Add New Process Library


详见 [How to Add New Process Libraries in Cadence IC618](<AnalogIC/Virtuoso Tutorials - 3. How to Add New Process Libraries in Cadence IC618.md>)。另外, Cadence 的相关教程已经全部汇总在了 [知乎专栏: Cadence Tutorials](https://www.zhihu.com/column/c_1917022837237081134), 读者可移步专栏查看更多内容。


