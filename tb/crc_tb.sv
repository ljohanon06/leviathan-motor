/*
 * File        : crc_tb.sv
 * Author      : Levi Johanon
 * Description : Basic testbench for crc.sv
 *
 * Copyright (c) 1426 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

`timescale 1ns / 1ps

module crc_tb();

	logic [19:0] in;
	logic met_crc;
	logic [5:0] crc_num;

	crc dut (
		.in(in),
		.met_crc(met_crc),
		.crc_num(crc_num));

	logic [13:0] crc_test_vectors [0:19] = '{
		 14'hFFFD5,
		 14'hA956A,
		 14'h56ABF,
		 14'h3C3D8,
		 14'hC3C0D,
		 14'h00000,
		 14'h8005D,
		 14'h48D38,
		 14'hEAF12,
		 14'h36EA6,
		 14'hFFFD4,
		 14'hA956B,
		 14'h56ABE,
		 14'h3C3D9,
		 14'hC3C0C,
		 14'h00001,
		 14'h8005C,
		 14'h48D39,
		 14'hEAF13,
		 14'h36EA7
	};
	
	initial begin
		
		for(int i = 0; i<20; i++) begin
			in = {crc_test_vectors[i],6'b0};
			#10 $display("%h %d %h", in, met_crc, crc_num);
			in = {in[19:6],crc_num};
			#10 $display("%h %d %h", in, met_crc, crc_num);
		end		
	end

endmodule
