# 主流云盘网盘对比

## 网盘存储

> [!Note|style:callout|label:Infor]
Initially published at 16:22 on 2024-09-23 in Beijing.


下面是主流网盘、云盘存储免费用户的权益对比，`-` 符号表示无。


<div style='font-size:10px'><div class='center'>

| 网盘 / 云盘 | 空间大小 | 下载速度 | 下载或预览限制 | 上传文件 | 文件分享限制 |
|:-:|:-:|:-:|:-:|:-:|:-:|
 | 123 云盘 | 2 T | 不限速 | 分享 100M 以内的小文件不受流量限制且免登录下载；下载流量 PC 端、网页端 10 GB / 天（在线预览不消耗流量），手机端无限制 | 最大 100 GB  | 不可分享音视频，其它无任何限制 |
 | 百度网盘 |  2 T |  限速严重  | 需要登录 | 最大 4 GB| - | 
 | 阿里云盘 | 100 GB | 限速 | 必须保存到自己的阿里云才可下载或预览 | 100 GB | - |
 | 腾讯微云 | 10 GB |  |  |  |  |
 | mCloud（中国移动云盘） | 移动用户 20 GB + 20 GB，非移动用户 10 GB + 10 GB | 不限速 | 需要登录 | 最大 4 GB| 分享链接限制 5000 次访问 |
 | Cloud189（天翼云盘） | 30 GB + 30 GB | 不限速 | 需要登录 | 最大 2 GB，每日 2 GB 上传流量 | 不可一次分享多个文件 |
</div></div>

## 同步空间

### 123 云盘

123 的同步空间与云盘存储共用免费 2 T 空间，上传下载无限速，每月有 10 GB 上传流量，下载流量无限制。

但是我个人（我的环境是 Windows 11）在使用过程中经常会报 Bug “系统错误”，此时无法进入同步空间，同步工作也无法进行，需要重启应用。在未关闭应用的情况下，临时断网并重连，有极大概率会报错。在未断网的正常使用时，时间一长也可能会报错。另外，我使用同步空间主要是为了在不同设备上同步笔记，同时也会定期在 Github 上更新，但存放在 123 同步空间文件夹下的 `.git` 文件夹有时无法正常使用，例如在工作区文件夹 `git add .` 时会报路径错误，重启 123 网盘才能解决。另外，在不同设备上同时提交了同一文件的不同的更新时，会直接发生覆盖，丢失其中一个文件的更新。

### 百度网盘

老牌大厂，同步较快且基本没有什么问题，这没话说。但是老问题，免费版体验感极差，不多说。

- 免费版：永久 1 GB 上传流量（不会刷新，我隔了三个月再看也没有重置流量），下载流量无限制，与网盘存储共用空间限制，上传无限速，下载 5 MB 小文件未观察到明显限速，大文件没试过。
- VIP 连续包年：第一年 165 元，此后 188 元 / 年。无限同步流量，无限速。
- SVIP 连续包年：第一年 170 元，此后 263 元 / 年。


### 坚果云

- 免费版：10 GB 同步空间，上传流量 1 GB / 月，下载流量 3 GB / 月，无限速
- 专业版：30 GB 同步空间，上传流量 1 GB / 月，下载流量 3 GB / 月，无限速

坚果云有几个比较突出的好处：
1. 可以不将文件夹移动到同步空间，而是直接右键添加同步路径（123 云盘和百度网盘好像也可以？）

考虑到这个特性，可以将文件夹同时添加到坚果云和 123 云盘的同步路径（右键添加即可），便能同时在两个平台上进行同步，提供较高的同步保障，实测可行。

2. 手机、平板和电脑都可以通过 APP 访问同步空间。而 123 云盘和百度网盘的移动端应用就没有同步空间这个入口，无法直接访问（只能通过网页端）。
3. 在不同设备上同时提交了同一文件的不同的更新时，会提示文件同步冲突，并暂停此文件的同步，等待处理。

另外，可以在线预览大多数文件（`.mp4` 等视频文件需要会员），但预览会消耗下载流量。

## 结论

目前我的使用情况是，坚果云用于同步笔记（与 123 云盘同时同步，提供双重保障），123 云盘用于存放文件，不使用百度网盘。不需要保存在本地的文件上传到 123 后即可删除本地文件，需要同时保存在本地和云端的大文件（夹）使用 123 同步空间（比如我的 `MyEBooks` 文件夹，约 5 GB）。文件保存在本地是为了方便离线使用以及 Everything 搜索，因为 123 云盘的搜索功能比较抽象（截至 2024.10.2），比如我有一个名为 `test.txt` 的文件，和一个名为 `test` 的文件夹，输入 `test` 进行搜索是能正常找到它们的，但是输入 `t`、`te` 以及 `tes` 是都搜索不到的，也就是说必须匹配整个输入词才能搜索到（试过了输入 `t e s t` 也不行）。

上面提到“需要同时保存在本地和云端的大文件（夹）使用 123 同步空间”，这里改为使用 123 云盘存储而非同步空间，因为同步空间无法分享文件夹或文件，而我经常需要将资料分享给他人。