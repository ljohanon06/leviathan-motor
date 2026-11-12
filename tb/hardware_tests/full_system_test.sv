/*
 * File        : full_system_test.sv
 * Author      : Levi Johanon
 * Description : Testbench for the entire system
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module full_system_test(
	input on_switch,
	input [2:0] voltage,
	input [3:0] servo_control,
	input clk_50,
	input reset,
	input sdo1, //ADC Inputs and Outputs
	input sdo2,
	output adc_clk1,
	output adc_clk2,
	output logic [5:0] cs, //a1, a2, b1, b2, c1, c2
	input d_in, //Magnetic Encoder Inputs and Outputs
	output mag_clk_out,
	output logic [2:0] csn, //a, b, c
	output [5:0] pwm_out_a, //Gate Driver Outputs
	output [5:0] pwm_out_b,
	output [5:0] pwm_out_c,
	output [2:0] servo_pwm, //a, b, c
	input rx, //Uart Wrapper inputs and outputs
	output tx,
	input ft232_clk, //FT232H Direct Connections
	input txe,
	output [7:0] ft232_data,
	output wr,
	output [9:0] debug,
	output [6:0] ssd1, ssd2, ssd3, ssd4);
	
	//Timing Parameters
	localparam MULT = 1;
	localparam HALF = 0;
	
	assign debug = mag_reg[12:3];
	
	logic [3:0] clk_arr, reset_arr; //clk 50, 100, 222, 15	
	
	global_clock_reset gcr (
		.clk_50(clk_50),
		.reset(reset),
		.clk_arr(clk_arr),
		.reset_arr(reset_arr));
	
	
	logic [31:0] cycle_count;	
	logic [MULT+10:0] pwm_count_a, pwm_count_b, pwm_count_c;
	logic [17:0] vd, vq;
	logic vdq_ready;
	
	//Normalized current data for PWM
	logic [17:0] ida, idb, idc, iqa, iqb, iqc;
	logic idq_ready_a, idq_ready_b, idq_ready_c;
	
	assign vd = 18'b0;
	
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
	
	//Raw Sensor Data
	logic sensor_done_a, sensor_done_b, sensor_done_c;
	logic [13:0] mag_reg_a, adc1_reg_a, adc2_reg_a;
	logic [13:0] mag_reg_b, adc1_reg_b, adc2_reg_b;
	logic [13:0] mag_reg_c, adc1_reg_c, adc2_reg_c;
	
	//Motor Modules
	pwm_timing #(.MULT(MULT), .HALF(HALF)) pt (
		.clk_222(clk_arr[1]),
		.reset_222(reset_arr[1]),
		.enable(on_switch),
		.cycle_count(cycle_count),
		.pwm_a(pwm_count_a),
		.pwm_b(pwm_count_b),
		.pwm_c(pwm_count_c));
		
	single_motor #(.MULT(MULT), .HALF(HALF), MAG_OFFSET(14'h0CF0)) sm1 (
		.clk_arr(clk_arr),
		.reset_arr(reset_arr),
		.enable(on_switch),
		.pwm_count(pwm_count_a),
		.vdq_ready(vdq_ready),
		.vd(vd),
		.vq(vq),
		.id(ida),
		.iq(iqa),
		.idq_ready(idq_ready_a),
		.pwm_out(pwm_out_a),
		.sdo1(sdo1),
		.sdo2(sdo2),
		.adc_clk1(adc_clk1),
		.adc_clk2(adc_clk2),
		.cs1(cs[5]),
		.cs2(cs[4]),
		.d_in(d_in),
		.mag_clk_out(mag_clk_out),
		.csn(csn[2]),
		.mag_reg(mag_reg_a),
		.adc1_reg(adc1_reg_a),
		.adc2_reg(adc2_reg_a),
		.sensor_done(sensor_done_a));
		
	single_motor #(.MULT(MULT), .HALF(HALF), MAG_OFFSET(14'h0CF0)) sm2 (
		.clk_arr(clk_arr),
		.reset_arr(reset_arr),
		.enable(on_switch),
		.pwm_count(pwm_count_b),
		.vdq_ready(vdq_ready),
		.vd(vd),
		.vq(vq),
		.id(idb),
		.iq(iqb),
		.idq_ready(idq_ready_b),
		.pwm_out(pwm_out_b),
		.sdo1(sdo1),
		.sdo2(sdo2),
		.adc_clk1(adc_clk1),
		.adc_clk2(adc_clk2),
		.cs1(cs[3]),
		.cs2(cs[2]),
		.d_in(d_in),
		.mag_clk_out(mag_clk_out),
		.csn(csn[1]),
		.mag_reg(mag_reg_b),
		.adc1_reg(adc1_reg_b),
		.adc2_reg(adc2_reg_b),
		.sensor_done(sensor_done_b));
		
	single_motor #(.MULT(MULT), .HALF(HALF), MAG_OFFSET(14'h0CF0)) sm3 (
		.clk_arr(clk_arr),
		.reset_arr(reset_arr),
		.enable(on_switch),
		.pwm_count(pwm_count_c),
		.vdq_ready(vdq_ready),
		.vd(vd),
		.vq(vq),
		.id(idc),
		.iq(iqc),
		.idq_ready(idq_ready_c),
		.pwm_out(pwm_out_c),
		.sdo1(sdo1),
		.sdo2(sdo2),
		.adc_clk1(adc_clk1),
		.adc_clk2(adc_clk2),
		.cs1(cs[1]),
		.cs2(cs[0]),
		.d_in(d_in),
		.mag_clk_out(mag_clk_out),
		.csn(csn[0]),
		.mag_reg(mag_reg_c),
		.adc1_reg(adc1_reg_c),
		.adc2_reg(adc2_reg_c),
		.sensor_done(sensor_done_c));
		
	//Servo Module
	logic [9:0] servo_input_a, servo_input_b, servo_input_c;
	logic [2:0] reverse_motor; //a b c
	
	servo_driver sd (
		.clk_100(clk_arr[2]),
		.reset(reset_arr[2]),
		.center(center),
		.a(servo_input_a),
		.b(servo_input_b),
		.c(servo_input_c),
		.pwm_a(servo_pwm[2]),
		.pwm_b(servo_pwm[1]),
		.pwm_c(servo_pwm[0]),
		.rev_a(reverse_motor[2]),
		.rev_b(reverse_motor[1]),
		.rev_c(reverse_motor[0]));
	
	//TODO: PID Controls
	
	//TODO: Process UART data and deal with transmission to ESP32
	typedef struct packed {
		logic [5:0] blank_0;
		logic home;
		logic boost;
		logic [15:0] optical_sensor;
		logic [3:0] rot_enc_l;
		logic [3:0] rot_enc_r;
		logic [3:0] blank_1;
		logic [11:0] joystick_y;
		logic [3:0] blank_2;
		logic [11:0] joystick_x;
	} rx_packet_s;
	
	typedef union packed {
		rx_packet_s rx_s;
		logic [7:0][7:0] data;
	} rx_packet_u;
	
	rx_packet_u rx_packet;
	logic [1:0][7:0] tx_packet;
	logic tx_valid, rx_valid;
	logic uart_busy
	
	uart_wrapper #(
		.TX_SIZE(2),
		.RX_SIZE(8)) uw (
		.clk_50(clk),
		.reset(reset),
		.tx_packet(tx_packet),
		.rx_packet(rx_packet),
		.tx_valid(tx_valid),
		.rx_valid(rx_valid),
		.tx(tx),
		.rx(rx),
		.busy(uart_busy));
	
	//TODO: Steering Logic 
		
	//Monitor module	
	monitor #(.N(7)) mon (
		.clk(clk_arr[2]),
		.reset(reset_arr[2]),
		.data_input({cycle_count,2'b0,mag_reg_a,5'b0,voltage}),
		.data_write(sensor_done && (cycle_count[2:0] == 3'b0)), //Write every 8 cycles
		.ft232_clk(ft232_clk),
		.txe(txe),
		.ft232_data(ft232_data),
		.wr(wr));
		
	//Speedometer for motor a
	logic [15:0] speed_hz;
	speedometer speed (
		.clk_100(clk_arr[2]),
		.reset(reset_arr[2]),
		.angle_reg(mag_reg_a[13:10]),
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
