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
	
	logic clk_15;
	
	pll pll_inst (
		.areset (~reset),
		.inclk0 (clk_50),
		.c2 (clk_15));
	
	logic me_done;
	logic [13:0] angle_out;
	logic [13:0] angle_reg;
	always_ff @(posedge me_done) angle_reg <= angle_out;
	
	logic [27:0] clk_ladder;
	
	always_ff @(posedge clk_15 or negedge reset) begin
		if(~reset)
			clk_ladder <= 28'b0;
		else clk_ladder <= clk_ladder + 28'b1;
	end
	
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
		
	monitor #(.N(2)) mon (
		.clk(clk_50),
		.reset(reset),
		.data_input({2'b0,angle_reg}),
		.data_write(me_done),
		.ft232_clk(ft232_clk),
		.txe(txe),
		.ft232_data(ft232_data),
		.wr(wr));	
		
endmodule
	
	
