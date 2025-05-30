# Design of Op Amp using gm-Id Methodology Assisted by MATLAB <br> (用 MATLAB 辅助 gm-Id 方法设计运算放大器)


> [!Note|style:callout|label:Infor]
> Initially published at 11:50 on 2025-05-29 in Beijing.

## Introduction

注：本文所考虑的 gm-Id 方法，是将 `gm/Id` 和 `L` 视为自变量。这样，一旦确定所需的 `gm`，便可通过 `gm/Id` 和 `L` 两个变量唯一地确定晶体管的所有参数。另外，我们不考虑 Vds 的改变对各参数的影响 (默认设定 vds =  vdd/2 或 vdd/3).

## OS Parameters

在 Cadence 设计工具 (如 Virtuoso) 中, 晶体管等器件的的 OS parameters (Operating System Parameters 或 Operating Point Parameters) 是仿真后生成的器件工作点参数，用于描述晶体管在特定偏置条件下的电气特性。这些参数对于电路分析和优化非常重要。

最常见的几个 OS parameters 一眼就能认出来，我们不多赘述，下面提几个比较重要但是不一定能马上认出的参数：

- `region`: 晶体管的工作区域，在 0, 1, 2, 3 中取值，分别表示 cut-off, triode, saturation 和 sub-threshold 区域
- `vdsat`: 最小饱和电压，表示晶体管进入饱和区所需的最小 Vds, 也就是最小 overdrive Voltage
- `fug`: 晶体管的 transient frequency, 比公式 $\frac{g_m}{2\pi (C_{GS} + C_{GD})}$ 得到的结果更低一些，但是两者的上升下降趋势是完全相同的

## Export Data

