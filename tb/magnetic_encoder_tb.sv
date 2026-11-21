module magnetic_encoder_tb();

	logic clk, reset;
	logic d_in;
	
	logic csn, mag_clk_out, me_done;
	logic [13:0] angle_out;
	logic [23:0] raw_data;
	
	magnetic_encoder #(.OFFSET(14'h0CF0)) me (
		.mag_clk(clk),
		.reset(reset),
		.d_in(d_in),
		.enable(1'b1),
		.csn(csn),
		.clk_out(mag_clk_out),
		.done(me_done),
		.angle_out(angle_out),
		.raw_data(raw_data));
		
	always #50 clk = ~clk;
	
	initial begin
		clk = 1'b0;
		reset = 1'b1;
		d_in = 1'b1;
		
		#100 reset <= 1'b0;
		#100 reset <= 1'b1;
		
		#10000;
		$stop;
	end

endmodule
