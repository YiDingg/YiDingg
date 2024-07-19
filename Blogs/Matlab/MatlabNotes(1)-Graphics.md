# Matlab Notes (1): Graphics 

## Intro 

[Matlab Grphics](https://www.mathworks.com/help/releases/R2019b/matlab/graphics.html?s_tid=CRUX_lftnav)

## By Functions 

### Line Plots

Here are the functions to plot the data in a 2-D or 3-D view using a linear scale. 

```matlab 
axis equal     % 纵横坐标轴采用等长刻度
axis square    % 产生正方形坐标系（默认为矩形）
axis auto      % 使用默认设置
axis off       % 取消坐标轴
axis on        % 显示坐标轴
grid on        % 显示网格
grid off       % 不显示网格
box on         % 显示其他轴(上、右)
box off        % 不显示其他轴(上、右)
hold on        % 继续在同一图层绘图
figure         % 新生成一个图层
```

<!-- details begin -->
<details>
<summary><span class='Word'> plot </span>: 2-D line plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/plot.html). And you can refer [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/matlab.graphics.chart.primitive.line-properties.html) for more line properties. 

```matlab
x = linspace(0,pi,50);
y_1 = sin(x);
y_2 = cos(x);
y_3 = cos(x.^2/5);
line_1 = plot(x,y_1)
hold on
line_2 = plot(x,y_2)
line_3 = plot(x,y_3)
hold off

% set axes properties

title('Title here, $y = f(x)$','Interpreter','latex')
xlabel('x axis')
ylabel('y axis')
text(x(4),y_1(4),'text')
% legend("y_1 = sin(x)",'y_2 = cos(x)','y_3 = cos(x^2/5)','Location','northoutside')
legend('$y_1 = sin(x)$','$y_2 = cos(x)$','$y_3 = cos(\frac{x^2}{5})$','Interpreter', 'latex', 'Location', 'best')
grid on % show the grid
axis on % show the axis
set(gca, 'YLimitMethod','padded', 'XLimitMethod','padded')

% set line properties

line_1.LineWidth = 1.3;
line_1.Color = 'blue';
line_1.Marker = '.';
line_1.MarkerSize = 8;
line_1.MarkerEdgeColor = 'b';

line_2.LineWidth = 1.3;
line_2.Color = 'red';
line_2.Marker = ">";
line_2.MarkerSize = 8;
line_2.MarkerEdgeColor = 'r';
line_2.MarkerIndices = 1:3:length(y_2); % set marker inteval 3

line_3.LineWidth = 1.3;
line_3.Color = 'black';
line_3.Marker = 's';
line_3.MarkerSize = 8;
line_3.MarkerFaceColor = 'yellow'
line_3.MarkerEdgeColor = 'black';
```
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-21-41-47_MatlabNotes(1)-Graphics.png"/></div> -->
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-22-05-30_MatlabNotes(1)-Graphics.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-23-56-26_MatlabNotes(1)-Graphics.png"/></div>

```matlab
% Attention: some uifigure controls cannot be exported by export_fig and will not appear in the generated output.
% export_fig 不支持具有多个坐标系的坐标区对象副本。

x = linspace(0,25, 100);
y = sin(x/2);
r = x.^2/2;

yyaxis left
left = plot(x,y)
hold on
yyaxis right
right = plot(x,r)
yyaxis left
hold off

title('Plots with Different y-Scales')
xlabel('Values from 0 to 25')
ylabel('Left Side')
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-22-39-44_MatlabNotes(1)-Graphics.png"/></div>

Refer [here](https://www.mathworks.com/help/releases/R2019b/matlab/examples.html?s_tid=CRUX_topnav&category=line-plots) for more examples. 


</details>
<!-- details begin -->
<details>
<summary><span class='Word'> plot3 </span>: 3-D point or line plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/plot3.html).

```matlab
t = 0:pi/500:pi;
xt1 = sin(t).*cos(10*t);
yt1 = sin(t).*sin(10*t);
zt1 = cos(t);

xt2 = sin(t).*cos(12*t);
yt2 = sin(t).*sin(12*t);
zt2 = cos(t);

