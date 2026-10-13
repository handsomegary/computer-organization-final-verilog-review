`timescale 1ns/1ps
// Exercise the integrated forwarding decision at its pipeline stage inputs.
// force supplies legal independent stage state without changing the ROM/source.
module rar_forwarding_tb;
  reg clk=0;
  integer errors=0;
  CPU dut(clk);
  initial begin
    force dut.write_back=1'b1; force dut.RegWrite=1'b1;
    force dut.ID_EX_Rs=5'd1; force dut.ID_EX_Rt=5'd2;
    force dut.write_reg=5'd2; force dut.WriteReg=5'd1;
    #2;
    if(dut.Forward1!==2'b01 || dut.Forward2!==2'b10) begin
      $display("FAIL separate producers: expected A=01 MEM/WB, B=10 EX/MEM; got A=%b B=%b",dut.Forward1,dut.Forward2);
      errors=errors+1;
    end
    force dut.write_reg=5'd1; force dut.WriteReg=5'd2;
    #2;
    if(dut.Forward1!==2'b10 || dut.Forward2!==2'b01) begin
      $display("FAIL swapped producers: expected A=10 EX/MEM, B=01 MEM/WB; got A=%b B=%b",dut.Forward1,dut.Forward2);
      errors=errors+1;
    end
    force dut.ID_EX_Rt=5'd1; force dut.write_reg=5'd1; force dut.WriteReg=5'd1;
    #2;
    if(dut.Forward1!==2'b10 || dut.Forward2!==2'b10) begin
      $display("FAIL newest producer priority on both operands");errors=errors+1;
    end
    if(errors) $fatal(1,"rar_forwarding_tb: %0d assertions failed",errors);
    $display("PASS rar_forwarding_tb");$finish;
  end
endmodule
