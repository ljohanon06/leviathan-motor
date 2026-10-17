/*
 * File        : park_transform.sv
 * Author      : Levi Johanon
 * Description : Transforms space current vector to direct and quadrature current
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module park_transform (
	input clk,
	input reset,
	input [15:0] cos_mag, //Unsigned 16bit
	input cos_sign,
	input [15:0] sin_mag,
	input sin_sign,
	input [17:0] ia, //Signed b16.b15b14...
	input [17:0] ib,
	output [17:0] id,
	output [17:0] iq);
	
	logic [34:0] dq11_out;
	logic [34:0] dq12_out;
	logic [34:0] dq21_out;
	logic [34:0] dq22_out;
	
	logic [34:0] id_sum;
	logic [34:0] iq_sum;
	
	assign id_sum = (cos_sign ? -dq11_out : dq11_out) + (sin_sign ? -dq12_out : dq12_out);
	assign iq_sum = (sin_sign ? dq21_out : -dq21_out) + (cos_sign ? -dq22_out : dq22_out);
	
	assign id = id_sum[33:16];
	assign iq = iq_sum[33:16];
	
/*
i11 sign = cos
i12 sign = sin
i21 sign = -sin
i22 sign = cos
*/
	
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(17),
		.lpm_widthp(35),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("DEDICATED_MULTIPLIER_CIRCUITRY=YES")) dq11 (
		.dataa(ia),
		.datab({1'b0,cos_mag}),
		.result(dq11_out),
		.clock(clk),
		.aclr(~reset));
		
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(17),
		.lpm_widthp(35),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("DEDICATED_MULTIPLIER_CIRCUITRY=YES")) dq12 (
		.dataa(ib),
		.datab({1'b0,sin_mag}),
		.result(dq12_out),
		.clock(clk),
		.aclr(~reset));
		
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(17),
		.lpm_widthp(35),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("DEDICATED_MULTIPLIER_CIRCUITRY=YES")) dq21 (
		.dataa(ia),
		.datab({1'b0,sin_mag}),
		.result(dq21_out),
		.clock(clk),
		.aclr(~reset));
		
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(17),
		.lpm_widthp(35),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("DEDICATED_MULTIPLIER_CIRCUITRY=YES")) dq22 (
		.dataa(ib),
		.datab({1'b0,cos_mag}),
		.result(dq22_out),
		.clock(clk),
		.aclr(~reset));
endmodule
