# Design Sheet for Folded-Cascode Op Amp

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 16:49 on 2025-06-10 in Beijing.

# 202506 台积电 180nm 单端输出折叠式运放设计 (一)：理论分析与设计参考 (Design Sheet for Folded-Cascode Op Amp)

## Introduction
本文是此次折叠式运放设计的 **理论分析和设计指导**，具体的 **设计过程与前仿结果** 见文章 [《202506 台积电 180nm 单端输出折叠式运放设计 (二)：设计迭代与前仿结果 (Design Iteration and Pre-Layout Simulation)》](https://zhuanlan.zhihu.com/p/1944724912431403356)。

## 1. Design Sheet

### 1.1 Reference Formulas 

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-17-28-23_Design Sheet of Folded-Cascode Op Amp.png"/></div> f_p1 错写呈 f_p2, 已在下一张改正-->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-17-31-39_Design Sheet of Folded-Cascode Op Amp.png"/></div>

### 1.2 Biasing Circuits

$V_{b3}$ 和 $V_{b4}$ 的偏置由常规的 current mirror 即可实现，$V_{b1}$ 和 $V_{b2}$ 的偏置可以由同一个 biasing 支路生成。具体而言，用两个 PMOS Mb9 和 Mb7 串联成一个等效晶体管，将此晶体管 diode-connected 以生成 $V_{b2}$，并在 drain 内或外部添加电阻以生成 $V_{b1}$，可以参考下图（下图的性能不好，不要抄尺寸）：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-18-18-57_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

### 1.3 CMFB 

如果是全差分的 stage, CMFB 是必须考虑的，这部分待之后再补充。

## 2. Formula Derivations

### 2.1  Biasing Circuits

详见下面两篇知乎文章：

<div class='center'>

|  |
|:-:|
 | **https://zhuanlan.zhihu.com/p/1915038423586177359** <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-12-01-23-48_Design Sheet for Folded-Cascode Op Amp (modified for WeChat).png"/></div> |
 | **https://zhuanlan.zhihu.com/p/1935398118490367665** <br>  <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-12-01-23-59_Design Sheet for Folded-Cascode Op Amp (modified for WeChat).png"/></div> |
</div>

### 2.2 DC Gain

详见文章：

 | **https://zhuanlan.zhihu.com/p/1915038423586177359** <br> <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-12-01-23-48_Design Sheet for Folded-Cascode Op Amp (modified for WeChat).png"/></div> |
|:-:|


### 2.3 GBW and PM

Y 点 (folding pole) 和 Z 点 (mirror pole) 分别贡献了第二、第三个极点，两者的频率大小在同一个量级。由经验来看, Z 点 (mirror pole) 的频率通常要稍低一些，可以近似视为 $f_{p2}$ 以指导 PM 的改进。事实上，此结构的频响曲线中存在一个与 $f_{p2}$, $f_{p3}$ 频率相近的右半平面零点，会使实际的 PM 略低于预期值。

### 2.4 Slew Rate 

注：下图中的偏置电压 $V_{b1},\ ...,\ V_{b4}$ 标错了，正确的标注见第一节 **Reference Formulas**。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-17-36-13_Design Sheet of Folded-Cascode Op Amp.png"/></div>

### 2.5 CM Input Range

由文章 [《模拟 CMOS 集成电路：共源共栅结构详解 (The Detailed Explanation of Cascode Stage) 》](https://zhuanlan.zhihu.com/p/1915038423586177359) 中的结论可知，共模输入范围为：

$$
\begin{gather}
V_{in,CM} \in \left(V_{I_{SS1}} - |V_{TH1}|,\ V_{DD} - |V_{OV11}| - |V_{OV1}| - |V_{TH1}|\right) \\
\mathrm{CM\ swing} = V_{DD} - V_{I_{SS1}} - |V_{OV11}| - |V_{OV1}|
\end{gather}
$$

注意这里的 $V_{I_{SS1}}$ 由 $V_{b1}$ 决定而不是简单视为 $|V_{OV5}|$，也就是 $V_{I_{SS1}} = V_{b1} - V_{GS3}$。可以通过适当的设计使 $(V_{in,CM})_{\min} = V_{I_{SS1}} - |V_{TH1}| < 0$, 以满足 zero CM input 的要求。

### 2.6 Output Swing

由文章 [《模拟 CMOS 集成电路：共源共栅结构详解 (The Detailed Explanation of Cascode Stage) 》](https://zhuanlan.zhihu.com/p/1915038423586177359) 中的结论可知，以饱和区边界为判定条件时，差模输出范围为：

$$
\begin{gather}
V_{out} \in \left(V_{b1} - V_{TH3},\ V_{b2} + |V_{TH7}|\right), \quad \mathrm{Output\ swing} = V_{TH3} + |V_{TH7}| + \left(V_{b2} - V_{b1}\right)
\end{gather}
$$

### 2.7 Noise

### 2.8 CMRR

### 2.9 PSRR

## 3. Optimizations

### 3.1 Gain-Boosting

如果不想用 two-stage 而是用 gain-boosting techniques 来获得同等增益下更高的 GBW, 可以参考论文 [Paper 1](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1635302), 或者考虑 triple cascode ([Paper 2](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6225750)).

### 3.2 Rail-to-Rail Input

也称为 complementary differential input, 可参考论文 [Paper 5](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=568171) 和 [Paper 6](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6584458).

### 3.3 Noise Optimization

参考论文 [Paper 4](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6871356)

### 3.4 Fast-Setting

参考论文  [Paper 2](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6225750)


## 4. Relevant Resources

<!-- - [Paper: Design and analysis of folded cascode operational amplifier using 0.13 µm CMOS technology](https://doi.org/10.1063/1.5142133) (备用链接 [here](https://scispace.com/pdf/design-and-analysis-of-folded-cascode-operational-amplifier-4wesrtx9gg.pdf#:~:text=This%20paper%20presents%20the%20design%20of%20a%20folded,CMOS%20technology%20with%20the%20Mentor%20Graphics%20pyxis%20software.)), 全引为 “Lee Cha Sing, N. Ahmad, M. Mohamad Isa, F. A. S. Musa; Design and analysis of folded cascode operational amplifier using 0.13 µm CMOS technology. AIP Conf. Proc. 8 January 2020; 2203 (1): 020041. https://doi.org/10.1063/1.5142133”
 -->

### 4.1 Relevant Literature

下面的几篇论文中, 涉及 single-ended output 的有 Paper 5 和 Paper 6, 其余的都是全差分运放。

- [Paper 1: IEEE > Design of a Fully Differential Gain-Boosted Folded-Cascode Op Amp with Settling Performance Optimization](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1635302) (备用链接 [here](https://ieeexplore.ieee.org/document/1635302))
- [Paper 2: IEEE > Dc-gain enhanced fast-settling triple folded cascode op-amp](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6225750) (备用链接 [here](https://ieeexplore.ieee.org/document/6225750))
- [Paper 3: IEEE > Design procedures for a fully differential folded-cascode CMOS operational amplifier](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=45013) (备用链接 [here](https://ieeexplore.ieee.org/document/45013))
- [Paper 4: IEEE > A gm/Id-Based Noise Optimization for CMOS Folded-Cascode Operational Amplifier](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6871356) (备用链接 [here](https://ieeexplore.ieee.org/document/6871356))
- [Paper 5: IEEE > A self-biased high performance folded cascode CMOS op-amp](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=568171) (备用链接 [here](https://ieeexplore.ieee.org/document/568171))
- [Paper 6: IEEE > Design tradeoffs in a 0.5V 65nm CMOS folded cascode OTA](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6584458) (备用链接 [here](https://ieeexplore.ieee.org/document/6584458))

### 4.2 Design Examples


- [复旦大学 全差分 telescopic 运放设计教程.pdf](https://www.writebug.com/static/uploads/2025/6/10/69881b7eab050ef46260205483164097.pdf)
- [清华大学 全差分 telescopic 运放设计实例 (李福乐, 微电子所).pdf](https://www.writebug.com/static/uploads/2025/6/10/75c2759b62a6483b9ddece6d23a33e99.pdf)
- [知乎 > 模拟 IC 设计之 telescopic 运放的仿真验证](https://zhuanlan.zhihu.com/p/590837057)

## Introduction
本文是此次折叠式运放设计的 **理论分析和设计指导**，具体的 **设计过程与前仿结果** 见文章 [《202506 台积电 180nm 单端输出折叠式运放设计 (二)：设计迭代与前仿结果 (Design Iteration and Pre-Layout Simulation)》](https://zhuanlan.zhihu.com/p/1944724912431403356)。

## 1. Design Sheet

### 1.1 Reference Formulas 

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-17-28-23_Design Sheet of Folded-Cascode Op Amp.png"/></div> f_p1 错写呈 f_p2, 已在下一张改正-->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-17-31-39_Design Sheet of Folded-Cascode Op Amp.png"/></div>

### 1.2 Biasing Circuits

$V_{b3}$ 和 $V_{b4}$ 的偏置由常规的 current mirror 即可实现，$V_{b1}$ 和 $V_{b2}$ 的偏置可以由同一个 biasing 支路生成。具体而言，用两个 PMOS Mb9 和 Mb7 串联成一个等效晶体管，将此晶体管 diode-connected 以生成 $V_{b2}$，并在 drain 内或外部添加电阻以生成 $V_{b1}$，可以参考下图（下图的性能不好，不要抄尺寸）：


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-18-18-57_Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.png"/></div>

### 1.3 CMFB 

如果是全差分的 stage, CMFB 是必须考虑的，这部分待之后再补充。

## 2. Formula Derivations

### 2.1  Biasing Circuits

详见下面两篇知乎文章：

<div class='center'>

|  |
|:-:|
 | **https://zhuanlan.zhihu.com/p/1915038423586177359** <br> [《模拟 CMOS 集成电路：共源共栅结构详解 (The Detailed Explanation of Cascode Stage) 》](https://zhuanlan.zhihu.com/p/1915038423586177359) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-12-01-23-48_Design Sheet for Folded-Cascode Op Amp (modified for WeChat).png"/></div> |
 | **https://zhuanlan.zhihu.com/p/1935398118490367665** <br> [《低压共源共栅电流镜的偏置结构考量——如何产生偏置电压 (Biasing Circuits for Low-Voltage Cascode Current Mirror)》](https://zhuanlan.zhihu.com/p/1935398118490367665) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-12-01-23-59_Design Sheet for Folded-Cascode Op Amp (modified for WeChat).png"/></div> |
</div>

### 2.2 DC Gain

详见
https://zhuanlan.zhihu.com/p/1915038423586177359
[《模拟 CMOS 集成电路：共源共栅结构详解 (The Detailed Explanation of Cascode Stage) 》](https://zhuanlan.zhihu.com/p/1915038423586177359)

### 2.3 GBW and PM

Y 点 (folding pole) 和 Z 点 (mirror pole) 分别贡献了第二、第三个极点，两者的频率大小在同一个量级。由经验来看, Z 点 (mirror pole) 的频率通常要稍低一些，可以近似视为 $f_{p2}$ 以指导 PM 的改进。事实上，此结构的频响曲线中存在一个与 $f_{p2}$, $f_{p3}$ 频率相近的右半平面零点，会使实际的 PM 略低于预期值。

### 2.4 Slew Rate 

注：下图中的偏置电压 $V_{b1},\ ...,\ V_{b4}$ 标错了，正确的标注见第一节 **Reference Formulas**。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-10-17-36-13_Design Sheet of Folded-Cascode Op Amp.png"/></div>

### 2.5 CM Input Range

由文章 [《模拟 CMOS 集成电路：共源共栅结构详解 (The Detailed Explanation of Cascode Stage) 》](https://zhuanlan.zhihu.com/p/1915038423586177359) 中的结论可知，共模输入范围为：

$$
\begin{gather}
V_{in,CM} \in \left(V_{I_{SS1}} - |V_{TH1}|,\ V_{DD} - |V_{OV11}| - |V_{OV1}| - |V_{TH1}|\right) \\
\mathrm{CM\ swing} = V_{DD} - V_{I_{SS1}} - |V_{OV11}| - |V_{OV1}|
\end{gather}
$$

注意这里的 $V_{I_{SS1}}$ 由 $V_{b1}$ 决定而不是简单视为 $|V_{OV5}|$，也就是 $V_{I_{SS1}} = V_{b1} - V_{GS3}$。可以通过适当的设计使 $(V_{in,CM})_{\min} = V_{I_{SS1}} - |V_{TH1}| < 0$, 以满足 zero CM input 的要求。

### 2.6 Output Swing

由文章 [《模拟 CMOS 集成电路：共源共栅结构详解 (The Detailed Explanation of Cascode Stage) 》](https://zhuanlan.zhihu.com/p/1915038423586177359) 中的结论可知，以饱和区边界为判定条件时，差模输出范围为：

$$
\begin{gather}
V_{out} \in \left(V_{b1} - V_{TH3},\ V_{b2} + |V_{TH7}|\right), \quad \mathrm{Output\ swing} = V_{TH3} + |V_{TH7}| + \left(V_{b2} - V_{b1}\right)
\end{gather}
$$

### 2.7 Noise

### 2.8 CMRR

### 2.9 PSRR

## 3. Optimizations

### 3.1 Gain-Boosting

如果不想用 two-stage 而是用 gain-boosting techniques 来获得同等增益下更高的 GBW, 可以参考论文 [Paper 1](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1635302), 或者考虑 triple cascode ([Paper 2](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6225750)).

### 3.2 Rail-to-Rail Input

也称为 complementary differential input, 可参考论文 [Paper 5](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=568171) 和 [Paper 6](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6584458).

### 3.3 Noise Optimization

参考论文 [Paper 4](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6871356)

### 3.4 Fast-Setting

参考论文  [Paper 2](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6225750)


## 4. Relevant Resources

<!-- - [Paper: Design and analysis of folded cascode operational amplifier using 0.13 µm CMOS technology](https://doi.org/10.1063/1.5142133) (备用链接 [here](https://scispace.com/pdf/design-and-analysis-of-folded-cascode-operational-amplifier-4wesrtx9gg.pdf#:~:text=This%20paper%20presents%20the%20design%20of%20a%20folded,CMOS%20technology%20with%20the%20Mentor%20Graphics%20pyxis%20software.)), 全引为 “Lee Cha Sing, N. Ahmad, M. Mohamad Isa, F. A. S. Musa; Design and analysis of folded cascode operational amplifier using 0.13 µm CMOS technology. AIP Conf. Proc. 8 January 2020; 2203 (1): 020041. https://doi.org/10.1063/1.5142133”
 -->

### 4.1 Relevant Literature

下面的几篇论文中, 涉及 single-ended output 的有 Paper 5 和 Paper 6, 其余的都是全差分运放。

- [Paper 1: IEEE > Design of a Fully Differential Gain-Boosted Folded-Cascode Op Amp with Settling Performance Optimization](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1635302) (备用链接 [here](https://ieeexplore.ieee.org/document/1635302))
- [Paper 2: IEEE > Dc-gain enhanced fast-settling triple folded cascode op-amp](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6225750) (备用链接 [here](https://ieeexplore.ieee.org/document/6225750))
- [Paper 3: IEEE > Design procedures for a fully differential folded-cascode CMOS operational amplifier](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=45013) (备用链接 [here](https://ieeexplore.ieee.org/document/45013))
- [Paper 4: IEEE > A gm/Id-Based Noise Optimization for CMOS Folded-Cascode Operational Amplifier](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6871356) (备用链接 [here](https://ieeexplore.ieee.org/document/6871356))
- [Paper 5: IEEE > A self-biased high performance folded cascode CMOS op-amp](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=568171) (备用链接 [here](https://ieeexplore.ieee.org/document/568171))
- [Paper 6: IEEE > Design tradeoffs in a 0.5V 65nm CMOS folded cascode OTA](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6584458) (备用链接 [here](https://ieeexplore.ieee.org/document/6584458))

### 4.2 Design Examples


- [复旦大学 全差分 telescopic 运放设计教程.pdf](https://www.writebug.com/static/uploads/2025/6/10/69881b7eab050ef46260205483164097.pdf)
- [清华大学 全差分 telescopic 运放设计实例 (李福乐, 微电子所).pdf](https://www.writebug.com/static/uploads/2025/6/10/75c2759b62a6483b9ddece6d23a33e99.pdf)
- [知乎 > 模拟 IC 设计之 telescopic 运放的仿真验证](https://zhuanlan.zhihu.com/p/590837057)

<!-- - [Paper: Design and analysis of folded cascode operational amplifier using 0.13 µm CMOS technology](https://doi.org/10.1063/1.5142133) (备用链接 [here](https://scispace.com/pdf/design-and-analysis-of-folded-cascode-operational-amplifier-4wesrtx9gg.pdf#:~:text=This%20paper%20presents%20the%20design%20of%20a%20folded,CMOS%20technology%20with%20the%20Mentor%20Graphics%20pyxis%20software.)), 全引为 “Lee Cha Sing, N. Ahmad, M. Mohamad Isa, F. A. S. Musa; Design and analysis of folded cascode operational amplifier using 0.13 µm CMOS technology. AIP Conf. Proc. 8 January 2020; 2203 (1): 020041. https://doi.org/10.1063/1.5142133”
 -->

### 4.1 Relevant Literature

下面的几篇论文中, 涉及 single-ended output 的有 Paper 5 和 Paper 6, 其余的都是全差分运放。

- [Paper 1: IEEE > Design of a Fully Differential Gain-Boosted Folded-Cascode Op Amp with Settling Performance Optimization](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1635302) (备用链接 [here](https://ieeexplore.ieee.org/document/1635302))
- [Paper 2: IEEE > Dc-gain enhanced fast-settling triple folded cascode op-amp](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6225750) (备用链接 [here](https://ieeexplore.ieee.org/document/6225750))
- [Paper 3: IEEE > Design procedures for a fully differential folded-cascode CMOS operational amplifier](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=45013) (备用链接 [here](https://ieeexplore.ieee.org/document/45013))
- [Paper 4: IEEE > A gm/Id-Based Noise Optimization for CMOS Folded-Cascode Operational Amplifier](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6871356) (备用链接 [here](https://ieeexplore.ieee.org/document/6871356))
- [Paper 5: IEEE > A self-biased high performance folded cascode CMOS op-amp](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=568171) (备用链接 [here](https://ieeexplore.ieee.org/document/568171))
- [Paper 6: IEEE > Design tradeoffs in a 0.5V 65nm CMOS folded cascode OTA](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6584458) (备用链接 [here](https://ieeexplore.ieee.org/document/6584458))

### 4.2 Design Examples


- [复旦大学 全差分 telescopic 运放设计教程.pdf](https://www.writebug.com/static/uploads/2025/6/10/69881b7eab050ef46260205483164097.pdf)
- [清华大学 全差分 telescopic 运放设计实例 (李福乐, 微电子所).pdf](https://www.writebug.com/static/uploads/2025/6/10/75c2759b62a6483b9ddece6d23a33e99.pdf)
- [知乎 > 模拟 IC 设计之 telescopic 运放的仿真验证](https://zhuanlan.zhihu.com/p/590837057)