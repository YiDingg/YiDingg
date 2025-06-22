# How to Use ADE Assembler to Enhance Your Simulation Efficiency

> [!Note|style:callout|label:Infor]
> Initially published at 12:09 on 2025-06-20 in Beijing.


## Learn ADE Assembler 

### 1. background

随着模拟 IC 设计的复杂性不断增加，传统的 ADE L/XL/GXL 工具在某些方面已经无法满足设计师的需求。为了解决这一问题, Cadence 推出了 ADE Explorer 和 ADE Assembler, 这两个工具旨在提供更强大的功能和更高的仿真效率。本文就来详细介绍“如何使用 ADE Assembler 进行基本仿真操作”、“如何使用 ADE Assembler 进行进阶仿真” 以及 “如何使用 ADE Assembler 提高仿真效率”。

虽然 Cadence 推出 ADE Explorer 和 ADE Assembler 已经有一段时间，但我所看到的大部分模拟 IC 设计人员仍在使用传统 (旧版本) 的 ADE L/XL/GXL, 并不是说使用旧版工具就不好，而是学习新版本的工具有助于我们提高工作效率和设计质量。那么，学习 ADE Assembler 究竟值不值得呢？

### 2. why using ADE assembler?



作为传统工具 ADE L/XL/GXL (基于 spectre 仿真器) 的替代, ADE Explorer 是基于 maestro 管理平台的新一代基础仿真工具，主要用于简单的仿真分析，如 dc, ac, tran, noise 和 mc 等，适合快速验证和小规模设计。相比之下, ADE Assembler 是更高级的仿真工具，它在包含 ADE Explorer 所有功能的基础上，增加了更多高级特性，理论上可以完全替代 ADE Explorer 。对于大多数现代 IC 设计，尤其是需要复杂分析和可靠性验证的场景, Assembler 是更优选择，能够显著提升仿真效率和数据分析能力。


### 3. learning maps

