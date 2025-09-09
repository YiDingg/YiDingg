# Basic Information of tsmcN28 (TSMC 28nm CMOS Process Library) (台积电 tsmcN28 工艺库基本信息)

> [!Note|style:callout|label:Infor]
> Initially published at 22:06 on 2025-09-09 in Lincang.

## 0. PDK Installation

由于我们的虚拟机没有配置网络，只能先将打包好的工艺库文件夹传输到本地 windows, 然后再通过共享文件夹传输到虚拟机中。

将 "练手" 服务器 `182.48.105.253` 的工艺库文件夹打包好：

``` bash
# 将 tsmcN65 工艺库复制到 dy2025 目录下
cp -r /home/library/TSMC/tsmc65n/v1.0c_RF/ /home/dy2025/Cadence_Data/tsmcN65/
cp -r /home/library/TSMC/tsmc65n/user_ref  /home/dy2025/Cadence_Data/tsmcN65/

# 将工艺库打包成压缩包
tar -czvf /home/dy2025/Cadence_Data/tsmcN65.tar.gz /home/dy2025/Cadence_Data/tsmcN65
```

然后在本地 windows 下载打包好的文件：

``` bash
# 将压缩包从服务器 username@111.11.111.111 下载到本地 windows
scp dy2025@182.48.105.253:/home/dy2025/Cadence_Data/tsmcN65.tar.gz D:/a_Win_VM_shared_2_largeFiles/Cadence_Process_Library_Backup/
# 回车后会让输入密码，输入完成再回车即可开始下载
```

上一步如果报错 `Ensure the remote shell produces no output for non-interactive sessions.`, 大概是服务器主机上设置了 shell 初始化文件 `.cshrc` ，将此文件改名为 `ttt.cshrc` 即可暂时禁用，传输完成后再改回来即可。

通过共享文件夹将工艺库传输到虚拟机中，最后打开本地虚拟机，解压并修改 `cds.lib` 文件即可使用。由于我们的虚拟机之前已经自带了一个的 N65 工艺库，这里在 `cds.lab` 中将原有的工艺库重命名为 `tsmcN65_old` 以避免冲突：

``` bash
# 解压工艺库到指定目录
tar -xzvf /home/a_Win_VM_shared_2_largeFiles/Cadence_Process_Library_Backup/tsmcN65.tar.gz -C /home/IC/Cadence_Process_Library/tsmcN65/

# 在 cds.lib 文件中添加工艺库路径

echo "DEFINE tsmcN65_old Tech/65NTSMC/tsmcN65" >> /home/IC/cds.lib
echo "ASSIGN tsmcN65_old DISPLAY ProcessLib" >> /home/IC/cds.lib
echo "DEFINE tsmcN65 /home/IC/Cadence_Process_Library/tsmcN65" >> /home/IC/cds.lib
```

