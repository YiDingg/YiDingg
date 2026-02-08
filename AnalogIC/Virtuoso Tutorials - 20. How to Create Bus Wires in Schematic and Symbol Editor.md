# Virtuoso Tutorials - 20. How to Create Bus Wires in Schematic and Symbol Editor.md

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 19:02 on 2026-02-02 in Lincang.
> dingyi233@mails.ucas.ac.cn

## Introduction

最近做 PAM3 CDR 项目时，很多 Verilog-A 或者实际模块都需要用到 BUS Wires (总线)，最典型的比如 ADC (DAC) 的输出 (输入) 就是多 bit 的数据总线，因此这篇文章就来介绍一下如何在 Cadence Virtuoso 的 Schematic Editor 和 Symbol Editor 中创建并使用 BUS Wires。

## 1. Bus Wires for Verilog-A Modules

对于 Verilog-A 模块，创建 BUS Wires 其实非常简单，只需要在 Verilog-A 代码中将对应输入/输出端口定义为多 bit 即可。例如 `output [7:0] OUT;` 就表示输出端口 OUT 是一个 8-bit 的总线，这样在点击左上角 `Build a database of instances` 创建 symbol 时，就会自动在 symbol 生成对应的 BUS 端口，不需要我们手动设置。



举个具体的例子，假设我们有一个 ideal 8-bit ADC 的 Verilog-A 模块 `VA_ADC_ideal_8bit`，其代码如下：

``` bash
`include "constants.vams"
`include "disciplines.vams"

module VA_ADC_ideal_8bit_input0to255V(vin, dout);
 input   vin;
 voltage vin;

 output  [7:0] dout;
 voltage [7:0] dout;

  parameter real  vmax = 255;
  parameter real  vmin = 0;
  parameter real   one = 1;
  parameter real  zero = 0.0;
  parameter real   vth = 0.5;
  parameter real slack = 10.0p from (0:inf);
  parameter real trise = 1n from (0:inf);
  parameter real tfall = 1n from (0:inf);
  parameter real tconv = 1n from [0:inf);
  parameter integer traceflag = 0;

     real   sample, vref, lsb, voffset;
     real   vd[0:7];
     integer ii, binvalue;

    analog begin
      @(initial_step or initial_step("dc", "ac", "tran", "xf"))  begin
        vref = (vmax - vmin) / 2.0;
        lsb  = (vmax - vmin) / (1 << 8) ;
        voffset = vmin;
		    
        if (traceflag)
        $display("%M ADC  range ( %g v ) /  %d bits  = lsb %g volts.\n",
                    vmax - vmin, 4, lsb );

        generate i ( 7, 0) begin
            vd[i] = 0 ;
        end
    end

 
          binvalue = 0;
          sample = V(vin) - voffset;
          for ( ii = 7 ; ii>=0 ; ii = ii -1 ) begin
            vd[ii] = 0;
            if (sample > vref ) begin
              vd[ii] = one;
              sample = sample - vref;
              binvalue = binvalue + ( 1 << ii );
            end
            else begin
             vd[ii] = zero;
            end
            sample = sample * 2.0;
          end
          if (traceflag)
            $strobe("%M at %g sec. digital out: %d   vin: %g  (d2a: %g)\n",
                       $abstime, binvalue,  V(vin), (binvalue*lsb)+voffset);
 

      generate i ( 7, 0) begin
         V(dout[i])  <+   transition ( vd[i] , tconv, trise, tfall );
	  end
    end				
endmodule
```

点击 `Build a database of instances`，软件会自动生成 symbol，效果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-02-19-22-30_Virtuoso Tutorials - 20. How to Create Bus Wires in Schematic and Symbol Editor.png"/></div>


## 2. Create Bus Wires in Schematic Editor


那么，如何在 Schematic Editor 中手动创建 BUS Wires 呢？下面就以这个 ideal 8-bit ADC 的 testbench 为例，介绍具体的操作步骤。


**第一种方法：** 放置好模块 (ADC) 后，可以直接在其 BUS 输出端口上连线，此时看 Q 查看属性可以看到其网络名为 `net1<7:0>`，说明这样直接引出来的连线已经是一个 8-bit 的 BUS Wire 了，这如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-02-19-26-01_Virtuoso Tutorials - 20. How to Create Bus Wires in Schematic and Symbol Editor.png"/></div>

当然，为了区分 BUS wire 和普通 wire，我们一般会把 BUS wire 的线宽属性设置为 `Width = wide` (默认是 `Width = narrow`)。


除了直接引出，更方便的还是 **第二种方法：** 按空格键 `Space` (默认按键好像是这个，具体命令是 `schHiCreateWireStubs()`，我自己的话改为了 `Ctrl + N`)，这样会自动引出所有走线，并自动将 BUS wire 设置为 `Width = wide`，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-02-19-29-34_Virtuoso Tutorials - 20. How to Create Bus Wires in Schematic and Symbol Editor.png"/></div>

**第三种方法是手动创建 BUS wire：** 按下 `L` 创建 label, 输入 `Names = dout<7:0>` 后，下面一共有四个可选项：

