module p4(
	input[15:0] address,
	input[15:0] storeData,
	input clock,
	input writeReg,
	input [2:0] regAddress,
	input writeEnable,
	input readEnable,
	output reg [15:0] readOutData,
	output reg WriteReg,
	output reg [2:0]RegAddress
	
);

 wire[15:0] ROD;
 /*wire[2:0] RA;
 wire WR;*/
 


 
 SIMPLE_RAM_bb BIGRAM(.address(address) , .clock(clock) , .data(storeData), .rden(readEnable) , .wren(writeEnable) , .q(ROD));
 
 always @(posedge clock) begin 
	WriteReg <= writeReg;
	readOutData <= ROD;
	RegAddress <= regAddress;
 end
 
 
endmodule 