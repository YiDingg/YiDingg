# Matlab Notes (1): Graphics 

## Intro 

[Matlab Grphics](https://www.mathworks.com/help/releases/R2022a/matlab/graphics.html?s_tid=CRUX_lftnav)

## Axis Settings 

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


## Graphic Functions 

### Line Plots

Here are the functions to plot the data in a 2-D or 3-D view using a linear scale. 

<!-- details begin -->
<details>
<summary><span class='Word'> plot </span>: 2-D line plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/plot.html). And you can refer [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/matlab.graphics.chart.primitive.line-properties.html) for more line properties. 

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-23-56-26_MatlabNotes(1)-Graphics.png"/></div>

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
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-22-39-44_MatlabNotes(1)-Graphics.png"/></div>

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

Refer [here](https://www.mathworks.com/help/releases/R2022a/matlab/examples.html?s_tid=CRUX_topnav&category=line-plots) for more examples. 


</details>
<!-- details begin -->
<details>
<summary><span class='Word'> plot3 </span>: 3-D point or line plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/plot3.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-22-19-45_MatlabNotes(1)-Graphics.png"/></div>

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
</details>
<!-- details begin -->
<details>
<summary><span class='Word'>stairs </span>: Stairstep graph</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/stairs.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-22-44-05_MatlabNotes(1)-Graphics.png"/></div>

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
</details>
<!-- details begin -->
<details>
<summary><span class='Word'> errorbar</span>: Line plot with error bars</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/errorbar.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-22-53-34_MatlabNotes(1)-Graphics.png"/></div>

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
</details>
<!-- details begin -->
<details>
<summary><span class='Word'> area </span>: Filled area 2-D plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/area.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-23-02-45_MatlabNotes(1)-Graphics.png"/></div>

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
</details>
<!-- details begin -->
<details>
<summary><span class='Word'> stackedplot </span>: Stacked plot of several variables with common x-axis (Since R2018b)</summary>

Official link [here]().
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-18-23-57-30_MatlabNotes(1)-Graphics.png"/></div>

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
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> semilogx, semilogy, loglog, </span>: logarithmic scale plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/loglog.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-00-05-06_MatlabNotes(1)-Graphics.png"/></div>

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

</details>

<!-- details begin -->
<details>
<summary><span class='Word'> fplot </span>: Plot expression or function</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/fplot.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-00-11-41_MatlabNotes(1)-Graphics.png"/></div>

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
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> fimplicit </span>: Plot implicit function</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/fimplicit.html).
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-12-48-24_MatlabNotes(1)-Graphics.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-12-51-51_MatlabNotes(1)-Graphics.png"/></div>

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
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> fplot3 </span>: 3-D parametric curve plotter</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/fplot3.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-12-55-51_MatlabNotes(1)-Graphics.png"/></div>

```matlab
fplot3(@(t)sin(t), @(t)cos(t), @(t)t, [0 2*pi], 'LineWidth', 2)
hold on
fplot3(@(t)sin(t), @(t)cos(t), @(t)t, [2*pi 4*pi], '--or')
fplot3(@(t)sin(t), @(t)cos(t), @(t)t, [4*pi 6*pi], '-.*c')
hold off
```

</details>

### Data Distribution Plots

<!-- details begin -->
<details>
<summary><span class='Word'> histogram </span>: Histogram (bar chart) plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/matlab.graphics.chart.primitive.histogram.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-13-11-41_MatlabNotes(1)-Graphics.png"/></div>

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
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> histogram2 </span>: Bivariate histogram plot (Since R2015b)</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/matlab.graphics.chart.primitive.histogram2.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-13-29-50_MatlabNotes(1)-Graphics.png"/></div>

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
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> swarmchart</span>: Swarm scatter chart</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/swarmchart.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-21-09-06_MatlabNotes(1)-Graphics.png"/></div>

