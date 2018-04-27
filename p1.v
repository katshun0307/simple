module p1(
input clk,
output reg [15:0] operation 
);

wire[15:0] operationData;
reg[15:0] PC;

initial begin 
	PC = 16'b0;
end
//ProgramCounter PC(.clock(clk) , .pc_out(operationAddress));


operationMemory OM(.address(PC) , .clock(clk) ,
		.data(16'b0) , .rden(1) , .wren(0) , .q(operationData) );
		
always @(posedge clk) begin
	PC  <= PC + 16'b1;
	operation = operationData;
end		

endmodule 