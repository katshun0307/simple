module p4(
	input[15:0] address,
	input[15:0] storeData,
	input clock,
	input writeReg,
	input [2:0] regAddress,
	input writeEnable,
	input readEnable,
	output reg [15:0] readOutData,
	output reg WriteRegp4,
	output reg [2:0]RegAddressp4
	
);

 wire[15:0] ROD;
 /*wire[2:0] RA;
 wire WR;*/
 


 
 SIMPLE_RAM_bb BIGRAM(.address(address) , .clock(clock) , .data(storeData), .rden(readEnable) , .wren(writeEnable) , .q(ROD));
 
 always @(posedge clock) begin 
	WriteRegp4 <= writeReg;
	readOutData <= ROD;
	RegAddressp4 <= regAddress;
 end
 
 
endmodule 