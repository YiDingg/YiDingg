# Matlab Notes(3): Symbolic Math

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 14:43 on 2024-08-08 in Lincang.


Official link: Mathworks --> Help Center --> Symbolic Math Toolbox --> [Symbolic Computations in MATLAB](https://www.mathworks.com/help/releases/R2022a/symbolic/symbolic-computations-in-matlab.html)

## Symbolic Objects

<!-- details begin -->
<details>
<summary><span class='Word'>syms</span>: Create symbolic scalar variables and functions, and matrix variables and functions</summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-23-17-46-55_MatlabNotes(3)-SymbolicMath.jpg"/></div>

```matlab
% Symbolic Variables

    syms a b [1 3]
    syms A [2 4]
    a,b,A
    
    % You can change the naming format of the generated 
    % elements by using a format character vector.
    
    syms 'p_a%d' 'p_b%d' [1 4]
    p_a
    
    % Manage Assumptions for Symbolic Scalar Variables
    
    syms n m integer
    syms z positive rational % rational (有理数)
    syms c [1 3] real
    n,z,c
    
    % check assumptions
    assumptions

% Symbolic Functions
    syms s(t) f(x,y)
    f(x,y) = x^2 + y
    f(1,2)

    syms x
    f(x) = [x x^3; x^2 x^4];
    xVal = [1 2 3; 4 5 6];
    y = f(xVal), y(1), y{1}

% Symbolic Matrix
syms A B [2 3] matrix
A, A + B

MySymObj = syms % List All Symbolic Objects
cellfun(@clear,MySymObj) % Delete All Symbolic Objects
``` 
</details>

Go to official link [here](https://www.mathworks.com/help/releases/R2022a/symbolic/referencelist.html?type=function&s_tid=CRUX_topnav) for more details about symbolic computations in MATLAB.

## Equation Solving

<!-- details begin -->
<details>
<summary><span class='Word'>eliminate</span>: Eliminate variables from rational equations</summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-23-18-07-06_MatlabNotes(3)-SymbolicMath.png"/></div>

```matlab
% Eliminate the variable x. 
% The result is a symbolic expression that is equal to zero.

syms x y
eqns = [
    x*y/(x-2) + y == 5/(y - x) 
    y-x == 1/(x-1)
    ]
eliminate(eqns,x)

syms z
eqns = [
    x^2 + y-z^2 == 2;
    x - z == y;
    x^2 + y^2-z == 4
    ]
eliminate(eqns, [x y])
eliminate(eqns, [x z])
eliminate(eqns, [y z])
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>finserve</span>: Equations systems solver</summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-23-18-10-20_MatlabNotes(3)-SymbolicMath.png"/></div>

```matlab
syms x
f(x) = 1/tan(x);
g(x) = x^2 + log(x) + 1
finverse(f)
finverse(g)

syms u v
h(u,v) = exp(u-2*v)
finverse(h, u)
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>linsolve</span>: Solve linear equations in matrix form</summary>

`[X,R] = linsolve(A,B)` solves the matrix equation AX = B, and returns the reciprocal of the condition number of A if A is a square matrix. Otherwise, linsolve returns the rank of A.

```matlab
syms a x y z
A = [a 0 0; 0 a 0; 0 0 1];
B = [x; y; z];
[X, R] = linsolve(A, B)

% output: 
X =
 x/a
 y/a
   z
 
R =
1/(max(abs(a), 1)*max(1/abs(a), 1))
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>solve</span>: Equations systems solver</summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-24-10-03-32_MatlabNotes(3)-SymbolicMath.jpg"/></div>

```matlab
syms x
eqn = sin(x) == x^2 - 1;
S = solve(eqn,x)

syms u v
eqns = [2*u^2 + v^2 == 0, u^2 - v == 1];
S = solve(eqns,[u v])
solutions = [S.u S.v]

syms u v
eqns = [2*u^2 + v^2 == 0, u - v == 1];
[solv, solu] = solve(eqns,[v u])
solutions = [solv solu]
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>vpasolve</span>: Solve equations numerically</summary>


```matlab
syms x y
eqns = [
    x*sin(10*x) == y^3; 
    y^2 == exp(-2*x/3)
    ]
[sol_x, sol_y] = vpasolve(eqns, [x,y])

output: 
[x*sin(10*x) == y^3; y^2 == exp(-(2*x)/3)]
vpa("88.90707209659114864849280774681")
vpa("0.00000000000013470479710676694388973703681918")
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>dsolve</span>: Solve system of differential equations</summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-24-10-29-46_MatlabNotes(3)-SymbolicMath.png"/></div>

```matlab
syms y(x)
eqn = diff(y) == (x-exp(-x))/(y(x)+exp(y(x)));
S = dsolve(eqn,'Implicit',true)

syms x y
h = exp(y) + y^2/2 == 1 + exp(-x) + x^2/2
fimplicit(h, [-20 20])
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>odeFunction</span>: Convert symbolic expressions to function handle for ODE solvers</summary>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-24-15-58-51_MatlabNotes(3)-SymbolicMath.jpg"/></div>

```matlab
figure

nexttile
    syms y(t);
    eqn = diff(y(t),t,2) == (1-y(t)^2)*diff(y(t),t) - y(t)
    [eqs,vars] = reduceDifferentialOrder(eqn,y(t));
    [M,F] = massMatrixForm(eqs,vars);
    f = M\F
    
    initConditions = [2 0];
    odefun = odeFunction(f,vars);
    ode15s(odefun, [0 20], initConditions)

nexttile
    ode45(odefun, [0 20], initConditions)

nexttile
    syms x(t) y(t)
    eqs = [
        diff(x(t),t)+2*diff(y(t),t) == 0.1*y(t)
        x(t)-y(t) == cos(t)-0.2*t*sin(x(t))
           ]
    vars = [x(t) y(t)];
    [M,F] = massMatrixForm(eqs,vars);
    
    M = odeFunction(M,vars);
    F = odeFunction(F,vars);
    xy0 = [2; 1];    % x(t) and y(t)
    xyp0 = [0; 0.05*xy0(2)];    % derivatives of x(t) and y(t)
    opt = odeset('mass', M, 'RelTol', 10^(-6),...
                   'AbsTol', 10^(-6), 'InitialSlope', xyp0);
    ode15s(F, [0 7], xy0, opt)

nexttile
    ode23t(F, [0 7], xy0, opt)
``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'></span>: </summary>


```matlab

``` 
</details>

## 

<!-- details begin -->
<details>
<summary><span class='Word'></span>: </summary>


```matlab

``` 
</details>