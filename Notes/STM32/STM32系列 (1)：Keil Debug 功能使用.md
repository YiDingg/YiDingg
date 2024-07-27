# STM32系列 (1)：Keil Debug 功能使用 

## 前言
本节目标：利用 Keil_MDK 进行软件Debug，如设置断点、查看寄存器值、查看引脚逻辑电平、设置按键功能等。

> 系列汇总详见地址：[《📕STM32系列汇总》](Blogs\STM32\STM32系列汇总.md) 

## 一、Keil 软件设置
官方对 Keil Debug 功能的说明详见：[官方 Keil Debug 文档](https://developer.arm.com/documentation/101407/0540/Dialogs/Project/Options/Debug?lang=en) 。下面是实际的一些操作：

<div class='center'> 

| 步骤 | 详解 |图片 |
| - | :-: | - |
|1. 调整仿真设置| 在 "Option for Target" 中设置软件仿真（软件Debug）。图片左侧是纯软件仿真，右侧是硬件仿真（如ST-LINK Debug）。 | [![pkdTt7F.png](https://s21.ax1x.com/2024/06/14/pkdTt7F.png)](https://imgse.com/i/pkdTt7F) |
|2. 查询单片机型号 | Dialog DLL和Parameter默认分别是DCM.DLL和-pCM3，该种配置无法进行正常的仿真调试，会导致程序一直在SystemInit()函数死循环。因此需要根据单片机型号输入对应的Dialog DLL和Parameter。参照下图，输入单片机型号进行搜索，搜索的结果便是需要填入的参数。 |[![pkdT360.png](https://s21.ax1x.com/2024/06/14/pkdT360.png)](https://imgse.com/i/pkdT360)  [![pkdTJmT.png](https://s21.ax1x.com/2024/06/14/pkdTJmT.png)](https://imgse.com/i/pkdTJmT)|
|3. 填写型号对应文件 | 这里我使用的是STM32C8T6，于是应填Dialog DLL：DARMSTM.DLL，Parameter：-pSTM32F103C8。最后点击 "Debug" 按键开始调试。 |[![pkdOh9g.png](https://s21.ax1x.com/2024/06/14/pkdOh9g.png)](https://imgse.com/i/pkdOh9g)|
</div>


## 二、各按键功能
软件仿真的所有按键如下图所示（图中罗马数字1表示序号11，罗马2表示12，以此类推）：
<a href="https://imgse.com/i/pkdOzv9"><img src="https://s21.ax1x.com/2024/06/14/pkdOzv9.png" alt="pkdOzv9.png" border="0" /></a>

除执行语句按键外，我们先单独列出经常使用的按键：

<div class="center">

| 按键序号 | 功能 | 详细 | 
| :------ | :------ | :------ | 
| 12. Registers Window | 寄存器窗口 | 此窗口"Interval"下的"Sec"会显示总运行时间，可以前后对比读出语句所需时间，较为常用 | 
| 13. Call Stack Window | 堆栈窗口 | 显示堆栈使用情况，可以查看函数、变量、数组等元素的值和地址 |
| 14. Watch Window | 监视窗口 | 可指定监视某些函数、变量、数组等的值和地址 |
| 16. Serial Window | 串行窗口 | 显示串口(UART)打印信息；提供4个串口打印窗口，用来显示从串口UART打印出来的内容；在窗口内右键可以调整数据形式（字符串、十进制、十六进制） |
| 17. System Analyzer Window | 系统分析仪 | 含多个窗口，包括逻辑分析仪、性能分析仪、代码覆盖率、系统分析仪、系统和线程查看器、组件查看器等 |
| 19. System Viewer Windows | 系统查看器 | 可查看单片机内部外设（如ADC、GPIO、DMA）的寄存器值 |
</div>



下面是所有按键的功能汇总：

<div class="center">

| 按键序号 | 功能 | 详细 |
| :------ | :------ | :------ |
| 1. RST | 复位 | 作用相当于硬件上触发了一次复位，但点击RST之后，你可以看到复位时单片机究竟执行了哪些语句 |
| 2. Run | 运行（到断点） | 全速运行程序，若没有设置断点则不停止运行（需点击Stop手动停止运行） |
| 3. Stop | 停止 | 停止正在运行的程序 |
| 4. Step | 步进 | 一步步执行当前语句，若有函数等，会进入函数一条条执行语句（真正意义上的 “一步步” ） |
| 5. Step Over | 执行当前行 | 一次性执行完当前语句，若当前语句为一函数，不会进入函数，而是把函数当作一行，一次执行完 |
| 6. Step Out | 执行出当前函数 |  若当前位于某函数内部，执行完此函数并跳出 |
| 7. Run to Cursor Line | 执行至光标 | 光标所在行也会被执行；代码行左侧的蓝色小三角代表当前光标位置，黄色小三角代表当前执行位置，绿色方框表示此语句已被执行 |
| 8. Show Next Statement | 显示下一条 | 是指黄色小光标的下一行；当我们一时找不到程序现在执行到哪里，可以点击此键快速跳转 |
| 9. Command Window | 命令窗口 | 显示已经执行的的汇编指令 |
| 10. Disassembly Window | 汇编窗口 | 显示每条语句对应的汇编指令 |
| 11. Symbols Window | 符号窗口 | 不常用 |
| 12. Registers Window | 寄存器窗口 | 此窗口"Interval"下的"Sec"会显示总运行时间，可以前后对比读出语句所需时间 |
| 13. Call Stack Window | 堆栈窗口 | 显示堆栈使用情况，可以查看函数、变量、数组等元素的值和地址 |
| 14. Watch Window | 监视窗口 | 可指定监视某些函数、变量、数组等的值和地址 |
| 15. Memory Window | 内存窗口 | 提供4个Memory查看窗口，可以在里面输入要查看的内存地址，然后观察这一片内存的变化情况。 |
| 16. Serial Window | 串行窗口 | 显示串口(UART)打印信息；提供4个串口打印窗口，用来显示从串口UART打印出来的内容；在窗口内右键可以调整数据形式（字符串、十进制、十六进制） |
| 17. System Analyzer Window | 系统分析仪 | 含多个窗口，包括逻辑分析仪、性能分析仪、代码覆盖率、系统分析仪、系统和线程查看器、组件查看器等 |
| 18. Trace Window | 跟踪窗口 | 不常用 |
| 19. System Viewer Windows | 系统查看器 | 可查看单片机内部外设（如ADC、GPIO、DMA）的寄存器值 |
| 20. Toolbox | 工具箱 | 不常用 |
</div>

## 三、仿真逻辑分析仪

Keil仿真逻辑分析仪不仅可以查看引脚电平，还能查看全局变量的值、虚拟仿真寄存器（Virtual Simulation Registers, VTREGs）等。下面是官方对其功能范围的描述，以及查看形式设置：
<a href="https://imgse.com/i/pkdjuz4"><img src="https://s21.ax1x.com/2024/06/15/pkdjuz4.png" alt="pkdjuz4.png" border="0" /><img src="https://s21.ax1x.com/2024/06/15/pkdjMQJ.png" alt="pkdjMQJ.png" border="0" /></a>

作为示例，我们仿真运行GPIO_C13电平翻转的程序，在仿真逻辑分析仪中观察电平高低和指定变量的值。

在CubeMX中配置GPIO_C13引脚为 PP Output 模式，在 main.c 中不断翻转引脚电平和变量自增：
``` c
  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  static uint16_t Count;
  while(1)
  {
  	HAL_Delay(100); // 延时100ms
    Count++;
    HAL_GPIO_WritePin(GPIOC,GPIO_PIN_13,n%2);
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
```

<div class="center">

| 步骤 |详细 | 图片 | 
| ------ | :------: |:------: |
  | 1. CubeMX配置引脚 | 配置GPIO_C13引脚为Output PP 模式 | 无 |
| 2.  打开仿真 | 在刚打开仿真时，程序自动运行到 main() 函数开头并停止，此时我们的变量 Count 还未初始化，需要初始化后才能添加到 Logic Analyzer 中，因此我们在 "uint16_t Count;" 语句后设置断点，并点击 Run(F5)，使程序运行到我们的断点处停止。 | [![pkdjlLR.png](https://s21.ax1x.com/2024/06/15/pkdjlLR.png)](https://imgse.com/i/pkdjlLR)|
 | 3. 打开 Logic Analyzer 添加引脚，然后右键设置显示方式| 在逻辑分析仪中添加引脚PC13，下面几种输入等价： | [![pkdj3e1.png](https://s21.ax1x.com/2024/06/15/pkdj3e1.png)](https://imgse.com/i/pkdj3e1)[![pkdj8dx.png](https://s21.ax1x.com/2024/06/15/pkdj8dx.png)](https://imgse.com/i/pkdj8dx)[![pkdjGo6.png](https://s21.ax1x.com/2024/06/15/pkdjGo6.png)](https://imgse.com/i/pkdjGo6)|
 | 4. 添加变量，设置显示方式 | 在程序中找到变量Count，右键并添加到 Logic Analyzer ，然后右键调整显示方式为Analog+Adaptive。如果报错添加失败，关闭仿真再打开，重新配置即可。 |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (1)：Keil Debug 功能使用--2024-06-23-00-28-43.png"/>|
 | 5. 运行并观察 | 可以看到，电平翻转间隔（延时）为 0.1012s=101.2ms 正常，变量自增也正常  |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (1)：Keil Debug 功能使用--2024-06-23-00-28-47.png"/><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (1)：Keil Debug 功能使用--2024-06-23-00-28-50.png"/>|
</div>

!!#ff0000 注意：在打开仿真之前，如果程序被修改，需要重新编译再打开仿真。!!这是因此仿真使用到了编译产生的相关文件，仅保存程序未重新编译时，仿真仍使用之前编译得到的文件。另外，程序里定义Count变量时，之所以使用static关键字，是因为非全局变量（如某函数中创建的变量）无法添加到逻辑分析仪，详见上面官方对其功能范围的说明。

特别地，图中问号点击可以跳转至官方帮助文档：
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (1)：Keil Debug 功能使用--2024-06-23-00-28-55.png"/>

## 四、仿真外部按键

Keil仿真可以自定义按键，按键对应一些函数语句，在按键按下时被执行（效果类似外部中断），配置步骤如下：

## 五、硬件软件调试的区别
单片机的调试（即Debug）一般分为软件和硬件两种。
软件Debug：使用软件模拟调试，用开发单片机程序的软件（IDE）去模拟单片机的指令执行，并模拟单片机片内资源，从而实现调试的目的，但是计算机无法准确的模拟单片机的时序，不可能像真正的单片机运行环境那样执行的指令在同样一个时间能完成（往往要完成的比单片机慢）。
硬件Debug：硬件调试其实也需要计算机软件的配合，大致过程是这样的：计算机软件把编译好的程序通过串行口、并行口或者USB口传输到硬件调试设备中（这个设备叫仿真器），仿真器仿真全部的单片机资源（所有的单片机接口，并且有真实的引脚输出），仿真器可以接入实际的电路中，然后与单片机一样执行。仿真的作用：仿真器也会返回单片机内部内存与时序等情况给计算机的辅助软件，这样 就可以在软件里看到真实的执行情况。不仅如此，还可以通过计算机上的软件实现单步、全速、运行到光标等常规调试手段。

## 参考文章
本文参考的资料，附在此处以供查阅：
[分析使用Keil虚拟仿真示波器仪和真实逻辑仪](https://blog.csdn.net/YouthBlood9/article/details/121792169) 

