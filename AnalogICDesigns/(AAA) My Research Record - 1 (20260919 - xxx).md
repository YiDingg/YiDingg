# My Research Record - 1

> [!Note|style:callout|label:Infor]
> Initially created by YiDingg at 21:22 on 2026-09-19 in Beijing.
> dingyi233@mails.ucas.ac.cn



## 1. IBN output > basic

202602_CDR 的 CP 迭代设计中，假设我们已经根据理想 25uA 电流设计好了运放，现在来设计其偏置电路。由于运放已经确定，偏置电路的电流管尺寸也确定了，不妨假设为 NMOS = 1.44u/240n (fW = 720n, fn = 2, mu = 1)。下面就来遍历下不同结构的偏置产生情况，对比不同结构的优缺点。

**目标输出 25uA 偏置 (gate of nmos)。**

- (K, Rs) = (8, 4k) 时，输出 24.8uA @ 176kOhm 似乎达到最优：
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-19-21-55-45_markdown.png"/></div>
- 在此参数附近进一步搜寻，没有找到更好的；最佳性能为 (IBN, ROUT_N, VDD_min @ 100kOhm) = (24.81uA, 175.7kOhm, 0.826V)
- (K, Rs, Rb) = (8, 4k, 0) 的 all-corner 验证，没有问题：
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-19-21-58-13_markdown.png"/></div>

## 2. IBN output > nmos-cascode 

- (K, Rs) = (8, 4k) 时，输出 24.5uA @ 190kOhm 似乎达到最优：
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-19-21-31-36_markdown.png"/></div>
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-19-21-35-16_markdown.png"/></div>
- 在此参数附近进一步搜寻，可以看到 point-21 (K, Rs, Rb) = (8, 4k, 0) 时具有最佳性能，为 (IBN, ROUT_N, VDD_min @ 100kOhm) = (24.55uA, 189.5kOhm, 0.866V)
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-19-21-38-11_markdown.png"/></div>
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-19-21-41-58_markdown.png"/></div>
- point-21 (K, Rs, Rb) = (8, 4k, 0) 的 all-corner 验证，没有问题：
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-19-21-47-33_markdown.png"/></div>


和上面不带 cascode 的对比起来，似乎没有什么优势，反而 headroom 消耗得更多了。



## 3. CP_cascode_variable 仿真迭代 (普通 cascode, 无反馈)

迭代前原尺寸为：
- current nmos: fW/fL = 2.835u/1.0u, fn = 10, mu = 8
- current pmos: fW/fL = 1.500u/1.0u, fn = 10, mu = 8 (ka ≈ 0.53)
- switch nmos:  fW/fL = 1u/30n,, fn = 2, mu = 1
- switch pmos:  = switch nmos

迭代过程记录：
- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-20-22-34-16_markdown.png"/></div>



## 4. Input Logic and BUF for CP

前仿瞬态仿真 @ 10GHz：
- 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-20-23-44-28_markdown.png"/></div>
- 波形：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-20-23-44-04_markdown.png"/></div>


加入 input logic 之后进行仿真：
- 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-00-06-31_markdown.png"/></div>
- EN_11TO00 = 0: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-00-02-45_markdown.png"/></div>
- EN_11TO00 = 1: <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-00-07-19_markdown.png"/></div>
- UP/DN 存在严重的占空比失真。

尝试改善：
- 原理图 `202609_CP_part1_inputLogic_BK_202609210052_tv`：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-00-52-51_markdown.png"/></div>
- 仿真结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-00-53-28_markdown.png"/></div>



## 5. 之前 202602_CDR 中用的 CP 仿真

性能如下：
- CP 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-01-42-06_markdown.png"/></div>
- TB 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-01-41-48_markdown.png"/></div>
- (20uA 模式, EN_dec = 12) DC: IOUT = 234uA, mismatch_abs = 2.75%, ROUT_N/P = 25k/24k <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-01-41-33_markdown.png"/></div>
- (20uA 模式, EN_dec = 12) DC: IOUT = 58.6uA, mismatch_abs = 2.75%, ROUT_N/P = 101k/97k <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-01-50-40_markdown.png"/></div>
- (10uA 模式, EN_dec = 12) DC: IOUT = 117uA, mismatch_abs = 2.72%, ROUT_N/P = 51k/48k <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-01-44-09_markdown.png"/></div>
- (10uA 模式, EN_dec = 03) DC: IOUT = 29.2uA, mismatch_abs = 2.72%, ROUT_N/P = 205k/192k <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-01-46-51_markdown.png"/></div>
- (20uA 模式, EN_dec = 12) DC: Tran: duty_DN/DNB = 45%/55%
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-02-00-40_markdown.png"/></div>
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-02-03-52_markdown.png"/></div>


``` bash
VDD, VDD, VDD, VSS, VSS, VSS, VSS, VSS, VSS, VSS, VSS, VSS, 
VDD,VDD,VDD,VSS,VSS,VSS,VSS,VSS,VSS,VSS,VSS,VSS
```

有了这些结果，我们对自己 CP 应该做到个什么程度便有了具体感受。


## 6. 我们自己的 CP 再仿真

结果如下：
- DC 仿真结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-02-19-19_markdown.png"/></div>
    - 30uA 时： IOUT = 30.0uA,  mismatch_abs = 0.25%, ROUT_N/P = 4.2M/5.3M
    - 100uA 时：IOUT = 99.92uA, mismatch_abs = 0.48%, ROUT_N/P = 1.6M/1.8M
- **注意上面是使用 variable 进行的前仿，填入真实尺寸后，ROUT 似乎会进一步上升 (挺明显的)，同时 mismatch 进一步下降，如图：**
    - 此时对 30uA 有： IOUT = 30.0uA, mismatch_abs = 0.13%, ROUT_N/P = 9.8M/7.6M
    - 此时对 100uA 有：IOUT = 30.0uA, mismatch_abs = 0.19%, ROUT_N/P = 7.5M/8.4M
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-02-21-16_markdown.png"/></div>
    - <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-02-22-58_markdown.png"/></div>

仿真瞬态时，发现每当 UP/DN 翻转时，IBP3/IBN3 就会出现一个接近关断的“波谷”，持续约 16ps，而原先的参考 CP 中这个波谷仅有不到 5ps。16ps 大大限制了其最高工作速率。

修改了 TG 开关的尺寸，没有作用。又怀疑是 cascode 导致的，但是换为 basic 结构之后，瞬态波形基本没有区别，所以问题出在哪里？<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-03-40-14_markdown.png"/></div>

又怀疑是 lvt 的问题。换为 ulvt 发现还是一样的。并且无论是 10uA 还是 100uA，都有很明显的 Ibias 波动。

换为实际 UP/DN 驱动电路后。似乎就正常了？




## 7. mismatch canlc. CP 环路再尝试

本 CP 环路相关理论分析：
- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-12-10-39_markdown.png"/></div>
- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-12-10-44_markdown.png"/></div>
- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-12-14-52_markdown.png"/></div>

- 方法一：电流管采用更低的 length 等尺寸，尝试牺牲 ROUT 以换取 mismatch cancel 稳定性
- 方法二：将运放配置为 diff-in sing-out 且增益为 1 (或更低) 的形式
- 方法三：运放输出串联一个 source-follower 降低输出电阻，以期提升环路其中一个低频极点

### 方法一：电流管采用更低的 length 等尺寸，以换取 mismatch cancel 稳定性


### 方法二：将运放配置为 diff-in sing-out 且增益为 1 (或更低) 的形式

