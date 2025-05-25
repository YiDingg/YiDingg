# How to Add New Process Libraries in Cadence IC618

> [!Note|style:callout|label:Infor]
> Initially published at 13:25 on 2025-05-22 in Beijing.

## Introduction

本文的手动导入方法可以使用绝大多数的工艺库：包括 CDB 格式 (未标有 OA 字样的一般都是 CDB) 和 OA 格式，对于“非散装”工艺库，我们也给出了解决办法。本文的示例便是导入操作最繁琐的 “非散装” CDB 格式工艺库，读者可以对号入座，直接从对应的步骤开始即可。

## 脚本安装 PDK 工艺库

!> **<span style='color:red'>Attention:</span>**<br>
注：此方法在笔者的虚拟机上安装失败，暂时没有成功的例子，建议跳转至第二种方法“手动安装 PDK 工艺库”

以自带安装脚本的  `tsmc18_pdk` 工艺库为例 (台积电 CMOS 180nm), 工艺库文件名称 `tsmc18rf_pdk_v13d.zip`, 其中的 "pdk" 是 "process design kit" 的缩写，"rf" 是 "radio frequency" 的缩写，"v13d" 是版本号。下载链接在 

- 在主机 (windows) 下载并解压 `tsmc18rf_pdk_v13d.zip`，得到 `tsmc18rf_pdk_v13d` 文件夹，包含以下文件：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-12-15-42_How to Use Cadence Efficiently.png"/></div>

- 将文件夹 `tsmc18rf_pdk_v13d` 移动或复制到共享文件夹中，以便在虚拟机中访问
- 在虚拟机中打开刚刚解压好的文件夹，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-13-40-25_How to Add New Process Libraries in Cadence IC618.png"/></div>

- 右键打开 terminal, 输入 `perl pdkInstall.pl` 以运行自动安装脚本 (linux 系统一般都默认装有 perl 语言):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-13-41-36_How to Add New Process Libraries in Cadence IC618.png"/></div>

- 脚本给了我们三个选择，它们的区别仅在于 Metal Layer 不同，即 `1P6M`, `1P5M` 和 `1P4M`, Metal Layer 层数越高，布线时可选的金属层数就越多。不同金属层数的 PDK 可能不兼容，需根据工艺库文档确认。
- 这里我们选择安装第一个 `1P6M`，输入 `1`，然后按回车键：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-13-47-05_How to Add New Process Libraries in Cadence IC618.png"/></div>

- 接下来输入安装目录，我们选择安装在 `/home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d_1P6M` 下:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-14-07-25_How to Add New Process Libraries in Cadence IC618.png"/></div>


**<span style='color:red'> 解压失败导致安装退出，查阅资料未果，因此这种方法暂时不推荐使用。 </span>**
- 尝试过 root 模式，现象无变化
- 尝试过 `1P6M`, `1P5M` 和 `1P4M`，现象无变化



## 手动安装 PDK 工艺库

### 1. 解压文件夹


