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
	
	logic reset_50, reset_15;
	reset_sync r50 (
		.clk(clk_50),
		.reset(reset),
		.reset_sync(reset_50));
	
	//Generate Clock to interact with magnetic encoder
	logic clk_15;
	pll #(.A(0), .B(0)) pll_inst (
		.reset (~reset),
		.clk_in (clk_50),
		.c0(),
		.c1(),
		.c2 (clk_15));
	
	reset_sync r15 (
		.clk(clk_15),
		.reset(reset),
		.reset_sync(reset_15));
	
	//Handle CDC between clk_15 (magnetic encoder) and clk_50 (logic)
	logic me_done;
	logic [13:0] angle_out;
	logic [13:0] angle_reg, angle_reg2;
	logic me_reg1, me_reg2;
	always_ff @(posedge clk_50 or negedge reset_50) begin
		if(~reset_50) begin
			me_reg1 <= 1'b0;
			me_reg2 <= 1'b0;
			angle_reg <= 14'b0;
		end else begin
			me_reg1 <= me_done;
			me_reg2 <= me_reg1;
			if(me_reg2 & ~me_reg1) begin
				angle_reg <= angle_out;
			end	
		end
	end
	
	//Slowly clock data to seven segment displays
	logic [15:0] clk_count;
	logic clk_en;
	
	always_ff @(posedge clk_50 or negedge reset_50) begin
		if(~reset_50) begin
			clk_count <= 16'b0;
			clk_en <= 1'b0;
		end else begin 
			clk_count <= clk_count + 16'b1;
			if(clk_count == 16'hFFFF) clk_en <= 1'b1;
			else clk_en <= 1'b0;
		end
	end
	
	always_ff @(posedge clk_50 or negedge reset_50) begin
		if(~reset_50) 
			angle_reg2 <= 14'b0;
		else if(clk_en) 
			angle_reg2 <= angle_reg;
	end
	
	//Unchecked data from magnetic encoder
	logic [23:0] raw_data;
	assign mg = raw_data[9:6];
	
	//Module Instantiations
	magnetic_encoder #(.OFFSET(14'h0CF0)) me (
		.mag_clk(clk_15),
		.reset(reset_15),
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
		.in({2'b0,angle_reg2[13:12]}),
		.ssd(ssd4));
		
endmodule
	
	
