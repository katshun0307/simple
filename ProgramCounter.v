module ProgramCounter(
	input clock, 
	input [15:0] pc_in,
	output [15:0] puc_out,
	output [15:0] pu_inc_out
	
);

reg [15:0] pc_out;

always @(posedge clock) begin
	pc_out <= pc_in;
end

assign pc_inc_out = pc_out + 16'b0000000000000001;

endmodule 