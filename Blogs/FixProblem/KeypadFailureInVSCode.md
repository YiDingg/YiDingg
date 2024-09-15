# Keypad Failure in VSCode <br> VSCode 按键失灵的解决方案

## 问题描述

起因是在使用 VSCode 时遇到了下面的问题：

VScode 编辑 .tex 文件时，backspace 不灵敏（实际上是命令 deleteLeft 的问题），具体表现为连按三至四次 backspace 或长按 backspace 时，vscode 卡死并报出 “Contributed command 'deletLeft' does not exist” 的弹窗，试过将命令 deletLeft 绑到 ctrl+h 上，与 backspace 现象完全相同（这排除了键位的问题）。在删去插件 "Key Promoter" 后，backspace 恢复正常，但是 Enter 键又不灵敏了。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-15-18-24-59_KeypadFailureInVSCode.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-15-18-25-04_KeypadFailureInVSCode.png"/></div>

环境：Win 11, VSCode v1.93.1 (August 2024)

已经做过的尝试（都无效果）：
1. 重启 VSCode
2. 重启电脑
3. 文件 .txt .md .c .h 等都可以正常 deleteLeft
4. 重装 Latexwork Shop 插件
5. 删除 VSCode 并重装
6. 在另一台电脑上同步此台电脑的设置，新电脑上也出现此问题（这排除了电脑原因）

## 解决方案

### 方案一（简单但可能无效）

参考 [here](https://blog.csdn.net/blacksharpsss/article/details/125612880) 或者 here

### 方案二（麻烦但是一定有效）

最终认为是 VSCode 中某个插件设置与 VSCode 本身的设置冲突，考虑到难以确定具体是哪个插件，并且删去插件时一般不会删除插件的配置文件（所以删除插件不一定有用），我们决定重装所有插件。不出意外的haul，这个方法是一定有效的。

具体步骤如下：
- 记录下你现在已安装的全部插件（截屏方便一些）
- 关闭此设备的 VSCode 设置云同步。左下角齿轮 --> 设置同步 --> Turn off，建议勾选“关闭所有设备云同步并从云中清除数据”，如下图。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-15-18-06-41_KeypadFailureInVSCode.png"/></div>

- 找到 Users 目录下的 .vscode 文件夹，VSCode 的所有扩展设置都在这里，例如我的路径是 `C:\Users\13081\.vscode`
- <span style='color:red'> 备份此文件夹</span>（比如复制到桌面），然后将其删除
- 重新启动 VSCode，依次安装你之前的插件，每安装两至三个插件后，检查按键是否失灵，以排除出问题的插件。
- 插件安装完毕后，对需要重新配置的插件进行配置。多数插件的路径配置等会保存在 VSCode 的 settings.json 文件中，这些一般不会影响按键，且并没有被删除（因为它不在 .vscode 文件夹中），无需再次配置。

配置完毕后，重启 VSCode，按键恢复正常。进行必要的测试，以确保没有其他问题，便可重新打开设置云同步。在其它需要同步的设备上，先关闭同步，删除 `.vscode` 文件夹，然后再打开设置同步即可。