p1 = plot3(xt1,yt1,zt1)
hold on 
p2 = plot3(xt2,yt2,zt2)
hold off

p1.LineWidth = 1.3;
p1.Color = 'blue';
p1.Marker = 'none';

p2.LineWidth = 1.3;
p2.Color = 'red';
p2.Marker = 'none';
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-22-19-45_MatlabNotes(1)-Graphics.png"/></div>
</details>
<!-- details begin -->
<details>
<summary><span class='Word'>stairs </span>: Stairstep graph</summary>

Official link [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/stairs.html).

```matlab
X = linspace(0,1,30)';
Y = [cos(10*X), exp(X).*sin(10*X)];
h = stairs(X,Y);
hold on 
line = plot(X(:,1),Y(:,1))
hold off

h(1).Marker = 'o';
h(1).MarkerSize = 4;
h(1).LineStyle = "-."
h(2).Marker = 'o';
h(2).MarkerFaceColor = 'm';
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-22-44-05_MatlabNotes(1)-Graphics.png"/></div>
</details>
<!-- details begin -->
<details>
<summary><span class='Word'> errorbar</span>: Line plot with error bars</summary>

Official link [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/errorbar.html).

```matlab
x = 1:10:100;
y = [20 30 45 40 60 65 80 75 95 90]; 
err = [5 8 2 9 3 3 8 3 9 3];
bar1 = errorbar(x,y,err)
hold on
y = 50*sin(x) + 50
err = [4 3 5 3 5 3 6 4 3 3];
bar2 = errorbar(x,y,err,'both','o')
x = 1:10:100;
y = [20 30 45 40 60 65 80 75 95 90];
yneg = [1 3 5 3 5 3 6 4 3 3];
ypos = [2 5 3 5 2 5 2 2 5 5];
xneg = [1 3 5 3 5 3 6 4 3 3];
xpos = [2 5 3 5 2 5 2 2 5 5];
bar3 = errorbar(x,y,yneg,ypos,xneg,xpos,'s')
hold off

bar1.LineWidth = 1.3;
bar1.Color = 'b'

bar3.MarkerSize = 10
bar3.MarkerEdgeColor = 'red'
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-22-53-34_MatlabNotes(1)-Graphics.png"/></div>
</details>
<!-- details begin -->
<details>
<summary><span class='Word'> area </span>: Filled area 2-D plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/area.html).

```matlab
Y = [1, 5, 3;
     3, 2, 7;
     1, 5, 3;
     2, 6, 1];
Z = [1 3 2 3];
figure
basevalue = -4;
a = area(Y,basevalue)

a(1).LineWidth = 6
a(1).LineStyle = '--'
a(1).FaceColor = 'red'
a(2).FaceColor = 'blue'
a(2).FaceAlpha = 0.4
a(3).FaceColor = [0.4 0.4 0.4]

ax = gca; % current axes
ax.XGrid = 'on';
ax.Layer = 'top';   % put ax at the top layer (then you can see the grid)
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-23-02-45_MatlabNotes(1)-Graphics.png"/></div>
</details>
<!-- details begin -->
<details>
<summary><span class='Word'> stackedplot </span>: Stacked plot of several variables with common x-axis (Since R2018b)</summary>

Official link [here]().

```matlab
X = 0:1:20
Y = randi(100,21,3) % create a 6*3 matrix, whose entries are random numbers in [1,100]
s = stackedplot(X,Y);
s.Title = 'Title here'
s.DisplayLabels = {'RH (%)','T/K','P (in Hg)'}  % use '{}' instead of '[]'
s.LineWidth = 1.3
s.LineProperties(1).LineWidth = 5
s.LineProperties(2).PlotType = 'scatter';
s.LineProperties(3).PlotType = 'stairs';
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-23-57-30_MatlabNotes(1)-Graphics.png"/></div>
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> semilogx, semilogy, loglog, </span>: logarithmic scale plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/loglog.html).

