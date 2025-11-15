# DCE 数字电路实验 - 实验 2. 计数器实验 (week 7 2025.11.01)


> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 08:40 on 2025-10-25 in Beijing.

## 1. 实验时间

- 实验 2: week 7 Sat (2025.11.01)
- 报告提交截止: week 8 Fri (2025.11.07) 23:55





## 2. 实验记录

按老师要求，我们的 4-bit counter 需满足：
- 一个数码管显示十六进制计数 (溢出清零)，一个拨码开关用于 reset (异步复位控制信号)
- 四比特计数器的每一位，必须放在四个 always 块中，每个监视块只能对一个 bit 信号进行赋值操作。


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-31-21-44-05_DCE 数字电路实验 - 实验 2. 计数器实验.png"/></div>


在约束文件中，设置 S2 (R15) 为计数，SW0-R1 为复位开关，效果如下：

（略）




