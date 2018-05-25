module p1(
input clock0,
input pcsrcin,
input signed [15:0] pctargetin,
input clock4,
input reset,
output reg [15:0] operation,
output reg [15:0] pcout
);

wire[15:0] operationData;
reg signed [15:0] PC;

initial begin 
	PC = 16'b0;
end

//read out operation when posedge clock0
operationMemory OM(.address(PC) , .clock(clock0),
		.data(16'b0) , .rden(1) , .wren(0) , .q(operationData) );

//PC update when posedge clock4		
always @(posedge clock4) begin
	if (pcsrcin == 1'b1) begin
		PC = PC + pctargetin + 1;
	end else begin
		PC = PC + 1;
	end
	// reset
	if (reset == 1'b1) begin
		PC <= 16'b0;
	end
end


//write in register when negedge clock0 
always @(negedge clock0) begin
	operation <= operationData;
	pcout <= PC; 
end

endmodule
