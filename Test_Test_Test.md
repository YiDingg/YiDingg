
## 9. Pre-Simulation (v3_142126)


### 9.0 schematic preview

将上面所得参数 (v3_142126) 摆放 schematic 并生成 symbol, 进行 pre-layout simulation **(默认 C_L = 0.5 pF)。**

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-33-17_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-44-27_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-44-39_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 9.1 (tran) start-up response (all-corner, 1.7 V)

**设置 VREF 与 VDD 一同上升 (上升时间相同)**，运行瞬态仿真：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-50-50_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-52-13_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-50-25_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

再看一下极低负载下的启动波形 (ILOAD = 10 uA):

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-54-06_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

也是没问题的。

### 9.2 (ac) stability (all-corner, 1.7 V)



<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-21-55-15_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-03-59_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>



<!-- 注：我们怀疑 (ac) stability 仿真中得到的直流工作点与 transient opt 有明显不同，导致部分 stability 结果不准确。
 -->

<!-- 将 ILOAD 改为 RLOAD 又尝试了下，无明显变化。
 -->



### 9.3 (ac) stability at all C_L (TT65, 1.7 V)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-22-34_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 9.4 (ac) PSRR (all-corner, two-supply)


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-24-59_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-24-02_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-29-19_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-24-39_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-31-03_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

### 9.4 (tran) step response (TT, 2.65 V)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-41-46_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

DC_1mA + STEP_10mA:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-44-37_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-43-48_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>

DC_10uA + STEP_100uA:

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-47-22_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-14-22-48-25_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d0.png"/></div>