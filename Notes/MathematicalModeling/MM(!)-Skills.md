# Mathematical Modeling (+): Tips and Tricks

> [!Note|style:callout|label:Infor]
Initially published at 12:42 on 2024-08-18 in Lincang.

## During The Contest 
- Matlab 搜 [examples](https://www.mathworks.com/support/search.html?q=&fq%5B%5D=asset_type_name:documentation/example&page=1&s_tid=CRUX_topnav) 和 [fileexchange](https://www.mathworks.com/matlabcentral/fileexchange)
- 搜相关论文

## Paper Tips 

### 插入 Matlab 代码

插入 Matlab 代码到 Latex 中，并保持 Matlab 代码原有格式和高亮。

### AxGlyph 导出 PDF 

截至 2024-7-28，AxGlyph 导出 PDF 有两种方式，一种是整页导出，无法自动裁剪图像，另一种可以自动裁剪导出区域，但常无法得到矢量图形。

这里提供一种可行的解决方案：选中要导出的图形 --> 右键复制（Ctrl + C 有时会丢失部分图形） --> 粘贴到 inkscape --> 导出为 PDF。

这样可以保留矢量图形，并自动裁剪导出区域。

### 绘制矢量图像

<!--  + [Mathcha](https://www.mathcha.io/editor)  -->

- Matlab 进行数据可视化并导出为 pdf
- 如果不麻烦，物理示意图直接用 AxGlyph绘制并导出
- 否则，用平板作图（适当使用“转文字 / 公式”）后导出为 pdf，pdf 转 svg 后在 PPT 内编辑（可辅以 AxGlyph），最后黏贴到 Inkscape 导出为 pdf
- 流程图用 [draw.io](https://app.diagrams.net/?src=about)

pdf 转 svg 可以使用 Texlive 自带的 pdftocairo.exe，只需在命令行输入 `pdftocairo -svg YourFileNameHere.pdf` 即可，例如：

``` shell 
pdftocairo -svg C:\Users\13081\Desktop\Test_Matlab\2024-08-15_13-50-23.pdf
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-18-09-43-03_MM(!)-Skills.jpg"/></div>

批量转换可通过脚本实现，详见 [here](https://blog.csdn.net/erwei4710/article/details/138505393)

## Matlab Tips

### 块注释

Matlab 中除了用 `%` 作行注释，还可以用 `%{  %}` 作块注释，如下：
``` matlab
%{  
   这是一个块注释，它可以有多行
   可以有多行
   可以有多行
   可以有多行
%}
```


### 帮助文档下载到本地

参考 [here](https://zhuanlan.zhihu.com/p/715676397)

### 数组逻辑索引

对于数组或元胞数组，可以使用逻辑索引而不是 `find` 来改善性能：

旧代码：

``` matlab
% 筛选（使用逻辑索引而不是find来改善性能）
    % 最大距离
        Index = find(   ( sqrt(sum((X_A_O' - Heliostat).^2, 2)) < distance_max+0.1 )   );
        % 剔除镜面自身    
        Index = Index( find(Index-i) );
    % 方向筛选
        BA = X_A_O' - Heliostat(Index,:);
        Index = Index(   find( sum(BA(:,[1 2]).*V_sun_O([1 2])',2) > 0 )   ); 
```

优化后的代码：

``` matlab 
% 筛选（使用逻辑索引而不是find来改善性能）
    % 最大距离
        Index = find(   ( sqrt(sum((X_A_O' - Heliostat).^2, 2)) < MaxDistance_he+0.1 )   );
        % 剔除镜面自身    
        Index = Index( (Index-i) ~= 0 );
    % 方向筛选
        BA = X_A_O' - Heliostat(Index,:);
        Index = Index(   sum(BA(:,[1 2]) .* V_sun_O([1 2])',2) > 0   ); 
```

### 行列索引与序号索引

`sub2ind`

`ind2sub`

### 拟合函数矩阵输入

Matlab 的拟合结果（二维 `cfit`，三维 `sfit`）可以视为一个函数，并且支持矩阵输入，例如 `cfit` 结构体：

``` matlab 
fittedmodel([1;2])
fittedmodel([1 2])
fittedmodel([1 2; 3 4])
```

``` output
ans = 2×1    
   23.2002
   35.2002

ans = 2×1    
   23.2002
   35.2002

ans = 4×1    
   23.2002
   47.2002
   35.2002
   59.2002
```

可以注意到，对于 `cfit` 结构体，无论输入是行向量、列向量还是矩阵，输出都是列向量。在利用输入输出时，可能需要使用序号索引和函数 `ind2sub` 或 `sub2ind`。

又例如 `sfit` 结构体：

``` matlab 
fittedmodel1([0 1], [0 1])
fittedmodel1([0 1], [0;1])
fittedmodel1([0;1], [0;1])
fittedmodel1([0 1 2; 2 3 4], [0 1 2; 2 3 4])
fittedmodel1([0 1 2; 2 3 4], [0 1 2; 2 3 4]')
```

``` output 
ans = 1×2    
   24.4000   23.6000

ans = 1×2    
   24.4000   23.6000

ans = 2×1    
   24.4000
   23.6000

ans = 2×3    
   24.4000   23.6000   29.2000
   29.2000   41.2000   59.6000

ans = 2×3    
   24.4000   29.4156   38.4637
   29.4156   38.4637   59.6000
```

输出的结构和 `X` 相同，并且需要注意，当矩阵 `X` 和矩阵 `Y` 尺寸互为转置时，输出可能不同，这是因为拟合函数处理输入时，都是利用索引值输入并输出。所以 `[0 1 2; 2 3 4]'` 对应的 `Y` 输入值依次为：`[0, 2, 1, 3, 2, 4]`。

如果要利用 `sfit` 构建新的一元函数，可以采用方式：

``` matlab 
f_y = @(y) fittedmodel1( zeros(size(y)), y );
g_x = @(x) fittedmodel1( x, zeros(size(y)) );
```

这样得到的匿名函数便支持矩阵输入，有时能大大提高代码效率。

### 动态字段

可以利用动态字段（ Matlab2019b 及之后版本）来生成变量名，这在循环或迭代时很方便。例如变量 `i = 80` 时：

``` matlab 
i = 80
stc.(['Num_',num2str(i-1)]) = 89456;
stc.(['Num_',num2str(i)]) = 'hello';
stc
```

``` output
i = 80
ans = 'Num_79'
stc = 
    Num_79: 89456
    Num_80: 'hello'
```

在更早的版本中，可以使用 `eval` 函数实现，但这种方法更复杂，也更容易出错，我们不过多阐述。一个例子如下：

``` matlab
for i = 1:5  
    eval(['stc.var', num2str(i) ' = i^3;']); 
end
stc
```

``` output
stc = 
    var1: 1
    var2: 8
    var3: 27
    var4: 64
    var5: 125
```

## Use Matlab in VS Code

### 配置 Python 环境

依次参考以下链接进行操作：【保姆级Anaconda安装教程】

- 安装并配置 Anaconda 环境：
  - [Anaconda安装+PyCharm安装和基本使用，Python编程环境安装](https://www.bilibili.com/video/BV1Vu411Y7gL)
  - [保姆级Anaconda安装教程](https://www.bilibili.com/video/BV1ns4y1T7AP)

注意 Python 和 Matlab 的版本对应情况（详见 [here](https://www.mathworks.com/support/requirements/python-compatibility.html)）：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-20-15-51-19_MM(!)-Skills.jpg"/></div>

其它问题可参考：
- [在anaconda环境下使用python调用matlab函数（windows系统）](https://blog.csdn.net/qq_47885658/article/details/132559305)
- [Python如何调用MATLAB？附有实例和详细讲解](https://blog.csdn.net/guangwulv/article/details/115165599)
- [python使用MATLAB报错OSError: MATLAB Engine for Python supports Python version 2.7, 3.4, 3.5 and3.6，but your version of python is 3.8](https://www.cnblogs.com/haobox/p/15755859.html)

相关链接：
- [清华镜像：anaconda](https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/?C=M&O=D)
- [PyCharm 官网下载](https://www.jetbrains.com/pycharm/download)
- [Python 官网下载](https://www.python.org/downloads/release)

Anaconda 创建虚拟环境时，下载速度一般极慢（真的很慢，20 MB 下了我六个小时），建议使用镜像路径，设置如下（清华源）：

``` shell 
conda config --set show_channel_urls yes
conda config --add channels http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
conda config --set show_channel_urls yes
conda config --remove channels defaults
conda config --show channels

```

其它镜像源及设置见 [here](https://blog.csdn.net/m0_57264062/article/details/136515565)。

Anaconda 查看、创建、激活、退出、删除虚拟环境：

``` shell 
conda env list                                                    # 查看所有环境
conda create -n YourPythonEnviromentName python=YourPythonVersion # 创建名为 YourPythonEnviromentName 的 Python 环境
activate YourPythonEnviromentName                                 # 激活名为 YourPythonEnviromentName 的 Python 环境
conda deactivate                                                  # 退出当前激活的 Python 环境                          
conda remove -n YourPythonEnviromentName --all                    # 删除名为 YourPythonEnviromentName 的 Python 环境
```

下面是一个例子

``` shell 
conda create -n Test_PythonEnviroment python=3.12 # 创建名为 Test_PythonEnviroment 的 Python v3.12 环境
conda env list                                    # 查看所有环境
conda init                                        # Run 'conda init' before 'conda activate'
conda activate Test_PythonEnviroment              # 激活该环境
conda env list                                    # 查看所有环境
conda deactivate                                  # 退出当前激活的 Python 环境 
#conda remove -n Test_PythonEnviroment --all      # 删除该环境
```

我的 Matlab 版本为 2022a，可以使用 Python 3.9，因此这里创建一个 v3.9 的环境：

``` shell 
conda create -n PythonEnviromentForMatlab2022a-v3.9 python=3.9 # 创建名为 PythonEnviromentForMatlab2022a-v3.9 的 Python v3.9 环境
conda activate PythonEnviromentForMatlab2022a-v3.9             # 激活该环境
conda env list                                                 # 查看所有环境
```

如果 `conda init` 之后仍遇到报错 “Run 'conda init' before 'conda activate'”，在命令提示符中（而不是 PowerShell）重新激活即可。出现这个问题时，重新启动 PowerShell，你应该会看到报错：

``` shell 
无法加载文件 C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1，因为在此系统上禁止运行脚本
```

此时参考 [here](https://blog.csdn.net/z17338523033/article/details/137372069) 解决即可。之后便可在 Shell 中正常使用 conda 相关命令。

conda 创建的虚拟环境默认在C盘，我们可以修改默认路径，参考 [here](https://blog.csdn.net/qq_41701723/article/details/129171317)。



### 配置 Matlab in VS Code

- 配置 Matlab in VS Code：
  - [vscode+matlab编写编译一条龙（不用打开matlab的命令行窗口，直接在vscode完成操作）](https://www.bilibili.com/video/BV1Qj421Z77h)
- 如遇报错：`setuptools.extern.packaging.version.InvalidVersion: Invalid version: ‘R2022a’`
  - [安装matlab engine报错：Invalid version: ‘R2022a’](https://blog.csdn.net/qq_41885018/article/details/139940010)
- 如遇报错：`setup.py install is deprecated`
  - [Python 安装 matlabengin 时遇到报错：setup.py install is deprecated.](https://blog.csdn.net/BOXonline1396529/article/details/139337746)

最终如图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-20-17-41-28_MM(!)-Skills.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-20-18-02-33_MM(!)-Skills.jpg"/></div>

我的快捷键设置如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-20-18-06-56_MM(!)-Skills.jpg"/></div>

`Run current MATLAB Script`：运行当前 `.m` 文件
`Run current selection in MATLAB`：运行光标所在行或选中区域
