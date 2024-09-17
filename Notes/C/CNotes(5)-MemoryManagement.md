# C Notes (5): Memory Management (内存管理)

> [!Note|style:callout|label:Infor]
Initially published at 16:27 on 2024-08-07 in Lincang.


## Before 

C语言的内存由stack, heap, static (.bss and .data), .rodata, .text 五大部分构成，分别称为栈区、堆区、静态区、常量区（只读区）、代码区，带有“.”点号的部分构成可执行文件。在内存管理之前，我们先了解他们的概念。

- Stack：栈（stack）是一种 LIFO（Last In First Out） 的数据结构，如下图所示

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-15-15-07-26_CSeriesNotes(5)-MemoryManagement.jpg"/></div>

stack可以用array或linked list实现。前者提供了 $O(1)$ 的访问和操作速度，存储空间连续，但栈的大小固定，容易溢出，在扩容时需复制整个数组；后者具有动态大小，存储空间离散，但访问和操作速度更慢。大多数情况下，我们使用数组构建栈空间。C++的STL（standard template library，标准模版库）中提供了vector, list, stack, queue等容器接口，可以直接调用。

- Heap：这里的 heap 不是指数据结构中的 heap，前者只是内存中的一个区域，而后者是完全二叉树的一种。
- static：具有全局作用域的变量存储在static区（包括全局变量、static变量）。static区被分为 .bss 和.data 两部分，未初始化或初始化为0的变量存放在 .bss 段，初始化为非 0 值的变量存放在 .data 段。
- .rodata：字符串常量、数字常量和const修饰的变量存放在常量区，程序运行期间，常量区的内容不可以被修改。
- .text：程序执行代码和define定义的常量也存放在代码区。

## Management

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-15-14-47-36_CSeriesNotes(5)-MemoryManagement.jpg"/></div>

### void* 

`void*`，即无类型指针，可以指向任意类型的数据，但是不能解读数据。任一类型的指针都可以转为 `void*`，而 `void*` 也可以转为任一类型的指针。

### 相关函数

<!-- details begin -->
<details>
<summary>1. malloc()</summary>

注意：`malloc()`不会对所分配的内存进行初始化，里面还保存着原来的值。

```c
/* 原型 */
void* malloc(size_t size);

/* 一般用法 */
int* p = (int*) malloc(sizeof(int) * 10);
if (p == NULL) {
  // 内存分配失败, dosomethinh
}
else {
    // 内存分配成功, 使用 p 指针
}
```
</details>
<!-- details begin -->
<details>
<summary>2. free()</summary>

`free()`释放已分配的内存，否则内存块一直被占用，直到程序结束。一个很常见的错误是，在函数内部分配了内存，但是函数调用结束时，没有使用`free()`释放内存。

```c
/* 原型 */
void free(void* block);

/* 一个例子 */
int* p = (int*) malloc(sizeof(int));
*p = 12;
free(p);
```
</details>
<!-- details begin -->
<details>
<summary>3. calloc()</summary>

分配内存并初始化为0，用法与`malloc()`类似。

```c
/* 原型 */
void* calloc( size_t num, size_t size );

/* 一般用法 */
int* p = (int*) calloc(sizeof(int) * 10);
if (p == NULL) {
  // 内存分配失败, dosomethinh
}
else {
    // 内存分配成功, 使用 p 指针
}
```
</details>
<!-- details begin -->
<details>
<summary>4. realloc()</summary>

放大或缩小已分配内存的大小，不对新增部分初始化。

```c
/* 原型 */
void *realloc( void *ptr, size_t new_size );


/* 一个例子 */
int* b;

b = malloc(sizeof(int) * 10);
b = realloc(b, sizeof(int) * 2000); 
```
</details>

### restrict 关键字

声明指针变量时，`restrict`告诉编译器，该块内存区域有且仅有当前指针一种访问方式，其他指针不能读写该块内存，称为“restrict pointer”。