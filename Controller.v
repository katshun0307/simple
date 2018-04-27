module Controller (
	input clock,
	output clock0, clock1, clock2, clock3, clock4);
	
reg [2:0] counter;
	
initial begin
	counter <= 0;
end

always @(negedge clock) begin
	// update counter
	if (counter <= 3) begin
		counter <= counter+1;
	end else begin
		counter <= 0;
	end
end

// clock control
assign clock0 = clock & (counter == 0);
assign clock1 = clock & (counter == 1);
assign clock2 = clock & (counter == 2);
assign clock3 = clock & (counter == 3);
assign clock4 = clock & (counter == 4);

endmodule
