`timescale 1ns / 1ps

module InstructionMemory(INSTRUCTION, ADDR, RST) ;

	output [31:0]INSTRUCTION ;
	input [31:0]ADDR ;
	input RST ;

	reg [31:0]memory[63:0] ;
	
	//assign INSTRUCTION = memory[ADDR] ; 

//////////////////////////////////////////////////////////////////////////////////////////////////

	wire [31:0] shifted_read_addr;
	assign shifted_read_addr = { 2'b00,ADDR[31:2] };
	assign INSTRUCTION = memory[shifted_read_addr];


	integer k;
	// I-MEM in this case is addressed by word, not by byte
	

	always @(posedge RST)
	begin
	
		for (k=12; k<64; k=k+1) 
		begin  // here Ou changes k=0 to k=16
			memory[k] <= 32'b0;
		end

		memory[0]  <= 32'b001000_00000_01111_0000000000110001; //addi $15 $zero 49
		memory[1]  <= 32'b001000_00000_10000_0000000000100101; //addi $16 $zero 37
		memory[2]  <= 32'b001000_00000_00111_0000000000011000; //addi $7 $zero 24
		memory[3]  <= 32'b001000_00000_01000_0000000000011001; //addi $8 $zero 25
		memory[4]  <= 32'b000000_01111_10000_10001_00000_100010;//sub $17 $15 $16 
		memory[5]  <= 32'b000000_01111_10000_10010_00000_100000;//add $18 $15 $16
		memory[6]  <= 32'b101011_01111_10000_0000000000000100;//sw $16 4($15)
		memory[7]  <= 32'b000000_01000_00111_01001_00000_100100;//and $9 $7 $8
		memory[8]  <= 32'b000100_01111_10000_0000000000000011; //beq $15 $16 Lable
		memory[9]  <= 32'b000000_00111_01000_01011_00000_100101;//or $7 $8 $11
		memory[10] <= 32'b000000_00111_10000_10100_00000_101010;//slt $20 $7 $8
		memory[11] <= 32'b100011_01111_01100_0000000000000100;//lw $12 4($15)

	end

endmodule
