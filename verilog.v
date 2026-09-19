// Voltage-controlled oscillator
//
// Version 1a, 1 June 04
//
// Ken Kundert
//
// Downloaded from The Designer's Guide Community (www.designers-guide.org).
// Post any questions on www.designers-guide.org/Forum.
// Taken from "The Designer's Guide to Verilog-AMS" by Kundert & Zinke.
// Chapter 3, Listing 22.


/* updated by YiDingg on 2026.02.24 (https://www.zhihu.com/people/YiDingg)
- modified from VA_VCO_whiteEdgeJitter_2Phase to VA_VCO_whiteCycleJitter_2Phase, which has white cycle jitter instead of white edge jitter for realistic VCO modeling
- added jitter_scale_factor to adjust the output cycle jitter to match the specified Jc_rms_UI
*/
/* updated by YiDingg on 2026.03.02 (https://www.zhihu.com/people/YiDingg)
- added output port "PERIOD_ps" to generate the period in ps for easier verification/usage in testbench
*/
/* updated by YiDingg on 2026.03.03 (https://www.zhihu.com/people/YiDingg)
- modified to unlimited frequency range based on the original cell "VA_VCO_whiteCycleJitter_8Phase"
*/
/* updated by YiDingg on 2026.08.31 (https://www.zhihu.com/people/YiDingg)
- added band control functionality based on the original cell "VA_VCO_whiteCycleJitter_8Phase_unlimitedFreq"
*/

/* updated by YiDingg on 2026.09.03 (https://www.zhihu.com/people/YiDingg)
- added hysteresis in band control 
*/



`include "disciplines.vams"
`include "constants.vams"

/*
"@(timer(next)) begin next = next + 0.5/freq; end" this method is not suitable for VCO, but is only applicable to fixed frequency oscillator.
VCO frequency changes with input voltage, so the next transition time cannot be simply calculated at the last transition instant.
Integration of frequency over time is required to determine the next transition time.
*/


`define PHASE_NUM_integer 8
`define PHASE_NUM_float 8.0


