/*
 * File        : current_normalizer.sv
 * Author      : Levi Johanon
 * Description : Submodule of current adder, adds sign bit and extra bit
 *		 of room to prevent later overflow
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module current_normalizer (
	input [13:0] adc_raw,
	output [14:0] adc_norm);
	
	//ADC has -I_max at 0, +I_max at 14'h3FFF, I=0 at 14'h2000
	//bit 13 is worth 0x2000 instead of -0x2000
	
	assign adc_norm = {~adc_raw[13],~adc_raw[13],adc_raw[12:0]};
endmodule
