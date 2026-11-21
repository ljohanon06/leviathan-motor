/*
 * File        : uart_receiver.sv
 * Author      : Levi Johanon
 * Description : Receives a single uart byte
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module uart_receiver (
	input clk_50,
	input reset,
	input rx,
	output logic [7:0] data,
	output logic data_valid,
	output logic failed_parity);
	
	//turns high for a clock cycle at 16*9600 Hz
	logic clk_en_16;
	logic [8:0] baud_count_16; //326 clock cycles
	logic [3:0] count_16;
	logic rx_reg;
	logic [7:0] data_reg;
	logic parity_check;
	
	assign parity_check = ^data_reg; //Xors to find number of odd, if parity equal to this parity even work
	
	typedef enum logic [3:0] {idle, start, d[0:7], parity, stop} state_t;
	logic parity_fail;
	state_t cur_state;
	
	//Handle clock enable
	always_ff @(posedge clk_50 or negedge reset) begin
		if(~reset) begin
			clk_en_16 <= 1'b0;
			baud_count_16 <= 9'b0;
		end else begin
			if(baud_count_16 == 9'd325) begin
				clk_en_16 <= 1'b1;
				baud_count_16 <= 9'b0;
			end else begin
				clk_en_16 <= 1'b0;
				baud_count_16 <= baud_count_16 + 9'b1;
			end
		end
	end
	
	always_ff @(posedge clk_50 or negedge reset) begin
		if (~reset) begin
			count_16 <= 4'b0;
			cur_state <= idle;
			rx_reg <= 1'b1;
			parity_fail <= 1'b0;
			data_reg <= 8'b0;
		end else if(clk_en_16) begin
			rx_reg <= rx;
			
			//Handle count_16
			if(cur_state == idle)
				count_16 <= 4'b0;
			else
				count_16 <= count_16 + 4'b1; //Wraparound is intentional
			
			//Switch out of idle
			if(cur_state == idle && (rx_reg & ~rx)) begin
				cur_state <= start;
				parity_fail <= 1'b0;
			end
			
			//Read bits and data
			if(count_16 == 4'd8) begin
				case (cur_state)
					start: if(rx_reg) parity_fail <= 1'b1;
					d0,d1,d2,d3,d4,d5,d6,d7: 
						data_reg[4'(cur_state - 4'd2)] <= rx_reg;
					parity: if(rx_reg ^ parity_check) parity_fail <= 1'b1;
					stop: if(~rx_reg) parity_fail <= 1'b1;
						  else cur_state <= idle;
				endcase
				
			end
		
			//Switch states
			if(count_16 == 4'd15) begin
				case(cur_state)
					start: cur_state <= d0;
					d0,d1,d2,d3,d4,d5,d6,d7: 
						cur_state <= state_t'(cur_state + 4'b1);
					d7: cur_state <= parity;
					parity: cur_state <= stop;
					stop: cur_state <= idle;
				endcase
			end
			
			//Data valid and parity
			if(cur_state == stop) begin
				data_valid <= 1'b1;
				data <= data_reg;
				failed_parity <= parity_fail;
			end else
				data_valid <= 1'b0;
		end
	end
endmodule
