# Virtuoso Tutorials - 21. How to Generate PRBS (Pseudo-Random Binary Sequence) Signal in Virtuoso

> [!Note|style:callout|label:Infor]
> Initially created by YiDingg at 19:50 on 2026-02-05 in Lincang.
> dingyi233@mails.ucas.ac.cn

## Introduction



## PRBS (Pseudo-Random Binary Sequence) 

<div class='center'>

| LFSR Length | PRBS Period (bits) | Taps |
|:-:|:-:|:-:|
| 2 | 3 | 2, 1 |
| 3 | 7 | 3, 2 |
| 4 | 15 | 4, 3 |
| 5 | 31 | 5, 3 |
| 6 | 63 | 6, 5 |
| 7 | 127 | 7, 6 |
| 8 | 255 | 8, 6, 5, 4 |
| 9 | 511 | 9, 5 |
| 10 | 1,023 | 10, 7 |
| 11 | 2,047 | 11, 9 |
| 12 | 4,095 | 12, 6, 4, 1 |
| 13 | 8,191 | 13, 4, 3, 1 |
| 14 | 16,383 | 14, 5, 3, 1 |
| 15 | 32,767 | 15, 14 |
| 16 | 65,535 | 16, 15, 13, 4 |
| 17 | 131,071 | 17, 14 |
| 18 | 262,143 | 18, 11 |
| 19 | 524,287 | 19, 6, 2, 1 |
| 20 | 1,048,575 | 20, 17 |
| 21 | 2,097,151 | 21, 19 |
| 22 | 4,194,303 | 22, 21 |
| 23 | 8,388,607 | 23, 18 |
| 24 | 16,777,215 | 24, 23, 22, 17 |
| 25 | 33,554,431 | 25, 22 |
| 26 | 67,108,863 | 26, 6, 2, 1 |
| 27 | 134,217,727 | 27, 5, 2, 1 |
| 28 | 268,435,455 | 28, 25 |
| 29 | 536,870,911 | 29, 27 |
| 30 | 1,073,741,823 | 30, 6, 4, 1 |
| 31 | 2,147,483,647 | 31, 28 |
| 32 | 4,294,967,295 | 32, 22, 2, 1 |

</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-20-47-58_Virtuoso Tutorials - 21. How to Generate PRBS (Pseudo-Random Binary Sequence) Signal in Virtuoso.png"/></div>



下面是一个 PRBS7 信号的仿真示例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-22-42-19_Virtuoso Tutorials - 21. How to Generate PRBS (Pseudo-Random Binary Sequence) Signal in Virtuoso.png"/></div>









## PRTS (Pseudo-Random Ternary Sequence)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-20-46-31_Virtuoso Tutorials - 21. How to Generate PRBS (Pseudo-Random Binary Sequence) Signal in Virtuoso.png"/></div>





## References

- [CSDN > analogLib 中 vprbs 的使用及各参数含义](https://blog.csdn.net/sinat_40709304/article/details/125224544)
- [PRBS (Pseudo-Random Binary Sequence)](https://blog.kurttomlinson.com/posts/prbs-pseudo-random-binary-sequence)
- [知乎 > PRBS 码是什么？PRBS 生成原理介绍](https://zhuanlan.zhihu.com/p/29658418)
- [CSDN > PRBS 码 (Verilog-A)](https://blog.csdn.net/qq_63868003/article/details/145474524)


