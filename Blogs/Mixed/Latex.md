# Latex 

> [!Note|style:callout|label:Infor]
Initially published at 22:43 on 2024-09-03 in Beijing.


本文环境：Windows 11 + Texlive 2023 + VSCode

## 调整公式字号大小

``` latex
\usepackage{graphicx} % Necessary to use \scalebox

normal: $ x^2 + 2xy + y^2 $
displaystyle: $ {\displaystyle x^2 + 2xy + y^2} $
scriptstyle: $ {\scriptstyle x^2 + 2xy + y^2} $
scriptscriptstyle: $ {\scriptscriptstyle x^2 + 2xy + y^2} $
textstyle: $ {\textstyle x^2 + 2xy + y^2} $
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-24-18-17-03_Latex.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-24-18-07-44_Latex.png"/></div>

## 多文档编译

推荐使用 `subfiles` 宏包，简单且实用。以下面的文章结构为例：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-12-07-16-40-38_Latex.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-12-07-16-40-23_Latex.png"/></div>

有几个需要注意的地方：
- 主文件名不能有空格或中文字符（否则会报错），但子文件可以有空格或中文字符
- 为了能够同时独立编译子文件和主文件，我们需要修改子文件的图片引入路径，具体见下文代码


下面给出一个代码示例，点击 [Subfiles Package Example.zip](https://www.writebug.com/static/uploads/2024/12/7/83e8bb98c5a885ffe622d592582e6dcd.zip) 以下载整个示例文件夹（压缩包）。

`main.tex` 如下：
``` latex
%%% 主文件 main.tex %%%

% 注意主文件名不能有空格或中文字符

\documentclass{article}
\usepackage{graphicx}

%\graphicspath{{assets/}}

% 如果习惯引入图片时直接输入图片文件名，应取消注释上面 \graphicspath{{assets/}} 一行，否则保留注释
% 例如我们的图片都放在 assets 文件夹下，其中有一张图片叫做 2024-08-15_13-50-23.pdf
% 那么在取消了注释后，应使用 \includegraphics{2024-08-15_13-50-23.pdf} 来引入图片
% 如果没有取消注释，则应使用 \includegraphics{assets/2024-08-15_13-50-23.pdf} 来引入图片


\usepackage{blindtext}
\usepackage{subfiles} % Best loaded last in the preamble

\title{Subfiles package example}
\author{YiDingg}
\date{2024.12.07}

\begin{document}

\maketitle

\subfile{Chapter/Chapter 1/Chapter 1.tex}
\subfile{Chapter/Chapter 2/Chapter 2.tex}

\end{document}
```

`Chapter 1.tex` 如下：
``` latex
%%% 子文件 Chapter 1.tex %%%

\documentclass[../main.tex]{subfiles}
%为了能正常分文档编译，主文件的文件名不能含有中文或空格，否则会报错
%在子文件中，指定主文件的正确路径应为 ../../main.tex, 但这样每次 ctrl+s 编译子文件时会弹出文件编译选择框, 比较麻烦。经过测试发现路径设置为 ../main.tex 时不仅能正常编译子文件（正常引入导言区），而且不会弹出文件编译选择框

\graphicspath{{\subfix{../../}}}
\begin{document}


\chapter{This Chapter 1}\thispagestyle{fancy}

\begin{figure}[bh]
\centering
\includegraphics[width=0.8\columnwidth]{assets/1N4007 Operation Chara 测试电路.pdf}
\label{fig:img1}
\caption{Test Circuits of 1N4007 Operation Characteristics}
\end{figure}

Hello, here is some text without a meaning...

Hello, here is some text without a meaning...

Hello, here is some text without a meaning...

Hello, here is some text without a meaning...

\end{document}
```

`Chapter 2.tex` 如下：
``` latex
\documentclass[../main.tex]{subfiles}
%为了能正常分文档编译，主文件的文件名不能含有中文或空格，否则会报错
%在子文件中，指定主文件的正确路径应为 ../../main.tex, 但这样每次 ctrl+s 编译子文件时会弹出文件编译选择框, 比较麻烦。经过测试发现路径设置为 ../main.tex 时不仅能正常编译子文件（正常引入导言区），而且不会弹出文件编译选择框

\graphicspath{{\subfix{../../}}}
\begin{document}

\chapter{This Chapter 1}\thispagestyle{fancy}

This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. 

