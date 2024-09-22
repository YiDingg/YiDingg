# Matlab Notes(4): Animations

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

