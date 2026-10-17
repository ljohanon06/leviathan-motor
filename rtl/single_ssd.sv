/*
 * File        : single_ssd.sv
 * Author      : Levi Johanon
 * Description : Auxilliary seven segment display encoder
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module single_ssd (
	input [3:0] in,
	output logic [0:6] ssd);
	
	always_comb
		case (in)
			4'b0000: ssd = 7'b1000000; //0
			4'b0001: ssd = 7'b1111001; //1
			4'b0010: ssd = 7'b0100100; //2
			4'b0011: ssd = 7'b0110000; //3
			4'b0100: ssd = 7'b0011001; //4
			4'b0101: ssd = 7'b0010010; //5
			4'b0110: ssd = 7'b0000010; //6
			4'b0111: ssd = 7'b1111000; //7
			4'b1000: ssd = 7'b0000000; //8
			4'b1001: ssd = 7'b0011000; //9
			4'b1010: ssd = 7'b0001000; //A
			4'b1011: ssd = 7'b0000011; //B
			4'b1100: ssd = 7'b0100111; //C
			4'b1101: ssd = 7'b0100001; //D
			4'b1110: ssd = 7'b0000110; //E
			4'b1111: ssd = 7'b0001110; //F
		endcase
endmodule
