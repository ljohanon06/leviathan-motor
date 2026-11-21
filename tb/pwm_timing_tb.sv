`timescale 1ns / 1ps

module pwm_timing_tb();

	logic clk_50, reset;

	logic [3:0] clk_arr, reset_arr; //clk 50, 100, 222, 15	
	global_clock_reset gcr (
		.clk_50(clk_50),
		.reset(reset),
		.clk_arr(clk_arr),
		.reset_arr(reset_arr));
		
	localparam MULT = 1;
	localparam HALF = 0;
	
	logic [31:0] cycle_count;	
	logic [MULT+10:0] pwm_count;
	
	pwm_timing #(.MULT(MULT), .HALF(HALF)) pt (
		.clk_222(clk_arr[1]),
		.reset_222(reset_arr[1]),
		.enable(1'b1),
		.cycle_count(cycle_count),
		.pwm_a(pwm_count),
		.pwm_b(),
		.pwm_c());
		
	logic v_valid;
	logic [5:0] pwm_out;
	logic adc_meas1, adc_meas2;		
	logic [17:0] v1, v2, v3;
	triple_pwm #(.MULT(MULT), .HALF(HALF)) tp (
		.clk_222(clk_arr[1]),
		.reset_222(reset_arr[1]),
		.v_valid(v_valid),
		.enable(1'b1), 
		.v1(v1),
		.v2(v2),
		.v3(v3),
		.pwm_count(pwm_count),
		.pwm_out(pwm_out),
		.meas_1(adc_meas1),
		.meas_2(adc_meas2));
		
	logic [13:0] mag_reg; //Angle out from magnetic encoder
	logic [15:0] cos_mag, sin_mag;
	logic cos_sign, sin_sign, cordic_done;
	logic valid;
		
	cordic_full cd (
		.clk(clk_arr[2]),
		.reset(reset_arr[2]),
		.valid(valid), 
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
		.vd(18'b0),
		.vq(18'h1BB60),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.v1(v1),
		.v2(v2),
		.v3(v3));
		
	//Set mag_reg, posedge on v_valid
	
	always #10 clk_50 = ~clk_50;
	
	initial begin
		clk_50 <= 1'b0;
		reset <= 1'b1;
		valid <= 1'b0;
		v_valid <= 1'b0;
		#1 reset <= 1'b0;
		#99 reset <= 1'b1;
		#200;
		
		for(int i = 0; i<18; i++) begin
			mag_reg <= 14'(14'h1fff * i * 20 / 360);
			#10 valid <= 1'b1;
			#10 valid <= 1'b0;
			v_valid <= 1'b0;			
			#500 v_valid <= 1'b1;
			#20000;
		end
		
		$stop;		
	end
		
endmodule
