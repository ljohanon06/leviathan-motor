/*
 * File        : inverse_transform_tb.sv
 * Author      : Levi Johanon
 * Description : Basic testbench for inverse_transform.sv, works with Matlab_tests.m
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

`timescale 1ns / 1ps

module inverse_transform_tb();

	logic clk;
	logic reset;
	logic [17:0] vd;
	logic [17:0] vq;
	logic [15:0] cos_mag;
	logic [15:0] sin_mag;
	logic cos_sign;
	logic sin_sign;
	logic [17:0] v1;
	logic [17:0] v2;
	logic [17:0] v3;

	logic [13:0] angle_in;
	logic valid;
	logic done;
	logic ready;

	cordic_full cd (
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
		
	inverse_transform dut (
		.clk(clk),
		.reset(reset),
		.vd(vd),
		.vq(vq),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.v1(v1),
		.v2(v2),
		.v3(v3));
		
	always #5 clk = ~clk;
	
	initial begin
		$timeformat(-9,0," ns", 8);
		
		clk = 0;
		reset = 1;
		valid = 0;
		vd = 18'd19660;
		vq = -18'd32768;
		angle_in = 14'd2116;
		
		#10 reset = 0;
		#10 reset = 1;
		valid = 1;
		#10 valid = 0;
		
		#200
		$display("%d %d %d", $signed(v1), $signed(v2), $signed(v3));		
	end

endmodule
