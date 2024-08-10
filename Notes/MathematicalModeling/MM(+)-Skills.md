# Mathematical Modeling (+): Skills 

## During The Contest 
- Matlab 搜 [examples](https://www.mathworks.com/support/search.html?q=&fq%5B%5D=asset_type_name:documentation/example&page=1&s_tid=CRUX_topnav) 和 [fileexchange](https://www.mathworks.com/matlabcentral/fileexchange)
- 搜相关论文

## Paper Skills 

### 插入 Matlab 代码

插入 Matlab 代码到 Latex 中，并保持 Matlab 代码原有格式和高亮。

### AxGlyph 导出 PDF 

截至 2024-7-28，AxGlyph 导出 PDF 有两种方式，一种是整页导出，无法自动裁剪图像，另一种可以自动裁剪导出区域，但常无法得到矢量图形。

这里提供一种可行的解决方案：选中要导出的图形 --> 右键复制（Ctrl + C 有时会丢失部分图形） --> 粘贴到 inkscape --> 导出为 PDF。

这样可以保留矢量图形，并自动裁剪导出区域。

### 绘制矢量图像

- Matlab 绘制数据可视化
- 如果不麻烦，物理示意图直接用 AxGlyph + [Mathcha](https://www.mathcha.io/editor) 绘制并导出。否则，用平板作图后导出为 pdf，用 Adobe Acrobat 裁剪，

## Matlab Skills

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