# 手把手教你用PWM实现呼吸灯(标准库)

## 前言

用PWM（"Pulse Width Modulation"，脉宽调制）实现呼吸灯一直是十分有趣且有锻炼意义的练习。本文既是笔者对呼吸灯学习的总结，也是学习PWM或呼吸灯的优质教程。

注：本文主控芯片为STM32F103C8T6，基于STM32标准库函数，示例代码适用大部分STM32F1系列芯片。若主控芯片不同，可以查阅参考手册、数据手册，依据具体区别进行必要的修改。

下面是实物效果：

<div class='center'>
    <video controls="controls"  muted="muted" id="video-example" style="width:900px;max-width:80%" loop='0'><source src="https://www.writebug.com/static/uploads/2024/5/10/6bccf8b5481df50e2b76af2a953769b4.mp4" type="video/mp4"></video>
</div>
<div class='center'>
    <video controls="controls"  muted="muted" id="video-example" style="width:900px;max-width:80%" loop='0'><source src="https://www.writebug.com/static/uploads/2024/5/10/2bdae9d10df0e3a3b62db4501f7efd6d.mp4" type="video/mp4"></video>
</div>


## 一、呼吸灯原理
>通过调整PWM信号占空比来控制LED灯的亮度，进而实现人眼中亮度的"连续"变化。
>考虑到部分单片机高电平驱动能力弱，我们以LED阳极接VCC（电源正极）、阴极接IO口（接收PWM信号）为例（建议自行串联限流电阻）。

"占空比"一般指一个时钟周期内高电平所占的时间比例，为了方便，我们定义 "有效占空比" 为LED发光所占时间比例，在这里即为低电平时间比例（LED为低电平点亮）。下图给出了有效占空比为50%的示意图
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/手把手教你用PWM实现呼吸灯(标准库)--2024-06-23-23-19-40.png"/></div>
也就是说，实际上，LED灯一直处于闪烁状态，只是当闪烁频率较高时（不低于60Hz），人眼一般无法观察到闪烁现象，只是认为LED灯的亮度发生了变化，当频率达到90Hz时，绝大部分人完全没有闪烁感。特别地，当有效占空比为0%时，LED亮度最低（完全熄灭），当有效占空比为100%时，LED亮度最高。


## 二、代码实现

>下面我们利用STM32F103C8T6的TIM3定时器实现PWM信号输出，并以此设计呼吸灯控制函数。

### 1. PWM信号输出

我们先直接在main函数中进行操作，观察成功现象并确认代码无误后将其封装为函数，以便直接使用。

下面是我们需要做的事情（不分顺序）：
1. 所用的TIM3是STM32F10系列的普通定时器（具有PWM功能），受APB1预分频器管理，因此我们需要利用APB1下的函数对TIM3进行配置；
2. 需要使用GPIO口来输出PWM信号，而GPOI受APB2管理，因此需要利用APB2下的函数配置GPIO口；
3. TIM3作为普通定时器，可同时输出4路PWM信号（分别从4个IO口输出），每一路PWM信号频率相同，但占空比可以不同，需要对每一路进行配置。

> 在STM32F103C8系列中，TIM3对应四个PWM通道默认为: Channel_1 -- A6, Channel_2 -- A7, Channel_3 -- B0, Channel_4 -- B1，"A6"表示GPIO_A的6号引脚。可通过"部分映射"或"重映射"更改通道所对应的IO口，此部分可根据需求自行设置，这里使用默认IO口。下图是数据手册中TIM3端口的对应关系表：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/手把手教你用PWM实现呼吸灯(标准库)--2024-06-23-23-19-53.png"/></div>

在代码中，我们先对GPIO和TIM3初始化，再对TIM3进行详细配置。并且先不进行具体频率、占空比计算，只给一个可行的初始值。
下面是初始化的代码（配有注释）：