配置为中心点 VDD/2，增益 0.2V/V 的放大器：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-14-22-34_markdown.png"/></div>


配置为中心点 VDD/2，增益 2.0V/V 的放大器：
- AMP 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-15-43-23_markdown_tv.png"/></div>
- 仿真结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-15-42-33_markdown_tv.png"/></div>
- AMP ac 结果：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-15-44-32_markdown_tv.png"/></div>
- 代入 CP 环路中，发现 dc 效果并不好：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-15-54-41_markdown_tv.png"/></div>

遂放弃。


## CP 环路再仿真

dc 下的可行参数之一 (参考之前的 ref CP):
- CP 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-15-51-19_markdown_tv.png"/></div>
- 参数：
    - IREF = 100 uA @ mu = 10
    - ka = 1.5
    - (fn, fW/fL) = (3, 1u/200n)
- 性能：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-15-51-05_markdown_tv.png"/></div>
    - IOUT = 100.3uA
    - mismatch = 0.0225% (带有 mismatch 反馈)
    - ROUT_N/P = 115k/117k
    - totalW = 75u




### 方法三：运放输出串联一个 source-follower 降低运放输出电阻



## CP 环路再仿真

dc 下的可行参数之一 (参考之前的 ref CP):
- CP 原理图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-15-51-19_markdown_tv.png"/></div>
- 参数：
    - IREF = 100 uA @ mu = 10
    - ka = 1.5
    - (fn, fW/fL) = (3, 1u/200n)
- 性能：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-15-51-05_markdown_tv.png"/></div>
    - IOUT = 100.3uA
    - mismatch = 0.0225% (带有 mismatch 反馈)
    - ROUT_N/P = 115k/117k
    - totalW = 75u


## 拯救者笔记本禁用本机键盘方法

