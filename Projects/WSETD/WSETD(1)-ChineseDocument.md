# WSETD (1): 中文文档

>WSETD，全称 *Writing Standards of Easy-read Technical Document*。

## 文件命名

（1）文档的文件名不得含有空格  
（2）文件名必须使用半角字符，不得使用全角字符（这意味着<span style='color:red'>文件名不能包含中文</span>）。  
（3）为了醒目，某些说明文件的文件名，可以全部使用大写字母。比如`README.md`、`LICENSE.md`  
（4）文件命名采用“大骆驼拼写法”（UpperCamelCase），即每个单词的首字母大写，其余字母小写。  

例如：一英文文档标题为 "Learn English"，或中文文档标题为“如何学习英语”，则应将文件命名为`LearnEnglish.md`。  

（5）禁止存在仅大小写不同的文件名  
Window、Linux和Mac系统中的大小写敏感不同，Linux 系统是大小写敏感的，而 Windows 和 Mac 系统是大小写不敏感的。因此，为了提高文件可移植性，应避免存在仅大小写不同的文件名。例如：在整个文档 / 工程中，不能同时存在名为`Hello.md`和`hello.md`的文件，应对其中一个进行重命名。

（6）当英文文档标题过长时，应采用缩写命名，缩写规则如下：

标题大小写规范参考 [英语标题中大小写的问题](https://zhuanlan.zhihu.com/p/38086502)。

- 标题中首字母大写的单词，至少保留其首字母。例如，`How to Learn English`中应保留`H`、`L`、`E`。
- 标题中未大写的单词，若由三个或者三个以下字母构成，则保留完整单词（小写），否则取前三个字母。

例如，`How to Learn English`中的`to`被完整保留，文件命名为`HowtoLearnEnglish.md`或`HtoLE.md`；标题`Skeletal Differences between Boys and Girls`中的`and`被完整保留，`between`被缩写为`bet`，文件最终命名为`SDbetBandG.md`。

又例如，标题为`Writing Standards of Easy-read Technical Document`的文档，应省略

（7）特别地，当文档内容过多时，应作为一个系列，分为多篇进行撰写。文件应采用`SeriesName(num)-Title`的命名方式，并增加本系列大纲（Outline），大纲结构详见 [其它-系列大纲](Projects\WSETD\WSETD(1)-ChineseDocument.md?id=系列大纲)

例如：将标题“易读性技术文档写作规范”翻译为*Writing Standards of Easy-read Technical Document*，并取 WSETD 为英文标题的缩写，最终得到：

```
OutlineOfWSETD.txt
WSETD(1)-ChineseDocument.txt
WSETD(2)-EnglishDocument.txt
WSETD(3)-SpanishDocument.txt
...
```

下面是一些命名示例：

```markdown
标题 --> 命名

Hello World --> HelloWorld.md
Learn English --> LearnEnglish.md
License --> LICENSE.md
Readme --> README.md
How to Learn English --> HowtoLearnEnglish.md 或 HtoLE.md
Writing Standards of Easy-read Technical Document --> WSofETD.md
Skeletal Differences between Boys and Girls --> SDBbetBandG.md
```

## 标题

### 原则

（1）标题共分为<strong style='color:red'>三级</strong>
- 一级标题：文章标题
- 二级标题：文章主要部分的大标题
- 三级标题：大标题下的小标题

（3）当文档内容过多，三级标题无法满足需求时，（除非特殊情况）应将文档分为多篇文章，每篇文章的标题格式为`系列名称（序号）：本篇标题`。例如：

- C语言笔记大纲
- C语言笔记（1）：开始之前
- C语言笔记（2）：内存与关键字
- C语言笔记（3）：数据类型
<!-- <a href="/#/Blogs/C/C语言笔记汇总.md">C语言笔记汇总</a> -->
<!-- <button onclick="window.open('/#/Blogs/C/C语言笔记汇总.md')" type="button">C语言笔记汇总.md</button>。 -->

（4）具体原则：

<details>
<summary>1. 一级标题（文章标题）下，不能直接出现三级标题</summary>

示例：下面的文章结构，缺少二级标题。

- 易读性技术文档写作规范（1）：中文文档
    - 内容1（三级）
    - 内容2
</details>
<details>
<summary>2. 标题要避免孤立编号（避免只有一个同级标题）</summary>

示例：下面的文章结构，二级标题`命名`只包含一个三级标题，应该省略三级标题`命名的要点`。
- 易读性技术文档写作规范（1）：中文文档
  - 命名（二级）
    - 命名的要点（三级）
  - 标题（二级）
    - 内容1（三级）
    - 内容2
</details>


<details>
<summary>3. 下级标题不重复上级标题的名字</summary>

示例：下面的文章结构，二级标题`命名`与下属的三级标题`命名`同名，应该避免，例如将三级标题改为`命名概要`。

- 易读性技术文档写作规范（1）：中文文档
  - 命名（二级）
    - 命名（三级）
    - 命名示例
  - 标题（二级）
    - 内容1（三级）
    - 内容2
</details>

<details>
<summary>4. 可以不使用三级标题</summary>

二级标题下可以没有三级标题，直接进行内容的书写。
</details>


<details>
<summary>5. 二级标题无序号，三级标题过多时应当加上序号</summary>

序号由半角阿拉伯数字、半角原点和一个半角空格构成。

示例：下面的文章结构，二级标题`命名`下有八个三级标题，应当加上`1. `，`2. `，……，`8. `序号。

- 易读性技术文档写作规范（1）：中文文档
  - 命名（二级）
    - <span>1. </span>小标题（三级）
    - <span>2. </span>小标题
    - <span>3. </span>小标题
    - <span>4. </span>小标题
    - <span>5. </span>小标题
    - <span>6. </span>小标题
    - <span>7. </span>小标题
    - <span>8. </span>小标题
  - 标题（二级）
    - 内容1（三级）
    - 内容2
</details>

### 标题示例

下面是一个常规示例：

- 易读性技术文档写作规范（文章标题，一级）
  - 命名（二级）
    - 内容1（三级）
    - 内容2
  - 标题（二级）
    - 内容1（三级）
    - 内容2
  - 内容（二级）
    - 字间距（三级）
    - 句子
    - 写作风格
    - 英文处理

下面是将文档分为多篇文章的示例：

- 易读性技术文档写作规范（1）：中文文档
  - 命名（二级）
    - 内容1（三级）
    - 内容2
  - 标题（二级）
    - 内容1（三级）
    - 内容2
  - 内容（二级）
    - 字间距（三级）
    - 句子
    - 写作风格
    - 英文处理

- 易读性技术文档写作规范（2）：英文文档
  - Naming (level 2)
    - Blabla1 (level 3)
    - Blabla2
  - Title (level 2)
    - Blabla1 (level 3)
    - Blabla2
  - Content (level 2)
    - Word Space (level 3)
    - Sentence
    - Writing Style
    - Chinese Processing


## 段落

### 原则

（1）一个段落只能有一个主题，或一个中心句子。  
（2）段落的中心句子放在段首，对全段内容进行概述。后面陈述的句子为中心句子服务。  
（3）一个段落的长度不能超过七行，最佳段落长度小于等于四行。  
（4）段落的句子语气要使用陈述和肯定语气，避免使用感叹语气。  
（5）段落之间使用一个空行隔开。  
（6）段落开头不要留出空白字符。

### 引用

（1）引用第三方内容时，应注明出处。

```
One man’s constant is another man’s variable. — Alan Perlis
```

（2）如果是全篇转载，请在全文开头显著位置注明作者和出处，并链接至原文。

```
本文转载自 WikiQuote
```

（3）使用外部图片时，必须在文末或图片下方标明来源。

```
本文部分图片来自 Wikipedia
```

## 内容

### 字间距

<details>
<summary>1. 字符</summary>

全角中文字符与半角英文字符、半角阿拉伯数字和半角百分号之间应有一个半角空格。

```
错误：测试产品发布于2024年7月2日，其中有6.5%不合格。  
正确：测试产品发布于 2024 年 7 月 2 日，其中有 6.5% 不合格。
```
</details>


<details>
<summary>2. 等号与英文单位</summary>

用半角等号表示相等/等价关系时，等号两侧要留有间隙。另外，英文单位若不翻译，单位前的阿拉伯数字与单位符号之间，应当留有一个半角空格。

```
错误：一部容量为 16GB 的智能手机，1h = 60min = 3,600s
正确：一部容量为 16 GB 的智能手机，1 h = 60 min = 3,600 s
```
</details>

<details>
<summary>3. 全角标点</summary>

半角英文字符与全角标点符号之间不留空格。
```
错误：他的电脑是 MacBook Air 。
正确：他的电脑是 MacBook Air。
```
</details>


### 句子

<details>
<summary>1. 尽量避免使用长句</summary>

不包含任何标点符号的单个句子，或者以逗号分隔的句子构件，长度尽量保持在 20 个字以内；20～29 个字的句子，可以接受；30～39 个字的句子，语义必须明确，才能接受；多于 40 个字的句子，任何情况下都不能接受。

另外，逗号分割的长句，总长度不应该超过 100 字或者正文的 3 行。

```
错误：本产品适用于从由一台服务器进行动作控制的单一节点结构到由多台服务器进行动作控制的并行处理程序结构等多种体系结构。
正确：本产品适用于多种体系结构。无论是由一台服务器（单一节点结构），还是由多台服务器（并行处理结构）进行动作控制，均可以使用本产品。
```
</details>

<details>
<summary>2. 多使用简单句和并列句，尽量避免使用复合句</summary>

```
并列句：他昨天生病了，没有参加会议。
复合句：那个昨天生病的人没有参加会议。
```
</details>

<details>
<summary>3. 同样一个意思，尽量使用肯定句表达，少用否定句表达</summary>

```
错误：请确认没有接通装置的电源。
正确：请确认装置的电源已关闭。
```
</details>


<details>
<summary>4. 避免使用双重否定句</summary>

```
错误：没有删除权限的用户，不能删除此文件。
正确：用户必须拥有删除权限，才能删除此文件。
```
</details>


### 写作风格

<details>
<summary>1. 尽量不使用被动语态，改为使用主动语态</summary>

```
错误：假如此软件尚未被安装，
正确：假如尚未安装这个软件，
```
</details>


<details>
<summary>2. 不使用非正式的语言风格。</summary>

```
错误：Lady Gaga 的演唱会真是酷毙了，从没看过这么给力的表演！！！
正确：无法参加本次活动，我深感遗憾。
```
</details>


<details>
<summary>3. 不使用冷僻或生造词语，而使用现代汉语的常用表达方式</summary>

```
错误：这是唯二的快速启动的方法。
正确：这是仅有的两种快速启动的方法。
```
</details>


<details>
<summary>4. 用对“的”、“地”、“得”</summary>

```
她露出了开心的笑容。
她开心地笑了。
她笑得很开心。
```
</details>

<details>
<summary>5. 使用代词时必须明确指代的内容，保证不产生歧义</summary>

使用代词时（比如“其”、“该”、“此”、“这”等词），必须明确指代的内容，保证只有一个含义

```
错误：从管理系统可以监视中继系统和受其直接控制的分配系统。
正确：从管理系统可以监视两个系统：中继系统和受中继系统直接控制的分配系统。
```
</details>

<details>
<summary>6. 名词前不要使用过多的形容词</summary>

```
错误：此设备的使用必须在接受过本公司举办的正式的设备培训的技师的指导下进行。
正确：此设备必须在技师的指导下使用，且指导技师必须接受过由本公司举办的正式设备培训。
```
</details>


### 英文处理

<details>
<summary>1. 复数形式还原为单数形式</summary>

英文原文如果使用了复数形式，翻译成中文时，应该将其还原为单数形式。

```
英文：...information stored in random access memory (RAMs)...
中文：⋯⋯存储在随机存取存储器（RAM）里的信息⋯⋯
```
</details>


<details>
<summary>2. 外文缩写可以使用半角圆点(`.`)表示缩写</summary>

```
U.S.A.
Apple, Inc.
```
</details>

<details>
<summary>3. 英文省略号`...`应改为中文省略号`……`</summary>

表示中文时，英文省略号`...`应改为中文省略号`……`（在中文输入法下`Shift + 6`）。

```
英文：5 minutes later...
中文：5 分钟过去了……
```
</details>


<details>
<summary>4. 英文书名、电影名等改用中文表达时，双引号应改为书名号</summary>

``` markdown
英文：He published an article entitled "The Future of the Aviation".
中文：他发表了一篇名为《航空业的未来》的文章。
```
</details>


<!-- details begin -->
<details>
<summary>5. 第一次出现英文词汇时，在括号中给出中文标注</summary>

第一次出现英文词汇时，在括号中给出中文标注。此后再次出现时，直接使用英文缩写即可。

``` markdown
IOC（International Olympic Committee，国际奥林匹克委员会）。这样定义后，便可以直接使用“IOC”了。
```
</details>


<!-- details begin -->
<details>
<summary>6. 专有名词需注意字母大写</summary>

专有名词中需注意第一个字母的大写，非专有名词则不需要大写。

```
“American Association of Physicists in Medicine”（美国医学物理学家协会）是专有名词，需要大写。
“online transaction processing”（在线事务处理）不是专有名词，不应大写。
```
</details>


## 标点符号

### 原则

（1）中文语句的标点符号，均应该采取全角符号，这样可以与全角文字保持视觉的一致。  
（2）如果整句为英文，则该句使用英文/半角标点。  
（3）句号、问号、叹号、逗号、顿号、分号和冒号不得出现在一行之首。  
（4）点号（句号、逗号、顿号、分号、冒号）不得出现在标题的末尾，而标号可以（引号、括号、破折号、省略号、书名号、着重号、间隔号、叹号、问号）。

### 具体规范

<!-- details begin -->
<details>
<summary>1. 句号</summary>

- 中文语句的结尾处应该用全角句号（`。`）
- 句子末尾用括号加注时，句号应在括号之外。

```
错误：关于文件的输出，请参照第 1.3 节（见第 26 页。）
正确：关于文件的输出，请参照第 1.3 节（见第 26 页）。
```
</details>

<!-- details begin -->
<details>
<summary>2. 逗号</summary>

- 逗号（`，`）表示句子内部的一般性停顿
- 注意避免“一逗到底”，即整个段落除了结尾，全部停顿都使用逗号。

</details>

<!-- details begin -->
<details>
<summary>3. 顿号</summary>

- 中文句子内部的并列词，应该用全角顿号(`、`) 分隔，而不用逗号，即使并列词是英语也是如此。

```
错误：我最欣赏的科技公司有 Google, Facebook, 腾讯, 阿里和百度等。
正确：我最欣赏的科技公司有 Google、Facebook、腾讯、阿里和百度等。
```

- 英文句子中，并列词语之间使用半角逗号（`,`）分隔。
  
```
例句：Microsoft Office includes Word, Excel and other components.
```

- 中文句子内部的并列词，最后一个尽量使用（`和`）来连接，使句子读起来更加连贯，下面两个句子都可以，第二个更优。

```
错误：我最欣赏的科技公司有 Google、Facebook、腾讯、阿里，以及百度等。
正确：我最欣赏的科技公司有 Google、Facebook、腾讯、阿里和百度等。
```
</details>

<!-- details begin -->
<details>
<summary>4. 分号</summary>

- 分号（`；`）表示复句内部并列分句之间的停顿。
</details>

<!-- details begin -->
<details>
<summary>5. 引号</summary>

- 引用时，应该使用全角双引号（`“ ”`），注意前后双引号不同。

```
例句：许多人都认为客户服务的核心是“友好”和“专业”。
```

- 引号里面还要用引号时，外面一层用双引号，里面一层用单引号（`‘ ’`），注意前后单引号不同。

```
例句：鲍勃解释道：“我要放音乐，可萨利说，‘不行！’。”
```
</details>

<!-- details begin -->
<details>
<summary>6. 括号</summary>

- 补充说明时，使用全角圆括号（`（）`），括号前后不加空格。

```
例句：请确认所有线缆（电缆和接插件）均安装牢固。
```

几种括号的中英文名称。

<div class='center'>

| 括号 | 英文名称  | 中文名称  |
|:-:|:-:|:-:|
| `{ }` | braces 或 curly brackets    | 大括号 |
| `[ ]` | square brackets 或 brackets | 方括号 |
| `< >` | angled brackets             | 尖括号 |
| `( )` | parentheses                 | 圆括号 |
</div>
</details>

<!-- details begin -->
<details>
<summary>7. 冒号</summary>

- 全角冒号`：`常用在需要解释的词语后边，引出解释和说明
- 表示时间时，应使用半角冒号`:`。

```
例句：请确认：时间为早上 8:00、地点在大厅。
```
</details>

<!-- details begin -->
<details>
<summary>8. 省略号</summary>

- 省略号（`……`）表示语句未完、或者语气的不连续。
- 省略号占两个汉字空间、包含六个省略点，不要使用`。。。`或`...`等非标准形式。
- 省略号不应与“等”这个词一起使用。

```
错误：我们为会餐准备了香蕉、苹果、梨…等各色水果。
正确：我们为会餐准备了各色水果，有香蕉、苹果、梨……
正确：我们为会餐准备了香蕉、苹果、梨等各色水果。
```
</details>

<!-- details begin -->
<details>
<summary>9. 感叹号</summary>

- 应该使用平静的语气叙述，尽量避免使用感叹号（`！`）。
- 不得多个感叹号连用，比如`！！`和`!!!`。
</details>



<!-- details begin -->
<details>
<summary>10. 破折号</summary>

- 破折号`————`一般用于进一步解释。
- 破折号应占两个汉字的位置。如果破折号本身只占一个汉字的位置，那么前后应该留出一个半角空格。

```
例句：直觉————尽管它并不总是可靠的————告诉我，这事可能出了些问题。
例句：直觉 —— 尽管它并不总是可靠的 —— 告诉我，这事可能出了些问题。
```
</details>


<!-- details begin -->
<details>
<summary>11. 连接号</summary>

- 连接号用于连接两个类似的词，以下场合应该使用直线连接号（`-`），占一个半角字符的位置。

（1）两个名词的复合  
（2）图表编号

```
例句：氧化-还原反应
例句：图 1-1
```

（3）数值范围（例如日期、时间或数字）应该使用波浪连接号（`～`）或一字号（`—`），占一个全角字符的位置，且连接号前后建议加上单位。

```
例句：2009年 ～ 2024年 
例句：2009年 — 2024年
```

（4）波浪连接号也可以用汉字“至”代替。

```
例句：周围温度：-20 °C 至 -10 °C
```
</details>

## 其它

### 系列大纲

系列大纲/概要的内容需简洁明了，建议采用下面的结构：



### 产品介绍文档

产品软件介绍文档应有简洁而丰富的内容，建议采用下面的结构。

- **简介**（Introduction）：[**必备**] [文件] 提供对产品和文档本身的总体的、扼要的说明
- **快速上手**（Getting Started）：[可选] [文件] 如何最快速地使用产品
- **入门篇**（Basics）：[**必备**] [目录] 又称“使用篇”，提供初级的使用教程
  - **环境准备**（Prerequisite）：[**必备**] [文件] 软件使用需要满足的前置条件
  - **安装**（Installation）：[可选] [文件] 软件的安装方法
  - **设置**（Configuration）：[**必备**] [文件] 软件的设置
- **进阶篇**（Advanced)：[可选] [目录] 又称“开发篇”，提供中高级的开发教程
- **API**（Reference）：[可选] [目录|文件] 软件 API 的逐一介绍
- **FAQ**：[可选] [文件] 常见问题解答
- **附录**（Appendix）：[可选] [目录] 不属于教程本身、但对阅读教程有帮助的内容
  - **Glossary**：[可选] [文件] 名词解释
  - **Recipes**：[可选] [文件] 最佳实践
  - **Troubleshooting**：[可选] [文件] 故障处理
  - **ChangeLog**：[可选] [文件] 版本说明
  - **Feedback**：[可选] [文件] 反馈方式

下面是两个真实范例，可参考。

- [Redux 手册](https://redux.js.org/introduction/getting-started)
- [Atom 手册](http://flight-manual.atom.io/)
