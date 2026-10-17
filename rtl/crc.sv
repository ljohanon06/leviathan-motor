/*
 * File        : crc.sv
 * Author      : Levi Johanon
 * Description : Cyclic redundency checksum algorithm, used for magnetic encoder and fifo output
 *
 * Copyright (c) 2026 Levi Johanon
 * This code is licensed under the MIT License.
 * See the LICENSE file in the project root for full license information.
 */

module crc #(
	BIT_WIDTH = 14,
	CRC_WIDTH = 7,
	logic [CRC_WIDTH-1:0] CRC = 7'b1000011)(
	input logic [BIT_WIDTH+CRC_WIDTH-2:0] in,
	output met_crc,
	output [CRC_WIDTH-2:0] crc_num);
	
	localparam X = BIT_WIDTH+CRC_WIDTH-2; //19
	
	logic [X:0] out;
	assign met_crc = out == '0;
	assign crc_num = out[CRC_WIDTH-2:0];
	genvar i;
	generate
		for(i = 0; i<BIT_WIDTH; i++) begin : gen
			logic [CRC_WIDTH-1:0] xor_out;
			
			if(i == 0) begin
				assign xor_out = in[X:X-CRC_WIDTH+1] ^ (CRC & {CRC_WIDTH{in[X]}});
			end else begin
				assign xor_out = {gen[i-1].xor_out[CRC_WIDTH-2:0],in[BIT_WIDTH-i-1]} ^ (CRC & {CRC_WIDTH{gen[i-1].xor_out[CRC_WIDTH-2]}});
				if(i == BIT_WIDTH-1)
					assign out[CRC_WIDTH-2:0] = xor_out[CRC_WIDTH-2:0];
			end
			assign out[X-i] = xor_out[CRC_WIDTH-1];
		end
	endgenerate
endmodule
	
