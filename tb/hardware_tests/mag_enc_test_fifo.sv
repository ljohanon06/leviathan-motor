/*
 * File        : mag_enc_test_fifo.sv
 * Author      : Levi Johanon
 * Description : Tests magnetic encoder using ft232h and monitor module
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module mag_enc_test_fifo (
	input clk_50,
	input reset,
	input d_in, //Magnetic Encoder Inputs and Outputs
	output mag_clk_out,
	output csn,
	output [3:0] mg,
	input ft232_clk, //FT232H Direct Connections
	input txe,
	output [7:0] ft232_data,
	output wr);
	
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
	
	logic [23:0] raw_data;
	assign mg = raw_data[9:6];
	
	logic [11:0] clk_count;
	logic clk_en;
	
	always_ff @(posedge clk_50 or negedge reset_50) begin
		if(~reset_50) begin
			clk_count <= 12'b0;
			clk_en <= 1'b0;
		end else begin 
			clk_count <= clk_count + 8'b1;
			if(clk_count >= 12'hFF0) clk_en <= 1'b1;
			else clk_en <= 1'b0;
		end
	end
	
	magnetic_encoder me (
		.mag_clk(clk_15),
		.reset(reset_15),
		.d_in(d_in),
		.enable(1'b1),
		.csn(csn),
		.clk_out(mag_clk_out),
		.done(me_done),
		.angle_out(angle_out),
		.raw_data(raw_data));
		
	monitor #(.N(2)) mon (
		.clk(clk_50),
		.reset(reset_50),
		.data_input({2'b0,angle_reg}),
		.data_write(clk_en),
		.ft232_clk(ft232_clk),
		.txe(txe),
		.ft232_data(ft232_data),
		.wr(wr));	
		
endmodule
	
	
