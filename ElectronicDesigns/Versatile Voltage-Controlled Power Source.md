# Versatile Voltage-Controlled Power Source

> [!Note|style:callout|label:Infor]
Initially published at 17:58 on 2025-02-20 in Lincang.

## Infor

- Time: 2025.02.20
- Notes: 
    - 输入：OPA+ (运放正电源), OPA- (运放负电源), VCC (电流输出电源), 以及四路控制电压
    - 输出：两路电压输出，两路电流输出
- Details: 
    - 两 VSVS + 两 VSCS ，共四通道输出
    - 功率输出供电与运放供电分离
    - 电流源输出比例三档可调 (0.1, 1, 10)
- Relevant Resources: [https://www.123684.com/s/0y0pTd-3yuj3](https://www.123684.com/s/0y0pTd-3yuj3)

<div class='center'>

| Schematic | 3D view | 
|:-:|:-:|
 |<div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-22-01-35-06_Versatile Voltage-Controlled Power Source.png"/></div>|<div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-22-01-35-25_Versatile Voltage-Controlled Power Source.png"/></div>|
</div>

<div class='center'>

| Top view | Bottom view | 
|:-:|:-:|
 | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-22-01-35-49_Versatile Voltage-Controlled Power Source.png"/></div> | <div class="center"><img width = 400px src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-02-22-01-36-12_Versatile Voltage-Controlled Power Source.png"/></div> |
</div>

## Design Notes

本电路是 [General VCVS and VCCS](<ElectronicDesigns/General VCVS and VCCS (up to 10 A).md>) 的改进版，分离了功率输出供电与运放供电，增加了电流源输出比例三档可调 (0.1, 1, 10)。