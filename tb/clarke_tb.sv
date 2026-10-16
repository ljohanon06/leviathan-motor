`timescale 1ns / 1ps

module clarke_tb ();

	logic [13:0] adc_i1;
	logic [13:0] adc_i2;
	logic [14:0] i1;
	logic [14:0] i2;
	logic [14:0] i3;
	logic [17:0] ia;
	logic [17:0] ib;
	logic clk;
	logic reset;
	
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
		
	always #5 clk = ~clk;
		
	initial begin
		$timeformat(-9,0," ns", 8);
		
		clk = 0;
		reset = 1;
		#15 reset = 0;
		#15 reset = 1;
		
		adc_i1 = 14'h2000;
		adc_i2 = 14'h3FFF;
		#20 //2 Clock cycle
		$display("Theta = 0, i1 = %d, i2 = %d, i3 = %d, ia = %d, ib = %d",
				$signed(i1),$signed(i2),$signed(i3),$signed(ia),$signed(ib));
				
		adc_i1 = 14'h0000;
		adc_i2 = 14'h3FFF;
		#20 //2 Clock cycle
		$display("Theta = 60, i1 = %d, i2 = %d, i3 = %d, ia = %d, ib = %d",
				$signed(i1),$signed(i2),$signed(i3),$signed(ia),$signed(ib));
		
		adc_i1 = 14'h0000;
		adc_i2 = 14'h2000;
		#20 //2 Clock cycle
		$display("Theta = 120, i1 = %d, i2 = %d, i3 = %d, ia = %d, ib = %d",
				$signed(i1),$signed(i2),$signed(i3),$signed(ia),$signed(ib));
				
		adc_i1 = 14'h2000;
		adc_i2 = 14'h0000;
		#20 //2 Clock cycle
		$display("Theta = 180, i1 = %d, i2 = %d, i3 = %d, ia = %d, ib = %d",
				$signed(i1),$signed(i2),$signed(i3),$signed(ia),$signed(ib));
				
		adc_i1 = 14'h3FFF;
		adc_i2 = 14'h0000;
		#20 //2 Clock cycle
		$display("Theta = 240, i1 = %d, i2 = %d, i3 = %d, ia = %d, ib = %d",
				$signed(i1),$signed(i2),$signed(i3),$signed(ia),$signed(ib));
				
		adc_i1 = 14'h3FFF;
		adc_i2 = 14'h2000;
		#20 //2 Clock cycle
		$display("Theta = 300, i1 = %d, i2 = %d, i3 = %d, ia = %d, ib = %d",
				$signed(i1),$signed(i2),$signed(i3),$signed(ia),$signed(ib));
				
		adc_i1 = 14'h3000;
		adc_i2 = 14'h3000;
		#20 //2 Clock cycle
		$display("Theta = 300, i1 = %d, i2 = %d, i3 = %d, ia = %d, ib = %d",
				$signed(i1),$signed(i2),$signed(i3),$signed(ia),$signed(ib));
		
		
		
	end
	
	
endmodule
		
	
	

	