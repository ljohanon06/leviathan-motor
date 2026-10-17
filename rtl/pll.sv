/*
 * File        : pll.sv
 * Author      : Levi Johanon
 * Description : Altera pll instantiation for the pll used.
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module pll (
	input reset,
	input clk_in,
	output c0,
	output c1,
	output c2);
	
	altpll altpll_inst (
		.areset(areset),
		.inclk(clk_in),
		.clk({c2,c1,c0}));
	defparam
		altpll_component.bandwidth_type = "AUTO",
		altpll_component.clk0_divide_by = 99, 
		altpll_component.clk0_multiply_by = 200, 
		altpll_component.clk1_divide_by = 45, 
		altpll_component.clk1_multiply_by = 200, 
		altpll_component.clk2_divide_by = 648,
		altpll_component.clk2_multiply_by = 200, 
		altpll_component.compensate_clock = "CLK0",
		altpll_component.inclk0_input_frequency = 20000,
		altpll_component.intended_device_family = "MAX 10",
		altpll_component.lpm_hint = "CBX_MODULE_PREFIX=pll",
		altpll_component.lpm_type = "altpll",
		altpll_component.operation_mode = "NORMAL",
		altpll_component.pll_type = "AUTO",
		altpll_component.port_areset = "PORT_USED",
		altpll_component.port_inclk0 = "PORT_USED",
		altpll_component.port_locked = "PORT_USED",
		altpll_component.port_clk0 = "PORT_USED",
		altpll_component.port_clk1 = "PORT_USED",
		altpll_component.port_clk2 = "PORT_USED",
		altpll_component.self_reset_on_loss_lock = "OFF",
		altpll_component.width_clock = 3;
endmodule	
	
