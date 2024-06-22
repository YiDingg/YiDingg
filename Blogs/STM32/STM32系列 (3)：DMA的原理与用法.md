# STM32系列 (3)：DMA的原理与用法 

## 前言
本节目标：了解DMA的原理，并利用DMA协助数据传输（如IIC和SPI）。  

>系列汇总详见地址：[📕STM32系列汇总](Blogs\STM32\STM32系列汇总.md)

## DMA原理
对于STM32F103x系列，官方对其DMA的说明在 [STM32F10x 参考手册(中文版).pdf](https://write-bug-backend.oss-cn-beijing.aliyuncs.com/static/uploads/2024/5/30/764d9b9b210b4c052c24837bf24e0398.pdf) 中的Page.142~Page.154。下面是部分截图：
<div class='center'>
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (3)：DMA的原理与用法--2024-06-23-00-30-08.png"/>
</div>


特别地，我们也要注意DMA的Circular模式、MemtoMem模式:
<div class='center'>
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (3)：DMA的原理与用法--2024-06-23-00-30-12.png"/>
</div>

## DMA辅助IIC
### 原理
要利用DMA辅助IIC发送数据，需要在常规IIC通信的基础上，添加一个 DMA (IIC_TX)，并**打开 IIC event interrupt**，如图：
<div class='center'>
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (3)：DMA的原理与用法--2024-06-23-00-30-17.png"/>
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (3)：DMA的原理与用法--2024-06-23-00-30-21.png"/>
<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/STM32系列 (3)：DMA的原理与用法--2024-06-23-00-30-28.png"/>
</div>

即可使用HAL库中 IIC (DMA模式) 对应的六个函数：
```c
// Mem_Write与Mem_Rea
HAL_StatusTypeDef HAL_I2C_Mem_Write_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress, uint16_t MemAddSize, uint8_t *pData, uint16_t Size);
HAL_StatusTypeDef HAL_I2C_Mem_Read_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress, uint16_t MemAddSize, uint8_t *pData, uint16_t Size);

// Master_Transmit与Master_Receive
HAL_StatusTypeDef HAL_I2C_Master_Transmit_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData, uint16_t Size);
HAL_StatusTypeDef HAL_I2C_Master_Receive_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData, uint16_t Size);

// Master_Seq_Transmit与Master_Seq_Receive
HAL_StatusTypeDef HAL_I2C_Master_Seq_Transmit_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData, uint16_t Size, uint32_t XferOptions);
HAL_StatusTypeDef HAL_I2C_Master_Seq_Receive_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData, uint16_t Size, uint32_t XferOptions);
```

下面是它们的对应关系和作用，从机可以是OLED屏幕，也可以是单片机或其他各种设备：  

<div class='center'> 

| IIC (普通模式，即阻塞模式) | IIC (DMA模式) | 作用 |
| :-----: | :---------: | :---------: |
| HAL_I2C_Mem_Write() | HAL_I2C_Mem_Write_DMA() | 主机（单片机）在从机（OLED）寄存器指定位置写入数据 |
| HAL_I2C_Mem_Read() | HAL_I2C_Mem_Read_DMA() | 主机（单片机）在从机（OLED）寄存器指定位置读出数据 |
| HAL_I2C_Master_Transmit  | HAL_I2C_Master_Transmit_DMA() | 主机向从机发送数据 |
|HAL_I2C_Master_Receive | HAL_I2C_Master_Receive_DMA() | 主机接受从机发来的数据 |
|无| HAL_I2C_Master_Seq_Transmit_DMA() | 主机用连续模式向从机发送数据（发送一次数据完毕后，立刻开启下一次发送） |
|无| HAL_I2C_Master_Seq_Receive_DMA() | 主机用连续模式接收从机发来的数据（接收一次数据完毕后，立刻开启下一次接收） |
</div>

### 实例

## DMA辅助SPI

### 实例

!> **注意：**
对OLED而言，单片机向OLED发送的数据分为两种，一种是命令字节(Command)，用于调整屏幕各项设置，另一种是数据字节(Data)，用于调整OLED的硬件显存。

在使用IIC与OLED通信时，无法通过硬件区分上述两种字节（仅有VCC, GND, SCL, SDA四个接口，而OLED的SPI通信利用DC引脚区分两种字节），因此需要通过软件将不同类型的字节写入到从机寄存器的不同位置。换句话说，通过IIC驱动OLED时，必须使用HAL_I2C_Mem_Write()函数而不是HAL_I2C_Master_Transmit()函数，因为后者无法区分命令字节和显存字节。一般地，我们会将命令字节写到寄存器的0x00地址处，将显存数据写到寄存器的0x40地址处。

### 实例
## 知识补充



