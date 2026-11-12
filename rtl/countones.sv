/*
 * File        : countones.sv
 * Author      : Levi Johanon
 * Description : Mimics the $countones systemcall
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module countones #(
	parameter W1 = 32,
	parameter W2 = 5) (
	input [W1-1:0] in,
	output logic [W2-1:0] ones);
	
	always_comb begin
		ones = '0;
		for(int i = 0; i<W1; i++) begin
			if(in[i])
				ones += 1'b1;
		end
	end
endmodule
