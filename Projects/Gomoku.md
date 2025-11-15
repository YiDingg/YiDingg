# Programming of Gomoku<br>五子棋程序设计

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 09:13 on 2024-08-30 in Beijing.


## Intro

本设计为 C 语言课程结课作业，源代码及最终成果见 [GitHub](https://github.com/YiDingg/Gomoku/releases)

程序要求实现：

-   基本界面
-   游戏模式
    -   人人对战
    -   人机对战
    -   机机对战

## 五子棋规则

### 原始规则

也称 Free-style Gomoku：

-   行棋：黑子先行，一人轮流一著下于棋盘空点处。
-   胜负：先把五枚或以上己棋相连成任何横纵斜方向为胜。（长连仍算胜利）

### 禁手

禁手是对先手下棋一方（黑子）的一种限制，无禁手的称为 ，有禁手的情况下，又分为多种禁手，比如三三禁手、四四禁手和长连禁手等。

禁手规则详见 [here](https://www.zhihu.com/question/375400094/answer/2454295442)，建议先了解下面的术语再看禁手。

### 术语

**棋盘：**

-   阳线：直线，棋盘上可见的横纵直线。
-   交叉点：阳线垂直相交的点，简称“点”。
-   阴线：斜线，由交叉点构成的与阳线成 45° 夹角的隐形斜线。
-   落子：棋子直接落于棋盘的空白交叉点上。
-   轮走方：“行棋方”，有权利落子的黑方或白方。
-   着：在对局过程中，行棋方把棋子落在棋盘无子的点上，不论落子的手是否脱离棋子，均被视为一着。
-   回合：双方各走一着，称为一个回合。
-   开局：在对局开始阶段形成的布局。
-   连：同色棋子在一条阳线或阴线上相邻成一排。

**棋形汇总：**

-   四：在一条阳线或阴线上连续相邻的 5 个点上只有四枚同色棋子的棋型。
-   活四：有两个点可以成五的四。
-   冲四：只有一个点可以成五的四。
-   死四：不能成五的四。
-   三：在一条阳线或阴线上连续相邻的 5 个点上只有三枚同色棋子的棋型。
-   活三：再走一着可以形成活四的三。
-   连活三：连的活三（同色棋子在一条阳线或阴线上相邻成一排的活三）。简称“连三”。
-   跳活三：中间隔有一个空点的活三。简称“跳三”。
-   眠三：再走一着可以形成冲四的三。
-   死三：不能成五的三。
-   二：在一条阳线或阴线上连续相邻的 5 个点上只有两枚同色棋子的棋型。
-   活二：再走一着可以形成活三的二。
-   连活二：连的活二（同色棋子在一条阳线或阴线上相邻成一排的活二）。简称“连二”。
-   跳活二：中间隔有一个空点的活二。简称“跳二”。
-   大跳活二〗中间隔有两个空点的活二。简称“大跳二”。
-   眠二：再走一着可以形成眠三的二。
-   死二：不能成五的二。
-   先手：对方必须应答的着法，相对于先手而言，冲四称为“绝对先手”。
-   三三：一子落下同时形成两个活三。也称“双三”。
-   四四：一子落下同时形成两个冲四。也称“双四”。
-   四三：一子落下同时形成一个冲四和一个活三。

**图片详解：**

-   五连：五颗同色棋连成一线的棋形称为“五连”

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-50-00_Gomoku.jpg"/></div>

-   活四：四颗同色棋连成一线，且两端无异色棋挡着的棋形称为“活四”

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-51-02_Gomoku.jpg"/></div>

-   冲四：把下一步棋可以走成五连的棋形称为“冲四”
    -   连冲四（简称“冲四”）
    -   跳冲四

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-50-28_Gomoku.jpg"/></div>

-   活三：下一步能走成活四的棋形称为“活三”
    -   连活三（简称“活三”）
    -   跳活三

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-52-34_Gomoku.jpg"/></div>

-   眠三：下一步能走成冲四的棋形称为“眠三”。眠三的棋形有多种，如图所示

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-53-13_Gomoku.jpg"/></div>

-   活二：下一步能形成活三的棋形叫作活二
    -   连二
    -   跳二
    -   大跳二

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-55-37_Gomoku.jpg"/></div>

-   进攻手段：冲四、活三、做眠三、做活二、做眠二和进攻性做棋的单子统称为进攻手段
-   绝对先手：迫使对方必须防守的手段叫做：绝对先手
-   追手冲四和活三这两种进攻手段称为：追手
-   做棋：追手之外的进攻性的行棋叫作做棋，做棋包括活二，也包括为了能使活二数量急速增加，或者为了能使追手进攻连续下去最终取胜而下的一些单个棋子。
-   做势：为了使活二数量能快速增加的做棋叫作：做势
-   做杀：为了能使追手进攻连续下去最终取胜的做棋叫作：做杀
-   审局在下棋过程中要不断审时度势，判断盘面形势，这叫做：审局
-   一级连攻：活四、冲四和双冲四，是一级连攻
-   二级连攻：活三、含招和示招是二级连攻


## 杨力祥班五子棋对战规则 (2024)

### 对战规则

原文件详见 [here](https://www.123865.com/s/0y0pTd-UOKj3)，这里仅提部分要点：

- 总规则：每对选手比赛两局，轮流执黑先行，胜一局得 2 分，负一局得 0 分，和棋各得 1 分
- 胜负评判：
    - 不违反禁手规则的前提下，最先在棋盘横向、竖向、斜向形成连续的相同色五个棋子的一方为胜。
    - 如分不出胜负，则定为平局。
    - 黑棋禁手判负，白棋无禁手。
    - 对局中途退场 (程序死机) 判为负。
    - 五连与禁手同时形成，先五为胜。
    - <span style='color:red'> 黑方禁手形成时，白方的程序应立即指出</span>。若白方未发现或发现后未指明而继续应子，则不能判黑方负。
    - 计算机每步“思考”时间不得长于 15 秒。否则判负。
- 禁手规则
    - 白方无禁手
    - 黑方禁手：三三（包括连活三、跳活三）、四四（包括活四、冲四）、长连。也即 ThreeThree，FourFour 和 Overline。
    - 五连与禁手一并形成时，黑方获胜 (而不是判负)
- 棋盘要求：共 $15 \times 15$ 个交点，用 1 ~ 15 表示“行”，A ~ O 表示“列”。棋盘左下角为 (1, A)，右上角为 (15, O)。

<span style='color:red'> 注：考虑到易读性，之前我们写代码时，都是采用左上角为 (1, A) 的形式，这与老师的要求不同。为解决此，只需对输出进行处理，水平颠倒棋盘，使得输出的 (1, A) 在左下角即可。</span>这样，除输出函数，原代码无需做任何修改，在后续的分析中，我们也采用原来的方向，默认左上角为 (1, A)。

### 禁手详解

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-10-11-22-42-54_Gomoku.jpg"/></div>

<!-- - 双三：即“三三”，黑方一子落下同时形成两个或更多活三

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-10-11-18-58-56_Gomoku.png"/></div>

- 双四：即“四四”，黑方一子落下同时形成两个或更多活四

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-10-11-18-59-18_Gomoku.png"/></div>

- 长连：指黑方一子落下，形成六个或六个以上的同色连续棋子

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-10-11-19-00-56_Gomoku.jpg"/></div>
 -->

## 禁手检查

按上一节 `杨力祥班五子棋对战规则` 的禁手要求，我们指定检查顺序为：长连 > 五连 > 四四 > 三三。
如果未长连，且形成五连，则无需继续检查四四和三三，这是因为“五连与禁手一并形成时，黑方获胜”。

### 长连检查

长连包括六、七、八、九连（最多九连），只需检查六连即可，代码思路如下：

``` c
我方为黑棋时，能否落子的检查都放在了函数 CheckThisLocation()，它的声明为：
void CheckThisLocation(
    Enum_LegalOrIllegal* p_islegal,
    const Enum_Color chessboard[ROW][COLUMN],
    const Struct_Location* p_location,
    const Enum_Color me);

因此考虑在 CheckThisLocation() 中加入下面子函数：

/**
 * @brief 检查此位置长连禁手情况，并将结果赋给 p_islegal
 * @param p_islegal 用于合法性检查
 * @param chessboard 棋盘数据
 * @param p_location 要检查的位置
 * @retval none
 */
void CheckOverline(
    Enum_LegalOrIllegal* p_islegal,
    const Enum_Color chessboard[ROW][COLUMN],
    const Struct_Location* p_location) {
}

输入：需要检查的位置、当前棋局（黑方还未落子）、当前布尔矩阵（用于继承多层检查结果）
作用：检查长连并将结果赋给 p_islegal
```

具体操作：
    给定循环变量 i、j，用于遍历棋盘矩阵，也即给定棋盘位置。将棋盘及要检查的位置传入子函数，子函数判断是否六连，并返回相应布尔值。全部位置都处理完毕后，返回布尔矩阵。

子函数操作：
    对给定的需要判断的位置，对每个给定的方向（最多三个方向），以当前位置为中心，沿给定方向和反方向各延伸 5 格位置（算上当前位置共 11 格）。然后，再用循环变量 k (最大范围 [0, 5])，表示 11 格中的第 k+1 格，以此格为起点，向另一端再数五格，判断是否六连。例如，水平方向时，以最左侧一格为起点，向右边数五格，进行判断。然后递增 k，直到 k 为 5，完成此次检查，同时结束此方向的检查，进入下一方向。

特别地，我方为白棋时，应在 GetChess 函数之前先检查对方的禁手情况，此时只需在新棋盘中回退一步，然后假设我们是黑方，再检查此位置的禁手情况即可。仅需检查一个位置，且一次性检查完三种禁手情况。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-10-14-22-13-10_Gomoku.jpg"/></div>

依据上图进行分析，三个方向对 k 的范围限制如下表所示，其中 $s = \min \{i, j\}, b = \max \{i, j\}$。

<div class='center'>
向右 →

| $i$ | $j$ | $k$ |
|:-:|:-:|:-:|
 | - | [0, 4]   | [5-j, 5] |
 | - | [5, 9]   | [0, 5] |
 | - | [10, 14] | [0, 14-j] |
</div>

<div class='center'>
向下 ↓

| $i$ | $j$ | $k$ |
|:-:|:-:|:-:|
| [0, 4]   | - | [5-i, 5] |
| [5, 9]   | - | [0, 5] |
| [10, 14] | - | [0, 14-i] |
</div>

<div class='center'>
右下 ↘

| $i$ | $j$ | $k$ |
|:-:|:-:|:-:|
 | $[0, 4]  $ | $[0, 4]  $ | $[5-{\color{red} s}, 5]   $ |
 | $[0, 4]  $ | $[5, 9]  $ | $[5-i, 5]   $ |
 | $[0, 4]  $ | $[10, 14]$ | $[5-i, 14-j]$ |
 | $[5, 9]  $ | $[0, 4]  $ | $[5-j, 5]   $ |
 | $[5, 9]  $ | $[5, 9]  $ | $[0, 5]     $ |
 | $[5, 9]  $ | $[10, 14]$ | $[0, 14-j]  $ |
 | $[10, 14]$ | $[0, 4]  $ | $[5-j, 14-i]$ |
 | $[10, 14]$ | $[5, 9]  $ | $[0, 14-i]  $ |
 | $[10, 14]$ | $[10, 14]$ | $[0, 14-{\color{red} b}]  $ |
</div>




### 五连检查

<span style='color:red'> 参考张钰堃！ </span>


### 四四检查

### 三三检查

## 五子棋基本框架

棋盘所需的字符 / 字符串可以到 `Word --> 插入 --> 符号 --> 其它符号` 中寻得。

下面是一个实现了五子棋基本框架的可执行文件（无禁手）：

-   [Gomoku_v1.1.exe](https://www.writebug.com/static/uploads/2024/8/31/28aaa56bb15b759e543f8ae057aae210.exe)

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-33-33_Gomoku.jpg"/></div> -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-31-23-04-12_Gomoku.png"/></div>

最新版本详见 [GitHub](https://github.com/YiDingg/Gomoku/releases)。



## AI 算法：纯随机

用 `srand((unsigned) (time(NULL) + rand()))` 和 `rand()` 生成随机数来实现，不多赘述，也是 v1.x 版本所用的算法。

## AI 算法：流程图

依据下面流程图构建简易 AI 算法：

<div class='center'><img src='assets/draw.ioFiles/Gomoku_AI_Easy.drawio.svg' alt='img'/>
<div class='caption'>Figure: 简易 AI 算法</div></div>

## AI 算法：Greedy Algorithm

### 概述

依贪心算法，现在我们的 AI 只考虑一步，即下一步的落子位置。那么 AI 应该在哪个位置落子？一个自然的想法是，评估所有可能的落子位置，选择价值（value）最高的位置（对本方最有利的位置）。

### 具体原理

易见，问题的关键就在于“评估”两字，也即评估函数，不妨命名为 `GetChess_AI_Greedy`。

`GetChess_AI_Greedy` 函数应该做到以下事情：给定当前棋局和当前棋色（我方棋色），计算所有空位的价值（value），并返回 value 最高的位置。因此，一个合理的函数定义是（输入棋局、我方颜色，输出最佳落子位置）：

```c
Struct_Location GetBestLocation(int chessboard[COLUMN][ROW], Color me) {
  /* code here */
}
```

其中 `Struct_Location` 是表征棋盘某位置的结构体：

```c
typedef struct {
  char raw;     // 行号
  char column;  // 列号
}Struct_Location;
```

`GetChess_AI_Greedy` 如何计算某一个空位的价值（value）呢？答案是，对给定的空位，假设我方将棋下在这个空位，得到一个新的棋局，对此棋局进行评估，返回 value 值。评估棋局价值的函数，我们记为 `EvaluateChessboard()`。

`EvaluateChessboard()`的具体工作：
给定一个棋局，计算棋局上所有位置的评分（score）。每个位置的 score，由从此点开始的四个方向的五元组评估得到，将所有位置的 score 相加，得到棋局的总分（return 一个 int），进而可以将这个总分视作上一步某空位的 value。这里要注意区分 score 和 value 的不同，score 是由评估某一位置的四个方向的五元组所得（水平向右、竖直向下、向左下方和向右下方），而 value 是将棋下在某位置后，整个棋局的 score 总和。

四个方向我们可以用 `enum` 记为：

```c
typedef enum {
  Right = 1,
  Down,
  RightDown,
  LeftDown
}Enum_Derection;
```

因此，`EvaluateChessboard()` 的一个合理定义如下（输入棋局、我方颜色，输出棋局总 score）：

```c
int EvaluateChessboard(int chessboard[COLUMN][ROW], Color me){
  /* code here */
}
```

`EvaluateChessboard()` 的评分逻辑即为五元组的评分细则，假设我方为黑棋，对于每个五元组, 我们定义评分规则如下：

<div class='center'>

|          五元组          |  score   |          五元组          |  score   |
| :----------------------: | :------: | :----------------------: | :------: |
|    同时含有黑子、白子    |    0     |    同时含有黑子、白子    |    0     |
|        1 黑 4 空         |    +3    |        1 白 4 空         |    -3    |
| 形如 0BB00, 00BB0, 0B0B0 |   +30    | 形如 0WW00, 00WW0, 0W0W0 |   -30    |
|        2 黑 3 空         |   +20    |        2 白 3 空         |   -20    |
|        形如 0BBB0        |  +2000   |        形如 0WWB0        |  -2000   |
|        3 黑 2 空         |  +1000   |        3 白 2 空         |  -1000   |
|        4 黑 1 空         | +100000  |        4 白 1 空         | -100000  |
|        5 黑 0 空         | +1000000 |        5 白 0 空         | -1000000 |

</div>

从上至下依次进行匹配，匹配成功则立即返回 score，例如 0BB00 虽然也满足“2 黑 3 空”，但是它先满足了“形如 0BB00, 00BB0”，因此返回 +30 而非 +20。

当然，这些分数你也可以自行修改（也可以拓展相关规则）。由对称性，我们只需要确定如下评分值即可：

<div class='center'>

|       五元组       | score |
| :----------------: | :---: |
| 同时含有黑子、白子 |       |
|     1 黑 4 空      |       |
| 形如 0BB00, 00BB0  |       |
|     2 黑 3 空      |       |
|     形如 0BBB0     |       |
|     3 黑 2 空      |       |
|     4 黑 1 空      |       |
|     5 黑 0 空      |       |

</div>

这些值可以由 `enum` 进行存储。

另外，考虑到棋盘不同位置的落子收益不同（例如棋盘中心和角落相比，中心收益更高），因此，我们需要给每个位置一个默认 value，之后计算的 value 值应该加上默认 value。这样做还有一个好处就是，假设许多空位的 value 值都相同，加上默认 value 值可以帮助我们利用位置收益来考虑落子位置。

例如，对于空棋盘，我们计算棋盘上各个位置的 value，如下（假设我方为黑棋）：

```c
const char ValuesOfBlankChessboard[ROW][COLUMN] = {
    // 棋盘不同位置的默认 value 值
    {9 , 12, 15, 18, 24, 24, 24, 24, 24, 24, 24, 18, 15, 12, 9 },
    {12, 18, 21, 27, 33, 33, 33, 33, 33, 33, 33, 27, 21, 18, 12},
    {15, 21, 30, 36, 42, 42, 42, 42, 42, 42, 42, 36, 30, 21, 15},
    {18, 27, 36, 45, 51, 51, 51, 51, 51, 51, 51, 45, 36, 27, 18},
    {24, 33, 42, 51, 60, 60, 60, 60, 60, 60, 60, 51, 42, 33, 24},
    {24, 33, 42, 51, 60, 60, 60, 60, 60, 60, 60, 51, 42, 33, 24},
    {24, 33, 42, 51, 60, 60, 60, 60, 60, 60, 60, 51, 42, 33, 24},
    {24, 33, 42, 51, 60, 60, 60, 60, 60, 60, 60, 51, 42, 33, 24},
    {24, 33, 42, 51, 60, 60, 60, 60, 60, 60, 60, 51, 42, 33, 24},
    {24, 33, 42, 51, 60, 60, 60, 60, 60, 60, 60, 51, 42, 33, 24},
    {24, 33, 42, 51, 60, 60, 60, 60, 60, 60, 60, 51, 42, 33, 24},
    {18, 27, 36, 45, 51, 51, 51, 51, 51, 51, 51, 45, 36, 27, 18},
    {15, 21, 30, 36, 42, 42, 42, 42, 42, 42, 42, 36, 30, 21, 15},
    {12, 18, 21, 27, 33, 33, 33, 33, 33, 33, 33, 27, 21, 18, 12},
    {9 , 12, 15, 18, 24, 24, 24, 24, 24, 24, 24, 18, 15, 12, 9 },
};
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-01-19-45-57_Gomoku.png"/></div>

一个合适的默认 value 值如下：

```c
const char DefultValuesOfChessboard[ROW][COLUMN] = {
    /* 棋盘不同位置的默认 value 值 */
    {0, 0, 0, 0, 0, 0 , 0 , 0 , 0 , 0 , 0, 0, 0, 0, 0},
    {0, 0, 2, 2, 2, 2 , 2 , 2 , 2 , 2 , 2, 2, 2, 0, 0},
    {0, 2, 2, 4, 4, 4 , 4 , 4 , 4 , 4 , 4, 4, 2, 2, 0},
    {0, 2, 4, 4, 6, 6 , 6 , 6 , 6 , 6 , 6, 4, 4, 2, 0},
    {0, 2, 4, 6, 6, 8 , 8 , 8 , 8 , 8 , 6, 6, 4, 2, 0},
    {0, 2, 4, 6, 8, 12, 16, 16, 16, 12, 8, 6, 4, 2, 0},
    {0, 2, 4, 6, 8, 16, 20, 24, 20, 16, 8, 6, 4, 2, 0},
    {0, 2, 4, 6, 8, 16, 24, 30, 24, 16, 8, 6, 4, 2, 0},
    {0, 2, 4, 6, 8, 16, 20, 24, 20, 16, 8, 6, 4, 2, 0},
    {0, 2, 4, 6, 8, 12, 16, 16, 16, 12, 8, 6, 4, 2, 0},
    {0, 2, 4, 6, 6, 8 , 8 , 8 , 8 , 8 , 6, 6, 4, 2, 0},
    {0, 2, 4, 4, 6, 6 , 6 , 6 , 6 , 6 , 6, 4, 4, 2, 0},
    {0, 2, 2, 4, 4, 4 , 4 , 4 , 4 , 4 , 4, 4, 2, 2, 0},
    {0, 0, 2, 2, 2, 2 , 2 , 2 , 2 , 2 , 2, 2, 2, 0, 0},
    {0, 0, 0, 0, 0, 0 , 0 , 0 , 0 , 0 , 0, 0, 0, 0, 0},
};
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-01-19-46-41_Gomoku.png"/></div>

加上默认 value 值后，空棋盘的 value 如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-01-19-47-00_Gomoku.png"/></div>

### 准备工作

**函数 `CheckThisLocation()`：**<br>衡量某一位置的 value 时，我们需要先判断此位置是否可以落子（尤其是有禁手的情况），因此需要从人人对战版本的五子棋（v1.X）中重构出 `CheckThisLocation()` 函数，用于检查某一位置是否可以落子。

为方便后续代码的编写，我们**规定变量命名规则如下：**

-   全局变量采用“大驼峰命名法”
-   局部变量全部使用小写，单词之间由下划线 `_` 连接（如果不影响可读性，可以不用下划线，直接拼接起来）
-   指针命名同上，但是加上 `p_` 前缀

**规定数据类型命名规则如下：**

-   `#define` 宏定义全部使用大写，单词之间用下划线 `_` 连接
-   `enum` 枚举类型全部使用 `typedef`，采用“大驼峰命名法”，且加上前缀 `Enum_`；枚举变量采用“大驼峰命名法”，且加上前缀 `enum_`
-   `struct` 结构体类型全部使用 `typedef`，采用“大驼峰命名法”，且加上前缀 `Struct_`；结构体变量采用“大驼峰命名法”，且加上前缀 `struct_`
-   `union` 联合体类型全部使用 `typedef`，采用“大驼峰命名法”，且加上前缀 `Union_`；联合变量采用“大驼峰命名法”，且加上前缀 `union_`

**规定文件内容如下：**

-   宏定义和数据类型定义（枚举、结构体、联合体）都放在 `.h` 头文件中
-   `.h` 头文件中必须声明所有函数，并进行必要的全局变量声明
-   `.h` 头文件必须含有 `#if !defined(__FILENAME_H)` 宏定义以防止重复包含
-   全局变量的初始化放在 `.c` 源文件中
-   函数的具体定义放在 `.c` 源文件中

下面是一个模板：

**main.c** 文件：

```c
/* main.c */

```

**Test.c** 文件：

```c
#include <stdio.h>
#include "main.h"
#include "Test.h"

/* ------------------------------------------------ */
/* >> ---- 全局变量 (在 .data 段, 初值默认 0) ---- << */
/*                                                  */

/*                                                  */
/* >> ---- 全局变量 (在 .data 段, 初值默认 0) ---- << */
/* ------------------------------------------------ */

/* ------------------------------------------------ */
/* >> ------------------ 函数 ------------------ << */
/*                                                  */

/*                                                  */
/* >> ------------------ 函数 ------------------ << */
/* ------------------------------------------------ */
```

**Test.h** 文件：

```c
#include <stdio.h>
#include "main.h"

#if !defined(__TEST_H)
#define __TEST_H

/* ------------------------------------------------ */
/* >> ----------------- 宏定义 ----------------- << */
/*                                                  */

/*                                                  */
/* >> ----------------- 宏定义 ----------------- << */
/* ------------------------------------------------ */

/* ----------------------------------------------- */
/* >> ---------------- 数据类型 ---------------- << */
/*                                                 */

/*                                                 */
/* >> ---------------- 数据类型 ---------------- << */
/* ----------------------------------------------- */

/* ------------------------------------------------- */
/* >> --------------- 全局变量声明 --------------- << */
/*                                                   */

/*                                                   */
/* >> --------------- 全局变量声明 --------------- << */
/* ------------------------------------------------- */

/* ------------------------------------------------- */
/* >> ----------------- 函数声明 ----------------- << */
/*                                                   */

/*                                                   */
/* >> ----------------- 函数声明 ----------------- << */
/* ------------------------------------------------- */
#endif // __TEST_H
```

value 的升序 / 倒序排列，我们使用希尔排序，原始排序代码如下（详细原理见 here）：

```c
/* 希尔排序 (升序, 第一个最小) */
void SortArray_Shell(int* nums, int numsSize) {
    int step = numsSize / 2;
    while (step > 0) {
        //!
        for (int i = step; i < numsSize; ++i) {
            int tmp = nums[i];
            int j = i - step;
            while (j >= 0 && tmp < nums[j]) {
                nums[j + step] = nums[j];
                j -= step;
            }
            nums[j + step] = tmp;
        }
        step = step / 2;
    }
}
```

### 优化: 强制落子

上面的逻辑看似不错，但其实存在一些缺陷，例如，不围堵对方的活三、对方已经冲四而不进行拦截、我方已经活三而不进行冲四。因此，我们需要借助人工逻辑，对 AI 进行一些优化。

为什么我们没有提到“我方已经冲四而不进行成五”的情况呢，是因为按上面 AI 的逻辑，可以成五的位置将有 1000000 的 score，进而导致此位置 value 值极高（通常是最高），因此 AI 一定会选择此位置。但是当加上强制落子后，便有可能出现我方已经冲四而不进行成五的情况，因此也要考虑进去。

下面是一些强制落子的人工逻辑优化（仅考虑五元组的情况, 从上至下依次匹配）：

1. 我方已经冲四
2. 对方已经冲四
3. 我方已经活三
4. 对方已经活三

代码如下：

```c
/* 检查我方和对方是否成三成四, 进行强制落子或强制围堵 */
for (char i = 0; i < ROW; i++) {
    for (char j = 0; j < COLUMN; j++) {
        // if (chessboard[i][j] == Blank) continue; /* 要进行成三检验, 因此不能跳过空位 */

        /* - 向右方 */
        if (j <= COLUMN - 5) {
            for (char k = 0; k < 5; k++) {
                p_five_locations[k].row = i;
                p_five_locations[k].column = j + k;
            }
            if (GetForceChess_five(p_five_locations, chessboard, me, p_best_location)) {
                return;
            }
        }

        /* | 向下方 */
        if (i <= ROW - 5) {
            for (char k = 0; k < 5; k++) {
                p_five_locations[k].row = i + k;
                p_five_locations[k].column = j;
            }
            if (GetForceChess_five(p_five_locations, chessboard, me, p_best_location)) {
                return;
            }
        }

        /* \ 向右下方 */
        if (i <= ROW - 5 && j <= COLUMN - 5) {
            for (char k = 0; k < 5; k++) {
                p_five_locations[k].row = i + k;
                p_five_locations[k].column = j + k;
            }
            if (GetForceChess_five(p_five_locations, chessboard, me, p_best_location)) {
                return;
            }
        }

        /* / 向左下方 */
        if (i <= ROW - 5 && j >= 4) {
            for (char k = 0; k < 5; k++) {
                p_five_locations[k].row = i + k;
                p_five_locations[k].column = j - k;
            }
            if (GetForceChess_five(p_five_locations, chessboard, me, p_best_location)) {
                return;
            }
        }
    }
}

/**
 * @brief 给点棋盘五元组, 判断我方是否可以直接胜利, 若是, 返回落子位置,
 * 否则判断对方是否可能直接胜利, 若是, 返回落子位置
 * @param five_locations 给定五元组
 * @param chessboard 给定的棋局
 * @param me 我方颜色
 * @param p_location 落子位置
 * @note 目前考虑了以下几种情况 (从上至下依次匹配)：
 * 1. 我方冲四
 * 2. 对方冲四
 * 3. 我方活三
 * 4. 对方活三
 * @retval none
 */
bool GetForceChess_five(
    Struct_Location five_locations[5],
    Enum_Color chessboard[ROW][COLUMN],
    const Enum_Color me,
    Struct_Location* p_location) {
    Enum_Color enemy = -me;
    char num_me = 0, num_enemy = 0;

    /* 统计对手棋子数 */
    for (char k = 0; k < 5; k++) {
        chessboard[five_locations[k].row][five_locations[k].column] == enemy ? num_enemy++ : 0;
        chessboard[five_locations[k].row][five_locations[k].column] == me ? num_me++ : 0;
    }
    if (num_me == 4) { /* 检查我方冲四 */
        if (DEBUG) {
            puts("num_me = 4");
            printf(
                "five_locations[0]= (%d, %c) \n",
                five_locations[0].row + 1,
                five_locations[0].column + 'A');
            printf(
                "chessboard[five_locations[0].row][five_locations[0].column] = %d\n",
                chessboard[five_locations[0].row][five_locations[0].column]);
            printf(
                "chessboard[five_locations[4].row][five_locations[4].column] = %d\n",
                chessboard[five_locations[4].row][five_locations[4].column]);
        }
        for (char k = 0; k < 5; k++) {
            if (chessboard[five_locations[k].row][five_locations[k].column] == Blank) {
                if (DEBUG) { puts("我方冲四, 检查是否能够成五"); }
                Enum_LegalOrIllegal islegal;
                CheckThisLocation(&islegal, chessboard, &five_locations[k], me);
                if (islegal == Legal) { /* 是否满足禁手限制 */
                    p_location->row = five_locations[k].row;
                    p_location->column = five_locations[k].column;
                    if (DEBUG) {
                        printf(
                            "five_locations[k].row = %d, five_locations[k].column = %d \n",
                            five_locations[k].row,
                            five_locations[k].column);
                    }
                    return true; /* 返回落子位置, 可以直接取得胜利 */
                } else {
                    return false; /* 受禁手限制, 虽冲四但是无法落子, 返回 false */
                }
            }
        }
        return false; /* 这一句不可少, 否则未作任何 return 就退出 (相当于 return true;) */
    } else if (num_enemy == 4) { /* 检查对方冲四 */
        if (DEBUG) {
            puts("num_enemy = 4");
            printf(
                "five_locations[0]= (%d, %c) \n",
                five_locations[0].row + 1,
                five_locations[0].column + 'A');
            printf(
                "chessboard[five_locations[0].row][five_locations[0].column] = %d\n",
                chessboard[five_locations[0].row][five_locations[0].column]);
            printf(
                "chessboard[five_locations[4].row][five_locations[4].column] = %d\n",
                chessboard[five_locations[4].row][five_locations[4].column]);
        }
        for (char k = 0; k < 5; k++) {
            if (chessboard[five_locations[k].row][five_locations[k].column] == Blank) {
                if (DEBUG) { puts("对方冲四, 检查是否能够围堵"); }
                Enum_LegalOrIllegal islegal;
                CheckThisLocation(&islegal, chessboard, &five_locations[k], me);
                if (islegal == Legal) { /* 是否满足禁手限制 */
                    p_location->row = five_locations[k].row;
                    p_location->column = five_locations[k].column;
                    if (DEBUG) {
                        printf(
                            "five_locations[k].row = %d, five_locations[k].column = %d \n",
                            five_locations[k].row,
                            five_locations[k].column);
                    }
                    return true; /* 返回落子位置, 防止对方直接获胜 */
                } else {
                    return false; /* 受禁手限制, 对方虽冲四但是无法落子, 无需围堵, 返回 false */
                }
            }
        }
        return false; /* 这一句不可少, 否则未作任何 return 就退出 (相当于 return true;) */
    } else if (num_me == 3) { /* 检查我方活三 */
        if (DEBUG) {
            puts("num_me = 3");
            printf(
                "five_locations[0]= (%d, %c) \n",
                five_locations[0].row + 1,
                five_locations[0].column + 'A');
            printf(
                "chessboard[five_locations[0].row][five_locations[0].column] = %d\n",
                chessboard[five_locations[0].row][five_locations[0].column]);
            printf(
                "chessboard[five_locations[4].row][five_locations[4].column] = %d\n",
                chessboard[five_locations[4].row][five_locations[4].column]);
        }
        if (chessboard[five_locations[0].row][five_locations[0].column] == Blank
            && chessboard[five_locations[4].row][five_locations[4].column] == Blank) {
            if (DEBUG) { printf("我方活三, 检查能否冲四 \n"); }
            /* 仅需检查我方禁手情况, 无需检查对方禁手情况 */
            Enum_LegalOrIllegal islegal_1, islegal_2;
            CheckThisLocation(&islegal_1, chessboard, &five_locations[0], me);
            CheckThisLocation(&islegal_2, chessboard, &five_locations[0], me);
            if (islegal_1 == Illegal && islegal_2 == Illegal) {
                return false; /* 活三但是无法ceeds, 返回 false */
            } else {          /* 存在 legal 位置 */
                if (DEBUG) { printf("islegal_1 = %d, islegal_2 = %d\n", islegal_1, islegal_2); }
                if (islegal_1 == Legal && islegal_2 == Legal) {
                    if (DEBUG) { puts("进入两种冲四方式的选择"); }
                    int value_1, value_2;
                    /* 计算两种冲四方式的优劣 */
                    chessboard[five_locations[0].row][five_locations[0].column] = me;
                    value_1 = EvaluateChessboard(chessboard, me);
                    chessboard[five_locations[0].row][five_locations[0].column] = Blank;
                    chessboard[five_locations[4].row][five_locations[4].column] = me;
                    value_2 = EvaluateChessboard(chessboard, me);
                    chessboard[five_locations[0].row][five_locations[0].column] = Blank;
                    /* 选择最佳方式 */
                    if (value_1 > value_2) {
                        if (DEBUG) {
                            printf(
                                "five_locations[0].row = %d, five_locations[0].column = %d \n",
                                five_locations[0].row,
                                five_locations[0].column);
                        }
                        p_location->row = five_locations[0].row;
                        p_location->column = five_locations[0].column;
                    } else {
                        if (DEBUG) {
                            printf(
                                "five_locations[4].row = %d, five_locations[4].column = %d \n",
                                five_locations[4].row,
                                five_locations[4].column);
                        }
                        p_location->row = five_locations[4].row;
                        p_location->column = five_locations[4].column;
                    }
                } else { /* 我方只有一个 legal 位置, 无法从此处活三取得shengl, 返回 false */
                    return false;
                }
            }
            return true;
        }
        return false;
    } else if (num_enemy == 3) { /* 检查对方活三 */
        if (DEBUG) {
            puts("num_enemy = 3");
            printf(
                "five_locations[0]= (%d, %c) \n",
                five_locations[0].row + 1,
                five_locations[0].column + 'A');
            printf(
                "chessboard[five_locations[0].row][five_locations[0].column] = %d\n",
                chessboard[five_locations[0].row][five_locations[0].column]);
            printf(
                "chessboard[five_locations[4].row][five_locations[4].column] = %d\n",
                chessboard[five_locations[4].row][five_locations[4].column]);
        }
        if (chessboard[five_locations[0].row][five_locations[0].column] == Blank
            && chessboard[five_locations[4].row][five_locations[4].column] == Blank) {
            if (DEBUG) { printf("对方活三, 检查是否需要围堵 \n"); }
            Enum_LegalOrIllegal islegal_me[2], islegal_enemy[2]; /* 两个空位的我方、对方禁手情况 */
            CheckThisLocation(&islegal_me[0], chessboard, &five_locations[0], me);
            CheckThisLocation(&islegal_me[1], chessboard, &five_locations[4], me);
            CheckThisLocation(&islegal_enemy[0], chessboard, &five_locations[0], enemy);
            CheckThisLocation(&islegal_enemy[1], chessboard, &five_locations[4], enemy);
            if (islegal_enemy[0] == Legal && islegal_enemy[1] == Legal) {
                /* 对方有两个 legal 位置, 检查我方是否可以进行围堵 */
                if (islegal_me[0] == Legal && islegal_me[1] == Legal) { /* 两空位都可以进行围堵 */
                    if (DEBUG) { puts("对方活三, 进入两种围堵方式的选择"); }
                    int value_1, value_2;
                    /* 计算两种围堵方式的优劣 */
                    chessboard[five_locations[0].row][five_locations[0].column] = me;
                    value_1 = EvaluateChessboard(chessboard, me);
                    chessboard[five_locations[0].row][five_locations[0].column] = Blank;
                    chessboard[five_locations[4].row][five_locations[4].column] = me;
                    value_2 = EvaluateChessboard(chessboard, me);
                    chessboard[five_locations[0].row][five_locations[0].column] = Blank;
                    /* 选择最佳方式 */
                    if (value_1 > value_2) {
                        if (DEBUG) {
                            printf(
                                "five_locations[0].row = %d, five_locations[0].column = %d \n",
                                five_locations[0].row,
                                five_locations[0].column);
                        }
                        p_location->row = five_locations[0].row;
                        p_location->column = five_locations[0].column;
                    } else {
                        if (DEBUG) {
                            printf(
                                "five_locations[4].row = %d, five_locations[4].column = %d \n",
                                five_locations[4].row,
                                five_locations[4].column);
                        }
                        p_location->row = five_locations[4].row;
                        p_location->column = five_locations[4].column;
                    }
                } else if (islegal_me[0] == Legal) { /* 只有第一个空位可以进行围堵 */
                    p_location->row = five_locations[0].row;
                    p_location->column = five_locations[0].column;
                } else if (islegal_me[1] == Legal) { /* 只有最后一个空位可以进行围堵 */
                    p_location->row = five_locations[4].row;
                    p_location->column = five_locations[4].column;
                } else { /* 两空位都不能进行围堵, 对方获胜 */
                    printf(
                        "%s 活三而 %s 无法围堵, %s 胜利! \n",
                        (me == Black) ? "白棋" : "黑棋",
                        (me == White) ? "白棋" : "黑棋",
                        (me == Black) ? "白棋" : "黑棋");
                    exit(0);
                }
                return true;
            }
        }
        return false;
    } else {
        return false;
    }
}
```

### 优化: harm_nothere

前面我们计算了在此位置落子所带来的收益，并将其记为 value，加上默认位置价值后，用来选取最佳落子位置。这样也会有一些缺陷，例如下面这种情况（蓝色代表我方，红色代表对方，轮到我方落子）：

<div class='center'><img src='assets/draw.ioFiles/harm_nothere.drawio.svg' alt='img'/>
<div class='caption'>Figure: harm_nothere 示意图</div></div>

按原先的算法，我方不会触发强制落子，且在 value 评估后，会选择点 a 或点 b 进行落子，而不是点 c。一个想法是在强制落子处增加双三检查，但实现起来比较麻烦，而且也没有必要。更自然也更普适的方法是，将落子在此位置的收益记为 value_here，将不落子在此位置的危害记为 harm_nothere，然后选择 value_here - harm_nothere 最大的位置进行落子。这样就能保证同时考虑到收益与危害后选择落子位置。

由比如下面这种情况：

## AI 算法：Greedy + Min-Max

参考 https://github.com/lihongxun945/gobang, https://github.com/lihongxun945/myblog/issues/13, 在线五子棋：https://gobang2.light7.cn/

算法大致流程如下：

-   确定参数
    -   Depth: 树的深度
    -   Multiplier: 公倍数（每个节点的子节点数）

则叶结点数目为 $m^d$，其中 $m$ 为 Multiplier，$d$ 为 Depth。

假设我方是黑棋，现在轮到我方下棋，
每个叶节点是，

## AI 算法：Greedy + Min-Max + Alpha-Beta 剪枝

alpha-beta 剪枝是对 Min-Max 算法的改进，Min-Max 算法是灵魂，alpha-beta 剪枝不过是加了一点 trick 节约搜索资源。

### 原理

-   叶节点：最底层节点。仅叶节点可以计算此操作分数
-   极大点

### 评分函数

## Reference

下面是一些参考资料：
- [x] [五子棋规则](https://www.zhihu.com/question/375400094/answer/2454295442)
- [x] [基于 alpha-beta 剪枝技术的五子棋](https://zhuanlan.zhihu.com/p/593096861)
- [x] [alpha-beta 剪枝算法原理](https://blog.csdn.net/moonlight11111/article/details/124208342)
- [x] [最清晰易懂的 MinMax 算法和 Alpha-Beta 剪枝详解](https://blog.csdn.net/weixin_42165981/article/details/103263211)
- [x] [极小极大搜索方法、负值最大算法和 Alpha-Beta 搜索方法](https://www.cnblogs.com/pangxiaodong/archive/2011/05/26/2058864.html)
- [x] [C++实现的基于 αβ 剪枝算法五子棋设计](https://blog.csdn.net/newlw/article/details/125588734)
- [x] [leetcode: 按升序排列数组](https://leetcode.cn/problems/sort-an-array/description/)

以下是一些参考代码：
- [x] [GitHub > tututugege > UCAS-Renju](https://github.com/tututugege/UCAS-Renju) : main reference
- [x] [GitHub > lihongxun945 > gobang](https://github.com/lihongxun945/gobang) : 提供了一个五子棋在线网址
- [x] [GitHub > hijkzzz > alpha-zero-gomoku](https://github.com/hijkzzz/alpha-zero-gomoku) : 五子棋的 Python 实现
- [x] [GitHub > LucasLan666666 > Gomoku](https://github.com/LucasLan666666/Gomoku) : 五子棋基本框架与简单 AI
- [x] [GitHub > Renovamen > Gomoku](https://github.com/Renovamen/Gomoku) : 五子棋基本框架与简单 AI
- [x] [GitHub > MasterLaplace > GomokuAlgo](https://github.com/MasterLaplace/GomokuAlgo) :
- [x] [GitHub > mirrorinf > GomokuZero](https://github.com/mirrorinf/GomokuZero) : 基于 Alpha-Beta 的五子棋
- [X] [GitHub > zykucas > UCAS-C-language-programming](https://github.com/zykucas/UCAS-C-language-programming) : 纯打分五子棋 (2023 秋 ylx 2 班冠军), 尝试运行但 (作了修改后仍) 未能成功编译