# Razavi CMOS - Chapter 19. Layout and Packaging

> [!Note|style:callout|label:Infor]
> Initially published at 23:30 on 2025-06-24 in Beijing.


## Introduction

参考教材: [*Design of Analog CMOS Integrated Circuits (Behzad Razavi) (2nd edition, 2015)*](https://www.zhihu.com/question/452068235/answer/95164892409).


在过去的 40 年里，模拟 CMOS 电路已经从低速、低复杂度、小信号、高电压的拓扑结构发展成为高速、高复杂度、低电压的“混合信号”系统，其中包含了大量数字电路。尽管器件缩放提高了晶体管的本征速度，但集成电路不同部分之间的负面相互作用以及布局和封装中的非理想因素正越来越限制着这类系统的速度和精度，使当今的模拟电路设计深受布局和封装的影响。

在本文，我们便来探讨 layout 和 packaging 的基本原则，眼睛当模拟和数字电路共存于一个芯片上时所显现出来的寄生效应。为了简洁起见，我们使用“模拟”一词来指代“模拟”和“混合信号”。

## 1. General Considerations

### 1.1 Design Rules

一个基本 PMOS 的 layout geometries 包括了：
- 1. n-well (n 阱)
- 2. polysilicon (多晶硅)
- 3. active area (有源区)
- 4. n+ and p+ implants (N/P 注入区)
- 5. interlayer contact windows (接触点)
- 6. metal layers (金属连线)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-24-23-37-12_An Intruduction to Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-18-16-12_An Intruduction to Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-19-10-17_An Intruduction to Layout.png"/></div>


`shift + m` 可以合并同网络金属连线，显著提高布局可读性。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-02-59_An Intruduction to Layout.png"/></div>

图 19.7 概括了有关 NMOS 差分对 (以及 PMOS 电流源负载) 部分布局规则。现代 CMOS 技术通常包含数百条布局设计规则。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-01-11_An Intruduction to Layout.png"/></div>

### 1.2 Antenna Effect

假设一个小型 MOSFET 的栅极与一个面积较大的金属 1 连接线相连（如图 19.8(a) 所示）。在金属 1 的蚀刻过程中，该金属区域充当“天线”的角色，能够收集离子并使电位升高。因此，有可能 MOS 器件的栅极电压会大幅上升，以至于在制造过程中栅极氧化层会发生不可逆的损坏。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-05-21_An Intruduction to Layout.png"/></div>


这种“天线效应”可能发生在任何与栅极相连的大型导电材料上，包括硅这种材料本身。因此，亚微米级的 CMOS 技术通常会限制此类几何结构的总面积，从而将栅极氧化层受损的概率降至最低。如果不可避免地要使用大面积的这种结构，那么可以像图 19.8(b) 所示那样制造一个断点，这样在蚀刻金属 1 时，大面积区域就不会与栅极相连。

## 2. Layout Techniques

### 2.1 Multifinger Transistor

关于如何 **Chaining Devices Interactively**, 详见 [Cadence Virtuoso Layout Suite XL User Guide.pdf](https://picture.iczhiku.com/resource/eetop/WYifYSQEuQhIQVBv.pdf) 的 page 195. 关于如何  **create dummy fingers**, 详见 


正如第二章所述，宽型晶体管通常会“折叠”处理，以降低漏极/源极结的面积以及栅极电阻。像图 19.9(a) 中那样的简单折叠结构可能对于非常宽的器件来说是不够的，因此需要使用多个 finger [图 19.9(b)], 也称 "interdigitization"。作为一条经验定律，每个 finger 的宽度应选择为使该 finger 的栅极电阻小于该 finger 的跨导电阻 (即 $R_{gate} < \frac{1}{g_{m}}$)。在低噪声应用中，栅极电阻 $R_{gate}$ 必须是 $\frac{1}{g_m}$ 的五分之一到十分之一。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-12-06_An Intruduction to Layout.png"/></div>


虽然将晶体管分解为更多的 finger 可以降低栅极电阻，但与源/漏区域周长相关的电容会增加。如图 19.10 所示的结构为例，有三个电极时，源或漏的总周长等于 2(2E + 2W/3) = 4E + 4W/3，而有五个电极时，则等于 3(2E + 2W/5) = 6E + 6W/5。

一般来说，对于 finger 数量为奇数 N 的情况, S/D 周边电容的计算公式为：

$$
\begin{gather}
C_P = \frac{N + 1}{2}\left(2 E + \frac{2W}{N}\right)C_{jsw} = \left[(N + 1)E + \left(1 + \frac{1}{N}\right)W\right]C_{jsw}
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-22-20_An Intruduction to Layout.png"/></div>

因此，finger 数量乘以 E 的结果必须远小于 W, 这样才能最大程度地减少 S/D 周边电容的贡献。在实际操作中，这一要求可能会与最小化栅极电阻噪声的要求相冲突，这就需要在两者之间做出权衡，或者在栅极两端进行接触以降低电阻。

当器件的 finger 数过高时，可以通过 multiplier 将一组 finger 分为两组或更多组，以避免器件过长导致匹配性降低。

### 2.2 Layout Symmetry

回顾第 14 章可知，全差分电路中的不对称性会导致输入相关的失调，从而限制了能够检测到的最小信号电平。虽然一些失配是不可避免的，但在布局设计中对对称性的关注不足可能会导致较大的失调——其数值远大于第 14 章中基于统计方法所预测的值。对称性还能抑制共模噪声和偶次非线性的影响。需要注意的是，对称性必须同时应用于所关注的器件及其周围环境。我们稍后会回到这个话题。


让我们以图 19.13(a) 中的差分对为例。如图 19.13(b) 所示，如果将两个晶体管的布局设置为不同的方向，那么匹配效果会大打折扣，因为光刻和晶圆加工过程中的许多步骤在不同的轴上表现会有所不同。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-28-23_An Intruduction to Layout.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-29-27_An Intruduction to Layout.png"/></div>

图 19.15(b) 中结构所固有的不对称性可以通过在两侧添加 “dummy” 晶体管来得到改善，这样 M1 和 M2 就能大致处于相同的环境中 (图 19.16)。然而，在更复杂的电路中，例如在 folded-cascode op amp 中，此类措施并不容易应用。我们稍后会看到，一种更简单的 “dummy” 版本在当今的技术中证明是有用且至关重要的。除此之外，我们还要强调在对称轴两侧保持相同环境的重要性，因为这会显著影响晶体管的匹配性。

对于大型晶体管而言，实现对称性变得更加困难。例如，在图 19.18 所示的差分对中，两个晶体管的宽度较大，以实现较小的输入失调电压，但沿 x 轴的梯度会导致明显的不匹配。为了减少误差，可以采用“共心”布局，即消除沿两个轴的第一阶梯度的影响。如图 19.19 所示，该方法是将每个晶体管分解为两个相对放置且相互平行连接的半部分。


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-33-13_An Intruduction to Layout.png"/></div>

然而，这种布局中的金属布线相当困难，常常会导致类似于图 19.17(a) 中所示的系统性不对称性，或者来自导线到地以及导线之间的电容变化。对于较大的电路，例如运算放大器，布线可能会变得极其复杂。因此，我们希望寻求更简单的解决方案。

线性渐变的效果可以通过“一维”交叉耦合来抑制，如图 19.20 所示。在此，所有四个半晶体管都沿同一轴排列，M1 和 M2 通过连接近端和远端的器件 [图 19.20(a)] 或每隔一个连接的器件 [图 19.20(b)] 而形成，这种类型的交叉耦合会抵消一阶梯度效应 (线性效应)。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-37-06_An Intruduction to Layout.png"/></div>

### 2.3 Trench Isolation

现代的 MOS 器件周围环绕着一层浅“沟槽”，以避免相邻晶体管之间形成导电通道，如图 19.21(a) 所示。这种被称为 “浅沟槽隔离” (STI) 的结构是自动形成的，内部填充着氧化物，其热膨胀系数与硅不同。因此，在制造过程中, STI 与所包围的硅区域会以不同的方式膨胀和收缩。这种由 STI 引起的“应力”改变了 MOS 器件的电气特性，导致其 I/V 特性出现显著误差。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-41-12_An Intruduction to Layout.png"/></div>

为了缓解这一问题，我们必须尽量减少应力向栅极区域的传播。为此，我们在主器件的两侧插入两个 dummy finger [图 19.21(b)]。这些 “dummy finger” 及其相关的 S/D 结点通常接地，以确保它们不会干扰主晶体管的正常工作。但请注意，这些 finger 栅极会增加到地的 S/D 电容值。对于采用较多 finger 的晶体管, dummy 栅极可以简单地添加到阵列的两端 [图 19.21(c)]。


### 2.4 Well Proximity Effects

正如第 18 章所解释的那样，n 型阱是通过在硅的暴露区域进行 N 型注入而形成的。未暴露的区域则被一层由氧化物和光刻胶组成的厚层所覆盖 [图 19.22(a)]。不幸的是，注入并非与晶圆呈 90 度角进行，因此会从由氧化物和光刻胶形成的壁面上反射，从而在 n 型阱中产生不均匀的掺杂。也就是说, n 型阱的边界区域与其中部区域的掺杂密度不同。因此，位于 n 型阱边缘附近的 PMOS 器件与位于阱中部的器件具有不同的 I/V 特性。我们称这种效应为“阱邻近”误差。例如，图 19.22(b) 中所示的电流镜装置会出现 M1 和 M2 或 M3 之间的不匹配，因为 M1 更受注入反射的影响。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-44-59_An Intruduction to Layout.png"/></div>

为减少“沟道邻近效应”，N 型漏极必须延伸至 PMOS 器件之外较远的位置。例如，图 19.22(b) 中的间距 A 可以设定为大于数个微米的尺寸。

### 2.5 Reference Distribution

在模拟系统中，各种构建模块的偏置电流和电压是由一个或多个带隙参考生成器提供的。在一块大芯片上分布这些参考信号会带来一系列重要问题。以图 19.23 所示的示例为例，IREF 是由带隙参考产生的，而 M1-Mn 则作为远离 MREF 且彼此独立的构建模块的偏置电流源。如果 ID1-IDn 与 IREF 的匹配性至关重要，那么沿接地线的电压降就必须予以考虑。实际上，对于连接到同一接地线的大量电路而言，电流源与 IREF 之间的系统性不匹配可能是不可接受的。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-50-29_An Intruduction to Layout.png"/></div>

为解决上述难题，参考信号可以设置在当前区域而非电压区域。如图 19.24 所示，其原理是将参考电流引导至构建单元附近，并在本地进行电流镜像操作。在目标位置，旁路电容可抑制长互连可能拾取到的任何噪声。将互连电阻与电流源串联起来，这种方法如果构建单元在芯片的不同区域密集排列，能够降低系统误差。然而, IREF1 和 IREF2 之间以及 MREF1 和 MREF2 之间的不匹配会引入误差。一般情况下，在大型系统中采用多个局部带隙参考电路的利远远大于弊，可以显著缓解布线问题。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-51-44_An Intruduction to Layout.png"/></div>

图 19.23 和 19.24 中的电路还有另一个问题与晶体管的排列方向有关。正如第 19.2.2 节所述，例如，图 19.23 中的 MREF 和 M1-Mn 如果方向不同，就会出现严重的不匹配现象。由于支路 1、2、……、n 可以单独布局，所以在整个芯片组装过程中，必须特别注意其电流源的方向。


图 19.23 和 19.24 中电流的缩放也需要仔细选择器件的尺寸和布局。假设图 19.23 中的电路需要 ID1 = 0.5\*IREF 和 ID2 = 2\*IREF 。那么我们如何根据 (W/L)REF 来选择 (W/L)1 和 (W/L)2 呢？参考第 2 章的内容，由于源/漏区域的侧向扩散，有效沟道长度比绘制长度少 2\*L_D, 这是一个基本无法控制的量。因此，为了避免大的不匹配，晶体管的长度必须相等，电流必须通过适当选择宽度来缩放。然后我们选择 W1 = 0.5\*WREF 和 W2 = 2\*WREF 。图 19.25 展示了在此示例中 MREF 、M1 和 M2 的布局方式，以确保合理的匹配。请注意，所有等效宽度都是一个单位值 Wu 的整数倍。晶体管 M1 与 MREF 相同，只是其一半的源极保持浮动（或连接到漏极）。同时，为进一步改善匹配性，可以围绕阵列设置一些 dummy transistor.


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-21-57-14_An Intruduction to Layout.png"/></div>

### 2.6 Passive Devices

使用硅化物封层的多晶硅电阻器具有高线性度、对基板的电容低以及相对较小的偏差。实际上，这些电阻器的线性度取决于其长度，因此在高精度应用中需要进行精确的测量和建模。

与其他器件一样，多晶硅电阻器的匹配取决于其尺寸。例如，长度和宽度均为几微米的电阻器通常会出现约 0.2% 的典型偏差。对于 MOS 器件布局所描述的大多数对称规则，同样适用于电阻器。例如，需要具有明确比例的电阻器必须由相同单元组成，并以并联或串联的方式排列（且方向相同）。

上述所研究的多晶硅结构的电阻由两部分组成：一是由于未硅化区域所产生的电阻，二是与两个接触点相关的电阻。如图 19.29(a) 所示，狭窄的接触窗口（在 40 纳米技术中约为 80nm × 80nm）导致金属 1 与硅化区域之间的界面电阻较高。这一部分难以控制，最好使其远小于第一部分。例如，图 19.29(a) 中结构的长度和宽度可以加倍，从而将总接触电阻减半，同时使未硅化区域的电阻保持大致不变 [图 19.29(b)]。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-22-03-53_An Intruduction to Layout.png"/></div>

多晶硅电阻的电阻率会随温度和工艺条件而变化，在设计时必须考虑到这种变化。具体而言，电阻的温度系数取决于掺杂类型和浓度，并且需要针对每种技术进行测量。典型的温度系数值在 p+ 掺杂为 +0.1%/°C，在 n+ 掺杂为 -0.1%/°C, 并且由工艺引起的变化通常小于 ±20%.

### 2.7 Interconnects

现代 CMOS 工艺通常提供非常多的金属层用于电路连接，但成本因素可能要求使用 8 或 9 层。在设计高精度和/或高速电路时，必须考虑到与导线相关的诸多影响因素。

下图是 "crosstalk" 的一个例子：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-22-19-20_An Intruduction to Layout.png"/></div>

通过使用两种技术可以减少串扰。首先，差分信号传输会将大部分串扰转化为共模干扰。例如，如果将图 19.40 中的电路修改为图 19.41 所示的电路，那么当 C1 = C'1 且 C2 = C'2 时，VA 和 VB 对 V+ 和 V- 的耦合不会产生差分误差。即使电容之间的偏差为 10%，差分干扰也比图 19.40 中的要小一个数量级。请注意，在布局中添加了一条虚拟导线，以在 CK 和 V- 输入之间创建与 CK 和 V + 输入之间相同的重叠电容。正如第 4 章所述，最好使用差分时钟来进一步抑制网络耦合。


第二种方法是通过布局来“屏蔽”其它支路对某一路的干扰。如图 19.42(a) 所示，一种方法是将接地线布置在信号的两侧，这样会使从“有干扰”的线路发出的大部分电场线终止在地线上，而非信号线上。请注意，这种方法比仅仅给信号和有干扰的线路之间留出更多空间要更有效[图 19.42(b)]。然而，这种屏蔽是以更复杂的布线和信号与地之间的更大电容为代价的。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-22-21-47_An Intruduction to Layout.png"/></div>

图 19.43 展示了第二种屏蔽技术。在此技术中，金属 6 中的敏感线路被一个接地屏蔽层所包围，该屏蔽层由上层和下层金属构成，从而与外部电场线完全隔离。但是，该信号与地的电容值更高，而且这里使用三层金属层会使其他信号的布线变得复杂。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-22-21-58_An Intruduction to Layout.png"/></div>


金属连线的电阻也需要引起注意。在低噪声应用中，长的信号线（其电阻值在 40 mΩ/□ 至 80 mΩ/□ 之间）可能会引入大量的热噪声。此外，接触点和过孔也存在较高的电阻。例如，一个 80nm x 80nm 的金属接触点与硅化多晶硅的接触电阻约为 30 Ohm ~ 40 Ohm, 而金属 1 和金属 2 之间的过孔电阻为 5 Ohm ~  10 Ohm.

另外，长线路的分布电阻和电容可能会导致信号出现显著的延迟和 “分散” (dispersion)。“分散”这一术语指的是信号在通过线路传输过程中，其转换时间出现显著延长的现象。如果要以时钟边沿来确定采样点，那么这种现象就尤为令人困扰。通过在 CK 与每个开关之间插入一个反相器，可以对时钟边缘进行细化处理，但这样做会带来 CK 与 Vin 之间延迟差异更大的不确定性。


举一个例子，如图 19.45 所示，线路的延迟可近似表示为:

$$
\begin{gather}
T_D = \frac{1}{2}RC = \frac{1}{2}R_uC_u L^2
\end{gather}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-23-40-37_An Intruduction to Layout.png"/></div>

其中 $R_u$ 和 $C_u$ 分别表示单位长度的电阻和电容, L 为线路总长度。例如，考虑图 19.46 所示的电路，其中一组采样器检测模拟输入 Vin 并由 CK 激活。如果 CK 和 Vin 从左侧到右侧经历的延迟不相等，那么 C1, ..., Cn 所采样的电平也会不相等，从而使采样波形失真。即使时钟和信号线及其电容负载完全相同, CK 和 Vin 仍可能因前者为矩形波而后者不是而出现延迟不相等的情况。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-23-42-44_An Intruduction to Layout.png"/></div>



### 2.8 Pads and ESD

集成电路与外部环境之间的接口涉及诸多重要问题。为了在芯片上连接引线键合，会在芯片的周边区域放置较大的“焊盘”，并将其与电路中的相应节点相连 (图 19.48)。

贴片的尺寸和结构是由可靠性问题以及引线焊接过程中制造公差的余量所决定的。由于引线直径在 25um 至 50um 之间，最小的贴片尺寸大约在 70um × 70um 到 100um × 100um 之间。相邻的贴片通常至少相隔 25um. 从电路设计的角度来看，贴片的尺寸必须最小化，以降低贴片到基板的电容以及整个芯片的面积。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-23-50-20_An Intruduction to Layout.png"/></div>

一个简单的焊盘仅由位于顶层金属层上的一个方形构成。然而，这种结构在焊接过程中容易出现“脱落”现象。因此，每个焊盘通常由最上面的两层金属构成，并通过周边的许多小过孔相互连接 (图 19.49)。请注意，这种结构与仅由顶层金属层构成的焊盘相比，对基板的电容更大。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-23-50-54_An Intruduction to Layout.png"/></div>


集成电路与外部环境之间的接口还存在静电放电 (ESD, electrostatic discharge) 的问题。这种现象常发生在外部具有高电位的物体接触到电路的某处连接时。由于每个输入或输出端所呈现的电容都很小，静电放电会产生巨大的电压，从而损坏芯片上制造的器件。

ESD 的一种常见情况发生在人类操作集成电路时。在这种情况下，人体可以被模拟为由几百皮法的电容与几千欧姆的电阻串联而成的电路。根据环境的不同，电容两端的电压范围从几百伏到几千伏不等。因此，如果一个人接触到连接到芯片的导线，芯片很容易受损。有趣的是，即使没有实际接触，静电放电也可能发生，因为在高电场环境下，如果手指足够靠近导线，人的手指会在空气中“电弧”到连接处。

ESD 可能对 MOS 器件造成两种永久性损坏。第一种情况，如果电场强度超过约 10^7 V/cm, 也就是 20 A (埃米) 的 oxide 上承受了 2 V 的电压，栅极氧化层可能会被击穿，导致栅极与沟道之间的电阻变得非常低 (短路)。其次，如果源极/漏极的 pn 结二极管在正向或反向偏置时承受较大电流，它们可能会熔化，从而形成与衬底的短路。对于当今的短沟道器件，这两种现象都有可能发生。

为了缓解静电放电的问题, CMOS 电路会配备静电放电保护装置。如图 19.52 所示，这些装置会将外部放电限制到地或 VDD 电平，从而限制施加到电路上的电压。通常需要电阻 R1 来避免因外部电源产生的大电流而损坏二极管 D1 或 D2。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-25-23-56-43_An Intruduction to Layout.png"/></div>

## 3. Substrate Coupling

大多数现代的 CMOS 技术都采用高掺杂的 p+ 基底层来降低闩锁效应的可能性。然而，该基底的低电阻率 (约为 0.1 Ohm*cm) 会在电路中的各个器件之间形成不必要的连接路径，从而破坏敏感信号。这种现象被称为“基底耦合”或“基底噪声”，在当今的混合信号集成电路中已成为一个严重的问题。

为了最大程度地减少衬底噪声的影响，可以采用以下方法。首先，在整个电路中应采用差分运算，使模拟部分对共模噪声的敏感度降低。其次，数字信号和时钟应以互补形式分布，从而减少耦合噪声的总量。第三，关键操作，例如对信号进行采样或将电荷从一个电容转移到另一个电容，应在时钟转换后良好执行，以使衬底电压稳定下来。第四，连接到衬底的引线电感应尽量减小（第 19.4 节）。此外，使用 PMOS 差分输入的运算放大器更受欢迎，因为晶体管的漏极可以与它们的公共源相连，从而减少衬底噪声的影响。

在轻掺杂衬底上制造的电路中，可以采用“保护环” (guard ring) 来将敏感部分与由其他部分产生的衬底噪声隔离开来。 Guard ring 可以是一个简单的连续环，由衬底连接线构成，环绕整个电路，为衬底中产生的电荷载流子提供一条低阻抗的接地路径。由于其深度较大, n well 还可以通过阻止靠近表面的噪声电流的流动来增强 guard ring 的作用 (图 19.55)。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-26-00-04-22_An Intruduction to Layout.png"/></div>

## References


- [1] N. C. C. Lu et al., “Modeling and Optimization of Monolithic Polycrystalline Silicon Resistors,” IEEE Trans. Electron Devices, vol. ED-28, pp. 818–830, July 1981. 
- [2] D. Su et al., “Experimental Results and Modeling Techniques for Substrate Noise in Mixed-Signal Integrated Cicuits,” IEEE J. of Solid-State Circuits, vol. 28, pp. 420–430, April 1993. 
- [3] T. Blalack and B. A. Wooley, “The Effects of Switching Noise on an Oversampling A/D Converter,” ISSCC Dig. of Tech. Papers, pp. 200–201, February 1995.  
- [4] B. Razavi, Principles of Data Conversion System Design (New York: IEEE Press, 1995).  
- [5] D. W. Dobberpuhl, “Circuits and Technology for Digital’s StrongARM and ALPHA Microprocessors,” Proc. of 17th Conference on Advanced Research in VLSI, pp. 2–11, September 1997.  
- [6] N. K. Verghese, T. J. Schmerbeck, and D. J. Allstot, Simulation Techniques and Solutions for Mixed-Signal Coupling in Integrated Circuits (Boston: Kluwer Academic Publishers, 1995).