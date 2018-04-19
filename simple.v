module simple(
    input [15:0] in1,
    input [15:0] in2,
    input [3:0] opcode,
    output [15:0] result );

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
	 default: calculate = 16'b0;
	 endcase
end
endfunction

assign result = calculate(opcode, in1, in2);

endmodule
