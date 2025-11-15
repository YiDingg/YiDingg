# C Notes (6): Special Data Types

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 22:23 on 2024-08-07 in Lincang.


## struct

### Intro

`struct`主要用于下面两种情况：
- 复杂的物体需要使用多个变量描述，这些变量都是相关的。
- 某函数需要传入多个参数，将其组合成一个复合结构传入。

`struct`变量在声明时，也可以使用 designated initializer（初始化器，即指定初始化），也可以在声明结构体的同时创建结构体变量，并为它们赋值。
```c
/* 创建结构体后，使用 designated initializer */
struct car {
  char* name;
  float price;
  int speed;
};
struct car saturn = {.speed=172, .name="Saturn SL/2"}; 

/* 创建匿名结构体，同时声明、初始化变量 */
struct {
  char title[500];
  char author[100];
  float value;
} b1 = {"Harry Potter", "J. K. Rowling", 10.0},
  b2 = {.title="title", .author="Aleksandr Solzhenitsyn"};/* 未初始化 b2.value  */

/* 利用typedef创建类型别名 */
typedef struct cell_phone {
  int cell_no;
  float minutes_of_charge;
} phone;

phone p = {5551234, 5};
```

struct 结构占用的存储空间，不是各个属性存储空间的总和，而是最大内存占用属性的存储空间的倍数，其他属性会添加空位与之对齐。这样可以提高读写效率。

```c
struct foo {
  int a;    /* 4 bytes */
  char* b;  /* 8 bytes (64-bit machine) */
  char c;   /* 1 byte */
};
printf("%d\n", sizeof(struct foo)); // 24 

/* 在内存中的实际结构 */
struct foo {
  int a;        // 4
  char pad1[4]; // 填充4字节
  char *b;      // 8
  char c;       // 1
  char pad2[7]; // 填充7字节
};
printf("%d\n", sizeof(struct foo)); // 24

```

这也就是说，在定义 Struct 结构体时，可以根据类型大小递增顺序，依次定义每个属性，这样也许就能节省一些空间。

```c
/* 按类型大小递增定义 */
struct foo {
  char c;     /* 1 byte */
  int a;      /* 4 bytes */
  char* b;    /* 8 bytes (64-bit machine) */
};
printf("%d\n", sizeof(struct foo)); // 16
```

### 复制 struct

不同于数组，struct 变量可以使用`=`进行变量整体赋值，但不能用比较运算符（`==`、`!=`）比较两个结构体是否相等。
```c
struct cat { char name[30]; short age; } a, b;

strcpy(a.name, "Hula");
a.age = 3; 
```

### 作为函数参数

需要注意，结构体变量作为函数参数被传入时，函数中操作的是结构体变量的副本（因为将结构体变量复制给了函数形参），有时会导致函数不能直接操作原结构体，因此一般情况下，我们都传入结构体变量的指针。
```c
#include <stdio.h>
struct turtle {
  char* name;
  char* species;
  int age;
};
void happy(struct turtle t) {
  t.age = t.age + 1;
}

int main() {
  struct turtle myTurtle = {"MyTurtle", "sea turtle", 99};
  happy(myTurtle);
  printf("Age is %i\n", myTurtle.age); // 输出 99 而不是 100，因为函数操作的是副本
  return 0;
} 
```

### bit field (位字段)

struct 可以定义由二进制位组成的数据结构，称为“位字段”（bit field），C99引入的`_Bool`类型也是一种位字段。注意，位字段变量类型必须是整数类型，即`char`、`int`、`unsigned int`等。

```c
struct {
/* {位字段数据类型} {变量名} : {所占bit位数} ; */
    unsigned int     ab    :     1        ;
    unsigned int     cd    :     1        ;
    unsigned int     ef    :     1        ;
    unsigned int     gh    :     1        ;
} synth;

synth.ab = 0;
synth.cd = 1; 


```

上面的例子中，synth 位字段占 4-bit，在同一字节中。这也意味着，`$ab`、`&cd`、`&ef`、`&gh`四个变量的地址很可能是相同的。另外，我们也可以利用“未命名位变量”或“0宽位变量”，手动调整位变量在内存中的字节位置。

```c 
struct {
  unsigned int field1 : 1;
  unsigned int        : 2;
  unsigned int field2 : 1;
  unsigned int        : 0;
  unsigned int field3 : 1;
} stuff;

/* stuff.field1 与 stuff.field2 之间，有一个宽度 2-bit 的未命名属性 */
/* 0 宽位变量表示占满当前字节剩余的二进制位，stuff.field3 将存储在下一个字节 */
```

### 弹性数组

struct结合malloc可以实现弹性数组，即大小可变的“数组”，一般用法如下：

``` c
struct vstring {
  int len;
  /* other properties */
  char chars[];
};

struct vstring* str = malloc(sizeof(struct vstring) + n * sizeof(char));
str->len = n;

/* 变量 len 可以实时记录当前数组的大小，注意不要忘了 free() */
```

注意，弹性数组必须是 struct 结构的最后一个属性，且 struct 至少还有一个其他属性。


## typedef

typedef 用来为某个类型起别名，详略。

## union

详略。

## enum 

如果一种数据类型的取值只有少数几种可能，并且每种取值都有自己的含义，为了提高代码的可读性，可以将它们定义为 `enum` 类型，称为枚举类型。用法不再赘述。

`enum`的作用域与变量完全类似（块和全局），另外，`enum` 的属性会自动声明为常量，也就是可以进行如下操作：

``` c
enum { ONE, TWO };

printf("%d %d", ONE, TWO);  // 0 1
```


