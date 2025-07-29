# Use Virtuoso Efficiently - 2. File Transfer using Shared Folders

> [!Note|style:callout|label:Infor]
> Initially published at 18:35 on 2025-07-22 in Beijing.


## 1. 背景

Cadence Virtuoso 是一个只能在 Linux 系统上运行的专业/商用集成电路设计软件，大多数主机为 windows 的用户，会选择将其安装到合适的虚拟机上 (如 VMware, VirtualBox 等)。此时，如何在主机 (windows) 和虚拟机之间传输文件就成了一个问题。虽然可以通过网络传输文件，但这相当麻烦，尤其是传输文件较多较大的场合，更别说有的虚拟机没有进行网络配置，无法连接网络。


如何解决这个问题？最简单的方法就是在主机和虚拟机之间建立一个 "共享文件夹"，这个特殊的文件夹可以 "同时存在于主机和虚拟机中"，这样就可以像访问本地文件一样，轻松地在两者之间传输文件了。


## 2. 创建并使用共享文件夹


创建共享文件夹的主要步骤为：
- 在虚拟机设置中启用共享文件夹功能
- 在虚拟机中创建挂载点并挂载共享文件夹
- 在虚拟机或主机中访问共享文件夹



具体步骤如下：

- (1) 在虚拟机主页面打开 `设置 > 选项 > 共享文件夹`, 选择 `总是启用`
- (2) 点击 `添加`，自动进入共享文件夹向导页面

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-12-23-16_How to Use Cadence Efficiently.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-12-24-17_How to Use Cadence Efficiently.png"/></div>


- (3) 填入合适的主机路径，或者点击 `浏览` 选择需要共享的文件夹，`名称`即为此文件夹在虚拟机显示的名称，建议与文件夹名称相同。例如，我们共享 `D:\Test_Folder`，如图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-12-30-04_How to Use Cadence Efficiently.png"/></div>

- (4) 点击 `下一步`，点击 `完成`，完成设置
- (5) 现在，共享文件夹已经创建完成，我们还需要在虚拟机中“挂载”才能找到这个文件夹
- (6) 在虚拟机中，右键打开终端，先进入 root 模式：

```bash
su - root   # 切换到 root 用户 (需要输入密码)
```

- (7) 输入以下命令创建并挂载共享文件夹 (假设共享文件夹名称为 `Test_Folder`，虚拟机中挂载点为 `/home/IC/Test_Folder`):

```bash
sudo mkdir -p /home/IC/Test_Folder
sudo mount -t fuse.vmhgfs-fuse .host:/Test_Folder  /home/IC/Test_Folder -o allow_other
```

- (8) `-o allow_other` 表示普通用户也能访问共享目录。挂载成功后，即可在 `/home/IC/Test_Folder` 目录下访问主机共享的文件夹内容。若提示找不到 `vmhgfs-fuse`，请先安装：

```bash
sudo apt update
sudo apt install open-vm-tools open-vm-tools-desktop
```

这样，共享文件夹就创建完成了。例如，我们将主机的某个文件放入共享文件夹，便可以从虚拟机中访问到这个文件：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-05-22-13-07-35_How to Use Cadence Efficiently.png"/></div>

另外，我们还可以继续创建多个共享文件夹（只需重复上述步骤），共享文件夹不会额外占用存储空间，不必担心硬盘空间不足。


上面所有步骤的代码汇总如下：

```bash
su - root   # 切换到 root 用户 (需要输入密码)

sudo mkdir -p /home/IC/Test_Folder  # 创建 Test_Folder, 用于挂载主机的 Test_Folder 文件夹
sudo mount -t fuse.vmhgfs-fuse .host:/Test_Folder  /home/IC/Test_Folder -o allow_other  # 挂载主机的 Test_Folder 文件夹

sudo mkdir -p /home/IC/a_Win_VM_shared  # 创建 a_Win_VM_shared, 用于挂载主机的 a_Win_VM_shared 文件夹
sudo mount -t fuse.vmhgfs-fuse .host:/a_Win_VM_shared  /home/IC/a_Win_VM_shared -o allow_other  # 挂载主机的 a_Win_VM_shared 文件夹

vmware-hgfsclient # 查看当前虚拟机的共享文件夹 (有无挂载都会显示)
```

## 3. "永久" 挂载共享文件夹

注意：到这个时候，共享文件夹的挂载仍是一次性的，重启虚拟机后需要重新挂载。为解决这个问题，我们在虚拟机的 `/etc/fstab` 文件中添加一行 `.host:/a_Win_VM_shared /home/IC/a_Win_VM_shared fuse.vmhgfs-fuse allow_other,defaults 0 0`。但 `/etc/fstab` 通常是只读的，需要在 bash 中使用管理员权限编辑它：

```bash 
tail -n 5 /etc/fstab  # 查看文件末尾 5 行内容
printf '.host:/a_Win_VM_shared /home/IC/a_Win_VM_shared fuse.vmhgfs-fuse allow_other,defaults 0 0\n' | sudo tee -a /etc/fstab   # 将共享文件夹挂载信息添加到 /etc/fstab 文件末尾, 以实现重启后自动挂载
tail -n 5 /etc/fstab  # 再次查看文件末尾 5 行内容, 检查是否添加成功
```

如果想像 windows 的文本编辑器一样编辑 `/etc/fstab` 文件，可以使用 `gedit` 编辑器打开文件：

``` bash
# 使用 gedit 编辑器打开 /etc/fstab 文件
sudo gedit /etc/fstab
```

修改完成后，`ctrl+s` 保存即可。

