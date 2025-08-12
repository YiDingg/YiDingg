# VSCode 变得很卡

最近 vscode 突然很卡，无论是粘贴、保存文件、修改/创建/删除文件等操作，还是在 vscode 的 git 终端输入命令都会卡半天，参考这篇文章 [博客园 > vscode 保存文件慢 —— 如何检验是哪个vscode插件导致的问题](https://www.cnblogs.com/duanlvxin/p/17253626.html), 查看是哪个插件出问题。经过排除法，发现是名为 "Color Highlight" 的插件导致的：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-22-43-29_VSCode 变得很卡.png"/></div>

然后又禁用了 "Git" 插件：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-08-07-22-44-50_VSCode 变得很卡.png"/></div>

将这两个插件禁用后，问题得到解决，并且 git 终端仍能正常使用。




