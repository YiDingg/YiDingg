# MOS 器件 TCAD 仿真及 SPICE 模型

> [!Note|style:callout|label:Infor]
> Initially created by YiDingg at 18:44 on 2026-10-15 in Beijing.
> dingyi233@mails.ucas.ac.cn

## 1. 软件安装与准备

- 123 云盘：
- 百度网盘：https://pan.baidu.com/s/1uktE377XT23fObrUMy9gqA?pwd=8888
- 安装参考：就看资源链接里的教程即可，安装很简单
- 字号修改：
    - https://zhuanlan.zhihu.com/p/639052191



## 2. AI 与虚拟机建立通信连接



**通信链路**：虚拟机以 VMware NAT 模式接入（网段 192.168.220.0/24，地址 192.168.220.128，由 VMware DHCP 保留绑定），宿主机侧 `VMware Network Adapter VMnet8` 为该网段网关。虚拟机内 `sshd` 常驻，因此宿主机与虚拟机之间只需 TCP 22 端口即可建立全双工命令行通道，无需 VMware Tools 的客户机操作接口（Workstation 17 的 guest 操作需登录凭据，反而更麻烦）。地址可通过 `vmrun -T ws list` 确认虚拟机在跑，再从 `C:\ProgramData\VMware\vmnetdhcp.leases` 读取其租约。

**身份认证**：采用 SSH 公钥认证。宿主机的 `~/.ssh/id_rsa.pub` 追加到虚拟机 `~/.ssh/authorized_keys`（权限 `700`/`600`，属主为该用户；RHEL 6 默认启用 SELinux，必要时执行 `restorecon -R ~/.ssh` 修正安全上下文）。密钥登录成功后不再需要任何密码，脚本可全自动执行。虚拟机为 RHEL 6.9，其 OpenSSH 仅支持 `ssh-rsa`/`ssh-dss` 主机密钥，新版客户端必须显式放行：

```bash
ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa tcad2017@192.168.220.128 "命令"
```

**命令执行与文件交换**：所有远程操作都是「一条 ssh 命令 + 命令串」，非交互、可批处理；涉及 Sentaurus 的命令必须先载入环境（设置 PATH、`STDB` 与 license 变量），例如 `source /usr/synopsys/sen_env.sh && sdevice -v`。文件用 `scp` 同选项双向传输：工程目录上传到 `~/work/<项目>/`，仿真结果与日志再取回宿主机，避免污染用户主目录。

**图形界面**：需要让程序显示在虚拟机桌面时，不能只设 `DISPLAY=:0`（缺少 X cookie 会被拒绝）。正确做法是从已登录图形会话的进程环境中取出真实的显示变量，再脱离 SSH 会话启动程序：

```bash
export DISPLAY=:0 XAUTHORITY=/var/run/gdm/auth-for-<用户>-*/database
nohup eog 图片.png >/tmp/eog.log 2>&1 &
```

可用 `xwininfo -root -tree` 确认窗口已映射；宿主机侧用 PowerShell 截屏即可作为「已在虚拟机桌面显示」的凭证。

**安全与边界**：该用户无免密 sudo，普通操作（跑仿真、传文件、读 license 状态）全部可自动完成，涉及改系统配置才需人工授权；虚拟机需保持开机、NAT 地址不变，关机改 vCPU/内存后再 `vmrun start` 即可恢复。