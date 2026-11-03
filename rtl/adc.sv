/*
 * File        : adc.sv
 * Author      : Levi Johanon
 * Description : Soft IP to interact with MCP33151D ADC.
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

/*
Timing information:

cs behavior:
cs is idle low
On rising edge of CS, cap is locked into ADC
1400ns CS high-Data conversion phase
CS Falling edge, data can be clocked out

sclk behavior:
sclk idle low
first rising edge is after cs goes low
data is clocked out of adc at falling edge

sdo behavior:
idle high, read on rising edge

CS-Pulldown
SCLK-Pulldown
SDI-Pullup
SDO-Pullup
*/

module adc (
	input clk, //50MHz
	input reset,
	input start,
	input sdo,
	output clk_out, 
	output cs, 
	output logic [13:0] adc,
	output done);
	
	
	typedef enum logic [4:0] {idle, converting_phase, d[13:0], quiet_phase} adc_state_t;
		
	adc_state_t state;
	logic [6:0] phase_count;  //70 clock cycles = 1400ns
	logic clk_out_set;
	
	assign clk_out = (clk & clk_out_set) ? 1'b1 : 1'bz;
	
	logic start_reg;
	
	always_ff @(posedge clk or negedge reset) begin
		if(~reset) begin //Reset logic
			state <= idle;
			phase_count <= 7'b0;
			clk_out_set <= 1'b0;
			cs <= 1'b0;
			adc <= 14'b0;
			start_reg <= 1'b0;
		end
		else begin 
			start_reg <= start;
			if(start && ~start_reg && state == idle) begin //Idle state
				state <= converting_phase;
				cs <= 1'b1;
				phase_count <= 7'b0;
				clk_out_set <= 1'b0;
				done <= 1'b0;
			end else if(state == converting_phase) begin //Data Conversion Phase, wait 1400ns
				if(phase_count == 7'd70) begin
					state <= d13;
					cs <= 1'b0;
					phase_count <= 7'b0;
					clk_out_set <= 1'b0;
				end else begin
					phase_count <= phase_count + 7'b1;
				end
			end else if(state >= 5'd2 && state <= 5'd15) begin //Data shift out
				clk_out_set <= 1'b1;
				state <= adc_state_t'(state + 5'b1);
				adc <= {adc[12:0],sdo};
			end else if(state == quiet_phase) begin //Quiet Phase
				done <= 1'b1;
				clk_out_set <= 1'b0;
				if(phase_count == 7'd5)
					state <= idle;
				else phase_count <= phase_count + 7'b1;
			end	else begin
				cs <= 1'b0;
				clk_out_set <= 1'b0;
			end
		end
	end
	
endmodule

/*
There is two phases for the SAR adc:
	-Capacitor Charge Phase: Internal capacitor matches external voltage 600ns
	-Data Conversion Phase: ADC sticks data into shift register 1400ns
	
External Controller is in charge of guarenteeing 600ns Cap charge phase
*/
		
	
	
