`timescale 1ns/1ps
// rt is not an ALU register source when ALUSrc selects the immediate.
module rar_immediate_tb;
  reg [1:0] forward_b;
  wire [31:0] result,branch_pc;
  wire zero;
  wire [4:0] write_reg;
  integer errors=0;
  ALU dut(.ALUresult(result),.ALUop(2'd0),.address(32'd16),
    .readdata1(32'd100),.readdata2(32'd7),.Zero(zero),.ALUsrc(1'b1),
    .branch_PC(branch_pc),.PC(32'd4),.regdst(1'b0),.Rt(5'd2),.Rd(5'd3),
    .writereg(write_reg),.EX_MEM_DATA(32'd99),.MEM_WB_DATA(32'd88),
    .Forward1(2'd0),.Forward2(forward_b));
  initial begin
    forward_b=2'b00;#2;
    if(result!==32'd116) begin
      $display("FAIL baseline address: expected 116, got %0d",result);errors=errors+1;
    end
    forward_b=2'b10;#2;
    if(result!==32'd116) begin
      $display("FAIL EX/MEM rt match replaced immediate: expected 116, got %0d",result);errors=errors+1;
    end
    forward_b=2'b01;#2;
    if(result!==32'd116) begin
      $display("FAIL MEM/WB rt match replaced immediate: expected 116, got %0d",result);errors=errors+1;
    end
    if(errors) $fatal(1,"rar_immediate_tb: %0d assertions failed",errors);
    $display("PASS rar_immediate_tb");$finish;
  end
endmodule
