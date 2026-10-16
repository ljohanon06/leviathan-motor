module forward_transform(
	input clk,
	input reset,
	input [13:0] adc_i1, //14 bit adc input
	input [13:0] adc_i2, //14'h0 -> -Imax, 14'h2000 -> 0, 14'h3fff -> Imax
	input [15:0] cos_mag, //Unsigned 16 bit 
	input cos_sign,
	input [15:0] sin_mag,
	input sin_sign,
	output [17:0] id, //Signed b16.b15b14...
	output [17:0] iq); //Id/Iq should cap at sqrt(3)/2
	
	//Internal Signals
	logic [14:0] i1; //Signed b13.b12b11...
	logic [14:0] i2; //14'h3000 = -Imax, 14'h1000 = Imax
	logic [14:0] i3;
	
	logic [17:0] ia; //Signed b16.b15b14...
	logic [17:0] ib;
	
	current_adder ca (
		.adc_i1(adc_i1),
		.adc_i2(adc_i2),
		.i1(i1),
		.i2(i2),
		.i3(i3));
		
	clarke_transform ct (
		.clk(clk),
		.reset(reset),
		.i1(i1),
		.i2(i2),
		.i3(i3),
		.ia(ia),
		.ib(ib));
		
	park_transform pt (
		.clk(clk),
		.reset(reset),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.ia(ia),
		.ib(ib),
		.id(id),
		.iq(iq));

endmodule
	
	