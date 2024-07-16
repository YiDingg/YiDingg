# C Notes(6): Special Data Types

## struct

### Intro

`struct`主要用于下面两种情况：
- 复杂的物体需要使用多个变量描述，这些变量都是相关的。
- 某函数需要传入多个参数，将其组合成一个复合结构传入。

`struct`变量在声明时，也可以使用指定初始化器（designated initializer），也可以在声明结构体的同时创建结构体变量，并为它们赋值。
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

### struct 的复制

不同于数组，struct 变量可以使用`=`进行变量整体赋值，但不能用比较运算符（`==`、`!=`）比较两个结构体是否相等。
```c
struct cat { char name[30]; short age; } a, b;

strcpy(a.name, "Hula");
a.age = 3; 
```

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

## typedef

## union

## enum 

