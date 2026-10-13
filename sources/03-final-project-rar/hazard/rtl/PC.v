`timescale 1ns / 1ps


module PC(clk,npc1,pcsel,insout,pcout,
          IF_ID_Write,PC_Write);
input pcsel;
input clk;
input [31:0]npc1;
input IF_ID_Write,PC_Write;

output reg [31:0]insout;
output reg [31:0]pcout = 32'b0;
reg [31:0]pc = -4;
reg [31:0]ins;
reg [31:0]pc4 = 32'b0;//0
reg [31:0]npc = 32'b0;

    always@(pc)
    begin
        case(pc)
     /* 0:ins  = 32'b000000_10001_10011_10010_00000_100010;  //Sub $2 $1 $3  
            4:ins  = 32'b000000_10010_10100_10101_00000_100100;  //And $5 $2 $4
            8:ins  = 32'b000000_10010_10110_10001_00000_100101;  //0r $1 $6 $2
            12:ins = 32'b000000_10010_10010_10011_00000_100000;  //Add $3 $2 $2
            16:ins = 32'b101011_10010_10100_00000_00001_100100;  //Sw $4 64($2)
            20:ins = 32'b00000000000000000000000000000000;*/
            0:ins  = 32'b101011_10001_10010_0000000010000000;// Sw $2 128($1)
            4:ins  = 32'b100011_10001_10011_0000000010000000;// Lw $3 128($1)
            8:ins  = 32'b000000_10001_10011_10101_00000_100000;// Add $5 $1 $3
            12:ins = 32'b000000_10101_10001_10011_00000_100000;// Add $3 $5 $1
            16:ins = 32'b00000000000000000000000000000000;
            
            default:ins=0;
            endcase           
     end
    
  always@(pc) begin
        pc4 = pc + 4;
    end
    always@(*) begin
        if(pcsel == 1)
            npc = npc1;
        else
            npc = pc4;
    end

    always@(posedge clk)begin
        if(IF_ID_Write == 1 && PC_Write == 1) begin
            insout <= ins;
            pcout <= pc4 ;
            pc <= npc;
        end
        else if(IF_ID_Write == 0 && PC_Write == 0) begin
            insout <= insout;
            pcout <= pcout ;
            pc <= pc;
        end
    end
 

  
endmodule

