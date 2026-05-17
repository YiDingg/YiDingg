# R-2R DAC by YiDingg (using tsmcN28)

- Library name: `MyLib_tsmcN28_R2RDAC`
- Top cells: as shown below
- Email: dingyi233@mails.ucas.ac.cn

<span style='font-size:12px'> 
<div class='center'>

| Cell Name | Input Channel | Input Ports | Built-In Input Buffer | Built-In Output Cap | Recommended Operation Freq. |
|:-|:-:|:-:|:-:|:-:|:-:|
 | Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit | 1 channel | DIN\<7:0\>, DINB\<7:0\> | - | - | < 12 GHz |
 | Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit_withBUF | 1 channel | DIN\<7:0\> | Yes | - | < 8 GHz |
 | Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit_withBUF_VDD <br> (VREF = VDD) | 1 channel | DIN\<7:0\> | Yes | - | < 8 GHz |
 | Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit_withBUF_CAP | 1 channel | DIN\<7:0\> | Yes | 300 fF | < 50 MHz |
 | Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit_withBUF_CAPx2 | 1 channel | DIN\<7:0\> | Yes | 700 fF | < 10 MHz |
 | Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit_withBUF_CAPx2_VDD | 1 channel | DIN\<7:0\> | Yes | 700 fF | < 10 MHz |
 | Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit_withBUF_CAPx2_DNW | 1 channel | DIN\<7:0\> | Yes | 700 fF | < 10 MHz |
 | Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit_withBUF_CAPx2_DNW_V <br> (VREF = VDD)| 1 channel | DIN\<7:0\> | Yes | 700 fF | < 10 MHz |
 | Logic_std_2d0_200n_30n_DAC_R2R_4d7k_withMN_8bit | 2 channel | DIN\<7:0\>, MN_DIN\<7:0\>, <br> MN_EN, MN_ENB | Yes | - | < 8 GHz |

</div>
</span>

Notes: 
- (1) DAC electronic characteristics:
    - resolution = 8 bit
    - output range = VSS ~ VREF
    - at (TT, 50°C), the output resistance of all DACa is 10 kOhm (9.4 kOhm exactly)
    - total **static current consumption** is less than $\frac{8 \times V_{REF}}{3 \times R}$ $= \frac{8 \times V_{REF}}{3 \times (4.7 \ \mathrm{kOhm})}$ $= 0.567 \times V_{REF}\ \mathrm{(mA)}$. For example, IDD_static < 567 uA @ VREF = VDD = 1.0V
- (2) explanation of suffixes:
    - `_withBUF`: with built-in buffer for the input ports, e.g., for DIN\<7:0\>
    - `_CAP`: with built-in output capacitance to achieve a better stability and noise performance
    - `_DNW`: with deep n-well (DNW)
    - `_withMN`: with extra manual control input channel, one channel for the counter output and one for manual control
    - `_VDD`: $V_{REF} = V_{DD}$ (VREF is internal connected to VDD), hence the output range is between VSS and VDD
- (3) recommended solutions:
    - when DAC provides a dc voltage from 0 ~ VDD, `Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit_withBUF_CAPx2_DNW_V` is recommended. 
    - when DAC operates at a high frequency (GHz level) providing a voltage from 0 ~ VDD, `Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit_withBUF_VDD` is recommended. 
    - when DAC operates at a very high frequency (> 8 GHz), `Logic_std_2d0_200n_30n_DAC_R2R_4d7k_8bit_withBUF` is recommended.
