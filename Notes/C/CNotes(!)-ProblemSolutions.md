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