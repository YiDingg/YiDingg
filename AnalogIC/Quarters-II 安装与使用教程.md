# Quarters-II 安装与使用教程


> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 15:28 on 2025-08-24 in Beijing.
> dingyi233@mails.ucas.ac.cn

## 1. Quarters-II 破解版安装与基本使用教程

参考：
- [1. (破解版, Quartus II 13.1) CSDN > Quartus II 13.1 的安装及使用](https://blog.csdn.net/qq_43279579/article/details/115158140)
- [2. (破解版, Quartus II 13.0) CSDN > Verilog 学习之路 (1) - Quartus II 13.0 下载安装和 HelloWorld](https://blog.csdn.net/qq_38113006/article/details/121569176)
- [3. (非破解, Quartus Prime 20.1) 知乎 > Quartus II 软件安装步骤](https://zhuanlan.zhihu.com/p/394199325)
- [4. (非破解, Quartus II 13.1) 知乎 > 正点原子【FPGA-开拓者】第四章：Quartus II 软件的安装和使用](https://zhuanlan.zhihu.com/p/138785729)
- [](https://gitcode.com/Resource-Bundle-Collection/2279c)

主要参考 [1. (破解版, Quartus II 13.1) CSDN > Quartus II 13.1 的安装及使用](https://blog.csdn.net/qq_43279579/article/details/115158140) 即可，运行破解软件途中若报错 `无法成功完成操作，因为文件包含病毒或潜在的垃圾软件`，参考 [知乎 > 解决Win10"无法成功完成操作，因为文件包含病毒或潜在的垃圾软件"](https://zhuanlan.zhihu.com/p/408613024) 将对应文件夹添加到 "排除项" 即可。

最终破解效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-24-17-18-28_Quarters-II 安装与使用教程.png"/></div>


使用技巧：
- Pin Planner: 先编译一次更新 pin planner，改了 pin 之后再编译一次
- Signal Tap: 设置时钟和输出节点 -> 编译 -> 下载 -> 设置触发 -> 运行 analyzer (推荐单次) -> 复位 FPGA -> 触发成功 -> 得到波形
    - 参考资料：
        - [CSDN > 彻底掌握 Quartus —— Signal Tap 篇](https://blog.csdn.net/k331922164/article/details/47623501)
        - [CSDN > Quartus 的 Signal Tap 的使用](https://blog.csdn.net/GLCZS/article/details/121474956)
        - [知乎 > Signal Tap Logic Analyzer使用讲解](https://zhuanlan.zhihu.com/p/656929563)


## 2. Altera-Blaster 驱动安装失败

搜了些博客，参考着关过安全中心里的相关设置，不起作用：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-26-13-46-56_Quarters-II 安装与使用教程.png"/></div>

参考这篇文章 [CSDN > WIN11 极简安装 USB-Blaster 驱动](https://blog.csdn.net/Nautiluss/article/details/161118052) 想下载最新版的，但是下载不了 (估计是被禁了？)，Pro Edition 和 Lite Edition 都不行。

最后解决了，方案是：
1. 下载 [博客园 > 【开发工具】驱动安装二：USB Blaster驱动安装](https://www.cnblogs.com/xiaomagee/p/12699530.html) 里的 USB Blaster 驱动程序，备用链接 [123 云盘](https://1836240215.share.123pan.cn/123pan/0y0pTd-85aAh)
2. 参考 [CSDN > Altera USB-blaster 驱动安装以及安装失败的解决办法](https://blog.csdn.net/lvzhshengh/article/details/115918262) 和 [百度经验 > Win10 怎么禁用驱动程序强制签名](https://jingyan.baidu.com/article/624e74594dbc8d34e8ba5aa6.html) 以 "禁用驱动程序强制签名" 模式重启电脑，然后仍按照常规方法 (本地路径) 选择刚刚步骤一里下载的驱动程序，安装即可。

