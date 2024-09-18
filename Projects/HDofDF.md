# Humidity Detection of Diabetic Foot<br>糖足湿度检测

> [!Note|style:callout|label:Infor]
Initially published at 16:13 on 2024-06-26 in Beijing.


## Preparation

### Preface

The reason is that I participate in a project called *The Intelligent Wound Humidity Monitoring System Construction Based on ... and Humidity Detection of Diabetic Foot*. The project's openning-report is at [Cross-project presentation](https://write-bug-backend.oss-cn-beijing.aliyuncs.com/static/uploads/2024/7/8/b242ea15cd88951814177c6ad1ee2504.pptx). I was assigned the task of reading sensor data by hardware IIC.

<!-- 起因是参与了一个项目，名为“基于糖尿病足溃疡创面湿度监测……的智能化创面湿度监测系统构建”，需要对糖足湿度进行检测，项目开题报告在 [交叉项目答辩](https://write-bug-backend.oss-cn-beijing.aliyuncs.com/static/uploads/2024/7/8/b242ea15cd88951814177c6ad1ee2504.pptx)。我分配到的任务是硬件IIC读取传感器数据。 -->

### Requirements

Target：read data from sensor SHT35 by EFR32BG22's hardware IIC.

<!-- 目标：利用 EFR32BG22 的硬件IIC读取SHT35传感器数据。 -->


Hardware:
- Main Control: EFR32BG22 (Thunderboard™ EFR32BG22, EFR32BG22C224HIC01FQM)
  - [www.silabs.com](https://www.silabs.com)
  - [www.silabs.com --> efr32bg22](https://www.silabs.com/wireless/bluetooth/efr32bg22-series-2-socs)
- SHT35 (temperature and humidity sensor) 
  - [DF创客社区](https://wiki.dfrobot.com.cn/_SKU_SEN0333_SHT35_%E6%B8%A9%E6%B9%BF%E5%BA%A6%E4%BC%A0%E6%84%9F%E5%99%A8)
  - [UDF（优迪半导体）](http://www.udf-ic.com/goods/1098033)
  - [SUNSTECH（森思德克）](https://sunsstech.com/item/27.html) 
 
Software:
- Language: C/C++
- IDE: [Simplicity Studio](https://www.silabs.com/developers/simplicity-studio)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-12-23-02-25_HDofDF.jpg"/></div>

## Simplicity Studio 5 

Download it [here](https://www.silabs.com/developers/simplicity-studio).

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-12-12-46-47_HDofDF.jpg"/></div>

Here are some official recources that might be helpful:

- [Simplicity Studio 5 User's Guide (online)](https://docs.silabs.com/simplicity-studio-5-users-guide/latest/ss-5-users-guide-overview/): The official Simplicity Studio 5 User's Guide
- - [Simplicity Studio 5 User's Guide.pdf](https://www.writebug.com/static/uploads/2024/8/14/2fd2582321ac1fcb4d48ad0e68873b04.pdf)
- [Getting Started (Video Series)](https://www.silabs.com/support/training/ss-studio-100-getting-started): Getting started with Simplicity Studio video series
- [Training and Tutorials](https://www.silabs.com/support/training.soft-development-environments_simplicity-studio): Our collection of Simplicity Studio training and tutorial videos
- [Tips and Tricks](https://docs.silabs.com/simplicity-studio-5-users-guide/latest/ss-5-users-guide-tips-and-tricks/): Useful tips and tricks to help you optimize your tools setup

## EFR32BG22 (Main Control)

### Introduction


- [Thunderboard™ EFR32BG22 User's Guide.pdf](https://www.writebug.com/static/uploads/2024/8/14/6447e4b1e41a9fb555c3003c4fa84234.pdf)


### IIC

- [simplicity-studio-5-users-guide.pdf](https://www.writebug.com/static/uploads/2024/8/14/2fd2582321ac1fcb4d48ad0e68873b04.pdf)


## SHT35 (Humidity Sensor)

### Introduction

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-13-00-22-30_HDofDF.jpg"/></div>

You can buy the similar product SHT30 or SHT31 at [Taobao](https://detail.tmall.com/item.htm?id=724887014597&spm=a1z09.2.0.0.1bac2e8dhYWWfz), which are much cheape than SHT35. And [here](https://pan.baidu.com/s/1WYkf5UArwjvNI6C_c7SrgA?password=FXSC) are the recources provided by the Taobao businesses (passward: FXSC). 


Refer the example [here](https://wiki.dfrobot.com.cn/_SKU_SEN0333_SHT35_%E6%B8%A9%E6%B9%BF%E5%BA%A6%E4%BC%A0%E6%84%9F%E5%99%A8) for a ready-to-use code if you are using Arduino.

### Usage: STM32 + CubeMX

**Once Mode:**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-18-16-51-52_HDofDF.png"/></div>

**Period Mode:**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-09-18-16-52-03_HDofDF.png"/></div>

`main.c` (period mode):

``` c
/* ----- main.c (period mode) -----*/
#include "SHT3X.h"  // #include SHT3X.h before the function main()

// in function main(): 

// ...
    /* Infinite loop */
    /* USER CODE BEGIN WHILE */
    uint8_t I2CRXBuffer[6] = {0};
    float Temperature = 0, Humidity = 0;
    uint8_t Status = 0;
    printf("-----\n");
    if (SHT3X.PeriodMode_Enable() == HAL_OK) {
        printf("Successfully enable SHT3X period mode !\r\n");
    } else {
        printf("error: SHT3X.PeriodMode_Enable()\r\n");
    }
    printf("-----\n");
    while (1) {
        HAL_Delay(1000);
        HAL_GPIO_TogglePin(GPIOC, GPIO_PIN_13);
        if (SHT3X.PeriodMode_GetData(I2CRXBuffer) == HAL_OK) {
            Status = SHT3X.Data_To_Float(I2CRXBuffer, &Temperature, &Humidity);
            if (!Status) {
                printf(
                    "Temprature: %.2f C, Humidity: %.2f %%\r\n", Temperature,
                    Humidity);
            } else {
                printf("error: CRC check\r\n");
            }
        } else {
            printf("error: SHT3X.PeriodMode_GetData()\r\n");
        }
        /* USER CODE END WHILE */
        /* USER CODE BEGIN 3 */
    }
    /* USER CODE END 3 */
// ...
```

`main.c` (once mode):

``` c
/* ----- main.c (once mode) -----*/
#include "SHT3X.h"  // #include SHT3X.h before the function main()

// in function main(): 

// ...
    /* Infinite loop */
    /* USER CODE BEGIN WHILE */
    uint8_t I2CRXBuffer[6] = {0};
    float Temperature = 0, Humidity = 0;
    uint8_t Status = 0;
    while (1) {
        HAL_GPIO_TogglePin(GPIOC, GPIO_PIN_13);
        if (SHT3X.OnceMode_GetData(I2CRXBuffer) == HAL_OK) {
            Status = SHT3X.Data_To_Float(I2CRXBuffer, &Temperature, &Humidity);
            if (!Status) {
                printf(
                    "Temprature: %.2f C, Humidity: %.2f %%\r\n", Temperature,
                    Humidity);
                HAL_Delay(1000);
            } else {
                printf("error: CRC check\r\n");
            }
        } else {
            printf("error: SHT3X.OnceMode_GetData()\r\n");
        }
        /* USER CODE END WHILE */
        /* USER CODE BEGIN 3 */
    }
    /* USER CODE END 3 */
// ...
```


`SHT3X.h`: Go to [GitHub](https://github.com/YiDingg/HDofDB/blob/main/Core/Inc/SHT3X.h)



`SHT3X.c`: Go to [GitHub](https://github.com/YiDingg/HDofDB/blob/main/Core/Src/SHT3X.c)


### Usage: EFR32BG22 + Simplicity Studio 5



## Reference

- [x] [www.silabs.com](https://www.silabs.com)
- [x] [www.silabs.com --> EFR32BG22](https://www.silabs.com/wireless/bluetooth/efr32bg22-series-2-socs)
- [x] [www.edomtech.com](https://www.edomtech.com.cn/product-detail/efr32bg22-bluetooth-le-soc/#development_kit)
- [x] [DF创客社区](https://wiki.dfrobot.com.cn/_SKU_SEN0333_SHT35_%E6%B8%A9%E6%B9%BF%E5%BA%A6%E4%BC%A0%E6%84%9F%E5%99%A8)
- [x] [UDF（优迪半导体）](http://www.udf-ic.com/goods/1098033)
- [x] [SUNSTECH（森思德克）](https://sunsstech.com/item/27.html)
- [x] [（软件IIC）STM32（HAL库）驱动SHT30温湿度传感器通过串口进行打印引脚配置](https://blog.csdn.net/weixin_44597885/article/details/131757338)
- [x] [（硬件IIC）STM32硬件IIC驱动SHT35](https://blog.csdn.net/weixin_50621510/article/details/136555927)
- [x] [（硬件IIC）STM32CubeMX的使用之四：IIC总线协议驱动SHT30温湿度传感器](https://blog.csdn.net/weixin_43444989/article/details/109141174)
