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