\begin{figure}[bh]
\centering
\includegraphics[width=0.5\columnwidth]{assets/1N4007 Operation Chara 测试电路.pdf}
\label{fig:img1}
\caption{Test Circuits of 1N4007 Operation Characteristics}
\end{figure}

This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. This is chapter 2. 
\end{document}
```

`Chapter 1.tex` 单独编译的效果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-12-07-16-49-14_Latex.png"/></div>

`Chapter 2.tex` 单独编译的效果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-12-07-16-49-51_Latex.png"/></div>

`main.tex` 的编译效果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-12-07-16-50-42_Latex.png"/></div>

## 自定义目录 (TOC)

起因是需要在我的 Homework of Circuits Theory 中插入由 Notability 手写导出的 pdf，这一步我们使用了 `pdfpages` 中的 `\include` 命令，但是如何在目录中显示这个 pdf 的标题和页码呢？使用了常规的 `\addcontentsline{toc}{chapter}{Homework 10: 2024.11.06 - 2024.11.12}` 后意识到，标题是正常显示在目录里了，但是之前的几个 chapter 在目录中都是自带编号的，而这个 Homework 10 却没有。这便引起了前后编号的冲突，如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-11-10-01-00-52_Latex.jpg"/></div>

并且还有一个问题，`\addcontentsline` 后，由于 Latex 没有给 include 的 pdf 分配实际的页面空间，它的超链接是无法点击的（点击无任何效果）。这一个问题我们可以用 `pdfpages` 中的 `\phantomsection` 命令来解决，它的作用是添加虚拟节, 使得 pdf 书签定位正确。因此最后插入 pdf 的代码如下：

``` latex
\phantomsection % 添加虚拟节, 使得 pdf 书签定位正确
\addcontentsline{toc}{chapter}{Homework 11: 2024.11.06 - 2024.11.12} 
\includepdf[pages=-]{assets/Notability/电路原理   Homework 10 _ 2024.11.06 - 2024.11.12.pdf}
```


对第一个问题，我们需要对 TOC 进行样式上的设置，先后试过了 `tocloft` 和 `titletoc` 宏包，最终选择了 `titletoc`，因为它的使用更加简单，而且效果也很好。主要用的是 `\titlecontents` 命令，它的语法如下：

``` latex
\usepackage{titletoc}   % 用于设置 toc
 \titlecontents{x1: 需要设置的标题}
               [x2: 左间距(标题左侧的额外页边距)]
               {x3: 标题格式}
               {x4: 标题标志(前缀)}
               {x5: 无序号标题的前缀}
               {x6: 指引线与页码}
               [x7: 下间距]

% 下面是各参数的详细解释
% x1: 需要设置的标题 (广义), 如 chapter, section, subsection 等, 也可以是 figure, table 等
% x2: 左间距, 严谨的说是标题左侧的额外页边距, 我比较习惯 0pt (无额外间距)
% x3: 标题格式, 一般是 \normalfont\bfseries, 也可以是 \normalfont\itshape 等
% x4: 标题标志, 直接使用 \thecontentslabel 相当只输出此标题的编号 (一个数字), \contentslabel{2.5em} 会显示宽为 2.5em 的章节编号
% x5: 无序号标题的前缀, 字面意思
% x6: 指引线与页码, \contentspage 是页码 (一个数字); {\titlerule*[0.5pc]{\footnotesize .}\contentspage} 是一个例子, 0.5pc 表示 '.' 号的间隔, {\hfill \contentspage \vspace{10.5pt}} 可以达到默认行间距效果 (无 '...页码')
% x7: 下间距, 暂时没弄懂这个参数的格式, 可以自行翻阅官方文档 

% 官方文档：https://mirror.bjtu.edu.cn/CTAN/macros/latex/contrib/titlesec/titlesec.pdf
```

最终的代码和效果如下，解决了我们之前说的“编号冲突问题”（因为我们没有输出 \thecontentslabel 标题编号）：
``` latex
\usepackage{titletoc}   % 用于设置 toc
\titlecontents{chapter}
              [0em]
              {\bf}%
              {}%   % \contentslabel{2.5em} 会显示宽为 2.5em 的章节编号
              {}%
              {\hfill \contentspage \vspace{10.5pt}}%
              []%
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-11-10-01-12-45_Latex.jpg"/></div>

