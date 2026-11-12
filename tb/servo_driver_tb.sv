/*
 * File        : servo_driver_tb.sv
 * Author      : Levi Johanon
 * Description : Testbench for servo_driver
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

`timescale 1ns / 10ps

module servo_driver_tb();
	logic clk, reset;
	logic pwm_a, pwm_b, pwm_c;
	logic rev_a, rev_b, rev_c;
	logic [9:0] a, b, c;
	
	servo_driver sd (
		.clk_100(clk),
		.reset(reset),
		.zero(1'b1),
		.a(a),
		.b(b),
		.c(c),
		.pwm_a(pwm_a),
		.pwm_b(pwm_b),
		.pwm_c(pwm_c),
		.rev_a(rev_a),
		.rev_b(rev_b),
		.rev_c(rev_c));
		
	always #4.95 clk = ~clk;
	
	initial begin
		clk <= 1'b0;
		reset <= 1'b1;
		a <= 10'b0;
		b <= 10'b0;
		c <= 10'b0;
		
		@(posedge clk);
		reset <= 1'b0;
		@(posedge clk);
		reset <= 1'b1;
		
		#40000000 //2*20ms
		
		a <= 10'd255;
		b <= 10'd255;
		c <= 10'd255;
		
		#40000000
		
		a <= 10'd128;
		b <= 10'd128;
		c <= 10'd128;
		
		#40000000
		
		$stop;		
	end
endmodule
