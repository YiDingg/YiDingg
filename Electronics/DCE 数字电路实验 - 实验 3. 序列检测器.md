# DCE 数字电路实验 - 实验 3. 序列检测器 (week 8 - 2025.11.08)


> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 08:31 on 2025-11-08 in Beijing.

## 1. 实验时间

- DCE-03: week 8 Sat (2025.11.08)
- 报告提交截止: week 9 Fri (2025.11.14)


## 2. 实验记录


本次实验分为两部分，第一部分是利用有限状态机 (FSM, finite state machine) 来设计序列检测器 (sequence detector)，第二部分则是利用最简单的移位寄存器 (shift register) 来实现。


对每一种实现方式，一个比较麻烦的点是 testbench 的编写，另一个比较麻烦的点是 top 模块和 constraints 文件设置。



### 2.1 sequence_detector_fsm


``` verilog
// sequence detector using state machine
// 2025.11.06 by YiDingg (https://www.zhihu.com/people/YiDingg)

module fsm(
    input clk,      // tell the machine when we should start
    input din,      // the signal we input
    input rst,      // restart
    output count,   // tell us the result
    output reg [2:0] st_cur
    );

    reg count_store;  // store the count

    parameter s_0 = 3'd0;   // 0
    parameter s_1 = 3'd1;   // 1
    parameter s_2 = 3'd2;   // 10
    parameter s_3 = 3'd3;   // 100
    parameter s_4 = 3'd4;   // 1001
    parameter s_5 = 3'd5;   // 10011
    parameter s_6 = 3'd6;   // 100110
    
    reg [2:0] st_next;
    
    // step 1:state transfer
    always @(posedge clk or posedge rst) begin
        if(rst)begin
            st_cur <= 0;    // restart
        end else
        begin
            st_cur <= st_next;
        end
    end


    // target sequence: 101111
    // four possible preceding bits:
    // (00 101111)_2 = (47)_10
    // (01 101111)_2 = (111)_10
    // (10 101111)_2 = (175)_10
    // (11 101111)_2 = (239)_10


    // step 2:state switch,using block assignment for combination_logic
    always @(*)begin
        case(st_cur)
            s_0:
                if(din)begin
                    st_next = s_1;
                end else
                begin
                    st_next = s_0;
                end
                
            s_1:
                if(din)begin
                    st_next = s_1;
                end else
                begin
                    st_next = s_2;
                end
            
            s_2:
                if(din)begin
                    st_next = s_3;
                end else
                begin
                    st_next = s_0;
                end
            
            s_3:
                if(din)begin
                    st_next = s_4;
                end else
                begin
                    st_next = s_2;
                end
        
            s_4:
                if(din)begin
                    st_next = s_5;
                end else
                begin
                    st_next = s_2;
                end
        
            s_5:
                if(din)begin
                    st_next = s_6;
                end else
                begin
                    st_next = s_2;
                end
        
            s_6:
                if(din)begin
                    st_next = s_1;
                end else
                begin
                    st_next = s_2;
                end
        endcase
    end
    
    // step 3: output logic,using non_block assignment
    always @(posedge clk or posedge rst)begin
        if(rst)begin
            count_store <= 0;
        end else
        begin
            if(st_next == s_6)begin
                count_store <= 1;
            end else
            begin
                count_store <= 0;
            end
        end
    end
    
    assign count = count_store;
endmodule

```


代码采用了经典三段式状态机架构，将状态转移、状态切换逻辑和输出逻辑分离。 
首先，模块定义了七个状态参数，每个状态对应序列检测过程中的一个特定阶段：s_0 表示初始空闲状态，s_1 表示已接收到第一个 '1'，s_2表示接收到 "10"，s_3表示 "100"，s_4表示 "1001"，s_5表示 "10011"，最终 s_6 状态表示成功检测到完整的目标序列 "100110"。这种状态划分清晰地反映了序列检测的渐进过程。
代码的核心采用三段式状态机设计。第一段是状态转移逻辑，在时钟上升沿或复位信号有效时更新当前状态。当复位信号rst为高电平时，状态机回到初始状态 s_0；否则，当前状态 st_cur 更新为下一状态 st_next。第二段是组合逻辑的状态切换部分，使用阻塞赋值，通过 case 语句根据当前状态和输入信号 din 决定状态转移路径。例如，在 s_0 状态下，如果输入为 '1' 则转移到 s_1 状态，否则保持在 s_0 状态；在 s_5 状态下，如果输入为 '1' 则转移到表示序列匹配的 s_6 状态，否则回退到 s_2 状态重新开始检测。
第三段是输出逻辑，采用时序逻辑的非阻塞赋值。当检测到下一状态将进入 s_6 时，count_store 信号在下一个时钟周期变为高电平，表示成功检测到目标序列；否则输出保持为低电平。这种设计确保了输出信号与时钟同步，避免了组合逻辑可能产生的毛刺。最终，count_store 的值通过连续赋值语句输出到count端口。整个状态机通过这种清晰的分层设计，实现了对 "100110" 序列的可靠检测，同时在检测到完整序列后能够自动回到适当的初始状态继续后续的检测任务。
2) 同时还需实现使用数码管显示当前检测结果，1表示检测有效，0表示检测无效，可调用已写好的模块。
调用已经使用过的译码模块，将状态机的检测输出dout输入至译码模块即可。当检测有效时就会显示1，否则为零。



