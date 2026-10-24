/*
 * File        : motor_test.sv
 * Author      : Levi Johanon
 * Description : Test for single motor with monitoring, no PI control
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module motor_test(
	input on_switch,
	input [2:0] voltage,
	input clk_50,
	input reset,
	input sdo1, //ADC Inputs and Outputs
	input sdo2,
	output adc_clk1,
	output adc_clk2,
	output cs1,
	output cs2,
	input d_in, //Magnetic Encoder Inputs and Outputs
	output mag_clk_out,
	output csn,
	output pwm_a_high, //Gate Driver outputs
	output pwm_a_low,
	output pwm_b_high,
	output pwm_b_low,
	output pwm_c_high,
	output pwm_c_low,
	input ft232_clk, //FT232H Direct Connections
	input txe,
	output [7:0] ft232_data,
	output wr,
	output [9:0] debug);
	assign debug = angle_reg[12:3];
	
	logic clk_100;
	logic clk_222; //Gate Driver clock
	logic clk_15; //Magnetic encoder
	
	logic reset_50, reset_100, reset_222, reset_15;
	
	reset_sync r50 (
		.clk(clk_50),
		.reset(reset),
		.reset_sync(reset_50));
	
	//PLL
	pll pll_inst (
		.reset (~reset_50),
		.clk_in (clk_50),
		.c0 (clk_100),
		.c1 (clk_222),
		.c2 (clk_15)	);
	
	reset_sync r100 (
		.clk(clk_100),
		.reset(reset),
		.reset_sync(reset_100));
		
	reset_sync r222 (
		.clk(clk_222),
		.reset(reset),
		.reset_sync(reset_222));
	
	reset_sync r15 (
		.clk(clk_15),
		.reset(reset),
		.reset_sync(reset_15));
	
	//State Variables
	logic [10:0] pwm_count;
	logic [23:0] cycle_count;
	
	logic pwm_enable;
	logic mag_enable;
	logic data_write; //For monitor
	logic cycle_inc;
	
	//Logic within one clock cycle
	assign pwm_enable = pwm_count < 11'd100;
	assign mag_enable = 11'd10 < pwm_count && pwm_count < 11'd100;
	assign data_write = 11'd700 < pwm_count && pwm_count < 11'd750;
	
	//Timing Information
	always_ff @(posedge clk_222 or negedge reset_222) begin
		if(~reset_222) begin
			cycle_count <= 24'b0;
			vq <= 18'b0;
		end else if(~on_switch) begin
			cycle_count <= 24'b0;
			vq <= 18'b0;
		end else begin
			if(~voltage[2])
				vq <= {1'b0,voltage[1:0],15'b0};
			else vq <= {1'b1,~voltage[1:0],15'h7FFF};
			
			if (pwm_count == 10'd1020)
				cycle_count <= cycle_count + 24'b1;
			if(pwm_count >= 10'd1020) cycle_inc <= 1'b1;
			else cycle_inc <= 1'b0;					
		end
	end
	
	//Clock domain crossing for cycle count and data_write
	logic dw_1, dw_2, ci_1, ci_2;
	logic [23:0] cycle_reg;
	always_ff @(posedge clk_100 or negedge reset_100) begin
		if(~reset_100) begin
			dw_1 <= 1'b0;
			dw_2 <= 1'b0;
			ci_1 <= 1'b0;
			ci_2 <= 1'b0;
		end else begin
			dw_1 <= data_write;
			dw_2 <= dw_1;
			ci_1 <= cycle_inc;
			ci_2 <= ci_1;
			if(ci_2 & ~ci_1) cycle_reg <= cycle_count;
		end
	end
	
	
	//Variables holding sensor information
	logic adc_done_1;
	logic adc_done_2;
	logic [13:0] adc_measurement1;
	logic [13:0] adc_measurement2;
	logic [13:0] angle_reg;
	
	monitor #(.N(7)) mon (
		.clk(clk_100),
		.reset(reset_100),
		.data_input({8'b0,cycle_reg,2'b0,angle_reg,5'b0,voltage}),
		.data_write(dw_2),
		.ft232_clk(ft232_clk),
		.txe(txe),
		.ft232_data(ft232_data),
		.wr(wr));
	
	//Cordic
	logic [15:0] cos_mag;
	logic [15:0] sin_mag;
	logic cos_sign;
	logic sin_sign;
	logic cordic_done;
	
	cordic_full cd (
		.clk(clk_100),
		.reset(reset_100),
		.valid(me_done),
		.ready(),
		.angle_in(angle_reg),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.done(cordic_done));
	
	//Convert desired voltage to pwm voltages
	logic [17:0] vd;
	logic [17:0] vq;
	logic [17:0] v1;
	logic [17:0] v2;
	logic [17:0] v3;
	
	assign vd = 18'b0;

	inverse_transform it (
		.clk(clk_100),
		.reset(reset_100),
		.vd(vd),
		.vq(vq),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.v1(v1),
		.v2(v2),
		.v3(v3));
		
	//PWM Gate Driver
	triple_pwm tp (
		.pwm_clk(clk_222),
		.reset(reset_222),
		.enable(pwm_enable),
		.v1(v1),
		.v2(v2),
		.v3(v3),
		.pwm_a_high(pwm_a_high),
		.pwm_a_low(pwm_a_low),
		.pwm_b_high(pwm_b_high),
		.pwm_b_low(pwm_b_low),
		.pwm_c_high(pwm_c_high),
		.pwm_c_low(pwm_c_low),
		.take_measurement_1(adc_start_1),
		.take_measurement_2(adc_start_2),
		.pwm_count(pwm_count));
		
	//Sensor signals
	//ADCs are controller from triple_pwm take measurement
	//Magnetic Encoder constantly reads and clocks into register
	logic adc_start_1;
	logic adc_start_2;
	logic me_done;
	logic [13:0] angle_out;
	logic me_reg1, me_reg2;
	always_ff @(posedge clk_100 or negedge reset_100) begin
		if(~reset_100) begin
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
	
	adc adc_1 (
		.clk(clk_100),
		.reset(reset_100),
		.start(adc_start_1),
		.sdo(sdo1),
		.clk_out(adc_clk1),
		.cs(cs1),
		.adc(adc_measurement1),
		.done(adc_done_1));
		
	adc adc_2 (
		.clk(clk_100),
		.reset(reset_100),
		.start(adc_start_2),
		.sdo(sdo2),
		.clk_out(adc_clk2),
		.cs(cs2),
		.adc(adc_measurement2),
		.done(adc_done_2));
		
	magnetic_encoder me (
		.mag_clk(clk_15),
		.reset(reset_15),
		.d_in(d_in),
		.enable(mag_enable),
		.csn(csn),
		.clk_out(mag_clk_out),
		.done(me_done),
		.raw_data(),
		.angle_out(angle_out));

	
endmodule
