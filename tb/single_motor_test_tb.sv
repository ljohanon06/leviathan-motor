`timescale 1ns / 1ps

module single_motor_test_tb();

	logic clk, reset, on_switch;
	logic [2:0] voltage;
	
	logic d_in, mag_clk_out, csn;
	logic [5:0] pwm_out;
	logic [9:0] debug;
	
	
	logic sdo1, sdo2, adc_clk1, adc_clk2, cs1, cs2;
	logic ft232_clk, txe, wr;
	logic [7:0] ft232_data;
	logic [3:0] [6:0] ssd;
	
	
	single_motor_test dut (
		.clk_50(clk),
		.reset(reset),
		.on_switch(on_switch),
		.voltage(voltage),
		.d_in(d_in),
		.mag_clk_out(mag_clk_out),
		.csn(csn),
		.pwm_out(pwm_out),
		.debug(debug),
		.sdo1(sdo1),
		.sdo2(sdo2),
		.adc_clk1(adc_clk1),
		.adc_clk2(adc_clk2),
		.cs1(cs1),
		.cs2(cs2),
		.ft232_clk(ft232_clk),
		.txe(txe),
		.wr(wr),
		.ft232_data(ft232_data),
		.ssd1(ssd[3]),
		.ssd2(ssd[2]),
		.ssd3(ssd[1]),
		.ssd4(ssd[0]));
		
	logic load;
	logic [17:0] load_input;
		
	magnetic_encoder_sim sim(
		.clk(mag_clk_out),
		.reset(reset),
		.cs(csn),
		.load(load),
		.load_input(load_input),
		.miso(d_in));
		
	always #10 clk = ~clk;
	
	logic past_idq;
	always_ff @(posedge clk or negedge reset) begin
		if(~reset) begin
			past_idq <= 1'b0;
			load_input <= {14'h3A6F, 4'b0};
		end else begin
			past_idq <= debug[0];
			if(debug[0] & ~past_idq)
				load_input <= load_input + 18'h1000;
		end
	end
		
	initial begin
		clk <= 1'b0;
		reset <= 1'b1;
		on_switch <= 1'b0;
		voltage <= 3'b0;
		load <= 1'b1;
		sdo1 <= 1'b0;
		sdo2 <= 1'b1;
		
		#1 reset <= 1'b0;
		@(posedge clk) reset <= 1'b1;
		#500;
		
		on_switch <= 1'b1;
		voltage <= 3'b011;
		
		
		#1000000;
		$stop;
	end
endmodule
