`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:32:13 12/24/2018 
// Design Name: 
// Module Name:    Control 
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
module ID(clk,Read_Reg1,Read_Reg2,Writeregister1,Writedata,instruction,instruction_Reg,
Read_data_mem,Read_data1,Read_data2,sign_extend,
register0,register1,register2,register3,register4,register5,register6,
register7,register8,register9,register10,register11,Write_Reg_Rtype,Write_Reg_lw
);

input clk;
input [4:0]Read_Reg1;
input [4:0]Read_Reg2;
input [4:0]Writeregister1;
input [31:0]Writedata;
input [31:0]instruction;
input [31:0]Read_data_mem;
output reg [31:0]instruction_Reg;
output reg [31:0]sign_extend;
output reg [31:0]Read_data1;
output reg [31:0]Read_data2;
output reg [4:0] Write_Reg_Rtype;
output reg [4:0] Write_Reg_lw;
//output [5:0]ALUcontrol;
input [31:0]register0,register1,register2,register3,register4,register5,register6,register7,register8,register9,register10,register11;
//output reg [5:0]Alu_control;
always @(posedge clk)
begin
    instruction_Reg<=instruction;
    if(instruction==32'd0)
		begin
			//Read_Reg1<=Read_Reg1;
			//Read_Reg2<=Read_Reg2;
			Write_Reg_Rtype<=Write_Reg_Rtype;
			Write_Reg_lw<=Write_Reg_lw;
			Read_data1<=Read_data1;
			Read_data2<=Read_data2;
			//Read_data_mem<=Read_data_mem;
		end
	else if(instruction[31:26]==6'd0)//Rtype
		begin 
			//Read_Reg1<=instruction[25:21];
			//Read_Reg2<=instruction[20:16];
			Write_Reg_Rtype<=instruction[15:11];
			//Alu_control<=instruction[5:0];
			case(instruction[25:21])
				5'b00000:begin Read_data1<=register0;end
				5'b00001:begin Read_data1<=register1;end
				5'b00010:begin Read_data1<=register2;end
				5'b00011:begin Read_data1<=register3;end
				5'b00100:begin Read_data1<=register4;end
				5'b00101:begin Read_data1<=register5;end
				5'b00110:begin Read_data1<=register6;end
				5'b00111:begin Read_data1<=register7;end
				5'b01000:begin Read_data1<=register8;end
				5'b01001:begin Read_data1<=register9;end
				5'b01010:begin Read_data1<=register10;end
				5'b01011:begin Read_data1<=register11;end
			endcase
			case(instruction[20:16])
				5'b00000:begin Read_data2<=register0;end
				5'b00001:begin Read_data2<=register1;end
				5'b00010:begin Read_data2<=register2;end
				5'b00011:begin Read_data2<=register3;end
				5'b00100:begin Read_data2<=register4;end
				5'b00101:begin Read_data2<=register5;end
				5'b00110:begin Read_data2<=register6;end
				5'b00111:begin Read_data2<=register7;end
				5'b01000:begin Read_data2<=register8;end
				5'b01001:begin Read_data2<=register9;end
				5'b01010:begin Read_data2<=register10;end
				5'b01011:begin Read_data2<=register11;end
			endcase
		end
	else if(instruction[31:26]==6'd35    //lw
				||instruction[31:26]==6'd43 //sw
				||instruction[31:26]==6'd4  //beq
				||instruction[31:26]==6'd8 ) //addi
			begin
				//Read_Reg1<=instruction[25:21];
				//Read_Reg2<=instruction[20:16];
				Write_Reg_lw<=Read_data_mem;
				
				if(instruction[31:26]==6'd4)sign_extend<={{14{instruction[15]}},instruction[15:0],2'b00};
				else sign_extend<={{16{instruction[15]}},instruction[15:0]};
				
				case(instruction[25:21])//rs//address
				5'b00000:begin Read_data1<=register0;end
				5'b00001:begin Read_data1<=register1;end
				5'b00010:begin Read_data1<=register2;end
				5'b00011:begin Read_data1<=register3;end
				5'b00100:begin Read_data1<=register4;end
				5'b00101:begin Read_data1<=register5;end
				5'b00110:begin Read_data1<=register6;end
				5'b00111:begin Read_data1<=register7;end
				5'b01000:begin Read_data1<=register8;end
				5'b01001:begin Read_data1<=register9;end
				5'b01010:begin Read_data1<=register10;end
				5'b01011:begin Read_data1<=register11;end
			   endcase

			end
		
	else if(instruction[31:26]==6'd35)    //jump
	      sign_extend<={4'b0000,instruction[25:0],2'b00};
		
		end
		
		






endmodule
