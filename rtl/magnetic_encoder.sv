/*
 * File        : magnetic_encoder.sv
 * Author      : Levi Johanon
 * Description : Soft IP for MT6701, SSI communication protocol, crc checksum
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */
	
//Determine offset by passing current from C to B
//This value plus 14'h0800 is the offset
module magnetic_encoder #(
	parameter logic [13:0] OFFSET = 14'b0) (
	input mag_clk, 
	input reset,
	input enable,
	input d_in,
	output logic csn,
	output logic clk_out,
	output logic done,
	output logic [13:0] angle_out,
	output logic [23:0] raw_data);
	
	typedef enum logic [4:0] {
		idle, csn_low, d[13:0], m[3:0], crc[5:0], csn_high, delay} mag_enc_state_t;
		
	mag_enc_state_t state;
	logic clk_level; //State variable, what level is the clk_out at
	
	logic [23:0] shift_reg;
	logic met_crc;
	
	mag_enc_state_t next_state;
	logic next_clk_level;
	
	always_ff @(posedge mag_clk or negedge reset) begin
		if(~reset) begin
			shift_reg <= 24'b0;
			csn <= 1'b1;
			clk_out <= 1'b1;
			state <= idle;
			clk_level <= 1'b0;
			done <= 1'b0;
			angle_out <= 14'b0;
			raw_data <= 24'b0;
		end else begin
			state <= next_state;
			clk_level <= next_clk_level;
			
			if(state >= d13 && state <= crc0 && clk_level)
				shift_reg <= {shift_reg[22:0], d_in};
				
			//Done and load shift register
			if(state == csn_high && clk_level) begin
				raw_data <= shift_reg;
				if(met_crc) begin
					angle_out <= shift_reg[23:10] - OFFSET;
					done <= 1'b1;
				end
			end
			if(state == crc0)
				done <= 1'b0;	
			
			//CSN
			if(next_state == idle || next_state == delay)
				csn <= 1'b1;
			else csn <= 1'b0;
				
			//Clock out
			if(next_state == idle)
				clk_out <= 1'b1;
			else if(next_state == csn_low)
				clk_out <= 1'b1;
			else if(next_state == csn_high)
				clk_out <= 1'b1;
			else if(next_state == delay)
				clk_out <= 1'b1;
			else if(next_clk_level == 1'b0)
				clk_out <= 1'b0;
			else clk_out <= 1'b1;
		end
	end
	
	crc #(.BIT_WIDTH(18)) checksum (
		.in(shift_reg),
		.met_crc(met_crc),
		.crc_num());
	
	//Next state combinational logic
	//Next_state logic
	always_comb begin
		//Next state and for clk_level 0
		if(~clk_level) begin
			if(state == idle && enable)
				next_state = csn_low;
			else if (state == csn_low)
				next_state = csn_low;
			else if (state >= d13 && state <= crc0)
				next_state = state;
			else if (state == csn_high)
				next_state = csn_high;
			else //state == delay
				next_state <= delay;
		end else begin //Next state for clk_level 1
			if(state == idle && enable)//Shouldn't Occur
				next_state = csn_low;
			else if (state == csn_low)
				next_state = d13;
			else if (state >= d13 && state <= crc0)
				next_state = mag_enc_state_t'(state + 5'b1);
			else if (state == csn_high)
				next_state = delay;
			else //state == delay
				next_state = idle;
		end
	end
	
	//Next clock level logic
	always_comb begin
		if(state == idle) 
			next_clk_level = 1'b0;
		else next_clk_level = ~clk_level;
	end
	
	
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


	
