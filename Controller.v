module Controller (
	input clock,
	input execbutton,
	output clock0, clock1, clock2, clock3, clock4,
	output [3:0] counterout,
	output reg [7:0] statusled,
	output reg [4:0] clockled );
	
reg [3:0] counter;
reg preparestop;
reg running;

initial begin
	counter = 4'b0000;
	running = 1'b0;
end

wire ispressed;
chattercounter(.chatterclock(clock), .switchin(~execbutton), .ispressedout(ispressed));

// loop through clock
always @(negedge clock or posedge ispressed) begin
	if (ispressed == 1) begin
		preparestop <= 1;
	end else begin
	case (counter)
		9: if (preparestop == 1) begin //switch status
			preparestop <= 0;
			running = ~running;
			end else begin  // increment
				counter = 0;
			end
		default: counter = counter + 4'b1; // increment
	endcase
	if (running == 1) begin
		statusled = 8'b10011110;
	end else begin
		statusled = 8'b10110110;
	end
	end
	
	// led clock
	case (counter)
	0: clockled = 4'b10000;
	1: clockled = 4'b01000;
	2: clockled = 4'b00100;
	3: clockled = 4'b00010;
	4: clockled = 4'b00001;
	endcase
end

// clock control
assign clock0 = (counter == 0) & running;
assign clock1 = (counter == 2) & running;
assign clock2 = (counter == 4) & running;
assign clock3 = (counter == 6) & running;
assign clock4 = (counter == 8) & running;
assign counterout = counter;

endmodule
