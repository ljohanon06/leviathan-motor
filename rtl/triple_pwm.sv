/*
 * File        : triple_pwm.sv
 * Author      : Levi Johanon
 * Description : Calculated pwm information from line voltages, uses single_pwm
 *		 Tells ADC when to take measurement
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module #(
	parameter MULT = 1,
	parameter HALF = 0) triple_pwm (
	input clk_222,  
	input reset_222,
	input v_valid,
	input enable, //Active High
	input [17:0] v1, //Signed x.xx..
	input [17:0] v2,
	input [17:0] v3,
	input [10+MULT:0] pwm_count,
	output [5:0] pwm_out, //[ah, al, bh, bl, ch, cl]
	output logic meas_1,
	output logic meas_2);
	
	logic [17:0] v1_reg;
	logic [17:0] v2_reg;
	logic [17:0] v3_reg;
	
	logic [10+MULT:0] pwm_high_v1;
	logic [10+MULT:0] pwm_low_v1;
	logic [10+MULT:0] pwm_high_v2;
	logic [10+MULT:0] pwm_low_v2;
	logic [10+MULT:0] pwm_high_v3;
	logic [10+MULT:0] pwm_low_v3;
	
	voltage_normalizer #(.MULT(MULT), .HALF(HALF)) nv1 (
		.v_in(v1_reg),
		.pwm_high(pwm_high_v1),
		.pwm_low(pwm_low_v1));
		
	voltage_normalizer #(.MULT(MULT), .HALF(HALF)) nv2 (
		.v_in(v2_reg),
		.pwm_high(pwm_high_v2),
		.pwm_low(pwm_low_v2));
		
	voltage_normalizer #(.MULT(MULT), .HALF(HALF)) nv3 (
		.v_in(v3_reg),
		.pwm_high(pwm_high_v3),
		.pwm_low(pwm_low_v3));
		
	single_pwm #(.MULT(MULT), .HALF(HALF)) sp1 (
		.pwm_count(pwm_count),
		.pwm_high_count(pwm_high_v1),
		.pwm_low_count(pwm_low_v1),
		.pwm_high(pwm_out[5]),
		.pwm_low(pwm_out[4]));
	
	single_pwm #(.MULT(MULT), .HALF(HALF)) sp2 (
		.pwm_count(pwm_count),
		.pwm_high_count(pwm_high_v2),
		.pwm_low_count(pwm_low_v2),
		.pwm_high(pwm_out[3]),
		.pwm_low(pwm_out[2]));
	
	single_pwm #(.MULT(MULT), .HALF(HALF)) sp3 (
		.pwm_count(pwm_count),
		.pwm_high_count(pwm_high_v3),
		.pwm_low_count(pwm_low_v3),
		.pwm_high(pwm_out[1]),
		.pwm_low(pwm_out[0]));
		
	logic enable_reg;
		
	always_ff @(posedge clk_222 or negedge reset_222) begin
		if(~reset_222) begin		//Reset Logic
			v1_reg <= 18'b0;
			v2_reg <= 18'b0;
			v3_reg <= 18'b0;
			enable_reg <= 1'b0;
		end
		else if(enable & ~enable_reg) begin
			v1_reg <= v1;
			v2_reg <= v2;
			v3_reg <= v3;
			enable_reg <= enable;
		end
	end
	
	//Measurements should be taken after at least 600ns of the low side being on
	//Voltage normalizer only guarentees 400ns of low side on
	adc_measurement	#(.MULT(MULT), .HALF(HALF)) am (
		.enable(enable),
		.pwm_count(pwm_count),
		.pwm_low_1(pwm_low_v1),
		.pwm_low_2(pwm_low_v2),
		.meas_1(meas_1),
		.meas_2(meas_2));
endmodule
