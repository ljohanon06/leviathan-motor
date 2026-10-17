/*
 * File        : inverse_park.sv
 * Author      : Levi Johanon
 * Description : Transforms direct and quadrature voltage to space vector voltage
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module inverse_park(
	input clk,
	input reset,
	input [15:0] cos_mag, //Unsigned 16bit
	input cos_sign,
	input [15:0] sin_mag,
	input sin_sign,
	input [17:0] vd, //Signed .xxxx... 
	input [17:0] vq,
	output [17:0] va, //Signed .xxx...
	output [17:0] vb);
	
	logic [34:0] va1_out;
	logic [34:0] va2_out;
	logic [34:0] vb1_out;
	logic [34:0] vb2_out;
	
	logic [34:0] va_sum;
	logic [34:0] vb_sum;
	
	assign va_sum = (cos_sign ? -va1_out : va1_out) + (sin_sign ? va2_out : -va2_out);
	assign vb_sum = (sin_sign ? -vb1_out : vb1_out) + (cos_sign ? -vb2_out : vb2_out);
	
	assign va = va_sum[33:16];
	assign vb = vb_sum[33:16];
	
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(17),
		.lpm_widthp(35),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("DEDICATED_MULTIPLIER_CIRCUITRY=YES")) va1 (
		.dataa(vd),
		.datab({1'b0,cos_mag}),
		.result(va1_out),
		.clock(clk),
		.aclr(~reset));
		
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(17),
		.lpm_widthp(35),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("DEDICATED_MULTIPLIER_CIRCUITRY=YES")) va2 (
		.dataa(vq),
		.datab({1'b0,sin_mag}),
		.result(va2_out),
		.clock(clk),
		.aclr(~reset));
		
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(17),
		.lpm_widthp(35),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("DEDICATED_MULTIPLIER_CIRCUITRY=YES")) vb1 (
		.dataa(vd),
		.datab({1'b0,sin_mag}),
		.result(vb1_out),
		.clock(clk),
		.aclr(~reset));
		
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(17),
		.lpm_widthp(35),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("DEDICATED_MULTIPLIER_CIRCUITRY=YES")) dvb2 (
		.dataa(vq),
		.datab({1'b0,cos_mag}),
		.result(vb2_out),
		.clock(clk),
		.aclr(~reset));
		
endmodule
