module BitShifter(
	input [15:0] innum,
	output [15:0] outnum
);
	assign outnum = innum << 2;

endmodule