```c
void RCC_Configuration(void)
{
     /* TIM3 clock enable */
     RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM3, ENABLE);   // (利用RCC_APB1下的函数)使能TIM3
     /* GPIOA and GPIOB clock enable */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA|RCC_APB2Periph_GPIOB|RCC_APB2Periph_AFIO,ENABLE);   
    // (利用RCC_APB2下的函数)使能GPIOA，GPIOB, AFIO的使能作用可查询数据手册
}

void GPIO_Configuration(void){
    GPIO_InitTypeDef GPIO_InitStructure;        // 定义并设置初始化结构体
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP; // PP(push-pull)，中文为推挽模式
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;   // 最大频率50MHz
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6 | GPIO_Pin_7;  // 初始化A6,A7端口
    GPIO_Init(GPIOA, &GPIO_InitStructure);  
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1;  // 初始化B0,B1端口
    GPIO_Init(GPIOB, &GPIO_InitStructure);
}
```

下面是TIM3的相关配置（!!#ff0000 配有详细注释!!）：

```c
void TIM3_Configuration(void){
    TIM_TimeBaseInitTypeDef  TIM_TimeBaseStructure;     // 定义TimeBaseInit结构体
    TIM_OCInitTypeDef  TIM_OCInitStructure;             // 定义OCInit结构体
    /* Time base configuration */
    TIM_TimeBaseStructure.TIM_Prescaler = 7200 - 1; // 分频，将系统频率(这里是72MHz)分为7200份，得到10kHz
    TIM_TimeBaseStructure.TIM_Period = 100 - 1; // period: TMI3计数周期值，结合prescaler得到100Hz的中断频率
    TIM_TimeBaseStructure.TIM_ClockDivision = 0;  // 设置时钟分割(这里无需了解，若感兴趣可查阅参考手册)
    TIM_TimeBaseStructure.TIM_CounterMode = TIM_CounterMode_Up;   // 计数器向上计数
    TIM_TimeBaseInit(TIM3, &TIM_TimeBaseStructure);  // 将上面的设置赋予TIM3，并在此基础上设置有效占空比
    
    // 下面以通道3为例：
    /* PWM1 Mode configuration: Channel3 (通道3在这里是B0) */
    TIM_OCInitStructure.TIM_OCMode = TIM_OCMode_PWM1;   // 设置OC(Output Channel)为PWM_1模式
    TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;   // 使能Output
    TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity_Low;    // 有效电平设置为低电平
    TIM_OCInitStructure.TIM_Pulse = 90;  // 设置比较值(决定占空比)
    /* 比较值(CRR)最大不超过计数周期值(ARR)，在我们的例子中(PWM模式为1，且向上计数)当计数值 n<=CRR时 输出有效电平，
    有效电平(LED亮)为低电平，因此 n<= CRR 时LED点亮。其它模式下的有效电平情况可查阅参考手册*/
    TIM_OC3Init(TIM3, &TIM_OCInitStructure);    // 将上面的设置赋予TIM3
    TIM_OC3PreloadConfig(TIM3, TIM_OCPreload_Enable);   // 使能TIM3_OC

    //类似地，对Channel4进行配置
    /* PWM1 Mode configuration: Channel4 (通道3在这里是B1)*/
    TIM_OCInitStructure.TIM_OCMode = TIM_OCMode_PWM1;                   
    TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;
    TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity_Low;    // 有效电平设置为低电平
    TIM_OCInitStructure.TIM_Pulse = 10; 
    TIM_OC4Init(TIM3, &TIM_OCInitStructure);
    TIM_OC4PreloadConfig(TIM3, TIM_OCPreload_Enable);

    /* TIM3 enable counter */
    TIM_ARRPreloadConfig(TIM3, ENABLE); // 使能TIM_ARR(计数器)
    TIM_Cmd(TIM3, ENABLE);  // 使能TIM3
}
```
运行主程序：

