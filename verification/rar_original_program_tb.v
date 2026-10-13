`timescale 1ns/1ps
// Assert architectural end state for the unmodified active ROM program.
// Original TB only clocks the design and calls finish; this adds checks.
module rar_original_program_tb;
  reg clk=1;
  integer errors=0;
  CPU dut(clk);
  always #15 clk=~clk;
  initial begin
    #990;
    if(dut.block2.s5!==32'd585) begin
      $display("FAIL active ROM s5: expected 585, got %0d",dut.block2.s5);errors=errors+1;
    end
    if(dut.block2.s3!==32'd1152) begin
      $display("FAIL active ROM s3: expected 1152, got %0d",dut.block2.s3);errors=errors+1;
    end
    if(dut.block5.tempaddr0!==32'd695 || dut.block5.memory0!==32'd18) begin
      $display("FAIL active ROM store: expected addr695=18, got addr%0d=%0d",dut.block5.tempaddr0,dut.block5.memory0);errors=errors+1;
    end
    if(errors) $fatal(1,"rar_original_program_tb: %0d assertions failed",errors);
    $display("PASS rar_original_program_tb");$finish;
  end
endmodule
