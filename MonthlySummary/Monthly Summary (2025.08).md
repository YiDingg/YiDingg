# Monthly Summary (2025.08)

## 本月概览 (2025.08)

这个月月初就回家了，整体作息比在学校正常很多，学习效率倒也算中规中矩，放松和学习参半。月初回到家后休息了一段时间，同时准备了下学期可能用到的中英文教材电子版，当然，按我的习惯，需要深入学习的关键课程都是用国外教材。

之后便进入了 PLL 领域的学习，主要还是看 Razavi 的 CMOS 和 PLL 两本书，从最基本的 CP-PLL (Charge Pump Phase-Locked Loop) 入手，一边补充 Mixed-Signal 领域所需的数电/数集知识，一边阅读相关文献和综述，大致了解了学界现阶段 PLL 常见架构和应用。

有了理论基础之后，我开始动手实践，在本月中旬选取 SJSU (美国圣何塞州立大学) EE230 RFIC II 课程中的 CP-PLL 设计项目 https://www.sjsu.edu/people/sang-soo.lee/courses/EE230/index.html 作为练习，前后花了大约一周的时间完成。做项目的同时也产出了几篇 Virtuoso Tutorials, 掌握了 Verilog-AMS, VCO 和 PLL 的仿真方法，对设计中的关键点有了更深入理解。项目完成之后发现自己对 jitter and phase noise 的理解不够深入，于是又参考 Razavi PLL、相关论文和网上的一些资料深入学习了一下。

月末的几天投入到 Basics of CDR 的学习中，类似地，也是阅读书籍、相关文献和综述，掌握基本结构工作原理的同时，对学界当前 CDR 的研究热点和发展趋势有了初步了解。



## 本月详情 (2025.08)

本月主要产出如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-03-16-01-05_Monthly Summary (2025.08).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-03-16-02-54_Monthly Summary (2025.08).png"/></div>




## 下月计划 (2025.09)

下个月 (2025.09) 月初先休息几天，调整一下状态，之后就得准备新学期的几门课程了。至于是否还有时间推进自己的学习进度，还得看具体情况。如果有时间，由于一年内的主要目标是 Burst Mode CDR, 因此打算先学习 bang-bang CDR (PLL-based CDR 的典型) 和 gated-VCO CDR (burst mode CDR 的典型) (下图取自 [this link](https://people.engr.tamu.edu/spalermo/ecen689/cdr_comparisons_hsieh_cas_2008.pdf))：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-03-16-06-56_Monthly Summary (2025.08).png"/></div>