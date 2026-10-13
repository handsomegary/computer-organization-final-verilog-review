`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:06:43 12/28/2018
// Design Name:   MarkLoveGarry
// Module Name:   /home/ise/ISEproject/Final/finaltb.v
// Project Name:  dick
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MarkLoveGarry
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module finaltb;

	// Inputs
	reg [31:0] pc;
	reg clk;
	reg rst;

	// Instantiate the Unit Under Test (UUT)
	MarkLoveGarry uut (
		.pc(pc), 
		.clk(clk), 
		.rst(rst)
	);
		always
    	#10 clk=~clk;
	initial begin
		// Initialize Inputs
		pc = 0;
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100; rst=0; 
        
		// Add stimulus here

	end
      
endmodule

