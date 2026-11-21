`timescale 1ns / 1ps

module magnetic_encoder_tb();

	logic clk, reset;
	logic d_in;
	
	logic csn, mag_clk_out, me_done;
	logic [13:0] angle_out;
	logic [23:0] raw_data;
	
	magnetic_encoder #(.OFFSET(14'h0)) me (
		.mag_clk(clk),
		.reset(reset),
		.d_in(d_in),
		.enable(1'b1),
		.csn(csn),
		.clk_out(mag_clk_out),
		.done(me_done),
		.angle_out(angle_out),
		.raw_data(raw_data));
		
	logic load;
	logic [17:0] load_input;
		
	magnetic_encoder_sim sim(
		.clk(mag_clk_out),
		.reset(reset),
		.cs(csn),
		.load(load),
		.load_input(load_input),
		.miso(d_in));
		
	always #28.8 clk = ~clk;
	
	initial begin
		clk = 1'b0;
		reset = 1'b1;
		load <= 1'b1;
		load_input <= 18'h2F395;
		
		#1 reset <= 1'b0;
		#200 reset <= 1'b1;
		
		#20000;
		$stop;
	end

endmodule
