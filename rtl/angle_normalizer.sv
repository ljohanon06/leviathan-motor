/*
 * File        : angle_normalizer.sv
 * Author      : Levi Johanon
 * Description : Normalizes magnetic encoder output to get quadrant and angle from x-axis
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module angle_normalizer (
	input [13:0] angle_in,
	output logic [11:0] norm_angle,
	output [1:0] quadrant);
	
	assign quadrant = angle_in[12:11];
	
	//First quadrant nothing 00
	//Second not, subtract msb 01
	//Third, subtract msb 10
	//Fourth, not 11
	
	//MSB of angle doesn't matter because 4 pole magnet, 2 elec rot for every 1 mech rot
	//Next 2 bits are quadrant, we eliminate those
	//cordic is currently 12 bits in, but hall only provides 11 usable so LSB = 0
	
	assign norm_angle[0] = 1'b0;
	always_comb begin
		if(quadrant[0])
			norm_angle[11:1] = ~angle_in[10:0];
		else norm_angle[11:1] = angle_in[10:0];
	end
endmodule
