# C Notes(8): I/O Functions

## Intro 

I/O 指 Input/Output。

严格来讲，I/O 函数并不是直接与外部设备通信，而是通过 buffer （缓存）间接通信（与嵌入式中的通信类似）。程序读取/发送数据时，都是将与缓存进行交互，由于缓存读完就被弃用或覆盖了，所以只能读取一次。这个过程就称为字节流操作。

C 语言的标准 I/O 函数，基本都在文件`stdio.h`中。并且，凡是涉及读写文件/设备的，都属于字节流操作。

## `printf()`和`scanf()`

### `printf()`

`printf()` 函数的基本用法在 [C Notes(1): Before Starting](Blogs/C/CNotes(1)-BeforeStarting.md) 已经讲过，更详细用法及其底层原理，我们会单独列一篇来介绍，这里略过。

### `scanf()`

`scanf()` 函数用于读取格式化输入，可以从标准输入（键盘）读取各种类型的数据，用法类似`printf()`，但占位符标识有所不同。

``` c
/* 原型, <stdio.h> */
int scanf( const char *format, ... );
/* 返回值是 int 型，表示成功读取的变量个数
如果没有读取任何项，或者匹配失败，则返回 0
如果读取到文件结尾，则返回常量 EOF（通常是 -1） */
```

`scanf()`读取输入的流程是：先将输入放入缓存，当按下回车键时，依照占位符解读数据，然后在此位置继续等待，直至结束。解读数据时，会从前一次的位置继续读取，直到读完缓存，<span style='color:red'>或者遇到第一个不符合条件的字符为止</span>。

标红的这句话需要特别注意，因为这可能导致用户输入本意与数据解读不一致，例如：

``` c
int x;
float y;

// 用户输入 "-13.45e12"
scanf("%d", &x);
scanf("%f", &y);

// 用户输入 "-13.45e12"
scanf("%d %f", &x, &y);
```

在上面的例子，解读结果都为`x = -13`而`y = 0.45e12`。这是因为`.`不属于整数的有效字符，占位符`%d`读取到`-13`，而`%f`读取到`.45e12`。

另外，`scanf()`处理占位符时，会自动过滤空白字符（空格、制表符、换行符等）。所以，输入多个数据时，数据之间的空格、换行等都不会影响读取结果。

### `scanf()`占位符

`scanf()`常用占位符如下：

- `%c`: char
- `%d`：整数，包括 char, short int, int ,long int 等
- `%f`：float
- `%lf`：double
- `%Lf`：long double
- `%s`：字符串
- `%[]`：指定匹配字符

上面所有占位符之中，除了`%c`外，都会自动忽略起首的空白字符。若要跳过`%c`前的空白字符，使用`scanf(" %c", &ch)`即可。

这里要提一下`%s`，它其实不能简单地等同于字符串。`%s`从当前第一个非空白字符读起，直至遇到下一个空白字符结束读取，并在末尾添加停止符`\0`。也就是说，`%s`的读取结果不包含空白字符，因此无法读取由空白字符分隔的多个单词。因此，`%s`不适合读取可能包含空格的字符串，比如书名或歌曲名。

注意：`scanf()`读取字符串时，不会检查是否超出数组长度，因此在使用`%s`时，建议写成`%{max}s`的形式，其中`{max}`为最大字符串长度（实际长度，与`strlen()`的结果相同，不包括停止符）。

``` c
char name[11];
scanf("%10s", name);
```

### 忽略符`*`

`*`, assignment suppression character，称为赋值忽略符。只要把`*`加在任意占位符的百分号后，该占位符的读取结果就会被忽略。

``` c
scanf("%d%*c%d%*c%d", &year, &month, &day);
```


### 占位符`%[]`

``` c
char str[50];

scanf("%[abc]",str);        // a、b、c才有效
scanf("%[1-6]",str);        // 1-6之间的有效
scanf("%[a-z]",str);        // a-z之间的有效
scanf("%[1-9a-z]",str);     // 1-9和a-z之间的有效
scanf("%[^123]",str);       // 123之外的有效（空格也有有效不会间断）
scanf("%[^1-9a-z]",str);    // 1-9和a-z之外的有效
scanf("%*[1-9]",str);       // *无效化   跳过开头的1-9读取后面的内容
scanf("%[^#]#",str);        // 匹配所有字符，直到遇到#，指针指向字符#,然后再忽略掉字符#，指针指向字符T（输出结果为其中所有的英文单词）
scanf("%[^xxx]xxx",str);        // 匹配字符串直到空白符，然后跳过空白符
```

下面是一个典型的例子，读者可以尝试找出两种情况的不同，并解释产生不同输出的原因：

``` c
/* 第一种情况 */
#include <stdio.h>

int main(void) {
    char str[1];
    scanf("%[1-6]%[1-6]%[1-6]", str);
    puts("result:");
    puts(str);
    for (char i = 0; i < 5; i++) {
        printf("location: %d, result: %d\n", i, *(str + i));
    }
    return 0;
}

/* 
用户输入：
123456 

输出：
result:
123456
location: 0, result: 49
location: 1, result: 1
location: 2, result: 51
location: 3, result: 52
location: 4, result: 53
*/
```

``` c
/* 第二种情况 */
#include <stdio.h>

int main(void) {
    char str[1];
    scanf("%[1-6]%[1-6]%[1-6]", str);
    puts("result:");
    puts(str);
    for (int i = 0; i < 5; i++) {
        printf("location: %d, result: %d\n", i, *(str + i));
    }
    return 0;
}

/* 
用户输入：
123456 

输出：
result:
123456
location: 0, result: 49
location: 1, result: 1
location: 2, result: 0
location: 3, result: 0
location: 4, result: 0
*/
```

## `sscanf()`

## `getchar()`和`putchar()`
