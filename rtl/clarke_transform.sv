/*
 * File        : clarke_transform.sv
 * Author      : Levi Johanon
 * Description : Transforms line currents into space vector current
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module clarke_transform (
	input clk,
	input reset,
	input [14:0] i1,
	input [14:0] i2,
	input [14:0] i3,
	output [17:0] ia,
	output [17:0] ib);
	
	localparam [17:0] root_three_three = 18'h1279a;
	localparam [17:0] neg_root_three_six = 18'h36c33;
	localparam [17:0] one_half = 18'h10000;
	localparam [17:0] neg_one_half = 18'h30000;
	
	
	logic [32:0] i11_out;
	logic [32:0] i12_out;
	logic [32:0] i13_out;
	logic [32:0] i22_out;
	logic [32:0] i23_out;
	
	logic [32:0] ia_sum;
	logic [32:0] ib_sum;
	
	assign ia_sum = i11_out + i12_out + i13_out;
	assign ib_sum = i22_out + i23_out;
	
	assign ia = ia_sum[31:14];
	assign ib = ib_sum[31:14];
	
	lpm_mult #(
		.lpm_widtha(15),
		.lpm_widthb(18),
		.lpm_widthp(33),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("INPUT_B_IS_CONSTANT=YES,DEDICATED_MULTIPLIER_CIRCUITRY=YES")) i11 (
		.dataa(i1),
		.datab(root_three_three),
		.result(i11_out),
		.clock(clk),
		.aclr(~reset));
		
	lpm_mult #(
		.lpm_widtha(15),
		.lpm_widthb(18),
		.lpm_widthp(33),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("INPUT_B_IS_CONSTANT=YES,DEDICATED_MULTIPLIER_CIRCUITRY=YES")) i12 (
		.dataa(i2),
		.datab(neg_root_three_six),
		.result(i12_out),
		.clock(clk),
		.aclr(~reset));
		
	lpm_mult #(
		.lpm_widtha(15),
		.lpm_widthb(18),
		.lpm_widthp(33),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("INPUT_B_IS_CONSTANT=YES,DEDICATED_MULTIPLIER_CIRCUITRY=YES")) i13 (
		.dataa(i3),
		.datab(neg_root_three_six),
		.result(i13_out),
		.clock(clk),
		.aclr(~reset));
		
	lpm_mult #(
		.lpm_widtha(15),
		.lpm_widthb(18),
		.lpm_widthp(33),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("INPUT_B_IS_CONSTANT=YES,DEDICATED_MULTIPLIER_CIRCUITRY=YES")) i22 (
		.dataa(i2),
		.datab(one_half),
		.result(i22_out),
		.clock(clk),
		.aclr(~reset));
		
	lpm_mult #(
		.lpm_widtha(15),
		.lpm_widthb(18),
		.lpm_widthp(33),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("INPUT_B_IS_CONSTANT=YES,DEDICATED_MULTIPLIER_CIRCUITRY=YES")) i23 (
		.dataa(i3),
		.datab(neg_one_half),
		.result(i23_out),
		.clock(clk),
		.aclr(~reset));
endmodule
