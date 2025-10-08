# Design of A 5-Bit RDR DAC for Reference Generation in BB-PLLs

**A 5-Bit R-2R DAC with -0.150\% Average Output Error (TT, +65°C) in TSMC 65nm Technology**

> [!Note|style:callout|label:Infor]
> Initially published at 21:24 on 2025-09-30 in Beijing.

## 1. Information

项目基本信息：
- 时间: 2025.09.30 ~ 2025.10.01
- 工艺:  <span style='color:red'>TSMC 65NM COMS </span> Mixed Signal RF SALICIDE Low-K IMD 1P6M-1P9M PDK (CRN65GP)
- 目标：设计一个满足指标要求的 5-bit RDR (R-2R) DAC, 用于 BB-PLL 的参考电压生成，包括前仿、版图和后仿

项目相关链接：
- [(本文) Design of A 5-Bit RDR DAC for Reference Generation in BB-PLLs](<Projects/Design of A 5-Bit RDR DAC for Reference Generation in BB-PLLs.md>)
    - (1) 理论与指导：[202509_tsmcN65_DAC_RDR_5bit](<AnalogICDesigns/202509_tsmcN65_DAC_RDR_5bit.md>)
    - (2) 设计与前仿：[202509_tsmcN65_DAC_RDR_5bit](<AnalogICDesigns/202509_tsmcN65_DAC_RDR_5bit.md>) (同上)
    - (3) 版图与后仿：[202509_tsmcN65_DAC_RDR_5bit](<AnalogICDesigns/202509_tsmcN65_DAC_RDR_5bit.md>) (同上)


## 2. Objective and Schedule

暂略。

## 3. Design Summary

下表总结了本次 DAC 设计的前后仿结果，与参考电路 (28nm) 的仿真结果作对比：

<span style='font-size:12px'>
<div class='center'>

| Parameter | This Work (Pre-Simul.) | This Work (Post-Simul.) | Reference (Pre-Simul.) | Reference (Post-Simul.) |
|:-:|:-:|:-:|:-:|:-:|
 | Average output error (TT, +65°C) | -0.140\% | -0.150\% | -0.044\% | -0.419\% |
 | Average output error (all corners) | -0.172\% ~ -0.098\% | -0.199\% ~ -0.116\% | -0.189\% ~ -0.019\% | -1.038\% ~ -0.326\% |
</div>
</span>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-02-01-18-18_202509_tsmcN65_DAC_RDR_5bit.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-02-01-20-08_202509_tsmcN65_DAC_RDR_5bit.png"/></div>

原理图和版图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-08-19-56-29_Design of A 5-Bit RDR DAC for Reference Generation in BB-PLLs.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-10-02-01-03-01_202509_tsmcN65_DAC_RDR_5bit.png"/></div>


<!-- ## 4. Material Detail Record -->




## References

本次 DAC 设计与另外两个 LDO/OTA 设计都属于同一项目，项目主页在这里：

- [**A 2.2-GHz ~ 3.3-GHz BB-PLL with Multiple Output Frequencies in TSMC 65-nm Technology**](<Projects/A 3.3-GHz BB-PLL with Multiple Output Frequencies in TSMC 65-nm Technology.md>)


下面是参考资料：
- [ChipDeubug > 全网最完整易理解的 R-2R DAC原理分析](https://chipdebug.com/forum-post/54266.html)
- [知乎 > R-2R梯形DAC – 通过示例电路图进行说明](https://zhuanlan.zhihu.com/p/665047757)
- [ADI > DAC 基本架构 II: 二进制 DAC](https://www.analog.com/media/cn/training-seminars/tutorials/mt-015_cn.pdf)
- [Electronics Tutorials > R-2R DAC](https://www.electronics-tutorials.ws/combination/r-2r-dac.html)
- [sasasatori > 模拟集成电路设计系列博客——6.2.2 基于 R-2R 的DAC](https://www.cnblogs.com/sasasatori/p/18169793)
- [知乎 > R_2R电阻网络DAC原理分析](https://zhuanlan.zhihu.com/p/39222238)
- [CSDN > 电压模式 R-2R DAC 的工作原理和特性](https://blog.csdn.net/Jack15302768279/article/details/139598475)