参考 [CSDN > 禁用系统键盘 (包括拯救者)](https://blog.csdn.net/qq_35494624/article/details/143423432) 中修改驱动的那种方法，成功：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-09-21-22-07-01_markdown.png"/></div>

新键盘按 F1 可打开 edge 的帮助页面，在手动点击 edge 无反应时好用。


## TG with crosstalk cancellation

尝试了 TG_cancelXT (with crosstalk cancellation), 发现几乎没有效果 (为什么？是因为 charge injection 占主导而 crosstalk 很小吗)，如图：





## 2026.10.08 ~ 2026.10.10

- [x] 202602_CDR 项目回顾与总结
- [x] TB_OPA tran: overshoot, SR


## 2026.10.11 IDAC 设计

### 1. 结构选型

同为 IOUT_PR，在相同的晶体管尺寸与电阻条件下，我们来探究受控管为 NMOS/PMOS 两种结构谁更好 (主要是噪声，速度的话一般仅用于 DC)，猜测 PMOS 受控会更好些，因为此时 VDAC 到 VOUT 的增益 = R_D/R_S < 1。

两种结构如下图：
- stc1 (PMOS 受控)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-03-44-02_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>
- stc2 (NMOS 受控)：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-03-44-39_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>

两种结构在 dc 上的功能都通过了验证，我们根据 xxx 指标来看看谁更优。

缺点：
- stc2 (NMOS 受控)：电流镜消耗明显 voltage headroom，导致 VDAC 很大时受控 NMOS 才打开，IDAC 难以进入 "线性区" <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-03-56-19_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>


### 2. stc1 (PMOS 受控) 迭代 for 0 ~ 100uA


- 迭代前 (RS, RB) = (14k, 2k) 的初始性能：IOUT = 21.68uA (19.51 ~ 24.03), PVT 波动不大，完全可以接受，如图：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-04-23-07_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>
- 大电流时 (75uA ~ 80uA) 对比 stc1, stc3, stc4 可以看出 low-voltage cascode 在多方面性能都最佳：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-04-31-51_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>
- 由于大电流下 Rout 性能恶化，以及线性区缩短导致 VDAC 可用范围缩短 (电流分辨率降低)，我们考虑采用：每个 cell 0 ~ 10 uA，多 cell 数控并联来适应不同输出范围
- 下面以输出 0 ~ 10 uA 为目标进行优化
- 我们对比了 ulvt, lvt, svt, hvt, uhvt 共五种阈值的 PMOS 受控管，发现 vdac_effectiveRange 基本没有变化 (不到 ±2mV 的差距)，因此还是用 svt 管子了 <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-05-10-34_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>
- 初步选定 RS = 37k ~ 40k <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-05-17-37_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>
- 然后调整 RB 阻值：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-05-24-40_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>
- 调整至较大的 RB 值，同时适当减小 RS：得到最佳参数为 (RS, RB) = (36k, 10k) or (36.5k, 9k) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-05-32-57_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>
- 小幅度调整 fW, fL 和 VDD：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-05-38-01_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>
- 注意 IOUT_max 与 VDD 有关 (约 20 uA/V, 即 2uA/0.1V)，如何提高 PSR? (dc 没想到啥好办法，ac 可以适当加些电容) <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-05-38-48_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>
- 尝试降低了 RB 的值，发现没用：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-05-42-21_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>
- 看一下当前最佳参数的 PVT 情况，没有什么大问题：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-05-45-10_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>
- 将管子、电阻实际参数填入电路，电阻 PVT 考虑进去后，IOUT_max PVT 波动更大，但其它性能不怎么变：<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-10-11-05-58-26_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>


ac:
- PSR (VDD to IOUT)
- VDAC to IOUT


## 2026.10.12 服务器 AI 部署尝试

【virtuoso-bridge喂饭教程（自动版）-哔哩哔哩】 https://b23.tv/8sy0V1S
【virtuoso-bridge喂饭教程（手动版）-哔哩哔哩】 https://b23.tv/sFqpUfc
教程与示例连接：https://virtuoso-bridge.tokenzhang.com/#start

``` bash


cd virtuoso-bridge-lite; $env:Path += ";$env:USERPROFILE\.local\bin"; uv --version;
uv venv .venv; .venv\Scripts\activate; uv pip install -e .;

ssh -p 2222 dy2025@111.198.29.104
virtuoso-bridge init dy2025@111.198.29.104

# (ssh -p 22122 dy2025@111.198.29.104 可以直接连通)

```

### 解决 virtuoso-bridge start 失败


``` bash
virtuoso-bridge start
using .env: C:\Users\13081\.virtuoso-bridge\.env
Starting tunnel...
[cmd] C:\Windows\System32\OpenSSH\ssh.EXE -o BatchMode=yes -o ConnectTimeout=30 -o GSSAPIAuthentication=no -o HostbasedAuthentication=no -o ControlMaster=auto -o ControlPath=C:\Users\13081\AppData\Local\Temp\vb_ssh_1d4da7259b6f8558 -o ControlPersist=3600 dy2025@111.198.29.104 sh -l
[cmd] C:\Windows\System32\OpenSSH\ssh.EXE -o BatchMode=yes -o ConnectTimeout=30 -o GSSAPIAuthentication=no -o HostbasedAuthentication=no dy2025@111.198.29.104 sh -l
[cmd] C:\Windows\System32\OpenSSH\ssh.EXE -o BatchMode=yes -o ConnectTimeout=30 -o GSSAPIAuthentication=no -o HostbasedAuthentication=no dy2025@111.198.29.104 sh -l
SSH to 111.198.29.104 failed.
  Check VB_DAEMON_HOST (or legacy VB_REMOTE_HOST) and VB_REMOTE_USER in your .env file.
  Verify: ssh dy2025@111.198.29.104
  For a local VM, use the VM's IP (run `ip addr` inside the VM).
  Details: No Python interpreter found on 111.198.29.104 (daemon host). Detection output: ''. SSH stderr: 'banner exchange: Connection to UNKNOWN port -1: Connection refused'. SSH return code: 255

(base) (.venv) PS E:\aa_MyResearch_and_Study\misc\20261012_AI_for_server_test\virtuoso-bridge-lite> ssh dy2025@111.198.29.104
ssh: connect to host 111.198.29.104 port 22: Connection refused
```


``` bash
EN = 0 -> T<7:0> = 0

EN = 1 -> T<0> = 1
L<0> = 1 -> T_sum = 1
L<1> = 1 -> T_sum = 1
L<2> = 1 -> T_sum = 2
L<3> = 1 -> T_sum = 3
L<4> = 1 -> T_sum = 4
L<5> = 1 -> T_sum = 5
L<6> = 1 -> T_sum = 6
L<7> = 1 -> T_sum = 7

D<2:0>_dec  sum{T<0:15>}   sum{T<1:15>}
00              01                  00
01              02                  01
02              03                  02
03              04                  03
......
14              15                  14
15              16                  15
D_dec = EN_num - 1, EN_num = D_dec + 1
where EN_num = sum{T<0:15>}

3-bit binary to thermometer converter:
D<2:0>_dec  sum{T<0:7>}   sum{T<1:7>}
00              01                  00
01              02                  01
02              03                  02
03              04                  03
......
06              07                  06
07              08                  07
D_dec = EN_num - 1, EN_num = D_dec + 1
where EN_num = sum{T<0:7>}
```

### virtuoso-bridge 前仿迭代功能测试成功


## 2026.10.14 CP 设计与迭代

- 利用 virtuoso-bridge + ClawsGO 迭代了一个 rail-to-rail-input-output two-stage folded-cascode opamp for CP，主要关注稳定性和瞬态性能，毕竟配置为 unit gain amp 使用时，输出不能 "到处过冲"


``` bash
- library: MyLib_amsLib_tsmcN28
- TB: TB_CP
- DUT: 202609_CP_cascode_variable

任务：对 202609_CP_cascode_variable 做仿真迭代优化，以获得更好的瞬态和 dc 性能。各参数初始值已在 TB 中给出，目标迭代次数约 300 次，在保证 dc current mismatch 较小的前提下尽量优化瞬态响应。

详细要求：
- 迭代开始前截图并展示当前聚焦的 TB，随后在 TB 上以起始参数运行一次仿真，截图并展示起始性能
- 可结合 “模拟 IC 设计师视角” 和 “统计迭代视角” 来优化你的迭代过程
- 所有 effective design variable 都可大幅改动，但需保证可靠性、可实现性，符合实际情况
- 硬性 spec 要求 (未提到的可在和我确认后做适当牺牲)：
    - dc: 
        - IOUT_mis_abs_ave (%) < 5
        - VOUT_headroom_low @ 10% < 200m
        - VOUT_headroom_high @ 10% < 200m
        - ROUT_N @ mid > 200k
        - ROUT_P @ mid > 200k
    - tran: 
        - surplus current: IOUT_integ_surplus_abs (%) < 5
        - settling time: settlingTime_ave < 50p
        - overshoot: os_ave < 100 (避免出现 ave 较好但是某个 os 值特别差)
- 尽量优化 (优先级从高到低)：
    - settlingTime_ave
    - 其它所有性能指标同优先级，待你做取舍

其它：
- IREF = 20 uA, mu = 1 保持不变
- cap value 保持不变
```




``` bash
- library: MyLib_amsLib_tsmcN28
- TB: TB_CP
- DUT: 202609_CP_cascode_variable

任务：对 202609_CP_cascode_variable 做仿真迭代优化，以获得更好的瞬态和 dc 性能。各参数初始值已在 TB 中给出，目标迭代次数约 500 次，在保证 dc current mismatch 较小的前提下尽量优化瞬态响应。

详细要求：
- 迭代开始前截图并展示当前聚焦的 TB，随后在 TB 上以起始参数运行一次仿真，截图并展示起始性能
- 可结合 “模拟 IC 设计师视角” 和 “统计迭代视角” 来优化你的迭代过程
- 所有 effective design variable 都可大幅改动，但需保证可靠性、可实现性，符合实际情况
- 硬性 spec 要求 (未提到的可在和我确认后做适当牺牲)：
    - dc: 
        - IOUT_delta_abs (%) @ VDD/2 < 1
        - IOUT_mis_abs_ave (%) < 3
        - VOUT_headroom_low @ 10% < 170m
        - VOUT_headroom_high @ 10% < 170m
        - ROUT_N @ mid > 200k
        - ROUT_P @ mid > 200k
    - tran: 
        - surplus current: IOUT_integ_surplus_abs (%) < 3
        - settling time: settlingTime_ave < 50p
        - overshoot: os_ave < 70 (避免出现 ave 较好但是某个 os 值特别差)
- 尽量优化 (优先级从高到低)：
    - settlingTime_ave
    - 其它所有性能指标同优先级，待你做取舍，都尽量优化一下

其它：
- IREF = 20 uA, mu = 1 保持不变
- cap value 保持不变
```








``` bash
- library: MyLib_amsLib_tsmcN28
- TB: TB_CP
- DUT: 202609_CP_cascode_variable

任务：对 202609_CP_cascode_variable 做仿真迭代优化，以获得更好的瞬态和 dc 性能。各参数初始值已在 TB 中给出，目标迭代次数约 500 次，在保证 dc current mismatch 较小的前提下尽量优化瞬态响应。

详细要求：
- 迭代开始前截图并展示当前聚焦的 TB，随后在 TB 上以起始参数运行一次仿真，截图并展示起始性能
- 可结合 “模拟 IC 设计师视角” 和 “统计迭代视角” 来优化你的迭代过程
- 所有 effective design variable 都可大幅改动，但需保证可靠性、可实现性，符合实际情况
- 硬性 spec 要求 (未提到的可在和我确认后做适当牺牲)：
    - dc: 
        - IOUT_delta_abs (%) @ VDD/2 < 0.3
        - IOUT_mis_abs_ave (%) < 1
        - VOUT_headroom_low @ 10% < 135m
        - VOUT_headroom_high @ 10% < 135m
        - ROUT_N @ mid > 3M
        - ROUT_P @ mid > 3M
    - tran: 
        - surplus current: IOUT_integ_surplus_abs (%) < 3
        - settling time: settlingTime_ave < 50p
        - overshoot: os_ave < 70 (避免出现 ave 较好但是某个 os 值特别差)
- 尽量优化 (优先级从高到低)：
    - settlingTime_ave
    - 其它所有性能指标同优先级，待你做取舍，都尽量优化一下

其它：
- IREF = 20 uA, mu = 1 保持不变
- cap value 保持不变
```


``` bash
我修改了 TB 中与 settling time 有关的几条 outputs 表达式。
你在当前 “稳健解” 的基础上，做进一步迭代：

- library: MyLib_amsLib_tsmcN28
- TB: TB_CP
- DUT: 202609_CP_cascode_variable
任务：对 202609_CP_cascode_variable 做仿真迭代优化，以获得更好的瞬态和 dc 性能。各参数初始值已在 TB 中给出，目标迭代次数约 500 次，在保证 dc current mismatch 较小的前提下尽量优化瞬态响应。
详细要求：
- 迭代开始前截图并展示当前聚焦的 TB，随后在 TB 上以起始参数运行一次仿真，截图并展示起始性能
- 可结合 “模拟 IC 设计师视角” 和 “统计迭代视角” 来优化你的迭代过程
- 所有 effective design variable 都可大幅改动，但需保证可靠性、可实现性，符合实际情况
- 硬性 spec 要求 (未提到的可在和我确认后做适当牺牲)：
    - dc: 
        - IOUT_delta_abs (%) @ VDD/2 < 0.3
        - IOUT_mis_abs_ave (%) < 1
        - VOUT_headroom_low @ 10% < 135m
        - VOUT_headroom_high @ 10% < 135m
        - ROUT_N @ mid > 3M
        - ROUT_P @ mid > 3M
    - tran: 
        - surplus current: IOUT_integ_surplus_abs (%) < 3
        - settling time: settlingTime_ave < 50p
        - overshoot: os_ave < 70 (避免出现 ave 较好但是某个 os 值特别差)
- 尽量优化 (优先级从高到低)：
    - settlingTime_ave
    - 其它所有性能指标同优先级，待你做取舍，都尽量优化一下
其它：
- IREF = 20 uA, mu = 1 保持不变
- cap value 保持不变
```


``` bash
- library: MyLib_amsLib_tsmcN28
- TB: TB_CP
- DUT: 202609_CP_basic_variable
任务：对 202609_CP_basic_variable 做仿真迭代优化，以获得更好的瞬态和 dc 性能。各参数初始值已在 TB 中给出，目标迭代次数约 500 次，在保证 dc current mismatch 较小的前提下尽量优化瞬态响应。
详细要求：
- 迭代开始前截图并展示当前聚焦的 TB，随后在 TB 上以起始参数运行一次仿真，截图并展示起始性能
- 可结合 “模拟 IC 设计师视角” 和 “统计迭代视角” 来优化你的迭代过程
- 所有 effective design variable 都可大幅改动，但需保证可靠性、可实现性，符合实际情况
- 硬性 spec 要求 (未提到的可在和我确认后做适当牺牲)：
    - dc: 
        - IOUT_delta_abs (%) @ VDD/2 < 0.3
        - IOUT_mis_abs_ave (%) < 1
        - VOUT_headroom_low @ 10% < 135m
        - VOUT_headroom_high @ 10% < 135m
        - ROUT_N @ mid > 1M
        - ROUT_P @ mid > 1M
    - tran: 
        - surplus current: IOUT_integ_surplus_abs (%) < 3
        - settling time: settlingTime_ave < 50p
        - overshoot: os_ave < 70 (避免出现 ave 较好但是某个 os 值特别差)
- 尽量优化 (优先级从高到低)：
    - settlingTime_ave
    - 其它所有性能指标同优先级，待你做取舍，都尽量优化一下
其它：
- IREF = 20 uA, mu = 1 保持不变
- cap value 保持不变

先把你要提问的问好，然后我就等任务结束才来看了
```







``` bash
你的 “最优” 参数，最小分辨率不符合我之前的要求 (比如 delta_fW = 10n)，我对其进行了 “整形” 得到 “修改后的最优参数”。我已创建了副本 202609_CP_basic_20uA_v1_PS_1014_bestSpeed，现在你将 “修改后的最优参数” 实际填入此副本并刷新原理图。

变量 起始 修改后的最优参数
fW 2.25 µ 1.65 µ
fL 975 n 995 n
fn 13 37
ka 1.2 1.5
fW_TG 100 n 120 n
fL_TG 30 n 30 n
fn_TG 2 1
```


## 2026.10.15 CP 迭代与库文件整理

``` bash
OPA Simulation Report:
- Time: 2026.10.15 19:09
- TB:  MyLib_amsLib_tsmcN28 > TB_OPA (interactive.211)
- DUT: MyLib_amsLib_tsmcN28 > 202609_OPA__2stage_nullMiller_AI_v2_PS_1013_gainGBW
- Simulation: Pre-Layout
- Corners: nom @ 1.0V, TT50/SS50/FF50 @ 1.0V, TT27/SS-40/FF130 @ 1.0V
- Load Capacitance: 1pF

Simulated Results:
- 60dB_out_vdelta (V) = 673.2m (364m ~ 783.2m)
- 40dB_out_vdelta (V) = 888.9m (725m ~ 937.6m)
- 20dB_out_vdelta (V) = 935.8m (905.5m ~ 968.7m)
- dc_input_Ib_ave (A) = 81.16p (35.73p ~ 205.1p)
- IDD_dc (A)        = 433.2u (269.3u ~ 734.4u)
- vin_offset (V)    = 212.9u (204.7u ~ 400.5u)
- ac_Gain_dc (dB)   = 84.55 (69.86 ~ 88.08)
- UGF (Hz)          = 145.5M (47.32M ~ 245M)
- GBW (Hz)          = 140.7M (47.51M ~ 272.3M)
- PM (deg)          = 69.01 (49.69 ~ 80.19)
- GM (dB)           = 14.74 (12.4 ~ 20.33)
- pole_2 / UGF      = 1.911 (1.121 ~ 3.986)
- Zout_dc (Ohm)     = 22.69K (10.29K ~ 29.23K)
- Gm_dc (S)         = 746.9m (303.8m ~ 870.2m)
- IOUTP_max (A)     = >800u (698u ~ >800u)
- IOUTN_max (A)     = 306.8u (196.5u ~ 509.8u)
- settlingTime_ave @ 3%     = 2.188n (2.188n ~ 7.626n)
- settlingTime_ave @ 10%    = 1.093n (1.028n ~ 4.879n)
- overshoot_ave (%)         = 5.931 (28.14m ~ 29.81)
- VOUT_headroom_low         = 1.958u (696.1n ~ 499.4u)
- VOUT_headroom_high        = 51.42m (25.51m ~ 125.7m)
- SR_ave (V/s) (30% ~ 70%)  = 8.877M (3.008M ~ 16.69M)
- unitGain1perc_input_range  = 356.5m (343.4m ~ 371m)
- unitGain1perc_input_vmin   = 268.2m (191.5m ~ 341m)
- unitGain1perc_input_vmax   = 624.7m (542m ~ 712.1m)
- unitGain5perc_input_range  = 609.6m (578m ~ 626.3m)
- unitGain5perc_input_vmin   = 213.6m (116.9m ~ 301.2m)
- unitGain5perc_input_vmax   = 823.2m (743.2m ~ 879.1m)
- unitGain_BW (Hz)           = 393.2M (71.25M ~ 540.2M)

Note: 
- The values in parentheses represent the fluctuation situations of all the test corners.
- In the test "TB_OPA_7_dcSweep_maxIout", the "eval err" means the max Iout has exceeded
  the specified simulation setting (default 800 uA). Hence "eval err" refers to "infty".
  For example, the results "TB_OPA_7_dcSweep_maxIout IOUTP_max (A)	eval err > 1u fail 698u 698u"
  means: "Iout_max (A) > 800u (698uA ~ >800u)"


Raw Data: 
Test                Output  Nominal Spec      Pass/Fall Min     Max
TB_OPA_2_dcSweep_gain_outRange	60dB_out_vdelta	673.2m	> 100m		pass	364m	783.2m
TB_OPA_2_dcSweep_gain_outRange	40dB_out_vdelta	888.9m	> 100m		pass	725m	937.6m
TB_OPA_2_dcSweep_gain_outRange	20dB_out_vdelta	935.8m	> 100m		fail	905.5m	968.7m
TB_OPA_4_ac_PM_GBW	dc_input_Ib_ave	81.16p	< 100p		fail	35.73p	205.1p
TB_OPA_4_ac_PM_GBW	IDD_dc (A)	433.2u	< 2m		pass	269.3u	734.4u
TB_OPA_4_ac_PM_GBW	vin_offset (V)	212.9u	< 5m		pass	204.7u	400.5u
TB_OPA_4_ac_PM_GBW	ac_Gain_dc (dB)	84.55	> 10		pass	69.86	88.08
TB_OPA_4_ac_PM_GBW	UGF (Hz)	145.5M	> 1M		pass	47.32M	245M
TB_OPA_4_ac_PM_GBW	GBW (Hz)	140.7M	> 1M		pass	47.51M	272.3M
TB_OPA_4_ac_PM_GBW	PM (deg)	69.01	> 45		pass	49.69	80.19
TB_OPA_4_ac_PM_GBW	GM (dB)	14.74	> 5		pass	12.4	20.33
TB_OPA_4_ac_PM_GBW	pole_2 / UGF	1.911	> 1		pass	1.121	3.986
TB_OPA_5_ac_Zout	Zout_dc (Ohm)	22.69K	< 1G		pass	10.29K	29.23K
TB_OPA_6_ac_Gm	Gm_dc (S)	746.9m	> 1u		pass	303.8m	870.2m
TB_OPA_7_dcSweep_maxIout	IOUTP_max (A)	eval err	> 1u		fail	698u	698u
TB_OPA_7_dcSweep_maxIout	IOUTN_max (A)	306.8u	> 1u		pass	196.5u	509.8u
TB_OPA_8_tran_stepResponse	settlingTime_ave @ 3%	2.188n	< 5n		fail	2.188n	7.626n
TB_OPA_8_tran_stepResponse	settlingTime_ave @ 10%	1.093n	< 2n		fail	1.028n	4.879n
TB_OPA_8_tran_stepResponse	overshoot_ave (%)	5.931	< 10		fail	28.14m	29.81
TB_OPA_9_tran_SR	VOUT_headroom_low	1.958u	< 20m		pass	696.1n	499.4u
TB_OPA_9_tran_SR	VOUT_headroom_high	51.42m	< 20m		fail	25.51m	125.7m
TB_OPA_9_tran_SR	SR_ave (V/s) (30% ~ 70%)	8.877M	> 0		pass	3.008M	16.69M
TB_OPA_10_dcSweep_unitGainAMP	unitGain1perc_input_range	356.5m	> 400m		fail	343.4m	371m
TB_OPA_10_dcSweep_unitGainAMP	unitGain1perc_input_vmin	268.2m	< 1		pass	191.5m	341m
TB_OPA_10_dcSweep_unitGainAMP	unitGain1perc_input_vmax	624.7m	> 0		pass	542m	712.1m
TB_OPA_10_dcSweep_unitGainAMP	unitGain5perc_input_range	609.6m	> 400m		pass	578m	626.3m
TB_OPA_10_dcSweep_unitGainAMP	unitGain5perc_input_vmin	213.6m	< 1		pass	116.9m	301.2m
TB_OPA_10_dcSweep_unitGainAMP	unitGain5perc_input_vmax	823.2m	> 0		pass	743.2m	879.1m
TB_OPA_12_ac_unitGainAMP	unitGain_BW (Hz)	393.2M	> 1M		pass	71.25M	540.2M
```


``` bash
在当前 TB 中我已完成了运放 202609_OPA__2stage_nullMiller_AI_v1_PS_1012_gain 的全工艺角仿真，现在要对其性能进行总结。你参考下面这段的风格，帮我提取相应性能指标，通过代码块给我，方便复制：

xxx

为了方便你判断各个性能指标来自仿真的哪一部分，我将其 raw data 也提供给你：

xxx
```


## 2026.10.15 AI 版图设计尝试


``` bash
我已提前帮你打开好了可运行的 drc 和 lvs 界面，对当前聚焦的 Logic_std_2d0_200n_30n_INV_x2_test_AI_layout 完成版图设计

(运行 40min，token 消耗 xxx)
结果：AI 参考了已有的 Logic_std_2d0_200n_30n_INV_x2 设计，成功完成了较好的版图设计
```



``` bash
现在对当前聚焦的 Logic_std_1d5_400n_60n_INV_x4_test_AI_layout 完成版图设计

(运行 14m，token 消耗 980)
结果：成功完成了版图设计并通过 DRC/LVS，但 "一定程度上无脑套用了原有" 设计
```


算力消耗：106516 -> 104837 (-1679)
``` bash
在你上一次迭代任务中，所得结果虽然性能好，但是版图性能不一定好，因为电流镜管子面积过大而开关管尺寸过小：电流镜管 fn/fW/fL = 37/2.475u/995n，在版图上的面积约为 37*0.995u * 2.475u ≈ 37u * 2.5u 很大，而开关管版图面积则极小。
其实电流镜管子面积大是正常的，但是不能过大，这里要求你的电流镜管子面积不得超过 35 um^2。

新的迭代任务如下：
- library: MyLib_amsLib_tsmcN28
- TB: TB_CP
- DUT: 202609_CP_basic_variable
任务：以当前的参数组合为起始点，结合你对版图实际可行性、可靠性、高性能的考量，对 202609_CP_basic_variable 再进行一次迭代优化，以获得更好的瞬态和 dc 性能。各参数初始值已在 TB 中给出，目标迭代次数约 500 次，在保证 dc current mismatch 较小的前提下尽量优化瞬态响应。
详细要求：
- 迭代开始前截图并展示当前聚焦的 TB，随后在 TB 上以起始参数运行一次仿真，截图并展示起始性能
- 可结合 “模拟 IC 设计师视角” 和 “统计迭代视角” 来优化你的迭代过程
- 所有 effective design variable 都可大幅改动，但需保证可靠性、可实现性，符合实际情况
- 硬性 spec 要求 (未提到的可在和我确认后做适当牺牲)：
    - dc: 
        - IOUT_delta_abs (%) @ VDD/2 < 0.3
        - IOUT_mis_abs_ave (%) < 1
        - VOUT_headroom_low @ 10% < 135m
        - VOUT_headroom_high @ 10% < 135m
        - ROUT_N @ mid > 1M
        - ROUT_P @ mid > 1M
    - tran: 
        - surplus current: IOUT_integ_surplus_abs (%) < 3
        - settling time: settlingTime_ave < 50p
        - overshoot: os_ave < 70 (避免出现 ave 较好但是某个 os 值特别差)
- 尽量优化 (优先级从高到低)：
    - settlingTime_ave
    - 其它所有性能指标同优先级，待你做取舍，都尽量优化一下
其它：
- IREF = 20 uA 保持不变
- cap value 保持不变
- 此次迭代并没有严格控制 mu = 1，你可以适当设置其值

先把你要提问的问好，然后我就等任务结束才来看了
```


## 2026.10.19 LUP 相关学习

详见 [Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.md](<AnalogIC/Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.md>)

## 2026.10.19 virtuoso 默认设置修改

``` bash
envLoadFile("/home/dy2025/Desktop/Work/AA_Workspace_tsmcN28/.cdsenv")
```


在 CIW > Tools Display Resource Manager 修改 display.drf，可参考 [CSDN > virtuoso cadence初学--常用设置文件1（cds.lib display.drf）](https://blog.csdn.net/hx_12138/article/details/134278588)

## 2026.10.21 ~ 2026.10.23 LUP 学习及 DRC 排查

详见 [Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.md](<AnalogIC/Virtuoso Tutorials - 22. Detailed Explanation of Latch-Up and Fixing LUP DRC.md>)

## 2026.10.22 CP_basic_v1 版图与后仿

后仿 nmos 电流镜效果不好，输出电流偏差挺大，为什么？（biasing 部分也是后仿的）


## 2026.10.24 ~ 2026.10.25 CP 后仿电流偏差原因排查


``` bash
@[conversation:d964cd09-2268-469c-a912-d61853e691e4|CP后仿支路三电流下降排查清单] 受 PDK 管子 L ≤ 1um 的限制，我采用 “晶体管的串联” 来实现更大的等效长度 L (仅对电流镜管子)，虽然 body effect 导致不是精确等效，但整体效果是有的。

我适当修改了 TB 中的设置，请你重新进行迭代任务。电流镜管子面积大是正常的，但是不能过大，这里要求你的电流镜管子面积不得超过 35 um^2（mu*fn*fw*fL）(两个 "串联" 管子的总面积) 。

新的迭代任务如下：
- library: MyLib_amsLib_tsmcN28
- TB: TB_CP
- DUT: 202609_CP_basic_seriesL_variable
任务：以之前的参数组合为基础，你自行选取合适的起始点，结合你对版图实际可行性、可靠性、高性能的考量，对 charge pump 重新进行迭代优化，以获得更好的瞬态和 dc 性能、以及版图可靠性。各参数初始值已在 TB 中给出，目标迭代次数约 500 次，在保证 dc current mismatch 较小的前提下尽量优化瞬态响应。
详细要求：
- 迭代开始前截图并展示当前聚焦的 TB，随后在 TB 上以起始参数运行一次仿真，截图并展示起始性能
- 可结合 “模拟 IC 设计师视角” 和 “统计迭代视角” 来优化你的迭代过程
- 所有 effective design variable 都可大幅改动，但需保证可靠性、可实现性，符合实际情况
- 硬性 spec 要求 (未提到的可在和我确认后做适当牺牲)：
    - dc: 
        - IOUT_mis_abs_ave (%) < 1
        - IOUT_delta_abs (%) @ VDD/2 < 300m
        - VOUT_headroom_low @ 10% < 140m
        - VOUT_headroom_high @ 10% < 140m
        - ROUT_N @ mid > 2.5M
        - ROUT_P @ mid > 2.5M
        - 所有电流镜管子的 gm/Id 值不允许超过 14
    - tran: 
        - surplus current: IOUT_integ_surplus_abs (%) < 1.5
        - settling time: settlingTime_ave < 50p
        - overshoot: os_ave < 50 (避免出现 ave 较好但是某个 os 值特别差)
- 尽量优化 (优先级从高到低)：
    - settlingTime_ave, IOUT_integ_surplus_abs
    - 其它所有性能指标同优先级，待你做取舍，都尽量优化一下
其它：
- corner: TT @ 50°C 
- IREF = 20 uA 保持不变
- cap value 保持不变
- mu = 1 保持不变
-

先把你要提问的问好，然后我就等任务结束才来看了
```


``` bash
2026.10.26 04:17
我适当修改了 TB 中的设置，请你重新进行迭代任务。这次给的 spec 比较宽松，你尽可能去做多方面的优化就好，提升综合性能。

电流镜管子面积大是正常的，但是不能过大，这里要求你的电流镜管子面积不得超过 90 um^2（ka*mu*fn*fw*fL）。

新的迭代任务如下：
- library: MyLib_amsLib_tsmcN28
- TB: TB_CP
- DUT: 202609_CP_basic_variable
任务：以 TB 现有的参数值作为起始点，结合你对版图实际可行性、可靠性、高性能的考量，对 charge pump 重新进行迭代优化，以获得更好的瞬态和 dc 性能、以及版图可靠性。各参数初始值已在 TB 中给出，目标迭代次数约 1000 次，在保证 dc current mismatch 较小的前提下尽量优化瞬态响应。
详细要求：
- 迭代开始前截图并展示当前聚焦的 TB，随后在 TB 上以起始参数运行一次仿真，截图并展示起始性能
- 可结合 “模拟 IC 设计师视角” 和 “统计迭代视角” 来优化你的迭代过程
- 所有 effective design variable 都可大幅改动，但需保证可靠性、可实现性，符合实际情况
- 硬性 spec 要求 (未提到的可在和我确认后做适当牺牲)：
    - dc: 
        - IOUT_mis_abs_ave (%) < 1
        - IOUT_delta_abs (%) @ VDD/2 < 500m
        - VOUT_headroom_low @ 10% < 140m
        - VOUT_headroom_high @ 10% < 140m
        - ROUT_N @ mid > 1.5M
        - ROUT_P @ mid > 1.5M
    - tran: 
        - surplus current: IOUT_integ_surplus_abs (%) < 2
        - settling time: settlingTime_ave < 50p
        - overshoot: os_ave < 60 (避免出现 ave 较好但是某个 os 值特别差)
- 尽量优化 (优先级从高到低)：
    - settlingTime_ave, IOUT_integ_surplus_abs
    - 其它所有性能指标同优先级，待你做取舍，都尽量优化一下
其它：
- corner: TT @ 50°C 
- IREF = 20 uA 保持不变
- cap value 保持不变
- mu = 2 保持不变

先把你要提问的问好，然后我就等任务结束才来看了
```


``` bash
你已经在宽松 spec 下完成了迭代任务，我已创建了副本 202609_CP_basic_20uA_AI_v3_PS_1026_bestSpeed，你先将迭代得到的最优解实际写入这个副本。

然后，结合刚刚的迭代经验，尝试更为苛刻的 spec 指标。

新的迭代任务如下：
- library: MyLib_amsLib_tsmcN28
- TB: TB_CP
- DUT: 202609_CP_basic_variable
任务：以 TB 现有的参数值作为起始点，结合你对版图实际可行性、可靠性、高性能的考量，对 charge pump 重新进行迭代优化，以获得更好的瞬态和 dc 性能、以及版图可靠性。各参数初始值已在 TB 中给出，目标迭代次数约 3000 次，在保证 dc current mismatch 较小的前提下尽量优化瞬态响应。由于迭代次数极大，你应当于常规迭代思路的基础上，在某些时候结合模拟设计工程师思维来 “创新性” 地尝试一些其它参数组合，以避免迭代陷入局部最优解 (也可自行尝试其它 “避免陷入局部最优解” 的方法)。
详细要求：
- 迭代开始前截图并展示当前聚焦的 TB，随后在 TB 上以起始参数运行一次仿真，截图并展示起始性能
- 可结合 “模拟 IC 设计师视角” 和 “统计迭代视角” 来优化你的迭代过程
- 所有 effective design variable 都可大幅改动，但需保证可靠性、可实现性，符合实际情况
- 硬性 spec 要求 (未提到的可在和我确认后做适当牺牲)：
    - dc: 
        - IOUT_mis_abs_ave (%) < 1
        - IOUT_delta_abs (%) @ VDD/2 < 300m
        - VOUT_headroom_low @ 10% < 170m (适当放宽了)
        - VOUT_headroom_high @ 10% < 170m (适当放宽了)
        - ROUT_N @ mid > 1.5M
        - ROUT_P @ mid > 1.5M
    - tran: 
        - surplus current: IOUT_integ_surplus_abs (%) < 1
        - settling time: settlingTime_ave < 40p
        - settling time (new): settlingTime_ave_new < 40p (新增项)
        - overshoot: os_ave < 30 (避免出现 ave 较好但是某个 os 值特别差)
- 尽量优化 (优先级从高到低)：
    - settlingTime_ave_new, IOUT_integ_surplus_abs
    - 其它所有性能指标同优先级，待你做取舍，都尽量优化一下
其它：
- corner: TT @ 50°C 
- IREF = 20 uA 保持不变
- cap value 保持不变
- mu = 2 保持不变
- 电流镜管子面积不得超过 100 um^2 (ka*mu*fn*fw*fL)
- 无需在意电流镜管子的 gm/Id 值，任意都行
- 迭代完成后，将最优解写入我已创建好的副本 202609_CP_basic_20uA_AI_v4_PS_1026_bestSpeed

```


## 2026.10.25 后仿 CP (支路三) 电流下降排查记录
- 现象：CP 模块 202609_CP_basic_20uA_v1_usingAIv1_main 前仿时电流复制正常，后仿时支路三（CP core）的 NMOS 电流源从 20 µA 降到约 19.35 µA，低了 3.2%。支路二 NMOS 和全部 PMOS 的电流都正常。三条支路的 NMOS 镜像管尺寸相同，都是 nch_mac，L = 1 µm，fW = 1.7 µm，36 指。
- 定位方法：在 TB_CP_1_dc 中跑后仿 DC 工作点（Interactive.443），逐 finger 读出三颗 NMOS 的工作点并汇总。支路三电流源 XI19_MM1 和支路一 diode 参考管 XI18_MM1 的 Vgs 只差 0.02 mV，排除了源端和地线 IR drop。所有管子都在饱和区，饱和余量在 225 到 305 mV 之间，排除了漏端余量不足。两者真正的差别在 Vth：支路三比参考管高 1.40 mV。这几颗管工作在中反型区，gm/Id 约 25 /V，每 1 mV 的 Vth 偏差大约会带来 2.5% 的电流误差，所以 1.4 mV 足以解释约 3.5% 的电流下降。支路三的 Vds 比参考管高 45 mV，沟道长度调制会补回约 1.2%。两者相抵，最终观察到的是 −3.2%。
- 根因：版图中的阱邻近效应（WPE）。PEX 网表里描述 WPE 的版图参数 SCA，参考管均值为 0.55，支路二为 0.79，支路三为 1.46。原版图里每颗管单独一行、各自套一圈 guard ring，支路三的 NMOS 紧挨着 PMOS 所在的 N-well。离阱边越近，阱注入时散射进沟道的掺杂越多，Vth 也就越高。两颗 PMOS 处在同一片 N-well 里，SCA 都是 0.73，电流也一致，这一点和上面的结论对得上。LOD 方面，三颗管的 sa+sb 相同，可以排除。
- 修正与验证：调整版图排布后，重新抽取并后仿（Interactive.458，网表 partTest_biasingAndCore_calibre）。三颗 NMOS 的 SCA 拉齐到 1.33 到 1.36，与参考管的 ΔVth 降到 −0.10 mV。支路二和支路三的电流都是 20.05 µA，与参考管 20.00 µA 只差 +0.27%。PMOS 两颗管的 SCA 都是 1.16，电流都是 20.05 µA。DC 下 IOUT_N 和 IOUT_P 都是 20.05 µA，失配约 0.94%，满足 < 5% 的 spec。WPE 造成的静态失配已经解决。这次是让三颗管离阱边"一样近"，没有让它们"都远离"阱边，所以所有 NMOS 的 Vth 整体高了约 10 mV，饱和余量还有约 220 mV。版图上如果还有空间，可以让镜像块整体再远离阱边，提高对工艺波动的鲁棒性。
- 遗留问题：新版图后仿的瞬态测试里，IOUT_neg_static 为 108.5%，IOUT_integ_surplus 分别为 −10.2% 和 −11.6%。settlingTime_00_01 和 settlingTime_10_01 分别为 86.6 ps 和 62.6 ps，都超过了 50 ps 的 spec。DC 下电流已经匹配，所以这些属于动态问题，可能来自开关电荷注入、X_n 节点电荷共享或 UP/DN 时序，与 WPE 无关，需要另外排查。


## 2026.10.24 帮 QWB 师兄做测试 PCB 板子


``` bash
共五处电源：
(LDO) VBIAS
(LDO) VDD_1V_1 = VDD_CK
(外部) VDD_1V_2 = VDD_SER
(外部) VDD_1V_3 = VDD_DRV
(外部) VDD_2V   = VDD2_DRV

```


## 2026.10.26 CP 修改 TB 后进一步迭代

``` bash
我适当修改了 TB 中的仿真设置，请你参考之前任务 @[conversation:2214a7f9-3038-4d4e-bb16-1f1f217db483|优化电荷泵迭代设计 (basic_AI_v3 和 v4)] 的迭代结果，以及 TB_CP 中 interactive.494 的 CP 参数 (管子大尺寸，几乎无 os 的同时实现了较好的 settlingTime)，重新进行迭代任务。

新的迭代任务如下：
- library: MyLib_amsLib_tsmcN28
- TB: TB_CP
- DUT: 202609_CP_basic_variable
任务：自行选取合适的起始点，结合你对版图实际可行性、可靠性、高性能的考量，对 charge pump 重新进行迭代优化，以获得更好的瞬态和 dc 性能、以及版图可靠性。各参数初始值已在 TB 中给出，目标迭代次数约 1000 次，在保证 dc current mismatch 较小的前提下尽量优化瞬态响应。
详细要求：
- 迭代开始前截图并展示当前聚焦的 TB，随后在 TB 上以起始参数运行一次仿真，截图并展示起始性能
- 可结合 “模拟 IC 设计师视角” 和 “统计迭代视角” 来优化你的迭代过程
- 所有 effective design variable 都可大幅改动，但需保证可靠性、可实现性，符合实际情况
- 硬性 spec 要求 (未提到的可在和我确认后做适当牺牲)：
    - dc: 
        - IOUT_mis_abs_ave (%) < 2
        - IOUT_delta_abs (%) @ VDD/2 < 700m
        - VOUT_headroom_low @ 10% < 150m
        - VOUT_headroom_high @ 10% < 150m
        - ROUT_N @ mid > 1.2M
        - ROUT_P @ mid > 1.2M
    - tran: 
        - settling time: settlingTime_ave_new < 50p (不重点关注 settlingTime_ave)
        - I_leak_eq_ave (A) 在 -25nA ~ +50nA 之间 (这次不再重点关注 IOUT_integ_surplus_abs, 它与 I_leak_eq_ave 有关但很多时候并不准确)
        - overshoot: os_ave < 60 (避免出现 ave 较好但是某个 os 值特别差)
- 尽量优化 (优先级从高到低)：
    - settlingTime_ave_new, I_leak_eq_ave
    - 其它所有性能指标同优先级，待你做取舍，尽量都优化一下
其它：
- corner: TT @ 50°C 
- IREF = 20 uA 保持不变
- cap value 保持不变
- mu = 2 保持不变
- 电流镜管子面积不得超过 100 um^2 (ka*mu*fn*fw*fL)
- 无需在意电流镜管子的 gm/Id 值，任意都行

先把你要提问的问好，然后我就等任务结束才来看了
```


``` bash
由于我调整过 TB 原理图，v6 现在的仿真结果与之前迭代结束时的结果稍有区别。我已设置好 TB 并跑了一次 interactive.531，现在要求你在 v6 基础上做一些调整，新的迭代任务如下：
- library: MyLib_amsLib_tsmcN28
- TB: TB_CP
- DUT: 202609_CP_basic_variable
任务：自行选取合适的起始点，结合你对版图实际可行性、可靠性、高性能的考量，对 charge pump 重新进行迭代优化，以获得更好的瞬态和 dc 性能、以及版图可靠性。各参数初始值已在 TB 中给出，目标迭代次数约 3000 次，在保证 dc current mismatch 较小的前提下尽量优化瞬态响应。由于迭代次数较多，你应当于常规迭代思路的基础上，在某些时候结合模拟设计工程师思维来 “创新性” 地尝试一些其它参数组合，以避免迭代陷入局部最优解 (也可自行尝试其它 “避免陷入局部最优解” 的方法)。
详细要求：
- 迭代开始前截图并展示当前聚焦的 TB，随后在 TB 上以起始参数运行一次仿真，截图并展示起始性能
- 可结合 “模拟 IC 设计师视角” 和 “统计迭代视角” 来优化你的迭代过程
- 所有 effective design variable 都可大幅改动，但需保证可靠性、可实现性，符合实际情况
- 硬性 spec 要求 (未提到的可在和我确认后做适当牺牲)：
    - dc: 
        - IOUT_mis_abs_ave (%) < 2
        - IOUT_delta_abs (%) @ VDD/2 < 700m
        - VOUT_headroom_low @ 10% < 150m
        - VOUT_headroom_high @ 10% < 150m
        - ROUT_N @ mid > 1.2M
        - ROUT_P @ mid > 1.2M
    - tran: 
        - settling time: settlingTime_ave_new < 50p (不重点关注 settlingTime_ave)
        - I_leak_eq_ave (A) 在 -40nA ~ +40nA 之间 (不重点关注 IOUT_integ_surplus_abs, 它与 I_leak_eq_ave 有关但很多时候并不准确)
        - overshoot: os_ave < 60 (避免出现 ave 较好但是某个 os 值特别差)
- 尽量优化 (优先级从高到低)：
    - settlingTime_ave_new
    - 其它所有性能指标，待你做取舍，尽量都优化一下
其它：
- corner: TT @ 50°C 
- IREF = 20 uA 保持不变
- cap value 保持不变
- mu = 2 保持不变
- 电流镜管子面积不得超过 100 um^2 (ka*mu*fn*fw*fL)
- 无需在意电流镜管子的 gm/Id 值，任意都行

先把你要提问的问好，然后我就等任务结束才来看了
```


``` bash
settlingTime(IOUT (pulse_width * 1.5) t (pulse_width * 3) t sett_perc nil "time") - UPDN_edge_00_10
 - UPDN_edge_00_10

(settlingTime(IOUT (UPDN_edge_1 - 2e-11) t (UPDN_edge_1 + 0.8*pulse_width) t sett_perc nil "time") - UPDN_edge_1)
(settlingTime(IOUT (UPDN_edge_2 - 2e-11) t (UPDN_edge_2 + 0.8*pulse_width) t sett_perc nil "time") - UPDN_edge_2)
(settlingTime(IOUT (UPDN_edge_3 - 2e-11) t (UPDN_edge_3 + 0.8*pulse_width) t sett_perc nil "time") - UPDN_edge_3)
(settlingTime(IOUT (UPDN_edge_4 - 2e-11) t (UPDN_edge_4 + 0.8*pulse_width) t sett_perc nil "time") - UPDN_edge_4)

(settlingTime(IOUT (UPDN_edge_1 - 2e-11) t (UPDN_edge_4 + 0.8*pulse_width) t sett_perc nil "time") - UPDN_edge_4)

9_sch_202609_CP_basic_20uA_v1_usingAIv1_main 9d3_cal_202609_CP_basic_20uA_v1_usingAIv1_main_complete 16_sch_202609_CP_basic_20uA_usingAIv1_partTest_biasingAndCore 16d1_cal_202609_CP_basic_20uA_usingAIv1_partTest_biasingAndCore 18_sch_202609_CP_basic_20uA_AI_v3_PS_1026_bestSpeed 19_sch_202609_CP_basic_20uA_AI_v4_PS_1026_bestSpeed 20_sch_202609_CP_basic_20uA_AI_v5_PS_1026_bestSpeed 21_sch_202609_CP_basic_20uA_AI_v6_PS_1026_speedTranAccuracy 23_sch_202609_CP_basic_20uA_AI_v7_PS_1027_speedTranAccuracy 24_sch_202609_CP_basic_20uA_AI_v8_PS_1027_bestSpeed 
```

## 2026.10.27 ~ 2026.11.02 LUP 文档撰写

## 2026.11.03 CP 版图与后仿

### 202609_CP_basic_20uA_usingAIv1


- [] 带 "11 to 00" 和 "EN" 的 CP input logic
- 完成 `202609_CP_basic_20uA_usingAIv1_10uA_core` 模块
- [] 完成 `202609_CP_basic_20uA_usingAIv1_4bit_0to150uA` 的完整版图，构建完整 0 ~ 150 uA CP (step 10 uA, 7 + 1, 4-bit)


### 问题排查已找出原因：CP_v1 的 IOUT 导通后缓慢向 ±20uA 靠拢，原因是 drain of mos 电容充放电与 VNODE/VOUT 失配 (也即根因是 charge sharing)

v1 电荷泵在 UP/DN 导通后输出电流先偏高 0.8~1.0 µA、再用约 100 ps 回落到 20 µA,DN 段最明显,其他版本没有这个长尾巴。排查表明,多出的电流是给 M1 漏极节点 net5 电容充电的位移电流,M1 沟道电流始终约 20.05 µA。net5 需要补电荷有两个原因:一是 DN/DNB 交叉瞬间 net5 悬空,被压低约 2.3 mV;二是 net5 的新目标电平比 DN 前高约 1.7 mV,来自浮空的复制节点 VNODE 与 IOUT 之间约 10 mV 的失配。补电荷要经 TG 导通电阻 5.07 kΩ 给 20.5 fF 的等效电容充电,τ≈100 ps,所以尾巴很长。v3、v7、v8 的等效电容只有 0.8~2.1 fF,尾巴缩成很快消失的尖峰。UP 看起来不明显,是因为 UP 脉冲开始时 IOUT−VNODE≈0。把 UP/DN 信号对调后,失配约 10 mV 的脉冲都出现了尾巴,所以这与 PMOS/NMOS 无关。只调边沿或延后 DNB 无法大幅改善:DNB 延后 8~12 ps 把第一个 DN 的 +20 ps 偏差从 0.78 µA 压到 0.25~0.01 µA,第二个 DN 仍有 0.4 µA 以上,还带来 7~23 µA 的窄尖峰。更有效的方向是减小 M1 漏极电容、增大 C4(20 pF 时失配 9.7→1.2 mV),或把 VNODE 钳到 IOUT 电平;钳位和脉冲间隙复位我没有仿真。开关加宽反而使尾巴变差,原因没有查明。

具体现象、报告详见文档 `misc/20261103-2010_v1_IOUT向零靠拢_完整报告_v3.pdf`，下面是 IOUT 波形图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-11-03-22-19-48_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-11-03-22-20-12_(AAA) My Research Record - 1 (20260919 - xxx).png"/></div>