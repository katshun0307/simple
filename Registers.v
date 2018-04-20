module Registers(
	input clock,
	input [2:0] address,
	input readflag,
	input [15:0] value,
	output reg [15:0] readout );

// the registers
reg [15:0] r0, r1, r2, r3, r4, r5, r6, r7;


// read register value
function [15:0] read;
input [2:0] addressin;
	case (addressin)
	0: read = r0;
	1: read = r1;
	2: read = r2;
	3: read = r3;
	4: read = r4;
	5: read = r5;
	6: read = r6;
	7: read = r7;
	default: read = 16'b0;
	endcase
endfunction


// main
always @(posedge clock) begin
	if (readflag == 1'b1) begin
		readout <= read(address);
	end else begin
		case (address)
		0: r0 <= value;
		1: r1 <= value;
		2: r2 <= value;
		3: r3 <= value;
		4: r4 <= value;
		5: r5 <= value;
		6: r6 <= value;
		7: r7 <= value;
		endcase
	end
end

endmodule
