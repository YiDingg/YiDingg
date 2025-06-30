# 如何通过 SSH 远程连接实验室服务器

> [!Note|style:callout|label:Infor]
> Initially published at 00:03 on 2025-06-24 in Beijing.

本文是我们组里其中一个服务器的连接流程记录。首先要有服务器的 IP 地址, 以及你的用户名和密码，下面是一个例子：

``` bash
111.11.111.111 # 服务器 IP 地址
myusername # 用户名
mypassword # 密码
```

## Step 1: 创建 SSH 端口

下载软件 [MobaXterm](https://www.filehorse.com/download-mobaxterm/download/) 并进行安装，完成后打开软件，点击左上角的 `session > SSH`, 输入你的服务器 IP 地址 `111.11.111.111` 和 username `myusername`，port 无需改动，点击 `OK` 即可。如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-18-05-32_如何通过 SSH 远程连接实验室服务器.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-18-07-00_如何通过 SSH 远程连接实验室服务器.png"/></div>

这时主界面会弹出来一个黑框框，并要求你输入密码，输入密码即可登录。登录完成后，输入下面这行代码创建 SSH 端口：

``` bash
vncserver -geometry 1920x1080 -depth 24 # 启动 vnc 服务器 (新端口), 设置分辨率为 2560x1600, 颜色深度为 24 位 (适合高质量图形显示)
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-18-19-09_如何通过 SSH 远程连接实验室服务器.png"/></div>

可以看到，创建了一个 `eda: 37`, 也就是说接下来我们需要通过端口 37 来连接服务器。

## Step 2: 连接服务器


下载 [RealVNC](https://www.realvnc.com/en/connect/download/viewer/) 安装后打开。接下来我们就在 RealVNC Viewer 上连接并使用实验室的服务器 (它具有图形界面, 而 MobaXterm 是命令行界面)，在正上方的空白栏输入你的服务器 IP 和端口 (我们的是 37 号端口)，按 `Enter` 键即可连接服务器。如果能连接得上，会弹出一个 warning，翻译过来是“您的身份验证信息将被安全传输，但在连接进行期间所交换的所有后续数据可能会被第三方截取”，意思就是远程操作过程所产生的数据交换可能会被第三方截取。我们不用太在意 (除非保密要求极高)，直接勾选 `Don't warn me about this again`，然后点击 `continue`，输入你的密码。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-18-22-49_如何通过 SSH 远程连接实验室服务器.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-18-27-46_如何通过 SSH 远程连接实验室服务器.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-18-26-42_如何通过 SSH 远程连接实验室服务器.png"/></div>

这样便成功登录进来了。我们服务器的工艺库文件都放在了 `/home/library` 路径下，比如 `tsmc28n` (台积电 28nm CMOS) 的路径为 `/home/library/TSMC/tsmc28n/1p9m6x1z1u_2v5` (111,100 items, totalling 4.3 GB)。



## Step 3: 修改基本设置

“新”电脑登录成功后，建议修改下面这些设置：
- 修改屏幕分辨率：`Application > System Tools > Settings > Device > Displays > Resolution`, 如果觉得用起来比较卡，可适当降低分辨率，比如 1920x1080。


## Step 4: 数据迁移

最后，我们需要将数据进行迁移。一方面是把本地电脑上的数据迁移到服务器，另一方面是将服务器上的工艺库 (如 `tsmc28n`) 迁移到本地电脑。因为在仿真速度要求不高的情况下，本地电脑的响应速度显然比 SSH 连接服务器要更快，操作更流畅，屏幕显示效果也更好。



## MobaXterm Tips

参考 [知乎 > MobaXterm 详细使用教程系列](https://zhuanlan.zhihu.com/p/61013117).

### 1. 文件传输和下载

文件传输和下载，可以采用直接拖拽的方式，或者采用鼠标右键选择相应功能。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-19-38-23_如何通过 SSH 远程连接实验室服务器.png"/></div>

也可以采用 SCP 命令上传和下载 (参考 [this link](https://deepinout.com/mobaxterm/8_uploading_files_with_mobaxterm.html))，好处是具有上传/下载的进度条 (但不能直接传输文件夹)。在 windows 端打开 terminal, 输入下面的命令即可将服务器上的文件下载到本地电脑上：

``` bash
tar -czvf test.tar /home/library/TSMC/tsmc28n/1p9m6x1z1u_2v5/    # 将要传输的文件打包成压缩包; -z：使用 gzip 压缩 (压缩率高，速度较快)
scp username@111.11.111.111:/home/dy2025/Cadence_Data/test.tar D:/a_Win_VM_shared_2_largeFiles/Cadence_Process_Library_Backup/  # 将压缩包从服务器下载到本地 windows
```

<!-- ``` bash
tar -czvf tsmc28n.tar /home/library/TSMC/tsmc28n/1p9m6x1z1u_2v5/    # 将要传输的文件打包成压缩包; -z：使用 gzip 压缩 (压缩率高，速度较快)
scp dy2025@182.48.105.253:/home/dy2025/Cadence_Data/tsmc28n.tar D:/a_Win_VM_shared_2_largeFiles/Cadence_Process_Library_Backup/  # 将压缩包从服务器下载到本地 windows
``` -->


如果报错 `Ensure the remote shell produces no output for non-interactive sessions.`, 大概是服务器主机上设置了 shell 初始化文件 `.cshrc` ，将此文件改名为 `ttt.cshrc` 即可暂时禁用。

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-20-21-59_如何通过 SSH 远程连接实验室服务器.png"/></div> -->


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-20-45-53_如何通过 SSH 远程连接实验室服务器.png"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-20-24-41_如何通过 SSH 远程连接实验室服务器.png"/></div>
 -->

等待文件传输完成即可。

### 问题日志

2025.06.24 21:00 注：我们这里解压时，出现了大量 “系统找不到指定路径” 的报错，暂未解决。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-21-01-35_如何通过 SSH 远程连接实验室服务器.png"/></div>

解决方案是，考虑不压缩文件夹，利用 SCP 直接递归传输整个文件夹：

``` bash
scp -r username@111.11.111.111:/home/dy2025/Workspace_T28 D:/a_Win_VM_shared_2_largeFiles/Cadence_Process_Library_Backup/  # 将压缩包从服务器下载到本地 windows, -r 表示递归
```

<!-- ``` bash
# test # scp -r dy2025@182.48.105.253:/home/library/TSMC/tsmc28n/1p9m6x1z1u_2v5/Calibre_new D:/a_Win_VM_shared_2_largeFiles/Cadence_Process_Library_Backup/  # 将压缩包从服务器下载到本地 windows, -r 表示递归
scp -r dy2025@182.48.105.253:/home/library/TSMC/tsmc28n/1p9m6x1z1u_2v5 D:/a_Win_VM_shared_2_largeFiles/Cadence_Process_Library_Backup/  # 将压缩包从服务器下载到本地 windows, -r 表示递归
scp -r dy2025@182.48.105.253:/home/library/TSMC/tsmc28n/1p9m6x1z1u/PDK_doc D:/a_Win_VM_shared_2_largeFiles/Cadence_Process_Library_Backup/tsmc28n_2v5/  # 将压缩包从服务器下载到本地 windows, -r 表示递归
``` -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-21-29-42_如何通过 SSH 远程连接实验室服务器.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-21-43-02_如何通过 SSH 远程连接实验室服务器.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-21-43-28_如何通过 SSH 远程连接实验室服务器.png"/></div>

虽然传输起始出现了几行错误，但是后面便再无报错了。





### 2. 个性化设置

个性化设置，设置终端字体，右键复制、文件保存路径等：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-19-40-05_如何通过 SSH 远程连接实验室服务器.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-19-40-11_如何通过 SSH 远程连接实验室服务器.png"/></div>


<!-- ## Tips: 如何传输文件

如何在服务器与自己的电脑之间互传文件？利用 
 -->
<!-- ## Solution 1: RealVNC

然后到 [https://www.realvnc.com/en/connect/download/viewer/](https://www.realvnc.com/en/connect/download/viewer/) 下载 RealVNC Viewer 客户端，安装后打开。


接下来就可以用 RealVNC Viewer 连接实验室的服务器，也不需创建 RealVNC 账号什么的 (想创建也无妨)。右键点击 `new connection`, 输入你的服务器端口和用户名，如下图：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-00-24-45_如何通过 SSH 远程连接实验室服务器.png"/></div>

其它选项不用设置，点击 `OK` 即可。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-00-25-50_如何通过 SSH 远程连接实验室服务器.png"/></div>



我们这里出现了 `authentication failed` 的错误 (2025.05.24 00:37)，有待解决。

## Solution 2: UltraVNC


参考 [知乎 > 快速上手免费内网远程工具 UltraVNC](https://zhuanlan.zhihu.com/p/709512820), 到 [UltraVNC Official](https://uvnc.com/) 下载 UltraVNC. 如果觉得太卡 (下载太慢)，也可以到 [alternative link 1](https://www.techspot.com/downloads/5181-ultravnc.html) or [alternative link 2](https://www.softpedia.com/get/Internet/Remote-Utils/UltraVNC.shtml#download) 进行下载。我们就是在官网下载时太慢导致下载失败，从而选择在 alternative link 1 下载了 **ultravnc 1610 msi X64** (UltraVNC 1.6.1.0 distribution for 64-bit operating systems) 。


注意，上面需要下载合适的操作系统版本，有 32 位 (X86) 和 64 位 (X64), 系统版本是指安装 VNC Serve 电脑的操作系统，也就是那台需要被远程的服务器，而不是你下载 UltraVNC 的计算机。

下载完成后，打开进行安装，注意安装环境建议全选：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-01-03-00_如何通过 SSH 远程连接实验室服务器.png"/></div>

安装完成后，打开 **UltraVNC Viewer**, 输入服务器的 IP 地址和端口号 (默认是 5900)，如下图： - > 