- **(1) Expand Bus Names:** 将总线名称例如 `dout<7:0>` 自动展开为 8 条独立的单线 `dout<0>, dout<1>, ..., dout<7>`，在需要为总线的每一位单独连线时使用
- **(2) Attach to Multiple Wires:** 允许单个总线标签同时连接到多根信号线，比如一个 `dout<7:0>` 标签可以依次连接多条其它线，直至取消 (多次连接，每次都是将 `dout<7:0>` 连上去)
- **(3) Create Net Alias Labels:** 创建网络别名标签 (为现有网络添加别名, **注意这会创建新的物理连接**)。
- **(4) Display Bundles Vertically** (垂直显示总线束) 控制总线标签的显示方向，选中时总线标签垂直显示，未选中时总线标签水平显示

上面 (1) (2) (4) 选项比较好理解，下面具体介绍一下 (3) 选项的作用。

## 3. Effect of "Create Net Alias Labels"

通常来讲一个 net 只会有一个名称 (net name 或者 label)，但是如果我们使用了上面提到的 **(3) Create Net Alias Labels** 选项，就可以为一个 net 添加多个 label 而不报错，此时这个节点/网络的实际名称就不是多个 label 中的任何一个，而是 Cadence 自动生成的一个名称 (例如 `net1`)，这些 label 都只是这个 net 的别名而已。

下面举一个具体的例子：我们将 `test` 和 `dout<6>` 两个 label 分别连接到电容 `C1` 和 `C2` 上 (一人连一个)，然后在 `C3` 上同时连接 `test` 和 `dout<6>` 两个 label (相当于为 `C3` 创建了两个别名标签)；从生成的版图可以看出，`C1/C2/C3` (的正端) 其实都是连在一起的，这是因为 `C3` 同时连接了 `test` 和 `dout<6>` 两个 label，将它们 "在物理连接在了一起"，软件便将其自动处理为了一个节点，因此 `C1/C2` (的正端) 自然也就和 `C3` (的正端) 连在了一起，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-03-03-09-09_Virtuoso Tutorials - 20. How to Create Bus Wires in Schematic and Symbol Editor.png"/></div>


## 4. Create Bus Wires in Symbol Editor

最后，我们再来看一下如何在 Symbol Editor 中创建 BUS wires。其实和 Schematic Editor 中的操作类似，主要有两种方法：
- **第一种方法：** 直接从 schematic 创建得到 symbol，此时 symbol 对应端口自动就是 BUS 端口了
- **第二种方法：** 手动在 Symbol Editor 中创建 BUS 端口，像创建 schematic 中的 BUS label 一样，直接在创建的 pin name 处使用 `dout<7:0>` 即可



## 5. ADC Testbench Example 

懂了如何创建 BUS wires 之后，我们可以来看一个完整的 testbench 例子，下面是一个简单的 testbench for ideal 8-bit ADC, 其中 RC 阵列用于模仿 ADC 的后级负载 (当然，这里设置的负载较大，达到 RC time constant = 21ps, 仅作演示)：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-03-17-59-48_Virtuoso Tutorials - 20. How to Create Bus Wires in Schematic and Symbol Editor.png"/></div>

在上图的 RC 阵列中，我们用到了一个技巧 **BUS instances**，先卖个关子，把 testbench 介绍完再作详细解释。设置 ADC 输入电压在 `0 ~ 255` 之间变化，仿真结果如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-03-03-42-02_Virtuoso Tutorials - 20. How to Create Bus Wires in Schematic and Symbol Editor.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-03-03-43-02_Virtuoso Tutorials - 20. How to Create Bus Wires in Schematic and Symbol Editor.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-03-03-51-32_Virtuoso Tutorials - 20. How to Create Bus Wires in Schematic and Symbol Editor.png"/></div>

可以看到， ADC 的输出 `dout<7:0>` 随着输入电压 `vin` 的变化而正确地输出了对应的数字值 (0~255)，说明我们 ADC，以及 BUS wire 的创建和使用都是正确的。并且，受到 ADC 输出路径上的 RC 负载影响，输出波形存在一定上升/下降时间，在输入电压变化过快时会出现输出数字码无法及时跟上的现象 (主要是变化最快的 `vc<0>`)，也即输出数字码的电平未达到 VDD/VSS 便进入下一次翻转。


## 6. Explanation of BUS Instances

上面 testbench 的原理图中，我们用到了电容和电阻的 **BUS instances**，也就是 `C0<7:0>` 和 `R0<7:0>`，它们俩器件之间的网络命名为了 `vc<7:0>`，这等价于我们一共创建了八组 RC 电路，并且将每一组的 RC 分别做了连接，像下面这样：
- R<0> - vc<0> - C<0>
- R<1> - vc<1> - C<1>
- ......
- R<7> - vc<7> - C<7>

不妨生成一下这个 BUS instances 的版图，验证一下其连接关系，如下图所示：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2026-02-03-18-09-39_Virtuoso Tutorials - 20. How to Create Bus Wires in Schematic and Symbol Editor.png"/></div>

和我们刚刚描述的一样，`R0<7:0>` 和 `C0<7:0>` 分别创建了八个电阻和电容器件，并且分别通过 `vc<7:0>` 连接在了一起。

 
