module p2(
	input clockp2,
	input [15:0] command, // command
	input [15:0] pc, // value of pc
	input [2:0] writetarget, // where to write register
	input [15:0] readoutwriteval, 
	input writeflag, // whether to write in register
	input [15:0] aluwriteval,
	input readoutSelect,
	input clockp5,
	input reset,
	output reg [15:0] alu1, alu2,
	output reg writereg,
	output reg [1:0] memwrite,
	output reg [2:0] regaddress,
	output reg [3:0] opcode,
	output reg [15:0] address,
	output reg [15:0] storedata,
	output reg isbranchout,
	output reg [2:0] condout,
	output reg [15:0] pcp2out,
	output reg haltout,
	output reg[15:0] regtest1,
	output reg[15:0] regtest2,
	output reg[15:0] regtest3 );
	
reg [2:0] alu1address, alu2address;
wire [15:0] alu1val, alu2val;
reg [15:0] writevalreg;


/////////////////
/// registers ///
/////////////////

reg [15:0] r0, r1, r2, r3, r4, r5, r6, r7;

// initial assignments for testing 
initial begin
	haltout <= 1'b0;
end

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
	2: getaluaddress1 = command[10:8]; // math immidiate
	default: getaluaddress1 = 3'b000;
endcase
endfunction
	
function [2:0] getaluaddress2;
input [15:0] command;
case (command[15:14])
	3: getaluaddress2 = command[10:8];
	0: getaluaddress2 = command[10:8];
	1: getaluaddress2 = command[10:8];
	default: getaluaddress2 = 3'b000;
endcase
endfunction

function [3:0] getopcode;
input [15:0] command;
case (command[15:14])
	2: case (command[13:11])
			1: getopcode = 4'b0000; // addi
			2: getopcode = 4'b0001; // subi
			3: getopcode = 4'b0101; // cmpi
			default: getopcode = command[7:4];
		endcase
	default: getopcode = command[7:4];
endcase
endfunction

// functions to get writereg
function getwritereg;
input [15:0] command;
	case (command[15:14])
		3: case (command[7:4])
				5: getwritereg = 1'b0; // cmp 
				13: getwritereg= 1'b0; // out
				14: getwritereg = 1'b0; // hlt
				default: getwritereg = 1'b1; // other arithmetic instructions 
			endcase
		0: getwritereg = 1'b1;
		1: getwritereg = 1'b0;
		2: case (command[13:11])
				1: getwritereg = 1'b1; // addi
				2: getwritereg = 1'b1; // subi
				3: getwritereg = 1'b0; // cmpi
				default: getwritereg = 1'b0;
			endcase
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
		2: getmemwrite = 2'b00; // changed for math immidiate
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
		default: getregaddress = 3'b000;
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
	2: getstoredata = signext8(command[7:0]);
	default: getstoredata = 16'b0;
endcase
endfunction

// function for branches
function getisbranch;
input [15:0] command;
case (command[15:14])
	2: if ((command[13:11] == 3'b100) || (command[13:11] == 3'b111)) begin
			getisbranch = 1;
		end else begin
			getisbranch = 0;
		end
	default: getisbranch = 0;
endcase
endfunction

function [2:0] getcond;
input [15:0] command;
case (command[13:11]) 
	7: getcond = command[10:8];
	default: getcond = command[13:11];
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
	opcode = getopcode(command);
	// command[7:4];
	// get memory things
	memwrite = getmemwrite(command);
	address = getaddress(alu2val, command);
	storedata = getstoredata(command);
	// branch commands
	condout = getcond(command);
	isbranchout = getisbranch(command);
	pcp2out = pc;
	// load immidiate
	if (command[15:11] == 5'b10000) begin
		isbranchout <= 1'b0;
		writereg <= 1'b1;
		regaddress <= command[10:8];
		opcode <= 4'b0110;
		memwrite <= 2'b00;
	end
	//	nop command
	if (command == 16'b0) begin
		writereg <= 1'b0;
		memwrite <= 2'b0;
	end
	// halt
	if (command[15:14] == 2'b11 && command[7:4] == 4'b1111) begin
		haltout = 1'b1;
	end
	// for debug
	regtest1 = r1;
	regtest2 = r2;
	regtest3 = r3;
end

// read from register
always @(negedge clockp2) begin
	// load immidiate
	if (command[15:11] == 5'b10000) begin
		alu1 <= signext8(command[7:0]);
	end else begin
		alu1 = read(alu1address);
	end
	// math immidiate
	if (command[15:14] == 2'b10) begin
		alu2 <= signext8(command[7:0]);
	end else begin
		alu2 = read(alu2address);
	end
end

// select what to write
always @(posedge clockp5) begin
	if (readoutSelect == 1'b1) begin
		writevalreg = readoutwriteval;
	end else begin
		writevalreg = aluwriteval;
	end
end


// write to register or reset register values 
always @(negedge clockp5) begin
if (writeflag == 1'b1) begin // if write to register
	case (writetarget)
		0: r0 <= writevalreg;
		1: r1 <= writevalreg;
		2: r2 <= writevalreg;
		3: r3 <= writevalreg;
		4: r4 <= writevalreg;
		5: r5 <= writevalreg;
		6: r6 <= writevalreg;
		7: r7 <= writevalreg;
	endcase
end

//if(reset) begin
//	r0 <= 0;
//	r1 <= 0;
//	r2 <= 0;
//	r3 <= 0;
//	r4 <= 0;
//	r5 <= 0;
//	r6 <= 0;
//	r7 <= 0;
//end
end

endmodule
