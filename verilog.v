`include "constants.vams"
`include "disciplines.vams"

module VA_LogicVDD_OR8_BUS (Y, A[7:0], VSS, VDD);

output Y;
input A[7:0], VSS, VDD;
voltage A[7:0], VSS, VDD, Y;
parameter real t_delay = 1p from [0:inf);	// delay to start of output transition
parameter real t_rise  = 1p from [0:inf);	// rise time of output signals
parameter real t_fall  = 1p from [0:inf);	// fall time of output signals
real vin_th;
integer logic_out;
analog begin
    vin_th = (V(VDD, VSS))/2;

    @( cross(V(A[0]) - vin_th)
    or cross(V(A[1]) - vin_th)
    or cross(V(A[2]) - vin_th)
    or cross(V(A[3]) - vin_th)
    or cross(V(A[4]) - vin_th)
    or cross(V(A[5]) - vin_th)
    or cross(V(A[6]) - vin_th)
    or cross(V(A[7]) - vin_th)
    );    // make sure simulator sees the threshold crossing

    if (   (V(A[0]) > vin_th)
        || (V(A[1]) > vin_th)
        || (V(A[2]) > vin_th)
        || (V(A[3]) > vin_th)
        || (V(A[4]) > vin_th)
        || (V(A[5]) > vin_th)
        || (V(A[6]) > vin_th)
        || (V(A[7]) > vin_th)
	) logic_out = 1; 
    else logic_out = 0;  // OR operation

    V(Y) <+ V(VSS) + V(VDD, VSS) * transition(logic_out, t_delay, t_rise, t_fall);    // output transition

/*
    if ((V(A) > vin_th) || (V(B) > vin_th)) logic_out = 1; else logic_out = 0;  // OR operation
    V(Y) <+ V(VDD) * transition(logic_out, t_delay, t_rise, t_fall);    // output transition 
*/

end
endmodule