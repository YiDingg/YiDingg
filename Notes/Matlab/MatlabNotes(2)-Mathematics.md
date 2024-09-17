# Matlab Notes (2): Mathematics

> [!Note|style:callout|label:Infor]
Initially published at 19:45 on 2024-08-08 in Lincang.


Official link: Mathworks --> Help Center --> Matlab --> [Mathematics](https://www.mathworks.com/help/releases/R2022a/matlab/mathematics.html)

There are some sections that are not included in this note, such as Sparse Matrices and Computational Geometry.

## Elementary Math 

### Arithmetic Operations

<!-- details begin -->
<details>
<summary><span class='Word'>diff</span>: Differences (差分) and approximate derivatives</summary>

If X is a vector of length m, then `Y = diff(X)` returns a vector of length m-1. The elements of Y are the differences between adjacent elements of X.

$$Y = [X(2)-X(1), X(3)-X(2), ..., X(m)-X(m-1)]$$

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-21-18-17-32_MatlabNotes(2)-Mathematics.png"/></div>

```matlab
h = 0.001;       % step size
X = -pi:h:pi;    % domain
f = sin(X);      % range
Y = diff(f)/h;   % first derivative
Z = diff(Y)/h;   % second derivative
plot(X(:,1:length(Y)),Y,'r',X,f,'b', X(:,1:length(Z)),Z,'k')
yline(0,'--')
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>sum</span>: Sum of array elements</summary>
<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-21-18-28-21_MatlabNotes(2)-Mathematics.jpg"/></div> -->
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-21-18-30-34_MatlabNotes(2)-Mathematics.png"/></div>

```matlab
A = [1 3 2; 4 2 5; 6 1 4]
sum(A)
sum(A,1)
sum(A,2)
sum(A,"all")
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>cumsum</span>: Cumulative sum (累计和)</summary>
Find the cumulative sum of the integers from 1 to 5. The element B(2) is the sum of A(1) and A(2), while B(5) is the sum of elements A(1) through A(5).

```matlab
A = 1:5;
B = cumsum(A)

% result:
B = 1×5
     1     3     6    10    15
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'><code>.*</code>, <code>*</code></span>: Element or Matrix multiplication</summary>

`C = A.*B` multiplies arrays A and B by multiplying corresponding elements. The sizes of A and B must be the same or be compatible.

Compatible example:

$$a=\begin{bmatrix}a_1&a_2&a_3\end{bmatrix},\quad b=\begin{bmatrix}b_1\\\\b_2\\\\b_3\\\\b_4\end{bmatrix},\quad a .*b=\begin{bmatrix}a_1b_1&a_2b_1&a_3b_1\\\\a_1b_2&a_2b_2&a_3b_2\\\\a_1b_3&a_2b_3&a_3b_3\\\\a_1b_4&a_2b_4&a_3b_4\end{bmatrix}.$$
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>prod, cumprod</span>: Product of array elements</summary>

cumprod() is similar to cumsum(), but it multiplies the elements instead of adding them.

```matlab
A=[1:3:7;2:3:8;3:3:9]   
B = prod(A)
C = prod(A,2)

% result:
A =

     1     4     7
     2     5     8
     3     6     9


B =

     6   120   504


C =

    28
    80
   162
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'><code>./</code>, <code>.\</code></span>: Left/right array division</summary>

`x = A./B` divides each element of A by the corresponding element of B. The sizes of A and B must be the same or be compatible.

$$a=\begin{bmatrix}a_1 &a_2\end{bmatrix},\quad b=\begin{bmatrix}b_1\\\\b_2\\\\b_3\end{bmatrix},\quad a ./b=\begin{bmatrix}a_1 ./b_1&a_2 ./b_1\\\\a_1 ./b_2&a_2 ./b_2\\\\a_1 ./b_3&a_2 ./b_3\end{bmatrix}$$

</details>

<!-- details begin -->
<details>
<summary><span class='Word'><code>/</code>, <code>\</code></span>: Solve systems of linear equations xA = B or Ax=B o for x</summary>

MATLAB® displays a warning message if A is badly scaled or nearly singular, but performs the calculation regardless.

If A is a scalar, then B/A is equivalent to B./A.

</details>

<!-- details begin -->
<details>
<summary><span class='Word'><code>.^</code>, <code>^</code></span>: Elementwise or matrix power</summary>

`C = A.^B` raises each element of A to the corresponding powers in B. The sizes of A and B must be the same or be compatible.

$$a=\begin{bmatrix}a_1 a_2\end{bmatrix},\quad b=\begin{bmatrix}b_1\\\\b_2\\\\b_3\end{bmatrix},\quad a . \uparrow b=\begin{bmatrix}b_1&a_2&b_1\\\\a_1&a_2&b_2\\\\a_1&a_2&b_3\end{bmatrix}.$$
</details>

<!-- details begin -->
<details>
<summary><span class='Word'><code>.'</code>, <code>'</code></span>: Transpose or complex conjugate transpose</summary>

`A.'`is equal to $A^T$, `A'` is equal to $A^H$. 
</details>

### Trigonometry (三角)

- **sin, cos, tan, csc, sec, cot, asin, acos, atan, acsc, asec, acot**: argument in radians
- **sind, cosd, tand, cscd, secd, cotd, asind, acosd, atand, acscd, asecd, acotd**: argument in degrees
- **sinh, cosh, tanh, csch, sech, coth, asinh, acosh, atanh, acsch, asech, acoth**: hyperbolic functions
- **hypot**: Square root of sum of squares (hypotenuse), better than sqrt(x^2+y^2) manually
- **deg2rad, rad2deg**: Convert angle between degrees and radians
- **cart2pol, pol2cart**: transform between Cartesian coordinates, polar (极坐标) and cylindrical (柱坐标) coordinates
- **cart2sph, sphcart**: transform between Cartesian and spherical coordinates (球坐标)

### Exponent and Logarithm (指对数)

- **exp, log, log10, log2, nthroot, pow2, sqrt**
- **expm1**: Compute `exp(x)-1` -- $(e^x -1)$ accurately for small values of x
- **log1p**: Compute `log(1+x)` --  $ln(1+x)$ accurately for small values of x

### Discrete Math 

- **factor**: Prime factors
- **factorial**: Factorial of input 
  - `factorial(n)` returns $n!$
- **gcd, lcm**: Greatest common divisor or least common multiple
- **isprime, primes**: Determine which array elements are prime, and return an array of prime numbers up to the given limit

### Polynomials 

- **poly**: Polynomial with specified roots or characteristic polynomial 
  - `ploy(f)` returns the roots and `ploy(A)` returns the characteristic polynomial of A
- **polyfit**: 	Polynomial curve fitting
- **roots**: Polynomial roots

### Complex Numbers 

### Special Functions 

### Constants and Test Matrices

## Random Number Generation

- **rand**:	Uniformly distributed random numbers
- **randn**: Normally distributed random numbers
- **randi**: Uniformly distributed pseudorandom integers
- **randperm**:	Random permutation of integers
- **rng**: Control random number generator
- **RandStream**: Random number stream

## Interpolation (插值)

<!-- details begin -->
<details>
<summary><span class='Word'>interp1, interp2, interp3, interpn</span>: Interpolation for 1-D, 2-D, 3-D, and N-D gridded data in ndgrid format</summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-22-00-07-36_MatlabNotes(2)-Mathematics.jpg"/></div>

```matlab
figure

nexttile
x = 0:pi/4:2*pi; 
v = [0  1.41  2  1.41  0  -1.41  -2  -1.41 0];
xq = 0:0.1:2*pi;
vq2 = interp1(x,v,xq,'spline');
plot(x,v,'o',xq,vq2,':.');

nexttile
[X,Y] = meshgrid(-3:3);
V = peaks(X,Y);
surf(X,Y,V)
title('Original Sampling');

nexttile
[Xq,Yq] = meshgrid(-3:0.25:3);
Vq = interp2(X,Y,V,Xq,Yq,'cubic');
surf(Xq,Yq,Vq);
title('Cubic Interpolation Over Finer Grid');

nexttile
[Xq,Yq] = meshgrid(-3:0.25:3);
Vq = interp2(X,Y,V,Xq,Yq,'spline');
surf(Xq,Yq,Vq);
title('Spline Interpolation Over Finer Grid');
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>interpft</span>: 1-D interpolation (FFT method)</summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-22-00-11-40_MatlabNotes(2)-Mathematics.png"/></div>

```matlab
figure
dx = 3*pi/30;
x = 0:dx:3*pi;
f = sin(x).^2 .* cos(x);

N = 200;
y = interpft(f,N);
dy = dx*length(x)/N;
x2 = 0:dy:3*pi;
y = y(1:length(x2));
plot(x,f,'o')
hold on
plot(x2,y,'.')
title('FFT Interpolation of Periodic Function')
``` 
</details>

## Optimization

<!-- details begin -->
<details>
<summary><span class='Word'>fminbnd</span>: Find minimum of single-variable function on fixed interval</summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-22-00-18-59_MatlabNotes(2)-Mathematics.png"/></div>

```matlab
figure
fun = @sin;
x1 = 0;
x2 = 2*pi;

% monitor the process
options = optimset('Display','iter');
x = fminbnd(@scalarobjective,1,3,options)

X = 0:0.1:2*pi;
plot(X,scalarobjective(X))

function f = scalarobjective(x)
    f = 0;
    for k = -10:10
        f = f + (k+1)^2*cos(k*x)*exp(-k^2/2);
    end
end

% output:
x = 2.0061
val = -0.6828

 Func-count     x          f(x)         Procedure
    1        1.76393    -0.589643        initial
    2        2.23607    -0.627273        golden
    3        2.52786     -0.47707        golden
    4        2.05121    -0.680212        parabolic
    5        2.03127     -0.68196        parabolic
    6        1.99608    -0.682641        parabolic
    7        2.00586    -0.682773        parabolic
    8        2.00618    -0.682773        parabolic
    9        2.00606    -0.682773        parabolic
   10         2.0061    -0.682773        parabolic
   11        2.00603    -0.682773        parabolic
 
优化已终止:
 当前的 x 满足使用 1.000000e-04 的 OPTIONS.TolX 的终止条件
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>fminsearch</span>: Find minimum of unconstrained multivariable function using derivative-free method</summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-22-12-59-45_MatlabNotes(2)-Mathematics.jpg"/></div>

```matlab
figure
[X,Y] = meshgrid(-2.5:0.2:2.5, -1:0.2:5);
fun = @(x,y) 100*(y - x.^2).^2 + (1 - x).^2;

problem.objective = @(x)100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
problem.x0 = [-1.2, 1];
problem.solver = 'fminsearch';
problem.options = optimset('Display','iter')

[x,fval,exitflag,output] = fminsearch(problem)

nexttile
mesh(X,Y,fun(X, Y))
view([-70 30])
pbaspect([1 1 0.5])

nexttile
mesh(X,Y,fun(X, Y))
view([-140 20])
pbaspect([1 1 0.5])


% output: 
problem = 
    objective: @(x)100*(x(2)-x(1)^2)^2+(1-x(1))^2
           x0: [-1.2000 1]
       solver: 'fminsearch'
      options: [1×1 struct]

 
 Iteration   Func-count     min f(x)         Procedure
     0            1             24.2         
     1            3            20.05         initial simplex
     2            5           5.1618         expand
     3            7           4.4978         reflect
     4            9           4.4978         contract outside
     5           11          4.38136         contract inside
     6           13          4.24527         contract inside
     7           15          4.21762         reflect
     8           17          4.21129         contract inside
     9           19          4.13556         expand
    10           21          4.13556         contract inside
    11           23          4.01273         expand
    12           25          3.93738         expand
    13           27          3.60261         expand
    14           28          3.60261         reflect
    15           30          3.46622         reflect
    16           32          3.21605         expand
    17           34          3.16491         reflect
    18           36          2.70687         expand
    19           37          2.70687         reflect
    20           39          2.00218         expand
    21           41          2.00218         contract inside
    22           43          2.00218         contract inside
    23           45          1.81543         expand
    24           47          1.73481         contract outside
    25           49          1.31697         expand
    26           50          1.31697         reflect
    27           51          1.31697         reflect
    28           53           1.1595         reflect
    29           55          1.07674         contract inside
    30           57         0.883492         reflect
    31           59         0.883492         contract inside
    32           61         0.669165         expand
    33           63         0.669165         contract inside
    34           64         0.669165         reflect
    35           66         0.536729         reflect
    36           68         0.536729         contract inside
    37           70         0.423294         expand
    38           72         0.423294         contract outside
    39           74         0.398527         reflect
    40           76          0.31447         expand
    41           77          0.31447         reflect
    42           79         0.190317         expand
    43           81         0.190317         contract inside
    44           82         0.190317         reflect
    45           84          0.13696         reflect
    46           86          0.13696         contract outside
    47           88         0.113128         contract outside
    48           90          0.11053         contract inside
    49           92          0.10234         reflect
    50           94         0.101184         contract inside
    51           96        0.0794969         expand
    52           97        0.0794969         reflect
    53           98        0.0794969         reflect
    54          100        0.0569294         expand
    55          102        0.0569294         contract inside
    56          104        0.0344855         expand
    57          106        0.0179534         expand
    58          108        0.0169469         contract outside
    59          110       0.00401463         reflect
    60          112       0.00401463         contract inside
    61          113       0.00401463         reflect
    62          115      0.000369954         reflect
    63          117      0.000369954         contract inside
    64          118      0.000369954         reflect
    65          120      0.000369954         contract inside
    66          122      5.90111e-05         contract outside
    67          124      3.36682e-05         contract inside
    68          126      3.36682e-05         contract outside
    69          128      1.89159e-05         contract outside
    70          130      8.46083e-06         contract inside
    71          132      2.88255e-06         contract inside
    72          133      2.88255e-06         reflect
    73          135      7.48997e-07         contract inside
    74          137      7.48997e-07         contract inside
    75          139      6.20365e-07         contract inside
    76          141      2.16919e-07         contract outside
    77          143      1.00244e-07         contract inside
    78          145      5.23487e-08         contract inside
    79          147      5.03503e-08         contract inside
    80          149       2.0043e-08         contract inside
    81          151      1.12293e-09         contract inside
    82          153      1.12293e-09         contract outside
    83          155      1.12293e-09         contract inside
    84          157      1.10755e-09         contract outside
    85          159      8.17766e-10         contract inside
 
优化已终止:
 当前的 x 满足使用 1.000000e-04 的 OPTIONS.TolX 的终止条件，
F(X) 满足使用 1.000000e-04 的 OPTIONS.TolFun 的收敛条件
x = 1×2    
    1.0000    1.0000

fval = 8.1777e-10
exitflag = 1
output = 
    iterations: 85
     funcCount: 159
     algorithm: 'Nelder-Mead simplex direct search'
       message: '优化已终止:↵ 当前的 x 满足使用 1.000000e-04 的 OPTIONS.TolX 的终止条件，↵F(X) 满足使用 1.000000e-04 的 OPTIONS.TolFun 的收敛条件↵'
``` 
</details>
	
<!-- details begin -->
<details>
<summary><span class='Word'>lsqnonneg</span>: Solve nonnegative linear least-squares (最小二乘) problem</summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-22-18-39-42_MatlabNotes(2)-Mathematics.png"/></div>

```matlab
% get the least-squares line fitting y=ax+b for points (0,0), (1,2), (2,pi)
% matirx (vector) x = [a b] is the parameter to solve, and matrix C*x is
% the fitted value ^y, while vector d = [y1 y2 y3] is the real value y. 

figure

x1 = 0; y1 = 0;
x2 = 1; y2 = 2;
x3 = 2; y3 = pi;

C = [
x1 1
x2 1
x3 1
]
d = [
y1
y2
y3
]
% x = [a b]

problem.C = C;
problem.d = d;
problem.solver = 'lsqnonneg';
problem.options = optimset('Display','final');

[x,resnorm,residual,exitflag,output,lambda] = lsqnonneg(problem)

a = x(1);
b = x(2);

f = @(x)(a*x + b)
X = [x1 x2 x3]

plot(X, [y1 y2 y3], 'o', X, f(X), 'LineWidth',1.3)

% output:
C = 3×2    
     0     1
     1     1
     2     1

d = 3×1    
         0
    2.0000
    3.1416

已终止优化。
x = 2×1    
    1.5708
    0.1431

resnorm = 0.1228
residual = 3×1    
   -0.1431
    0.2861
   -0.1431

exitflag = 1
output = 
    iterations: 2
     algorithm: 'active-set'
       message: '已终止优化。'

lambda = 2×1    
1.0e-15 *

    0.2220
    0.4163

f = 
    @(x)(a*x+b)

X = 1×3    
     0     1     2
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>fzero</span>: Root of nonlinear function</summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-22-22-25-12_MatlabNotes(2)-Mathematics.png"/></div>

```matlab

``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>optimget</span>: Optimization options values</summary>


```matlab
fun = @(x) sin(x).*log(x+6);
problem1.objective = fun; % function
problem1.x0 = [-4 4]; % initial point for x, real scalar or 2-element vector
problem1.solver = 'fzero';
problem1.options = optimset('Display','iter'); % show iterations (迭代次数)

[x, fval, exitflag, output] = fzero(problem1)
X = -4:0.2:4;
plot(X,fun(X))
yline(0);

% output:
 
 Func-count    x          f(x)             Procedure
    2              -4      0.524576        initial
    3              -4      0.524576        interpolation
    4        -3.41285      0.254695        interpolation
    5        -2.96072     -0.199969        interpolation
    6        -3.15957     0.0187703        interpolation
    7        -3.14251   0.000962753        interpolation
    8        -3.14159  -1.23641e-06        interpolation
    9        -3.14159   3.77999e-10        interpolation
   10        -3.14159   3.37791e-16        interpolation
   11        -3.14159   3.37791e-16        interpolation
 
在区间 [-4, 4] 中发现零
x = -3.1416
fval = 3.3779e-16
exitflag = 1
output = 
    intervaliterations: 0
            iterations: 9
             funcCount: 11
             algorithm: 'bisection, interpolation'
               message: '在区间 [-4, 4] 中发现零'
``` 


</details>


## Numerical Integration and Differential Equations

<!-- details begin -->
<details>
<summary><span class='Word'>ode23, ode45, ode78, ode89, ode113</span>: Solve nonstiff differential (非刚性) equations with low/medium/high order or variable order method</summary>

See [Summary of ODE Options](https://www.mathworks.com/help/releases/R2022a/matlab/math/summary-of-ode-options.html) and [odeset](https://www.mathworks.com/help/releases/R2022a/matlab/ref/odeset.html) for a list of the options compatible with each solver.

van der Pol equation as an example:

$$y'' - \mu(1 - y^2)y' + y = 0$$

where $\mu > 0$ is a scalar constant. We need to rewrite the equation as a system of two first-order (一阶) equations. For instance, we can make the substitution $y' = y_2$ and $y = y_1$. Then, we have:

$$\begin{bmatrix}
y'\\
y''
\end{bmatrix} = \begin{bmatrix}
y_2 \\
\mu(1-y_1^2)y_2 - y_1
\end{bmatrix}$$

While $y_1$ and $y_2$ are the entries `y(1)` and `y(2)` of a two-element vector `dydt = [y(2); (1-y(1)^2)*y(2)-y(1)];`. $y_1 = y_1(t)$ is what we want to find, and the output solution is a two-element vector 
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-22-23-52-18_MatlabNotes(2)-Mathematics.png"/></div>


```matlab
mu = 1 
tspan = [0 20]
y0 = [2; 0]
[t,y] = ode23(@vdp1,tspan,y0);

myplot_2([t,t],y)
title('Solution of van der Pol Equation (\mu = 1) with ODE23');
xlabel('Time t');
ylabel('Solution y');
legend('y_1',"y_2 = y_1'", Location="best",box = 'on')

function dydt = vdp1(t,y)
    dydt = [y(2); (1-y(1)^2)*y(2)-y(1)];
end

function myplot_2(XMatrix, YMatrix)
% 函数myplot_2(X,Y)，用于在一张图中作出两条二维数据线。
% 输入参数：
    % "XMatrix"：应为两列，第一列为第一组数据的横坐标，第二列为第二组数据的横坐标，
    % "YMatrix"：应为两列，第一列为第一组数据的纵坐标，第二列为第二组数据的纵坐标
% 输出：函数图像

% 创建 figure
figure1 = figure('NumberTitle','off','Name','Figure','Color',[1 1 1]);

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% 使用 plot 的矩阵输入创建多个 line 对象
plot1 = plot(XMatrix,YMatrix,'MarkerSize',2,'Marker','o','LineWidth',1.1);
set(plot1(1),'DisplayName','第一列数据','MarkerFaceColor',[0 0 0],'Color',[0.1 0.1 0.1]);
set(plot1(2),'DisplayName','第二列','MarkerFaceColor',[0 0 0.8],'Color',[0 0 1]);

% 创建 ylabel
ylabel('纵坐标（单位）','FontName','TimesNewRoman');

% 创建 xlabel
xlabel('横坐标（单位）','FontName','TimesNewRoman');

hold(axes1,'off');
% 设置其余坐标区属性
set(axes1,'FontName','TimesNewRoman','FontSize',13,'LineWidth',1.1,'XLimitMethod','padded',...
    'YLimitMethod','padded');
% 创建 legend
legend1 = legend(axes1,'show','box','on');
set(legend1,'Location','northwest','FontSize',11,'FontName','TimesNewRoman');
end
``` 
</details>

<!-- details begin -->
<details>
<summary>Another ode example and options settings</summary>
<div class='center'>

| Option Group | Option | comment | value |
|:-:|:-:|:-:|:-:|
 | Step Size | InitialStep |  initial step size | `x` $\in \mathbb{R}_+$, default $\frac{\Delta t}{10}$ |
 | Step Size | MaxStep |  maximum step size | `x` $ \in \mathbb{R}_+$, default $\frac{\Delta t}{10}$ |
 | Error Control | RelTol | relative error tolerance | `x` $ \in \mathbb{R}_+$, default $10^{-3}$ |
 | Error Control | AbsTol | absolute error tolerance | `x` $ \in \mathbb{R}_+$, default $10^{-6}$ |
 | Error Control | NormControl | Control error relative to norm | `'on'`, `'off'`(default) |
 | Solver Output | OutputFcn |  output function | `@odeplot`: Plot all components of the solution vs. time<br>`@odephas2`: <br>`@odephas3`:<br>`@odeprint`: Print solution and time step |
 | Solver Output | Refine | solution refinement factor | `n` $\in \mathbb{N}_+$ |
 | Solver Output | Stats | solver statistics | `'on'`, `'off'` |

</div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-22-22-56-25_MatlabNotes(2)-Mathematics.png"/></div>


```matlab
% solve ode: y′ = − λ*y*t

lambda = pi;

fun = @(t,y) -lambda*y*t
tspan = [0 2];  % solution interval
y0 = 1;
opts = odeset('Stats','on','InitialStep',0.01,'MaxStep',0.1); % options

subplot(2,2,1)
tic,
re23 = ode23(fun, tspan, y0, opts);
toc,
plot(re23.x,re23.y,':.')
title('ode23')

subplot(2,2,2)
tic
re45 = ode45(fun, tspan, y0, opts);
toc
plot(re45.x,re45.y,':.')
title('ode45')

% solve ode: y′ = −λ*t*y

subplot(2,2,3)
tic
re78 = ode78(fun, tspan, y0, opts);
toc
plot(re78.x,re78.y,':.')
title('ode78')

subplot(2,2,4)
tic
re113 = ode113(fun, tspan, y0, opts);
toc
plot(re113.x,re113.y,':.')
title('ode113')

% output: 

fun = 
    @(t,y)-lambda*y*t

23 个成功步骤
0 次失败尝试
70 次函数计算
历时 0.002053 秒。
22 个成功步骤
0 次失败尝试
133 次函数计算
历时 0.001731 秒。
22 个成功步骤
0 次失败尝试
374 次函数计算
历时 0.007955 秒。
23 个成功步骤
0 次失败尝试
47 次函数计算
历时 0.014177 秒。
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>ode15s, ode23s, ode23t, ode23tb</span>: Solve stiff differential equations and DAEs (微分代数方程) </summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-23-00-25-09_MatlabNotes(2)-Mathematics.png"/></div>

```matlab
figure

nexttile
tspan = [0 3000]
y0 = [2; 0]
tic
[t,y] = ode15s(@vdp1000,tspan,y0);  % costs 0.0184 seconds
toc
plot(t,y(:,1),':.')

nexttile
tic
[t,y] = ode45(@vdp1000,tspan,y0);   % costs 7.61 seconds
toc
plot(t,y(:,1),':.')

function dydt = vdp1000(t,y)
    dydt = [y(2); 1000*(1-y(1)^2)*y(2)-y(1)];
end
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>integral, integral2, integral3</span>: Numerically evaluate one/double/triple integral</summary>


```matlab

``` 
</details>

### Differences Between ode Functions
### Differences 
## Linear Algebra
## Fourier Analysis and Filtering

