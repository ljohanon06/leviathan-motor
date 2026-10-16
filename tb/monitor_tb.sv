`timescale 1ns / 1ps

module monitor_tb();
	
	logic clk, reset, write;
	logic [47:0] d_in;
	
	logic ft232_clk, txe, wr;
	logic [7:0] ft232_data;
	
		
	monitor #(.N(6)) mon (
		.clk(clk),
		.reset(reset),
		.data_input(d_in),
		.data_write(write),
		.ft232_clk(ft232_clk),
		.txe(txe),
		.ft232_data(ft232_data),
		.wr(wr));	

	logic [5:0] crc_num;
	crc #(.BIT_WIDTH(48)) crc (
		.in({d_in,6'b0}),
		.crc_num(crc_num));
		
	always #5 clk = ~clk;
	always #8.333 ft232_clk = ~ft232_clk;
	
	initial begin
		reset = 1'b0;
		clk = 1'b0;
		ft232_clk = 1'b0;
		write = 1'b0;
		d_in = 16'b0;
		txe = 1'b0;
		#100
		reset = 1'b1;
		#10
		
		@(posedge clk);
		d_in = 48'h0000ABCDBEEF;
		write = 1'b1;
		#50 write = 1'b0;
		#1950
		
		@(posedge clk);
		d_in = 48'hF000AAAA1234;
		write = 1'b1;
		#50 write = 1'b0;
		#1950
		
		@(posedge clk);
		d_in = 48'h123456788765;
		write = 1'b1;
		#50 write = 1'b0;
		#1950
		
		@(posedge clk);
		d_in = 48'hFF00FF00FF00;
		write = 1'b1;
		#50 write = 1'b0;
		#1950
		
		$stop;
	end

endmodule