```matlab
x1 = ones(1,500);
x2 = 2 * ones(1,500);
x3 = 3 * ones(1,500);
y1 = 2 * randn(1,500);
y2 = [randn(1,250) randn(1,250) + 4];
y3 = 5 * randn(1,500) + 5;

s1 = swarmchart(x1,y1,5)
hold on
swarmchart(x2,y2,5)
swarmchart(x3,y3,5)
hold off

s1.SizeData = linspace(0.1,20,500)
s1.MarkerEdgeColor = 'b'
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> swarmchart3</span>: 	3-D swarm scatter chart</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/swarmchart3.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-21-12-13_MatlabNotes(1)-Graphics.png"/></div>

```matlab
x = [zeros(1,500) ones(1,500)];
y = randi(2,1,1000);
z = randn(1,1000).^2;
c = sqrt(z);
swarmchart3(x,y,z,50,c,'filled');
cb = colorbar;
cb.Location = 'eastoutside'
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> scatter </span>: Scatter plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/scatter.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-13-36-02_MatlabNotes(1)-Graphics.png"/></div>

```matlab
figure 
x = linspace(0,3*pi,200);
y = cos(x) + rand(1,200);
sc = scatter(x,y);

sc.SizeData = linspace(1,100,200);
sc.CData = linspace(1,10,length(x));
sc.MarkerFaceColor = "flat"
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> scatter3 </span>: 3-D scatter plot </summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/scatter3.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-18-20-43_MatlabNotes(1)-Graphics.png"/></div>

```matlab
z = linspace(0,4*pi,250);
x = 2*cos(z) + rand(1,250);
y = 2*sin(z) + rand(1,250);
sc = scatter3(x,y,z,'filled');

sc.SizeData = linspace(1,20,250);
ax = gca
ax.View = [-30,10];
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> binscatter </span>: 	Binned scatter plot (Since R2017b)</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/binscatter.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-20-19-11_MatlabNotes(1)-Graphics.jpg"/></div>

```matlab
x = randn(1e5,1);
y = randn(1e5,1);
graph = binscatter(x,y)

graph.NumBins = [150 150]
graph.ShowEmptyBins = 'on';

ax = gca;
ax.SortMethod = "childorder"
axis(ax,'equal') 
colormap(ax,"hot")


% export_fig is not working for binscatter, so we use print2eps and eps2pdf instead.
% export_fig( gcf , '-png' , '-r200' , '-painters' , 'C:/Users/13081/Desktop/Test_Matlab/Example_binscatter');
% export_fig( gcf , '-png' , '-r200' , '-painters' , 'C:/Users/13081/Desktop/Test_Matlab/Example_binscatter');
print2eps 'C:/Users/13081/Desktop/Test_Matlab/Example_binscatter'
eps2pdf('C:/Users/13081/Desktop/Test_Matlab/Example_binscatter.eps','C:/Users/13081/Desktop/Test_Matlab/Example_binscatter.pdf')
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> scatterhistogram </span>: Create scatter plot with histograms (Since R2018b)</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/scatterhistogram.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-21-53-30_MatlabNotes(1)-Graphics.png"/></div>

```matlab
xvalues = [7 6 5 6.5 9 7.5 8.5 7.5 10 8];
yvalues = categorical({'onsale','regular','onsale','onsale', ...
    'regular','regular','onsale','onsale','regular','regular'});
grpvalues = {'Red','Black','Blue','Red','Black','Blue','Red', ...
    'Red','Blue','Black'};
s = scatterhistogram(xvalues,yvalues,'GroupData',grpvalues);

s.Title = 'Shoe Sales';
s.XLabel = 'Shoe Size';
s.YLabel = 'Price';
s.LegendTitle = 'Shoe Color';

s.Color = {'Red','Black','Blue'};
s.BinWidths = 1;
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> spy </span>: Visualize sparsity pattern of matrix</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/spy.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-20-31-28_MatlabNotes(1)-Graphics.png"/></div>

```matlab
B = bucky;
spy(B)
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> plotmatrix </span>: Scatter plot matrix</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/plotmatrix.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-20-38-03_MatlabNotes(1)-Graphics.png"/></div>

```matlab
X = randn(50,3);  
plotmatrix(X)
```
</details>


<!-- details begin -->
<details>
<summary><span class='Word'>pie </span>: Pie chart</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/pie.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-20-49-59_MatlabNotes(1)-Graphics.png"/></div>

```matlab
X = 1:3;
explode = [0 1 0]
labels = {'Taxes','Expenses','Profit'};
p = pie(X,explode,labels);

