/*
 * File        : current_adder.sv
 * Author      : Levi Johanon
 * Description : Takes two ADC inputs and outputs the 3 line currents.
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module current_adder (
	input [13:0] adc_i1,
	input [13:0] adc_i2,
	output logic [14:0] i1,
	output logic [14:0] i2,
	output logic [14:0] i3);
	
	current_normalizer norm1 (
		.adc_raw(adc_i1),
		.adc_norm(i1));
	
	current_normalizer norm2 (
		.adc_raw(adc_i2),
		.adc_norm(i2));
	
	assign i3 = -i1 - i2;
endmodule
	
