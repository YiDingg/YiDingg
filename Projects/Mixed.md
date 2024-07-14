# Mixed

Here are some mixed projects, which are not so complicated so that we won't have a dedicated section for them.

## ESP12-F Adapter Board

ESP12-F is a Wi-Fi module based on the ESP8266 chip, manufactured by Ai-Thinker (安信可). Here is the adapter borad for ESP-12 and you can refer to [立创开源硬件平台](https://oshwhub.com/dy130810/esp12-f_adapterboard) for more details.

### Display 


<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-14-22-51-16_Mixed.jpg"/></div>
<div class='center'><img src='https://s.b1n.net/SxqPO' alt='img'/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-14-22-58-44_Mixed.jpg"/></div>




### BOM 

Below is the BOM list for the Adapter Board.



<div class='center'>

| Category | Comment |  Quantity |
|:-:|:-:|:-:|
 | main control | ESP-12 (E, F, S)  | 1 |
 | pin header (排针) | - | 20 pin: 1<br>4 pin: 1 |
 | capacitance (电容) | - | 0.1 uF: 2<br> 1 uF: 2<br> 10 uF: 1 |
 | resistance (电阻) | - | 10 K: 3<br> 660 R: 2 |
 | LDO | XC6206P332MR | 1 |
 | button | 3.5mm*8mm | 2 |
 | LED | 0603 | red: 1<br>blue: 1 |

</div>

### Welding  

Below is the welding instructions.

<div class='center'>

| name | silkscreen logo (丝印) | 
| :-: |:-: | 
| 0.1uF|  C11, C6 |
| 1uF | C4, C5 |
| 10uF| C3 |
| 10K | R1 R6 R7 |
| 660R | R3 R4  |
| LDO | U1 |
| LED | U8 (power), U9 (GPIO13) |  
| ESP-12 | U6 |  
| button | U5 (reset), U6 (GPIO0) |
| pin header | H1, H3 |

</div>