```c
#include "stm32f10x.h"   // Device header

void RCC_Configuration(void);
void GPIO_Configuration(void);
void TIM3_Configuration(void);

int main(void){
    RCC_Configuration();
    GPIO_Configuration();
    TIM3_Configuration();
    while (1){}
}
/* 这里把上面用到的三个函数搬下来 */
```
上面的例子中，我们只启用了TIM3的两个通道(Channel3, Channel4)，分别对应B0、B1口。在面包板上，将LED正极与单片机VCC口连接，负极分别于B0、B1口连，编译并烧录程序。
可以看到，B0口LED（左）亮度低，B1口LED（右）亮度高，见下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-07-13-31-15_手把手教你用PWM实现呼吸灯(标准库).jpg"/></div>


将两个通道的有效占空比互换（即调换两者的比较值CRR，语句即为TIM3_Configuration函数中的 "TIM_OCInitStructure.TIM_Pulse = 90" 和 "TIM_OCInitStructure.TIM_Pulse = 5"，把90和5互换 ），重新编译、烧录。
可以看到，B0口LED（左）亮度高，B1口LED（右）亮度低，见下图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-07-13-24-00_手把手教你用PWM实现呼吸灯(标准库).jpg"/></div>



这是符合我们预期的，因为在外面的例子中，计数值<=比较值时，输出有效电平（被设置为了低电平），此时LED发光。因此比较值越大，LED发光时间占比越大，对应亮度越高。

### 2. PWM一键输出函数

下面进行将其封装为一键输出函数，预期效果为：在main函数中调用此函数（给予适当的函数参数），可以直接在GPIO端口上得到输出的PWM信号，并且PWM信号输出端口、各端输出频率、各端有效电平（可高可低）、各端有效占空比等都可通过函数参数设置。

函数框架及参数设计如下：
```c
/**
 * @brief 输出PWM信号
 * @param gpioA_pin 要使能的A端口，可以是: 0, GPIO_Pin_6, GPIO_Pin_7, GPIO_Pin_6|GPIO_Pin_7
 * @param gpioB_pin 要使能的B端口，可以是: 0, GPIO_Pin_0, GPIO_Pin_1, GPIO_Pin_0|GPIO_Pin_1
 * @param frequency 输出信号频率, 范围 [4 Hz, 65535 Hz]
 * @param TIM_OCPolarity 有效电平的1*4数组，分别对应A6,A7,B0,B1，例如: {TIM_OCPolarity_Low, TIM_OCPolarity_High, TIM_OCPolarity_High, TIM_OCPolarity_High}，未启用的端口写0即可
 * @param duty_ratio 有效占空比的1*4数组，分别对应A6,A7,B0,B1，例如:{5, 85, 95, 50}，未启用的端口写0即可
 * @retval void
*/
void OutputPWM_TIM3(uint16_t gpioA_pin, uint16_t gpioB_pin, uint16_t frequency, uint16_t* TIM_OCPolarity, uint16_t* duty_ratio )
{
	/* 这里是函数内容 */ 
}
```
为了完成上面的操作，我们要对原来的函数进行修改，封装结果如下：

