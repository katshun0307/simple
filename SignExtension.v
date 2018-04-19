module SignExtension(
	input [7:0] innum ,
	output [15:0] outnum
);

	assign outnum = {{8{innum[7]}} , innum[7:0]};
	
endmodule	