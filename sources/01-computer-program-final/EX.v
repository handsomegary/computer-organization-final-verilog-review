`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:32:40 12/24/2018 
// Design Name: 
// Module Name:    ALUcontrol 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module EX(Read_data1,Read_data2,instruction_Reg,Alu_result,instruction_Alu,Write_data_mem
			,clk,sign_extend,rst,newpc,branch,jump);

input [31:0]newpc;

input [31:0]Read_data1,Read_data2;
input [31:0]instruction_Reg;
input clk,rst;
input [31:0]sign_extend;
output reg signed [31:0]Alu_result;
output reg [31:0]instruction_Alu;
output reg signed [31:0]Write_data_mem;
//output reg [31:0]jumpaddress,branchaddress;

output reg branch,jump;

always @(posedge clk )
begin
    Write_data_mem<=Read_data2;
    instruction_Alu<=instruction_Reg;
    if(rst) begin
      Alu_result<=32'b0;
	   branch<=0;
		end
	else 
	begin
	   if (instruction_Reg==32'd0)
		begin
		   Alu_result<=Alu_result;
			branch<=0;
		end
		
		//rtype
	   else if((instruction_Reg[31:26]==6'd0)//rtype
					&&(instruction_Reg[5:0]==6'b100000))//add
				begin
					Alu_result<=Read_data1+Read_data2;
					branch<=0;
				end
		else if((instruction_Reg[31:26]==6'd0)//rtype
					&&(instruction_Reg[5:0]==6'b100010))//sub
				begin
					Alu_result<=Read_data1-Read_data2;
					branch<=0;
				end
		else if((instruction_Reg[31:26]==6'd0)//rtype
					&&(instruction_Reg[5:0]==6'b100100))//and
				begin
					Alu_result<=Read_data1 & Read_data2;
					branch<=0;
				end
		else if((instruction_Reg[31:26]==6'd0)&&//rtype
				(instruction_Reg[5:0]==6'b100101))//or
		begin
		   Alu_result<=Read_data1 | Read_data2;
			branch<=0;
		end
		
		//itype
		else if((instruction_Reg[31:26]==6'd43)||//sw
					(instruction_Reg[31:26]==6'd35)||//lw
					(instruction_Reg[31:26]==6'd8))//addi
		begin
		   Alu_result<=Read_data1+sign_extend;//address
		   branch<=0;
		end
		
      else if(instruction_Reg[31:26]==6'd4)//beq
			 begin
				   //branchaddress<=newpc+sign_extend;
					if (Read_data1==Read_data2)
					branch<=1;
					else
					branch<=0;
			 end
		else if(instruction_Reg[31:26]==6'd2)//jump
					//jumpaddress<={newpc[31:28],sign_extend[27:0]};
					jump<=1;
					
	 end	 
end





endmodule
