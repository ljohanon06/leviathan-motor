module magnetic_encoder_sim(
	input clk,
	input reset,
	input cs,
	input load,
	input [17:0] load_input,
	output logic miso);
	
	logic [17:0] data;
	logic [23:0] shift;
	logic [5:0] crc_num;
	
	logic post_cs;
	
	logic [4:0] count;
	
	logic n_edge;
	assign n_edge = reset & cs;
	
	always_ff @(negedge clk or negedge n_edge) begin
		if(~reset) begin
			post_cs <= 1'b0;
			shift <= 24'b0;
			count <= 5'b0;
			miso <= 1'b1;
		end else if(~post_cs && count == 5'b0) begin
			if(load)
				data <= load_input;
			post_cs <= 1'b1;
			miso <= 1'b1;
		end else begin
			if(post_cs) begin
				post_cs <= 1'b0;
				count <= 5'b1;
				shift <= {data[16:0],crc_num,1'b0};
				miso <= data[17];
			end else begin
				count <= count + 5'b1;
				miso <= shift[23];
				shift <= {shift[22:0], 1'b0};
			end
			if(count == 5'd23)
				count <= 5'b0;
		end
	end
	
	crc #(.BIT_WIDTH(18)) checksum (
		.in({data, 6'b0}),
		.met_crc(),
		.crc_num(crc_num));
endmodule
	
