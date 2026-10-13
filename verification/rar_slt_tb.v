`timescale 1ns/1ps
// Canonical MIPS slt is signed and writes 32'd1 when true.
module rar_slt_tb;
  reg [31:0] a,b;
  wire [31:0] result,branch_pc;
  wire zero;
  wire [4:0] write_reg;
  integer errors=0;
  ALU dut(.ALUresult(result),.ALUop(2'd2),.address(32'h0000002a),
    .readdata1(a),.readdata2(b),.Zero(zero),.ALUsrc(1'b0),
    .branch_PC(branch_pc),.PC(32'd4),.regdst(1'b1),.Rt(5'd2),.Rd(5'd3),
    .writereg(write_reg),.EX_MEM_DATA(32'd0),.MEM_WB_DATA(32'd0),
    .Forward1(2'd0),.Forward2(2'd0));
  initial begin
    a=32'd3;b=32'd7;#2;
    if(result!==32'd1) begin
      $display("FAIL canonical slt 3<7: expected 00000001, got %h",result); errors=errors+1;
    end
    a=32'hffffffff;b=32'd1;#2;
    if(result!==32'd1) begin
      $display("FAIL signed slt -1<1: expected 00000001, got %h",result); errors=errors+1;
    end
    a=32'd1;b=32'hffffffff;#2;
    if(result!==32'd0) begin
      $display("FAIL signed slt 1<-1: expected 00000000, got %h",result); errors=errors+1;
    end
    if(errors) $fatal(1,"rar_slt_tb: %0d assertions failed",errors);
    $display("PASS rar_slt_tb");$finish;
  end
endmodule
