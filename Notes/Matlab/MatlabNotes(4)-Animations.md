# Matlab Notes(4): Animations

> [!Note|style:callout|label:Infor]
Initially published at 19:48 on 2024-09-22 in Beijing.


Animate a simple plot:
```matlab
% Create a simple plot
x = linspace(0,2*pi,100);
y = sin(x);
figure
h = plot(x,y);
axis tight manual % this ensures that getframe() returns a consistent size
for n = 1:0.1:10
    y = sin(x + n/10);
    h.YData = y;
    drawnow
end
```

Animate a simple plot with a trail:
```matlab
% Create a simple plot with a trail
x = linspace(0,2*pi,100);
y = sin(x);
figure
h = plot(x,y);
axis tight manual % this ensures that getframe() returns a consistent size
for n = 1:0.1:10
    y = sin(x + n/10);
    h.YData = y;
    drawnow
    pause(0.1)
end
```

Animate a simple plot with a trail and save as a GIF:
```matlab
% Create a simple plot with a trail and save as a GIF
x = linspace(0,2*pi,100);
y = sin(x);
figure
h = plot(x,y);
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'sine_wave.gif';
for n = 1:0.1:10
    y = sin(x + n/10);
    h.YData = y;
    drawnow
    % Capture the plot as an image
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    if n == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end
```

## Export 

### .mp4

Here is an example:

```matlab
%%%%%%%%%% 两个球面波源在平面上的干涉情况 (以 z 轴为标量电场 E) %%%%%%%%%%
global lambda k omega X_OA X_OB A B

lambda = 550.0 * 10^(-9); % 单位: m
k = 1.3;      % k 取决于光的波长，但在可视化中不妨令为 1
omega = 1;  % omega 取决于光的波长，但在可视化中不妨令为 1
X_OA = [-2, 0];  % 球面波源 A 的位置
X_OB = [ 2, 0];  % 球面波源 B 的位置
A = 50; % r = 1 时 A 的振幅
B = 50; % r = 1 时 B 的振幅

E_A0 = @(x, y) A./sqrt( (x - X_OA(1)).^2 + (y - X_OA(2)).^2 ); % X 位置的振幅, 输入的 X_array 为一列行向量
E_B0 = @(x, y) B./sqrt( (x - X_OB(1)).^2 + (y - X_OB(2)).^2 ); % X 位置的振幅, 输入的 X_array 为一列行向量
alpha_A = @(x, y) k*sqrt( (x - X_OA(1)).^2 + (y - X_OA(2)).^2 );
alpha_B = @(x, y) k*sqrt( (x - X_OB(1)).^2 + (y - X_OB(2)).^2 );
E_0 = @(E_A0, alpha_A, E_B0, alpha_B) sqrt( E_A0.^2 + E_B0.^2 + 2*E_A0.*E_B0.*cos(alpha_A - alpha_B) );
vib = @(E_0, t, alpha) E_0.*cos(-omega*t + alpha); % 振荡函数

R_array = linspace(4, 20, 80);
theta_array = transpose(linspace(0, 2*pi, 30));
x_matrix = R_array .* cos(theta_array);
y_matrix = R_array .* sin(theta_array);
%E_0_matrix = E_A0(x_matrix, y_matrix);

E_A0_matrix = E_A0(x_matrix, y_matrix);
E_B0_matrix = E_B0(x_matrix, y_matrix);
alpha_A_matrix = alpha_A(x_matrix, y_matrix);
alpha_B_matrix = alpha_B(x_matrix, y_matrix);
E_0_matrix = E_0(E_A0_matrix, alpha_A_matrix, E_B0_matrix, alpha_B_matrix);
alpha_matrix = GetAlpha(E_0_matrix, E_A0_matrix, alpha_A_matrix, E_B0_matrix, alpha_B_matrix);

MyMesh(x_matrix, y_matrix, vib(E_A0_matrix, 0, alpha_A_matrix), 1);
MyMesh(x_matrix, y_matrix, vib(E_B0_matrix, 0, alpha_B_matrix), 1);
MyMesh(x_matrix, y_matrix, vib(E_0_matrix, 0, alpha_matrix), 1);

figure 
    h = surf(x_matrix, y_matrix, E_0_matrix, 'EdgeColor', 'interp', FaceColor='interp');
    hold on
    surf([X_OA(1) X_OA(1)], [X_OA(2) X_OA(2)], [40 -40; 40 -40])
    surf([X_OB(1) X_OB(1)], [X_OB(2) X_OB(2)], [40 -40; 40 -40])
    colormap(redblue);
    zlim([-35 35]);
    xlim([-R_array(end), R_array(end)])
    ylim([-R_array(end), R_array(end)])
    drawnow

t_array = linspace(0, 10, 50);
for i = 1:length(t_array)
    h.ZData = vib(E_0_matrix, t_array(i), alpha_matrix);
    drawnow
    %export_fig( gcf , '-p0.00','-png' , ['-r', num2str(100)] , '-painters' , ['D:/aa_MyGraphics/Test/img', num2str(i)]);
end

function alpha = GetAlpha(E_0, E_A0, alpha_A, E_B0, alpha_B)
    sin_alpha = ( E_A0.*sin(alpha_A) + E_B0.*sin(alpha_B) ) ./ E_0;
    cos_alpha = ( E_A0.*cos(alpha_A) + E_B0.*cos(alpha_B) ) ./ E_0;
    %{
        if cos_alpha > 0
            alpha = acos(cos_alpha);
            return
        elseif cos_alpha == 0
            sin_alpha = ( E_A_0.*sin(alpha_A) + E_B_0.*sin(alpha_B) ) ./ E_0;
            if sin_alpha > 0
                alpha = pi/2;
                return
            else
                alpha = -pi/2;
                return
            end
        else
            alpha = pi - acos(cos_alpha);
            return 
        end
    %}
    alpha = (cos_alpha >= 0) .* asin(sin_alpha) + (cos_alpha < 0) .* ( pi - asin(sin_alpha));
    %alpha =  acos(cos_alpha);
end
```

