/*
 * File        : adc_measurement.sv
 * Author      : Levi Johanon
 * Description : Tells adcs when to take the measurements during PWM
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */
 

module adc_measurement #(
	parameter MULT = 1,
	parameter HALF = 0) (
	input enable,
	input [MULT+10:0] pwm_count, pwm_low_1, pwm_low_2,
	output logic meas_1, meas_2); 
	
	always_comb begin
		if(enable) begin
			if(pwm_low_1 > 10'd138)
				meas_1 = pwm_count > 10'd180;
			else
				meas_1 = pwm_count > (10'd42 + pwm_low_1);
				
			if(pwm_low_2 > 10'd138)
				meas_2 = pwm_count > 10'd180;
			else
				meas_2 = pwm_count > (10'd42 + pwm_low_2);
		end else begin
			meas_1 = 1'b0;
			meas_2 = 1'b0;
		end
	end
endmodule
