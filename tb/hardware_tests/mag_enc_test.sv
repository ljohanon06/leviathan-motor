/*
 * File        : mag_enc_test.sv
 * Author      : Levi Johanon
 * Description : Tests magnetic encoder by routing output to seven segment displays
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module mag_enc_test (
	input clk_50,
	input reset,
	input d_in, //Magnetic Encoder Inputs and Outputs
	output mag_clk_out,
	output csn,
	output [3:0] mg,
	output [6:0] ssd1, ssd2, ssd3, ssd4);
	
	logic clk_15;
	
	pll pll_inst (
		.reset (~reset),
		.clk_in (clk_50),
		.c2 (clk_15));
	
	logic me_done;
	logic [13:0] angle_out;
	logic [13:0] angle_reg, angle_reg2;
	always_ff @(posedge me_done) angle_reg <= angle_out;
	
	logic [27:0] clk_ladder;
	
	always_ff @(posedge clk_15 or negedge reset) begin
		if(~reset)
			clk_ladder <= 28'b0;
		else clk_ladder <= clk_ladder + 28'b1;
	end
	
	always_ff @(posedge clk_ladder[10]) angle_reg2 <= angle_reg;
	
	logic [23:0] raw_data;
	assign mg = raw_data[9:6];
	
	magnetic_encoder me (
		.mag_clk(clk_ladder[0]),
		.reset(reset),
		.d_in(d_in),
		.enable(1'b1),
		.csn(csn),
		.clk_out(mag_clk_out),
		.done(me_done),
		.angle_out(angle_out),
		.raw_data(raw_data));
		
	single_ssd s1 (
		.in(angle_reg2[3:0]),
		.ssd(ssd1));
	
	single_ssd s2 (
		.in(angle_reg2[7:4]),
		.ssd(ssd2));
	
	single_ssd s3 (
		.in(angle_reg2[11:8]),
		.ssd(ssd3));
		
	single_ssd s4 (
		.in(angle_reg2[13:12]),
		.ssd(ssd4));
		
endmodule
	
	
