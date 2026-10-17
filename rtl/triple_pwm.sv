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

module triple_pwm (
	input pwm_clk,  
	input reset,
	input enable, //Active High
	input [17:0] v1, //Signed x.xx..
	input [17:0] v2,
	input [17:0] v3,
	output pwm_a_high,
	output pwm_a_low,
	output pwm_b_high,
	output pwm_b_low,
	output pwm_c_high,
	output pwm_c_low,
	output logic take_measurement_1,
	output logic take_measurement_2,
	output logic [10:0] pwm_count);
	
	logic [17:0] v1_reg;
	logic [17:0] v2_reg;
	logic [17:0] v3_reg;
	logic enable_reg;
	
	logic [9:0] pwm_high_v1;
	logic [9:0] pwm_low_v1;
	logic [9:0] pwm_high_v2;
	logic [9:0] pwm_low_v2;
	logic [9:0] pwm_high_v3;
	logic [9:0] pwm_low_v3;
	
	assign pwm_low_v1 = 10'd1023 - pwm_high_v1;
	assign pwm_low_v2 = 10'd1023 - pwm_high_v2;
	assign pwm_low_v3 = 10'd1023 - pwm_high_v3;
	
	voltage_normalizer nv1 (
		.v_in(v1_reg),
		.pwm_high(pwm_high_v1));
		
	voltage_normalizer nv2 (
		.v_in(v2_reg),
		.pwm_high(pwm_high_v2));
		
	voltage_normalizer nv3 (
		.v_in(v3_reg),
		.pwm_high(pwm_high_v3));
		
	single_pwm sp1 (
		.pwm_count(pwm_count),
		.pwm_high_count(pwm_high_v1),
		.pwm_low_count(pwm_low_v1),
		.pwm_high(pwm_a_high),
		.pwm_low(pwm_a_low));
	
	single_pwm sp2 (
		.pwm_count(pwm_count),
		.pwm_high_count(pwm_high_v2),
		.pwm_low_count(pwm_low_v2),
		.pwm_high(pwm_b_high),
		.pwm_low(pwm_b_low));
	
	single_pwm sp3 (
		.pwm_count(pwm_count),
		.pwm_high_count(pwm_high_v3),
		.pwm_low_count(pwm_low_v3),
		.pwm_high(pwm_c_high),
		.pwm_low(pwm_c_low));
		
	always_ff @(posedge pwm_clk or negedge reset) begin
		if(~reset) begin		//Reset Logic
			v1_reg <= 18'b0;
			v2_reg <= 18'b0;
			v3_reg <= 18'b0;
			enable_reg <= 1'b0;
			pwm_count <= 1'b0;
		end
		else begin
			if(enable & ~enable_reg) begin //Enable signal recieved
				enable_reg <= 1'b1;
				v1_reg <= v1;
				v2_reg <= v2;
				v3_reg <= v3;
			end
			if(enable_reg) begin //Main Logic
				if(pwm_count == 11'd1114) begin
					enable_reg <= 1'b0;
					pwm_count <= 1'b0;
				end else pwm_count <= pwm_count + 11'b1;
			end
		end
	end
	
	//Measurements should be taken after at least 600ns of the low side being on
	//Voltage normalizer only guarentees 400ns of low side on
	always_comb begin
		if(pwm_low_v1 > 10'd138)
			take_measurement_1 = (pwm_count > (10'd45+10'd135)) & enable_reg;
		else take_measurement_1 = (pwm_count > (10'd45+10'd90)) & enable_reg;
		
		if(pwm_low_v2 > 10'd138)
			take_measurement_2 = (pwm_count > (10'd45+10'd135)) & enable_reg;
		else take_measurement_2 = (pwm_count > (10'd45+10'd90)) & enable_reg;
	end		
endmodule
