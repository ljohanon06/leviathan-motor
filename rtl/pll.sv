/*
 * File        : pll.sv
 * Author      : Levi Johanon
 * Description : Altera pll instantiation for the pll used.
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

//A, B, C are set to 1 if clock is used
module pll #(
	parameter A = 1,
	parameter B = 1,
	parameter C = 1) (
	input reset,
	input clk_in,
	output logic c0,
	output logic c1,
	output logic c2);
	
	logic [4:0] clk_out;
	assign c0 = clk_out[0];
	assign c1 = clk_out[1];
	assign c2 = clk_out[2];
	
	altpll altpll_component (
		.areset(reset),
		.inclk({1'b0,clk_in}),
		.clk(clk_out));
	defparam
		altpll_component.clk0_divide_by = 99, 
		altpll_component.clk0_multiply_by = 200, 
		altpll_component.clk1_divide_by = 45, 
		altpll_component.clk1_multiply_by = 200, 
		altpll_component.clk2_divide_by = 648,
		altpll_component.clk2_multiply_by = 200, 
		altpll_component.compensate_clock = A == 1 ? "CLK0" : (B == 1 ? "CLK1" : "CLK2"),
		altpll_component.inclk0_input_frequency = 20000,
		altpll_component.intended_device_family = "MAX 10",
		altpll_component.operation_mode = "NORMAL",
		altpll_component.port_areset = "PORT_USED",
		altpll_component.port_inclk0 = "PORT_USED",
		altpll_component.port_clk0 = A == 1 ? "PORT_USED" : "PORT_UNUSED",
		altpll_component.port_clk1 = B == 1 ? "PORT_USED" : "PORT_UNUSED",
		altpll_component.port_clk2 = C == 1 ? "PORT_USED" : "PORT_UNUSED",
		altpll_component.port_clk3 = "PORT_UNUSED",
		altpll_component.port_clk4 = "PORT_UNUSED",
		altpll_component.width_clock = 5;
endmodule	
	
