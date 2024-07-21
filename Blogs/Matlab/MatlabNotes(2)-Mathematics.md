# Matlab Notes (2): Mathematics

Learn at the official Matlab documentation [here](https://www.mathworks.com/help/releases/R2022a/matlab/mathematics.html?s_tid=CRUX_lftnav).

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


## Linear Algebra

## Random Number Generation

- **rand**:	Uniformly distributed random numbers
- **randn**: Normally distributed random numbers
- **randi**: Uniformly distributed pseudorandom integers
- **randperm**:	Random permutation of integers
- **rng**: Control random number generator
- **RandStream**: Random number stream

## Interpolation (插值) ✨

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

## Optimization ✨

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


```matlab
figure
[X,Y] = meshgrid(-2.5:0.1:2.5, -2.5:0.1:2.5)
fun = @(x,y) 100*(y - x.^2).^2 + (1 - x).^2;

problem.objective = @(x)100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
problem.x0 = [-1.2, 1];
problem.solver = 'fminsearch';
problem.options = optimset('Display','iter')

[x,fval,exitflag,output] = fminsearch(problem)

nexttile
mesh(X,Y,fun(X, Y))
view([-70 30])

nexttile
mesh(X,Y,fun(X, Y))
view([-140 20])

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
<summary><span class='Word'>lsqnonneg</span>: Solve nonnegative linear least-squares problem</summary>


```matlab

``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>fzero</span>: Root of nonlinear function</summary>


```matlab

``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>optimget</span>: Optimization options values</summary>


```matlab

``` 
</details>

<!-- details begin -->
<details>
<summary><span class='Word'>optimset</span>: Create or modify optimization options structure</summary>

</details>

	
	

## Numerical Integration and Differential Equations

## Fourier Analysis and Filtering

<!-- details begin -->
<details>
<summary><span class='Word'></span>: </summary>


```matlab

``` 
</details>