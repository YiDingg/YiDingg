# Programming of Gomoku<br>五子棋程序设计

## Intro

本设计为 C 语言课程结课作业，源代码及最终成果见 [GitHub](https://github.com/YiDingg/Gomoku/releases)

程序要求实现：

- 基本界面
- 游戏模式
  - 人人对战
  - 人机对战
  - 机机对战

## 五子棋规则


### 原始规则

也称 Free-style Gomoku：

- 行棋：黑子先行，一人轮流一著下于棋盘空点处。
- 胜负：先把五枚或以上己棋相连成任何横纵斜方向为胜。（长连仍算胜利）

### 禁手

禁手是对先手下棋一方（黑子）的一种限制，无禁手的称为 ，有禁手的情况下，又分为多种禁手，比如三三禁手、四四禁手和长连禁手等。

禁手规则详见 [here](https://www.zhihu.com/question/375400094/answer/2454295442)，建议先了解相关名词再看禁手。

### 专有名词

- 五连：五颗同色棋连成一线的棋形称为“五连”

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-50-00_Gomoku.jpg"/></div>

- 活四：四颗同色棋连成一线，且两端无异色棋挡着的棋形称为“活四”

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-51-02_Gomoku.jpg"/></div>

- 冲四：把下一步棋可以走成五连的棋形称为“冲四”
  - 连冲四（简称“冲四”）
  - 跳冲四

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-50-28_Gomoku.jpg"/></div>


- 活三：下一步能走成活四的棋形称为“活三”
  - 连活三（简称“活三”）
  - 跳活三

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-52-34_Gomoku.jpg"/></div>

- 眠三：下一步能走成冲四的棋形称为“眠三”。眠三的棋形有多种，如图所示

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-53-13_Gomoku.jpg"/></div>

- 活二：下一步能形成活三的棋形叫作活二
  - 连二
  - 跳二
  - 大跳二

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-55-37_Gomoku.jpg"/></div>

- 进攻手段：冲四、活三、做眠三、做活二、做眠二和进攻性做棋的单子统称为进攻手段
- 绝对先手：迫使对方必须防守的手段叫做：绝对先手
- 追手冲四和活三这两种进攻手段称为：追手
- 做棋：追手之外的进攻性的行棋叫作做棋，做棋包括活二，也包括为了能使活二数量急速增加，或者为了能使追手进攻连续下去最终取胜而下的一些单个棋子。
- 做势：为了使活二数量能快速增加的做棋叫作：做势
- 做杀：为了能使追手进攻连续下去最终取胜的做棋叫作：做杀
- 审局在下棋过程中要不断审时度势，判断盘面形势，这叫做：审局
- 一级连攻：活四、冲四和双冲四，是一级连攻
- 二级连攻：活三、含招和示招是二级连攻

## 基本框架

棋盘所需的字符 / 字符串可以到 `Word --> 插入 --> 符号 --> 其它符号` 中寻得。

下面是一个实现了五子棋基本框架的可执行文件：
- [Gomoku_v1.0.exe](https://www.writebug.com/static/uploads/2024/8/30/3a4188ed213009acb30f695c62f2d840.exe)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-16-33-33_Gomoku.jpg"/></div>

其它版本详见 [GitHub](https://github.com/YiDingg/Gomoku/releases)。

## 算法：伪随机数

`rand()` 生成随机数来实现，不多赘述，也是 v1.0 版本所用的算法。

## 算法：简易 AI

依据下面流程图构建简易 AI 算法：

<div class='center'><img src='assets/draw.ioFiles/Gomoku_AI_Easy.drawio.svg' alt='img'/>
<div class='caption'>Figure: 简易 AI 算法</div></div>




## 算法：基于 alpha-beta 剪枝技术的五子棋

主要参考了 [基于 alpha-beta 剪枝技术的五子棋](https://zhuanlan.zhihu.com/p/593096861)。

### 评分函数

初始化棋盘不同位置对应的权值：

``` c
char* array[] = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 0},
    {0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 0},
    {0, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 0},
    {0, 1, 2, 3, 4, 5, 5, 5, 5, 5, 4, 3, 2, 1, 0},
    {0, 1, 2, 3, 4, 5, 6, 6, 6, 5, 4, 3, 2, 1, 0},
    {0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1, 0},
    {0, 1, 2, 3, 4, 5, 6, 6, 6, 5, 4, 3, 2, 1, 0},
    {0, 1, 2, 3, 4, 5, 5, 5, 5, 5, 4, 3, 2, 1, 0},
    {0, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 0},
    {0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 0},
    {0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
};
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-30-17-02-47_Gomoku.jpg"/></div>

初始化以下变量：

## Reference

- [x] [五子棋规则](https://www.zhihu.com/question/375400094/answer/2454295442)
- [ ] [基于 alpha-beta 剪枝技术的五子棋](https://zhuanlan.zhihu.com/p/593096861)
- [ ] [alpha-beta 剪枝算法原理](https://blog.csdn.net/moonlight11111/article/details/124208342)
