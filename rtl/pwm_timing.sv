/*
 * File        : pwm_timing.sv
 * Author      : Levi Johanon
 * Description : Handles the offset pwm timing and output pwm_count for everything
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module #(
	parameter MULT = 1,
	parameter HALF = 0) pwm_timing (
	input clk_222,
	input reset_222,
	input enable,
	output logic [31:0] cycle_count,
	output logic [MULT+10:0] pwm_a, pwm_b, pwm_c);
	
	localparam MAX = 90 - 1 + (1024 + (HALF ? 511 : 0)) << MULT; //90 cycles for deadtime
	localparam B_RE = MAX / 3;
	localparam C_RE = 2 * MAX / 3;
	
	logic b_on, c_on;
	
	always_ff @(posedge clk_222 or negedge reset_222) begin
		if(~reset) begin
			cycle_count <= 32'b0;
			pwm_a <= 'b0;
			pwm_b <= 'b0;
			pwm_c <= 'b0;
			b_on <= 1'b0;
			c_on <= 1'b0;
		end else if(enable) begin
			pwm_a <= pwm_a + 1'b1;
			if(b_on)
				pwm_b <= pwm_b + 1'b1;
			if(c_on)
				pwm_c <= pwm_c + 1'b1;
				
			if(pwm_a == MAX) begin
				cycle_count <= cycle_count + 32'b1;
				pwm_a <= 'b0;
			end
			if(pwm_b == MAX)
				pwm_b <= 'b0;
			if(pwm_c == MAX)
				pwm_c <= 'b0;
			
			//On reset, B and C should release offset to A
			if(pwm_a == B_RE)
				b_on <= 1'b1;
			if(pwm_a == C_RE)
				c_on <= 1'b1;	
	end
endmodule
/*
Requirements: Handle all three motors to have seperate ADCs
Parameterized for different PWM frequencies.

MULT: Multiplier on the original 5000ns period
new period = 5000*2^m

HALF: Adds a half shift factor
5000 -> 7500, 10000 -> 15000
*/
