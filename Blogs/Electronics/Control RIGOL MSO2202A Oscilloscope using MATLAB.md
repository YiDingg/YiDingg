# 用 MATLAB 控制普源 (RIGOL) MSO2202A 数字示波器

> [!Note|style:callout|label:Infor]
Initially published at 16:26 on 2025-03-21 in Beijing.

## Intro

如何在电脑上用 MATLAB 来控制普源 (RIGOL) MSO2202A 数字示波器？本文基于普源 (RIGOL) MSO2202A 数字示波器的官方编程手册，给出了常用命令的解释和 MATLAB 代码示例。

## 官方资料

- 官网 MSO2000A/DS2000A 编程手册：[https://www.rigol.com/Images/MSO2000ADS2000AProgrammingGuideCN_tcm4-2899.pdf]( https://www.rigol.com/Images/MSO2000ADS2000AProgrammingGuideCN_tcm4-2899.pdf) (MSO2202A 属于 MSO2000A 系列)


官方 MATLAB 编程实例：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-16-44-13_Control RIGOL MSO2202A Oscilloscope using MATLAB.png"/></div>

代码如下：

``` matlab
% RIGOL MSO2000A Oscilloscope Control Example
% https://www.rigol.com/Images/MSO2000ADS2000AProgrammingGuideCN_tcm4-2899.pdf
% 本例使用的程序：MATLAB R2009a 
% 本例实现的功能：对波形数据进行FFT计算，并绘制波形。 
% demo.m

% 创建VISA对象。'ni'为销售商参数，可以为agilent、NI或tek，
'USB0::0x1AB1::0x04B0::DS2A0000000000::INSTR'为设备的资源描述符。创建后需设置设备的属性，
本例中设置输入缓存的长度为2048 
MSO2000A = visa( 'ni','USB0::0x1AB1::0x04B0::DS2A0000000000::INSTR' ); 
MSO2000A.InputBufferSize = 2048; 

% 打开已创建的VISA对象 
fopen(MSO2000A); 
% 读取波形 
fprintf(MSO2000A, ':wav:data?' );  
% 请求数据 
[data,len]= fread(MSO2000A,2048); 
% 关闭设备 
fclose(MSO2000A); 
delete(MSO2000A); 
clear MSO2000A; 

% 数据处理。读取的波形数据含有TMC头，长度为11个字节，其中前2个字节分别为TMC头标志符#和宽度描述符9，接着的9个字节为数据长度，然后是波形数据，最后一个字节为结束符0x0A。所
以，读取的有效波形数据点为12到倒数第2个点。 
wave = data(12:len-1); 
wave = wave'; 
subplot(211); 
plot(wave); 
fftSpec = fft(wave',2048); 
fftRms = abs( fftSpec'); 
fftLg = 20*log(fftRms); 
subplot(212); 
plot(fftLg); 
```

实测效果：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-17-22-53_Control RIGOL MSO2202A Oscilloscope using MATLAB.png"/></div>

## 官方控制代码解读


下面是我们对常用功能进行的测试：

``` matlab
clc, clear, close all

%MyOscilloscope_MSO2202A_read(mode, channel)


%{
如果有警告：
警告: The EOI line was asserted before SIZE values were available.
 visa’ unable to read all requested data. For more information on possible reasons, see VISA Read Warnings.
不用担心, 这是因为我们请求了较多字节的数据 (InputBufferSize), 但是返回的数据没那么长导致的。
%}

instrreset  % 创建 visa 对象前, 断开并删除全部对象, 防止报错

% 创建设备：
%   第一个参数为销售商参数, 可以为 agilent, NI, tek
%   第二个参数为资源描述符 (通讯地址), 创建后需要设置设备的属性, 例如设置输入缓存的长度为 2048
stc_visa = visa( 'NI', 'USB0::0x1AB1::0x04B0::DS2F192200361::INSTR' );
%stc_visa.InputBufferSize = 1024*100;  % 一般示波器返回 1400 个数据点
stc_visa.InputBufferSize = 2048;
%stc_visa.OutputBufferSize = stc_visa.InputBufferSize;
%set(stc_visa, 'InputBufferSize', 1e8)
%set(stc_visa, 'OutputBufferSize', 1e8)


fopen(stc_visa);    % 打开已创建的VISA对象


%指定获取波形的通道，格式，数据大小，采样长度；


% 无需改动的数据读取设置
fprintf(stc_visa,':WAVEFORM:FORMAT BYTE');  % 设置数据传输形式, {WORD|BYTE|ASCii}

% 数据读取设置
fprintf(stc_visa,':WAVeform:SOURce CHANnel1');  % 设置要读取的通道, {CHANnel1|CHANnel2|MATH|FFT|LA}
fprintf(stc_visa,':WAVeform:MODE NORMal');  % 设置读取模式, {NORMal|RAW|MAXimum}
fprintf(stc_visa,':WAVeform:Start 1');
fprintf(stc_visa,':WAVeform:POINts 1400');
%fprintf(stc_visa,':WAVeform:Stop 1400');
%fprintf(stc_visa,':WAVeform:MODE?'); char(fread( stc_visa, 2048 )) % 检查模式是否设置成功
%fprintf(stc_visa,':WAVeform:POINts 1100');  % 设置需要读取的波形点数, 波形点数的可设置范围受当前波形读取模式的限制
%fprintf(stc_visa,':WAVeform:MODE?');
%fprintf(stc_visa,':WAVeform:STARt?'); char(fread( stc_visa, 2048 ))
%fprintf(stc_visa,':WAVeform:STOP?'); char(fread( stc_visa, 2048 ))

% 检查相关参数
%fprintf(stc_visa,':WAVeform:PREamble?'); char(fread( stc_visa, 2048 ))'
%{
<format>,<type>,<points>,<count>,<xincrement>,<xorigin>,<xreference>,<yincrement>,<yorigin>
 ,<yreference> 
其中， 
<format>：0（BYTE）、1（WORD）或2（ASC）。请参考:WAVeform:FORMat命令。 
<type>：0（NORMal）、1（MAXimum）或2（RAW）。请参考:WAVeform:MODE命令。 
<points>：1 至 56000000 之间的整数。请参考:WAVeform:POINts命令。 
<count>：在平均采样方式下为平均次数（请参考:ACQuire:AVERages命令），其它方式下为1。 
<xincrement>：X 方向上的相邻两点之间的时间差（科学计数形式）。请参考:WAVeform:XINCrement?命令。 
<xorigin>：X 方向上波形数据的起始时间（科学计数形式）。请参考:WAVeform:XORigin?命令。 
<xreference>：X 方向上数据点的参考时间基准（整数形式）。请参考:WAVeform:XREFerence?命令。 
<yincrement>：Y 方向上的单位电压值（科学计数形式）。请参考:WAVeform:YINCrement?命令。 
<yorigin>：Y 方向上相对于“垂直参考位置”的垂直偏移（整数形式）。请参考:WAVeform:YORigin?命令。 
<yreference>：Y 方向的垂直参考位置（整数形式）。请参考:WAVeform:YREFerence?命令。 
%}

%fprintf(stc_visa, ':DISPlay:GRID FULL');

%fprintf(stc_visa, ':SAVE:IMAGe:FACTors 1');
%fprintf(stc_visa, ':SAVE:IMAGe  D:\123.png');  % 保存图像到示波器的硬盘

% 开始读取数据
fprintf(stc_visa, ':wav:data?'); [data, ~]= fread(stc_visa, stc_visa.InputBufferSize); % 读取波形数据 
fprintf(stc_visa, ':WAVeform:XINCrement?'); [X_increment,~]= fread( stc_visa, stc_visa.InputBufferSize ); % 读取时间刻度
fprintf(stc_visa, ':WAVeform:YINCrement?'); [Y_increment,~]= fread( stc_visa, stc_visa.InputBufferSiz ); % 读取电压刻度
fprintf(stc_visa, ':WAVeform:YREFerence?'); [Y_ref_index,~]= fread( stc_visa, 2048 ); % 读取电压参考线
fprintf(stc_visa, ':WAVeform:YORigin?'); [Y_bias_index,~]= fread( stc_visa, 2048 ); % 读取电压偏移
fprintf(stc_visa,':ACQuire:SRATe?'); Fs = fscanf(stc_visa); Fs = str2double(Fs); % 读取采样频率


%fprintf(stc_visa,':WAVeform:STATus? '); char(fread( stc_visa, 2048 ))'

% 关闭设备
fclose(stc_visa); % 关闭连接 (必须要有), 否则再次调用时会报错
delete(stc_visa); 
clear stc_visa; 

%{
数据处理：
    读取的波形数据含有 TMC 头，长度为 11 个字节，
    其中前 2 个字节分别为 TMC 头标志符 '#' 和宽度描述符 9，
    接着的 9 个字节为数据长度，然后是波形数据，最后一个字节为结束符 0x0A。
    所以，读取的有效波形数据点为 12 到倒数第 2 个点 
%}
data = data(12:(end-1));  % 获取有效数据点
X_increment = str2double(char(X_increment)') % str ascii 码转换成数字
Y_increment = str2double(char(Y_increment)'); % str ascii 码转换成数字
Y_ref_index = str2double(char(Y_ref_index)'); % str ascii 码转换成数字
Y_bias_index = str2double(char(Y_bias_index)') % str ascii 码转换成数字

data = data - Y_ref_index - Y_bias_index; % 减去参考线的位置再减去偏移
data = data * Y_increment; % 将单位从格数转化为 vol
time = 0 : X_increment : ( (length(data)-1)*X_increment );   % 创建时间轴

%stc_visa.dataplot = MyPlot(time', data')   % time 和 data 是列向量
%stc_visa.FFTplot = 



disp(length(data)) % 显示总采样点数
% 显示采样时间长度
% 显示采样率


stc_visa.plot = MyPlot_2window(time', time', data', data');
stc_visa.plot.plot1.label.x.String = 'Time (s)';
stc_visa.plot.plot1.label.y.String = 'Voltage (V)';
stc_visa.plot.plot2.label.x.String = 'Frequency (Hz)';



% 进行 FFT 
%fftSpec = fft(data', 2048); 
%fftRms = abs(fftSpec'); 
%fftLg = 20*log(fftRms); 
%MyPlot_2window()


% 保存数据到 stc_visa 结构体
```




下面是部分常用命令：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-20-52-14_Control RIGOL MSO2202A Oscilloscope using MATLAB.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-20-51-56_Control RIGOL MSO2202A Oscilloscope using MATLAB.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-18-53-06_Control RIGOL MSO2202A Oscilloscope using MATLAB.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-18-59-38_Control RIGOL MSO2202A Oscilloscope using MATLAB.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-18-59-51_Control RIGOL MSO2202A Oscilloscope using MATLAB.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-19-00-01_Control RIGOL MSO2202A Oscilloscope using MATLAB.png"/></div>
示波器处于运行状态时，数据读取量只能在 0~1400 之间设置，在示波器 STOP 之后，可以读取内存中的全部数据。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-19-12-29_Control RIGOL MSO2202A Oscilloscope using MATLAB.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-21-19-12-37_Control RIGOL MSO2202A Oscilloscope using MATLAB.png"/></div>


## 自定义函数

为方便调用，我们对几个常用的函数进行了自定义封装，代码如下：


``` matlab
function stc_visa = MyOscilloscope_MSO2202A_Read_OneCh(ch)
    instrreset  % 创建 visa 对象前, 断开并删除全部对象, 防止报错
    stc_visa = visa( 'NI', 'USB0::0x1AB1::0x04B0::DS2F192200361::INSTR' );
    stc_visa.InputBufferSize = 2048;    % 一般示波器返回 1400 个数据点
    fopen(stc_visa);    % 打开已创建的VISA对象
    % 无需改动的数据读取设置
    fprintf(stc_visa,':WAVEFORM:FORMAT BYTE');  % 设置数据传输形式, {WORD|BYTE|ASCii}
    % 数据读取设置
    switch ch
        case 1
            str_channel = ':WAVeform:SOURce CHANnel1';
            color = '#FFB90F';
        case 2
            str_channel = ':WAVeform:SOURce CHANnel2';
            color = 'b';
    end
    fprintf(stc_visa, str_channel);  % 设置要读取的通道, {CHANnel1|CHANnel2|MATH|FFT|LA}
    fprintf(stc_visa,':WAVeform:MODE NORMal');  % 设置读取模式, {NORMal|RAW|MAXimum}
    fprintf(stc_visa,':WAVeform:Start 1');
    fprintf(stc_visa,':WAVeform:POINts 1400');
    % 开始读取数据
    fprintf(stc_visa, ':wav:data?'); [data, ~]= fread(stc_visa, stc_visa.InputBufferSize); % 读取波形数据 
    fprintf(stc_visa, ':WAVeform:XINCrement?'); [X_increment,~]= fread( stc_visa, stc_visa.InputBufferSize ); % 读取时间刻度
    fprintf(stc_visa, ':WAVeform:YINCrement?'); [Y_increment,~]= fread( stc_visa, stc_visa.InputBufferSiz ); % 读取电压刻度
    fprintf(stc_visa, ':WAVeform:YREFerence?'); [Y_ref_index,~]= fread( stc_visa, 2048 ); % 读取电压参考线
    fprintf(stc_visa, ':WAVeform:YORigin?'); [Y_bias_index,~]= fread( stc_visa, 2048 ); % 读取电压偏移
    fprintf(stc_visa,':ACQuire:SRATe?'); Fs = fscanf(stc_visa); Fs = str2double(Fs); % 读取采样频率
    % 关闭设备
    fclose(stc_visa); % 关闭连接 (必须要有), 否则再次调用时会报错
    delete(stc_visa); 
    clear stc_visa; 
    
    %{
    数据处理：
        读取的波形数据含有 TMC 头，长度为 11 个字节，
        其中前 2 个字节分别为 TMC 头标志符 '#' 和宽度描述符 9，
        接着的 9 个字节为数据长度，然后是波形数据，最后一个字节为结束符 0x0A。
        所以，读取的有效波形数据点为 12 到倒数第 2 个点 
    %}
    data = data(12:(end-1));  % 获取有效数据点
    X_increment = str2double(char(X_increment)'); % str ascii 码转换成数字
    Y_increment = str2double(char(Y_increment)'); % str ascii 码转换成数字
    Y_ref_index = str2double(char(Y_ref_index)'); % str ascii 码转换成数字
    Y_bias_index = str2double(char(Y_bias_index)'); % str ascii 码转换成数字
    
    data = data - Y_ref_index - Y_bias_index; % 减去参考线的位置再减去偏移
    data = data * Y_increment; % 将单位从格数转化为 vol
    time = 0 : X_increment : ( (length(data)-1)*X_increment );   % 创建时间轴

    % 结果展示
    data_length = length(data);
    sampling_time = time(end) + X_increment;
    sampling_rate = length(data)/(time(end) + X_increment);
    disp(  "Sampling Points: " + num2str(data_length)  ) % 显示总采样点数
    disp(  "Sampling Time: " + num2str(sampling_time) + ' s' ) % 显示采样时间长度
    disp(  "Sampling Rate: " + num2str(sampling_rate) + ' Sa/s' ) % 显示采样率
    stc_visa.stc_spectrum = MyAnalysis_Spectrum_3fig(data', time', 0);  % 进行频谱分析并作图
    stc_visa.stc_spectrum.plot0.plot.plot_1.Color = color;

    % 导出结果
    stc_visa.data = data;
    stc_visa.time = time;
    stc_visa.data_length = length(data);
    stc_visa.sampling_time = time(end) + X_increment;
    stc_visa.sampling_rate = length(data)/(time(end) + X_increment);
end

```

``` matlab
function stc_visa = MyOscilloscope_MSO2202A_read_alldata(ch, four_level)
    % 初始化
    instrreset  % 创建 visa 对象前, 断开并删除全部对象, 防止报错
    stc_visa = visa( 'NI', 'USB0::0x1AB1::0x04B0::DS2F192200361::INSTR' );
    stc_visa.InputBufferSize = 14e6 + 2048;    % 一般示波器返回 1400 个数据点
    fopen(stc_visa);    % 打开已创建的VISA对象
    % 无需改动的数据读取设置
    fprintf(stc_visa,':WAVEFORM:FORMAT BYTE');  % 设置数据传输形式, {WORD|BYTE|ASCii}

    % 示波器设置
    str_channel = ":WAVeform:SOURce CHANnel" + num2str(ch); % 用于数据读取
    fprintf(stc_visa,':ACQuire:MDEPth?'); depth_origin = str2num(char(fread( stc_visa, 2048 ))');   % 读取当前存储深度
    fprintf(stc_visa, ":CHANnel" + num2str(mod(ch+2, 2)+1) + ':DISPlay?'); tv = str2num(char(fread( stc_visa, 2048 ))');   % 检查另一通道是否打开
    if tv == 1  % 另一通道处于打开状态
        str_channel_on = ":CHANnel" + num2str(mod(ch+2, 2)+1) + ':DISPlay on';
        str_channel_off = ":CHANnel" + num2str(mod(ch+2, 2)+1) + ':DISPlay off';
        fprintf(stc_visa, str_channel_off); % 关闭另一通道
    end
    if four_level >= 4
        disp('不建议 level = 4, 读取未执行')
        return
    end
    depth = 1400*10^four_level;    % 计算存储深度, 14e3 ~ 14e6 (非交织模式) or 7e3 ~ 7e6 (交织模式, 即两通道同时打开)
    fprintf(stc_visa,":ACQuire:MDEPth " + num2str(depth));  % 设置存储深度
    fprintf(stc_visa,':STOP'); disp('已停止示波器运行') % 暂停示波器

    % 数据读取设置
    fprintf(stc_visa, str_channel);  % 设置要读取的通道, {CHANnel1|CHANnel2|MATH|FFT|LA}
    fprintf(stc_visa, ':WAVeform:MODE RAW');  % 设置读取模式, {NORMal|RAW|MAXimum}
    fprintf(stc_visa, ':WAVeform:Start 1');
    fprintf(stc_visa, ":WAVeform:POINts " + num2str(depth));

    % 开始读取数据
    fprintf(stc_visa, ':wav:data?'); [data, ~]= fread(stc_visa, stc_visa.InputBufferSize); % 读取波形数据 
    fprintf(stc_visa, ':WAVeform:XINCrement?'); [X_increment,~]= fread( stc_visa, stc_visa.InputBufferSize ); % 读取时间刻度
    fprintf(stc_visa, ':WAVeform:YINCrement?'); [Y_increment,~]= fread( stc_visa, stc_visa.InputBufferSiz ); % 读取电压刻度
    fprintf(stc_visa, ':WAVeform:YREFerence?'); [Y_ref_index,~]= fread( stc_visa, 2048 ); % 读取电压参考线
    fprintf(stc_visa, ':WAVeform:YORigin?'); [Y_bias_index,~]= fread( stc_visa, 2048 ); % 读取电压偏移
    fprintf(stc_visa,':ACQuire:SRATe?'); Fs = fscanf(stc_visa); Fs = str2double(Fs); % 读取采样频率

    % 恢复示波器设置
    if tv == 1  % 另一通道原本是打开状态
        fprintf(stc_visa, str_channel_on); % 打开另一通道
    end
    fprintf(stc_visa,':RUN'); disp('已重新开启示波器') % 先开启, 再恢复深度
    fprintf(stc_visa,":ACQuire:MDEPth " + num2str(depth_origin));   % 恢复存储深度
    

    % 关闭设备
    fclose(stc_visa); % 关闭连接 (必须要有), 否则再次调用时会报错
    delete(stc_visa); 
    clear stc_visa; 
    
    %{
    数据处理：
        读取的波形数据含有 TMC 头，长度为 11 个字节，
        其中前 2 个字节分别为 TMC 头标志符 '#' 和宽度描述符 9，
        接着的 9 个字节为数据长度，然后是波形数据，最后一个字节为结束符 0x0A。
        所以，读取的有效波形数据点为 12 到倒数第 2 个点 
    %}
    data = data(12:(end-1));  % 获取有效数据点
    X_increment = str2double(char(X_increment)'); % str ascii 码转换成数字
    Y_increment = str2double(char(Y_increment)'); % str ascii 码转换成数字
    Y_ref_index = str2double(char(Y_ref_index)'); % str ascii 码转换成数字
    Y_bias_index = str2double(char(Y_bias_index)'); % str ascii 码转换成数字
    
    data = data - Y_ref_index - Y_bias_index; % 减去参考线的位置再减去偏移
    data = data * Y_increment; % 将单位从格数转化为 vol
    time = 0 : X_increment : ( (length(data)-1)*X_increment );   % 创建时间轴

    % 结果展示
    data_length = length(data);
    sampling_time = time(end) + X_increment;
    sampling_rate = length(data)/(time(end) + X_increment);
    disp(  "Sampling Points: " + num2str(data_length)  ) % 显示总采样点数
    disp(  "Sampling Time: " + num2str(sampling_time) + ' s' ) % 显示采样时间长度
    disp(  "Sampling Rate: " + num2str(sampling_rate) + ' Sa/s' ) % 显示采样率
    stc_visa.stc_spectrum = MyAnalysis_Spectrum_3fig(data', time', 0);  % 进行频谱分析并作图

    % 导出结果
    stc_visa.data = data;
    stc_visa.time = time;
    stc_visa.data_length = length(data);
    stc_visa.sampling_time = time(end) + X_increment;
    stc_visa.sampling_rate = length(data)/(time(end) + X_increment);
end

```

``` matlab
function stc = MyOscilloscope_MSO2202A_Read_TwoCh
    stc.stc_CH1 = MyOscilloscope_MSO2202A_Read_OneCh(1);
    stc.stc_CH2 = MyOscilloscope_MSO2202A_Read_OneCh(2);
    stc.myplot = MyPlot(stc.stc_CH2.time', [stc.stc_CH1.data'; stc.stc_CH2.data']);
    stc.myplot.plot.plot_1.Color = '#FFB90F';
    stc.myplot.plot.plot_2.Color = 'b';
    stc.myplot.plot.plot_2.LineStyle = '-';
    stc.myplot.leg.String = ["CH 1"; "CH 2"];
    stc.myplot.label.x.String = 'Time (s)';
    stc.myplot.label.y.String = 'Voltage (V)';
    MyFigure_ChangeSize_2048x512(stc.myplot.fig);
end
```

## 自定义函数输出示例

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-11-24-48_Control RIGOL MSO2202A Oscilloscope using MATLAB.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-03-23-11-25-34_Control RIGOL MSO2202A Oscilloscope using MATLAB.png"/></div>

## 常见问题




<!-- details begin -->
<details>
<summary>问题：设备未正常关闭导致的再次连接时报错 (VISA: Unsuccessful open: The specified configuration: GPIB0::8::INSTR is not available)</summary>

解决方案：控制台输入 `instrreset` 即可解决。

``` matlab
% 报错示例：
VISA: Unsuccessful open: The specified configuration: GPIB0::8::INSTR is not available.
```

``` matlab
% 解决方案
instrreset % Disconnect and delete all instrument objects
```

</details>


## 相关资源

- [GitHub: rigol-oscilloscope-and-generator](https://github.com/cai525/rigol-oscilloscope-and-generator)