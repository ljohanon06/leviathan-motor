/*
Handles the clock domain crossing between the ft232h and the fpga
Uses a 4 step handshake
*/

module fifo_ft232h_cdc(
	input reset,
	input [7:0] data_in,
	input data_valid,
	input ft232_clk,
	output logic [7:0] ft232_data,
	output logic data_recieved,
	input txe, //Transmit empty, active low
	output logic wr); //Write enable, active low
	
	logic dv1, dv2; //Data Valid flip flops
	logic wr_control; 
	
	typedef enum logic [1:0] {dvl_drl, dvh_drl, dvh_drh, dvl_drh} state_t;
	state_t state;
	
	always_ff @(posedge ft232_clk or negedge reset) begin
		if(~reset) begin
			dv1 <= 1'b0;
			dv2 <= 1'b0;
			ft232_data <= 8'b0;
			state <= dvl_drl;
			wr <= 1'b1;
		end else begin
			dv1 <= data_valid;
			dv2 <= dv1;
			case(state)
				dvl_drl: if(dv2) begin
					state <= dvh_drl;
					wr_control <= 1'b0;
					wr <= 1'b1; end
				dvh_drl: if(~txe) begin
					state <= dvh_drh;
					ft232_data <= data_in;
					wr_control <= 1'b1;
					wr <= wr_control; 
					data_recieved <= 1'b1; end
				dvh_drh: begin
					wr <= wr_control;
					if(~dv2 & wr) 
						state <= dvl_drh; end
				dvl_drh: begin 
					state <= dvl_drl; 
					data_recieved <= 1'b0; end			
			endcase
		end
	end
endmodule
