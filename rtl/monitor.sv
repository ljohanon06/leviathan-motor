//N is bytes sent, max 16
module monitor #(parameter N = 2,
	parameter B = (N < 2) ? 2 : ((N>16) ? 16 : N)) (
	input clk,
	input reset,
	input [B-1:0] [7:0] data_input,
	input data_write,
	input ft232_clk, //FT232H Direct Connections
	input txe,
	output [7:0] ft232_data,
	output wr);
	
	//Fifo inputs
	logic write, done; 
	logic [7:0] data_in;
	
	logic [B+1:0] [7:0] data_reg;
	
	//Data is send little endian
	typedef enum logic [1:0] {idle, crc_gen1, crc_gen2, data} state_t;
	logic [4:0] byte_num;
	state_t state;
	
	logic prev_dw;
	
	logic [5:0] crc_num;
	crc #(.BIT_WIDTH(B*8)) crc (
		.in({data_reg[B-1:0],6'b0}),
		.crc_num(crc_num));
	
	always_ff @(posedge clk or negedge reset) begin
		if(~reset) begin
			state <= idle;
			write <= 1'b0;
			data_reg <= '0;
			prev_dw <= 1'b0;
		end else begin
			prev_dw <= data_write;
			if(state == idle) begin
				if(data_write & ~prev_dw) begin
					data_reg <= {8'hAA,8'b0,data_input};
					state <= crc_gen1;
					byte_num <= 5'b0;
				end 
				write <= 1'b0;
			end else if(state == crc_gen1) begin
				state <= crc_gen2;
			end else if(state == crc_gen2) begin
				state <= data;
				data_reg <= {8'hAA,2'b0,crc_num,data_reg[B-1:0]};
			end else if(byte_num == B+2) begin
				state <= idle;
				byte_num <= 5'b0;
				write <= 1'b0;
			end else begin
				if(~write & ~done) begin
					write <= 1'b1;
					data_in <= data_reg[byte_num];
				end else if(write & done) begin
					write <= 1'b0;
					byte_num <= byte_num + 5'b1;
				end
			end	
		end
	end
	
	fifo_ft232h fifo (
		.clk(clk),
		.reset(reset),
		.data_in(data_in),
		.write(write),
		.done(done),
		.ft232_clk(ft232_clk),
		.txe(txe),
		.ft232_data(ft232_data),
		.wr(wr));

	
endmodule
	