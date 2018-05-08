module p2(
	input clockp2, clockp5,
	input [15:0] command, // command
	input [15:0] pc, // value of pc
	input [2:0] writetarget, // where to write register
	input [15:0] writeval, // what to write in register
	input writeflag, // whether to write in register
	output reg [15:0] alu1, alu2,
	output reg writereg,
	output reg [1:0] memwrite,
	output reg [2:0] regaddress,
	output reg [3:0] opcode,
	output reg [15:0] address,
	output reg [15:0] storedata );
	
reg [2:0] alu1address, alu2address;
wire [15:0] alu1val, alu2val;


/////////////////
/// registers ///
/////////////////

reg [15:0] r0, r1, r2, r3, r4, r5, r6, r7;

// initial assignments for testing 
//initial begin
//	r0 = 16'b0;
//	r1 = 16'b1;
//	r2 = 16'b10;
//	r3 = 16'b11;
//	r4 = 16'b100;
//	r5 = 16'b101;
//	r6 = 16'b110;
//	r7 = 16'b111;
//end

// read register value
function [15:0] read;
input [2:0] addressin;
	case (addressin)
	0: read = r0;
	1: read = r1;
	2: read = r2;
	3: read = r3;
	4: read = r4;
	5: read = r5;
	6: read = r6;
	7: read = r7;
	default: read = 16'b0;
	endcase
endfunction


/////////////////
/// functions ///
/////////////////

function [15:0] signext8;
input [7:0] d;
signext8 = {{8{d[7]}} , d[7:0]};
endfunction

function [15:0] signext4;
input [3:0] d;
signext4 = {{12{d[3]}} , d[3:0]};
endfunction

// function to get aluaddress1 and aluaddress2
function [2:0] getaluaddress1;
input [15:0] command;
case (command[15:14])
	3: getaluaddress1 = command[13:11];
	0: getaluaddress1 = command[13:11];
	1: getaluaddress1 = command[13:11];
	default: getaluaddress1 = 3'b000;
endcase
endfunction
	
function [2:0] getaluaddress2;
input [15:0] command;
case (command[15:14])
	3: if (command[7:4] <= 4'd8) begin
			getaluaddress2 = command[10:8];
		end else begin
			getaluaddress2 = command[3:0];
		end
	0: getaluaddress2 = command[10:8];
	1: getaluaddress2 = command[10:8];
	default: getaluaddress2 = 3'b000;
endcase
endfunction


// functions to get writereg
function getwritereg;
input [15:0] command;
	case (command[15:14])
		3: getwritereg = 1'b1;
		0: getwritereg = 1'b1;
		1: getwritereg = 1'b0;
		2: getwritereg = 1'b1;
		default: getwritereg = 1'b0;
	endcase
endfunction

// function to get memwrite
function [1:0] getmemwrite;
input [15:0] command;
	case (command[15:14])
		3: getmemwrite = 2'b00;
		0: getmemwrite = 2'b01;
		1: getmemwrite = 2'b10;
		2: getmemwrite = 2'b01;
		default: getmemwrite = 2'b00;
	endcase
endfunction

// function to get regaddress
function [2:0] getregaddress;
input [15:0] command;
	case (command[15:14])
		3: getregaddress = command[10:8];
		0: getregaddress = command[13:11];
		2: getregaddress = command[10:8];
		default: getregaddress = 2'b00;
	endcase
endfunction


// function to get memory address
function [15:0] getaddress;
input [15:0] alu2;
input [15:0] command;
	case (command[15:14])
	0: getaddress = alu2 + signext8(command[7:0]);
	1: getaddress = alu2 + signext8(command[7:0]);
	2: getaddress = signext8(command[7:0]);
	endcase
endfunction

// function to get storedata
function [15:0] getstoredata;
input [15:0] command;
case(command[15:14])
	1: getstoredata = read(command[13:11]);
	default: getstoredata = 16'b0;
endcase
endfunction


////////////
/// main ///
////////////

always @(posedge clockp2) begin
	// get register things
	writereg = getwritereg(command);
	regaddress = getregaddress(command);
	// get alu1 and 2
	alu1address = getaluaddress1(command);
	alu2address = getaluaddress2(command);
	alu1 = read(alu1address);
	alu2 = read(alu2address);
	opcode = command[7:4];
	// get memory things
	memwrite = getmemwrite(command);
	address = getaddress(alu2val, command);
	storedata = getstoredata(command);		
end

always @(posedge clockp5) begin
if (writeflag == 1'b1) begin // if write to register
	case (writetarget)
		0: r0 <= writeval;
		1: r1 <= writeval;
		2: r2 <= writeval;
		3: r3 <= writeval;
		4: r4 <= writeval;
		5: r5 <= writeval;
		6: r6 <= writeval;
		7: r7 <= writeval;
	endcase
end
end

endmodule
