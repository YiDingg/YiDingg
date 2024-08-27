# Circuit Theory Notes (1): Introductions (绪论)

本章首先介绍几个有关电路的基本问题，然后研究电压、电流和功率的定义，接下来简单介绍电路在信号处理与能量处理方面的应用，最后讨论电路的分类。本章是所有后
续章节的共同基础。

## 电路（Electric Circuit）

### 电路原理

一般来讲，电路的研究内容分为电路分析、电路综合，分别对应电路研究的正问题（已知电路求电路的解）和逆问题（已知解求电路结构参数）。

<div class='center'><img src='https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-27-11-58-03_CircuitTheoryNotes(1)-Introductions.png' alt='img'/>
<div class='caption'>Figure: 电路原理与其他电类主要课程的联系</div></div>

有些电路原理课程习惯用大写英文字母表示不随时间变化的常量，用小写英文字母表示随时间变化的量。在本笔记中，时变量、瞬时量、微元量均用小写表示，其它情况一般用大写。

### 电路物理量

电流、电压：
$$
\begin{equation}
i = \frac{\mathrm{d}q}{\mathrm{d}t},\ u = \frac{\mathrm{d}W}{\mathrm{d}q}
\end{equation}
$$

电位（电势，potential）：选定参考点（reference point）后，电路中某一点的电势，用 $\varphi$ 表示。如果不引起歧义，也常用 $U$ 表示。两点间电位差（电势差，potential difference）即为电压。

电动势（electromotive force, e.m.f.）：非静电力克服电场力搬运单位正电荷所做的功（使电势升高, potential rise）。

在分析电路时，<span style='color:red'> 必须 </span> 事先规定电路电流的参考方向（正方向），也必须规定电压的参考方向或参考极性。

### 其它概念

端口：封装好的电路元件与电路其它部分的联接点称为端纽、端子或接线端（terminal）。如果从元件的两个端纽看进去满足 $i = -i'$，则这两个端子被称为一个端口。

<div class='center'><img src='assets/draw.ioFiles/端口.drawio.svg' alt='img'/>
<div class='caption'>Figure: 端口示意图</div></div>
 
### 部分电气图图形符号

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-27-11-17-16_CircuitTheoryNotes(1)-Introductions.jpg"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-27-11-17-44_CircuitTheoryNotes(1)-Introductions.png"/></div>

## 中英文对照表

<div class='center'>

| English | 中文 |
|:-:|:-:|
 | voltage | 电压 |
 | current | 电流 |
 | power | 功率 |
 | resistance | 电阻 |
 | inductance | 电感 |
 | capacitance | 电容 |
 | conductance | 电导 |
 | frequency | 频率 |
 | circuit | 电路 |
 | circuit element | 电路元件 |
 | circuit network | 电路网络 |
 | signal | 信号 |
 | energy | 能量 |
 | circuit analysis | 电路分析 |
 | circuit synthesis | 电路综合 |
 | circuit design | 电路设计 |
 | circuit simulation | 电路仿真 |
 | circuit topology | 电路拓扑 |
 | circuit elements | 电路元件 |
 |  |  |
</div>