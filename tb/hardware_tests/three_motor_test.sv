/*
 * File        : single_motor_test.sv
 * Author      : Levi Johanon
 * Description : Test for single_motor, no PI control
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
	output [5:0] pwm_out,
	input ft232_clk, //FT232H Direct Connections
	input txe,
	output [7:0] ft232_data,
	output wr,
	output [9:0] debug,
	output [6:0] ssd1, ssd2, ssd3, ssd4);
	assign debug = mag_reg[12:3];
	
	logic [3:0] clk_arr, reset_arr; //clk 50, 100, 222, 15	
	
	global_clock_reset gcr (
		.clk_50(clk[3]),
		.reset(reset)
		.clk_arr(clk_arr),
		.reset_arr(reset_arr));
	
	localparam MULT = 0;
	localparam HALF = 1;
	logic [31:0] cycle_count;	
	logic [MULT+10:0] pwm_count;
	logic [17:0] id, iq, vd, vq;
	logic vdq_ready, idq_ready;
	
	assign vd <= 18'b0;
	
	always_ff @(posedge clk_arr[2] or negedge reset_arr[2]) begin
		if(~reset_arr[2]) begin
			vq <= 18'b0;
		end else if(~on_switch) begin
			vq <= 18'b0;
		end else begin
			if(voltage == 3'b011)
				vq <= 18'h1BB60;
			else if(~voltage[2])
				vq <= {1'b0,voltage[1:0],15'b0};
			else vq <= {1'b1,~voltage[1:0],15'h7FFF};				
		end
	end
	
	
	logic sensor_done;
	logic [13:0] mag_reg, adc1_reg, adc2_reg;
	
	pwm_timing #(.MULT(MULT), .HALF(HALF)) pt (
		.clk_222(clk_arr[1]),
		.reset_222(reset_arr[1]),
		.enable(on_switch),
		.cycle_count(cycle_count),
		.pwm_a(pwm_count),
		.pwm_b(),
		.pwm_c());
		
	single_motor #(.MULT(MULT), .HALF(HALF)) sm1 (
		.clk_arr(clk_arr),
		.reset_arr(reset_arr),
		.enable(on_switch),
		.pwm_count(pwm_count),
		.vdq_ready(vdq_ready),
		.vd(vd),
		.vq(vq),
		.id(id),
		.iq(iq),
		.idq_ready(idq_ready),
		.pwm_out(pwm_out),
		.sdo1(sdo1),
		.sdo2(sdo2),
		.adc_clk1(adc_clk1),
		.adc_clk2(adc_clk2),
		.cs1(cs1),
		.cs2(cs2),
		.d_in(d_in),
		.mag_clk_out(mag_clk_out),
		.csn(csn),
		.mag_reg(mag_reg),
		.adc1_reg(adc1_reg),
		.adc2_reg(adc2_reg),
		.sensor_done(sensor_done));
		
	monitor #(.N(7)) mon (
		.clk(clk_arr[2]),
		.reset(reset_arr[2]),
		.data_input({cycle_count,2'b0,mag_reg,5'b0,voltage_reg}),
		.data_write(sensor_done && (cycle_count[2:0] == 3'b0)), //Write every 8 cycles
		.ft232_clk(ft232_clk),
		.txe(txe),
		.ft232_data(ft232_data),
		.wr(wr));
		
		
	logic [15:0] speed_hz;
	speedometer speed (
		.clk_100(clk_100),
		.reset(reset_100),
		.angle_reg(angle_reg[13:10]),
		.speed_hz(speed_hz));

	single_ssd s1 (
		.in(speed_hz[3:0]),
		.ssd(ssd1));
	
	single_ssd s2 (
		.in(speed_hz[7:4]),
		.ssd(ssd2));
	
	single_ssd s3 (
		.in(speed_hz[11:8]),
		.ssd(ssd3));
		
	single_ssd s4 (
		.in(speed_hz[15:12]),
		.ssd(ssd4));
endmodule