```c
void RCC_Configuration(void)
{
     /* TIM3 clock enable */
     RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM3, ENABLE);   // (利用RCC_APB1下的函数)使能TIM3
     /* GPIOA and GPIOB clock enable */
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA|RCC_APB2Periph_GPIOB|RCC_APB2Periph_AFIO,ENABLE);
}

void GPIO_Configuration(uint16_t gpioA_pin, uint16_t gpioB_pin){
    GPIO_InitTypeDef GPIO_InitStructure;        // 定义并设置初始化结构体
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP; // PP(push-pull)，中文为推挽模式
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;   // 最大频率50MHz
    GPIO_InitStructure.GPIO_Pin = gpioA_pin ;       
    GPIO_Init(GPIOA, &GPIO_InitStructure);
    GPIO_InitStructure.GPIO_Pin = gpioB_pin ;
    GPIO_Init(GPIOB, &GPIO_InitStructure);
}

/**
 * @brief 输出PWM信号
 * @param gpioA_pin 要使能的A端口，可以是: 0, GPIO_Pin_6, GPIO_Pin_7, GPIO_Pin_6|GPIO_Pin_7
 * @param gpioB_pin 要使能的B端口，可以是: 0, GPIO_Pin_0, GPIO_Pin_1, GPIO_Pin_0|GPIO_Pin_1
 * @param frequency 输出PWM频率, 范围 [4 Hz, 65535 Hz]
 * @param TIM_OCPolarity 有效电平的1*4数组，分别对应A6,A7,B0,B1，例如: {TIM_OCPolarity_Low, TIM_OCPolarity_High, TIM_OCPolarity_High, TIM_OCPolarity_High}，未启用的端口写0即可
 * @param duty_ratio 有效占空比的1*4数组，分别对应A6,A7,B0,B1，范围[0, 100]，例如:{5, 85, 95, 50}，未启用的端口写0即可
 * @retval void
*/
void OutputPWM_TIM3(uint16_t gpioA_pin, uint16_t gpioB_pin, uint16_t frequency, uint16_t* TIM_OCPolarity, uint16_t* duty_ratio ){
    TIM_TimeBaseInitTypeDef  TIM_TimeBaseStructure;
    TIM_OCInitTypeDef  TIM_OCInitStructure;
    RCC_Configuration();
    GPIO_Configuration(gpioA_pin, gpioB_pin);
    /* Time base configuration */
    TIM_TimeBaseStructure.TIM_Prescaler = 300 - 1;  // prescaler: 分频，将系统频率(这里是72MHz)分为300份，得到240kHz
    TIM_TimeBaseStructure.TIM_Period = (uint16_t)(240000/frequency) - 1;    // period: TMI3周期计数值(计数周期)，结合prescaler得到100Hz的中断频率
    TIM_TimeBaseStructure.TIM_ClockDivision = 0;    // 设置时钟分割(这里无需了解，若感兴趣可查阅参考手册)
    TIM_TimeBaseStructure.TIM_CounterMode = TIM_CounterMode_Up; // 计数器向上计数
    TIM_TimeBaseInit(TIM3, &TIM_TimeBaseStructure); // 将上面的设置赋予TIM3，并在此基础上设置有效占空比

    /* PWM1 Mode configuration: Channel_1(A6), Channel_2(A7), Channel_3(B0), Channel_4(B1)*/
    TIM_OCInitStructure.TIM_OCMode = TIM_OCMode_PWM1;       // 设置OC(Output Channel)为PWM_1模式
    TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;   // 使能Output
    if ((gpioA_pin&GPIO_Pin_6) != 0)
    {
        /* 比较值的范围取决于计数值，当计数值 n<=比较值 时输出有效电平，下面设置了有效电平为低电平，又LED共阳极，因此 n<= CRR 时点亮  */
        TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity[0]; // 设置有效电平
        TIM_OCInitStructure.TIM_Pulse = (uint16_t)(TIM_TimeBaseStructure.TIM_Period*duty_ratio[0]/100) ;    // 设置比较值(决定占空比)
        TIM_OC1Init(TIM3, &TIM_OCInitStructure);
        TIM_OC1PreloadConfig(TIM3, TIM_OCPreload_Enable);
    }
    if ((gpioA_pin&GPIO_Pin_7) != 0)
    {
        /* 比较值的范围取决于计数值，当计数值 n<=比较值 时输出有效电平，下面设置了有效电平为低电平，又LED共阳极，因此 n<= CRR 时点亮  */
        TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity[1]; // 设置有效电平
        TIM_OCInitStructure.TIM_Pulse = (uint16_t)(TIM_TimeBaseStructure.TIM_Period*duty_ratio[1]/100); // 设置比较值(决定占空比)
        TIM_OC2Init(TIM3, &TIM_OCInitStructure);
        TIM_OC2PreloadConfig(TIM3, TIM_OCPreload_Enable);
    }
    if ((gpioB_pin&GPIO_Pin_0) != 0)
    {
        /* 比较值的范围取决于计数值，当计数值 n<=比较值 时输出有效电平，下面设置了有效电平为低电平，又LED共阳极，因此 n<= CRR 时点亮  */
        TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity[2]; // 设置有效电平
        TIM_OCInitStructure.TIM_Pulse = (uint16_t)(TIM_TimeBaseStructure.TIM_Period*duty_ratio[2]/100); // 设置比较值(决定占空比)
        TIM_OC3Init(TIM3, &TIM_OCInitStructure);
        TIM_OC3PreloadConfig(TIM3, TIM_OCPreload_Enable);
    }
    if ((gpioB_pin&GPIO_Pin_1) != 0)
    {
        /* 比较值的范围取决于计数值，当计数值 n<=比较值 时输出有效电平，下面设置了有效电平为低电平，又LED共阳极，因此 n<= CRR 时点亮  */
        TIM_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity[3]; // 设置有效电平
        TIM_OCInitStructure.TIM_Pulse = (uint16_t)(TIM_TimeBaseStructure.TIM_Period*duty_ratio[3]/100); // 设置比较值(决定占空比)
        TIM_OC4Init(TIM3, &TIM_OCInitStructure);
        TIM_OC4PreloadConfig(TIM3, TIM_OCPreload_Enable);
    }
    /* TIM3 enable counter */
    TIM_ARRPreloadConfig(TIM3, ENABLE);
    TIM_Cmd(TIM3, ENABLE);
}
```

