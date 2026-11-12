/*
 * File        : servo_driver_test.sv
 * Author      : Levi Johanon
 * Description : Hardware test for a servo driver
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module servo_driver_test(
	input clk_50,
	input reset,
	input center,
	input [9:0] sw,
	output rev_a, rev_b, rev_c,
	output pwm_a, pwm_b, pwm_c);
	
	logic [3:0] clk_arr, reset_arr; //clk 50, 100, 222, 15	
	
	logic [9:0] a, b, c;
	
	assign a = sw;
	assign b = sw;
	assign c = sw;
	
	global_clock_reset gcr (
		.clk_50(clk_50),
		.reset(reset),
		.clk_arr(clk_arr),
		.reset_arr(reset_arr));
	
	servo_driver #(
		.A_LOW(21'd0),
		.A_BIAS(9'd511),
		.A_COMP(8'd0)) sd (
		.clk_100(clk_arr[2]),
		.reset(reset_arr[2]),
		.center(center),
		.a(a),
		.b(b),
		.c(c),
		.pwm_a(pwm_a),
		.pwm_b(pwm_b),
		.pwm_c(pwm_c),
		.rev_a(rev_a),
		.rev_b(rev_b),
		.rev_c(rev_c));
	
endmodule
