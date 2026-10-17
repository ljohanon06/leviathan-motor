/*
 * File        : inverse_transform.sv
 * Author      : Levi Johanon
 * Description : Transforms PI output voltage to line voltages, need external cordic angle
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module inverse_transform (
	input clk,
	input reset,
	input [17:0] vd, //Signed .b16b15...
	input [17:0] vq,
	input [15:0] cos_mag, //Unsigned 16 bit 
	input cos_sign,
	input [15:0] sin_mag,
	input sin_sign,
	output [17:0] v1, //Signed b16.b15b14...
	output [17:0] v2, 
	output [17:0] v3);
	
	//Internal signals
	logic [17:0] va; //Signed b16.b15b14...
	logic [17:0] vb;
	
	inverse_park ipt (
		.clk(clk),
		.reset(reset),
		.cos_mag(cos_mag),
		.cos_sign(cos_sign),
		.sin_mag(sin_mag),
		.sin_sign(sin_sign),
		.vd(vd),
		.vq(vq),
		.va(va),
		.vb(vb));
	
	inverse_clarke ict (
		.clk(clk),
		.reset(reset),
		.va(va),
		.vb(vb),
		.v1(v1),
		.v2(v2),
		.v3(v3));

endmodule
