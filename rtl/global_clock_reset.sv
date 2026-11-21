/*
 * File        : global_clock_reset.sv
 * Author      : Levi Johanon
 * Description : Generates all clocks and synchronized reset signals
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module global_clock_reset(
	input clk_50, reset,
	output [3:0] clk_arr,
	output [3:0] reset_arr);
	
	assign clk_arr[3] = clk_50;
	
	reset_sync r50 (
		.clk(clk_50),
		.reset(reset),
		.reset_sync(reset_arr[3]));

	pll pll_inst (
		.reset (~reset_arr[3]), //Reset is asynchronous
		.clk_in (clk_50),
		.c0 (clk_arr[2]),
		.c1 (clk_arr[1]),
		.c2 (clk_arr[0])	);
	
	reset_sync r100 (
		.clk(clk_arr[2]),
		.reset(reset),
		.reset_sync(reset_arr[2]));
		
	reset_sync r222 (
		.clk(clk_arr[1]),
		.reset(reset),
		.reset_sync(reset_arr[1]));
	
	reset_sync r15 (
		.clk(clk_arr[0]),
		.reset(reset),
		.reset_sync(reset_arr[0]));
endmodule
