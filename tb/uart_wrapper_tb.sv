/*
 * File        : uart_wrapper_tb.sv
 * Author      : Levi Johanon
 * Description : Testbench for uart_wrapper
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

`timescale 1ns / 10ps

module uart_wrapper_tb();
	logic clk, reset;
	logic [7:0][7:0] tx_packet, rx_packet;
	logic tx_valid, rx_valid, busy;
	logic tx, rx;
	
	assign rx = tx;
	
	
	uart_wrapper #(
		.TX_SIZE(8),
		.RX_SIZE(8)) dut (
		.clk_50(clk),
		.reset(reset),
		.tx_packet(tx_packet),
		.rx_packet(rx_packet),
		.tx_valid(tx_valid),
		.rx_valid(rx_valid),
		.tx(tx),
		.rx(rx),
		.busy(busy));
		
	always #10 clk = ~clk;
	
	initial begin
		clk <= 1'b0;
		reset <= 1'b1;
		tx_packet <= 64'hDEADBEEF12345678;
		tx_valid <= 1'b0;
		
		@(posedge clk);
		reset <= 1'b0;
		
		@(posedge clk);
		reset <= 1'b1;
		#100
		tx_valid <= 1'b1;
		
		#12000000;
		$stop;		
	end
endmodule
