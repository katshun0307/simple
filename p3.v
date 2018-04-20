module p3(
 input clk,
 input[15:0] alu1 , alu2, 
 input writereg ,
 input [2:0]regaddress,
 input[1:0] memwrite,
 input [15:0] address,
 input [15:0] storedata,
 input [3:0] opcode,
 output reg [15:0] aluOutput,
 output reg writeReg,
 output reg [1:0] memWrite,
 output reg [2:0] regAddress,
 output reg [15:0] Address , storeData
);

 wire v , z , c, s;
 wire aluOut;
 wire WR;
 wire [1:0] MW;
 wire [2:0] RA;
 wire [15:0] AD , SD;
 
 Alu a(.in1(alu1) , .in2(alu2) , .opcode(opcode), .result(aluOut) , .v(v) , .z(z) , .c(c) , .s(s) );
 
 always @(posedge clk) begin
	aluOutput <= aluOut;
	writeReg  <= WR;
   memWrite  <= MW;
	regAddress <= RA;
	Address <= AD;
	storeData <= SD;
 end



endmodule 