# C Notes(!): Problem Solutions

记录 C 语言学习过程中遇到的一些问题及其解决方案。

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