- 还是以上面的 `tsmc18_pdk` 工艺库为例，下载链接 [123 云盘 (主链接)](https://www.123684.com/s/0y0pTd-0uUj3)
- 解压下载好的 `tsmc18rf_pdk_v13d.zip` 文件夹，解压后得到文件夹 `tsmc18rf_pdk_v13d`，内容如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-12-15-42_How to Use Cadence Efficiently.png"/></div>

- 继续解压全部压缩包，得到以下内容：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-14-26-07_How to Add New Process Libraries in Cadence IC618.png"/></div>

- 将文件夹 `tsmc18rf_pdk_v13d` 移动到共享文件夹中，共享文件夹教程见 [How to Use Cadence Efficiently](<Electronics/How to Use Cadence Efficiently.md>).
- 打开虚拟机，在共享文件夹中找到刚刚解压好的总文件夹 `tsmc18rf_pdk_v13d`，例如我的路径为 `<Original_Path> = /home/IC/a_Win_VM_shared/Cadence_Process_Library_Backup/tsmc18rf_pdk_v13d`

### 2. 调整文件夹为合适的格式

我们这里，解压后的文件夹分为了四个部分，需要我们手动调整，将这些文件夹都合并在一起。**如果解压后已经是“散装”，则跳过这一步骤**。下图这样的就可以跳过：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-14-54-50_How to Add New Process Libraries in Cadence IC618.png"/></div>


- 在一个合适的位置新建文件夹，如 `<Installed_Path> = /home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d`，稍后我们便要将工艺库的四个小文件夹合并到这里
- 将所有的工艺库文件复制到 `<Installed_Path>` 中，具体而言，执行以下命令：

``` bash
su root  # 切换到 root 用户 (需要输入密码)'
# cp -r 递归复制, /* 表示所有文件, . 表示复制到当前目录
cp -r /home/IC/a_Win_VM_shared/Cadence_Process_Library_Backup/tsmc18rf_pdk_v13d/tsmc18rf_lib/* .
cp -r /home/IC/a_Win_VM_shared/Cadence_Process_Library_Backup/tsmc18rf_pdk_v13d/tsmc18rf_models/* .
cp -r /home/IC/a_Win_VM_shared/Cadence_Process_Library_Backup/tsmc18rf_pdk_v13d/tsmc18rf_techfiles/TechFiles/* .
```

- **确认必要的文件/文件夹都存在：** 
    - 路径配置文件：`cds.lib`
    - display 配置文件：`display.drf`
    - tech 配置文件：`techfile.tf` 或 `techfile.m4`, `techfile.m5` 之类的，有就可以
    - 工艺模型文件夹：`models`
    - 设计规则文件夹：`calibre`
    - 工艺信息文件夹：`tsmc18rf` (通常与工艺库名称直接相同)


### CDB to OA (Method 1)

!> **<span style='color:red'>Attention:</span>**<br>
注：此方法有一个缺点：转换后的文件/文件夹会直接堆在我们的工作文件夹下，容易造成混乱。因此，我们考虑下面的 Method 2 (不用看 Method 1 了，没必要)

Cadence IC 直接导入时需要 OpenAccess 格式的工艺库文件 (即 OA 格式)，而我们下载的工艺库文件是 CDB 格式的 (只要文件夹没有标明 OA 字样，基本都是 CDB 格式)。为了完成 CDB to OA 转换，需要在合适的位置新建一个文件夹，作为以后工作用的启动 virtuoso 的文件夹 workplace. 这是因为工艺库不能存放在工作文件夹里，否则 CDB to OA 转换会失败。我们整合好的工艺库放在了 `<Installed_Path> = /home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d`，而我们 cadence 虚拟机的工作文件夹为 `/home/IC/`，所以不能正常转换。

一种方法是在虚拟机根目录下创建一个文件夹 `Cadence_Process_Library`，然后将整合好的工艺库从 `<Installed_Path> = /home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d` 移动到此文件夹。这样，工艺库路径就变为了 `/Cadence_Process_Library/TSMC18RF_PDK_v13d`，而工作文件夹为 `/home/IC/`，两者不冲突，可以正常转换。

``` bash
su toot # 切换到 root 用户 (需要输入密码)
# 将整合好的工艺库从 <Installed_Path> 移动到 /Cadence_Process_Library/ 下
sudo mv /home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d /Cadence_Process_Library/
# 将整合好的工艺库从 /Cadence_Process_Library/ 移回 <Installed_Path>
sudo mv /Cadence_Process_Library/TSMC18RF_PDK_v13d /home/IC/Cadence_Process_Library/
```


### CDB to OA (Method 2)

工艺库不能位于 virtuoso 的打开路径下，本质只是路径冲突。换句话说，如果我们换一个地方打开 virtuoso, 完成格式转换之后，再将转化后的 OA 格式文件夹复制回 `<Installed_Path>`，是不是就可以完成 CDB to OA 转换呢？事实证明，这种方法是可行的，具体步骤如下：

- 现在，我们整合好的工艺库仍在 `<Installed_Path> = /home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d` 下
- 在 `/home/IC/` 下新建一个文件夹 `Cadence_CDB_to_OA`，专门用于 CDB to OA 转换
- 在 `/home/IC/Cadence_CDB_to_OA` 下新建一个文件夹 `TSMC18RF_PDK_v13d`, 用于存放 virtuoso 转换后的 OA 格式文件
- 在 `/home/IC/Cadence_CDB_to_OA/TSMC18RF_PDK_v13d` 中右键打开 terminal, 输入 `virtuoso` 启动 virtuoso
- 在 virtuoso 中，打开 `初始界面 > Tools > Conversion Toolbox > CDB to OpenAccess Translator`，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-16-01-06_How to Add New Process Libraries in Cadence IC618.png"/></div>

- 选择 `<Installed_Path>/cds.lib` 文件

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-17-00-34_How to Add New Process Libraries in Cadence IC618.png"/></div>

- 点击 `OK`, "Libraries to convert" 一栏会自动显示 `tsmc18rf`，点击 `OK` 开始转换
- 转换结束，检查是否转换成功：有 `ERROR` 表示不成功，有 `WARNING` 不影响转换结果

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-17-03-09_How to Add New Process Libraries in Cadence IC618.png"/></div>

- 转换成功之后，由于我们刚刚是在 `/home/IC/Cadence_CDB_to_OA/TSMC18RF_PDK_v13d` 下打开的 virtuoso, 所有转换所得文件都放在了 `/home/IC/Cadence_CDB_to_OA/TSMC18RF_PDK_v13d/` 下，下面对这些文件作处理
- 关闭 virtuoso, 打开 `<Installed_Path> = /home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d` 文件夹，右键打开终端，输入以下代码：

``` bash
su root # 切换到 root 用户 (需要输入密码)
cd .. # 返回上一级目录
# cp -r 递归复制, /* 表示所有文件, . 表示复制到当前目录
cp -r TSMC18RF_PDK_v13d TSMC18RF_PDK_v13d_OA  # 复制一份工艺库, 原来的作为原始文件留存, 对新的这一份作修改处理后, 将其导入 virtuoso 中
cd TSMC18RF_PDK_v13d_OA # 进入新复制的工艺库文件夹
# -r 递归, -f 强制
cp -rf /home/IC/Cadence_CDB_to_OA/TSMC18RF_PDK_v13d/* .  # 将转换后的 OA 格式文件复制到 TSMC18RF_PDK_v13d_OA 文件夹中, 并覆盖原有文件
rm -i /home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d_OA/tsmc18rf/prop.xx   # (交互式) 删除 prop.xx 文件, 否则导入到 virtuoso 时会被识别为 CDB 格式, 删除后才会识别为 OA 格式
```

- 现在，我们的工艺库已经完成了所有的转换工作，已经可以按 OA 格式的标准操作进行导入了：
- 关闭终端，返回 Cadence IC618 的安装目录 `/home/IC/`，右键打开 terminal, 输入 `virtuoso` 启动 virtuoso (也就是我们平时启动 virtuoso 的地方)
- 打开 `初始界面 > Tools > Library Path Editor > Edit > Add Library Path`，选择 `TSMC18RF_PDK_v13d_OA` 文件夹 (路径 `/home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d_OA`), 此时右侧会自动跳出 `tsmc18rf` 这个工艺库名称，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-17-35-49_How to Add New Process Libraries in Cadence IC618.png"/></div>

- 点击 `OK` 进行导入，如下图, log 界面没有任何 warning 和 error 提示，表示导入成功：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-17-53-16_How to Add New Process Libraries in Cadence IC618.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-17-54-34_How to Add New Process Libraries in Cadence IC618.png"/></div>

至此，导入工作全部结束，可以愉快地使用新工艺库咯！

如果嫌工艺库所占空间太大，可以删除工艺库原始文件 (未整合的 CDB 工艺库) `<Original_Path> = /home/IC/a_Win_VM_shared/Cadence_Process_Library_Backup/tsmc18rf_pdk_v13d`，删除整合过的 CDB 工艺库 `<Installed_Path> = /home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d`，**但是不能删除 OA 格式工艺库**（我们导入到 virtuoso 里的就是它）。


<!-- 
- 退出终端，找到 Cadence IC618 安装目录下的 `cds.lib` 文件，我们的路径为 `/home/IC/cds.lib`，复制此路径
- 打开 `TSMC18RF_PDK_v13d_OA` 文件夹 (路径 `/home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d_OA`)，打开 `cds.lib` 文件，在第一行添加以下命令：
 -->





<!-- 先手动解压 `tsmc18rf_pdk_v13d/tsmc18rf_docs.tar.Z`，得到 `tsmc18rf_docs` 文件夹，内含 PDK documents 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-14-14-18_How to Add New Process Libraries in Cadence IC618.png"/></div>
 -->

<!-- 
示例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-14-52-04_How to Add New Process Libraries in Cadence IC618.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-14-54-06_How to Add New Process Libraries in Cadence IC618.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-14-54-40_How to Add New Process Libraries in Cadence IC618.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-14-54-50_How to Add New Process Libraries in Cadence IC618.png"/></div>

 -->


### Simulation Verification

下面，我们利用导入的工艺库进行一个简单的 inverter 仿真，以验证工艺库导入成功。此部分步骤没有详细说明，因为我们已经出过仿真教程 [Simulate CMOS Inverter in Cadence IC618 (Virtuoso)](<Electronics/Simulate CMOS Inverter in Cadence IC618 (Virtuoso).md>)，下面是仿真步骤的简要总结：
- 在任意 Library 中新建一个 Cellview, 命名为 `inverter_tsmc18rf`，表示我们使用的是 `tsmc18rf` 工艺库
- 打开原理图，使用 `tsmc18rf` 工艺库中的 `nmos` 和 `pmos` 组件搭建 inverter 电路
- 如果出现原理图器件一片黄的问题，大概是 attach 时出现了某些错误，将工艺库的 `display.drf` 文件复制到 virtuoso 的启动目录 `/home/IC/`，然后重启 virtuoso 即可 
- 调整仿真设置，运行仿真
- 如果仿真报错：<span style='color:red'> The instance 'NMOS1' is referencing an undefined model or subcircuit, 'nch'. Either include the file containing the definition of 'nch', or define 'nch' before running the simulation. </span> 这是工艺信息文件设置错误导致的，因为一般都是默认用中芯科技 smic18 工艺库的工艺信息文件，但是台积电 tsmc18 的工艺信息文件与其不同。
- 解决办法： `ADE L > Setup > Model Libraries`，添加 model file `/home/IC/Cadence_Process_Library/TSMC18RF_PDK_v13d_OA/models/spectre/cor_std_mos.scs`，然后 <span style='color:red'> 记得在 section 一栏填入 tt 表示标准等级</span> (如果仍未解决，可参考 [this article](https://blog.csdn.net/coocoock/article/details/128053280))。
- 重新运行仿真，仿真结果正常弹出，如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-19-28-50_How to Add New Process Libraries in Cadence IC618.png"/></div>

- 当然，也可以调整一下背景图的颜色、线条的颜色和粗细（详见文章 [How to Use Cadence Efficiently](<Electronics/How to Use Cadence Efficiently.md>) 的 Color Preferences 部分）：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-20-31-56_How to Add New Process Libraries in Cadence IC618.png"/></div>




## 导入方式总结

- 事实上，我们在本文导入的是操作最复杂的一个工艺库：
    - CDB 格式：需要我们手动转换为 OA 格式
    - 非散装：需要我们手动调整，将几个子文件夹的内容合并到一起，才能进行 CDB to OA 转换
- 因此，本文的手动导入方法可以使用绝大多数的工艺库。依据工艺库格式/文件夹结构的不同，对号入座，从对应的步骤开始即可

网上还有一些其它的方法（见 **Reference** 一节），但是都没有我们的简洁，因为我们不但省去了手动调整 `cds.lib` 文件的步骤，保留有了 CDB (未整合), CDB (已整合), OA 三个源文件夹的同时，完全不侵占默认的工作文件夹 `/home/IC/`。







## More Process Libraries

我们在这里分享几个常见的工艺库，仅供学习参考，禁止商用！

- 下载链接：[123 云盘 (主链接)](https://www.123684.com/s/0y0pTd-0uUj3), [123 云盘链接 2 (备用链接)](https://www.123912.com/s/0y0pTd-0uUj3)
- 上面的链接包含以下工艺库：
    - TSMC18RF_PDK_v13d: 台积电 0.18μm CMOS 射频工艺库 <span style='color:red'> (本文所导入的工艺库) </span>
    - SMIC_018_MMRF: 中芯国际 0.18μm CMOS 射频工艺库
    - SMIC_13mmrf_1P6M_30k: 中芯国际 0.13μm CMOS 射频工艺库
    - NCSU-FreePDK45-1.4: 北卡罗莱纳州立大学 (NCSU) 45nm CMOS 开源工艺库
    - NCSU-FreePDK3D45-1.1: 北卡罗莱纳州立大学 (NCSU) 3D 45nm CMOS 开源工艺库
    - NCSU-FreePDK15-1.2: 北卡罗莱纳州立大学 (NCSU) 15nm FinFET 开源工艺库
    - CSU-LithoSim-FreePDK45-1: LithoSim for FreePDK45 (光刻仿真工具包)
- 其它工艺库：
    - TSMC28: 台积电 28nm CMOS 工艺库 (文件大小 164.59 GB), [百度网盘链接 1](https://pan.baidu.com/s/1aQNJ6KGsq4raYPxRUwHEew?pwd=8888) (提取码 `8888`)
    - ASAP5: 5nm FinFET 开源工艺库, [GitHub > The-OpenROAD-Project > ASAP5](https://github.com/The-OpenROAD-Project/asap5)
    - ASAP7: 7nm FinFET 开源工艺库, [GitHub > The-OpenROAD-Project > ASAP7](https://github.com/The-OpenROAD-Project/asap7)


## Reference

如果本文没能解决你的问题，或者你想了解更多的工艺库导入方法，可以参考以下链接：
- [tsmc28nm模拟工艺库安装方法](https://zhuanlan.zhihu.com/p/237387021)
- [IC617的CDB工艺库安装](https://zhuanlan.zhihu.com/p/284338404)
- [模拟IC版图设计学习问题——CDB-OA工艺库转换](https://zhuanlan.zhihu.com/p/673473052)
- [CSDN: cadence 617 cdb转oa格式、工艺库安装以及相关问题解决](https://blog.csdn.net/weixin_43026197/article/details/124520378)
- [IC617手动添加工艺库（OA格式）](https://zhuanlan.zhihu.com/p/585261304)

