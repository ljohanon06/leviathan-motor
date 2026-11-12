/*
 * File        : voltage_normalizer.sv
 * Author      : Levi Johanon
 * Description : Calculates how long the pwm should be high based on line voltage
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module voltage_normalizer #(
	parameter MULT = 1,
	parameter HALF = 0) (
	input [17:0] v_in, //Signed x.xxx...
	output logic [10+MULT:0] pwm_high, pwm_low);
	
	localparam logic [10+MULT:0] MAX = (11+MULT)'((1024 + (HALF ? 511 : 0)) << MULT);
	localparam logic [10+MULT:0] MAX_ADC = (11+MULT)'(MAX - 93); //400ns + 3 spare clock cycles
	
	//Step 1: Shift up voltage from -1 to 1 to 0 to 2	
	//Step 2: Calculate high period
	logic [10+MULT:0] pwm_cycles, pwm_half;
	assign pwm_cycles = {~v_in[17],v_in[15:7-MULT]}; //Will be optimized out
	assign pwm_half = (11+MULT)'(pwm_cycles + (HALF ? (pwm_cycles >> 1) : 'b0));
	
	//Step 3: Account for ADC measurement
	always_comb begin
		if(pwm_half > MAX_ADC || (~v_in[17] & v_in[16])) //'b01... = +1
			pwm_high = MAX_ADC;
		else pwm_high = pwm_half;
	end
	
	assign pwm_low = MAX - pwm_high;
	
endmodule
