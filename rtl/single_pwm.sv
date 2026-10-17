/*
 * File        : single_pwm.sv
 * Author      : Levi Johanon
 * Description : Handles the pwm output for one half bridge, inside triple_pwm.sv
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module single_pwm (
	input [10:0] pwm_count,
	input [9:0] pwm_high_count,
	input [9:0] pwm_low_count,
	output logic pwm_high,
	output logic pwm_low);
	
	always_comb begin
		if(pwm_count < 11'd45) begin
			pwm_high <= 1'b0;
			pwm_low <= 1'b0;
		end else if(pwm_count < (11'd45 + pwm_low_count)) begin
			pwm_high <= 1'b0;
			pwm_low <= 1'b1;
		end else if(pwm_count < (11'd90 + pwm_low_count)) begin
			pwm_high <= 1'b0;
			pwm_low <= 1'b0;
		end else begin
			pwm_high <= 1'b1;
			pwm_low <= 1'b0;
		end
	end
endmodule

/*
1024 cycles -> 4600ns (5k-2*200ns deadtime)
= 222.6 MHz Clock 4.49ns
200kHz PWM Frequency

ADC need at least 90 cycles (400ns) so high max 934 cycles
45 cycles for each dead time

1024+90 = 1114 total cycles.

0 - deadtime start
45 - low start
135 - first possible measurement
180 - last possible measurement
500 - mag_enc done
640 - adc done

*/	
