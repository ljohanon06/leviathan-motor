/*
 * File        : speedometer.sv
 * Author      : Levi Johanon
 * Description : Speedometer using exponential moving average, alpha = 0.25
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module speedometer (
	input clk_100,
	input reset,
	input [3:0] angle_reg,
	output [15:0] speed_hz);
	
	logic [15:0] distance;
	logic [22:0] count;
	
	logic [3:0] past_angle;
	
	always_ff @(posedge clk_100 or negedge reset) begin
		if(~reset) begin
			speed_hz <= 16'b0;
			distance <= 16'b0;
			count <= 23'b0;
			past_angle <= 4'b0;
		end else begin
			count <= count + 23'b1;
			past_angle <= angle_reg;
			if(angle_reg != past_angle)
				distance <= distance + 16'b1;
			
			//Exponential Moving Average
			//Out = 0.75*Old + 0.25*New
			if(count == 23'd6250000)
				speed_hz <= (speed_hz - (speed_hz >> 1)) + (distance >> 1);
		end
	end
endmodule	

/*
Output is rotations times 16
Period is 1/16th of a second (6250000 cycles)
This makes speed_hz unit in hertz exactly
*/
