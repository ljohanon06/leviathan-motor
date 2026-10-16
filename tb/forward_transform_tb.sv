`timescale 1ns / 1ps

module forward_transform_tb ();

	logic clk;
	logic reset;
	logic [13:0] adc_i1;
	logic [13:0] adc_i2;
	logic [15:0] cos_mag;
	logic [15:0] sin_mag;
	logic cos_sign;
	logic sin_sign;
	logic [17:0] id;
	logic [17:0] iq;
	
	logic [13:0] angle_in;
	logic valid;
	logic done;
	logic ready;
	
	cordic_full cd (
		.clk(clk),
		.reset(reset),
		.valid(valid),
		.angle_in(angle_in),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.done(done),
		.ready(ready));
	
	forward_transform dut (
		.clk(clk),
		.reset(reset),
		.adc_i1(adc_i1),
		.adc_i2(adc_i2),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.id(id),
		.iq(iq));
		
	
	always #5 clk = ~clk;
	
	initial begin
		$timeformat(-9,0," ns", 8);
		
		clk = 0;
		reset = 1;
		valid = 0;
		angle_in = 14'd6144;
		adc_i1 = 14'd0;
		adc_i2 = 14'd16302;
		
		#10 reset = 0;
		#10 reset = 1;
		valid = 1;
		#10 valid = 0;
		
		#200
		$display("%d %d", $signed(id), $signed(iq));		
	end
	
	



endmodule