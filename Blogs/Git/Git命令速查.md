# Git 命令速查

## 一、命令速查手册

<details>
<summary> 0. 杂七杂八</summary>  

```bash
# list files in current directory
ls

# print working directory
pwd  

# 查看ssh公钥  
cat ~/.ssh/id_rsa.pub

# 移除对 FolderName 文件夹的跟踪但不删除文件
git rm --cached -r FolderName

# 允许合并不同的历史记录
--allow-unrelated-histories
```
</details>


<details>
<summary> 1. branch </summary>  

```bash
常用：
`git branch -a -vv`
`git branch -m old_name new_name`

其它：
`git branch`                      ：查看本地分支
`git branch -v`                   ：查看本地分支 + 分支最近一次提交信息
`git branch -vv`                  ：查看本地分支 + 分支链接信息 + 分支最近一次提交信息
`git branch -a`                   ：查看本地和远程分支
`git branch -a -v`                ：查看本地和远程分支 + 分支最近一次提交信息
`git branch -a -vv`               ：查看本地和远程分支 + 分支链接信息 + 分支最近一次提交信息
`git branch -m old_name new_name` ：重命名本地分支
```
</details>


<details>
<summary>2. remote </summary>  

```bash
常用：
`git remote -v`
`git remote remove {remote_name}`

其它：
`git remote`                                ：查看链接
`git remote -v`                             ：查看链接信息（详细）
`git remote prune {remote_name}`            ：从删除远程中不存在的本地分支
`git remote prune --dry-run {remote_name}`  ：预览远程中不存在的本地分支
`git remote remove {remote_name}`           ：移除链接 
```
</details>

<details>
<summary>3. commit  </summary>  

```bash
常用：
`git commit -a -m "here is the info"`
`git commit --amend --only -m "here is the info" `

其它：
`git commit`：提交stage区
`git commit -m "here is the info"`：提交stage区 + 备注 "here is the info"
`git commit -a -m "here is the info"`：将更改保存到stage区并提交 + 备注 "here is the info"
`git commit --amend --only -m "here is the info" `：撤回上次提交并重新提交信息
```
</details>


<details>
<summary>4. reset </summary>  

```bash
常用：
`git reset HEAD^`
`git reset --hard {commit_hash}`

其它：
`git reset HEAD^`：返回到上个版本
`git reset HEAD^^`：返回到上上个版本
`git reset HEAD-10`：返回到十个版本前版本
`git reset --hard {commit_hash}`：重置到某一版本（包括日志+暂存区+工作区）

已 add 未 commit：
`git restore --staged .`

已 commit 未 push：
`git reset --soft {commit_hash}`：
`git reset --mixed {commit_hash}`：

已 push：
`git reset --hard {commit_hash}`：
`git revert {commit_hash}`：
```
</details>


<details>
<summary>5. mv 和 rm </summary>  

```bash
常用：
`git mv {new_file_name} {old_file_name}`
`git rm {file_name}`

其它：
`git mv {new_file_name} {old_file_name}`：移动或重命名文件（夹）
`git rm {file_name}`：删除文件（夹）
`git rm --force {file_name}`：从工作区和暂存区彻底删除
```
</details>


<details>
<summary> 6. merge</summary>  

```bash
常用：
`git merge --no-ff {local_branch_name} -m "merge bra_1 into bra_2"`

其它：
`git merge {local_branch_name}`：将某分支快速合并到当前分支
`git merge --no-ff {local_branch_name}`：
```
</details>

<details>
<summary>7. tag </summary>  

```bash
常用：
`git tag`：
`git tag -l 'V1*'`：列出本地 "V1" 开头的标签

其它：
`git tag`：查看本地标签
`git tag -l 'V1*'`：列出本地 "V1" 开头的标签
`git ls-remote --tags {remote_name}`：查看远程库标签
`git tag {tag_name}`：（在当前位置）打快速型标签
`git tag -a {tag_name} -m {note}`：（在当前位置）打注释型标签
`git tag {tag_name} {commitID}`：在某一提交处打快速型标签
`git tag -a {tag_name} -m {note} {commitID}`：在某一提交处打注释型标签
`git tag -d {tag_name_1} {tag_name_2}`：删除本地标签
```
</details>


