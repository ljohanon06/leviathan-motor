module uart_wrapper_test(
	input clk,
	input reset,
	input rx,
	output logic tx,
	output logic [6:0] ssd1, ssd2, ssd3, ssd4,
	output logic [9:0] leds,
	input zero,
	output pwm_a, pwm_b, pwm_c);
	
	typedef struct packed {
		logic [15:0] optical_sensor;
		logic [5:0] blank_0;
		logic home;
		logic boost;
		logic signed [7:0] pot_diff;
		logic [5:0] blank_1;
		logic [9:0] direction;
		logic [5:0] blank_2;
		logic [9:0] magnitude;
	} rx_packet_s;
	
	rx_packet_s rx_packet;
	logic [1:0][7:0] tx_packet;
	logic tx_valid, rx_valid;
	logic uart_busy;
	
	uart_wrapper #(
		.TX_SIZE(2),
		.RX_SIZE(8)) uw (
		.clk_50(clk),
		.reset(reset),
		.tx_packet(tx_packet),
		.rx_packet(rx_packet),
		.tx_valid(tx_valid),
		.rx_valid(rx_valid),
		.tx(tx),
		.rx(rx),
		.busy(uart_busy));
	
	logic [3:0] [3:0] hex;
	
	logic signed [15:0] count;
	logic rx_valid_reg;
	
	always_ff @(posedge clk or negedge reset) begin
		if(~reset) begin
			hex <= 'b0;
			tx_valid <= 1'b0;
			count <= 16'h0;
			rx_valid_reg <= 1'b0;
		end else begin
			tx_valid <= ~uart_busy;
			tx_packet <= 16'hBEEF;
			hex <= {~count[15],count[14:0]};
			leds[7:0] <= rx_packet.pot_diff;
			rx_valid_reg <= rx_valid;
			if(~rx_valid_reg & rx_valid)
				count <= count + rx_packet.pot_diff;
		end
	end
		
	single_ssd s1 (
		.in(hex[0]),
		.ssd(ssd1));
	
	single_ssd s2 (
		.in(hex[1]),
		.ssd(ssd2));
	
	single_ssd s3 (
		.in(hex[2]),
		.ssd(ssd3));
		
	single_ssd s4 (
		.in(hex[3]),
		.ssd(ssd4));
		
	servo_driver_test sd (
		.clk_50(clk),
		.reset(reset),
		.zero(zero),
		.sw(rx_packet.direction),
		.rev_a(leds[9]),
		.rev_b(),
		.rev_c(),
		.pwm_a(pwm_a),
		.pwm_b(pwm_b),
		.pwm_c(pwm_c));
endmodule
