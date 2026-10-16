module clock_div #(
	parameter WIDTH = 8, 
	parameter DIV = 50) (
	input clk,
	input reset,
	output clk_out);
	
	logic [WIDTH-1:0] count;
	
	always_ff @(posedge clk or negedge reset) begin
		if(~reset) begin
			clk_out <= 0;
			count <= 0;
		end 
		else if(count == DIV - 1) begin
			clk_out <= ~clk_out;
			count <= 0;
		end
		else count <= count + 1'b1;
	end
endmodule
			
		
			
	