``` verilog
// tb_fsm.v

`timescale 1ns / 1ps

module tb_fsm();
    
    reg clk;
    reg rst;
    reg din;
    wire dout;
    wire [2:0] state;
    wire [7:0] array_now;
    
    fsm uut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .dout(dout),
        .state(state),
        .array_now(array_now)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        din = 0;
        
        // Reset
        #20;
        rst = 0;
        #10;
        
        $display("Time\tValue\tBinary\t\tState\tdout\tMatch");
        $display("------------------------------------------------");
        
        // Test specific target values
        test_value(8'd47);   // 00101111 - should match
        test_value(8'd111);  // 01101111 - should match  
        test_value(8'd175);  // 10101111 - should match
        test_value(8'd239);  // 11101111 - should match
        
        #100;
        $display("=== Test Complete ===");
        $finish;
    end
    
    task test_value;
        input [7:0] value;
        integer i;
        begin
            $display("--- Testing value %d (%b) ---", value, value);
            
            // Send 8 bits MSB first
            for (i = 7; i >= 0; i = i - 1) begin
                din = value[i];
                @(posedge clk);
                #1;
                $display("%0t\t-\t-\t\t%d\t%b", $time, state, dout);
            end
            
            // Check result
            @(posedge clk);
            #1;
            if (dout) begin
                $display("*** SUCCESS: Sequence detected for value %d ***", value);
            end else begin
                $display("*** FAIL: Sequence not detected for value %d ***", value);
            end
            
            // Wait between tests
            repeat(4) @(posedge clk);
        end
    endtask

endmodule
```


``` verilog
// top_fsm.v

module top_fsm(
    input clk,  // clock of sysytem
    input s0,   // signal press
    input rst,  // signal:restart
    input SW0,  // signal:din
    input  [3:0] ctrl, // control signal for anode
    output [7:0] on,   // output of reg
    output [7:0] sseg, // output reflects on the led
    output wire [3:0] an,
    output wire [2:0] st,
    output wire debug
    );
    
    assign an = ctrl;
    wire s0_o;
    wire rst_o;
    wire count_o;
    
    db db_fsm_clk(
    .clk(clk),
    .sw(s0),
    .db(s0_o)
    );
    
    db db_fsm_rst(
    .clk(clk),
    .sw(!rst),
    .db(rst_o)
    );
    
    LD LD(
    .clk(s0_o),
    .rst(rst_o),
    .din(SW0),
    .on(on)
    );
    
    fsm fsm(
    .clk(s0_o),
    .rst(rst_o),
    .din(SW0),
    .count(count_o),
    .st_cur(st)
    );
    
    hex_7seg hex_7seg(
    .hex(count_o),
    .dp(0),
    .sseg(sseg)
    );
    
    assign debug = s0;
endmodule
```

```bash
# top_fsm.xdc

# Clock, Button & Reset
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports clk]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports s0]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports rst]
# SW0 For input
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports SW0]
# Select Number
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {an[3]}]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports {an[2]}]
set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS33} [get_ports {an[1]}]
set_property -dict {PACKAGE_PIN H1 IOSTANDARD LVCMOS33} [get_ports {an[0]}]
# Select Segment
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {sseg[6]}]
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {sseg[5]}]
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {sseg[4]}]
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {sseg[3]}]
set_property -dict {PACKAGE_PIN A1 IOSTANDARD LVCMOS33} [get_ports {sseg[2]}]
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports {sseg[1]}]
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {sseg[0]}]
set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports {sseg[7]}]

# Green LEDs 1
set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports {str_cur[2]}]
set_property -dict {PACKAGE_PIN M1 IOSTANDARD LVCMOS33} [get_ports {str_cur[1]}]
set_property -dict {PACKAGE_PIN K3 IOSTANDARD LVCMOS33} [get_ports {str_cur[0]}]

# Green LEDs 2
set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports {on[7]}]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {on[6]}]
set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS33} [get_ports {on[5]}]
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports {on[4]}]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {on[3]}]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {on[2]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {on[1]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {on[0]}]

#for ctrl
set_property -dict {PACKAGE_PIN P5 IOSTANDARD LVCMOS33} [get_ports {ctrl[3]}]
set_property -dict {PACKAGE_PIN P4 IOSTANDARD LVCMOS33} [get_ports {ctrl[2]}]
set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports {ctrl[1]}]
set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {ctrl[0]}]
```




### 2.2 sequence_detector_shiftreg

``` verilog
// sequence detector using shift register
module shift_reg(
    input clk,
    input din,
    input rst,
    output reg [7:0] on,
    output reg [3:0] out
    );
    
    reg count = 0;
    
    always @(posedge clk or posedge rst)begin
        if(rst)begin
            on <= 0;
            out<= 0;
        end else
        begin
            on[7:0] <= {on[6:0],din};
            case({on[4:0],din})
                6'b101111: out <= 1;
                default:   out <= 0;
            endcase
        end
    end