t = p(6);
t.BackgroundColor = 'cyan';
t.EdgeColor = 'red';
t.FontSize = 14;

p(1).FaceColor = 'r'
p(2).String = 'new name here'
p(2).Color = 'r'
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> pie3</span>: 3-D pie chart</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/pie3.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-20-57-39_MatlabNotes(1)-Graphics.png"/></div>

```matlab
X = 1:3;
explode = [0 1 0]
labels = {'Taxes','Expenses','Profit'};
p = pie3(X,explode,labels);
le = legend(labels);
le.Location = 'best';

t = p(6);
t.FaceColor = 'blue';
t.EdgeColor = 'red';
t.MarkerSize = 50;

p(1).MarkerFaceColor = 'white';
p(3).FaceColor = 'w';
p(2).FaceColor = 'black';
p(4).String = 'new name here'
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>heatmap</span>: Create heatmap chart</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/heatmap.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-21-51-03_MatlabNotes(1)-Graphics.png"/></div>

```matlab
cdata = [45 60 32; 43 54 76; 32 94 68; 23 95 58];
xvalues = {'Small','Medium','Large'};
yvalues = {'Green','Red','Blue','Gray'};
h = heatmap(xvalues,yvalues,cdata);

h.Title = 'T-Shirt Orders';
h.XLabel = 'Sizes';
h.YLabel = 'Colors';
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>bubblechart</span>: Bubble chart</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/bubblechart.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-22-08-52_MatlabNotes(1)-Graphics.png"/></div>

```matlab
x = 1:20;
y = rand(1,20);
sz = rand(1,20);
c = 1:20;
bc = bubblechart(x,y,sz,c);
bc.MarkerEdgeColor = 'red'

xlabel('Number of Industrial Sites')
ylabel('Contamination Level')
le = bubblelegend('Town Population','Location','eastoutside')
le.Color = 'red'
le.TextColor = 'white'
le.EdgeColor = 'blue'
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'> wordcloud</span>: Create word cloud chart from text data</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/wordcloud.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-22-00-06_MatlabNotes(1)-Graphics.png"/></div>

```matlab
sonnets = string(fileread('sonnets.txt'));
extractBefore(sonnets,"II")
punctuationCharacters = ["." "?" "!" "," ";" ":"];
sonnets = replace(sonnets,punctuationCharacters," ");
words = split(join(sonnets));
words(strlength(words)<5) = [];
words = lower(words);
words(1:10)
[numOccurrences,uniqueWords] = histcounts(categorical(words));
figure
wordcloud(uniqueWords,numOccurrences);
title("Sonnets Word Cloud")
```
</details>


<!-- details begin -->
<details>
<summary><span class='Word'> bubblecloud</span>: Create bubble cloud chart</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/bubblecloud.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-22-01-39_MatlabNotes(1)-Graphics.png"/></div>

```matlab
c = categorical(["Pumpkin" "Princess" "Princess" "Princess" "Spooky Monster" ...
    "Spooky Monster" "Spooky Monster" "Spooky Monster" "Spooky Monster"]);
[sz,labels] = histcounts(c);
bubblecloud(sz,labels)
```
</details>

### Discrete Data Plots

<!-- details begin -->
<details>
<summary><span class='Word'>bar, barh</span>: 	Bar graph</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/bar.html).
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-22-22-55_MatlabNotes(1)-Graphics.png"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-22-24-52_MatlabNotes(1)-Graphics.png"/></div>

```matlab
subplot(2,2,1)
x = 1900:10:2000;
y = [75 91 105 123.5 131 150 179 203 226 249 281.5];
b = bar(x,y);
b.BarWidth = 0.4

subplot(2,2,2)
y = [2 2 3; 2 5 6; 2 8 9; 2 11 12];
b2 = bar([1920 1950 1980],y)
b2(1).FaceColor = 'r'
b2(2).FaceColor = 'b'

subplot(2,2,3)
b3 = bar([1920 1950 1980],y,'stacked');

