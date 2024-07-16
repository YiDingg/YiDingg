# C Notes(4): Array and String (数组)

## 数组

### 简介

- 仅在定义数组可以使用花括号，已定义的数组无法用花括号进行赋值。
- C99之后可以指定初始化（designated initializer）某个元素，例如下面的例子

```c 
int arr[100] = {1, [33]33, 99, 88, [99]5}; 
/* 效果: arr[0] = 1, arr[33] = 33, arr[34] = 99, arr[35] = 88, arr[99] = 5 */

int arr2[100] = {1, [30]2, [10]3, [15]4}; /* 指定位置的赋值可以不按照顺序 */
/* 效果: arr2[0] = 1, arr2[30] = 2, arr2[10] = 3, arr2[15] = 4 */

int arr[] = {2, [10]88}; 
/* 效果: sizeof(arr)/sizeof(arr[0]) = 11, arr[0] = 2, arr[10] = 88 */
```

注意，`sizeof(a)`和`sizeof(a)/sizeof(a[0])`的数据类型都是`size_t`，在printf()里面的占位符，要用`%zd`或`%zu`。

### 变长数组

C99加入了变长数组，这里的“变”是指可以使用变量定义数组的大小，而不是改变已有数组的大小。

### 作为函数参数

数组作为函数的参数，一般会同时传入数组名和数组长度，例如：

```c
example_1(int arr[], unsigned int lenth){
    // do something
} 

example_2(int arr[], size_t sizeofarr, size_t sizeofarr_0){
    unsigned int lenth = (unsigned int) sizeofarr/sizeofarr_0;
    // do something
} 

int a[] = {3, 5, 7, 3};
int sum = example_1(a, 4);
int sum = example_2(a, sizeof(a), sizeof(a[0]));
```

显然第二种方法更有效，因为无需人工判断数组长度（易出错）

### 字符数组

在C语言，双引号之中的字符，会被自动视为（含有停止符的）字符数组。这意味着，对于已定义的字符数组，不可以用等号把字符串赋值给数组（在声明时可以），因为这相当于用等号把一个数组赋值给另一个数组。所以，如果要把字符串赋值给字符数组，就需要用到`strcpy()`函数。

## 字符串

### 简介

- C语言不存在单独的字符串类型，字符串被当作`char`数组来处理。例如`"Hello"`实际上是`{'H', 'e', 'l', 'l', 'o', '\0'}`，其中`\0`是ASCII码为`0x00`的停止符（8-bit都为0的一字节）。
- 如果字符串内部包含双引号，则该双引号需要使用反斜杠转义。
- C 语言允许合并多个字符串字面量，例如下面三个等价语句：

```c
char greeting[50] = "Hello, how are you today!";
char greeting[50] = "Hello, ""how are you ""today!";
char greeting[50] = "Hello, "
  "how are you "
  "today!"; 
```

### 相关函数

下面的函数都在`string.h`头文件。

<!-- details begin -->
<details>
<summary>1. strlen()</summary>

原型：`size_t strlen(const char* s);`  
返回字符串的字节长度，且不包括末尾的空字符`\0`。

注意，字符串长度`strlen()`与字符串变量长度`sizeof()`，是两个不同的概念。

```c
char s[50] = "hello";
printf("%d\n", strlen(s));  // 5
printf("%d\n", sizeof(s));  // 50 
```

</details>

<!-- details begin -->
<details>
<summary>2. strcpy(), strncpy()</summary>

strcpy(): `char* strcpy( char* dest, const char* src );`  
strncpy(): `char* strncpy( char* dest, const char* src, size_t count );`  
示例：

```c
char str[10];
strcpy(str, "abcd"); 

char str1[10];
char str2[10];
strcpy(str1, strcpy(str2, "abcd"));

```
</details>
<!-- details begin -->
<details>
<summary>3. strcat(), strncat()</summary>

strcat(): `char* strcat(char* s1, const char* s2);`  
strncat(): `char* strncat(const char* dest,const char* src,size_t n);`  
一般写作：

```c
strncat(str1, str2, sizeof(str1) - strlen(str1) - 1); 
/* -1 是为了留出最后的空字符 */
```
</details>
<!-- details begin -->
<details>
<summary>4. strcmp(), strncmp()</summary>

strcmp(): `int strcmp(const char* s1, const char* s2);`  
strncmp(): `int strncmp( const char* lhs, const char* rhs, size_t count );`  
依据字典序给出比较结果，return positive if $s_1 > s_2$。
</details>
<!-- details begin -->
<details>
<summary>5. sprintf(), snprintf()</summary>

sprintf(): `int sprintf( char* buffer, const char* format, ... );`
snprintf(): `int snprintf( char* buffer, size_t size, const char* format, ... );`

用于将数据写入字符串，而不是输出到显示器，用法与`printf()`类似。返回值是写入变量的字符串实际长度（不计尾部空字符`\0`），如果遇到错误，返回负值。`snprintf()`控制写入变量的字符串不超过 n - 1 个字符，剩下一个位置写入空字符`\0`。
</details>
