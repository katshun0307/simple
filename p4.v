module p4(
	input[15:0] address,
	input[15:0] storeData,
	input clock,
	input[1:0] memWrite,
	input writeReg,
	input [2:0] regAddress,
	output reg [15:0] readOutData,
	output reg WriteReg,
	output reg [2:0]RegAddress
	
);

 reg writeEnable;
 wire[15:0] ROD;
 /*wire[2:0] RA;
 wire WR;*/
 
 if(memWrite == 2'b01) begin
		writeEnable <= 0;
	end else if(opcode == 2'b10) begin
		writeEnable <= 1;
	end
 
 
 SIMPLE_RAM_bb BIGRAM(.address(address) , .clock(clock) , .data(storeData), .wren(writeEnable) , .q(ROD));
 
 always @(posedge clock) begin 
	WriteReg <= writeReg;
	readOutData <= ROD;
	RegAddress <= regAddress;
 end
 
 
endmodule 