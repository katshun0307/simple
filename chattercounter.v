module chattercounter(
	input chatterclock,
	input switchin,
	output reg ispressedout );
	
	reg [7:0] count;
	
	initial begin
		count = 8'b0;
	end
	
	// count switch pressed time
	always @(posedge chatterclock) begin
		if ( !switchin ) begin // if switch is pressed
			count <= count + 1;
		end
		else begin  // if switch is not pressed
			count <= 8'b0; // go back to 0
		end
	end
	
	// if switch is pressed for long
	always @(posedge chatterclock) begin
		if (count == 8'd30) begin
			ispressedout <= 1;
		end
		
		if (count == 0) begin
			ispressedout <= 0;
		end
	end
	
endmodule