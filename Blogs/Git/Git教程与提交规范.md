# Git 教程与命令规范

## 前言
Git 目前有 Bash，GUI，CMD 三种使用使用环境。Bash 与Linux命令格式相似，使用频率最高；GUI 为图形界面，CMD 类型Windows命令行环境。

本篇文章主要为 Git Bash 的使用，有关Git常见问题、Git下载安装等内容放在了文章末尾。

<div class='center'>

| 相关链接 |
| :------: |
| [Git 官网](https://git-scm.com/) |
| [Github 官网](https://github.com/) |
| [Watt Toolkit (原名steam++)：Github网络加速器](https://steampp.net/) |
</div>

## 一、Git 使用教程
在此之前，我们先介绍几个Windows命令行环境（Windows PowerShell）的指令。打开 Windows Powershell（也可以在VSCode中新建PowerShell中断）。


<details>
<summary>pwd</summary>

`pwd` (print work directory)：显示当前目录所在地址
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-53-50.png"/>
</details>

<details>
<summary>ls</summary>

`ls` (list files)：显示当前目录下的所有文件
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-53-58.png"/>
</details>

<details>
<summary>cd</summary>

`cd` (change directory)：切换目录
后接 ".." 是返回上一级，后接文件名是进入下一级

</details>


### 1. Git使用演示
为了更好的演示效果，我们在桌面新建一个文件夹 Git_Test，在其中新建 test.tex 文件，并以此进行演示。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-02-10-07-39_Git教程与提交规范_.png"/></div>

下面的步骤，既可以在 Windosw PowerShell 中进行，也可以在 Git Bash 中进行，步骤完全相同，这里以 Git Bash 为例。


<details>
<summary> 1. 查看、修改用户信息</summary>  

`git config --global --list` ：查看用户信息<br> 
`git config --global user.name "name"` ：修改用户名 <br>
`git config --global user.email "email"` ：修改邮箱
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-55-25.png"/>
</details>

<details>
<summary> 2. 初始化本地git仓库  </summary>  

`git init` ：初始化本地仓库<br>会进行初始化，并在当前目录创建.git文件夹（用于保存版本记录和变化）
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-55-32.png"/>
</details>

<details>
<summary>  3. 添加文件到Git  </summary>  

`git add test.txt` ：添加一个文件<br>`git add .` ：添加当前目录所有文件
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-55-38.png"/>
</details>

<details>
<summary> 4. 查看文件状态  </summary>  

`git status` ：查看（当前目录）文件更改情况（分为stage区和workspace区）
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-55-43.png"/>
</details>

<details>
<summary>  5. 提交更改（固定为版本） </summary>  

`git commit -m "初始化，并添加了几个文件"` ：提交更改，引号内为此次提交的批注
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-55-48.png"/>
<br>注意：每次提交前都需要将待提交文件add到stage区，如下图。或者用`-a -m`参数一次性add到stage区并commit
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-55-57.png"/>

`git commit -a -m "一次性完成add和commit"`：一次性完成add和commit
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-56-06.png"/>
</details>

<details>
<summary>  6. 查看提交日志  </summary>  

`git log`：查看提交日志<br>`git log --oneline`：简洁版日志，每行显示一次提交
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-56-11.png"/>
</details>


<details>
<summary> 7. 回退版本  </summary>  

`git reset --hard HEAD^`：重置为上个版本  
`git reset --hard {commit_hash}`：重置为某个版本
注意： --hard 回退模式会彻底删除之后的所有更改，无法撤销
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-56-20.png"/>
</details>


<details>
<summary> 8. 创建并切换分支  </summary>  

`git branch {branch_name}`：创建新分支（如果分支已存在，则不产生任何效果）  
`git branch`：查看所有分支  
`git checkout {branch_name}`：切换到某分支（如果分支不存在，则不产生任何效果）  
`git checkout -b bra_name`：切换到bra_name分支，如果分支不存在，创建并切换分支

注：创建分支时，会将当前分支（可以不是master）复制到新分支，后续的修改都是基于此版本。
例如团队协作开放一个项目时，从V1.0到V1.1要新增三个功能，分别由三个人进行开发。这时就在master上的V1.0创建三个分支，三个人基于V1.0版本，分别开发完毕后再进行merge合并。
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-59-20.png"/>
</details>


<details>
<summary> 9. 分支合并  </summary>  

`git merge --no-ff {local_branch_name} -m "merge bra_1 into bra_2"`：将某个分支合并到当前分支，并附带提交备注  
`git branch -vv`：查看所有分支状态  
注：merge合并只是将某分支的更改合并到另一个分支，并不会删除原始分支，建议提交信息格式为 "merge branch V2.0 into branch main "。合并时可能会出现conflicts，手动解决后再次merge即可。
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-59-26.png"/>
</details>


<details>
<summary>  10. 连接远程仓库（HTTPS方式） </summary>  

首先创建一个仓库，填写相关信息和初始化信息，并复制仓库连接：  
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-59-31.png"/>
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-59-38.png"/>
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-22-59-49.png"/>

`git remote add origin {remote-url}`：将远程仓库链接到本地并命名为 origin（注意，Git Bash 默认中键黏贴）  
`git remote -v`：查看已链接的仓库信息  
`git branch -m main`：重命名当前分支为 "main"  
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-00-00.png"/>
</details>


<details>
<summary> 11. 上传更改到远程仓库  </summary>  
确保现在你处于main分支，然后：
`git push -u origin main`：将当前分支推送到远程仓库 origin 的 main 分支，-u 表示建立分支关联（下次位于main分支时仅需 git push 即可将本地main分支推送到origin的main分支）
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-00-07.png"/>


如果出现SSL证书无法验证，确保此远程仓库是可信的，然后 `git config --global http.sslVerify false`（全局禁用SSL证书验证）并再次提交。
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-00-17.png"/>
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-00-25.png"/>
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-00-32.png"/>
</details>


###  2. Git管理新项目
在Github上新建一个项目库，我们希望将它部署到本地，并在本地进行修改、提交、推送等操作。 以最常见的分支结构（主main+dev，辅feat+rel+fix）为例：

<details>
<summary>1. 在合适的目录克隆仓库  </summary>  

我们选择本地存放位置选择为 C:\Users\13081\Desktop\Test ，在此文件夹中右键，点击 Git Bash here，则会打开一个位于此目录的 Git Bash（省去cd命令找半天的过程），然后：    
`git clone {remote-url}`：将远程仓库克隆到本地（建议使用SSH方式）  
`git branch -vv`：查看本地分支（-vv指详细信息）  
`git branch -r`：查看远程链接分支    
`git remote -v`：查看链接信息    
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-01-09.png"/><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-01-14.png"/>
当然，也可以一次性查看本地、远程分支：  

`git branch -a -vv`：查看所有分支（-vv指详细信息)  
注：git clone 命令完成克隆时，会自动将本地链接到远程仓库  
</details>


<details>
<summary>2. 修改链接仓库名称  </summary>  

将远程仓库克隆到本地时，其默认名为origin，可以对其进行修改。  
`git remote rename origin {remote_name}`
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-01-25.png"/>
</details>


<details>
<summary> 3. 配置SSH密钥 </summary>  

[Git配置SSH Key（密钥和公钥）到github](https://blog.csdn.net/Yaoyao2024/article/details/132123525)
</details>


<details>
<summary> 4. 管理、推送分支 </summary>  

`git branch -b {branch_name}`：新建本地分支
修改分支并commit后：  
`git push {remote_name} {remote_branch_name}`：将本地分支推送到远程
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-01-40.png"/>

`git branch -d {branch_name}`：删除本地分支
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-01-48.png"/>

`git push {remote_name} --delete {remote_branch_name}`：删除远程分支
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-01-56.png"/>
</details>


<details>
<summary> 5. 标签管理与版本发行 </summary>  

`git tag {tag_name}`：为HEAD所在提交位置打标签（本地）  
`git push {remote_name} --tags`：推送所有标签到远程  
版本发布：先选择分支，然后选择标签。  
</details>


### 3. Git 管理本地老项目
现在我们需要为一个老项目搭建 Git 管理，下面是它之前所有的发行版本：

<div class='center'><img src='https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-02-04.png' alt='img'/></div>

Git 搭建步骤如下：
<details>
<summary> 1. 创建远程项目库 </summary>  

<div class='center'><img src='https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-02-09.png'/></div>

</details>


<details>
<summary> 2. 配置SSH密钥 </summary>  

`ssh-keygen -t rsa -C {your_email}`  
`cat ~/.ssh/id_rsa.pub`  
密钥生成后，在远程仓库中添加你的公钥。

</details>


<details>
<summary>3. 克隆远程仓库  </summary>  

确保你已在远程（如Github）上添加了SSH密钥，然后在合适的本地目录下打开 Git Bash：
`git init`
`git clone {new_remote_name} {repo-url}`

如果遇到问题，可以参考官方文档[Using SSH over the HTTPS port](https://docs.github.com/en/authentication/troubleshooting-ssh/using-ssh-over-the-https-port)或者[《linux下生成ssh密钥并获取密钥》](https://blog.csdn.net/qq_39505065/article/details/106099633)

我这边就是遇到报错：
```
ssh: connect to host github.com port 22: Connection refused
fatal: Could not read from remote repository.
```
这是由于防火墙拒绝SSH请求导致的，参考上面的官方文档[Using SSH over the HTTPS port](https://docs.github.com/en/authentication/troubleshooting-ssh/using-ssh-over-the-https-port)即可轻松解决。
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-02-25.png"/>
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-02-33.png"/>
</details>

<details>
<summary> 4. 进行版本导入 </summary>  

`git remote rename origin {new_remote_name}`：先修改一下远程链接名称

接下来，对每个版本文件，依次执行：
(1) 将某一版本中的文件全部复制到当前目录
(2) `git commit -a -m "导入版本Vx.x"`
(3) `git tag {Version}`
(4) `git push {remote_name} {remote_branch_name}`
(5) `git push {remote_name} {local_tag}`
全部导入完毕后，推送到远程：
(1) `git push {remote_name} main`
(2) `git push {remote_name} --tags` 

例如对V1.0版本：
(1) 将V1.0版本中的文件全部复制到当前目录
(2) `git commit -a -m "导入版本V1.0"`
(3) `git tag V1.0`
</details>


<details>
<summary> 5. 检查是否导入成功 </summary>  

全部版本导入完毕后，在Github的Tag处可直接下载对应版本，这样就完成了老项目库的 Git 搭建。
<div class='center'><img src='https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-02-39.png' alt='img'/></div>
<div class='center'><img src='https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-02-42.png' alt='img'/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Git教程与提交规范--2024-06-23-23-02-42.png"/></div>
</details>



### 4. 参与他人项目
to be continued ...


## 二、Git 规范化
下面介绍一种名为 Git-Flow 的规范化风格。

项目共有五个分支，包括两个固定分支（main，develop）、三个临时性分支（feature、fixbug、release），临时性分支在工作完成后需立即删除，保证仅有两个固定分支常驻。

- mian：代码库唯一主分支，所有提供给用户使用的正式版本，都在这个主分支上发布。保证 main 分支上的每一个提交都是一个新的版本（打上 tag）
- develop：主分支只用来发布版本，日常开发（小的、杂七杂八的开发）应该在另一条分支上完成，称为 develop 分支。这个分支可以用来生成代码的最新隔夜版本（nightly）。如果想正式对外发布，就将 dev 分支merge到 main。
- feature：始于 develop，终于 develop。功能分支，是为了开发某种特定功能，从 develop分支上面分出来，开发完成后merge到 develop 并删除。功能分支的名字，可以采用 `feat/***` 的形式命名，例如 `feat/PWMandADC`。
- fixbug：始于 main，终于 main。
- release：始于 develop，终于 develop、main。预发布分支，是指发布正式版本之前（即合并到 main 分支之前），我们可能需要有一个预发布的版本进行测试。预发布分支是从 develop 分支上面分出来的，预发布结束以后，必须合并进 develop 和 main 分支，然后删除。它的命名，可以采用`release/***`的形式。

这里也仅介绍极小型项目开发的规范建议（例如个人或三人开发）：

<details>
<summary>具体开发流程： </summary>

1.确保当前位于正确的固定分支  
2.（若多人） `git pull <remote_name> <remote_branch_name>` ：fetch + merge  
3.`git checkout -b <local_branch_name>`：创建并切换到临时分支  
4.开发代码（主要环节，包括 status, add, commit 等）  
5.`git checkout <local_branch_name>`：切换回固定分支  
6.（若多人） `git pull <remote_name> <remote_branch_name>` ：fetch + merge，并解决 conflicts（如果有的话）  
7.`git merge --no-ff <local_branch_name> -m "merge bra_1 into bra_2"`：将开发合并到固定分支  
8.`git push <remote_name> <remote_branch_name>`：将更改推送到远端  
9.`git branch -d <local_branch_name>`：删除临时分支  
</details>


<details>
<summary>以开发AAA功能为例（远程仓库名称 MuMeStar）： </summary>

1.确保当前位于 develop 分支  
2.（若多人） `git pull MuMeStar develop` ：fetch + merge  
3.`git checkout -b feat/AAA`：创建并切换到临时分支  
4.开发代码（主要环节，包括 status, add, commit 等）  
5.`git checkout develop`：切换回固定分支  
6.（若多人） `git pull MuMeStar develop` ：fetch + merge，并解决 conflicts（如果有的话）  
7.`git merge --no-ff feat/AAA -m "merge feat/AAA into develop"`：将开发合并到固定分支  
8.`git push MuMeStar develop`：将更改推送到远端  
9.`git branch -d feat/AAA`：删除临时分支  

</details>



其中，在开发环节，我们的 commit 备注应包含：type（必须）、scope（可选）、subject（必须）。
- type
	- feat：新功能（feature）
	- fixbug：修补bug
	- docs：文档（如注释等）
	- test：增加测试
	- Revert：当前 commit 用于撤销以前的 commit，后接被撤销 Commit 的备注
	- style： 格式（不影响代码运行的变动）
	- refactor：重构（即不是新增功能，也不是修改bug的代码变动）
	- chore：构建过程或辅助工具的变动
- scope 用于说明 commit 影响的范围，比如数据层、控制层、视图层等等，视项目不同而不同。
- subject 是 commit 目的的简短描述，不超过50个字符，首字母小写，结尾不加句号。

例如：

```
feat(*): add ADC function
revert(*): "feat(*): add ADC function" - <commit_hash>
```

## 三、其它
### 1. Git 常见问题

#### 1.1 小问题汇总
- Tab键可以自动补全命令、文件名等 
- `--global` 可简写为 `--gl`，`--list` 可简写为 `--l` 或 `-l`
- Git Bash 环境中，复制粘贴并不是Ctrl+C和Ctrl+V，默认情况下，选中则会复制（可以双击选中），中键黏贴
- 默认的master或main分支并没有任何特殊性，仅是默认名为master
- commit 命令只会提交位于stage区的更改，如要一次性add到stage区并commit，需使用 `git commit -a -m "提交信息"` 命令。
- 创建分支时，会将当前分支（可以不是master）复制到新分支，后续的修改都是基于此。
- `git reset --hard <>` 回退模式会彻底删除之后的所有更改，无法撤销
- `git clone <remote-url>` 命令完成克隆时，会自动将本地链接到远程仓库。
- 标签则是一个静态的指针，指向一个特定的提交，不会随着代码的修改而移动。
- `git tag` 命令创建的标签默认只存在于本地仓库中，如果想要将标签推送到远程仓库，需要使用 `git push` 命令将标签推送到远程仓库。
- 为了使 Github 能正常记录、跟踪你的contributions，在 git config --gl user.email 时，需要填入与Github上一样的邮箱。如果Github上添加了多个邮箱，任意填入一个即可。
- 为避免不同操作系统下的换行符冲突，建议Windows设置 `git config core.autocrlf true`，Mac和Linux设置 `git config core.autocrlf input`。详情可以参考 [Git换行符问题](https://blog.csdn.net/adaivskean/article/details/124873199)

#### 1.2 reset 参数区别
`git reset <commit_hash>`：重置到某一版本（默认参数为 --mixed）  
`git reset --soft <commit_hash>`：日志（仅撤回 commit 一步，暂存区退回到commit前的状态，工作区不变）  
`git reset --mixed <commit_hash>`：日志+暂存（工作区不变）  
`git reset --hard <commit_hash>`：日志+暂存+工作区（相当于直接重置）  


### 2. Git 下载及安装
Git下载及命令行环境配置步骤如下：

<div class='center'> 

| 步骤|详细| 图片 |
| :-: | :-: |:-: |
| 1. 进入 [Git官网](https://git-scm.com/) 进行下载：  |依次点击：Downloads --> Windows --> 64-bit Git for Windows Setup  |      |
| 2. 安装Git |       选择合适的安装路径!!#ff0000 （不要有中文字符）!!       | |
| 3. 检查是否安装成功 | 在桌面右键，点击 Open Git Bash here，输入 `git version` 并回车，正常显示版本信息则表示安装成功 |     |
</div>

### 3. Github 无法连接
推荐下载 [Watt Toolkit (原名steam++) -- Github网络加速器](https://steampp.net/)，可完全免费加速 Github、steam 等平台。我个人使用的就是这个（没收广告费）。


## 参考文章
[【git / github 保姆级教程入门，工作和协作必备技术】](https://www.bilibili.com/video/BV1s3411g7PS)  
[【Git + GitHub 10分钟完全入门（图形化界面）】](https://www.bilibili.com/video/BV1KD4y1S7FL)  
[【git-branch详解，2023年git基础使用教程】](https://www.bilibili.com/video/BV16M411z7uH)  
[【git-tag管理，2023年git最新实用教程】](https://www.bilibili.com/video/BV16Y411B7Jp)  
[【ssh密钥进行github身份验证】](https://www.bilibili.com/video/BV1dV411G77N)  
[【Git操作命令-版本回退】](https://www.bilibili.com/video/BV16J4m1H7Fv?vd_source=cc1a55267bfd4977e53958893f16a4a9)  
[《Git分支管理及命名规范》](https://blog.csdn.net/xc_zhou/article/details/136552399)  
[《Git 分支管理与提交规范》](https://blog.csdn.net/adaivskean/article/details/124878194)  
[《Git笔记 - Git重命名详解》](https://blog.csdn.net/qq_35097289/article/details/133696725)  
[《Commit message 和 Change log 编写指南》](https://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)  