官方给出的 analog design and simulation learning map 如下 (from [this link](https://www.cadence.com/content/dam/cadence-www/global/en_US/documents/training/learning-maps.pdf))：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-01-29-20_How to Use ADE Explorer and ADE Assembler to Enhance Your Simulation Efficiency.png"/></div>

上图仅仅是 learning map 的 page 1 of 3, 可以点击 PDF 中的超链接直接跳转至官方教程。

**遗憾的是，所有的教程都需要 Cadence Host ID 或 Reference/LMS Key 才能访问，也就是需要正版软件授权。** 如何解决这个问题？事实上，我们在文章 [How to Install Cadence IC618](<AnalogIC/Virtuoso Tutorials - 1. How to Install Cadence IC618.md>) 中提供的安装包，就 **<span style='color:red'> 自带包括 ADE Assembler 在内的所有官方资料和相关教程</span>**。

### 4. learning method 1

如何打开这些资料？一种访问方法是在虚拟机中打开 virtuoso, 然后点击 `CIW > Help > User Guide`, 即打开帮助页面，然后在上分搜索栏输入你想要查找的内容。作为本文的主要内容，我们搜索 "ADE Assembler", 结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-11-42-14_Use ADE Explorer and ADE Assembler to Enhance Your Simulation Efficiency.png"/></div>

第一篇便是我们最感兴趣的 "User Guide", 也就是 ADE Assembler 的官方教程。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-12-02-19_How to Use ADE Assembler to Enhance Your Simulation Efficiency.png"/></div>


其它仿真软件，例如 ADE L/XL/GXL 的资料也可以在帮助页面中找到，我们不多赘述。

### 5. learning method 2

第二种方法是直接打开 PDF 文件。到路径 `/opt/eda/cadence/IC618/doc/assembler/` 下找到 `assembler.pdf` 文件打开即可，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-12-15-22_How to Use ADE Assembler to Enhance Your Simulation Efficiency.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-06-20-12-15-32_How to Use ADE Assembler to Enhance Your Simulation Efficiency.png"/></div>



为方便读者学习，我们已将 ADE Assembler 和 ADE Explorer 的官方文档上传到了 [123 云盘](https://www.123684.com/s/0y0pTd-16Uj3)，点击即可下载 (无需登录)。相应地，读者在也可 `/opt/eda/cadence/IC618/doc/` 路径下找到 ADE Explorer, ADE L/XL/GXL 的 PDF User Guide 文件，我们不多赘述。


**上面所介绍的两种方法，其内容都是相同的，并且在虚拟机环境下，文档内部的超链接全部可以正常打开。读者可根据自身情况，选择合适的方法进行学习。**


## Frequently Asked Questions

### **问题 (1): cadence virtuoso 中 ADE Explorer, ADE Assembler 分别是什么，它们与传统的 ADE L, XL 和 GXL 的区别在哪里？**

**回答 (1.1): 2025.06.20 由 Kimi 生成：**

在Cadence Virtuoso中，ADE Explorer和ADE Assembler是两种重要的仿真工具。ADE Explorer是一个交互式设计环境，它整合了单次仿真、corners、sweeps、蒙特卡罗以及参数对比等功能，能够快速、精确地实现设计参数实时调节，并自动生成合格/不合格设计的数据列表。而ADE Assembler则主要取代了之前的ADE XL以及ADE GXL功能，它具有更高的自由度，可以在右侧同时添加多个ADE Explorer，每个ADE Explorer对应着一个Test，可以实现同时运行多种不同性能参数的仿真。

与传统的ADE L、XL和GXL相比，ADE Explorer和ADE Assembler有以下区别：ADE L主要用于单一测试，而ADE Explorer整合了ADE L和ADE XL的功能，在功能上更加全面和强大。ADE XL支持更广范围的工艺环境和工作条件，支持多仿真器多测试和多条件交叉分析，但ADE Assembler在功能上对ADE XL进行了替代和扩展，它不仅包含了ADE XL的功能，还增加了对ADE GXL功能的支持。ADE GXL则在ADE XL的基础上增加了寄生参数分析和敏感度分析等功能，这些功能在ADE Assembler中也得到了保留和进一步的优化。总的来说，ADE Explorer和ADE Assembler在功能整合和仿真效率上有了显著的提升，为用户提供了更加强大和灵活的仿真工具。

**回答 (1.2): 2025.06.20 由 DeepSeek 生成：**

在Cadence Virtuoso设计环境中，ADE Explorer和ADE Assembler是较新的仿真工具，用于替代传统的ADE L、XL和GXL。ADE Explorer是基础版本的仿真工具，提供了基本的仿真功能，适用于简单的设计验证任务。它允许用户设置仿真参数、运行仿真并查看结果，但功能相对有限。ADE Assembler则是一个更高级的工具，支持多测试场景的并行仿真、复杂的优化和分析功能，适用于更复杂的设计需求。它集成了更多的自动化功能，能够显著提高设计验证的效率。  

传统的ADE L、XL和GXL是较早版本的仿真工具，功能逐渐增强。ADE L是最基础的版本，仅支持单点仿真；ADE XL增加了多测试管理和优化功能；而ADE GXL进一步扩展了高级分析和优化能力，支持更复杂的仿真需求。相比之下，ADE Explorer和ADE Assembler采用了更现代化的用户界面和更高效的仿真引擎，同时整合了更多先进功能，如机器学习辅助优化和更灵活的数据分析工具。此外，新工具在与其他Cadence平台 (如Virtuoso ADE Suite) 的集成上也更为紧密，提供了更流畅的工作流程。  

总的来说，ADE Explorer和ADE Assembler是Cadence对传统ADE工具的升级，不仅在功能上有所增强，还在用户体验和集成度上进行了优化，使仿真和验证过程更加高效和灵活。


### **问题 (2): cadence virtuoso 中, ADE Assembler 和 ADE Explorer 的关系是什么，能不能用 Assembler 完全替代 Explorer?**

**回答 (2): 2025.06.20 由 DeepSeek 生成：**

ADE Explorer 是基础仿真工具，主要用于简单的电路分析，如 DC、AC、瞬态和噪声仿真，适合快速验证和小规模设计。相比之下，ADE Assembler 是更高级的仿真环境，在 ADE Explorer 的基础上扩展了诸多功能，使其适用于更复杂的电路设计需求。由于 ADE Assembler 涵盖了 ADE Explorer 的所有功能，并增加了高级特性，理论上它可以完全替代 ADE Explorer。对于大多数现代 IC 设计，尤其是需要复杂分析和可靠性验证的场景，Assembler 是更优选择，能够显著提升仿真效率和数据分析能力。


### **问题 (3): cadence virtuoso 中的 spectre 和 maestro 是什么，它们的区别在哪里？**

**回答 (3): 2025.06.20 由 DeepSeek 生成：**

**Spectre** 是 Cadence Virtuoso 平台中的高性能 **SPICE 级电路仿真器**，主要用于模拟、混合信号 (AMS) 和射频 (RF) 电路的晶体管级仿真。它支持多种分析类型，包括直流 (DC) 、交流 (AC) 、瞬态 (Transient) 、噪声 (Noise) 、蒙特卡洛 (Monte Carlo) 以及可靠性分析 (如老化、电迁移等) 。Spectre 通常集成在 **ADE Explorer/Assembler** 环境中使用，也可通过命令行独立运行，并支持多核并行加速 (如 APS 和 Spectre X 技术) ，适用于高精度、大规模 IC 设计。  

**Maestro** 则是 Cadence 提供的 **仿真流程管理与自动化工具**，主要用于 **AMS (模拟混合信号) ** 和 **数字协同仿真** (如 Virtuoso AMS Designer) 。它不直接执行仿真，而是作为管理平台，帮助用户自动化仿真任务 (如多工艺角分析、PVT 扫描、回归测试等) ，并支持与多种仿真引擎 (包括 Spectre、APS、Xcelium 等) 的集成。Maestro 的优势在于 **批量仿真管理** 和 **数据后处理**，适用于复杂设计验证和量产前的芯片验证流程。  

**主要区别**  
1. **功能定位**：  
   - Spectre 是 **仿真引擎**，负责执行电路仿真计算。  
   - Maestro 是 **流程管理工具**，负责调度、自动化和管理仿真任务。  
2. **使用场景**：  
   - Spectre 用于单次或交互式仿真 (如调试电路性能) 。  
   - Maestro 用于批量仿真 (如同时跑数百个工艺角或蒙特卡洛样本) 。  
3. **集成方式**：  
   - Spectre 通常通过 ADE 调用，也可独立运行。  
   - Maestro 通常与 Virtuoso AMS Designer 或大型验证流程结合使用。  

简言之，**Spectre 是“计算工具”，而 Maestro 是“调度工具”**，两者常配合使用以提高仿真效率。

### **问题 (4): xxx**

## Relevant Resources

### Official Resources

官方介绍：
- [Virtuoso ADE Assembler Datasheet](https://login.cadence.com/content/dam/cadence-www/global/en_US/documents/tools/custom-ic-analog-rf-design/virtuoso-ade-assembler-ds.pdf)
- [Virtuoso ADE Explorer Datasheet](https://login.cadence.com/content/dam/cadence-www/global/en_US/documents/tools/custom-ic-analog-rf-design/virtuoso-ade-explorer-ds.pdf)

官方学习路线：
- [Cadence Course Learning Maps](https://www.cadence.com/content/dam/cadence-www/global/en_US/documents/training/learning-maps.pdf)


官方教程：
- [Virtuoso Schematic Editor Training](https://www.cadence.com/en_US/home/training/all-courses/84443.html)
- [Virtuoso ADE Explorer and Assembler S1: ADE Explorer and Single Test Corner Analysis Training](https://www.cadence.com/en_US/home/training/all-courses/86253.html)
- [Virtuoso ADE Explorer and Assembler S2: ADE Assembler and Multi Test Corner Analysis Training](https://www.cadence.com/en_US/home/training/all-courses/86254.html)
- [Virtuoso ADE Explorer and Assembler S3: Sweeping Variables and Simulating Corners Training](https://www.cadence.com/en_US/home/training/all-courses/86255.html)
- [Virtuoso ADE Explorer and Assembler S4: Monte Carlo Analysis, Real-Time Tuning and Run Plans Training](https://www.cadence.com/en_US/home/training/all-courses/86256.html)
- [Analyzing Simulation Results Using Virtuoso Visualization and Analysis Training](https://www.cadence.com/en_US/home/training/all-courses/85040.html)

其它官方文档：
- [Virtuoso Analog Design Environment XL User Guide (Product Version 6.1.6 August 2014)](https://picture.iczhiku.com/resource/eetop/syIfptILiLPyrvCB.pdf)
- [Virtuoso® Spectre® Circuit Simulator and Accelerated Parallel Simulator User Guide (Product Version 10.1.1 June 2011)](https://picture.iczhiku.com/resource/eetop/wYkfLuEsZIWWJBVC.pdf)
- [Virtuoso Visualization and Analysis XL User Guide (Product Version 6.1.5 January 2012)](https://home.engineering.iastate.edu/~hmeng/EE501lab/TAHelp/wavescanug.pdf)

### Relevant Articles

- [Analog-Life > Cadence maestro 快速仿真实用教程 (ADE Explorer 与 ADE Assembler)](https://www.analog-life.com/2025/02/improve-simulation-efficiency-with-cadence-maestro/)
- [知乎 > 模拟仿真 ADE Explorer 和 Assembler 的一些小技巧](https://zhuanlan.zhihu.com/p/372495688)
- [CSDN > virtuoso 学习笔记 (ADE Explorer)](https://blog.csdn.net/qingyangxuqiang/article/details/144115569)
- [书籍《 Cadence Virtuoso 使用手册》](https://bbs.eetop.cn/thread-963855-1-1.html)
- [Cadence IC Design Manual using ADE L (June, 2020)](https://cde.nus.edu.sg/ece/wp-content/uploads/sites/3/2024/09/SimulationManualWithCadenceTools.pdf)