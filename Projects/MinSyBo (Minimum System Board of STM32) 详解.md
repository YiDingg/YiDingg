# MinSyBo (Minimum System Board of STM32) 

## 项目说明

这是一个STM32F103C8T6最小系统板，（以下简称 “系统板” ），原理图和PCB使用立创EDA(专业版)进行设计，相关文件全部开源。

本文介绍了STM32F103C8T6最小系统板的设计原理，提供了原理图、PCB下载渠道，以供学习参考。

<div class='center'>

| 相关链接 |
| :------: |
| 原理图和PCB下载(GitHub)：[MinSyBo](https://github.com/YiDingg/MinSyBo)|
| 设计思路、物料表与焊接建议：[MinSyBo (Minimum System Board of STM32)](https://yidingg.github.io/YiDingg/#/Projects/MinSyBo%20(Minimum%20System%20Board%20of%20STM32)%20详解.md?id=四、物料表与焊接) |
</div>

产品图片：

<div class='center'>

| 正面 | 背面 |
| :------: | :------: |
 |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MinSyBo (Minimum System Board of STM32) 详解-2024-06-21-02-12-35.png">|<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MinSyBo (Minimum System Board of STM32) 详解-2024-06-21-02-12-40.png"> |
 |<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MinSyBo (Minimum System Board of STM32) 详解--2024-06-29-13-04-51.png"/></div> |<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MinSyBo (Minimum System Board of STM32) 详解--2024-06-29-13-04-59.png"/></div>|
</div>
由于个人时间、精力和水平有限，项目难免存在不足，望读者不吝指正。

## 原理图设计

### 1. 主控芯片：
主控芯片选用STM32F103C8T6，需要参考其数据手册设计相关的电源、烧录、复位、晶振、复位、启动等模块。

<div class='center'>

| 模块 | 图片 |
| :------: | :------: |
 | Power Supply:  | <img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MinSyBo (Minimum System Board of STM32) 详解--2024-06-22-23-01-21.png"/><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MinSyBo (Minimum System Board of STM32) 详解--2024-06-22-23-01-59.png"/>|
 |NRST(Reset):  |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MinSyBo (Minimum System Board of STM32) 详解--2024-06-22-23-02-04.png"/><img src='https://www.writebug.com/static/uploads/2024/5/14/b654abde5465749f6fb2c0f89226ecf8.png'/> |
 | BOOT modes | <img src="https://www.writebug.com/static/uploads/2024/5/14/6d8dc36c50a6ef8df7347e22cb86f4c6.png"/>|
</div>

### 2. 电源模块

目标：将USB接入的5V电压转为3.3V（利用稳压电路），添加电源滤波，并加配两个状态灯（分别指示3.3V电源和GPIO的PC13口）。
常见的稳压电路类型有 LDO(Low Dropout Regulator，低压线性稳压器)，DCDC(Direct Current to Direct Current，直流转直流器)等，可根据需求选择。
使用最广的型号是AMS1117-3.3(LDO)，如果需要更便宜且合适的LDO，推荐LR6206B-U33(LDO)，XC6206P332MR(LDO)，HXY6206I-3.3(LDO)，也可在立创商城中自行选择。

下面是它们的对比图：

<div class='center'><img src='https://www.writebug.com/static/uploads/2024/5/15/cd13162f205c3497e4c4e4c1b0219770.png' alt='img'/></div>

考虑到STM32F103C8T6最大负载电流为150mA，这里使用XC6206P332MR(LCD, 3.3V~8V to 3.3V, MAX 300mA)，并参考数据手册中的典型应用进行稳压电路设计：
<div class='center'><img src='https://www.writebug.com/static/uploads/2024/5/15/c9d7f4fb14cb94e65dac4d7398894089.png' alt='img'/></div>

对于电源滤波电路，参考芯片数据手册：

<div class='center'><img src='https://www.writebug.com/static/uploads/2024/5/16/69473cecc72e51a9605ca0fc3760beb6.png' alt='img'/></div>



对于状态灯，考虑到其功率不宜较大，可以选用正向压降和工作电流尽量小的LED。例如 XL-1608SURC-06（红），XL-1608UGC-04（绿）两种作为分别作为电源指示灯、状态指示灯。下面根据其数据手册中的具体参数进行设计：



<div class='center'>

|LED型号|XL-1608SURC-06（红）|XL-1608UGC-04（绿）|
|:-:|:-:|:-:|
 |电气参数：|<img src="https://www.writebug.com/static/uploads/2024/6/1/d7bc80695a27a343b8b2e62eb83cbac9.png"/><img src="https://www.writebug.com/static/uploads/2024/6/1/c56d9be02eb0b33e53947e4d7be9c1a0.png"/>|<img src="https://www.writebug.com/static/uploads/2024/6/1/665a82aff6b61f6484abd5935508e21f.png"/><img src="https://www.writebug.com/static/uploads/2024/6/1/4c26bdcaed51fd33bc8b715245a96ff0.png"/>|
 |适宜值：|正向电压为2.2V时，正向电流约18mA，功率约39.6mW，未超过功率上限50mW| 正向电压为3.0V时，正向电流约20mA，功率约60mW，未超过功率上限70mW |
 |限流电阻（3.3V电源）| 70R~100R | 20R~30R |
</div>

事实上，我们在网上买到的0603小功率LED（如某宝），大多数正向压降在 1.1V~1.5V 之间，工作电流5mA~15mA，限流电阻在100R~1000R间不等（3.3V~5V电源）。我们这里选用600R限流电阻。

### 3. USB转串口

使用USB-micro接口，选用CH340C芯片。

对于CH340C，有一些需要注意的点，我们参考数据手册：
<img src="https://www.writebug.com/static/uploads/2024/5/15/2ce24e9644364df72a18711849e702cf.png"/><img src="https://www.writebug.com/static/uploads/2024/5/15/49b1ab7e992bf24150acd23b75fd8161.png"/><img src="https://www.writebug.com/static/uploads/2024/5/15/46575fde01ced672ffc0ba9c65b39ffe.png"/><img src="https://www.writebug.com/static/uploads/2024/5/15/2f89c3a35c21a206bb205d8e02294dd3.png"/>

并且， 我们希望可以直接通过此USB-micro接口下载程序，因此将CH340C的 RXD 接到单片机的 PA9/USART1_TX，TXD 接到 PA10/USART1_RX

### 4. SWD下载模块

不采用广为流传的接口顺序，将其改为与STLINK-V2接口顺序一致，并添加一个去耦电容。

### 5. 晶振模块
> 晶振选型及相关电容电阻的计算可以参考文章：[切勿忽视晶振的选型设计](https://mp.weixin.qq.com/s?__biz=MzU2MTgyNTc2NA==&mid=2247484342&idx=1&sn=3bc4f307d19ecf78e07392d8fdb83258)，[STM32晶振的选择与计算](https://blog.csdn.net/weixin_45499326/article/details/133465510)

外部高速晶振选用 RC08000619（8MHz），其负载电容值为20uF，为了计算外接的两个电容值，我们查阅晶振和单片机数据手册：
<img src="https://www.writebug.com/static/uploads/2024/5/15/9580874a0f1b78acf26485594809612e.png"/><img src="https://www.writebug.com/static/uploads/2024/5/15/4786bfa425094a47d9a4fab87c968b5a.png"/><img src="https://www.writebug.com/static/uploads/2024/5/15/4786bfa425094a47d9a4fab87c968b5a.png"/>

由负载电容计算公式：

$$
C_{L} = \frac{C_{L1}C_{L2}}{C_{L1}+C_{L2}}+C_{stray}
$$

其中$C_L$为负载电容（在MCU手册中典型值为30pF，我们选用的晶振负载电容 $\ge 4pF$即可，这里取 $C_L=20pF$），$C_{L1}$和$C_{L2}$即为上图中的两个电容（一般我们令它们相等），$C_{stray}$ 为PCB和MCU_Pin等带来的额外电容值（在F103C8T6的手册中推荐估计值为10pF，实际范围一般在0.1pF~7pF间，我们取 $C_{stray}=10pF$）。代入计算可得$C_{L1}=C_{L2}=20pF$。

注意：严谨地说，由MCU手册，我们还需要在OSC_OUT口外另接一外部串联电阻$R_{EXT}$，如图：<img src="https://www.writebug.com/static/uploads/2024/5/17/821cbd8ee8281f949fad076bec749a08.png"/>

它的值与等效串联电阻$R_S$有关（$R_S$常记为ESR，即 Equivalent Series Resistance，也称作谐振电阻）。$R_S$的值需要查阅晶振数据手册，$R_{EXT}$的计算我们不作展开，只说明其典型取值是$R_S$的2~6倍，这里可以取$R_{EXT} = 300\Omega $。
但令一方面，考虑到晶振线为高频信号线，在PCB布线时我们一般要进行差分对等长调节，同时又要求晶振（包括滤波）离引脚尽可能的近。如果我们将电阻$R_{EXT}$串联进去，会为等长布线带来极大的困难。
实际上，$R_{EXT}$的作用主要为限流（限制晶振信号振幅），在这里，即使不加串联电阻$R_{EXT}$，晶振也在正常工作范围内（振幅未超出正常范围）。综合考虑下来，我们不加电阻$R_{EXT}$，如图：
<img src="https://www.writebug.com/static/uploads/2024/5/17/c2511db5dcbb669ce6ccd2362f2535e9.png"/>

对于外部低速晶振，我们选用 RNA32768117（32.768KHz），同样，为了计算负载电容值，我们查阅晶振的数据手册：

查阅单片机数据手册：
<img src="https://www.writebug.com/static/uploads/2024/5/15/25a67de572c57ef2ff0be42a0cbf7646.png"/><img src="https://www.writebug.com/static/uploads/2024/5/15/fcc627dd104be108115f2982d61baf01.png"/>
注意：在STM32F103C8的数据手册中可以看到，此款单片机外部低速晶振的负载电容!!#ff0000 不宜超过7pF!!，且!!#ff0000 一定不要选用负载电容为12.5pF的晶振!!。

类似地，我们令$C_{L1}=C_{L2}$，代入$C_{L}=6pF$（由晶振手册得到）和$C_{stray}=2pF$（MCU手册中给出的典型估计值为2pF至7pF），可以得到$C_{L1}=C_{L2}=8pF$


### 6. 复位电路

对于STM32F103C8T6，其NRST脚为低电平时执行复位，因此需要将此脚拉高，并用按键接地，使得按键按下时引脚被拉低。

如图：
<img src="https://www.writebug.com/static/uploads/2024/5/18/b2d047f41984dd801d17c3d753bd72d9.png"/>

### 7. 启动方式

BOOT Modes：

<div class='center'>

| 步骤| 图片 |
| :------: | :------: |
 | 在立创EDA器件栏中搜索STM32F103C8T6，查看数据手册 | <img src="https://www.writebug.com/static/uploads/2024/5/13/a87848aee7749836a47db123257f38ce.png"/>|
 | 找到 "BOOT modes" |<img src="https://www.writebug.com/static/uploads/2024/5/13/a4f4fb2de07411fd72dc478ea8447a02.png"/>|
 | 三种模式分别为：1. Flash启动，2. System memory启动，3. embedded SRAM(embedded static random access memory，内嵌静态随机存储器) |<img src="https://www.writebug.com/static/uploads/2024/5/14/6d8dc36c50a6ef8df7347e22cb86f4c6.png"/>|
 | BOOT1一般我们不会调整，只需将BOOT0接一按键便于调节即可 | 无 |

</div>

效果：
<img src="https://www.writebug.com/static/uploads/2024/5/18/90cda8860606b5a71e535f6056c6a048.png"/>

## PCB设计

在原理图中 Ctrl+A 全选，点击上方菜单栏 "设计"--"转换原理图到PCB"。对某一模块进行摆放时，在原理图中选中此模块相关器件，Shift+X 可快速跳转到 PCB 并选中相关器件，Ctrl+Shift+X 可将原理图中的器件布局传递到 PCB 。下面是一些常用快捷键的汇总：

<div class='center'>

| 快捷键 | 作用 |
| :------: |:------: |
| Shift+X | 跳转到PCB或原理图并选中此器件 |
| Ctrl+Shift+X | 将原理图布局传递到 PCB |
| Shift+H | 高亮网络 |
| Ctrl+R | 隐藏/显示飞线 |
|Alt+W|绘制导线|
|Alt+V|放置过孔|
|Alt+B|移动到底层|
|Shift+A|等长调节|
|Alt+D|差分对布线|

</div>

可以先隐藏飞线，先进行器件摆放、丝印修改：
<div class='center' ><img src="https://www.writebug.com/static/uploads/2024/5/17/44ac40d46d32c44c90f7cb6b2760206a.png" style="height: 600px"/></div>

然后隐藏丝印，进行布线。布线时优先布局晶振线（晶振下层不要走任何其他导线）、信号线（同时注意调整差分对等长、滤波电容靠近引脚），然后布线其他部分，最后再考虑电源线和地线：
<div class='center' ><img src="https://www.writebug.com/static/uploads/2024/5/17/1f35cfdc4afd15d2f8b3f0a11f07a66d.png" style="height: 600px"/></div>

将电源线连接完毕之后，在下图中，根据单片机最大电流，修改电源导线宽度（默认铜厚0.035mm，线宽10mil=）：
<div class='center' ><img src="https://www.writebug.com/static/uploads/2024/5/17/d062b59ca1567d2436a121e9d778e7f2.png" style="height: 300px"/></div>

建议电源线尽量宽，可以为标准对应关系的3~5倍，SMT32F103C8T6最大电流150mA，对应线宽小于0.15mm，这里选择3.3V线宽为15mil=0.381mm，5V线宽为20mil=0.508mm，如图：<div class='center' ><img src="https://www.writebug.com/static/uploads/2024/5/17/bf844da9dcb56c2ce16d5c0c617562d5.png 	" style="height: 600px"/></div>

当仅剩地线GND未连接时，进行铺铜，将地线连接完毕，并检查有无错误：<div class='center' ><img src="https://www.writebug.com/static/uploads/2024/5/17/e70921650b64c5e8aab6e0ba795edd1c.png" style="height: 600px"/></div>
## 物料表与焊接图
BOM表（简略）：
- 主控芯片：
	- STM32F103C8T6（或STM32F103CBT6，LQFP48封装）：1个
- LDO稳压3.3V：
	- XC6206P332MR（SOT-23封装）：1个
- USB转串口：
	- CH340C（SOP-16封装）：1个
- 晶振：
	- 8MHz（HC-49S-SMD封装）：1个
	- 32.768KHz（DT-38封装）：1个
- Micro接口：
	- Micro-B（SMD封装）：1个
- 电容（0603）
	- 8pF：2个
	- 20pF：2个
	- 0.01uF：1个
	- 0.1uF：11个
	- 1uF：  4个
	- 4.7uF：1个
	- 10uF：2个
- 电阻（0603）：
	- 660R：2个
	- 10K：4个
- LED（0603）：
	- 红：1个
	- 蓝（或绿）：1个
- 开关：
	- 自锁开关（5.8*5.8mm）：1个
	- 按键（6*3.5mm）：2个
- 排针：
	- 4P（2.5mm）：1个
	- 20P（2.5mm）：2个 

下表是推荐焊接顺序（从上至下依次焊接），在PCB板上容易找到位号或丝印：

<div class='center'>

| 名称 | 丝印标识 | 
| :-: |:-: | 
| 0.1uF电容（位置详见下图）|  C6 C9 C12 C13 C14, C2 C7, C8 C11, C10  |
| 1uF电容 | C4 C5 C16  |
| 8pF电容| C19 C20   |
|20pF电容| C15 C18 |
| 4.7uF电容 |C1 |
| 0.01uF电容 | C17 |
| 10uF电容 | C3 |
| 10K电阻 | R1 R2 R6 R7 |
| LED | PC13，Power |  
| 660R电阻 | R3 R4  |
| LDO稳压 | U1 |
| 用洗板水或酒精 |清洗一次板子|
| 主控芯片 | U6 |  
| USB转串口 | U2 |
| 高速晶振 | U7 |
| Micro接口|Micro |
| 0.1uF电容（背面） |C22|
| 1uF电容（背面） |C21|
| 低速晶振（插件） | X1 | 
|电源开关（插件）|U4|
| 按键（插件） | Reset，BOOT0|
| 排针（插件） | H3，H4，H5 |
| 清洗PCB | 检查有无虚焊、短路 |
</div>

0.1uF电容位置图片：
<div class='center'><img src="https://www.writebug.com/static/uploads/2024/5/30/d45257fe561033ab8863ad19be0ddd23.png" style="height: 600px"/></div>

## 参考文章

[《立创EDA画图过程，实际布线考虑，自动布线的多板框问题，自动布线》](https://blog.csdn.net/weixin_43794311/article/details/129516797)  
[《[立创eda]PCB版绘制教程》](https://blog.csdn.net/weixin_65176607/article/details/134158201)  
[《电子通识：CH340C与CH340G的区别》](https://blog.csdn.net/weixin_51792779/article/details/136763934)  
[《零基础DIY/嵌入式教程-自动下载电路分析》](https://blog.csdn.net/weixin_37847447/article/details/136021916)  
[《零基础DIY/嵌入式教程-CH340C使用教程-引脚说明》](https://blog.csdn.net/weixin_37847447/article/details/135965762)  
[《stm32f103c8t6最小系统板》](https://blog.csdn.net/m0_73963748/article/details/134776364)  
[《电路基础知识——常见晶振电路》](https://blog.csdn.net/weixin_52856735/article/details/131041138)  
[《Altium Designer学习之1——Stm32f103c8t6最小系统板》](https://blog.csdn.net/weixin_53405696/article/details/131635769)  


