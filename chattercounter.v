module chattercounter(
	input chatterclock,
	input switchin,
	output reg enabled,
	output reg ispressed,
	output reg [7:0] count
);
	
	
	initial begin
		count = 8'b0;
		enabled = 1'b0; 
		ispressed = 1'b0;
	end
	
	// count switch pressed time
	always @(posedge chatterclock) begin
		if ( ~switchin ) begin // if switch is pressed
			count <= count + 1;
		end
		else begin  // if switch is not pressed
			count <= 8'b0; // go back to 0
		end
	end
	
	// if switch is pressed for long
	always @(negedge chatterclock) begin
		if (count == 8'd5) begin
			ispressed <= 1;
		end
		
		if (count == 0) begin
			ispressed <= 0;
		end
	end
	
	// switch between enabled and disabled states
	always @(posedge ispressed) begin
		enabled <= ~enabled;
	end

endmodule
