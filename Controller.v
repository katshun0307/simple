module Controller (
	input clock,
	input execbutton,
	input resetbutton,
	input haltin,
	output clock0, clock1, clock2, clock3, clock4,
	output [4:0] counterout,
	output reg [7:0] runningled,
	output reg [7:0] execled,
	output reg [4:0] clockled,
	output reg [7:0] resetled,
	output resetout,
	output exectrue,
	output [7:0] execchattercount,
	output execispressed );
	
reg [4:0] counter;
reg preparestop;
reg running;

initial begin
	counter <= 5'b0;
	running = 1'b1;
	preparestop <=1'b0;
end

//wire exectrue;
wire resettemp;

chattercounter execchattercounter(.chatterclock(clock), .switchin(execbutton), .enabled(exectrue), .count(chattercount), .ispressed(execispressed));
chattercounter resetchattercounter(.chatterclock(clock), .switchin(~resetbutton), .ispressed(resettemp));


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
	// update running led
	if( running == 1'b1 ) begin
		runningled = 8'b00111010; // o
	end else begin
		runningled = 8'b10001110; // F
	end
	// update exec led
	if ( exectrue == 1'b1) begin
		execled = 8'b01101110; // H
	end else begin
		execled = 8'b10011110; // E
	end
	// show reset button
	if ( resetbutton == 1'b1) begin
		resetled = 8'b00010000; // R
	end else begin
		resetled = 8'b11101110; // hoge
	end
end

// negedge
always @(negedge clock) begin
	// change preparestop
	if (haltin == 1'b1) begin
		preparestop = 1'b1;
	end
end

assign resetout = 1'b0;

// clock control
assign clock0 = (counter == 0) & running & ~exectrue;
assign clock1 = (counter == 3) & running & ~exectrue;
assign clock2 = (counter == 6) & running & ~exectrue;
assign clock3 = (counter == 12) & running & ~exectrue;
assign clock4 = (counter == 24) & running & ~exectrue;
assign counterout = counter;

endmodule
