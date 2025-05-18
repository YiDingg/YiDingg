# Transistor Measurement of 2N7000 (N-Channel VDMOS)

> [!Note|style:callout|label:Infor]
> Initially published at 20:43 on 2025-04-23 in Beijing.


## 2N7000 实验记录

测量实验汇总: [The Collection of My Measurement Experiments](<Electronics/The Collection of My Measurement Experiments.md>).


- Time: 2025.04.23
- Location: Beijing
- Device under test (待测晶体管): 2N7000 (NMOS)
- Measurement board (测试板): [Simplified Transistor Tester](<ElectronicDesigns/Simplified Transistor Tester.md>)
- 2D test current level: `low (0 ~ 5mA)`, `moderate (0 ~ 25mA)` and `high (0 ~ 125mA)`
- 3D test current level: `high (0 ~ 125mA)`


<div class='center'>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-24-01-14-52_Transistor Measurement of 2N7000 (N VDMOS).png"/></div>
</div>

### 3D, level high (0 ~ 125mA)

<div class='center'>

| 测量序号 | 数据号 | <span style='color:red'> 3D </span> $(y,\ x,\ var)$ | Test condition | 图片记录 |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | 1 | $(I_D,\ V_{DS},\ V_{GS})$ | 电流检测 $R_{I_D} = 10\ \mathrm{\Omega}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-23-21-55-30_Transistor Measurement of 2N7000 (N VDMOS).png"/></div> |
 | 2 | 2 | $(I_D,\ V_{GS},\ V_{DS})$ | 电流检测 $R_{I_D} = 10\ \mathrm{\Omega}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-23-21-54-31_Transistor Measurement of 2N7000 (N VDMOS).png"/></div> |

</div>


### 2D, level low (0 ~ 5mA)

<div class='center'>

| 测量序号 | 数据号 | <span style='color:red'> 2D </span> $(y,\ x,\ var)$ | Test condition | 图片记录 |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | 1 | $(I_D,\ V_{DS},\ V_{GS})$ | 电流检测 $R_{I_D} = 1\ \mathrm{k\Omega}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-23-21-45-41_Transistor Measurement of 2N7000 (N VDMOS).png"/></div> |
 | 2 | 2 | $(I_D,\ V_{GS},\ V_{DS})$ | 电流检测 $R_{I_D} = 1\ \mathrm{k\Omega}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-23-21-49-52_Transistor Measurement of 2N7000 (N VDMOS).png"/></div> |
</div>






### 2D, level moder. (0 ~ 25mA)

<div class='center'>


| 测量序号 | 数据号 | <span style='color:red'> 2D </span> $(y,\ x,\ var)$ | Test condition | 图片记录 |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | 1 | $(I_D,\ V_{DS},\ V_{GS})$ | 电流检测 $R_{I_D} = 100\ \mathrm{\Omega}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-23-21-44-07_Transistor Measurement of 2N7000 (N VDMOS).png"/></div> |
 | 2 | 2 | $(I_D,\ V_{GS},\ V_{DS})$ | 电流检测 $R_{I_D} = 100\ \mathrm{\Omega}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-23-21-40-13_Transistor Measurement of 2N7000 (N VDMOS).png"/></div> |
</div>









### 2D, level high (0 ~ 125mA)

<div class='center'>


| 测量序号 | 数据号 | <span style='color:red'> 2D </span> $(y,\ x,\ var)$ | Test condition | 图片记录 |
|:-:|:-:|:-:|:-:|:-:|
 | 1 | 1 | $(I_D,\ V_{DS},\ V_{GS})$ | 电流检测 $R_{I_D} = 10\ \mathrm{\Omega}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-23-21-28-16_Transistor Measurement of 2N7000 (N VDMOS).png"/></div> |
 | 2 | 2 | $(I_D,\ V_{GS},\ V_{DS})$ | 电流检测 $R_{I_D} = 10\ \mathrm{\Omega}$ | <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-23-21-39-09_Transistor Measurement of 2N7000 (N VDMOS).png"/></div> |
</div>

## 数据处理

对实验数据进行处理，作图，得到结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-24-21-39-17_Transistor Measurement of 2N7000 (N VDMOS).png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-24-21-39-28_Transistor Measurement of 2N7000 (N VDMOS).png"/></div>

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-24-21-09-26_Transistor Measurement of 2N7000 (N VDMOS).png"/></div> -->

<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-04-24-01-00-29_Transistor Measurement of 2N7000 (N VDMOS).png"/></div>
 -->
