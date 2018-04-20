module p4(
	input address,
	input writeData,
	input clock,
	input[1:0] opcode,
	output readOutData
	
);

 reg writeEnable;
 
 always @(posedge clock) begin 
	if(opcode == 2'b01) begin
		writeEnable <= 0;
	end else if(opcode == 2'b10) begin
		writeEnable <= 1;
	end
	
 end
 
 SIMPLE_RAM_bb BIGRAM(.address(address) , .clock(clock) , .data(writeData), .wren(writeEnable) , .q(readOutData));
 
endmodule 