<details>
<summary> 8. push</summary>  

```bash
常用：
`git push {remote_name} {remote_branch_name_1} {remote_branch_name_2}`
`git push {remote_name} --tags`

分支：
`git push {remote_name} {remote_branch_name} `：推送（当前）本地分支到远程分支
`git push {remote_name} {remote_branch_name_1} {remote_branch_name_2}`：推送当前分支到多个远程分支
`git push --force {remote_name} {remote_branch_name} `：用当前本地分支覆盖远程分支
`git push {remote_name} -d {remote_branch_name}`：删除远程分支

标签：
`git push {remote_name} {tag_name_1} {tag_name_2}`：将本地标签推送到远程
`git push {remote_name} --tags`：将全部本地分支推送到远程
`git push {remote_name} tag -d {tag_name_1} {tag_name_2}`：删除远程标签
`git push {remote_name} {tag_name_1} {tag_name_2}`：推送本地标签到远程
`git push {remote_name} --tags`：推送全部本地标签到远程
```
</details>


<details>
<summary>9. show </summary>  

```bash
常用：
`$ git show -s {name}`：显示简略信息

其它：
`git show {name}`：显示信息
`git show {name} -s`：显示信息（简略）
```
</details>


<details>
<summary>10. clone </summary>  

```bash
常用：
`git clone {git-url}`

其它：
`git clone {git-url}`：克隆远程到本地
```
</details>


<details>
<summary>  11. config</summary>  

```bash
常用：
`git config --gl -l`：查看全局设置
`git config --global user.name`：
`git config --global user.email`：

其它：
`git config --gl -l`：查看全局设置
`git config [--local|--global|--system] --list`：查看 [ 本地 | 全局 | 系统 ] 设置

我的常用配置：
git config --global user.name "YiDing"
git config --global user.email "dingyi233@mails.ucas.ac.cn"
git config --global init.defaultBranch main # 配置初始化仓库的默认分支名
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -10"  # 配置后 git lg 的信息大概是 (有颜色区别，显示最近 10 条commit)：* 84b2f5d - here is the info (45 minutes ago) <Author> 


git config --global alias.a "add ."           # git a 等同于 git add .
git config --global alias.c "commit -a -m"    # git c "message" 等同于 git commit -a -m "message"
git config --global alias.u "c 'update'"      # git u 等同于 git commit -a -m "update"
git config --global alias.s "status"          # git s 等同于 git status
git config --global alias.pl "pull"           # git pl 等同于 git pull
git config --global alias.ps "push"           # git ps 等同于 git push
################### 下面的命令需要配合 .sh Shell 脚本来使用 ####################
git config --global alias.e '!sh -c \"ShellScript/git-e.sh"'
git config --global alias.s '!sh -c \"ShellScript/git-s.sh"'

# 若要自定义其它配置，参考官方文档file:///D:/aa_my_apps_main/Git/mingw64/share/doc/git-doc/git-log.html
```
</details>

<details>
<summary> 12. log</summary>  

```bash
常用：
`git lg`：自定义的log查看
`git shortlog`：仅查看commit备注

其它：
`git log`：查看日志
`git log --oneline`：用一行形式查看日志
`git shortlog`：查看贡献者commit备注
```
</details>


## 二、简写对照表

常用命令简写表 ：

<div class='center'> 

| 简写 | 全拼 |
| ------ | ------ |
| `--gl` | `--global`|
| `-l` | `--list` |
| `-v` |`--verbose` |
| `-vv` | `--verbose --verbose` |
|`-a`  |`--all` 或 `--annotate` |
| `-d` |`-delete`  |
| `-f` |`--force`  |
| `-m` | `--move` 或 `--message=` |
| `-r`| `--remote` |
| `-u` | `--set-upstream` |
| `-s` | `--short` |

</div>