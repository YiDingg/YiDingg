OPA Simulation Report:
- Time: 2026.10.15 21:42
- TB:  MyLib_amsLib_tsmcN28 > TB_OPA (interactive.215)
- DUT: MyLib_amsLib_tsmcN28 > 202609_OPA__2stage_inoutRailToRail_AI_v1_1014_PM80deg
- Simulation: Pre-Layout (schematic)
- Corners: nom @ 1.0V, TT50/SS50/FF50 @ 1.0V, TT27/SS-40/FF130 @ 1.0V
- Load Cap: 1.0 pF

Simulated Results:
- 60dB_out_vdelta (V)           = 644.7m (582m ~ 886.1m)
- 40dB_out_vdelta (V)           = 924.8m (909.6m ~ 984.8m)
- 20dB_out_vdelta (V)           = 992.5m (981.6m ~ 998.6m)
- dc_input_Ib_ave (A)           = 2.965p (-1.184p ~ 3.147p)
- IDD_dc (A)                    = 658.5u (268.8u ~ 1.287m)
- vin_offset (V)                = -539.3u (-539.3u ~ 1.493u)
- ac_Gain_dc (dB)               = 64.47 (63.83 ~ 76.23)
- UGF (Hz)                      = 170.1M (104.3M ~ 222.7M)
- GBW (Hz)                      = 169M (104.1M ~ 221.9M)
- PM (deg)                      = 81.11 (77.47 ~ 81.11)
- GM (dB)                       = 24.21 (21.36 ~ 24.21)
- pole_2 / UGF                  = 5.215 (3.702 ~ 5.215)
- Zout_dc (Ohm)                 = 1.15K (710.7 ~ 2.467K)
- Gm_dc (S)                     = 1.458 (1.458 ~ 3.619)
- IOUTP_max (A)                 = >800u (>800u ~ >800u)
- IOUTN_max (A)                 = >800u (>800u ~ >800u)
- settlingTime_ave @ 3% (s)     = 2.872n (2.024n ~ 6.248n)
- settlingTime_ave @ 10% (s)    = 1.949n (1.405n ~ 4.882n)
- overshoot_ave (%)             = 6.667p (3.885p ~ 6.667p)
- VOUT_headroom_low (V)         = 6.264u (20.45n ~ 479.7u)
- VOUT_headroom_high (V)        = 12.52u (8.45u ~ 522.9u)
- SR_ave (V/s) (30% ~ 70%)      = 10.56M (9.202M ~ 13.86M)
- unitGain1perc_input_range (V) = 931m (832.7m ~ 963.3m)
- unitGain1perc_input_vmin (V)  = 7.454m (7.454m ~ 56.91m)
- unitGain1perc_input_vmax (V)  = 938.5m (889.7m ~ 993.2m)
- unitGain5perc_input_range (V) = 982m (915.9m ~ 989.9m)
- unitGain5perc_input_vmin (V)  = 7.129m (7.129m ~ 39.06m)
- unitGain5perc_input_vmax (V)  = 989.2m (954.9m ~ 998.7m)
- unitGain_BW (Hz)              = 202.9M (134.9M ~ 290.7M)

Note: 
- The values in parentheses represent the fluctuation situations of all the test corners.
- In the test "TB_OPA_7_dcSweep_maxIout", the "eval err" means the max Iout has exceeded
  the specified simulation setting (default 800 uA). Hence "eval err" refers to "infty".
  For example, the results "TB_OPA_7_dcSweep_maxIout IOUTP_max (A)  eval err > 1u fail 698u 698u"
  means: "Iout_max (A) > 800u (698uA ~ >800u)"