```matlab
x=1:1000;
y=x.^2+exp(x);
subplot(2,2,1)
plot(x,y,'r-')
subplot(2,2,2)
semilogx(x,y,'b-')
subplot(2,2,3)
semilogy(x,y,'m-')
subplot(2,2,4)
loglog(x,y,'k-')
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-00-05-06_MatlabNotes(1)-Graphics.png"/></div>
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> fplot </span>: Plot expression or function</summary>

Official link [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/fplot.html).

```matlab
% Use array operators instead of matrix operators for the best performance. For example, use .* (times) instead of * (mtimes).

subplot(2,2,1)
fplot(@(x) exp(x),[-3 0],'b')
hold on
fplot(@(x) cos(x),[0 3],'b')
hold off
grid on

subplot(2,2,2)
xt = @(t) cos(3*t);
yt = @(t) sin(2*t);
fplot(xt,yt)

subplot(2,2,3)
fp = fplot(@(x) sin(x))
fp.LineStyle = ':';
fp.Color = 'r';
fp.Marker = 'x';
fp.MarkerEdgeColor = 'b';

subplot(2,2,4)
fplot(@sin,[-2*pi 2*pi])
grid on
title('sin(x) from -2\pi to 2\pi')
xlabel('x');
ylabel('y');
ax = gca;
ax.XTick = -2*pi:pi/2:2*pi;
ax.XTickLabel = {'-2\pi','-3\pi/2','-\pi','-\pi/2','0','\pi/2','\pi','3\pi/2','2\pi'};
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-00-11-41_MatlabNotes(1)-Graphics.png"/></div>
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> fimplicit </span>: Plot implicit function</summary>

Official link [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/fimplicit.html).

```matlab
% Use array operators instead of matrix operators for the best performance. For example, use .* (times) instead of * (mtimes).

figure

fp = fimplicit(@(x,y) y.*sin(x) + x.*cos(y) - 1, [-7 7 -7 7])
hold on 
f2 = @(x,y) x.^2 + y.^2 - 8;
fimplicit(f2,'g','LineWidth',2)
hold off

axis square
fp.Color = 'r';
fp.LineStyle = '--';
fp.LineWidth = 2;
```
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-12-48-24_MatlabNotes(1)-Graphics.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-12-51-51_MatlabNotes(1)-Graphics.png"/></div>
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> fplot3 </span>: 3-D parametric curve plotter</summary>

Official link [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/fplot3.html).

```matlab
fplot3(@(t)sin(t), @(t)cos(t), @(t)t, [0 2*pi], 'LineWidth', 2)
hold on
fplot3(@(t)sin(t), @(t)cos(t), @(t)t, [2*pi 4*pi], '--or')
fplot3(@(t)sin(t), @(t)cos(t), @(t)t, [4*pi 6*pi], '-.*c')
hold off
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-12-55-51_MatlabNotes(1)-Graphics.png"/></div>
</details>

### Data Distribution Plots

<!-- details begin -->
<details>
<summary><span class='Word'> histogram </span>: Histogram (bar chart) plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/matlab.graphics.chart.primitive.histogram.html).

```matlab
subplot(1,2,1)
x = randn(10000,1);
y = 1 + randn(5000,1);
h = histogram(x);
hold on

hh = histogram(y);

hold off

h.BinWidth = 0.5;
h.Normalization = 'probability'; % use probability normalization (概率归一化)
h.FaceColor = 'r';
h.EdgeColor = [0 0.5 0.5];

hh.BinWidth = 0.5;
hh.Normalization = 'probability'; % use probability normalization (概率归一化)


% bar chart information
h.Values
h.BinEdges
h.BinCounts

subplot(1,2,2)
h = histogram(x);
hold on
hh = histogram(y);
hold off

h.NumBins = 30;
hh.NumBins = 30;
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-13-11-41_MatlabNotes(1)-Graphics.png"/></div>
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> histogram2 </span>: Bivariate histogram plot (Since R2015b)</summary>

Official link [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/matlab.graphics.chart.primitive.histogram2.html).

