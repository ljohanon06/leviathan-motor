module fifo_ft232h (
	input reset, //Internal Connections
	input clk,
	input [7:0] data_in,
	input write,
	output logic done,
	input ft232_clk, //FT232H Direct Connections
	input txe,
	output [7:0] ft232_data,
	output wr);
	
	logic dr1, dr2;
	logic data_valid, data_recieved;
	
	typedef enum logic [1:0] {dvl_drl, dvh_drl, dvh_drh, dvl_drh} state_t;
	state_t state;
	
	always_ff @(posedge clk or negedge reset) begin
		if(~reset) begin
			dr1 <= 1'b0;
			dr2 <= 1'b0;
			state <= dvl_drl;
			done <= 1'b0;
		end else begin
			dr1 <= data_recieved;
			dr2 <= dr1;
			case(state)
				dvl_drl: if(write) begin
					state <= dvh_drl;
					data_valid <= 1'b1; 
					done <= 1'b0; end
				dvh_drl: if(dr2) begin
					state <= dvh_drh;
					done <= 1'b1; end
				dvh_drh: begin 
					state <= dvl_drh; 
					data_valid <= 1'b0; end
				dvl_drh: if(~dr2) begin
					state <= dvl_drl;
					done <= 1'b0; end
			endcase
		end
	end
	
	fifo_ft232h_cdc cdc (
		.reset(reset),
		.data_in(data_in),
		.data_valid(data_valid),
		.ft232_clk(ft232_clk),
		.ft232_data(ft232_data),
		.data_recieved(data_recieved),
		.txe(txe),
		.wr(wr));
		
endmodule
