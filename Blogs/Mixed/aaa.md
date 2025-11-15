
104:

Preparation:
- LDO 理论 > opamp specs
- LDo Loop 零极点，估计

Part 1:
1. onc18 导入 (dy)
2. MyLib_onc18, MyLib_202510_LDO_onc18 (无 variable)
3. variable_opamp, tb_opamp (dc > gain; ac > GBW/PM/GM; tran > overshoot/settlingTime/SR) 
4. opamp specs (指标)？根据 LDO specs + 理论
5. 单级 folded, C_L 上升 > PM 上升, PM > 75° @ C_L = 0.1pF (C_L 更大，PM 更大，LDO 较好 PM)

Q: dc, GBW, PM, 保证 dc gain, PM, 提高 GBW

Part 2: 
1. 功率管 NMOS?
2. tb_LDO (dc > current, ac > PSRR/PM, tran > 上电波形)，tran + ac (也罢)


前仿完成：进版图