另外，如果想要一些其他的格式，我们再给出一个例子：
``` latex
\usepackage{titletoc}   % 用于设置 toc
\titlecontents{chapter}
              [3cm]
              {\bf \large}%
              {\contentslabel{2.5em}}%
              {}%
              {\titlerule*[0.5pc]{$\cdot$}\contentspage\hspace*{3cm}}%
              []%
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-11-10-01-14-59_Latex.jpg"/></div>

另外，再提一句，`\includepdf` 时，路径解析只会解析出一个空格，这也就是说，如果你的文件名是 `Hello**World.pdf` (我们用`*`代表空格以做强调)，那么 `\includepdf{Hello**World.pdf}` 是无法正常工作的，它会报错“找不到文件 `Hello*World.pdf`”。这是我们可以将文件名改为 `Hello*World.pdf` 以解决这个问题，其它方法暂时还没试过。

## 表格

### 表格插入

最佳方法是利用表格生成器（手动输入内容）或表格转换器（Excel 数据转表格）生成代码：

- Latex Table
    - [Latex Table Editor](https://www.latex-tables.com/)：`\usepackage{tabularray}`，可以在数学表格外统一使用 `\begin{equation*}` 来创造数学环境，无需手动给每个元素添加 `$$`
    - [Create Latex Tables Online](https://www.tablesgenerator.com/latex_tables#google_vignette)：`\usepackage{longtable}`，便于生成跨页长表格
    - [Excel2LATEX](https://ctan.org/tex-archive/support/excel2latex/)：可以将 Excel 表格转化为 Latex 表格
- Image to Excel
    - [Online OCR](https://www.onlineocr.net/)
    - [image-to-excel](https://web.baimiaoapp.com/image-to-excel)
    - [图片转 Excel](https://zhiyakeji.com/freg/)
    

使用 [Latex Table Editor](https://www.latex-tables.com/) 的一个例子：

``` latex
\begin{table}[H]
    \caption{\textbf{三点二阶导数近似的 Taylor 级数表}}
    \begin{equation*}
        \begin{tblr}{
            hline{1,6} = {-}{0.08em},
            hline{2} = {-}{},
            colspec = {cccccc},
        }
        \text{求和项}& u_j & \Delta x\left(\frac{\partial u}{\partial x}\right)_j & \Delta x^2\left(\frac{\partial^2u}{\partial x^2}\right)_j & \Delta x^3\left(\frac{\partial^3u}{\partial x^3}\right)_j & \Delta x^4\left(\frac{\partial^4u}{\partial x^4}\right)_j \\
        \Delta x^2\left(\frac{\partial^2u}{\partial x^2}\right)_j& 0 & 0 & 1 & 0 & 0 \\
        -au_{j-1}&-a&-a(-1)\frac{1}{1}&-a(-1)^2\frac{1}{2}&-a(-1)^3\frac{1}{6}&-a(-1)^4\frac{1}{24}\\
        -bu_j&-b&0&0&0&0\\
        -cu_{j+1}&-c&-c(1)\frac{1}{1}&-c(1)^2\frac{1}{2}&-c(1)^3\frac{1}{6}&-c(1)^4\frac{1}{24}
        \end{tblr}
    \end{equation*}
\end{table}
```



### 表格 caption



## 图片

### 插入图片

Latex 的图片插入支持以下格式：

- jpg, png, eps, pdf: `\usepackage{graphicx}` 并 `\includegraphics{YourFileNameHere}`
- svg: `\usepackage{svg}` 并 `\includesvg{YourFileNameHere}`

jpg, png, eps, pdf 代码如下：
``` latex
% jpg, png, eps, pdf: \usepackage{graphicx} 并 \includegraphics{YourFileNameHere}

% 导言区：
% \usepackage{graphicx}  % 支持 jpg, png, eps, pdf 图片 

% 正文区：
\begin{figure}[H]
  \centering
  \includegraphics[width=\textwidth]{assets/2024-08-15_13-50-23.pdf}
  \caption{\textbf{这里是图注}}\label{这里是图注}
\end{figure}
```


svg 代码如下（借助 VSCode 的 Draw.io 插件，可以方便且快速的编辑、导入 svg）：
``` latex
% svg: \usepackage{svg} 并 \includesvg{YourFileNameHere}

% 导言区：
% \usepackage{svg}       % 支持 svg 图片
%     \svgsetup{
%         inkscapeexe = D:/aa_my_apps_main/Inkscape/bin/inkscape.exe, % 指向 inkscape.exe 的路径
%         inkscapelatex = false                 % 一定程度上修复导入后图片文字溢出几何图形的问题
%     }

