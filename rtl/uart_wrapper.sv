module uart_wrapper #(
	parameter TX_SIZE = 4,
	parameter RX_SIZE = 4) (
	input clk_50,
	input reset,
	input [TX_SIZE-1:0] [7:0] tx_packet,
	input tx_valid,
	output logic [RX_SIZE-1:0] [7:0] rx_packet,
	output logic rx_valid,
	output logic busy,
	output logic tx, //Uart lines
	input rx);
	
	logic [TX_SIZE+1:0] [7:0] tx_reg;
	logic [RX_SIZE+1:0] [7:0] rx_reg;
	
	typedef enum logic {idle_tx, sending} tx_state_t;
	tx_state_t tx_state;
	logic tx_valid_reg;
	logic [2:0] tx_delay;
	
	typedef enum logic [1:0] {idle_rx, receiving, parity} rx_state_t;
	rx_state_t rx_state;
	
	
	logic [7:0] tx_data;
	logic tx_send, tx_busy;
	
	uart_transmitter u_tx (
		.clk_50(clk_50),
		.reset(reset),
		.data(tx_data),
		.send(tx_send),
		.tx(tx),
		.busy(tx_busy));
		
	logic [7:0] rx_data;
	logic rx_data_valid, rx_failed_parity;
	logic rx_data_valid_reg;
		
	uart_receiver u_rx (
		.clk_50(clk_50),
		.reset(reset),
		.rx(rx),
		.data(rx_data),
		.data_valid(rx_data_valid),
		.failed_parity(rx_failed_parity));
		
	always_ff @(posedge clk_50 or negedge reset) begin
		if(~reset) begin
			tx_reg <= '0;
			tx_state <= idle_tx;
			tx_valid_reg <= 1'b0;
			tx_data <= 8'b0;
			tx_send <= 1'b0;
			tx_delay <= 3'b0;
			busy <= 1'b0;
		end else begin
			tx_valid_reg <= tx_valid;
			if(tx_state == idle_tx && tx_valid && ~tx_valid_reg) begin //Recieve packet for transmission
				tx_reg <= {8'h55,tx_packet,8'h55};
				tx_state <= sending;
				busy <= 1'b1;
				tx_delay <= 3'b0;
			end else tx_delay <= tx_delay + 3'b1;
			if(tx_state == sending && !tx_busy && tx_delay == 3'b0) begin //Send packets til out of packets
				if(tx_reg == '0) begin
					tx_state <= idle_tx;
					busy <= 1'b0;
				end else begin
					tx_data <= tx_reg[0];
					tx_reg <= {8'b0, tx_reg[TX_SIZE+1:1]};
					tx_send <= 1'b1;
				end
			end else
				tx_send <= 1'b0;
		end
	end
	
	always_ff @(posedge clk_50 or negedge reset) begin
		if(~reset) begin
			rx_state <= idle_rx;
			rx_reg <= '0;
			rx_valid <= 1'b0;
			rx_data_valid_reg <= 1'b0;
			rx_packet <= '0;
		end else begin
			rx_data_valid_reg <= rx_data_valid;
			if(rx_data_valid && ~rx_data_valid_reg) begin
				rx_valid <= 1'b0;
				if(rx_state == idle_rx) begin
					rx_state <= receiving;
					rx_reg <= {rx_data,((RX_SIZE+1)*8)'('b0)};
				end else
					rx_reg <= {rx_data, rx_reg[RX_SIZE+1:1]};
					
				if(rx_failed_parity)
					rx_state <= parity;
			end
			if(rx_reg[0] != 8'b0 && rx_state != idle_rx) begin
				if(rx_state == receiving) begin
					rx_valid <= 1'b1;
					rx_packet <= rx_reg[RX_SIZE:1];
					rx_state <= idle_rx;
				end else begin //parity
					rx_state <= idle_rx;
					rx_valid <= 1'b0;
				end
			end	
		end
	end
	
	
endmodule	
