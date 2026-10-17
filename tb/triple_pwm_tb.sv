/*
 * File        : triple_pwm_tb.sv
 * Author      : Levi Johanon
 * Description : Basic testbench for triple_pwm.sv, works with Matlab_tests.m
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

`timescale 1ns / 1ps

module triple_pwm_tb ();

	logic pwm_clk;
	logic reset;
	logic enable;
	logic [17:0] v1;
	logic [17:0] v2;
	logic [17:0] v3;
	logic pwm_a_high;
	logic pwm_a_low;
	logic pwm_b_high;
	logic pwm_b_low;
	logic pwm_c_high;
	logic pwm_c_low;
	logic take_measurement_1;
	logic take_measurement_2;
	
	triple_pwm dut (
		.pwm_clk(pwm_clk),
		.reset(reset),
		.enable(enable),
		.v1(v1),
		.v2(v2),
		.v3(v3),
		.pwm_a_high(pwm_a_high),
		.pwm_a_low(pwm_a_low),
		.pwm_b_high(pwm_b_high),
		.pwm_b_low(pwm_b_low),
		.pwm_c_high(pwm_c_high),
		.pwm_c_low(pwm_c_low),
		.take_measurement_1(take_measurement_1),
		.take_measurement_2(take_measurement_2));
		
	always #2.246 pwm_clk = ~pwm_clk;
		
	initial begin
		$timeformat(-9,0," ns", 8);
		
		pwm_clk = 0;
		reset = 1;
		enable = 0;
		v1 = 18'd32768;
		v2 = 18'd13107;
		v3 = -18'd45876;
		
		#4.492 reset = 0;
		#4.492 reset = 1;
		enable = 1;
		#100 enable = 0;
		
		$display("A low: %d, A high: %d\n", dut.pwm_low_v1, dut.pwm_high_v1);
		$display("B low: %d, B high: %d\n", dut.pwm_low_v2, dut.pwm_high_v2);
		$display("C low: %d, C high: %d\n", dut.pwm_low_v3, dut.pwm_high_v3);
		
	end


endmodule