本小节参考 [Cadence > Export data to CSV format](https://community.cadence.com/cadence_technology_forums/f/custom-ic-design/18899/export-data-to-csv-format).


以台积电 180nm CMOS 工艺库 `tsmc18rf` 为例。打开 virtuoso, 在 ADE L 中设置好仿真参数，设置以下 outputs:

``` bash
self gain (gm*rO)              = waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "self_gain"))
current density (Id/W)         = waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "id") / VAR("W")))
transient freq (gm/(Cgs+Cgd))  = waveVsWave(    ?x OS("/NMOS" "gmoverid")  ?y (OS("/NMOS" "gm") / (2*pi*abs((OS("/NMOS" "cgs") + OS("/NMOS" "cgd")))))    )
minimum overdrive (Vdsat)      = waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vdsat"))
gate-source voltage (Vgs)      = waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vgs"))
```

**<span style='color:red'> 注意：上面的 "current density (Id/W)" 一项需要正确设置 width, 我们 schematic 中设置的是 2um, 这里就相应地填 2e-6 </span>**

另外, transient frequency 也可以直接用 OS parameters 里的 `fug`, 它比公式 $\frac{g_m}{2\pi (C_{GS} + C_{GD})}$ 得到的结果更低一些，但是两者整体的上升下降趋势是相同的。

设置好 dc sweep 和 parametric analysis 后，运行仿真并导出数据。我们先给出代码快速导出数据的方法，然后再给出手动导出方法。在 CIW 命令行中输入 `startFinder()` 打开函数查找器，查找 `ocnPrint` 可以看到其详细定义如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-29-12-49-00_How to Use Cadence Efficiently.png"/></div>

双击函数还可以打开 help 界面，可以看到各参数的定义和代码示例。根据函数定义，我们可以给出“快速导出仿真数据”的代码：

```bash
ocnPrint(
    ?output "<export_pathAndName>" ; 设置导出路径和文件名, 可以设置扩展名为 .txt, .csv, .vcsv, 和 .matlab 等
    ?numberNotation 'scientific ; 有 scientific, engineering, 和 suffix 三种数据格式
	"<export_DataName>" ; 需要导出的数据名称
)
```


比如我们实际使用的代码如下：

```bash
; 快速导出 gm-Id 仿真数据

    ; 设置数据导出路径和器件名称
        ; 完整路径例如 "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data/tsmc18rf_gmIdData_nmos2v/tsmc18rf_gmIdData_nmos2v_test.txt"
        export_path = "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data"
        export_deviceName = "tsmc18rf_gmIdData_nmos2v"
        export_fileFormat = ".txt"
    ; 创建各个数据的 filePathAndName
        path_selfGain = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_selfGain", export_fileFormat)
        path_currentDensity = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_currentDensity", export_fileFormat)
        path_transientFreq = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_transientFreq", export_fileFormat)
        path_overdrive = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_overdrive", export_fileFormat)
        path_vgs = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_vgs", export_fileFormat)
    ; 导出数据
        ocnPrint(   ; 1. 导出 self gain (gm*rO)
            ?output path_selfGain
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "self_gain"))
        )
        ocnPrint(   ; 2. 导出 current density (Id/W)
            ?output path_currentDensity
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "id") / VAR("W")))
        )
        ocnPrint(   ; 3. transient freq (gm/2*pi*((Cgs+Cgd)))
            ?output path_transientFreq
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "gm") / (2 * 3.1415926 * abs((OS("/NMOS" "cgs") + OS("/NMOS" "cgd"))))))
        )
        ocnPrint(   ; 4. 导出 minimum overdrive (Vdsat)
            ?output path_overdrive
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vdsat"))
        )
        ocnPrint(   ; 5. gate-source voltage (Vgs)
            ?output path_vgs
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vgs"))
        )
```



**<span style='color:red'> 再次提醒：设置 current density 的 output 数据，应填入正确的晶体管 width</span>** (一般默认是 2um, 也即 2e-6)，最好是直接将 width 设置为 design variable `W`, 这样便可在 output expression 中用 `VAR("W")` 直接调用它。

**手动导出的方法是:** 在 ADL L 打开 `Tools > Results Browser`, 在左侧界面选中需要导出的数据（可多选），右键 `Export` 或者 `Save to Export List`, 即可导出为 `.csv`, `.vcsv` 和 `.matlab` 等格式 (不能导出为 `txt` 文件)。需要注意的是，这种手动导出得到的文件，其排版格式与前面的代码导出得到的文件格式不同，比如都导出为 `.csv` 时，两个文件的表头排版不一致。为了方便 MATLAB 处理数据，我们后续只考虑代码导出的 `.txt`，使数据格式统一。


## MATLAB Function

为了处理 Cadence 导出的数据，我们编写了一个 MATLAB 函数 `MyAnalogIC_Cadence_ReadData_txt.m`，该函数可以读取 Cadence 导出的 `.txt` 文件，并将数据转换为 MATLAB 中的矩阵格式。函数的输入参数包括文件路径和文件名，输出参数为一个结构体，包含了数据文件的各种信息。

``` matlab
function stc = MyAnalogIC_Cadence_ReadData_txt(filePath)
Debug = 0;
% 读取 SKILL 代码导出的 .txt 文件, 数字格式 scientific, cadence 数据导出参考代码见文末
% 导出的数据格式为 "colomn"
%%
    % filePath = "D:\a_Win_VM_shared\a_Misc\Cadence_Data\tsmc18rf_gmIdData_nmos2v\tsmc18rf_gmIdData_nmos2v_selfGain.txt";
    fileContent = fileread(filePath);

% 提取 length
    % 定义正则表达式匹配模式, 提取 length 信息
    pattern = "\(L = (\d+\.\d*)e-(\d*)\)";
    matches = regexp(fileContent, pattern, 'tokens');
    
    % 提取所有匹配的L值并转换为数值
    secondVarible = zeros(size(matches));
    for i = 1:length(matches) % 遍历匹配项并转换为数值
        base = str2double(matches{i}{1}); % 获取基数部分
        exponent = matches{i}{2}; % 获取指数部分（如果有）
        if ~isempty(exponent)
            L_value = base * 10^str2double("-" + exponent); % 处理科学计数法
        else
            L_value = base; % 没有指数部分，直接使用基数
        end
        % 将值添加到数组 A 中
        secondVarible(i) = L_value;
    end

    if Debug 
        disp("Second Varible' = ")
        disp(secondVarible')
    end

% 提取

% 读取文件内容
fileID = fopen(filePath, 'r');
if fileID == -1
    error('无法打开文件');
end

% 初始化变量
data_left = [];
data_right = [];
dataMatrix = []; % 存储所有数据
currentSet = []; % 当前数据集
isCollecting = false; % 是否正在收集数据

% 逐行读取文件内容
while ~feof(fileID)
    line = fgetl(fileID);
    
    % 检查是否是数据块的开始
    if contains(line, 'Set No.')
        % 如果已经在收集数据，保存当前数据集
        if isCollecting     % 将当前数据集追加到总矩阵
            data_left = [data_left, currentSet(:, 1)];
            data_right = [data_right, currentSet(:, 2)];

        end
        currentSet = []; % 初始化新的数据集
        isCollecting = true; % 开始收集数据
    elseif isCollecting && ~isempty(line) && ~contains(line, '#') && ~contains(line, 'L =')
        % 提取数据行
        data = str2num(line); % 将字符串转换为数值
        if length(data) == 2
            currentSet = [currentSet; data]; % 将数据添加到当前数据集
        end
    end
end

% 保存最后一个数据集
if isCollecting
    data_left = [data_left, currentSet(:, 1)];
    data_right = [data_right, currentSet(:, 2)];
end

% 关闭文件
fclose(fileID);

if Debug
    % 显示结果
    disp('提取的数据矩阵：');
    disp(dataMatrix);
    disp(data_left);
end

Length = zeros(size(data_left)) + secondVarible;
MySurf(data_left, Length, data_right);

% 返回结果
stc.data_left = data_left;
stc.data_right = data_right;
stc.secondVarible = secondVarible;
filePath    % 显示数据来源

%{
; 20250529: 给出 cadence 中导出数据的参考代码如下 (SKILL 语言)
; 快速导出 gm-Id 仿真数据

    ; 设置数据导出路径和器件名称
        ; 完整路径例如 "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data/tsmc18rf_gmIdData_nmos2v/tsmc18rf_gmIdData_nmos2v_test.txt"
        export_path = "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data"
        export_deviceName = "tsmc18rf_gmIdData_nmos2v"
        export_fileFormat = ".txt"
    ; 创建各个数据的 filePathAndName
        path_selfGain = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_selfGain", export_fileFormat)
        path_currentDensity = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_currentDensity", export_fileFormat)
        path_transientFreq = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_transientFreq", export_fileFormat)
        path_overdrive = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_overdrive", export_fileFormat)
        path_vgs = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_vgs", export_fileFormat)
    ; 导出数据
        ocnPrint(   ; 1. 导出 self gain (gm*rO)
            ?output path_selfGain
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "self_gain"))
        )
        ocnPrint(   ; 2. 导出 current density (Id/W)
            ?output path_currentDensity
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "id") / VAR("W")))
        )
        ocnPrint(   ; 3. transient freq (gm/2*pi*((Cgs+Cgd)))
            ?output path_transientFreq
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "gm") / (2 * 3.1415926 * abs((OS("/NMOS" "cgs") + OS("/NMOS" "cgd"))))))
        )
        ocnPrint(   ; 4. 导出 minimum overdrive (Vdsat)
            ?output path_overdrive
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vdsat"))
        )
        ocnPrint(   ; 5. gate-source voltage (Vgs)
            ?output path_vgs
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vgs"))
        )
%}
end

```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-29-18-35-02_Design of Op Amp using gm-Id Methodology Assisted by MATLAB.png"/></div>

然后便是漫长的、繁琐的写代码过程了。我们从下午六点左右一直写到将近晚上十二点，终于完成了这部分功能。下面我们给出一个简单的 demo, 演示我们的代码都干了些什么。源代码太长 (零零散散几百行了)，我们不在这里贴出，可到我的 GitHub 仓库下载: [GitHub > YiDingg > Matlab](https://github.com/YiDingg/Matlab).

## Demo 

下面，我们举两个不同方向的例子，分别是 strong inversion 和 weak inversion 的情况。前者通常出现在强调高增益、高带宽的运放设计中，而后者更适用于低功耗、低电压的应用场景。

### strong inversion

还是以文章 [Design Example of F-OTA using Gm-Id Method](<Electronics/Design Example of F-OTA using Gm-Id Method.md>) 的五管 OTA 为例。在本次示例，我们设置了五个 performance parameters, 它们分别是：

``` bash
self gain (gm*rO)              = waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "self_gain"))
current density (Id/W)         = waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "id") / VAR("W")))
transient freq (gm/(Cgs+Cgd))  = waveVsWave(    ?x OS("/NMOS" "gmoverid")  ?y (OS("/NMOS" "gm") / (2*pi*abs((OS("/NMOS" "cgs") + OS("/NMOS" "cgd")))))    )
minimum overdrive (Vdsat)      = waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vdsat"))
gate-source voltage (Vgs)      = waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vgs"))
```

在 cadence 仿真完成后，导出数据（代码见前文），然后运行下面代码，将 `tsmc18rf` 的 `nmos2v` 数据导入到 MATLAB 中进行处理，得到各参数的基本情况：

``` matlab
clc, clear, close all
deviceName = "tsmc18rf_gmIdData_nmos2v";
flag_plot = 0;
stc = MyAnalogIC_Cadence_gmId_designPreparation(deviceName, flag_plot);
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-00-48-46_Design of Op Amp using gm-Id Methodology Assisted by MATLAB.png"/></div>

从图中可以看到五个参数关于横坐标 $\frac{g_m}{I_D}$ 和纵坐标 $L$ 的分布情况，竖坐标 $z$ 即为各参数的值。大多数情况下，我们认为前三个参数越大越好，后两个参数越小越好，因为这意味着高增益、高带宽、低面积、高摆幅和低电压。回想之前 F-OTA 的设计中，我们对两个 NMOS input 提出了以下要求：

$$
\begin{gather}
g_m r_O > 300,\quad \frac{g_m}{I_D} \in \left(7.5398,\ 12.5664\right),\quad \mathrm{GBW} > 50 \ \mathrm{MHz}
\end{gather}
$$

因此，我们可以设置目标参数如下：

``` matlab
stc.obej_array = [
    300     % self gain (gm*rO) 
    5       % current density (Id/W)   
    5e8    % transient freq (gm/(Cgs+Cgd))
    0.25    % minimum overdrive (Vdsat) 
    0       % gate-source voltage (Vgs) 
];
stc1 = MyAnalogIC_Cadence_gmId_designAssistor(stc);
```

计算所有数据点的 performance scores, 作出图像，同时作出满足所有 objectives 条件的数据点，结果如下：



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-01-26-18_Design of Op Amp using gm-Id Methodology Assisted by MATLAB.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-01-26-49_Design of Op Amp using gm-Id Methodology Assisted by MATLAB.png"/></div>
图中绿点表示满足所有目标参数下的最高分点。按照我们所设置的目标参数, 4221 个数据点中共有 23 个满足所有要求，占比 0.5449 %。其中，性能分数最高的点是：


``` matlab
Best point: gm/Id  = 7.9949, length = 1.395e-06
Points satisfying objectives = 23/4221 = 0.5449 %
```

$$
\begin{gather}
\left(\frac{g_m}{I_D}\right)_{\mathrm{best}} = 7.9949\ \ \mathrm{S/A},\quad \left(L\right)_{\mathrm{best}} = 1.395 \ \mathrm{um}
\end{gather}
$$

这与我们之前的设计所选的参数是大致相符的。


### weak inversion

同理，我们也给出 weak inversion 的设计示例。设置本征增益、电流密度和穿越频率偏小，两个电压量也偏小（性能更好），代码和结果如下：

``` matlab
stc.obej_array = [
    50      % self gain (gm*rO) 
    0.5     % current density (Id/W)   
    1e8     % transient freq (gm/(Cgs+Cgd))
    0.080   % minimum overdrive (Vdsat) 
    0.45    % gate-source voltage (Vgs) 
];
stc1 = MyAnalogIC_Cadence_gmId_designAssistor(stc);

```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-01-33-21_Design of Op Amp using gm-Id Methodology Assisted by MATLAB.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-30-01-33-42_Design of Op Amp using gm-Id Methodology Assisted by MATLAB.png"/></div>

``` matlab
Best point: gm/Id  = 20.4939, length = 5.04e-07
Points satisfying objectives = 13/4221 = 0.3080 %
```

$$
\begin{gather}
\left(\frac{g_m}{I_D}\right)_{\mathrm{best}} = 20.4939\ \ \mathrm{S/A},\quad \left(L\right)_{\mathrm{best}} = 0.504 \ \mathrm{um},\quad \mathrm{percentage} = 0.3080 \,\%
\end{gather}
$$

