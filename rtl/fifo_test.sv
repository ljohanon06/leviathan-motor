module fifo_test (
	input clk_50,
	input reset,
	input ft232_clk, //FT232H Direct Connections
	input txe,
	output [7:0] ft232_data,
	output wr);
	
	
	logic [31:0] clk_ladder;
	
	always_ff @(posedge clk_50 or negedge reset) begin
		if(~reset)
			clk_ladder <= 32'b0;
		else clk_ladder <= clk_ladder + 32'b1;
	end
		
	monitor #(.N(4)) mon (
		.clk(clk_50),
		.reset(reset),
		.data_input(clk_ladder),
		.data_write(clk_ladder[10]),
		.ft232_clk(ft232_clk),
		.txe(txe),
		.ft232_data(ft232_data),
		.wr(wr));	
		
endmodule
	
	