# LTEX

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 18:06 on 2024-12-15 in Beijing.

## 安装 LTEX
直接在 VSCode 中搜索 `LTEX`，点击安装即可，注意区分不同作者的相似插件。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-12-15-18-19-50_LTEX.png"/></div>

## Solution: 'could not run ltex-ls with java'

Version information:
- Operating system: Windows 11
- VS Code: 1.92.0
- vscode-ltex: 13.1.0

如果正常安装 LTEX 后出现 `could not run ltex-ls with java` 的错误，具体而言，会在 VSCode 的输出端口中显示如下信息：
```shell
2024-07-29T17:17:28.190Z Info: Setting LTeX UI language to 'en'.
2024-07-29T17:17:28.190Z Info: Loading i18n messages...
2024-07-29T17:17:28.190Z Info: Loading default i18n messages...
2024-07-29T17:17:28.194Z Info:
2024-07-29T17:17:28.194Z Info: ltex.ltex-ls.path not set.
2024-07-29T17:17:28.194Z Info: Searching for ltex-ls in 'c:\Users...'...
2024-07-29T17:17:28.194Z Info: ltex-ls found in 'c:\Users...'.
2024-07-29T17:17:28.194Z Info:
2024-07-29T17:17:28.194Z Info: Using ltex-ls from 'c:\Users...'.
2024-07-29T17:17:28.194Z Info: Using Java bundled with ltex-ls as ltex.java.path is not set.
2024-07-29T17:17:28.196Z Info: Testing ltex-ls...
2024-07-29T17:17:28.196Z Info: Command: "c:\Users\...\lib\ltex-ls-15.2.0\bin\ltex-ls.bat"
2024-07-29T17:17:28.196Z Info: Arguments: ["--version"]
2024-07-29T17:17:28.196Z Info: env['JAVA_HOME']: undefined
2024-07-29T17:17:28.196Z Info: env['JAVA_OPTS']: "-Xms64m -Xmx512m"
2024-07-29T17:17:28.196Z Error: Test failed.
2024-07-29T17:17:28.196Z Error: Error details:
2024-07-29T17:17:28.201Z Error: Error: spawnSync c:\Users...\lib\ltex-ls-15.2.0\bin\ltex-ls.bat EINVAL
2024-07-29T17:17:28.201Z Error: at Object.spawnSync (node:internal/child_process:1124:20)
2024-07-29T17:17:28.201Z Error: at Object.spawnSync (node:child_process:914:24)
2024-07-29T17:17:28.201Z Error: at DependencyManager. (c:\Users...\dist\extension.js:15912:43)
2024-07-29T17:17:28.201Z Error: at Generator.next ()
2024-07-29T17:17:28.201Z Error: at fulfilled (c:\Users...\dist\extension.js:15367:32)
2024-07-29T17:17:28.202Z Info: ltex-ls did not print expected version information to stdout.
2024-07-29T17:17:28.202Z Info: stdout of ltex-ls:
2024-07-29T17:17:28.202Z Info:
2024-07-29T17:17:28.202Z Info: stderr of ltex-ls:
2024-07-29T17:17:28.202Z Info:
2024-07-29T17:17:28.202Z Info: You might want to try offline installation, see https://valentjn.github.io/vscode-ltex/docs/installation-and-usage.html#offline-installation.
```

首先尝试离线安装 [here](https://valentjn.github.io/vscode-ltex/docs/installation-and-usage.html#offline-installation)，如果问题依然存在，参考下面的解决方法。

解决方法如下：
- 在 `%USERPROFILE%.vscode\extensions\valentjn.vscode-ltex-13.1.0\dist` 路径下找到 `extension.js` 文件，其中 `%USERPROFILE%` 是你的 VSCode 安装路径。
- 打开 `extension.js` 文件，按下面的提示进行修改，其中 @@ 表示需要修改的行号，可以按快捷键 `Ctrl + G` 输入行号跳转到对应的行。`+` 表示需要新增的内容，`-` 表示需要删除的内容。

```javascript
--- a/extension.js.old
+++ b/extension.js
@@ -13516,6 +13516,7 @@ class DependencyManager {
             const executableOptions = {
                 encoding: 'utf-8',
                 timeout: 15000,
+                shell: true
             };
             if (executable.options != null) {
                 executableOptions.cwd = executable.options.cwd;
@@ -13615,6 +13616,7 @@ class DependencyManager {
         const executableOptions = {
             encoding: 'utf-8',
             timeout: 15000,
+            shell: true
         };
         const childProcess = ((process.platform == 'win32')
             ? ChildProcess.spawnSync('wmic', ['process', 'list', 'FULL'], executableOptions)
@@ -24684,7 +24686,9 @@ class LanguageClient extends commonClient_1.CommonLanguageClient {
                     if (node.args) {
                         node.args.forEach(element => args.push(element));
                     }
-                    const execOptions = Object.create(null);
+                    const execOptions = {
+                        shell: true
+                    };
                     execOptions.cwd = serverWorkingDir;
                     execOptions.env = getEnvironment(options.env, false);
                     const runtime = this._getRuntimePath(node.runtime, serverWorkingDir);
@@ -24817,6 +24821,7 @@ class LanguageClient extends commonClient_1.CommonLanguageClient {
                 let args = command.args || [];
                 let options = Object.assign({}, command.options);
                 options.cwd = options.cwd || serverWorkingDir;
+                options.shell = true;
                 let serverProcess = cp.spawn(command.command, args, options);
                 if (!serverProcess || !serverProcess.pid) {
                     return Promise.reject(`Launching server using command ${command.command} failed.`);
```

完成修改后，重新启动 VSCode 即可（笔者就是参考这个方法解决的）。如果问题仍未解决，参考 References 中的链接 [GitHub --> valentjn --> vscode-ltex --> issues-884](https://github.com/valentjn/vscode-ltex/issues/884)。

## References:
- [GitHub --> valentjn --> vscode-ltex --> issues-884](https://github.com/valentjn/vscode-ltex/issues/884)