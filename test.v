// Simple edge-triggered D flip-flop
//
// Version 1c, 17 July 03
//
// Ken Kundert
//
// Downloaded from The Designer's Guide (www.designers-guide.org).
// Post any questions to www.designers-guide.org/Forum

// D-flip flop without set or reset

`include "disciplines.vams"

// modified by YiDingg on 2026.02.07 (https://www.zhihu.com/people/YiDingg)

module VA_LogicVDD_DFF_doubleEdge (Q, QB, CK, D, VSS, VDD);
/* Inputs and Outputs */
output Q, QB;
input D, CK, VSS, VDD;
electrical D, CK, Q, QB, VSS, VDD;

/* Instance Parameters */
parameter real t_delay = 1p from [0:inf);	// delay from clock to Q
parameter real t_rise  = 1p from [0:inf);	// transition time of output signals
parameter real t_fall  = 1p from [0:inf);	// transition time of output signals
//parameter integer edge_dir = +1 from [-1:+1] exclude 0;
			// if edge_dir=+1, rising clock edge triggers flip flop 
			// if edge_dir=-1, falling clock edge triggers flip flop 

/* Internal Variables */
real state;
real vth;	// threshold voltage at inputs and CK

// Behavioral Description
analog begin
    vth = (V(VDD) + V(VSS)) / 2;
    @(cross(V(CK) - vth, +1) or cross(V(CK) - vth, -1)) state = (V(D) > vth); // double-edge triggered
    V(Q)  <+ V(VDD) * transition(state, 3*t_delay, t_rise, t_fall);
    V(QB) <+ V(VDD) * transition(!state, 3*t_delay, t_rise, t_fall);
end

endmodule