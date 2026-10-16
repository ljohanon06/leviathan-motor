`timescale 1ns / 1ps

module crc_tb();

	logic [19:0] in;
	logic met_crc;
	logic [5:0] crc_num;

	crc dut (
		.in(in),
		.met_crc(met_crc),
		.crc_num(crc_num));
	
	//First 10 pass, last 10 fail
	logic [19:0] crc_test_vectors [0:19] = '{
		 20'hFFFD5,
		 20'hA956A,
		 20'h56ABF,
		 20'h3C3D8,
		 20'hC3C0D,
		 20'h00000,
		 20'h8005D,
		 20'h48D38,
		 20'hEAF12,
		 20'h36EA6,
		 20'hFFFD4,
		 20'hA956B,
		 20'h56ABE,
		 20'h3C3D9,
		 20'hC3C0C,
		 20'h00001,
		 20'h8005C,
		 20'h48D39,
		 20'hEAF13,
		 20'h36EA7
	};
	
	initial begin
	/*
		for(int i = 0; i<20; i++) begin
			in = crc_test_vectors[i];
			#10;
			$display("%d %d", i, met_crc);
		end */
		
		for(int i = 0; i<20; i++) begin
			in = {crc_test_vectors[i][19:6],6'b0};
			#10 $display("%h %d %h", in, met_crc, crc_num);
			in = (in[19:6] << 6) + crc_num;
			#10 $display("%h %d %h", in, met_crc, crc_num);
		end
		
		in = 20'hAAAC0;
		#10 $display("%h %d %h", in, met_crc, crc_num);
		in = (in[19:6] << 6) + crc_num;
		#10 $display("%h %d %h", in, met_crc, crc_num);
		
	end

endmodule