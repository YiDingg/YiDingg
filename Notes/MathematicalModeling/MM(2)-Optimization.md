# Mathematical Modeling (2): Optimization

## 理论

几乎所有的优化问题都具有相同的形式：

- 目标函数： $f(x)$
- 约束条件：
  - 等式约束：$ceq_i(x) \leq 0$
  - 不等式约束：$c_j(x) = 0$

事实上，等式约束可以被两个不等式约束等价替换，例如 $x=0 \Longleftrightarrow \begin{cases}x \le 0 \\ -x \le 0\end{cases}$。

将上面的要素综合在一起，即得：

$$
\min_{x} f\left(x\right)\\\mathrm{s.t.}
\begin{cases}
    c_i (x)\leq0, i=1,\ldots,m_1\\ c_i (x)=0, i=m_1+1,\ldots,m_1+m_2
\end{cases}
$$

其中$x$可以是多维向量。

## Matlab 自带

Matlab 中提供了 Optimization Problem 求解器，可以创建并解决优化问题（统一用`solve`函数），`solve`函数会根据优化问题的类型，自动选择合适的求解函数。当然，也可以自行选择Matlab的函数来解决，函数选择参考如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-24-13-46-44_MM(2)-Optimization.jpg"/></div>

When using the you Optimization Problem Solver, you don't need to provide an initial guess structure if the objective function is linear. Otherwise, you do.

### OP求解器（无约束）
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-24-16-01-56_MM(2)-Optimization.jpg"/></div>

``` matlab 
% create the optimization problem
    prob = optimproblem("Description","Factory Location");
    x = optimvar("x");
    y = optimvar("y");
    X = [5 40 70];
    Y = [20 50 15];
    d = sqrt((x-X).^2 + (y-Y).^2);
    dTotal = sum(d);
    prob.Objective = dTotal;
    show(prob)

% solve the optimization problem
    initialGuess.x = 14;
    initialGuess.y = 34; 
    [sol,optval] = solve(prob,initialGuess)

% plot the solution
    xOpt = sol.x 
    yOpt = sol.y

    plotStores
    hold on
    scatter(xOpt,yOpt)
    hold off

    xvec = linspace(0,75);
    yvec = linspace(0,75);
    [x,y] = meshgrid(xvec,yvec);
    distance = sqrt((x-X(1)).^2 + (y-Y(1)).^2)+...
        sqrt((x-X(2)).^2 + (y-Y(2)).^2)+...
        sqrt((x-X(3)).^2 + (y-Y(3)).^2);
    contourf(x,y,distance)
    ylabel("Y")
    xlabel("X")
    colorbar
    hold on
    scatter(xOpt,yOpt)
    plotStores
    hold off

function plotStores()
    X = [5 40 70];
    Y = [20 50 15];
    pgon1 = nsidedpoly(5,"Center",[X(1) Y(1)],"sidelength",3);
    pgon2 = nsidedpoly(5,"Center",[X(2) Y(2)],"sidelength",3);
    pgon3 = nsidedpoly(5,"Center",[X(3) Y(3)],"sidelength",3);
    plot([pgon1 pgon2 pgon3])
    axis equal
end

% output: 
  OptimizationProblem : Factory Location

	Solve for:
       x, y

	minimize :
       sum(sqrt(((x - extraParams{1}).^2 + (y - extraParams{2}).^2)))

       extraParams
Solving problem using fminunc.

Local minimum found.

Optimization completed because the size of the gradient is less than
the value of the optimality tolerance.

<stopping criteria details>
sol = 
    x: 38.9434
    y: 36.2639

optval = 89.0540
xOpt = 38.9434
yOpt = 36.2639
```

### OP求解器（有约束）
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-24-16-01-04_MM(2)-Optimization.jpg"/></div>

