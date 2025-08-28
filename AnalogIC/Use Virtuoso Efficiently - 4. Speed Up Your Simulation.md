# Use Virtuoso Efficiently - 4. Speed Up Your Simulation

> [!Note|style:callout|label:Infor]
Initially published at 13:33 on 2025-08-19 in Lincang.

## Background

你是否曾为大型瞬态仿真的龟速而烦恼，是否希望更快地获得仿真结果？这篇文章将介绍几种加快仿真速度的实用方法。

起因是最近在设计一个 2 GHz 的 CP-PLL 时需要进行大量的瞬态仿真，仿真速度成为了一个瓶颈。

## Common Solutions

1. 使用 APS 仿真器 + 多线程仿真 (还可进一步启用 `++aps`)
2. 修改仿真精度
3. 使用 spectre X 或 spectre FX 仿真器: spectre X > MX 兼顾速度和精度, CX 精度高, spectre FX 速度最快
4. 给虚拟机分配更多 CPU 资源
5. 在特定时间才开启各器件的 noise, 详见这篇文章 [知乎 > Transient noise 仿真在需要的时间点开启 noise](https://zhuanlan.zhihu.com/p/9915953761)





## Run out of Memory

在一些比较大型的后仿可能会因为内存不足导致仿真挂掉，这时可以设置仿真器需要保存的电压节点 (默认是保存所有节点)，除此之外还可以仅保存部分数据 (例如 4 个数据点仅保存一个)，详见这篇文章 [CSDN > Cadence 加快仿真速度](https://blog.csdn.net/qq_47452573/article/details/137106350)。



## References

- [知乎 > 提高 ADE 仿真速度的方法](https://zhuanlan.zhihu.com/p/675062591): 提出 "使用 APS 仿真器 + 多线程仿真" 的方法，评论区指出用 spectreX 会更高效 (spectreX 的 MX 兼顾速度和精度, CX 则精度高)，最快的是 spectre FX 仿真器
- [CSDN > Cadence 加快仿真速度](https://blog.csdn.net/qq_47452573/article/details/137106350): 类似，也是 APS + 线程 + 精度
- [知乎 > Cadence 加快仿真速度](https://zhuanlan.zhihu.com/p/680258606):  IC618 已经可以使用 spectre X/ spectre FX，仿真速度能更快, Spectre X MX 估计能比 APS 快个三倍


