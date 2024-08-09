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

## Matlab Skills

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


```
