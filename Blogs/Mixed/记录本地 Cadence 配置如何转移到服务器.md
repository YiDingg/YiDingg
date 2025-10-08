# 记录本地 Cadence 配置如何转移到服务器

> [!Note|style:callout|label:Infor]
> Initially published at 22:02 on 2025-10-07 in Beijing.

**<span style='color:red'> 注：本文内容涉及私人信息，不公开到个人网站或其它公共平台。 </span>**

## 1. 背景

截至 2025 年 9 月底的 BB-PLL 项目，我们一直是使用本地虚拟机上的 Cadence 进行设计和仿真。但随着项目的推进，设计和仿真的复杂度越来越高，一方面本地虚拟机的性能已经无法满足需求，另一方面服务器上便于远程交流和资源共享，因此决定将我们的 Cadence 各项配置迁移到组内服务器上。

## 2. 关键文件/文件夹

本次迁移的几个关键文件/文件夹列于下表，也是我们以后使用的文件结构：

- `/home/dy2025`: home 主目录
    - `.cdsinit`
    - `.cdsenv`
    - `cds.lib`
    - `00_File_Library`: 所有杂七杂八资料的存放位置，包括但不限于从本地传资料、与他人交换资料等
    - `Cadence_Projects`: 存放我们的所有 Cadence 项目
    - `Cadence_Config`: 存放 Cadence 各项配置，主要是各工艺的 corner 设置
    - `Cadence_DRC_LVS`: 下有文件夹 DRC_tsmcN65, LVS_tsmcN65 等，作为 DRC 和 LVS 的 run directory
    - (Optional) `simulation`: 所有仿真数据都存在这个文件夹中，但一般情况下文件夹较大导致不便迁移

## 3. 迁移步骤

在 MobaXterm 上连接组内的 104 服务器 `111.198.29.104` (需要管理员给你创建好用户名和端口号)，输入下面代码创建自己的端口：

``` bash
# 创建一个 vnc 服务器, 分辨率 2560x1600, 颜色深度为 24 位
vncserver -geometry 2560x1600 -depth 24
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-07-22-33-57_记录本地 Cadence 配置如何转移到服务器.png"/></div>



自动创建的端口号是 21, 然后就可以在 RealVNC 上连接服务器了：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-07-22-35-06_记录本地 Cadence 配置如何转移到服务器.png"/></div>

把 Cadence 各项配置/文件复制到文件夹 `Cadence_Migration` 中，打包后放到共享文件夹里 (打包是为了提高传输速度)，然后通过 scp 命令将本地的配置文件都传到服务器上：

``` bash
# 把本地压缩包发送到 104 服务器
scp D:\a_Win_VM_shared\Cadence_Data\Cadence_Migration_20251007.tar.gz dy2025@111.198.29.104:/home/dy2025/00_File_Library/
```

如果报错 `port 22: Connection refused`, 解决方案见这篇文章 [How to Fix "Ssh: Connect To Host 'Hostname' Port 22: Connection Timed Out"](https://www.geeksforgeeks.org/linux-unix/fix-ssh-connect-to-host-hostname-port-22-connection-timed-out/). 但这里我们并没有像文中一样解决，而是改为 MobaXterm 传输文件夹。

**<span style='color:red'> 注意，按照师兄的嘱咐，我们所有项目文件/仿真数据都存放在特定文件夹下以方便备份/迁移等操作，我们的是 `/data/Work_dy2025`。 </span>**

传输完成后，修改 `cds.lib` 文件中的路径，下面是 104 服务器的常用工艺库路径：

``` bash
DEFINE tsmcN28 /data/library/TSMC/tsmc28n/1p9m6x1z1u/tsmcN28
DEFINE tsmcN45 /data/library/TSMC/tsmc40n/1P10M_7X0Y1Z0R1U/tsmcN45
DEFINE tsmcN65 /data/library/TSMC/tsmc65n/v1.0c_RF/tsmcN65
DEFINE smic40 /data/library/SMIC_40/smic40ll
DEFINE onc18 /data/library/ONSEMI180/180nm/onc18/pdk/cds_oa/onc18_1_40ext/libs/onc18/onc18
```

效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-00-11-54_记录本地 Cadence 配置如何转移到服务器.png"/></div>

`cds.lib` 文件弄完之后，手动调整一下 `.cdsinit` 和 `.cdsenv` 文件中的一些配置，这里仅提如何将 104 服务器的 calibre 集成到工具栏：

``` bash
; .cdsinit
; EMX initialization start
load("/data/App/cadence/emx23.10/share/emx/virtuoso_ui/emxinterface/emxskill/emxconfig.il")

; Calibre initialization start
load("/data/App/mentor/aoi_cal_2023.2_35.23/lib/calibre.OA.skl")
```

最后将 `Cadence_DRC_LVS_PEX` 文件夹创建好，把各工艺库的 `Calibre` 文件夹复制进去，方面后面找各种文件。

**<span style='color:red'> 按我们的设置，simulation 数据会默认存放在 home 目录下，这里需要将其修改到 work 文件夹。</span>** 在 `.cdsenv` 文件添加下面一行：

``` bash
asimenv.startup  projectDir  string "/data/Work_dy2025/simulation" ; 设置仿真数据存放路径
```




## 4. 服务器与本地虚拟机对比

- 服务器优点：
    - (1) 服务器上软件的操作要流畅一些，不会出现一步小操作卡两三秒的情况
    - (2) 服务器上版图比本地虚拟机流程得多，基本上完全没有卡顿
- 服务器缺点：
    - (1) 小项目前仿实在是太慢了 (后仿)
    - (2) 服务器上的 maestro 查看仿真波形时不是另起一个窗口，令人不习惯，后面看看如何修改
- 其它：
    - (1) 服务器上 maestro 前后仿结果都与本地虚拟机有一定差异，暂未确定具体原因
    - (2) 服务器上后仿有的快有的慢，暂时没摸清规律





常用服务器命令等内容见文章 [如何通过 SSH 远程连接实验室服务器](<Blogs/Mixed/如何通过 SSH 远程连接实验室服务器.md>)。