After running the code in a `.mlx` file, click the button 'export' to export it to `.mp4` or `.gif`, and the former is recommended.

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-23-01-05-04_MatlabNotes(4)-Animations.jpg"/></div>

### .gif

Here is an example:

``` matlab
%%%%%%%%%%%%%%% 导出为 gif, 缺点是无法 interp facecolor

clc, clear, close all;
global lambda k omega X_OA X_OB A B

lambda = 550.0 * 10^(-9); % 单位: m
k = 1.3;      % k 取决于光的波长，但在可视化中不妨令为 1
omega = 1;  % omega 取决于光的波长，但在可视化中不妨令为 1
X_OA = [-2, 0];  % 球面波源 A 的位置
X_OB = [ 2, 0];  % 球面波源 B 的位置
A = 50; % r = 1 时 A 的振幅
B = 50; % r = 1 时 B 的振幅

E_A0 = @(x, y) A./sqrt( (x - X_OA(1)).^2 + (y - X_OA(2)).^2 ); % X 位置的振幅, 输入的 X_array 为一列行向量
E_B0 = @(x, y) B./sqrt( (x - X_OB(1)).^2 + (y - X_OB(2)).^2 ); % X 位置的振幅, 输入的 X_array 为一列行向量
alpha_A = @(x, y) k*sqrt( (x - X_OA(1)).^2 + (y - X_OA(2)).^2 );
alpha_B = @(x, y) k*sqrt( (x - X_OB(1)).^2 + (y - X_OB(2)).^2 );
E_0 = @(E_A0, alpha_A, E_B0, alpha_B) sqrt( E_A0.^2 + E_B0.^2 + 2*E_A0.*E_B0.*cos(alpha_A - alpha_B) );
vib = @(E_0, t, alpha) E_0.*cos(-omega*t + alpha); % 振荡函数

R_array = linspace(4, 20, 80);
theta_array = transpose(linspace(0, 2*pi, 30));
x_matrix = R_array .* cos(theta_array);
y_matrix = R_array .* sin(theta_array);
%E_0_matrix = E_A0(x_matrix, y_matrix);

E_A0_matrix = E_A0(x_matrix, y_matrix);
E_B0_matrix = E_B0(x_matrix, y_matrix);
alpha_A_matrix = alpha_A(x_matrix, y_matrix);
alpha_B_matrix = alpha_B(x_matrix, y_matrix);
E_0_matrix = E_0(E_A0_matrix, alpha_A_matrix, E_B0_matrix, alpha_B_matrix);
alpha_matrix = GetAlpha(E_0_matrix, E_A0_matrix, alpha_A_matrix, E_B0_matrix, alpha_B_matrix);

MyMesh(x_matrix, y_matrix, vib(E_A0_matrix, 0, alpha_A_matrix), 1);
MyMesh(x_matrix, y_matrix, vib(E_B0_matrix, 0, alpha_B_matrix), 1);
MyMesh(x_matrix, y_matrix, vib(E_0_matrix, 0, alpha_matrix), 1);


figure 
set(gca,'NextPlot','replaceChildren','box','on','color','w');
 
    h = mesh(x_matrix, y_matrix, E_0_matrix, 'EdgeColor', 'interp', FaceColor='interp');
    hold on
    surf([X_OA(1) X_OA(1)], [X_OA(2) X_OA(2)], [40 -40; 40 -40])
    surf([X_OB(1) X_OB(1)], [X_OB(2) X_OB(2)], [40 -40; 40 -40])
    hold off
    view([45, 30])
    colormap(redblue);
    zlim([-35 35]);
    xlim([-R_array(end), R_array(end)])
    ylim([-R_array(end), R_array(end)])
    drawnow

t_array = linspace(0, 15, 80);
numFrames = length(t_array);
for i = 1:numFrames
    h.ZData = vib(E_0_matrix, t_array(i), alpha_matrix);
    f(i) = getframe(gcf);
end
 
animated(1,1,1,numFrames) = 0;
for i = 1:numFrames
    if i == 1
        [animated,cmap] = rgb2ind(f(i).cdata,256,'nodither');
    else
        animated(:,:,1,i) = rgb2ind(f(i).cdata,cmap,'nodither');
    end
end
filename = 'test.gif';
imwrite(animated,cmap,filename,'DelayTime',1/20,'LoopCount',inf);
web(filename)

function alpha = GetAlpha(E_0, E_A0, alpha_A, E_B0, alpha_B)
    sin_alpha = ( E_A0.*sin(alpha_A) + E_B0.*sin(alpha_B) ) ./ E_0;
    cos_alpha = ( E_A0.*cos(alpha_A) + E_B0.*cos(alpha_B) ) ./ E_0;
    %{
        if cos_alpha > 0
            alpha = acos(cos_alpha);
            return
        elseif cos_alpha == 0
            sin_alpha = ( E_A_0.*sin(alpha_A) + E_B_0.*sin(alpha_B) ) ./ E_0;
            if sin_alpha > 0
                alpha = pi/2;
                return
            else
                alpha = -pi/2;
                return
            end
        else
            alpha = pi - acos(cos_alpha);
            return 
        end
    %}
    alpha = (cos_alpha >= 0) .* asin(sin_alpha) + (cos_alpha < 0) .* ( pi - asin(sin_alpha));
    %alpha =  acos(cos_alpha);
end
```


## Insert GIF in Latex

## Enviroment

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

Refer to [Blogs/Mixed/Latex --> Insert GIF in Latex](https://yidingg.github.io/YiDingg/#/Blogs/Mixed/Latex?id=insert-gif-in-latex) for more details, you can also refer to [ImageMagick](https://www.imagemagick.org/script/command-line-processing.php) for more advanced usage.