在主程序中运行：

``` c
#include "stm32f10x.h"   // Device header

void RCC_Configuration(void);
void GPIO_Configuration(uint16_t gpioA_pin, uint16_t gpioB_pin);
void OutputPWM_TIM3(uint16_t gpioA_pin, uint16_t gpioB_pin, uint16_t frequency, uint16_t* TIM_OCPolarity, uint16_t* duty_ratio );


uint16_t TIM_OCPolarity[] = {TIM_OCPolarity_Low, TIM_OCPolarity_Low, TIM_OCPolarity_Low, TIM_OCPolarity_Low};
uint16_t duty_ratio[] = {50,30,0,0};
int main(void)
{
    OutputPWM_TIM3(GPIO_Pin_6|GPIO_Pin_7, GPIO_Pin_0|GPIO_Pin_1, 100, TIM_OCPolarity, duty_ratio);
    while(1){
    }   
}

/* 这里把上面封装好的函数搬下来（一共三个） */
```
将四个LED共阳极接到电源VCC，阴极分别接到四个端口，设置所需的函数参数。这里选择了开启全部通道，PWM频率100Hz，全部都为低电平有效，且占空比为 {0,30,60,100}，效果如下：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-07-13-03-54_手把手教你用PWM实现呼吸灯(标准库).jpg"/></div>
将占空比改为 {100,10,50,0}，效果如下（为了便于分辨亮度差异，四个LED都使用了相同颜色）：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-07-13-27-40_手把手教你用PWM实现呼吸灯(标准库).jpg"/></div>
可以看到，现象完全符合我们的预期（有效占空比为0的灯看起来没有完全熄灭，是受到旁边LED的光照影响，实际上是完全熄灭的。）
我们将四个通道有效占空比设为{0,0,0,0}，可以看到LED完全熄灭：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-07-13-26-08_手把手教你用PWM实现呼吸灯(标准库).jpg"/></div>

### 3. 呼吸灯控制

完成了PWM封装后，我们可以轻松地实现LED呼吸灯，在呼吸灯的呼吸周期内，按某种规律使有效占空比从0到100再回到0即可。这里以占空比随时间线性变化为例。

> 实际上，占空比随时间线性变化时，LED亮度并不是线性变化，具体的亮度变化不仅与占空比有关，还与VCC电压值和脉冲电流值等有关，可以从物理角度推导，这里从略。

利用延时函数和for循环语句即可完成LED呼吸灯控制，其中延时函数代码如下：

