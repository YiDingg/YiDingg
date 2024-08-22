# Latex 

>环境：Texlive 2023 + VSCode

## 模版

### 我的模板

最新源代码见：[GitHub](https://github.com/YiDingg/LatexNotes/tree/main/Templates)


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

- [Latex Table Editor](https://www.latex-tables.com/)：`\usepackage{tabularray}`，可以在数学表格外统一使用 `equation*` 来创造数学环境，无需手动给每个元素添加 `$$`
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

- `\includegraphics`: jpg, png, pdf
- `\includepdf`: pdf

代码如下：

``` latex
\begin{figure}[H]
  \centering
  \includegraphics[width=\textwidth]{assets/2024-08-15_13-50-23.pdf}
  \caption{\textbf{这里是图注}}\label{这里是图注}
\end{figure}
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-17-21-10-52_Latex.jpg"/></div>

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

## 其他资源

- [TeX - LaTeX Stack Exchange](https://tex.stackexchange.com/)