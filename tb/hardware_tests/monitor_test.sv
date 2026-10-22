/*
 * File        : monitor_test.sv
 * Author      : Levi Johanon
 * Description : Tests monitor module with ft232h using counting clock ladder
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module monitor_test (
	input clk_50,
	input reset,
	input ft232_clk, //FT232H Direct Connections
	input txe,
	output [7:0] ft232_data,
	output wr);
	
	logic reset_50;
	reset_sync r50 (
		.clk(clk_50),
		.reset(reset),
		.reset_sync(reset_50));
	
	logic [31:0] clk_count;
	logic clk_en;
	
	always_ff @(posedge clk_50 or negedge reset_50) begin
		if(~reset_50) begin
			clk_count <= 32'b0;
			clk_en <= 1'b0;
		end else begin 
			clk_count <= clk_count + 32'b1;
			if(clk_count[11:0] >= 12'hFF0) clk_en <= 1'b1;
			else clk_en <= 1'b0;
		end
	end
		
	monitor #(.N(4)) mon (
		.clk(clk_50),
		.reset(reset_50),
		.data_input(clk_count),
		.data_write(clk_en),
		.ft232_clk(ft232_clk),
		.txe(txe),
		.ft232_data(ft232_data),
		.wr(wr));	
		
endmodule
	
	