``` matlab 
% https://matlabacademy.mathworks.com/R2024a/cn/portal.html?course=optim#chapter=3&lesson=4&section=1

prob = optimproblem("Description","An Optimal Breakfast");
servings = optimvar("servings",16,"LowerBound",0);
C = food.Price .* servings;
prob.Objective = sum(C);
cals = food.Calories .* servings;
prob.Constraints.calories = sum(cals) == 350;
show(prob)

% sol1
    carbs = food.Carbs .* servings; 
    totalCarbs = sum(carbs);
    prob.Constraints.carbs = totalCarbs >= 45 
    
    sol = solve(prob) 
    bar(food.Name,sol.servings)

% sol2
    optCarbs = evaluate(totalCarbs,sol)
    
    protein = food.Protein .* servings;
    totalProtein = sum(protein)
    prob.Constraints.protein = totalProtein >= 15
    
    sol2 = solve(prob) 
    bar(food.Name,sol2.servings)
    optProtein = evaluate(totalProtein,sol2)

% sol3
    vitaminC = food.VitaminC .* servings;
    totalVitaminC = sum(vitaminC)
    prob.Constraints.vitaminC = totalVitaminC >= 60
    
    sol3 = solve(prob)
    bar(food.Name,sol3.servings)
    optVitaminC = evaluate(totalVitaminC,sol3)

% sol4 (no solution)
    prob.Constraints.carbs = totalCarbs <= 30
    prob.Constraints.protein = totalProtein >= 60  
    prob.Constraints.vitaminC = totalVitaminC >= 60
    
    [sol4,optval] = solve(prob)
```
### Examples

<!-- details begin -->
<details>
<summary>线性布尔数规划</summary>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-24-16-02-20_MM(2)-Optimization.jpg"/></div>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-24-16-07-57_MM(2)-Optimization.jpg"/></div> -->

``` matlab 
prob = optimproblem("Description", '整数优化练习','ObjectiveSense','maximize');
X = optimvar('X',[3 1],'Type','integer','LowerBound',0,'UpperBound',1);
prob.Objective = 3*X(1) - 2*X(2) + 5*X(3);

L = [
1 2 -1
1 4 1
1 1 0
0 4 1
];
R = [2;4;3;6];

prob.Constraints.constraints = L*X <= R;
show(prob)

[sol, optval] = solve(prob)
sol.X

% output: 
  OptimizationProblem : 整数优化练习

	Solve for:
       X
	where:
       X integer

	maximize :
       3*X(1) - 2*X(2) + 5*X(3)


	subject to constraints:
       X(1) + 2*X(2) - X(3) <= 2
       X(1) + 4*X(2) + X(3) <= 4
       X(1) + X(2) <= 3
       4*X(2) + X(3) <= 6

	variable bounds:
       0 <= X(1) <= 1
       0 <= X(2) <= 1
       0 <= X(3) <= 1
Solving problem using intlinprog.
LP:                Optimal objective value is -8.000000.                                            


Optimal solution found.

Intlinprog stopped at the root node because the objective value is within a gap tolerance of the optimal value, options.AbsoluteGapTolerance = 0 (the default
value). The intcon variables are integer within tolerance, options.IntegerTolerance = 1e-05 (the default value).
sol = 
    X: [3×1 double]

optval = 8
ans = 3×1    
     1
     0
     1
```
</details>

## 自行实现

### 模拟退火

