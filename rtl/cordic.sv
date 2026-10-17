/*
 * File        : cordic.sv
 * Author      : Levi Johanon
 * Description : Main cordic logic, wrapped with cordic_full
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module cordic (
	input clk,
	input reset,
	input valid,
	input [11:0] angle_in, //Normalized to first quadrant
	output logic signed [17:0] cos, //x
	output logic signed [17:0] sin, //y
	output logic done,
	output ready);
	
	typedef enum logic [3:0] {
		s0, s1, s2, s3, s4, s5,
		s6, s7, s8, s9, s10, s11, idle} cordic_state_t;
	
	localparam [0:11] [11:0] tan = {12'd2048, 12'd1209, 12'd639, 12'd324,
		12'd163,  12'd81,   12'd41,  12'd20,
		12'd10,   12'd5,    12'd3,   12'd1};
	
	cordic_state_t state;
	
	assign ready = state == idle;
	
	logic [12:0] angle_ref; //IN_BITS + 1 for signed
	
	always_ff @(posedge clk or negedge reset) begin
		if(~reset) begin
			cos <= 18'h09b75; //Values are fixed point 2.16 bits 9b75
			sin <= 18'b0;		//Initial value is product from 0 to 11 of cos(atan(2^-i))
			done <= 1'b0;
			state <= idle;
		end
		else begin
			if(state == idle && valid) begin
				cos <= 18'h09b75;
				sin <= 18'b0;
				done <= 1'b0;
				angle_ref <= angle_in; 
				state <= s0;
			end
			else if (state != idle) begin
				if(~angle_ref[12]) begin
					cos <= cos - (sin >>> state); //>>> is used instead of >> to fill in with msb
					sin <= (cos >>> state) + sin;
					angle_ref <= angle_ref - tan[state];
				end else begin
					cos <= cos + (sin >>> state);
					sin <= sin - (cos >>> state);
					angle_ref <= angle_ref + tan[state];
				end
				if(state == s11) begin
					state <= idle;
					done <= 1'b1;
				end
				else
					state <= cordic_state_t'(state + 4'b1);
			end
		end
	end	
endmodule