``` c
/* delay.c */

#include "stm32f10x.h"   // Device header

/**
 * @brief us级Delay函数(精确)
 * @param n 延时 n*1us，n范围[0, 233016]
 * @retval void
*/
void delay_us(uint32_t n)  
{
    SysTick->LOAD=72*n;          //装载计数值，因为时钟 72M，72 次在 1μs
    SysTick->VAL=0x00;          //清空计数器
    SysTick->CTRL=0x00000005;   //时钟来源设为为 HCLK(72M)，打开定时器
    while(! (SysTick->CTRL&0x00010000)); //等待计数到 0
    SysTick->CTRL=0x00000004;   //关闭定时器
}

/**
 * @brief ms级延时函数(精确)
 * @param n 延时 n*1ms，n范围[0, 233]
 * @retval void
*/
void delay_ms(uint32_t n)  
{
    SysTick->LOAD=72000*n;      //装载计数值，因为时钟 72000 kHz，72000次在 1ms
    SysTick->VAL=0x00;          //清空计数器
    SysTick->CTRL=0x00000005;   //时钟来源设为为 HCLK(72M)，打开定时器
    while(! (SysTick->CTRL&0x00010000)); //等待计数到 0
    SysTick->CTRL=0x00000004;   //关闭定时器
}

/**
 * @brief s级延时函数(精确)
 * @param n 延时 n*1s，n范围[0, 858993459]
 * @retval void
*/
void delay_s(uint32_t n)  
{
    uint32_t Systick_counter;  
    for ( Systick_counter = 0; Systick_counter < n*5; Systick_counter++)
    {
        delay_ms(200);
    }
}
```
延时函数的原理与计算我们不再单独讲解，可参考链接：[https://www.bilibili.com/video/BV1fe4y147oS/](https://www.bilibili.com/video/BV1fe4y147oS/) 

为了方便使用，将封装好的PWM函数转移到PWM.c文件中，并在PWM.h进行声明。

下面是使用Channel1的示例主程序：

``` c
#include "stm32f10x.h"   // Device header
#include "delay.h"
#include "PWM.h"

int main(void)
{
    
    uint16_t TIM_OCPolarity[] = {TIM_OCPolarity_Low, TIM_OCPolarity_Low, TIM_OCPolarity_Low, TIM_OCPolarity_Low};   // 非零也不影响
    uint16_t duty_ratio[] = {0,0,0,0};
    uint16_t i;     // 循环变量
    OutputPWM_TIM3(GPIO_Pin_6,0, 100, TIM_OCPolarity, duty_ratio);
    while(1){
        for ( i = 0; i < 100; i++)
        {
            duty_ratio[0]++;
            OutputPWM_TIM3(GPIO_Pin_6,0, 100, TIM_OCPolarity, duty_ratio);
            delay_ms(7);
        }
        for ( i = 0; i < 100; i++)
        {
            duty_ratio[0]--;
            OutputPWM_TIM3(GPIO_Pin_6,0, 100, TIM_OCPolarity, duty_ratio);
            delay_ms(7);
        }
		delay_ms(200);	// 注意这里delay的ms值不大于233(详见函数注释)
    }
}
```


## 总结

文章的关键内容在于PWM信号的自定义输出，这个功能不仅可以用于实现呼吸灯，可以用于电机驱动等其它领域，呼吸灯仅为其中的一个比较有趣的例子。

另外，在上面的例子中，涉及到但我们没有考虑的功能包括但不限于：
1. TIM端口映射，如部分映射或重映射
2. 其它定时器输出PWM信号（高级定时器可同时输出7路PWM信号）
3. PWM信号输出类型（如矩形波、正弦波）
在此文的基础上，上面的功能可以根据自己的需求，查询相关资料进行实现。
## 参考文章

[【从零开始stm32学习记录-呼吸灯程序书写（利用Delay函数）】](https://www.bilibili.com/video/BV14F411T7VR)  
[【STM32入门—软件延时函数的实现—基于SysTick系统滴答定时器】](https://www.bilibili.com/video/BV1fe4y147oS/)  
[【STM32入门—定时器的应用及编程—PWM实现LED呼吸灯】](https://www.bilibili.com/video/BV1b8411j7sY)  