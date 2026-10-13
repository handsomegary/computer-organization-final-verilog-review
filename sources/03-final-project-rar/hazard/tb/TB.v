`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/08 16:57:48
// Design Name: 
// Module Name: TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TB;

reg CLK;

CPU hazard(CLK);
initial begin
CLK = 1;
end
always begin
#15 CLK =~ CLK;
end

initial 
#1000 $finish;

endmodule

