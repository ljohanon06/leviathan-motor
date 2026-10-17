/*
 * File        : cordic_full.sv
 * Author      : Levi Johanon
 * Description : Cordic algorithm with normalized magnetic encoder input and sign-magnitude output
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module cordic_full (
	input clk,
	input reset,
	input valid, //Set high when input angle is valid
	input [13:0] angle_in,
	output logic [15:0] cos_mag,
	output cos_sign,
	output logic [15:0] sin_mag,
	output sin_sign,
	output done, //Set high after 12 clock cycles when angle is ready
	output ready); //Set high when not calculating
	
	logic [11:0] norm_angle;
	logic [1:0] quadrant;
	
	angle_normalizer an (
		.angle_in(angle_in),
		.norm_angle(norm_angle),
		.quadrant(quadrant));
		
	logic [17:0] raw_cos;
	logic [17:0] raw_sin;
	
	cordic cd (
		.clk(clk),
		.reset(reset),
		.valid(valid),
		.angle_in(norm_angle),
		.cos(raw_cos),
		.sin(raw_sin),
		.done(done),
		.ready(ready));
		
	logic cos_sign_error; //Only at magnitudes extrememly close to 90 or 0 degrees
	logic sin_sign_error; //Can the signs be negative
	
	logic [17:0] cos_out;
	logic [17:0] sin_out;
		
	two_to_sign #(.N(18)) c_ts (
		.two(raw_cos),
		.magnitude(cos_out),
		.sign(cos_sign_error));
	
	two_to_sign #(.N(18)) s_ts (
		.two(raw_sin),
		.magnitude(sin_out),
		.sign(sin_sign_error));
		
	always_comb begin
		if(cos_sign_error)
			cos_mag = 16'h0000;
		else cos_mag = cos_out[15:0];
		if(sin_sign_error)
			sin_mag = 16'h0000;
		else sin_mag = sin_out[15:0];
	end
		
	assign cos_sign = quadrant[0] ^ quadrant[1]; //Sign is 0 in quads 00 and 11
	assign sin_sign = quadrant[1] ; //Sign is 0 in quads 00 and 01
endmodule
		
		
	
	
	
	