module VA_VCO_whiteCycleJitter_8Phase_unlimitedFreq_bandCtrl (
OUT[(`PHASE_NUM_integer - 1):0],
VCTRL, VSS, VDD,
PHASE_NOR, FLAG_TRANS, PHASE_NOISE, FREQ_MHZ, PERIOD_PS, N_BD
); 

input VCTRL, VSS, VDD;
output OUT[(`PHASE_NUM_integer - 1):0];
output PHASE_NOR, FLAG_TRANS, PHASE_NOISE, FREQ_MHZ, PERIOD_PS, N_BD;
electrical VCTRL, OUT[(`PHASE_NUM_integer - 1):0], VSS, VDD, PHASE_NOR, FLAG_TRANS, PHASE_NOISE, FREQ_MHZ, PERIOD_PS, N_BD;


/* To be set VCTRL the "design variable" section of the testbench */
parameter real k_vco          =   100M    from [0:inf);           // VCO gain (Hz/V)
parameter real freq_init      =   10G     from (0:inf);           // corner frequency of the low-pass filter for noise shaping (Hz)
parameter real f_lowerLimit   =   1G      from (0:inf);           // lower limit of the output frequency (Hz)
parameter real f_upperLimit   =   50G     from (0:inf);           // upper limit of the output frequency (Hz)
parameter real VCTRL_init     =   0       from (-inf:inf); // initial control voltage (V), also the center voltage of the VCO tuning range
parameter real t_trans_UI     =   0.1     from (0:0.5];           // rise time as fraction of period (0 ~ 0.5)
parameter real Jc_rms_UI      =   10m     from [0:1);             // rms cycle jitter as fraction of period (0 ~ 1)
parameter real fnoise_max     =   10G     from (0:inf);           // maximum transition noise frequency
parameter real t_start        =   0       from [0:inf);           // time to start oscillation (s)
parameter real f_BD           =   0.2G    from (0:inf);           // frequency range fro each band of VCO
parameter real alpha_BD       =   0.2     from [0:1);             // percentage of overlap between adjacent bands
parameter real alpha_hyst     =   0.1     from (0: 0.5);          // normalized hysteresis factor


/* parameter to be set in "Design Variable" */
parameter real FNOISE_max     =   fnoise_max;
parameter real vol_noise_enable = 0; // enable voltage noise when set to 1, otherwise disable voltage noise when set to 0

real vctrl_min = -100;
real vctrl_max = 100;
real f_min = f_lowerLimit; // minimum output frequency (Hz)
real f_max = f_upperLimit; // maximum output frequency (Hz)

real vnoise_scale_factor = 1;
real jitter_scale_factor = 1.4828;

integer seed = 314;
integer flag_transition = 0;
integer flag_start = 0;
integer flag_vol_noise = 0;
integer logic_out;
real phase_posEdge = `M_PI/4; // phase at which output goes high
real phase_negEdge = phase_posEdge + `M_PI; // phase at which output goes low
real phase_posEdge_normalized = phase_posEdge / (2*`M_PI);
real phase_negEdge_normalized = phase_negEdge / (2*`M_PI);
real t_start_oscillation = 0;

real vout; // output voltage of the main output (OUT[0])
real freq, period, voltage_noise, period_jittered, freq_jittered;
real phase, phase_normalized, cosine_phase, phase_noise;
real phase_jittered, phase_jittered_normalized;
real phase_jittered_1of2, phase_jittered_1of2_normalized;

// for band control
real v_BD = f_BD/k_vco;    // voltage range for each band, i.e., within (0, v_BD)
integer N_band; // current band number
real v_ctrl_nor; // normalized control voltage: v_ctrl_nor = (VCTRL - v_0 + v_BD/2) / v_BD = ((VCTRL - v_0)/v_BD + 0.5, where v_0 = VCTRL_init
real v_ctrl_nor_inBD; // in (-0.5, +0.5) or (-0.5 + delta, +0.5) or (-0.5, +0.5 + delta)
real Vth_inBD_right, Vth_inBD_left;
integer last_band_transition;   // in {-1, 0, +1}, last band transition direction (initial 0)
// last_band_transition = lbt = {-1, 0, +1}
//                (1 - lbt)/2 = {1, 0.5, 0}, used at right threshold
//                (1 + lbt)/2 = {0, 0.5, 1}, used at left threshold


analog begin
    // Initialization at the start of simulation or when t_start is reached
    @(initial_step) begin
        f_min = f_lowerLimit; // minimum output frequency (Hz)
        f_max = f_upperLimit; // maximum output frequency (Hz)
        flag_start = 0;         // VCO starts oscillating when flag_start is set to 1
        flag_transition = 0;    // reset flag
        flag_vol_noise = 0;
        // t_start_oscillation = t_start + $abstime;
        // freq = f_min + k_vco*(V(VCTRL) - vctrl_min); // Initial frequency
        V(VCTRL) <+ VCTRL_init; // set the initial control voltage
        freq = freq_init; // Initial frequency at the voltage of VCTRL_init 
        if (freq < f_min) freq = f_min; // Bound the frequency
        if (freq > f_max) freq = f_max; // Bound the frequency
        period = 1.0 / freq; // Initial period
        period_jittered = period;
        freq_jittered = freq;
        logic_out = 0; // Initial logic output
        voltage_noise = 0;
        phase = 0;
        phase_normalized = 0;
        cosine_phase = 0;
        phase_noise = 0;
        vout = V(VSS); // Initial output voltage
        $bound_step(0.05/freq); // Bound the time step to period/20 for better noise simulation

        // for band control
        // v_BD = f_BD/k_vco;    // voltage range for each band, i.e., within (0, v_BD)
        N_band = 0; // Initialize the current band number
        last_band_transition = 0;
        v_ctrl_nor = (V(VCTRL) - VCTRL_init) / v_BD;  // initial at 0
        v_ctrl_nor_inBD = v_ctrl_nor - N_band*1;
        Vth_inBD_right = 0.5 + alpha_hyst*(1 - last_band_transition)/2;
        Vth_inBD_left = -0.5 - alpha_hyst*(1 + last_band_transition)/2;
    end


    @(timer(max(0, t_start - period*(1.0/8.0 + t_trans_UI/2.0)))) begin
        f_min = f_lowerLimit; // minimum output frequency (Hz)
        f_max = f_upperLimit; // maximum output frequency (Hz)
        flag_start = 1;         // VCO starts oscillating when flag_start is set to 1
        flag_transition = 0;    // reset flag
        flag_vol_noise = 1;   // enable voltage noise after oscillation starts
        // freq = f_min + k_vco*(V(VCTRL) - vctrl_min); // Initial frequency
        // V(VCTRL) <+ VCTRL_init; // set initial control voltage to the center of the tuning range
        freq = freq_init; // Initial frequency with VCTRL_init as the center voltage of the tuning range
        if (freq < f_min) freq = f_min; // Bound the frequency
        if (freq > f_max) freq = f_max; // Bound the frequency
        period = 1.0 / freq; // Initial period
        period_jittered = period;
        freq_jittered = freq;
        logic_out = 0; // Initial logic output
        voltage_noise = 0;
        phase = 0;
        phase_normalized = 0;
        cosine_phase = 0;
        phase_noise = 0;
        vout = V(VSS); // Initial output voltage
        $bound_step(0.05/freq); // Bound the time step to period/20 for better noise simulation
    end

    // band ctrl with hysteresis
    v_ctrl_nor = (V(VCTRL) - VCTRL_init) / v_BD;
    v_ctrl_nor_inBD = v_ctrl_nor - N_band*1;
    Vth_inBD_right = 0.5 + alpha_hyst*(1 - last_band_transition)/2;
    Vth_inBD_left = -0.5 - alpha_hyst*(1 + last_band_transition)/2;
    @(cross(v_ctrl_nor_inBD - Vth_inBD_right, +1)) begin
        N_band = N_band + 1;
        last_band_transition = +1;
        v_ctrl_nor_inBD = v_ctrl_nor - N_band*1;    //  cross  Vctrl
    end
    @(cross(v_ctrl_nor_inBD - Vth_inBD_left, -1)) begin
        N_band = N_band - 1;
        last_band_transition = -1;
        v_ctrl_nor_inBD = v_ctrl_nor - N_band*1;    //  cross  Vctrl
    end

    // Compute the output frequency
    if (V(VCTRL) > vctrl_min && V(VCTRL) < vctrl_max) begin 
        // freq = freq_init + k_vco*(V(VCTRL) - VCTRL_init); 
        freq = freq_init       // 原先的 (freq_init - f_BD/2) 改为 freq_init 因为现在 v_ctrl_nor_inBD \in (-0.5, +0.5) 而不是 (0, 1)
             + v_ctrl_nor_inBD*v_BD * k_vco
             + N_band*f_BD*(1 - alpha_BD);
    end
    else if (V(VCTRL) <= vctrl_min) begin freq = f_min; end
    else if (V(VCTRL) >= vctrl_max) begin freq = f_max; end

    // period, frequency and phase operations
    period = 1.0 / freq; // Update period based on frequency
    phase = 2*`M_PI*idtmod(flag_start * (1/period_jittered), 0.0, 1.0, 0); // use flag_start to control when the VCO starts oscillating
    phase_normalized = phase/(2*`M_PI);     // Normalized phase [0, 1)
    phase_jittered = phase + phase_noise; // edge phase noise
    phase_jittered_normalized = phase_jittered / (2*`M_PI);
    // idtmod(expr, initial, modulus, offset) computes the integral of freq over time, note that modulus = 1.0 here to get phase in [0, 2pi]
    
    @(cross(phase_jittered - phase_posEdge, +1)) begin
        logic_out = 1; // high-level output
        flag_transition = 1;
    end
    @(cross(phase_jittered - phase_negEdge, +1)) begin
        logic_out = 0; // low-level output
        flag_transition = 1;
    end

    if (flag_transition == 1) begin
        flag_vol_noise = 0; // disable voltage noise during transition to avoid unrealistic noise spikes due to rapid voltage changes
        if (logic_out == 1) begin       // rising edge
            vout = V(VSS) + (1 - cos(cosine_phase))/2 * (V(VDD) - V(VSS)); // rising edge with cosine shape
            cosine_phase = (phase_jittered_normalized - phase_posEdge_normalized) / t_trans_UI * `M_PI;
        end if (logic_out == 0) begin   // falling edge
            vout = V(VDD) - (1 - cos(cosine_phase))/2 * (V(VDD) - V(VSS)); // falling edge with cosine shape
            cosine_phase = (phase_jittered_normalized - phase_negEdge_normalized) / t_trans_UI * `M_PI;
        end
        // if (cosine_phase > `M_PI) flag_transition = 0; // reset flag if transition complete
    end else begin
        flag_vol_noise = 1; // enable voltage noise during steady state
        vout = (logic_out == 1) ? V(VDD) : V(VSS); // steady state output
    end
    /* 
    Use "if (cosine_phase > `M_PI) flag_transition = 0;" in the above block will cause "flag reset lag",
    so we use event control @(cross(cosine_phase - `M_PI, +1)) to reset flag_transition when transition is complete.
    */
    @(cross(cosine_phase - `M_PI, +1)) begin
        flag_transition = 0; // reset flag after transition complete
        cosine_phase = 0;
        phase_noise = 2*`M_PI*(Jc_rms_UI/10) * $rdist_normal(seed, 0, 1); // update phase noise at the end of each transition
        period_jittered = period * (1 + jitter_scale_factor * Jc_rms_UI * $rdist_normal(seed, 0, 1)); // Jittered period
    end

    voltage_noise = vol_noise_enable * flag_vol_noise * vnoise_scale_factor * Jc_rms_UI * white_noise(1/FNOISE_max) * V(VDD, VSS) / ((logic_out&&(!flag_transition)) ? 1 : 2.5); // output voltage noise
    V(OUT[0]) <+ vout + voltage_noise;	// plus noise on output voltage
    V(PHASE_NOR) <+ phase_normalized; // output normalized phase [0, 1)
    V(FLAG_TRANS) <+ flag_transition; // output transition flag
    V(PHASE_NOISE) <+ phase_noise; // output phase noise
    V(FREQ_MHZ) <+ freq/1e6;     // output frequency
    V(PERIOD_PS) <+ period*1e12; // output period in ps
    V(N_BD) <+ N_band; // output band number
    //V(PERIOD) <+ period; // output period


/* commented by YiDingg at 18:24, 2026.02.08
I don't know why the absdelay() function does not work here to generate the complementary output, even when I set max_delay to a very large value. 
As a workaround, I choose to use a separate verilog-a model "VCDL (voltage-controlled delay line)" to generate the complementary output with a dynamic delay of half period, and the delay can be adjusted dynamically during simulation as the period changes. 
*/

end




electrical Zero_Volt; // zero voltage reference for the delay model
electrical Delay[(`PHASE_NUM_integer - 1):0]; // delay control voltages for the 8 outputs

VA_VCDL_AdjustableDelay #(
    .delay_gain(0), // vtcrl-to-delay gain
    .delay_max(1000/freq_init)   // maximum limit of the delay (if VCTRL is too large, the delay will not increase anymore)
) VCDL[(`PHASE_NUM_integer - 1):1] (
    .VIN(OUT[0]), 
    .VCTRL(Zero_Volt), 
    .DELAY_FIXED(Delay[(`PHASE_NUM_integer - 1):1]), // total delay is set to half of the period, and it will be updated dynamically during simulation as the period changes
    .VOUT(OUT[(`PHASE_NUM_integer - 1):1])
);

analog begin
    V(Zero_Volt) <+ 0; // zero voltage reference for the delay model
    generate j (1, (`PHASE_NUM_integer - 1)) V(Delay[j]) <+ j/`PHASE_NUM_float * period; // `PHASE_NUM_float must be used here to avoid integer division, which will cause the delay to be always 0 and thus the complementary outputs will be the same as the main output without phase difference
end 


endmodule






