# C Notes(!): Problem Solutions

> [!Note|style:callout|label:Infor]
Initially published at 12:40 on 2024-08-06 in Lincang.


记录 C 语言学习过程中遇到的一些问题及其解决方案。

<!-- details begin -->
<details>
<summary>printf 在终端输出乱码</summary>

``` c
#include <windows.h>

system("chcp 65001"); // 方式 1: system() 设置编码为 UTF-8
SetConsoleOutputCP(65001); // 方式 3: SetConsoleOutputCP() 设置输出编码为 UTF-8
```

</details>

<!-- details begin -->
<details>
<summary>编译时报错：undefined reference to `DrawBoard'</summary>

可能是 CMake 链接配置错误，到 CMakelists.txt 中 `Ctrl + S` 刷新 CMake 配置即可。
</details>

<!-- details begin -->
<details>
<summary>main.exe 黑窗口一闪而过</summary>

`return 0` 前写 `getchar();` 或 `while(1)` 或 `system("pause");`  
</details>

<!-- details begin -->
<details>
<summary>运行报错：Segmentation fault</summary>

一般是将变量当作指针传入，使得数值被当作地址来处理导致的错误，比如下面的例子：

``` c
/* 错误 */
scanf("%d%d", CuurentCoordinate.raw, CuurentCoordinate.column);

/* 正确 */
scanf("%d%d", &CuurentCoordinate.raw, &CuurentCoordinate.column);
```
</details>

<!-- details begin -->
<details>
<summary>cannot open output file bin\main.exe: Permission denied</summary>

.exe 文件仍在运行，关闭后重新编译即可。
</details>

<!-- details begin -->
<details>
<summary>CMake 配置错误: [cmake]   No SOURCES given to target: main</summary>

出现问题的环境如下图，工作区路径是 `C:\Users\13081\Desktop\[Homework]C\Homework1`。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-09-18-31-07_CNotes(!)-ProblemSolutions.jpg"/></div>

但是复制到其他路径下（例如 `C:\Users\13081\Desktop\Homework1`，`C:\Users\13081\Desktop\Homework1]`），CMake 配置正常。

**结论与解决方案：**路径中的所有文件夹名，都不能以 `[` 开头（否则会被认为是 `\[` 转义字符），重命名文件夹为 `Homework-C` 后，问题解决，此时工作区路径 `"C:\Users\13081\Desktop\Homework-C\Homework1"`

</details>