d_202602_CDR_PAM3_56GT_quarterRate_1
0. CDR 基本信息
f_osc_GHz = 14
T_osc_ns = 1/f_osc_GHz; T_osc_ps = T_osc_ns*1e3
f_osc = f_osc_GHz*1e9; T_osc = 1/f_osc;






(2026.02.15) INV delay/power 测试 (std. Vt)
fileName = "D:\aa_MyExperimentData\Raw data backup\20260215_LogicDelay__nch_pch__1080points_TT27.csv";
rawdata = readmatrix(fileName)
% 1 ~ 16 raw 分别对应：
% 1 = test num
% 2 = Corner
% 3 = fl (finger length)
% 4 = ka (WP/WN)
% 5 = 

%% 读取原数据
% 读取 CSV 文件
fileName = "D:\aa_MyExperimentData\Raw data backup\20260215_LogicDelay__nch_pch__1080points_TT27.csv";
rawtable = readtable(fileName, 'VariableNamingRule', 'preserve');

% 定义要提取的列名
str_arrays = [
"fl"
"ka"
"fa"
"fn"
"IDD_singleINV_ave (A)"
"unitDelay_ave (s)"
"OUT_riseTime (s)"
"OUT_fallTime (s)"
"OUT_riseTime (%)"
"OUT_fallTime (%)"
"total_aspectRatio"
];


% 检查列是否存在
missingCols = setdiff(str_arrays, rawtable.Properties.VariableNames);
if ~isempty(missingCols)
    error('缺少列: %s', strjoin(missingCols, ', '));
else
    fprintf('找到列：%s', strjoin(str_arrays, ', '));
end

% 提取指定列数据
extractedData = rawtable(:, str_arrays);

% 将 "sim err" 和 "eval err" 替换为 NaN
errorStrings = {'sim err', 'eval err'};
for i = 1:width(extractedData)
    if iscategorical(extractedData.(i)) || isstring(extractedData.(i)) || iscell(extractedData.(i))
        % 处理字符类型数据
        colData = extractedData.(i);
        if iscategorical(colData)
            colData = cellstr(colData);
        elseif isstring(colData)
            colData = cellstr(colData);
        end
        for j = 1:length(errorStrings)
            idx = strcmp(colData, errorStrings{j});
            colData(idx) = {'NaN'};
        end
        extractedData.(i) = str2double(colData);
    elseif isnumeric(extractedData.(i))
        % 对于已经是数值的列，可能不需要处理
        % 但如果存在 NaN，已经保持了
    end
end


rawdata = table2array(extractedData);   % 转换为 double 矩阵（方便后续处理）
data = rawdata(~any(isnan(rawdata), 2), :);    % 去除包含 NaN 的行（这些行原本包含 sim err 或 eval err）
disp(['提取的干净数据 (已去除错误行)：size = ', num2str(size(data, 1)), ' x ', num2str(size(data, 2))]);
cleanTable = array2table(data, 'VariableNames', str_arrays);
writetable(cleanTable, [fileName + '__extracted_clean_data.csv']);  % 保存为新表格

index = str_arrays == "IDD_singleINV_ave (A)"; IDD = data(:, index);
IDD_uA = IDD*1e6
index = str_arrays == "fl"; axis_fl = data(:, index);
index = str_arrays == "total_aspectRatio"; axis_totalA = data(:, index);

[X, Y] = meshgrid(axis_fl, axis_totalA);
%MyMesh(axis_fl, axis_totalA, IDD)
%mesh(X, Y, IDD)
stc = MyScatter3(axis_totalA, axis_fl, IDD);
stc.axes.ZScale = 'log';


%% 对数据进行分组
index_fl = find(str_arrays == "fl");    % 找到 "fl" 对应的列索引
axis_fl = data(:, index_fl);  
% 找出 fl 有几个不同的值
unique_fl = unique(axis_fl); num_unique_fl = length(unique_fl);
fprintf('fl 共有 %d 组\n', num_unique_fl);

% 为每个 fl 值创建分组索引
group_index_fl = cell(num_unique_fl, 1);
for i = 1:num_unique_fl
    group_index_fl{i} = find(axis_fl == unique_fl(i));
end
% 或者使用更简洁的方式：创建分组标签
[group_id, group_values] = findgroups(axis_fl);



%% 作图 (IDD_uA)
ax = MyFigure_CreateAxis;
colors = MyGet_colors_nok;
for i = 1:num_unique_fl
X = axis_totalA(group_index_fl{i});
Y = IDD_uA(group_index_fl{i});
X = sort(X); Y = sort(Y);
stc = MyPlot_ax(ax, X, Y);
stc.plot.plot_1.Color = colors{i};
end
stc.axes.XScale = 'log';
stc.axes.YScale = 'log';
stc.leg.Visible = 'on';
stc.leg.FontSize = 10;
stc.leg.String = strcat("fl = ", string(unique_fl*1e9), "n");
stc.axes.XLim = [0.1, 100];
stc.axes.YLim = [0.1, 100];
stc.label.x.String = "total aspect ratio (W/L)";
stc.label.y.String = "IDD of single INV (uA)";

%% 作图 (gate delay)
ax = MyFigure_CreateAxis;
colors = MyGet_colors_nok;
for i = 1:num_unique_fl
X = axis_totalA(group_index_fl{i});
Y = unitDelay_ps(group_index_fl{i});
X = sort(X); Y = sort(Y);
stc = MyPlot_ax(ax, X, Y);
stc.plot.plot_1.Color = colors{i};
end
stc.axes.XScale = 'log';
stc.axes.YScale = 'log';
stc.leg.Visible = 'on';
stc.leg.FontSize = 10;
stc.leg.String = strcat("L = ", string(unique_fl*1e9), "n");
stc.axes.XLim = [0.1, 100];
stc.axes.YLim = [1, 1000];
stc.label.x.String = "total aspect ratio (W/L)";
stc.label.y.String = "gate delay (ps)";

%% 作图 (transition time)
ax = MyFigure_CreateAxis;
colors = MyGet_colors_nok;
for i = 1:num_unique_fl
X = axis_totalA(group_index_fl{i});
Y = max(OUT_riseTime_ps(group_index_fl{i}), OUT_fallTime_ps(group_index_fl{i}));
X = sort(X); Y = sort(Y);
stc = MyPlot_ax(ax, X, Y);
stc.plot.plot_1.Color = colors{i};
end
stc.axes.XScale = 'log';
stc.axes.YScale = 'log';
stc.leg.Visible = 'on';
stc.leg.FontSize = 10;
stc.leg.String = strcat("L = ", string(unique_fl*1e9), "n");
stc.axes.XLim = [0.1, 100];
stc.axes.YLim = [1, 1000];
stc.label.x.String = "total aspect ratio (W/L)";
stc.label.y.String = "transition time (ps)";

