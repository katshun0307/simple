module Alu(
    input [15:0] in1,
    input [15:0] in2,
    input [3:0] opcode,
    output [15:0] result,
	 output v, z, c, s );

// main function
function [15:0] calculate;
input [3:0] opcode;
input [15:0] in1;
input [15:0] in2;
begin
    case (opcode)
    0: calculate = in1 + in2;
    1: calculate = in1 - in2;
    8: calculate = in1 & in2;
    9: calculate = in1 | in2;
	 10: calculate = in1 << in2;
	 11: calculate = in1 >> in2;
	 15: calculate = in1;
	 default: calculate = 16'b0;
	 endcase
end
endfunction

assign result = calculate(opcode, in1, in2);

assign z = (result == 4'b0000);

// overflow
assign v = (((opcode == 4'b0000) && ((~in1[15] & ~in2[15] & result[3]) || (in1[15] & in2[15] & ~result[3]))) & ((opcode == 4'b0001) && ((in1[15] & ~in2[15] & ~result[3]) || (~in1[15] & in2[15] & result[3]))));

assign c = 1'b0;
assign s = result[15];

endmodule
