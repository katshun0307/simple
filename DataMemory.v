module DataMemory(clock , load , address , data , readOutData);
	input clock , load ;
	input[2:0] address;
	input[15:0] data;
	output [15:0] readOutData;
	reg [15:0] readOutData;
	reg [15:0] mem [1023:0];
	
	always @(posedge clock) begin 
		if(load) begin 
		mem[address] <= data;
		readOutData <= mem[address];
		end else
		mem[address] <= data;
	end 
	
	integer i;
	initial begin
	 for(i =0 ; i<1024; i = i+1)
	      mem[i] = 0;
	end

endmodule 
	
