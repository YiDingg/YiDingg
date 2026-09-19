# ISSCC Submission Checklist

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 23:46 on 2026-08-08 in LinCang.

## 1. Submission Process

ISSCC 一般需要提交：
1. manuscript: `.pdf` 格式正文，建议用 word 来写，要求 Arial Narrow 12pt、单栏、双倍行距，且连带标题的 "字符数 (计空格)" ≤ 指定值，标题建议 12~14 words 且排版不要超出两行
2. figure: 七张图放到模板里然后导出为 `.pdf` 格式 (另可选不超过三张补充图)，需要使用官网模板
3. abstract: ≤ 500 words
4. xx



## x. ISSCC Tips

- LaTex 模版：[知乎 > isscc latex 和 typst 模板](https://zhuanlan.zhihu.com/p/1950135013178844792)


## 2. Check List for ISSCC'2027

### 2.1 check list

**关于注意事项，重点阅读当年的几个文件 (重要性依次递减)：**
1. ISSCC'2027 Sample Draft Manuscript
2. ISSCC2027 Call For Papers
3. ISSCC2027 Author Instructions And FAQ
4. ISSCC2027 Writing Good ISSCC Paper


下面是 Check List:
1. manuscript:
    - [x] Arial Narrow
    - [ ] 正文 12pt，标题 12 pt 加粗
    - [x] 单栏、双倍行距，≤ 5 页
    - [x] 连带标题的 "字符数 (计空格)" ≤ 11000 (今年是 11000, 往年是 10000)
    - [x] 标题排版不要超出两行
    - [ ] 标题包括 introduction 在一页以内 (不严格要求)，第二页开头就是第二段
2. figure:
    - [ ] 尺寸比例约 5:4 = 300:240 (Visio 建议尺寸 300mm x 240mm, 待定???)
    - [x] 七张大图必须在正文引用并解释
    - [x] Do not use subfigure labels (a, b, c, …; 1, 2, 3, …) .
    - [x] 七张图中至少含有一个晶体管级电路
    - [ ] 检查导出为 `.pdf` 后是否清晰无错漏 (只能上传 `.pdf` 文件)
    - [x] figure density check (2027 新规): 
        - 今年新加入的图片密度要求，需要“过”官方给的密度检查器 [ISSCC Figure Density Check Tool](https://www.isscc.org/figures)，检查结果不作为评审标准，只是让你自己看一下各方面是否合适、pdf 降采样后是否可辨认
        - ISSCC 审稿人会以打印尺寸阅读您的图表，因此清晰度和可辨识度将直接影响评审结果 [ISSCC > Figures](https://www.isscc.org/figures)
    - [ ] 去除 pdf 中的可编辑信息 (扁平化)：[https://www.i2pdf.com/flatten-pdf](https://www.i2pdf.com/flatten-pdf)
    - [ ] 三张可选的补充图不得在正文中出现
    - [x] 正文中需用 `Fig. 1` (有空格) 而不是 `Fig.1` 或者 `Figure.1` (经导师核实，初稿应该不需要空格，后面编辑给你处理)
3. abstract: 
    - "字符数 (计空格)" ≤ 500
4. reference 格式：下面是几个例子
    - 最多 30 条，在投稿网站单独输入，正文中不得包含参考文献列表，下面是几个格式示例 (文章标题结尾处，逗号应在右引号前面，因为 IEEE 自己的官网 cite 就是这样)：
        - [1] B. Ye et al., “A 1.11pJ/b 224Gb/s XSR Receiver with Slice-Based CTLE and PI-Based Clock Generator in 12nm CMOS,” IEEE ISSCC, pp. 140-142, 2025. https://doi.org/10.1109/ISSCC49661.2025.10904800
        - [20] Z. Zhang et al., “A 64-Gb/s Reference-Less PAM4 CDR with Asymmetrical Linear Phase Detector Soring 231.5-fsrms Clock Jitter and 0.21-pJ/bit Energy Efficiency in 40-nm CMOS,” IEEE VLSI, pp. 1-2, 2023. https://doi.org/10.23919/VLSITechnologyandCir57934.2023.10185285
        - [22] K. Park, D. -K. Jeong, “Analysis of frequency detection capability of Alexander phase detector,” Electronics Letters vol. 56, no. 4, pp. 180-182, Feb. 2020. https://doi.org/10.1049/el.2019.3488
    - 在 Mirasmart Submission Website 提交参考文献的直接访问链接示例：“https://doi.org/10.1109/ISSCC42615.2023.10067724” or “doi.org/10.1109/ISSCC42615.2023.10067724”.
5. 其它:
    - 严格匿名：不允许出现任何作者名、单位、联系方式、Logo、致谢、基金来源等个人/组织信息
    - 提交前删除 pdf 元信息 (标题，作者等)
    - 以第三人称引用自己的工作
    - 不得联系所在机构之外的 TPC 成员 (违者直接拒稿)
    - (2027 新规) 提交时必须声明与所投分委会 ITPC 成员之间的潜在利益冲突 (conflict of interest, COI)


### 2.2 resources

资源下载：
- Downloadable templates and documents for your submission: [ISSCC Paper Submission](https://www.isscc.org/paper-submission-26)
    - [Draft Sample Manuscript (.pdf)](https://submissions.mirasmart.com/ISSCC2027/PDF/ISSCC2027-SampleDraftManuscript.pdf)
    - [Figure Template (.docx)](https://submissions.mirasmart.com/ISSCC2027/PDF/ISSCC2027_FiguresTemplate.docx)
    - [Sample Abstract (.pdf)](https://submissions.mirasmart.com/ISSCC2027/PDF/ISSCC2027-SampleAbstract.pdf)
    - [ISSCC Figure Density Check](https://www.isscc.org/figures)


### 2.3 usage of figure density check tool

[ISSCC Figure Density Check](https://submissions.mirasmart.com/ISSCC2027/ISSCC_Figure_Density_Tool.html)，下面是一个例子：
- 初始尝试：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-08-11-16-49-14_ISSCC Submission Checklist.png"/></div>
- 将所有字符全部加粗：

### 2.4 else



除了manuscript和figure外还需要准备500个字符数以内的abstract，一个750字符数以内的作者biology，以及一段highlight（这个没有字符数限制，但是也需要精简，官网上有example）



注意call for paper写得deadline时间是美国时间，记得换算到国内时间