subplot(2,2,4)
x = [1980 1990 2000];
y = [40 50 63 52; 42 55 50 48; 30 20 44 40];
barh(x,y)
xlabel('Snowfall')
ylabel('Year')
le = legend({'Springfield','Fairview','Bristol','Jamesville'})
le.Location = 'northoutside'
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>bar3, bar3h</span>: 3-D bar graph</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/bar3.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-22-37-05_MatlabNotes(1)-Graphics.png"/></div>

```matlab
figure
y = 0:pi/8:4*pi;
z = [sin(y')/4 sin(y')/2 sin(y')];
ba = bar3(y,z,0.5)
ba(1).FaceColor = 'k';
ba(2).FaceColor = 'white';
ba(3).FaceColor = [.5 .7 .8];
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>pareto</span>: Pareto chart</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/pareto.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-22-37-59_MatlabNotes(1)-Graphics.png"/></div>

```matlab
y = [20 30 10 55 5];
[charts, ax] = pareto(y);
charts(1).FaceColor = [0.50  0.37  0.60];
charts(2).Color = [0 0.50 0.10];
ax(1).YColor = [0.50 0.37 0.60];
ax(2).YColor = [0 0.50 0.10];
grid on
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>stem</span>: Plot discrete sequence data</summary>

Official link [here]().
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-22-42-13_MatlabNotes(1)-Graphics.png"/></div>

```matlab
figure
X = linspace(0,2*pi,50)';
Y = (exp(X).*sin(X));
s = stem(X,Y,':diamondr')
s.MarkerFaceColor = 'black'
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>stem3</span>: Plot 3-D discrete sequence data</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/stem3.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-19-22-52-32_MatlabNotes(1)-Graphics.png"/></div>

```matlab
X = linspace(-2,2,50);
Y = X.^3;
Z = exp(X);
tiledlayout(2,1)

ax2 = nexttile;  
stem3(ax2,X,Y,Z)

ax3 = nexttile;  
stem3(ax3,X,Y,Z)
ax3.View = [0 0]
```
</details>

### Surface and Mesh Plots

<!-- details begin -->
<details>
<summary><span class='Word'>surf, surface</span>: Surface plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/surf.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-20-00-22-49_MatlabNotes(1)-Graphics.png"/></div>

```matlab
[X,Y] = meshgrid(1:0.25:10,1:0.5:20);
Z = sin(X) + cos(Y);

figure
tiledlayout(2,2)

nexttile
s = surf(X,Y,Z);
ax1 = gca;
ax1.View = [40 50];
cb = colorbar;
cb.Location = "eastoutside"

s.FaceColor = "interp";  % interpolate the colormap across the surface face
s.EdgeColor = "none";
colormap(ax1,"hot")

nexttile
s = surface(X,Y,Z);
ax1 = gca;
view(2) % Display the plot in a 2-D view.

s.FaceColor = "interp";  % interpolate the colormap across the surface face
s.EdgeColor = "none";
colormap(ax1,"hot")


nexttile
s = surf(X,Y,Z);
ax2 = gca;
ax2.View = [40 50];
colormap(ax2,"hot")

s.FaceColor = "interp";  % interpolate the colormap across the surface face
s.EdgeColor = "none";
light               % create a light
lighting gouraud    % preferred method for lighting curved surfaces
material dull    % set material to be dull, no specular highlights


nexttile
s = surf(X,Y,Z);

ax2 = gca;
view(2) % Display the plot in a 2-D view.
s.FaceColor = "interp";  % interpolate the colormap across the surface face
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>surfc</span>: Contour plot under surface plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/surfc.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-20-00-25-46_MatlabNotes(1)-Graphics.png"/></div>

```matlab
figure
[X,Y] = meshgrid(-3:.125:3);
Z = peaks(X,Y);
C = X.*Y;
surfc(X,Y,Z,C)
colorbar
view([-40 -60 20])
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>mesh</span>: Mesh surface plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/mesh.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-20-00-35-11_MatlabNotes(1)-Graphics.jpg"/></div>



```matlab
tiledlayout(2,1)

