# MCU Notes (!): Tips and Tricks (STM32)

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 19:46 on 2024-06-27 in Beijing.


序号 `(!)` 表明此章节为补充章节，独立于主干内容之外。

## 前言

本节目标：总结STM32开发过程中的实用技巧，以提高学习和开发效率

>系列汇总详见地址：[《📕STM32系列汇总》 ](Blogs\STM32\STM32系列汇总.md) 

## printf() 重定向

在 Keil 中重定向`printf` 有两种方式，一种使用微库 MicroLIB，另一种需要定义 `fputc()` 函数。为避免使用微库 MicroLIB 导致的操作系统或规则标准问题（详见 [here](https://blog.csdn.net/sarsscofy/article/details/122395372)，可能会导致 Keil Debug 卡死），我们采用第二种方式。

下面我们利用 CubeMX 配置串口，并将 `printf` 重定向到 `USART` 输出，以便在 PC 端查看串口输出。

依次配置 ，并设置波特率为 115200。

``` CubeMX 配置串口
SYS --> Debug --> Serial Wire
RCC --> HSE --> Crystal/Ceramic Resonator
Clock --> 72MHz
USART1 --> Asynchronous (异步)
其它默认即可，再配置 Project Manager 并 Generate Code。
```

在生成的 `uart.c` 文件中添加以下代码：

``` c
/* 在生成的 uart.c 文件中添加以下代码： */

/* ------------------------------- */
/* -------- printf 重定向 -------- */
/* 支持 printf() 且不需要勾选 Use MicroLIB */
#include <stdio.h>
#if 1
#pragma import(__use_no_semihosting) // 标准库需要的支持函数
struct __FILE {
    int handle;
};
FILE __stdout;
/* 定义 _sys_exit() 以避免使用半主机模式   */
void _sys_exit(int x) {
    x = x;
}
/* 如果配置的是 USART1，则无需修改，否则修改 USART1 */
int fputc(int ch, FILE* f) {
    while ((USART1->SR & 0X40) == 0); // 循环发送,直到发送完毕
    USART1->DR = (uint8_t)ch;
    return ch;
}
#endif
/* -------- printf 重定向 -------- */
/* ------------------------------- */
```

在生成的 `main.h` 文件中添加以下代码：

``` c
/* 在生成的 main.h 文件中添加以下代码： */

#include <stdio.h>  // printf 重定向
```

即可完成 `printf()` 函数的配置，到 `main.c` 的 `/* USER CODE END WHILE */` 前添加以下代码（要放在 `while(1)` 中），并编译、烧录以测试是否成功：

``` c
printf("hello!");
HAL_Delay(999); // 精确延时 1000 ms
HAL_GPIO_TogglePin(GPIOC, GPIO_PIN_13);
```

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-13-14-10-14_MCUNotes(!)-TipsAndTricks(STM32).png"/></div>

## string.h 中的实用函数
C语言中有一些直接面向内存的函数，它们可以对内存块进行高效而快速的操作，如赋值、复制、移动、查找等。
下面是 string.h 文件中的部分内存操作函数：

- memset()：赋值<br>  
    - 原型：`void* memset(void* ptr, int value, size_t num);`  
    - 详解：将一块内存区域的内容设置为指定的值。ptr 为（起始）目标地址，value 为要赋的值，num 为要赋值的字节数。
- memcpy()：复制  
    - 原型：`void* memcpy(void* dest, const void* source, size_t num);`  
    - 详解：将一块内存区域的内容复制到另一块内存区域。dest 为目标地址，source 为源地址（要被复制的内容），num 为要复制的字节数。  
- memmove()：移动  
    - 原型：`void* memmove(void* dest, const void* source, size_t num)`  
    - 详解：将一块内存区域的内容移动到另一块内存区域，且不必理会内存区域是否重叠。dest 为目标地址，source 为源地址（要被复制的内容），num 为要移动的字节数。  
    - 注：此函数可视为memcpy函数的安全版。事实上，将此函数理解为 “覆盖” 或许更准确，因为它保证了被移动数据的完整性，而覆盖了dest地址上的原数据（即使起始区域与目标区域有    重合）。  
- memchr()：查找  
    - 原型：`void* memchr(const void* ptr, int value, size_t num);`  
    - 详解：在一块内存区域中查找指定字符。dest 为目标地址，source 为源地址（要被复制的内容），num 为要查找的字节数。  
- memcmp()：比较  
    - 原型：`int memcmp(const void* ptr1, const void* ptr2, size_t num);`  
    - 详解： 比较两块内存区域的内容。ptr1 为第一个内存地址，ptr2 为第二个内存地址，num 为要比较的字节数。如果两个内存区域的内容相等，则返回0；如果不相等，则返回第一个不相等字  节的- 差值。  
- strlen()：字符串长度  
    - 原型：`size_t strlen(const char* str)`  
    - 详解：返回字符串的长度，单位byte，不包括字符串末尾的结束符  


以memset()为例，当我们控制OLED屏时使用了软件显存时（常作为二维数组存在，例如OLED_GRAMBuffer[8][128]），在绘制下一帧之前，我们常常需要清除软件显存。此时，若使用二重循环进行显存清除，则会十分低效。相反，使用memset()函数则能够快速的完成 $8*128=1024$ 字节的填充，起到快速清除显存的效果。  
在Keil中，利用仿真可以看到，二重循环需要约 $0.02502014   -   0.02463104 = 0.0003891\  \mathrm{s} = 389.1\  \mathrm{us}$ 才能完成，而memset()仅需 $0.52642908 - 0.52642190 = 0.00000718\  \mathrm{s} = 7.18\  \mathrm{us}$ 。如下图所示：

<div class='center'> 

|  操作  | 前 | 后 |  OLED帧率 |
| :------: | :------------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------------: |
 | 二重循环 | <img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (4)：实用技巧汇总--2024-06-23-00-31-16.png"/> | <img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (4)：实用技巧汇总--2024-06-23-00-31-23.png"/> | <img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (4)：实用技巧汇总--2024-06-23-00-31-28.png"/> |
 | memset() | <img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (4)：实用技巧汇总--2024-06-23-00-31-31.png"/> | <img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (4)：实用技巧汇总--2024-06-23-00-31-35.png"/> | <img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (4)：实用技巧汇总--2024-06-23-00-31-39.png"/> |
</div>


## 精确延时 1000 ms 

受 HAL 库中断架构的影响，`HAL_Delay(999)`（如图）比 `HAL_Delay(1000)` 更接近 $1000 \ \mathrm{ms}$ 的延时。


<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/PicGo/202408131345372.png" alt="202408131345372.png">

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-13-13-49-11_HDofDF.png"/></div>




