# Practical Instances in Basic Libraries of Cadence Virtuoso

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 15:36 on 2026-02-05 in Lincang.
> dingyi233@mails.ucas.ac.cn


## Introduction

cadence virtuoso 中自带了一些基础库，例如：
- `basic`：设计 `VSS/GND` 之类的基础库
- `analogLib`：模拟 IC 设计常用的基础/进阶模块库
- `rfLib`：射频 IC 设计常用的基础/进阶模块库
- `ahdlLib`：用于 AHDL (Analog Hardware Description Language) 设计的模块库，也即 Verilog-A 模块库

这些库中包含了很多常用的模块，其中相当一部分是非常实用的。但我们平时往往不会主动去了解库中各个器件到底是做什么用，仅从 `cell name` 中又看不出来，导致在使用过程中没有充分利用这些基础库。本文就来介绍 virtuoso 基础库中一些比较实用的模块，并给出应用实例，方便大家在后续设计中直接调用这些模块，提高设计效率。


## 1. analogLib - Basic Modules for Analog IC Design

analogLib 是模拟 IC 设计中非常常用的基础库，里面包含了很多常用的模拟电路模块，例如电阻电容二极管等一系列理想元件、运放 OPA (opamp)、比较器 CMP (comparator)、电压源、电流源和滤波器等等。下面列举一些比较实用的模块及其应用实例，主要参数 cadence 自己的官方资料：[[1] Cadence Analog Library Reference Guide (Product Version 5.1.41 June 2004)](https://picture.iczhiku.com/resource/eetop/syITAhYDQiEIAxnm.pdf)

### 1.1 mostly used modules

先简单提一下 `analogLib` 中最常用的一些模块：
- Passive Components: res (电阻), cap (电容), ind (电感)
- Active Components (但其实基本不用): nmos/pmos (3-terminals MOSFET), nmos4/pmos4(4-terminals MOSFET), npn/pnp (BJT), diode (二极管)

然后再来详细介绍一下 `analogLib` 中各个分类都有哪些模块，以及一些实用模块该如何使用。



### 1.1 active components



<!-- 首先是有源器件 Active Components:
- ibis_buffer: IBIS Buffer (IBIS 缓冲器, 用于数字 I/O 信号仿真)
- diode: Junction Diode (结型二极管)
- nbsim/pbsim: BSIM Field Effect Transistor (GSD 三端 BSIM 场效应晶体管)
- nbsim4/pbsim4: BSIM4 Field Effect Transistor (GSDB 四端 BSIM 场效应晶体管)
- njfet/pjfet: Junction Field Effect Transistor (JFET, 三端)
- nmes/pmes: GaAs MESFET (GSD 三端 GaAs MESFET)
- nmos/pmos: Generic MOS Transistor (3 terminals)
- nmos4/pmos4: Generic MOS Transistor (4 terminals)
- npn/pnp: Generic Bipolar Transistor (BCE 三端)
- schottky: Schottky Diode (肖特基二极管)
- usernpn/userpnp: User Specific Bipolar Transistor (3 terminals) (自定义 BJT)
- zener: Zener Diode (齐纳二极管)
 -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-05-16-55-35_Practical Instances in Basic Libraries of Cadence Virtuoso.png"/></div>

不过其实上面这些有源器件我们平时基本不用，都是直接用具体工艺库 PDK 里面提供的器件模型。

### 1.2 analysis specific components

<!-- Analysis Specific Components: 
cmdmprobe
fourier
fourier2ch
iprobe
nodeQuantity -->

如下图，Analysis specific components 里面也就 `iprobe` 还比较实用，其它几个基本用不到：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-05-17-04-22_Practical Instances in Basic Libraries of Cadence Virtuoso.png"/></div>

### 1.3 parasitic components

这几个 parasitic components 也基本用不到，其名称具体是啥意思参考下一小节 **1.4 passive components** 即可。

Parasitic Components
- pcapacitor
- pdiode
- pinductor
- pmind
- presistor



### 1.4 passive components

无源器件里面常用的就比较多了：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-05-17-10-52_Practical Instances in Basic Libraries of Cadence Virtuoso.png"/></div>

<!-- Passive Components:
- **cap: capacitor (电容)**
- core: Magnetic Core with Hysteresis (具有磁滞特性的磁芯)
- corefragment: Magnetic Core Fragment with Hysteresis (磁芯片段)
- **delay: Delay Line (延时线)**
- ideal_balun: Balun Transformer (平衡-不平衡变压器)
- **ind: Inductor (电感)**
- mind: Mutual Inductor (互感线圈)
- msline: Microstrip Line (微带线), 常用于射频和微波电路设计
- mtline: Multi-Conductor Transmission Line (多导体传输线)
- phyres: Physical Resistor (实际电阻), 带有 parasitic cap 参数
- rcwireload: RC Wire Load (RC 线负载), 和 phyres 类似
- **res: Resistor (电阻): Two Terminal Resistor**
- spxtswitch: 
    - **sp1tswitch - Ideal Switch With 1 Position (理想开关)**, 可通过设置 DC/AC Position 来取代运放 ac gain 仿真中的大电感和大电容
    - sp2tswitch - Ideal Switch With 2 Positions (单刀双掷开关)
    - sp3tswitch - Ideal Switch With 3 Positions (单刀三掷开关)
- switch: Four Terminal Relay Switch (四端继电器开关), 差分控制端口 `ps/ns` 的电压值控制着开关的电阻值 (非线性控制)
- **tline: Transmission Line (Lossy or Lossless) (传输线)**
- winding: Winding for Magnetic Core (磁芯绕组)
- xfmr: Linear Two Winding Ideal Transformer (线性双绕组变压器)


Passive Components. 
cap
core
corefragment
delay
ideal_balun 
ind
mind
msline
mtline
phyres
rcwireload
res
spxtswitch
switch
tline
winding
xfmr
 -->


### 1.5 sources - dependent sources


一些压控/流控的电压/电流源，有线性/非线性的，以及一组/多组差分输入的：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-05-17-23-20_Practical Instances in Basic Libraries of Cadence Virtuoso.png"/></div>

<!-- 6
Sources - Dependent Components.
cccs
ccvs
pcccs
pccvs
pvccs, pvccs2, pvccs3
pvccsp
pvcvs, pvcvs2, pvcvs3
pvcvsp
vccs
vccsp
vcvs
vcvsp -->



### 1.6 sources - global components

一些全局的电源/地模块，主要是各种类型的 `VSS/VDD`，平时也基本不用，这里就不展开介绍了：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-05-17-23-32_Practical Instances in Basic Libraries of Cadence Virtuoso.png"/></div>


<!-- Sources - Global Components
gnd
gnda
gndd
vcc
vcca
vccd
vdd
vdda
vddd
vee
veea
veed
vss
vssa
vssd
 -->

### 1.7 sources - independent components

独立电压源、电流源、带输出阻抗匹配的电压源模块：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-05-18-08-14_Practical Instances in Basic Libraries of Cadence Virtuoso.png"/></div>

这里先单独说一下 port/pdc/pexp/port/ppulse/ppwl/psin 与 vsource/vdc/vexp/vpulse/vpwl/vsin 的区别：
- 前者称为 resistive voltage source (这里的前缀 `p` 是指 port)，一方面是在 voltage source 的基础上，加了输出阻抗匹配功能 (默认 Resistance = 50 Ohm @ Reactance = 0)，可以通过 `Resistance/Reactance` 参数来设置输出阻抗；
- 另一方面是 port 等源的设置，例如 dc = 1 V 为例，是指负载同样为 50 Ohm load 时，负载端所接收到的电压为 1 V，也即如果源输出阻抗设置为了 (50 + j0) Ohm 的话，实际源端输出的电压为 2 V，其它信号类型也是类似；说明 port/pdc/pexp/port/ppulse/ppwl/psin 是针对 ratio signal 而言的。


再来说说 isource/vsource/port 中额外有的 `bit/prbs` 信号类型。

前者 `bit` 是输出制定的 data pattern (bit sequence)，由 `Pattern Parameter data` 来指定，例如 `1011001`，可以用来生成任意的数字信号序列 (但是不能指定文件)；`bit` 信号模式下的参数 `Period of Waveform` 其实就是 bit period (bit width)，例如设置为 1 ns，则表示每个 bit 占用 1 ns 时间。这个模式的具体示例可以参考这篇文章：[打鱼晒网的 DT9025A > IC Design & EDA > Virtuoso 中 vsource 的使用](https://dt9025a.top/?p=802)。


后者 `prbs` 是输出伪随机二进制序列 (pseudo-random binary sequence, PRBS)，有关 PRBS 的详细介绍可以参考这篇文章：[Virtuoso Tutorials - 21. How to Generate PRBS (Pseudo-Random Binary Sequence) Signal in Virtuoso](<AnalogIC/Virtuoso Tutorials - 21. How to Generate PRBS (Pseudo-Random Binary Sequence) Signal in Virtuoso.md>).

这两个信号类型在信号链设计中非常常用，例如 SerDes/CDR/ADC/DAC 等等，方便我们直接生成测试数据进行仿真验证。



<!-- Sources - Independent Components
idc
iexp
ipulse
ipwl
ipwlf
isin
isource
pdc
pexp
port
powerSupply
ppulse
ppwl
ppwlf
psin
vdc
vexp
vpulse
vpwl
vpwlf
vsin
vsource -->


<!-- Sources - Independent Components
idc/vdc/pdc
iexp/vexp/pexp
ipulse/vpulse/ppulse
ipwl/vpwl/ppwl
ipwlf/vpwlf/ppwlf
isin/vsin/psin
isource/vsource/port

pdc
pexp
ppulse
ppwl
ppwlf
psin

vdc
vexp
vpulse
vpwl
vpwlf
vsin
vsource

powerSupply -->

### 1.8 sources - ports

<!-- Sources - Ports
n1port
n2port
n3port
n4port
nport
pdc
pexp
port
ppulse
ppwl
ppwlf
psin -->

ports 相关的如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-16-34-56_Explore Practical Instances in Basic Libraries of Cadence Virtuoso.png"/></div>

其中 nport/n1port/n2port/n3port/n4port 是用 S-parameter file 来描述的，可以用来做射频电路的端口建模 (S-parameter modeling)；其余 pdc/pexp/port/ppulse/ppwl/ppwlf/psin 则已经在上一小节介绍过，这里不再赘述。

### 1.9 sources - z/s-domain components


<!-- Sources - Z_S_Domain Components
scccs
sccvs
svccs
svcvs
zcccs
zccvs
zvccs
zvcvs

Sources - Z_S_Domain Components
scccs/sccvs/svccs/svcvs
zcccs/zccvs/zvccs/zvcvs -->

一些 s/z 域的受控源模块，也是比较实用的，方便我们构建任意传递函数模块：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-17-55-23_Explore Practical Instances in Basic Libraries of Cadence Virtuoso.png"/></div>

$$
\begin{gather}
H(s) = \mathrm{gain}\,\frac{a_0 + a_1 s + a_2 s^2 + ...}{1 + b_1 s + b_2 s^2 + ...} \\
H(z) = \mathrm{gain}\,\frac{a_0 + a_1 z + a_2 z^2 + ...}{1 + b_1 z + b_2 z^2 + ...}
\end{gather}
$$

注意 z-domain components 是对输入信号进行 sample (指定频率) 后再进行处理的并输出信号的，仿真效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-18-32-32_Explore Practical Instances in Basic Libraries of Cadence Virtuoso.png"/></div>

这里如果仿真时遇到报错 **<span style='color:red'> Zero diagonal found in Jacobian at `sout_p' and `sout_p'. </span>**，将瞬态仿真中 `options > cmin` 设置成 1f 即可解决。


### 1.10 uncategorized components


<!-- Uncategorized Components
MOS_a2d
MOS_d2a
TTL_a2d
TTL_d2a
scasubckt -->

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-06-18-38-21_Explore Practical Instances in Basic Libraries of Cadence Virtuoso.png"/></div>

## 2. ahdlLib - Basic Modules for AHDL (Verilog-A) Design

ahdlLib 是用于 AHDL (Analog Hardware Description Language) 设计的模块库，也即 Verilog-A 模块库，里面包含了很多常用的 Verilog-A 模块，例如电压源、电流源、运放、比较器、滤波器、锁相环等等。下面列举一些比较实用的模块及其应用实例，主要参考 cadence 自己的官方资料：[[2] Cadence Verilog-A Language Reference (Product Version 5.1 January 2004)](https://picture.iczhiku.com/resource/eetop/wHKHWkFiYkuOICnN.pdf)




## Reference

- [[1] Cadence Analog Library Reference Guide (Product Version 5.1.41 June 2004)](https://picture.iczhiku.com/resource/eetop/syITAhYDQiEIAxnm.pdf): `analogLib` 的主要参考资料
- [[2] Cadence Verilog-A Language Reference (Product Version 5.1 January 2004)](https://picture.iczhiku.com/resource/eetop/wHKHWkFiYkuOICnN.pdf): `ahdlLib` 的主要参考资料

