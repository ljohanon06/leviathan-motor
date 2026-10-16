module current_normalizer (
	input [13:0] adc_raw,
	output [14:0] adc_norm);
	
	//ADC has -I_max at 0, +I_max at 14'h3FFF, I=0 at 14'h2000
	//bit 13 is worth 0x2000 instead of -0x2000
	
	assign adc_norm = {~adc_raw[13],~adc_raw[13],adc_raw[12:0]};
endmodule