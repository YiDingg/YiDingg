## 前言

本节目标：学习 printf() 函数的使用，并了解其底层实现原理

> 系列汇总详见地址：[《📕C语言系列汇总》](Blogs\C\C语言系列汇总.md) 


## 格式限定符重定义
原有的格式限定符（也称占位符、说明符，specifier）并没有完全按照基本数据类型来写，在 printf() 函数使用频繁的场合，我们可以利用宏重定义占位符，以提高开发效率。如下所示：

``` c
#define _int 		d    // int
#define _uint 		u    // unsigned int 
#define _uint_hex   x   // unsigned int (十六进制，x对应abcd，无前导0x)
#define _uint_HEX   X   // unsigned int (十六进制，X对应ABCD，无前导0X)
#define _doub 	f   // double (默认六位小数)
#define _doub_e 	e   // double (十六进制，默认六位小数，e代表输出时'e'用小写)
#define _doub_E	E   // double (十六进制，默认六位小数，E代表输出时'E'用大写)
#define _char 		c   // char (以ASCII码字符输出)
#define _str 	s   // char* (严格地说是字符串类型，直到遇到空字符'\0'才停止输出)
#define _pointer	p   // void* (十六进制，输出指针值)
#define _num 		n   // int* (此字符之前一共输出的字符个数，不输出文本) 
```
注：printf() 函数是从右往左开始处理数据的，是因为函数需要从右到左压栈，将先读取放到栈底，后读取的放在栈顶，这样处理时候是从栈顶开始的。

## 输出格式

printf() 函数的输出格式为 `printf("%[symbol][minwidth][.accuracy][length] {type}", ...)` ，其中 "[]" 为可选参数，"{}" 为必需参数。各参数含义如下表：

<div class='center'>

|Parameter|Details|Example|
|:-:|:-|:-:|
| [symbol] | one of the symbols { '-', '+', ' ', '#', '0'}, here are the details: <br>`-`: left align, space ' ' will be added if the output length shorter than [minwidth]<br>`+`(defults): right align, space ' ' will be added if the output length shorter than [minwidth]<br>` `: <br>`#`: <br>`0`: |  |
| [minwidth] |  |  |
| [.accuracy] |  |  |
| [length] |  |  |
|{type}  |  |  |

</div>





## 参考文章
[printf() 输出格式](https://blog.csdn.net/lnfiniteloop/article/details/123131946)