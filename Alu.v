module Alu(
    input [15:0] in1,
    input [15:0] in2,
    input [3:0] opcode,
    output [15:0] result,
	 output v, z, c, s );

wire[16:0] calcAns;
	 
// main function
function [16:0] calculate;
input [3:0] opcodeIn;
input [15:0] in1In;
input [15:0] in2In;
begin
    case (opcodeIn)
    0: calculate = in1 + in2;
    1: calculate =  ~in2 + 16'b0000000000000001 + in1;
    2: calculate = {1'b0 , {in1 & in2}};
    3: calculate = {1'b0 , {in1 | in2}};
	 4: calculate = {1'b0,{in1 ^ in2}};
	 5: calculate = in1 - in2;
	 6: calculate = {1'b0,{in1 & in2}};
	 8: calculate = {1'b0, in1 << in2}; //
	 //9: calculate = {0, in1[15-in2[3:0]:0] , in1[15:15-in2[3:0]+1]};
	 10: calculate = {1'b0, in1 >> in2};//
	 //11: calculate = {0 , {in2{in1[15]}} , in1[15-in2+1:0]};//
	 //: calculate = in1;*/
	 default: calculate = 17'b0;
	 endcase
end
endfunction



assign calcAns = calculate(opcode, in1, in2);

assign result = calcAns[15:0];

assign z = (result == 4'b0000)? 1:0;

// overflow
assign v = (((opcode == 4'b0000) && ((~in1[15] & ~in2[15] & result[3]) || (in1[15] & in2[15] & ~result[3]))) & ((opcode == 4'b0001) && ((in1[15] & ~in2[15] & ~result[3]) || (~in1[15] & in2[15] & result[3]))));

assign c = calcAns[16];
assign s = result[15]? 0:1;

endmodule
