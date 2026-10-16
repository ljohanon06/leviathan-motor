`timescale 1ns / 1ps

module park_tb();

	logic clk;
	logic reset;
	logic valid;
	logic [13:0] angle_in;
	logic [15:0] cos_mag; 
	logic [15:0] sin_mag;
	logic cos_sign;
	logic sin_sign;
	logic done;
	logic ready;
	
	logic [13:0] adc_i1;
	logic [13:0] adc_i2;
	logic [14:0] i1;
	logic [14:0] i2;
	logic [14:0] i3;
	logic [17:0] ia;
	logic [17:0] ib;
	
	logic [17:0] id;
	logic [17:0] iq;
	

	cordic_full dut_cf (
		.clk(clk),
		.reset(reset),
		.valid(valid),
		.angle_in(angle_in),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.done(done),
		.ready(ready));

	
	current_adder dut_ca (
		.adc_i1(adc_i1),
		.adc_i2(adc_i2),
		.i1(i1),
		.i2(i2),
		.i3(i3));
		
	clarke_transform dut_ct (
		.clk(clk),
		.reset(reset),
		.i1(i1),
		.i2(i2),
		.i3(i3),
		.ia(ia),
		.ib(ib));
		
	park_transform dut_pt (
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
		
	logic [13:0] ang [19:0] = '{0, 22, 682, 1024, 841, 1365, 2048, 2730, 3413, 4073, 4096, 4118, 4778, 5461, 6121, 6144, 6166, 6826, 7509, 8169};
	logic [13:0] adc_in [12:0] [1:0] = '{'{8192,0},'{16383, 0},'{16383, 4096},'{16383, 6144},'{16383, 8192},'{0, 8192},'{0, 10240},'{0, 12288},'{0, 16383},'{8192, 8192},'{12288, 12288},'{7372, 13926},'{10649, 4915}};
	
	always #5 clk = ~clk;
	
	initial begin
		clk = 0;
		#10 reset = 0;		
		#10 reset = 1;
		
		//Test different angle inputs
		$display("Different Angles");
		for(int i = 19; i >= 0; i--) begin
			angle_in = ang[i];
			adc_i1 = adc_in[12][1];
			adc_i2 = adc_in[12][0];
			valid = 1;
			#10 valid = 0;
			#140
			$display("%d %d %d %d %d", ang[i]*360/(2**13),adc_i1,adc_i2,$signed(id),$signed(iq));
		end
		
		//Test different adc inputs
		$display("Different ADC");
		for(int i = 12; i >= 0; i--) begin
			angle_in = ang[19];
			adc_i1 = adc_in[i][1];
			adc_i2 = adc_in[i][0];
			valid = 1;
			#10 valid = 0;
			#140
			$display("%d %d %d %d %d", ang[19],adc_i1,adc_i2,$signed(id),$signed(iq));
		end
	end

endmodule