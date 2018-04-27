module ProgramCounter(
	input clock, 

	output reg [15:0] pc_out
	
	
);
reg [15:0] pc_in = 16'b0;
reg [15:0] pc_plussed;

initial begin 
 pc_out = 16'b0;
end

always @(posedge clock) begin
	pc_out <= pc_in;
	pc_plussed <= pc_in + 16'b0000000000000001;
	pc_in <= pc_plussed;
end

//assign pc_inc_out = pc_out + 16'b0000000000000001;

endmodule 