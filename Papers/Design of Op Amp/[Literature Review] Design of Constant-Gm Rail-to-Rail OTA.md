# [Literature Review] Design of Constant-Gm Rail-to-Rail OTA

> [!Note|style:callout|label:Infor]
> Initially published at 23:42 on 2025-09-23 in Beijing.


## Introduction

最近有一个项目 [Design of A Constant-Gm Rail-to-Rail OTA for Low Pass Filters in BB-PLL](<Projects/Design of An Adjustable Constant-Gm OTA for Low Pass Filters in BB-PLL.md>) 需要设计 **Constant-Gm Rail-to-Rail OTA**，于是开始查阅相关文献。本文的主要目的是 **略读并总结相关文献中的架构和思路**，为后续设计工作提供参考。

## [1] Guo-Ding Dai

来自西电 CAD 研究所的一篇论文。

>The first idea in the literature to obtain a constant gm input stage was in [4]. A1:1 current mirror with a switch transistor operation in strong inversion gives a constant total input current and its gm variation is about 41% over the common input range. After that, a number of methods have been proposed, including: 1:3 current mirrors [5], DC level shift circuit [6], maximum/minimum current select circuit [7], and square root circuit [8], and so on.

>In this paper, we discuss the designed two-stage op-amp with a constant-gm rail-to-rail input stage and a simple class-AB output stage.

个人评价：
- 文章段落结构不够清晰，一大片文字放在一起，阅读体验不佳


## [2] Il Kwon Chang
## [3] Xiao Zhao
## [4] Wang Xichuan
## [5] L. Líber Malavolta
## [6] 

## Reference

- [1] G.-D. Dai, P. Huang, L. Yang, and B. Wang, “A Constant Gm CMOS Op-Amp with Rail-to-Rail input/output stage,” in 2010 10th IEEE International Conference on Solid-State and Integrated Circuit Technology, Shanghai, China: IEEE, Nov. 2010, pp. 123–125. doi: 10.1109/ICSICT.2010.5667830.
- [2] Il Kwon Chang, Jang Woo Park, Se Jun Kim, and Kae Dal Kwack, “A global operational amplifier with constant-gm input and output stage,” in Proceedings of IEEE. IEEE Region 10 Conference. TENCON 99. “Multimedia Technology for Asia-Pacific Information Infrastructure” (Cat. No.99CH37030), Cheju Island, South Korea: IEEE, 1999, pp. 1051–1054. doi: 10.1109/TENCON.1999.818603.
- [3] X. Zhao, H. Fang, and J. Xu, “A low power constant-Gm rail-to-rail operational transconductance amplifier by recycling current,” in 2011 IEEE International Conference of Electron Devices and Solid-State Circuits, Tianjin, China: IEEE, Nov. 2011, pp. 1–2. doi: 10.1109/EDSSC.2011.6117572.
- [4] W. Xichuan, D. Huan, and Z. Ting, “A Rail-To-Rail Op-Amp with Constant Gm Using Current Switches,” in High Density Design Packaging and Microsystem Integration, 2007 International Symposium on, IEEE, Jun. 2007, pp. 1–3. doi: 10.1109/HDP.2007.4283626.
- [5] L. L. Malavolta, R. L. Moreno, and T. C. Pimenta, “A self-biased operational amplifier of constant gm for 1.5 V rail-to-rail operation in 130nm CMOS,” in 2016 28th International Conference on Microelectronics (ICM), Giza, Egypt: IEEE, Dec. 2016, pp. 45–48. doi: 10.1109/ICM.2016.7847904.
- [6] J. Wang, L. Huang, and J. Li, “Constant- $g_{m}$ Rail-To-Rail Input/Output Operational Amplifier,” in 2025 IEEE 14th International Conference on Communications, Circuits and Systems (ICCCAS), Wuhan, China: IEEE, May 2025, pp. 87–92. doi: 10.1109/ICCCAS65806.2025.11102681.
- [7] J.-L. Lai, T.-Y. Lin, C.-F. Tai, Y.-T. Lai, and R.-J. Chen, “Design a low-noise operational amplifier with constant-gm”.
- [8] Y. Hao, S. He, and P. Xiao, “Design of a Constant-Gm Rail-to-Rail Operational Amplifier with Chopper Stabilization,” in 2025 5th International Conference on Electronics, Circuits and Information Engineering (ECIE), Guangzhou, China: IEEE, May 2025, pp. 583–587. doi: 10.1109/ECIE65947.2025.11086613.
- [9] Z. Wu, F. Rui, Z. Zhi-Yong, and C. Wei-Dong, “Design of a Rail-to-Rail Constant-gm CMOS Operational Amplifier,” in 2009 WRI World Congress on Computer Science and Information Engineering, Los Angeles, California USA: IEEE, 2009, pp. 198–201. doi: 10.1109/CSIE.2009.173.
- [10] A. C. Veselu, C. Stanescu, and G. Brezeanu, “Low Current Constant-gm Technique for Rail-to-Rail Operational Amplifiers,” in 2020 International Semiconductor Conference (CAS), Sinaia, Romania: IEEE, Oct. 2020, pp. 253–256. doi: 10.1109/CAS50358.2020.9267977.
- [11] N. Baxevanakis, I. Georgakopoulos, and P. P. Sotiriadis, “Rail-to-rail operational amplifier with stabilized frequency response and constant-gm input stage,” in 2017 Panhellenic Conference on Electronics and Telecommunications (PACET), Xanthi, Greece: IEEE, Nov. 2017, pp. 1–4. doi: 10.1109/PACET.2017.8259966.
