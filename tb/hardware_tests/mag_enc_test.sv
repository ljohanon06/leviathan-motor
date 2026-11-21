/*
 * File        : mag_enc_test.sv
 * Author      : Levi Johanon
 * Description : Tests magnetic encoder by routing output to seven segment displays
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module mag_enc_test (
	input clk_50,
	input reset,
	input d_in, //Magnetic Encoder Inputs and Outputs
	output mag_clk_out,
	output csn,
	output [3:0] mg,
	output [6:0] ssd1, ssd2, ssd3, ssd4);
	
	logic [3:0] clk_arr, reset_arr; //clk 50, 100, 222, 15	
	global_clock_reset gcr (
		.clk_50(clk_50),
		.reset(reset),
		.clk_arr(clk_arr),
		.reset_arr(reset_arr));
	
	//Handle CDC between clk_15 (magnetic encoder) and clk_100 (logic)
	logic me_done;
	logic [13:0] angle_out;
	logic [13:0] angle_reg, angle_reg2;
	logic me_reg1, me_reg2;
	always_ff @(posedge clk_arr[2] or negedge reset_arr[2]) begin
		if(~reset_arr[2]) begin
			me_reg1 <= 1'b0;
			me_reg2 <= 1'b0;
			angle_reg <= 14'b0;
		end else begin
			me_reg1 <= me_done;
			me_reg2 <= me_reg1;
			if(me_reg2 & ~me_reg1) begin
				angle_reg <= angle_out;
			end	
		end
	end
	
	//Slowly clock data to seven segment displays
	logic [15:0] clk_count;
	logic clk_en;
	
	always_ff @(posedge clk_arr[2] or negedge reset_arr[2]) begin
		if(~reset_arr[2]) begin
			clk_count <= 16'b0;
			clk_en <= 1'b0;
		end else begin 
			clk_count <= clk_count + 16'b1;
			if(clk_count == 16'hFFFF) clk_en <= 1'b1;
			else clk_en <= 1'b0;
		end
	end
	
	always_ff @(posedge clk_arr[2] or negedge reset_arr[2]) begin
		if(~reset_arr[2]) 
			angle_reg2 <= 14'b0;
		else if(clk_en) 
			angle_reg2 <= angle_reg;
	end
	
	//Unchecked data from magnetic encoder
	logic [23:0] raw_data;
	assign mg = {raw_data[23:10] == angle_out, raw_data[9:7]};
	
	//Module Instantiations
	magnetic_encoder #(.OFFSET(14'h0CF0)) me (
		.mag_clk(clk_arr[0]),
		.reset(reset_arr[0]),
		.d_in(d_in),
		.enable(1'b1),
		.csn(csn),
		.clk_out(mag_clk_out),
		.done(me_done),
		.angle_out(angle_out),
		.raw_data(raw_data));
		
	logic [15:0] cos_mag, sin_mag;
	logic cos_sign, sin_sign, cordic_done;
		
	cordic_full cd (
		.clk(clk_arr[2]),
		.reset(reset_arr[2]),
		.valid(me_reg2), 
		.ready(), //Shows cordic module is ready, unused
		.angle_in(angle_reg), 
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.done(cordic_done));
		
	logic [17:0] v1, v2, v3;
		
	inverse_transform it (
		.clk(clk_arr[2]),
		.reset(reset_arr[2]),
		.vd(18'b0),
		.vq(18'h1BB60),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.v1(v1),
		.v2(v2),
		.v3(v3));
		
	logic [3:0] [3:0] hex;
	//assign hex = v2[15:0];
	assign hex = {raw_data[23:10] == angle_out,1'b0,angle_out};
		
	single_ssd s1 (
		.in(hex[0]),
		.ssd(ssd1));
	
	single_ssd s2 (
		.in(hex[1]),
		.ssd(ssd2));
	
	single_ssd s3 (
		.in(hex[2]),
		.ssd(ssd3));
		
	single_ssd s4 (
		.in(hex[3]),
		.ssd(ssd4));
		
endmodule
	
	
