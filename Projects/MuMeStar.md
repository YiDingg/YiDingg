# MuMeStar (Mutiple Menu Star for OLED)

## 项目说明

这是一个OLED多级菜单项目，（以下简称 “菜单” ），菜单基于多叉树结构，底层逻辑自洽，移植简单，可无限扩展。相关代码全部开源，持续更新。

本文介绍了项目目前成果及其实现原理，提供了源代码下载渠道，以供学习参考。

<div class='center'>

| 相关链接 |
| :------: |
| 源码下载(GitHub)：[MuMeStar](https://github.com/YiDingg/MuMeStar)  |
|代码移植方法、详细扩展教程：[MuMeStar (Mutiple Menu Star for OLED)](https://yidingg.github.io/YiDingg/#/Projects/MuMeStar%20(Mutiple%20Menu%20Star%20for%20OLED)%20%E8%AF%A6%E8%A7%A3) |
</div>

由于个人时间、精力和水平有限，项目难免存在不足，望读者不吝指正。

- 示例硬件环境一：
	- 单片机型号：STM32F103C8T6
	- OLED型号：0.96寸128x64屏幕，SSD1306控制芯片，IIC通信协议，4管脚。
- 示例硬件环境二：
	- 单片机型号：STM32F103VCT6
	- OLED型号：0.96寸128x64屏幕，SSD1306控制芯片，SPI通信协议，7管脚。

## 演示视频

>下面为 V1.2.0 版本的非正式演示视频，最新版本（V1.2.2）已支持动画效果和更多功能，新版本正式演示视频等有时间再录制。

<video class='center' controls="false"  muted="muted" id="video1" name="media"><source src="https://write-bug-backend.oss-cn-beijing.aliyuncs.com/static/uploads/2024/7/4/abd306f26cbfca441b3494317798eb0f.mp4" type="video/mp4"></video>

## 移植方法

**注：**

-   菜单默认添加了小恐龙游戏，如果需要节省空间，只需在 Mutimenu.h 中取消小恐龙游戏的宏定义。

| 步骤 |详细 | 图片 |
| :------: | :------: | :-:|
 | 1. 新建工程并配置基本参数 | 在 CubeMX 中新建一个工程，依次配置：RCC为外部高速时钟，SYS为 SD Debug，调整项目路径、名称，代码生成设置等 | 无 |
 | 2.若为IIC通信，配置IIC接口 | 打开一个IIC接口（图中是I2C2，I2C模式），添加IIC对应的DMA（IIC_TX），并打开 I2C event interrupt 中断（可自由设置IIC通讯速率，I2C error interrput 也建议打开 ） | <img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-17-44.png"/><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-18-16.png"/><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-18-19.png"/> |

<div class='center'>

| 步骤 |详细 | 图片 |
| :------: | :------: | :-:|
 | 1. 新建工程并配置基本参数 | 在 CubeMX 中新建一个工程，依次配置：RCC为外部高速时钟，SYS为 SD Debug，调整项目路径、名称，代码生成设置等 | 无 |
 | 2.若为IIC通信，配置IIC接口 | 打开一个IIC接口（图中是I2C2，I2C模式），添加IIC对应的DMA（IIC_TX），并打开 I2C event interrupt 中断（可自由设置IIC通讯速率，I2C error interrput 也建议打开 ） | <img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-17-44.png"/><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-18-16.png"/><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-18-19.png"/> |
 |3. 若为SPI通信，配置SPI接口|打开一个SPI接口（图中是SPI1，Transmit Only Master模式），添加SPI对应的DMA（SPI_TX），并打开 SPI global interrupt 中断（可自由设置SPI通信速率）；然后配置三个GPIO口（PP Output模式，分别连接OLED的CS, DC, RES接口）|<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-18-50.png"/><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-18-54.png"/>  |
 |4. 配置四个GPIO外部中断作为按键| 外部中断模式（记得打开中断），根据具体硬件环境选择下降沿触发+内部上拉或者上升沿触发+内部下拉，四个按键分别对应 Previous, Enter, Next, Return  |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-18-58.png"/><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-19-01.png"/>|
 |5. 配置状态灯GPIO口| 配置一个PP Output 模式GPIO口作为状态灯（在程序中，任意按键按下会使状态灯电平翻转） |<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-07-13-32-22_MuMeStar (Mutiple Menu Star for OLED) 详解.jpg"/></div>|
 |6. 生成代码并编译 | 保存并生成代码，在Keil中编译一次 | - |
 |7. 添加项目文件| 将下载好的六个文件（MutiMenu.c，MutiMenu.h，Mutimenu_Data.h，OLEDSD.c，OLEDSD.h，OLEDSD_Font.h）复制到项目目录下的inc文件夹（.h文件放这里）和src文件夹（.c文件放这里）|<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解-2024-06-21.png" alt="MuMeStar (Mutiple Menu Star for OLED) 详解-2024-06-21"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解-2024-06-21-02-11-33.png"> |
 |8. 修改main.c| 在main.c中 #include "MutiMenu.h"，并在while(1)循环中使用函数 Menu_Handler() |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解-2024-06-21-02-11-38.png"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解-2024-06-21-02-11-42.png">|
 |9. 移植完成| 菜单移植完成，编译并下载，连接好硬件部分，可以看到菜单正常显示 |<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-07-13-27-22_MuMeStar (Mutiple Menu Star for OLED) 详解.jpg"/></div>|
</div>



## 如何自由扩展菜单
### 1. 添加 Parent 菜单
目标：在某个 Parent 型菜单下，添加一个 Parent 型菜单。下面以添加 "游戏" 选项为例。

<div class='center'>

| 步骤 | 详解 | 图片 |
| :------: | :------: | :------: |
 | 1. 声明新菜单  | 在 Multimenu.c 的 "菜单栏定义" 中声明需要添加的 Parent 型菜单，Parent 型菜单数组大小即为子菜单数目。这里我们仅在其下添加一个 "Dinosaur" 选项，因此 Parent 型菜单数组大小为1。另外，建议数组名字根据级别依次往下连接，避免混淆位置，这里以将 Game 选项放在了 Main 下。 |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-19-42.png"/>|
 | 2. 定义新菜单并添加结构体 | 在 main.c 中的 Main 菜单下加入 Game 菜单（!!#ff0000 子节点函数填写 Draw_Menu!!），并在 "Menu_1" 下方添加 Game 菜单的定义，Menu_1 表示其为一级菜单（Main为0级），然后!!#ff0000 修改Main菜单数组大小!!（在宏定义处修改） | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-07-13-31-47_MuMeStar (Mutiple Menu Star for OLED) 详解.jpg"/></div><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-19-49.png"/> |
 |3. 编译并下载 | 可以看到，成功实现菜单的添加 | 无 |
</div>

### 2. 添加 Data 菜单

目标：在某个 Parent 型菜单下，添加一个 Data 型菜单。下面以添加 "亮度设置" 选项为例。

<div class='center'>

| 步骤 | 详解 | 图片 |
| :------: | :------: | :------: |
 | 1. 声明新菜单  | 在 Multimenu.c 的 "菜单栏定义" 中声明需要添加的 Data 型菜单，Data 型菜单数组大小需为1。另外，建议数组名字根据级别依次往下连接，避免混淆位置；这里以将 Brightness 选项放在了 Main 的 Settings 下。 |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-20-00.png"/>|
 | 2. 定义新菜单并添加结构体 | 在 Multimenu.c"菜单栏定义" 的 " Menu_2 " 中定义刚刚声明的菜单（即数组），Menu_2 表示其为二级菜单（Main为0级）；并在其父级菜单（这里是 Settings，位于 " Menu_1 " ）中添加结构体，添加结构体时!!#ff0000 勿忘修改数组大小，然后修改 Main_Settings 中的子节点数目！!! | <img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-20-04.png"/><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-20-08.png"/><div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-07-13-26-27_MuMeStar (Mutiple Menu Star for OLED) 详解.jpg"/></div> |
 | 3. 新增两个节点函数 | 在 "菜单节点函数" 处定义你的函数。第一个节点函数在进入 Brightness 时调用（记为 Func_Brightness_enter ） ，第二个（记为 Func_Brightness_set）在进入 Brightness 后，有其他按键按下时调用。这两个函数共同实现了我们需要的功能：显示亮度调节页面，next 增大亮度，previous 减小亮度，同时在屏幕上显示当前亮度值，enter 或 return 确定更改。 |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-20-19.png"/> |
 | 4. 进行函数的编写与指针替换 | 注意：两个函数都应为 void func(void) 型，利用全局变量 KEY_num 传递键值。 编写完毕后，将  Func_Brightness_enter 替换到 Settings 数组的函数指针处，将 Func_Brightness_set 替换到 Brightness 定义的函数指针处。  |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-20-28.png"/><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-20-31.png"/>|
 |5. 在 Multimenu.h 中声明函数| 在 "自定义菜单节点函数声明" 处进行声明，注意不要忘了分号|<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-20-45.png"/>|
 |6. 编译并烧录 | 可以看到，成功实现屏幕亮度自由调节 |<video controls="false"  muted="muted" id="video1" name="media" style="width:300px"><source src="https://write-bug-backend.oss-cn-beijing.aliyuncs.com/static/uploads/2024/5/13/19916860e374f57a105a3622b3939622.mp4" type="video/mp4"></video>|

</div>



### 3. 添加 Once 菜单

目标：在某个 Parent 型菜单下，添加一个 Once 型菜单。下面以添加在 "Hello" 下的 "Sayhello" 选项为例。

| 步骤 | 详解 | 图片 |
| :------: | :------: | :------: |
 | 1. 声明新菜单  | 在 Multimenu.c 的 "菜单栏定义" 中声明需要添加的 Once 型菜单，Once 型菜单数组大小需为1。另外，建议数组名字根据级别依次往下连接，避免混淆位置。 |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-24-50.png"/>|
 | 2. 定义新菜单并添加结构体 | 在 Multimenu.c "菜单栏定义" 的 " Menu_2 " 中定义刚刚声明的菜单（即数组），节点函数可以先填 {NULL, 0, Invalid_Operation} 中的任一个以避免报错 ，注释写的 Menu_2 表示其为二级菜单（Main为0级）；并在其父级菜单（这里是 Hello，位于 " Menu_1 " ）中添加结构体，添加结构体时勿忘修改数组大小。结构体示意图见 "4.2 添加 Data 型菜单" | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-07-13-32-58_MuMeStar (Mutiple Menu Star for OLED) 详解.jpg"/></div>|
 | 3. 新增一个节点函数 | 在 "菜单节点函数" 处定义你的函数。函数在 enter 此菜单时调用，我们编写函数以在屏幕上显示 "Hello world!" |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-24-58.png"/> |
 | 4. 进行函数的编写与指针替换 | 注意：函数应为 void func(void) 型。 编写完毕后，将其替换到父菜单数组的对应结构体中  |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-25-08.png"/> |
 |5. 在 Multimenu.h 中声明函数| 在 "自定义菜单节点函数声明" 处进行声明，注意不要忘了分号|<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-25-12.png"/>|
 |6. 编译并烧录 | 可以看到，成功实现 Sayhello 功能 |<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-06-29-13-48-08_MuMeStar (Mutiple Menu Star for OLED) 详解_.jpg"/></div> |

### 4. 添加 Loop 菜单
目标：在某个 Parent 型菜单下，添加一个 Loop 型菜单。下面以添加在 "Hello" 下的 "Smile" 选项为例。

| 步骤 | 详解 | 图片 |
| :------: | :------: | :------: |
 | 1. 声明新菜单  | 在 Multimenu.c 的 "菜单栏定义" 中声明需要添加的 Loop 型菜单，Loop 型菜单数组大小需为1。另外，建议数组名字根据级别依次往下连接，避免混淆位置；这里以将Smile 放在了 Main 的 Hello 下。 |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-25-22.png"/>|
 | 2. 定义新菜单并添加结构体 | 在 Multimenu.c"菜单栏定义" 的 " Menu_2 " 中定义刚刚声明的菜单（即数组），Menu_2 表示其为二级菜单（Main为0级）；并在其父级菜单（这里是 Hello，位于 " Menu_1 " ）中添加结构体，添加结构体时勿忘修改数组大小  |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-25-25.png"/>|
 | 3. 新增两个节点函数 | 在 "菜单节点函数" 处定义你的函数。第一个节点函数在进入 Smile 时调用（记为 Func_Smile_enter ） ，第二个（记为 Func_Smile_run）在进入 Smile 后，有其他按键按下时调用。这两个函数共同实现了我们需要的功能：enter函数进行初始化，循环调用run函数。一个示例功能是：next 笑脸右移，previous 笑脸左移，enter 笑脸反色， return 退出。 |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-25-30.png"/>|
 | 4. 进行函数的编写并替换指针 | 注意：两个函数都应为 void func(void) 型，利用全局变量 KEY_num 实现键值传递。 编写完毕后，将  Func_Smile_enter 替换到 Hello 数组下的的smile节点函数指针处，将 Func_Smile_run 替换到 Smile 定义的函数指针处。  |<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-07-13-32-01_MuMeStar (Mutiple Menu Star for OLED) 详解.jpg"/></div>|
 |5. 在 Multimenu.h 中声明函数| 在 "自定义菜单节点函数声明" 处进行声明，注意不要忘了分号| <img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/MuMeStar (Mutiple Menu Star for OLED) 详解--2024-06-23-00-25-38.png"/>|
 |6. 编译并烧录 | 可以看到，成功实现笑脸眼睛循环转动，且横向位置可调、循环可随时暂停 |<video controls="false"  muted="muted" id="video1" name="media" style="width:300px"><source src="https://www.writebug.com/static/uploads/2024/5/13/694fac4c38008c055e88d17a4e448a3b.mp4" type="video/mp4"></video>|

## 原理详解

### 1. 底层数据结构
> 此部分需要结构体、结构体指针、函数指针、结构体递归、多叉树、状态机等知识基础。

菜单的常见结构类型有链表（序号索引）、树（父子索引）等，本菜单采用多叉树结构实现。

在 Version 2.0 中有四种菜单属性：
- Parent：父菜单型，表示其下有一个或多个子菜单，无特定功能
- Data：数据型，表示此项可调整某项数据（如调整屏幕亮度）
- Once：单次型，表示执行一次某种操作后进入等待状态，直至退出
- Loop：循环型，表示一直执行某种操作，直至退出

每个菜单作为一个结构体数组存在，数组中的元素即为所定义的结构体。

代码如下：
``` c
// 定义菜单属性
enum MenuProperties{  
  Menu_Parent=1,
  Menu_Data,
  Menu_Once,
  Menu_Loop,
};

// 定义菜单底层结构体
typedef struct Menu{
  char *Name;                     // 子节点标题
  const struct Menu *Parent;            // 父节点结构体数组
  const struct Menu *Child;             // 子节点结构体数组 
  void (*func)(void);                   // 子节点函数(进入子节点时调用)
  uint8_t Child_nodes_number;         // 子节点的子节点数 
  enum MenuProperties Menuproperty;   // 子菜单属性
} Menu_typedef;
```
通过定义不同属性的菜单，实现可无限拓展的多级菜单（只要硬件内存足够），例如 Version 2.2 中的菜单定义：

```c

/* ------下面是菜单栏定义 ------ */

/* 菜单节点初始化(节点声明) */
#define Main_Child_nodesnumber 6    // 宏定义主菜单子节点数,方便操作
const Menu_typedef 
Main[Main_Child_nodesnumber],
    Main_Settings[2],
        Main_Settings_Fontsize[1],
        Main_Settings_Brightness[1],     
    Main_Hello[2],
        Main_Hello_Sayhello[1],
        Main_Hello_Smile[1],
    Main_About[1],
    Main_Menu4[1],
    Main_Menu5[1],
    Main_Menu6[1];

/* Menu_Root, Menu_0 */
Menu_typedef *Menu_Pointer =  (Menu_typedef *)Main; // 设置当前菜单为 Main 并初始化

char UserChoose = 0;        // 初始化光标为第 0 行
const Menu_typedef Main[Main_Child_nodesnumber] = {             
    {"Main",    NULL, Main_Settings,  Draw_Menu,         2,Menu_Parent},
    {"Main",    NULL, Main_Hello,     Draw_Menu,         2,Menu_Parent},
    {"Main",    NULL, Main_About,     Func_About,    1,Menu_Once},
    {"Main",    NULL, Main_Menu4,     0, 0},
    {"Main",    NULL, Main_Menu5,     0, 0},
    {"Main",    NULL, Main_Menu6,     0, 0},
};

/* Menu_1 */
const Menu_typedef Main_Settings[2] = {             
    {"Settings", Main,  Main_Settings_Fontsize,   Func_Fontsize_enter, 1, Menu_Data},
    {"Settings", Main,  Main_Settings_Brightness,  Func_Brightness_enter, 1, Menu_Data}
};

const Menu_typedef Main_Hello[2] = {                
    {"Hello", Main,  Main_Hello_Sayhello,Func_Sayhello, 1,Menu_Once},
    {"Hello", Main,  Main_Hello_Smile,0, 0}
};

const Menu_typedef Main_About[1] = {{"About",Main,NULL,0, 0},};
const Menu_typedef Main_Menu4[1] = {{"Menu4",Main,NULL,0, 0},};
const Menu_typedef Main_Menu5[1] = {{"Menu5",Main,NULL,0, 0},};
const Menu_typedef Main_Menu6[1] = {{"Menu6",Main,NULL,0, 0},};

/* Menu_2*/
const Menu_typedef Main_Settings_Fontsize[1] = {{"Fontsize",Main_Settings,NULL,Func_Fontsize_set, 0,Menu_Data}};
const Menu_typedef Main_Settings_Brightness[1] = {
    {"Brightness",Main_Settings,NULL,Func_Brightness_set, 0, Menu_Data}
};
const Menu_typedef Main_Hello_Sayhello[1] = {{"Sayhello",Main_Hello,NULL,NULL, 0,}};
const Menu_typedef Main_Hello_Smile[1] = {{"Smile",Main_Hello,NULL,0, 0}};

/* ------上面是菜单栏定义 ------ */
```

### 2. 无延迟按键
在 Version 3.0 之前（不包括V3.0），我们利用 EXIT IT (外部中断) 机制，实现按键的无延迟获取。在按键按下瞬间，系统调用 HAL_GPIO_EXTI_Callback() 中断回调函数执行按键总控，并根据键值处理相关事件，在事件处理完毕后中断结束，回到主程序。这样做的好处除了按键无延迟，还能保证相关事件不会和主程序起冲突，主程序中可以编写任意其它代码。

例如，假设某一按键被按下，触发外部中断：

``` c
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
	if(GPIO_Pin == Key_previous_Pin||GPIO_Pin == Key_next_Pin||GPIO_Pin == Key_enter_Pin||GPIO_Pin == Key_return_Pin){KEY_Pressed(GPIO_Pin);}
}
```

KEY_Pressed() 函数获取当前菜单属性，进而调用不同菜单按键：

``` c
/**
 * @brief 按键总控函数, 任意按键按下时触发, 提取当前菜单属性并调用对应函数
 * @retval void
*/
void KEY_Pressed(uint8_t GPIO_pin){
    uint8_t ispressed;
    // 获取当前菜单属性
    enum MenuProperties property;   
    // -----------------------------------------------------
    if(Menu_Pointer == Main){ property = Menu_Parent; }
    else{property = Menu_Pointer->Parent[Get_menu_index(Menu_Pointer)].Child_Menuproperty;}
    HAL_Delay(15);  // 按键消抖
    ispressed =     HAL_GPIO_ReadPin(Key_return_GPIO_Port,Key_previous_Pin)&&
    HAL_GPIO_ReadPin(Key_next_GPIO_Port,Key_next_Pin)&&
    HAL_GPIO_ReadPin(Key_enter_GPIO_Port,Key_enter_Pin)&&
    HAL_GPIO_ReadPin(Key_return_GPIO_Port,Key_return_Pin);
    /* 根据菜单属性调用函数 */
    if(ispressed == 0){     // 防误触
        switch (property)
        {
        case Menu_Parent:   // Menu_Parents 型菜单
            KEY_Parent_pressed(GPIO_pin);
            break;
        case Menu_Data:
            KEY_Data_pressed(GPIO_pin);
            break;
        case Menu_Once:   // Menu_Parents 型菜单
            KEY_Once_pressed(GPIO_pin);
            break;
        case Menu_Loop:   // Menu_Parents 型菜单
            break;
        default:
            break;
        }
        HAL_GPIO_TogglePin(GPIOC,GPIO_PIN_13);  // 状态灯
    }
    else {return;}
    HAL_Delay(15);  // 按键消抖
}
```

例如调用 KEY_Parent_pressed() 函数：

``` c
/**
 * @brief 经过 KEY_Pressed() 函数判定当前菜单为 Parent 型后调用此函数
 * @param GPIO_pin 被按下的 GPIO 口
 * @retval void
*/
void KEY_Parent_pressed(uint8_t GPIO_pin){
     switch (GPIO_pin){
            case Key_previous_Pin:KEY_Parent_previous();break;
            case Key_next_Pin:KEY_Parent_next();break;
            case Key_enter_Pin:KEY_Parent_enter(); break;
            case Key_return_Pin:KEY_Parent_return();break;
            default: return;
        }
}

void KEY_Parent_next(void){
    uint8_t nodes_number = Menu_Pointer->Parent->Child_nodes_number;
    if(Menu_Pointer == Main){nodes_number = Main_Child_nodesnumber;}    
    // 判断 当前菜单子项目数 与 最大显示行数 大小关系
    if(nodes_number<=Mysize[fontsize].row_number){
        if(UserChoose == nodes_number-1 ){UserChoose = 0;}
        else{UserChoose++;}
    }
    else{
        if( UserChoose == Current_showrange + Mysize[fontsize].row_number -1 ){   // 到达显示下边界
            if( UserChoose == nodes_number-1 )
            {Current_showrange=0;UserChoose=0;}    // 到达选项下边界
            else{Current_showrange++;UserChoose++;}
        }
        else{   // 未到达显示边界
            UserChoose++;
        }
    }
    Draw_Menu();
}

/* 
KEY_Parent_previous() 
KEY_Parent_enter()
KEY_Parent_return()
详见源代码
*/
```

## 参考文章

项目的建立和完善参考了多方资料，感谢他们的开源分享，并附在此处以供查阅。

- [《树状菜单实现》](hhttps://blog.csdn.net/qq_21154037/article/details/103149513) 
- [【开源单片机多级菜单+OLED动画原理讲解】](https://www.bilibili.com/video/BV1Y94y1g7mu)
- [GitHub: MultMenu](https://github.com/JFeng-Z/MultMenu) 
- [Gitee: 函数指针多级菜单](https://gitee.com/AdamLoong/Embedded_Menu_Simple) 
- [App: 波特率动](https://led.baud-dance.com/)

