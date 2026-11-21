/*
 * File        : uart_transmitter.sv
 * Author      : Levi Johanon
 * Description : Transmits a single uart byte
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module uart_transmitter (
	input clk_50,
	input reset,
	input [7:0] data,
	input send,
	output logic tx,
	output logic busy);
	
	typedef enum logic [3:0] {idle, start, d[0:7], parity, stop} state_t;
	state_t cur_state;
	
	//9600 * 5208 =~ 50MHz
	logic [12:0] baud_count;
	
	logic send_reg;
	logic [7:0] data_reg;
	
	//State Machine
	always_ff @(posedge clk_50 or negedge reset) begin
		if(~reset) begin
			send_reg <= 1'b0;
			cur_state <= idle;
		end else begin
			send_reg <= send;
			if(cur_state == idle) begin
				if(~send_reg & send) begin
					cur_state <= start;
					baud_count <= 13'b0;
					data_reg <= data;
				end
			end else begin //Not in state idle
				baud_count <= baud_count + 13'b1;
				if(baud_count == 13'd5207) begin//Timing for 9600 baud
					baud_count <= 13'b0;
					if(cur_state == stop)
						cur_state <= idle;
					else cur_state <= state_t'(cur_state + 4'b1);
				end
			end
		end
	end
	
	logic parity_bit;
	
	//Tx and busy combinational output
	always_comb begin
		busy = cur_state != idle;
	
		parity_bit = ^data_reg;	//High if odd number of bits is one
								//For even parity no flipping needed
		case (cur_state)
			idle: tx = 1'b1;
			start: tx = 1'b0;
			parity: tx = parity_bit;
			stop: tx = 1'b1;
			default: tx = data_reg[4'(cur_state - 4'd2)];
		endcase
	end	
endmodule

