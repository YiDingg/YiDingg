# 文件夹无权访问或访问被拒绝

文件夹无权访问或访问被拒绝，如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-15-16-04-08_文件夹权限问题.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-15-11-48-50_SettingAdviceForNewComputer.png"/></div>

### 解决方案一（推荐）

- 用管理员模式打开 PowerShell（或命令行窗口）
- 输入以下代码（我们以 `C:\Program Files\WindowsApps` 文件夹为例）

``` shell
# 双引号内是需要获取权限的文件夹路径
takeown /F "C:\Program Files\WindowsApps" /A
icacls "C:\Program Files\WindowsApps" /grant "Users:(RX)" /C

# 这段代码主要用于在 Windows 操作系统中修改文件和文件夹的权限。它使用了 takeown 和 icacls 两个命令行工具，这些工具在 Windows 资源管理器中并不直接提供，但可以在命令提示符（CMD）或 PowerShell 中运行。下面是对每一行代码作用的逐行分析：

#第一行：
    # takeown   :这是 Windows 命令行下的一个工具，用于获取指定文件或文件夹的所有权。这对于修改由其他用户或系统账户拥有的文件或文件夹的权限特别有用。
    # /F        ：指定了要获取所有权的文件或文件夹的路径。这里指的是 C:\Program Files\WindowsApps 这个目录。
    # /A        :自动赋予当前登录的用户（即管理员账户）所有权，而无需手动指定用户名。
    # 总结      :第一行代码的目的是获取 C:\Program Files\WindowsApps 目录的所有权。

#第二行：
    # icacls                         :这是另一个 Windows 命令行工具，用于显示或修改文件、目录、注册表项或Windows服务的访问控制列表（ACL）。
    # "C:\Program Files\WindowsApps" :指定了要修改其 ACL 的文件或目录的路径。
    # /grant "Users:(RX)"            :授予Users组读取（R）和执行（X）权限。这通常用于文件，以允许用户读取文件内容或运行可执行文件；对于目录，这允许用户列出目录内容，但不允许他们修改目录本身或其中的文件（除非有额外的权限）。
    # /C                             :继续选项，如果在处理过程中遇到错误，则 icacls 会继续执行而不是停止。
    # 总结                           :此行代码授予 Users 组对 C:\Program Files\WindowsApps 目录的读取和执行权限
```
### 解决方案二（完全控制权限）

如果你要对文件夹进行删除等操作，可能需要使用完全控制权限，如下：

- 用管理员模式打开 PowerShell（或命令行窗口）
- 输入以下代码（我们以 `C:\Program Files\WindowsApps` 文件夹为例）

``` shell
# 双引号内是需要获取权限的文件夹路径
takeown /F "C:\Program Files\WindowsApps" /R /A /D Y    
icacls "C:\Program Files\WindowsApps" /grant "Users:(F)" /T /C   

# 这段代码主要用于在 Windows 操作系统中修改文件和文件夹的权限。它使用了 takeown 和 icacls 两个命令行工具，这些工具在 Windows 资源管理器中并不直接提供，但可以在命令提示符（CMD）或 PowerShell 中运行。下面是对每一行代码作用的逐行分析：

#第一行：takeown /F "C:\Program Files\WindowsApps" /R /A /D Y
    # takeown：这是 Windows 命令行下的一个工具，用于获取指定文件或文件夹的所有权。这对于修改由其他用户或系统账户拥有的文件或文件夹的权限特别有用。
    # /F：指定了要获取所有权的文件或文件夹的路径。这里指的是 C:\Program Files\WindowsApps 这个目录。
    # /R：递归选项，意味着不仅会对指定的目录本身，还会对其子目录和文件应用此操作。
    # /A：自动赋予当前登录的用户（即管理员账户）所有权，而无需手动指定用户名。
    # /D Y：自动回答“Y”（Yes），用于在需要确认时自动同意操作，避免命令执行过程中因等待用户输入而暂停。
    # 总结：第一行代码的目的是递归地获取 C:\Program Files\WindowsApps 目录及其所有子目录和文件的所有权。

#第二行：icacls "C:\Program Files\WindowsApps" /t /c /grant HR:F
    # icacls：这是另一个 Windows 命令行工具，用于显示或修改文件、目录、注册表项或Windows服务的访问控制列表（ACL）。
    # "C:\Program Files\WindowsApps"：指定了要修改其 ACL 的文件或目录的路径。
    # /t：递归选项，与 takeown 的 /R 类似，它指定了操作应应用于指定的目录及其所有子目录和文件。
    # /c：继续选项，如果在处理过程中遇到错误，则 icacls 会继续执行而不是停止。
    # /grant HR:F：授予权限。这里将完全控制（F）权限授予 Users 组。
    # 总结：第二行代码授予 Users 组对 C:\Program Files\WindowsApps 目录及其所有子目录和文件的完全控制权限。
```
