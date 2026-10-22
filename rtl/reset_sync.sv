/*
 * File        : reset_sync.sv
 * Author      : Levi Johanon
 * Description : Synchronize reset signal to clocks for deassertion issues
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */
 
 module reset_sync (
 	input clk,
 	input reset,
 	output reset_sync);
 	
 	logic reset_reg;
 	
 	always_ff @(posedge clk or negedge reset) begin
 		if(~reset) begin //Reset instantly applied
 			reset_reg <= 1'b0;
 			reset_sync <= 1'b0;
 		end else begin //Reset lifted aligned with clock edge
 			reset_reg <= 1'b1;
 			reset_sync <= reset_reg;
 		end
 	end
endmodule
