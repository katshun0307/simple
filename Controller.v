module Controller (
	input clock,
	input execbutton,
	input haltin,
	output clock0, clock1, clock2, clock3, clock4,
	output [4:0] counterout,
	output reg [7:0] statusled,
	output reg [4:0] clockled );
	
reg [4:0] counter;
reg preparestop;
reg running;

initial begin
	counter <= 5'b0;
	running = 1'b1;
	preparestop <=1'b0;
end

wire exectrue;

chattercounter(.chatterclock(clock), .switchin(execbutton), .exectrue(exectrue));

//posedge
always @(posedge clock) begin
	case(counter)
		0: counter = 1;
		1: counter = 3;
		3: counter = 2;
		2: counter = 6;
		6: counter = 4;
		4: counter = 12;
		12: counter = 8;
		8: counter = 24;
		24: counter = 21;
		21: if (preparestop == 1'b1) begin
				running <= 1'b0;
			end else begin
				counter <= 5'b00000;
			end
		default: counter <= 5'd16;
	endcase
	// update running status led
	if( running == 1'b1 ) begin
		statusled = 8'b11111111; 
	end else begin
		statusled = 8'b10000001; // change to F
	end
end

// negedge
always @(negedge clock) begin
	// change preparestop
	if (haltin == 1'b1) begin
		preparestop = 1'b1;
	end
end

// clock control
assign clock0 = (counter == 0) & running & exectrue;
assign clock1 = (counter == 3) & running & exectrue;
assign clock2 = (counter == 6) & running & exectrue;
assign clock3 = (counter == 12) & running & exectrue;
assign clock4 = (counter == 24) & running & exectrue;
assign counterout = counter;

endmodule
