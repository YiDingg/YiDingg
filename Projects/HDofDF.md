# HDofDF (Humidity Detection of Diabetic Foot)<br>糖足湿度检测

## Preparation

### Preface

The reason is that I participate in a project called *The Intelligent Wound Humidity Monitoring System Construction Based on ... and Humidity Detection of Diabetic Foot*. The project's openning-report is at [Cross-project presentation](https://write-bug-backend.oss-cn-beijing.aliyuncs.com/static/uploads/2024/7/8/b242ea15cd88951814177c6ad1ee2504.pptx). I was assigned the task of sensor data reading by hardware IIC.

<!-- 起因是参与了一个项目，名为“基于糖尿病足溃疡创面湿度监测……的智能化创面湿度监测系统构建”，需要对糖足湿度进行检测，项目开题报告在 [交叉项目答辩](https://write-bug-backend.oss-cn-beijing.aliyuncs.com/static/uploads/2024/7/8/b242ea15cd88951814177c6ad1ee2504.pptx)。我分配到的任务是硬件IIC读取传感器数据。 -->

### Requirements

Target：read data from sensor SHT35 by EFR32BG22's hardware IIC.

<!-- 目标：利用 EFR32BG22 的硬件IIC读取SHT35传感器数据。 -->


Hardware:
- Main Control: EFR32BG22
  - [www.silabs.com](https://www.silabs.com/wireless/bluetooth/efr32bg22-series-2-socs)
  - [www.edomtech.com](https://www.edomtech.com.cn/product-detail/efr32bg22-bluetooth-le-soc/#development_kit)
- Bluetooth Module: RF-BM-BG22A1 (EFR32BG22-C112F352GM32-C inside)
  - [Resources](https://www.szrfstar.com/product/306-cn.html)
- SHT35 (temperature and humidity sensor) 
  - [DF创客社区](https://wiki.dfrobot.com.cn/_SKU_SEN0333_SHT35_%E6%B8%A9%E6%B9%BF%E5%BA%A6%E4%BC%A0%E6%84%9F%E5%99%A8)
  - [UDF（优迪半导体）](http://www.udf-ic.com/goods/1098033)
  - [SUNSTECH（森思德克）](https://sunsstech.com/item/27.html) 
 
Software:
- Language: C/C++
- IDE: [Simplicity Studio](https://www.silabs.com/)


## EFR32BG22 (main control)

### Introduction

### IIC



## SHT35 (humidity sensor)

### Introduction

### Application