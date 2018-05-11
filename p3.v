module p3(
	input clk,
	input[15:0] alu1 , alu2, 
	input writereg ,
	input[1:0] memWrite,//select write or read
	input [2:0]regaddressIn,
	input [3:0] opcode,
	input [15:0] addressIn,
	input [15:0] storedataIn,
	input isbranch,
	input [2:0] cond,
	input [15:0] pcp3in,
	output reg [15:0] aluOutput,
	output reg writeRegp3,
	output reg [2:0] regAddressp3,
	output reg [15:0] Address , storeData ,
	output reg writeEnable, 
	output reg readEnable,
	// leds
	output reg [7:0] signal1,
	output reg [7:0] signal2,
	output reg [7:0] signal3,
	output reg [7:0] signal4,
	output selector,
	output reg pcsrc,
	output [15:0] pctarget);

 wire v , z , c, s;
 reg vreg, zreg, creg, sreg;
 wire aluOut;
 //wire WR;
 /*wire [2:0] RA
 wire [15:0] AD  = address;
 wire [15:0] SD  = storedata;*/
 
 Alu a(.in1(alu1) , .in2(alu2) , .opcode(opcode), .result(aluOut) , .v(v) , .z(z) , .c(c) , .s(s) );

// function for led 
function [7:0] encode;
input [3:0] a;
case (a)
	0: encode = 8'b11111100;
	1: encode = 8'b01100000;
	2: encode = 8'b11011010;
	3: encode = 8'b11110010;
	4: encode = 8'b01100110;
	5: encode = 8'b10110110;
	6: encode = 8'b10111110;
	7: encode = 8'b11100000;
	8: encode = 8'b11111110;
	9: encode = 8'b11110110;
	10: encode = 8'b11101110;
	11: encode = 8'b00111110;
	12: encode = 8'b00011010;
	13: encode = 8'b01111010;
	14: encode = 8'b10011110;
	15: encode = 8'b10001110;
	default: encode = 8'b00111001;
endcase
endfunction

// branch command
function getpcsrc;
input isbranch;
input [2:0] cond;
if (isbranch == 1) begin
	case (cond)
	0: getpcsrc = zreg;
	1: getpcsrc = sreg ^ vreg;
	2: getpcsrc = (zreg || (sreg ^ vreg));
	3: getpcsrc = ~z;
	4: getpcsrc = 1'b1;
	default: getpcsrc = 1'b0;
	endcase
end else begin
	getpcsrc = 1'b0;
end
endfunction

// function to get pctarget
function [15:0] getpctarget;
input [15:0] storedataIn;
input isbranch;
if (isbranch == 1'b1) begin
	getpctarget = pcp3in + storedataIn;
end else begin
	getpctarget = 1'b0;
end
endfunction

// posedge
always @(posedge clk) begin

case (memWrite) //select write or read 
    1:{readEnable , writeEnable } <= 2'b10;
	 2:{readEnable , writeEnable } <= 2'b01;
	 default: {readEnable , writeEnable } <= 2'b00;
endcase
 
writeRegp3  <= writereg;
regAddressp3 <= regaddressIn;
Address <= addressIn;
storeData <= storedataIn;
pcsrc = getpcsrc(isbranch, cond);

// leds
if (opcode == 4'b1101) begin
	signal1 = encode(alu1[15:12]);
	signal2 = encode(alu1[11:8]);
	signal3 = encode(alu1[7:4]);
	signal4 = encode(alu1[3:0]);
end

end

// negedge
always @(negedge clk) begin
	aluOutput <= aluOut;
	vreg <= v;
	creg <= c;
	zreg <= z;
	sreg <= s;
end


assign selector = 1'b1;
assign pctarget = getpctarget(storedataIn, isbranch);

endmodule 