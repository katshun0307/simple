module p3(
 input clk,
 input[15:0] alu1 , alu2, 
 input writereg ,
 input [2:0]regaddressIn,
 input[1:0] memWrite,//select write or read
 input [15:0] addressIn,
 input [15:0] storedataIn,
 input [3:0] opcode,
 output reg [15:0] aluOutput,
 output reg writeRegp3,
 output reg [2:0] regAddressp3,
 output reg [15:0] Address , storeData ,
 output reg writeEnable, 
 output reg readEnable
);

 wire v , z , c, s;
 wire aluOut;
 //wire WR;
 /*wire [2:0] RA
 wire [15:0] AD  = address;
 wire [15:0] SD  = storedata;*/
 
 Alu a(.in1(alu1) , .in2(alu2) , .opcode(opcode), .result(aluOut) , .v(v) , .z(z) , .c(c) , .s(s) );

 
 always @(posedge clk) begin
   case (memWrite) //select write or read 
    1:{readEnable , writeEnable } <= 2'b10;
	 2:{readEnable , writeEnable } <= 2'b01;
	 default: {readEnable , writeEnable } <= 2'b00;
  endcase 
 
	aluOutput <= aluOut;
	writeRegp3  <= writereg;
	regAddressp3 <= regaddressIn;
	Address <= addressIn;
	storeData <= storedataIn;
 end



endmodule 