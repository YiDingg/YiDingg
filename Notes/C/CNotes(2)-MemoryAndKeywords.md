# C Notes (2): Memory and Keywords

> [!Note|style:callout|label:Infor]
Initially published at 12:31 on 2024-08-06 in Lincang.


## 关键字

在C语言中有许多关键字(keywords，也称保留字)，常见的如 static,  const, volatile, extern, sizeof 等。由ANSI(C89)标准定义的C语言关键字共32个（ long long 类型归为long关键字），由下表列出。 

```c
/* 基本数据类型 */
void, char, short, int, long, long long, float, double
signed, unsigned

/* 构造数据类型 */ 
struct, union, enum, typedef

/* 数据存储类别 */
static, extern, register, auto

/* 数据优化 */ 
const, volatile

/* 九条基本逻辑语句 */ 
if, else, switch, case, default, break, while, do, for, return, continue, goto

/* 其它 */ 
sizeof
```

需要注意：
- signed, unsigned 单独使用时，默认为 signed int 和 unsigned int
- 基本数据类型所占字节与编译器位数有关（常见的有8、16、32、64位编译器）


## 内存分配

C语言程序运行期间，内存会被分为多个区块，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-02-01-05-37_C语言笔记 (2)：内存与关键字_.png"/></div>

下面是它们的具体性质：

<div class='center'>

| 区块 | 存放内容 | 生命周期 | 作用域 | 自动 or 手动 | 内存性质 |
| :------: | :------: | :------: | :------: | :------: | :------: |
| 栈区 | 局部变量 <br>函数入口参数、形参、返回值 | 局部 | 局部 | 自动 | RAM |
| 堆区 | 任意 | 任意 | 全局 | 手动 | RAM |
| 静态区 | 未初始化的全局、静态变量（.BSS段） <br>已初始化的全局、静态变量（.DATA段）| 全局 | 全局（全局变量） <br>本部（静态变量） | 自动 | RAM |
| 常量区 | 字符串、数字常量 <br>const修饰的全局（静态）变量 | 全局 | 全局 | 自动 | ROM |
| 代码区 | 程序代码  | 全局 | 全局 | 自动 | ROM |
</div>

## 关键字：
了解了内存的具体分配后，我们可以进一步学习关键字的作用。

一些最常见也是最简单的关键字（如基本数据类型、基本逻辑语句等）我们不再赘述，下面讲解几种需要进一步辨析的关键字。


### 1. static
`static` 关键字用于将变量存储到静态区，此时变量的生命周期变为全局，作用域为本部（当前文件）。这样，仅当前文件可访问此变量，其它文件中无法直接访问（无论是 #include 还是 extern）。

但我们可以通过指针，间接的访问其它文件中的static变量，例如：

``` c
/* menu.c文件 */
static int a = 88;
int *p = &a

/* main.c文件 */
extern int *p;
printf("a的值是：%d", *p);

/* 输出结果 */ 
/* 
a的值是：88
*/
```

### 2. sizeof

`sizeof`是一个非常特殊的关键字，它的用法更像函数：输入一个变量，返回变量所占的字节数。
例如，在32位系统中，指针大小为四个字节（32-bit），double 类型大小为8字节，则：
``` c
int main(){
	double x = 1.02364;
	double* p = &x;
	printf("变量x占字节大小：%d\n", sizeof(x))；
	printf("指针p占字节大小：%d\n", sizeof(p))；
	return 0;
}

/* 输出结果 */ 
/* 
变量x占字节大小：8
指针p占字节大小：4
*/
```

比较特殊的是数组的大小，这是因为数组名作为参量传入函数时，数组名会退化为指针。
数组名未退化时，sizeof 会返回数组的总大小。还是以32位系统为例，对数组 double array[100]，sizeof(array) 会返回 $100\times8 = 800$。当数组名退化时，sizeof(array) 会返回4，也就是指针的大小。
当我们需要获取一个数组的元素个数时，如果它未退化，则表达式 `sizeof(array)/sizeof(array[0])` 的结果便是数组元素个数。

### 3. extern

`extern` 用于告诉编译器到其他文件中寻找此变量或函数的定义，前提是此变量或函数具有全局作用域（如全局变量，静态变量和静态函数都不可以）。
一般来讲，我们会在下面两种情况下使用到extern关键字（以main.c和example.c为例）：
1. 在example.c中，我们定义了一个全局变量 int var = 10; 且在example.h 中并!!#ff0000 没有声明!!它。此时，如果要在main.c中使用此变量，无论我们是否 #include example.h，都需要在第一次使用var之前先使用extern关键字进行声明 `extern int var;`。此后，main.c文件中便可以访问变量var。
2. 在example.c中， 我们定义了一个全局变量 int var = 10; 且在example.h 中!!#ff0000 声明了!!它，但main.c中!!#ff0000 没有 #include !!example.h。那么同样的，需要先用extern关键字声明此变量 `extern int var;`，此后，main.c文件中便可以访问变量var。

### 4. const
`const` 关键字将变量提升为常量，告知CPU此变量的值在整个程序中都不变，以避免无意或意外使得此变量的值发生改变。
被const修饰的变量都会存储到常量区（ROM）。

### 5. valatile
`valatile` 表明变量随时可能改变，告知CPU此变量的值可能随时会被更改（即提醒CPU每次都必须到内存中取出变量当前的值而不是取cache或者寄存器中的备份），包括受硬件直接更改、在多线程任务中被其它线程修改（共享内存段）等。
用 valatile 关键字声明后，编译器不会对其相关语句进行优化，并且每次使用变量值时，都会到内存中去取值，以保证取到最新值。

### 6. register
`register` 关键字用于修饰变量存储类型，告知CPU尽可能将变量放到寄存器中，从而提高操作效率。例如在长循环中，需要对某变量频繁操作，可以考虑用 register 进行修饰。
有几个注意事项：
- 仅可用于局部变量、函数形参
- 不能大量使用，因为寄存器数量有限
- 寄存器变量不能取地址，因为寄存器中没有地址的概念。
- register 变量必须是能被 CPU 所接受的类型。这意味着 register 变量长度应该小于或等于寄存器长度。

## 基本数据类型大小
在不同位数的系统中，基本数据类型大小不尽相同，最典型的例子即为指针的大小，因为它与寻址空间大小有关。
下表列出了常见系统中各基本数据类型的大小（单位Byte）：

<div class='center'>

|数据类型|16位|32位|64位|
|:-:|:-:|:-:|:-:|
|指针|2|4|8|
|char|1|1|1|
|short |2|2|2|
|int|2|4|4|
|long|4|4|8|
|long long|8|8|8|
|float|4|4|4|
|double|8|8|8|

</div>