```matlab
figure

ax1 = subplot(2,1,1)
x = randn(1000,1);
y = randn(1000,1);
h = histogram2(x, y);

h.NumBins = [30 20];
h.FaceColor = 'flat';
cb = colorbar;
cb.Location = 'eastoutside';
cb.LimitsMode = "auto";

ax2 = subplot(2,1,2)
histogram2(x, y, [30 20], 'DisplayStyle','tile', 'ShowEmptyBins','on');

ax1.FontSize = 20;
ax2.LineWidth = 8;
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-13-29-50_MatlabNotes(1)-Graphics.png"/></div>
</details>


<!-- details begin -->
<details>
<summary><span class='Word'> scatter </span>: Scatter plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2019b/matlab/ref/scatter.html).

```matlab
figure 
x = linspace(0,3*pi,200);
y = cos(x) + rand(1,200);
sc = scatter(x,y);

sc.SizeData = linspace(1,100,200);
sc.CData = linspace(1,10,length(x));
sc.MarkerFaceColor = "flat"
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-13-36-02_MatlabNotes(1)-Graphics.png"/></div>
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> scatter3 </span>: 3-D scatter plot </summary>

Official link [here]().

```matlab
```

</details>

<!-- details begin -->
<details>
<summary><span class='Word'>  </span>: </summary>

Official link [here]().

```matlab
```

</details>

<!-- details begin -->
<details>
<summary><span class='Word'>  </span>: </summary>

Official link [here]().

```matlab
```

</details>

<!-- details begin -->
<details>
<summary><span class='Word'>  </span>: </summary>

Official link [here]().

```matlab
```

</details>
## By Request 

There are some commonly used functions for plotting data in Matlab. It is worth learning them more deeply. 


## Export 

There are several ways to export figures in Matlab. You can defenitely follow the [official documentation](https://www.mathworks.com/help/releases/R2019b/matlab/creating_plots/saving-your-work.html) and [here](https://www.mathworks.com/help/releases/R2019b/matlab/printing-and-exporting.html?s_tid=CRUX_lftnav), but some extensions can do this perfectly while others may require some additional steps. Here are our recommendations.

### Entension: export_fig

[export_fig](https://ww2.mathworks.cn/matlabcentral/fileexchange/23629-export_fig) is most popular extension for exporting figures in Matlab. It has the highest number of downloads (352.6K by 2024-7-18)

To use this extension, download it [here](https://www.mathworks.com/matlabcentral/fileexchange/23629-export_fig), unzip the files to any path. Then, open your matlab, type the command below and press enter to add its path.  That's it! You can now use the functions to export your figures. 

```matlab
% add export_fig path
addpath(genpath("your file path to export_fig"));savepath;

% For example, my code to add the path is:
addpath(genpath("D:\my apps\matlab-code\learning\altmany-export_fig-3.46.0.0"));savepath;
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-18-28-27_MatlabNotes(1)-Graphics.jpeg"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-13-01-25_MatlabNotes(1)-Graphics.jpg"/></div>

If you have no idea what functions will be used, you can simplily put the folder in your project directory to import all the functions. 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-13-06-16_MatlabNotes(1)-Graphics.png"/></div>
 -->
By the way, when exporting to vector format (pdf & eps), and to bitmap using the painters renderer, ghostscript (http://ghostscript.com) (perhaps also [Xpdf](http://www.xpdfreader.com/download.html)) needs to be installed on your system. You can follow the blog [*Matlab配置export_fig*](https://blog.csdn.net/Liangontheway/article/details/90903348) to download and install them.

### Examples 

Here are some examples of how to use the export_fig extension to export figures. 

You can open the `.m` file of the functions that you want to use for more information and examples, such as `export_fig.m` (as shown below).

``` matlab 
function [imageData, alpha] = export_fig(varargin) %#ok<*STRCL1,*DATST,*TNOW1>
%EXPORT_FIG  Exports figures in a publication-quality format
%
% Examples:
%   imageData = export_fig
%   [imageData, alpha] = export_fig
%   export_fig filename
%   export_fig ... -<format>
%   export_fig ... -nocrop
%   export_fig ... -c[<val>,<val>,<val>,<val>]
% ......
```


### export_fig