% 正文区：
\begin{figure}[H]
    \centering
    \includesvg[width=0.5\textwidth]{assets/draw.ioFiles/draw.io_test.drawio.svg}
    \caption{\textbf{插入 svg}}\label{插入 svg}
\end{figure}
```
注：Latex 插入 svg 实际上是通过 Inkscape 将 svg 转为 pdf 再执行插入的，由于这个过程在编译时进行，因此插入过多的 svg 图片可能会导致编译时间过长。遗憾的是，`.drawio.svg` 图片中的数学排版在 Latex 中无法正常显示（以纯文本形式显示，而不渲染为数学公式），`.drawio.png` 可以正常渲染数学公式，但是公式画质较低，因此对于有数学排版要求的图片，建议使用 `.drawio.png`，或者在 AxGlyph 中编辑后导出为 `.svg` 或 `.pdf`（前者文件更大，后者可能有轻微渲染差异）。当然，也可以将 `.drawio.svg` 中的内容手动导出为 `.svg`。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-17-21-10-52_Latex.jpg"/></div>

若插入 svg 遇到如下报错：

``` latex
Package svg: You didn't enable `shell escape' (or `write18')(svg)	so it wasn't possible to launch the Inkscape export(svg)	for `assets/draw.io_test.drawio.svg'.LaTeX
Package svg: File `draw.io_test.drawio_svg-raw.pdf' is missing.LaTeX
```
则需要在编译选项中添加参数 `-shell-escape`，在 settings.json 中找到当初 Latex 编译时的命令设置，在其后添加 `-shell-escape` 即可。比如我使用的是 `XeLatex` 选项，则再添加一条 `-shell-escape` 参数即可，如图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-22-22-37-08_Latex.jpg"/></div>


### 图片 caption

## 脚注

``` latex
\begin{figure}[ht]\centering
    here is a figure 
    \caption{Example images from Soccer team dataset \protect\footnotemark[1]}
    \label{yourlabel}
\end{figure}
\footnotetext[1]{按照这个格式在这里标注你想注释的内容}
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-17-21-20-43_Latex.jpg"/></div>

## Insert GIF in Latex

### Enviroment

Refer to [this](https://blog.csdn.net/qq_37851620/article/details/102829579) or [this](https://blog.csdn.net/yihuajack/article/details/120228598) to build the enviroment , and learn the basic operations to insert GIF in Latex. Definitely, you might find that the command `convert xxx.gif xxx.png`, which the previous two articles told you, will run into the error "Invalid parameter". All you need is to change the word `convert` to `magick` -- the new version of ImageMagick uses the keyword `magick`, instead of `convert`. 

After getting a series of `.png` images from you `.gif` file, you can go to Latex to insert those `.png`, by the package `animate`. Which means you need to `\usepackage{animate}`.

### Demo

Here is an example:

``` bash
# In Power Shell or command line
magick test.gif test.png
```

``` tex
% In your .tex file

% use package animate to animate the images and insert them.
% \usepackage{animate}

\begin{figure}[H]\centering
    \animategraphics[autoplay,loop,controls,width=0.9\textwidth]{10}{assets/test_GIF/test-}{0}{30}
\caption{\bfseries Insert GIF in PDF}\label{Insert GIF in PDF}
\end{figure}
```

<video class='center' controls="false"  muted="muted" name="media"><source src="https://www.writebug.com/static/uploads/2024/9/21/717d852bc64ed28aa0e88aba4518259b.mp4" type="video/mp4"></video>

!> **<span style='color:red'>Attention:</span>**<br>
You may need a certain PDF viewer to view the GIF in your pdf file, such as Adoube Acrobat. The built-in PDF viewer in VSCode when editing `.tex` file does not supporte the function, WPS does not, either.

You can refer to [ImageMagick](https://www.imagemagick.org/script/command-line-processing.php) for more advanced usage.

## Latex 转 word

直接法：`.tex` 转 `.docx`，间接法：`.pdf` 转 `.docx`。

### 直接法：

考虑 pandoc + pandoc-crossref。首先到 pandoc-crossref 的 GitHub 官网 [here](https://github.com/lierdakil/pandoc-crossref/releases) 下载最新版 release，然后到 pandoc 的 GitHub 官网 [here](https://github.com/jgm/pandoc/releases/) 下载并安装对应版本的 release。
安装时注意选择正确的系统，例如我的是 Windows，则选择 `pandoc-3.5-windows-x86_64.msi`。还要注意是依据 pandoc-crossref 的版本来选择 pandoc 的版本，如下图所示：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-10-10-21-14-18_Latex.jpg"/></div>

如果你无法访问 GitHub，且是 Windows 用户，也可以到链接 [here](https://www.123865.com/s/0y0pTd-XOKj3) 下载它们，其中的两个文件已经是对应版本。

两边都下载 / 安装完成之后，将 pandoc-crossref 的 `.exe` 可执行文件放到 pandoc 的安装目录 `C:\Program Files\Pandoc` 下，然后在命令行中输入下面代码检查是否安装成功：

``` shell
pandoc-crossref --version # 检查 pandoc-crossref 是否安装成功
pandoc --version # 检查 pandoc 是否安装成功

```

如果正常显示版本号如下，则说明安装成功：

``` shell
# pandoc-crossref --version # 检查 pandoc-crossref 是否安装成功
pandoc-crossref v0.3.18.0 git commit 6cff8a6f8fa193ebeb8b84cc71006f635036344c (HEAD) built with Pandoc v3.4, pandoc-types v1.23.1 and GHC 9.6.6 

# pandoc --version # 检查 pandoc 是否安装成功
pandoc.exe 3.4
Features: +server +lua
Scripting engine: Lua 5.4
User data directory: C:\Users\13081\AppData\Roaming\pandoc
Copyright (C) 2006-2024 John MacFarlane. Web: https://pandoc.org
This is free software; see the source for copying conditions. There is no
warranty, not even for merchantability or fitness for a particular purpose.
```

之后参考文章 [CSDN](https://blog.csdn.net/qq_35091353/article/details/124281241) 即可。

### 间接法

在线网址：
- [i2pdf](https://www.i2pdf.com/pdf-to-word): 文字较好，公式一般，图片一般
- [ilovepdf](https://www.ilovepdf.com/pdf_to_word): 文字一般，公式一般，图片较好
- [pdf.io](https://pdf.io/pdf2doc/): 文字一般，公式较好，图片较好

使用 ABBYY 软件：
可以到官网 [here](https://www.abbyychina.com/) <span style='color:red'> 购买 </span> 并下载，也可以到链接 [here (123 云盘)](https://www.123865.com/s/0y0pTd-nOKj3) 下载并安装 ABBYY Windows 版，或者备用链接 [here](https://downloadlynet.ir/2020/30/17871/07/abbyy-finereader/19/?#/17871-abbyy-fi-192405103010.html)（标有 `Mac` 的是 MacOS 版，其它的都是 Windows 版）

效果对比（10 分为满分）：

<div class='center'>

| 方法 | 文字处理效果 | 公式处理效果 | 图片处理效果 | 平均分 |
|:-:|:-:|:-:|:-:|:-:|
 | [pdf.io](https://pdf.io/pdf2doc/) | 5 | 7 | 7 | 6.3 |
 | [ABBYY](https://www.123865.com/s/0y0pTd-nOKj3) | 10 | 3 | 4 | 5.7 |
 | [ilovepdf](https://www.ilovepdf.com/pdf_to_word) | 5 | 4 | 7 | 5.3 |
 | [i2pdf](https://www.i2pdf.com/pdf-to-word) | 7 | 4 | 5 | 5.3 |
</div>

可根据需要选择合适的转换方式，文本较多的情况尤其建议 [ABBYY](https://www.123865.com/s/0y0pTd-nOKj3)。特别地，如果有较多超链接跳转需求，也非常建议使用 ABBYY，它能极好的保留原有超链接。


## 杂七杂八

### 对号错号

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-02-15-42-41_Latex.jpg"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-26-18-50-05_Latex.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-26-18-50-36_Latex.png"/></div>
 -->

### 埃米符号

``` latex
\qty{8}{\angstrom}
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-24-22-22-29_Latex.png"/></div>



## 自定义模版

全部自定义模版的最新源代码见：[GitHub](https://github.com/YiDingg/LatexNotes/tree/main/Templates)

### [Notes]Template

Template of Notes，同时也是 Template of Report。

- 源码：[GitHub](https://github.com/YiDingg/LatexNotes/tree/main/Templates/%5BNotes%5DTemplate)
- 快捷下载：<button onclick="window.open('https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[Notes]Template/[Notes]Template.tex')" type="button">ReportTemplate.tex</button>  <button onclick="window.open('https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[Notes]Template/[Notes]Template.pdf')" type="button">ReportTemplate.pdf</button>

```pdf
https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[Notes]Template/[Notes]Template.pdf
```

### [Homework]Template

Template of Homework，用于课程作业。

- 源码：[GitHub](https://github.com/YiDingg/LatexNotes/tree/main/Templates/%5BHomework%5DTemplateOfHomework)
- 快捷下载：<button onclick="window.open('https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[Homework]TemplateOfHomework/[Homework]Template.tex')" type="button">[Homework]Template.tex</button>  <button onclick="window.open('https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[Homework]TemplateOfHomework/[Homework]Template.pdf')" type="button">[Homework]Template.pdf</button>

```pdf
https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[Homework]TemplateOfHomework/[Homework]Template.pdf
```


### [BPE]Template

Template of Basic Physics Experiment，即基础物理实验报告的模板。

- 源码：[GitHub](https://github.com/YiDingg/LatexNotes/tree/main/Templates/%5BBPE%5DTemplate)
- 快捷下载：<button onclick="window.open('https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[BPE]Template/[BPE]Template.tex')" type="button">[BPE]Template.tex</button>  <button onclick="window.open('https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[BPE]Template/[BPE]Template.pdf')" type="button">[BPE]Template.pdf</button>

```pdf
https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/%5BBPE%5DTemplate/BPE-Template.pdf
```

### [CUMCM]Template

Template of CUMCM，数学建模国赛（CUMCM）专用模板。

- 源码：[GitHub](https://github.com/YiDingg/LatexNotes/tree/main/Templates/%5BCUMCM%5DTemplate)
- 快捷下载：<button onclick="window.open('https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[CUMCM]Template/[CUMCM]Template.tex')" type="button">[CUMCM]Template.tex</button>  <button onclick="window.open('https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[CUMCM]Template/[CUMCM]Template.pdf')" type="button">[CUMCM]Template.pdf</button>

```pdf
https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[CUMCM]Template/[CUMCM]Template.pdf
```

### [CheatSheet]Template

Template of CheatSheet，速查表，速查手册模板。例如，有的课程在期末考试时会允许带一张有笔记的 A4 纸进去，这时就需要排版非常紧凑，下面的模版很好地做到了这一点。

- 源码：[GitHub](https://github.com/YiDingg/LatexNotes/tree/main/Templates/%5BCheatSheet%5DTemplate)
- 快捷下载：<button onclick="window.open('https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[CheatSheet]Template/[CheatSheet]Template.tex')" type="button">[CheatSheet]Template.tex</button>  <button onclick="window.open('https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[CheatSheet]Template/[CheatSheet]Template.pdf')" type="button">[CheatSheet]Template.pdf </button>

```pdf
https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/Templates/[CheatSheet]Template/[CheatSheet]Template.pdf
```

## 其它模版

- [Latexstudio: Latex Templates](https://www.latexstudio.net/index/lists/index/type/2.html)
- [Overleat: Templates](https://www.overleaf.com/latex/templates)
- [ElegantBook](https://github.com/ElegantLaTeX/ElegantBook):  LaTeX 书籍模板
- [ElegantPaper](https://github.com/ElegantLaTeX/ElegantPaper): LaTeX 论文模板
- [ElegantNote](https://github.com/ElegantLaTeX/ElegantNote): LaTeX 笔记模板
- [BeautyBook](https://github.com/BeautyLaTeX/Beautybook/tree/master): LaTeX 书籍模板
- [Eye-Candy-Lecture-Notes-Theme](https://github.com/sohamch08/Eye-Candy-Lecture-Notes-Theme): LaTeX 笔记模板

## Latex 即时预览与其他在线编辑器

详见 [知乎：Scientific WorkPlace](https://zhuanlan.zhihu.com/p/3574614730)


## 相关资源

教程与文档：
- [TeX - LaTeX Stack Exchange](https://tex.stackexchange.com/)
- [Latex Studio](https://www.latexstudio.net)
- [Latex Studio > Articles](https://www.latexstudio.net/articles/)
- [Latex Studio > Learn LaTeX](https://www.latexstudio.net/LearnLaTeX/)
- [LaTeX 入门与进阶](https://latex.lierhua.top/zh/)
- [Overleaf > Learn Latex](https://www.overleaf.com/learn)

免费模板：
- [VividBook: 生动的 LaTeX 书籍模板](https://github.com/Azure1210/VividBooK) or [知乎](https://zhuanlan.zhihu.com/p/631306342)
- [spTemplate: 高度封装化的 LaTeX 类文件](https://github.com/SweetPastry/spTemplate) or [知乎](https://zhuanlan.zhihu.com/p/17531477449)
- 
