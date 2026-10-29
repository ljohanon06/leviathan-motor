/*
 * File        : adc_test.sv
 * Author      : Levi Johanon
 * Description : Test the analog to digital converter
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module adc_test(
	input clk_50,
	input reset,
	input sdo, 
	output adc_clk,
	output cs,
	output [6:0] ssd1, ssd2, ssd3, ssd4);
	
	logic [13:0] adc_measurement, adc_reg;
	logic adc_start;
	logic [10:0] count;
	logic clk_100, reset_50, reset_100;
	
	always_ff @(posedge clk_100 or negedge reset_100) begin
		if(~reset_100) begin
			adc_reg <= 14'b0;
			adc_start <= 1'b0;
			count <= 11'b0;
		end else begin
			count <= count + 11'b1;
			if(count >= 11'd600 && count <= 11'd610)
				adc_start <= 1'b1;
			else adc_start <= 1'b0;
			
			if(count == 11'h7FF)
				adc_reg <= adc_measurement;
		end
	end
	
	reset_sync r50 (
		.clk(clk_50),
		.reset(reset),
		.reset_sync(reset_50));
		
	pll #(.B(0), .C(0)) pll_inst (
		.reset (~reset_50),
		.clk_in (clk_50),
		.c0 (clk_100),
		.c1 (),
		.c2 ());
	
	reset_sync r100 (
		.clk(clk_100),
		.reset(reset),
		.reset_sync(reset_100));
		
	adc adc_1 (
		.clk(clk_100),
		.reset(reset_100),
		.start(adc_start),
		.sdo(sdo),
		.clk_out(adc_clk),
		.cs(cs),
		.adc(adc_measurement),
		.done());
		
	single_ssd s1 (
		.in(adc_reg[3:0]),
		.ssd(ssd1));
	
	single_ssd s2 (
		.in(adc_reg[7:4]),
		.ssd(ssd2));
	
	single_ssd s3 (
		.in(adc_reg[11:8]),
		.ssd(ssd3));
		
	single_ssd s4 (
		.in({2'b0,adc_reg[13:12]}),
		.ssd(ssd4));
endmodule
