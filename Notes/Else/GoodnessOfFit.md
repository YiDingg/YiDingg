# Goodness of Fit<br> 拟合优度（回归模型评价指标）

> [!Note|style:callout|label:Infor]
Initially published at 19:12 on 2024-09-30 in 北京.

## 离散数据

当实际数据（真实数据）离散时，通常取拟合函数在相同自变量下的函数值（称为拟合集）与实际数据进行比较，以此评判拟合优度。拟合集与实际集是两个同等大小的向量 / 矩阵 / 多维矩阵。

### 知识储备


#### SSR / ESS

SSR (The Sum of Squares Due to Regression), 回归平方和, 亦称 ESS (Explained sum of squares), 解释平方和.

$$
SSR = \sum_{i=1}^{n} (\hat{y}_i- \bar{y})^2
$$


#### SSE / RSS


SSE (The Sum of Squared Errors of Prediction), 预测误差平方和, 亦称为 RSS (Residual sum of squares), 残差平方和.

$$
SSE = \sum_{i=1}^{n} (y_i - \hat{y}_i)^2
$$

#### SST / TSS

SST (sum of squares total), 总离差平方和, 亦称 TSS (Total Sum of Squares), 总体平方和.

$$
SST =  \sum_{i=1}^{n} (y_i- \bar{y})^2 
$$

当 $\hat{y}$ 是线性拟合时（即 $\hat{y} = \hat{a}x + \hat{}b$），有 $SST = SSE + SSR$（非线性时不成立）。


### 优度衡量

#### R Squared ($R^2$)

R Squared ($R^2$), 范围 $[-\infty, 1]$，越接近 1 越好。$R^2$ 的好处是作了归一化，对不同类型的数据集能保持较好的比较标准。

$$
R^2  = 1 - \frac{SSE}{SST} = 1 - \frac{\sum_{i=1}^{n} (y_i - \hat{y}_i)^2}{\sum_{i=1}^{n} (y_i- \bar{y})^2}
$$

特别地，当 $\hat{y} = \hat{a}x + \hat{b}$ 为线性拟合时，由于 $SST = SSE + SSR$，有 $R^2 = 1 - \frac{SSE}{SST}  = \frac{SSR}{SST} $。

#### Adjusted R Squared

Adjusted R Squared, 范围 $[-\infty, 1]$，越接近 1 越好。当自变量个数增加时，$R^2$ 会增加，但这并不意味着模型更好，Adjusted R Squared 在其基础上考虑了自变量个数的影响。

$$
Adjusted\ R^2 =  1 - \left(1 - R^2\right) \times \frac{n-1}{n-p-1}
$$
其中 $n$ 为数据集的大小（数据个数），$p$ 为自变量的个数。


#### MAE 

MAE, Mean Absolute Error, 平均绝对误差。范围 $[0, +\infty)$，越接近 0 越好。

$$
MAE = \frac{1}{n} \sum_{i=1}^{n} |y_i - \hat{y}_i|
$$

#### MAPE

MAPE, Mean Absolute Percentage Error, 平均绝对百分比误差。范围 $[0, +\infty)$，越接近 0 越好。

$$
MAPE = \frac{1}{n} \sum_{i=1}^{n}  \frac{|y_i - \hat{y}_i|}{\max \{\varepsilon, |y_i|\}} 
$$

<!-- #### MyMAPE

MyMAPE, My Mean Absolute Percentage Error, 自定义平均绝对百分比误差。范围 $[0, +\infty)$，越接近 0 越好。

$$
\text{MyMAPE} = \frac{1}{n} \sum_{i=1}^{n}  \frac{|y_i - \hat{y}_i|}{\max \{\varepsilon, |y_i|\}} 
$$
 -->

#### MSE

MSE, Mean Squared Error, 均方误差。范围 $[0, +\infty)$，越接近 0 越好。

$$
MSE = \frac{1}{n} \sum_{i=1}^{n} (y_i - \hat{y}_i)^2 = \frac{SSE}{n}
$$

#### RMSE 

RMSE, Residual Mean Squared Error, 均方根误差, MSE 的平方根。范围 $[0, +\infty)$，越接近 0 越好。

$$
RMSE = \sqrt{MSE} = \sqrt{\frac{1}{n} \sum_{i=1}^{n} (y_i - \hat{y}_i)^2} 
$$

#### fitness

同时考虑 $R^2$ 和 RMSE 的优度量，范围 $[0, +\infty)$，越接近 0 越好。

$$
fitness = \frac{RMSE}{R^2} = \frac{\sqrt{\frac{1}{n} \sum_{i=1}^{n} (y_i - \hat{y}_i)^2} }{1 - \frac{\sum_{i=1}^{n} (y_i - \hat{y}_i)^2}{\sum_{i=1}^{n} (y_i - \bar{y})^2}}
$$

#### MSLE

MSLE, Mean Squared Logarithmic Error, 均方对数误差。范围 $[0, +\infty)$，越接近 0 越好。

MSLE 对预测值小于真实值的惩罚要大一些，比较适合应用在预测必需品的投放量，此时同样误差的情况下，预测多了比预测少了要好。

$$
MSLE =\frac1{n}\sum_{i=1}^{n}[\ln(1+y_i)- \ln(1+\hat{y}_i)]^2
$$

#### RMSLE

RMSLE, Root Mean Squared Logarithmic Error, 均方根对数误差, MSLE 的平方根。范围 $[0, +\infty)$，越接近 0 越好。

$$
RMSLE = \sqrt{MSLE} = \sqrt{\frac1{n}\sum_{i=1}^{n}[\ln(1+y_i)- \ln(1+\hat{y}_i)]^2}
$$

## 连续数据

当实际数据连续时（比如一个比较复杂的函数），通常考虑拟合函数与原函数的直接比较，以此评判拟合优度。

### 知识储备

### 优度衡量

#### SAAE 标准绝对面积误差

SAAE, Standard Absolute Area Error, 标准绝对面积误差。范围 $[0, +\infty)$，越接近 0 越好。

$$
SAAE = \frac{\int_{a}^{b} |f(x) - g(x)| dx}{\int_{a}^{b} |f(x)| dx}
$$

## 中英文对照表

常见统计学专业术语的中英对照详见 [here](https://zhuanlan.zhihu.com/p/371810441).