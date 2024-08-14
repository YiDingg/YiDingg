# Humidity Detection of Diabetic Foot<br>糖足湿度检测

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

- [Simplicity Studio User's Guide](https://docs.silabs.com/simplicity-studio-5-users-guide/latest/ss-5-users-guide-overview/): The official Simplicity Studio 5 User's Guide
- [Getting Started (Video Series)](https://www.silabs.com/support/training/ss-studio-100-getting-started): Getting started with Simplicity Studio video series
- [Training and Tutorials](https://www.silabs.com/support/training.soft-development-environments_simplicity-studio): Our collection of Simplicity Studio training and tutorial videos
- [Tips and Tricks](https://docs.silabs.com/simplicity-studio-5-users-guide/latest/ss-5-users-guide-tips-and-tricks/): Useful tips and tricks to help you optimize your tools setup

## EFR32BG22 (Main Control)

### Introduction


- [Thunderboard™ EFR32BG22 User's Guide.pdf](https://www.writebug.com/static/uploads/2024/8/14/6447e4b1e41a9fb555c3003c4fa84234.pdf)


### IIC

- [simplicity-studio-5-users-guide](https://www.writebug.com/static/uploads/2024/8/14/2fd2582321ac1fcb4d48ad0e68873b04.pdf)


## SHT35 (Humidity Sensor)

### Introduction

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-13-00-22-30_HDofDF.jpg"/></div>

You can buy the similar product SHT30 or SHT31 at [Taobao](https://detail.tmall.com/item.htm?id=724887014597&spm=a1z09.2.0.0.1bac2e8dhYWWfz), which are much cheape than SHT35. And [here](https://pan.baidu.com/s/1WYkf5UArwjvNI6C_c7SrgA?password=FXSC) are the recources provided by the Taobao businesses (passward: FXSC). 


Refer the example [here](https://wiki.dfrobot.com.cn/_SKU_SEN0333_SHT35_%E6%B8%A9%E6%B9%BF%E5%BA%A6%E4%BC%A0%E6%84%9F%E5%99%A8) for a ready-to-use code if you are using Arduino.


### Usage: STM32 + CubeMX

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
    if (SHT3X_PeriodMode_Enable() == HAL_OK) {
        printf("Successfully enable SHT3X period mode !\r\n");
    } else {
        printf("error: SHT3X_PeriodMode_Enable()\r\n");
    }
    printf("-----\n");
    while (1) {
        HAL_Delay(1000);
        HAL_GPIO_TogglePin(GPIOC, GPIO_PIN_13);

        if (SHT3X_PeriodMode_GetData(I2CRXBuffer) == HAL_OK) {
            Status = SHT3X_Data_To_Float(I2CRXBuffer, &Temperature, &Humidity);
            if (!Status) {
                printf("Temp:%.2fC, Humi:%.2f%%\r\n", Temperature, Humidity);
            } else {
                printf("error: CRC check\r\n");
            }
        } else {
            printf("error: SHT3X_PeriodMode_GetData()\r\n");
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
        printf("-----");
        HAL_GPIO_TogglePin(GPIOC, GPIO_PIN_13);

        if (SHT3X_OnceMode_GetData(I2CRXBuffer) == HAL_OK) {
            Status = SHT3X_Data_To_Float(I2CRXBuffer, &Temperature, &Humidity);
            if (!Status) {
                printf("Temp:%.2fC, Humi:%.2f%%\r\n", Temperature, Humidity);
                HAL_Delay(1000);
            } else {
                printf("error: CRC check\r\n");
            }
        } else {
            printf("error: SHT3X_OnceMode_GetData()\r\n");
        }
        /* USER CODE END WHILE */
        /* USER CODE BEGIN 3 */
    }
    /* USER CODE END 3 */
// ...
```


`SHT3X.h`:

``` c
#if !defined(__SHT3X_H)
#define __SHT3X_H

#include "i2c.h"

/* The address connected to VSS */
#define SHT3X_ADDRESS_WRITE 0x44 << 1      // 10001000
#define SHT3X_ADDRESS_READ (0x44 << 1) + 1 // 10001011

typedef enum {
    /* 软件复位命令 */

    SOFT_RESET_CMD = 0x30A2,
    /*
    单次测量模式
    命名格式：Repeatability_CS_CMD
    CS： Clock stretching
    */
    HIGH_ENABLED_CMD = 0x2C06,
    MEDIUM_ENABLED_CMD = 0x2C0D,
    LOW_ENABLED_CMD = 0x2C10,
    HIGH_DISABLED_CMD = 0x2400,
    MEDIUM_DISABLED_CMD = 0x240B,
    LOW_DISABLED_CMD = 0x2416,

    /*
    周期测量模式
    命名格式：Repeatability_MPS_CMD
    MPS：measurement per second
    */
    HIGH_0_5_CMD = 0x2032,
    MEDIUM_0_5_CMD = 0x2024,
    LOW_0_5_CMD = 0x202F,
    HIGH_1_CMD = 0x2130,
    MEDIUM_1_CMD = 0x2126,
    LOW_1_CMD = 0x212D,
    HIGH_2_CMD = 0x2236,
    MEDIUM_2_CMD = 0x2220,
    LOW_2_CMD = 0x222B,
    HIGH_4_CMD = 0x2334,
    MEDIUM_4_CMD = 0x2322,
    LOW_4_CMD = 0x2329,
    HIGH_10_CMD = 0x2737,
    MEDIUM_10_CMD = 0x2721,
    LOW_10_CMD = 0x272A,

    /* 周期测量模式读取数据命令 */
    READOUT_FOR_PERIODIC_MODE = 0xE000,
} SHT3X_CMD;

void SHT3X_Reset(void);
HAL_StatusTypeDef SHT3X_OnceMode_GetData(uint8_t* dat);
HAL_StatusTypeDef SHT3X_PeriodMode_Enable(void);
HAL_StatusTypeDef SHT3X_PeriodMode_GetData(uint8_t* dat);
uint8_t CheckCrc8(const uint8_t* message, uint8_t initial_value);
uint8_t SHT3X_Data_To_Float(const uint8_t* dat, float* temp, float* humi);

#endif // __SHT3X_H

```


`SHT3X.c`:

``` c
#include "SHT3X.h"

/**
 * @brief Send a 16-bit command to the SHT3X
 * @param cmd SHT3X command (defined in enum SHT3X_MODE)
 * @retval Status of the operation
 */
HAL_StatusTypeDef SHT3X_Send_Cmd(SHT3X_CMD cmd) {
    uint8_t cmd_buffer[2] = {cmd >> 8, cmd};
    return HAL_I2C_Master_Transmit(
        &hi2c1, SHT3X_ADDRESS_WRITE, (uint8_t*)cmd_buffer, 2, 0xFFFF);
}

/**
 * @brief	Reset SHT3X
 * @param	none
 * @retval	none
 */
void SHT3X_Reset(void) {
    SHT3X_Send_Cmd(SOFT_RESET_CMD);
    HAL_Delay(20);
}

/**
 * @brief	Get data from STH3X (once mode)
 * @param	dat the address of your varible to restore the data (6-byte array)
 * @retval	Status of the operation
 */
HAL_StatusTypeDef SHT3X_OnceMode_GetData(uint8_t* dat) {
    HAL_StatusTypeDef Status = SHT3X_Send_Cmd(HIGH_ENABLED_CMD);
    HAL_Delay(20);
    if (Status != HAL_OK) { return Status; }
    return HAL_I2C_Master_Receive(&hi2c1, SHT3X_ADDRESS_READ, dat, 6, 0xFFFF);
    /* return HAL_I2C_Mem_Read(&hi2c1, SHT3X_ADDRESS_READ, 0x00,
     * I2C_MEMADD_SIZE_8BIT, dat, 6, 0xFFFF);*/
}

/**
 * @brief	Enable SHT3X period mode
 * @param	none
 * @retval	Status of the operation
 */
HAL_StatusTypeDef SHT3X_PeriodMode_Enable(void) {
    return SHT3X_Send_Cmd(MEDIUM_2_CMD);
}

/**
 * @brief	Read data from SHT3X (period mode)
 * @param	dat the address of your varible to restore the data (6-byte array)
 * @retval	Status of the operation
 */
HAL_StatusTypeDef SHT3X_PeriodMode_GetData(uint8_t* dat) {
    SHT3X_Send_Cmd(READOUT_FOR_PERIODIC_MODE);
    return HAL_I2C_Master_Receive(&hi2c1, SHT3X_ADDRESS_READ, dat, 6, 0xFFFF);
}

/**
 * @brief	Convert raw data to temperature
 * @param	dat the address of the varible that restored the data (6-byte array)
 * @retval	0: success
 * @retval	1: failure
 */
uint8_t SHT3X_Data_To_Float(const uint8_t* dat, float* temp, float* humi) {
    uint16_t recv_temperature = 0;
    uint16_t recv_humidity = 0;

    /* 校验温度数据和湿度数据是否接收正确 */
    if (CheckCrc8(dat, 0xFF) != dat[2] || CheckCrc8(&dat[3], 0xFF) != dat[5]) {
        return 1;
    }
    /* 转换温度数据 */
    recv_temperature = ((uint16_t)dat[0] << 8) | dat[1];
    *temp = -45 + 175 * ((float)recv_temperature / 65535);
    /* 转换湿度数据 */
    recv_humidity = ((uint16_t)dat[3] << 8) | dat[4];
    *humi = 100 * ((float)recv_humidity / 65535);
    return 0;
}

#define CRC8_POLYNOMIAL 0x31

/**
 * @brief Calculate CRC8 code of a message
 * @param message
 * @param initial_value
 * @retval remainder:
 */
uint8_t CheckCrc8(const uint8_t* message, uint8_t initial_value) {
    uint8_t remainder;    // 余数
    uint8_t i = 0, j = 0; // 循环变量

    /* 初始化 */
    remainder = initial_value;

    for (j = 0; j < 2; j++) {
        remainder ^= message[j];

        /* 从最高位开始依次计算  */
        for (i = 0; i < 8; i++) {
            if (remainder & 0x80) {
                remainder = (remainder << 1) ^ CRC8_POLYNOMIAL;
            } else {
                remainder = (remainder << 1);
            }
        }
    }

    /* 返回计算的CRC码 */
    return remainder;
}

```


### Usage: EFR32BG22 + Simplicity Studio 5



## Reference

- [ ] [www.silabs.com](https://www.silabs.com)
- [x] [www.silabs.com --> EFR32BG22](https://www.silabs.com/wireless/bluetooth/efr32bg22-series-2-socs)
- [x] [www.edomtech.com](https://www.edomtech.com.cn/product-detail/efr32bg22-bluetooth-le-soc/#development_kit)
- [x] [DF创客社区](https://wiki.dfrobot.com.cn/_SKU_SEN0333_SHT35_%E6%B8%A9%E6%B9%BF%E5%BA%A6%E4%BC%A0%E6%84%9F%E5%99%A8)
- [x] [UDF（优迪半导体）](http://www.udf-ic.com/goods/1098033)
- [x] [SUNSTECH（森思德克）](https://sunsstech.com/item/27.html)

<!-- - [x] [（软件IIC）STM32模拟IIC驱动sht30温湿度传感器](https://blog.csdn.net/lllmeimei/article/details/121552846) 
- [x] [（软件IIC）IIC学习之SHT30温湿度传感器(基于STM32)](https://blog.csdn.net/qq_36973838/article/details/135546011)
-->


- [x] [（软件IIC）STM32（HAL库）驱动SHT30温湿度传感器通过串口进行打印引脚配置](https://blog.csdn.net/weixin_44597885/article/details/131757338)
- [x] [（硬件IIC）STM32硬件IIC驱动SHT35](https://blog.csdn.net/weixin_50621510/article/details/136555927)
- [x] [（硬件IIC）STM32CubeMX的使用之四：IIC总线协议驱动SHT30温湿度传感器](https://blog.csdn.net/weixin_43444989/article/details/109141174)
