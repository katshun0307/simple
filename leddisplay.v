module leddisplay(
	input clock,
	input [15:0] dipswitchval,
	output reg [7:0] digitcode,
	output reg [3:0] selectors );
	
reg [3:0] counter;

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

always @(posedge clock) begin
	if (counter == 3'b111) begin
		counter = 0;
	end else begin
		counter = counter + 1;
	end
	case (counter)
		0: digitcode = encode(dipswitchval[15:12]);
		2: digitcode = encode(dipswitchval[11:8]);
		4: digitcode = encode(dipswitchval[7:4]);
		6: digitcode = encode(dipswitchval[3:0]);
		default: digitcode = 8'b0;
	endcase
	case (counter)
		1: selectors = 4'b1000;
		3: selectors = 4'b0100;
		5: selectors = 4'b0010;
		7: selectors = 4'b0001;
		default: selectors = 4'b0000;
	endcase
end

endmodule
