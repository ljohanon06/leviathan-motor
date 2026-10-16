/*
There is two phases for the SAR adc:
	-Capacitor Charge Phase: Internal capacitor matches external voltage 600ns
	-Data Conversion Phase: ADC sticks data into shift register 1400ns
	
External Controller is in charge of guarenteeing 600ns Cap charge phase
*/

module adc (
	input clk, //100MHz
	input reset,
	input start,
	input sdo, //pullup, sdi pullup
	output clk_out, //pullup
	output cs, //pulldown
	output logic [13:0] adc,
	output done);
	
	
	typedef enum logic [4:0] {
		idle, converting_phase, d13, d12,
		d11, d10, d9, d8, d7, d6,
		d5, d4, d3, d2, d1, d0, quiet_phase} adc_state_t;
		
	adc_state_t state;
	logic [7:0] phase_count; 
	logic clk_out_set;
	
	assign clk_out = clk & clk_out_set;
	
	always_ff @(posedge clk or negedge reset) begin
		if(~reset) begin //Reset logic
			state <= idle;
			phase_count <= 8'b0;
			clk_out_set <= 1'b0;
			cs <= 1'b0;
			adc <= 14'b0;
		end
		else begin 
			if(start && state == idle) begin //Idle state
				state <= converting_phase;
				cs <= 1'b1;
				phase_count <= 8'b0;
				clk_out_set <= 1'b0;
				done <= 1'b0;
			end else if(state == converting_phase) begin //Data Conversion Phase, wait 1400ns
				if(phase_count == 8'd139) begin
					state <= d13;
					cs <= 1'b0;
					phase_count <= 8'b0;
					clk_out_set <= 1'b1;
				end else begin
					phase_count <= phase_count + 5'b1;
				end
			end else if(state >= 5'd2 && state <= 5'd15) begin //Data shift out
				state <= adc_state_t'(state + 5'b1);
				adc <= {adc[12:0],sdo};
			end else if(state == quiet_phase) begin //Quiet Phase
				done <= 1'b1;
				clk_out_set <= 1'b0;
				if(phase_count == 8'd5)
					state <= idle;
				else phase_count <= phase_count + 8'b1;
			end			
		end
	end
	
endmodule
		
	
	