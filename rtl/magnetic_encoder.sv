/*
 * File        : magnetic_encoder.sv
 * Author      : Levi Johanon
 * Description : Soft IP for MT6701, SSI communication protocol, crc checksum
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */
	
module magnetic_encoder(
	input mag_clk,
	input reset,
	input enable,
	input d_in,
	output csn,
	output clk_out,
	output done,
	output [13:0] angle_out,
	output [23:0] raw_data);
	
	typedef enum logic [4:0] {
		idle, CSN_low, CLK_start, d[13:0],
		m[3:0], crc[5:0], CRC_check, CSN_high} mag_enc_state_t;
		
	mag_enc_state_t state;
	logic [23:0] data_shift;
	logic clk_out_set; //Should clk_out match mag_clk?
	logic met_crc;
	
	assign clk_out = mag_clk & clk_out_set;
	
	//csn is affected on the positive edge
	always_ff @(posedge mag_clk or negedge reset) begin
		if(~reset) begin
			csn <= 1'b1;
		end
		else begin
			if(state != idle && state != CSN_high)
				csn <= 1'b0;
			else csn <= 1'b1;
		end
	end
	
	//d_in read on neg, clk_out_set, state, done
	always_ff @(negedge mag_clk or negedge reset) begin
		if(~reset) begin
			data_shift <= 24'b0;
			clk_out_set <= 1'b0;
			state <= idle;
			done <= 1'b0;
		end
		else begin
			if(state == idle && enable) begin
				state <= CSN_low;
			end else if(state == CSN_low) begin //csn handled by posedge
				state <= CLK_start; 
			end else if(state == CLK_start) begin
				state <= d13;
				clk_out_set <= 1'b1;
				done <= 1'b0;
			end else if(state >= 5'd3 && state <= 5'd25) begin //between d13 and crc1
				state <= mag_enc_state_t'(state + 5'b1);
				data_shift <= {data_shift[22:0],d_in};
			end else if(state == crc0) begin
				state <= CRC_check;
				data_shift <= {data_shift[22:0],d_in};
				clk_out_set <= 1'b0;
			end else if(state == CRC_check) begin //Give a clock cycle for CRC to compute
				state <= CSN_high;
			end else if(state == CSN_high) begin
				state <= idle;
				raw_data <= data_shift;
				if(met_crc) begin //Only set done if checksum matches
					done <= 1'b1;
					angle_out <= data_shift[23:10];
				end
				else done <= 1'b0; 
			end
		end
	end
	
	crc checksum (
		.in({data_shift[23:10],data_shift[5:0]}),
		.met_crc(met_crc),
		.crc_num());
	
endmodule

/*
Timing Details:
Clock period: 64ns
Total time: 1536ns
Enable should be high for 100ns at least

1R-CSN falls
2F-CLK falls
3F-D13...

on crc0, no falling edge clk

Data 13:0
Status 3:0
CRC 5:0 x^6+x+1
*/


	
