/*
 * File        : two_to_sign.sv
 * Author      : Levi Johanon
 * Description : Used in cordic_full.sv to normalize cordic output
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module two_to_sign #(N = 16)(
	input [N-1:0] two,
	output sign,
	output logic [N-1:0] magnitude);
	
	assign sign = two[N-1];
	
	always_comb begin
		if(sign)
			magnitude = -two;
		else magnitude = two;
	end
endmodule
