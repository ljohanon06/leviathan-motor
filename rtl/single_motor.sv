/*
 * File        : single_motor.sv
 * Author      : Levi Johanon
 * Description : Everything to interact with a single motor except for PI controller
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module single_motor #(
	parameter MULT = 1,
	parameter HALF = 0,
	parameter MAG_OFFSET = 14'h0) (
	input [3:0] clk_arr, //50, 100, 222, 15
	input [3:0] reset_arr,
	input enable,
	input [17:0] vd, vq,
	input vdq_ready,
	input [MULT+10:0] pwm_count,
	output logic [17:0] id, iq,
	output logic idq_ready, 
	output logic [5:0] pwm_out,
	input sdo1, //ADC Inputs and Outputs
	input sdo2,
	output logic adc_clk1,
	output logic adc_clk2,
	output logic cs1,
	output logic cs2,
	input d_in, //Magnetic Encoder Inputs and Outputs
	output logic mag_clk_out,
	output logic csn,
	output logic [13:0] mag_reg, //Output signals for monitor
	output logic [13:0] adc1_reg, adc2_reg,
	output logic sensor_done); 
	
	//PWM voltage ready
	logic v_valid;
	always v_valid = pwm_count > (10+MULT)'('d950) & pwm_count < (10+MULT)'('d1024);
	
	//Start magnetic encoder at the beginning
	logic mag_enable, me1, me2;
	always me1 = pwm_count < 10'd64;
	always_ff @(posedge clk_arr[0] or negedge reset_arr[0]) begin
		if(~reset_arr[0]) begin
			me2 <= 1'b0;
			mag_enable <= 1'b0;
		end else begin
			me2 <= me1;
			mag_enable <= me2;
		end
	end
	
	//The current from ADC and foward transform is ready at this time
	logic idq_f1, idq_ready_222;
	always idq_ready_222 = pwm_count >= (10+MULT)'('d640) && pwm_count <= (10+MULT)'('d647);
	always_ff @(posedge clk_arr[2] or negedge reset_arr[2]) begin
		if(~reset_arr[2]) begin
			idq_ready <= 1'b0;
			idq_f1 <= 1'b0;
		end else begin
			idq_f1 <= idq_ready_222;
			idq_ready <= idq_f1;
		end
	end
	
	//The raw sensor data is ready at this time
	logic sd_f1, sensor_done_222;
	always sensor_done_222 = pwm_count >= (10+MULT)'('d640) && pwm_count <= (10+MULT)'('d647);
	always_ff @(posedge clk_arr[2] or negedge reset_arr[2]) begin
		if(~reset_arr[2]) begin
			sensor_done <= 1'b0;
			sd_f1 <= 1'b0;
		end else begin
			sd_f1 <= sensor_done_222;
			sensor_done <= sd_f1;
		end
	end
	
	logic [17:0] vd_reg, vq_reg;
	logic vdq_ready_reg;
	always_ff @(posedge clk_arr[2] or negedge reset_arr[2]) begin
		if(~reset_arr[2]) begin
			vd_reg <= 18'b0;
			vq_reg <= 18'b0;
			vdq_ready_reg <= 1'b0;
		end else if (enable) begin
			vdq_ready_reg <= vdq_ready;
			if(vdq_ready & ~vdq_ready_reg) begin
				vd_reg <= vd;
				vq_reg <= vq;
			end
		end
	end
	
	
	
	logic adc_meas1, adc_meas2;
	logic [13:0] adc1_raw, adc2_raw, mag_raw;
	logic adc_done_1, adc_done_2, me_done;
	logic a1d_1, a1d_2, a2d_1, a2d_2, med_1, med_2;
	
	//PWM Signal
	logic [17:0] v1, v2, v3;
	triple_pwm #(.MULT(MULT), .HALF(HALF)) pt (
		.clk_222(clk_arr[1]),
		.reset_222(reset_arr[1]),
		.v_valid(v_valid),
		.enable(enable), 
		.v1(v1),
		.v2(v2),
		.v3(v3),
		.pwm_count(pwm_count),
		.pwm_out(pwm_out),
		.meas_1(adc_meas1),
		.meas_2(adc_meas2));
		
	//Forward and Inverse Transform, Cordic
	logic [15:0] cos_mag, sin_mag;
	logic cos_sign, sin_sign, cordic_done;
	
	cordic_full cd (
		.clk(clk_arr[2]),
		.reset(reset_arr[2]),
		.valid(med_2), //2nd flip flop synchronizer
		.ready(), //Shows cordic module is ready, unused
		.angle_in(mag_reg), 
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.done(cordic_done));
	
	inverse_transform it (
		.clk(clk_arr[2]),
		.reset(reset_arr[2]),
		.vd(vd_reg), //External input
		.vq(vq_reg),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.v1(v1),
		.v2(v2),
		.v3(v3));
		
	forward_transform ft (
		.clk(clk_arr[2]),
		.reset(reset_arr[2]),
		.adc_i1(adc1_reg), 
		.adc_i2(adc2_reg),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.id(id), //External outputs to PI
		.iq(iq));
		
	//Sensor Clock Domain Crossing using 2-flip flop handshake on done signal
	always_ff @(posedge clk_arr[2] or negedge reset_arr[2]) begin //100MHz
		if(~reset_arr[2]) begin
			adc1_reg <= 14'b0;
			a1d_1 <= 1'b0;
			a1d_2 <= 1'b0;
		end else begin
			a1d_1 <= adc_done_1;
			a1d_2 <= a1d_1;
			if(a1d_2 & ~a1d_1)
				adc1_reg <= adc1_raw;
		end
	end
	
	always_ff @(posedge clk_arr[2] or negedge reset_arr[2]) begin //100MHz
		if(~reset_arr[2]) begin
			adc2_reg <= 14'b0;
			a2d_1 <= 1'b0;
			a2d_2 <= 1'b0;
		end else begin
			a2d_1 <= adc_done_2;
			a2d_2 <= a2d_1;
			if(a2d_2 & ~a2d_1)
				adc2_reg <= adc2_raw;
		end
	end
	
	always_ff @(posedge clk_arr[2] or negedge reset_arr[2]) begin //100MHz
		if(~reset_arr[2]) begin
			mag_reg <= 14'b0;
			med_1 <= 1'b0;
			med_2 <= 1'b0;
		end else begin
			med_1 <= me_done;
			med_2 <= med_1;
			if(med_2 & ~med_1)
				mag_reg <= mag_raw;
		end
	end
	
	//ADC start measurement clock domain crossing
	logic meas1_1, meas1_2, meas2_1, meas2_2;
	always_ff @(posedge clk_arr[3] or negedge reset_arr[3]) begin //50MHz
		if(~reset_arr[3]) begin
			meas1_1 <= 1'b0;
			meas1_2 <= 1'b0;
			meas2_1 <= 1'b0;
			meas2_2 <= 1'b0;
		end else begin
			meas1_1 <= adc_meas1;
			meas1_2 <= meas1_1;
			meas2_1 <= adc_meas2;
			meas2_2 <= meas2_1;
		end
	end
			
		
	//Sensors	
	adc #(.CYCLES(5)) adc_1 (
		.clk(clk_arr[3]), //50 MHz
		.reset(reset_arr[3]),
		.start(meas1_2),
		.sdo(sdo1),
		.clk_out(adc_clk1),
		.cs(cs1),
		.adc(adc1_raw),
		.done(adc_done_1));
		
	adc #(.CYCLES(5)) adc_2 (
		.clk(clk_arr[3]),
		.reset(reset_arr[3]),
		.start(meas2_2),
		.sdo(sdo2),
		.clk_out(adc_clk2),
		.cs(cs2),
		.adc(adc2_raw),
		.done(adc_done_2));
		
	magnetic_encoder #(.OFFSET(MAG_OFFSET)) me (
		.mag_clk(clk_arr[0]), //15 MHz
		.reset(reset_arr[0]),
		.d_in(d_in),
		.enable(mag_enable),
		.csn(csn),
		.clk_out(mag_clk_out),
		.done(me_done),
		.raw_data(), //Unused
		.angle_out(mag_raw));
	
	
endmodule
	
	
	


/*
Modules to instantiate

-cordic_full
-forward_transform
-inverse_transform
-PI controller
-PWM output
-Clock logic
-PLL for mt6701
-magnetic_encoder
-two adc, timing logic to ensure that its clocked when low gate on.
*/

/*
Clocks:
100MHz - Logic and ADC
64ns - MT6701
216MHz - PWM

Remaining:
ESP32 logic - unclocked?
Angle sensor
BMS?? 
*/
