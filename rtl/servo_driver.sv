/*
 * File        : servo_driver.sv
 * Author      : Levi Johanon
 * Description : Drives all three servos
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

//red, blue, black
module servo_driver #(
	parameter logic [20:0] A_LOW = 21'd33215, B_LOW = 21'd30660, C_LOW = 21'd38325,
	parameter logic [8:0] A_BIAS = 9'd273, B_BIAS = 9'd275, C_BIAS = 9'd405,
	parameter logic [7:0] A_COMP = 8'd169, B_COMP = 8'd169, C_COMP = 8'd33)(
	input clk_100,
	input reset,
	input [9:0] a, b, c, //Angle from 0 to 360 degrees
	input zero, //Active low, used for testing
	output logic pwm_a, pwm_b, pwm_c,
	output logic rev_a, rev_b, rev_c); //High if motor needs to be reversed (180-360 degrees).
	
	assign rev_a = a[9];
	assign rev_b = b[9];
	assign rev_c = c[9];
	
	logic [20:0] pwm_count;
	logic [20:0] a_count, b_count, c_count;
	
	//Avoids the issue that countones isn't available for synthesis
	logic [2:0] a1, b1, c1;
	logic [2:0] a2, b2, c2;
	countones #(.W1(8),.W2(3)) a1_co (.in(A_COMP), .ones(a1));
	countones #(.W1(8),.W2(3)) b1_co (.in(B_COMP), .ones(b1));
	countones #(.W1(8),.W2(3)) c1_co (.in(C_COMP), .ones(c1));
	countones #(.W1(8),.W2(3)) a2_co (.in(A_COMP & (8'hFF >> (3'd7 - a[2:0]))), .ones(a2));
	countones #(.W1(8),.W2(3)) b2_co (.in(B_COMP & (8'hFF >> (3'd7 - b[2:0]))), .ones(b2));
	countones #(.W1(8),.W2(3)) c2_co (.in(C_COMP & (8'hFF >> (3'd7 - c[2:0]))), .ones(c2));
	
	always_comb begin
		if(zero) begin
			a_count = 21'(a[8:0] * A_BIAS + a[8:3] * a1 + a2);
			b_count = 21'(b[8:0] * B_BIAS + b[8:3] * b1 + b2);
			c_count = 21'(c[8:0] * C_BIAS + c[8:3] * c1 + c2);
		end else begin
			a_count = 21'b0;
			b_count = 21'b0;
			c_count = 21'b0;
		end
	end
	
	always_ff @(posedge clk_100 or negedge reset) begin
		if(~reset) begin
			pwm_a <= 1'b0;
			pwm_b <= 1'b0;
			pwm_c <= 1'b0;
			pwm_count <= 21'b0;
		end else begin
			if(pwm_count == 21'h1ED36A) //20 milliseconds
				pwm_count <= 21'b0;
			else
				pwm_count <= pwm_count + 1'b1;
			
			if(pwm_count < A_LOW + a_count)
				pwm_a <= 1'b1;
			else pwm_a <= 1'b0;
			
			if(pwm_count < B_LOW + b_count)
				pwm_b <= 1'b1;
			else pwm_b <= 1'b0;
			
			if(pwm_count < C_LOW + c_count)
				pwm_c <= 1'b1;
			else pwm_c <= 1'b0;
		end
	end
endmodule
//Red 3C-

/*
Timing:
50Hz = 20ms
20ms at 101.01MHz = 2020202 clock cycles
2020202 = 0x1ED36A = 21 bits

0.5 to 2.5 ms range

*/
/*
For reverse:
Ignore MSB of angle
Set reverse to MSB of angle

Example, 200 = 20 in reverse
*/	