endmodule

```

``` verilog
// tb_sr.v
`timescale 1ns / 1ps

module tb_sr();
    
    reg clk;
    reg rst;
    reg din;
    wire [7:0] on;
    wire [3:0] out;
    
    shift_reg uut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .on(on),
        .out(out)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        din = 0;
        
        // Reset
        #20;
        rst = 0;
        #10;
        
        $display("Time\tValue\tBinary\t\ton_reg\tout\tMatch");
        $display("--------------------------------------------------------");
        
        // Test specific target values that contain sequence "101111"
        test_value(8'd47);   // 00101111 - should match
        test_value(8'd111);  // 01101111 - should match  
        test_value(8'd175);  // 10101111 - should match
        test_value(8'd239);  // 11101111 - should match
        
        // Test some values that should NOT match
        test_value(8'd46);   // 00101110 - should NOT match
        test_value(8'd63);   // 00111111 - should NOT match
        test_value(8'd191);  // 10111111 - should NOT match
        
        #100;
        $display("=== Test Complete ===");
        $finish;
    end
    
    task test_value;
        input [7:0] value;
        integer i;
        begin
            $display("--- Testing value %d (%b) ---", value, value);
            
            // Send 8 bits MSB first
            for (i = 7; i >= 0; i = i - 1) begin
                din = value[i];
                @(posedge clk);
                #1;
                $display("%0t\t-\t-\t\t%b\t%b", $time, on, out);
            end
            
            // Check result after complete byte is shifted in
            @(posedge clk);
            #1;
            if (out == 1) begin
                $display("*** SUCCESS: Sequence detected for value %d ***", value);
            end else begin
                $display("*** Sequence not detected for value %d ***", value);
            end
            
            // Wait between tests to observe
            repeat(4) @(posedge clk);
        end
    endtask

endmodule
```

``` verilog
// top_sr.v
module top_sr(
    input clk,//clock of sysytem
    input s0,//signal press
    input rst,//signal:restart
    input SW0,//signal:din
    input [3:0] ctrl,
    output [7:0] on,//output of reg
    output [7:0] sseg,//output reflects on the led
    output wire[3:0] an
    );
    
    assign an = ctrl;
    wire s0_o;
    wire rst_o;
    wire [3:0]out_o;
    
    db db_fsm_clk(
    .clk(clk),
    .sw(s0),
    .db(s0_o)
    );
    
    db db_fsm_rst(
    .clk(clk),
    .sw(!rst),
    .db(rst_o)
    );
    
    shift_reg shift_reg(
    .clk(s0_o),
    .rst(rst_o),
    .din(SW0),
    .out(out_o),
    .on(on)
    );
    
    hex_7seg hex_7seg(
    .hex(out_o),
    .dp(0),
    .sseg(sseg)
    );
    
    
endmodule    
```

``` verilog
# Clock, Button & Reset
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports clk]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports s0]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports rst]
# SW0 For input
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports SW0]
# Select Number
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {an[3]}]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports {an[2]}]
set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS33} [get_ports {an[1]}]
set_property -dict {PACKAGE_PIN H1 IOSTANDARD LVCMOS33} [get_ports {an[0]}]
# Select Segment
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {sseg[6]}]
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {sseg[5]}]
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {sseg[4]}]
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {sseg[3]}]
set_property -dict {PACKAGE_PIN A1 IOSTANDARD LVCMOS33} [get_ports {sseg[2]}]
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports {sseg[1]}]
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {sseg[0]}]
set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports {sseg[7]}]



# Green LEDs 2
set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports {on[7]}]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {on[6]}]
set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS33} [get_ports {on[5]}]
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports {on[4]}]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {on[3]}]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {on[2]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {on[1]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {on[0]}]

# for ctrl
set_property -dict {PACKAGE_PIN P5 IOSTANDARD LVCMOS33} [get_ports {ctrl[3]}]
set_property -dict {PACKAGE_PIN P4 IOSTANDARD LVCMOS33} [get_ports {ctrl[2]}]
set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports {ctrl[1]}]
set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {ctrl[0]}]
```


### 2.3 behavior-simul. (fsm)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-09-15-24_DCE 数字电路实验 - 实验 3. 序列检测器.png"/></div>

### 2.4 behavior-simul. (sr)

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-11-08-09-25-16_DCE 数字电路实验 - 实验 3. 序列检测器.png"/></div>

## 3. 问题记录

generate bitstream 时遇到了 `(NSTD-1)` 报错，参考这篇文章得到解决：
- [CSDN > Vivado 生成 bit 流失败的解决办法](https://blog.csdn.net/yohe12/article/details/104790430)

