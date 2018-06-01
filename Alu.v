module Alu(
    input signed [15:0] in1,
    input signed [15:0] in2,
    input [3:0] opcode,
	 input [15:0] dipswitch,
    output signed [15:0] result,
	 output v, z, c, s );

wire[16:0] calcAns;
wire shiftc;
	 
// main function
function [16:0] calculate;
input [3:0] opcode;
input [15:0] in1val;
input [15:0] in2val;
begin
    case (opcode)
    0: calculate = in1val + in2val;
    1: calculate =  in1val - in2val;
    2: calculate = in1val & in2val;
    3: calculate = in1val | in2val;
	 4: calculate = in1val ^ in2val;
	 5: calculate = in2val - in1val; // not write to register
	 6: calculate = in1val; // mov
	 8: calculate = in1val << in2val; // shift left logical
	 9: calculate = slr(in1val, in2val); // shift left rotate
	 10: calculate = in1val >> in2val; // shift right logical 
	 11: calculate = sra(in1val, in2val); // shift right arithmetic
	 12: calculate = dipswitch; // in
	 default: calculate = 17'b0;
	 endcase
end
endfunction

function [16:0] slr;
input [0:15] in1;
input [15:0] in2;
	slr = {in1, in1} >> (16 - in2);
endfunction

function [16:0] sra;
input [15:0] in1, in2;
case (in2)
	1: sra = {in1[15], in1[15:1]};
	2: sra = {{2{in1[15]}}, in1[15:2]};
	3: sra = {{3{in1[15]}}, in1[15:3]};
	4: sra = {{4{in1[15]}}, in1[15:4]};
	5: sra = {{5{in1[15]}}, in1[15:5]};
	6: sra = {{6{in1[15]}}, in1[15:6]};
	7: sra = {{7{in1[15]}}, in1[15:7]};
	default: sra = in1;
endcase
endfunction

function shiftout;
input [3:0] opcode;
input [15:0] in1;
input [15:0] in2;
case(opcode)
	8:case (in2)
		1: shiftout = in1[15];
		2: shiftout = in1[14];
		3: shiftout = in1[13];
		4: shiftout = in1[12];
		5: shiftout = in1[11];
		6: shiftout = in1[10];
		7: shiftout = in1[9];
		default: shiftout = 0;
	  endcase
	10:case (in2)
		1: shiftout = in1[0];
		2: shiftout = in1[1];
		3: shiftout = in1[2];
		4: shiftout = in1[3];
		5: shiftout = in1[4];
		6: shiftout = in1[5];
		7: shiftout = in1[6];
		default: shiftout = 0;
	endcase
	11:case (in2)
		1: shiftout = in1[0];
		2: shiftout = in1[1];
		3: shiftout = in1[2];
		4: shiftout = in1[3];
		5: shiftout = in1[4];
		6: shiftout = in1[5];
		7: shiftout = in1[6];
		default: shiftout = 0;
	endcase
	default shiftout = 0;
endcase 
endfunction

assign calcAns = calculate(opcode, in1, in2);

assign result = calcAns[15:0];

assign shiftc = shiftout(opcode , in1 , in2);

assign z = (result == 16'b0)? 1:0;

// overflow
assign v = (((opcode == 4'b0000) && ((~in1[15] & ~in2[15] & result[15]) || (in1[15] & in2[15] & ~result[15]))) 
					  || (((opcode == 4'b0001)||(opcode == 4'b0101)) && ((in1[15] & ~in2[15] & result[15]) || (~in1[15] & in2[15] & ~result[15]))));

assign c = (calcAns[16] && (opcode == 0 || opcode == 1 || opcode == 5))
						|| ((opcode == 8 || opcode == 10 || opcode == 11) && shiftc);
						
assign s = result[15]? 1:0;

endmodule
