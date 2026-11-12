/*
 * File        : adc_tb.sv
 * Author      : Levi Johanon
 * Description : Testbench for adc
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

`timescale 1ns / 10ps

module adc_tb();
	logic clk, reset;
	logic adc_start;
	logic sdo, adc_clk, cs;
	logic [13:0] adc_measurement;
	
	adc #(.CYCLES(5)) adc_1 (
		.clk(clk),
		.reset(reset),
		.start(adc_start),
		.sdo(sdo),
		.clk_out(adc_clk),
		.cs(cs),
		.adc(adc_measurement),
		.done());
		
	always #10 clk = ~clk;
	
	initial begin
		clk <= 1'b0;
		reset <= 1'b1;
		adc_start <= 1'b0;
		
		sdo <= 1'b1;
		
		@(posedge clk);
		reset <= 1'b0;
		@(posedge clk);
		reset <= 1'b1;
		@(posedge clk);
		#1 adc_start <= 1'b1;
		#5000;
		
		sdo <= 1'b0;
		
		adc_start <= 1'b0;
		@(posedge clk);
		#1 adc_start <= 1'b1;
		
		#5000;		
		$stop;		
	end
endmodule
