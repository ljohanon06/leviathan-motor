/*
 * File        : voltage_normalizer.sv
 * Author      : Levi Johanon
 * Description : Calculates how long the pwm should be high based on line voltage
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module voltage_normalizer (
	input [17:0] v_in, //Signed x.xxx...
	output logic [9:0] pwm_high);
	
	//Step 1: Shift up voltage from -1 to 1 to 0 to 2	
	//Step 2: Calculate high period
	logic [9:0] pwm_cycles;
	assign pwm_cycles = {~v_in[17],v_in[15:7]};
	
	//Step 3: Account for ADC measurement
	always_comb begin
		if(pwm_cycles > 10'd934 || (~v_in[17] & v_in[16])) //'b01... = +1
			pwm_high = 10'd934;
		else pwm_high = pwm_cycles;
	end
	
endmodule
