# Latex 

>环境：Texlive 2023 + VSCode

## 模版

### 我的模板

最新源代码见：[GitHub](https://github.com/YiDingg/LatexNotes/tree/main/Templates)

Report Template 快捷复制（2024.8.28）：

``` tex
% 若编译失败，且生成 .synctex(busy) 辅助文件，可能有两个原因：
% 1. 需要插入的图片不存在：Ctrl + F 搜索 'figure' 将这些代码注释/删除掉即可
% 2. 路径/文件名含中文或空格：更改路径/文件名即可

% --------------------- 文章宏包及相关设置 --------------------- %
% >> ------------------ 文章宏包及相关设置 ------------------ << %
% 设定文章类型与编码格式
    \documentclass[,UTF8]{report}		


% 自定义宏定义
    \def\N{\mathbb{N}}
    \def\F{\mathbb{F}}
    \def\Z{\mathbb{Z}}
    \def\Q{\mathbb{Q}}
    \def\R{\mathbb{R}}
    \def\C{\mathbb{C}}
    \def\T{\mathbb{T}}
    \def\S{\mathbb{S}}
    \def\A{\mathbb{A}}
    \def\I{\mathscr{I}}
    \def\d{\mathrm{d}}
    \def\p{\partial}


% 导入基本宏包
    \usepackage[UTF8]{ctex}     % 设置文档为中文语言
    \usepackage[colorlinks, linkcolor=blue, anchorcolor=blue, citecolor=blue, urlcolor=blue]{hyperref}  % 宏包：自动生成超链接 (此宏包与标题中的数学环境冲突)
    % \usepackage{docmute}    % 宏包：子文件导入时自动去除导言区，用于主/子文件的写作方式，\include{./51单片机笔记}即可。注：启用此宏包会导致.tex文件capacity受限。
    \usepackage{amsmath}    % 宏包：数学公式
    \usepackage{mathrsfs}   % 宏包：提供更多数学符号
    \usepackage{amssymb}    % 宏包：提供更多数学符号
    \usepackage{pifont}     % 宏包：提供了特殊符号和字体
    \usepackage{extarrows}  % 宏包：更多箭头符号


% 文章页面margin设置
    \usepackage[a4paper]{geometry}
        \geometry{top=1in}
        \geometry{bottom=1in}
        \geometry{left=0.75in}
        \geometry{right=0.75in}   % 设置上下左右页边距
        \geometry{marginparwidth=1.75cm}    % 设置边注距离（注释、标记等）

% 配置数学环境
    \usepackage{amsthm} % 宏包：数学环境配置
    % theorem-line 环境自定义
        \newtheoremstyle{MyLineTheoremStyle}% <name>
            {11pt}% <space above>
            {11pt}% <space below>
            {}% <body font> 使用默认正文字体
            {}% <indent amount>
            {\bfseries}% <theorem head font> 设置标题项为加粗
            {：}% <punctuation after theorem head>
            {.5em}% <space after theorem head>
            {\textbf{#1}\thmnumber{#2}\ \ (\,\textbf{#3}\,)}% 设置标题内容顺序
        \theoremstyle{MyLineTheoremStyle} % 应用自定义的定理样式
        \newtheorem{LineTheorem}{Theorem.\,}
    % theorem-block 环境自定义
        \newtheoremstyle{MyBlockTheoremStyle}% <name>
            {11pt}% <space above>
            {11pt}% <space below>
            {}% <body font> 使用默认正文字体
            {}% <indent amount>
            {\bfseries}% <theorem head font> 设置标题项为加粗
            {：\\ \indent}% <punctuation after theorem head>
            {.5em}% <space after theorem head>
            {\textbf{#1}\thmnumber{#2}\ \ (\,\textbf{#3}\,)}% 设置标题内容顺序
        \theoremstyle{MyBlockTheoremStyle} % 应用自定义的定理样式
        \newtheorem{BlockTheorem}[LineTheorem]{Theorem.\,} % 使用 LineTheorem 的计数器
    % definition 环境自定义
        \newtheoremstyle{MySubsubsectionStyle}% <name>
            {11pt}% <space above>
            {11pt}% <space below>
            {}% <body font> 使用默认正文字体
            {}% <indent amount>
            {\bfseries}% <theorem head font> 设置标题项为加粗
            {：\\ \indent}% <punctuation after theorem head>
            {0pt}% <space after theorem head>
            {\textbf{#3}}% 设置标题内容顺序
        \theoremstyle{MySubsubsectionStyle} % 应用自定义的定理样式
        \newtheorem{definition}{}

%宏包：有色文本框（proof环境）及其设置
    \usepackage[dvipsnames,svgnames]{xcolor}    %设置插入的文本框颜色
    \usepackage[strict]{changepage}     % 提供一个 adjustwidth 环境
    \usepackage{framed}     % 实现方框效果
        \definecolor{graybox_color}{rgb}{0.95,0.95,0.96} % 文本框颜色。修改此行中的 rgb 数值即可改变方框纹颜色，具体颜色的rgb数值可以在网站https://colordrop.io/ 中获得。（截止目前的尝试还没有成功过，感觉单位不一样）（找到喜欢的颜色，点击下方的小眼睛，找到rgb值，复制修改即可）
        \newenvironment{graybox}{%
        \def\FrameCommand{%
        \hspace{1pt}%
        {\color{gray}\small \vrule width 2pt}%
        {\color{graybox_color}\vrule width 4pt}%
        \colorbox{graybox_color}%
        }%
        \MakeFramed{\advance\hsize-\width\FrameRestore}%
        \noindent\hspace{-4.55pt}% disable indenting first paragraph
        \begin{adjustwidth}{}{7pt}%
        \vspace{2pt}\vspace{2pt}%
        }
        {%
        \vspace{2pt}\end{adjustwidth}\endMakeFramed%
        }

% 外源代码插入设置
    % matlab 代码插入设置
    \usepackage{matlab-prettifier}
        \lstset{
            style=Matlab-editor,  % 继承matlab代码颜色等
        }
    \usepackage[most]{tcolorbox} % 引入tcolorbox包 
    \usepackage{listings} % 引入listings包
        \tcbuselibrary{listings, skins, breakable}
        \lstdefinestyle{matlabstyle}{
            language=Matlab,
            basicstyle=\small,
            breakatwhitespace=false,
            breaklines=true,
            captionpos=b,
            keepspaces=true,
            numbers=left,
            numbersep=15pt,
            showspaces=false,
            showstringspaces=false,
            showtabs=false,
            tabsize=2
        }
        \newtcblisting{matlablisting}{
            arc=0pt,
            top=0pt,
            bottom=0pt,
            left=1mm,
            listing only,
            listing style=matlabstyle,
            breakable,
            colback=white   % 选一个合适的颜色
        }

% table 支持
    \usepackage{booktabs}   % 宏包：三线表
    \usepackage{tabularray} % 宏包：表格排版
    \usepackage{longtable}  % 宏包：长表格

% figure 设置
    \usepackage{graphicx}  % 支持 jpg, png, eps, pdf 图片 
    \usepackage{svg}       % 支持 svg 图片
        \svgsetup{
            % 指向 inkscape.exe 的路径
            inkscapeexe = D:/aa_my_apps_main/Inkscape/bin/inkscape.exe, 
            % 一定程度上修复导入后图片文字溢出几何图形的问题
            inkscapelatex = false                 
        }

% 图表进阶设置
    \usepackage{caption}    % 图注、表注
        \captionsetup[figure]{name=图}  
        \captionsetup[table]{name=表}
        \captionsetup{labelfont=bf, font=small}
    \usepackage{float}     % 图表位置浮动设置 

% 圆圈序号自定义
    \newcommand*\circled[1]{\tikz[baseline=(char.base)]{\node[shape=circle,draw,inner sep=0.8pt, line width = 0.03em] (char) {\small \bfseries #1};}}   % TikZ solution

% 列表设置
    \usepackage{enumitem}   % 宏包：列表环境设置
        \setlist[enumerate]{itemsep=0pt, parsep=0pt, topsep=0pt, partopsep=0pt, leftmargin=3.5em} 
        \setlist[itemize]{itemsep=0pt, parsep=0pt, topsep=0pt, partopsep=0pt, leftmargin=3.5em}
        \newlist{circledenum}{enumerate}{1} % 创建一个新的枚举环境  
        \setlist[circledenum,1]{  
            label=\protect\circled{\arabic*}, % 使用 \arabic* 来获取当前枚举计数器的值，并用 \circled 包装它  
            ref=\arabic*, % 如果需要引用列表项，这将决定引用格式（这里仍然使用数字）
            itemsep=0pt, parsep=0pt, topsep=0pt, partopsep=0pt, leftmargin=3.5em
        }  

% 参考文献引用设置
    \bibliographystyle{unsrt}   % 设置参考文献引用格式为unsrt
    \newcommand{\upcite}[1]{\textsuperscript{\cite{#1}}}     % 自定义上角标式引用

% 文章序言设置
    \newcommand{\cnabstractname}{序言}
    \newenvironment{cnabstract}{%
        \par\Large
        \noindent\mbox{}\hfill{\bfseries \cnabstractname}\hfill\mbox{}\par
        \vskip 2.5ex
        }{\par\vskip 2.5ex}

% 文章默认字体设置
\usepackage{fontspec}   % 宏包：字体设置
    \setmainfont{SimSun}    % 设置中文字体为宋体字体
    \setmainfont{Times New Roman} % 设置英文字体为Times New Roman

% 各级标题自定义设置
\usepackage{titlesec}   
\titleformat{\chapter}[hang]{\normalfont\huge\bfseries\centering}{第\,\thechapter\,章}{20pt}{}
\titlespacing*{\chapter}{0pt}{-20pt}{20pt} % 控制上方空白的大小
% section标题自定义设置 
\titleformat{\section}[hang]{\normalfont\Large\bfseries}{§\,\thesection\,}{8pt}{}
% subsubsection标题自定义设置
%\titleformat{\subsubsection}[hang]{\normalfont\bfseries}{}{8pt}{}

% --------------------- 文章宏包及相关设置 --------------------- %
% >> ------------------ 文章宏包及相关设置 ------------------ << %

% ------------------------ 文章信息区 ------------------------ %
% ------------------------ 文章信息区 ------------------------ %
% 页眉页脚设置
\usepackage{fancyhdr}   %宏包：页眉页脚设置
    \pagestyle{fancy}
    \fancyhf{}
    \cfoot{\thepage}
    \renewcommand\headrulewidth{1pt}
    \renewcommand\footrulewidth{0pt}
    \chead{here is the header，这里是页眉}    

%文档信息设置
\title{这里是标题\\The Title of the Report}
\author{丁毅\\ \footnotesize 中国科学院大学，北京 100049\\ Yi Ding \\ \footnotesize University of Chinese Academy of Sciences, Beijing 100049, China}
\date{\footnotesize 2024.8 -- 2025.1}
% ------------------------ 文章信息区 ------------------------ %
% ------------------------ 文章信息区 ------------------------ %
```


### 其它模板

- [Latex Templates](https://www.latexstudio.net/index/lists/index/type/2.html)

### .gitignore 

``` .gitignore
# .gitignore for Latex

# 忽略附属次要文件
*.aux
*.bbl 
*.blg
*.log
*.out
*.gz
*.toc
*.listing
```


## 表格

### 表格插入

最佳方法是利用表格生成器（手动输入内容）或表格转换器（Excel 数据转表格）生成代码：

- [Latex Table Editor](https://www.latex-tables.com/)：`\usepackage{tabularray}`，可以在数学表格外统一使用 `\begin{equation*}` 来创造数学环境，无需手动给每个元素添加 `$$`
- [Create Latex Tables Online](https://www.tablesgenerator.com/latex_tables#google_vignette)：`\usepackage{longtable}`，便于生成跨页长表格
- [Excel2LATEX](https://ctan.org/tex-archive/support/excel2latex/)：可以将 Excel 表格转化为 Latex 表格

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
    \includesvg[width=0.5\textwidth]{Notes/MajorCourses/CircuitTheory/assets/draw.io_test.drawio.svg}
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

## 杂七杂八

### 对号错号

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-26-18-50-05_Latex.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-26-18-50-36_Latex.png"/></div>

## 相关资源

- [TeX - LaTeX Stack Exchange](https://tex.stackexchange.com/)