/*
 * File        : inverse_clarke.sv
 * Author      : Levi Johanon
 * Description : Transforms space voltage vector to line voltages
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module inverse_clarke(
	input clk,
	input reset,
	input [17:0] va,
	input [17:0] vb,
	output [17:0] v1, //Signed x.xx...
	output [17:0] v2,
	output [17:0] v3);
	
	localparam [17:0] two_root_three_three = 18'h1279a; //Signed x.xx...
	localparam [17:0] neg_root_three_three = 18'h36c33;
	localparam [17:0] one = 18'h10000;
	localparam [17:0] neg_one = 18'h30000;
	
	logic [35:0] v11_out;
	logic [35:0] v21_out;
	logic [35:0] v22_out;
	logic [35:0] v31_out;
	logic [35:0] v32_out;
	
	logic [35:0] v2_sum;
	logic [35:0] v3_sum;
	
	assign v2_sum = v21_out + v22_out;
	assign v3_sum = v31_out + v32_out;
	
	always_ff @(posedge clk or negedge reset) begin
		if(~reset) begin
			v1 <= 18'b0;
			v2 <= 18'b0;
			v3 <= 18'b0;
		end else begin
			v1 <= v11_out[34:17];
			v2 <= v2_sum[34:17];
			v3 <= v3_sum[34:17];
		end
	end
	
	
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(18),
		.lpm_widthp(36),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("INPUT_B_IS_CONSTANT=YES,DEDICATED_MULTIPLIER_CIRCUITRY=YES")) v11 (
		.dataa(va),
		.datab(two_root_three_three),
		.result(v11_out),
		.clock(clk),
		.aclr(~reset));
	
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(18),
		.lpm_widthp(36),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("INPUT_B_IS_CONSTANT=YES,DEDICATED_MULTIPLIER_CIRCUITRY=YES")) v21 (
		.dataa(va),
		.datab(neg_root_three_three),
		.result(v21_out),
		.clock(clk),
		.aclr(~reset));
	
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(18),
		.lpm_widthp(36),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("INPUT_B_IS_CONSTANT=YES,DEDICATED_MULTIPLIER_CIRCUITRY=YES")) v22 (
		.dataa(vb),
		.datab(one),
		.result(v22_out),
		.clock(clk),
		.aclr(~reset));
	
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(18),
		.lpm_widthp(36),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("INPUT_B_IS_CONSTANT=YES,DEDICATED_MULTIPLIER_CIRCUITRY=YES")) v31 (
		.dataa(va),
		.datab(neg_root_three_three),
		.result(v31_out),
		.clock(clk),
		.aclr(~reset));
		
	lpm_mult #(
		.lpm_widtha(18),
		.lpm_widthb(18),
		.lpm_widthp(36),
		.lpm_pipeline(1),
		.lpm_representation("SIGNED"),
		.lpm_hint("INPUT_B_IS_CONSTANT=YES,DEDICATED_MULTIPLIER_CIRCUITRY=YES")) v32 (
		.dataa(vb),
		.datab(neg_one),
		.result(v32_out),
		.clock(clk),
		.aclr(~reset));
		
endmodule
	
	