nexttile
[X,Y] = meshgrid(-8:.5:8);
R = sqrt(X.^2 + Y.^2) + eps;
Z = sin(R)./R;
m = mesh(X,Y,Z)
colorbar 

nexttile
[X,Y] = meshgrid(-8:.5:8);
R = sqrt(X.^2 + Y.^2) + eps;
Z = sin(R)./R;
m = mesh(X,Y,Z)
m.EdgeColor = "none"
m.FaceColor = "interp"
colorbar 
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>meshc</span>: Contour plot under mesh surface plot</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/meshc.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-20-00-37-49_MatlabNotes(1)-Graphics.jpg"/></div>

```matlab
figure
[X,Y] = meshgrid(-3:.125:3);
Z = peaks(X,Y);
C = X.*Y;
meshc(X,Y,Z,C)
colorbar
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>meshz</span>: Mesh surface plot with curtain</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/meshz.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-20-00-38-26_MatlabNotes(1)-Graphics.jpg"/></div>

```matlab
figure
[X,Y] = meshgrid(-3:.125:3);
Z = peaks(X,Y);
C = X.*Y;
meshz(X,Y,Z,C)
colorbar
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>fsurf, fmesh</span>: Plot 3-D surface or mesh</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/fsurf.html).
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-20-17-02-12_MatlabNotes(1)-Graphics.jpg"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-20-17-18-40_MatlabNotes(1)-Graphics.jpg"/></div>

```matlab
figure

t = tiledlayout(4,2)

nexttile(1,[2 2])
f1 = @(x,y) erf(x)+cos(y);  
fs1 = fsurf(f1,[-5 0 -5 5]);
hold on
f2 = @(x,y) sin(x)+cos(y);
fs2 = fsurf(f2,[0 5 -5 5]);
hold off

% surface properties

fs1.EdgeColor = 'none';
fs2.ShowContours = 'on' % show the contour 
fs2.EdgeColor = 'none';
camlight

% axes properties

xlim([-5 5])
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
zlabel('$z$','Interpreter','latex','Rotation',0)


nexttile(5,[2 2])
f1 = @(x,y) erf(x)+cos(y);  
fm1 = fmesh(f1,[-5 0 -5 5]);
hold on
f2 = @(x,y) sin(x)+cos(y);
fm2 = fmesh(f2,[0 5 -5 5]);
hold off

xlim([-5 5])
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
zlabel('$z$','Interpreter','latex','Rotation',0)

fm2.ShowContours = 'on';

% tile properties

title(t,'title here')
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>fimplicit3</span>: 	Plot 3-D implicit function</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/fimplicit3.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-20-17-06-05_MatlabNotes(1)-Graphics.jpg"/></div>

```matlab
figure

f = @(x,y,z) x.^2 + y.^2 - z.^2;
fin = fimplicit3(f);

% properties (similar with function fsurf)
fin.EdgeColor = "none";
camlight
```
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>fill, fill3</span>: Create filled 2-D or 3-D patches</summary>

Official link [here](https://www.mathworks.com/help/releases/R2022a/matlab/ref/fill.html).
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-20-17-16-53_MatlabNotes(1)-Graphics.png"/></div>

```matlab

```
</details>

## By Request 

There are some commonly used functions for plotting data in Matlab. It is worth learning them more deeply. 

<!-- details begin -->
<details>
<summary><span class='Word'></span>: </summary>

Official link [here]().


```matlab

```
</details>

## Export 

There are several ways to export figures in Matlab. You can defenitely follow the [official documentation](https://www.mathworks.com/help/releases/R2022a/matlab/creating_plots/saving-your-work.html) and [here](https://www.mathworks.com/help/releases/R2022a/matlab/printing-and-exporting.html?s_tid=CRUX_lftnav), but some extensions can do this perfectly while others may require some additional steps. Here are our recommendations.

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

```matlab
export_fig( gcf , '-p0.02','-png' , '-r150' , '-painters' , 'C:/Users/13081/Desktop/Test_Matlab/Example_stem');
```

### Examples 

You can open the `.m` file of the functions that you want to use for more information and examples, such as `export_fig.m` (as shown below). Also, refer [GitHub: export_fig](https://github.com/altmany/export_fig)  for more examples and tutorials.

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