module p4(
	input clock,
	input [15:0] aluOutputIn,
	input writeReg,
	input [2:0] regAddress,
	input[15:0] address,
	input[15:0] storeData,
	input writeEnable,
	input readEnable,
	output [15:0] readOutData,
	output reg WriteRegp4,
	output reg [2:0]RegAddressp4,
	output reg readoutselect,
	output reg [15:0] aluOutData
);

 wire[15:0] ROD;
 /*wire[2:0] RA;
 wire WR;*/
 
 SIMPLE_RAM_bb BIGRAM(.address(address), .clock(clock) , .data(storeData), .rden(readEnable) , .wren(writeEnable) , .q(ROD));
 
always @(posedge clock) begin 
	WriteRegp4 <= writeReg;
	aluOutData <= aluOutputIn;
	RegAddressp4 <= regAddress;
	readoutselect <= readEnable;
end


assign readOutData = ROD;
 
endmodule 