最新源代码见 GitHub： [here](https://github.com/YiDingg/Matlab/blob/main/MySimulatedAnnealing.m)

``` matlab 
function stc = MySimulatedAnnealing(stc, objective)
% 输入退火问题结构体，输出迭代结果。
% 输入参数：
    % stc：退火问题结构体
        % stc.Var：迭代参数信息
            % stc.Var.num：迭代参数个数
            % stc.Var.var1range：参数 1 的范围
            % stc.Var.var2range：参数 2 的范围
            % ...
        % stc.Init：迭代参数初始值
        % stc.Annealing：退火参数
            % stc.Annealing.T0 = 100;        % 初始温度
            % stc.Annealing.a = 0.97;        % 降温系数
            % stc.Annealing.t0 = 1;         % 停止温度
            % stc.Annealing.mkvlength = 1;   % 马尔科夫链长度
% 输出：迭代结果

    % 步骤一：初始化
        TK = stc.Annealing.T0;
        t0 = stc.Annealing.t0;
        mkv = stc.Annealing.mkvlength;
        a = stc.Annealing.a;
        lam = stc.Annealing.lam;
        f_best = 0;
        change_1 = 0;    % 随机到更优解的次数
        change_2 = 0;    % 接收较差解的次数（两者约 10:1 时有较好寻优效果）
        mytry = 0;       % 当前迭代次数
        N = mkv*log(t0/TK)/log(a);   % 迭代总次数
        X = zeros(1, stc.Var.num); 
        % 迭代记录仪初始化
        X_best = zeros(1, stc.Var.num); 
        process = zeros(1, floor(N));
        process_change = zeros(1, floor(N));
        

    % 步骤二：退火
        disp("初始化完成，开始退火")
        tic; % 开始计时
        while TK >= t0   
            for i = 1:mkv  % 每个温度T下，我们都寻找 mkv 次新解 X，每一个新解都有可能被接受
                r = rand;
                if r>=0.5 % 在当前较优解附近扰动
                    for j = 1:stc.Var.num
                        X(j) = X_best(j)+(rand-0.5)*(stc.Var.range(:,2) - stc.Var.range(:,1));
                        X(j) = max(stc.Var.range(j,1), min(X(j), stc.Var.range(j,2)));   % 确保扰动后的 X 仍在范围内
                    end
                else % 生成全局随机解
                    X = rand*(stc.Var.range(:,2) - stc.Var.range(:,1))';  % 转置后才是行向量   
                end
                f = objective(X); % 计算目标函数
                mytry = mytry+1;
                if f > f_best   % 随机到更优解，接受新解
                   f_best = f;
                   X_best = X;
                   change_1 = change_1+1;
                   % disp(['较优参数为：',num2str(X_best)])
                   disp(['    新目标值：',num2str(f_best)])
                elseif exp((f-f_best)/(lam*TK)) > rand  % 满足概率，接受较差解
                   f_best = f;
                   X_best = X;
                   % disp(['较优参数为：',num2str(X_best)])
                   disp(['    新目标值：',num2str(f_best)])
                   change_2 = change_2 + 1;
                end
                process(mytry) = f;
                process_change(mytry) = f_best;
            end
            disp(['当前进度:',num2str((mytry-1)/N*100),'%'])
            TK = TK*a;
        end
        time = toc; % 结束计时

    % 步骤三：退火结束，输出最终结果
        stc.process = process;
        stc.process_change = process_change;
        MyPlot(1:length(process),[process; process_change], ["times"; "objective"])
        disp('---------------------------------')
        disp(['此次退火用时(s)：',num2str(time)])
        disp(['一共寻找新解：',num2str(mytry)])
        disp(['change_1次数：',num2str(change_1)])
        disp(['change_2次数：',num2str(change_2)])
        disp('最优参数为：')
        disp(num2str(X_best))
        disp(['此参数下的目标函数值：',num2str(f_best)])
        disp('---------------------------------')
end
```


<!-- details begin -->
<details>
<summary>示例1：国赛 2022-A 问题四</summary>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-24-22-52-27_MM(2)-Optimization.png"/></div>

```matlab
stc.Var.num = 2; % [X Y] 两个参数
stc.Var.range(1,:) = [0 100000];
stc.Var.range(2,:) = [0 100000];
stc.Init = [0, 0];
stc.Annealing.T0 = 100;        % 初始温度
stc.Annealing.lam = 0.1;         % TK 前的概率系数（一般为0.1即可）
stc.Annealing.a = 0.97;        % 降温系数
stc.Annealing.t0 = 1;         % 停止温度
stc.Annealing.mkvlength = 3;   % 马尔科夫链长度

MySimulatedAnnealing(stc, @objective);

% export_fig(gcf , '-p0.02','-png' , '-r180' , '-painters' , 'C:/Users/13081/Desktop/Test_Matlab/MySimulatedAnnealing');

function f = objective(X)
    %求解微分方程，输出结果y
    % y(1)=浮子位移
    % y(2)=物体位移
    % y(3)=浮子速度
    % y(4)=物体速度
    % y(5)=浮子角位移
    % y(6)=振子角位移
    % y(7)=浮子角速度
    % y(8)=振子角位移
    % y(9)=获得的总能量
     
    k_zz = X(1);
    k_xz = X(2);
    Y_0 = [-2; -1.7980;0;0;0;0;0;0;0];   % 输入初始条件
    w = 1.9806; % 输入波浪频率以计算时间范围
    T = 2*pi/w;
    T_z = 40*2*pi/w;
    
    [t,y] = ode15s(@fangcheng,0:T/400:T_z,Y_0);  % 求解微分方程，时间步长T/4000
    mn = length(y);
    f = (y(end, 9)-y(mn(1)-4000,9))/T;

    function dydt = fangcheng(t,y)
        % 普遍数值（不变） 
        l = 0.5;
        k_zt = 80000;
        k_xt = 250000;
        C_j = 8890.7;
        rho = 1025;
        g = 9.8;
        m_1 = 4866;
        m_2 = 2433;
        S = pi;
        V_0 = pi*0.8/3;
        I_C1 = 7458.4845;
        I_C2 = 202.75; 
        
        % 问题四中的特殊数值
        I_f = 7142.493;
        m_f = 1091.099;
        omega = 1.9806;
        C_zx = 528.5018;
        C_xx = 1655.909;
        f = 1760;
        L = 2140;
    
        dydt = ...
            [
            y(3);
            y(4);
            (  rho*g*(V_0-S*y(1)/cos(y(5))) + f*cos(omega*t) - C_zx*y(3) + k_zt*(y(2)-y(1)-l*cos(y(6))) - k_zz*(y(3)-y(4)) - m_1*g  )/(m_1+m_f);
            (  - k_zt*(y(2)-y(1)-l*cos(y(6))) + k_zz*(y(3)-y(4)) - m_2*g  )/m_2;
            y(7);
            y(8);
            (  -C_j*y(5) + L*cos(omega*t) -C_xx*y(7) + k_xt*(y(6)-y(5)) -k_xz*(y(7)-y(8))  )/(I_C1+I_f);
            (  - k_xt*(y(6)-y(5)) +k_xz*(y(7)-y(8))  )/I_C2;
            k_zz*(y(3)-y(4))^2 + k_xz*(y(7)-y(8))^2
            ];
    end
end

function stc = MySimulatedAnnealing(stc, objective)
% 输入退火问题结构体，输出迭代结果。
% 输入参数：
    % stc：退火问题结构体
        % stc.Var：迭代参数信息
            % stc.Var.num：迭代参数个数
            % stc.Var.var1range：参数 1 的范围
            % stc.Var.var2range：参数 2 的范围
            % ...
        % stc.Init：迭代参数初始值
        % stc.Annealing：退火参数
            % stc.Annealing.T0 = 100;        % 初始温度
            % stc.Annealing.a = 0.97;        % 降温系数
            % stc.Annealing.t0 = 1;         % 停止温度
            % stc.Annealing.mkvlength = 1;   % 马尔科夫链长度
% 输出：迭代结果

    % 步骤一：初始化
        TK = stc.Annealing.T0;
        t0 = stc.Annealing.t0;
        mkv = stc.Annealing.mkvlength;
        a = stc.Annealing.a;
        lam = stc.Annealing.lam;
        f_best = 0;
        change_1 = 0;    % 随机到更优解的次数
        change_2 = 0;    % 接收较差解的次数（两者约 10:1 时有较好寻优效果）
        mytry = 0;       % 当前迭代次数
        N = mkv*log(t0/TK)/log(a);   % 迭代总次数
        X = zeros(1, stc.Var.num); 
        % 迭代记录仪初始化
        X_best = zeros(1, stc.Var.num); 
        process = zeros(1, floor(N));
        process_change = zeros(1, floor(N));
        

    % 步骤二：退火
        disp("初始化完成，开始退火")
        tic; % 开始计时
        while TK >= t0   
            for i = 1:mkv  % 每个温度T下，我们都寻找 mkv 次新解 X，每一个新解都有可能被接受
                r = rand;
                if r>=0.5 % 在当前较优解附近扰动
                    for j = 1:stc.Var.num
                        X(j) = X_best(j)+(rand-0.5)*10000;
                        X(j) = max(stc.Var.range(j,1), min(X(j), stc.Var.range(j,2)));   % 确保扰动后的 X 仍在范围内
                    end
                else % 生成全局随机解
                    X = rand*(stc.Var.range(:,2) - stc.Var.range(:,1))';  % 转置后才是行向量   
                end
                f = objective(X); % 计算目标函数
                mytry = mytry+1;
                if f > f_best   % 随机到更优解，接受新解
                   f_best = f;
                   X_best = X;
                   change_1 = change_1+1;
                   % disp(['较优参数为：',num2str(X_best)])
                   disp(['    新目标值：',num2str(f_best)])
                elseif exp((f-f_best)/(lam*TK)) > rand  % 满足概率，接受较差解
                   f_best = f;
                   X_best = X;
                   % disp(['较优参数为：',num2str(X_best)])
                   disp(['    新目标值：',num2str(f_best)])
                   change_2 = change_2 + 1;
                end
                process(mytry) = f;
                process_change(mytry) = f_best;
            end
            disp(['当前进度:',num2str((mytry-1)/N*100),'%'])
            TK = TK*a;
        end
        time = toc; % 结束计时

    % 步骤三：退火结束，输出最终结果
        stc.process = process;
        stc.process_change = process_change;
        MyPlot(1:length(process),[process' process_change'], ["times"; "objective"])
        disp('---------------------------------')
        disp(['此次退火用时(s)：',num2str(time)])
        disp(['一共寻找新解：',num2str(mytry)])
        disp(['change_1次数：',num2str(change_1)])
        disp(['change_2次数：',num2str(change_2)])
        disp('最优参数为：')
        disp(num2str(X_best))
        disp(['此参数下的目标函数值：',num2str(f_best)])
        disp('---------------------------------')
end

function MyPlot(XData, YData, XYLabel)
% 给定数据，作出 2-D 函数图像
% 输入：
    % XData：（所有数据共用的）横坐标，应为 n*1 列向量
    % YData：每一列代表一条线，应为 n*m 矩阵，其中 m 为数据线总条数
% 输出：图像

    % 准备参数
    MyColor = [
      [0 0 1]   % 蓝色
      [1 0 1]   % 粉色
      [0 1 0]   % 绿色 
      [1 0 0]   % 红色 
      [0 0 0]   % 黑色 
    ];
    m = length(YData(1,:));

    % 创建图窗
    Myfigure = figure('NumberTitle','off','Name','MyPlot','Color',[1 1 1]);
    Myaxes = axes('Parent',Myfigure);   
    hold(Myaxes,'on');

    % 作图
    for i = 1:1:m
        line = plot(XData, YData(:,i));
        % 设置样式
        line.LineWidth = 1.3;
        line.Marker = '.';
        line.MarkerSize = 7;
        line.Color = MyColor(i,:);
    end

    % 设置样式
    % title(Myaxes,'Title here, $y = f(x)$','Interpreter','latex')
    xlabel(Myaxes, XYLabel(1,:),'Interpreter','latex')
    ylabel(Myaxes, XYLabel(2,:),'Interpreter','latex')
    % Myaxes.GridLineStyle = '--';
    % Myle = legend(Myaxes,'$y_1 = sin(x)$','$y_2 = cos(x)$','$y_3 = cos(\frac{x^2}{5})$','Interpreter', 'latex', 'Location', 'best');
    Myle = legend(Myaxes, 'Location', 'best');
    Myle.FontSize = 11;
    Myle.FontName = "TimesNewRoman";
    grid(Myaxes,"on") % show the grid
    axis(Myaxes,"padded") % show the axis
    % set(Myaxes, 'YLimitMethod','padded', 'XLimitMethod','padded')
            
    % 收尾
    hold(Myaxes,'on');
end
```
</details>

<!-- details begin -->
<details>
<summary>示例2：求一元函数在给定区间的最大值</summary>

$$
\min_{x \in [0.5, 1.5]} f\left(x\right) = \frac{sin(x)^2}{(x-1)^2 + 0.001}
$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-24-23-21-05_MM(2)-Optimization.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-24-23-21-10_MM(2)-Optimization.png"/></div>

``` matlab 
clc,clear
g = @(x) sin(x).^2./((x-1).^2 + 0.001);
X = 0.9:0.001:1.1;
Y = g(X);
MyPlot(X,g(X),['X';'Y'])
export_fig(gcf , '-p0.02','-png' , '-r330' , '-painters' , 'C:/Users/13081/Desktop/Test_Matlab/MyPlot_Example');

Struct_SA.Var.num = 1; % 一个参数
Struct_SA.Var.range = [0.5 1.5 0.6];
Struct_SA.Annealing.T0 = 100;        % 初始温度
Struct_SA.Annealing.a = 0.97;        % 降温系数
Struct_SA.Annealing.t0 = 1;         % 停止温度
Struct_SA.Annealing.mkvlength = 6;   % 马尔科夫链长度

Struct_SA = MySimulatedAnnealing(Struct_SA, @(x) sin(x)^2/((x-1)^2+0.001));
vpa(Struct_SA.X_best)
```

</details>

### 网格搜索

网格搜索虽然具有普适性，但在参数数目增多时，所需时间急剧增加，因此需谨慎使用。

<!-- details begin -->
<details>
<summary>示例 1：求一元函数在给定区间的最大值</summary>

$$
\min_{x \in [0.5, 1.5]} f\left(x\right) = \frac{sin(x)^2}{(x-1)^2 + 0.001}
$$

``` matlab 
clc,clear,close all
obj1 = @(x) sin(x).^2./((x-1).^2 + 0.001);
GridSearch.Var = [
    0.9 1.1 1000
];
[GridSearch, figure] = MyGridSearch(GridSearch, obj1, 0);
% export_fig(figure.fig , '-p0.02','-png' , '-r250' , '-painters' , 'C:/Users/13081/Desktop/Test_Matlab/test');

% output: 
---------------------------------
>> --------  网格搜索  -------- <<
总计算次数：1001
历时 0.002452 秒。
最优参数：1.0006
最优目标值：708.3638
>> --------  网格搜索  -------- <<
---------------------------------
```
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-04-20-07-58_MM(2)-Optimization.png"/></div>

</details>

<!-- details begin -->
<details>
<summary>示例 2：求二元函数在给定区间的最大值</summary>

$$
\min_{[x, y] \in [0, 2]\times[0, 2]} f\left(x, y\right) = \pi \sin(x^2+y)\ln(x+y)
$$



``` matlab 
clc,clear,close all
obj2 = @(x,y)pi*sin(x^2+y)*log(x+y);
GridSearch.Var = [
    0 2 40
    0 2 40
];
[GridSearch, figure] = MyGridSearch(GridSearch, obj2, 0);
export_fig(figure.fig , '-p0.02','-jpg' , '-r130' , '-painters' , 'C:/Users/13081/Desktop/Test_Matlab/MyGridSearch2');
export_fig(figure.fig , '-p0.02','-png' , '-r130' , '-painters' , 'C:/Users/13081/Desktop/Test_Matlab/MyGridSearch2');

% output: 
---------------------------------
>> --------  网格搜索  -------- <<
总计算次数：1681
历时 0.002336 秒。
最优参数：0.5        1.75
最优目标值：2.3219
>> --------  网格搜索  -------- <<
---------------------------------
```

</details>

<!-- details begin -->
<details>
<summary>示例 3：求四元函数在给定区间的最大值</summary>

$$
\min_{x,y,z,t \in [0, 2]} f\left(x,y,z,t\right) = (x-1)^2 + (y-2)^2 + z^2 + (t-1)^2
$$

``` matlab 
clc,clear,close all
obj4 = @(x,y,z,t) (x-1)^2 + (y-2)^2 + z^2 + (t-1)^2;
GridSearch.Var = [
    0 2 10
    0 2 10
    0 2 10
    0 2 10
];
GridSearch = MyGridSearch(GridSearch, obj4, 1);

% output: 
进度：9.0909%
进度：18.1818%
进度：27.2727%
进度：36.3636%
进度：45.4545%
进度：54.5455%
进度：63.6364%
进度：72.7273%
进度：81.8182%
进度：90.9091%
进度：100%
---------------------------------
>> --------  网格搜索  -------- <<
总计算次数：14641
历时 0.005525 秒。
最优参数：0  0  2  0
最优目标值：10
>> --------  网格搜索  -------- <<
---------------------------------
```

</details>

### 遗传算法

## Else 

其它Matlab官方资源：
- [MATLAB 中基于问题的优化](https://www.mathworks.com/help/optim/problem-based-approach.html)：文档
- [优化数学建模](https://www.mathworks.com/videos/series/mathematical-modeling-with-optimization-94592.html)：关于优化问题建模和求解的系列视频
- [Optimization Toolbox](https://www.mathworks.com/products/optimization.html):指向关于在 MATLAB 中基于问题的优化的示例、网络研讨会和视频的链接
- [示例](https://www.mathworks.com/help/optim/examples.html)：使用基于问题和基于求解器方法的各种优化应用的示例代码
- [MATLAB 中的优化方法](https://www.mathworks.com/learn/training/optimization-techniques-in-matlab.html)：相关训练