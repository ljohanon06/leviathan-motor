/*
 * File        : cordic_tb.sv
 * Author      : Levi Johanon
 * Description : Basic testbench for cordic_full.sv
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

`timescale 1ns / 1ps

module cordic_tb;

	logic clk;
	logic reset;
	logic valid;
	logic [13:0] angle_in;
	logic [15:0] cos_mag; 
	logic [15:0] sin_mag;
	logic cos_sign;
	logic sin_sign;
	logic done;
	logic ready;
	

	cordic_full dut (
		.clk(clk),
		.reset(reset),
		.valid(valid),
		.angle_in(angle_in),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.done(done),
		.ready(ready));
		
	always #5 clk = ~clk;
	
	initial begin
		$timeformat(-9,0," ns", 8);
	
		clk = 0;
		reset = 1;
		valid = 0;
		angle_in = 14'd0; //0 degrees
		
		#15 reset = 0;
		#15 reset = 1;
		$display("%0t Ready after reset: %b \n", $time, ready);
		
		for (int i = 0; i<360; i++) begin
			angle_in = 14'((i * 2 ** 13) / 360);
			valid = 1;
			#10
			valid = 0;
			#190
			$display("%0t Cos: %b %d, Sin: %b %d, Done: %b, Ready: %b\n", $time, cos_sign, cos_mag, sin_sign, sin_mag, done, ready);
		end
			
	end
endmodule
