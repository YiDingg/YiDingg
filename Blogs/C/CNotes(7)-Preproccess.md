# C Notes (7): Preproccess

## Intro 

C 语言编译器在编译之前，会先预处理代码（preproccess）。这包括清理无用代码、删除注释、多行语句合并为一个逻辑行等工作，然后执行`#`开头的预处理指令。

预处理指令（后文简称“预指令”）可以出现在程序的任何地方，但是习惯上，往往放在代码的开头部分。所有预处理指令都是一行的，除非在行尾使用反斜杠，将其折行。指令结尾处不需要分号。



## macro (宏)

### #define

`#define`是最常见的预指令，起字符串的替换作用（直接替换），这些替换规则称为“宏”，因此也称为“宏定义”。

### 带参数的宏

宏名称后面可以使用括号，指定接受一个或多个参数。要注意，由于宏进行的是字符串直接替换，因此右侧的表达式须有必要的括号，以避免意外结果。一般用法如下：

``` c
#define IS_EVEN(n) ((n)%2==0)       /* 接收一个参数 */
#define MAX(x, y) ((x)>(y)?(x):(y)) /* 接收两个参数 */

/* 利用反斜杠 `\` 进行折行 */
#define PRINT_NUMS_TO_PRODUCT(a, b) { \
  int product = (a) * (b); \
  for (int i = 0; i < product; i++) { \
    printf("%d\n", i); \
  } \
}

/* 宏可以嵌套，也可以对应多个右值 */
#define QUADP(a, b, c) ((-(b) + sqrt((b) * (b) - 4 * (a) * (c))) / (2 * (a)))
#define QUADM(a, b, c) ((-(b) - sqrt((b) * (b) - 4 * (a) * (c))) / (2 * (a)))
#define QUAD(a, b, c) QUADP(a, b, c), QUADM(a, b, c)
```

### `#`和`##`运算符

`#`运算符将右值替换为字符串，这是为了解决宏定义字符串的问题。

``` c
#define Test_1(x) "hello!""x"
#define Test_2(x) "hello!"#x

printf("Test_1: %s\n", Test_1(3.14159)); // hello!x
printf("Test_2: %s\n", Test_2(3.14159)); // hello!3.14159
```

`##`运算符 attach 右值 to 左值，即“粘合”在一起。它一个用途是批量生成变量名和标识符。

``` c
#define MK_ID(n) i##n
int MK_ID(1), MK_ID(2), MK_ID(3);
// 替换为：
// int i1, i2, i3;
```

### 不定参数宏

宏的参数数量可以是不定的，在末尾用`...`表示剩余的参数。

``` c
#define X(a, b, ...) (10*(a) + 20*(b)), __VA_ARGS__
X(5, 4, 3.14, "Hi!", 12)
// 替换成
// (10*(5) + 20*(4)), 3.14, "Hi!", 12
```

类似地，在`__VA_ARGS__`前面加上一个`#`号，可以让输出转成字符串。

``` c
#define X(...) #__VA_ARGS__
printf("%s\n", X(1,hello !,3));  // 1, hello !, 3
printf("%s\n", X(1,"hello! ",3));  // 1, "hello! ", 3
```

### `#undef`

`#undef`用来取消宏定义。有时候想重新定义一个宏，但不确定是否以前定义过，就可以先用`#undef`取消，然后再定义。因为同名的宏如果两次定义不一致，会报错，而`#undef`的宏如果不存在，并不会报错。

``` c
#define PI 3.14159
#undef PI
```

### `#include`

`#include`用于引入文件，有两种形式（尖括号和双引号）。尖括号：表示文件由系统提供，通常是标准库文件，不需要写路径（编译器会到系统指定安装目录寻找）。双引号：表示文件由用户提供，如果文件在其他位置，就需要指定路径。

``` c
// 尖括号：引入系统提供的文件
#include <foo.h> 

// 双引号：引入用户提供的文件
#include "foo.h" 
#include "/usr/local/lib/foo.h"
```

### `#if`、`defined`、`#ifdef`、`#ifndef`

最常用的是`.h`头文件中定义文件引入宏，宏名称为文件名附上左右下划线。

``` c
/* MuMeStar.h */
#ifndef _MUMESTAR_H_
  #define _MUMESTAR_H_
  /* do something */
#endif
```


一些暂时无用，但不需要删除、留着有用的代码，可以用`#if 0`和`#endif`将其注释掉。

``` c
#if 0
  const double pi = 3.1415; // 不会执行
#endif
```

`#if`可以直接判断宏，没有定义过的宏等价于`0`，也可以配合`defined`判断是否定义过某个宏；`#ifdef`等价于`#if defined()`，`#ifndef`等价于`#if !defined()`。它们都可以和`#elif`、`#else`配合使用，下面是一个例子。

``` c
#if defined IBMPC
  #include "ibmpc.h"
#elif defined MAC
  #include "mac.h"
#else
  #include "general.h"
#endif
```


### 预定义宏

C语言提供了一些预定义宏，可以直接使用（即使没有引入任何头文件）。

- `__DATE__`：编译日期，格式为“Mmm dd yyyy”的字符串（比如 Nov 23 2021）。
- `__TIME__`：编译时间，格式为“hh:mm:ss”。
- `__FILE__`：当前文件名。
- `__LINE__`：当前行号。
- `__func__`：当前正在执行的函数名。该预定义宏必须在函数作用域使用。
- `__STDC__`：如果被设为1，表示当前编译器遵循 C 标准。
- `__STDC_HOSTED__`：如果被设为1，表示当前编译器可以提供完整的标准库；否则被设为0（嵌入式系统的标准库常常是不完整的）。
- `__STDC_VERSION__`：编译所使用的 C 语言版本，是一个格式为`yyyymmL`的长整数，C99 版本为“199901L”，C11 版本为“201112L”，C17 版本为“201710L”。

下面示例打印这些预定义宏的值。

```c
#include <stdio.h>

int main(void) {
  printf("This function: %s\n", __func__);
  printf("This file: %s\n", __FILE__);
  printf("This line: %d\n", __LINE__);
  printf("Compiled on: %s %s\n", __DATE__, __TIME__);
  printf("C Version: %ld\n", __STDC_VERSION__);
}

/* 输出如下：
This function: main
This file: C:\Users\13081\Desktop\Test_Cmake\src\main.c
This line: 50
Compiled on: Jul 17 2024 18:35:08
C Version: 201710
*/
```

## 其它宏

### `#line`

`#line`用于更改预定义宏`__LINE__`的值，后面第一行则为新行号。`#line`还可以更改预定义宏`__FILE__`，将其改为自定义文件名。

```c
#line 300 "newfilename"
/* 
下一行的行号更改为 300
文件名更改为 newfilename 
*/
```

### `#error`

`#error`指令用于抛出错误并终止编译，同时，输出定义好的错误信息。

```c
#if __STDC_VERSION__ != 201112L
    #error Not C11
#endif
```

上面示例指定，如果编译器不使用 C11 标准，就中止编译。MinGW (gcc) 编译器会像下面这样报错。

``` bash
[build] C:\Users\13081\Desktop\Test_Cmake\src\main.c: In function 'main':
[build] C:\Users\13081\Desktop\Test_Cmake\src\main.c:54:2: error: #error Not C11
[build]  #error Not C11
[build]   ^~~~~
```


