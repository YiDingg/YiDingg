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

### 线性规划

$$min\mathrm{~}C^{\prime}X\\ s.t.\begin{cases}Ax\leq b\\ Aeq*x=beq\\lb\leq x\leq ub&&\end{cases}$$

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

## 手动实现

### 模拟退火

## Examples

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

## Else 

其它Matlab官方资源：
- [MATLAB 中基于问题的优化](https://www.mathworks.com/help/optim/problem-based-approach.html)：文档
- [优化数学建模](https://www.mathworks.com/videos/series/mathematical-modeling-with-optimization-94592.html)：关于优化问题建模和求解的系列视频
- [Optimization Toolbox](https://www.mathworks.com/products/optimization.html):指向关于在 MATLAB 中基于问题的优化的示例、网络研讨会和视频的链接
- [示例](https://www.mathworks.com/help/optim/examples.html)：使用基于问题和基于求解器方法的各种优化应用的示例代码
- [MATLAB 中的优化方法](https://www.mathworks.com/learn/training/optimization-techniques-in-matlab.html)：相关训练